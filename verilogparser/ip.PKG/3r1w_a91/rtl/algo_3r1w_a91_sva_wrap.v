/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_3r1w_a91_sva_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

//Special Params.
parameter IP_NUMVROW1 = 8192,	//Num rows for Higher level algo ... = T3_NUMBNKS*T1_NUMVROW
parameter IP_BITVROW1 = 13, 	// lg of above
parameter IP_BITPBNK2 = 3,		// lg of (T3_NUMBNKS+1)

parameter T1_WIDTH = 49, parameter T1_NUMVBNK = 8, parameter T1_BITVBNK = 3, parameter T1_DELAY = 1, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 2048, parameter T1_BITSROW = 11, parameter T1_PHYWDTH = 49,
parameter T2_WIDTH = 49, parameter T2_NUMVBNK = 2, parameter T2_BITVBNK = 1, parameter T2_DELAY = 1, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 2048, parameter T2_BITSROW = 11, parameter T2_PHYWDTH = 49,
parameter T3_WIDTH = 49, parameter T3_NUMVBNK = 4, parameter T3_BITVBNK = 2, parameter T3_DELAY = 1, parameter T3_NUMVROW = 2048, parameter T3_BITVROW = 11,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 1, parameter T3_NUMSROW = 2048, parameter T3_BITSROW = 11, parameter T3_PHYWDTH = 49)
( clk,  rst,  ready,
 write,  wr_adr,  din,
 read,  rd_adr,  rd_dout,  rd_vld,  rd_serr,  rd_derr,  rd_padr,
 t1_readA,  t1_writeA,  t1_addrA,  t1_dinA,  t1_bwA,  t1_doutA,
 t1_readB,  t1_writeB,  t1_addrB,  t1_dinB,  t1_bwB,  t1_doutB,
 t2_readA,  t2_writeA,  t2_addrA,  t2_dinA,  t2_bwA,  t2_doutA,
 t2_readB,  t2_writeB,  t2_addrB,  t2_dinB,  t2_bwB,  t2_doutB,
 t3_readA,  t3_writeA,  t3_addrA,  t3_dinA,  t3_bwA,  t3_doutA,
 t3_readB,  t3_writeB,  t3_addrB,  t3_dinB,  t3_bwB,  t3_doutB);
 
 
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter PARITY = 1;
  parameter MEMWDTH = WIDTH+PARITY;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW1 = IP_NUMVROW1;   // ALGO1 Parameters
  parameter BITVROW1 = IP_BITVROW1;
  parameter NUMVBNK1 = T2_NUMVBNK;
  parameter BITVBNK1 = T2_BITVBNK;
  parameter BITPBNK1 = IP_BITPBNK;
  parameter NUMWRDS1 = T3_NUMWRDS;
  parameter BITWRDS1 = T3_BITWRDS;
  parameter NUMSROW1 = T3_NUMSROW;
  parameter BITSROW1 = T3_BITSROW;
  parameter PHYWDTH1 = NUMWRDS1*MEMWDTH;
  parameter FLOPIN1 = FLOPIN;
  parameter FLOPOUT1 = FLOPOUT;
  parameter NUMVROW2 = T1_NUMVROW;    // ALGO2 Parameters
  parameter BITVROW2 = T1_BITVROW;
  parameter NUMVBNK2 = T3_NUMVBNK;
  parameter BITVBNK2 = T3_BITVBNK;
  parameter BITPBNK2 = IP_BITPBNK2;
  parameter NUMWRDS2 = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS2 = T1_BITWRDS;
  parameter NUMSROW2 = T1_NUMSROW;
  parameter BITSROW2 = T1_BITSROW;
  parameter PHYWDTH2 = NUMWRDS2*MEMWDTH;
  parameter FLOPIN2 = 0;
  parameter FLOPOUT2 = 0;
  parameter SRAM_DELAY = T1_DELAY;

  parameter BITPADR3 = BITVBNK2+BITSROW2+BITWRDS2+1;
  parameter BITPADR2 = BITPBNK2+BITSROW2+BITWRDS2+1;
  parameter BITPADR1 = BITPBNK1+BITPADR2+1;
  
  input                          write;
  input [BITADDR-1:0]            wr_adr;
  input [WIDTH-1:0]              din;

  input [3-1:0]                  read;
  input [3*BITADDR-1:0]          rd_adr;
  input [3-1:0]                 rd_vld;
  input [3*WIDTH-1:0]           rd_dout;
  input [3-1:0]                 rd_serr;
  input [3-1:0]                 rd_derr;
  input [3*BITPADR1-1:0]        rd_padr;

  input                         ready;
  input                          clk, rst;

  input [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
  input [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
  input [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrA;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_doutA;

  input [NUMVBNK1*NUMVBNK2-1:0] t1_readB;
  input [NUMVBNK1*NUMVBNK2-1:0] t1_writeB;
  input [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrB;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwB;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinB;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_doutB;

  input [NUMVBNK1-1:0] t2_readA;
  input [NUMVBNK1-1:0] t2_writeA;
  input [NUMVBNK1*BITSROW2-1:0] t2_addrA;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_bwA;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_dinA;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_doutA;

  input [NUMVBNK1-1:0] t2_readB;
  input [NUMVBNK1-1:0] t2_writeB;
  input [NUMVBNK1*BITSROW2-1:0] t2_addrB;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_bwB;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_dinB;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_doutB;

  input [NUMVBNK2-1:0] t3_readA;
  input [NUMVBNK2-1:0] t3_writeA;
  input [NUMVBNK2*BITSROW2-1:0] t3_addrA;
  input [NUMVBNK2*PHYWDTH2-1:0] t3_bwA;
  input [NUMVBNK2*PHYWDTH2-1:0] t3_dinA;
  input [NUMVBNK2*PHYWDTH2-1:0] t3_doutA;

  input [NUMVBNK2-1:0] t3_readB;
  input [NUMVBNK2-1:0] t3_writeB;
  input [NUMVBNK2*BITSROW2-1:0] t3_addrB;
  input [NUMVBNK2*PHYWDTH2-1:0] t3_bwB;
  input [NUMVBNK2*PHYWDTH2-1:0] t3_dinB;
  input [NUMVBNK2*PHYWDTH2-1:0] t3_doutB;

		
endmodule    //algo_3r1w_a91_sva_wrap
