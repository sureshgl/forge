module infra_align_dwsn_a20 (read, write, addr, din, dout, serr, padr,
	                     mem_read, mem_write, mem_addr, mem_bw, mem_dwsn, mem_din, mem_dout,
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
  parameter NUMDWS0 = 72;
  parameter NUMDWS1 = 72;
  parameter NUMDWS2 = 72;
  parameter NUMDWS3 = 72;
  parameter NUMDWS4 = 72;
  parameter NUMDWS5 = 72;
  parameter NUMDWS6 = 72;
  parameter NUMDWS7 = 72;
  parameter NUMDWS8 = 72;
  parameter NUMDWS9 = 72;
  parameter NUMDWS10 = 72;
  parameter NUMDWS11 = 72;
  parameter NUMDWS12 = 72;
  parameter NUMDWS13 = 72;
  parameter NUMDWS14 = 72;
  parameter NUMDWS15 = 72;
  parameter BITDWSN = 4;
  parameter SRAM_DELAY = 2;
  parameter RSTZERO = 1;
  parameter FLOPMEM = 0;

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
  output [BITDWSN-1:0] mem_dwsn;
  output [NUMWRDS*MEMWDTH-1:0] mem_din;
  input [NUMWRDS*MEMWDTH-1:0] mem_dout;

  input clk;
  input rst;

  input [BITADDR-1:0] select_addr;

  align_dwsn #(.WIDTH (WIDTH), .PARITY (PARITY), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .NUMSROW (NUMSROW), .BITSROW (BITSROW), .BITPADR (BITPADR),
               .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
               .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7), 
 	       .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
               .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15),
               .BITDWSN (BITDWSN), .SRAM_DELAY (SRAM_DELAY))
    core (.read (read), .write (write), .addr (addr), .din (din), .dout (dout), .serr (serr), .padr (padr),
          .mem_read (mem_read), .mem_write (mem_write), .mem_addr (mem_addr),
          .mem_bw (mem_bw), .mem_dwsn (mem_dwsn), .mem_din (mem_din), .mem_dout (mem_dout),
          .clk (clk));

`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));

ip_top_sva_align_dwsn_a20 #(
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

ip_top_sva_2_align_dwsn_a20 #(
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
ip_top_sva_align_dwsn_a20 #(
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

ip_top_sva_2_align_dwsn_a20 #(
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW))
ip_top_sva_2 (.*);

`endif

endmodule
