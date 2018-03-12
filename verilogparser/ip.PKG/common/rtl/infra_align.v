module infra_align (read, write, addr, din, dout, serr, padr,
	            mem_read, mem_write, mem_addr, mem_bw, mem_din, mem_dout,
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

  parameter MEMWDTH = WIDTH+PARITY;

  input read;
  input write;
  input [BITADDR-1:0] addr;
  input [WIDTH-1:0] din;
  output [WIDTH-1:0] dout;
  output             serr;
  output [BITPADR-1:0] padr;

  output mem_read;
  output mem_write;
  output [BITSROW-1:0] mem_addr;
  output [NUMWRDS*MEMWDTH-1:0] mem_bw;
  output [NUMWRDS*MEMWDTH-1:0] mem_din;
  input [NUMWRDS*MEMWDTH-1:0] mem_dout;

  input clk;
  input rst;

  input [BITADDR-1:0] select_addr;

  align #(.WIDTH (WIDTH), .PARITY (PARITY), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
          .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .NUMSROW (NUMSROW), .BITSROW (BITSROW), .BITPADR (BITPADR),
          .SRAM_DELAY (SRAM_DELAY))
    core (.read (read),
          .write (write),
          .addr (addr),
          .din (din),
          .dout (dout),
	  .serr (serr),
          .padr (padr),
          .mem_read (mem_read),
          .mem_write (mem_write),
          .mem_addr (mem_addr),
          .mem_bw (mem_bw),
          .mem_din (mem_din),
          .mem_dout (mem_dout),
          .clk (clk));

`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));

ip_top_sva_align #(
     .WIDTH       (WIDTH),
     .PARITY      (PARITY),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWRDS     (NUMWRDS),
     .BITWRDS     (BITWRDS),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW),
     .SRAM_DELAY  (SRAM_DELAY))
ip_top_sva (.*);

ip_top_sva_2_align #(
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
ip_top_sva_align #(
     .WIDTH       (WIDTH),
     .PARITY      (PARITY),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWRDS     (NUMWRDS),
     .BITWRDS     (BITWRDS),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW),
     .SRAM_DELAY  (SRAM_DELAY))
ip_top_sva (.select_addr(help_addr), .*);
end
endgenerate

ip_top_sva_2_align #(
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW))
ip_top_sva_2 (.*);

`endif

endmodule
