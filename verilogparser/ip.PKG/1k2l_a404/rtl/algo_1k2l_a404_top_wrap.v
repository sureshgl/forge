/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.UNKNOWN Date: Wed 2012.11.21 at 01:59:18 PM IST
 * */

module algo_1k2l_a404_top_wrap
#(parameter IP_WIDTH = 16, parameter IP_BITWIDTH = 4, parameter IP_DECCBITS = 6, parameter IP_NUMADDR = 12, parameter IP_BITADDR = 4, 
parameter IP_NUMVBNK = 1,	parameter IP_BITVBNK = 1, parameter IP_BITPBNK = 1,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 1, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 0, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,
parameter IP_NUMQPRT = 3, parameter IP_BITQPRT = 2, parameter IP_NUMPING = 8, parameter IP_BITPING = 3,
parameter IP_BITMDAT = 5,

parameter T1_T1_WIDTH = 9,  parameter T1_T1_NUMVBNK = 4, parameter T1_T1_BITVBNK = 2, parameter T1_T1_DELAY = 2,      parameter T1_T1_NUMVROW = 3, parameter T1_T1_BITVROW = 2,
parameter T1_T1_BITWSPF = 0, parameter T1_T1_NUMWRDS = 1, parameter T1_T1_BITWRDS = 0, parameter T1_T1_NUMSROW = 3, parameter T1_T1_BITSROW = 2,   parameter T1_T1_PHYWDTH = 9,
parameter T1_T2_WIDTH = 9,  parameter T1_T2_NUMVBNK = 2, parameter T1_T2_BITVBNK = 1, parameter T1_T2_DELAY = 2,      parameter T1_T2_NUMVROW = 3, parameter T1_T2_BITVROW = 2,
parameter T1_T2_BITWSPF = 0, parameter T1_T2_NUMWRDS = 1, parameter T1_T2_BITWRDS = 0, parameter T1_T2_NUMSROW = 3, parameter T1_T2_BITSROW = 2,   parameter T1_T2_PHYWDTH = 9,
parameter T1_T3_WIDTH = 10,  parameter T1_T3_NUMVBNK = 3, parameter T1_T3_BITVBNK = 2, parameter T1_T3_DELAY = 2,      parameter T1_T3_NUMVROW = 3, parameter T1_T3_BITVROW = 2,
parameter T1_T3_BITWSPF = 0, parameter T1_T3_NUMWRDS = 1, parameter T1_T3_BITWRDS = 0, parameter T1_T3_NUMSROW = 3, parameter T1_T3_BITSROW = 2,   parameter T1_T3_PHYWDTH = 10,
parameter T2_T1_WIDTH = 16,  parameter T2_T1_NUMVBNK = 4, parameter T2_T1_BITVBNK = 2, parameter T2_T1_DELAY = 2,      parameter T2_T1_NUMVROW = 3, parameter T2_T1_BITVROW = 2,
parameter T2_T1_BITWSPF = 0, parameter T2_T1_NUMWRDS = 1, parameter T2_T1_BITWRDS = 0, parameter T2_T1_NUMSROW = 3, parameter T2_T1_BITSROW = 2,   parameter T2_T1_PHYWDTH = 16,
parameter T2_T2_WIDTH = 16,  parameter T2_T2_NUMVBNK = 2, parameter T2_T2_BITVBNK = 1, parameter T2_T2_DELAY = 2,      parameter T2_T2_NUMVROW = 3, parameter T2_T2_BITVROW = 2,
parameter T2_T2_BITWSPF = 0, parameter T2_T2_NUMWRDS = 1, parameter T2_T2_BITWRDS = 0, parameter T2_T2_NUMSROW = 3, parameter T2_T2_BITSROW = 2,   parameter T2_T2_PHYWDTH = 16,
parameter T2_T3_WIDTH = 10,  parameter T2_T3_NUMVBNK = 3, parameter T2_T3_BITVBNK = 2, parameter T2_T3_DELAY = 2,      parameter T2_T3_NUMVROW = 3, parameter T2_T3_BITVROW = 2,
parameter T2_T3_BITWSPF = 0, parameter T2_T3_NUMWRDS = 1, parameter T2_T3_BITWRDS = 0, parameter T2_T3_NUMSROW = 3, parameter T2_T3_BITSROW = 2,   parameter T2_T3_PHYWDTH = 10,
parameter T3_WIDTH = 3, parameter T3_NUMVBNK = 1, parameter T3_BITVBNK = 0, parameter T3_DELAY = 0, parameter T3_NUMVROW = 3, parameter T3_BITVROW = 2,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 0, parameter T3_NUMSROW = 3, parameter T3_BITSROW = 2, parameter T3_PHYWDTH = 3,
parameter T4_WIDTH = 3, parameter T4_NUMVBNK = 1, parameter T4_BITVBNK = 0, parameter T4_DELAY = 0, parameter T4_NUMVROW = 3, parameter T4_BITVROW = 2,
parameter T4_BITWSPF = 0, parameter T4_NUMWRDS = 1, parameter T4_BITWRDS = 0, parameter T4_NUMSROW = 3, parameter T4_BITSROW = 2, parameter T4_PHYWDTH = 3,
parameter T5_WIDTH = 5, parameter T5_NUMVBNK = 1, parameter T5_BITVBNK = 0, parameter T5_DELAY = 0, parameter T5_NUMVROW = 3, parameter T5_BITVROW = 2,
parameter T5_BITWSPF = 0, parameter T5_NUMWRDS = 1, parameter T5_BITWRDS = 0, parameter T5_NUMSROW = 3, parameter T5_BITSROW = 2, parameter T5_PHYWDTH = 5,
parameter T6_WIDTH = 72, parameter T6_NUMVBNK = 1, parameter T6_BITVBNK = 0, parameter T6_DELAY = 0, parameter T6_NUMVROW = 3, parameter T6_BITVROW = 2,
parameter T6_BITWSPF = 0, parameter T6_NUMWRDS = 1, parameter T6_BITWRDS = 0, parameter T6_NUMSROW = 3, parameter T6_BITSROW = 2, parameter T6_PHYWDTH = 72,
parameter T7_WIDTH = 32, parameter T7_NUMVBNK = 1, parameter T7_BITVBNK = 0, parameter T7_DELAY = 0, parameter T7_NUMVROW = 3, parameter T7_BITVROW = 2,
parameter T7_BITWSPF = 0, parameter T7_NUMWRDS = 1, parameter T7_BITWRDS = 0, parameter T7_NUMSROW = 2, parameter T7_BITSROW = 1, parameter T7_PHYWDTH = 32,
parameter T8_WIDTH = 4, parameter T8_NUMVBNK = 2, parameter T8_BITVBNK = 1, parameter T8_DELAY = 2, parameter T8_NUMVROW = 6, parameter T8_BITVROW = 3,
parameter T8_BITWSPF = 0, parameter T8_NUMWRDS = 1, parameter T8_BITWRDS = 0, parameter T8_NUMSROW = 6, parameter T8_BITSROW = 3, parameter T8_PHYWDTH = 4)
( clk, rst, ready,
  push, pu_prt, pu_metadata, pu_din,
  pop, po_prt, po_metadata, po_dvld, po_dout,
  freecnt,
  t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
  t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
  t3_writeA, t3_addrA, t3_bwA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
  t4_writeA, t4_addrA, t4_bwA, t4_dinA, t4_readB, t4_addrB, t4_doutB,
  t5_writeA, t5_addrA, t5_bwA, t5_dinA, t5_readB, t5_addrB, t5_doutB,
  t6_writeA, t6_addrA, t6_bwA, t6_dinA, t6_readB, t6_addrB, t6_doutB,
  t7_writeA, t7_addrA, t7_bwA, t7_dinA, t7_readB, t7_addrB, t7_doutB,
  t8_writeA, t8_addrA, t8_bwA, t8_dinA, t8_writeB, t8_addrB, t8_bwB, t8_dinB, t8_readC, t8_addrC, t8_doutC, t8_readD, t8_addrD, t8_doutD,
  t9_writeA, t9_addrA, t9_bwA, t9_dinA, t9_writeB, t9_addrB, t9_bwB, t9_dinB, t9_writeC, t9_addrC, t9_bwC, t9_dinC,
  t9_readD, t9_addrD, t9_doutD, t9_readE, t9_addrE, t9_doutE, t9_readF, t9_addrF, t9_doutF,
  t10_writeA, t10_addrA, t10_bwA, t10_dinA, t10_writeB, t10_addrB, t10_bwB, t10_dinB, t10_writeC, t10_addrC, t10_bwC, t10_dinC,
  t10_readD, t10_addrD, t10_doutD, t10_readE, t10_addrE, t10_doutE, t10_readF, t10_addrF, t10_doutF,
  t11_writeA, t11_addrA, t11_bwA, t11_dinA, t11_writeB, t11_addrB, t11_bwB, t11_dinB,
  t11_readC, t11_addrC, t11_doutC, t11_readD, t11_addrD, t11_doutD,
  t12_writeA, t12_addrA, t12_bwA, t12_dinA, t12_readB, t12_addrB, t12_doutB);
  
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
  parameter NUMVROW = T1_T1_NUMVROW;
  parameter BITVROW = T1_T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter NUMPBNK = IP_NUMVBNK + 1;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMWRDS = T1_T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_T1_BITWRDS;
  parameter NUMSROW = T1_T1_NUMSROW;
  parameter BITSROW = T1_T1_BITSROW;
  parameter MEMWDTH = ENAPAR ? BITADDR+1 : ENAECC ? BITADDR+ECCWDTH : BITADDR;
  parameter PHYWDTH = T2_T1_PHYWDTH;
  parameter QPTR_DELAY = T3_DELAY;
  parameter LINK_DELAY = T1_T1_DELAY;
  parameter DATA_DELAY = T2_T1_DELAY;
  parameter NUMPOPT = 1;
  parameter NUMPUPT = 2;
  parameter BITMDAT = IP_BITMDAT;
  parameter NUMMDAT = 3;
  
  parameter BITQPTR = BITADDR;
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter BITCPAD = BITQPRT;
  parameter CPUWDTH = 2*BITPING+BITQCNT+2*NUMPING*(BITQPTR+BITMDAT);

  input [NUMPUPT-1:0]                  push;
  input [NUMPUPT*BITQPRT-1:0]          pu_prt;
  input [NUMPUPT*BITMDAT-1:0]          pu_metadata;
  input [NUMPUPT*WIDTH-1:0]            pu_din;

  input [NUMPOPT-1:0]                  pop;
  input [NUMPOPT*BITQPRT-1:0]          po_prt;
  output [NUMPOPT*NUMMDAT*BITMDAT-1:0]         po_metadata;
  output [NUMPOPT-1:0]                 po_dvld;
  output [NUMPOPT*WIDTH-1:0]           po_dout;

  output [BITQCNT-1:0]                 freecnt;
  output                               ready;
  input                                clk, rst;

  output [T1_T1_NUMVBNK-1:0]                 t1_writeA;
  output [T1_T1_NUMVBNK*T1_T1_BITVROW-1:0]   t1_addrA;
  output [T1_T1_NUMVBNK*T1_T1_PHYWDTH-1:0]   t1_bwA;
  output [T1_T1_NUMVBNK*T1_T1_PHYWDTH-1:0]   t1_dinA;
  output [T1_T1_NUMVBNK-1:0]                 t1_readB;
  output [T1_T1_NUMVBNK*T1_T1_BITVROW-1:0]   t1_addrB;
  input  [T1_T1_NUMVBNK*T1_T1_PHYWDTH-1:0]   t1_doutB;

  output [T1_T2_NUMVBNK-1:0]                 t2_writeA;
  output [T1_T2_NUMVBNK*T1_T2_BITVROW-1:0]   t2_addrA;
  output [T1_T2_NUMVBNK*T1_T2_PHYWDTH-1:0]   t2_bwA;
  output [T1_T2_NUMVBNK*T1_T2_PHYWDTH-1:0]   t2_dinA;
  output [T1_T2_NUMVBNK-1:0]                 t2_readB;
  output [T1_T2_NUMVBNK*T1_T2_BITVROW-1:0]   t2_addrB;
  input  [T1_T2_NUMVBNK*T1_T2_PHYWDTH-1:0]   t2_doutB;

  output [T1_T3_NUMVBNK-1:0]                 t3_writeA;
  output [T1_T3_NUMVBNK*T1_T3_BITVROW-1:0]   t3_addrA;
  output [T1_T3_NUMVBNK*T1_T3_PHYWDTH-1:0]   t3_bwA;
  output [T1_T3_NUMVBNK*T1_T3_PHYWDTH-1:0]   t3_dinA;
  output [T1_T3_NUMVBNK-1:0]                 t3_readB;
  output [T1_T3_NUMVBNK*T1_T3_BITVROW-1:0]   t3_addrB;
  input  [T1_T3_NUMVBNK*T1_T3_PHYWDTH-1:0]   t3_doutB;

  output [T2_T1_NUMVBNK-1:0]                 t4_writeA;
  output [T2_T1_NUMVBNK*T2_T1_BITVROW-1:0]   t4_addrA;
  output [T2_T1_NUMVBNK*T2_T1_PHYWDTH-1:0]   t4_bwA;
  output [T2_T1_NUMVBNK*T2_T1_PHYWDTH-1:0]   t4_dinA;
  output [T2_T1_NUMVBNK-1:0]                 t4_readB;
  output [T2_T1_NUMVBNK*T2_T1_BITVROW-1:0]   t4_addrB;
  input  [T2_T1_NUMVBNK*T2_T1_PHYWDTH-1:0]   t4_doutB;

  output [T2_T2_NUMVBNK-1:0]                 t5_writeA;
  output [T2_T2_NUMVBNK*T2_T2_BITVROW-1:0]   t5_addrA;
  output [T2_T2_NUMVBNK*T2_T2_PHYWDTH-1:0]   t5_bwA;
  output [T2_T2_NUMVBNK*T2_T2_PHYWDTH-1:0]   t5_dinA;
  output [T2_T2_NUMVBNK-1:0]                 t5_readB;
  output [T2_T2_NUMVBNK*T2_T2_BITVROW-1:0]   t5_addrB;
  input  [T2_T2_NUMVBNK*T2_T2_PHYWDTH-1:0]   t5_doutB;

  output [T2_T3_NUMVBNK-1:0]                 t6_writeA;
  output [T2_T3_NUMVBNK*T2_T3_BITVROW-1:0]   t6_addrA;
  output [T2_T3_NUMVBNK*T2_T3_PHYWDTH-1:0]   t6_bwA;
  output [T2_T3_NUMVBNK*T2_T3_PHYWDTH-1:0]   t6_dinA;
  output [T2_T3_NUMVBNK-1:0]                 t6_readB;
  output [T2_T3_NUMVBNK*T2_T3_BITVROW-1:0]   t6_addrB;
  input  [T2_T3_NUMVBNK*T2_T3_PHYWDTH-1:0]   t6_doutB;

  output                       t7_writeA;
  output [BITQPRT-1:0]         t7_addrA;
  output [BITPING-1:0]         t7_bwA;
  output [BITPING-1:0]         t7_dinA;
  output                       t7_readB;
  output [BITQPRT-1:0]         t7_addrB;
  input [BITPING-1:0]          t7_doutB;

  output                       t8_writeA;
  output [BITQPRT-1:0]         t8_addrA;
  output [BITPING-1:0]         t8_bwA;
  output [BITPING-1:0]         t8_dinA;
  output                       t8_writeB;
  output [BITQPRT-1:0]         t8_addrB;
  output [BITPING-1:0]         t8_bwB;
  output [BITPING-1:0]         t8_dinB;
  output                       t8_readC;
  output [BITQPRT-1:0]         t8_addrC;
  input [BITPING-1:0]          t8_doutC;
  output                       t8_readD;
  output [BITQPRT-1:0]         t8_addrD;
  input [BITPING-1:0]          t8_doutD;

  output                       t9_writeA;
  output [BITQPRT-1:0]         t9_addrA;
  output [BITQCNT-1:0]         t9_bwA;
  output [BITQCNT-1:0]         t9_dinA;
  output                       t9_writeB;
  output [BITQPRT-1:0]         t9_addrB;
  output [BITQCNT-1:0]         t9_bwB;
  output [BITQCNT-1:0]         t9_dinB;
  output                       t9_writeC;
  output [BITQPRT-1:0]         t9_addrC;
  output [BITQCNT-1:0]         t9_bwC;
  output [BITQCNT-1:0]         t9_dinC;
  output                       t9_readD;
  output [BITQPRT-1:0]         t9_addrD;
  input [BITQCNT-1:0]          t9_doutD;
  output                       t9_readE;
  output [BITQPRT-1:0]         t9_addrE;
  input [BITQCNT-1:0]          t9_doutE;
  output                       t9_readF;
  output [BITQPRT-1:0]         t9_addrF;
  input [BITQCNT-1:0]          t9_doutF;

  output                       t10_writeA;
  output [BITQPRT-1:0]         t10_addrA;
  output [NUMPING*(BITQPTR+BITMDAT)-1:0] t10_bwA;
  output [NUMPING*(BITQPTR+BITMDAT)-1:0] t10_dinA;
  output                       t10_writeB;
  output [BITQPRT-1:0]         t10_addrB;
  output [NUMPING*(BITQPTR+BITMDAT)-1:0] t10_bwB;
  output [NUMPING*(BITQPTR+BITMDAT)-1:0] t10_dinB;
  output                       t10_writeC;
  output [BITQPRT-1:0]         t10_addrC;
  output [NUMPING*(BITQPTR+BITMDAT)-1:0] t10_bwC;
  output [NUMPING*(BITQPTR+BITMDAT)-1:0] t10_dinC;
  output                       t10_readD;
  output [BITQPRT-1:0]         t10_addrD;
  input [NUMPING*(BITQPTR+BITMDAT)-1:0]  t10_doutD;
  output                       t10_readE;
  output [BITQPRT-1:0]         t10_addrE;
  input [NUMPING*(BITQPTR+BITMDAT)-1:0]  t10_doutE;
  output                       t10_readF;
  output [BITQPRT-1:0]         t10_addrF;
  input [NUMPING*(BITQPTR+BITMDAT)-1:0]  t10_doutF;

  output                       t11_writeA;
  output [BITQPRT-1:0]         t11_addrA;
  output [NUMPING*BITQPTR-1:0] t11_bwA;
  output [NUMPING*BITQPTR-1:0] t11_dinA;
  output                       t11_writeB;
  output [BITQPRT-1:0]         t11_addrB;
  output [NUMPING*BITQPTR-1:0] t11_bwB;
  output [NUMPING*BITQPTR-1:0] t11_dinB;
  output                       t11_readC;
  output [BITQPRT-1:0]         t11_addrC;
  input [NUMPING*BITQPTR-1:0]  t11_doutC;
  output                       t11_readD;
  output [BITQPRT-1:0]         t11_addrD;
  input [NUMPING*BITQPTR-1:0]  t11_doutD;

  output [NUMPUPT-1:0]                 t12_writeA;
  output [NUMPUPT*(BITQPTR-1)-1:0]     t12_addrA;
  output [NUMPUPT*T8_WIDTH-1:0]         t12_bwA;
  output [NUMPUPT*T8_WIDTH-1:0]         t12_dinA;
  output [NUMPUPT-1:0]                 t12_readB;
  output [NUMPUPT*(BITQPTR-1)-1:0]     t12_addrB;
  input [NUMPUPT*T8_WIDTH-1:0]          t12_doutB;

  wire [NUMPOPT-1:0]                   t7_writeA_tmp;
  wire [NUMPOPT*BITQPRT-1:0]           t7_addrA_tmp;
  wire [NUMPOPT*BITPING-1:0]           t7_dinA_tmp;
  wire [NUMPOPT-1:0]                   t7_readB_tmp;
  wire [NUMPOPT*BITQPRT-1:0]           t7_addrB_tmp;

  wire [NUMPUPT-1:0]                   t8_writeA_tmp;
  wire [NUMPUPT*BITQPRT-1:0]           t8_addrA_tmp;
  wire [NUMPUPT*BITPING-1:0]           t8_dinA_tmp;
  wire [NUMPUPT-1:0]                   t8_readB_tmp;
  wire [NUMPUPT*BITQPRT-1:0]           t8_addrB_tmp;

  wire [(NUMPOPT+NUMPUPT)-1:0]         t9_writeA_tmp;
  wire [(NUMPOPT+NUMPUPT)*BITQPRT-1:0] t9_addrA_tmp;
  wire [(NUMPOPT+NUMPUPT)*BITQCNT-1:0] t9_dinA_tmp;
  wire [(NUMPOPT+NUMPUPT)-1:0]         t9_readB_tmp;
  wire [(NUMPOPT+NUMPUPT)*BITQPRT-1:0] t9_addrB_tmp;

  wire [(NUMPOPT+NUMPUPT)-1:0]         t10_writeA_tmp;
  wire [(NUMPOPT+NUMPUPT)*BITQPRT-1:0] t10_addrA_tmp;
  wire [(NUMPOPT+NUMPUPT)*NUMPING*(BITQPTR+BITMDAT)-1:0] t10_dinA_tmp;
  wire [(NUMPOPT+NUMPUPT)-1:0]         t10_readB_tmp;
  wire [(NUMPOPT+NUMPUPT)*BITQPRT-1:0] t10_addrB_tmp;

  wire [NUMPUPT-1:0]                   t11_writeA_tmp;
  wire [NUMPUPT*BITQPRT-1:0]           t11_addrA_tmp;
  wire [NUMPUPT*NUMPING*BITQPTR-1:0]   t11_dinA_tmp;
  wire [NUMPUPT-1:0]                   t11_readB_tmp;
  wire [NUMPUPT*BITQPRT-1:0]           t11_addrB_tmp;

  wire [NUMPUPT-1:0]                   t12_writeA_tmp;
  wire [NUMPUPT*(BITQPTR-1)-1:0]       t12_addrA_tmp;
  wire [NUMPUPT*T8_WIDTH-1:0]           t12_dinA_tmp;
  wire [NUMPUPT-1:0]                   t12_readB_tmp;
  wire [NUMPUPT*(BITQPTR-1)-1:0]       t12_addrB_tmp;

  reg                       t7_writeA;
  reg [BITQPRT-1:0]         t7_addrA;
  reg [BITPING-1:0]         t7_dinA;
  reg                       t7_readB;
  reg [BITQPRT-1:0]         t7_addrB;

  reg                       t8_writeA;
  reg [BITQPRT-1:0]         t8_addrA;
  reg [BITPING-1:0]         t8_dinA;
  reg                       t8_writeB;
  reg [BITQPRT-1:0]         t8_addrB;
  reg [BITPING-1:0]         t8_dinB;
  reg                       t8_readC;
  reg [BITQPRT-1:0]         t8_addrC;
  reg                       t8_readD;
  reg [BITQPRT-1:0]         t8_addrD;

  reg                       t9_writeA;
  reg [BITQPRT-1:0]         t9_addrA;
  reg [BITQCNT-1:0]         t9_dinA;
  reg                       t9_writeB;
  reg [BITQPRT-1:0]         t9_addrB;
  reg [BITQCNT-1:0]         t9_dinB;
  reg                       t9_writeC;
  reg [BITQPRT-1:0]         t9_addrC;
  reg [BITQCNT-1:0]         t9_dinC;
  reg                       t9_readD;
  reg [BITQPRT-1:0]         t9_addrD;
  reg                       t9_readE;
  reg [BITQPRT-1:0]         t9_addrE;
  reg                       t9_readF;
  reg [BITQPRT-1:0]         t9_addrF;

  reg                       t10_writeA;
  reg [BITQPRT-1:0]         t10_addrA;
  reg [NUMPING*(BITQPTR+BITMDAT)-1:0] t10_dinA;
  reg                       t10_writeB;
  reg [BITQPRT-1:0]         t10_addrB;
  reg [NUMPING*(BITQPTR+BITMDAT)-1:0] t10_dinB;
  reg                       t10_writeC;
  reg [BITQPRT-1:0]         t10_addrC;
  reg [NUMPING*(BITQPTR+BITMDAT)-1:0] t10_dinC;
  reg                       t10_readD;
  reg [BITQPRT-1:0]         t10_addrD;
  reg                       t10_readE;
  reg [BITQPRT-1:0]         t10_addrE;
  reg                       t10_readF;
  reg [BITQPRT-1:0]         t10_addrF;

  reg                       t11_writeA;
  reg [BITQPRT-1:0]         t11_addrA;
  reg [NUMPING*BITQPTR-1:0] t11_dinA;
  reg                       t11_writeB;
  reg [BITQPRT-1:0]         t11_addrB;
  reg [NUMPING*BITQPTR-1:0] t11_dinB;
  reg                       t11_readC;
  reg [BITQPRT-1:0]         t11_addrC;
  reg                       t11_readD;
  reg [BITQPRT-1:0]         t11_addrD;

  reg [NUMPUPT-1:0]                 t12_writeA;
  reg [NUMPUPT*(BITQPTR-1)-1:0]     t12_addrA;
  reg [NUMPUPT*T8_WIDTH-1:0]         t12_dinA;
  reg [NUMPUPT-1:0]                 t12_readB;
  reg [NUMPUPT*(BITQPTR-1)-1:0]     t12_addrB;

  always @(posedge clk) begin
    t7_writeA <= t7_writeA_tmp;
    t7_addrA <= t7_addrA_tmp;
    t7_dinA <= t7_dinA_tmp;
    t7_readB <= t7_readB_tmp;
    t7_addrB <= t7_addrB_tmp;

    t8_writeA <= t8_writeA_tmp;
    t8_addrA <= t8_addrA_tmp;
    t8_dinA <= t8_dinA_tmp;
    t8_writeB <= t8_writeA_tmp >> 1;
    t8_addrB <= t8_addrA_tmp >> BITQPRT;
    t8_dinB <= t8_dinA_tmp >> BITPING;
    t8_readC <= t8_readB_tmp;
    t8_addrC <= t8_addrB_tmp;
    t8_readD <= t8_readB_tmp >> 1;
    t8_addrD <= t8_addrB_tmp >> BITQPRT;

    t9_writeA <= t9_writeA_tmp;
    t9_addrA <= t9_addrA_tmp;
    t9_dinA <= t9_dinA_tmp;
    t9_writeB <= t9_writeA_tmp >> 1;
    t9_addrB <= t9_addrA_tmp >> BITQPRT;
    t9_dinB <= t9_dinA_tmp >> BITQCNT;
    t9_writeC <= t9_writeA_tmp >> 2;
    t9_addrC <= t9_addrA_tmp >> (2*BITQPRT);
    t9_dinC <= t9_dinA_tmp >> (2*BITQCNT);
    t9_readD <= t9_readB_tmp;
    t9_addrD <= t9_addrB_tmp;
    t9_readE <= t9_readB_tmp >> 1;
    t9_addrE <= t9_addrB_tmp >> BITQPRT;
    t9_readF <= t9_readB_tmp >> 2;
    t9_addrF <= t9_addrB_tmp >> (2*BITQPRT);

    t10_writeA <= t10_writeA_tmp;
    t10_addrA <= t10_addrA_tmp;
    t10_dinA <= t10_dinA_tmp;
    t10_writeB <= t10_writeA_tmp >> 1;
    t10_addrB <= t10_addrA_tmp >> BITQPRT;
    t10_dinB <= t10_dinA_tmp >> (NUMPING*(BITQPTR+BITMDAT));
    t10_writeC <= t10_writeA_tmp >> 2;
    t10_addrC <= t10_addrA_tmp >> (2*BITQPRT);
    t10_dinC <= t10_dinA_tmp >> (2*NUMPING*(BITQPTR+BITMDAT));
    t10_readD <= t10_readB_tmp;
    t10_addrD <= t10_addrB_tmp;
    t10_readE <= t10_readB_tmp >> 1;
    t10_addrE <= t10_addrB_tmp >> BITQPRT;
    t10_readF <= t10_readB_tmp >> 2;
    t10_addrF <= t10_addrB_tmp >> (2*BITQPRT);

    t11_writeA <= t11_writeA_tmp;
    t11_addrA <= t11_addrA_tmp;
    t11_dinA <= t11_dinA_tmp;
    t11_writeB <= t11_writeA_tmp >> 1;
    t11_addrB <= t11_addrA_tmp >> BITQPRT;
    t11_dinB <= t11_dinA_tmp >> (NUMPING*BITQPTR);
    t11_readC <= t11_readB_tmp;
    t11_addrC <= t11_addrB_tmp;
    t11_readD <= t11_readB_tmp >> 1;
    t11_addrD <= t11_addrB_tmp >> (1*BITQPRT);

  end

  wire [T1_T1_NUMVBNK*T1_T1_PHYWDTH-1:0]   t1_bwA = ~0;
  wire [T1_T2_NUMVBNK*T1_T2_PHYWDTH-1:0]   t2_bwA = ~0;
  wire [T1_T3_NUMVBNK*T1_T3_PHYWDTH-1:0]   t3_bwA = ~0;
  wire [T2_T1_NUMVBNK*T2_T1_PHYWDTH-1:0]   t4_bwA = ~0;
  wire [T2_T2_NUMVBNK*T2_T2_PHYWDTH-1:0]   t5_bwA = ~0;
  wire [T2_T3_NUMVBNK*T2_T3_PHYWDTH-1:0]   t6_bwA = ~0;
  wire [BITPING-1:0]               t7_bwA = ~0;
  wire [BITPING-1:0]               t8_bwA = ~0;
  wire [BITPING-1:0]               t8_bwB = ~0;
  wire [BITQCNT-1:0]               t9_bwA = ~0;
  wire [BITQCNT-1:0]               t9_bwB = ~0;
  wire [BITQCNT-1:0]               t9_bwC = ~0;
  wire [NUMPING*(BITQPTR+BITMDAT)-1:0]       t10_bwA = ~0;
  wire [NUMPING*(BITQPTR+BITMDAT)-1:0]       t10_bwB = ~0;
  wire [NUMPING*(BITQPTR+BITMDAT)-1:0]       t10_bwC = ~0;
  wire [NUMPING*BITQPTR-1:0]                 t11_bwA = ~0;
  wire [NUMPING*BITQPTR-1:0]                 t11_bwB = ~0;
  wire [NUMPUPT*T8_WIDTH-1:0]                t12_bwA = ~0;

  wire [NUMPUPT*BITPING-1:0] t8_doutB_tmp = {t8_doutD,t8_doutC};
  wire [(NUMPOPT+NUMPUPT)*BITQCNT-1:0] t9_doutB_tmp = {t9_doutF,t9_doutE,t9_doutD};
  wire [(NUMPOPT+NUMPUPT)*NUMPING*(BITQPTR+BITMDAT)-1:0] t10_doutB_tmp = {t10_doutF,t10_doutE,t10_doutD};
  wire [NUMPUPT*NUMPING*BITQPTR-1:0] t11_doutB_tmp = {t11_doutD,t11_doutC};

  algo_1k2l_a404_top 
		#(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMPOPT (NUMPOPT), .NUMPUPT (NUMPUPT),
          .NUMQPRT (NUMQPRT), .BITQPRT (BITQPRT), .NUMPING (NUMPING), .BITPING (BITPING), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .BITMDAT(BITMDAT),
		  .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .NUMPBNK(NUMPBNK), .BITPBNK(BITPBNK),
          .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS), .NUMSROW(NUMSROW), .BITSROW(BITSROW),
          .QPTR_WIDTH(T1_T1_WIDTH), .DATA_WIDTH(T2_T1_WIDTH),
          .QPTR_DELAY(QPTR_DELAY+1), .LINK_DELAY(LINK_DELAY), .DATA_DELAY(DATA_DELAY), .FLOPIN(FLOPIN), .FLOPMEM(FLOPMEM), .FLOPOUT(FLOPOUT), .FLOPECC(FLOPECC),
          .T1_T1_WIDTH(T1_T1_WIDTH), .T1_T1_NUMVBNK(T1_T1_NUMVBNK), .T1_T1_BITVBNK(T1_T1_BITVBNK),
          .T1_T1_DELAY(T1_T1_DELAY), .T1_T1_NUMVROW(T1_T1_NUMVROW), .T1_T1_BITVROW(T1_T1_BITVROW),
          .T1_T1_BITWSPF(T1_T1_BITWSPF), .T1_T1_NUMWRDS(T1_T1_NUMWRDS), .T1_T1_BITWRDS(T1_T1_BITWRDS),
          .T1_T1_NUMSROW(T1_T1_NUMSROW), .T1_T1_BITSROW(T1_T1_BITSROW), .T1_T1_PHYWDTH(T1_T1_PHYWDTH),
          .T1_T2_WIDTH(T1_T2_WIDTH), .T1_T2_NUMVBNK(T1_T2_NUMVBNK), .T1_T2_BITVBNK(T1_T2_BITVBNK),
          .T1_T2_DELAY(T1_T2_DELAY), .T1_T2_NUMVROW(T1_T2_NUMVROW), .T1_T2_BITVROW(T1_T2_BITVROW),
          .T1_T2_BITWSPF(T1_T2_BITWSPF), .T1_T2_NUMWRDS(T1_T2_NUMWRDS), .T1_T2_BITWRDS(T1_T2_BITWRDS),
          .T1_T2_NUMSROW(T1_T2_NUMSROW), .T1_T2_BITSROW(T1_T2_BITSROW), .T1_T2_PHYWDTH(T1_T2_PHYWDTH),
          .T1_T3_WIDTH(T1_T3_WIDTH), .T1_T3_NUMVBNK(T1_T3_NUMVBNK), .T1_T3_BITVBNK(T1_T3_BITVBNK),
          .T1_T3_DELAY(T1_T3_DELAY), .T1_T3_NUMVROW(T1_T3_NUMVROW), .T1_T3_BITVROW(T1_T3_BITVROW),
          .T1_T3_BITWSPF(T1_T3_BITWSPF), .T1_T3_NUMWRDS(T1_T3_NUMWRDS), .T1_T3_BITWRDS(T1_T3_BITWRDS),
          .T1_T3_NUMSROW(T1_T3_NUMSROW), .T1_T3_BITSROW(T1_T3_BITSROW), .T1_T3_PHYWDTH(T1_T3_PHYWDTH),
          .T2_T1_WIDTH(T2_T1_WIDTH), .T2_T1_NUMVBNK(T2_T1_NUMVBNK), .T2_T1_BITVBNK(T2_T1_BITVBNK),
          .T2_T1_DELAY(T2_T1_DELAY), .T2_T1_NUMVROW(T2_T1_NUMVROW), .T2_T1_BITVROW(T2_T1_BITVROW),
          .T2_T1_BITWSPF(T2_T1_BITWSPF), .T2_T1_NUMWRDS(T2_T1_NUMWRDS), .T2_T1_BITWRDS(T2_T1_BITWRDS),
          .T2_T1_NUMSROW(T2_T1_NUMSROW), .T2_T1_BITSROW(T2_T1_BITSROW), .T2_T1_PHYWDTH(T2_T1_PHYWDTH),
          .T2_T2_WIDTH(T2_T2_WIDTH), .T2_T2_NUMVBNK(T2_T2_NUMVBNK), .T2_T2_BITVBNK(T2_T2_BITVBNK),
          .T2_T2_DELAY(T2_T2_DELAY), .T2_T2_NUMVROW(T2_T2_NUMVROW), .T2_T2_BITVROW(T2_T2_BITVROW),
          .T2_T2_BITWSPF(T2_T2_BITWSPF), .T2_T2_NUMWRDS(T2_T2_NUMWRDS), .T2_T2_BITWRDS(T2_T2_BITWRDS),
          .T2_T2_NUMSROW(T2_T2_NUMSROW), .T2_T2_BITSROW(T2_T2_BITSROW), .T2_T2_PHYWDTH(T2_T2_PHYWDTH),
          .T2_T3_WIDTH(T2_T3_WIDTH), .T2_T3_NUMVBNK(T2_T3_NUMVBNK), .T2_T3_BITVBNK(T2_T3_BITVBNK),
          .T2_T3_DELAY(T2_T3_DELAY), .T2_T3_NUMVROW(T2_T3_NUMVROW), .T2_T3_BITVROW(T2_T3_BITVROW),
          .T2_T3_BITWSPF(T2_T3_BITWSPF), .T2_T3_NUMWRDS(T2_T3_NUMWRDS), .T2_T3_BITWRDS(T2_T3_BITWRDS),
          .T2_T3_NUMSROW(T2_T3_NUMSROW), .T2_T3_BITSROW(T2_T3_BITSROW), .T2_T3_PHYWDTH(T2_T3_PHYWDTH),
          .T8_WIDTH(T8_WIDTH), .T8_NUMVBNK(T8_NUMVBNK), .T8_BITVBNK(T8_BITVBNK), .T8_DELAY(T8_DELAY), .T8_NUMVROW(T8_NUMVROW), .T8_BITVROW(T8_BITVROW),
          .T8_NUMWRDS(T8_NUMWRDS), .T8_BITWRDS(T8_BITWRDS), .T8_NUMSROW(T8_NUMSROW), .T8_BITSROW(T8_BITSROW), .T8_PHYWDTH(T8_PHYWDTH))
    algo_top
		(.clk(clk), .rst(rst), .ready(ready),
		 .push(push), .pu_prt(pu_prt), .pu_metadata(pu_metadata), .pu_din(pu_din),
		 .pop(pop), .po_prt(po_prt), .po_metadata(po_metadata), .po_dvld(po_dvld), .po_dout(po_dout),
         .freecnt(freecnt),
         .cp_read(1'b0), .cp_write(1'b0), .cp_adr({BITCPAD{1'b0}}), .cp_din({CPUWDTH{1'b0}}), .cp_vld(), .cp_dout(),
		 .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
		 .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
		 .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB),
		 .t4_writeA(t4_writeA), .t4_addrA(t4_addrA), .t4_dinA(t4_dinA), .t4_readB(t4_readB), .t4_addrB(t4_addrB), .t4_doutB(t4_doutB),
		 .t5_writeA(t5_writeA), .t5_addrA(t5_addrA), .t5_dinA(t5_dinA), .t5_readB(t5_readB), .t5_addrB(t5_addrB), .t5_doutB(t5_doutB),
		 .t6_writeA(t6_writeA), .t6_addrA(t6_addrA), .t6_dinA(t6_dinA), .t6_readB(t6_readB), .t6_addrB(t6_addrB), .t6_doutB(t6_doutB),
		 .t7_writeA(t7_writeA_tmp), .t7_addrA(t7_addrA_tmp), .t7_dinA(t7_dinA_tmp), .t7_readB(t7_readB_tmp), .t7_addrB(t7_addrB_tmp), .t7_doutB(t7_doutB),
		 .t8_writeA(t8_writeA_tmp), .t8_addrA(t8_addrA_tmp), .t8_dinA(t8_dinA_tmp), .t8_readB(t8_readB_tmp), .t8_addrB(t8_addrB_tmp), .t8_doutB(t8_doutB_tmp),
		 .t9_writeA(t9_writeA_tmp), .t9_addrA(t9_addrA_tmp), .t9_dinA(t9_dinA_tmp), .t9_readB(t9_readB_tmp), .t9_addrB(t9_addrB_tmp), .t9_doutB(t9_doutB_tmp),
		 .t10_writeA(t10_writeA_tmp), .t10_addrA(t10_addrA_tmp), .t10_dinA(t10_dinA_tmp), .t10_readB(t10_readB_tmp), .t10_addrB(t10_addrB_tmp), .t10_doutB(t10_doutB_tmp),
		 .t11_writeA(t11_writeA_tmp), .t11_addrA(t11_addrA_tmp), .t11_dinA(t11_dinA_tmp), .t11_readB(t11_readB_tmp), .t11_addrB(t11_addrB_tmp), .t11_doutB(t11_doutB_tmp),
		 .t12_writeA(t12_writeA), .t12_addrA(t12_addrA), .t12_dinA(t12_dinA), .t12_readB(t12_readB), .t12_addrB(t12_addrB), .t12_doutB(t12_doutB));

endmodule    //algo_1k2l_a404_top_wrap
