/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.UNKNOWN Date: Wed 2012.11.21 at 01:59:18 PM IST
 * */

module algo_1r1w_a417_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 9216, parameter IP_BITADDR = 14, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 1, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,
parameter IP_NUMQPRT = 9248, parameter IP_BITQPRT = 14, parameter IP_NUMPING = 1, parameter IP_BITPING = 0,

parameter T1_WIDTH = 20, parameter T1_ECCWDTH = 6, parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 0, parameter T1_DELAY = 2, parameter T1_NUMVROW = 9216, parameter T1_BITVROW = 14,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 0, parameter T1_NUMSROW = 9216, parameter T1_BITSROW = 14, parameter T1_PHYWDTH = 20,
parameter T2_WIDTH = 39, parameter T2_ECCWDTH = 7, parameter T2_NUMVBNK = 1, parameter T2_BITVBNK = 0, parameter T2_DELAY = 2, parameter T2_NUMVROW = 9216, parameter T2_BITVROW = 14,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 9216, parameter T2_BITSROW = 14, parameter T2_PHYWDTH = 39,
parameter T3_WIDTH = 21, parameter T3_NUMVBNK = 10, parameter T3_BITVBNK = 4, parameter T3_DELAY = 2, parameter T3_NUMVROW = 1852, parameter T3_BITVROW = 11,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 0, parameter T3_NUMSROW = 1852, parameter T3_BITSROW = 11, parameter T3_PHYWDTH = 21,
parameter T4_WIDTH = 21, parameter T4_NUMVBNK = 2, parameter T4_BITVBNK = 1, parameter T4_DELAY = 2, parameter T4_NUMVROW = 1852, parameter T4_BITVROW = 11,
parameter T4_BITWSPF = 0, parameter T4_NUMWRDS = 1, parameter T4_BITWRDS = 0, parameter T4_NUMSROW = 4096, parameter T4_BITSROW = 11, parameter T4_PHYWDTH = 21,
parameter T5_WIDTH = 12, parameter T5_NUMVBNK = 2, parameter T5_BITVBNK = 1, parameter T5_DELAY = 2, parameter T5_NUMVROW = 1852, parameter T5_BITVROW = 11,
parameter T5_BITWSPF = 0, parameter T5_NUMWRDS = 1, parameter T5_BITWRDS = 0, parameter T5_NUMSROW = 1852, parameter T5_BITSROW = 11, parameter T5_PHYWDTH = 12,
parameter T6_WIDTH = 20, parameter T6_NUMVBNK = 10, parameter T6_BITVBNK = 4, parameter T6_DELAY = 2, parameter T6_NUMVROW = 1852, parameter T6_BITVROW = 11,
parameter T6_BITWSPF = 0, parameter T6_NUMWRDS = 1, parameter T6_BITWRDS = 0, parameter T6_NUMSROW = 1852, parameter T6_BITSROW = 11, parameter T6_PHYWDTH = 20,
parameter T7_WIDTH = 20, parameter T7_NUMVBNK = 2, parameter T7_BITVBNK = 1, parameter T7_DELAY = 2, parameter T7_NUMVROW = 1852, parameter T7_BITVROW = 11,
parameter T7_BITWSPF = 0, parameter T7_NUMWRDS = 1, parameter T7_BITWRDS = 0, parameter T7_NUMSROW = 1852, parameter T7_BITSROW = 11, parameter T7_PHYWDTH = 20,
parameter T8_WIDTH = 12, parameter T8_NUMVBNK = 2, parameter T8_BITVBNK = 1, parameter T8_DELAY = 2, parameter T8_NUMVROW = 1852, parameter T8_BITVROW = 11,
parameter T8_BITWSPF = 0, parameter T8_NUMWRDS = 1, parameter T8_BITWRDS = 0, parameter T8_NUMSROW = 1852, parameter T8_BITSROW = 11, parameter T8_PHYWDTH = 12,
parameter T9_WIDTH = 20, parameter T9_NUMVBNK = 1, parameter T9_BITVBNK = 0, parameter T9_DELAY = 2, parameter T9_NUMVROW = 9216, parameter T9_BITVROW = 14,
parameter T9_BITWSPF = 0, parameter T9_NUMWRDS = 1, parameter T9_BITWRDS = 0, parameter T9_NUMSROW = 9216, parameter T9_BITSROW = 14, parameter T9_PHYWDTH = 20)
( clk, rst, ready,
  push, pu_prt, pu_ptr, pu_din, pu_cvld, pu_cnt,
  pop, po_ndq, po_prt, po_cvld, po_cmt, po_cnt, po_pvld, po_ptr, po_dvld, po_dout,
  peek, pe_prt, pe_ptr, pe_cvld, pe_cmt, pe_nvld, pe_nxt, pe_dvld, pe_dout,
  cp_read, cp_write, cp_adr, cp_din, cp_vld, cp_dout,
  t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
  t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
  t3_writeA, t3_addrA, t3_bwA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
  t4_writeA, t4_addrA, t4_bwA, t4_dinA, t4_readB, t4_addrB, t4_doutB,
  t5_writeA, t5_addrA, t5_bwA, t5_dinA, t5_readB, t5_addrB, t5_doutB,
  t6_writeA, t6_addrA, t6_bwA, t6_dinA, t6_readB, t6_addrB, t6_doutB,
  t7_writeA, t7_addrA, t7_bwA, t7_dinA, t7_readB, t7_addrB, t7_doutB,
  t8_writeA, t8_addrA, t8_bwA, t8_dinA, t8_readB, t8_addrB, t8_doutB,
  t9_writeA, t9_addrA, t9_bwA, t9_dinA, t9_readB, t9_addrB, t9_doutB);
  
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
  parameter QPTR_DELAY = T9_DELAY;
  parameter LINK_DELAY = T1_DELAY;
  parameter DATA_DELAY = T2_DELAY;
  parameter NUMPOPT = 1;
  parameter NUMPUPT = 1;
  parameter NUMPEPT = 1;

  parameter BITQPTR = BITADDR;
  parameter QPTR_WIDTH = T1_PHYWDTH;
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter CNTD_WIDTH   = T3_WIDTH;
  parameter CNTD_NUMVBNK = T3_NUMVBNK;
  parameter CNTD_BITVBNK = T3_BITVBNK;
  parameter CNTD_DELAY   = T3_DELAY;
  parameter CNTD_NUMVROW = T3_NUMVROW;
  parameter CNTD_BITVROW = T3_BITVROW;
  parameter CNTD_BITWSPF = T3_BITWSPF;
  parameter CNTD_NUMWRDS = T3_NUMWRDS;
  parameter CNTD_BITWRDS = T3_BITWRDS;
  parameter CNTD_NUMSROW = T3_NUMSROW;
  parameter CNTD_BITSROW = T3_BITSROW;
  parameter CNTD_PHYWDTH = T3_PHYWDTH;

  parameter CNTC_WIDTH   = T4_WIDTH;
  parameter CNTC_NUMVBNK = T4_NUMVBNK;
  parameter CNTC_BITVBNK = T4_BITVBNK;
  parameter CNTC_DELAY   = T4_DELAY;
  parameter CNTC_NUMVROW = T4_NUMVROW;
  parameter CNTC_BITVROW = T4_BITVROW;
  parameter CNTC_BITWSPF = T4_BITWSPF;
  parameter CNTC_NUMWRDS = T4_NUMWRDS;
  parameter CNTC_BITWRDS = T4_BITWRDS;
  parameter CNTC_NUMSROW = T4_NUMSROW;
  parameter CNTC_BITSROW = T4_BITSROW;
  parameter CNTC_PHYWDTH = T4_PHYWDTH;

  parameter CNTS_WIDTH   = T5_WIDTH;
  parameter CNTS_NUMVBNK = T5_NUMVBNK;
  parameter CNTS_BITVBNK = T5_BITVBNK;
  parameter CNTS_DELAY   = T5_DELAY;
  parameter CNTS_NUMVROW = T5_NUMVROW;
  parameter CNTS_BITVROW = T5_BITVROW;
  parameter CNTS_BITWSPF = T5_BITWSPF;
  parameter CNTS_NUMWRDS = T5_NUMWRDS;
  parameter CNTS_BITWRDS = T5_BITWRDS;
  parameter CNTS_NUMSROW = T5_NUMSROW;
  parameter CNTS_BITSROW = T5_BITSROW;
  parameter CNTS_PHYWDTH = T5_PHYWDTH;

  parameter HEADD_WIDTH   = T6_WIDTH;
  parameter HEADD_NUMVBNK = T6_NUMVBNK;
  parameter HEADD_BITVBNK = T6_BITVBNK;
  parameter HEADD_DELAY   = T6_DELAY;
  parameter HEADD_NUMVROW = T6_NUMVROW;
  parameter HEADD_BITVROW = T6_BITVROW;
  parameter HEADD_BITWSPF = T6_BITWSPF;
  parameter HEADD_NUMWRDS = T6_NUMWRDS;
  parameter HEADD_BITWRDS = T6_BITWRDS;
  parameter HEADD_NUMSROW = T6_NUMSROW;
  parameter HEADD_BITSROW = T6_BITSROW;
  parameter HEADD_PHYWDTH = T6_PHYWDTH;

  parameter HEADC_WIDTH   = T7_WIDTH;
  parameter HEADC_NUMVBNK = T7_NUMVBNK;
  parameter HEADC_BITVBNK = T7_BITVBNK;
  parameter HEADC_DELAY   = T7_DELAY;
  parameter HEADC_NUMVROW = T7_NUMVROW;
  parameter HEADC_BITVROW = T7_BITVROW;
  parameter HEADC_BITWSPF = T7_BITWSPF;
  parameter HEADC_NUMWRDS = T7_NUMWRDS;
  parameter HEADC_BITWRDS = T7_BITWRDS;
  parameter HEADC_NUMSROW = T7_NUMSROW;
  parameter HEADC_BITSROW = T7_BITSROW;
  parameter HEADC_PHYWDTH = T7_PHYWDTH;

  parameter HEADS_WIDTH   = T8_WIDTH;
  parameter HEADS_NUMVBNK = T8_NUMVBNK;
  parameter HEADS_BITVBNK = T8_BITVBNK;
  parameter HEADS_DELAY   = T8_DELAY;
  parameter HEADS_NUMVROW = T8_NUMVROW;
  parameter HEADS_BITVROW = T8_BITVROW;
  parameter HEADS_BITWSPF = T8_BITWSPF;
  parameter HEADS_NUMWRDS = T8_NUMWRDS;
  parameter HEADS_BITWRDS = T8_BITWRDS;
  parameter HEADS_NUMSROW = T8_NUMSROW;
  parameter HEADS_BITSROW = T8_BITSROW;
  parameter HEADS_PHYWDTH = T8_PHYWDTH;

  parameter TAIL_WIDTH   = T9_WIDTH;
  parameter TAIL_NUMVBNK = T9_NUMVBNK;
  parameter TAIL_BITVBNK = T9_BITVBNK;
  parameter TAIL_DELAY   = T9_DELAY;
  parameter TAIL_NUMVROW = T9_NUMVROW;
  parameter TAIL_BITVROW = T9_BITVROW;
  parameter TAIL_BITWSPF = T9_BITWSPF;
  parameter TAIL_NUMWRDS = T9_NUMWRDS;
  parameter TAIL_BITWRDS = T9_BITWRDS;
  parameter TAIL_NUMSROW = T9_NUMSROW;
  parameter TAIL_BITSROW = T9_BITSROW;
  parameter TAIL_PHYWDTH = T9_PHYWDTH;

  parameter DATA_WIDTH = T2_PHYWDTH;
  parameter ECC_WIDTH = T2_ECCWDTH;

  parameter BITCPAD = BITQPRT;
  parameter CPUWDTH = 2*BITPING+BITQCNT+2*NUMPING*BITQPTR;

  input [NUMPUPT-1:0]                      push;
  input [NUMPUPT*BITQPRT-1:0]              pu_prt;
  input [NUMPUPT*BITQPTR-1:0]              pu_ptr;
  input [NUMPUPT*WIDTH-1:0]                pu_din;
  output [NUMPUPT-1:0]                     pu_cvld;
  output [NUMPUPT*BITQCNT-1:0]             pu_cnt;

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

  input [NUMPEPT-1:0]                      peek;
  input [NUMPEPT*BITQPRT-1:0]              pe_prt;
  input [NUMPEPT*BITQPTR-1:0]              pe_ptr;
  output [NUMPEPT-1:0]                     pe_cvld;
  output [NUMPEPT-1:0]                     pe_cmt;
  output [NUMPEPT-1:0]                     pe_nvld;
  output [NUMPEPT*BITQPTR-1:0]             pe_nxt;
  output [NUMPEPT-1:0]                     pe_dvld;
  output [NUMPEPT*WIDTH-1:0]               pe_dout;

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

  output [CNTD_NUMVBNK-1:0]                t3_writeA;
  output [CNTD_NUMVBNK*CNTD_BITVROW-1:0]   t3_addrA;
  output [CNTD_NUMVBNK*CNTD_WIDTH-1:0]     t3_bwA;
  output [CNTD_NUMVBNK*CNTD_WIDTH-1:0]     t3_dinA;
  output [CNTD_NUMVBNK-1:0]                t3_readB;
  output [CNTD_NUMVBNK*CNTD_BITVROW-1:0]   t3_addrB;
  input  [CNTD_NUMVBNK*CNTD_WIDTH-1:0]     t3_doutB;

  output [CNTC_NUMVBNK-1:0]                t4_writeA;
  output [CNTC_NUMVBNK*CNTC_BITVROW-1:0]   t4_addrA;
  output [CNTC_NUMVBNK*CNTC_WIDTH-1:0]     t4_bwA;
  output [CNTC_NUMVBNK*CNTC_WIDTH-1:0]     t4_dinA;
  output [CNTC_NUMVBNK-1:0]                t4_readB;
  output [CNTC_NUMVBNK*CNTC_BITVROW-1:0]   t4_addrB;
  input  [CNTC_NUMVBNK*CNTC_WIDTH-1:0]     t4_doutB;

  output [CNTS_NUMVBNK-1:0]                t5_writeA;
  output [CNTS_NUMVBNK*CNTS_BITVROW-1:0]   t5_addrA;
  output [CNTS_NUMVBNK*CNTS_WIDTH-1:0]     t5_bwA;
  output [CNTS_NUMVBNK*CNTS_WIDTH-1:0]     t5_dinA;
  output [CNTS_NUMVBNK-1:0]                t5_readB;
  output [CNTS_NUMVBNK*CNTS_BITVROW-1:0]   t5_addrB;
  input [CNTS_NUMVBNK*CNTS_WIDTH-1:0]      t5_doutB;

  output [HEADD_NUMVBNK-1:0]               t6_writeA;
  output [HEADD_NUMVBNK*HEADD_BITVROW-1:0] t6_addrA;
  output [HEADD_NUMVBNK*HEADD_WIDTH-1:0]   t6_bwA;
  output [HEADD_NUMVBNK*HEADD_WIDTH-1:0]   t6_dinA;
  output [HEADD_NUMVBNK-1:0]               t6_readB;
  output [HEADD_NUMVBNK*HEADD_BITVROW-1:0] t6_addrB;
  input  [HEADD_NUMVBNK*HEADD_WIDTH-1:0]   t6_doutB;

  output [HEADC_NUMVBNK-1:0]               t7_writeA;
  output [HEADC_NUMVBNK*HEADC_BITVROW-1:0] t7_addrA;
  output [HEADC_NUMVBNK*HEADC_WIDTH-1:0]   t7_bwA;
  output [HEADC_NUMVBNK*HEADC_WIDTH-1:0]   t7_dinA;
  output [HEADC_NUMVBNK-1:0]               t7_readB;
  output [HEADC_NUMVBNK*HEADC_BITVROW-1:0] t7_addrB;
  input  [HEADC_NUMVBNK*HEADC_WIDTH-1:0]   t7_doutB;

  output [HEADS_NUMVBNK-1:0]               t8_writeA;
  output [HEADS_NUMVBNK*HEADS_BITVROW-1:0] t8_addrA;
  output [HEADS_NUMVBNK*HEADS_WIDTH-1:0]   t8_bwA;
  output [HEADS_NUMVBNK*HEADS_WIDTH-1:0]   t8_dinA;
  output [HEADS_NUMVBNK-1:0]               t8_readB;
  output [HEADS_NUMVBNK*HEADS_BITVROW-1:0] t8_addrB;
  input  [HEADS_NUMVBNK*HEADS_WIDTH-1:0]   t8_doutB;

  output [NUMPUPT-1:0]                     t9_writeA;
  output [NUMPUPT*BITQPRT-1:0]             t9_addrA;
  output [NUMPUPT*TAIL_WIDTH-1:0]          t9_bwA;
  output [NUMPUPT*TAIL_WIDTH-1:0]          t9_dinA;
  output [NUMPUPT-1:0]                     t9_readB;
  output [NUMPUPT*BITQPRT-1:0]             t9_addrB;
  input [NUMPUPT*TAIL_WIDTH-1:0]           t9_doutB;

  wire [NUMPUPT*QPTR_WIDTH-1:0]            t1_bwA = ~0;
  wire [NUMPUPT*DATA_WIDTH-1:0]            t2_bwA = ~0;
  wire [CNTD_NUMVBNK*CNTD_WIDTH-1:0]       t3_bwA = ~0;
  wire [CNTC_NUMVBNK*CNTC_WIDTH-1:0]       t4_bwA = ~0;
  wire [CNTS_NUMVBNK*CNTS_WIDTH-1:0]       t5_bwA = ~0;
  wire [HEADD_NUMVBNK*HEADD_WIDTH-1:0]     t6_bwA = ~0;
  wire [HEADC_NUMVBNK*HEADC_WIDTH-1:0]     t7_bwA = ~0;
  wire [HEADS_NUMVBNK*HEADS_WIDTH-1:0]     t8_bwA = ~0;
  wire [NUMPUPT*TAIL_WIDTH-1:0]            t9_bwA = ~0;

  algo_1r1w_a417_top
		#(.WIDTH (WIDTH), .DATA_WIDTH(DATA_WIDTH), .BITWDTH (BITWDTH), .NUMPOPT (NUMPOPT), .NUMPUPT (NUMPUPT),
          .NUMQPRT (NUMQPRT), .BITQPRT (BITQPRT), .QPTR_WIDTH(QPTR_WIDTH), .NUMPING (NUMPING), .BITPING (BITPING), .NUMADDR(NUMADDR), .BITADDR(BITADDR),
		  .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .NUMPBNK(NUMPBNK), .BITPBNK(BITPBNK),
          .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS), .NUMSROW(NUMSROW), .BITSROW(BITSROW),
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
		 .push(push), .pu_prt(pu_prt), .pu_ptr(pu_ptr), .pu_din(pu_din), .pu_cvld(pu_cvld), .pu_cnt(pu_cnt),
		 .pop(pop), .po_ndq(po_ndq), .po_prt(po_prt), .po_cvld(po_cvld), .po_cmt(po_cmt), .po_cnt(po_cnt),
         .po_pvld(po_pvld), .po_ptr(po_ptr), .po_dvld(po_dvld), .po_dout(po_dout),
         .peek(peek), .pe_prt(pe_prt), .pe_ptr(pe_ptr), .pe_cvld(pe_cvld), .pe_cmt(pe_cmt), .pe_nvld(pe_nvld), .pe_nxt(pe_nxt), .pe_dvld(pe_dvld), .pe_dout(pe_dout),
         .cp_read(cp_read), .cp_write(cp_write), .cp_adr(cp_adr), .cp_din(cp_din), .cp_vld(cp_vld), .cp_dout(cp_dout),
		 .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
		 .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
		 .t3_writeA(), .t3_addrA(), .t3_dinA(), .t3_readB(), .t3_addrB(), .t3_doutB(),
		 .t4_writeA(), .t4_addrA(), .t4_dinA(), .t4_readB(), .t4_addrB(), .t4_doutB(),
		 .t5_writeA(t3_writeA), .t5_addrA(t3_addrA), .t5_dinA(t3_dinA), .t5_readB(t3_readB), .t5_addrB(t3_addrB), .t5_doutB(t3_doutB),
		 .t6_writeA(t4_writeA), .t6_addrA(t4_addrA), .t6_dinA(t4_dinA), .t6_readB(t4_readB), .t6_addrB(t4_addrB), .t6_doutB(t4_doutB),
		 .t7_writeA(t5_writeA), .t7_addrA(t5_addrA), .t7_dinA(t5_dinA), .t7_readB(t5_readB), .t7_addrB(t5_addrB), .t7_doutB(t5_doutB),
		 .t8_writeA(t6_writeA), .t8_addrA(t6_addrA), .t8_dinA(t6_dinA), .t8_readB(t6_readB), .t8_addrB(t6_addrB), .t8_doutB(t6_doutB),
		 .t9_writeA(t7_writeA), .t9_addrA(t7_addrA), .t9_dinA(t7_dinA), .t9_readB(t7_readB), .t9_addrB(t7_addrB), .t9_doutB(t7_doutB),
		 .t10_writeA(t8_writeA), .t10_addrA(t8_addrA), .t10_dinA(t8_dinA), .t10_readB(t8_readB), .t10_addrB(t8_addrB), .t10_doutB(t8_doutB),
		 .t11_writeA(t9_writeA), .t11_addrA(t9_addrA), .t11_dinA(t9_dinA), .t11_readB(t9_readB), .t11_addrB(t9_addrB), .t11_doutB(t9_doutB));

`ifndef FORMAL
`endif

endmodule    //algo_1r1w_a417_top_wrap
