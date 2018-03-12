/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_2r1w3m2d_m53_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 5, parameter IP_SECCDWIDTH = 11, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 4, parameter T1_BITVBNK = 2, parameter T1_DELAY = 1, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11, 
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 2048, parameter T1_BITSROW = 11, parameter T1_PHYWDTH = 32,

parameter T2_WIDTH = 27, parameter T2_NUMVBNK = 8, parameter T2_BITVBNK = 3, parameter T2_DELAY = 1, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 2048, parameter T2_BITSROW = 11, parameter T2_PHYWDTH = 27)
( clk, 		rst, 		ready,
  read, 	rd_adr, 	rd_dout, 	rd_vld, 	rd_serr, 	rd_derr, 	rd_padr,
  ma_write, 	ma_adr, 	ma_din,	        ma_bp,		bp_thr,
  write, 	wr_adr, 	din,
  dq_vld,       dq_adr,
 
  grpmsk,

t1_writeA, t1_addrA, t1_dinA, t1_bwA,
t1_readB, t1_addrB, t1_doutB,
t2_writeA, t2_addrA, t2_dinA, t2_bwA, 
t2_readB, t2_addrB, t2_doutB);

// MEMOIR_TRANSLATE_OFF

  parameter NUMRDPT = 2;
  parameter NUMWRPT = 1;
  parameter NUMMAPT = 4;
  parameter NUMDQPT = 2;
  
  parameter T1_INST = T1_NUMVBNK;
  parameter T2_INST = T2_NUMVBNK;
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  
  parameter NUMVROW = T1_NUMVROW;  // ALGO1 Parameters
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = T1_NUMVBNK;
  parameter BITVBNK = T1_BITVBNK;
  
  parameter NUMWRDS = T1_NUMWRDS;     // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T2_DELAY;
  parameter DRAM_DELAY = T1_DELAY;
  
  parameter MEMWDTH = WIDTH;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;
  parameter BITPADR = BITVBNK+BITSROW+BITWRDS+1;
  parameter SDOUT_WIDTH = 2*BITVROW+ECCBITS;
//  parameter SDOUT_WIDTH = BITVROW;

input clk; input rst;
output ready; 

input  [NUMMAPT - 1:0]				ma_write; 
output  [NUMMAPT* BITADDR - 1:0] 	ma_adr; 
input  [NUMMAPT* WIDTH - 1:0]		ma_din;
output  [NUMMAPT - 1:0]				ma_bp; 
input [7:0]				bp_thr;

input  [NUMWRPT - 1:0]				write; 
input  [NUMWRPT* BITADDR - 1:0] 	wr_adr; 
input  [NUMWRPT* WIDTH - 1:0]		din;

input  [NUMRDPT - 1:0] 				read; 
input  [NUMRDPT* BITADDR - 1:0] 	rd_adr; 
output [NUMRDPT* WIDTH - 1:0] 		rd_dout; 
output [NUMRDPT - 1:0] 				rd_vld; 
output [NUMRDPT - 1:0] 				rd_serr; 
output [NUMRDPT - 1:0] 				rd_derr; 
output [NUMRDPT* BITPADR - 1:0] 	rd_padr;

input  [NUMDQPT - 1:0]			dq_vld;
input  [NUMDQPT* BITADDR - 1:0]		dq_adr;

input  [NUMVBNK - 1:0]                  grpmsk;

output [T1_INST- 1:0] 			t1_writeA; 
output [T1_INST*BITSROW - 1:0] t1_addrA; 
output [T1_INST*PHYWDTH - 1:0] 	t1_dinA;
output [T1_INST*PHYWDTH - 1:0] 	t1_bwA; 
output [T1_INST - 1:0] 			t1_readB; 
output [T1_INST*BITSROW - 1:0] t1_addrB; 
input  [T1_INST*PHYWDTH - 1:0] 	t1_doutB;

output [T2_INST - 1:0] t2_writeA; 
output [T2_INST*BITVROW - 1:0] t2_addrA; 
output [T2_INST*SDOUT_WIDTH - 1:0] t2_dinA; 
output [T2_INST*SDOUT_WIDTH - 1:0] t2_bwA;

output [T2_INST - 1:0] t2_readB; 
output [T2_INST*BITVROW - 1:0] t2_addrB; 
input  [T2_INST*SDOUT_WIDTH - 1:0] t2_doutB;

wire ma_bp_tmp;
assign ma_bp = {NUMMAPT{ma_bp_tmp}};
assign t2_bwA = ~0;

  algo_2r1w3m2d_1r1w_fl_top
		#(.WIDTH(WIDTH),   .BITWDTH(BITWDTH),   .NUMADDR(NUMADDR),  .BITADDR(BITADDR),
		.NUMVROW(NUMVROW),   .BITVROW(BITVROW),   .NUMVBNK(NUMVBNK),   .BITVBNK(BITVBNK),
		.NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW),
		.ECCBITS(ECCBITS),   .SRAM_DELAY(SRAM_DELAY),   .DRAM_DELAY(DRAM_DELAY), .FLOPIN(FLOPIN),   .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT))
  algo_top
	(.clk(clk), .rst(rst), .ready(ready),
	
        .malloc(ma_write),
        .ma_adr(ma_adr),
        .ma_din(ma_din),
        .ma_bp(ma_bp_tmp),
        .bp_thr(bp_thr),

        .write(write),
        .wr_adr(wr_adr),
        .din(din),
        
        .read(read),
        .rd_adr(rd_adr),
        .rd_dout(rd_dout),
        .rd_vld (rd_vld),
        .rd_serr(rd_serr),
        .rd_derr(rd_derr),
        .rd_padr(rd_padr),

        .dq_vld(dq_vld),
        .dq_adr(dq_adr),

        .grpmsk(grpmsk),

	.t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_bwA(t1_bwA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
	.t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB));

// MEMOIR_TRANSLATE_ON

endmodule    //algo_2r1w6m2d_m63_top_wrap
