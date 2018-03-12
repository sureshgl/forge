module ip_top_sva_2_1rnwg_1rw_mt
  #(parameter
     WIDTH   = 32,
     NUMADDR = 8192,
     BITADDR = 13,
     NUMWRPT = 2,
     NUMVBNK = 8,
     BITVBNK = 3,
     NUMPBNK = 10,
     BITPBNK = 4,
     NUMVROW = 1024,
     BITVROW = 10,
     BITMAPT = BITPBNK*(NUMPBNK-NUMWRPT+1)
   )
(
  input clk,
  input rst,
  input ready,
  input read,
  input [BITADDR-1:0] rd_adr,
  input [NUMWRPT-1:0] write,
  input [NUMWRPT*BITADDR-1:0] wr_adr,
  input [NUMWRPT*WIDTH-1:0] din,
  input [NUMPBNK-1:0] t1_readA,
  input [NUMPBNK-1:0] t1_writeA,
  input [NUMPBNK*BITVROW-1:0] t1_addrA,
  input [NUMPBNK*WIDTH-1:0] t1_dinA,
  input [4*NUMWRPT-1:0] t2_writeA,
  input [4*NUMWRPT*BITVROW-1:0] t2_addrA,
  input [4*NUMWRPT*BITMAPT-1:0] t2_dinA,
  input [4*NUMWRPT-1:0] t2_readB,
  input [4*NUMWRPT*BITVROW-1:0] t2_addrB
);

assert_rd_range_check: assert property (@(posedge clk) disable iff (rst) read |-> (rd_adr < NUMADDR));

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

reg same_bank;
reg wrong_bank;
integer swx_int, swy_int;
always_comb begin
  same_bank = 1'b0;
  wrong_bank = 1'b0;
  for (swx_int=0; swx_int<NUMWRPT; swx_int=swx_int+1) begin
    if (write_wire[swx_int] && |wrmsk[wr_badr_wire[swx_int]] && !wrmsk[wr_badr_wire[swx_int]][swx_int])
      wrong_bank = 1'b1;
    for (swy_int=0; swy_int<NUMWRPT; swy_int=swy_int+1) 
      if ((swx_int!=swy_int) && write_wire[swx_int] && write_wire[swy_int] && (wr_badr_wire[swx_int] == wr_badr_wire[swy_int]))
        same_bank = 1'b1;
  end
end

assert_wr_alloc_check: assert property (@(posedge clk) disable iff (rst) !(same_bank || wrong_bank));
 
genvar t1b_int;
generate for (t1b_int=0; t1b_int<NUMPBNK; t1b_int=t1b_int+1) begin: t1b_loop
  wire t1_readA_wire = t1_readA >> t1b_int;
  wire t1_writeA_wire = t1_writeA >> t1b_int;
  wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> (t1b_int*BITVROW);
  wire [WIDTH-1:0] t1_dinA_wire = t1_dinA >> (t1b_int*WIDTH);

  assert_t1_1p_check: assert property (@(posedge clk) disable iff (rst) !(t1_readA_wire && t1_writeA_wire));
  assert_t1_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire || t1_writeA_wire) |-> (t1_addrA_wire < NUMVROW));
end
endgenerate

genvar t2w_int, t2r_int;
generate
  for (t2w_int=0; t2w_int<NUMWRPT; t2w_int=t2w_int+1) begin: t2w_loop
    for (t2r_int=0; t2r_int<2*NUMWRPT; t2r_int=t2r_int+1) begin: t2r_loop
      wire t2_writeA_wire = t2_writeA >> (4*t2w_int+t2r_int);
      wire [BITVROW-1:0] t2_addrA_wire = t2_addrA >> ((4*t2w_int+t2r_int)*BITVROW);
      wire [BITMAPT-1:0] t2_dinA_wire = t2_dinA >> ((4*t2w_int+t2r_int)*BITMAPT);

      wire t2_readB_wire = t2_readB >> (4*t2w_int+t2r_int);
      wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> ((4*t2w_int+t2r_int)*BITVROW);

      wire t2_writeA_0_wire = t2_writeA >> (4*t2w_int);
      wire [BITVROW-1:0] t2_addrA_0_wire = t2_addrA >> ((4*t2w_int)*BITVROW);
      wire [BITMAPT-1:0] t2_dinA_0_wire = t2_dinA >> ((4*t2w_int)*BITMAPT);

      assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_addrA_wire < NUMVROW));
      assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire |-> (t2_addrB_wire < NUMVROW));
      assert_t2_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t2_writeA_wire && t2_readB_wire) |-> (t2_addrA_wire != t2_addrB_wire));
      assert_t2_wr_same_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |->
                                                (t2_writeA_0_wire && (t2_addrA_0_wire == t2_addrA_wire) && (t2_dinA_0_wire == t2_dinA_wire)));
    end
  end
endgenerate

endmodule

module ip_top_sva_1rnwg_1rw_mt
  #(parameter
     WIDTH   = 32,
     BITWDTH = 5,
     NUMADDR = 8192,
     BITADDR = 13,
     NUMWRPT = 2,
     NUMVROW = 1024,
     BITVROW = 10,
     NUMVBNK = 8,
     BITVBNK = 3,
     NUMPBNK = 10,
     BITPBNK = 4,
     BITPADR = 15,
     SRAM_DELAY = 2,
     DRAM_DELAY = 2,
     FLOPIN = 0,
     FLOPOUT = 0,
     BITMAPT = BITPBNK*(NUMPBNK-NUMWRPT+1)
   )
(
  input clk,
  input rst,
  input read,
  input [BITADDR-1:0] rd_adr,
  input [WIDTH-1:0] rd_dout,
  input rd_vld,
  input rd_fwrd,
  input rd_serr,
  input rd_derr,
  input [BITPADR-1:0] rd_padr,
  input [NUMWRPT-1:0] write,
  input [NUMWRPT*BITADDR-1:0] wr_adr,
  input [NUMWRPT*WIDTH-1:0] din,
  input [NUMPBNK-1:0] t1_readA,
  input [NUMPBNK-1:0] t1_writeA,
  input [NUMPBNK*BITVROW-1:0] t1_addrA,
  input [NUMPBNK*WIDTH-1:0] t1_dinA,
  input [NUMPBNK*WIDTH-1:0] t1_doutA,
  input [NUMPBNK-1:0] t1_fwrdA,
  input [NUMPBNK-1:0] t1_serrA,
  input [NUMPBNK-1:0] t1_derrA,
  input [NUMPBNK*(BITPADR-BITPBNK)-1:0] t1_padrA,
  input [4*NUMWRPT-1:0] t2_writeA,
  input [4*NUMWRPT*BITVROW-1:0] t2_addrA,
  input [4*NUMWRPT*BITMAPT-1:0] t2_dinA,
  input [4*NUMWRPT-1:0] t2_readB,
  input [4*NUMWRPT*BITVROW-1:0] t2_addrB,
  input [4*NUMWRPT*BITMAPT-1:0] t2_doutB,
  input [4*NUMWRPT-1:0] t2_fwrdB,
  input [4*NUMWRPT-1:0] t2_serrB,
  input [4*NUMWRPT-1:0] t2_derrB,
  input [4*NUMWRPT*BITVROW-1:0] t2_padrB,
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
integer prt_int;
always_comb
  for (prt_int=0; prt_int<NUMWRPT; prt_int=prt_int+1) begin
    write_wire[prt_int] = write >> prt_int;
    wr_adr_wire[prt_int] = wr_adr >> (prt_int*BITADDR);
    din_wire[prt_int] = din >> (prt_int*WIDTH);
  end

wire t1_readA_wire [0:NUMPBNK-1];
wire t1_writeA_wire [0:NUMPBNK-1];
wire [BITVROW-1:0] t1_addrA_wire [0:NUMPBNK-1];
wire [WIDTH-1:0] t1_dinA_wire [0:NUMPBNK-1];
wire [WIDTH-1:0] t1_doutA_wire [0:NUMPBNK-1];
wire t1_serrA_wire [0:16-1];
wire t1_derrA_wire [0:16-1];
wire [BITPADR-BITPBNK-1:0] t1_padrA_wire [0:16-1];
genvar t1b_int, t1r_int;
generate for (t1b_int=0; t1b_int<NUMPBNK; t1b_int=t1b_int+1) begin: t1b_loop
  assign t1_readA_wire[t1b_int] = t1_readA >> t1b_int;
  assign t1_writeA_wire[t1b_int] = t1_writeA >> t1b_int;
  assign t1_addrA_wire[t1b_int] = t1_addrA >> (t1b_int*BITVROW);
  assign t1_dinA_wire[t1b_int] = t1_dinA >> (t1b_int*WIDTH);
  assign t1_doutA_wire[t1b_int] = t1_doutA >> (t1b_int*WIDTH);
  assign t1_serrA_wire[t1b_int] = t1_serrA >> t1b_int;
  assign t1_derrA_wire[t1b_int] = t1_derrA >> t1b_int;
  assign t1_padrA_wire[t1b_int] = t1_padrA >> (t1b_int*(BITPADR-BITPBNK));
end
endgenerate

wire t2_writeA_wire [0:4*NUMWRPT-1];
wire [BITVROW-1:0] t2_addrA_wire [0:4*NUMWRPT-1];
wire [BITMAPT-1:0] t2_dinA_wire [0:4*NUMWRPT-1];
wire t2_readB_wire [0:4*NUMWRPT-1];
wire [BITVROW-1:0] t2_addrB_wire [0:4*NUMWRPT-1];
wire [BITMAPT-1:0] t2_doutB_wire [0:4*NUMWRPT-1];
wire t2_fwrdB_wire [0:4*NUMWRPT-1];
wire t2_serrB_wire [0:4*NUMWRPT-1];
wire t2_derrB_wire [0:4*NUMWRPT-1];
wire [BITVROW-1:0] t2_padrB_wire [0:4*NUMWRPT-1];
genvar t2p_int;
generate for (t2p_int=0; t2p_int<4*NUMWRPT; t2p_int=t2p_int+1) begin: t2_loop
  assign t2_writeA_wire[t2p_int] = t2_writeA >> t2p_int;
  assign t2_addrA_wire[t2p_int] = t2_addrA >> (t2p_int*BITVROW);
  assign t2_dinA_wire[t2p_int] = t2_dinA >> (t2p_int*BITMAPT);
  assign t2_readB_wire[t2p_int] = t2_readB >> t2p_int;
  assign t2_addrB_wire[t2p_int] = t2_addrB >> (t2p_int*BITVROW);
  assign t2_doutB_wire[t2p_int] = t2_doutB >> (t2p_int*BITMAPT); 
  assign t2_fwrdB_wire[t2p_int] = t2_fwrdB >> t2p_int;
  assign t2_serrB_wire[t2p_int] = t2_serrB >> t2p_int;
  assign t2_derrB_wire[t2p_int] = t2_derrB >> t2p_int;
  assign t2_padrB_wire[t2p_int] = t2_padrB >> (t2p_int*BITVROW); 
end
endgenerate

reg [NUMPBNK-1:0] pmeminv;
reg [NUMPBNK-1:0] pmem;
integer pmem_int;
always @(posedge clk)
  if (rst)
    pmeminv <= ~0;
  else for (pmem_int=0; pmem_int<NUMPBNK; pmem_int=pmem_int+1)
    if (t1_writeA_wire[pmem_int] && (t1_addrA_wire[pmem_int] == select_row)) begin
      pmeminv[pmem_int] <= 1'b0;
      pmem[pmem_int] <= t1_dinA_wire[pmem_int] >> select_bit;
    end

reg [BITMAPT-1:0] smem [0:NUMWRPT-1];
integer smem_int;
always @(posedge clk)
  for (smem_int=0; smem_int<NUMWRPT; smem_int=smem_int+1)
    if (rst)
      smem[smem_int] <= ~0;
    else if (t2_writeA_wire[4*smem_int] && (t2_addrA_wire[4*smem_int] == select_row))
      smem[smem_int] <= t2_dinA_wire[4*smem_int];

reg [BITPBNK-1:0] smem_sel_wire;
reg [BITPBNK-1:0] smem_sel_tmp;
integer ssel_int;
always_comb begin
  smem_sel_wire = select_bank;
  for (ssel_int=0; ssel_int<NUMWRPT; ssel_int=ssel_int+1) begin
    smem_sel_tmp = smem[ssel_int] >> (select_bank*BITPBNK);
    if (!(&smem_sel_tmp))
      smem_sel_wire = smem_sel_tmp;
  end
end

wire mem_wire = pmem[smem_sel_wire];

genvar pdout_int;
generate for (pdout_int=0; pdout_int<NUMPBNK; pdout_int=pdout_int+1) begin: pdout_loop
  assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire[pdout_int] && (t1_addrA_wire[pdout_int] == select_row)) |-> ##DRAM_DELAY
				         ($past(pmeminv[pdout_int],DRAM_DELAY) || (t1_doutA_wire[pdout_int][select_bit] == $past(pmem[pdout_int],DRAM_DELAY))));
end
endgenerate

genvar sdout_int, sdoutr_int;
generate for (sdout_int=0; sdout_int<NUMWRPT; sdout_int=sdout_int+1) begin: sdout_loop
  for (sdoutr_int=0; sdoutr_int<4; sdoutr_int=sdoutr_int+1) begin: sdoutr_loop
    assert_sdout_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[4*sdout_int+sdoutr_int] && (t2_addrB_wire[4*sdout_int+sdoutr_int] == select_row)) |-> ##SRAM_DELAY
                                         (!t2_fwrdB_wire[4*sdout_int+sdoutr_int] && t2_derrB_wire[4*sdout_int+sdoutr_int]) ||
                                         (t2_doutB_wire[4*sdout_int+sdoutr_int] == $past(smem[sdout_int],SRAM_DELAY)));
    if (sdoutr_int[0]==0)
      assert_sdout_err_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[4*sdout_int+sdoutr_int] && (t2_addrB_wire[4*sdout_int+sdoutr_int] == select_row)) |-> ##SRAM_DELAY
                                               (!t2_serrB_wire[4*sdout_int+sdoutr_int]   && !t2_derrB_wire[4*sdout_int+sdoutr_int]) || 
                                               (!t2_serrB_wire[4*sdout_int+sdoutr_int+1] && !t2_derrB_wire[4*sdout_int+sdoutr_int+1]) || 
                                               (t2_serrB_wire[4*sdout_int+sdoutr_int]    && t2_serrB_wire[4*sdout_int+sdoutr_int+1]));
  end
end
endgenerate
 
genvar fwd_int;
generate for (fwd_int=0; fwd_int<NUMWRPT; fwd_int=fwd_int+1) begin: fwd_loop
  assert_rdmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire && (core.vrdradr_wire == select_row)) |-> ##SRAM_DELAY
                                           (core.rdmap_out[fwd_int] == smem[fwd_int]));
  assert_wrmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[fwd_int] && (core.vwrradr_wire[fwd_int] == select_row)) |-> ##SRAM_DELAY
                                           ((core.wrmap_out[fwd_int] == smem[fwd_int]) &&
                                            (!core.vwrite_out[fwd_int] ||
                                             ((&core.wrbnk_tmp[fwd_int] || (core.wrbnk_tmp[fwd_int] == (NUMVBNK+fwd_int)) ||
                                               ((core.wrbnk_tmp[fwd_int]<NUMVBNK) && ip_top_sva_2.wrmsk[core.wrbnk_tmp[fwd_int]][fwd_int])) &&
                                              (&core.wrfre_tmp[fwd_int] || (core.wrfre_tmp[fwd_int] == (NUMVBNK+fwd_int)) ||
                                               ((core.wrfre_tmp[fwd_int]<NUMVBNK) && ip_top_sva_2.wrmsk[core.wrfre_tmp[fwd_int]][fwd_int]))))));
  assert_wrmap_alloc_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[fwd_int]) |-> ##SRAM_DELAY
                                             (!core.vwrite_out[fwd_int] ||
                                              ((&core.wrbnk_tmp[fwd_int] || (core.wrbnk_tmp[fwd_int] == (NUMVBNK+fwd_int)) ||
                                                ((core.wrbnk_tmp[fwd_int]<NUMVBNK) && ip_top_sva_2.wrmsk[core.wrbnk_tmp[fwd_int]][fwd_int])) &&
                                               (&core.wrfre_tmp[fwd_int] || (core.wrfre_tmp[fwd_int] == (NUMVBNK+fwd_int)) ||
                                                ((core.wrfre_tmp[fwd_int]<NUMVBNK) && ip_top_sva_2.wrmsk[core.wrfre_tmp[fwd_int]][fwd_int])))));
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

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##SRAM_DELAY
				       ($past(fakememinv,SRAM_DELAY) || ($past(fakemem,SRAM_DELAY) == mem_wire)));

assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
                                    (rd_vld && ($past(fakememinv,FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT) ||
                                                (rd_dout[select_bit] == $past(fakemem,FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)))));
assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 0)  && (rd_serr == (FLOPOUT ? $past(t1_serrA_wire[0])  : t1_serrA_wire[0])) && 
                                                        (rd_derr == (FLOPOUT ? $past(t1_derrA_wire[0])  : t1_derrA_wire[0]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 1)  && (rd_serr == (FLOPOUT ? $past(t1_serrA_wire[1])  : t1_serrA_wire[1])) && 
                                                        (rd_derr == (FLOPOUT ? $past(t1_derrA_wire[1])  : t1_derrA_wire[1]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 2)  && (rd_serr == (FLOPOUT ? $past(t1_serrA_wire[2])  : t1_serrA_wire[2])) && 
                                                        (rd_derr == (FLOPOUT ? $past(t1_derrA_wire[2])  : t1_derrA_wire[2]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 3)  && (rd_serr == (FLOPOUT ? $past(t1_serrA_wire[3])  : t1_serrA_wire[3])) && 
                                                        (rd_derr == (FLOPOUT ? $past(t1_derrA_wire[3])  : t1_derrA_wire[3]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 4)  && (rd_serr == (FLOPOUT ? $past(t1_serrA_wire[4])  : t1_serrA_wire[4])) && 
                                                        (rd_derr == (FLOPOUT ? $past(t1_derrA_wire[4])  : t1_derrA_wire[4]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 5)  && (rd_serr == (FLOPOUT ? $past(t1_serrA_wire[5])  : t1_serrA_wire[5])) && 
                                                        (rd_derr == (FLOPOUT ? $past(t1_derrA_wire[5])  : t1_derrA_wire[5]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 6)  && (rd_serr == (FLOPOUT ? $past(t1_serrA_wire[6])  : t1_serrA_wire[6])) && 
                                                        (rd_derr == (FLOPOUT ? $past(t1_derrA_wire[6])  : t1_derrA_wire[6]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 7)  && (rd_serr == (FLOPOUT ? $past(t1_serrA_wire[7])  : t1_serrA_wire[7])) && 
                                                        (rd_derr == (FLOPOUT ? $past(t1_derrA_wire[7])  : t1_derrA_wire[7]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 8)  && (rd_serr == (FLOPOUT ? $past(t1_serrA_wire[8])  : t1_serrA_wire[8])) && 
                                                        (rd_derr == (FLOPOUT ? $past(t1_derrA_wire[8])  : t1_derrA_wire[8]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 9)  && (rd_serr == (FLOPOUT ? $past(t1_serrA_wire[9])  : t1_serrA_wire[9])) && 
                                                        (rd_derr == (FLOPOUT ? $past(t1_derrA_wire[9])  : t1_derrA_wire[9]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 10) && (rd_serr == (FLOPOUT ? $past(t1_serrA_wire[10]) : t1_serrA_wire[10])) && 
                                                        (rd_derr == (FLOPOUT ? $past(t1_derrA_wire[10]) : t1_derrA_wire[10]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 11) && (rd_serr == (FLOPOUT ? $past(t1_serrA_wire[11]) : t1_serrA_wire[11])) && 
                                                        (rd_derr == (FLOPOUT ? $past(t1_derrA_wire[11]) : t1_derrA_wire[11]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 12) && (rd_serr == (FLOPOUT ? $past(t1_serrA_wire[12]) : t1_serrA_wire[12])) && 
                                                        (rd_derr == (FLOPOUT ? $past(t1_derrA_wire[12]) : t1_derrA_wire[12]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 13) && (rd_serr == (FLOPOUT ? $past(t1_serrA_wire[13]) : t1_serrA_wire[13])) && 
                                                        (rd_derr == (FLOPOUT ? $past(t1_derrA_wire[13]) : t1_derrA_wire[13]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 14) && (rd_serr == (FLOPOUT ? $past(t1_serrA_wire[14]) : t1_serrA_wire[14])) && 
                                                        (rd_derr == (FLOPOUT ? $past(t1_derrA_wire[14]) : t1_derrA_wire[14]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 15) && (rd_serr == (FLOPOUT ? $past(t1_serrA_wire[15]) : t1_serrA_wire[15])) && 
                                                        (rd_derr == (FLOPOUT ? $past(t1_derrA_wire[15]) : t1_derrA_wire[15]))));
//                                      ((rd_serr == (FLOPOUT ? $past(t1_serrA_wire[$past(smem_sel_wire,DRAM_DELAY)]) : t1_serrA_wire[$past(smem_sel_wire,DRAM_DELAY)])) &&
//                                       (rd_derr == (FLOPOUT ? $past(t1_derrA_wire[$past(smem_sel_wire,DRAM_DELAY)]) : t1_derrA_wire[$past(smem_sel_wire,DRAM_DELAY)]))));
assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
                                    (rd_padr == ((NUMVBNK << (BITPADR-BITPBNK)) | select_row)) ||
                                    (rd_padr == ((NUMVBNK+1) << (BITPADR-BITPBNK)) | select_row) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 0)  && (rd_padr == ((0 << (BITPADR-BITPBNK))  | (FLOPOUT ? $past(t1_padrA_wire[0])  : t1_padrA_wire[0])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 1)  && (rd_padr == ((1 << (BITPADR-BITPBNK))  | (FLOPOUT ? $past(t1_padrA_wire[1])  : t1_padrA_wire[1])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 2)  && (rd_padr == ((2 << (BITPADR-BITPBNK))  | (FLOPOUT ? $past(t1_padrA_wire[2])  : t1_padrA_wire[2])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 3)  && (rd_padr == ((3 << (BITPADR-BITPBNK))  | (FLOPOUT ? $past(t1_padrA_wire[3])  : t1_padrA_wire[3])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 4)  && (rd_padr == ((4 << (BITPADR-BITPBNK))  | (FLOPOUT ? $past(t1_padrA_wire[4])  : t1_padrA_wire[4])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 5)  && (rd_padr == ((5 << (BITPADR-BITPBNK))  | (FLOPOUT ? $past(t1_padrA_wire[5])  : t1_padrA_wire[5])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 6)  && (rd_padr == ((6 << (BITPADR-BITPBNK))  | (FLOPOUT ? $past(t1_padrA_wire[6])  : t1_padrA_wire[6])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 7)  && (rd_padr == ((7 << (BITPADR-BITPBNK))  | (FLOPOUT ? $past(t1_padrA_wire[7])  : t1_padrA_wire[7])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 8)  && (rd_padr == ((8 << (BITPADR-BITPBNK))  | (FLOPOUT ? $past(t1_padrA_wire[8])  : t1_padrA_wire[8])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 9)  && (rd_padr == ((9 << (BITPADR-BITPBNK))  | (FLOPOUT ? $past(t1_padrA_wire[9])  : t1_padrA_wire[9])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 10) && (rd_padr == ((10 << (BITPADR-BITPBNK)) | (FLOPOUT ? $past(t1_padrA_wire[10]) : t1_padrA_wire[10])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 11) && (rd_padr == ((11 << (BITPADR-BITPBNK)) | (FLOPOUT ? $past(t1_padrA_wire[11]) : t1_padrA_wire[11])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 12) && (rd_padr == ((12 << (BITPADR-BITPBNK)) | (FLOPOUT ? $past(t1_padrA_wire[12]) : t1_padrA_wire[12])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 13) && (rd_padr == ((13 << (BITPADR-BITPBNK)) | (FLOPOUT ? $past(t1_padrA_wire[13]) : t1_padrA_wire[13])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 14) && (rd_padr == ((14 << (BITPADR-BITPBNK)) | (FLOPOUT ? $past(t1_padrA_wire[14]) : t1_padrA_wire[14])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 15) && (rd_padr == ((15 << (BITPADR-BITPBNK)) | (FLOPOUT ? $past(t1_padrA_wire[15]) : t1_padrA_wire[15])))));
//                                      (rd_padr == {$past(smem_sel_wire,DRAM_DELAY+FLOPOUT),(FLOPOUT ? $past(t1_padrA_wire[$past(smem_sel_wire,DRAM_DELAY)]) : t1_padrA_wire[$past(smem_sel_wire,DRAM_DELAY)])})));
//  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_int] && (addr_wire[dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
//                                      (&rd_padr || (rd_padr == ((NUMVBNK << (BITPADR-BITPBNK)) | select_row)) ||
//                                      (rd_padr == {select_bank,(FLOPOUT ? $past(t1_padrA_sel_wire) : t1_padrA_sel_wire)})));

endmodule

