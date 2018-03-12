module ip_top_sva_2_nru_1r1w_mt
  #(
parameter     WIDTH   = 32,
parameter     ENAPAR  = 0,
parameter     ENAECC  = 0,
parameter     ECCWDTH = 7,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMRUPT = 2,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     NUMPBNK = 11,
parameter     BITPBNK = 4,
parameter     NUMWRDS = 4,
parameter     BITWRDS = 2,
parameter     NUMSROW = 256,
parameter     BITSROW = 8,
parameter     SRAM_DELAY = 2,
parameter     DRAM_DELAY = 2,
parameter     BITMAPT = BITPBNK*NUMVBNK,
parameter     MEMWDTH = ENAPAR ? NUMWRDS*WIDTH+1 : ENAECC ? NUMWRDS*WIDTH+ECCWDTH : NUMWRDS*WIDTH
   )
(
  input clk,
  input rst,
  input ready,
  input [NUMRUPT-1:0] read,
  input [NUMRUPT-1:0] write,
  input [NUMRUPT*BITADDR-1:0] addr,
  input [NUMRUPT*WIDTH-1:0] din,
  input [NUMRUPT*NUMPBNK-1:0] t1_writeA,
  input [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_addrA,
  input [NUMRUPT*NUMPBNK*MEMWDTH-1:0] t1_dinA,
  input [NUMRUPT*NUMPBNK-1:0] t1_readB,
  input [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_addrB,
  input [(NUMRUPT-1)-1:0] t2_writeA,
  input [(NUMRUPT-1)*BITSROW-1:0] t2_addrA,
  input [NUMRUPT-1:0] t2_readB,
  input [NUMRUPT*BITSROW-1:0] t2_addrB
);

genvar prt_int;
generate
  for (prt_int=0; prt_int<NUMRUPT; prt_int=prt_int+1) begin: prt_loop
    wire read_wire = read >> prt_int;
    wire write_wire = write >> prt_int;
    wire [BITADDR-1:0] addr_wire = addr >> (prt_int*BITADDR);

    assert_rd_range_check: assert property (@(posedge clk) disable iff (!ready) read_wire |-> (addr_wire < NUMADDR));
    assert_rd_wr_check: assert property (@(posedge clk) disable iff (!ready) !read_wire |-> ##(SRAM_DELAY+DRAM_DELAY) !write_wire);
  end
endgenerate

genvar t1r_int, t1b_int;
generate
  for (t1r_int=0; t1r_int<NUMRUPT; t1r_int=t1r_int+1) begin: t1r_loop
    for (t1b_int=0; t1b_int<NUMPBNK; t1b_int=t1b_int+1) begin: t1b_loop
      wire t1_writeA_wire = t1_writeA >> (t1r_int*NUMPBNK+t1b_int);
      wire [BITSROW-1:0] t1_addrA_wire = t1_addrA >> ((t1r_int*NUMPBNK+t1b_int)*BITSROW);
      wire [MEMWDTH-1:0] t1_dinA_wire = t1_dinA >> ((t1r_int*NUMPBNK+t1b_int)*MEMWDTH);

      wire t1_readB_wire = t1_readB >> (t1r_int*NUMPBNK+t1b_int);
      wire [BITSROW-1:0] t1_addrB_wire = t1_addrB >> ((t1r_int*NUMPBNK+t1b_int)*BITSROW);

      wire t1_writeA_0_wire = t1_writeA >> t1b_int;
      wire [BITSROW-1:0] t1_addrA_0_wire = t1_addrA >> (t1b_int*BITSROW);
      wire [MEMWDTH-1:0] t1_dinA_0_wire = t1_dinA >> (t1b_int*MEMWDTH);

      assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMSROW));
      assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> (t1_addrB_wire < NUMSROW));
//      assert_t1_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t1_writeA_wire && t1_readB_wire) |-> (t1_addrA_wire != t1_addrB_wire));
//      assert_t1_wr_same_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |->
//                                                (t1_writeA_0_wire && (t1_addrA_0_wire == t1_addrA_wire) && (t1_dinA_0_wire == t1_dinA_wire)));
    end
  end
endgenerate

genvar t2w_int, t2r_int;
generate
  for (t2w_int=0; t2w_int<NUMRUPT-1; t2w_int=t2w_int+1) begin: t2w_loop
    wire t2_writeA_wire = t2_writeA >> t2w_int;
    wire [BITSROW-1:0] t2_addrA_wire = t2_addrA >> (t2w_int*BITSROW);
    assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_addrA_wire < NUMSROW));

    for (t2r_int=0; t2r_int<NUMRUPT-1; t2r_int=t2r_int+1)
      if (t2r_int != t2w_int) begin: t2wp_loop
        wire t2_writeA_wp_wire = t2_writeA >> t2r_int;
        wire [BITSROW-1:0] t2_addrA_wp_wire = t2_addrA >> (t2r_int*BITSROW);
        assert_t2_ww_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t2_writeA_wire && t2_writeA_wp_wire) |-> (t2_addrA_wire != t2_addrA_wp_wire));
      end
  end

  for (t2w_int=0; t2w_int<NUMRUPT; t2w_int=t2w_int+1) begin: t2r_loop
    wire t2_readB_wire = t2_readB >> t2w_int;
    wire [BITSROW-1:0] t2_addrB_wire = t2_addrB >> (t2w_int*BITSROW);
    assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire |-> (t2_addrB_wire < NUMSROW));
/*
    for (t2r_int=0; t2r_int<NUMRUPT-1; t2r_int=t2r_int+1) begin: t2wp_loop
      wire t2_writeA_wp_wire = t2_writeA >> t2r_int;
      wire [BITSROW-1:0] t2_addrA_wp_wire = t2_addrA >> (t2r_int*BITSROW);
      assert_t2_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire && t2_writeA_wp_wire) |-> (t2_addrB_wire != t2_addrA_wp_wire));
    end
*/
  end
endgenerate

endmodule


module ip_top_sva_nru_1r1w_mt
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     ENAPAR  = 0,
parameter     ENAECC  = 0,
parameter     ECCWDTH = 7,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMRUPT = 2,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     NUMPBNK = 11,
parameter     BITPBNK = 4,
parameter     NUMWRDS = 4,
parameter     BITWRDS = 2,
parameter     NUMSROW = 256,
parameter     BITSROW = 8,
parameter     BITPADR = 14,
parameter     SRAM_DELAY = 2,
parameter     DRAM_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPPWR = 0,
parameter     FLOPOUT = 0,
parameter     BITMAPT = BITPBNK*NUMVBNK,
parameter     MEMWDTH = ENAPAR ? NUMWRDS*WIDTH+1 : ENAECC ? NUMWRDS*WIDTH+ECCWDTH: NUMWRDS*WIDTH
   )
(
  input clk,
  input rst,
  input ready,
  input [NUMRUPT-1:0] read,
  input [NUMRUPT-1:0] write,
  input [NUMRUPT*BITADDR-1:0] addr,
  input [NUMRUPT*WIDTH-1:0] din,
  input [NUMRUPT-1:0] rd_vld,
  input [NUMRUPT*WIDTH-1:0] rd_dout,
  input [NUMRUPT-1:0] rd_fwrd,
  input [NUMRUPT-1:0] rd_serr,
  input [NUMRUPT-1:0] rd_derr,
  input [NUMRUPT*BITPADR-1:0] rd_padr,
  input [NUMRUPT*NUMPBNK-1:0] t1_writeA,
  input [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_addrA,
  input [NUMRUPT*NUMPBNK*MEMWDTH-1:0] t1_dinA,
  input [NUMRUPT*NUMPBNK-1:0] t1_readB,
  input [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_addrB,
  input [NUMRUPT*NUMPBNK*MEMWDTH-1:0] t1_doutB,
  input [NUMRUPT*NUMPBNK-1:0] t1_fwrdB,
  input [NUMRUPT*NUMPBNK-1:0] t1_serrB,
  input [NUMRUPT*NUMPBNK-1:0] t1_derrB,
  input [NUMRUPT*NUMPBNK*(BITPADR-BITPBNK-BITWRDS)-1:0] t1_padrB,
  input [(NUMRUPT-1)-1:0] t2_writeA,
  input [(NUMRUPT-1)*BITSROW-1:0] t2_addrA,
  input [(NUMRUPT-1)*BITMAPT-1:0] t2_dinA,
  input [NUMRUPT-1:0] t2_readB,
  input [NUMRUPT*BITSROW-1:0] t2_addrB,
  input [NUMRUPT*BITMAPT-1:0] t2_doutB,
  input [BITADDR-1:0] select_addr,
  input [BITWDTH-1:0] select_bit
);

wire [BITVBNK-1:0] select_bank;
wire [BITVROW-1:0] select_vrow;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  badr_inst (.vbadr(select_bank), .vradr(select_vrow), .vaddr(select_addr));

wire [BITWRDS-1:0] select_word;
wire [BITSROW-1:0] select_srow;
generate if (NUMWRDS>1) begin: wd_loop
  np2_addr #(
    .NUMADDR (NUMVROW), .BITADDR (BITVROW),
    .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
    .NUMVROW (NUMSROW), .BITVROW (BITSROW))
    wadr_inst (.vbadr(select_word), .vradr(select_srow), .vaddr(select_vrow));
end else begin: nwd_loop
  assign select_word = 0;
  assign select_srow = select_vrow;
end
endgenerate

reg read_wire [0:NUMRUPT-1];
reg write_wire [0:NUMRUPT-1];
reg [BITADDR-1:0] addr_wire [0:NUMRUPT-1];
reg [WIDTH-1:0] din_wire [0:NUMRUPT-1];
reg rd_vld_wire [0:NUMRUPT-1];
reg [WIDTH-1:0] rd_dout_wire [0:NUMRUPT-1];
reg rd_fwrd_wire [0:NUMRUPT-1];
reg rd_serr_wire [0:NUMRUPT-1];
reg rd_derr_wire [0:NUMRUPT-1];
reg [BITPADR-1:0] rd_padr_wire [0:NUMRUPT-1];
integer prt_int;
always_comb begin
  for (prt_int=0; prt_int<NUMRUPT; prt_int=prt_int+1) begin
    read_wire[prt_int] = read >> prt_int;
    write_wire[prt_int] = write >> prt_int;
    addr_wire[prt_int] = addr >> (prt_int*BITADDR);
    din_wire[prt_int] = din >> (prt_int*WIDTH);
    rd_vld_wire[prt_int] = rd_vld >> prt_int;
    rd_dout_wire[prt_int] = rd_dout >> (prt_int*WIDTH);
    rd_fwrd_wire[prt_int] = rd_fwrd >> prt_int;
    rd_serr_wire[prt_int] = rd_serr >> prt_int;
    rd_derr_wire[prt_int] = rd_derr >> prt_int;
    rd_padr_wire[prt_int] = rd_padr >> (prt_int*BITPADR);
  end
end

wire t1_writeA_wire [0:NUMPBNK-1][0:NUMRUPT-1];
wire [BITSROW-1:0] t1_addrA_wire [0:NUMPBNK-1][0:NUMRUPT-1];
wire [MEMWDTH-1:0] t1_dinA_wire [0:NUMPBNK-1][0:NUMRUPT-1];
wire t1_readB_wire [0:NUMPBNK-1][0:NUMRUPT-1];
wire [BITSROW-1:0] t1_addrB_wire [0:NUMPBNK-1][0:NUMRUPT-1];
wire [MEMWDTH-1:0] t1_doutB_wire [0:NUMPBNK-1][0:NUMRUPT-1];
wire t1_fwrdB_wire [0:16-1][0:NUMRUPT-1];
wire t1_serrB_wire [0:16-1][0:NUMRUPT-1];
wire t1_derrB_wire [0:16-1][0:NUMRUPT-1];
wire [BITPADR-BITPBNK-BITWRDS-1:0] t1_padrB_wire [0:16-1][0:NUMRUPT-1];
genvar t1b_int, t1r_int;
generate
  for (t1b_int=0; t1b_int<NUMPBNK; t1b_int=t1b_int+1) begin: t1b_loop
    for (t1r_int=0; t1r_int<NUMRUPT; t1r_int=t1r_int+1) begin: t1r_loop
      assign t1_writeA_wire[t1b_int][t1r_int] = t1_writeA >> (NUMPBNK*t1r_int+t1b_int);
      assign t1_addrA_wire[t1b_int][t1r_int] = t1_addrA >> ((NUMPBNK*t1r_int+t1b_int)*BITSROW);
      assign t1_dinA_wire[t1b_int][t1r_int] = t1_dinA >> ((NUMPBNK*t1r_int+t1b_int)*MEMWDTH);
      assign t1_readB_wire[t1b_int][t1r_int] = t1_readB >> (NUMPBNK*t1r_int+t1b_int);
      assign t1_addrB_wire[t1b_int][t1r_int] = t1_addrB >> ((NUMPBNK*t1r_int+t1b_int)*BITSROW);
      assign t1_doutB_wire[t1b_int][t1r_int] = t1_doutB >> ((NUMPBNK*t1r_int+t1b_int)*MEMWDTH);
      assign t1_fwrdB_wire[t1b_int][t1r_int] = t1_fwrdB >> (NUMPBNK*t1r_int+t1b_int);
      assign t1_serrB_wire[t1b_int][t1r_int] = t1_serrB >> (NUMPBNK*t1r_int+t1b_int);
      assign t1_derrB_wire[t1b_int][t1r_int] = t1_derrB >> (NUMPBNK*t1r_int+t1b_int);
      assign t1_padrB_wire[t1b_int][t1r_int] = t1_padrB >> ((NUMPBNK*t1r_int+t1b_int)*(BITPADR-BITPBNK-BITWRDS));
    end
  end
endgenerate

wire t2_writeA_wire [0:(NUMRUPT-1)-1];
wire [BITSROW-1:0] t2_addrA_wire [0:(NUMRUPT-1)-1];
wire [BITMAPT-1:0] t2_dinA_wire [0:(NUMRUPT-1)-1];
wire t2_readB_wire [0:NUMRUPT-1];
wire [BITSROW-1:0] t2_addrB_wire [0:NUMRUPT-1];
wire [BITMAPT-1:0] t2_doutB_wire [0:NUMRUPT-1];
genvar t2p_int;
generate if (1) begin: t2_loop
  for (t2p_int=0; t2p_int<NUMRUPT-1; t2p_int=t2p_int+1) begin: wr_loop
    assign t2_writeA_wire[t2p_int] = t2_writeA >> t2p_int;
    assign t2_addrA_wire[t2p_int] = t2_addrA >> (t2p_int*BITSROW);
    assign t2_dinA_wire[t2p_int] = t2_dinA >> (t2p_int*BITMAPT);
  end
  for (t2p_int=0; t2p_int<NUMRUPT; t2p_int=t2p_int+1) begin: rd_loop
    assign t2_readB_wire[t2p_int] = t2_readB >> t2p_int;
    assign t2_addrB_wire[t2p_int] = t2_addrB >> (t2p_int*BITSROW);
    assign t2_doutB_wire[t2p_int] = t2_doutB >> (t2p_int*BITMAPT); 
  end
end
endgenerate

reg [NUMPBNK-1:0] pmeminv;
reg [MEMWDTH-1:0] pmem [0:NUMPBNK-1];
integer pmem_int;
always @(posedge clk)
  for (pmem_int=0; pmem_int<NUMPBNK; pmem_int=pmem_int+1)
    if (rst) begin
      pmeminv[pmem_int] <= 0;
      pmem[pmem_int] <= 0;
    end else if (t1_writeA_wire[pmem_int][0] && (t1_addrA_wire[pmem_int][0] == select_srow)) begin
      pmeminv[pmem_int] <= 1'b0;
      pmem[pmem_int] <= t1_dinA_wire[pmem_int][0];
    end

reg [BITMAPT-1:0] rststate;
integer rst_int;
always_comb begin
  rststate = 0;
  for (rst_int=0; rst_int<NUMPBNK; rst_int=rst_int+1)
    rststate = rststate | (rst_int << (rst_int*BITPBNK));
end

reg [BITMAPT-1:0] smem;
integer smem_int;
always @(posedge clk)
  if (rst)
    smem <= rststate;
  else for (smem_int=0; smem_int<NUMRUPT-1; smem_int=smem_int+1)
    if (t2_writeA_wire[smem_int] && (t2_addrA_wire[smem_int] == select_srow))
      smem <= t2_dinA_wire[smem_int];

wire [BITPBNK-1:0] smem_sel_wire = smem >> (select_bank*BITPBNK);
wire [WIDTH-1:0] pmem_wire = pmem[smem_sel_wire] >> (select_word*WIDTH);

genvar pdout_int, pdoutr_int;
generate
  for (pdout_int=0; pdout_int<NUMPBNK; pdout_int=pdout_int+1) begin: pdout_loop
    for (pdoutr_int=0; pdoutr_int<NUMRUPT; pdoutr_int=pdoutr_int+1) begin: pdoutr_loop
      assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire[pdout_int][pdoutr_int] && (t1_addrB_wire[pdout_int][pdoutr_int] == select_srow)) |-> ##DRAM_DELAY
  				         ($past(pmeminv[pdout_int],DRAM_DELAY) ||
                                          (t1_doutB_wire[pdout_int][pdoutr_int] == $past(pmem[pdout_int],DRAM_DELAY))));
    end
  end
endgenerate

genvar sdout_int, sdoutm_int;
generate
  for (sdout_int=0; sdout_int<NUMRUPT; sdout_int=sdout_int+1) begin: sdout_loop
    wire [BITMAPT-1:0] sdout_wire = t2_doutB >> (sdout_int*BITMAPT);
    assert_sdout_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[sdout_int] && (t2_addrB_wire[sdout_int] == select_srow)) |-> ##SRAM_DELAY
                                         (sdout_wire == $past(smem,SRAM_DELAY)));
//    for (sdoutm_int=0; sdoutm_int<NUMVBNK; sdoutm_int=sdoutm_int+1) begin: sdoutm_loop
//      wire [BITPBNK-1:0] sdout_wire = t2_doutB_wire[sdout_int] >> (sdoutm_int*BITPBNK);
//      assert_sdout_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[sdout_int] && (t2_addrB_wire[sdout_int] == select_srow)) |-> ##SRAM_DELAY
//                                           ((sdoutm_int==select_bank) ? (sdout_wire == $past(smem_sel_wire,SRAM_DELAY)) : (sdout_wire != $past(smem_sel_wire,SRAM_DELAY))));
//    end
  end
endgenerate

genvar pfwd_int;
generate
  for (pfwd_int=0; pfwd_int<NUMRUPT; pfwd_int=pfwd_int+1) begin: pfwd_loop
    assert_pdout_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[pfwd_int] && (core.vbadr_wire[pfwd_int] == select_bank) && (core.vradr_wire[pfwd_int] == select_srow)) |-> ##(SRAM_DELAY+DRAM_DELAY)
                                             (pmeminv[smem_sel_wire] || (core.vdout_fwrd[pfwd_int] == pmem[smem_sel_wire])));
  end
endgenerate
 
genvar sfwd_int, sfwdm_int;
generate
  for (sfwd_int=0; sfwd_int<NUMRUPT; sfwd_int=sfwd_int+1) begin: rfwd_loop
    assert_rmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[sfwd_int] && (core.vradr_wire[sfwd_int] == select_srow)) |-> ##SRAM_DELAY
                                            (core.rmap_out[sfwd_int] == smem));
//    for (sfwdm_int=0; sfwdm_int<NUMVBNK; sfwdm_int=sfwdm_int+1) begin: fwdm_loop
//      wire [BITPBNK-1:0] map_wire = core.rmap_bus >> (sfwd_int*BITMAPT+sfwdm_int*BITPBNK);
//      assert_rmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[sfwd_int] && (core.vradr_wire[sfwd_int] == select_srow)) |-> ##SRAM_DELAY
//                                              ((sfwdm_int==select_bank) ? (map_wire == smem_sel_wire) : (map_wire != smem_sel_wire)));
//    end
  end
  for (sfwd_int=0; sfwd_int<NUMRUPT; sfwd_int=sfwd_int+1) begin: wfwd_loop
    assert_wmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[sfwd_int] && (core.vradr_wire[sfwd_int] == select_srow)) |-> ##(SRAM_DELAY+DRAM_DELAY)
                                            (core.wmap_out[sfwd_int] == smem));
//    for (sfwdm_int=0; sfwdm_int<NUMVBNK; sfwdm_int=sfwdm_int+1) begin: fwdm_loop
//      wire [BITPBNK-1:0] map_wire = core.wmap_out[sfwd_int] >> (sfwdm_int*BITPBNK);
//      assert_wmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[sfwd_int] && (core.vradr_wire[sfwd_int] == select_srow)) |-> ##(SRAM_DELAY+DRAM_DELAY)
//                                              ((sfwdm_int==select_bank) ? (map_wire == smem_sel_wire) : (map_wire != smem_sel_wire)));
//    end
  end
endgenerate

reg [BITADDR-1:0] addr_reg [0:NUMRUPT-1][0:SRAM_DELAY+DRAM_DELAY-1];
reg ready_reg [0:SRAM_DELAY+DRAM_DELAY-1];
integer adrd_int, adrp_int;
always @(posedge clk)
  for (adrd_int=0; adrd_int<SRAM_DELAY+DRAM_DELAY; adrd_int=adrd_int+1)
    if (adrd_int>0) begin
      ready_reg[adrd_int] <= ready_reg[adrd_int-1];
      for (adrp_int=0; adrp_int<NUMRUPT; adrp_int=adrp_int+1)
        addr_reg[adrp_int][adrd_int] <= addr_reg[adrp_int][adrd_int-1];
    end else begin
      ready_reg[adrd_int] <= ready;
      for (adrp_int=0; adrp_int<NUMRUPT; adrp_int=adrp_int+1)
        addr_reg[adrp_int][adrd_int] <= addr_wire[adrp_int];
    end

reg fakememinv;
reg [WIDTH-1:0] fakemem;
integer fake_int;
always @(posedge clk)
  if (!ready_reg[SRAM_DELAY+DRAM_DELAY-1])
    fakememinv <= 1'b1;
  else for (fake_int=0; fake_int<NUMRUPT; fake_int=fake_int+1)
    if (write_wire[fake_int] && (addr_reg[fake_int][SRAM_DELAY+DRAM_DELAY-1] == select_addr)) begin
      fakememinv <= 1'b0;
      fakemem <= din_wire[fake_int];
    end

generate if (FLOPPWR) begin: pwrflp_loop
  assert_fakemem_check: assert property (@(posedge clk) disable iff (rst || !ready) 1'b1 |-> ##(FLOPPWR)
				         ($past(fakememinv,FLOPPWR) || ($past(fakemem,FLOPPWR) == pmem[$past(smem_sel_wire)])));
end else begin: npwrflp_loop
  assert_fakemem_check: assert property (@(posedge clk) disable iff (rst || !ready) 1'b1 |->
				         (fakememinv || (fakemem == pmem_wire)));
end
endgenerate

genvar dout_int;
generate for (dout_int=0; dout_int<NUMRUPT; dout_int=dout_int+1) begin: dout_loop
  assert_dout_check: assert property (@(posedge clk) disable iff (!ready) (read_wire[dout_int] && (addr_wire[dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
                                      (rd_vld_wire[dout_int] && (fakememinv || (rd_dout_wire[dout_int] == fakemem))));
  assert_derr_check: assert property (@(posedge clk) disable iff (!ready) (!ENAPAR && !ENAECC && read_wire[dout_int] && (addr_wire[dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 0)  &&
                                       (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrB_wire[0][dout_int])  : t1_serrB_wire[0][dout_int])) && 
                                       (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrB_wire[0][dout_int])  : t1_derrB_wire[0][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 1)  &&
                                       (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrB_wire[1][dout_int])  : t1_serrB_wire[1][dout_int])) && 
                                       (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrB_wire[1][dout_int])  : t1_derrB_wire[1][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 2)  &&
                                       (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrB_wire[2][dout_int])  : t1_serrB_wire[2][dout_int])) && 
                                       (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrB_wire[2][dout_int])  : t1_derrB_wire[2][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 3)  &&
                                       (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrB_wire[3][dout_int])  : t1_serrB_wire[3][dout_int])) && 
                                       (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrB_wire[3][dout_int])  : t1_derrB_wire[3][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 4)  &&
                                       (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrB_wire[4][dout_int])  : t1_serrB_wire[4][dout_int])) && 
                                       (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrB_wire[4][dout_int])  : t1_derrB_wire[4][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 5)  &&
                                       (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrB_wire[5][dout_int])  : t1_serrB_wire[5][dout_int])) && 
                                       (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrB_wire[5][dout_int])  : t1_derrB_wire[5][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 6)  &&
                                       (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrB_wire[6][dout_int])  : t1_serrB_wire[6][dout_int])) && 
                                       (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrB_wire[6][dout_int])  : t1_derrB_wire[6][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 7)  &&
                                       (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrB_wire[7][dout_int])  : t1_serrB_wire[7][dout_int])) && 
                                       (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrB_wire[7][dout_int])  : t1_derrB_wire[7][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 8)  &&
                                       (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrB_wire[8][dout_int])  : t1_serrB_wire[8][dout_int])) && 
                                       (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrB_wire[8][dout_int])  : t1_derrB_wire[8][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 9)  &&
                                       (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrB_wire[9][dout_int])  : t1_serrB_wire[9][dout_int])) && 
                                       (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrB_wire[9][dout_int])  : t1_derrB_wire[9][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 10) &&
                                       (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrB_wire[10][dout_int]) : t1_serrB_wire[10][dout_int])) && 
                                       (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrB_wire[10][dout_int]) : t1_derrB_wire[10][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 11) &&
                                       (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrB_wire[11][dout_int]) : t1_serrB_wire[11][dout_int])) && 
                                       (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrB_wire[11][dout_int]) : t1_derrB_wire[11][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 12) &&
                                       (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrB_wire[12][dout_int]) : t1_serrB_wire[12][dout_int])) && 
                                       (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrB_wire[12][dout_int]) : t1_derrB_wire[12][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 13) &&
                                       (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrB_wire[13][dout_int]) : t1_serrB_wire[13][dout_int])) && 
                                       (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrB_wire[13][dout_int]) : t1_derrB_wire[13][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 14) &&
                                       (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrB_wire[14][dout_int]) : t1_serrB_wire[14][dout_int])) && 
                                       (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrB_wire[14][dout_int]) : t1_derrB_wire[14][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 15) &&
                                       (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrB_wire[15][dout_int]) : t1_serrB_wire[15][dout_int])) && 
                                       (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrB_wire[15][dout_int]) : t1_derrB_wire[15][dout_int]))));
//                                      ((rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrB_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int]) : t1_serrB_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int])) &&
//                                       (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrB_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int]) : t1_derrB_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int]))));
  assert_padr_check: assert property (@(posedge clk) disable iff (!ready) (read_wire[dout_int] && (addr_wire[dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 0)  &&
                                       (rd_padr_wire[dout_int] == ((0 << (BITPADR-BITPBNK)) | {select_word,
                                                                   (FLOPOUT ? $past(t1_padrB_wire[0][dout_int])  : t1_padrB_wire[0][dout_int])}))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 1)  &&
                                       (rd_padr_wire[dout_int] == ((1 << (BITPADR-BITPBNK)) | {select_word,
                                                                   (FLOPOUT ? $past(t1_padrB_wire[1][dout_int])  : t1_padrB_wire[1][dout_int])}))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 2)  &&
                                       (rd_padr_wire[dout_int] == ((2 << (BITPADR-BITPBNK)) | {select_word,
                                                                   (FLOPOUT ? $past(t1_padrB_wire[2][dout_int])  : t1_padrB_wire[2][dout_int])}))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 3)  &&
                                       (rd_padr_wire[dout_int] == ((3 << (BITPADR-BITPBNK)) | {select_word,
                                                                   (FLOPOUT ? $past(t1_padrB_wire[3][dout_int])  : t1_padrB_wire[3][dout_int])}))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 4)  &&
                                       (rd_padr_wire[dout_int] == ((4 << (BITPADR-BITPBNK)) | {select_word,
                                                                   (FLOPOUT ? $past(t1_padrB_wire[4][dout_int])  : t1_padrB_wire[4][dout_int])}))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 5)  &&
                                       (rd_padr_wire[dout_int] == ((5 << (BITPADR-BITPBNK)) | {select_word,
                                                                   (FLOPOUT ? $past(t1_padrB_wire[5][dout_int])  : t1_padrB_wire[5][dout_int])}))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 6)  &&
                                       (rd_padr_wire[dout_int] == ((6 << (BITPADR-BITPBNK)) | {select_word,
                                                                   (FLOPOUT ? $past(t1_padrB_wire[6][dout_int])  : t1_padrB_wire[6][dout_int])}))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 7)  &&
                                       (rd_padr_wire[dout_int] == ((7 << (BITPADR-BITPBNK)) | {select_word,
                                                                   (FLOPOUT ? $past(t1_padrB_wire[7][dout_int])  : t1_padrB_wire[7][dout_int])}))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 8)  &&
                                       (rd_padr_wire[dout_int] == ((8 << (BITPADR-BITPBNK)) | {select_word,
                                                                   (FLOPOUT ? $past(t1_padrB_wire[8][dout_int])  : t1_padrB_wire[8][dout_int])}))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 9)  &&
                                       (rd_padr_wire[dout_int] == ((9 << (BITPADR-BITPBNK)) | {select_word,
                                                                   (FLOPOUT ? $past(t1_padrB_wire[9][dout_int])  : t1_padrB_wire[9][dout_int])}))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 10) &&
                                       (rd_padr_wire[dout_int] == ((10 << (BITPADR-BITPBNK)) | {select_word,
                                                                   (FLOPOUT ? $past(t1_padrB_wire[10][dout_int]) : t1_padrB_wire[10][dout_int])}))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 11) &&
                                       (rd_padr_wire[dout_int] == ((11 << (BITPADR-BITPBNK)) | {select_word,
                                                                   (FLOPOUT ? $past(t1_padrB_wire[11][dout_int]) : t1_padrB_wire[11][dout_int])}))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 12) &&
                                       (rd_padr_wire[dout_int] == ((12 << (BITPADR-BITPBNK)) | {select_word,
                                                                   (FLOPOUT ? $past(t1_padrB_wire[12][dout_int]) : t1_padrB_wire[12][dout_int])}))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 13) &&
                                       (rd_padr_wire[dout_int] == ((13 << (BITPADR-BITPBNK)) | {select_word,
                                                                   (FLOPOUT ? $past(t1_padrB_wire[13][dout_int]) : t1_padrB_wire[13][dout_int])}))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 14) &&
                                       (rd_padr_wire[dout_int] == ((14 << (BITPADR-BITPBNK)) | {select_word,
                                                                   (FLOPOUT ? $past(t1_padrB_wire[14][dout_int]) : t1_padrB_wire[14][dout_int])}))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 15) && 
                                       (rd_padr_wire[dout_int] == ((15 << (BITPADR-BITPBNK)) | {select_word,
                                                                   (FLOPOUT ? $past(t1_padrB_wire[15][dout_int]) : t1_padrB_wire[15][dout_int])}))));
//                                      (rd_padr_wire[dout_int] == {$past(smem_sel_wire,DRAM_DELAY+FLOPOUT),(FLOPOUT ? $past(t1_padrB_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int]) : t1_padrB_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int])})));
//  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_int] && (addr_wire[dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
//                                      (&rd_padr || (rd_padr == ((NUMVBNK << (BITPADR-BITPBNK-BITWRDS-1)) | select_srow)) ||
//                                      (rd_padr == {select_bank,(FLOPOUT ? $past(t1_padrA_sel_wire) : t1_padrA_sel_wire)})));
end
endgenerate

endmodule

