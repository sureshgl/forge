
module algo_2ror1w_a2_top (clk, rst, ready,
                        write, wr_adr, din,
                        read, rd_adr, rd_vld, rd_dout,
	                t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA,
	                t2_readA, t2_writeA, t2_addrA, t2_dinA, t2_doutA);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter BITPADR = 15;
  parameter SRAM_DELAY = 2;

  parameter MEMWDTH = WIDTH;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input [2-1:0]                  read;
  input [2*BITADDR-1:0]          rd_adr;
  output [2-1:0]                 rd_vld;
  output [2*WIDTH-1:0]           rd_dout;

  output                               ready;
  input                                clk, rst;

  output [NUMVBNK-1:0] t1_readA;
  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMVBNK*WIDTH-1:0] t1_dinA;
  input [NUMVBNK*WIDTH-1:0] t1_doutA;

  output [1-1:0] t2_readA;
  output [1-1:0] t2_writeA;
  output [1*BITVROW-1:0] t2_addrA;
  output [1*WIDTH-1:0] t2_dinA;
  input [1*WIDTH-1:0] t2_doutA;

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

algo_nror1w #(
    .WIDTH (WIDTH), .PARITY (0), .BITWDTH (BITWDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMVRPT (2), .NUMPRPT (1),
    .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK),
    .BITPADR (BITPADR), .REFRESH (0), .PASSPAR (0), .SRAM_DELAY (SRAM_DELAY))
    algo (.refr (),
	  .clk (clk),
	  .rst (rst),
	  .ready (ready),
          .write (write),
	  .wr_adr (wr_adr),
	  .din (din),
	  .read (read),
	  .rd_adr (rd_adr),
	  .rd_vld (rd_vld),
	  .rd_dout (rd_dout),
	  .rd_serr (),
	  .rd_derr (),
	  .rd_padr (),
          .t1_readA (t1_readA),
	  .t1_writeA (t1_writeA),
	  .t1_addrA (t1_addrA),
	  .t1_dinA (t1_dinA),
	  .t1_doutA (t1_doutA),
	  .t1_serrA (),
	  .t1_derrA (),
	  .t1_padrA (),
	  .t1_refrB (),
          .t2_readA (t2_readA),
	  .t2_writeA (t2_writeA),
	  .t2_addrA (t2_addrA),
	  .t2_dinA (t2_dinA),
	  .t2_doutA (t2_doutA),
	  .t2_serrA (),
	  .t2_derrA (),
	  .t2_padrA (),
	  .t2_refrB (),
	  .select_addr (select_addr),
	  .select_bit (select_bit));

end
endgenerate

endmodule
