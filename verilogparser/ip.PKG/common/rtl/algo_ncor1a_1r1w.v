module algo_ncor1a_1r1w (cnt, ct_adr, imm, ct_vld, ct_serr, ct_derr,
                         read, write, addr, din, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
                         t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                         ready, clk, rst,
		         select_addr, select_bit);
  
  parameter BITWDTH = 5;
  parameter WIDTH = 32;
  parameter NUMCTPT = 2;
  parameter BITCTPT = 1;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter BITPADR = BITCTPT+BITADDR;
  parameter NUMSCNT = 1;
  parameter SRAM_DELAY = 2;
  parameter FLOPADD = 0;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  input [NUMCTPT-1:0]              cnt;
  input [NUMCTPT*BITADDR-1:0]      ct_adr;
  input [NUMCTPT*WIDTH-1:0]        imm;
  output [NUMCTPT-1:0]             ct_vld;
  output [NUMCTPT-1:0]             ct_serr;
  output [NUMCTPT-1:0]             ct_derr;

  input                            read;
  input                            write;
  input [BITADDR-1:0]              addr;
  input [WIDTH-1:0]                din;
  output                           rd_vld;
  output [WIDTH-1:0]               rd_dout;
  output                           rd_fwrd;
  output                           rd_serr;
  output                           rd_derr;
  output [BITPADR-1:0]             rd_padr;

  output                           ready;

  input                            clk;
  input                            rst;

  output [NUMCTPT-1:0] t1_writeA;
  output [NUMCTPT*BITADDR-1:0] t1_addrA;
  output [NUMCTPT*WIDTH-1:0] t1_dinA;

  output [NUMCTPT-1:0] t1_readB;
  output [NUMCTPT*BITADDR-1:0] t1_addrB;
  input [NUMCTPT*WIDTH-1:0] t1_doutB;
  input [NUMCTPT-1:0] t1_fwrdB;
  input [NUMCTPT-1:0] t1_serrB;
  input [NUMCTPT-1:0] t1_derrB;
  input [NUMCTPT*(BITPADR-BITCTPT)-1:0] t1_padrB;

  input [BITADDR-1:0] select_addr;
  input [BITWDTH-1:0] select_bit;

core_ncor1a_1r1w #(.BITWDTH (BITWDTH), .WIDTH (WIDTH), .NUMCTPT (NUMCTPT), .BITCTPT (BITCTPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR), .BITPADR (BITPADR),
                   .NUMSCNT (NUMSCNT), .SRAM_DELAY (SRAM_DELAY), .FLOPADD (FLOPADD), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    core (.vcnt (cnt), .vctaddr (ct_adr), .vimm (imm), .vcnt_vld (ct_vld), .vcnt_serr (ct_serr), .vcnt_derr (ct_derr),
          .vread (read), .vwrite (write), .vaddr (addr), .vdin (din),
          .vread_vld (rd_vld), .vdout (rd_dout), .vread_fwrd (rd_fwrd), .vread_serr (rd_serr), .vread_derr (rd_derr), .vread_padr (rd_padr),
          .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA),
          .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB), .t1_fwrdB(t1_fwrdB), .t1_serrB(t1_serrB), .t1_derrB(t1_derrB), .t1_padrB(t1_padrB),
          .ready (ready), .clk (clk), .rst (rst));

`ifdef FORMAL
//wire [BITADDR-1:0] select_addr;
//wire [BITWDTH-1:0] select_bit;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));

ip_top_sva_ncor1a_1r1w #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMCTPT     (NUMCTPT),
     .BITCTPT     (BITCTPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPADD     (FLOPADD),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);

ip_top_sva_2_ncor1a_1r1w #(
     .WIDTH       (WIDTH),
     .NUMCTPT     (NUMCTPT),
     .BITCTPT     (BITCTPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR))
ip_top_sva_2 (.*);

//`else
`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin : ip_top_sva
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;

  ip_top_sva_ncor1a_1r1w #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMCTPT     (NUMCTPT),
     .BITCTPT     (BITCTPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPADD     (FLOPADD),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
  ip_top_sva (.select_addr(help_addr), .select_bit(help_bit), .*);
end
endgenerate

ip_top_sva_2_ncor1a_1r1w #(
     .WIDTH       (WIDTH),
     .NUMCTPT     (NUMCTPT),
     .BITCTPT     (BITCTPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR))
ip_top_sva_2 (.*);

`endif

endmodule
