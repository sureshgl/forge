module ip_top_sva_2_align_1r1wa_ramwrap
  #(
parameter     ENAPSDO = 0,
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
parameter     NUMSROW = 256,
parameter     BITSROW = 8)
(
  input rd_clk,
  input rd_rst,
  input wr_clk,
  input wr_rst,
  input write,
  input [BITADDR-1:0] wr_adr,
  input read,
  input [BITADDR-1:0] rd_adr,
  input mem_write,
  input [BITSROW-1:0] mem_wr_adr,
  input mem_read,
  input [BITSROW-1:0] mem_rd_adr
);
`ifdef FORMAL
//synopsys translate_off
assert_rd_range_check: assume property (@(posedge rd_clk) disable iff (rd_rst) read |-> (rd_adr < NUMADDR));
assert_wr_range_check: assume property (@(posedge wr_clk) disable iff (wr_rst) write |-> (wr_adr < NUMADDR));

assert_mem_rd_range_check: assert property (@(posedge rd_clk) disable iff (rd_rst) mem_read |-> (mem_rd_adr < NUMSROW));
assert_mem_wr_range_check: assert property (@(posedge wr_clk) disable iff (wr_rst) mem_write |-> (mem_wr_adr < NUMSROW));
//assert_mem_rd_wr_pseudo_check: assert property (@(posedge clk) disable iff (rst) (ENAPSDO && mem_write && mem_read) |-> (mem_wr_adr != mem_rd_adr));
//synopsys translate_on
`endif
endmodule


module ip_top_sva_align_1r1wa_ramwrap
  #(
parameter     WIDTH   = 32,
parameter     ENAPSDO = 0,
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
parameter     NUMWRDS = 4,
parameter     BITWRDS = 2,
parameter     NUMSROW = 256,
parameter     BITSROW = 8,
parameter     SRAM_DELAY = 2,
parameter     FLOPGEN = 0,
parameter     FLOPCMD = 0,
parameter     FLOPMEM = 0,
parameter     FLOPOUT = 0,
parameter     MEMWDTH = WIDTH
   )
(
  input wr_clk,
  input wr_rst,
  input rd_clk,
  input rd_rst,
  input write,
  input [BITADDR-1:0] wr_adr,
  input [WIDTH-1:0] din,
  input [WIDTH-1:0] bw,
  input read,
  input [BITADDR-1:0] rd_adr,
  input [WIDTH-1:0] rd_dout,
  input mem_write,
  input [BITSROW-1:0] mem_wr_adr,
  input [NUMWRDS*MEMWDTH-1:0] mem_bw,
  input [NUMWRDS*MEMWDTH-1:0] mem_din,
  input mem_read,
  input [BITSROW-1:0] mem_rd_adr,
  input [NUMWRDS*MEMWDTH-1:0] mem_rd_dout,
  input [BITADDR-1:0] select_addr
);
`ifdef FORMAL
//synopsys translate_off

wire [BITWRDS-1:0] select_word;
wire [BITSROW-1:0] select_srow;
generate if (BITWRDS>0) begin: np2_loop
  np2_addr_ramwrap #(
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

reg [MEMWDTH-1:0] meminv;
reg [MEMWDTH-1:0] mem;
always @(posedge wr_clk)
  if (wr_rst) begin
    meminv <= {MEMWDTH{1'b1}};
  end else if (mem_write && (mem_wr_adr == select_srow)) begin
    meminv <= (~mem_bw_wire & meminv);
    mem <= (mem_bw_wire & mem_din_wire) | (~mem_bw_wire & mem);
  end

wire [MEMWDTH-1:0] mem_dout_wire = mem_rd_dout >> select_word*MEMWDTH;
generate if (SRAM_DELAY > 0) begin :d_loop
assert_mem_check: assert property (@(posedge rd_clk) disable iff (rd_rst) (mem_read && (mem_rd_adr == select_srow)) |-> ##SRAM_DELAY
                                   (($past(~meminv,SRAM_DELAY) & mem_dout_wire) == ($past(~meminv,SRAM_DELAY) & $past(mem,SRAM_DELAY))));
end else begin : nd_loop
assert_mem_check: assert property (@(posedge rd_clk) disable iff (rd_rst) (mem_read && (mem_rd_adr == select_srow)) |-> ##SRAM_DELAY
                                   ((~meminv & mem_dout_wire) == (~meminv & mem)));
end
endgenerate

reg [WIDTH-1:0] fakememinv;
reg [WIDTH-1:0] fakemem;
always @(posedge wr_clk)
  if (wr_rst) begin
    fakememinv <= {WIDTH{1'b1}};
  end else if (write && (wr_adr == select_addr)) begin
    fakememinv <= (~bw & fakememinv);
    fakemem    <= (fakemem & ~bw) | (din & bw);
  end

generate if (SRAM_DELAY > 0) begin : dl_loop
assert_dout_check: assert property (@(posedge rd_clk) disable iff (rd_rst) (read && (rd_adr == select_srow)) |-> ##SRAM_DELAY
                                   (($past(~fakememinv,SRAM_DELAY) & rd_dout) == ($past(~fakememinv,SRAM_DELAY) & $past(fakemem,SRAM_DELAY))));
end else begin : ndl_loop
assert_dout_check: assert property (@(posedge rd_clk) disable iff (rd_rst) (read && (rd_adr == select_srow)) |-> ##SRAM_DELAY
                                   ((~fakememinv & rd_dout) == (~fakememinv & fakemem)));
end
endgenerate
//synopsys translate_on
`endif
endmodule
