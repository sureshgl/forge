
module algo_1r1w_a1_top (clk, rst, ready,
                         write, wr_adr, din,
                         read, rd_adr, rd_vld, rd_dout,
	                 t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA,
	                 t2_readB, t2_writeA, t2_addrA, t2_addrB, t2_dinA, t2_doutB);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter SRAM_DELAY = 2;
  parameter ECCDWIDTH = 4;
  parameter ECCBITS = 4;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input                                read;
  input [BITADDR-1:0]                  rd_adr;
  output                               rd_vld;
  output [WIDTH-1:0]                   rd_dout;

  output                               ready;
  input                                clk, rst;

  output [NUMVBNK-1:0] t1_readA;
  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMVBNK*WIDTH-1:0] t1_dinA;
  input [NUMVBNK*WIDTH-1:0] t1_doutA;

  output [2-1:0] t2_writeA;
  output [2*BITVROW-1:0] t2_addrA;
  output [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA;

  output [2-1:0] t2_readB;
  output [2*BITVROW-1:0] t2_addrB;
  input [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB;

`ifdef FORMAL
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr == 0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit == 0));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
`endif

generate begin: a1_loop

algo_1r1w_rl2_a1 #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
		.NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
		.SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (SRAM_DELAY), .ECCDWIDTH (ECCDWIDTH), .ECCBITS (ECCBITS))
  algo (.clk(clk), .rst(rst), .ready(ready),
        .write(write), .wr_adr(wr_adr), .din(din),
        .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_err(),
        .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA),
        .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
	.select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

endmodule
