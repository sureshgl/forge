module infra_align_2rw (write, read, addr, din, dout, serr, padr,
	                mem_write, mem_read, mem_addr, mem_bw, mem_din, mem_dout,
		        clk, rst,
		        select_addr);

  parameter WIDTH = 32;
  parameter PARITY = 1;
  parameter NUMADDR = 1024;
  parameter BITADDR = 10;
  parameter NUMWRDS = 4;
  parameter BITWRDS = 2;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter BITPADR = 10;
  parameter SRAM_DELAY = 2;
  parameter FLOPMEM = 0;
  parameter RSTZERO = 0;

  parameter MEMWDTH = WIDTH+PARITY;

  input [2-1:0] write;
  input [2-1:0] read;
  input [2*BITADDR-1:0] addr;
  input [2*WIDTH-1:0] din;
  output [2*WIDTH-1:0] dout;
  output [2-1:0] serr;
  output [2*BITPADR-1:0] padr;

  output [2-1:0] mem_write;
  output [2-1:0] mem_read;
  output [2*BITSROW-1:0] mem_addr;
  output [2*NUMWRDS*MEMWDTH-1:0] mem_bw;
  output [2*NUMWRDS*MEMWDTH-1:0] mem_din;
  input [2*NUMWRDS*MEMWDTH-1:0] mem_dout;

  input clk;
  input rst;

  input [BITADDR-1:0] select_addr;

  align_2rw #(.WIDTH (WIDTH), .PARITY (PARITY), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
              .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .NUMSROW (NUMSROW), .BITSROW (BITSROW), .BITPADR (BITPADR),
              .SRAM_DELAY (SRAM_DELAY), .FLOPMEM (FLOPMEM))
    core (.write(write), .read(read), .addr(addr), .din(din), .dout(dout), .serr(serr), .padr(padr),
          .mem_write(mem_write), .mem_read(mem_read), .mem_addr(mem_addr), .mem_bw(mem_bw), .mem_din(mem_din), .mem_dout(mem_dout),
          .clk (clk), .rst (rst));

`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));

ip_top_sva_align_2rw #(
     .WIDTH       (WIDTH),
     .PARITY      (PARITY),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWRDS     (NUMWRDS),
     .BITWRDS     (BITWRDS),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPMEM     (FLOPMEM),
     .RSTZERO     (RSTZERO))
ip_top_sva (.*);

ip_top_sva_2_align_2rw #(
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
// generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin: sva_loop
  wire [BITADDR-1:0] help_addr = sva_int;
ip_top_sva_align_2rw #(
     .WIDTH       (WIDTH),
     .PARITY      (PARITY),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWRDS     (NUMWRDS),
     .BITWRDS     (BITWRDS),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPMEM     (FLOPMEM),
     .RSTZERO     (RSTZERO))
ip_top_sva (.select_addr(help_addr), .*);
end
endgenerate

ip_top_sva_2_align_2rw #(
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW))
ip_top_sva_2 (.*);

`endif

endmodule
