module algo_3r1w_b100_top_wrap
  #(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
    parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
    parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
    parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
    parameter T1_WIDTH = 64, parameter T1_NUMVBNK = 3, parameter T1_BITVBNK = 2, parameter T1_DELAY = 1,
    parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1,  parameter T1_NUMSROW = 4096, parameter T1_BITSROW = 12, parameter T1_PHYWDTH = 128,
    parameter T1_NUMVROW = 8192, parameter T1_BITVROW = 13)
  (clk, rst, ready, write, wr_adr, din, read, rd_adr, rd_dout, rd_vld, rd_serr, rd_derr, rd_padr,
   t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_readB, t1_addrB, t1_doutB);

  // MEMOIR_TRANSLATE_OFF

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR  = IP_ENAPAR;
  parameter ENAECC  = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter NUMRDPT = 3;
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

  input                                            write;
  input [BITADDR-1:0]                              wr_adr;
  input [WIDTH-1:0]                                din;

  input [NUMRDPT-1:0]                              read;
  input [NUMRDPT*BITADDR-1:0]                      rd_adr;
  output [NUMRDPT-1:0]                             rd_vld;
  output [NUMRDPT*WIDTH-1:0]                       rd_dout;
  output [NUMRDPT-1:0]                             rd_serr;
  output [NUMRDPT-1:0]                             rd_derr;
  output [NUMRDPT*BITPADR-1:0]                     rd_padr;

  output                                           ready;
  input                                            clk, rst;

  output [NUMRDPT*NUMVBNK-1:0]                     t1_writeA;
  output [NUMRDPT*NUMVBNK*BITSROW-1:0]             t1_addrA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0]             t1_dinA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0]             t1_bwA;

  output [NUMRDPT*NUMVBNK-1:0]                     t1_readB;
  output [NUMRDPT*NUMVBNK*BITSROW-1:0]             t1_addrB;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0]              t1_doutB;

  reg                                              H2O_AMC3R1WB100_001_00;
  always @(posedge clk)
    H2O_AMC3R1WB100_001_00 <= rst;
  wire                                             rst_int = H2O_AMC3R1WB100_001_00 && rst;

  algo_nr1w_dup_top #(.WIDTH(WIDTH), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ECCWDTH(ECCWDTH),
                      .BITWDTH(BITWDTH), .NUMRDPT(NUMRDPT), .NUMADDR(NUMADDR), .BITADDR(BITADDR),
                      .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK),
                      .NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW), .PHYWDTH(PHYWDTH), 
                      .SRAM_DELAY(SRAM_DELAY), .FLOPIN(FLOPIN),   .FLOPCMD(FLOPCMD),   .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT))
  algo_top
	 (.clk(clk), .rst(rst_int), .ready(ready),
	  .write(write), .wr_adr(wr_adr), .din(din),
	  .read(read), .rd_adr(rd_adr),
     .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
	  .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_bwA(t1_bwA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB));
  
  // MEMOIR_TRANSLATE_ON
endmodule    //algo_3r1w_b100_top_wrap