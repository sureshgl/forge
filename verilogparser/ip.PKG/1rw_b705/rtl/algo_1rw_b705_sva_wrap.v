module algo_1rw_b705_sva_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 64, parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 1, parameter T1_DELAY = 1,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1,  parameter T1_NUMSROW = 4096, parameter T1_BITSROW = 12, parameter T1_PHYWDTH = 128,
parameter T1_NUMVROW = 8192, parameter T1_BITVROW = 13
)

(clk, rst, rw_read, rw_write, rw_addr, rw_bw, rw_din, rw_dout, rw_vld, flopout_en,
 t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_doutA);

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter NUMRDPT = 1;
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
  parameter FLOPWTH = FLOPOUT>0?FLOPOUT:1;

  input                                            rw_write;
  input                                            rw_read;
  input [BITADDR-1:0]                              rw_addr;
  input [WIDTH-1:0]                                rw_bw;
  input [WIDTH-1:0]                                rw_din;

  input                                           rw_vld;
  input [WIDTH-1:0]                               rw_dout;

  input                                            clk, rst;
  
  input [FLOPWTH-1:0]                             flopout_en;

  input [NUMRDPT*NUMVBNK-1:0]                     t1_writeA;
  input [NUMRDPT*NUMVBNK*BITSROW-1:0]   		   t1_addrA;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0]             t1_dinA;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0]             t1_bwA;

  input [NUMRDPT*NUMVBNK-1:0]                     t1_readA;
  input  [NUMRDPT*NUMVBNK*PHYWDTH-1:0]             t1_doutA;


 
endmodule    //algo_1r1w_b10_sva_wrap

