module infra_align_ecc_1r1w (write, wr_adr, din, read, rd_adr, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
	                     mem_write, mem_wr_adr, mem_bw, mem_din, mem_read, mem_rd_adr, mem_rd_dout, mem_rd_fwrd, mem_rd_padr,
		             clk, rst,
		             select_addr);

  parameter WIDTH = 32;
  parameter ENAPSDO = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ENADEC = 0;
  parameter ENAHEC = 0;
  parameter ENAQEC = 0;
  parameter ECCWDTH = 7;
  parameter NUMADDR = 1024;
  parameter BITADDR = 10;
  parameter NUMWRDS = 4;
  parameter BITWRDS = 2;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter BITPADR = 10;
  parameter SRAM_DELAY = 2;
  parameter FLOPGEN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;
  parameter ENAPADR = 0;
  parameter RSTZERO = 0;
  parameter RSTONES = 0;
  parameter CGFLOPC = 0;
  parameter CGFLOPM = 0;
  parameter CGFLOPO = 0;
  parameter FLOPECC1 = 0;
  parameter FLOPECC2 = 0;

  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENADEC ? 2*WIDTH+ECCWDTH : ENAHEC ? WIDTH+2*ECCWDTH : ENAQEC ? WIDTH+4*ECCWDTH : WIDTH;

  input write;
  input [BITADDR-1:0] wr_adr;
  input [WIDTH-1:0] din;

  input read;
  input [BITADDR-1:0] rd_adr;
  output [WIDTH-1:0] rd_dout;
  output rd_fwrd;
  output rd_serr;
  output rd_derr;
  output [BITPADR-1:0] rd_padr;

  output mem_write;
  output [BITSROW-1:0] mem_wr_adr;
  output [NUMWRDS*MEMWDTH-1:0] mem_bw;
  output [NUMWRDS*MEMWDTH-1:0] mem_din;

  output mem_read;
  output [BITSROW-1:0] mem_rd_adr;
  input [NUMWRDS*MEMWDTH-1:0] mem_rd_dout;
  input mem_rd_fwrd;
  input [BITPADR-BITWRDS-1:0] mem_rd_padr;

  input clk;
  input rst;

  input [BITADDR-1:0] select_addr;

  align_ecc_1r1w #(.WIDTH (WIDTH), .ENAPSDO (ENAPSDO), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                   .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ENADEC (ENADEC), .ENAHEC (ENAHEC), .ENAQEC (ENAQEC), .ECCWDTH (ECCWDTH),
                   .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .NUMSROW (NUMSROW), .BITSROW (BITSROW), .BITPADR (BITPADR),
                   .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPGEN), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPOUT), .ENAPADR (ENAPADR),
                   .CGFLOPC(CGFLOPC), .CGFLOPM(CGFLOPM), .CGFLOPO(CGFLOPO), .FLOPECC1(FLOPECC1), .FLOPECC2(FLOPECC2)
                 )
    core (.write (write), .wr_adr (wr_adr), .din (din),
          .read (read), .rd_adr (rd_adr), .rd_dout (rd_dout), .rd_fwrd (rd_fwrd), .rd_serr (rd_serr), .rd_derr (rd_derr), .rd_padr (rd_padr),
          .mem_write (mem_write), .mem_wr_adr (mem_wr_adr), .mem_bw (mem_bw), .mem_din (mem_din),
          .mem_read (mem_read), .mem_rd_adr (mem_rd_adr), .mem_rd_dout (mem_rd_dout), .mem_rd_fwrd (mem_rd_fwrd), .mem_rd_padr (mem_rd_padr),
          .clk (clk), .rst (rst));

`ifdef FORMAL
//synopsys translate_off
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));

ip_top_sva_align_ecc_1r1w #(
     .WIDTH       (WIDTH),
     .ENAPSDO     (ENAPSDO),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .ENADEC      (ENADEC),
     .ENAHEC      (ENAHEC),
     .ENAQEC      (ENAQEC),
     .ECCWDTH     (ECCWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWRDS     (NUMWRDS),
     .BITWRDS     (BITWRDS),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPGEN     (FLOPGEN),
     .FLOPCMD     (FLOPCMD),
     .FLOPMEM     (FLOPMEM),
     .FLOPOUT     (FLOPOUT),
     .ENAPADR     (ENAPADR),
     .RSTZERO     (RSTZERO),
     .RSTONES     (RSTONES))
ip_top_sva (.*);

ip_top_sva_2_align_ecc_1r1w #(
     .ENAPSDO     (ENAPSDO),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW))
ip_top_sva_2 (.*);
//synopsys translate_on

`elsif SIM_SVA
//synopsys translate_off

genvar sva_int;
// generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin: sva_loop
  wire [BITADDR-1:0] help_addr = sva_int;
ip_top_sva_align_ecc_1r1w #(
     .WIDTH       (WIDTH),
     .ENAPSDO     (ENAPSDO),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .ENADEC      (ENADEC),
     .ENAHEC      (ENAHEC),
     .ENAQEC      (ENAQEC),
     .ECCWDTH     (ECCWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMWRDS     (NUMWRDS),
     .BITWRDS     (BITWRDS),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPGEN     (FLOPGEN),
     .FLOPCMD     (FLOPCMD),
     .FLOPMEM     (FLOPMEM),
     .FLOPOUT     (FLOPOUT),
     .ENAPADR     (ENAPADR),
     .RSTZERO     (RSTZERO),
     .RSTONES     (RSTONES))
ip_top_sva (.select_addr(help_addr), .*);
end
endgenerate

ip_top_sva_2_align_ecc_1r1w #(
     .ENAPSDO     (ENAPSDO),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW))
ip_top_sva_2 (.*);
//synopsys translate_on

`endif

endmodule

