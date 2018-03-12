module align_ecc_pseudo (write, wr_bnk, wr_adr, din,
                         read, rd_bnk, rd_adr, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
	                 mem_write, mem_wr_bnk, mem_wr_adr, mem_wr_dwsn, mem_bw, mem_din,
                         mem_read, mem_rd_bnk, mem_rd_adr, mem_rd_dwsn, mem_rd_dout, mem_rd_fwrd,  mem_rd_padr,
                         clk, rst);

  parameter WIDTH = 32;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ENADEC = 0;
  parameter ECCWDTH = 7;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
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

  parameter NUMDWS0 = 72;
  parameter NUMDWS1 = 72;
  parameter NUMDWS2 = 72;
  parameter NUMDWS3 = 72;
  parameter NUMDWS4 = 72;
  parameter NUMDWS5 = 72;
  parameter NUMDWS6 = 72;
  parameter NUMDWS7 = 72;
  parameter NUMDWS8 = 72;
  parameter NUMDWS9 = 72;
  parameter NUMDWS10 = 72;
  parameter NUMDWS11 = 72;
  parameter NUMDWS12 = 72;
  parameter NUMDWS13 = 72;
  parameter NUMDWS14 = 72;
  parameter NUMDWS15 = 72;
  parameter BITDWSN = 4;

  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENADEC ? 2*WIDTH+ECCWDTH : WIDTH;

  input write;
  input [BITVBNK-1:0] wr_bnk;
  input [BITVROW-1:0] wr_adr;
  input [WIDTH-1:0] din;

  input read;
  input [BITVBNK-1:0] rd_bnk;
  input [BITVROW-1:0] rd_adr;
  output [WIDTH-1:0] rd_dout;
  output rd_fwrd;
  output rd_serr;
  output rd_derr;
  output [BITPADR-1:0] rd_padr;

  output mem_write;
  output [BITVBNK-1:0] mem_wr_bnk;
  output [BITSROW-1:0] mem_wr_adr;
  output [BITDWSN-1:0] mem_wr_dwsn;
  output [NUMWRDS*MEMWDTH-1:0] mem_bw;
  output [NUMWRDS*MEMWDTH-1:0] mem_din;
  output mem_read;
  output [BITVBNK-1:0] mem_rd_bnk;
  output [BITSROW-1:0] mem_rd_adr;
  output [BITDWSN-1:0] mem_rd_dwsn;
  input [NUMWRDS*MEMWDTH-1:0] mem_rd_dout;
  input mem_rd_fwrd;
  input [(BITPADR-BITWRDS)-1:0] mem_rd_padr;

  input clk;
  input rst;

  wire write_wire;
  wire [BITVBNK-1:0] wr_bnk_wire;
  wire [BITVROW-1:0] wr_adr_wire;
  wire [WIDTH-1:0] din_wire;
  wire read_wire;
  wire [BITVBNK-1:0] rd_bnk_wire;
  wire [BITVROW-1:0] rd_adr_wire;
  generate if (FLOPGEN) begin: flpg_loop
    reg write_reg;
    reg [BITVBNK-1:0] wr_bnk_reg;
    reg [BITVROW-1:0] wr_adr_reg;
    reg [WIDTH-1:0] din_reg;
    always @(posedge clk) begin
      write_reg <= write;
      wr_bnk_reg <= wr_bnk;
      wr_adr_reg <= wr_adr;
      din_reg <= din;
    end
    assign write_wire = write_reg;
    assign wr_bnk_wire = wr_bnk_reg;
    assign wr_adr_wire = wr_adr_reg;
    assign din_wire = din_reg;
    assign read_wire = read;
    assign rd_bnk_wire = rd_bnk;
    assign rd_adr_wire = rd_adr;
  end else begin: noflpi_loop
    assign write_wire = write;
    assign wr_bnk_wire = wr_bnk;
    assign wr_adr_wire = wr_adr;
    assign din_wire = din;
    assign read_wire = read;
    assign rd_bnk_wire = rd_bnk;
    assign rd_adr_wire = rd_adr;
  end
  endgenerate

  wire [BITWRDS-1:0] wr_wadr;
  wire [BITSROW-1:0] wr_radr;
  wire [BITWRDS-1:0] rd_wadr;
  wire [BITSROW-1:0] rd_radr;
  generate if (BITWRDS>0) begin: np2_loop
    np2_addr #(
      .NUMADDR (NUMVROW), .BITADDR (BITVROW),
      .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
      .NUMVROW (NUMSROW), .BITVROW (BITSROW))
      wr_adr_inst (.vbadr(wr_wadr), .vradr(wr_radr), .vaddr(wr_adr_wire));

    np2_addr #(
      .NUMADDR (NUMVROW), .BITADDR (BITVROW),
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
    wire [ECCWDTH-1:0] din_ecc_d;
    ecc_calc #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
      ecc_calc_inst (.din(din_wire), .eccout(din_ecc_d));
    assign din_tmp = {din_wire,din_ecc_d,din_wire};
  end else begin: ng_loop
    assign din_tmp = din_wire;
  end
  endgenerate

  wire forward_read = FLOPGEN && read_wire && write_wire && (rd_bnk_wire == wr_bnk_wire) && (rd_adr_wire == wr_adr_wire);
  wire mem_write_tmp = write_wire;
  wire [BITVBNK-1:0] mem_wr_bnk_tmp = wr_bnk_wire;
  wire [BITSROW-1:0] mem_wr_adr_tmp = wr_radr;
  wire [NUMWRDS*MEMWDTH-1:0] mem_bw_tmp = {MEMWDTH{1'b1}} << (wr_wadr*MEMWDTH);
  wire [NUMWRDS*MEMWDTH-1:0] mem_din_tmp = din_tmp << (wr_wadr*MEMWDTH);
  wire mem_read_tmp = read_wire && !forward_read;
  wire [BITVBNK-1:0] mem_rd_bnk_tmp = rd_bnk_wire;
  wire [BITSROW-1:0] mem_rd_adr_tmp = rd_radr;
  wire [NUMWRDS*MEMWDTH-1:0] mem_br_tmp = {MEMWDTH{1'b1}} << (rd_wadr*MEMWDTH);

  parameter SDWS0  = 0      + NUMDWS0;
  parameter SDWS1  = SDWS0  + NUMDWS1;
  parameter SDWS2  = SDWS1  + NUMDWS2;
  parameter SDWS3  = SDWS2  + NUMDWS3;
  parameter SDWS4  = SDWS3  + NUMDWS4;
  parameter SDWS5  = SDWS4  + NUMDWS5;
  parameter SDWS6  = SDWS5  + NUMDWS6;
  parameter SDWS7  = SDWS6  + NUMDWS7;
  parameter SDWS8  = SDWS7  + NUMDWS8;
  parameter SDWS9  = SDWS8  + NUMDWS9;
  parameter SDWS10 = SDWS9  + NUMDWS10;
  parameter SDWS11 = SDWS10 + NUMDWS11;
  parameter SDWS12 = SDWS11 + NUMDWS12;
  parameter SDWS13 = SDWS12 + NUMDWS13;
  parameter SDWS14 = SDWS13 + NUMDWS14;

  reg [BITDWSN-1:0] mem_wr_dwsn_tmp;
  integer wrdw_int;
  always_comb begin
    mem_wr_dwsn_tmp = ~0;
    for (wrdw_int=0; wrdw_int<BITDWSN; wrdw_int=wrdw_int+1)
      if (wrdw_int<16) begin
             if ((wrdw_int==0)  && NUMDWS0)   mem_wr_dwsn_tmp[wrdw_int]  = !(|(~(~0 << NUMDWS0)  & (mem_bw_tmp >> 0)));
        else if ((wrdw_int==1)  && NUMDWS1)   mem_wr_dwsn_tmp[wrdw_int]  = !(|(~(~0 << NUMDWS1)  & (mem_bw_tmp >> SDWS0)));
        else if ((wrdw_int==2)  && NUMDWS2)   mem_wr_dwsn_tmp[wrdw_int]  = !(|(~(~0 << NUMDWS2)  & (mem_bw_tmp >> SDWS1)));
        else if ((wrdw_int==3)  && NUMDWS3)   mem_wr_dwsn_tmp[wrdw_int]  = !(|(~(~0 << NUMDWS3)  & (mem_bw_tmp >> SDWS2)));
        else if ((wrdw_int==4)  && NUMDWS4)   mem_wr_dwsn_tmp[wrdw_int]  = !(|(~(~0 << NUMDWS4)  & (mem_bw_tmp >> SDWS3)));
        else if ((wrdw_int==5)  && NUMDWS5)   mem_wr_dwsn_tmp[wrdw_int]  = !(|(~(~0 << NUMDWS5)  & (mem_bw_tmp >> SDWS4)));
        else if ((wrdw_int==6)  && NUMDWS6)   mem_wr_dwsn_tmp[wrdw_int]  = !(|(~(~0 << NUMDWS6)  & (mem_bw_tmp >> SDWS5)));
        else if ((wrdw_int==7)  && NUMDWS7)   mem_wr_dwsn_tmp[wrdw_int]  = !(|(~(~0 << NUMDWS7)  & (mem_bw_tmp >> SDWS6)));
        else if ((wrdw_int==8)  && NUMDWS8)   mem_wr_dwsn_tmp[wrdw_int]  = !(|(~(~0 << NUMDWS8)  & (mem_bw_tmp >> SDWS7)));
        else if ((wrdw_int==9)  && NUMDWS9)   mem_wr_dwsn_tmp[wrdw_int]  = !(|(~(~0 << NUMDWS9)  & (mem_bw_tmp >> SDWS8)));
        else if ((wrdw_int==10) && NUMDWS10)  mem_wr_dwsn_tmp[wrdw_int]  = !(|(~(~0 << NUMDWS10) & (mem_bw_tmp >> SDWS9)));
        else if ((wrdw_int==11) && NUMDWS11)  mem_wr_dwsn_tmp[wrdw_int]  = !(|(~(~0 << NUMDWS11) & (mem_bw_tmp >> SDWS10)));
        else if ((wrdw_int==12) && NUMDWS12)  mem_wr_dwsn_tmp[wrdw_int]  = !(|(~(~0 << NUMDWS12) & (mem_bw_tmp >> SDWS11)));
        else if ((wrdw_int==13) && NUMDWS13)  mem_wr_dwsn_tmp[wrdw_int]  = !(|(~(~0 << NUMDWS13) & (mem_bw_tmp >> SDWS12)));
        else if ((wrdw_int==14) && NUMDWS14)  mem_wr_dwsn_tmp[wrdw_int]  = !(|(~(~0 << NUMDWS14) & (mem_bw_tmp >> SDWS13)));
        else if ((wrdw_int==15) && NUMDWS15)  mem_wr_dwsn_tmp[wrdw_int]  = !(|(~(~0 << NUMDWS15) & (mem_bw_tmp >> SDWS14)));
      end else
        mem_wr_dwsn_tmp[wrdw_int] = 0;
  end

  reg [BITDWSN-1:0] mem_rd_dwsn_tmp;
  integer rddw_int;
  always_comb begin
    mem_rd_dwsn_tmp = ~0;
    for (rddw_int=0; rddw_int<BITDWSN; rddw_int=rddw_int+1)
      if (rddw_int<16) begin
             if ((rddw_int==0)  && NUMDWS0)   mem_rd_dwsn_tmp[rddw_int]  = !(|(~(~0 << NUMDWS0)  & (mem_br_tmp >> 0)));
        else if ((rddw_int==1)  && NUMDWS1)   mem_rd_dwsn_tmp[rddw_int]  = !(|(~(~0 << NUMDWS1)  & (mem_br_tmp >> SDWS0)));
        else if ((rddw_int==2)  && NUMDWS2)   mem_rd_dwsn_tmp[rddw_int]  = !(|(~(~0 << NUMDWS2)  & (mem_br_tmp >> SDWS1)));
        else if ((rddw_int==3)  && NUMDWS3)   mem_rd_dwsn_tmp[rddw_int]  = !(|(~(~0 << NUMDWS3)  & (mem_br_tmp >> SDWS2)));
        else if ((rddw_int==4)  && NUMDWS4)   mem_rd_dwsn_tmp[rddw_int]  = !(|(~(~0 << NUMDWS4)  & (mem_br_tmp >> SDWS3)));
        else if ((rddw_int==5)  && NUMDWS5)   mem_rd_dwsn_tmp[rddw_int]  = !(|(~(~0 << NUMDWS5)  & (mem_br_tmp >> SDWS4)));
        else if ((rddw_int==6)  && NUMDWS6)   mem_rd_dwsn_tmp[rddw_int]  = !(|(~(~0 << NUMDWS6)  & (mem_br_tmp >> SDWS5)));
        else if ((rddw_int==7)  && NUMDWS7)   mem_rd_dwsn_tmp[rddw_int]  = !(|(~(~0 << NUMDWS7)  & (mem_br_tmp >> SDWS6)));
        else if ((rddw_int==8)  && NUMDWS8)   mem_rd_dwsn_tmp[rddw_int]  = !(|(~(~0 << NUMDWS8)  & (mem_br_tmp >> SDWS7)));
        else if ((rddw_int==9)  && NUMDWS9)   mem_rd_dwsn_tmp[rddw_int]  = !(|(~(~0 << NUMDWS9)  & (mem_br_tmp >> SDWS8)));
        else if ((rddw_int==10) && NUMDWS10)  mem_rd_dwsn_tmp[rddw_int]  = !(|(~(~0 << NUMDWS10) & (mem_br_tmp >> SDWS9)));
        else if ((rddw_int==11) && NUMDWS11)  mem_rd_dwsn_tmp[rddw_int]  = !(|(~(~0 << NUMDWS11) & (mem_br_tmp >> SDWS10)));
        else if ((rddw_int==12) && NUMDWS12)  mem_rd_dwsn_tmp[rddw_int]  = !(|(~(~0 << NUMDWS12) & (mem_br_tmp >> SDWS11)));
        else if ((rddw_int==13) && NUMDWS13)  mem_rd_dwsn_tmp[rddw_int]  = !(|(~(~0 << NUMDWS13) & (mem_br_tmp >> SDWS12)));
        else if ((rddw_int==14) && NUMDWS14)  mem_rd_dwsn_tmp[rddw_int]  = !(|(~(~0 << NUMDWS14) & (mem_br_tmp >> SDWS13)));
        else if ((rddw_int==15) && NUMDWS15)  mem_rd_dwsn_tmp[rddw_int]  = !(|(~(~0 << NUMDWS15) & (mem_br_tmp >> SDWS14)));
      end else
        mem_rd_dwsn_tmp[rddw_int] = 0;
  end

  generate if (FLOPCMD) begin: flpc_loop
    reg mem_write_reg;
    reg [BITVBNK-1:0] mem_wr_bnk_reg;
    reg [BITSROW-1:0] mem_wr_adr_reg;
    reg [BITDWSN-1:0] mem_wr_dwsn_reg;
    reg [NUMWRDS*MEMWDTH-1:0] mem_bw_reg;
    reg [NUMWRDS*MEMWDTH-1:0] mem_din_reg;
    reg mem_read_reg;
    reg [BITVBNK-1:0] mem_rd_bnk_reg;
    reg [BITSROW-1:0] mem_rd_adr_reg;
    reg [BITDWSN-1:0] mem_rd_dwsn_reg;
    always @(posedge clk) begin
      mem_write_reg <= mem_write_tmp;
      mem_wr_bnk_reg <= mem_wr_bnk_tmp;
      mem_wr_adr_reg <= mem_wr_adr_tmp;
      mem_wr_dwsn_reg <= mem_wr_dwsn_tmp;
      mem_bw_reg <= mem_bw_tmp;
      mem_din_reg <= mem_din_tmp;
      mem_read_reg <= mem_read_tmp;
      mem_rd_bnk_reg <= mem_rd_bnk_tmp;
      mem_rd_adr_reg <= mem_rd_adr_tmp;
      mem_rd_dwsn_reg <= mem_rd_dwsn_tmp;
    end
    
    assign mem_write = mem_write_reg;
    assign mem_wr_bnk = mem_wr_bnk_reg;
    assign mem_wr_adr = mem_wr_adr_reg;
    assign mem_wr_dwsn = mem_wr_dwsn_reg;
    assign mem_bw = mem_bw_reg;
    assign mem_din = mem_din_reg;
    assign mem_read = mem_read_reg;
    assign mem_rd_bnk = mem_rd_bnk_reg;
    assign mem_rd_adr = mem_rd_adr_reg;
    assign mem_rd_dwsn = mem_rd_dwsn_reg;
  end else begin: nflpc_loop
    assign mem_write = mem_write_tmp;
    assign mem_wr_bnk = mem_wr_bnk_tmp;
    assign mem_wr_adr = mem_wr_adr_tmp;
    assign mem_wr_dwsn = mem_wr_dwsn_tmp;
    assign mem_bw = mem_bw_tmp;
    assign mem_din = mem_din_tmp;
    assign mem_read = mem_read_tmp;
    assign mem_rd_bnk = mem_rd_bnk_tmp;
    assign mem_rd_adr = mem_rd_adr_tmp;
    assign mem_rd_dwsn = mem_rd_dwsn_tmp;
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
        rd_dat_reg[rd_int] <= din_tmp;
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
  wire rd_fwrd_tmp;
  wire rd_serr_tmp;
  wire rd_derr_tmp;
  wire [BITPADR-1:0] rd_padr_tmp;
  generate if (ENAPAR) begin: pc_loop
    assign rd_dout_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] ? rd_dat_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] : rd_dout_wire;
    assign rd_fwrd_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] || rd_fwrd_wire;
    assign rd_serr_tmp = ^rd_dout_wire && rd_mem_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_derr_tmp = 1'b0;
    assign rd_padr_tmp = (NUMWRDS>1) ? (ENAPADR ? {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_padr_wire} :
                                                  {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]}) :
                                       (ENAPADR ? rd_padr_wire : rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]);
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
    assign rd_fwrd_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] || rd_fwrd_wire;
    assign rd_serr_tmp = rd_sec_err_wire_e && rd_mem_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_derr_tmp = rd_ded_err_wire_e && rd_mem_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_padr_tmp = (NUMWRDS>1) ? (ENAPADR ? {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_padr_wire} :
                                                  {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]}) :
                                       (ENAPADR ? rd_padr_wire : rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]);
  end else if (ENADEC) begin: dc_loop
    wire [WIDTH-1:0] rd_data_wire_d = rd_dout_wire;
    wire [ECCWDTH-1:0] rd_ecc_wire_d = rd_dout_wire >> WIDTH;
    wire [WIDTH-1:0] rd_dup_data_wire_d = rd_dout_wire >> (WIDTH+ECCWDTH);
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
        ecc_dup_check_inst (.din(rd_dup_data_wire_d), .eccin(rd_ecc_wire_d),
                            .dout(), .sec_err(rd_dup_sec_err_wire_d), .ded_err(rd_dup_ded_err_wire_d),
                            .clk(clk), .rst(rst));
     
    assign rd_dout_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] ? rd_dat_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] :
                                                                    rd_ded_err_wire_d ? rd_dup_data_wire_d : rd_corr_data_wire_d;
    assign rd_fwrd_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] || rd_fwrd_wire;
    assign rd_serr_tmp = (((rd_data_wire_d == rd_corr_data_wire_d) && rd_sec_err_wire_d && rd_dup_sec_err_wire_d) ||
                          ((rd_sec_err_wire_d ^ rd_dup_sec_err_wire_d) && !rd_ded_err_wire_d && !rd_dup_ded_err_wire_d)) && rd_vld_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_derr_tmp = (((rd_data_wire_d != rd_corr_data_wire_d) && rd_sec_err_wire_d && rd_dup_sec_err_wire_d) ||
                          rd_ded_err_wire_d || rd_dup_ded_err_wire_d) && rd_vld_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
    assign rd_padr_tmp = (NUMWRDS>1) ? (ENAPADR ? {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_padr_wire} :
                                                  {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]}) :
                                       (ENAPADR ? rd_padr_wire : rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]);
  end else begin: nc_loop
    assign rd_dout_tmp = rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] ? rd_dat_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] : rd_dout_wire;
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

