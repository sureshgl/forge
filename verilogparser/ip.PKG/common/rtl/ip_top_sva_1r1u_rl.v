module ip_top_sva_2_1r1u_rl
  #(
parameter     WIDTH   = 32,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     SRAM_DELAY = 2,
parameter     SDOUT_WIDTH = BITVBNK+1
   )
(
  input clk,
  input rst,
  input ready,
  input read,
  input [BITADDR-1:0] rd_adr,
  input write,
  input [NUMVBNK-1:0] t1_readA,
  input [NUMVBNK-1:0] t1_writeA,
  input [NUMVBNK*BITVROW-1:0] t1_addrA,
  input t2_writeA,
  input [BITVROW-1:0] t2_addrA,
  input t2_readB,
  input [BITVROW-1:0] t2_addrB,
  input t3_writeA,
  input [BITVROW-1:0] t3_addrA,
  input t3_readB,
  input [BITVROW-1:0] t3_addrB
);

assert_rd_range_check: assert property (@(posedge clk) disable iff (rst) read |-> (rd_adr < NUMADDR));
assert_wr_update_check: assert property (@(posedge clk) disable iff (rst) !read |-> ##SRAM_DELAY !write);

genvar t1_int;
generate for (t1_int=0; t1_int<NUMVBNK; t1_int=t1_int+1) begin: t1_loop
  wire t1_readA_wire = t1_readA >> t1_int;
  wire t1_writeA_wire = t1_writeA >> t1_int;
  wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> (t1_int*BITVROW);

  assert_t1_1port_check: assert property (@(posedge clk) disable iff (rst) !(t1_readA_wire && t1_writeA_wire));
  assert_t1_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire || t1_writeA_wire) |-> (t1_addrA_wire < NUMVROW));
end
endgenerate

genvar t2_int;
generate for (t2_int=0; t2_int<1; t2_int=t2_int+1) begin: t2_loop
  wire t2_writeA_wire = t2_writeA >> t2_int;
  wire [BITVROW-1:0] t2_addrA_wire = t2_addrA >> (t2_int*BITVROW);

  wire t2_readB_wire = t2_readB >> t2_int;
  wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> (t2_int*BITVROW);

  assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_addrA_wire < NUMVROW));
  assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire |-> (t2_addrB_wire < NUMVROW));
//  assert_t2_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t2_writeA_wire && t2_readB_wire) |-> (t2_addrA_wire != t2_addrB_wire));
end
endgenerate

genvar t3_int;
generate for (t3_int=0; t3_int<1; t3_int=t3_int+1) begin: t3_loop
  wire t3_writeA_wire = t3_writeA >> t3_int;
  wire [BITVROW-1:0] t3_addrA_wire = t3_addrA >> (t3_int*BITVROW);

  wire t3_readB_wire = t3_readB >> t3_int;
  wire [BITVROW-1:0] t3_addrB_wire = t3_addrB >> (t3_int*BITVROW);

  assert_t3_wr_range_check: assert property (@(posedge clk) disable iff (rst) t3_writeA_wire |-> (t3_addrA_wire < NUMVROW));
  assert_t3_rd_range_check: assert property (@(posedge clk) disable iff (rst) t3_readB_wire |-> (t3_addrB_wire < NUMVROW));
//  assert_t3_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t3_writeA_wire && t3_readB_wire) |-> (t3_addrA_wire != t3_addrB_wire));
end
endgenerate

endmodule

module ip_top_sva_1r1u_rl
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     ENAPAR = 0,
parameter     ENAECC = 0,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     BITPBNK = 4,
parameter     BITPADR = 14,
parameter     SRAM_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0,
parameter     SDOUT_WIDTH = BITVBNK+1
   )
(
  input clk,
  input rst,
  input write,
  input [WIDTH-1:0] din,
  input read,
  input [BITADDR-1:0] rd_adr,
  input rd_vld,
  input [WIDTH-1:0] rd_dout,
  input rd_fwrd,
  input rd_serr,
  input rd_derr,
  input [BITPADR-1:0] rd_padr,
  input [NUMVBNK-1:0] t1_readA,
  input [NUMVBNK-1:0] t1_writeA,
  input [NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMVBNK*WIDTH-1:0] t1_doutA,
  input [NUMVBNK-1:0] t1_fwrdA,
  input [NUMVBNK-1:0] t1_serrA,
  input [NUMVBNK-1:0] t1_derrA,
  input [NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrA,
  input t2_writeA,
  input [BITVROW-1:0] t2_addrA,
  input [WIDTH-1:0] t2_dinA,
  input t2_readB,
  input [BITVROW-1:0] t2_addrB,
  input [WIDTH-1:0] t2_doutB,
  input t2_fwrdB,
  input t2_serrB,
  input t2_derrB,
  input [BITVROW-1:0] t2_padrB,
  input t3_writeA,
  input [BITVROW-1:0] t3_addrA,
  input [SDOUT_WIDTH-1:0] t3_dinA,
  input t3_readB,
  input [BITVROW-1:0] t3_addrB,
  input [SDOUT_WIDTH-1:0] t3_doutB,
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

assert_rd_sl_np2_check: assert property (@(posedge clk) disable iff (rst) (read) |-> ##FLOPIN
					 ((core.vrdaddr_wire == select_addr) == ((core.vrdbadr_wire == select_bank) && (core.vrdradr_wire == select_row)))); 

assert_rd_np2_range_check: assert property (@(posedge clk) disable iff (rst) (read) |-> ##FLOPIN
					    ((core.vrdbadr_wire < NUMVBNK) && (core.vrdradr_wire < NUMVROW)));
assert_sl_np2_range_check: assert property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR) |->
					    ((select_bank < NUMVBNK) && (select_row < NUMVROW))); 

wire t1_readA_sel_wire = t1_readA >> select_bank;
wire t1_writeA_sel_wire = t1_writeA >> select_bank;
wire [BITVROW-1:0] t1_addrA_sel_wire = t1_addrA >> (select_bank*BITVROW);
wire [WIDTH-1:0] t1_dinA_sel_wire = t1_dinA >> (select_bank*WIDTH);
wire [WIDTH-1:0] t1_doutA_sel_wire = t1_doutA >> (select_bank*WIDTH);
wire t1_fwrdA_sel_wire = t1_fwrdA >> select_bank;
wire t1_serrA_sel_wire = t1_serrA >> select_bank;
wire t1_derrA_sel_wire = t1_derrA >> select_bank;
wire [BITPADR-BITPBNK-1:0] t1_padrA_sel_wire = t1_padrA >> (select_bank*(BITPADR-BITPBNK));
wire t1_doutA_sel_sel_wire = t1_doutA_sel_wire >> select_bit;
wire t2_doutB_sel_wire = t2_doutB >> select_bit;

wire rd_dout_sel_wire = rd_dout >> select_bit;

reg meminv;
reg mem;
always @(posedge clk)
  if (rst) begin
    meminv <= 1'b1;
  end else if (t1_writeA_sel_wire && (t1_addrA_sel_wire == select_row)) begin
    meminv <= 1'b0;
    mem <= t1_dinA_sel_wire[select_bit];
  end

reg [SDOUT_WIDTH-1:0] mapmem;
always @(posedge clk)
  if (rst)
    mapmem <= 0;
  else if (t3_writeA && (t3_addrA == select_row))
    mapmem <= t3_dinA;

reg datmem;
always @(posedge clk)
  if (rst)
    datmem <= 0;
  else if (t2_writeA && (t2_addrA == select_row))
    datmem <= t2_dinA[select_bit];

wire mem_wire = (mapmem[BITVBNK] && (mapmem[BITVBNK-1:0] == select_bank)) ? datmem : mem;

assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_sel_wire && (t1_addrA_sel_wire == select_row)) |-> ##SRAM_DELAY
                                     ($past(meminv,SRAM_DELAY) ||
                                      (!t1_fwrdA_sel_wire && (ENAPAR ? t1_serrA_sel_wire : ENAECC ? t1_derrA_sel_wire : 1'b0)) ||
                                      (t1_doutA_sel_sel_wire == $past(mem,SRAM_DELAY))));

assert_sdout_check: assert property (@(posedge clk) disable iff (rst) (t3_readB && (t3_addrB == select_row)) |-> ##SRAM_DELAY
                                     (t3_doutB == $past(mapmem,SRAM_DELAY)));

assert_cdout_check: assert property (@(posedge clk) disable iff (rst) (t2_readB && (t2_addrB == select_row)) |-> ##SRAM_DELAY
                                     ((!t2_fwrdB && (ENAPAR ? t2_serrB : ENAECC ? t2_derrB : 1'b0)) ||
                                      (t2_doutB_sel_wire == $past(datmem,SRAM_DELAY))));

assert_wrmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdradr_wire == select_row)) |-> ##SRAM_DELAY
                                         (core.wrmap_out == mapmem));
assert_wcdat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdradr_wire == select_row)) |-> ##SRAM_DELAY
                                         (core.wcdat_out[select_bit] == datmem));

reg [BITADDR-1:0] rd_adr_reg [0:SRAM_DELAY-1];
integer wa_int;
always @(posedge clk)
  for (wa_int=0; wa_int<SRAM_DELAY; wa_int=wa_int+1)
    if (wa_int>0)
      rd_adr_reg[wa_int] <= rd_adr_reg[wa_int-1];
    else
      rd_adr_reg[wa_int] <= rd_adr;

reg fakememinv;
reg fakemem;
always @(posedge clk)
  if (rst)
    fakememinv <= 1'b1;
  else if (write && (rd_adr_reg[SRAM_DELAY-1] == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din[select_bit];
  end

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) (fakememinv || (mem_wire == fakemem)));

assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                    (rd_vld && ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) ||
                                                (ENAPAR ? (rd_serr && !rd_fwrd) || (rd_dout_sel_wire == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)) :
                                                 ENAECC ? (rd_derr && !rd_fwrd) || (rd_dout_sel_wire == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)) :
                                                          (rd_dout_sel_wire == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT))))));

assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                    (($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT)) ||
                                     ((rd_padr[BITPADR-1:BITPADR-BITPBNK] != NUMVBNK) &&
                                      (rd_serr == (FLOPOUT ? $past(t1_serrA_sel_wire) : t1_serrA_sel_wire)) &&
                                      (rd_derr == (FLOPOUT ? $past(t1_derrA_sel_wire) : t1_derrA_sel_wire))) ||
                                     ((rd_padr[BITPADR-1:BITPADR-BITPBNK] == NUMVBNK) &&
                                      (rd_serr == (FLOPOUT ? $past(t2_serrB) : t2_serrB)) &&
                                      (rd_derr == (FLOPOUT ? $past(t2_derrB) : t2_derrB)))));

assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                    (rd_fwrd || ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT)) ||
                                     ((rd_padr[BITPADR-1:BITPADR-BITPBNK] != NUMVBNK) &&
                                      (rd_dout_sel_wire == (FLOPOUT ? $past(t1_doutA_sel_sel_wire) : t1_doutA_sel_sel_wire))) ||
                                     ((rd_padr[BITPADR-1:BITPADR-BITPBNK] == NUMVBNK) &&
                                      (rd_dout_sel_wire == (FLOPOUT ? $past(t2_doutB_sel_wire) : t2_doutB_sel_wire)))));

assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                    ((rd_padr == {NUMVBNK,(FLOPOUT ? $past(t2_padrB) : t2_padrB)}) ||
				     (rd_padr == {select_bank,(FLOPOUT ? $past(t1_padrA_sel_wire) : t1_padrA_sel_wire)})));

endmodule

