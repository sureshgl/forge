/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

module algo_1r2wg_a165_sva_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 8,	parameter IP_BITVBNK = 3, parameter IP_BITPBNK = 4,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 7, parameter IP_SECCDWIDTH = 36, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 8, parameter T1_BITVBNK = 3, parameter T1_DELAY = 2, parameter T1_NUMVROW = 1024, parameter T1_BITVROW = 10, 
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 0, parameter T1_NUMSROW = 1024, parameter T1_BITSROW = 10, parameter T1_PHYWDTH = 32,

parameter T2_WIDTH = 32, parameter T2_NUMVBNK = 2, parameter T2_BITVBNK = 1, parameter T2_DELAY = 2, parameter T2_NUMVROW = 1024, parameter T2_BITVROW = 10, 
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 1024, parameter T2_BITSROW = 10, parameter T2_PHYWDTH = 32,

parameter T3_WIDTH = 42, parameter T3_NUMVBNK = 8, parameter T3_BITVBNK = 3, parameter T3_DELAY = 1, parameter T3_NUMVROW = 1024, parameter T3_BITVROW = 10,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 0, parameter T3_NUMSROW = 1024, parameter T3_BITSROW = 10, parameter T3_PHYWDTH = 42)
( clk, 		rst, 		ready,	
write, 		wr_adr, 	din,
read, 		rd_adr, 	rd_dout, 	rd_vld, 	rd_serr, 	rd_derr, 	rd_padr,

t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_doutA,
t2_readA, t2_writeA, t2_addrA, t2_dinA, t2_bwA, t2_doutA,
t3_writeA, t3_addrA, t3_dinA, t3_bwA, 
t3_readB, t3_addrB, t3_doutB);

  parameter NUMWRPT = 2;
  
  parameter T1_INST = T1_NUMVBNK;
  parameter T2_INST = T2_NUMVBNK;
  parameter T3_INST = T3_NUMVBNK;
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  
  parameter NUMVROW = T1_NUMVROW;  // ALGO1 Parameters
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = T1_NUMVBNK;
  parameter BITVBNK = T1_BITVBNK;
  parameter NUMPBNK = T1_NUMVBNK + 2;
  parameter BITPBNK = IP_BITPBNK;
  
  parameter NUMWRDS = T1_NUMWRDS;     // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  
  parameter PARITY = 0;       // PARITY Parameters
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T3_DELAY;
  parameter DRAM_DELAY = T1_DELAY;
  
  parameter MEMWDTH = WIDTH+PARITY;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter BITMAPT = BITPBNK*(NUMPBNK-1);
  parameter SDOUT_WIDTH = BITMAPT+ECCBITS;
  
input clk; input rst;
input ready; 

input  [NUMWRPT-1:0]		write; 
input  [NUMWRPT*BITADDR-1:0] 	wr_adr; 
input  [NUMWRPT*WIDTH-1:0]	din;

input   			read; 
input  [BITADDR - 1:0]    	rd_adr; 
input [WIDTH - 1:0] 		rd_dout; 
input  			rd_vld; 
input  			rd_serr; 
input  			rd_derr; 
input [BITPADR - 1:0] 		rd_padr;

input [T1_INST - 1:0] 		t1_readA; 
input [T1_INST- 1:0] 		t1_writeA; 
input [T1_INST*BITSROW - 1:0] 	t1_addrA; 
input [T1_INST*PHYWDTH - 1:0] 	t1_dinA;
input [T1_INST*PHYWDTH - 1:0] 	t1_bwA; 
input  [T1_INST*PHYWDTH - 1:0] 	t1_doutA;

input [T2_INST - 1:0]		 t2_readA; 
input [T2_INST - 1:0]		 t2_writeA; 
input [T2_INST*BITSROW - 1:0]	 t2_addrA; 
input [T2_INST*PHYWDTH - 1:0]	 t2_dinA; 
input [T2_INST*PHYWDTH - 1:0]	 t2_bwA; 
input  [T2_INST*PHYWDTH - 1:0]	 t2_doutA;

input [T3_INST - 1:0] t3_writeA; 
input [T3_INST*BITVROW - 1:0] t3_addrA; 
input [T3_INST*SDOUT_WIDTH - 1:0] t3_dinA; 
input [T3_INST*SDOUT_WIDTH - 1:0] t3_bwA;

input [T3_INST - 1:0] t3_readB; 
input [T3_INST*BITVROW - 1:0] t3_addrB; 
input  [T3_INST*SDOUT_WIDTH - 1:0] t3_doutB;

endmodule
