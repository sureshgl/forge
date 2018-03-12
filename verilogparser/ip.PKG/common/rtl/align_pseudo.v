module align_pseudo (write, wr_bnk, wr_adr, din,
		     read, rd_bnk, rd_adr, dout, serr, padr,
	             mem_write, mem_wr_bnk, mem_wr_adr, mem_wr_dwsn, mem_bw, mem_din,
		     mem_read, mem_rd_bnk, mem_rd_adr, mem_rd_dwsn, mem_dout, clk);

  parameter WIDTH = 32;
  parameter PARITY = 1;  
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter NUMWRDS = 4;
  parameter BITWRDS = 2;
  parameter BITPADR = 10;
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
  parameter SRAM_DELAY = 2;
  parameter FLOPMEM = 0;

  parameter MEMWDTH = WIDTH+PARITY;

  input write;
  input [BITVBNK-1:0] wr_bnk;
  input [BITVROW-1:0] wr_adr;
  input [WIDTH-1:0] din;
  input read;
  input [BITVBNK-1:0] rd_bnk;
  input [BITVROW-1:0] rd_adr;
  output [WIDTH-1:0] dout;
  output             serr;
  output [BITPADR-1:0] padr;

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
  input [NUMWRDS*MEMWDTH-1:0] mem_dout;

  input clk;

  wire [BITWRDS-1:0] wr_wadr;
  wire [BITSROW-1:0] wr_radr;
  generate if (BITWRDS>0) begin: wr_loop
    np2_addr #(
      .NUMADDR (NUMVROW), .BITADDR (BITVROW),
      .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
      .NUMVROW (NUMSROW), .BITVROW (BITSROW))
      np2_addr_inst (.vbadr(wr_wadr), .vradr(wr_radr), .vaddr(wr_adr));
  end else begin: no_wr_loop
    assign wr_wadr = 0;
    assign wr_radr = wr_adr;
  end
  endgenerate

  wire [BITWRDS-1:0] rd_wadr;
  wire [BITSROW-1:0] rd_radr;
  generate if (BITWRDS>0) begin: rd_loop
    np2_addr #(
      .NUMADDR (NUMVROW), .BITADDR (BITVROW),
      .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
      .NUMVROW (NUMSROW), .BITVROW (BITSROW))
      np2_addr_inst (.vbadr(rd_wadr), .vradr(rd_radr), .vaddr(rd_adr));
  end else begin: no_rd_loop
    assign rd_wadr = 0;
    assign rd_radr = rd_adr;
  end
  endgenerate

  assign mem_write = write;
  assign mem_wr_bnk = wr_bnk;
  assign mem_wr_adr = wr_radr;
  assign mem_bw = {MEMWDTH{1'b1}} << (wr_wadr*MEMWDTH);
  assign mem_din = {(PARITY && ^din),din} << (wr_wadr*MEMWDTH);

  assign mem_read = read;
  assign mem_rd_bnk = rd_bnk;
  assign mem_rd_adr = rd_radr;
  wire [NUMWRDS*MEMWDTH-1:0] mem_br = {MEMWDTH{1'b1}} << (rd_wadr*MEMWDTH);

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

  reg [BITDWSN-1:0] mem_wr_dwsn;
  integer wrdw_int;
  always_comb begin
    mem_wr_dwsn = ~0;
    for (wrdw_int=0; wrdw_int<BITDWSN; wrdw_int=wrdw_int+1)
      if (wrdw_int<16) begin
             if ((wrdw_int==0)  && NUMDWS0)   mem_wr_dwsn[wrdw_int]  = !(|(~(~0 << NUMDWS0)  & (mem_bw >> 0)));
        else if ((wrdw_int==1)  && NUMDWS1)   mem_wr_dwsn[wrdw_int]  = !(|(~(~0 << NUMDWS1)  & (mem_bw >> SDWS0)));
        else if ((wrdw_int==2)  && NUMDWS2)   mem_wr_dwsn[wrdw_int]  = !(|(~(~0 << NUMDWS2)  & (mem_bw >> SDWS1)));
        else if ((wrdw_int==3)  && NUMDWS3)   mem_wr_dwsn[wrdw_int]  = !(|(~(~0 << NUMDWS3)  & (mem_bw >> SDWS2)));
        else if ((wrdw_int==4)  && NUMDWS4)   mem_wr_dwsn[wrdw_int]  = !(|(~(~0 << NUMDWS4)  & (mem_bw >> SDWS3)));
        else if ((wrdw_int==5)  && NUMDWS5)   mem_wr_dwsn[wrdw_int]  = !(|(~(~0 << NUMDWS5)  & (mem_bw >> SDWS4)));
        else if ((wrdw_int==6)  && NUMDWS6)   mem_wr_dwsn[wrdw_int]  = !(|(~(~0 << NUMDWS6)  & (mem_bw >> SDWS5)));
        else if ((wrdw_int==7)  && NUMDWS7)   mem_wr_dwsn[wrdw_int]  = !(|(~(~0 << NUMDWS7)  & (mem_bw >> SDWS6)));
        else if ((wrdw_int==8)  && NUMDWS8)   mem_wr_dwsn[wrdw_int]  = !(|(~(~0 << NUMDWS8)  & (mem_bw >> SDWS7)));
        else if ((wrdw_int==9)  && NUMDWS9)   mem_wr_dwsn[wrdw_int]  = !(|(~(~0 << NUMDWS9)  & (mem_bw >> SDWS8)));
        else if ((wrdw_int==10) && NUMDWS10)  mem_wr_dwsn[wrdw_int]  = !(|(~(~0 << NUMDWS10) & (mem_bw >> SDWS9)));
        else if ((wrdw_int==11) && NUMDWS11)  mem_wr_dwsn[wrdw_int]  = !(|(~(~0 << NUMDWS11) & (mem_bw >> SDWS10)));
        else if ((wrdw_int==12) && NUMDWS12)  mem_wr_dwsn[wrdw_int]  = !(|(~(~0 << NUMDWS12) & (mem_bw >> SDWS11)));
        else if ((wrdw_int==13) && NUMDWS13)  mem_wr_dwsn[wrdw_int]  = !(|(~(~0 << NUMDWS13) & (mem_bw >> SDWS12)));
        else if ((wrdw_int==14) && NUMDWS14)  mem_wr_dwsn[wrdw_int]  = !(|(~(~0 << NUMDWS14) & (mem_bw >> SDWS13)));
        else if ((wrdw_int==15) && NUMDWS15)  mem_wr_dwsn[wrdw_int]  = !(|(~(~0 << NUMDWS15) & (mem_bw >> SDWS14)));
      end else
        mem_wr_dwsn[wrdw_int] = 0;
  end

  reg [BITDWSN-1:0] mem_rd_dwsn;
  integer rddw_int;
  always_comb begin
    mem_rd_dwsn = ~0;
    for (rddw_int=0; rddw_int<BITDWSN; rddw_int=rddw_int+1)
      if (rddw_int<16) begin
             if ((rddw_int==0)  && NUMDWS0)   mem_rd_dwsn[rddw_int]  = !(|(~(~0 << NUMDWS0)  & (mem_br >> 0)));
        else if ((rddw_int==1)  && NUMDWS1)   mem_rd_dwsn[rddw_int]  = !(|(~(~0 << NUMDWS1)  & (mem_br >> SDWS0)));
        else if ((rddw_int==2)  && NUMDWS2)   mem_rd_dwsn[rddw_int]  = !(|(~(~0 << NUMDWS2)  & (mem_br >> SDWS1)));
        else if ((rddw_int==3)  && NUMDWS3)   mem_rd_dwsn[rddw_int]  = !(|(~(~0 << NUMDWS3)  & (mem_br >> SDWS2)));
        else if ((rddw_int==4)  && NUMDWS4)   mem_rd_dwsn[rddw_int]  = !(|(~(~0 << NUMDWS4)  & (mem_br >> SDWS3)));
        else if ((rddw_int==5)  && NUMDWS5)   mem_rd_dwsn[rddw_int]  = !(|(~(~0 << NUMDWS5)  & (mem_br >> SDWS4)));
        else if ((rddw_int==6)  && NUMDWS6)   mem_rd_dwsn[rddw_int]  = !(|(~(~0 << NUMDWS6)  & (mem_br >> SDWS5)));
        else if ((rddw_int==7)  && NUMDWS7)   mem_rd_dwsn[rddw_int]  = !(|(~(~0 << NUMDWS7)  & (mem_br >> SDWS6)));
        else if ((rddw_int==8)  && NUMDWS8)   mem_rd_dwsn[rddw_int]  = !(|(~(~0 << NUMDWS8)  & (mem_br >> SDWS7)));
        else if ((rddw_int==9)  && NUMDWS9)   mem_rd_dwsn[rddw_int]  = !(|(~(~0 << NUMDWS9)  & (mem_br >> SDWS8)));
        else if ((rddw_int==10) && NUMDWS10)  mem_rd_dwsn[rddw_int]  = !(|(~(~0 << NUMDWS10) & (mem_br >> SDWS9)));
        else if ((rddw_int==11) && NUMDWS11)  mem_rd_dwsn[rddw_int]  = !(|(~(~0 << NUMDWS11) & (mem_br >> SDWS10)));
        else if ((rddw_int==12) && NUMDWS12)  mem_rd_dwsn[rddw_int]  = !(|(~(~0 << NUMDWS12) & (mem_br >> SDWS11)));
        else if ((rddw_int==13) && NUMDWS13)  mem_rd_dwsn[rddw_int]  = !(|(~(~0 << NUMDWS13) & (mem_br >> SDWS12)));
        else if ((rddw_int==14) && NUMDWS14)  mem_rd_dwsn[rddw_int]  = !(|(~(~0 << NUMDWS14) & (mem_br >> SDWS13)));
        else if ((rddw_int==15) && NUMDWS15)  mem_rd_dwsn[rddw_int]  = !(|(~(~0 << NUMDWS15) & (mem_br >> SDWS14)));
      end else
        mem_rd_dwsn[rddw_int] = 0;
  end

  reg [BITVBNK-1:0] rd_bnk_reg [0:SRAM_DELAY+FLOPMEM-1];
  reg [BITWRDS-1:0] rd_wadr_reg [0:SRAM_DELAY+FLOPMEM-1];
  reg [BITSROW-1:0] rd_radr_reg [0:SRAM_DELAY+FLOPMEM-1];
  integer rd_int;
  always @(posedge clk)
    for (rd_int=SRAM_DELAY+FLOPMEM-1; rd_int>=0; rd_int=rd_int-1)
      if (rd_int>0) begin
	rd_bnk_reg[rd_int] <= rd_bnk_reg[rd_int-1];
	rd_wadr_reg[rd_int] <= rd_wadr_reg[rd_int-1];
        rd_radr_reg[rd_int] <= rd_radr_reg[rd_int-1];
      end else begin
	rd_bnk_reg[rd_int] <= rd_bnk;
	rd_wadr_reg[rd_int] <= rd_wadr;
	rd_radr_reg[rd_int] <= rd_radr;
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

  wire               dout_bit_err = 0;
  wire [15:0]        dout_bit_pos = 0;
  wire [MEMWDTH-1:0] dout_bit_mask = dout_bit_err << dout_bit_pos;
  wire               dout_serr_mask = |dout_bit_mask;

  wire [MEMWDTH-1:0] dout_wire = mem_dout_tmp >> (rd_wadr_reg[SRAM_DELAY+FLOPMEM-1]*MEMWDTH);
  assign dout = dout_wire ^ dout_bit_mask;
  assign serr = PARITY ? ^dout : 1'b0;
  assign padr = (NUMWRDS>1) ? {rd_wadr_reg[SRAM_DELAY+FLOPMEM-1],rd_radr_reg[SRAM_DELAY+FLOPMEM-1]} : rd_radr_reg[SRAM_DELAY+FLOPMEM-1];

endmodule
