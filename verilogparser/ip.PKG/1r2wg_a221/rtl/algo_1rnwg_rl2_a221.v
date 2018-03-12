
module algo_1rnwg_rl2_a221 (clk, rst, ready,
                            write, wr_adr, din,
	                    read, rd_adr, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
	                    t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_padrB,
                            t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_padrB,
		            select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPSDO = 1;
  parameter NUMWRPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter BITPADR = 14;
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter ECCBITS = 4;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input [NUMWRPT-1:0]                  write;
  input [NUMWRPT*BITADDR-1:0]          wr_adr;
  input [NUMWRPT*WIDTH-1:0]            din;

  input                                read;
  input [BITADDR-1:0]                  rd_adr;
  output                               rd_vld;
  output [WIDTH-1:0]                   rd_dout;
  output                               rd_fwrd;
  output                               rd_serr;
  output                               rd_derr;
  output [BITPADR-1:0]                 rd_padr;

  input                                clk;
  input                                rst;
  output                               ready;

  input [BITADDR-1:0]                  select_addr;
  input [BITWDTH-1:0]                  select_bit;

  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMVBNK*WIDTH-1:0] t1_dinA;

  output [NUMVBNK-1:0] t1_readB;
  output [NUMVBNK*BITVROW-1:0] t1_addrB;
  input [NUMVBNK*WIDTH-1:0] t1_doutB;
  input [NUMVBNK-1:0] t1_fwrdB;
  input [NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrB;

  output [2*NUMWRPT-1:0] t2_writeA;
  output [2*NUMWRPT*BITVROW-1:0] t2_addrA;
  output [2*NUMWRPT*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA;

  output [2*NUMWRPT-1:0] t2_readB;
  output [2*NUMWRPT*BITVROW-1:0] t2_addrB;
  input [2*NUMWRPT*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB;
  input [2*NUMWRPT-1:0] t2_fwrdB;
  input [2*NUMWRPT*(BITPADR-BITPBNK)-1:0] t2_padrB;

  core_1rnwg_rl2_a221 #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPSDO (ENAPSDO), .NUMWRPT (NUMWRPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                        .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR),
                        .SRAM_DELAY (SRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT), .ECCBITS (ECCBITS))
       core (.vread (read), .vrdaddr (rd_adr), .vread_vld (rd_vld), .vdout (rd_dout),
             .vread_fwrd (rd_fwrd), .vread_serr (rd_serr), .vread_derr (rd_derr), .vread_padr (rd_padr),
             .vwrite (write), .vwraddr (wr_adr), .vdin (din),
             .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA),
             .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB), .t1_fwrdB(t1_fwrdB), .t1_padrB(t1_padrB),
             .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA),
             .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB), .t2_fwrdB(t2_fwrdB), .t2_padrB(t2_padrB),
             .ready (ready), .clk (clk), .rst (rst));

`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_1rnwg_rl2_a221 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPBNK     (BITPBNK),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT),
     .ECCBITS     (ECCBITS))
ip_top_sva (.*);

ip_top_sva_2_1rnwg_rl2_a221 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPSDO     (ENAPSDO),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .SRAM_DELAY  (SRAM_DELAY),
     .ECCBITS     (ECCBITS))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_1rnwg_rl2_a221 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPBNK     (BITPBNK),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT),
     .ECCBITS     (ECCBITS))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

ip_top_sva_2_1rnwg_rl2_a221 #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPSDO     (ENAPSDO),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .SRAM_DELAY  (SRAM_DELAY),
     .ECCBITS     (ECCBITS))
ip_top_sva_2 (.*);

`endif

endmodule
