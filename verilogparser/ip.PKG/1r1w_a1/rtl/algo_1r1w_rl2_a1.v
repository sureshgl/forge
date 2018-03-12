module algo_1r1w_rl2_a1 (clk, rst, ready,
                      write, wr_adr, din,
	              read, rd_adr, rd_vld, rd_dout, rd_err,
	              t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA,
                      t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
		      select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter ECCDWIDTH = 4;
  parameter ECCBITS = 4;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input                                read;
  input [BITADDR-1:0]                  rd_adr;
  output                               rd_vld;
  output [WIDTH-1:0]                   rd_dout;
  output                               rd_err;

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

  output [2-1:0] t2_writeA;
  output [2*BITVROW-1:0] t2_addrA;
  output [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA;

  output [2-1:0] t2_readB;
  output [2*BITVROW-1:0] t2_addrB;
  input [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB;

wire                               pwrite;
wire [BITVBNK-1:0]                 pwrbadr;
wire [BITVROW-1:0]                 pwrradr;
wire [WIDTH-1:0]                   pdin;
wire                               pread;
wire [BITVBNK-1:0]                 prdbadr;
wire [BITVROW-1:0]                 prdradr;
wire [WIDTH-1:0]                   pdout;
wire                               swrite;
wire [BITVROW-1:0]                 swrradr;
wire [2*(BITVBNK+1)+ECCBITS+WIDTH-1:0]       sdin;
wire                               sread1;
wire [BITVROW-1:0]                 srdradr1;
wire [2*(BITVBNK+1)+ECCBITS+WIDTH-1:0]       sdout1;
wire                               sread2;
wire [BITVROW-1:0]                 srdradr2;
wire [2*(BITVBNK+1)+ECCBITS+WIDTH-1:0]       sdout2;

core_1r1w_rl2_a1 #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .ECCDWIDTH (ECCDWIDTH), .ECCBITS (ECCBITS))
       core (
            .vread (read),
            .vrdaddr (rd_adr),
            .vread_vld (rd_vld),
            .vdout (rd_dout),
            .vread_err (rd_err),
            .vwrite (write),
            .vwraddr (wr_adr),
            .vdin (din),
            .pwrite (pwrite),
            .pwrbadr (pwrbadr),
            .pwrradr (pwrradr),
            .pdin (pdin),
            .pread (pread),
            .prdbadr (prdbadr),
            .prdradr (prdradr),
            .pdout (pdout),
            .swrite (swrite),
            .swrradr (swrradr),
            .ddin (sdin[WIDTH-1:0]),
            .sdin (sdin[2*(BITVBNK+1)+ECCBITS+WIDTH-1:WIDTH]),
            .sread1 (sread1),
            .sread2 (sread2),
            .srdradr1 (srdradr1),
            .srdradr2 (srdradr2),
            .ddout1 (sdout1[WIDTH-1:0]),
            .ddout2 (sdout2[WIDTH-1:0]),
            .sdout1 (sdout1[2*(BITVBNK+1)+ECCBITS+WIDTH-1:WIDTH]),
            .sdout2 (sdout2[2*(BITVBNK+1)+ECCBITS+WIDTH-1:WIDTH]),
            .ready (ready),
            .clk (clk),
            .rst (rst));

mux_1r1w_rl2 #(.WIDTH (WIDTH), .BITWDTH (BITWDTH),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW), .BITVBNK (BITVBNK),
               .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .ECCBITS (ECCBITS),
               .T1_NUM_MEM (NUMVBNK), .T1_ADR_BIT (BITVROW), .T1_DAT_BIT (WIDTH),
               .T2_NUM_MEM (2), .T2_ADR_BIT (BITVROW), .T2_DAT_BIT (SDOUT_WIDTH+WIDTH))
    mux  (.clk(clk), .rst(rst), 
          .pwrite(pwrite), .pwrbadr(pwrbadr), .prdbadr(prdbadr), .pdin(pdin),
          .pread(pread), .pwrradr(pwrradr), .prdradr(prdradr), .pdout(pdout),
          .swrite(swrite), .swrradr(swrradr), .sdin(sdin),
          .sread1(sread1), .srdradr1(srdradr1), .sdout1(sdout1),
          .sread2(sread2), .srdradr2(srdradr2), .sdout2(sdout2),
          .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA),
          .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB));


`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_1r1w_rl2_a1 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .ECCDWIDTH   (ECCDWIDTH),
     .ECCBITS     (ECCBITS),
     .SDOUT_WIDTH (SDOUT_WIDTH))
ip_top_sva (.*);

ip_top_sva_2_1r1w_rl2_a1 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .ECCBITS     (ECCBITS),
     .SDOUT_WIDTH (SDOUT_WIDTH))
ip_top_sva_2 (.*);

// `else
`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_1r1w_rl2_a1 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .ECCDWIDTH   (ECCDWIDTH),
     .ECCBITS     (ECCBITS),
     .SDOUT_WIDTH (SDOUT_WIDTH))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

//`endif

ip_top_sva_2_1r1w_rl2_a1 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .ECCBITS     (ECCBITS),
     .SDOUT_WIDTH (SDOUT_WIDTH))
ip_top_sva_2 (.*);

`endif

endmodule
