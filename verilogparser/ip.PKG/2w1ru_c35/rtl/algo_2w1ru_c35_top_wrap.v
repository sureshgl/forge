/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.4981M Date: Wed 2012.11.21 at 03:05:28 PM IST
 * */

module algo_2w1ru_c35_top_wrap
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
parameter   IP_ENAECC = 0,
parameter   IP_ENAPAR = 0,
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
(clk, rst, ready, write,
wr_adr,
din,
ru_read,
ru_write,
ru_addr,
ru_din,
ru_dout,
ru_vld,
ru_serr,
ru_derr,
ru_padr,
t1_readB,
t1_addrB,
t1_doutB,
t1_writeA,
t1_addrA,
t1_dinA,
t1_bwA);

parameter WIDTH   = IP_WIDTH;
parameter BITWDTH = IP_BITWIDTH;
parameter ENAPAR  = IP_ENAPAR;
parameter ENAECC = IP_ENAECC;
parameter ECCWDTH = IP_DECCBITS;
parameter NUMADDR = IP_NUMADDR;
parameter BITADDR = IP_BITADDR;
parameter NUMSTPT = 2;
parameter NUMPBNK = 3;
parameter BITPBNK = 2;
parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
parameter BITWRDS = T1_BITWRDS;
parameter NUMSROW = T1_NUMSROW;
parameter BITSROW = T1_BITSROW;
parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
parameter PHYWDTH = T1_PHYWDTH;
parameter SRAM_DELAY = T1_DELAY;
parameter UPDT_DELAY = 7;
parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

input [NUMSTPT-1:0]                  write;
input [NUMSTPT*BITADDR-1:0]          wr_adr;
input [NUMSTPT*WIDTH-1:0]            din;
input                                ru_read;
input                                ru_write;
input [BITADDR-1:0]                  ru_addr;
input [WIDTH-1:0]                    ru_din;
output                               ru_vld;
output [WIDTH-1:0]                   ru_dout;
output                               ru_serr;
output                               ru_derr;
output [BITPADR-1:0]                 ru_padr;
output                               ready;
input                                clk, rst;

output [NUMPBNK-1:0] t1_writeA;
output [NUMPBNK*BITSROW-1:0] t1_addrA;
output [NUMPBNK*PHYWDTH-1:0] t1_bwA;
output [NUMPBNK*PHYWDTH-1:0] t1_dinA;

output [NUMPBNK-1:0] t1_readB;
output [NUMPBNK*BITSROW-1:0] t1_addrB;
input [NUMPBNK*PHYWDTH-1:0] t1_doutB;

algo_2w1ru_top #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ECCWDTH(ECCWDTH),
                 .NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMSTPT(NUMSTPT), .NUMPBNK(NUMPBNK), .BITPBNK(BITPBNK),
                 .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS), .NUMSROW(NUMSROW), .BITSROW(BITSROW), .PHYWDTH(PHYWDTH),
                 .SRAM_DELAY(SRAM_DELAY), .UPDT_DELAY(UPDT_DELAY), .FLOPIN(FLOPIN), .FLOPMEM(FLOPMEM), .FLOPOUT(FLOPOUT), .FLOPECC(FLOPECC))
  algo_top(.clk(clk), .rst(rst), .ready(ready), .st_write(write), .st_adr(wr_adr), .st_din(din),
           .read(ru_read), .write(ru_write), .addr(ru_addr), .din(ru_din),
           .rd_vld(ru_vld), .rd_dout(ru_dout), .rd_serr(ru_serr), .rd_derr(ru_derr), .rd_padr(ru_padr),
           .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_bwA(t1_bwA), .t1_dinA(t1_dinA),
           .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB));

endmodule    //algo_2w1ru_c35_top_wrap
