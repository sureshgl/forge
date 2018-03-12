module infra_align_ecc_pseudo (write, wr_bnk, wr_adr, din,
                               read, rd_bnk, rd_adr, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
	                       mem_write, mem_wr_bnk, mem_wr_adr, mem_wr_dwsn, mem_bw, mem_din,
                               mem_read, mem_rd_bnk, mem_rd_adr, mem_rd_dwsn, mem_rd_dout, mem_rd_fwrd, mem_rd_padr,
		               clk, rst,
		               select_vrow);

  parameter WIDTH = 32;
  parameter ENAPSDO = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ENADEC = 0;
  parameter ECCWDTH = 7;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
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

  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENADEC ? 2*WIDTH+ECCWDTH : WIDTH;

  input write;
  input [BITVBNK-1:0] wr_bnk;
  input [BITVROW-1:0] wr_adr;
  input [WIDTH-1:0] din;

  input read;
  input [BITVBNK-1:0] rd_bnk;
  input [BITVROW-1:0] rd_adr;
  output [WIDTH-1:0] rd_dout;
  output rd_fwrd;
  output rd_serr;
  output rd_derr;
  output [BITPADR-1:0] rd_padr;

  output mem_write;
  output [BITVBNK-1:0] mem_wr_bnk;
  output [BITSROW-1:0] mem_wr_adr;
  output [BITDWSN-1:0] mem_wr_dwsn;
  output [NUMWRDS*MEMWDTH-1:0] mem_bw;
  output [NUMWRDS*MEMWDTH-1:0] mem_din;

  output mem_read;
  output [BITVBNK-1:0] mem_rd_bnk;
  output [BITSROW-1:0] mem_rd_adr;
  output [BITDWSN-1:0] mem_rd_dwsn;
  input [NUMWRDS*MEMWDTH-1:0] mem_rd_dout;
  input mem_rd_fwrd;
  input [BITPADR-BITWRDS-1:0] mem_rd_padr;

  input clk;
  input rst;

  input [BITVROW-1:0] select_vrow;

  align_ecc_pseudo #(.WIDTH (WIDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ENADEC (ENADEC), .ECCWDTH (ECCWDTH),
                     .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                     .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .NUMSROW (NUMSROW), .BITSROW (BITSROW), .BITPADR (BITPADR),
                     .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                     .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                     .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                     .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                     .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPGEN), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPOUT), .ENAPADR (ENAPADR))
    core (.write (write), .wr_bnk (wr_bnk), .wr_adr (wr_adr), .din (din),
          .read (read), .rd_bnk (rd_bnk), .rd_adr (rd_adr), .rd_dout (rd_dout), .rd_fwrd (rd_fwrd), .rd_serr (rd_serr), .rd_derr (rd_derr), .rd_padr (rd_padr),
          .mem_write (mem_write), .mem_wr_bnk (mem_wr_bnk), .mem_wr_adr (mem_wr_adr), .mem_wr_dwsn (mem_wr_dwsn), .mem_bw (mem_bw), .mem_din (mem_din),
          .mem_read (mem_read), .mem_rd_bnk (mem_rd_bnk), .mem_rd_adr (mem_rd_adr), .mem_rd_dwsn (mem_rd_dwsn),
          .mem_rd_dout (mem_rd_dout), .mem_rd_fwrd (mem_rd_fwrd), .mem_rd_padr (mem_rd_padr),
          .clk (clk), .rst (rst));

`ifdef FORMAL
assume_select_vrow_range: assume property (@(posedge clk) disable iff (rst) (select_vrow < NUMVROW));
assume_select_vrow_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_vrow));

ip_top_sva_align_ecc_pseudo #(
     .WIDTH       (WIDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .ENADEC      (ENADEC),
     .ECCWDTH     (ECCWDTH),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
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

ip_top_sva_2_align_ecc_pseudo #(
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
// generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin: sva_loop
  wire [BITVBNK-1:0] help_bank = sva_int;
  wire [BITVROW-1:0] help_vrow = sva_int;
ip_top_sva_align_ecc_pseudo #(
     .WIDTH       (WIDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .ENADEC      (ENADEC),
     .ECCWDTH     (ECCWDTH),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
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
ip_top_sva (.select_vrow(help_vrow), .*);
end
endgenerate

ip_top_sva_2_align_ecc_pseudo #(
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW))
ip_top_sva_2 (.*);

`endif

endmodule

