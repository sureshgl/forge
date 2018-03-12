module ip_top_sva_2_mrnw_fque_doppler
  #(
parameter     NUMADDR = 16,
parameter     BITADDR = 4,
parameter     NUMPORT = 2,
parameter     BITPORT = 1,
parameter     NUMVROW = 8,
parameter     BITVROW = 3,
parameter     BITQPTR = BITADDR
   )
(
  input clk,
  input rst,
  input ready,
  input [NUMPORT-1:0]         push,
  input [NUMPORT*BITQPTR-1:0] pu_ptr,
  input [NUMPORT-1:0]         pop,
  input [NUMPORT-1:0]         t1_writeA,
  input [NUMPORT*BITVROW-1:0] t1_addrA,
  input [NUMPORT*BITQPTR-1:0] t1_dinA,
  input [NUMPORT-1:0]         t1_readB,
  input [NUMPORT*BITVROW-1:0] t1_addrB
);

genvar pu_var;
generate
  for (pu_var=0; pu_var<NUMPORT; pu_var=pu_var+1) begin: pu_loop
    wire push_wire = push >> pu_var;
    wire [BITADDR-1:0] pu_ptr_wire = pu_ptr >> (pu_var*BITQPTR);

    assert_pu_range_check: assert property (@(posedge clk) disable iff (!ready) push_wire |-> (pu_ptr_wire < NUMADDR));
  end
endgenerate

genvar t1w_var;
generate
  for (t1w_var=0; t1w_var<NUMPORT; t1w_var=t1w_var+1) begin: t1w_loop
    wire t1_writeA_wire = t1_writeA >> t1w_var;
    wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> (t1w_var*BITVROW);
    wire [BITQPTR-1:0] t1_dinA_wire = t1_dinA >> (t1w_var*BITQPTR);

    assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> ((t1_addrA_wire < NUMVROW) && (t1_dinA_wire < NUMADDR)));
  end
endgenerate

genvar t1r_var;
generate
  for (t1r_var=0; t1r_var<NUMPORT; t1r_var=t1r_var+1) begin: t1r_loop
    wire t1_readB_wire = t1_readB >> t1r_var;
    wire [BITVROW-1:0] t1_addrB_wire = t1_addrB >> (t1r_var*BITVROW);

    assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> (t1_addrB_wire < NUMVROW));
  end
endgenerate

endmodule


module ip_top_sva_mrnw_fque_doppler
  #(
parameter     NUMPORT = 2,
parameter     BITPORT = 1,
parameter     NUMADDR = 16,
parameter     BITADDR = 4,
parameter     NUMVROW = 8,
parameter     BITVROW = 3,
parameter     QPTR_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0,
parameter     FIFOCNT = NUMADDR,
parameter     BITQPTR = BITADDR,
parameter     BITQCNT = BITADDR+1
   )
(
  input clk,
  input rst,
  input ready,
  input [NUMPORT-1:0] push,
  input [NUMPORT*BITQPTR-1:0] pu_ptr,
  input [NUMPORT-1:0] pop,
  input [NUMPORT-1:0] po_pvld,
  input [NUMPORT*BITQPTR-1:0] po_ptr,
  input [NUMPORT-1:0] t1_writeA,
  input [NUMPORT*BITVROW-1:0] t1_addrA,
  input [NUMPORT*BITQPTR-1:0] t1_dinA,
  input [NUMPORT-1:0] t1_readB,
  input [NUMPORT*BITVROW-1:0] t1_addrB,
  input [NUMPORT*BITQPTR-1:0] t1_doutB
);

wire push_wire [0:NUMPORT-1];
wire [BITQPTR-1:0] pu_ptr_wire [0:NUMPORT-1];
wire pop_wire [0:NUMPORT-1];
wire po_pvld_wire [0:NUMPORT-1];
wire [BITQPTR-1:0] po_ptr_wire [0:NUMPORT-1];
genvar prt_var;
generate if (1) begin: prt_loop
  for (prt_var=0; prt_var<NUMPORT; prt_var=prt_var+1) begin: pu_loop
    assign push_wire[prt_var] = push >> prt_var;
    assign pu_ptr_wire[prt_var] = pu_ptr >> (prt_var*BITQPTR);
  end
  for (prt_var=0; prt_var<NUMPORT; prt_var=prt_var+1) begin: po_loop
    assign pop_wire[prt_var] = pop >> prt_var;
    assign po_pvld_wire[prt_var] = po_pvld >> prt_var;
    assign po_ptr_wire[prt_var] = po_ptr >> (prt_var*BITQPTR);
  end
end
endgenerate

wire t1_writeA_wire [0:NUMPORT-1];
wire [BITVROW-1:0] t1_addrA_wire [0:NUMPORT-1];
wire [BITQPTR-1:0] t1_dinA_wire [0:NUMPORT-1];
wire t1_readB_wire [0:NUMPORT-1];
wire [BITVROW-1:0] t1_addrB_wire [0:NUMPORT-1];
wire [BITQPTR-1:0] t1_doutB_wire [0:NUMPORT-1];

genvar txr_var;
generate begin: tx_loop
  for (txr_var=0; txr_var<NUMPORT; txr_var=txr_var+1) begin: t1w_loop
    assign t1_writeA_wire[txr_var] = t1_writeA >> txr_var;
    assign t1_addrA_wire[txr_var] = t1_addrA >> (txr_var*BITVROW);
    assign t1_dinA_wire[txr_var] = t1_dinA >> (txr_var*BITQPTR);
  end
  for (txr_var=0; txr_var<NUMPORT; txr_var=txr_var+1) begin: t1r_loop
    assign t1_readB_wire[txr_var] = t1_readB >> txr_var;
    assign t1_addrB_wire[txr_var] = t1_addrB >> (txr_var*BITVROW);
    assign t1_doutB_wire[txr_var] = t1_doutB >> (txr_var*BITQPTR);
  end
end
endgenerate

reg [BITQCNT-1:0] fakecnt_nxt;
reg [BITQCNT-1:0] fakecnt;
integer fcnt_int;
always_comb begin
  fakecnt_nxt = fakecnt;
  for (fcnt_int=0; fcnt_int<NUMPORT; fcnt_int=fcnt_int+1) 
    if (pop_wire[fcnt_int])
      fakecnt_nxt = fakecnt_nxt - 1;
  for (fcnt_int=0; fcnt_int<NUMPORT; fcnt_int=fcnt_int+1) 
    if (push_wire[fcnt_int])
      fakecnt_nxt = fakecnt_nxt + 1;
end

always @(posedge clk)
  if (!ready)
    fakecnt <= FIFOCNT;
  else
    fakecnt <= fakecnt_nxt;

reg [3:0] popcnt;
reg [3:0] pushcnt;
integer pprt_int;
always_comb begin
  popcnt = 0;
  for (pprt_int=0; pprt_int<NUMPORT; pprt_int=pprt_int+1)
    if (pop_wire[pprt_int])
      popcnt = popcnt + 1;
  pushcnt = 0;
  for (pprt_int=0; pprt_int<NUMPORT; pprt_int=pprt_int+1)
    if (push_wire[pprt_int])
      pushcnt = pushcnt + 1;
end

reg [BITADDR-1:0] tailptr;
always @(posedge clk)
  if (!ready)
    tailptr <= 0;
  else
    tailptr <= (tailptr + pushcnt)%FIFOCNT;

reg [3:0] push_sel [0:NUMPORT-1];
integer fifn_int;
always_comb
  for (fifn_int=0; fifn_int<NUMPORT; fifn_int=fifn_int+1) begin
    if (fifn_int>0)
      push_sel[fifn_int] = push_sel[fifn_int-1];
    else
      push_sel[fifn_int] = fakecnt-popcnt-1;
    if (push_wire[fifn_int])
      push_sel[fifn_int] = push_sel[fifn_int] + 1;
  end
    
reg [3:0] tailptrval [0:NUMPORT-1];
integer tail_int;
always_comb begin
  for (tail_int=0; tail_int<NUMPORT; tail_int=tail_int+1) begin
    if (tail_int>0)
      tailptrval[tail_int] = tailptrval[tail_int-1];
    else
      tailptrval[tail_int] = 0;
    if ((push_wire[tail_int]))
       tailptrval[tail_int] = tailptrval[tail_int] + 1;
  end
end
reg [3:0] headptrval [0:NUMPORT-1];
integer head_int;
always_comb begin
  for (head_int=0; head_int<NUMPORT; head_int=head_int+1) begin
    if (head_int>0)
      headptrval[head_int] = headptrval[head_int-1];
    else
      headptrval[head_int] = 0;
    if ((pop_wire[head_int]))
       headptrval[head_int] = headptrval[head_int] + 1;
  end
end

reg [BITADDR-1:0] adrfifo [0:FIFOCNT-1];
reg [BITQPTR-1:0] ptrfifo [0:FIFOCNT-1];
reg vldfifo [0:FIFOCNT-1];
reg [BITADDR-1:0] adrfifo_nxt [0:FIFOCNT-1];
reg [BITQPTR-1:0] ptrfifo_nxt [0:FIFOCNT-1];
reg vldfifo_nxt[0:FIFOCNT-1];
integer fifo_int, fifp_int;
always_comb
  for (fifo_int=0; fifo_int<FIFOCNT; fifo_int=fifo_int+1) begin
    adrfifo_nxt[fifo_int] = adrfifo[fifo_int];
    vldfifo_nxt[fifo_int] = vldfifo[fifo_int];
    ptrfifo_nxt[fifo_int] = ptrfifo[fifo_int];
    if (fifo_int<(fakecnt-popcnt)) begin
      adrfifo_nxt[fifo_int] = adrfifo[fifo_int+popcnt];
      vldfifo_nxt[fifo_int] = vldfifo[fifo_int+popcnt];
      ptrfifo_nxt[fifo_int] = ptrfifo[fifo_int+popcnt];
    end
    if (fifo_int>=(fakecnt-popcnt))
      for (fifp_int=0; fifp_int<NUMPORT; fifp_int=fifp_int+1)
        if (push_wire[fifp_int] && (fifo_int==push_sel[fifp_int])) begin
          adrfifo_nxt[fifo_int] = tailptr + tailptrval[fifp_int] - 1;
          vldfifo_nxt[fifo_int] = 1'b0;
          ptrfifo_nxt[fifo_int] = pu_ptr_wire[fifp_int];
        end
    for (fifp_int=0; fifp_int<NUMPORT; fifp_int=fifp_int+1)
      if (t1_writeA_wire[fifp_int] && ((NUMPORT*t1_addrA_wire[fifp_int]+fifp_int) == adrfifo_nxt[fifo_int]) && (t1_dinA_wire[fifp_int]==ptrfifo_nxt[fifo_int]))
        vldfifo_nxt[fifo_int] = 1'b1;
    if (!ready) begin
      adrfifo_nxt[fifo_int] = fifo_int;
      vldfifo_nxt[fifo_int] = 1'b1;
      ptrfifo_nxt[fifo_int] = fifo_int;
    end
  end

integer fiff_int;
always @(posedge clk)
  for (fiff_int=0; fiff_int<FIFOCNT; fiff_int=fiff_int+1) begin
    adrfifo[fiff_int] <= adrfifo_nxt[fiff_int];
    vldfifo[fiff_int] <= vldfifo_nxt[fiff_int];
    ptrfifo[fiff_int] <= ptrfifo_nxt[fiff_int];
  end

reg mthr_ptrfifo [0:NUMPORT-1];
reg mthr_vldlink [0:NUMPORT-1];
reg [BITQPTR-1:0] mthr_ptrlink [0:NUMPORT-1];
reg [0:BITPORT-1] mthr_bank [0:NUMPORT-1];
reg mthw_ptrfifo [0:NUMPORT-1];
reg mthw_vldlink [0:NUMPORT-1];
reg [BITQPTR-1:0] mthw_ptrlink [0:NUMPORT-1];
reg [0:BITPORT-1] mthw_bank [0:NUMPORT-1];
integer mthp_int, mthb_int;
always_comb begin
  for (mthp_int=0; mthp_int<NUMPORT; mthp_int=mthp_int+1) begin
    mthr_ptrfifo[mthp_int] = 1'b0;
    mthr_vldlink[mthp_int] = 1'b0;
    mthr_ptrlink[mthp_int] = 0;
    mthr_bank[mthp_int] = mthp_int;
    for (mthb_int=0; mthb_int<FIFOCNT; mthb_int=mthb_int+1) begin
      if(mthp_int >0) begin
      if ((mthb_int<fakecnt) && (adrfifo[mthb_int] == ((mthp_int + (NUMPORT * t1_addrB_wire[mthp_int]))))) begin
        mthr_ptrfifo[mthp_int] = 1'b1;
        mthr_vldlink[mthp_int] = vldfifo[mthb_int];
        mthr_ptrlink[mthp_int] = ptrfifo[mthb_int];
      end
      end else 
      if ((mthb_int<fakecnt) && (adrfifo[mthb_int] == ((NUMPORT*t1_addrB_wire[mthp_int])))) begin
        mthr_ptrfifo[mthp_int] = 1'b1;
        mthr_vldlink[mthp_int] = vldfifo[mthb_int];
        mthr_ptrlink[mthp_int] = ptrfifo[mthb_int];
      end
    end
  end
  for (mthp_int=0; mthp_int<NUMPORT; mthp_int=mthp_int+1) begin
    mthw_ptrfifo[mthp_int] = 1'b0;
    mthw_vldlink[mthp_int] = 1'b0;
    mthw_ptrlink[mthp_int] = 0;
    mthw_bank[mthp_int]    =mthp_int;
    for (mthb_int=0; mthb_int<FIFOCNT; mthb_int=mthb_int+1) begin
      if ((mthb_int<fakecnt_nxt) && (adrfifo_nxt[mthb_int] == (NUMPORT*t1_addrA_wire[mthp_int]+ mthp_int) && t1_writeA_wire[mthp_int])) begin
        mthw_ptrfifo[mthp_int] = 1'b1;
        mthw_vldlink[mthp_int] = vldfifo_nxt[mthb_int];
        mthw_ptrlink[mthp_int] = ptrfifo_nxt[mthb_int];
      end
    end
  end
end

genvar link_var;
generate begin: link_loop
  for (link_var=0; link_var<NUMPORT; link_var=link_var+1) begin: lnkr_loop
    assert_lnkr_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire[link_var] && mthr_vldlink[link_var] && mthr_ptrfifo[link_var]) |-> ##QPTR_DELAY
                                        (t1_doutB_wire[link_var] == $past(mthr_ptrlink[link_var],QPTR_DELAY)));
  end
  for (link_var=0; link_var<NUMPORT; link_var=link_var+1) begin: lnkw_loop
    assert_lnkw_check: assert property (@(posedge clk) disable iff (rst) (t1_writeA_wire[link_var]) |->
                                        (t1_dinA_wire[link_var] == mthw_ptrlink[link_var])&& mthw_ptrfifo[link_var]);
  end
end
endgenerate

genvar pop_var;
generate
  for (pop_var=0; pop_var<NUMPORT; pop_var=pop_var+1) begin: pop_loop
    assert_po_mt_check: assert property (@(posedge clk) disable iff (rst) pop_wire[pop_var] |-> (fakecnt >= headptrval[pop_var]));
  end
endgenerate

reg allo_ptr [0:NUMPORT-1];
integer allo_int, allf_int, allp_int;
always_comb
  for (allo_int=0; allo_int<NUMPORT; allo_int=allo_int+1) begin
    allo_ptr[allo_int] = 1'b0;
    for (allf_int=0; allf_int<FIFOCNT; allf_int=allf_int+1)
      if ((allf_int<fakecnt) && push_wire[allo_int] && (pu_ptr_wire[allo_int][BITADDR-1:0]==ptrfifo[allf_int][BITADDR-1:0]))
        allo_ptr[allo_int] = 1'b1;
  end

genvar push_var, push2_var;
generate begin: push_loop
  for (push_var=0; push_var<NUMPORT; push_var=push_var+1) begin: fa_loop
    assert_pu_fu_check: assert property (@(posedge clk) disable iff (rst) push_wire[push_var] |-> ((fakecnt+tailptrval[push_var] - popcnt)<=FIFOCNT));
    assert_pu_al_check: assert property (@(posedge clk) disable iff (rst) push_wire[push_var] |-> !allo_ptr[push_var]);
    for (push2_var=0; push2_var < push_var; push2_var = push2_var+1) begin: dup_loop
      assert_pu_ptr_dup_check: assert property (@(posedge clk) disable iff (rst) push_wire[push_var] |-> (pu_ptr_wire[push2_var] != pu_ptr_wire[push_var]));
    end
  end
end
endgenerate

genvar itf_var;
generate begin: itf_loop
  for (itf_var=0; itf_var<NUMPORT; itf_var=itf_var+1) begin: head_loop
    assert_head_check: assert property (@(posedge clk) disable iff (rst) pop_wire[itf_var] |->
                                        (po_pvld_wire[itf_var] && (po_ptr_wire[itf_var] == ptrfifo[headptrval[itf_var]-1])));
  end
end
endgenerate

assert_cnt_check:  assert property (@(posedge clk) disable iff (rst) ((core.pbnk_freecnt[core.max_bnk]-core.pbnk_freecnt[core.min_bnk]) <= 1));

endmodule

