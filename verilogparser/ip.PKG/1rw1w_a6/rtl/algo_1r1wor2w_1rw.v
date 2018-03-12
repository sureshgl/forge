
module algo_1r1wor2w_1rw (read, write, addr, din, rd_vld, rd_dout, rd_err,
	                  t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA,
	                  t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
	                  t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
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

  parameter ECCDWIDTH = 4;
  parameter ECCBITS = 4;

  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 1;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input [1-1:0]                read;
  input [2-1:0]                write;
  input [2*BITADDR-1:0]        addr;
  input [2*WIDTH-1:0]          din;
  output [1-1:0]               rd_vld;
  output [1*WIDTH-1:0]         rd_dout;
  output [1-1:0]               rd_err;

  output                       ready;
  input                        clk;
  input                        rst;

  input [BITADDR-1:0]          select_addr;
  input [BITWDTH-1:0]          select_bit;

  output [NUMVBNK-1:0] t1_readA;
  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMVBNK*WIDTH-1:0] t1_dinA;
  input [NUMVBNK*WIDTH-1:0] t1_doutA;

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
wire                               cread2;
wire [BITVROW-1:0]                 crdradr2;
wire [WIDTH-1:0]                   cdout2;

core_1r1wor2w_1rw #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                    .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                    .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .ECCDWIDTH(ECCDWIDTH), .ECCBITS (ECCBITS))
    core (
            .vread (read),
	    .vwrite (write),
	    .vaddr (addr),
	    .vdin (din),
	    .vread_vld (rd_vld),
	    .vdout (rd_dout),
	    .vread_err (rd_err),
            .pwrite1 (pwrite1),
            .pwrbadr1 (pwrbadr1),
            .pwrradr1 (pwrradr1),
            .pdin1 (pdin1),
            .pwrite2 (pwrite2),
            .pwrbadr2 (pwrbadr2),
            .pwrradr2 (pwrradr2),
            .pdin2 (pdin2),
            .pread1 (pread1),
            .prdbadr1 (prdbadr1),
            .prdradr1 (prdradr1),
            .pdout1 (pdout1),
            .swrite (swrite),
            .swrradr (swrradr),
            .sdin (sdin),
            .sread1 (sread1),
            .srdradr1 (srdradr1),
            .sdout1 (sdout1),
            .sread2 (sread2),
            .srdradr2 (srdradr2),
            .sdout2 (sdout2),
            .cwrite (cwrite),
            .cwrradr (cwrradr),
            .cdin (cdin),
            .cread1 (cread1),
            .crdradr1 (crdradr1),
            .cdout1 (cdout1),
            .cread2 (cread2),
            .crdradr2 (crdradr2),
            .cdout2 (cdout2),
            .ready (ready),
            .clk (clk),
            .rst (rst),
	    .select_addr (select_addr),
	    .select_bit (select_bit));

mux_1r1wor2w_1rw #(.WIDTH (WIDTH), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .NUMVROW (NUMVROW), .BITVROW (BITVROW),
                   .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .ECCBITS (ECCBITS))
    mux (.clk(clk), .rst(rst), 
         .pwrite1(pwrite1), .pwrbadr1(pwrbadr1), .pwrradr1(pwrradr1), .pdin1(pdin1),
         .pwrite2(pwrite2), .pwrbadr2(pwrbadr2), .pwrradr2(pwrradr2), .pdin2(pdin2),
         .pread1(pread1), .prdbadr1(prdbadr1), .prdradr1(prdradr1), .pdout1(pdout1),
         .swrite(swrite), .swrradr(swrradr), .sdin(sdin),
         .sread1(sread1), .srdradr1(srdradr1), .sdout1(sdout1),
         .sread2(sread2), .srdradr2(srdradr2), .sdout2(sdout2),
         .cwrite(cwrite), .cwrradr(cwrradr), .cdin(cdin),
         .cread1(cread1), .crdradr1(crdradr1), .cdout1(cdout1),
         .cread2(cread2), .crdradr2(crdradr2), .cdout2(cdout2),
         .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA),
         .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA),
         .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
         .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA),
         .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB));

`ifdef FORMAL

//wire [BITADDR-1:0] select_addr;
//wire [BITWDTH-1:0] select_bit;
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr==0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit==0));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_1r1wor2w_1rw #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .ECCDWIDTH   (ECCDWIDTH),
     .ECCBITS     (ECCBITS),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY))
ip_top_sva (.*);

//`else

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_1r1wor2w_1rw #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .ECCDWIDTH   (ECCDWIDTH),
     .ECCBITS     (ECCBITS),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

// `endif

ip_top_sva_2_1r1wor2w_1rw #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .ECCBITS     (ECCBITS))
ip_top_sva_2 (.*);

`elsif SIM_SVA
genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_1r1wor2w_1rw #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .ECCDWIDTH   (ECCDWIDTH),
     .ECCBITS     (ECCBITS),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate


ip_top_sva_2_1r1wor2w_1rw #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .ECCBITS     (ECCBITS))
ip_top_sva_2 (.*);

`endif

endmodule
