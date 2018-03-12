module algo_4r5ws_a33_sva_wrap
#(
parameter IP_WIDTH = 256, parameter IP_BITWIDTH = 8, parameter IP_NUMADDR = 663552, parameter IP_BITADDR = 20,
parameter IP_NUMVBNK = 4, parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 5, 
parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, parameter IP_DECCBITS = 10,
parameter IP_ENAECC = 1, parameter IP_ENAHEC = 0, parameter IP_ENAQEC = 0, parameter IP_ENAPAR = 0,

parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 274, parameter T1_NUMVBNK = 16, parameter T1_BITVBNK = 4, parameter T1_DELAY = 2, parameter T1_NUMVROW = 2304, parameter T1_BITVROW = 12,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 0, parameter T1_NUMSROW = 2304, parameter T1_BITSROW = 12, parameter T1_PHYWDTH = 274,
parameter T2_WIDTH = 274, parameter T2_NUMVBNK = 8, parameter T2_BITVBNK = 3, parameter T2_DELAY = 2, parameter T2_NUMVROW = 2304, parameter T2_BITVROW = 12,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 2304, parameter T2_BITSROW = 12, parameter T2_PHYWDTH = 274,
parameter T3_WIDTH = 10, parameter T3_NUMVBNK = 12, parameter T3_BITVBNK = 4, parameter T3_DELAY = 2, parameter T3_NUMVROW = 2304, parameter T3_BITVROW = 12,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 0, parameter T3_NUMSROW = 2304, parameter T3_BITSROW = 12, parameter T3_PHYWDTH = 10,
parameter T4_WIDTH = 144, parameter T4_NUMVBNK = 80, parameter T4_BITVBNK = 7, parameter T4_DELAY = 2, parameter T4_NUMVROW = 7836, parameter T4_BITVROW = 13,
parameter T4_BITWSPF = 0, parameter T4_NUMWRDS = 1, parameter T4_BITWRDS = 0, parameter T4_NUMSROW = 7836, parameter T4_BITSROW = 13, parameter T4_PHYWDTH = 144,
parameter T5_WIDTH = 122, parameter T5_NUMVBNK = 80, parameter T5_BITVBNK = 7, parameter T5_DELAY = 2, parameter T5_NUMVROW = 7836, parameter T5_BITVROW = 13,
parameter T5_BITWSPF = 0, parameter T5_NUMWRDS = 1, parameter T5_BITWRDS = 0, parameter T5_NUMSROW = 7836, parameter T5_BITSROW = 13, parameter T5_PHYWDTH = 122,
parameter READ_DELAY=32)
( lclk, clk,  rst,  ready,
  write,   wr_adr,   din,
  read,   rd_adr,   rd_dout,   rd_vld,   rd_serr,   rd_derr,   rd_padr,
  whfifo_oflw, wlfifo_oflw, rhfifo_oflw, rlfifo_oflw, 
  t1_writeA,   t1_addrA,   t1_dinA,    t1_bwA,     t1_readB,    t1_addrB,   t1_doutB,
  t2_writeA,   t2_addrA,   t2_dinA,    t2_bwA,     t2_readB,    t2_addrB,   t2_doutB,
  t3_writeA,   t3_addrA,   t3_dinA,    t3_bwA,     t3_readB,    t3_addrB,   t3_doutB,
  t4_writeA,   t4_addrA,   t4_dinA,    t4_bwA,     t4_readB,    t4_addrB,   t4_doutB,
  t5_writeA,   t5_addrA,   t5_dinA,    t5_bwA,     t5_readB,    t5_addrB,   t5_doutB);
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ENAHEC = IP_ENAHEC;
  parameter ENAQEC = IP_ENAQEC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENAHEC ? WIDTH+2*ECCWDTH : ENAQEC ? WIDTH+4*ECCWDTH : WIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMCELL = 72;
  parameter BITCELL = 7;
  parameter NUMVROW = IP_NUMADDR/IP_NUMVBNK;
  parameter BITVROW = IP_BITADDR-IP_BITVBNK;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter PHYWDTH = MEMWDTH;
  parameter NUMHROW = T1_NUMVROW*T1_NUMVBNK/IP_NUMVBNK;
  parameter BITHROW = T1_BITVROW+T1_BITVBNK-IP_BITVBNK;
  parameter NUMHVBK = T1_NUMVBNK/IP_NUMVBNK;
  parameter BITHVBK = T1_BITVBNK-IP_BITVBNK;
  parameter BITHPBK = T1_BITVBNK-IP_BITVBNK+1;
  parameter NUMHVRW = T1_NUMVROW;
  parameter BITHVRW = T1_BITVROW;
  parameter NUMLROW = T4_NUMVROW*T4_NUMVBNK/IP_NUMVBNK; 
  parameter BITLROW = T4_BITVROW+T4_BITVBNK-IP_BITVBNK; 
  parameter NUMLVRW = T4_NUMVROW;
  parameter BITLVRW = T4_BITVROW;
  parameter NUMLVBK = T4_NUMVBNK/IP_NUMVBNK;
  parameter BITLVBK = T4_BITVBNK-IP_BITVBNK;
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T1_DELAY;
  parameter BITRDLY = 5;
  
  parameter BITPADR = BITLROW+4;
  parameter SDOUT_WIDTH = 2*(BITHPBK+1)+ECCBITS;
  parameter NUMRDPT = 4;
  parameter BITRDPT = 2;
  parameter NUMWRPT = 5;
  parameter BITWRPT = 3;
  
  parameter NUMQUEU = NUMADDR/NUMCELL;

  input [5-1:0]                        write;
  input [5*BITADDR-1:0]                wr_adr;
  input [5*WIDTH-1:0]                  din;

  input [4-1:0]                        read;
  input [4*BITADDR-1:0]                rd_adr;
  input  [4-1:0]                       rd_vld;
  input  [4*WIDTH-1:0]                 rd_dout;
  input  [4-1:0]                       rd_serr;
  input  [4-1:0]                       rd_derr;
  input  [4*BITPADR-1:0]               rd_padr;

  input  [NUMVBNK-1:0]                 whfifo_oflw;
  input  [NUMVBNK-1:0]                 wlfifo_oflw;
  input  [NUMVBNK-1:0]                 rhfifo_oflw;
  input  [NUMVBNK-1:0]                 rlfifo_oflw;

  input                                ready;
  input                                lclk, clk, rst;

  input  [T1_NUMVBNK-1:0] t1_writeA;
  input  [T1_NUMVBNK*T1_BITVROW-1:0] t1_addrA;
  input  [T1_NUMVBNK*T1_PHYWDTH-1:0] t1_bwA;
  input  [T1_NUMVBNK*T1_PHYWDTH-1:0] t1_dinA;
  input  [T1_NUMVBNK-1:0] t1_readB;
  input  [T1_NUMVBNK*T1_BITVROW-1:0] t1_addrB;
  input  [T1_NUMVBNK*T1_PHYWDTH-1:0] t1_doutB;

  input  [T2_NUMVBNK-1:0] t2_writeA;
  input  [T2_NUMVBNK*T2_BITVROW-1:0] t2_addrA;
  input  [T2_NUMVBNK*T2_PHYWDTH-1:0] t2_bwA;
  input  [T2_NUMVBNK*T2_PHYWDTH-1:0] t2_dinA;
  input  [T2_NUMVBNK-1:0] t2_readB;
  input  [T2_NUMVBNK*T2_BITVROW-1:0] t2_addrB;
  input  [T2_NUMVBNK*T2_PHYWDTH-1:0] t2_doutB;

  input  [T3_NUMVBNK-1:0] t3_writeA;
  input  [T3_NUMVBNK*T3_BITVROW-1:0] t3_addrA;
  input  [T3_NUMVBNK*T3_PHYWDTH-1:0] t3_bwA;
  input  [T3_NUMVBNK*T3_PHYWDTH-1:0] t3_dinA;
  input  [T3_NUMVBNK-1:0] t3_readB;
  input  [T3_NUMVBNK*T3_BITVROW-1:0] t3_addrB;
  input  [T3_NUMVBNK*T3_PHYWDTH-1:0] t3_doutB;

  input  [T4_NUMVBNK-1:0] t4_writeA;
  input  [T4_NUMVBNK*T4_BITVROW-1:0] t4_addrA;
  input  [T4_NUMVBNK*T4_PHYWDTH-1:0] t4_bwA;
  input  [T4_NUMVBNK*T4_PHYWDTH-1:0] t4_dinA;
  input  [T4_NUMVBNK-1:0] t4_readB;
  input  [T4_NUMVBNK*T4_BITVROW-1:0] t4_addrB;
  input  [T4_NUMVBNK*T4_PHYWDTH-1:0] t4_doutB;

  input  [T5_NUMVBNK-1:0] t5_writeA;
  input  [T5_NUMVBNK*T5_BITVROW-1:0] t5_addrA;
  input  [T5_NUMVBNK*T5_PHYWDTH-1:0] t5_bwA;
  input  [T5_NUMVBNK*T5_PHYWDTH-1:0] t5_dinA;
  input  [T5_NUMVBNK-1:0] t5_readB;
  input  [T5_NUMVBNK*T5_BITVROW-1:0] t5_addrB;
  input  [T5_NUMVBNK*T5_PHYWDTH-1:0] t5_doutB;

wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITCELL-BITVBNK-1:0] select_vwrd = 0;
wire [BITADDR-BITCELL-1:0] select_vrow = 0;
wire [BITHROW-1:0] select_hrow = 0;
wire [BITLROW-1:0] select_lrow = 0;
wire [BITVBNK-1:0] select_bnk = 0;
wire select_prio = 0;
wire [BITHVRW-1:0] select_hvrw = 0;
wire [BITLVRW-1:0] select_lvrw = 0;

 ip_top_sva_2_mrnws_a33 #(
     .WIDTH       (WIDTH), .NUMRDPT     (NUMRDPT), .BITRDPT     (BITRDPT), .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR), .BITADDR     (BITADDR), .NUMVBNK     (NUMVBNK), .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW), .BITVROW     (BITVROW), .NUMHROW     (NUMHROW), .BITHROW     (BITHROW),
     .NUMLROW     (NUMLROW), .BITLROW     (BITLROW), .NUMCELL     (NUMCELL),     .BITCELL     (BITCELL),
     .BITHVRW(BITHVRW), .BITLVRW(BITLVRW), .NUMQUEU     (NUMQUEU), .BITWDTH (BITWDTH))
  ip_top_sva_2 (.select_addr(select_addr), .select_bit (select_bit), .select_bnk(select_bnk), .select_prio(select_prio), .select_vwrd(select_vwrd), 
                .select_vrow(select_vrow), .select_hrow(select_hrow), .select_hvrw(select_hvrw), .select_lrow(select_lrow), 
                .clk(clk), .rst(rst), .ready(ready),
                .write(write), .wr_adr(wr_adr), .din(din), .read(read), .rd_adr(rd_adr),
                .whfifo_oflw(whfifo_oflw), .wlfifo_oflw(wlfifo_oflw), .rhfifo_oflw(rhfifo_oflw), .rlfifo_oflw(rlfifo_oflw)
               );

endmodule // algo_4r5ws_a33_sva_wrap

