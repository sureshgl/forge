
module algo_2rw_rl_edram_del (vrefr, vread, vwrite, vaddr, vdin, vread_vld, vdout, vread_serr, vread_derr, vread_padr, 
                              pwrite, pwrbadr, pwrradr, pdin,
                              pread1, prdbadr1, prdradr1, pdout1, pdout1_serr, pdout1_derr, pdout1_padr,
                              pread2, prdbadr2, prdradr2, pdout2, pdout2_serr, pdout2_derr, pdout2_padr,
                              prefr, prfbadr,
                              request, xnorefr, xstop, xstbadr,
                              swrite, swrradr, sdin,
                              sread, srdradr, sdout,
                              cwrite, cwrradr, cdin,
                              cread, crdradr, cdout,
	                      ready, clk, rst, 
			      select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;

  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;

  parameter NUMMBNK = 4;
  parameter BITMBNK = 2;
  parameter NUMMROW = 256;
  parameter BITMROW = 8;
 
  parameter REFRESH = 0;
  parameter NUMRBNK = 4;
  parameter BITRBNK = 2;
  parameter BITPADR = 17;
  parameter ECCBITS = 4;

  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input                        vrefr;

  input                        vread;
  input                        vwrite;
  input [BITADDR-1:0]          vaddr;
  input [WIDTH-1:0]            vdin;
  output                       vread_vld;
  output [WIDTH-1:0]           vdout;
  output                       vread_serr;
  output                       vread_derr;
  output [BITPADR-1:0]         vread_padr;

  output                       pwrite;
  output [BITVBNK-1:0]         pwrbadr;
  output [BITVROW-1:0]         pwrradr;
  output [WIDTH-1:0]           pdin;

  output                       pread1;
  output [BITVBNK-1:0]         prdbadr1;
  output [BITVROW-1:0]         prdradr1;
  input [WIDTH-1:0]            pdout1;
  input                        pdout1_serr;
  input                        pdout1_derr;
  input [BITPADR-2:0]          pdout1_padr;

  output                       pread2;
  output [BITVBNK-1:0]         prdbadr2;
  output [BITVROW-1:0]         prdradr2;
  input [WIDTH-1:0]            pdout2;
  input                        pdout2_serr;
  input                        pdout2_derr;
  input [BITPADR-2:0]          pdout2_padr;

  output                       prefr;
  output [BITRBNK-1:0]         prfbadr;

  output                       request;
  output                       xnorefr;
  output                       xstop;
  output [BITVBNK-1:0]         xstbadr;

  output                       swrite;
  output [BITVROW-1:0]         swrradr;
  output [SDOUT_WIDTH-1:0]     sdin;

  output                       sread;
  output [BITVROW-1:0]         srdradr;
  input [SDOUT_WIDTH-1:0]      sdout;

  output                       cwrite;
  output [BITVROW-1:0]         cwrradr;
  output [WIDTH-1:0]           cdin;

  output                       cread;
  output [BITVROW-1:0]         crdradr;
  input [WIDTH-1:0]            cdout;

  output                       ready;
  input                        clk;
  input                        rst;

  input [BITADDR-1:0] select_addr;
  input [BITWDTH-1:0] select_bit;


  core_2rw_rl_edram_del #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                          .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
		          .REFRESH (REFRESH), .NUMRBNK (NUMRBNK), .BITRBNK (BITRBNK), .BITPADR (BITPADR),
                          .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY+1), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT), .ECCBITS (ECCBITS))
      core (.vrefr (vrefr), .vread (vread), .vwrite (vwrite), .vaddr (vaddr), .vdin (vdin),
	    .vread_vld (vread_vld), .vdout (vdout), .vread_serr (vread_serr), .vread_derr (vread_derr), .vread_padr (vread_padr),
            .pwrite (pwrite), .pwrbadr (pwrbadr), .pwrradr (pwrradr), .pdin (pdin),
            .pread1 (pread1), .prdbadr1 (prdbadr1), .prdradr1 (prdradr1), .pdout1 (pdout1),
            .pdout1_serr (pdout1_serr), .pdout1_derr (pdout1_derr), .pdout1_padr (pdout1_padr),
            .pread2 (pread2), .prdbadr2 (prdbadr2), .prdradr2 (prdradr2), .pdout2 (pdout2),
            .pdout2_serr (pdout2_serr), .pdout2_derr (pdout2_derr), .pdout2_padr (pdout2_padr),
	    .prefr (prefr), .prfbadr (prfbadr), .request (request), .xnorefr (xnorefr), .xstop (xstop), .xstbadr (xstbadr),
            .swrite (swrite), .swrradr (swrradr), .sdin (sdin),
            .sread (sread), .srdradr (srdradr), .sdout (sdout),
            .cwrite (cwrite), .cwrradr (cwrradr), .cdin (cdin),
            .cread (cread), .crdradr (crdradr), .cdout (cdout),
            .ready (ready), .clk (clk), .rst (rst),
	    .select_addr (select_addr), .select_bit (select_bit));


`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_2rw_rl_edram_del #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .ECCBITS     (ECCBITS),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);

ip_top_sva_2_2rw_rl_edram_del #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .BITWDTH     (BITWDTH),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMMROW     (NUMMROW),
     .BITMROW     (BITMROW),
     .NUMMBNK     (NUMMBNK),
     .ECCBITS     (ECCBITS))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_2rw_rl_edram_del #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .ECCBITS     (ECCBITS),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

ip_top_sva_2_2rw_rl_edram_del #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .BITWDTH     (BITWDTH),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMMROW     (NUMMROW),
     .BITMROW     (BITMROW),
     .NUMMBNK     (NUMMBNK),
     .ECCBITS     (ECCBITS))
ip_top_sva_2 (.*);

`endif

endmodule
