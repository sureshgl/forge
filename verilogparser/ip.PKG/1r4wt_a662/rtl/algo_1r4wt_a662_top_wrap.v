module algo_1r4wt_a662_top_wrap 
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
  parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
  parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
  parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
  parameter FIFOCNT = 64, parameter BITFIFO = 6,

  parameter T1_WIDTH = 64, parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 1, parameter T1_DELAY = 1,
  parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1,  parameter T1_NUMSROW = 4096, parameter T1_BITSROW = 12, parameter T1_PHYWDTH = 128,
  parameter T1_NUMVROW = 8192, parameter T1_BITVROW = 13
)

(clk, rst, ready, 
  write, wr_adr, din, read, rd_adr, rd_dout, rd_vld, rd_serr, rd_derr, rd_padr,
  bp_thr, wr_bp,
 t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_readB, t1_addrB, t1_doutB);

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter NUMRDPT = 1;
  parameter NUMWRPT = 4;
  parameter NUMWTPT = 1;
  parameter BITWRPT = 2;
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


  input [NUMWRPT-1:0]                              write;
  input [NUMWRPT*BITADDR-1:0]                      wr_adr;
  input [NUMWRPT*WIDTH-1:0]                        din;

  input [NUMRDPT-1:0]                              read;
  input [NUMRDPT*BITADDR-1:0]                      rd_adr;
  output [NUMRDPT-1:0]                             rd_vld;
  output [NUMRDPT*WIDTH-1:0]                       rd_dout;
  output [NUMRDPT-1:0]                             rd_serr;
  output [NUMRDPT-1:0]                             rd_derr;
  output [NUMRDPT*BITPADR-1:0]                     rd_padr;

  output [3:0]                                         wr_bp;
  input [BITFIFO :0]                     bp_thr;

  output                                           ready;
  input                                            clk, rst;

  output [NUMRDPT*NUMVBNK-1:0]                     t1_writeA;
  output [NUMRDPT*NUMVBNK*BITSROW-1:0]   		   t1_addrA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0]             t1_dinA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0]             t1_bwA;

  output [NUMRDPT*NUMVBNK-1:0]                     t1_readB;
  output [NUMRDPT*NUMVBNK*BITSROW-1:0]   		   t1_addrB;
  input  [NUMRDPT*NUMVBNK*PHYWDTH-1:0]             t1_doutB;

  wire wr_bp_tmp;
  assign wr_bp[3] = wr_bp_tmp;
  assign wr_bp[2] = wr_bp_tmp;
  assign wr_bp[1] = wr_bp_tmp;
  assign wr_bp[0] = wr_bp_tmp;

  algo_mrnwt_base_top #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .NUMRDPT(NUMRDPT), .NUMWRPT(NUMWRPT), .NUMWTPT(NUMWTPT), .BITWRPT(BITWRPT),
                        .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ECCWDTH(ECCWDTH),
					    .NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK),
					    .NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW), .PHYWDTH(PHYWDTH), 
                        .FIFOCNT(FIFOCNT), .BITFIFO(BITFIFO),
					    .SRAM_DELAY(SRAM_DELAY), .FLOPIN(FLOPIN),   .FLOPCMD(FLOPCMD),   .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT))
				algo_top
					(.clk(clk), .rst(rst), .ready(ready),
					 .write(write), .wr_adr(wr_adr), .din(din),
                     .read(read), .rd_adr(rd_adr),
                     .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
                     .bp_thr(bp_thr), .wr_bp(wr_bp_tmp),
					 .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_bwA(t1_bwA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB));
  
endmodule // algo_1r4wt_a662_top_wrap

