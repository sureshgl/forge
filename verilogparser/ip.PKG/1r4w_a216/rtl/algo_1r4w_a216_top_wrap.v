/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.8424M Date: Sat 2014.10.25 at 10:33:29 AM PDT
 * */

module algo_1r4w_a216_top_wrap 
#(
  parameter IP_WIDTH = 4, parameter IP_BITWIDTH = 2, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, parameter IP_ADDDELAY = 0,
  parameter IP_NUMVBNK = 4, parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
  parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 3, parameter IP_SECCDWIDTH = 4, parameter IP_DECCBITS = 4, 

  parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPMEM = 0, parameter FLOPCMD = 0, 

  parameter T1_WIDTH = 4, parameter T1_NUMVBNK = 8, parameter T1_BITVBNK = 3, parameter T1_DELAY = 1, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11, 
  parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 0, parameter T1_NUMSROW = 2048, parameter T1_BITSROW = 11, parameter T1_PHYWDTH = 4, 

  parameter T2_WIDTH = 4, parameter T2_NUMVBNK = 4, parameter T2_BITVBNK = 2, parameter T2_DELAY = 1, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11,
  parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 2048, parameter T2_BITSROW = 11, parameter T2_PHYWDTH = 4,

  parameter T3_WIDTH = 10, parameter T3_NUMVBNK = 6, parameter T3_BITVBNK = 3, parameter T3_DELAY = 1, parameter T3_NUMVROW = 2048, parameter T3_BITVROW = 11,
  parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 0, parameter T3_NUMSROW = 2048, parameter T3_BITSROW = 11, parameter T3_PHYWDTH = 10, 

  parameter T4_WIDTH = 2, parameter T4_NUMVBNK = 6, parameter T4_BITVBNK = 3, parameter T4_DELAY = 1, parameter T4_NUMVROW = 8192, parameter T4_BITVROW = 13, 
  parameter T4_BITWSPF = 0, parameter T4_NUMWRDS = 1, parameter T4_BITWRDS = 0, parameter T4_NUMSROW = 8192, parameter T4_BITSROW = 13, parameter T4_PHYWDTH = 2)
  (
    clk,         rst,        ready,
    write,       wr_adr,     din,
    read,        rd_clr_0,     rd_adr,     rd_dout,     rd_vld,     rd_serr,   rd_derr,   rd_padr,
    t1_readB,    t1_addrB,   t1_doutB,   t1_writeA,   t1_addrA,   t1_dinA,   t1_bwA,
    t2_readB,    t2_addrB,   t2_doutB,   t2_writeA,   t2_addrA,   t2_dinA,   t2_bwA,
    t3_readB,    t3_addrB,   t3_doutB,   t3_writeA,   t3_addrA,   t3_dinA,   t3_bwA,
    t4_readB,    t4_addrB,   t4_doutB,   t4_writeA,   t4_addrA,   t4_dinA,   t4_bwA
  );
               
  
  parameter WIDTH   = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR  = IP_ENAPAR;
  parameter ENAECC  = IP_ENAECC;
  parameter ECCBITS = IP_SECCBITS;
  parameter ECCWDTH = IP_DECCBITS;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter BITPBNK = BITVBNK+1;
  parameter NUMVROW = T1_NUMVROW;
  parameter BITVROW = T1_BITVROW;
  parameter NUMWRDS = T1_NUMWRDS;
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter PHYWDTH = T1_PHYWDTH;
  parameter SRAM_DELAY = T2_DELAY;
  parameter DRAM_DELAY = T1_DELAY;
  parameter ADD_DELAY  = IP_ADDDELAY;
  parameter NUMRDPT = 1;
  parameter NUMWRPT = 4;
  
  parameter NUMCWDS = T4_NUMWRDS;      // C35 ALIGN Parameters
  parameter BITCWDS = T4_BITWRDS;
  parameter NUMCSRW = T4_NUMSROW;
  parameter BITCSRW = T4_BITSROW;
  parameter PHCWDTH = NUMCWDS*2;

  parameter BITPADR = 1+BITPBNK+BITSROW+BITWRDS+1;

  input  [NUMWRPT-1:0]                 write;
  input  [NUMWRPT*BITADDR-1:0]         wr_adr;
  input  [NUMWRPT*WIDTH-1:0]           din;
         
  input  [NUMRDPT-1:0]                 read;
  input  [NUMRDPT-1:0]                 rd_clr_0;
  input  [NUMRDPT*BITADDR-1:0]         rd_adr;
  output [NUMRDPT-1:0]                 rd_vld;
  output [NUMRDPT*WIDTH-1:0]           rd_dout;
  output [NUMRDPT-1:0]                 rd_serr;
  output [NUMRDPT-1:0]                 rd_derr;
  output [NUMRDPT*BITPADR:0]           rd_padr;

  output                               ready;
  input                                clk, rst;

  output [T1_NUMVBNK-1:0]              t1_readB;
  output [T1_NUMVBNK*BITSROW-1:0]      t1_addrB;
  input  [T1_NUMVBNK*PHYWDTH-1:0]      t1_doutB;
  output [T1_NUMVBNK-1:0]              t1_writeA;
  output [T1_NUMVBNK*BITSROW-1:0]      t1_addrA;
  output [T1_NUMVBNK*PHYWDTH-1:0]      t1_dinA;
  output [T1_NUMVBNK*PHYWDTH-1:0]      t1_bwA;

  output [T2_NUMVBNK-1:0]              t2_readB;
  output [T2_NUMVBNK*BITSROW-1:0]      t2_addrB;
  input  [T2_NUMVBNK*PHYWDTH-1:0]      t2_doutB;
  output [T2_NUMVBNK-1:0]              t2_writeA;
  output [T2_NUMVBNK*BITSROW-1:0]      t2_addrA;
  output [T2_NUMVBNK*PHYWDTH-1:0]      t2_dinA;
  output [T2_NUMVBNK*PHYWDTH-1:0]      t2_bwA;

  output [T3_NUMVBNK-1:0]              t3_readB;
  output [T3_NUMVBNK*BITSROW-1:0]      t3_addrB;
  input  [T3_NUMVBNK*T3_PHYWDTH-1:0]   t3_doutB;
  output [T3_NUMVBNK-1:0]              t3_writeA;
  output [T3_NUMVBNK*BITSROW-1:0]      t3_addrA;
  output [T3_NUMVBNK*T3_PHYWDTH-1:0]   t3_dinA;
  output [T3_NUMVBNK*T3_PHYWDTH-1:0]   t3_bwA;


  output [T4_NUMVBNK-1:0]              t4_readB;
  output [T4_NUMVBNK*BITCSRW-1:0]      t4_addrB;
  input  [T4_NUMVBNK*T4_PHYWDTH-1:0]   t4_doutB;
  output [T4_NUMVBNK-1:0]              t4_writeA;
  output [T4_NUMVBNK*BITCSRW-1:0]      t4_addrA;
  output [T4_NUMVBNK*T4_PHYWDTH-1:0]   t4_dinA;
  output [T4_NUMVBNK*T4_PHYWDTH-1:0]   t4_bwA;

  algo_mrcnw_1r2w_rl_top
  #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCBITS(ECCBITS), .ECCWDTH (ECCWDTH),
    .NUMRDPT(NUMRDPT), .NUMWRPT(NUMWRPT), .NUMADDR(NUMADDR), .BITADDR(BITADDR),
    .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .NUMVROW(NUMVROW), .BITVROW(BITVROW),
    .BITPBNK(BITPBNK), .BITPADR(BITPADR),
    .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS), .NUMSROW(NUMSROW), .BITSROW(BITSROW),
    .NUMCWDS(NUMCWDS), .BITCWDS(BITCWDS), .NUMCSRW(NUMCSRW), .BITCSRW(BITCSRW),
    .PHYWDTH(PHYWDTH), .SRAM_DELAY(SRAM_DELAY), .DRAM_DELAY(DRAM_DELAY), .FLOPIN(FLOPIN), .FLOPMEM(FLOPMEM), .FLOPOUT(FLOPOUT))
    algo_top (
      .clk(clk), .rst(rst), .ready(ready),
      .write(write), .wr_adr(wr_adr), .din(din),
      .read(read), .rd_clr(rd_clr_0), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
      .t1_readB(t1_readB),   .t1_addrB(t1_addrB),  .t1_doutB(t1_doutB),  .t1_writeA(t1_writeA),  .t1_addrA(t1_addrA),  .t1_dinA(t1_dinA),  .t1_bwA(t1_bwA),
      .t2_readB(t2_readB),   .t2_addrB(t2_addrB),  .t2_doutB(t2_doutB),  .t2_writeA(t2_writeA),  .t2_addrA(t2_addrA),  .t2_dinA(t2_dinA),  .t2_bwA(t2_bwA),
      .t3_readB(t3_readB),   .t3_addrB(t3_addrB),  .t3_doutB(t3_doutB),  .t3_writeA(t3_writeA),  .t3_addrA(t3_addrA),  .t3_dinA(t3_dinA),  .t3_bwA(t3_bwA),
      .t4_readB(t4_readB),   .t4_addrB(t4_addrB),  .t4_doutB(t4_doutB),  .t4_writeA(t4_writeA),  .t4_addrA(t4_addrA),  .t4_dinA(t4_dinA),  .t4_bwA(t4_bwA)
    );


endmodule    // algo_1r4w_a216_top_wrap

