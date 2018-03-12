module ip_top_sva_2_1r1w_rl2_a1
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     SRAM_DELAY = 2,
parameter     DRAM_DELAY = 2,
parameter     ECCBITS = 4,
parameter     SDOUT_WIDTH = 12
   )
(
  input clk,
  input rst,
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

assert_rd_range_check: assert property (@(posedge clk) disable iff (rst) read |-> (rd_adr < NUMADDR));
assert_wr_range_check: assert property (@(posedge clk) disable iff (rst) write |-> (wr_adr < NUMADDR));

genvar t1_int;
generate for (t1_int=0; t1_int<NUMVBNK; t1_int=t1_int+1) begin: t1_loop
  assert_t1_1port_check: assert property (@(posedge clk) disable iff (rst) !(t1_readA[t1_int] && t1_writeA[t1_int]));
  assert_t1_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t1_readA[t1_int] || t1_writeA[t1_int]) |->
					     ((t1_addrA >> (t1_int*BITVROW)) & {BITVROW{1'b1}}) < NUMVROW);
end
endgenerate

genvar t2_int;
generate for (t2_int=0; t2_int<2; t2_int=t2_int+1) begin: t2_loop
  assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB[t2_int] |-> (((t2_addrB >> (t2_int*BITVROW)) & {BITVROW{1'b1}}) < NUMVROW));
  assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA[t2_int] |-> (((t2_addrA >> (t2_int*BITVROW)) & {BITVROW{1'b1}}) < NUMVROW));
  assert_t2_rw_psuedo_check: assert property (@(posedge clk) disable iff (rst) t2_writeA[t2_int] && t2_readB[t2_int] |->
					      (((t2_addrA >> (t2_int*BITVROW)) & {BITVROW{1'b1}}) != ((t2_addrB >> (t2_int*BITVROW)) & {BITVROW{1'b1}})));
end
endgenerate

assert_t2_write_check: assert property (@(posedge clk) disable iff (rst) |t2_writeA |->
									 ((t2_writeA[0] == t2_writeA[1]) &&
								          ((t2_addrA & {BITVROW{1'b1}}) == (t2_addrA >> BITVROW)) &&
								          ((t2_dinA & {(SDOUT_WIDTH+WIDTH){1'b1}}) == (t2_dinA >> (SDOUT_WIDTH+WIDTH)))));

endmodule


module ip_top_sva_1r1w_rl2_a1
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     SRAM_DELAY = 2,
parameter     DRAM_DELAY = 2,
parameter     ECCDWIDTH = 4,
parameter     ECCBITS = 4,
parameter     SDOUT_WIDTH = 12
   )
(
  input clk,
  input rst,
  input [NUMVBNK-1:0] t1_writeA,
  input [NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMVBNK*WIDTH-1:0] t1_dinA,
  input [2-1:0] t2_writeA,
  input [2*BITVROW-1:0] t2_addrA,
  input [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA,
  input [NUMVBNK-1:0] t1_readA,
  input [NUMVBNK*WIDTH-1:0] t1_doutA,
  input [2-1:0] t2_readB,
  input [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB,
  input write,
  input [BITADDR-1:0]  wr_adr,
  input [WIDTH-1:0] din,
  input [BITADDR-1:0] rd_adr,
  input [WIDTH-1:0] rd_dout,
  input [2*BITVROW-1:0] t2_addrB,
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

assert_rw_wr_np2_check: assert property (@(posedge clk) disable iff (rst) (read && write) |->
					 ((rd_adr == wr_adr) == ((core.vrdbadr == core.vwrbadr) && (core.vrdradr == core.vwrradr))));
assert_rw_sl_np2_check: assert property (@(posedge clk) disable iff (rst) (read) |->
					 ((rd_adr == select_addr) == ((core.vrdbadr == select_bank) && (core.vrdradr == select_row)))); 
assert_wr_sl_np2_check: assert property (@(posedge clk) disable iff (rst) (write) |->
					 ((wr_adr == select_addr) == ((core.vwrbadr == select_bank) && (core.vwrradr == select_row)))); 

assert_rp_np2_range_check: assert property (@(posedge clk) disable iff (rst) (read) |->
					    ((core.vrdbadr < NUMVBNK) && (core.vrdradr < NUMVROW)));
assert_wr_np2_range_check: assert property (@(posedge clk) disable iff (rst) (write) |->
					    ((core.vwrbadr < NUMVBNK) && (core.vwrradr < NUMVROW)));
assert_sl_np2_range_check: assert property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR) |->
					    ((select_bank < NUMVBNK) && (select_row < NUMVROW))); 

reg mem;
always @(posedge clk)
  if (t1_writeA[select_bank] && (((t1_addrA >> (select_bank*BITVROW)) & {BITVROW{1'b1}}) == select_row))
    mem <= t1_dinA[select_bank*WIDTH+select_bit];

reg [SDOUT_WIDTH-1:0] mapmem;
always @(posedge clk)
  if (rst)
    mapmem <= 0;
  else if (t2_writeA[0] && ((t2_addrA & {BITVROW{1'b1}}) == select_row))
    mapmem <= t2_dinA >> WIDTH;

wire [ECCBITS-1:0] mapmem_ecc;
ecc_calc #(.ECCDWIDTH(ECCDWIDTH), .ECCWIDTH(ECCBITS))
    ecc_calc_inst (.din(mapmem[BITVBNK:0]), .eccout(mapmem_ecc));

reg datmem;
always @(posedge clk)
  if (rst)
    datmem <= 0;
  else if (t2_writeA[0] && ((t2_addrA & {BITVROW{1'b1}}) == select_row))
    datmem <= t2_dinA[select_bit];

wire mem_wire = (mapmem[BITVBNK] && (mapmem[BITVBNK-1:0] == select_bank)) ? datmem : mem;

assert_mapmem_ecc_check: assert property (@(posedge clk) disable iff (rst) (mapmem == {mapmem[BITVBNK:0],mapmem_ecc,mapmem[BITVBNK:0]}));


assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readA[select_bank] &&
								       (((t1_addrA >> (select_bank*BITVROW)) & {BITVROW{1'b1}}) == select_row)) |-> ##SRAM_DELAY
                                     (t1_doutA[select_bank*WIDTH+select_bit] == $past(mem,SRAM_DELAY)));

assert_sdout1_check: assert property (@(posedge clk) disable iff (rst) (t2_readB[0] && ((t2_addrB & {BITVROW{1'b1}}) == select_row)) |-> ##SRAM_DELAY
                                      (((t2_doutB >> WIDTH) & {SDOUT_WIDTH{1'b1}}) == $past(mapmem,SRAM_DELAY)));

assert_sdout2_check: assert property (@(posedge clk) disable iff (rst) (t2_readB[1] && ((t2_addrB >> BITVROW) == select_row)) |-> ##SRAM_DELAY
                                      (((t2_doutB >> (SDOUT_WIDTH+2*WIDTH)) & {SDOUT_WIDTH{1'b1}}) == $past(mapmem,SRAM_DELAY)));

assert_ddout1_check: assert property (@(posedge clk) disable iff (rst) (t2_readB[0] && ((t2_addrB & {BITVROW{1'b1}}) == select_row)) |-> ##SRAM_DELAY
                                      (t2_doutB[select_bit] == $past(datmem,SRAM_DELAY)));

assert_ddout2_check: assert property (@(posedge clk) disable iff (rst) (t2_readB[1] && ((t2_addrB >> BITVROW) == select_row)) |-> ##SRAM_DELAY
                                      (t2_doutB[select_bit+SDOUT_WIDTH+WIDTH] == $past(datmem,SRAM_DELAY)));

assert_sdout1_ecc_check: assert property (@(posedge clk) disable iff (rst) (t2_readB[0] && ((t2_addrB & {BITVROW{1'b1}}) == select_row)) |-> ##SRAM_DELAY
                                          (core.sdout1_out == $past(mapmem[BITVBNK:0],SRAM_DELAY)));

assert_sdout2_ecc_check: assert property (@(posedge clk) disable iff (rst) (t2_readB[1] && ((t2_addrB >> BITVROW) == select_row)) |-> ##SRAM_DELAY
                                          (core.sdout2_out == $past(mapmem[BITVBNK:0],SRAM_DELAY)));
`ifdef FORMAL
wire state1_serr = 0;
wire state1_derr = 0;
wire state1_nerr = !state1_serr && !state1_derr;
assume_state1_err_check: assert property (@(posedge clk) disable iff (rst) !(state1_serr && state1_derr));
assume_state1_serr_check: assert property (@(posedge clk) disable iff (rst) state1_serr |-> ##SRAM_DELAY core.sdout1_serr && !core.sdout1_derr);
assume_state1_derr_check: assert property (@(posedge clk) disable iff (rst) state1_derr |-> ##SRAM_DELAY !core.sdout1_serr && core.sdout1_derr);
assume_state1_nerr_check: assert property (@(posedge clk) disable iff (rst) state1_nerr |-> ##SRAM_DELAY !core.sdout1_serr && !core.sdout1_derr);

assert_sdout1_nerr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB[0] && ((t2_addrB & {BITVROW{1'b1}}) == select_row) && state1_nerr) |-> ##SRAM_DELAY
					   !core.sdout1_ded_err && !core.sdout1_sec_err && (core.sdout1_dup_data == core.sdout1_post_ecc));

assert_sdout1_serr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB[0] && ((t2_addrB & {BITVROW{1'b1}}) == select_row) && state1_serr) |-> ##SRAM_DELAY
					   !core.sdout1_ded_err && (core.sdout1_sec_err ? (core.sdout1_dup_data == core.sdout1_post_ecc) :
										          (core.sdout1_dup_data != core.sdout1_post_ecc)));

assert_sdout1_derr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB[0] && ((t2_addrB & {BITVROW{1'b1}}) == select_row) && state1_derr) |-> ##SRAM_DELAY
					   core.sdout1_ded_err ? !core.sdout1_sec_err :
					   core.sdout1_sec_err ? !core.sdout1_ded_err && (core.sdout1_dup_data != core.sdout1_post_ecc) :
							         (core.sdout1_dup_data != core.sdout1_post_ecc));

wire state2_serr = 0;
wire state2_derr = 0;
wire state2_nerr = !state2_serr && !state2_derr;
assume_state2_err_check: assert property (@(posedge clk) disable iff (rst) !(state2_serr && state2_derr));
assume_state2_serr_check: assert property (@(posedge clk) disable iff (rst) state2_serr |-> ##SRAM_DELAY core.sdout2_serr && !core.sdout2_derr);
assume_state2_derr_check: assert property (@(posedge clk) disable iff (rst) state2_derr |-> ##SRAM_DELAY !core.sdout2_serr && core.sdout2_derr);
assume_state2_nerr_check: assert property (@(posedge clk) disable iff (rst) state2_nerr |-> ##SRAM_DELAY !core.sdout2_serr && !core.sdout2_derr);

assert_sdout2_nerr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB[1] && ((t2_addrB >> BITVROW) == select_row) && state2_nerr) |-> ##SRAM_DELAY
					   !core.sdout2_ded_err && !core.sdout2_sec_err && (core.sdout2_dup_data == core.sdout2_post_ecc));

assert_sdout2_serr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB[1] && ((t2_addrB >> BITVROW) == select_row) && state2_serr) |-> ##SRAM_DELAY
					   !core.sdout2_ded_err && (core.sdout2_sec_err ? (core.sdout2_dup_data == core.sdout2_post_ecc) :
										          (core.sdout2_dup_data != core.sdout2_post_ecc)));

assert_sdout2_derr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB[1] && ((t2_addrB >> BITVROW) == select_row) && state2_derr) |-> ##SRAM_DELAY
					   core.sdout2_ded_err ? !core.sdout2_sec_err :
					   core.sdout2_sec_err ? !core.sdout2_ded_err && (core.sdout2_dup_data != core.sdout2_post_ecc) :
							                                 (core.sdout2_dup_data != core.sdout2_post_ecc));
`endif
reg fakemem;
reg fakememinv;
always @(posedge clk)
  if (rst)
    fakememinv <= 1'b1;
  else if (write && (wr_adr == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din[select_bit];
  end

assert_wrmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (write && (core.vwrradr == select_row)) |-> ##(SRAM_DELAY+1)
                                          (core.wrmap_out == mapmem[BITVBNK:0]));
assert_wrdat_fwd_check: assert property (@(posedge clk) disable iff (rst) (write && (core.vwrradr == select_row)) |-> ##(SRAM_DELAY+1)
                                          (core.wrdat_out[select_bit] == datmem));

assert_rdmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (read && (core.vrdradr == select_row)) |-> ##SRAM_DELAY
                                          (core.rdmap_out == $past(mapmem[BITVBNK:0],SRAM_DELAY)));
assert_rddat_fwd_check: assert property (@(posedge clk) disable iff (rst) (read && (core.vrdradr == select_row)) |-> ##SRAM_DELAY
                                          (core.rddat_out[select_bit] == $past(datmem,SRAM_DELAY)));

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##(SRAM_DELAY+1)
				       ($past(fakememinv,SRAM_DELAY+1) || ($past(fakemem,SRAM_DELAY+1) == mem_wire)));

assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##SRAM_DELAY
                                    (rd_vld && ($past(fakememinv,SRAM_DELAY) || (rd_dout[select_bit] == $past(fakemem,SRAM_DELAY)))));

endmodule

