module align_ecc_1rw (write, wr_adr, din, read, rd_adr, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
	              mem_read, mem_write, mem_addr, mem_bw, mem_din, mem_dout, clk, rst);

  parameter WIDTH = 32;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ENADEC = 0;
  parameter ECCWDTH = 7;
  parameter NUMADDR = 1024;
  parameter BITADDR = 10;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter NUMWRDS = 4;
  parameter BITWRDS = 2;
  parameter BITPADR = 10;
  parameter SRAM_DELAY = 2;
  parameter FLOPGEN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;

  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENADEC ? 2*WIDTH+ECCWDTH : WIDTH;

  input write;
  input [BITADDR-1:0] wr_adr;
  input [WIDTH-1:0] din;
  input read;
  input [BITADDR-1:0] rd_adr;
  output [WIDTH-1:0] rd_dout;
  output             rd_fwrd;
  output             rd_serr;
  output             rd_derr;
  output [BITPADR-1:0] rd_padr;

  output mem_read;
  output mem_write;
  output [BITSROW-1:0] mem_addr;
  output [NUMWRDS*MEMWDTH-1:0] mem_bw;
  output [NUMWRDS*MEMWDTH-1:0] mem_din;
  input [NUMWRDS*MEMWDTH-1:0] mem_dout;

  input clk;
  input rst;

  wire write_wire;
  wire [BITADDR-1:0] wr_adr_wire;
  wire [WIDTH-1:0] din_wire;
  wire read_wire;
  wire [BITADDR-1:0] rd_adr_wire;
  generate if (FLOPGEN) begin: flpg_loop
    reg write_reg;
    reg [BITADDR-1:0] wr_adr_reg;
    reg [WIDTH-1:0] din_reg;
    always @(posedge clk)
      if (rst)
        write_reg <= 1'b0;
      else if (write) begin
        write_reg <= 1'b1;
        wr_adr_reg <= wr_adr;
        din_reg <= din;
      end else if (write_reg && !read)
        write_reg <= 1'b0;

    assign write_wire = write_reg;
    assign wr_adr_wire = wr_adr_reg;
    assign din_wire = din_reg;
    assign read_wire = read;
    assign rd_adr_wire = rd_adr;
  end else begin: noflpi_loop
    assign write_wire = write;
    assign wr_adr_wire = wr_adr;
    assign din_wire = din;
    assign read_wire = read;
    assign rd_adr_wire = rd_adr;
  end
  endgenerate

  wire [BITWRDS-1:0] wr_wadr;
  wire [BITSROW-1:0] wr_radr;
  wire [BITWRDS-1:0] rd_wadr;
  wire [BITSROW-1:0] rd_radr;
  generate if (BITWRDS>0) begin: np2_loop
    np2_addr #(
      .NUMADDR (NUMADDR), .BITADDR (BITADDR),
      .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
      .NUMVROW (NUMSROW), .BITVROW (BITSROW))
      wr_adr_inst (.vbadr(wr_wadr), .vradr(wr_radr), .vaddr(wr_adr_wire));
    np2_addr #(
      .NUMADDR (NUMADDR), .BITADDR (BITADDR),
      .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
      .NUMVROW (NUMSROW), .BITVROW (BITSROW))
      rd_adr_inst (.vbadr(rd_wadr), .vradr(rd_radr), .vaddr(rd_adr_wire));
  end else begin: no_np2_loop
    assign wr_wadr = 0;
    assign wr_radr = wr_adr_wire;
    assign rd_wadr = 0;
    assign rd_radr = rd_adr_wire;
  end
  endgenerate

  wire [MEMWDTH-1:0] din_tmp;
  generate if (ENAPAR) begin: pg_loop
    assign din_tmp = {^din_wire,din_wire};
  end else if (ENAECC) begin: eg_loop
    wire [ECCWDTH-1:0] din_ecc_a;
    ecc_calc #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
      ecc_calc_inst (.din(din_wire), .eccout(din_ecc_a));
    assign din_tmp = {din_ecc_a,din_wire};
  end else if (ENADEC) begin: dg_loop
    wire [ECCWDTH-1:0] din_ecc_b;
    ecc_calc #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
      ecc_calc_inst (.din(din_wire), .eccout(din_ecc_b));
    assign din_tmp = {din_wire,din_ecc_b,din_wire};
  end else begin: ng_loop
    assign din_tmp = din_wire;
  end
  endgenerate

  wire mem_read_tmp = read_wire;
  wire mem_write_tmp = write_wire && !read_wire;
  wire [BITSROW-1:0] mem_addr_tmp = read_wire ? rd_radr : wr_radr;
  wire [NUMWRDS*MEMWDTH-1:0] mem_bw_tmp = {MEMWDTH{1'b1}} << (wr_wadr*MEMWDTH);
  wire [NUMWRDS*MEMWDTH-1:0] mem_din_tmp = din_tmp << (wr_wadr*MEMWDTH);

  generate if (FLOPCMD) begin: flpc_loop
    reg mem_read_reg;
    reg mem_write_reg;
    reg [BITSROW-1:0] mem_addr_reg;
    reg [NUMWRDS*MEMWDTH-1:0] mem_bw_reg;
    reg [NUMWRDS*MEMWDTH-1:0] mem_din_reg;
    always @(posedge clk) begin
      mem_read_reg <= mem_read_tmp;
      mem_write_reg <= mem_write_tmp;
      mem_addr_reg <= mem_addr_tmp;
      mem_bw_reg <= mem_bw_tmp;
      mem_din_reg <= mem_din_tmp;
    end

    assign mem_read = mem_read_reg;
    assign mem_write = mem_write_reg;
    assign mem_addr = mem_addr_reg;
    assign mem_bw = mem_bw_reg;
    assign mem_din = mem_din_reg;
  end else begin: nflpc_loop
    assign mem_read = mem_read_tmp;
    assign mem_write = mem_write_tmp;
    assign mem_addr = mem_addr_tmp;
    assign mem_bw = mem_bw_tmp;
    assign mem_din = mem_din_tmp;
  end
  endgenerate

  wire forward_read = FLOPGEN && read_wire && write_wire && (rd_adr_wire == wr_adr_wire);

  reg [BITWRDS-1:0] rd_wadr_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg [BITSROW-1:0] rd_radr_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg               rd_fwd_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg [WIDTH-1:0]   rd_dat_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg               rd_vld_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  integer rd_int;
  always @(posedge clk)
    for (rd_int=0; rd_int<SRAM_DELAY+FLOPCMD+FLOPMEM; rd_int=rd_int+1)
      if (rd_int>0) begin
	rd_wadr_reg[rd_int] <= rd_wadr_reg[rd_int-1];
        rd_radr_reg[rd_int] <= rd_radr_reg[rd_int-1];
        rd_fwd_reg[rd_int] <= rd_fwd_reg[rd_int-1];
        rd_dat_reg[rd_int] <= rd_dat_reg[rd_int-1];
        rd_vld_reg[rd_int] <= rd_vld_reg[rd_int-1];
      end else begin
	rd_wadr_reg[rd_int] <= rd_wadr;
	rd_radr_reg[rd_int] <= rd_radr;
        rd_fwd_reg[rd_int] <= forward_read;
        rd_dat_reg[rd_int] <= din_wire;
        rd_vld_reg[rd_int] <= read_wire;
      end

  wire [NUMWRDS*MEMWDTH-1:0] mem_dout_tmp;
  generate if (FLOPMEM) begin: flpm_loop
    reg [NUMWRDS*MEMWDTH-1:0] mem_dout_reg;
    always @(posedge clk)
      mem_dout_reg <= mem_dout;
    assign mem_dout_tmp = mem_dout_reg; 
  end else begin: noflpm_loop
    assign mem_dout_tmp = mem_dout;
  end
  endgenerate

  reg [MEMWDTH-1:0] rd_dout_wire;
  integer bit_int;
  always_comb
    for (bit_int=0; bit_int<MEMWDTH; bit_int=bit_int+1)
      rd_dout_wire[bit_int] = mem_dout_tmp[rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]*MEMWDTH+bit_int];

  wire [WIDTH-1:0] rd_dout_tmp;
  wire rd_fwrd_tmp;
  wire rd_serr_tmp;
  wire rd_derr_tmp;
  wire [BITPADR-1:0] rd_padr_tmp;
  generate if (ENAPAR) begin: pc_loop
    assign rd_dout_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] ? rd_dat_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] : rd_dout_wire;
    assign rd_fwrd_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_serr_tmp = ^rd_dout_wire && rd_vld_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_derr_tmp = 1'b0;
    assign rd_padr_tmp = (NUMWRDS>1) ? {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]} :
                                       rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  end else if (ENAECC) begin: ec_loop
    wire [WIDTH-1:0] rd_data_wire_e = rd_dout_wire;
    wire [ECCWDTH-1:0] rd_ecc_wire_e = rd_dout_wire >> WIDTH;
    wire [WIDTH-1:0] rd_corr_data_wire_e;
    wire rd_sec_err_wire_e;
    wire rd_ded_err_wire_e;

    ecc_check   #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
        ecc_check_inst (.din(rd_data_wire_e), .eccin(rd_ecc_wire_e),
                        .dout(rd_corr_data_wire_e), .sec_err(rd_sec_err_wire_e), .ded_err(rd_ded_err_wire_e),
                        .clk(clk), .rst(rst));

    assign rd_dout_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] ? rd_dat_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] : rd_corr_data_wire_e;
    assign rd_fwrd_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_serr_tmp = rd_sec_err_wire_e && rd_vld_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_derr_tmp = rd_ded_err_wire_e && rd_vld_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_padr_tmp = (NUMWRDS>1) ? {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]} :
                                       rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  end else if (ENADEC) begin: dc_loop
    wire [WIDTH-1:0] rd_data_wire_d = rd_dout_wire;
    wire [ECCWDTH-1:0] rd_ecc_wire_d = rd_dout_wire >> WIDTH;
    wire [WIDTH-1:0] rd_dup_data_wire = rd_dout_wire >> (WIDTH+ECCWDTH);
    wire [WIDTH-1:0] rd_corr_data_wire_d;
    wire rd_sec_err_wire_d;
    wire rd_ded_err_wire_d;
    wire rd_dup_sec_err_wire_d;
    wire rd_dup_ded_err_wire_d;

    ecc_check #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
        ecc_check_inst (.din(rd_data_wire_d), .eccin(rd_ecc_wire_d),
                        .dout(rd_corr_data_wire_d), .sec_err(rd_sec_err_wire_d), .ded_err(rd_ded_err_wire_d),
                        .clk(clk), .rst(rst));

    ecc_check #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
        ecc_dup_check_inst (.din(rd_dup_data_wire), .eccin(rd_ecc_wire_d),
                            .dout(), .sec_err(rd_dup_sec_err_wire_d), .ded_err(rd_dup_ded_err_wire_d),
                            .clk(clk), .rst(rst));

    assign rd_dout_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] ? rd_dat_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] :
                                                                    rd_ded_err_wire_d ? rd_dup_data_wire : rd_corr_data_wire_d;
    assign rd_fwrd_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_serr_tmp = (((rd_data_wire_d == rd_corr_data_wire_d) && rd_sec_err_wire_d && rd_dup_sec_err_wire_d) ||
                          ((rd_sec_err_wire_d ^ rd_dup_sec_err_wire_d) && !rd_ded_err_wire_d && !rd_dup_ded_err_wire_d)) && rd_vld_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_derr_tmp = (((rd_data_wire_d != rd_corr_data_wire_d) && rd_sec_err_wire_d && rd_dup_sec_err_wire_d) ||
                          rd_ded_err_wire_d || rd_dup_ded_err_wire_d) && rd_vld_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_padr_tmp = (NUMWRDS>1) ? {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]} :
                                       rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  end else begin: nc_loop
    assign rd_dout_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] ? rd_dat_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] : rd_dout_wire;
    assign rd_fwrd_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_serr_tmp = 1'b0;
    assign rd_derr_tmp = 1'b0;
    assign rd_padr_tmp = (NUMWRDS>1) ? {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]} :
                                       rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  end
  endgenerate

  generate if (FLOPOUT) begin: flpo_loop
    reg [WIDTH-1:0] rd_dout_reg;
    reg rd_fwrd_reg;
    reg rd_serr_reg;
    reg rd_derr_reg;
    reg [BITPADR-1:0] rd_padr_reg;
    always @(posedge clk) begin
      rd_dout_reg <= rd_dout_tmp;
      rd_fwrd_reg <= rd_fwrd_tmp;
      rd_serr_reg <= rd_serr_tmp;
      rd_derr_reg <= rd_derr_tmp;
      rd_padr_reg <= rd_padr_tmp;
    end
    assign rd_dout = rd_dout_reg;
    assign rd_fwrd = rd_fwrd_reg;
    assign rd_serr = rd_serr_reg;
    assign rd_derr = rd_derr_reg;
    assign rd_padr = rd_padr_reg;
  end else begin: noflpo_loop
    assign rd_dout = rd_dout_tmp;
    assign rd_fwrd = rd_fwrd_tmp;
    assign rd_serr = rd_serr_tmp;
    assign rd_derr = rd_derr_tmp;
    assign rd_padr = rd_padr_tmp;
  end
  endgenerate

endmodule
