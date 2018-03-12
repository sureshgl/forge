module mux_2rw_2ror1w (clk, rst,
	               pread1, prdbadr1, prdradr1, pdout1,
	               pread2, prdbadr2, prdradr2, pdout2,
           	       pwrite1, pwrbadr1, pwrradr1, pdin1,
           	       pwrite2, pwrbadr2, pwrradr2, pdin2,
           	       sread1, srdradr1, sdout1,
           	       sread2, srdradr2, sdout2,
           	       swrite, swrradr, sdin,
	               cread1, crdradr1, cdout1,
	               cread2, crdradr2, cdout2,
	               cwrite, cwrradr, cdin,
	               t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_readC, t1_addrC, t1_doutC,
	               t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
	               t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB);

  parameter WIDTH   = 32;

  parameter BITVBNK = 3;

  parameter ECCBITS = 4;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;
  
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;

  parameter T1_NUM_MEM = 8;
  parameter T1_ADR_BIT = 10;
  parameter T1_DAT_BIT = 32;
  parameter T2_NUM_MEM = 2;
  parameter T2_ADR_BIT = 10;
  parameter T2_DAT_BIT = 12;
  parameter T3_NUM_MEM = 2;
  parameter T3_ADR_BIT = 10;
  parameter T3_DAT_BIT = 32;

input clk;
input rst;

input pread1;
input [BITVBNK-1:0] prdbadr1;
input [BITVROW-1:0] prdradr1;
output [WIDTH-1:0] pdout1;

input pread2;
input [BITVBNK-1:0] prdbadr2;
input [BITVROW-1:0] prdradr2;
output [WIDTH-1:0] pdout2;

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

output [T1_NUM_MEM-1:0] t1_writeA;
output [T1_NUM_MEM*T1_ADR_BIT-1:0] t1_addrA;
output [T1_NUM_MEM*T1_DAT_BIT-1:0] t1_dinA;

output [T1_NUM_MEM-1:0] t1_readB;
output [T1_NUM_MEM*T1_ADR_BIT-1:0] t1_addrB;
input [T1_NUM_MEM*T1_DAT_BIT-1:0] t1_doutB;

output [T1_NUM_MEM-1:0] t1_readC;
output [T1_NUM_MEM*T1_ADR_BIT-1:0] t1_addrC;
input [T1_NUM_MEM*T1_DAT_BIT-1:0] t1_doutC;

output [T2_NUM_MEM-1:0] t2_writeA;
output [T2_NUM_MEM*T2_ADR_BIT-1:0] t2_addrA;
output [T2_NUM_MEM*T2_DAT_BIT-1:0] t2_dinA;

output [T2_NUM_MEM-1:0] t2_readB;
output [T2_NUM_MEM*T2_ADR_BIT-1:0] t2_addrB;
input [T2_NUM_MEM*T2_DAT_BIT-1:0] t2_doutB;

output [T3_NUM_MEM-1:0] t3_writeA;
output [T3_NUM_MEM*T3_ADR_BIT-1:0] t3_addrA;
output [T3_NUM_MEM*T3_DAT_BIT-1:0] t3_dinA;

output [T3_NUM_MEM-1:0] t3_readB;
output [T3_NUM_MEM*T3_ADR_BIT-1:0] t3_addrB;
input [T3_NUM_MEM*T3_DAT_BIT-1:0] t3_doutB;

assign t1_writeA = (pwrite1 ? (pwrite1 << pwrbadr1) : 0) | (pwrite2 ? (pwrite2 << pwrbadr2) : 0);

reg [T1_NUM_MEM*T1_ADR_BIT-1:0] t1_addrA;
reg [T1_NUM_MEM*T1_DAT_BIT-1:0] t1_dinA;
integer t1_A_int;
always_comb begin
  t1_addrA = 0;
  t1_dinA = 0;
  for (t1_A_int=0; t1_A_int<T1_NUM_MEM; t1_A_int=t1_A_int+1)
    if (pwrite2 && (t1_A_int==pwrbadr2)) begin
      t1_addrA = t1_addrA | (pwrradr2 << (t1_A_int*T1_ADR_BIT));
      t1_dinA = t1_dinA | (pdin2 << (t1_A_int*T1_DAT_BIT));
    end else begin
      t1_addrA = t1_addrA | (pwrradr1 << (t1_A_int*T1_ADR_BIT));
      t1_dinA = t1_dinA | (pdin1 << (t1_A_int*T1_DAT_BIT));
    end
end

assign t1_readB = pread1 ? (pread1 << prdbadr1) : 0;
assign t1_addrB = {T1_NUM_MEM{prdradr1}}; 

assign t1_readC = pread2 ? (pread2 << prdbadr2) : 0;
assign t1_addrC = {T1_NUM_MEM{prdradr2}}; 

reg [BITVBNK-1:0] prdbadr1_reg [0:SRAM_DELAY-1];
reg [BITVBNK-1:0] prdbadr2_reg [0:SRAM_DELAY-1];
integer prd_int;
always @(posedge clk)
  for (prd_int=0; prd_int<SRAM_DELAY; prd_int=prd_int+1)
    if (prd_int>0) begin
      prdbadr1_reg[prd_int] <= prdbadr1_reg[prd_int-1];
      prdbadr2_reg[prd_int] <= prdbadr2_reg[prd_int-1];
    end else begin
      prdbadr1_reg[prd_int] <= prdbadr1;
      prdbadr2_reg[prd_int] <= prdbadr2;
    end

assign pdout1 = t1_doutB >> (prdbadr1_reg[SRAM_DELAY-1]*T1_DAT_BIT);
assign pdout2 = t1_doutC >> (prdbadr2_reg[SRAM_DELAY-1]*T1_DAT_BIT);

assign t2_writeA = {2{swrite}};
assign t2_addrA = {2{swrradr}};
assign t2_dinA = {2{sdin}};

assign t2_readB = {sread2,sread1};
assign t2_addrB = {srdradr2,srdradr1};

assign sdout1 = t2_doutB;
assign sdout2 = t2_doutB >> T2_DAT_BIT;

assign t3_writeA = {2{cwrite}};
assign t3_addrA = {2{cwrradr}};
assign t3_dinA = {2{cdin}};

assign t3_readB = {cread2,cread1};
assign t3_addrB = {crdradr2,crdradr1};

assign cdout1 = t3_doutB;
assign cdout2 = t3_doutB >> T3_DAT_BIT;

endmodule

