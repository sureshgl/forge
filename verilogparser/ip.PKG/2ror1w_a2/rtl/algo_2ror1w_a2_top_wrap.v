module algo_2ror1w_a2_top_wrap

#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 4, parameter T1_BITVBNK = 2, parameter T1_DELAY = 1, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11,
parameter T2_WIDTH = 32, parameter T2_NUMVBNK = 1, parameter T2_BITVBNK = 0, parameter T2_DELAY = 1, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11
)
)

			(clk, rst, ready,
			write, wr_adr, din,
			read, rd_adr, rd_vld, rd_serr, rd_dout,
			t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA,
			t2_readA, t2_writeA, t2_addrA, t2_dinA, t2_doutA);
// MEMOIR_TRANSLATE_OFF

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = T1_NUMVBNK;
  parameter BITVBNK = T1_BITVBNK;
  //parameter BITPBNK = 4;
  //parameter BITPADR = 15;
  parameter SRAM_DELAY = T1_DELAY;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input [2-1:0]                  read;
  input [2*BITADDR-1:0]          rd_adr;
  output [2-1:0]                 rd_vld;
  output [2-1:0]                 rd_serr;
  output [2*WIDTH-1:0]           rd_dout;

  output                               ready;
  input                                clk, rst;

  output [NUMVBNK-1:0] t1_readA;
  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMVBNK*WIDTH-1:0] t1_dinA;
  input [NUMVBNK*WIDTH-1:0] t1_doutA;

  
  output [1-1:0] t2_readA;
  output [1-1:0] t2_writeA;
  output [1*BITVROW-1:0] t2_addrA;
  output [1*WIDTH-1:0] t2_dinA;
  input [1*WIDTH-1:0] t2_doutA;

  assign rd_serr = 2'b0;

  algo_2ror1w_a2_top
			#(.WIDTH(WIDTH),
			  .BITWDTH(BITWDTH),
			  .NUMADDR(NUMADDR),
			  .BITADDR(BITADDR),
			  .NUMVROW(NUMVROW),
			  .BITVROW(BITVROW),
			  .NUMVBNK(NUMVBNK),
			  .BITVBNK(BITVBNK),
			  .SRAM_DELAY(SRAM_DELAY))
		algo_top
			(.clk(clk), .rst(rst), .ready(ready),
			.write(write), .wr_adr(wr_adr), .din(din),
			.read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout),
			.t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA),
			.t2_readA(t2_readA), .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_doutA(t2_doutA));
			  
// MEMOIR_TRANSLATE_ON
endmodule    //algo_2ror1w_a2_top_wrap

