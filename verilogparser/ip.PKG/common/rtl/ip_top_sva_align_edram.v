module ip_top_sva_2_align_edram
  #(parameter
     NUMADDR = 1024,
     BITADDR = 10,
     NUMRBNK = 8,
     BITRBNK = 3,
     NUMSROW = 256,
     BITSROW = 8)
(
  input clk,
  input rst,
  input read,
  input write,
  input [BITRBNK-1:0] badr,
  input [BITADDR-1:0] addr,
  input mem_read,
  input mem_write,
  input [BITRBNK-1:0] mem_badr,
  input [BITSROW-1:0] mem_addr
);

assert_rd_wr_check: assume property (@(posedge clk) disable iff (rst) !(write && read));
assert_rd_wr_range_check: assume property (@(posedge clk) disable iff (rst) (write || read) |-> (badr < NUMRBNK) && (addr < NUMADDR));

assert_mem_1port_check: assert property (@(posedge clk) disable iff (rst) !(mem_write && mem_read));
assert_mem_range_check: assert property (@(posedge clk) disable iff (rst) (mem_write || mem_read) |-> (mem_badr < NUMRBNK) && (mem_addr < NUMSROW));

endmodule


module ip_top_sva_align_edram
  #(parameter
     WIDTH   = 32,
     PARITY  = 1,
     NUMADDR = 1024,
     BITADDR = 10,
     NUMRBNK = 8,
     BITRBNK = 3,
     NUMWRDS = 4,
     BITWRDS = 2,
     NUMSROW = 256,
     BITSROW = 8,
     SRAM_DELAY = 2,
     FLOPMEM = 0,
     MEMWDTH = WIDTH+PARITY
   )
(
  input clk,
  input rst,
  input read,
  input write,
  input [BITRBNK-1:0] badr,
  input [BITADDR-1:0] addr,
  input [WIDTH-1:0] din,
  input [WIDTH-1:0] dout,
  input serr,
  input [BITRBNK+BITWRDS+BITSROW-1:0] padr,
  input mem_read,
  input mem_write,
  input [BITRBNK-1:0] mem_badr,
  input [BITSROW-1:0] mem_addr,
  input [NUMWRDS*MEMWDTH-1:0] mem_bw,
  input [NUMWRDS*MEMWDTH-1:0] mem_din,
  input [NUMWRDS*MEMWDTH-1:0] mem_dout,
  input [BITRBNK-1:0] select_rbnk,
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

reg [MEMWDTH-1:0] mem;
always @(posedge clk)
  if (rst)
    mem <= 0;
  else if (mem_write && (mem_badr == select_rbnk) && (mem_addr == select_srow))
    mem <= (mem_bw_wire & mem_din_wire) | (~mem_bw_wire & mem);

wire [MEMWDTH-1:0] mem_dout_wire = mem_dout >> select_word*MEMWDTH;

assert_mem_check: assert property (@(posedge clk) disable iff (rst) (mem_read && (mem_badr == select_rbnk) && (mem_addr == select_srow)) |-> ##SRAM_DELAY
                                   (mem_dout_wire == $past(mem,SRAM_DELAY)));

assert_mem_parity_check: assert property (@(posedge clk) disable iff (rst) ((PARITY == 0) || !(^mem)));

reg [WIDTH-1:0] fakemem;
always @(posedge clk)
  if (rst) 
    fakemem <= 0;
  else if (write && (badr == select_rbnk) && (addr == select_addr)) 
    fakemem <= din;

wire mem_serr = 0;
wire mem_nerr = !mem_serr;
assume_mem_nerr_check: assert property (@(posedge clk) disable iff (rst) mem_nerr |-> ##(SRAM_DELAY+FLOPMEM) !core.dout_serr_mask);
assume_mem_serr_check: assert property (@(posedge clk) disable iff (rst) mem_serr |-> ##(SRAM_DELAY+FLOPMEM) core.dout_serr_mask);

assert_dout_nerr_check: assert property (@(posedge clk) disable iff (rst) (read && (badr == select_rbnk) && (addr == select_addr) && mem_nerr) |-> ##(SRAM_DELAY+FLOPMEM)
				         (!serr && (dout == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM))));
assert_dout_serr_check: assert property (@(posedge clk) disable iff (rst) (read && (badr == select_rbnk) && (addr == select_addr) && mem_serr) |-> ##(SRAM_DELAY+FLOPMEM)
					 ((PARITY == 0) || serr));
assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read && (badr == select_rbnk) && (addr==select_addr)) |-> ##(SRAM_DELAY+FLOPMEM)
				    (padr == ((NUMWRDS>1) ? {select_rbnk,select_word,select_srow} : {select_rbnk,select_srow})));

endmodule
