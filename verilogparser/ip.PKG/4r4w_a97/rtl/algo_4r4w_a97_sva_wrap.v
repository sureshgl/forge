/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.UNKNOWN Date: Wed 2012.11.21 at 01:59:18 PM IST
 * */

module algo_4r4w_a97_sva_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 32, parameter T1_BITVBNK = 5, parameter T1_DELAY = 1, parameter T1_NUMVROW = 512, parameter T1_BITVROW = 9,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 2, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 256, parameter T1_BITSROW = 8, parameter T1_PHYWDTH = 64,
parameter T2_WIDTH = 32, parameter T2_NUMVBNK = 3, parameter T2_BITVBNK = 2, parameter T2_DELAY = 1, parameter T2_NUMVROW = 512, parameter T2_BITVROW = 9,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 512, parameter T2_BITSROW = 9, parameter T2_PHYWDTH = 32,
parameter T3_WIDTH = 15, parameter T3_NUMVBNK = 4, parameter T3_BITVBNK = 2, parameter T3_DELAY = 1, parameter T3_NUMVROW = 512, parameter T3_BITVROW = 9,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 1, parameter T3_NUMSROW = 512, parameter T3_BITSROW = 9, parameter T3_PHYWDTH = 15)
( clk,  rst,  ready,
  write,   wr_adr,   din,
  read,   rd_adr,   rd_dout,   rd_vld,   rd_serr,   rd_derr,   rd_padr,
  t1_writeA,   t1_addrA,   t1_dinA,    t1_bwA,   t1_writeB,   t1_addrB,   t1_dinB,   t1_bwB,
  t1_readC,    t1_addrC,   t1_doutC,   t1_readD,   t1_addrD,   t1_doutD,
  t2_writeA,   t2_addrA,   t2_dinA,    t2_bwA,   t2_writeB,   t2_addrB,   t2_dinB,   t2_bwB,
  t2_readC,    t2_addrC,   t2_doutC,   t2_readD,   t2_addrD,   t2_doutD,
  t3_dinA,     t3_bwA,     t3_writeB,  t3_addrB,   t3_dinB,   t3_bwB,
  t3_readC,    t3_addrC,   t3_doutC,   t3_readD,   t3_addrD,   t3_doutD,   t3_writeA,   t3_addrA);
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter PHYWDTH = NUMWRDS*WIDTH;
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T1_DELAY;
  
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;
  
  input [4-1:0]                        write;
  input [4*BITADDR-1:0]                wr_adr;
  input [4*WIDTH-1:0]                  din;

  input [4-1:0]                        read;
  input [4*BITADDR-1:0]                rd_adr;
  input [4-1:0]                       rd_vld;
  input [4*WIDTH-1:0]                 rd_dout;
  input [4-1:0]                       rd_serr;
  input [4-1:0]                       rd_derr;
  input [4*BITPADR-1:0]               rd_padr;

  input                               ready;
  input                                clk, rst;

  input [T1_NUMVBNK-1:0] t1_writeA;
  input [T1_NUMVBNK*BITSROW-1:0] t1_addrA;
  input [T1_NUMVBNK*PHYWDTH-1:0] t1_bwA;
  input [T1_NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input [T1_NUMVBNK-1:0] t1_writeB;
  input [T1_NUMVBNK*BITSROW-1:0] t1_addrB;
  input [T1_NUMVBNK*PHYWDTH-1:0] t1_bwB;
  input [T1_NUMVBNK*PHYWDTH-1:0] t1_dinB;

  input [T1_NUMVBNK-1:0] t1_readC;
  input [T1_NUMVBNK*BITSROW-1:0] t1_addrC;
  input  [T1_NUMVBNK*PHYWDTH-1:0] t1_doutC;
  input [T1_NUMVBNK-1:0] t1_readD;
  input [T1_NUMVBNK*BITSROW-1:0] t1_addrD;
  input  [T1_NUMVBNK*PHYWDTH-1:0] t1_doutD;

  input [T2_NUMVBNK-1:0] t2_writeA;
  input [T2_NUMVBNK*BITVROW-1:0] t2_addrA;
  input [T2_NUMVBNK*WIDTH-1:0] t2_dinA;
  input [T2_NUMVBNK*WIDTH-1:0] t2_bwA;
  input [T2_NUMVBNK-1:0] t2_writeB;
  input [T2_NUMVBNK*BITVROW-1:0] t2_addrB;
  input [T2_NUMVBNK*WIDTH-1:0] t2_dinB;
  input [T2_NUMVBNK*WIDTH-1:0] t2_bwB;
  
  input [T2_NUMVBNK-1:0] t2_readC;
  input [T2_NUMVBNK*BITVROW-1:0] t2_addrC;
  input  [T2_NUMVBNK*WIDTH-1:0] t2_doutC;
  input [T2_NUMVBNK-1:0] t2_readD;
  input [T2_NUMVBNK*BITVROW-1:0] t2_addrD;
  input  [T2_NUMVBNK*WIDTH-1:0] t2_doutD;
  
  input [T3_NUMVBNK-1:0] t3_writeA;
  input [T3_NUMVBNK*BITVROW-1:0] t3_addrA;
  input [T3_NUMVBNK*SDOUT_WIDTH-1:0] t3_dinA;
  input [T3_NUMVBNK*SDOUT_WIDTH-1:0] t3_bwA;
  input [T3_NUMVBNK-1:0] t3_writeB;
  input [T3_NUMVBNK*BITVROW-1:0] t3_addrB;
  input [T3_NUMVBNK*SDOUT_WIDTH-1:0] t3_dinB;
  input [T3_NUMVBNK*SDOUT_WIDTH-1:0] t3_bwB;

  input [T3_NUMVBNK-1:0] t3_readC;
  input [T3_NUMVBNK*BITVROW-1:0] t3_addrC;
  input  [T3_NUMVBNK*SDOUT_WIDTH-1:0] t3_doutC;
  input [T3_NUMVBNK-1:0] t3_readD;
  input [T3_NUMVBNK*BITVROW-1:0] t3_addrD;
  input  [T3_NUMVBNK*SDOUT_WIDTH-1:0] t3_doutD;

endmodule
