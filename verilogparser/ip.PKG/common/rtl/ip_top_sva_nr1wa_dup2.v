module ip_top_sva_2_nr1wa_dup2
  #(
parameter     WIDTH = 8,
parameter     NUMRDPT = 4,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 256,
parameter     BITVROW = 8,
parameter     NUMCOLS = 1,
parameter     BITCOLS = 0,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3)
(
  input rd_clk,
  input rd_rst,
  input wr_clk,
  input wr_rst,
  input [NUMRDPT-1:0] read,
  input [NUMRDPT*BITADDR-1:0] rd_adr,
  input write,
  input [BITADDR-1:0]  wr_adr,
  input [NUMRDPT*NUMVBNK-1:0] t1_writeA,
  input [NUMRDPT*NUMVBNK*(BITVROW+BITCOLS)-1:0] t1_addrA,
  input [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_bwA,
  input [NUMRDPT*NUMVBNK-1:0] t1_readB,
  input [NUMRDPT*NUMVBNK*(BITVROW+BITCOLS)-1:0] t1_addrB
);
`ifdef FORMAL
//synopsys translate_off

assert_wr_range_check: assume property (@(posedge wr_clk) disable iff (wr_rst) write |-> (wr_adr < NUMADDR));
genvar rd_int;
generate for (rd_int=0; rd_int<NUMRDPT; rd_int=rd_int+1) begin: rd_loop
  wire read_wire = read >> rd_int;
  wire [BITADDR-1:0] rd_adr_wire = rd_adr >> (rd_int*BITADDR);

  assert_rd_range_check: assume property (@(posedge rd_clk) disable iff (rd_rst) read_wire |-> (rd_adr_wire < NUMADDR));
end
endgenerate

genvar t1_vbnk_int, t1_prpt_int;
generate for (t1_vbnk_int=0; t1_vbnk_int<NUMVBNK; t1_vbnk_int=t1_vbnk_int+1) begin: t1_vbnk_loop
  for (t1_prpt_int=0; t1_prpt_int<NUMRDPT; t1_prpt_int=t1_prpt_int+1) begin: t1_prpt_loop
    wire t1_writeA_wire = t1_writeA >> (NUMRDPT*t1_vbnk_int+t1_prpt_int);
    wire t1_bwA_wire = t1_bwA >> (NUMRDPT*t1_vbnk_int+t1_prpt_int);
    wire [(BITVROW+BITCOLS)-1:0] t1_addrA_wire = t1_addrA >> ((NUMRDPT*t1_vbnk_int+t1_prpt_int)*(BITVROW+BITCOLS));
    wire [BITVROW-1:0] t1_rowA_wire = t1_addrA_wire >> BITCOLS;
    wire [BITCOLS-1:0] t1_colA_wire = t1_addrA_wire;
    wire [WIDTH-1:0] t1_dinA_wire = t1_dinA >> ((NUMRDPT*t1_vbnk_int+t1_prpt_int)*WIDTH);

    wire t1_readB_wire = t1_readB >> (NUMRDPT*t1_vbnk_int+t1_prpt_int);
    wire [(BITVROW+BITCOLS)-1:0] t1_addrB_wire = t1_addrB >> ((NUMRDPT*t1_vbnk_int+t1_prpt_int)*(BITVROW+BITCOLS));
    wire [BITVROW-1:0] t1_rowB_wire = t1_addrB_wire >> BITCOLS;
    wire [BITCOLS-1:0] t1_colB_wire = t1_addrB_wire;

    assert_t1_wr_range_check: assert property (@(posedge wr_clk) disable iff (wr_rst) t1_writeA_wire |-> (t1_addrA_wire < NUMVROW*NUMCOLS));
//    assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> (t1_addrB_wire < NUMVROW*NUMCOLS));
//    assert_t1_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t1_writeA_wire && t1_readB_wire) |-> (t1_rowA_wire != t1_rowB_wire));
  end
end
endgenerate
//synopsys translate_on
`endif
endmodule


module ip_top_sva_nr1wa_dup2
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     ENAPAR = 0,
parameter     ENAECC = 0,
parameter     NUMRDPT = 2,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     NUMVROW = 256,
parameter     BITVROW = 8,
parameter     NUMCOLS = 1,
parameter     BITCOLS = 0,
parameter     SRAM_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0
   )
(
  input wr_clk,
  input wr_rst,
  input rd_clk,
  input rd_rst,
  input [NUMRDPT*NUMVBNK-1:0] t1_writeA,
  input [NUMRDPT*NUMVBNK*(BITVROW+BITCOLS)-1:0] t1_addrA,
  input [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_bwA,
  input [NUMRDPT*NUMVBNK-1:0] t1_readB,
  input [NUMRDPT*NUMVBNK*(BITVROW+BITCOLS)-1:0] t1_addrB,
  input [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_doutB,
  input write,
  input [BITADDR-1:0]  wr_adr,
  input [WIDTH-1:0] din,
  input [WIDTH-1:0] bw,
  input [NUMRDPT-1:0] read,
  input [NUMRDPT*BITADDR-1:0] rd_adr,
  input [NUMRDPT-1:0] rd_vld,
  input [NUMRDPT*WIDTH-1:0] rd_dout,
  input [BITADDR-1:0] select_addr,
  input [BITWDTH-1:0] select_bit
);

  localparam LBITVBK = BITVBNK>0 ? BITVBNK : 1;
`ifdef FORMAL
//synopsys translate_off

wire [LBITVBK-1:0] select_bank;
wire [(BITVROW+BITCOLS)-1:0] select_vrow;
np2_addr_ramwrap #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW*NUMCOLS), .BITVROW (BITVROW+BITCOLS))
  sel_adr (.vbadr(select_bank), .vradr(select_vrow), .vaddr(select_addr));

wire [BITVROW-1:0] select_row = select_vrow >> BITCOLS;
wire [BITCOLS-1:0] select_col = select_vrow;

reg t1_writeA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
reg [WIDTH-1:0] t1_bwA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
reg [(BITVROW+BITCOLS)-1:0] t1_addrA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
reg [WIDTH-1:0] t1_dinA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
reg t1_readB_wire [0:NUMRDPT-1][0:NUMVBNK-1];
reg [(BITVROW+BITCOLS)-1:0] t1_addrB_wire [0:NUMRDPT-1][0:NUMVBNK-1];
integer t1_prpt_int, t1_vbnk_int;
always_comb
  for (t1_vbnk_int=0; t1_vbnk_int<NUMVBNK; t1_vbnk_int=t1_vbnk_int+1) begin
    for (t1_prpt_int=0; t1_prpt_int<NUMRDPT; t1_prpt_int=t1_prpt_int+1) begin
      t1_writeA_wire[t1_prpt_int][t1_vbnk_int] = t1_writeA >> (NUMRDPT*t1_vbnk_int+t1_prpt_int);
      t1_bwA_wire[t1_prpt_int][t1_vbnk_int] = t1_bwA >> (NUMRDPT*t1_vbnk_int+t1_prpt_int);
      t1_addrA_wire[t1_prpt_int][t1_vbnk_int] = t1_addrA >> ((NUMRDPT*t1_vbnk_int+t1_prpt_int)*(BITVROW+BITCOLS));
      t1_dinA_wire[t1_prpt_int][t1_vbnk_int] = t1_dinA >> ((NUMRDPT*t1_vbnk_int+t1_prpt_int)*WIDTH);
      t1_readB_wire[t1_prpt_int][t1_vbnk_int] = t1_readB >> (NUMRDPT*t1_vbnk_int+t1_prpt_int);
      t1_addrB_wire[t1_prpt_int][t1_vbnk_int] = t1_addrB >> ((NUMRDPT*t1_vbnk_int+t1_prpt_int)*(BITVROW+BITCOLS));
    end
  end

reg read_wire [0:NUMRDPT-1];
reg [BITADDR-1:0] rd_adr_wire [0:NUMRDPT-1];
reg rd_vld_wire [0:NUMRDPT-1];
reg [WIDTH-1:0] rd_dout_wire [0:NUMRDPT-1];
integer rd_int;
always_comb
  for (rd_int=0; rd_int<NUMRDPT; rd_int=rd_int+1) begin
    read_wire[rd_int] = read >> rd_int;
    rd_adr_wire[rd_int] = rd_adr >> (rd_int*BITADDR);
    rd_vld_wire[rd_int] = rd_vld >> rd_int;
    rd_dout_wire[rd_int] = rd_dout >> (rd_int*WIDTH);
  end

reg meminv [0:NUMRDPT-1];
reg mem [0:NUMRDPT-1];
integer mem_int;
always @(posedge wr_clk)
  for (mem_int=0; mem_int<NUMRDPT; mem_int=mem_int+1)
    if (wr_rst)
      meminv[mem_int] <= 1'b1;
    else if (t1_writeA_wire[mem_int][select_bank] && t1_bwA_wire[mem_int][select_bank][select_bit] && (t1_addrA_wire[mem_int][select_bank] == select_vrow)) begin
      meminv[mem_int] <= 1'b0;
      mem[mem_int] <= t1_dinA_wire[mem_int][select_bank][select_bit];
    end
      
genvar memr_int;
generate for (memr_int=0; memr_int<NUMRDPT; memr_int=memr_int+1) begin: memr_loop
  if(SRAM_DELAY > 0) begin : dl_l
  assert_pdout_check: assert property (@(posedge rd_clk) disable iff (rd_rst)
				       (t1_readB_wire[memr_int][select_bank] && (t1_addrB_wire[memr_int][select_bank] == select_vrow)) |-> ##SRAM_DELAY
                                       ($past(meminv[memr_int],SRAM_DELAY) || (t1_doutB[(select_bank*NUMRDPT+memr_int)*WIDTH+select_bit] == $past(mem[memr_int],SRAM_DELAY))));
  end else begin : nd_l
  assert_pdout_check: assert property (@(posedge rd_clk) disable iff (rd_rst)
				       (t1_readB_wire[memr_int][select_bank] && (t1_addrB_wire[memr_int][select_bank] == select_vrow)) |-> ##SRAM_DELAY
                                       (meminv[memr_int] || (t1_doutB[(select_bank*NUMRDPT+memr_int)*WIDTH+select_bit] == mem[memr_int])));
  end
end
endgenerate

reg fakememinv;
reg fakemem;
always @(posedge wr_clk)
  if (wr_rst) 
    fakememinv <= 1'b1;
  else if (write && bw[select_bit] && (wr_adr == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din[select_bit];
  end

genvar fake_int;
generate  for (fake_int=0; fake_int<NUMRDPT; fake_int=fake_int+1) begin: fake_loop
    assert_fakemem_check: assert property (@(posedge wr_clk) disable iff (wr_rst) 1'b1 |-> ##1
					   (fakememinv || fakemem == mem[fake_int]));
end
endgenerate

genvar doutr_int;
generate for (doutr_int=0; doutr_int<NUMRDPT; doutr_int=doutr_int+1) begin: doutr_loop
  wire read_wire = read >> doutr_int;
  wire [BITADDR-1:0] rd_adr_wire = rd_adr >> (doutr_int*BITADDR);
  wire rd_vld_wire = rd_vld >> doutr_int;
  wire [WIDTH-1:0] rd_dout_wire = rd_dout >> (doutr_int*WIDTH);

  if(FLOPIN+SRAM_DELAY+FLOPOUT>0) begin :dl_loop
  assert_dout_check: assert property (@(posedge rd_clk) disable iff (rd_rst) (read_wire && (rd_adr_wire == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_vld_wire && ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) ||
                                                       (rd_dout_wire[select_bit] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)))));
  end else begin : ndl_loop
  assert_dout_check: assert property (@(posedge rd_clk) disable iff (rd_rst) (read_wire && (rd_adr_wire == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_vld_wire && (fakememinv ||
                                                       (rd_dout_wire[select_bit] == fakemem))));
  end
end
endgenerate
//synopsys translate_on
`endif
endmodule


