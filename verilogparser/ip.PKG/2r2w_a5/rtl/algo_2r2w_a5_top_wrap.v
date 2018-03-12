module algo_2r2w_a5_top_wrap

#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, parameter IP_NUMVBNK = 8, parameter IP_BITVBNK = 3, parameter IP_ECCBITS = 4, parameter IP_ECCDWIDTH = 4,
parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 16, parameter T1_BITVBNK = 4, parameter T1_DELAY = 1, parameter T1_NUMVROW = 1024, parameter T1_BITVROW = 10, 
parameter T2_WIDTH = 32, parameter T2_NUMVBNK = 3, parameter T2_BITVBNK = 2, parameter T2_DELAY = 1, parameter T2_NUMVROW = 1024, parameter T2_BITVROW = 10,
parameter T3_WIDTH = 12, parameter T3_NUMVBNK = 4, parameter T3_BITVBNK = 2, parameter T3_DELAY = 1, parameter T3_NUMVROW = 1024, parameter T3_BITVROW = 10,
parameter FLOPIN = 0, parameter FLOPMEM = 0, parameter FLOPOUT = 0)
		(clk, rst, ready,
		write, wr_adr, din,
		read, rd_adr, rd_vld, rd_serr, rd_dout,
		t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
		t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
		t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB);
		
// MEMOIR_TRANSLATE_OFF

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter ECCDWIDTH = IP_ECCDWIDTH;
  parameter ECCBITS = IP_ECCBITS;
  parameter SRAM_DELAY = T1_DELAY;

  parameter NUMRPRT = 2;
  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input [2-1:0]                        write;
  input [2*BITADDR-1:0]                wr_adr;
  input [2*WIDTH-1:0]                  din;

  input [NUMRPRT-1:0]                  read;
  input [NUMRPRT*BITADDR-1:0]          rd_adr;
  output [NUMRPRT-1:0]                 rd_vld;
  output [NUMRPRT-1:0]                 rd_serr;
  output [NUMRPRT*WIDTH-1:0]           rd_dout;

  output                               ready;
  input                                clk, rst;

  output [NUMRPRT*NUMVBNK-1:0] t1_writeA;
  output [NUMRPRT*NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMRPRT*NUMVBNK*WIDTH-1:0] t1_dinA;
  output [NUMRPRT*NUMVBNK-1:0] t1_readB;
  output [NUMRPRT*NUMVBNK*BITVROW-1:0] t1_addrB;
  input [NUMRPRT*NUMVBNK*WIDTH-1:0] t1_doutB;

  output [(NUMRPRT+1)-1:0] t2_writeA;
  output [(NUMRPRT+1)*BITVROW-1:0] t2_addrA;
  output [(NUMRPRT+1)*WIDTH-1:0] t2_dinA;
  output [(NUMRPRT+1)-1:0] t2_readB;
  output [(NUMRPRT+1)*BITVROW-1:0] t2_addrB;
  input [(NUMRPRT+1)*WIDTH-1:0] t2_doutB;

  output [(NUMRPRT+2)-1:0] t3_writeA;
  output [(NUMRPRT+2)*BITVROW-1:0] t3_addrA;
  output [(NUMRPRT+2)*SDOUT_WIDTH-1:0] t3_dinA;
  output [(NUMRPRT+2)-1:0] t3_readB;
  output [(NUMRPRT+2)*BITVROW-1:0] t3_addrB;
  input [(NUMRPRT+2)*SDOUT_WIDTH-1:0] t3_doutB;

  assign rd_serr = {NUMRPRT{1'b0}};
  
  algo_2r2w_a5_top
				  #(.WIDTH(WIDTH),
				  .BITWDTH(BITWDTH),
				  .NUMADDR(NUMADDR),
				  .BITADDR(BITADDR),
				  .NUMVROW(NUMVROW),
				  .BITVROW(BITVROW),
				  .NUMVBNK(NUMVBNK),
				  .BITVBNK(BITVBNK),
				  .ECCDWIDTH(ECCDWIDTH),
				  .ECCBITS(ECCBITS),
				  .SRAM_DELAY(SRAM_DELAY))
			algo_top	  
				(.clk(clk), .rst(rst), .ready(ready),
				.write(write), .wr_adr(wr_adr), .din(din),
				.read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout),
				.t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
				.t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
				.t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB));
				
// MEMOIR_TRANSLATE_ON

endmodule    //algo_2r2w_a5_top_wrap

