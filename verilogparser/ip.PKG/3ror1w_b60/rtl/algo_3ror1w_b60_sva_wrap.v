/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

module algo_3ror1w_b60_sva_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAEXT = 0, parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 16, parameter T1_NUMVBNK = 8, parameter T1_BITVBNK = 3, parameter T1_DELAY = 2, parameter T1_NUMVROW = 16384, parameter T1_BITVROW = 14,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 4, parameter T1_BITWRDS = 2, parameter T1_NUMSROW = 4096, parameter T1_BITSROW = 12, parameter T1_PHYWDTH = 64, 
parameter T1_NUMRBNK = 2, parameter T1_BITRBNK = 1, parameter T1_NUMRROW = 256, parameter T1_BITRROW = 8, parameter T1_NUMPROW = 4096, parameter T1_BITPROW = 12,
parameter T1_BITDWSN = 8, 
parameter T1_NUMDWS0 = 0, parameter T1_NUMDWS1 = 0, parameter T1_NUMDWS2 = 0, parameter T1_NUMDWS3 = 0,
parameter T1_NUMDWS4 = 0, parameter T1_NUMDWS5 = 0, parameter T1_NUMDWS6 = 0, parameter T1_NUMDWS7 = 0,
parameter T1_NUMDWS8 = 0, parameter T1_NUMDWS9 = 0, parameter T1_NUMDWS10 = 0, parameter T1_NUMDWS11 = 0,
parameter T1_NUMDWS12 = 0, parameter T1_NUMDWS13 = 0, parameter T1_NUMDWS14 = 0, parameter T1_NUMDWS15 = 0)
( clk,  rst,  ready,  refr,
 write, wr_adr, din, 
 read, rd_adr, rd_dout, rd_vld, rd_serr, rd_derr, rd_padr,
 t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_doutA, t1_read_serrA, t1_dwsnA, t1_refrB, t1_bankB);

 
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ECCWDTH = IP_DECCBITS;
  parameter ENAEXT = IP_ENAEXT;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;   // ALGO Parameters
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter REFRESH = IP_REFRESH;      // REFRESH Parameters 
  parameter NUMRBNK = T1_NUMRBNK;
  parameter BITWSPF = T1_BITWSPF;
  parameter BITRBNK = T1_BITRBNK;
  parameter NUMRROW = T1_NUMRROW;
  parameter BITRROW = T1_BITRROW;
  parameter REFFREQ = IP_REFFREQ;
  parameter REFFRHF = IP_REFFRHF;
  
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

  parameter SRAM_DELAY = T1_DELAY;
  parameter PHYWDTH = T1_PHYWDTH;

  parameter NUMRDPT = 3;
  parameter BITPADR = BITVBNK+BITSROW+BITWRDS+1;

  input                          refr;

  input                          write;
  input [BITADDR-1:0]            wr_adr;
  input [WIDTH-1:0]              din;

  input [NUMRDPT-1:0]            read;
  input [NUMRDPT*BITADDR-1:0]    rd_adr;
  input [NUMRDPT-1:0]           rd_vld;
  input [NUMRDPT*WIDTH-1:0]     rd_dout;
  input [NUMRDPT-1:0]           rd_serr;
  input [NUMRDPT-1:0]           rd_derr;
  input [NUMRDPT*BITPADR-1:0]   rd_padr;

  input                         ready;
  input                          clk, rst;

  input [NUMRDPT*NUMVBNK-1:0] t1_readA;
  input [NUMRDPT*NUMVBNK-1:0] t1_writeA;
  input [NUMRDPT*NUMVBNK*BITSROW-1:0] t1_addrA;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_bwA;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input  [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_doutA;
  input  [NUMRDPT*NUMVBNK-1:0] t1_read_serrA;
  input [NUMRDPT*NUMVBNK*BITDWSN-1:0] t1_dwsnA;
  
  input [NUMRDPT*NUMVBNK-1:0] t1_refrB;
  input [NUMRDPT*NUMVBNK*BITRBNK-1:0] t1_bankB;


endmodule    //algo_3ror1w_b60_sva_wrap
