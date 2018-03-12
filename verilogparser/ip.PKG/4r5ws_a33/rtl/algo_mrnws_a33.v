module algo_mrnws_a33 (write, wr_adr, din,
                       read, rd_adr, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
                       whfifo_oflw, wlfifo_oflw, rhfifo_oflw, rlfifo_oflw, rdrob_uflw,
                       t1_writeA, t1_addrA, t1_dinA, t1_writeB, t1_addrB, t1_dinB,
                       t1_readC, t1_addrC, t1_doutC, t1_fwrdC, t1_serrC, t1_derrC, t1_padrC, t1_cinC, t1_vldC, t1_coutC,
                       t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_serrB, t2_derrB, t2_padrB, t2_cinB, t2_vldB, t2_coutB,
	               clk, rst, ready,
	               select_addr, select_bit, select_bnk, select_prio, select_vwrd, select_vrow, select_hrow, select_hvrw, select_lrow);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMWRPT = 4;
  parameter BITWRPT = 2;
  parameter NUMRDPT = 4;
  parameter BITRDPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMCELL = 80;
  parameter BITCELL = 7;
  parameter NUMQUEU = 9216;
  
  parameter NUMVBNK = 4;
  parameter BITVBNK = 2;
  parameter NUMVROW = 2048;
  parameter BITVROW = 11;
  parameter BITPADR = 14;

  parameter NUMHROW = 512;
  parameter BITHROW = 9;
  parameter NUMLROW = 1536;
  parameter BITLROW = 11;
  parameter BITHVRW = 7;
  parameter BITHPDR = BITHROW+1;

  parameter WFFOCNT = 16;
  parameter RFFOCNT = 16;
  parameter READ_DELAY = 8;
  parameter BITRDLY = 4;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter LPBKHDL = 10;
  parameter LPBKLDL = 12;
  parameter LPBKADL = 14;
 
  parameter BITCTRL = BITRDPT+BITRDLY;

  input [NUMWRPT-1:0]          write;
  input [NUMWRPT*BITADDR-1:0]  wr_adr;
  input [NUMWRPT*WIDTH-1:0]    din;

  input [NUMRDPT-1:0]          read;
  input [NUMRDPT*BITADDR-1:0]  rd_adr;
  output [NUMRDPT-1:0]         rd_vld;
  output [NUMRDPT*WIDTH-1:0]   rd_dout;
  output [NUMRDPT-1:0]         rd_fwrd;
  output [NUMRDPT-1:0]         rd_serr;
  output [NUMRDPT-1:0]         rd_derr;
  output [NUMRDPT*BITPADR-1:0] rd_padr;

  output [NUMVBNK-1:0]          whfifo_oflw;
  output [NUMVBNK-1:0]          wlfifo_oflw;
  output [NUMVBNK-1:0]          rhfifo_oflw;
  output [NUMVBNK-1:0]          rlfifo_oflw;
  output [NUMRDPT-1:0]          rdrob_uflw;

  output [NUMVBNK-1:0]          t1_writeA;
  output [NUMVBNK*BITHROW-1:0]  t1_addrA;
  output [NUMVBNK*WIDTH-1:0]    t1_dinA;
  output [NUMVBNK-1:0]          t1_writeB;
  output [NUMVBNK*BITHROW-1:0]  t1_addrB;
  output [NUMVBNK*WIDTH-1:0]    t1_dinB;
  output [NUMVBNK-1:0]          t1_readC;
  output [NUMVBNK*BITHROW-1:0]  t1_addrC;
  input [NUMVBNK*WIDTH-1:0]     t1_doutC;
  input [NUMVBNK-1:0]           t1_fwrdC;
  input [NUMVBNK-1:0]           t1_serrC;
  input [NUMVBNK-1:0]           t1_derrC;
  input [NUMVBNK*BITHPDR-1:0]   t1_padrC;
  output [NUMVBNK*BITCTRL-1:0]  t1_cinC;
  input [NUMVBNK-1:0]           t1_vldC;
  input [NUMVBNK*BITCTRL-1:0]   t1_coutC;

  output [NUMVBNK-1:0]          t2_writeA;
  output [NUMVBNK*BITLROW-1:0]  t2_addrA;
  output [NUMVBNK*WIDTH-1:0]    t2_dinA;
  output [NUMVBNK-1:0]          t2_readB;
  output [NUMVBNK*BITLROW-1:0]  t2_addrB;
  input [NUMVBNK*WIDTH-1:0]     t2_doutB;
  input [NUMVBNK-1:0]           t2_fwrdB;
  input [NUMVBNK-1:0]           t2_serrB;
  input [NUMVBNK-1:0]           t2_derrB;
  input [NUMVBNK*BITLROW-1:0]   t2_padrB;
  output [NUMVBNK*BITCTRL-1:0]  t2_cinB;
  input [NUMVBNK-1:0]           t2_vldB;
  input [NUMVBNK*BITCTRL-1:0]   t2_coutB;

  output                        ready;
  input                         clk;
  input                         rst;

  input [BITADDR-1:0]           select_addr;
  input [BITWDTH-1:0]           select_bit;
  input [BITVBNK-1:0]           select_bnk;
  input                         select_prio;
  input [BITCELL-BITVBNK-1:0]   select_vwrd;
  input [BITADDR-BITCELL-1:0]   select_vrow;
  input [BITHROW-1:0]           select_hrow;
  input [BITLROW-1:0]           select_lrow;
  input [BITHVRW-1:0]           select_hvrw;

  core_mrnws_a33 #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMRDPT (NUMRDPT), .BITRDPT (BITRDPT), .NUMWRPT (NUMWRPT), .BITWRPT (BITWRPT),
                   .NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMCELL (NUMCELL), .BITCELL (BITCELL),
                   .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                   .NUMHROW (NUMHROW), .BITHROW (BITHROW), .NUMLROW (NUMLROW), .BITLROW (BITLROW), .BITPADR (BITPADR), .BITHPDR(BITHPDR),
                   .READ_DELAY (READ_DELAY), .BITRDLY (BITRDLY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    core (.vwrite(write), .vwraddr(wr_adr), .vdin(din),
          .vread(read), .vrdaddr(rd_adr), .vread_vld(rd_vld), .vdout(rd_dout),
          .vread_fwrd(rd_fwrd), .vread_serr(rd_serr), .vread_derr(rd_derr), .vread_padr(rd_padr),
          .whfifo_oflw(whfifo_oflw), .wlfifo_oflw(wlfifo_oflw), .rhfifo_oflw(rhfifo_oflw), .rlfifo_oflw(rlfifo_oflw), .rdrob_uflw(rdrob_uflw),
          .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA),
          .t1_writeB(t1_writeB), .t1_addrB(t1_addrB), .t1_dinB(t1_dinB),
          .t1_readC(t1_readC), .t1_addrC(t1_addrC), .t1_doutC(t1_doutC),
          .t1_fwrdC(t1_fwrdC), .t1_serrC(t1_serrC), .t1_derrC(t1_derrC), .t1_padrC(t1_padrC),
          .t1_cinC(t1_cinC), .t1_vldC(t1_vldC), .t1_coutC(t1_coutC),
          .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA),
          .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
          .t2_fwrdB(t2_fwrdB), .t2_serrB(t2_serrB), .t2_derrB(t2_derrB), .t2_padrB(t2_padrB),
          .t2_cinB(t2_cinB), .t2_vldB(t2_vldB), .t2_coutB(t2_coutB),
          .clk(clk), .rst(rst), .ready(ready));

`ifdef FORMAL

ip_top_sva_mrnws_a33 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMRDPT     (NUMRDPT),
     .BITRDPT     (BITRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPADR     (BITPADR),
     .NUMHROW     (NUMHROW),
     .BITHROW     (BITHROW),
     .NUMLROW     (NUMLROW),
     .BITLROW     (BITLROW),
     .BITHVRW     (BITHVRW),
     .BITCTRL     (BITCTRL),
     .NUMCELL     (NUMCELL),     
     .BITCELL     (BITCELL),
     .NUMQUEU     (NUMQUEU),
     .RFFOCNT     (RFFOCNT),   
     .WFFOCNT     (WFFOCNT),   
     .READ_DELAY  (READ_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT),
     .LPBKHDL     (LPBKHDL),
     .LPBKLDL     (LPBKLDL),
     .LPBKADL     (LPBKADL)
   )
ip_top_sva (.*);

ip_top_sva_2_mrnws_a33 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMRDPT     (NUMRDPT),
     .BITRDPT     (BITRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMHROW     (NUMHROW),
     .BITHROW     (BITHROW),
     .NUMLROW     (NUMLROW),
     .BITLROW     (BITLROW),
     .BITHVRW     (BITHVRW),
     .BITCTRL     (BITCTRL),
     .NUMCELL     (NUMCELL),     
     .BITCELL     (BITCELL),
     .NUMQUEU     (NUMQUEU))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITADDR-1:0]         help_addr = sva_int;
  wire [BITWDTH-1:0]         help_bit = sva_int;
  wire [BITVBNK-1:0]         help_bnk = sva_int;
  wire [BITCELL-BITVBNK-1:0] help_vwrd = sva_int;
  wire [BITADDR-BITCELL-1:0] help _vrow = sva_int;
  wire [BITHROW-1:0]         help_hrow = sva_int;
  wire [BITLROW-1:0]         help _lrow = sva_int;
  wire [BITHVRW-1:0]         help _hvrw = sva_int;
ip_top_sva_mrnws_a33 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMRDPT     (NUMRDPT),
     .BITRDPT     (BITRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPADR     (BITPADR),
     .NUMHROW     (NUMHROW),
     .BITHROW     (BITHROW),
     .NUMLROW     (NUMLROW),
     .BITLROW     (BITLROW),
     .NUMCELL     (NUMCELL),     
     .BITCELL     (BITCELL),
     .NUMQUEU     (NUMQUEU),
     .RFFOCNT     (RFFOCNT),   
     .WFFOCNT     (WFFOCNT),   
     .READ_DELAY  (READ_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT),
     .LPBKHDL     (LPBKHDL),
     .LPBKLDL     (LPBKLDL),
     .LPBKADL     (LPBKADL))
   )
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .select_bnk(help_bnk), .select_prio(select_prio), .select_vwrd(select_vwrd), 
            .select_vrow(select_vrow), .select_hrow(select_hrow), .select_hvrw(select_hvrw), .select_lrow(select_lrow), .*);

ip_top_sva_2_mrnws_a33 #(
     .WIDTH       (WIDTH),
     .NUMRDPT     (NUMRDPT),
     .BITRDPT     (BITRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMHROW     (NUMHROW),
     .BITHROW     (BITHROW),
     .NUMLROW     (NUMLROW),
     .BITLROW     (BITLROW),
     .NUMCELL     (NUMCELL),     
     .BITCELL     (BITCELL),
     .NUMQUEU     (NUMQUEU))
ip_top_sva_2 (.select_addr(help_addr), .select_bit (help_bit), .select_bnk(help_bnk), .select_prio(select_prio), .select_vwrd(select_vwrd), 
              .select_vrow(select_vrow), .select_hrow(select_hrow), .select_hvrw(select_hvrw), .select_lrow(select_lrow), .*);

end
endgenerate

`endif
endmodule // algo_mrnws_a33

