
module algo_4ror1w_a3_top (clk, rst, ready,
                        write, wr_adr, din,
                        read, rd_adr, rd_vld, rd_dout,
	                t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA,
	                t2_readA, t2_writeA, t2_addrA, t2_dinA, t2_doutA,
	                t3_readA, t3_writeA, t3_addrA, t3_dinA, t3_doutA,
	                t4_readA, t4_writeA, t4_addrA, t4_dinA, t4_doutA);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW1 = 1024;
  parameter BITVROW1 = 10;
  parameter NUMVBNK1 = 8;
  parameter BITVBNK1 = 3;
  parameter BITPBNK1 = 4;
  parameter BITPADR1 = 15;
  parameter NUMVROW2 = 256;
  parameter BITVROW2 = 8;
  parameter NUMVBNK2 = 4;
  parameter BITVBNK2 = 2;
  parameter BITPBNK2 = 3;
  parameter BITPADR2 = 11;
  parameter SRAM_DELAY = 2;

  parameter MEMWDTH = WIDTH;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input [4-1:0]                  read;
  input [4*BITADDR-1:0]          rd_adr;
  output [4-1:0]                 rd_vld;
  output [4*WIDTH-1:0]           rd_dout;

  output                               ready;
  input                                clk, rst;

  output [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
  output [NUMVBNK1*NUMVBNK2*BITVROW2-1:0] t1_addrA;
  output [NUMVBNK1*NUMVBNK2*WIDTH-1:0] t1_dinA;
  input [NUMVBNK1*NUMVBNK2*WIDTH-1:0] t1_doutA;

  output [NUMVBNK1-1:0] t2_readA;
  output [NUMVBNK1-1:0] t2_writeA;
  output [NUMVBNK1*BITVROW2-1:0] t2_addrA;
  output [NUMVBNK1*WIDTH-1:0] t2_dinA;
  input [NUMVBNK1*WIDTH-1:0] t2_doutA;

  output [NUMVBNK2-1:0] t3_readA;
  output [NUMVBNK2-1:0] t3_writeA;
  output [NUMVBNK2*BITVROW2-1:0] t3_addrA;
  output [NUMVBNK2*WIDTH-1:0] t3_dinA;
  input [NUMVBNK2*WIDTH-1:0] t3_doutA;

  output [1-1:0] t4_readA;
  output [1-1:0] t4_writeA;
  output [1*BITVROW2-1:0] t4_addrA;
  output [1*WIDTH-1:0] t4_dinA;
  input [1*WIDTH-1:0] t4_doutA;

`ifdef FORMAL
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr == 0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit == 0));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

wire [BITVROW1-1:0] select_addr_a2;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK1), .BITVBNK (BITVBNK1),
  .NUMVROW (NUMVROW1), .BITVROW (BITVROW1))
  adr_a2 (.vbadr(), .vradr(select_addr_a2), .vaddr(select_addr));
`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITVROW1-1:0] select_addr_a2 = 0;
`endif

wire [2*NUMVBNK1-1:0] t1_readA_a1;
wire [2*NUMVBNK1-1:0] t1_writeA_a1;
wire [2*NUMVBNK1*BITVROW1-1:0] t1_addrA_a1;
wire [2*NUMVBNK1*WIDTH-1:0] t1_dinA_a1;
reg [2*NUMVBNK1*WIDTH-1:0] t1_doutA_a1;

wire [2-1:0] t3_readA_a1;
wire [2-1:0] t3_writeA_a1;
wire [2*BITVROW1-1:0] t3_addrA_a1;
wire [2*WIDTH-1:0] t3_dinA_a1;
wire [2*WIDTH-1:0] t3_doutA_a1;

wire [NUMVBNK1-1:0] t1_a2_ready;
wire t3_a3_ready;

generate begin: a1_loop

algo_nror1w #(.WIDTH (WIDTH), .PARITY (0), .BITWDTH (BITWDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMVRPT (4), .NUMPRPT (2),
              .NUMVROW (NUMVROW1), .BITVROW (BITVROW1), .NUMVBNK (NUMVBNK1), .BITVBNK (BITVBNK1), .BITPBNK (BITPBNK1),
              .BITPADR (BITPADR1), .REFRESH (0), .PASSPAR (0), .SRAM_DELAY (SRAM_DELAY))
    algo (.refr (),
	  .clk (clk),
	  .rst (rst || !(&t1_a2_ready) || !t3_a3_ready),
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
          .t1_readA (t1_readA_a1),
	  .t1_writeA (t1_writeA_a1),
	  .t1_addrA (t1_addrA_a1),
	  .t1_dinA (t1_dinA_a1),
	  .t1_doutA (t1_doutA_a1),
	  .t1_serrA (),
	  .t1_derrA (),
	  .t1_padrA (),
	  .t1_refrB (),
          .t2_readA (t3_readA_a1),
	  .t2_writeA (t3_writeA_a1),
	  .t2_addrA (t3_addrA_a1),
	  .t2_dinA (t3_dinA_a1),
	  .t2_doutA (t3_doutA_a1),
	  .t2_serrA (),
	  .t2_derrA (),
	  .t2_padrA (),
	  .t2_refrB (),
	  .select_addr (select_addr),
	  .select_bit (select_bit));

end
endgenerate

reg [2-1:0] t1_readA_a1_wire [0:NUMVBNK1-1];
reg t1_writeA_a1_wire [0:NUMVBNK1-1];
reg [2*BITVROW1-1:0] t1_radrA_a1_wire [0:NUMVBNK1-1];
reg [BITVROW1-1:0] t1_wadrA_a1_wire [0:NUMVBNK1-1];
reg [WIDTH-1:0] t1_dinA_a1_wire [0:NUMVBNK1-1];
wire [2*WIDTH-1:0] t1_doutA_a1_wire [0:NUMVBNK1-1];
integer a1_wire_int;
always_comb begin
  t1_doutA_a1 = 0;
  for (a1_wire_int=0; a1_wire_int<NUMVBNK1; a1_wire_int=a1_wire_int+1) begin
    t1_readA_a1_wire[a1_wire_int] = t1_readA_a1 >> (a1_wire_int*2);
    t1_writeA_a1_wire[a1_wire_int] = t1_writeA_a1 >> (a1_wire_int*2);
    t1_radrA_a1_wire[a1_wire_int] = t1_addrA_a1 >> (a1_wire_int*2*BITVROW1);
    t1_wadrA_a1_wire[a1_wire_int] = t1_addrA_a1 >> (a1_wire_int*BITVROW1);
    t1_dinA_a1_wire[a1_wire_int] = t1_dinA_a1 >> (a1_wire_int*2*WIDTH);
    t1_doutA_a1 = t1_doutA_a1 | (t1_doutA_a1_wire[a1_wire_int] << (a1_wire_int*2*WIDTH));
  end
end

wire [NUMVBNK2-1:0] t1_readA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2-1:0] t1_writeA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2*BITVROW2-1:0] t1_addrA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2*MEMWDTH-1:0] t1_dinA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2*MEMWDTH-1:0] t1_doutA_a2 [0:NUMVBNK1-1];

wire [1-1:0] t2_readA_a2 [0:NUMVBNK1-1];
wire [1-1:0] t2_writeA_a2 [0:NUMVBNK1-1];
wire [1*BITVROW2-1:0] t2_addrA_a2 [0:NUMVBNK1-1];
wire [1*MEMWDTH-1:0] t2_dinA_a2 [0:NUMVBNK1-1];
reg [1*MEMWDTH-1:0] t2_doutA_a2 [0:NUMVBNK1-1];

genvar a2_int;
generate for (a2_int=0; a2_int<NUMVBNK1; a2_int=a2_int+1) begin: a2_loop

algo_nror1w #(.WIDTH (WIDTH), .PARITY (0), .BITWDTH (BITWDTH), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1), .NUMVRPT (2), .NUMPRPT (1),
              .NUMVROW (NUMVROW2), .BITVROW (BITVROW2), .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2), .BITPBNK (BITPBNK2),
              .BITPADR (BITPADR2), .REFRESH (0), .PASSPAR (0), .SRAM_DELAY (SRAM_DELAY))
    algo (.refr (),
	  .clk (clk),
	  .rst (rst),
	  .ready (t1_a2_ready[a2_int]),
          .write (t1_writeA_a1_wire[a2_int]),
	  .wr_adr (t1_wadrA_a1_wire[a2_int]),
	  .din (t1_dinA_a1_wire[a2_int]),
	  .read (t1_readA_a1_wire[a2_int]),
	  .rd_adr (t1_radrA_a1_wire[a2_int]),
	  .rd_vld (),
	  .rd_dout (t1_doutA_a1_wire[a2_int]),
	  .rd_serr (),
	  .rd_derr (),
	  .rd_padr (),
          .t1_readA (t1_readA_a2[a2_int]),
	  .t1_writeA (t1_writeA_a2[a2_int]),
	  .t1_addrA (t1_addrA_a2[a2_int]),
	  .t1_dinA (t1_dinA_a2[a2_int]),
	  .t1_doutA (t1_doutA_a2[a2_int]),
	  .t1_serrA (),
	  .t1_derrA (),
	  .t1_padrA (),
	  .t1_refrB (),
          .t2_readA (t2_readA_a2[a2_int]),
	  .t2_writeA (t2_writeA_a2[a2_int]),
	  .t2_addrA (t2_addrA_a2[a2_int]),
	  .t2_dinA (t2_dinA_a2[a2_int]),
	  .t2_doutA (t2_doutA_a2[a2_int]),
	  .t2_serrA (),
	  .t2_derrA (),
	  .t2_padrA (),
	  .t2_refrB (),
	  .select_addr (select_addr_a2),
	  .select_bit (select_bit));

end
endgenerate

reg [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
reg [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
reg [NUMVBNK1*NUMVBNK2*BITVROW2-1:0] t1_addrA;
reg [NUMVBNK1*NUMVBNK2*MEMWDTH-1:0] t1_dinA;
//wire [NUMVBNK1*NUMVBNK2*MEMWDTH-1:0] t1_doutA;
reg [NUMVBNK1-1:0] t2_readA;
reg [NUMVBNK1-1:0] t2_writeA;
reg [NUMVBNK1*BITVROW2-1:0] t2_addrA;
reg [NUMVBNK1*MEMWDTH-1:0] t2_dinA;
//wire [NUMVBNK1*MEMWDTH-1:0] t2_doutA;
integer a2_wire_int;
always_comb begin
  t1_readA = 0;
  t1_writeA = 0;
  t1_addrA = 0;
  t1_dinA = 0;
  t2_readA = 0;
  t2_writeA = 0;
  t2_addrA = 0;
  t2_dinA = 0;
  for (a2_wire_int=0; a2_wire_int<NUMVBNK1; a2_wire_int=a2_wire_int+1) begin
    t1_readA = t1_readA | (t1_readA_a2[a2_wire_int] << (a2_wire_int*NUMVBNK2));
    t1_writeA = t1_writeA | (t1_writeA_a2[a2_wire_int] << (a2_wire_int*NUMVBNK2));
    t1_addrA = t1_addrA | (t1_addrA_a2[a2_wire_int] << (a2_wire_int*NUMVBNK2*BITVROW2));
    t1_dinA = t1_dinA | (t1_dinA_a2[a2_wire_int] << (a2_wire_int*NUMVBNK2*MEMWDTH));
    t2_readA = t2_readA | (t2_readA_a2[a2_wire_int] << a2_wire_int);
    t2_writeA = t2_writeA | (t2_writeA_a2[a2_wire_int] << a2_wire_int);
    t2_addrA = t2_addrA | (t2_addrA_a2[a2_wire_int] << (a2_wire_int*BITVROW2));
    t2_dinA = t2_dinA | (t2_dinA_a2[a2_wire_int] << (a2_wire_int*MEMWDTH));
    t1_doutA_a2[a2_wire_int] = t1_doutA >> (a2_wire_int*NUMVBNK2*MEMWDTH);
    t2_doutA_a2[a2_wire_int] = t2_doutA >> (a2_wire_int*MEMWDTH);
  end
end

wire [NUMVBNK2-1:0] t3_readA;
wire [NUMVBNK2-1:0] t3_writeA;
wire [NUMVBNK2*BITVROW2-1:0] t3_addrA;
wire [NUMVBNK2*MEMWDTH-1:0] t3_dinA;
wire [NUMVBNK2*MEMWDTH-1:0] t3_doutA;

wire [1-1:0] t4_readA;
wire [1-1:0] t4_writeA;
wire [1*BITVROW2-1:0] t4_addrA;
wire [1*MEMWDTH-1:0] t4_dinA;
wire [1*MEMWDTH-1:0] t4_doutA;

generate begin: a3_loop

algo_nror1w #(.WIDTH (WIDTH), .PARITY (0), .BITWDTH (BITWDTH), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1), .NUMVRPT (2), .NUMPRPT (1),
              .NUMVROW (NUMVROW2), .BITVROW (BITVROW2), .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2), .BITPBNK (BITPBNK2),
              .BITPADR (BITPADR2), .REFRESH (0), .PASSPAR (0), .SRAM_DELAY (SRAM_DELAY))
    algo (.refr (),
	  .clk (clk),
	  .rst (rst),
	  .ready (t3_a3_ready),
          .write (t3_writeA_a1[0]),
	  .wr_adr (t3_addrA_a1[BITVROW1-1:0]),
	  .din (t3_dinA_a1[WIDTH-1:0]),
	  .read (t3_readA_a1),
	  .rd_adr (t3_addrA_a1),
	  .rd_vld (),
	  .rd_dout (t3_doutA_a1),
	  .rd_serr (),
	  .rd_derr (),
	  .rd_padr (),
          .t1_readA (t3_readA),
	  .t1_writeA (t3_writeA),
	  .t1_addrA (t3_addrA),
	  .t1_dinA (t3_dinA),
	  .t1_doutA (t3_doutA),
	  .t1_serrA (),
	  .t1_derrA (),
	  .t1_padrA (),
	  .t1_refrB (),
          .t2_readA (t4_readA),
	  .t2_writeA (t4_writeA),
	  .t2_addrA (t4_addrA),
	  .t2_dinA (t4_dinA),
	  .t2_doutA (t4_doutA),
	  .t2_serrA (),
	  .t2_derrA (),
	  .t2_padrA (),
	  .t2_refrB (),
	  .select_addr (select_addr_a2),
	  .select_bit (select_bit));

end
endgenerate

endmodule
