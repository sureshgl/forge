/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 *
 * */

module algo_4ror1w_a194_top_wrap
#(parameter IP_WIDTH = 64, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 8, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13,
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3,
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 64, parameter T1_NUMVBNK = 2, parameter T1_BITVBNK = 1, parameter T1_DELAY = 2, parameter T1_NUMVROW = 16384, parameter T1_BITVROW = 14,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 16384, parameter T1_BITSROW = 14, parameter T1_PHYWDTH = 64,
parameter T2_WIDTH = 64, parameter T2_NUMVBNK = 1, parameter T2_BITVBNK = 1, parameter T2_DELAY = 2, parameter T2_NUMVROW = 16384, parameter T2_BITVROW = 14,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 16384, parameter T2_BITSROW = 14, parameter T2_PHYWDTH = 64,

parameter T1_IP_WIDTH = 64, parameter T1_IP_BITWIDTH = 6, parameter T1_IP_NUMADDR = 16384, parameter T1_IP_BITADDR = 14, parameter T1_IP_NUMVBNK = 2, parameter T1_IP_BITVBNK = 1,
parameter T1_IP_SECCBITS = 4, parameter T1_IP_SECCDWIDTH = 2, parameter T1_FLOPIN = 0, parameter T1_FLOPOUT = 0, parameter T1_FLOPMEM = 0, parameter T1_FLOPECC = 0,
parameter T1_IP_REFRESH = 1, parameter T1_IP_REFFREQ = 24, parameter T1_IP_REFFRHF = 1, parameter T1_IP_BITPBNK = 2, parameter T1_IP_ENAECC = 0, parameter T1_IP_ENAPAR = 0,

parameter T1_T1_WIDTH = 64, parameter T1_T1_NUMVBNK = 2, parameter T1_T1_BITVBNK = 1, parameter T1_T1_DELAY = 2, parameter T1_T1_NUMVROW = 8192, parameter T1_T1_BITVROW = 13,
parameter T1_T1_BITWSPF = 0, parameter T1_T1_NUMWRDS = 1, parameter T1_T1_BITWRDS = 1, parameter T1_T1_NUMSROW = 8192, parameter T1_T1_BITSROW = 13, parameter T1_T1_PHYWDTH = 64,
parameter T1_T1_NUMRBNK = 2, parameter T1_T1_BITRBNK = 1, parameter T1_T1_NUMRROW = 256, parameter T1_T1_BITRROW = 8, parameter T1_T1_NUMPROW = 8192, parameter T1_T1_BITPROW = 13,
parameter T1_T1_BITDWSN = 8,
parameter T1_T1_NUMDWS0 = 0, parameter T1_T1_NUMDWS1 = 0, parameter T1_T1_NUMDWS2 = 0, parameter T1_T1_NUMDWS3 = 0,
parameter T1_T1_NUMDWS4 = 0, parameter T1_T1_NUMDWS5 = 0, parameter T1_T1_NUMDWS6 = 0, parameter T1_T1_NUMDWS7 = 0,
parameter T1_T1_NUMDWS8 = 0, parameter T1_T1_NUMDWS9 = 0, parameter T1_T1_NUMDWS10 = 0, parameter T1_T1_NUMDWS11 = 0,
parameter T1_T1_NUMDWS12 = 0, parameter T1_T1_NUMDWS13 = 0, parameter T1_T1_NUMDWS14 = 0, parameter T1_T1_NUMDWS15 = 0,

parameter T1_T2_WIDTH = 64, parameter T1_T2_NUMVBNK = 1, parameter T1_T2_BITVBNK = 1, parameter T1_T2_DELAY = 2, parameter T1_T2_NUMVROW = 8192, parameter T1_T2_BITVROW = 13,
parameter T1_T2_BITWSPF = 0, parameter T1_T2_NUMWRDS = 1, parameter T1_T2_BITWRDS = 1, parameter T1_T2_NUMSROW = 8192, parameter T1_T2_BITSROW = 13, parameter T1_T2_PHYWDTH = 64,
parameter T1_T2_NUMRBNK = 2, parameter T1_T2_BITRBNK = 1, parameter T1_T2_NUMRROW = 256, parameter T1_T2_BITRROW = 8, parameter T1_T2_NUMPROW = 8192, parameter T1_T2_BITPROW = 13,
//Not Declaring T1_T2 DWSN

parameter T2_IP_WIDTH = 64, parameter T2_IP_BITWIDTH = 6, parameter T2_IP_NUMADDR = 16384, parameter T2_IP_BITADDR = 14, parameter T2_IP_NUMVBNK = 2, parameter T2_IP_BITVBNK = 1,
parameter T2_IP_SECCBITS = 4, parameter T2_IP_SECCDWIDTH = 2, parameter T2_FLOPIN = 0, parameter T2_FLOPOUT = 0, parameter T2_FLOPMEM = 0, parameter T2_FLOPECC = 0,
parameter T2_IP_REFRESH = 1, parameter T2_IP_REFFREQ = 24, parameter T2_IP_REFFRHF = 1, parameter T2_IP_BITPBNK = 2, parameter T2_IP_ENAECC = 0, parameter T2_IP_ENAPAR = 0,

parameter T2_T1_WIDTH = 64, parameter T2_T1_NUMVBNK = 2, parameter T2_T1_BITVBNK = 1, parameter T2_T1_DELAY = 2, parameter T2_T1_NUMVROW = 8192, parameter T2_T1_BITVROW = 13,
parameter T2_T1_BITWSPF = 0, parameter T2_T1_NUMWRDS = 1, parameter T2_T1_BITWRDS = 1, parameter T2_T1_NUMSROW = 8192, parameter T2_T1_BITSROW = 13, parameter T2_T1_PHYWDTH = 64,
parameter T2_T1_NUMRBNK = 2, parameter T2_T1_BITRBNK = 1, parameter T2_T1_NUMRROW = 256, parameter T2_T1_BITRROW = 8, parameter T2_T1_NUMPROW = 8192, parameter T2_T1_BITPROW = 13,
//Not Declaring T2_T1 DWSN

parameter T2_T2_WIDTH = 64, parameter T2_T2_NUMVBNK = 1, parameter T2_T2_BITVBNK = 1, parameter T2_T2_DELAY = 2, parameter T2_T2_NUMVROW = 8192, parameter T2_T2_BITVROW = 13,
parameter T2_T2_BITWSPF = 0, parameter T2_T2_NUMWRDS = 1, parameter T2_T2_BITWRDS = 1, parameter T2_T2_NUMSROW = 8192, parameter T2_T2_BITSROW = 13, parameter T2_T2_PHYWDTH = 64,
parameter T2_T2_NUMRBNK = 2, parameter T2_T2_BITRBNK = 1, parameter T2_T2_NUMRROW = 256, parameter T2_T2_BITRROW = 8, parameter T2_T2_NUMPROW = 8192, parameter T2_T2_BITPROW = 13
//Not Declaring T2_T2 DWSN
)
( clk,  rst,  ready,  refr,
 write,  wr_adr,  din,
 read,  rd_adr,  rd_dout,  rd_vld,  rd_serr,  rd_derr,  rd_padr,
 t1_readA,  t1_writeA,  t1_addrA,  t1_dinA,  t1_bwA,  t1_doutA,  t1_read_serrA,  t1_dwsnA,
 t1_refrB,  t1_bankB,
 t2_readA,  t2_writeA,  t2_addrA,  t2_dinA,  t2_bwA,  t2_doutA,  t2_read_serrA,  t2_dwsnA,
 t2_refrB,  t2_bankB,
 t3_readA,  t3_writeA,  t3_addrA,  t3_dinA,  t3_bwA,  t3_doutA,  t3_read_serrA,  t3_dwsnA,
 t3_refrB,  t3_bankB,
 t4_readA,  t4_writeA,  t4_addrA,  t4_dinA,  t4_bwA,  t4_doutA,  t4_read_serrA,  t4_dwsnA,
 t4_refrB,  t4_bankB);

 // MEMOIR_TRANSLATE_OFF

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAEXT = 1;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter MEMWDTH = ENAEXT ? WIDTH : ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW1 = T1_NUMVROW;
  parameter BITVROW1 = T1_BITVROW;
  parameter NUMVBNK1 = IP_NUMVBNK;
  parameter BITVBNK1 = IP_BITVBNK;
  parameter BITPBNK1 = IP_BITPBNK;
  parameter FLOPIN1 = FLOPIN;
  parameter FLOPOUT1 = FLOPOUT;
  parameter NUMVROW2 = T1_T1_NUMVROW;
  parameter BITVROW2 = T1_T1_BITVROW;
  parameter NUMVBNK2 = T1_IP_NUMVBNK;
  parameter BITVBNK2 = T1_IP_BITVBNK;
  parameter BITPBNK2 = T1_IP_BITPBNK;
  parameter FLOPIN2 = 1;
  parameter FLOPOUT2 = 1;
  parameter NUMWRDS2 = T1_T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS2 = T1_T1_BITWRDS;
  parameter NUMSROW2 = T1_T1_NUMSROW;
  parameter BITSROW2 = T1_T1_BITSROW;
  parameter PHYWDTH2 = T1_T1_PHYWDTH;
  parameter REFRESH = IP_REFRESH;      // REFRESH Parameters
  parameter NUMRBNK = T1_T1_NUMRBNK;
  parameter BITWSPF = T1_T1_BITWSPF;
  parameter BITRBNK = T1_T1_BITRBNK;
  parameter REFLOPW = 0;
  parameter NUMRROW = T1_T1_NUMRROW;
  parameter BITRROW = T1_T1_BITRROW;
  parameter REFFREQ = IP_REFFREQ;
  parameter REFFRHF = IP_REFFRHF;

  parameter BITDWSN = T1_T1_BITDWSN;		//DWSN Parameters
  parameter NUMDWS0 = T1_T1_NUMDWS0;
  parameter NUMDWS1 = T1_T1_NUMDWS1;
  parameter NUMDWS2 = T1_T1_NUMDWS2;
  parameter NUMDWS3 = T1_T1_NUMDWS3;
  parameter NUMDWS4 = T1_T1_NUMDWS4;
  parameter NUMDWS5 = T1_T1_NUMDWS5;
  parameter NUMDWS6 = T1_T1_NUMDWS6;
  parameter NUMDWS7 = T1_T1_NUMDWS7;
  parameter NUMDWS8 = T1_T1_NUMDWS8;
  parameter NUMDWS9 = T1_T1_NUMDWS9;
  parameter NUMDWS10 = T1_T1_NUMDWS10;
  parameter NUMDWS11 = T1_T1_NUMDWS11;
  parameter NUMDWS12 = T1_T1_NUMDWS12;
  parameter NUMDWS13 = T1_T1_NUMDWS13;
  parameter NUMDWS14 = T1_T1_NUMDWS14;
  parameter NUMDWS15 = T1_T1_NUMDWS15;

  parameter SRAM_DELAY = T1_T1_DELAY;

  parameter BITPADR2 = BITPBNK2+BITSROW2+BITWRDS2;
  parameter BITPADR1 = BITPBNK1+BITPADR2+1;

  input                                refr;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input [4-1:0]                        read;
  input [4*BITADDR-1:0]                rd_adr;
  output [4-1:0]                       rd_vld;
  output [4*WIDTH-1:0]                 rd_dout;
  output [4-1:0]                       rd_serr;
  output [4-1:0]                       rd_derr;
  output [4*BITPADR1-1:0]              rd_padr;

  output                               ready;
  input                                clk, rst;

  output [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
  output [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrA;
  output [NUMVBNK1*NUMVBNK2*BITDWSN-1:0] t1_dwsnA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_doutA;
  input [NUMVBNK1*NUMVBNK2-1:0] t1_read_serrA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_refrB;
  output [NUMVBNK1*NUMVBNK2*BITRBNK-1:0] t1_bankB;

  output [NUMVBNK1-1:0] t2_readA;
  output [NUMVBNK1-1:0] t2_writeA;
  output [NUMVBNK1*BITSROW2-1:0] t2_addrA;
  output [NUMVBNK1*BITDWSN-1:0] t2_dwsnA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_bwA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_dinA;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_doutA;
  input [NUMVBNK1-1:0] t2_read_serrA;
  output [NUMVBNK1-1:0] t2_refrB;
  output [NUMVBNK1*BITRBNK-1:0] t2_bankB;

  output [NUMVBNK2-1:0] t3_readA;
  output [NUMVBNK2-1:0] t3_writeA;
  output [NUMVBNK2*BITSROW2-1:0] t3_addrA;
  output [NUMVBNK2*BITDWSN-1:0] t3_dwsnA;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_bwA;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_dinA;
  input [NUMVBNK2*PHYWDTH2-1:0] t3_doutA;
  input [NUMVBNK2-1:0] t3_read_serrA;
  output [NUMVBNK2-1:0] t3_refrB;
  output [NUMVBNK2*BITRBNK-1:0] t3_bankB;

  output [1-1:0] t4_readA;
  output [1-1:0] t4_writeA;
  output [1*BITSROW2-1:0] t4_addrA;
  output [1*BITDWSN-1:0] t4_dwsnA;
  output [1*PHYWDTH2-1:0] t4_bwA;
  output [1*PHYWDTH2-1:0] t4_dinA;
  input [1*PHYWDTH2-1:0] t4_doutA;
  input [1-1:0] t4_read_serrA;
  output [1-1:0] t4_refrB;
  output [1*BITRBNK-1:0] t4_bankB;

  algo_4ror1w_top
		   #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAEXT(ENAEXT), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ECCWDTH(ECCWDTH),
                     .NUMADDR(NUMADDR),   .BITADDR(BITADDR),
		  .NUMVROW1(NUMVROW1),   .BITVROW1(BITVROW1),   .NUMVBNK1(NUMVBNK1),   .BITVBNK1(BITVBNK1),   .BITPBNK1(BITPBNK1),
		  .FLOPIN1(FLOPIN1),   .FLOPOUT1(FLOPOUT1),   .NUMVROW2(NUMVROW2),   .BITVROW2(BITVROW2),
		  .NUMVBNK2(NUMVBNK2),   .BITVBNK2(BITVBNK2),   .BITPBNK2(BITPBNK2), .PHYWDTH2(PHYWDTH2),
		  .FLOPIN2(FLOPIN2),   .FLOPOUT2(FLOPOUT2),
		  .NUMWRDS2(NUMWRDS2),   .BITWRDS2(BITWRDS2),   .NUMSROW2(NUMSROW2),   .BITSROW2(BITSROW2),
		  .REFRESH(REFRESH),   .NUMRBNK(NUMRBNK),   .BITWSPF(BITWSPF),  .BITRBNK(BITRBNK),   .REFLOPW(REFLOPW),
		  .NUMRROW(NUMRROW),   .BITRROW(BITRROW),   .REFFREQ(REFFREQ),   .REFFRHF(REFFRHF),
		  .NUMDWS0(NUMDWS0),   .NUMDWS1(NUMDWS1),   .NUMDWS2(NUMDWS2),   .NUMDWS3(NUMDWS3),
		  .NUMDWS4(NUMDWS4),   .NUMDWS5(NUMDWS5),   .NUMDWS6(NUMDWS6),   .NUMDWS7(NUMDWS7),
		  .NUMDWS8(NUMDWS8),   .NUMDWS9(NUMDWS9),   .NUMDWS10(NUMDWS10),   .NUMDWS11(NUMDWS11),
		  .NUMDWS12(NUMDWS12),   .NUMDWS13(NUMDWS13),   .NUMDWS14(NUMDWS14),   .NUMDWS15(NUMDWS15),
		  .BITDWSN(BITDWSN),   .SRAM_DELAY(SRAM_DELAY), .FLOPECC(FLOPECC), .FLOPMEM(FLOPMEM))
  algo_top
		(.refr(refr), .clk(clk), .rst(rst), .ready(ready),
		.write(write), .wr_adr(wr_adr), .din(din),
		.read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
		.t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dwsnA(t1_dwsnA), .t1_bwA(t1_bwA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA), .t1_serrA(t1_read_serrA), .t1_refrB(t1_refrB), .t1_bankB(t1_bankB),
		.t2_readA(t2_readA), .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dwsnA(t2_dwsnA), .t2_bwA(t2_bwA), .t2_dinA(t2_dinA), .t2_doutA(t2_doutA), .t2_serrA(t2_read_serrA), .t2_refrB(t2_refrB), .t2_bankB(t2_bankB),
		.t3_readA(t3_readA), .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dwsnA(t3_dwsnA), .t3_bwA(t3_bwA), .t3_dinA(t3_dinA), .t3_doutA(t3_doutA), .t3_serrA(t3_read_serrA), .t3_refrB(t3_refrB), .t3_bankB(t3_bankB),
		.t4_readA(t4_readA), .t4_writeA(t4_writeA), .t4_addrA(t4_addrA), .t4_dwsnA(t4_dwsnA), .t4_bwA(t4_bwA), .t4_dinA(t4_dinA), .t4_doutA(t4_doutA), .t4_serrA(t4_read_serrA), .t4_refrB(t4_refrB), .t4_bankB(t4_bankB));

// MEMOIR_TRANSLATE_ON

endmodule    //algo_4ror1w_a194_top_wrap
