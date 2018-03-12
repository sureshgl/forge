module ip_top_sva_2_nror1w_dup
  #(
parameter WIDTH = 8,
parameter NUMRDPT = 4,
parameter NUMADDR = 8192,
parameter BITADDR = 13,
parameter NUMVROW = 1024,
parameter BITVROW = 10,
parameter NUMVBNK = 8,
parameter BITVBNK = 3,
parameter REFRESH = 10)
(
  input clk,
  input rst,
  input ready,
  input refr,
  input [NUMRDPT-1:0] read,
  input [NUMRDPT*BITADDR-1:0] rd_adr,
  input write,
  input [BITADDR-1:0]  wr_adr,
  input [NUMRDPT*NUMVBNK-1:0] t1_readA,
  input [NUMRDPT*NUMVBNK-1:0] t1_writeA,
  input [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_dinA
);
`ifdef FORMAL
//synopsys translate_off

generate if (REFRESH) begin: refr_loop
assert_refr_noacc_check: assume property (@(posedge clk) disable iff (rst) !(refr && (write || |read)));
end
endgenerate

assert_rd_wr_check: assume property (@(posedge clk) disable iff (!ready) !(write && |read));
//assert_wr_range_check: assume property (@(posedge clk) disable iff (!ready) write |-> (wr_adr < NUMADDR));
genvar rd_int;
generate for (rd_int=0; rd_int<NUMRDPT; rd_int=rd_int+1) begin: rd_loop
  wire read_wire = read >> rd_int;
  wire [BITADDR-1:0] rd_adr_wire = rd_adr >> (rd_int*BITADDR);

//  assert_rd_range_check: assume property (@(posedge clk) disable iff (!ready) read_wire |-> (rd_adr_wire < NUMADDR));
end
endgenerate

genvar t1_vbnk_int, t1_prpt_int;
generate for (t1_vbnk_int=0; t1_vbnk_int<NUMVBNK; t1_vbnk_int=t1_vbnk_int+1) begin: t1_vbnk_loop
  for (t1_prpt_int=0; t1_prpt_int<NUMRDPT; t1_prpt_int=t1_prpt_int+1) begin: t1_prpt_loop
    wire t1_readA_wire = t1_readA >> (NUMRDPT*t1_vbnk_int+t1_prpt_int);
    wire t1_writeA_wire = t1_writeA >> (NUMRDPT*t1_vbnk_int+t1_prpt_int);
    wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> ((NUMRDPT*t1_vbnk_int+t1_prpt_int)*BITVROW);
    wire [WIDTH-1:0] t1_dinA_wire = t1_dinA >> ((NUMRDPT*t1_vbnk_int+t1_prpt_int)*WIDTH);

    wire t1_writeA_0_wire = t1_writeA >> (NUMRDPT*t1_vbnk_int);
    wire [BITVROW-1:0] t1_addrA_0_wire = t1_addrA >> (NUMRDPT*t1_vbnk_int*BITVROW);
    wire [WIDTH-1:0] t1_dinA_0_wire = t1_dinA >> (NUMRDPT*t1_vbnk_int*WIDTH);

    assert_t1_1port_check: assert property (@(posedge clk) disable iff (rst) !(t1_readA_wire && t1_writeA_wire));
//    assert_t1_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire || t1_writeA_wire) |-> (t1_addrA_wire < NUMVROW));
    assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMVROW));
    assert_t1_wr_same_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |->
					      (t1_writeA_0_wire && (t1_addrA_0_wire == t1_addrA_wire) && (t1_dinA_0_wire == t1_dinA_wire))); 
  end
end
endgenerate
//synopsys translate_on
`endif
endmodule


module ip_top_sva_nror1w_dup
  #(
parameter WIDTH = 32,
parameter BITWDTH = 5,
parameter ENAPAR = 0,
parameter ENAECC = 0,
parameter NUMRDPT = 2,
parameter NUMADDR = 8192,
parameter BITADDR = 13,
parameter NUMVBNK = 8,
parameter BITVBNK = 3,
parameter NUMVROW = 8,
parameter BITVROW = 3,
parameter BITPADR = 13,
parameter SRAM_DELAY = 2,
parameter FLOPIN = 0,
parameter FLOPOUT = 0)
(
  input clk,
  input rst,
  input ready,
  input [NUMRDPT*NUMVBNK-1:0] t1_readA,
  input [NUMRDPT*NUMVBNK-1:0] t1_writeA,
  input [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_doutA,
  input [NUMRDPT*NUMVBNK-1:0] t1_fwrdA,
  input [NUMRDPT*NUMVBNK-1:0] t1_serrA,
  input [NUMRDPT*NUMVBNK-1:0] t1_derrA,
  input [NUMRDPT*NUMVBNK*(BITPADR-BITVBNK)-1:0] t1_padrA,
  input write,
  input [BITADDR-1:0]  wr_adr,
  input [WIDTH-1:0] din,
  input [NUMRDPT*BITADDR-1:0] rd_adr,
  input [NUMRDPT-1:0] read,
  input [NUMRDPT-1:0] rd_vld,
  input [NUMRDPT*WIDTH-1:0] rd_dout,
  input [NUMRDPT-1:0] rd_fwrd,
  input [NUMRDPT-1:0] rd_serr,
  input [NUMRDPT-1:0] rd_derr,
  input [NUMRDPT*BITPADR-1:0] rd_padr,
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

reg t1_fwrdA_sel [0:NUMRDPT-1];
reg t1_serrA_sel [0:NUMRDPT-1];
reg t1_derrA_sel [0:NUMRDPT-1];
reg [BITPADR-BITVBNK-1:0] t1_padrA_sel [0:NUMRDPT-1];
integer t1_padr_int;
always_comb
  for (t1_padr_int=0; t1_padr_int<NUMRDPT; t1_padr_int=t1_padr_int+1) begin
    t1_fwrdA_sel[t1_padr_int] = t1_fwrdA >> (NUMRDPT*select_bank+t1_padr_int);
    t1_serrA_sel[t1_padr_int] = t1_serrA >> (NUMRDPT*select_bank+t1_padr_int);
    t1_derrA_sel[t1_padr_int] = t1_derrA >> (NUMRDPT*select_bank+t1_padr_int);
    t1_padrA_sel[t1_padr_int] = t1_padrA >> ((NUMRDPT*select_bank+t1_padr_int)*(BITPADR-BITVBNK));
  end

reg t1_readA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
reg t1_writeA_wire [0:NUMVBNK-1];
reg [BITVROW-1:0] t1_addrA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
reg [WIDTH-1:0] t1_dinA_wire [0:NUMVBNK-1];
integer t1_prpt_int, t1_vbnk_int;
always_comb
  for (t1_vbnk_int=0; t1_vbnk_int<NUMVBNK; t1_vbnk_int=t1_vbnk_int+1) begin
    for (t1_prpt_int=0; t1_prpt_int<NUMRDPT; t1_prpt_int=t1_prpt_int+1) begin
      t1_readA_wire[t1_prpt_int][t1_vbnk_int] = t1_readA >> (NUMRDPT*t1_vbnk_int+t1_prpt_int);
      t1_addrA_wire[t1_prpt_int][t1_vbnk_int] = t1_addrA >> ((NUMRDPT*t1_vbnk_int+t1_prpt_int)*BITVROW);
    end
    t1_writeA_wire[t1_vbnk_int] = t1_writeA >> (NUMRDPT*t1_vbnk_int);
    t1_dinA_wire[t1_vbnk_int] = t1_dinA >> (NUMRDPT*t1_vbnk_int*WIDTH);
  end

reg read_wire [0:NUMRDPT-1];
reg [BITADDR-1:0] rd_adr_wire [0:NUMRDPT-1];
reg [BITVBNK-1:0] rd_bnk_wire [0:NUMRDPT-1];
reg [BITVBNK-1:0] rd_row_wire [0:NUMRDPT-1];
reg rd_vld_wire [0:NUMRDPT-1];
reg [WIDTH-1:0] rd_dout_wire [0:NUMRDPT-1];
reg rd_fwrd_wire [0:NUMRDPT-1];
reg rd_serr_wire [0:NUMRDPT-1];
reg rd_derr_wire [0:NUMRDPT-1];
reg [BITPADR-1:0] rd_padr_wire [0:NUMRDPT-1];
integer rd_int;
always_comb
  for (rd_int=0; rd_int<NUMRDPT; rd_int=rd_int+1) begin
    read_wire[rd_int] = read >> rd_int;
    rd_adr_wire[rd_int] = rd_adr >> (rd_int*BITADDR);
    rd_bnk_wire[rd_int] = rd_adr >> ((rd_int*BITADDR)+BITVROW);
    rd_row_wire[rd_int] = rd_adr >> (rd_int*BITADDR);
    rd_vld_wire[rd_int] = rd_vld >> rd_int;
    rd_dout_wire[rd_int] = rd_dout >> (rd_int*WIDTH);
    rd_fwrd_wire[rd_int] = rd_fwrd >> rd_int;
    rd_serr_wire[rd_int] = rd_serr >> rd_int;
    rd_derr_wire[rd_int] = rd_derr >> rd_int;
    rd_padr_wire[rd_int] = rd_padr >> (rd_int*BITPADR);
  end

reg meminv;
reg mem;
always @(posedge clk)
  if (rst)
    meminv <= 1'b1;
  else if (t1_writeA_wire[select_bank] && (t1_addrA_wire[0][select_bank] == select_vrow)) begin
    meminv <= 1'b0;
    mem <= t1_dinA_wire[select_bank][select_bit];
  end
      
genvar memr_int, memb_int;
generate for (memr_int=0; memr_int<NUMRDPT; memr_int=memr_int+1) begin: memr_loop
  assert_pdout_check: assert property (@(posedge clk) disable iff (rst)
				       (t1_readA_wire[memr_int][select_bank] && (t1_addrA_wire[memr_int][select_bank] == select_vrow)) |-> ##SRAM_DELAY
                                       ($past(meminv,SRAM_DELAY) || (!t1_fwrdA_sel[memr_int] && (ENAPAR ? t1_serrA_sel[memr_int] :
                                                                                                 ENAECC ? t1_derrA_sel[memr_int] : 1'b0)) ||
                                        (t1_doutA[(select_bank*NUMRDPT+memr_int)*WIDTH+select_bit] == $past(mem,SRAM_DELAY))));
end
endgenerate

reg fakememinv;
reg fakemem;
always @(posedge clk)
  if (rst) 
    fakememinv <= 1'b1;
  else if (write && (wr_adr == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din[select_bit];
  end

generate if (FLOPIN) begin: fake_flp_loop
  assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##1
                                         ($past(fakememinv) || ($past(fakemem) == mem)));
end else begin: fake_noflp_loop
  assert_fakemem_check: assert property (@(posedge clk) disable iff (rst)
                                         (fakememinv || (fakemem == mem)));
end
endgenerate

genvar doutr_int;
generate for (doutr_int=0; doutr_int<NUMRDPT; doutr_int=doutr_int+1) begin: doutr_loop
  assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_vld_wire[doutr_int] && ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) ||
                                                                  (!rd_fwrd_wire[doutr_int] && ((ENAPAR && rd_serr_wire[doutr_int]) || (ENAECC && rd_derr_wire[doutr_int]))) ||
                                                                  (rd_dout_wire[doutr_int][select_bit] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)))));
  assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_fwrd_wire[doutr_int] == (FLOPOUT ? $past(t1_fwrdA_sel[doutr_int]) : t1_fwrdA_sel[doutr_int])));
  assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_serr_wire[doutr_int] == (FLOPOUT ? $past(t1_serrA_sel[doutr_int]) : t1_serrA_sel[doutr_int])) &&
                                      (rd_derr_wire[doutr_int] == (FLOPOUT ? $past(t1_derrA_sel[doutr_int]) : t1_derrA_sel[doutr_int])));
  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_padr_wire[doutr_int] == {select_bank,(FLOPOUT ? $past(t1_padrA_sel[doutr_int]) : t1_padrA_sel[doutr_int])}));

end
endgenerate
//synopsys translate_on
`endif
endmodule


