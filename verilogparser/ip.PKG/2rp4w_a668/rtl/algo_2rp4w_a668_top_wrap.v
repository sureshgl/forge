/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_2rp4w_a668_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 11, parameter T1_BITVBNK = 4, parameter T1_DELAY = 1, parameter T1_NUMVROW = 745, parameter T1_BITVROW = 10,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 745, parameter T1_BITSROW = 10, parameter T1_PHYWDTH = 32,

parameter T2_WIDTH = 32, parameter T2_NUMVBNK = 3, parameter T2_BITVBNK = 2, parameter T2_DELAY = 1, parameter T2_NUMVROW = 745, parameter T2_BITVROW = 10,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 745, parameter T2_BITSROW = 10, parameter T2_PHYWDTH = 32,

parameter T3_WIDTH = 15, parameter T3_NUMVBNK = 4, parameter T3_BITVBNK = 2, parameter T3_DELAY = 1, parameter T3_NUMVROW = 745, parameter T3_BITVROW = 10,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 1, parameter T3_NUMSROW = 745, parameter T3_BITSROW = 10, parameter T3_PHYWDTH = 15)
		(clk, rst, ready,
		 write, wr_adr, din, wr_bp_5, wr_bp_4, wr_bp_3, wr_bp_2, bp_thr,
		 read, rd_adr, rd_vld, rd_serr, rd_derr, rd_dout, rd_padr,
		 t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
                 t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
                 t3_writeA, t3_addrA, t3_bwA, t3_dinA, t3_readB, t3_addrB, t3_doutB);

// MEMOIR_TRANSLATE_OFF
		
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMRDPT = 2;
  parameter NUMWRPT = 4;
  parameter NUMVROW = T1_NUMVROW;
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter PHYWDTH = NUMWRDS*WIDTH;
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T1_DELAY;
  
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;
  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input [NUMWRPT-1:0]                  write;
  input [NUMWRPT*BITADDR-1:0]          wr_adr;
  input [NUMWRPT*WIDTH-1:0]            din;
  output                               wr_bp_5;
  output                               wr_bp_4;
  output                               wr_bp_3;
  output                               wr_bp_2;

  input [NUMRDPT-1:0]                  read;
  input [NUMRDPT*BITADDR-1:0]          rd_adr;
  output [NUMRDPT-1:0]                 rd_vld;
  output [NUMRDPT*WIDTH-1:0]           rd_dout;
  output [NUMRDPT-1:0]                 rd_serr;
  output [NUMRDPT-1:0]                 rd_derr;
  output [NUMRDPT*BITPADR-1:0]         rd_padr;

  input [8:0]                          bp_thr;

  output                               ready;
  input                                clk, rst;

  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMVBNK*PHYWDTH-1:0] t1_dinA;

  output [NUMVBNK-1:0] t1_readB;
  output [NUMVBNK*BITSROW-1:0] t1_addrB;
  input [NUMVBNK*PHYWDTH-1:0] t1_doutB;

  output [(NUMRDPT+1)-1:0] t2_writeA;
  output [(NUMRDPT+1)*BITVROW-1:0] t2_addrA;
  output [(NUMRDPT+1)*WIDTH-1:0] t2_dinA;
  output [(NUMRDPT+1)*WIDTH-1:0] t2_bwA;
  output [(NUMRDPT+1)-1:0] t2_readB;
  output [(NUMRDPT+1)*BITVROW-1:0] t2_addrB;
  input [(NUMRDPT+1)*WIDTH-1:0] t2_doutB;

  output [(NUMRDPT+2)-1:0] t3_writeA;
  output [(NUMRDPT+2)*BITVROW-1:0] t3_addrA;
  output [(NUMRDPT+2)*SDOUT_WIDTH-1:0] t3_dinA;
  output [(NUMRDPT+2)*SDOUT_WIDTH-1:0] t3_bwA;
  output [(NUMRDPT+2)-1:0] t3_readB;
  output [(NUMRDPT+2)*BITVROW-1:0] t3_addrB;
  input [(NUMRDPT+2)*SDOUT_WIDTH-1:0] t3_doutB;

  wire wr_bp_tmp;

  assign wr_bp_5 = wr_bp_tmp;
  assign wr_bp_4 = wr_bp_tmp;
  assign wr_bp_3 = wr_bp_tmp;
  assign wr_bp_2 = wr_bp_tmp;
  assign t3_bwA = ~0;

  algo_2rp4wt2_1r1w_top 
	  #(.WIDTH(WIDTH),       .BITWDTH(BITWDTH),   .NUMADDR(NUMADDR),   .BITADDR(BITADDR),   .NUMRDPT(NUMRDPT),  .NUMWRPT(NUMWRPT),
            .NUMVROW(NUMVROW),   .BITVROW(BITVROW),   .NUMVBNK(NUMVBNK),   .BITVBNK(BITVBNK),   .BITPBNK(BITPBNK),
            .NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW),
            .ECCBITS(ECCBITS),   .SRAM_DELAY(SRAM_DELAY),   .FLOPIN(FLOPIN),  .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT))
  algo_top
	(.clk(clk), .rst(rst), .ready(ready),
         .write(write), .wr_adr(wr_adr), .din(din), .wr_bp(wr_bp_tmp), .bp_thr(bp_thr),
         .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
         .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_bwA(t1_bwA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
         .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_bwA(t2_bwA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
         .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB));

// MEMOIR_TRANSLATE_ON
  
endmodule    //algo_2rp4w_a668_top_wrap
