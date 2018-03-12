
module algo_1r2w_a7_top (clk, rst, ready,
                           write, wr_adr, din,
                           read, rd_adr, rd_vld, rd_dout,
			   t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
			   t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
			   t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter ECCDWIDTH = 4;
  parameter ECCBITS = 4;
  parameter SRAM_DELAY = 2;

  parameter NUMRPRT = 1;
  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input [2-1:0]                        write;
  input [2*BITADDR-1:0]                wr_adr;
  input [2*WIDTH-1:0]                  din;

  input [NUMRPRT-1:0]                  read;
  input [NUMRPRT*BITADDR-1:0]          rd_adr;
  output [NUMRPRT-1:0]                 rd_vld;
  output [NUMRPRT*WIDTH-1:0]           rd_dout;

  output                               ready;
  input                                clk, rst;

  output [NUMRPRT*NUMVBNK-1:0] t1_writeA;
  output [NUMRPRT*NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMRPRT*NUMVBNK*WIDTH-1:0] t1_dinA;
  output [NUMRPRT*NUMVBNK-1:0] t1_readB;
  output [NUMRPRT*NUMVBNK*BITVROW-1:0] t1_addrB;
  input [NUMRPRT*NUMVBNK*WIDTH-1:0] t1_doutB;

  output [(NUMRPRT+1)-1:0] t2_writeA;
  output [(NUMRPRT+1)*BITVROW-1:0] t2_addrA;
  output [(NUMRPRT+1)*WIDTH-1:0] t2_dinA;
  output [(NUMRPRT+1)-1:0] t2_readB;
  output [(NUMRPRT+1)*BITVROW-1:0] t2_addrB;
  input [(NUMRPRT+1)*WIDTH-1:0] t2_doutB;

  output [(NUMRPRT+2)-1:0] t3_writeA;
  output [(NUMRPRT+2)*BITVROW-1:0] t3_addrA;
  output [(NUMRPRT+2)*SDOUT_WIDTH-1:0] t3_dinA;
  output [(NUMRPRT+2)-1:0] t3_readB;
  output [(NUMRPRT+2)*BITVROW-1:0] t3_addrB;
  input [(NUMRPRT+2)*SDOUT_WIDTH-1:0] t3_doutB;

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

algo_nr2w_1r1w #(.BITWDTH (BITWDTH), .WIDTH (WIDTH), .NUMRPRT (NUMRPRT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
	         .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .SRAM_DELAY (SRAM_DELAY),
	         .ECCDWIDTH(ECCDWIDTH), .ECCBITS (ECCBITS))
  algo (.clk(clk), .rst(rst), .ready(ready),
        .write(write), .wr_adr(wr_adr), .din(din),
        .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_err(),
	.t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
        .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
        .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB),
	.select_addr(select_addr), .select_bit(select_bit));

end
endgenerate

endmodule
