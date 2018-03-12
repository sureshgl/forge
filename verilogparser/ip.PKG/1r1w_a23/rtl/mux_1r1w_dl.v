module mux_1r1w_dl (clk, rst,
                    pref,
	            pwrite, pwrbadr, pwrradr, pdin,
	            pread, prdbadr, prdradr, pdout, pdout_fwrd, pdout_serr, pdout_derr, pdout_padr,
	            sread1, srdradr1, sdout1,
	            sread2, srdradr2, sdout2,
	            swrite, swrradr, sdin,
	            cread, crdradr, cdout,
	            cwrite, cwrradr, cdin,

	            t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA, t1_fwrdA, t1_serrA, t1_derrA, t1_padrA, t1_refrB,
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
assign t1_refrB = {NUMVBNK{pref}};

integer prd_int;
reg [BITVBNK-1:0] prdbadr_reg [0:DRAM_DELAY-1];
always @(posedge clk)
  for (prd_int=0; prd_int<DRAM_DELAY; prd_int=prd_int+1)
    if (prd_int>0)
      prdbadr_reg[prd_int] <= prdbadr_reg[prd_int-1];
    else
      prdbadr_reg[prd_int] <= prdbadr;

assign pdout = t1_doutA >> (prdbadr_reg[DRAM_DELAY-1]*WIDTH);
assign pdout_fwrd = t1_fwrdA >> (prdbadr_reg[DRAM_DELAY-1]);
assign pdout_serr = t1_serrA >> (prdbadr_reg[DRAM_DELAY-1]);
assign pdout_derr = t1_derrA >> (prdbadr_reg[DRAM_DELAY-1]);
assign pdout_padr = t1_padrA >> (prdbadr_reg[DRAM_DELAY-1]*BITPADR);

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


