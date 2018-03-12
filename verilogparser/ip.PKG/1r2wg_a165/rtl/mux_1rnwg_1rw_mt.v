module mux_1rnwg_1rw_mt (clk, rst,
	                 pread, prdbadr, prdradr, pdout, pdout_fwrd, pdout_serr, pdout_derr, pdout_padr,
                         pwrite, pwrbadr, pwrradr, pdin,
	                 t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA, t1_fwrdA, t1_serrA, t1_derrA, t1_padrA);

  parameter WIDTH   = 32;
  parameter NUMWRPT = 2;

  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMPBNK = 11;
  parameter BITPBNK = 4; 
  parameter BITPADR = 14;

  parameter DRAM_DELAY = 2;

input clk;
input rst;

input pread;
input [BITPBNK-1:0] prdbadr;
input [BITVROW-1:0] prdradr;
output [WIDTH-1:0] pdout;
output pdout_fwrd;
output pdout_serr;
output pdout_derr;
output [BITPADR-1:0] pdout_padr;

input [NUMWRPT-1:0] pwrite;
input [NUMWRPT*BITPBNK-1:0] pwrbadr;
input [NUMWRPT*BITVROW-1:0] pwrradr;
input [NUMWRPT*WIDTH-1:0] pdin;

output [NUMPBNK-1:0] t1_readA;
output [NUMPBNK-1:0] t1_writeA;
output [NUMPBNK*BITVROW-1:0] t1_addrA;
output [NUMPBNK*WIDTH-1:0] t1_dinA;
input [NUMPBNK*WIDTH-1:0] t1_doutA;
input [NUMPBNK-1:0] t1_fwrdA;
input [NUMPBNK-1:0] t1_serrA;
input [NUMPBNK-1:0] t1_derrA;
input [NUMPBNK*(BITPADR-BITPBNK)-1:0] t1_padrA;

reg pwrite_wire [0:NUMWRPT-1];
reg [BITPBNK-1:0] pwrbadr_wire [0:NUMWRPT-1];
reg [BITVROW-1:0] pwrradr_wire [0:NUMWRPT-1];
reg [WIDTH-1:0] pdin_wire [0:NUMWRPT-1];
integer pwr_int;
always_comb
  for (pwr_int=0; pwr_int<NUMWRPT; pwr_int=pwr_int+1) begin
    pwrite_wire[pwr_int] = pwrite >> pwr_int;
    pwrbadr_wire[pwr_int] = pwrbadr >> (pwr_int*BITPBNK);
    pwrradr_wire[pwr_int] = pwrradr >> (pwr_int*BITVROW);
    pdin_wire[pwr_int] = pdin >> (pwr_int*WIDTH);
  end

reg [NUMPBNK-1:0] t1_readA;
reg [NUMPBNK-1:0] t1_writeA;
reg [NUMPBNK*BITVROW-1:0] t1_addrA;
reg [NUMPBNK*WIDTH-1:0] t1_dinA;
integer t1_int;
always_comb begin
  t1_writeA = 0;
  t1_addrA = 0;
  t1_dinA = 0;
  for (t1_int=0; t1_int<NUMWRPT; t1_int=t1_int+1) 
    if (pwrite_wire[t1_int]) begin
      t1_writeA = t1_writeA | (1'b1 << pwrbadr_wire[t1_int]);
      t1_addrA = t1_addrA | (pwrradr_wire[t1_int] << (pwrbadr_wire[t1_int]*BITVROW));
      t1_dinA = t1_dinA | (pdin_wire[t1_int] << (pwrbadr_wire[t1_int]*WIDTH));
    end
  t1_readA = 0;
  if (pread) begin
    t1_readA = t1_readA | (1'b1 << prdbadr);
    t1_addrA = t1_addrA | (prdradr << (prdbadr*BITVROW));
  end
end

reg [BITPBNK-1:0] prdbadr_reg [0:DRAM_DELAY-1];
integer prdd_int;
always @(posedge clk)
  for (prdd_int=0; prdd_int<DRAM_DELAY; prdd_int=prdd_int+1)
    if (prdd_int>0)
      prdbadr_reg[prdd_int] <= prdbadr_reg[prdd_int-1];
    else
      prdbadr_reg[prdd_int] <= prdbadr;

reg [WIDTH-1:0] pdout;
reg pdout_fwrd;
reg pdout_serr;
reg pdout_derr;
reg [BITPADR-BITPBNK-1:0] pdout_padr_temp;
reg [BITPADR-1:0] pdout_padr;
always_comb begin
  pdout = t1_doutA >> (prdbadr_reg[DRAM_DELAY-1]*WIDTH);
  pdout_fwrd = t1_fwrdA >> prdbadr_reg[DRAM_DELAY-1];
  pdout_serr = t1_serrA >> prdbadr_reg[DRAM_DELAY-1];
  pdout_derr = t1_derrA >> prdbadr_reg[DRAM_DELAY-1];
  pdout_padr_temp = t1_padrA >> (prdbadr_reg[DRAM_DELAY-1]*(BITPADR-BITPBNK));
  pdout_padr = {prdbadr_reg[DRAM_DELAY-1],pdout_padr_temp};
end 

endmodule

