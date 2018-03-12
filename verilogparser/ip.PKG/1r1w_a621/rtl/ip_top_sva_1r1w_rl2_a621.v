module ip_top_sva_2_1r1w_rl2_a621
  #(
parameter     WIDTH   = 32,
parameter     ENAPSDO = 0,
parameter     ENAPAR = 0,
parameter     ENAECC = 0,
parameter     ECCWDTH = 7,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     SRAM_DELAY = 2,
parameter     DRAM_DELAY = 2,
parameter     ECCBITS = 4,
parameter     SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS,
parameter     MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH
   )
(
  input clk,
  input rst,
  input ready,
  input read,
  input [BITADDR-1:0] rd_adr,
  input write,
  input [BITADDR-1:0] wr_adr,
  input [NUMVBNK-1:0] t1_writeA,
  input [NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMVBNK-1:0] t1_readB,
  input [NUMVBNK*BITVROW-1:0] t1_addrB,
  input [2-1:0] t2_writeA,
  input [2*BITVROW-1:0] t2_addrA,
  input [2*(SDOUT_WIDTH+MEMWDTH)-1:0] t2_dinA,
  input [2-1:0] t2_readB,
  input [2*BITVROW-1:0] t2_addrB
);

assert_rd_range_check: assert property (@(posedge clk) disable iff (rst) read |-> (rd_adr < NUMADDR));
assert_wr_range_check: assert property (@(posedge clk) disable iff (rst) write |-> (wr_adr < NUMADDR));

genvar t1_int;
generate for (t1_int=0; t1_int<NUMVBNK; t1_int=t1_int+1) begin: t1_loop
  wire t1_writeA_wire = t1_writeA >> t1_int;
  wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> (t1_int*BITVROW);

  wire t1_readB_wire = t1_readB >> t1_int;
  wire [BITVROW-1:0] t1_addrB_wire = t1_addrB >> (t1_int*BITVROW);

  assert_t1_1port_check: assert property (@(posedge clk) disable iff (rst) !(t1_writeA_wire && t1_readB_wire));
  assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMVROW));
  assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> (t1_addrB_wire < NUMVROW));
end
endgenerate

genvar t2_int;
generate for (t2_int=0; t2_int<2; t2_int=t2_int+1) begin: t2_loop
  wire t2_writeA_wire = t2_writeA >> t2_int;
  wire [BITVROW-1:0] t2_addrA_wire = t2_addrA >> (t2_int*BITVROW);
  wire [SDOUT_WIDTH+MEMWDTH-1:0] t2_dinA_wire = t2_dinA >> (t2_int*(SDOUT_WIDTH+MEMWDTH));

  wire t2_writeA_0_wire = t2_writeA;
  wire [BITVROW-1:0] t2_addrA_0_wire = t2_addrA;
  wire [SDOUT_WIDTH+MEMWDTH-1:0] t2_dinA_0_wire = t2_dinA;

  wire t2_readB_wire = t2_readB >> t2_int;
  wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> (t2_int*BITVROW);

  assert_t2_wr_same_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_writeA_0_wire &&
                                                                                                 (t2_addrA_0_wire == t2_addrA_wire) &&
                                                                                                 (t2_dinA_0_wire == t2_dinA_wire)));
  assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_addrA_wire < NUMVROW));
  assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire |-> (t2_addrB_wire < NUMVROW));
  assert_t2_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (ENAPSDO && t2_writeA_wire && t2_readB_wire) |-> (t2_addrA_wire != t2_addrB_wire));
end
endgenerate

endmodule


module ip_top_sva_1r1w_rl2_a621
  #(
parameter     WIDTH   = 32,
parameter     ENAPAR = 0,
parameter     ENAECC = 0,
parameter     ECCWDTH = 7,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     BITPBNK = 4,
parameter     BITPADR = 14,
parameter     SRAM_DELAY = 2,
parameter     DRAM_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0,
parameter     ECCBITS = 4,
parameter     SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS,
parameter     MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH
   )
(
  input clk,
  input rst,
  input [NUMVBNK-1:0] t1_writeA,
  input [NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMVBNK*MEMWDTH-1:0] t1_dinA,
  input [NUMVBNK-1:0] t1_readB,
  input [NUMVBNK*BITVROW-1:0] t1_addrB,
  input [NUMVBNK*MEMWDTH-1:0] t1_doutB,
  input [NUMVBNK-1:0] t1_fwrdB,
  input [NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrB,
  input [2-1:0] t2_writeA,
  input [2*BITVROW-1:0] t2_addrA,
  input [2*(SDOUT_WIDTH+MEMWDTH)-1:0] t2_dinA,
  input [2-1:0] t2_readB,
  input [2*BITVROW-1:0] t2_addrB,
  input [2-1:0] t2_fwrdB,
  input [2*(SDOUT_WIDTH+MEMWDTH)-1:0] t2_doutB,
  input [2*(BITPADR-BITPBNK)-1:0] t2_padrB,
  input write,
  input [BITADDR-1:0]  wr_adr,
  input [WIDTH-1:0] din,
  input [BITADDR-1:0] rd_adr,
  input [WIDTH-1:0] rd_dout,
  input rd_fwrd,
  input rd_serr,
  input rd_derr,
  input [BITPADR-1:0] rd_padr,
  input read,
  input rd_vld,
  input [BITADDR-1:0] select_addr
);

wire [BITVBNK-1:0] select_bank;
wire [BITVROW-1:0] select_row;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  sel_inst (.vbadr(select_bank), .vradr(select_row), .vaddr(select_addr));

wire [BITVBNK-1:0] wr_bnk;
wire [BITVROW-1:0] wr_row;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  wr_inst (.vbadr(wr_bnk), .vradr(wr_row), .vaddr(wr_adr));

assert_rw_wr_np2_check: assert property (@(posedge clk) disable iff (rst) (read && write) |-> ##FLOPIN
					 ((core.vrdaddr_wire == core.vwraddr_wire) == ((core.vrdbadr_wire == core.vwrbadr_wire) && (core.vrdradr_wire == core.vwrradr_wire))));
assert_rw_sl_np2_check: assert property (@(posedge clk) disable iff (rst) (read) |-> ##FLOPIN
					 ((core.vrdaddr_wire == select_addr) == ((core.vrdbadr_wire == select_bank) && (core.vrdradr_wire == select_row)))); 
assert_wr_sl_np2_check: assert property (@(posedge clk) disable iff (rst) (write) |-> ##FLOPIN
					 ((core.vwraddr_wire == select_addr) == ((core.vwrbadr_wire == select_bank) && (core.vwrradr_wire == select_row)))); 

assert_rp_np2_range_check: assert property (@(posedge clk) disable iff (rst) (read) |-> ##FLOPIN
					    ((core.vrdbadr_wire < NUMVBNK) && (core.vrdradr_wire < NUMVROW)));
assert_wr_np2_range_check: assert property (@(posedge clk) disable iff (rst) (write) |-> ##FLOPIN
					    ((core.vwrbadr_wire < NUMVBNK) && (core.vwrradr_wire < NUMVROW)));
assert_sl_np2_range_check: assert property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR) |->
					    ((select_bank < NUMVBNK) && (select_row < NUMVROW))); 

wire t1_writeA_sel_wire = t1_writeA >> select_bank;
wire [BITVROW-1:0] t1_addrA_sel_wire = t1_addrA >> (select_bank*BITVROW);
wire [MEMWDTH-1:0] t1_dinA_sel_wire = t1_dinA >> (select_bank*MEMWDTH);
wire t1_readB_sel_wire = t1_readB >> select_bank;
wire [BITVROW-1:0] t1_addrB_sel_wire = t1_addrB >> (select_bank*BITVROW);
wire [MEMWDTH-1:0] t1_doutB_sel_wire = t1_doutB >> (select_bank*MEMWDTH);
wire t1_fwrdB_sel_wire = t1_fwrdB >> select_bank;
wire [BITPADR-BITPBNK-1:0] t1_padrB_sel_wire = t1_padrB >> (select_bank*(BITPADR-BITPBNK));

wire t2_writeA_wire = t2_writeA;
wire [BITVROW-1:0] t2_addrA_wire = t2_addrA;
wire [SDOUT_WIDTH-1:0] t2_sdinA_wire = t2_dinA >> MEMWDTH;
wire [MEMWDTH-1:0] t2_ddinA_wire = t2_dinA;
wire t2_readB_0_wire = t2_readB;
wire [BITVROW-1:0] t2_addrB_0_wire = t2_addrB;
wire [SDOUT_WIDTH-1:0] t2_sdoutB_0_wire = t2_doutB >> MEMWDTH;
wire [MEMWDTH-1:0] t2_ddoutB_0_wire = t2_doutB;
wire t2_fwrdB_0_wire = t2_fwrdB;
wire [BITPADR-BITPBNK-1:0] t2_padrB_0_wire = t2_padrB;
wire t2_readB_1_wire = t2_readB >> 1;
wire [BITVROW-1:0] t2_addrB_1_wire = t2_addrB >> (1*BITVROW);
wire [SDOUT_WIDTH-1:0] t2_sdoutB_1_wire = t2_doutB >> (2*MEMWDTH+SDOUT_WIDTH);
wire [MEMWDTH-1:0] t2_ddoutB_1_wire = t2_doutB >> (MEMWDTH+SDOUT_WIDTH);
wire t2_fwrdB_1_wire = t2_fwrdB >> 1;
wire [BITPADR-BITPBNK-1:0] t2_padrB_1_wire = t2_padrB >> (BITPADR-BITPBNK);

reg meminv;
reg memsec;
reg memded;
reg [MEMWDTH-1:0] memmsk;
reg [MEMWDTH-1:0] mem;
always @(posedge clk)
  if (rst) begin
    meminv <= 1'b1;
  end else if (t1_writeA_sel_wire && (t1_addrA_sel_wire == select_row)) begin
    meminv <= 1'b0;
    memsec <= core.old_to_pivot ? core.sold_serr : 1'b0;
    memded <= core.old_to_pivot ? core.sold_derr : 1'b0;
    memmsk <= core.old_to_pivot ? core.sold_mask : 0;
    mem <= t1_dinA_sel_wire;
  end

wire [ECCWDTH-1:0] mem_ecc;
ecc_calc #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
  ecc_calc_mem_inst (.din(mem[WIDTH-1:0]), .eccout(mem_ecc));

reg [SDOUT_WIDTH-1:0] mapmem;
always @(posedge clk)
  if (rst)
    mapmem <= 0;
  else if (t2_writeA_wire && (t2_addrA_wire == select_row))
    mapmem <= t2_sdinA_wire;

wire [ECCBITS-1:0] mapmem_ecc;
ecc_calc   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
    ecc_calc_mapmem_inst(.din(mapmem[BITVBNK:0]), .eccout(mapmem_ecc));

reg [MEMWDTH-1:0] datmem;
always @(posedge clk)
  if (rst)
    datmem <= 0;
  else if (t2_writeA_wire && (t2_addrA_wire == select_row))
    datmem <= t2_ddinA_wire;

wire [ECCWDTH-1:0] datmem_ecc;
ecc_calc #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
  ecc_calc_datmem_inst (.din(datmem[WIDTH-1:0]), .eccout(datmem_ecc));

wire [MEMWDTH-1:0] mem_wire = (mapmem[BITVBNK] && (mapmem[BITVBNK-1:0] == select_bank)) ? datmem : mem;
wire [MEMWDTH-1:0] msk_wire = (mapmem[BITVBNK] && (mapmem[BITVBNK-1:0] == select_bank)) ? 0 : memmsk;
wire               sec_wire = (mapmem[BITVBNK] && (mapmem[BITVBNK-1:0] == select_bank)) ? 1'b0 : memsec;
wire               ded_wire = (mapmem[BITVBNK] && (mapmem[BITVBNK-1:0] == select_bank)) ? 1'b0 : memded;

assert_mapmem_ecc_check: assert property (@(posedge clk) disable iff (rst) (mapmem == {mapmem[BITVBNK:0],mapmem_ecc,mapmem[BITVBNK:0]}));
assert_mem_ecc_check: assert property (@(posedge clk) disable iff (rst) (meminv ||
                                                                         (ENAPAR ? (mem == {^mem[WIDTH-1:0],mem[WIDTH-1:0]}) :
                                                                          ENAECC ? (mem == {mem_ecc,mem[WIDTH-1:0]}) : 1'b1)));
assert_datmem_ecc_check: assert property (@(posedge clk) disable iff (rst) ENAPAR ? (datmem == {^datmem[WIDTH-1:0],datmem[WIDTH-1:0]}) :
                                                                           ENAECC ? (datmem == {datmem_ecc,datmem[WIDTH-1:0]}) : 1'b1);

assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_sel_wire && (t1_addrB_sel_wire == select_row)) |-> ##DRAM_DELAY
                                     ($past(meminv,DRAM_DELAY) || (t1_doutB_sel_wire == $past(mem,DRAM_DELAY))));

assert_sdout1_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_0_wire && (t2_addrB_0_wire == select_row)) |-> ##SRAM_DELAY
                                      (t2_sdoutB_0_wire == $past(mapmem,SRAM_DELAY)));

assert_sdout2_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_1_wire && (t2_addrB_1_wire == select_row)) |-> ##SRAM_DELAY
                                      (t2_sdoutB_1_wire == $past(mapmem,SRAM_DELAY)));

assert_ddout1_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_0_wire && (t2_addrB_0_wire == select_row)) |-> ##SRAM_DELAY
                                      (t2_ddoutB_0_wire == $past(datmem,SRAM_DELAY)));

assert_ddout2_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_1_wire && (t2_addrB_1_wire == select_row)) |-> ##SRAM_DELAY
                                      (t2_ddoutB_1_wire == $past(datmem,SRAM_DELAY)));

assert_sdout1_ecc_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_0_wire && (t2_addrB_0_wire == select_row)) |-> ##SRAM_DELAY
                                          (core.sdout1_out == $past(mapmem[BITVBNK:0],SRAM_DELAY)));

assert_sdout2_ecc_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_1_wire && (t2_addrB_1_wire == select_row)) |-> ##SRAM_DELAY
                                          (core.sdout2_out == $past(mapmem[BITVBNK:0],SRAM_DELAY)));

wire pdat_serr = 0;
wire pdat_derr = 0;
wire pdat_nerr = !pdat_serr && !pdat_derr;
assume_pdat_serr_check: assert property (@(posedge clk) disable iff (rst) pdat_serr |-> ##DRAM_DELAY
                                         memded ? core.pdat_serr && !core.pdat_derr && |(core.pdat_mask & memmsk) :
                                         memsec ? !core.pdat_serr && !core.pdat_derr :
                                                  core.pdat_serr && !core.pdat_derr);
assume_pdat_derr_check: assert property (@(posedge clk) disable iff (rst) pdat_derr |-> ##DRAM_DELAY
                                         memded ? !core.pdat_serr && !core.pdat_derr :
                                         memsec ? (core.pdat_mask != memmsk) && core.pdat_serr && !core.pdat_derr :
                                                  !core.pdat_serr && core.pdat_derr);
assume_pdat_nerr_check: assert property (@(posedge clk) disable iff (rst) pdat_nerr |-> ##DRAM_DELAY (core.pdat_mask == memmsk));

assert_pdat_nerr_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdaddr_wire == select_addr) && pdat_nerr) |-> ##DRAM_DELAY
					 meminv || (!core.pdat_ded_err && !core.pdat_sec_err && ((mem[WIDTH-1:0] ^ memmsk[WIDTH-1:0]) == core.pdat_post_ecc)));
assert_pdat_serr_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdaddr_wire == select_addr) && pdat_serr) |-> ##DRAM_DELAY
					 meminv || (!core.pdat_ded_err && core.pdat_sec_err && ((mem[WIDTH-1:0] ^ memmsk[WIDTH-1:0]) == core.pdat_post_ecc)));
assert_pdat_derr_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdaddr_wire == select_addr) && pdat_derr) |-> ##DRAM_DELAY
					 meminv || (core.pdat_ded_err && !core.pdat_sec_err));

wire sold_serr = 0;
wire sold_derr = 0;
wire sold_nerr = !sold_serr && !sold_derr;
assume_sold_serr_check: assert property (@(posedge clk) disable iff (rst) sold_serr |-> ##(SRAM_DELAY+1) core.sold_serr && !core.sold_derr);
assume_sold_derr_check: assert property (@(posedge clk) disable iff (rst) sold_derr |-> ##(SRAM_DELAY+1) !core.sold_serr && core.sold_derr);
assume_sold_nerr_check: assert property (@(posedge clk) disable iff (rst) sold_nerr |-> ##(SRAM_DELAY+1) !core.sold_serr && !core.sold_derr);

wire rddat_serr = 0;
wire rddat_derr = 0;
wire rddat_nerr = !rddat_serr && !rddat_derr;
assume_rddat_serr_check: assert property (@(posedge clk) disable iff (rst) rddat_serr |-> ##SRAM_DELAY core.rddat_serr && !core.rddat_derr);
assume_rddat_derr_check: assert property (@(posedge clk) disable iff (rst) rddat_derr |-> ##SRAM_DELAY !core.rddat_serr && core.rddat_derr);
assume_rddat_nerr_check: assert property (@(posedge clk) disable iff (rst) rddat_nerr |-> ##SRAM_DELAY !core.rddat_serr && !core.rddat_derr);

assert_rddat_nerr_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdradr_wire == select_row) && rddat_nerr) |-> ##DRAM_DELAY
					  !core.rddat_ded_err && !core.rddat_sec_err && (datmem[WIDTH-1:0] == core.rddat_post_ecc));
assert_rddat_serr_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdradr_wire == select_row) && rddat_serr) |-> ##DRAM_DELAY
					  !core.rddat_ded_err && core.rddat_sec_err && (datmem[WIDTH-1:0] == core.rddat_post_ecc));
assert_rddat_derr_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdradr_wire == select_row) && rddat_derr) |-> ##DRAM_DELAY
					  core.rddat_ded_err && !core.rddat_sec_err);

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

assert_wrmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire && (core.vwrradr_wire == select_row)) |-> ##(SRAM_DELAY+1)
                                         (core.wrmap_out == mapmem[BITVBNK:0]));
assert_wrdat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire && (core.vwrradr_wire == select_row)) |-> ##(SRAM_DELAY+1)
                                         (core.wrdat_out == datmem));

assert_rdmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdradr_wire == select_row)) |-> ##DRAM_DELAY
                                         (core.rdmap_out == mapmem[BITVBNK:0]));
assert_rddat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdradr_wire == select_row)) |-> ##DRAM_DELAY
                                         (core.rddat_out == datmem));
//assert_rddat_fwd_nerr_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdradr_wire == select_row) && ddout2_nerr) |-> ##DRAM_DELAY
//                                              (!core.rddat_sec_err && !core.rddat_ded_err && (core.rddat_post_ecc == datmem[WIDTH-1:0])));
//assert_rddat_fwd_serr_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdradr_wire == select_row) && ddout2_serr) |-> ##DRAM_DELAY
//                                              (!core.rddat_ded_err && (core.rddat_post_ecc == datmem[WIDTH-1:0])));
//assert_rddat_fwd_derr_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdradr_wire == select_row) && ddout2_derr) |-> ##DRAM_DELAY
//                                              (!core.rddat_sec_err && core.rddat_ded_err) ||
//                                              (!core.rddat_sec_err && !core.rddat_ded_err && (core.rddat_post_ecc == datmem[WIDTH-1:0])));
assert_pdat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdaddr_wire == select_addr)) |-> ##DRAM_DELAY
                                        (meminv || (core.pdat_out == mem)));
//assert_pdat_fwd_nerr_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdaddr_wire == select_addr) && pdat_nerr) |-> ##DRAM_DELAY
//                                             (meminv || (!core.pdat_sec_err && !core.pdat_ded_err && (core.pdat_post_ecc == mem[WIDTH-1:0]))));
//assert_pdat_fwd_serr_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdaddr_wire == select_addr) && pdat_serr) |-> ##DRAM_DELAY
//                                             (meminv || (core.pdat_sec_err && !core.pdat_ded_err && (core.pdat_post_ecc == mem[WIDTH-1:0]))));
//assert_pdat_fwd_derr_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdaddr_wire == select_addr) && pdat_derr) |-> ##DRAM_DELAY
//                                             (meminv || (!core.pdat_sec_err && core.pdat_ded_err)));

reg rmeminv;
reg [WIDTH-1:0] rmem;
always @(posedge clk)
  if (rst) begin
    rmeminv <= 1'b1;
  end else if (core.snew_vld && (core.snew_map == select_bank) && (core.snew_row == select_row)) begin
    rmeminv <= 1'b0;
    rmem <= core.snew_dat;
  end

assert_rmem_check: assert property (@(posedge clk) disable iff (rst) (rmeminv || ((mem_wire[WIDTH-1:0] ^ msk_wire[WIDTH-1:0]) == rmem)));

//generate if (SRAM_DELAY==DRAM_DELAY) begin: vdout_sym_loop
  assert_vdout_int_nerr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr) && pdat_nerr && rddat_nerr) |-> ##(FLOPIN+DRAM_DELAY)
                                                (rmeminv || (!core.vread_serr_tmp && !core.vread_derr_tmp && (core.vdout_int == rmem))));
  assert_vdout_int_serr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr) && (pdat_serr || rddat_serr) && !(pdat_derr || rddat_derr)) |-> ##(FLOPIN+DRAM_DELAY)
                                                (rmeminv || (!core.vread_derr_tmp && (core.vdout_int == rmem))));
  assert_vdout_int_derr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr) && (pdat_derr || rddat_derr)) |-> ##(FLOPIN+DRAM_DELAY)
                                                (rmeminv || core.vread_derr_tmp || (core.vdout_int == rmem)));
//end else begin: vdout_asym_loop
//  assert_vdout_int_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+DRAM_DELAY)
//                                           ($past(rmeminv,DRAM_DELAY-SRAM_DELAY) || (core.vdout_int == $past(rmem,DRAM_DELAY-SRAM_DELAY))));
//end
//endgenerate

reg fakememinv;
reg fakesec;
reg fakeded;
reg [WIDTH-1:0] fakemem;
always @(posedge clk)
  if (rst)
    fakememinv <= 1'b1;
  else if (write && (wr_adr == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din;
  end

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##(FLOPIN+SRAM_DELAY+1)
				       ($past(fakememinv,FLOPIN+SRAM_DELAY+1) ||
                                       ($past(fakemem,FLOPIN+SRAM_DELAY+1) == (mem_wire[WIDTH-1:0] ^ msk_wire[WIDTH-1:0]))));

assert_dout_nerr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr) && pdat_nerr && rddat_nerr) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
                                         (rd_vld && ($past(fakememinv,FLOPIN+DRAM_DELAY+FLOPOUT) ||
                                                     (sec_wire && rd_serr && !rd_derr && (rd_dout == $past(fakemem,FLOPIN+DRAM_DELAY+FLOPOUT))) ||
                                                     (ded_wire && !rd_serr && rd_derr) ||
                                                     (!rd_serr && !rd_derr && (rd_dout == $past(fakemem,FLOPIN+DRAM_DELAY+FLOPOUT))))));
assert_dout_serr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr) && (pdat_serr || rddat_serr) && !(pdat_derr || rddat_derr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
                                         (rd_vld && ($past(fakememinv,FLOPIN+DRAM_DELAY+FLOPOUT) ||
                                                     (!rd_derr && (rd_dout == $past(fakemem,FLOPIN+DRAM_DELAY+FLOPOUT))))));
assert_dout_derr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr) && (pdat_derr || rddat_derr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
                                         (rd_vld && ($past(fakememinv,FLOPIN+DRAM_DELAY+FLOPOUT) ||
                                                     rd_derr || (rd_dout == $past(fakemem,FLOPIN+DRAM_DELAY+FLOPOUT)))));
assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
                                    ($past(fakememinv,FLOPIN+DRAM_DELAY+FLOPOUT) ||
                                     ($past(fakemem,FLOPIN+DRAM_DELAY+FLOPOUT)==rmem) || rd_fwrd));
assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
                                    ((rd_padr == ((NUMVBNK << (BITPADR-BITPBNK)) | (FLOPOUT ? $past(t2_padrB_1_wire) : t2_padrB_1_wire))) ||
				     (rd_padr == {select_bank,(FLOPOUT ? $past(t1_padrB_sel_wire) : t1_padrB_sel_wire)})));

endmodule

