
module algo_nr2w_1r1w (write, wr_adr, din,
                       read, rd_adr, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
                       t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                       t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_serrB, t2_derrB, t2_padrB,
                       t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB, t3_fwrdB, t3_serrB, t3_derrB, t3_padrB,
                       ready, clk, rst,
		       select_addr, select_bit) ;
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPSDO = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter NUMRDPT = 2;
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

  input [NUMRDPT-1:0]              read;
  input [NUMRDPT*BITADDR-1:0]      rd_adr;
  output [NUMRDPT-1:0]             rd_vld;
  output [NUMRDPT*WIDTH-1:0]       rd_dout;
  output [NUMRDPT-1:0]             rd_fwrd;
  output [NUMRDPT-1:0]             rd_serr;
  output [NUMRDPT-1:0]             rd_derr;
  output [NUMRDPT*BITPADR-1:0]     rd_padr;

  input [2-1:0]                    write;
  input [2*BITADDR-1:0]            wr_adr;
  input [2*WIDTH-1:0]              din;

  output                           ready;

  input                            clk;
  input                            rst;

  output [NUMRDPT*NUMVBNK-1:0] t1_writeA;
  output [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_dinA;

  output [NUMRDPT*NUMVBNK-1:0] t1_readB;
  output [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB;
  input [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_doutB;
  input [NUMRDPT*NUMVBNK-1:0] t1_fwrdB;
  input [NUMRDPT*NUMVBNK-1:0] t1_serrB;
  input [NUMRDPT*NUMVBNK-1:0] t1_derrB;
  input [NUMRDPT*NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrB;

  output [(NUMRDPT+1)-1:0] t2_writeA;
  output [(NUMRDPT+1)*BITVROW-1:0] t2_addrA;
  output [(NUMRDPT+1)*WIDTH-1:0] t2_dinA;

  output [(NUMRDPT+1)-1:0] t2_readB;
  output [(NUMRDPT+1)*BITVROW-1:0] t2_addrB;
  input [(NUMRDPT+1)*WIDTH-1:0] t2_doutB;
  input [(NUMRDPT+1)-1:0] t2_fwrdB;
  input [(NUMRDPT+1)-1:0] t2_serrB;
  input [(NUMRDPT+1)-1:0] t2_derrB;
  input [(NUMRDPT+1)*(BITPADR-BITPBNK)-1:0] t2_padrB;

  output [(NUMRDPT+2)-1:0] t3_writeA;
  output [(NUMRDPT+2)*BITVROW-1:0] t3_addrA;
  output [(NUMRDPT+2)*(BITVBNK+1)-1:0] t3_dinA;

  output [(NUMRDPT+2)-1:0] t3_readB;
  output [(NUMRDPT+2)*BITVROW-1:0] t3_addrB;
  input [(NUMRDPT+2)*(BITVBNK+1)-1:0] t3_doutB;
  input [(NUMRDPT+2)-1:0] t3_fwrdB;
  input [(NUMRDPT+2)-1:0] t3_serrB;
  input [(NUMRDPT+2)-1:0] t3_derrB;
  input [(NUMRDPT+2)*(BITPADR-BITPBNK)-1:0] t3_padrB;

  input [BITADDR-1:0] select_addr;
  input [BITWDTH-1:0] select_bit;

  core_nr2w_1r1w #(.BITWDTH (BITWDTH), .WIDTH (WIDTH), .ENAPSDO (ENAPSDO), .NUMRDPT (NUMRDPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                   .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR),
                   .SRAM_DELAY (SRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    core (.vread (read), .vrdaddr (rd_adr), .vread_vld (rd_vld), .vdout (rd_dout),
          .vread_fwrd(rd_fwrd), .vread_serr (rd_serr), .vread_derr (rd_derr), .vread_padr (rd_padr),
          .vwrite (write), .vwraddr (wr_adr), .vdin (din),
          .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
          .t1_fwrdB(t1_fwrdB), .t1_serrB(t1_serrB), .t1_derrB(t1_derrB), .t1_padrB(t1_padrB),
          .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
          .t2_fwrdB(t2_fwrdB), .t2_serrB(t2_serrB), .t2_derrB(t2_derrB), .t2_padrB(t2_padrB),
          .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB),
          .t3_fwrdB(t3_fwrdB), .t3_serrB(t3_serrB), .t3_derrB(t3_derrB), .t3_padrB(t3_padrB),
          .ready (ready), .clk (clk), .rst (rst));

`ifdef FORMAL
//wire [BITADDR-1:0] select_addr;
//wire [BITWDTH-1:0] select_bit;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_nr2w_1r1w #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMRDPT     (NUMRDPT),
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
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);

ip_top_sva_2_nr2w_1r1w #(
     .WIDTH       (WIDTH),
     .ENAPSDO     (ENAPSDO),
     .NUMRDPT     (NUMRDPT),
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
ip_top_sva_nr2w_1r1w #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMRDPT     (NUMRDPT),
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
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate


ip_top_sva_2_nr2w_1r1w #(
     .WIDTH       (WIDTH),
     .ENAPSDO     (ENAPSDO),
     .NUMRDPT     (NUMRDPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK))
ip_top_sva_2 (.*);

`endif

endmodule
