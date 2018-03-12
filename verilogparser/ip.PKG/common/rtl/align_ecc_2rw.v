module align_ecc_2rw (write, read, addr, din, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
	              mem_write, mem_read, mem_addr, mem_bw, mem_din, mem_dout,
                      clk, rst);

  parameter WIDTH = 32;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
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
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;

  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;

  input [2-1:0] write;
  input [2-1:0] read;
  input [2*BITADDR-1:0] addr;
  input [2*WIDTH-1:0] din;
  output [2*WIDTH-1:0] rd_dout;
  output [2-1:0] rd_fwrd;
  output [2-1:0] rd_serr;
  output [2-1:0] rd_derr;
  output [2*BITPADR-1:0] rd_padr;

  output [2-1:0] mem_write;
  output [2-1:0] mem_read;
  output [2*BITSROW-1:0] mem_addr;
  output [2*NUMWRDS*MEMWDTH-1:0] mem_bw;
  output [2*NUMWRDS*MEMWDTH-1:0] mem_din;
  input [2*NUMWRDS*MEMWDTH-1:0] mem_dout;

  input clk;
  input rst;

  wire write_wire [0:2-1];
  wire read_wire [0:2-1];
  wire [BITADDR-1:0] addr_wire [0:2-1];
  wire [WIDTH-1:0] din_wire [0:2-1];

  wire write_reg [0:2-1];
  wire [BITADDR-1:0] wr_adr_reg [0:2-1];
  wire [WIDTH-1:0] din_reg [0:2-1];

  genvar gen_var;
  generate for (gen_var=0; gen_var<2; gen_var=gen_var+1) begin: gen_loop
    wire write_tmp = write >> gen_var;
    wire read_tmp = read >> gen_var;
    wire [BITADDR-1:0] addr_tmp = addr >> (gen_var*BITADDR);
    wire [WIDTH-1:0] wrdin_tmp = din >> (gen_var*WIDTH);
   
    if (FLOPGEN) begin: flpg_loop
      reg write_help;
      reg [BITADDR-1:0] wr_adr_help;
      reg [WIDTH-1:0] din_help;
      always @(posedge clk)
        if (rst)
          write_help <= 1'b0;
        else if (write_tmp) begin
          write_help <= 1'b1;
          wr_adr_help <= addr_tmp;
          din_help <= wrdin_tmp;
        end else if (write_help && !read_tmp)
          write_help <= 1'b0;

      assign write_wire[gen_var] = write_help && !read_tmp;
      assign read_wire[gen_var] = read_tmp;
      assign addr_wire[gen_var] = read_tmp ? addr_tmp : wr_adr_help;
      assign din_wire[gen_var] = din_help;

      assign write_reg[gen_var] = write_help;
      assign wr_adr_reg[gen_var] = wr_adr_help;
      assign din_reg[gen_var] = din_help;
    end else begin: noflpi_loop
      assign write_wire[gen_var] = write_tmp;
      assign read_wire[gen_var] = read_tmp;
      assign addr_wire[gen_var] = addr_tmp;
      assign din_wire[gen_var] = wrdin_tmp;
    end
  end
  endgenerate

  wire [BITWRDS-1:0] wadr [0:2-1];
  wire [BITSROW-1:0] radr [0:2-1];
  wire [MEMWDTH-1:0] din_tmp [0:2-1];
  genvar np2_var;
  generate for (np2_var=0; np2_var<2; np2_var=np2_var+1) begin: adr_loop
    if (BITWRDS>0) begin: np2_loop
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
                 .NUMVROW (NUMSROW), .BITVROW (BITSROW))
        np2_inst (.vbadr(wadr[np2_var]), .vradr(radr[np2_var]), .vaddr(addr_wire[np2_var]));
    end else begin: no_np2_loop
      assign wadr[np2_var] = 0;
      assign radr[np2_var] = addr_wire[np2_var];
    end

    if (ENAPAR) begin: pg_loop
      assign din_tmp[np2_var] = {^din_wire[np2_var],din_wire[np2_var]};
    end else if (ENAECC) begin: eg_loop
      wire [ECCWDTH-1:0] din_ecc;
      ecc_calc #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
        ecc_calc_inst (.din(din_wire[np2_var]), .eccout(din_ecc));
      assign din_tmp[np2_var] = {din_ecc,din_wire[np2_var]};
    end else begin: ng_loop
      assign din_tmp[np2_var] = din_wire[np2_var];
    end
  end
  endgenerate

  reg write_vld_reg;
  reg [BITSROW-1:0] write_adr_reg;
  reg [NUMWRDS-1:0] write_msk_reg;
  reg [NUMWRDS*MEMWDTH-1:0] write_dat_reg;
  always @(posedge clk)
    if (rst)
      write_vld_reg <= 1'b0;
    else if (write_wire[0] && read_wire[1] && (radr[0] == radr[1])) begin
      write_vld_reg <= 1'b1;
      write_adr_reg <= radr[0]; 
      if (write_vld_reg && (radr[0] == write_adr_reg)) begin
        write_msk_reg <= write_msk_reg | (1 << wadr[0]);
        write_dat_reg <= (write_dat_reg & ~({MEMWDTH{1'b1}} << (wadr[0]*MEMWDTH))) | (din_tmp[0] << (wadr[0]*MEMWDTH));
      end else begin
        write_msk_reg <= 1 << wadr[0];
        write_dat_reg <= din_tmp[0] << (wadr[0]*MEMWDTH);
      end
    end else if (write_wire[1] && read_wire[0] && (radr[1] == radr[0])) begin
      write_vld_reg <= 1'b1; write_adr_reg <= radr[1]; 
      if (write_vld_reg && (radr[1] == write_adr_reg)) begin
        write_msk_reg <= write_msk_reg | (1 << wadr[1]);
        write_dat_reg <= (write_dat_reg & ~({MEMWDTH{1'b1}} << (wadr[1]*MEMWDTH))) | (din_tmp[1] << (wadr[1]*MEMWDTH));
      end else begin
        write_msk_reg <= 1 << wadr[1];
        write_dat_reg <= din_tmp[1] << (wadr[1]*MEMWDTH);
      end
    end else if (write_vld_reg && write_wire[0] && (radr[0] == write_adr_reg) && write_wire[1] && (radr[1] == write_adr_reg)) begin
      write_vld_reg <= 1'b1;
      write_adr_reg <= radr[0]; 
      write_msk_reg <= write_msk_reg | (1 << wadr[0]) | (1 << wadr[1]);
      write_dat_reg <= (write_dat_reg & ~({MEMWDTH{1'b1}} << (wadr[0]*MEMWDTH)) & ~({MEMWDTH{1'b1}} << (wadr[1]*MEMWDTH))) |
                       (din_tmp[0] << (wadr[0]*MEMWDTH)) | (din_tmp[1] << (wadr[1]*MEMWDTH));
    end else if (write_wire[0] && write_vld_reg && (radr[0] == write_adr_reg)) begin
      write_vld_reg <= 1'b1;
      write_adr_reg <= radr[0]; 
      write_msk_reg <= write_msk_reg | (1 << wadr[0]);
      write_dat_reg <= (write_dat_reg & ~({MEMWDTH{1'b1}} << (wadr[0]*MEMWDTH))) | (din_tmp[0] << (wadr[0]*MEMWDTH));
    end else if (write_wire[1] && write_vld_reg && (radr[1] == write_adr_reg)) begin
      write_vld_reg <= 1'b1;
      write_adr_reg <= radr[1]; 
      write_msk_reg <= write_msk_reg | (1 << wadr[1]);
      write_dat_reg <= (write_dat_reg & ~({MEMWDTH{1'b1}} << (wadr[1]*MEMWDTH))) | (din_tmp[1] << (wadr[1]*MEMWDTH));
    end

  reg [NUMWRDS*MEMWDTH-1:0] write_msk_tmp;
  integer msk_int;
  always_comb begin
    write_msk_tmp = 0;
    for (msk_int=0; msk_int<NUMWRDS; msk_int=msk_int+1)
      write_msk_tmp = write_msk_tmp | ({MEMWDTH{write_msk_reg[msk_int]}} << (msk_int*MEMWDTH)); 
  end

  wire mem_write_wire [0:2-1];
  wire mem_read_wire [0:2-1];
  wire [BITSROW-1:0] mem_addr_wire [0:2-1];
  wire [NUMWRDS*MEMWDTH-1:0] mem_bw_wire [0:2-1];
  wire [NUMWRDS*MEMWDTH-1:0] mem_din_wire [0:2-1];

  assign mem_read_wire[0] = read_wire[0];
  assign mem_write_wire[0] = write_wire[0] && !(write_wire[1] && (radr[0] == radr[1])) &&
                             !(read_wire[1] && (radr[0] == radr[1]) && (!write_vld_reg || (write_adr_reg == radr[0])));
  assign mem_addr_wire[0] = read_wire[0] ? radr[0] : (write_wire[0] && read_wire[1] && (radr[0] == radr[1])) ? write_adr_reg : radr[0];
  assign mem_bw_wire[0] = (write_wire[0] && read_wire[1] && (radr[0] == radr[1])) ? write_msk_tmp : {MEMWDTH{1'b1}} << (wadr[0]*MEMWDTH);
  assign mem_din_wire[0] = (write_wire[0] && read_wire[1] && (radr[0] == radr[1])) ? write_dat_reg : din_tmp[0] << (wadr[0]*MEMWDTH);

  assign mem_read_wire[1] = read_wire[1];
  assign mem_write_wire[1] = write_wire[1] && !(read_wire[0] && (radr[1] == radr[0]) && (!write_vld_reg || (write_adr_reg == radr[1])));
  assign mem_addr_wire[1] = read_wire[1] ? radr[1] : (write_wire[1] && read_wire[0] && (radr[1] == radr[0])) ? write_adr_reg : radr[1];
  assign mem_bw_wire[1] = (write_wire[1] && read_wire[0] && (radr[1] == radr[0])) ? write_msk_tmp :
                          ((write_wire[0] && write_wire[1] && (radr[0] == radr[1])) ? mem_bw_wire[0] : 0) | ({MEMWDTH{1'b1}} << (wadr[1]*MEMWDTH));
  assign mem_din_wire[1] = (write_wire[1] && read_wire[0] && (radr[1] == radr[0])) ? write_dat_reg :
                           ((write_wire[0] && write_wire[1] && (radr[0] == radr[1])) ? mem_din_wire[0] : 0) | (din_tmp[1] << (wadr[1]*MEMWDTH));

  wire [BITSROW-1:0] mem_addr_wire_0 = mem_addr_wire[0];
  wire [BITSROW-1:0] mem_addr_wire_1 = mem_addr_wire[1];

  reg [2-1:0] mem_write;
  reg [2-1:0] mem_read;
  reg [2*BITSROW-1:0] mem_addr;
  reg [2*NUMWRDS*MEMWDTH-1:0] mem_bw;
  reg [2*NUMWRDS*MEMWDTH-1:0] mem_din;
  integer mem_int;
  always_comb begin
    mem_write = 0;
    mem_read = 0;
    mem_addr = 0;
    mem_bw = 0;
    mem_din = 0;
    for (mem_int=0; mem_int<2; mem_int=mem_int+1) begin
      mem_write = mem_write | (mem_write_wire[mem_int] << mem_int);
      mem_read = mem_read | (mem_read_wire[mem_int] << mem_int);
      mem_addr = mem_addr | (mem_addr_wire[mem_int] << (mem_int*BITSROW));
      mem_bw = mem_bw | (mem_bw_wire[mem_int] << (mem_int*NUMWRDS*MEMWDTH));
      mem_din = mem_din | (mem_din_wire[mem_int] << (mem_int*NUMWRDS*MEMWDTH));
    end
  end

  wire forward_read [0:2-1];
  assign forward_read[0] = (FLOPGEN && read_wire[0] && write_reg[0] && (addr_wire[0] == wr_adr_reg[0])) ||
                           (FLOPGEN && read_wire[0] && write_reg[1] && (addr_wire[0] == wr_adr_reg[0])) ||
                           read_wire[0] && write_vld_reg && (radr[0] == write_adr_reg) && write_msk_reg[wadr[0]];
  assign forward_read[1] = (FLOPGEN && read_wire[1] && write_reg[0] && (addr_wire[1] == wr_adr_reg[0])) ||
                           (FLOPGEN && read_wire[1] && write_reg[1] && (addr_wire[1] == wr_adr_reg[1])) ||
                           read_wire[1] && write_vld_reg && (radr[1] == write_adr_reg) && write_msk_reg[wadr[1]];

  reg [BITWRDS-1:0] wadr_reg [0:2-1][0:SRAM_DELAY+FLOPMEM-1];
  reg [BITSROW-1:0] radr_reg [0:2-1][0:SRAM_DELAY+FLOPMEM-1];
  reg               fwd_reg [0:2-1][0:SRAM_DELAY+FLOPMEM-1];
  reg [MEMWDTH-1:0] dat_reg [0:2-1][0:SRAM_DELAY+FLOPMEM-1];
  reg               vld_reg [0:2-1][0:SRAM_DELAY+FLOPMEM-1];
  integer rdp_int, rdb_int;
  always @(posedge clk)
    for (rdp_int=0; rdp_int<2; rdp_int=rdp_int+1)
      for (rdb_int=0; rdb_int<SRAM_DELAY+FLOPMEM; rdb_int=rdb_int+1)
        if (rdb_int>0) begin
          wadr_reg[rdp_int][rdb_int] <= wadr_reg[rdp_int][rdb_int-1];
          radr_reg[rdp_int][rdb_int] <= radr_reg[rdp_int][rdb_int-1];
          fwd_reg[rdp_int][rdb_int] <= fwd_reg[rdp_int][rdb_int-1];
          dat_reg[rdp_int][rdb_int] <= dat_reg[rdp_int][rdb_int-1];
          vld_reg[rdp_int][rdb_int] <= vld_reg[rdp_int][rdb_int-1];
        end else if (FLOPGEN && read_wire[rdp_int] && write_reg[1] && (addr_wire[rdp_int] == wr_adr_reg[1])) begin
          wadr_reg[rdp_int][rdb_int] <= wadr[rdp_int];
          radr_reg[rdp_int][rdb_int] <= radr[rdp_int];
          fwd_reg[rdp_int][rdb_int] <= 1'b1;
          dat_reg[rdp_int][rdb_int] <= din_reg[1];
          vld_reg[rdp_int][rdb_int] <= read_wire[rdp_int];
        end else if (FLOPGEN && read_wire[rdp_int] && write_reg[0] && (addr_wire[rdp_int] == wr_adr_reg[0])) begin
          wadr_reg[rdp_int][rdb_int] <= wadr[rdp_int];
          radr_reg[rdp_int][rdb_int] <= radr[rdp_int];
          fwd_reg[rdp_int][rdb_int] <= 1'b1;
          dat_reg[rdp_int][rdb_int] <= din_reg[0];
          vld_reg[rdp_int][rdb_int] <= read_wire[rdp_int];
        end else begin
          wadr_reg[rdp_int][rdb_int] <= wadr[rdp_int];
          radr_reg[rdp_int][rdb_int] <= radr[rdp_int];
          fwd_reg[rdp_int][rdb_int] <= read_wire[rdp_int] && write_vld_reg && (radr[rdp_int] == write_adr_reg) && write_msk_reg[wadr[rdp_int]];
          dat_reg[rdp_int][rdb_int] <= write_dat_reg >> (wadr[rdp_int]*MEMWDTH);
          vld_reg[rdp_int][rdb_int] <= read[rdp_int];
        end

  wire [2*NUMWRDS*MEMWDTH-1:0] mem_dout_tmp;
  generate if (FLOPMEM) begin: flpm_loop
    reg [2*NUMWRDS*MEMWDTH-1:0] mem_dout_reg;
    always @(posedge clk)
      mem_dout_reg <= mem_dout;
    assign mem_dout_tmp = mem_dout_reg;
  end else begin: noflpm_loop
    assign mem_dout_tmp = mem_dout;
  end
  endgenerate

  wire [MEMWDTH-1:0] rd_dout_int [0:2-1];
  genvar err_int;
  generate for (err_int=0; err_int<2; err_int=err_int+1) begin: err_loop
    wire [MEMWDTH-1:0] rd_dout_wire = mem_dout_tmp >> ((NUMWRDS*err_int+wadr_reg[err_int][SRAM_DELAY+FLOPMEM-1])*MEMWDTH);
    assign rd_dout_int[err_int] = rd_dout_wire;
  end
  endgenerate

  wire [WIDTH-1:0] rd_dout_tmp [0:2-1];
  wire rd_fwrd_tmp [0:2-1];
  wire rd_serr_tmp [0:2-1];
  wire rd_derr_tmp [0:2-1];
  wire [BITPADR-1:0] rd_padr_tmp [0:2-1];
  genvar rtmp_int;
  generate for (rtmp_int=0; rtmp_int<2; rtmp_int=rtmp_int+1) begin: rdc_loop
    if (ENAPAR) begin: pc_loop
      assign rd_dout_tmp[rtmp_int] = fwd_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1] ? dat_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1] : rd_dout_int[rtmp_int];
      assign rd_fwrd_tmp[rtmp_int] = fwd_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1];
      assign rd_serr_tmp[rtmp_int] = ^rd_dout_int[rtmp_int] && vld_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1];
      assign rd_derr_tmp[rtmp_int] = 1'b0;
      assign rd_padr_tmp[rtmp_int] = (NUMWRDS>1) ? {wadr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1],radr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1]} :
                                                   {radr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1]};
    end else if (ENAECC) begin: ec_loop
      wire [WIDTH-1:0] rd_data_wire = rd_dout_int[rtmp_int];
      wire [ECCWDTH-1:0] rd_ecc_wire = rd_dout_int[rtmp_int] >> WIDTH;
      wire [WIDTH-1:0] rd_corr_data_wire;
      wire rd_sec_err_wire;
      wire rd_ded_err_wire;

      ecc_check   #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
          ecc_check_inst (.din(rd_data_wire), .eccin(rd_ecc_wire),
                          .dout(rd_corr_data_wire), .sec_err(rd_sec_err_wire), .ded_err(rd_ded_err_wire),
                          .clk(clk), .rst(rst));

      assign rd_dout_tmp[rtmp_int] = fwd_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1] ? dat_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1] : rd_corr_data_wire;
      assign rd_fwrd_tmp[rtmp_int] = fwd_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1];
      assign rd_serr_tmp[rtmp_int] = rd_sec_err_wire && vld_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1];
      assign rd_derr_tmp[rtmp_int] = rd_ded_err_wire && vld_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1];
      assign rd_padr_tmp[rtmp_int] = (NUMWRDS>1) ? {wadr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1],radr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1]} :
                                                   {radr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1]};
    end else begin: nc_loop
      assign rd_dout_tmp[rtmp_int] = fwd_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1] ? dat_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1] : rd_dout_int[rtmp_int];
      assign rd_fwrd_tmp[rtmp_int] = fwd_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1];
      assign rd_serr_tmp[rtmp_int] = 1'b0;
      assign rd_derr_tmp[rtmp_int] = 1'b0;
      assign rd_padr_tmp[rtmp_int] = (NUMWRDS>1) ? {wadr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1],radr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1]} :
                                                   {radr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1]};
    end
  end
  endgenerate

  reg [2*WIDTH-1:0] rd_dout_help;
  reg [2-1:0] rd_fwrd_help;
  reg [2-1:0] rd_serr_help;
  reg [2-1:0] rd_derr_help;
  reg [2*BITPADR-1:0] rd_padr_help;
  integer rdh_int;
  always_comb begin
    rd_dout_help = 0;
    rd_fwrd_help = 0;
    rd_serr_help = 0;
    rd_derr_help = 0;
    rd_padr_help = 0;
    for (rdh_int=0; rdh_int<2; rdh_int=rdh_int+1) begin
      rd_dout_help = rd_dout_help | (rd_dout_tmp[rdh_int] << (rdh_int*WIDTH));
      rd_fwrd_help = rd_fwrd_help | (rd_fwrd_tmp[rdh_int] << rdh_int);
      rd_serr_help = rd_serr_help | (rd_serr_tmp[rdh_int] << rdh_int);
      rd_derr_help = rd_derr_help | (rd_derr_tmp[rdh_int] << rdh_int);
      rd_padr_help = rd_padr_help | (rd_padr_tmp[rdh_int] << (rdh_int*BITPADR));
    end
  end

  generate if (FLOPOUT) begin: flpo_loop
    reg [2*WIDTH-1:0] rd_dout_reg;
    reg [2-1:0] rd_fwrd_reg;
    reg [2-1:0] rd_serr_reg;
    reg [2-1:0] rd_derr_reg;
    reg [2*BITPADR-1:0] rd_padr_reg;
    always @(posedge clk) begin
      rd_dout_reg <= rd_dout_help;
      rd_fwrd_reg <= rd_fwrd_help;
      rd_serr_reg <= rd_serr_help;
      rd_derr_reg <= rd_derr_help;
      rd_padr_reg <= rd_padr_help;
    end
    assign rd_dout = rd_dout_reg;
    assign rd_fwrd = rd_fwrd_reg;
    assign rd_serr = rd_serr_reg;
    assign rd_derr = rd_derr_reg;
    assign rd_padr = rd_padr_reg;
  end else begin: noflpo_loop
    assign rd_dout = rd_dout_help;
    assign rd_fwrd = rd_fwrd_help;
    assign rd_serr = rd_serr_help;
    assign rd_derr = rd_derr_help;
    assign rd_padr = rd_padr_help;
  end
  endgenerate

endmodule
