module algo_3ror1w_a8_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 72, parameter T1_NUMVBNK = 45, parameter T1_BITVBNK = 6, parameter T1_DELAY = 2, parameter T1_NUMVROW = 32768, parameter T1_BITVROW = 15,
parameter T2_WIDTH = 72, parameter T2_NUMVBNK = 1, parameter T2_BITVBNK = 1, parameter T2_DELAY = 2, parameter T2_NUMVROW = 32768, parameter T2_BITVROW = 15,

parameter T1_IP_WIDTH = 72,  parameter T1_IP_BITWIDTH = 7, parameter T1_IP_NUMADDR = 32768, parameter T1_IP_BITADDR = 15, parameter T1_IP_NUMVBNK = 8,
parameter T1_IP_BITVBNK = 3, parameter T1_IP_SECCBITS = 4, parameter T1_IP_SECCDWIDTH = 4,
parameter T1_T1_WIDTH = 72, parameter T1_T1_NUMVBNK = 8, parameter T1_T1_BITVBNK = 3, parameter T1_T1_DELAY = 2, parameter T1_T1_NUMVROW = 4096, parameter T1_T1_BITVROW = 12,
parameter T1_T2_WIDTH = 72, parameter T1_T2_NUMVBNK = 1, parameter T1_T2_BITVBNK = 1, parameter T1_T2_DELAY = 2, parameter T1_T2_NUMVROW = 4096, parameter T1_T2_BITVROW = 12
)

			(clk, rst, ready,
			write, wr_adr, din,
			read, rd_adr, rd_vld, rd_serr,  rd_dout,
			t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA,
			t2_readA, t2_writeA, t2_addrA, t2_dinA, t2_doutA,
			t3_readA, t3_writeA, t3_addrA, t3_dinA, t3_doutA);
// MEMOIR_TRANSLATE_OFF

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW1 = T1_NUMVROW;
  parameter BITVROW1 = T1_BITVROW;
  parameter NUMVBNK1 = T1_NUMVBNK;
  parameter BITVBNK1 = T1_BITVBNK;
  //parameter BITPBNK1 = 4;
  //parameter BITPADR1 = 15;
  parameter NUMVROW2 = T1_T1_NUMVROW;
  parameter BITVROW2 = T1_T1_BITVROW;
  parameter NUMVBNK2 = T1_T1_NUMVBNK;
  parameter BITVBNK2 = T1_T1_BITVBNK;
  //parameter BITPBNK2 = 3;
  //parameter BITPADR2 = 11;
  parameter SRAM_DELAY = T1_DELAY;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input [3-1:0]                  read;
  input [3*BITADDR-1:0]          rd_adr;
  output [3-1:0]                 rd_vld;
  output [3-1:0]                 rd_serr;
  output [3*WIDTH-1:0]           rd_dout;

  output                               ready;
  input                                clk, rst;
 
  output [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
  output [NUMVBNK1*NUMVBNK2*BITVROW2-1:0] t1_addrA;
  output [NUMVBNK1*NUMVBNK2*WIDTH-1:0] t1_dinA;
  input [NUMVBNK1*NUMVBNK2*WIDTH-1:0] t1_doutA;

  output [NUMVBNK1-1:0] t2_readA;
  output [NUMVBNK1-1:0] t2_writeA;
  output [NUMVBNK1*BITVROW2-1:0] t2_addrA;
  output [NUMVBNK1*WIDTH-1:0] t2_dinA;
  input [NUMVBNK1*WIDTH-1:0] t2_doutA;

  output [1-1:0] t3_readA;
  output [1-1:0] t3_writeA;
  output [1*BITVROW1-1:0] t3_addrA;
  output [1*WIDTH-1:0] t3_dinA;
  input [1*WIDTH-1:0] t3_doutA;

  assign rd_serr = 3'b0;
  
	algo_3ror1w_a8_top
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
						  .SRAM_DELAY(SRAM_DELAY))
			algo_top					
			(.clk(clk), .rst(rst), .ready(ready),
			.write(write), .wr_adr(wr_adr), .din(din),
			.read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout),
			.t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA),
			.t2_readA(t2_readA), .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_doutA(t2_doutA),
			.t3_readA(t3_readA), .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), .t3_doutA(t3_doutA));
			
// MEMOIR_TRANSLATE_ON
endmodule 