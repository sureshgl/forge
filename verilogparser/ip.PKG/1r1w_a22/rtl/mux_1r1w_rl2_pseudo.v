module mux_1r1w_rl2_pseudo (clk, rst,
                            prefr,
		            pwrite, pwrbadr, pwrradr, pdin,
		            pread, prdbadr, prdradr, pdout, pdout_fwrd, pdout_serr, pdout_derr, pdout_padr,
		            swrite, swrradr, sdin,
                            sread1, srdradr1, sdout1, sdout1_fwrd, sdout1_serr, sdout1_derr, sdout1_padr,
                            sread2, srdradr2, sdout2, sdout2_fwrd, sdout2_serr, sdout2_derr, sdout2_padr,
                            t1_writeA, t1_bankA, t1_addrA, t1_dinA,
                            t1_readB, t1_bankB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB, t1_refrC,
                            t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_serrB, t2_derrB, t2_padrB);

  parameter WIDTH   = 32;
  parameter BITWDTH = 5;

  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPADR = 10;
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter ECCBITS = 4;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

input clk;
input rst;

input prefr;

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
output [SDOUT_WIDTH+WIDTH-1:0] sdout1;
output sdout1_fwrd;
output sdout1_serr;
output sdout1_derr;
output [BITPADR-1:0] sdout1_padr;

input sread2;
input [BITVROW-1:0] srdradr2;
output [SDOUT_WIDTH+WIDTH-1:0] sdout2;
output sdout2_fwrd;
output sdout2_serr;
output sdout2_derr;
output [BITPADR-1:0] sdout2_padr;

input swrite;
input [BITVROW-1:0] swrradr;
input [SDOUT_WIDTH+WIDTH-1:0] sdin;

output [1-1:0] t1_writeA;
output [1*BITVBNK-1:0] t1_bankA;
output [1*BITVROW-1:0] t1_addrA;
output [1*WIDTH-1:0] t1_dinA;
output [1-1:0] t1_readB;
output [1*BITVBNK-1:0] t1_bankB;
output [1*BITVROW-1:0] t1_addrB;
input [1*WIDTH-1:0] t1_doutB;
input [1-1:0] t1_fwrdB;
input [1-1:0] t1_serrB;
input [1-1:0] t1_derrB;
input [1*BITPADR-1:0] t1_padrB;
output [1-1:0] t1_refrC;

output [2-1:0] t2_writeA;
output [2*BITVROW-1:0] t2_addrA;
output [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA;

output [2-1:0] t2_readB;
output [2*BITVROW-1:0] t2_addrB;
input [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB;
input [2-1:0] t2_fwrdB;
input [2-1:0] t2_serrB;
input [2-1:0] t2_derrB;
input [2*BITPADR-1:0] t2_padrB;

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

assign t1_refrC = prefr;

assign t2_writeA = {2{swrite}};
assign t2_addrA = {2{swrradr}};
assign t2_dinA = {2{sdin}};

assign t2_readB = {sread2,sread1};
assign t2_addrB = {srdradr2,srdradr1};

assign sdout1 = t2_doutB;
assign sdout1_fwrd = t2_fwrdB;
assign sdout1_serr = t2_serrB;
assign sdout1_derr = t2_derrB;
assign sdout1_padr = t2_padrB;

assign sdout2 = t2_doutB >> (SDOUT_WIDTH+WIDTH);
assign sdout2_fwrd = t2_fwrdB >> 1;
assign sdout2_serr = t2_serrB >> 1;
assign sdout2_derr = t2_derrB >> 1;
assign sdout2_padr = t2_padrB >> BITPADR;

endmodule


