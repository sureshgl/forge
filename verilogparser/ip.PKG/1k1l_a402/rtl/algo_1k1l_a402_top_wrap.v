/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.UNKNOWN Date: Wed 2012.11.21 at 01:59:18 PM IST
 * */

module algo_1k1l_a402_top_wrap
#(parameter IP_WIDTH = 16, parameter IP_BITWIDTH = 4, parameter IP_DECCBITS = 6, parameter IP_NUMADDR = 16, parameter IP_BITADDR = 4, 
parameter IP_NUMVBNK = 1,	parameter IP_BITVBNK = 1, parameter IP_BITPBNK = 1,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 1, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 0, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,
parameter IP_NUMQPRT = 3, parameter IP_BITQPRT = 2, parameter IP_NUMPING = 4, parameter IP_BITPING = 2,

parameter T1_WIDTH = 4, parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 0, parameter T1_DELAY = 2, parameter T1_NUMVROW = 16, parameter T1_BITVROW = 4,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 0, parameter T1_NUMSROW = 16, parameter T1_BITSROW = 4, parameter T1_PHYWDTH = 4,
parameter T2_WIDTH = 16, parameter T2_NUMVBNK = 1, parameter T2_BITVBNK = 0, parameter T2_DELAY = 2, parameter T2_NUMVROW =16, parameter T2_BITVROW = 4,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 16, parameter T2_BITSROW = 4, parameter T2_PHYWDTH = 16,
parameter T3_WIDTH = 2, parameter T3_NUMVBNK = 1, parameter T3_BITVBNK = 0, parameter T3_DELAY = 0, parameter T3_NUMVROW = 3, parameter T3_BITVROW = 2,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 0, parameter T3_NUMSROW = 3, parameter T3_BITSROW = 2, parameter T3_PHYWDTH = 2,
parameter T4_WIDTH = 2, parameter T4_NUMVBNK = 1, parameter T4_BITVBNK = 0, parameter T4_DELAY = 0, parameter T4_NUMVROW = 3, parameter T4_BITVROW = 2,
parameter T4_BITWSPF = 0, parameter T4_NUMWRDS = 1, parameter T4_BITWRDS = 0, parameter T4_NUMSROW = 3, parameter T4_BITSROW = 2, parameter T4_PHYWDTH = 2,
parameter T5_WIDTH = 5, parameter T5_NUMVBNK = 1, parameter T5_BITVBNK = 0, parameter T5_DELAY = 0, parameter T5_NUMVROW = 3, parameter T5_BITVROW = 1,
parameter T5_BITWSPF = 0, parameter T5_NUMWRDS = 1, parameter T5_BITWRDS = 0, parameter T5_NUMSROW = 3, parameter T5_BITSROW = 2, parameter T5_PHYWDTH = 5,
parameter T6_WIDTH = 16, parameter T6_NUMVBNK = 1, parameter T6_BITVBNK = 0, parameter T6_DELAY = 0, parameter T6_NUMVROW = 3, parameter T6_BITVROW = 2,
parameter T6_BITWSPF = 0, parameter T6_NUMWRDS = 1, parameter T6_BITWRDS = 0, parameter T6_NUMSROW = 3, parameter T6_BITSROW = 2, parameter T6_PHYWDTH = 16,
parameter T7_WIDTH = 16, parameter T7_NUMVBNK = 1, parameter T7_BITVBNK = 0, parameter T7_DELAY = 0, parameter T7_NUMVROW = 3, parameter T7_BITVROW = 2,
parameter T7_BITWSPF = 0, parameter T7_NUMWRDS = 1, parameter T7_BITWRDS = 0, parameter T7_NUMSROW = 3, parameter T7_BITSROW = 2, parameter T7_PHYWDTH = 16,
parameter T8_WIDTH = 4, parameter T8_NUMVBNK = 1, parameter T8_BITVBNK = 0, parameter T8_DELAY = 2, parameter T8_NUMVROW = 16, parameter T8_BITVROW = 4,
parameter T8_BITWSPF = 0, parameter T8_NUMWRDS = 1, parameter T8_BITWRDS = 0, parameter T8_NUMSROW = 16, parameter T8_BITSROW = 4, parameter T8_PHYWDTH = 4)
( clk, rst, ready,
  push, pu_prt, pu_din,
  pop, po_prt, po_dvld, po_dout, 
  freecnt,
  t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB, 
  t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_readB, t2_addrB, t2_doutB, 
  t3_writeA, t3_addrA, t3_bwA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
  t4_writeA, t4_addrA, t4_bwA, t4_dinA, t4_readB, t4_addrB, t4_doutB,
  t5_writeA, t5_addrA, t5_bwA, t5_dinA, t5_writeB, t5_addrB, t5_bwB, t5_dinB, t5_readC, t5_addrC, t5_doutC, t5_readD, t5_addrD, t5_doutD,
  t6_writeA, t6_addrA, t6_bwA, t6_dinA, t6_writeB, t6_addrB, t6_bwB, t6_dinB, t6_readC, t6_addrC, t6_doutC, t6_readD, t6_addrD, t6_doutD,
  t7_writeA, t7_addrA, t7_bwA, t7_dinA, t7_readB, t7_addrB, t7_doutB,
  t8_writeA, t8_addrA, t8_bwA, t8_dinA, t8_readB, t8_addrB, t8_doutB);
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter NUMQPRT = IP_NUMQPRT;
  parameter BITQPRT = IP_BITQPRT;
  parameter NUMPING = IP_NUMPING;
  parameter BITPING = IP_BITPING;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter BITQCNT = BITADDR+1;
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
  parameter MEMWDTH = ENAPAR ? BITADDR+1 : ENAECC ? BITADDR+ECCWDTH : BITADDR;
  parameter PHYWDTH = T1_PHYWDTH;
  parameter QPTR_DELAY = T3_DELAY;
  parameter LINK_DELAY = T1_DELAY;
  parameter DATA_DELAY = T2_DELAY;
  parameter NUMPOPT = 1;
  parameter NUMPUPT = 1;
  
  parameter BITQPTR = BITADDR;
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter BITCPAD = BITQPRT;
  parameter CPUWDTH = 2*BITPING+BITQCNT+2*NUMPING*BITQPTR;

  input [NUMPUPT-1:0]                  push;
  input [NUMPUPT*BITQPRT-1:0]          pu_prt;
  input [NUMPUPT*WIDTH-1:0]            pu_din;

  input [NUMPOPT-1:0]                  pop;
  input [NUMPOPT*BITQPRT-1:0]          po_prt;
  output [NUMPOPT-1:0]                 po_dvld;
  output [NUMPOPT*WIDTH-1:0]           po_dout;

  output [BITQCNT-1:0]                 freecnt;
  output                               ready;
  input                                clk, rst;

  output [NUMPUPT-1:0]                 t1_writeA;
  output [NUMPUPT*BITADDR-1:0]         t1_addrA;
  output [NUMPUPT*T1_WIDTH-1:0]        t1_bwA;
  output [NUMPUPT*T1_WIDTH-1:0]        t1_dinA;
  output [NUMPOPT-1:0]                 t1_readB;
  output [NUMPOPT*BITADDR-1:0]         t1_addrB;
  input [NUMPOPT*T1_WIDTH-1:0]         t1_doutB;

  output [NUMPUPT-1:0]                 t2_writeA;
  output [NUMPUPT*BITADDR-1:0]         t2_addrA;
  output [NUMPUPT*T2_WIDTH-1:0]        t2_bwA;
  output [NUMPUPT*T2_WIDTH-1:0]        t2_dinA;
  output [NUMPOPT-1:0]                 t2_readB;
  output [NUMPOPT*BITADDR-1:0]         t2_addrB;
  input [NUMPOPT*T2_WIDTH-1:0]         t2_doutB;

  output [NUMPOPT-1:0]                 t3_writeA;
  output [NUMPOPT*BITQPRT-1:0]         t3_addrA;
  output [NUMPOPT*BITPING-1:0]         t3_bwA;
  output [NUMPOPT*BITPING-1:0]         t3_dinA;
  output [NUMPOPT-1:0]                 t3_readB;
  output [NUMPOPT*BITQPRT-1:0]         t3_addrB;
  input [NUMPOPT*BITPING-1:0]          t3_doutB;

  output [NUMPUPT-1:0]                 t4_writeA;
  output [NUMPUPT*BITQPRT-1:0]         t4_addrA;
  output [NUMPUPT*BITPING-1:0]         t4_bwA;
  output [NUMPUPT*BITPING-1:0]         t4_dinA;
  output [NUMPUPT-1:0]                 t4_readB;
  output [NUMPUPT*BITQPRT-1:0]         t4_addrB;
  input [NUMPUPT*BITPING-1:0]          t4_doutB;

  output [NUMPOPT-1:0]                 t5_writeA;
  output [NUMPOPT*BITQPRT-1:0]         t5_addrA;
  output [NUMPOPT*BITQCNT-1:0]         t5_bwA;
  output [NUMPOPT*BITQCNT-1:0]         t5_dinA;
  output [NUMPUPT-1:0]                 t5_writeB;
  output [NUMPUPT*BITQPRT-1:0]         t5_addrB;
  output [NUMPUPT*BITQCNT-1:0]         t5_bwB;
  output [NUMPUPT*BITQCNT-1:0]         t5_dinB;
  output [NUMPOPT-1:0]                 t5_readC;
  output [NUMPOPT*BITQPRT-1:0]         t5_addrC;
  input [NUMPOPT*BITQCNT-1:0]          t5_doutC;
  output [NUMPUPT-1:0]                 t5_readD;
  output [NUMPUPT*BITQPRT-1:0]         t5_addrD;
  input [NUMPUPT*BITQCNT-1:0]          t5_doutD;

  output [NUMPOPT-1:0]                 t6_writeA;
  output [NUMPOPT*BITQPRT-1:0]         t6_addrA;
  output [NUMPOPT*NUMPING*BITQPTR-1:0] t6_bwA;
  output [NUMPOPT*NUMPING*BITQPTR-1:0] t6_dinA;
  output [NUMPUPT-1:0]                 t6_writeB;
  output [NUMPUPT*BITQPRT-1:0]         t6_addrB;
  output [NUMPUPT*NUMPING*BITQPTR-1:0] t6_bwB;
  output [NUMPUPT*NUMPING*BITQPTR-1:0] t6_dinB;
  output [NUMPOPT-1:0]                 t6_readC;
  output [NUMPOPT*BITQPRT-1:0]         t6_addrC;
  input [NUMPOPT*NUMPING*BITQPTR-1:0]  t6_doutC;
  output [NUMPUPT-1:0]                 t6_readD;
  output [NUMPUPT*BITQPRT-1:0]         t6_addrD;
  input [NUMPUPT*NUMPING*BITQPTR-1:0]  t6_doutD;

  output [NUMPUPT-1:0]                 t7_writeA;
  output [NUMPUPT*BITQPRT-1:0]         t7_addrA;
  output [NUMPUPT*NUMPING*BITQPTR-1:0] t7_bwA;
  output [NUMPUPT*NUMPING*BITQPTR-1:0] t7_dinA;
  output [NUMPUPT-1:0]                 t7_readB;
  output [NUMPUPT*BITQPRT-1:0]         t7_addrB;
  input [NUMPUPT*NUMPING*BITQPTR-1:0]  t7_doutB;

  output [NUMPUPT-1:0]                 t8_writeA;
  output [NUMPUPT*BITADDR-1:0]         t8_addrA;
  output [NUMPUPT*T1_WIDTH-1:0]        t8_bwA;
  output [NUMPUPT*T1_WIDTH-1:0]        t8_dinA;
  output [NUMPOPT-1:0]                 t8_readB;
  output [NUMPOPT*BITADDR-1:0]         t8_addrB;
  input [NUMPOPT*T1_WIDTH-1:0]         t8_doutB;

  wire [NUMPOPT-1:0]                   t3_writeA_tmp;
  wire [NUMPOPT*BITQPRT-1:0]           t3_addrA_tmp;
  wire [NUMPOPT*BITPING-1:0]           t3_dinA_tmp;
  wire [NUMPOPT-1:0]                   t3_readB_tmp;
  wire [NUMPOPT*BITQPRT-1:0]           t3_addrB_tmp;

  wire [NUMPUPT-1:0]                   t4_writeA_tmp;
  wire [NUMPUPT*BITQPRT-1:0]           t4_addrA_tmp;
  wire [NUMPUPT*BITPING-1:0]           t4_dinA_tmp;
  wire [NUMPUPT-1:0]                   t4_readB_tmp;
  wire [NUMPUPT*BITQPRT-1:0]           t4_addrB_tmp;

  wire [(NUMPOPT+NUMPUPT)-1:0]         t5_writeA_tmp;
  wire [(NUMPOPT+NUMPUPT)*BITQPRT-1:0] t5_addrA_tmp;
  wire [(NUMPOPT+NUMPUPT)*BITQCNT-1:0] t5_dinA_tmp;
  wire [(NUMPOPT+NUMPUPT)-1:0]         t5_readB_tmp;
  wire [(NUMPOPT+NUMPUPT)*BITQPRT-1:0] t5_addrB_tmp;
  wire [(NUMPOPT+NUMPUPT)*BITQCNT-1:0] t5_doutB_tmp;

  wire [(NUMPOPT+NUMPUPT)-1:0]         t6_writeA_tmp;
  wire [(NUMPOPT+NUMPUPT)*BITQPRT-1:0] t6_addrA_tmp;
  wire [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t6_dinA_tmp;
  wire [(NUMPOPT+NUMPUPT)-1:0]         t6_readB_tmp;
  wire [(NUMPOPT+NUMPUPT)*BITQPRT-1:0] t6_addrB_tmp;
  wire [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t6_doutB_tmp;

  wire [NUMPUPT-1:0]                   t7_writeA_tmp;
  wire [NUMPUPT*BITQPRT-1:0]           t7_addrA_tmp;
  wire [NUMPUPT*NUMPING*BITQPTR-1:0]   t7_dinA_tmp;
  wire [NUMPUPT-1:0]                   t7_readB_tmp;
  wire [NUMPUPT*BITQPRT-1:0]           t7_addrB_tmp;

  reg [NUMPOPT-1:0]                    t3_writeA;
  reg [NUMPOPT*BITQPRT-1:0]            t3_addrA;
  reg [NUMPOPT*BITPING-1:0]            t3_dinA;
  reg [NUMPOPT-1:0]                    t3_readB;
  reg [NUMPOPT*BITQPRT-1:0]            t3_addrB;

  reg [NUMPUPT-1:0]                    t4_writeA;
  reg [NUMPUPT*BITQPRT-1:0]            t4_addrA;
  reg [NUMPUPT*BITPING-1:0]            t4_dinA;
  reg [NUMPUPT-1:0]                    t4_readB;
  reg [NUMPUPT*BITQPRT-1:0]            t4_addrB;
  reg [NUMPOPT-1:0]                    t5_writeA;
  reg [NUMPOPT*BITQPRT-1:0]            t5_addrA;
  reg [NUMPOPT*BITQCNT-1:0]            t5_dinA;
  reg [NUMPUPT-1:0]                    t5_writeB;
  reg [NUMPUPT*BITQPRT-1:0]            t5_addrB;
  reg [NUMPUPT*BITQCNT-1:0]            t5_dinB;
  reg [NUMPOPT-1:0]                    t5_readC;
  reg [NUMPOPT*BITQPRT-1:0]            t5_addrC;
  reg [NUMPUPT-1:0]                    t5_readD;
  reg [NUMPUPT*BITQPRT-1:0]            t5_addrD;

  reg [NUMPOPT-1:0]                    t6_writeA;
  reg [NUMPOPT*BITQPRT-1:0]            t6_addrA;
  reg [NUMPOPT*NUMPING*BITQPTR-1:0]    t6_dinA;
  reg [NUMPUPT-1:0]                    t6_writeB;
  reg [NUMPUPT*BITQPRT-1:0]            t6_addrB;
  reg [NUMPUPT*NUMPING*BITQPTR-1:0]    t6_dinB;
  reg [NUMPOPT-1:0]                    t6_readC;
  reg [NUMPOPT*BITQPRT-1:0]            t6_addrC;
  reg [NUMPUPT-1:0]                    t6_readD;
  reg [NUMPUPT*BITQPRT-1:0]            t6_addrD;

  reg [NUMPUPT-1:0]                    t7_writeA;
  reg [NUMPUPT*BITQPRT-1:0]            t7_addrA;
  reg [NUMPUPT*NUMPING*BITQPTR-1:0]    t7_dinA;
  reg [NUMPUPT-1:0]                    t7_readB;
  reg [NUMPUPT*BITQPRT-1:0]            t7_addrB;

  always @(posedge clk) begin
    t3_writeA <= t3_writeA_tmp;
    t3_addrA <= t3_addrA_tmp;
    t3_dinA <= t3_dinA_tmp;
    t3_readB <= t3_readB_tmp;
    t3_addrB <= t3_addrB_tmp;
    t4_writeA <= t4_writeA_tmp;
    t4_addrA <= t4_addrA_tmp;
    t4_dinA <= t4_dinA_tmp;
    t4_readB <= t4_readB_tmp;
    t4_addrB <= t4_addrB_tmp;
    t5_writeA <= t5_writeA_tmp;
    t5_addrA <= t5_addrA_tmp;
    t5_dinA <= t5_dinA_tmp;
    t5_writeB <= t5_writeA_tmp >> 1;
    t5_addrB <= t5_addrA_tmp >> BITQPRT;
    t5_dinB <= t5_dinA_tmp >> BITQCNT;
    t5_readC <= t5_readB_tmp;
    t5_addrC <= t5_addrB_tmp;
    t5_readD <= t5_readB_tmp >> 1;
    t5_addrD <= t5_addrB_tmp >> BITQPRT;
    t6_writeA <= t6_writeA_tmp;
    t6_addrA <= t6_addrA_tmp;
    t6_dinA <= t6_dinA_tmp;
    t6_writeB <= t6_writeA_tmp >> 1;
    t6_addrB <= t6_addrA_tmp >> BITQPRT;
    t6_dinB <= t6_dinA_tmp >> NUMPING*BITQPTR;
    t6_readC <= t6_readB_tmp;
    t6_addrC <= t6_addrB_tmp;
    t6_readD <= t6_readB_tmp >> 1;
    t6_addrD <= t6_addrB_tmp >> BITQPRT;
    t7_writeA <= t7_writeA_tmp;
    t7_addrA <= t7_addrA_tmp;
    t7_dinA <= t7_dinA_tmp;
    t7_readB <= t7_readB_tmp;
    t7_addrB <= t7_addrB_tmp;
  end

  wire [NUMPUPT*T1_WIDTH-1:0]        t1_bwA = ~0;
  wire [NUMPUPT*T2_WIDTH-1:0]        t2_bwA = ~0;
  wire [NUMPOPT*BITPING-1:0]         t3_bwA = ~0;
  wire [NUMPUPT*BITPING-1:0]         t4_bwA = ~0;
  wire [NUMPOPT*BITQCNT-1:0]         t5_bwA = ~0;
  wire [NUMPUPT*BITQCNT-1:0]         t5_bwB = ~0;
  wire [NUMPOPT*NUMPING*BITQPTR-1:0] t6_bwA = ~0;
  wire [NUMPUPT*NUMPING*BITQPTR-1:0] t6_bwB = ~0;
  wire [NUMPUPT*NUMPING*BITQPTR-1:0] t7_bwA = ~0;
  wire [NUMPUPT*T8_WIDTH-1:0]        t8_bwA = ~0;

  assign t5_doutB_tmp = {t5_doutD,t5_doutC};
  assign t6_doutB_tmp = {t6_doutD,t6_doutC};

  algo_1k1l_a402_top 
		#(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMPOPT (NUMPOPT), .NUMPUPT (NUMPUPT), .BITCPAD(BITCPAD), .CPUWDTH(CPUWDTH),
          .NUMQPRT (NUMQPRT), .BITQPRT (BITQPRT), .NUMPING (NUMPING), .BITPING (BITPING), .NUMADDR(NUMADDR), .BITADDR(BITADDR),
		  .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .NUMPBNK(NUMPBNK), .BITPBNK(BITPBNK),
          .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS), .NUMSROW(NUMSROW), .BITSROW(BITSROW),
          .QPTR_WIDTH(T1_WIDTH), .DATA_WIDTH(T2_WIDTH),
          .QPTR_DELAY(QPTR_DELAY+1), .LINK_DELAY(LINK_DELAY), .DATA_DELAY(DATA_DELAY), .FLOPIN(FLOPIN), .FLOPMEM(FLOPMEM), .FLOPOUT(FLOPOUT), .FLOPECC(FLOPECC))	
    algo_top
		(.clk(clk), .rst(rst), .ready(ready),
		 .push(push), .pu_prt(pu_prt), .pu_din(pu_din),
		 .pop(pop), .po_prt(po_prt), .po_cserr(), .po_cderr(),
         .po_dvld(po_dvld), .po_dout(po_dout), .po_dserr(), .po_dderr(),
         .freecnt(freecnt),
         .cp_read(1'b0), .cp_write(1'b0), .cp_adr({BITCPAD{1'b0}}), .cp_din({CPUWDTH{1'b0}}), .cp_vld(), .cp_dout(),
		 .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB), .t1_serrB(), .t1_derrB(), .t1_padrB(),
		 .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB), .t2_serrB(), .t2_derrB(), .t2_padrB(),
		 .t3_writeA(t3_writeA_tmp), .t3_addrA(t3_addrA_tmp), .t3_dinA(t3_dinA_tmp), .t3_readB(t3_readB_tmp), .t3_addrB(t3_addrB_tmp), .t3_doutB(t3_doutB),
		 .t4_writeA(t4_writeA_tmp), .t4_addrA(t4_addrA_tmp), .t4_dinA(t4_dinA_tmp), .t4_readB(t4_readB_tmp), .t4_addrB(t4_addrB_tmp), .t4_doutB(t4_doutB),
		 .t5_writeA(t5_writeA_tmp), .t5_addrA(t5_addrA_tmp), .t5_dinA(t5_dinA_tmp), .t5_readB(t5_readB_tmp), .t5_addrB(t5_addrB_tmp), .t5_doutB(t5_doutB_tmp),
		 .t6_writeA(t6_writeA_tmp), .t6_addrA(t6_addrA_tmp), .t6_dinA(t6_dinA_tmp), .t6_readB(t6_readB_tmp), .t6_addrB(t6_addrB_tmp), .t6_doutB(t6_doutB_tmp),
		 .t7_writeA(t7_writeA_tmp), .t7_addrA(t7_addrA_tmp), .t7_dinA(t7_dinA_tmp), .t7_readB(t7_readB_tmp), .t7_addrB(t7_addrB_tmp), .t7_doutB(t7_doutB),
		 .t8_writeA(t8_writeA), .t8_addrA(t8_addrA), .t8_dinA(t8_dinA), .t8_readB(t8_readB), .t8_addrB(t8_addrB), .t8_doutB(t8_doutB), .t8_serrB(), .t8_derrB(), .t8_padrB());

`ifndef FORMAL
/*
  reg t3_writeA_wire [0:NUMPOPT-1];
  reg [BITQPRT-1:0] t3_addrA_wire [0:NUMPOPT-1];
  reg [BITPING-1:0] t3_dinA_wire [0:NUMPOPT-1];
  reg t3_readB_wire [0:NUMPOPT-1];
  reg [BITQPRT-1:0] t3_addrB_wire [0:NUMPOPT-1];
  integer t3_int;
  always_comb begin
    for (t3_int=0; t3_int<NUMPOPT; t3_int=t3_int+1) begin
      t3_writeA_wire[t3_int] = t3_writeA >> t3_int;
      t3_addrA_wire[t3_int] = t3_addrA >> (t3_int*BITQPRT);
      t3_dinA_wire[t3_int] = t3_dinA >> (t3_int*BITPING);
    end
    for (t3_int=0; t3_int<NUMPOPT; t3_int=t3_int+1) begin
      t3_readB_wire[t3_int] = t3_readB >> t3_int;
      t3_addrB_wire[t3_int] = t3_addrB >> (t3_int*BITQPRT);
    end
  end

  reg [BITPING-1:0] t3_mem [0:NUMQPRT-1];
  integer t3w_int;
  always @(posedge clk) begin
    for (t3w_int=0; t3w_int<NUMPOPT; t3w_int=t3w_int+1)
      if (t3_writeA_wire[t3w_int])
        t3_mem[t3_addrA_wire[t3w_int]] <= t3_dinA_wire[t3w_int];
  end

  integer t3r_int;
  always_comb begin
    t3_doutB_tmp = 0;
    for (t3r_int=0; t3r_int<NUMPOPT; t3r_int=t3r_int+1)
      t3_doutB_tmp = t3_doutB_tmp | (t3_mem[t3_addrB_wire[t3r_int]] << (t3r_int*BITPING));
  end

  always @(posedge clk)
    t3_doutB <= t3_doutB_tmp;

  reg t4_writeA_wire [0:NUMPUPT-1];
  reg [BITQPRT-1:0] t4_addrA_wire [0:NUMPUPT-1];
  reg [BITPING-1:0] t4_dinA_wire [0:NUMPUPT-1];
  reg t4_readB_wire [0:NUMPUPT-1];
  reg [BITQPRT-1:0] t4_addrB_wire [0:NUMPUPT-1];
  integer t4_int;
  always_comb begin
    for (t4_int=0; t4_int<NUMPUPT; t4_int=t4_int+1) begin
      t4_writeA_wire[t4_int] = t4_writeA >> t4_int;
      t4_addrA_wire[t4_int] = t4_addrA >> (t4_int*BITQPRT);
      t4_dinA_wire[t4_int] = t4_dinA >> (t4_int*BITPING);
    end
    for (t4_int=0; t4_int<NUMPUPT; t4_int=t4_int+1) begin
      t4_readB_wire[t4_int] = t4_readB >> t4_int;
      t4_addrB_wire[t4_int] = t4_addrB >> (t4_int*BITQPRT);
    end
  end

  reg [BITPING-1:0] t4_mem [0:NUMQPRT-1];
  integer t4w_int;
  always @(posedge clk) begin
    for (t4w_int=0; t4w_int<NUMPUPT; t4w_int=t4w_int+1)
      if (t4_writeA_wire[t4w_int])
        t4_mem[t4_addrA_wire[t4w_int]] <= t4_dinA_wire[t4w_int];
  end

  integer t4r_int;
  always_comb begin
    t4_doutB_tmp = 0;
    for (t4r_int=0; t4r_int<NUMPUPT; t4r_int=t4r_int+1)
      t4_doutB_tmp = t4_doutB_tmp | (t4_mem[t4_addrB_wire[t4r_int]] << (t4r_int*BITPING));
  end

  always @(posedge clk)
    t4_doutB <= t4_doutB_tmp;

  reg t5_writeA_wire [0:NUMPOPT+NUMPUPT-1];
  reg [BITQPRT-1:0] t5_addrA_wire [0:NUMPOPT+NUMPUPT-1];
  reg [NUMPING*BITQPTR-1:0] t5_dinA_wire [0:NUMPOPT+NUMPUPT-1];
  reg t5_readB_wire [0:NUMPOPT+NUMPUPT-1];
  reg [BITQPRT-1:0] t5_addrB_wire [0:NUMPOPT+NUMPUPT-1];
  integer t5_int;
  always_comb begin
    for (t5_int=0; t5_int<NUMPOPT+NUMPUPT; t5_int=t5_int+1) begin
      t5_writeA_wire[t5_int] = t5_writeA >> t5_int;
      t5_addrA_wire[t5_int] = t5_addrA >> (t5_int*BITQPRT);
      t5_dinA_wire[t5_int] = t5_dinA >> (t5_int*BITQCNT);
    end
    for (t5_int=0; t5_int<NUMPOPT+NUMPUPT; t5_int=t5_int+1) begin
      t5_readB_wire[t5_int] = t5_readB >> t5_int;
      t5_addrB_wire[t5_int] = t5_addrB >> (t5_int*BITQPRT);
    end
  end

  reg [BITQCNT-1:0] t5_mem [0:NUMQPRT-1];
  integer t5w_int;
  always @(posedge clk) begin
    for (t5w_int=0; t5w_int<NUMPOPT+NUMPUPT; t5w_int=t5w_int+1)
      if (t5_writeA_wire[t5w_int])
        t5_mem[t5_addrA_wire[t5w_int]] <= t5_dinA_wire[t5w_int];
  end

  integer t5r_int;
  always_comb begin
    t5_doutB_tmp = 0;
    for (t5r_int=0; t5r_int<NUMPOPT+NUMPUPT; t5r_int=t5r_int+1)
      t5_doutB_tmp = t5_doutB_tmp | (t5_mem[t5_addrB_wire[t5r_int]] << (t5r_int*BITQCNT));
  end

  always @(posedge clk)
    t6_doutB <= t6_doutB_tmp;

  reg t6_writeA_wire [0:NUMPOPT+NUMPUPT-1];
  reg [BITQPRT-1:0] t6_addrA_wire [0:NUMPOPT+NUMPUPT-1];
  reg [NUMPING*BITQPTR-1:0] t6_dinA_wire [0:NUMPOPT+NUMPUPT-1];
  reg t6_readB_wire [0:NUMPOPT+NUMPUPT-1];
  reg [BITQPRT-1:0] t6_addrB_wire [0:NUMPOPT+NUMPUPT-1];
  integer t6_int;
  always_comb begin
    for (t6_int=0; t6_int<NUMPOPT+NUMPUPT; t6_int=t6_int+1) begin
      t6_writeA_wire[t6_int] = t6_writeA >> t6_int;
      t6_addrA_wire[t6_int] = t6_addrA >> (t6_int*BITQPRT);
      t6_dinA_wire[t6_int] = t6_dinA >> (t6_int*NUMPING*BITQPTR);
    end
    for (t6_int=0; t6_int<NUMPOPT+NUMPUPT; t6_int=t6_int+1) begin
      t6_readB_wire[t6_int] = t6_readB >> t6_int;
      t6_addrB_wire[t6_int] = t6_addrB >> (t6_int*BITQPRT);
    end
  end

  reg [NUMPING*BITQPTR-1:0] t6_mem [0:NUMQPRT-1];
  integer t6w_int;
  always @(posedge clk) begin
    for (t6w_int=0; t6w_int<NUMPOPT+NUMPUPT; t6w_int=t6w_int+1)
      if (t6_writeA_wire[t6w_int])
        t6_mem[t6_addrA_wire[t6w_int]] <= t6_dinA_wire[t6w_int];
  end

  integer t6r_int;
  always_comb begin
    t6_doutB_tmp = 0;
    for (t6r_int=0; t6r_int<NUMPOPT+NUMPUPT; t6r_int=t6r_int+1)
      t6_doutB_tmp = t6_doutB_tmp | (t6_mem[t6_addrB_wire[t6r_int]] << (t6r_int*NUMPING*BITQPTR));
  end

  always @(posedge clk)
    t6_doutB <= t6_doutB_tmp;

  reg t7_writeA_wire [0:NUMPUPT-1];
  reg [BITQPRT-1:0] t7_addrA_wire [0:NUMPUPT-1];
  reg [NUMPING*BITQPTR-1:0] t7_dinA_wire [0:NUMPUPT-1];
  reg t7_readB_wire [0:NUMPUPT-1];
  reg [BITQPRT-1:0] t7_addrB_wire [0:NUMPUPT-1];
  integer t7_int;
  always_comb begin
    for (t7_int=0; t7_int<NUMPUPT; t7_int=t7_int+1) begin
      t7_writeA_wire[t7_int] = t7_writeA >> t7_int;
      t7_addrA_wire[t7_int] = t7_addrA >> (t7_int*BITQPRT);
      t7_dinA_wire[t7_int] = t7_dinA >> (t7_int*NUMPING*BITQPTR);
    end
    for (t7_int=0; t7_int<NUMPUPT; t7_int=t7_int+1) begin
      t7_readB_wire[t7_int] = t7_readB >> t7_int;
      t7_addrB_wire[t7_int] = t7_addrB >> (t7_int*BITQPRT);
    end
  end

  reg [NUMPING*BITQPTR-1:0] t7_mem [0:NUMQPRT-1];
  integer t7w_int;
  always @(posedge clk) begin
    for (t7w_int=0; t7w_int<NUMPUPT; t7w_int=t7w_int+1)
      if (t7_writeA_wire[t7w_int])
        t7_mem[t7_addrA_wire[t7w_int]] <= t7_dinA_wire[t7w_int];
  end

  integer t7r_int;
  always_comb begin
    t7_doutB_tmp = 0;
    for (t7r_int=0; t7r_int<NUMPUPT; t7r_int=t7r_int+1)
      t7_doutB_tmp = t7_doutB_tmp | (t7_mem[t7_addrB_wire[t7r_int]] << (t7r_int*NUMPING*BITQPTR));
  end

  always @(posedge clk)
    t7_doutB <= t7_doutB_tmp;

  wire [BITPING-1:0] t3_mem_help = t3_mem[0];
  wire [BITPING-1:0] t4_mem_help = t4_mem[0];
  wire [BITQCNT-1:0] t5_mem_help = t5_mem[0];
  wire [NUMPING*BITQPTR-1:0] t6_mem_help = t6_mem[0];
  wire [NUMPING*BITQPTR-1:0] t7_mem_help = t7_mem[0];
*/
`endif

endmodule    //algo_1k1l_a402_top_wrap
