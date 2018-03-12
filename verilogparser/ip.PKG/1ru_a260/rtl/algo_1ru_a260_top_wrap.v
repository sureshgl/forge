/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_1ru_a260_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAEXT = 0, parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 6, parameter IP_SECCDWIDTH = 12, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 4, parameter T1_BITVBNK = 1, parameter T1_DELAY = 2, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11, 
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 2048, parameter T1_BITSROW = 11, parameter T1_PHYWDTH = 32,
parameter T1_NUMRBNK = 2, parameter T1_BITRBNK = 1, parameter T1_NUMRROW = 256, parameter T1_BITRROW = 8, parameter T1_NUMPROW = 2048, parameter T1_BITPROW = 11,
parameter T1_BITDWSN = 8, 
parameter T1_NUMDWS0 = 0, parameter T1_NUMDWS1 = 0, parameter T1_NUMDWS2 = 0, parameter T1_NUMDWS3 = 0,
parameter T1_NUMDWS4 = 0, parameter T1_NUMDWS5 = 0, parameter T1_NUMDWS6 = 0, parameter T1_NUMDWS7 = 0,
parameter T1_NUMDWS8 = 0, parameter T1_NUMDWS9 = 0, parameter T1_NUMDWS10 = 0, parameter T1_NUMDWS11 = 0,
parameter T1_NUMDWS12 = 0, parameter T1_NUMDWS13 = 0, parameter T1_NUMDWS14 = 0, parameter T1_NUMDWS15 = 0,

parameter T2_WIDTH = 32, parameter T2_NUMVBNK = 1, parameter T2_BITVBNK = 1, parameter T2_DELAY = 2, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11, 
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 2048, parameter T2_BITSROW = 11, parameter T2_PHYWDTH = 32,
parameter T2_NUMRBNK = 2, parameter T2_BITRBNK = 1, parameter T2_NUMRROW = 256, parameter T2_BITRROW = 8, parameter T2_NUMPROW = 2048, parameter T2_BITPROW = 11,
parameter T2_BITDWSN = 8, 
parameter T2_NUMDWS0 = 0, parameter T2_NUMDWS1 = 0, parameter T2_NUMDWS2 = 0, parameter T2_NUMDWS3 = 0,
parameter T2_NUMDWS4 = 0, parameter T2_NUMDWS5 = 0, parameter T2_NUMDWS6 = 0, parameter T2_NUMDWS7 = 0,
parameter T2_NUMDWS8 = 0, parameter T2_NUMDWS9 = 0, parameter T2_NUMDWS10 = 0, parameter T2_NUMDWS11 = 0,
parameter T2_NUMDWS12 = 0, parameter T2_NUMDWS13 = 0, parameter T2_NUMDWS14 = 0, parameter T2_NUMDWS15 = 0,

parameter T3_WIDTH = 30, parameter T3_NUMVBNK = 1, parameter T3_BITVBNK = 1, parameter T3_DELAY = 1, parameter T3_NUMVROW = 2048, parameter T3_BITVROW = 11,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 1, parameter T3_NUMSROW = 2048, parameter T3_BITSROW = 11, parameter T3_PHYWDTH = 30)
( clk, 		rst, 		ready,		refr,
ru_read, 	ru_write,	ru_addr,    	ru_din, 	ru_dout, 	ru_vld, 	ru_serr, 	ru_derr, 	ru_padr,

t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_doutA, t1_dwsnA,
t1_refrB, t1_bankB,
t2_readA, t2_writeA, t2_addrA, t2_dinA, t2_bwA, t2_doutA, t2_dwsnA, 
t2_refrB, t2_bankB,
t3_writeA, t3_addrA, t3_dinA, t3_bwA, 
t3_readB, t3_addrB, t3_doutB);

// MEMOIR_TRANSLATE_OFF

  parameter NUMRUPT = 1;
  
  parameter T1_INST = T1_NUMVBNK;
  parameter T2_INST = T2_NUMVBNK;
  parameter T3_INST = T3_NUMVBNK;
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;

  parameter ENAEXT = IP_ENAEXT;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
  
  parameter NUMVROW = T1_NUMVROW;  // ALGO1 Parameters
  parameter BITVROW = T1_BITVROW;
  parameter BITPROW = T1_BITPROW;
  parameter NUMVBNK = T1_NUMVBNK;
  parameter BITVBNK = T1_BITVBNK;
  parameter NUMPBNK = T1_NUMVBNK + 1;
  parameter BITPBNK = IP_BITPBNK;
  
  parameter NUMWRDS = T1_NUMWRDS;     // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  
  parameter REFRESH = IP_REFRESH;      // REFRESH Parameters 
  parameter NUMRBNK = T1_NUMRBNK;
  parameter BITWSPF = T1_BITWSPF;
  parameter BITRBNK = T1_BITRBNK;
  parameter NUMRROW = T1_NUMRROW;
  parameter BITRROW = T1_BITRROW;
  parameter REFFREQ = IP_REFFREQ;
  
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T3_DELAY;
  parameter DRAM_DELAY = T1_DELAY;
  
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

  parameter MEMWDTH = ENAEXT ? NUMWRDS*WIDTH : ENAPAR ? NUMWRDS*WIDTH+1 : ENAECC ? NUMWRDS*WIDTH+ECCWDTH : NUMWRDS*WIDTH;
  parameter PHYWDTH = MEMWDTH;
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter BITMAPT = BITPBNK*NUMVBNK;
  parameter SDOUT_WIDTH = 2*BITMAPT+ECCBITS;
  
input clk; input rst; input refr;
output ready; 


input  [NUMRUPT - 1:0] 				ru_read; 
input  [NUMRUPT - 1:0]				ru_write; 
input  [NUMRUPT* BITADDR - 1:0] 	ru_addr; 
input  [NUMRUPT* WIDTH - 1:0]		ru_din;
output [NUMRUPT* WIDTH - 1:0] 		ru_dout; 
output [NUMRUPT - 1:0] 				ru_vld; 
output [NUMRUPT - 1:0] 				ru_serr; 
output [NUMRUPT - 1:0] 				ru_derr; 
output [NUMRUPT* BITPADR - 1:0] 	ru_padr;

output [T1_INST - 1:0] 			t1_readA; 
output [T1_INST- 1:0] 			t1_writeA; 
output [T1_INST*BITSROW - 1:0] t1_addrA; 
output [T1_INST*PHYWDTH - 1:0] 	t1_dinA;
output [T1_INST*PHYWDTH - 1:0] 	t1_bwA; 
input  [T1_INST*PHYWDTH - 1:0] 	t1_doutA;
output [T1_INST*BITDWSN - 1:0] t1_dwsnA;

output [T1_INST - 1:0] 			t1_refrB; 
output [T1_INST*BITRBNK - 1:0] 	t1_bankB;

output [T2_INST - 1:0] t2_readA; 
output [T2_INST - 1:0] t2_writeA; 
output [T2_INST*BITSROW - 1:0] t2_addrA; 
output [T2_INST*PHYWDTH - 1:0] t2_dinA; 
output [T2_INST*PHYWDTH - 1:0] t2_bwA; 
input  [T2_INST*PHYWDTH - 1:0] t2_doutA;
output [T2_INST*BITDWSN - 1:0] t2_dwsnA;

output [T2_INST - 1:0] t2_refrB; 
output [T2_INST*BITRBNK - 1:0] t2_bankB; 

output [T3_INST - 1:0] t3_writeA; 
output [T3_INST*BITSROW - 1:0] t3_addrA; 
output [T3_INST*SDOUT_WIDTH - 1:0] t3_dinA; 
output [T3_INST*SDOUT_WIDTH - 1:0] t3_bwA;

output [T3_INST - 1:0] t3_readB; 
output [T3_INST*BITSROW - 1:0] t3_addrB; 
input  [T3_INST*SDOUT_WIDTH - 1:0] t3_doutB;

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

  task DumpMem;
  begin
    integer file, i;
    file = $fopen ("mem_dump.txt", "w");
    for (i = 0; i < NUMADDR; i = i + 1)
      $fwrite (file, "0x%x 0x%x\n", i, algo_ref.mem[i]);
  end
  endtask

  algo_1r1w_ref #(
    .WIDTH(WIDTH), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .MEM_DELAY(T1_DELAY+FLOPIN+FLOPMEM+FLOPOUT),
    .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK),
    .NUMSROW(NUMSROW), .BITSROW(BITSROW), .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS),
    .BITPADR(BITPADR)) algo_ref (
    .read_0(read), .addr_0(rd_adr), .read_vld_0(rd_vld), .dout_0(rd_dout),
    .read_serr_0(rd_serr), .read_derr_0(rd_derr), .read_padr_0(rd_padr),
    .write_1(write), .addr_1(wr_adr), .din_1(din), .clk(clk), .rst(rst));

`else

wire t3_writeA_tmp;
wire [BITSROW-1:0] t3_addrA_tmp;
wire [SDOUT_WIDTH-1:0] t3_bwA_tmp;
wire [SDOUT_WIDTH-1:0] t3_dinA_tmp;

  algo_1ru_1rw_mt_top
		#(.WIDTH(WIDTH),   .BITWDTH(BITWDTH),   .ENAEXT(ENAEXT), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ECCWDTH(ECCWDTH), .NUMRUPT(NUMRUPT),
                  .NUMADDR(NUMADDR),  .BITADDR(BITADDR),
		.NUMVROW(NUMVROW),   .BITVROW(BITVROW),   .BITPROW(BITPROW),   .NUMVBNK(NUMVBNK),   .BITVBNK(BITVBNK),
		.NUMPBNK(NUMPBNK),   .BITPBNK(BITPBNK),
		.NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW),
		.REFRESH(REFRESH),   .NUMRBNK(NUMRBNK),   .BITWSPF(BITWSPF),  .BITRBNK(BITRBNK),   .NUMRROW(NUMRROW),   .BITRROW(BITRROW),
		.REFFREQ(REFFREQ),   .ECCBITS(ECCBITS),   .SRAM_DELAY(SRAM_DELAY),   .DRAM_DELAY(DRAM_DELAY),
		.NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
		.NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
		.NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
		.NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15),
		.BITDWSN (BITDWSN), .FLOPIN(FLOPIN),   .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT))
  algo_top
	(.clk(clk), .rst(rst), .ready(ready), .refr(refr), 
	
        .read(ru_read),
        .write(ru_write),
        .addr(ru_addr),
        .din(ru_din),
	.rd_dout(ru_dout),
        .rd_vld (ru_vld),
        .rd_serr(ru_serr),
        .rd_derr(ru_derr),
        .rd_padr(ru_padr),
     
	.t1_readA({t2_readA, t1_readA}), .t1_writeA({t2_writeA, t1_writeA}), .t1_addrA({t2_addrA, t1_addrA}), .t1_bwA({t2_bwA, t1_bwA}), .t1_dinA({t2_dinA, t1_dinA}), .t1_doutA({t2_doutA, t1_doutA}), .t1_dwsnA({t2_dwsnA, t1_dwsnA}),
	.t1_refrB({t2_refrB, t1_refrB}), .t1_bankB({t2_bankB, t1_bankB}),
	.t2_writeA(t3_writeA_tmp), .t2_addrA(t3_addrA_tmp), .t2_bwA(t3_bwA_tmp), .t2_dinA(t3_dinA_tmp),
        .t2_readB(t3_readB), .t2_addrB(t3_addrB), .t2_doutB(t3_doutB));

assign t3_writeA = {T3_INST{t3_writeA_tmp}};
assign t3_addrA = {T3_INST{t3_addrA_tmp}};
assign t3_bwA = {T3_INST{t3_bwA_tmp}};
assign t3_dinA = {T3_INST{t3_dinA_tmp}};

`endif

// MEMOIR_TRANSLATE_ON

endmodule    //algo_1ru_a260_top_wrap
