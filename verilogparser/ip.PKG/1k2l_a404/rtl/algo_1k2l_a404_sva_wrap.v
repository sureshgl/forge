/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.UNKNOWN Date: Wed 2012.11.21 at 01:59:18 PM IST
 * */

module algo_1k2l_a404_sva_wrap
#(parameter IP_WIDTH = 83, parameter IP_BITWIDTH = 7, parameter IP_DECCBITS = 8, parameter IP_NUMADDR = 9216, parameter IP_BITADDR = 14, 
parameter IP_NUMVBNK = 1,	parameter IP_BITVBNK = 1, parameter IP_BITPBNK = 1,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 0, parameter IP_SECCDWIDTH = 0, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 0, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,
parameter IP_NUMQPRT = 64, parameter IP_BITQPRT = 6, parameter IP_NUMPING = 8, parameter IP_BITPING = 3,
parameter IP_BITMDAT = 5,

parameter T1_T1_WIDTH = 20,  parameter T1_T1_NUMVBNK = 2, parameter T1_T1_BITVBNK = 1, parameter T1_T1_DELAY = 2,      parameter T1_T1_NUMVROW = 9216, parameter T1_T1_BITVROW = 14,
parameter T1_T1_BITWSPF = 0, parameter T1_T1_NUMWRDS = 1, parameter T1_T1_BITWRDS = 0, parameter T1_T1_NUMSROW = 9216, parameter T1_T1_BITSROW = 14,   parameter T1_T1_PHYWDTH = 32,
parameter T1_T2_WIDTH = 20,  parameter T1_T2_NUMVBNK = 2, parameter T1_T2_BITVBNK = 1, parameter T1_T2_DELAY = 2,      parameter T1_T2_NUMVROW = 9216, parameter T1_T2_BITVROW = 14,
parameter T1_T2_BITWSPF = 0, parameter T1_T2_NUMWRDS = 1, parameter T1_T2_BITWRDS = 0, parameter T1_T2_NUMSROW = 9216, parameter T1_T2_BITSROW = 14,   parameter T1_T2_PHYWDTH = 32,
parameter T1_T3_WIDTH = 20,  parameter T1_T3_NUMVBNK = 2, parameter T1_T3_BITVBNK = 1, parameter T1_T3_DELAY = 2,      parameter T1_T3_NUMVROW = 9216, parameter T1_T3_BITVROW = 14,
parameter T1_T3_BITWSPF = 0, parameter T1_T3_NUMWRDS = 1, parameter T1_T3_BITWRDS = 0, parameter T1_T3_NUMSROW = 9216, parameter T1_T3_BITSROW = 14,   parameter T1_T3_PHYWDTH = 32,
parameter T2_T1_WIDTH = 91,  parameter T2_T1_NUMVBNK = 2, parameter T2_T1_BITVBNK = 1, parameter T2_T1_DELAY = 2,      parameter T2_T1_NUMVROW = 9216, parameter T2_T1_BITVROW = 14,
parameter T2_T1_BITWSPF = 0, parameter T2_T1_NUMWRDS = 1, parameter T2_T1_BITWRDS = 0, parameter T2_T1_NUMSROW = 9216, parameter T2_T1_BITSROW = 14,   parameter T2_T1_PHYWDTH = 32,
parameter T2_T2_WIDTH = 91,  parameter T2_T2_NUMVBNK = 2, parameter T2_T2_BITVBNK = 1, parameter T2_T2_DELAY = 2,      parameter T2_T2_NUMVROW = 9216, parameter T2_T2_BITVROW = 14,
parameter T2_T2_BITWSPF = 0, parameter T2_T2_NUMWRDS = 1, parameter T2_T2_BITWRDS = 0, parameter T2_T2_NUMSROW = 9216, parameter T2_T2_BITSROW = 14,   parameter T2_T2_PHYWDTH = 32,
parameter T2_T3_WIDTH = 91,  parameter T2_T3_NUMVBNK = 2, parameter T2_T3_BITVBNK = 1, parameter T2_T3_DELAY = 2,      parameter T2_T3_NUMVROW = 9216, parameter T2_T3_BITVROW = 14,
parameter T2_T3_BITWSPF = 0, parameter T2_T3_NUMWRDS = 1, parameter T2_T3_BITWRDS = 0, parameter T2_T3_NUMSROW = 9216, parameter T2_T3_BITSROW = 14,   parameter T2_T3_PHYWDTH = 32,
parameter T3_WIDTH = 3, parameter T3_NUMVBNK = 1, parameter T3_BITVBNK = 0, parameter T3_DELAY = 2, parameter T3_NUMVROW = 2, parameter T3_BITVROW = 1,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 0, parameter T3_NUMSROW = 2, parameter T3_BITSROW = 1, parameter T3_PHYWDTH = 3,
parameter T4_WIDTH = 3, parameter T4_NUMVBNK = 1, parameter T4_BITVBNK = 0, parameter T4_DELAY = 2, parameter T4_NUMVROW = 2, parameter T4_BITVROW = 1,
parameter T4_BITWSPF = 0, parameter T4_NUMWRDS = 1, parameter T4_BITWRDS = 0, parameter T4_NUMSROW = 2, parameter T4_BITSROW = 1, parameter T4_PHYWDTH = 3,
parameter T5_WIDTH = 15, parameter T5_NUMVBNK = 1, parameter T5_BITVBNK = 0, parameter T5_DELAY = 2, parameter T5_NUMVROW = 2, parameter T5_BITVROW = 1,
parameter T5_BITWSPF = 0, parameter T5_NUMWRDS = 1, parameter T5_BITWRDS = 0, parameter T5_NUMSROW = 2, parameter T5_BITSROW = 1, parameter T5_PHYWDTH = 15,
parameter T6_WIDTH = 56, parameter T6_NUMVBNK = 1, parameter T6_BITVBNK = 0, parameter T6_DELAY = 2, parameter T6_NUMVROW = 2, parameter T6_BITVROW = 1,
parameter T6_BITWSPF = 0, parameter T6_NUMWRDS = 1, parameter T6_BITWRDS = 0, parameter T6_NUMSROW = 2, parameter T6_BITSROW = 1, parameter T6_PHYWDTH = 56,
parameter T7_WIDTH = 56, parameter T7_NUMVBNK = 1, parameter T7_BITVBNK = 0, parameter T7_DELAY = 2, parameter T7_NUMVROW = 2, parameter T7_BITVROW = 1,
parameter T7_BITWSPF = 0, parameter T7_NUMWRDS = 1, parameter T7_BITWRDS = 0, parameter T7_NUMSROW = 2, parameter T7_BITSROW = 1, parameter T7_PHYWDTH = 56,
parameter T8_WIDTH = 56, parameter T8_NUMVBNK = 1, parameter T8_BITVBNK = 0, parameter T8_DELAY = 2, parameter T8_NUMVROW = 2, parameter T8_BITVROW = 1,
parameter T8_BITWSPF = 0, parameter T8_NUMWRDS = 1, parameter T8_BITWRDS = 0, parameter T8_NUMSROW = 2, parameter T8_BITSROW = 1, parameter T8_PHYWDTH = 56)
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
  input [NUMPOPT*NUMMDAT*BITMDAT-1:0]         po_metadata;
  input [NUMPOPT-1:0]                 po_dvld;
  input [NUMPOPT*WIDTH-1:0]           po_dout;

  input [BITQCNT-1:0]                 freecnt;
  input                               ready;
  input                                clk, rst;

  input [T1_T1_NUMVBNK-1:0]                 t1_writeA;
  input [T1_T1_NUMVBNK*T1_T1_BITVROW-1:0]   t1_addrA;
  input [T1_T1_NUMVBNK*T1_T1_PHYWDTH-1:0]   t1_bwA;
  input [T1_T1_NUMVBNK*T1_T1_PHYWDTH-1:0]   t1_dinA;
  input [T1_T1_NUMVBNK-1:0]                 t1_readB;
  input [T1_T1_NUMVBNK*T1_T1_BITVROW-1:0]   t1_addrB;
  input  [T1_T1_NUMVBNK*T1_T1_PHYWDTH-1:0]   t1_doutB;

  input [T1_T2_NUMVBNK-1:0]                 t2_writeA;
  input [T1_T2_NUMVBNK*T1_T2_BITVROW-1:0]   t2_addrA;
  input [T1_T2_NUMVBNK*T1_T2_PHYWDTH-1:0]   t2_bwA;
  input [T1_T2_NUMVBNK*T1_T2_PHYWDTH-1:0]   t2_dinA;
  input [T1_T2_NUMVBNK-1:0]                 t2_readB;
  input [T1_T2_NUMVBNK*T1_T2_BITVROW-1:0]   t2_addrB;
  input  [T1_T2_NUMVBNK*T1_T2_PHYWDTH-1:0]   t2_doutB;

  input [T1_T3_NUMVBNK-1:0]                 t3_writeA;
  input [T1_T3_NUMVBNK*T1_T3_BITVROW-1:0]   t3_addrA;
  input [T1_T3_NUMVBNK*T1_T3_PHYWDTH-1:0]   t3_bwA;
  input [T1_T3_NUMVBNK*T1_T3_PHYWDTH-1:0]   t3_dinA;
  input [T1_T3_NUMVBNK-1:0]                 t3_readB;
  input [T1_T3_NUMVBNK*T1_T3_BITVROW-1:0]   t3_addrB;
  input  [T1_T3_NUMVBNK*T1_T3_PHYWDTH-1:0]   t3_doutB;

  input [T2_T1_NUMVBNK-1:0]                 t4_writeA;
  input [T2_T1_NUMVBNK*T2_T1_BITVROW-1:0]   t4_addrA;
  input [T2_T1_NUMVBNK*T2_T1_PHYWDTH-1:0]   t4_bwA;
  input [T2_T1_NUMVBNK*T2_T1_PHYWDTH-1:0]   t4_dinA;
  input [T2_T1_NUMVBNK-1:0]                 t4_readB;
  input [T2_T1_NUMVBNK*T2_T1_BITVROW-1:0]   t4_addrB;
  input  [T2_T1_NUMVBNK*T2_T1_PHYWDTH-1:0]   t4_doutB;

  input [T2_T2_NUMVBNK-1:0]                 t5_writeA;
  input [T2_T2_NUMVBNK*T2_T2_BITVROW-1:0]   t5_addrA;
  input [T2_T2_NUMVBNK*T2_T2_PHYWDTH-1:0]   t5_bwA;
  input [T2_T2_NUMVBNK*T2_T2_PHYWDTH-1:0]   t5_dinA;
  input [T2_T2_NUMVBNK-1:0]                 t5_readB;
  input [T2_T2_NUMVBNK*T2_T2_BITVROW-1:0]   t5_addrB;
  input  [T2_T2_NUMVBNK*T2_T2_PHYWDTH-1:0]   t5_doutB;

  input [T2_T3_NUMVBNK-1:0]                 t6_writeA;
  input [T2_T3_NUMVBNK*T2_T3_BITVROW-1:0]   t6_addrA;
  input [T2_T3_NUMVBNK*T2_T3_PHYWDTH-1:0]   t6_bwA;
  input [T2_T3_NUMVBNK*T2_T3_PHYWDTH-1:0]   t6_dinA;
  input [T2_T3_NUMVBNK-1:0]                 t6_readB;
  input [T2_T3_NUMVBNK*T2_T3_BITVROW-1:0]   t6_addrB;
  input  [T2_T3_NUMVBNK*T2_T3_PHYWDTH-1:0]   t6_doutB;

  input                       t7_writeA;
  input [BITQPRT-1:0]         t7_addrA;
  input [BITPING-1:0]         t7_bwA;
  input [BITPING-1:0]         t7_dinA;
  input                       t7_readB;
  input [BITQPRT-1:0]         t7_addrB;
  input [BITPING-1:0]          t7_doutB;

  input                       t8_writeA;
  input [BITQPRT-1:0]         t8_addrA;
  input [BITPING-1:0]         t8_bwA;
  input [BITPING-1:0]         t8_dinA;
  input                       t8_writeB;
  input [BITQPRT-1:0]         t8_addrB;
  input [BITPING-1:0]         t8_bwB;
  input [BITPING-1:0]         t8_dinB;
  input                       t8_readC;
  input [BITQPRT-1:0]         t8_addrC;
  input [BITPING-1:0]          t8_doutC;
  input                       t8_readD;
  input [BITQPRT-1:0]         t8_addrD;
  input [BITPING-1:0]          t8_doutD;

  input                       t9_writeA;
  input [BITQPRT-1:0]         t9_addrA;
  input [BITQCNT-1:0]         t9_bwA;
  input [BITQCNT-1:0]         t9_dinA;
  input                       t9_writeB;
  input [BITQPRT-1:0]         t9_addrB;
  input [BITQCNT-1:0]         t9_bwB;
  input [BITQCNT-1:0]         t9_dinB;
  input                       t9_writeC;
  input [BITQPRT-1:0]         t9_addrC;
  input [BITQCNT-1:0]         t9_bwC;
  input [BITQCNT-1:0]         t9_dinC;
  input                       t9_readD;
  input [BITQPRT-1:0]         t9_addrD;
  input [BITQCNT-1:0]          t9_doutD;
  input                       t9_readE;
  input [BITQPRT-1:0]         t9_addrE;
  input [BITQCNT-1:0]          t9_doutE;
  input                       t9_readF;
  input [BITQPRT-1:0]         t9_addrF;
  input [BITQCNT-1:0]          t9_doutF;

  input                       t10_writeA;
  input [BITQPRT-1:0]         t10_addrA;
  input [NUMPING*(BITQPTR+BITMDAT)-1:0] t10_bwA;
  input [NUMPING*(BITQPTR+BITMDAT)-1:0] t10_dinA;
  input                       t10_writeB;
  input [BITQPRT-1:0]         t10_addrB;
  input [NUMPING*(BITQPTR+BITMDAT)-1:0] t10_bwB;
  input [NUMPING*(BITQPTR+BITMDAT)-1:0] t10_dinB;
  input                       t10_writeC;
  input [BITQPRT-1:0]         t10_addrC;
  input [NUMPING*(BITQPTR+BITMDAT)-1:0] t10_bwC;
  input [NUMPING*(BITQPTR+BITMDAT)-1:0] t10_dinC;
  input                       t10_readD;
  input [BITQPRT-1:0]         t10_addrD;
  input [NUMPING*(BITQPTR+BITMDAT)-1:0]  t10_doutD;
  input                       t10_readE;
  input [BITQPRT-1:0]         t10_addrE;
  input [NUMPING*(BITQPTR+BITMDAT)-1:0]  t10_doutE;
  input                       t10_readF;
  input [BITQPRT-1:0]         t10_addrF;
  input [NUMPING*(BITQPTR+BITMDAT)-1:0]  t10_doutF;

  input                       t11_writeA;
  input [BITQPRT-1:0]         t11_addrA;
  input [NUMPING*BITQPTR-1:0] t11_bwA;
  input [NUMPING*BITQPTR-1:0] t11_dinA;
  input                       t11_writeB;
  input [BITQPRT-1:0]         t11_addrB;
  input [NUMPING*BITQPTR-1:0] t11_bwB;
  input [NUMPING*BITQPTR-1:0] t11_dinB;
  input                       t11_readC;
  input [BITQPRT-1:0]         t11_addrC;
  input [NUMPING*BITQPTR-1:0]  t11_doutC;
  input                       t11_readD;
  input [BITQPRT-1:0]         t11_addrD;
  input [NUMPING*BITQPTR-1:0]  t11_doutD;

  input [NUMPUPT-1:0]                 t12_writeA;
  input [NUMPUPT*(BITQPTR-1)-1:0]     t12_addrA;
  input [NUMPUPT*T8_WIDTH-1:0]         t12_bwA;
  input [NUMPUPT*T8_WIDTH-1:0]         t12_dinA;
  input [NUMPUPT-1:0]                 t12_readB;
  input [NUMPUPT*(BITQPTR-1)-1:0]     t12_addrB;
  input [NUMPUPT*T8_WIDTH-1:0]          t12_doutB;

  reg push_wire [0:NUMPUPT-1];
  reg [BITQPRT-1:0] pu_prt_wire [0:NUMPUPT-1];
  integer p_int;
  always_comb begin
    for (p_int=0; p_int<NUMPUPT; p_int=p_int+1) begin: pu_loop
      push_wire[p_int] = push >> p_int;
      pu_prt_wire[p_int] = pu_prt >> (p_int*BITQPRT);
    end
  end
  
  reg [3:0] pushcnt;
  integer pcnt_int;
  always_comb begin
    pushcnt = 0;
    for (pcnt_int=0; pcnt_int<NUMPUPT; pcnt_int=pcnt_int+1)
      if (push_wire[pcnt_int])
        pushcnt = pushcnt + 1;
  end

  assert_push_empty: assert property (@(posedge clk) disable iff (rst) (freecnt >= pushcnt));

  genvar pcnta_var, pcntb_var;
  generate
    for (pcnta_var=0;pcnta_var<NUMPUPT;pcnta_var=pcnta_var+1) begin: pcnta_loop
      for (pcntb_var=0;pcntb_var<pcnta_var;pcntb_var=pcntb_var+1) begin: pcntb_loop
        assert_uniq_queue: assert property (@(posedge clk) disable iff (rst) (push_wire[pcnta_var] && push_wire[pcntb_var]) |-> (pu_prt_wire[pcnta_var] != pu_prt_wire[pcntb_var]));
      end
    end
  endgenerate

endmodule
