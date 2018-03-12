/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_1r1w_a24_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 1, parameter T1_DELAY = 2, parameter T1_NUMVROW = 8192, parameter T1_BITVROW = 13,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 2048, parameter T1_BITSROW = 11, parameter T1_PHYWDTH = 32,
parameter T1_NUMRBNK = 4, parameter T1_BITRBNK = 2, parameter T1_NUMRROW = 256, parameter T1_BITRROW = 8, parameter T1_NUMPROW = 8192, parameter T1_BITPROW = 13,
parameter T1_M_NUMVBNK = 4, parameter T1_M_BITVBNK = 2, parameter T1_ISDCR = 0,
parameter T1_BITDWSN = 8, 
parameter T1_NUMDWS0 = 0, parameter T1_NUMDWS1 = 0, parameter T1_NUMDWS2 = 0, parameter T1_NUMDWS3 = 0,
parameter T1_NUMDWS4 = 0, parameter T1_NUMDWS5 = 0, parameter T1_NUMDWS6 = 0, parameter T1_NUMDWS7 = 0,
parameter T1_NUMDWS8 = 0, parameter T1_NUMDWS9 = 0, parameter T1_NUMDWS10 = 0, parameter T1_NUMDWS11 = 0,
parameter T1_NUMDWS12 = 0, parameter T1_NUMDWS13 = 0, parameter T1_NUMDWS14 = 0, parameter T1_NUMDWS15 = 0,

parameter T2_WIDTH = 10, parameter T2_NUMVBNK = 2, parameter T2_BITVBNK = 1, parameter T2_DELAY = 2, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 2048, parameter T2_BITSROW = 11, parameter T2_PHYWDTH = 10,

parameter T3_WIDTH = 32, parameter T3_NUMVBNK = 1, parameter T3_BITVBNK = 1, parameter T3_DELAY = 2, parameter T3_NUMVROW = 2048, parameter T3_BITVROW = 11,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 1, parameter T3_NUMSROW = 2048, parameter T3_BITSROW = 11, parameter T3_PHYWDTH = 32
)
								(clk, rst, ready, refr,
                                write, wr_adr, din,
                                read, rd_adr, rd_vld, rd_serr, rd_derr, rd_dout, rd_padr,
                                t1_writeA, t1_bankA, t1_addrA, t1_bwA, t1_dinA, t1_dwsnA,
                                t1_readB, t1_bankB, t1_addrB, t1_doutB, t1_dwsnB,
                                t1_refrC, t1_bankC,
                                t2_writeA, t2_addrA, t2_readB, t2_addrB, t2_dinA, t2_bwA, t2_doutB,
                                t3_writeA, t3_addrA, t3_readB, t3_addrB, t3_dinA, t3_bwA, t3_doutB);
// MEMOIR_TRANSLATE_OFF
								
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;   // ALGO Parameters
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter REFRESH = IP_REFRESH;      // REFRESH Parameters
  parameter NUMRBNK = T1_NUMRBNK;
  parameter BITWSPF = T1_BITWSPF;
  parameter BITRBNK = T1_BITRBNK;
  parameter NUMRROW = T1_NUMRROW;
  parameter BITRROW = T1_BITRROW;
  parameter REFFREQ = IP_REFFREQ;
  parameter ISDCR   = T1_ISDCR;
  parameter SRAM_DELAY = T2_DELAY;
  parameter DRAM_DELAY = T1_DELAY;
  parameter PHYWDTH = T1_PHYWDTH;
  parameter ECCBITS = IP_SECCBITS;
  
  parameter BITDWSN = T1_BITDWSN;		//DWSN Parameters
  parameter NUMDWS0 = T1_NUMDWS0;
  parameter NUMDWS1 = T1_NUMDWS1;
  parameter NUMDWS2 = T1_NUMDWS2;
  parameter NUMDWS3 = T1_NUMDWS3;
  parameter NUMDWS4 = T1_NUMDWS4;
  parameter NUMDWS5 = T1_NUMDWS5;
  parameter NUMDWS6 = T1_NUMDWS6;
  parameter NUMDWS7 = T1_NUMDWS7;
  parameter NUMDWS8 = T1_NUMDWS8;
  parameter NUMDWS9 = T1_NUMDWS9;
  parameter NUMDWS10 = T1_NUMDWS10;
  parameter NUMDWS11 = T1_NUMDWS11;
  parameter NUMDWS12 = T1_NUMDWS12;
  parameter NUMDWS13 = T1_NUMDWS13;
  parameter NUMDWS14 = T1_NUMDWS14;
  parameter NUMDWS15 = T1_NUMDWS15;
  
  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  input                                refr;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input                                read;
  input [BITADDR-1:0]                  rd_adr;
  output                               rd_vld;
  output [WIDTH-1:0]                   rd_dout;
  output                               rd_serr;
  output                               rd_derr;
  output [BITPADR-1:0]                 rd_padr;

  output                               ready;
  input                                clk, rst;

  output [1-1:0] t1_writeA;
  output [1*BITVBNK-1:0] t1_bankA;
  output [1*BITSROW-1:0] t1_addrA;
  output [1*PHYWDTH-1:0] t1_bwA;
  output [1*PHYWDTH-1:0] t1_dinA;
  output [1*BITDWSN-1:0] t1_dwsnA;

  output [1-1:0] t1_readB;
  output [1*BITVBNK-1:0] t1_bankB;
  output [1*BITSROW-1:0] t1_addrB;
  input  [1*PHYWDTH-1:0] t1_doutB;
  output [1*BITDWSN-1:0] t1_dwsnB;

  output [1-1:0] t1_refrC;
  output [1*BITRBNK-1:0] t1_bankC;

  output [2-1:0] t2_writeA;
  output [2*BITVROW-1:0] t2_addrA;
  output [2*SDOUT_WIDTH-1:0] t2_dinA;
  output [2*SDOUT_WIDTH-1:0] t2_bwA;

  output [2-1:0] t2_readB;
  output [2*BITVROW-1:0] t2_addrB;
  input [2*SDOUT_WIDTH-1:0] t2_doutB;

  output [1-1:0] t3_writeA;
  output [1*BITVROW-1:0] t3_addrA;
  output [1*WIDTH-1:0] t3_dinA;
  output [1*WIDTH-1:0] t3_bwA;

   output [1-1:0] t3_readB;
  output [1*BITVROW-1:0] t3_addrB;
  input [1*WIDTH-1:0] t3_doutB;
  
`ifdef AMP_REF
  wire                               rd_vld_rtl;
  wire [WIDTH-1:0]                   rd_dout_rtl;
  wire                               rd_serr_rtl;
  wire                               rd_derr_rtl;
  wire [BITPADR-1:0]                 rd_padr_rtl;

  task Write;
  input [BITADDR-1:0] addr;
  input [WIDTH-1:0] din;
  begin
    algo_ref.bdw_flag[addr] = 1'b1;
    algo_ref.mem[addr] = din;
  end
  endtask
  
  task Read;
  input [BITADDR-1:0] addr;
  output [WIDTH-1:0] dout;
  begin
`ifdef SUPPORTED
    if (algo_ref.mem.exists(addr))
      dout = algo_ref.mem[addr];
    else
      dout = {WIDTH{1'bx}};
`else
    dout = algo_ref.mem[addr];
`endif
  end
  endtask

  algo_1r1w_ref #(
    .WIDTH(WIDTH), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .MEM_DELAY(T1_DELAY+T2_DELAY+FLOPIN+2*FLOPMEM+FLOPOUT),
    .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK),
    .NUMSROW(NUMSROW), .BITSROW(BITSROW), .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS),
    .BITPADR(BITPADR)) algo_ref (
    .read_0(read), .addr_0(rd_adr), .read_vld_0(rd_vld), .dout_0(rd_dout),
    .read_serr_0(rd_serr), .read_derr_0(rd_derr), .read_padr_0(rd_padr),
    .write_1(write), .addr_1(wr_adr), .din_1(din), .clk(clk), .rst(rst));
`endif

reg H2O_AMP1R1WA24_001_00;
always @(posedge clk)
  H2O_AMP1R1WA24_001_00 <= rst;
wire rst_int = H2O_AMP1R1WA24_001_00 && rst;

  assign t2_bwA = ~0;
  assign t3_bwA = ~0;
  
  algo_1r1w_dl_pseudo_top 
		 #(.WIDTH(WIDTH),   .BITWDTH(BITWDTH),   .NUMADDR(NUMADDR),   .BITADDR(BITADDR),   .NUMVROW(NUMVROW),   .BITVROW(BITVROW),
			.NUMVBNK(NUMVBNK),   .BITVBNK(BITVBNK),   .BITPBNK(BITPBNK),   .NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW),
			.REFRESH(REFRESH),   .NUMRBNK(NUMRBNK),   .BITWSPF(BITWSPF),  .BITRBNK(BITRBNK),   .NUMRROW(NUMRROW),   .BITRROW(BITRROW),   .REFFREQ(REFFREQ),   .ISDCR(ISDCR),
			.SRAM_DELAY(SRAM_DELAY),   .DRAM_DELAY(DRAM_DELAY), .FLOPIN(FLOPIN),   .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT),   .PHYWDTH(PHYWDTH),   .ECCBITS(ECCBITS),
			.NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
			.NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
			.NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
			.NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15),
			.BITDWSN (BITDWSN))
algo_top
		(.clk(clk), .rst(rst_int), .ready(ready), .refr(refr),
		.write(write), .wr_adr(wr_adr), .din(din),
`ifdef AMP_REF
		.read(read), .rd_adr(rd_adr), .rd_vld(rd_vld_rtl), .rd_serr(rd_serr_rtl), .rd_derr(rd_derr_rtl), .rd_dout(rd_dout_rtl), .rd_padr(rd_padr_rtl),
`else
		.read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_dout(rd_dout), .rd_padr(rd_padr),
`endif
		.t1_writeA(t1_writeA), .t1_bankA(t1_bankA), .t1_addrA(t1_addrA), .t1_bwA(t1_bwA), .t1_dinA(t1_dinA), .t1_dwsnA(t1_dwsnA),
		.t1_readB(t1_readB), .t1_bankB(t1_bankB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB), .t1_dwsnB(t1_dwsnB),
		.t1_refrC(t1_refrC), .t1_bankC(t1_bankC),
		.t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_dinA(t2_dinA), .t2_doutB(t2_doutB),
		.t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_dinA(t3_dinA), .t3_doutB(t3_doutB));

// MEMOIR_TRANSLATE_ON
endmodule    //algo_1r1w_a24_top_wrap
