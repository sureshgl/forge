
module algo_nr1rw_1r1w (clk, rst, ready,
                        write, wr_adr, din,
                        read, rd_adr, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
                        t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
	                t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_serrB, t2_derrB, t2_padrB,
	                select_addr, select_bit);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter NUMVRPT = 4;
  parameter NUMPRPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter BITPADR = 14;
  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input [NUMVRPT-1:0]                  read;
  input [NUMVRPT*BITADDR-1:0]          rd_adr;
  output [NUMVRPT-1:0]                 rd_vld;
  output [NUMVRPT*WIDTH-1:0]           rd_dout;
  output [NUMVRPT-1:0]                 rd_fwrd;
  output [NUMVRPT-1:0]                 rd_serr;
  output [NUMVRPT-1:0]                 rd_derr;
  output [NUMVRPT*BITPADR-1:0]         rd_padr;

  output                               ready;
  input                                clk, rst;

  input [BITADDR-1:0]                  select_addr;
  input [BITWDTH-1:0]                  select_bit;

  output [NUMPRPT*NUMVBNK-1:0]         t1_writeA;
  output [NUMPRPT*NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMPRPT*NUMVBNK*WIDTH-1:0]   t1_dinA;
  output [NUMPRPT*NUMVBNK-1:0]         t1_readB;
  output [NUMPRPT*NUMVBNK*BITVROW-1:0] t1_addrB;
  input [NUMPRPT*NUMVBNK*WIDTH-1:0]    t1_doutB;
  input [NUMPRPT*NUMVBNK-1:0]          t1_fwrdB;
  input [NUMPRPT*NUMVBNK-1:0]          t1_serrB;
  input [NUMPRPT*NUMVBNK-1:0]          t1_derrB;
  input [NUMPRPT*NUMVBNK*(BITPADR-BITPBNK)-1:0]  t1_padrB;

  output [NUMPRPT-1:0]                 t2_writeA;
  output [NUMPRPT*BITVROW-1:0]         t2_addrA;
  output [NUMPRPT*WIDTH-1:0]           t2_dinA;
  output [NUMPRPT-1:0]                 t2_readB;
  output [NUMPRPT*BITVROW-1:0]         t2_addrB;
  input [NUMPRPT*WIDTH-1:0]            t2_doutB;
  input [NUMPRPT-1:0]                  t2_fwrdB;
  input [NUMPRPT-1:0]                  t2_serrB;
  input [NUMPRPT-1:0]                  t2_derrB;
  input [NUMPRPT*(BITPADR-BITPBNK)-1:0]  t2_padrB;

  core_nr1rw_1r1w #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .NUMVRPT(NUMVRPT), .NUMPRPT(NUMPRPT),
                    .NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                    .BITPBNK (BITPBNK), .BITPADR (BITPADR), .SRAM_DELAY (SRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
      core (.vwrite(write), .vwraddr(wr_adr), .vdin(din),
	    .vread(read), .vrdaddr(rd_adr), .vread_vld(rd_vld), .vdout(rd_dout),
            .vread_fwrd(rd_fwrd), .vread_serr(rd_serr), .vread_derr(rd_derr), .vread_padr(rd_padr),
            .pwrite(t1_writeA), .pwrradr (t1_addrA), .pdin (t1_dinA), .pread(t1_readB), .prdradr(t1_addrB), .pdout (t1_doutB),
            .pdout_fwrd (t1_fwrdB), .pdout_serr (t1_serrB), .pdout_derr (t1_derrB), .pdout_padr (t1_padrB),
            .xwrite(t2_writeA), .xwrradr(t2_addrA), .xdin (t2_dinA), .xread(t2_readB), .xrdradr(t2_addrB), .xdout (t2_doutB),
            .xdout_fwrd (t2_fwrdB), .xdout_serr (t2_serrB), .xdout_derr (t2_derrB), .xdout_padr (t2_padrB),
	    .ready (ready), .clk (clk), .rst (rst), .select_bit (select_bit));

`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_nr1rw_1r1w #(
     .WIDTH       (WIDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
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

ip_top_sva_2_nr1rw_1r1w #(
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
ip_top_sva_nr1rw_1r1w #(
     .WIDTH       (WIDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
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

ip_top_sva_2_nr1rw_1r1w #(
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


