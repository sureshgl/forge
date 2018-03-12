module ip_top_sva_2_1r1w_rl2_a721
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     ENAPSDO = 1,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     REFRESH = 0,
parameter     REFFREQ = 16,
parameter     SRAM_DELAY = 2,
parameter     DRAM_DELAY = 2,
parameter     SDOUT_WIDTH = BITVBNK+1
   )
(
  input clk,
  input rst,
  input ready,
  input refr,
  input read,
  input [BITADDR-1:0] rd_adr,
  input write,
  input [BITADDR-1:0] wr_adr,
  input [NUMVBNK-1:0] t1_readA,
  input [NUMVBNK-1:0] t1_writeA,
  input [NUMVBNK*BITVROW-1:0] t1_addrA,
  input [2-1:0] t2_writeA,
  input [2*BITVROW-1:0] t2_addrA,
  input [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA,
  input [2-1:0] t2_readB,
  input [2*BITVROW-1:0] t2_addrB
);

generate if (REFRESH) begin: refr_loop
//assert_refr_check: assert property (@(posedge clk) disable iff (!ready) !refr |-> ##[1:REFFREQ-1] refr);
//assert_refr_noacc_check: assume property (@(posedge clk) disable iff (rst) !(refr && (write || read)));
end
endgenerate

//assert_rd_range_check: assert property (@(posedge clk) disable iff (rst) read |-> (rd_adr < NUMADDR));
assert_wr_range_check: assert property (@(posedge clk) disable iff (rst) write |-> (wr_adr < NUMADDR));

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
  wire t2_writeA_wire = t2_writeA >> t2_int;
  wire [BITVROW-1:0] t2_addrA_wire = t2_addrA >> (t2_int*BITVROW);
  wire [SDOUT_WIDTH+WIDTH-1:0] t2_dinA_wire = t2_dinA >> (t2_int*(SDOUT_WIDTH+WIDTH));

  wire t2_writeA_0_wire = t2_writeA;
  wire [BITVROW-1:0] t2_addrA_0_wire = t2_addrA;
  wire [SDOUT_WIDTH+WIDTH-1:0] t2_dinA_0_wire = t2_dinA;

  wire t2_readB_wire = t2_readB >> t2_int;
  wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> (t2_int*BITVROW);

  assert_t2_wr_same_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_writeA_0_wire &&
                                                                                                 (t2_addrA_0_wire == t2_addrA_wire) &&
                                                                                                 (t2_dinA_0_wire == t2_dinA_wire)));
  assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_addrA_wire < NUMVROW));
//  assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire |-> (t2_addrB_wire < NUMVROW));
  assert_t2_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (ENAPSDO && t2_writeA_wire && t2_readB_wire) |-> (t2_addrA_wire != t2_addrB_wire));
end
endgenerate

endmodule


module ip_top_sva_1r1w_rl2_a721
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     ENAPAR = 0,
parameter     ENAECC = 0,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     BITPBNK = 4,
parameter     BITPADR = 14,
parameter     REFRESH = 0,
parameter     SRAM_DELAY = 2,
parameter     DRAM_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0,
parameter     SDOUT_WIDTH = BITVBNK+1,
parameter     FIFOCNT = SRAM_DELAY+REFRESH
   )
(
  input clk,
  input rst,
  input [NUMVBNK-1:0] t1_writeA,
  input [NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMVBNK-1:0] t1_readA,
  input [NUMVBNK*WIDTH-1:0] t1_doutA,
  input [NUMVBNK-1:0] t1_fwrdA,
  input [NUMVBNK-1:0] t1_serrA,
  input [NUMVBNK-1:0] t1_derrA,
  input [NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrA,
  input [2-1:0] t2_writeA,
  input [2*BITVROW-1:0] t2_addrA,
  input [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA,
  input [2-1:0] t2_readB,
  input [2*BITVROW-1:0] t2_addrB,
  input [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB,
  input [2-1:0] t2_fwrdB,
  input [2-1:0] t2_serrB,
  input [2-1:0] t2_derrB,
  input [2*(BITPADR-BITPBNK)-1:0] t2_padrB,
  input write,
  input [BITADDR-1:0]  wr_adr,
  input [WIDTH-1:0] din,
  input [BITADDR-1:0] rd_adr,
  input [WIDTH-1:0] rd_dout,
  input rd_fwrd,
  input rd_serr,
  input rd_derr,
  input [BITPADR-1:0] rd_padr,
  input read,
  input rd_vld,
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

wire t2_writeA_wire = t2_writeA;
wire [BITVROW-1:0] t2_addrA_wire = t2_addrA;
wire [SDOUT_WIDTH-1:0] t2_sdinA_wire = t2_dinA >> WIDTH;
wire [WIDTH-1:0] t2_ddinA_wire = t2_dinA;

wire t2_readB_0_wire = t2_readB;
wire [BITVROW-1:0] t2_addrB_0_wire = t2_addrB;
wire [SDOUT_WIDTH-1:0] t2_sdoutB_0_wire = t2_doutB >> WIDTH;
wire [WIDTH-1:0] t2_ddoutB_0_wire = t2_doutB;
wire t2_fwrdB_0_wire = t2_fwrdB;
wire t2_serrB_0_wire = t2_serrB;
wire t2_derrB_0_wire = t2_derrB;
wire [BITPADR-BITPBNK-1:0] t2_padrB_0_wire = t2_padrB;

wire t2_readB_1_wire = t2_readB >> 1;
wire [BITVROW-1:0] t2_addrB_1_wire = t2_addrB >> (1*BITVROW);
wire [SDOUT_WIDTH-1:0] t2_sdoutB_1_wire = t2_doutB >> (2*WIDTH+SDOUT_WIDTH);
wire [WIDTH-1:0] t2_ddoutB_1_wire = t2_doutB >> (WIDTH+SDOUT_WIDTH);
wire t2_ddoutB_1_sel_wire = t2_ddoutB_1_wire >> select_bit;
wire t2_fwrdB_1_wire = t2_fwrdB >> 1;
wire t2_serrB_1_wire = t2_serrB >> 1;
wire t2_derrB_1_wire = t2_derrB >> 1;
wire [BITPADR-BITPBNK-1:0] t2_padrB_1_wire = t2_padrB >> (BITPADR-BITPBNK);

reg meminv;
reg mem;
always @(posedge clk)
  if (rst) begin
    meminv <= 1'b1;
  end else if (t1_writeA_sel_wire && (t1_addrA_sel_wire == select_row)) begin
    meminv <= 1'b0;
    mem <= t1_dinA_sel_wire[select_bit];
  end

reg [SDOUT_WIDTH-1:0] mapmem;
always @(posedge clk)
  if (rst)
    mapmem <= 0;
  else if (t2_writeA_wire && (t2_addrA_wire == select_row))
    mapmem <= t2_sdinA_wire;

reg datmem;
always @(posedge clk)
  if (rst)
    datmem <= 0;
  else if (t2_writeA_wire && (t2_addrA_wire == select_row))
    datmem <= t2_ddinA_wire[select_bit];

wire mem_wire = (mapmem[BITVBNK] && (mapmem[BITVBNK-1:0] == select_bank)) ? datmem : mem;

assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_sel_wire && (t1_addrA_sel_wire == select_row)) |-> ##DRAM_DELAY
                                     ($past(meminv,DRAM_DELAY) ||
                                      (!t1_fwrdA_sel_wire && (ENAPAR ? t1_serrA_sel_wire : ENAECC ? t1_derrA_sel_wire : 0)) ||
                                      (t1_doutA[select_bank*WIDTH+select_bit] == $past(mem,DRAM_DELAY))));

assert_sdout1_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_0_wire && (t2_addrB_0_wire == select_row)) |-> ##SRAM_DELAY
                                      (t2_sdoutB_0_wire == $past(mapmem,SRAM_DELAY)));

assert_sdout2_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_1_wire && (t2_addrB_1_wire == select_row)) |-> ##SRAM_DELAY
                                      (t2_sdoutB_1_wire == $past(mapmem,SRAM_DELAY)));

assert_ddout1_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_0_wire && (t2_addrB_0_wire == select_row)) |-> ##SRAM_DELAY
                                      (t2_ddoutB_0_wire[select_bit] == $past(datmem,SRAM_DELAY)));

assert_ddout2_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_1_wire && (t2_addrB_1_wire == select_row)) |-> ##SRAM_DELAY
                                      (t2_ddoutB_1_wire[select_bit] == $past(datmem,SRAM_DELAY)));

reg fakemem;

assert_wrmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire && (core.vwrradr_wire == select_row)) |-> ##SRAM_DELAY
                                          (core.wrmap_out == mapmem[BITVBNK:0]));
assert_wrdat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire && (core.vwrradr_wire == select_row)) |-> ##SRAM_DELAY
                                          (core.wrdat_out[select_bit] == datmem));

assert_rdmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdradr_wire == select_row)) |-> ##DRAM_DELAY
                                         (core.rdmap_out == mapmem[BITVBNK:0]));
assert_rddat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdradr_wire == select_row)) |-> ##DRAM_DELAY
                                         (core.rddat_out[select_bit] == datmem));
assert_pdat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdaddr_wire == select_addr)) |-> ##DRAM_DELAY
                                        (meminv || (!t1_fwrdA_sel_wire && !core.pdat_vld[SRAM_DELAY-1] &&
                                                    (ENAPAR ? t1_serrA_sel_wire : ENAECC ? t1_derrA_sel_wire : 1'b0)) ||
                                         (core.pdat_out[select_bit] == mem)));

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

//generate if (SRAM_DELAY==DRAM_DELAY) begin: vdout_sym_loop
  assert_vdout_int_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+DRAM_DELAY)
                                           (rmeminv || (!core.vread_fwrd_int && (ENAPAR ? rd_serr : ENAECC ? rd_derr : 1'b0)) ||
                                            (core.vdout_int[select_bit] == rmem)));
//end else begin: vdout_asym_loop
//  assert_vdout_int_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+DRAM_DELAY)
//                                           ($past(rmeminv,DRAM_DELAY-SRAM_DELAY) || (core.vdout_int[select_bit] == $past(rmem,DRAM_DELAY-SRAM_DELAY))));
//end
//endgenerate

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

assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
                                    (rd_vld && ($past(fakememinv,FLOPIN+DRAM_DELAY+FLOPOUT) || 
                                                (!rd_fwrd && (ENAPAR ? rd_serr : ENAECC ? rd_derr : 1'b0)) ||
                                                (rd_dout[select_bit] == $past(fakemem,FLOPIN+DRAM_DELAY+FLOPOUT)))));
assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
                                    ($past(fakememinv,FLOPIN+DRAM_DELAY+FLOPOUT) ||
                                     ($past(fakemem,FLOPIN+DRAM_DELAY+FLOPOUT)==$past(mem_wire,DRAM_DELAY+FLOPOUT)) || rd_fwrd) &&
                                    (rd_fwrd || !((rd_padr[BITPADR-1:BITPADR-BITPBNK] == NUMVBNK) ?
                                                  (FLOPOUT ? $past(t2_fwrdB_1_wire) : t2_fwrdB_1_wire) :
                                                  (FLOPOUT ? $past(t1_fwrdA_sel_wire) : t1_fwrdA_sel_wire))));
assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
                                    ($past(fakememinv,FLOPIN+DRAM_DELAY+FLOPOUT) ||
                                     ((rd_padr[BITPADR-1:BITPADR-BITPBNK] == NUMVBNK) ?
                                      (rd_serr == (FLOPOUT ? $past(t2_serrB_1_wire) : t2_serrB_1_wire)) &&
                                      (rd_derr == (FLOPOUT ? $past(t2_derrB_1_wire) : t2_derrB_1_wire)) :
                                      (rd_serr == (FLOPOUT ? $past(t1_serrA_sel_wire) : t1_serrA_sel_wire)) &&
                                      (rd_derr == (FLOPOUT ? $past(t1_derrA_sel_wire) : t1_derrA_sel_wire)))));
assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
                                    ((rd_padr == {NUMVBNK,(FLOPOUT ? $past(t2_padrB_1_wire) : t2_padrB_1_wire)}) ||
				     (rd_padr == {select_bank,(FLOPOUT ? $past(t1_padrA_sel_wire) : t1_padrA_sel_wire)})));

endmodule
