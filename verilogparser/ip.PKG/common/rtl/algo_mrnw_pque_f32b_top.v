module algo_mrnw_pque_f32b_top (clk, rst, ready,
                                push, pu_prt, pu_ptr, pu_din, pu_cvld, pu_cnt,
                                pop, po_ndq, po_prt, po_cvld, po_cmt, po_cnt, po_pvld, po_ptr, po_dvld, po_dout,
                                peek, pe_ptr, pe_nvld, pe_nxt, pe_dvld, pe_dout,
                                cp_read, cp_write, cp_adr, cp_din, cp_vld, cp_dout,
                                t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
                                t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
                                t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
                                t4_writeA, t4_addrA, t4_dinA, t4_readB, t4_addrB, t4_doutB,
                                t5_writeA, t5_addrA, t5_dinA, t5_readB, t5_addrB, t5_doutB,
                                t6_writeA, t6_addrA, t6_dinA, t6_readB, t6_addrB, t6_doutB,
                                t7_writeA, t7_addrA, t7_dinA, t7_readB, t7_addrB, t7_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMQPRT = 64;
  parameter BITQPRT = 6;
  parameter NUMPING = 2;
  parameter BITPING = 1;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
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

  parameter BITQPTR = BITADDR;
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

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

  input [NUMPEPT-1:0]              peek;
  input [NUMPEPT*BITQPTR-1:0]      pe_ptr;
  output [NUMPEPT-1:0]             pe_nvld;
  output [NUMPEPT*BITQPTR-1:0]     pe_nxt;
  output [NUMPEPT-1:0]             pe_dvld;
  output [NUMPEPT*WIDTH-1:0]       pe_dout;

  input                            cp_read;
  input                            cp_write;
  input [BITCPAD-1:0]              cp_adr;
  input [CPUWDTH-1:0]              cp_din;
  output                           cp_vld;
  output [CPUWDTH-1:0]             cp_dout;

  output                           ready;
  input                            clk, rst;

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

`ifdef FORMAL 

wire [BITQPRT-1:0] select_qprt;
wire [BITADDR-1:0] select_addr;
assume_select_qprt_range: assume property (@(posedge clk) disable iff (rst) (select_qprt < NUMQPRT));
assume_select_qprt_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_qprt));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
/*
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
*/
`else
wire [BITQPRT-1:0] select_qprt = 0;
wire [BITADDR-1:0] select_addr = 0;
/*
wire [BITVROW-1:0] select_vrow = 0;
wire [BITSROW-1:0] select_srow = 0;
wire [BITDROW-1:0] select_drow = 0;
*/
`endif

wire [NUMPOPT*BITPING-1:0]                   t3_doutB_a1;
wire [NUMPUPT*BITPING-1:0]                   t4_doutB_a1;
wire [(NUMPOPT+NUMPUPT)*BITQCNT-1:0]         t5_doutB_a1;
wire [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t6_doutB_a1;
wire [NUMPUPT*NUMPING*BITQPTR-1:0]           t7_doutB_a1;

generate if (1) begin: a1_loop

  algo_mrnw_pque_f32b #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMPUPT (NUMPUPT), .NUMPOPT (NUMPOPT), .NUMPEPT (NUMPEPT),
                        .NUMQPRT (NUMQPRT), .BITQPRT (BITQPRT), .NUMPING (NUMPING), .BITPING (BITPING),
                        .NUMADDR (NUMADDR), .BITADDR (BITADDR), .BITPADR (BITPADR-1),
                        .QPTR_DELAY(QPTR_DELAY), .LINK_DELAY(LINK_DELAY), .DATA_DELAY(DATA_DELAY), .FLOPIN (FLOPIN), .FLOPOUT(FLOPOUT))
    algo (.ready(ready), .clk(clk), .rst (rst),
          .push(push), .pu_prt(pu_prt), .pu_ptr(pu_ptr), .pu_din(pu_din), .pu_cvld(pu_cvld), .pu_cnt(pu_cnt),
          .pop(pop), .po_ndq(po_ndq), .po_prt(po_prt), .po_cvld(po_cvld), .po_cmt(po_cmt), .po_cnt(po_cnt),
          .po_pvld(po_pvld), .po_ptr(po_ptr), .po_dvld(po_dvld), .po_dout(po_dout),
          .peek(peek), .pe_ptr(pe_ptr), .pe_nvld(pe_nvld), .pe_nxt(pe_nxt), .pe_dvld(pe_dvld), .pe_dout(pe_dout),
          .cp_read(cp_read), .cp_write(cp_write), .cp_adr(cp_adr), .cp_din(cp_din), .cp_vld(cp_vld), .cp_dout(cp_dout),
          .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
          .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
          .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB_a1),
          .t4_writeA(t4_writeA), .t4_addrA(t4_addrA), .t4_dinA(t4_dinA), .t4_readB(t4_readB), .t4_addrB(t4_addrB), .t4_doutB(t4_doutB_a1),
          .t5_writeA(t5_writeA), .t5_addrA(t5_addrA), .t5_dinA(t5_dinA), .t5_readB(t5_readB), .t5_addrB(t5_addrB), .t5_doutB(t5_doutB_a1),
          .t6_writeA(t6_writeA), .t6_addrA(t6_addrA), .t6_dinA(t6_dinA), .t6_readB(t6_readB), .t6_addrB(t6_addrB), .t6_doutB(t6_doutB_a1),
          .t7_writeA(t7_writeA), .t7_addrA(t7_addrA), .t7_dinA(t7_dinA), .t7_readB(t7_readB), .t7_addrB(t7_addrB), .t7_doutB(t7_doutB_a1),
          .select_qprt (select_qprt), .select_addr (select_addr));

end
endgenerate

generate if (FLOPMEM) begin: t3_flp_loop
  reg [NUMPOPT*BITPING-1:0] t3_doutB_reg;
  reg [NUMPUPT*BITPING-1:0] t4_doutB_reg;
  reg [(NUMPOPT+NUMPUPT)*BITQCNT-1:0] t5_doutB_reg;
  reg [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t6_doutB_reg;
  reg [NUMPUPT*NUMPING*BITQPTR-1:0] t7_doutB_reg;
  always @(posedge clk) begin
    t3_doutB_reg <= t3_doutB;
    t4_doutB_reg <= t4_doutB;
    t5_doutB_reg <= t5_doutB;
    t6_doutB_reg <= t6_doutB;
    t7_doutB_reg <= t7_doutB;
  end

  assign t3_doutB_a1 = t3_doutB_reg;
  assign t4_doutB_a1 = t4_doutB_reg;
  assign t5_doutB_a1 = t5_doutB_reg;
  assign t6_doutB_a1 = t6_doutB_reg;
  assign t7_doutB_a1 = t7_doutB_reg;
end else begin: t3_noflp_loop
  assign t3_doutB_a1 = t3_doutB;
  assign t4_doutB_a1 = t4_doutB;
  assign t5_doutB_a1 = t5_doutB;
  assign t6_doutB_a1 = t6_doutB;
  assign t7_doutB_a1 = t7_doutB;
end
endgenerate

endmodule
