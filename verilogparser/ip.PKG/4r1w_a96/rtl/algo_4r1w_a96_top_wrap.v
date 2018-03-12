/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_4r1w_a96_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 64, parameter T1_NUMVBNK = 4, parameter T1_BITVBNK = 2, parameter T1_DELAY = 1, parameter T1_NUMVROW = 8192, parameter T1_BITVROW = 13,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 8192, parameter T1_BITSROW = 13, parameter T1_PHYWDTH = 64,
parameter T2_WIDTH = 64, parameter T2_NUMVBNK = 1, parameter T2_BITVBNK = 1, parameter T2_DELAY = 1, parameter T2_NUMVROW = 8192, parameter T2_BITVROW = 13,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 8192, parameter T2_BITSROW = 13, parameter T2_PHYWDTH = 64,

parameter T1_IP_WIDTH = 64, parameter T1_IP_BITWIDTH = 6, parameter T1_IP_NUMADDR = 8192, parameter T1_IP_BITADDR = 13, parameter T1_IP_NUMVBNK = 4, parameter T1_IP_BITVBNK = 2,
parameter T1_IP_SECCBITS = 4, parameter T1_IP_SECCDWIDTH = 3, parameter T1_FLOPIN = 0, parameter T1_FLOPOUT = 0, parameter T1_FLOPMEM = 0, parameter T1_IP_BITPBNK = 3,

parameter T1_T1_WIDTH = 65, parameter T1_T1_NUMVBNK = 4, parameter T1_T1_BITVBNK = 2, parameter T1_T1_DELAY = 1, parameter T1_T1_NUMVROW = 2048, parameter T1_T1_BITVROW = 11,
parameter T1_T1_BITWSPF = 0, parameter T1_T1_NUMWRDS = 1, parameter T1_T1_BITWRDS = 1, parameter T1_T1_NUMSROW = 2048, parameter T1_T1_BITSROW = 11, parameter T1_T1_PHYWDTH = 65,
parameter T1_T2_WIDTH = 65, parameter T1_T2_NUMVBNK = 1, parameter T1_T2_BITVBNK = 1, parameter T1_T2_DELAY = 1, parameter T1_T2_NUMVROW = 2048, parameter T1_T2_BITVROW = 11,
parameter T1_T2_BITWSPF = 0, parameter T1_T2_NUMWRDS = 1, parameter T1_T2_BITWRDS = 1, parameter T1_T2_NUMSROW = 2048, parameter T1_T2_BITSROW = 11, parameter T1_T2_PHYWDTH = 65,

parameter T2_IP_WIDTH = 64, parameter T2_IP_BITWIDTH = 6, parameter T2_IP_NUMADDR = 8192, parameter T2_IP_BITADDR = 13, parameter T2_IP_NUMVBNK = 4, parameter T2_IP_BITVBNK = 2,
parameter T2_IP_SECCBITS = 4, parameter T2_IP_SECCDWIDTH = 3, parameter T2_FLOPIN = 0, parameter T2_FLOPOUT = 0, parameter T2_FLOPMEM = 0, parameter T2_IP_BITPBNK = 3,

parameter T2_T1_WIDTH = 65, parameter T2_T1_NUMVBNK = 4, parameter T2_T1_BITVBNK = 2, parameter T2_T1_DELAY = 1, parameter T2_T1_NUMVROW = 2048, parameter T2_T1_BITVROW = 11,
parameter T2_T1_BITWSPF = 0, parameter T2_T1_NUMWRDS = 1, parameter T2_T1_BITWRDS = 1, parameter T2_T1_NUMSROW = 2048, parameter T2_T1_BITSROW = 11, parameter T2_T1_PHYWDTH = 65,
parameter T2_T2_WIDTH = 65, parameter T2_T2_NUMVBNK = 1, parameter T2_T2_BITVBNK = 1, parameter T2_T2_DELAY = 1, parameter T2_T2_NUMVROW = 2048, parameter T2_T2_BITVROW = 11,
parameter T2_T2_BITWSPF = 0, parameter T2_T2_NUMWRDS = 1, parameter T2_T2_BITWRDS = 1, parameter T2_T2_NUMSROW = 2048, parameter T2_T2_BITSROW = 11, parameter T2_T2_PHYWDTH = 65)
( clk,  rst,  ready,
  write,   wr_adr,   din,
  read,   rd_adr,   rd_dout,   rd_vld,   rd_serr,   rd_derr,   rd_padr,
  t1_readA,   t1_writeA,   t1_addrA,   t1_dinA,   t1_bwA,   t1_doutA,
  t1_readB,   t1_writeB,   t1_addrB,   t1_dinB,   t1_bwB,   t1_doutB,
  t2_readA,   t2_writeA,   t2_addrA,   t2_dinA,   t2_bwA,   t2_doutA,
  t2_readB,   t2_writeB,   t2_addrB,   t2_dinB,   t2_bwB,   t2_doutB,
  t3_readA,   t3_writeA,   t3_addrA,   t3_dinA,   t3_bwA,   t3_doutA,
  t3_readB,   t3_writeB,   t3_addrB,   t3_dinB,   t3_bwB,   t3_doutB,
  t4_readA,   t4_writeA,   t4_addrA,   t4_dinA,   t4_bwA,   t4_doutA,
  t4_readB,   t4_writeB,   t4_addrB,   t4_dinB,   t4_bwB,   t4_doutB);
  
  // MEMOIR_TRANSLATE_OFF
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter PARITY = 1;       // PARITY Parameters
  parameter MEMWDTH = WIDTH+PARITY;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW1 = T1_NUMVROW;
  parameter BITVROW1 = T1_BITVROW;
  parameter NUMVBNK1 = IP_NUMVBNK;
  parameter BITVBNK1 = IP_BITVBNK;
  parameter BITPBNK1 = IP_BITPBNK;
  parameter NUMWRDS1 = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS1 = T1_BITWRDS;
  parameter NUMSROW1 = T1_NUMSROW;
  parameter BITSROW1 = T1_BITSROW;
  parameter PHYWDTH1 = T1_PHYWDTH;
  parameter FLOPIN1 = FLOPIN;
  parameter FLOPOUT1 = FLOPOUT;
  parameter NUMVROW2 = T1_T1_NUMVROW;
  parameter BITVROW2 = T1_T1_BITVROW;
  parameter NUMVBNK2 = T1_IP_NUMVBNK;
  parameter BITVBNK2 = T1_IP_BITVBNK;
  parameter BITPBNK2 = T1_IP_BITPBNK;
  parameter NUMWRDS2 = T1_T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS2 = T1_T1_BITWRDS;
  parameter NUMSROW2 = T1_T1_NUMSROW;
  parameter BITSROW2 = T1_T1_BITSROW;
  parameter PHYWDTH2 = T1_T1_PHYWDTH;
  parameter FLOPIN2 = 0;
  parameter FLOPOUT2 = 0;
  parameter SRAM_DELAY = T1_T1_DELAY;

  parameter BITPADR2 = BITPBNK2+BITSROW2+BITWRDS2+1;
  parameter BITPADR1 = BITPBNK1+BITPADR2+1;

  input                          write;
  input [BITADDR-1:0]            wr_adr;
  input [WIDTH-1:0]              din;

  input [4-1:0]                  read;
  input [4*BITADDR-1:0]          rd_adr;
  output [4-1:0]                 rd_vld;
  output [4*WIDTH-1:0]           rd_dout;
  output [4-1:0]                 rd_serr;
  output [4-1:0]                 rd_derr;
  output [4*BITPADR1-1:0]        rd_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
  output [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_doutA;

  output [NUMVBNK1*NUMVBNK2-1:0] t1_readB;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_writeB;
  output [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrB;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwB;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinB;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_doutB;

  output [NUMVBNK1-1:0] t2_readA;
  output [NUMVBNK1-1:0] t2_writeA;
  output [NUMVBNK1*BITSROW2-1:0] t2_addrA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_bwA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_dinA;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_doutA;

  output [NUMVBNK1-1:0] t2_readB;
  output [NUMVBNK1-1:0] t2_writeB;
  output [NUMVBNK1*BITSROW2-1:0] t2_addrB;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_bwB;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_dinB;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_doutB;

  output [NUMVBNK2-1:0] t3_readA;
  output [NUMVBNK2-1:0] t3_writeA;
  output [NUMVBNK2*BITSROW2-1:0] t3_addrA;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_bwA;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_dinA;
  input [NUMVBNK2*PHYWDTH2-1:0] t3_doutA;
  
  output [NUMVBNK2-1:0] t3_readB;
  output [NUMVBNK2-1:0] t3_writeB;
  output [NUMVBNK2*BITSROW2-1:0] t3_addrB;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_bwB;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_dinB;
  input [NUMVBNK2*PHYWDTH2-1:0] t3_doutB;
  
  output [1-1:0] t4_readA;
  output [1-1:0] t4_writeA;
  output [1*BITSROW2-1:0] t4_addrA;
  output [1*PHYWDTH2-1:0] t4_bwA;
  output [1*PHYWDTH2-1:0] t4_dinA;
  input [1*PHYWDTH2-1:0] t4_doutA;

  output [1-1:0] t4_readB;
  output [1-1:0] t4_writeB;
  output [1*BITSROW2-1:0] t4_addrB;
  output [1*PHYWDTH2-1:0] t4_bwB;
  output [1*PHYWDTH2-1:0] t4_dinB;
  input [1*PHYWDTH2-1:0] t4_doutB;
  
  algo_4r1w_xr_top 
		#(.WIDTH(WIDTH),   .BITWDTH(BITWDTH),   .PARITY(PARITY),   .NUMADDR(NUMADDR),   .BITADDR(BITADDR),   .NUMVROW1(NUMVROW1),   .BITVROW1(BITVROW1),
		.NUMVBNK1(NUMVBNK1),   .BITVBNK1(BITVBNK1),   .BITPBNK1(BITPBNK1),
		.NUMWRDS1(NUMWRDS1),   .BITWRDS1(BITWRDS1),   .NUMSROW1(NUMSROW1),   .BITSROW1(BITSROW1),   .FLOPIN1(FLOPIN1),   .FLOPOUT1(FLOPOUT1),
		.NUMVROW2(NUMVROW2),   .BITVROW2(BITVROW2),   .NUMVBNK2(NUMVBNK2),   .BITVBNK2(BITVBNK2),   .BITPBNK2(BITPBNK2),
		.NUMWRDS2(NUMWRDS2),   .BITWRDS2(BITWRDS2),   .NUMSROW2(NUMSROW2),   .BITSROW2(BITSROW2),
		.FLOPIN2(FLOPIN2),   .FLOPOUT2(FLOPOUT2),   .SRAM_DELAY(SRAM_DELAY),   .FLOPMEM(FLOPMEM))
algo_top
		(.clk(clk), .rst(rst), .ready(ready),
		.write(write), .wr_adr(wr_adr), .din(din),
		.read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
		.t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_bwA(t1_bwA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA),
		.t1_readB(t1_readB), .t1_writeB(t1_writeB), .t1_addrB(t1_addrB), .t1_bwB(t1_bwB), .t1_dinB(t1_dinB), .t1_doutB(t1_doutB),
		.t2_readA(t2_readA), .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_bwA(t2_bwA), .t2_dinA(t2_dinA), .t2_doutA(t2_doutA),
		.t2_readB(t2_readB), .t2_writeB(t2_writeB), .t2_addrB(t2_addrB), .t2_bwB(t2_bwB), .t2_dinB(t2_dinB), .t2_doutB(t2_doutB),
		.t3_readA(t3_readA), .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_bwA(t3_bwA), .t3_dinA(t3_dinA), .t3_doutA(t3_doutA),
		.t3_readB(t3_readB), .t3_writeB(t3_writeB), .t3_addrB(t3_addrB), .t3_bwB(t3_bwB), .t3_dinB(t3_dinB), .t3_doutB(t3_doutB),
		.t4_readA(t4_readA), .t4_writeA(t4_writeA), .t4_addrA(t4_addrA), .t4_bwA(t4_bwA), .t4_dinA(t4_dinA), .t4_doutA(t4_doutA),
		.t4_readB(t4_readB), .t4_writeB(t4_writeB), .t4_addrB(t4_addrB), .t4_bwB(t4_bwB), .t4_dinB(t4_dinB), .t4_doutB(t4_doutB));
		
// MEMOIR_TRANSLATE_ON
  
endmodule    //algo_4r1w_a96_top_wrap
