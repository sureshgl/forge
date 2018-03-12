module algo_2r2w_b752_sva_wrap(rst,clk, flopout_en, read, rd_adr, rd_dout, rd_vld, write, wr_adr, din, bw, 
  t1_readC, t1_addrC, t1_doutC, 
  t1_readD, t1_addrD, t1_doutD, 
  t1_writeA, t1_addrA, t1_dinA, t1_bwA,
  t1_writeB, t1_addrB, t1_dinB, t1_bwB

);
parameter IP_WIDTH = 15;
parameter IP_BITWIDTH = 4;
parameter IP_NUMADDR = 256;
parameter IP_BITADDR = 8;
parameter IP_NUMVBNK = 1;
parameter IP_BITVBNK = 0;
parameter IP_SECCBITS = 4;
parameter IP_SECCDWIDTH = 1;
parameter IP_BITPBNK = 0;
parameter FLOPIN = 0;
parameter FLOPOUT = 0;
parameter IP_ENAECC = 0;
parameter IP_DECCBITS = 6;
parameter IP_ENAPAR = 0;
parameter FLOPMEM = 0;
parameter FLOPCMD = 0;
parameter T1_WIDTH = 15;
parameter T1_PHYWDTH = 15;
parameter T1_NUMVBNK = 1;
parameter T1_BITVBNK = 0;
parameter T1_DELAY = 2;
parameter T1_NUMVROW = 256;
parameter T1_BITVROW = 8;
parameter T1_BITWSPF = 0;
parameter T1_NUMWRDS = 1;
parameter T1_BITWRDS = 0;
parameter T1_NUMSROW = 256;
parameter T1_BITSROW = 8;
parameter NUMWRPRT = 2;
parameter NUMRDPRT = 2;
parameter BITADDR = IP_BITADDR;
parameter WIDTH = IP_WIDTH;


input                             rst,clk;

input                             flopout_en;

input  [NUMRDPRT-1:0]             read;
input  [NUMRDPRT*BITADDR-1:0]     rd_adr;
input [NUMRDPRT*WIDTH-1:0]       rd_dout;
input [NUMRDPRT-1:0]             rd_vld;

input  [NUMWRPRT-1:0]             write;
input  [NUMWRPRT*BITADDR-1:0]     wr_adr;
input  [NUMWRPRT*WIDTH-1:0]       din;
input  [NUMWRPRT*WIDTH-1:0]       bw;

input                            t1_readC;
input [BITADDR-1:0]              t1_addrC;
input  [WIDTH-1:0]                t1_doutC;

input                            t1_readD;
input [BITADDR-1:0]              t1_addrD;
input  [WIDTH-1:0]                t1_doutD;

input                            t1_writeA;
input [BITADDR-1:0]              t1_addrA;
input [WIDTH-1:0]                t1_dinA;
input [WIDTH-1:0]                t1_bwA;

input                            t1_writeB;
input [BITADDR-1:0]              t1_addrB;
input [WIDTH-1:0]                t1_dinB;
input [WIDTH-1:0]                t1_bwB;

endmodule
