
module algo_1r1we_rl2_pseudo (clk, rst, ready, refr,
                              write, wr_adr, bw, din,
	                      read, rd_adr, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
                              t1_writeA, t1_bankA, t1_addrA, t1_bwA, t1_dinA,
                              t1_readB, t1_bankB, t1_addrB, t1_doutB, t1_padrB, t1_refrC,
                              t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
		              select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
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

  parameter SDOUT_WIDTH = WIDTH+BITVBNK;

  input                                refr;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    bw;
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

  output t1_writeA;
  output [BITVBNK-1:0] t1_bankA;
  output [BITVROW-1:0] t1_addrA;
  output [WIDTH-1:0] t1_bwA;
  output [WIDTH-1:0] t1_dinA;
  output t1_readB;
  output [BITVBNK-1:0] t1_bankB;
  output [BITVROW-1:0] t1_addrB;
  input [WIDTH-1:0] t1_doutB;
  input [(BITPADR-BITPBNK)-1:0] t1_padrB;
  output t1_refrC;

  output [2-1:0] t2_writeA;
  output [2*BITVROW-1:0] t2_addrA;
  output [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_bwA;
  output [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA;

  output [2-1:0] t2_readB;
  output [2*BITVROW-1:0] t2_addrB;
  input [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB;

wire                                 pwrite;
wire [BITVBNK-1:0]                   pwrbadr;
wire [BITVROW-1:0]                   pwrradr;
wire [WIDTH-1:0]                     pbwe;
wire [WIDTH-1:0]                     pdin;
wire                                 pread;
wire [BITVBNK-1:0]                   prdbadr;
wire [BITVROW-1:0]                   prdradr;
wire [BITPADR-BITPBNK-1:0]           ppadr;
wire [WIDTH-1:0]                     pdout;
wire                                 swrite;
wire [BITVROW-1:0]                   swrradr;
wire [SDOUT_WIDTH-1:0]               sdin;
wire [WIDTH-1:0]                     cbwe;
wire [WIDTH-1:0]                     cdin;
wire                                 sread1;
wire [BITVROW-1:0]                   srdradr1;
wire [SDOUT_WIDTH-1:0]               sdout1;
wire [WIDTH-1:0]                     cdout1;
wire                                 sread2;
wire [BITVROW-1:0]                   srdradr2;
wire [SDOUT_WIDTH-1:0]               sdout2;
wire [WIDTH-1:0]                     cdout2;

core_1r1we_rl2 #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .BITPBNK (BITPBNK), .BITPADR (BITPADR), .REFRESH (REFRESH),
                 .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
       core (.vrefr (refr),
             .vread (read), .vrdaddr (rd_adr), .vread_vld (rd_vld), .vdout (rd_dout),
             .vread_fwrd (rd_fwrd), .vread_serr (rd_serr), .vread_derr (rd_derr), .vread_padr (rd_padr),
             .vwrite (write), .vwraddr (wr_adr), .vbwe (bw), .vdin (din),
             .prefr (prefr),
             .pwrite (pwrite), .pwrbadr (pwrbadr), .pwrradr (pwrradr), .pbwe (pbwe), .pdin (pdin),
             .pread (pread), .prdbadr (prdbadr), .prdradr (prdradr), .pdout (pdout), .ppadr (ppadr),
             .swrite (swrite), .swrradr (swrradr), .sdin (sdin), .cbwe (cbwe), .cdin (cdin),
             .sread1 (sread1), .srdradr1 (srdradr1), .sdout1 (sdout1), .cdout1 (cdout1),
             .sread2 (sread2), .srdradr2 (srdradr2), .sdout2 (sdout2), .cdout2 (cdout2),
             .ready (ready), .clk (clk), .rst (rst),
	     .select_addr (select_addr));

mux_1r1we_rl2_pseudo #(.WIDTH (WIDTH), .BITWDTH (BITWDTH),
                       .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPADR (BITPADR-BITPBNK),
                       .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY))
    mux  (.clk(clk), .rst(rst), 
          .prefr(prefr),
          .pwrite(pwrite), .pwrbadr(pwrbadr), .prdbadr(prdbadr), .pbwe(pbwe), .pdin(pdin),
          .pread(pread), .pwrradr(pwrradr), .prdradr(prdradr), .pdout(pdout), .ppadr(ppadr),
          .swrite(swrite), .swrradr(swrradr), .sdin(sdin), .cbwe(cbwe), .cdin(cdin),
          .sread1(sread1), .srdradr1(srdradr1), .sdout1(sdout1), .cdout1(cdout1),
          .sread2(sread2), .srdradr2(srdradr2), .sdout2(sdout2), .cdout2(cdout2),
          .t1_writeA(t1_writeA), .t1_bankA(t1_bankA), .t1_addrA(t1_addrA), .t1_bwA(t1_bwA), .t1_dinA(t1_dinA),
          .t1_readB(t1_readB), .t1_bankB(t1_bankB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB), .t1_padrB(t1_padrB),
          .t1_refrC(t1_refrC),
          .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_bwA(t2_bwA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB));


`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_1r1we_rl2_pseudo #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
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

ip_top_sva_2_1r1we_rl2_pseudo #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
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
ip_top_sva_1r1we_rl2_pseudo #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
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
ip_top_sva (.select_addr(help_addr), .select_bit(help_bit), .*);
end
endgenerate

ip_top_sva_2_1r1we_rl2_pseudo #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
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
