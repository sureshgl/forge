
module algo_mrnw_pque_f32 (push, pu_prt, pu_ptr, pu_din, pu_cvld, pu_cnt,
                           pop, po_ndq, po_prt, po_cvld, po_cmt, po_cnt, po_pvld, po_ptr, po_dvld, po_dout,
                           cp_read, cp_write, cp_adr, cp_din, cp_vld, cp_dout,
                           t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
                           t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
                           t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
                           t4_writeA, t4_addrA, t4_dinA, t4_readB, t4_addrB, t4_doutB,
                           t5_writeA, t5_addrA, t5_dinA, t5_readB, t5_addrB, t5_doutB,
                           t6_writeA, t6_addrA, t6_dinA, t6_readB, t6_addrB, t6_doutB,
                           t7_writeA, t7_addrA, t7_dinA, t7_readB, t7_addrB, t7_doutB,
                           clk, rst, ready,
                           select_qprt, select_addr);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMPUPT = 1;
  parameter NUMPOPT = 1;
  parameter NUMQPRT = 64;
  parameter BITQPRT = 6;
  parameter NUMPING = 2;
  parameter BITPING = 1;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter BITPADR = 15;
  parameter BITQPTR = BITADDR;
  parameter BITQCNT = BITADDR+1;

  parameter QPTR_DELAY = 2;
  parameter LINK_DELAY = 2;
  parameter DATA_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter BITCPAD = BITQPRT;
  parameter CPUWDTH = 2*BITPING+BITQCNT+2*NUMPING*BITQPTR;

  input [NUMPUPT-1:0]              push;
  input [NUMPUPT*BITQPRT-1:0]      pu_prt;
  input [NUMPUPT*BITQPTR-1:0]      pu_ptr;
  input [NUMPUPT*WIDTH-1:0]        pu_din;
  output [NUMPUPT-1:0]             pu_cvld;
  output [NUMPUPT*BITQCNT-1:0]     pu_cnt;

  input [NUMPOPT-1:0]              pop;
  input [NUMPOPT-1:0]              po_ndq;
  input [NUMPOPT*BITQPRT-1:0]      po_prt;
  output [NUMPOPT-1:0]             po_cvld;
  output [NUMPOPT-1:0]             po_cmt;
  output [NUMPOPT*BITQCNT-1:0]     po_cnt;
  output [NUMPOPT-1:0]             po_pvld;
  output [NUMPOPT*BITQPTR-1:0]     po_ptr;
  output [NUMPOPT-1:0]             po_dvld;
  output [NUMPOPT*WIDTH-1:0]       po_dout;

  input                            cp_read;
  input                            cp_write;
  input [BITCPAD-1:0]              cp_adr;
  input [CPUWDTH-1:0]              cp_din;
  output                           cp_vld;
  output [CPUWDTH-1:0]             cp_dout;

  output                           ready;
  input                            clk;
  input                            rst;

  input [BITQPRT-1:0]            select_qprt;
  input [BITADDR-1:0]            select_addr;

  output [NUMPUPT-1:0]                     t1_writeA;
  output [NUMPUPT*BITADDR-1:0]             t1_addrA;
  output [NUMPUPT*BITQPTR-1:0]             t1_dinA;
  output [NUMPOPT-1:0]                     t1_readB;
  output [NUMPOPT*BITADDR-1:0]             t1_addrB;
  input [NUMPOPT*BITQPTR-1:0]              t1_doutB;

  output [NUMPUPT-1:0]                     t2_writeA;
  output [NUMPUPT*BITADDR-1:0]             t2_addrA;
  output [NUMPUPT*WIDTH-1:0]               t2_dinA;
  output [NUMPOPT-1:0]                     t2_readB;
  output [NUMPOPT*BITADDR-1:0]             t2_addrB;
  input [NUMPOPT*WIDTH-1:0]                t2_doutB;

  output [NUMPOPT-1:0]                     t3_writeA;
  output [NUMPOPT*BITQPRT-1:0]             t3_addrA;
  output [NUMPOPT*BITPING-1:0]             t3_dinA;
  output [NUMPOPT-1:0]                     t3_readB;
  output [NUMPOPT*BITQPRT-1:0]             t3_addrB;
  input [NUMPOPT*BITPING-1:0]              t3_doutB;

  output [NUMPUPT-1:0]                     t4_writeA;
  output [NUMPUPT*BITQPRT-1:0]             t4_addrA;
  output [NUMPUPT*BITPING-1:0]             t4_dinA;
  output [NUMPUPT-1:0]                     t4_readB;
  output [NUMPUPT*BITQPRT-1:0]             t4_addrB;
  input [NUMPUPT*BITPING-1:0]              t4_doutB;

  output [(NUMPOPT+NUMPUPT)-1:0]           t5_writeA;
  output [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t5_addrA;
  output [(NUMPOPT+NUMPUPT)*BITQCNT-1:0]   t5_dinA;
  output [(NUMPOPT+NUMPUPT)-1:0]           t5_readB;
  output [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t5_addrB;
  input [(NUMPOPT+NUMPUPT)*BITQCNT-1:0]    t5_doutB;

  output [(NUMPOPT+NUMPUPT)-1:0]           t6_writeA;
  output [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t6_addrA;
  output [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t6_dinA;
  output [(NUMPOPT+NUMPUPT)-1:0]           t6_readB;
  output [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t6_addrB;
  input [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t6_doutB;

  output [NUMPUPT-1:0]                     t7_writeA;
  output [NUMPUPT*BITQPRT-1:0]             t7_addrA;
  output [NUMPUPT*NUMPING*BITQPTR-1:0]     t7_dinA;
  output [NUMPUPT-1:0]                     t7_readB;
  output [NUMPUPT*BITQPRT-1:0]             t7_addrB;
  input [NUMPUPT*NUMPING*BITQPTR-1:0]      t7_doutB;

  core_mrnw_pque_f32 #(.WIDTH (WIDTH), .NUMPUPT (NUMPUPT), .NUMPOPT (NUMPOPT),
                       .NUMQPRT (NUMQPRT), .BITQPRT (BITQPRT), .NUMPING (NUMPING), .BITPING (BITPING),
                       .NUMADDR (NUMADDR), .BITADDR (BITADDR), .BITPADR (BITPADR),
                       .QPTR_DELAY (QPTR_DELAY), .LINK_DELAY (LINK_DELAY), .DATA_DELAY (DATA_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    core (.vpush(push), .vpu_prt(pu_prt), .vpu_ptr(pu_ptr), .vpu_din(pu_din), .vpu_cvld(pu_cvld), .vpu_cnt(pu_cnt),
          .vpop(pop), .vpo_ndq(po_ndq), .vpo_prt(po_prt), .vpo_cvld(po_cvld), .vpo_cmt(po_cmt), .vpo_cnt(po_cnt),
          .vpo_pvld(po_pvld), .vpo_ptr(po_ptr), .vpo_dvld(po_dvld), .vpo_dout(po_dout),
          .vcpread (cp_read), .vcpwrite (cp_write), .vcpaddr (cp_adr), .vcpdin (cp_din), .vcpread_vld (cp_vld), .vcpread_dout (cp_dout),
          .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
          .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
          .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB),
          .t4_writeA(t4_writeA), .t4_addrA(t4_addrA), .t4_dinA(t4_dinA), .t4_readB(t4_readB), .t4_addrB(t4_addrB), .t4_doutB(t4_doutB),
          .t5_writeA(t5_writeA), .t5_addrA(t5_addrA), .t5_dinA(t5_dinA), .t5_readB(t5_readB), .t5_addrB(t5_addrB), .t5_doutB(t5_doutB),
          .t6_writeA(t6_writeA), .t6_addrA(t6_addrA), .t6_dinA(t6_dinA), .t6_readB(t6_readB), .t6_addrB(t6_addrB), .t6_doutB(t6_doutB),
          .t7_writeA(t7_writeA), .t7_addrA(t7_addrA), .t7_dinA(t7_dinA), .t7_readB(t7_readB), .t7_addrB(t7_addrB), .t7_doutB(t7_doutB),
          .ready (ready), .clk (clk), .rst (rst));

`ifdef FORMAL

assume_select_qprt_range: assume property (@(posedge clk) disable iff (rst) (select_qprt < NUMQPRT));
assume_select_qprt_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_qprt));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));

ip_top_sva_mrnw_pque_f32 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMQPRT     (NUMQPRT),
     .BITQPRT     (BITQPRT),
     .NUMPING     (NUMPING),
     .BITPING     (BITPING),
     .NUMPUPT     (NUMPUPT),
     .NUMPOPT     (NUMPOPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .BITPADR     (BITPADR),
     .QPTR_DELAY  (QPTR_DELAY),
     .LINK_DELAY  (LINK_DELAY),
     .DATA_DELAY  (DATA_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);


ip_top_sva_2_mrnw_pque_f32 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMQPRT     (NUMQPRT),
     .BITQPRT     (BITQPRT),
     .NUMPUPT     (NUMPUPT),
     .NUMPOPT     (NUMPOPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITQPRT-1:0] help_qprt = sva_int;
  wire [BITADDR-1:0] help_addr = sva_int;
ip_top_sva_mrnw_pque_f32 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMQPRT     (NUMQPRT),
     .BITQPRT     (BITQPRT),
     .NUMPING     (NUMPING),
     .BITPING     (BITPING),
     .NUMPUPT     (NUMPUPT),
     .NUMPOPT     (NUMPOPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .BITPADR     (BITPADR),
     .QPTR_DELAY  (QPTR_DELAY),
     .LINK_DELAY  (LINK_DELAY),
     .DATA_DELAY  (DATA_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_qprt(help_qprt), .select_addr(help_addr), .*);
end
endgenerate

ip_top_sva_2_mrnw_pque_f32 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMQPRT     (NUMQPRT),
     .BITQPRT     (BITQPRT),
     .NUMPUPT     (NUMPUPT),
     .NUMPOPT     (NUMPOPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR))
ip_top_sva_2 (.*);

`endif

endmodule
