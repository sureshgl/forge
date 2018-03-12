
module algo_nr1w_2rw (clk, rst, ready,
                      write1, read1, addr1, din1, rd1_dout, rd1_serr, rd1_derr, rd1_padr,
                      read2, addr2, rd2_vld, rd2_dout, rd2_serr, rd2_derr, rd2_padr,
	              t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA, t1_serrA, t1_derrA, t1_padrA,
	              t1_readB, t1_writeB, t1_addrB, t1_dinB, t1_doutB, t1_serrB, t1_derrB, t1_padrB,
	              t2_readA, t2_writeA, t2_addrA, t2_dinA, t2_doutA, t2_serrA, t2_derrA, t2_padrA,
	              t2_readB, t2_writeB, t2_addrB, t2_dinB, t2_doutB, t2_serrB, t2_derrB, t2_padrB,
	              select_addr, select_bit);
  
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
  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  input                                write1;
  input                                read1;
  input [BITADDR-1:0]                  addr1;
  input [WIDTH-1:0]                    din1;
  output [WIDTH-1:0]                   rd1_dout;
  output                               rd1_serr;
  output                               rd1_derr;
  output [BITPADR-1:0]                 rd1_padr;

  input [NUMVRPT-1:0]                  read2;
  input [NUMVRPT*BITADDR-1:0]          addr2;
  output [NUMVRPT-1:0]                 rd2_vld;
  output [NUMVRPT*WIDTH-1:0]           rd2_dout;
  output [NUMVRPT-1:0]                 rd2_serr;
  output [NUMVRPT-1:0]                 rd2_derr;
  output [NUMVRPT*BITPADR-1:0]         rd2_padr;

  output                               ready;
  input                                clk, rst;

  input [BITADDR-1:0]                  select_addr;
  input [BITWDTH-1:0]                  select_bit;

  output [NUMPRPT*NUMVBNK-1:0]         t1_readA;
  output [NUMPRPT*NUMVBNK-1:0]         t1_writeA;
  output [NUMPRPT*NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMPRPT*NUMVBNK*WIDTH-1:0]   t1_dinA;
  input [NUMPRPT*NUMVBNK*WIDTH-1:0]    t1_doutA;
  input [NUMPRPT*NUMVBNK-1:0]          t1_serrA;
  input [NUMPRPT*NUMVBNK-1:0]          t1_derrA;
  input [NUMPRPT*NUMVBNK*(BITPADR-BITPBNK-1)-1:0]  t1_padrA;

  output [NUMPRPT*NUMVBNK-1:0]         t1_readB;
  output [NUMPRPT*NUMVBNK-1:0]         t1_writeB;
  output [NUMPRPT*NUMVBNK*BITVROW-1:0] t1_addrB;
  output [NUMPRPT*NUMVBNK*WIDTH-1:0]   t1_dinB;
  input [NUMPRPT*NUMVBNK*WIDTH-1:0]    t1_doutB;
  input [NUMPRPT*NUMVBNK-1:0]          t1_serrB;
  input [NUMPRPT*NUMVBNK-1:0]          t1_derrB;
  input [NUMPRPT*NUMVBNK*(BITPADR-BITPBNK-1)-1:0]  t1_padrB;

  output [NUMPRPT-1:0]                 t2_readA;
  output [NUMPRPT-1:0]                 t2_writeA;
  output [NUMPRPT*BITVROW-1:0]         t2_addrA;
  output [NUMPRPT*WIDTH-1:0]           t2_dinA;
  input [NUMPRPT*WIDTH-1:0]            t2_doutA;
  input [NUMPRPT-1:0]                  t2_serrA;
  input [NUMPRPT-1:0]                  t2_derrA;
  input [NUMPRPT*(BITPADR-BITPBNK-1)-1:0]  t2_padrA;

  output [NUMPRPT-1:0]                 t2_readB;
  output [NUMPRPT-1:0]                 t2_writeB;
  output [NUMPRPT*BITVROW-1:0]         t2_addrB;
  output [NUMPRPT*WIDTH-1:0]           t2_dinB;
  input [NUMPRPT*WIDTH-1:0]            t2_doutB;
  input [NUMPRPT-1:0]                  t2_serrB;
  input [NUMPRPT-1:0]                  t2_derrB;
  input [NUMPRPT*(BITPADR-BITPBNK-1)-1:0]  t2_padrB;

  core_nr1w_2rw #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMVRPT(NUMVRPT), .NUMPRPT(NUMPRPT),
                  .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                  .BITPBNK (BITPBNK), .BITPADR (BITPADR), .SRAM_DELAY (SRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
      core (.vwrite1(write1), .vread1(read1), .vaddr1(addr1), .vdin1(din1), .vdout1(rd1_dout), .vread1_serr(rd1_serr), .vread1_derr(rd1_derr), .vread1_padr(rd1_padr),
	    .vread2(read2), .vaddr2(addr2), .vread2_vld(rd2_vld), .vdout2(rd2_dout), .vread2_serr(rd2_serr), .vread2_derr(rd2_derr), .vread2_padr(rd2_padr),
            .pwrite1(t1_writeA), .pread1(t1_readA), .pradr1(t1_addrA), .pdin1(t1_dinA), .pdout1(t1_doutA), .pdout1_serr(t1_serrA), .pdout1_derr(t1_derrA), .pdout1_padr(t1_padrA),
            .pwrite2(t1_writeB), .pread2(t1_readB), .pradr2(t1_addrB), .pdin2(t1_dinB), .pdout2(t1_doutB), .pdout2_serr(t1_serrB), .pdout2_derr(t1_derrB), .pdout2_padr(t1_padrB),
            .xwrite1(t2_writeA), .xread1(t2_readA), .xradr1(t2_addrA), .xdin1(t2_dinA), .xdout1(t2_doutA), .xdout1_serr(t2_serrA), .xdout1_derr(t2_derrA), .xdout1_padr(t2_padrA),
            .xwrite2(t2_writeB), .xread2(t2_readB), .xradr2(t2_addrB), .xdin2(t2_dinB), .xdout2(t2_doutB), .xdout2_serr(t2_serrB), .xdout2_derr(t2_derrB), .xdout2_padr(t2_padrB),
	    .ready (ready), .clk (clk), .rst (rst), .select_addr (select_addr), .select_bit (select_bit));

`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr == 0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit == 0));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_nr1w_2rw #(
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
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);

ip_top_sva_2_nr1w_2rw #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVRPT     (NUMVRPT),
     .NUMPRPT     (NUMPRPT),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
// generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin: sva_loop
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_nr1w_2rw #(
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
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

ip_top_sva_2_nr1w_2rw #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVRPT     (NUMVRPT),
     .NUMPRPT     (NUMPRPT),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK))
ip_top_sva_2 (.*);

`endif

endmodule


