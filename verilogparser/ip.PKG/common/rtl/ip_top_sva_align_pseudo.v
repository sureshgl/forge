module ip_top_sva_2_align_pseudo
  #(
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     NUMSROW = 256,
parameter     BITSROW = 8)
(
  input clk,
  input rst,
  input write,
  input [BITVBNK-1:0] wr_bnk,
  input [BITVROW-1:0] wr_adr,
  input read,
  input [BITVBNK-1:0] rd_bnk,
  input [BITVROW-1:0] rd_adr,
  input mem_write,
  input [BITVBNK-1:0] mem_wr_bnk,
  input [BITSROW-1:0] mem_wr_adr,
  input mem_read,
  input [BITVBNK-1:0] mem_rd_bnk,
  input [BITSROW-1:0] mem_rd_adr
);

assert_rd_range_check: assume property (@(posedge clk) disable iff (rst) read |-> (rd_bnk < NUMVBNK) && (rd_adr < NUMVROW));
assert_wr_range_check: assume property (@(posedge clk) disable iff (rst) write |-> (wr_bnk < NUMVBNK) && (wr_adr < NUMVROW));
assert_rw_pseudo_check: assume property (@(posedge clk) disable iff (rst) (read && write) |-> (rd_bnk != wr_bnk));

assert_mem_rd_range_check: assume property (@(posedge clk) disable iff (rst) mem_read |-> (mem_rd_bnk < NUMVBNK) && (mem_rd_adr < NUMSROW));
assert_mem_wr_range_check: assume property (@(posedge clk) disable iff (rst) mem_write |-> (mem_wr_bnk < NUMVBNK) && (mem_wr_adr < NUMSROW));
assert_mem_rw_pseudo_check: assume property (@(posedge clk) disable iff (rst) (mem_read && mem_write) |-> (mem_rd_bnk != mem_wr_bnk));

endmodule


module ip_top_sva_align_pseudo
  #(
parameter     WIDTH   = 32,
parameter     PARITY  = 1,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     NUMWRDS = 4,
parameter     BITWRDS = 2,
parameter     NUMSROW = 256,
parameter     BITSROW = 8,
parameter     SRAM_DELAY = 2,
parameter     FLOPMEM = 0,
parameter     MEMWDTH = WIDTH+PARITY
   )
(
  input clk,
  input rst,
  input write,
  input [BITVBNK-1:0] wr_bnk,
  input [BITVROW-1:0] wr_adr,
  input [WIDTH-1:0] din,
  input read,
  input [BITVBNK-1:0] rd_bnk,
  input [BITVROW-1:0] rd_adr,
  input [WIDTH-1:0] dout,
  input serr,
  input [BITWRDS+BITSROW-1:0] padr,
  input mem_write,
  input [BITVBNK-1:0] mem_wr_bnk,
  input [BITSROW-1:0] mem_wr_adr,
  input [NUMWRDS*MEMWDTH-1:0] mem_bw,
  input [NUMWRDS*MEMWDTH-1:0] mem_din,
  input mem_read,
  input [BITVBNK-1:0] mem_rd_bnk,
  input [BITSROW-1:0] mem_rd_adr,
  input [NUMWRDS*MEMWDTH-1:0] mem_dout,
  input [BITVBNK-1:0] select_bank,
  input [BITVROW-1:0] select_vrow
);

wire [BITWRDS-1:0] select_word;
wire [BITSROW-1:0] select_srow;
generate if (BITWRDS>0) begin: np2_loop
  np2_addr #(
    .NUMADDR (NUMVROW), .BITADDR (BITVROW),
    .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
    .NUMVROW (NUMSROW), .BITVROW (BITSROW))
    sel_adr (.vbadr(select_word), .vradr(select_srow), .vaddr(select_vrow));
  end else begin: no_np2_loop
    assign select_word = 0;
    assign select_srow = select_vrow;
  end
endgenerate

wire [MEMWDTH-1:0] mem_bw_wire = mem_bw >> select_word*MEMWDTH;
wire [MEMWDTH-1:0] mem_din_wire = mem_din >> select_word*MEMWDTH;

reg meminv;
reg [MEMWDTH-1:0] mem;
always @(posedge clk)
  if (rst)
    meminv <= 1'b1;
  else if (mem_write && (mem_wr_bnk == select_bank) && (mem_wr_adr == select_srow)) begin
    meminv <= 1'b0;
    mem <= (mem_bw_wire & mem_din_wire) | (~mem_bw_wire & mem);
  end

wire [MEMWDTH-1:0] mem_dout_wire = mem_dout >> select_word*MEMWDTH;

assert_mem_check: assert property (@(posedge clk) disable iff (rst) (mem_read && (mem_rd_bnk == select_bank) && (mem_rd_adr == select_srow)) |-> ##SRAM_DELAY
                                   ($past(meminv,SRAM_DELAY) || (mem_dout_wire == $past(mem,SRAM_DELAY))));

assert_mem_parity_check: assert property (@(posedge clk) disable iff (rst) ((PARITY == 0) || !(^mem)));

reg fakememinv;
reg [MEMWDTH-1:0] fakemem;
always @(posedge clk)
  if (rst) 
    fakememinv <= 1'b1;
  else if (write && (wr_bnk == select_bank) && (wr_adr == select_vrow)) begin
    fakememinv <= 1'b0;
    fakemem <= {^din,din};
  end

wire mem_serr = 0;
wire mem_nerr = !mem_serr;
assume_mem_nerr_check: assert property (@(posedge clk) disable iff (rst) mem_nerr |-> ##(SRAM_DELAY+FLOPMEM) !core.dout_serr_mask);
assume_mem_serr_check: assert property (@(posedge clk) disable iff (rst) mem_serr |-> ##(SRAM_DELAY+FLOPMEM) core.dout_serr_mask);

assert_dout_nerr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_bnk == select_bank) && (rd_adr == select_vrow) && mem_nerr) |-> ##(SRAM_DELAY+FLOPMEM)
				         ($past(fakememinv,SRAM_DELAY+FLOPMEM) || (!serr && (dout == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM)))));
assert_dout_serr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_bnk == select_bank) && (rd_adr == select_vrow) && mem_serr) |-> ##(SRAM_DELAY+FLOPMEM)
                                         (PARITY ? ($past(fakememinv,SRAM_DELAY+FLOPMEM) || serr) : !serr));
assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_bnk == select_bank) && (rd_adr == select_vrow)) |-> ##(SRAM_DELAY+FLOPMEM)
                                    (NUMWRDS>1) ? (padr == {select_word,select_srow}) : (padr == {select_srow}));

endmodule
