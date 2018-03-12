/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 *
 * */

module algo_2rw_a54_top_wrap
  #(parameter IP_WIDTH = 64,
    parameter   IP_BITWIDTH = 6,
    parameter   IP_DECCBITS = 8,
    parameter   IP_NUMADDR = 2048,
    parameter   IP_BITADDR = 11,
    parameter   IP_NUMVBNK = 1,
    parameter   IP_BITVBNK = 1,
    parameter   IP_BITPBNK = 2,
    parameter   IP_SECCBITS = 8,
    parameter   IP_SECCDWIDTH = 2,
    parameter   IP_ENAECC = 0,
    parameter   IP_ENAPAR = 0,
    parameter   FLOPADD = 0,
    parameter   FLOPIN = 0,
    parameter   FLOPOUT = 0,
    parameter   FLOPMEM = 0,
    parameter   FLOPECC = 0,
    parameter   FLOPCMD = 0,
    parameter   T1_WIDTH = 73,
    parameter   T1_NUMVBNK = 4,
    parameter   T1_BITVBNK = 2,
    parameter   T1_DELAY = 1,
    parameter   T1_NUMVROW = 2048,
    parameter   T1_BITVROW = 11,
    parameter   T1_BITWSPF = 0,
    parameter   T1_NUMWRDS = 1,
    parameter   T1_BITWRDS = 1,
    parameter   T1_NUMSROW = 2048,
    parameter   T1_BITSROW = 11,
    parameter   T1_PHYWDTH = 73)
  (clk, rst, ready,
   rw_read,
   rw_write,
   rw_addr,
   rw_din,
   rw_dout,
   rw_vld,
   rw_serr,
   rw_derr,
   rw_padr,
   t1_readB,
   t1_addrB,
   t1_doutB,
   t1_writeA,
   t1_addrA,
   t1_dinA,
   t1_bwA);

  // MEMOIR_TRANSLATE_OFF

  parameter WIDTH   = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR  = IP_ENAPAR;
  parameter ENAECC =  IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMRWPT = 2;
  parameter NUMPBNK = 4; // NUMRWPT*NUMRWPT
  parameter BITPBNK = 2;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter PHYWDTH = T1_PHYWDTH;
  parameter SRAM_DELAY = T1_DELAY;
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  input [NUMRWPT-1:0]                  rw_read;
  input [NUMRWPT-1:0]                  rw_write;
  input [NUMRWPT*BITADDR-1:0]          rw_addr;
  input [NUMRWPT*WIDTH-1:0]            rw_din;
  output [NUMRWPT-1:0]                 rw_vld;
  output [NUMRWPT*WIDTH-1:0]           rw_dout;
  output [NUMRWPT-1:0]                 rw_serr;
  output [NUMRWPT-1:0]                 rw_derr;
  output [2*BITPADR-1:0]               rw_padr;
  output                               ready;
  input                                clk;
  input                                rst;

  output [NUMPBNK-1:0]                 t1_writeA;
  output [NUMPBNK*BITSROW-1:0]         t1_addrA;
  output [NUMPBNK*PHYWDTH-1:0]         t1_bwA;
  output [NUMPBNK*PHYWDTH-1:0]         t1_dinA;

  output [NUMPBNK-1:0]                 t1_readB;
  output [NUMPBNK*BITSROW-1:0]         t1_addrB;
  input [NUMPBNK*PHYWDTH-1:0]          t1_doutB;

  algo_2rw_1r1w_top #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ECCWDTH(ECCWDTH),
                     .NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMRWPT(NUMRWPT),
                     .NUMPBNK(NUMPBNK), .BITPBNK(BITPBNK),
                     .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS), .NUMSROW(NUMSROW), .BITSROW(BITSROW), .PHYWDTH(PHYWDTH),
                     .SRAM_DELAY(SRAM_DELAY), .FLOPIN(FLOPIN), .FLOPMEM(FLOPMEM), .FLOPOUT(FLOPOUT), .FLOPECC(FLOPECC))

  algo_top(.clk(clk), .rst(rst), .ready(ready),
           .read(rw_read), .write(rw_write), .addr(rw_addr), .din(rw_din),
           .rd_vld(rw_vld), .rd_dout(rw_dout), .rd_serr(rw_serr), .rd_derr(rw_derr),
           .rd_padr(rw_padr), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA),
           .t1_bwA(t1_bwA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB),
           .t1_doutB(t1_doutB));

  // MEMOIR_TRANSLATE_ON

endmodule // algo_2rw_a54_top_wrap
