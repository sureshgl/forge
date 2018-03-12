module ip_top_sva_2_mrnw_queue
  #(
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMQUEU = 32,
parameter     BITQUEU = 5,
parameter     NUMPUPT = 2,
parameter     NUMPOPT = 2
   )
(
  input clk,
  input rst,
  input ready,
  input [NUMPUPT-1:0] push,
  input [NUMPUPT*BITQUEU-1:0] pu_adr,
  input [NUMPUPT*BITADDR-1:0] pu_din,
  input [NUMRDPT-1:0] pop,
  input [NUMRDPT*BITQUEU-1:0] po_adr,
  input [NUMPUPT-1:0] t1_writeA,
  input [NUMPUPT*BITADDR-1:0] t1_addrA,
  input [NUMPUPT*BITADDR-1:0] t1_dinA,
  input [NUMPOPT-1:0] t1_readB,
  input [NUMPOPT*BITADDR-1:0] t1_addrB
);

genvar pu_var;
generate
  for (pu_var=0; pu_var<NUMPUPT; pu_var=pu_var+1) begin: pu_loop
    wire push_wire = push >> pu_var;
    wire [BITQUEU-1:0] pu_adr_wire = pu_adr >> (pu_var*BITQUEU);

    assert_pu_range_check: assert property (@(posedge clk) disable iff (!ready) push_wire |-> (pu_adr_wire < NUMQUEU));
  end
endgenerate

genvar po_var;
generate
  for (po_var=0; po_var<NUMPOPT; po_var=po_var+1) begin: po_loop
    wire read_wire = pop >> po_var;
    wire [BITQUEU-1:0] po_adr_wire = po_adr >> (po_var*BITQUEU);

    assert_po_range_check: assert property (@(posedge clk) disable iff (!ready) pop_wire |-> (po_adr_wire < NUMQUEU));
  end
endgenerate

genvar t1w_var;
generate
  for (t1w_var=0; t1w_var<NUMPUPT; t1w_var=t1w_var+1) begin: t1w_loop
    wire t1_writeA_wire = t1_writeA >> t1w_var;
    wire [BITADDR-1:0] t1_addrA_wire = t1_addrA >> (t1w_var*BITADDR);

    assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMADDR));
  end
endgenerate

genvar t1r_var;
generate
  for (t1r_var=0; t1r_var<NUMPOPT; t1r_var=t1r_var+1) begin: t1r_loop
    wire t1_readB_wire = t1_readB >> t1r_var;
    wire [BITADDR-1:0] t1_addrB_wire = t1_addrB >> (t1r_var*BITADDR);

    assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> (t1_addrB_wire < NUMADDR));
    end
  end
endgenerate

endmodule


module ip_top_sva_mrnw_queue
  #(
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMQUEU = 32,
parameter     BITQUEU = 5,
parameter     NUMPUPT = 2,
parameter     NUMPOPT = 2
parameter     BITPADR = 14,
parameter     NUMSBFL = 2,
parameter     SRAM_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0
   )
(
  input clk,
  input rst,
  input ready,
  input [NUMPUPT-1:0] push,
  input [NUMPUPT*BITQUEU-1:0] pu_adr,
  input [NUMPUPT*BITADDR-1:0] pu_din,
  input [NUMPOPT-1:0] pop,
  input [NUMPOPT*BITQUEU-1:0] po_adr,
  input [NUMPOPT-1:0] po_vld,
  input [NUMPOPT*WIDTH-1:0] po_dout,
  input [NUMPOPT-1:0] po_fwrd,
  input [NUMPOPT-1:0] po_serr,
  input [NUMPOPT-1:0] po_derr,
  input [NUMPOPT*BITPADR-1:0] po_padr,
  input [NUMPUPT-1:0] t1_writeA,
  input [NUMPUPT*BITADDR-1:0] t1_addrA,
  input [NUMPUPT*BITADDR-1:0] t1_dinA,
  input [NUMPOPT-1:0] t1_readB,
  input [NUMPOPT*BITADDR-1:0] t1_addrB,
  input [NUMPOPT*BITADDR-1:0] t1_doutB,
  input [NUMPOPT-1:0] t1_fwrdB,
  input [NUMPOPT-1:0] t1_serrB,
  input [NUMPOPT-1:0] t1_derrB,
  input [NUMPOPT*BITPADR-1:0] t1_padrB,
  input [BITQUEU-1:0] select_queue,
  input [BITADDR-1:0] select_addr
);

wire push_wire [0:NUMPUPT-1];
wire [BITQUEU-1:0] pu_adr_wire [0:NUMPUPT-1];
wire [BITADDR-1:0] pu_din_wire [0:NUMPUPT-1];
wire pop_wire [0:NUMPOPT-1];
wire [BITQUEU-1:0] po_adr_wire [0:NUMPOPT-1];
wire po_vld_wire [0:NUMPOPT-1];
wire [BITADDR-1:0] po_dout_wire [0:NUMPOPT-1];
wire po_fwrd_wire [0:NUMPOPT-1];
wire po_serr_wire [0:NUMPOPT-1];
wire po_derr_wire [0:NUMPOPT-1];
wire [BITPADR-1:0] po_padr_wire [0:NUMPOPT-1];
genvar prt_var;
generate if (1) begin: prt_loop
  for (prt_var=0; prt_var<NUMPUPT; prt_var=prt_var+1) begin: pu_loop
    assign push_wire[prt_var] = push >> prt_var;
    assign pu_adr_wire[prt_var] = pu_adr >> (prt_var*BITQUEU);
    assign pu_din_wire[prt_var] = pu_din >> (prt_var*BITADDR);
  end
  for (prt_var=0; prt_var<NUMPOPT; prt_var=prt_var+1) begin: po_loop
    assign pop_wire[prt_var] = pop >> prt_var;
    assign po_adr_wire[prt_var] = po_adr >> (prt_var*BITQUEU);
    assign po_vld_wire[prt_var] = po_vld >> prt_var;
    assign po_dout_wire[prt_var] = po_dout >> (prt_var*BITADDR);
    assign po_fwrd_wire[prt_var] = po_fwrd >> prt_var;
    assign po_serr_wire[prt_var] = po_serr >> prt_var;
    assign po_derr_wire[prt_var] = po_derr >> prt_var;
    assign po_padr_wire[prt_var] = po_padr >> (prt_var*BITPADR);
  end
end
endgenerate
/*
reg write_reg [0:NUMWRPT-1];
reg [WIDTH-1:0] din_reg [0:NUMWRPT-1];
integer wrd_int;
always @(posedge clk)
  for (wrd_int=0; wrd_int<NUMWRPT; wrd_int=wrd_int+1) begin
    write_reg[wrd_int] <= write_wire[wrd_int] && ready;
    din_reg[wrd_int] <= din_wire[wrd_int];
  end

reg write_del [0:NUMWRPT-1];
reg [BITVBNK-1:0] wr_badr_del [0:NUMWRPT-1];
reg [BITVROW-1:0] wr_radr_del [0:NUMWRPT-1];
integer wrdl_int;
always @(posedge clk)
  for (wrdl_int=0; wrdl_int<NUMWRPT; wrdl_int=wrdl_int+1) begin
    write_del[wrdl_int] <= write_reg[wrdl_int];
    wr_badr_del[wrdl_int] <= wr_badr_wire[wrdl_int];
    wr_radr_del[wrdl_int] <= wr_radr_wire[wrdl_int];
  end

wire t1_writeA_wire [0:NUMVBNK-1][0:NUMRDPT-1];
wire [BITVROW-1:0] t1_addrA_wire [0:NUMVBNK-1][0:NUMRDPT-1];
wire [WIDTH-1:0] t1_dinA_wire [0:NUMVBNK-1][0:NUMRDPT-1];
wire t1_readB_wire [0:NUMVBNK-1][0:NUMRDPT-1];
wire [BITVROW-1:0] t1_addrB_wire [0:NUMVBNK-1][0:NUMRDPT-1];
wire [WIDTH-1:0] t1_doutB_wire [0:NUMVBNK-1][0:NUMRDPT-1];
wire t1_fwrdB_wire [0:NUMVBNK-1][0:NUMRDPT-1];
wire t1_serrB_wire [0:NUMVBNK-1][0:NUMRDPT-1];
wire t1_derrB_wire [0:NUMVBNK-1][0:NUMRDPT-1];
wire [BITPADR-BITVBNK-1:0] t1_padrB_wire [0:NUMVBNK-1][0:NUMRDPT-1];
wire [WIDTH-1:0] t1_doutB_sel_wire [0:NUMRDPT-1];
wire t1_fwrdB_sel_wire [0:NUMRDPT-1];
wire t1_serrB_sel_wire [0:NUMRDPT-1];
wire t1_derrB_sel_wire [0:NUMRDPT-1];
wire [BITPADR-BITVBNK-1:0] t1_padrB_sel_wire [0:NUMRDPT-1];
genvar t1r_var, t1b_var;
generate
  for (t1r_var=0; t1r_var<NUMRDPT; t1r_var=t1r_var+1) begin: t1r_loop
    for (t1b_var=0; t1b_var<NUMVBNK; t1b_var=t1b_var+1) begin: t1b_loop
      assign t1_writeA_wire[t1b_var][t1r_var] = t1_writeA >> (NUMVBNK*t1r_var+t1b_var);
      assign t1_addrA_wire[t1b_var][t1r_var] = t1_addrA >> ((NUMVBNK*t1r_var+t1b_var)*BITVROW);
      assign t1_dinA_wire[t1b_var][t1r_var] = t1_dinA >> ((NUMVBNK*t1r_var+t1b_var)*WIDTH);
      assign t1_readB_wire[t1b_var][t1r_var] = t1_readB >> (NUMVBNK*t1r_var+t1b_var);
      assign t1_addrB_wire[t1b_var][t1r_var] = t1_addrB >> ((NUMVBNK*t1r_var+t1b_var)*BITVROW);
      assign t1_doutB_wire[t1b_var][t1r_var] = t1_doutB >> ((NUMVBNK*t1r_var+t1b_var)*WIDTH);
      assign t1_fwrdB_wire[t1b_var][t1r_var] = t1_fwrdB >> (NUMVBNK*t1r_var+t1b_var);
      assign t1_serrB_wire[t1b_var][t1r_var] = t1_serrB >> (NUMVBNK*t1r_var+t1b_var);
      assign t1_derrB_wire[t1b_var][t1r_var] = t1_derrB >> (NUMVBNK*t1r_var+t1b_var);
      assign t1_padrB_wire[t1b_var][t1r_var] = t1_padrB >> ((NUMVBNK*t1r_var+t1b_var)*(BITPADR-BITVBNK));
      assign t1_doutB_sel_wire[t1r_var] = t1_doutB_wire[select_bank][t1r_var];
      assign t1_fwrdB_sel_wire[t1r_var] = t1_fwrdB_wire[select_bank][t1r_var];
      assign t1_serrB_sel_wire[t1r_var] = t1_serrB_wire[select_bank][t1r_var];
      assign t1_derrB_sel_wire[t1r_var] = t1_derrB_wire[select_bank][t1r_var];
      assign t1_padrB_sel_wire[t1r_var] = t1_padrB_wire[select_bank][t1r_var];
    end
  end
endgenerate

wire t2_writeA_wire [0:NUMVBNK-1][0:NUMDQPT-1];
wire [BITVROW-1:0] t2_addrA_wire [0:NUMVBNK-1][0:NUMDQPT-1];
wire [BITVROW-1:0] t2_dinA_wire [0:NUMVBNK-1][0:NUMDQPT-1];
wire t2_readB_wire [0:NUMVBNK-1][0:NUMDQPT-1];
wire [BITVROW-1:0] t2_addrB_wire [0:NUMVBNK-1][0:NUMDQPT-1];
wire [BITVROW-1:0] t2_doutB_wire [0:NUMVBNK-1][0:NUMDQPT-1];
genvar t2r_var, t2b_var;
generate
  for (t2r_var=0; t2r_var<NUMDQPT; t2r_var=t2r_var+1) begin: t2r_loop
    for (t2b_var=0; t2b_var<NUMVBNK; t2b_var=t2b_var+1) begin: t2b_loop
      assign t2_writeA_wire[t2b_var][t2r_var] = t2_writeA >> (NUMVBNK*t2r_var+t2b_var);
      assign t2_addrA_wire[t2b_var][t2r_var] = t2_addrA >> ((NUMVBNK*t2r_var+t2b_var)*BITVROW);
      assign t2_dinA_wire[t2b_var][t2r_var] = t2_dinA >> ((NUMVBNK*t2r_var+t2b_var)*BITVROW);
      assign t2_readB_wire[t2b_var][t2r_var] = t2_readB >> (NUMVBNK*t2r_var+t2b_var);
      assign t2_addrB_wire[t2b_var][t2r_var] = t2_addrB >> ((NUMVBNK*t2r_var+t2b_var)*BITVROW);
      assign t2_doutB_wire[t2b_var][t2r_var] = t2_doutB >> ((NUMVBNK*t2r_var+t2b_var)*BITVROW); 
    end
  end
endgenerate

reg pmeminv;
reg pmem;
always @(posedge clk)
  if (rst)
    pmeminv <= 1'b1;
  else if (t1_writeA_wire[select_bank][0] && (t1_addrA_wire[select_bank][0] == select_vrow)) begin
    pmeminv <= 1'b0;
    pmem <= t1_dinA_wire[select_bank][0][select_bit];
  end

genvar pdor_var;
generate for (pdor_var=0; pdor_var<NUMRDPT; pdor_var=pdor_var+1) begin: pdor_loop
  assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire[select_bank][pdor_var] && (t1_addrB_wire[select_bank][pdor_var] == select_vrow)) |-> ##DRAM_DELAY
                                       ($past(pmeminv,DRAM_DELAY) ||
                                        (!t1_fwrdB_sel_wire[pdor_var] && ((ENAEXT && ENAPAR) ? t1_serrB_sel_wire[pdor_var] :
                                                                      (ENAEXT && ENAECC) ? t1_derrB_sel_wire[pdor_var] : 0)) ||
                                        (t1_doutB_sel_wire[pdor_var][select_bit] == $past(pmem,DRAM_DELAY))));
end
endgenerate

reg [BITVROW-1:0] lmem [0:NUMVROW-1];
integer lmem_int;
always @(posedge clk)
  if (t2_writeA_wire[select_bank][0])
      lmem[t2_addrA_wire[select_bank][0]] <= t2_dinA_wire[select_bank][0];

genvar ldor_var;
generate for (ldor_var=0; ldor_var<NUMDQPT; ldor_var=ldor_var+1) begin: ldor_loop
  assert_sdout_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire[select_bank][ldor_var] |-> ##SRAM_DELAY
                                       t2_doutB_wire[select_bank][ldor_var] == $past(lmem[t2_addrB_wire[select_bank][ldor_var]],SRAM_DELAY));
end
endgenerate

reg [BITVROW:0] freecnt [0:NUMVBNK-1];
integer free_int;
always @(posedge clk)
  for (free_int=0; free_int<NUMVBNK; free_int=free_int+1)
    if (!ready)
      freecnt[free_int] <= NUMVROW;
    else
      freecnt[free_int] <= freecnt[free_int] + (read_wire[0] && rd_deq_wire[0] && (rd_badr_wire[0]==free_int) && (rd_adr_wire[0]<NUMADDR)) - core.new_enq[free_int];

genvar new_var, newx_var;
generate for (new_var=0; new_var<NUMWRPT; new_var=new_var+1) begin: new_loop
  assert_new_bank_check: assert property (@(posedge clk) disable iff (rst) (core.new_vld[new_var] && (core.new_bnk[new_var]==select_bank)) |->
                                          core.vwrite_wire[new_var] && $past(freecnt[select_bank]>NUMSBFL+1)); //core.free_pivot_init[select_bank]);
end
endgenerate
genvar newe_var;
generate for (newe_var=0; newe_var<NUMVBNK; newe_var=newe_var+1) begin: free_loop
  assert_rd_freecnt_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] && (rd_badr_wire[0]==newe_var)) |-> (freecnt[newe_var] < NUMVROW));
//  assert_new_enq_check: assert property (@(posedge clk) disable iff (rst) core.new_enq[newe_var] |-> $past(freecnt[newe_var]>NUMSBFL+1));
end
endgenerate

//assert_new_same_check: assert property (@(posedge clk) disable iff (rst)
//                                        !(core.new_vld[0] && (core.new_bnk[0]==select_bank) &&
//                                          core.new_vld[1] && (core.new_bnk[1]==select_bank)));

reg malloc_flag [0:NUMVROW-1];
integer malp_int, malr_int; 
always @(posedge clk)
  if (rst)
    for (malr_int=0; malr_int<NUMVROW; malr_int=malr_int+1)
      malloc_flag[malr_int] <= 1'b0;
  else begin
    for (malp_int=0; malp_int<NUMDQPT; malp_int=malp_int+1)
      if (dq_vld_wire[malp_int] && (dq_badr_wire[malp_int] == select_bank)) 
        malloc_flag[dq_radr_wire[malp_int]] <= 1'b0; 
    if (core.new_enq[select_bank])
      malloc_flag[core.new_radr[select_bank]] <= 1'b1; 
  end

reg read_reg [0:NUMRDPT-1];
reg [BITVBNK-1:0] rd_badr_reg [0:NUMRDPT-1];
reg [BITVROW-1:0] rd_radr_reg [0:NUMRDPT-1];
reg dq_vld_reg [0:NUMDQPT-1];
reg [BITVBNK-1:0] dq_badr_reg [0:NUMDQPT-1];
reg [BITVROW-1:0] dq_radr_reg [0:NUMDQPT-1];
integer rdd_int;
always @(posedge clk) begin
  for (rdd_int=0; rdd_int<NUMRDPT; rdd_int=rdd_int+1) begin
    read_reg[rdd_int] <= read_wire[rdd_int] && ready;
    rd_badr_reg[rdd_int] <= rd_badr_wire[rdd_int];
    rd_radr_reg[rdd_int] <= rd_radr_wire[rdd_int];
  end
  for (rdd_int=0; rdd_int<NUMDQPT; rdd_int=rdd_int+1) begin
    dq_reg[rdd_int] <= dq_vld_wire[rdd_int] && ready;
    dq_badr_reg[rdd_int] <= dq_badr_wire[rdd_int];
    dq_radr_reg[rdd_int] <= dq_radr_wire[rdd_int];
  end
end

reg salloc_flag [0:NUMVROW-1];
integer salp_int, salb_int, salr_int;
always @(posedge clk)
  if (rst)
    for (salr_int=0; salr_int<NUMVROW; salr_int=salr_int+1)
      salloc_flag[salr_int] <= (salr_int<NUMSBFL);
  else begin
    for (salp_int=0; salp_int<NUMRDPT; salp_int=salp_int+1)
      if (dq_vld_reg && (dq_badr_reg[salp_int] == select_bank)) 
        salloc_flag[dq_radr_reg[salp_int]] <= 1'b0; 
    for (salb_int=0; salb_int<NUMVBNK; salb_int=salb_int+1)
      if (core.new_enq_reg[select_bank][SRAM_DELAY-1])
        salloc_flag[t2_doutB_wire[select_bank][0]] <= 1'b1; 
  end

wire salloc_flag_0 = salloc_flag[0];
wire salloc_flag_1 = salloc_flag[1];
wire salloc_flag_2 = salloc_flag[2];
wire salloc_flag_3 = salloc_flag[3];
wire read_wire_0 = read_wire[0];
wire [BITVBNK-1:0] rd_badr_wire_0 = rd_badr_wire[0];
wire [BITVROW-1:0] rd_radr_wire_0 = rd_radr_wire[0];
wire [BITVROW-1:0] t2_doutB_wire_0_0 = t2_doutB_wire[0][0];

genvar malc_var;
generate if (1) begin: malc_loop
  for (malc_var=0; malc_var<NUMRDPT; malc_var=malc_var+1) begin: malr_loop
    assert_rd_malloc_check: assert property (@(posedge clk) disable iff (rst) (read_wire[malc_var] && (rd_badr_wire[malc_var] == select_bank)) |->
                                             malloc_flag[rd_radr_wire[malc_var]]);
    assert_rd_salloc_check: assert property (@(posedge clk) disable iff (rst) (read_wire[malc_var] && (rd_badr_wire[malc_var] == select_bank)) |-> ##SRAM_DELAY
                                             salloc_flag[$past(rd_radr_wire[malc_var],SRAM_DELAY)] &&
                                             (core.freehead[0][select_bank] != $past(rd_radr_wire[malc_var],SRAM_DELAY)) &&
                                             (core.freehead[1][select_bank] != $past(rd_radr_wire[malc_var],SRAM_DELAY)));
  end
  for (malc_var=0; malc_var<NUMWRPT; malc_var=malc_var+1) begin: malw_loop
    assert_wr_malloc_check: assert property (@(posedge clk) disable iff (rst) (write_reg[malc_var] && (wr_adr_wire[malc_var] == select_addr)) |-> !malloc_flag[select_vrow]);
  end
end
endgenerate

assert_wr_malloc_missing_check: assert property (@(posedge clk) disable iff (rst) core.new_enq[select_bank] |-> !malloc_flag[core.new_radr[select_bank]]);

// Create counter and show that wr_bp is set properly

reg [BITVROW-1:0] linker;
always @(posedge clk)
  if (t2_writeA_wire[select_bank][0] && (t2_dinA_wire[select_bank][0] == select_vrow))
    linker <= t2_addrA_wire[select_bank][0];
 
genvar sdob_var, sdor_var, sdop_var;
generate
  for (sdor_var=0; sdor_var<NUMRDPT; sdor_var=sdor_var+1) begin: sdor_loop
    for (sdob_var=0; sdob_var<NUMVBNK; sdob_var=sdob_var+1) begin: sdob_loop
      assert_sdout_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire[sdob_var][sdor_var] |-> ##SRAM_DELAY
                                                 (t2_doutB_wire[sdob_var][sdor_var] < NUMVROW));
//      assert_sdout_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[select_bank][sdor_var] && (t2_addrB_wire[select_bank][sdor_var] == linker)) |-> ##SRAM_DELAY
//                                           ($past(malloc_flag) || (t2_doutB_wire[select_bank][sdor_var] == select_vrow)));
//      assert_sdout_next_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[sdob_var][sdor_var] && (t2_addrB_wire[sdob_var][sdor_var] == select_vrow)) |-> ##SRAM_DELAY
//                                                !salloc_flag[sdob_var][t2_doutB_wire[sdob_var][sdor_var]]);
//      assert_sdout_head_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire[sdob_var][sdor_var] |-> ##SRAM_DELAY
//                                                ((t2_doutB_wire[sdob_var][sdor_var] != select_vrow) || !salloc_flag[sdob_var][select_vrow]));
//      assert_sdout_tail_check: assert property (@(posedge clk) disable iff (!ready) 1'b1 |-> ##1
//                                                !(t2_writeA_wire[sdob_var][sdor_var] && (t2_dinA_wire[sdob_var][sdor_var] == select_vrow)) || $past(salloc_flag[sdob_var][select_vrow]));
//      assert_sdout_malloc_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire[sdob_var][sdor_var] |-> ##SRAM_DELAY
//                                                  ((t2_doutB_wire[sdob_var][sdor_var] != select_vrow) ||
//                                                   (!malloc_flag[sdob_var][select_vrow] && (core.freehead[0][sdob_var] != select_vrow) && 
//                                                                                           (core.freehead[1][sdob_var] != select_vrow))));
//      for (sdop_var=0; sdop_var<NUMSBFL; sdop_var=sdop_var+1) begin: sdop_loop
//        assert_free_head_check: assert property (@(posedge clk) disable iff (rst)
//                                                 (core.freehead[sdop_var][sdob_var] != select_vrow) || salloc_flag[sdob_var][select_vrow]);
//        assert_free_tail_check: assert property (@(posedge clk) disable iff (rst)
//                                                 (core.freetail[sdop_var][sdob_var] != select_vrow) ||
//                                                 ((core.freehead[sdop_var][sdob_var] == select_vrow) && salloc_flag[sdob_var][select_vrow]) ||
//                                                 !salloc_flag[sdob_var][select_vrow]);
//        assert_free_head_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##SRAM_DELAY
//                                                 salloc_flag[sdob_var][core.freehead[sdop_var][sdob_var]]);
//        assert_free_tail_check: assert property (@(posedge clk) disable iff (rst)
//                                                 (core.freehead[sdop_var][sdob_var] == core.freetail[sdop_var][sdob_var]) ?
//                                                  salloc_flag[sdob_var][core.freetail[sdop_var][sdob_var]] :
//                                                  !salloc_flag[sdob_var][core.freetail[sdop_var][sdob_var]]);
//      end
//      assert_free_diff_check: assert property (@(posedge clk) disable iff (rst)
//                                               (core.freehead[0][sdob_var] != core.freehead[1][sdob_var]));
   end
   assert_sdout_range_bank_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire[select_bank][sdor_var] |-> ##SRAM_DELAY
                                                   (t2_doutB_wire[select_bank][sdor_var] < NUMVROW));
   assert_sdout_head_bank_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire[select_bank][sdor_var] |-> ##SRAM_DELAY
                                                  ((t2_doutB_wire[select_bank][sdor_var] != select_vrow) || !salloc_flag[select_vrow]));
   assert_sdout_salloc_bank_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire[select_bank][sdor_var] |-> ##SRAM_DELAY
                                                    !salloc_flag[t2_doutB_wire[select_bank][sdor_var]]);
   for (sdop_var=0; sdop_var<NUMSBFL; sdop_var=sdop_var+1) begin: sdop_loop
     assert_free_head_bank_check: assert property (@(posedge clk) disable iff (rst) salloc_flag[core.freehead[sdop_var][select_bank]]);
   end
   assert_sdout_malloc_bank_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire[select_bank][sdor_var] |-> ##SRAM_DELAY
                                                    !malloc_flag[t2_doutB_wire[select_bank][sdor_var]] &&
                                                    (core.freehead[0][select_bank] != t2_doutB_wire[select_bank][sdor_var]) &&
                                                    (core.freehead[0][select_bank] != t2_doutB_wire[select_bank][sdor_var]));
  end
endgenerate

reg fakememinv;
reg fakemem;
integer fake_int;
always @(posedge clk)
  if (rst)
    fakememinv <= 1'b1;
  else for (fake_int=0; fake_int<NUMWRPT; fake_int=fake_int+1)
    if (write_reg[fake_int] && (wr_adr_wire[fake_int] == select_addr)) begin
      fakememinv <= 1'b0;
      fakemem <= din_reg[fake_int][select_bit];
    end

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> (fakememinv || (fakemem == pmem)));

genvar dout_var;
generate for (dout_var=0; dout_var<NUMRDPT; dout_var=dout_var+1) begin: dout_loop
  assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var] == select_addr)) |-> ##(DRAM_DELAY+FLOPOUT+1)
                                      (rd_vld_wire[dout_var] &&
                                       (fakememinv || (!rd_fwrd_wire[dout_var] && ((ENAEXT && ENAPAR) ? rd_serr_wire[dout_var] :
                                                                                   (ENAEXT && ENAECC) ? rd_derr_wire[dout_var] : 1'b0)) ||
                                        (rd_dout_wire[dout_var][select_bit] == fakemem))));
  assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var] == select_addr)) |-> ##(DRAM_DELAY+FLOPOUT+1)
                                      ($past(fakememinv,DRAM_DELAY+FLOPOUT+1) ||
                                       (rd_fwrd_wire[dout_var] == (FLOPOUT ? $past(t1_fwrdB_sel_wire[dout_var]) : t1_fwrdB_sel_wire[dout_var]))));
  assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var] == select_addr)) |-> ##(DRAM_DELAY+FLOPOUT+1)
                                      (rd_serr_wire[dout_var] == (FLOPOUT ? $past(t1_serrB_sel_wire[dout_var]) : t1_serrB_sel_wire[dout_var])) && 
                                      (rd_derr_wire[dout_var] == (FLOPOUT ? $past(t1_derrB_sel_wire[dout_var]) : t1_derrB_sel_wire[dout_var])));
  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var] == select_addr)) |-> ##(DRAM_DELAY+FLOPOUT+1)
                                      (rd_padr_wire[dout_var] == ((select_bank << (BITPADR-BITVBNK)) | 
                                                                  (FLOPOUT ? $past(t1_padrB_sel_wire[dout_var]) : t1_padrB_sel_wire[dout_var]))));
end
endgenerate
*/
endmodule

