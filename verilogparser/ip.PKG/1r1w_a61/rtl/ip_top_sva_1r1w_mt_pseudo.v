module ip_top_sva_2_1r1w_mt_pseudo
  #(parameter
     WIDTH   = 32,
     NUMADDR = 8192,
     BITADDR = 13,
     NUMVBNK = 8,
     BITVBNK = 3,
     NUMPBNK = 9,
     BITPBNK = 4,
     NUMVROW = 1024,
     BITVROW = 10,
     REFRESH = 1,
     ECCBITS = 7,
     BITMAPT = BITPBNK*NUMPBNK,
     SDOUT_WIDTH = 2*BITMAPT+ECCBITS
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
  input t1_writeA,
  input [BITPBNK-1:0] t1_bankA,
  input [BITVROW-1:0] t1_addrA,
  input t1_readB,
  input [BITPBNK-1:0] t1_bankB,
  input [BITVROW-1:0] t1_addrB,
  input [2-1:0] t2_writeA,
  input [2*BITVROW-1:0] t2_addrA,
  input [2*SDOUT_WIDTH-1:0] t2_dinA,
  input [2-1:0] t2_readB,
  input [2*BITVROW-1:0] t2_addrB
);

generate if (REFRESH) begin: refr_loop
  assert_refr_noacc_check: assume property (@(posedge clk) disable iff (rst) !(refr && (write || read)));
end
endgenerate

//assert_rd_range_check: assert property (@(posedge clk) disable iff (rst) read |-> (rd_adr < NUMADDR));
assert_wr_range_check: assert property (@(posedge clk) disable iff (rst) write |-> (wr_adr < NUMADDR));

//assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB |-> (t1_bankB < NUMVBNK) && (t1_addrB < NUMVROW));
assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA |-> (t1_bankA < NUMPBNK) && (t1_addrA < NUMVROW));
assert_t1_rw_bank_check: assert property (@(posedge clk) disable iff (rst) (t1_writeA && t1_readB) |-> (t1_bankA != t1_bankB));

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

endmodule


module ip_top_sva_1r1w_mt_pseudo
  #(parameter
     WIDTH   = 32,
     BITWDTH = 5,
     NUMADDR = 8192,
     BITADDR = 13,
     NUMVROW = 1024,
     BITVROW = 10,
     NUMVBNK = 8,
     BITVBNK = 3,
     NUMPBNK = 9,
     BITPBNK = 4,
     BITPADR = 14,
     ECCBITS = 8,
     SRAM_DELAY = 2,
     DRAM_DELAY = 2,
     FLOPIN = 0,
     FLOPOUT = 0,
     BITMAPT = BITPBNK*NUMPBNK,
     SDOUT_WIDTH = 2*BITMAPT+ECCBITS
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
  input t1_writeA,
  input [BITPBNK-1:0] t1_bankA,
  input [BITVROW-1:0] t1_addrA, 
  input [WIDTH-1:0] t1_dinA,
  input t1_readB,
  input [BITPBNK-1:0] t1_bankB,
  input [BITVROW-1:0] t1_addrB,
  input [WIDTH-1:0] t1_doutB,
  input t1_fwrdB,
  input t1_serrB,
  input t1_derrB,
  input [(BITPADR-BITPBNK)-1:0] t1_padrB,
  input [2-1:0] t2_writeA,
  input [2*BITVROW-1:0] t2_addrA,
  input [2*SDOUT_WIDTH-1:0] t2_dinA,
  input [2-1:0] t2_readB,
  input [2*BITVROW-1:0] t2_addrB,
  input [2*SDOUT_WIDTH-1:0] t2_doutB,
  input [2-1:0] t2_fwrdB,
  input [2-1:0] t2_serrB,
  input [2-1:0] t2_derrB,
  input [2*(BITPADR-BITPBNK)-1:0] t2_padrB,
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

wire t2_writeA_wire [0:2-1];
wire [BITVROW-1:0] t2_addrA_wire [0:2-1];
wire [SDOUT_WIDTH-1:0] t2_dinA_wire [0:2-1];
wire t2_readB_wire [0:2-1];
wire [BITVROW-1:0] t2_addrB_wire [0:2-1];
wire [SDOUT_WIDTH-1:0] t2_doutB_wire [0:2-1];
wire t2_fwrdB_wire [0:2-1];
wire t2_serrB_wire [0:2-1];
wire t2_derrB_wire [0:2-1];
wire [BITPADR-BITPBNK-1:0] t2_padrB_wire [0:2-1];
genvar t2_var;
generate for (t2_var=0; t2_var<2; t2_var=t2_var+1) begin: t2_loop
  assign t2_writeA_wire[t2_var] = t2_writeA >> t2_var;
  assign t2_addrA_wire[t2_var] = t2_addrA >> (t2_var*BITVROW);
  assign t2_dinA_wire[t2_var] = t2_dinA >> (t2_var*SDOUT_WIDTH);
  assign t2_readB_wire[t2_var] = t2_readB >> t2_var;
  assign t2_addrB_wire[t2_var] = t2_addrB >> (t2_var*BITVROW);
  assign t2_doutB_wire[t2_var] = t2_doutB >> (t2_var*SDOUT_WIDTH); 
  assign t2_fwrdB_wire[t2_var] = t2_fwrdB >> t2_var;
  assign t2_serrB_wire[t2_var] = t2_serrB >> t2_var;
  assign t2_derrB_wire[t2_var] = t2_derrB >> t2_var;
  assign t2_padrB_wire[t2_var] = t2_padrB >> (t2_var*SDOUT_WIDTH);
end
endgenerate

reg [NUMPBNK-1:0] pmeminv;
reg [NUMPBNK-1:0] pmem;
integer pmem_int;
always @(posedge clk)
  if (rst)
    pmeminv <= ~0;
  else if (t1_writeA && (t1_addrA == select_row)) begin
    pmeminv[t1_bankA] <= 1'b0;
    pmem[t1_bankA] <= t1_dinA >> select_bit;
  end

reg [BITMAPT-1:0] rststate;
integer rst_int;
always_comb begin
  rststate = 0;
  for (rst_int=0; rst_int<NUMPBNK; rst_int=rst_int+1)
    rststate = rststate | (rst_int << (rst_int*BITPBNK));
end

wire [ECCBITS-1:0] rststate_ecc;
ecc_calc #(.ECCDWIDTH(BITMAPT), .ECCWIDTH(ECCBITS))
    ecc_calc_rst(.din(rststate), .eccout(rststate_ecc));

reg [SDOUT_WIDTH-1:0] smem;
integer smem_int;
always @(posedge clk)
  if (rst)
    smem <= {rststate,rststate_ecc,rststate};
  else if (t2_writeA_wire[0] && (t2_addrA_wire[0] == select_row))
      smem <= t2_dinA_wire[0];

wire [BITPBNK-1:0] smem_sel_wire = smem >> (select_bank*BITPBNK);
wire [ECCBITS-1:0] smem_ecc;
ecc_calc #(.ECCDWIDTH(BITMAPT), .ECCWIDTH(ECCBITS))
    ecc_calc_inst(.din(smem[BITMAPT-1:0]), .eccout(smem_ecc));

wire mem_wire = pmem[smem_sel_wire];

assert_smem_ecc_check: assert property (@(posedge clk) disable iff (rst) (smem == {smem[BITMAPT-1:0],smem_ecc,smem[BITMAPT-1:0]}));

assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readB && (t1_addrB == select_row)) |-> ##DRAM_DELAY
				     ($past(pmeminv[t1_bankB],DRAM_DELAY) || (t1_doutB[select_bit] == $past(pmem[t1_bankB],DRAM_DELAY))));

genvar sdout_int;
generate for (sdout_int=0; sdout_int<2; sdout_int=sdout_int+1) begin: sdout_loop
  assert_sdout_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[sdout_int] && (t2_addrB_wire[sdout_int] == select_row)) |-> ##SRAM_DELAY
                                       (t2_doutB_wire[sdout_int] == $past(smem,SRAM_DELAY)));
  assert_sdout_ecc_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[sdout_int] && (t2_addrB_wire[sdout_int] == select_row)) |-> ##SRAM_DELAY
                                           (core.sdout_out[sdout_int] == $past(smem[BITMAPT-1:0],SRAM_DELAY)));
end
endgenerate
 
genvar state_int;
generate for (state_int=0; state_int<2; state_int=state_int+1) begin: state_loop
  wire state_serr = 0;
  wire state_derr = 0;
  wire state_nerr = !state_serr && !state_derr;
  assume_state_err_check: assert property (@(posedge clk) disable iff (rst) !(state_serr && state_derr));
  assume_state_serr_check: assert property (@(posedge clk) disable iff (rst) state_serr |-> ##SRAM_DELAY
                                            core.sdo_loop[state_int].sdout_serr && !core.sdo_loop[state_int].sdout_derr);
  assume_state_derr_check: assert property (@(posedge clk) disable iff (rst) state_derr |-> ##SRAM_DELAY
                                            !core.sdo_loop[state_int].sdout_serr && core.sdo_loop[state_int].sdout_derr);
  assume_state_nerr_check: assert property (@(posedge clk) disable iff (rst) state_nerr |-> ##SRAM_DELAY
                                            !core.sdo_loop[state_int].sdout_serr && !core.sdo_loop[state_int].sdout_derr);

  assert_sdout_nerr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[state_int] && (t2_addrB_wire[state_int] == select_row) && state_nerr) |-> ##SRAM_DELAY
                                            !core.sdo_loop[state_int].sdout_ded_err && !core.sdo_loop[state_int].sdout_sec_err &&
                                            (core.sdo_loop[state_int].sdout_dup_data == core.sdo_loop[state_int].sdout_post_ecc));
  assert_sdout_serr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[state_int] && (t2_addrB_wire[state_int] == select_row) && state_serr) |-> ##SRAM_DELAY
                                            !core.sdo_loop[state_int].sdout_ded_err && (core.sdo_loop[state_int].sdout_sec_err ?
                                            (core.sdo_loop[state_int].sdout_dup_data == core.sdo_loop[state_int].sdout_post_ecc) :
                                            (core.sdo_loop[state_int].sdout_dup_data != core.sdo_loop[state_int].sdout_post_ecc)));
  assert_sdout_derr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[state_int] && (t2_addrB_wire[state_int] == select_row) && state_derr) |-> ##SRAM_DELAY
                                            core.sdo_loop[state_int].sdout_ded_err ? !core.sdo_loop[state_int].sdout_sec_err :
                                            core.sdo_loop[state_int].sdout_sec_err ? !core.sdo_loop[state_int].sdout_ded_err &&
                                                                                     (core.sdo_loop[state_int].sdout_dup_data != core.sdo_loop[state_int].sdout_post_ecc) :
                                                                                     (core.sdo_loop[state_int].sdout_dup_data != core.sdo_loop[state_int].sdout_post_ecc));
end
endgenerate

genvar fwd_int;
generate for (fwd_int=0; fwd_int<2; fwd_int=fwd_int+1) begin: fwd_loop
  assert_map_fwd_check: assert property (@(posedge clk) disable iff (rst) ((core.vread_wire[fwd_int] || core.vwrite_wire[fwd_int]) &&
                                                                           (core.vradr_wire[fwd_int] == select_row)) |-> ##SRAM_DELAY
                                         (core.map_out[fwd_int] == smem[BITMAPT-1:0]));
end
endgenerate

reg fakememinv;
reg fakemem;
always @(posedge clk)
  if (rst)
    fakememinv <= 1'b1;
  else if (write && (wr_adr == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din[select_bit];
  end

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##SRAM_DELAY
				       ($past(fakememinv,SRAM_DELAY) || ($past(fakemem,SRAM_DELAY) == mem_wire)));

assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
                                    (rd_vld && ($past(fakememinv,FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT) ||
                                                (rd_dout[select_bit] == $past(fakemem,FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)))));
assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
                                    (rd_fwrd == (FLOPOUT ? $past(t1_fwrdB) : t1_fwrdB)));
assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
                                    (rd_serr == (FLOPOUT ? $past(t1_serrB) : t1_serrB)) &&
                                    (rd_derr == (FLOPOUT ? $past(t1_derrB) : t1_derrB)));
assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
                                    (rd_padr == (FLOPOUT ? {$past(smem_sel_wire,DRAM_DELAY+FLOPOUT),$past(t1_padrB)} :
                                                           {$past(smem_sel_wire,DRAM_DELAY),t1_padrB})));

endmodule

