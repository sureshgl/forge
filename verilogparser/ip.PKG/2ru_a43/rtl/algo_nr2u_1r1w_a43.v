module algo_nr2u_1r1w_a43 (ru_write, ru_din,
                       ru_read, ru_addr, ru_vld, ru_dout, ru_fwrd, ru_serr, ru_derr, ru_padr,
                       t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                       t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_serrB, t2_derrB, t2_padrB,
                       t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB, t3_fwrdB, t3_serrB, t3_derrB, t3_padrB,
                       ready, clk, rst,
		       select_addr);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPSDO = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter NUMRUPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter BITPADR = 14;
  parameter SRAM_DELAY = 2;
  parameter UPD_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  input [NUMRUPT-1:0]              ru_read;
  input [NUMRUPT*BITADDR-1:0]      ru_addr;
  output [NUMRUPT-1:0]             ru_vld;
  output [NUMRUPT*WIDTH-1:0]       ru_dout;
  output [NUMRUPT-1:0]             ru_fwrd;
  output [NUMRUPT-1:0]             ru_serr;
  output [NUMRUPT-1:0]             ru_derr;
  output [NUMRUPT*BITPADR-1:0]     ru_padr;

  input [2-1:0]                    ru_write;
  input [2*WIDTH-1:0]              ru_din;

  output                           ready;

  input                            clk;
  input                            rst;

  output [NUMRUPT*NUMVBNK-1:0] t1_writeA;
  output [NUMRUPT*NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMRUPT*NUMVBNK*WIDTH-1:0] t1_dinA;

  output [NUMRUPT*NUMVBNK-1:0] t1_readB;
  output [NUMRUPT*NUMVBNK*BITVROW-1:0] t1_addrB;
  input [NUMRUPT*NUMVBNK*WIDTH-1:0] t1_doutB;
  input [NUMRUPT*NUMVBNK-1:0] t1_fwrdB;
  input [NUMRUPT*NUMVBNK-1:0] t1_serrB;
  input [NUMRUPT*NUMVBNK-1:0] t1_derrB;
  input [NUMRUPT*NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrB;

  output [(NUMRUPT)-1:0] t2_writeA;
  output [(NUMRUPT)*BITVROW-1:0] t2_addrA;
  output [(NUMRUPT)*WIDTH-1:0] t2_dinA;

  output [(NUMRUPT)-1:0] t2_readB;
  output [(NUMRUPT)*BITVROW-1:0] t2_addrB;
  input [(NUMRUPT)*WIDTH-1:0] t2_doutB;
  input [(NUMRUPT)-1:0] t2_fwrdB;
  input [(NUMRUPT)-1:0] t2_serrB;
  input [(NUMRUPT)-1:0] t2_derrB;
  input [(NUMRUPT)*(BITPADR-BITPBNK)-1:0] t2_padrB;

  output [(NUMRUPT)-1:0] t3_writeA;
  output [(NUMRUPT)*BITVROW-1:0] t3_addrA;
  output [(NUMRUPT)*(BITVBNK+1)-1:0] t3_dinA;

  output [(NUMRUPT)-1:0] t3_readB;
  output [(NUMRUPT)*BITVROW-1:0] t3_addrB;
  input [(NUMRUPT)*(BITVBNK+1)-1:0] t3_doutB;
  input [(NUMRUPT)-1:0] t3_fwrdB;
  input [(NUMRUPT)-1:0] t3_serrB;
  input [(NUMRUPT)-1:0] t3_derrB;
  input [(NUMRUPT)*(BITPADR-BITPBNK)-1:0] t3_padrB;

  input [BITADDR-1:0] select_addr;

  core_nr2u_1r1w_a43 #(.BITWDTH (BITWDTH), .WIDTH (WIDTH), .ENAPSDO (ENAPSDO), .NUMRUPT (NUMRUPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                   .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR),
                   .SRAM_DELAY (SRAM_DELAY), .UPD_DELAY (UPD_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    core (.vread (ru_read), .vaddr (ru_addr), .vread_vld (ru_vld), .vdout (ru_dout),
          .vread_fwrd(ru_fwrd), .vread_serr (ru_serr), .vread_derr (ru_derr), .vread_padr (ru_padr),
          .vwrite (ru_write), .vdin (ru_din),
          .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
          .t1_fwrdB(t1_fwrdB), .t1_serrB(t1_serrB), .t1_derrB(t1_derrB), .t1_padrB(t1_padrB),
          .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
          .t2_fwrdB(t2_fwrdB), .t2_serrB(t2_serrB), .t2_derrB(t2_derrB), .t2_padrB(t2_padrB),
          .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB),
          .t3_fwrdB(t3_fwrdB), .t3_serrB(t3_serrB), .t3_derrB(t3_derrB), .t3_padrB(t3_padrB),
          .ready (ready), .clk (clk), .rst (rst));

`ifdef FORMAL
wire [BITADDR-1:0] select_addr;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));

ip_top_sva_nr2u_1r1w #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMRUPT     (NUMRUPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPBNK     (BITPBNK),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .UPD_DELAY   (UPD_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);

ip_top_sva_2_nr2u_1r1w #(
     .WIDTH       (WIDTH),
     .ENAPSDO     (ENAPSDO),
     .NUMRUPT     (NUMRUPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT),
     .UPD_DELAY   (UPD_DELAY))
ip_top_sva_2 (.*);
`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin : ip_top_sva
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_nr2u_1r1w #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMRUPT     (NUMRUPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPBNK     (BITPBNK),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .UPD_DELAY   (UPD_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .*);
end
endgenerate


ip_top_sva_2_nr2u_1r1w #(
     .WIDTH       (WIDTH),
     .ENAPSDO     (ENAPSDO),
     .NUMRUPT     (NUMRUPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT),
     .UPD_DELAY   (UPD_DELAY))
ip_top_sva_2 (.*);

`endif

endmodule
