
module algo_1r1w_rl2_a721 (clk, rst, ready, refr,
                           write, wr_adr, din,
	                   read, rd_adr, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
	                   t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA, t1_fwrdA, t1_serrA, t1_derrA, t1_padrA, t1_refrB,
                           t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_serrB, t2_derrB, t2_padrB,
		           select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPSDO = 1;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter BITPADR = 14;
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter REFRESH = 0;
  parameter REFFREQ = 16;

  parameter SDOUT_WIDTH = BITVBNK+1;

  input                                refr;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input                                read;
  input [BITADDR-1:0]                  rd_adr;
  output                               rd_vld;
  output [WIDTH-1:0]                   rd_dout;
  output                               rd_fwrd;
  output                               rd_serr;
  output                               rd_derr;
  output [BITPADR-1:0]                 rd_padr;

  input                                clk;
  input                                rst;
  output                               ready;

  input [BITADDR-1:0]                  select_addr;
  input [BITWDTH-1:0]                  select_bit;

  output [NUMVBNK-1:0] t1_readA;
  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMVBNK*WIDTH-1:0] t1_dinA;
  input [NUMVBNK*WIDTH-1:0] t1_doutA;
  input [NUMVBNK-1:0] t1_fwrdA;
  input [NUMVBNK-1:0] t1_serrA;
  input [NUMVBNK-1:0] t1_derrA;
  input [NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrA;
  output [NUMVBNK-1:0] t1_refrB;

  output [2-1:0] t2_writeA;
  output [2*BITVROW-1:0] t2_addrA;
  output [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA;

  output [2-1:0] t2_readB;
  output [2*BITVROW-1:0] t2_addrB;
  input [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB;
  input [2-1:0] t2_fwrdB;
  input [2-1:0] t2_serrB;
  input [2-1:0] t2_derrB;
  input [2*(BITPADR-BITPBNK)-1:0] t2_padrB;

wire                               pwrite;
wire [BITVBNK-1:0]                 pwrbadr;
wire [BITVROW-1:0]                 pwrradr;
wire [WIDTH-1:0]                   pdin;
wire                               pread;
wire [BITVBNK-1:0]                 prdbadr;
wire [BITVROW-1:0]                 prdradr;
wire                               pdout_fwrd;
wire                               pdout_serr;
wire                               pdout_derr;
wire [BITPADR-BITPBNK-1:0]         pdout_padr;
wire [WIDTH-1:0]                   pdout;
wire                               swrite;
wire [BITVROW-1:0]                 swrradr;
wire [SDOUT_WIDTH+WIDTH-1:0]       sdin;
wire                               sread1;
wire [BITVROW-1:0]                 srdradr1;
wire [SDOUT_WIDTH+WIDTH-1:0]       sdout1;
wire                               sdout1_fwrd;
wire                               sdout1_serr;
wire                               sdout1_derr;
wire [BITPADR-BITPBNK-1:0]         sdout1_padr;
wire                               sread2;
wire [BITVROW-1:0]                 srdradr2;
wire [SDOUT_WIDTH+WIDTH-1:0]       sdout2;
wire                               sdout2_fwrd;
wire                               sdout2_serr;
wire                               sdout2_derr;
wire [BITPADR-BITPBNK-1:0]         sdout2_padr;

core_1r1w_rl2_a721 #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPSDO (ENAPSDO), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                     .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                     .BITPBNK (BITPBNK), .BITPADR (BITPADR), .REFRESH (REFRESH),
                     .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
       core (.vrefr (refr),
             .vread (read), .vrdaddr (rd_adr), .vread_vld (rd_vld), .vdout (rd_dout),
             .vread_fwrd (rd_fwrd), .vread_serr (rd_serr), .vread_derr (rd_derr), .vread_padr (rd_padr),
             .vwrite (write), .vwraddr (wr_adr), .vdin (din),
             .prefr (prefr),
             .pwrite (pwrite), .pwrbadr (pwrbadr), .pwrradr (pwrradr), .pdin (pdin),
             .pread (pread), .prdbadr (prdbadr), .prdradr (prdradr), .pdout (pdout),
             .pdout_fwrd (pdout_fwrd), .pdout_serr (pdout_serr), .pdout_derr (pdout_derr), .pdout_padr (pdout_padr),
             .swrite (swrite), .swrradr (swrradr), .ddin (sdin[WIDTH-1:0]), .sdin (sdin[SDOUT_WIDTH+WIDTH-1:WIDTH]),
             .sread1 (sread1), .srdradr1 (srdradr1), .ddout1 (sdout1[WIDTH-1:0]), .sdout1 (sdout1[SDOUT_WIDTH+WIDTH-1:WIDTH]),
             .ddout1_fwrd (sdout1_fwrd), .ddout1_serr (sdout1_serr), .ddout1_derr (sdout1_derr), .ddout1_padr (sdout1_padr),
             .sread2 (sread2), .srdradr2 (srdradr2), .ddout2 (sdout2[WIDTH-1:0]), .sdout2 (sdout2[SDOUT_WIDTH+WIDTH-1:WIDTH]),
             .ddout2_fwrd (sdout2_fwrd), .ddout2_serr (sdout2_serr), .ddout2_derr (sdout2_derr), .ddout2_padr (sdout2_padr),
             .ready (ready), .clk (clk), .rst (rst),
	     .select_addr (select_addr), .select_bit (select_bit));

mux_1r1w_rl2_a721 #(.WIDTH (WIDTH), .BITWDTH (BITWDTH),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPADR (BITPADR-BITPBNK),
               .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY))
    mux  (.clk(clk), .rst(rst), 
          .prefr(prefr),
          .pwrite(pwrite), .pwrbadr(pwrbadr), .prdbadr(prdbadr), .pdin(pdin),
          .pread(pread), .pwrradr(pwrradr), .prdradr(prdradr), .pdout(pdout),
          .pdout_fwrd (pdout_fwrd), .pdout_serr (pdout_serr), .pdout_derr (pdout_derr), .pdout_padr (pdout_padr),
          .swrite(swrite), .swrradr(swrradr), .sdin(sdin),
          .sread1(sread1), .srdradr1(srdradr1), .sdout1(sdout1),
          .sdout1_fwrd (sdout1_fwrd), .sdout1_serr (sdout1_serr), .sdout1_derr (sdout1_derr), .sdout1_padr (sdout1_padr),
          .sread2(sread2), .srdradr2(srdradr2), .sdout2(sdout2),
          .sdout2_fwrd (sdout2_fwrd), .sdout2_serr (sdout2_serr), .sdout2_derr (sdout2_derr), .sdout2_padr (sdout2_padr),
          .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA),
          .t1_fwrdA(t1_fwrdA), .t1_serrA(t1_serrA), .t1_derrA(t1_derrA), .t1_padrA(t1_padrA), .t1_refrB(t1_refrB),
          .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
          .t2_fwrdB(t2_fwrdB), .t2_serrB(t2_serrB), .t2_derrB(t2_derrB), .t2_padrB(t2_padrB));

`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_1r1w_rl2_a721 #(
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
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);

ip_top_sva_2_1r1w_rl2_a721 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPSDO     (ENAPSDO),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .REFRESH     (REFRESH),
     .REFFREQ     (REFFREQ),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_1r1w_rl2_a721 #(
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
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

ip_top_sva_2_1r1w_rl2_a721 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPSDO     (ENAPSDO),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .REFRESH     (REFRESH),
     .REFFREQ     (REFFREQ),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY))
ip_top_sva_2 (.*);

`endif

endmodule
