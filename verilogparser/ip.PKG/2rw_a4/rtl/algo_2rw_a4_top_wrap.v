module algo_2rw_a4_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 8, parameter T1_BITVBNK = 3, parameter T1_DELAY = 1, parameter T1_NUMVROW = 1024, parameter T1_BITVROW = 10, 
parameter T2_WIDTH = 12, parameter T2_NUMVBNK = 2, parameter T2_BITVBNK = 1, parameter T2_DELAY = 1, parameter T2_NUMVROW = 1024, parameter T2_BITVROW = 10,
parameter T3_WIDTH = 32, parameter T3_NUMVBNK = 2, parameter T3_BITVBNK = 1, parameter T3_DELAY = 1, parameter T3_NUMVROW = 1024, parameter T3_BITVROW = 10,

parameter T1_IP_WIDTH = 32, parameter T1_IP_BITWIDTH = 5, parameter T1_IP_NUMADDR = 1024, parameter T1_IP_BITADDR = 10, parameter T1_IP_NUMVBNK = 2, parameter T1_IP_BITVBNK = 1, parameter T1_IP_ECCBITS = 3, parameter T1_IP_ECCDWIDTH = 2,
parameter T1_T1_WIDTH = 32, parameter T1_T1_NUMVBNK = 2, parameter T1_T1_BITVBNK = 1, parameter T1_T1_DELAY = 1, parameter T1_T1_NUMVROW = 512, parameter T1_T1_BITVROW = 9, 
parameter T1_T2_WIDTH = 32, parameter T1_T2_NUMVBNK = 1, parameter T1_T2_BITVBNK = 1, parameter T1_T2_DELAY = 1, parameter T1_T2_NUMVROW = 512, parameter T1_T2_BITVROW = 9
)
		(clk, rst, ready,
		 rw_read, rw_write, rw_addr, rw_din, rw_vld, rw_serr, rw_dout,
		 t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA,
		 t2_readA, t2_writeA, t2_addrA, t2_dinA, t2_doutA,
		 t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
		 t4_writeA, t4_addrA, t4_dinA, t4_readB, t4_addrB, t4_doutB);
		 
// MEMOIR_TRANSLATE_OFF

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW1 = T1_NUMVROW;
  parameter BITVROW1 = T1_BITVROW;
  parameter NUMVBNK1 = IP_NUMVBNK;
  parameter BITVBNK1 = IP_BITVBNK;
  parameter NUMVROW2 = T1_T1_NUMVROW;
  parameter BITVROW2 = T1_T1_BITVROW;
  parameter NUMVBNK2 = T1_IP_NUMVBNK;
  parameter BITVBNK2 = T1_IP_BITVBNK;
  parameter SRAM_DELAY = T1_DELAY;
  parameter ECCDWIDTH = IP_ECCDWIDTH;
  parameter ECCBITS = IP_ECCBITS;

  parameter SDOUT_WIDTH = 2*(BITVBNK1+1)+ECCBITS;

  input [2-1:0]                  rw_read;
  input [2-1:0]                  rw_write;
  input [2*BITADDR-1:0]          rw_addr;
  input [2*WIDTH-1:0]            rw_din;
  output [2-1:0]                 rw_vld;
  output [2-1:0]                 rw_serr;
  output [2*WIDTH-1:0]           rw_dout;

  output                         ready;
  input                          clk, rst;
  
  output [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
  output [NUMVBNK1*NUMVBNK2*BITVROW2-1:0] t1_addrA;
  output [NUMVBNK1*NUMVBNK2*WIDTH-1:0] t1_dinA;
  output [NUMVBNK1*NUMVBNK2*WIDTH-1:0] t1_doutA;

  output [NUMVBNK1-1:0] t2_readA;
  output [NUMVBNK1-1:0] t2_writeA;
  output [NUMVBNK1*BITVROW2-1:0] t2_addrA;
  output [NUMVBNK1*WIDTH-1:0] t2_dinA;
  input [NUMVBNK1*WIDTH-1:0] t2_doutA;

  output [2-1:0] t3_writeA;
  output [2*BITVROW1-1:0] t3_addrA;
  output [2*SDOUT_WIDTH-1:0] t3_dinA;
  output [2-1:0] t3_readB;
  output [2*BITVROW1-1:0] t3_addrB;
  input [2*SDOUT_WIDTH-1:0] t3_doutB;

  output [2-1:0] t4_writeA;
  output [2*BITVROW1-1:0] t4_addrA;
  output [2*WIDTH-1:0] t4_dinA;
  output [2-1:0] t4_readB;
  output [2*BITVROW1-1:0] t4_addrB;
  input [2*WIDTH-1:0] t4_doutB;

  assign rw_serr = 2'b0;
  
  		algo_2rw_1rw_top
				   #(.WIDTH(WIDTH),
				  .BITWDTH(BITWDTH),
				  .NUMADDR(NUMADDR),
				  .BITADDR(BITADDR),
				  .NUMVROW1(NUMVROW1),
				  .BITVROW1(BITVROW1),
				  .NUMVBNK1(NUMVBNK1),
				  .BITVBNK1(BITVBNK1),
				  .NUMVROW2(NUMVROW2),
				  .BITVROW2(BITVROW2),
				  .NUMVBNK2(NUMVBNK2),
				  .BITVBNK2(BITVBNK2),
				  .SRAM_DELAY(SRAM_DELAY),
				  .ECCDWIDTH(ECCDWIDTH),
				  .ECCBITS(ECCBITS))
			algo_top
				(.clk(clk), .rst(rst), .ready(ready),
				 .read(rw_read), .write(rw_write), .addr(rw_addr), .din(rw_din), .rd_vld(rw_vld), .rd_dout(rw_dout),
				 .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA),
				 .t2_readA(t2_readA), .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_doutA(t2_doutA),
				 .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB),
				 .t4_writeA(t4_writeA), .t4_addrA(t4_addrA), .t4_dinA(t4_dinA), .t4_readB(t4_readB), .t4_addrB(t4_addrB), .t4_doutB(t4_doutB));
				 
// MEMOIR_TRANSLATE_ON
				 
endmodule    //algo_2rw_a4_top_wrap

