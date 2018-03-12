module mux_1r1w_dl_pseudo (clk, rst,
                           pref,
	                   pwrite, pwrbadr, pwrradr, pdin,
	                   pread, prdbadr, prdradr, pdout, pdout_fwrd, pdout_serr, pdout_derr, pdout_padr,
	                   sread1, srdradr1, sdout1,
	                   sread2, srdradr2, sdout2,
	                   swrite, swrradr, sdin,
	                   cread, crdradr, cdout,
	                   cwrite, cwrradr, cdin,
	                   t1_writeA, t1_bankA, t1_addrA, t1_dinA, t1_readB, t1_bankB, t1_addrB,
                           t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB, t1_refrC,
	                   t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
	                   t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB);

  parameter WIDTH   = 32;

  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPADR = 10;
  parameter ECCBITS = 4;
  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;

input clk;
input rst;

input pref;

input pread;
input [BITVBNK-1:0] prdbadr;
input [BITVROW-1:0] prdradr;
output [WIDTH-1:0] pdout;
output pdout_fwrd;
output pdout_serr;
output pdout_derr;
output [BITPADR-1:0] pdout_padr;

input pwrite;
input [BITVBNK-1:0] pwrbadr;
input [BITVROW-1:0] pwrradr;
input [WIDTH-1:0] pdin;

input sread1;
input [BITVROW-1:0] srdradr1;
output [SDOUT_WIDTH-1:0] sdout1;

input sread2;
input [BITVROW-1:0] srdradr2;
output [SDOUT_WIDTH-1:0] sdout2;

input swrite;
input [BITVROW-1:0] swrradr;
input [SDOUT_WIDTH-1:0] sdin;

input cread;
input [BITVROW-1:0] crdradr;
output [WIDTH-1:0] cdout;

input cwrite;
input [BITVROW-1:0] cwrradr;
input [WIDTH-1:0] cdin;

output [1-1:0] t1_writeA;
output [1*BITVBNK-1:0] t1_bankA;
output [1*BITVROW-1:0] t1_addrA;
output [1*WIDTH-1:0] t1_dinA;
output [1-1:0] t1_readB;
output [1*BITVBNK-1:0] t1_bankB;
output [1*BITVROW-1:0] t1_addrB;
input [1*WIDTH-1:0] t1_doutB;
input t1_fwrdB;
input t1_serrB;
input t1_derrB;
input [1*BITPADR-1:0] t1_padrB;
output [1-1:0] t1_refrC;

output [2-1:0] t2_writeA;
output [2*BITVROW-1:0] t2_addrA;
output [2*SDOUT_WIDTH-1:0] t2_dinA;
output [2-1:0] t2_readB;
output [2*BITVROW-1:0] t2_addrB;
input [2*SDOUT_WIDTH-1:0] t2_doutB;

output [1-1:0] t3_writeA;
output [1*BITVROW-1:0] t3_addrA;
output [1*WIDTH-1:0] t3_dinA;
output [1-1:0] t3_readB;
output [1*BITVROW-1:0] t3_addrB;
input [1*WIDTH-1:0] t3_doutB;

assign t1_writeA = pwrite && (pwrbadr < NUMVBNK);
assign t1_bankA = pwrbadr;
assign t1_addrA = pwrradr;
assign t1_dinA = pdin;

assign t1_readB = pread && (prdbadr < NUMVBNK);
assign t1_bankB = prdbadr;
assign t1_addrB = prdradr;
assign pdout = t1_doutB;
assign pdout_fwrd = t1_fwrdB;
assign pdout_serr = t1_serrB;
assign pdout_derr = t1_derrB;
assign pdout_padr = t1_padrB;

assign t1_refrC = pref;

assign t2_writeA = {2{swrite}};
assign t2_addrA = {2{swrradr}};
assign t2_dinA = {2{sdin}};

assign t2_readB = {sread2,sread1};
assign t2_addrB = {srdradr2,srdradr1};

assign sdout1 = t2_doutB;
assign sdout2 = t2_doutB >> SDOUT_WIDTH;

assign t3_writeA = cwrite;
assign t3_addrA = cwrradr;
assign t3_dinA = cdin;

assign t3_readB = cread;
assign t3_addrB = crdradr;

assign cdout = t3_doutB;

endmodule


