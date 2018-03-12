/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 *
 * */

module algo_1bor1hu_h1_sva_wrap
#(parameter IP_WIDTH = 64,parameter IP_BITWIDTH = 6,parameter IP_NUMADDR = 8192,parameter IP_BITADDR = 13,
parameter IP_NUMVBNK = 8,parameter IP_BITVBNK = 3,parameter IP_SECCBITS = 4,parameter IP_SECCDWIDTH = 4,parameter IP_BITPBNK = 4,
parameter FLOPIN = 0,parameter FLOPOUT = 0,parameter FLOPCRC = 0,parameter FLOPMEM = 0,parameter FLOPCMD = 0,
parameter FLOPECC = 0,parameter IP_ENAECC = 0,parameter IP_DECCBITS = 8,parameter IP_ENAPAR = 0,
parameter T1_WIDTH = 65,parameter T1_NUMVBNK = 9,parameter T1_BITVBNK = 4,parameter T1_DELAY = 2,
parameter T1_NUMVROW = 1024,parameter T1_BITVROW = 10,parameter T1_BITWSPF = 0,
parameter T1_NUMWRDS = 1,parameter T1_BITWRDS = 0,parameter T1_NUMSROW = 1024,parameter T1_BITSROW = 10,parameter T1_PHYWDTH = 65,
parameter HASH_KYWIDTH = 32,parameter HASH_DTWIDTH = 32, parameter HASH_LGDTWIDTH=5)
(clk,rst,ready,
search,sr_key,sr_dout,sr_vld,sr_match,sr_mhe,sr_serr,sr_derr,sr_padr,
update,up_key,up_din,up_del,up_bp,up_mhe,
t1_readB,t1_addrB,t1_doutB,
t1_writeA,t1_addrA,t1_dinA,t1_bwA);

  parameter NUMSEPT = 1;

  parameter KYWIDTH = HASH_KYWIDTH;
  parameter DTWIDTH = HASH_DTWIDTH;
  parameter LG_DTWIDTH = HASH_LGDTWIDTH;

  parameter NUMVROW = T1_NUMVROW;
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = T1_NUMVBNK;
  parameter BITVBNK = T1_BITVBNK;
  parameter NUMWRDS = T1_NUMWRDS;       // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  
  parameter MEM_DELAY = T1_DELAY;
  
  parameter SLOTWIDTH = KYWIDTH+DTWIDTH+1;
  parameter PLINE_DELAY = MEM_DELAY + FLOPCRC;
  
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;

  parameter BITPADR = BITVBNK+BITSROW+BITWRDS+1;
  parameter MEMWDTH = ENAPAR ? SLOTWIDTH+1 : ENAECC ? SLOTWIDTH+ECCWDTH : SLOTWIDTH;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;

  input clk, rst;
  input ready;

  input  [NUMSEPT-1:0] search;
  input  [NUMSEPT*KYWIDTH-1:0] sr_key;
  input [NUMSEPT*DTWIDTH-1:0] sr_dout;
  input [NUMSEPT-1:0] sr_vld;
  input [NUMSEPT-1:0] sr_match;
  input [NUMSEPT-1:0] sr_mhe;
  input [NUMSEPT-1:0] sr_serr;
  input [NUMSEPT-1:0] sr_derr;
  input [NUMSEPT*BITPADR-1:0] sr_padr;

  input  update;
  input  [KYWIDTH-1:0] up_key;
  input  [DTWIDTH-1:0] up_din;
  input  up_del;
  input up_bp;
  input up_mhe;

  input [NUMSEPT*NUMVBNK-1:0] t1_readB;
  input [NUMSEPT*NUMVBNK*BITSROW-1:0] t1_addrB;
  input  [NUMSEPT*NUMVBNK*PHYWDTH-1:0] t1_doutB;

  input [NUMSEPT*NUMVBNK-1:0] t1_writeA;
  input [NUMSEPT*NUMVBNK*BITSROW-1:0] t1_addrA;
  input [NUMSEPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input [NUMSEPT*NUMVBNK*PHYWDTH-1:0] t1_bwA;


endmodule    //algo_1bor1hu_h1_sva_wrap
