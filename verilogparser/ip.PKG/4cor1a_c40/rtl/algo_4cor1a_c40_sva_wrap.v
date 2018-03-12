/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.4981M Date: Wed 2012.11.21 at 03:05:28 PM IST
 * */

module algo_4cor1a_c40_sva_wrap
#(parameter IP_WIDTH = 64,
parameter   IP_BITWIDTH = 6,
parameter   IP_DECCBITS = 8,
parameter   IP_NUMADDR = 2048,
parameter   IP_BITADDR = 11,
parameter   IP_NUMVBNK = 1,
parameter   IP_BITVBNK = 1,
parameter   IP_BITPBNK = 2, 
parameter   IP_SECCBITS = 8,
parameter   IP_SECCDWIDTH = 2,
parameter   IP_ENAECC = 1,
parameter   IP_ENAPAR = 0,
parameter   FLOPADD = 0,
parameter   FLOPIN = 0,
parameter   FLOPOUT = 0,
parameter   FLOPMEM = 0,
parameter   FLOPECC = 0,
parameter   FLOPCMD = 0,
parameter   T1_WIDTH = 73,
parameter   T1_NUMVBNK = 4,
parameter   T1_BITVBNK = 2,
parameter   T1_DELAY = 1,
parameter   T1_NUMVROW = 2048,
parameter   T1_BITVROW = 11,
parameter   T1_BITWSPF = 0,
parameter   T1_NUMWRDS = 1,
parameter   T1_BITWRDS = 1,
parameter   T1_NUMSROW = 2048,
parameter   T1_BITSROW = 11,
parameter   T1_PHYWDTH = 73)
(clk, rst, ready, cnt,
ct_adr,
ct_imm,
ct_vld,
ct_serr,
ct_derr,
ac_read,
ac_write,
ac_addr,
ac_din,
ac_dout,
ac_vld,
ac_serr,
ac_derr,
ac_padr,
t1_readB,
t1_addrB,
t1_doutB,
t1_writeA,
t1_addrA,
t1_dinA,
t1_bwA);

parameter WIDTH   = IP_WIDTH;
parameter BITWDTH = IP_BITWIDTH;
parameter ENAPAR  = 0;
parameter ENAECC = 1;
parameter ECCWDTH = IP_DECCBITS;
parameter NUMADDR = IP_NUMADDR;
parameter BITADDR = IP_BITADDR;
parameter NUMCTPT = 4;
parameter BITCTPT = 2;
parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
parameter BITWRDS = T1_BITWRDS;
parameter NUMSROW = T1_NUMSROW;
parameter BITSROW = T1_BITSROW;
parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
parameter PHYWDTH = T1_PHYWDTH;
parameter SRAM_DELAY = T1_DELAY;
parameter BITPADR = BITCTPT+BITSROW+BITWRDS+1;

input [NUMCTPT-1:0]                  cnt;
input [NUMCTPT*BITADDR-1:0]          ct_adr;
input [NUMCTPT*WIDTH-1:0]            ct_imm;
input [NUMCTPT-1:0]                 ct_vld;
input [NUMCTPT-1:0]                 ct_serr;
input [NUMCTPT-1:0]                 ct_derr;
input                                ac_read;
input                                ac_write;
input [BITADDR-1:0]                  ac_addr;
input [WIDTH-1:0]                    ac_din;
input                               ac_vld;
input [WIDTH-1:0]                   ac_dout;
input                               ac_serr;
input                               ac_derr;
input [BITPADR-1:0]                 ac_padr;
input                               ready;
input                                clk, rst;

input [NUMCTPT-1:0] t1_writeA;
input [NUMCTPT*BITSROW-1:0] t1_addrA;
input [NUMCTPT*PHYWDTH-1:0] t1_bwA;
input [NUMCTPT*PHYWDTH-1:0] t1_dinA;

input [NUMCTPT-1:0] t1_readB;
input [NUMCTPT*BITSROW-1:0] t1_addrB;
input [NUMCTPT*PHYWDTH-1:0] t1_doutB;

endmodule
