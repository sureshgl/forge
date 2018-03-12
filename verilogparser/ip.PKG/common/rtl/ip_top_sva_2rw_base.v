module ip_top_sva_2_2rw_base
  #(
parameter     WIDTH = 8,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3)
(
  input clk,
  input rst,
  input ready,
  input [2-1:0] read,
  input [2-1:0] write,
  input [2*BITADDR-1:0] addr,
  input [2*NUMVBNK-1:0] t1_readA,
  input [2*NUMVBNK-1:0] t1_writeA,
  input [2*NUMVBNK*BITVROW-1:0] t1_addrA
);
`ifdef FORMAL
//synopsys translate_off

genvar rw_int;
generate for (rw_int=0; rw_int<2; rw_int=rw_int+1) begin: rw_loop
  wire read_wire = read >> rw_int;
  wire write_wire = write >> rw_int;
  wire [BITADDR-1:0] addr_wire = addr >> (rw_int*BITADDR);

  assert_rw_1port_check: assume property (@(posedge clk) disable iff (!ready) !(read_wire && write_wire));
  assert_rw_range_check: assume property (@(posedge clk) disable iff (!ready) (read_wire && write_wire) |-> (addr_wire < NUMADDR));
end
endgenerate

genvar t1_vbnk_int, t1_prpt_int;
generate for (t1_vbnk_int=0; t1_vbnk_int<NUMVBNK; t1_vbnk_int=t1_vbnk_int+1) begin: t1_vbnk_loop
  for (t1_prpt_int=0; t1_prpt_int<2; t1_prpt_int=t1_prpt_int+1) begin: t1_prpt_loop
    wire t1_readA_wire = t1_readA >> (2*t1_vbnk_int+t1_prpt_int);
    wire t1_writeA_wire = t1_writeA >> (2*t1_vbnk_int+t1_prpt_int);
    wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> ((2*t1_vbnk_int+t1_prpt_int)*BITVROW);

    assert_t1_rw_1port_check: assert property (@(posedge clk) disable iff (rst) !(t1_readA_wire && t1_writeA_wire));
//    assert_t1_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire || t1_writeA_wire) |-> (t1_addrA_wire < NUMVROW));
  end
end
endgenerate

genvar t1_psdo_int;
generate
  for (t1_psdo_int=0; t1_psdo_int<NUMVBNK; t1_psdo_int=t1_psdo_int+1) begin: t1_pseudo_loop
    wire t1_readA_0_wire = t1_readA >> (2*t1_psdo_int+0);
    wire t1_writeA_0_wire = t1_writeA >> (2*t1_psdo_int+0);
    wire [BITVROW-1:0] t1_addrA_0_wire = t1_addrA >> ((2*t1_psdo_int+0)*BITVROW);

    wire t1_readA_1_wire = t1_readA >> (2*t1_psdo_int+1);
    wire t1_writeA_1_wire = t1_writeA >> (2*t1_psdo_int+1);
    wire [BITVROW-1:0] t1_addrA_1_wire = t1_addrA >> ((2*t1_psdo_int+1)*BITVROW);

    assert_t1_rw0_pseudo_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_0_wire |->
                                                 !((t1_readA_1_wire || t1_writeA_1_wire) && (t1_addrA_0_wire == t1_addrA_1_wire)));
    assert_t1_rw1_pseudo_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_1_wire |->
                                                 !((t1_readA_0_wire || t1_writeA_0_wire) && (t1_addrA_0_wire == t1_addrA_1_wire)));
  end
endgenerate
//synopsys translate_on
`endif
endmodule


module ip_top_sva_2rw_base
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     ENAPAR = 0,
parameter     ENAECC = 0,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 8,
parameter     BITVROW = 3,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     BITPADR = 13,
parameter     SRAM_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0
   )
(
  input clk,
  input rst,
  input ready,
  input [2*NUMVBNK-1:0] t1_readA,
  input [2*NUMVBNK-1:0] t1_writeA,
  input [2*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [2*NUMVBNK*WIDTH-1:0] t1_dinA,
  input [2*NUMVBNK*WIDTH-1:0] t1_doutA,
  input [2*NUMVBNK-1:0] t1_fwrdA,
  input [2*NUMVBNK-1:0] t1_serrA,
  input [2*NUMVBNK-1:0] t1_derrA,
  input [2*NUMVBNK*(BITPADR-BITVBNK)-1:0] t1_padrA,
  input [2-1:0] read,
  input [2-1:0] write,
  input [2*BITADDR-1:0] addr,
  input [2*WIDTH-1:0] din,
  input [2-1:0] rd_vld,
  input [2*WIDTH-1:0] rd_dout,
  input [2-1:0] rd_fwrd,
  input [2-1:0] rd_serr,
  input [2-1:0] rd_derr,
  input [2*BITPADR-1:0] rd_padr,
  input [BITADDR-1:0] select_addr,
  input [BITWDTH-1:0] select_bit
);
`ifdef FORMAL
//synopsys translate_off

wire [BITVBNK-1:0] select_bank;
wire [BITVROW-1:0] select_vrow;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  sel_adr (.vbadr(select_bank), .vradr(select_vrow), .vaddr(select_addr));

reg t1_writeA_sel [0:2-1];
reg t1_readA_sel [0:2-1];
reg [BITVROW-1:0] t1_addrA_sel [0:2-1];
reg [WIDTH-1:0] t1_dinA_sel [0:2-1];
reg [WIDTH-1:0] t1_doutA_sel [0:2-1];
reg t1_fwrdA_sel [0:2-1];
reg t1_serrA_sel [0:2-1];
reg t1_derrA_sel [0:2-1];
reg [BITPADR-BITVBNK-1:0] t1_padrA_sel [0:2-1];
integer t1_padr_int;
always_comb
  for (t1_padr_int=0; t1_padr_int<2; t1_padr_int=t1_padr_int+1) begin
    t1_writeA_sel[t1_padr_int] = t1_writeA >> (2*select_bank+t1_padr_int);
    t1_readA_sel[t1_padr_int] = t1_readA >> (2*select_bank+t1_padr_int);
    t1_addrA_sel[t1_padr_int] = t1_addrA >> ((2*select_bank+t1_padr_int)*BITVROW);
    t1_dinA_sel[t1_padr_int] = t1_dinA >> ((2*select_bank+t1_padr_int)*WIDTH);
    t1_doutA_sel[t1_padr_int] = t1_doutA >> ((2*select_bank+t1_padr_int)*WIDTH);
    t1_fwrdA_sel[t1_padr_int] = t1_fwrdA >> (2*select_bank+t1_padr_int);
    t1_serrA_sel[t1_padr_int] = t1_serrA >> (2*select_bank+t1_padr_int);
    t1_derrA_sel[t1_padr_int] = t1_derrA >> (2*select_bank+t1_padr_int);
    t1_padrA_sel[t1_padr_int] = t1_padrA >> ((2*select_bank+t1_padr_int)*(BITPADR-BITVBNK));
  end

reg t1_readA_wire [0:2-1][0:NUMVBNK-1];
reg t1_writeA_wire [0:2-1][0:NUMVBNK-1];
reg [BITVROW-1:0] t1_addrA_wire [0:2-1][0:NUMVBNK-1];
reg [WIDTH-1:0] t1_dinA_wire [0:2-1][0:NUMVBNK-1];
integer t1_prpt_int, t1_vbnk_int;
always_comb
  for (t1_vbnk_int=0; t1_vbnk_int<NUMVBNK; t1_vbnk_int=t1_vbnk_int+1) begin
    for (t1_prpt_int=0; t1_prpt_int<2; t1_prpt_int=t1_prpt_int+1) begin
      t1_readA_wire[t1_prpt_int][t1_vbnk_int] = t1_readA >> (2*t1_vbnk_int+t1_prpt_int);
      t1_writeA_wire[t1_prpt_int][t1_vbnk_int] = t1_writeA >> (2*t1_vbnk_int+t1_prpt_int);
      t1_addrA_wire[t1_prpt_int][t1_vbnk_int] = t1_addrA >> ((2*t1_vbnk_int+t1_prpt_int)*BITVROW);
      t1_dinA_wire[t1_prpt_int][t1_vbnk_int] = t1_dinA >> ((2*t1_vbnk_int+t1_prpt_int)*WIDTH);
    end
  end

reg read_wire [0:2-1];
reg write_wire [0:2-1];
reg [BITADDR-1:0] addr_wire [0:2-1];
reg [WIDTH-1:0] din_wire [0:2-1];
reg rd_vld_wire [0:2-1];
reg [WIDTH-1:0] rd_dout_wire [0:2-1];
reg rd_fwrd_wire [0:2-1];
reg rd_serr_wire [0:2-1];
reg rd_derr_wire [0:2-1];
reg [BITPADR-1:0] rd_padr_wire [0:2-1];
integer rw_int;
always_comb
  for (rw_int=0; rw_int<2; rw_int=rw_int+1) begin
    read_wire[rw_int] = read >> rw_int;
    write_wire[rw_int] = write >> rw_int;
    addr_wire[rw_int] = addr >> (rw_int*BITADDR);
    din_wire[rw_int] = din >> (rw_int*WIDTH);
    rd_vld_wire[rw_int] = rd_vld >> rw_int;
    rd_dout_wire[rw_int] = rd_dout >> (rw_int*WIDTH);
    rd_fwrd_wire[rw_int] = rd_fwrd >> rw_int;
    rd_serr_wire[rw_int] = rd_serr >> rw_int;
    rd_derr_wire[rw_int] = rd_derr >> rw_int;
    rd_padr_wire[rw_int] = rd_padr >> (rw_int*BITPADR);
  end

reg meminv;
reg mem;
integer mem_int;
always @(posedge clk)
  if (rst)
    meminv <= 1'b1;
  else for (mem_int=0; mem_int<2; mem_int=mem_int+1)
    if (t1_writeA_sel[mem_int] && (t1_addrA_sel[mem_int] == select_vrow)) begin
      meminv <= 1'b0;
      mem <= t1_dinA_sel[mem_int][select_bit];
    end

genvar memr_int;
generate for (memr_int=0; memr_int<2; memr_int=memr_int+1) begin: memr_loop
  assert_pdout_check: assert property (@(posedge clk) disable iff (rst)
                                       (t1_readA_sel[memr_int] && (t1_addrA_sel[memr_int] == select_vrow)) |-> ##SRAM_DELAY
                                       ($past(meminv,SRAM_DELAY) ||
                                        (!t1_fwrdA_sel[memr_int] && (ENAPAR ? t1_serrA_sel[memr_int] :
                                                                     ENAECC ? t1_derrA_sel[memr_int] : 1'b0)) ||
                                        (t1_doutA_sel[memr_int][select_bit] == $past(mem,SRAM_DELAY))));
end
endgenerate

reg fakememinv;
reg fakemem;
always @(posedge clk)
  if (rst) 
    fakememinv <= 1'b1;
  else if (write_wire[1] && (addr_wire[1] == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din_wire[1][select_bit];
  end else if (write_wire[0] && (addr_wire[0] == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din_wire[0][select_bit];
  end

generate if (FLOPIN) begin: fake_flp_loop
  assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##1
				         ($past(fakememinv) || ($past(fakemem) == ((core.vwrite_del &&
								                   (core.vbadr_del == select_bank) &&
								                   (core.vradr_del == select_vrow)) ? core.vdin_del[select_bit] : mem))));
end else begin: fake_noflp_loop
  assert_fakemem_check: assert property (@(posedge clk) disable iff (rst)
				         (fakememinv || (fakemem == ((core.vwrite_del &&
								     (core.vbadr_del == select_bank) &&
								     (core.vradr_del == select_vrow)) ? core.vdin_del[select_bit] : mem))));
end
endgenerate

genvar doutr_int;
generate for (doutr_int=0; doutr_int<2; doutr_int=doutr_int+1) begin: doutr_loop
  assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (addr_wire[doutr_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_vld_wire[doutr_int] &&
                                       ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) ||
                                        (!rd_fwrd_wire[doutr_int] && ((ENAPAR && rd_serr_wire[doutr_int]) || rd_derr_wire[doutr_int])) ||
                                         (rd_dout_wire[doutr_int][select_bit] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)))));
  assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (addr_wire[doutr_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_fwrd_wire[doutr_int] == ((FLOPOUT ? $past(t1_fwrdA_sel[doutr_int]) : t1_fwrdA_sel[doutr_int]) ||
                                                                   ($past(core.forward_read[doutr_int],FLOPIN+SRAM_DELAY)))));
  assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (addr_wire[doutr_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_serr_wire[doutr_int] == (FLOPOUT ? $past(t1_serrA_sel[doutr_int]) : t1_serrA_sel[doutr_int])) &&
                                      (rd_derr_wire[doutr_int] == (FLOPOUT ? $past(t1_derrA_sel[doutr_int]) : t1_derrA_sel[doutr_int])));
  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (addr_wire[doutr_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_padr_wire[doutr_int] == {select_bank,(FLOPOUT ? $past(t1_padrA_sel[doutr_int]) : t1_padrA_sel[doutr_int])}));
end
endgenerate
//synopsys translate_on
`endif
endmodule


