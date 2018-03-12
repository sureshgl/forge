module ip_top_sva_2_ncor1a_1r1w
  #(
parameter     WIDTH   = 32,
parameter     NUMCTPT = 2,
parameter     BITCTPT = 1,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13
   )
(
  input clk,
  input rst,
  input [NUMCTPT-1:0] cnt,
  input [NUMCTPT*BITADDR-1:0] ct_adr,
  input read,
  input write,
  input [BITADDR-1:0]  addr,
  input [NUMCTPT-1:0] t1_writeA,
  input [NUMCTPT*BITADDR-1:0] t1_addrA,
  input [NUMCTPT-1:0] t1_readB,
  input [NUMCTPT*BITADDR-1:0] t1_addrB
);

assert_ct_rw_check: assume property (@(posedge clk) disable iff (rst) !((read || write) && |cnt));

genvar ct_int;
generate for (ct_int=0; ct_int<NUMCTPT; ct_int=ct_int+1) begin: ct_loop
  wire cnt_wire = cnt >> ct_int;
  wire [BITADDR-1:0] ct_adr_wire = ct_adr >> (ct_int*BITADDR);

  assert_ct_range_check: assert property (@(posedge clk) disable iff (rst) cnt_wire |-> (ct_adr_wire < NUMADDR));
end
endgenerate

genvar rw_int;
generate for (rw_int=0; rw_int<1; rw_int=rw_int+1) begin: rw_loop
  wire read_wire = read >> rw_int;
  wire write_wire = write >> rw_int;
  wire [BITADDR-1:0] rw_adr_wire = addr >> (rw_int*BITADDR);

  assert_rw_range_check: assert property (@(posedge clk) disable iff (rst) (read_wire || write_wire) |-> (rw_adr_wire < NUMADDR));
end
endgenerate

genvar t1_int;
generate for (t1_int=0; t1_int<NUMCTPT; t1_int=t1_int+1) begin: t1_loop
  wire t1_writeA_wire = t1_writeA >> t1_int;
  wire [BITADDR-1:0] t1_addrA_wire = t1_addrA >> (t1_int*BITADDR);

  assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMADDR));

  wire t1_readB_wire = t1_readB >> t1_int;
  wire [BITADDR-1:0] t1_addrB_wire = t1_addrB >> (t1_int*BITADDR);

  assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> (t1_addrB_wire < NUMADDR));
end
endgenerate

endmodule

module ip_top_sva_ncor1a_1r1w
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     NUMCTPT = 2,
parameter     BITCTPT = 1,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     BITPADR = 14,
parameter     SRAM_DELAY = 2,
parameter     FLOPADD = 1,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0
   )
(
  input clk,
  input rst,
  input read,
  input write,
  input [BITADDR-1:0] addr,
  input [WIDTH-1:0] din,
  input rd_vld,
  input [WIDTH-1:0] rd_dout,
  input rd_fwrd,
  input rd_serr,
  input rd_derr,
  input [BITPADR-1:0] rd_padr,
  input [NUMCTPT-1:0] cnt,
  input [NUMCTPT*BITADDR-1:0] ct_adr,
  input [NUMCTPT*WIDTH-1:0] imm,
  input [NUMCTPT-1:0] ct_vld,
  input [NUMCTPT-1:0] ct_serr,
  input [NUMCTPT-1:0] ct_derr,
  input [NUMCTPT-1:0] t1_writeA,
  input [NUMCTPT*BITADDR-1:0] t1_addrA,
  input [NUMCTPT*WIDTH-1:0] t1_dinA,
  input [NUMCTPT-1:0] t1_readB,
  input [NUMCTPT*BITADDR-1:0] t1_addrB,
  input [NUMCTPT*WIDTH-1:0] t1_doutB,
  input [NUMCTPT-1:0] t1_fwrdB,
  input [NUMCTPT-1:0] t1_serrB,
  input [NUMCTPT-1:0] t1_derrB,
  input [NUMCTPT*(BITPADR-BITCTPT)-1:0] t1_padrB,
  input [BITADDR-1:0] select_addr,
  input [BITWDTH-1:0] select_bit
);

wire cnt_wire [0:NUMCTPT-1];
wire [BITADDR-1:0] ct_adr_wire [0:NUMCTPT-1];
wire [WIDTH-1:0] imm_wire [0:NUMCTPT-1];
wire ct_vld_wire [0:NUMCTPT-1];
wire ct_serr_wire [0:NUMCTPT-1];
wire ct_derr_wire [0:NUMCTPT-1];
genvar ct_int;
generate for (ct_int=0; ct_int<NUMCTPT; ct_int=ct_int+1) begin: ct_loop
  assign cnt_wire[ct_int] = cnt >> ct_int;
  assign ct_adr_wire[ct_int] = ct_adr >> (ct_int*BITADDR);
  assign imm_wire[ct_int] = imm >> (ct_int*WIDTH);
  assign ct_vld_wire[ct_int] = ct_vld >> ct_int;
  assign ct_serr_wire[ct_int] = ct_serr >> ct_int;
  assign ct_derr_wire[ct_int] = ct_derr >> ct_int;
end
endgenerate

reg t1_writeA_wire [0:NUMCTPT-1];
reg [BITADDR-1:0] t1_addrA_wire [0:NUMCTPT-1];
reg [WIDTH-1:0] t1_dinA_wire [0:NUMCTPT-1];
reg t1_readB_wire [0:NUMCTPT-1];
reg [BITADDR-1:0] t1_addrB_wire [0:NUMCTPT-1];
reg [WIDTH-1:0] t1_doutB_wire [0:NUMCTPT-1];
reg t1_serrB_wire [0:NUMCTPT-1];
reg t1_derrB_wire [0:NUMCTPT-1];
reg [BITPADR-BITCTPT-1:0] t1_padrB_wire [0:NUMCTPT-1];
integer t1_prpt_int;
always_comb
  for (t1_prpt_int=0; t1_prpt_int<NUMCTPT; t1_prpt_int=t1_prpt_int+1) begin
    t1_writeA_wire[t1_prpt_int] = t1_writeA >> t1_prpt_int;
    t1_addrA_wire[t1_prpt_int] = t1_addrA >> (t1_prpt_int*BITADDR);
    t1_dinA_wire[t1_prpt_int] = t1_dinA >> (t1_prpt_int*WIDTH);
    t1_readB_wire[t1_prpt_int] = t1_readB >> t1_prpt_int;
    t1_doutB_wire[t1_prpt_int] = t1_doutB >> (t1_prpt_int*BITADDR);
    t1_serrB_wire[t1_prpt_int] = t1_serrB >> t1_prpt_int;
    t1_derrB_wire[t1_prpt_int] = t1_derrB >> t1_prpt_int;
    t1_padrB_wire[t1_prpt_int] = t1_padrB >> (t1_prpt_int*(BITPADR-BITCTPT));
  end

reg meminv [0:NUMCTPT-1];
reg [WIDTH-1:0] mem [0:NUMCTPT-1];
integer mem_int;
always @(posedge clk)
  for (mem_int=0; mem_int<NUMCTPT; mem_int=mem_int+1)
    if (rst)
      meminv[mem_int] <= 1'b1;
    else if (t1_writeA_wire[mem_int] && (t1_addrA_wire[mem_int] == select_addr)) begin
      meminv[mem_int] <= 1'b0;
      mem[mem_int] <= t1_dinA_wire[mem_int];
    end

wire [WIDTH-1:0] mem_0 = mem[0];

genvar t1_dout_int;
generate for (t1_dout_int=0; t1_dout_int<NUMCTPT; t1_dout_int=t1_dout_int+1) begin: pdout_loop
  wire t1_readB_wire = t1_readB >> t1_dout_int;
  wire [BITADDR-1:0] t1_addrB_wire = t1_addrB >> (t1_dout_int*BITADDR);
  wire t1_derrB_wire = t1_derrB >> t1_dout_int;
  wire [WIDTH-1:0] t1_doutB_wire = t1_doutB >> (t1_dout_int*WIDTH);

  assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire && (t1_addrB_wire == select_addr)) |-> ##SRAM_DELAY
                                       ($past(meminv[t1_dout_int],SRAM_DELAY) || t1_derrB_wire || (t1_doutB_wire == $past(mem[t1_dout_int],SRAM_DELAY))));
  assert_pdout_sel_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire && (t1_addrB_wire == select_addr)) |-> ##SRAM_DELAY
                                           ($past(meminv[t1_dout_int],SRAM_DELAY) || t1_derrB_wire ||
                                            (t1_doutB_wire[select_bit] == $past(mem[t1_dout_int][select_bit],SRAM_DELAY))));
end
endgenerate

genvar cnt_int;
generate for (cnt_int=0; cnt_int<NUMCTPT; cnt_int=cnt_int+1) begin: cnt_loop
  assert_cnt_fwd_check: assert property (@(posedge clk) disable iff (rst) (cnt_wire[cnt_int] && (ct_adr_wire[cnt_int] == select_addr)) |-> ##SRAM_DELAY
                                         (meminv[cnt_int] || t1_derrB_wire[cnt_int] || (core.cnt_out[cnt_int] == mem[cnt_int])));
  assert_rdcnt_fwd_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr)) |-> ##SRAM_DELAY
                                           (meminv[cnt_int] || t1_derrB_wire[cnt_int] || (core.rdcnt_out[cnt_int] == mem[cnt_int])));
end
endgenerate

wire [NUMCTPT-1:0] cnt_derr = 0;
genvar derr_int;
generate for (derr_int=0; derr_int<NUMCTPT; derr_int=derr_int+1) begin: derr_loop
  assume_mem_derr_check: assert property (@(posedge clk) disable iff (rst) cnt_wire[derr_int] |-> ##SRAM_DELAY
                                          ($past(cnt_derr[derr_int],SRAM_DELAY) == t1_derrB[derr_int]));
end
endgenerate

reg cntmeminv [0:NUMCTPT-1];
reg [WIDTH-1:0] cntmem [0:NUMCTPT-1];
reg [WIDTH:0] cntmem_temp [0:NUMCTPT-1];
reg cntmeminv_next [0:NUMCTPT-1];
reg [WIDTH-1:0] cntmem_next [0:NUMCTPT-1];
integer fmem_int;
always_comb
  for (fmem_int=0; fmem_int<NUMCTPT; fmem_int=fmem_int+1) begin
    cntmeminv_next[fmem_int] = cntmeminv[fmem_int];
    cntmem_next[fmem_int] = cntmem[fmem_int];
    if (cnt_wire[fmem_int] && (ct_adr_wire[fmem_int] == select_addr)) begin
      cntmeminv_next[fmem_int] = cntmeminv_next[fmem_int] || cnt_derr[fmem_int];
      cntmem_temp[fmem_int] = cntmem_next[fmem_int] + imm_wire[fmem_int];
      cntmem_next[fmem_int] = {|cntmem_temp[fmem_int][WIDTH:WIDTH-1],cntmem_temp[fmem_int][WIDTH-2:0]};
    end
  end

integer cmem_int;
always @(posedge clk)
  for (cmem_int=0; cmem_int<NUMCTPT; cmem_int=cmem_int+1)
    if (rst)
      cntmeminv[cmem_int] <= 1'b1;
    else if (write && (addr == select_addr)) begin
      cntmeminv[cmem_int] <= 1'b0;
      cntmem[cmem_int] <= (cmem_int==0) ? din : 0;
    end else if (!cntmeminv[cmem_int]) begin
      cntmeminv[cmem_int] <= cntmeminv_next[cmem_int];
      cntmem[cmem_int] <= cntmem_next[cmem_int];
    end

reg [WIDTH:0] mem_temp;
reg meminv_wire;
reg [WIDTH-1:0] mem_wire;
integer fake_int;
always_comb begin
  meminv_wire = 0;
  mem_wire = 0;
  for (fake_int=0; fake_int<NUMCTPT; fake_int=fake_int+1) begin
    meminv_wire = meminv_wire || cntmeminv[fake_int];
    mem_temp = mem_wire + cntmem[fake_int];
    mem_wire = {|mem_temp[WIDTH:WIDTH-1],mem_temp[WIDTH-2:0]};
  end
end

genvar cmem_var;
generate for (cmem_var=0; cmem_var<NUMCTPT; cmem_var=cmem_var+1) begin: cmem_loop
  assert_cntmem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##(FLOPIN+SRAM_DELAY)
                                        ($past(cntmeminv[cmem_var],FLOPIN+SRAM_DELAY) || ($past(cntmem[cmem_var],FLOPIN+SRAM_DELAY) == mem[cmem_var])));
end
endgenerate

genvar ct_var;
generate for (ct_var=0; ct_var<NUMCTPT; ct_var=ct_var+1) begin: cto_loop
  assert_ct_vld_check: assert property (@(posedge clk) disable iff (rst) (cnt_wire[ct_var] && (ct_adr_wire[ct_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                        ct_vld_wire[ct_var]);
  if (FLOPADD || FLOPOUT) begin: flp_loop
    assert_ct_serr_check: assert property (@(posedge clk) disable iff (rst) (cnt_wire[ct_var] && (ct_adr_wire[ct_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                           (ct_serr[ct_var] == $past(t1_serrB[ct_var],FLOPADD+FLOPOUT)));
    assert_ct_derr_check: assert property (@(posedge clk) disable iff (rst) (cnt_wire[ct_var] && (ct_adr_wire[ct_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                           (ct_derr[ct_var] == $past(t1_derrB[ct_var],FLOPADD+FLOPOUT)));
  end else begin: nflp_loop
    assert_ct_serr_check: assert property (@(posedge clk) disable iff (rst) (cnt_wire[ct_var] && (ct_adr_wire[ct_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                           (ct_serr[ct_var] == t1_serrB[ct_var]));
    assert_ct_derr_check: assert property (@(posedge clk) disable iff (rst) (cnt_wire[ct_var] && (ct_adr_wire[ct_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                           (ct_derr[ct_var] == t1_derrB[ct_var]));
  end
end
endgenerate

assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                    (rd_vld && ($past(meminv_wire,FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT) || |rd_derr ||
                                               (rd_dout == $past(mem_wire,FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)))));

reg [BITCTPT-1:0] padr_tmp;
reg serr_tmp;
reg derr_tmp;
integer padr_int;
always_comb begin
  serr_tmp = 0;
  derr_tmp = 0;
  padr_tmp = 0;
  for (padr_int=NUMCTPT-1; padr_int>=0; padr_int=padr_int-1) begin
    if (t1_serrB[padr_int] && !derr_tmp) begin
      serr_tmp = 1'b1;
      padr_tmp = padr_int;
    end
    if (t1_derrB[padr_int]) begin
      derr_tmp = 1'b1;
      padr_tmp = padr_int;
    end
  end
end

generate if (FLOPADD || FLOPOUT) begin: eflp_loop
  assert_serr_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                      (rd_serr == $past(|t1_serrB,FLOPADD+FLOPOUT)));
  assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                      (rd_derr == $past(|t1_derrB,FLOPADD+FLOPOUT)));
  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                      (rd_padr[BITPADR-1:BITPADR-BITCTPT] == $past(padr_tmp,FLOPADD+FLOPOUT)) &&
                                      (rd_padr[BITPADR-BITCTPT-1:0] == $past(t1_padrB_wire[padr_tmp],FLOPADD+FLOPOUT)));
end else begin: neflp_loop
  assert_serr_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                      (rd_serr == |t1_serrB));
  assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                      (rd_derr == |t1_derrB));
  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                      (rd_padr[BITPADR-1:BITPADR-BITCTPT] == padr_tmp) &&
                                      (rd_padr[BITPADR-BITCTPT-1:0] == t1_padrB_wire[padr_tmp]));
end
endgenerate

endmodule



