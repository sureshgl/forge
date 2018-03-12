module algo_2r2w_a53_sva_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 22, parameter T1_BITVBNK = 5, parameter T1_DELAY = 1, parameter T1_NUMVROW = 745, parameter T1_BITVROW = 10,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 745, parameter T1_BITSROW = 10, parameter T1_PHYWDTH = 32, 
parameter T2_WIDTH = 32, parameter T2_NUMVBNK = 3, parameter T2_BITVBNK = 2, parameter T2_DELAY = 1, parameter T2_NUMVROW = 745, parameter T2_BITVROW = 10,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 745, parameter T2_BITSROW = 10, parameter T2_PHYWDTH = 32,
parameter T3_WIDTH = 15, parameter T3_NUMVBNK = 4, parameter T3_BITVBNK = 2, parameter T3_DELAY = 1, parameter T3_NUMVROW = 745, parameter T3_BITVROW = 10,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 1, parameter T3_NUMSROW = 745, parameter T3_BITSROW = 10, parameter T3_PHYWDTH = 15)

( clk,  rst,  ready, 
 write,  wr_adr,  din,
 read,  rd_adr,  rd_dout,  rd_vld,  rd_serr,  rd_derr,  rd_padr,
 t1_writeA,  t1_addrA,  t1_dinA,  t1_bwA,
 t1_readB,  t1_addrB,  t1_doutB,
 t2_writeA,  t2_addrA,  t2_dinA,  t2_bwA,
 t2_readB,  t2_addrB,  t2_doutB,
 t3_writeA, t3_addrA,  t3_dinA,  t3_bwA,
 t3_readB,  t3_addrB,  t3_doutB); 
 
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMRDPT = 2;
  parameter NUMVROW = T1_NUMVROW;
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter PHYWDTH = NUMWRDS*WIDTH;
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T1_DELAY;
	
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input [2-1:0]                        write;
  input [2*BITADDR-1:0]                wr_adr;
  input [2*WIDTH-1:0]                  din;

  input [NUMRDPT-1:0]                  read;
  input [NUMRDPT*BITADDR-1:0]          rd_adr;
  input [NUMRDPT-1:0]                 rd_vld;
  input [NUMRDPT*WIDTH-1:0]           rd_dout;
  input [NUMRDPT-1:0]                 rd_serr;
  input [NUMRDPT-1:0]                 rd_derr;
  input [NUMRDPT*BITPADR-1:0]         rd_padr;

  input                               ready;
  input                                clk, rst;

  input [NUMRDPT*NUMVBNK-1:0] t1_writeA;
  input [NUMRDPT*NUMVBNK*BITSROW-1:0] t1_addrA;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_bwA;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;

  input [NUMRDPT*NUMVBNK-1:0] t1_readB;
  input [NUMRDPT*NUMVBNK*BITSROW-1:0] t1_addrB;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_doutB;

  input [(NUMRDPT+1)-1:0] t2_writeA;
  input [(NUMRDPT+1)*BITVROW-1:0] t2_addrA;
  input [(NUMRDPT+1)*WIDTH-1:0] t2_dinA;
  input [(NUMRDPT+1)*WIDTH-1:0] t2_bwA;
  input [(NUMRDPT+1)-1:0] t2_readB;
  input [(NUMRDPT+1)*BITVROW-1:0] t2_addrB;
  input [(NUMRDPT+1)*WIDTH-1:0] t2_doutB;

  input [(NUMRDPT+2)-1:0] t3_writeA;
  input [(NUMRDPT+2)*BITVROW-1:0] t3_addrA;
  input [(NUMRDPT+2)*SDOUT_WIDTH-1:0] t3_dinA;
  input [(NUMRDPT+2)*SDOUT_WIDTH-1:0] t3_bwA;
  input [(NUMRDPT+2)-1:0] t3_readB;
  input [(NUMRDPT+2)*BITVROW-1:0] t3_addrB;
  input [(NUMRDPT+2)*SDOUT_WIDTH-1:0] t3_doutB;

endmodule