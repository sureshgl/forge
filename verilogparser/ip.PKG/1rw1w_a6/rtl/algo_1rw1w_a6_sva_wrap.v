
module algo_1rw1w_a6_sva_wrap 
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
  input [1-1:0]                 rw_vld;
  input [1-1:0]                 rw_serr;
  input [1*WIDTH-1:0]           rw_dout;

  input                         ready;
  input                          clk, rst;

  input [NUMVBNK-1:0] t1_readA;
  input [NUMVBNK-1:0] t1_writeA;
  input [NUMVBNK*BITVROW-1:0] t1_addrA;
  input [NUMVBNK*WIDTH-1:0] t1_dinA;
  input [NUMVBNK*WIDTH-1:0] t1_doutA;

  input [2-1:0] t2_writeA;
  input [2*BITVROW-1:0] t2_addrA;
  input [2*SDOUT_WIDTH-1:0] t2_dinA;
  input [2-1:0] t2_readB;
  input [2*BITVROW-1:0] t2_addrB;
  input [2*SDOUT_WIDTH-1:0] t2_doutB;

  input [2-1:0] t3_writeA;
  input [2*BITVROW-1:0] t3_addrA;
  input [2*WIDTH-1:0] t3_dinA;
  input [2-1:0] t3_readB;
  input [2*BITVROW-1:0] t3_addrB;
  input [2*WIDTH-1:0] t3_doutB;

endmodule
