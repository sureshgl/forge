module ip_top_sva_2_1r1d3w_1rw_rl2
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
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
  input [2-1:0] t2_readA,
  input [2-1:0] t2_writeA,
  input [2*BITVROW-1:0] t2_addrA,
  input [2*WIDTH-1:0] t2_dinA,
  input [2-1:0] t3_readA,
  input [2-1:0] t3_writeA,
  input [2*BITVROW-1:0] t3_addrA,
  input [2*(BITVBNK+1)-1:0] t3_dinA
);

//assert_rd_range_check: assert property (@(posedge clk) disable iff (rst) read |-> (rd_adr < NUMADDR));
//assert wr_check: assert property (@(posedge clk) disable iff (!ready) write |-> ##2 !$past(write) && !write);
assert_wr_check: assert property (@(posedge clk) disable iff (!ready) write |-> ##2 $past(!write) && !write);
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
generate for (t2_int=0; t2_int<2; t2_int=t2_int+1) begin: t2_loop
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
generate for (t3_int=0; t3_int<2; t3_int=t3_int+1) begin: t3_loop
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

module ip_top_sva_1r1d3w_1rw_rl2
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
  input [2-1:0] t2_readA,
  input [2-1:0] t2_writeA,
  input [2*BITVROW-1:0] t2_addrA,
  input [2*WIDTH-1:0] t2_dinA,
  input [2*WIDTH-1:0] t2_doutA,
  input [2-1:0] t2_fwrdA,
  input [2-1:0] t2_serrA,
  input [2-1:0] t2_derrA,
  input [2*(BITPADR-BITPBNK)-1:0] t2_padrA,
  input [2-1:0] t3_readA,
  input [2-1:0] t3_writeA,
  input [2*BITVROW-1:0] t3_addrA,
  input [2*(BITVBNK+1)-1:0] t3_dinA,
  input [2*(BITVBNK+1)-1:0] t3_doutA,
  input [2-1:0] t3_fwrdA,
  input [2-1:0] t3_serrA,
  input [2-1:0] t3_derrA,
  input [2*(BITPADR-BITPBNK)-1:0] t3_padrA,
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

wire t2_readA_0_wire = t2_readA;
wire t2_writeA_0_wire = t2_writeA;
wire [BITVROW-1:0] t2_addrA_0_wire = t2_addrA;
wire [WIDTH-1:0] t2_dinA_0_wire = t2_dinA;
wire t2_readA_1_wire = t2_readA >> 1;
wire t2_writeA_1_wire = t2_writeA >> 1;
wire [BITVROW-1:0] t2_addrA_1_wire = t2_addrA >> BITVROW;
wire [WIDTH-1:0] t2_dinA_1_wire = t2_dinA >> WIDTH;

wire t3_readA_0_wire = t3_readA;
wire t3_writeA_0_wire = t3_writeA;
wire [BITVROW-1:0] t3_addrA_0_wire = t3_addrA;
wire [BITVBNK:0] t3_dinA_0_wire = t3_dinA;
wire t3_readA_1_wire = t3_readA >> 1;
wire t3_writeA_1_wire = t3_writeA >> 1;
wire [BITVROW-1:0] t3_addrA_1_wire = t3_addrA >> BITVROW;
wire [BITVBNK:0] t3_dinA_1_wire = t3_dinA >> (BITVBNK+1);

wire [WIDTH-1:0] t2_doutA_0_wire = t2_doutA;
wire t2_fwrdA_0_wire = t2_fwrdA;
wire t2_serrA_0_wire = t2_serrA;
wire t2_derrA_0_wire = t2_derrA;
wire [BITPADR-BITPBNK-1:0] t2_padrA_0_wire = t2_padrA;
wire [WIDTH-1:0] t2_doutA_1_wire = t2_doutA >> WIDTH;
wire t2_fwrdA_1_wire = t2_fwrdA >> 1;
wire t2_serrA_1_wire = t2_serrA >> 1;
wire t2_derrA_1_wire = t2_derrA >> 1;
wire [BITPADR-BITPBNK-1:0] t2_padrA_1_wire = t2_padrA >> (BITPADR-BITPBNK);

wire [BITVBNK:0] t3_doutA_0_wire = t3_doutA;
wire [BITVBNK:0] t3_doutA_1_wire = t3_doutA >> (BITVBNK+1);

reg meminv;
reg mem;
always @(posedge clk)
  if (rst) begin
    meminv <= 1'b1;
  end else if (t1_writeA_sel_wire && (t1_addrA_sel_wire == select_row)) begin
    meminv <= 1'b0;
    mem <= t1_dinA_sel_wire[select_bit];
  end

reg [BITVBNK:0] mapmem_0;
always @(posedge clk)
  if (rst)
    mapmem_0 <= 0;
  else if (t3_writeA_0_wire && (t3_addrA_0_wire == select_row))
    mapmem_0 <= t3_dinA_0_wire;

reg [BITVBNK:0] mapmem_1;
always @(posedge clk)
  if (rst)
    mapmem_1 <= 0;
  else if (t3_writeA_1_wire && (t3_addrA_1_wire == select_row))
    mapmem_1 <= t3_dinA_1_wire;

reg datmem_0;
always @(posedge clk)
  if (rst)
    datmem_0 <= 0;
  else if (t2_writeA_0_wire && (t2_addrA_0_wire == select_row))
    datmem_0 <= t2_dinA_0_wire[select_bit];

reg datmem_1;
always @(posedge clk)
  if (rst)
    datmem_1 <= 0;
  else if (t2_writeA_1_wire && (t2_addrA_1_wire == select_row))
    datmem_1 <= t2_dinA_1_wire[select_bit];

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

assert_ddout1_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_0_wire && (t2_addrA_0_wire == select_row)) |-> ##SRAM_DELAY
                                      (t2_doutA_0_wire[select_bit] == $past(datmem_0,SRAM_DELAY)));
assert_ddout2_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_1_wire && (t2_addrA_1_wire == select_row)) |-> ##SRAM_DELAY
                                      (t2_doutA_1_wire[select_bit] == $past(datmem_1,SRAM_DELAY)));

assert_sdout1_check: assert property (@(posedge clk) disable iff (rst) (t3_readA_0_wire && (t3_addrA_0_wire == select_row)) |-> ##SRAM_DELAY
                                      (t3_doutA_0_wire == $past(mapmem_0,SRAM_DELAY)));
assert_sdout2_check: assert property (@(posedge clk) disable iff (rst) (t3_readA_1_wire && (t3_addrA_1_wire == select_row)) |-> ##SRAM_DELAY
                                      (t3_doutA_1_wire == $past(mapmem_1,SRAM_DELAY)));

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
                                                  (FLOPOUT ? $past(t2_fwrdA_1_wire) : t2_fwrdA_1_wire) :
                                                  (FLOPOUT ? $past(t1_fwrdA_sel_wire) : t1_fwrdA_sel_wire))));
assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                    ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) ||
                                     ((rd_padr[BITPADR-1:BITPADR-BITPBNK] == NUMVBNK) ?
                                      (rd_serr == (FLOPOUT ? $past(t2_serrA_1_wire) : t2_serrA_1_wire)) &&
                                      (rd_derr == (FLOPOUT ? $past(t2_derrA_1_wire) : t2_derrA_1_wire)) :
                                      (rd_serr == (FLOPOUT ? $past(t1_serrA_sel_wire) : t1_serrA_sel_wire)) &&
                                      (rd_derr == (FLOPOUT ? $past(t1_derrA_sel_wire) : t1_derrA_sel_wire)))));
assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                    ((rd_padr == {NUMVBNK,select_row}) ||
				     (rd_padr == {select_bank,(FLOPOUT ? $past(t1_padrA_sel_wire) : t1_padrA_sel_wire)})));

endmodule

