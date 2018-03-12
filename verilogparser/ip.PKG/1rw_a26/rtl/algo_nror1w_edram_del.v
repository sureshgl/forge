
module algo_nror1w_edram_del (clk, rst, ready,
		              refr, rf_bnk, request, xnorefr, xstop, xstbadr,
                              write, wr_bnk, wr_adr, din,
                              read, rd_bnk, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
	                      t1_readA, t1_writeA, t1_bankA, t1_addrA, t1_dinA, t1_doutA, t1_serrA, t1_derrA, t1_padrA, t1_refrB, t1_bankB,
	                      t2_readA, t2_writeA, t2_bankA, t2_addrA, t2_dinA, t2_doutA, t2_serrA, t2_derrA, t2_padrA, t2_refrB, t2_bankB, 
	                      select_rbnk, select_addr, select_bit);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVRPT = 4;
  parameter NUMPRPT = 2;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter BITPADR = 15;
  parameter NUMRBNK = 4;
  parameter BITRBNK = 2;
  parameter REFRESH = 0;
  parameter NUMXBNK = 4;
  parameter BITXBNK = 2;
  parameter REFFREQ = 10;

  parameter SRAM_DELAY = 2;
  parameter FLOPOUT = 0;

  input                                refr;
  input [BITXBNK-1:0]                  rf_bnk;

  input                                request;
  input                                xnorefr;
  input                                xstop;
  input [BITRBNK-1:0]                  xstbadr;

  input                                write;
  input [BITRBNK-1:0]                  wr_bnk;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input [NUMVRPT-1:0]                  read;
  input [NUMVRPT*BITRBNK-1:0]          rd_bnk;
  input [NUMVRPT*BITADDR-1:0]          rd_adr;
  output [NUMVRPT-1:0]                 rd_vld;
  output [NUMVRPT*WIDTH-1:0]           rd_dout;
  output [NUMVRPT-1:0]                 rd_serr;
  output [NUMVRPT-1:0]                 rd_derr;
  output [NUMVRPT*BITPADR-1:0]         rd_padr;

  output                               ready;
  input                                clk, rst;

  input [BITRBNK-1:0]                  select_rbnk;
  input [BITADDR-1:0]                  select_addr;
  input [BITWDTH-1:0]                  select_bit;

  output [NUMPRPT*NUMVBNK-1:0]         t1_readA;
  output [NUMPRPT*NUMVBNK-1:0]         t1_writeA;
  output [NUMPRPT*NUMVBNK*BITRBNK-1:0] t1_bankA;
  output [NUMPRPT*NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMPRPT*NUMVBNK*WIDTH-1:0]   t1_dinA;
  input [NUMPRPT*NUMVBNK*WIDTH-1:0]    t1_doutA;
  input [NUMPRPT*NUMVBNK-1:0]          t1_serrA;
  input [NUMPRPT*NUMVBNK-1:0]          t1_derrA;
  input [NUMPRPT*NUMVBNK*(BITPADR-BITPBNK-1)-1:0]  t1_padrA;
  output [NUMPRPT*NUMVBNK-1:0]         t1_refrB;
  output [NUMPRPT*NUMVBNK*BITXBNK-1:0] t1_bankB;

  output [NUMPRPT-1:0]                 t2_readA;
  output [NUMPRPT-1:0]                 t2_writeA;
  output [NUMPRPT*BITRBNK-1:0]         t2_bankA;
  output [NUMPRPT*BITVROW-1:0]         t2_addrA;
  output [NUMPRPT*WIDTH-1:0]           t2_dinA;
  input [NUMPRPT*WIDTH-1:0]            t2_doutA;
  input [NUMPRPT-1:0]                  t2_serrA;
  input [NUMPRPT-1:0]                  t2_derrA;
  input [NUMPRPT*(BITPADR-BITPBNK-1)-1:0]  t2_padrA;
  output [NUMPRPT-1:0]                 t2_refrB;
  output [NUMPRPT*BITXBNK-1:0]         t2_bankB;

  core_nror1w_edram_del #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMVRPT(NUMVRPT), .NUMPRPT(NUMPRPT),
                          .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR),
	      	          .NUMRBNK (NUMRBNK), .BITRBNK (BITRBNK), .REFRESH (REFRESH), .NUMXBNK (NUMXBNK), .BITXBNK (BITXBNK),
                          .SRAM_DELAY (SRAM_DELAY), .FLOPOUT (FLOPOUT))
      core (.vrefr(refr), .vrfrbnk (rf_bnk), .request (request), .xnorefr (xnorefr), .xstop (xstop), .xstbadr (xstbadr),
	    .vwrite(write), .vwrrbnk (wr_bnk), .vwraddr(wr_adr), .vdin(din),
	    .vread(read), .vrdrbnk (rd_bnk), .vrdaddr(rd_adr), .vread_vld(rd_vld), .vdout(rd_dout), .vread_serr(rd_serr), .vread_derr(rd_derr), .vread_padr(rd_padr),
            .prefr(t1_refrB), .prfrbnk(t1_bankB),
	    .pwrite(t1_writeA), .pread(t1_readA), .prbnk (t1_bankA), .pradr(t1_addrA),
	    .pdin (t1_dinA), .pdout (t1_doutA), .pdout_serr (t1_serrA), .pdout_derr (t1_derrA), .pdout_padr (t1_padrA),
            .xrefr(t2_refrB), .xrfrbnk (t2_bankB), .xwrite(t2_writeA), .xread(t2_readA), .xrbnk (t2_bankA), .xradr(t2_addrA),
	    .xdin (t2_dinA), .xdout (t2_doutA), .xdout_serr (t2_serrA), .xdout_derr (t2_derrA), .xdout_padr (t2_padrA),
	    .ready (ready), .clk (clk), .rst (rst), .select_bit (select_bit));

`ifdef FORMAL
assume_select_rbnk_range: assume property (@(posedge clk) disable iff (rst) (select_rbnk < NUMRBNK));
assume_select_rbnk_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_rbnk));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_nror1w_edram_del #(
     .WIDTH       (WIDTH),
     .NUMVRPT     (NUMVRPT),
     .NUMPRPT     (NUMPRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .BITWDTH     (BITWDTH),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPBNK     (BITPBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .BITPADR     (BITPADR),
     .NUMRBNK     (NUMRBNK),
     .BITRBNK     (BITRBNK),
     .SRAM_DELAY  (SRAM_DELAY))
ip_top_sva (.*);

ip_top_sva_2_nror1w_edram_del #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVRPT     (NUMVRPT),
     .NUMPRPT     (NUMPRPT),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMRBNK     (NUMRBNK),
     .BITRBNK     (BITRBNK),
     .REFRESH     (REFRESH),
     .REFFREQ     (REFFREQ))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
// generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin: sva_loop
  wire [BITRBNK-1:0] help_rbnk = sva_int;
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_nror1w_edram_del #(
     .WIDTH       (WIDTH),
     .NUMVRPT     (NUMVRPT),
     .NUMPRPT     (NUMPRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .BITWDTH     (BITWDTH),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPBNK     (BITPBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .BITPADR     (BITPADR),
     .NUMRBNK     (NUMRBNK),
     .BITRBNK     (BITRBNK),
     .SRAM_DELAY  (SRAM_DELAY))
ip_top_sva (.select_rbnk (help_rbnk), .select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

ip_top_sva_2_nror1w_edram_del #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVRPT     (NUMVRPT),
     .NUMPRPT     (NUMPRPT),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMRBNK     (NUMRBNK),
     .BITRBNK     (BITRBNK),
     .REFRESH     (REFRESH),
     .REFFREQ     (REFFREQ))
ip_top_sva_2 (.*);

`endif

endmodule


