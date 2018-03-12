/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.UNKNOWN Date: Wed 2012.11.21 at 01:59:18 PM IST
 * */

module algo_2ru_a55_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 1, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 8, parameter T1_BITVBNK = 3, parameter T1_DELAY = 1, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 2, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 1024, parameter T1_BITSROW = 10, parameter T1_PHYWDTH = 64,
parameter T2_WIDTH = 32, parameter T2_NUMVBNK = 2, parameter T2_BITVBNK = 1, parameter T2_DELAY = 1, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 2, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 1024, parameter T2_BITSROW = 10, parameter T2_PHYWDTH = 64)
( clk,  rst,  ready,
  ru_read, ru_write, ru_addr, ru_din, ru_vld, ru_dout, ru_serr, ru_derr, ru_padr,
  t1_writeA,   t1_addrA,   t1_dinA,    t1_bwA,   t1_readB,    t1_addrB,   t1_doutB,
  t2_writeA,   t2_addrA,   t2_dinA,    t2_bwA,   t2_readB,    t2_addrB,   t2_doutB);
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter NUMPBNK = IP_NUMVBNK + 1;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter PHYWDTH = T1_PHYWDTH;
  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = T1_DELAY;
  parameter NUMRUPT = 2;
  
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter BITMAPT = BITPBNK*NUMVBNK;
  
  input [NUMRUPT-1:0]                        ru_read;
  input [NUMRUPT-1:0]                        ru_write;
  input [NUMRUPT*BITADDR-1:0]                ru_addr;
  input [NUMRUPT*WIDTH-1:0]                  ru_din;
  output [NUMRUPT-1:0]                       ru_vld;
  output [NUMRUPT*WIDTH-1:0]                 ru_dout;
  output [NUMRUPT-1:0]                       ru_serr;
  output [NUMRUPT-1:0]                       ru_derr;
  output [NUMRUPT*BITPADR-1:0]               ru_padr;

  output                               ready;
  input                                clk, rst;

  output [T1_NUMVBNK-1:0] t1_writeA;
  output [T1_NUMVBNK*BITSROW-1:0] t1_addrA;
  output [T1_NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [T1_NUMVBNK*PHYWDTH-1:0] t1_dinA;
  output [T1_NUMVBNK-1:0] t1_readB;
  output [T1_NUMVBNK*BITSROW-1:0] t1_addrB;
  input  [T1_NUMVBNK*PHYWDTH-1:0] t1_doutB;

  output [T2_NUMVBNK-1:0] t2_writeA;
  output [T2_NUMVBNK*BITSROW-1:0] t2_addrA;
  output [T2_NUMVBNK*PHYWDTH-1:0] t2_bwA;
  output [T2_NUMVBNK*PHYWDTH-1:0] t2_dinA;
  output [T2_NUMVBNK-1:0] t2_readB;
  output [T2_NUMVBNK*BITSROW-1:0] t2_addrB;
  input  [T2_NUMVBNK*PHYWDTH-1:0] t2_doutB;

  wire [(NUMRUPT-1)-1:0] t3_writeA;
  wire [(NUMRUPT-1)*BITSROW-1:0] t3_addrA;
  wire [(NUMRUPT-1)*BITMAPT-1:0] t3_dinA;

  wire [NUMRUPT-1:0] t3_readB;
  wire [NUMRUPT*BITSROW-1:0] t3_addrB;
  reg [NUMRUPT*BITMAPT-1:0] t3_doutB;
  
  algo_2ru_1r1w_mt_top 
		#(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .NUMADDR(NUMADDR), .BITADDR(BITADDR),
		  .NUMVROW(NUMVROW),   .BITVROW(BITVROW),   .NUMVBNK(NUMVBNK),   .BITVBNK(BITVBNK),     .NUMPBNK(NUMPBNK),
		  .BITPBNK(BITPBNK),   .NUMWRDS(NUMWRDS),        .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW),
		  .PHYWDTH(PHYWDTH),   .SRAM_DELAY(SRAM_DELAY),    .DRAM_DELAY(DRAM_DELAY), .FLOPIN(FLOPIN), .FLOPMEM(FLOPMEM), .FLOPOUT(FLOPOUT))	
  algo_top
		(.clk(clk), .rst(rst), .ready(ready),
		 .read(ru_read), .write(ru_write), .addr(ru_addr), .din(ru_din),
                 .rd_vld(ru_vld), .rd_dout(ru_dout), .rd_serr(ru_serr), .rd_derr(ru_derr), .rd_padr(ru_padr),
		 .t1_writeA({t2_writeA,t1_writeA}), .t1_addrA({t2_addrA,t1_addrA}), .t1_bwA({t2_bwA,t1_bwA}), .t1_dinA({t2_dinA,t1_dinA}),
                 .t1_readB({t2_readB,t1_readB}), .t1_addrB({t2_addrB,t1_addrB}), .t1_doutB({t2_doutB,t1_doutB}),
 		 .t2_writeA(t3_writeA), .t2_addrA(t3_addrA), .t2_dinA(t3_dinA), .t2_readB(t3_readB), .t2_addrB(t3_addrB), .t2_doutB(t3_doutB));

  reg t3_writeA_wire [0:(NUMRUPT-1)-1];
  reg [BITSROW-1:0] t3_addrA_wire [0:(NUMRUPT-1)-1];
  reg [BITSROW-1:0] t3_dinA_wire [0:(NUMRUPT-1)-1];
  reg t3_readB_wire [0:NUMRUPT-1];
  reg [BITSROW-1:0] t3_addrB_wire [0:NUMRUPT-1];
  integer t3_int;
  always_comb begin
    for (t3_int=0; t3_int<NUMRUPT-1; t3_int=t3_int+1) begin
      t3_writeA_wire[t3_int] = t3_writeA >> t3_int;
      t3_addrA_wire[t3_int] = t3_addrA >> (t3_int*BITSROW);
      t3_dinA_wire[t3_int] = t3_dinA >> (t3_int*BITMAPT);
    end
    for (t3_int=0; t3_int<NUMRUPT; t3_int=t3_int+1) begin
      t3_readB_wire[t3_int] = t3_readB >> t3_int;
      t3_addrB_wire[t3_int] = t3_addrB >> (t3_int*BITSROW);
    end
  end
  
  wire t3_writeA_wire_0 = t3_writeA_wire[0];
  wire [BITSROW-1:0] t3_addrA_wire_0 = t3_addrA_wire[0];
  wire [BITSROW-1:0] t3_dinA_wire_0 = t3_dinA_wire[0];
  wire t3_readB_wire_0 = t3_readB_wire[0];
  wire [BITSROW-1:0] t3_addrB_wire_0 = t3_addrB_wire[0];

  wire t3_writeA_wire_1 = t3_writeA_wire[1];
  wire [BITSROW-1:0] t3_addrA_wire_1 = t3_addrA_wire[1];
  wire [BITSROW-1:0] t3_dinA_wire_1 = t3_dinA_wire[1];
  wire t3_readB_wire_1 = t3_readB_wire[1];
  wire [BITSROW-1:0] t3_addrB_wire_1 = t3_addrB_wire[1];

  reg t3_writeA_reg [0:(NUMRUPT-1)-1];
  reg [BITSROW-1:0] t3_addrA_reg [0:(NUMRUPT-1)-1];
  reg [BITMAPT-1:0] t3_dinA_reg [0:(NUMRUPT-1)-1];
  reg t3_readB_reg [0:NUMRUPT-1];
  reg [BITSROW-1:0] t3_addrB_reg [0:NUMRUPT-1];
  integer t3d_int;
  always @(posedge clk) begin
    for (t3d_int=0; t3d_int<NUMRUPT-1; t3d_int=t3d_int+1) begin
      t3_writeA_reg[t3d_int] <= t3_writeA_wire[t3d_int];
      t3_addrA_reg[t3d_int] <= t3_addrA_wire[t3d_int];
      t3_dinA_reg[t3d_int] <= t3_dinA_wire[t3d_int];
    end
    for (t3d_int=0; t3d_int<NUMRUPT; t3d_int=t3d_int+1) begin
      t3_readB_reg[t3d_int] <= t3_readB_wire[t3d_int];
      t3_addrB_reg[t3d_int] <= t3_addrB_wire[t3d_int];
    end
  end

  reg [BITMAPT-1:0] t3_mem [0:NUMVROW-1];
  integer t3w_int;
  always @(posedge clk)
    for (t3w_int=0; t3w_int<NUMRUPT-1; t3w_int=t3w_int+1)
      if (t3_writeA_reg[t3w_int])
        t3_mem[t3_addrA_reg[t3w_int]] <= t3_dinA_reg[t3w_int];

  integer t3r_int;
  always_comb begin
    t3_doutB = 0;
    for (t3r_int=0; t3r_int<NUMRUPT; t3r_int=t3r_int+1)
      t3_doutB = t3_doutB | (t3_mem[t3_addrB_reg[t3r_int]] << (t3r_int*BITMAPT));
  end
  
endmodule    //algo_2ru_a55_top_wrap
