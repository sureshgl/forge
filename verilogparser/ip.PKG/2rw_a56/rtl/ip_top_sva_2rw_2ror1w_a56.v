module ip_top_sva_2_2rw_2ror1w_a56
  #(
parameter     WIDTH   = 32,
parameter     ENAPSDO = 0,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     REFRESH = 0,
parameter     SDOUT_WIDTH = BITVBNK+1
   )
(
  input clk,
  input rst,
  input ready,
  input refr,
  input [2-1:0] read,
  input [2-1:0] write,
  input [2*BITADDR-1:0] addr,
  input [2*WIDTH-1:0] din,
  input [NUMVBNK-1:0] t1_writeA,
  input [NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMVBNK-1:0] t1_readB,
  input [NUMVBNK*BITVROW-1:0] t1_addrB,
  input [NUMVBNK-1:0] t1_readC,
  input [NUMVBNK*BITVROW-1:0] t1_addrC,
  input [2-1:0] t2_writeA,
  input [2*BITVROW-1:0] t2_addrA,
  input [2*SDOUT_WIDTH-1:0] t2_dinA,
  input [2-1:0] t2_readB,
  input [2*BITVROW-1:0] t2_addrB,
  input [2-1:0] t3_writeA,
  input [2*BITVROW-1:0] t3_addrA,
  input [2*WIDTH-1:0] t3_dinA,
  input [2-1:0] t3_readB,
  input [2*BITVROW-1:0] t3_addrB
);

generate if (REFRESH) begin: refr_loop
  assert_refr_noacc_check: assume property (@(posedge clk) disable iff (!ready) !(refr && (write || read)));
end
endgenerate

genvar prt_int;
generate for (prt_int=0; prt_int<2; prt_int=prt_int+1) begin: prt_loop
  wire read_wire = read >> prt_int;
  wire write_wire = write >> prt_int;
  wire [BITADDR-1:0] addr_wire = addr >> (prt_int*BITADDR);

  assert_rw_1p_check: assert property (@(posedge clk) disable iff (!ready) !(read_wire && write_wire)); 
  assert_rw_range_check: assert property (@(posedge clk) disable iff (!ready) (read_wire || write_wire) |-> (addr_wire < NUMADDR));
end
endgenerate

genvar t1_int;
generate for (t1_int=0; t1_int<NUMVBNK; t1_int=t1_int+1) begin: t1_loop
  wire t1_writeA_wire = t1_writeA >> t1_int;
  wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> (t1_int*BITVROW);
  wire t1_readB_wire = t1_readB >> t1_int;
  wire [BITVROW-1:0] t1_addrB_wire = t1_addrB >> (t1_int*BITVROW);
  wire t1_readC_wire = t1_readC >> t1_int;
  wire [BITVROW-1:0] t1_addrC_wire = t1_addrC >> (t1_int*BITVROW);

  assert_t1_2ror1w_check: assert property (@(posedge clk) disable iff (rst) !(t1_writeA_wire && (t1_readB_wire || t1_readC_wire)));
  assert_t1_wrA_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMVROW));
  assert_t1_rdB_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> (t1_addrB_wire < NUMVROW));
  assert_t1_rdC_range_check: assert property (@(posedge clk) disable iff (rst) t1_readC_wire |-> (t1_addrC_wire < NUMVROW));
end
endgenerate

genvar t2_int;
generate for (t2_int=0; t2_int<2; t2_int=t2_int+1) begin: t2_loop
  wire t2_writeA_wire = t2_writeA >> t2_int;
  wire [BITVROW-1:0] t2_addrA_wire = t2_addrA >> (t2_int*BITVROW);
  wire [SDOUT_WIDTH-1:0] t2_dinA_wire = t2_dinA >> (t2_int*SDOUT_WIDTH);

  wire t2_writeA_0_wire = t2_writeA;
  wire [BITVROW-1:0] t2_addrA_0_wire = t2_addrA;
  wire [SDOUT_WIDTH-1:0] t2_dinA_0_wire = t2_dinA;

  wire t2_readB_wire = t2_readB >> t2_int;
  wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> (t2_int*BITVROW);

  assert_t2_wr_same_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_writeA_0_wire &&
												 (t2_addrA_0_wire == t2_addrA_wire) &&
												 (t2_dinA_0_wire == t2_dinA_wire)));
  assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_addrA_wire < NUMVROW));
  assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire |-> (t2_addrB_wire < NUMVROW));
  assert_t2_rw_psuedo_check: assert property (@(posedge clk) disable iff (rst) (ENAPSDO && t2_writeA_wire && t2_readB_wire) |-> (t2_addrA_wire != t2_addrB_wire));
end
endgenerate

genvar t3_int;
generate for (t3_int=0; t3_int<2; t3_int=t3_int+1) begin: t3_loop
  wire t3_writeA_wire = t3_writeA >> t3_int;
  wire [BITVROW-1:0] t3_addrA_wire = t3_addrA >> (t3_int*BITVROW);
  wire [WIDTH-1:0] t3_dinA_wire = t3_dinA >> (t3_int*WIDTH);

  wire t3_writeA_0_wire = t3_writeA;
  wire [BITVROW-1:0] t3_addrA_0_wire = t3_addrA;
  wire [WIDTH-1:0] t3_dinA_0_wire = t3_dinA;

  wire t3_readB_wire = t3_readB >> t3_int;
  wire [BITVROW-1:0] t3_addrB_wire = t3_addrB >> (t3_int*BITVROW);

  assert_t3_wr_same_check: assert property (@(posedge clk) disable iff (rst) t3_writeA_wire |-> (t3_writeA_0_wire &&
												 (t3_addrA_0_wire == t3_addrA_wire) &&
												 (t3_dinA_0_wire == t3_dinA_wire)));
  assert_t3_wr_range_check: assert property (@(posedge clk) disable iff (rst) t3_writeA_wire |-> (t3_addrA_wire < NUMVROW));
  assert_t3_rd_range_check: assert property (@(posedge clk) disable iff (rst) t3_readB_wire |-> (t3_addrB_wire < NUMVROW));
  assert_t3_rw_psuedo_check: assert property (@(posedge clk) disable iff (rst) (ENAPSDO && t3_writeA_wire && t3_readB_wire) |-> (t3_addrA_wire != t3_addrB_wire));
end
endgenerate

endmodule


module ip_top_sva_2rw_2ror1w_a56
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     ENAPAR  = 0,
parameter     ENAECC  = 0,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     BITPBNK = 4,
parameter     BITPADR = 14,
parameter     REFRESH = 0,
parameter     SDOUT_WIDTH = BITVBNK+1,
parameter     SRAM_DELAY = 2,
parameter     DRAM_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0,
parameter     FIFOCNT = 2*SRAM_DELAY+2
   )
(
  input clk,
  input rst,
  input [2-1:0] read,
  input [2-1:0] write,
  input [2*BITADDR-1:0] addr,
  input [2*WIDTH-1:0] din,
  input [2-1:0] rd_vld,
  input [2-1:0] rd_fwrd,
  input [2-1:0] rd_serr,
  input [2-1:0] rd_derr,
  input [2*BITPADR-1:0] rd_padr,
  input [2*WIDTH-1:0] rd_dout,
  input [NUMVBNK-1:0] t1_writeA,
  input [NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMVBNK-1:0] t1_readB,
  input [NUMVBNK*BITVROW-1:0] t1_addrB,
  input [NUMVBNK*WIDTH-1:0] t1_doutB,
  input [NUMVBNK-1:0] t1_fwrdB,
  input [NUMVBNK-1:0] t1_serrB,
  input [NUMVBNK-1:0] t1_derrB,
  input [NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrB,
  input [NUMVBNK-1:0] t1_readC,
  input [NUMVBNK*BITVROW-1:0] t1_addrC,
  input [NUMVBNK*WIDTH-1:0] t1_doutC,
  input [NUMVBNK-1:0] t1_fwrdC,
  input [NUMVBNK-1:0] t1_serrC,
  input [NUMVBNK-1:0] t1_derrC,
  input [NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrC,
  input [2-1:0] t2_writeA,
  input [2*BITVROW-1:0] t2_addrA,
  input [2*SDOUT_WIDTH-1:0] t2_dinA,
  input [2-1:0] t2_readB,
  input [2*BITVROW-1:0] t2_addrB,
  input [2*SDOUT_WIDTH-1:0] t2_doutB,
  input [2-1:0] t3_writeA,
  input [2*BITVROW-1:0] t3_addrA,
  input [2*WIDTH-1:0] t3_dinA,
  input [2-1:0] t3_readB,
  input [2*BITVROW-1:0] t3_addrB,
  input [2*WIDTH-1:0] t3_doutB,
  input [2-1:0] t3_fwrdB,
  input [2-1:0] t3_serrB,
  input [2-1:0] t3_derrB,
  input [2*(BITPADR-BITPBNK)-1:0] t3_padrB,
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

wire read_wire [0:2-1];
wire write_wire [0:2-1];
wire [BITADDR-1:0] addr_wire [0:2-1];
wire [BITVROW-1:0] radr_wire [0:2-1];
wire [WIDTH-1:0] din_wire [0:2-1];
wire rd_vld_wire [0:2-1];
wire rd_fwrd_wire [0:2-1];
wire [WIDTH-1:0] rd_dout_wire [0:2-1];
wire rd_serr_wire [0:2-1];
wire rd_derr_wire [0:2-1];
wire [BITPADR-1:0] rd_padr_wire [0:2-1];
genvar prt_int;
generate for (prt_int=0; prt_int<2; prt_int=prt_int+1) begin: prt_loop
  assign read_wire[prt_int] = read >> prt_int;
  assign write_wire[prt_int] = write >> prt_int;
  assign addr_wire[prt_int] = addr >> (prt_int*BITADDR);
  np2_addr #(
    .NUMADDR (NUMADDR), .BITADDR (BITADDR),
    .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
    .NUMVROW (NUMVROW), .BITVROW (BITVROW))
    adr_inst (.vbadr(), .vradr(radr_wire[prt_int]), .vaddr(addr_wire[prt_int]));
  assign din_wire[prt_int] = din >> (prt_int*WIDTH);
  assign rd_vld_wire[prt_int] = rd_vld >> prt_int;
  assign rd_fwrd_wire[prt_int] = rd_fwrd >> prt_int;
  assign rd_dout_wire[prt_int] = rd_dout >> (prt_int*WIDTH);
  assign rd_serr_wire[prt_int] = rd_serr >> prt_int;
  assign rd_derr_wire[prt_int] = rd_derr >> prt_int;
  assign rd_padr_wire[prt_int] = rd_padr >> (prt_int*BITPADR);
end
endgenerate

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

reg t1_writeA_wire [0:NUMVBNK-1];
reg [BITVROW-1:0] t1_addrA_wire [0:NUMVBNK-1];
reg [WIDTH-1:0] t1_dinA_wire [0:NUMVBNK-1];
integer t1_int;
always_comb
  for (t1_int=0; t1_int<NUMVBNK; t1_int=t1_int+1) begin
    t1_writeA_wire[t1_int] = t1_writeA >> t1_int;
    t1_addrA_wire[t1_int] = t1_addrA >> (t1_int*BITVROW);
    t1_dinA_wire[t1_int] = t1_dinA >> (t1_int*WIDTH);
  end

wire t1_writeA_sel_wire = t1_writeA >> select_bank;
wire [BITVROW-1:0] t1_addrA_sel_wire = t1_addrA >> (select_bank*BITVROW);
wire [WIDTH-1:0] t1_dinA_sel_wire = t1_dinA >> (select_bank*WIDTH);
wire t1_readB_sel_wire = t1_readB >> select_bank;
wire [BITVROW-1:0] t1_addrB_sel_wire = t1_addrB >> (select_bank*BITVROW);
wire [WIDTH-1:0] t1_doutB_sel_wire = t1_doutB >> (select_bank*WIDTH);
wire t1_fwrdB_sel_wire = t1_fwrdB >> select_bank;
wire t1_serrB_sel_wire = t1_serrB >> select_bank;
wire t1_derrB_sel_wire = t1_derrB >> select_bank;
wire [BITPADR-BITPBNK-1:0] t1_padrB_sel_wire = t1_padrB >> (select_bank*(BITPADR-BITPBNK));
wire t1_readC_sel_wire = t1_readC >> select_bank;
wire [BITVROW-1:0] t1_addrC_sel_wire = t1_addrC >> (select_bank*BITVROW);
wire [WIDTH-1:0] t1_doutC_sel_wire = t1_doutC >> (select_bank*WIDTH);
wire t1_fwrdC_sel_wire = t1_fwrdC >> select_bank;
wire t1_serrC_sel_wire = t1_serrC >> select_bank;
wire t1_derrC_sel_wire = t1_derrC >> select_bank;
wire [BITPADR-BITPBNK-1:0] t1_padrC_sel_wire = t1_padrC >> (select_bank*(BITPADR-BITPBNK));

wire t2_writeA_sel_wire = t2_writeA;
wire [BITVROW-1:0] t2_addrA_sel_wire = t2_addrA;
wire [SDOUT_WIDTH-1:0] t2_dinA_sel_wire = t2_dinA; 
wire t2_readB_0_wire = t2_readB;
wire [BITVROW-1:0] t2_addrB_0_wire = t2_addrB;
wire [SDOUT_WIDTH-1:0] t2_doutB_0_wire = t2_doutB; 
wire t2_readB_1_wire = t2_readB >> 1;
wire [BITVROW-1:0] t2_addrB_1_wire = t2_addrB >> (1*BITVROW);
wire [SDOUT_WIDTH-1:0] t2_doutB_1_wire = t2_doutB >> (1*SDOUT_WIDTH); 

wire t3_writeA_sel_wire = t3_writeA;
wire [BITVROW-1:0] t3_addrA_sel_wire = t3_addrA;
wire [WIDTH-1:0] t3_dinA_sel_wire = t3_dinA; 
wire t3_readB_0_wire = t3_readB;
wire [BITVROW-1:0] t3_addrB_0_wire = t3_addrB;
wire [WIDTH-1:0] t3_doutB_0_wire = t3_doutB; 
wire t3_fwrdB_0_wire = t3_fwrdB; 
wire t3_serrB_0_wire = t3_serrB; 
wire t3_derrB_0_wire = t3_derrB; 
wire [BITPADR-BITPBNK-1:0] t3_padrB_0_wire = t3_padrB; 
wire t3_readB_1_wire = t3_readB >> 1;
wire [BITVROW-1:0] t3_addrB_1_wire = t3_addrB >> (1*BITVROW);
wire [WIDTH-1:0] t3_doutB_1_wire = t3_doutB >> (1*WIDTH); 
wire t3_fwrdB_1_wire = t3_fwrdB >> 1; 
wire t3_serrB_1_wire = t3_serrB >> 1; 
wire t3_derrB_1_wire = t3_derrB >> 1; 
wire [BITPADR-BITPBNK-1:0] t3_padrB_1_wire = t3_padrB >> (BITPADR-BITPBNK); 

wire [NUMVBNK-1:0] wrp1_serr = 0;
wire [NUMVBNK-1:0] wrp1_derr = 0;
wire [NUMVBNK-1:0] wrp1_nerr = ~wrp1_serr & ~wrp1_derr;

reg pmeminv;
reg pmem;
always @(posedge clk)
  if (rst)
    pmeminv <= 1'b1;
  else if (t1_writeA_sel_wire && (t1_addrA_sel_wire == select_row))
    pmeminv <= ENAPAR ? wrp1_serr[select_bank] : ENAECC ? wrp1_derr[select_bank] : 1'b0;
  else if (t1_writeA_sel_wire)
    pmeminv <= pmeminv || (ENAPAR ? wrp1_serr[select_bank] : ENAECC ? wrp1_derr[select_bank] : 1'b0);

always @(posedge clk)
  if (t1_writeA_sel_wire && (t1_addrA_sel_wire == select_row))
    pmem <= t1_dinA_sel_wire >> select_bit;

reg [SDOUT_WIDTH-1:0] smem;
always @(posedge clk)
  if (rst)
    smem <= 0;
  else if (t2_writeA_sel_wire && (t2_addrA_sel_wire == select_row))
    smem <= t2_dinA_sel_wire;

reg cmem;
always @(posedge clk)
  if (rst)
    cmem <= 0;
  else if (t3_writeA[0] && (t3_addrA_sel_wire == select_row))
    cmem <= t3_dinA_sel_wire >> select_bit;

wire mem_wire = (smem[BITVBNK] && (smem[BITVBNK-1:0] == select_bank)) ? cmem : pmem;

assert_pdout1_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_sel_wire && (t1_addrB_sel_wire == select_row)) |-> ##DRAM_DELAY
				      ($past(pmeminv,DRAM_DELAY) ||
                                       (!t1_fwrdB_sel_wire && (ENAPAR ? t1_serrB_sel_wire : ENAECC ? t1_derrB_sel_wire : 0)) || 
                                       (t1_doutB_sel_wire[select_bit] == $past(pmem,DRAM_DELAY))));
assert_pdout2_check: assert property (@(posedge clk) disable iff (rst) (t1_readC_sel_wire && (t1_addrC_sel_wire == select_row)) |-> ##DRAM_DELAY
				      ($past(pmeminv,DRAM_DELAY) ||
                                       (!t1_fwrdC_sel_wire && (ENAPAR ? t1_serrC_sel_wire : ENAECC ? t1_derrC_sel_wire : 0)) || 
                                       (t1_doutC_sel_wire[select_bit] == $past(pmem,DRAM_DELAY))));

assert_sdout1_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_0_wire && (t2_addrB_0_wire == select_row)) |-> ##SRAM_DELAY
				                      (t2_doutB_0_wire == $past(smem,SRAM_DELAY)));
assert_sdout2_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_1_wire && (t2_addrB_1_wire == select_row)) |-> ##SRAM_DELAY
				                      (t2_doutB_1_wire == $past(smem,SRAM_DELAY)));

assert_cdout1_check: assert property (@(posedge clk) disable iff (rst) (t3_readB_0_wire && (t3_addrB_0_wire == select_row)) |-> ##SRAM_DELAY
				                      (t3_doutB_0_wire[select_bit] == $past(cmem,SRAM_DELAY)));
assert_cdout2_check: assert property (@(posedge clk) disable iff (rst) (t3_readB_1_wire && (t3_addrB_1_wire == select_row)) |-> ##SRAM_DELAY
				                      (t3_doutB_1_wire[select_bit] == $past(cmem,SRAM_DELAY)));

assert_rmap1_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[0] && (core.vradr_wire[0] == select_row)) |-> ##DRAM_DELAY
                                         (core.rmap1_out == smem[BITVBNK:0]));
assert_rcdat1_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[0] && (core.vradr_wire[0] == select_row)) |-> ##DRAM_DELAY
                                          (core.rcdat1_out[select_bit] == cmem));
assert_rpdat1_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[0] && (core.vbadr_wire[0] == select_bank) && (core.vradr_wire[0] == select_row)) |-> ##DRAM_DELAY
                                          (pmeminv ||
                                           (!t1_fwrdB_sel_wire && !core.pdat1_vld[DRAM_DELAY-1] && (ENAPAR ? t1_serrB_sel_wire : ENAECC ? t1_derrB_sel_wire : 0)) || 
                                           (core.rpdat1_out[select_bit] == pmem)));

assert_rmap2_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[1] && (core.vradr_wire[1] == select_row)) |-> ##DRAM_DELAY
                                         (core.rmap2_out == smem[BITVBNK:0]));
assert_rcdat2_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[1] && (core.vradr_wire[1] == select_row)) |-> ##DRAM_DELAY
                                          (core.rcdat2_out[select_bit] == cmem));
assert_rpdat2_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[1] && (core.vbadr_wire[1] == select_bank) && (core.vradr_wire[1] == select_row)) |-> ##DRAM_DELAY
                                          (pmeminv ||
                                           (!t1_fwrdC_sel_wire && !core.pdat2_vld[DRAM_DELAY-1] && (ENAPAR ? t1_serrC_sel_wire : ENAECC ? t1_derrC_sel_wire : 0)) || 
                                           (core.rpdat2_out[select_bit] == pmem)));

assert_wmap1_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[0] && (core.vradr_wire[0] == select_row)) |-> ##SRAM_DELAY
                                         (core.wmap1_out == smem[BITVBNK:0]));
assert_wcdat1_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[0] && (core.vradr_wire[0] == select_row)) |-> ##SRAM_DELAY
                                          (core.wcdat1_out[select_bit] == cmem));

assert_wmap2_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[1] && (core.vradr_wire[1] == select_row)) |-> ##SRAM_DELAY
                                         (core.wmap2_out == smem[BITVBNK:0]));
assert_wcdat2_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[1] && (core.vradr_wire[1] == select_row)) |-> ##SRAM_DELAY
                                          (core.wcdat2_out[select_bit] == cmem));

assert_sold1_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.snew_vld1 && (core.snew_row1 == select_row)) |->
                                        (({core.sold_vld1,core.sold_map1} == smem[BITVBNK:0]) && (core.sold_dat1[select_bit] == cmem)));
assert_sold2_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.snew_vld2 && (core.snew_row2 == select_row)) |->
                                         (({core.sold_vld2,core.sold_map2} == smem[BITVBNK:0]) && (core.sold_dat2[select_bit] == cmem)));
assert_wrfifo_check: assert property (@(posedge clk) disable iff (rst) (core.wrfifo_cnt <= FIFOCNT));

reg rmeminv;
reg rmem;
always @(posedge clk)
  if (rst)
    rmeminv <= 1'b1;
  else if (core.snew_vld2 && (core.snew_map2 == select_bank) && (core.snew_row2 == select_row)) begin
    rmeminv <= 1'b0;
    rmem <= core.snew_dat2[select_bit];
  end else if (core.snew_vld1 && (core.snew_map1 == select_bank) && (core.snew_row1 == select_row)) begin
    rmeminv <= 1'b0;
    rmem <= core.snew_dat1[select_bit];
  end

assert_rmem_check: assert property (@(posedge clk) disable iff (rst) (rmeminv || (mem_wire == rmem)));

assert_vdout1_int_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] && (addr_wire[0] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY)
                                          (rmeminv ||
                                           (!core.vread_fwrd1_int && (ENAPAR ? rd_serr_wire[0] : ENAECC ? rd_derr_wire[0] : 1'b0)) ||
                                           (core.vdout1_int[select_bit] == rmem)));
assert_vdout2_int_check: assert property (@(posedge clk) disable iff (rst) (read_wire[1] && (addr_wire[1] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY)
                                          (rmeminv ||
                                           (!core.vread_fwrd2_int && (ENAPAR ? rd_serr_wire[1] : ENAECC ? rd_derr_wire[1] : 1'b0)) ||
                                           (core.vdout2_int[select_bit] == rmem)));

reg vmeminv;
reg vmem;
always @(posedge clk)
  if (rst)
    vmeminv <= 1'b1;
  else if (core.vwrite2_out && (core.vwrbadr2_out == select_bank) && (core.vwrradr2_out == select_row)) begin
    vmeminv <= 1'b0;
    vmem <= core.vdin2_out[select_bit];
  end else if (core.vwrite1_out && (core.vwrbadr1_out == select_bank) && (core.vwrradr1_out == select_row)) begin
    vmeminv <= 1'b0;
    vmem <= core.vdin1_out[select_bit];
  end

assert_vmem_check: assert property (@(posedge clk) disable iff (rst) (vmeminv || ((core.wr_srch_flags ? core.wr_srch_datas[select_bit] : rmem) == vmem)));

assert_srch1_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] && (addr_wire[0] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY)
                                     (vmeminv || (rmeminv ? (core.wr_srch_flag1 && (core.wr_srch_data1[select_bit] == vmem)) :
                                                            ((core.wr_srch_flag1 ? core.wr_srch_data1[select_bit] : rmem) == vmem))));
assert_srch2_check: assert property (@(posedge clk) disable iff (rst) (read_wire[1] && (addr_wire[1] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY)
                                     (vmeminv || (rmeminv ? (core.wr_srch_flag2 && (core.wr_srch_data2[select_bit] == vmem)) :
                                                            ((core.wr_srch_flag2 ? core.wr_srch_data2[select_bit] : rmem) == vmem))));

reg fakememinv;
always @(posedge clk)
  if (rst)
    fakememinv <= 1'b1;
  else if (write_wire[1] && (addr_wire[1] == select_addr))
    fakememinv <= 1'b0;
  else if (write_wire[0] && (addr_wire[0] == select_addr))
    fakememinv <= 1'b0;

reg fakemem;
always @(posedge clk)
  if (write_wire[1] && (addr_wire[1] == select_addr))
    fakemem <= din_wire[1][select_bit];
  else if (write_wire[0] && (addr_wire[0] == select_addr))
    fakemem <= din_wire[0][select_bit];

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##(FLOPIN+SRAM_DELAY)
				       ($past(fakememinv,FLOPIN+SRAM_DELAY) || ($past(fakemem,FLOPIN+SRAM_DELAY) == vmem)));

assert_dout1_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] && (addr_wire[0] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
                                     (rd_vld_wire[0] && ($past(fakememinv,FLOPIN+DRAM_DELAY+FLOPOUT) ||
                                                         (!rd_fwrd_wire[0] && (ENAPAR ? rd_serr_wire[0] : ENAECC ? rd_derr_wire[0] : 1'b0)) ||
                                                         (rd_dout_wire[0][select_bit] == $past(fakemem,FLOPIN+DRAM_DELAY+FLOPOUT)))));
assert_dout2_check: assert property (@(posedge clk) disable iff (rst) (read_wire[1] && (addr_wire[1] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
                                     (rd_vld_wire[1] && ($past(fakememinv,FLOPIN+DRAM_DELAY+FLOPOUT) ||
                                                         (!rd_fwrd_wire[1] && (ENAPAR ? rd_serr_wire[1] : ENAECC ? rd_derr_wire[1] : 1'b0)) ||
                                                         (rd_dout_wire[1][select_bit] == $past(fakemem,FLOPIN+DRAM_DELAY+FLOPOUT)))));
assert_derr1_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] && (addr_wire[0] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
                                     (rd_padr_wire[0][BITPADR-1:BITPADR-BITPBNK] == NUMVBNK) ?
                                      ((rd_serr_wire[0] == (FLOPOUT ? $past(t3_serrB_0_wire) : t3_serrB_0_wire)) &&
                                       (rd_derr_wire[0] == (FLOPOUT ? $past(t3_derrB_0_wire) : t3_derrB_0_wire))) :
                                      ((rd_serr_wire[0] == (FLOPOUT ? $past(t1_serrB_sel_wire) : t1_serrB_sel_wire)) &&
                                       (rd_derr_wire[0] == (FLOPOUT ? $past(t1_derrB_sel_wire) : t1_derrB_sel_wire))));
assert_derr2_check: assert property (@(posedge clk) disable iff (rst) (read_wire[1] && (addr_wire[1] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
                                     (rd_padr_wire[1][BITPADR-1:BITPADR-BITPBNK] == NUMVBNK) ?
                                      ((rd_serr_wire[1] == (FLOPOUT ? $past(t3_serrB_1_wire) : t3_serrB_1_wire)) &&
                                       (rd_derr_wire[1] == (FLOPOUT ? $past(t3_derrB_1_wire) : t3_derrB_1_wire))) :
                                      ((rd_serr_wire[1] == (FLOPOUT ? $past(t1_serrC_sel_wire) : t1_serrC_sel_wire)) &&
                                       (rd_derr_wire[1] == (FLOPOUT ? $past(t1_derrC_sel_wire) : t1_derrC_sel_wire))));
assert_padr1_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] && (addr_wire[0] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
                                     (rd_padr_wire[0] == ((NUMVBNK << (BITPADR-BITPBNK)) | select_row)) ||
                                     (rd_padr_wire[0] == {select_bank,(FLOPOUT ? $past(t1_padrB_sel_wire) : t1_padrB_sel_wire)}));
assert_padr2_check: assert property (@(posedge clk) disable iff (rst) (read_wire[1] && (addr_wire[1] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
                                     (rd_padr_wire[1] == ((NUMVBNK << (BITPADR-BITPBNK)) | select_row)) ||
                                     (rd_padr_wire[1] == {select_bank,(FLOPOUT ? $past(t1_padrC_sel_wire) : t1_padrC_sel_wire)}));

endmodule

