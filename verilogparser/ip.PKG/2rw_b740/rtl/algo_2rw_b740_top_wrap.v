module algo_2rw_b740_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 64, parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 1, parameter T1_DELAY = 0,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1,  parameter T1_NUMSROW = 4096, parameter T1_BITSROW = 12, parameter T1_PHYWDTH = 128,
parameter T1_NUMVROW = 256, parameter T1_BITVROW = 8)
(clk, rst, rw_read, rw_write, rw_addr, rw_din, rw_dout, rw_vld, rw_bw, flopout_en, 
 t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_doutA,
 t1_readB, t1_writeB, t1_addrB, t1_dinB, t1_bwB, t1_doutB);

// MEMOIR_TRANSLATE_OFF

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR  = IP_ENAPAR;
  parameter ENAECC  = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter SRAM_DELAY = T1_DELAY;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;      
  parameter PHYWDTH = T1_PHYWDTH;
  parameter BITPADR = BITVBNK+BITSROW+BITWRDS+1;
  parameter NUMRWPT = 2;

  input [NUMRWPT-1:0]                        rw_read;
  input [NUMRWPT-1:0]                        rw_write;
  input [NUMRWPT*BITADDR-1:0]                rw_addr;
  input [NUMRWPT*WIDTH-1:0]                  rw_din;
  input [NUMRWPT*WIDTH-1:0]                  rw_bw;
  output [NUMRWPT-1:0]                       rw_vld;
  output [NUMRWPT*WIDTH-1:0]                 rw_dout;

  input                                      clk, rst;
  input                                      flopout_en;
  
  output                                     t1_readA;
  output                                     t1_writeA;
  output [BITADDR-1:0]                       t1_addrA;
  output [WIDTH-1:0]                         t1_dinA;
  output [WIDTH-1:0]                         t1_bwA;
  input [WIDTH-1:0]                          t1_doutA;

  output                                     t1_readB;
  output                                     t1_writeB;
  output [BITADDR-1:0]                       t1_addrB;
  output [WIDTH-1:0]                         t1_dinB;
  output [WIDTH-1:0]                         t1_bwB;
  input [WIDTH-1:0]                          t1_doutB;

  reg [NUMRWPT-1:0]                       rw_vld;
  reg [NUMRWPT*WIDTH-1:0]                 rw_dout;
  reg                                     t1_readA;
  reg                                     t1_writeA;
  reg [BITADDR-1:0]                       t1_addrA;
  reg [WIDTH-1:0]                         t1_dinA;
  reg [WIDTH-1:0]                         t1_bwA;
  reg                                     t1_readB;
  reg                                     t1_writeB;
  reg [BITADDR-1:0]                       t1_addrB;
  reg [WIDTH-1:0]                         t1_dinB;
  reg [WIDTH-1:0]                         t1_bwB;

  reg [NUMRWPT*WIDTH-1:0]                 rw_dout_tmp;

always_comb begin
  t1_readA = rw_read[0];
  t1_addrA = rw_addr[BITADDR-1:0];
  t1_readB = rw_read[1];
  t1_addrB = rw_addr[2*BITADDR-1:BITADDR];

  rw_dout_tmp = {t1_doutB, t1_doutA};

  t1_writeA = rw_write[0];
  t1_dinA   = rw_din[WIDTH-1:0];
  t1_bwA    = rw_bw[WIDTH-1:0];
  t1_writeB = rw_write[1];
  t1_dinB   = rw_din[2*WIDTH-1:WIDTH];
  t1_bwB    = rw_bw[2*WIDTH-1:WIDTH];
end

generate if (T1_DELAY+FLOPOUT >0 ) begin:fo 
  reg [NUMRWPT-1:0] read_out[0:T1_DELAY+FLOPOUT-1];
  always @(posedge clk) begin:rw_vld_frwd
    read_out[0]  <= rw_read;
    for(integer i=1;i<T1_DELAY+FLOPOUT;i=i+1) begin
      read_out[i]  <= read_out[i-1];
    end
  end
  assign rw_vld = read_out[T1_DELAY+FLOPOUT-1];
end else begin :no_fo
  assign rw_vld = rw_read;
end
endgenerate

generate if(T1_DELAY+FLOPOUT>0) begin : fo_loop
  reg [NUMRWPT*WIDTH-1:0] read_dout [0:T1_DELAY+FLOPOUT-1];
  always @(posedge clk) begin:rw_dout_frwd
    read_dout[0] <= rw_dout_tmp;
    for(integer i=1;i<T1_DELAY+FLOPOUT;i=i+1) begin
      read_dout[i] <= read_dout[i-1];
    end
  end
  assign rw_dout = read_dout[T1_DELAY+FLOPOUT-1];
end else begin :nfo_loop
  assign rw_dout = rw_dout_tmp;
end
endgenerate



/*
  output [NUMVBNK-1:0]               t1_readB;
  output [NUMVBNK-1:0]               t1_writeB;
  output [NUMVBNK*BITSROW-1:0]       t1_addrB;
  output [NUMVBNK*PHYWDTH-1:0]         t1_dinB;
  output [NUMVBNK*PHYWDTH-1:0]         t1_bwB;
  input [NUMVBNK*PHYWDTH-1:0]          t1_doutB;
*/
`ifdef FORMAL
//synopsys translate_off
wire [BITADDR-1:0] select_addr;
wire [IP_BITWIDTH-1:0] select_bit;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < IP_NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < IP_BITWIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_smurf_2rw #(
     .WIDTH       (WIDTH),
     .BITWDTH     (IP_BITWIDTH),
     .NUMRWPT    (NUMRWPT),
     .NUMADDR     (IP_NUMADDR),
     .BITADDR     (IP_BITADDR),
     .SRAM_DELAY  (T1_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(select_addr), .select_bit(select_bit), .*);

ip_top_sva_2_smurf_2rw #(
     .WIDTH (WIDTH),
     .NUMRWPT    (NUMRWPT),
     .NUMADDR     (IP_NUMADDR),
     .BITADDR     (IP_BITADDR))
ip_top_sva_2 (.*);
//synopsys translate_on

`elsif SIM_SVA

genvar sva_int;
// generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin: sva_loop
  wire [IP_BITADDR-1:0] help_addr = sva_int;
  wire [IP_BITWIDTH-1:0] help_bit = sva_int;
ip_top_sva_smurf_2rw #(
     .WIDTH       (WIDTH),
     .BITWDTH     (IP_BITWIDTH),
     .NUMRWPT    (NUMRWPT),
     .NUMADDR     (IP_NUMADDR),
     .BITADDR     (IP_BITADDR),
     .SRAM_DELAY  (T1_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

ip_top_sva_2_smurf_2rw #(
     .WIDTH       (WIDTH),
     .NUMRWPT    (NUMRWPT),
     .NUMADDR     (IP_NUMADDR),
     .BITADDR     (IP_BITADDR),
     .FLOPOUT     (FLOPOUT))
ip_top_sva_2 (.*);

`endif

endmodule    //algo_2rw_b40_top_wrap
