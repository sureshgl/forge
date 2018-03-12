module algo_nw1ru_1r1w (st_write, st_adr, st_din,
                        read, write, addr, din, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
                        t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                        ready, clk, rst,
		        select_addr, select_bit);
  
  parameter BITWDTH = 5;
  parameter WIDTH = 32;
  parameter NUMSTPT = 2;
  parameter NUMPBNK = 3;
  parameter BITPBNK = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter BITPADR = BITPBNK+BITADDR;
  parameter SRAM_DELAY = 2;
  parameter UPDT_DELAY = 1;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter FLOPADD = 0;

  input [NUMSTPT-1:0]              st_write;
  input [NUMSTPT*BITADDR-1:0]      st_adr;
  input [NUMSTPT*WIDTH-1:0]        st_din;

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

  output [NUMPBNK-1:0] t1_writeA;
  output [NUMPBNK*BITADDR-1:0] t1_addrA;
  output [NUMPBNK*WIDTH-1:0] t1_dinA;

  output [NUMPBNK-1:0] t1_readB;
  output [NUMPBNK*BITADDR-1:0] t1_addrB;
  input [NUMPBNK*WIDTH-1:0] t1_doutB;
  input [NUMPBNK-1:0] t1_fwrdB;
  input [NUMPBNK-1:0] t1_serrB;
  input [NUMPBNK-1:0] t1_derrB;
  input [NUMPBNK*(BITPADR-BITPBNK)-1:0] t1_padrB;

  input [BITADDR-1:0] select_addr;
  input [BITWDTH-1:0] select_bit;

  core_nw1ru_1r1w #(.BITWDTH (BITWDTH), .WIDTH (WIDTH), .NUMSTPT (NUMSTPT), .NUMPBNK (NUMPBNK), .BITPBNK (BITPBNK),
                    .NUMADDR (NUMADDR), .BITADDR (BITADDR), .BITPADR (BITPADR),
                    .SRAM_DELAY (SRAM_DELAY), .UPDT_DELAY (UPDT_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    core (.vset (st_write), .vstaddr (st_adr), .vstin (st_din),
          .vread (read), .vwrite (write), .vaddr (addr), .vdin (din),
          .vread_vld (rd_vld), .vdout (rd_dout), .vread_fwrd (rd_fwrd), .vread_serr (rd_serr), .vread_derr (rd_derr), .vread_padr (rd_padr),
          .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA),
          .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
          .t1_fwrdB(t1_fwrdB), .t1_serrB(t1_serrB), .t1_derrB(t1_derrB), .t1_padrB(t1_padrB),
          .ready (ready), .clk (clk), .rst (rst));

`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));

ip_top_sva_nw1ru_1r1w #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMSTPT     (NUMSTPT),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .UPDT_DELAY  (UPDT_DELAY),
     .FLOPADD     (FLOPADD),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);

ip_top_sva_2_nw1ru_1r1w #(
     .WIDTH       (WIDTH),
     .NUMSTPT     (NUMSTPT),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .SRAM_DELAY  (SRAM_DELAY),
     .UPDT_DELAY  (UPDT_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR))
ip_top_sva_2 (.*);

//`else
`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin : ip_top_sva
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;

  ip_top_sva_nw1ru_1r1w #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMSTPT     (NUMSTPT),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .UPDT_DELAY  (UPDT_DELAY),
     .FLOPADD     (FLOPADD),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
  ip_top_sva (.select_addr(help_addr), .select_bit(help_bit), .*);
end
endgenerate

ip_top_sva_2_nw1ru_1r1w #(
     .WIDTH       (WIDTH),
     .NUMSTPT     (NUMSTPT),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR))
ip_top_sva_2 (.*);

`endif

endmodule
