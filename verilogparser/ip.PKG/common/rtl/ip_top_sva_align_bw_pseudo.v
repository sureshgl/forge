module ip_top_sva_2_align_bw_pseudo
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

assert_rd_range_check: assume property (@(posedge clk) disable iff (rst) read |-> ((rd_bnk < NUMVBNK) && (rd_adr < NUMVROW)));
assert_wr_range_check: assume property (@(posedge clk) disable iff (rst) write |-> ((wr_bnk < NUMVBNK) && (wr_adr < NUMVROW)));
assert_rd_wr_pseudo_check: assume property (@(posedge clk) disable iff (rst) (read && write) |-> (rd_bnk != wr_bnk));

assert_mem_rd_range_check: assert property (@(posedge clk) disable iff (rst) mem_read |-> ((mem_rd_bnk < NUMVBNK) && (mem_rd_adr < NUMSROW)));
assert_mem_wr_range_check: assert property (@(posedge clk) disable iff (rst) mem_write |-> ((mem_wr_bnk < NUMVBNK) && (mem_wr_adr < NUMSROW)));
assert_mem_rd_wr_pseudo_check: assert property (@(posedge clk) disable iff (rst) (mem_write && mem_read) |-> (mem_wr_bnk != mem_rd_bnk));

endmodule


module ip_top_sva_align_bw_pseudo
  #(
parameter     WIDTH   = 32,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
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
  input [BITVBNK-1:0] wr_bnk,
  input [BITVROW-1:0] wr_adr,
  input [WIDTH-1:0] bw,
  input [WIDTH-1:0] din,
  input read,
  input [BITVBNK-1:0] rd_bnk,
  input [BITVROW-1:0] rd_adr,
  input [WIDTH-1:0] rd_dout,
  input rd_fwrd,
  input rd_serr,
  input rd_derr,
  input [BITPADR-1:0] rd_padr,
  input mem_write,
  input [BITVBNK-1:0] mem_wr_bnk,
  input [BITSROW-1:0] mem_wr_adr,
  input [NUMWRDS*WIDTH-1:0] mem_bw,
  input [NUMWRDS*WIDTH-1:0] mem_din,
  input mem_read,
  input [BITVBNK-1:0] mem_rd_bnk,
  input [BITSROW-1:0] mem_rd_adr,
  input [NUMWRDS*WIDTH-1:0] mem_rd_dout,
  input mem_rd_fwrd,
  input [BITPADR-BITWRDS-1:0] mem_rd_padr,
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

wire [WIDTH-1:0] mem_bw_wire = mem_bw >> select_word*WIDTH;
wire [WIDTH-1:0] mem_din_wire = mem_din >> select_word*WIDTH;

wire [WIDTH-1:0] rstdin = RSTZERO ? 0 : RSTONES ? ~0 : {WIDTH{1'bx}};

reg meminv [0:NUMVBNK-1];
reg [WIDTH-1:0] mem [0:NUMVBNK-1];
integer mem_int;
always @(posedge clk)
  if (rst)
    for (mem_int=0; mem_int<NUMVBNK; mem_int=mem_int+1) begin
      meminv[mem_int] <= 1'b1;
      mem[mem_int] <= rstdin;
    end
  else if (mem_write && (mem_wr_adr == select_srow)) begin
    meminv[mem_wr_bnk] <= 1'b0;
    mem[mem_wr_bnk] <= (mem_bw_wire & mem_din_wire) | (~mem_bw_wire & mem[mem_wr_bnk]); 
  end

wire [WIDTH-1:0] mem_dout_wire = mem_rd_dout >> select_word*WIDTH;

assert_mem_check: assert property (@(posedge clk) disable iff (rst) (mem_read && (mem_rd_adr == select_srow)) |-> ##SRAM_DELAY
                                   ($past(!RSTZERO && !RSTONES && meminv[mem_rd_bnk],SRAM_DELAY) || (mem_dout_wire == $past(mem[mem_rd_bnk],SRAM_DELAY))));

reg [WIDTH-1:0] fakememinv [0:NUMVBNK-1];
reg [WIDTH-1:0] fakemem [0:NUMVBNK-1];
integer fake_int;
always @(posedge clk)
  if (rst)
    for (fake_int=0; fake_int<NUMVBNK; fake_int=fake_int+1) begin
      fakememinv[fake_int] <= RSTZERO ? 0 : RSTONES ? 0 : ~0;
      fakemem[fake_int] <= RSTZERO ? 0 : RSTONES ? ~0 : 'hx;
    end
  else if (write && (wr_adr == select_vrow)) begin
    fakememinv[wr_bnk] <= fakememinv[wr_bnk] & ~bw;
    fakemem[wr_bnk] <= (bw & din) | (~bw & fakemem[wr_bnk]);
  end

wire [WIDTH-1:0] fakememinv_rd = fakememinv[rd_bnk];
wire [WIDTH-1:0] fakemem_rd = fakemem[rd_bnk];

assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_vrow)) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
                                    ((rd_dout & $past(~fakememinv_rd,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)) == $past(fakemem_rd & ~fakememinv_rd,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)));
assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_vrow)) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
                                    (rd_fwrd == ($past(core.forward_read,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT) ||
                                                 (FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd))));
assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_vrow)) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
                                      ((NUMWRDS==1) ? (rd_padr == (ENAPADR ? (FLOPOUT ? $past(mem_rd_padr) : mem_rd_padr) : select_srow)) :
                                                      (rd_padr == (ENAPADR ? {select_word,(FLOPOUT ? $past(mem_rd_padr) : mem_rd_padr)} :
                                                                             {select_word,select_srow}))));

endmodule

