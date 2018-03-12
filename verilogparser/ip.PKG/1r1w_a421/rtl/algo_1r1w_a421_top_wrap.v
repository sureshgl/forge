/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

module algo_1r1w_a421_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 48, parameter T1_NUMVBNK = 8, parameter T1_BITVBNK = 3, parameter T1_DELAY = 2, parameter T1_NUMVROW = 4096, parameter T1_BITVROW = 12,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 2, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 2048, parameter T1_BITSROW = 11, parameter T1_PHYWDTH = 96,
parameter T1_NUMRBNK = 2, parameter T1_BITRBNK = 1, parameter T1_NUMRROW = 256, parameter T1_BITRROW = 8, parameter T1_NUMPROW = 4096, parameter T1_BITPROW = 12,
parameter T1_BITDWSN = 8, 
parameter T1_NUMDWS0 = 0, parameter T1_NUMDWS1 = 0, parameter T1_NUMDWS2 = 0, parameter T1_NUMDWS3 = 0,
parameter T1_NUMDWS4 = 0, parameter T1_NUMDWS5 = 0, parameter T1_NUMDWS6 = 0, parameter T1_NUMDWS7 = 0,
parameter T1_NUMDWS8 = 0, parameter T1_NUMDWS9 = 0, parameter T1_NUMDWS10 = 0, parameter T1_NUMDWS11 = 0,
parameter T1_NUMDWS12 = 0, parameter T1_NUMDWS13 = 0, parameter T1_NUMDWS14 = 0, parameter T1_NUMDWS15 = 0,

parameter T2_WIDTH = 60, parameter T2_NUMVBNK = 2, parameter T2_BITVBNK = 1, parameter T2_DELAY = 2, parameter T2_NUMVROW = 4096, parameter T2_BITVROW = 12, 
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 4096, parameter T2_BITSROW = 12, parameter T2_PHYWDTH = 60
)
(wclk, clk, rst, ready,
  write, wr_adr, din,
  read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
  t1_readA, t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_doutA,
  t2_readA, t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_doutA);

// MEMOIR_TRANSLATE_OFF
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;   // ALGO Parameters
  parameter BITVROW = T1_BITVROW;
  parameter BITPROW = T1_BITPROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter SRAM_DELAY = T1_DELAY;
  parameter PHYWDTH = T1_PHYWDTH;
  parameter ECCBITS = IP_SECCBITS;
  
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;
  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input                                read;
  input [BITADDR-1:0]                  rd_adr;
  output                               rd_vld;
  output [WIDTH-1:0]                   rd_dout;
  output                               rd_serr;
  output                               rd_derr;
  output [BITPADR-1:0]                 rd_padr;

  output                               ready;
  input                                wclk, clk, rst;

  output [NUMVBNK-1:0] t1_readA;
  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input  [NUMVBNK*PHYWDTH-1:0] t1_doutA;

  output [2-1:0] t2_readA;
  output [2-1:0] t2_writeA;
  output [2*BITVROW-1:0] t2_addrA;
  output [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_bwA;
  output [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA;
  input [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutA;

reg H2O_AMP1R1WA421_001_00;
always @(posedge clk)
  H2O_AMP1R1WA421_001_00 <= rst;
wire rst_int = H2O_AMP1R1WA421_001_00 && rst;

reg rst_0_wrc, rst_1_wrc;
always @(posedge clk) begin
  rst_1_wrc <= rst_0_wrc;
  rst_0_wrc <= rst;
end

reg wrptr_wrc;
reg [BITADDR-1:0] wr_adr_reg_wrc [0:2-1];
reg [WIDTH-1:0] din_reg_wrc [0:2-1];
always @(posedge wclk)
  if (rst_1_wrc)
    wrptr_wrc <= 1'b0;
  else if (write) begin
    wrptr_wrc <= !wrptr_wrc;
    wr_adr_reg_wrc[wrptr_wrc] <= wr_adr;
    din_reg_wrc[wrptr_wrc] <= din;
  end 

reg wrptr_async_0, wrptr_async_1;
always @(posedge clk) begin
  wrptr_async_1 <= wrptr_async_0;;
  wrptr_async_0 <= wrptr_wrc;
end

reg rdptr;
always @(posedge clk)
  if (rst)
    rdptr <= 1'b0;
  else if (rdptr ^ wrptr_async_1)
    rdptr <= wrptr_async_1;

algo_1rfw_1rw_rl2_top
			  #(.WIDTH(WIDTH),   .BITWDTH(BITWDTH),   .NUMADDR(NUMADDR),   .BITADDR(BITADDR),
			    .NUMVROW(NUMVROW),  .BITVROW(BITVROW),  .NUMVBNK(NUMVBNK),   .BITVBNK(BITVBNK), .BITPBNK(BITPBNK),
                            .NUMCBNK(2), .BITCBNK(1),
                            .NUMWRDS(NUMWRDS),  .BITWRDS(BITWRDS),  .NUMSROW(NUMSROW),  .BITSROW(BITSROW),
			    .SRAM_DELAY(SRAM_DELAY), .FLOPIN(FLOPIN),   .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT),
			    .PHYWDTH(PHYWDTH),  .ECCBITS(ECCBITS))
		algo_top	  
			(.clk(clk), .rst(rst_int), .ready(ready),
			 .write(rdptr^wrptr_async_1), .wr_adr(wr_adr_reg_wrc[rdptr]), .din(din_reg_wrc[rdptr]),
                         .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
			 .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_bwA(t1_bwA),.t1_dinA(t1_dinA), .t1_doutA(t1_doutA),
			 .t2_readA(t2_readA), .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_bwA(t2_bwA),.t2_dinA(t2_dinA), .t2_doutA(t2_doutA));

// MEMOIR_TRANSLATE_ON
endmodule    //algo_1r1w_a421_top_wrap
