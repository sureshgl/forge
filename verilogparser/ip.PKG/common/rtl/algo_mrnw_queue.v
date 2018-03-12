
module algo_mrnw_queue (push, pu_adr, pu_din,
                        pop, po_adr, po_vld, po_dout, po_fwrd, po_serr, po_derr, po_padr,
                        t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                        clk, rst, ready,
                        select_queue, select_addr);

  parameter NUMPUPT = 6;
  parameter NUMPOPT = 1;
  parameter NUMQUEU = 256;
  parameter BITQUEU = 8;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter BITPADR = 15;

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter NUMSBFL = 1;

  input [NUMPUPT-1:0]            push;
  input [NUMPUPT*BITQUEU-1:0]    pu_adr;
  input [NUMPUPT*BITADDR-1:0]    pu_din;

  input                          pop;
  input [NUMPOPT*BITQUEU-1:0]    po_adr;
  output [NUMPOPT-1:0]           po_vld;
  output [NUMPOPT*BITADDR-1:0]   po_dout;
  output [NUMPOPT-1:0]           po_fwrd;
  output [NUMPOPT-1:0]           po_serr;
  output [NUMPOPT-1:0]           po_derr;
  output [NUMPOPT*BITPADR-1:0]   po_padr;

  output                         ready;
  input                          clk;
  input                          rst;

  input [BITQUEU-1:0]            select_queue;
  input [BITADDR-1:0]            select_addr;

  output [NUMPUPT-1:0] t1_writeA;
  output [NUMPUPT*BITADDR-1:0] t1_addrA;
  output [NUMPUPT*BITADDR-1:0] t1_dinA;
  output [NUMPOPT-1:0] t1_readB;
  output [NUMPOPT*BITADDR-1:0] t1_addrB;
  input [NUMPOPT*BITADDR-1:0] t1_doutB;
  input [NUMPOPT-1:0] t1_fwrdB;
  input [NUMPOPT-1:0] t1_serrB;
  input [NUMPOPT-1:0] t1_derrB;
  input [NUMPOPT*BITPADR-1:0] t1_padrB;

  core_mrnw_queue #(.NUMPUPT (NUMPUPT), .NUMPOPT (NUMPOPT), .NUMQUEU (NUMQUEU), .BITQUEU (BITQUEU),
                    .NUMADDR (NUMADDR), .BITADDR (BITADDR), .BITPADR (BITPADR),
                    .SRAM_DELAY (SRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT), .NUMSBFL (NUMSBFL))
    core (.vpush (push), .vpuaddr (pu_adr), .vdin (pu_din),
          .vpop (pop), .vpoaddr (po_adr), .vpo_vld (po_vld), .vpo_dout (po_dout),
          .vpo_fwrd (po_fwrd), .vpo_serr (po_serr), .vpo_derr (po_derr), .vpo_padr (po_padr),
          .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA),
          .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB), .t1_fwrdB(t1_fwrdB), .t1_serrB(t1_serrB), .t1_derrB(t1_derrB), .t1_padrB(t1_padrB),
          .ready (ready), .clk (clk), .rst (rst));

`ifdef FORMAL

assume_select_queue_range: assume property (@(posedge clk) disable iff (rst) (select_queue < NUMQUEU));
assume_select_queue_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_queue));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));

ip_top_sva_mrnw_queue #(
     .NUMQUEU     (NUMQUEU),
     .BITQUEU     (BITQUEU),
     .NUMPUPT     (NUMPUPT),
     .NUMPOPT     (NUMPOPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .BITPADR     (BITPADR),
     .NUMSBFL     (NUMSBFL),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);


ip_top_sva_2_mrnw_queue #(
     .NUMQUEU     (NUMQUEU),
     .BITQUEU     (BITQUEU),
     .NUMPUPT     (NUMPUPT),
     .NUMPOPT     (NUMPOPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITQUEU-1:0] help_queue = sva_int;
  wire [BITADDR-1:0] help_addr = sva_int;
ip_top_sva_mrnw_queue #(
     .NUMQUEU     (NUMQUEU),
     .BITQUEU     (BITQUEU),
     .NUMPUPT     (NUMPUPT),
     .NUMPOPT     (NUMPOPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .BITPADR     (BITPADR),
     .NUMSBFL     (NUMSBFL),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_queue(help_queue), .select_addr(help_addr), .*);
end
endgenerate

ip_top_sva_2_mrnw_queue #(
     .NUMQUEU     (NUMQUEU),
     .BITQUEU     (BITQUEU),
     .NUMPUPT     (NUMPUPT),
     .NUMPOPT     (NUMPOPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR))
ip_top_sva_2 (.*);

`endif

endmodule
