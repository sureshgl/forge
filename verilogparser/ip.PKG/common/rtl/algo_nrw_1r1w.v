module algo_nrw_1r1w (
                      read, write, addr, din, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
                      t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                      ready, clk, rst,
		                select_addr, select_bit
                      );
  
  parameter BITWDTH = 5;
  parameter WIDTH = 32;
  parameter NUMRWPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMPBNK = 4;     // NUMRWPT*NUMRWPT
  parameter BITPBNK = 2;
  parameter BITPADR = BITPBNK+BITADDR;
  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  input [NUMRWPT-1:0]              read;
  input [NUMRWPT-1:0]              write;
  input [NUMRWPT*BITADDR-1:0]      addr;
  input [NUMRWPT*WIDTH-1:0]        din;
  output [NUMRWPT-1:0]             rd_vld;
  output [NUMRWPT*WIDTH-1:0]       rd_dout;
  output [NUMRWPT-1:0]             rd_fwrd;
  output [NUMRWPT-1:0]             rd_serr;
  output [NUMRWPT-1:0]             rd_derr;
  output [NUMRWPT*BITPADR-1:0]     rd_padr;

  output                           ready;
  input                            clk;
  input                            rst;

  output [NUMPBNK-1:0]             t1_writeA;
  output [NUMPBNK*BITADDR-1:0]     t1_addrA;
  output [NUMPBNK*WIDTH-1:0]       t1_dinA;

  output [NUMPBNK-1:0]             t1_readB;
  output [NUMPBNK*BITADDR-1:0]     t1_addrB;
  input [NUMPBNK*WIDTH-1:0]        t1_doutB;
  input [NUMPBNK-1:0]              t1_fwrdB;
  input [NUMPBNK-1:0]              t1_serrB;
  input [NUMPBNK-1:0]              t1_derrB;
  input [NUMPBNK*(BITPADR-BITPBNK)-1:0] t1_padrB;

  input [BITADDR-1:0]                   select_addr;
  input [BITWDTH-1:0]                   select_bit;

  core_nrw_1r1w #(
                  .BITWDTH (BITWDTH), .WIDTH (WIDTH), .NUMRWPT (NUMRWPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                  .NUMPBNK(NUMPBNK), .BITPBNK (BITPBNK), .BITPADR(BITPADR), 
                  .SRAM_DELAY (SRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT)
                  )
  core (
        .vread (read), .vwrite (write), .vaddr (addr), .vdin (din),
        .vread_vld (rd_vld), .vdout (rd_dout), .vread_fwrd (rd_fwrd), .vread_serr (rd_serr), .vread_derr (rd_derr), .vread_padr (rd_padr),
        .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA),
        .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB), .t1_fwrdB(t1_fwrdB), .t1_serrB(t1_serrB), .t1_derrB(t1_derrB), .t1_padrB(t1_padrB),
        .ready (ready), .clk (clk), .rst (rst)
        );

`ifdef FORMAL
  assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
  assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));

  ip_top_sva_nrw_1r1w #(
                        .WIDTH       (WIDTH),
                        .BITWDTH     (BITWDTH),
                        .NUMRWPT     (NUMRWPT),
                        .NUMADDR     (NUMADDR),
                        .BITADDR     (BITADDR),
                        .NUMPBNK     (NUMPBNK),
                        .BITPBNK     (BITPBNK),
                        .BITPADR     (BITPADR),
                        .SRAM_DELAY  (SRAM_DELAY),
                        .FLOPIN      (FLOPIN),
                        .FLOPOUT     (FLOPOUT))
  ip_top_sva (.*);

  ip_top_sva_2_nrw_1r1w #(
                          .WIDTH       (WIDTH),
                          .NUMRWPT     (NUMRWPT),
                          .NUMADDR     (NUMADDR),
                          .BITADDR     (BITADDR))
  ip_top_sva_2 (.*);

  //`else
`elsif SIM_SVA

  genvar                                sva_int;
  generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin : ip_top_sva
    wire [BITADDR-1:0] help_addr = sva_int;
    wire [BITWDTH-1:0] help_bit = sva_int;

    ip_top_sva_nrw_1r1w #(
                          .WIDTH       (WIDTH),
                          .BITWDTH     (BITWDTH),
                          .NUMRWPT     (NUMRWPT),
                          .NUMADDR     (NUMADDR),
                          .BITADDR     (BITADDR),
                          .NUMPBNK     (NUMPBNK),
                          .BITPBNK     (BITPBNK),
                          .BITPADR     (BITPADR),
                          .SRAM_DELAY  (SRAM_DELAY),
                          .FLOPIN      (FLOPIN),
                          .FLOPOUT     (FLOPOUT))
    ip_top_sva (.select_addr(help_addr), .select_bit(help_bit), .*);
  end
  endgenerate

  ip_top_sva_2_nrw_1r1w #(
                          .WIDTH       (WIDTH),
                          .NUMRWPT     (NUMRWPT),
                          .NUMADDR     (NUMADDR),
                          .BITADDR     (BITADDR))
  ip_top_sva_2 (.*);

`endif

  endmodule
