/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_2rw_a56_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13,
parameter IP_NUMVBNK = 4,       parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3,
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 8, parameter T1_BITVBNK = 3, parameter T1_DELAY = 2, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 2, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 1024, parameter T1_BITSROW = 10, parameter T1_PHYWDTH = 64,
parameter T2_WIDTH = 10, parameter T2_NUMVBNK = 2, parameter T2_BITVBNK = 1, parameter T2_DELAY = 2, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11, 
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 4096, parameter T2_BITSROW = 12, parameter T2_PHYWDTH = 10,
parameter T3_WIDTH = 71, parameter T3_NUMVBNK = 2, parameter T3_BITVBNK = 1, parameter T3_DELAY = 2, parameter T3_NUMVROW = 2048, parameter T3_BITVROW = 11, 
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 0, parameter T3_NUMSROW = 4096, parameter T3_BITSROW = 12, parameter T3_PHYWDTH = 71
)
( clk,  rst,  ready,
  rw_read,   rw_write,   rw_addr,   rw_din,   rw_dout,   rw_vld,   rw_serr,   rw_derr,   rw_padr,
  t1_readA,   t1_writeA,   t1_addrA,   t1_dinA,   t1_bwA,   t1_doutA,
  t2_writeA,   t2_addrA,   t2_dinA,   t2_bwA,   t2_readB,   t2_addrB,   t2_doutB,
  t3_writeA,   t3_addrA,   t3_dinA,   t3_bwA,   t3_readB,   t3_addrB,   t3_doutB);
  
  // MEMOIR_TRANSLATE_OFF
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter PHYWDTH = T1_PHYWDTH;
  parameter SRAM_DELAY = T2_DELAY;
  parameter DRAM_DELAY = T1_DELAY;
  parameter ECCBITS = IP_SECCBITS;
  
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;
  parameter CDOUT_WIDTH = 2*WIDTH+ECCWDTH;

  input [2-1:0]                  rw_read;
  input [2-1:0]                  rw_write;
  input [2*BITADDR-1:0]          rw_addr;
  input [2*WIDTH-1:0]            rw_din;
  output [2-1:0]                 rw_vld;
  output [2*WIDTH-1:0]           rw_dout;
  output [2-1:0]                 rw_serr;
  output [2-1:0]                 rw_derr;
  output [2*BITPADR-1:0]         rw_padr;

  output                         ready;
  input                          clk, rst;

  output [2*NUMVBNK-1:0] t1_readA;
  output [2*NUMVBNK-1:0] t1_writeA;
  output [2*NUMVBNK*BITSROW-1:0] t1_addrA;
  output [2*NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [2*NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input [2*NUMVBNK*PHYWDTH-1:0] t1_doutA;

  output [2-1:0] t2_writeA;
  output [2*BITVROW-1:0] t2_addrA;
  output [2*SDOUT_WIDTH-1:0] t2_dinA;
  output [2*SDOUT_WIDTH-1:0] t2_bwA;
  output [2-1:0] t2_readB;
  output [2*BITVROW-1:0] t2_addrB;
  input [2*SDOUT_WIDTH-1:0] t2_doutB;

  output [2-1:0] t3_writeA;
  output [2*BITVROW-1:0] t3_addrA;
  output [2*CDOUT_WIDTH-1:0] t3_dinA;
  output [2*CDOUT_WIDTH-1:0] t3_bwA;
  output [2-1:0] t3_readB;
  output [2*BITVROW-1:0] t3_addrB;
  input [2*CDOUT_WIDTH-1:0] t3_doutB;

  assign t2_bwA = ~0;
  assign t3_bwA = ~0;
  
  algo_2rw_1rw_a56_top 
  		#(.WIDTH(WIDTH),   .BITWDTH(BITWDTH),   .ENAPAR(ENAPAR),  .ENAECC(ENAECC), .ECCWDTH (ECCWDTH),  .NUMADDR(NUMADDR),   .BITADDR(BITADDR),
		.NUMVROW(NUMVROW),   .BITVROW(BITVROW),   .NUMVBNK(NUMVBNK),   .BITVBNK(BITVBNK),  .BITPBNK(BITPBNK),
		.FLOPIN(FLOPIN),   .FLOPOUT(FLOPOUT),
		.NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW),
		.SRAM_DELAY(SRAM_DELAY),   .DRAM_DELAY(DRAM_DELAY),   .ECCBITS(ECCBITS),   .FLOPMEM(FLOPMEM))
    algo_top
		(.clk(clk), .rst(rst), .ready(ready),
		 .read(rw_read), .write(rw_write), .addr(rw_addr), .din(rw_din), .rd_vld(rw_vld), .rd_dout(rw_dout), .rd_serr(rw_serr), .rd_derr(rw_derr), .rd_padr(rw_padr),
		 .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_bwA(t1_bwA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA),
		 .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
		 .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB));

// MEMOIR_TRANSLATE_ON
  
endmodule    //algo_2rw_a56_top_wrap
