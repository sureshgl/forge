module ip_top_sva_2_stack_1r1w_ramwrap
  #(
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
parameter     NUMWBNK = 4,
parameter     BITWBNK = 2,
parameter     NUMWROW = 256,
parameter     BITWROW = 8)
(
  input clk,
  input rst,
  input write,
  input [BITADDR-1:0] wr_adr,
  input read,
  input [BITADDR-1:0] rd_adr,
  input [NUMWBNK-1:0] mem_write,
  input [NUMWBNK*BITWROW-1:0] mem_wr_adr,
  input [NUMWBNK-1:0] mem_read,
  input [NUMWBNK*BITWROW-1:0] mem_rd_adr
);
`ifdef FORMAL
//synopsys translate_off

assert_rd_range_check: assume property (@(posedge clk) disable iff (rst) read |-> (rd_adr < NUMADDR));
assert_wr_range_check: assume property (@(posedge clk) disable iff (rst) write |-> (wr_adr < NUMADDR));

genvar mem_int;
generate for (mem_int=0; mem_int<NUMWBNK; mem_int=mem_int+1) begin: mem_loop
  wire mem_write_wire = mem_write >> mem_int;
  wire [BITWROW-1:0] mem_wr_adr_wire = mem_wr_adr >> (mem_int*BITWROW);
  wire mem_read_wire = mem_read >> mem_int;
  wire [BITWROW-1:0] mem_rd_adr_wire = mem_rd_adr >> (mem_int*BITWROW);

  assert_mem_rd_range_check: assert property (@(posedge clk) disable iff (rst) mem_read_wire |-> (mem_rd_adr_wire < NUMWROW));
  assert_mem_wr_range_check: assert property (@(posedge clk) disable iff (rst) mem_write_wire |-> (mem_wr_adr_wire < NUMWROW));
  //assert_mem_rd_wr_pseudo_check: assert property (@(posedge clk) disable iff (rst) (mem_write_wire && mem_read_wire) |-> (mem_wr_adr_wire != mem_rd_adr_wire));
end
endgenerate
//synopsys translate_on
`endif
endmodule

module ip_top_sva_stack_1r1w_ramwrap
  #(
parameter     WIDTH   = 32,
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
parameter     NUMWBNK = 4,
parameter     BITWBNK = 2,
parameter     NUMWROW = 256,
parameter     BITWROW = 8,
parameter     SRAM_DELAY = 2,
parameter     FLOPCMD = 0,
parameter     FLOPMEM = 0,
parameter     FLOPOUT = 0,
parameter     RSTZERO = 0
   )
(
  input clk,
  input rst,
  input write,
  input [BITADDR-1:0] wr_adr,
  input [WIDTH-1:0] bw,
  input [WIDTH-1:0] din,
  input read,
  input [BITADDR-1:0] rd_adr,
  input [WIDTH-1:0] rd_dout,
  input [NUMWBNK-1:0] mem_write,
  input [NUMWBNK*BITWROW-1:0] mem_wr_adr,
  input [NUMWBNK*WIDTH-1:0] mem_bw,
  input [NUMWBNK*WIDTH-1:0] mem_din,
  input [NUMWBNK-1:0] mem_read,
  input [NUMWBNK*BITWROW-1:0] mem_rd_adr,
  input [NUMWBNK*WIDTH-1:0] mem_rd_dout,
  input [BITADDR-1:0] select_addr
);
`ifdef FORMAL
//synopsys translate_off
  localparam LBITWBK = BITWBNK>0 ? BITWBNK : 1;

wire [LBITWBK-1:0] select_bank;
wire [BITWROW-1:0] select_wrow;
generate if (BITWBNK>0) begin: np2_loop
  np2_addr_ramwrap #(
    .NUMADDR (NUMADDR), .BITADDR (BITADDR),
    .NUMVBNK (NUMWBNK), .BITVBNK (BITWBNK),
    .NUMVROW (NUMWROW), .BITVROW (BITWROW))
    sel_adr (.vbadr(select_bank), .vradr(select_wrow), .vaddr(select_addr));
  end else begin: no_np2_loop
    assign select_bank = 0;
    assign select_wrow = select_addr;
  end
endgenerate

wire mem_write_wire = mem_write >> select_bank;
wire [BITWROW-1:0] mem_wr_adr_wire = mem_wr_adr >> (select_bank*BITWROW);
wire [WIDTH-1:0] mem_bw_wire = mem_bw >> select_bank*WIDTH;
wire [WIDTH-1:0] mem_din_wire = mem_din >> select_bank*WIDTH;

wire mem_read_wire = mem_read >> select_bank;
wire [BITWROW-1:0] mem_rd_adr_wire = mem_rd_adr >> (select_bank*BITWROW);

reg meminv;
reg [WIDTH-1:0] mem;
always @(posedge clk)
  if (rst) begin
    meminv <= 1'b1;
    mem <= RSTZERO ? 0 : 'hx;
  end else if (mem_write_wire && (mem_wr_adr_wire == select_wrow)) begin
    meminv <= meminv && !(|mem_bw_wire);
    mem <= (mem_bw_wire & mem_din_wire) | (~mem_bw_wire & mem);
  end

wire [WIDTH-1:0] mem_dout_wire = mem_rd_dout >> select_bank*WIDTH;

generate if(SRAM_DELAY>0) begin :dl_loop
assert_mem_check: assert property (@(posedge clk) disable iff (rst) (mem_read_wire && (mem_rd_adr_wire == select_wrow)) |-> ##SRAM_DELAY
                                   ($past(!RSTZERO && meminv,SRAM_DELAY) || (mem_dout_wire == $past(mem,SRAM_DELAY))));
end else begin:ndl_loop
assert_mem_check: assert property (@(posedge clk) disable iff (rst) (mem_read_wire && (mem_rd_adr_wire == select_wrow)) |-> ##SRAM_DELAY
                                   ((!RSTZERO && meminv) || (mem_dout_wire == mem)));
end
endgenerate

reg [WIDTH-1:0] fakememinv;
reg [WIDTH-1:0] fakemem;
always @(posedge clk)
  if (rst) begin
    fakememinv <= ~0;
    fakemem <= RSTZERO ? 0 : 'hx;
  end else if (write && (wr_adr == select_addr)) begin
    fakememinv <= fakememinv & ~bw;
    fakemem <= (bw & din) | (~bw & fakemem);
  end

generate if(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT>0) begin :dly_loop
assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
                                    (&((RSTZERO ? 0 : $past(fakememinv,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)) |
                                       ~(rd_dout ^ $past(fakemem,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)))));
end else begin:ndly_loop
assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> (&(RSTZERO ? 0 : fakememinv) | ~(rd_dout ^ (fakemem))));
end
endgenerate
//synopsys translate_on
`endif
endmodule

