/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_2r2w_a83_sva_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 64, parameter T1_NUMVBNK = 32, parameter T1_BITVBNK = 5, parameter T1_DELAY = 2, parameter T1_NUMVROW = 256, parameter T1_BITVROW = 8,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 256, parameter T1_BITSROW = 8, parameter T1_PHYWDTH = 64,

parameter T1_IP_WIDTH = 64, parameter T1_IP_BITWIDTH = 6, parameter T1_IP_NUMADDR = 256, parameter T1_IP_BITADDR = 8, parameter T1_IP_NUMVBNK = 2, parameter T1_IP_BITVBNK = 1,
parameter T1_IP_SECCBITS = 4, parameter T1_IP_SECCDWIDTH = 2, parameter T1_FLOPIN = 0, parameter T1_FLOPOUT = 0, parameter T1_FLOPMEM = 0,
parameter T1_IP_REFRESH = 1, parameter T1_IP_REFFREQ = 42, parameter T1_IP_REFFRHF = 0, parameter T1_IP_BITPBNK = 2,

parameter T1_T1_WIDTH = 65, parameter T1_T1_NUMVBNK = 2, parameter T1_T1_BITVBNK = 1, parameter T1_T1_DELAY = 2, parameter T1_T1_NUMVROW = 128, parameter T1_T1_BITVROW = 7,
parameter T1_T1_BITWSPF = 0, parameter T1_T1_NUMWRDS = 1, parameter T1_T1_BITWRDS = 1, parameter T1_T1_NUMSROW = 128, parameter T1_T1_BITSROW = 7, parameter T1_T1_PHYWDTH = 65,
parameter T1_T1_NUMRBNK = 1, parameter T1_T1_BITRBNK = 1, parameter T1_T1_NUMRROW = 128, parameter T1_T1_BITRROW = 7, parameter T1_T1_NUMPROW = 1024, parameter T1_T1_BITPROW = 10,
parameter T1_T1_BITDWSN = 8, 
parameter T1_T1_NUMDWS0 = 0, parameter T1_T1_NUMDWS1 = 0, parameter T1_T1_NUMDWS2 = 0, parameter T1_T1_NUMDWS3 = 0,
parameter T1_T1_NUMDWS4 = 0, parameter T1_T1_NUMDWS5 = 0, parameter T1_T1_NUMDWS6 = 0, parameter T1_T1_NUMDWS7 = 0,
parameter T1_T1_NUMDWS8 = 0, parameter T1_T1_NUMDWS9 = 0, parameter T1_T1_NUMDWS10 = 0, parameter T1_T1_NUMDWS11 = 0,
parameter T1_T1_NUMDWS12 = 0, parameter T1_T1_NUMDWS13 = 0, parameter T1_T1_NUMDWS14 = 0, parameter T1_T1_NUMDWS15 = 0,

parameter T1_T2_WIDTH = 65, parameter T1_T2_NUMVBNK = 1, parameter T1_T2_BITVBNK = 1, parameter T1_T2_DELAY = 2, parameter T1_T2_NUMVROW = 128, parameter T1_T2_BITVROW = 7,
parameter T1_T2_BITWSPF = 0, parameter T1_T2_NUMWRDS = 1, parameter T1_T2_BITWRDS = 1, parameter T1_T2_NUMSROW = 128, parameter T1_T2_BITSROW = 7, parameter T1_T2_PHYWDTH = 65,
parameter T1_T2_NUMRBNK = 1, parameter T1_T2_BITRBNK = 1, parameter T1_T2_NUMRROW = 128, parameter T1_T2_BITRROW = 7, parameter T1_T2_NUMPROW = 1024, parameter T1_T2_BITPROW = 10,
//Not delcaring DWSN for T1_T2

parameter T3_WIDTH = 64, parameter T3_NUMVBNK = 6, parameter T3_BITVBNK = 3, parameter T3_DELAY = 1, parameter T3_NUMVROW = 256, parameter T3_BITVROW = 8,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 1, parameter T3_NUMSROW = 256, parameter T3_BITSROW = 8, parameter T3_PHYWDTH = 64,

parameter T2_WIDTH = 17, parameter T2_NUMVBNK = 6, parameter T2_BITVBNK = 3, parameter T2_DELAY = 1, parameter T2_NUMVROW = 256, parameter T2_BITVROW = 8,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 256, parameter T2_BITSROW = 8, parameter T2_PHYWDTH = 17)
( clk,  rst,  ready,  refr,
  write,   wr_adr,   din,
  read,   rd_adr,   rd_dout,   rd_vld,   rd_serr,   rd_derr,   rd_padr,
  t1_readA,   t1_writeA,   t1_addrA,   t1_dinA,   t1_bwA,   t1_doutA,   t1_dwsnA,
  t1_refrB,   t1_bankB,
  t2_readA,   t2_writeA,   t2_addrA,   t2_dinA,   t2_bwA,   t2_doutA,   t2_dwsnA,
  t2_refrB,   t2_bankB,
  t3_writeA,   t3_addrA,   t3_dinA,   t3_bwA,
  t3_writeB,   t3_addrB,   t3_dinB,   t3_bwB,
  t3_readC,   t3_addrC,   t3_doutC,
  t3_readD,   t3_addrD,   t3_doutD,
  t4_writeA,   t4_addrA,   t4_dinA,   t4_bwA,
  t4_writeB,   t4_addrB,   t4_dinB,   t4_bwB,
  t4_readC,   t4_addrC,   t4_doutC,
  t4_readD,   t4_addrD,   t4_doutD);
  
  parameter NUMRDPT = 2;
  parameter NUMRWPT = 0;
  parameter NUMWRPT = 2;
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter PARITY = 1;
  parameter MEMWDTH = WIDTH+PARITY;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW1 = T1_NUMVROW;  // ALGO1 Parameters
  parameter BITVROW1 = T1_BITVROW;
  parameter NUMVBNK1 = IP_NUMVBNK;
  parameter BITVBNK1 = IP_BITVBNK;
  parameter BITPBNK1 = IP_BITPBNK;
  parameter FLOPIN1 = FLOPIN;
  parameter FLOPOUT1 = FLOPOUT;
  parameter NUMVROW2 = T1_T1_NUMVROW;   // ALGO2 Parameters
  parameter BITVROW2 = T1_T1_BITVROW;
  parameter NUMVBNK2 = T1_IP_NUMVBNK;
  parameter BITVBNK2 = T1_IP_BITVBNK;
  parameter BITPBNK2 = T1_IP_BITPBNK;
  parameter FLOPIN2 = 0;
  parameter FLOPOUT2 = 0;
  parameter NUMWRDS2 = T1_T1_NUMWRDS;     // ALIGN Parameters
  parameter BITWRDS2 = T1_T1_BITWRDS;
  parameter NUMSROW2 = T1_T1_NUMSROW;
  parameter BITSROW2 = T1_T1_BITSROW;
  parameter PHYWDTH2 = T1_T1_PHYWDTH;
  parameter REFRESH = IP_REFRESH;      // REFRESH Parameters 
  parameter NUMRBNK = T1_T1_NUMRBNK;
  parameter BITWSPF = T1_T1_BITWSPF;
  parameter BITRBNK = T1_T1_BITRBNK;
  parameter REFLOPW = 0;
  parameter NUMRROW = T1_T1_NUMRROW;
  parameter BITRROW = T1_T1_BITRROW;
  parameter REFFREQ = IP_REFFREQ;
  parameter REFFRHF = IP_REFFRHF;
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T2_DELAY;
  parameter DRAM_DELAY = T1_T1_DELAY;
  
  parameter BITDWSN = T1_T1_BITDWSN;        //DWSN Parameters
  parameter NUMDWS0 = T1_T1_NUMDWS0;
  parameter NUMDWS1 = T1_T1_NUMDWS1;
  parameter NUMDWS2 = T1_T1_NUMDWS2;
  parameter NUMDWS3 = T1_T1_NUMDWS3;
  parameter NUMDWS4 = T1_T1_NUMDWS4;
  parameter NUMDWS5 = T1_T1_NUMDWS5;
  parameter NUMDWS6 = T1_T1_NUMDWS6;
  parameter NUMDWS7 = T1_T1_NUMDWS7;
  parameter NUMDWS8 = T1_T1_NUMDWS8;
  parameter NUMDWS9 = T1_T1_NUMDWS9;
  parameter NUMDWS10 = T1_T1_NUMDWS10;
  parameter NUMDWS11 = T1_T1_NUMDWS11;
  parameter NUMDWS12 = T1_T1_NUMDWS12;
  parameter NUMDWS13 = T1_T1_NUMDWS13;
  parameter NUMDWS14 = T1_T1_NUMDWS14;
  parameter NUMDWS15 = T1_T1_NUMDWS15;

  parameter BITPADR2 = BITPBNK2+BITSROW2+BITWRDS2+1;
  parameter BITPADR1 = BITPBNK1+BITPADR2+1;

  parameter SDOUT_WIDTH = 2*(BITVBNK1+1)+ECCBITS;
  parameter NUMCASH = NUMRDPT+NUMRWPT+NUMWRPT-1;

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
  input [NUMRDPT* BITPADR1 - 1:0]     rd_padr;

  input                         ready;
  input                          clk, rst;

  input [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
  input [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
  input [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrA;
  input [NUMVBNK1*NUMVBNK2*BITDWSN-1:0] t1_dwsnA;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_doutA;
  input [NUMVBNK1*NUMVBNK2-1:0] t1_refrB;
  input [NUMVBNK1*NUMVBNK2*BITRBNK-1:0] t1_bankB;

  input [NUMVBNK1-1:0] t2_readA;
  input [NUMVBNK1-1:0] t2_writeA;
  input [NUMVBNK1*BITSROW2-1:0] t2_addrA;
  input [NUMVBNK1*BITDWSN-1:0] t2_dwsnA;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_bwA;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_dinA;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_doutA;
  input [NUMVBNK1-1:0] t2_refrB;
  input [NUMVBNK1*BITRBNK-1:0] t2_bankB;
  
  parameter SHORTWR = 2;
  parameter EXTRARD = 0;

  input [SHORTWR*NUMCASH-1:0] t3_writeA;
  input [SHORTWR*NUMCASH*BITVROW1-1:0] t3_addrA;
  input [SHORTWR*NUMCASH*SDOUT_WIDTH-1:0] t3_dinA;
  input [SHORTWR*NUMCASH*SDOUT_WIDTH-1:0] t3_bwA;
  input [SHORTWR*NUMCASH-1:0] t3_writeB;
  input [SHORTWR*NUMCASH*BITVROW1-1:0] t3_addrB;
  input [SHORTWR*NUMCASH*SDOUT_WIDTH-1:0] t3_dinB;
  input [SHORTWR*NUMCASH*SDOUT_WIDTH-1:0] t3_bwB;
  
  input [SHORTWR*NUMCASH-1:0] t3_readC;
  input [SHORTWR*NUMCASH*BITVROW1-1:0] t3_addrC;
  input  [SHORTWR*NUMCASH*SDOUT_WIDTH-1:0] t3_doutC;
  input [SHORTWR*NUMCASH-1:0] t3_readD;
  input [SHORTWR*NUMCASH*BITVROW1-1:0] t3_addrD;
  input  [SHORTWR*NUMCASH*SDOUT_WIDTH-1:0] t3_doutD;

  input [SHORTWR*NUMCASH-1:0] t4_writeA;
  input [SHORTWR*NUMCASH*BITVROW1-1:0] t4_addrA;
  input [SHORTWR*NUMCASH*WIDTH-1:0] t4_dinA;
  input [SHORTWR*NUMCASH*WIDTH-1:0] t4_bwA;
  input [SHORTWR*NUMCASH-1:0] t4_writeB;
  input [SHORTWR*NUMCASH*BITVROW1-1:0] t4_addrB;
  input [SHORTWR*NUMCASH*WIDTH-1:0] t4_dinB;
  input [SHORTWR*NUMCASH*WIDTH-1:0] t4_bwB;
  
  input [SHORTWR*NUMCASH-1:0] t4_readC;
  input [SHORTWR*NUMCASH*BITVROW1-1:0] t4_addrC;
  input  [SHORTWR*NUMCASH*WIDTH-1:0] t4_doutC;
  input [SHORTWR*NUMCASH-1:0] t4_readD;
  input [SHORTWR*NUMCASH*BITVROW1-1:0] t4_addrD;
  input  [SHORTWR*NUMCASH*WIDTH-1:0] t4_doutD;

endmodule
