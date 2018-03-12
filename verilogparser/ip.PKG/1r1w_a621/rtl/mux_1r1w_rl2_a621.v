module mux_1r1w_rl2_a621 (clk, rst,
		          pwrite, pwrbadr, pwrradr, pdin,
		          pread, prdbadr, prdradr, pdout, pfwrd, ppadr,
		          swrite, swrradr, sdin,
		          sread1, srdradr1, sdout1, sfwrd1, spadr1,
		          sread2, srdradr2, sdout2, sfwrd2, spadr2,
		          t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_padrB,
		          t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_padrB);

  parameter WIDTH   = 32;

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

input pread;
input [BITVBNK-1:0] prdbadr;
input [BITVROW-1:0] prdradr;
output [WIDTH-1:0] pdout;
output pfwrd;
output [BITPADR-1:0] ppadr;

input pwrite;
input [BITVBNK-1:0] pwrbadr;
input [BITVROW-1:0] pwrradr;
input [WIDTH-1:0] pdin;

input sread1;
input [BITVROW-1:0] srdradr1;
output [SDOUT_WIDTH+WIDTH-1:0] sdout1;
output sfwrd1;
output [BITPADR-1:0] spadr1;

input sread2;
input [BITVROW-1:0] srdradr2;
output [SDOUT_WIDTH+WIDTH-1:0] sdout2;
output sfwrd2;
output [BITPADR-1:0] spadr2;

input swrite;
input [BITVROW-1:0] swrradr;
input [SDOUT_WIDTH+WIDTH-1:0] sdin;

output [NUMVBNK-1:0] t1_writeA;
output [NUMVBNK*BITVROW-1:0] t1_addrA;
output [NUMVBNK*WIDTH-1:0] t1_dinA;

output [NUMVBNK-1:0] t1_readB;
output [NUMVBNK*BITVROW-1:0] t1_addrB;
input [NUMVBNK*WIDTH-1:0] t1_doutB;
input [NUMVBNK-1:0] t1_fwrdB;
input [NUMVBNK*BITPADR-1:0] t1_padrB;

output [2-1:0] t2_writeA;
output [2*BITVROW-1:0] t2_addrA;
output [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA;

output [2-1:0] t2_readB;
output [2*BITVROW-1:0] t2_addrB;
input [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB;
input [2-1:0] t2_fwrdB;
input [2*BITPADR-1:0] t2_padrB;

reg [NUMVBNK-1:0] t1_writeA;
reg [NUMVBNK*BITVROW-1:0] t1_addrA;
reg [NUMVBNK*WIDTH-1:0] t1_dinA;
reg [NUMVBNK-1:0] t1_readB;
reg [NUMVBNK*BITVROW-1:0] t1_addrB;
integer t1b_int, t1w_int;
always_comb
  for (t1b_int=0; t1b_int<NUMVBNK; t1b_int=t1b_int+1) begin
    t1_writeA[t1b_int] = pwrite ? (t1b_int==pwrbadr) : 0;
    for (t1w_int=0; t1w_int<BITVROW; t1w_int=t1w_int+1)
      t1_addrA[t1b_int*BITVROW+t1w_int] = pwrradr[t1w_int];
    for (t1w_int=0; t1w_int<WIDTH; t1w_int=t1w_int+1)
      t1_dinA[t1b_int*WIDTH+t1w_int] = pdin[t1w_int];
    t1_readB[t1b_int] = pread ? (t1b_int==prdbadr) : 0;
    for (t1w_int=0; t1w_int<BITVROW; t1w_int=t1w_int+1)
      t1_addrB[t1b_int*BITVROW+t1w_int] = prdradr[t1w_int];
  end

integer prd_int;
reg [BITVBNK-1:0] prdbadr_reg [0:DRAM_DELAY-1];
always @(posedge clk)
  for (prd_int=0; prd_int<DRAM_DELAY; prd_int=prd_int+1)
    if (prd_int>0)
      prdbadr_reg[prd_int] <= prdbadr_reg[prd_int-1];
    else
      prdbadr_reg[prd_int] <= prdbadr;

reg [WIDTH-1:0] pdout;
reg pfwrd;
reg [BITPADR-1:0] ppadr;
integer pdb_int, pdw_int;
always_comb begin
  pdout = 0;
  ppadr = 0;
  pfwrd = 0;
  for (pdb_int=0; pdb_int<NUMVBNK; pdb_int=pdb_int+1)
    if (pdb_int==prdbadr_reg[DRAM_DELAY-1]) begin
      for (pdw_int=0; pdw_int<WIDTH; pdw_int=pdw_int+1)
        pdout[pdw_int] = t1_doutB[pdb_int*WIDTH+pdw_int];
      pfwrd = t1_fwrdB[pdb_int];
      for (pdw_int=0; pdw_int<BITPADR; pdw_int=pdw_int+1)
        ppadr[pdw_int] = t1_padrB[pdb_int*BITPADR+pdw_int];
    end
end

assign t2_writeA = {2{swrite}};
assign t2_addrA = {2{swrradr}};
assign t2_dinA = {2{sdin}};

assign t2_readB = {sread2,sread1};
assign t2_addrB = {srdradr2,srdradr1};

assign sdout1 = t2_doutB;
assign sfwrd1 = t2_fwrdB;
assign spadr1 = t2_padrB;
assign sdout2 = t2_doutB[2*(SDOUT_WIDTH+WIDTH)-1:SDOUT_WIDTH+WIDTH];
assign sfwrd2 = t2_fwrdB[1];
assign spadr2 = t2_padrB[2*BITPADR-1:BITPADR];

endmodule


