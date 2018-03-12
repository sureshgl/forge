module algo_2r2w_b752_top_wrap(rst,clk, flopout_en, read, rd_adr, rd_dout, rd_vld, write, wr_adr, din, bw, 
  t1_readC, t1_addrC, t1_doutC, 
  t1_readD, t1_addrD, t1_doutD, 
  t1_writeA, t1_addrA, t1_dinA, t1_bwA,
  t1_writeB, t1_addrB, t1_dinB, t1_bwB

);
//Disclaimer: Dumbest algo ever.
//NO Sub packing, No Superpacking, No Banking.
parameter IP_WIDTH = 15;
parameter IP_BITWIDTH = 4;
parameter IP_NUMADDR = 256;
parameter IP_BITADDR = 8;
parameter IP_NUMVBNK = 1;
parameter IP_BITVBNK = 0;
parameter IP_SECCBITS = 4;
parameter IP_SECCDWIDTH = 1;
parameter IP_BITPBNK = 0;
parameter FLOPIN = 0;
parameter FLOPOUT = 0;
parameter IP_ENAECC = 0;
parameter IP_DECCBITS = 6;
parameter IP_ENAPAR = 0;
parameter FLOPMEM = 0;
parameter FLOPCMD = 0;
parameter T1_WIDTH = 15;
parameter T1_PHYWDTH = 15;
parameter T1_NUMVBNK = 1;
parameter T1_BITVBNK = 0;
parameter T1_DELAY = 0;
parameter T1_NUMVROW = 256;
parameter T1_BITVROW = 8;
parameter T1_BITWSPF = 0;
parameter T1_NUMWRDS = 1;
parameter T1_BITWRDS = 0;
parameter T1_NUMSROW = 256;
parameter T1_BITSROW = 8;
parameter NUMWRPRT = 2;
parameter NUMRDPRT = 2;
parameter BITADDR = IP_BITADDR;
parameter WIDTH = IP_WIDTH;

input                             rst,clk;

input                             flopout_en;

input  [NUMRDPRT-1:0]             read;
input  [NUMRDPRT*BITADDR-1:0]     rd_adr;
output [NUMRDPRT*WIDTH-1:0]       rd_dout;
output [NUMRDPRT-1:0]             rd_vld;
input  [NUMWRPRT-1:0]             write;
input  [NUMWRPRT*BITADDR-1:0]     wr_adr;
input  [NUMWRPRT*WIDTH-1:0]       din;
input  [NUMWRPRT*WIDTH-1:0]       bw;

output                            t1_readC;
output [BITADDR-1:0]              t1_addrC;
input  [WIDTH-1:0]                t1_doutC;
output                            t1_readD;
output [BITADDR-1:0]              t1_addrD;
input  [WIDTH-1:0]                t1_doutD;

output                            t1_writeA; 
output [BITADDR-1:0]              t1_addrA; 
output [WIDTH-1:0]                t1_dinA; 
output [WIDTH-1:0]                t1_bwA;
output                            t1_writeB; 
output [BITADDR-1:0]              t1_addrB; 
output [WIDTH-1:0]                t1_dinB; 
output [WIDTH-1:0]                t1_bwB;

reg [NUMRDPRT*WIDTH-1:0]       rd_dout_tmp;

reg [NUMRDPRT*WIDTH-1:0]       rd_dout;
reg [NUMRDPRT-1:0]             rd_vld;

reg                            t1_readC;
reg [BITADDR-1:0]              t1_addrC;
reg                            t1_readD;
reg [BITADDR-1:0]              t1_addrD;

reg                            t1_writeA; 
reg [BITADDR-1:0]              t1_addrA; 
reg [WIDTH-1:0]                t1_dinA; 
reg [WIDTH-1:0]                t1_bwA;

reg                            t1_writeB; 
reg [BITADDR-1:0]              t1_addrB; 
reg [WIDTH-1:0]                t1_dinB; 
reg [WIDTH-1:0]                t1_bwB;

always_comb begin
  t1_readC = read[0];
  t1_addrC = rd_adr[BITADDR-1:0];
  t1_readD = read[1];
  t1_addrD = rd_adr[BITADDR*2-1:BITADDR];

  rd_dout_tmp = {t1_doutD, t1_doutC};

  t1_writeA = write[0];
  t1_addrA  = wr_adr[BITADDR-1:0];
  t1_dinA   = din[WIDTH-1:0];
  t1_bwA    = bw[WIDTH-1:0];
  t1_writeB = write[1];
  t1_addrB  = wr_adr[2*BITADDR-1:BITADDR];
  t1_dinB   = din[2*WIDTH-1:WIDTH];
  t1_bwB    = bw[2*WIDTH-1:WIDTH];
end

generate if (T1_DELAY+FLOPOUT >0 ) begin:fo 
  reg [NUMRDPRT-1:0] read_out[0:T1_DELAY+FLOPOUT-1];
  always @(posedge clk) begin:rd_vld_frwd
    read_out[0]  <= read;
    for(integer i=1;i<T1_DELAY+FLOPOUT;i=i+1) begin
      read_out[i]  <= read_out[i-1];
    end
  end
  assign rd_vld = read_out[T1_DELAY+FLOPOUT-1];
end else begin :no_fo
  assign rd_vld = read;
end
endgenerate

generate if(FLOPOUT>0) begin : fo_loop
  reg [NUMRDPRT*WIDTH-1:0] read_dout [0:FLOPOUT-1];
  always @(posedge clk) begin:rd_dout_frwd
    read_dout[0] <= rd_dout_tmp;
    for(integer i=1;i<FLOPOUT;i=i+1) begin
      read_dout[i] <= read_dout[i-1];
    end
  end
  assign rd_dout = read_dout[FLOPOUT-1];
end else begin :nfo_loop
  assign rd_dout = rd_dout_tmp;
end
endgenerate

`ifdef FORMAL
//synopsys translate_off
wire [BITADDR-1:0] select_addr;
wire [IP_BITWIDTH-1:0] select_bit;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < IP_NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < IP_BITWIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_smurf_2r2w #(
     .WIDTH       (WIDTH),
     .BITWDTH     (IP_BITWIDTH),
     .NUMRDPRT    (NUMRDPRT),
     .NUMWRPRT    (NUMWRPRT),
     .NUMADDR     (IP_NUMADDR),
     .BITADDR     (IP_BITADDR),
     .SRAM_DELAY  (T1_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(select_addr), .select_bit(select_bit), .*);

ip_top_sva_2_smurf_2r2w #(
     .NUMRDPRT    (NUMRDPRT),
     .NUMWRPRT    (NUMWRPRT),
     .NUMADDR     (IP_NUMADDR),
     .BITADDR     (IP_BITADDR))
ip_top_sva_2 (.*);
//synopsys translate_on

`elsif SIM_SVA

genvar sva_int;
// generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin: sva_loop
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [IP_BITWIDTH-1:0] help_bit = sva_int;
ip_top_sva_smurf_2r2w #(
     .WIDTH       (WIDTH),
     .BITWDTH     (IP_BITWIDTH),
     .NUMRDPRT    (NUMRDPRT),
     .NUMWRPRT    (NUMWRPRT),
     .NUMADDR     (IP_NUMADDR),
     .BITADDR     (IP_BITADDR),
     .SRAM_DELAY  (T1_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

ip_top_sva_2_smurf_2r2w #(
     .WIDTH       (WIDTH),
     .NUMRDPRT    (NUMRDPRT),
     .NUMWRPRT    (NUMWRPRT),
     .NUMADDR     (IP_NUMADDR),
     .BITADDR     (IP_BITADDR),
     .FLOPOUT     (FLOPOUT))
ip_top_sva_2 (.*);

`endif
endmodule
