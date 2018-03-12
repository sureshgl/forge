/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 *
 * */

module algo_2rw_a50_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 127, parameter T1_NUMVBNK = 4, parameter T1_BITVBNK = 2, parameter T1_DELAY = 2, parameter T1_NUMVROW = 16384, parameter T1_BITVROW = 14,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 16384, parameter T1_BITSROW = 14, parameter T1_PHYWDTH = 127,
parameter T1_FLOPIN = 0, parameter T1_FLOPOUT = 0, parameter T1_FLOPMEM = 0, parameter T1_IP_REFFRHF = 0,
parameter T2_WIDTH = 127, parameter T2_NUMVBNK = 2, parameter T2_BITVBNK = 1, parameter T2_DELAY = 2, parameter T2_NUMVROW = 16384, parameter T2_BITVROW = 14, 
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 16384, parameter T2_BITSROW = 14, parameter T2_PHYWDTH = 127,
parameter T2_FLOPIN = 0, parameter T2_FLOPOUT = 0, parameter T2_FLOPMEM = 0, parameter T2_IP_REFFRHF = 0,
parameter T3_WIDTH = 43, parameter T3_NUMVBNK = 3, parameter T3_BITVBNK = 2, parameter T3_DELAY = 1, parameter T3_NUMVROW = 16384, parameter T3_BITVROW = 14,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 1, parameter T3_NUMSROW = 16384, parameter T3_BITSROW = 14, parameter T3_PHYWDTH = 43,

parameter T1_IP_WIDTH = 127, parameter T1_IP_BITWIDTH = 7, parameter T1_IP_NUMADDR = 16384, parameter T1_IP_BITADDR = 14, parameter T1_IP_NUMVBNK = 2, parameter T1_IP_BITVBNK = 1,
parameter T1_IP_SECCBITS = 4, parameter T1_IP_SECCDWIDTH = 2, parameter T1_IP_REFRESH = 1, parameter T1_IP_REFFREQ = 13, parameter T1_IP_BITPBNK = 2,
parameter T1_T1_WIDTH = 128, parameter T1_T1_NUMVBNK = 2, parameter T1_T1_BITVBNK = 1, parameter T1_T1_DELAY = 2, parameter T1_T1_NUMVROW = 8192, parameter T1_T1_BITVROW = 13,
parameter T1_T1_BITWSPF = 0, parameter T1_T1_NUMWRDS = 1, parameter T1_T1_BITWRDS = 1, parameter T1_T1_NUMSROW = 8192, parameter T1_T1_BITSROW = 13, parameter T1_T1_PHYWDTH = 128,
parameter T1_T1_NUMRBNK = 4, parameter T1_T1_BITRBNK = 2, parameter T1_T1_NUMRROW = 256, parameter T1_T1_BITRROW = 8, parameter T1_T1_NUMPROW = 8192, parameter T1_T1_BITPROW = 13,
parameter T1_T1_BITDWSN = 8, 
parameter T1_T1_NUMDWS0 = 0, parameter T1_T1_NUMDWS1 = 0, parameter T1_T1_NUMDWS2 = 0, parameter T1_T1_NUMDWS3 = 0,
parameter T1_T1_NUMDWS4 = 0, parameter T1_T1_NUMDWS5 = 0, parameter T1_T1_NUMDWS6 = 0, parameter T1_T1_NUMDWS7 = 0,
parameter T1_T1_NUMDWS8 = 0, parameter T1_T1_NUMDWS9 = 0, parameter T1_T1_NUMDWS10 = 0, parameter T1_T1_NUMDWS11 = 0,
parameter T1_T1_NUMDWS12 = 0, parameter T1_T1_NUMDWS13 = 0, parameter T1_T1_NUMDWS14 = 0, parameter T1_T1_NUMDWS15 = 0,
parameter T1_T2_WIDTH = 128, parameter T1_T2_NUMVBNK = 1, parameter T1_T2_BITVBNK = 1, parameter T1_T2_DELAY = 2, parameter T1_T2_NUMVROW = 8192, parameter T1_T2_BITVROW = 13,
parameter T1_T2_BITWSPF = 0, parameter T1_T2_NUMWRDS = 1, parameter T1_T2_BITWRDS = 1, parameter T1_T2_NUMSROW = 8192, parameter T1_T2_BITSROW = 13, parameter T1_T2_PHYWDTH = 128,
parameter T1_T2_NUMRBNK = 4, parameter T1_T2_BITRBNK = 2, parameter T1_T2_NUMRROW = 256, parameter T1_T2_BITRROW = 8, parameter T1_T2_NUMPROW = 8192, parameter T1_T2_BITPROW = 13,
//Not declaring DWSN for T1_T2

parameter T2_IP_WIDTH = 127, parameter T2_IP_BITWIDTH = 7, parameter T2_IP_NUMADDR = 16384, parameter T2_IP_BITADDR = 14, parameter T2_IP_NUMVBNK = 2, parameter T2_IP_BITVBNK = 1,
parameter T2_IP_SECCBITS = 4, parameter T2_IP_SECCDWIDTH = 2, parameter T2_IP_REFRESH = 1, parameter T2_IP_REFFREQ = 13, parameter T2_IP_BITPBNK = 2,
parameter T2_T1_WIDTH = 128, parameter T2_T1_NUMVBNK = 2, parameter T2_T1_BITVBNK = 1, parameter T2_T1_DELAY = 2, parameter T2_T1_NUMVROW = 8192, parameter T2_T1_BITVROW = 13,
parameter T2_T1_BITWSPF = 0, parameter T2_T1_NUMWRDS = 1, parameter T2_T1_BITWRDS = 1, parameter T2_T1_NUMSROW = 8192, parameter T2_T1_BITSROW = 13, parameter T2_T1_PHYWDTH = 128,
parameter T2_T1_NUMRBNK = 4, parameter T2_T1_BITRBNK = 2, parameter T2_T1_NUMRROW = 256, parameter T2_T1_BITRROW = 8, parameter T2_T1_NUMPROW = 8192, parameter T2_T1_BITPROW = 13,
//Not declaring DWSN for T2_T1
parameter T2_T2_WIDTH = 128, parameter T2_T2_NUMVBNK = 1, parameter T2_T2_BITVBNK = 1, parameter T2_T2_DELAY = 2, parameter T2_T2_NUMVROW = 8192, parameter T2_T2_BITVROW = 13,
parameter T2_T2_BITWSPF = 0, parameter T2_T2_NUMWRDS = 1, parameter T2_T2_BITWRDS = 1, parameter T2_T2_NUMSROW = 8192, parameter T2_T2_BITSROW = 13, parameter T2_T2_PHYWDTH = 128,
parameter T2_T2_NUMRBNK = 4, parameter T2_T2_BITRBNK = 2, parameter T2_T2_NUMRROW = 256, parameter T2_T2_BITRROW = 8, parameter T2_T2_NUMPROW = 8192, parameter T2_T2_BITPROW = 13)
//Not declaring DWSN for T2_T2

( clk,  rst,  ready,  refr,
  rw_read,   rw_write,	rw_addr,	rw_din,   	rw_dout,   	rw_vld,   	rw_serr,   	rw_derr,   	rw_padr,
  
  t1_readA,   t1_writeA,   t1_addrA,   t1_dinA,   t1_bwA,   t1_doutA, t1_dwsnA,
  t1_refrB,   t1_bankB,
  t2_readA,   t2_writeA,   t2_addrA,   t2_dinA,   t2_bwA,   t2_doutA, t2_dwsnA,
  t2_refrB,   t2_bankB, 
  t3_readA,   t3_writeA,   t3_addrA,   t3_dinA,   t3_bwA,   t3_doutA, t3_dwsnA,
  t3_refrB,   t3_bankB, 
  t4_readA,   t4_writeA,   t4_addrA,   t4_dinA,   t4_bwA,   t4_doutA, t4_dwsnA,
  t4_refrB,   t4_bankB,
  t5_writeA,  t5_addrA,    t5_dinA,    t5_bwA, 
  t5_readB,   t5_addrB,    t5_doutB);
  
  // MEMOIR_TRANSLATE_OFF
  
    
  parameter NUMRDPT = 0;
  parameter NUMRWPT = 2;
  parameter NUMWRPT = 0;
  
  parameter T1_INST = T1_NUMVBNK*T1_T1_NUMVBNK;
  parameter T2_INST = T1_NUMVBNK*T1_T2_NUMVBNK;
  parameter T3_INST = T2_NUMVBNK*T2_T1_NUMVBNK;
  parameter T4_INST = T2_NUMVBNK*T2_T2_NUMVBNK;
  parameter T5_INST = T3_NUMVBNK;
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW1 = T1_NUMVROW;  // ALGO1 Parameters
  parameter BITVROW1 = T1_BITVROW;
  parameter NUMVBNK1 = T1_NUMVBNK;
  parameter BITVBNK1 = T1_BITVBNK;
  parameter NUMPBNK1 = T1_NUMVBNK + 1;			
  parameter BITPBNK1 = IP_BITPBNK;
  parameter NUMVROW2 = T1_T1_NUMVROW;   // ALGO2 Parameters  
  parameter BITVROW2 = T1_T1_BITVROW;
  parameter NUMVBNK2 = T1_IP_NUMVBNK;
  parameter BITVBNK2 = T1_IP_BITVBNK;
  parameter BITPBNK2 = T1_IP_BITPBNK;
  parameter NUMWRDS2 = T1_T1_NUMWRDS;     // ALIGN Parameters
  parameter BITWRDS2 = T1_T1_BITWRDS;
  parameter NUMSROW2 = T1_T1_NUMSROW;
  parameter BITSROW2 = T1_T1_BITSROW;
  parameter REFRESH = T1_IP_REFRESH;      // REFRESH Parameters 
  parameter NUMRBNK = T1_T1_NUMRBNK;
  parameter BITWSPF = T1_T1_BITWSPF;
  parameter BITRBNK = T1_T1_BITRBNK;
  parameter NUMRROW = T1_T1_NUMRROW;
  parameter BITRROW = T1_T1_BITRROW;
  parameter REFFREQ = T1_IP_REFFREQ;
  parameter PARITY = 1;       // PARITY Parameters
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T3_DELAY;
  parameter DRAM_DELAY = T1_T1_DELAY;
  
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

  parameter MEMWDTH = WIDTH+PARITY;
  parameter PHYWDTH = NUMWRDS2*MEMWDTH;
  parameter BITPADR2 = BITPBNK2+BITSROW2+BITWRDS2+1;
  parameter BITPADR1 = BITPBNK1+BITPADR2+1;

  parameter BITMAPT = BITPBNK1*NUMPBNK1;
  parameter SDOUT_WIDTH = 2*BITMAPT+ECCBITS;

 
input clk; input rst; input refr;
output ready; 

input  [NUMRWPT - 1:0]				rw_write; 
input  [NUMRWPT* WIDTH - 1:0]		rw_din;
input  [NUMRWPT - 1:0] 				rw_read; 
input  [NUMRWPT* BITADDR - 1:0] 	rw_addr; 
output [NUMRWPT* WIDTH - 1:0] 	rw_dout; 
output [NUMRWPT - 1:0] 				rw_vld; 
output [NUMRWPT - 1:0] 				rw_serr; 
output [NUMRWPT - 1:0] 				rw_derr; 
output [NUMRWPT*BITPADR1-1:0]    rw_padr;

output [T1_INST - 1:0] 			t1_readA; 
output [T1_INST- 1:0] 			t1_writeA; 
output [T1_INST*BITSROW2 - 1:0] t1_addrA; 
output [T1_INST*PHYWDTH - 1:0] 	t1_dinA;
output [T1_INST*PHYWDTH - 1:0] 	t1_bwA; 
input  [T1_INST*PHYWDTH - 1:0] 	t1_doutA;
output [T1_INST*BITDWSN - 1:0]  t1_dwsnA;

output [T1_INST - 1:0] 			t1_refrB; 
output [T1_INST*BITRBNK - 1:0] 	t1_bankB;

output [T2_INST - 1:0] t2_readA; 
output [T2_INST - 1:0] t2_writeA; 
output [T2_INST*BITSROW2 - 1:0] t2_addrA; 
output [T2_INST*PHYWDTH - 1:0] t2_dinA; 
output [T2_INST*PHYWDTH - 1:0] t2_bwA; 
input  [T2_INST*PHYWDTH - 1:0] t2_doutA;
output [T2_INST*BITDWSN - 1:0] t2_dwsnA;

output [T2_INST - 1:0] t2_refrB; 
output [T2_INST*BITRBNK - 1:0] t2_bankB; 

output [T3_INST - 1:0] t3_readA;  
output [T3_INST - 1:0] t3_writeA; 
output [T3_INST*BITSROW2 - 1:0] t3_addrA; 
output [T3_INST*PHYWDTH - 1:0] t3_dinA; 
output [T3_INST*PHYWDTH - 1:0] t3_bwA; 
input  [T3_INST*PHYWDTH - 1:0] t3_doutA;
output [T3_INST*BITDWSN - 1:0] t3_dwsnA;

output [T3_INST - 1:0] t3_refrB; 
output [T3_INST*BITRBNK - 1:0] t3_bankB; 

output [T4_INST - 1:0] t4_readA; 
output [T4_INST - 1:0] t4_writeA; 
output [T4_INST*BITSROW2 - 1:0] t4_addrA; 
output [T4_INST*PHYWDTH - 1:0] t4_dinA; 
output [T4_INST*PHYWDTH - 1:0] t4_bwA; 
input  [T4_INST*PHYWDTH - 1:0] t4_doutA;
output [T4_INST*BITDWSN - 1:0] t4_dwsnA;

output [T4_INST - 1:0] t4_refrB; 
output [T4_INST*BITRBNK - 1:0] t4_bankB;

output [T5_INST - 1:0] t5_writeA; 
output [T5_INST*BITVROW1 - 1:0] t5_addrA; 
output [T5_INST*SDOUT_WIDTH - 1:0] t5_dinA; 
output [T5_INST*SDOUT_WIDTH - 1:0] t5_bwA;

output [T5_INST - 1:0] t5_readB; 
output [T5_INST*BITVROW1 - 1:0] t5_addrB; 
input  [T5_INST*SDOUT_WIDTH - 1:0] t5_doutB;

wire t5_writeA_tmp;
wire [BITVROW1-1:0] t5_addrA_tmp;
wire [SDOUT_WIDTH-1:0] t5_dinA_tmp;

algo_2rw_1rw_mt_top
		#(.WIDTH(WIDTH),       .BITWDTH(BITWDTH),      .NUMADDR(NUMADDR),      .BITADDR(BITADDR),      .NUMVROW1(NUMVROW1),  .BITVROW1(BITVROW1),
		.NUMVBNK1(NUMVBNK1),  .BITVBNK1(BITVBNK1),    .NUMPBNK1(NUMPBNK1),    .BITPBNK1(BITPBNK1),  
		.NUMVROW2(NUMVROW2),  .BITVROW2(BITVROW2),    .NUMVBNK2(NUMVBNK2),    .BITVBNK2(BITVBNK2),    .BITPBNK2(BITPBNK2), 
		.NUMWRDS2(NUMWRDS2),  .BITWRDS2(BITWRDS2),    .NUMSROW2(NUMSROW2),    .BITSROW2(BITSROW2),    .REFRESH(REFRESH), .REFFRHF(IP_REFFRHF),
		.NUMRBNK(NUMRBNK),    .BITWSPF(BITWSPF),  .BITRBNK(BITRBNK),          .NUMRROW(NUMRROW),      .BITRROW(BITRROW),      .REFFREQ(REFFREQ),
		.PARITY(PARITY),              .ECCBITS(ECCBITS),              .SRAM_DELAY(SRAM_DELAY),        .DRAM_DELAY(DRAM_DELAY),
		.NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
		.NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
		.NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
		.NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15),
		.BITDWSN (BITDWSN), .FLOPIN1(FLOPIN),   .FLOPMEM(FLOPMEM),   .FLOPOUT1(FLOPOUT))
  algo_top
        (.clk(clk), .rst(rst), .ready(ready), .refr(refr),
        
		.read(rw_read),
        .write(rw_write),
        .addr(rw_addr),
        .din(rw_din),
        
		.rd_dout(rw_dout),
        .rd_vld (rw_vld),
        .rd_serr(rw_serr),
        .rd_derr(rw_derr),
        .rd_padr(rw_padr),

        .t1_readA({t3_readA, t1_readA}), .t1_writeA({t3_writeA, t1_writeA}), .t1_addrA({t3_addrA, t1_addrA}), .t1_bwA({t3_bwA, t1_bwA}), .t1_dinA({t3_dinA, t1_dinA}), .t1_doutA({t3_doutA, t1_doutA}), .t1_dwsnA({t3_dwsnA, t1_dwsnA}),
		.t1_refrB({t3_refrB, t1_refrB}), .t1_bankB({t3_bankB, t1_bankB}),
        .t2_readA({t4_readA, t2_readA}), .t2_writeA({t4_writeA, t2_writeA}), .t2_addrA({t4_addrA, t2_addrA}), .t2_bwA({t4_bwA, t2_bwA}), .t2_dinA({t4_dinA, t2_dinA}), .t2_doutA({t4_doutA, t2_doutA}), .t2_dwsnA({t4_dwsnA, t2_dwsnA}),
		.t2_refrB({t4_refrB, t2_refrB}), .t2_bankB({t4_bankB, t2_bankB}),
        .t3_writeA(t5_writeA_tmp), .t3_addrA(t5_addrA_tmp), .t3_dinA(t5_dinA_tmp), .t3_readB(t5_readB), .t3_addrB(t5_addrB), .t3_doutB(t5_doutB));

assign t5_writeA = {T5_INST{t5_writeA_tmp}};
assign t5_addrA = {T5_INST{t5_addrA_tmp}};
assign t5_dinA = {T5_INST{t5_dinA_tmp}};
assign t5_bwA = ~0;

// MEMOIR_TRANSLATE_ON

endmodule 
