module ip_top_sva_2_mrnwt_base
  #(
parameter WIDTH = 8,
parameter NUMRDPT = 2,
parameter NUMWRPT = 3,
parameter NUMADDR = 8192,
parameter BITADDR = 13,
parameter NUMWTPT = 3)
(
  input clk,
  input rst,
  input ready,
  input [NUMRDPT-1:0] read,
  input [NUMRDPT*BITADDR-1:0] rd_adr,
  input [NUMWRPT-1:0] write,
  input [NUMWRPT*BITADDR-1:0]  wr_adr,
  input [NUMWTPT-1:0] t1_writeA,
  input [NUMWTPT*BITADDR-1:0] t1_addrA,
  input [NUMWTPT*WIDTH-1:0] t1_dinA,
  input [NUMRDPT-1:0] t1_readB,
  input [NUMRDPT*BITADDR-1:0] t1_addrB
);

genvar rd_int;
generate for (rd_int=0; rd_int<NUMRDPT; rd_int=rd_int+1) begin: rd_loop
  wire read_wire = read >> rd_int;
  wire [BITADDR-1:0] rd_adr_wire = rd_adr >> (rd_int*BITADDR);

  assert_rd_range_check: assume property (@(posedge clk) disable iff (!ready) read_wire |-> (rd_adr_wire < NUMADDR));
end
endgenerate

genvar wr_int;
generate for (wr_int=0; wr_int<NUMRDPT; wr_int=wr_int+1) begin: wr_loop
  wire write_wire = write >> wr_int;
  wire [BITADDR-1:0] wr_adr_wire = wr_adr >> (wr_int*BITADDR);

  assert_wr_range_check: assume property (@(posedge clk) disable iff (!ready) write_wire |-> (wr_adr_wire < NUMADDR));
end
endgenerate

genvar t1w_var;
generate for (t1w_var=0; t1w_var<NUMWTPT; t1w_var=t1w_var+1) begin: t1w_loop
  wire t1_writeA_wire = t1_writeA >> t1w_var;
  wire [BITADDR-1:0] t1_addrA_wire = t1_addrA >> (t1w_var*BITADDR);
  wire [WIDTH-1:0] t1_dinA_wire = t1_dinA >> (t1w_var*WIDTH);

  assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMADDR));
end
endgenerate

genvar t1r_var;
generate for (t1r_var=0; t1r_var<NUMRDPT; t1r_var=t1r_var+1) begin: t1r_loop
  wire t1_readB_wire = t1_readB >> t1r_var;
  wire [BITADDR-1:0] t1_addrB_wire = t1_addrB >> (t1r_var*BITADDR);

  assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> (t1_addrB_wire < NUMADDR));
end
endgenerate

endmodule


module ip_top_sva_mrnwt_base
  #(
parameter WIDTH = 32,
parameter BITWDTH = 5,
parameter ENAPAR = 0,
parameter ENAECC = 0,
parameter NUMRDPT = 2,
parameter NUMWRPT = 3,
parameter NUMADDR = 8192,
parameter BITADDR = 13,
parameter NUMWTPT = 3,
parameter BITPADR = 13,
parameter SRAM_DELAY = 2,
parameter FLOPIN = 0,
parameter FLOPOUT = 0,
parameter FIFOCNT = NUMWRPT)
(
  input clk,
  input rst,
  input ready,
  input [NUMWRPT-1:0] write,
  input [NUMWRPT*BITADDR-1:0]  wr_adr,
  input [NUMWRPT*WIDTH-1:0] din,
  input [NUMRDPT-1:0] read,
  input [NUMRDPT*BITADDR-1:0] rd_adr,
  input [NUMRDPT-1:0] rd_vld,
  input [NUMRDPT*WIDTH-1:0] rd_dout,
  input [NUMRDPT-1:0] rd_fwrd,
  input [NUMRDPT-1:0] rd_serr,
  input [NUMRDPT-1:0] rd_derr,
  input [NUMRDPT*BITPADR-1:0] rd_padr,
  input [NUMWTPT-1:0] t1_writeA,
  input [NUMWTPT*BITADDR-1:0] t1_addrA,
  input [NUMWTPT*WIDTH-1:0] t1_dinA,
  input [NUMRDPT-1:0] t1_readB,
  input [NUMRDPT*BITADDR-1:0] t1_addrB,
  input [NUMRDPT*WIDTH-1:0] t1_doutB,
  input [NUMRDPT-1:0] t1_fwrdB,
  input [NUMRDPT-1:0] t1_serrB,
  input [NUMRDPT-1:0] t1_derrB,
  input [NUMRDPT*BITPADR-1:0] t1_padrB,
  input [BITADDR-1:0] select_addr,
  input [BITWDTH-1:0] select_bit
);
/*
reg [WIDTH-1:0] t1_doutB_sel;
reg t1_fwrdB_sel;
reg t1_serrB_sel;
reg t1_derrB_sel;
reg [BITPADR-BITVBNK-1:0] t1_padrB_sel;
integer t1_sel_int;
always_comb begin
  t1_doutB_sel = t1_doutB >> (select_bank*WIDTH); 
  t1_fwrdB_sel = t1_fwrdB >> select_bank;
  t1_serrB_sel = t1_serrB >> select_bank;
  t1_derrB_sel = t1_derrB >> select_bank;
  t1_padrB_sel = t1_padrB >> (select_bank*(BITPADR-BITVBNK));
end

reg t1_writeA_wire [0:NUMVBNK-1];
reg [BITVROW-1:0] t1_addrA_wire [0:NUMVBNK-1];
reg [WIDTH-1:0] t1_dinA_wire [0:NUMVBNK-1];
reg t1_readB_wire [0:NUMVBNK-1];
reg [BITVROW-1:0] t1_addrB_wire [0:NUMVBNK-1];
integer t1_int;
always_comb
  for (t1_int=0; t1_int<NUMVBNK; t1_int=t1_int+1) begin
    t1_writeA_wire[t1_int] = t1_writeA >> t1_int;
    t1_addrA_wire[t1_int] = t1_addrA >> (t1_int*BITVROW);
    t1_dinA_wire[t1_int] = t1_dinA >> (t1_int*WIDTH);
    t1_readB_wire[t1_int] = t1_readB >> t1_int;
    t1_addrB_wire[t1_int] = t1_addrB >> (t1_int*BITVROW);
  end

reg read_wire [0:NUMRDPT-1];
reg [BITADDR-1:0] rd_adr_wire [0:NUMRDPT-1];
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
    rd_vld_wire[rd_int] = rd_vld >> rd_int;
    rd_dout_wire[rd_int] = rd_dout >> (rd_int*WIDTH);
    rd_fwrd_wire[rd_int] = rd_fwrd >> rd_int;
    rd_serr_wire[rd_int] = rd_serr >> rd_int;
    rd_derr_wire[rd_int] = rd_derr >> rd_int;
    rd_padr_wire[rd_int] = rd_padr >> (rd_int*BITPADR);
  end

reg write_wire [0:NUMWRPT-1];
reg [BITADDR-1:0] wr_adr_wire [0:NUMWRPT-1];
reg [WIDTH-1:0] din_wire [0:NUMWRPT-1];
integer wr_int;
always_comb
  for (wr_int=0; wr_int<NUMWRPT; wr_int=wr_int+1) begin
    write_wire[wr_int] = write >> wr_int;
    wr_adr_wire[wr_int] = wr_adr >> (wr_int*BITADDR);
    din_wire[wr_int] = din >> (wr_int*WIDTH);
  end

reg meminv;
reg mem;
always @(posedge clk)
  if (rst)
    meminv <= 1'b1;
  else if (t1_writeA_wire[select_bank] && (t1_addrA_wire[select_bank] == select_vrow)) begin
    meminv <= 1'b0;
    mem <= t1_dinA_wire[select_bank][select_bit];
  end
      
assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire[select_bank] && (t1_addrB_wire[select_bank] == select_vrow)) |-> ##SRAM_DELAY
                                     ($past(meminv,SRAM_DELAY) || (!t1_fwrdB_sel && (ENAPAR ? t1_serrB_sel : ENAECC ? t1_derrB_sel : 1'b0)) ||
                                      (t1_doutB_sel[select_bit] == $past(mem,SRAM_DELAY))));

reg fakememinv;
reg fakemem;
integer fake_int;
always @(posedge clk)
  if (rst) 
    fakememinv <= 1'b1;
  else for (fake_int=0; fake_int<NUMWRPT; fake_int=fake_int+1)
    if (write_wire[fake_int] && (wr_adr_wire[fake_int] == select_addr)) begin
      fakememinv <= 1'b0;
      fakemem <= din_wire[fake_int][select_bit];
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
                                                                  (!rd_fwrd_wire[doutr_int] && ((ENAPAR && rd_serr_wire[doutr_int]) || rd_derr_wire[doutr_int])) ||
                                                                  (rd_dout_wire[doutr_int][select_bit] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)))));
  assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_fwrd_wire[doutr_int] == (FLOPOUT ? $past(t1_fwrdB_sel) : t1_fwrdB_sel)));
  assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_serr_wire[doutr_int] == (FLOPOUT ? $past(t1_serrB_sel) : t1_serrB_sel)) &&
                                      (rd_derr_wire[doutr_int] == (FLOPOUT ? $past(t1_derrB_sel) : t1_derrB_sel)));
  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_padr_wire[doutr_int] == {select_bank,(FLOPOUT ? $past(t1_padrB_sel) : t1_padrB_sel)}));

end
endgenerate
*/
endmodule


