module ip_top_sva_2_nr2w_1r1w_a653
  #(
parameter     WIDTH   = 32,
parameter     ENAPSDO = 0,
parameter     NUMRDPT = 2,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3
   )
(
  input clk,
  input rst,
  input [NUMRDPT-1:0] read,
  input [NUMRDPT*BITADDR-1:0] rd_adr,
  input [2-1:0] write,
  input [2*BITADDR-1:0]  wr_adr,
  input [NUMRDPT*NUMVBNK-1:0] t1_writeA,
  input [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMRDPT*NUMVBNK-1:0] t1_readB,
  input [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB,
  input [NUMRDPT+1-1:0] t2_writeA,
  input [(NUMRDPT+1)*BITVROW-1:0] t2_addrA,
  input [(NUMRDPT+1)*WIDTH-1:0] t2_dinA,
  input [NUMRDPT+1-1:0] t2_readB,
  input [(NUMRDPT+1)*BITVROW-1:0] t2_addrB,
  input [NUMRDPT+2-1:0] t3_writeA,
  input [(NUMRDPT+2)*BITVROW-1:0] t3_addrA,
  input [(NUMRDPT+2)*(BITVBNK+1)-1:0] t3_dinA,
  input [NUMRDPT+2-1:0] t3_readB,
  input [(NUMRDPT+2)*BITVROW-1:0] t3_addrB
);

genvar rd_int;
generate for (rd_int=0; rd_int<NUMRDPT; rd_int=rd_int+1) begin: rd_loop
  wire read_wire = read >> rd_int;
  wire [BITADDR-1:0] rd_adr_wire = rd_adr >> (rd_int*BITADDR);

  assert_rd_range_check: assert property (@(posedge clk) disable iff (rst) read_wire |-> (rd_adr_wire < NUMADDR));
end
endgenerate

genvar wr_int;
generate for (wr_int=0; wr_int<2; wr_int=wr_int+1) begin: wr_loop
  wire write_wire = write >> wr_int;
  wire [BITADDR-1:0] wr_adr_wire = wr_adr >> (wr_int*BITADDR);

  assert_wr_range_check: assert property (@(posedge clk) disable iff (rst) write_wire |-> (wr_adr_wire < NUMADDR));
end
endgenerate

genvar t1_int;
generate for (t1_int=0; t1_int<NUMRDPT*NUMVBNK; t1_int=t1_int+1) begin: t1_loop
  wire t1_writeA_wire = t1_writeA >> t1_int;
  wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> (t1_int*BITVROW);

  assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMVROW));

  wire t1_readB_wire = t1_readB >> t1_int;
  wire [BITVROW-1:0] t1_addrB_wire = t1_addrB >> (t1_int*BITVROW);

  assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> (t1_addrB_wire < NUMVROW));
  assert_t1_rw_psuedo_check: assert property (@(posedge clk) disable iff (rst) (ENAPSDO && t1_writeA_wire && t1_readB_wire) |-> (t1_addrA_wire != t1_addrB_wire));
end
endgenerate

genvar t2_int;
generate for (t2_int=0; t2_int<NUMRDPT+1; t2_int=t2_int+1) begin: t2_loop
  wire t2_writeA_wire = t2_writeA >> t2_int;
  wire [BITVROW-1:0] t2_addrA_wire = t2_addrA >> (t2_int*BITVROW);
  wire [WIDTH-1:0] t2_dinA_wire = t2_dinA >> (t2_int*WIDTH);

  wire t2_writeA_0_wire = t2_writeA;
  wire [BITVROW-1:0] t2_addrA_0_wire = t2_addrA;
  wire [WIDTH-1:0] t2_dinA_0_wire = t2_dinA;

  wire t2_readB_wire = t2_readB >> t2_int;
  wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> (t2_int*BITVROW);

  assert_t2_wr_same_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_writeA_0_wire &&
                                                                                                 (t2_addrA_0_wire == t2_addrA_wire) &&
                                                                                                 (t2_dinA_0_wire == t2_dinA_wire)));
  assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_addrA_wire < NUMVROW));
  assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire |-> (t2_addrB_wire < NUMVROW));
  assert_t2_rw_psuedo_check: assert property (@(posedge clk) disable iff (rst) (ENAPSDO && t2_writeA_wire && t2_readB_wire) |-> (t2_addrA_wire != t2_addrB_wire));
end
endgenerate

genvar t3_int;
generate for (t3_int=0; t3_int<NUMRDPT+2; t3_int=t3_int+1) begin: t3_loop
  wire t3_writeA_wire = t3_writeA >> t3_int;
  wire [BITVROW-1:0] t3_addrA_wire = t3_addrA >> (t3_int*BITVROW);
  wire [(BITVBNK+1)-1:0] t3_dinA_wire = t3_dinA >> (t3_int*(BITVBNK+1));

  wire t3_writeA_0_wire = t3_writeA;
  wire [BITVROW-1:0] t3_addrA_0_wire = t3_addrA;
  wire [(BITVBNK+1)-1:0] t3_dinA_0_wire = t3_dinA;

  wire t3_readB_wire = t3_readB >> t3_int;
  wire [BITVROW-1:0] t3_addrB_wire = t3_addrB >> (t3_int*BITVROW);

  assert_t3_wr_same_check: assert property (@(posedge clk) disable iff (rst) t3_writeA_wire |-> (t3_writeA_0_wire &&
                                                                                                 (t3_addrA_0_wire == t3_addrA_wire) &&
                                                                                                 (t3_dinA_0_wire == t3_dinA_wire)));
  assert_t3_wr_range_check: assert property (@(posedge clk) disable iff (rst) t3_writeA_wire |-> (t3_addrA_wire < NUMVROW));
  assert_t3_rd_range_check: assert property (@(posedge clk) disable iff (rst) t3_readB_wire |-> (t3_addrB_wire < NUMVROW));
  assert_t3_rw_psuedo_check: assert property (@(posedge clk) disable iff (rst) (ENAPSDO && t3_writeA_wire && t3_readB_wire) |-> (t3_addrA_wire != t3_addrB_wire));
end
endgenerate

endmodule

module ip_top_sva_nr2w_1r1w_a653
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     ENAPAR  = 0,
parameter     ENAECC  = 0,
parameter     NUMRDPT = 2,
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
parameter     FLOPOUT = 0
   )
(
  input clk,
  input rst,
  input [2-1:0] write,
  input [2*BITADDR-1:0]  wr_adr,
  input [2*WIDTH-1:0] din,
  input [NUMRDPT-1:0] read,
  input [NUMRDPT*BITADDR-1:0] rd_adr,
  input [NUMRDPT-1:0] rd_vld,
  input [NUMRDPT*WIDTH-1:0] rd_dout,
  input [NUMRDPT-1:0] rd_fwrd,
  input [NUMRDPT-1:0] rd_serr,
  input [NUMRDPT-1:0] rd_derr,
  input [NUMRDPT*BITPADR-1:0] rd_padr,
  input [NUMRDPT*NUMVBNK-1:0] t1_writeA,
  input [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMRDPT*NUMVBNK-1:0] t1_readB,
  input [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB,
  input [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_doutB,
  input [NUMRDPT*NUMVBNK-1:0] t1_fwrdB,
  input [NUMRDPT*NUMVBNK-1:0] t1_serrB,
  input [NUMRDPT*NUMVBNK-1:0] t1_derrB,
  input [NUMRDPT*NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrB,
  input [(NUMRDPT+1)-1:0] t2_writeA,
  input [(NUMRDPT+1)*BITVROW-1:0] t2_addrA,
  input [(NUMRDPT+1)*WIDTH-1:0] t2_dinA,
  input [(NUMRDPT+1)-1:0] t2_readB,
  input [(NUMRDPT+1)*BITVROW-1:0] t2_addrB,
  input [(NUMRDPT+1)*WIDTH-1:0] t2_doutB,
  input [(NUMRDPT+1)-1:0] t2_fwrdB,
  input [(NUMRDPT+1)-1:0] t2_serrB,
  input [(NUMRDPT+1)-1:0] t2_derrB,
  input [(NUMRDPT+1)*(BITPADR-BITPBNK)-1:0] t2_padrB,
  input [(NUMRDPT+2)-1:0] t3_writeA,
  input [(NUMRDPT+2)*BITVROW-1:0] t3_addrA,
  input [(NUMRDPT+2)*(BITVBNK+1)-1:0] t3_dinA,
  input [(NUMRDPT+2)-1:0] t3_readB,
  input [(NUMRDPT+2)*BITVROW-1:0] t3_addrB,
  input [(NUMRDPT+2)*(BITVBNK+1)-1:0] t3_doutB,
  input [(NUMRDPT+2)-1:0] t3_fwrdB,
  input [(NUMRDPT+2)-1:0] t3_serrB,
  input [(NUMRDPT+2)-1:0] t3_derrB,
  input [(NUMRDPT+2)*(BITPADR-BITPBNK)-1:0] t3_padrB,
  input [BITADDR-1:0] select_addr,
  input [BITWDTH-1:0] select_bit
);

wire [BITVBNK-1:0] select_bank;
wire [BITVROW-1:0] select_row;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  sel_inst (.vbadr(select_bank), .vradr(select_row), .vaddr(select_addr));

wire [BITVROW-1:0] wr_row_1;
np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
           .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
           .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  wr_inst (.vbadr(), .vradr(wr_row_1), .vaddr(wr_adr[2*BITADDR-1:BITADDR]));

/*
assert_rw_wr_np2_check: assert property (@(posedge clk) disable iff (rst) (read_0 && write_1) |->
					 ((rd_adr_0 == wr_adr_1) == ((core.vrdbadr == core.vwrbadr) && (core.vrdradr == core.vwrradr))));
*/
genvar np2_int;
generate begin: np2_loop
  assert_sl_np2_range_check: assert property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR) |->
					      ((select_bank < NUMVBNK) && (select_row < NUMVROW))); 

  for (np2_int=0; np2_int<2; np2_int=np2_int+1) begin: wr_loop
    wire write_wire = write >> np2_int;

    assert_wr_sl_np2_check: assert property (@(posedge clk) disable iff (rst) write_wire |-> ##FLOPIN
					     ((core.vwraddr_wire[np2_int] == select_addr) == ((core.vwrbadr_wire[np2_int] == select_bank) && (core.vwrradr_wire[np2_int] == select_row)))); 
    assert_wr_np2_range_check: assert property (@(posedge clk) disable iff (rst) write_wire |-> ##FLOPIN
					        ((core.vwrbadr_wire[np2_int] < NUMVBNK) && (core.vwrradr_wire[np2_int] < NUMVROW)));
  end

  for (np2_int=0; np2_int<NUMRDPT; np2_int=np2_int+1) begin: rd_loop
    wire read_wire = read >> np2_int;

    assert_rd_sl_np2_check: assert property (@(posedge clk) disable iff (rst) read_wire |-> ##FLOPIN
					     ((core.vrdaddr_wire[np2_int] == select_addr) == ((core.vrdbadr_wire[np2_int] == select_bank) && (core.vrdradr_wire[np2_int] == select_row)))); 
    assert_rd_np2_range_check: assert property (@(posedge clk) disable iff (rst) read_wire |-> ##FLOPIN
					        ((core.vrdbadr_wire[np2_int] < NUMVBNK) && (core.vrdradr_wire[np2_int] < NUMVROW)));
  end
end
endgenerate

reg t1_doutB_selb_wire [0:NUMRDPT-1];
reg t2_doutB_selb_wire [0:NUMRDPT-1];
integer dsel_int;
always_comb
  for (dsel_int=0; dsel_int<NUMRDPT; dsel_int=dsel_int+1) begin
    t1_doutB_selb_wire[dsel_int] = t1_doutB >> ((dsel_int*NUMVBNK+select_bank)*WIDTH+select_bit);
    t2_doutB_selb_wire[dsel_int] = t2_doutB >> (dsel_int*WIDTH+select_bit);
  end

reg meminv;
reg mem;
always @(posedge clk)
  if (rst)
    meminv <= 1'b1;
  else if (t1_writeA[select_bank] && (((t1_addrA >> (select_bank*BITVROW)) & {BITVROW{1'b1}}) == select_row)) begin
    meminv <= 1'b0;
    mem <= t1_dinA[select_bank*WIDTH+select_bit];
  end

reg [BITVBNK:0] mapmem;
always @(posedge clk)
  if (rst)
    mapmem <= 0;
  else if (t3_writeA[0] && ((t3_addrA & {BITVROW{1'b1}}) == select_row))
    mapmem <= t3_dinA;

reg datmem;
always @(posedge clk)
  if (rst)
    datmem <= 0;
  else if (t2_writeA[0] && ((t2_addrA & {BITVROW{1'b1}}) == select_row))
    datmem <= t2_dinA[select_bit];

wire mem_wire = (mapmem[BITVBNK] && (mapmem[BITVBNK-1:0] == select_bank)) ? datmem : mem;

genvar t1_dout_int;
generate for (t1_dout_int=0; t1_dout_int<NUMRDPT; t1_dout_int=t1_dout_int+1) begin: pdout_loop
  wire t1_readB_wire = t1_readB >> (select_bank+(t1_dout_int*NUMVBNK));
  wire [BITVROW-1:0] t1_addrB_wire = t1_addrB >> ((select_bank+(t1_dout_int*NUMVBNK))*BITVROW);
  wire [WIDTH-1:0] t1_doutB_wire = t1_doutB >> ((select_bank+(t1_dout_int*NUMVBNK))*WIDTH);
  wire t1_fwrdB_wire = t1_fwrdB >> (select_bank+(t1_dout_int*NUMVBNK));
  wire t1_serrB_wire = t1_serrB >> (select_bank+(t1_dout_int*NUMVBNK));
  wire t1_derrB_wire = t1_derrB >> (select_bank+(t1_dout_int*NUMVBNK));

  assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire && (t1_addrB_wire == select_row)) |-> ##SRAM_DELAY
                                       ($past(meminv,SRAM_DELAY) ||
                                       (!t1_fwrdB_wire && (ENAPAR ? t1_serrB_wire : ENAECC ? t1_derrB_wire : 0)) ||
                                       (t1_doutB_wire[select_bit] == $past(mem,SRAM_DELAY))));
end
endgenerate

genvar t2_dout_int;
generate for (t2_dout_int=0; t2_dout_int<NUMRDPT+1; t2_dout_int=t2_dout_int+1) begin: cdout_loop
  wire t2_readB_wire = t2_readB >> t2_dout_int;
  wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> (t2_dout_int*BITVROW);
  wire [WIDTH-1:0] t2_doutB_wire = t2_doutB >> (t2_dout_int*WIDTH);
  wire t2_fwrdB_wire = t2_fwrdB >> t2_dout_int;
  wire t2_serrB_wire = t2_serrB >> t2_dout_int;
  wire t2_derrB_wire = t2_derrB >> t2_dout_int;

  assert_cdout_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire && (t2_addrB_wire == select_row)) |-> ##SRAM_DELAY
                                       (t2_doutB_wire[select_bit] == $past(datmem,SRAM_DELAY)));
end
endgenerate

genvar t3_dout_int;
generate for (t3_dout_int=0; t3_dout_int<NUMRDPT+2; t3_dout_int=t3_dout_int+1) begin: sdout_loop
  wire t3_readB_wire = t3_readB >> t3_dout_int;
  wire [BITVROW-1:0] t3_addrB_wire = t3_addrB >> (t3_dout_int*BITVROW);
  wire [BITVBNK:0] t3_doutB_wire = t3_doutB >> (t3_dout_int*(BITVBNK+1));

  assert_sdout_check: assert property (@(posedge clk) disable iff (rst) (t3_readB_wire && (t3_addrB_wire == select_row)) |-> ##SRAM_DELAY
                                       (t3_doutB_wire == $past(mapmem,SRAM_DELAY)));
end
endgenerate

assert_wrmapa_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[0] && (core.vwrradr_wire[0] == select_row)) |-> ##(SRAM_DELAY+1)
                                          (core.wrmapa_out == mapmem[BITVBNK:0]));
assert_wrmapb_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[1] && (core.vwrradr_wire[1] == select_row)) |-> ##(SRAM_DELAY+1)
                                          (core.wrmapb_out == mapmem[BITVBNK:0]));
assert_wrdatb_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[1] && (core.vwrradr_wire[1] == select_row)) |-> ##(SRAM_DELAY+1)
                                          (core.wrdatb_out[select_bit] == datmem));

genvar rdm_int;
generate for (rdm_int=0; rdm_int<NUMRDPT; rdm_int=rdm_int+1) begin: rdm_loop
  wire t1_fwrdB_wire = t1_fwrdB >> (select_bank+(rdm_int*NUMVBNK));
  wire t1_serrB_wire = t1_serrB >> (select_bank+(rdm_int*NUMVBNK));
  wire t1_derrB_wire = t1_derrB >> (select_bank+(rdm_int*NUMVBNK));

  wire t2_fwrdB_wire = t2_fwrdB >> rdm_int;
  wire t2_serrB_wire = t2_serrB >> rdm_int;
  wire t2_derrB_wire = t2_derrB >> rdm_int;

  assert_rdmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[rdm_int] && (core.vrdradr_wire[rdm_int] == select_row)) |-> ##SRAM_DELAY
                                           (core.vdo_loop[rdm_int].rdmap_out == mapmem[BITVBNK:0]));
  assert_rcdat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[rdm_int] && (core.vrdradr_wire[rdm_int] == select_row)) |-> ##SRAM_DELAY
                                           (core.vdo_loop[rdm_int].rcdat_out[select_bit] == datmem));
  assert_rpdat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[rdm_int] && (core.vrdbadr_wire[rdm_int] == select_bank) && (core.vrdradr_wire[rdm_int] == select_row)) |-> ##SRAM_DELAY
                                           (meminv || (!t1_fwrdB_wire && !core.rpdat_vld[rdm_int][SRAM_DELAY-1] &&
                                                       (ENAPAR ? t1_serrB_wire : ENAECC ? t1_derrB_wire : 1'b0)) ||
                                           (core.vdo_loop[rdm_int].rpdat_out[select_bit] == mem)));

//  assert_rdmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[rdm_int] && (core.vrdradr_wire[rdm_int] == select_row)) |-> ##SRAM_DELAY
//                                           (core.sdout_final[rdm_int] == $past(mapmem[BITVBNK:0],SRAM_DELAY)));

//  assert_rddat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[rdm_int] && (core.vrdradr_wire[rdm_int] == select_row)) |-> ##SRAM_DELAY
//                                           (core.cdout_wire[rdm_int][select_bit] == $past(datmem,SRAM_DELAY)));

end
endgenerate

reg rmeminv;
reg rmem;
always @(posedge clk)
  if (rst)
    rmeminv <= 1'b1;
  else if (core.vwriteb_out && (core.vwrbadrb_out == select_bank) && (core.vwrradrb_out == select_row)) begin
    rmeminv <= 1'b0;
    rmem <= core.vdinb_out[select_bit];
  end else if (core.vwritea_out && (core.vwrbadra_out == select_bank) && (core.vwrradra_out == select_row)) begin
    rmeminv <= 1'b0;
    rmem <= core.vdina_out[select_bit];
  end

assert_rmem_check: assert property (@(posedge clk) disable iff (rst) (rmeminv || (mem_wire == rmem)));

reg fakemem;
reg fakememinv;
always @(posedge clk)
  if (rst)
    fakememinv <= 1'b1;
  else if (write[1] && ((wr_adr >> BITADDR) == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din[select_bit+WIDTH];
  end else if (write[0] && ((wr_adr & {BITADDR{1'b1}}) == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din[select_bit];
  end

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##(FLOPIN+SRAM_DELAY+1)
				       ($past(fakememinv,FLOPIN+SRAM_DELAY+1) || ($past(fakemem,FLOPIN+SRAM_DELAY+1) == mem_wire)));

reg [WIDTH-1:0] t1_doutB_sel_wire [0:NUMRDPT-1];
reg [WIDTH-1:0] t2_doutB_sel_wire [0:NUMRDPT-1];
genvar rd_dout_int;
generate for (rd_dout_int=0; rd_dout_int<NUMRDPT; rd_dout_int=rd_dout_int+1) begin: rd_dout_loop
  wire read_wire = read >> rd_dout_int;
  wire [BITADDR-1:0] rd_adr_wire = rd_adr >> (rd_dout_int*BITADDR);
  wire rd_vld_wire = rd_vld >> rd_dout_int;
  wire [WIDTH-1:0] rd_dout_wire = rd_dout >> (rd_dout_int*WIDTH);
  wire rd_fwrd_wire = rd_fwrd >> rd_dout_int;
  wire rd_serr_wire = rd_serr >> rd_dout_int;
  wire rd_derr_wire = rd_derr >> rd_dout_int;
  wire [BITPADR-1:0] rd_padr_wire = rd_padr >> (rd_dout_int*BITPADR);

  wire t1_fwrdB_sel_wire = t1_fwrdB >>  (NUMVBNK*rd_dout_int+select_bank);
  wire t1_serrB_sel_wire = t1_serrB >>  (NUMVBNK*rd_dout_int+select_bank);
  wire t1_derrB_sel_wire = t1_derrB >>  (NUMVBNK*rd_dout_int+select_bank);
  wire [BITPADR-BITPBNK-1:0] t1_padrB_sel_wire = t1_padrB >> ((NUMVBNK*rd_dout_int+select_bank)*(BITPADR-BITPBNK));

  wire t2_fwrdB_sel_wire = t2_fwrdB >> rd_dout_int;
  wire t2_serrB_sel_wire = t2_serrB >> rd_dout_int;
  wire t2_derrB_sel_wire = t2_derrB >> rd_dout_int;
  wire [BITPADR-BITPBNK-1:0] t2_padrB_sel_wire = t2_padrB >> (rd_dout_int*(BITPADR-BITPBNK));

  assert_vdout_int_check: assert property (@(posedge clk) disable iff (rst) (read_wire && (rd_adr_wire == select_addr)) |-> ##(FLOPIN+SRAM_DELAY)
                                           (rmeminv || (!core.vread_fwrd_int[rd_dout_int] && (ENAPAR ? core.vread_serr_wire[rd_dout_int] : ENAECC ? core.vread_derr_wire[rd_dout_int] : 1'b0)) ||
                                           (core.vdout_int[rd_dout_int][select_bit] == rmem)));
  assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read_wire && (rd_adr_wire == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_vld_wire && ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) ||
                                                       (!rd_fwrd_wire && (ENAPAR ? rd_serr_wire : ENAECC ? rd_derr_wire : 1'b0)) ||
                                                       (rd_dout_wire[select_bit] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)))));
  assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read_wire && (rd_adr_wire == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) ||
                                       $past(fakemem==mem_wire,FLOPIN+SRAM_DELAY+FLOPOUT) || rd_fwrd_wire) &&
                                      (rd_fwrd_wire || !((rd_padr_wire[BITPADR-1:BITPADR-BITPBNK] == NUMVBNK) ?
                                                         (FLOPOUT ? $past(t2_fwrdB_sel_wire) : t2_fwrdB_sel_wire) :
                                                         (FLOPOUT ? $past(t1_fwrdB_sel_wire) : t1_fwrdB_sel_wire))));
  assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire && (rd_adr_wire == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) ||
                                      (((rd_padr_wire[BITPADR-1:BITPADR-BITPBNK] == NUMVBNK) ?
                                        (rd_serr_wire == (FLOPOUT ? $past(t2_serrB_sel_wire) : t2_serrB_sel_wire)) :
                                        (rd_serr_wire == (FLOPOUT ? $past(t1_serrB_sel_wire) : t1_serrB_sel_wire))) &&
                                       ((rd_padr_wire[BITPADR-1:BITPADR-BITPBNK] == NUMVBNK) ?
                                        (rd_derr_wire == (FLOPOUT ? $past(t2_derrB_sel_wire) : t2_derrB_sel_wire)) :
                                        (rd_derr_wire == (FLOPOUT ? $past(t1_derrB_sel_wire) : t1_derrB_sel_wire))))));
  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire && (rd_adr_wire == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_padr_wire == ((NUMVBNK << (BITPADR-BITPBNK)) | (FLOPOUT ? $past(t2_padrB_sel_wire) : t2_padrB_sel_wire))) ||
                                      (rd_padr_wire == {select_bank,(FLOPOUT ? $past(t1_padrB_sel_wire) : t1_padrB_sel_wire)}));

end
endgenerate

endmodule


