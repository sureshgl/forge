module infra_stack_1r1w (write, wr_adr, bw, din, read, rd_adr, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
	                 mem_write, mem_wr_adr, mem_bw, mem_din, mem_read, mem_rd_adr, mem_rd_dout,
		         clk, rst,
		         select_addr);

  parameter WIDTH = 32;
  parameter ENAPSDO = 1;
  parameter NUMADDR = 1024;
  parameter BITADDR = 10;
  parameter NUMWBNK = 4;
  parameter BITWBNK = 2;
  parameter NUMWROW = 256;
  parameter BITWROW = 8;
  parameter SRAM_DELAY = 2;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;
  parameter RSTZERO = 0;
  parameter CGFLOPC = 0;
  parameter CGFLOPM = 0;
  parameter CGFLOPO = 0;

  input write;
  input [BITADDR-1:0] wr_adr;
  input [WIDTH-1:0] bw;
  input [WIDTH-1:0] din;

  input read;
  input [BITADDR-1:0] rd_adr;
  output [WIDTH-1:0] rd_dout;
  output rd_fwrd;
  output rd_serr;
  output rd_derr;
  output [BITWBNK+BITWROW-1:0] rd_padr;

  output [NUMWBNK-1:0] mem_write;
  output [NUMWBNK*BITWROW-1:0] mem_wr_adr;
  output [NUMWBNK*WIDTH-1:0] mem_bw;
  output [NUMWBNK*WIDTH-1:0] mem_din;

  output [NUMWBNK-1:0] mem_read;
  output [NUMWBNK*BITWROW-1:0] mem_rd_adr;
  input [NUMWBNK*WIDTH-1:0] mem_rd_dout;

  input clk;
  input rst;

  input [BITADDR-1:0] select_addr;

  stack_1r1w #(.WIDTH (WIDTH), .ENAPSDO (ENAPSDO), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK), .NUMWROW (NUMWROW), .BITWROW (BITWROW),
               .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPOUT))
    core (.write (write), .wr_adr (wr_adr), .bw (bw), .din (din),
          .read (read), .rd_adr (rd_adr), .rd_dout (rd_dout), .rd_fwrd (rd_fwrd), .rd_serr (rd_serr), .rd_derr (rd_derr), .rd_padr (rd_padr),
          .mem_write (mem_write), .mem_wr_adr (mem_wr_adr), .mem_bw (mem_bw), .mem_din (mem_din),
          .mem_read (mem_read), .mem_rd_adr (mem_rd_adr), .mem_rd_dout (mem_rd_dout),
          .clk (clk), .rst (rst));

`ifdef FORMAL
//synopsys translate_off

assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));

ip_top_sva_stack_1r1w #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWBNK     (NUMWBNK),
     .BITWBNK     (BITWBNK),
     .NUMWROW     (NUMWROW),
     .BITWROW     (BITWROW),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPCMD     (FLOPCMD),
     .FLOPMEM     (FLOPMEM),
     .FLOPOUT     (FLOPOUT),
     .RSTZERO     (RSTZERO))
ip_top_sva (.*);

ip_top_sva_2_stack_1r1w #(
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWROW     (NUMWROW),
     .BITWROW     (BITWROW),
     .NUMWBNK     (NUMWBNK),
     .BITWBNK     (BITWBNK))
ip_top_sva_2 (.*);
//synopsys translate_on

`elsif SIM_SVA
//synopsys translate_off

genvar sva_int;
// generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin: sva_loop
  wire [BITADDR-1:0] help_addr = sva_int;
ip_top_sva_stack_1r1w #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWBNK     (NUMWBNK),
     .BITWBNK     (BITWBNK),
     .NUMWROW     (NUMWROW),
     .BITWROW     (BITWROW),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPCMD     (FLOPCMD),
     .FLOPMEM     (FLOPMEM),
     .FLOPOUT     (FLOPOUT),
     .RSTZERO     (RSTZERO))
ip_top_sva (.select_addr(help_addr), .*);
end
endgenerate

ip_top_sva_2_stack_1r1w #(
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWROW     (NUMWROW),
     .BITWROW     (BITWROW),
     .NUMWBNK     (NUMWBNK),
     .BITWBNK     (BITWBNK))
ip_top_sva_2 (.*);
//synopsys translate_on

`endif

endmodule

