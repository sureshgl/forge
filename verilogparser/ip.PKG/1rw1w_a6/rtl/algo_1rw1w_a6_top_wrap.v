
module algo_1rw1w_a6_top_wrap 
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 16, parameter T1_BITVBNK = 4, parameter T1_DELAY = 1, parameter T1_NUMVROW = 512, parameter T1_BITVROW = 9,
parameter T2_WIDTH = 15, parameter T2_NUMVBNK = 2, parameter T2_BITVBNK = 1, parameter T2_DELAY = 1, parameter T2_NUMVROW = 512, parameter T2_BITVROW = 9,
parameter T3_WIDTH = 32, parameter T3_NUMVBNK = 2, parameter T3_BITVBNK = 1, parameter T3_DELAY = 1, parameter T3_NUMVROW = 512, parameter T3_BITVROW = 9)
			(clk, rst, ready,
                               write, wr_adr, din, rw_read, rw_write, rw_addr, rw_din,  rw_vld, rw_dout, rw_serr,
                              t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA,
                              t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
                              t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB);
							  
// MEMOIR_TRANSLATE_OFF

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = T1_NUMVBNK;
  parameter BITVBNK = T1_BITVBNK;
  parameter SRAM_DELAY = T1_DELAY;
  parameter ECCDWIDTH = IP_SECCDWIDTH;
  parameter ECCBITS = IP_SECCBITS;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input                          write;
  input [BITADDR-1:0]            wr_adr;
  input [WIDTH-1:0]              din;
  
  input [1-1:0]                  rw_read;
  input [1-1:0]                  rw_write;
  input [1*BITADDR-1:0]          rw_addr;
  input [1*WIDTH -1 :0]          rw_din;
  output [1-1:0]                 rw_vld;
  output [1-1:0]                 rw_serr;
  output [1*WIDTH-1:0]           rw_dout;

  output                         ready;
  input                          clk, rst;

  output [NUMVBNK-1:0] t1_readA;
  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMVBNK*WIDTH-1:0] t1_dinA;
  output [NUMVBNK*WIDTH-1:0] t1_doutA;

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
  
  assign rw_serr = 1'b0;
  
  
  algo_1r1wor2w_1rw_top 
  							  #(.WIDTH(WIDTH),
							  .BITWDTH(BITWDTH),
							  .NUMADDR(NUMADDR),
							  .BITADDR(BITADDR),
							  .NUMVROW(NUMVROW),
							  .BITVROW(BITVROW),
							  .NUMVBNK(NUMVBNK),
							  .BITVBNK(BITVBNK),
							  .SRAM_DELAY(SRAM_DELAY),
							  .ECCDWIDTH(ECCDWIDTH),
							  .ECCBITS(ECCBITS))
  algo_top 
							(.clk(clk), .rst(rst), .ready(ready),
                              .read(rw_read), .write({write, rw_write}), .addr({wr_adr, rw_addr}), .din({din, rw_din}), .rd_vld(rw_vld), .rd_dout(rw_dout),
                              .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA),
                              .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
                              .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB));
							  
// MEMOIR_TRANSLATE_ON

endmodule  //algo_1r1wor2w_1rw_top_wrap
