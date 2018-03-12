
module algo_2nr4w_2r2w (write, wr_adr, din,
                        read, rd_adr, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
                        t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_padrB,
                        t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
                        t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
                        ready, clk, rst,
		        select_addr, select_bit) ;
  
  parameter BITWDTH = 5;
  parameter WIDTH = 32;
  parameter NUMDUPL = 1;
  parameter NUMRDPT = 2;
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
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter ECCBITS = 4;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input [NUMDUPL*NUMRDPT-1:0]              read;
  input [NUMDUPL*NUMRDPT*BITADDR-1:0]      rd_adr;
  output [NUMDUPL*NUMRDPT-1:0]             rd_vld;
  output [NUMDUPL*NUMRDPT*WIDTH-1:0]       rd_dout;
  output [NUMDUPL*NUMRDPT-1:0]             rd_fwrd;
  output [NUMDUPL*NUMRDPT-1:0]             rd_serr;
  output [NUMDUPL*NUMRDPT-1:0]             rd_derr;
  output [NUMDUPL*NUMRDPT*BITPADR-1:0]     rd_padr;

  input [2*NUMWRPT-1:0]                    write;
  input [2*NUMWRPT*BITADDR-1:0]            wr_adr;
  input [2*NUMWRPT*WIDTH-1:0]              din;

  output                                   ready;

  input                                    clk;
  input                                    rst;

  output [NUMWRPT*NUMVBNK-1:0] t1_writeA;
  output [NUMWRPT*NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMWRPT*NUMVBNK*WIDTH-1:0] t1_dinA;

  output [NUMDUPL*NUMRDPT*NUMVBNK-1:0] t1_readB;
  output [NUMDUPL*NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB;
  input [NUMDUPL*NUMRDPT*NUMVBNK*WIDTH-1:0] t1_doutB;
  input [NUMDUPL*NUMRDPT*NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrB;

  output [NUMWRPT-1:0] t2_writeA;
  output [NUMWRPT*BITVROW-1:0] t2_addrA;
  output [NUMWRPT*WIDTH-1:0] t2_dinA;

  output [NUMDUPL*NUMRDPT+NUMWRPT-1:0] t2_readB;
  output [(NUMDUPL*NUMRDPT+NUMWRPT)*BITVROW-1:0] t2_addrB;
  input [(NUMDUPL*NUMRDPT+NUMWRPT)*WIDTH-1:0] t2_doutB;

  output [NUMWRPT-1:0] t3_writeA;
  output [NUMWRPT*BITVROW-1:0] t3_addrA;
  output [NUMWRPT*SDOUT_WIDTH-1:0] t3_dinA;

  output [NUMDUPL*NUMRDPT+2*NUMWRPT-1:0] t3_readB;
  output [(NUMDUPL*NUMRDPT+2*NUMWRPT)*BITVROW-1:0] t3_addrB;
  input [(NUMDUPL*NUMRDPT+2*NUMWRPT)*SDOUT_WIDTH-1:0] t3_doutB;

  input [BITADDR-1:0] select_addr;
  input [BITWDTH-1:0] select_bit;

core_2nr4w_2r2w #(.BITWDTH (BITWDTH), .WIDTH (WIDTH), .NUMDUPL (NUMDUPL), .NUMRDPT (NUMRDPT), .NUMWRPT (NUMWRPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                  .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR),
                  .SRAM_DELAY (SRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT), .ECCBITS (ECCBITS))
    core (.vread (read), .vrdaddr (rd_adr), .vread_vld (rd_vld), .vdout (rd_dout),
          .vread_fwrd(rd_fwrd), .vread_serr (rd_serr), .vread_derr (rd_derr), .vread_padr (rd_padr),
          .vwrite (write), .vwraddr (wr_adr), .vdin (din),
          .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB), .t1_padrB(t1_padrB),
          .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
          .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB),
          .ready (ready), .clk (clk), .rst (rst));

`ifdef FORMAL
//wire [BITADDR-1:0] select_addr;
//wire [BITWDTH-1:0] select_bit;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_2nr4w_2r2w #(
     .BITWDTH     (BITWDTH),
     .WIDTH       (WIDTH),
     .NUMDUPL     (NUMDUPL),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPBNK     (BITPBNK),
     .BITPADR     (BITPADR),
     .ECCBITS     (ECCBITS),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);

ip_top_sva_2_2nr4w_2r2w #(
     .WIDTH       (WIDTH),
     .NUMDUPL     (NUMDUPL),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK))
ip_top_sva_2 (.*);

//`else
`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin : ip_top_sva
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_2nr4w_2r2w #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMDUPL     (NUMDUPL),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPBNK     (BITPBNK),
     .BITPADR     (BITPADR),
     .ECCBITS     (ECCBITS),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate


ip_top_sva_2_2nr4w_2r2w #(
     .WIDTH       (WIDTH),
     .NUMDUPL     (NUMDUPL),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK))
ip_top_sva_2 (.*);

`endif

endmodule
