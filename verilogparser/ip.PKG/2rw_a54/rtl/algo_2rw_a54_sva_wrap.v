/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 *
 * */

module algo_2rw_a54_sva_wrap
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
  input [NUMRWPT-1:0]                 rw_vld;
  input [NUMRWPT*WIDTH-1:0]           rw_dout;
  input [NUMRWPT-1:0]                 rw_serr;
  input [NUMRWPT-1:0]                 rw_derr;
  input [2*BITPADR-1:0]               rw_padr;
  input                               ready;
  input                                clk;
  input                                rst;

  input [NUMPBNK-1:0]                 t1_writeA;
  input [NUMPBNK*BITSROW-1:0]         t1_addrA;
  input [NUMPBNK*PHYWDTH-1:0]         t1_bwA;
  input [NUMPBNK*PHYWDTH-1:0]         t1_dinA;

  input [NUMPBNK-1:0]                 t1_readB;
  input [NUMPBNK*BITSROW-1:0]         t1_addrB;
  input [NUMPBNK*PHYWDTH-1:0]          t1_doutB;

endmodule
