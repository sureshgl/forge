module mux_1r1w_mt_pseudo (clk, rst,
	                   pread, prdbadr, prdradr, pdout, pdout_fwrd, pdout_serr, pdout_derr, pdout_padr,
                           prefr, pwrite, pwrbadr, pwrradr, pdin,
                           swrite, swrradr, sdin,
                           sread, srdradr, sdout, sdout_fwrd, sdout_serr, sdout_derr, sdout_padr,
                           t1_writeA, t1_bankA, t1_addrA, t1_dinA,
                           t1_readB, t1_bankB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB, t1_refrC,
                           t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_serrB, t2_derrB, t2_padrB);

  parameter WIDTH   = 32;

  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMPBNK = 11;
  parameter BITPBNK = 4; 
  parameter BITPADR = 10;

  parameter ECCBITS = 8;

  parameter BITMAPT = BITPBNK*NUMPBNK;
  parameter SDOUT_WIDTH = 2*BITMAPT+ECCBITS;
  
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;

input clk;
input rst;

input prefr;

input pread;
input [BITPBNK-1:0] prdbadr;
input [BITVROW-1:0] prdradr;
output [WIDTH-1:0] pdout;
output pdout_fwrd;
output pdout_serr;
output pdout_derr;
output [BITPADR-1:0] pdout_padr;

input pwrite;
input [BITPBNK-1:0] pwrbadr;
input [BITVROW-1:0] pwrradr;
input [WIDTH-1:0] pdin;

input [2-1:0] sread;
input [2*BITVROW-1:0] srdradr;
output [2*SDOUT_WIDTH-1:0] sdout;
output [2-1:0] sdout_fwrd;
output [2-1:0] sdout_serr;
output [2-1:0] sdout_derr;
output [2*(BITPADR-BITPBNK)-1:0] sdout_padr;

input swrite;
input [BITVROW-1:0] swrradr;
input [SDOUT_WIDTH-1:0] sdin;

output t1_writeA;
output [BITPBNK-1:0] t1_bankA;
output [BITVROW-1:0] t1_addrA;
output [WIDTH-1:0] t1_dinA;
output t1_readB;
output [BITPBNK-1:0] t1_bankB;
output [BITVROW-1:0] t1_addrB;
input [WIDTH-1:0] t1_doutB;
input t1_fwrdB;
input t1_serrB;
input t1_derrB;
input [(BITPADR-BITPBNK)-1:0] t1_padrB;
output t1_refrC;

output [2-1:0] t2_writeA;
output [2*BITVROW-1:0] t2_addrA;
output [2*SDOUT_WIDTH-1:0] t2_dinA;

output [2-1:0] t2_readB;
output [2*BITVROW-1:0] t2_addrB;
input [2*SDOUT_WIDTH-1:0] t2_doutB;
input [2-1:0] t2_fwrdB;
input [2-1:0] t2_serrB;
input [2-1:0] t2_derrB;
input [2*(BITPADR-BITPBNK)-1:0] t2_padrB;

assign t1_writeA = pwrite && (pwrbadr < NUMPBNK);
assign t1_bankA = pwrbadr;
assign t1_addrA = pwrradr;
assign t1_dinA = pdin;

assign t1_readB = pread && (prdbadr < NUMPBNK);
assign t1_bankB = prdbadr;
assign t1_addrB = prdradr;

reg [BITPBNK-1:0] prdbadr_reg [0:DRAM_DELAY-1];
integer prd_int;
always @(posedge clk)
  for (prd_int=0; prd_int<DRAM_DELAY; prd_int=prd_int+1)
    if (prd_int>0)
      prdbadr_reg[prd_int] <= prdbadr_reg[prd_int-1];
    else
      prdbadr_reg[prd_int] <= prdbadr;
 
assign pdout = t1_doutB;
assign pdout_fwrd = t1_fwrdB;
assign pdout_serr = t1_serrB;
assign pdout_derr = t1_derrB;
assign pdout_padr = {prdbadr_reg[DRAM_DELAY-1],t1_padrB};

assign t1_refrC = prefr;

assign t2_writeA = {2{swrite}};
assign t2_addrA = {2{swrradr}};
assign t2_dinA = {2{sdin}};

assign t2_readB = sread;
assign t2_addrB = srdradr;

assign sdout = t2_doutB;
assign sdout_fwrd = t2_fwrdB;
assign sdout_serr = t2_serrB;
assign sdout_derr = t2_derrB;
assign sdout_padr = t2_padrB;

endmodule

