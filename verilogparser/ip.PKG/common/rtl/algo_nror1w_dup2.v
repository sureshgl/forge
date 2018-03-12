module algo_nror1w_dup2 ( 
  clk, rst, 
  write, wr_adr, bw, din,
  read, rd_adr, rd_vld, rd_dout, flopout_en,
  t1_writeA, t1_addrA, t1_bwA, t1_dinA, 
  t1_readB, t1_addrB, t1_doutB,
  select_addr, select_bit);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter NUMRDPT = 4;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPADR = 13;
  parameter REFRESH = 0;
  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter FLOPWTH = 1;


  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    bw;
  input [WIDTH-1:0]                    din;

  input [NUMRDPT-1:0]                  read;
  input [NUMRDPT*BITADDR-1:0]          rd_adr;
  output [NUMRDPT-1:0]                 rd_vld;
  output [NUMRDPT*WIDTH-1:0]           rd_dout;

  input                                clk, rst;
  input [FLOPWTH-1:0]                  flopout_en;
  input [BITADDR-1:0]                  select_addr;
  input [BITWDTH-1:0]                  select_bit;

  output [NUMRDPT*NUMVBNK-1:0]         t1_writeA;
  output [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMRDPT*NUMVBNK*WIDTH-1:0]   t1_bwA;
  output [NUMRDPT*NUMVBNK*WIDTH-1:0]   t1_dinA;
  output [NUMRDPT*NUMVBNK-1:0]         t1_readB;
  output [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB;
  input [NUMRDPT*NUMVBNK*WIDTH-1:0]    t1_doutB;

  core_nror1w_dup2 #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMRDPT (NUMRDPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                    .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                    .SRAM_DELAY (SRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT), .FLOPWTH(FLOPWTH))
      core (.vwrite(write), .vwraddr(wr_adr), .vbw(bw), .vdin(din),
	        .vread(read), .vrdaddr(rd_adr), .vread_vld(rd_vld), .vdout(rd_dout), .flopout_en(flopout_en),
            .t1_writeA(t1_writeA), .t1_addrA(t1_addrA),.t1_bwA(t1_bwA), .t1_dinA(t1_dinA),
            .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
	        .clk (clk), .rst (rst));

`ifdef FORMAL
//synopsys translate_off

assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_nror1w_dup_ramwrap #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMRDPT     (NUMRDPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPWTH      (FLOPWTH),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);

ip_top_sva_2_nror1w_dup_ramwrap #(
     .WIDTH       (WIDTH),
     .NUMRDPT     (NUMRDPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK))

ip_top_sva_2 (.*);
//synopsys translate_on

`elsif SIM_SVA

genvar sva_int;
// generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin: sva_loop
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_nror1w_dup_ramwrap #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMRDPT     (NUMRDPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPWTH      (FLOPWTH),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

ip_top_sva_2_nror1w_dup_ramwrap #(
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

endmodule // algo_nror1w_dup2




