/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_1r2m_m30_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 4, parameter T1_BITVBNK = 2, parameter T1_DELAY = 1, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11, 
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 2048, parameter T1_BITSROW = 11, parameter T1_PHYWDTH = 32,
parameter T1_NUMRBNK = 2, parameter T1_BITRBNK = 1, parameter T1_NUMRROW = 256, parameter T1_BITRROW = 8, parameter T1_NUMPROW = 1024, parameter T1_BITPROW = 10,
parameter T1_BITDWSN = 8, 
parameter T1_NUMDWS0 = 0, parameter T1_NUMDWS1 = 0, parameter T1_NUMDWS2 = 0, parameter T1_NUMDWS3 = 0,
parameter T1_NUMDWS4 = 0, parameter T1_NUMDWS5 = 0, parameter T1_NUMDWS6 = 0, parameter T1_NUMDWS7 = 0,
parameter T1_NUMDWS8 = 0, parameter T1_NUMDWS9 = 0, parameter T1_NUMDWS10 = 0, parameter T1_NUMDWS11 = 0,
parameter T1_NUMDWS12 = 0, parameter T1_NUMDWS13 = 0, parameter T1_NUMDWS14 = 0, parameter T1_NUMDWS15 = 0,

parameter T2_WIDTH = 11, parameter T2_NUMVBNK = 4, parameter T2_BITVBNK = 2, parameter T2_DELAY = 1, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 2048, parameter T2_BITSROW = 11, parameter T2_PHYWDTH = 11)
( clk, 		rst, 		ready,		refr,
  ma_write, 	ma_adr, 	ma_din,	        ma_bp,
  read, 	rd_deq,		rd_adr, 	rd_dout, 	rd_vld, 	rd_serr, 	rd_derr, 	rd_padr,

t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_doutA, t1_dwsnA,
t1_refrB, t1_bankB,
t2_writeA, t2_addrA, t2_dinA, t2_bwA, 
t2_readB, t2_addrB, t2_doutB);

// MEMOIR_TRANSLATE_OFF

  parameter NUMRDPT = 1;
  parameter NUMWRPT = 2;
  
  parameter T1_INST = T1_NUMVBNK;
  parameter T2_INST = T2_NUMVBNK;
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  
  parameter NUMVROW = T1_NUMVROW;  // ALGO1 Parameters
  parameter BITVROW = T1_BITVROW;
  parameter BITPROW = T1_BITPROW;
  parameter NUMVBNK = T1_NUMVBNK;
  parameter BITVBNK = T1_BITVBNK;
  
  parameter NUMWRDS = T1_NUMWRDS;     // ALIGN Parameters
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
  
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T2_DELAY;
  parameter DRAM_DELAY = T1_DELAY;
  
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

  parameter MEMWDTH = WIDTH;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;
  parameter BITPADR = BITVBNK+BITSROW+BITWRDS+1;
  parameter SDOUT_WIDTH = BITVROW;

input clk; input rst; input refr;
output ready; 

input  [NUMWRPT - 1:0]				ma_write; 
output  [NUMWRPT* BITADDR - 1:0] 	ma_adr; 
input  [NUMWRPT* WIDTH - 1:0]		ma_din;
output  [NUMWRPT - 1:0]				ma_bp; 

input  [NUMRDPT - 1:0] 				read; 
input  [NUMRDPT - 1:0] 				rd_deq; 
input  [NUMRDPT* BITADDR - 1:0] 	rd_adr; 
output [NUMRDPT* WIDTH - 1:0] 		rd_dout; 
output [NUMRDPT - 1:0] 				rd_vld; 
output [NUMRDPT - 1:0] 				rd_serr; 
output [NUMRDPT - 1:0] 				rd_derr; 
output [NUMRDPT* BITPADR - 1:0] 	rd_padr;

output [T1_INST - 1:0] 			t1_readA; 
output [T1_INST- 1:0] 			t1_writeA; 
output [T1_INST*BITSROW - 1:0] t1_addrA; 
output [T1_INST*PHYWDTH - 1:0] 	t1_dinA;
output [T1_INST*PHYWDTH - 1:0] 	t1_bwA; 
input  [T1_INST*PHYWDTH - 1:0] 	t1_doutA;
output [T1_INST*BITDWSN - 1:0] t1_dwsnA;

output [T1_INST - 1:0] 			t1_refrB; 
output [T1_INST*BITRBNK - 1:0] 	t1_bankB;

output [T2_INST - 1:0] t2_writeA; 
output [T2_INST*BITVROW - 1:0] t2_addrA; 
output [T2_INST*SDOUT_WIDTH - 1:0] t2_dinA; 
output [T2_INST*SDOUT_WIDTH - 1:0] t2_bwA;

output [T2_INST - 1:0] t2_readB; 
output [T2_INST*BITVROW - 1:0] t2_addrB; 
input  [T2_INST*SDOUT_WIDTH - 1:0] t2_doutB;

wire wr_bp_tmp;
assign ma_bp = {NUMWRPT{wr_bp_tmp}};

  algo_1r2m_1rw_fl_top
		#(.WIDTH(WIDTH),   .BITWDTH(BITWDTH),   .NUMADDR(NUMADDR),  .BITADDR(BITADDR),
		.NUMVROW(NUMVROW),   .BITVROW(BITVROW),   .BITPROW(BITPROW),   .NUMVBNK(NUMVBNK),   .BITVBNK(BITVBNK),
		.NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW),
		.REFRESH(REFRESH),   .NUMRBNK(NUMRBNK),   .BITWSPF(BITWSPF),  .BITRBNK(BITRBNK),   .NUMRROW(NUMRROW),   .BITRROW(BITRROW),
		.REFFREQ(REFFREQ),   .ECCBITS(ECCBITS),   .SRAM_DELAY(SRAM_DELAY),   .DRAM_DELAY(DRAM_DELAY),
		.NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
		.NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
		.NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
		.NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15),
		.BITDWSN (BITDWSN), .FLOPIN(FLOPIN),   .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT))
  algo_top
	(.clk(clk), .rst(rst), .ready(ready), .refr(refr), 
	
        .write(ma_write),
        .wr_adr(ma_adr),
        .din(ma_din),
        .wr_bp(wr_bp_tmp),
        
        .read(read),
        .rd_adr(rd_adr),
        .rd_deq(rd_deq),
        .rd_dout(rd_dout),
        .rd_vld (rd_vld),
        .rd_serr(rd_serr),
        .rd_derr(rd_derr),
        .rd_padr(rd_padr),

	.t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_bwA(t1_bwA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA), .t1_dwsnA(t1_dwsnA),
	.t1_refrB(t1_refrB), .t1_bankB(t1_bankB),
	.t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB));

// MEMOIR_TRANSLATE_ON

endmodule    //algo_1r1w_a60_top_wrap
