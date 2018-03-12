module algo_1r1w_a417_top (clk, rst, ready,
                               push, pu_prt, pu_ptr, pu_din, pu_cvld, pu_cnt,
                               pop, po_ndq, po_prt, po_cvld, po_cmt, po_cnt, po_pvld, po_ptr, po_dvld, po_dout,
                               peek, pe_prt, pe_ptr, pe_cvld, pe_cmt, pe_nvld, pe_nxt, pe_dvld, pe_dout,
                               cp_read, cp_write, cp_adr, cp_din, cp_vld, cp_dout,
                               t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
                               t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
                               t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
                               t4_writeA, t4_addrA, t4_dinA, t4_readB, t4_addrB, t4_doutB,
                               t5_writeA, t5_addrA, t5_dinA, t5_readB, t5_addrB, t5_doutB,
                               t6_writeA, t6_addrA, t6_dinA, t6_readB, t6_addrB, t6_doutB,
                               t7_writeA, t7_addrA, t7_dinA, t7_readB, t7_addrB, t7_doutB,
                               t8_writeA, t8_addrA, t8_dinA, t8_readB, t8_addrB, t8_doutB,
                               t9_writeA, t9_addrA, t9_dinA, t9_readB, t9_addrB, t9_doutB,
                               t10_writeA, t10_addrA, t10_dinA, t10_readB, t10_addrB, t10_doutB,
                               t11_writeA, t11_addrA, t11_dinA, t11_readB, t11_addrB, t11_doutB);

  parameter WIDTH = 32;
  parameter DATA_WIDTH = 38;
  parameter BITWDTH = 5;
  parameter NUMQPRT = 64;
  parameter BITQPRT = 6;
  parameter NUMPING = 2;
  parameter BITPING = 1;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter QPTR_WIDTH = 19;
  parameter BITQCNT = BITADDR+1;
  parameter NUMPUPT = 6;
  parameter NUMPOPT = 1;
  parameter NUMPEPT = 1;
  parameter NUMVROW = 1024;  // ALGO2 Parameters
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMPBNK = 11;
  parameter BITPBNK = 4;
  parameter NUMWRDS = 4;     // ALIGN Parameters
  parameter BITWRDS = 2;
  parameter NUMSROW = 64;
  parameter BITSROW = 6;
  parameter NUMWROW = NUMSROW; // STACK Parameters
  parameter BITWROW = BITSROW;
  parameter NUMDBNK = 8;
  parameter BITDBNK = 3;
  parameter NUMDROW = 1024;
  parameter BITDROW = 10;
  parameter NUMWBNK = 1;
  parameter BITWBNK = 0;
  parameter QPTR_DELAY = 1;
  parameter LINK_DELAY = 2;
  parameter DATA_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;
  parameter FLOPOUT = 0;

  parameter POPTR_WIDTH  = 13;
  parameter POPTR_BITWDTH = 4;
  parameter POPTR_NUMRUPT = NUMPOPT;
  parameter POPTR_UPD_DELAY = 0;

  parameter PUPTR_WIDTH  = 13;
  parameter PUPTR_BITWDTH = 4;
  parameter PUPTR_NUMRUPT = NUMPOPT;
  parameter PUPTR_UPD_DELAY = 0;

  parameter CNTD_WIDTH   = 13;
  parameter CNTD_NUMVBNK = 1;
  parameter CNTD_BITVBNK = 0;
  parameter CNTD_DELAY   = 2;
  parameter CNTD_NUMVROW = 4096;
  parameter CNTD_BITVROW = 12;
  parameter CNTD_BITWSPF = 0;
  parameter CNTD_NUMWRDS = 1;
  parameter CNTD_BITWRDS = 0;
  parameter CNTD_NUMSROW = 4096;
  parameter CNTD_BITSROW = 12;
  parameter CNTD_PHYWDTH = 13;
  parameter CNT_NUMVBNK  = CNTD_NUMVBNK >> 1;
  parameter CNT_BITVBNK  = CNTD_BITVBNK-1;
  parameter CNT_BITPADR  = CNTD_BITSROW+CNT_BITVBNK;
  parameter CNTS_BITWDTH  = 5;

  parameter CNTC_WIDTH   = 13;
  parameter CNTC_NUMVBNK = 1;
  parameter CNTC_BITVBNK = 0;
  parameter CNTC_DELAY   = 2;
  parameter CNTC_NUMVROW = 4096;
  parameter CNTC_BITVROW = 12;
  parameter CNTC_BITWSPF = 0;
  parameter CNTC_NUMWRDS = 1;
  parameter CNTC_BITWRDS = 0;
  parameter CNTC_NUMSROW = 4096;
  parameter CNTC_BITSROW = 12;
  parameter CNTC_PHYWDTH = 13;

  parameter CNTS_WIDTH   = 13;
  parameter CNTS_NUMVBNK = 1;
  parameter CNTS_BITVBNK = 0;
  parameter CNTS_DELAY   = 2;
  parameter CNTS_NUMVROW = 4096;
  parameter CNTS_BITVROW = 12;
  parameter CNTS_BITWSPF = 0;
  parameter CNTS_NUMWRDS = 1;
  parameter CNTS_BITWRDS = 0;
  parameter CNTS_NUMSROW = 4096;
  parameter CNTS_BITSROW = 12;
  parameter CNTS_PHYWDTH = 13;

  parameter HEADD_WIDTH   = 13;
  parameter HEADD_NUMVBNK = 1;
  parameter HEADD_BITVBNK = 0;
  parameter HEADD_DELAY   = 2;
  parameter HEADD_NUMVROW = 4096;
  parameter HEADD_BITVROW = 12;
  parameter HEADD_BITWSPF = 0;
  parameter HEADD_NUMWRDS = 1;
  parameter HEADD_BITWRDS = 0;
  parameter HEADD_NUMSROW = 4096;
  parameter HEADD_BITSROW = 12;
  parameter HEADD_PHYWDTH = 13;
  parameter HEAD_NUMVBNK  = HEADD_NUMVBNK >> 1;
  parameter HEAD_BITVBNK  = HEADD_BITVBNK-1;
  parameter HEAD_BITPADR  = HEADD_BITSROW+HEAD_BITVBNK;
  parameter HEADS_BITWDTH = 5;

  parameter HEADC_WIDTH   = 13;
  parameter HEADC_NUMVBNK = 1;
  parameter HEADC_BITVBNK = 0;
  parameter HEADC_DELAY   = 2;
  parameter HEADC_NUMVROW = 4096;
  parameter HEADC_BITVROW = 12;
  parameter HEADC_BITWSPF = 0;
  parameter HEADC_NUMWRDS = 1;
  parameter HEADC_BITWRDS = 0;
  parameter HEADC_NUMSROW = 4096;
  parameter HEADC_BITSROW = 12;
  parameter HEADC_PHYWDTH = 13;

  parameter HEADS_WIDTH   = 13;
  parameter HEADS_NUMVBNK = 1;
  parameter HEADS_BITVBNK = 0;
  parameter HEADS_DELAY   = 2;
  parameter HEADS_NUMVROW = 4096;
  parameter HEADS_BITVROW = 12;
  parameter HEADS_BITWSPF = 0;
  parameter HEADS_NUMWRDS = 1;
  parameter HEADS_BITWRDS = 0;
  parameter HEADS_NUMSROW = 4096;
  parameter HEADS_BITSROW = 12;
  parameter HEADS_PHYWDTH = 13;

  parameter TAIL_WIDTH   = 13;
  parameter TAIL_NUMVBNK = 1;
  parameter TAIL_BITVBNK = 0;
  parameter TAIL_DELAY   = 2;
  parameter TAIL_NUMVROW = 4096;
  parameter TAIL_BITVROW = 12;
  parameter TAIL_BITWSPF = 0;
  parameter TAIL_NUMWRDS = 1;
  parameter TAIL_BITWRDS = 0;
  parameter TAIL_NUMSROW = 4096;
  parameter TAIL_BITSROW = 12;
  parameter TAIL_PHYWDTH = 13;

  parameter CNT_NUMRUPT = 2;
  parameter HEAD_NUMRUPT = 2;

  parameter BITQPTR = BITADDR;
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter BITCPAD = BITQPRT;
  parameter CPUWDTH = 2*BITPING+BITQCNT+2*NUMPING*BITQPTR;

  parameter CNTS_ECCWDTH = CNTS_WIDTH - 2*(CNTD_BITVBNK);
  parameter HEADS_ECCWDTH = HEADS_WIDTH - 2*(HEADD_BITVBNK);

  parameter TAIL_BITWDTH = 7;
  parameter TAIL_UPD_DELAY = 0;
  parameter TAIL_NUMRUPT = NUMPOPT;

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
  output [NUMPUPT*QPTR_WIDTH-1:0]          t1_dinA;
  output [NUMPOPT-1:0]                     t1_readB;
  output [NUMPOPT*BITADDR-1:0]             t1_addrB;
  input [NUMPOPT*QPTR_WIDTH-1:0]           t1_doutB;

  output [NUMPUPT-1:0]                     t2_writeA;
  output [NUMPUPT*BITADDR-1:0]             t2_addrA;
  output [NUMPUPT*DATA_WIDTH-1:0]          t2_dinA;
  output [NUMPOPT-1:0]                     t2_readB;
  output [NUMPOPT*BITADDR-1:0]             t2_addrB;
  input [NUMPOPT*DATA_WIDTH-1:0]           t2_doutB;

  output [NUMPOPT-1:0]                     t3_writeA;
  output [NUMPOPT*BITQPRT-1:0]             t3_addrA;
  output [NUMPOPT*POPTR_WIDTH-1:0]         t3_dinA;
  output [NUMPOPT-1:0]                     t3_readB;
  output [NUMPOPT*BITQPRT-1:0]             t3_addrB;
  input [NUMPOPT*POPTR_WIDTH-1:0]          t3_doutB;

  output [NUMPUPT-1:0]                     t4_writeA;
  output [NUMPUPT*BITQPRT-1:0]             t4_addrA;
  output [NUMPUPT*PUPTR_WIDTH-1:0]         t4_dinA;
  output [NUMPUPT-1:0]                     t4_readB;
  output [NUMPUPT*BITQPRT-1:0]             t4_addrB;
  input [NUMPUPT*PUPTR_WIDTH-1:0]          t4_doutB;

  output [CNTD_NUMVBNK-1:0]                t5_writeA;
  output [CNTD_NUMVBNK*CNTD_BITSROW-1:0]   t5_addrA;
  output [CNTD_NUMVBNK*CNTD_WIDTH-1:0]     t5_dinA;
  output [CNTD_NUMVBNK-1:0]                t5_readB;
  output [CNTD_NUMVBNK*CNTD_BITSROW-1:0]   t5_addrB;
  input  [CNTD_NUMVBNK*CNTD_WIDTH-1:0]     t5_doutB;

  output [CNTC_NUMVBNK-1:0]                t6_writeA;
  output [CNTC_NUMVBNK*CNTC_BITSROW-1:0]   t6_addrA;
  output [CNTC_NUMVBNK*CNTC_WIDTH-1:0]     t6_dinA;
  output [CNTC_NUMVBNK-1:0]                t6_readB;
  output [CNTC_NUMVBNK*CNTC_BITSROW-1:0]   t6_addrB;
  input  [CNTC_NUMVBNK*CNTC_WIDTH-1:0]     t6_doutB;

  output [CNTS_NUMVBNK-1:0]                t7_writeA;
  output [CNTS_NUMVBNK*CNTS_BITSROW-1:0]   t7_addrA;
  output [CNTS_NUMVBNK*CNTS_WIDTH-1:0]     t7_dinA;
  output [CNTS_NUMVBNK-1:0]                t7_readB;
  output [CNTS_NUMVBNK*CNTS_BITSROW-1:0]   t7_addrB;
  input  [CNTS_NUMVBNK*CNTS_WIDTH-1:0]     t7_doutB;

  output [HEADD_NUMVBNK-1:0]               t8_writeA;
  output [HEADD_NUMVBNK*HEADD_BITSROW-1:0] t8_addrA;
  output [HEADD_NUMVBNK*HEADD_WIDTH-1:0]   t8_dinA;
  output [HEADD_NUMVBNK-1:0]               t8_readB;
  output [HEADD_NUMVBNK*HEADD_BITSROW-1:0] t8_addrB;
  input  [HEADD_NUMVBNK*HEADD_WIDTH-1:0]   t8_doutB;

  output [HEADC_NUMVBNK-1:0]               t9_writeA;
  output [HEADC_NUMVBNK*HEADC_BITSROW-1:0] t9_addrA;
  output [HEADC_NUMVBNK*HEADC_WIDTH-1:0]   t9_dinA;
  output [HEADC_NUMVBNK-1:0]               t9_readB;
  output [HEADC_NUMVBNK*HEADC_BITSROW-1:0] t9_addrB;
  input  [HEADC_NUMVBNK*HEADC_WIDTH-1:0]   t9_doutB;

  output [HEADS_NUMVBNK-1:0]               t10_writeA;
  output [HEADS_NUMVBNK*HEADS_BITSROW-1:0] t10_addrA;
  output [HEADS_NUMVBNK*HEADS_WIDTH-1:0]   t10_dinA;
  output [HEADS_NUMVBNK-1:0]               t10_readB;
  output [HEADS_NUMVBNK*HEADS_BITSROW-1:0] t10_addrB;
  input  [HEADS_NUMVBNK*HEADS_WIDTH-1:0]   t10_doutB;

  output [NUMPUPT-1:0]                     t11_writeA;
  output [NUMPUPT*BITQPRT-1:0]             t11_addrA;
  output [NUMPUPT*TAIL_WIDTH-1:0]          t11_dinA;
  output [NUMPUPT-1:0]                     t11_readB;
  output [NUMPUPT*BITQPRT-1:0]             t11_addrB;
  input [NUMPUPT*TAIL_WIDTH-1:0]           t11_doutB;

`ifdef FORMAL 

wire [BITQPRT-1:0] select_qprt;
wire [BITADDR-1:0] select_addr;
assume_select_qprt_range: assume property (@(posedge clk) disable iff (rst) (select_qprt < NUMQPRT));
assume_select_qprt_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_qprt));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));

wire [BITVROW-1:0] select_vrow;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  adr_a2 (.vbadr(), .vradr(select_vrow), .vaddr(select_addr));
  
wire [BITSROW-1:0] select_srow;
np2_addr #(
  .NUMADDR (NUMVROW), .BITADDR (BITVROW),
  .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
  .NUMVROW (NUMSROW), .BITVROW (BITSROW))
  vrow_inst (.vbadr(), .vradr(select_srow), .vaddr(select_vrow));


wire [CNTD_BITVROW-1:0] select_cnt_vrow;
np2_addr #(
  .NUMADDR (NUMQPRT), .BITADDR (BITQPRT),
  .NUMVBNK (CNT_NUMVBNK), .BITVBNK (CNT_BITVBNK),
  .NUMVROW (CNTD_NUMVROW), .BITVROW (CNTD_BITVROW))
  adr_a2_cnt (.vbadr(), .vradr(select_cnt_vrow), .vaddr(select_addr));
  
wire [CNTD_BITSROW-1:0] select_cnt_srow;
np2_addr #(
  .NUMADDR (CNTD_NUMVROW), .BITADDR (CNTD_BITVROW),
  .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
  .NUMVROW (CNTD_NUMSROW), .BITVROW (CNTD_BITSROW))
  vrow_inst_cnt (.vbadr(), .vradr(select_cnt_srow), .vaddr(select_cnt_vrow));

wire [HEADD_BITVROW-1:0] select_head_vrow;
np2_addr #(
  .NUMADDR (NUMQPRT), .BITADDR (BITQPRT),
  .NUMVBNK (HEAD_NUMVBNK), .BITVBNK (HEAD_BITVBNK),
  .NUMVROW (HEADD_NUMVROW), .BITVROW (HEADD_BITVROW))
  adr_a2_head (.vbadr(), .vradr(select_head_vrow), .vaddr(select_addr));
  
wire [HEADD_BITSROW-1:0] select_head_srow;
np2_addr #(
  .NUMADDR (HEADD_NUMVROW), .BITADDR (HEADD_BITVROW),
  .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
  .NUMVROW (HEADD_NUMSROW), .BITVROW (HEADD_BITSROW))
  vrow_inst_head (.vbadr(), .vradr(select_head_srow), .vaddr(select_head_vrow));

wire [TAIL_BITVROW-1:0] select_tail_vrow;  
np2_addr #(
  .NUMADDR (NUMQPRT), .BITADDR (BITQPRT),
  .NUMVBNK (TAIL_NUMVBNK), .BITVBNK (TAIL_BITVBNK),
  .NUMVROW (TAIL_NUMVROW), .BITVROW (TAIL_BITVROW))
  adr_tail (.vbadr(), .vradr(select_tail_vrow), .vaddr(select_qprt));

wire [TAIL_BITSROW-1:0] select_tail_srow;
np2_addr #(
  .NUMADDR (TAIL_NUMVROW), .BITADDR (TAIL_BITVROW),
  .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
  .NUMVROW (TAIL_NUMSROW), .BITVROW (TAIL_BITSROW))
  vrow_tail (.vbadr(), .vradr(select_tail_srow), .vaddr(select_tail_vrow));

`else
wire [BITQPRT-1:0] select_qprt = 0;
wire [BITADDR-1:0] select_addr = 0;
wire [BITVROW-1:0] select_vrow = 0;
wire [BITSROW-1:0] select_srow = 0;
wire [BITDROW-1:0] select_drow = 0;

wire [CNTS_BITVROW-1:0] select_cnt_vrow = 0;
wire [CNTS_BITSROW-1:0] select_cnt_srow = 0;
wire [HEADS_BITVROW-1:0] select_head_vrow = 0;
wire [HEADS_BITSROW-1:0] select_head_srow = 0;
wire [TAIL_BITVROW-1:0] select_tail_vrow = 0;
wire [TAIL_BITSROW-1:0] select_tail_srow = 0;
/*
*/
`endif

wire [(NUMPOPT+NUMPUPT)*BITQCNT-1:0]         t5_doutB_a1;
reg  [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t6_doutB_a1;
wire [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t6_doutB_a1_int;
wire [NUMPUPT*NUMPING*BITQPTR-1:0]           t7_doutB_a1;

wire [NUMPUPT-1:0]                     t1_writeA_a1;
wire [NUMPUPT*BITADDR-1:0]             t1_addrA_a1;
wire [NUMPUPT*BITQPTR-1:0]             t1_dinA_a1;
wire [NUMPOPT-1:0]                     t1_readB_a1;
wire [NUMPOPT*BITADDR-1:0]             t1_addrB_a1;
reg  [NUMPOPT*BITQPTR-1:0]             t1_doutB_a1;
reg  [NUMPOPT-1:0]                     t1_fwrdB_a1;
reg  [NUMPOPT-1:0]                     t1_serrB_a1;
reg  [NUMPOPT-1:0]                     t1_derrB_a1;
reg  [NUMPOPT*BITADDR-1:0]             t1_padrB_a1;

wire [NUMPUPT-1:0]                     t2_writeA_a1;
wire [NUMPUPT*BITADDR-1:0]             t2_addrA_a1;
wire [NUMPUPT*WIDTH-1:0]               t2_dinA_a1;
wire [NUMPOPT-1:0]                     t2_readB_a1;
wire [NUMPOPT*BITADDR-1:0]             t2_addrB_a1;

reg  [NUMPOPT*WIDTH-1:0]               t2_doutB_a1;
reg  [NUMPOPT-1:0]                     t2_fwrdB_a1;
reg  [NUMPOPT-1:0]                     t2_serrB_a1;
reg  [NUMPOPT-1:0]                     t2_derrB_a1;
reg  [NUMPOPT*BITADDR-1:0]             t2_padrB_a1;

wire [NUMPOPT-1:0]                     t3_writeA_a1;
wire [NUMPOPT*BITQPRT-1:0]             t3_addrA_a1;
wire [NUMPOPT*BITPING-1:0]             t3_dinA_a1;
wire [NUMPOPT-1:0]                     t3_readB_a1;
wire [NUMPOPT*BITQPRT-1:0]             t3_addrB_a1;

wire [NUMPOPT*BITPING-1:0]             t3_doutB_a1;
wire [NUMPOPT-1:0]                     t3_fwrdB_a1;
wire [NUMPOPT-1:0]                     t3_serrB_a1;
wire [NUMPOPT-1:0]                     t3_derrB_a1;
wire [NUMPOPT*BITQPRT-1:0]             t3_padrB_a1;

wire [NUMPUPT-1:0]                     t4_writeA_a1;
wire [NUMPUPT*BITQPRT-1:0]             t4_addrA_a1;
wire [NUMPUPT*BITPING-1:0]             t4_dinA_a1;
wire [NUMPUPT-1:0]                     t4_readB_a1;
wire [NUMPUPT*BITQPRT-1:0]             t4_addrB_a1;

wire [NUMPUPT*BITPING-1:0]             t4_doutB_a1;
wire [NUMPUPT-1:0]                     t4_fwrdB_a1;
wire [NUMPUPT-1:0]                     t4_serrB_a1;
wire [NUMPUPT-1:0]                     t4_derrB_a1;
wire [NUMPUPT*BITQPRT-1:0]             t4_padrB_a1;

wire [(NUMPOPT+NUMPUPT)-1:0]           t5_writeA_a1;
wire [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t5_addrA_a1;
wire [(NUMPOPT+NUMPUPT)*BITQCNT-1:0]   t5_dinA_a1;
wire [(NUMPOPT+NUMPUPT)-1:0]           t5_readB_a1;
wire [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t5_addrB_a1;

wire [(NUMPOPT+NUMPUPT)-1:0]           t6_writeA_a1;
wire [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t6_addrA_a1;
wire [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t6_dinA_a1;
wire [(NUMPOPT+NUMPUPT)-1:0]           t6_readB_a1;
wire [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t6_addrB_a1;


wire [NUMPUPT-1:0]                     t11_writeA_a1;
wire [NUMPUPT*BITQPRT-1:0]             t11_addrA_a1;
wire [NUMPUPT*NUMPING*BITQPTR-1:0]     t11_dinA_a1;
wire [NUMPOPT-1:0]                     t11_readB_a1;
wire [NUMPOPT*BITQPRT-1:0]             t11_addrB_a1;

reg  [NUMPOPT*NUMPING*BITQPTR-1:0]     t11_doutB_a1;
reg  [NUMPOPT-1:0]                     t11_fwrdB_a1;
reg  [NUMPOPT-1:0]                     t11_serrB_a1;
reg  [NUMPOPT-1:0]                     t11_derrB_a1;
reg  [NUMPOPT*BITADDR-1:0]             t11_padrB_a1;

wire /*a3_ready, a4_ready,*/a5_ready, a6_ready, a7_ready;

wire rst_int = rst ||/* !a3_ready || !a4_ready ||*/ !a5_ready || !a6_ready || !a7_ready;

generate if (1) begin: a1_loop

  algo_mrnw_pque_f32b #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMPUPT (NUMPUPT), .NUMPOPT (NUMPOPT), .NUMPEPT(NUMPEPT),
                        .NUMQPRT (NUMQPRT), .BITQPRT (BITQPRT), .NUMPING (NUMPING), .BITPING (BITPING),
                        .NUMADDR (NUMADDR), .BITADDR (BITADDR), .BITPADR (BITPADR-1),
                        .QPTR_DELAY(QPTR_DELAY+FLOPECC), .LINK_DELAY(LINK_DELAY+FLOPECC), .DATA_DELAY(DATA_DELAY+FLOPECC), .FLOPIN (FLOPIN), .FLOPOUT(FLOPOUT))
    algo (.ready(ready), .clk(clk), .rst (rst_int),
          .push(push), .pu_prt(pu_prt), .pu_ptr(pu_ptr), .pu_din(pu_din), .pu_cvld(pu_cvld), .pu_cnt(pu_cnt),
          .pop(pop), .po_ndq(po_ndq), .po_prt(po_prt), .po_cvld(po_cvld), .po_cmt(po_cmt), .po_cnt(po_cnt),
          .po_pvld(po_pvld), .po_ptr(po_ptr), .po_dvld(po_dvld), .po_dout(po_dout),
          .peek(peek), .pe_prt(pe_prt), .pe_ptr(pe_ptr), .pe_cvld(pe_cvld), .pe_cmt(pe_cmt), .pe_nvld(pe_nvld), .pe_nxt(pe_nxt), .pe_dvld(pe_dvld), .pe_dout(pe_dout),
          .cp_read(cp_read), .cp_write(cp_write), .cp_adr(cp_adr), .cp_din(cp_din), .cp_vld(cp_vld), .cp_dout(cp_dout),
          .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1), .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1),
          .t2_writeA(t2_writeA_a1), .t2_addrA(t2_addrA_a1), .t2_dinA(t2_dinA_a1), .t2_readB(t2_readB_a1), .t2_addrB(t2_addrB_a1), .t2_doutB(t2_doutB_a1),
          .t3_writeA(t3_writeA_a1), .t3_addrA(t3_addrA_a1), .t3_dinA(t3_dinA_a1), .t3_readB(t3_readB_a1), .t3_addrB(t3_addrB_a1), .t3_doutB(t3_doutB_a1),
          .t4_writeA(t4_writeA_a1), .t4_addrA(t4_addrA_a1), .t4_dinA(t4_dinA_a1), .t4_readB(t4_readB_a1), .t4_addrB(t4_addrB_a1), .t4_doutB(t4_doutB_a1),
          .t5_writeA(t5_writeA_a1), .t5_addrA(t5_addrA_a1), .t5_dinA(t5_dinA_a1), .t5_readB(t5_readB_a1), .t5_addrB(t5_addrB_a1), .t5_doutB(t5_doutB_a1),
          .t6_writeA(t6_writeA_a1), .t6_addrA(t6_addrA_a1), .t6_dinA(t6_dinA_a1), .t6_readB(t6_readB_a1), .t6_addrB(t6_addrB_a1), .t6_doutB(t6_doutB_a1),
          .t7_writeA(t11_writeA_a1), .t7_addrA(t11_addrA_a1), .t7_dinA(t11_dinA_a1), .t7_readB(t11_readB_a1), .t7_addrB(t11_addrB_a1), .t7_doutB(t11_doutB_a1),
          .select_qprt (select_qprt), .select_addr (select_addr));

end
endgenerate

wire t1_writeA_wire [0:NUMPUPT-1];
wire [BITADDR-1:0] t1_addrA_wire [0:NUMPUPT-1];
wire [QPTR_WIDTH-1:0] t1_bwA_wire [0:NUMPUPT-1];
wire [QPTR_WIDTH-1:0] t1_dinA_wire [0:NUMPUPT-1];
wire t1_readB_wire [0:NUMPOPT-1];
wire [BITADDR-1:0] t1_addrB_wire [0:NUMPOPT-1];
wire [BITQPTR-1:0] t1_doutB_a1_wire [0:NUMPOPT-1];
wire t1_fwrdB_a1_wire [0:NUMPOPT-1];
wire t1_serrB_a1_wire [0:NUMPOPT-1];
wire t1_derrB_a1_wire [0:NUMPOPT-1];
wire [BITADDR-1:0] t1_padrB_a1_wire [0:NUMPOPT-1];

genvar t1r;
generate
  for (t1r=0; t1r<NUMPUPT; t1r=t1r+1) begin: t1r_loop
    wire t1_writeA_a1_wire = t1_writeA_a1 >> (t1r);
    wire [BITADDR-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> (t1r*BITADDR);
    wire [BITQPTR-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> (t1r*WIDTH);
    wire t1_readB_a1_wire = t1_readB_a1 >> (t1r);
    wire [BITADDR-1:0] t1_addrB_a1_wire = t1_addrB_a1 >> (t1r*BITADDR);

    wire [NUMPOPT*QPTR_WIDTH-1:0] t1_doutB_wire = t1_doutB >> (t1r*QPTR_WIDTH);

    wire t1_mem_write_wire;
    wire [BITADDR-1:0] t1_mem_wr_adr_wire;
    wire [QPTR_WIDTH-1:0] t1_mem_bw_wire;
    wire [QPTR_WIDTH-1:0] t1_mem_din_wire;
    wire t1_mem_read_wire;
    wire [BITADDR-1:0] t1_mem_rd_adr_wire;
    wire [QPTR_WIDTH-1:0] t1_mem_rd_dout_wire;
    wire t1_mem_rd_fwrd_wire;
    wire t1_mem_rd_serr_wire;
    wire t1_mem_rd_derr_wire;
    wire [BITADDR-1:0] t1_mem_rd_padr_wire;

    if (1) begin: align_loop
      infra_align_ecc_1r1w #(.WIDTH (BITQPTR), .ENAPSDO (NUMWRDS==1), .ENAECC (1), .ECCWDTH (QPTR_WIDTH-BITQPTR), .ENAPADR (0),
                             .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                             .NUMSROW (NUMADDR), .BITSROW (BITADDR), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITADDR),
                             .SRAM_DELAY (QPTR_DELAY), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC))
        infra (.write(t1_writeA_a1_wire), .wr_adr(t1_addrA_a1_wire), .din(t1_dinA_a1_wire),
               .read(t1_readB_a1_wire), .rd_adr(t1_addrB_a1_wire),
               .rd_dout(t1_doutB_a1_wire[t1r]), .rd_fwrd(t1_fwrdB_a1_wire[t1r]),
               .rd_serr(t1_serrB_a1_wire[t1r]), .rd_derr(t1_derrB_a1_wire[t1r]), .rd_padr(t1_padrB_a1_wire[t1r]),
               .mem_write (t1_mem_write_wire), .mem_wr_adr(t1_mem_wr_adr_wire), .mem_bw (t1_mem_bw_wire), .mem_din (t1_mem_din_wire),
               .mem_read (t1_mem_read_wire), .mem_rd_adr(t1_mem_rd_adr_wire), .mem_rd_dout (t1_mem_rd_dout_wire),
               .mem_rd_fwrd(t1_mem_rd_fwrd_wire), .mem_rd_padr(t1_mem_rd_padr_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_vrow));
    end

    if (1) begin: stack_loop
      infra_stack_1r1w #(.WIDTH (QPTR_WIDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (NUMSROW), .BITADDR (BITSROW),
                         .NUMWROW (NUMADDR), .BITWROW (BITADDR), .NUMWBNK (1), .BITWBNK (0),
                         .SRAM_DELAY (QPTR_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
        infra (.write (t1_mem_write_wire), .wr_adr (t1_mem_wr_adr_wire), .bw (t1_mem_bw_wire), .din (t1_mem_din_wire),
               .read (t1_mem_read_wire), .rd_adr (t1_mem_rd_adr_wire), .rd_dout (t1_mem_rd_dout_wire),
               .rd_fwrd (t1_mem_rd_fwrd_wire), .rd_serr (t1_mem_rd_serr_wire), .rd_derr(t1_mem_rd_derr_wire), .rd_padr(t1_mem_rd_padr_wire),
               .mem_write (t1_writeA_wire[t1r]), .mem_wr_adr(t1_addrA_wire[t1r]),
               .mem_bw (t1_bwA_wire[t1r]), .mem_din (t1_dinA_wire[t1r]),
               .mem_read (t1_readB_wire[t1r]), .mem_rd_adr(t1_addrB_wire[t1r]), .mem_rd_dout (t1_doutB_wire),
               .clk (clk), .rst(rst),
               .select_addr (select_srow));
    end
  end
endgenerate

reg [NUMPUPT-1:0] t1_writeA;
reg [NUMPUPT*BITADDR-1:0] t1_addrA;
reg [NUMPUPT*QPTR_WIDTH-1:0] t1_bwA;
reg [NUMPUPT*QPTR_WIDTH-1:0] t1_dinA;
reg [NUMPOPT-1:0] t1_readB;
reg [NUMPOPT*BITADDR-1:0] t1_addrB;
integer t1r_int;
always_comb begin
  t1_writeA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  t1_readB = 0;
  t1_addrB = 0;
  t1_doutB_a1 = 0;
  t1_fwrdB_a1 = 0;
  t1_serrB_a1 = 0;
  t1_derrB_a1 = 0;
  t1_padrB_a1 = 0;
  for (t1r_int=0; t1r_int<NUMPUPT; t1r_int=t1r_int+1) begin
    t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int] << (t1r_int));
    t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int] << (t1r_int*BITADDR));
    t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int] << (t1r_int*QPTR_WIDTH));
    t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int] << (t1r_int*QPTR_WIDTH));
    t1_readB = t1_readB | (t1_readB_wire[t1r_int] << (t1r_int));
    t1_addrB = t1_addrB | (t1_addrB_wire[t1r_int] << (t1r_int*BITADDR));
    t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[t1r_int] << (t1r_int*BITQPTR));
    t1_fwrdB_a1 = t1_fwrdB_a1 | (t1_fwrdB_a1_wire[t1r_int] << (t1r_int));
    t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_wire[t1r_int] << (t1r_int));
    t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[t1r_int] << (t1r_int));
    t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_wire[t1r_int] << (t1r_int*BITADDR));
  end
end


wire t2_writeA_wire [0:NUMPUPT-1];
wire [BITADDR-1:0] t2_addrA_wire [0:NUMPUPT-1];
wire [DATA_WIDTH-1:0] t2_bwA_wire [0:NUMPUPT-1];
wire [DATA_WIDTH-1:0] t2_dinA_wire [0:NUMPUPT-1];
wire t2_readB_wire [0:NUMPOPT-1];
wire [BITADDR-1:0] t2_addrB_wire [0:NUMPOPT-1];
wire [WIDTH-1:0] t2_doutB_a1_wire [0:NUMPOPT-1];
wire t2_fwrdB_a1_wire [0:NUMPOPT-1];
wire t2_serrB_a1_wire [0:NUMPOPT-1];
wire t2_derrB_a1_wire [0:NUMPOPT-1];
wire [BITADDR-1:0] t2_padrB_a1_wire [0:NUMPOPT-1];

genvar t2r;
generate
  for (t2r=0; t2r<NUMPUPT; t2r=t2r+1) begin: t2r_loop
    wire t2_writeA_a1_wire = t2_writeA_a1 >> (t2r);
    wire [BITADDR-1:0] t2_addrA_a1_wire = t2_addrA_a1 >> (t2r*BITADDR);
    wire [WIDTH-1:0] t2_dinA_a1_wire = t2_dinA_a1 >> (t2r*WIDTH);
    wire t2_readB_a1_wire = t2_readB_a1 >> (t2r);
    wire [BITADDR-1:0] t2_addrB_a1_wire = t2_addrB_a1 >> (t2r*BITADDR);

    wire [NUMPOPT*DATA_WIDTH-1:0] t2_doutB_wire = t2_doutB >> (t2r*DATA_WIDTH);

    wire t2_mem_write_wire;
    wire [BITADDR-1:0] t2_mem_wr_adr_wire;
    wire [DATA_WIDTH-1:0] t2_mem_bw_wire;
    wire [DATA_WIDTH-1:0] t2_mem_din_wire;
    wire t2_mem_read_wire;
    wire [BITADDR-1:0] t2_mem_rd_adr_wire;
    wire [DATA_WIDTH-1:0] t2_mem_rd_dout_wire;
    wire t2_mem_rd_fwrd_wire;
    wire t2_mem_rd_serr_wire;
    wire t2_mem_rd_derr_wire;
    wire [BITADDR-1:0] t2_mem_rd_padr_wire;

    if (1) begin: align_loop
      infra_align_ecc_1r1w #(.WIDTH (WIDTH), .ENAPSDO (NUMWRDS==1), .ENAECC (1), .ECCWDTH (DATA_WIDTH-WIDTH), .ENAPADR (0),
                             .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                             .NUMSROW (NUMADDR), .BITSROW (BITADDR), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITADDR),
                             .SRAM_DELAY (QPTR_DELAY), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC))
        infra (.write(t2_writeA_a1_wire), .wr_adr(t2_addrA_a1_wire), .din(t2_dinA_a1_wire),
               .read(t2_readB_a1_wire), .rd_adr(t2_addrB_a1_wire),
               .rd_dout(t2_doutB_a1_wire[t2r]), .rd_fwrd(t2_fwrdB_a1_wire[t2r]),
               .rd_serr(t2_serrB_a1_wire[t2r]), .rd_derr(t2_derrB_a1_wire[t2r]), .rd_padr(t2_padrB_a1_wire[t2r]),
               .mem_write (t2_mem_write_wire), .mem_wr_adr(t2_mem_wr_adr_wire), .mem_bw (t2_mem_bw_wire), .mem_din (t2_mem_din_wire),
               .mem_read (t2_mem_read_wire), .mem_rd_adr(t2_mem_rd_adr_wire), .mem_rd_dout (t2_mem_rd_dout_wire),
               .mem_rd_fwrd(t2_mem_rd_fwrd_wire), .mem_rd_padr(t2_mem_rd_padr_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_vrow));
    end

    if (1) begin: stack_loop
      infra_stack_1r1w #(.WIDTH (DATA_WIDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                         .NUMWROW (NUMADDR), .BITWROW (BITADDR), .NUMWBNK (1), .BITWBNK (0),
                         .SRAM_DELAY (QPTR_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
        infra (.write (t2_mem_write_wire), .wr_adr (t2_mem_wr_adr_wire), .bw (t2_mem_bw_wire), .din (t2_mem_din_wire),
               .read (t2_mem_read_wire), .rd_adr (t2_mem_rd_adr_wire), .rd_dout (t2_mem_rd_dout_wire),
               .rd_fwrd (t2_mem_rd_fwrd_wire), .rd_serr (t2_mem_rd_serr_wire), .rd_derr(t2_mem_rd_derr_wire), .rd_padr(t2_mem_rd_padr_wire),
               .mem_write (t2_writeA_wire[t2r]), .mem_wr_adr(t2_addrA_wire[t2r]),
               .mem_bw (t2_bwA_wire[t2r]), .mem_din (t2_dinA_wire[t2r]),
               .mem_read (t2_readB_wire[t2r]), .mem_rd_adr(t2_addrB_wire[t2r]), .mem_rd_dout (t2_doutB_wire),
               .clk (clk), .rst(rst),
               .select_addr (select_srow));
    end
  end
endgenerate

reg [NUMPUPT-1:0] t2_writeA;
reg [NUMPUPT*BITADDR-1:0] t2_addrA;
reg [NUMPUPT*DATA_WIDTH-1:0] t2_bwA;
reg [NUMPUPT*DATA_WIDTH-1:0] t2_dinA;
reg [NUMPOPT-1:0] t2_readB;
reg [NUMPOPT*BITADDR-1:0] t2_addrB;
integer t2r_int;
always_comb begin
  t2_writeA = 0;
  t2_addrA = 0;
  t2_bwA = 0;
  t2_dinA = 0;
  t2_readB = 0;
  t2_addrB = 0;
  t2_doutB_a1 = 0;
  t2_fwrdB_a1 = 0;
  t2_serrB_a1 = 0;
  t2_derrB_a1 = 0;
  t2_padrB_a1 = 0;
  for (t2r_int=0; t2r_int<NUMPUPT; t2r_int=t2r_int+1) begin
    t2_writeA = t2_writeA | (t2_writeA_wire[t2r_int] << (t2r_int));
    t2_addrA = t2_addrA | (t2_addrA_wire[t2r_int] << (t2r_int*BITADDR));
    t2_bwA = t2_bwA | (t2_bwA_wire[t2r_int] << (t2r_int*DATA_WIDTH));
    t2_dinA = t2_dinA | (t2_dinA_wire[t2r_int] << (t2r_int*DATA_WIDTH));
    t2_readB = t2_readB | (t2_readB_wire[t2r_int] << (t2r_int));
    t2_addrB = t2_addrB | (t2_addrB_wire[t2r_int] << (t2r_int*BITADDR));
    t2_doutB_a1 = t2_doutB_a1 | (t2_doutB_a1_wire[t2r_int] << (t2r_int*WIDTH));
    t2_fwrdB_a1 = t2_fwrdB_a1 | (t2_fwrdB_a1_wire[t2r_int] << (t2r_int));
    t2_serrB_a1 = t2_serrB_a1 | (t2_serrB_a1_wire[t2r_int] << (t2r_int));
    t2_derrB_a1 = t2_derrB_a1 | (t2_derrB_a1_wire[t2r_int] << (t2r_int));
    t2_padrB_a1 = t2_padrB_a1 | (t2_padrB_a1_wire[t2r_int] << (t2r_int*BITADDR));
  end
end

wire [NUMPOPT-1:0]                     t3_writeA_a3;
wire [NUMPOPT*BITQPRT-3:0]             t3_addrA_a3;
wire [NUMPOPT*4*BITPING-1:0]           t3_dinA_a3;
wire [NUMPOPT-1:0]                     t3_readB_a3;
wire [NUMPOPT*BITQPRT-3:0]             t3_addrB_a3;

reg  [NUMPOPT*4*BITPING-1:0]           t3_doutB_a3;
reg  [NUMPOPT-1:0]                     t3_fwrdB_a3;
reg  [NUMPOPT-1:0]                     t3_serrB_a3;
reg  [NUMPOPT-1:0]                     t3_derrB_a3;
reg  [NUMPOPT*(BITQPRT-2)-1:0]         t3_padrB_a3;
/*
generate if (1) begin: a3_loop

  algo_nru_1r1w #(.BITWDTH (1), .WIDTH (BITPING), .NUMRUPT (1), .NUMADDR (NUMQPRT), .BITADDR (BITQPRT), .BITPADR (BITQPRT),
                  .NUMVROW(NUMQPRT/4), .BITVROW(BITQPRT-2), .NUMWRDS(4), .BITWRDS(2),
                  .NUMPBNK(1), .BITPBNK(0),
                  .SRAM_DELAY (QPTR_DELAY+FLOPECC), .UPD_DELAY (0), .FLOPIN (0), .FLOPOUT (0))
  algo (.clk(clk), .rst(rst), .ready(a3_ready),
        .read(t3_readB_a1), .write(t3_writeA_a1), .addr(t3_addrB_a1), .din(t3_dinA_a1), .rd_vld(), .rd_dout(t3_doutB_a1),
        .rd_fwrd(), .rd_serr(), .rd_derr(), .rd_padr(),
        .t1_writeA(t3_writeA_a3), .t1_addrA(t3_addrA_a3), .t1_dinA(t3_dinA_a3),
        .t1_readB(t3_readB_a3), .t1_addrB(t3_addrB_a3), .t1_doutB(t3_doutB_a3),
        .t1_fwrdB(t3_fwrdB_a3), .t1_serrB(t3_serrB_a3), .t1_derrB(t3_derrB_a3), .t1_padrB(t3_padrB_a3),
        .select_addr(select_addr));
  end
endgenerate

wire t3_writeA_wire [0:NUMPOPT-1];
wire [BITQPRT-3:0] t3_addrA_wire [0:NUMPOPT-1];
wire [POPTR_WIDTH-1:0] t3_bwA_wire [0:NUMPOPT-1];
wire [POPTR_WIDTH-1:0] t3_dinA_wire [0:NUMPOPT-1];
wire t3_readB_wire [0:NUMPOPT-1];
wire [BITQPRT-3:0] t3_addrB_wire [0:NUMPOPT-1];
wire [4*BITPING-1:0] t3_doutB_a3_wire [0:NUMPOPT-1];
wire t3_fwrdB_a3_wire [0:NUMPOPT-1];
wire t3_serrB_a3_wire [0:NUMPOPT-1];
wire t3_derrB_a3_wire [0:NUMPOPT-1];
wire [BITQPRT-3:0] t3_padrB_a3_wire [0:NUMPOPT-1];

genvar t3r;
generate
  for (t3r=0; t3r<NUMPOPT; t3r=t3r+1) begin: t3r_loop
    wire t3_writeA_a3_wire = t3_writeA_a3 >> (t3r);
    wire [BITQPRT-3:0] t3_addrA_a3_wire = t3_addrA_a3 >> (t3r*(BITQPRT-2));
    wire [4*BITPING-1:0] t3_dinA_a3_wire = t3_dinA_a3 >> (t3r*4*BITPING);
    wire t3_readB_a3_wire = t3_readB_a3 >> (t3r);
    wire [BITQPRT-3:0] t3_addrB_a3_wire = t3_addrB_a3 >> (t3r*(BITQPRT-2));

    wire [NUMPOPT*POPTR_WIDTH-1:0] t3_doutB_wire = t3_doutB >> (t3r*POPTR_WIDTH);

    wire t3_mem_write_wire;
    wire [BITQPRT-3:0] t3_mem_wr_adr_wire;
    wire [POPTR_WIDTH-1:0] t3_mem_bw_wire;
    wire [POPTR_WIDTH-1:0] t3_mem_din_wire;
    wire t3_mem_read_wire;
    wire [BITQPRT-3:0] t3_mem_rd_adr_wire;
    wire [POPTR_WIDTH-1:0] t3_mem_rd_dout_wire;
    wire t3_mem_rd_fwrd_wire;
    wire t3_mem_rd_serr_wire;
    wire t3_mem_rd_derr_wire;
    wire [BITQPRT-1:0] t3_mem_rd_padr_wire;

    if (1) begin: align_loop
      infra_align_ecc_1r1w #(.WIDTH (4*BITPING), .ENAPSDO (0), .ENAECC (1), .ECCWDTH (POPTR_WIDTH-4*BITPING), .ENAPADR (0),
                             .NUMADDR (NUMQPRT/4), .BITADDR (BITQPRT-2),
                             .NUMSROW (NUMQPRT/4), .BITSROW (BITQPRT-2), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITQPRT-2),
                             .SRAM_DELAY (QPTR_DELAY), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC))
        infra (.write(t3_writeA_a3_wire), .wr_adr(t3_addrA_a3_wire), .din(t3_dinA_a3_wire),
               .read(t3_readB_a3_wire), .rd_adr(t3_addrB_a3_wire),
               .rd_dout(t3_doutB_a3_wire[t3r]), .rd_fwrd(t3_fwrdB_a3_wire[t3r]),
               .rd_serr(t3_serrB_a3_wire[t3r]), .rd_derr(t3_derrB_a3_wire[t3r]), .rd_padr(t3_padrB_a3_wire[t3r]),
               .mem_write (t3_mem_write_wire), .mem_wr_adr(t3_mem_wr_adr_wire), .mem_bw (t3_mem_bw_wire), .mem_din (t3_mem_din_wire),
               .mem_read (t3_mem_read_wire), .mem_rd_adr(t3_mem_rd_adr_wire), .mem_rd_dout (t3_mem_rd_dout_wire),
               .mem_rd_fwrd(t3_mem_rd_fwrd_wire), .mem_rd_padr(t3_mem_rd_padr_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_vrow));
    end

    if (1) begin: stack_loop
      infra_stack_1r1w #(.WIDTH (POPTR_WIDTH), .ENAPSDO (0), .NUMADDR (NUMQPRT/4), .BITADDR (BITQPRT-2),
                         .NUMWROW (NUMQPRT/4), .BITWROW (BITQPRT-2), .NUMWBNK (1), .BITWBNK (0),
                         .SRAM_DELAY (QPTR_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
        infra (.write (t3_mem_write_wire), .wr_adr (t3_mem_wr_adr_wire), .bw (t3_mem_bw_wire), .din (t3_mem_din_wire),
               .read (t3_mem_read_wire), .rd_adr (t3_mem_rd_adr_wire), .rd_dout (t3_mem_rd_dout_wire),
               .rd_fwrd (t3_mem_rd_fwrd_wire), .rd_serr (t3_mem_rd_serr_wire), .rd_derr(t3_mem_rd_derr_wire), .rd_padr(t3_mem_rd_padr_wire),
               .mem_write (t3_writeA_wire[t3r]), .mem_wr_adr(t3_addrA_wire[t3r]),
               .mem_bw (t3_bwA_wire[t3r]), .mem_din (t3_dinA_wire[t3r]),
               .mem_read (t3_readB_wire[t3r]), .mem_rd_adr(t3_addrB_wire[t3r]), .mem_rd_dout (t3_doutB_wire),
               .clk (clk), .rst(rst),
               .select_addr (select_srow));
    end
  end
endgenerate

reg [NUMPOPT-1:0] t3_writeA;
reg [NUMPOPT*(BITQPRT-2)-1:0] t3_addrA;
reg [NUMPOPT*POPTR_WIDTH-1:0] t3_bwA;
reg [NUMPOPT*POPTR_WIDTH-1:0] t3_dinA;
reg [NUMPOPT-1:0] t3_readB;
reg [NUMPOPT*(BITQPRT-2)-1:0] t3_addrB;
integer t3r_int;
always_comb begin
  t3_writeA = 0;
  t3_addrA = 0;
  t3_bwA = 0;
  t3_dinA = 0;
  t3_readB = 0;
  t3_addrB = 0;
  t3_doutB_a3 = 0;
  t3_fwrdB_a3 = 0;
  t3_serrB_a3 = 0;
  t3_derrB_a3 = 0;
  t3_padrB_a3 = 0;
  for (t3r_int=0; t3r_int<NUMPUPT; t3r_int=t3r_int+1) begin
    t3_writeA = t3_writeA | (t3_writeA_wire[t3r_int] << (t3r_int));
    t3_addrA = t3_addrA | (t3_addrA_wire[t3r_int] << (t3r_int*(BITQPRT-2)));
    t3_bwA = t3_bwA | (t3_bwA_wire[t3r_int] << (t3r_int*POPTR_WIDTH));
    t3_dinA = t3_dinA | (t3_dinA_wire[t3r_int] << (t3r_int*POPTR_WIDTH));
    t3_readB = t3_readB | (t3_readB_wire[t3r_int] << (t3r_int));
    t3_addrB = t3_addrB | (t3_addrB_wire[t3r_int] << (t3r_int*(BITQPRT-2)));
    t3_doutB_a3 = t3_doutB_a3 | (t3_doutB_a3_wire[t3r_int] << (t3r_int*4*BITPING));
    t3_fwrdB_a3 = t3_fwrdB_a3 | (t3_fwrdB_a3_wire[t3r_int] << (t3r_int));
    t3_serrB_a3 = t3_serrB_a3 | (t3_serrB_a3_wire[t3r_int] << (t3r_int));
    t3_derrB_a3 = t3_derrB_a3 | (t3_derrB_a3_wire[t3r_int] << (t3r_int));
    t3_padrB_a3 = t3_padrB_a3 | (t3_padrB_a3_wire[t3r_int] << (t3r_int*(BITQPRT-2)));
  end
end
*/
wire [NUMPUPT-1:0]                     t4_writeA_a4;
wire [NUMPUPT*(BITQPRT-2)-1:0]         t4_addrA_a4;
wire [NUMPUPT*4*BITPING-1:0]           t4_dinA_a4;
wire [NUMPUPT-1:0]                     t4_readB_a4;
wire [NUMPUPT*(BITQPRT-2)-1:0]         t4_addrB_a4;

reg  [NUMPUPT*4*BITPING-1:0]           t4_doutB_a4;
reg  [NUMPUPT-1:0]                     t4_fwrdB_a4;
reg  [NUMPUPT-1:0]                     t4_serrB_a4;
reg  [NUMPUPT-1:0]                     t4_derrB_a4;
reg  [NUMPUPT*(BITQPRT-2)-1:0]         t4_padrB_a4;
/*
generate if (1) begin: a4_loop

  algo_nru_1r1w #(.BITWDTH (1), .WIDTH (BITPING), .NUMRUPT (1), .NUMADDR (NUMQPRT), .BITADDR (BITQPRT), .BITPADR (BITQPRT),
                  .NUMVROW(NUMQPRT/4), .BITVROW(BITQPRT-2), .NUMWRDS(4), .BITWRDS(2),
                  .NUMPBNK(1), .BITPBNK(0),
                  .SRAM_DELAY (QPTR_DELAY+1), .UPD_DELAY (0), .FLOPIN (0), .FLOPOUT (0))
  algo (.clk(clk), .rst(rst), .ready(a4_ready),
        .read(t4_readB_a1), .write(t4_writeA_a1), .addr(t4_addrB_a1), .din(t4_dinA_a1), .rd_vld(), .rd_dout(t4_doutB_a1),
        .rd_fwrd(), .rd_serr(), .rd_derr(), .rd_padr(),
        .t1_writeA(t4_writeA_a4), .t1_addrA(t4_addrA_a4), .t1_dinA(t4_dinA_a4),
        .t1_readB(t4_readB_a4), .t1_addrB(t4_addrB_a4), .t1_doutB(t4_doutB_a4),
        .t1_fwrdB(t4_fwrdB_a4), .t1_serrB(t4_serrB_a4), .t1_derrB(t4_derrB_a4), .t1_padrB(t4_padrB_a4),
        .select_addr(select_addr));
  end
endgenerate

wire t4_writeA_wire [0:NUMPUPT-1];
wire [BITQPRT-3:0] t4_addrA_wire [0:NUMPUPT-1];
wire [PUPTR_WIDTH-1:0] t4_bwA_wire [0:NUMPUPT-1];
wire [PUPTR_WIDTH-1:0] t4_dinA_wire [0:NUMPUPT-1];
wire t4_readB_wire [0:NUMPUPT-1];
wire [BITQPRT-3:0] t4_addrB_wire [0:NUMPUPT-1];
wire [4*BITPING-1:0] t4_doutB_a4_wire [0:NUMPUPT-1];
wire t4_fwrdB_a4_wire [0:NUMPUPT-1];
wire t4_serrB_a4_wire [0:NUMPUPT-1];
wire t4_derrB_a4_wire [0:NUMPUPT-1];
wire [BITQPRT-3:0] t4_padrB_a4_wire [0:NUMPUPT-1];

genvar t4r;
generate
  for (t4r=0; t4r<NUMPUPT; t4r=t4r+1) begin: t4r_loop
    wire t4_writeA_a4_wire = t4_writeA_a4 >> (t4r);
    wire [BITQPRT-3:0] t4_addrA_a4_wire = t4_addrA_a4 >> (t4r*(BITQPRT-2));
    wire [4*BITPING-1:0] t4_dinA_a4_wire = t4_dinA_a4 >> (t4r*4*BITPING);
    wire t4_readB_a4_wire = t4_readB_a4 >> (t4r);
    wire [BITQPRT-3:0] t4_addrB_a4_wire = t4_addrB_a4 >> (t4r*(BITQPRT-2));

    wire [NUMPUPT*PUPTR_WIDTH-1:0] t4_doutB_wire = t4_doutB >> (t4r*PUPTR_WIDTH);

    wire t4_mem_write_wire;
    wire [BITQPRT-3:0] t4_mem_wr_adr_wire;
    wire [PUPTR_WIDTH-1:0] t4_mem_bw_wire;
    wire [PUPTR_WIDTH-1:0] t4_mem_din_wire;
    wire t4_mem_read_wire;
    wire [BITQPRT-3:0] t4_mem_rd_adr_wire;
    wire [PUPTR_WIDTH-1:0] t4_mem_rd_dout_wire;
    wire t4_mem_rd_fwrd_wire;
    wire t4_mem_rd_serr_wire;
    wire t4_mem_rd_derr_wire;
    wire [BITQPRT-3:0] t4_mem_rd_padr_wire;

    if (1) begin: align_loop
      infra_align_ecc_1r1w #(.WIDTH (4*BITPING), .ENAPSDO (0), .ENAECC (1), .ECCWDTH (PUPTR_WIDTH-4*BITPING), .ENAPADR (0),
                             .NUMADDR (NUMQPRT/4), .BITADDR (BITQPRT-2),
                             .NUMSROW (NUMQPRT/4), .BITSROW (BITQPRT-2), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITQPRT-2),
                             .SRAM_DELAY (QPTR_DELAY), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC))
        infra (.write(t4_writeA_a4_wire), .wr_adr(t4_addrA_a4_wire), .din(t4_dinA_a4_wire),
               .read(t4_readB_a4_wire), .rd_adr(t4_addrB_a4_wire),
               .rd_dout(t4_doutB_a4_wire[t4r]), .rd_fwrd(t4_fwrdB_a4_wire[t4r]),
               .rd_serr(t4_serrB_a4_wire[t4r]), .rd_derr(t4_derrB_a4_wire[t4r]), .rd_padr(t4_padrB_a4_wire[t4r]),
               .mem_write (t4_mem_write_wire), .mem_wr_adr(t4_mem_wr_adr_wire), .mem_bw (t4_mem_bw_wire), .mem_din (t4_mem_din_wire),
               .mem_read (t4_mem_read_wire), .mem_rd_adr(t4_mem_rd_adr_wire), .mem_rd_dout (t4_mem_rd_dout_wire),
               .mem_rd_fwrd(t4_mem_rd_fwrd_wire), .mem_rd_padr(t4_mem_rd_padr_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_vrow));
    end

    if (1) begin: stack_loop
      infra_stack_1r1w #(.WIDTH (PUPTR_WIDTH), .ENAPSDO (0), .NUMADDR (NUMQPRT/4), .BITADDR (BITQPRT-2),
                         .NUMWROW (NUMQPRT/4), .BITWROW (BITQPRT-2), .NUMWBNK (1), .BITWBNK (0),
                         .SRAM_DELAY (QPTR_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
        infra (.write (t4_mem_write_wire), .wr_adr (t4_mem_wr_adr_wire), .bw (t4_mem_bw_wire), .din (t4_mem_din_wire),
               .read (t4_mem_read_wire), .rd_adr (t4_mem_rd_adr_wire), .rd_dout (t4_mem_rd_dout_wire),
               .rd_fwrd (t4_mem_rd_fwrd_wire), .rd_serr (t4_mem_rd_serr_wire), .rd_derr(t4_mem_rd_derr_wire), .rd_padr(t4_mem_rd_padr_wire),
               .mem_write (t4_writeA_wire[t4r]), .mem_wr_adr(t4_addrA_wire[t4r]),
               .mem_bw (t4_bwA_wire[t4r]), .mem_din (t4_dinA_wire[t4r]),
               .mem_read (t4_readB_wire[t4r]), .mem_rd_adr(t4_addrB_wire[t4r]), .mem_rd_dout (t4_doutB_wire),
               .clk (clk), .rst(rst),
               .select_addr (select_srow));
    end
  end
endgenerate

reg [NUMPUPT-1:0] t4_writeA;
reg [NUMPUPT*(BITQPRT-2)-1:0] t4_addrA;
reg [NUMPUPT*PUPTR_WIDTH-1:0] t4_bwA;
reg [NUMPUPT*PUPTR_WIDTH-1:0] t4_dinA;
reg [NUMPOPT-1:0] t4_readB;
reg [NUMPOPT*(BITQPRT-2)-1:0] t4_addrB;
integer t4r_int;
always_comb begin
  t4_writeA = 0;
  t4_addrA = 0;
  t4_bwA = 0;
  t4_dinA = 0;
  t4_readB = 0;
  t4_addrB = 0;
  t4_doutB_a4 = 0;
  t4_fwrdB_a4 = 0;
  t4_serrB_a4 = 0;
  t4_derrB_a4 = 0;
  t4_padrB_a4 = 0;
  for (t4r_int=0; t4r_int<NUMPUPT; t4r_int=t4r_int+1) begin
    t4_writeA = t4_writeA | (t4_writeA_wire[t4r_int] << (t4r_int));
    t4_addrA = t4_addrA | (t4_addrA_wire[t4r_int] << (t4r_int*(BITQPRT-2)));
    t4_bwA = t4_bwA | (t4_bwA_wire[t4r_int] << (t4r_int*PUPTR_WIDTH));
    t4_dinA = t4_dinA | (t4_dinA_wire[t4r_int] << (t4r_int*PUPTR_WIDTH));
    t4_readB = t4_readB | (t4_readB_wire[t4r_int] << (t4r_int));
    t4_addrB = t4_addrB | (t4_addrB_wire[t4r_int] << (t4r_int*(BITQPRT-2)));
    t4_doutB_a4 = t4_doutB_a4 | (t4_doutB_a4_wire[t4r_int] << (t4r_int*4*BITPING));
    t4_fwrdB_a4 = t4_fwrdB_a4 | (t4_fwrdB_a4_wire[t4r_int] << (t4r_int));
    t4_serrB_a4 = t4_serrB_a4 | (t4_serrB_a4_wire[t4r_int] << (t4r_int));
    t4_derrB_a4 = t4_derrB_a4 | (t4_derrB_a4_wire[t4r_int] << (t4r_int));
    t4_padrB_a4 = t4_padrB_a4 | (t4_padrB_a4_wire[t4r_int] << (t4r_int*(BITQPRT-2)));
  end
end
*/
wire [CNTD_NUMVBNK-1:0] t5_writeA_a5;
wire [CNTD_NUMVBNK*CNTD_BITVROW-1:0] t5_addrA_a5;
wire [CNTD_NUMVBNK*BITQCNT-1:0] t5_dinA_a5;
wire [CNTD_NUMVBNK-1:0] t5_readB_a5;
wire [CNTD_NUMVBNK*CNTD_BITVROW-1:0] t5_addrB_a5;
reg  [CNTD_NUMVBNK*BITQCNT-1:0] t5_doutB_a5;
reg  [CNTD_NUMVBNK-1:0] t5_fwrdB_a5;
reg  [CNTD_NUMVBNK-1:0] t5_serrB_a5;
reg  [CNTD_NUMVBNK-1:0] t5_derrB_a5;
reg  [CNTD_NUMVBNK*CNTD_BITSROW-1:0] t5_padrB_a5;

wire [CNTC_NUMVBNK-1:0] t6_writeA_a5;
wire [CNTC_NUMVBNK*CNTC_BITVROW-1:0] t6_addrA_a5;
wire [CNTC_NUMVBNK*BITQCNT-1:0] t6_dinA_a5;
wire [CNTC_NUMVBNK-1:0] t6_readB_a5;
wire [CNTC_NUMVBNK*CNTC_BITVROW-1:0] t6_addrB_a5;
reg  [CNTC_NUMVBNK*BITQCNT-1:0] t6_doutB_a5;
reg  [CNTC_NUMVBNK-1:0] t6_fwrdB_a5;
reg  [CNTC_NUMVBNK-1:0] t6_serrB_a5;
reg  [CNTC_NUMVBNK-1:0] t6_derrB_a5;
reg  [CNTC_NUMVBNK*CNTC_BITSROW-1:0] t6_padrB_a5;

wire [CNTS_NUMVBNK-1:0] t7_writeA_a5;
wire [CNTS_NUMVBNK*CNTS_BITVROW-1:0] t7_addrA_a5;
wire [CNTS_NUMVBNK*CNTD_BITVBNK-1:0] t7_dinA_a5;
wire [CNTS_NUMVBNK-1:0] t7_readB_a5;
wire [CNTS_NUMVBNK*CNTS_BITVROW-1:0] t7_addrB_a5;
reg  [CNTS_NUMVBNK*CNTD_BITVBNK-1:0] t7_doutB_a5;
reg  [CNTS_NUMVBNK-1:0] t7_fwrdB_a5;
reg  [CNTS_NUMVBNK-1:0] t7_serrB_a5;
reg  [CNTS_NUMVBNK-1:0] t7_derrB_a5;
reg  [CNTS_NUMVBNK*CNTS_BITSROW-1:0] t7_padrB_a5;

generate if (1) begin: a5_loop

  algo_nr2u_1r1w_a43 #(.WIDTH (BITQCNT), .ENAPSDO (0), .ENAPAR (0), .ENAECC (0),
                   .NUMRUPT (CNT_NUMRUPT), .NUMADDR (NUMQPRT), .BITADDR (BITQPRT),
                   .NUMVROW (CNTD_NUMVROW), .BITVROW (CNTD_BITVROW), .NUMVBNK (CNT_NUMVBNK), .BITVBNK (CNT_BITVBNK), .BITPBNK (BITPBNK), .BITPADR (CNT_BITPADR),
                   .SRAM_DELAY (CNTD_DELAY+FLOPECC), .UPD_DELAY(0), .FLOPIN(FLOPIN), .FLOPOUT(FLOPOUT))
    algo (.clk(clk), .rst(rst), .ready(a5_ready),
          .ru_write(t5_writeA_a1), .ru_din(t5_dinA_a1),
          .ru_read(t5_readB_a1), .ru_addr(t5_addrB_a1), .ru_vld(), .ru_dout(t5_doutB_a1),
          .ru_fwrd(), .ru_serr(), .ru_derr(), .ru_padr(),
          .t1_writeA(t5_writeA_a5), .t1_addrA(t5_addrA_a5), .t1_dinA(t5_dinA_a5),
          .t1_readB(t5_readB_a5), .t1_addrB(t5_addrB_a5), .t1_doutB(t5_doutB_a5),
          .t1_fwrdB(t5_fwrdB_a5), .t1_serrB(t5_serrB_a5), .t1_derrB(t5_derrB_a5), .t1_padrB(130'd0),
          .t2_writeA(t6_writeA_a5), .t2_addrA(t6_addrA_a5), .t2_dinA(t6_dinA_a5),
          .t2_readB(t6_readB_a5), .t2_addrB(t6_addrB_a5), .t2_doutB(t6_doutB_a5),
          .t2_fwrdB(t6_fwrdB_a5), .t2_serrB(t6_serrB_a5), .t2_derrB(t6_derrB_a5), .t2_padrB(26'd0),
          .t3_writeA(t7_writeA_a5), .t3_addrA(t7_addrA_a5), .t3_dinA(t7_dinA_a5),
          .t3_readB(t7_readB_a5), .t3_addrB(t7_addrB_a5), .t3_doutB(t7_doutB_a5),
          .t3_fwrdB(t7_fwrdB_a5), .t3_serrB(t7_serrB_a5), .t3_derrB(t7_derrB_a5), .t3_padrB(26'd0),
          .select_addr(select_qprt));


end
endgenerate


wire t5_writeA_wire [0:CNT_NUMRUPT-1][0:CNT_NUMVBNK-1];
wire [CNTD_BITVROW-1:0] t5_addrA_wire [0:CNT_NUMRUPT-1][0:CNT_NUMVBNK-1];
wire [CNTD_NUMWRDS*CNTD_WIDTH-1:0] t5_bwA_wire [0:CNT_NUMRUPT-1][0:CNT_NUMVBNK-1];
wire [CNTD_NUMWRDS*CNTD_WIDTH-1:0] t5_dinA_wire [0:CNT_NUMRUPT-1][0:CNT_NUMVBNK-1];
wire t5_readB_wire [0:CNT_NUMRUPT-1][0:CNT_NUMVBNK-1];
wire [CNTD_BITSROW-1:0] t5_addrB_wire [0:CNT_NUMRUPT-1][0:CNT_NUMVBNK-1];

wire [BITQCNT-1:0] t5_doutB_a5_wire [0:CNT_NUMRUPT-1][0:CNT_NUMVBNK-1];
wire t5_fwrdB_a5_wire [0:CNT_NUMRUPT-1][0:CNT_NUMVBNK-1];
wire t5_serrB_a5_wire [0:CNT_NUMRUPT-1][0:CNT_NUMVBNK-1];
wire t5_derrB_a5_wire [0:CNT_NUMRUPT-1][0:CNT_NUMVBNK-1];
wire [CNTD_BITSROW-1:0] t5_padrB_a5_wire [0:CNT_NUMRUPT-1][0:CNT_NUMVBNK-1];

genvar t5r, t5b;
generate
  for (t5r=0; t5r<CNT_NUMRUPT; t5r=t5r+1) begin: t5r_loop
    for (t5b=0; t5b<CNT_NUMVBNK; t5b=t5b+1) begin: t5b_loop
      wire t5_writeA_a5_wire = t5_writeA_a5 >> (t5r*CNT_NUMVBNK+t5b);
      wire [CNTD_BITVROW-1:0] t5_addrA_a5_wire = t5_addrA_a5 >> ((t5r*CNT_NUMVBNK+t5b)*CNTD_BITVROW);
      wire [BITQCNT-1:0] t5_dinA_a5_wire = t5_dinA_a5 >> ((t5r*CNT_NUMVBNK+t5b)*BITQCNT);
      wire t5_readB_a5_wire = t5_readB_a5 >> (t5r*CNT_NUMVBNK+t5b);
      wire [CNTD_BITVROW-1:0] t5_addrB_a5_wire = t5_addrB_a5 >> ((t5r*CNT_NUMVBNK+t5b)*CNTD_BITVROW);

      wire [NUMWRDS*CNTD_WIDTH-1:0] t5_doutB_wire = t5_doutB >> ((t5r*CNT_NUMVBNK+t5b)*CNTD_WIDTH);

      wire mem_write_t5r_wire;
      wire [CNTD_BITSROW-1:0] mem_wr_adr_t5r_wire;
      wire [NUMWRDS*CNTD_WIDTH-1:0] mem_bw_t5r_wire;
      wire [NUMWRDS*CNTD_WIDTH-1:0] mem_din_t5r_wire;
      wire mem_read_t5r_wire;
      wire [CNTD_BITSROW-1:0] mem_rd_adr_t5r_wire;
      wire [NUMWRDS*CNTD_WIDTH-1:0] mem_rd_dout_t5r_wire;
      wire mem_rd_fwrd_t5r_wire;
      wire mem_rd_serr_t5r_wire;
      wire mem_rd_derr_t5r_wire;
      wire [(BITWBNK+CNTD_BITSROW)-1:0] mem_rd_padr_t5r_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH (BITQCNT), .ENAPSDO (NUMWRDS==1), .ENAPAR (0), .ENAECC (1), .ECCWDTH (CNTD_WIDTH-BITQCNT), .ENAPADR (1),
                               .NUMADDR (CNTD_NUMVROW), .BITADDR (CNTD_BITVROW),
                               .NUMSROW (CNTD_NUMSROW), .BITSROW (CNTD_BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWBNK+CNTD_BITSROW),
                               .SRAM_DELAY (CNTD_DELAY), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC))
          infra (.write(t5_writeA_a5_wire), .wr_adr(t5_addrA_a5_wire), .din(t5_dinA_a5_wire),
                 .read(t5_readB_a5_wire), .rd_adr(t5_addrB_a5_wire),
                 .rd_dout(t5_doutB_a5_wire[t5r][t5b]), .rd_fwrd(t5_fwrdB_a5_wire[t5r][t5b]),
                 .rd_serr(t5_serrB_a5_wire[t5r][t5b]), .rd_derr(t5_derrB_a5_wire[t5r][t5b]), .rd_padr(t5_padrB_a5_wire[t5r][t5b]),
                 .mem_write (mem_write_t5r_wire), .mem_wr_adr(mem_wr_adr_t5r_wire), .mem_bw (mem_bw_t5r_wire), .mem_din (mem_din_t5r_wire),
                 .mem_read (mem_read_t5r_wire), .mem_rd_adr(mem_rd_adr_t5r_wire), .mem_rd_dout (mem_rd_dout_t5r_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_t5r_wire), .mem_rd_padr(mem_rd_padr_t5r_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_cnt_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (NUMWRDS*CNTD_WIDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (CNTD_NUMSROW), .BITADDR (CNTD_BITSROW),
                           .NUMWROW (CNTD_NUMSROW), .BITWROW (CNTD_BITSROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                           .SRAM_DELAY (CNTD_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (0))
          infra (.write (mem_write_t5r_wire), .wr_adr (mem_wr_adr_t5r_wire), .bw (mem_bw_t5r_wire), .din (mem_din_t5r_wire),
                 .read (mem_read_t5r_wire), .rd_adr (mem_rd_adr_t5r_wire), .rd_dout (mem_rd_dout_t5r_wire),
                 .rd_fwrd (mem_rd_fwrd_t5r_wire), .rd_serr (mem_rd_serr_t5r_wire), .rd_derr(mem_rd_derr_t5r_wire), .rd_padr(mem_rd_padr_t5r_wire),
                 .mem_write (t5_writeA_wire[t5r][t5b]), .mem_wr_adr(t5_addrA_wire[t5r][t5b]),
                 .mem_bw (t5_bwA_wire[t5r][t5b]), .mem_din (t5_dinA_wire[t5r][t5b]),
                 .mem_read (t5_readB_wire[t5r][t5b]), .mem_rd_adr(t5_addrB_wire[t5r][t5b]), .mem_rd_dout (t5_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_cnt_srow));
      end
    end
  end
endgenerate

reg [CNTD_NUMVBNK-1:0] t5_writeA;
reg [CNTD_NUMVBNK*CNTD_BITSROW-1:0] t5_addrA;
reg [CNTD_NUMVBNK*CNTD_WIDTH-1:0] t5_bwA;
reg [CNTD_NUMVBNK*CNTD_WIDTH-1:0] t5_dinA;
reg [CNTD_NUMVBNK-1:0] t5_readB;
reg [CNTD_NUMVBNK*CNTD_BITSROW-1:0] t5_addrB;
integer t5r_int, t5b_int;
always_comb begin
  t5_writeA = 0;
  t5_addrA = 0;
  t5_bwA = 0;
  t5_dinA = 0;
  t5_readB = 0;
  t5_addrB = 0;
  t5_doutB_a5 = 0;
  t5_fwrdB_a5 = 0;
  t5_serrB_a5 = 0;
  t5_derrB_a5 = 0;
  t5_padrB_a5 = 0;
  for (t5r_int=0; t5r_int<CNT_NUMRUPT; t5r_int=t5r_int+1) begin
    for (t5b_int=0; t5b_int<CNT_NUMVBNK; t5b_int=t5b_int+1) begin
      t5_writeA = t5_writeA | (t5_writeA_wire[t5r_int][t5b_int] << (t5r_int*CNT_NUMVBNK+t5b_int));
      t5_addrA = t5_addrA | (t5_addrA_wire[t5r_int][t5b_int] << ((t5r_int*CNT_NUMVBNK+t5b_int)*CNTD_BITSROW));
      t5_bwA = t5_bwA | (t5_bwA_wire[t5r_int][t5b_int] << ((t5r_int*CNT_NUMVBNK+t5b_int)*CNTD_WIDTH));
      t5_dinA = t5_dinA | (t5_dinA_wire[t5r_int][t5b_int] << ((t5r_int*CNT_NUMVBNK+t5b_int)*CNTD_WIDTH));
      t5_readB = t5_readB | (t5_readB_wire[t5r_int][t5b_int] << (t5r_int*CNT_NUMVBNK+t5b_int));
      t5_addrB = t5_addrB | (t5_addrB_wire[t5r_int][t5b_int] << ((t5r_int*CNT_NUMVBNK+t5b_int)*CNTD_BITSROW));
      t5_doutB_a5 = t5_doutB_a5 | (t5_doutB_a5_wire[t5r_int][t5b_int] << ((t5r_int*CNT_NUMVBNK+t5b_int)*BITQCNT));
      t5_fwrdB_a5 = t5_fwrdB_a5 | (t5_fwrdB_a5_wire[t5r_int][t5b_int] << (t5r_int*CNT_NUMVBNK+t5b_int));
      t5_serrB_a5 = t5_serrB_a5 | (t5_serrB_a5_wire[t5r_int][t5b_int] << (t5r_int*CNT_NUMVBNK+t5b_int));
      t5_derrB_a5 = t5_derrB_a5 | (t5_derrB_a5_wire[t5r_int][t5b_int] << (t5r_int*CNT_NUMVBNK+t5b_int));
      t5_padrB_a5 = t5_padrB_a5 | (t5_padrB_a5_wire[t5r_int][t5b_int] << ((t5r_int*CNT_NUMVBNK+t5b_int)*(CNTD_BITSROW+BITWRDS)));
    end
  end
end

wire t6_writeA_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire [CNTC_BITSROW-1:0] t6_addrA_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire [NUMWRDS*CNTC_WIDTH-1:0] t6_bwA_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire [NUMWRDS*CNTC_WIDTH-1:0] t6_dinA_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire t6_readB_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire [CNTC_BITSROW-1:0] t6_addrB_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire [BITQCNT-1:0] t6_doutB_a5_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire t6_fwrdB_a5_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire t6_serrB_a5_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire t6_derrB_a5_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire [CNTC_BITSROW-1:0] t6_padrB_a5_wire [0:(CNT_NUMRUPT)-1][0:1-1];

genvar t6r, t6b;
generate
  for (t6r=0; t6r<(CNT_NUMRUPT); t6r=t6r+1) begin: t6r_loop
    for (t6b=0; t6b<1; t6b=t6b+1) begin: t6b_loop
      wire t6_writeA_a5_wire = t6_writeA_a5 >> (t6r*1+t6b);
      wire [CNTC_BITVROW-1:0] t6_addrA_a5_wire = t6_addrA_a5 >> ((t6r*1+t6b)*CNTC_BITVROW);
      wire [BITQCNT-1:0] t6_dinA_a5_wire = t6_dinA_a5 >> ((t6r*1+t6b)*BITQCNT);
      wire t6_readB_a5_wire = t6_readB_a5 >> (t6r*1+t6b);
      wire [CNTC_BITVROW-1:0] t6_addrB_a5_wire = t6_addrB_a5 >> ((t6r*1+t6b)*CNTC_BITVROW);

      wire [NUMWRDS*CNTC_WIDTH-1:0] t6_doutB_wire = t6_doutB >> ((t6r*1+t6b)*CNTC_WIDTH);

      wire mem_write_t6r_wire;
      wire [CNTC_BITSROW-1:0] mem_wr_adr_t6r_wire;
      wire [NUMWRDS*CNTC_WIDTH-1:0] mem_bw_t6r_wire;
      wire [NUMWRDS*CNTC_WIDTH-1:0] mem_din_t6r_wire;
      wire mem_read_t6r_wire;
      wire [CNTC_BITSROW-1:0] mem_rd_adr_t6r_wire;
      wire [NUMWRDS*CNTC_WIDTH-1:0] mem_rd_dout_t6r_wire;
      wire mem_rd_fwrd_t6r_wire;
      wire mem_rd_serr_t6r_wire;
      wire mem_rd_derr_t6r_wire;
      wire [(BITWBNK+CNTC_BITSROW)-1:0] mem_rd_padr_t6r_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH (BITQCNT), .ENAPSDO (NUMWRDS==1), .ENAPAR (0), .ENAECC (1), .ECCWDTH (CNTC_WIDTH-BITQCNT), .ENAPADR (1),
                               .NUMADDR (CNTC_NUMVROW), .BITADDR (CNTC_BITVROW),
                               .NUMSROW (CNTC_NUMSROW), .BITSROW (CNTC_BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITWBNK+CNTC_BITSROW),
                               .SRAM_DELAY (CNTC_DELAY), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.write(t6_writeA_a5_wire), .wr_adr(t6_addrA_a5_wire), .din(t6_dinA_a5_wire),
                 .read(t6_readB_a5_wire), .rd_adr(t6_addrB_a5_wire),
                 .rd_dout(t6_doutB_a5_wire[t6r][t6b]), .rd_fwrd(t6_fwrdB_a5_wire[t6r][t6b]),
                 .rd_serr(t6_serrB_a5_wire[t6r][t6b]), .rd_derr(t6_derrB_a5_wire[t6r][t6b]), .rd_padr(t6_padrB_a5_wire[t6r][t6b]),
                 .mem_write (mem_write_t6r_wire), .mem_wr_adr(mem_wr_adr_t6r_wire), .mem_bw (mem_bw_t6r_wire), .mem_din (mem_din_t6r_wire),
                 .mem_read (mem_read_t6r_wire), .mem_rd_adr(mem_rd_adr_t6r_wire), .mem_rd_dout (mem_rd_dout_t6r_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_t6r_wire), .mem_rd_padr(mem_rd_padr_t6r_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_cnt_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (NUMWRDS*CNTC_WIDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (CNTC_NUMSROW), .BITADDR (CNTC_BITSROW),
                           .NUMWROW (NUMWROW), .BITWROW (CNTC_BITSROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                           .SRAM_DELAY (CNTC_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (0), .RSTZERO (1))
          infra (.write (mem_write_t6r_wire), .wr_adr (mem_wr_adr_t6r_wire), .bw (mem_bw_t6r_wire), .din (mem_din_t6r_wire),
                 .read (mem_read_t6r_wire), .rd_adr (mem_rd_adr_t6r_wire), .rd_dout (mem_rd_dout_t6r_wire),
                 .rd_fwrd (mem_rd_fwrd_t6r_wire), .rd_serr (mem_rd_serr_t6r_wire), .rd_derr(mem_rd_derr_t6r_wire), .rd_padr(mem_rd_padr_t6r_wire),
                 .mem_write (t6_writeA_wire[t6r][t6b]), .mem_wr_adr(t6_addrA_wire[t6r][t6b]),
                 .mem_bw (t6_bwA_wire[t6r][t6b]), .mem_din (t6_dinA_wire[t6r][t6b]),
                 .mem_read (t6_readB_wire[t6r][t6b]), .mem_rd_adr(t6_addrB_wire[t6r][t6b]), .mem_rd_dout (t6_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_cnt_srow));
      end
    end
  end
endgenerate

reg [(CNT_NUMRUPT)-1:0] t6_writeA;
reg [(CNT_NUMRUPT)*CNTC_BITSROW-1:0] t6_addrA;
reg [(CNT_NUMRUPT)*CNTC_WIDTH-1:0] t6_bwA;
reg [(CNT_NUMRUPT)*CNTC_WIDTH-1:0] t6_dinA;
reg [(CNT_NUMRUPT)-1:0] t6_readB;
reg [(CNT_NUMRUPT)*CNTC_BITSROW-1:0] t6_addrB;
integer t6r_int, t6b_int;
always_comb begin
  t6_writeA = 0;
  t6_addrA = 0;
  t6_bwA = 0;
  t6_dinA = 0;
  t6_readB = 0;
  t6_addrB = 0;
  t6_doutB_a5 = 0;
  t6_fwrdB_a5 = 0;
  t6_serrB_a5 = 0;
  t6_derrB_a5 = 0;
  t6_padrB_a5 = 0;
  for (t6r_int=0; t6r_int<CNT_NUMRUPT; t6r_int=t6r_int+1) begin
    for (t6b_int=0; t6b_int<1; t6b_int=t6b_int+1) begin
      t6_writeA = t6_writeA | (t6_writeA_wire[t6r_int][t6b_int] << (t6r_int*1+t6b_int));
      t6_addrA = t6_addrA | (t6_addrA_wire[t6r_int][t6b_int] << ((t6r_int*1+t6b_int)*CNTC_BITSROW));
      t6_bwA = t6_bwA | (t6_bwA_wire[t6r_int][t6b_int] << ((t6r_int*1+t6b_int)*CNTC_WIDTH));
      t6_dinA = t6_dinA | (t6_dinA_wire[t6r_int][t6b_int] << ((t6r_int*1+t6b_int)*CNTC_WIDTH));
      t6_readB = t6_readB | (t6_readB_wire[t6r_int][t6b_int] << (t6r_int*1+t6b_int));
      t6_addrB = t6_addrB | (t6_addrB_wire[t6r_int][t6b_int] << ((t6r_int*1+t6b_int)*CNTC_BITSROW));
      t6_doutB_a5 = t6_doutB_a5 | (t6_doutB_a5_wire[t6r_int][t6b_int] << ((t6r_int*1+t6b_int)*BITQCNT));
      t6_fwrdB_a5 = t6_fwrdB_a5 | (t6_fwrdB_a5_wire[t6r_int][t6b_int] << (t6r_int*1+t6b_int));
      t6_serrB_a5 = t6_serrB_a5 | (t6_serrB_a5_wire[t6r_int][t6b_int] << (t6r_int*1+t6b_int));
      t6_derrB_a5 = t6_derrB_a5 | (t6_derrB_a5_wire[t6r_int][t6b_int] << (t6r_int*1+t6b_int));
      t6_padrB_a5 = t6_padrB_a5 | (t6_padrB_a5_wire[t6r_int][t6b_int] << ((t6r_int*1+t6b_int)*(CNTC_BITSROW+BITWRDS)));
    end
  end
end

wire t7_writeA_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire [CNTS_BITVROW-1:0] t7_addrA_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire [CNTS_WIDTH-1:0] t7_bwA_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire [CNTS_WIDTH-1:0] t7_dinA_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire t7_readB_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire [CNTS_BITVROW-1:0] t7_addrB_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire [CNTD_BITVBNK-1:0] t7_doutB_a5_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire t7_fwrdB_a5_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire t7_serrB_a5_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire t7_derrB_a5_wire [0:(CNT_NUMRUPT)-1][0:1-1];
wire [CNTS_BITVROW-1:0] t7_padrB_a5_wire [0:(CNT_NUMRUPT)-1][0:1-1];

genvar t7r, t7b;
generate
  for (t7r=0; t7r<CNT_NUMRUPT; t7r=t7r+1) begin: t7r_loop
    for (t7b=0; t7b<1; t7b=t7b+1) begin: t7b_loop
      wire t7_writeA_a5_wire = t7_writeA_a5 >> (t7r*1+t7b);
      wire [CNTS_BITVROW-1:0] t7_addrA_a5_wire = t7_addrA_a5 >> ((t7r*1+t7b)*CNTS_BITVROW);
      wire [CNTD_BITVBNK-1:0] t7_dinA_a5_wire = t7_dinA_a5 >> ((t7r*1+t7b)*(CNTD_BITVBNK));
      wire t7_readB_a5_wire = t7_readB_a5 >> (t7r*1+t7b);
      wire [CNTS_BITVROW-1:0] t7_addrB_a5_wire = t7_addrB_a5 >> ((t7r*1+t7b)*CNTS_BITVROW);

      wire [CNTS_WIDTH-1:0] t7_doutB_wire = t7_doutB >> ((t7r*1+t7b)*CNTS_WIDTH);

      wire mem_write_t7r_wire;
      wire [CNTS_BITVROW-1:0] mem_wr_adr_t7r_wire;
      wire [CNTS_WIDTH-1:0] mem_bw_t7r_wire;
      wire [CNTS_WIDTH-1:0] mem_din_t7r_wire;
      wire mem_read_t7r_wire;
      wire [CNTS_BITVROW-1:0] mem_rd_adr_t7r_wire;
      wire [CNTS_WIDTH-1:0] mem_rd_dout_t7r_wire;
      wire mem_rd_fwrd_t7r_wire;
      wire mem_rd_serr_t7r_wire;
      wire mem_rd_derr_t7r_wire;
      wire [CNTS_BITVROW-1:0] mem_rd_padr_t7r_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH (CNTD_BITVBNK), .ENAPSDO (1), .ENADEC(1), .ECCWDTH (CNTS_ECCWDTH), .ENAPADR (1),
                               .NUMADDR (CNTS_NUMVROW), .BITADDR (CNTS_BITVROW),
                               .NUMSROW (CNTS_NUMVROW), .BITSROW (CNTS_BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (CNTS_BITVROW),
                               .SRAM_DELAY (CNTS_DELAY), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.write(t7_writeA_a5_wire), .wr_adr(t7_addrA_a5_wire), .din(t7_dinA_a5_wire),
                 .read(t7_readB_a5_wire), .rd_adr(t7_addrB_a5_wire),
                 .rd_dout(t7_doutB_a5_wire[t7r][t7b]), .rd_fwrd(t7_fwrdB_a5_wire[t7r][t7b]),
                 .rd_serr(t7_serrB_a5_wire[t7r][t7b]), .rd_derr(t7_derrB_a5_wire[t7r][t7b]), .rd_padr(t7_padrB_a5_wire[t7r][t7b]),
                 .mem_write (mem_write_t7r_wire), .mem_wr_adr(mem_wr_adr_t7r_wire), .mem_bw (mem_bw_t7r_wire), .mem_din (mem_din_t7r_wire),
                 .mem_read (mem_read_t7r_wire), .mem_rd_adr(mem_rd_adr_t7r_wire), .mem_rd_dout (mem_rd_dout_t7r_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_t7r_wire), .mem_rd_padr(mem_rd_padr_t7r_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_cnt_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (CNTS_WIDTH), .ENAPSDO (0), .NUMADDR (CNTS_NUMVROW), .BITADDR (CNTS_BITVROW),
                           .NUMWROW (CNTS_NUMVROW), .BITWROW (CNTS_BITVROW), .NUMWBNK (1), .BITWBNK (0),
                           .SRAM_DELAY (CNTS_DELAY), .FLOPCMD (0), .FLOPMEM (0), .RSTZERO (1))
          infra (.write (mem_write_t7r_wire), .wr_adr (mem_wr_adr_t7r_wire), .bw (mem_bw_t7r_wire), .din (mem_din_t7r_wire),
                 .read (mem_read_t7r_wire), .rd_adr (mem_rd_adr_t7r_wire), .rd_dout (mem_rd_dout_t7r_wire),
                 .rd_fwrd (mem_rd_fwrd_t7r_wire), .rd_serr (mem_rd_serr_t7r_wire), .rd_derr(mem_rd_derr_t7r_wire), .rd_padr(mem_rd_padr_t7r_wire),
                 .mem_write (t7_writeA_wire[t7r][t7b]), .mem_wr_adr(t7_addrA_wire[t7r][t7b]),
                 .mem_bw (t7_bwA_wire[t7r][t7b]), .mem_din (t7_dinA_wire[t7r][t7b]),
                 .mem_read (t7_readB_wire[t7r][t7b]), .mem_rd_adr(t7_addrB_wire[t7r][t7b]), .mem_rd_dout (t7_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_cnt_vrow));
      end
    end
  end
endgenerate

reg [(CNT_NUMRUPT)-1:0] t7_writeA;
reg [(CNT_NUMRUPT)*CNTS_BITVROW-1:0] t7_addrA;
reg [(CNT_NUMRUPT)*CNTS_WIDTH-1:0] t7_bwA;
reg [(CNT_NUMRUPT)*CNTS_WIDTH-1:0] t7_dinA;
reg [(CNT_NUMRUPT)-1:0] t7_readB;
reg [(CNT_NUMRUPT)*CNTS_BITVROW-1:0] t7_addrB;
integer t7r_int, t7b_int;
always_comb begin
  t7_writeA = 0;
  t7_addrA = 0;
  t7_bwA = 0;
  t7_dinA = 0;
  t7_readB = 0;
  t7_addrB = 0;
  t7_doutB_a5 = 0;
  t7_fwrdB_a5 = 0;
  t7_serrB_a5 = 0;
  t7_derrB_a5 = 0;
  t7_padrB_a5 = 0;
  for (t7r_int=0; t7r_int<CNT_NUMRUPT; t7r_int=t7r_int+1) begin
    for (t7b_int=0; t7b_int<1; t7b_int=t7b_int+1) begin
      t7_writeA = t7_writeA | (t7_writeA_wire[t7r_int][t7b_int] << (t7r_int*1+t7b_int));
      t7_addrA = t7_addrA | (t7_addrA_wire[t7r_int][t7b_int] << ((t7r_int*1+t7b_int)*CNTS_BITVROW));
      t7_bwA = t7_bwA | (t7_bwA_wire[t7r_int][t7b_int] << ((t7r_int*1+t7b_int)*CNTS_WIDTH));
      t7_dinA = t7_dinA | (t7_dinA_wire[t7r_int][t7b_int] << ((t7r_int*1+t7b_int)*CNTS_WIDTH));
      t7_readB = t7_readB | (t7_readB_wire[t7r_int][t7b_int] << (t7r_int*1+t7b_int));
      t7_addrB = t7_addrB | (t7_addrB_wire[t7r_int][t7b_int] << ((t7r_int*1+t7b_int)*CNTS_BITVROW));
      t7_doutB_a5 = t7_doutB_a5 | (t7_doutB_a5_wire[t7r_int][t7b_int] << ((t7r_int*1+t7b_int)*(CNTD_BITVBNK)));
      t7_fwrdB_a5 = t7_fwrdB_a5 | (t7_fwrdB_a5_wire[t7r_int][t7b_int] << (t7r_int*1+t7b_int));
      t7_serrB_a5 = t7_serrB_a5 | (t7_serrB_a5_wire[t7r_int][t7b_int] << (t7r_int*1+t7b_int));
      t7_derrB_a5 = t7_derrB_a5 | (t7_derrB_a5_wire[t7r_int][t7b_int] << (t7r_int*1+t7b_int));
      t7_padrB_a5 = t7_padrB_a5 | (t7_padrB_a5_wire[t7r_int][t7b_int] << ((t7r_int*1+t7b_int)*(CNTS_BITSROW+BITWRDS)));
    end
  end
end

wire [HEADD_NUMVBNK-1:0] t8_writeA_a6;
wire [HEADD_NUMVBNK*HEADD_BITVROW-1:0] t8_addrA_a6;
wire [HEADD_NUMVBNK*NUMPING*BITQPTR-1:0] t8_dinA_a6;
wire [HEADD_NUMVBNK-1:0] t8_readB_a6;
wire [HEADD_NUMVBNK*HEADD_BITVROW-1:0] t8_addrB_a6;
reg  [HEADD_NUMVBNK*NUMPING*BITQPTR-1:0] t8_doutB_a6;
reg  [HEADD_NUMVBNK-1:0] t8_fwrdB_a6;
reg  [HEADD_NUMVBNK-1:0] t8_serrB_a6;
reg  [HEADD_NUMVBNK-1:0] t8_derrB_a6;
reg  [HEADD_NUMVBNK*HEADD_BITSROW-1:0] t8_padrB_a6;

wire [HEADC_NUMVBNK-1:0] t9_writeA_a6;
wire [HEADC_NUMVBNK*HEADC_BITVROW-1:0] t9_addrA_a6;
wire [HEADC_NUMVBNK*NUMPING*BITQPTR-1:0] t9_dinA_a6;
wire [HEADC_NUMVBNK-1:0] t9_readB_a6;
wire [HEADC_NUMVBNK*HEADC_BITVROW-1:0] t9_addrB_a6;
reg  [HEADC_NUMVBNK*NUMPING*BITQPTR-1:0] t9_doutB_a6;
reg  [HEADC_NUMVBNK-1:0] t9_fwrdB_a6;
reg  [HEADC_NUMVBNK-1:0] t9_serrB_a6;
reg  [HEADC_NUMVBNK-1:0] t9_derrB_a6;
reg  [HEADC_NUMVBNK*HEADC_BITSROW-1:0] t9_padrB_a6;

wire [HEADS_NUMVBNK-1:0] t10_writeA_a6;
wire [HEADS_NUMVBNK*HEADS_BITVROW-1:0] t10_addrA_a6;
wire [HEADS_NUMVBNK*HEADD_BITVBNK-1:0] t10_dinA_a6;
wire [HEADS_NUMVBNK-1:0] t10_readB_a6;
wire [HEADS_NUMVBNK*HEADS_BITVROW-1:0] t10_addrB_a6;
reg  [HEADS_NUMVBNK*HEADD_BITVBNK-1:0] t10_doutB_a6;
reg  [HEADS_NUMVBNK-1:0] t10_fwrdB_a6;
reg  [HEADS_NUMVBNK-1:0] t10_serrB_a6;
reg  [HEADS_NUMVBNK-1:0] t10_derrB_a6;
reg  [HEADS_NUMVBNK*HEADS_BITSROW-1:0] t10_padrB_a6;

generate if (1) begin: a6_loop
  reg t6_writeA_a1_vec[0:NUMPOPT+NUMPUPT-1];
  reg [NUMPING*BITQPTR-1:0] t6_dinA_a1_vec [0:NUMPOPT+NUMPUPT-1];
  reg [BITQPRT-1:0]         t6_addrA_a1_vec[0:NUMPOPT+NUMPUPT-1];
  reg t6_readB_a1_vec[0:NUMPOPT+NUMPUPT-1];
  reg [BITQPRT-1:0]         t6_addrB_a1_vec[0:NUMPOPT+NUMPUPT-1];
  reg [NUMPING*BITQPTR-1:0] t6_doutB_a1_vec [0:NUMPOPT+NUMPUPT-1];

  integer a6v_int;
  always_comb
    for (a6v_int=0; a6v_int<NUMPOPT+NUMPUPT; a6v_int=a6v_int+1) begin
      t6_writeA_a1_vec[a6v_int] = t6_writeA_a1 >> a6v_int;
      t6_dinA_a1_vec[a6v_int] = t6_dinA_a1 >> (a6v_int*NUMPING*BITQPTR);
      t6_addrA_a1_vec[a6v_int] = t6_addrA_a1 >> (a6v_int*BITQPRT);
      t6_readB_a1_vec[a6v_int] = t6_readB_a1 >> a6v_int;
      t6_addrB_a1_vec[a6v_int] = t6_addrB_a1 >> (a6v_int*BITQPRT);
      t6_doutB_a1_vec[a6v_int] = t6_doutB_a1_int >> (a6v_int*NUMPING*BITQPTR);
    end

  reg [(NUMPOPT+NUMPUPT)-1:0]                 t6_writeA_a1_int;
  reg [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t6_dinA_a1_int;

  reg                       t6_writeA_a1_reg[0:NUMPUPT-1][0:LINK_DELAY+FLOPECC-1];
  reg [NUMPING*BITQPTR-1:0] t6_dinA_a1_reg[0:NUMPUPT-1][0:LINK_DELAY+FLOPECC-1];
  reg [BITQPRT-1:0]         t6_addrA_a1_reg[0:NUMPOPT+NUMPUPT-1][0:LINK_DELAY+FLOPECC-1];

  integer a6d_int, a6pu_int;
  always@(posedge clk) begin
    for(a6pu_int=0;a6pu_int<NUMPUPT; a6pu_int=a6pu_int+1) begin
      for(a6d_int=0;a6d_int<LINK_DELAY+FLOPECC; a6d_int=a6d_int+1) begin
        if (a6d_int > 0) begin
          t6_writeA_a1_reg[a6pu_int][a6d_int] <= t6_writeA_a1_reg[a6pu_int][a6d_int-1];
          t6_dinA_a1_reg[a6pu_int][a6d_int]   <= t6_dinA_a1_reg[a6pu_int][a6d_int-1];
          t6_addrA_a1_reg[a6pu_int][a6d_int]   <= t6_addrA_a1_reg[a6pu_int][a6d_int-1];
        end else begin
          t6_writeA_a1_reg[a6pu_int][a6d_int] <= t6_writeA_a1_vec[NUMPOPT+a6pu_int];
          t6_dinA_a1_reg[a6pu_int][a6d_int]   <= t6_dinA_a1_vec[NUMPOPT+a6pu_int];
          t6_addrA_a1_reg[a6pu_int][a6d_int]   <= t6_addrA_a1_vec[NUMPOPT+a6pu_int];
        end
      end
    end
  end

  integer a6w_int, a6wpu_int, a6wpo_int;
  always_comb begin
    t6_dinA_a1_int   = 0;
    for(a6wpo_int=0;a6wpo_int<NUMPOPT; a6wpo_int=a6wpo_int+1) begin
      t6_writeA_a1_int[a6wpo_int] = t6_writeA_a1_vec[a6wpo_int];
      t6_dinA_a1_int   = t6_dinA_a1_int | (t6_dinA_a1_vec[a6wpo_int] << (a6wpo_int*(NUMPING*BITQPTR)));
    end
    for(a6wpu_int=0;a6wpu_int<NUMPUPT; a6wpu_int=a6wpu_int+1) begin
      t6_writeA_a1_int[NUMPOPT+a6wpu_int] = t6_writeA_a1_reg[a6wpu_int][LINK_DELAY+FLOPECC-1];
      t6_dinA_a1_int   = t6_dinA_a1_int | (t6_dinA_a1_reg[a6wpu_int][LINK_DELAY+FLOPECC-1] << ((NUMPOPT+a6wpu_int)*NUMPING*BITQPTR));
    end
  end

  reg                       t6_readB_a1_reg[0:NUMPOPT+NUMPUPT-1][0:HEADD_DELAY+FLOPECC-1];
  reg [NUMPING*BITQPTR-1:0] t6_addrB_a1_reg[0:NUMPOPT+NUMPUPT-1][0:HEADD_DELAY+FLOPECC-1];

  integer a6r_int, a6rpu_int;
  always@(posedge clk) begin
    for(a6rpu_int=0;a6rpu_int<NUMPOPT+NUMPUPT; a6rpu_int=a6rpu_int+1) begin
      for(a6r_int=0;a6r_int<HEADD_DELAY+FLOPECC; a6r_int=a6r_int+1) begin
        if (a6r_int > 0) begin
          t6_readB_a1_reg[a6rpu_int][a6r_int] <= t6_readB_a1_reg[a6rpu_int][a6r_int-1];
        end else begin
          t6_readB_a1_reg[a6rpu_int][a6r_int] <= t6_readB_a1_vec[NUMPOPT+a6rpu_int];
        end
      end
      for(a6r_int=0;a6r_int<HEADD_DELAY+FLOPECC+LINK_DELAY+FLOPECC; a6r_int=a6r_int+1) begin
        if (a6r_int > 0) begin
          t6_addrB_a1_reg[a6rpu_int][a6r_int]   <= t6_addrB_a1_reg[a6rpu_int][a6r_int-1];
        end else begin
          t6_addrB_a1_reg[a6rpu_int][a6r_int]   <= t6_addrB_a1_vec[NUMPOPT+a6rpu_int];
        end
      end
    end
  end

  reg             t6_vldB_a1_reg [0:NUMPOPT+NUMPUPT-1][0:LINK_DELAY+FLOPECC-1];
  reg [NUMPING*BITQPTR-1:0] t6_doutB_a1_reg [0:NUMPOPT+NUMPUPT-1][0:LINK_DELAY+FLOPECC-1];
  integer a6pur_int, a6purf_int, a6purf2_int;
  always @(posedge clk) 
    for (a6pur_int=LINK_DELAY+FLOPECC-1; a6pur_int>=0; a6pur_int=a6pur_int-1)
      for (a6purf_int=0; a6purf_int<NUMPOPT+NUMPUPT; a6purf_int=a6purf_int+1)
        for (a6purf2_int=0; a6purf2_int<NUMPUPT; a6purf2_int=a6purf2_int+1)
          if (a6pur_int>0) begin
            if (t6_writeA_a1_reg[a6purf2_int][LINK_DELAY+FLOPECC-1] && (t6_addrA_a1_reg[a6purf2_int][LINK_DELAY+FLOPECC-1] == t6_addrB_a1_reg[a6purf_int][a6pur_int-1])) begin
              t6_vldB_a1_reg[a6purf_int][a6pur_int] <= 1'b1;
              t6_doutB_a1_reg[a6purf_int][a6pur_int] <= t6_dinA_a1_reg[a6purf2_int][LINK_DELAY+FLOPECC-1];
            end else begin
              t6_vldB_a1_reg[a6purf_int][a6pur_int] <= t6_vldB_a1_reg[a6purf_int][a6pur_int-1];
              t6_doutB_a1_reg[a6purf_int][a6pur_int] <= (t6_vldB_a1_reg[a6purf_int][a6pur_int-1]) ? t6_doutB_a1_reg[a6purf_int][a6pur_int-1] : t6_doutB_a1_reg[a6purf_int][a6pur_int];
            end
          end else begin
            if (t6_writeA_a1_reg[a6purf2_int][LINK_DELAY+FLOPECC-1] && (t6_addrA_a1_reg[a6purf2_int][LINK_DELAY+FLOPECC-1] == t6_addrB_a1_vec[a6purf_int])) begin
              t6_vldB_a1_reg[a6purf_int][a6pur_int] <= 1'b1;
              t6_doutB_a1_reg[a6purf_int][a6pur_int] <= t6_dinA_a1_reg[a6purf2_int][LINK_DELAY+FLOPECC-1];
            end else begin
              t6_vldB_a1_reg[a6purf_int][a6pur_int] <= 1'b0;
              t6_doutB_a1_reg[a6purf_int][a6pur_int] <= t6_doutB_a1_reg[a6purf_int][a6pur_int];
            end
          end

  integer t6_doutb_a6_int;
  reg [NUMPING*BITQPTR-1:0] t6_doutB_a1_fwrd [0:NUMPOPT+NUMPUPT-1];
  always_comb begin
    t6_doutB_a1 = 0;
    for (t6_doutb_a6_int=0; t6_doutb_a6_int<NUMPOPT+NUMPUPT; t6_doutb_a6_int=t6_doutb_a6_int+1) begin
      t6_doutB_a1_fwrd[t6_doutb_a6_int]  = (t6_vldB_a1_reg[t6_doutb_a6_int][HEADD_DELAY+FLOPECC-1]) ? t6_doutB_a1_reg[t6_doutb_a6_int][HEADD_DELAY+FLOPECC-1] : t6_doutB_a1_vec[t6_doutb_a6_int];
      t6_doutB_a1 = t6_doutB_a1 | (t6_doutB_a1_fwrd[t6_doutb_a6_int] << (t6_doutb_a6_int*NUMPING*BITQPTR));
    end
  end
  
  algo_nr2u_1r1w_a43 #(.WIDTH (NUMPING*BITQPTR), .ENAPSDO (0), .ENAPAR (0), .ENAECC (0),
                   .NUMRUPT (HEAD_NUMRUPT), .NUMADDR (NUMQPRT), .BITADDR (BITQPRT),
                   .NUMVROW (HEADD_NUMVROW), .BITVROW (HEADD_BITVROW), .NUMVBNK (HEAD_NUMVBNK), .BITVBNK (HEAD_BITVBNK), .BITPBNK (BITPBNK), .BITPADR (HEAD_BITPADR),
                   .SRAM_DELAY (HEADD_DELAY+FLOPECC), .UPD_DELAY (LINK_DELAY+FLOPECC), .FLOPIN(FLOPIN), .FLOPOUT(FLOPOUT))
    algo (.clk(clk), .rst(rst), .ready(a6_ready),
          .ru_write(t6_writeA_a1_int), .ru_din(t6_dinA_a1_int),
          .ru_read(t6_readB_a1), .ru_addr(t6_addrB_a1), .ru_vld(), .ru_dout(t6_doutB_a1_int),
          .ru_fwrd(), .ru_serr(), .ru_derr(), .ru_padr(),
          .t1_writeA(t8_writeA_a6), .t1_addrA(t8_addrA_a6), .t1_dinA(t8_dinA_a6),
          .t1_readB(t8_readB_a6), .t1_addrB(t8_addrB_a6), .t1_doutB(t8_doutB_a6),
          .t1_fwrdB(t8_fwrdB_a6), .t1_serrB(t8_serrB_a6), .t1_derrB(t8_derrB_a6), .t1_padrB(130'd0),
          .t2_writeA(t9_writeA_a6), .t2_addrA(t9_addrA_a6), .t2_dinA(t9_dinA_a6),
          .t2_readB(t9_readB_a6), .t2_addrB(t9_addrB_a6), .t2_doutB(t9_doutB_a6),
          .t2_fwrdB(t9_fwrdB_a6), .t2_serrB(t9_serrB_a6), .t2_derrB(t9_derrB_a6), .t2_padrB(26'd0),
          .t3_writeA(t10_writeA_a6), .t3_addrA(t10_addrA_a6), .t3_dinA(t10_dinA_a6),
          .t3_readB(t10_readB_a6), .t3_addrB(t10_addrB_a6), .t3_doutB(t10_doutB_a6),
          .t3_fwrdB(t10_fwrdB_a6), .t3_serrB(t10_serrB_a6), .t3_derrB(t10_derrB_a6), .t3_padrB(26'd0),
          .select_addr(select_qprt));

      end
endgenerate

wire t8_writeA_wire [0:HEAD_NUMRUPT-1][0:HEAD_NUMVBNK-1];
wire [HEADD_BITSROW-1:0] t8_addrA_wire [0:HEAD_NUMRUPT-1][0:HEAD_NUMVBNK-1];
wire [NUMWRDS*HEADD_WIDTH-1:0] t8_bwA_wire [0:HEAD_NUMRUPT-1][0:HEAD_NUMVBNK-1];
wire [NUMWRDS*HEADD_WIDTH-1:0] t8_dinA_wire [0:HEAD_NUMRUPT-1][0:HEAD_NUMVBNK-1];
wire t8_readB_wire [0:HEAD_NUMRUPT-1][0:HEAD_NUMVBNK-1];
wire [HEADD_BITSROW-1:0] t8_addrB_wire [0:HEAD_NUMRUPT-1][0:HEAD_NUMVBNK-1];

wire [NUMPING*BITQPTR-1:0] t8_doutB_a6_wire [0:HEAD_NUMRUPT-1][0:HEAD_NUMVBNK-1];
wire t8_fwrdB_a6_wire [0:HEAD_NUMRUPT-1][0:HEAD_NUMVBNK-1];
wire t8_serrB_a6_wire [0:HEAD_NUMRUPT-1][0:HEAD_NUMVBNK-1];
wire t8_derrB_a6_wire [0:HEAD_NUMRUPT-1][0:HEAD_NUMVBNK-1];
wire [HEADD_BITSROW+BITWRDS-1:0] t8_padrB_a6_wire [0:HEAD_NUMRUPT-1][0:HEAD_NUMVBNK-1];

genvar t8r, t8b;
generate
  for (t8r=0; t8r<HEAD_NUMRUPT; t8r=t8r+1) begin: t8r_loop
    for (t8b=0; t8b<HEAD_NUMVBNK; t8b=t8b+1) begin: t8b_loop
      wire t8_writeA_a6_wire = t8_writeA_a6 >> (t8r*HEAD_NUMVBNK+t8b);
      wire [HEADD_BITVROW-1:0] t8_addrA_a6_wire = t8_addrA_a6 >> ((t8r*HEAD_NUMVBNK+t8b)*HEADD_BITVROW);
      wire [NUMPING*BITQPTR-1:0] t8_dinA_a6_wire = t8_dinA_a6 >> ((t8r*HEAD_NUMVBNK+t8b)*NUMPING*BITQPTR);
      wire t8_readB_a6_wire = t8_readB_a6 >> (t8r*HEAD_NUMVBNK+t8b);
      wire [HEADD_BITVROW-1:0] t8_addrB_a6_wire = t8_addrB_a6 >> ((t8r*HEAD_NUMVBNK+t8b)*HEADD_BITVROW);

      wire [NUMWRDS*HEADD_WIDTH-1:0] t8_doutB_wire = t8_doutB >> ((t8r*HEAD_NUMVBNK+t8b)*HEADD_WIDTH);

      wire mem_write_t8r_wire;
      wire [HEADD_BITSROW-1:0] mem_wr_adr_t8r_wire;
      wire [NUMWRDS*HEADD_WIDTH-1:0] mem_bw_t8r_wire;
      wire [NUMWRDS*HEADD_WIDTH-1:0] mem_din_t8r_wire;
      wire mem_read_t8r_wire;
      wire [HEADD_BITSROW-1:0] mem_rd_adr_t8r_wire;
      wire [NUMWRDS*HEADD_WIDTH-1:0] mem_rd_dout_t8r_wire;
      wire mem_rd_fwrd_t8r_wire;
      wire mem_rd_serr_t8r_wire;
      wire mem_rd_derr_t8r_wire;
      wire [(BITWBNK+HEADD_BITSROW)-1:0] mem_rd_padr_t8r_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH (NUMPING*BITQPTR), .ENAPSDO (NUMWRDS==1), .ENAPAR (0), .ENAECC (1), .ECCWDTH (HEADD_WIDTH-NUMPING*BITQPTR), .ENAPADR (1),
                               .NUMADDR (HEADD_NUMVROW), .BITADDR (HEADD_BITVROW),
                               .NUMSROW (HEADD_NUMSROW), .BITSROW (HEADD_BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITWBNK+HEADD_BITSROW),
                               .SRAM_DELAY (HEADD_DELAY), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC))
          infra (.write(t8_writeA_a6_wire), .wr_adr(t8_addrA_a6_wire), .din(t8_dinA_a6_wire),
                 .read(t8_readB_a6_wire), .rd_adr(t8_addrB_a6_wire),
                 .rd_dout(t8_doutB_a6_wire[t8r][t8b]), .rd_fwrd(t8_fwrdB_a6_wire[t8r][t8b]),
                 .rd_serr(t8_serrB_a6_wire[t8r][t8b]), .rd_derr(t8_derrB_a6_wire[t8r][t8b]), .rd_padr(t8_padrB_a6_wire[t8r][t8b]),
                 .mem_write (mem_write_t8r_wire), .mem_wr_adr(mem_wr_adr_t8r_wire), .mem_bw (mem_bw_t8r_wire), .mem_din (mem_din_t8r_wire),
                 .mem_read (mem_read_t8r_wire), .mem_rd_adr(mem_rd_adr_t8r_wire), .mem_rd_dout (mem_rd_dout_t8r_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_t8r_wire), .mem_rd_padr(mem_rd_padr_t8r_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_head_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (NUMWRDS*HEADD_WIDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (NUMSROW), .BITADDR (HEADD_BITSROW),
                           .NUMWROW (NUMWROW), .BITWROW (HEADD_BITSROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                           .SRAM_DELAY (HEADD_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (0))
          infra (.write (mem_write_t8r_wire), .wr_adr (mem_wr_adr_t8r_wire), .bw (mem_bw_t8r_wire), .din (mem_din_t8r_wire),
                 .read (mem_read_t8r_wire), .rd_adr (mem_rd_adr_t8r_wire), .rd_dout (mem_rd_dout_t8r_wire),
                 .rd_fwrd (mem_rd_fwrd_t8r_wire), .rd_serr (mem_rd_serr_t8r_wire), .rd_derr(mem_rd_derr_t8r_wire), .rd_padr(mem_rd_padr_t8r_wire),
                 .mem_write (t8_writeA_wire[t8r][t8b]), .mem_wr_adr(t8_addrA_wire[t8r][t8b]),
                 .mem_bw (t8_bwA_wire[t8r][t8b]), .mem_din (t8_dinA_wire[t8r][t8b]),
                 .mem_read (t8_readB_wire[t8r][t8b]), .mem_rd_adr(t8_addrB_wire[t8r][t8b]), .mem_rd_dout (t8_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_head_srow));
      end
    end
  end
endgenerate

reg [HEADD_NUMVBNK-1:0] t8_writeA;
reg [HEADD_NUMVBNK*HEADD_BITSROW-1:0] t8_addrA;
reg [HEADD_NUMVBNK*HEADD_WIDTH-1:0] t8_bwA;
reg [HEADD_NUMVBNK*HEADD_WIDTH-1:0] t8_dinA;
reg [HEADD_NUMVBNK-1:0] t8_readB;
reg [HEADD_NUMVBNK*HEADD_BITSROW-1:0] t8_addrB;
integer t8r_int, t8b_int;
always_comb begin
  t8_writeA = 0;
  t8_addrA = 0;
  t8_bwA = 0;
  t8_dinA = 0;
  t8_readB = 0;
  t8_addrB = 0;
  t8_doutB_a6 = 0;
  t8_fwrdB_a6 = 0;
  t8_serrB_a6 = 0;
  t8_derrB_a6 = 0;
  t8_padrB_a6 = 0;
  for (t8r_int=0; t8r_int<HEAD_NUMRUPT; t8r_int=t8r_int+1) begin
    for (t8b_int=0; t8b_int<HEAD_NUMVBNK; t8b_int=t8b_int+1) begin
      t8_writeA = t8_writeA | (t8_writeA_wire[t8r_int][t8b_int] << (t8r_int*HEAD_NUMVBNK+t8b_int));
      t8_addrA = t8_addrA | (t8_addrA_wire[t8r_int][t8b_int] << ((t8r_int*HEAD_NUMVBNK+t8b_int)*HEADD_BITSROW));
      t8_bwA = t8_bwA | (t8_bwA_wire[t8r_int][t8b_int] << ((t8r_int*HEAD_NUMVBNK+t8b_int)*HEADD_WIDTH));
      t8_dinA = t8_dinA | (t8_dinA_wire[t8r_int][t8b_int] << ((t8r_int*HEAD_NUMVBNK+t8b_int)*HEADD_WIDTH));
      t8_readB = t8_readB | (t8_readB_wire[t8r_int][t8b_int] << (t8r_int*HEAD_NUMVBNK+t8b_int));
      t8_addrB = t8_addrB | (t8_addrB_wire[t8r_int][t8b_int] << ((t8r_int*HEAD_NUMVBNK+t8b_int)*HEADD_BITSROW));
      t8_doutB_a6 = t8_doutB_a6 | (t8_doutB_a6_wire[t8r_int][t8b_int] << ((t8r_int*HEAD_NUMVBNK+t8b_int)*NUMPING*BITQPTR));
      t8_fwrdB_a6 = t8_fwrdB_a6 | (t8_fwrdB_a6_wire[t8r_int][t8b_int] << (t8r_int*HEAD_NUMVBNK+t8b_int));
      t8_serrB_a6 = t8_serrB_a6 | (t8_serrB_a6_wire[t8r_int][t8b_int] << (t8r_int*HEAD_NUMVBNK+t8b_int));
      t8_derrB_a6 = t8_derrB_a6 | (t8_derrB_a6_wire[t8r_int][t8b_int] << (t8r_int*HEAD_NUMVBNK+t8b_int));
      t8_padrB_a6 = t8_padrB_a6 | (t8_padrB_a6_wire[t8r_int][t8b_int] << ((t8r_int*HEAD_NUMVBNK+t8b_int)*(HEADD_BITSROW+BITWRDS)));
    end
  end
end

wire t9_writeA_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire [HEADC_BITSROW-1:0] t9_addrA_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire [NUMWRDS*HEADC_WIDTH-1:0] t9_bwA_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire [NUMWRDS*HEADC_WIDTH-1:0] t9_dinA_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire t9_readB_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire [HEADC_BITSROW-1:0] t9_addrB_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire [NUMPING*BITQPTR-1:0] t9_doutB_a6_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire t9_fwrdB_a6_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire t9_serrB_a6_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire t9_derrB_a6_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire [HEADC_BITSROW+BITWRDS-1:0] t9_padrB_a6_wire [0:(HEAD_NUMRUPT)-1][0:1-1];

genvar t9r, t9b;
generate
  for (t9r=0; t9r<(HEAD_NUMRUPT); t9r=t9r+1) begin: t9r_loop
    for (t9b=0; t9b<1; t9b=t9b+1) begin: t9b_loop
      wire t9_writeA_a6_wire = t9_writeA_a6 >> (t9r*1+t9b);
      wire [HEADC_BITVROW-1:0] t9_addrA_a6_wire = t9_addrA_a6 >> ((t9r*1+t9b)*HEADC_BITVROW);
      wire [NUMPING*BITQPTR-1:0] t9_dinA_a6_wire = t9_dinA_a6 >> ((t9r*1+t9b)*NUMPING*BITQPTR);
      wire t9_readB_a6_wire = t9_readB_a6 >> (t9r*1+t9b);
      wire [HEADC_BITVROW-1:0] t9_addrB_a6_wire = t9_addrB_a6 >> ((t9r*1+t9b)*HEADC_BITVROW);

      wire [NUMWRDS*HEADC_WIDTH-1:0] t9_doutB_wire = t9_doutB >> ((t9r*1+t9b)*HEADC_WIDTH);

      wire mem_write_t9r_wire;
      wire [HEADC_BITSROW-1:0] mem_wr_adr_t9r_wire;
      wire [NUMWRDS*HEADC_WIDTH-1:0] mem_bw_t9r_wire;
      wire [NUMWRDS*HEADC_WIDTH-1:0] mem_din_t9r_wire;
      wire mem_read_t9r_wire;
      wire [HEADC_BITSROW-1:0] mem_rd_adr_t9r_wire;
      wire [NUMWRDS*HEADC_WIDTH-1:0] mem_rd_dout_t9r_wire;
      wire mem_rd_fwrd_t9r_wire;
      wire mem_rd_serr_t9r_wire;
      wire mem_rd_derr_t9r_wire;
      wire [(BITWBNK+HEADC_BITSROW)-1:0] mem_rd_padr_t9r_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH (NUMPING*BITQPTR), .ENAPSDO (1'b1), .ENAPAR (0), .ENAECC (1), .ECCWDTH (HEADC_WIDTH-NUMPING*BITQPTR), .ENAPADR (1),
                               .NUMADDR (HEADC_NUMVROW), .BITADDR (HEADC_BITVROW),
                               .NUMSROW (HEADC_NUMSROW), .BITSROW (HEADC_BITSROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITWRDS+BITWBNK+HEADC_BITSROW),
                               .SRAM_DELAY (HEADC_DELAY), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.write(t9_writeA_a6_wire), .wr_adr(t9_addrA_a6_wire), .din(t9_dinA_a6_wire),
                 .read(t9_readB_a6_wire), .rd_adr(t9_addrB_a6_wire),
                 .rd_dout(t9_doutB_a6_wire[t9r][t9b]), .rd_fwrd(t9_fwrdB_a6_wire[t9r][t9b]),
                 .rd_serr(t9_serrB_a6_wire[t9r][t9b]), .rd_derr(t9_derrB_a6_wire[t9r][t9b]), .rd_padr(t9_padrB_a6_wire[t9r][t9b]),
                 .mem_write (mem_write_t9r_wire), .mem_wr_adr(mem_wr_adr_t9r_wire), .mem_bw (mem_bw_t9r_wire), .mem_din (mem_din_t9r_wire),
                 .mem_read (mem_read_t9r_wire), .mem_rd_adr(mem_rd_adr_t9r_wire), .mem_rd_dout (mem_rd_dout_t9r_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_t9r_wire), .mem_rd_padr(mem_rd_padr_t9r_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_head_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (NUMWRDS*HEADC_WIDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (HEADC_NUMSROW), .BITADDR (HEADC_BITSROW),
                           .NUMWROW (NUMWROW), .BITWROW (HEADC_BITSROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                           .SRAM_DELAY (HEADC_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (0), .RSTZERO (1))
          infra (.write (mem_write_t9r_wire), .wr_adr (mem_wr_adr_t9r_wire), .bw (mem_bw_t9r_wire), .din (mem_din_t9r_wire),
                 .read (mem_read_t9r_wire), .rd_adr (mem_rd_adr_t9r_wire), .rd_dout (mem_rd_dout_t9r_wire),
                 .rd_fwrd (mem_rd_fwrd_t9r_wire), .rd_serr (mem_rd_serr_t9r_wire), .rd_derr(mem_rd_derr_t9r_wire), .rd_padr(mem_rd_padr_t9r_wire),
                 .mem_write (t9_writeA_wire[t9r][t9b]), .mem_wr_adr(t9_addrA_wire[t9r][t9b]),
                 .mem_bw (t9_bwA_wire[t9r][t9b]), .mem_din (t9_dinA_wire[t9r][t9b]),
                 .mem_read (t9_readB_wire[t9r][t9b]), .mem_rd_adr(t9_addrB_wire[t9r][t9b]), .mem_rd_dout (t9_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_head_srow));
      end
    end
  end
endgenerate

reg [(HEAD_NUMRUPT)-1:0] t9_writeA;
reg [(HEAD_NUMRUPT)*HEADC_BITSROW-1:0] t9_addrA;
reg [(HEAD_NUMRUPT)*HEADC_WIDTH-1:0] t9_bwA;
reg [(HEAD_NUMRUPT)*HEADC_WIDTH-1:0] t9_dinA;
reg [(HEAD_NUMRUPT)-1:0] t9_readB;
reg [(HEAD_NUMRUPT)*HEADC_BITSROW-1:0] t9_addrB;
integer t9r_int, t9b_int;
always_comb begin
  t9_writeA = 0;
  t9_addrA = 0;
  t9_bwA = 0;
  t9_dinA = 0;
  t9_readB = 0;
  t9_addrB = 0;
  t9_doutB_a6 = 0;
  t9_fwrdB_a6 = 0;
  t9_serrB_a6 = 0;
  t9_derrB_a6 = 0;
  t9_padrB_a6 = 0;
  for (t9r_int=0; t9r_int<HEAD_NUMRUPT; t9r_int=t9r_int+1) begin
    for (t9b_int=0; t9b_int<1; t9b_int=t9b_int+1) begin
      t9_writeA = t9_writeA | (t9_writeA_wire[t9r_int][t9b_int] << (t9r_int*1+t9b_int));
      t9_addrA = t9_addrA | (t9_addrA_wire[t9r_int][t9b_int] << ((t9r_int*1+t9b_int)*HEADC_BITSROW));
      t9_bwA = t9_bwA | (t9_bwA_wire[t9r_int][t9b_int] << ((t9r_int*1+t9b_int)*HEADC_WIDTH));
      t9_dinA = t9_dinA | (t9_dinA_wire[t9r_int][t9b_int] << ((t9r_int*1+t9b_int)*HEADC_WIDTH));
      t9_readB = t9_readB | (t9_readB_wire[t9r_int][t9b_int] << (t9r_int*1+t9b_int));
      t9_addrB = t9_addrB | (t9_addrB_wire[t9r_int][t9b_int] << ((t9r_int*1+t9b_int)*HEADC_BITSROW));
      t9_doutB_a6 = t9_doutB_a6 | (t9_doutB_a6_wire[t9r_int][t9b_int] << ((t9r_int*1+t9b_int)*NUMPING*BITQPTR));
      t9_fwrdB_a6 = t9_fwrdB_a6 | (t9_fwrdB_a6_wire[t9r_int][t9b_int] << (t9r_int*1+t9b_int));
      t9_serrB_a6 = t9_serrB_a6 | (t9_serrB_a6_wire[t9r_int][t9b_int] << (t9r_int*1+t9b_int));
      t9_derrB_a6 = t9_derrB_a6 | (t9_derrB_a6_wire[t9r_int][t9b_int] << (t9r_int*1+t9b_int));
      t9_padrB_a6 = t9_padrB_a6 | (t9_padrB_a6_wire[t9r_int][t9b_int] << ((t9r_int*1+t9b_int)*(HEADC_BITSROW+BITWRDS)));
    end
  end
end

wire t10_writeA_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire [HEADS_BITVROW-1:0] t10_addrA_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire [HEADS_WIDTH-1:0] t10_bwA_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire [HEADS_WIDTH-1:0] t10_dinA_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire t10_readB_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire [HEADS_BITVROW-1:0] t10_addrB_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire [HEADD_BITVBNK-1:0] t10_doutB_a6_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire t10_fwrdB_a6_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire t10_serrB_a6_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire t10_derrB_a6_wire [0:(HEAD_NUMRUPT)-1][0:1-1];
wire [HEADS_BITVROW-1:0] t10_padrB_a6_wire [0:(HEAD_NUMRUPT)-1][0:1-1];

genvar t10r, t10b;
generate
  for (t10r=0; t10r<HEAD_NUMRUPT; t10r=t10r+1) begin: t10r_loop
    for (t10b=0; t10b<1; t10b=t10b+1) begin: t10b_loop
      wire t10_writeA_a6_wire = t10_writeA_a6 >> (t10r*1+t10b);
      wire [HEADS_BITVROW-1:0] t10_addrA_a6_wire = t10_addrA_a6 >> ((t10r*1+t10b)*HEADS_BITVROW);
      wire [HEADD_BITVBNK-1:0] t10_dinA_a6_wire = t10_dinA_a6 >> ((t10r*1+t10b)*(HEADD_BITVBNK));
      wire t10_readB_a6_wire = t10_readB_a6 >> (t10r*1+t10b);
      wire [HEADS_BITVROW-1:0] t10_addrB_a6_wire = t10_addrB_a6 >> ((t10r*1+t10b)*HEADS_BITVROW);

      wire [HEADS_WIDTH-1:0] t10_doutB_wire = t10_doutB >> ((t10r*1+t10b)*HEADS_WIDTH);

      wire mem_write_t10r_wire;
      wire [HEADS_BITVROW-1:0] mem_wr_adr_t10r_wire;
      wire [HEADS_WIDTH-1:0] mem_bw_t10r_wire;
      wire [HEADS_WIDTH-1:0] mem_din_t10r_wire;
      wire mem_read_t10r_wire;
      wire [HEADS_BITVROW-1:0] mem_rd_adr_t10r_wire;
      wire [HEADS_WIDTH-1:0] mem_rd_dout_t10r_wire;
      wire mem_rd_fwrd_t10r_wire;
      wire mem_rd_serr_t10r_wire;
      wire mem_rd_derr_t10r_wire;
      wire [HEADS_BITVROW-1:0] mem_rd_padr_t10r_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH (HEADD_BITVBNK), .ENAPSDO (1), .ENADEC(1), .ECCWDTH (HEADS_ECCWDTH), .ENAPADR (1),
                               .NUMADDR (HEADS_NUMVROW), .BITADDR (HEADS_BITVROW),
                               .NUMSROW (HEADS_NUMVROW), .BITSROW (HEADS_BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (HEADS_BITVROW),
                               .SRAM_DELAY (HEADS_DELAY), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.write(t10_writeA_a6_wire), .wr_adr(t10_addrA_a6_wire), .din(t10_dinA_a6_wire),
                 .read(t10_readB_a6_wire), .rd_adr(t10_addrB_a6_wire),
                 .rd_dout(t10_doutB_a6_wire[t10r][t10b]), .rd_fwrd(t10_fwrdB_a6_wire[t10r][t10b]),
                 .rd_serr(t10_serrB_a6_wire[t10r][t10b]), .rd_derr(t10_derrB_a6_wire[t10r][t10b]), .rd_padr(t10_padrB_a6_wire[t10r][t10b]),
                 .mem_write (mem_write_t10r_wire), .mem_wr_adr(mem_wr_adr_t10r_wire), .mem_bw (mem_bw_t10r_wire), .mem_din (mem_din_t10r_wire),
                 .mem_read (mem_read_t10r_wire), .mem_rd_adr(mem_rd_adr_t10r_wire), .mem_rd_dout (mem_rd_dout_t10r_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_t10r_wire), .mem_rd_padr(mem_rd_padr_t10r_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_head_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (HEADS_WIDTH), .ENAPSDO (0), .NUMADDR (HEADS_NUMVROW), .BITADDR (HEADS_BITVROW),
                           .NUMWROW (HEADS_NUMVROW), .BITWROW (HEADS_BITVROW), .NUMWBNK (1), .BITWBNK (0),
                           .SRAM_DELAY (HEADS_DELAY), .FLOPCMD (0), .FLOPMEM (0), .RSTZERO (1))
          infra (.write (mem_write_t10r_wire), .wr_adr (mem_wr_adr_t10r_wire), .bw (mem_bw_t10r_wire), .din (mem_din_t10r_wire),
                 .read (mem_read_t10r_wire), .rd_adr (mem_rd_adr_t10r_wire), .rd_dout (mem_rd_dout_t10r_wire),
                 .rd_fwrd (mem_rd_fwrd_t10r_wire), .rd_serr (mem_rd_serr_t10r_wire), .rd_derr(mem_rd_derr_t10r_wire), .rd_padr(mem_rd_padr_t10r_wire),
                 .mem_write (t10_writeA_wire[t10r][t10b]), .mem_wr_adr(t10_addrA_wire[t10r][t10b]),
                 .mem_bw (t10_bwA_wire[t10r][t10b]), .mem_din (t10_dinA_wire[t10r][t10b]),
                 .mem_read (t10_readB_wire[t10r][t10b]), .mem_rd_adr(t10_addrB_wire[t10r][t10b]), .mem_rd_dout (t10_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_head_vrow));
      end
    end
  end
endgenerate

reg [(HEAD_NUMRUPT)-1:0] t10_writeA;
reg [(HEAD_NUMRUPT)*HEADS_BITVROW-1:0] t10_addrA;
reg [(HEAD_NUMRUPT)*HEADS_WIDTH-1:0] t10_bwA;
reg [(HEAD_NUMRUPT)*HEADS_WIDTH-1:0] t10_dinA;
reg [(HEAD_NUMRUPT)-1:0] t10_readB;
reg [(HEAD_NUMRUPT)*HEADS_BITVROW-1:0] t10_addrB;
integer t10r_int, t10b_int;
always_comb begin
  t10_writeA = 0;
  t10_addrA = 0;
  t10_bwA = 0;
  t10_dinA = 0;
  t10_readB = 0;
  t10_addrB = 0;
  t10_doutB_a6 = 0;
  t10_fwrdB_a6 = 0;
  t10_serrB_a6 = 0;
  t10_derrB_a6 = 0;
  t10_padrB_a6 = 0;
  for (t10r_int=0; t10r_int<HEAD_NUMRUPT; t10r_int=t10r_int+1) begin
    for (t10b_int=0; t10b_int<1; t10b_int=t10b_int+1) begin
      t10_writeA = t10_writeA | (t10_writeA_wire[t10r_int][t10b_int] << (t10r_int*1+t10b_int));
      t10_addrA = t10_addrA | (t10_addrA_wire[t10r_int][t10b_int] << ((t10r_int*1+t10b_int)*HEADS_BITVROW));
      t10_bwA = t10_bwA | (t10_bwA_wire[t10r_int][t10b_int] << ((t10r_int*1+t10b_int)*HEADS_WIDTH));
      t10_dinA = t10_dinA | (t10_dinA_wire[t10r_int][t10b_int] << ((t10r_int*1+t10b_int)*HEADS_WIDTH));
      t10_readB = t10_readB | (t10_readB_wire[t10r_int][t10b_int] << (t10r_int*1+t10b_int));
      t10_addrB = t10_addrB | (t10_addrB_wire[t10r_int][t10b_int] << ((t10r_int*1+t10b_int)*HEADS_BITVROW));
      t10_doutB_a6 = t10_doutB_a6 | (t10_doutB_a6_wire[t10r_int][t10b_int] << ((t10r_int*1+t10b_int)*(HEADD_BITVBNK)));
      t10_fwrdB_a6 = t10_fwrdB_a6 | (t10_fwrdB_a6_wire[t10r_int][t10b_int] << (t10r_int*1+t10b_int));
      t10_serrB_a6 = t10_serrB_a6 | (t10_serrB_a6_wire[t10r_int][t10b_int] << (t10r_int*1+t10b_int));
      t10_derrB_a6 = t10_derrB_a6 | (t10_derrB_a6_wire[t10r_int][t10b_int] << (t10r_int*1+t10b_int));
      t10_padrB_a6 = t10_padrB_a6 | (t10_padrB_a6_wire[t10r_int][t10b_int] << ((t10r_int*1+t10b_int)*(HEADS_BITSROW+BITWRDS)));
    end
  end
end

wire [NUMPUPT-1:0]                     t11_writeA_a7;
wire [NUMPUPT*BITQPRT-1:0]             t11_addrA_a7;
wire [NUMPUPT*NUMPING*BITQPTR-1:0]     t11_dinA_a7;
wire [NUMPOPT-1:0]                     t11_readB_a7;
wire [NUMPOPT*BITQPRT-1:0]             t11_addrB_a7;

reg  [NUMPOPT*NUMPING*BITQPTR-1:0]     t11_doutB_a7;
reg  [NUMPOPT-1:0]                     t11_fwrdB_a7;
reg  [NUMPOPT-1:0]                     t11_serrB_a7;
reg  [NUMPOPT-1:0]                     t11_derrB_a7;
reg  [NUMPOPT*BITQPRT-1:0]             t11_padrB_a7;

generate if (1) begin: a7_loop

  algo_nru_1r1w #(.BITWDTH (TAIL_BITWDTH), .WIDTH (NUMPING*BITQPTR), .NUMRUPT (TAIL_NUMRUPT), .NUMADDR (NUMQPRT), .BITADDR (BITQPRT), .BITPADR (BITQPRT),
                  .NUMVROW(NUMQPRT), .BITVROW(BITQPRT), .NUMWRDS(1), .BITWRDS(0),
                  .NUMPBNK(1), .BITPBNK(0),
                  .SRAM_DELAY (TAIL_DELAY+1), .UPD_DELAY (TAIL_UPD_DELAY), .FLOPIN (0), .FLOPOUT (0))
  algo (.clk(clk), .rst(rst), .ready(a7_ready),
        .read(t11_readB_a1), .write(t11_writeA_a1), .addr(t11_addrB_a1), .din(t11_dinA_a1), .rd_vld(), .rd_dout(t11_doutB_a1),
        .rd_fwrd(), .rd_serr(), .rd_derr(), .rd_padr(),
        .t1_writeA(t11_writeA_a7), .t1_addrA(t11_addrA_a7), .t1_dinA(t11_dinA_a7),
        .t1_readB(t11_readB_a7), .t1_addrB(t11_addrB_a7), .t1_doutB(t11_doutB_a7),
        .t1_fwrdB(t11_fwrdB_a7), .t1_serrB(t11_serrB_a7), .t1_derrB(t11_derrB_a7), .t1_padrB(t11_padrB_a7),
        .select_addr(select_qprt));
  end
endgenerate

wire t11_writeA_wire [0:NUMPUPT-1];
wire [BITQPRT-1:0] t11_addrA_wire [0:NUMPUPT-1];
wire [TAIL_WIDTH-1:0] t11_bwA_wire [0:NUMPUPT-1];
wire [TAIL_WIDTH-1:0] t11_dinA_wire [0:NUMPUPT-1];
wire t11_readB_wire [0:NUMPUPT-1];
wire [BITQPRT-1:0] t11_addrB_wire [0:NUMPUPT-1];
wire [NUMPING*BITQPTR-1:0] t11_doutB_a7_wire [0:NUMPUPT-1];
wire t11_fwrdB_a7_wire [0:NUMPUPT-1];
wire t11_serrB_a7_wire [0:NUMPUPT-1];
wire t11_derrB_a7_wire [0:NUMPUPT-1];
wire [BITQPRT-1:0] t11_padrB_a7_wire [0:NUMPUPT-1];

genvar t11r;
generate
  for (t11r=0; t11r<NUMPUPT; t11r=t11r+1) begin: t11r_loop
    wire t11_writeA_a7_wire = t11_writeA_a7 >> (t11r);
    wire [BITQPRT-1:0] t11_addrA_a7_wire = t11_addrA_a7 >> (t11r*BITQPRT);
    wire [NUMPING*BITQPTR-1:0] t11_dinA_a7_wire = t11_dinA_a7 >> (t11r*NUMPING*BITQPTR);
    wire t11_readB_a7_wire = t11_readB_a7 >> (t11r);
    wire [BITQPRT-1:0] t11_addrB_a7_wire = t11_addrB_a7 >> (t11r*BITQPRT);

    wire [NUMPUPT*TAIL_WIDTH-1:0] t11_doutB_wire = t11_doutB >> (t11r*TAIL_WIDTH);

    wire t11_mem_write_wire;
    wire [BITQPRT-1:0] t11_mem_wr_adr_wire;
    wire [TAIL_WIDTH-1:0] t11_mem_bw_wire;
    wire [TAIL_WIDTH-1:0] t11_mem_din_wire;
    wire t11_mem_read_wire;
    wire [BITQPRT-1:0] t11_mem_rd_adr_wire;
    wire [TAIL_WIDTH-1:0] t11_mem_rd_dout_wire;
    wire t11_mem_rd_fwrd_wire;
    wire t11_mem_rd_serr_wire;
    wire t11_mem_rd_derr_wire;
    wire [BITQPRT-1:0] t11_mem_rd_padr_wire;

    if (1) begin: align_loop
      infra_align_ecc_1r1w #(.WIDTH (NUMPING*BITQPTR), .ENAPSDO (0), .ENAECC (1), .ECCWDTH (TAIL_WIDTH-NUMPING*BITQPTR), .ENAPADR (0),
                             .NUMADDR (NUMQPRT), .BITADDR (BITQPRT),
                             .NUMSROW (NUMQPRT), .BITSROW (BITQPRT), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITQPRT),
                             .SRAM_DELAY (TAIL_DELAY), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC))
        infra (.write(t11_writeA_a7_wire), .wr_adr(t11_addrA_a7_wire), .din(t11_dinA_a7_wire),
               .read(t11_readB_a7_wire), .rd_adr(t11_addrB_a7_wire),
               .rd_dout(t11_doutB_a7_wire[t11r]), .rd_fwrd(t11_fwrdB_a7_wire[t11r]),
               .rd_serr(t11_serrB_a7_wire[t11r]), .rd_derr(t11_derrB_a7_wire[t11r]), .rd_padr(t11_padrB_a7_wire[t11r]),
               .mem_write (t11_mem_write_wire), .mem_wr_adr(t11_mem_wr_adr_wire), .mem_bw (t11_mem_bw_wire), .mem_din (t11_mem_din_wire),
               .mem_read (t11_mem_read_wire), .mem_rd_adr(t11_mem_rd_adr_wire), .mem_rd_dout (t11_mem_rd_dout_wire),
               .mem_rd_fwrd(t11_mem_rd_fwrd_wire), .mem_rd_padr(t11_mem_rd_padr_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_tail_vrow));
    end

    if (1) begin: stack_loop
      infra_stack_1r1w #(.WIDTH (TAIL_WIDTH), .ENAPSDO (0), .NUMADDR (NUMQPRT), .BITADDR (BITQPRT),
                         .NUMWROW (NUMQPRT), .BITWROW (BITQPRT), .NUMWBNK (1), .BITWBNK (0),
                         .SRAM_DELAY (TAIL_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
        infra (.write (t11_mem_write_wire), .wr_adr (t11_mem_wr_adr_wire), .bw (t11_mem_bw_wire), .din (t11_mem_din_wire),
               .read (t11_mem_read_wire), .rd_adr (t11_mem_rd_adr_wire), .rd_dout (t11_mem_rd_dout_wire),
               .rd_fwrd (t11_mem_rd_fwrd_wire), .rd_serr (t11_mem_rd_serr_wire), .rd_derr(t11_mem_rd_derr_wire), .rd_padr(t11_mem_rd_padr_wire),
               .mem_write (t11_writeA_wire[t11r]), .mem_wr_adr(t11_addrA_wire[t11r]),
               .mem_bw (t11_bwA_wire[t11r]), .mem_din (t11_dinA_wire[t11r]),
               .mem_read (t11_readB_wire[t11r]), .mem_rd_adr(t11_addrB_wire[t11r]), .mem_rd_dout (t11_doutB_wire),
               .clk (clk), .rst(rst),
               .select_addr (select_tail_srow));
    end
  end
endgenerate

reg [NUMPUPT-1:0] t11_writeA;
reg [NUMPUPT*BITQPRT-1:0] t11_addrA;
reg [NUMPUPT*TAIL_WIDTH-1:0] t11_bwA;
reg [NUMPUPT*TAIL_WIDTH-1:0] t11_dinA;
reg [NUMPUPT-1:0] t11_readB;
reg [NUMPUPT*BITQPRT-1:0] t11_addrB;
integer t11r_int;
always_comb begin
  t11_writeA = 0;
  t11_addrA = 0;
  t11_bwA = 0;
  t11_dinA = 0;
  t11_readB = 0;
  t11_addrB = 0;
  t11_doutB_a7 = 0;
  t11_fwrdB_a7 = 0;
  t11_serrB_a7 = 0;
  t11_derrB_a7 = 0;
  t11_padrB_a7 = 0;
  for (t11r_int=0; t11r_int<NUMPUPT; t11r_int=t11r_int+1) begin
    t11_writeA = t11_writeA | (t11_writeA_wire[t11r_int] << (t11r_int));
    t11_addrA = t11_addrA | (t11_addrA_wire[t11r_int] << (t11r_int*BITQPRT));
    t11_bwA = t11_bwA | (t11_bwA_wire[t11r_int] << (t11r_int*TAIL_WIDTH));
    t11_dinA = t11_dinA | (t11_dinA_wire[t11r_int] << (t11r_int*TAIL_WIDTH));
    t11_readB = t11_readB | (t11_readB_wire[t11r_int] << (t11r_int));
    t11_addrB = t11_addrB | (t11_addrB_wire[t11r_int] << (t11r_int*BITQPRT));
    t11_doutB_a7 = t11_doutB_a7 | (t11_doutB_a7_wire[t11r_int] << (t11r_int*NUMPING*BITQPTR));
    t11_fwrdB_a7 = t11_fwrdB_a7 | (t11_fwrdB_a7_wire[t11r_int] << (t11r_int));
    t11_serrB_a7 = t11_serrB_a7 | (t11_serrB_a7_wire[t11r_int] << (t11r_int));
    t11_derrB_a7 = t11_derrB_a7 | (t11_derrB_a7_wire[t11r_int] << (t11r_int));
    t11_padrB_a7 = t11_padrB_a7 | (t11_padrB_a7_wire[t11r_int] << (t11r_int*BITQPRT));
  end
end

endmodule
