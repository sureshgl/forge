/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.UNKNOWN Date: Wed 2012.11.21 at 01:59:18 PM IST
 * */

module algo_1r6w_a113_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 1, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,
parameter IP_NUMQUEUE = 416, parameter IP_BITQUEUE = 9,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 8, parameter T1_BITVBNK = 3, parameter T1_DELAY = 1, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 2, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 1024, parameter T1_BITSROW = 10, parameter T1_PHYWDTH = 64,
parameter T2_WIDTH = 32, parameter T2_NUMVBNK = 4, parameter T2_BITVBNK = 2, parameter T2_DELAY = 1, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 2, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 1024, parameter T2_BITSROW = 10, parameter T2_PHYWDTH = 64)
( clk,  rst,  ready,
  push,   pu_adr,   pu_din,
  pop,   po_adr,   po_dout,   po_vld,   po_serr,   po_derr,   po_padr,
  t1_writeA,   t1_addrA,   t1_dinA,    t1_bwA,   t1_readB,    t1_addrB,   t1_doutB,
  t2_writeA,   t2_addrA,   t2_dinA,    t2_bwA,   t2_readB,    t2_addrB,   t2_doutB);
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter NUMQUEU = IP_NUMQUEUE;
  parameter BITQUEU = IP_BITQUEUE;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter NUMPBNK = IP_NUMVBNK + 2;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter MEMWDTH = ENAPAR ? BITADDR+1 : ENAECC ? BITADDR+ECCWDTH : BITADDR;
  parameter PHYWDTH = T1_PHYWDTH;
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = T1_DELAY;
  parameter NUMPOPT = 1;
  parameter NUMPUPT = 6;
  parameter NUMSBFL = 1;
  
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter BITMAPT = (BITPBNK+1)*NUMVBNK;
  
  input [NUMPUPT-1:0]                  push;
  input [NUMPUPT*BITQUEU-1:0]          pu_adr;
  input [NUMPUPT*BITADDR-1:0]          pu_din;

  input [NUMPOPT-1:0]                  pop;
  input [NUMPOPT*BITQUEU-1:0]          po_adr;
  output [NUMPOPT-1:0]                 po_vld;
  output [NUMPOPT*BITADDR-1:0]         po_dout;
  output [NUMPOPT-1:0]                 po_serr;
  output [NUMPOPT-1:0]                 po_derr;
  output [NUMPOPT*BITPADR-1:0]         po_padr;

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

  wire [NUMPUPT-1:0] t3_writeA;
  wire [NUMPUPT*BITVROW-1:0] t3_addrA;
  wire [NUMPUPT*BITMAPT-1:0] t3_dinA;

  wire [(NUMPOPT+NUMPUPT)-1:0] t3_readB;
  wire [(NUMPOPT+NUMPUPT)*BITVROW-1:0] t3_addrB;
  reg [(NUMPOPT+NUMPUPT)*BITMAPT-1:0] t3_doutB_tmp;
  reg [(NUMPOPT+NUMPUPT)*BITMAPT-1:0] t3_doutB;
  
  algo_mrnw_queue_top 
		#(.ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .NUMPOPT (NUMPOPT), .NUMPUPT (NUMPUPT), .NUMSBFL (NUMSBFL),
                  .NUMQUEU (NUMQUEU), .BITQUEU (BITQUEU), .NUMADDR(NUMADDR), .BITADDR(BITADDR),
		  .NUMVROW(NUMVROW),   .BITVROW(BITVROW),   .NUMVBNK(NUMVBNK),   .BITVBNK(BITVBNK),     .NUMPBNK(NUMPBNK),
		  .BITPBNK(BITPBNK),   .NUMWRDS(NUMWRDS),        .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW),
		  .PHYWDTH(PHYWDTH),   .SRAM_DELAY(SRAM_DELAY),    .DRAM_DELAY(DRAM_DELAY), .FLOPIN(FLOPIN), .FLOPMEM(FLOPMEM), .FLOPOUT(FLOPOUT))	
  algo_top
		(.clk(clk), .rst(rst), .ready(ready),
		 .push(push), .pu_adr(pu_adr), .pu_din(pu_din),
		 .pop(pop), .po_adr(po_adr), .po_vld(po_vld), .po_dout(po_dout), .po_serr(po_serr), .po_derr(po_derr), .po_padr(po_padr),
		 .t1_writeA({t2_writeA,t1_writeA}), .t1_addrA({t2_addrA,t1_addrA}), .t1_bwA({t2_bwA,t1_bwA}), .t1_dinA({t2_dinA,t1_dinA}),
                 .t1_readB({t2_readB,t1_readB}), .t1_addrB({t2_addrB,t1_addrB}), .t1_doutB({t2_doutB,t1_doutB}),
		 .t2_writeA(t3_writeA), .t2_addrA(t3_addrA), .t2_dinA(t3_dinA), .t2_readB(t3_readB), .t2_addrB(t3_addrB), .t2_doutB(t3_doutB));

  reg t3_writeA_wire [0:NUMPUPT-1];
  reg [BITVROW-1:0] t3_addrA_wire [0:NUMPUPT*BITVROW-1];
  reg [BITMAPT-1:0] t3_dinA_wire [0:NUMPUPT*BITMAPT-1];
  reg t3_readB_wire [0:(NUMPOPT+NUMPUPT)-1];
  reg [BITVROW-1:0] t3_addrB_wire [0:(NUMPOPT+NUMPUPT)*BITVROW-1];
  integer t3_int;
  always_comb begin
    for (t3_int=0; t3_int<NUMPUPT; t3_int=t3_int+1) begin
      t3_writeA_wire[t3_int] = t3_writeA >> t3_int;
      t3_addrA_wire[t3_int] = t3_addrA >> (t3_int*BITVROW);
      t3_dinA_wire[t3_int] = t3_dinA >> (t3_int*BITMAPT);
    end
    for (t3_int=0; t3_int<NUMPOPT+NUMPUPT; t3_int=t3_int+1) begin
      t3_readB_wire[t3_int] = t3_readB >> t3_int;
      t3_addrB_wire[t3_int] = t3_addrB >> (t3_int*BITVROW);
    end
  end

  reg t3_writeA_reg [0:NUMPUPT-1];
  reg [BITVROW-1:0] t3_addrA_reg [0:NUMPUPT-1];
  reg [BITMAPT-1:0] t3_dinA_reg [0:NUMPUPT-1];
  reg t3_readB_reg [0:(NUMPOPT+NUMPUPT)-1];
  reg [BITVROW-1:0] t3_addrB_reg [0:(NUMPOPT+NUMPUPT)-1];
  integer t3d_int;
  always @(posedge clk) begin
    for (t3d_int=0; t3d_int<NUMPUPT; t3d_int=t3d_int+1) begin
      t3_writeA_reg[t3d_int] <= t3_writeA_wire[t3d_int];
      t3_addrA_reg[t3d_int] <= t3_addrA_wire[t3d_int];
      t3_dinA_reg[t3d_int] <= t3_dinA_wire[t3d_int];
    end
    for (t3d_int=0; t3d_int<NUMPOPT+NUMPUPT; t3d_int=t3d_int+1) begin
      t3_readB_reg[t3d_int] <= t3_readB_wire[t3d_int];
      t3_addrB_reg[t3d_int] <= t3_addrB_wire[t3d_int];
    end
  end

  reg [BITMAPT-1:0] t3_mem [0:NUMVROW-1];
  integer t3w_int;
  always @(posedge clk)
    for (t3w_int=0; t3w_int<NUMPUPT; t3w_int=t3w_int+1)
      if (t3_writeA_reg[t3w_int])
        t3_mem[t3_addrA_reg[t3w_int]] <= t3_dinA_reg[t3w_int];

  integer t3r_int;
  always_comb begin
    t3_doutB_tmp = 0;
    for (t3r_int=0; t3r_int<NUMPOPT+NUMPUPT; t3r_int=t3r_int+1)
      t3_doutB_tmp = t3_doutB_tmp | (t3_mem[t3_addrB_reg[t3r_int]] << (t3r_int*BITMAPT));
  end

  always @(posedge clk)
    t3_doutB <= t3_doutB_tmp;
  
endmodule    //algo_1r6w_a113_top_wrap
