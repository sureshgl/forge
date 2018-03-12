/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

module algo_3ror1w_a293_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

//Special Params.
parameter IP_NUMVROW1 = 8192,	//Num rows for Higher level algo ... = T3_NUMBNKS*T1_NUMVROW
parameter IP_BITVROW1 = 13, 	// lg of above
parameter IP_BITPBNK2 = 3,		// lg of (T3_NUMBNKS+1)

parameter T1_WIDTH = 49, parameter T1_NUMVBNK = 4, parameter T1_BITVBNK = 2, parameter T1_DELAY = 2, parameter T1_NUMVROW = 4096, parameter T1_BITVROW = 12,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 2, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 2048, parameter T1_BITSROW = 11, parameter T1_PHYWDTH = 98,
parameter T1_NUMRBNK = 1, parameter T1_BITRBNK = 1, parameter T1_NUMRROW = 256, parameter T1_BITRROW = 8, parameter T1_NUMPROW = 2048, parameter T1_BITPROW = 11,
parameter T1_BITDWSN = 8, 
parameter T1_NUMDWS0 = 0, parameter T1_NUMDWS1 = 0, parameter T1_NUMDWS2 = 0, parameter T1_NUMDWS3 = 0,
parameter T1_NUMDWS4 = 0, parameter T1_NUMDWS5 = 0, parameter T1_NUMDWS6 = 0, parameter T1_NUMDWS7 = 0,
parameter T1_NUMDWS8 = 0, parameter T1_NUMDWS9 = 0, parameter T1_NUMDWS10 = 0, parameter T1_NUMDWS11 = 0,
parameter T1_NUMDWS12 = 0, parameter T1_NUMDWS13 = 0, parameter T1_NUMDWS14 = 0, parameter T1_NUMDWS15 = 0,

parameter T2_WIDTH = 49, parameter T2_NUMVBNK = 2, parameter T2_BITVBNK = 1, parameter T2_DELAY = 2, parameter T2_NUMVROW = 4096, parameter T2_BITVROW = 12,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 2, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 2048, parameter T2_BITSROW = 11, parameter T2_PHYWDTH = 98,
parameter T2_NUMRBNK = 1, parameter T2_BITRBNK = 1, parameter T2_NUMRROW = 256, parameter T2_BITRROW = 8, parameter T2_NUMPROW = 2048, parameter T2_BITPROW = 11,
//Not declaring DWSN for T2

parameter T3_WIDTH = 49, parameter T3_NUMVBNK = 2, parameter T3_BITVBNK = 1, parameter T3_DELAY = 2, parameter T3_NUMVROW = 4096, parameter T3_BITVROW = 12,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 2, parameter T3_BITWRDS = 1, parameter T3_NUMSROW = 2048, parameter T3_BITSROW = 11, parameter T3_PHYWDTH = 98,
parameter T3_NUMRBNK = 1, parameter T3_BITRBNK = 1, parameter T3_NUMRROW = 256, parameter T3_BITRROW = 8, parameter T3_NUMPROW = 2048, parameter T3_BITPROW = 11
//Not declaring DWSN for T3
)
( clk,  rst,  ready,  refr,
  write,   wr_adr,   din,
  read,   rd_adr,   rd_dout,   rd_vld,   rd_serr,   rd_derr,   rd_padr,
  t1_readA,   t1_writeA,   t1_addrA,   t1_dinA,   t1_bwA,   t1_doutA,   t1_dwsnA,
  t1_refrB,   t1_bankB,
  t2_readA,   t2_writeA,   t2_addrA,   t2_dinA,   t2_bwA,   t2_doutA,   t2_dwsnA,
  t2_refrB,   t2_bankB,
  t3_readA,   t3_writeA,   t3_addrA,   t3_dinA,   t3_bwA,   t3_doutA,   t3_dwsnA,
  t3_refrB,   t3_bankB);
  
  // MEMOIR_TRANSLATE_OFF
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ECCWDTH = IP_DECCBITS;
  parameter ENAPAR = 0;
  parameter ENAECC = 1;
  parameter MEMWDTH = WIDTH+ECCWDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW1 = IP_NUMVROW1;   // ALGO1 Parameters
  parameter BITVROW1 = IP_BITVROW1;
  parameter NUMVBNK1 = T2_NUMVBNK;
  parameter BITVBNK1 = T2_BITVBNK;
  parameter BITPBNK1 = IP_BITPBNK;
  parameter FLOPIN1 = FLOPIN;
  parameter FLOPOUT1 = FLOPOUT;
  parameter NUMWRDS1 = T3_NUMWRDS; 
  parameter BITWRDS1 = T3_BITWRDS;
  parameter NUMSROW1 = T3_NUMSROW;
  parameter BITSROW1 = T3_BITSROW;
  parameter PHYWDTH1 = NUMWRDS1*MEMWDTH;
  parameter NUMRBNK1 = T3_NUMRBNK;
  parameter BITWSPF1 = T3_BITWSPF;
  parameter BITRBNK1 = T3_BITRBNK;
  parameter NUMVROW2 = T1_NUMVROW;    // ALGO2 Parameters
  parameter BITVROW2 = T1_BITVROW;
  parameter NUMVBNK2 = T3_NUMVBNK;
  parameter BITVBNK2 = T3_BITVBNK;
  parameter BITPBNK2 = IP_BITPBNK2;
  parameter FLOPIN2 = 0;
  parameter FLOPOUT2 = 0;
  parameter NUMWRDS2 = T1_NUMWRDS; 
  parameter BITWRDS2 = T1_BITWRDS;
  parameter NUMSROW2 = T1_NUMSROW;
  parameter BITSROW2 = T1_BITSROW;
  parameter PHYWDTH2 = NUMWRDS2*MEMWDTH;
  parameter NUMRBNK2 = T1_NUMRBNK;
  parameter BITWSPF2 = T1_BITWSPF;
  parameter BITRBNK2 = T1_BITRBNK;
  parameter REFRESH = IP_REFRESH;      // REFRESH Parameters 
  parameter REFLOPW = 0;
  parameter NUMRROW = T1_NUMRROW;
  parameter BITRROW = T1_BITRROW;
  parameter REFFREQ = IP_REFFREQ;
  parameter REFFRHF = IP_REFFRHF;
  parameter SRAM_DELAY = T1_DELAY;
  
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

  parameter BITPADR2 = BITPBNK2+BITSROW2+BITWRDS2;
  parameter BITPADR1 = BITPBNK1+BITPADR2+1;

  input                                refr;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input [3-1:0]                        read;
  input [3*BITADDR-1:0]                rd_adr;
  output [3-1:0]                       rd_vld;
  output [3*WIDTH-1:0]                 rd_dout;
  output [3-1:0]                       rd_serr;
  output [3-1:0]                       rd_derr;
  output [3*BITPADR1-1:0]              rd_padr;

  output                               ready;
  input                                clk, rst;

  output [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
  output [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrA;
  output [NUMVBNK1*NUMVBNK2*BITDWSN-1:0] t1_dwsnA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_doutA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_refrB;
  output [NUMVBNK1*NUMVBNK2*BITRBNK2-1:0] t1_bankB;

  output [NUMVBNK1-1:0] t2_readA;
  output [NUMVBNK1-1:0] t2_writeA;
  output [NUMVBNK1*BITSROW2-1:0] t2_addrA;
  output [NUMVBNK1*BITDWSN-1:0] t2_dwsnA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_bwA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_dinA;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_doutA;
  output [NUMVBNK1-1:0] t2_refrB;
  output [NUMVBNK1*BITRBNK2-1:0] t2_bankB;

  output [NUMVBNK2-1:0] t3_readA;
  output [NUMVBNK2-1:0] t3_writeA;
  output [NUMVBNK2*BITSROW2-1:0] t3_addrA;
  output [NUMVBNK2*BITDWSN-1:0] t3_dwsnA;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_bwA;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_dinA;
  input [NUMVBNK2*PHYWDTH2-1:0] t3_doutA;
  output [NUMVBNK2-1:0] t3_refrB;
  output [NUMVBNK2*BITRBNK2-1:0] t3_bankB;
/*  
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
*/
  algo_3ror1w_top
		#(.WIDTH(WIDTH),   .BITWDTH(BITWDTH),   .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ECCWDTH(ECCWDTH),   .NUMADDR(NUMADDR),   .BITADDR(BITADDR),
		.NUMVROW1(NUMVROW1),   .BITVROW1(BITVROW1),   .NUMVBNK1(NUMVBNK1),   .BITVBNK1(BITVBNK1),   .BITPBNK1(BITPBNK1),
		.FLOPIN1(FLOPIN1),   .FLOPOUT1(FLOPOUT1),
		.NUMWRDS1(NUMWRDS1),   .BITWRDS1(BITWRDS1),   .NUMSROW1(NUMSROW1),   .BITSROW1(BITSROW1),   .NUMRBNK1(NUMRBNK1),   .BITWSPF1(BITWSPF1),  .BITRBNK1(BITRBNK1),
		.NUMVROW2(NUMVROW2),   .BITVROW2(BITVROW2),   .NUMVBNK2(NUMVBNK2),   .BITVBNK2(BITVBNK2),   .BITPBNK2(BITPBNK2),
		.FLOPIN2(FLOPIN2),   .FLOPOUT2(FLOPOUT2),
		.NUMWRDS2(NUMWRDS2),   .BITWRDS2(BITWRDS2),   .NUMSROW2(NUMSROW2),   .BITSROW2(BITSROW2),   .NUMRBNK2(NUMRBNK2),   .BITWSPF2(BITWSPF2),  .BITRBNK2(BITRBNK2),
		.REFRESH(REFRESH),   .REFLOPW(REFLOPW),   .NUMRROW(NUMRROW),   .BITRROW(BITRROW),   .REFFREQ(REFFREQ),   .REFFRHF(REFFRHF),
		.SRAM_DELAY(SRAM_DELAY),   .FLOPECC(FLOPECC), .FLOPMEM(FLOPMEM),
		.BITDWSN(BITDWSN),   .NUMDWS0(NUMDWS0),   .NUMDWS1(NUMDWS1),   .NUMDWS2(NUMDWS2),   .NUMDWS3(NUMDWS3),   .NUMDWS4(NUMDWS4),
		.NUMDWS5(NUMDWS5),   .NUMDWS6(NUMDWS6),   .NUMDWS7(NUMDWS7),   .NUMDWS8(NUMDWS8),   .NUMDWS9(NUMDWS9),   .NUMDWS10(NUMDWS10),
		.NUMDWS11(NUMDWS11),   .NUMDWS12(NUMDWS12),   .NUMDWS13(NUMDWS13),   .NUMDWS14(NUMDWS14),   .NUMDWS15(NUMDWS15))
  algo_top
		(.refr(refr), .clk(clk), .rst(rst), .ready(ready),
		.write(write), .wr_adr(wr_adr), .din(din),
		.read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
		.t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dwsnA(t1_dwsnA), .t1_bwA(t1_bwA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA), 
		.t1_refrB(t1_refrB), .t1_bankB(t1_bankB),
		.t2_readA(t2_readA), .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dwsnA(t2_dwsnA), .t2_bwA(t2_bwA), .t2_dinA(t2_dinA), .t2_doutA(t2_doutA),
		.t2_refrB(t2_refrB), .t2_bankB(t2_bankB),
		.t3_readA(t3_readA), .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dwsnA(t3_dwsnA), .t3_bwA(t3_bwA), .t3_dinA(t3_dinA), .t3_doutA(t3_doutA), 
		.t3_refrB(t3_refrB), .t3_bankB(t3_bankB));

/*
`endif
*/

// MEMOIR_TRANSLATE_ON

endmodule    //algo_3ror1w_a93_top_wrap
