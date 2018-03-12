
module algo_1r1u_rl (clk, rst, ready,
                     write, din,
	             read, rd_adr, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
	             t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA, t1_fwrdA, t1_serrA, t1_derrA, t1_padrA,
	             t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_serrB, t2_derrB, t2_padrB,
                     t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB, t3_fwrdB, t3_serrB, t3_derrB, t3_padrB,
		     select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
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
  parameter SDOUT_WIDTH = BITVBNK+1;

  input                                write;
  input [WIDTH-1:0]                    din;

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

  output [NUMVBNK-1:0] t1_readA;
  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMVBNK*WIDTH-1:0] t1_dinA;
  input [NUMVBNK*WIDTH-1:0] t1_doutA;
  input [NUMVBNK-1:0] t1_fwrdA;
  input [NUMVBNK-1:0] t1_serrA;
  input [NUMVBNK-1:0] t1_derrA;
  input [NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrA;

  output t2_writeA;
  output [BITVROW-1:0] t2_addrA;
  output [WIDTH-1:0] t2_dinA;

  output t2_readB;
  output [BITVROW-1:0] t2_addrB;
  input [WIDTH-1:0] t2_doutB;
  input t2_fwrdB;
  input t2_serrB;
  input t2_derrB;
  input [BITVROW-1:0] t2_padrB;

  output t3_writeA;
  output [BITVROW-1:0] t3_addrA;
  output [SDOUT_WIDTH-1:0] t3_dinA;

  output t3_readB;
  output [BITVROW-1:0] t3_addrB;
  input [SDOUT_WIDTH-1:0] t3_doutB;
  input t3_fwrdB;
  input t3_serrB;
  input t3_derrB;
  input [BITVROW-1:0] t3_padrB;

  core_1r1u_rl #(.WIDTH (WIDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR),
                 .SRAM_DELAY (SRAM_DELAY),.FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
      core (.vread (read), .vrdaddr (rd_adr), .vread_vld (rd_vld), .vdout (rd_dout),
            .vread_fwrd (rd_fwrd), .vread_serr (rd_serr), .vread_derr (rd_derr), .vread_padr (rd_padr),
            .vwrite (write), .vdin (din),
            .t1_readA (t1_readA), .t1_writeA (t1_writeA), .t1_addrA (t1_addrA), .t1_dinA (t1_dinA),
            .t1_doutA (t1_doutA), .t1_fwrdA (t1_fwrdA), .t1_serrA (t1_serrA), .t1_derrA (t1_derrA), .t1_padrA (t1_padrA),
            .t2_writeA (t2_writeA), .t2_addrA (t2_addrA), .t2_dinA (t2_dinA),
            .t2_readB (t2_readB), .t2_addrB (t2_addrB), .t2_doutB (t2_doutB), .t2_fwrdB (t2_fwrdB), .t2_serrB (t2_serrB), .t2_derrB (t2_derrB), .t2_padrB (t2_padrB),
            .t3_writeA (t3_writeA), .t3_addrA (t3_addrA), .t3_dinA (t3_dinA),
            .t3_readB (t3_readB), .t3_addrB (t3_addrB), .t3_doutB (t3_doutB), .t3_fwrdB (t3_fwrdB), .t3_serrB (t3_serrB), .t3_derrB (t3_derrB), .t3_padrB (t3_padrB),
            .ready (ready), .clk (clk), .rst (rst));

`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_1r1u_rl #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
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

ip_top_sva_2_1r1u_rl #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .SRAM_DELAY  (SRAM_DELAY))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_1r1u_rl #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
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

ip_top_sva_2_1r1u_rl #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .SRAM_DELAY  (SRAM_DELAY))
ip_top_sva_2 (.*);

`endif

endmodule
