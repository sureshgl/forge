module algo_1ru_b2_sva_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 64, parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 1, parameter T1_DELAY = 1,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1,  parameter T1_NUMSROW = 4096, parameter T1_BITSROW = 12, parameter T1_PHYWDTH = 128,
parameter T1_NUMVROW = 8192, parameter T1_BITVROW = 13
)

(clk, rst, ready, ru_write, ru_addr, ru_din, ru_read, ru_dout, ru_vld, ru_serr, ru_derr, ru_padr,
 t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_readB, t1_addrB, t1_doutB, refr);

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMRUPT = 1;
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

  input                                            ru_write;
  input [BITADDR-1:0]                              ru_addr;
  input [WIDTH-1:0]                                ru_din;

  input [NUMRUPT-1:0]                              ru_read;
  input [NUMRUPT-1:0]                             ru_vld;
  input [NUMRUPT*WIDTH-1:0]                       ru_dout;
  input [NUMRUPT-1:0]                             ru_serr;
  input [NUMRUPT-1:0]                             ru_derr;
  input [NUMRUPT*BITPADR-1:0]                     ru_padr;

  input                                           ready;
  input                                            clk, rst;

  input [NUMRUPT*NUMVBNK-1:0]                     t1_writeA;
  input [NUMRUPT*NUMVBNK*BITSROW-1:0]   		   t1_addrA;
  input [NUMRUPT*NUMVBNK*PHYWDTH-1:0]             t1_dinA;
  input [NUMRUPT*NUMVBNK*PHYWDTH-1:0]             t1_bwA;

  input [NUMRUPT*NUMVBNK-1:0]                     t1_readB;
  input [NUMRUPT*NUMVBNK*BITSROW-1:0]   		   t1_addrB;
  input  [NUMRUPT*NUMVBNK*PHYWDTH-1:0]             t1_doutB;

  input  refr;

endmodule
