module algo_1r1rw_b35_sva_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 64, parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 1, parameter T1_DELAY = 2,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1,  parameter T1_NUMSROW = 4096, 
parameter T1_BITSROW = 12, parameter T1_PHYWDTH = 128, parameter T1_NUMVROW = 256, parameter T1_BITVROW = 8
)
(clk, rst, ready, rw_read, rw_write, rw_addr, rw_din, rw_dout, rw_vld, rw_serr, rw_derr, rw_padr, read, rd_adr, rd_dout, rd_vld, rd_serr, rd_derr, rd_padr,
 t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_doutA,
 t1_readB, t1_writeB, t1_addrB, t1_dinB, t1_bwB, t1_doutB);

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ECCWDTH = IP_DECCBITS;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
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

  input                                rw_read;
  input                                rw_write;
  input [BITADDR-1:0]                  rw_addr;
  input [WIDTH-1:0]                    rw_din;
  input                               rw_vld;
  input [WIDTH-1:0]                   rw_dout;
  input                               rw_serr;
  input                               rw_derr;
  input [BITPADR-1:0]                 rw_padr;
  input                                read;
  input [BITADDR-1:0]                  rd_adr;
  input [WIDTH-1:0]                   rd_dout;
  input                               rd_vld;
  input                               rd_serr;
  input                               rd_derr;
  input [BITPADR-1:0]                 rd_padr;
  

  input                               ready;
  input                                clk, rst;

  input [NUMVBNK-1:0]               t1_readA;
  input [NUMVBNK-1:0]               t1_writeA;
  input [NUMVBNK*BITSROW-1:0]       t1_addrA;
  input [NUMVBNK*PHYWDTH-1:0]         t1_dinA;
  input [NUMVBNK*PHYWDTH-1:0]         t1_bwA;
  input [NUMVBNK*PHYWDTH-1:0]         t1_doutA;
  
  input [NUMVBNK-1:0]               t1_readB;
  input [NUMVBNK-1:0]               t1_writeB;
  input [NUMVBNK*BITSROW-1:0]       t1_addrB;
  input [NUMVBNK*PHYWDTH-1:0]         t1_dinB;
  input [NUMVBNK*PHYWDTH-1:0]         t1_bwB;
  input [NUMVBNK*PHYWDTH-1:0]         t1_doutB;


endmodule    //algo_1r1rw_b35_sva_wrap