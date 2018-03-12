module algo_mrcnw_1r2w_rl (write, wr_adr, din, read, rd_clr, rd_adr, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
                      t1_writeA, t1_addrA, t1_dinA, 
	                  t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
	                  t2_writeA, t2_addrA, t2_dinA, 
                      t2_readB, t2_addrB, t2_doutB, t2_writeB, t2_dinB,
	                  clk, rst, ready,
	                  select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMRDPT = 1;
  parameter NUMWRPT = 4;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter BITPADR = 15;

  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 1;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter NUMPBNK = NUMWRPT/2;
  parameter BITPBNK = 1;

  input  [NUMWRPT-1:0]         write;
  input  [NUMWRPT*BITADDR-1:0] wr_adr;
  input  [NUMWRPT*WIDTH-1:0]   din;

  input  [NUMRDPT-1:0]         read;
  input  [NUMRDPT-1:0]         rd_clr;
  input  [NUMRDPT*BITADDR-1:0] rd_adr;
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

  output [NUMPBNK*2*NUMRDPT-1:0]                 t1_writeA;
  output [NUMPBNK*2*NUMRDPT*BITADDR-1:0]         t1_addrA;
  output [NUMPBNK*2*NUMRDPT*WIDTH-1:0]           t1_dinA;
  output [NUMPBNK*NUMRDPT-1:0]                   t1_readB;
  output [NUMPBNK*NUMRDPT*BITADDR-1:0]           t1_addrB;
  input  [NUMPBNK*NUMRDPT*WIDTH-1:0]             t1_doutB;
  input  [NUMPBNK*NUMRDPT-1:0]                   t1_fwrdB;
  input  [NUMPBNK*NUMRDPT-1:0]                   t1_serrB;
  input  [NUMPBNK*NUMRDPT-1:0]                   t1_derrB;
  input  [NUMPBNK*NUMRDPT*(BITPADR-BITPBNK)-1:0] t1_padrB;

  output [NUMPBNK*2*NUMRDPT-1:0]                 t2_writeA;
  output [NUMPBNK*2*NUMRDPT*BITADDR-1:0]         t2_addrA;
  output [NUMPBNK*2*NUMRDPT*2-1:0]               t2_dinA;
                                               
  output [NUMPBNK*NUMRDPT-1:0]                   t2_readB;
  output [NUMPBNK*NUMRDPT*BITADDR-1:0]           t2_addrB;
  input  [NUMPBNK*NUMRDPT*2-1:0]                 t2_doutB;
  output [NUMPBNK*NUMRDPT-1:0]                   t2_writeB;
  output [NUMPBNK*NUMRDPT*2-1:0]                 t2_dinB;
                                                 
  core_mrcnw_1r2w_rl #(.WIDTH(WIDTH), .BITWDTH(BITWDTH),
                      .NUMRDPT(NUMRDPT), .NUMWRPT(NUMWRPT), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMPBNK(NUMPBNK), .BITPBNK(BITPBNK), .BITPADR(BITPADR),
                      .SRAM_DELAY(SRAM_DELAY), .DRAM_DELAY(DRAM_DELAY), .FLOPIN(FLOPIN), .FLOPOUT(FLOPOUT))
    core (.vwrite (write), .vwraddr (wr_adr), .vdin (din),
	  .vread (read), .vread_clr (rd_clr), .vrdaddr (rd_adr), .vread_vld (rd_vld), .vdout (rd_dout),
          .vread_fwrd (rd_fwrd), .vread_serr (rd_serr), .vread_derr (rd_derr), .vread_padr (rd_padr),
          .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA),
          .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB), .t1_fwrdB(t1_fwrdB), .t1_serrB(t1_serrB), .t1_derrB(t1_derrB), .t1_padrB(t1_padrB),
          .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), 
          .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB), .t2_writeB(t2_writeB), .t2_dinB(t2_dinB), 
          .ready (ready), .clk (clk), .rst (rst));

`ifdef FORMAL

wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_mrcnw_1r2w_rl #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);


ip_top_sva_2_mrcnw_1r2w_rl #(
     .WIDTH       (WIDTH),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_mrcnw_1r2w_rl #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
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

ip_top_sva_2_mrcnw_1r2w_rl #(
     .WIDTH       (WIDTH),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK))
ip_top_sva_2 (.*);

`endif

endmodule
