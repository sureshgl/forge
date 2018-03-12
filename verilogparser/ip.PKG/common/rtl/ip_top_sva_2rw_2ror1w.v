module ip_top_sva_2_2rw_2ror1w
  #(
parameter     WIDTH   = 32,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     ECCBITS = 4,
parameter     SDOUT_WIDTH = 12
   )
(
  input clk,
  input rst,
  input [2-1:0] read,
  input [2-1:0] write,
  input [2*BITADDR-1:0] addr,
  input [2*WIDTH-1:0] din,
  input [NUMVBNK-1:0] t1_writeA,
  input [NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMVBNK-1:0] t1_readB,
  input [NUMVBNK*BITVROW-1:0] t1_addrB,
  input [NUMVBNK-1:0] t1_readC,
  input [NUMVBNK*BITVROW-1:0] t1_addrC,
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

genvar prt_int;
generate for (prt_int=0; prt_int<2; prt_int=prt_int+1) begin: prt_loop
  wire read_wire = read >> prt_int;
  wire write_wire = write >> prt_int;
  wire [BITADDR-1:0] addr_wire = addr >> (prt_int*BITADDR);

  assert_rw_1p_check: assert property (@(posedge clk) disable iff (!ready) !(read_wire && write_wire)); 
  assert_rw_range_check: assert property (@(posedge clk) disable iff (!ready) (read_wire || write_wire) |-> (addr_wire < NUMADDR));
end
endgenerate

genvar t1_int;
generate for (t1_int=0; t1_int<NUMVBNK; t1_int=t1_int+1) begin: t1_loop
  wire t1_writeA_wire = t1_writeA >> t1_int;
  wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> (t1_int*BITVROW);
  wire t1_readB_wire = t1_readB >> t1_int;
  wire [BITVROW-1:0] t1_addrB_wire = t1_addrB >> (t1_int*BITVROW);
  wire t1_readC_wire = t1_readC >> t1_int;
  wire [BITVROW-1:0] t1_addrC_wire = t1_addrC >> (t1_int*BITVROW);

  assert_t1_2ror1w_check: assert property (@(posedge clk) disable iff (rst) !(t1_writeA_wire && (t1_readB_wire || t1_readC_wire)));
  assert_t1_wrA_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMVROW));
  assert_t1_rdB_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> (t1_addrB_wire < NUMVROW));
  assert_t1_rdC_range_check: assert property (@(posedge clk) disable iff (rst) t1_readC_wire |-> (t1_addrC_wire < NUMVROW));
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


module ip_top_sva_2rw_2ror1w
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     ECCDWIDTH = 4,
parameter     ECCBITS = 4,
parameter     SDOUT_WIDTH = 12,
parameter     SRAM_DELAY = 2,
parameter     DRAM_DELAY = 2
   )
(
  input clk,
  input rst,
  input [2-1:0] read,
  input [2-1:0] write,
  input [2*BITADDR-1:0] addr,
  input [2*WIDTH-1:0] din,
  input [2-1:0] rd_vld,
  input [2*WIDTH-1:0] rd_dout,
  input [NUMVBNK-1:0] t1_writeA,
  input [NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMVBNK-1:0] t1_readB,
  input [NUMVBNK*BITVROW-1:0] t1_addrB,
  input [NUMVBNK*WIDTH-1:0] t1_doutB,
  input [NUMVBNK-1:0] t1_readC,
  input [NUMVBNK*BITVROW-1:0] t1_addrC,
  input [NUMVBNK*WIDTH-1:0] t1_doutC,
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
integer prt_int;
always_comb
  for (prt_int=0; prt_int<2; prt_int=prt_int+1) begin
    read_wire[prt_int] = read >> prt_int;
    write_wire[prt_int] = write >> prt_int;
    addr_wire[prt_int] = addr >> (prt_int*BITADDR);
    din_wire[prt_int] = din >> (prt_int*WIDTH);
    rd_vld_wire[prt_int] = rd_vld >> prt_int;
    rd_dout_wire[prt_int] = rd_dout >> (prt_int*WIDTH);
  end

assert_rw1_rw2_np2_check: assert property (@(posedge clk) disable iff (rst) ((read_wire[0] || write_wire[0]) && (read_wire[1] || write_wire[1])) |->
				       ((addr_wire[0] == addr_wire[1]) == ((core.vbadr_wire[0] == core.vbadr_wire[1]) && (core.vradr_wire[0] == core.vradr_wire[1]))));
assert_rw1_sl_np2_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] || write_wire[0]) |->
					  ((addr_wire[0] == select_addr) == ((core.vbadr_wire[0] == select_bank) && (core.vradr_wire[0] == select_row)))); 
assert_rw2_sl_np2_check: assert property (@(posedge clk) disable iff (rst) (read_wire[1] || write_wire[1]) |->
					  ((addr_wire[1] == select_addr) == ((core.vbadr_wire[1] == select_bank) && (core.vradr_wire[1] == select_row)))); 

assert_rw1_np2_range_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] || write_wire[0]) |->
					     ((core.vbadr_wire[0] < NUMVBNK) && (core.vradr_wire[0] < NUMVROW)));
assert_rw2_np2_range_check: assert property (@(posedge clk) disable iff (rst) (read_wire[1] || write_wire[1]) |->
					     ((core.vbadr_wire[1] < NUMVBNK) && (core.vradr_wire[1] < NUMVROW)));
assert_sl_np2_range_check: assert property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR) |->
					    ((select_bank < NUMVBNK) && (select_row < NUMVROW))); 

wire t1_writeA_sel_wire = t1_writeA >> select_bank;
wire [BITVROW-1:0] t1_addrA_sel_wire = t1_addrA >> (select_bank*BITVROW);
wire [WIDTH-1:0] t1_dinA_sel_wire = t1_dinA >> (select_bank*WIDTH);
wire t1_readB_sel_wire = t1_readB >> select_bank;
wire [BITVROW-1:0] t1_addrB_sel_wire = t1_addrB >> (select_bank*BITVROW);
wire [WIDTH-1:0] t1_doutB_sel_wire = t1_doutB >> (select_bank*WIDTH);
wire t1_readC_sel_wire = t1_readC >> select_bank;
wire [BITVROW-1:0] t1_addrC_sel_wire = t1_addrC >> (select_bank*BITVROW);
wire [WIDTH-1:0] t1_doutC_sel_wire = t1_doutC >> (select_bank*WIDTH);

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

reg pmem;
always @(posedge clk)
  if (rst)
    pmem <= 1'b0;
  else if (t1_writeA_sel_wire && (t1_addrA_sel_wire == select_row))
    pmem <= t1_dinA_sel_wire >> select_bit;

reg [SDOUT_WIDTH-1:0] smem;
always @(posedge clk)
  if (rst)
    smem <= 0;
  else if (t2_writeA_sel_wire && (t2_addrA_sel_wire == select_row))
    smem <= t2_dinA_sel_wire;

wire [ECCBITS-1:0] smem_ecc;
ecc_calc   #(.ECCDWIDTH(ECCDWIDTH), .ECCWIDTH(ECCBITS))
    ecc_calc_inst (.din(smem[BITVBNK:0]), .eccout(smem_ecc));

reg cmem;
always @(posedge clk)
  if (rst)
    cmem <= 0;
  else if (t3_writeA[0] && (t3_addrA_sel_wire == select_row))
    cmem <= t3_dinA_sel_wire >> select_bit;

wire mem_wire = (smem[BITVBNK] && (smem[BITVBNK-1:0] == select_bank)) ? cmem : pmem;

assert_smem_ecc_check: assert property (@(posedge clk) disable iff (rst) (smem == {smem[BITVBNK:0],smem_ecc,smem[BITVBNK:0]}));


assert_pdout1_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_sel_wire && (t1_addrB_sel_wire == select_row)) |-> ##DRAM_DELAY
				      (t1_doutB_sel_wire[select_bit] == $past(pmem,DRAM_DELAY)));
assert_pdout2_check: assert property (@(posedge clk) disable iff (rst) (t1_readC_sel_wire && (t1_addrC_sel_wire == select_row)) |-> ##DRAM_DELAY
				      (t1_doutC_sel_wire[select_bit] == $past(pmem,DRAM_DELAY)));

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
assert_map1_fwd_check: assert property (@(posedge clk) disable iff (rst) ((read_wire[0] || write_wire[0]) && (core.vradr_wire[0] == select_row)) |-> ##SRAM_DELAY
                                        (core.map1_out == smem[BITVBNK:0]));
assert_cdat1_fwd_check: assert property (@(posedge clk) disable iff (rst) ((read_wire[0] || write_wire[0]) && (core.vradr_wire[0] == select_row)) |-> ##SRAM_DELAY
                                         (core.cdat1_out[select_bit] == cmem));
assert_pdat1_fwd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] && (core.vbadr_wire[0] == select_bank) && (core.vradr_wire[0] == select_row)) |-> ##DRAM_DELAY
                                         (core.pdat1_out[select_bit] == pmem));

assert_map2_fwd_check: assert property (@(posedge clk) disable iff (rst) ((read_wire[1] || write_wire[1]) && (core.vradr_wire[1] == select_row)) |-> ##SRAM_DELAY
                                        (core.map2_out == smem[BITVBNK:0]));
assert_cdat2_fwd_check: assert property (@(posedge clk) disable iff (rst) ((read_wire[1] || write_wire[1]) && (core.vradr_wire[1] == select_row)) |-> ##SRAM_DELAY
                                         (core.cdat2_out[select_bit] == cmem));
assert_pdat2_fwd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[1] && (core.vbadr_wire[1] == select_bank) && (core.vradr_wire[1] == select_row)) |-> ##DRAM_DELAY
                                         (core.pdat2_out[select_bit] == pmem));

assert_sold1_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.snew_vld1 && (core.snew_row1 == select_row)) |->
					 (({core.sold_vld1,core.sold_map1} == smem[BITVBNK:0]) && (core.sold_dat1[select_bit] == cmem)));
assert_sold2_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.snew_vld2 && (core.snew_row2 == select_row)) |->
					 (({core.sold_vld2,core.sold_map2} == smem[BITVBNK:0]) && (core.sold_dat2[select_bit] == cmem)));

reg rmem;
always @(posedge clk)
  if (rst)
    rmem <= 0;
  else if (core.snew_vld2 && (core.snew_map2 == select_bank) && (core.snew_row2 == select_row))
    rmem <= core.snew_dat2[select_bit];
  else if (core.snew_vld1 && (core.snew_map1 == select_bank) && (core.snew_row1 == select_row))
    rmem <= core.snew_dat1[select_bit];

assert_rmem_check: assert property (@(posedge clk) disable iff (rst) (mem_wire == rmem));

reg vmem;
always @(posedge clk)
  if (rst)
    vmem <= 0;
  else if (core.vwrite2_out && (core.vbadr2_out == select_bank) && (core.vradr2_out == select_row))
    vmem <= core.vdin2_out[select_bit];
  else if (core.vwrite1_out && (core.vbadr1_out == select_bank) && (core.vradr1_out == select_row))
    vmem <= core.vdin1_out[select_bit];

assert_vmem_check: assert property (@(posedge clk) disable iff (rst) ((core.wr_srch_flags ? core.wr_srch_dbits : rmem) == vmem));

//assert_vdout1_int_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] && (core.vbadr_wire[0] == select_bank) && (core.vradr_wire[0] == select_row)) |-> ##SRAM_DELAY
//									    (core.vdout1_int[select_bit] == vmem));
//assert_vdout2_int_check: assert property (@(posedge clk) disable iff (rst) (read_wire[1] && (core.vbadr_wire[1] == select_bank) && (core.vradr_wire[1] == select_row)) |-> ##SRAM_DELAY
//									    (core.vdout2_int[select_bit] == vmem));

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

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##SRAM_DELAY
				       ($past(fakememinv,SRAM_DELAY) || ($past(fakemem,SRAM_DELAY) == vmem)));

assert_dout1_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] && (addr_wire[0] == select_addr)) |-> ##DRAM_DELAY
                                     (rd_vld_wire[0] && ($past(fakememinv,DRAM_DELAY) || (rd_dout_wire[0][select_bit] == $past(fakemem,DRAM_DELAY)))));
assert_dout2_check: assert property (@(posedge clk) disable iff (rst) (read_wire[1] && (addr_wire[1] == select_addr)) |-> ##DRAM_DELAY
                                     (rd_vld_wire[1] && ($past(fakememinv,DRAM_DELAY) || (rd_dout_wire[1][select_bit] == $past(fakemem,DRAM_DELAY)))));

endmodule

