module algo_mrnws_a34 (write, wr_adr, din,
                       read, rd_adr, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
                       wrfifo_oflw, rdfifo_oflw, rdrob_uflw,
                       t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB, t1_cinB, t1_vldB, t1_coutB,
	                   clk, rst, ready,
	                   select_addr, select_bit, select_bnk, select_vwrd, select_vrow, select_lrow);

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
  parameter BITQUEU = 10;
  
  parameter NUMVBNK = 4;
  parameter BITVBNK = 2;
  parameter NUMVROW = 2048;
  parameter BITVROW = 11;
  parameter BITPADR = 14;

  parameter NUMLROW = 8192;
  parameter BITLROW = 13;

  parameter WFFOCNT = 16;
  parameter RFFOCNT = 16;
  parameter BITWFFO = 4;
  parameter BITRFFO = 4;
  parameter READ_DELAY = 8;
  parameter BITRDLY = 4;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter LPBKDEL = 12;
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

  output [NUMVBNK-1:0]          wrfifo_oflw;
  output [NUMVBNK-1:0]          rdfifo_oflw;
  output [NUMRDPT-1:0]          rdrob_uflw;

  output [NUMVBNK-1:0]          t1_writeA;
  output [NUMVBNK*BITLROW-1:0]  t1_addrA;
  output [NUMVBNK*WIDTH-1:0]    t1_dinA;
  output [NUMVBNK-1:0]          t1_readB;
  output [NUMVBNK*BITLROW-1:0]  t1_addrB;
  input [NUMVBNK*WIDTH-1:0]     t1_doutB;
  input [NUMVBNK-1:0]           t1_fwrdB;
  input [NUMVBNK-1:0]           t1_serrB;
  input [NUMVBNK-1:0]           t1_derrB;
  input [NUMVBNK*BITLROW-1:0]   t1_padrB;
  output [NUMVBNK*BITCTRL-1:0]  t1_cinB;
  input [NUMVBNK-1:0]           t1_vldB;
  input [NUMVBNK*BITCTRL-1:0]   t1_coutB;

  output                        ready;
  input                         clk;
  input                         rst;

  input [BITADDR-1:0]           select_addr;
  input [BITWDTH-1:0]           select_bit;
  input [BITVBNK-1:0]           select_bnk;
  input [BITCELL-1:0]                   select_vwrd;
  input [BITADDR-BITCELL-BITVBNK-1:0]   select_vrow;
  input [BITLROW-1:0]                select_lrow;

  core_mrnws_a34 #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMRDPT (NUMRDPT), .BITRDPT (BITRDPT), .NUMWRPT (NUMWRPT), .BITWRPT (BITWRPT),
                   .NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMCELL (NUMCELL), .BITCELL (BITCELL), .NUMQUEU(NUMQUEU), .BITQUEU(BITQUEU),
                   .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPADR (BITPADR),
                   .BITLROW(BITLROW),
                   .READ_DELAY (READ_DELAY), .BITRDLY (BITRDLY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    core (.vwrite(write), .vwraddr(wr_adr), .vdin(din),
          .vread(read), .vrdaddr(rd_adr), .vread_vld(rd_vld), .vdout(rd_dout),
          .vread_fwrd(rd_fwrd), .vread_serr(rd_serr), .vread_derr(rd_derr), .vread_padr(rd_padr),
          .wrfifo_oflw(wrfifo_oflw), .rdfifo_oflw(rdfifo_oflw), .rdrob_uflw(rdrob_uflw),
          .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA),
          .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
          .t1_fwrdB(t1_fwrdB), .t1_serrB(t1_serrB), .t1_derrB(t1_derrB), .t1_padrB(t1_padrB),
          .t1_cinB(t1_cinB), .t1_vldB(t1_vldB), .t1_coutB(t1_coutB),
          .clk(clk), .rst(rst), .ready(ready));

`ifdef FORMAL

ip_top_sva_mrnws_a34 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMRDPT     (NUMRDPT),
     .BITRDPT     (BITRDPT),
     .NUMWRPT     (NUMWRPT),
     .BITWRPT     (BITWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPADR     (BITPADR),
     .BITCTRL     (BITCTRL),
     .NUMCELL     (NUMCELL),     
     .BITCELL     (BITCELL),
     .NUMQUEU     (NUMQUEU),
     .BITQUEU     (BITQUEU),
     .NUMLROW     (NUMLROW),
     .BITLROW     (BITLROW),
     .RFFOCNT     (RFFOCNT),   
     .WFFOCNT     (WFFOCNT),   
     .READ_DELAY  (READ_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT),
     .LPBKDEL     (LPBKDEL),
     .LPBKADL     (LPBKADL)
   )
ip_top_sva (.*);

ip_top_sva_2_mrnws_a34 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMRDPT     (NUMRDPT),
     .BITRDPT     (BITRDPT),
     .NUMWRPT     (NUMWRPT),
     .BITWRPT     (BITWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .BITCTRL     (BITCTRL),
     .NUMCELL     (NUMCELL),     
     .NUMLROW     (NUMLROW),
     .BITLROW     (BITLROW),
     .BITCELL     (BITCELL),
     .NUMQUEU     (NUMQUEU),
     .BITQUEU     (BITQUEU))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITADDR-1:0]         help_addr = sva_int;
  wire [BITWDTH-1:0]         help_bit = sva_int;
  wire [BITVBNK-1:0]         help_bnk = sva_int;
  wire [BITCELL-BITVBNK-1:0] help_vwrd = sva_int;
  wire [BITADDR-BITCELL-1:0] help _vrow = sva_int;
  wire [BITLROW-1:0]         help _lrow = sva_int;
ip_top_sva_mrnws_a34 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMRDPT     (NUMRDPT),
     .BITRDPT     (BITRDPT),
     .NUMWRPT     (NUMWRPT),
     .BITWRPT     (BITWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPADR     (BITPADR),
     .NUMCELL     (NUMCELL),     
     .BITCELL     (BITCELL),
     .NUMQUEU     (NUMQUEU),
     .BITQUEU     (BITQUEU),
     .NUMLROW     (NUMLROW),
     .BITLROW     (BITLROW),
     .RFFOCNT     (RFFOCNT),   
     .WFFOCNT     (WFFOCNT),   
     .READ_DELAY  (READ_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT),
     .LPBKDEL     (LPBKDEL),
     .LPBKADL     (LPBKADL))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .select_bnk(help_bnk), .select_vwrd(select_vwrd), 
            .select_vrow(select_vrow), .select_lrow(select_lrow), .*);

ip_top_sva_2_mrnws_a34 #(
     .WIDTH       (WIDTH),
     .NUMRDPT     (NUMRDPT),
     .BITRDPT     (BITRDPT),
     .NUMWRPT     (NUMWRPT),
     .BITWRPT     (BITWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMCELL     (NUMCELL),     
     .BITCELL     (BITCELL),
     .NUMQUEU     (NUMQUEU),
     .BITQUEU     (BITQUEU),
     .BITLROW     (BITLROW))
ip_top_sva_2 (.select_addr(help_addr), .select_bit (help_bit), .select_bnk(help_bnk), .select_vwrd(select_vwrd), 
              .select_vrow(select_vrow), .select_lrow(select_lrow), .*);

end
endgenerate

`endif
endmodule
