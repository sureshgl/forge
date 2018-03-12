module mux_2rw_2ror1w_a56 (clk, rst,
                           prefr,
	                   pread1, prdbadr1, prdradr1, pdout1, pdout1_fwrd, pdout1_serr, pdout1_derr, pdout1_padr,
	                   pread2, prdbadr2, prdradr2, pdout2, pdout2_fwrd, pdout2_serr, pdout2_derr, pdout2_padr,
           	           pwrite1, pwrbadr1, pwrradr1, pdin1,
           	           pwrite2, pwrbadr2, pwrradr2, pdin2,
           	           sread1, srdradr1, sdout1,
           	           sread2, srdradr2, sdout2,
           	           swrite, swrradr, sdin,
	                   cread1, crdradr1, cdout1, cdout1_fwrd, cdout1_serr, cdout1_derr, cdout1_padr,
	                   cread2, crdradr2, cdout2, cdout2_fwrd, cdout2_serr, cdout2_derr, cdout2_padr,
	                   cwrite, cwrradr, cdin,
	                   t1_writeA, t1_addrA, t1_dinA,
                           t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                           t1_readC, t1_addrC, t1_doutC, t1_fwrdC, t1_serrC, t1_derrC, t1_padrC,
                           t1_refrD,
	                   t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
	                   t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB, t3_fwrdB, t3_serrB, t3_derrB, t3_padrB);

  parameter WIDTH   = 32;

  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPADR = 14;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;

  parameter SDOUT_WIDTH = BITVBNK+1;
  
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;

input clk;
input rst;

input prefr;

input pread1;
input [BITVBNK-1:0] prdbadr1;
input [BITVROW-1:0] prdradr1;
output [WIDTH-1:0] pdout1;
output pdout1_fwrd;
output pdout1_serr;
output pdout1_derr;
output [BITPADR-1:0] pdout1_padr;

input pread2;
input [BITVBNK-1:0] prdbadr2;
input [BITVROW-1:0] prdradr2;
output [WIDTH-1:0] pdout2;
output pdout2_fwrd;
output pdout2_serr;
output pdout2_derr;
output [BITPADR-1:0] pdout2_padr;

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
output cdout1_fwrd;
output cdout1_serr;
output cdout1_derr;
output [BITPADR-1:0] cdout1_padr;

input cread2;
input [BITVROW-1:0] crdradr2;
output [WIDTH-1:0] cdout2;
output cdout2_fwrd;
output cdout2_serr;
output cdout2_derr;
output [BITPADR-1:0] cdout2_padr;

input cwrite;
input [BITVROW-1:0] cwrradr;
input [WIDTH-1:0] cdin;

output [NUMVBNK-1:0] t1_writeA;
output [NUMVBNK*BITVROW-1:0] t1_addrA;
output [NUMVBNK*WIDTH-1:0] t1_dinA;

output [NUMVBNK-1:0] t1_readB;
output [NUMVBNK*BITVROW-1:0] t1_addrB;
input [NUMVBNK*WIDTH-1:0] t1_doutB;
input [NUMVBNK-1:0] t1_fwrdB;
input [NUMVBNK-1:0] t1_serrB;
input [NUMVBNK-1:0] t1_derrB;
input [NUMVBNK*BITPADR-1:0] t1_padrB;

output [NUMVBNK-1:0] t1_readC;
output [NUMVBNK*BITVROW-1:0] t1_addrC;
input [NUMVBNK*WIDTH-1:0] t1_doutC;
input [NUMVBNK-1:0] t1_fwrdC;
input [NUMVBNK-1:0] t1_serrC;
input [NUMVBNK-1:0] t1_derrC;
input [NUMVBNK*BITPADR-1:0] t1_padrC;

output [NUMVBNK-1:0] t1_refrD;

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
input [2-1:0] t3_fwrdB;
input [2-1:0] t3_serrB;
input [2-1:0] t3_derrB;
input [2*BITPADR-1:0] t3_padrB;

assign t1_writeA = (pwrite1 ? (pwrite1 << pwrbadr1) : 0) | (pwrite2 ? (pwrite2 << pwrbadr2) : 0);

reg [NUMVBNK*BITVROW-1:0] t1_addrA;
reg [NUMVBNK*WIDTH-1:0] t1_dinA;
integer t1_A_int;
always_comb begin
  t1_addrA = 0;
  t1_dinA = 0;
  for (t1_A_int=0; t1_A_int<NUMVBNK; t1_A_int=t1_A_int+1)
    if (pwrite2 && (t1_A_int==pwrbadr2)) begin
      t1_addrA = t1_addrA | (pwrradr2 << (t1_A_int*BITVROW));
      t1_dinA = t1_dinA | (pdin2 << (t1_A_int*WIDTH));
    end else begin
      t1_addrA = t1_addrA | (pwrradr1 << (t1_A_int*BITVROW));
      t1_dinA = t1_dinA | (pdin1 << (t1_A_int*WIDTH));
    end
end

assign t1_readB = pread1 ? (pread1 << prdbadr1) : 0;
assign t1_addrB = {NUMVBNK{prdradr1}}; 

assign t1_readC = pread2 ? (pread2 << prdbadr2) : 0;
assign t1_addrC = {NUMVBNK{prdradr2}}; 

assign t1_refrD = {NUMVBNK{prefr}};

reg [BITVBNK-1:0] prdbadr1_reg [0:DRAM_DELAY-1];
reg [BITVBNK-1:0] prdbadr2_reg [0:DRAM_DELAY-1];
integer prd_int;
always @(posedge clk)
  for (prd_int=0; prd_int<DRAM_DELAY; prd_int=prd_int+1)
    if (prd_int>0) begin
      prdbadr1_reg[prd_int] <= prdbadr1_reg[prd_int-1];
      prdbadr2_reg[prd_int] <= prdbadr2_reg[prd_int-1];
    end else begin
      prdbadr1_reg[prd_int] <= prdbadr1;
      prdbadr2_reg[prd_int] <= prdbadr2;
    end

assign pdout1 = t1_doutB >> (prdbadr1_reg[DRAM_DELAY-1]*WIDTH);
assign pdout1_fwrd = t1_fwrdB >> prdbadr1_reg[DRAM_DELAY-1];
assign pdout1_serr = t1_serrB >> prdbadr1_reg[DRAM_DELAY-1];
assign pdout1_derr = t1_derrB >> prdbadr1_reg[DRAM_DELAY-1];
assign pdout1_padr = t1_padrB >> (prdbadr1_reg[DRAM_DELAY-1]*BITPADR);
assign pdout2 = t1_doutC >> (prdbadr2_reg[DRAM_DELAY-1]*WIDTH);
assign pdout2_fwrd = t1_fwrdC >> prdbadr2_reg[DRAM_DELAY-1];
assign pdout2_serr = t1_serrC >> prdbadr2_reg[DRAM_DELAY-1];
assign pdout2_derr = t1_derrC >> prdbadr2_reg[DRAM_DELAY-1];
assign pdout2_padr = t1_padrC >> (prdbadr2_reg[DRAM_DELAY-1]*BITPADR);

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
assign cdout1_fwrd = t3_fwrdB;
assign cdout2_fwrd = t3_fwrdB >> 1;
assign cdout1_serr = t3_serrB;
assign cdout2_serr = t3_serrB >> 1;
assign cdout1_derr = t3_derrB;
assign cdout2_derr = t3_derrB >> 1;
assign cdout1_padr = t3_padrB;
assign cdout2_padr = t3_padrB >> BITPADR;

endmodule

