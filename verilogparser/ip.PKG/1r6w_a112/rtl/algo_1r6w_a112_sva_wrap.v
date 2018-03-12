/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.UNKNOWN Date: Wed 2012.11.21 at 01:59:18 PM IST
 * */

module algo_1r6w_a112_sva_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 1, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 8, parameter T1_BITVBNK = 3, parameter T1_DELAY = 1, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 2, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 1024, parameter T1_BITSROW = 10, parameter T1_PHYWDTH = 64,
parameter T2_WIDTH = 32, parameter T2_NUMVBNK = 4, parameter T2_BITVBNK = 2, parameter T2_DELAY = 1, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 2, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 1024, parameter T2_BITSROW = 10, parameter T2_PHYWDTH = 64)
( clk,  rst,  ready,
  write,   wr_adr,   din,
  read,   rd_adr,   rd_dout,   rd_vld,   rd_serr,   rd_derr,   rd_padr,
  t1_writeA,   t1_addrA,   t1_dinA,    t1_bwA,   t1_readB,    t1_addrB,   t1_doutB,
  t2_writeA,   t2_addrA,   t2_dinA,    t2_bwA,   t2_readB,    t2_addrB,   t2_doutB);
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter NUMPBNK = IP_NUMVBNK + 2;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter PHYWDTH = T1_PHYWDTH;
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = T1_DELAY;
  parameter NUMRDPT = 1;
  parameter NUMWRPT = 6;
  
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter BITMAPT = (BITPBNK+1)*NUMVBNK;
  
  input [NUMWRPT-1:0]                  write;
  input [NUMWRPT*BITADDR-1:0]          wr_adr;
  input [NUMWRPT*WIDTH-1:0]            din;

  input [NUMRDPT-1:0]                  read;
  input [NUMRDPT*BITADDR-1:0]          rd_adr;
  input [NUMRDPT-1:0]                 rd_vld;
  input [NUMRDPT*WIDTH-1:0]           rd_dout;
  input [NUMRDPT-1:0]                 rd_serr;
  input [NUMRDPT-1:0]                 rd_derr;
  input [NUMRDPT*BITPADR-1:0]         rd_padr;

  input                               ready;
  input                                clk, rst;

  input [T1_NUMVBNK-1:0] t1_writeA;
  input [T1_NUMVBNK*BITSROW-1:0] t1_addrA;
  input [T1_NUMVBNK*PHYWDTH-1:0] t1_bwA;
  input [T1_NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input [T1_NUMVBNK-1:0] t1_readB;
  input [T1_NUMVBNK*BITSROW-1:0] t1_addrB;
  input  [T1_NUMVBNK*PHYWDTH-1:0] t1_doutB;

  input [T2_NUMVBNK-1:0] t2_writeA;
  input [T2_NUMVBNK*BITSROW-1:0] t2_addrA;
  input [T2_NUMVBNK*PHYWDTH-1:0] t2_bwA;
  input [T2_NUMVBNK*PHYWDTH-1:0] t2_dinA;
  input [T2_NUMVBNK-1:0] t2_readB;
  input [T2_NUMVBNK*BITSROW-1:0] t2_addrB;
  input  [T2_NUMVBNK*PHYWDTH-1:0] t2_doutB;

endmodule
