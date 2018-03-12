
module algo_2rw_1rw_top (clk, rst, ready,
                         read, write, addr, din, rd_vld, rd_dout,
                         t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA,
                         t2_readA, t2_writeA, t2_addrA, t2_dinA, t2_doutA,
                         t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
                         t4_writeA, t4_addrA, t4_dinA, t4_readB, t4_addrB, t4_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW1 = 1024;
  parameter BITVROW1 = 10;
  parameter NUMVBNK1 = 8;
  parameter BITVBNK1 = 3;
  parameter NUMVROW2 = 256;
  parameter BITVROW2 = 8;
  parameter NUMVBNK2 = 4;
  parameter BITVBNK2 = 2;
  parameter SRAM_DELAY = 2;
  parameter ECCDWIDTH = 4;
  parameter ECCBITS = 4;

  parameter SDOUT_WIDTH = 2*(BITVBNK1+1)+ECCBITS;

  input [2-1:0]                  read;
  input [2-1:0]                  write;
  input [2*BITADDR-1:0]          addr;
  input [2*WIDTH-1:0]            din;
  output [2-1:0]                 rd_vld;
  output [2*WIDTH-1:0]           rd_dout;

  output                         ready;
  input                          clk, rst;

  output [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
  output [NUMVBNK1*NUMVBNK2*BITVROW2-1:0] t1_addrA;
  output [NUMVBNK1*NUMVBNK2*WIDTH-1:0] t1_dinA;
  output [NUMVBNK1*NUMVBNK2*WIDTH-1:0] t1_doutA;

  output [NUMVBNK1-1:0] t2_readA;
  output [NUMVBNK1-1:0] t2_writeA;
  output [NUMVBNK1*BITVROW2-1:0] t2_addrA;
  output [NUMVBNK1*WIDTH-1:0] t2_dinA;
  input [NUMVBNK1*WIDTH-1:0] t2_doutA;

  output [2-1:0] t3_writeA;
  output [2*BITVROW1-1:0] t3_addrA;
  output [2*SDOUT_WIDTH-1:0] t3_dinA;
  output [2-1:0] t3_readB;
  output [2*BITVROW1-1:0] t3_addrB;
  input [2*SDOUT_WIDTH-1:0] t3_doutB;

  output [2-1:0] t4_writeA;
  output [2*BITVROW1-1:0] t4_addrA;
  output [2*WIDTH-1:0] t4_dinA;
  output [2-1:0] t4_readB;
  output [2*BITVROW1-1:0] t4_addrB;
  input [2*WIDTH-1:0] t4_doutB;

`ifdef FORMAL 
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr==0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit==0));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
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

wire [NUMVBNK1-1:0] t1_writeA_a1;
wire [NUMVBNK1*BITVROW1-1:0] t1_addrA_a1;
wire [NUMVBNK1*WIDTH-1:0] t1_dinA_a1;

wire [NUMVBNK1-1:0] t1_readB_a1;
wire [NUMVBNK1*BITVROW1-1:0] t1_addrB_a1;
reg [NUMVBNK1*WIDTH-1:0] t1_doutB_a1;

wire [NUMVBNK1-1:0] t1_readC_a1;
wire [NUMVBNK1*BITVROW1-1:0] t1_addrC_a1;
reg [NUMVBNK1*WIDTH-1:0] t1_doutC_a1;
/*
wire [NUMVBNK1-1:0] t1_writeA_a1;
wire [NUMVBNK1*BITVROW1-1:0] t1_addrA_a1;
wire [NUMVBNK1*WIDTH-1:0] t1_dinA_a1;

wire [NUMVBNK1-1:0] t1_readB_a1;
wire [NUMVBNK1*BITVROW1-1:0] t1_addrB_a1;
reg [NUMVBNK1*WIDTH-1:0] t1_doutB_a1;

wire [NUMVBNK1-1:0] t1_readC_a1;
wire [NUMVBNK1*BITVROW1-1:0] t1_addrC_a1;
reg [NUMVBNK1*WIDTH-1:0] t1_doutC_a1;
*/
wire [NUMVBNK1-1:0] t1_a2_ready;

generate begin: a1_loop

algo_2rw_2ror1w #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .NUMADDR(NUMADDR), .BITADDR(BITADDR),
                  .NUMVBNK(NUMVBNK1), .BITVBNK(BITVBNK1), .NUMVROW(NUMVROW1), .BITVROW(BITVROW1),
                  .SRAM_DELAY(SRAM_DELAY), .DRAM_DELAY(SRAM_DELAY), .ECCDWIDTH(ECCDWIDTH), .ECCBITS(ECCBITS))
  algo (.ready(ready), .clk(clk), .rst (rst || !(|t1_a2_ready)),
        .read(read),. write(write), .addr(addr), .din(din), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_err(),
        .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
        .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1),
        .t1_readC(t1_readC_a1), .t1_addrC(t1_addrC_a1), .t1_doutC(t1_doutC_a1),
        .t2_writeA(t3_writeA), .t2_addrA(t3_addrA), .t2_dinA(t3_dinA),
        .t2_readB(t3_readB), .t2_addrB(t3_addrB), .t2_doutB(t3_doutB),
        .t3_writeA(t4_writeA), .t3_addrA(t4_addrA), .t3_dinA(t4_dinA),
        .t3_readB(t4_readB), .t3_addrB(t4_addrB), .t3_doutB(t4_doutB),
	.select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

wire [NUMVBNK2-1:0] t1_readA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2-1:0] t1_writeA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2*BITVROW2-1:0] t1_addrA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2*WIDTH-1:0] t1_dinA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2*WIDTH-1:0] t1_doutA_a2 [0:NUMVBNK1-1];

wire t2_readA_a2 [0:NUMVBNK1-1];
wire t2_writeA_a2 [0:NUMVBNK1-1];
wire [BITVROW2-1:0] t2_addrA_a2 [0:NUMVBNK1-1];
wire [WIDTH-1:0] t2_dinA_a2 [0:NUMVBNK1-1];
reg [WIDTH-1:0] t2_doutA_a2 [0:NUMVBNK1-1];

wire [WIDTH-1:0] t1_doutB_a1_wire [0:NUMVBNK1-1];
wire [WIDTH-1:0] t1_doutC_a1_wire [0:NUMVBNK1-1];

integer t1_dout_int;
always_comb begin
  t1_doutB_a1 = 0;
  t1_doutC_a1 = 0;
  for (t1_dout_int=0; t1_dout_int<NUMVBNK1; t1_dout_int=t1_dout_int+1) begin
    t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[t1_dout_int] << (t1_dout_int*WIDTH));
    t1_doutC_a1 = t1_doutC_a1 | (t1_doutC_a1_wire[t1_dout_int] << (t1_dout_int*WIDTH));
  end
end

genvar a2;
generate for (a2=0; a2<NUMVBNK1; a2=a2+1) begin: a2_loop
  wire vwrite = t1_writeA_a1 >> a2;
  wire [BITVROW1-1:0] vwraddr = t1_addrA_a1 >> a2*BITVROW1;
  wire [WIDTH-1:0] vdin = t1_dinA_a1 >> a2*WIDTH;
  wire vread1 = t1_readB_a1 >> a2;
  wire [BITVROW1-1:0] vrdaddr1 = t1_addrB_a1 >> a2*BITVROW1;
  wire vread2 = t1_readC_a1 >> a2;
  wire [BITVROW1-1:0] vrdaddr2 = t1_addrC_a1 >> a2*BITVROW1;
  algo_nror1w #(.WIDTH (WIDTH), .PARITY(0), .BITWDTH(BITWDTH), .NUMADDR(NUMVROW1), .BITADDR(BITVROW1), .NUMVRPT(2), .NUMPRPT(1),
                .NUMVROW(NUMVROW2), .BITVROW(BITVROW2), .NUMVBNK(NUMVBNK2), .BITVBNK(BITVBNK2), .BITPBNK(1), .BITPADR(1),
                .REFRESH(0), .PASSPAR(0), .SRAM_DELAY(SRAM_DELAY))
    algo (.refr (), .ready (t1_a2_ready[a2]), .clk (clk), .rst (rst),
          .write (vwrite), .wr_adr (vwraddr), .din (vdin),
          .read ({vread2,vread1}), .rd_adr ({vrdaddr2,vrdaddr1}),
	  .rd_vld (),
          .rd_dout ({t1_doutC_a1_wire[a2],t1_doutB_a1_wire[a2]}), .rd_serr (), .rd_derr (), .rd_padr (),
          .t1_readA (t1_readA_a2[a2]),
          .t1_writeA (t1_writeA_a2[a2]),
          .t1_addrA (t1_addrA_a2[a2]),
          .t1_dinA (t1_dinA_a2[a2]),
          .t1_doutA (t1_doutA_a2[a2]),
	  .t1_serrA (), .t1_derrA (), .t1_padrA (), .t1_refrB (),
          .t2_readA (t2_readA_a2[a2]),
          .t2_writeA (t2_writeA_a2[a2]),
          .t2_addrA (t2_addrA_a2[a2]),
          .t2_dinA (t2_dinA_a2[a2]),
          .t2_doutA (t2_doutA_a2[a2]),
	  .t2_serrA (), .t2_derrA (), .t2_padrA (), .t2_refrB (),
	  .select_addr (select_addr_a2),
	  .select_bit (select_bit));
end
endgenerate

reg [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
reg [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
reg [NUMVBNK1*NUMVBNK2*BITVROW2-1:0] t1_addrA;
reg [NUMVBNK1*NUMVBNK2*WIDTH-1:0] t1_dinA;
//wire [NUMVBNK1*NUMVBNK2*WIDTH-1:0] t1_doutA;

reg [NUMVBNK1-1:0] t2_readA;
reg [NUMVBNK1-1:0] t2_writeA;
reg [NUMVBNK1*BITVROW2-1:0] t2_addrA;
reg [NUMVBNK1*WIDTH-1:0] t2_dinA;
//wire [NUMVBNK1*WIDTH-1:0] t2_doutA;

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
    t1_dinA = t1_dinA | (t1_dinA_a2[a2_wire_int] << (a2_wire_int*NUMVBNK2*WIDTH));
    t1_doutA_a2[a2_wire_int] = t1_doutA >> (a2_wire_int*NUMVBNK2*WIDTH);
    t2_readA = t2_readA | (t2_readA_a2[a2_wire_int] << (a2_wire_int));
    t2_writeA = t2_writeA | (t2_writeA_a2[a2_wire_int] << a2_wire_int);
    t2_addrA = t2_addrA | (t2_addrA_a2[a2_wire_int] << (a2_wire_int*BITVROW2));
    t2_dinA = t2_dinA | (t2_dinA_a2[a2_wire_int] << (a2_wire_int*WIDTH));
    t2_doutA_a2[a2_wire_int] = t2_doutA >> (a2_wire_int*WIDTH);
  end
end

endmodule
