module ip_top_sva_2_1rw1w_1rw
  #(
parameter     WIDTH   = 32,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     REFRESH = 0,
parameter     SRAM_DELAY = 2,
parameter     DRAM_DELAY = 2,
parameter     ECCBITS = 4,
parameter     SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS
   )
(
  input clk,
  input rst,
  input ready,
  input refr,
  input [1-1:0] read,
  input [2-1:0] write,
  input [2*BITADDR-1:0] addr,
  input [2*WIDTH-1:0] din,
  input [NUMVBNK-1:0] t1_readA,
  input [NUMVBNK-1:0] t1_writeA,
  input [NUMVBNK*BITVROW-1:0] t1_addrA,
  input [2-1:0] t2_writeA,
  input [2*BITVROW-1:0] t2_addrA,
  input [2*SDOUT_WIDTH-1:0] t2_dinA,
  input [2-1:0] t2_readB,
  input [2*BITVROW-1:0] t2_addrB,
  input [2-1:0] t3_writeA,
  input [2*BITVROW-1:0] t3_addrA,
  input [2*WIDTH-1:0] t3_dinA,
  input [2-1:0] t3_readB,
  input [2*BITVROW-1:0] t3_addrB
);

generate if (REFRESH) begin: refr_loop
assert_refr_noacc_check: assume property (@(posedge clk) disable iff (!ready) !(refr && (write || read)));
end
endgenerate

genvar prt_int;
generate for (prt_int=0; prt_int<2; prt_int=prt_int+1) begin: prt_loop
  wire read_wire = read >> prt_int;
  wire write_wire = write >> prt_int;
  wire [BITADDR-1:0] addr_wire = addr >> (prt_int*BITADDR);

  if (prt_int>0) begin: wr_loop
    assert_wr_range_check: assert property (@(posedge clk) disable iff (!ready) write_wire |-> (addr_wire < NUMADDR));
  end else begin: rw_loop
    assert_rw_1p_check: assert property (@(posedge clk) disable iff (!ready) !(read_wire && write_wire)); 
    assert_rw_range_check: assert property (@(posedge clk) disable iff (!ready) (read_wire || write_wire) |-> (addr_wire < NUMADDR));
  end
end
endgenerate

genvar t1_int;
generate for (t1_int=0; t1_int<NUMVBNK; t1_int=t1_int+1) begin: t1_loop
  wire t1_readA_wire = t1_readA >> t1_int;
  wire t1_writeA_wire = t1_writeA >> t1_int;
  wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> (t1_int*BITVROW);

  assert_t1_1p_check: assert property (@(posedge clk) disable iff (rst) !(t1_readA_wire && t1_writeA_wire));
  assert_t1_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire || t1_writeA_wire) |-> (t1_addrA_wire < NUMVROW));
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
  assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire |-> (t2_addrB_wire < NUMVROW));
  assert_t2_rw_psuedo_check: assert property (@(posedge clk) disable iff (rst) (t2_writeA_wire && t2_readB_wire) |-> (t2_addrA_wire != t2_addrB_wire));
end
endgenerate

genvar t3_int;
generate for (t3_int=0; t3_int<2; t3_int=t3_int+1) begin: t3_loop
  wire t3_writeA_wire = t3_writeA >> t3_int;
  wire [BITVROW-1:0] t3_addrA_wire = t3_addrA >> (t3_int*BITVROW);
  wire [WIDTH-1:0] t3_dinA_wire = t3_dinA >> (t3_int*WIDTH);

  wire t3_writeA_0_wire = t3_writeA;
  wire [BITVROW-1:0] t3_addrA_0_wire = t3_addrA;
  wire [WIDTH-1:0] t3_dinA_0_wire = t3_dinA;

  wire t3_readB_wire = t3_readB >> t3_int;
  wire [BITVROW-1:0] t3_addrB_wire = t3_addrB >> (t3_int*BITVROW);

  assert_t3_wr_same_check: assert property (@(posedge clk) disable iff (rst) t3_writeA_wire |-> (t3_writeA_0_wire &&
												 (t3_addrA_0_wire == t3_addrA_wire) &&
												 (t3_dinA_0_wire == t3_dinA_wire)));
  assert_t3_wr_range_check: assert property (@(posedge clk) disable iff (rst) t3_writeA_wire |-> (t3_addrA_wire < NUMVROW));
  assert_t3_rd_range_check: assert property (@(posedge clk) disable iff (rst) t3_readB_wire |-> (t3_addrB_wire < NUMVROW));
  assert_t3_rw_psuedo_check: assert property (@(posedge clk) disable iff (rst) (t3_writeA_wire && t3_readB_wire) |-> (t3_addrA_wire != t3_addrB_wire));
end
endgenerate

endmodule


module ip_top_sva_1rw1w_1rw
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
parameter     REFRESH = 0,
parameter     SRAM_DELAY = 2,
parameter     DRAM_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0,
parameter     ECCBITS = 4,
parameter     SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS,
parameter     FIFOCNT = 2*SRAM_DELAY+REFRESH+2
   )
(
  input clk,
  input rst,
  input [1-1:0] read,
  input [2-1:0] write,
  input [2*BITADDR-1:0] addr,
  input [2*WIDTH-1:0] din,
  input [1-1:0] rd_vld,
  input [1*WIDTH-1:0] rd_dout,
  input [1-1:0] rd_fwrd,
  input [1-1:0] rd_serr,
  input [1-1:0] rd_derr,
  input [1*BITPADR-1:0] rd_padr,
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
  input [2-1:0] t3_writeA,
  input [2*BITVROW-1:0] t3_addrA,
  input [2*WIDTH-1:0] t3_dinA,
  input [2-1:0] t3_readB,
  input [2*BITVROW-1:0] t3_addrB,
  input [2*WIDTH-1:0] t3_doutB,
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

reg read_wire [0:2-1];
reg write_wire [0:2-1];
reg [BITADDR-1:0] addr_wire [0:2-1];
reg [WIDTH-1:0] din_wire [0:2-1];
reg rd_vld_wire [0:2-1];
reg [WIDTH-1:0] rd_dout_wire [0:2-1];
reg rd_fwrd_wire [0:2-1];
reg rd_serr_wire [0:2-1];
reg rd_derr_wire [0:2-1];
reg [BITPADR-1:0] rd_padr_wire [0:2-1];
integer prt_int;
always_comb
  for (prt_int=0; prt_int<2; prt_int=prt_int+1) begin
    write_wire[prt_int] = write >> prt_int;
    addr_wire[prt_int] = addr >> (prt_int*BITADDR);
    din_wire[prt_int] = din >> (prt_int*WIDTH);
    if (prt_int<1) begin
      read_wire[prt_int] = read >> prt_int;
      rd_vld_wire[prt_int] = rd_vld >> prt_int;
      rd_dout_wire[prt_int] = rd_dout >> (prt_int*WIDTH);
      rd_fwrd_wire[prt_int] = rd_fwrd >> prt_int;
      rd_serr_wire[prt_int] = rd_serr >> prt_int;
      rd_derr_wire[prt_int] = rd_derr >> prt_int;
      rd_padr_wire[prt_int] = rd_padr >> (prt_int*BITPADR);
    end
  end

assert_rw1_wr2_np2_check: assert property (@(posedge clk) disable iff (rst) ((read_wire[0] || write_wire[0]) && write_wire[1]) |-> ##FLOPIN
				             ((core.vaddr_wire[0] == core.vaddr_wire[1]) == ((core.vbadr_wire[0] == core.vbadr_wire[1]) && (core.vradr_wire[0] == core.vradr_wire[1]))));
assert_rw1_sl_np2_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] || write_wire[0]) |-> ##FLOPIN
					  ((core.vaddr_wire[0] == select_addr) == ((core.vbadr_wire[0] == select_bank) && (core.vradr_wire[0] == select_row)))); 
assert_wr2_sl_np2_check: assert property (@(posedge clk) disable iff (rst) write_wire[1] |-> ##FLOPIN
					  ((core.vaddr_wire[1] == select_addr) == ((core.vbadr_wire[1] == select_bank) && (core.vradr_wire[1] == select_row)))); 

assert_rw1_np2_range_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] || write_wire[0]) |-> ##FLOPIN
					     ((core.vbadr_wire[0] < NUMVBNK) && (core.vradr_wire[0] < NUMVROW)));
assert_wr2_np2_range_check: assert property (@(posedge clk) disable iff (rst) write_wire[1] |-> ##FLOPIN
					     ((core.vbadr_wire[1] < NUMVBNK) && (core.vradr_wire[1] < NUMVROW)));
assert_sl_np2_range_check: assert property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR) |-> ##FLOPIN
					    ((select_bank < NUMVBNK) && (select_row < NUMVROW))); 

wire t1_readA_sel_wire = t1_readA >> select_bank;
wire t1_writeA_sel_wire = t1_writeA >> select_bank;
wire [BITVROW-1:0] t1_addrA_sel_wire = t1_addrA >> (select_bank*BITVROW);
wire [WIDTH-1:0] t1_dinA_sel_wire = t1_dinA >> (select_bank*WIDTH);
wire [WIDTH-1:0] t1_doutA_sel_wire = t1_doutA >> (select_bank*WIDTH);
wire [BITPADR-BITPBNK-1:0] t1_padrA_sel_wire = t1_padrA >> (select_bank*(BITPADR-BITPBNK));

wire t2_writeA_sel_wire = t2_writeA;
wire [BITVROW-1:0] t2_addrA_sel_wire = t2_addrA;
wire [SDOUT_WIDTH-1:0] t2_dinA_sel_wire = t2_dinA; 
wire t2_readB_0_wire = t2_readB;
wire [BITVROW-1:0] t2_addrB_0_wire = t2_addrB;
wire [SDOUT_WIDTH-1:0] t2_doutB_0_wire = t2_doutB; 
wire t2_readB_1_wire = t2_readB >> 1;
wire [BITVROW-1:0] t2_addrB_1_wire = t2_addrB >> (1*BITVROW);
wire [SDOUT_WIDTH-1:0] t2_doutB_1_wire = t2_doutB >> (1*SDOUT_WIDTH); 

wire t3_writeA_sel_wire = t3_writeA;
wire [BITVROW-1:0] t3_addrA_sel_wire = t3_addrA;
wire [WIDTH-1:0] t3_dinA_sel_wire = t3_dinA; 
wire t3_readB_0_wire = t3_readB;
wire [BITVROW-1:0] t3_addrB_0_wire = t3_addrB;
wire [WIDTH-1:0] t3_doutB_0_wire = t3_doutB; 
wire t3_readB_1_wire = t3_readB >> 1;
wire [BITVROW-1:0] t3_addrB_1_wire = t3_addrB >> (1*BITVROW);
wire [WIDTH-1:0] t3_doutB_1_wire = t3_doutB >> (1*WIDTH); 

reg pmeminv;
reg pmem;
always @(posedge clk)
  if (rst)
    pmeminv <= 1'b1;
  else if (t1_writeA_sel_wire && (t1_addrA_sel_wire == select_row)) begin
    pmeminv <= 1'b0;
    pmem <= t1_dinA_sel_wire >> select_bit;
  end

reg [SDOUT_WIDTH-1:0] smem;
always @(posedge clk)
  if (rst)
    smem <= 0;
  else if (t2_writeA_sel_wire && (t2_addrA_sel_wire == select_row))
    smem <= t2_dinA_sel_wire;

wire [ECCBITS-1:0] smem_ecc;
ecc_calc   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
    ecc_calc_inst (.din(smem[BITVBNK:0]), .eccout(smem_ecc));

reg cmem;
always @(posedge clk)
  if (rst)
    cmem <= 0;
  else if (t3_writeA[0] && (t3_addrA_sel_wire == select_row))
    cmem <= t3_dinA_sel_wire >> select_bit;

wire mem_wire = (smem[BITVBNK] && (smem[BITVBNK-1:0] == select_bank)) ? cmem : pmem;

assert_smem_ecc_check: assert property (@(posedge clk) disable iff (rst) (smem == {smem[BITVBNK:0],smem_ecc,smem[BITVBNK:0]}));


assert_pdout1_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_sel_wire && (t1_addrA_sel_wire == select_row)) |-> ##DRAM_DELAY
				      ($past(pmeminv,DRAM_DELAY) || (t1_doutA_sel_wire[select_bit] == $past(pmem,DRAM_DELAY))));

assert_sdout1_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_0_wire && (t2_addrB_0_wire == select_row)) |-> ##SRAM_DELAY
				      (t2_doutB_0_wire == $past(smem,SRAM_DELAY)));
assert_sdout2_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_1_wire && (t2_addrB_1_wire == select_row)) |-> ##SRAM_DELAY
				      (t2_doutB_1_wire == $past(smem,SRAM_DELAY)));

assert_cdout1_check: assert property (@(posedge clk) disable iff (rst) (t3_readB_0_wire && (t3_addrB_0_wire == select_row)) |-> ##SRAM_DELAY
				      (t3_doutB_0_wire[select_bit] == $past(cmem,SRAM_DELAY)));
assert_cdout2_check: assert property (@(posedge clk) disable iff (rst) (t3_readB_1_wire && (t3_addrB_1_wire == select_row)) |-> ##SRAM_DELAY
				      (t3_doutB_1_wire[select_bit] == $past(cmem,SRAM_DELAY)));

assert_sdout1_ecc_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_0_wire && (t2_addrB_0_wire == select_row)) |-> ##SRAM_DELAY
				          (core.sdout1_out == $past(smem[BITVBNK:0],SRAM_DELAY)));
assert_sdout2_ecc_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_1_wire && (t2_addrB_1_wire == select_row)) |-> ##SRAM_DELAY
				          (core.sdout2_out == $past(smem[BITVBNK:0],SRAM_DELAY)));

wire state1_serr = 0;
wire state1_derr = 0;
wire state1_nerr = !state1_serr && !state1_derr;
assume_state1_err_check: assert property (@(posedge clk) disable iff (rst) !(state1_serr && state1_derr));
assume_state1_serr_check: assert property (@(posedge clk) disable iff (rst) state1_serr |-> ##SRAM_DELAY core.sdout1_serr && !core.sdout1_derr);
assume_state1_derr_check: assert property (@(posedge clk) disable iff (rst) state1_derr |-> ##SRAM_DELAY !core.sdout1_serr && core.sdout1_derr);
assume_state1_nerr_check: assert property (@(posedge clk) disable iff (rst) state1_nerr |-> ##SRAM_DELAY !core.sdout1_serr && !core.sdout1_derr);

assert_sdout1_nerr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_0_wire && (t2_addrB_0_wire == select_row) && state1_nerr) |-> ##SRAM_DELAY
					   !core.sdout1_ded_err && !core.sdout1_sec_err && (core.sdout1_dup_data == core.sdout1_post_ecc));
assert_sdout1_serr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_0_wire && (t2_addrB_0_wire == select_row) && state1_serr) |-> ##SRAM_DELAY
					   !core.sdout1_ded_err && (core.sdout1_sec_err ? (core.sdout1_dup_data == core.sdout1_post_ecc) :
										          (core.sdout1_dup_data != core.sdout1_post_ecc)));
assert_sdout1_derr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_0_wire && (t2_addrB_0_wire == select_row) && state1_derr) |-> ##SRAM_DELAY
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

assert_sdout2_nerr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_1_wire && (t2_addrB_1_wire == select_row) && state2_nerr) |-> ##SRAM_DELAY
					   !core.sdout2_ded_err && !core.sdout2_sec_err && (core.sdout2_dup_data == core.sdout2_post_ecc));
assert_sdout2_serr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_1_wire && (t2_addrB_1_wire == select_row) && state2_serr) |-> ##SRAM_DELAY
					   !core.sdout2_ded_err && (core.sdout2_sec_err ? (core.sdout2_dup_data == core.sdout2_post_ecc) :
										          (core.sdout2_dup_data != core.sdout2_post_ecc)));
assert_sdout2_derr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_1_wire && (t2_addrB_1_wire == select_row) && state2_derr) |-> ##SRAM_DELAY
					   core.sdout2_ded_err ? !core.sdout2_sec_err :
					   core.sdout2_sec_err ? !core.sdout2_ded_err && (core.sdout2_dup_data != core.sdout2_post_ecc) :
							         (core.sdout2_dup_data != core.sdout2_post_ecc));

generate if (SRAM_DELAY==DRAM_DELAY) begin: sym_loop
  assert_rmap1_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[0] && (core.vradr_wire[0] == select_row)) |-> ##DRAM_DELAY
                                           (core.rmap1_out == smem[BITVBNK:0]));
  assert_rcdat1_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[0] && (core.vradr_wire[0] == select_row)) |-> ##DRAM_DELAY
                                            (core.rcdat1_out[select_bit] == cmem));
  assert_rpdat1_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[0] && (core.vaddr_wire[0] == select_addr)) |-> ##DRAM_DELAY
                                            (pmeminv || (core.rpdat1_out[select_bit] == pmem)));
end else begin: asym_loop
  assert_rmap1_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[0] && (core.vradr_wire[0] == select_row)) |-> ##DRAM_DELAY
                                           (core.rmap1_out == $past(smem[BITVBNK:0],DRAM_DELAY-SRAM_DELAY)));
  assert_rcdat1_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[0] && (core.vradr_wire[0] == select_row)) |-> ##DRAM_DELAY
                                            (core.rcdat1_out[select_bit] == $past(cmem,DRAM_DELAY-SRAM_DELAY)));
  assert_rpdat1_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[0] && (core.vaddr_wire[0] == select_addr)) |-> ##DRAM_DELAY
                                            ($past(pmeminv,DRAM_DELAY-SRAM_DELAY) || (core.rpdat1_out[select_bit] == $past(pmem,DRAM_DELAY-SRAM_DELAY))));
end
endgenerate

assert_wmap1_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[0] && (core.vradr_wire[0] == select_row)) |-> ##SRAM_DELAY
                                         (core.wmap1_out == smem[BITVBNK:0]));
assert_wcdat1_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[0] && (core.vradr_wire[0] == select_row)) |-> ##SRAM_DELAY
                                          (core.wcdat1_out[select_bit] == cmem));
assert_wmap2_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[1] && (core.vradr_wire[1] == select_row)) |-> ##SRAM_DELAY
                                         (core.wmap2_out == smem[BITVBNK:0]));
assert_wcdat2_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[1] && (core.vradr_wire[1] == select_row)) |-> ##SRAM_DELAY
                                          (core.wcdat2_out[select_bit] == cmem));

assert_sold1_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.snew_vld1 && (core.snew_row1 == select_row)) |->
					 (({core.sold_vld1,core.sold_map1} == smem[BITVBNK:0]) && (core.sold_dat1[select_bit] == cmem)));
assert_sold2_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.snew_vld2 && (core.snew_row2 == select_row)) |->
					 (({core.sold_vld2,core.sold_map2} == smem[BITVBNK:0]) && (core.sold_dat2[select_bit] == cmem)));
assert_wrfifo_check: assert property (@(posedge clk) disable iff (rst) (core.wrfifo_cnt <= FIFOCNT));

reg rmeminv;
reg rmem;
always @(posedge clk)
  if (rst)
    rmeminv <= 1'b1;
  else if (core.snew_vld2 && (core.snew_map2 == select_bank) && (core.snew_row2 == select_row)) begin
    rmeminv <= 1'b0;
    rmem <= core.snew_dat2[select_bit];
  end else if (core.snew_vld1 && (core.snew_map1 == select_bank) && (core.snew_row1 == select_row)) begin
    rmeminv <= 1'b0;
    rmem <= core.snew_dat1[select_bit];
  end

assert_rmem_check: assert property (@(posedge clk) disable iff (rst) (rmeminv || (mem_wire == rmem)));

generate if (SRAM_DELAY==DRAM_DELAY) begin: vdout_sym_loop
  assert_vdout_int_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] && (addr_wire[0] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY)
                                           (rmeminv || (core.vdout_int[select_bit] == rmem)));
end else begin: vdout_asym_loop
  assert_vdout_int_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] && (addr_wire[0] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY)
                                           ($past(rmeminv,DRAM_DELAY-SRAM_DELAY) || (core.vdout_int[select_bit] == $past(rmem,DRAM_DELAY-SRAM_DELAY))));
end
endgenerate


reg vmeminv;
reg vmem;
always @(posedge clk)
  if (rst)
    vmeminv <= 1'b1;
  else if (core.vwrite2_out && (core.vwrbadr2_out == select_bank) && (core.vwrradr2_out == select_row)) begin
    vmeminv <= 1'b0;
    vmem <= core.vdin2_out[select_bit];
  end else if (core.vwrite1_out && (core.vwrbadr1_out == select_bank) && (core.vwrradr1_out == select_row)) begin
    vmeminv <= 1'b0;
    vmem <= core.vdin1_out[select_bit];
  end

assert_vmem_check: assert property (@(posedge clk) disable iff (rst) (vmeminv || ((core.wr_srch_flags ? core.wr_srch_datas[select_bit] : rmem) == vmem)));

assert_srch_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] && (addr_wire[0] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY)
                                    (vmeminv || (rmeminv ? (core.wr_srch_flag1 && (core.wr_srch_data1[select_bit] == vmem)) :
                                                           ((core.wr_srch_flag1 ? core.wr_srch_data1[select_bit] : rmem) == vmem))));

reg fakemem;
reg fakememinv;
always @(posedge clk)
  if (rst)
    fakememinv <= 1'b1;
  else if (write_wire[1] && (addr_wire[1] == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din_wire[1][select_bit];
  end else if (write_wire[0] && (addr_wire[0] == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din_wire[0][select_bit];
  end

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##(FLOPIN+SRAM_DELAY)
				       ($past(fakememinv,FLOPIN+SRAM_DELAY) || ($past(fakemem,FLOPIN+SRAM_DELAY) == vmem)));

assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] && (addr_wire[0] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
                                    (rd_vld_wire[0] && ($past(fakememinv,FLOPIN+DRAM_DELAY+FLOPOUT) || (rd_dout_wire[0][select_bit] == $past(fakemem,FLOPIN+DRAM_DELAY+FLOPOUT)))));

assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] && (addr_wire[0] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
                                    (rd_fwrd_wire[0] || ($past(fakememinv,FLOPIN+DRAM_DELAY+FLOPOUT)) ||
                                     ((rd_padr_wire[0][BITPADR-1:BITPADR-BITPBNK] != NUMVBNK) &&
                                      (rd_dout_wire[0][select_bit] == (FLOPOUT ? $past(t1_doutA_sel_wire[select_bit]) : t1_doutA_sel_wire[select_bit]))) ||
                                     ((rd_padr_wire[0][BITPADR-1:BITPADR-BITPBNK] == NUMVBNK) &&
                                      (rd_dout_wire[0][select_bit] == (FLOPOUT ? $past(t3_doutB_0_wire[select_bit]) : t3_doutB_0_wire[select_bit])))));

assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] && (addr_wire[0] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
                                    ((rd_padr_wire[0] == ((NUMVBNK << (BITPADR-BITPBNK)) | select_row)) ||
                                    (rd_padr_wire[0] == {select_bank,(FLOPOUT ? $past(t1_padrA_sel_wire) : t1_padrA_sel_wire)})));

endmodule

