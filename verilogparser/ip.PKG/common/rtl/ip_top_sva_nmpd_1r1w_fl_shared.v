module ip_top_sva_2_nmpd_1r1w_fl_shared
  #(
parameter     ENAEXT  = 0,
parameter     ENAPAR  = 0,
parameter     ENAECC  = 0,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMMAPT = 2,
parameter     NUMDQPT = 2,
parameter     NUMEGPT = 2,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     NUMGRPW = 13,
parameter     SRAM_DELAY = 2,
parameter     DRAM_DELAY = 2
   )
(
  input clk,
  input rst,
  input ready,
  input ena_rand,
  input [BITVROW:0] bp_thr,
  input [NUMMAPT*NUMVBNK-1:0] grpmsk,
  input [NUMMAPT*NUMVBNK-1:0] grpbp,
  input [NUMMAPT-1:0] malloc,
  input [NUMMAPT-1:0] ma_vld,
  input [NUMMAPT*BITADDR-1:0] ma_adr,
  input [NUMMAPT-1:0] ma_bp,
  input [NUMDQPT-1:0] dq_vld,
  input [NUMDQPT*BITADDR-1:0] dq_adr,
  input [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_writeA,
  input [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_addrA,
  input [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_readB,
  input [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_addrB
);

reg grpmsk_start;
reg grpmsk_flag;
reg grpbp_start;
reg grpbp_flag;
integer grpf_int;
always_comb begin
  grpmsk_start = 0;
  grpmsk_flag = 0;
  grpbp_start = 0;
  grpbp_flag = 0;
  for (grpf_int=NUMVBNK-1; grpf_int>=0; grpf_int=grpf_int-1) begin
    if (grpmsk_start && !grpmsk[grpf_int])
      grpmsk_flag = 1;
    if (grpmsk[grpf_int])
      grpmsk_start = 1;
    if (grpbp_start && !grpbp[grpf_int])
      grpbp_flag = 1;
    if (grpbp[grpf_int])
      grpbp_start = 1;
  end
end

assume_grpbp_less_check: assert property (@(posedge clk) disable iff (rst) (grpbp==(grpmsk & grpbp)));
assume_grpmsk_cont_check: assert property (@(posedge clk) disable iff (rst) !grpmsk_flag);
assume_grpbp_cont_check: assert property (@(posedge clk) disable iff (rst) !grpbp_flag);
assume_grpmsk_stable: assert property (@(posedge clk) disable iff (rst) $stable(grpmsk));
assume_grpbp_stable: assert property (@(posedge clk) disable iff (rst) $stable(grpbp));
assume_ena_rand_stable: assert property (@(posedge clk) disable iff (rst) $stable(ena_rand));

reg [256-1:0] ma_bp_reg;
always @(posedge clk)
  ma_bp_reg <= (ma_bp_reg << 1) | ma_bp[0];

wire [256-1:0] ma_bp_int = {ma_bp_reg,ma_bp[0]};

reg [BITVROW:0] num_cells [0:NUMMAPT-1];
integer num_int;
always @(posedge clk)
  for (num_int=0; num_int<NUMMAPT; num_int=num_int+1) begin
    if (!ready)
      num_cells[num_int] <= 0;
    else if (!ma_bp[num_int])
      num_cells[num_int] <= bp_thr;
    else if (malloc[num_int] && |num_cells[num_int])
      num_cells[num_int] <= num_cells[num_int] - 1;
  end

reg [BITVBNK+BITVROW:0] bp_cells [0:NUMEGPT-1];
reg [BITVBNK+BITVROW:0] bp_cells_nxt [0:NUMEGPT-1];
integer bpe_int, bpx_int;
always_comb
  for (bpe_int=0; bpe_int<NUMEGPT; bpe_int=bpe_int+1) begin
    bp_cells_nxt[bpe_int] = bp_cells[bpe_int];
    for (bpx_int=0; bpx_int<NUMEGPT; bpx_int=bpx_int+1)
      if (malloc[bpe_int*NUMEGPT+bpx_int])
        bp_cells_nxt[bpe_int] = bp_cells_nxt[bpe_int]-1;
  end

reg [BITVBNK:0] grpcnt [0:NUMEGPT-1];
integer grp_int, gre_int;
always_comb
  for (gre_int=0; gre_int<NUMEGPT; gre_int=gre_int+1) begin
    grpcnt[gre_int]=0;
    for (grp_int=0; grp_int<NUMVBNK; grp_int=grp_int+1)
      if (grpbp[gre_int*NUMVBNK+grp_int])
        grpcnt[gre_int]=grpcnt[gre_int]+1;
  end

integer bpc_int;
always @(posedge clk)
  for (bpc_int=0; bpc_int<NUMEGPT; bpc_int=bpc_int+1)
    if (!ready)
      bp_cells[bpc_int] <= 0;
    else if (!ma_bp[bpc_int*NUMEGPT])
      bp_cells[bpc_int] <= ena_rand ? bp_thr*grpcnt[bpc_int] : bp_thr*NUMMAPT;
    else
      bp_cells[bpc_int] <= bp_cells_nxt[bpc_int]; 

reg [BITVBNK+BITVROW:0] bp_cells_wire [0:NUMMAPT-1];
integer bpw_int, bpy_int;
always_comb
  for (bpw_int=0; bpw_int<NUMEGPT; bpw_int=bpw_int+1)
    for (bpy_int=0; bpy_int<NUMEGPT; bpy_int=bpy_int+1)
      bp_cells_wire[bpw_int*NUMEGPT+bpy_int] = bp_cells[bpw_int];

genvar ma_var;
generate
  for (ma_var=0; ma_var<NUMMAPT; ma_var=ma_var+1) begin: ma_loop
    wire malloc_wire = malloc >> ma_var;
    wire ma_vld_wire = ma_vld >> ma_var;
    wire [BITADDR-1:0] ma_adr_wire = ma_adr >> (ma_var*BITADDR);
    wire ma_bp_wire = ma_bp >> ma_bp;

    assert_ma_range_check: assert property (@(posedge clk) disable iff (!ready) ma_vld_wire |-> (ma_adr_wire < NUMADDR));
//    assert_ma_bp_check: assert property (@(posedge clk) disable iff (!ready) ma_bp_int[bp_thr] |-> !malloc_wire);
//    assert_ma_bp_check: assert property (@(posedge clk) disable iff (!ready) !(malloc_wire && ma_bp && (num_cells[ma_var]==0)));
    assert_ma_bp_check: assert property (@(posedge clk) disable iff (!ready) !(malloc_wire && ma_bp_wire && ((bp_cells[ma_var]==0) || bp_cells_nxt[ma_var][BITVBNK+BITVROW])));
  end
endgenerate

genvar dq_var;
generate
  for (dq_var=0; dq_var<NUMDQPT; dq_var=dq_var+1) begin: dq_loop
    wire dq_vld_wire = dq_vld >> dq_var;
    wire [BITADDR-1:0] dq_adr_wire = dq_adr >> (dq_var*BITADDR);

    assert_dq_range_check: assert property (@(posedge clk) disable iff (!ready) dq_vld_wire |-> (dq_adr_wire < NUMADDR));
  end
endgenerate
/*
genvar t1r_var, t1b_var;
generate
  for (t1r_var=0; t1r_var<NUMGRPW; t1r_var=t1r_var+1) begin: t1r_loop
    for (t1b_var=0; t1b_var<NUMVBNK; t1b_var=t1b_var+1) begin: t1b_loop
      wire t1_writeA_wire = t1_writeA >> (t1b_var*NUMGRPW+t1r_var);
      wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> ((t1b_var*NUMGRPW+t1r_var)*BITVROW);
      wire [GRPWDTH-1:0] t1_dinA_wire = t1_dinA >> ((t1b_var*NUMGRPW+t1r_var)*GRPWDTH);

      wire t1_readB_wire = t1_readB >> (t1b_var*NUMGRPW+t1r_var);
      wire [BITVROW-1:0] t1_addrB_wire = t1_addrB >> ((t1b_var*NUMGRPW+t1r_var)*BITVROW);

      wire t1_writeA_0_wire = t1_writeA >> t1b_var*NUMGRPW;
      wire [BITVROW-1:0] t1_addrA_0_wire = t1_addrA >> (t1b_var*NUMGRPW*BITVROW);
      wire [GRPWDTH-1:0] t1_dinA_0_wire = t1_dinA >> (t1b_var*NUMGRPW*GRPWDTH);

      assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMVROW));
      assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> (t1_addrB_wire < NUMVROW));
      assert_t1_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire && t1_writeA_wire) |-> (t1_addrB_wire != t1_addrA_wire));
//      assert_t1_wr_same_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |->
//                                                (t1_writeA_0_wire && (t1_addrA_0_wire == t1_addrA_wire) && (t1_dinA_0_wire == t1_dinA_wire)));
    end
  end
endgenerate
*/
genvar t2r_var, t2b_var;
generate
  for (t2r_var=0; t2r_var<(NUMDQPT/NUMEGPT); t2r_var=t2r_var+1) begin: t2r_loop
    for (t2b_var=0; t2b_var<NUMVBNK; t2b_var=t2b_var+1) begin: t2b_loop
      wire t2_writeA_wire = t2_writeA >> (t2r_var*NUMVBNK+t2b_var);
      wire [BITVROW-1:0] t2_addrA_wire = t2_addrA >> ((t2r_var*NUMVBNK+t2b_var)*BITVROW);

      wire t2_readB_wire = t2_readB >> (t2r_var*NUMVBNK+t2b_var);
      wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> ((t2r_var*NUMVBNK+t2b_var)*BITVROW);

      assert_t2_rw_check: assert property (@(posedge clk) disable iff (rst) !(t2_writeA_wire && t2_readB_wire));
      assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_addrA_wire < NUMVROW));
      assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire |-> (t2_addrB_wire < NUMVROW));
      assert_t2_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire && t2_writeA_wire) |-> (t2_addrB_wire != t2_addrA_wire));
    end
  end
endgenerate

endmodule


module ip_top_sva_nmpd_1r1w_fl_shared
  #(
parameter     ENAEXT  = 0,
parameter     ENAPAR  = 0,
parameter     ENAECC  = 0,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMMAPT = 2,
parameter     NUMDQPT = 2,
parameter     NUMEGPT = 2,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     NUMGRPW = 13,
parameter     NUMGRPC = 4,
parameter     SRAM_DELAY = 2,
parameter     DRAM_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0,
parameter     NUMSBFL = SRAM_DELAY+1,
parameter     NUMFPAD = 4,
parameter     FIFOCNT = 32
   )
(
  input clk,
  input rst,
  input ready,
  input [NUMMAPT*NUMVBNK-1:0] grpmsk,
  input [NUMMAPT-1:0] malloc,
  input [NUMMAPT-1:0] ma_vld,
  input [NUMMAPT*BITADDR-1:0] ma_adr,
  input [NUMMAPT-1:0] ma_fwrd,
  input [NUMMAPT-1:0] ma_serr,
  input [NUMMAPT-1:0] ma_derr,
  input [NUMMAPT*(BITVROW+1)-1:0] ma_padr,
  input [NUMDQPT-1:0] dq_vld,
  input [NUMDQPT*BITADDR-1:0] dq_adr,
  input [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_writeA,
  input [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_addrA,
  input [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_dinA,
  input [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_readB,
  input [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_addrB,
  input [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_doutB,
  input [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_fwrdB,
  input [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_serrB,
  input [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_derrB,
  input [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_padrB,
  input [BITADDR-1:0] select_addr
);

wire [BITVBNK-1:0] select_bank;
wire [BITVROW-1:0] select_vrow;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  badr_inst (.vbadr(select_bank), .vradr(select_vrow), .vaddr(select_addr));

wire malloc_wire [0:NUMMAPT-1];
wire ma_vld_wire [0:NUMMAPT-1];
wire [BITADDR-1:0] ma_adr_wire [0:NUMMAPT-1];
wire [BITVBNK-1:0] ma_badr_wire [0:NUMMAPT-1];
wire [BITVROW-1:0] ma_radr_wire [0:NUMMAPT-1];
wire ma_fwrd_wire [0:NUMMAPT-1];
wire ma_serr_wire [0:NUMMAPT-1];
wire ma_derr_wire [0:NUMMAPT-1];
wire [BITVROW:0] ma_padr_wire [0:NUMMAPT-1];
wire dq_vld_wire [0:NUMDQPT-1];
wire [BITADDR-1:0] dq_adr_wire [0:NUMDQPT-1];
wire [BITVBNK-1:0] dq_badr_wire [0:NUMDQPT-1];
wire [BITVROW-1:0] dq_radr_wire [0:NUMDQPT-1];
genvar prt_var;
generate if (1) begin: prt_loop
  for (prt_var=0; prt_var<NUMMAPT; prt_var=prt_var+1) begin: ma_loop
    assign malloc_wire[prt_var] = malloc >> prt_var;
    assign ma_vld_wire[prt_var] = ma_vld >> prt_var;
    assign ma_adr_wire[prt_var] = ma_adr >> (prt_var*BITADDR);
    assign ma_fwrd_wire[prt_var] = ma_fwrd >> prt_var;
    assign ma_serr_wire[prt_var] = ma_serr >> prt_var;
    assign ma_derr_wire[prt_var] = ma_derr >> prt_var;
    assign ma_padr_wire[prt_var] = ma_padr >> (prt_var*(BITVROW+1));
    np2_addr #(
      .NUMADDR (NUMADDR), .BITADDR (BITADDR),
      .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
      .NUMVROW (NUMVROW), .BITVROW (BITVROW))
      ma_badr_inst (.vbadr(ma_badr_wire[prt_var]), .vradr(ma_radr_wire[prt_var]), .vaddr(ma_adr_wire[prt_var]));
  end
  for (prt_var=0; prt_var<NUMDQPT; prt_var=prt_var+1) begin: dq_loop
    assign dq_vld_wire[prt_var] = dq_vld >> prt_var;
    assign dq_adr_wire[prt_var] = dq_adr >> (prt_var*BITADDR);
    np2_addr #(
      .NUMADDR (NUMADDR), .BITADDR (BITADDR),
      .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
      .NUMVROW (NUMVROW), .BITVROW (BITVROW))
      dq_badr_inst (.vbadr(dq_badr_wire[prt_var]), .vradr(dq_radr_wire[prt_var]), .vaddr(dq_adr_wire[prt_var]));
  end
end
endgenerate

reg malloc_reg [0:NUMMAPT-1][0:FLOPIN+SRAM_DELAY+FLOPOUT];
genvar malr_var, mald_var;
generate
  for (malr_var=0; malr_var<NUMMAPT; malr_var=malr_var+1) begin: malr_loop
    for (mald_var=0; mald_var<=FLOPIN+SRAM_DELAY+FLOPOUT; mald_var=mald_var+1) begin: mald_loop
      if (mald_var>0) begin: flp_loop
        always @(posedge clk) begin
          malloc_reg[malr_var][mald_var] <= malloc_reg[malr_var][mald_var-1];
        end
      end else begin: nflp_loop
        always_comb begin
          malloc_reg[malr_var][mald_var] = malloc_wire[malr_var] && ready;
        end
      end
    end
  end
endgenerate

reg malloc_del [0:NUMMAPT-1];
reg ma_vld_del [0:NUMMAPT-1];
reg [BITADDR-1:0] ma_adr_del [0:NUMMAPT-1];
reg [BITVBNK-1:0] ma_badr_del [0:NUMMAPT-1];
reg [BITVROW-1:0] ma_radr_del [0:NUMMAPT-1];
integer madl_int;
always @(posedge clk)
  for (madl_int=0; madl_int<NUMMAPT; madl_int=madl_int+1) begin
    malloc_del[madl_int] <= malloc_reg[madl_int][FLOPIN+FLOPOUT];
    ma_vld_del[madl_int] <= ma_vld_wire[madl_int];
    ma_adr_del[madl_int] <= ma_adr_wire[madl_int];
    ma_badr_del[madl_int] <= ma_badr_wire[madl_int];
    ma_radr_del[madl_int] <= ma_radr_wire[madl_int];
  end

/*wire t1_writeA_wire [0:NUMVBNK-1][0:NUMGRPW-1];
wire [BITVROW-1:0] t1_addrA_wire [0:NUMVBNK-1][0:NUMGRPW-1];
wire [GRPWDTH-1:0] t1_dinA_wire [0:NUMVBNK-1][0:NUMGRPW-1];
wire t1_readB_wire [0:NUMVBNK-1][0:NUMGRPW-1];
wire [BITVROW-1:0] t1_addrB_wire [0:NUMVBNK-1][0:NUMGRPW-1];

genvar t1r_var, t1b_var;
generate
  for (t1r_var=0; t1r_var<NUMGRPW; t1r_var=t1r_var+1) begin: t1r_loop
    for (t1b_var=0; t1b_var<NUMVBNK; t1b_var=t1b_var+1) begin: t1b_loop
      assign t1_writeA_wire[t1b_var][t1r_var] = t1_writeA >> (NUMGRPW*t1b_var+t1r_var);
      assign t1_addrA_wire[t1b_var][t1r_var] = t1_addrA >> ((NUMGRPW*t1b_var+t1r_var)*BITVROW);
      assign t1_dinA_wire[t1b_var][t1r_var] = t1_dinA >> ((NUMGRPW*t1b_var+t1r_var)*GRPWDTH);
      assign t1_readB_wire[t1b_var][t1r_var] = t1_readB >> (NUMGRPW*t1b_var+t1r_var);
      assign t1_addrB_wire[t1b_var][t1r_var] = t1_addrB >> ((NUMGRPW*t1b_var+t1r_var)*BITVROW);
      assign t1_doutB_wire[t1b_var][t1r_var] = t1_doutB >> ((NUMGRPW*t1b_var+t1r_var)*GRPWDTH);
      assign t1_fwrdB_wire[t1b_var][t1r_var] = t1_fwrdB >> (NUMGRPW*t1b_var+t1r_var);
      assign t1_serrB_wire[t1b_var][t1r_var] = t1_serrB >> (NUMGRPW*t1b_var+t1r_var);
      assign t1_derrB_wire[t1b_var][t1r_var] = t1_derrB >> (NUMGRPW*t1b_var+t1r_var);
      assign t1_doutB_sel_wire[t1r_var] = t1_doutB_wire[select_bank][t1r_var];
      assign t1_fwrdB_sel_wire[t1r_var] = t1_fwrdB_wire[select_bank][t1r_var];
      assign t1_serrB_sel_wire[t1r_var] = t1_serrB_wire[select_bank][t1r_var];
      assign t1_derrB_sel_wire[t1r_var] = t1_derrB_wire[select_bank][t1r_var];
      assign t1_padrB_sel_wire[t1r_var] = t1_padrB_wire[select_bank][t1r_var];
    end
  end
endgenerate
*/
wire t2_writeA_wire [0:NUMVBNK-1][0:(NUMDQPT/NUMEGPT)-1];
wire [BITVROW-1:0] t2_addrA_wire [0:NUMVBNK-1][0:(NUMDQPT/NUMEGPT)-1];
wire [BITVROW-1:0] t2_dinA_wire [0:NUMVBNK-1][0:(NUMDQPT/NUMEGPT)-1];
wire t2_readB_wire [0:NUMVBNK-1][0:(NUMDQPT/NUMEGPT)-1];
wire [BITVROW-1:0] t2_addrB_wire [0:NUMVBNK-1][0:(NUMDQPT/NUMEGPT)-1];
wire [BITVROW-1:0] t2_doutB_wire [0:NUMVBNK-1][0:(NUMDQPT/NUMEGPT)-1];
wire t2_fwrdB_wire [0:NUMVBNK-1][0:(NUMDQPT/NUMEGPT)-1];
wire t2_serrB_wire [0:NUMVBNK-1][0:(NUMDQPT/NUMEGPT)-1];
wire t2_derrB_wire [0:NUMVBNK-1][0:(NUMDQPT/NUMEGPT)-1];
wire [BITVROW-1:0] t2_padrB_wire [0:NUMVBNK-1][0:(NUMDQPT/NUMEGPT)-1];
genvar t2r_var, t2b_var;
generate
  for (t2r_var=0; t2r_var<(NUMDQPT/NUMEGPT); t2r_var=t2r_var+1) begin: t2r_loop
    for (t2b_var=0; t2b_var<NUMVBNK; t2b_var=t2b_var+1) begin: t2b_loop
      assign t2_writeA_wire[t2b_var][t2r_var] = t2_writeA >> (NUMVBNK*t2r_var+t2b_var);
      assign t2_addrA_wire[t2b_var][t2r_var] = t2_addrA >> ((NUMVBNK*t2r_var+t2b_var)*BITVROW);
      assign t2_dinA_wire[t2b_var][t2r_var] = t2_dinA >> ((NUMVBNK*t2r_var+t2b_var)*BITVROW);
      assign t2_readB_wire[t2b_var][t2r_var] = t2_readB >> (NUMVBNK*t2r_var+t2b_var);
      assign t2_addrB_wire[t2b_var][t2r_var] = t2_addrB >> ((NUMVBNK*t2r_var+t2b_var)*BITVROW);
      assign t2_doutB_wire[t2b_var][t2r_var] = t2_doutB >> ((NUMVBNK*t2r_var+t2b_var)*BITVROW); 
      assign t2_fwrdB_wire[t2b_var][t2r_var] = t2_fwrdB >> (NUMVBNK*t2r_var+t2b_var);
      assign t2_serrB_wire[t2b_var][t2r_var] = t2_serrB >> (NUMVBNK*t2r_var+t2b_var);
      assign t2_derrB_wire[t2b_var][t2r_var] = t2_derrB >> (NUMVBNK*t2r_var+t2b_var);
      assign t2_padrB_wire[t2b_var][t2r_var] = t2_padrB >> ((NUMVBNK*t2r_var+t2b_var)*BITVROW); 
    end
  end
endgenerate

reg [BITVROW:0] fakecnt [0:NUMVBNK-1];
reg [BITVROW:0] fakecnt_nxt [0:NUMVBNK-1];
integer fakn_int, fakp_int;
always_comb
  for (fakn_int=0; fakn_int<NUMVBNK; fakn_int=fakn_int+1) begin
    fakecnt_nxt[fakn_int] = fakecnt[fakn_int];
    for (fakp_int=0; fakp_int<NUMMAPT; fakp_int=fakp_int+1)
      if (ma_vld_wire[fakp_int] && (ma_badr_wire[fakp_int] == fakn_int))
        fakecnt_nxt[fakn_int] = fakecnt_nxt[fakn_int] - 1;
    for (fakp_int=0; fakp_int<NUMDQPT; fakp_int=fakp_int+1)
      if (dq_vld_wire[fakp_int] && (dq_badr_wire[fakp_int] == fakn_int))
        fakecnt_nxt[fakn_int] = fakecnt_nxt[fakn_int] + 1;
  end

integer fako_int;
always @(posedge clk)
  for (fako_int=0; fako_int<NUMVBNK; fako_int=fako_int+1)
    if (!ready)
      fakecnt[fako_int] <= FIFOCNT;
    else
      fakecnt[fako_int] <= fakecnt_nxt[fako_int];

reg [BITVROW:0] fifocnt;
reg [BITVROW:0] fifocnt_nxt;
integer fifn_int, fifp_int;
always_comb
  for (fifn_int=0; fifn_int<NUMVBNK; fifn_int=fifn_int+1) begin
    fifocnt_nxt = fifocnt;
    for (fifp_int=0; fifp_int<NUMMAPT; fifp_int=fifp_int+1)
      if (ma_vld_wire[fifp_int] && (ma_badr_wire[fifp_int] == select_bank))
        fifocnt_nxt = fifocnt_nxt - 1;
    for (fifp_int=0; fifp_int<NUMDQPT; fifp_int=fifp_int+1)
      if (dq_vld_wire[fifp_int] && (dq_badr_wire[fifp_int] == select_bank))
        fifocnt_nxt = fifocnt_nxt + 1;
  end

always @(posedge clk)
  if (!ready)
    fifocnt <= 8;
  else
    fifocnt <= fifocnt_nxt;

reg [1:0] mavcnt;
integer mavc_int;
always_comb begin
  mavcnt = 0;
  for (mavc_int=0; mavc_int<NUMMAPT; mavc_int=mavc_int+1)
    if (ma_vld_wire[mavc_int] && (ma_badr_wire[mavc_int] == select_bank))
      mavcnt = mavcnt + 1;
end 

reg [5:0] deq_sel [0:NUMDQPT-1];
integer deqs_int;
always_comb
  for (deqs_int=0; deqs_int<NUMDQPT; deqs_int=deqs_int+1) begin
    if (deqs_int>0)
      deq_sel[deqs_int] = deq_sel[deqs_int-1];
    else
      deq_sel[deqs_int] = fifocnt-mavcnt-1;
    if (dq_vld_wire[deqs_int] && (dq_badr_wire[deqs_int] == select_bank))
      deq_sel[deqs_int] = deq_sel[deqs_int] + 1;
  end
  
reg [BITVROW-1:0] ptrfifo [0:FIFOCNT-1];
reg [NUMDQPT-1:0] vlpfifo [0:FIFOCNT-1];
reg [BITVROW-1:0] ptrfifo_nxt [0:FIFOCNT-1];
reg [NUMDQPT-1:0] vlpfifo_nxt[0:FIFOCNT-1];
integer ptro_int, ptrp_int;
always_comb
  for (ptro_int=0; ptro_int<FIFOCNT; ptro_int=ptro_int+1) begin
    if (!ready) begin
      if (ptro_int<4) begin
        vlpfifo_nxt[ptro_int] = {NUMDQPT{1'b1}};
        ptrfifo_nxt[ptro_int] = ptro_int;
      end else if (ptro_int<8) begin
        vlpfifo_nxt[ptro_int] = {NUMDQPT{1'b0}};
        ptrfifo_nxt[ptro_int] = NUMVROW-NUMVROW%NUMSBFL-NUMSBFL+ptro_int-4;
      end else begin
        vlpfifo_nxt[ptro_int] = {NUMDQPT{1'b0}};
        ptrfifo_nxt[ptro_int] = ptrfifo[ptro_int];
      end
    end else begin
      vlpfifo_nxt[ptro_int] = vlpfifo[ptro_int];
      ptrfifo_nxt[ptro_int] = ptrfifo[ptro_int];
      if (ptro_int<(fifocnt-mavcnt)) begin
        vlpfifo_nxt[ptro_int] = vlpfifo[ptro_int+mavcnt];
        ptrfifo_nxt[ptro_int] = ptrfifo[ptro_int+mavcnt];
      end 
      for (ptrp_int=0; ptrp_int<(NUMDQPT/NUMEGPT); ptrp_int=ptrp_int+1)
        if (t2_writeA_wire[select_bank][ptrp_int] && (t2_addrA_wire[select_bank][ptrp_int]==ptrfifo_nxt[ptro_int]))
          vlpfifo_nxt[ptro_int][ptrp_int] = 1'b1;
      if (ptro_int>=(fifocnt-mavcnt))
        for (ptrp_int=0; ptrp_int<NUMDQPT; ptrp_int=ptrp_int+1)
          if (dq_vld_wire[ptrp_int] && (dq_badr_wire[ptrp_int] == select_bank) && (ptro_int==deq_sel[ptrp_int])) begin
            vlpfifo_nxt[ptro_int] = {NUMDQPT{1'b0}};
            ptrfifo_nxt[ptro_int] = dq_radr_wire[ptrp_int];
          end
    end
  end

integer ptrf_int;
always @(posedge clk)
  for (ptrf_int=0; ptrf_int<FIFOCNT; ptrf_int=ptrf_int+1) begin
    vlpfifo[ptrf_int] <= vlpfifo_nxt[ptrf_int];
    ptrfifo[ptrf_int] <= ptrfifo_nxt[ptrf_int];
  end

reg mthr_ptrfifo [0:NUMDQPT-1];
reg mthr_vlplink [0:NUMDQPT-1];
reg [BITVROW-1:0] mthr_ptrlink [0:NUMDQPT-1];
reg mthw_ptrfifo [0:NUMDQPT-1];
reg [NUMDQPT-1:0] mthw_vlplink [0:NUMDQPT-1];
reg [BITVROW-1:0] mthw_ptrlink [0:NUMDQPT-1];
integer mthp_int, mthb_int;
always_comb begin
  for (mthp_int=0; mthp_int<NUMDQPT; mthp_int=mthp_int+1) begin
    mthr_ptrfifo[mthp_int] = 1'b0;
    mthr_vlplink[mthp_int] = 1'b0;
    mthr_ptrlink[mthp_int] = 0;
    for (mthb_int=0; mthb_int<FIFOCNT; mthb_int=mthb_int+1) begin
      if ((mthb_int<fifocnt) && (ptrfifo[mthb_int] == t2_addrB_wire[select_bank][mthp_int])) begin
        mthr_ptrfifo[mthp_int] = 1'b1;
        mthr_vlplink[mthp_int] = vlpfifo[mthb_int][mthp_int];
        mthr_ptrlink[mthp_int] = ptrfifo[mthb_int+4];
      end
    end
  end
  for (mthp_int=0; mthp_int<NUMDQPT; mthp_int=mthp_int+1) begin
    mthw_ptrfifo[mthp_int] = 1'b0;
    mthw_vlplink[mthp_int] = 0;
    mthw_ptrlink[mthp_int] = 0;
    for (mthb_int=0; mthb_int<FIFOCNT; mthb_int=mthb_int+1) begin
      if ((mthb_int<fifocnt) && (ptrfifo[mthb_int] == t2_addrA_wire[select_bank][mthp_int])) begin
        mthw_ptrfifo[mthp_int] = 1'b1;
        mthw_vlplink[mthp_int] = vlpfifo[mthb_int];
        mthw_ptrlink[mthp_int] = ptrfifo[mthb_int+4];
      end
    end
  end
end

genvar lnkr_var;
generate begin: link_loop
  for (lnkr_var=0; lnkr_var<(NUMDQPT/NUMEGPT); lnkr_var=lnkr_var+1) begin: lnkr_loop
    assert_lnkr_check: assert property (@(posedge clk) disable iff (!ready) (t2_readB_wire[select_bank][lnkr_var] && mthr_vlplink[lnkr_var] && mthr_ptrfifo[lnkr_var]) |-> ##SRAM_DELAY
                                        (t2_doutB_wire[select_bank][lnkr_var] == $past(mthr_ptrlink[lnkr_var],SRAM_DELAY)));
  end
  for (lnkr_var=0; lnkr_var<(NUMDQPT/NUMEGPT); lnkr_var=lnkr_var+1) begin: lnkw_loop
    assert_lnkw_check: assert property (@(posedge clk) disable iff (!ready) (t2_writeA_wire[select_bank][lnkr_var] && mthw_ptrfifo[lnkr_var]) |->
                                        !(|mthw_vlplink[lnkr_var]) && (t2_dinA_wire[select_bank][lnkr_var] == mthw_ptrlink[lnkr_var]));
  end
end
endgenerate

reg allo_ptr [0:NUMDQPT-1];
integer allo_int, allf_int;
always_comb
  for (allo_int=0; allo_int<NUMDQPT; allo_int=allo_int+1) begin
    allo_ptr[allo_int] = 1'b0;
    for (allf_int=0; allf_int<FIFOCNT; allf_int=allf_int+1)
      if ((allf_int<fifocnt) && dq_vld_wire[allo_int] && (dq_badr_wire[allo_int]==select_bank) && (dq_radr_wire[allo_int]==ptrfifo[allf_int]))
        allo_ptr[allo_int] = 1'b1;
  end

reg same_ptr;
integer same_int, samp_int;
always_comb begin
  same_ptr = 1'b0; 
  for (same_int=0; same_int<NUMDQPT; same_int=same_int+1)
    for (samp_int=same_int+1; samp_int<NUMDQPT; samp_int=samp_int+1)
      if (dq_vld_wire[same_int] && dq_vld_wire[samp_int] && (dq_adr_wire[same_int]==dq_adr_wire[samp_int]))
        same_ptr = 1'b1;
end

assert_dq_same_check: assert property (@(posedge clk) disable iff (rst) !same_ptr);

genvar dqa_var;
generate for (dqa_var=0; dqa_var<NUMDQPT; dqa_var=dqa_var+1) begin: dqa_loop
  assert_dq_fak_check: assert property (@(posedge clk) disable iff (!ready) !(dq_vld_wire[dqa_var] && (fakecnt_nxt[dq_badr_wire[dqa_var]] > FIFOCNT)));
  assert_dq_fif_check: assert property (@(posedge clk) disable iff (!ready) !(dq_vld_wire[dqa_var] && (fifocnt_nxt > FIFOCNT)));
  assert_dq_alp_check: assert property (@(posedge clk) disable iff (rst) (dq_vld_wire[dqa_var] && (dq_badr_wire[dqa_var]==select_bank)) |-> !allo_ptr[dqa_var]);
end
endgenerate

genvar most_var;
generate for (most_var=0; most_var<NUMVBNK; most_var=most_var+1) begin: most_loop
//  assert_mostbnk_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##((NUMVBNK/4)+1)
//                                         (core.mostbnk_tmp[most_var] == $past(core.formbnk[most_var],(NUMVBNK/4)+1)));
//  assert_mostbnk_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##(NUMVBNK+1)
//                                         (core.mostbnk_tmp[most_var] == $past(core.formbnk[most_var],NUMVBNK+1)));
  assert_mostbnk_check: assert property (@(posedge clk) disable iff (rst) (core.mostbnk_tmp[most_var]==core.formbnk[most_var]));
end
endgenerate

assert_permide_check: assert property (@(posedge clk) disable iff (rst) &core.permide_chk);
assert_perminv_check: assert property (@(posedge clk) disable iff (rst) &core.perminv_chk);
assert_permmat_check: assert property (@(posedge clk) disable iff (rst) !core.permmat_chk);
assert_permmst_check: assert property (@(posedge clk) disable iff (rst) &core.permmst_chk);

genvar free_var;
generate for (free_var=0; free_var<NUMVBNK; free_var=free_var+1) begin: free_loop
  assert_freecnt_check: assert property (@(posedge clk) disable iff (!ready) (core.freecnt[free_var] >= NUMSBFL+NUMFPAD));
end
endgenerate

assert_freecnt_sel_check: assert property (@(posedge clk) disable iff (!ready) (core.freecnt[select_bank] >= NUMSBFL+NUMFPAD));

genvar mall_var;
generate for (mall_var=0; mall_var<NUMMAPT; mall_var=mall_var+1) begin: mall_loop
//  if (mall_var>=(NUMMAPT-2)) begin: help_loop
  assert_malloc_check: assert property (@(posedge clk) disable iff (!ready) malloc_wire[mall_var] |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT) ma_vld_wire[mall_var]);
//  end
  assert_ma_grpmsk_check: assert property (@(posedge clk) disable iff (!ready) malloc_wire[mall_var] |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT) grpmsk[ma_badr_wire[mall_var]]);
  assert_ma_radr_check: assert property (@(posedge clk) disable iff (!ready) (ma_vld_wire[mall_var] && (ma_badr_wire[mall_var] == select_bank)) |->
                                         ma_radr_wire[mall_var] == ptrfifo[0]);
  assert_ma_fwrd_check: assert property (@(posedge clk) disable iff (!ready) ma_vld_wire[mall_var] |-> !ma_fwrd_wire[mall_var]);

//  assert_ma_fwrd_check: assert property (@(posedge clk) disable iff (rst) malloc_wire[mall_var] |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
//                                         ((ma_adr_wire[mall_wire] != select_addr) ||
//                                          (ma_fwrd_wire[mall_var] == (FLOPOUT ? $past(t2_fwrdB_wire[select_bank][0],FLOPOUT) : t2_fwrdB_wire[select_bank][0]))));
//  assert_ma_derr_check: assert property (@(posedge clk) disable iff (rst) malloc_wire[mall_var] |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
//                                         ((ma_adr_wire[mall_wire] != select_addr) ||
//                                          ((ma_serr_wire[mall_var] == (FLOPOUT ? $past(t2_serrB_wire[select_bank][0],FLOPOUT) : t2_serrB_wire[select_bank][0])) &&
//                                           (ma_derr_wire[mall_var] == (FLOPOUT ? $past(t2_derrB_wire[select_bank][0],FLOPOUT) : t2_derrB_wire[select_bank][0])))));
//  assert_ma_padr_check: assert property (@(posedge clk) disable iff (rst) malloc_wire[mall_var] |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
//                                         ((ma_adr_wire[mall_wire] != select_addr) ||
//                                          (ma_padr_wire[mall_var][BITVROW-1:0] == select_vrow)));
end
endgenerate

reg ma_same_bank;
reg ma_sel_addr;
integer swx_int, swy_int;
always_comb begin
  for (swx_int=0; swx_int<NUMMAPT; swx_int=swx_int+1)
    for (swy_int=swx_int+1; swy_int<NUMMAPT; swy_int=swy_int+1)
      if (ma_vld_wire[swx_int] && ma_vld_wire[swy_int] && (ma_badr_wire[swx_int] == ma_badr_wire[swy_int]))
        ma_same_bank = 1'b1;
  ma_sel_addr = 1'b0;
  for (swx_int=0; swx_int<NUMMAPT; swx_int=swx_int+1)
    if (ma_vld_wire[swx_int] && (ma_adr_wire[swx_int] == select_addr))
      ma_sel_addr = 1'b1;
end

assert_ma_pseudo_check: assert property (@(posedge clk) disable iff (!ready) !ma_same_bank);


/*reg pmeminv;
reg pmem;
always @(posedge clk)
  if (rst)
    pmeminv <= 1'b1;
  else if (t1_writeA_wire[select_bank][select_grpw] && (t1_addrA_wire[select_bank][select_grpw] == select_vrow)) begin
    pmeminv <= 1'b0;
    pmem <= t1_dinA_wire[select_bank][select_grpw][select_gbit];
  end

assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire[select_bank][select_grpw] && (t1_addrB_wire[select_bank][select_grpw] == select_vrow)) |-> ##DRAM_DELAY
 
                                     ($past(pmeminv,DRAM_DELAY) ||
                                      (t1_doutB_wire[select_bank][select_grpw][select_gbit] == $past(pmem,DRAM_DELAY))));
*/
/*
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
generate for (new_var=0; new_var<NUMMAPT; new_var=new_var+1) begin: new_loop
  assert_new_bank_check: assert property (@(posedge clk) disable iff (rst) (core.new_vld[new_var] && (core.new_bnk[new_var]==select_bank)) |->
                                          core.vwrite_wire[new_var] && $past(freecnt[select_bank]>NUMSBFL+1));
//                                          core.free_pivot_init[select_bank]);
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
  for (malc_var=0; malc_var<NUMMAPT; malc_var=malc_var+1) begin: malw_loop
    assert_wr_malloc_check: assert property (@(posedge clk) disable iff (rst) (malloc_reg[malc_var] && (wr_adr_wire[malc_var] == select_addr)) |-> !malloc_flag[select_vrow]);
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
*/
/*
reg fakememinv;
reg fakemem;
integer fake_int;
always @(posedge clk)
  if (rst)
    fakememinv <= 1'b1;
  else if (write_wire[0] && (wr_adr_wire[0] == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din_wire[0][select_bit]; 
  end else for (fake_int=0; fake_int<NUMMAPT; fake_int=fake_int+1)
    if (ma_vld_wire[fake_int] && (ma_adr_wire[fake_int] == select_addr)) begin
      fakememinv <= 1'b0;
      fakemem <= ma_din_reg[fake_int][FLOPIN+SRAM_DELAY+FLOPOUT][select_bit];
    end

//assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> (fakememinv || (fakemem == pmem)));

genvar dout_var;
generate for (dout_var=0; dout_var<NUMRDPT; dout_var=dout_var+1) begin: dout_loop
  assert_wr_dout_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var] == select_addr) && !grpmsk[rd_badr_wire[dout_var]]) |-> ##(FLOPIN+DRAM_DELAY+NUMGRPC+3+FLOPOUT)
                                         (rd_vld_wire[dout_var] &&
                                          ($past(fakememinv,FLOPIN+DRAM_DELAY+NUMGRPC+3+FLOPOUT) ||
                                           (!rd_fwrd_wire[dout_var] && ((ENAEXT && ENAPAR) ? rd_serr_wire[dout_var] :
                                                                        (ENAEXT && ENAECC) ? rd_derr_wire[dout_var] : 1'b0)) ||
                                           (rd_dout_wire[dout_var][select_bit] == $past(fakemem,FLOPIN+DRAM_DELAY+NUMGRPC+3+FLOPOUT)))));
  assert_ma_dout_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var] == select_addr) && grpmsk[rd_badr_wire[dout_var]]) |-> ##(FLOPIN+DRAM_DELAY+NUMGRPC+3+FLOPOUT)
                                         (rd_vld_wire[dout_var] &&
                                          ($past(fakememinv,FLOPIN+NUMGRPC+3+FLOPOUT) ||
                                           (!rd_fwrd_wire[dout_var] && ((ENAEXT && ENAPAR) ? rd_serr_wire[dout_var] :
                                                                        (ENAEXT && ENAECC) ? rd_derr_wire[dout_var] : 1'b0)) ||
                                           (rd_dout_wire[dout_var][select_bit] == $past(fakemem,FLOPIN+NUMGRPC+3+FLOPOUT)))));
  
 assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+NUMGRPC+3+FLOPOUT)
                                      !rd_fwrd_wire[dout_var]);
  assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+NUMGRPC+3+FLOPOUT)
                                      !rd_serr_wire[dout_var] && !rd_derr_wire[dout_var]);

//  assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var] == select_addr)) |-> ##(DRAM_DELAY+FLOPOUT+1)
//                                      ($past(fakememinv,DRAM_DELAY+FLOPOUT+1) ||
//                                       (rd_fwrd_wire[dout_var] == (FLOPOUT ? $past(t1_fwrdB_sel_wire[dout_var]) : t1_fwrdB_sel_wire[dout_var]))));
//  assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var] == select_addr)) |-> ##(DRAM_DELAY+FLOPOUT+1)
//                                      (rd_serr_wire[dout_var] == (FLOPOUT ? $past(t1_serrB_sel_wire[dout_var]) : t1_serrB_sel_wire[dout_var])) && 
//                                      (rd_derr_wire[dout_var] == (FLOPOUT ? $past(t1_derrB_sel_wire[dout_var]) : t1_derrB_sel_wire[dout_var])));

end
endgenerate
*/

endmodule

