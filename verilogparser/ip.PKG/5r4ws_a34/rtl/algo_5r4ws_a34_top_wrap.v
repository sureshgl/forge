/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.UNKNOWN Date: Wed 2012.11.21 at 01:59:18 PM IST
 * */

module algo_5r4ws_a34_top_wrap #(
parameter IP_WIDTH = 256, parameter IP_BITWIDTH = 8, parameter IP_NUMADDR = 126720, parameter IP_BITADDR = 18, parameter IP_NUMVBNK = 4,
parameter IP_BITVBNK = 2, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, parameter IP_BITPBNK = 5,
parameter IP_ENAECC = 1, parameter IP_ENAHEC = 0, parameter IP_ENAQEC = 0, parameter IP_DECCBITS = 10, parameter IP_ENAPAR = 0,
parameter FLOPIN = 1, parameter FLOPOUT = 1, parameter FLOPECC = 0, parameter FLOPMEM = 1, parameter FLOPCMD = 1,
parameter T1_WIDTH = 144, parameter T1_NUMVBNK = 16, parameter T1_BITVBNK = 4, parameter T1_DELAY = 2, parameter T1_NUMVROW = 7920,
parameter T1_BITVROW = 13, parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 0, parameter T1_NUMSROW = 7920,
parameter T1_BITSROW = 13, parameter T1_PHYWDTH = 144, parameter T2_WIDTH = 122,
parameter T2_NUMVBNK = 16, parameter T2_BITVBNK = 4, parameter T2_DELAY = 2, parameter T2_NUMVROW = 7920, parameter T2_BITVROW = 13,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 7920, parameter T2_BITSROW = 13,
parameter T2_PHYWDTH = 122
)
( 
  lclk, clk,  rst,  rst_l, ready,
  write,   wr_adr,   din,
  read,   rd_adr,   rd_dout,   rd_vld,   rd_serr,   rd_derr,   rd_padr,
  wfifo_oflw, rfifo_oflw, rdrob_uflw, faf_full, raf_full,
  t1_writeA,   t1_addrA,   t1_dinA,    t1_bwA,     t1_readB,    t1_addrB,   t1_doutB,
  t2_writeA,   t2_addrA,   t2_dinA,    t2_bwA,     t2_readB,    t2_addrB,   t2_doutB);
  
  parameter WIDTH   = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR  = IP_ENAPAR;
  parameter ENAECC  = IP_ENAECC;
  parameter ENAHEC  = IP_ENAHEC;
  parameter ENAQEC  = IP_ENAQEC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENAHEC ? WIDTH+2*ECCWDTH : ENAQEC ? WIDTH+4*ECCWDTH : WIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMCELL = 36;
  parameter BITCELL = 6;
  parameter NUMVROW = IP_NUMADDR/IP_NUMVBNK;
  parameter BITVROW = IP_BITADDR-IP_BITVBNK;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter PHYWDTH = MEMWDTH;
  
  parameter NUMLROW = IP_NUMADDR/IP_NUMVBNK;
  parameter BITLROW = IP_BITADDR-IP_BITVBNK-1;
  parameter NUMLVRW = T1_NUMVROW;
  parameter BITLVRW = T1_BITVROW;
  parameter NUMLVBK = T1_NUMVBNK/IP_NUMVBNK;
  parameter BITLVBK = T1_BITVBNK-IP_BITVBNK;

  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T1_DELAY;
  parameter READ_DELAY = 32;
  parameter BITRDLY = 5;
  
  parameter BITPADR = BITADDR;

  parameter NUMRDPT = 5;
  parameter NUMWRPT = 4;
  parameter BITRDPT = 3;
  parameter BITWRPT = 2;
  
  input [NUMWRPT-1:0]                        write;
  input [NUMWRPT*BITADDR-1:0]                wr_adr;
  input [NUMWRPT*WIDTH-1:0]                  din;

  input  [NUMRDPT-1:0]                       read;
  input  [NUMRDPT*BITADDR-1:0]               rd_adr;
  output [NUMRDPT-1:0]                       rd_vld;
  output [NUMRDPT*WIDTH-1:0]                 rd_dout;
  output [NUMRDPT-1:0]                       rd_serr;
  output [NUMRDPT-1:0]                       rd_derr;
  output [NUMRDPT*BITPADR-1:0]               rd_padr;

  output [NUMVBNK-1:0]                       wfifo_oflw;
  output [NUMVBNK-1:0]                       rfifo_oflw;
  output [NUMRDPT-1:0]                       rdrob_uflw;
  output [NUMVBNK-1:0]                       faf_full;
  output [NUMVBNK-1:0]                       raf_full;

  output                                  ready;
  input                                   lclk, clk, rst, rst_l;

  output [T1_NUMVBNK-1:0]                 t1_writeA;
  output [T1_NUMVBNK*T1_BITVROW-1:0]      t1_addrA;
  output [T1_NUMVBNK*T1_PHYWDTH-1:0]      t1_bwA;
  output [T1_NUMVBNK*T1_PHYWDTH-1:0]      t1_dinA;
  output [T1_NUMVBNK-1:0]                 t1_readB;
  output [T1_NUMVBNK*T1_BITVROW-1:0]      t1_addrB;
  input  [T1_NUMVBNK*T1_PHYWDTH-1:0]      t1_doutB;

  output [T2_NUMVBNK-1:0]                 t2_writeA;
  output [T2_NUMVBNK*T2_BITVROW-1:0]      t2_addrA;
  output [T2_NUMVBNK*T2_PHYWDTH-1:0]      t2_bwA;
  output [T2_NUMVBNK*T2_PHYWDTH-1:0]      t2_dinA;
  output [T2_NUMVBNK-1:0]                 t2_readB;
  output [T2_NUMVBNK*T2_BITVROW-1:0]      t2_addrB;
  input  [T2_NUMVBNK*T2_PHYWDTH-1:0]      t2_doutB;

  wire [T1_NUMVBNK-1:0] t1_writeA_a1;
  wire [T1_NUMVBNK*T1_BITVROW-1:0] t1_addrA_a1;
  wire [T1_NUMVBNK*T1_PHYWDTH+T2_NUMVBNK*T2_PHYWDTH-1:0] t1_bwA_a1;
  wire [T1_NUMVBNK*T1_PHYWDTH+T2_NUMVBNK*T2_PHYWDTH-1:0] t1_dinA_a1;
  wire [T1_NUMVBNK-1:0] t1_readB_a1;
  wire [T1_NUMVBNK*T1_BITVROW-1:0] t1_addrB_a1;
  reg  [T1_NUMVBNK*T1_PHYWDTH+T2_NUMVBNK*T2_PHYWDTH-1:0] t1_doutB_a1;
  
  assign t1_writeA = t1_writeA_a1;
  assign t1_addrA  = t1_addrA_a1;
  assign t1_readB  = t1_readB_a1;
  assign t1_addrB  = t1_addrB_a1;
  assign t2_writeA = t1_writeA_a1;
  assign t2_addrA  = t1_addrA_a1;
  assign t2_readB  = t1_readB_a1;
  assign t2_addrB  = t1_addrB_a1;
  
  reg [T1_NUMVBNK*T1_PHYWDTH-1:0] t1_bwA;
  reg [T1_NUMVBNK*T1_PHYWDTH-1:0] t1_dinA;
  reg [T2_NUMVBNK*T2_PHYWDTH-1:0] t2_bwA;
  reg [T2_NUMVBNK*T2_PHYWDTH-1:0] t2_dinA;
  reg [T1_PHYWDTH-1:0] t1_bwA_tmp;
  reg [T1_PHYWDTH-1:0] t1_dinA_tmp;
  reg [T2_PHYWDTH-1:0] t2_bwA_tmp;
  reg [T2_PHYWDTH-1:0] t2_dinA_tmp;
  reg [T1_PHYWDTH-1:0] t1_doutB_tmp;
  reg [T2_PHYWDTH-1:0] t2_doutB_tmp;
  reg [T1_PHYWDTH+T2_PHYWDTH-1:0] t1_doutB_a1_tmp;
  always_comb begin
    t1_bwA = 0;
    t1_dinA = 0;
    t2_bwA = 0;
    t2_dinA = 0;
    t1_doutB_a1 = 0;
    for (integer i=0; i<T1_NUMVBNK;i++) begin
      t1_bwA_tmp = t1_bwA_a1>>(i*(T1_PHYWDTH+T2_PHYWDTH));
      t1_bwA = t1_bwA | (t1_bwA_tmp<<(i*T1_PHYWDTH));
      t1_dinA_tmp = t1_dinA_a1>>(i*(T1_PHYWDTH+T2_PHYWDTH));
      t1_dinA = t1_dinA | (t1_dinA_tmp<<(i*T1_PHYWDTH));
    end
    for (integer i=0; i<T2_NUMVBNK;i++) begin
      t2_bwA_tmp = (t1_bwA_a1>>(i*(T1_PHYWDTH+T2_PHYWDTH)))>>T1_PHYWDTH;
      t2_bwA = t2_bwA | (t2_bwA_tmp<<(i*T2_PHYWDTH));
      t2_dinA_tmp = (t1_dinA_a1>>(i*(T1_PHYWDTH+T2_PHYWDTH)))>>T1_PHYWDTH;
      t2_dinA = t2_dinA | (t2_dinA_tmp<<(i*T2_PHYWDTH));
    end
    for (integer i=0; i<T2_NUMVBNK;i++) begin
      t1_doutB_tmp = t1_doutB>>(i*T1_PHYWDTH);
      t2_doutB_tmp = t2_doutB>>(i*T2_PHYWDTH);
      t1_doutB_a1_tmp = {t2_doutB_tmp,t1_doutB_tmp};
      t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_tmp<<(i*(T1_PHYWDTH+T2_PHYWDTH)));
    end
  end

  algo_mrnws_a34_top #(
    .BITWDTH(BITWDTH), .WIDTH(WIDTH), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ENAHEC(ENAHEC), .ENAQEC(ENAQEC), .ECCWDTH(ECCWDTH),
    .NUMRDPT(NUMRDPT), .BITRDPT(BITRDPT), .NUMWRPT(NUMWRPT), .BITWRPT(BITWRPT),
    .NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMCELL(NUMCELL), .BITCELL(BITCELL),
    .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK),
    .NUMLROW(NUMLROW), .BITLROW(BITLROW), .NUMLVBK(NUMLVBK), .BITLVBK(BITLVBK), .NUMLVRW(NUMLVRW), .BITLVRW(BITLVRW),
    .PHYWDTH(PHYWDTH), .SRAM_DELAY(SRAM_DELAY), .READ_DELAY(READ_DELAY), .BITRDLY(BITRDLY), .ECCBITS(ECCBITS),
    .BITPADR(BITPADR),
    .FLOPIN(FLOPIN), .FLOPCMD (FLOPCMD), .FLOPOUT(FLOPOUT), .FLOPMEM(FLOPMEM), .FLOPECC(FLOPECC))
   algo_top (
    .clk(clk), .rst(rst), .rst_l(rst_l), .ready(ready), .lclk(lclk), 
	.write(write), .wr_adr(wr_adr), .din(din),
    .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
    .wrfifo_oflw(wfifo_oflw), .rdfifo_oflw(rfifo_oflw), .rdrob_uflw(rdrob_uflw), .faf_full(faf_full), .raf_full(raf_full),
	.t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_bwA(t1_bwA_a1), .t1_dinA(t1_dinA_a1), .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1));
  
endmodule // algo_5r4ws_a34_top_wrap

