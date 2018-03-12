/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 *
 * */

module algo_1bor1hu_h1_top_wrap
#(parameter IP_WIDTH = 64,parameter IP_BITWIDTH = 6,parameter IP_NUMADDR = 8192,parameter IP_BITADDR = 13,
parameter IP_NUMVBNK = 8,parameter IP_BITVBNK = 3,parameter IP_SECCBITS = 4,parameter IP_SECCDWIDTH = 4,parameter IP_BITPBNK = 4,
parameter FLOPIN = 0,parameter FLOPOUT = 0,parameter FLOPCRC = 0,parameter FLOPMEM = 0,parameter FLOPCMD = 0,
parameter FLOPECC = 0,parameter IP_ENAECC = 0,parameter IP_DECCBITS = 8,parameter IP_ENAPAR = 0,
parameter T1_WIDTH = 65,parameter T1_NUMVBNK = 9,parameter T1_BITVBNK = 4,parameter T1_DELAY = 2,
parameter T1_NUMVROW = 1024,parameter T1_BITVROW = 10,parameter T1_BITWSPF = 0,
parameter T1_NUMWRDS = 1,parameter T1_BITWRDS = 0,parameter T1_NUMSROW = 1024,parameter T1_BITSROW = 10,parameter T1_PHYWDTH = 65,
parameter HASH_KYWIDTH = 32,parameter HASH_DTWIDTH = 32, parameter HASH_LGDTWIDTH=5)
(clk,rst,ready, disp_en, freeze,
   cpu_read, cpu_write, cpu_bnk, cpu_addr, cpu_din, cpu_dout, cpu_vld,
  search,sr_key,sr_dout,sr_vld,sr_match,sr_mhe,sr_serr,sr_derr,sr_padr,
  update,up_key,up_din,up_del,up_bp,
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
  parameter BITPBNK = IP_BITPBNK;
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

  input clk, rst, disp_en, freeze;
  output ready;

  input cpu_read;
  input cpu_write;
  input [BITPBNK-1:0] cpu_bnk;
  input [BITVROW-1:0] cpu_addr;
  input [SLOTWIDTH-1:0] cpu_din;
  output[SLOTWIDTH-1:0] cpu_dout;
  output              cpu_vld;

  input  [NUMSEPT-1:0] search;
  input  [NUMSEPT*KYWIDTH-1:0] sr_key;
  output [NUMSEPT*DTWIDTH-1:0] sr_dout;
  output [NUMSEPT-1:0] sr_vld;
  output [NUMSEPT-1:0] sr_match;
  output [NUMSEPT-1:0] sr_mhe;
  output [NUMSEPT-1:0] sr_serr;
  output [NUMSEPT-1:0] sr_derr;
  output [NUMSEPT*BITPADR-1:0] sr_padr;

  input  update;
  input  [KYWIDTH-1:0] up_key;
  input  [DTWIDTH-1:0] up_din;
  input  up_del;
  output up_bp;

  output [NUMSEPT*NUMVBNK-1:0] t1_readB;
  output [NUMSEPT*NUMVBNK*BITSROW-1:0] t1_addrB;
  input  [NUMSEPT*NUMVBNK*PHYWDTH-1:0] t1_doutB;

  output [NUMSEPT*NUMVBNK-1:0] t1_writeA;
  output [NUMSEPT*NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMSEPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;
  output [NUMSEPT*NUMVBNK*PHYWDTH-1:0] t1_bwA;

  algo_nbor1hu_1r1w_nocam_top
  #(.NUMSEPT(NUMSEPT), .KYWIDTH(KYWIDTH), .DTWIDTH(DTWIDTH), .NUMVROW(NUMVROW), .BITVROW(BITVROW),
    .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .MEM_DELAY(MEM_DELAY), .BITPBNK(BITPBNK),
    .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS), .NUMSROW(NUMSROW), .BITSROW(BITSROW),
    .FLOPCRC(FLOPCRC), .FLOPIN(FLOPIN), .FLOPMEM(FLOPMEM), .FLOPECC(FLOPECC), .FLOPOUT(FLOPOUT), .FLOPCMD(FLOPCMD))
  algo_top (.clk(clk), .rst(rst), .ready(ready), .disp_en(disp_en), .freeze(freeze),
  .cpu_read(cpu_read), .cpu_write(cpu_write), .cpu_bnk(cpu_bnk), .cpu_addr(cpu_addr), .cpu_din(cpu_din), .cpu_dout(cpu_dout), .cpu_vld(cpu_vld),
  .sr_en(search), .sr_key(sr_key), .sr_dout(sr_dout), .sr_vld(sr_vld), .sr_match(sr_match), .sr_mhe(sr_mhe),
  .sr_serr(sr_serr), .sr_derr(sr_derr), .sr_padr(sr_padr),
  .up_en(update), .up_key(up_key), .up_din(up_din), .up_del(up_del), .up_bp(up_bp), 
  .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
  .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_bwA(t1_bwA));


endmodule    //algo_1bor1hu_h1_top_wrap
