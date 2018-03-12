module mux_1r1w_rl2_a21 (clk, rst,
                         prefr,
		         pwrite, pwrbadr, pwrradr, pdin,
		         pread, prdbadr, prdradr, pdout, pdout_fwrd, pdout_serr, pdout_derr, pdout_padr,
		         swrite, swrradr, sdin,
		         sread1, srdradr1, sdout1, sdout1_fwrd, sdout1_serr, sdout1_derr, sdout1_padr,
		         sread2, srdradr2, sdout2, sdout2_fwrd, sdout2_serr, sdout2_derr, sdout2_padr,
		         t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA, t1_fwrdA, t1_serrA, t1_derrA, t1_padrA, t1_refrB,
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

output [NUMVBNK-1:0] t1_readA;
output [NUMVBNK-1:0] t1_writeA;
output [NUMVBNK*BITVROW-1:0] t1_addrA;
output [NUMVBNK*WIDTH-1:0] t1_dinA;
input [NUMVBNK*WIDTH-1:0] t1_doutA;
input [NUMVBNK-1:0] t1_fwrdA;
input [NUMVBNK-1:0] t1_serrA;
input [NUMVBNK-1:0] t1_derrA;
input [NUMVBNK*BITPADR-1:0] t1_padrA;
output [NUMVBNK-1:0] t1_refrB;

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

assign t1_readA = pread ? (pread << prdbadr) : 0;
assign t1_writeA = pwrite ? (pwrite << pwrbadr) : 0;

integer t1_addr_int;
reg [NUMVBNK*BITVROW-1:0] t1_addrA;
always_comb begin
  t1_addrA = 0;
  for (t1_addr_int=0; t1_addr_int<NUMVBNK; t1_addr_int=t1_addr_int+1) 
    if (pwrite && (pwrbadr == t1_addr_int))
      t1_addrA =  t1_addrA | (pwrradr << (BITVROW*t1_addr_int));
    else
      t1_addrA =  t1_addrA | (prdradr << (BITVROW*t1_addr_int));
end

assign t1_dinA = {NUMVBNK{pdin}};
assign t1_refrB = {NUMVBNK{prefr}};

integer prd_int;
reg [BITVBNK-1:0] prdbadr_reg [0:DRAM_DELAY-1];
always @(posedge clk)
  for (prd_int=0; prd_int<DRAM_DELAY; prd_int=prd_int+1)
    if (prd_int>0)
      prdbadr_reg[prd_int] <= prdbadr_reg[prd_int-1];
    else
      prdbadr_reg[prd_int] <= prdbadr;

assign pdout = t1_doutA >> (prdbadr_reg[DRAM_DELAY-1]*WIDTH);
assign pdout_fwrd = t1_fwrdA >> (prdbadr_reg[DRAM_DELAY-1]*WIDTH);
assign pdout_serr = t1_serrA >> (prdbadr_reg[DRAM_DELAY-1]*WIDTH);
assign pdout_derr = t1_derrA >> (prdbadr_reg[DRAM_DELAY-1]*WIDTH);
assign pdout_padr = t1_padrA >> (prdbadr_reg[DRAM_DELAY-1]*BITPADR);

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


