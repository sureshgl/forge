/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.1.UNKNOWN Date: Wed 2012.03.07 at 08:01:10 PM IST
 * */

module algo_1rw_a25_sva_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0, 
parameter IP_A1_NUMVROW = 4, parameter IP_A1_BITVROW = 2,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 1, parameter T1_DELAY = 3, parameter T1_NUMVROW = 8192, parameter T1_BITVROW = 13,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 2048, parameter T1_BITSROW = 11, parameter T1_PHYWDTH = 32,
parameter T1_NUMRBNK = 4, parameter T1_BITRBNK = 2, parameter T1_NUMRROW = 256, parameter T1_BITRROW = 8, parameter T1_NUMPROW = 8192, parameter T1_BITPROW = 13,
parameter T1_M_NUMVBNK = 4, parameter T1_M_BITVBNK = 2, parameter T1_ISDCR = 0,

parameter T2_WIDTH = 32, parameter T2_NUMVBNK = 1, parameter T2_BITVBNK = 1, parameter T2_DELAY = 2, parameter T2_NUMVROW = 8192, parameter T2_BITVROW = 13,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 8192, parameter T2_BITSROW = 13, parameter T2_PHYWDTH = 32,

parameter T3_WIDTH = 10, parameter T3_NUMVBNK = 1, parameter T3_BITVBNK = 1, parameter T3_DELAY = 2, parameter T3_NUMVROW = 2048, parameter T3_BITVROW = 11,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 1, parameter T3_NUMSROW = 2048, parameter T3_BITSROW = 11, parameter T3_PHYWDTH = 10, 

parameter T4_WIDTH = 32, parameter T4_NUMVBNK = 1, parameter T4_BITVBNK = 1, parameter T4_DELAY = 2, parameter T4_NUMVROW = 2048, parameter T4_BITVROW = 11,
parameter T4_BITWSPF = 0, parameter T4_NUMWRDS = 1, parameter T4_BITWRDS = 1, parameter T4_NUMSROW = 2048, parameter T4_BITSROW = 11, parameter T4_PHYWDTH = 32)
						(refr, rw_read, rw_write, rw_addr, rw_din, rw_vld, rw_dout, rw_err, rw_derr, rw_padr,
                              ready, clk, rst,
                              t1_readA, t1_writeA, t1_addrA, t1_bankA, t1_bwA, t1_dinA, t1_doutA, t1_refrB, t1_bankB,
                              t2_readA, t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_doutA,
                              t3_writeA, t3_addrA, t3_dinA, t3_bwA, t3_readB, t3_addrB, t3_doutB,
                              t4_writeA, t4_addrA, t4_dinA, t4_bwA, t4_readB, t4_addrB, t4_doutB);
							  
  parameter WIDTH = IP_WIDTH;			
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;

  parameter NUMVBNK = T1_M_NUMVBNK;
  parameter BITVBNK = T1_M_BITVBNK;
  parameter NUMVROW = T3_NUMVROW;
  parameter BITVROW = T3_BITVROW;

  parameter NUMMBNK = T1_NUMVBNK;
  parameter BITMBNK = T1_BITVBNK;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMMROW = T1_NUMVROW;
  parameter BITMROW = T1_BITVROW;

  parameter NUMWRDS = T1_NUMWRDS;
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;

  parameter REFRESH = IP_REFRESH;
  parameter NUMRROW = T1_NUMRROW;
  parameter BITRROW = T1_BITRROW;
  parameter REFFREQ = IP_REFFREQ;

  parameter ECCBITS = IP_SECCBITS;
  parameter PARITY = 1;
  parameter PHYWDTH = T1_PHYWDTH;

  parameter SRAM_DELAY = T3_DELAY;
  parameter DRAM_DELAY = T1_DELAY;
                                   
  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;
  parameter MEMWDTH = WIDTH+PARITY;
  parameter BITPADR = BITPBNK+BITVBNK+BITWRDS+BITSROW+2;

  input                        refr;

  input                        rw_read;
  input                        rw_write;
  input [BITADDR-1:0]          rw_addr;
  input [WIDTH-1:0]            rw_din;
  input                       rw_vld;
  input [WIDTH-1:0]           rw_dout;
  input                       rw_err;
  input                       rw_derr;
  input [BITPADR-1:0]         rw_padr;

  input                       ready;
  input                        clk;
  input                        rst;

  input [NUMMBNK-1:0] t1_readA;
  input [NUMMBNK-1:0] t1_writeA;
  input [NUMMBNK*BITSROW-1:0] t1_addrA;
  input [NUMMBNK*BITVBNK-1:0] t1_bankA;
  input [NUMMBNK*PHYWDTH-1:0] t1_bwA;
  input [NUMMBNK*PHYWDTH-1:0] t1_dinA;
  input [NUMMBNK*PHYWDTH-1:0] t1_doutA;

  input [NUMMBNK-1:0] t1_refrB;
  input [NUMMBNK*BITVBNK-1:0] t1_bankB;

  input [1-1:0] t2_readA;
  input [1-1:0] t2_writeA;
  input [1*(BITVBNK+BITSROW)-1:0] t2_addrA;
  input [1*PHYWDTH-1:0] t2_bwA;
   input [1*PHYWDTH-1:0] t2_dinA;
  input [1*PHYWDTH-1:0] t2_doutA;

  input [1-1:0] t3_writeA;
  input [1*BITVROW-1:0] t3_addrA;
  input [1*SDOUT_WIDTH-1:0] t3_dinA;
  input [1*SDOUT_WIDTH-1:0] t3_bwA;

  input [1-1:0] t3_readB;
  input [1*BITVROW-1:0] t3_addrB;
  input [1*SDOUT_WIDTH-1:0] t3_doutB;

  input [1-1:0] t4_writeA;
  input [1*BITVROW-1:0] t4_addrA;
  input [1*WIDTH-1:0] t4_dinA;
  input [1*WIDTH-1:0] t4_bwA;

  input [1-1:0] t4_readB;
  input [1*BITVROW-1:0] t4_addrB;
  input [1*WIDTH-1:0] t4_doutB;
  
endmodule
