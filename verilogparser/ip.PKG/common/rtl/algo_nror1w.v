
module algo_nror1w (refr, clk, rst, ready,
                    write, wr_adr, din,
                    read, rd_adr, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
	            t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA, t1_fwrdA, t1_serrA, t1_derrA, t1_padrA, t1_refrB,
	            t2_readA, t2_writeA, t2_addrA, t2_dinA, t2_doutA, t2_fwrdA, t2_serrA, t2_derrA, t2_padrA, t2_refrB,
	            select_addr, select_bit);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVRPT = 4;
  parameter NUMPRPT = 2;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter BITPADR = 14;
  parameter REFRESH = 0;
  parameter REFFREQ = 10;
  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  input                                refr;

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

  output [NUMPRPT*NUMVBNK-1:0]         t1_readA;
  output [NUMPRPT*NUMVBNK-1:0]         t1_writeA;
  output [NUMPRPT*NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMPRPT*NUMVBNK*WIDTH-1:0]   t1_dinA;
  input [NUMPRPT*NUMVBNK*WIDTH-1:0]    t1_doutA;
  input [NUMPRPT*NUMVBNK-1:0]          t1_fwrdA;
  input [NUMPRPT*NUMVBNK-1:0]          t1_serrA;
  input [NUMPRPT*NUMVBNK-1:0]          t1_derrA;
  input [NUMPRPT*NUMVBNK*(BITPADR-BITPBNK)-1:0]  t1_padrA;
  output [NUMPRPT*NUMVBNK-1:0]         t1_refrB;

  output [NUMPRPT-1:0]                 t2_readA;
  output [NUMPRPT-1:0]                 t2_writeA;
  output [NUMPRPT*BITVROW-1:0]         t2_addrA;
  output [NUMPRPT*WIDTH-1:0]           t2_dinA;
  input [NUMPRPT*WIDTH-1:0]            t2_doutA;
  input [NUMPRPT-1:0]                  t2_fwrdA;
  input [NUMPRPT-1:0]                  t2_serrA;
  input [NUMPRPT-1:0]                  t2_derrA;
  input [NUMPRPT*(BITPADR-BITPBNK)-1:0]  t2_padrA;
  output [NUMPRPT-1:0]                 t2_refrB;

  core_nror1w #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC),
                .NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMVRPT(NUMVRPT), .NUMPRPT(NUMPRPT),
                .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR),
                .REFRESH (REFRESH), .SRAM_DELAY (SRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
      core (.vrefr(refr),
	    .vwrite(write), .vwraddr(wr_adr), .vdin(din),
	    .vread(read), .vrdaddr(rd_adr), .vread_vld(rd_vld), .vdout(rd_dout),
            .vread_fwrd(rd_fwrd), .vread_serr(rd_serr), .vread_derr(rd_derr), .vread_padr(rd_padr),
            .prefr(t1_refrB), .pwrite(t1_writeA), .pread(t1_readA), .pradr(t1_addrA), .pdin (t1_dinA), .pdout (t1_doutA),
            .pdout_fwrd (t1_fwrdA), .pdout_serr (t1_serrA), .pdout_derr (t1_derrA), .pdout_padr (t1_padrA),
            .xrefr(t2_refrB), .xwrite(t2_writeA), .xread(t2_readA), .xradr(t2_addrA), .xdin (t2_dinA), .xdout (t2_doutA),
            .xdout_fwrd (t2_fwrdA), .xdout_serr (t2_serrA), .xdout_derr (t2_derrA), .xdout_padr (t2_padrA),
	    .ready (ready), .clk (clk), .rst (rst), .select_addr (select_addr), .select_bit (select_bit));

`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr == 0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit == 0));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_nror1w #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMVRPT     (NUMVRPT),
     .NUMPRPT     (NUMPRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
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

ip_top_sva_2_nror1w #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVRPT     (NUMVRPT),
     .NUMPRPT     (NUMPRPT),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .REFRESH     (REFRESH),
     .REFFREQ     (REFFREQ))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
// generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin: sva_loop
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_nror1w #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMVRPT     (NUMVRPT),
     .NUMPRPT     (NUMPRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
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

ip_top_sva_2_nror1w #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVRPT     (NUMVRPT),
     .NUMPRPT     (NUMPRPT),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .REFRESH     (REFRESH),
     .REFFREQ     (REFFREQ))
ip_top_sva_2 (.*);

`endif

endmodule


