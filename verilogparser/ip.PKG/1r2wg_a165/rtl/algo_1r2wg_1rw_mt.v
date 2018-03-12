
module algo_1r2wg_1rw_mt (read, rd_adr, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
                          write, wr_adr, din,
	                  t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA, t1_fwrdA, t1_serrA, t1_derrA, t1_padrA,
	                  t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_serrB, t2_derrB, t2_padrB, 
	                  clk, rst, ready,
	                  select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMWRPT = 2;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMPBNK = 11;
  parameter BITPBNK = 4;
  parameter BITPADR = 15;
  parameter REFRESH = 0;

  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 1;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter BITMAPT = BITPBNK*(NUMPBNK-NUMWRPT+1);

  input                        read;
  input [BITADDR-1:0]          rd_adr;
  output                       rd_vld;
  output [WIDTH-1:0]           rd_dout;
  output                       rd_fwrd;
  output                       rd_serr;
  output                       rd_derr;
  output [BITPADR-1:0]         rd_padr;

  input [NUMWRPT-1:0]          write;
  input [NUMWRPT*BITADDR-1:0]  wr_adr;
  input [NUMWRPT*WIDTH-1:0]    din;

  output                       ready;
  input                        clk;
  input                        rst;

  input [BITADDR-1:0]          select_addr;
  input [BITWDTH-1:0]          select_bit;

  output [NUMPBNK-1:0] t1_readA;
  output [NUMPBNK-1:0] t1_writeA;
  output [NUMPBNK*BITVROW-1:0] t1_addrA;
  output [NUMPBNK*WIDTH-1:0] t1_dinA;
  input [NUMPBNK*WIDTH-1:0] t1_doutA;
  input [NUMPBNK-1:0] t1_fwrdA;
  input [NUMPBNK-1:0] t1_serrA;
  input [NUMPBNK-1:0] t1_derrA;
  input [NUMPBNK*(BITPADR-BITPBNK)-1:0] t1_padrA;

  output [4*NUMWRPT-1:0] t2_writeA;
  output [4*NUMWRPT*BITVROW-1:0] t2_addrA;
  output [4*NUMWRPT*BITMAPT-1:0] t2_dinA;

  output [4*NUMWRPT-1:0] t2_readB;
  output [4*NUMWRPT*BITVROW-1:0] t2_addrB;
  input [4*NUMWRPT*BITMAPT-1:0] t2_doutB;
  input [4*NUMWRPT-1:0] t2_fwrdB;
  input [4*NUMWRPT-1:0] t2_serrB;
  input [4*NUMWRPT-1:0] t2_derrB;
  input [4*NUMWRPT*(BITPADR-BITPBNK)-1:0] t2_padrB;

wire [NUMWRPT-1:0]                  pwrite;
wire [NUMWRPT*BITPBNK-1:0]          pwrbadr;
wire [NUMWRPT*BITVROW-1:0]          pwrradr;
wire [NUMWRPT*WIDTH-1:0]            pdin;
wire                                pread;
wire [BITPBNK-1:0]                  prdbadr;
wire [BITVROW-1:0]                  prdradr;
wire [WIDTH-1:0]                    pdout;
wire                                pdout_fwrd;
wire                                pdout_serr;
wire                                pdout_derr;
wire [BITPADR-1:0]                  pdout_padr;
wire [NUMWRPT-1:0]                  swrite;
wire [NUMWRPT*BITVROW-1:0]          swrradr;
wire [NUMWRPT*BITMAPT-1:0]          sdin;
wire [2*NUMWRPT-1:0]                sread;
wire [2*NUMWRPT*BITVROW-1:0]        srdradr;
wire [2*NUMWRPT*BITMAPT-1:0]        sdout;

core_1r2wg_1rw_mt #(.WIDTH (WIDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                    .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .NUMPBNK (NUMPBNK), .BITPBNK (BITPBNK),
                    .SRAM_DELAY (SRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    core (.vwrite0 (write[0]), .vwraddr0 (wr_adr[BITADDR-1:0]), .vdin0 (din[WIDTH-1:0]),
          .vwrite1 (write[1]), .vwraddr1 (wr_adr[2*BITADDR-1:BITADDR]), .vdin1 (din[2*WIDTH-1:WIDTH]),
          .vread (read), .vrdaddr (rd_adr), .vdout (rd_dout),
          .pwrite0 (pwrite[0]), .pwraddr0 ({pwrbadr[BITPBNK-1:0],pwrradr[BITVROW-1:0]}), .pdin0 (pdin[WIDTH-1:0]),
          .pwrite1 (pwrite[1]), .pwraddr1 ({pwrbadr[2*BITPBNK-1:BITPBNK],pwrradr[2*BITVROW-1:BITVROW]}), .pdin1 (pdin[2*WIDTH-1:WIDTH]),
          .pread (pread), .prdaddr ({prdbadr,prdradr}), .pdout (pdout),
          .swrite0 (t2_writeA[0]), .swrradr0 (t2_addrA[BITVROW-1:0]), .sdin0 (t2_dinA[BITMAPT-1:0]),
          .swrite1 (t2_writeA[4]), .swrradr1 (t2_addrA[5*BITVROW-1:4*BITVROW]), .sdin1(t2_dinA[5*BITMAPT-1:4*BITMAPT]),
          .sread0 (t2_readB[0]), .srdradr0 (t2_addrB[BITVROW-1:0]), .sdout0 (t2_doutB[BITMAPT-1:0]), .sserr0 (t2_serrB[0]), .sderr0 (t2_derrB[0]),
          .sread1 (t2_readB[1]), .srdradr1 (t2_addrB[2*BITVROW-1:BITVROW]), .sdout1 (t2_doutB[2*BITMAPT-1:BITMAPT]), .sserr1 (t2_serrB[1]), .sderr1 (t2_derrB[1]),
          .sread2 (t2_readB[2]), .srdradr2 (t2_addrB[3*BITVROW-1:2*BITVROW]), .sdout2 (t2_doutB[3*BITMAPT-1:2*BITMAPT]), .sserr2 (t2_serrB[2]), .sderr2 (t2_derrB[2]),
          .sread3 (t2_readB[3]), .srdradr3 (t2_addrB[4*BITVROW-1:3*BITVROW]), .sdout3 (t2_doutB[4*BITMAPT-1:3*BITMAPT]), .sserr3 (t2_serrB[3]), .sderr3 (t2_derrB[3]),
          .sread4 (t2_readB[4]), .srdradr4 (t2_addrB[5*BITVROW-1:4*BITVROW]), .sdout4 (t2_doutB[5*BITMAPT-1:4*BITMAPT]), .sserr4 (t2_serrB[4]), .sderr4 (t2_derrB[4]),
          .sread5 (t2_readB[5]), .srdradr5 (t2_addrB[6*BITVROW-1:5*BITVROW]), .sdout5 (t2_doutB[6*BITMAPT-1:5*BITMAPT]), .sserr5 (t2_serrB[5]), .sderr5 (t2_derrB[5]),
          .sread6 (t2_readB[6]), .srdradr6 (t2_addrB[7*BITVROW-1:6*BITVROW]), .sdout6 (t2_doutB[7*BITMAPT-1:6*BITMAPT]), .sserr6 (t2_serrB[6]), .sderr6 (t2_derrB[6]),
          .sread7 (t2_readB[7]), .srdradr7 (t2_addrB[8*BITVROW-1:7*BITVROW]), .sdout7 (t2_doutB[8*BITMAPT-1:7*BITMAPT]), .sserr7 (t2_serrB[7]), .sderr7 (t2_derrB[7]),
          .ready (ready), .clk (clk), .rst (rst));

assign t2_writeA[4-1:1] = {3{t2_writeA[0]}};
assign t2_addrA[4*BITVROW-1:BITVROW] = {3{t2_addrA[BITVROW-1:0]}};
assign t2_dinA[4*BITMAPT-1:BITMAPT] = {3{t2_dinA[BITMAPT-1:0]}};
assign t2_writeA[8-1:5] = {3{t2_writeA[4]}};
assign t2_addrA[8*BITVROW-1:5*BITVROW] = {3{t2_addrA[5*BITVROW-1:4*BITVROW]}};
assign t2_dinA[8*BITMAPT-1:5*BITMAPT] = {3{t2_dinA[5*BITMAPT-1:4*BITMAPT]}};

reg pread_reg [0:DRAM_DELAY-1];
integer prdd_int;
always @(posedge clk)
  for (prdd_int=0; prdd_int<DRAM_DELAY; prdd_int=prdd_int+1)
    if (prdd_int>0)
      pread_reg[prdd_int] <= pread_reg[prdd_int-1];
    else
      pread_reg[prdd_int] <= pread;

assign rd_vld = pread_reg[DRAM_DELAY-1];
assign rd_fwrd = pdout_fwrd;
assign rd_serr = pdout_serr;
assign rd_derr = pdout_derr;
assign rd_padr = pdout_padr;

mux_1rnwg_1rw_mt #(.WIDTH (WIDTH), .NUMWRPT (NUMWRPT),
                   .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMPBNK (NUMPBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR),
                   .DRAM_DELAY (DRAM_DELAY))
    mux (.clk(clk), .rst(rst), 
         .pwrite(pwrite), .pwrbadr(pwrbadr), .pwrradr(pwrradr), .pdin(pdin),
         .pread(pread), .prdbadr(prdbadr), .prdradr(prdradr), .pdout(pdout),
         .pdout_fwrd(pdout_fwrd), .pdout_serr(pdout_serr), .pdout_derr(pdout_derr), .pdout_padr (pdout_padr),
         .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA),
         .t1_doutA(t1_doutA), .t1_fwrdA(t1_fwrdA), .t1_serrA(t1_serrA), .t1_derrA(t1_derrA), .t1_padrA(t1_padrA));


`ifdef FORMAL

//wire [BITADDR-1:0] select_addr;
//wire [BITWDTH-1:0] select_bit;
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr==0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit==0));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_1rnwg_1rw_mt #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWRPT     (NUMWRPT),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);


ip_top_sva_2_1rnwg_1rw_mt #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWRPT     (NUMWRPT),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_1rnwg_1rw_mt #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWRPT     (NUMWRPT),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

ip_top_sva_2_1rnwg_1rw_mt #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWRPT     (NUMWRPT),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW))
ip_top_sva_2 (.*);

`endif

endmodule
