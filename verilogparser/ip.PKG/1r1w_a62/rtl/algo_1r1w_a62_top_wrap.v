/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_1r1w_a62_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 618, parameter T1_NUMVBNK = 2, parameter T1_BITVBNK = 1, parameter T1_DELAY = 2, parameter T1_NUMVROW = 8122, parameter T1_BITVROW = 13, 
parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 8122, parameter T1_BITSROW = 13, parameter T1_PHYWDTH = 618,
parameter T1_NUMRBNK = 2, parameter T1_BITRBNK = 1, parameter T1_NUMRROW = 256, parameter T1_BITRROW = 8, parameter T1_NUMPROW = 8192, parameter T1_BITPROW = 13,
parameter T1_BITDWSN = 8, 
parameter T1_NUMDWS0 = 0, parameter T1_NUMDWS1 = 0, parameter T1_NUMDWS2 = 0, parameter T1_NUMDWS3 = 0,
parameter T1_NUMDWS4 = 0, parameter T1_NUMDWS5 = 0, parameter T1_NUMDWS6 = 0, parameter T1_NUMDWS7 = 0,
parameter T1_NUMDWS8 = 0, parameter T1_NUMDWS9 = 0, parameter T1_NUMDWS10 = 0, parameter T1_NUMDWS11 = 0,
parameter T1_NUMDWS12 = 0, parameter T1_NUMDWS13 = 0, parameter T1_NUMDWS14 = 0, parameter T1_NUMDWS15 = 0,

parameter T2_WIDTH = 618, parameter T2_NUMVBNK = 1, parameter T2_BITVBNK = 1, parameter T2_DELAY = 2, parameter T2_NUMVROW = 8122, parameter T2_BITVROW = 13, 
parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 8122, parameter T2_BITSROW = 13, parameter T2_PHYWDTH = 618,
parameter T2_NUMRBNK = 2, parameter T2_BITRBNK = 1, parameter T2_NUMRROW = 256, parameter T2_BITRROW = 8, parameter T2_NUMPROW = 8192, parameter T2_BITPROW = 13,
parameter T2_BITDWSN = 8, 
parameter T2_NUMDWS0 = 0, parameter T2_NUMDWS1 = 0, parameter T2_NUMDWS2 = 0, parameter T2_NUMDWS3 = 0,
parameter T2_NUMDWS4 = 0, parameter T2_NUMDWS5 = 0, parameter T2_NUMDWS6 = 0, parameter T2_NUMDWS7 = 0,
parameter T2_NUMDWS8 = 0, parameter T2_NUMDWS9 = 0, parameter T2_NUMDWS10 = 0, parameter T2_NUMDWS11 = 0,
parameter T2_NUMDWS12 = 0, parameter T2_NUMDWS13 = 0, parameter T2_NUMDWS14 = 0, parameter T2_NUMDWS15 = 0,

parameter T3_WIDTH = 17, parameter T3_NUMVBNK = 2, parameter T3_BITVBNK = 1, parameter T3_DELAY = 1, parameter T3_NUMVROW = 8122, parameter T3_BITVROW = 13,
parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 1, parameter T3_NUMSROW = 8122, parameter T3_BITSROW = 13, parameter T3_PHYWDTH = 17)
( clk, 		rst, 		ready,		refr,
write, 		wr_adr, 	din,
read, 		rd_adr, 	rd_dout, 	rd_vld, 	rd_serr, 	rd_derr, 	rd_padr,

t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_doutA, t1_dwsnA,
t1_refrB, t1_bankB,
t2_readA, t2_writeA, t2_addrA, t2_dinA, t2_bwA, t2_doutA, t2_dwsnA, 
t2_refrB, t2_bankB,
t3_writeA, t3_addrA, t3_dinA, t3_bwA, 
t3_readB, t3_addrB, t3_doutB);

  parameter NUMRDPT = 1;
  parameter NUMRWPT = 0;
  parameter NUMWRPT = 1;
  
  parameter T1_INST = T1_NUMVBNK;
  parameter T2_INST = T2_NUMVBNK;
  parameter T3_INST = T3_NUMVBNK;
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  
  parameter NUMVROW = T1_NUMVROW;  // ALGO1 Parameters
  parameter BITVROW = T1_BITVROW;
  parameter BITPROW = T1_BITPROW;
  parameter NUMVBNK = T1_NUMVBNK;
  parameter BITVBNK = T1_BITVBNK;
  parameter NUMPBNK = T1_NUMVBNK + 1;
  parameter BITPBNK = IP_BITPBNK;
  
  parameter NUMWRDS = T1_NUMWRDS;     // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  
  parameter REFRESH = IP_REFRESH;      // REFRESH Parameters 
  parameter NUMRBNK = T1_NUMRBNK;
  parameter BITRBNK = T1_BITRBNK;
  parameter NUMRROW = T1_NUMRROW;
  parameter BITRROW = T1_BITRROW;
  parameter REFFREQ = IP_REFFREQ;
  
  parameter PARITY = 0;       // PARITY Parameters
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T3_DELAY;
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

  parameter MEMWDTH = WIDTH+PARITY;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter BITMAPT = BITPBNK*NUMPBNK;
  parameter SDOUT_WIDTH = 2*BITMAPT+ECCBITS;
  
input clk; input rst; input refr;
output ready; 

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

/*
input  [NUMRWPT - 1:0]				rw_write; 
input  [NUMRWPT* WIDTH - 1:0]		rw_din;
input  [NUMRWPT - 1:0] 				rw_read; 
input  [NUMRWPT* BITADDR - 1:0] 	rw_adr; 
output [NUMRWPT* WIDTH - 1:0] 		rw_dout; 
output [NUMRWPT - 1:0] 				rw_vld; 
output [NUMRWPT - 1:0] 				rw_serr; 
output [NUMRWPT - 1:0] 				rw_derr; 
output [NUMRWPT* BITPADR - 1:0] 	rw_padr;
*/

output [T1_INST - 1:0] 			t1_readA; 
output [T1_INST- 1:0] 			t1_writeA; 
output [T1_INST*BITSROW - 1:0] t1_addrA; 
output [T1_INST*PHYWDTH - 1:0] 	t1_dinA;
output [T1_INST*PHYWDTH - 1:0] 	t1_bwA; 
input  [T1_INST*PHYWDTH - 1:0] 	t1_doutA;
output [T1_INST*BITDWSN - 1:0] t1_dwsnA;

output [T1_INST - 1:0] 			t1_refrB; 
output [T1_INST*BITRBNK - 1:0] 	t1_bankB;

output [T2_INST - 1:0] t2_readA; 
output [T2_INST - 1:0] t2_writeA; 
output [T2_INST*BITSROW - 1:0] t2_addrA; 
output [T2_INST*PHYWDTH - 1:0] t2_dinA; 
output [T2_INST*PHYWDTH - 1:0] t2_bwA; 
input  [T2_INST*PHYWDTH - 1:0] t2_doutA;
output [T2_INST*BITDWSN - 1:0] t2_dwsnA;

output [T2_INST - 1:0] t2_refrB; 
output [T2_INST*BITRBNK - 1:0] t2_bankB; 

output [T3_INST - 1:0] t3_writeA; 
output [T3_INST*BITVROW - 1:0] t3_addrA; 
output [T3_INST*SDOUT_WIDTH - 1:0] t3_dinA; 
output [T3_INST*SDOUT_WIDTH - 1:0] t3_bwA;

output [T3_INST - 1:0] t3_readB; 
output [T3_INST*BITVROW - 1:0] t3_addrB; 
input  [T3_INST*SDOUT_WIDTH - 1:0] t3_doutB;

wire t3_writeA_tmp;
wire [BITVROW-1:0] t3_addrA_tmp;
wire [SDOUT_WIDTH-1:0] t3_dinA_tmp;

wire [NUMWRPT*WIDTH-1 :0] 		rd_dout_nocon;
wire [NUMWRPT-1 :0] 			rd_vld_nocon;
wire [NUMWRPT-1 :0] 			rd_serr_nocon;
wire [NUMWRPT-1 :0] 			rd_derr_nocon;
wire [NUMWRPT*BITPADR-1 :0] 	rd_padr_nocon;

  algo_1r1w_1rw_mt_top
		#(.WIDTH(WIDTH),   .BITWDTH(BITWDTH),   .NUMADDR(NUMADDR),  .BITADDR(BITADDR),
		.NUMVROW(NUMVROW),   .BITVROW(BITVROW),   .BITPROW(BITPROW),   .NUMVBNK(NUMVBNK),   .BITVBNK(BITVBNK),
		.NUMPBNK(NUMPBNK),   .BITPBNK(BITPBNK),
		.NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW),
		.REFRESH(REFRESH),   .NUMRBNK(NUMRBNK),   .BITRBNK(BITRBNK),   .NUMRROW(NUMRROW),   .BITRROW(BITRROW),
		.REFFREQ(REFFREQ),   .DISCORR(1),   .ECCBITS(ECCBITS),   .SRAM_DELAY(SRAM_DELAY),   .DRAM_DELAY(DRAM_DELAY),
		.NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
		.NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
		.NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
		.NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15),
		.BITDWSN (BITDWSN), .FLOPIN(FLOPIN),   .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT))
  algo_top
	(.clk(clk), .rst(rst), .ready(ready), .refr(refr), 
	
        .read({{NUMWRPT{1'b0}}, read}),
        .write({write, {NUMRDPT{1'b0}}}),
        .addr({wr_adr, rd_adr}),
        .din({din, {(NUMRDPT*WIDTH){1'b0}}}),
        
		.rd_dout({rd_dout_nocon, rd_dout}),
        .rd_vld ({rd_vld_nocon,  rd_vld}),
        .rd_serr({rd_serr_nocon,  rd_serr}),
        .rd_derr({rd_derr_nocon, rd_derr}),
        .rd_padr({rd_padr_nocon, rd_padr}),


     
	.t1_readA({t2_readA, t1_readA}), .t1_writeA({t2_writeA, t1_writeA}), .t1_addrA({t2_addrA, t1_addrA}), .t1_bwA({t2_bwA, t1_bwA}), .t1_dinA({t2_dinA, t1_dinA}), .t1_doutA({t2_doutA, t1_doutA}), .t1_dwsnA({t2_dwsnA, t1_dwsnA}),
	.t1_refrB({t2_refrB, t1_refrB}), .t1_bankB({t2_bankB, t1_bankB}),
	.t2_writeA(t3_writeA_tmp), .t2_addrA(t3_addrA_tmp), .t2_dinA(t3_dinA_tmp), .t2_readB(t3_readB), .t2_addrB(t3_addrB), .t2_doutB(t3_doutB));

assign t3_writeA = {T3_INST{t3_writeA_tmp}};
assign t3_addrA = {T3_INST{t3_addrA_tmp}};
assign t3_dinA = {T3_INST{t3_dinA_tmp}};
assign t3_bwA = ~0;

endmodule    //algo_1r1w_a62_top_wrap
