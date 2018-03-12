module ip_top_sva_2_2nr2w_dup
  #(
parameter     WIDTH = 8,
parameter     NUMRDPT = 4,
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
  input [2*NUMRDPT-1:0] read,
  input [2*NUMRDPT*BITADDR-1:0] rd_adr,
  input [2-1:0] write,
  input [2*BITADDR-1:0]  wr_adr,
  input [2*NUMRDPT*NUMVBNK-1:0] t1_writeA,
  input [2*NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [2*NUMRDPT*NUMVBNK*WIDTH-1:0] t1_dinA,
  input [2*NUMRDPT*NUMVBNK-1:0] t1_readB,
  input [2*NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB,
  input [2*NUMRDPT*NUMVBNK*WIDTH-1:0] t1_doutB
);
`ifdef FORMAL
//synopsys translate_off

genvar rd_int;
generate for (rd_int=0; rd_int<2*NUMRDPT; rd_int=rd_int+1) begin: rd_loop
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

genvar t1_vbnk_int, t1_prpt_int;
generate for (t1_vbnk_int=0; t1_vbnk_int<NUMVBNK; t1_vbnk_int=t1_vbnk_int+1) begin: t1_vbnk_loop
  for (t1_prpt_int=0; t1_prpt_int<2*NUMRDPT; t1_prpt_int=t1_prpt_int+1) begin: t1_prpt_loop
    wire t1_writeA_wire = t1_writeA >> (2*NUMRDPT*t1_vbnk_int+t1_prpt_int);
    wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> ((2*NUMRDPT*t1_vbnk_int+t1_prpt_int)*BITVROW);
    wire [WIDTH-1:0] t1_dinA_wire = t1_dinA >> ((2*NUMRDPT*t1_vbnk_int+t1_prpt_int)*WIDTH);

    wire t1_writeA_0_wire = t1_writeA >> (2*NUMRDPT*t1_vbnk_int+t1_prpt_int[0]);
    wire [BITVROW-1:0] t1_addrA_0_wire = t1_addrA >> ((2*NUMRDPT*t1_vbnk_int+t1_prpt_int[0])*BITVROW);
    wire [WIDTH-1:0] t1_dinA_0_wire = t1_dinA >> ((2*NUMRDPT*t1_vbnk_int+t1_prpt_int[0])*WIDTH);

    wire t1_readB_wire = t1_readB >> (2*NUMRDPT*t1_vbnk_int+t1_prpt_int);
    wire [BITVROW-1:0] t1_addrB_wire = t1_addrB >> ((2*NUMRDPT*t1_vbnk_int+t1_prpt_int)*BITVROW);

    assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMVROW));
    assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> (t1_addrB_wire < NUMVROW));
    assert_t1_wr_same_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |->
					      (t1_writeA_0_wire && (t1_addrA_0_wire == t1_addrA_wire) && (t1_dinA_0_wire == t1_dinA_wire))); 
  end
end
endgenerate
//synopsys translate_on
`endif
endmodule


module ip_top_sva_2nr2w_dup
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     NUMRDPT = 2,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 8,
parameter     BITVROW = 3,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     BITPADR = 0,
parameter     SRAM_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0
   )
(
  input clk,
  input rst,
  input ready,
  input [2*NUMRDPT*NUMVBNK-1:0] t1_writeA,
  input [2*NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [2*NUMRDPT*NUMVBNK*WIDTH-1:0] t1_dinA,
  input [2*NUMRDPT*NUMVBNK-1:0] t1_readB,
  input [2*NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB,
  input [2*NUMRDPT*NUMVBNK*WIDTH-1:0] t1_doutB,
  input [2*NUMRDPT*NUMVBNK-1:0] t1_serrB,
  input [2*NUMRDPT*NUMVBNK-1:0] t1_derrB,
  input [2*NUMRDPT*NUMVBNK*(BITPADR-BITVBNK-1)-1:0] t1_padrB,
  input [2-1:0] write,
  input [2*BITADDR-1:0]  wr_adr,
  input [2*WIDTH-1:0] din,
  input [2*NUMRDPT-1:0] read,
  input [2*NUMRDPT*BITADDR-1:0] rd_adr,
  input [2*NUMRDPT-1:0] rd_vld,
  input [2*NUMRDPT*WIDTH-1:0] rd_dout,
  input [2*NUMRDPT-1:0] rd_serr,
  input [2*NUMRDPT-1:0] rd_derr,
  input [2*NUMRDPT*BITPADR-1:0] rd_padr,
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

reg t1_writeA_wire [0:2*NUMRDPT-1][0:NUMVBNK-1];
reg [BITVROW-1:0] t1_addrA_wire [0:2*NUMRDPT-1][0:NUMVBNK-1];
reg [WIDTH-1:0] t1_dinA_wire [0:2*NUMRDPT-1][0:NUMVBNK-1];
reg t1_readB_wire [0:2*NUMRDPT-1][0:NUMVBNK-1];
reg [BITVROW-1:0] t1_addrB_wire [0:2*NUMRDPT-1][0:NUMVBNK-1];
integer t1_prpt_int, t1_vbnk_int;
always_comb
  for (t1_vbnk_int=0; t1_vbnk_int<NUMVBNK; t1_vbnk_int=t1_vbnk_int+1) begin
    for (t1_prpt_int=0; t1_prpt_int<2*NUMRDPT; t1_prpt_int=t1_prpt_int+1) begin
      t1_writeA_wire[t1_prpt_int][t1_vbnk_int] = t1_writeA >> (2*NUMRDPT*t1_vbnk_int+t1_prpt_int);
      t1_addrA_wire[t1_prpt_int][t1_vbnk_int] = t1_addrA >> ((2*NUMRDPT*t1_vbnk_int+t1_prpt_int)*BITVROW);
      t1_dinA_wire[t1_prpt_int][t1_vbnk_int] = t1_dinA >> ((2*NUMRDPT*t1_vbnk_int+t1_prpt_int)*WIDTH);
    end
    for (t1_prpt_int=0; t1_prpt_int<2*NUMRDPT; t1_prpt_int=t1_prpt_int+1) begin
      t1_readB_wire[t1_prpt_int][t1_vbnk_int] = t1_readB >> (2*NUMRDPT*t1_vbnk_int+t1_prpt_int);
      t1_addrB_wire[t1_prpt_int][t1_vbnk_int] = t1_addrB >> ((2*NUMRDPT*t1_vbnk_int+t1_prpt_int)*BITVROW);
    end
  end

reg write_wire [0:2-1];
reg [BITADDR-1:0] wr_adr_wire [0:2-1];
reg [WIDTH-1:0] din_wire [0:2-1];
integer wr_int;
always_comb
  for (wr_int=0; wr_int<2; wr_int=wr_int+1) begin
    write_wire[wr_int] = write >> wr_int;
    wr_adr_wire[wr_int] = wr_adr >> (wr_int*BITADDR);
    din_wire[wr_int] = din >> (wr_int*WIDTH);
  end

reg read_wire [0:2*NUMRDPT-1];
reg [BITADDR-1:0] rd_adr_wire [0:2*NUMRDPT-1];
reg rd_vld_wire [0:2*NUMRDPT-1];
reg [WIDTH-1:0] rd_dout_wire [0:2*NUMRDPT-1];
reg rd_serr_wire [0:2*NUMRDPT-1];
reg rd_derr_wire [0:2*NUMRDPT-1];
reg [BITPADR-1:0] rd_padr_wire [0:2*NUMRDPT-1];
integer rd_int;
always_comb
  for (rd_int=0; rd_int<2*NUMRDPT; rd_int=rd_int+1) begin
    read_wire[rd_int] = read >> rd_int;
    rd_adr_wire[rd_int] = rd_adr >> (rd_int*BITADDR);
    rd_vld_wire[rd_int] = rd_vld >> rd_int;
    rd_dout_wire[rd_int] = rd_dout >> (rd_int*WIDTH);
    rd_serr_wire[rd_int] = rd_serr >> rd_int;
    rd_derr_wire[rd_int] = rd_derr >> rd_int;
    rd_padr_wire[rd_int] = rd_padr >> (rd_int*BITPADR);
  end

reg [BITPADR-BITVBNK-2:0] t1_padrB_sel [0:2*NUMRDPT-1];
integer t1_padr_int;
always_comb
  for (t1_padr_int=0; t1_padr_int<2*NUMRDPT; t1_padr_int=t1_padr_int+1)
    t1_padrB_sel[t1_padr_int] = t1_padrB >> ((2*NUMRDPT*select_bank+t1_padr_int)*(BITPADR-BITVBNK-1));

reg meminv [0:NUMRDPT-1];
reg mem [0:NUMRDPT-1];
integer mem_int;
always @(posedge clk)
  for (mem_int=0; mem_int<NUMRDPT; mem_int=mem_int+1)
    if (rst)
      meminv[mem_int] <= 1'b1;
    else if (t1_writeA_wire[2*mem_int+1][select_bank] && (t1_addrA_wire[2*mem_int+1][select_bank] == select_vrow)) begin
      meminv[mem_int] <= 1'b0;
      mem[mem_int] <= t1_dinA_wire[2*mem_int+1][select_bank][select_bit];
    end else if (t1_writeA_wire[2*mem_int+0][select_bank] && (t1_addrA_wire[2*mem_int+0][select_bank] == select_vrow)) begin
      meminv[mem_int] <= 1'b0;
      mem[mem_int] <= t1_dinA_wire[2*mem_int+0][select_bank][select_bit];
    end 
      
genvar memr_int;
generate for (memr_int=0; memr_int<2*NUMRDPT; memr_int=memr_int+1) begin: memr_loop
  assert_pdout_check: assert property (@(posedge clk) disable iff (rst)
                                       (t1_readB_wire[memr_int][select_bank] && (t1_addrB_wire[memr_int][select_bank] == select_vrow)) |-> ##SRAM_DELAY
                                       ($past(meminv[memr_int>>1],SRAM_DELAY) || (t1_doutB[(select_bank*2*NUMRDPT+memr_int)*WIDTH+select_bit] == $past(mem[memr_int>>1],SRAM_DELAY))));
end
endgenerate

reg fakememinv;
reg fakemem;
always @(posedge clk)
  if (rst) 
    fakememinv <= 1'b1;
  else if (write_wire[1] && (wr_adr_wire[1] == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din_wire[1][select_bit];
  end else if (write_wire[0] && (wr_adr_wire[0] == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din_wire[0][select_bit];
  end

genvar fake_int;
generate if (FLOPIN) begin: fake_flp_loop
  for (fake_int=0; fake_int<NUMRDPT; fake_int=fake_int+1) begin: fake_loop
    assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##1 ($past(fakememinv) || ($past(fakemem) == mem[fake_int])));
  end
end else begin: fake_noflp_loop
  for (fake_int=0; fake_int<NUMRDPT; fake_int=fake_int+1) begin: fake_loop
    assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) (fakememinv || (fakemem == mem[fake_int])));
  end
end
endgenerate

genvar doutr_int;
generate for (doutr_int=0; doutr_int<2*NUMRDPT; doutr_int=doutr_int+1) begin: doutr_loop
  assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_vld_wire[doutr_int] && ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) ||
                                                                  (rd_dout_wire[doutr_int][select_bit] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)))));
  assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (!rd_serr_wire[doutr_int] && !rd_derr_wire[doutr_int]));
  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (&rd_padr_wire[doutr_int] ||
                                       (rd_padr_wire[doutr_int] == {select_bank,(FLOPOUT ? $past(t1_padrB_sel[doutr_int]) : t1_padrB_sel[doutr_int])})));
end
endgenerate
//synopsys translate_on
`endif
endmodule


