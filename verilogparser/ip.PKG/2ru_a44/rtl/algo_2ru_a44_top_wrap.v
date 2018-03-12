/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 *
 * */

module algo_2ru_a44_top_wrap
  #(parameter   IP_WIDTH = 8,
    parameter   IP_BITWIDTH = 3,
    parameter   IP_DECCBITS = 4,
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
    parameter   T1_WIDTH = 32,
    parameter   T1_NUMVBNK = 4,
    parameter   T1_BITVBNK = 2,
    parameter   T1_DELAY = 1,
    parameter   T1_NUMVROW = 2048,
    parameter   T1_BITVROW = 11,
    parameter   T1_BITWSPF = 0,
    parameter   T1_NUMWRDS = 4,
    parameter   T1_BITWRDS = 2,
    parameter   T1_NUMSROW = 512,
    parameter   T1_BITSROW = 9,
    parameter   T1_PHYWDTH = 32)
  (clk, rst, ready,
   ru_read,
   ru_write,
   ru_addr,
   ru_din,
   ru_dout,
   ru_vld,
   ru_serr,
   ru_derr,
   ru_padr,
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
  parameter NUMRUPT = 2;
  parameter NUMPBNK = 4; // NUMRUPT*NUMRUPT
  parameter BITPBNK = 2;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMVROW = T1_NUMSROW;
  parameter BITVROW = T1_BITSROW;
  parameter MEMWDTH = ENAPAR ? NUMWRDS*WIDTH+1 : ENAECC ? NUMWRDS*WIDTH+ECCWDTH : NUMWRDS*WIDTH;
  parameter PHYWDTH = T1_PHYWDTH;
  parameter SRAM_DELAY = T1_DELAY;
  parameter UPD_DELAY = 2;
  parameter BITPADR = BITPBNK+BITVROW+BITWRDS+1;

  input [NUMRUPT-1:0]                  ru_read;
  input [NUMRUPT-1:0]                  ru_write;
  input [NUMRUPT*BITADDR-1:0]          ru_addr;
  input [NUMRUPT*WIDTH-1:0]            ru_din;
  output [NUMRUPT-1:0]                 ru_vld;
  output [NUMRUPT*WIDTH-1:0]           ru_dout;
  output [NUMRUPT-1:0]                 ru_serr;
  output [NUMRUPT-1:0]                 ru_derr;
  output [2*BITPADR-1:0]               ru_padr;
  output                               ready;
  input                                clk;
  input                                rst;

  output [NUMPBNK-1:0]                 t1_writeA;
  output [NUMPBNK*BITVROW-1:0]         t1_addrA;
  output [NUMPBNK*PHYWDTH-1:0]         t1_bwA;
  output [NUMPBNK*PHYWDTH-1:0]         t1_dinA;

  output [NUMPBNK-1:0]                 t1_readB;
  output [NUMPBNK*BITVROW-1:0]         t1_addrB;
  input [NUMPBNK*PHYWDTH-1:0]          t1_doutB;

  algo_2ru_a44_top #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ECCWDTH(ECCWDTH),
                     .NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMRUPT(NUMRUPT),
                     .NUMPBNK(NUMPBNK), .BITPBNK(BITPBNK),
                     .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS), .NUMVROW(NUMVROW), .BITVROW(BITVROW), .PHYWDTH(PHYWDTH),
                     .SRAM_DELAY(SRAM_DELAY), .UPD_DELAY(UPD_DELAY), .FLOPIN(FLOPIN), .FLOPMEM(FLOPMEM), .FLOPOUT(FLOPOUT), .FLOPECC(FLOPECC))

  algo_top(.clk(clk), .rst(rst), .ready(ready),
           .read(ru_read), .write(ru_write), .addr(ru_addr), .din(ru_din),
           .rd_vld(ru_vld), .rd_dout(ru_dout), .rd_serr(ru_serr), .rd_derr(ru_derr),
           .rd_padr(ru_padr), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA),
           .t1_bwA(t1_bwA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB),
           .t1_doutB(t1_doutB));

  // MEMOIR_TRANSLATE_ON

endmodule // algo_2ru_a44_top_wrap
