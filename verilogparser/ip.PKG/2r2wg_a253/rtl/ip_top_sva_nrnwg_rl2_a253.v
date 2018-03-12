module ip_top_sva_2_nrnwg_rl2_a253
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     ENAPSDO = 0,
parameter     NUMWRPT = 2,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     SRAM_DELAY = 2,
parameter     ECCBITS = 4,
parameter     SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS
   )
(
  input clk,
  input rst,
  input ready,
  input [NUMWRPT-1:0] read,
  input [NUMWRPT*BITADDR-1:0] rd_adr,
  input [NUMWRPT-1:0] write,
  input [NUMWRPT*BITADDR-1:0] wr_adr,
  input [NUMVBNK-1:0] t1_writeA,
  input [NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMVBNK-1:0] t1_readB,
  input [NUMVBNK*BITVROW-1:0] t1_addrB,
  input [2*NUMWRPT-1:0] t2_writeA,
  input [2*NUMWRPT*BITVROW-1:0] t2_addrA,
  input [2*NUMWRPT*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA,
  input [2*NUMWRPT-1:0] t2_readB,
  input [2*NUMWRPT*BITVROW-1:0] t2_addrB
);

reg read_wire [0:NUMWRPT-1];
reg [BITADDR-1:0] rd_adr_wire [0:NUMWRPT-1];
reg [BITVBNK-1:0] rd_badr_wire [0:NUMWRPT-1];
genvar rd_var;
generate for (rd_var=0; rd_var<NUMWRPT; rd_var=rd_var+1) begin: rd_loop
  assign read_wire[rd_var] = read >> rd_var;
  assign rd_adr_wire[rd_var] = rd_adr >> (rd_var*BITADDR);
  np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
             .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
             .NUMVROW (NUMVROW), .BITVROW (BITVROW))
    rd_adr_inst (.vbadr(rd_badr_wire[rd_var]), .vradr(), .vaddr(rd_adr_wire[rd_var]));

  assert_rd_range_check: assert property (@(posedge clk) disable iff (rst) read_wire[rd_var] |-> (rd_adr_wire[rd_var] < NUMADDR));
end
endgenerate

reg write_wire [0:NUMWRPT-1];
reg [BITADDR-1:0] wr_adr_wire [0:NUMWRPT-1];
reg [BITVBNK-1:0] wr_badr_wire [0:NUMWRPT-1];
genvar wr_var;
generate for (wr_var=0; wr_var<NUMWRPT; wr_var=wr_var+1) begin: wr_loop
  assign write_wire[wr_var] = write >> wr_var;
  assign wr_adr_wire[wr_var] = wr_adr >> (wr_var*BITADDR);
  np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
             .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
             .NUMVROW (NUMVROW), .BITVROW (BITVROW))
    wr_adr_inst (.vbadr(wr_badr_wire[wr_var]), .vradr(), .vaddr(wr_adr_wire[wr_var]));

  assert_wr_range_check: assert property (@(posedge clk) disable iff (rst) write_wire[wr_var] |-> (wr_adr_wire[wr_var] < NUMADDR));
end
endgenerate

reg [NUMWRPT-1:0] wrmsk [0:NUMVBNK-1]; 
integer wrm_int;
always @(posedge clk)
  if (!ready)
    for (wrm_int=0; wrm_int<NUMVBNK; wrm_int=wrm_int+1)
      wrmsk[wrm_int] <= 0;
  else for (wrm_int=0; wrm_int<NUMWRPT; wrm_int=wrm_int+1)
    if (write_wire[wrm_int])
      wrmsk[wr_badr_wire[wrm_int]] <= 1'b1 << wrm_int;

reg same_rd_bank;
reg wrong_rd_bank;
reg same_wr_bank;
reg wrong_wr_bank;
integer swx_int, swy_int;
always_comb begin
  same_rd_bank = 1'b0;
  wrong_rd_bank = 1'b0;
  same_wr_bank = 1'b0;
  wrong_wr_bank = 1'b0;
  for (swx_int=0; swx_int<NUMWRPT; swx_int=swx_int+1) begin
    if (write_wire[swx_int] && |wrmsk[wr_badr_wire[swx_int]] && !wrmsk[wr_badr_wire[swx_int]][swx_int])
      wrong_wr_bank = 1'b1;
    if (read_wire[swx_int] && |wrmsk[rd_badr_wire[swx_int]] && !wrmsk[rd_badr_wire[swx_int]][swx_int])
      wrong_rd_bank = 1'b1;
    for (swy_int=0; swy_int<NUMWRPT; swy_int=swy_int+1) begin
      if ((swx_int!=swy_int) && write_wire[swx_int] && write_wire[swy_int] && (wr_badr_wire[swx_int] == wr_badr_wire[swy_int]))
        same_wr_bank = 1'b1;
      if ((swx_int!=swy_int) && read_wire[swx_int] && read_wire[swy_int] && (rd_badr_wire[swx_int] == rd_badr_wire[swy_int]))
        same_rd_bank = 1'b1;
    end
  end
end

assert_rd_alloc_check: assert property (@(posedge clk) disable iff (rst) !(same_rd_bank || wrong_rd_bank));
assert_wr_alloc_check: assert property (@(posedge clk) disable iff (rst) !(same_wr_bank || wrong_wr_bank));
 
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

genvar t2w_int, t2b_int;
generate for (t2w_int=0; t2w_int<NUMWRPT; t2w_int=t2w_int+1) begin: t2w_loop
  for (t2b_int=0; t2b_int<2; t2b_int=t2b_int+1) begin: t2b_loop
    wire t2_writeA_wire = t2_writeA >> (2*t2w_int+t2b_int);
    wire [BITVROW-1:0] t2_addrA_wire = t2_addrA >> ((2*t2w_int+t2b_int)*BITVROW);
    wire [SDOUT_WIDTH+WIDTH-1:0] t2_dinA_wire = t2_dinA >> ((2*t2w_int+t2b_int)*(SDOUT_WIDTH+WIDTH));

    wire t2_writeA_0_wire = t2_writeA >> 2*t2w_int;
    wire [BITVROW-1:0] t2_addrA_0_wire = t2_addrA >> (2*t2w_int*BITVROW);
    wire [SDOUT_WIDTH+WIDTH-1:0] t2_dinA_0_wire = t2_dinA >> (2*t2w_int*(SDOUT_WIDTH+WIDTH));

    wire t2_readB_wire = t2_readB >> 2*t2w_int;
    wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> ((2*t2w_int)*BITVROW);

    assert_t2_wr_same_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |->
                                              (t2_writeA_0_wire && (t2_addrA_0_wire == t2_addrA_wire) && (t2_dinA_0_wire == t2_dinA_wire)));
    assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_addrA_wire < NUMVROW));
    assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire |-> (t2_addrB_wire < NUMVROW));
    assert_t2_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (ENAPSDO && t2_writeA_wire && t2_readB_wire) |-> (t2_addrA_wire != t2_addrB_wire));
  end
end
endgenerate

endmodule


module ip_top_sva_nrnwg_rl2_a253
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     NUMWRPT = 2,
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
parameter     ECCBITS = 4,
parameter     SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS
   )
(
  input clk,
  input rst,
  input [NUMVBNK-1:0] t1_writeA,
  input [NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMVBNK-1:0] t1_readB,
  input [NUMVBNK*BITVROW-1:0] t1_addrB,
  input [NUMVBNK*WIDTH-1:0] t1_doutB,
  input [NUMVBNK-1:0] t1_fwrdB,
  input [NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrB,
  input [2*NUMWRPT-1:0] t2_writeA,
  input [2*NUMWRPT*BITVROW-1:0] t2_addrA,
  input [2*NUMWRPT*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA,
  input [2*NUMWRPT-1:0] t2_readB,
  input [2*NUMWRPT*BITVROW-1:0] t2_addrB,
  input [2*NUMWRPT-1:0] t2_fwrdB,
  input [2*NUMWRPT*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB,
  input [2*NUMWRPT*(BITPADR-BITPBNK)-1:0] t2_padrB,
  input [NUMWRPT-1:0] write,
  input [NUMWRPT*BITADDR-1:0]  wr_adr,
  input [NUMWRPT*WIDTH-1:0] din,
  input [NUMWRPT-1:0] read,
  input [NUMWRPT*BITADDR-1:0] rd_adr,
  input [NUMWRPT-1:0] rd_vld,
  input [NUMWRPT*WIDTH-1:0] rd_dout,
  input [NUMWRPT-1:0] rd_fwrd,
  input [NUMWRPT-1:0] rd_serr,
  input [NUMWRPT-1:0] rd_derr,
  input [NUMWRPT*BITPADR-1:0] rd_padr,
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

reg write_wire [0:NUMWRPT-1];
reg [BITADDR-1:0] wr_adr_wire [0:NUMWRPT-1];
reg [WIDTH-1:0] din_wire [0:NUMWRPT-1];
reg read_wire [0:NUMWRPT-1];
reg [BITADDR-1:0] rd_adr_wire [0:NUMWRPT-1];
reg rd_vld_wire [0:NUMWRPT-1];
reg [WIDTH-1:0] rd_dout_wire [0:NUMWRPT-1];
reg rd_fwrd_wire [0:NUMWRPT-1];
reg rd_serr_wire [0:NUMWRPT-1];
reg rd_derr_wire [0:NUMWRPT-1];
reg [BITPADR-1:0] rd_padr_wire [0:NUMWRPT-1];
integer wr_int;
always_comb 
  for (wr_int=0; wr_int<NUMWRPT; wr_int=wr_int+1) begin
    write_wire[wr_int] = write >> wr_int;
    wr_adr_wire[wr_int] = wr_adr >> (wr_int*BITADDR);
    din_wire[wr_int] = din >> (wr_int*WIDTH);
    read_wire[wr_int] = read >> wr_int;
    rd_adr_wire[wr_int] = rd_adr >> (wr_int*BITADDR);
    rd_vld_wire[wr_int] = rd_vld >> wr_int;
    rd_dout_wire[wr_int] = rd_dout >> (wr_int*WIDTH);
    rd_fwrd_wire[wr_int] = rd_fwrd >> wr_int;
    rd_serr_wire[wr_int] = rd_serr >> wr_int;
    rd_derr_wire[wr_int] = rd_derr >> wr_int;
    rd_padr_wire[wr_int] = rd_padr >> (wr_int*BITPADR);
  end

wire t1_writeA_sel_wire = t1_writeA >> select_bank;
wire [BITVROW-1:0] t1_addrA_sel_wire = t1_addrA >> (select_bank*BITVROW);
wire [WIDTH-1:0] t1_dinA_sel_wire = t1_dinA >> (select_bank*WIDTH);
wire t1_readB_sel_wire = t1_readB >> select_bank;
wire [BITVROW-1:0] t1_addrB_sel_wire = t1_addrB >> (select_bank*BITVROW);
wire [WIDTH-1:0] t1_doutB_sel_wire = t1_doutB >> (select_bank*WIDTH);
wire t1_fwrdB_sel_wire = t1_fwrdB >> select_bank;
wire [BITPADR-BITPBNK-1:0] t1_padrB_sel_wire = t1_padrB >> (select_bank*(BITPADR-BITPBNK));
wire t1_doutB_sel_sel_wire = t1_doutB_sel_wire >> select_bit;

reg t2_writeA_wire [0:2*NUMWRPT-1];
reg [BITVROW-1:0] t2_addrA_wire [0:2*NUMWRPT-1];
reg [SDOUT_WIDTH-1:0] t2_sdinA_wire [0:2*NUMWRPT-1];
reg [WIDTH-1:0] t2_cdinA_wire [0:2*NUMWRPT-1];
reg t2_readB_wire [0:2*NUMWRPT-1];
reg [BITVROW-1:0] t2_addrB_wire [0:2*NUMWRPT-1];
reg [SDOUT_WIDTH-1:0] t2_sdoutB_wire [0:2*NUMWRPT-1];
reg [WIDTH-1:0] t2_cdoutB_wire [0:2*NUMWRPT-1];
reg t2_cdoutB_sel_wire [0:2*NUMWRPT-1];
reg t2_fwrdB_wire [0:2*NUMWRPT-1];
reg [BITPADR-BITPBNK-1:0] t2_padrB_wire [0:2*NUMWRPT-1];
integer t2w_int;
always_comb
  for (t2w_int=0; t2w_int<2*NUMWRPT; t2w_int=t2w_int+1) begin
    t2_writeA_wire[t2w_int] = t2_writeA >> t2w_int;
    t2_addrA_wire[t2w_int] = t2_addrA >> (t2w_int*BITVROW);
    t2_sdinA_wire[t2w_int] = t2_dinA >> (t2w_int*(SDOUT_WIDTH+WIDTH)+WIDTH);
    t2_cdinA_wire[t2w_int] = t2_dinA >> (t2w_int*(SDOUT_WIDTH+WIDTH));
    t2_readB_wire[t2w_int] = t2_readB >> t2w_int;
    t2_addrB_wire[t2w_int] = t2_addrB >> (t2w_int*BITVROW);
    t2_sdoutB_wire[t2w_int] = t2_doutB >> (t2w_int*(SDOUT_WIDTH+WIDTH)+WIDTH);
    t2_cdoutB_wire[t2w_int] = t2_doutB >> (t2w_int*(SDOUT_WIDTH+WIDTH));
    t2_cdoutB_sel_wire[t2w_int] = t2_cdoutB_wire[t2w_int] >> select_bit;
    t2_fwrdB_wire[t2w_int] = t2_fwrdB >> t2w_int;
    t2_padrB_wire[t2w_int] = t2_padrB >> (t2w_int*(BITPADR-BITPBNK));
  end

reg meminv;
reg mem;
always @(posedge clk)
  if (rst) begin
    meminv <= 1'b1;
  end else if (t1_writeA_sel_wire && (t1_addrA_sel_wire == select_row)) begin
    meminv <= 1'b0;
    mem <= t1_dinA_sel_wire[select_bit];
  end

reg [SDOUT_WIDTH-1:0] smem [0:NUMWRPT-1];
reg [SDOUT_WIDTH-1:0] cmem [0:NUMWRPT-1];
genvar smem_var;
generate for (smem_var=0; smem_var<NUMWRPT; smem_var=smem_var+1) begin: smem_loop
  always @(posedge clk)
    if (rst)
      smem[smem_var] <= 0;
    else if (t2_writeA_wire[2*smem_var] && (t2_addrA_wire[2*smem_var] == select_row))
      smem[smem_var] <= t2_sdinA_wire[2*smem_var];

  wire [ECCBITS-1:0] smem_ecc;
  ecc_calc   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
      ecc_calc_inst(.din(smem[smem_var][BITVBNK:0]), .eccout(smem_ecc));

  always @(posedge clk)
    if (rst)
      cmem[smem_var] <= 0;
    else if (t2_writeA_wire[2*smem_var] && (t2_addrA_wire[2*smem_var] == select_row))
      cmem[smem_var] <= t2_cdinA_wire[2*smem_var][select_bit];

  assert_smem_ecc_check: assert property (@(posedge clk) disable iff (rst) (smem[smem_var] == {smem[smem_var][BITVBNK:0],smem_ecc,smem[smem_var][BITVBNK:0]}));
end
endgenerate

reg mem_wire;
integer memw_int;
always_comb begin
  mem_wire = mem;
  for (memw_int=0; memw_int<NUMWRPT; memw_int=memw_int+1)
    if (smem[memw_int][BITVBNK] && (smem[memw_int][BITVBNK-1:0] == select_bank))
      mem_wire = cmem[memw_int];
end

assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_sel_wire && (t1_addrB_sel_wire == select_row)) |-> ##SRAM_DELAY
                                     ($past(meminv,SRAM_DELAY) || (t1_doutB_sel_sel_wire == $past(mem,SRAM_DELAY))));

genvar smem_gen;
generate for (smem_gen=0; smem_gen<2*NUMWRPT; smem_gen=smem_gen+1) begin: sgen_loop
  assert_sdout_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[smem_gen] && (t2_addrB_wire[smem_gen] == select_row)) |-> ##SRAM_DELAY
                                       (t2_sdoutB_wire[smem_gen] == $past(smem[smem_gen>>1],SRAM_DELAY)));
  assert_cdout_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[smem_gen] && (t2_addrB_wire[smem_gen] == select_row)) |-> ##SRAM_DELAY
                                       (t2_cdoutB_wire[smem_gen][select_bit] == $past(cmem[smem_gen>>1],SRAM_DELAY)));
  assert_sdout_ecc_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[smem_gen] && (t2_addrB_wire[smem_gen] == select_row)) |-> ##SRAM_DELAY
                                           (core.sdout_out[smem_gen] == $past(smem[smem_gen>>1][BITVBNK:0],SRAM_DELAY)));
end
endgenerate

genvar state_var;
generate for (state_var=0; state_var<2*NUMWRPT; state_var=state_var+1) begin: state_loop
    wire state_serr = 0;
    wire state_derr = 0;
    wire state_nerr = !state_serr && !state_derr;
    assume_state_err_check: assert property (@(posedge clk) disable iff (rst) !(state_serr && state_derr));
    assume_state_serr_check: assert property (@(posedge clk) disable iff (rst) state_serr |-> ##SRAM_DELAY
                                              core.sdo_loop[state_var].sdout_serr && !core.sdo_loop[state_var].sdout_derr);
    assume_state_derr_check: assert property (@(posedge clk) disable iff (rst) state_derr |-> ##SRAM_DELAY
                                              !core.sdo_loop[state_var].sdout_serr && core.sdo_loop[state_var].sdout_derr);
    assume_state_nerr_check: assert property (@(posedge clk) disable iff (rst) state_nerr |-> ##SRAM_DELAY
                                              !core.sdo_loop[state_var].sdout_serr && !core.sdo_loop[state_var].sdout_derr);

    assert_sdout_nerr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[state_var] && (t2_addrB_wire[state_var] == select_row) && state_nerr) |-> ##SRAM_DELAY
                                              !core.sdo_loop[state_var].sdout_ded_err && !core.sdo_loop[state_var].sdout_sec_err &&
                                              (core.sdo_loop[state_var].sdout_dup_data == core.sdo_loop[state_var].sdout_post_ecc));
    assert_sdout_serr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[state_var] && (t2_addrB_wire[state_var] == select_row) && state_serr) |-> ##SRAM_DELAY
                                              !core.sdo_loop[state_var].sdout_ded_err && (core.sdo_loop[state_var].sdout_sec_err ?
                                              (core.sdo_loop[state_var].sdout_dup_data == core.sdo_loop[state_var].sdout_post_ecc) :
                                              (core.sdo_loop[state_var].sdout_dup_data != core.sdo_loop[state_var].sdout_post_ecc)));
    assert_sdout_derr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[state_var] && (t2_addrB_wire[state_var] == select_row) && state_derr) |-> ##SRAM_DELAY
                                              core.sdo_loop[state_var].sdout_ded_err ? !core.sdo_loop[state_var].sdout_sec_err :
                                              core.sdo_loop[state_var].sdout_sec_err ?
                                              !core.sdo_loop[state_var].sdout_ded_err && (core.sdo_loop[state_var].sdout_dup_data != core.sdo_loop[state_var].sdout_post_ecc) :
                                              (core.sdo_loop[state_var].sdout_dup_data != core.sdo_loop[state_var].sdout_post_ecc));
end
endgenerate

reg [NUMWRPT-1:0] wrmsk_reg [0:NUMVBNK-1];
integer wrm_int;
always @(posedge clk)
  if (rst)
    for (wrm_int=0; wrm_int<NUMVBNK; wrm_int=wrm_int+1)
      wrmsk_reg[wrm_int] <= 0;
  else for (wrm_int=0; wrm_int<NUMWRPT; wrm_int=wrm_int+1)
    if (core.vwrite_out[wrm_int])
      wrmsk_reg[core.vwrbadr_out[wrm_int]] <= 1'b1 << wrm_int;

genvar fwd_var;
generate for (fwd_var=0; fwd_var<NUMWRPT; fwd_var=fwd_var+1) begin: fwd_loop
  assert_rdmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[fwd_var] && (core.vrdradr_wire[fwd_var] == select_row)) |-> ##SRAM_DELAY
                                           (core.rdmap_out[fwd_var] == smem[fwd_var][BITVBNK:0]));
  assert_rddat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[fwd_var] && (core.vrdradr_wire[fwd_var] == select_row)) |-> ##SRAM_DELAY
                                           (core.rddat_out[fwd_var][select_bit] == cmem[fwd_var]));
  assert_wrmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[fwd_var] && (core.vwrradr_wire[fwd_var] == select_row)) |-> ##(SRAM_DELAY+1)
                                           (core.wrmap_out[fwd_var] == smem[fwd_var][BITVBNK:0]) &&
                                           !(core.wrmap_out[fwd_var][BITVBNK] && !wrmsk_reg[core.wrmap_out[fwd_var][BITVBNK-1:0]][fwd_var]));
  assert_wrdat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[fwd_var] && (core.vwrradr_wire[fwd_var] == select_row)) |-> ##(SRAM_DELAY+1)
                                            (core.wrdat_out[fwd_var][select_bit] == cmem[fwd_var]));
  assert_pdat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[fwd_var] && (core.vrdaddr_wire[fwd_var] == select_addr)) |-> ##SRAM_DELAY
                                          (meminv || (core.pdat_out[fwd_var][select_bit] == mem)));
  assert_wrmap_alloc_check: assert property (@(posedge clk) disable iff (rst) core.vwrite_wire[fwd_var] |-> ##(SRAM_DELAY+1)
                                             !(core.wrmap_out[fwd_var][BITVBNK] && !wrmsk_reg[core.wrmap_out[fwd_var][BITVBNK-1:0]][fwd_var]));
end
endgenerate


reg rmeminv;
reg rmem;
integer rmem_int;
always @(posedge clk)
  if (rst) begin
    rmeminv <= 1'b1;
  end else for (rmem_int=0; rmem_int<NUMWRPT; rmem_int=rmem_int+1)
    if (core.vwrite_out[rmem_int] && (core.vwrbadr_out[rmem_int] == select_bank) && (core.vwrradr_out[rmem_int] == select_row)) begin
      rmeminv <= 1'b0;
      rmem <= core.vdin_out[rmem_int][select_bit];
    end

assert_rmem_check: assert property (@(posedge clk) disable iff (rst) (rmeminv || (mem_wire == rmem)));

genvar vint_var;
generate for (vint_var=0; vint_var<NUMWRPT; vint_var=vint_var+1) begin: vint_loop
  assert_vdout_int_check: assert property (@(posedge clk) disable iff (rst) (read_wire[vint_var] && (rd_adr_wire[vint_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY)
                                           (rmeminv || (core.vdout_int[vint_var][select_bit] == rmem)));
end
endgenerate

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

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##(FLOPIN+SRAM_DELAY+1)
				       ($past(fakememinv,FLOPIN+SRAM_DELAY+1) || ($past(fakemem,FLOPIN+SRAM_DELAY+1) == rmem)));

genvar dout_var;
generate for (dout_var=0; dout_var<NUMWRPT; dout_var=dout_var+1) begin: dout_loop
  assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_vld_wire[dout_var] && ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) ||
                                                                 (rd_dout_wire[dout_var][select_bit] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)))));
  assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) ||
                                       ($past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)==$past(mem_wire,SRAM_DELAY+FLOPOUT)) || rd_fwrd_wire[dout_var]) &&
                                        (rd_fwrd_wire[dout_var] ||
                                         !((rd_padr_wire[dout_var][BITPADR-1:BITPADR-BITPBNK]==NUMVBNK)     ?  (FLOPOUT ? $past(t2_fwrdB_wire[0]) : t2_fwrdB_wire[0]) :
                                           (rd_padr_wire[dout_var][BITPADR-1:BITPADR-BITPBNK]==(NUMVBNK+1)) ?  (FLOPOUT ? $past(t2_fwrdB_wire[2]) : t2_fwrdB_wire[2]) :
                                                                                                               (FLOPOUT ? $past(t1_fwrdB_sel_wire) : t1_fwrdB_sel_wire))));
  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      ((rd_padr_wire[dout_var] == ((NUMVBNK     << (BITPADR-BITPBNK)) | (FLOPOUT ? $past(t2_padrB_wire[0]) : t2_padrB_wire[0]))) ||
                                       (rd_padr_wire[dout_var] == (((NUMVBNK+1) << (BITPADR-BITPBNK)) | (FLOPOUT ? $past(t2_padrB_wire[2]) : t2_padrB_wire[2]))) ||
                                       (rd_padr_wire[dout_var] == {select_bank,(FLOPOUT ? $past(t1_padrB_sel_wire) : t1_padrB_sel_wire)})));
end
endgenerate

endmodule

