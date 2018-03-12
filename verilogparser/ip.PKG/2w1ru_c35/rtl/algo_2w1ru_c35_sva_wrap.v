/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.4981M Date: Wed 2012.11.21 at 03:05:28 PM IST
 * */

module algo_2w1ru_c35_sva_wrap
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
input                               ru_vld;
input [WIDTH-1:0]                   ru_dout;
input                               ru_serr;
input                               ru_derr;
input [BITPADR-1:0]                 ru_padr;
input                               ready;
input                                clk, rst;

input [NUMPBNK-1:0] t1_writeA;
input [NUMPBNK*BITSROW-1:0] t1_addrA;
input [NUMPBNK*PHYWDTH-1:0] t1_bwA;
input [NUMPBNK*PHYWDTH-1:0] t1_dinA;

input [NUMPBNK-1:0] t1_readB;
input [NUMPBNK*BITSROW-1:0] t1_addrB;
input [NUMPBNK*PHYWDTH-1:0] t1_doutB;

// ********************************************************************************
// ENABLE BELOW ASSERTIONS
// ********************************************************************************

/*
*
  *
  *
  *
module memoir_2w1ru_24Kx20_sva_3_3_8043M
(
 input            clk,
 input            rst,
 input            ready,
 input            write_0,
 input [15 - 1:0] addr_0,
 input [20 - 1:0] din_0,
 input            write_1,
 input [15 - 1:0] addr_1,
 input [20 - 1:0] din_1,
 input            ru_read_2,
 input            ru_write_2,
 input [15 - 1:0] ru_addr_2,
 input [20 - 1:0] ru_din_2,
 input [20 - 1:0] ru_dout_2,
 input            ru_vld_2,
 input            ru_serr_2,
 input            ru_derr_2
 );

  parameter UDEL = 11;
  parameter NUMA = 24576;
  parameter BITA = 15;

  reg [BITA - 1:0]   ru_addr_2_d [0:UDEL-1];
  integer        i;
  always @(posedge clk) begin
    for (i = 0; i < UDEL; i++)
      if (i == 0)
        ru_addr_2_d[i] <= ru_addr_2;
      else
        ru_addr_2_d[i] <= ru_addr_2_d[i-1];
  end

  assert_ru_write_read_check: assert property (@(posedge clk) disable iff (!ready) ru_write_2 |-> $past(ru_read_2, UDEL))
    else $display("[ERROR:memoir:%m:%0t] ru2 ru_write without previous ru_read", $time);

  integer j;
  reg     vld [0:NUMA - 1];
  always @(posedge clk) begin
    if (rst) begin
      for (j = 0; j < NUMA; j++) 
        vld[j] <= 1'b0;
    end else begin
      if (write_0 && |din_0)
        vld[addr_0] <= 1'b1;
      if (write_1 && |din_1)
        vld[addr_1] <= 1'b1;
      if (ru_write_2 & !(|ru_din_2))
        vld[ru_addr_2_d[UDEL-1]] <= 1'b0;
    end
  end

  assert_write_0_vld_entry_check: assert property (@(posedge clk) disable iff (!ready) write_0 |-> !(vld[addr_0]))
    else $display("[ERROR:memoir:%m:%0t] write_0 write to valid entry", $time);
  assert_write_1_vld_entry_check: assert property (@(posedge clk) disable iff (!ready) write_1 |-> !(vld[addr_1]))
    else $display("[ERROR:memoir:%m:%0t] write_1 write to valid_entry", $time);
  assert_ru_read_2_invalid_entry_check: assert property (@(posedge clk) disable iff (!ready) ru_read_2 |-> vld[ru_addr_2])
    else $display("[ERROR:memoir:%m:%0t] ru_read_2 read from invalid entry", $time);

endmodule // memoir_2w1ru_24Kx20_sva_3_3_8043M
*/

endmodule
