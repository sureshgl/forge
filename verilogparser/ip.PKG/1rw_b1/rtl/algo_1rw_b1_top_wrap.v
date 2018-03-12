/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_1rw_b1_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0, parameter IP_REFLOPW = 0,

parameter T1_WIDTH = 16, parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 1, parameter T1_DELAY = 2, parameter T1_NUMVROW = 32768, parameter T1_BITVROW = 15,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1,  parameter T1_NUMSROW = 4096, parameter T1_BITSROW = 12, parameter T1_PHYWDTH = 128,
parameter T1_NUMRBNK = 2, parameter T1_BITRBNK = 1, parameter T1_NUMRROW = 256, parameter T1_BITRROW = 8, parameter T1_NUMPROW = 4096, parameter T1_BITPROW = 12,
parameter T1_BITDWSN = 8, 
parameter T1_NUMDWS0 = 0, parameter T1_NUMDWS1 = 0, parameter T1_NUMDWS2 = 0, parameter T1_NUMDWS3 = 0,
parameter T1_NUMDWS4 = 0, parameter T1_NUMDWS5 = 0, parameter T1_NUMDWS6 = 0, parameter T1_NUMDWS7 = 0,
parameter T1_NUMDWS8 = 0, parameter T1_NUMDWS9 = 0, parameter T1_NUMDWS10 = 0, parameter T1_NUMDWS11 = 0,
parameter T1_NUMDWS12 = 0, parameter T1_NUMDWS13 = 0, parameter T1_NUMDWS14 = 0, parameter T1_NUMDWS15 = 0
)
( clk, rst, ready, refr,
 rw_read,  rw_write,  rw_addr,  rw_din,  rw_dout, rw_vld, rw_serr, rw_derr, rw_padr,
 t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_bwA,  t1_doutA, t1_dwsnA,
 t1_refrB, t1_bankB);

// MEMOIR_TRANSLATE_OFF
 
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;   // ALGO Parameters
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;      
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;      
  parameter PHYWDTH = T1_PHYWDTH;
  parameter REFRESH = IP_REFRESH;      // REFRESH Parameters 
  parameter NUMRBNK = T1_NUMRBNK;
  parameter BITWSPF = T1_BITWSPF;
  parameter BITRBNK = T1_BITRBNK;
  parameter NUMRROW = T1_NUMRROW;
  parameter BITRROW = T1_BITRROW;
  parameter REFFREQ = IP_REFFREQ;
  parameter REFFRHF = IP_REFFRHF;
  parameter REFLOPW = IP_REFLOPW;
  parameter BITDWSN = T1_BITDWSN;		//DWSN Parameters
  parameter NUMDWS0 = T1_NUMDWS0;
  parameter NUMDWS1 = T1_NUMDWS1;
  parameter NUMDWS2 = T1_NUMDWS2;
  parameter NUMDWS3 = T1_NUMDWS3;
  parameter NUMDWS4 = T1_NUMDWS4;
  parameter NUMDWS5 = T1_NUMDWS5;
  parameter NUMDWS6 = T1_NUMDWS6;
  parameter NUMDWS7 = T1_NUMDWS7;
  parameter NUMDWS8 = T1_NUMDWS8;
  parameter NUMDWS9 = T1_NUMDWS9;
  parameter NUMDWS10 = T1_NUMDWS10;
  parameter NUMDWS11 = T1_NUMDWS11;
  parameter NUMDWS12 = T1_NUMDWS12;
  parameter NUMDWS13 = T1_NUMDWS13;
  parameter NUMDWS14 = T1_NUMDWS14;
  parameter NUMDWS15 = T1_NUMDWS15;

  parameter SRAM_DELAY = T1_DELAY;
  
  parameter BITPADR = BITVBNK+BITSROW+BITWRDS+1;
  
  input                          refr;
  
  input                          rw_read;
  input                          rw_write;
  input [BITADDR-1:0]            rw_addr;
  input [WIDTH-1:0]              rw_din;
  
  output                         rw_vld;
  output [WIDTH-1:0]             rw_dout;
  output                         rw_serr;
  output                         rw_derr;
  output [BITPADR-1:0]           rw_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMVBNK-1:0] t1_readA;
  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input  [NUMVBNK*PHYWDTH-1:0] t1_doutA;
  output [NUMVBNK*BITDWSN-1:0] t1_dwsnA;

  output [NUMVBNK-1:0] t1_refrB;
  output [NUMVBNK*BITRBNK-1:0] t1_bankB;

`ifdef AMP_REF
  wire                       rw_vld_rtl;
  wire [WIDTH-1:0]           rw_dout_rtl;
  wire                       rw_serr_rtl;
  wire                       rw_derr_rtl;
  wire [BITPADR-1:0]         rw_padr_rtl;

  task Write;
  input [BITADDR-1:0] addr;
  input [WIDTH-1:0] din;
  begin
    algo_ref.bdw_flag[addr] = 1'b1;
    algo_ref.mem[addr] = din;
  end
  endtask
  
  task Read;
  input [BITADDR-1:0] addr;
  output [WIDTH-1:0] dout;
  begin
`ifdef SUPPORTED
    if (algo_ref.mem.exists(addr))
      dout = algo_ref.mem[addr];
    else
      dout = {WIDTH{1'bx}};
`else
    dout = algo_ref.mem[addr];
`endif
  end
  endtask

  algo_1rw_ref #(
    .WIDTH(WIDTH), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .MEM_DELAY(T1_DELAY+FLOPIN+FLOPMEM+FLOPOUT),
    .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK),
    .NUMSROW(NUMSROW), .BITSROW(BITSROW), .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS),
    .BITPADR(BITPADR)) algo_ref (
    .read_0(rw_read), .addr_0(rw_addr), .read_vld_0(rw_vld), .dout_0(rw_dout),
    .read_serr_0(rw_serr), .read_derr_0(rw_derr), .read_padr_0(rw_padr),
    .write_0(rw_write), .din_0(rw_din), .clk(clk), .rst(rst));
`endif

reg H2O_AMC1RWB1_001_00;
always @(posedge clk)
  H2O_AMC1RWB1_001_00 <= rst;
wire rst_int = H2O_AMC1RWB1_001_00 && rst;

  algo_nror1w_dup_top
                        #(.WIDTH(WIDTH),   .BITWDTH(BITWDTH),   .NUMADDR(NUMADDR),   .BITADDR(BITADDR),   .NUMRDPT(1),   .NUMVROW(NUMVROW),    .BITVROW(BITVROW),
                        .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK),   .NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),    .BITSROW(BITSROW),
                        .REFRESH(REFRESH), .NUMRBNK(NUMRBNK),   .BITWSPF(BITWSPF),  .BITRBNK(BITRBNK),   .NUMRROW(NUMRROW),   .BITRROW(BITRROW),    .REFFREQ(REFFREQ),       .REFFRHF(REFFRHF),      .REFLOPW(REFLOPW),
                        .SRAM_DELAY(SRAM_DELAY),   .FLOPIN(FLOPIN),   .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT),   .PHYWDTH(PHYWDTH),
                        .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                        .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                        .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                        .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15),
                        .BITDWSN (BITDWSN))

  algo_top
                  (.clk(clk), .rst(rst_int), .ready(ready), .refr(refr),
                .write(rw_write), .wr_adr(rw_addr), .din(rw_din),
`ifdef AMP_REF
                .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld_rtl), .rd_dout(rd_dout_rtl), .rd_serr(rd_serr_rtl), .rd_derr(rd_derr_rtl), .rd_padr(rd_padr_rtl),
`else
                .read(rw_read), .rd_adr(rw_addr), .rd_vld(rw_vld), .rd_dout(rw_dout), .rd_serr(rw_serr), .rd_derr(rw_derr), .rd_padr(rw_padr),
`endif
                .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_bwA(t1_bwA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA), .t1_serrA(), .t1_dwsnA(t1_dwsnA),
                .t1_refrB(t1_refrB), .t1_bankB(t1_bankB));
/* SHARAD just in case
algo_1rw_top
#(.WIDTH(WIDTH),   .BITWDTH(BITWDTH),   .NUMADDR(NUMADDR),   .BITADDR(BITADDR),   .NUMVROW(NUMVROW),   .BITVROW(BITVROW),
  .NUMVBNK(NUMVBNK),   .BITVBNK(BITVBNK),   .NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW), .PHYWDTH(PHYWDTH), 
  .REFRESH(REFRESH),   .NUMRBNK(NUMRBNK),   .BITWSPF(BITWSPF),  .BITRBNK(BITRBNK),   .NUMRROW(NUMRROW),   .BITRROW(BITRROW),   .REFFREQ(REFFREQ), .REFFRHF(REFFRHF),
  .SRAM_DELAY(SRAM_DELAY),   .FLOPOUT(FLOPOUT),   
  .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
  .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
  .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
  .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15),
  .BITDWSN (BITDWSN))
  algo_top
     (.clk(clk), .rst(rst_int), .ready(ready), .refr(refr),
`ifdef AMP_REF
   .read(rw_read), .write(rw_write), .addr(rw_addr), .din(rw_din), .rd_vld(rw_vld_rtl), .rd_dout(rw_dout_rtl), .rd_serr(rw_serr_rtl), .rd_derr(rw_derr_rtl), .rd_padr(rw_padr_rtl),
`else
   .read(rw_read), .write(rw_write), .addr(rw_addr), .din(rw_din), .rd_vld(rw_vld), .rd_dout(rw_dout), .rd_serr(rw_serr), .rd_derr(rw_derr), .rd_padr(rw_padr),
`endif
   .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_bwA(t1_bwA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA), .t1_dwsnA(t1_dwsnA),
   .t1_refrB(t1_refrB), .t1_bankB(t1_bankB));
*/
// MEMOIR_TRANSLATE_ON
 
endmodule    //algo_1rw_b1_top_wrap
