/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

module algo_1r1w_a127_top_wrap
#(parameter IP_WIDTH = 256, parameter IP_BITWIDTH = 8, parameter IP_DECCBITS = 10, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMWREN = 8, parameter IP_BITWREN = 3, parameter IP_NUMVBNK = 4, parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 5, parameter IP_SECCDWIDTH = 12, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 0, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 256, parameter T1_NUMVBNK = 4, parameter T1_BITVBNK = 2, parameter T1_DELAY = 2, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 0, parameter T1_NUMSROW = 2048, parameter T1_BITSROW = 11, parameter T1_PHYWDTH = 256,

parameter T2_WIDTH = 276, parameter T2_NUMVBNK = 2, parameter T2_BITVBNK = 1, parameter T2_DELAY = 2, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11, 
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 2048, parameter T2_BITSROW = 11, parameter T2_PHYWDTH = 276
)
(clk, rst, ready,
  write, wr_adr, wren, din,
  read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
  t1_readA, t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_doutA,
  t2_writeA, t2_addrA, t2_readB, t2_addrB, t2_bwA, t2_dinA, t2_doutB);

// MEMOIR_TRANSLATE_OFF
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMWREN = IP_NUMWREN;
  parameter BITWREN = IP_BITWREN;
  parameter NUMVROW = T1_NUMVROW;   // ALGO Parameters
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter SRAM_DELAY = T2_DELAY;
  parameter DRAM_DELAY = T1_DELAY;
  parameter PHYWDTH = T1_PHYWDTH;
  parameter ECCBITS = IP_SECCBITS;
  
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;
  parameter SDOUT_WIDTH = 2*(NUMWREN+BITVBNK)+ECCBITS;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [NUMWREN-1:0]                  wren;
  input [WIDTH-1:0]                    din;

  input                                read;
  input [BITADDR-1:0]                  rd_adr;
  output                               rd_vld;
  output [WIDTH-1:0]                   rd_dout;
  output                               rd_serr;
  output                               rd_derr;
  output [BITPADR-1:0]                 rd_padr;

  output                               ready;
  input                                clk, rst;

  output [NUMVBNK-1:0] t1_readA;
  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input  [NUMVBNK*PHYWDTH-1:0] t1_doutA;

  output [2-1:0] t2_writeA;
  output [2*BITVROW-1:0] t2_addrA;
  output [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_bwA;
  output [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA;

  output [2-1:0] t2_readB;
  output [2*BITVROW-1:0] t2_addrB;
  input [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB;

reg H2O_AMP1R1WA127_001_00;
always @(posedge clk)
  H2O_AMP1R1WA127_001_00 <= rst;
wire rst_int = H2O_AMP1R1WA127_001_00 && rst;

algo_1r1we_rl2_pseudo_top
			  #(.WIDTH(WIDTH>>BITWREN),   .BITWDTH(BITWDTH-BITWREN),   .NUMWREN(NUMWREN),    .BITWREN(BITWREN),    .NUMADDR(NUMADDR),   .BITADDR(BITADDR),
				.NUMVROW(NUMVROW),  .BITVROW(BITVROW),  .NUMVBNK(NUMVBNK),   .BITVBNK(BITVBNK),
				.BITPBNK(BITPBNK),  .NUMWRDS(NUMWRDS),  .BITWRDS(BITWRDS),
				.NUMSROW(NUMSROW),  .BITSROW(BITSROW),
				.SRAM_DELAY(SRAM_DELAY),  .DRAM_DELAY(DRAM_DELAY),  .FLOPIN(FLOPIN),   .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT),
				.PHYWDTH(PHYWDTH),  .ECCBITS(ECCBITS))
		algo_top	  
			(.clk(clk), .rst(rst_int), .ready(ready),
			 .write(write), .wr_adr(wr_adr), .wren(wren), .din(din),
                         .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
			 .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA),
                         .t1_bwA(t1_bwA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA),
			 .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_bwA(t2_bwA), .t2_dinA(t2_dinA),
                         .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB));

// MEMOIR_TRANSLATE_ON
endmodule    //algo_1r1w_a127_top_wrap
