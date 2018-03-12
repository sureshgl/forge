module infra_align_1r1w_ramwrap (write, wr_adr, bw,  din, read, rd_adr, rd_vld, rd_dout, 
	                             mem_write, mem_wr_adr, mem_bw, mem_din, mem_read, mem_rd_adr, mem_rd_dout, 
		                         clk, rst,
		                         select_addr);

  parameter WIDTH = 32;
  parameter ENAPSDO = 0;
  parameter NUMADDR = 1024;
  parameter BITADDR = 10;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter NUMWRDS = 4;
  parameter BITWRDS = 2;
  parameter SRAM_DELAY = 2;
  parameter FLOPGEN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;


  input write;
  input [BITADDR-1:0] wr_adr;
  input [WIDTH-1:0] bw;
  input [WIDTH-1:0] din;

  input               read;
  input [BITADDR-1:0] rd_adr;
  output              rd_vld;
  output [WIDTH-1:0]  rd_dout;

  output mem_write;
  output [BITSROW-1:0] mem_wr_adr;
  output [NUMWRDS*WIDTH-1:0] mem_bw;
  output [NUMWRDS*WIDTH-1:0] mem_din;

  output mem_read;
  output [BITSROW-1:0] mem_rd_adr;
  input [NUMWRDS*WIDTH-1:0] mem_rd_dout;

  input clk;
  input rst;

  input [BITADDR-1:0] select_addr;

  align_1r1w_ramwrap #(.WIDTH (WIDTH), .ENAPSDO (ENAPSDO), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                   .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .NUMSROW (NUMSROW), .BITSROW (BITSROW),
                   .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPGEN), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPOUT)
                 )
    core (.write(write), .wr_adr(wr_adr) , .bw(bw) , .din(din) , .read(read) , .rd_adr(rd_adr) , .rd_vld(rd_vld) , .rd_dout(rd_dout),
          .mem_write(mem_write), .mem_wr_adr(mem_wr_adr), .mem_bw(mem_bw), .mem_din(mem_din), .mem_read(mem_read), .mem_rd_adr(mem_rd_adr), .mem_rd_dout(mem_rd_dout),
          .clk(clk), .rst(rst)
        );

`ifdef FORMAL
//synopsys translate_off

assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));

ip_top_sva_align_1r1w_ramwrap #(
     .WIDTH       (WIDTH),
     .ENAPSDO     (ENAPSDO),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWRDS     (NUMWRDS),
     .BITWRDS     (BITWRDS),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPGEN     (FLOPGEN),
     .FLOPCMD     (FLOPCMD),
     .FLOPMEM     (FLOPMEM),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);

ip_top_sva_2_align_1r1w_ramwrap #(
     .ENAPSDO     (ENAPSDO),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW))
ip_top_sva_2 (.*);
//synopsys translate_on

`elsif SIM_SVA

genvar sva_int;
// generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin: sva_loop
  wire [BITADDR-1:0] help_addr = sva_int;
ip_top_sva_align_1r1w_ramwrap #(
     .WIDTH       (WIDTH),
     .ENAPSDO     (ENAPSDO),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWRDS     (NUMWRDS),
     .BITWRDS     (BITWRDS),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPGEN     (FLOPGEN),
     .FLOPCMD     (FLOPCMD),
     .FLOPMEM     (FLOPMEM),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .*);
end
endgenerate

ip_top_sva_2_align_1r1w_ramwrap #(
     .ENAPSDO     (ENAPSDO),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW))
ip_top_sva_2 (.*);

`endif

endmodule // infra_align_1r1w_ramwrap

