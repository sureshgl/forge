
module algo_2nr2w_dup (clk, rst, ready,
                       write, wr_adr, din,
                       read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
	               t1_writeA, t1_addrA, t1_dinA,
                       t1_readB, t1_addrB, t1_doutB, t1_serrB, t1_derrB, t1_padrB,
	               select_addr, select_bit);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMRDPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPADR = 14;

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  input [2-1:0]                        write;
  input [2*BITADDR-1:0]                wr_adr;
  input [2*WIDTH-1:0]                  din;

  input [2*NUMRDPT-1:0]                read;
  input [2*NUMRDPT*BITADDR-1:0]        rd_adr;
  output [2*NUMRDPT-1:0]               rd_vld;
  output [2*NUMRDPT*WIDTH-1:0]         rd_dout;
  output [2*NUMRDPT-1:0]               rd_serr;
  output [2*NUMRDPT-1:0]               rd_derr;
  output [2*NUMRDPT*BITPADR-1:0]       rd_padr;

  output                               ready;
  input                                clk, rst;

  input [BITADDR-1:0]                  select_addr;
  input [BITWDTH-1:0]                  select_bit;

  output [2*NUMRDPT*NUMVBNK-1:0]         t1_writeA;
  output [2*NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrA;
  output [2*NUMRDPT*NUMVBNK*WIDTH-1:0]   t1_dinA;

  output [2*NUMRDPT*NUMVBNK-1:0]         t1_readB;
  output [2*NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB;
  input [2*NUMRDPT*NUMVBNK*WIDTH-1:0]    t1_doutB;
  input [2*NUMRDPT*NUMVBNK-1:0]          t1_serrB;
  input [2*NUMRDPT*NUMVBNK-1:0]          t1_derrB;
  input [2*NUMRDPT*NUMVBNK*(BITPADR-BITVBNK-1)-1:0] t1_padrB;

  core_2nr2w_dup #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMRDPT (NUMRDPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                   .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPADR (BITPADR),
                   .SRAM_DELAY (SRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
      core (.vwrite(write), .vwraddr(wr_adr), .vdin(din),
	    .vread(read), .vrdaddr(rd_adr), .vread_vld(rd_vld), .vdout(rd_dout), .vread_serr(rd_serr), .vread_derr(rd_derr), .vread_padr(rd_padr),
            .pwrite(t1_writeA), .pwrradr(t1_addrA), .pdin (t1_dinA),
            .pread(t1_readB), .prdradr(t1_addrB), .pdout(t1_doutB), .pdout_serr(t1_serrB), .pdout_derr(t1_derrB), .pdout_padr(t1_padrB),
	    .ready (ready), .clk (clk), .rst (rst));

`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr == 0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit == 0));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_2nr2w_dup #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMRDPT     (NUMRDPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);

ip_top_sva_2_2nr2w_dup #(
     .WIDTH       (WIDTH),
     .NUMRDPT     (NUMRDPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
// generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin: sva_loop
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_2nr2w_dup #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMRDPT     (NUMRDPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

ip_top_sva_2_2nr2w_dup #(
     .WIDTH       (WIDTH),
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


