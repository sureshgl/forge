module ip_top_sva_2_mrnw_pque_doppler
  #(
parameter     WIDTH = 32,
parameter     BITWDTH = 5,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMQPRT = 64,
parameter     BITQPRT = 6,
parameter     NUMPUPT = 2,
parameter     NUMPOPT = 2,
parameter     BITQPTR = BITADDR,
parameter     BITMDAT = 5

   )
(
  input clk,
  input rst,
  input ready,
  input [NUMPUPT-1:0] push,
  input [NUMPUPT-1:0] pu_owr,
  input [NUMPUPT*BITQPRT-1:0] pu_prt,
  input [NUMPUPT*BITQPTR-1:0] pu_ptr,
  input [NUMPUPT*BITMDAT-1:0] pu_mdat,
  input [NUMPUPT*WIDTH-1:0] pu_din,
  input [NUMPOPT-1:0] pop,
  input [NUMPOPT*BITQPRT-1:0] po_prt,
  input [NUMPUPT-1:0] t1_writeA,
  input [NUMPUPT*BITADDR-1:0] t1_addrA,
  input [NUMPUPT*(BITQPTR+BITMDAT)-1:0] t1_dinA,
  input [NUMPOPT-1:0] t1_readB,
  input [NUMPOPT*BITADDR-1:0] t1_addrB,
  input [NUMPUPT-1:0] t2_writeA,
  input [NUMPUPT*BITADDR-1:0] t2_addrA,
  input [NUMPUPT*WIDTH-1:0] t2_dinA,
  input [NUMPOPT-1:0] t2_readB,
  input [NUMPOPT*BITADDR-1:0] t2_addrB
);

wire push_wire [0:NUMPUPT-1];
wire [BITQPRT-1:0] pu_prt_wire [0:NUMPUPT-1];
genvar pu_var,pcntb_var;
generate
  for (pu_var=0; pu_var<NUMPUPT; pu_var=pu_var+1) begin: pu_loop
    assign  push_wire[pu_var] = push >> pu_var;
    assign pu_prt_wire[pu_var] = pu_prt >> (pu_var*BITQPRT);

    assert_pu_range_check: assert property (@(posedge clk) disable iff (!ready) push_wire[pu_var] |-> (pu_prt_wire[pu_var] < NUMQPRT));
    for (pcntb_var=0;pcntb_var<pu_var;pcntb_var=pcntb_var+1) begin: puni_loop
      assert_pu_uniq_check: assert property (@(posedge clk) disable iff (rst || !ready) (push_wire[pu_var] && push_wire[pcntb_var]) |-> (pu_prt_wire[pu_var] != pu_prt_wire[pcntb_var]));
    end
  end
endgenerate

genvar po_var,pou_var;
generate
  for (po_var=0; po_var<NUMPOPT; po_var=po_var+1) begin: po_loop
    wire pop_wire = pop >> po_var;
    wire [BITQPRT-1:0] po_prt_wire = po_prt >> (po_var*BITQPRT);

    assert_po_range_check: assert property (@(posedge clk) disable iff (!ready) pop_wire |-> (po_prt_wire < NUMQPRT));
  end
endgenerate

genvar t1w_var;
generate
  for (t1w_var=0; t1w_var<NUMPUPT; t1w_var=t1w_var+1) begin: t1w_loop
    wire t1_writeA_wire = t1_writeA >> t1w_var;
    wire [BITADDR-1:0] t1_addrA_wire = t1_addrA >> (t1w_var*BITADDR);

    assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst || !ready) t1_writeA_wire |-> (t1_addrA_wire < NUMADDR));
  end
endgenerate

genvar t1r_var;
generate
  for (t1r_var=0; t1r_var<NUMPOPT; t1r_var=t1r_var+1) begin: t1r_loop
    wire t1_readB_wire = t1_readB >> t1r_var;
    wire [BITADDR-1:0] t1_addrB_wire = t1_addrB >> (t1r_var*BITADDR);

    assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (rst || !ready) t1_readB_wire |-> (t1_addrB_wire < NUMADDR));
  end
endgenerate

genvar t2w_var;
generate
  for (t2w_var=0; t2w_var<NUMPUPT; t2w_var=t2w_var+1) begin: t2w_loop
    wire t2_writeA_wire = t2_writeA >> t2w_var;
    wire [BITADDR-1:0] t2_addrA_wire = t2_addrA >> (t2w_var*BITADDR);

    assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst || !ready) t2_writeA_wire |-> (t2_addrA_wire < NUMADDR));
  end
endgenerate

genvar t2r_var;
generate
  for (t2r_var=0; t2r_var<NUMPOPT; t2r_var=t2r_var+1) begin: t2r_loop
    wire t2_readB_wire = t2_readB >> t2r_var;
    wire [BITADDR-1:0] t2_addrB_wire = t2_addrB >> (t2r_var*BITADDR);

    assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst || !ready) t2_readB_wire |-> (t2_addrB_wire < NUMADDR));
  end
endgenerate

endmodule


module ip_top_sva_mrnw_pque_doppler
  #(
parameter     WIDTH = 32,
parameter     BITWDTH = 5,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMQPRT = 64,
parameter     BITQPRT = 6,
parameter     NUMPING = 2,
parameter     BITPING = 1,
parameter     NUMPUPT = 2,
parameter     NUMPOPT = 2,
parameter     BITPADR = 14,
parameter     NUMSBFL = 2,
parameter     QPTR_DELAY = 2,
parameter     LINK_DELAY = 2,
parameter     DATA_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0,
parameter     FIFOCNT = 8,
parameter     BITQPTR = BITADDR,
parameter     BITQCNT = BITADDR+1,
parameter     BITMDAT = 5,
parameter     NUMMDAT = 3
   )
(
  input clk,
  input rst,
  input ready,
  input [NUMPUPT-1:0] push,
  input [NUMPUPT-1:0] pu_owr,
  input [NUMPUPT*BITQPRT-1:0] pu_prt,
  input [NUMPUPT*BITQPTR-1:0] pu_ptr,
  input [NUMPUPT*BITMDAT-1:0] pu_mdat,
  input [NUMPUPT*WIDTH-1:0] pu_din,
  input [NUMPUPT-1:0] pu_cvld,
  input [NUMPUPT*BITQCNT-1:0] pu_cnt,
  input [NUMPOPT-1:0] pop,
  input [NUMPOPT-1:0] po_ndq,
  input [NUMPOPT*BITQPRT-1:0] po_prt,
  input [NUMPOPT-1:0] po_cvld,
  input [NUMPOPT-1:0] po_cmt,
  input [NUMPOPT*BITQCNT-1:0] po_cnt,
  input [NUMPOPT-1:0] po_pvld,
  input [NUMPOPT*BITQPTR-1:0] po_ptr,
  input [NUMPOPT*NUMMDAT*BITMDAT-1:0] po_mdat,
  input [NUMPOPT-1:0] po_dvld,
  input [NUMPOPT*WIDTH-1:0] po_dout,
  input [NUMPUPT-1:0] t1_writeA,
  input [NUMPUPT*BITADDR-1:0] t1_addrA,
  input [NUMPUPT*(BITQPTR+BITMDAT)-1:0] t1_dinA,
  input [NUMPOPT-1:0] t1_readB,
  input [NUMPOPT*BITADDR-1:0] t1_addrB,
  input [NUMPOPT*(BITQPTR+BITMDAT)-1:0] t1_doutB,
  input [NUMPUPT-1:0] t2_writeA,
  input [NUMPUPT*BITADDR-1:0] t2_addrA,
  input [NUMPUPT*WIDTH-1:0] t2_dinA,
  input [NUMPOPT-1:0] t2_readB,
  input [NUMPOPT*BITADDR-1:0] t2_addrB,
  input [NUMPOPT*WIDTH-1:0] t2_doutB,
  input [NUMPOPT-1:0] t3_writeA,
  input [NUMPOPT*BITQPRT-1:0] t3_addrA,
  input [NUMPOPT*BITPING-1:0] t3_dinA,
  input [NUMPOPT-1:0] t3_readB,
  input [NUMPOPT*BITQPRT-1:0] t3_addrB,
  input [NUMPOPT*BITPING-1:0] t3_doutB,
  input [NUMPUPT-1:0] t4_writeA,
  input [NUMPUPT*BITQPRT-1:0] t4_addrA,
  input [NUMPUPT*BITPING-1:0] t4_dinA,
  input [NUMPUPT-1:0] t4_readB,
  input [NUMPUPT*BITQPRT-1:0] t4_addrB,
  input [NUMPUPT*BITPING-1:0] t4_doutB,
  input [(NUMPOPT+NUMPUPT)-1:0] t5_writeA,
  input [(NUMPOPT+NUMPUPT)*BITQPRT-1:0] t5_addrA,
  input [(NUMPOPT+NUMPUPT)*BITQCNT-1:0] t5_dinA,
  input [(NUMPOPT+NUMPUPT)-1:0] t5_readB,
  input [(NUMPOPT+NUMPUPT)*BITQPRT-1:0] t5_addrB,
  input [(NUMPOPT+NUMPUPT)*BITQCNT-1:0] t5_doutB,
  input [(NUMPOPT+NUMPUPT)-1:0] t6_writeA,
  input [(NUMPOPT+NUMPUPT)*BITQPRT-1:0] t6_addrA,
  input [(NUMPOPT+NUMPUPT)*NUMPING*(BITQPTR+BITMDAT)-1:0] t6_dinA,
  input [(NUMPOPT+NUMPUPT)-1:0] t6_readB,
  input [(NUMPOPT+NUMPUPT)*BITQPRT-1:0] t6_addrB,
  input [(NUMPOPT+NUMPUPT)*NUMPING*(BITQPTR+BITMDAT)-1:0] t6_doutB,
  input [NUMPUPT-1:0] t7_writeA,
  input [NUMPUPT*BITQPRT-1:0] t7_addrA,
  input [NUMPUPT*NUMPING*BITQPTR-1:0] t7_dinA,
  input [NUMPUPT-1:0] t7_readB,
  input [NUMPUPT*BITQPRT-1:0] t7_addrB,
  input [NUMPUPT*NUMPING*BITQPTR-1:0] t7_doutB,
  input [BITQPRT-1:0] select_qprt,
  input [BITADDR-1:0] select_addr
);

wire push_wire [0:NUMPUPT-1];
wire pu_owr_wire [0:NUMPUPT-1];
wire [BITQPRT-1:0] pu_prt_wire [0:NUMPUPT-1];
wire [BITQPTR-1:0] pu_ptr_wire [0:NUMPUPT-1];
wire [BITMDAT-1:0] pu_mdat_wire [0:NUMPUPT-1];
wire [WIDTH-1:0] pu_din_wire [0:NUMPUPT-1];
wire pu_cvld_wire [0:NUMPUPT-1];
wire [BITQCNT-1:0] pu_cnt_wire [0:NUMPUPT-1];
wire pop_wire [0:NUMPOPT-1];
wire po_ndq_wire [0:NUMPOPT-1];
wire [BITQPRT-1:0] po_prt_wire [0:NUMPOPT-1];
wire po_pvld_wire [0:NUMPOPT-1];
wire [BITQPTR-1:0] po_ptr_wire [0:NUMPOPT-1];
wire [NUMMDAT*BITMDAT-1:0] po_mdat_wire [0:NUMPOPT-1];
wire po_cvld_wire [0:NUMPOPT-1];
wire po_cmt_wire [0:NUMPOPT-1];
wire [BITQCNT-1:0] po_cnt_wire [0:NUMPOPT-1];
wire po_dvld_wire [0:NUMPOPT-1];
wire [WIDTH-1:0] po_dout_wire [0:NUMPOPT-1];
genvar prt_var;
generate if (1) begin: prt_loop
  for (prt_var=0; prt_var<NUMPUPT; prt_var=prt_var+1) begin: pu_loop
    assign push_wire[prt_var] = push >> prt_var;
    assign pu_owr_wire[prt_var] = pu_owr >> prt_var;
    assign pu_prt_wire[prt_var] = pu_prt >> (prt_var*BITQPRT);
    assign pu_ptr_wire[prt_var] = pu_ptr >> (prt_var*BITQPTR);
    assign pu_mdat_wire[prt_var] = pu_mdat >> (prt_var*BITMDAT);
    assign pu_din_wire[prt_var] = pu_din >> (prt_var*WIDTH);
    assign pu_cvld_wire[prt_var] = pu_cvld >> prt_var;
    assign pu_cnt_wire[prt_var] = pu_cnt >> (prt_var*BITQCNT);
  end
  for (prt_var=0; prt_var<NUMPOPT; prt_var=prt_var+1) begin: po_loop
    assign pop_wire[prt_var] = pop >> prt_var;
    assign po_ndq_wire[prt_var] = po_ndq >> prt_var;
    assign po_prt_wire[prt_var] = po_prt >> (prt_var*BITQPRT);
    assign po_cvld_wire[prt_var] = po_cvld >> prt_var;
    assign po_cmt_wire[prt_var] = po_cmt >> prt_var;
    assign po_cnt_wire[prt_var] = po_cnt >> (prt_var*BITQCNT);
    assign po_pvld_wire[prt_var] = po_pvld >> prt_var;
    assign po_ptr_wire[prt_var] = po_ptr >> (prt_var*BITQPTR);
    assign po_mdat_wire[prt_var] = po_mdat >> (prt_var*NUMMDAT*BITMDAT);
    assign po_dvld_wire[prt_var] = po_dvld >> prt_var;
    assign po_dout_wire[prt_var] = po_dout >> (prt_var*WIDTH);
  end
end
endgenerate

reg [BITQCNT-1:0] fakecnt_nxt;
reg [BITQCNT-1:0] fakecnt;
reg pop_reg [0:NUMPOPT-1][0:QPTR_DELAY-1];
reg po_ndq_reg [0:NUMPOPT-1][0:QPTR_DELAY-1];
reg [BITQPRT-1:0] po_prt_reg [0:NUMPOPT-1][0:QPTR_DELAY-1];
reg push_reg [0:NUMPUPT-1][0:QPTR_DELAY-1];
reg pu_owr_reg [0:NUMPUPT-1][0:QPTR_DELAY-1];
reg [BITQPTR+BITMDAT-1:0] pu_ptr_reg [0:NUMPUPT-1][0:QPTR_DELAY-1];
integer prto_int, prtd_int;
always @(posedge clk)
  for (prtd_int=0; prtd_int<QPTR_DELAY; prtd_int=prtd_int+1)
    if (prtd_int>0) begin
      for (prto_int=0; prto_int<NUMPOPT; prto_int=prto_int+1) begin
        pop_reg[prto_int][prtd_int] <= pop_reg[prto_int][prtd_int-1] && ready;
        po_ndq_reg[prto_int][prtd_int] <= po_ndq_reg[prto_int][prtd_int-1];
        po_prt_reg[prto_int][prtd_int] <= po_prt_reg[prto_int][prtd_int-1];
      end
      for (prto_int=0; prto_int<NUMPUPT; prto_int=prto_int+1) begin
        push_reg[prto_int][prtd_int] <= push_reg[prto_int][prtd_int-1] && ready;
        pu_owr_reg[prto_int][prtd_int] <= pu_owr_reg[prto_int][prtd_int-1] && ready;
        pu_ptr_reg[prto_int][prtd_int] <= pu_ptr_reg[prto_int][prtd_int-1];
      end
    end else begin
      for (prto_int=0; prto_int<NUMPOPT; prto_int=prto_int+1) begin
        pop_reg[prto_int][prtd_int] <= pop_wire[prto_int] && |fakecnt && ready;
        po_ndq_reg[prto_int][prtd_int] <= po_ndq_wire[prto_int];
        po_prt_reg[prto_int][prtd_int] <= po_prt_wire[prto_int];
      end
      for (prto_int=0; prto_int<NUMPUPT; prto_int=prto_int+1) begin
        push_reg[prto_int][prtd_int] <= push_wire[prto_int] && ready;
        pu_owr_reg[prto_int][prtd_int] <= pu_owr_wire[prto_int] && ready;
        pu_ptr_reg[prto_int][prtd_int] <= {pu_mdat_wire[prto_int],pu_ptr_wire[prto_int]};
      end
    end

wire t1_writeA_wire [0:NUMPUPT-1];
wire [BITADDR-1:0] t1_addrA_wire [0:NUMPUPT-1];
wire [BITQPTR+BITMDAT-1:0] t1_dinA_wire [0:NUMPUPT-1];
wire t1_readB_wire [0:NUMPOPT-1];
wire [BITADDR-1:0] t1_addrB_wire [0:NUMPOPT-1];
wire [BITQPTR+BITMDAT-1:0] t1_doutB_wire [0:NUMPOPT-1];
wire t2_writeA_wire [0:NUMPUPT-1];
wire [BITADDR-1:0] t2_addrA_wire [0:NUMPUPT-1];
wire [WIDTH-1:0] t2_dinA_wire [0:NUMPUPT-1];
wire t2_readB_wire [0:NUMPOPT-1];
wire [BITADDR-1:0] t2_addrB_wire [0:NUMPOPT-1];
wire [WIDTH:0] t2_doutB_wire [0:NUMPOPT-1];
wire t3_writeA_wire [0:NUMPOPT-1];
wire [BITQPRT-1:0] t3_addrA_wire [0:NUMPOPT-1];
wire [BITPING-1:0] t3_dinA_wire [0:NUMPOPT-1];
wire t3_readB_wire [0:NUMPOPT-1];
wire [BITQPRT-1:0] t3_addrB_wire [0:NUMPOPT-1];
wire [BITPING-1:0] t3_doutB_wire [0:NUMPOPT-1];
wire t4_writeA_wire [0:NUMPUPT-1];
wire [BITQPRT-1:0] t4_addrA_wire [0:NUMPUPT-1];
wire [BITPING-1:0] t4_dinA_wire [0:NUMPUPT-1];
wire t4_readB_wire [0:NUMPUPT-1];
wire [BITQPRT-1:0] t4_addrB_wire [0:NUMPUPT-1];
wire [BITPING-1:0] t4_doutB_wire [0:NUMPUPT-1];
wire t5_writeA_wire [0:NUMPOPT+NUMPUPT-1];
wire [BITQPRT-1:0] t5_addrA_wire [0:NUMPOPT+NUMPUPT-1];
wire [BITQCNT-1:0] t5_dinA_wire [0:NUMPOPT+NUMPUPT-1];
wire t5_readB_wire [0:NUMPOPT+NUMPUPT-1];
wire [BITQPRT-1:0] t5_addrB_wire [0:NUMPOPT+NUMPUPT-1];
wire [BITQCNT-1:0] t5_doutB_wire [0:NUMPOPT+NUMPUPT-1];
wire t6_writeA_wire [0:NUMPOPT+NUMPUPT-1];
wire [BITQPRT-1:0] t6_addrA_wire [0:NUMPOPT+NUMPUPT-1];
wire [NUMPING*(BITQPTR+BITMDAT)-1:0] t6_dinA_wire [0:NUMPOPT+NUMPUPT-1];
wire t6_readB_wire [0:NUMPOPT+NUMPUPT-1];
wire [BITQPRT-1:0] t6_addrB_wire [0:NUMPOPT+NUMPUPT-1];
wire [NUMPING*(BITQPTR+BITMDAT)-1:0] t6_doutB_wire [0:NUMPOPT+NUMPUPT-1];
wire t7_writeA_wire [0:NUMPUPT-1];
wire [BITQPRT-1:0] t7_addrA_wire [0:NUMPUPT-1];
wire [NUMPING*BITQPTR-1:0] t7_dinA_wire [0:NUMPUPT-1];
wire t7_readB_wire [0:NUMPUPT-1];
wire [BITQPRT-1:0] t7_addrB_wire [0:NUMPUPT-1];
wire [NUMPING*BITQPTR-1:0] t7_doutB_wire [0:NUMPUPT-1];

genvar txr_var;
generate begin: tx_loop
  for (txr_var=0; txr_var<NUMPUPT; txr_var=txr_var+1) begin: t1w_loop
    assign t1_writeA_wire[txr_var] = t1_writeA >> txr_var;
    assign t1_addrA_wire[txr_var] = t1_addrA >> (txr_var*BITADDR);
    assign t1_dinA_wire[txr_var] = t1_dinA >> (txr_var*(BITQPTR+BITMDAT));
  end
  for (txr_var=0; txr_var<NUMPOPT; txr_var=txr_var+1) begin: t1r_loop
    assign t1_readB_wire[txr_var] = t1_readB >> txr_var;
    assign t1_addrB_wire[txr_var] = t1_addrB >> (txr_var*BITADDR);
    assign t1_doutB_wire[txr_var] = t1_doutB >> (txr_var*(BITQPTR+BITMDAT));
  end
  for (txr_var=0; txr_var<NUMPUPT; txr_var=txr_var+1) begin: t2w_loop
    assign t2_writeA_wire[txr_var] = t2_writeA >> txr_var;
    assign t2_addrA_wire[txr_var] = t2_addrA >> (txr_var*BITADDR);
    assign t2_dinA_wire[txr_var] = t2_dinA >> (txr_var*WIDTH);
  end
  for (txr_var=0; txr_var<NUMPOPT; txr_var=txr_var+1) begin: t2r_loop
    assign t2_readB_wire[txr_var] = t2_readB >> txr_var;
    assign t2_addrB_wire[txr_var] = t2_addrB >> (txr_var*BITADDR);
    assign t2_doutB_wire[txr_var] = t2_doutB >> (txr_var*WIDTH);
  end
  for (txr_var=0; txr_var<NUMPOPT; txr_var=txr_var+1) begin: t3w_loop
    assign t3_writeA_wire[txr_var] = t3_writeA >> txr_var;
    assign t3_addrA_wire[txr_var] = t3_addrA >> (txr_var*BITQPRT);
    assign t3_dinA_wire[txr_var] = t3_dinA >> (txr_var*BITPING);
  end
  for (txr_var=0; txr_var<NUMPOPT; txr_var=txr_var+1) begin: t3r_loop
    assign t3_readB_wire[txr_var] = t3_readB >> txr_var;
    assign t3_addrB_wire[txr_var] = t3_addrB >> (txr_var*BITQPRT);
    assign t3_doutB_wire[txr_var] = t3_doutB >> (txr_var*BITPING);
  end
  for (txr_var=0; txr_var<NUMPUPT; txr_var=txr_var+1) begin: t4w_loop
    assign t4_writeA_wire[txr_var] = t4_writeA >> txr_var;
    assign t4_addrA_wire[txr_var] = t4_addrA >> (txr_var*BITQPRT);
    assign t4_dinA_wire[txr_var] = t4_dinA >> (txr_var*BITPING);
  end
  for (txr_var=0; txr_var<NUMPUPT; txr_var=txr_var+1) begin: t4r_loop
    assign t4_readB_wire[txr_var] = t4_readB >> txr_var;
    assign t4_addrB_wire[txr_var] = t4_addrB >> (txr_var*BITQPRT);
    assign t4_doutB_wire[txr_var] = t4_doutB >> (txr_var*BITPING);
  end
  for (txr_var=0; txr_var<NUMPOPT+NUMPUPT; txr_var=txr_var+1) begin: t5w_loop
    assign t5_writeA_wire[txr_var] = t5_writeA >> txr_var;
    assign t5_addrA_wire[txr_var] = t5_addrA >> (txr_var*BITQPRT);
    assign t5_dinA_wire[txr_var] = t5_dinA >> (txr_var*BITQCNT);
  end
  for (txr_var=0; txr_var<NUMPOPT+NUMPUPT; txr_var=txr_var+1) begin: t5r_loop
    assign t5_readB_wire[txr_var] = t5_readB >> txr_var;
    assign t5_addrB_wire[txr_var] = t5_addrB >> (txr_var*BITQPRT);
    assign t5_doutB_wire[txr_var] = t5_doutB >> (txr_var*BITQCNT);
  end
  for (txr_var=0; txr_var<NUMPOPT+NUMPUPT; txr_var=txr_var+1) begin: t6w_loop
    assign t6_writeA_wire[txr_var] = t6_writeA >> txr_var;
    assign t6_addrA_wire[txr_var] = t6_addrA >> (txr_var*BITQPRT);
    assign t6_dinA_wire[txr_var] = t6_dinA >> (txr_var*NUMPING*(BITMDAT+BITQPTR));
  end
  for (txr_var=0; txr_var<NUMPOPT+NUMPUPT; txr_var=txr_var+1) begin: t6r_loop
    assign t6_readB_wire[txr_var] = t6_readB >> txr_var;
    assign t6_addrB_wire[txr_var] = t6_addrB >> (txr_var*BITQPRT);
    assign t6_doutB_wire[txr_var] = t6_doutB >> (txr_var*NUMPING*(BITQPTR+BITMDAT));
  end
  for (txr_var=0; txr_var<NUMPUPT; txr_var=txr_var+1) begin: t7w_loop
    assign t7_writeA_wire[txr_var] = t7_writeA >> txr_var;
    assign t7_addrA_wire[txr_var] = t7_addrA >> (txr_var*BITQPRT);
    assign t7_dinA_wire[txr_var] = t7_dinA >> (txr_var*NUMPING*BITQPTR);
  end
  for (txr_var=0; txr_var<NUMPUPT; txr_var=txr_var+1) begin: t7r_loop
    assign t7_readB_wire[txr_var] = t7_readB >> txr_var;
    assign t7_addrB_wire[txr_var] = t7_addrB >> (txr_var*BITQPRT);
    assign t7_doutB_wire[txr_var] = t7_doutB >> (txr_var*NUMPING*BITQPTR);
  end
end
endgenerate

reg [BITPING-1:0] omem;
integer omem_int;
always @(posedge clk)
  if (!ready)
    omem <= 0;
  else for (omem_int=0; omem_int<NUMPOPT; omem_int=omem_int+1)
    if (t3_writeA_wire[omem_int] && (t3_addrA_wire[omem_int] == select_qprt))
      omem <= t3_dinA_wire[omem_int];

reg [BITPING-1:0] umem;
integer umem_int;
always @(posedge clk)
  if (!ready)
    umem <= 0;
  else for (umem_int=0; umem_int<NUMPUPT; umem_int=umem_int+1)
    if (t4_writeA_wire[umem_int] && (t4_addrA_wire[umem_int] == select_qprt))
      umem <= t4_dinA_wire[umem_int];

reg [BITQCNT-1:0] cmem;
integer cmem_int;
always @(posedge clk)
  if (!ready)
    cmem <= 0;
  else for (cmem_int=0; cmem_int<NUMPOPT+NUMPUPT; cmem_int=cmem_int+1)
    if (t5_writeA_wire[cmem_int] && (t5_addrA_wire[cmem_int] == select_qprt))
      cmem <= t5_dinA_wire[cmem_int];

reg [NUMPING*(BITQPTR+BITMDAT)-1:0] hmem;
integer hmem_int;
always @(posedge clk)
  if (!ready)
    hmem <= 0;
  else for (hmem_int=0; hmem_int<NUMPOPT+NUMPUPT; hmem_int=hmem_int+1)
    if (t6_writeA_wire[hmem_int] && (t6_addrA_wire[hmem_int] == select_qprt))
      hmem <= t6_dinA_wire[hmem_int];

reg [NUMPING*BITQPTR-1:0] tmem;
integer tmem_int;
always @(posedge clk)
  if (!ready)
    tmem <= 0;
  else for (tmem_int=0; tmem_int<NUMPUPT; tmem_int=tmem_int+1)
    if (t7_writeA_wire[tmem_int] && (t7_addrA_wire[tmem_int] == select_qprt))
      tmem <= t7_dinA_wire[tmem_int];

genvar memr_var;
generate begin: mem_loop
  for (memr_var=0; memr_var<NUMPOPT; memr_var=memr_var+1) begin: odo_loop
    assert_odout_check: assert property (@(posedge clk) disable iff (rst || !ready) (t3_readB_wire[memr_var] && (t3_addrB_wire[memr_var] == select_qprt)) |-> ##QPTR_DELAY
                                         (t3_doutB_wire[memr_var] == $past(omem,QPTR_DELAY)));
  end
  for (memr_var=0; memr_var<NUMPUPT; memr_var=memr_var+1) begin: udo_loop
    assert_udout_check: assert property (@(posedge clk) disable iff (rst || !ready) (t4_readB_wire[memr_var] && (t4_addrB_wire[memr_var] == select_qprt)) |-> ##QPTR_DELAY
                                         (t4_doutB_wire[memr_var] == $past(umem,QPTR_DELAY)));
  end
  for (memr_var=0; memr_var<NUMPOPT+NUMPUPT; memr_var=memr_var+1) begin: cdo_loop
    assert_cdout_check: assert property (@(posedge clk) disable iff (rst || !ready) (t5_readB_wire[memr_var] && (t5_addrB_wire[memr_var] == select_qprt)) |-> ##QPTR_DELAY
                                         (t5_doutB_wire[memr_var] == $past(cmem,QPTR_DELAY)));
  end
  for (memr_var=0; memr_var<NUMPOPT+NUMPUPT; memr_var=memr_var+1) begin: hdo_loop
    assert_hdout_check: assert property (@(posedge clk) disable iff (rst || !ready) (t6_readB_wire[memr_var] && (t6_addrB_wire[memr_var] == select_qprt)) |-> ##QPTR_DELAY
                                         (t6_doutB_wire[memr_var] == $past(hmem,QPTR_DELAY)));
  end
  for (memr_var=0; memr_var<NUMPUPT; memr_var=memr_var+1) begin: tdo_loop
    assert_tdout_check: assert property (@(posedge clk) disable iff (rst || !ready) (t7_readB_wire[memr_var] && (t7_addrB_wire[memr_var] == select_qprt)) |-> ##QPTR_DELAY
                                         (t7_doutB_wire[memr_var] == $past(tmem,QPTR_DELAY)));
  end
end
endgenerate

genvar fwdr_var;
generate begin: fwd_loop
  for (fwdr_var=0; fwdr_var<NUMPOPT; fwdr_var=fwdr_var+1) begin: odf_loop
    assert_optr_fwd_check: assert property (@(posedge clk) disable iff (rst || !ready) (t3_readB_wire[fwdr_var] && (t3_addrB_wire[fwdr_var] == select_qprt)) |-> ##QPTR_DELAY
                                            (core.optr_out[fwdr_var] == omem));
  end
  for (fwdr_var=0; fwdr_var<NUMPUPT; fwdr_var=fwdr_var+1) begin: udf_loop
    assert_uptr_fwd_check: assert property (@(posedge clk) disable iff (rst || !ready) (t4_readB_wire[fwdr_var] && (t4_addrB_wire[fwdr_var] == select_qprt)) |-> ##QPTR_DELAY
                                            (core.uptr_out[fwdr_var] == umem));
  end
  for (fwdr_var=0; fwdr_var<NUMPOPT+NUMPUPT; fwdr_var=fwdr_var+1) begin: cdf_loop
    assert_cnt_fwd_check: assert property (@(posedge clk) disable iff (rst || !ready) (t5_readB_wire[fwdr_var] && (t5_addrB_wire[fwdr_var] == select_qprt)) |-> ##QPTR_DELAY
                                           (core.cnt_out[fwdr_var] == cmem));
  end
  for (fwdr_var=0; fwdr_var<NUMPOPT+NUMPUPT; fwdr_var=fwdr_var+1) begin: hdf_loop
    assert_head_fwd_check: assert property (@(posedge clk) disable iff (rst || !ready) (t6_readB_wire[fwdr_var] && (t6_addrB_wire[fwdr_var] == select_qprt)) |-> ##QPTR_DELAY
                                            (core.head_out[fwdr_var] == hmem));
  end
  for (fwdr_var=0; fwdr_var<NUMPUPT; fwdr_var=fwdr_var+1) begin: tdf_loop
    assert_tail_fwd_check: assert property (@(posedge clk) disable iff (rst || !ready) (t7_readB_wire[fwdr_var] && (t7_addrB_wire[fwdr_var] == select_qprt)) |-> ##QPTR_DELAY
                                            (core.tail_out[fwdr_var] == tmem));
  end
  for (fwdr_var=0; fwdr_var<NUMPOPT; fwdr_var=fwdr_var+1) begin: hqf_loop
    assert_hdeq_fwd_check: assert property (@(posedge clk) disable iff (rst || !ready) (t6_readB_wire[fwdr_var] && (t6_addrB_wire[fwdr_var] == select_qprt)) |-> ##(QPTR_DELAY+LINK_DELAY)
                                            (core.hdeq_out[fwdr_var] == hmem));
  end
end
endgenerate

integer fcnt_int;
always_comb begin
  fakecnt_nxt = fakecnt;
  for (fcnt_int=0; fcnt_int<NUMPOPT; fcnt_int=fcnt_int+1) 
    if (pop_wire[fcnt_int] && !po_ndq_wire[fcnt_int] && (po_prt_wire[fcnt_int] == select_qprt) && |fakecnt_nxt)
      fakecnt_nxt = fakecnt_nxt - 1;
  for (fcnt_int=0; fcnt_int<NUMPUPT; fcnt_int=fcnt_int+1) 
    if (push_wire[fcnt_int] && !pu_owr_wire[fcnt_int] && (pu_prt_wire[fcnt_int] == select_qprt))
      fakecnt_nxt = fakecnt_nxt + 1;
end

always @(posedge clk)
  if (!ready)
    fakecnt <= 0;
  else
    fakecnt <= fakecnt_nxt;

reg [BITQCNT-1:0] fifocnt_nxt;
reg [BITQCNT-1:0] fifocnt;
integer ffct_int;
always_comb begin
  fifocnt_nxt = fifocnt;
  for (ffct_int=0; ffct_int<NUMPUPT; ffct_int=ffct_int+1) 
    if (push_wire[ffct_int] && !pu_owr_wire[ffct_int] && (pu_prt_wire[ffct_int] == select_qprt))
      fifocnt_nxt = fifocnt_nxt + 1;
  for (ffct_int=0; ffct_int<NUMPOPT; ffct_int=ffct_int+1) 
    if (pop_reg[ffct_int][QPTR_DELAY-1] && !po_ndq_reg[ffct_int][QPTR_DELAY-1] && (po_prt_reg[ffct_int][QPTR_DELAY-1] == select_qprt))
      fifocnt_nxt = fifocnt_nxt - 1;
end

always @(posedge clk)
  if (!ready)
    fifocnt <= 0;
  else
    fifocnt <= fifocnt_nxt;

reg [3:0] popcnt;
integer popc_int;
always_comb begin
  popcnt = 0;
  for (popc_int=0; popc_int<NUMPOPT; popc_int=popc_int+1)
    if (pop_reg[popc_int][QPTR_DELAY-1] && !po_ndq_reg[popc_int][QPTR_DELAY-1] && (po_prt_reg[popc_int][QPTR_DELAY-1] == select_qprt))
      popcnt = popcnt + 1;
end

reg [3:0] push_sel [0:NUMPUPT-1];
integer fifn_int;
always_comb
  for (fifn_int=0; fifn_int<NUMPUPT; fifn_int=fifn_int+1) begin
    if (fifn_int>0)
      push_sel[fifn_int] = push_sel[fifn_int-1];
    else
      push_sel[fifn_int] = fifocnt-popcnt-1;
    if (push_wire[fifn_int] && !pu_owr_wire[fifn_int] && (pu_prt_wire[fifn_int] == select_qprt)) 
      push_sel[fifn_int] = push_sel[fifn_int] + 1;
  end
    
reg [(BITMDAT+BITQPTR)-1:0] ptrfifo [0:FIFOCNT-1];
reg [WIDTH-1:0] datfifo [0:FIFOCNT-1];
reg vlpfifo [0:FIFOCNT-1];
reg vldfifo [0:FIFOCNT-1];
reg [(BITMDAT+BITQPTR)-1:0] ptrfifo_nxt [0:FIFOCNT-1];
reg [WIDTH-1:0] datfifo_nxt [0:FIFOCNT-1];
reg vlpfifo_nxt[0:FIFOCNT-1];
reg vldfifo_nxt[0:FIFOCNT-1];
integer fifo_int, fifp_int;
always_comb
  for (fifo_int=0; fifo_int<FIFOCNT; fifo_int=fifo_int+1) begin
    vlpfifo_nxt[fifo_int] = vlpfifo[fifo_int];
    ptrfifo_nxt[fifo_int] = ptrfifo[fifo_int];
    vldfifo_nxt[fifo_int] = vldfifo[fifo_int];
    datfifo_nxt[fifo_int] = datfifo[fifo_int];
    if (fifo_int<(fifocnt-popcnt)) begin
      vlpfifo_nxt[fifo_int] = vlpfifo[fifo_int+popcnt];
      ptrfifo_nxt[fifo_int] = ptrfifo[fifo_int+popcnt];
      vldfifo_nxt[fifo_int] = vldfifo[fifo_int+popcnt];
      datfifo_nxt[fifo_int] = datfifo[fifo_int+popcnt];
    end
    for (fifp_int=0; fifp_int<NUMPUPT; fifp_int=fifp_int+1)
      if (t1_writeA_wire[fifp_int] && (t1_addrA_wire[fifp_int]==ptrfifo_nxt[fifo_int][BITADDR-1:0]))
        vlpfifo_nxt[fifo_int] = 1'b1;
    for (fifp_int=0; fifp_int<NUMPUPT; fifp_int=fifp_int+1)
      if (t2_writeA_wire[fifp_int] && (t2_addrA_wire[fifp_int]==ptrfifo_nxt[fifo_int][BITADDR-1:0]))
        vldfifo_nxt[fifo_int] = 1'b1;
    if (fifo_int>=(fifocnt-popcnt))
      for (fifp_int=0; fifp_int<NUMPUPT; fifp_int=fifp_int+1)
        if (push_wire[fifp_int] && !pu_owr_wire[fifp_int] && (pu_prt_wire[fifp_int] == select_qprt) && (fifo_int==push_sel[fifp_int])) begin
          vlpfifo_nxt[fifo_int] = 1'b0;
          ptrfifo_nxt[fifo_int] = {pu_mdat_wire[fifp_int],pu_ptr_wire[fifp_int]};
          vldfifo_nxt[fifo_int] = 1'b0;
          datfifo_nxt[fifo_int] = pu_din_wire[fifp_int];
        end
    if (fifo_int==(fifocnt-popcnt-1))
      for (fifp_int=0; fifp_int<NUMPUPT; fifp_int=fifp_int+1)
        if (push_wire[fifp_int] && pu_owr_wire[fifp_int] && (pu_prt_wire[fifp_int] == select_qprt) && (fifo_int==push_sel[fifp_int]))
          datfifo_nxt[fifo_int] = pu_din_wire[fifp_int];
  end

integer fiff_int;
always @(posedge clk)
  for (fiff_int=0; fiff_int<FIFOCNT; fiff_int=fiff_int+1) begin
    vlpfifo[fiff_int] <= vlpfifo_nxt[fiff_int];
    ptrfifo[fiff_int] <= ptrfifo_nxt[fiff_int];
    vldfifo[fiff_int] <= vldfifo_nxt[fiff_int];
    datfifo[fiff_int] <= datfifo_nxt[fiff_int];
  end

reg mthr_ptrfifo [0:NUMPOPT-1];
reg mthr_vlplink [0:NUMPOPT-1];
reg [BITQPTR+BITMDAT-1:0] mthr_ptrlink [0:NUMPOPT-1];
reg mthr_datfifo [0:NUMPOPT-1];
reg mthr_vldlink [0:NUMPOPT-1];
reg [WIDTH-1:0] mthr_datlink [0:NUMPOPT-1];
reg mthw_ptrfifo [0:NUMPUPT-1];
reg mthw_vlplink [0:NUMPUPT-1];
reg [BITQPTR+BITMDAT-1:0] mthw_ptrlink [0:NUMPUPT-1];
reg mthw_datfifo [0:NUMPUPT-1];
reg mthw_vldlink [0:NUMPUPT-1];
reg [WIDTH-1:0] mthw_datlink [0:NUMPUPT-1];
integer mthp_int, mthb_int;
always_comb begin
  for (mthp_int=0; mthp_int<NUMPOPT; mthp_int=mthp_int+1) begin
    mthr_ptrfifo[mthp_int] = 1'b0;
    mthr_vlplink[mthp_int] = 1'b0;
    mthr_ptrlink[mthp_int] = 0;
    mthr_datfifo[mthp_int] = 1'b0;
    mthr_vldlink[mthp_int] = 1'b0;
    mthr_datlink[mthp_int] = 0;
    for (mthb_int=0; mthb_int<FIFOCNT; mthb_int=mthb_int+1) begin
      if ((mthb_int<fifocnt) && (ptrfifo[mthb_int][BITADDR-1:0] == t1_addrB_wire[mthp_int])) begin
        mthr_ptrfifo[mthp_int] = 1'b1;
        mthr_vlplink[mthp_int] = vlpfifo[mthb_int];
        mthr_ptrlink[mthp_int] = ptrfifo[mthb_int+NUMPING];
      end
      if ((mthb_int<fifocnt) && (ptrfifo[mthb_int][BITADDR-1:0] == t2_addrB_wire[mthp_int])) begin
        mthr_datfifo[mthp_int] = 1'b1;
        mthr_vldlink[mthp_int] = vldfifo[mthb_int];
        mthr_datlink[mthp_int] = datfifo[mthb_int];
      end
    end
  end
  for (mthp_int=0; mthp_int<NUMPUPT; mthp_int=mthp_int+1) begin
    mthw_ptrfifo[mthp_int] = 1'b0;
    mthw_vlplink[mthp_int] = 1'b0;
    mthw_ptrlink[mthp_int] = 0;
    mthw_datfifo[mthp_int] = 1'b0;
    mthw_vldlink[mthp_int] = 1'b0;
    mthw_datlink[mthp_int] = 0;
    for (mthb_int=0; mthb_int<FIFOCNT; mthb_int=mthb_int+1) begin
      if ((mthb_int<fifocnt) && (ptrfifo[mthb_int][BITADDR-1:0] == t1_addrA_wire[mthp_int])) begin
        mthw_ptrfifo[mthp_int] = 1'b1;
        mthw_vlplink[mthp_int] = vlpfifo[mthb_int];
        mthw_ptrlink[mthp_int] = ptrfifo[mthb_int+NUMPING];
      end
      if ((mthb_int<fifocnt) && (ptrfifo[mthb_int][BITADDR-1:0] == t2_addrA_wire[mthp_int])) begin
        mthw_datfifo[mthp_int] = 1'b1;
        mthw_vldlink[mthp_int] = vldfifo[mthb_int];
        mthw_datlink[mthp_int] = datfifo[mthb_int];
      end
    end
  end
end

genvar link_var;
generate begin: link_loop
  for (link_var=0; link_var<NUMPOPT; link_var=link_var+1) begin: lnkr_loop
    assert_lnkr_check: assert property (@(posedge clk) disable iff (rst || !ready) (t1_readB_wire[link_var] && mthr_vlplink[link_var] && mthr_ptrfifo[link_var]) |-> ##LINK_DELAY
                                        (t1_doutB_wire[link_var] == $past(mthr_ptrlink[link_var],LINK_DELAY)));
    assert_datr_check: assert property (@(posedge clk) disable iff (rst || !ready) (t2_readB_wire[link_var] && mthr_vldlink[link_var] && mthr_datfifo[link_var]) |-> ##DATA_DELAY
                                        (t2_doutB_wire[link_var] == $past(mthr_datlink[link_var],DATA_DELAY)));
  end
  for (link_var=0; link_var<NUMPUPT; link_var=link_var+1) begin: lnkw_loop
    assert_lnkw_check: assert property (@(posedge clk) disable iff (rst || !ready) (t1_writeA_wire[link_var] && mthw_ptrfifo[link_var]) |->
                                        !mthw_vlplink[link_var] && (t1_dinA_wire[link_var] == mthw_ptrlink[link_var]));
    assert_datw_check: assert property (@(posedge clk) disable iff (rst || !ready) (t2_writeA_wire[link_var] && mthw_datfifo[link_var]) |->
                                        !mthw_vldlink[link_var] && (t2_dinA_wire[link_var] == mthw_datlink[link_var]));
  end
end
endgenerate

reg [BITADDR-1:0] tail_tmp [0:NUMPUPT-1][0:NUMPING-1];
reg mtch_tail [0:NUMPUPT-1][0:NUMPING-1];
integer tail_int, taif_int, taib_int;
always_comb
  for (tail_int=0; tail_int<NUMPUPT; tail_int=tail_int+1)
    for (taib_int=0; taib_int<NUMPING; taib_int=taib_int+1) begin
      mtch_tail[tail_int][taib_int] = 1'b0;
      for (taif_int=0; taif_int<FIFOCNT; taif_int=taif_int+1)
        if ((taif_int<fifocnt) && (tail_tmp[tail_int][taib_int] == ptrfifo[taif_int][BITADDR-1:0]))
          mtch_tail[tail_int][taib_int] = 1'b1;
    end

genvar tnot_var, tnob_var;
generate for (tnot_var=0; tnot_var<NUMPUPT; tnot_var=tnot_var+1) begin: tnot_loop
  for (tnob_var=0; tnob_var<NUMPING; tnob_var=tnob_var+1) begin: tnob_loop
    assert_tail_not_check: assert property (@(posedge clk) disable iff (rst || !ready) (t7_readB_wire[tnot_var] && !(t7_addrB_wire[tnot_var] == select_qprt)) |-> ##QPTR_DELAY
                                            !(|core.cnt_out[tnot_var+NUMPOPT]) ||
                                            ((!mtch_tail[tnot_var][tnob_var] &&
                                             (((core.tail_out[tnot_var] >> (tnob_var*BITQPTR)) & {BITADDR{1'b1}}) == tail_tmp[tnot_var][tnob_var]))));
  end
end
endgenerate

genvar pop_var;
generate
  for (pop_var=0; pop_var<NUMPOPT; pop_var=pop_var+1) begin: pop_loop
    assert_po_mt_check: assert property (@(posedge clk) disable iff (rst || !ready) (pop_wire[pop_var] && (po_prt_wire[pop_var] == select_qprt)) |-> |fakecnt);
//    assert_po_bb_check: assert property (@(posedge clk) disable iff (rst || !ready) (pop_wire[pop_var] && (po_prt_wire[pop_var] == select_qprt)) |-> ##1
//                                         !(pop_wire[pop_var] && (po_prt_wire[pop_var] == select_qprt)) [*3]);
  end
endgenerate

reg allo_ptr [0:NUMPUPT-1];
integer allo_int, allf_int, allp_int;
always_comb
  for (allo_int=0; allo_int<NUMPUPT; allo_int=allo_int+1) begin
    allo_ptr[allo_int] = 1'b0;
    for (allf_int=0; allf_int<QPTR_DELAY-1; allf_int=allf_int+1)
      for (allp_int=0; allp_int<NUMPUPT; allp_int=allp_int+1)
        if (push_wire[allo_int] && push_reg[allp_int][allf_int] && (pu_ptr_wire[allo_int][BITADDR-1:0]==pu_ptr_reg[allp_int][allf_int][BITADDR-1:0]))
          allo_ptr[allo_int] = 1'b1;
    for (allf_int=0; allf_int<FIFOCNT; allf_int=allf_int+1)
      if ((allf_int<fifocnt) && push_wire[allo_int] && (pu_ptr_wire[allo_int][BITADDR-1:0]==ptrfifo[allf_int][BITADDR-1:0]))
        allo_ptr[allo_int] = 1'b1;
  end

genvar push_var;
generate begin: push_loop
  for (push_var=0; push_var<NUMPUPT; push_var=push_var+1) begin: fa_loop
    assert_pu_fu_check: assert property (@(posedge clk) disable iff (rst || !ready) (push_wire[push_var] && (pu_prt_wire[push_var] == select_qprt)) |-> (fifocnt_nxt<=FIFOCNT));
    assert_pu_al_check: assert property (@(posedge clk) disable iff (rst || !ready) push_wire[push_var] |-> !allo_ptr[push_var]);
  end
end
endgenerate

reg same_ptr;
integer same_int, samp_int;
always_comb begin
  same_ptr = 1'b0;
  for (same_int=0; same_int<NUMPUPT; same_int=same_int+1)
    for (samp_int=same_int+1; samp_int<NUMPUPT; samp_int=samp_int+1)
      if (push_wire[same_int] && push_wire[samp_int] && (pu_ptr_wire[same_int][BITADDR-1:0]==pu_ptr_wire[samp_int][BITADDR-1:0]))
        same_ptr = 1'b1;
end

assert_pu_same_check: assert property (@(posedge clk) disable iff (rst || !ready) !same_ptr);

genvar itf_var,mdat_var;
generate begin: itf_loop
  for (itf_var=0; itf_var<NUMPUPT; itf_var=itf_var+1) begin: pu_cnt_loop
    reg [BITADDR-1:0] puptr;
    reg puptr_vld;
    always @(posedge clk) begin
      if (rst) begin
        puptr_vld <= 0;
      end else begin
        puptr <= (push_wire[itf_var] && !pu_owr_wire[itf_var] && (pu_prt_wire[itf_var] == select_qprt)) ? pu_ptr_wire[itf_var] : puptr;
        puptr_vld <= (push_wire[itf_var] && !pu_owr_wire[itf_var] && (pu_prt_wire[itf_var] == select_qprt)) ? 1'b1 : puptr_vld;
      end
    end
    assert_pu_owr_check: assert property (@(posedge clk) disable iff (rst || !ready) (push_wire[itf_var] && pu_owr_wire[itf_var] && (pu_prt_wire[itf_var] == select_qprt)) |-> (puptr_vld && (puptr == pu_ptr_wire[itf_var])));
    if (QPTR_DELAY+FLOPOUT == 1) begin: pu_cnt_qptr0_loop
      assert_cnt_check: assert property (@(posedge clk) disable iff (rst || !ready) (push_wire[itf_var] && (pu_prt_wire[itf_var] == select_qprt)) |-> ##(QPTR_DELAY+FLOPOUT)
                                         (pu_cvld_wire[itf_var] && (pu_cnt_wire[itf_var] == fakecnt)));
    end else begin : pu_cnt_qptr1_loop
      assert_cnt_check: assert property (@(posedge clk) disable iff (rst || !ready) (push_wire[itf_var] && (pu_prt_wire[itf_var] == select_qprt)) |-> ##(QPTR_DELAY+FLOPOUT)
                                         (pu_cvld_wire[itf_var] && (pu_cnt_wire[itf_var] == $past(fakecnt,QPTR_DELAY+FLOPOUT-1))));
    end
  end
  for (itf_var=0; itf_var<NUMPOPT; itf_var=itf_var+1) begin: po_cnt_loop
    if (QPTR_DELAY+FLOPOUT == 1) begin: po_cnt_qptr0_loop
      assert_cnt_check: assert property (@(posedge clk) disable iff (rst || !ready) (pop_wire[itf_var] && (po_prt_wire[itf_var] == select_qprt)) |-> ##(QPTR_DELAY+FLOPOUT)
                                         (po_cvld_wire[itf_var] && (po_cnt_wire[itf_var] == fakecnt)));
    end else begin : po_cnt_qptr1_loop
      assert_cnt_check: assert property (@(posedge clk) disable iff (rst || !ready) (pop_wire[itf_var] && (po_prt_wire[itf_var] == select_qprt)) |-> ##(QPTR_DELAY+FLOPOUT)
                                         (po_cvld_wire[itf_var] && (po_cnt_wire[itf_var] == $past(fakecnt,QPTR_DELAY+FLOPOUT-1))));
    end
    if (QPTR_DELAY+FLOPOUT == 0) begin: po_cmt_qptr0_loop
      assert_cmt_check: assert property (@(posedge clk) disable iff (rst || !ready) (pop_wire[itf_var] && (po_prt_wire[itf_var] == select_qprt)) |->
                                         (po_cvld_wire[itf_var] && (po_cmt_wire[itf_var] != |fakecnt)));
    end else begin : po_cmt_qptr1_loop
      assert_cmt_check: assert property (@(posedge clk) disable iff (rst || !ready) (pop_wire[itf_var] && (po_prt_wire[itf_var] == select_qprt)) |-> ##(QPTR_DELAY+FLOPOUT)
                                         (po_cvld_wire[itf_var] && (po_cmt_wire[itf_var] != $past(|fakecnt,QPTR_DELAY+FLOPOUT))));
    end
  end
  for (itf_var=0; itf_var<NUMPOPT; itf_var=itf_var+1) begin: head_loop
    if (FLOPOUT == 0) begin: po_head_qptr0_loop
      assert_head_check: assert property (@(posedge clk) disable iff (rst || !ready) (pop_wire[itf_var] && (po_prt_wire[itf_var] == select_qprt)) |-> ##(QPTR_DELAY+FLOPOUT)
                                          (po_pvld_wire[itf_var] && ($past(!(|fakecnt),QPTR_DELAY) || (po_ptr_wire[itf_var] == ptrfifo[0][BITADDR-1:0]))));
    end else begin : po_head_qptr1_loop
      assert_head_check: assert property (@(posedge clk) disable iff (rst || !ready) (pop_wire[itf_var] && (po_prt_wire[itf_var] == select_qprt)) |-> ##(QPTR_DELAY+FLOPOUT)
                                          (po_pvld_wire[itf_var] && ($past(!(|fakecnt),QPTR_DELAY+FLOPOUT) || (po_ptr_wire[itf_var] == $past(ptrfifo[0],FLOPOUT)))));
    end
  end
  for (itf_var=0; itf_var<NUMPOPT; itf_var=itf_var+1) begin: mdat_loop
    for (mdat_var=0; mdat_var<NUMMDAT; mdat_var=mdat_var+1) begin: nummdat_loop
      if (FLOPOUT == 0) begin: po_mdat_qptr0_loop
        assert_mdat_check: assert property (@(posedge clk) disable iff (rst || !ready) (pop_wire[itf_var] && (po_prt_wire[itf_var] == select_qprt) && (mdat_var < fakecnt)) |-> ##(QPTR_DELAY+FLOPOUT)
                                            (po_pvld_wire[itf_var] && ($past(!(|fakecnt),QPTR_DELAY) || (po_mdat_wire[itf_var][(mdat_var+1)*BITMDAT-1:mdat_var*BITMDAT] == ptrfifo[mdat_var][BITQPTR+BITMDAT-1:BITQPTR]))));
      end else begin : po_head_qptr1_loop
        assert_mdat_check: assert property (@(posedge clk) disable iff (rst || !ready) (pop_wire[itf_var] && (po_prt_wire[itf_var] == select_qprt) && (mdat_var < fakecnt)) |-> ##(QPTR_DELAY+FLOPOUT)
                                            (po_pvld_wire[itf_var] && ($past(!(|fakecnt),QPTR_DELAY+FLOPOUT) || (po_mdat_wire[itf_var][(mdat_var+1)*BITMDAT-1:mdat_var*BITMDAT] == $past(ptrfifo[mdat_var][BITQPTR+BITMDAT-1:BITQPTR],FLOPOUT)))));
      end
    end
  end

  for (itf_var=0; itf_var<NUMPOPT; itf_var=itf_var+1) begin: dout_loop
    assert_dout_check: assert property (@(posedge clk) disable iff (rst || !ready) (pop_wire[itf_var] && (po_prt_wire[itf_var] == select_qprt)) |-> ##(QPTR_DELAY+DATA_DELAY+FLOPOUT)
                                        (po_dvld_wire[itf_var] && ($past(!(|fakecnt),QPTR_DELAY+DATA_DELAY) ||
                                                                   (po_dout_wire[itf_var] == $past(datfifo[0],DATA_DELAY+FLOPOUT)))));
  end
end
endgenerate

endmodule
