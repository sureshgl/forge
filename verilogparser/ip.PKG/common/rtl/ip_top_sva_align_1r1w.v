module ip_top_sva_2_align_1r1w
  #(
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
parameter     NUMSROW = 256,
parameter     BITSROW = 8)
(
  input clk,
  input rst,
  input write,
  input [BITADDR-1:0] wr_adr,
  input read,
  input [BITADDR-1:0] rd_adr,
  input mem_write,
  input [BITSROW-1:0] mem_wr_adr,
  input mem_read,
  input [BITSROW-1:0] mem_rd_adr
);

assert_rd_range_check: assume property (@(posedge clk) disable iff (rst) read |-> (rd_adr < NUMADDR));
assert_wr_range_check: assume property (@(posedge clk) disable iff (rst) write |-> (wr_adr < NUMADDR));

assert_mem_rd_range_check: assert property (@(posedge clk) disable iff (rst) mem_read |-> (mem_rd_adr < NUMSROW));
assert_mem_wr_range_check: assert property (@(posedge clk) disable iff (rst) mem_write |-> (mem_wr_adr < NUMSROW));
assert_mem_rd_wr_pseudo_check: assert property (@(posedge clk) disable iff (rst) (mem_write && mem_read) |-> (mem_wr_adr != mem_rd_adr));

endmodule


module ip_top_sva_align_1r1w
  #(
parameter     WIDTH   = 32,
parameter     PARITY  = 1,
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
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
  input [BITADDR-1:0] wr_adr,
  input [WIDTH-1:0] din,
  input read,
  input [BITADDR-1:0] rd_adr,
  input [WIDTH-1:0] rd_dout,
  input rd_serr,
  input [BITWRDS+BITSROW-1:0] rd_padr,
  input mem_write,
  input [BITSROW-1:0] mem_wr_adr,
  input [NUMWRDS*MEMWDTH-1:0] mem_bw,
  input [NUMWRDS*MEMWDTH-1:0] mem_din,
  input mem_read,
  input [BITSROW-1:0] mem_rd_adr,
  input [NUMWRDS*MEMWDTH-1:0] mem_rd_dout,
  input [BITADDR-1:0] select_addr
);

wire [BITWRDS-1:0] select_word;
wire [BITSROW-1:0] select_srow;
generate if (BITWRDS>0) begin: np2_loop
  np2_addr #(
    .NUMADDR (NUMADDR), .BITADDR (BITADDR),
    .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
    .NUMVROW (NUMSROW), .BITVROW (BITSROW))
    sel_adr (.vbadr(select_word), .vradr(select_srow), .vaddr(select_addr));
  end else begin: no_np2_loop
    assign select_word = 0;
    assign select_srow = select_addr;
  end
endgenerate

wire [MEMWDTH-1:0] mem_bw_wire = mem_bw >> select_word*MEMWDTH;
wire [MEMWDTH-1:0] mem_din_wire = mem_din >> select_word*MEMWDTH;

reg meminv;
reg [MEMWDTH-1:0] mem;
always @(posedge clk)
  if (rst)
    meminv <= 1'b1;
  else if (mem_write && (mem_wr_adr == select_srow)) begin
    meminv <= 1'b0;
    mem <= (mem_bw_wire & mem_din_wire) | (~mem_bw_wire & mem);
  end

wire [MEMWDTH-1:0] mem_dout_wire = mem_rd_dout >> select_word*MEMWDTH;

assert_mem_check: assert property (@(posedge clk) disable iff (rst) (mem_read && (mem_rd_adr == select_srow)) |-> ##SRAM_DELAY
                                   (mem_dout_wire == $past(mem,SRAM_DELAY)));

assert_mem_parity_check: assert property (@(posedge clk) disable iff (rst) ((PARITY == 0) || meminv || !(^mem)));

reg fakememinv;
reg [WIDTH-1:0] fakemem;
always @(posedge clk)
  if (rst) 
    fakememinv <= 1'b1;
  else if (write && (wr_adr == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din;
  end

wire mem_serr = 0;
wire mem_nerr = !mem_serr;
assume_mem_nerr_check: assert property (@(posedge clk) disable iff (rst) mem_nerr |-> ##(SRAM_DELAY+FLOPMEM) !core.dout_serr_mask);
assume_mem_serr_check: assert property (@(posedge clk) disable iff (rst) mem_serr |-> ##(SRAM_DELAY+FLOPMEM) core.dout_serr_mask);

assert_dout_nerr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr) && mem_nerr) |-> ##(SRAM_DELAY+FLOPMEM)
				         ($past(fakememinv,SRAM_DELAY+FLOPMEM) || (!rd_serr && (rd_dout == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM)))));
assert_dout_serr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr) && mem_serr) |-> ##(SRAM_DELAY+FLOPMEM)
					 (PARITY ? ($past(fakememinv,SRAM_DELAY+FLOPMEM) || rd_serr) : !rd_serr));
assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr==select_addr)) |-> ##(SRAM_DELAY+FLOPMEM)
				    (rd_padr == {select_word,select_srow}));

endmodule
