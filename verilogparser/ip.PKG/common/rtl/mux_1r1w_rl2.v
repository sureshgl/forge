module mux_1r1w_rl2 (clk, rst,
		     pwrite, pwrbadr, pwrradr, pdin,
		     pread, prdbadr, prdradr, pdout,
		     swrite, swrradr, sdin,
		     sread1, srdradr1, sdout1,
		     sread2, srdradr2, sdout2,
		     t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA,
		     t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB);

  parameter WIDTH   = 32;
  parameter BITWDTH = 5;

  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter BITVBNK = 3;
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter ECCBITS = 4;

  parameter T1_NUM_MEM = 8;
  parameter T1_ADR_BIT = 10;
  parameter T1_DAT_BIT = 32;
  parameter T2_NUM_MEM = 2;
  parameter T2_ADR_BIT = 10;
  parameter T2_DAT_BIT = 44;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

input clk;
input rst;

input pread;
input [BITVBNK-1:0] prdbadr;
input [BITVROW-1:0] prdradr;
output [WIDTH-1:0] pdout;

input pwrite;
input [BITVBNK-1:0] pwrbadr;
input [BITVROW-1:0] pwrradr;
input [WIDTH-1:0] pdin;

input sread1;
input [BITVROW-1:0] srdradr1;
output [SDOUT_WIDTH+WIDTH-1:0] sdout1;

input sread2;
input [BITVROW-1:0] srdradr2;
output [SDOUT_WIDTH+WIDTH-1:0] sdout2;

input swrite;
input [BITVROW-1:0] swrradr;
input [SDOUT_WIDTH+WIDTH-1:0] sdin;

output [T1_NUM_MEM-1:0] t1_readA;
output [T1_NUM_MEM-1:0] t1_writeA;
output [T1_NUM_MEM*T1_ADR_BIT-1:0] t1_addrA;
output [T1_NUM_MEM*T1_DAT_BIT-1:0] t1_dinA;
input [T1_NUM_MEM*T1_DAT_BIT-1:0] t1_doutA;

output [2-1:0] t2_writeA;
output [2*T2_ADR_BIT-1:0] t2_addrA;
output [2*T2_DAT_BIT-1:0] t2_dinA;

output [2-1:0] t2_readB;
output [2*T2_ADR_BIT-1:0] t2_addrB;
input [2*T2_DAT_BIT-1:0] t2_doutB;

assign t1_readA = pread ? (pread << prdbadr) : 0;
assign t1_writeA = pwrite ? (pwrite << pwrbadr) : 0;

integer t1_addr_int;
reg [T1_NUM_MEM*T1_ADR_BIT-1:0] t1_addrA;
always_comb begin
  t1_addrA = 0;
  for (t1_addr_int=0; t1_addr_int<T1_NUM_MEM; t1_addr_int=t1_addr_int+1) 
    if (pwrite && (pwrbadr == t1_addr_int))
      t1_addrA =  t1_addrA | (pwrradr << (T1_ADR_BIT*t1_addr_int));
    else
      t1_addrA =  t1_addrA | (prdradr << (T1_ADR_BIT*t1_addr_int));
end

assign t1_dinA = {T1_NUM_MEM{pdin}};

integer prd_int;
reg [BITVBNK-1:0] prdbadr_reg [0:DRAM_DELAY-1];
always @(posedge clk)
  for (prd_int=0; prd_int<DRAM_DELAY; prd_int=prd_int+1)
    if (prd_int>0)
      prdbadr_reg[prd_int] <= prdbadr_reg[prd_int-1];
    else
      prdbadr_reg[prd_int] <= prdbadr;

assign pdout = t1_doutA >> (prdbadr_reg[DRAM_DELAY-1] * T1_DAT_BIT);

assign t2_writeA = {2{swrite}};
assign t2_addrA = {2{swrradr}};
assign t2_dinA = {2{sdin}};

assign t2_readB = {sread2,sread1};
assign t2_addrB = {srdradr2,srdradr1};

assign sdout1 = t2_doutB;
assign sdout2 = t2_doutB >> T2_DAT_BIT;

endmodule


