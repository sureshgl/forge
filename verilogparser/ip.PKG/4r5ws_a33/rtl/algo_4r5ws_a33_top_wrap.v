/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.UNKNOWN Date: Wed 2012.11.21 at 01:59:18 PM IST
 * */

module algo_4r5ws_a33_top_wrap
#(
parameter IP_WIDTH = 256, parameter IP_BITWIDTH = 8, parameter IP_NUMADDR = 663552, parameter IP_BITADDR = 20,
parameter IP_NUMVBNK = 4, parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 5, 
parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, parameter IP_DECCBITS = 10,
parameter IP_ENAECC = 1, parameter IP_ENAHEC = 0, parameter IP_ENAQEC = 0, parameter IP_ENAPAR = 0,

parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 274, parameter T1_NUMVBNK = 16, parameter T1_BITVBNK = 4, parameter T1_DELAY = 2, parameter T1_NUMVROW = 2304, parameter T1_BITVROW = 12,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 0, parameter T1_NUMSROW = 2304, parameter T1_BITSROW = 12, parameter T1_PHYWDTH = 274,
parameter T2_WIDTH = 274, parameter T2_NUMVBNK = 8, parameter T2_BITVBNK = 3, parameter T2_DELAY = 2, parameter T2_NUMVROW = 2304, parameter T2_BITVROW = 12,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 2304, parameter T2_BITSROW = 12, parameter T2_PHYWDTH = 274,
parameter T3_WIDTH = 10, parameter T3_NUMVBNK = 12, parameter T3_BITVBNK = 4, parameter T3_DELAY = 2, parameter T3_NUMVROW = 2304, parameter T3_BITVROW = 12,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 0, parameter T3_NUMSROW = 2304, parameter T3_BITSROW = 12, parameter T3_PHYWDTH = 10,
parameter T4_WIDTH = 144, parameter T4_NUMVBNK = 80, parameter T4_BITVBNK = 7, parameter T4_DELAY = 2, parameter T4_NUMVROW = 7836, parameter T4_BITVROW = 13,
parameter T4_BITWSPF = 0, parameter T4_NUMWRDS = 1, parameter T4_BITWRDS = 0, parameter T4_NUMSROW = 7836, parameter T4_BITSROW = 13, parameter T4_PHYWDTH = 144,
parameter T5_WIDTH = 122, parameter T5_NUMVBNK = 80, parameter T5_BITVBNK = 7, parameter T5_DELAY = 2, parameter T5_NUMVROW = 7836, parameter T5_BITVROW = 13,
parameter T5_BITWSPF = 0, parameter T5_NUMWRDS = 1, parameter T5_BITWRDS = 0, parameter T5_NUMSROW = 7836, parameter T5_BITSROW = 13, parameter T5_PHYWDTH = 122,
parameter READ_DELAY=32)
( lclk, clk,  rst,  rst_l, ready,
  write,   wr_adr,   din,
  read,   rd_adr,   rd_dout,   rd_vld,   rd_serr,   rd_derr,   rd_padr,
  whfifo_oflw, wlfifo_oflw, rhfifo_oflw, rlfifo_oflw, 
  rdrob_uflw, faf_full, raf_full,
  t1_writeA,   t1_addrA,   t1_dinA,    t1_bwA,     t1_readB,    t1_addrB,   t1_doutB,
  t2_writeA,   t2_addrA,   t2_dinA,    t2_bwA,     t2_readB,    t2_addrB,   t2_doutB,
  t3_writeA,   t3_addrA,   t3_dinA,    t3_bwA,     t3_readB,    t3_addrB,   t3_doutB,
  t4_writeA,   t4_addrA,   t4_dinA,    t4_bwA,     t4_readB,    t4_addrB,   t4_doutB,
  t5_writeA,   t5_addrA,   t5_dinA,    t5_bwA,     t5_readB,    t5_addrB,   t5_doutB);
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ENAHEC = IP_ENAHEC;
  parameter ENAQEC = IP_ENAQEC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENAHEC ? WIDTH+2*ECCWDTH : ENAQEC ? WIDTH+4*ECCWDTH : WIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMCELL = 72;
  parameter BITCELL = 7;
  parameter NUMVROW = IP_NUMADDR/IP_NUMVBNK;
  parameter BITVROW = IP_BITADDR-IP_BITVBNK;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter PHYWDTH = MEMWDTH;
  parameter NUMHROW = T1_NUMVROW*T1_NUMVBNK/IP_NUMVBNK;
  parameter BITHROW = T1_BITVROW+T1_BITVBNK-IP_BITVBNK;
  parameter NUMHVBK = T1_NUMVBNK/IP_NUMVBNK;
  parameter BITHVBK = T1_BITVBNK-IP_BITVBNK;
  parameter BITHPBK = T1_BITVBNK-IP_BITVBNK+1;
  parameter NUMHVRW = T1_NUMVROW;
  parameter BITHVRW = T1_BITVROW;
  parameter NUMLROW = T4_NUMVROW*T4_NUMVBNK/IP_NUMVBNK; 
  parameter BITLROW = T4_BITVROW+T4_BITVBNK-IP_BITVBNK; 
  parameter NUMLVRW = T4_NUMVROW;
  parameter BITLVRW = T4_BITVROW;
  parameter NUMLVBK = T4_NUMVBNK/IP_NUMVBNK;
  parameter BITLVBK = T4_BITVBNK-IP_BITVBNK;
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T1_DELAY;
  parameter BITRDLY = 5;
  
  parameter BITPADR = BITLROW+4;
  parameter SDOUT_WIDTH = 2*(BITHPBK+1)+ECCBITS;
  parameter NUMRDPT = 4;
  parameter BITRDPT = 2;
  parameter NUMWRPT = 5;
  parameter BITWRPT = 3;
  
  input [5-1:0]                        write;
  input [5*BITADDR-1:0]                wr_adr;
  input [5*WIDTH-1:0]                  din;

  input [4-1:0]                        read;
  input [4*BITADDR-1:0]                rd_adr;
  output [4-1:0]                       rd_vld;
  output [4*WIDTH-1:0]                 rd_dout;
  output [4-1:0]                       rd_serr;
  output [4-1:0]                       rd_derr;
  output [4*BITPADR-1:0]               rd_padr;

  output [NUMVBNK-1:0]                 whfifo_oflw;
  output [NUMVBNK-1:0]                 wlfifo_oflw;
  output [NUMVBNK-1:0]                 rhfifo_oflw;
  output [NUMVBNK-1:0]                 rlfifo_oflw;
  output [NUMRDPT-1:0]                 rdrob_uflw;
  output [NUMVBNK-1:0]                 faf_full;
  output [NUMVBNK-1:0]                 raf_full;

  output                               ready;
  input                                lclk, clk, rst, rst_l;

  output [T1_NUMVBNK-1:0] t1_writeA;
  output [T1_NUMVBNK*T1_BITVROW-1:0] t1_addrA;
  output [T1_NUMVBNK*T1_PHYWDTH-1:0] t1_bwA;
  output [T1_NUMVBNK*T1_PHYWDTH-1:0] t1_dinA;
  output [T1_NUMVBNK-1:0] t1_readB;
  output [T1_NUMVBNK*T1_BITVROW-1:0] t1_addrB;
  input  [T1_NUMVBNK*T1_PHYWDTH-1:0] t1_doutB;

  output [T2_NUMVBNK-1:0] t2_writeA;
  output [T2_NUMVBNK*T2_BITVROW-1:0] t2_addrA;
  output [T2_NUMVBNK*T2_PHYWDTH-1:0] t2_bwA;
  output [T2_NUMVBNK*T2_PHYWDTH-1:0] t2_dinA;
  output [T2_NUMVBNK-1:0] t2_readB;
  output [T2_NUMVBNK*T2_BITVROW-1:0] t2_addrB;
  input  [T2_NUMVBNK*T2_PHYWDTH-1:0] t2_doutB;

  output [T3_NUMVBNK-1:0] t3_writeA;
  output [T3_NUMVBNK*T3_BITVROW-1:0] t3_addrA;
  output [T3_NUMVBNK*T3_PHYWDTH-1:0] t3_bwA;
  output [T3_NUMVBNK*T3_PHYWDTH-1:0] t3_dinA;
  output [T3_NUMVBNK-1:0] t3_readB;
  output [T3_NUMVBNK*T3_BITVROW-1:0] t3_addrB;
  input  [T3_NUMVBNK*T3_PHYWDTH-1:0] t3_doutB;

  output [T4_NUMVBNK-1:0] t4_writeA;
  output [T4_NUMVBNK*T4_BITVROW-1:0] t4_addrA;
  output [T4_NUMVBNK*T4_PHYWDTH-1:0] t4_bwA;
  output [T4_NUMVBNK*T4_PHYWDTH-1:0] t4_dinA;
  output [T4_NUMVBNK-1:0] t4_readB;
  output [T4_NUMVBNK*T4_BITVROW-1:0] t4_addrB;
  input  [T4_NUMVBNK*T4_PHYWDTH-1:0] t4_doutB;

  output [T5_NUMVBNK-1:0] t5_writeA;
  output [T5_NUMVBNK*T5_BITVROW-1:0] t5_addrA;
  output [T5_NUMVBNK*T5_PHYWDTH-1:0] t5_bwA;
  output [T5_NUMVBNK*T5_PHYWDTH-1:0] t5_dinA;
  output [T5_NUMVBNK-1:0] t5_readB;
  output [T5_NUMVBNK*T5_BITVROW-1:0] t5_addrB;
  input  [T5_NUMVBNK*T5_PHYWDTH-1:0] t5_doutB;

  wire [T4_NUMVBNK-1:0] t4_writeA_a1;
  wire [T4_NUMVBNK*T4_BITVROW-1:0] t4_addrA_a1;
  wire [T4_NUMVBNK*T4_PHYWDTH+T5_NUMVBNK*T5_PHYWDTH-1:0] t4_bwA_a1;
  wire [T4_NUMVBNK*T4_PHYWDTH+T5_NUMVBNK*T5_PHYWDTH-1:0] t4_dinA_a1;
  wire [T4_NUMVBNK-1:0] t4_readB_a1;
  wire [T4_NUMVBNK*T4_BITVROW-1:0] t4_addrB_a1;
  reg  [T4_NUMVBNK*T4_PHYWDTH+T5_NUMVBNK*T5_PHYWDTH-1:0] t4_doutB_a1;

  assign t4_writeA = t4_writeA_a1;
  assign t4_addrA  = t4_addrA_a1;
  assign t4_readB  = t4_readB_a1;
  assign t4_addrB  = t4_addrB_a1;
  assign t5_writeA = t4_writeA_a1;
  assign t5_addrA  = t4_addrA_a1;
  assign t5_readB  = t4_readB_a1;
  assign t5_addrB  = t4_addrB_a1;

  reg [T4_NUMVBNK*T4_PHYWDTH-1:0] t4_bwA;
  reg [T4_NUMVBNK*T4_PHYWDTH-1:0] t4_dinA;
  reg [T5_NUMVBNK*T5_PHYWDTH-1:0] t5_bwA;
  reg [T5_NUMVBNK*T5_PHYWDTH-1:0] t5_dinA;
  reg [T4_PHYWDTH-1:0] t4_bwA_tmp;
  reg [T4_PHYWDTH-1:0] t4_dinA_tmp;
  reg [T5_PHYWDTH-1:0] t5_bwA_tmp;
  reg [T5_PHYWDTH-1:0] t5_dinA_tmp;
  reg [T4_PHYWDTH-1:0] t4_doutB_tmp;
  reg [T5_PHYWDTH-1:0] t5_doutB_tmp;
  reg [T4_PHYWDTH+T5_PHYWDTH-1:0] t4_doutB_a1_tmp;
  always_comb begin
    t4_bwA = 0;
    t4_dinA = 0;
    t5_bwA = 0;
    t5_dinA = 0;
    t4_doutB_a1 = 0;
    for (integer i=0; i<T4_NUMVBNK;i++) begin
      t4_bwA_tmp = t4_bwA_a1>>(i*(T4_PHYWDTH+T5_PHYWDTH));
      t4_bwA = t4_bwA | (t4_bwA_tmp<<(i*T4_PHYWDTH));
      t4_dinA_tmp = t4_dinA_a1>>(i*(T4_PHYWDTH+T5_PHYWDTH));
      t4_dinA = t4_dinA | (t4_dinA_tmp<<(i*T4_PHYWDTH));
    end
    for (integer i=0; i<T5_NUMVBNK;i++) begin
      t5_bwA_tmp = (t4_bwA_a1>>(i*(T4_PHYWDTH+T5_PHYWDTH)))>>T4_PHYWDTH;
      t5_bwA = t5_bwA | (t5_bwA_tmp<<(i*T5_PHYWDTH));
      t5_dinA_tmp = (t4_dinA_a1>>(i*(T4_PHYWDTH+T5_PHYWDTH)))>>T4_PHYWDTH;
      t5_dinA = t5_dinA | (t5_dinA_tmp<<(i*T5_PHYWDTH));
    end
    for (integer i=0; i<T5_NUMVBNK;i++) begin
      t4_doutB_tmp = t4_doutB>>(i*T4_PHYWDTH);
      t5_doutB_tmp = t5_doutB>>(i*T5_PHYWDTH);
      t4_doutB_a1_tmp = {t5_doutB_tmp,t4_doutB_tmp};
      t4_doutB_a1 = t4_doutB_a1 | (t4_doutB_a1_tmp<<(i*(T4_PHYWDTH+T5_PHYWDTH)));
    end
  end

  algo_mrnws_a33_top #(.BITWDTH(BITWDTH), .WIDTH(WIDTH), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ENAHEC(ENAHEC), .ENAQEC(ENAQEC), .ECCWDTH(ECCWDTH),
                       .NUMRDPT(NUMRDPT), .BITRDPT(BITRDPT), .NUMWRPT(NUMWRPT), .BITWRPT(BITWRPT),
                       .NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMCELL(NUMCELL), .BITCELL(BITCELL),
                       .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK),
                       .NUMHROW(NUMHROW), .BITHROW(BITHROW), .NUMHVBK(NUMHVBK), .BITHVBK(BITHVBK), .NUMHVRW(NUMHVRW), .BITHVRW(BITHVRW),
                       .NUMLROW(NUMLROW), .BITLROW(BITLROW), .NUMLVBK(NUMLVBK), .BITLVBK(BITLVBK), .NUMLVRW(NUMLVRW), .BITLVRW(BITLVRW),
                       .PHYWDTH(PHYWDTH), .SRAM_DELAY(SRAM_DELAY), .READ_DELAY(READ_DELAY), .BITRDLY(BITRDLY), .ECCBITS(ECCBITS),
                       .FLOPIN(FLOPIN), .FLOPCMD (FLOPCMD), .FLOPOUT(FLOPOUT), .FLOPMEM(FLOPMEM), .FLOPECC(FLOPECC))
    algo_top
	(
     .clk(clk), .rst(rst), .rst_l(rst_l), .ready(ready), .lclk(lclk), 
	 .write(write), .wr_adr(wr_adr), .din(din),
	 .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
     .whfifo_oflw(whfifo_oflw), .wlfifo_oflw(wlfifo_oflw), .rhfifo_oflw(rhfifo_oflw), .rlfifo_oflw(rlfifo_oflw), .rdrob_uflw(rdrob_uflw), .faf_full(faf_full), .raf_full(raf_full),
	 .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_bwA(t1_bwA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
	 .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_bwA(t2_bwA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
	 .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_bwA(t3_bwA), .t3_dinA(t3_dinA), .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB),
	 .t4_writeA(t4_writeA_a1), .t4_addrA(t4_addrA_a1), .t4_bwA(t4_bwA_a1), .t4_dinA(t4_dinA_a1), .t4_readB(t4_readB_a1), .t4_addrB(t4_addrB_a1), .t4_doutB(t4_doutB_a1)
    );
  
endmodule // algo_4r5ws_a33_top_wrap

