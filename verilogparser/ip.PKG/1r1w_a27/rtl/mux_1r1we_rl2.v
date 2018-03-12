module mux_1r1we_rl2 (clk, rst,
                      prefr,
		      pwrite, pwrbadr, pwrradr, pbwe, pdin,
		      pread, prdbadr, prdradr, pdout, ppadr,
		      swrite, swrradr, sdin, cbwe, cdin,
		      sread1, srdradr1, sdout1, cdout1,
		      sread2, srdradr2, sdout2, cdout2,
		      t1_readA, t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_doutA, t1_padrA, t1_refrB,
		      t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_readB, t2_addrB, t2_doutB);

  parameter WIDTH   = 32;
  parameter BITWDTH = 5;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPADR = 10;
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;

  parameter SDOUT_WIDTH = WIDTH+BITVBNK;

input clk;
input rst;

input prefr;

input pread;
input [BITVBNK-1:0] prdbadr;
input [BITVROW-1:0] prdradr;
output [WIDTH-1:0] pdout;
output [BITPADR-1:0] ppadr;

input pwrite;
input [BITVBNK-1:0] pwrbadr;
input [BITVROW-1:0] pwrradr;
input [WIDTH-1:0] pbwe;
input [WIDTH-1:0] pdin;

input sread1;
input [BITVROW-1:0] srdradr1;
output [SDOUT_WIDTH-1:0] sdout1;
output [WIDTH-1:0] cdout1;

input sread2;
input [BITVROW-1:0] srdradr2;
output [SDOUT_WIDTH-1:0] sdout2;
output [WIDTH-1:0] cdout2;

input swrite;
input [BITVROW-1:0] swrradr;
input [SDOUT_WIDTH-1:0] sdin;
input [WIDTH-1:0] cbwe;
input [WIDTH-1:0] cdin;

output [NUMVBNK-1:0] t1_readA;
output [NUMVBNK-1:0] t1_writeA;
output [NUMVBNK*BITVROW-1:0] t1_addrA;
output [NUMVBNK*WIDTH-1:0] t1_bwA;
output [NUMVBNK*WIDTH-1:0] t1_dinA;
input [NUMVBNK*WIDTH-1:0] t1_doutA;
input [NUMVBNK*BITPADR-1:0] t1_padrA;
output [NUMVBNK-1:0] t1_refrB;

output [2-1:0] t2_writeA;
output [2*BITVROW-1:0] t2_addrA;
output [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_bwA;
output [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA;

output [2-1:0] t2_readB;
output [2*BITVROW-1:0] t2_addrB;
input [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB;

assign t1_readA = pread ? (pread << prdbadr) : 0;
assign t1_writeA = pwrite ? (pwrite << pwrbadr) : 0;

integer t1d_int;
reg [NUMVBNK*BITVROW-1:0] t1_addrA;
always_comb begin
  t1_addrA = {NUMVBNK{pwrradr}};
  if (pread)
    for (t1d_int=0; t1d_int<BITVROW; t1d_int=t1d_int+1)
      t1_addrA[prdbadr*BITVROW+t1d_int] = prdradr[t1d_int];
end

assign t1_bwA = {NUMVBNK{pbwe}};
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
assign ppadr = t1_padrA >> (prdbadr_reg[DRAM_DELAY-1]*BITPADR);

assign t2_writeA = {2{swrite}};
assign t2_addrA = {2{swrradr}};
assign t2_bwA = {2{{SDOUT_WIDTH{1'b1}},cbwe}};
assign t2_dinA = {2{sdin,cdin}};

assign t2_readB = {sread2,sread1};
assign t2_addrB = {srdradr2,srdradr1};

assign sdout1 = t2_doutB >> WIDTH;
assign cdout1 = t2_doutB;
assign sdout2 = t2_doutB >> (SDOUT_WIDTH+2*WIDTH);
assign cdout2 = t2_doutB >> (SDOUT_WIDTH+WIDTH);

endmodule


