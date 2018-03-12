module align_ecc_1r1w_a621 (write, wr_adr, din, read, rd_adr, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
	                    mem_write, mem_wr_adr, mem_bw, mem_din, mem_read, mem_rd_adr, mem_rd_dout, mem_rd_fwrd,  mem_rd_padr,
                            clk, rst);

  parameter WIDTH = 32;
  parameter ENAPSDO = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ENADEC = 0;
  parameter ENAHEC = 0;
  parameter ENAQEC = 0;
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
  parameter ENAPADR = 0;

  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENADEC ? 2*WIDTH+ECCWDTH : ENAHEC ? WIDTH+2*ECCWDTH : ENAQEC ? WIDTH+4*ECCWDTH : WIDTH;

  input write;
  input [BITADDR-1:0] wr_adr;
  input [WIDTH-1:0] din;

  input read;
  input [BITADDR-1:0] rd_adr;
  output [WIDTH-1:0] rd_dout;
  output rd_vld;
  output rd_fwrd;
  output rd_serr;
  output rd_derr;
  output [BITPADR-1:0] rd_padr;

  output mem_write;
  output [BITSROW-1:0] mem_wr_adr;
  output [NUMWRDS*MEMWDTH-1:0] mem_bw;
  output [NUMWRDS*MEMWDTH-1:0] mem_din;
  output mem_read;
  output [BITSROW-1:0] mem_rd_adr;
  input [NUMWRDS*MEMWDTH-1:0] mem_rd_dout;
  input mem_rd_fwrd;
  input [(BITPADR-BITWRDS)-1:0] mem_rd_padr;

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
    always @(posedge clk) begin
      write_reg <= write;
      wr_adr_reg <= wr_adr;
      din_reg <= din;
    end
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
    wire [ECCWDTH-1:0] din_ecc;
    ecc_calc #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
      ecc_calc_inst (.din(din_wire), .eccout(din_ecc));
    assign din_tmp = {din_ecc,din_wire};
  end else if (ENADEC) begin: dg_loop
    wire [ECCWDTH-1:0] din_ecc;
    ecc_calc #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
      ecc_calc_inst (.din(din_wire), .eccout(din_ecc));
    assign din_tmp = {din_wire,din_ecc,din_wire};
  end else if (ENAHEC) begin: hg_loop
    wire [(WIDTH>>1)-1:0] din_wire1 = din_wire;
    wire [ECCWDTH-1:0] din_ecc1;
    ecc_calc #(.ECCDWIDTH(WIDTH>>1), .ECCWIDTH(ECCWDTH))
      ecc_calc_1_inst (.din(din_wire1), .eccout(din_ecc1));
    wire [(WIDTH>>1)-1:0] din_wire2 = din_wire >> (WIDTH>>1);
    wire [ECCWDTH-1:0] din_ecc2;
    ecc_calc #(.ECCDWIDTH(WIDTH>>1), .ECCWIDTH(ECCWDTH))
      ecc_calc_2_inst (.din(din_wire2), .eccout(din_ecc2));
    assign din_tmp = {din_ecc2,din_wire2,din_ecc1,din_wire1};
  end else if (ENAQEC) begin: qg_loop
    wire [(WIDTH>>2)-1:0] din_wire1 = din_wire;
    wire [ECCWDTH-1:0] din_ecc1;
    ecc_calc #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH))
      ecc_calc_1_inst (.din(din_wire1), .eccout(din_ecc1));
    wire [(WIDTH>>2)-1:0] din_wire2 = din_wire >> (WIDTH>>2);
    wire [ECCWDTH-1:0] din_ecc2;
    ecc_calc #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH))
      ecc_calc_2_inst (.din(din_wire2), .eccout(din_ecc2));
    wire [(WIDTH>>2)-1:0] din_wire3 = din_wire >> 2*(WIDTH>>2);
    wire [ECCWDTH-1:0] din_ecc3;
    ecc_calc #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH))
      ecc_calc_3_inst (.din(din_wire3), .eccout(din_ecc3));
    wire [(WIDTH>>2)-1:0] din_wire4 = din_wire >> 3*(WIDTH>>2);
    wire [ECCWDTH-1:0] din_ecc4;
    ecc_calc #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH))
      ecc_calc_4_inst (.din(din_wire4), .eccout(din_ecc4));
    assign din_tmp = {din_ecc4,din_wire4,din_ecc3,din_wire3,din_ecc2,din_wire2,din_ecc1,din_wire1};
  end else begin: ng_loop
    assign din_tmp = din_wire;
  end
  endgenerate

  wire forward_read = FLOPGEN && read_wire && write_wire && (rd_adr_wire == wr_adr_wire);
  wire mem_write_tmp = write_wire;
  wire [BITSROW-1:0] mem_wr_adr_tmp = wr_radr;
  wire [NUMWRDS*MEMWDTH-1:0] mem_bw_tmp = {MEMWDTH{1'b1}} << (wr_wadr*MEMWDTH);
  wire [NUMWRDS*MEMWDTH-1:0] mem_din_tmp = din_tmp << (wr_wadr*MEMWDTH);
  wire mem_read_tmp = read_wire && !(ENAPSDO && forward_read);
  wire [BITSROW-1:0] mem_rd_adr_tmp = rd_radr;

  generate if (FLOPCMD) begin: flpc_loop
    reg mem_write_reg;
    reg [BITSROW-1:0] mem_wr_adr_reg;
    reg [NUMWRDS*MEMWDTH-1:0] mem_bw_reg;
    reg [NUMWRDS*MEMWDTH-1:0] mem_din_reg;
    reg mem_read_reg;
    reg [BITSROW-1:0] mem_rd_adr_reg;
    always @(posedge clk) begin
      mem_write_reg <= mem_write_tmp;
      mem_wr_adr_reg <= mem_wr_adr_tmp;
      mem_bw_reg <= mem_bw_tmp;
      mem_din_reg <= mem_din_tmp;
      mem_read_reg <= mem_read_tmp;
      mem_rd_adr_reg <= mem_rd_adr_tmp;
    end
    
    assign mem_write = mem_write_reg;
    assign mem_wr_adr = mem_wr_adr_reg;
    assign mem_bw = mem_bw_reg;
    assign mem_din = mem_din_reg;
    assign mem_read = mem_read_reg;
    assign mem_rd_adr = mem_rd_adr_reg;
  end else begin: nflpc_loop
    assign mem_write = mem_write_tmp;
    assign mem_wr_adr = mem_wr_adr_tmp;
    assign mem_bw = mem_bw_tmp;
    assign mem_din = mem_din_tmp;
    assign mem_read = mem_read_tmp;
    assign mem_rd_adr = mem_rd_adr_tmp;
  end
  endgenerate

  reg [BITWRDS-1:0] rd_wadr_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg [BITSROW-1:0] rd_radr_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg               rd_fwd_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg [WIDTH-1:0]   rd_dat_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg               rd_vld_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg               rd_mem_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  integer rd_int;
  always @(posedge clk)
    for (rd_int=0; rd_int<SRAM_DELAY+FLOPCMD+FLOPMEM; rd_int=rd_int+1)
      if (rd_int>0) begin
	rd_wadr_reg[rd_int] <= rd_wadr_reg[rd_int-1];
        rd_radr_reg[rd_int] <= rd_radr_reg[rd_int-1];
        rd_fwd_reg[rd_int] <= rd_fwd_reg[rd_int-1];
        rd_dat_reg[rd_int] <= rd_dat_reg[rd_int-1];
        rd_vld_reg[rd_int] <= rd_vld_reg[rd_int-1];
        rd_mem_reg[rd_int] <= rd_mem_reg[rd_int-1];
      end else begin
	rd_wadr_reg[rd_int] <= rd_wadr;
	rd_radr_reg[rd_int] <= rd_radr;
        rd_fwd_reg[rd_int] <= forward_read;
        rd_dat_reg[rd_int] <= din_wire;
        rd_vld_reg[rd_int] <= read_wire;
        rd_mem_reg[rd_int] <= mem_read_tmp;
      end


  wire [NUMWRDS*MEMWDTH-1:0] mem_rd_dout_tmp;
  wire [BITPADR-BITWRDS-1:0] mem_rd_padr_tmp;
  wire mem_rd_fwrd_tmp;
  generate if (FLOPMEM) begin: flpm_loop
    reg [NUMWRDS*MEMWDTH-1:0] mem_rd_dout_reg;
    reg [BITPADR-BITWRDS-1:0] mem_rd_padr_reg;
    reg mem_rd_fwrd_reg;
    always @(posedge clk) begin
      mem_rd_dout_reg <= mem_rd_dout;
      mem_rd_padr_reg <= mem_rd_padr;
      mem_rd_fwrd_reg <= mem_rd_fwrd;
    end
    assign mem_rd_dout_tmp = mem_rd_dout_reg;
    assign mem_rd_padr_tmp = mem_rd_padr_reg;
    assign mem_rd_fwrd_tmp = mem_rd_fwrd_reg;
  end else begin: noflpm_loop
    assign mem_rd_dout_tmp = mem_rd_dout;
    assign mem_rd_padr_tmp = mem_rd_padr;
    assign mem_rd_fwrd_tmp = mem_rd_fwrd;
  end
  endgenerate

  reg [MEMWDTH-1:0] rd_dout_wire;
  reg [BITPADR-BITWRDS-1:0] rd_padr_wire;
  reg rd_fwrd_wire; 
  integer bit_int; 
  always_comb begin
    for (bit_int=0; bit_int<MEMWDTH; bit_int=bit_int+1)
      rd_dout_wire[bit_int] = mem_rd_dout_tmp[rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]*MEMWDTH+bit_int];
    for (bit_int=0; bit_int<BITPADR-BITWRDS; bit_int=bit_int+1)
      rd_padr_wire[bit_int] = mem_rd_padr_tmp[bit_int];
    rd_fwrd_wire = mem_rd_fwrd_tmp;
  end

  wire [WIDTH-1:0] rd_dout_tmp;
  wire rd_vld_tmp;
  wire rd_fwrd_tmp;
  wire rd_serr_tmp;
  wire rd_derr_tmp;
  wire [BITPADR-1:0] rd_padr_tmp;
  generate if (ENAPAR) begin: pc_loop
    assign rd_dout_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] ? rd_dat_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] : rd_dout_wire;
    assign rd_vld_tmp = rd_vld_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_fwrd_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] || rd_fwrd_wire;
    assign rd_serr_tmp = ^rd_dout_wire && rd_mem_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_derr_tmp = 1'b0;
    assign rd_padr_tmp = (NUMWRDS>1) ? (ENAPADR ? {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_padr_wire} :
                                                  {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]}) :
                                       (ENAPADR ? rd_padr_wire : rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]);
  end else if (ENAECC) begin: ec_loop
    wire [WIDTH-1:0] rd_data_wire = rd_dout_wire;
    wire [ECCWDTH-1:0] rd_ecc_wire = rd_dout_wire >> WIDTH;
    wire [WIDTH-1:0] rd_corr_data_wire;
    wire rd_sec_err_wire;
    wire rd_ded_err_wire;

    ecc_check   #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
        ecc_check_inst (.din(rd_data_wire), .eccin(rd_ecc_wire),
                        .dout(rd_corr_data_wire), .sec_err(rd_sec_err_wire), .ded_err(rd_ded_err_wire),
                        .clk(clk), .rst(rst));

    assign rd_dout_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] ? rd_dat_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] : rd_corr_data_wire;
    assign rd_vld_tmp = rd_vld_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_fwrd_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] || rd_fwrd_wire;
    assign rd_serr_tmp = rd_sec_err_wire && rd_mem_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_derr_tmp = rd_ded_err_wire && rd_mem_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_padr_tmp = (NUMWRDS>1) ? (ENAPADR ? {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_padr_wire} :
                                                  {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]}) :
                                       (ENAPADR ? rd_padr_wire : rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]);
  end else if (ENADEC) begin: dc_loop
    wire [WIDTH-1:0] rd_data_wire = rd_dout_wire;
    wire [ECCWDTH-1:0] rd_ecc_wire = rd_dout_wire >> WIDTH;
    wire [WIDTH-1:0] rd_dup_data_wire = rd_dout_wire >> (WIDTH+ECCWDTH);
    wire [WIDTH-1:0] rd_corr_data_wire;
    wire rd_sec_err_wire;
    wire rd_ded_err_wire;
    wire rd_dup_sec_err_wire;
    wire rd_dup_ded_err_wire;

    ecc_check #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
        ecc_check_inst (.din(rd_data_wire), .eccin(rd_ecc_wire),
                        .dout(rd_corr_data_wire), .sec_err(rd_sec_err_wire), .ded_err(rd_ded_err_wire),
                        .clk(clk), .rst(rst));

    ecc_check #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
        ecc_dup_check_inst (.din(rd_dup_data_wire), .eccin(rd_ecc_wire),
                            .dout(), .sec_err(rd_dup_sec_err_wire), .ded_err(rd_dup_ded_err_wire),
                            .clk(clk), .rst(rst));
     
    assign rd_dout_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] ? rd_dat_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] :
                                                                    rd_ded_err_wire ? rd_dup_data_wire : rd_corr_data_wire;
    assign rd_vld_tmp = rd_vld_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_fwrd_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] || rd_fwrd_wire;
    assign rd_serr_tmp = (((rd_data_wire == rd_corr_data_wire) && rd_sec_err_wire && rd_dup_sec_err_wire) ||
                          ((rd_sec_err_wire ^ rd_dup_sec_err_wire) && !rd_ded_err_wire && !rd_dup_ded_err_wire)) && rd_vld_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_derr_tmp = (((rd_data_wire != rd_corr_data_wire) && rd_sec_err_wire && rd_dup_sec_err_wire) ||
                          rd_ded_err_wire || rd_dup_ded_err_wire) && rd_vld_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_padr_tmp = (NUMWRDS>1) ? (ENAPADR ? {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_padr_wire} :
                                                  {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]}) :
                                       (ENAPADR ? rd_padr_wire : rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]);
  end else if (ENAHEC) begin: hc_loop
    wire [(WIDTH>>1)-1:0] rd_data_1_wire = rd_dout_wire;
    wire [ECCWDTH-1:0] rd_ecc_1_wire = rd_dout_wire >> (WIDTH>>1);
    wire [(WIDTH>>1)-1:0] rd_corr_data_1_wire;
    wire rd_sec_err_1_wire;
    wire rd_ded_err_1_wire;

    wire [(WIDTH>>1)-1:0] rd_data_2_wire = rd_dout_wire >> ((WIDTH>>1)+ECCWDTH);
    wire [ECCWDTH-1:0] rd_ecc_2_wire = rd_dout_wire >> (WIDTH+ECCWDTH);
    wire [(WIDTH>>1)-1:0] rd_corr_data_2_wire;
    wire rd_sec_err_2_wire;
    wire rd_ded_err_2_wire;

    ecc_check #(.ECCDWIDTH(WIDTH>>1), .ECCWIDTH(ECCWDTH))
        ecc_check_1_inst (.din(rd_data_1_wire), .eccin(rd_ecc_1_wire),
                          .dout(rd_corr_data_1_wire), .sec_err(rd_sec_err_1_wire), .ded_err(rd_ded_err_1_wire),
                          .clk(clk), .rst(rst));

    ecc_check #(.ECCDWIDTH(WIDTH>>1), .ECCWIDTH(ECCWDTH))
        ecc_check_2_inst (.din(rd_data_2_wire), .eccin(rd_ecc_2_wire),
                          .dout(rd_corr_data_2_wire), .sec_err(rd_sec_err_2_wire), .ded_err(rd_ded_err_2_wire),
                          .clk(clk), .rst(rst));

    assign rd_dout_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] ? rd_dat_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] : {rd_corr_data_2_wire,rd_corr_data_1_wire};
    assign rd_vld_tmp = rd_vld_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_fwrd_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] || rd_fwrd_wire;
    assign rd_serr_tmp = (rd_sec_err_1_wire || rd_sec_err_2_wire) && rd_mem_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_derr_tmp = (rd_ded_err_1_wire || rd_ded_err_2_wire) && rd_mem_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_padr_tmp = (NUMWRDS>1) ? (ENAPADR ? {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_padr_wire} :
                                                  {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]}) :
                                       (ENAPADR ? rd_padr_wire : rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]);
  end else if (ENAQEC) begin: qc_loop
    wire [(WIDTH>>2)-1:0] rd_data_1_wire = rd_dout_wire;
    wire [ECCWDTH-1:0] rd_ecc_1_wire = rd_dout_wire >> (WIDTH>>2);
    wire [(WIDTH>>2)-1:0] rd_corr_data_1_wire;
    wire rd_sec_err_1_wire;
    wire rd_ded_err_1_wire;

    wire [(WIDTH>>2)-1:0] rd_data_2_wire = rd_dout_wire >> ((WIDTH>>2)+ECCWDTH);
    wire [ECCWDTH-1:0] rd_ecc_2_wire = rd_dout_wire >> ((WIDTH>>2)+((WIDTH>>2)+ECCWDTH));
    wire [(WIDTH>>2)-1:0] rd_corr_data_2_wire;
    wire rd_sec_err_2_wire;
    wire rd_ded_err_2_wire;

    wire [(WIDTH>>2)-1:0] rd_data_3_wire = rd_dout_wire >> (2*((WIDTH>>2)+ECCWDTH));
    wire [ECCWDTH-1:0] rd_ecc_3_wire = rd_dout_wire >> ((WIDTH>>2)+(2*((WIDTH>>2)+ECCWDTH)));
    wire [(WIDTH>>2)-1:0] rd_corr_data_3_wire;
    wire rd_sec_err_3_wire;
    wire rd_ded_err_3_wire;

    wire [(WIDTH>>2)-1:0] rd_data_4_wire = rd_dout_wire >> (3*((WIDTH>>2)+ECCWDTH));
    wire [ECCWDTH-1:0] rd_ecc_4_wire = rd_dout_wire >> ((WIDTH>>2)+(3*((WIDTH>>2)+ECCWDTH)));
    wire [(WIDTH>>2)-1:0] rd_corr_data_4_wire;
    wire rd_sec_err_4_wire;
    wire rd_ded_err_4_wire;

    ecc_check #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH))
        ecc_check_1_inst (.din(rd_data_1_wire), .eccin(rd_ecc_1_wire),
                          .dout(rd_corr_data_1_wire), .sec_err(rd_sec_err_1_wire), .ded_err(rd_ded_err_1_wire),
                          .clk(clk), .rst(rst));

    ecc_check #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH))
        ecc_check_2_inst (.din(rd_data_2_wire), .eccin(rd_ecc_2_wire),
                          .dout(rd_corr_data_2_wire), .sec_err(rd_sec_err_2_wire), .ded_err(rd_ded_err_2_wire),
                          .clk(clk), .rst(rst));

    ecc_check #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH))
        ecc_check_3_inst (.din(rd_data_3_wire), .eccin(rd_ecc_3_wire),
                          .dout(rd_corr_data_3_wire), .sec_err(rd_sec_err_3_wire), .ded_err(rd_ded_err_3_wire),
                          .clk(clk), .rst(rst));

    ecc_check #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH))
        ecc_check_4_inst (.din(rd_data_4_wire), .eccin(rd_ecc_4_wire),
                          .dout(rd_corr_data_4_wire), .sec_err(rd_sec_err_4_wire), .ded_err(rd_ded_err_4_wire),
                          .clk(clk), .rst(rst));

    assign rd_dout_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] ? rd_dat_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] :
                                                                    {rd_corr_data_4_wire,rd_corr_data_3_wire,rd_corr_data_2_wire,rd_corr_data_1_wire};
    assign rd_vld_tmp = rd_vld_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_fwrd_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] || rd_fwrd_wire;
    assign rd_serr_tmp = (rd_sec_err_1_wire || rd_sec_err_2_wire || rd_sec_err_3_wire || rd_sec_err_4_wire) && rd_mem_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_derr_tmp = (rd_ded_err_1_wire || rd_ded_err_2_wire || rd_ded_err_3_wire || rd_ded_err_4_wire) && rd_mem_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_padr_tmp = (NUMWRDS>1) ? (ENAPADR ? {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_padr_wire} :
                                                  {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]}) :
                                       (ENAPADR ? rd_padr_wire : rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]);
  end else begin: nc_loop
    assign rd_dout_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] ? rd_dat_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] : rd_dout_wire;
    assign rd_vld_tmp = rd_vld_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_fwrd_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] || rd_fwrd_wire;
    assign rd_serr_tmp = 1'b0;
    assign rd_derr_tmp = 1'b0;
    assign rd_padr_tmp = (NUMWRDS>1) ? (ENAPADR ? {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_padr_wire} :
                                                  {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]}) :
                                       (ENAPADR ? rd_padr_wire : rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]);
  end
  endgenerate

  generate if (FLOPOUT) begin: flpo_loop
    reg [WIDTH-1:0] rd_dout_reg;
    reg rd_vld_reg;
    reg rd_fwrd_reg;
    reg rd_serr_reg;
    reg rd_derr_reg;
    reg [BITPADR-1:0] rd_padr_reg;
    always @(posedge clk) begin
      rd_dout_reg <= rd_dout_tmp;
      rd_vld_reg <= rd_vld_tmp;
      rd_fwrd_reg <= rd_fwrd_tmp;
      rd_serr_reg <= rd_serr_tmp;
      rd_derr_reg <= rd_derr_tmp;
      rd_padr_reg <= rd_padr_tmp;
    end
    assign rd_dout = rd_dout_reg;
    assign rd_vld = rd_vld_reg;
    assign rd_fwrd = rd_fwrd_reg;
    assign rd_serr = rd_serr_reg;
    assign rd_derr = rd_derr_reg;
    assign rd_padr = rd_padr_reg;
  end else begin: noflpo_loop
    assign rd_dout = rd_dout_tmp;
    assign rd_vld = rd_vld_tmp;
    assign rd_fwrd = rd_fwrd_tmp;
    assign rd_serr = rd_serr_tmp;
    assign rd_derr = rd_derr_tmp;
    assign rd_padr = rd_padr_tmp;
  end
  endgenerate

endmodule

