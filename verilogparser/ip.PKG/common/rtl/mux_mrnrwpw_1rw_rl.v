module mux_mrnrwpw_1rw_rl (clk, rst,
                           pread, prdbadr, prdradr, pdout, pdout_fwrd, pdout_serr, pdout_derr, pdout_padr,
                           prefr, pwrite, pwrbadr, pwrradr, pdin,
                           swrite, swrradr, sdin, sread, srdradr, sdout,
                           sdout_fwrd, sdout_serr, sdout_derr, sdout_padr,
           	           cwrite, cwrradr, cdin, cread, crdradr, cdout,
                           cdout_fwrd, cdout_serr, cdout_derr, cdout_padr,
                           t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA, t1_fwrdA, t1_serrA, t1_derrA, t1_padrA, t1_refrB,
                           t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_serrB, t2_derrB, t2_padrB,
                           t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB, t3_fwrdB, t3_serrB, t3_derrB, t3_padrB);

  parameter WIDTH   = 32;
  parameter NUMRDPT = 1;
  parameter NUMRWPT = 1;
  parameter NUMWRPT = 2;

  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter ECCBITS = 4;
  parameter BITPADR = 14;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;
  parameter NUMCASH = NUMRDPT+NUMRWPT+NUMWRPT-1;
  
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;

input clk;
input rst;

input                         prefr;

input [(NUMRDPT+NUMRWPT)-1:0] pread;
input [(NUMRDPT+NUMRWPT)*BITVBNK-1:0] prdbadr;
input [(NUMRDPT+NUMRWPT)*BITVROW-1:0] prdradr;
output [(NUMRDPT+NUMRWPT)*WIDTH-1:0] pdout;
output [(NUMRDPT+NUMRWPT)-1:0] pdout_fwrd;
output [(NUMRDPT+NUMRWPT)-1:0] pdout_serr;
output [(NUMRDPT+NUMRWPT)-1:0] pdout_derr;
output [(NUMRDPT+NUMRWPT)*BITPADR-1:0] pdout_padr;

input [(NUMRWPT+NUMWRPT)-1:0] pwrite;
input [(NUMRWPT+NUMWRPT)*BITVBNK-1:0] pwrbadr;
input [(NUMRWPT+NUMWRPT)*BITVROW-1:0] pwrradr;
input [(NUMRWPT+NUMWRPT)*WIDTH-1:0] pdin;

input [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] swrite;
input [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW-1:0] swrradr;
input [NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] sdin;

input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] sread;
input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] srdradr;
output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] sdout;
output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] sdout_fwrd;
output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] sdout_serr;
output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] sdout_derr;
output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR-1:0] sdout_padr;

input [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] cwrite;
input [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW-1:0] cwrradr;
input [NUMCASH*(NUMRWPT+NUMWRPT)*WIDTH-1:0] cdin;

input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] cread;
input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] crdradr;
output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] cdout;
output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] cdout_fwrd;
output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] cdout_serr;
output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] cdout_derr;
output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR-1:0] cdout_padr;

output [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_readA;
output [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_writeA;
output [(NUMRDPT+NUMRWPT)*NUMVBNK*BITVROW-1:0] t1_addrA;
output [(NUMRDPT+NUMRWPT)*NUMVBNK*WIDTH-1:0] t1_dinA;
input [(NUMRDPT+NUMRWPT)*NUMVBNK*WIDTH-1:0] t1_doutA;
input [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_fwrdA;
input [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_serrA;
input [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_derrA;
input [(NUMRDPT+NUMRWPT)*NUMVBNK*BITPADR-1:0] t1_padrA;
output [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_refrB;

output [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t2_writeA;
output [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW-1:0] t2_addrA;
output [NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_dinA;

output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB;
output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] t2_addrB;
input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_doutB;
input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_fwrdB;
input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_serrB;
input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_derrB;
input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR-1:0] t2_padrB;

output [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t3_writeA;
output [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW-1:0] t3_addrA;
output [NUMCASH*(NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_dinA;

output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB;
output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] t3_addrB;
input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_doutB;
input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_fwrdB;
input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_serrB;
input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_derrB;
input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR-1:0] t3_padrB;

reg pread_wire [0:NUMRDPT+NUMRWPT-1];
reg [BITVBNK-1:0] prdbadr_wire [0:NUMRDPT+NUMRWPT-1];
reg [BITVROW-1:0] prdradr_wire [0:NUMRDPT+NUMRWPT-1];
integer prd_int;
always_comb
  for (prd_int=0; prd_int<NUMRDPT+NUMRWPT; prd_int=prd_int+1) begin
    pread_wire[prd_int] = pread >> prd_int;
    prdbadr_wire[prd_int] = prdbadr >> (prd_int*BITVBNK);
    prdradr_wire[prd_int] = prdradr >> (prd_int*BITVROW);
  end

reg pwrite_wire [0:NUMRWPT+NUMWRPT-1];
reg [BITVBNK-1:0] pwrbadr_wire [0:NUMRWPT+NUMWRPT-1];
reg [BITVROW-1:0] pwrradr_wire [0:NUMRWPT+NUMWRPT-1];
reg [WIDTH-1:0] pdin_wire [0:NUMRWPT+NUMWRPT-1];
integer pwr_int;
always_comb
  for (pwr_int=0; pwr_int<NUMRWPT+NUMWRPT; pwr_int=pwr_int+1) begin
    pwrite_wire[pwr_int] = pwrite >> pwr_int;
    pwrbadr_wire[pwr_int] = pwrbadr >> (pwr_int*BITVBNK);
    pwrradr_wire[pwr_int] = pwrradr >> (pwr_int*BITVROW);
    pdin_wire[pwr_int] = pdin >> (pwr_int*WIDTH);
  end

reg [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_readA;
reg [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_writeA;
reg [(NUMRDPT+NUMRWPT)*NUMVBNK*BITVROW-1:0] t1_addrA;
reg [(NUMRDPT+NUMRWPT)*NUMVBNK*WIDTH-1:0] t1_dinA;
integer t1_int, t1r_int, t1b_int, t1d_int;
always_comb begin
  t1_readA = 0;
  t1_writeA = 0;
  t1_addrA = 0;
  t1_dinA = 0;
  for (t1r_int=0; t1r_int<NUMRDPT+NUMRWPT; t1r_int=t1r_int+1)
    for (t1b_int=0; t1b_int<NUMVBNK; t1b_int=t1b_int+1)
      if (pread_wire[t1r_int] && (t1b_int==prdbadr_wire[t1r_int])) begin
        t1_readA[t1b_int*(NUMRDPT+NUMRWPT)+t1r_int] = 1'b1;
        for (t1d_int=0; t1d_int<BITVROW; t1d_int=t1d_int+1)
          t1_addrA[(t1b_int*(NUMRDPT+NUMRWPT)+t1r_int)*BITVROW+t1d_int] = prdradr_wire[t1r_int][t1d_int];
      end
  for (t1_int=0; t1_int<NUMRWPT+NUMWRPT; t1_int=t1_int+1)
    for (t1r_int=0; t1r_int<NUMRDPT+NUMRWPT; t1r_int=t1r_int+1)
      for (t1b_int=0; t1b_int<NUMVBNK; t1b_int=t1b_int+1)
        if (pwrite_wire[t1_int] && (t1b_int==pwrbadr_wire[t1_int])) begin
          t1_writeA[t1b_int*(NUMRDPT+NUMRWPT)+t1r_int] = 1'b1;
          for (t1d_int=0; t1d_int<BITVROW; t1d_int=t1d_int+1)
            t1_addrA[(t1b_int*(NUMRDPT+NUMRWPT)+t1r_int)*BITVROW+t1d_int] = pwrradr_wire[t1_int][t1d_int];
          for (t1d_int=0; t1d_int<WIDTH; t1d_int=t1d_int+1)
            t1_dinA[(t1b_int*(NUMRDPT+NUMRWPT)+t1r_int)*WIDTH+t1d_int] = pdin_wire[t1_int][t1d_int];
        end
end

assign t1_refrB = {(NUMRDPT+NUMRWPT)*NUMVBNK{prefr}};

reg [BITVBNK-1:0] prdbadr_reg [0:NUMRDPT+NUMRWPT-1][0:DRAM_DELAY-1];
integer prdp_int, prdd_int;
always @(posedge clk)
  for (prdp_int=0; prdp_int<NUMRDPT+NUMRWPT; prdp_int=prdp_int+1)
    for (prdd_int=0; prdd_int<DRAM_DELAY; prdd_int=prdd_int+1)
      if (prdd_int>0)
        prdbadr_reg[prdp_int][prdd_int] <= prdbadr_reg[prdp_int][prdd_int-1];
      else
        prdbadr_reg[prdp_int][prdd_int] <= prdbadr_wire[prdp_int];

reg [(NUMRDPT+NUMRWPT)*WIDTH-1:0] pdout;
reg [NUMRDPT+NUMRWPT-1:0] pdout_fwrd;
reg [NUMRDPT+NUMRWPT-1:0] pdout_serr;
reg [NUMRDPT+NUMRWPT-1:0] pdout_derr;
reg [(NUMRDPT+NUMRWPT)*BITPADR-1:0] pdout_padr;
integer pdo_int, pdod_int;
always_comb
  for (pdo_int=0; pdo_int<NUMRDPT+NUMRWPT; pdo_int=pdo_int+1) begin
    for (pdod_int=0; pdod_int<WIDTH; pdod_int=pdod_int+1)
      pdout[pdo_int*WIDTH+pdod_int] = t1_doutA[(prdbadr_reg[pdo_int][DRAM_DELAY-1]*(NUMRDPT+NUMRWPT)+pdo_int)*WIDTH+pdod_int];
    pdout_fwrd[pdo_int] = t1_fwrdA[prdbadr_reg[pdo_int][DRAM_DELAY-1]*(NUMRDPT+NUMRWPT)+pdo_int];
    pdout_serr[pdo_int] = t1_serrA[prdbadr_reg[pdo_int][DRAM_DELAY-1]*(NUMRDPT+NUMRWPT)+pdo_int];
    pdout_derr[pdo_int] = t1_derrA[prdbadr_reg[pdo_int][DRAM_DELAY-1]*(NUMRDPT+NUMRWPT)+pdo_int];
    for (pdod_int=0; pdod_int<BITPADR; pdod_int=pdod_int+1)
      pdout_padr[pdo_int*BITPADR+pdod_int] = t1_padrA[(prdbadr_reg[pdo_int][DRAM_DELAY-1]*(NUMRDPT+NUMRWPT)+pdo_int)*BITPADR+pdod_int];
  end

assign t2_writeA = swrite;
assign t2_addrA = swrradr;
assign t2_dinA = sdin;

assign t2_readB = sread;
assign t2_addrB = srdradr;

assign sdout = t2_doutB;
assign sdout_fwrd = t2_fwrdB;
assign sdout_serr = t2_serrB;
assign sdout_derr = t2_derrB;
assign sdout_padr = t2_padrB;

assign t3_writeA = cwrite;
assign t3_addrA = cwrradr;
assign t3_dinA = cdin;

assign t3_readB = cread;
assign t3_addrB = crdradr;

assign cdout = t3_doutB;
assign cdout_fwrd = t3_fwrdB;
assign cdout_serr = t3_serrB;
assign cdout_derr = t3_derrB;
assign cdout_padr = t3_padrB;

endmodule

