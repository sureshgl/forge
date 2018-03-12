/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.4981M Date: Wed 2012.11.21 at 03:05:28 PM IST
 * */

module algo_4cor1a_c42_sva_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, parameter IP_NUMVBNK = 8, parameter IP_BITVBNK = 4,
parameter IP_SECCBITS = 5, parameter IP_SECCDWIDTH = 5, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPMEM = 0, parameter IP_BITPBNK = 6,
parameter IP_ENAECC =1, parameter IP_ENAPAR = 0, parameter FLOPECC = 0, parameter FLOPCMD = 0, parameter IP_DECCBITS = 7,
parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 32, parameter T1_BITVBNK = 5, parameter T1_DELAY = 1, parameter T1_NUMVROW = 512, parameter T1_BITVROW = 9,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 2, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 256, parameter T1_BITSROW = 8, parameter T1_PHYWDTH = 64,
parameter T2_WIDTH = 32, parameter T2_NUMVBNK = 4, parameter T2_BITVBNK = 2, parameter T2_DELAY = 1, parameter T2_NUMVROW = 512, parameter T2_BITVROW = 9,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 512, parameter T2_BITSROW = 9, parameter T2_PHYWDTH = 32,
parameter T3_WIDTH = 15, parameter T3_NUMVBNK = 4, parameter T3_BITVBNK = 2, parameter T3_DELAY = 1, parameter T3_NUMVROW = 512, parameter T3_BITVROW = 9,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 1, parameter T3_NUMSROW = 512, parameter T3_BITSROW = 9, parameter T3_PHYWDTH = 15)
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
t1_readA,
t1_writeA,
t1_addrA,
t1_bwA,
t1_dinA,
t1_doutA,
t2_writeA,
t2_addrA,
t2_dinA,
t2_bwA,
t2_readB,
t2_addrB,
t2_doutB,
t3_writeA,
t3_addrA,
t3_dinA,
t3_bwA,
t3_readB,
t3_addrB,
t3_doutB);

parameter WIDTH   = IP_WIDTH;
parameter BITWDTH = IP_BITWIDTH;
parameter ENAPAR  = 0;
parameter ENAECC = 1;
parameter ECCWDTH = IP_DECCBITS;
parameter NUMADDR = IP_NUMADDR;
parameter BITADDR = IP_BITADDR;
parameter NUMCTPT = 4;
parameter BITCTPT = 2;
parameter BITPBNK = IP_BITPBNK;
parameter BITVBNK = IP_BITVBNK;
parameter NUMVBNK = IP_NUMVBNK;
parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
parameter BITWRDS = T1_BITWRDS;
parameter NUMSROW = T1_NUMSROW;
parameter BITSROW = T1_BITSROW;
parameter BITVROW = T1_BITVROW;
parameter NUMVROW = T1_NUMVROW;
parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
parameter PHYWDTH = T1_PHYWDTH;
parameter ECCBITS = IP_SECCBITS;
parameter SRAM_DELAY = T1_DELAY;
parameter BITPADR2 = BITPBNK+BITSROW+BITWRDS;
parameter BITPADR1 = BITCTPT+BITPADR2+1;
parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

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
input [BITPADR1-1:0]                 ac_padr;
input                               ready;
input                                clk, rst;

input [NUMCTPT*NUMVBNK-1:0] t1_writeA;
input [NUMCTPT*NUMVBNK-1:0] t1_readA;
input [NUMCTPT*NUMVBNK*BITSROW-1:0] t1_addrA;
input [NUMCTPT*NUMVBNK*PHYWDTH-1:0] t1_bwA;
input [NUMCTPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;
input [NUMCTPT*NUMVBNK*PHYWDTH-1:0] t1_doutA;

input [NUMCTPT-1:0] t2_writeA;
input [NUMCTPT*BITVROW-1:0] t2_addrA;
input [NUMCTPT*MEMWDTH-1:0] t2_dinA;
input [T2_NUMVBNK*MEMWDTH-1:0] t2_bwA;
input [NUMCTPT-1:0] t2_readB;
input [NUMCTPT*BITVROW-1:0] t2_addrB;
input [NUMCTPT*MEMWDTH-1:0] t2_doutB;

input [NUMCTPT-1:0] t3_writeA;
input [NUMCTPT*SDOUT_WIDTH-1:0] t3_dinA;
input [T3_NUMVBNK*SDOUT_WIDTH-1:0] t3_bwA;
input [NUMCTPT*BITVROW-1:0] t3_addrA;
input [T3_NUMVBNK-1:0] t3_readB;
input [T3_NUMVBNK*BITVROW-1:0] t3_addrB;
input  [T3_NUMVBNK*SDOUT_WIDTH-1:0] t3_doutB;

endmodule
