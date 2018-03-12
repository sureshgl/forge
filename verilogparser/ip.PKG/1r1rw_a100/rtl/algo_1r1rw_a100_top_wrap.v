/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

module algo_1r1rw_a100_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_ENAHEC = 0, parameter IP_ENAQEC = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 33, parameter T1_NUMVBNK = 4, parameter T1_BITVBNK = 2, parameter T1_DELAY = 1, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 4, parameter T1_BITWRDS = 2, parameter T1_NUMSROW = 512, parameter T1_BITSROW = 9, parameter T1_PHYWDTH = 132, 
parameter T2_WIDTH = 33, parameter T2_NUMVBNK = 1, parameter T2_BITVBNK = 1, parameter T2_DELAY = 1, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 4, parameter T2_BITWRDS = 2, parameter T2_NUMSROW = 512, parameter T2_BITSROW = 9, parameter T2_PHYWDTH = 132)
( clk,  rst,  ready,  
  rw_read,  rw_write,  rw_addr,  rw_din,  rw_dout,  rw_vld,  rw_serr,  rw_derr,  rw_padr,
  read,  rd_adr,  rd_dout,  rd_vld,  rd_serr,  rd_derr,  rd_padr,
  t1_writeA,  t1_addrA,  t1_dinA,  t1_bwA,  t1_readB,  t1_addrB,  t1_doutB,
  t2_writeA,  t2_addrA,  t2_dinA,  t2_bwA,  t2_readB,  t2_addrB,  t2_doutB);
  
  // MEMOIR_TRANSLATE_OFF
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ENAHEC = IP_ENAHEC;
  parameter ENAQEC = IP_ENAQEC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;   // ALGO Parameters
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = T1_NUMVBNK;
  parameter BITVBNK = T1_BITVBNK;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter SRAM_DELAY = T1_DELAY;
  parameter PHYWDTH = T1_PHYWDTH;

  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENAHEC ? WIDTH+2*ECCWDTH : ENAQEC ? WIDTH+4*ECCWDTH : WIDTH;
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  
  input [1-1:0]                  rw_read;
  input [1-1:0]                  rw_write;
  input [1*BITADDR-1:0]          rw_addr;
  output [1-1:0]                 rw_vld;
  output [1*WIDTH-1:0]           rw_dout;
  input [1*WIDTH-1:0]            rw_din;
  output [1-1:0]                 rw_serr;
  output [1-1:0]                 rw_derr;
  output [1*BITPADR-1:0]         rw_padr;

  input [1-1:0]                  read;
  input [1*BITADDR-1:0]          rd_adr;
  output [1-1:0]                 rd_vld;
  output [1*WIDTH-1:0]           rd_dout;
  output [1-1:0]                 rd_serr;
  output [1-1:0]                 rd_derr;
  output [1*BITPADR-1:0]         rd_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  output [NUMVBNK-1:0] t1_readB;
  output [NUMVBNK*BITSROW-1:0] t1_addrB;
  input [NUMVBNK*PHYWDTH-1:0] t1_doutB;

  output [1-1:0] t2_writeA;
  output [1*BITSROW-1:0] t2_addrA;
  output [1*PHYWDTH-1:0] t2_bwA;
  output [1*PHYWDTH-1:0] t2_dinA;
  output [1-1:0] t2_readB;
  output [1*BITSROW-1:0] t2_addrB;
  input [1*PHYWDTH-1:0] t2_doutB;

  algo_1r1rw_xr_top  
		  #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ENAHEC(ENAHEC), .ENAQEC(ENAQEC), .ECCWDTH(ECCWDTH), 
                    .NUMADDR(NUMADDR),   .BITADDR(BITADDR),   .NUMVROW(NUMVROW),   .BITVROW(BITVROW),
		  .NUMVBNK(NUMVBNK),   .BITVBNK(BITVBNK),   .BITPBNK(BITPBNK),   .NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),
		  .NUMSROW(NUMSROW),   .BITSROW(BITSROW),   .SRAM_DELAY(SRAM_DELAY), 
		  .FLOPIN(FLOPIN),   .FLOPMEM(FLOPMEM),    .FLOPECC(FLOPECC),   .FLOPOUT(FLOPOUT),   .FLOPCMD(FLOPCMD), .PHYWDTH(PHYWDTH))
  algo_top
		(.clk(clk), .rst(rst), .ready(ready),
		.write(rw_write), .wr_adr(rw_addr), .din(rw_din),
		.read({rw_read,read}), .rd_adr({rw_addr,rd_adr}), .rd_vld({rw_vld,rd_vld}), .rd_dout({rw_dout,rd_dout}),
                .rd_serr({rw_serr,rd_serr}), .rd_derr({rw_derr,rd_derr}), .rd_padr({rw_padr,rd_padr}),
		.t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_bwA(t1_bwA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
		.t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_bwA(t2_bwA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB));

// MEMOIR_TRANSLATE_ON

endmodule    //algo_1r1rw_a100_top_wrap
