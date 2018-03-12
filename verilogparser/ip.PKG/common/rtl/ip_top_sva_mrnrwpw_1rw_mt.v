module ip_top_sva_2_mrnrwpw_1rw_mt
  #(parameter
     WIDTH   = 32,
     NUMADDR = 8192,
     BITADDR = 13,
     NUMRDPT = 1,
     NUMRWPT = 1,
     NUMWRPT = 2,
     NUMVBNK = 8,
     BITVBNK = 3,
     NUMPBNK = 11,
     BITPBNK = 4,
     NUMVROW = 1024,
     BITVROW = 10,
     ECCBITS = 8,
     BITMAPT = BITPBNK*NUMPBNK,
     SDOUT_WIDTH = 2*BITMAPT+ECCBITS
   )
(
  input clk,
  input rst,
  input ready,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] read,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] write,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*BITADDR-1:0] addr,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] din,
  input [(NUMRDPT+NUMRWPT)*NUMPBNK-1:0] t1_readA,
  input [(NUMRDPT+NUMRWPT)*NUMPBNK-1:0] t1_writeA,
  input [(NUMRDPT+NUMRWPT)*NUMPBNK*BITVROW-1:0] t1_addrA,
  input [(NUMRDPT+NUMRWPT)*NUMPBNK*WIDTH-1:0] t1_dinA,
  input [(NUMRWPT+NUMWRPT-!NUMRDPT)-1:0] t2_writeA,
  input [(NUMRWPT+NUMWRPT-!NUMRDPT)*BITVROW-1:0] t2_addrA,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] t2_addrB
);

genvar prt_int;
generate for (prt_int=0; prt_int<NUMRDPT+NUMRWPT+NUMWRPT; prt_int=prt_int+1) begin: prt_loop
  wire read_wire = (prt_int<NUMRDPT+NUMRWPT) ? read >> prt_int : 1'b0;
  wire write_wire = (prt_int>=NUMRDPT) ? write >> prt_int : 1'b0;
  wire [BITADDR-1:0] addr_wire = addr >> (prt_int*BITADDR);

  assert_rw_1p_check: assert property (@(posedge clk) disable iff (!ready) !(read_wire && write_wire)); 
  assert_rw_range_check: assert property (@(posedge clk) disable iff (!ready) (read_wire || write_wire) |-> (addr_wire < NUMADDR));
end
endgenerate

genvar t1b_int, t1r_int;
generate for (t1b_int=0; t1b_int<NUMPBNK; t1b_int=t1b_int+1) begin: t1b_loop
  for (t1r_int=0; t1r_int<NUMRDPT+NUMRWPT; t1r_int=t1r_int+1) begin: t1r_loop
    wire t1_readA_wire = t1_readA >> ((NUMRDPT+NUMRWPT)*t1b_int+t1r_int);
    wire t1_writeA_wire = t1_writeA >> ((NUMRDPT+NUMRWPT)*t1b_int+t1r_int);
    wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> (((NUMRDPT+NUMRWPT)*t1b_int+t1r_int)*BITVROW);
    wire [WIDTH-1:0] t1_dinA_wire = t1_dinA >> (((NUMRDPT+NUMRWPT)*t1b_int+t1r_int)*WIDTH);

    wire t1_writeA_0_wire = t1_writeA >> ((NUMRDPT+NUMRWPT)*t1b_int);
    wire [BITVROW-1:0] t1_addrA_0_wire = t1_addrA >> ((NUMRDPT+NUMRWPT)*t1b_int*BITVROW);
    wire [WIDTH-1:0] t1_dinA_0_wire = t1_dinA >> ((NUMRDPT+NUMRWPT)*t1b_int*WIDTH);

    assert_t1_1p_check: assert property (@(posedge clk) disable iff (rst) !(t1_readA_wire && t1_writeA_wire));
    assert_t1_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire || t1_writeA_wire) |-> (t1_addrA_wire < NUMVROW));
    assert_t1_wr_same_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |->
                                              (t1_writeA_0_wire && (t1_addrA_0_wire == t1_addrA_wire) && (t1_dinA_0_wire == t1_dinA_wire)));
  end
end
endgenerate

genvar t2w_int, t2r_int;
generate
  for (t2w_int=0; t2w_int<NUMRWPT+NUMWRPT-!NUMRDPT; t2w_int=t2w_int+1) begin: t2w_loop
    wire t2_writeA_wire = t2_writeA >> t2w_int;
    wire [BITVROW-1:0] t2_addrA_wire = t2_addrA >> (t2w_int*BITVROW);
    assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_addrA_wire < NUMVROW));

    for (t2r_int=0; t2r_int<NUMRWPT+NUMWRPT-!NUMRDPT; t2r_int=t2r_int+1)
      if (t2r_int != t2w_int) begin: t2wp_loop
        wire t2_writeA_wp_wire = t2_writeA >> t2r_int;
        wire [BITVROW-1:0] t2_addrA_wp_wire = t2_addrA >> (t2r_int*BITVROW);
        assert_t2_ww_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t2_writeA_wire && t2_writeA_wp_wire) |-> (t2_addrA_wire != t2_addrA_wp_wire));
      end

    for (t2r_int=0; t2r_int<NUMRDPT+NUMRWPT+NUMWRPT; t2r_int=t2r_int+1) begin: t2rp_loop
      wire t2_readB_wire = t2_readB >> t2r_int;
      wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> (t2r_int*BITVROW);
      assert_t2_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t2_writeA_wire && t2_readB_wire) |-> (t2_addrA_wire != t2_addrB_wire));
    end
  end

  for (t2r_int=0; t2r_int<NUMRDPT+NUMRWPT+NUMWRPT; t2r_int=t2r_int+1) begin: t2r_loop
    wire t2_readB_wire = t2_readB >> t2r_int;
    wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> (t2r_int*BITVROW);
    assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire |-> (t2_addrB_wire < NUMVROW));
  end
endgenerate

endmodule


module ip_top_sva_mrnrwpw_1rw_mt
  #(parameter
     WIDTH   = 32,
     BITWDTH = 5,
     NUMADDR = 8192,
     BITADDR = 13,
     NUMRDPT = 1,
     NUMRWPT = 1,
     NUMWRPT = 2,
     NUMVROW = 1024,
     BITVROW = 10,
     NUMVBNK = 8,
     BITVBNK = 3,
     NUMPBNK = 11,
     BITPBNK = 4,
     BITPADR = 14,
     ECCBITS = 8,
     SRAM_DELAY = 2,
     DRAM_DELAY = 2,
     FLOPIN = 0,
     FLOPOUT = 0,
     BITMAPT = BITPBNK*NUMPBNK,
     SDOUT_WIDTH = 2*BITMAPT+ECCBITS
   )
(
  input clk,
  input rst,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] read,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] write,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*BITADDR-1:0] addr,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] din,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] rd_vld,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] rd_dout,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] rd_fwrd,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] rd_serr,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] rd_derr,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR-1:0] rd_padr,
  input [(NUMRDPT+NUMRWPT)*NUMPBNK-1:0] t1_readA,
  input [(NUMRDPT+NUMRWPT)*NUMPBNK-1:0] t1_writeA,
  input [(NUMRDPT+NUMRWPT)*NUMPBNK*BITVROW-1:0] t1_addrA,
  input [(NUMRDPT+NUMRWPT)*NUMPBNK*WIDTH-1:0] t1_dinA,
  input [(NUMRDPT+NUMRWPT)*NUMPBNK*WIDTH-1:0] t1_doutA,
  input [(NUMRDPT+NUMRWPT)*NUMPBNK-1:0] t1_fwrdA,
  input [(NUMRDPT+NUMRWPT)*NUMPBNK-1:0] t1_serrA,
  input [(NUMRDPT+NUMRWPT)*NUMPBNK-1:0] t1_derrA,
  input [(NUMRDPT+NUMRWPT)*NUMPBNK*(BITPADR-BITPBNK)-1:0] t1_padrA,
  input [(NUMRWPT+NUMWRPT-!NUMRDPT)-1:0] t2_writeA,
  input [(NUMRWPT+NUMWRPT-!NUMRDPT)*BITVROW-1:0] t2_addrA,
  input [(NUMRWPT+NUMWRPT-!NUMRDPT)*SDOUT_WIDTH-1:0] t2_dinA,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] t2_addrB,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_doutB,
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

reg read_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg write_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg [BITADDR-1:0] addr_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg [WIDTH-1:0] din_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg rd_vld_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg [WIDTH-1:0] rd_dout_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg rd_fwrd_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg rd_serr_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg rd_derr_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg [BITPADR-1:0] rd_padr_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
integer prt_int;
always_comb
  for (prt_int=0; prt_int<NUMRDPT+NUMRWPT+NUMWRPT; prt_int=prt_int+1) begin
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

assert_rw1_rw2_np2_check: assert property (@(posedge clk) disable iff (rst) ((read_wire[0] || write_wire[0]) && (read_wire[1] || write_wire[1])) |-> ##FLOPIN
				       ((core.vaddr_wire[0] == core.vaddr_wire[1]) == ((core.vbadr_wire[0] == core.vbadr_wire[1]) && (core.vradr_wire[0] == core.vradr_wire[1]))));
assert_rw1_sl_np2_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] || write_wire[0]) |-> ##FLOPIN
					  ((core.vaddr_wire[0] == select_addr) == ((core.vbadr_wire[0] == select_bank) && (core.vradr_wire[0] == select_row)))); 
assert_rw2_sl_np2_check: assert property (@(posedge clk) disable iff (rst) (read_wire[1] || write_wire[1]) |-> ##FLOPIN
					  ((core.vaddr_wire[1] == select_addr) == ((core.vbadr_wire[1] == select_bank) && (core.vradr_wire[1] == select_row)))); 

assert_rw1_np2_range_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] || write_wire[0]) |-> ##FLOPIN
					     ((core.vbadr_wire[0] < NUMVBNK) && (core.vradr_wire[0] < NUMVROW)));
assert_rw2_np2_range_check: assert property (@(posedge clk) disable iff (rst) (read_wire[1] || write_wire[1]) |-> ##FLOPIN
					     ((core.vbadr_wire[1] < NUMVBNK) && (core.vradr_wire[1] < NUMVROW)));
assert_sl_np2_range_check: assert property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR) |->
					    ((select_bank < NUMVBNK) && (select_row < NUMVROW))); 

wire t1_readA_wire [0:NUMPBNK-1][0:NUMRDPT+NUMRWPT-1];
wire t1_writeA_wire [0:NUMPBNK-1][0:NUMRDPT+NUMRWPT-1];
wire [BITVROW-1:0] t1_addrA_wire [0:NUMPBNK-1][0:NUMRDPT+NUMRWPT-1];
wire [WIDTH-1:0] t1_dinA_wire [0:NUMPBNK-1][0:NUMRDPT+NUMRWPT-1];
wire [WIDTH-1:0] t1_doutA_wire [0:NUMPBNK-1][0:NUMRDPT+NUMRWPT-1];
wire t1_fwrdA_wire [0:16-1][0:NUMRDPT+NUMRWPT-1];
wire t1_serrA_wire [0:16-1][0:NUMRDPT+NUMRWPT-1];
wire t1_derrA_wire [0:16-1][0:NUMRDPT+NUMRWPT-1];
wire [BITPADR-BITPBNK-1:0] t1_padrA_wire [0:16-1][0:NUMRDPT+NUMRWPT-1];
genvar t1b_int, t1r_int;
generate for (t1b_int=0; t1b_int<NUMPBNK; t1b_int=t1b_int+1) begin: t1b_loop
  for (t1r_int=0; t1r_int<NUMRDPT+NUMRWPT; t1r_int=t1r_int+1) begin: t1r_loop
    assign t1_readA_wire[t1b_int][t1r_int] = t1_readA >> ((NUMRDPT+NUMRWPT)*t1b_int+t1r_int);
    assign t1_writeA_wire[t1b_int][t1r_int] = t1_writeA >> ((NUMRDPT+NUMRWPT)*t1b_int+t1r_int);
    assign t1_addrA_wire[t1b_int][t1r_int] = t1_addrA >> (((NUMRDPT+NUMRWPT)*t1b_int+t1r_int)*BITVROW);
    assign t1_dinA_wire[t1b_int][t1r_int] = t1_dinA >> (((NUMRDPT+NUMRWPT)*t1b_int+t1r_int)*WIDTH);
    assign t1_doutA_wire[t1b_int][t1r_int] = t1_doutA >> (((NUMRDPT+NUMRWPT)*t1b_int+t1r_int)*WIDTH);
    assign t1_fwrdA_wire[t1b_int][t1r_int] = t1_fwrdA >> ((NUMRDPT+NUMRWPT)*t1b_int+t1r_int);
    assign t1_serrA_wire[t1b_int][t1r_int] = t1_serrA >> ((NUMRDPT+NUMRWPT)*t1b_int+t1r_int);
    assign t1_derrA_wire[t1b_int][t1r_int] = t1_derrA >> ((NUMRDPT+NUMRWPT)*t1b_int+t1r_int);
    assign t1_padrA_wire[t1b_int][t1r_int] = t1_padrA >> (((NUMRDPT+NUMRWPT)*t1b_int+t1r_int)*(BITPADR-BITPBNK));
  end
end
endgenerate

wire t2_writeA_wire [0:NUMRWPT+NUMWRPT-!NUMRDPT-1];
wire [BITVROW-1:0] t2_addrA_wire [0:NUMRWPT+NUMWRPT-!NUMRDPT-1];
wire [SDOUT_WIDTH-1:0] t2_dinA_wire [0:NUMRWPT+NUMWRPT-!NUMRDPT-1];
wire t2_readB_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
wire [BITVROW-1:0] t2_addrB_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
wire [SDOUT_WIDTH-1:0] t2_doutB_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
genvar t2p_int;
generate if (1) begin: t2_loop
  for (t2p_int=0; t2p_int<NUMRWPT+NUMWRPT-!NUMRDPT; t2p_int=t2p_int+1) begin: wr_loop
    assign t2_writeA_wire[t2p_int] = t2_writeA >> t2p_int;
    assign t2_addrA_wire[t2p_int] = t2_addrA >> (t2p_int*BITVROW);
    assign t2_dinA_wire[t2p_int] = t2_dinA >> (t2p_int*SDOUT_WIDTH);
  end
  for (t2p_int=0; t2p_int<NUMRDPT+NUMRWPT+NUMWRPT; t2p_int=t2p_int+1) begin: rd_loop
    assign t2_readB_wire[t2p_int] = t2_readB >> t2p_int;
    assign t2_addrB_wire[t2p_int] = t2_addrB >> (t2p_int*BITVROW);
    assign t2_doutB_wire[t2p_int] = t2_doutB >> (t2p_int*SDOUT_WIDTH); 
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
    rststate = rststate | (rst_int << (rst_int*BITPBNK));
end

wire [ECCBITS-1:0] rststate_ecc;
ecc_calc #(.ECCDWIDTH(BITMAPT), .ECCWIDTH(ECCBITS))
    ecc_calc_rst(.din(rststate), .eccout(rststate_ecc));


reg [SDOUT_WIDTH-1:0] smem;
integer smem_int;
always @(posedge clk)
  if (rst)
    smem <= {rststate,rststate_ecc,rststate};
  else for (smem_int=0; smem_int<NUMRWPT+NUMWRPT-!NUMRDPT; smem_int=smem_int+1)
    if (t2_writeA_wire[smem_int] && (t2_addrA_wire[smem_int] == select_row))
      smem <= t2_dinA_wire[smem_int];

wire [BITPBNK-1:0] smem_sel_wire = smem >> (select_bank*BITPBNK);
wire [ECCBITS-1:0] smem_ecc;
ecc_calc #(.ECCDWIDTH(BITMAPT), .ECCWIDTH(ECCBITS))
    ecc_calc_inst(.din(smem[BITMAPT-1:0]), .eccout(smem_ecc));

wire mem_wire = pmem[smem_sel_wire];

assert_smem_ecc_check: assert property (@(posedge clk) disable iff (rst) (smem == {smem[BITMAPT-1:0],smem_ecc,smem[BITMAPT-1:0]}));

genvar pdout_int, pdoutr_int;
generate for (pdout_int=0; pdout_int<NUMPBNK; pdout_int=pdout_int+1) begin: pdout_loop
  for (pdoutr_int=0; pdoutr_int<NUMRDPT+NUMRWPT; pdoutr_int=pdoutr_int+1) begin: pdoutr_loop
    assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire[pdout_int][pdoutr_int] && (t1_addrA_wire[pdout_int][pdoutr_int] == select_row)) |-> ##DRAM_DELAY
				         ($past(pmeminv[pdout_int],DRAM_DELAY) || (t1_doutA_wire[pdout_int][pdoutr_int][select_bit] == $past(pmem[pdout_int],DRAM_DELAY))));
  end
end
endgenerate

genvar sdout_int;
generate for (sdout_int=0; sdout_int<NUMRDPT+NUMRWPT+NUMWRPT; sdout_int=sdout_int+1) begin: sdout_loop
  assert_sdout_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[sdout_int] && (t2_addrB_wire[sdout_int] == select_row)) |-> ##SRAM_DELAY
                                       (t2_doutB_wire[sdout_int] == $past(smem,SRAM_DELAY)));
  assert_sdout_ecc_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[sdout_int] && (t2_addrB_wire[sdout_int] == select_row)) |-> ##SRAM_DELAY
                                           (core.sdout_out[sdout_int] == $past(smem[BITMAPT-1:0],SRAM_DELAY)));
end
endgenerate
 
genvar state_int;
generate for (state_int=0; state_int<NUMRDPT+NUMRWPT+NUMWRPT; state_int=state_int+1) begin: state_loop
  wire state_serr = 0;
  wire state_derr = 0;
  wire state_nerr = !state_serr && !state_derr;
  assume_state_err_check: assert property (@(posedge clk) disable iff (rst) !(state_serr && state_derr));
  assume_state_serr_check: assert property (@(posedge clk) disable iff (rst) state_serr |-> ##SRAM_DELAY
                                            core.sdo_loop[state_int].sdout_serr && !core.sdo_loop[state_int].sdout_derr);
  assume_state_derr_check: assert property (@(posedge clk) disable iff (rst) state_derr |-> ##SRAM_DELAY
                                            !core.sdo_loop[state_int].sdout_serr && core.sdo_loop[state_int].sdout_derr);
  assume_state_nerr_check: assert property (@(posedge clk) disable iff (rst) state_nerr |-> ##SRAM_DELAY
                                            !core.sdo_loop[state_int].sdout_serr && !core.sdo_loop[state_int].sdout_derr);

  assert_sdout_nerr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[state_int] && (t2_addrB_wire[state_int] == select_row) && state_nerr) |-> ##SRAM_DELAY
                                            !core.sdo_loop[state_int].sdout_ded_err && !core.sdo_loop[state_int].sdout_sec_err &&
                                            (core.sdo_loop[state_int].sdout_dup_data == core.sdo_loop[state_int].sdout_post_ecc));
  assert_sdout_serr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[state_int] && (t2_addrB_wire[state_int] == select_row) && state_serr) |-> ##SRAM_DELAY
                                            !core.sdo_loop[state_int].sdout_ded_err && (core.sdo_loop[state_int].sdout_sec_err ?
                                            (core.sdo_loop[state_int].sdout_dup_data == core.sdo_loop[state_int].sdout_post_ecc) :
                                            (core.sdo_loop[state_int].sdout_dup_data != core.sdo_loop[state_int].sdout_post_ecc)));
  assert_sdout_derr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[state_int] && (t2_addrB_wire[state_int] == select_row) && state_derr) |-> ##SRAM_DELAY
                                            core.sdo_loop[state_int].sdout_ded_err ? !core.sdo_loop[state_int].sdout_sec_err :
                                            core.sdo_loop[state_int].sdout_sec_err ? !core.sdo_loop[state_int].sdout_ded_err &&
                                                                                     (core.sdo_loop[state_int].sdout_dup_data != core.sdo_loop[state_int].sdout_post_ecc) :
                                                                                     (core.sdo_loop[state_int].sdout_dup_data != core.sdo_loop[state_int].sdout_post_ecc));
end
endgenerate

genvar fwd_int;
generate for (fwd_int=0; fwd_int<NUMRDPT+NUMRWPT+NUMWRPT; fwd_int=fwd_int+1) begin: fwd_loop
  assert_map_fwd_check: assert property (@(posedge clk) disable iff (rst) ((core.vread_wire[fwd_int] || core.vwrite_wire[fwd_int]) &&
                                                                           (core.vradr_wire[fwd_int] == select_row)) |-> ##SRAM_DELAY
                                         (core.map_out[fwd_int] == smem[BITMAPT-1:0]));
end
endgenerate

reg fakememinv;
reg fakemem;
integer fake_int;
always @(posedge clk)
  if (rst)
    fakememinv <= 1'b1;
  else for (fake_int=NUMRDPT; fake_int<NUMRDPT+NUMRWPT+NUMRWPT; fake_int=fake_int+1)
    if (write_wire[fake_int] && (addr_wire[fake_int] == select_addr)) begin
      fakememinv <= 1'b0;
      fakemem <= din_wire[fake_int][select_bit];
    end

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##SRAM_DELAY
				       ($past(fakememinv,SRAM_DELAY) || ($past(fakemem,SRAM_DELAY) == mem_wire)));

wire [BITPADR-1:0] rd_padr_wire_0 = rd_padr_wire[0];
wire [BITPADR-BITPBNK-1:0] t1_padrA_wire_0_0 = t1_padrA_wire[0][0];

genvar dout_int;
generate for (dout_int=0; dout_int<NUMRDPT+NUMRWPT; dout_int=dout_int+1) begin: dout_loop
  assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_int] && (addr_wire[dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
                                    (rd_vld_wire[dout_int] && ($past(fakememinv,FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT) ||
                                                               (rd_dout_wire[dout_int][select_bit] == $past(fakemem,FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)))));
  assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_int] && (addr_wire[dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 0)  && (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdA_wire[0][dout_int])  : t1_fwrdA_wire[0][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 1)  && (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdA_wire[1][dout_int])  : t1_fwrdA_wire[1][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 2)  && (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdA_wire[2][dout_int])  : t1_fwrdA_wire[2][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 3)  && (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdA_wire[3][dout_int])  : t1_fwrdA_wire[3][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 4)  && (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdA_wire[4][dout_int])  : t1_fwrdA_wire[4][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 5)  && (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdA_wire[5][dout_int])  : t1_fwrdA_wire[5][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 6)  && (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdA_wire[6][dout_int])  : t1_fwrdA_wire[6][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 7)  && (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdA_wire[7][dout_int])  : t1_fwrdA_wire[7][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 8)  && (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdA_wire[8][dout_int])  : t1_fwrdA_wire[8][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 9)  && (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdA_wire[9][dout_int])  : t1_fwrdA_wire[9][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 10) && (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdA_wire[10][dout_int]) : t1_fwrdA_wire[10][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 11) && (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdA_wire[11][dout_int]) : t1_fwrdA_wire[11][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 12) && (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdA_wire[12][dout_int]) : t1_fwrdA_wire[12][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 13) && (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdA_wire[13][dout_int]) : t1_fwrdA_wire[13][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 14) && (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdA_wire[14][dout_int]) : t1_fwrdA_wire[14][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 15) && (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdA_wire[15][dout_int]) : t1_fwrdA_wire[15][dout_int]))));
//                                      (rd_fwrd_wire[dout_int] == (FLOPOUT ? $past(t1_fwrdA_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int]) : t1_fwrdA_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int])));
  assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_int] && (addr_wire[dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 0)  && (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrA_wire[0][dout_int])  : t1_serrA_wire[0][dout_int])) && 
                                                        (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrA_wire[0][dout_int])  : t1_derrA_wire[0][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 1)  && (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrA_wire[1][dout_int])  : t1_serrA_wire[1][dout_int])) && 
                                                        (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrA_wire[1][dout_int])  : t1_derrA_wire[1][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 2)  && (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrA_wire[2][dout_int])  : t1_serrA_wire[2][dout_int])) && 
                                                        (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrA_wire[2][dout_int])  : t1_derrA_wire[2][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 3)  && (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrA_wire[3][dout_int])  : t1_serrA_wire[3][dout_int])) && 
                                                        (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrA_wire[3][dout_int])  : t1_derrA_wire[3][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 4)  && (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrA_wire[4][dout_int])  : t1_serrA_wire[4][dout_int])) && 
                                                        (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrA_wire[4][dout_int])  : t1_derrA_wire[4][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 5)  && (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrA_wire[5][dout_int])  : t1_serrA_wire[5][dout_int])) && 
                                                        (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrA_wire[5][dout_int])  : t1_derrA_wire[5][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 6)  && (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrA_wire[6][dout_int])  : t1_serrA_wire[6][dout_int])) && 
                                                        (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrA_wire[6][dout_int])  : t1_derrA_wire[6][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 7)  && (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrA_wire[7][dout_int])  : t1_serrA_wire[7][dout_int])) && 
                                                        (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrA_wire[7][dout_int])  : t1_derrA_wire[7][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 8)  && (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrA_wire[8][dout_int])  : t1_serrA_wire[8][dout_int])) && 
                                                        (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrA_wire[8][dout_int])  : t1_derrA_wire[8][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 9)  && (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrA_wire[9][dout_int])  : t1_serrA_wire[9][dout_int])) && 
                                                        (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrA_wire[9][dout_int])  : t1_derrA_wire[9][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 10) && (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrA_wire[10][dout_int]) : t1_serrA_wire[10][dout_int])) && 
                                                        (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrA_wire[10][dout_int]) : t1_derrA_wire[10][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 11) && (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrA_wire[11][dout_int]) : t1_serrA_wire[11][dout_int])) && 
                                                        (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrA_wire[11][dout_int]) : t1_derrA_wire[11][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 12) && (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrA_wire[12][dout_int]) : t1_serrA_wire[12][dout_int])) && 
                                                        (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrA_wire[12][dout_int]) : t1_derrA_wire[12][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 13) && (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrA_wire[13][dout_int]) : t1_serrA_wire[13][dout_int])) && 
                                                        (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrA_wire[13][dout_int]) : t1_derrA_wire[13][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 14) && (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrA_wire[14][dout_int]) : t1_serrA_wire[14][dout_int])) && 
                                                        (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrA_wire[14][dout_int]) : t1_derrA_wire[14][dout_int]))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 15) && (rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrA_wire[15][dout_int]) : t1_serrA_wire[15][dout_int])) && 
                                                        (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrA_wire[15][dout_int]) : t1_derrA_wire[15][dout_int]))));
//                                      ((rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrA_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int]) : t1_serrA_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int])) &&
//                                       (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrA_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int]) : t1_derrA_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int]))));
  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_int] && (addr_wire[dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 0)  && (rd_padr_wire[dout_int] == ((0 << (BITPADR-BITPBNK)) |
                                                                                    (FLOPOUT ? $past(t1_padrA_wire[0][dout_int])  : t1_padrA_wire[0][dout_int])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 1)  && (rd_padr_wire[dout_int] == ((1 << (BITPADR-BITPBNK)) |
                                                                                    (FLOPOUT ? $past(t1_padrA_wire[1][dout_int])  : t1_padrA_wire[1][dout_int])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 2)  && (rd_padr_wire[dout_int] == ((2 << (BITPADR-BITPBNK)) |
                                                                                    (FLOPOUT ? $past(t1_padrA_wire[2][dout_int])  : t1_padrA_wire[2][dout_int])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 3)  && (rd_padr_wire[dout_int] == ((3 << (BITPADR-BITPBNK)) |
                                                                                    (FLOPOUT ? $past(t1_padrA_wire[3][dout_int])  : t1_padrA_wire[3][dout_int])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 4)  && (rd_padr_wire[dout_int] == ((4 << (BITPADR-BITPBNK)) |
                                                                                    (FLOPOUT ? $past(t1_padrA_wire[4][dout_int])  : t1_padrA_wire[4][dout_int])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 5)  && (rd_padr_wire[dout_int] == ((5 << (BITPADR-BITPBNK)) |
                                                                                    (FLOPOUT ? $past(t1_padrA_wire[5][dout_int])  : t1_padrA_wire[5][dout_int])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 6)  && (rd_padr_wire[dout_int] == ((6 << (BITPADR-BITPBNK)) |
                                                                                    (FLOPOUT ? $past(t1_padrA_wire[6][dout_int])  : t1_padrA_wire[6][dout_int])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 7)  && (rd_padr_wire[dout_int] == ((7 << (BITPADR-BITPBNK)) |
                                                                                    (FLOPOUT ? $past(t1_padrA_wire[7][dout_int])  : t1_padrA_wire[7][dout_int])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 8)  && (rd_padr_wire[dout_int] == ((8 << (BITPADR-BITPBNK)) |
                                                                                    (FLOPOUT ? $past(t1_padrA_wire[8][dout_int])  : t1_padrA_wire[8][dout_int])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 9)  && (rd_padr_wire[dout_int] == ((9 << (BITPADR-BITPBNK)) |
                                                                                    (FLOPOUT ? $past(t1_padrA_wire[9][dout_int])  : t1_padrA_wire[9][dout_int])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 10) && (rd_padr_wire[dout_int] == ((10 << (BITPADR-BITPBNK)) |
                                                                                    (FLOPOUT ? $past(t1_padrA_wire[10][dout_int]) : t1_padrA_wire[10][dout_int])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 11) && (rd_padr_wire[dout_int] == ((11 << (BITPADR-BITPBNK)) |
                                                                                    (FLOPOUT ? $past(t1_padrA_wire[11][dout_int]) : t1_padrA_wire[11][dout_int])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 12) && (rd_padr_wire[dout_int] == ((12 << (BITPADR-BITPBNK)) |
                                                                                    (FLOPOUT ? $past(t1_padrA_wire[12][dout_int]) : t1_padrA_wire[12][dout_int])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 13) && (rd_padr_wire[dout_int] == ((13 << (BITPADR-BITPBNK)) |
                                                                                    (FLOPOUT ? $past(t1_padrA_wire[13][dout_int]) : t1_padrA_wire[13][dout_int])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 14) && (rd_padr_wire[dout_int] == ((14 << (BITPADR-BITPBNK)) |
                                                                                    (FLOPOUT ? $past(t1_padrA_wire[14][dout_int]) : t1_padrA_wire[14][dout_int])))) ||
    (($past(smem_sel_wire,DRAM_DELAY+FLOPOUT) == 15) && (rd_padr_wire[dout_int] == ((15 << (BITPADR-BITPBNK)) |
                                                                                    (FLOPOUT ? $past(t1_padrA_wire[15][dout_int]) : t1_padrA_wire[15][dout_int])))));
//                                      (rd_padr_wire[dout_int] == {$past(smem_sel_wire,DRAM_DELAY+FLOPOUT),(FLOPOUT ? $past(t1_padrA_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int]) : t1_padrA_wire[$past(smem_sel_wire,DRAM_DELAY)][dout_int])})));
//  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_int] && (addr_wire[dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+DRAM_DELAY+FLOPOUT)
//                                      (rd_padr == {select_bank,(FLOPOUT ? $past(t1_padrA_sel_wire) : t1_padrA_sel_wire)}));
end
endgenerate

endmodule

