module ip_top_sva_2_1rfw_1rw_rl2
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     NUMCBNK = 2,
parameter     BITCBNK = 1,
parameter     SRAM_DELAY = 2
   )
(
  input clk,
  input rst,
  input ready,
  input read,
  input [BITADDR-1:0] rd_adr,
  input write,
  input [BITADDR-1:0] wr_adr,
  input [NUMVBNK-1:0] t1_readA,
  input [NUMVBNK-1:0] t1_writeA,
  input [NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMCBNK-1:0] t2_readA,
  input [NUMCBNK-1:0] t2_writeA,
  input [NUMCBNK*BITVROW-1:0] t2_addrA,
  input [NUMCBNK*WIDTH-1:0] t2_dinA,
  input [NUMCBNK-1:0] t3_readA,
  input [NUMCBNK-1:0] t3_writeA,
  input [NUMCBNK*BITVROW-1:0] t3_addrA,
  input [NUMCBNK*(BITVBNK+1)-1:0] t3_dinA
);

//assert_rd_range_check: assert property (@(posedge clk) disable iff (rst) read |-> (rd_adr < NUMADDR));
assert_wr_check: assert property (@(posedge clk) disable iff (!ready) write |-> ##2 !$past(write) && !write);
assert_wr_range_check: assert property (@(posedge clk) disable iff (!ready) write |-> (wr_adr < NUMADDR));

genvar t1_int;
generate for (t1_int=0; t1_int<NUMVBNK; t1_int=t1_int+1) begin: t1_loop
  wire t1_readA_wire = t1_readA >> t1_int;
  wire t1_writeA_wire = t1_writeA >> t1_int;
  wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> (t1_int*BITVROW);

  assert_t1_1port_check: assert property (@(posedge clk) disable iff (rst) !(t1_readA_wire && t1_writeA_wire));
//  assert_t1_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire || t1_writeA_wire) |-> (t1_addrA_wire < NUMVROW));
  assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMVROW));
end
endgenerate

genvar t2_int;
generate for (t2_int=0; t2_int<NUMCBNK; t2_int=t2_int+1) begin: t2_loop
  wire t2_readA_wire = t2_readA >> t2_int;
  wire t2_writeA_wire = t2_writeA >> t2_int;
  wire [BITVROW-1:0] t2_addrA_wire = t2_addrA >> (t2_int*BITVROW);
  wire [WIDTH-1:0] t2_dinA_wire = t2_dinA >> (t2_int*WIDTH);

  wire t2_writeA_0_wire = t2_writeA;
  wire [BITVROW-1:0] t2_addrA_0_wire = t2_addrA;
  wire [WIDTH-1:0] t2_dinA_0_wire = t2_dinA;

  assert_t2_1port_check: assert property (@(posedge clk) disable iff (rst) !(t2_readA_wire && t2_writeA_wire));
//  assert_t2_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire || t2_writeA_wire) |-> (t2_addrA_wire < NUMVROW));
  assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_addrA_wire < NUMVROW));
//  assert_t2_wr_same_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_writeA_0_wire &&
//                                                                                                 (t2_addrA_0_wire == t2_addrA_wire) &&
//                                                                                                 (t2_dinA_0_wire == t2_dinA_wire)));
end
endgenerate

genvar t3_int;
generate for (t3_int=0; t3_int<NUMCBNK; t3_int=t3_int+1) begin: t3_loop
  wire t3_readA_wire = t3_readA >> t3_int;
  wire t3_writeA_wire = t3_writeA >> t3_int;
  wire [BITVROW-1:0] t3_addrA_wire = t3_addrA >> (t3_int*BITVROW);
  wire [BITVBNK:0] t3_dinA_wire = t3_dinA >> (t3_int*(BITVBNK+1));

  wire t3_writeA_0_wire = t3_writeA;
  wire [BITVROW-1:0] t3_addrA_0_wire = t3_addrA;
  wire [BITVBNK:0] t3_dinA_0_wire = t3_dinA;

  assert_t3_1port_check: assert property (@(posedge clk) disable iff (rst) !(t3_readA_wire && t3_writeA_wire));
//  assert_t3_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t3_readA_wire || t3_writeA_wire) |-> (t3_addrA_wire < NUMVROW));
  assert_t3_wr_range_check: assert property (@(posedge clk) disable iff (rst) t3_writeA_wire |-> (t3_addrA_wire < NUMVROW));
//  assert_t3_wr_same_check: assert property (@(posedge clk) disable iff (rst) t3_writeA_wire |-> (t3_writeA_0_wire &&
//                                                                                                 (t3_addrA_0_wire == t3_addrA_wire) &&
//                                                                                                 (t3_dinA_0_wire == t3_dinA_wire)));
end
endgenerate

endmodule

module ip_top_sva_1rfw_1rw_rl2
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     BITPBNK = 4,
parameter     BITPADR = 14,
parameter     NUMCBNK = 2,
parameter     BITCBNK = 1,
parameter     SRAM_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0,
parameter     FIFOCNT = 1
   )
(
  input clk,
  input rst,
  input write,
  input [BITADDR-1:0]  wr_adr,
  input [WIDTH-1:0] din,
  input read,
  input [BITADDR-1:0] rd_adr,
  input rd_vld,
  input [WIDTH-1:0] rd_dout,
  input rd_fwrd,
  input rd_serr,
  input rd_derr,
  input [BITPADR-1:0] rd_padr,
  input [NUMVBNK-1:0] t1_readA,
  input [NUMVBNK-1:0] t1_writeA,
  input [NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMVBNK*WIDTH-1:0] t1_doutA,
  input [NUMVBNK-1:0] t1_fwrdA,
  input [NUMVBNK-1:0] t1_serrA,
  input [NUMVBNK-1:0] t1_derrA,
  input [NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrA,
  input [NUMCBNK-1:0] t2_readA,
  input [NUMCBNK-1:0] t2_writeA,
  input [NUMCBNK*BITVROW-1:0] t2_addrA,
  input [NUMCBNK*WIDTH-1:0] t2_dinA,
  input [NUMCBNK*WIDTH-1:0] t2_doutA,
  input [NUMCBNK-1:0] t2_fwrdA,
  input [NUMCBNK-1:0] t2_serrA,
  input [NUMCBNK-1:0] t2_derrA,
  input [NUMCBNK*(BITPADR-BITPBNK)-1:0] t2_padrA,
  input [NUMCBNK-1:0] t3_readA,
  input [NUMCBNK-1:0] t3_writeA,
  input [NUMCBNK*BITVROW-1:0] t3_addrA,
  input [NUMCBNK*(BITVBNK+1)-1:0] t3_dinA,
  input [NUMCBNK*(BITVBNK+1)-1:0] t3_doutA,
  input [NUMCBNK-1:0] t3_fwrdA,
  input [NUMCBNK-1:0] t3_serrA,
  input [NUMCBNK-1:0] t3_derrA,
  input [NUMCBNK*(BITPADR-BITPBNK)-1:0] t3_padrA,
  input [BITADDR-1:0] select_addr,
  input [BITWDTH-1:0] select_bit
);

wire [BITVBNK-1:0] select_bank;
wire [BITVROW-1:0] select_row;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  sel_adr (.vbadr(select_bank), .vradr(select_row), .vaddr(select_addr));

assert_rw_wr_np2_check: assert property (@(posedge clk) disable iff (rst) (read && write) |-> ##FLOPIN
					 ((core.vrdaddr_wire == core.vwraddr_wire) == ((core.vrdbadr_wire == core.vwrbadr_wire) && (core.vrdradr_wire == core.vwrradr_wire))));
assert_rw_sl_np2_check: assert property (@(posedge clk) disable iff (rst) (read) |-> ##FLOPIN
					 ((core.vrdaddr_wire == select_addr) == ((core.vrdbadr_wire == select_bank) && (core.vrdradr_wire == select_row)))); 
assert_wr_sl_np2_check: assert property (@(posedge clk) disable iff (rst) (write) |-> ##FLOPIN
					 ((core.vwraddr_wire == select_addr) == ((core.vwrbadr_wire == select_bank) && (core.vwrradr_wire == select_row)))); 

//assert_rp_np2_range_check: assert property (@(posedge clk) disable iff (rst) (read) |-> ##FLOPIN
//					    ((core.vrdbadr_wire < NUMVBNK) && (core.vrdradr_wire < NUMVROW)));
assert_wr_np2_range_check: assert property (@(posedge clk) disable iff (rst) (write) |-> ##FLOPIN
					    ((core.vwrbadr_wire < NUMVBNK) && (core.vwrradr_wire < NUMVROW)));
assert_sl_np2_range_check: assert property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR) |->
					    ((select_bank < NUMVBNK) && (select_row < NUMVROW))); 

wire t1_readA_sel_wire = t1_readA >> select_bank;
wire t1_writeA_sel_wire = t1_writeA >> select_bank;
wire [BITVROW-1:0] t1_addrA_sel_wire = t1_addrA >> (select_bank*BITVROW);
wire [WIDTH-1:0] t1_dinA_sel_wire = t1_dinA >> (select_bank*WIDTH);
wire [WIDTH-1:0] t1_doutA_sel_wire = t1_doutA >> (select_bank*WIDTH);
wire t1_fwrdA_sel_wire = t1_fwrdA >> select_bank;
wire t1_serrA_sel_wire = t1_serrA >> select_bank;
wire t1_derrA_sel_wire = t1_derrA >> select_bank;
wire [BITPADR-BITPBNK-1:0] t1_padrA_sel_wire = t1_padrA >> (select_bank*(BITPADR-BITPBNK));
wire t1_doutA_sel_sel_wire = t1_doutA_sel_wire >> select_bit;

reg t2_readA_wire [0:NUMCBNK-1];
reg t2_writeA_wire [0:NUMCBNK-1];
reg [BITVROW-1:0] t2_addrA_wire [0:NUMCBNK-1];
reg [WIDTH-1:0] t2_dinA_wire [0:NUMCBNK-1];
reg [WIDTH-1:0] t2_doutA_wire [0:NUMCBNK-1];
reg t2_fwrdA_wire [0:NUMCBNK-1];
reg t2_serrA_wire [0:NUMCBNK-1];
reg t2_derrA_wire [0:NUMCBNK-1];
reg [BITPADR-BITPBNK-1:0] t2_padrA_wire [0:NUMCBNK-1];
integer t2_int;
always_comb
  for (t2_int=0; t2_int<NUMCBNK; t2_int=t2_int+1) begin
    t2_readA_wire[t2_int] = t2_readA >> t2_int;
    t2_writeA_wire[t2_int] = t2_writeA >> t2_int;
    t2_addrA_wire[t2_int] = t2_addrA >> (t2_int*BITVROW);
    t2_dinA_wire[t2_int] = t2_dinA >> (t2_int*WIDTH);
    t2_doutA_wire[t2_int] = t2_doutA >> (t2_int*WIDTH);
    t2_fwrdA_wire[t2_int] = t2_fwrdA >> t2_int;
    t2_serrA_wire[t2_int] = t2_serrA >> t2_int;
    t2_derrA_wire[t2_int] = t2_derrA >> t2_int;
    t2_padrA_wire[t2_int] = t2_padrA >> (t2_int*(BITPADR-BITPBNK));
  end

reg t3_readA_wire [0:NUMCBNK-1];
reg t3_writeA_wire [0:NUMCBNK-1];
reg [BITVROW-1:0] t3_addrA_wire [0:NUMCBNK-1];
reg [BITVBNK:0] t3_dinA_wire [0:NUMCBNK-1];
reg [BITVBNK:0] t3_doutA_wire [0:NUMCBNK-1];
reg t3_fwrdA_wire [0:NUMCBNK-1];
reg t3_serrA_wire [0:NUMCBNK-1];
reg t3_derrA_wire [0:NUMCBNK-1];
reg [BITPADR-BITPBNK-1:0] t3_padrA_wire [0:NUMCBNK-1];
integer t3_int;
always_comb
  for (t3_int=0; t3_int<NUMCBNK; t3_int=t3_int+1) begin
    t3_readA_wire[t3_int] = t3_readA >> t3_int;
    t3_writeA_wire[t3_int] = t3_writeA >> t3_int;
    t3_addrA_wire[t3_int] = t3_addrA >> (t3_int*BITVROW);
    t3_dinA_wire[t3_int] = t3_dinA >> (t3_int*(BITVROW+1));
    t3_doutA_wire[t3_int] = t3_doutA >> (t3_int*(BITVROW+1));
    t3_fwrdA_wire[t3_int] = t3_fwrdA >> t3_int;
    t3_serrA_wire[t3_int] = t3_serrA >> t3_int;
    t3_derrA_wire[t3_int] = t3_derrA >> t3_int;
    t3_padrA_wire[t3_int] = t3_padrA >> (t3_int*(BITPADR-BITPBNK));
  end
 
reg meminv;
reg mem;
always @(posedge clk)
  if (rst) begin
    meminv <= 1'b1;
  end else if (t1_writeA_sel_wire && (t1_addrA_sel_wire == select_row)) begin
    meminv <= 1'b0;
    mem <= t1_dinA_sel_wire[select_bit];
  end

reg [BITVBNK:0] smem [0:NUMCBNK-1];
integer smem_int;
always @(posedge clk)
  for (smem_int=0; smem_int<NUMCBNK; smem_int=smem_int+1)
    if (rst)
      smem[smem_int] <= 0;
    else if (t3_writeA_wire[smem_int] && (t3_addrA_wire[smem_int] == select_row))
      smem[smem_int] <= t3_dinA_wire[smem_int];

reg [BITVBNK:0] cmem [0:NUMCBNK-1];
integer cmem_int;
always @(posedge clk)
  for (cmem_int=0; cmem_int<NUMCBNK; cmem_int=cmem_int+1)
    if (rst)
      cmem[cmem_int] <= 0;
    else if (t2_writeA_wire[cmem_int] && (t2_addrA_wire[cmem_int] == select_row))
      cmem[cmem_int] <= t2_dinA_wire[cmem_int][select_bit];

reg [BITVBNK:0] mapmem;
always @(posedge clk)
  if (rst)
    mapmem <= 0;
  else if (core.swrite && (core.swrradr == select_row))
    mapmem <= core.sdin;

reg datmem;
always @(posedge clk)
  if (rst)
    datmem <= 0;
  else if (core.swrite && (core.swrradr == select_row))
    datmem <= core.ddin[select_bit];

wire mem_wire = (mapmem[BITVBNK] && (mapmem[BITVBNK-1:0] == select_bank)) ? datmem : mem;

assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_sel_wire && (t1_addrA_sel_wire == select_row)) |-> ##SRAM_DELAY
                                     ($past(meminv,SRAM_DELAY) || (t1_doutA[select_bank*WIDTH+select_bit] == $past(mem,SRAM_DELAY))));

genvar ddout_var;
generate for (ddout_var=0; ddout_var<NUMCBNK; ddout_var=ddout_var+1) begin: ddout_loop
  assert_ddout_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire[ddout_var] && (t2_addrA_wire[ddout_var] == select_row)) |-> ##SRAM_DELAY
                                       (t2_doutA_wire[ddout_var][select_bit] == $past(cmem[ddout_var],SRAM_DELAY)));
end
endgenerate

genvar sdout_var;
generate for (sdout_var=0; sdout_var<NUMCBNK; sdout_var=sdout_var+1) begin: sdout_loop
  assert_sdout_check: assert property (@(posedge clk) disable iff (rst) (t3_readA_wire[sdout_var] && (t3_addrA_wire[sdout_var] == select_row)) |-> ##SRAM_DELAY
                                       (t3_doutA_wire[sdout_var] == $past(smem[sdout_var],SRAM_DELAY)));
end
endgenerate

reg fakemem;

assert_wrmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire && (core.vwrradr_wire == select_row)) |-> ##SRAM_DELAY
                                          (core.wrmap_out == mapmem[BITVBNK:0]));
assert_wrdat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire && (core.vwrradr_wire == select_row)) |-> ##SRAM_DELAY
                                          (core.wrdat_out[select_bit] == datmem));

assert_rdmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdradr_wire == select_row)) |-> ##SRAM_DELAY
                                         (core.rdmap_out == mapmem[BITVBNK:0]));
assert_rddat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdradr_wire == select_row)) |-> ##SRAM_DELAY
                                         (core.rddat_out[select_bit] == datmem));
assert_pdat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdaddr_wire == select_addr)) |-> ##SRAM_DELAY
                                        (meminv || (core.pdat_out[select_bit] == mem)));

assert_sold_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.snew_vld && (core.snew_row == select_row)) |->
                                        (({core.sold_vld,core.sold_map} == mapmem[BITVBNK:0]) && (core.sold_dat[select_bit] == datmem)));
assert_wrfifo_check: assert property (@(posedge clk) disable iff (rst) (core.wrfifo_cnt <= FIFOCNT));

reg rmeminv;
reg rmem;
always @(posedge clk)
  if (rst) begin
    rmeminv <= 1'b1;
  end else if (core.snew_vld && (core.snew_map == select_bank) && (core.snew_row == select_row)) begin
    rmeminv <= 1'b0;
    rmem <= core.snew_dat[select_bit];
  end

assert_rmem_check: assert property (@(posedge clk) disable iff (rst) (rmeminv || (mem_wire == rmem)));

assert_vdout_int_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY)
                                         (rmeminv || (core.vdout_int[select_bit] == rmem)));

reg vmeminv;
reg vmem;
always @(posedge clk)
  if (rst) begin
    vmeminv <= 1'b1;
  end else if (core.vwrite_out && (core.vwrbadr_out == select_bank) && (core.vwrradr_out == select_row)) begin
    vmeminv <= 1'b0;
    vmem <= core.vdin_out[select_bit];
  end

assert_vmem_check: assert property (@(posedge clk) disable iff (rst) (vmeminv || ((core.wr_srch_flags ? core.wr_srch_datas[select_bit] : rmem) == vmem)));

assert_srch_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY)
                                    (vmeminv || (rmeminv ? (core.wr_srch_flag && (core.wr_srch_data[select_bit] == vmem)) :
                                                           ((core.wr_srch_flag ? core.wr_srch_data[select_bit] : rmem) == vmem))));
//                                    (vmeminv || (rmeminv ? (core.wr_srch_flag && (core.wr_srch_dbit == vmem)) :
//                                                           ((core.wr_srch_flag ? core.wr_srch_dbit : rmem) == vmem))));

reg fakememinv;
always @(posedge clk)
  if (rst)
    fakememinv <= 1'b1;
  else if (write && (wr_adr == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din[select_bit];
  end

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##(FLOPIN+SRAM_DELAY)
				       ($past(fakememinv,FLOPIN+SRAM_DELAY) || ($past(fakemem,FLOPIN+SRAM_DELAY) == vmem)));

assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                    (rd_vld && ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) || (rd_dout[select_bit] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)))));
assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                    ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) ||
                                     $past(fakemem==mem_wire,FLOPIN+SRAM_DELAY+FLOPOUT) || rd_fwrd) &&
                                    (rd_fwrd || !((rd_padr[BITPADR-1:BITPADR-BITPBNK] == NUMVBNK) ?
                                                  (FLOPOUT ? $past(t2_fwrdA_wire[0]) : t2_fwrdA_wire[0]) :
                                                  (FLOPOUT ? $past(t1_fwrdA_sel_wire) : t1_fwrdA_sel_wire))));
assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                    ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) ||
                                     ((rd_padr[BITPADR-1:BITPADR-BITPBNK] == NUMVBNK) ?
                                      (rd_serr == (FLOPOUT ? $past(t2_serrA_wire[0]) : t2_serrA_wire[0])) &&
                                      (rd_derr == (FLOPOUT ? $past(t2_derrA_wire[0]) : t2_derrA_wire[0])) :
                                      (rd_serr == (FLOPOUT ? $past(t1_serrA_sel_wire) : t1_serrA_sel_wire)) &&
                                      (rd_derr == (FLOPOUT ? $past(t1_derrA_sel_wire) : t1_derrA_sel_wire)))));
assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                    ((rd_padr == {NUMVBNK,select_row}) ||
				     (rd_padr == {select_bank,(FLOPOUT ? $past(t1_padrA_sel_wire) : t1_padrA_sel_wire)})));

endmodule

