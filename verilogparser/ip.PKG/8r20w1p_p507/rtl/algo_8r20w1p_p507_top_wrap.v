module algo_8r20w1p_p507_top_wrap
#(parameter IP_WIDTH = 64, parameter IP_BITWIDTH = 6, parameter IP_NUMADDR = 8192, parameter IP_DECCBITS = 0,
parameter IP_BITADDR = 13, parameter IP_NUMVBNK = 1, parameter IP_BITVBNK = 1, parameter IP_BITPBNK = 1,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter T1_WIDTH = 64,
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter NUMGRPW = 13, parameter GRPWDTH = 128, parameter NUMGRPF = 5, parameter NUMCMDL = 2, parameter BITCMDL = 1, parameter WRBUSRED = 1,
parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 1, parameter T1_DELAY = 1,
parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1,  parameter T1_NUMSROW = 4096, parameter T1_BITSROW = 12, parameter T1_PHYWDTH = 128,
parameter T1_NUMVROW = 8192, parameter T1_BITVROW = 13, parameter T1_BITWSPF = 0
)

(clk, rst, ready, write, wr_badr, wr_radr, din, read, rd_badr, rd_radr, rd_dout, rd_vld, rd_serr, rd_derr, rd_padr,
 t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_readB, t1_addrB, t1_doutB);
// MEMOIR_TRANSLATE_OFF

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMRDPT = 8;
  parameter NUMWRPT = 20;
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
  input [NUMWRPT*BITVBNK-1:0]                      wr_badr;
  input [NUMWRPT*BITVROW-1:0]                      wr_radr;
  input [(4+16/WRBUSRED)*WIDTH-1:0]            din;

  input [NUMRDPT-1:0]                              read;
  input [NUMRDPT*BITVBNK-1:0]                      rd_badr;
  input [NUMRDPT*BITVROW-1:0]                      rd_radr;
  output [NUMRDPT-1:0]                             rd_vld;
  output [NUMRDPT*WIDTH-1:0]                       rd_dout;
  output [NUMRDPT-1:0]                             rd_serr;
  output [NUMRDPT-1:0]                             rd_derr;
  output [NUMRDPT*BITPADR-1:0]                     rd_padr;

  output                                           ready;
  input                                            clk, rst;

  output [NUMGRPW*NUMVBNK-1:0] t1_writeA;
  output [NUMGRPW*NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  output [NUMGRPW*NUMVBNK-1:0] t1_readB;
  output [NUMGRPW*NUMVBNK*BITSROW-1:0] t1_addrB;
  input  [NUMVBNK*PHYWDTH-1:0] t1_doutB;
  
reg H2O_AMP1R6WP61_001_00;
always @(posedge clk)
  H2O_AMP1R6WP61_001_00 <= rst;
wire rst_int = H2O_AMP1R6WP61_001_00 && rst;

    algo_mrpnwp_1r1w_base_top #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .NUMRDPT(NUMRDPT), .NUMWRPT(NUMWRPT), .NUMADDR(NUMADDR), .BITADDR(BITADDR),
                              .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK),
                              .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS), .NUMSROW(NUMSROW), .BITSROW(BITSROW), .PHYWDTH(PHYWDTH),
			      .NUMGRPW(NUMGRPW), .GRPWDTH(GRPWDTH), .NUMGRPF(NUMGRPF), .NUMCMDL(NUMCMDL), .BITCMDL(BITCMDL), .WRBUSRED(WRBUSRED),
                              .SRAM_DELAY(SRAM_DELAY), .FLOPIN(FLOPIN), .FLOPCMD(FLOPCMD), .FLOPMEM(FLOPMEM), .FLOPOUT(FLOPOUT))
    algo_top (.clk(clk), .rst(rst_int), .ready(ready),
	      .write(write), .wr_badr(wr_badr), .wr_radr(wr_radr), .din(din),
	      .read(read), .rd_badr(rd_badr), .rd_radr(rd_radr), .rd_vld(rd_vld), .rd_dout(rd_dout), 
	      .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
              .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_bwA(t1_bwA), .t1_dinA(t1_dinA),
              .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB));
  
// MEMOIR_TRANSLATE_ON
endmodule    //algo_8r20w1p_p507_top_wrap


