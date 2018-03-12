/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.UNKNOWN Date: Wed 2012.11.21 at 01:59:18 PM IST
 * */

module algo_1r1w_a460_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 1, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 4, parameter T1_BITVBNK = 2, parameter T1_DELAY = 1, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 2, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 1024, parameter T1_BITSROW = 10, parameter T1_PHYWDTH = 64,
parameter T2_WIDTH = 32, parameter T2_NUMVBNK = 1, parameter T2_BITVBNK = 0, parameter T2_DELAY = 1, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 2, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 1024, parameter T2_BITSROW = 10, parameter T2_PHYWDTH = 64)
(wclk, clk,  rst,  ready,
  write,   wr_adr,   din,
  read,   rd_adr,   rd_dout,   rd_vld,   rd_serr,   rd_derr,   rd_padr,
  t1_readA,    t1_writeA,  t1_addrA,   t1_dinA,  t1_bwA,      t1_doutA,
  t2_readA,    t2_writeA,  t2_addrA,   t2_dinA,  t2_bwA,      t2_doutA);
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter NUMPBNK = IP_NUMVBNK + 1;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter PHYWDTH = T1_PHYWDTH;
  parameter SRAM_DELAY = 0;
  parameter DRAM_DELAY = T1_DELAY;
  parameter NUMRDPT = 1;
  parameter NUMWRPT = 1;
  
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter BITMAPT = BITPBNK*NUMVBNK;
  
  input [NUMWRPT-1:0]                  write;
  input [NUMWRPT*BITADDR-1:0]          wr_adr;
  input [NUMWRPT*WIDTH-1:0]            din;

  input [NUMRDPT-1:0]                  read;
  input [NUMRDPT*BITADDR-1:0]          rd_adr;
  output [NUMRDPT-1:0]                 rd_vld;
  output [NUMRDPT*WIDTH-1:0]           rd_dout;
  output [NUMRDPT-1:0]                 rd_serr;
  output [NUMRDPT-1:0]                 rd_derr;
  output [NUMRDPT*BITPADR-1:0]         rd_padr;

  output                               ready;
  input                                wclk, clk, rst;

  output [T1_NUMVBNK-1:0] t1_readA;
  output [T1_NUMVBNK-1:0] t1_writeA;
  output [T1_NUMVBNK*BITSROW-1:0] t1_addrA;
  output [T1_NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [T1_NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input  [T1_NUMVBNK*PHYWDTH-1:0] t1_doutA;

  output [T2_NUMVBNK-1:0] t2_readA;
  output [T2_NUMVBNK-1:0] t2_writeA;
  output [T2_NUMVBNK*BITSROW-1:0] t2_addrA;
  output [T2_NUMVBNK*PHYWDTH-1:0] t2_bwA;
  output [T2_NUMVBNK*PHYWDTH-1:0] t2_dinA;
  input  [T2_NUMVBNK*PHYWDTH-1:0] t2_doutA;

  wire [NUMWRPT-1:0] t3_writeA;
  wire [NUMWRPT*BITVROW-1:0] t3_addrA;
  wire [NUMWRPT*BITMAPT-1:0] t3_dinA;

  wire [(NUMRDPT+NUMWRPT)-1:0] t3_readB;
  wire [(NUMRDPT+NUMWRPT)*BITVROW-1:0] t3_addrB;
  reg [(NUMRDPT+NUMWRPT)*BITMAPT-1:0] t3_doutB_tmp;
  reg [(NUMRDPT+NUMWRPT)*BITMAPT-1:0] t3_doutB;
  
reg rst_0_wrc, rst_1_wrc;
always @(posedge wclk) begin
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

  algo_mrnw_1rw_mt_top 
		#(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .NUMRDPT (NUMRDPT), .NUMWRPT (NUMWRPT),
                  .NUMADDR(NUMADDR), .BITADDR(BITADDR),
		  .NUMVROW(NUMVROW),   .BITVROW(BITVROW),   .NUMVBNK(NUMVBNK),   .BITVBNK(BITVBNK),     .NUMPBNK(NUMPBNK),
		  .BITPBNK(BITPBNK),   .NUMWRDS(NUMWRDS),        .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW),
		  .PHYWDTH(PHYWDTH),   .SRAM_DELAY(SRAM_DELAY),    .DRAM_DELAY(DRAM_DELAY), .FLOPIN(FLOPIN), .FLOPMEM(FLOPMEM), .FLOPOUT(FLOPOUT))	
  algo_top
		(.clk(clk), .rst(rst), .ready(ready),
                 .write(rdptr^wrptr_async_1), .wr_adr(wr_adr_reg_wrc[rdptr]), .din(din_reg_wrc[rdptr]),
                 .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
                 .t1_readA({t2_readA,t1_readA}), .t1_writeA({t2_writeA,t1_writeA}), .t1_addrA({t2_addrA,t1_addrA}),
                 .t1_bwA({t2_bwA,t1_bwA}), .t1_dinA({t2_dinA,t1_dinA}), .t1_doutA({t2_doutA,t1_doutA}),
                 .t2_writeA(t3_writeA), .t2_addrA(t3_addrA), .t2_dinA(t3_dinA), .t2_readB(t3_readB), .t2_addrB(t3_addrB), .t2_doutB(t3_doutB));

  reg t3_writeA_wire [0:NUMWRPT-1];
  reg [BITVROW-1:0] t3_addrA_wire [0:NUMWRPT*BITVROW-1];
  reg [BITMAPT-1:0] t3_dinA_wire [0:NUMWRPT*BITMAPT-1];
  reg t3_readB_wire [0:(NUMRDPT+NUMWRPT)-1];
  reg [BITVROW-1:0] t3_addrB_wire [0:(NUMRDPT+NUMWRPT)*BITVROW-1];
  integer t3_int;
  always_comb begin
    for (t3_int=0; t3_int<NUMWRPT; t3_int=t3_int+1) begin
      t3_writeA_wire[t3_int] = t3_writeA >> t3_int;
      t3_addrA_wire[t3_int] = t3_addrA >> (t3_int*BITVROW);
      t3_dinA_wire[t3_int] = t3_dinA >> (t3_int*BITMAPT);
    end
    for (t3_int=0; t3_int<NUMRDPT+NUMWRPT; t3_int=t3_int+1) begin
      t3_readB_wire[t3_int] = t3_readB >> t3_int;
      t3_addrB_wire[t3_int] = t3_addrB >> (t3_int*BITVROW);
    end
  end
/*
  reg t3_writeA_reg [0:NUMWRPT-1];
  reg [BITVROW-1:0] t3_addrA_reg [0:NUMWRPT-1];
  reg [BITMAPT-1:0] t3_dinA_reg [0:NUMWRPT-1];
  reg t3_readB_reg [0:(NUMRDPT+NUMWRPT)-1];
  reg [BITVROW-1:0] t3_addrB_reg [0:(NUMRDPT+NUMWRPT)-1];
  integer t3d_int;
  always @(posedge clk) begin
    for (t3d_int=0; t3d_int<NUMWRPT; t3d_int=t3d_int+1) begin
      t3_writeA_reg[t3d_int] <= t3_writeA_wire[t3d_int];
      t3_addrA_reg[t3d_int] <= t3_addrA_wire[t3d_int];
      t3_dinA_reg[t3d_int] <= t3_dinA_wire[t3d_int];
    end
    for (t3d_int=0; t3d_int<NUMRDPT+NUMWRPT; t3d_int=t3d_int+1) begin
      t3_readB_reg[t3d_int] <= t3_readB_wire[t3d_int];
      t3_addrB_reg[t3d_int] <= t3_addrB_wire[t3d_int];
    end
  end
*/
  reg [BITMAPT-1:0] t3_mem [0:NUMVROW-1];
  integer t3w_int;
  always @(posedge clk)
    for (t3w_int=0; t3w_int<NUMWRPT; t3w_int=t3w_int+1)
      if (t3_writeA_wire[t3w_int])
        t3_mem[t3_addrA_wire[t3w_int]] <= t3_dinA_wire[t3w_int];

  integer t3r_int;
  always_comb begin
    t3_doutB_tmp = 0;
    for (t3r_int=0; t3r_int<NUMRDPT+NUMWRPT; t3r_int=t3r_int+1)
      t3_doutB_tmp = t3_doutB_tmp | (t3_mem[t3_addrB_wire[t3r_int]] << (t3r_int*BITMAPT));
  end

  always_comb
    t3_doutB = t3_doutB_tmp;
  
endmodule    //algo_1r1w_a460_top_wrap
