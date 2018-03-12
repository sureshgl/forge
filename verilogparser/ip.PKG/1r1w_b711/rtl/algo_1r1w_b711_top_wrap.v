module algo_1r1w_b711_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 64, parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 1, parameter T1_DELAY = 1,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1,  parameter T1_NUMSROW = 4096, parameter T1_BITSROW = 12, parameter T1_PHYWDTH = 128,
parameter T1_NUMVROW = 8192, parameter T1_BITVROW = 13
)

(wr_rst, write, wr_clk,  wr_adr, bw, din, read, rd_rst, rd_clk, rd_adr, rd_dout, rd_vld, flopout_en,
 t1_writeA, t1_wr_rstA, t1_wr_clkA, t1_addrA, t1_dinA, t1_bwA, t1_readB, t1_addrB, t1_doutB, t1_rd_rstB, t1_rd_clkB);

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
  parameter FLOPWTH = FLOPOUT >0?FLOPOUT:1;

  input                                            write;
  input                                            wr_clk;
  input                                            wr_rst;
  input [BITADDR-1:0]                              wr_adr;
  input [WIDTH-1:0]                                bw;
  input [WIDTH-1:0]                                din;

  input [NUMRDPT-1:0]                              read;
  input                                            rd_clk;
  input                                            rd_rst;
  input [NUMRDPT*BITADDR-1:0]                      rd_adr;
  output [NUMRDPT-1:0]                             rd_vld;
  output [NUMRDPT*WIDTH-1:0]                       rd_dout;

  input [FLOPWTH-1:0]                              flopout_en;

  output [NUMRDPT*NUMVBNK-1:0]                     t1_writeA;
  output [NUMRDPT*NUMVBNK-1:0]                     t1_wr_clkA;
  output [NUMRDPT*NUMVBNK-1:0]                     t1_wr_rstA;
  output [NUMRDPT*NUMVBNK*BITSROW-1:0]   		   t1_addrA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0]             t1_dinA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0]             t1_bwA;

  output [NUMRDPT*NUMVBNK-1:0]                     t1_readB;
  output [NUMRDPT*NUMVBNK-1:0]                     t1_rd_clkB;
  output [NUMRDPT*NUMVBNK-1:0]                     t1_rd_rstB;
  output [NUMRDPT*NUMVBNK*BITSROW-1:0]   		   t1_addrB;
  input  [NUMRDPT*NUMVBNK*PHYWDTH-1:0]             t1_doutB;


  assign t1_wr_clkA = {(NUMRDPT*NUMVBNK){1'b0}};
  assign t1_wr_rstA = {(NUMRDPT*NUMVBNK){1'b0}};
  assign t1_rd_clkB = {(NUMRDPT*NUMVBNK){1'b0}};
  assign t1_rd_rstB = {(NUMRDPT*NUMVBNK){1'b0}};

  algo_nr1w_b711_dup_top #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .NUMRDPT(NUMRDPT), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ECCWDTH(ECCWDTH),
					  .NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK),
					  .NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW), .PHYWDTH(PHYWDTH), 
					  .SRAM_DELAY(SRAM_DELAY), .FLOPIN(FLOPIN),   .FLOPCMD(FLOPCMD),   .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT),  .FLOPWTH(FLOPWTH))
				algo_top
					(
					 .write(write), .wr_clk(wr_clk), .wr_rst(wr_rst), .wr_adr(wr_adr), .bw(bw), .din(din),
                     .flopout_en(flopout_en),
					 .read(read), .rd_clk(rd_clk), .rd_rst(rd_rst), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), 
					 .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_bwA(t1_bwA),
                     .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB) );
  
endmodule    //algo_1r1w_b711_top_wrap

