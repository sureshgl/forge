
module algo_mrnwt_base (clk, rst, ready,
                        write, wr_adr, din, wr_bp,
                        read, rd_adr, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
                        t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                        bp_thr,
                        select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter NUMRDPT = 2;
  parameter NUMWRPT = 3;
  parameter BITWRPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMWTPT = 3;
  parameter BITPADR = 13;

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter FIFOCNT = 256;
  parameter BITFIFO = 8;
  parameter NUMSRCH = 2;

  input [NUMWRPT-1:0]                   write;
  input [NUMWRPT*BITADDR-1:0]           wr_adr;
  input [NUMWRPT*WIDTH-1:0]             din;
  output                                wr_bp;

  input [NUMRDPT-1:0]                   read;
  input [NUMRDPT*BITADDR-1:0]           rd_adr;
  output [NUMRDPT-1:0]                  rd_vld;
  output [NUMRDPT*WIDTH-1:0]            rd_dout;
  output [NUMRDPT-1:0]                  rd_fwrd;
  output [NUMRDPT-1:0]                  rd_serr;
  output [NUMRDPT-1:0]                  rd_derr;
  output [NUMRDPT*BITPADR-1:0]          rd_padr;

  input [BITFIFO:0]                     bp_thr;

  output                                ready;
  input                                 clk, rst;

  input [BITADDR-1:0]                   select_addr;
  input [BITWDTH-1:0]                   select_bit;

  output [NUMWTPT-1:0]                  t1_writeA;
  output [NUMWTPT*BITADDR-1:0]          t1_addrA;
  output [NUMWTPT*WIDTH-1:0]            t1_dinA;

  output [NUMRDPT-1:0]                  t1_readB;
  output [NUMRDPT*BITADDR-1:0]          t1_addrB;
  input [NUMRDPT*WIDTH-1:0]             t1_doutB;
  input [NUMRDPT-1:0]                   t1_fwrdB;
  input [NUMRDPT-1:0]                   t1_serrB;
  input [NUMRDPT-1:0]                   t1_derrB;
  input [NUMRDPT*BITPADR-1:0]           t1_padrB;

  core_mrnwt_base #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMRDPT (NUMRDPT), .NUMWRPT (NUMWRPT), .BITWRPT (BITWRPT), .NUMWTPT (NUMWTPT),
                    .NUMADDR (NUMADDR), .BITADDR (BITADDR), .BITPADR (BITPADR),
                    .SRAM_DELAY (SRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT),
                    .FIFOCNT (FIFOCNT), .BITFIFO (BITFIFO), .NUMSRCH (NUMSRCH))
      core (.vwrite(write), .vwraddr(wr_adr), .vdin(din), .vwr_bp(wr_bp),
	    .vread(read), .vrdaddr(rd_adr), .vread_vld(rd_vld), .vdout(rd_dout),
            .vread_fwrd(rd_fwrd), .vread_serr(rd_serr), .vread_derr(rd_derr), .vread_padr(rd_padr),
            .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA),
            .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
            .t1_fwrdB(t1_fwrdB), .t1_serrB(t1_serrB), .t1_derrB(t1_derrB), .t1_padrB(t1_padrB),
            .bp_thr(bp_thr),
	    .ready (ready), .clk (clk), .rst (rst));

`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_mrnwt_base #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWTPT     (NUMWTPT),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT),
     .FIFOCNT     (FIFOCNT))
ip_top_sva (.*);

ip_top_sva_2_mrnwt_base #(
     .WIDTH       (WIDTH),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWTPT     (NUMWTPT))

ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
// generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin: sva_loop
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_mrnwt_base #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWTPT     (NUMWTPT),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT),
     .FIFOCNT     (FIFOCNT))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

ip_top_sva_2_mrnwt_base #(
     .WIDTH       (WIDTH),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWTPT     (NUMWTPT))
ip_top_sva_2 (.*);

`endif

endmodule


