/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_5r4ws_a34_sva_wrap
#(
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
( lclk, clk,  rst,  rst_l, ready,
  write,   wr_adr,   din,
  read,   rd_adr,   rd_dout,   rd_vld,   rd_serr,   rd_derr,   rd_padr,
  wfifo_oflw, rfifo_oflw, 
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
  input  [NUMRDPT-1:0]                       rd_vld;
  input  [NUMRDPT*WIDTH-1:0]                 rd_dout;
  input  [NUMRDPT-1:0]                       rd_serr;
  input  [NUMRDPT-1:0]                       rd_derr;
  input  [NUMRDPT*BITPADR-1:0]               rd_padr;

  input  [NUMVBNK-1:0]                       wfifo_oflw;
  input  [NUMVBNK-1:0]                       rfifo_oflw;

  input                                ready;
  input                                lclk, clk, rst, rst_l;

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

wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITCELL-1:0] select_vwrd = 0;
wire [BITADDR-BITCELL-BITVBNK-1:0] select_vrow = 0;
wire [BITLROW-1:0] select_lrow = 0;
wire [BITVBNK-1:0] select_bnk = 0;
wire [BITLVRW-1:0] select_lvrw = 0;

  parameter NUMQUEU = 880;
  parameter BITQUEU = 10;

 ip_top_sva_2_mrnws_a34 #(
     .WIDTH       (WIDTH), .NUMRDPT     (NUMRDPT), .BITRDPT     (BITRDPT), .NUMWRPT     (NUMWRPT), .BITWRPT     (BITWRPT),
     .NUMADDR     (NUMADDR), .BITADDR     (BITADDR), .NUMVBNK     (NUMVBNK), .BITVBNK     (BITVBNK), .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW), .NUMCELL     (NUMCELL),     .BITCELL     (BITCELL), .NUMQUEU     (NUMQUEU), .BITQUEU     (BITQUEU),
     .BITLROW     (BITLROW), .BITWDTH (BITWDTH))
ip_top_sva_2 (
.clk         (clk), .rst         (rst), .ready       (ready),
.write       (write), .wr_adr      (wr_adr), .din         (din), .read        (read), .rd_adr      (rd_adr),
.wrfifo_oflw (wfifo_oflw), .rdfifo_oflw (rfifo_oflw),
.select_addr (select_addr), .select_bit  (select_bit),  .select_bnk  (select_bnk),
.select_vwrd (select_vwrd), .select_vrow (select_vrow), .select_lrow (select_lrow))
 ;


endmodule // algo_5r4ws_a34_sva_wrap

