
module algo_mrnwa_1rw_fl (refr, write, wr_adr, din, wr_bp,
                          read, rd_deq, rd_adr, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
                          t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA, t1_fwrdA, t1_serrA, t1_derrA, t1_padrA, t1_refrB,
                          t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, 
                          clk, rst, ready,
                          select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAEXT = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;

  parameter NUMRDPT = 1;
  parameter NUMWRPT = 1;

  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter BITPADR = 14;

  parameter REFRESH = 0;
  parameter REFFREQ = 16;
  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 1;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  input                        refr;

  input [NUMWRPT-1:0]          write;
  output [NUMWRPT*BITADDR-1:0] wr_adr;
  input [NUMWRPT*WIDTH-1:0]    din;
  output                       wr_bp;

  input [NUMRDPT-1:0]          read;
  input [NUMRDPT-1:0]          rd_deq;
  input [NUMRDPT*BITADDR-1:0]  rd_adr;
  output [NUMRDPT-1:0]         rd_vld;
  output [NUMRDPT*WIDTH-1:0]   rd_dout;
  output [NUMRDPT-1:0]         rd_fwrd;
  output [NUMRDPT-1:0]         rd_serr;
  output [NUMRDPT-1:0]         rd_derr;
  output [NUMRDPT*BITPADR-1:0] rd_padr;

  output                       ready;
  input                        clk;
  input                        rst;

  input [BITADDR-1:0]          select_addr;
  input [BITWDTH-1:0]          select_bit;

  output [NUMRDPT*NUMVBNK-1:0] t1_readA;
  output [NUMRDPT*NUMVBNK-1:0] t1_writeA;
  output [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_dinA;
  input [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_doutA;
  input [NUMRDPT*NUMVBNK-1:0] t1_fwrdA;
  input [NUMRDPT*NUMVBNK-1:0] t1_serrA;
  input [NUMRDPT*NUMVBNK-1:0] t1_derrA;
  input [NUMRDPT*NUMVBNK*(BITPADR-BITVBNK)-1:0] t1_padrA;
  output [NUMRDPT*NUMVBNK-1:0] t1_refrB;

  output [NUMRDPT*NUMVBNK-1:0] t2_writeA;
  output [NUMRDPT*NUMVBNK*BITVROW-1:0] t2_addrA;
  output [NUMRDPT*NUMVBNK*BITVROW-1:0] t2_dinA;

  output [NUMRDPT*NUMVBNK-1:0] t2_readB;
  output [NUMRDPT*NUMVBNK*BITVROW-1:0] t2_addrB;
  input [NUMRDPT*NUMVBNK*BITVROW-1:0] t2_doutB;

  core_mrnwa_1rw_fl #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMRDPT (NUMRDPT), .NUMWRPT (NUMWRPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                      .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPADR (BITPADR),
                      .REFRESH (REFRESH), .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    core (.vrefr (refr), .vwrite (write), .vwraddr (wr_adr), .vdin (din), .vwrite_bp (wr_bp),
          .vread (read), .vread_deq (rd_deq), .vrdaddr (rd_adr), .vread_vld (rd_vld), .vdout (rd_dout),
          .vread_fwrd (rd_fwrd), .vread_serr (rd_serr), .vread_derr (rd_derr), .vread_padr (rd_padr),
          .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA),
          .t1_doutA(t1_doutA), .t1_fwrdA(t1_fwrdA), .t1_serrA(t1_serrA), .t1_derrA(t1_derrA), .t1_padrA(t1_padrA), .t1_refrB(t1_refrB),
          .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
          .ready (ready), .clk (clk), .rst (rst),
          .select_addr (select_addr), .select_bit (select_bit));

`ifdef FORMAL

assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_mrnwa_1rw_fl #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAEXT      (ENAEXT),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPADR     (BITPADR),
     .REFRESH     (REFRESH),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);


ip_top_sva_2_mrnwa_1rw_fl #(
     .WIDTH       (WIDTH),
     .ENAEXT      (ENAEXT),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .REFRESH     (REFRESH),
     .REFFREQ     (REFFREQ),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_mrnwa_1rw_fl #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAEXT      (ENAEXT),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPADR     (BITPADR),
     .REFRESH     (REFRESH),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

ip_top_sva_2_mrnwa_1rw_fl #(
     .WIDTH       (WIDTH),
     .ENAEXT      (ENAEXT),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .REFRESH     (REFRESH),
     .REFFREQ     (REFFREQ),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY))
ip_top_sva_2 (.*);

`endif

endmodule