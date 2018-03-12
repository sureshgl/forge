
module algo_nru_1rw_mt (refr, read, write, addr, din, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
	                t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA, t1_fwrdA, t1_serrA, t1_derrA, t1_padrA, t1_refrB,
	                t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, 
	                clk, rst, ready,
	                select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPSDO = 0;
  parameter ENAEXT = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;

  parameter NUMRUPT = 1;

  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMPBNK = 11;
  parameter BITPBNK = 4;
  parameter NUMWRDS = 4;
  parameter BITWRDS = 2;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter BITPADR = 14;
  parameter MEMWDTH = ENAEXT ? NUMWRDS*WIDTH : ENAPAR ? NUMWRDS*WIDTH+1 : ENAECC ? NUMWRDS*WIDTH+ECCWDTH : NUMWRDS*WIDTH;

  parameter REFRESH = 0;
  parameter REFFREQ = 16;
  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 1;
  parameter FLOPIN = 0;
  parameter FLOPPWR = 0;
  parameter FLOPOUT = 0;

  parameter BITMAPT = BITPBNK*NUMVBNK;

  input                        refr;
  input [NUMRUPT-1:0]          read;
  input [NUMRUPT-1:0]          write;
  input [NUMRUPT*BITADDR-1:0]  addr;
  input [NUMRUPT*WIDTH-1:0]    din;
  output [NUMRUPT-1:0]         rd_vld;
  output [NUMRUPT*WIDTH-1:0]   rd_dout;
  output [NUMRUPT-1:0]         rd_fwrd;
  output [NUMRUPT-1:0]         rd_serr;
  output [NUMRUPT-1:0]         rd_derr;
  output [NUMRUPT*BITPADR-1:0] rd_padr;

  output                       ready;
  input                        clk;
  input                        rst;

  input [BITADDR-1:0]          select_addr;
  input [BITWDTH-1:0]          select_bit;

  output [NUMRUPT*NUMPBNK-1:0] t1_readA;
  output [NUMRUPT*NUMPBNK-1:0] t1_writeA;
  output [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_addrA;
  output [NUMRUPT*NUMPBNK*MEMWDTH-1:0] t1_dinA;
  input [NUMRUPT*NUMPBNK*MEMWDTH-1:0] t1_doutA;
  input [NUMRUPT*NUMPBNK-1:0] t1_fwrdA;
  input [NUMRUPT*NUMPBNK-1:0] t1_serrA;
  input [NUMRUPT*NUMPBNK-1:0] t1_derrA;
  input [NUMRUPT*NUMPBNK*(BITPADR-BITPBNK-BITWRDS)-1:0] t1_padrA;
  output [NUMRUPT*NUMPBNK-1:0] t1_refrB;

  output [NUMRUPT-1:0] t2_writeA;
  output [NUMRUPT*BITSROW-1:0] t2_addrA;
  output [NUMRUPT*BITMAPT-1:0] t2_dinA;

  output [NUMRUPT-1:0] t2_readB;
  output [NUMRUPT*BITSROW-1:0] t2_addrB;
  input [NUMRUPT*BITMAPT-1:0] t2_doutB;

  core_nru_1rw_mt #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPSDO (ENAPSDO), .ENAEXT (ENAEXT), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                    .NUMRUPT (NUMRUPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                    .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .NUMPBNK (NUMPBNK), .BITPBNK (BITPBNK),
                    .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .NUMSROW (NUMSROW), .BITSROW (BITSROW), .BITPADR (BITPADR),
                    .REFRESH (REFRESH), .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .FLOPIN (FLOPIN), .FLOPPWR (FLOPPWR), .FLOPOUT (FLOPOUT))
    core (.vrefr (refr), .vread (read), .vwrite (write), .vaddr (addr), .vdin (din), .vread_vld (rd_vld), .vdout (rd_dout),
          .vread_fwrd (rd_fwrd), .vread_serr (rd_serr), .vread_derr (rd_derr), .vread_padr (rd_padr),
          .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA),
          .t1_doutA(t1_doutA), .t1_fwrdA(t1_fwrdA), .t1_serrA(t1_serrA), .t1_derrA(t1_derrA), .t1_padrA(t1_padrA), .t1_refrB(t1_refrB),
          .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
          .ready (ready), .clk (clk), .rst (rst),
          .select_addr (select_addr));

`ifdef FORMAL

assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_nru_1rw_mt #(
     .WIDTH       (WIDTH),
     .ENAEXT      (ENAEXT),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .ECCWDTH     (ECCWDTH),
     .BITWDTH     (BITWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMRUPT     (NUMRUPT),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .NUMWRDS     (NUMWRDS),
     .BITWRDS     (BITWRDS),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW),
     .BITPADR     (BITPADR),
     .REFRESH     (REFRESH),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPPWR     (FLOPPWR),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);


ip_top_sva_2_nru_1rw_mt #(
     .WIDTH       (WIDTH),
     .ENAPSDO     (ENAPSDO),
     .ENAEXT      (ENAEXT),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .ECCWDTH     (ECCWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMRUPT     (NUMRUPT),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .NUMWRDS     (NUMWRDS),
     .BITWRDS     (BITWRDS),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW),
     .FLOPOUT     (FLOPOUT),
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
ip_top_sva_nru_1rw_mt #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAEXT      (ENAEXT),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .ECCWDTH     (ECCWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMRUPT     (NUMRUPT),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .NUMWRDS     (NUMWRDS),
     .BITWRDS     (BITWRDS),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW),
     .BITPADR     (BITPADR),
     .REFRESH     (REFRESH),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPPWR     (FLOPPWR),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

ip_top_sva_2_nru_1rw_mt #(
     .WIDTH       (WIDTH),
     .ENAPSDO     (ENAPSDO),
     .ENAEXT      (ENAEXT),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .ECCWDTH     (ECCWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMRUPT     (NUMRUPT),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .NUMWRDS     (NUMWRDS),
     .BITWRDS     (BITWRDS),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW),
     .FLOPOUT     (FLOPOUT),
     .REFRESH     (REFRESH),
     .REFFREQ     (REFFREQ),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY))
ip_top_sva_2 (.*);

`endif

endmodule
