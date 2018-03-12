module ip_top_sva_2_mrnw_1r1w_mt2
  #(
parameter     WIDTH   = 32,
parameter     ENAPAR  = 0,
parameter     ENAECC  = 0,
parameter     ECCWDTH = 7,
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
parameter     NUMRDPT = 2,
parameter     NUMWRPT = 2,
parameter     NUMVROW = 256,
parameter     BITVROW = 8,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     NUMPBNK = 11,
parameter     BITPBNK = 4,
parameter     BITMAPT = (BITPBNK+1)*NUMVBNK,
parameter     MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH: WIDTH
   )
(
  input clk,
  input rst,
  input ready,
  input [NUMWRPT-1:0] write,
  input [NUMWRPT*BITADDR-1:0] wr_adr,
  input [NUMWRPT*WIDTH-1:0] din,
  input [NUMRDPT-1:0] read,
  input [NUMRDPT*BITADDR-1:0] rd_adr,
  input [2*NUMRDPT*NUMPBNK-1:0] t1_writeA,
  input [2*NUMRDPT*NUMPBNK*BITVROW-1:0] t1_addrA,
  input [2*NUMRDPT*NUMPBNK*MEMWDTH-1:0] t1_dinA,
  input [2*NUMRDPT*NUMPBNK-1:0] t1_readB,
  input [2*NUMRDPT*NUMPBNK*BITVROW-1:0] t1_addrB,
  input [NUMWRPT-1:0] t2_writeA,
  input [NUMWRPT*BITVROW-1:0] t2_addrA,
  input [(NUMRDPT+NUMWRPT)-1:0] t2_readB,
  input [(NUMRDPT+NUMWRPT)*BITVROW-1:0] t2_addrB
);

genvar prt_int;
generate
  for (prt_int=0; prt_int<NUMRDPT; prt_int=prt_int+1) begin: rd_loop
    wire read_wire = read >> prt_int;
    wire [BITADDR-1:0] rd_adr_wire = rd_adr >> (prt_int*BITADDR);

    assert_rd_range_check: assert property (@(posedge clk) disable iff (!ready) read_wire |-> (rd_adr_wire < NUMADDR));
  end
  for (prt_int=0; prt_int<NUMWRPT; prt_int=prt_int+1) begin: wr_loop
    wire write_wire = write >> prt_int;
    wire [BITADDR-1:0] wr_adr_wire = wr_adr >> (prt_int*BITADDR);

    assert_wr_range_check: assert property (@(posedge clk) disable iff (!ready) write_wire |-> (wr_adr_wire < NUMADDR));
  end
endgenerate

genvar t1r_int, t1b_int;
generate
  for (t1r_int=0; t1r_int<NUMRDPT; t1r_int=t1r_int+1) begin: t1r_loop
    for (t1b_int=0; t1b_int<NUMPBNK; t1b_int=t1b_int+1) begin: t1b_loop
      wire t1_writeA_wire = t1_writeA >> (t1r_int*NUMPBNK+t1b_int);
      wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> ((t1r_int*NUMPBNK+t1b_int)*BITVROW);
      wire [MEMWDTH-1:0] t1_dinA_wire = t1_dinA >> ((t1r_int*NUMPBNK+t1b_int)*MEMWDTH);

      wire t1_readB_wire = t1_readB >> (t1r_int*NUMPBNK+t1b_int);
      wire [BITVROW-1:0] t1_addrB_wire = t1_addrB >> ((t1r_int*NUMPBNK+t1b_int)*BITVROW);

      wire t1_writeA_0_wire = t1_writeA >> t1b_int;
      wire [BITVROW-1:0] t1_addrA_0_wire = t1_addrA >> (t1b_int*BITVROW);
      wire [MEMWDTH-1:0] t1_dinA_0_wire = t1_dinA >> (t1b_int*MEMWDTH);

      assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMVROW));
      assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> (t1_addrB_wire < NUMVROW));
//      assert_t1_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t1_writeA_wire && t1_readB_wire) |-> (t1_addrA_wire != t1_addrB_wire));
      assert_t1_wr_same_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |->
                                                (t1_writeA_0_wire && (t1_addrA_0_wire == t1_addrA_wire) && (t1_dinA_0_wire == t1_dinA_wire)));
    end
  end
endgenerate

genvar t2w_int, t2r_int;
generate
  for (t2w_int=0; t2w_int<NUMWRPT; t2w_int=t2w_int+1) begin: t2w_loop
    wire t2_writeA_wire = t2_writeA >> t2w_int;
    wire [BITVROW-1:0] t2_addrA_wire = t2_addrA >> (t2w_int*BITVROW);
    assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_addrA_wire < NUMVROW));

    for (t2r_int=0; t2r_int<NUMWRPT; t2r_int=t2r_int+1)
      if (t2r_int != t2w_int) begin: t2wp_loop
        wire t2_writeA_wp_wire = t2_writeA >> t2r_int;
        wire [BITVROW-1:0] t2_addrA_wp_wire = t2_addrA >> (t2r_int*BITVROW);
        assert_t2_ww_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t2_writeA_wire && t2_writeA_wp_wire) |-> (t2_addrA_wire != t2_addrA_wp_wire));
      end
  end

  for (t2w_int=0; t2w_int<NUMRDPT+NUMWRPT; t2w_int=t2w_int+1) begin: t2r_loop
    wire t2_readB_wire = t2_readB >> t2w_int;
    wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> (t2w_int*BITVROW);
    assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire |-> (t2_addrB_wire < NUMVROW));
/*
    for (t2r_int=0; t2r_int<NUMWRPT-1; t2r_int=t2r_int+1) begin: t2wp_loop
      wire t2_writeA_wp_wire = t2_writeA >> t2r_int;
      wire [BITVROW-1:0] t2_addrA_wp_wire = t2_addrA >> (t2r_int*BITVROW);
      assert_t2_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire && t2_writeA_wp_wire) |-> (t2_addrB_wire != t2_addrA_wp_wire));
    end
*/
  end
endgenerate

endmodule


module ip_top_sva_mrnw_1r1w_mt2
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     ENAPAR  = 0,
parameter     ENAECC  = 0,
parameter     ECCWDTH = 7,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMRDPT = 1,
parameter     NUMWRPT = 2,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     NUMPBNK = 11,
parameter     BITPBNK = 4,
parameter     BITPADR = 15,
parameter     SRAM_DELAY = 2,
parameter     DRAM_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPWRM = 0,
parameter     FLOPPWR = 0,
parameter     FLOPOUT = 0,
parameter     BITMAPT = (BITPBNK+1)*NUMVBNK,
parameter     MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH: WIDTH
   )
(
  input clk,
  input rst,
  input [NUMWRPT-1:0] write,
  input [NUMWRPT*BITADDR-1:0] wr_adr,
  input [NUMWRPT*WIDTH-1:0] din,
  input [NUMRDPT-1:0] read,
  input [NUMRDPT*BITADDR-1:0] rd_adr,
  input [NUMRDPT-1:0] rd_vld,
  input [NUMRDPT*WIDTH-1:0] rd_dout,
  input [NUMRDPT-1:0] rd_fwrd,
  input [NUMRDPT-1:0] rd_serr,
  input [NUMRDPT-1:0] rd_derr,
  input [NUMRDPT*BITPADR-1:0] rd_padr,
  input [2*NUMRDPT*NUMPBNK-1:0] t1_writeA,
  input [2*NUMRDPT*NUMPBNK*BITVROW-1:0] t1_addrA,
  input [2*NUMRDPT*NUMPBNK*MEMWDTH-1:0] t1_dinA,
  input [2*NUMRDPT*NUMPBNK-1:0] t1_readB,
  input [2*NUMRDPT*NUMPBNK*BITVROW-1:0] t1_addrB,
  input [2*NUMRDPT*NUMPBNK*MEMWDTH-1:0] t1_doutB,
  input [2*NUMRDPT*NUMPBNK-1:0] t1_fwrdB,
  input [2*NUMRDPT*NUMPBNK-1:0] t1_serrB,
  input [2*NUMRDPT*NUMPBNK-1:0] t1_derrB,
  input [2*NUMRDPT*NUMPBNK*(BITPADR-BITPBNK)-1:0] t1_padrB,
  input [NUMWRPT-1:0] t2_writeA,
  input [NUMWRPT*BITVROW-1:0] t2_addrA,
  input [NUMWRPT*BITMAPT-1:0] t2_dinA,
  input [(NUMRDPT+NUMWRPT)-1:0] t2_readB,
  input [(NUMRDPT+NUMWRPT)*BITVROW-1:0] t2_addrB,
  input [(NUMRDPT+NUMWRPT)*BITMAPT-1:0] t2_doutB,
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
reg read_wire [0:NUMRDPT-1];
reg [BITADDR-1:0] rd_adr_wire [0:NUMRDPT-1];
reg rd_vld_wire [0:NUMRDPT-1];
reg [WIDTH-1:0] rd_dout_wire [0:NUMRDPT-1];
reg rd_fwrd_wire [0:NUMRDPT-1];
reg rd_serr_wire [0:NUMRDPT-1];
reg rd_derr_wire [0:NUMRDPT-1];
reg [BITPADR-1:0] rd_padr_wire [0:NUMRDPT-1];
integer prt_int;
always_comb begin
  for (prt_int=0; prt_int<NUMWRPT; prt_int=prt_int+1) begin
    write_wire[prt_int] = write >> prt_int;
    wr_adr_wire[prt_int] = wr_adr >> (prt_int*BITADDR);
    din_wire[prt_int] = din >> (prt_int*WIDTH);
  end
  for (prt_int=0; prt_int<NUMRDPT; prt_int=prt_int+1) begin
    read_wire[prt_int] = read >> prt_int;
    rd_adr_wire[prt_int] = rd_adr >> (prt_int*BITADDR);
    rd_vld_wire[prt_int] = rd_vld >> prt_int;
    rd_dout_wire[prt_int] = rd_dout >> (prt_int*WIDTH);
    rd_fwrd_wire[prt_int] = rd_fwrd >> prt_int;
    rd_serr_wire[prt_int] = rd_serr >> prt_int;
    rd_derr_wire[prt_int] = rd_derr >> prt_int;
    rd_padr_wire[prt_int] = rd_padr >> (prt_int*BITPADR);
  end
end

wire t1_writeA_wire [0:NUMPBNK-1][0:2*NUMRDPT-1];
wire [BITVROW-1:0] t1_addrA_wire [0:NUMPBNK-1][0:2*NUMRDPT-1];
wire [MEMWDTH-1:0] t1_dinA_wire [0:NUMPBNK-1][0:2*NUMRDPT-1];
wire t1_readB_wire [0:NUMPBNK-1][0:2*NUMRDPT-1];
wire [BITVROW-1:0] t1_addrB_wire [0:NUMPBNK-1][0:2*NUMRDPT-1];
wire [MEMWDTH-1:0] t1_doutB_wire [0:NUMPBNK-1][0:2*NUMRDPT-1];
wire t1_fwrdB_wire [0:16-1][0:2*NUMRDPT-1];
wire t1_serrB_wire [0:16-1][0:2*NUMRDPT-1];
wire t1_derrB_wire [0:16-1][0:2*NUMRDPT-1];
wire [BITPADR-BITPBNK-1:0] t1_padrB_wire [0:16-1][0:2*NUMRDPT-1];
genvar t1b_int, t1r_int;
generate
  for (t1b_int=0; t1b_int<NUMPBNK; t1b_int=t1b_int+1) begin: t1b_loop
    for (t1r_int=0; t1r_int<2*NUMRDPT; t1r_int=t1r_int+1) begin: t1r_loop
      assign t1_writeA_wire[t1b_int][t1r_int] = t1_writeA >> (NUMPBNK*t1r_int+t1b_int);
      assign t1_addrA_wire[t1b_int][t1r_int] = t1_addrA >> ((NUMPBNK*t1r_int+t1b_int)*BITVROW);
      assign t1_dinA_wire[t1b_int][t1r_int] = t1_dinA >> ((NUMPBNK*t1r_int+t1b_int)*MEMWDTH);
      assign t1_readB_wire[t1b_int][t1r_int] = t1_readB >> (NUMPBNK*t1r_int+t1b_int);
      assign t1_addrB_wire[t1b_int][t1r_int] = t1_addrB >> ((NUMPBNK*t1r_int+t1b_int)*BITVROW);
      assign t1_doutB_wire[t1b_int][t1r_int] = t1_doutB >> ((NUMPBNK*t1r_int+t1b_int)*MEMWDTH);
      assign t1_fwrdB_wire[t1b_int][t1r_int] = t1_fwrdB >> (NUMPBNK*t1r_int+t1b_int);
      assign t1_serrB_wire[t1b_int][t1r_int] = t1_serrB >> (NUMPBNK*t1r_int+t1b_int);
      assign t1_derrB_wire[t1b_int][t1r_int] = t1_derrB >> (NUMPBNK*t1r_int+t1b_int);
      assign t1_padrB_wire[t1b_int][t1r_int] = t1_padrB >> ((NUMPBNK*t1r_int+t1b_int)*(BITPADR-BITPBNK));
    end
  end
endgenerate

wire t2_writeA_wire [0:NUMWRPT-1];
wire [BITVROW-1:0] t2_addrA_wire [0:NUMWRPT-1];
wire [BITMAPT-1:0] t2_dinA_wire [0:NUMWRPT-1];
wire t2_readB_wire [0:NUMRDPT+NUMWRPT-1];
wire [BITVROW-1:0] t2_addrB_wire [0:NUMRDPT+NUMWRPT-1];
wire [BITMAPT-1:0] t2_doutB_wire [0:NUMRDPT+NUMWRPT-1];
genvar t2p_int;
generate if (1) begin: t2_loop
  for (t2p_int=0; t2p_int<NUMWRPT; t2p_int=t2p_int+1) begin: wr_loop
    assign t2_writeA_wire[t2p_int] = t2_writeA >> t2p_int;
    assign t2_addrA_wire[t2p_int] = t2_addrA >> (t2p_int*BITVROW);
    assign t2_dinA_wire[t2p_int] = t2_dinA >> (t2p_int*BITMAPT);
  end
  for (t2p_int=0; t2p_int<NUMRDPT+NUMWRPT; t2p_int=t2p_int+1) begin: rd_loop
    assign t2_readB_wire[t2p_int] = t2_readB >> t2p_int;
    assign t2_addrB_wire[t2p_int] = t2_addrB >> (t2p_int*BITVROW);
    assign t2_doutB_wire[t2p_int] = t2_doutB >> (t2p_int*BITMAPT); 
  end
end
endgenerate

reg [NUMPBNK-1:0] pmeminv;
reg [NUMPBNK-1:0] pmem;
integer pmem_int;
always @(posedge clk)
  if (rst)
    pmeminv <= ~0;
  else for (pmem_int=0; pmem_int<NUMPBNK; pmem_int=pmem_int+1)
    if (t1_writeA_wire[pmem_int][0] && (t1_addrA_wire[pmem_int][0] == select_row)) begin
      pmeminv[pmem_int] <= 1'b0;
      pmem[pmem_int] <= t1_dinA_wire[pmem_int][0] >> select_bit;
    end

reg [BITMAPT-1:0] rststate;
integer rst_int;
always_comb begin
  rststate = 0;
  for (rst_int=0; rst_int<NUMPBNK; rst_int=rst_int+1)
    rststate = rststate | ({rst_int,1'b0} << (rst_int*(BITPBNK+1)));
end

reg [BITMAPT-1:0] smem;
integer smem_int;
always @(posedge clk)
  if (rst)
    smem <= rststate;
  else for (smem_int=0; smem_int<NUMWRPT; smem_int=smem_int+1)
    if (t2_writeA_wire[smem_int] && (t2_addrA_wire[smem_int] == select_row))
      smem <= t2_dinA_wire[smem_int];

wire [BITPBNK:0] smem_sel_wire = smem >> (select_bank*(BITPBNK+1));

genvar pdout_int, pdoutr_int;
generate
  for (pdout_int=0; pdout_int<NUMPBNK; pdout_int=pdout_int+1) begin: pdout_loop
    for (pdoutr_int=0; pdoutr_int<NUMRDPT; pdoutr_int=pdoutr_int+1) begin: pdoutr_loop
      assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire[pdout_int][pdoutr_int] && (t1_addrB_wire[pdout_int][pdoutr_int] == select_row)) |-> ##DRAM_DELAY
  				         ($past(pmeminv[pdout_int],DRAM_DELAY) || (t1_doutB_wire[pdout_int][pdoutr_int][select_bit] == $past(pmem[pdout_int],DRAM_DELAY))));
    end
  end
endgenerate

genvar sdout_int, sdoutm_int;
generate
  for (sdout_int=0; sdout_int<NUMRDPT+NUMWRPT; sdout_int=sdout_int+1) begin: sdout_loop
//    for (sdoutm_int=0; sdoutm_int<NUMVBNK; sdoutm_int=sdoutm_int+1) begin: sdoutm_loop
//      wire [BITPBNK-1:0] sdout_wire = t2_doutB_wire[sdout_int] >> (sdoutm_int*BITPBNK);
      assert_sdout_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[sdout_int] && (t2_addrB_wire[sdout_int] == select_row)) |-> ##SRAM_DELAY
                                           (t2_doutB_wire[sdout_int] == $past(smem,SRAM_DELAY)));
//                                           ((sdoutm_int==select_bank) ? (sdout_wire == $past(smem_sel_wire,SRAM_DELAY)) : (sdout_wire != $past(smem_sel_wire,SRAM_DELAY))));
//    end
  end
endgenerate
 
genvar fwd_int, fwdm_int;
generate
  for (fwd_int=0; fwd_int<NUMRDPT; fwd_int=fwd_int+1) begin: rfwd_loop
//    for (fwdm_int=0; fwdm_int<NUMVBNK; fwdm_int=fwdm_int+1) begin: fwdm_loop
//      wire [BITPBNK-1:0] map_wire = core.map_out[fwd_int+NUMWRPT] >> (fwdm_int*BITPBNK);
      assert_rmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[fwd_int] && (core.vrdradr_wire[fwd_int] == select_row)) |-> ##SRAM_DELAY
                                              (core.map_out[fwd_int+NUMWRPT] == smem));
//                                              ((fwdm_int==select_bank) ? (map_wire == smem_sel_wire) : (map_wire != smem_sel_wire)));
//    end
  end
  for (fwd_int=0; fwd_int<NUMWRPT; fwd_int=fwd_int+1) begin: wfwd_loop
//    for (fwdm_int=0; fwdm_int<NUMVBNK; fwdm_int=fwdm_int+1) begin: fwdm_loop
//      wire [BITPBNK-1:0] map_wire = core.map_out[fwd_int] >> (fwdm_int*BITPBNK);
      assert_wmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[fwd_int] && (core.vwrradr_wire[fwd_int] == select_row)) |-> ##(SRAM_DELAY+FLOPWRM)
                                              (core.map_out[fwd_int] == smem));
//                                              ((fwdm_int==select_bank) ? (map_wire == smem_sel_wire) : (map_wire != smem_sel_wire)));
//    end
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
/*
generate if (FLOPPWR) begin: pwrflp_loop
  assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##(SRAM_DELAY+FLOPPWR+FLOPWRM)
				         ($past(fakememinv,SRAM_DELAY+FLOPPWR+FLOPWRM) ||
                                          ($past(fakemem,SRAM_DELAY+FLOPPWR+FLOPWRM) == pmem[$past(smem_sel_wire)])));
end else begin: npwrflp_loop
  assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##(SRAM_DELAY+FLOPPWR+FLOPWRM)
				         ($past(fakememinv,SRAM_DELAY+FLOPPWR+FLOPWRM) ||
                                          ($past(fakemem,SRAM_DELAY+FLOPPWR+FLOPWRM) == pmem[smem_sel_wire])));
end
endgenerate
*/

genvar dout_int;
generate for (dout_int=0; dout_int<NUMRDPT; dout_int=dout_int+1) begin: dout_loop
  assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_int] && (rd_adr_wire[dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
                                      (rd_vld_wire[dout_int] && ($past(fakememinv,FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT) ||
                                                                 (rd_dout_wire[dout_int][select_bit] == $past(fakemem,FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)))));
/*
  assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_int] && (rd_adr_wire[dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
                                      (rd_fwrd_wire[dout_int] == $past(core.forward_read[dout_int],DRAM_DELAY+FLOPOUT)) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 0)  &&
                                       (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdB_wire[0][dout_int])  : t1_fwrdB_wire[0][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 1)  &&
                                       (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdB_wire[1][dout_int])  : t1_fwrdB_wire[1][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 2)  &&
                                       (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdB_wire[2][dout_int])  : t1_fwrdB_wire[2][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 3)  &&
                                       (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdB_wire[3][dout_int])  : t1_fwrdB_wire[3][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 4)  &&
                                       (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdB_wire[4][dout_int])  : t1_fwrdB_wire[4][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 5)  &&
                                       (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdB_wire[5][dout_int])  : t1_fwrdB_wire[5][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 6)  &&
                                       (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdB_wire[6][dout_int])  : t1_fwrdB_wire[6][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 7)  &&
                                       (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdB_wire[7][dout_int])  : t1_fwrdB_wire[7][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 8)  &&
                                       (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdB_wire[8][dout_int])  : t1_fwrdB_wire[8][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 9)  &&
                                       (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdB_wire[9][dout_int])  : t1_fwrdB_wire[9][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 10) &&
                                       (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdB_wire[10][dout_int]) : t1_fwrdB_wire[10][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 11) &&
                                       (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdB_wire[11][dout_int]) : t1_fwrdB_wire[11][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 12) &&
                                       (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdB_wire[12][dout_int]) : t1_fwrdB_wire[12][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 13) &&
                                       (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdB_wire[13][dout_int]) : t1_fwrdB_wire[13][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 14) &&
                                       (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdB_wire[14][dout_int]) : t1_fwrdB_wire[14][dout_int]))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 15) &&
                                       (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdB_wire[15][dout_int]) : t1_fwrdB_wire[15][dout_int]))));
*/
//                                       (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdB_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int]) : t1_fwrdB_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int]))));
/*
  assert_derr_check: assert property (@(posedge clk) disable iff (rst) (!ENAPAR && !ENAECC && read_wire[dout_int] && (rd_adr_wire[dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
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
*/
//                                      ((rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrB_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int]) : t1_serrB_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int])) &&
//                                       (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrB_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int]) : t1_derrB_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int]))));
/*
  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_int] && (rd_adr_wire[dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
                                      ((rd_padr_wire[dout_int] == ((NUMVBNK << (BITPADR-BITPBNK)) | select_row)) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 0)  &&
                                       (rd_padr_wire[dout_int] == ((0 << (BITPADR-BITPBNK)) |
                                                                   (FLOPOUT ? $past(t1_padrB_wire[0][dout_int])  : t1_padrB_wire[0][dout_int])))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 1)  &&
                                       (rd_padr_wire[dout_int] == ((1 << (BITPADR-BITPBNK)) |
                                                                   (FLOPOUT ? $past(t1_padrB_wire[1][dout_int])  : t1_padrB_wire[1][dout_int])))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 2)  &&
                                       (rd_padr_wire[dout_int] == ((2 << (BITPADR-BITPBNK)) |
                                                                   (FLOPOUT ? $past(t1_padrB_wire[2][dout_int])  : t1_padrB_wire[2][dout_int])))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 3)  &&
                                       (rd_padr_wire[dout_int] == ((3 << (BITPADR-BITPBNK)) |
                                                                   (FLOPOUT ? $past(t1_padrB_wire[3][dout_int])  : t1_padrB_wire[3][dout_int])))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 4)  &&
                                       (rd_padr_wire[dout_int] == ((4 << (BITPADR-BITPBNK)) |
                                                                   (FLOPOUT ? $past(t1_padrB_wire[4][dout_int])  : t1_padrB_wire[4][dout_int])))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 5)  &&
                                       (rd_padr_wire[dout_int] == ((5 << (BITPADR-BITPBNK)) |
                                                                   (FLOPOUT ? $past(t1_padrB_wire[5][dout_int])  : t1_padrB_wire[5][dout_int])))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 6)  &&
                                       (rd_padr_wire[dout_int] == ((6 << (BITPADR-BITPBNK)) |
                                                                   (FLOPOUT ? $past(t1_padrB_wire[6][dout_int])  : t1_padrB_wire[6][dout_int])))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 7)  &&
                                       (rd_padr_wire[dout_int] == ((7 << (BITPADR-BITPBNK)) |
                                                                   (FLOPOUT ? $past(t1_padrB_wire[7][dout_int])  : t1_padrB_wire[7][dout_int])))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 8)  &&
                                       (rd_padr_wire[dout_int] == ((8 << (BITPADR-BITPBNK)) |
                                                                   (FLOPOUT ? $past(t1_padrB_wire[8][dout_int])  : t1_padrB_wire[8][dout_int])))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 9)  &&
                                       (rd_padr_wire[dout_int] == ((9 << (BITPADR-BITPBNK)) |
                                                                   (FLOPOUT ? $past(t1_padrB_wire[9][dout_int])  : t1_padrB_wire[9][dout_int])))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 10) &&
                                       (rd_padr_wire[dout_int] == ((10 << (BITPADR-BITPBNK)) |
                                                                   (FLOPOUT ? $past(t1_padrB_wire[10][dout_int]) : t1_padrB_wire[10][dout_int])))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 11) &&
                                       (rd_padr_wire[dout_int] == ((11 << (BITPADR-BITPBNK)) |
                                                                   (FLOPOUT ? $past(t1_padrB_wire[11][dout_int]) : t1_padrB_wire[11][dout_int])))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 12) &&
                                       (rd_padr_wire[dout_int] == ((12 << (BITPADR-BITPBNK)) |
                                                                   (FLOPOUT ? $past(t1_padrB_wire[12][dout_int]) : t1_padrB_wire[12][dout_int])))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 13) &&
                                       (rd_padr_wire[dout_int] == ((13 << (BITPADR-BITPBNK)) |
                                                                   (FLOPOUT ? $past(t1_padrB_wire[13][dout_int]) : t1_padrB_wire[13][dout_int])))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 14) &&
                                       (rd_padr_wire[dout_int] == ((14 << (BITPADR-BITPBNK)) |
                                                                   (FLOPOUT ? $past(t1_padrB_wire[14][dout_int]) : t1_padrB_wire[14][dout_int])))) ||
                                      (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 15) &&
                                       (rd_padr_wire[dout_int] == ((15 << (BITPADR-BITPBNK)) |
                                                                   (FLOPOUT ? $past(t1_padrB_wire[15][dout_int]) : t1_padrB_wire[15][dout_int]))))));
*/
//                                      (rd_padr_wire[dout_int] == {$past(smem_sel_wire,DRAM_DELAY+FLOPOUT),(FLOPOUT ? $past(t1_padrB_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int]) : t1_padrB_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int])})));
//  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_int] && (addr_wire[dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
//                                      (&rd_padr || (rd_padr == ((NUMVBNK << (BITPADR-BITPBNK-1)) | select_row)) ||
//                                      (rd_padr == {select_bank,(FLOPOUT ? $past(t1_padrA_sel_wire) : t1_padrA_sel_wire)})));
end
endgenerate

endmodule

