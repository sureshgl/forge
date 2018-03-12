module ip_top_sva_2_1r1w_dl
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     ECCBITS = 4,
parameter     REFRESH = 0,
parameter     REFFREQ = 16,
parameter     REFFRHF = 0,
parameter     SRAM_DELAY = 2,
parameter     DRAM_DELAY = 2,
parameter     SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS
   )
(
  input clk,
  input rst,
  input ready,
  input refr,
  input read,
  input [BITADDR-1:0] rd_adr,
  input write,
  input [BITADDR-1:0]  wr_adr,
  input [NUMVBNK-1:0] t1_readA,
  input [NUMVBNK-1:0] t1_writeA,
  input [NUMVBNK*BITVROW-1:0] t1_addrA,
  input [2-1:0] t2_writeA,
  input [2*BITVROW-1:0] t2_addrA,
  input [2*SDOUT_WIDTH-1:0] t2_dinA,
  input [2-1:0] t2_readB,
  input [2*BITVROW-1:0] t2_addrB,
  input [1-1:0] t3_writeA,
  input [1*BITVROW-1:0] t3_addrA,
  input [1-1:0] t3_readB,
  input [1*BITVROW-1:0] t3_addrB
);

generate if (REFRESH) begin: refr_loop
assert_refr_check: assert property (@(posedge clk) disable iff (!ready) !refr |-> ##[1:REFFREQ-1] refr);
assert_refr_half_check: assert property (@(posedge clk) disable iff (!ready) refr ##(REFFREQ+REFFRHF) refr |-> ##REFFREQ (!REFFRHF || refr));
assert_refr_noacc_check: assume property (@(posedge clk) disable iff (rst) !(refr && (write || read)));
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
  wire [SDOUT_WIDTH-1:0] t2_dinA_wire = t2_dinA >> (t2_int*SDOUT_WIDTH);

  wire t2_writeA_0_wire = t2_writeA;
  wire [BITVROW-1:0] t2_addrA_0_wire = t2_addrA;
  wire [SDOUT_WIDTH-1:0] t2_dinA_0_wire = t2_dinA;

  wire t2_readB_wire = t2_readB >> t2_int;
  wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> (t2_int*BITVROW);

  assert_t2_wr_same_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_writeA_0_wire &&
                                                                                                 (t2_addrA_0_wire == t2_addrA_wire) &&
                                                                                                 (t2_dinA_0_wire == t2_dinA_wire)));
  assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_addrA_wire < NUMVROW));
//  assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire |-> (t2_addrB_wire < NUMVROW));
  assert_t2_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t2_writeA_wire && t2_readB_wire) |-> (t2_addrA_wire != t2_addrB_wire));
end
endgenerate

genvar t3_int;
generate for (t3_int=0; t3_int<1; t3_int=t3_int+1) begin: t3_loop
  wire t3_writeA_wire = t3_writeA >> t3_int;
  wire [BITVROW-1:0] t3_addrA_wire = t3_addrA >> (t3_int*BITVROW);

  wire t3_readB_wire = t3_readB >> t3_int;
  wire [BITVROW-1:0] t3_addrB_wire = t3_addrB >> (t3_int*BITVROW);

  assert_t3_wr_range_check: assert property (@(posedge clk) disable iff (rst) t3_writeA_wire |-> (t3_addrA_wire < NUMVROW));
//  assert_t3_rd_range_check: assert property (@(posedge clk) disable iff (rst) t3_readB_wire |-> (t3_addrB_wire < NUMVROW));
  assert_t3_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t3_writeA_wire && t3_readB_wire) |-> (t3_addrA_wire != t3_addrB_wire));
end
endgenerate

endmodule


module ip_top_sva_1r1w_dl
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
parameter     BITPADR = 13,
parameter     ECCBITS = 4,
parameter     SRAM_DELAY = 2,
parameter     DRAM_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0,
parameter     SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS,
parameter     FIFOCNT = SRAM_DELAY+1
   )
(
  input clk,
  input rst,
  input [NUMVBNK-1:0] t1_readA,
  input [NUMVBNK-1:0] t1_writeA,
  input [NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMVBNK*WIDTH-1:0] t1_doutA,
  input [NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrA,
  input [2-1:0] t2_writeA,
  input [2*BITVROW-1:0] t2_addrA,
  input [2*SDOUT_WIDTH-1:0] t2_dinA,
  input [2-1:0] t2_readB,
  input [2*BITVROW-1:0] t2_addrB,
  input [2*SDOUT_WIDTH-1:0] t2_doutB,
  input [1-1:0] t3_writeA,
  input [1*BITVROW-1:0] t3_addrA,
  input [1*WIDTH-1:0] t3_dinA,
  input [1-1:0] t3_readB,
  input [1*BITVROW-1:0] t3_addrB,
  input [1*WIDTH-1:0] t3_doutB,
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
//                                            ((core.vrdbadr_wire < NUMVBNK) && (core.vrdradr_wire < NUMVROW)));
assert_wr_np2_range_check: assert property (@(posedge clk) disable iff (rst) (write) |-> ##FLOPIN
                                            ((core.vwrbadr_wire < NUMVBNK) && (core.vwrradr_wire < NUMVROW)));
assert_sl_np2_range_check: assert property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR) |->
                                            ((select_bank < NUMVBNK) && (select_row < NUMVROW)));

wire t1_readA_sel_wire = t1_readA >> select_bank;
wire t1_writeA_sel_wire = t1_writeA >> select_bank;
wire [BITVROW-1:0] t1_addrA_sel_wire = t1_addrA >> (select_bank*BITVROW);
wire [WIDTH-1:0] t1_dinA_sel_wire = t1_dinA >> (select_bank*WIDTH);
wire [WIDTH-1:0] t1_doutA_sel_wire = t1_doutA >> (select_bank*WIDTH);
wire [BITPADR-BITPBNK-1:0] t1_padrA_sel_wire = t1_padrA >> (select_bank*(BITPADR-BITPBNK));
wire t1_doutA_sel_sel_wire = t1_doutA_sel_wire >> select_bit;

wire t2_writeA_sel_wire = t2_writeA;
wire [BITVROW-1:0] t2_addrA_sel_wire = t2_addrA;
wire [SDOUT_WIDTH-1:0] t2_dinA_sel_wire = t2_dinA;
wire t2_readB_0_wire = t2_readB;
wire [BITVROW-1:0] t2_addrB_0_wire = t2_addrB;
wire [SDOUT_WIDTH-1:0] t2_doutB_0_wire = t2_doutB;
wire t2_readB_1_wire = t2_readB >> 1;
wire [BITVROW-1:0] t2_addrB_1_wire = t2_addrB >> (1*BITVROW);
wire [SDOUT_WIDTH-1:0] t2_doutB_1_wire = t2_doutB >> (1*SDOUT_WIDTH);
wire t3_doutB_sel_wire = t3_doutB >> select_bit;

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
  else if (t2_writeA_sel_wire && (t2_addrA_sel_wire == select_row))
    mapmem <= t2_dinA_sel_wire;

wire [ECCBITS-1:0] mapmem_ecc;
ecc_calc   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
   ecc_calc_inst (.din(mapmem[BITVBNK:0]), .eccout(mapmem_ecc));

reg datmem;
always @(posedge clk)
  if (rst)
    datmem <= 0;
  else if (t3_writeA && (t3_addrA == select_row))
    datmem <= t3_dinA[select_bit];

wire mem_wire = (mapmem[BITVBNK] && (mapmem[BITVBNK-1:0] == select_bank)) ? datmem : mem;

assert_mapmem_ecc_check: assert property (@(posedge clk) disable iff (rst) (mapmem == {mapmem[BITVBNK:0],mapmem_ecc,mapmem[BITVBNK:0]}));


assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_sel_wire && (t1_addrA_sel_wire == select_row)) |-> ##DRAM_DELAY
                                     ($past(meminv,DRAM_DELAY) || (t1_doutA_sel_wire[select_bit] == $past(mem,DRAM_DELAY))));

assert_sdout1_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_0_wire && (t2_addrB_0_wire == select_row)) |-> ##SRAM_DELAY
                                      (t2_doutB_0_wire == $past(mapmem,SRAM_DELAY)));

assert_sdout2_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_1_wire && (t2_addrB_1_wire == select_row)) |-> ##SRAM_DELAY
                                      (t2_doutB_1_wire == $past(mapmem,SRAM_DELAY)));

assert_ddout1_check: assert property (@(posedge clk) disable iff (rst) (t3_readB && (t3_addrB == select_row)) |-> ##SRAM_DELAY
                                      (t3_doutB[select_bit] == $past(datmem,SRAM_DELAY)));

assert_sdout1_ecc_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_0_wire && (t2_addrB_0_wire == select_row)) |-> ##SRAM_DELAY
                                          (core.sdout1_out == $past(mapmem[BITVBNK:0],SRAM_DELAY)));

assert_sdout2_ecc_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_1_wire && (t2_addrB_1_wire == select_row)) |-> ##SRAM_DELAY
                                          (core.sdout2_out == $past(mapmem[BITVBNK:0],SRAM_DELAY)));

wire state1_serr = 0;
wire state1_derr = 0;
wire state1_nerr = !state1_serr && !state1_derr;
assume_state1_err_check: assert property (@(posedge clk) disable iff (rst) !(state1_serr && state1_derr));
assume_state1_serr_check: assert property (@(posedge clk) disable iff (rst) state1_serr |-> ##SRAM_DELAY core.sdout1_serr && !core.sdout1_derr);
assume_state1_derr_check: assert property (@(posedge clk) disable iff (rst) state1_derr |-> ##SRAM_DELAY !core.sdout1_serr && core.sdout1_derr);
assume_state1_nerr_check: assert property (@(posedge clk) disable iff (rst) state1_nerr |-> ##SRAM_DELAY !core.sdout1_serr && !core.sdout1_derr);

assert_sdout1_nerr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_0_wire && (t2_addrB_0_wire == select_row) && state1_nerr) |-> ##SRAM_DELAY
					   !core.wr_ded_err && !core.wr_sec_err && (core.sdout1_dup_data == core.sdout1_post_ecc));

assert_sdout1_serr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_0_wire && (t2_addrB_0_wire == select_row) && state1_serr) |-> ##SRAM_DELAY
					   !core.wr_ded_err && (core.wr_sec_err ? (core.sdout1_dup_data == core.sdout1_post_ecc) :
										  (core.sdout1_dup_data != core.sdout1_post_ecc)));

assert_sdout1_derr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_0_wire && (t2_addrB_0_wire == select_row) && state1_derr) |-> ##SRAM_DELAY
					   core.wr_ded_err ? !core.wr_sec_err :
					   core.wr_sec_err ? !core.wr_ded_err && (core.sdout1_dup_data != core.sdout1_post_ecc) :
							     (core.sdout1_dup_data != core.sdout1_post_ecc));

wire state2_serr = 0;
wire state2_derr = 0;
wire state2_nerr = !state2_serr && !state2_derr;
assume_state2_err_check: assert property (@(posedge clk) disable iff (rst) !(state2_serr && state2_derr));
assume_state2_serr_check: assert property (@(posedge clk) disable iff (rst) state2_serr |-> ##SRAM_DELAY core.sdout2_serr && !core.sdout2_derr);
assume_state2_derr_check: assert property (@(posedge clk) disable iff (rst) state2_derr |-> ##SRAM_DELAY !core.sdout2_serr && core.sdout2_derr);
assume_state2_nerr_check: assert property (@(posedge clk) disable iff (rst) state2_nerr |-> ##SRAM_DELAY !core.sdout2_serr && !core.sdout2_derr);

assert_sdout2_nerr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_1_wire && (t2_addrB_1_wire == select_row) && state2_nerr) |-> ##SRAM_DELAY
					   !core.rd_ded_err && !core.rd_sec_err && (core.sdout2_dup_data == core.sdout2_post_ecc));

assert_sdout2_serr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_1_wire && (t2_addrB_1_wire == select_row) && state2_serr) |-> ##SRAM_DELAY
					   !core.rd_ded_err && (core.rd_sec_err ? (core.sdout2_dup_data == core.sdout2_post_ecc) :
										  (core.sdout2_dup_data != core.sdout2_post_ecc)));

assert_sdout2_derr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_1_wire && (t2_addrB_1_wire == select_row) && state2_derr) |-> ##SRAM_DELAY
					   core.rd_ded_err ? !core.rd_sec_err :
					   core.rd_sec_err ? !core.rd_ded_err && (core.sdout2_dup_data != core.sdout2_post_ecc) :
							     (core.sdout2_dup_data != core.sdout2_post_ecc));


assert_wrmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire && (core.vwrradr_wire == select_row)) |-> ##SRAM_DELAY
                                          (core.wrmap_out == mapmem[BITVBNK:0]));
assert_rdmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdradr_wire == select_row)) |-> ##SRAM_DELAY
                                          (core.rdmap_out == mapmem[BITVBNK:0]));

assert_wmmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.cread1 && (core.crdradr1 == select_row)) |-> ##SRAM_DELAY
                                         (core.wmmap_out == mapmem[BITVBNK:0]));
assert_wrdat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.cread1 && (core.crdradr1 == select_row)) |-> ##SRAM_DELAY
                                         (core.wrdat_out[select_bit] == datmem));

assert_swrold_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.swrnew_vld && (core.swrnew_row == select_row)) |->
                                          (({core.swrold_vld,core.swrold_map} == mapmem[BITVBNK:0]) && (core.swrold_dat[select_bit] == datmem)));
assert_wrfifo_check: assert property (@(posedge clk) disable iff (rst) (core.wrfifo_cnt <= FIFOCNT));

reg rmeminv;
reg rmem;
always @(posedge clk)
  if (rst) begin
    rmeminv <= 1'b1;
  end else if (core.cut_to_pivot && (core.vwrbadr_out == select_bank) && (core.vwrradr_out == select_row)) begin
    rmeminv <= 1'b0;
    rmem <= core.vdin_out[select_bit];
  end else if (core.swrnew_vld && (core.swrnew_map == select_bank) && (core.swrnew_row == select_row)) begin
    rmeminv <= 1'b0;
    rmem <= core.swrnew_dat[select_bit];
  end

assert_rmem_check: assert property (@(posedge clk) disable iff (rst) (rmeminv || (mem_wire == rmem)));

assert_vdout_int_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY)
                                         ($past(rmeminv,DRAM_DELAY) || (core.vdout_int[select_bit] == $past(rmem,DRAM_DELAY))));

reg vmeminv;
reg vmem;
always @(posedge clk)
  if (rst) begin
    vmeminv <= 1'b1;
  end else if (core.cut_to_pivot && (core.vwrbadr_out == select_bank) && (core.vwrradr_out == select_row)) begin
    vmeminv <= 1'b0;
    vmem <= core.vdin_out[select_bit];
  end else if (core.cread1_out && (core.crdbadr1_out == select_bank) && (core.crdradr1_out == select_row)) begin
    vmeminv <= 1'b0;
    vmem <= core.cdin1_out[select_bit];
  end

assert_vmem_check: assert property (@(posedge clk) disable iff (rst) (vmeminv || ((core.wr_srch_flags ? core.wr_srch_datas[select_bit] : rmem) == vmem)));

assert_srch_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY)
                                    (vmeminv || (rmeminv ? (core.wr_srch_flag && (core.wr_srch_data[select_bit] == vmem)) :
                                                           ((core.wr_srch_flag ? core.wr_srch_data[select_bit] : rmem) == vmem))));
//                                    (vmeminv || (rmeminv ? (core.wr_srch_flag && (core.wr_srch_dbit == vmem)) :
//                                                           ((core.wr_srch_flag ? core.wr_srch_dbit : rmem) == vmem))));

reg fakemem;
reg fakememinv;
always @(posedge clk)
  if (rst)
    fakememinv <= 1'b1;
  else if (write && (wr_adr == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din[select_bit];
  end

//assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##SRAM_DELAY
//				       ($past(fakememinv,SRAM_DELAY) || ($past(fakemem,SRAM_DELAY) == mem_wire)));
//assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |->  ##(2*SRAM_DELAY)
//				       ($past(fakememinv,2*SRAM_DELAY) || ($past(fakemem,2*SRAM_DELAY) == vmem) || ($past(fakemem,SRAM_DELAY) == vmem)));

assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
                                    (rd_vld && ($past(fakememinv,FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT) ||
                                                (rd_dout[select_bit] == $past(fakemem,FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)))));

assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
                                    (rd_fwrd || ($past(fakememinv,FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)) ||
                                     ((rd_padr[BITPADR-1:BITPADR-BITPBNK] != NUMVBNK) &&
                                      (rd_dout[select_bit] == (FLOPOUT ? $past(t1_doutA_sel_sel_wire) : t1_doutA_sel_sel_wire))) ||
                                     ((rd_padr[BITPADR-1:BITPADR-BITPBNK] == NUMVBNK) &&
                                      (rd_dout[select_bit] == ((FLOPOUT+DRAM_DELAY-SRAM_DELAY>0) ? $past(t3_doutB_sel_wire,FLOPOUT+DRAM_DELAY-SRAM_DELAY) :
                                                                                                   t3_doutB_sel_wire)))));

assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
				    ((rd_padr == ((NUMVBNK << (BITPADR-BITPBNK)) | select_row)) ||
				     (rd_padr == {select_bank,(FLOPOUT ? $past(t1_padrA_sel_wire) : t1_padrA_sel_wire)})));

endmodule

