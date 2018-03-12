module algo_1r1w_mt_pseudo (refr, write, wr_adr, din,
                            read, rd_adr, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
                            t1_writeA, t1_bankA, t1_addrA, t1_dinA,
                            t1_readB, t1_bankB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB, t1_refrC,
                            t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_serrB, t2_derrB, t2_padrB,
	                    clk, rst, ready,
	                    select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;

  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMPBNK = 9;
  parameter BITPBNK = 4;
  parameter BITPADR = 14;

  parameter REFRESH = 0;
  parameter ECCBITS = 7;

  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 1;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter DISCORR = 0;

  parameter BITMAPT = BITPBNK*NUMPBNK;
  parameter SDOUT_WIDTH = 2*BITMAPT+ECCBITS;

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
  
  output t1_writeA;
  output [BITPBNK-1:0] t1_bankA;
  output [BITVROW-1:0] t1_addrA;
  output [WIDTH-1:0] t1_dinA;
  output t1_readB;
  output [BITPBNK-1:0] t1_bankB;
  output [BITVROW-1:0] t1_addrB;
  input [WIDTH-1:0] t1_doutB;
  input t1_fwrdB;
  input t1_serrB;
  input t1_derrB;
  input [(BITPADR-BITPBNK)-1:0] t1_padrB;
  output t1_refrC;

  output [2-1:0] t2_writeA;
  output [2*BITVROW-1:0] t2_addrA;
  output [2*SDOUT_WIDTH-1:0] t2_dinA;
  
  output [2-1:0] t2_readB;
  output [2*BITVROW-1:0] t2_addrB;
  input [2*SDOUT_WIDTH-1:0] t2_doutB;
  input [2-1:0] t2_fwrdB;
  input [2-1:0] t2_serrB;
  input [2-1:0] t2_derrB;
  input [2*(BITPADR-BITPBNK)-1:0] t2_padrB;

  wire                               prefr;
  wire                               pwrite;
  wire [BITPBNK-1:0]                 pwrbadr;
  wire [BITVROW-1:0]                 pwrradr;
  wire [WIDTH-1:0]                   pdin;
  wire                               pread;
  wire [BITPBNK-1:0]                 prdbadr;
  wire [BITVROW-1:0]                 prdradr;
  wire [WIDTH-1:0]                   pdout;
  wire                               pdout_fwrd;
  wire                               pdout_serr;
  wire                               pdout_derr;
  wire [BITPADR-1:0]                 pdout_padr;
  wire                               swrite;
  wire [BITVROW-1:0]                 swrradr;
  wire [SDOUT_WIDTH-1:0]             sdin;
  wire [2-1:0]                       sread;
  wire [2*BITVROW-1:0]               srdradr;
  wire [2*SDOUT_WIDTH-1:0]           sdout;
  wire [2-1:0]                       sdout_fwrd;
  wire [2-1:0]                       sdout_serr;
  wire [2-1:0]                       sdout_derr;
  wire [2*(BITPADR-BITPBNK)-1:0]     sdout_padr;

wire float_rd_vld;
wire [WIDTH-1:0] float_rd_dout;
wire float_rd_fwrd;
wire float_rd_serr;
wire float_rd_derr;
wire [BITPADR-1:0] float_rd_padr;

core_mrnrwpw_1rw_mt #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMRDPT (1), .NUMRWPT (0), .NUMWRPT (1),
                      .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .NUMPBNK (NUMPBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR),
                      .REFRESH (REFRESH), .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT),
                      .DISCORR (DISCORR), .ECCBITS (ECCBITS))
    core (.vrefr (refr), .vread ({1'b0,read}), .vwrite ({write,1'b0}), .vaddr ({wr_adr,rd_adr}), .vdin ({din,{WIDTH{1'b0}}}),
	  .vread_vld ({float_rd_vld,rd_vld}), .vdout ({float_rd_dout,rd_dout}), .vread_fwrd ({float_rd_fwrd,rd_fwrd}),
          .vread_serr ({float_rd_serr,rd_serr}), .vread_derr ({float_rd_derr,rd_derr}), .vread_padr ({float_rd_padr,rd_padr}),
          .prefr (prefr), .pwrite (pwrite), .pwrbadr (pwrbadr), .pwrradr (pwrradr), .pdin (pdin),
          .pread (pread), .prdbadr (prdbadr), .prdradr (prdradr), .pdout (pdout), .pdout_fwrd (pdout_fwrd),
          .pdout_serr (pdout_serr), .pdout_derr (pdout_derr), .pdout_padr (pdout_padr),
          .swrite (swrite), .swrradr (swrradr), .sdin (sdin),
          .sread (sread), .srdradr (srdradr), .sdout (sdout),
          .ready (ready), .clk (clk), .rst (rst),
	  .select_addr (select_addr), .select_bit (select_bit));

mux_1r1w_mt_pseudo #(.WIDTH (WIDTH), .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMPBNK (NUMPBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR),
                      .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .ECCBITS (ECCBITS))
    mux  (.clk(clk), .rst(rst),
          .prefr (prefr),
          .pwrite(pwrite), .pwrbadr(pwrbadr), .prdbadr(prdbadr), .pdin(pdin),
          .pread(pread), .pwrradr(pwrradr), .prdradr(prdradr), .pdout(pdout),
          .pdout_fwrd(pdout_fwrd), .pdout_serr(pdout_serr), .pdout_derr(pdout_derr), .pdout_padr(pdout_padr),
          .swrite(swrite), .swrradr(swrradr), .sdin(sdin),
          .sread(sread), .srdradr(srdradr), .sdout(sdout),
          .sdout_fwrd(sdout_fwrd), .sdout_serr(sdout_serr), .sdout_derr(sdout_derr), .sdout_padr(sdout_padr),
          .t1_writeA(t1_writeA), .t1_bankA(t1_bankA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA),
          .t1_readB(t1_readB), .t1_bankB(t1_bankB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
          .t1_fwrdB(t1_fwrdB), .t1_serrB(t1_serrB), .t1_derrB(t1_derrB), .t1_padrB(t1_padrB),
          .t1_refrC(t1_refrC),
          .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
          .t2_fwrdB(t2_fwrdB), .t2_serrB(t2_serrB), .t2_derrB(t2_derrB), .t2_padrB(t2_padrB));

`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_1r1w_mt_pseudo #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .BITPADR     (BITPADR),
     .ECCBITS     (ECCBITS),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);


ip_top_sva_2_1r1w_mt_pseudo #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .ECCBITS     (ECCBITS))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_1r1w_mt_pseudo #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .BITPADR     (BITPADR),
     .ECCBITS     (ECCBITS),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

ip_top_sva_2_1r1w_mt_pseudo #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .ECCBITS     (ECCBITS))
ip_top_sva_2 (.*);

`endif

endmodule
