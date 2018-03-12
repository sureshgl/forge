module infra_align_ecc_mrnw (write, wr_adr, din, read, rd_adr, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
	                     mem_write, mem_wr_adr, mem_bw, mem_din, mem_read, mem_rd_adr, mem_rd_fwrd, mem_rd_dout, mem_rd_padr,
		             clk, rst,
		             select_addr);

  parameter WIDTH = 32;
  parameter ENAPSDO = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ENADEC = 0;
  parameter ECCWDTH = 7;
  parameter NUMRDPT = 2;
  parameter NUMWRPT = 2;
  parameter NUMADDR = 1024;
  parameter BITADDR = 10;
  parameter NUMWRDS = 4;
  parameter BITWRDS = 2;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter BITPADR = 10;
  parameter SRAM_DELAY = 2;
  parameter FLOPGEN = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;
  parameter RSTZERO = 0;
  parameter ENAPADR = 0;

  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENADEC ? 2*WIDTH+ECCWDTH : WIDTH;

  input [NUMWRPT-1:0] write;
  input [NUMWRPT*BITADDR-1:0] wr_adr;
  input [NUMWRPT*WIDTH-1:0] din;

  input [NUMRDPT-1:0] read;
  input [NUMRDPT*BITADDR-1:0] rd_adr;
  output [NUMRDPT-1:0] rd_vld;
  output [NUMRDPT*WIDTH-1:0] rd_dout;
  output [NUMRDPT-1:0] rd_fwrd;
  output [NUMRDPT-1:0] rd_serr;
  output [NUMRDPT-1:0] rd_derr;
  output [NUMRDPT*BITPADR-1:0] rd_padr;

  output [NUMWRPT-1:0] mem_write;
  output [NUMWRPT*BITSROW-1:0] mem_wr_adr;
  output [NUMWRPT*NUMWRDS*MEMWDTH-1:0] mem_bw;
  output [NUMWRPT*NUMWRDS*MEMWDTH-1:0] mem_din;

  output [NUMRDPT-1:0] mem_read;
  output [NUMRDPT*BITSROW-1:0] mem_rd_adr;
  input [NUMRDPT-1:0] mem_rd_fwrd;
  input [NUMRDPT*NUMWRDS*MEMWDTH-1:0] mem_rd_dout;
  input [NUMRDPT*(BITPADR-BITWRDS)-1:0] mem_rd_padr;

  input clk;
  input rst;

  input [BITADDR-1:0] select_addr;

  align_ecc_mrnw #(.WIDTH (WIDTH), .ENAPSDO (ENAPSDO), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ENADEC (ENADEC), .ECCWDTH (ECCWDTH),
                   .NUMRDPT (NUMRDPT), .NUMWRPT (NUMWRPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                   .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .NUMSROW (NUMSROW), .BITSROW (BITSROW), .BITPADR (BITPADR),
                   .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPGEN), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPOUT), .ENAPADR (ENAPADR))
    core (.write (write), .wr_adr (wr_adr), .din (din),
          .read (read), .rd_adr (rd_adr), .rd_vld (rd_vld), .rd_dout (rd_dout), .rd_fwrd (rd_fwrd), .rd_serr (rd_serr), .rd_derr (rd_derr), .rd_padr (rd_padr),
          .mem_write (mem_write), .mem_wr_adr (mem_wr_adr), .mem_bw (mem_bw), .mem_din (mem_din),
          .mem_read (mem_read), .mem_rd_adr (mem_rd_adr), .mem_rd_fwrd (mem_rd_fwrd), .mem_rd_dout (mem_rd_dout), .mem_rd_padr (mem_rd_padr),
          .clk (clk), .rst (rst));

`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));

ip_top_sva_align_ecc_mrnw #(
     .WIDTH       (WIDTH),
     .ENAPSDO     (ENAPSDO),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .ENADEC      (ENADEC),
     .ECCWDTH     (ECCWDTH),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWRDS     (NUMWRDS),
     .BITWRDS     (BITWRDS),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPGEN     (FLOPGEN),
     .FLOPMEM     (FLOPMEM),
     .FLOPOUT     (FLOPOUT),
     .RSTZERO     (RSTZERO),
     .ENAPADR     (ENAPADR),
     .BITPADR     (BITPADR))
ip_top_sva (.*);

ip_top_sva_2_align_ecc_mrnw #(
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
// generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin: sva_loop
  wire [BITADDR-1:0] help_addr = sva_int;
ip_top_sva_align_ecc_mrnw #(
     .WIDTH       (WIDTH),
     .ENAPSDO     (ENAPSDO),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .ENADEC      (ENADEC),
     .ECCWDTH     (ECCWDTH),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWRDS     (NUMWRDS),
     .BITWRDS     (BITWRDS),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPGEN     (FLOPGEN),
     .FLOPMEM     (FLOPMEM),
     .FLOPOUT     (FLOPOUT),
     .RSTZERO     (RSTZERO),
     .ENAPADR     (ENAPADR),
     .BITPADR     (BITPADR))
ip_top_sva (.select_addr(help_addr), .*);
end
endgenerate

ip_top_sva_2_align_ecc_mrnw #(
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW))
ip_top_sva_2 (.*);

`endif

endmodule
