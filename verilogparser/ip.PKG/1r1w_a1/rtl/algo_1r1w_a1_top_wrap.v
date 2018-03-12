module algo_1r1w_a1_top_wrap 
#(parameter IP_WIDTH = 32,
parameter IP_BITWIDTH = 5,
parameter IP_NUMADDR = 8192,
parameter IP_BITADDR = 13,
parameter IP_SECCBITS = 4,
parameter IP_SECCDWIDTH = 4,
parameter IP_NUMVBNK = 8,
parameter IP_BITVBNK = 3,
parameter T1_WIDTH = 32,
parameter T1_NUMVBNK = 8,
parameter T1_BITVBNK = 3,
parameter T1_BITWSPF = 0, 
parameter T1_DELAY = 2,
parameter T1_NUMVROW = 1024,
parameter T1_BITVROW = 10,
parameter T2_WIDTH = 0,
parameter T2_NUMVBNK = 0,
parameter T2_BITVBNK = 0,
parameter T2_DELAY = 0,
parameter T2_NUMVROW = 0,
parameter T2_BITVROW = 0,
parameter FLOPIN = 0, parameter FLOPMEM = 0, parameter FLOPOUT = 0)
			(clk, rst, ready,
                          write, wr_adr, din,
                          read, rd_adr, rd_vld, rd_dout, rd_serr,
                          t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA,
                          t2_readB, t2_writeA, t2_addrA, t2_addrB, t2_dinA, t2_doutB);
						  
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

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input                                read;
  input [BITADDR-1:0]                  rd_adr;
  output                               rd_vld;
  output 			       rd_serr;
  output [WIDTH-1:0]                   rd_dout;

  output                               ready;
  input                                clk, rst;

  output [NUMVBNK-1:0] t1_readA;
  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMVBNK*WIDTH-1:0] t1_dinA;
  input [NUMVBNK*WIDTH-1:0] t1_doutA;

  output [2-1:0] t2_writeA;
  output [2*BITVROW-1:0] t2_addrA;
  output [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA;

  output [2-1:0] t2_readB;
  output [2*BITVROW-1:0] t2_addrB;
  input [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB;

  assign rd_serr = 1'b0;

  algo_1r1w_a1_top #( .WIDTH(WIDTH), .BITWDTH(BITWDTH), .NUMADDR(NUMADDR), .BITADDR(BITADDR), 
			.NUMVROW(NUMVROW),  .BITVROW(BITVROW) ,  .NUMVBNK(NUMVBNK) , .BITVBNK(BITVBNK) ,  
			.SRAM_DELAY(SRAM_DELAY) ,  
			.ECCDWIDTH(ECCDWIDTH) ,  .ECCBITS(ECCBITS)) 
		algo_top (.clk(clk), .rst(rst), .ready(ready),
                          .write(write), .wr_adr(wr_adr), .din(din),
                          .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout),
                          .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA),
                          .t2_readB(t2_readB), .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_addrB(t2_addrB), .t2_dinA(t2_dinA), .t2_doutB(t2_doutB));


// MEMOIR_TRANSLATE_ON

endmodule
