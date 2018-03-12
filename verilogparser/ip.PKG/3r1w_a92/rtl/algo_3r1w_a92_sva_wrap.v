/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

module algo_3r1w_a92_sva_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 48, parameter T1_NUMVBNK = 2, parameter T1_BITVBNK = 1, parameter T1_DELAY = 2, parameter T1_NUMVROW = 8192, parameter T1_BITVROW = 13,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 8192, parameter T1_BITSROW = 13, parameter T1_PHYWDTH = 48,

parameter T1_IP_WIDTH = 48, parameter T1_IP_BITWIDTH = 6, parameter T1_IP_NUMADDR = 8192, parameter T1_IP_BITADDR = 13, parameter T1_IP_NUMVBNK = 2, parameter T1_IP_BITVBNK = 1,
parameter T1_IP_SECCBITS = 4, parameter T1_IP_SECCDWIDTH = 2, parameter T1_FLOPIN = 0, parameter T1_FLOPOUT = 0, parameter T1_FLOPMEM = 0, 
parameter T1_IP_REFRESH = 1, parameter T1_IP_REFFREQ = 15, parameter T1_IP_REFFRHF = 1, parameter T1_IP_BITPBNK = 3, parameter T1_IP_NUMVROW1 = 4096, parameter T1_IP_BITVROW1 = 12, parameter T1_IP_BITPBNK2 = 1,

parameter T1_T1_WIDTH = 49, parameter T1_T1_NUMVBNK = 4, parameter T1_T1_BITVBNK = 2, parameter T1_T1_DELAY = 2, parameter T1_T1_NUMVROW = 2048, parameter T1_T1_BITVROW = 11,
parameter T1_T1_BITWSPF = 0, parameter T1_T1_NUMWRDS = 1, parameter T1_T1_BITWRDS = 1, parameter T1_T1_NUMSROW = 2048, parameter T1_T1_BITSROW = 11, parameter T1_T1_PHYWDTH = 49,
parameter T1_T1_NUMRBNK = 1, parameter T1_T1_BITRBNK = 1, parameter T1_T1_NUMRROW = 256, parameter T1_T1_BITRROW = 8, parameter T1_T1_NUMPROW = 2048, parameter T1_T1_BITPROW = 11,
parameter T1_T1_BITDWSN = 8, 
parameter T1_T1_NUMDWS0 = 0, parameter T1_T1_NUMDWS1 = 0, parameter T1_T1_NUMDWS2 = 0, parameter T1_T1_NUMDWS3 = 0,
parameter T1_T1_NUMDWS4 = 0, parameter T1_T1_NUMDWS5 = 0, parameter T1_T1_NUMDWS6 = 0, parameter T1_T1_NUMDWS7 = 0,
parameter T1_T1_NUMDWS8 = 0, parameter T1_T1_NUMDWS9 = 0, parameter T1_T1_NUMDWS10 = 0, parameter T1_T1_NUMDWS11 = 0,
parameter T1_T1_NUMDWS12 = 0, parameter T1_T1_NUMDWS13 = 0, parameter T1_T1_NUMDWS14 = 0, parameter T1_T1_NUMDWS15 = 0,

parameter T1_T2_WIDTH = 49, parameter T1_T2_NUMVBNK = 2, parameter T1_T2_BITVBNK = 1, parameter T1_T2_DELAY = 2, parameter T1_T2_NUMVROW = 2048, parameter T1_T2_BITVROW = 11,
parameter T1_T2_BITWSPF = 0, parameter T1_T2_NUMWRDS = 1, parameter T1_T2_BITWRDS = 1, parameter T1_T2_NUMSROW = 2048, parameter T1_T2_BITSROW = 11, parameter T1_T2_PHYWDTH = 49,
parameter T1_T2_NUMRBNK = 1, parameter T1_T2_BITRBNK = 1, parameter T1_T2_NUMRROW = 256, parameter T1_T2_BITRROW = 8, parameter T1_T2_NUMPROW = 2048, parameter T1_T2_BITPROW = 11,
//Not declaring DWSN for T1_T2

parameter T1_T3_WIDTH = 49, parameter T1_T3_NUMVBNK = 2, parameter T1_T3_BITVBNK = 1, parameter T1_T3_DELAY = 2, parameter T1_T3_NUMVROW = 2048, parameter T1_T3_BITVROW = 11,
parameter T1_T3_BITWSPF = 0, parameter T1_T3_NUMWRDS = 1, parameter T1_T3_BITWRDS = 1, parameter T1_T3_NUMSROW = 2048, parameter T1_T3_BITSROW = 11, parameter T1_T3_PHYWDTH = 49,
parameter T1_T3_NUMRBNK = 1, parameter T1_T3_BITRBNK = 1, parameter T1_T3_NUMRROW = 256, parameter T1_T3_BITRROW = 8, parameter T1_T3_NUMPROW = 2048, parameter T1_T3_BITPROW = 11,
//Not declaring DWSN for T1_T3

parameter T2_WIDTH = 48, parameter T2_NUMVBNK = 3, parameter T2_BITVBNK = 2, parameter T2_DELAY = 2, parameter T2_NUMVROW = 8192, parameter T2_BITVROW = 13,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 8192, parameter T2_BITSROW = 13, parameter T2_PHYWDTH = 48,

parameter T2_IP_WIDTH = 48, parameter T2_IP_BITWIDTH = 6, parameter T2_IP_NUMADDR = 8192, parameter T2_IP_BITADDR = 13, parameter T2_IP_NUMVBNK = 2, parameter T2_IP_BITVBNK = 1,
parameter T2_IP_SECCBITS = 4, parameter T2_IP_SECCDWIDTH = 2, parameter T2_FLOPIN = 0, parameter T2_FLOPOUT = 0, parameter T2_FLOPMEM = 0,
parameter T2_IP_REFRESH = 1, parameter T2_IP_REFFREQ = 15, parameter T2_IP_REFFRHF = 1, parameter T2_IP_BITPBNK = 3, parameter T2_IP_NUMVROW1 = 4096, parameter T2_IP_BITVROW1 = 12, parameter T2_IP_BITPBNK2 = 1,

parameter T2_T1_WIDTH = 49, parameter T2_T1_NUMVBNK = 4, parameter T2_T1_BITVBNK = 2, parameter T2_T1_DELAY = 2, parameter T2_T1_NUMVROW = 2048, parameter T2_T1_BITVROW = 11,
parameter T2_T1_BITWSPF = 0, parameter T2_T1_NUMWRDS = 1, parameter T2_T1_BITWRDS = 1, parameter T2_T1_NUMSROW = 2048, parameter T2_T1_BITSROW = 11, parameter T2_T1_PHYWDTH = 49,
parameter T2_T1_NUMRBNK = 1, parameter T2_T1_BITRBNK = 1, parameter T2_T1_NUMRROW = 256, parameter T2_T1_BITRROW = 8, parameter T2_T1_NUMPROW = 2048, parameter T2_T1_BITPROW = 11,
//Not declaring DWSN for T2_T1

parameter T2_T2_WIDTH = 49, parameter T2_T2_NUMVBNK = 2, parameter T2_T2_BITVBNK = 1, parameter T2_T2_DELAY = 2, parameter T2_T2_NUMVROW = 2048, parameter T2_T2_BITVROW = 11,
parameter T2_T2_BITWSPF = 0, parameter T2_T2_NUMWRDS = 1, parameter T2_T2_BITWRDS = 1, parameter T2_T2_NUMSROW = 2048, parameter T2_T2_BITSROW = 11, parameter T2_T2_PHYWDTH = 49,
parameter T2_T2_NUMRBNK = 1, parameter T2_T2_BITRBNK = 1, parameter T2_T2_NUMRROW = 256, parameter T2_T2_BITRROW = 8, parameter T2_T2_NUMPROW = 2048, parameter T2_T2_BITPROW = 11,
//Not declaring DWSN for T2_T2

parameter T2_T3_WIDTH = 49, parameter T2_T3_NUMVBNK = 2, parameter T2_T3_BITVBNK = 1, parameter T2_T3_DELAY = 2, parameter T2_T3_NUMVROW = 2048, parameter T2_T3_BITVROW = 11,
parameter T2_T3_BITWSPF = 0, parameter T2_T3_NUMWRDS = 1, parameter T2_T3_BITWRDS = 1, parameter T2_T3_NUMSROW = 2048, parameter T2_T3_BITSROW = 11, parameter T2_T3_PHYWDTH = 49,
parameter T2_T3_NUMRBNK = 1, parameter T2_T3_BITRBNK = 1, parameter T2_T3_NUMRROW = 256, parameter T2_T3_BITRROW = 8, parameter T2_T3_NUMPROW = 2048, parameter T2_T3_BITPROW = 11,
//Not declaring DWSN for T2_T3

parameter T3_WIDTH = 36, parameter T3_NUMVBNK = 4, parameter T3_BITVBNK = 2, parameter T3_DELAY = 1, parameter T3_NUMVROW = 8192, parameter T3_BITVROW = 13,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 1, parameter T3_NUMSROW = 8192, parameter T3_BITSROW = 13, parameter T3_PHYWDTH = 36)

( clk,  rst,  ready,  refr,
 write,   wr_adr,   din,
  read,   rd_adr,   rd_dout,   rd_vld,   rd_serr,   rd_derr,   rd_padr,
  t1_readA,   t1_writeA,   t1_addrA,   t1_dinA,   t1_bwA,   t1_doutA,   t1_dwsnA,
  t1_refrB,   t1_bankB,
  t2_readA,   t2_writeA,   t2_addrA,   t2_dinA,   t2_bwA,   t2_doutA,   t2_dwsnA,
  t2_refrB,   t2_bankB,
  t3_readA,   t3_writeA,   t3_addrA,   t3_dinA,   t3_bwA,   t3_doutA,   t3_dwsnA,
  t3_refrB,   t3_bankB,
  t4_readA,   t4_writeA,   t4_addrA,   t4_dinA,   t4_bwA,   t4_doutA,   t4_dwsnA,
  t4_refrB,   t4_bankB,
  t5_readA,   t5_writeA,   t5_addrA,   t5_dinA,   t5_bwA,   t5_doutA,   t5_dwsnA,
  t5_refrB,   t5_bankB,
  t6_readA,   t6_writeA,   t6_addrA,   t6_dinA,   t6_bwA,   t6_doutA,   t6_dwsnA,
  t6_refrB,   t6_bankB,
  t7_writeA,   t7_addrA,   t7_dinA,   t7_bwA,
  t7_readB,   t7_addrB,   t7_doutB);
  
  
  parameter NUMRDPT = 3;
  parameter NUMRWPT = 0;
  parameter NUMWRPT = 1;
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter PARITY = 1;
  parameter MEMWDTH = WIDTH+PARITY;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW1 = T1_NUMVROW;  // ALGO1 Parameters
  parameter BITVROW1 = T1_BITVROW;
  parameter NUMVBNK1 = IP_NUMVBNK;
  parameter BITVBNK1 = IP_BITVBNK;
  parameter NUMPBNK1 = IP_NUMVBNK+3;
  parameter BITPBNK1 = IP_BITPBNK;
  parameter FLOPIN1 = FLOPIN;
  parameter FLOPOUT1 = FLOPOUT;
  parameter NUMVROW2 = T1_IP_NUMVROW1;   // ALGO2 Parameters
  parameter BITVROW2 = T1_IP_BITVROW1;
  parameter NUMVBNK2 = T1_T2_NUMVBNK;
  parameter BITVBNK2 = T1_T2_BITVBNK;
  parameter BITPBNK2 = T1_IP_BITPBNK;
  parameter FLOPIN2 = 0;
  parameter FLOPOUT2 = 0;
  parameter NUMWRDS2 = T1_T3_NUMWRDS;     // ALIGN Parameters
  parameter BITWRDS2 = T1_T3_BITWRDS;
  parameter NUMSROW2 = T1_T3_NUMSROW;
  parameter BITSROW2 = T1_T3_BITSROW;
  parameter PHYWDTH2 = T1_T3_PHYWDTH;
  parameter NUMRBNK2 = T1_T3_NUMRBNK;
  parameter BITWSPF2 = T1_T3_BITWSPF;
  parameter BITRBNK2 = T1_T3_BITRBNK;
  parameter NUMVROW3 = T1_T1_NUMVROW;   // ALGO2 Parameters
  parameter BITVROW3 = T1_T1_BITVROW;
  parameter NUMVBNK3 = T1_T3_NUMVBNK;
  parameter BITVBNK3 = T1_T3_BITVBNK;
  parameter BITPBNK3 = T1_IP_BITPBNK2;
  parameter FLOPIN3 = 0;
  parameter FLOPOUT3 = 0;

  parameter NUMWRDS3 = T1_T1_NUMWRDS;     // ALIGN Parameters
  parameter BITWRDS3 = T1_T1_BITWRDS;
  parameter NUMSROW3 = T1_T1_NUMSROW;
  parameter BITSROW3 = T1_T1_BITSROW;
  parameter PHYWDTH3 = T1_T1_PHYWDTH;
  parameter NUMRBNK3 = T1_T1_NUMRBNK;
  parameter BITWSPF3 = T1_T1_BITWSPF;
  parameter BITRBNK3 = T1_T1_BITRBNK;
  parameter REFRESH = IP_REFRESH;      // REFRESH Parameters 
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
  
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T3_DELAY;
  parameter DRAM_DELAY = T1_T1_DELAY;

  parameter BITPADR4 = BITVBNK3+BITSROW3+BITWRDS3+1;
  parameter BITPADR3 = BITPBNK3+BITSROW3+BITWRDS3+1;
  parameter BITPADR2 = BITPBNK2+BITPADR3+1;
  parameter BITPADR1 = BITPBNK1+BITPADR2+1;

  parameter BITMAPT = BITPBNK1*NUMPBNK1;
  parameter SDOUT_WIDTH = 2*BITMAPT+ECCBITS;
  
  parameter T1_INST = T1_NUMVBNK*T1_T1_NUMVBNK;
  parameter T2_INST = T1_NUMVBNK*T1_T2_NUMVBNK;
  parameter T3_INST = T1_NUMVBNK*T1_T3_NUMVBNK;
  parameter T4_INST = T2_NUMVBNK*T2_T1_NUMVBNK;
  parameter T5_INST = T2_NUMVBNK*T2_T2_NUMVBNK;
  parameter T6_INST = T2_NUMVBNK*T2_T3_NUMVBNK;
  parameter T7_INST = T3_NUMVBNK;
  
input clk; input rst; input refr;
input ready; 

input  [NUMWRPT - 1:0]				write; 
input  [NUMWRPT* BITADDR - 1:0] 	wr_adr; 
input  [NUMWRPT* WIDTH - 1:0]		din;

input  [NUMRDPT - 1:0] 				read; 
input  [NUMRDPT* BITADDR - 1:0] 	rd_adr; 
input [NUMRDPT* WIDTH - 1:0] 		rd_dout; 
input [NUMRDPT - 1:0] 				rd_vld; 
input [NUMRDPT - 1:0] 				rd_serr; 
input [NUMRDPT - 1:0] 				rd_derr; 
input [NUMRDPT* BITPADR1 - 1:0] 	rd_padr;

input [T1_INST - 1:0] 			t1_readA; 
input [T1_INST- 1:0] 			t1_writeA; 
input [T1_INST*BITSROW3 - 1:0] t1_addrA; 
input [T1_INST*PHYWDTH3 - 1:0] 	t1_dinA;
input [T1_INST*PHYWDTH3 - 1:0] 	t1_bwA; 
input  [T1_INST*PHYWDTH3 - 1:0] 	t1_doutA;
input [T1_INST*BITDWSN - 1:0] t1_dwsnA;

input [T1_INST - 1:0] 			t1_refrB; 
input [T1_INST*BITRBNK3 - 1:0] 	t1_bankB;

input [T2_INST - 1:0] t2_readA; 
input [T2_INST - 1:0] t2_writeA; 
input [T2_INST*BITSROW3 - 1:0] t2_addrA; 
input [T2_INST*PHYWDTH3 - 1:0] t2_dinA; 
input [T2_INST*PHYWDTH3 - 1:0] t2_bwA; 
input  [T2_INST*PHYWDTH3 - 1:0] t2_doutA;
input [T2_INST*BITDWSN - 1:0] t2_dwsnA;

input [T2_INST - 1:0] t2_refrB; 
input [T2_INST*BITRBNK3 - 1:0] t2_bankB; 

input [T3_INST - 1:0] t3_readA; 
input [T3_INST - 1:0] t3_writeA; 
input [T3_INST*BITSROW2 - 1:0] t3_addrA; 
input [T3_INST*PHYWDTH2 - 1:0] t3_dinA; 
input [T3_INST*PHYWDTH2 - 1:0] t3_bwA; 
input  [T3_INST*PHYWDTH2 - 1:0] t3_doutA;
input [T3_INST*BITDWSN - 1:0] t3_dwsnA;

input [T3_INST - 1:0] t3_refrB; 
input [T3_INST*BITRBNK2 - 1:0] t3_bankB; 

input [T4_INST - 1:0] t4_readA; 
input [T4_INST - 1:0] t4_writeA; 
input [T4_INST*BITSROW3 - 1:0] t4_addrA; 
input [T4_INST*PHYWDTH3 - 1:0] t4_dinA; 
input [T4_INST*PHYWDTH3 - 1:0] t4_bwA; 
input  [T4_INST*PHYWDTH3 - 1:0] t4_doutA;
input [T4_INST*BITDWSN - 1:0] t4_dwsnA;

input [T4_INST - 1:0] t4_refrB; 
input [T4_INST*BITRBNK3 - 1:0] t4_bankB; 

input [T5_INST - 1:0] t5_readA; 
input [T5_INST - 1:0] t5_writeA; 
input [T5_INST*BITSROW3 - 1:0] t5_addrA; 
input [T5_INST*PHYWDTH3 - 1:0] t5_dinA; 
input [T5_INST*PHYWDTH3 - 1:0] t5_bwA; 
input  [T5_INST*PHYWDTH3 - 1:0] t5_doutA;
input [T5_INST*BITDWSN - 1:0] t5_dwsnA;

input [T5_INST - 1:0] t5_refrB; 
input [T5_INST*BITRBNK3 - 1:0] t5_bankB; 

input [T6_INST - 1:0] t6_readA; 
input [T6_INST - 1:0] t6_writeA; 
input [T6_INST*BITSROW2 - 1:0] t6_addrA; 
input [T6_INST*PHYWDTH2 - 1:0] t6_dinA; 
input [T6_INST*PHYWDTH2 - 1:0] t6_bwA; 
input  [T6_INST*PHYWDTH2 - 1:0] t6_doutA;
input [T6_INST*BITDWSN - 1:0] t6_dwsnA;

input [T6_INST - 1:0] t6_refrB; 
input [T6_INST*BITRBNK2 - 1:0] t6_bankB; 

input [T7_INST - 1:0] t7_writeA; 
input [T7_INST*BITVROW1 - 1:0] t7_addrA; 
input [T7_INST*SDOUT_WIDTH - 1:0] t7_dinA; 
input [T7_INST*SDOUT_WIDTH - 1:0] t7_bwA;

input [T7_INST - 1:0] t7_readB; 
input [T7_INST*BITVROW1 - 1:0] t7_addrB; 
input  [T7_INST*SDOUT_WIDTH - 1:0] t7_doutB;

endmodule
