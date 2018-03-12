/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

module algo_3r1w_a92_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 48, parameter T1_NUMVBNK = 2, parameter T1_BITVBNK = 1, parameter T1_DELAY = 2, parameter T1_NUMVROW = 8192, parameter T1_BITVROW = 13,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 8192, parameter T1_BITSROW = 13, parameter T1_PHYWDTH = 48,

parameter T1_IP_WIDTH = 48, parameter T1_IP_BITWIDTH = 6, parameter T1_IP_NUMADDR = 8192, parameter T1_IP_BITADDR = 13, parameter T1_IP_NUMVBNK = 2, parameter T1_IP_BITVBNK = 1,
parameter T1_IP_SECCBITS = 4, parameter T1_IP_SECCDWIDTH = 2, parameter T1_FLOPIN = 0, parameter T1_FLOPOUT = 0, parameter T1_FLOPMEM = 0, 
parameter T1_IP_REFRESH = 1, parameter T1_IP_REFFREQ = 15, parameter T1_IP_REFFRHF = 1, parameter T1_IP_BITPBNK = 3, parameter T1_IP_NUMVROW1 = 4096, parameter T1_IP_BITVROW1 = 12, parameter T1_IP_BITPBNK2 = 1,

parameter T1_T1_WIDTH = 49, parameter T1_T1_NUMVBNK = 4, parameter T1_T1_BITVBNK = 2, parameter T1_T1_DELAY = 2, parameter T1_T1_NUMVROW = 2048, parameter T1_T1_BITVROW = 11,
parameter T1_T1_BITWSPF = 0, parameter T1_T1_NUMWRDS = 1, parameter T1_T1_BITWRDS = 1, parameter T1_T1_NUMSROW = 2048, parameter T1_T1_BITSROW = 11, parameter T1_T1_PHYWDTH = 49,
parameter T1_T1_NUMRBNK = 1, parameter T1_T1_BITRBNK = 1, parameter T1_T1_NUMRROW = 256, parameter T1_T1_BITRROW = 8, parameter T1_T1_NUMPROW = 2048, parameter T1_T1_BITPROW = 11,
parameter T1_T1_BITDWSN = 8, 
parameter T1_T1_NUMDWS0 = 0, parameter T1_T1_NUMDWS1 = 0, parameter T1_T1_NUMDWS2 = 0, parameter T1_T1_NUMDWS3 = 0,
parameter T1_T1_NUMDWS4 = 0, parameter T1_T1_NUMDWS5 = 0, parameter T1_T1_NUMDWS6 = 0, parameter T1_T1_NUMDWS7 = 0,
parameter T1_T1_NUMDWS8 = 0, parameter T1_T1_NUMDWS9 = 0, parameter T1_T1_NUMDWS10 = 0, parameter T1_T1_NUMDWS11 = 0,
parameter T1_T1_NUMDWS12 = 0, parameter T1_T1_NUMDWS13 = 0, parameter T1_T1_NUMDWS14 = 0, parameter T1_T1_NUMDWS15 = 0,

parameter T1_T2_WIDTH = 49, parameter T1_T2_NUMVBNK = 2, parameter T1_T2_BITVBNK = 1, parameter T1_T2_DELAY = 2, parameter T1_T2_NUMVROW = 2048, parameter T1_T2_BITVROW = 11,
parameter T1_T2_BITWSPF = 0, parameter T1_T2_NUMWRDS = 1, parameter T1_T2_BITWRDS = 1, parameter T1_T2_NUMSROW = 2048, parameter T1_T2_BITSROW = 11, parameter T1_T2_PHYWDTH = 49,
parameter T1_T2_NUMRBNK = 1, parameter T1_T2_BITRBNK = 1, parameter T1_T2_NUMRROW = 256, parameter T1_T2_BITRROW = 8, parameter T1_T2_NUMPROW = 2048, parameter T1_T2_BITPROW = 11,
//Not declaring DWSN for T1_T2

parameter T1_T3_WIDTH = 49, parameter T1_T3_NUMVBNK = 2, parameter T1_T3_BITVBNK = 1, parameter T1_T3_DELAY = 2, parameter T1_T3_NUMVROW = 2048, parameter T1_T3_BITVROW = 11,
parameter T1_T3_BITWSPF = 0, parameter T1_T3_NUMWRDS = 1, parameter T1_T3_BITWRDS = 1, parameter T1_T3_NUMSROW = 2048, parameter T1_T3_BITSROW = 11, parameter T1_T3_PHYWDTH = 49,
parameter T1_T3_NUMRBNK = 1, parameter T1_T3_BITRBNK = 1, parameter T1_T3_NUMRROW = 256, parameter T1_T3_BITRROW = 8, parameter T1_T3_NUMPROW = 2048, parameter T1_T3_BITPROW = 11,
//Not declaring DWSN for T1_T3

parameter T2_WIDTH = 48, parameter T2_NUMVBNK = 3, parameter T2_BITVBNK = 2, parameter T2_DELAY = 2, parameter T2_NUMVROW = 8192, parameter T2_BITVROW = 13,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 8192, parameter T2_BITSROW = 13, parameter T2_PHYWDTH = 48,

parameter T2_IP_WIDTH = 48, parameter T2_IP_BITWIDTH = 6, parameter T2_IP_NUMADDR = 8192, parameter T2_IP_BITADDR = 13, parameter T2_IP_NUMVBNK = 2, parameter T2_IP_BITVBNK = 1,
parameter T2_IP_SECCBITS = 4, parameter T2_IP_SECCDWIDTH = 2, parameter T2_FLOPIN = 0, parameter T2_FLOPOUT = 0, parameter T2_FLOPMEM = 0,
parameter T2_IP_REFRESH = 1, parameter T2_IP_REFFREQ = 15, parameter T2_IP_REFFRHF = 1, parameter T2_IP_BITPBNK = 3, parameter T2_IP_NUMVROW1 = 4096, parameter T2_IP_BITVROW1 = 12, parameter T2_IP_BITPBNK2 = 1,

parameter T2_T1_WIDTH = 49, parameter T2_T1_NUMVBNK = 4, parameter T2_T1_BITVBNK = 2, parameter T2_T1_DELAY = 2, parameter T2_T1_NUMVROW = 2048, parameter T2_T1_BITVROW = 11,
parameter T2_T1_BITWSPF = 0, parameter T2_T1_NUMWRDS = 1, parameter T2_T1_BITWRDS = 1, parameter T2_T1_NUMSROW = 2048, parameter T2_T1_BITSROW = 11, parameter T2_T1_PHYWDTH = 49,
parameter T2_T1_NUMRBNK = 1, parameter T2_T1_BITRBNK = 1, parameter T2_T1_NUMRROW = 256, parameter T2_T1_BITRROW = 8, parameter T2_T1_NUMPROW = 2048, parameter T2_T1_BITPROW = 11,
//Not declaring DWSN for T2_T1

parameter T2_T2_WIDTH = 49, parameter T2_T2_NUMVBNK = 2, parameter T2_T2_BITVBNK = 1, parameter T2_T2_DELAY = 2, parameter T2_T2_NUMVROW = 2048, parameter T2_T2_BITVROW = 11,
parameter T2_T2_BITWSPF = 0, parameter T2_T2_NUMWRDS = 1, parameter T2_T2_BITWRDS = 1, parameter T2_T2_NUMSROW = 2048, parameter T2_T2_BITSROW = 11, parameter T2_T2_PHYWDTH = 49,
parameter T2_T2_NUMRBNK = 1, parameter T2_T2_BITRBNK = 1, parameter T2_T2_NUMRROW = 256, parameter T2_T2_BITRROW = 8, parameter T2_T2_NUMPROW = 2048, parameter T2_T2_BITPROW = 11,
//Not declaring DWSN for T2_T2

parameter T2_T3_WIDTH = 49, parameter T2_T3_NUMVBNK = 2, parameter T2_T3_BITVBNK = 1, parameter T2_T3_DELAY = 2, parameter T2_T3_NUMVROW = 2048, parameter T2_T3_BITVROW = 11,
parameter T2_T3_BITWSPF = 0, parameter T2_T3_NUMWRDS = 1, parameter T2_T3_BITWRDS = 1, parameter T2_T3_NUMSROW = 2048, parameter T2_T3_BITSROW = 11, parameter T2_T3_PHYWDTH = 49,
parameter T2_T3_NUMRBNK = 1, parameter T2_T3_BITRBNK = 1, parameter T2_T3_NUMRROW = 256, parameter T2_T3_BITRROW = 8, parameter T2_T3_NUMPROW = 2048, parameter T2_T3_BITPROW = 11,
//Not declaring DWSN for T2_T3

parameter T3_WIDTH = 36, parameter T3_NUMVBNK = 4, parameter T3_BITVBNK = 2, parameter T3_DELAY = 1, parameter T3_NUMVROW = 8192, parameter T3_BITVROW = 13,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 1, parameter T3_NUMSROW = 8192, parameter T3_BITSROW = 13, parameter T3_PHYWDTH = 36)

( clk,  rst,  ready,  refr,
 write,   wr_adr,   din,
  read,   rd_adr,   rd_dout,   rd_vld,   rd_serr,   rd_derr,   rd_padr,
  t1_readA,   t1_writeA,   t1_addrA,   t1_dinA,   t1_bwA,   t1_doutA,   t1_dwsnA,
  t1_refrB,   t1_bankB,
  t2_readA,   t2_writeA,   t2_addrA,   t2_dinA,   t2_bwA,   t2_doutA,   t2_dwsnA,
  t2_refrB,   t2_bankB,
  t3_readA,   t3_writeA,   t3_addrA,   t3_dinA,   t3_bwA,   t3_doutA,   t3_dwsnA,
  t3_refrB,   t3_bankB,
  t4_readA,   t4_writeA,   t4_addrA,   t4_dinA,   t4_bwA,   t4_doutA,   t4_dwsnA,
  t4_refrB,   t4_bankB,
  t5_readA,   t5_writeA,   t5_addrA,   t5_dinA,   t5_bwA,   t5_doutA,   t5_dwsnA,
  t5_refrB,   t5_bankB,
  t6_readA,   t6_writeA,   t6_addrA,   t6_dinA,   t6_bwA,   t6_doutA,   t6_dwsnA,
  t6_refrB,   t6_bankB,
  t7_writeA,   t7_addrA,   t7_dinA,   t7_bwA,
  t7_readB,   t7_addrB,   t7_doutB);
  
  // MEMOIR_TRANSLATE_OFF
  
  parameter NUMRDPT = 3;
  parameter NUMRWPT = 0;
  parameter NUMWRPT = 1;
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter PARITY = 1;
  parameter MEMWDTH = WIDTH+PARITY;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW1 = T1_NUMVROW;  // ALGO1 Parameters
  parameter BITVROW1 = T1_BITVROW;
  parameter NUMVBNK1 = IP_NUMVBNK;
  parameter BITVBNK1 = IP_BITVBNK;
  parameter NUMPBNK1 = IP_NUMVBNK+3;
  parameter BITPBNK1 = IP_BITPBNK;
  parameter FLOPIN1 = FLOPIN;
  parameter FLOPOUT1 = FLOPOUT;
  parameter NUMVROW2 = T1_IP_NUMVROW1;   // ALGO2 Parameters
  parameter BITVROW2 = T1_IP_BITVROW1;
  parameter NUMVBNK2 = T1_T2_NUMVBNK;
  parameter BITVBNK2 = T1_T2_BITVBNK;
  parameter BITPBNK2 = T1_IP_BITPBNK;
  parameter FLOPIN2 = 0;
  parameter FLOPOUT2 = 0;
  parameter NUMWRDS2 = T1_T3_NUMWRDS;     // ALIGN Parameters
  parameter BITWRDS2 = T1_T3_BITWRDS;
  parameter NUMSROW2 = T1_T3_NUMSROW;
  parameter BITSROW2 = T1_T3_BITSROW;
  parameter PHYWDTH2 = T1_T3_PHYWDTH;
  parameter NUMRBNK2 = T1_T3_NUMRBNK;
  parameter BITWSPF2 = T1_T3_BITWSPF;
  parameter BITRBNK2 = T1_T3_BITRBNK;
  parameter NUMVROW3 = T1_T1_NUMVROW;   // ALGO2 Parameters
  parameter BITVROW3 = T1_T1_BITVROW;
  parameter NUMVBNK3 = T1_T3_NUMVBNK;
  parameter BITVBNK3 = T1_T3_BITVBNK;
  parameter BITPBNK3 = T1_IP_BITPBNK2;
  parameter FLOPIN3 = 0;
  parameter FLOPOUT3 = 0;

  parameter NUMWRDS3 = T1_T1_NUMWRDS;     // ALIGN Parameters
  parameter BITWRDS3 = T1_T1_BITWRDS;
  parameter NUMSROW3 = T1_T1_NUMSROW;
  parameter BITSROW3 = T1_T1_BITSROW;
  parameter PHYWDTH3 = T1_T1_PHYWDTH;
  parameter NUMRBNK3 = T1_T1_NUMRBNK;
  parameter BITWSPF3 = T1_T1_BITWSPF;
  parameter BITRBNK3 = T1_T1_BITRBNK;
  parameter REFRESH = IP_REFRESH;      // REFRESH Parameters 
  parameter REFLOPW = 0;
  parameter NUMRROW = T1_T1_NUMRROW;
  parameter BITRROW = T1_T1_BITRROW;
  parameter REFFREQ = IP_REFFREQ;
  parameter REFFRHF = IP_REFFRHF;
  
  parameter BITDWSN = T1_T1_BITDWSN;		//DWSN Parameters
  parameter NUMDWS0 = T1_T1_NUMDWS0;
  parameter NUMDWS1 = T1_T1_NUMDWS1;
  parameter NUMDWS2 = T1_T1_NUMDWS2;
  parameter NUMDWS3 = T1_T1_NUMDWS3;
  parameter NUMDWS4 = T1_T1_NUMDWS4;
  parameter NUMDWS5 = T1_T1_NUMDWS5;
  parameter NUMDWS6 = T1_T1_NUMDWS6;
  parameter NUMDWS7 = T1_T1_NUMDWS7;
  parameter NUMDWS8 = T1_T1_NUMDWS8;
  parameter NUMDWS9 = T1_T1_NUMDWS9;
  parameter NUMDWS10 = T1_T1_NUMDWS10;
  parameter NUMDWS11 = T1_T1_NUMDWS11;
  parameter NUMDWS12 = T1_T1_NUMDWS12;
  parameter NUMDWS13 = T1_T1_NUMDWS13;
  parameter NUMDWS14 = T1_T1_NUMDWS14;
  parameter NUMDWS15 = T1_T1_NUMDWS15;
  
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T3_DELAY;
  parameter DRAM_DELAY = T1_T1_DELAY;

  parameter BITPADR4 = BITVBNK3+BITSROW3+BITWRDS3+1;
  parameter BITPADR3 = BITPBNK3+BITSROW3+BITWRDS3+1;
  parameter BITPADR2 = BITPBNK2+BITPADR3+1;
  parameter BITPADR1 = BITPBNK1+BITPADR2+1;

  parameter BITMAPT = BITPBNK1*NUMPBNK1;
  parameter SDOUT_WIDTH = 2*BITMAPT+ECCBITS;
  
  parameter T1_INST = T1_NUMVBNK*T1_T1_NUMVBNK;
  parameter T2_INST = T1_NUMVBNK*T1_T2_NUMVBNK;
  parameter T3_INST = T1_NUMVBNK*T1_T3_NUMVBNK;
  parameter T4_INST = T2_NUMVBNK*T2_T1_NUMVBNK;
  parameter T5_INST = T2_NUMVBNK*T2_T2_NUMVBNK;
  parameter T6_INST = T2_NUMVBNK*T2_T3_NUMVBNK;
  parameter T7_INST = T3_NUMVBNK;
  
input clk; input rst; input refr;
output ready; 

input  [NUMWRPT - 1:0]				write; 
input  [NUMWRPT* BITADDR - 1:0] 	wr_adr; 
input  [NUMWRPT* WIDTH - 1:0]		din;

input  [NUMRDPT - 1:0] 				read; 
input  [NUMRDPT* BITADDR - 1:0] 	rd_adr; 
output [NUMRDPT* WIDTH - 1:0] 		rd_dout; 
output [NUMRDPT - 1:0] 				rd_vld; 
output [NUMRDPT - 1:0] 				rd_serr; 
output [NUMRDPT - 1:0] 				rd_derr; 
output [NUMRDPT* BITPADR1 - 1:0] 	rd_padr;

output [T1_INST - 1:0] 			t1_readA; 
output [T1_INST- 1:0] 			t1_writeA; 
output [T1_INST*BITSROW3 - 1:0] t1_addrA; 
output [T1_INST*PHYWDTH3 - 1:0] 	t1_dinA;
output [T1_INST*PHYWDTH3 - 1:0] 	t1_bwA; 
input  [T1_INST*PHYWDTH3 - 1:0] 	t1_doutA;
output [T1_INST*BITDWSN - 1:0] t1_dwsnA;

output [T1_INST - 1:0] 			t1_refrB; 
output [T1_INST*BITRBNK3 - 1:0] 	t1_bankB;

output [T2_INST - 1:0] t2_readA; 
output [T2_INST - 1:0] t2_writeA; 
output [T2_INST*BITSROW3 - 1:0] t2_addrA; 
output [T2_INST*PHYWDTH3 - 1:0] t2_dinA; 
output [T2_INST*PHYWDTH3 - 1:0] t2_bwA; 
input  [T2_INST*PHYWDTH3 - 1:0] t2_doutA;
output [T2_INST*BITDWSN - 1:0] t2_dwsnA;

output [T2_INST - 1:0] t2_refrB; 
output [T2_INST*BITRBNK3 - 1:0] t2_bankB; 

output [T3_INST - 1:0] t3_readA; 
output [T3_INST - 1:0] t3_writeA; 
output [T3_INST*BITSROW2 - 1:0] t3_addrA; 
output [T3_INST*PHYWDTH2 - 1:0] t3_dinA; 
output [T3_INST*PHYWDTH2 - 1:0] t3_bwA; 
input  [T3_INST*PHYWDTH2 - 1:0] t3_doutA;
output [T3_INST*BITDWSN - 1:0] t3_dwsnA;

output [T3_INST - 1:0] t3_refrB; 
output [T3_INST*BITRBNK2 - 1:0] t3_bankB; 

output [T4_INST - 1:0] t4_readA; 
output [T4_INST - 1:0] t4_writeA; 
output [T4_INST*BITSROW3 - 1:0] t4_addrA; 
output [T4_INST*PHYWDTH3 - 1:0] t4_dinA; 
output [T4_INST*PHYWDTH3 - 1:0] t4_bwA; 
input  [T4_INST*PHYWDTH3 - 1:0] t4_doutA;
output [T4_INST*BITDWSN - 1:0] t4_dwsnA;

output [T4_INST - 1:0] t4_refrB; 
output [T4_INST*BITRBNK3 - 1:0] t4_bankB; 

output [T5_INST - 1:0] t5_readA; 
output [T5_INST - 1:0] t5_writeA; 
output [T5_INST*BITSROW3 - 1:0] t5_addrA; 
output [T5_INST*PHYWDTH3 - 1:0] t5_dinA; 
output [T5_INST*PHYWDTH3 - 1:0] t5_bwA; 
input  [T5_INST*PHYWDTH3 - 1:0] t5_doutA;
output [T5_INST*BITDWSN - 1:0] t5_dwsnA;

output [T5_INST - 1:0] t5_refrB; 
output [T5_INST*BITRBNK3 - 1:0] t5_bankB; 

output [T6_INST - 1:0] t6_readA; 
output [T6_INST - 1:0] t6_writeA; 
output [T6_INST*BITSROW2 - 1:0] t6_addrA; 
output [T6_INST*PHYWDTH2 - 1:0] t6_dinA; 
output [T6_INST*PHYWDTH2 - 1:0] t6_bwA; 
input  [T6_INST*PHYWDTH2 - 1:0] t6_doutA;
output [T6_INST*BITDWSN - 1:0] t6_dwsnA;

output [T6_INST - 1:0] t6_refrB; 
output [T6_INST*BITRBNK2 - 1:0] t6_bankB; 

output [T7_INST - 1:0] t7_writeA; 
output [T7_INST*BITVROW1 - 1:0] t7_addrA; 
output [T7_INST*SDOUT_WIDTH - 1:0] t7_dinA; 
output [T7_INST*SDOUT_WIDTH - 1:0] t7_bwA;

output [T7_INST - 1:0] t7_readB; 
output [T7_INST*BITVROW1 - 1:0] t7_addrB; 
input  [T7_INST*SDOUT_WIDTH - 1:0] t7_doutB;

wire [(NUMRWPT+NUMWRPT)-1:0] t7_writeA_tmp;
wire [(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t7_addrA_tmp;
wire [(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t7_dinA_tmp;

wire [NUMWRPT*WIDTH-1 :0] 		rd_dout_nocon;
wire [NUMWRPT-1 :0] 			rd_vld_nocon;
wire [NUMWRPT-1 :0] 			rd_serr_nocon;
wire [NUMWRPT-1 :0] 			rd_derr_nocon;
wire [NUMWRPT*BITPADR1-1 :0] 	rd_padr_nocon;

assign t7_bwA = ~0;

`ifdef AMP_REF

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

  algo_mrnrwpw_ref #(
    .WIDTH(WIDTH), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMRDPT(3), .NUMRWPT(0), .NUMWRPT(1),
    .NUMVROW(NUMVROW1), .BITVROW(BITVROW1), .NUMVBNK(NUMVBNK1), .BITVBNK(BITVBNK1),
    .NUMSROW(T1_NUMSROW), .BITSROW(T1_BITSROW), .NUMWRDS(T1_NUMWRDS), .BITWRDS(T1_BITWRDS), .BITPADR(BITPADR1),
    .MEM_DELAY(T1_DELAY+FLOPOUT+FLOPIN+FLOPMEM)) algo_ref (
       .rd_read(read), .rd_addr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
       .rw_read(), .rw_write(), .rw_addr(), .rw_din(), .rw_vld(), .rw_dout(), .rw_serr(), .rw_derr(), .rw_padr(),
       .wr_write(write), .wr_addr(wr_adr), .wr_din(din),
       .clk(clk), .ready(ready), .rst(rst));

`else

  algo_3r1w_1rw_mt_top
		#(.WIDTH(WIDTH),   .BITWDTH(BITWDTH),   .PARITY(PARITY),   .NUMADDR(NUMADDR),   .BITADDR(BITADDR),
		.NUMVROW1(NUMVROW1),   .BITVROW1(BITVROW1),   .NUMVBNK1(NUMVBNK1),   .BITVBNK1(BITVBNK1),   .NUMPBNK1(NUMPBNK1),   .BITPBNK1(BITPBNK1),
		.FLOPIN1(FLOPIN1),   .FLOPOUT1(FLOPOUT1),
		.NUMVROW2(NUMVROW2),   .BITVROW2(BITVROW2),   .NUMVBNK2(NUMVBNK2),   .BITVBNK2(BITVBNK2),   .BITPBNK2(BITPBNK2),
		.FLOPIN2(FLOPIN2),   .FLOPOUT2(FLOPOUT2),
		.NUMWRDS2(NUMWRDS2),   .BITWRDS2(BITWRDS2),   .NUMSROW2(NUMSROW2),   .BITSROW2(BITSROW2),   .NUMRBNK2(NUMRBNK2),   .BITWSPF2(BITWSPF2),  .BITRBNK2(BITRBNK2),
		.NUMVROW3(NUMVROW3),   .BITVROW3(BITVROW3),   .NUMVBNK3(NUMVBNK3),   .BITVBNK3(BITVBNK3),   .BITPBNK3(BITPBNK3),   .FLOPIN3(FLOPIN3),   .FLOPOUT3(FLOPOUT3),
		.NUMWRDS3(NUMWRDS3),   .BITWRDS3(BITWRDS3),   .NUMSROW3(NUMSROW3),   .BITSROW3(BITSROW3),   .NUMRBNK3(NUMRBNK3),   .BITWSPF3(BITWSPF3),   .BITRBNK3(BITRBNK3),
		.REFRESH(REFRESH),   .REFLOPW(REFLOPW),   .NUMRROW(NUMRROW),   .BITRROW(BITRROW),   .REFFREQ(REFFREQ),   .REFFRHF(REFFRHF),
		.NUMDWS0(NUMDWS0),   .NUMDWS1(NUMDWS1),   .NUMDWS2(NUMDWS2),   .NUMDWS3(NUMDWS3),   .NUMDWS4(NUMDWS4),   .NUMDWS5(NUMDWS5),
		.NUMDWS6(NUMDWS6),   .NUMDWS7(NUMDWS7),   .NUMDWS8(NUMDWS8),   .NUMDWS9(NUMDWS9),   .NUMDWS10(NUMDWS10),   .NUMDWS11(NUMDWS11),
		.NUMDWS12(NUMDWS12),   .NUMDWS13(NUMDWS13),   .NUMDWS14(NUMDWS14),   .NUMDWS15(NUMDWS15),   .BITDWSN(BITDWSN),
		.ECCBITS(ECCBITS),   .SRAM_DELAY(SRAM_DELAY),   .DRAM_DELAY(DRAM_DELAY),   .FLOPMEM(FLOPMEM))
  algo_top
  	(.clk(clk), .rst(rst), .ready(ready), .refr(refr), 
	
        .read({{NUMWRPT{1'b0}}, read}),
        .write({write, {NUMRDPT{1'b0}}}),
        .addr({wr_adr, rd_adr}),
        .din({din, {(NUMRDPT*WIDTH){1'b0}}}),        
		.rd_dout({rd_dout_nocon, rd_dout}),
        .rd_vld ({rd_vld_nocon,  rd_vld}),
        .rd_serr({rd_serr_nocon,  rd_serr}),
        .rd_derr({rd_derr_nocon, rd_derr}),
        .rd_padr({rd_padr_nocon, rd_padr}),
		
	    .t1_readA({t4_readA,t1_readA}), .t1_writeA({t4_writeA,t1_writeA}), .t1_addrA({t4_addrA,t1_addrA}), .t1_dwsnA({t4_dwsnA,t1_dwsnA}), .t1_bwA({t4_bwA,t1_bwA}), .t1_dinA({t4_dinA,t1_dinA}), .t1_doutA({t4_doutA,t1_doutA}),
		.t1_refrB({t4_refrB,t1_refrB}), .t1_bankB({t4_bankB,t1_bankB}),
		.t2_readA({t5_readA,t2_readA}), .t2_writeA({t5_writeA,t2_writeA}), .t2_addrA({t5_addrA,t2_addrA}), .t2_dwsnA({t5_dwsnA,t2_dwsnA}), .t2_bwA({t5_bwA,t2_bwA}), .t2_dinA({t5_dinA,t2_dinA}), .t2_doutA({t5_doutA,t2_doutA}), 
		.t2_refrB({t5_refrB,t2_refrB}), .t2_bankB({t5_bankB,t2_bankB}),
		.t3_readA({t6_readA,t3_readA}), .t3_writeA({t6_writeA,t3_writeA}), .t3_addrA({t6_addrA,t3_addrA}), .t3_dwsnA({t6_dwsnA,t3_dwsnA}), .t3_bwA({t6_bwA,t3_bwA}), .t3_dinA({t6_dinA,t3_dinA}), .t3_doutA({t6_doutA,t3_doutA}), 
		.t3_refrB({t6_refrB,t3_refrB}), .t3_bankB({t6_bankB,t3_bankB}),
		 .t4_writeA(t7_writeA_tmp), .t4_addrA(t7_addrA_tmp), .t4_dinA(t7_dinA_tmp), .t4_readB(t7_readB), .t4_addrB(t7_addrB), .t4_doutB(t7_doutB)
	);
	
assign t7_writeA = {T7_INST{t7_writeA_tmp}};
assign t7_addrA = {T7_INST{t7_addrA_tmp}};
assign t7_dinA = {T7_INST{t7_dinA_tmp}};

`endif

// MEMOIR_TRANSLATE_ON

endmodule    //algo_3r1w_a92_top_wrap
