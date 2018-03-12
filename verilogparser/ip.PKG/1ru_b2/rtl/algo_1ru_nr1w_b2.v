
module algo_1ru_nr1w_b2 (clk, rst, ready,
                      write, addr, din,
                      read, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
		      t1_writeA, t1_addrA, t1_dinA,
                      t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
	              select_addr, select_bit);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter NUMRUPT = 4;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 256;
  parameter BITVROW = 8;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPADR = 14;
  parameter NUMCOLS = 4;
  parameter BITCOLS = 2;

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  input                                write;
  input [BITADDR-1:0]                  addr;
  input [WIDTH-1:0]                    din;

  input [NUMRUPT-1:0]                  read;
  output [NUMRUPT-1:0]                 rd_vld;
  output [NUMRUPT*WIDTH-1:0]           rd_dout;
  output [NUMRUPT-1:0]                 rd_fwrd;
  output [NUMRUPT-1:0]                 rd_serr;
  output [NUMRUPT-1:0]                 rd_derr;
  output [NUMRUPT*BITPADR-1:0]         rd_padr;

  output                               ready;
  input                                clk, rst;

  input [BITADDR-1:0]                  select_addr;
  input [BITWDTH-1:0]                  select_bit;

  output [NUMRUPT*NUMVBNK-1:0]         t1_writeA;
  output [NUMRUPT*NUMVBNK*(BITVROW+BITCOLS)-1:0] t1_addrA;
  output [NUMRUPT*NUMVBNK*WIDTH-1:0]   t1_dinA;

  output [NUMRUPT*NUMVBNK-1:0]         t1_readB;
  output [NUMRUPT*NUMVBNK*(BITVROW+BITCOLS)-1:0] t1_addrB;
  input [NUMRUPT*NUMVBNK*WIDTH-1:0]    t1_doutB;
  input [NUMRUPT*NUMVBNK-1:0]          t1_fwrdB;
  input [NUMRUPT*NUMVBNK-1:0]          t1_serrB;
  input [NUMRUPT*NUMVBNK-1:0]          t1_derrB;
  input [NUMRUPT*NUMVBNK*(BITPADR-BITVBNK)-1:0] t1_padrB;

  core_1ru_nr1w_b2 #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMRUPT (NUMRUPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                  .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPADR (BITPADR), .NUMCOLS (NUMCOLS), .BITCOLS (BITCOLS),
		  .SRAM_DELAY (SRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
      core (.vwrite(write), .vaddr(addr), .vdin(din),
	    .vread(read), .vread_vld(rd_vld), .vdout(rd_dout),
            .vread_fwrd(rd_fwrd), .vread_serr(rd_serr), .vread_derr(rd_derr), .vread_padr(rd_padr),
            .pwrite(t1_writeA), .pwrradr(t1_addrA), .pdin(t1_dinA),
            .pread(t1_readB), .prdradr(t1_addrB), .pdout(t1_doutB),
            .pdout_fwrd(t1_fwrdB), .pdout_serr(t1_serrB), .pdout_derr(t1_derrB), .pdout_padr(t1_padrB),
	    .ready (ready), .clk (clk), .rst (rst),
	    .select_addr (select_addr), .select_bit (select_bit));

`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_nr1w_dup #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMRDPT     (NUMRUPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPADR     (BITPADR),
     .NUMCOLS     (NUMCOLS),
     .BITCOLS     (BITCOLS),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);

ip_top_sva_2_nr1w_dup #(
     .WIDTH       (WIDTH),
     .NUMRDPT     (NUMRUPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMCOLS     (NUMCOLS),
     .BITCOLS     (BITCOLS),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
// generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin: sva_loop
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_nr1w_dup #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMRDPT     (NUMRUPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .BITPADR     (BITPADR),
     .NUMCOLS     (NUMCOLS),
     .BITCOLS     (BITCOLS),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

ip_top_sva_2_nr1w_dup #(
     .WIDTH       (WIDTH),
     .NUMRDPT     (NUMRUPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMCOLS     (NUMCOLS),
     .BITCOLS     (BITCOLS),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK))
ip_top_sva_2 (.*);

`endif

endmodule


