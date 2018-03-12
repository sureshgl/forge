/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.UNKNOWN Date: Wed 2012.11.21 at 01:59:18 PM IST
 * */

module algo_1r1w_a416_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 9216, parameter IP_BITADDR = 14, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 1, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,
parameter IP_NUMQPRT = 9248, parameter IP_BITQPRT = 14, parameter IP_NUMPING = 4, parameter IP_BITPING = 2,

parameter T1_WIDTH = 20, parameter T1_ECCWDTH = 6, parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 0, parameter T1_DELAY = 2, parameter T1_NUMVROW = 9216, parameter T1_BITVROW = 14,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 0, parameter T1_NUMSROW = 9216, parameter T1_BITSROW = 14, parameter T1_PHYWDTH = 20,
parameter T2_WIDTH = 39, parameter T2_ECCWDTH = 7, parameter T2_NUMVBNK = 1, parameter T2_BITVBNK = 0, parameter T2_DELAY = 2, parameter T2_NUMVROW = 9216, parameter T2_BITVROW = 14,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 9216, parameter T2_BITSROW = 14, parameter T2_PHYWDTH = 39,
parameter T3_WIDTH = 13, parameter T3_NUMVBNK = 1, parameter T3_BITVBNK = 0, parameter T3_DELAY = 2, parameter T3_NUMVROW = 2312, parameter T3_BITVROW = 12,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 4, parameter T3_BITWRDS = 2, parameter T3_NUMSROW = 2312, parameter T3_BITSROW = 12, parameter T3_PHYWDTH = 13,
parameter T4_WIDTH = 13, parameter T4_NUMVBNK = 1, parameter T4_BITVBNK = 0, parameter T4_DELAY = 2, parameter T4_NUMVROW = 2312, parameter T4_BITVROW = 12,
parameter T4_BITWSPF = 0, parameter T4_NUMWRDS = 4, parameter T4_BITWRDS = 2, parameter T4_NUMSROW = 2312, parameter T4_BITSROW = 12, parameter T4_PHYWDTH = 13,
parameter T5_WIDTH = 21, parameter T5_NUMVBNK = 10, parameter T5_BITVBNK = 4, parameter T5_DELAY = 2, parameter T5_NUMVROW = 1852, parameter T5_BITVROW = 11,
parameter T5_BITWSPF = 0, parameter T5_NUMWRDS = 1, parameter T5_BITWRDS = 0, parameter T5_NUMSROW = 1852, parameter T5_BITSROW = 11, parameter T5_PHYWDTH = 21,
parameter T6_WIDTH = 21, parameter T6_NUMVBNK = 2, parameter T6_BITVBNK = 1, parameter T6_DELAY = 2, parameter T6_NUMVROW = 1852, parameter T6_BITVROW = 11,
parameter T6_BITWSPF = 0, parameter T6_NUMWRDS = 1, parameter T6_BITWRDS = 0, parameter T6_NUMSROW = 4096, parameter T6_BITSROW = 11, parameter T6_PHYWDTH = 21,
parameter T7_WIDTH = 12, parameter T7_NUMVBNK = 2, parameter T7_BITVBNK = 1, parameter T7_DELAY = 2, parameter T7_NUMVROW = 1852, parameter T7_BITVROW = 11,
parameter T7_BITWSPF = 0, parameter T7_NUMWRDS = 1, parameter T7_BITWRDS = 0, parameter T7_NUMSROW = 1852, parameter T7_BITSROW = 11, parameter T7_PHYWDTH = 12,
parameter T8_WIDTH = 63, parameter T8_NUMVBNK = 10, parameter T8_BITVBNK = 4, parameter T8_DELAY = 2, parameter T8_NUMVROW = 1852, parameter T8_BITVROW = 11,
parameter T8_BITWSPF = 0, parameter T8_NUMWRDS = 1, parameter T8_BITWRDS = 0, parameter T8_NUMSROW = 1852, parameter T8_BITSROW = 11, parameter T8_PHYWDTH = 63,
parameter T9_WIDTH = 63, parameter T9_NUMVBNK = 2, parameter T9_BITVBNK = 1, parameter T9_DELAY = 2, parameter T9_NUMVROW = 1852, parameter T9_BITVROW = 11,
parameter T9_BITWSPF = 0, parameter T9_NUMWRDS = 1, parameter T9_BITWRDS = 0, parameter T9_NUMSROW = 1852, parameter T9_BITSROW = 11, parameter T9_PHYWDTH = 63,
parameter T10_WIDTH = 12, parameter T10_NUMVBNK = 2, parameter T10_BITVBNK = 1, parameter T10_DELAY = 2, parameter T10_NUMVROW = 1852, parameter T10_BITVROW = 11,
parameter T10_BITWSPF = 0, parameter T10_NUMWRDS = 1, parameter T10_BITWRDS = 0, parameter T10_NUMSROW = 1852, parameter T10_BITSROW = 11, parameter T10_PHYWDTH = 12,
parameter T11_WIDTH = 63, parameter T11_NUMVBNK = 1, parameter T11_BITVBNK = 0, parameter T11_DELAY = 2, parameter T11_NUMVROW = 9216, parameter T11_BITVROW = 14,
parameter T11_BITWSPF = 0, parameter T11_NUMWRDS = 1, parameter T11_BITWRDS = 0, parameter T11_NUMSROW = 9216, parameter T11_BITSROW = 14, parameter T11_PHYWDTH = 63)
( clk, rst, ready,
  push, pu_owr, pu_prt, pu_ptr, pu_din, pu_cvld, pu_cnt, pu_cserr, pu_cderr,
  pop, po_ndq, po_prt, po_cvld, po_cmt, po_cnt, po_pvld, po_ptr, po_dvld, po_dout, po_cserr, po_cderr, po_pserr, po_pderr, po_dserr, po_dderr,
  cp_read, cp_write, cp_adr, cp_din, cp_vld, cp_dout,
  t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_padrB, t1_serrB, t1_derrB,
  t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_padrB, t2_serrB, t2_derrB,
  t3_writeA, t3_addrA, t3_bwA, t3_dinA, t3_readB, t3_addrB, t3_doutB, t3_padrB, t3_serrB, t3_derrB,
  t4_writeA, t4_addrA, t4_bwA, t4_dinA, t4_readB, t4_addrB, t4_doutB, t4_padrB, t4_serrB, t4_derrB,
  t5_writeA, t5_addrA, t5_bwA, t5_dinA, t5_readB, t5_addrB, t5_doutB, t5_padrB, t5_serrB, t5_derrB,
  t6_writeA, t6_addrA, t6_bwA, t6_dinA, t6_readB, t6_addrB, t6_doutB, t6_padrB, t6_serrB, t6_derrB,
  t7_writeA, t7_addrA, t7_bwA, t7_dinA, t7_readB, t7_addrB, t7_doutB, t7_padrB, t7_serrB, t7_derrB,
  t8_writeA, t8_addrA, t8_bwA, t8_dinA, t8_readB, t8_addrB, t8_doutB, t8_padrB, t8_serrB, t8_derrB,
  t9_writeA, t9_addrA, t9_bwA, t9_dinA, t9_readB, t9_addrB, t9_doutB, t9_padrB, t9_serrB, t9_derrB,
  t10_writeA, t10_addrA, t10_bwA, t10_dinA, t10_readB, t10_addrB, t10_doutB, t10_padrB, t10_serrB, t10_derrB,
  t11_writeA, t11_addrA, t11_bwA, t11_dinA, t11_readB, t11_addrB, t11_doutB, t11_padrB, t11_serrB, t11_derrB);
  
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
  parameter QPTR_WIDTH = T1_PHYWDTH;
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;
  parameter POPTR_WIDTH = T3_PHYWDTH;
  parameter PUPTR_WIDTH = T4_PHYWDTH;

  parameter CNTD_WIDTH   = T5_WIDTH;
  parameter CNTD_NUMVBNK = T5_NUMVBNK;
  parameter CNTD_BITVBNK = T5_BITVBNK;
  parameter CNTD_DELAY   = T5_DELAY;
  parameter CNTD_NUMVROW = T5_NUMVROW;
  parameter CNTD_BITVROW = T5_BITVROW;
  parameter CNTD_BITWSPF = T5_BITWSPF;
  parameter CNTD_NUMWRDS = T5_NUMWRDS;
  parameter CNTD_BITWRDS = T5_BITWRDS;
  parameter CNTD_NUMSROW = T5_NUMSROW;
  parameter CNTD_BITSROW = T5_BITSROW;
  parameter CNTD_PHYWDTH = T5_PHYWDTH;

  parameter CNTC_WIDTH   = T6_WIDTH;
  parameter CNTC_NUMVBNK = T6_NUMVBNK;
  parameter CNTC_BITVBNK = T6_BITVBNK;
  parameter CNTC_DELAY   = T6_DELAY;
  parameter CNTC_NUMVROW = T6_NUMVROW;
  parameter CNTC_BITVROW = T6_BITVROW;
  parameter CNTC_BITWSPF = T6_BITWSPF;
  parameter CNTC_NUMWRDS = T6_NUMWRDS;
  parameter CNTC_BITWRDS = T6_BITWRDS;
  parameter CNTC_NUMSROW = T6_NUMSROW;
  parameter CNTC_BITSROW = T6_BITSROW;
  parameter CNTC_PHYWDTH = T6_PHYWDTH;

  parameter CNTS_WIDTH   = T7_WIDTH;
  parameter CNTS_NUMVBNK = T7_NUMVBNK;
  parameter CNTS_BITVBNK = T7_BITVBNK;
  parameter CNTS_DELAY   = T7_DELAY;
  parameter CNTS_NUMVROW = T7_NUMVROW;
  parameter CNTS_BITVROW = T7_BITVROW;
  parameter CNTS_BITWSPF = T7_BITWSPF;
  parameter CNTS_NUMWRDS = T7_NUMWRDS;
  parameter CNTS_BITWRDS = T7_BITWRDS;
  parameter CNTS_NUMSROW = T7_NUMSROW;
  parameter CNTS_BITSROW = T7_BITSROW;
  parameter CNTS_PHYWDTH = T7_PHYWDTH;

  parameter HEADD_WIDTH   = T8_WIDTH;
  parameter HEADD_NUMVBNK = T8_NUMVBNK;
  parameter HEADD_BITVBNK = T8_BITVBNK;
  parameter HEADD_DELAY   = T8_DELAY;
  parameter HEADD_NUMVROW = T8_NUMVROW;
  parameter HEADD_BITVROW = T8_BITVROW;
  parameter HEADD_BITWSPF = T8_BITWSPF;
  parameter HEADD_NUMWRDS = T8_NUMWRDS;
  parameter HEADD_BITWRDS = T8_BITWRDS;
  parameter HEADD_NUMSROW = T8_NUMSROW;
  parameter HEADD_BITSROW = T8_BITSROW;
  parameter HEADD_PHYWDTH = T8_PHYWDTH;

  parameter HEADC_WIDTH   = T9_WIDTH;
  parameter HEADC_NUMVBNK = T9_NUMVBNK;
  parameter HEADC_BITVBNK = T9_BITVBNK;
  parameter HEADC_DELAY   = T9_DELAY;
  parameter HEADC_NUMVROW = T9_NUMVROW;
  parameter HEADC_BITVROW = T9_BITVROW;
  parameter HEADC_BITWSPF = T9_BITWSPF;
  parameter HEADC_NUMWRDS = T9_NUMWRDS;
  parameter HEADC_BITWRDS = T9_BITWRDS;
  parameter HEADC_NUMSROW = T9_NUMSROW;
  parameter HEADC_BITSROW = T9_BITSROW;
  parameter HEADC_PHYWDTH = T9_PHYWDTH;

  parameter HEADS_WIDTH   = T10_WIDTH;
  parameter HEADS_NUMVBNK = T10_NUMVBNK;
  parameter HEADS_BITVBNK = T10_BITVBNK;
  parameter HEADS_DELAY   = T10_DELAY;
  parameter HEADS_NUMVROW = T10_NUMVROW;
  parameter HEADS_BITVROW = T10_BITVROW;
  parameter HEADS_BITWSPF = T10_BITWSPF;
  parameter HEADS_NUMWRDS = T10_NUMWRDS;
  parameter HEADS_BITWRDS = T10_BITWRDS;
  parameter HEADS_NUMSROW = T10_NUMSROW;
  parameter HEADS_BITSROW = T10_BITSROW;
  parameter HEADS_PHYWDTH = T10_PHYWDTH;

  parameter TAIL_WIDTH   = T11_WIDTH;
  parameter TAIL_NUMVBNK = T11_NUMVBNK;
  parameter TAIL_BITVBNK = T11_BITVBNK;
  parameter TAIL_DELAY   = T11_DELAY;
  parameter TAIL_NUMVROW = T11_NUMVROW;
  parameter TAIL_BITVROW = T11_BITVROW;
  parameter TAIL_BITWSPF = T11_BITWSPF;
  parameter TAIL_NUMWRDS = T11_NUMWRDS;
  parameter TAIL_BITWRDS = T11_BITWRDS;
  parameter TAIL_NUMSROW = T11_NUMSROW;
  parameter TAIL_BITSROW = T11_BITSROW;
  parameter TAIL_PHYWDTH = T11_PHYWDTH;

  parameter DATA_WIDTH = T2_PHYWDTH;
  parameter ECC_WIDTH = T2_ECCWDTH;

  parameter BITCPAD = BITQPRT;
  parameter CPUWDTH = 2*BITPING+BITQCNT+2*NUMPING*BITQPTR;

  input [NUMPUPT-1:0]                      push;
  input [NUMPUPT-1:0]                      pu_owr;
  input [NUMPUPT*BITQPRT-1:0]              pu_prt;
  input [NUMPUPT*BITQPTR-1:0]              pu_ptr;
  input [NUMPUPT*WIDTH-1:0]                pu_din;
  output [NUMPUPT-1:0]                     pu_cvld;
  output [NUMPUPT*BITQCNT-1:0]             pu_cnt;
  output [NUMPUPT-1:0]                     pu_cserr;
  output [NUMPUPT-1:0]                     pu_cderr;

  input [NUMPOPT-1:0]                      pop;
  input [NUMPOPT-1:0]                      po_ndq;
  input [NUMPOPT*BITQPRT-1:0]              po_prt;
  output [NUMPOPT-1:0]                     po_cvld;
  output [NUMPOPT-1:0]                     po_cmt;
  output [NUMPOPT*BITQCNT-1:0]             po_cnt;
  output [NUMPOPT-1:0]                     po_pvld;
  output [NUMPOPT*BITQPTR-1:0]             po_ptr;
  output [NUMPOPT-1:0]                     po_dvld;
  output [NUMPOPT*WIDTH-1:0]               po_dout;
  output [NUMPOPT-1:0]                     po_cserr;
  output [NUMPOPT-1:0]                     po_cderr;
  output [NUMPOPT-1:0]                     po_pserr;
  output [NUMPOPT-1:0]                     po_pderr;
  output [NUMPOPT-1:0]                     po_dserr;
  output [NUMPOPT-1:0]                     po_dderr;

  input                                    cp_read;
  input                                    cp_write;
  input [BITCPAD-1:0]                      cp_adr;
  input [CPUWDTH-1:0]                      cp_din;
  output                                   cp_vld;
  output [CPUWDTH-1:0]                     cp_dout;

  output                                   ready;
  input                                    clk, rst;

  output [NUMPUPT-1:0]                     t1_writeA;
  output [NUMPUPT*BITADDR-1:0]             t1_addrA;
  output [NUMPUPT*QPTR_WIDTH-1:0]          t1_bwA;
  output [NUMPUPT*QPTR_WIDTH-1:0]          t1_dinA;
  output [NUMPOPT-1:0]                     t1_readB;
  output [NUMPOPT*BITADDR-1:0]             t1_addrB;
  input [NUMPOPT*QPTR_WIDTH-1:0]           t1_doutB;

  output [NUMPUPT-1:0]                     t2_writeA;
  output [NUMPUPT*BITADDR-1:0]             t2_addrA;
  output [NUMPUPT*DATA_WIDTH-1:0]          t2_bwA;
  output [NUMPUPT*DATA_WIDTH-1:0]          t2_dinA;
  output [NUMPOPT-1:0]                     t2_readB;
  output [NUMPOPT*BITADDR-1:0]             t2_addrB;
  input [NUMPOPT*DATA_WIDTH-1:0]           t2_doutB;

  output [T3_NUMVBNK-1:0]                  t3_writeA;
  output [T3_NUMVBNK*T3_BITVROW-1:0]       t3_addrA;
  output [T3_NUMVBNK*T3_WIDTH-1:0]         t3_bwA;
  output [T3_NUMVBNK*T3_WIDTH-1:0]         t3_dinA;
  output [T3_NUMVBNK-1:0]                  t3_readB;
  output [T3_NUMVBNK*T3_BITVROW-1:0]       t3_addrB;
  input [T3_NUMVBNK*T3_WIDTH-1:0]          t3_doutB;

  output [T4_NUMVBNK-1:0]                  t4_writeA;
  output [T4_NUMVBNK*T4_BITVROW-1:0]       t4_addrA;
  output [T4_NUMVBNK*T4_WIDTH-1:0]         t4_bwA;
  output [T4_NUMVBNK*T4_WIDTH-1:0]         t4_dinA;
  output [T4_NUMVBNK-1:0]                  t4_readB;
  output [T4_NUMVBNK*T4_BITVROW-1:0]       t4_addrB;
  input [T4_NUMVBNK*T4_WIDTH-1:0]          t4_doutB;

  output [CNTD_NUMVBNK-1:0]                t5_writeA;
  output [CNTD_NUMVBNK*CNTD_BITVROW-1:0]   t5_addrA;
  output [CNTD_NUMVBNK*CNTD_WIDTH-1:0]     t5_bwA;
  output [CNTD_NUMVBNK*CNTD_WIDTH-1:0]     t5_dinA;
  output [CNTD_NUMVBNK-1:0]                t5_readB;
  output [CNTD_NUMVBNK*CNTD_BITVROW-1:0]   t5_addrB;
  input  [CNTD_NUMVBNK*CNTD_WIDTH-1:0]     t5_doutB;

  output [CNTC_NUMVBNK-1:0]                t6_writeA;
  output [CNTC_NUMVBNK*CNTC_BITVROW-1:0]   t6_addrA;
  output [CNTC_NUMVBNK*CNTC_WIDTH-1:0]     t6_bwA;
  output [CNTC_NUMVBNK*CNTC_WIDTH-1:0]     t6_dinA;
  output [CNTC_NUMVBNK-1:0]                t6_readB;
  output [CNTC_NUMVBNK*CNTC_BITVROW-1:0]   t6_addrB;
  input  [CNTC_NUMVBNK*CNTC_WIDTH-1:0]     t6_doutB;

  output [CNTS_NUMVBNK-1:0]                t7_writeA;
  output [CNTS_NUMVBNK*CNTS_BITVROW-1:0]   t7_addrA;
  output [CNTS_NUMVBNK*CNTS_WIDTH-1:0]     t7_bwA;
  output [CNTS_NUMVBNK*CNTS_WIDTH-1:0]     t7_dinA;
  output [CNTS_NUMVBNK-1:0]                t7_readB;
  output [CNTS_NUMVBNK*CNTS_BITVROW-1:0]   t7_addrB;
  input [CNTS_NUMVBNK*CNTS_WIDTH-1:0]      t7_doutB;

  output [HEADD_NUMVBNK-1:0]               t8_writeA;
  output [HEADD_NUMVBNK*HEADD_BITVROW-1:0] t8_addrA;
  output [HEADD_NUMVBNK*HEADD_WIDTH-1:0]   t8_bwA;
  output [HEADD_NUMVBNK*HEADD_WIDTH-1:0]   t8_dinA;
  output [HEADD_NUMVBNK-1:0]               t8_readB;
  output [HEADD_NUMVBNK*HEADD_BITVROW-1:0] t8_addrB;
  input  [HEADD_NUMVBNK*HEADD_WIDTH-1:0]   t8_doutB;

  output [HEADC_NUMVBNK-1:0]               t9_writeA;
  output [HEADC_NUMVBNK*HEADC_BITVROW-1:0] t9_addrA;
  output [HEADC_NUMVBNK*HEADC_WIDTH-1:0]   t9_bwA;
  output [HEADC_NUMVBNK*HEADC_WIDTH-1:0]   t9_dinA;
  output [HEADC_NUMVBNK-1:0]               t9_readB;
  output [HEADC_NUMVBNK*HEADC_BITVROW-1:0] t9_addrB;
  input  [HEADC_NUMVBNK*HEADC_WIDTH-1:0]   t9_doutB;

  output [HEADS_NUMVBNK-1:0]               t10_writeA;
  output [HEADS_NUMVBNK*HEADS_BITVROW-1:0] t10_addrA;
  output [HEADS_NUMVBNK*HEADS_WIDTH-1:0]   t10_bwA;
  output [HEADS_NUMVBNK*HEADS_WIDTH-1:0]   t10_dinA;
  output [HEADS_NUMVBNK-1:0]               t10_readB;
  output [HEADS_NUMVBNK*HEADS_BITVROW-1:0] t10_addrB;
  input  [HEADS_NUMVBNK*HEADS_WIDTH-1:0]   t10_doutB;

  output [NUMPUPT-1:0]                     t11_writeA;
  output [NUMPUPT*BITQPRT-1:0]             t11_addrA;
  output [NUMPUPT*TAIL_WIDTH-1:0]          t11_bwA;
  output [NUMPUPT*TAIL_WIDTH-1:0]          t11_dinA;
  output [NUMPUPT-1:0]                     t11_readB;
  output [NUMPUPT*BITQPRT-1:0]             t11_addrB;
  input [NUMPUPT*TAIL_WIDTH-1:0]           t11_doutB;

  output [NUMPOPT-1:0]                     t1_serrB;
  output [NUMPOPT-1:0]                     t1_derrB;
  output [NUMPOPT*BITADDR-1:0]             t1_padrB;
  output [NUMPOPT-1:0]                     t2_serrB;
  output [NUMPOPT-1:0]                     t2_derrB;
  output [NUMPOPT*BITADDR-1:0]             t2_padrB;
  output [NUMPOPT-1:0]                     t3_serrB;
  output [NUMPOPT-1:0]                     t3_derrB;
  output [NUMPOPT*(BITQPRT-2)-1:0]         t3_padrB;
  output [NUMPUPT-1:0]                     t4_serrB;
  output [NUMPUPT-1:0]                     t4_derrB;
  output [NUMPUPT*(BITQPRT-2)-1:0]         t4_padrB;
  output [CNTD_NUMVBNK-1:0]                t5_serrB;
  output [CNTD_NUMVBNK-1:0]                t5_derrB;
  output [CNTD_NUMVBNK*CNTD_BITSROW-1:0]   t5_padrB;
  output [CNTC_NUMVBNK-1:0]                t6_serrB;
  output [CNTC_NUMVBNK-1:0]                t6_derrB;
  output [CNTC_NUMVBNK*CNTC_BITSROW-1:0]   t6_padrB;
  output [CNTS_NUMVBNK-1:0]                t7_serrB;
  output [CNTS_NUMVBNK-1:0]                t7_derrB;
  output [CNTS_NUMVBNK*CNTS_BITSROW-1:0]   t7_padrB;
  output [HEADD_NUMVBNK-1:0]               t8_serrB;
  output [HEADD_NUMVBNK-1:0]               t8_derrB;
  output [HEADD_NUMVBNK*CNTS_BITSROW-1:0]  t8_padrB;
  output [HEADC_NUMVBNK-1:0]               t9_serrB;
  output [HEADC_NUMVBNK-1:0]               t9_derrB;
  output [HEADC_NUMVBNK*CNTS_BITSROW-1:0]  t9_padrB;
  output [HEADS_NUMVBNK-1:0]               t10_serrB;
  output [HEADS_NUMVBNK-1:0]               t10_derrB;
  output [HEADS_NUMVBNK*CNTS_BITSROW-1:0]  t10_padrB;
  output [NUMPUPT-1:0]                     t11_serrB;
  output [NUMPUPT-1:0]                     t11_derrB;
  output [NUMPUPT*BITQPRT-1:0]             t11_padrB;

  wire [NUMPUPT*QPTR_WIDTH-1:0]            t1_bwA = ~0;
  wire [NUMPUPT*DATA_WIDTH-1:0]            t2_bwA = ~0;
  wire [T3_NUMVBNK*T3_WIDTH-1:0]           t3_bwA = ~0;
  wire [T4_NUMVBNK*T4_WIDTH-1:0]           t4_bwA = ~0;
  wire [CNTD_NUMVBNK*CNTD_WIDTH-1:0]       t5_bwA = ~0;
  wire [CNTC_NUMVBNK*CNTC_WIDTH-1:0]       t6_bwA = ~0;
  wire [CNTS_NUMVBNK*CNTS_WIDTH-1:0]       t7_bwA = ~0;
  wire [HEADD_NUMVBNK*HEADD_WIDTH-1:0]     t8_bwA = ~0;
  wire [HEADC_NUMVBNK*HEADC_WIDTH-1:0]     t9_bwA = ~0;
  wire [HEADS_NUMVBNK*HEADS_WIDTH-1:0]     t10_bwA = ~0;
  wire [NUMPUPT*TAIL_WIDTH-1:0]            t11_bwA = ~0;

  algo_mrnw_pque_f32_top 
		#(.WIDTH (WIDTH), .DATA_WIDTH(DATA_WIDTH), .BITWDTH (BITWDTH), .NUMPOPT (NUMPOPT), .NUMPUPT (NUMPUPT),
          .NUMQPRT (NUMQPRT), .BITQPRT (BITQPRT), .QPTR_WIDTH(QPTR_WIDTH), .NUMPING (NUMPING), .BITPING (BITPING), .NUMADDR(NUMADDR), .BITADDR(BITADDR),
		  .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .NUMPBNK(NUMPBNK), .BITPBNK(BITPBNK),
          .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS), .NUMSROW(NUMSROW), .BITSROW(BITSROW),
          .POPTR_WIDTH(POPTR_WIDTH), .PUPTR_WIDTH(PUPTR_WIDTH),
          .CNTD_WIDTH(CNTD_WIDTH), .CNTD_NUMVBNK(CNTD_NUMVBNK), .CNTD_BITVBNK(CNTD_BITVBNK), .CNTD_DELAY(CNTD_DELAY),
          .CNTD_NUMVROW(CNTD_NUMVROW), .CNTD_BITVROW(CNTD_BITVROW), .CNTD_BITWSPF(CNTD_BITWSPF), .CNTD_NUMWRDS(CNTD_NUMWRDS),
          .CNTD_BITWRDS(CNTD_BITWRDS), .CNTD_NUMSROW(CNTD_NUMSROW), .CNTD_BITSROW(CNTD_BITSROW), .CNTD_PHYWDTH(CNTD_PHYWDTH),
          .CNTC_WIDTH(CNTC_WIDTH), .CNTC_NUMVBNK(CNTC_NUMVBNK), .CNTC_BITVBNK(CNTC_BITVBNK), .CNTC_DELAY(CNTC_DELAY),
          .CNTC_NUMVROW(CNTC_NUMVROW), .CNTC_BITVROW(CNTC_BITVROW), .CNTC_BITWSPF(CNTC_BITWSPF), .CNTC_NUMWRDS(CNTC_NUMWRDS),
          .CNTC_BITWRDS(CNTC_BITWRDS), .CNTC_NUMSROW(CNTC_NUMSROW), .CNTC_BITSROW(CNTC_BITSROW), .CNTC_PHYWDTH(CNTC_PHYWDTH),
          .CNTS_WIDTH(CNTS_WIDTH), .CNTS_NUMVBNK(CNTS_NUMVBNK), .CNTS_BITVBNK(CNTS_BITVBNK), .CNTS_DELAY(CNTS_DELAY),
          .CNTS_NUMVROW(CNTS_NUMVROW), .CNTS_BITVROW(CNTS_BITVROW), .CNTS_BITWSPF(CNTS_BITWSPF), .CNTS_NUMWRDS(CNTS_NUMWRDS),
          .CNTS_BITWRDS(CNTS_BITWRDS), .CNTS_NUMSROW(CNTS_NUMSROW), .CNTS_BITSROW(CNTS_BITSROW), .CNTS_PHYWDTH(CNTS_PHYWDTH),
          .HEADD_WIDTH(HEADD_WIDTH), .HEADD_NUMVBNK(HEADD_NUMVBNK), .HEADD_BITVBNK(HEADD_BITVBNK), .HEADD_DELAY(HEADD_DELAY),
          .HEADD_NUMVROW(HEADD_NUMVROW), .HEADD_BITVROW(HEADD_BITVROW), .HEADD_BITWSPF(HEADD_BITWSPF), .HEADD_NUMWRDS(HEADD_NUMWRDS),
          .HEADD_BITWRDS(HEADD_BITWRDS), .HEADD_NUMSROW(HEADD_NUMSROW), .HEADD_BITSROW(HEADD_BITSROW), .HEADD_PHYWDTH(HEADD_PHYWDTH),
          .HEADC_WIDTH(HEADC_WIDTH), .HEADC_NUMVBNK(HEADC_NUMVBNK), .HEADC_BITVBNK(HEADC_BITVBNK), .HEADC_DELAY(HEADC_DELAY),
          .HEADC_NUMVROW(HEADC_NUMVROW), .HEADC_BITVROW(HEADC_BITVROW), .HEADC_BITWSPF(HEADC_BITWSPF), .HEADC_NUMWRDS(HEADC_NUMWRDS),
          .HEADC_BITWRDS(HEADC_BITWRDS), .HEADC_NUMSROW(HEADC_NUMSROW), .HEADC_BITSROW(HEADC_BITSROW), .HEADC_PHYWDTH(HEADC_PHYWDTH),
          .HEADS_WIDTH(HEADS_WIDTH), .HEADS_NUMVBNK(HEADS_NUMVBNK), .HEADS_BITVBNK(HEADS_BITVBNK), .HEADS_DELAY(HEADS_DELAY),
          .HEADS_NUMVROW(HEADS_NUMVROW), .HEADS_BITVROW(HEADS_BITVROW), .HEADS_BITWSPF(HEADS_BITWSPF), .HEADS_NUMWRDS(HEADS_NUMWRDS),
          .HEADS_BITWRDS(HEADS_BITWRDS), .HEADS_NUMSROW(HEADS_NUMSROW), .HEADS_BITSROW(HEADS_BITSROW), .HEADS_PHYWDTH(HEADS_PHYWDTH),
          .TAIL_WIDTH(TAIL_WIDTH), .TAIL_NUMVBNK(TAIL_NUMVBNK), .TAIL_BITVBNK(TAIL_BITVBNK), .TAIL_DELAY(TAIL_DELAY),
          .TAIL_NUMVROW(TAIL_NUMVROW), .TAIL_BITVROW(TAIL_BITVROW), .TAIL_BITWSPF(TAIL_BITWSPF),
          .TAIL_NUMWRDS(TAIL_NUMWRDS), .TAIL_BITWRDS(TAIL_BITWRDS), .TAIL_NUMSROW(TAIL_NUMSROW), .TAIL_BITSROW(TAIL_BITSROW),
          .QPTR_DELAY(QPTR_DELAY), .LINK_DELAY(LINK_DELAY), .DATA_DELAY(DATA_DELAY), .FLOPIN(FLOPIN), .FLOPMEM(FLOPMEM), .FLOPOUT(FLOPOUT), .FLOPECC(FLOPECC))	
    algo_top
		(.clk(clk), .rst(rst), .ready(ready),
		 .push(push), .pu_owr(pu_owr), .pu_prt(pu_prt), .pu_ptr(pu_ptr), .pu_din(pu_din), .pu_cvld(pu_cvld), .pu_cnt(pu_cnt), .pu_cserr(pu_cserr), .pu_cderr(pu_cderr),
		 .pop(pop), .po_ndq(po_ndq), .po_prt(po_prt), .po_cvld(po_cvld), .po_cmt(po_cmt), .po_cnt(po_cnt), .po_pvld(po_pvld), .po_ptr(po_ptr), .po_dvld(po_dvld), .po_dout(po_dout),
         .po_cserr(po_cserr), .po_cderr(po_cderr), .po_pserr(po_pserr), .po_pderr(po_pderr), .po_dserr(po_dserr), .po_dderr(po_dderr),
         .cp_read(cp_read), .cp_write(cp_write), .cp_adr(cp_adr), .cp_din(cp_din), .cp_vld(cp_vld), .cp_dout(cp_dout),
		 .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB), .t1_padrB(t1_padrB), .t1_serrB(t1_serrB), .t1_derrB(t1_derrB),
		 .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB), .t2_padrB(t2_padrB), .t2_serrB(t2_serrB), .t2_derrB(t2_derrB),
		 .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB), .t3_padrB(t3_padrB), .t3_serrB(t3_serrB), .t3_derrB(t3_derrB),
		 .t4_writeA(t4_writeA), .t4_addrA(t4_addrA), .t4_dinA(t4_dinA), .t4_readB(t4_readB), .t4_addrB(t4_addrB), .t4_doutB(t4_doutB), .t4_padrB(t4_padrB), .t4_serrB(t4_serrB), .t4_derrB(t4_derrB),
		 .t5_writeA(t5_writeA), .t5_addrA(t5_addrA), .t5_dinA(t5_dinA), .t5_readB(t5_readB), .t5_addrB(t5_addrB), .t5_doutB(t5_doutB), .t5_padrB(t5_padrB), .t5_serrB(t5_serrB), .t5_derrB(t5_derrB),
		 .t6_writeA(t6_writeA), .t6_addrA(t6_addrA), .t6_dinA(t6_dinA), .t6_readB(t6_readB), .t6_addrB(t6_addrB), .t6_doutB(t6_doutB), .t6_padrB(t6_padrB), .t6_serrB(t6_serrB), .t6_derrB(t6_derrB),
		 .t7_writeA(t7_writeA), .t7_addrA(t7_addrA), .t7_dinA(t7_dinA), .t7_readB(t7_readB), .t7_addrB(t7_addrB), .t7_doutB(t7_doutB), .t7_padrB(t7_padrB), .t7_serrB(t7_serrB), .t7_derrB(t7_derrB),
		 .t8_writeA(t8_writeA), .t8_addrA(t8_addrA), .t8_dinA(t8_dinA), .t8_readB(t8_readB), .t8_addrB(t8_addrB), .t8_doutB(t8_doutB), .t8_padrB(t8_padrB), .t8_serrB(t8_serrB), .t8_derrB(t8_derrB),
		 .t9_writeA(t9_writeA), .t9_addrA(t9_addrA), .t9_dinA(t9_dinA), .t9_readB(t9_readB), .t9_addrB(t9_addrB), .t9_doutB(t9_doutB), .t9_padrB(t9_padrB), .t9_serrB(t9_serrB), .t9_derrB(t9_derrB),
		 .t10_writeA(t10_writeA), .t10_addrA(t10_addrA), .t10_dinA(t10_dinA), .t10_readB(t10_readB), .t10_addrB(t10_addrB), .t10_doutB(t10_doutB), .t10_padrB(t10_padrB), .t10_serrB(t10_serrB), .t10_derrB(t10_derrB),
		 .t11_writeA(t11_writeA), .t11_addrA(t11_addrA), .t11_dinA(t11_dinA), .t11_readB(t11_readB), .t11_addrB(t11_addrB), .t11_doutB(t11_doutB), .t11_padrB(t11_padrB), .t11_serrB(t11_serrB), .t11_derrB(t11_derrB));

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

endmodule    //algo_1r1w_a416_top_wrap
