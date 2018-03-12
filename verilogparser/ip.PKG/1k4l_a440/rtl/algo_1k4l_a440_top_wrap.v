/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.UNKNOWN Date: Wed 2012.11.21 at 01:59:18 PM IST
 * */

module algo_1k4l_a440_top_wrap
#(parameter IP_WIDTH = 83, parameter IP_BITWIDTH = 7, parameter IP_DECCBITS = 8, parameter IP_NUMADDR = 9216, parameter IP_BITADDR = 14, 
parameter IP_NUMVBNK = 1,	parameter IP_BITVBNK = 1, parameter IP_BITPBNK = 1,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 0, parameter IP_SECCDWIDTH = 0, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 0, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,
parameter IP_NUMQPRT = 8, parameter IP_BITQPRT = 3, parameter IP_NUMPING = 4, parameter IP_BITPING = 2,

parameter T1_WIDTH = 20, parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 0, parameter T1_DELAY = 2, parameter T1_NUMVROW = 9216, parameter T1_BITVROW = 14,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 0, parameter T1_NUMSROW = 9216, parameter T1_BITSROW = 14, parameter T1_PHYWDTH = 32,
parameter T2_WIDTH = 2, parameter T2_NUMVBNK = 1, parameter T2_BITVBNK = 0, parameter T2_DELAY = 2, parameter T2_NUMVROW = 2, parameter T2_BITVROW = 1,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 2, parameter T2_BITSROW = 1, parameter T2_PHYWDTH = 3,
parameter T3_WIDTH = 2, parameter T3_NUMVBNK = 1, parameter T3_BITVBNK = 0, parameter T3_DELAY = 2, parameter T3_NUMVROW = 2, parameter T3_BITVROW = 1,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 0, parameter T3_NUMSROW = 2, parameter T3_BITSROW = 1, parameter T3_PHYWDTH = 3,
parameter T4_WIDTH = 15, parameter T4_NUMVBNK = 1, parameter T4_BITVBNK = 0, parameter T4_DELAY = 2, parameter T4_NUMVROW = 2, parameter T4_BITVROW = 1,
parameter T4_BITWSPF = 0, parameter T4_NUMWRDS = 1, parameter T4_BITWRDS = 0, parameter T4_NUMSROW = 2, parameter T4_BITSROW = 1, parameter T4_PHYWDTH = 15,
parameter T5_WIDTH = 56, parameter T5_NUMVBNK = 1, parameter T5_BITVBNK = 0, parameter T5_DELAY = 2, parameter T5_NUMVROW = 2, parameter T5_BITVROW = 1,
parameter T5_BITWSPF = 0, parameter T5_NUMWRDS = 1, parameter T5_BITWRDS = 0, parameter T5_NUMSROW = 2, parameter T5_BITSROW = 1, parameter T5_PHYWDTH = 56,
parameter T6_WIDTH = 56, parameter T6_NUMVBNK = 1, parameter T6_BITVBNK = 0, parameter T6_DELAY = 2, parameter T6_NUMVROW = 2, parameter T6_BITVROW = 1,
parameter T6_BITWSPF = 0, parameter T6_NUMWRDS = 1, parameter T6_BITWRDS = 0, parameter T6_NUMSROW = 2, parameter T6_BITSROW = 1, parameter T6_PHYWDTH = 56)
( clk, rst, ready,
  push, pu_owr, pu_prt, pu_ptr, pu_tail,
  pop, ndq, po_prt, po_pvld, po_ptr,
  t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
  t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
  t3_writeA, t3_addrA, t3_bwA, t3_dinA,
  t3_writeB, t3_addrB, t3_bwB, t3_dinB,
  t3_writeC, t3_addrC, t3_bwC, t3_dinC,
  t3_writeD, t3_addrD, t3_bwD, t3_dinD,
  t3_readE, t3_addrE, t3_doutE,
  t3_readF, t3_addrF, t3_doutF,
  t3_readG, t3_addrG, t3_doutG,
  t3_readH, t3_addrH, t3_doutH,

  t4_writeA, t4_addrA, t4_bwA, t4_dinA,
  t4_writeB, t4_addrB, t4_bwB, t4_dinB,
  t4_writeC, t4_addrC, t4_bwC, t4_dinC,
  t4_writeD, t4_addrD, t4_bwD, t4_dinD,
  t4_writeE, t4_addrE, t4_bwE, t4_dinE,
  t4_readF, t4_addrF, t4_doutF,
  t4_readG, t4_addrG, t4_doutG,
  t4_readH, t4_addrH, t4_doutH,
  t4_readI, t4_addrI, t4_doutI,
  t4_readJ, t4_addrJ, t4_doutJ,

  t5_writeA, t5_addrA, t5_bwA, t5_dinA,
  t5_writeB, t5_addrB, t5_bwB, t5_dinB,
  t5_writeC, t5_addrC, t5_bwC, t5_dinC,
  t5_writeD, t5_addrD, t5_bwD, t5_dinD,
  t5_writeE, t5_addrE, t5_bwE, t5_dinE,
  t5_readF, t5_addrF, t5_doutF,
  t5_readG, t5_addrG, t5_doutG,
  t5_readH, t5_addrH, t5_doutH,
  t5_readI, t5_addrI, t5_doutI,
  t5_readJ, t5_addrJ, t5_doutJ,

  t6_writeA, t6_addrA, t6_bwA, t6_dinA,
  t6_writeB, t6_addrB, t6_bwB, t6_dinB,
  t6_writeC, t6_addrC, t6_bwC, t6_dinC,
  t6_writeD, t6_addrD, t6_bwD, t6_dinD,
  t6_readE, t6_addrE, t6_doutE, t6_readF,
  t6_addrF, t6_doutF, t6_readG, t6_addrG,
  t6_doutG, t6_readH, t6_addrH, t6_doutH);

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
  parameter QPTR_DELAY = T2_DELAY;
  parameter LINK_DELAY = T1_DELAY;
  parameter NUMPOPT = 1;
  parameter NUMPUPT = 4;
  parameter BITPUPT = 2;
  parameter NUMWTPT = 1;
  parameter BITWTPT = 1;
  
  parameter BITQPTR = BITADDR;
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter BITCPAD = BITQPRT;
  parameter CPUWDTH = 2*BITPING+BITQCNT+2*NUMPING*BITQPTR;
  
  parameter FIFOCNT = NUMQPRT;
  parameter BITFIFO = BITQPRT;
  parameter BITBITQPTR = 4; // lg(BITQPTR)

  input [NUMPUPT-1:0]                  push;
  input [NUMPUPT-1:0]                  pu_owr;
  input [NUMPUPT*BITQPRT-1:0]          pu_prt;
  input [NUMPUPT*BITQPTR-1:0]          pu_ptr;
  output [NUMPUPT*BITQPTR-1:0]         pu_tail;

  input [NUMPOPT-1:0]                  pop;
  input [NUMPOPT-1:0]                  ndq;
  input [NUMPOPT*BITQPRT-1:0]          po_prt;
  output [NUMPOPT-1:0]                 po_pvld;
  output [NUMPOPT*BITQPTR-1:0]         po_ptr;

  output                               ready;
  input                                clk, rst;

  output [NUMWTPT-1:0]                 t1_writeA;
  output [NUMWTPT*BITADDR-1:0]         t1_addrA;
  output [NUMWTPT*T1_WIDTH-1:0]        t1_bwA;
  output [NUMWTPT*T1_WIDTH-1:0]        t1_dinA;
  output [NUMPOPT-1:0]                 t1_readB;
  output [NUMPOPT*BITADDR-1:0]         t1_addrB;
  input [NUMPOPT*T1_WIDTH-1:0]         t1_doutB;

  output [NUMPOPT-1:0]                 t2_writeA;
  output [NUMPOPT*BITQPRT-1:0]         t2_addrA;
  output [NUMPOPT*BITPING-1:0]         t2_bwA;
  output [NUMPOPT*BITPING-1:0]         t2_dinA;
  output [NUMPOPT-1:0]                 t2_readB;
  output [NUMPOPT*BITQPRT-1:0]         t2_addrB;
  input [NUMPOPT*BITPING-1:0]          t2_doutB;

  output [0:0]                 t3_writeA;
  output [BITQPRT-1:0]         t3_addrA;
  output [BITPING-1:0]         t3_bwA;
  output [BITPING-1:0]         t3_dinA;
  output [0:0]                 t3_writeB;
  output [BITQPRT-1:0]         t3_addrB;
  output [BITPING-1:0]         t3_bwB;
  output [BITPING-1:0]         t3_dinB;
  output [0:0]                 t3_writeC;
  output [BITQPRT-1:0]         t3_addrC;
  output [BITPING-1:0]         t3_bwC;
  output [BITPING-1:0]         t3_dinC;
  output [0:0]                 t3_writeD;
  output [BITQPRT-1:0]         t3_addrD;
  output [BITPING-1:0]         t3_bwD;
  output [BITPING-1:0]         t3_dinD;
  output [0:0]                 t3_readE;
  output [BITQPRT-1:0]         t3_addrE;
  input  [BITPING-1:0]         t3_doutE;
  output [0:0]                 t3_readF;
  output [BITQPRT-1:0]         t3_addrF;
  input  [BITPING-1:0]         t3_doutF;
  output [0:0]                 t3_readG;
  output [BITQPRT-1:0]         t3_addrG;
  input  [BITPING-1:0]         t3_doutG;
  output [0:0]                 t3_readH;
  output [BITQPRT-1:0]         t3_addrH;
  input  [BITPING-1:0]         t3_doutH;

  output [0:0]                 t4_writeA;
  output [BITQPRT-1:0]         t4_addrA;
  output [BITQCNT-1:0]         t4_bwA;
  output [BITQCNT-1:0]         t4_dinA;
  output [0:0]                 t4_writeB;
  output [BITQPRT-1:0]         t4_addrB;
  output [BITQCNT-1:0]         t4_bwB;
  output [BITQCNT-1:0]         t4_dinB;
  output [0:0]                 t4_writeC;
  output [BITQPRT-1:0]         t4_addrC;
  output [BITQCNT-1:0]         t4_bwC;
  output [BITQCNT-1:0]         t4_dinC;
  output [0:0]                 t4_writeD;
  output [BITQPRT-1:0]         t4_addrD;
  output [BITQCNT-1:0]         t4_bwD;
  output [BITQCNT-1:0]         t4_dinD;
  output [0:0]                 t4_writeE;
  output [BITQPRT-1:0]         t4_addrE;
  output [BITQCNT-1:0]         t4_bwE;
  output [BITQCNT-1:0]         t4_dinE;
  output [0:0]                 t4_readF;
  output [BITQPRT-1:0]         t4_addrF;
  input  [BITQCNT-1:0]         t4_doutF;
  output [0:0]                 t4_readG;
  output [BITQPRT-1:0]         t4_addrG;
  input  [BITQCNT-1:0]         t4_doutG;
  output [0:0]                 t4_readH;
  output [BITQPRT-1:0]         t4_addrH;
  input  [BITQCNT-1:0]         t4_doutH;
  output [0:0]                 t4_readI;
  output [BITQPRT-1:0]         t4_addrI;
  input  [BITQCNT-1:0]         t4_doutI;
  output [0:0]                 t4_readJ;
  output [BITQPRT-1:0]         t4_addrJ;
  input  [BITQCNT-1:0]         t4_doutJ;

  output [0:0]                 t5_writeA;
  output [BITQPRT-1:0]         t5_addrA;
  output [NUMPING*BITQPTR-1:0] t5_bwA;
  output [NUMPING*BITQPTR-1:0] t5_dinA;
  output [0:0]                 t5_writeB;
  output [BITQPRT-1:0]         t5_addrB;
  output [NUMPING*BITQPTR-1:0] t5_bwB;
  output [NUMPING*BITQPTR-1:0] t5_dinB;
  output [0:0]                 t5_writeC;
  output [BITQPRT-1:0]         t5_addrC;
  output [NUMPING*BITQPTR-1:0] t5_bwC;
  output [NUMPING*BITQPTR-1:0] t5_dinC;
  output [0:0]                 t5_writeD;
  output [BITQPRT-1:0]         t5_addrD;
  output [NUMPING*BITQPTR-1:0] t5_bwD;
  output [NUMPING*BITQPTR-1:0] t5_dinD;
  output [0:0]                 t5_writeE;
  output [BITQPRT-1:0]         t5_addrE;
  output [NUMPING*BITQPTR-1:0] t5_bwE;
  output [NUMPING*BITQPTR-1:0] t5_dinE;
  output [0:0]                 t5_readF;
  output [BITQPRT-1:0]         t5_addrF;
  input  [NUMPING*BITQPTR-1:0] t5_doutF;
  output [0:0]                 t5_readG;
  output [BITQPRT-1:0]         t5_addrG;
  input  [NUMPING*BITQPTR-1:0] t5_doutG;
  output [0:0]                 t5_readH;
  output [BITQPRT-1:0]         t5_addrH;
  input  [NUMPING*BITQPTR-1:0] t5_doutH;
  output [0:0]                 t5_readI;
  output [BITQPRT-1:0]         t5_addrI;
  input  [NUMPING*BITQPTR-1:0] t5_doutI;
  output [0:0]                 t5_readJ;
  output [BITQPRT-1:0]         t5_addrJ;
  input  [NUMPING*BITQPTR-1:0] t5_doutJ;

  output [0:0]                 t6_writeA;
  output [BITQPRT-1:0]         t6_addrA;
  output [NUMPING*BITQPTR-1:0] t6_bwA;
  output [NUMPING*BITQPTR-1:0] t6_dinA;
  output [0:0]                 t6_writeB;
  output [BITQPRT-1:0]         t6_addrB;
  output [NUMPING*BITQPTR-1:0] t6_bwB;
  output [NUMPING*BITQPTR-1:0] t6_dinB;
  output [0:0]                 t6_writeC;
  output [BITQPRT-1:0]         t6_addrC;
  output [NUMPING*BITQPTR-1:0] t6_bwC;
  output [NUMPING*BITQPTR-1:0] t6_dinC;
  output [0:0]                 t6_writeD;
  output [BITQPRT-1:0]         t6_addrD;
  output [NUMPING*BITQPTR-1:0] t6_bwD;
  output [NUMPING*BITQPTR-1:0] t6_dinD;
  output [0:0]                 t6_readE;
  output [BITQPRT-1:0]         t6_addrE;
  input  [NUMPING*BITQPTR-1:0] t6_doutE;
  output [0:0]                 t6_readF;
  output [BITQPRT-1:0]         t6_addrF;
  input  [NUMPING*BITQPTR-1:0] t6_doutF;
  output [0:0]                 t6_readG;
  output [BITQPRT-1:0]         t6_addrG;
  input  [NUMPING*BITQPTR-1:0] t6_doutG;
  output [0:0]                 t6_readH;
  output [BITQPRT-1:0]         t6_addrH;
  input  [NUMPING*BITQPTR-1:0] t6_doutH;

  wire [NUMPOPT-1:0]                   t2_writeA_tmp;
  wire [NUMPOPT*BITQPRT-1:0]           t2_addrA_tmp;
  wire [NUMPOPT*BITPING-1:0]           t2_dinA_tmp;
  wire [NUMPOPT-1:0]                   t2_readB_tmp;
  wire [NUMPOPT*BITQPRT-1:0]           t2_addrB_tmp;

  wire [NUMPUPT-1:0]                   t3_writeA_tmp;
  wire [NUMPUPT*BITQPRT-1:0]           t3_addrA_tmp;
  wire [NUMPUPT*BITPING-1:0]           t3_dinA_tmp;
  wire [NUMPUPT-1:0]                   t3_readB_tmp;
  wire [NUMPUPT*BITQPRT-1:0]           t3_addrB_tmp;
  wire [NUMPUPT*BITPING-1:0]           t3_doutB_tmp;

  wire [(NUMPOPT+NUMPUPT)-1:0]         t4_writeA_tmp;
  wire [(NUMPOPT+NUMPUPT)*BITQPRT-1:0] t4_addrA_tmp;
  wire [(NUMPOPT+NUMPUPT)*BITQCNT-1:0] t4_dinA_tmp;
  wire [(NUMPOPT+NUMPUPT)-1:0]         t4_readB_tmp;
  wire [(NUMPOPT+NUMPUPT)*BITQPRT-1:0] t4_addrB_tmp;
  wire [(NUMPOPT+NUMPUPT)*BITQCNT-1:0] t4_doutB_tmp;

  wire [(NUMPOPT+NUMPUPT)-1:0]         t5_writeA_tmp;
  wire [(NUMPOPT+NUMPUPT)*BITQPRT-1:0] t5_addrA_tmp;
  wire [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t5_dinA_tmp;
  wire [(NUMPOPT+NUMPUPT)-1:0]         t5_readB_tmp;
  wire [(NUMPOPT+NUMPUPT)*BITQPRT-1:0] t5_addrB_tmp;
  wire [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t5_doutB_tmp;

  wire [NUMPUPT-1:0]                   t6_writeA_tmp;
  wire [NUMPUPT*BITQPRT-1:0]           t6_addrA_tmp;
  wire [NUMPUPT*NUMPING*BITQPTR-1:0]   t6_dinA_tmp;
  wire [NUMPUPT-1:0]                   t6_readB_tmp;
  wire [NUMPUPT*BITQPRT-1:0]           t6_addrB_tmp;
  wire [NUMPUPT*NUMPING*BITQPTR-1:0]   t6_doutB_tmp;

  reg [NUMPOPT-1:0]                    t2_writeA;
  reg [NUMPOPT*BITQPRT-1:0]            t2_addrA;
  reg [NUMPOPT*BITPING-1:0]            t2_dinA;
  reg [NUMPOPT-1:0]                    t2_readB;
  reg [NUMPOPT*BITQPRT-1:0]            t2_addrB;

  reg [0:0]                 t3_writeA;
  reg [BITQPRT-1:0]         t3_addrA;
  reg [BITPING-1:0]         t3_dinA;
  reg [0:0]                 t3_writeB;
  reg [BITQPRT-1:0]         t3_addrB;
  reg [BITPING-1:0]         t3_dinB;
  reg [0:0]                 t3_writeC;
  reg [BITQPRT-1:0]         t3_addrC;
  reg [BITPING-1:0]         t3_dinC;
  reg [0:0]                 t3_writeD;
  reg [BITQPRT-1:0]         t3_addrD;
  reg [BITPING-1:0]         t3_dinD;
  reg [0:0]                 t3_readE;
  reg [BITQPRT-1:0]         t3_addrE;
  reg [0:0]                 t3_readF;
  reg [BITQPRT-1:0]         t3_addrF;
  reg [0:0]                 t3_readG;
  reg [BITQPRT-1:0]         t3_addrG;
  reg [0:0]                 t3_readH;
  reg [BITQPRT-1:0]         t3_addrH;

  reg [0:0]                 t4_writeA;
  reg [BITQPRT-1:0]         t4_addrA;
  reg [BITQCNT-1:0]         t4_dinA;
  reg [0:0]                 t4_writeB;
  reg [BITQPRT-1:0]         t4_addrB;
  reg [BITQCNT-1:0]         t4_dinB;
  reg [0:0]                 t4_writeC;
  reg [BITQPRT-1:0]         t4_addrC;
  reg [BITQCNT-1:0]         t4_dinC;
  reg [0:0]                 t4_writeD;
  reg [BITQPRT-1:0]         t4_addrD;
  reg [BITQCNT-1:0]         t4_dinD;
  reg [0:0]                 t4_writeE;
  reg [BITQPRT-1:0]         t4_addrE;
  reg [BITQCNT-1:0]         t4_dinE;
  reg [0:0]                 t4_readF;
  reg [BITQPRT-1:0]         t4_addrF;
  reg [0:0]                 t4_readG;
  reg [BITQPRT-1:0]         t4_addrG;
  reg [0:0]                 t4_readH;
  reg [BITQPRT-1:0]         t4_addrH;
  reg [0:0]                 t4_readI;
  reg [BITQPRT-1:0]         t4_addrI;
  reg [0:0]                 t4_readJ;
  reg [BITQPRT-1:0]         t4_addrJ;

  reg [0:0]                 t5_writeA;
  reg [BITQPRT-1:0]         t5_addrA;
  reg [NUMPING*BITQPTR-1:0] t5_dinA;
  reg [0:0]                 t5_writeB;
  reg [BITQPRT-1:0]         t5_addrB;
  reg [NUMPING*BITQPTR-1:0] t5_dinB;
  reg [0:0]                 t5_writeC;
  reg [BITQPRT-1:0]         t5_addrC;
  reg [NUMPING*BITQPTR-1:0] t5_dinC;
  reg [0:0]                 t5_writeD;
  reg [BITQPRT-1:0]         t5_addrD;
  reg [NUMPING*BITQPTR-1:0] t5_dinD;
  reg [0:0]                 t5_writeE;
  reg [BITQPRT-1:0]         t5_addrE;
  reg [NUMPING*BITQPTR-1:0] t5_dinE;
  reg [0:0]                 t5_readF;
  reg [BITQPRT-1:0]         t5_addrF;
  reg [0:0]                 t5_readG;
  reg [BITQPRT-1:0]         t5_addrG;
  reg [0:0]                 t5_readH;
  reg [BITQPRT-1:0]         t5_addrH;
  reg [0:0]                 t5_readI;
  reg [BITQPRT-1:0]         t5_addrI;
  reg [0:0]                 t5_readJ;
  reg [BITQPRT-1:0]         t5_addrJ;

  reg [0:0]                 t6_writeA;
  reg [BITQPRT-1:0]         t6_addrA;
  reg [NUMPING*BITQPTR-1:0] t6_dinA;
  reg [0:0]                 t6_writeB;
  reg [BITQPRT-1:0]         t6_addrB;
  reg [NUMPING*BITQPTR-1:0] t6_dinB;
  reg [0:0]                 t6_writeC;
  reg [BITQPRT-1:0]         t6_addrC;
  reg [NUMPING*BITQPTR-1:0] t6_dinC;
  reg [0:0]                 t6_writeD;
  reg [BITQPRT-1:0]         t6_addrD;
  reg [NUMPING*BITQPTR-1:0] t6_dinD;
  reg [0:0]                 t6_readE;
  reg [BITQPRT-1:0]         t6_addrE;
  reg [0:0]                 t6_readF;
  reg [BITQPRT-1:0]         t6_addrF;
  reg [0:0]                 t6_readG;
  reg [BITQPRT-1:0]         t6_addrG;
  reg [0:0]                 t6_readH;
  reg [BITQPRT-1:0]         t6_addrH;

  /*
  always @(posedge clk) begin
    t2_writeA <= t2_writeA_tmp;
    t2_addrA <= t2_addrA_tmp;
    t2_dinA <= t2_dinA_tmp;
    t2_readB <= t2_readB_tmp;
    t2_addrB <= t2_addrB_tmp;
    t3_writeA <= t3_writeA_tmp;
    t3_addrA <= t3_addrA_tmp;
    t3_dinA <= t3_dinA_tmp;
    t3_readB <= t3_readB_tmp;
    t3_addrB <= t3_addrB_tmp;
    t4_writeA <= t4_writeA_tmp;
    t4_addrA <= t4_addrA_tmp;
    t4_dinA <= t4_dinA_tmp;
    t4_writeB <= t4_writeA_tmp >> 1;
    t4_addrB <= t4_addrA_tmp >> BITQPRT;
    t4_dinB <= t4_dinA_tmp >> BITQCNT;
    t4_readC <= t4_readB_tmp;
    t4_addrC <= t4_addrB_tmp;
    t4_readD <= t4_readB_tmp >> 1;
    t4_addrD <= t4_addrB_tmp >> BITQPRT;
    t5_writeA <= t5_writeA_tmp;
    t5_addrA <= t5_addrA_tmp;
    t5_dinA <= t5_dinA_tmp;
    t5_writeB <= t5_writeA_tmp >> 1;
    t5_addrB <= t5_addrA_tmp >> BITQPRT;
    t5_dinB <= t5_dinA_tmp >> NUMPING*BITQPTR;
    t5_readC <= t5_readB_tmp;
    t5_addrC <= t5_addrB_tmp;
    t5_readD <= t5_readB_tmp >> 1;
    t5_addrD <= t5_addrB_tmp >> BITQPRT;
    t6_writeA <= t6_writeA_tmp;
    t6_addrA <= t6_addrA_tmp;
    t6_dinA <= t6_dinA_tmp;
    t6_readB <= t6_readB_tmp;
    t6_addrB <= t6_addrB_tmp;
  end
  */

 always_comb begin
    t2_writeA = t2_writeA_tmp;
    t2_addrA = t2_addrA_tmp;
    t2_dinA = t2_dinA_tmp;
    t2_readB = t2_readB_tmp;
    t2_addrB = t2_addrB_tmp;
   
    t3_writeA = t3_writeA_tmp;
    t3_addrA = t3_addrA_tmp;
    t3_dinA = t3_dinA_tmp;
    t3_writeB = t3_writeA_tmp >> 1;
    t3_addrB = t3_addrA_tmp >> BITQPRT;
    t3_dinB = t3_dinA_tmp >> BITPING;
    t3_writeC = t3_writeA_tmp >> (1*2);
    t3_addrC = t3_addrA_tmp >> (BITQPRT*2);
    t3_dinC = t3_dinA_tmp >> (BITPING*2);
    t3_writeD = t3_writeA_tmp >> (1*3);
    t3_addrD = t3_addrA_tmp >> (BITQPRT*3);
    t3_dinD = t3_dinA_tmp >> (BITPING*3);
    
    t3_readE = t3_readB_tmp;
    t3_addrE = t3_addrB_tmp;
    t3_readF = t3_readB_tmp >> 1;
    t3_addrF = t3_addrB_tmp >> BITQPRT;
    t3_readG = t3_readB_tmp >> (1*2);
    t3_addrG = t3_addrB_tmp >> (BITQPRT*2);
    t3_readH = t3_readB_tmp >> (1*3);
    t3_addrH = t3_addrB_tmp >> (BITQPRT*3);

    t4_writeA = t4_writeA_tmp;
    t4_addrA = t4_addrA_tmp;
    t4_dinA = t4_dinA_tmp;
    t4_writeB = t4_writeA_tmp >> 1;
    t4_addrB = t4_addrA_tmp >> BITQPRT;
    t4_dinB = t4_dinA_tmp >> BITQCNT;
    t4_writeC = t4_writeA_tmp >> (1*2);
    t4_addrC = t4_addrA_tmp >> (BITQPRT*2);
    t4_dinC = t4_dinA_tmp >> (BITQCNT*2);
    t4_writeD = t4_writeA_tmp >> (1*3);
    t4_addrD = t4_addrA_tmp >> (BITQPRT*3);
    t4_dinD = t4_dinA_tmp >> (BITQCNT*3);
    t4_writeE = t4_writeA_tmp >> (1*4);
    t4_addrE = t4_addrA_tmp >> (BITQPRT*4);
    t4_dinE = t4_dinA_tmp >> (BITQCNT*4);

    t4_readF = t4_readB_tmp;
    t4_addrF = t4_addrB_tmp;
    t4_readG = t4_readB_tmp >> 1;
    t4_addrG = t4_addrB_tmp >> BITQPRT;
    t4_readH = t4_readB_tmp >> (1*2);
    t4_addrH = t4_addrB_tmp >> (BITQPRT*2);
    t4_readI = t4_readB_tmp >> (1*3);
    t4_addrI = t4_addrB_tmp >> (BITQPRT*3);
    t4_readJ = t4_readB_tmp >> (1*4);
    t4_addrJ = t4_addrB_tmp >> (BITQPRT*4);
    
    t5_writeA = t5_writeA_tmp;
    t5_addrA = t5_addrA_tmp;
    t5_dinA = t5_dinA_tmp;
    t5_writeB = t5_writeA_tmp >> 1;
    t5_addrB = t5_addrA_tmp >> BITQPRT;
    t5_dinB = t5_dinA_tmp >> NUMPING*BITQPTR;
    t5_writeC = t5_writeA_tmp >> (1*2);
    t5_addrC = t5_addrA_tmp >> (BITQPRT*2);
    t5_dinC = t5_dinA_tmp >> (NUMPING*BITQPTR*2);
    t5_writeD = t5_writeA_tmp >> (1*3);
    t5_addrD = t5_addrA_tmp >> (BITQPRT*3);
    t5_dinD = t5_dinA_tmp >> (NUMPING*BITQPTR*3);
    t5_writeE = t5_writeA_tmp >> (1*4);
    t5_addrE = t5_addrA_tmp >> (BITQPRT*4);
    t5_dinE = t5_dinA_tmp >> (NUMPING*BITQPTR*4);
   
    t5_readF = t5_readB_tmp;
    t5_addrF = t5_addrB_tmp;
    t5_readG = t5_readB_tmp >> 1;
    t5_addrG = t5_addrB_tmp >> BITQPRT;
    t5_readH = t5_readB_tmp >> (1*2);
    t5_addrH = t5_addrB_tmp >> (BITQPRT*2);
    t5_readI = t5_readB_tmp >> (1*3);
    t5_addrI = t5_addrB_tmp >> (BITQPRT*3);
    t5_readJ = t5_readB_tmp >> (1*4);
    t5_addrJ = t5_addrB_tmp >> (BITQPRT*4);

    t6_writeA = t6_writeA_tmp;
    t6_addrA = t6_addrA_tmp;
    t6_dinA = t6_dinA_tmp;
    t6_writeB = t6_writeA_tmp >> 1;
    t6_addrB = t6_addrA_tmp >> BITQPRT;
    t6_dinB = t6_dinA_tmp >> NUMPING*BITQPTR;
    t6_writeC = t6_writeA_tmp >> (1*2);
    t6_addrC = t6_addrA_tmp >> (BITQPRT*2);
    t6_dinC = t6_dinA_tmp >> (NUMPING*BITQPTR*2);
    t6_writeD = t6_writeA_tmp >> (1*3);
    t6_addrD = t6_addrA_tmp >> (BITQPRT*3);
    t6_dinD = t6_dinA_tmp >> (NUMPING*BITQPTR*3);

    t6_readE = t6_readB_tmp;
    t6_addrE = t6_addrB_tmp;
    t6_readF = t6_readB_tmp >> 1;
    t6_addrF = t6_addrB_tmp >> BITQPRT;
    t6_readG = t6_readB_tmp >> (1*2);
    t6_addrG = t6_addrB_tmp >> (BITQPRT*2);
    t6_readH = t6_readB_tmp >> (1*3);
    t6_addrH = t6_addrB_tmp >> (BITQPRT*3);
  end

  wire [NUMWTPT*T1_WIDTH-1:0]        t1_bwA = ~0;
  wire [NUMPOPT*BITPING-1:0]         t2_bwA = ~0;
  wire [BITPING-1:0]                 t3_bwA = ~0;
  wire [BITPING-1:0]                 t3_bwB = ~0;
  wire [BITPING-1:0]                 t3_bwC = ~0;
  wire [BITPING-1:0]                 t3_bwD = ~0;
  wire [BITQCNT-1:0]                 t4_bwA = ~0;
  wire [BITQCNT-1:0]                 t4_bwB = ~0;
  wire [BITQCNT-1:0]                 t4_bwC = ~0;
  wire [BITQCNT-1:0]                 t4_bwD = ~0;
  wire [BITQCNT-1:0]                 t4_bwE = ~0;
  wire [NUMPING*BITQPTR-1:0]         t5_bwA = ~0;
  wire [NUMPING*BITQPTR-1:0]         t5_bwB = ~0;
  wire [NUMPING*BITQPTR-1:0]         t5_bwC = ~0;
  wire [NUMPING*BITQPTR-1:0]         t5_bwD = ~0;
  wire [NUMPING*BITQPTR-1:0]         t5_bwE = ~0;
  wire [NUMPING*BITQPTR-1:0]         t6_bwA = ~0;
  wire [NUMPING*BITQPTR-1:0]         t6_bwB = ~0;
  wire [NUMPING*BITQPTR-1:0]         t6_bwC = ~0;
  wire [NUMPING*BITQPTR-1:0]         t6_bwD = ~0;

  assign t3_doutB_tmp = {t3_doutH,t3_doutG,t3_doutF,t3_doutE};
  assign t4_doutB_tmp = {t4_doutJ,t4_doutI,t4_doutH,t4_doutG,t4_doutF};
  assign t5_doutB_tmp = {t5_doutJ,t5_doutI,t5_doutH,t5_doutG,t5_doutF};
  assign t6_doutB_tmp = {t6_doutH,t6_doutG,t6_doutF,t6_doutE};

  algo_1k4l_a440_top 
		#(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMPOPT (NUMPOPT), .NUMPUPT (NUMPUPT), .BITPUPT (BITPUPT), .NUMWTPT(NUMWTPT),
          .FIFOCNT(FIFOCNT), .BITFIFO(BITFIFO), .BITBITQPTR(BITBITQPTR),
          .NUMQPRT (NUMQPRT), .BITQPRT (BITQPRT), .NUMPING (NUMPING), .BITPING (BITPING), .NUMADDR(NUMADDR), .BITADDR(BITADDR),
		  .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .NUMPBNK(NUMPBNK), .BITPBNK(BITPBNK),
          .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS), .NUMSROW(NUMSROW), .BITSROW(BITSROW),
          .QPTR_WIDTH(T1_WIDTH), .LINK_DELAY(LINK_DELAY),
          .FLOPIN(FLOPIN), .FLOPMEM(FLOPMEM), .FLOPOUT(FLOPOUT), .FLOPECC(FLOPECC))	
    algo_top
		(.clk(clk), .rst(rst), .ready(ready),
		 .push(push), .pu_owr(pu_owr), .pu_prt(pu_prt), .pu_ptr(pu_ptr), .pu_cvld(), .pu_cnt(), .pu_tail(pu_tail),
		 .pop(pop), .po_ndq(ndq), .po_prt(po_prt), .po_cvld(), .po_cmt(), .po_cnt(), .po_pvld(po_pvld), .po_ptr(po_ptr),
         .cp_read(1'b0), .cp_write(1'b0), .cp_adr({BITCPAD{1'b0}}), .cp_din({CPUWDTH{1'b0}}), .cp_vld(), .cp_dout(),
		 .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
		 .t2_writeA(t2_writeA_tmp), .t2_addrA(t2_addrA_tmp), .t2_dinA(t2_dinA_tmp), .t2_readB(t2_readB_tmp), .t2_addrB(t2_addrB_tmp), .t2_doutB(t2_doutB),
		 .t3_writeA(t3_writeA_tmp), .t3_addrA(t3_addrA_tmp), .t3_dinA(t3_dinA_tmp), .t3_readB(t3_readB_tmp), .t3_addrB(t3_addrB_tmp), .t3_doutB(t3_doutB_tmp),
		 .t4_writeA(t4_writeA_tmp), .t4_addrA(t4_addrA_tmp), .t4_dinA(t4_dinA_tmp), .t4_readB(t4_readB_tmp), .t4_addrB(t4_addrB_tmp), .t4_doutB(t4_doutB_tmp),
		 .t5_writeA(t5_writeA_tmp), .t5_addrA(t5_addrA_tmp), .t5_dinA(t5_dinA_tmp), .t5_readB(t5_readB_tmp), .t5_addrB(t5_addrB_tmp), .t5_doutB(t5_doutB_tmp),
		 .t6_writeA(t6_writeA_tmp), .t6_addrA(t6_addrA_tmp), .t6_dinA(t6_dinA_tmp), .t6_readB(t6_readB_tmp), .t6_addrB(t6_addrB_tmp), .t6_doutB(t6_doutB_tmp));

`ifndef FORMAL
/*
  reg t2_writeA_wire [0:NUMPOPT-1];
  reg [BITQPRT-1:0] t2_addrA_wire [0:NUMPOPT-1];
  reg [BITPING-1:0] t2_dinA_wire [0:NUMPOPT-1];
  reg t2_readB_wire [0:NUMPOPT-1];
  reg [BITQPRT-1:0] t2_addrB_wire [0:NUMPOPT-1];
  integer t2_int;
  always_comb begin
    for (t2_int=0; t2_int<NUMPOPT; t2_int=t2_int+1) begin
      t2_writeA_wire[t2_int] = t2_writeA >> t2_int;
      t2_addrA_wire[t2_int] = t2_addrA >> (t2_int*BITQPRT);
      t2_dinA_wire[t2_int] = t2_dinA >> (t2_int*BITPING);
    end
    for (t2_int=0; t2_int<NUMPOPT; t2_int=t2_int+1) begin
      t2_readB_wire[t2_int] = t2_readB >> t2_int;
      t2_addrB_wire[t2_int] = t2_addrB >> (t2_int*BITQPRT);
    end
  end

  reg [BITPING-1:0] t2_mem [0:NUMQPRT-1];
  integer t2w_int;
  always @(posedge clk) begin
    for (t2w_int=0; t2w_int<NUMPOPT; t2w_int=t2w_int+1)
      if (t2_writeA_wire[t2w_int])
        t2_mem[t2_addrA_wire[t2w_int]] <= t2_dinA_wire[t2w_int];
  end

  integer t2r_int;
  always_comb begin
    t2_doutB_tmp = 0;
    for (t2r_int=0; t2r_int<NUMPOPT; t2r_int=t2r_int+1)
      t2_doutB_tmp = t2_doutB_tmp | (t2_mem[t2_addrB_wire[t2r_int]] << (t2r_int*BITPING));
  end

  always @(posedge clk)
    t2_doutB <= t2_doutB_tmp;

  reg t3_writeA_wire [0:NUMPUPT-1];
  reg [BITQPRT-1:0] t3_addrA_wire [0:NUMPUPT-1];
  reg [BITPING-1:0] t3_dinA_wire [0:NUMPUPT-1];
  reg t3_readB_wire [0:NUMPUPT-1];
  reg [BITQPRT-1:0] t3_addrB_wire [0:NUMPUPT-1];
  integer t3_int;
  always_comb begin
    for (t3_int=0; t3_int<NUMPUPT; t3_int=t3_int+1) begin
      t3_writeA_wire[t3_int] = t3_writeA >> t3_int;
      t3_addrA_wire[t3_int] = t3_addrA >> (t3_int*BITQPRT);
      t3_dinA_wire[t3_int] = t3_dinA >> (t3_int*BITPING);
    end
    for (t3_int=0; t3_int<NUMPUPT; t3_int=t3_int+1) begin
      t3_readB_wire[t3_int] = t3_readB >> t3_int;
      t3_addrB_wire[t3_int] = t3_addrB >> (t3_int*BITQPRT);
    end
  end

  reg [BITPING-1:0] t3_mem [0:NUMQPRT-1];
  integer t3w_int;
  always @(posedge clk) begin
    for (t3w_int=0; t3w_int<NUMPUPT; t3w_int=t3w_int+1)
      if (t3_writeA_wire[t3w_int])
        t3_mem[t3_addrA_wire[t3w_int]] <= t3_dinA_wire[t3w_int];
  end

  integer t3r_int;
  always_comb begin
    t3_doutB_tmp = 0;
    for (t3r_int=0; t3r_int<NUMPUPT; t3r_int=t3r_int+1)
      t3_doutB_tmp = t3_doutB_tmp | (t3_mem[t3_addrB_wire[t3r_int]] << (t3r_int*BITPING));
  end

  always @(posedge clk)
    t3_doutB <= t3_doutB_tmp;

  reg t4_writeA_wire [0:NUMPOPT+NUMPUPT-1];
  reg [BITQPRT-1:0] t4_addrA_wire [0:NUMPOPT+NUMPUPT-1];
  reg [NUMPING*BITQPTR-1:0] t4_dinA_wire [0:NUMPOPT+NUMPUPT-1];
  reg t4_readB_wire [0:NUMPOPT+NUMPUPT-1];
  reg [BITQPRT-1:0] t4_addrB_wire [0:NUMPOPT+NUMPUPT-1];
  integer t4_int;
  always_comb begin
    for (t4_int=0; t4_int<NUMPOPT+NUMPUPT; t4_int=t4_int+1) begin
      t4_writeA_wire[t4_int] = t4_writeA >> t4_int;
      t4_addrA_wire[t4_int] = t4_addrA >> (t4_int*BITQPRT);
      t4_dinA_wire[t4_int] = t4_dinA >> (t4_int*BITQCNT);
    end
    for (t4_int=0; t4_int<NUMPOPT+NUMPUPT; t4_int=t4_int+1) begin
      t4_readB_wire[t4_int] = t4_readB >> t4_int;
      t4_addrB_wire[t4_int] = t4_addrB >> (t4_int*BITQPRT);
    end
  end

  reg [BITQCNT-1:0] t4_mem [0:NUMQPRT-1];
  integer t4w_int;
  always @(posedge clk) begin
    for (t4w_int=0; t4w_int<NUMPOPT+NUMPUPT; t4w_int=t4w_int+1)
      if (t4_writeA_wire[t4w_int])
        t4_mem[t4_addrA_wire[t4w_int]] <= t4_dinA_wire[t4w_int];
  end

  integer t4r_int;
  always_comb begin
    t4_doutB_tmp = 0;
    for (t4r_int=0; t4r_int<NUMPOPT+NUMPUPT; t4r_int=t4r_int+1)
      t4_doutB_tmp = t4_doutB_tmp | (t4_mem[t4_addrB_wire[t4r_int]] << (t4r_int*BITQCNT));
  end

  always @(posedge clk)
    t5_doutB <= t5_doutB_tmp;

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
      t5_dinA_wire[t5_int] = t5_dinA >> (t5_int*NUMPING*BITQPTR);
    end
    for (t5_int=0; t5_int<NUMPOPT+NUMPUPT; t5_int=t5_int+1) begin
      t5_readB_wire[t5_int] = t5_readB >> t5_int;
      t5_addrB_wire[t5_int] = t5_addrB >> (t5_int*BITQPRT);
    end
  end

  reg [NUMPING*BITQPTR-1:0] t5_mem [0:NUMQPRT-1];
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
      t5_doutB_tmp = t5_doutB_tmp | (t5_mem[t5_addrB_wire[t5r_int]] << (t5r_int*NUMPING*BITQPTR));
  end

  always @(posedge clk)
    t5_doutB <= t5_doutB_tmp;

  reg t6_writeA_wire [0:NUMPUPT-1];
  reg [BITQPRT-1:0] t6_addrA_wire [0:NUMPUPT-1];
  reg [NUMPING*BITQPTR-1:0] t6_dinA_wire [0:NUMPUPT-1];
  reg t6_readB_wire [0:NUMPUPT-1];
  reg [BITQPRT-1:0] t6_addrB_wire [0:NUMPUPT-1];
  integer t6_int;
  always_comb begin
    for (t6_int=0; t6_int<NUMPUPT; t6_int=t6_int+1) begin
      t6_writeA_wire[t6_int] = t6_writeA >> t6_int;
      t6_addrA_wire[t6_int] = t6_addrA >> (t6_int*BITQPRT);
      t6_dinA_wire[t6_int] = t6_dinA >> (t6_int*NUMPING*BITQPTR);
    end
    for (t6_int=0; t6_int<NUMPUPT; t6_int=t6_int+1) begin
      t6_readB_wire[t6_int] = t6_readB >> t6_int;
      t6_addrB_wire[t6_int] = t6_addrB >> (t6_int*BITQPRT);
    end
  end

  reg [NUMPING*BITQPTR-1:0] t6_mem [0:NUMQPRT-1];
  integer t6w_int;
  always @(posedge clk) begin
    for (t6w_int=0; t6w_int<NUMPUPT; t6w_int=t6w_int+1)
      if (t6_writeA_wire[t6w_int])
        t6_mem[t6_addrA_wire[t6w_int]] <= t6_dinA_wire[t6w_int];
  end

  integer t6r_int;
  always_comb begin
    t6_doutB_tmp = 0;
    for (t6r_int=0; t6r_int<NUMPUPT; t6r_int=t6r_int+1)
      t6_doutB_tmp = t6_doutB_tmp | (t6_mem[t6_addrB_wire[t6r_int]] << (t6r_int*NUMPING*BITQPTR));
  end

  always @(posedge clk)
    t6_doutB <= t6_doutB_tmp;

  wire [BITPING-1:0] t3_mem_help = t3_mem[0];
  wire [BITPING-1:0] t4_mem_help = t4_mem[0];
  wire [BITQCNT-1:0] t5_mem_help = t5_mem[0];
  wire [NUMPING*BITQPTR-1:0] t6_mem_help = t6_mem[0];
  wire [NUMPING*BITQPTR-1:0] t6_mem_help = t6_mem[0];
*/
`endif

endmodule
