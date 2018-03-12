
/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */
module algo_1r1w_a418_sva_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 1, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,
parameter IP_NUMQPRT = 64, parameter IP_BITQPRT = 6, parameter IP_NUMPING = 4, parameter IP_BITPING = 2,

parameter T1_WIDTH = 13, parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 0, parameter T1_DELAY = 1, parameter T1_NUMVROW = 8192, parameter T1_BITVROW = 13,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 0, parameter T1_NUMSROW = 8192, parameter T1_BITSROW = 13, parameter T1_PHYWDTH = 32,
parameter T2_WIDTH = 32, parameter T2_NUMVBNK = 1, parameter T2_BITVBNK = 0, parameter T2_DELAY = 1, parameter T2_NUMVROW = 8192, parameter T2_BITVROW = 13,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 8192, parameter T2_BITSROW = 13, parameter T2_PHYWDTH = 32)
( clk,  rst,  ready,
  push, pu_prt, pu_ptr, pu_din, pu_cvld, pu_cnt,
  pop, po_prt, po_pvld, po_ptr, po_cvld, po_cnt, po_dvld, po_dout,
  cp_read, cp_write, cp_adr, cp_din, cp_vld, cp_dout,
  t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_readB, t1_addrB, t1_doutB,
  t2_writeA, t2_addrA, t2_dinA, t2_bwA, t2_readB, t2_addrB, t2_doutB);
  
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
  parameter QPTR_DELAY = 1;
  parameter LINK_DELAY = T1_DELAY;
  parameter DATA_DELAY = T2_DELAY;
  parameter NUMPOPT = 1;
  parameter NUMPUPT = 1;

  parameter BITQPTR = BITADDR;
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter BITCPAD = BITQPRT;
  parameter CPUWDTH = 2*BITPING+BITQCNT+2*NUMPING*BITQPTR;

  input [NUMPUPT-1:0]                 push;
  input [NUMPUPT*BITQPRT-1:0]         pu_prt;
  input [NUMPUPT*BITQPTR-1:0]         pu_ptr;
  input [NUMPUPT*WIDTH-1:0]           pu_din;
  input [NUMPUPT-1:0]                 pu_cvld;
  input [NUMPUPT*BITQCNT-1:0]         pu_cnt;

  input [NUMPOPT-1:0]                 pop;
  input [NUMPOPT*BITQPRT-1:0]         po_prt;
  input [NUMPOPT-1:0]                 po_pvld;
  input [NUMPOPT*BITQPTR-1:0]         po_ptr;
  input [NUMPOPT-1:0]                 po_cvld;
  input [NUMPOPT*BITQCNT-1:0]         po_cnt;
  input [NUMPOPT-1:0]                 po_dvld;
  input [NUMPOPT*WIDTH-1:0]           po_dout;

  input                               cp_read;
  input                               cp_write;
  input [BITCPAD-1:0]                 cp_adr;
  input [CPUWDTH-1:0]                 cp_din;
  input                               cp_vld;
  input [CPUWDTH-1:0]                 cp_dout;

  input                               ready;
  input                               clk, rst;

  input [NUMPUPT-1:0]                 t1_writeA;
  input [NUMPUPT*BITADDR-1:0]         t1_addrA;
  input [NUMPUPT*BITQPTR-1:0]         t1_bwA;
  input [NUMPUPT*BITQPTR-1:0]         t1_dinA;
  input [NUMPOPT-1:0]                 t1_readB;
  input [NUMPOPT*BITADDR-1:0]         t1_addrB;
  input [NUMPOPT*BITQPTR-1:0]         t1_doutB;

  input [NUMPUPT-1:0]                 t2_writeA;
  input [NUMPUPT*BITADDR-1:0]         t2_addrA;
  input [NUMPUPT*WIDTH-1:0]           t2_bwA;
  input [NUMPUPT*WIDTH-1:0]           t2_dinA;
  input [NUMPOPT-1:0]                 t2_readB;
  input [NUMPOPT*BITADDR-1:0]         t2_addrB;
  input [NUMPOPT*WIDTH-1:0]           t2_doutB;

  reg [BITQPRT-1:0] pu_prt_r [0:NUMPUPT-1];
  always_comb begin : puxf
    integer pui;
    for (pui=0;pui<NUMPUPT;pui=pui+1) begin
      pu_prt_r[pui] = pu_prt >> (pui*BITQPRT);
    end
  end

  reg [BITQPRT-1:0] po_prt_r [0:NUMPOPT-1];
  always_comb begin : poxf
    integer poi;
    for (poi=0;poi<NUMPOPT;poi=poi+1) begin
      po_prt_r[poi] = po_prt >> (poi*BITQPRT);
    end
  end

  reg [BITADDR:0] occ_cnt_nxt [0:NUMQPRT-1];
  reg [BITADDR:0] occ_cnt [0:NUMQPRT-1];
  always @(posedge clk) begin : occ_cnt_f
    integer q;
    if (rst)
      for (q=0;q<NUMQPRT;q=q+1)
        occ_cnt[q] <= 'h0;
    else
      for (q=0;q<NUMQPRT;q=q+1)
        occ_cnt[q] <= occ_cnt_nxt[q];
  end

  always_comb begin : occ_cnt_c
    integer q, pu, po;
    for (q =0;q<NUMQPRT;q=q+1)
      occ_cnt_nxt[q] = occ_cnt[q];
    for (pu=0;pu<NUMPUPT;pu=pu+1)
      if (push[pu]) begin
        occ_cnt_nxt[pu_prt_r[pu]] = occ_cnt_nxt[pu_prt_r[pu]] + 1;
      end
    for (po=0;po<NUMPOPT;po=po+1)
      if (pop[po]) begin
        occ_cnt_nxt[po_prt_r[po]] = occ_cnt_nxt[po_prt_r[po]] - 1;
      end
  end

  genvar p_a;
  generate begin : p_e_chk
    for (p_a=0;p_a<NUMPOPT;p_a=p_a+1) begin : port
      wire [BITQPRT-1:0] po_prt_wire = po_prt_r[p_a];
      assert_pop_empty_check: assert property (@(negedge clk) disable iff (rst || !ready) pop[p_a] |-> (occ_cnt[po_prt_wire] != 0))
        else $display("[ERROR:memoir:%m:%0t] empty queue pop que=0x%0x", $time, po_prt_wire);
    end
  end
  endgenerate

endmodule    //algo_1r2w_a116_sva_wrap
