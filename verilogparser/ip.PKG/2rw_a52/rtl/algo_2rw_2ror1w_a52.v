
module algo_2rw_2ror1w_a52 (refr, read, write, addr, din, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
	                    t1_writeA, t1_addrA, t1_dinA,
                            t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                            t1_readC, t1_addrC, t1_doutC, t1_fwrdC, t1_serrC, t1_derrC, t1_padrC,
                            t1_refrD,
	                    t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
	                    t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB, t3_fwrdB, t3_serrB, t3_derrB, t3_padrB,
	                    clk, rst, ready,
	                    select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;

  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter BITPADR = 14;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;

  parameter REFRESH = 0;
  parameter ECCBITS = 4;

  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input                        refr;

  input [2-1:0]                read;
  input [2-1:0]                write;
  input [2*BITADDR-1:0]        addr;
  input [2*WIDTH-1:0]          din;
  output [2-1:0]               rd_vld;
  output [2*WIDTH-1:0]         rd_dout;
  output [2-1:0]               rd_fwrd;
  output [2-1:0]               rd_serr;
  output [2-1:0]               rd_derr;
  output [2*BITPADR-1:0]       rd_padr;

  output                       ready;
  input                        clk;
  input                        rst;

  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMVBNK*WIDTH-1:0] t1_dinA;

  output [NUMVBNK-1:0] t1_readB;
  output [NUMVBNK*BITVROW-1:0] t1_addrB;
  input [NUMVBNK*WIDTH-1:0] t1_doutB;
  input [NUMVBNK-1:0] t1_fwrdB;
  input [NUMVBNK-1:0] t1_serrB;
  input [NUMVBNK-1:0] t1_derrB;
  input [NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrB;

  output [NUMVBNK-1:0] t1_readC;
  output [NUMVBNK*BITVROW-1:0] t1_addrC;
  input [NUMVBNK*WIDTH-1:0] t1_doutC;
  input [NUMVBNK-1:0] t1_fwrdC;
  input [NUMVBNK-1:0] t1_serrC;
  input [NUMVBNK-1:0] t1_derrC;
  input [NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrC;

  output [NUMVBNK-1:0] t1_refrD;

  output [2-1:0] t2_writeA;
  output [2*BITVROW-1:0] t2_addrA;
  output [2*SDOUT_WIDTH-1:0] t2_dinA;

  output [2-1:0] t2_readB;
  output [2*BITVROW-1:0] t2_addrB;
  input [2*SDOUT_WIDTH-1:0] t2_doutB;

  output [2-1:0] t3_writeA;
  output [2*BITVROW-1:0] t3_addrA;
  output [2*WIDTH-1:0] t3_dinA;

  output [2-1:0] t3_readB;
  output [2*BITVROW-1:0] t3_addrB;
  input [2*WIDTH-1:0] t3_doutB;
  input [2-1:0] t3_fwrdB;
  input [2-1:0] t3_serrB;
  input [2-1:0] t3_derrB;
  input [2*(BITPADR-BITPBNK)-1:0] t3_padrB;

  input [BITADDR-1:0]          select_addr;
  input [BITWDTH-1:0]          select_bit;

wire                               prefr;
wire                               pwrite1;
wire [BITVBNK-1:0]                 pwrbadr1;
wire [BITVROW-1:0]                 pwrradr1;
wire [WIDTH-1:0]                   pdin1;
wire                               pwrite2;
wire [BITVBNK-1:0]                 pwrbadr2;
wire [BITVROW-1:0]                 pwrradr2;
wire [WIDTH-1:0]                   pdin2;
wire                               pread1;
wire [BITVBNK-1:0]                 prdbadr1;
wire [BITVROW-1:0]                 prdradr1;
wire [WIDTH-1:0]                   pdout1;
wire                               pdout1_fwrd;
wire                               pdout1_serr;
wire                               pdout1_derr;
wire [BITPADR-BITPBNK-1:0]         pdout1_padr;
wire                               pread2;
wire [BITVBNK-1:0]                 prdbadr2;
wire [BITVROW-1:0]                 prdradr2;
wire [WIDTH-1:0]                   pdout2;
wire                               pdout2_fwrd;
wire                               pdout2_serr;
wire                               pdout2_derr;
wire [BITPADR-BITPBNK-1:0]         pdout2_padr;
wire                               swrite;
wire [BITVROW-1:0]                 swrradr;
wire [SDOUT_WIDTH-1:0]             sdin;
wire                               sread1;
wire [BITVROW-1:0]                 srdradr1;
wire [SDOUT_WIDTH-1:0]             sdout1;
wire                               sread2;
wire [BITVROW-1:0]                 srdradr2;
wire [SDOUT_WIDTH-1:0]             sdout2;
wire                               cwrite;
wire [BITVROW-1:0]                 cwrradr;
wire [WIDTH-1:0]                   cdin;
wire                               cread1;
wire [BITVROW-1:0]                 crdradr1;
wire [WIDTH-1:0]                   cdout1;
wire                               cdout1_fwrd;
wire                               cdout1_serr;
wire                               cdout1_derr;
wire [BITPADR-BITPBNK-1:0]         cdout1_padr;
wire                               cread2;
wire [BITVROW-1:0]                 crdradr2;
wire [WIDTH-1:0]                   cdout2;
wire                               cdout2_fwrd;
wire                               cdout2_serr;
wire                               cdout2_derr;
wire [BITPADR-BITPBNK-1:0]         cdout2_padr;

core_2rw_2ror1w_a52 #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                      .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR),
                      .REFRESH (REFRESH), .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT), .ECCBITS (ECCBITS))
    core (.vrefr (refr), .vread (read), .vwrite (write), .vaddr (addr), .vdin (din),
	  .vread_vld (rd_vld), .vdout (rd_dout), .vread_fwrd (rd_fwrd), .vread_serr (rd_serr), .vread_derr (rd_derr), .vread_padr (rd_padr),
          .prefr (prefr),
          .pwrite1 (pwrite1), .pwrbadr1 (pwrbadr1), .pwrradr1 (pwrradr1), .pdin1 (pdin1),
          .pwrite2 (pwrite2), .pwrbadr2 (pwrbadr2), .pwrradr2 (pwrradr2), .pdin2 (pdin2),
          .pread1 (pread1), .prdbadr1 (prdbadr1), .prdradr1 (prdradr1), .pdout1 (pdout1),
          .pdout1_fwrd (pdout1_fwrd), .pdout1_serr (pdout1_serr), .pdout1_derr (pdout1_derr), .pdout1_padr (pdout1_padr),
          .pread2 (pread2), .prdbadr2 (prdbadr2), .prdradr2 (prdradr2), .pdout2 (pdout2),
          .pdout2_fwrd (pdout2_fwrd), .pdout2_serr (pdout2_serr), .pdout2_derr (pdout2_derr), .pdout2_padr (pdout2_padr),
          .swrite (swrite), .swrradr (swrradr), .sdin (sdin),
          .sread1 (sread1), .srdradr1 (srdradr1), .sdout1 (sdout1),
          .sread2 (sread2), .srdradr2 (srdradr2), .sdout2 (sdout2),
          .cwrite (cwrite), .cwrradr (cwrradr), .cdin (cdin),
          .cread1 (cread1), .crdradr1 (crdradr1), .cdout1 (cdout1),
          .cdout1_fwrd (cdout1_fwrd), .cdout1_serr (cdout1_serr), .cdout1_derr (cdout1_derr), .cdout1_padr (cdout1_padr),
          .cread2 (cread2), .crdradr2 (crdradr2), .cdout2 (cdout2),
          .cdout2_fwrd (cdout2_fwrd), .cdout2_serr (cdout2_serr), .cdout2_derr (cdout2_derr), .cdout2_padr (cdout2_padr),
          .ready (ready), .clk (clk), .rst (rst),
	  .select_addr (select_addr), .select_bit (select_bit));

mux_2rw_2ror1w_a52 #(.WIDTH (WIDTH), .NUMVBNK(NUMVBNK), .BITVBNK (BITVBNK), .BITPADR (BITPADR-BITPBNK),
                     .NUMVROW (NUMVROW), .BITVROW (BITVROW), .ECCBITS (ECCBITS),
                     .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY))
    mux  (.clk(clk), .rst(rst), 
          .prefr(prefr),
          .pwrite1(pwrite1), .pwrbadr1(pwrbadr1), .pwrradr1(pwrradr1), .pdin1(pdin1),
          .pwrite2(pwrite2), .pwrbadr2(pwrbadr2), .pwrradr2(pwrradr2), .pdin2(pdin2),
          .pread1(pread1), .prdbadr1(prdbadr1), .prdradr1(prdradr1), .pdout1(pdout1),
          .pdout1_fwrd(pdout1_fwrd), .pdout1_serr(pdout1_serr), .pdout1_derr(pdout1_derr), .pdout1_padr(pdout1_padr),
          .pread2(pread2), .prdbadr2(prdbadr2), .prdradr2(prdradr2), .pdout2(pdout2),
          .pdout2_fwrd(pdout2_fwrd), .pdout2_serr(pdout2_serr), .pdout2_derr(pdout2_derr), .pdout2_padr(pdout2_padr),
          .swrite(swrite), .swrradr(swrradr), .sdin(sdin),
          .sread1(sread1), .srdradr1(srdradr1), .sdout1(sdout1),
          .sread2(sread2), .srdradr2(srdradr2), .sdout2(sdout2),
          .cwrite(cwrite), .cwrradr(cwrradr), .cdin(cdin),
          .cread1(cread1), .crdradr1(crdradr1), .cdout1(cdout1),
          .cdout1_fwrd(cdout1_fwrd), .cdout1_serr(cdout1_serr), .cdout1_derr(cdout1_derr), .cdout1_padr(cdout1_padr),
          .cread2(cread2), .crdradr2(crdradr2), .cdout2(cdout2),
          .cdout2_fwrd(cdout2_fwrd), .cdout2_serr(cdout2_serr), .cdout2_derr(cdout2_derr), .cdout2_padr(cdout2_padr),
          .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA),
          .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB), .t1_fwrdB(t1_fwrdB), .t1_serrB(t1_serrB), .t1_derrB(t1_derrB), .t1_padrB(t1_padrB),
          .t1_readC(t1_readC), .t1_addrC(t1_addrC), .t1_doutC(t1_doutC), .t1_fwrdC(t1_fwrdC), .t1_serrC(t1_serrC), .t1_derrC(t1_derrC), .t1_padrC(t1_padrC),
          .t1_refrD(t1_refrD),
          .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA),
          .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
          .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA),
          .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB), .t3_fwrdB(t3_fwrdB), .t3_serrB(t3_serrB), .t3_derrB(t3_derrB), .t3_padrB(t3_padrB));

`ifdef FORMAL

//wire [BITADDR-1:0] select_addr;
//wire [BITWDTH-1:0] select_bit;
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr==0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit==0));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_2rw_2ror1w_a52 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPBNK     (BITPBNK),
     .BITPADR     (BITPADR),
     .REFRESH     (REFRESH),
     .ECCBITS     (ECCBITS),
     .SDOUT_WIDTH (SDOUT_WIDTH),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);

ip_top_sva_2_2rw_2ror1w_a52 #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .REFRESH     (REFRESH),
     .ECCBITS     (ECCBITS),
     .SDOUT_WIDTH (SDOUT_WIDTH))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_2rw_2ror1w_a52 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPBNK     (BITPBNK),
     .BITPADR     (BITPADR),
     .REFRESH     (REFRESH),
     .ECCBITS     (ECCBITS),
     .SDOUT_WIDTH (SDOUT_WIDTH),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

ip_top_sva_2_2rw_2ror1w_a52 #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .REFRESH     (REFRESH),
     .ECCBITS     (ECCBITS),
     .SDOUT_WIDTH (SDOUT_WIDTH))
ip_top_sva_2 (.*);

`endif


endmodule
