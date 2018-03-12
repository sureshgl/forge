/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_2r1w_a682_sva_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAEXT = 0, parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 4, parameter T1_BITVBNK = 2, parameter T1_DELAY = 2, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 0, parameter T1_NUMSROW = 2048, parameter T1_BITSROW = 11, parameter T1_PHYWDTH = 32,

parameter T2_WIDTH = 10, parameter T2_NUMVBNK = 6, parameter T2_BITVBNK = 3, parameter T2_DELAY = 1, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 2048, parameter T2_BITSROW = 11, parameter T2_PHYWDTH = 10,

parameter T3_WIDTH = 71, parameter T3_NUMVBNK = 6, parameter T3_BITVBNK = 3, parameter T3_DELAY = 1, parameter T3_NUMVROW = 2048, parameter T3_BITVROW = 11,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 0, parameter T3_NUMSROW = 2048, parameter T3_BITSROW = 11, parameter T3_PHYWDTH = 71)
( clk,  rst,  ready,
  write,   wr_adr,   din,
  read,   rd_adr,   rd_dout,   rd_vld,   rd_serr,   rd_derr,   rd_padr,
  t1_readA,   t1_writeA,   t1_addrA,   t1_dinA,   t1_bwA,   t1_doutA,
  t2_writeA,   t2_addrA,   t2_dinA,   t2_bwA,   
  t2_readB,   t2_addrB,   t2_doutB,
  t3_writeA,   t3_addrA,   t3_dinA,   t3_bwA,   
  t3_readB,   t3_addrB,   t3_doutB);
  
  parameter NUMRDPT = 2;
  parameter NUMRWPT = 0;
  parameter NUMWRPT = 1;
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAEXT = IP_ENAEXT;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW1 = T1_NUMVROW;  // ALGO1 Parameters
  parameter BITVROW1 = T1_BITVROW;
  parameter NUMVBNK1 = IP_NUMVBNK;
  parameter BITVBNK1 = IP_BITVBNK;
  parameter BITPBNK1 = IP_BITPBNK;
  parameter FLOPIN1 = FLOPIN;
  parameter FLOPOUT1 = FLOPOUT;
  parameter NUMWRDS1 = T1_NUMWRDS;     // ALIGN Parameters
  parameter BITWRDS1 = T1_BITWRDS;
  parameter NUMSROW1 = T1_NUMSROW;
  parameter BITSROW1 = T1_BITSROW;
  parameter PHYWDTH1 = T1_PHYWDTH;
  
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T2_DELAY;
  parameter DRAM_DELAY = T1_DELAY;

  parameter MEMWDTH = ENAEXT ? WIDTH : ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter BITPADR = BITPBNK1+BITSROW1+BITWRDS1+1;

  parameter SDOUT_WIDTH = 2*(BITVBNK1+1)+ECCBITS;
  parameter CDOUT_WIDTH = 2*WIDTH+ECCWDTH;
  parameter NUMCASH = NUMRDPT+NUMRWPT+NUMWRPT-1;

  input  [NUMWRPT - 1:0]            write; 
  input  [NUMWRPT* BITADDR - 1:0]     wr_adr; 
  input  [NUMWRPT* WIDTH - 1:0]        din;

  input  [NUMRDPT - 1:0]             read; 
  input  [NUMRDPT* BITADDR - 1:0]     rd_adr; 
  input [NUMRDPT* WIDTH - 1:0]     rd_dout; 
  input [NUMRDPT - 1:0]             rd_vld; 
  input [NUMRDPT - 1:0]             rd_serr; 
  input [NUMRDPT - 1:0]             rd_derr; 
  input [NUMRDPT* BITPADR - 1:0]     rd_padr;

  input                         ready;
  input                          clk, rst;

  input [NUMVBNK1*NUMRDPT-1:0] t1_readA;
  input [NUMVBNK1*NUMRDPT-1:0] t1_writeA;
  input [NUMVBNK1*NUMRDPT*BITSROW1-1:0] t1_addrA;
  input [NUMVBNK1*NUMRDPT*PHYWDTH1-1:0] t1_bwA;
  input [NUMVBNK1*NUMRDPT*PHYWDTH1-1:0] t1_dinA;
  input [NUMVBNK1*NUMRDPT*PHYWDTH1-1:0] t1_doutA;

  parameter SHORTWR = 3;
  input [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t2_writeA;
  input [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t2_addrA;
  input [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_dinA;
  input [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_bwA;
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB;
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t2_addrB;
  input  [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_doutB;

  input [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t3_writeA;
  input [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrA;
  input [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*CDOUT_WIDTH-1:0] t3_dinA;
  input [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*CDOUT_WIDTH-1:0] t3_bwA;
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB;
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrB;
  input  [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*CDOUT_WIDTH-1:0] t3_doutB;
  

endmodule
