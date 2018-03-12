module algo_1r1rw_b37_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
  parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
  parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
  parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

  parameter T1_WIDTH = 64, parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 1, parameter T1_DELAY = 2,
  parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1,  parameter T1_NUMSROW = 4096, parameter T1_BITSROW = 12, parameter T1_PHYWDTH = 128,
  parameter T1_NUMVROW = 256, parameter T1_BITVROW = 8,

  parameter T2_WIDTH = 8, parameter T2_NUMVBNK = 1, parameter T2_BITVBNK = 0, parameter T2_DELAY = 1,
  parameter T2_NUMVROW = 256, parameter T2_BITVROW = 8, parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1,
  parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 256, parameter T2_BITSROW = 8, parameter T2_PHYWDTH = 8
)
  (clk, rst, ready, 
    read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
    rw_read, rw_write, rw_addr, rw_din, rw_dout, rw_vld, rw_serr, rw_derr, rw_padr,
    t1_readA, t1_writeA, t1_addrA,           t1_dinA, t1_bwA, t1_doutA,
    t2_readB, t2_writeA, t2_addrA, t2_addrB, t2_dinA, t2_bwA, t2_doutB);

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR  = IP_ENAPAR;
  parameter ENAECC  = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
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

  parameter NUMRDPT = 1;

  input  [NUMRDPT-1:0]                 read;
  input  [NUMRDPT*BITADDR-1:0]         rd_adr;
  output [NUMRDPT-1:0]                 rd_vld;
  output [NUMRDPT*WIDTH-1:0]           rd_dout;
  output [NUMRDPT-1:0]                 rd_serr;
  output [NUMRDPT-1:0]                 rd_derr;
  output [NUMRDPT*BITPADR-1:0]         rd_padr;

  input  [1-1:0]                       rw_read;
  input  [1-1:0]                       rw_write;
  input  [1*BITADDR-1:0]               rw_addr;
  input  [1*WIDTH-1:0]                 rw_din;
  output [1-1:0]                       rw_vld;
  output [1*WIDTH-1:0]                 rw_dout;
  output [1-1:0]                       rw_serr;
  output [1-1:0]                       rw_derr;
  output [1*BITPADR-1:0]               rw_padr;

  output                               ready;
  input                                clk, rst;

  output [NUMVBNK-1:0]               t1_readA;
  output [NUMVBNK-1:0]               t1_writeA;
  output [NUMVBNK*BITSROW-1:0]       t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0]       t1_dinA;
  output [NUMVBNK*PHYWDTH-1:0]       t1_bwA;
  input  [NUMVBNK*PHYWDTH-1:0]       t1_doutA;

  output [NUMRDPT*NUMVBNK-1:0]               t2_writeA;
  output [NUMRDPT*NUMVBNK*BITSROW-1:0]       t2_addrA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0]       t2_dinA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0]       t2_bwA;
  output [NUMRDPT*NUMVBNK-1:0]               t2_readB;
  output [NUMRDPT*NUMVBNK*BITSROW-1:0]       t2_addrB;
  input  [NUMRDPT*NUMVBNK*PHYWDTH-1:0]       t2_doutB;

  reg H2O_AMC2RWB40_001_00;
  always @(posedge clk)
    H2O_AMC2RWB40_001_00 <= rst;
  wire rst_int = H2O_AMC2RWB40_001_00 && rst;

  algo_1r1rw_base_top #(
    .WIDTH(WIDTH), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ECCWDTH(ECCWDTH),
    .BITWDTH(BITWDTH), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMVROW(NUMVROW),
    .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK),
    .NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW), .PHYWDTH(PHYWDTH), 
    .SRAM_DELAY(SRAM_DELAY), .FLOPIN(FLOPIN),  .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT))
  algo_top (
    .clk(clk), .rst(rst_int), .ready(ready),
    .rw_read(rw_read), .rw_write(rw_write), .rw_addr(rw_addr), .rw_din(rw_din),
    .rw_vld(rw_vld), .rw_dout(rw_dout), .rw_serr(rw_serr), .rw_derr(rw_derr), .rw_padr(rw_padr),
    .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
    .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA),
    .t1_dinA(t1_dinA), .t1_bwA(t1_bwA), .t1_doutA(t1_doutA),
    .t2_readB(t2_readB),   .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
    .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_bwA(t2_bwA)
  );

  // Check fwrd connections
// Check padr connections
// convert to mrn1rw_dup algo

endmodule    //algo_1r1rw_b37_top_wrap
