module mux_1r1wor2w_1rw (clk, rst,
	                 pread1, prdbadr1, prdradr1, pdout1,
           	         pwrite1, pwrbadr1, pwrradr1, pdin1,
           	         pwrite2, pwrbadr2, pwrradr2, pdin2,
           	         sread1, srdradr1, sdout1,
           	         sread2, srdradr2, sdout2,
           	         swrite, swrradr, sdin,
	                 cread1, crdradr1, cdout1,
	                 cread2, crdradr2, cdout2,
	                 cwrite, cwrradr, cdin,
	                 t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA,
	                 t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
	                 t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB);

  parameter WIDTH   = 32;

  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter ECCBITS = 4;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;
  
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;

input clk;
input rst;

input pread1;
input [BITVBNK-1:0] prdbadr1;
input [BITVROW-1:0] prdradr1;
output [WIDTH-1:0] pdout1;

input pwrite1;
input [BITVBNK-1:0] pwrbadr1;
input [BITVROW-1:0] pwrradr1;
input [WIDTH-1:0] pdin1;

input pwrite2;
input [BITVBNK-1:0] pwrbadr2;
input [BITVROW-1:0] pwrradr2;
input [WIDTH-1:0] pdin2;

input sread1;
input [BITVROW-1:0] srdradr1;
output [SDOUT_WIDTH-1:0] sdout1;

input sread2;
input [BITVROW-1:0] srdradr2;
output [SDOUT_WIDTH-1:0] sdout2;

input swrite;
input [BITVROW-1:0] swrradr;
input [SDOUT_WIDTH-1:0] sdin;

input cread1;
input [BITVROW-1:0] crdradr1;
output [WIDTH-1:0] cdout1;

input cread2;
input [BITVROW-1:0] crdradr2;
output [WIDTH-1:0] cdout2;

input cwrite;
input [BITVROW-1:0] cwrradr;
input [WIDTH-1:0] cdin;

output [NUMVBNK-1:0] t1_readA;
output [NUMVBNK-1:0] t1_writeA;
output [NUMVBNK*BITVROW-1:0] t1_addrA;
output [NUMVBNK*WIDTH-1:0] t1_dinA;
input [NUMVBNK*WIDTH-1:0] t1_doutA;

output [2-1:0] t2_writeA;
output [2*BITVROW-1:0] t2_addrA;
output [2*SDOUT_WIDTH-1:0] t2_dinA;

output [2-1:0] t2_readB;
output [2*BITVROW-1:0] t2_addrB;
input [2*SDOUT_WIDTH-1:0] t2_doutB;

output [2-1:0] t3_writeA;
output [2*BITVROW-1:0] t3_addrA;
output [2*WIDTH-1:0] t3_dinA;

output [2-1:0] t3_readB;
output [2*BITVROW-1:0] t3_addrB;
input [2*WIDTH-1:0] t3_doutB;

assign t1_readA = pread1 ? (pread1 << prdbadr1) : 0;
assign t1_writeA = (pwrite1 ? (pwrite1 << pwrbadr1) : 0) | (pwrite2 ? (pwrite2 << pwrbadr2) : 0);

reg [NUMVBNK*BITVROW-1:0] t1_addrA;
reg [NUMVBNK*WIDTH-1:0] t1_dinA;
integer t1_int;
always_comb begin
  t1_addrA = 0;
  t1_dinA = 0;
  for (t1_int=0; t1_int<NUMVBNK; t1_int=t1_int+1)
    if (pwrite2 && (t1_int==pwrbadr2)) begin
      t1_addrA = t1_addrA | (pwrradr2 << (t1_int*BITVROW));
      t1_dinA = t1_dinA | (pdin2 << (t1_int*WIDTH));
    end else if (pwrite1 && (t1_int==pwrbadr1)) begin
      t1_addrA = t1_addrA | (pwrradr1 << (t1_int*BITVROW));
      t1_dinA = t1_dinA | (pdin1 << (t1_int*WIDTH));
    end else begin
      t1_addrA = t1_addrA | (prdradr1 << (t1_int*BITVROW));
      t1_dinA = t1_dinA;
    end
end

reg [BITVBNK-1:0] prdbadr1_reg [0:SRAM_DELAY-1];
integer prd_int;
always @(posedge clk)
  for (prd_int=0; prd_int<SRAM_DELAY; prd_int=prd_int+1)
    if (prd_int>0)
      prdbadr1_reg[prd_int] <= prdbadr1_reg[prd_int-1];
    else
      prdbadr1_reg[prd_int] <= prdbadr1;

assign pdout1 = t1_doutA >> (prdbadr1_reg[SRAM_DELAY-1]*WIDTH);

assign t2_writeA = {2{swrite}};
assign t2_addrA = {2{swrradr}};
assign t2_dinA = {2{sdin}};

assign t2_readB = {sread2,sread1};
assign t2_addrB = {srdradr2,srdradr1};

assign sdout1 = t2_doutB;
assign sdout2 = t2_doutB >> SDOUT_WIDTH;

assign t3_writeA = {2{cwrite}};
assign t3_addrA = {2{cwrradr}};
assign t3_dinA = {2{cdin}};

assign t3_readB = {cread2,cread1};
assign t3_addrB = {crdradr2,crdradr1};

assign cdout1 = t3_doutB;
assign cdout2 = t3_doutB >> WIDTH;

endmodule

