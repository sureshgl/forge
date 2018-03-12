module ip_top_sva_2_align_ecc_dwsn
  #(
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
parameter     NUMSROW = 256,
parameter     BITSROW = 8)
(
  input clk,
  input rst,
  input read,
  input write,
  input [BITADDR-1:0] addr,
  input mem_read,
  input mem_write,
  input [BITSROW-1:0] mem_addr
);
`ifdef FORMAL
//synopsys translate_off

assert_rd_wr_check: assume property (@(posedge clk) disable iff (rst) !(write && read));
//assert_rd_wr_range_check: assume property (@(posedge clk) disable iff (rst) (write || read) |-> (addr < NUMADDR));
assert_wr_range_check: assume property (@(posedge clk) disable iff (rst) write |-> (addr < NUMADDR));

assert_mem_1port_check: assert property (@(posedge clk) disable iff (rst) !(mem_write && mem_read));
//assert_mem_range_check: assert property (@(posedge clk) disable iff (rst) (mem_write || mem_read) |-> (mem_addr < NUMSROW));
assert_mem_wr_range_check: assert property (@(posedge clk) disable iff (rst) mem_write |-> (mem_addr < NUMSROW));
//synopsys translate_on
`endif
endmodule


module ip_top_sva_align_ecc_dwsn
  #(
parameter     WIDTH   = 32,
parameter     ENAEXT  = 0,
parameter     ENAPAR  = 0,
parameter     ENAECC  = 0,
parameter     ECCWDTH = 7,
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
parameter     RSTZERO = 0,
parameter     MEMWDTH = ENAEXT ? WIDTH : ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH
   )
(
  input clk,
  input rst,
  input read,
  input write,
  input [BITADDR-1:0] addr,
  input [WIDTH-1:0] din,
  input [WIDTH-1:0] rd_dout,
  input rd_fwrd,
  input rd_serr,
  input rd_derr,
  input [BITWRDS+BITSROW-1:0] rd_padr,
  input mem_read,
  input mem_write,
  input [BITSROW-1:0] mem_addr,
  input [NUMWRDS*MEMWDTH-1:0] mem_bw,
  input [NUMWRDS*MEMWDTH-1:0] mem_din,
  input [NUMWRDS*MEMWDTH-1:0] mem_dout,
  input [NUMWRDS-1:0] mem_serr,
  input [BITADDR-1:0] select_addr
);
`ifdef FORMAL
//synopsys translate_off

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
  if (rst) begin
    meminv <= 1'b1;
    mem <= RSTZERO ? 0 : 'hx;
  end else if (mem_write && (mem_addr == select_srow) && |mem_bw_wire) begin
    meminv <= 1'b0;
    mem <= mem_din_wire;
  end

wire [MEMWDTH-1:0] mem_dout_wire = mem_dout >> select_word*MEMWDTH;
wire mem_serr_wire = mem_serr >> select_word;


wire [ECCWDTH-1:0] din_ecc;
generate if (ENAECC) begin: decc_loop
  ecc_calc #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
    ecc_calc_inst (.din(mem[WIDTH-1:0]), .eccout(din_ecc));
end
endgenerate

wire [MEMWDTH-1:0] dout_mask;
assert_mem_check: assert property (@(posedge clk) disable iff (rst) (mem_read && (mem_addr == select_srow)) |-> ##SRAM_DELAY
                                   ($past(!RSTZERO && meminv,SRAM_DELAY) || (mem_dout_wire == ($past(mem,SRAM_DELAY) ^ dout_mask))));

assert_mem_chk_check: assert property (@(posedge clk) disable iff (rst) ((!RSTZERO && meminv) || (ENAEXT ? 1'b1 :
                                                                                                  ENAPAR ? !(^mem) :
                                                                                                  ENAECC ? ({din_ecc,mem[WIDTH-1:0]}==mem) : 1'b1)));

reg fakememinv;
reg [WIDTH-1:0] fakemem;
always @(posedge clk)
  if (rst) begin 
    fakememinv <= 1'b1;
    fakemem <= RSTZERO ? 0 : 'hx;
  end else if (write && (addr == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din;
  end

wire dout_bit1_err = 0;
wire dout_bit2_err = 0;
wire [15:0] dout_bit1_pos = 0;
wire [15:0] dout_bit2_pos = 0;
wire [MEMWDTH-1:0] dout_bit1_mask = (ENAPAR || ENAECC) ? dout_bit1_err << dout_bit1_pos : 0;
wire [MEMWDTH-1:0] dout_bit2_mask = (ENAECC) ? dout_bit2_err << dout_bit2_pos : 0;
assign dout_mask = dout_bit1_mask ^ dout_bit2_mask;
wire dout_serr = |dout_mask && (|dout_bit1_mask ^ |dout_bit2_mask);
wire dout_derr = |dout_mask && |dout_bit1_mask && |dout_bit2_mask;

wire pmem_serr = 0;
wire pmem_derr = 0;
wire pmem_nerr = !pmem_serr && !pmem_derr;
assume_pmem_err_check: assert property (@(posedge clk) disable iff (rst) !(pmem_serr && pmem_derr));
assume_pmem_nerr_check: assert property (@(posedge clk) disable iff (rst) pmem_nerr |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM) (!ENAEXT || !mem_serr_wire) && !dout_serr && !dout_derr);
assume_pmem_serr_check: assert property (@(posedge clk) disable iff (rst) pmem_serr |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM) (!ENAEXT || mem_serr_wire) && dout_serr);
assume_pmem_derr_check: assert property (@(posedge clk) disable iff (rst) pmem_derr |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM) (!ENAEXT || !mem_serr_wire) && dout_derr);

assert_dout_nerr_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr) && pmem_nerr) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
                                         ($past(!RSTZERO && fakememinv,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT) ||
                                          (($past(!RSTZERO && meminv,SRAM_DELAY+FLOPMEM+FLOPOUT) || (!rd_serr && !rd_derr)) &&
                                           (rd_dout == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)))));
assert_dout_serr_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr) && pmem_serr) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
                                         ($past(!RSTZERO && fakememinv,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT) ||
                                          ($past(!RSTZERO && meminv,SRAM_DELAY+FLOPMEM+FLOPOUT) ?
                                           (rd_dout == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)) :
                                           (ENAEXT ? rd_serr && !rd_derr && (!rd_fwrd || (rd_dout == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT))) :
                                            ENAPAR ? rd_serr && !rd_derr && (!rd_fwrd || (rd_dout == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT))) :
                                            ENAECC ? rd_serr && !rd_derr && (rd_dout == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)) :
                                                     !rd_serr && !rd_derr && (rd_dout == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT))))));
assert_dout_derr_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr) && pmem_derr) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
                                         ($past(!RSTZERO && fakememinv,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT) ||
                                          ($past(!RSTZERO && meminv,SRAM_DELAY+FLOPMEM+FLOPOUT) ?
                                           (rd_dout == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)) :
                                           (ENAEXT ? !rd_serr && !rd_derr && (!rd_fwrd || (rd_dout == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT))) :
                                            ENAPAR ? !rd_serr && !rd_derr && (rd_dout == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)) :
                                            ENAECC ? !rd_serr && rd_derr && (!rd_fwrd || (rd_dout == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT))) :
                                                     !rd_serr && !rd_derr && (rd_dout == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT))))));
assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr)) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
                                    (rd_fwrd == $past(core.forward_read,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)));
assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr)) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
                                    (rd_padr == {select_word,select_srow}));
//synopsys translate_on
`endif
endmodule
