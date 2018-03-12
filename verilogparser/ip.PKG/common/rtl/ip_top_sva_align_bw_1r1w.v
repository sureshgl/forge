module ip_top_sva_2_align_bw_1r1w
  #(
parameter     ENAPSDO = 0,
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
assert_mem_rd_wr_pseudo_check: assert property (@(posedge clk) disable iff (rst) (ENAPSDO && mem_write && mem_read) |-> (mem_wr_adr != mem_rd_adr));

endmodule


module ip_top_sva_align_bw_1r1w
  #(
parameter     WIDTH   = 32,
parameter     ENAPSDO = 0,
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
parameter     NUMWRDS = 4,
parameter     BITWRDS = 2,
parameter     NUMSROW = 256,
parameter     BITSROW = 8,
parameter     BITPADR = 10,
parameter     SRAM_DELAY = 2,
parameter     FLOPGEN = 0,
parameter     FLOPCMD = 0,
parameter     FLOPMEM = 0,
parameter     FLOPOUT = 0,
parameter     ENAPADR = 0,
parameter     RSTZERO = 0,
parameter     RSTONES = 0
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
  input rd_fwrd,
  input rd_serr,
  input rd_derr,
  input [BITPADR-1:0] rd_padr,
  input mem_write,
  input [BITSROW-1:0] mem_wr_adr,
  input [NUMWRDS*WIDTH-1:0] mem_bw,
  input [NUMWRDS*WIDTH-1:0] mem_din,
  input mem_read,
  input [BITSROW-1:0] mem_rd_adr,
  input [NUMWRDS*WIDTH-1:0] mem_rd_dout,
  input mem_rd_fwrd,
  input [BITPADR-BITWRDS-1:0] mem_rd_padr,
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

wire [WIDTH-1:0] mem_bw_wire = mem_bw >> select_word*WIDTH;
wire [WIDTH-1:0] mem_din_wire = mem_din >> select_word*WIDTH;


reg [WIDTH-1:0] meminv;
reg [WIDTH-1:0] mem;
always @(posedge clk)
  if (rst) begin
    meminv <= RSTZERO ? 0 : RSTONES ? 0 : ~0;
    mem <= RSTZERO ? 0 : RSTONES ? ~0 : {WIDTH{1'bx}};
  end else if (mem_write && (mem_wr_adr == select_srow)) begin
    meminv <= meminv & ~mem_bw_wire;
    mem <= (mem_bw_wire & mem_din_wire) | (~mem_bw_wire & mem);
  end

wire [WIDTH-1:0] mem_dout_wire = mem_rd_dout >> select_word*WIDTH;

assert_mem_check: assert property (@(posedge clk) disable iff (rst) (mem_read && (mem_rd_adr == select_srow)) |-> ##SRAM_DELAY
                                   ((mem_dout_wire & $past(~meminv,SRAM_DELAY)) == $past(mem & ~meminv,SRAM_DELAY)));

reg [WIDTH-1:0] fakememinv;
reg [WIDTH-1:0] fakemem;
always @(posedge clk)
  if (rst) begin
    fakememinv <= RSTZERO ? 0 : RSTONES ? 0 : ~0;
    fakemem <= RSTZERO ? 0 : RSTONES ? ~0 : 'hx;
  end else if (write && (wr_adr == select_addr)) begin
    fakememinv <= fakememinv & ~bw;
    fakemem <= (bw & din) | (~bw & fakemem);
  end

assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
                                    ($past(!RSTZERO && !RSTONES && fakememinv,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT) ||
                                     (!rd_serr && !rd_derr && (rd_dout & $past(~fakememinv,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)) ==
                                                               $past(fakemem & ~fakememinv,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT))));
assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr==select_addr)) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
                                    (rd_fwrd == ($past(core.forward_read,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT) ||
                                                 (FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd))));
assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr==select_addr)) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
                                    ((NUMWRDS==1) ? (rd_padr == (ENAPADR ? (FLOPOUT ? $past(mem_rd_padr) : mem_rd_padr) : select_srow)) :
                                                    (rd_padr == (ENAPADR ? {select_word,(FLOPOUT ? $past(mem_rd_padr) : mem_rd_padr)} :
                                                                           {select_word,select_srow}))));

endmodule

