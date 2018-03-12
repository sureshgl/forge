/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_1r3w_a661_sva_wrap
#(parameter IP_WIDTH = 64, parameter IP_BITWIDTH = 6, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, parameter IP_NUMVBNK = 32, parameter IP_BITVBNK = 5,
parameter IP_SECCBITS = 5, parameter IP_SECCDWIDTH = 6, parameter IP_DECCBITS= 0, parameter IP_ENAECC=0, parameter IP_ENAPAR=0,
parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPMEM = 0, parameter FLOPCMD=0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 42, parameter IP_REFFRHF = 0, parameter IP_BITPBNK = 6, parameter IP_REFLOPW = 0,

parameter T1_WIDTH = 64, parameter T1_NUMVBNK = 32, parameter T1_BITVBNK = 5, parameter T1_DELAY = 2, parameter T1_NUMVROW = 256, parameter T1_BITVROW = 8,
parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 256, parameter T1_BITSROW = 8, parameter T1_PHYWDTH = 64, parameter T1_BITWSPF = 0,
parameter T1_NUMRBNK = 1, parameter T1_BITRBNK = 1, parameter T1_NUMRROW = 128, parameter T1_BITRROW = 7, parameter T1_NUMPROW = 1024, parameter T1_BITPROW = 10,

parameter T3_WIDTH = 64, parameter T3_NUMVBNK = 4, parameter T3_BITVBNK = 2, parameter T3_DELAY = 1, parameter T3_NUMVROW = 256, parameter T3_BITVROW = 8,
parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 1, parameter T3_NUMSROW = 256, parameter T3_BITSROW = 8, parameter T3_PHYWDTH = 64, parameter T3_BITWSPF=0,

parameter T2_WIDTH = 17, parameter T2_NUMVBNK = 4, parameter T2_BITVBNK = 2, parameter T2_DELAY = 1, parameter T2_NUMVROW = 256, parameter T2_BITVROW = 8,
parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 256, parameter T2_BITSROW = 8, parameter T2_PHYWDTH = 17, parameter T2_BITWSPF=0)
( clk,  rst,  ready,  refr,
  write,   wr_adr,   din,
 read,   rd_adr,   rd_dout,  rd_vld,  rd_serr,  rd_derr,   rd_padr,
  t1_writeA,  t1_addrA,   t1_dinA,   t1_bwA,   
  t1_readB,   t1_addrB,   t1_doutB,
  t2_writeA,   t2_addrA,   t2_dinA,   t2_bwA,
  t2_writeB,   t2_addrB,   t2_dinB,   t2_bwB,
  t2_readC,   t2_addrC,   t2_doutC,
  t2_readD,   t2_addrD,   t2_doutD,
  t2_readE,   t2_addrE,   t2_doutE,
  t2_readF,   t2_addrF,   t2_doutF,
  t3_writeA,   t3_addrA,   t3_dinA,   t3_bwA,
  t3_readB,   t3_addrB,   t3_doutB);
  
  parameter NUMRDPT = 1;
  parameter NUMRWPT = 0;
  parameter NUMWRPT = 3;
  parameter NUMCASH = NUMRDPT+NUMRWPT+NUMWRPT-1;
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter PARITY = IP_ENAPAR;
  parameter MEMWDTH = WIDTH+PARITY;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;  // ALGO1 Parameters
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMWRDS = T1_NUMWRDS;     // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter PHYWDTH = T1_PHYWDTH;
  parameter BITPROW = T1_BITPROW;
  parameter REFRESH = IP_REFRESH;      // REFRESH Parameters 
  parameter NUMRBNK = T1_NUMRBNK;
  parameter BITRBNK = T1_BITRBNK;
  parameter REFLOPW = IP_REFLOPW;
  parameter NUMRROW = T1_NUMRROW;
  parameter BITRROW = T1_BITRROW;
  parameter REFFREQ = IP_REFFREQ;
  parameter REFFRHF = IP_REFFRHF;
  
  parameter BITDWSN = 0;        //DWSN Parameters
  parameter NUMDWS0 = 0;
  parameter NUMDWS1 = 0;
  parameter NUMDWS2 = 0;
  parameter NUMDWS3 = 0;
  parameter NUMDWS4 = 0;
  parameter NUMDWS5 = 0;
  parameter NUMDWS6 = 0;
  parameter NUMDWS7 = 0;
  parameter NUMDWS8 = 0;
  parameter NUMDWS9 = 0;
  parameter NUMDWS10 = 0;
  parameter NUMDWS11 = 0;
  parameter NUMDWS12 = 0;
  parameter NUMDWS13 = 0;
  parameter NUMDWS14 = 0;
  parameter NUMDWS15 = 0;
  
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T2_DELAY;
  parameter DRAM_DELAY = T1_DELAY;

  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter SDOUT_WIDTH = BITVBNK+1;

  input                                            refr;

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

  input [NUMVBNK-1:0] t1_writeA;
  input [NUMVBNK*BITSROW-1:0] t1_addrA;
  input [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  input [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input [NUMVBNK-1:0] t1_readB;
  input [NUMVBNK*BITSROW-1:0] t1_addrB;
  input  [NUMVBNK*PHYWDTH-1:0] t1_doutB;
  
  parameter SHORTWR = 2;
  parameter EXTRARD = 0;

  input [NUMCASH-1:0] t2_writeA;
  input [NUMCASH*BITVROW-1:0] t2_addrA;
  input [NUMCASH*SDOUT_WIDTH-1:0] t2_dinA;
  input [NUMCASH*SDOUT_WIDTH-1:0] t2_bwA;
  input [NUMCASH-1:0] t2_writeB;
  input [NUMCASH*BITVROW-1:0] t2_addrB;
  input [NUMCASH*SDOUT_WIDTH-1:0] t2_dinB;
  input [NUMCASH*SDOUT_WIDTH-1:0] t2_bwB;
  
  
  input [NUMCASH-1:0] t2_readC;
  input [NUMCASH*BITVROW-1:0] t2_addrC;
  input  [NUMCASH*SDOUT_WIDTH-1:0] t2_doutC;
  input [NUMCASH-1:0] t2_readD;
  input [NUMCASH*BITVROW-1:0] t2_addrD;
  input  [NUMCASH*SDOUT_WIDTH-1:0] t2_doutD;
  input [NUMCASH-1:0] t2_readE;
  input [NUMCASH*BITVROW-1:0] t2_addrE;
  input  [NUMCASH*SDOUT_WIDTH-1:0] t2_doutE;
  input [NUMCASH-1:0] t2_readF;
  input [NUMCASH*BITVROW-1:0] t2_addrF;
  input  [NUMCASH*SDOUT_WIDTH-1:0] t2_doutF;


  input [SHORTWR*NUMCASH-1:0] t3_writeA;
  input [SHORTWR*NUMCASH*BITVROW-1:0] t3_addrA;
  input [SHORTWR*NUMCASH*WIDTH-1:0] t3_dinA;
  input [SHORTWR*NUMCASH*WIDTH-1:0] t3_bwA;
  
  input [SHORTWR*NUMCASH-1:0] t3_readB;
  input [SHORTWR*NUMCASH*BITVROW-1:0] t3_addrB;
  input  [SHORTWR*NUMCASH*WIDTH-1:0] t3_doutB;

endmodule
