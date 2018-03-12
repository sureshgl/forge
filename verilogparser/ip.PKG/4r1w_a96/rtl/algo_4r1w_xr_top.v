
module algo_4r1w_xr_top (clk, rst, ready,
                         write, wr_adr, din,
                         read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
	                 t1_readA, t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_doutA,
	                 t1_readB, t1_writeB, t1_addrB, t1_bwB, t1_dinB, t1_doutB,
	                 t2_readA, t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_doutA,
	                 t2_readB, t2_writeB, t2_addrB, t2_bwB, t2_dinB, t2_doutB,
	                 t3_readA, t3_writeA, t3_addrA, t3_bwA, t3_dinA, t3_doutA,
	                 t3_readB, t3_writeB, t3_addrB, t3_bwB, t3_dinB, t3_doutB,
	                 t4_readA, t4_writeA, t4_addrA, t4_bwA, t4_dinA, t4_doutA,
	                 t4_readB, t4_writeB, t4_addrB, t4_bwB, t4_dinB, t4_doutB);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter PARITY = 1;       // PARITY Parameters
  parameter MEMWDTH = WIDTH+PARITY;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW1 = 1024;
  parameter BITVROW1 = 10;
  parameter NUMVBNK1 = 8;
  parameter BITVBNK1 = 3;
  parameter BITPBNK1 = 4;
  parameter NUMWRDS1 = 4;      // ALIGN Parameters
  parameter BITWRDS1 = 2;
  parameter NUMSROW1 = 256;
  parameter BITSROW1 = 8;
  parameter PHYWDTH1 = NUMWRDS1*MEMWDTH;
  parameter FLOPIN1 = 0;
  parameter FLOPOUT1 = 0;
  parameter NUMVROW2 = 256;
  parameter BITVROW2 = 8;
  parameter NUMVBNK2 = 4;
  parameter BITVBNK2 = 2;
  parameter BITPBNK2 = 3;
  parameter NUMWRDS2 = 4;      // ALIGN Parameters
  parameter BITWRDS2 = 2;
  parameter NUMSROW2 = 64;
  parameter BITSROW2 = 6;
  parameter PHYWDTH2 = NUMWRDS2*MEMWDTH;
  parameter FLOPIN2 = 0;
  parameter FLOPOUT2 = 0;
  parameter SRAM_DELAY = 2;
  parameter FLOPMEM = 0;

  parameter BITPADR2 = BITPBNK2+BITSROW2+BITWRDS2+1;
  parameter BITPADR1 = BITPBNK1+BITPADR2+1;

  input                          write;
  input [BITADDR-1:0]            wr_adr;
  input [WIDTH-1:0]              din;

  input [4-1:0]                  read;
  input [4*BITADDR-1:0]          rd_adr;
  output [4-1:0]                 rd_vld;
  output [4*WIDTH-1:0]           rd_dout;
  output [4-1:0]                 rd_serr;
  output [4-1:0]                 rd_derr;
  output [4*BITPADR1-1:0]        rd_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
  output [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_doutA;

  output [NUMVBNK1*NUMVBNK2-1:0] t1_readB;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_writeB;
  output [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrB;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwB;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinB;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_doutB;

  output [NUMVBNK1-1:0] t2_readA;
  output [NUMVBNK1-1:0] t2_writeA;
  output [NUMVBNK1*BITSROW2-1:0] t2_addrA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_bwA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_dinA;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_doutA;

  output [NUMVBNK1-1:0] t2_readB;
  output [NUMVBNK1-1:0] t2_writeB;
  output [NUMVBNK1*BITSROW2-1:0] t2_addrB;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_bwB;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_dinB;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_doutB;

  output [NUMVBNK2-1:0] t3_readA;
  output [NUMVBNK2-1:0] t3_writeA;
  output [NUMVBNK2*BITSROW2-1:0] t3_addrA;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_bwA;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_dinA;
  input [NUMVBNK2*PHYWDTH2-1:0] t3_doutA;
  
  output [NUMVBNK2-1:0] t3_readB;
  output [NUMVBNK2-1:0] t3_writeB;
  output [NUMVBNK2*BITSROW2-1:0] t3_addrB;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_bwB;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_dinB;
  input [NUMVBNK2*PHYWDTH2-1:0] t3_doutB;
  
  output [1-1:0] t4_readA;
  output [1-1:0] t4_writeA;
  output [1*BITSROW2-1:0] t4_addrA;
  output [1*PHYWDTH2-1:0] t4_bwA;
  output [1*PHYWDTH2-1:0] t4_dinA;
  input [1*PHYWDTH2-1:0] t4_doutA;

  output [1-1:0] t4_readB;
  output [1-1:0] t4_writeB;
  output [1*BITSROW2-1:0] t4_addrB;
  output [1*PHYWDTH2-1:0] t4_bwB;
  output [1*PHYWDTH2-1:0] t4_dinB;
  input [1*PHYWDTH2-1:0] t4_doutB;

`ifdef FORMAL
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr == 0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit == 0));
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
  
wire [BITVROW2-1:0] select_vrow_a2;
np2_addr #(
  .NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
  .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2),
  .NUMVROW (NUMVROW2), .BITVROW (BITVROW2))
  row_a2 (.vbadr(), .vradr(select_vrow_a2), .vaddr(select_addr_a2));
`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITVROW1-1:0] select_addr_a2 = 0;
wire [BITVROW2-1:0] select_vrow_a2 = 0;
`endif

wire [2*NUMVBNK1-1:0] t1_readA_a1;
wire [2*NUMVBNK1-1:0] t1_writeA_a1;
wire [2*NUMVBNK1*BITVROW1-1:0] t1_addrA_a1;
wire [2*NUMVBNK1*WIDTH-1:0] t1_dinA_a1;
reg [2*NUMVBNK1*WIDTH-1:0] t1_doutA_a1;
reg [2*NUMVBNK1-1:0] t1_serrA_a1;
reg [2*NUMVBNK1-1:0] t1_derrA_a1;
reg [2*NUMVBNK1*BITPADR2-1:0] t1_padrA_a1;
  
wire [2*NUMVBNK1-1:0] t1_readB_a1;
wire [2*NUMVBNK1-1:0] t1_writeB_a1;
wire [2*NUMVBNK1*BITVROW1-1:0] t1_addrB_a1;
wire [2*NUMVBNK1*WIDTH-1:0] t1_dinB_a1;
reg [2*NUMVBNK1*WIDTH-1:0] t1_doutB_a1;
reg [2*NUMVBNK1-1:0] t1_serrB_a1;
reg [2*NUMVBNK1-1:0] t1_derrB_a1;
reg [2*NUMVBNK1*BITPADR2-1:0] t1_padrB_a1;
  
wire [2-1:0] t3_readA_a1;
wire [2-1:0] t3_writeA_a1;
wire [2*BITVROW1-1:0] t3_addrA_a1;
wire [2*WIDTH-1:0] t3_dinA_a1;
reg [2*WIDTH-1:0] t3_doutA_a1;
reg [2-1:0] t3_serrA_a1;
reg [2-1:0] t3_derrA_a1;
reg [2*BITPADR2-1:0] t3_padrA_a1;

wire [2-1:0] t3_readB_a1;
wire [2-1:0] t3_writeB_a1;
wire [2*BITVROW1-1:0] t3_addrB_a1;
wire [2*WIDTH-1:0] t3_dinB_a1;
reg [2*WIDTH-1:0] t3_doutB_a1;
reg [2-1:0] t3_serrB_a1;
reg [2-1:0] t3_derrB_a1;
reg [2*BITPADR2-1:0] t3_padrB_a1;

wire [NUMVBNK1-1:0] t1_a2_ready;
wire t3_a3_ready;

generate if (1) begin: a1_loop

algo_nr1w_2rw #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMVRPT (4), .NUMPRPT (2),
                .NUMVROW (NUMVROW1), .BITVROW (BITVROW1), .NUMVBNK (NUMVBNK1), .BITVBNK (BITVBNK1), .BITPBNK (BITPBNK1),
                .BITPADR (BITPADR1), .SRAM_DELAY (SRAM_DELAY+FLOPMEM+FLOPIN2+FLOPOUT2), .FLOPIN (FLOPIN1), .FLOPOUT (FLOPOUT1))
    algo (.clk (clk), .rst (rst || !(&t1_a2_ready) || !t3_a3_ready), .ready (ready),
          .write1 (write), .read1 (1'b0), .addr1 (wr_adr), .din1 (din), .rd1_dout (), .rd1_serr (), .rd1_derr (), .rd1_padr (),
	  .read2 (read), .addr2 (rd_adr), .rd2_vld (rd_vld), .rd2_dout (rd_dout), .rd2_serr (rd_serr), .rd2_derr (rd_derr), .rd2_padr (rd_padr),
          .t1_readA (t1_readA_a1), .t1_writeA (t1_writeA_a1), .t1_addrA (t1_addrA_a1), .t1_dinA (t1_dinA_a1),
	  .t1_doutA (t1_doutA_a1), .t1_serrA (t1_serrA_a1), .t1_derrA (t1_derrA_a1), .t1_padrA (t1_padrA_a1),
          .t1_readB (t1_readB_a1), .t1_writeB (t1_writeB_a1), .t1_addrB (t1_addrB_a1), .t1_dinB (t1_dinB_a1),
	  .t1_doutB (t1_doutB_a1), .t1_serrB (t1_serrB_a1), .t1_derrB (t1_derrB_a1), .t1_padrB (t1_padrB_a1),
          .t2_readA (t3_readA_a1), .t2_writeA (t3_writeA_a1), .t2_addrA (t3_addrA_a1), .t2_dinA (t3_dinA_a1),
	  .t2_doutA (t3_doutA_a1), .t2_serrA (t3_serrA_a1), .t2_derrA (t3_derrA_a1), .t2_padrA (t3_padrA_a1),
          .t2_readB (t3_readB_a1), .t2_writeB (t3_writeB_a1), .t2_addrB (t3_addrB_a1), .t2_dinB (t3_dinB_a1),
	  .t2_doutB (t3_doutB_a1), .t2_serrB (t3_serrB_a1), .t2_derrB (t3_derrB_a1), .t2_padrB (t3_padrB_a1),
	  .select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

reg [2-1:0] t1_readA_a1_wire [0:NUMVBNK1-1];
reg t1_writeA_a1_wire [0:NUMVBNK1-1];
reg [2*BITVROW1-1:0] t1_addrA_a1_wire [0:NUMVBNK1-1];
reg [2*WIDTH-1:0] t1_dinA_a1_wire [0:NUMVBNK1-1];
reg [2-1:0] t1_readB_a1_wire [0:NUMVBNK1-1];
reg t1_writeB_a1_wire [0:NUMVBNK1-1];
reg [2*BITVROW1-1:0] t1_addrB_a1_wire [0:NUMVBNK1-1];
reg [2*WIDTH-1:0] t1_dinB_a1_wire [0:NUMVBNK1-1];
wire [2*WIDTH-1:0] t1_doutA_a1_wire [0:NUMVBNK1-1];
wire [2-1:0] t1_serrA_a1_wire [0:NUMVBNK1-1];
wire [2-1:0] t1_derrA_a1_wire [0:NUMVBNK1-1];
wire [2*BITPADR2-1:0] t1_padrA_a1_wire [0:NUMVBNK1-1];
wire [2*WIDTH-1:0] t1_doutB_a1_wire [0:NUMVBNK1-1];
wire [2-1:0] t1_serrB_a1_wire [0:NUMVBNK1-1];
wire [2-1:0] t1_derrB_a1_wire [0:NUMVBNK1-1];
wire [2*BITPADR2-1:0] t1_padrB_a1_wire [0:NUMVBNK1-1];
integer a1_wire_int; 
always_comb begin
  t1_doutA_a1 = 0;
  t1_serrA_a1 = 0;
  t1_derrA_a1 = 0; 
  t1_padrA_a1 = 0;
  t1_doutB_a1 = 0;
  t1_serrB_a1 = 0;
  t1_derrB_a1 = 0; 
  t1_padrB_a1 = 0;
  for (a1_wire_int=0; a1_wire_int<NUMVBNK1; a1_wire_int=a1_wire_int+1) begin
    t1_readA_a1_wire[a1_wire_int] = t1_readA_a1 >> (a1_wire_int*2);
    t1_writeA_a1_wire[a1_wire_int] = t1_writeA_a1 >> (a1_wire_int*2);
    t1_addrA_a1_wire[a1_wire_int] = t1_addrA_a1 >> (a1_wire_int*2*BITVROW1);
    t1_dinA_a1_wire[a1_wire_int] = t1_dinA_a1 >> (a1_wire_int*2*WIDTH);
    t1_readB_a1_wire[a1_wire_int] = t1_readB_a1 >> (a1_wire_int*2);
    t1_writeB_a1_wire[a1_wire_int] = t1_writeB_a1 >> (a1_wire_int*2);
    t1_addrB_a1_wire[a1_wire_int] = t1_addrB_a1 >> (a1_wire_int*2*BITVROW1);
    t1_dinB_a1_wire[a1_wire_int] = t1_dinB_a1 >> (a1_wire_int*2*WIDTH);
    t1_doutA_a1 = t1_doutA_a1 | (t1_doutA_a1_wire[a1_wire_int] << (a1_wire_int*2*WIDTH));
    t1_serrA_a1 = t1_serrA_a1 | (t1_serrA_a1_wire[a1_wire_int] << a1_wire_int*2);
    t1_derrA_a1 = t1_derrA_a1 | (t1_derrA_a1_wire[a1_wire_int] << a1_wire_int*2);
    t1_padrA_a1 = t1_padrA_a1 | (t1_padrA_a1_wire[a1_wire_int] << (a1_wire_int*2*BITPADR2));
    t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[a1_wire_int] << (a1_wire_int*2*WIDTH));
    t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_wire[a1_wire_int] << a1_wire_int*2);
    t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[a1_wire_int] << a1_wire_int*2);
    t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_wire[a1_wire_int] << (a1_wire_int*2*BITPADR2));
  end
end

wire [NUMVBNK2-1:0] t1_readA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2-1:0] t1_writeA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2*BITVROW2-1:0] t1_addrA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2*WIDTH-1:0] t1_dinA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2*WIDTH-1:0] t1_doutA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2-1:0] t1_serrA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2-1:0] t1_derrA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2*(BITSROW2+BITWRDS2)-1:0] t1_padrA_a2 [0:NUMVBNK1-1];

wire [NUMVBNK2-1:0] t1_readB_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2-1:0] t1_writeB_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2*BITVROW2-1:0] t1_addrB_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2*WIDTH-1:0] t1_dinB_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2*WIDTH-1:0] t1_doutB_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2-1:0] t1_serrB_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2-1:0] t1_derrB_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2*(BITSROW2+BITWRDS2)-1:0] t1_padrB_a2 [0:NUMVBNK1-1];

wire [1-1:0] t2_readA_a2 [0:NUMVBNK1-1];
wire [1-1:0] t2_writeA_a2 [0:NUMVBNK1-1];
wire [1*BITVROW2-1:0] t2_addrA_a2 [0:NUMVBNK1-1];
wire [1*WIDTH-1:0] t2_dinA_a2 [0:NUMVBNK1-1];
reg [1*WIDTH-1:0] t2_doutA_a2 [0:NUMVBNK1-1];
reg [1-1:0] t2_serrA_a2 [0:NUMVBNK1-1];
reg [1-1:0] t2_derrA_a2 [0:NUMVBNK1-1];
reg [1*(BITSROW2+BITWRDS2)-1:0] t2_padrA_a2 [0:NUMVBNK1-1];

wire [1-1:0] t2_readB_a2 [0:NUMVBNK1-1];
wire [1-1:0] t2_writeB_a2 [0:NUMVBNK1-1];
wire [1*BITVROW2-1:0] t2_addrB_a2 [0:NUMVBNK1-1];
wire [1*WIDTH-1:0] t2_dinB_a2 [0:NUMVBNK1-1];
reg [1*WIDTH-1:0] t2_doutB_a2 [0:NUMVBNK1-1];
reg [1-1:0] t2_serrB_a2 [0:NUMVBNK1-1];
reg [1-1:0] t2_derrB_a2 [0:NUMVBNK1-1];
reg [1*(BITSROW2+BITWRDS2)-1:0] t2_padrB_a2 [0:NUMVBNK1-1];

genvar a2_int;
generate for (a2_int=0; a2_int<NUMVBNK1; a2_int=a2_int+1) begin: a2_loop
  wire write_wire = t1_writeA_a1_wire[a2_int];
  wire read_wire = t1_readA_a1_wire[a2_int];
  wire [BITVROW1-1:0] addr_wire = t1_addrA_a1_wire[a2_int];
  wire [WIDTH-1:0] din_wire = t1_dinA_a1_wire[a2_int];

  algo_nr1w_2rw #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1), .NUMVRPT (2), .NUMPRPT (1),
                  .NUMVROW (NUMVROW2), .BITVROW (BITVROW2), .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2), .BITPBNK (BITPBNK2),
                  .BITPADR (BITPADR2), .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPIN (FLOPIN2), .FLOPOUT (FLOPOUT2))
    algo (.clk (clk), .rst (rst), .ready (t1_a2_ready[a2_int]),
          .write1 (write_wire), .read1 (read_wire), .addr1 (addr_wire), .din1 (din_wire), .rd1_dout(t1_doutA_a1_wire[a2_int][WIDTH-1:0]),
          .rd1_serr(t1_serrA_a1_wire[a2_int][0]), .rd1_derr(t1_derrA_a1_wire[a2_int][0]), .rd1_padr(t1_padrA_a1_wire[a2_int][BITPADR2-1:0]),
          .read2 (t1_readB_a1_wire[a2_int]), .addr2 (t1_addrB_a1_wire[a2_int]), .rd2_vld (), .rd2_dout (t1_doutB_a1_wire[a2_int]),
          .rd2_serr (t1_serrB_a1_wire[a2_int]), .rd2_derr (t1_derrB_a1_wire[a2_int]), .rd2_padr (t1_padrB_a1_wire[a2_int]),
          .t1_readA (t1_readA_a2[a2_int]), .t1_writeA (t1_writeA_a2[a2_int]), .t1_addrA (t1_addrA_a2[a2_int]), .t1_dinA (t1_dinA_a2[a2_int]),
          .t1_doutA (t1_doutA_a2[a2_int]), .t1_serrA (t1_serrA_a2[a2_int]), .t1_derrA (t1_derrA_a2[a2_int]), .t1_padrA (t1_padrA_a2[a2_int]),
          .t1_readB (t1_readB_a2[a2_int]), .t1_writeB (t1_writeB_a2[a2_int]), .t1_addrB (t1_addrB_a2[a2_int]), .t1_dinB (t1_dinB_a2[a2_int]),
          .t1_doutB (t1_doutB_a2[a2_int]), .t1_serrB (t1_serrB_a2[a2_int]), .t1_derrB (t1_derrB_a2[a2_int]), .t1_padrB (t1_padrB_a2[a2_int]),
          .t2_readA (t2_readA_a2[a2_int]), .t2_writeA (t2_writeA_a2[a2_int]), .t2_addrA (t2_addrA_a2[a2_int]), .t2_dinA (t2_dinA_a2[a2_int]),
          .t2_doutA (t2_doutA_a2[a2_int]), .t2_serrA (t2_serrA_a2[a2_int]), .t2_derrA (t2_derrA_a2[a2_int]), .t2_padrA (t2_padrA_a2[a2_int]),
          .t2_readB (t2_readB_a2[a2_int]), .t2_writeB (t2_writeB_a2[a2_int]), .t2_addrB (t2_addrB_a2[a2_int]), .t2_dinB (t2_dinB_a2[a2_int]),
          .t2_doutB (t2_doutB_a2[a2_int]), .t2_serrB (t2_serrB_a2[a2_int]), .t2_derrB (t2_derrB_a2[a2_int]), .t2_padrB (t2_padrB_a2[a2_int]),
          .select_addr (select_addr_a2), .select_bit (select_bit));
end
endgenerate

wire [WIDTH-1:0] t1_doutA_a2_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_serrA_a2_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_derrA_a2_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [BITSROW2+BITWRDS2-1:0] t1_padrA_a2_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_readA_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_writeA_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [BITSROW2-1:0] t1_addrA_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t1_bwA_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t1_dinA_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];

wire [WIDTH-1:0] t1_doutB_a2_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_serrB_a2_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_derrB_a2_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [BITSROW2+BITWRDS2-1:0] t1_padrB_a2_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_readB_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_writeB_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [BITSROW2-1:0] t1_addrB_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t1_bwB_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t1_dinB_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];

genvar t1r, t1b;
generate
  for (t1r=0; t1r<NUMVBNK1; t1r=t1r+1) begin: t1r_loop
    for (t1b=0; t1b<NUMVBNK2; t1b=t1b+1) begin: t1b_loop
      wire t1_readA_a2_wire = t1_readA_a2[t1r] >> t1b;
      wire t1_writeA_a2_wire = t1_writeA_a2[t1r] >> t1b;
      wire [BITVROW2-1:0] t1_addrA_a2_wire = t1_addrA_a2[t1r] >> (t1b*BITVROW2);
      wire [WIDTH-1:0] t1_dinA_a2_wire = t1_dinA_a2[t1r] >> (t1b*WIDTH);

      wire t1_readB_a2_wire = t1_readB_a2[t1r] >> t1b;
      wire t1_writeB_a2_wire = t1_writeB_a2[t1r] >> t1b;
      wire [BITVROW2-1:0] t1_addrB_a2_wire = t1_addrB_a2[t1r] >> (t1b*BITVROW2);
      wire [WIDTH-1:0] t1_dinB_a2_wire = t1_dinB_a2[t1r] >> (t1b*WIDTH);

      wire [NUMWRDS2*MEMWDTH-1:0] t1_doutA_wire = t1_doutA >> ((t1r*NUMVBNK2+t1b)*PHYWDTH2);
      wire [NUMWRDS2*MEMWDTH-1:0] t1_doutB_wire = t1_doutB >> ((t1r*NUMVBNK2+t1b)*PHYWDTH2);

      if (1) begin: align_loop
        infra_align_2rw #(.WIDTH (WIDTH), .PARITY (PARITY), .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                          .NUMSROW (NUMSROW2), .BITSROW (BITSROW2), .NUMWRDS (NUMWRDS2), .BITWRDS (BITWRDS2), .BITPADR (BITSROW2+BITWRDS2),
                          .SRAM_DELAY (SRAM_DELAY), .FLOPMEM (FLOPMEM), .RSTZERO(1))
          infra (.read ({t1_readB_a2_wire,t1_readA_a2_wire}), .write ({t1_writeB_a2_wire,t1_writeA_a2_wire}), .addr ({t1_addrB_a2_wire,t1_addrA_a2_wire}),
                 .din ({t1_dinB_a2_wire,t1_dinA_a2_wire}), .dout ({t1_doutB_a2_wire[t1r][t1b],t1_doutA_a2_wire[t1r][t1b]}),
                 .serr ({t1_serrB_a2_wire[t1r][t1b],t1_serrA_a2_wire[t1r][t1b]}), .padr ({t1_padrB_a2_wire[t1r][t1b],t1_padrA_a2_wire[t1r][t1b]}),
                 .mem_read ({t1_readB_wire[t1r][t1b],t1_readA_wire[t1r][t1b]}), .mem_write ({t1_writeB_wire[t1r][t1b],t1_writeA_wire[t1r][t1b]}),
                 .mem_addr ({t1_addrB_wire[t1r][t1b],t1_addrA_wire[t1r][t1b]}), .mem_bw ({t1_bwB_wire[t1r][t1b],t1_bwA_wire[t1r][t1b]}),
                 .mem_din ({t1_dinB_wire[t1r][t1b],t1_dinA_wire[t1r][t1b]}), .mem_dout ({t1_doutB_wire,t1_doutA_wire}),
	         .select_addr (select_vrow_a2),
                 .clk (clk), .rst (rst));
        assign t1_derrA_a2_wire[t1r][t1b] = 1'b0;
        assign t1_derrB_a2_wire[t1r][t1b] = 1'b0;
      end
    end
  end
endgenerate

reg [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
reg [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
reg [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrA;
reg [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA;
reg [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA;
reg [NUMVBNK1*NUMVBNK2-1:0] t1_readB;
reg [NUMVBNK1*NUMVBNK2-1:0] t1_writeB;
reg [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrB;
reg [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwB;
reg [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinB;
integer t1r_int, t1b_int;
always_comb begin
  t1_readA = 0;
  t1_writeA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  t1_readB = 0;
  t1_writeB = 0;
  t1_addrB = 0;
  t1_bwB = 0;
  t1_dinB = 0;
  for (t1r_int=0; t1r_int<NUMVBNK1; t1r_int=t1r_int+1) begin
    t1_doutA_a2[t1r_int] = 0;
    t1_serrA_a2[t1r_int] = 0;
    t1_derrA_a2[t1r_int] = 0;
    t1_padrA_a2[t1r_int] = 0;
    t1_doutB_a2[t1r_int] = 0;
    t1_serrB_a2[t1r_int] = 0;
    t1_derrB_a2[t1r_int] = 0;
    t1_padrB_a2[t1r_int] = 0;
    for (t1b_int=0; t1b_int<NUMVBNK2; t1b_int=t1b_int+1) begin
      t1_readA = t1_readA | (t1_readA_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK2+t1b_int));
      t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK2+t1b_int));
      t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK2+t1b_int)*BITSROW2));
      t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK2+t1b_int)*PHYWDTH2));
      t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK2+t1b_int)*PHYWDTH2));
      t1_readB = t1_readB | (t1_readB_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK2+t1b_int));
      t1_writeB = t1_writeB | (t1_writeB_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK2+t1b_int));
      t1_addrB = t1_addrB | (t1_addrB_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK2+t1b_int)*BITSROW2));
      t1_bwB = t1_bwB | (t1_bwB_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK2+t1b_int)*PHYWDTH2));
      t1_dinB = t1_dinB | (t1_dinB_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK2+t1b_int)*PHYWDTH2));
      t1_doutA_a2[t1r_int] = t1_doutA_a2[t1r_int] | (t1_doutA_a2_wire[t1r_int][t1b_int] << (t1b_int*WIDTH));
      t1_serrA_a2[t1r_int] = t1_serrA_a2[t1r_int] | (t1_serrA_a2_wire[t1r_int][t1b_int] << t1b_int);
      t1_derrA_a2[t1r_int] = t1_derrA_a2[t1r_int] | (t1_derrA_a2_wire[t1r_int][t1b_int] << t1b_int);
      t1_padrA_a2[t1r_int] = t1_padrA_a2[t1r_int] | (t1_padrA_a2_wire[t1r_int][t1b_int] << (t1b_int*(BITSROW2+BITWRDS2)));
      t1_doutB_a2[t1r_int] = t1_doutB_a2[t1r_int] | (t1_doutB_a2_wire[t1r_int][t1b_int] << (t1b_int*WIDTH));
      t1_serrB_a2[t1r_int] = t1_serrB_a2[t1r_int] | (t1_serrB_a2_wire[t1r_int][t1b_int] << t1b_int);
      t1_derrB_a2[t1r_int] = t1_derrB_a2[t1r_int] | (t1_derrB_a2_wire[t1r_int][t1b_int] << t1b_int);
      t1_padrB_a2[t1r_int] = t1_padrB_a2[t1r_int] | (t1_padrB_a2_wire[t1r_int][t1b_int] << (t1b_int*(BITSROW2+BITWRDS2)));
    end
  end
end

wire [WIDTH-1:0] t2_doutA_a2_wire [0:NUMVBNK1-1][0:1-1];
wire t2_serrA_a2_wire [0:NUMVBNK1-1][0:1-1];
wire t2_derrA_a2_wire [0:NUMVBNK1-1][0:1-1];
wire [BITSROW2+BITWRDS2-1:0] t2_padrA_a2_wire [0:NUMVBNK1-1][0:1-1];
wire t2_readA_wire [0:NUMVBNK1-1][0:1-1];
wire t2_writeA_wire [0:NUMVBNK1-1][0:1-1];
wire [BITSROW2-1:0] t2_addrA_wire [0:NUMVBNK1-1][0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t2_bwA_wire [0:NUMVBNK1-1][0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t2_dinA_wire [0:NUMVBNK1-1][0:1-1];

wire [WIDTH-1:0] t2_doutB_a2_wire [0:NUMVBNK1-1][0:1-1];
wire t2_serrB_a2_wire [0:NUMVBNK1-1][0:1-1];
wire t2_derrB_a2_wire [0:NUMVBNK1-1][0:1-1];
wire [BITSROW2+BITWRDS2-1:0] t2_padrB_a2_wire [0:NUMVBNK1-1][0:1-1];
wire t2_readB_wire [0:NUMVBNK1-1][0:1-1];
wire t2_writeB_wire [0:NUMVBNK1-1][0:1-1];
wire [BITSROW2-1:0] t2_addrB_wire [0:NUMVBNK1-1][0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t2_bwB_wire [0:NUMVBNK1-1][0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t2_dinB_wire [0:NUMVBNK1-1][0:1-1];

genvar t2r, t2b;
generate
  for (t2r=0; t2r<NUMVBNK1; t2r=t2r+1) begin: t2r_loop
    for (t2b=0; t2b<1; t2b=t2b+1) begin: t2b_loop
      wire t2_readA_a2_wire = t2_readA_a2[t2r] >> t2b;
      wire t2_writeA_a2_wire = t2_writeA_a2[t2r] >> t2b;
      wire [BITVROW2-1:0] t2_addrA_a2_wire = t2_addrA_a2[t2r] >> (t2b*BITVROW2);
      wire [WIDTH-1:0] t2_dinA_a2_wire = t2_dinA_a2[t2r] >> (t2b*WIDTH);

      wire t2_readB_a2_wire = t2_readB_a2[t2r] >> t2b;
      wire t2_writeB_a2_wire = t2_writeB_a2[t2r] >> t2b;
      wire [BITVROW2-1:0] t2_addrB_a2_wire = t2_addrB_a2[t2r] >> (t2b*BITVROW2);
      wire [WIDTH-1:0] t2_dinB_a2_wire = t2_dinB_a2[t2r] >> (t2b*WIDTH);

      wire [NUMWRDS2*MEMWDTH-1:0] t2_doutA_wire = t2_doutA >> ((t2r*1+t2b)*PHYWDTH2);
      wire [NUMWRDS2*MEMWDTH-1:0] t2_doutB_wire = t2_doutB >> ((t2r*1+t2b)*PHYWDTH2);

      if (1) begin: align_loop
        infra_align_2rw #(.WIDTH (WIDTH), .PARITY (PARITY), .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                          .NUMSROW (NUMSROW2), .BITSROW (BITSROW2), .NUMWRDS (NUMWRDS2), .BITWRDS (BITWRDS2), .BITPADR (BITSROW2+BITWRDS2),
                          .SRAM_DELAY (SRAM_DELAY), .FLOPMEM (FLOPMEM), .RSTZERO (1))
          infra (.read ({t2_readB_a2_wire,t2_readA_a2_wire}), .write ({t2_writeB_a2_wire,t2_writeA_a2_wire}), .addr ({t2_addrB_a2_wire,t2_addrA_a2_wire}),
                 .din ({t2_dinB_a2_wire,t2_dinA_a2_wire}), .dout ({t2_doutB_a2_wire[t2r][t2b],t2_doutA_a2_wire[t2r][t2b]}),
                 .serr ({t2_serrB_a2_wire[t2r][t2b],t2_serrA_a2_wire[t2r][t2b]}), .padr ({t2_padrB_a2_wire[t2r][t2b],t2_padrA_a2_wire[t2r][t2b]}),
                 .mem_read ({t2_readB_wire[t2r][t2b],t2_readA_wire[t2r][t2b]}), .mem_write ({t2_writeB_wire[t2r][t2b],t2_writeA_wire[t2r][t2b]}),
                 .mem_addr ({t2_addrB_wire[t2r][t2b],t2_addrA_wire[t2r][t2b]}), .mem_bw ({t2_bwB_wire[t2r][t2b],t2_bwA_wire[t2r][t2b]}),
                 .mem_din ({t2_dinB_wire[t2r][t2b],t2_dinA_wire[t2r][t2b]}), .mem_dout ({t2_doutB_wire,t2_doutA_wire}),
	         .select_addr (select_vrow_a2),
                 .clk (clk), .rst (rst));
        assign t2_derrA_a2_wire[t2r][t2b] = 1'b0;
        assign t2_derrB_a2_wire[t2r][t2b] = 1'b0;
      end
    end
  end
endgenerate

reg [NUMVBNK1-1:0] t2_readA;
reg [NUMVBNK1-1:0] t2_writeA;
reg [NUMVBNK1*BITSROW2-1:0] t2_addrA;
reg [NUMVBNK1*PHYWDTH2-1:0] t2_bwA;
reg [NUMVBNK1*PHYWDTH2-1:0] t2_dinA;

reg [NUMVBNK1-1:0] t2_readB;
reg [NUMVBNK1-1:0] t2_writeB;
reg [NUMVBNK1*BITSROW2-1:0] t2_addrB;
reg [NUMVBNK1*PHYWDTH2-1:0] t2_bwB;
reg [NUMVBNK1*PHYWDTH2-1:0] t2_dinB;

integer t2r_int, t2b_int;
always_comb begin
  t2_readA = 0;
  t2_writeA = 0;
  t2_addrA = 0;
  t2_bwA = 0;
  t2_dinA = 0;
  t2_readB = 0;
  t2_writeB = 0;
  t2_addrB = 0;
  t2_bwB = 0;
  t2_dinB = 0;
  for (t2r_int=0; t2r_int<NUMVBNK1; t2r_int=t2r_int+1) begin
    t2_doutA_a2[t2r_int] = 0;
    t2_serrA_a2[t2r_int] = 0;
    t2_derrA_a2[t2r_int] = 0;
    t2_padrA_a2[t2r_int] = 0;
    t2_doutB_a2[t2r_int] = 0;
    t2_serrB_a2[t2r_int] = 0;
    t2_derrB_a2[t2r_int] = 0;
    t2_padrB_a2[t2r_int] = 0;
    for (t2b_int=0; t2b_int<1; t2b_int=t2b_int+1) begin
      t2_readA = t2_readA | (t2_readA_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_writeA = t2_writeA | (t2_writeA_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_addrA = t2_addrA | (t2_addrA_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*BITSROW2));
      t2_bwA = t2_bwA | (t2_bwA_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*PHYWDTH2));
      t2_dinA = t2_dinA | (t2_dinA_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*PHYWDTH2));
      t2_readB = t2_readB | (t2_readB_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_writeB = t2_writeB | (t2_writeB_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_addrB = t2_addrB | (t2_addrB_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*BITSROW2));
      t2_bwB = t2_bwB | (t2_bwB_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*PHYWDTH2));
      t2_dinB = t2_dinB | (t2_dinB_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*PHYWDTH2));
      t2_doutA_a2[t2r_int] = t2_doutA_a2[t2r_int] | (t2_doutA_a2_wire[t2r_int][t2b_int] << (t2b_int*WIDTH));
      t2_serrA_a2[t2r_int] = t2_serrA_a2[t2r_int] | (t2_serrA_a2_wire[t2r_int][t2b_int] << t2b_int);
      t2_derrA_a2[t2r_int] = t2_derrA_a2[t2r_int] | (t2_derrA_a2_wire[t2r_int][t2b_int] << t2b_int);
      t2_padrA_a2[t2r_int] = t2_padrA_a2[t2r_int] | (t2_padrA_a2_wire[t2r_int][t2b_int] << (t2b_int*(BITSROW2+BITWRDS2)));
      t2_doutB_a2[t2r_int] = t2_doutB_a2[t2r_int] | (t2_doutB_a2_wire[t2r_int][t2b_int] << (t2b_int*WIDTH));
      t2_serrB_a2[t2r_int] = t2_serrB_a2[t2r_int] | (t2_serrB_a2_wire[t2r_int][t2b_int] << t2b_int);
      t2_derrB_a2[t2r_int] = t2_derrB_a2[t2r_int] | (t2_derrB_a2_wire[t2r_int][t2b_int] << t2b_int);
      t2_padrB_a2[t2r_int] = t2_padrB_a2[t2r_int] | (t2_padrB_a2_wire[t2r_int][t2b_int] << (t2b_int*(BITSROW2+BITWRDS2)));
    end
  end
end

wire [NUMVBNK2-1:0] t3_readA_a3;
wire [NUMVBNK2-1:0] t3_writeA_a3; 
wire [NUMVBNK2*BITVROW2-1:0] t3_addrA_a3;
wire [NUMVBNK2*WIDTH-1:0] t3_dinA_a3;
reg [NUMVBNK2*WIDTH-1:0] t3_doutA_a3;
reg [NUMVBNK2-1:0] t3_serrA_a3;
reg [NUMVBNK2-1:0] t3_derrA_a3;
reg [NUMVBNK2*(BITSROW2+BITWRDS2)-1:0] t3_padrA_a3;

wire [NUMVBNK2-1:0] t3_readB_a3;
wire [NUMVBNK2-1:0] t3_writeB_a3; 
wire [NUMVBNK2*BITVROW2-1:0] t3_addrB_a3;
wire [NUMVBNK2*WIDTH-1:0] t3_dinB_a3;
reg [NUMVBNK2*WIDTH-1:0] t3_doutB_a3;
reg [NUMVBNK2-1:0] t3_serrB_a3;
reg [NUMVBNK2-1:0] t3_derrB_a3;
reg [NUMVBNK2*(BITSROW2+BITWRDS2)-1:0] t3_padrB_a3;

wire [1-1:0] t4_readA_a3; 
wire [1-1:0] t4_writeA_a3; 
wire [1*BITVROW2-1:0] t4_addrA_a3;
wire [1*WIDTH-1:0] t4_dinA_a3;
reg [1*WIDTH-1:0] t4_doutA_a3;
reg [1-1:0] t4_serrA_a3;
reg [1-1:0] t4_derrA_a3;
reg [1*(BITSROW2+BITWRDS2)-1:0] t4_padrA_a3;

wire [1-1:0] t4_readB_a3; 
wire [1-1:0] t4_writeB_a3; 
wire [1*BITVROW2-1:0] t4_addrB_a3;
wire [1*WIDTH-1:0] t4_dinB_a3;
reg [1*WIDTH-1:0] t4_doutB_a3;
reg [1-1:0] t4_serrB_a3;
reg [1-1:0] t4_derrB_a3;
reg [1*(BITSROW2+BITWRDS2)-1:0] t4_padrB_a3;

genvar a3_int;
generate for (a3_int=0; a3_int<1; a3_int=a3_int+1) begin: a3_loop

  algo_nr1w_2rw #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1), .NUMVRPT (2), .NUMPRPT (1),
                  .NUMVROW (NUMVROW2), .BITVROW (BITVROW2), .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2), .BITPBNK (BITPBNK2),
                  .BITPADR (BITPADR2), .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPIN (FLOPIN2), .FLOPOUT (FLOPOUT2))
    algo (.clk (clk), .rst (rst), .ready (t3_a3_ready),
          .write1 (t3_writeA_a1[0]), .read1 (t3_readA_a1[0]), .addr1 (t3_addrA_a1[BITVROW1-1:0]), .din1 (t3_dinA_a1[WIDTH-1:0]),
          .rd1_dout(t3_doutA_a1[WIDTH-1:0]), .rd1_serr(t3_serrA_a1[0]), .rd1_derr(t3_derrA_a1[0]), .rd1_padr(t3_padrA_a1[BITPADR2-1:0]),
          .read2 (t3_readB_a1), .addr2 (t3_addrB_a1), .rd2_vld (), .rd2_dout (t3_doutB_a1),
          .rd2_serr (t3_serrB_a1), .rd2_derr (t3_derrB_a1), .rd2_padr (t3_padrB_a1),
          .t1_readA (t3_readA_a3), .t1_writeA (t3_writeA_a3), .t1_addrA (t3_addrA_a3), .t1_dinA (t3_dinA_a3),
          .t1_doutA (t3_doutA_a3), .t1_serrA (t3_serrA_a3), .t1_derrA (t3_derrA_a3), .t1_padrA (t3_padrA_a3),
          .t1_readB (t3_readB_a3), .t1_writeB (t3_writeB_a3), .t1_addrB (t3_addrB_a3), .t1_dinB (t3_dinB_a3),
          .t1_doutB (t3_doutB_a3), .t1_serrB (t3_serrB_a3), .t1_derrB (t3_derrB_a3), .t1_padrB (t3_padrB_a3),
          .t2_readA (t4_readA_a3), .t2_writeA (t4_writeA_a3), .t2_addrA (t4_addrA_a3), .t2_dinA (t4_dinA_a3),
          .t2_doutA (t4_doutA_a3), .t2_serrA (t4_serrA_a3), .t2_derrA (t4_derrA_a3), .t2_padrA (t4_padrA_a3),
          .t2_readB (t4_readB_a3), .t2_writeB (t4_writeB_a3), .t2_addrB (t4_addrB_a3), .t2_dinB (t4_dinB_a3),
          .t2_doutB (t4_doutB_a3), .t2_serrB (t4_serrB_a3), .t2_derrB (t4_derrB_a3), .t2_padrB (t4_padrB_a3),
          .select_addr (select_addr_a2), .select_bit (select_bit));
end
endgenerate

wire [WIDTH-1:0] t3_doutA_a3_wire [0:NUMVBNK2-1];
wire t3_serrA_a3_wire [0:NUMVBNK2-1];
wire t3_derrA_a3_wire [0:NUMVBNK2-1];
wire [(BITSROW2+BITWRDS2)-1:0] t3_padrA_a3_wire [0:NUMVBNK2-1];
wire t3_readA_wire [0:NUMVBNK2-1];
wire t3_writeA_wire [0:NUMVBNK2-1];
wire [BITSROW2-1:0] t3_addrA_wire [0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t3_bwA_wire [0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t3_dinA_wire [0:NUMVBNK2-1];

wire [WIDTH-1:0] t3_doutB_a3_wire [0:NUMVBNK2-1];
wire t3_serrB_a3_wire [0:NUMVBNK2-1];
wire t3_derrB_a3_wire [0:NUMVBNK2-1];
wire [(BITSROW2+BITWRDS2)-1:0] t3_padrB_a3_wire [0:NUMVBNK2-1];
wire t3_readB_wire [0:NUMVBNK2-1];
wire t3_writeB_wire [0:NUMVBNK2-1];
wire [BITSROW2-1:0] t3_addrB_wire [0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t3_bwB_wire [0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t3_dinB_wire [0:NUMVBNK2-1];

genvar t3;
generate for (t3=0; t3<NUMVBNK2; t3=t3+1) begin: t3_loop
  wire t3_readA_a3_wire = t3_readA_a3 >> t3;
  wire t3_writeA_a3_wire = t3_writeA_a3 >> t3;
  wire [BITVROW2-1:0] t3_addrA_a3_wire = t3_addrA_a3 >> (t3*BITVROW2);
  wire [WIDTH-1:0] t3_dinA_a3_wire = t3_dinA_a3 >> (t3*WIDTH);

  wire t3_readB_a3_wire = t3_readB_a3 >> t3;
  wire t3_writeB_a3_wire = t3_writeB_a3 >> t3;
  wire [BITVROW2-1:0] t3_addrB_a3_wire = t3_addrB_a3 >> (t3*BITVROW2);
  wire [WIDTH-1:0] t3_dinB_a3_wire = t3_dinB_a3 >> (t3*WIDTH);

  wire [NUMWRDS2*MEMWDTH-1:0] t3_doutA_wire = t3_doutA >> (t3*PHYWDTH2);
  wire [NUMWRDS2*MEMWDTH-1:0] t3_doutB_wire = t3_doutB >> (t3*PHYWDTH2);

  if (1) begin: align_loop
    infra_align_2rw #(.WIDTH (WIDTH), .PARITY (PARITY), .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                      .NUMSROW (NUMSROW2), .BITSROW (BITSROW2), .NUMWRDS (NUMWRDS2), .BITWRDS (BITWRDS2), .BITPADR (BITSROW2+BITWRDS2),
                      .SRAM_DELAY (SRAM_DELAY), .FLOPMEM (FLOPMEM), .RSTZERO (1))
      infra (.read ({t3_readB_a3_wire,t3_readA_a3_wire}), .write ({t3_writeB_a3_wire,t3_writeA_a3_wire}), .addr ({t3_addrB_a3_wire,t3_addrA_a3_wire}),
             .din ({t3_dinB_a3_wire,t3_dinA_a3_wire}), .dout ({t3_doutB_a3_wire[t3],t3_doutA_a3_wire[t3]}),
             .serr ({t3_serrB_a3_wire[t3],t3_serrA_a3_wire[t3]}), .padr ({t3_padrB_a3_wire[t3],t3_padrA_a3_wire[t3]}),
             .mem_read ({t3_readB_wire[t3],t3_readA_wire[t3]}), .mem_write ({t3_writeB_wire[t3],t3_writeA_wire[t3]}),
             .mem_addr ({t3_addrB_wire[t3],t3_addrA_wire[t3]}), .mem_bw ({t3_bwB_wire[t3],t3_bwA_wire[t3]}),
             .mem_din ({t3_dinB_wire[t3],t3_dinA_wire[t3]}), .mem_dout ({t3_doutB_wire,t3_doutA_wire}),
             .select_addr (select_vrow_a2),
             .clk (clk), .rst (rst));
    assign t3_derrA_a3_wire[t3] = 1'b0;
    assign t3_derrB_a3_wire[t3] = 1'b0;
  end
end
endgenerate

reg [NUMVBNK2-1:0] t3_readA;
reg [NUMVBNK2-1:0] t3_writeA;
reg [NUMVBNK2*BITSROW2-1:0] t3_addrA;
reg [NUMVBNK2*PHYWDTH2-1:0] t3_bwA;
reg [NUMVBNK2*PHYWDTH2-1:0] t3_dinA;

reg [NUMVBNK2-1:0] t3_readB;
reg [NUMVBNK2-1:0] t3_writeB;
reg [NUMVBNK2*BITSROW2-1:0] t3_addrB;
reg [NUMVBNK2*PHYWDTH2-1:0] t3_bwB;
reg [NUMVBNK2*PHYWDTH2-1:0] t3_dinB;

integer t3_out_int;
always_comb begin
  t3_readA = 0;
  t3_writeA = 0;
  t3_addrA = 0;
  t3_bwA = 0;
  t3_dinA = 0;
  t3_readB = 0;
  t3_writeB = 0;
  t3_addrB = 0;
  t3_bwB = 0;
  t3_dinB = 0;
  t3_doutA_a3 = 0;
  t3_serrA_a3 = 0;
  t3_derrA_a3 = 0;
  t3_padrA_a3 = 0;
  t3_doutB_a3 = 0;
  t3_serrB_a3 = 0;
  t3_derrB_a3 = 0;
  t3_padrB_a3 = 0;
  for (t3_out_int=0; t3_out_int<NUMVBNK2; t3_out_int=t3_out_int+1) begin
    t3_readA = t3_readA | (t3_readA_wire[t3_out_int] << t3_out_int);
    t3_writeA = t3_writeA | (t3_writeA_wire[t3_out_int] << t3_out_int);
    t3_addrA = t3_addrA | (t3_addrA_wire[t3_out_int] << (t3_out_int*BITSROW2));
    t3_bwA = t3_bwA | (t3_bwA_wire[t3_out_int] << (t3_out_int*PHYWDTH2));
    t3_dinA = t3_dinA | (t3_dinA_wire[t3_out_int] << (t3_out_int*PHYWDTH2));
    t3_readB = t3_readB | (t3_readB_wire[t3_out_int] << t3_out_int);
    t3_writeB = t3_writeB | (t3_writeB_wire[t3_out_int] << t3_out_int);
    t3_addrB = t3_addrB | (t3_addrB_wire[t3_out_int] << (t3_out_int*BITSROW2));
    t3_bwB = t3_bwB | (t3_bwB_wire[t3_out_int] << (t3_out_int*PHYWDTH2));
    t3_dinB = t3_dinB | (t3_dinB_wire[t3_out_int] << (t3_out_int*PHYWDTH2));
    t3_doutA_a3 = t3_doutA_a3 | (t3_doutA_a3_wire[t3_out_int] << (t3_out_int*WIDTH));
    t3_serrA_a3 = t3_serrA_a3 | (t3_serrA_a3_wire[t3_out_int] << t3_out_int);
    t3_derrA_a3 = t3_derrA_a3 | (t3_derrA_a3_wire[t3_out_int] << t3_out_int);
    t3_padrA_a3 = t3_padrA_a3 | (t3_padrA_a3_wire[t3_out_int] << (t3_out_int*(BITSROW2+BITWRDS2)));
    t3_doutB_a3 = t3_doutB_a3 | (t3_doutB_a3_wire[t3_out_int] << (t3_out_int*WIDTH));
    t3_serrB_a3 = t3_serrB_a3 | (t3_serrB_a3_wire[t3_out_int] << t3_out_int);
    t3_derrB_a3 = t3_derrB_a3 | (t3_derrB_a3_wire[t3_out_int] << t3_out_int);
    t3_padrB_a3 = t3_padrB_a3 | (t3_padrB_a3_wire[t3_out_int] << (t3_out_int*(BITSROW2+BITWRDS2)));
  end
end

wire [WIDTH-1:0] t4_doutA_a3_wire [0:1-1];
wire t4_serrA_a3_wire [0:1-1]; 
wire t4_derrA_a3_wire [0:1-1];
wire [(BITSROW2+BITWRDS2)-1:0] t4_padrA_a3_wire [0:1-1];
wire t4_readA_wire [0:1-1];
wire t4_writeA_wire [0:1-1];
wire [BITSROW2-1:0] t4_addrA_wire [0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t4_bwA_wire [0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t4_dinA_wire [0:1-1];

wire [WIDTH-1:0] t4_doutB_a3_wire [0:1-1];
wire t4_serrB_a3_wire [0:1-1]; 
wire t4_derrB_a3_wire [0:1-1];
wire [(BITSROW2+BITWRDS2)-1:0] t4_padrB_a3_wire [0:1-1];
wire t4_readB_wire [0:1-1];
wire t4_writeB_wire [0:1-1];
wire [BITSROW2-1:0] t4_addrB_wire [0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t4_bwB_wire [0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t4_dinB_wire [0:1-1];

genvar t4;
generate for (t4=0; t4<1; t4=t4+1) begin: t4_loop
  wire t4_readA_a3_wire = t4_readA_a3 >> t4;
  wire t4_writeA_a3_wire = t4_writeA_a3 >> t4;
  wire [BITVROW2-1:0] t4_addrA_a3_wire = t4_addrA_a3 >> (t4*BITVROW2);
  wire [WIDTH-1:0] t4_dinA_a3_wire = t4_dinA_a3 >> (t4*WIDTH);
  
  wire t4_readB_a3_wire = t4_readB_a3 >> t4;
  wire t4_writeB_a3_wire = t4_writeB_a3 >> t4;
  wire [BITVROW2-1:0] t4_addrB_a3_wire = t4_addrB_a3 >> (t4*BITVROW2);
  wire [WIDTH-1:0] t4_dinB_a3_wire = t4_dinB_a3 >> (t4*WIDTH);
  
  wire [NUMWRDS2*MEMWDTH-1:0] t4_doutA_wire = t4_doutA >> (t4*PHYWDTH2);
  wire [NUMWRDS2*MEMWDTH-1:0] t4_doutB_wire = t4_doutB >> (t4*PHYWDTH2);

  if (1) begin: align_loop
    infra_align_2rw #(.WIDTH (WIDTH), .PARITY (PARITY), .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                      .NUMSROW (NUMSROW2), .BITSROW (BITSROW2), .NUMWRDS (NUMWRDS2), .BITWRDS (BITWRDS2), .BITPADR (BITSROW2+BITWRDS2),
                      .SRAM_DELAY (SRAM_DELAY), .FLOPMEM (FLOPMEM), .RSTZERO (1))
      infra (.read ({t4_readB_a3_wire,t4_readA_a3_wire}), .write ({t4_writeB_a3_wire,t4_writeA_a3_wire}), .addr ({t4_addrB_a3_wire,t4_addrA_a3_wire}),
             .din ({t4_dinB_a3_wire,t4_dinA_a3_wire}), .dout ({t4_doutB_a3_wire[t4],t4_doutA_a3_wire[t4]}),
             .serr ({t4_serrB_a3_wire[t4],t4_serrA_a3_wire[t4]}), .padr ({t4_padrB_a3_wire[t4],t4_padrA_a3_wire[t4]}),
             .mem_read ({t4_readB_wire[t4],t4_readA_wire[t4]}), .mem_write ({t4_writeB_wire[t4],t4_writeA_wire[t4]}),
             .mem_addr ({t4_addrB_wire[t4],t4_addrA_wire[t4]}), .mem_bw ({t4_bwB_wire[t4],t4_bwA_wire[t4]}),
             .mem_din ({t4_dinB_wire[t4],t4_dinA_wire[t4]}), .mem_dout ({t4_doutB_wire,t4_doutA_wire}),
             .select_addr (select_vrow_a2),
             .clk (clk), .rst (rst));
    assign t4_derrA_a3_wire[t4] = 1'b0;
    assign t4_derrB_a3_wire[t4] = 1'b0;
  end
end
endgenerate

reg [1-1:0] t4_readA;
reg [1-1:0] t4_writeA;
reg [1*BITSROW2-1:0] t4_addrA;
reg [1*PHYWDTH2-1:0] t4_bwA;
reg [1*PHYWDTH2-1:0] t4_dinA;

reg [1-1:0] t4_readB;
reg [1-1:0] t4_writeB;
reg [1*BITSROW2-1:0] t4_addrB;
reg [1*PHYWDTH2-1:0] t4_bwB;
reg [1*PHYWDTH2-1:0] t4_dinB;

integer t4_out_int;
always_comb begin
  t4_readA = 0;
  t4_writeA = 0;
  t4_addrA = 0;
  t4_bwA = 0;
  t4_dinA = 0;
  t4_readB = 0;
  t4_writeB = 0;
  t4_addrB = 0;
  t4_bwB = 0;
  t4_dinB = 0;
  t4_doutA_a3 = 0;
  t4_serrA_a3 = 0;
  t4_derrA_a3 = 0;
  t4_padrA_a3 = 0;
  t4_doutB_a3 = 0;
  t4_serrB_a3 = 0;
  t4_derrB_a3 = 0;
  t4_padrB_a3 = 0;
  for (t4_out_int=0; t4_out_int<1; t4_out_int=t4_out_int+1) begin
    t4_readA = t4_readA | (t4_readA_wire[t4_out_int] << t4_out_int);
    t4_writeA = t4_writeA | (t4_writeA_wire[t4_out_int] << t4_out_int);
    t4_addrA = t4_addrA | (t4_addrA_wire[t4_out_int] << (t4_out_int*BITSROW2));
    t4_bwA = t4_bwA | (t4_bwA_wire[t4_out_int] << (t4_out_int*PHYWDTH2));
    t4_dinA = t4_dinA | (t4_dinA_wire[t4_out_int] << (t4_out_int*PHYWDTH2));
    t4_readB = t4_readB | (t4_readB_wire[t4_out_int] << t4_out_int);
    t4_writeB = t4_writeB | (t4_writeB_wire[t4_out_int] << t4_out_int);
    t4_addrB = t4_addrB | (t4_addrB_wire[t4_out_int] << (t4_out_int*BITSROW2));
    t4_bwB = t4_bwB | (t4_bwB_wire[t4_out_int] << (t4_out_int*PHYWDTH2));
    t4_dinB = t4_dinB | (t4_dinB_wire[t4_out_int] << (t4_out_int*PHYWDTH2));
    t4_doutA_a3 = t4_doutA_a3 | (t4_doutA_a3_wire[t4_out_int] << (t4_out_int*WIDTH));
    t4_serrA_a3 = t4_serrA_a3 | (t4_serrA_a3_wire[t4_out_int] << t4_out_int);
    t4_derrA_a3 = t4_derrA_a3 | (t4_derrA_a3_wire[t4_out_int] << t4_out_int);
    t4_padrA_a3 = t4_padrA_a3 | (t4_padrA_a3_wire[t4_out_int] << (t4_out_int*(BITSROW2+BITWRDS2)));
    t4_doutB_a3 = t4_doutB_a3 | (t4_doutB_a3_wire[t4_out_int] << (t4_out_int*WIDTH));
    t4_serrB_a3 = t4_serrB_a3 | (t4_serrB_a3_wire[t4_out_int] << t4_out_int);
    t4_derrB_a3 = t4_derrB_a3 | (t4_derrB_a3_wire[t4_out_int] << t4_out_int);
    t4_padrB_a3 = t4_padrB_a3 | (t4_padrB_a3_wire[t4_out_int] << (t4_out_int*(BITSROW2+BITWRDS2)));
  end
end

`ifdef FORMAL
genvar werr_int;
generate for (werr_int=0; werr_int<NUMVBNK1; werr_int=werr_int+1) begin: werr_loop
  assume_wr_rerr_check: assert property (@(posedge clk) disable iff (rst) (ready || a1_loop.algo.ip_top_sva.wr_nerr[werr_int]));
  assume_wr_nerr_check: assert property (@(posedge clk) disable iff (rst) (a2_loop[werr_int].algo.ip_top_sva.write1 &&
                                                                           (a2_loop[werr_int].algo.ip_top_sva.wr_row1 == select_vrow_a2)) |->
                                         (a1_loop.algo.ip_top_sva.wr_nerr[werr_int] == &a2_loop[werr_int].algo.ip_top_sva.memA_nerr[0]));
  assume_wr_serr_check: assert property (@(posedge clk) disable iff (rst) (a2_loop[werr_int].algo.ip_top_sva.write1 &&
                                                                           (a2_loop[werr_int].algo.ip_top_sva.wr_row1 == select_vrow_a2) &&
                                                                           |a2_loop[werr_int].algo.ip_top_sva.memA_serr[0]) |->
                                         (a1_loop.algo.ip_top_sva.t1_writeA_wire[werr_int] && (a1_loop.algo.ip_top_sva.t1_addrA_wire[0][werr_int] == select_addr_a2) &&
                                          a1_loop.algo.ip_top_sva.wr_serr[werr_int]));
end
endgenerate

assume_xwr_rerr_check: assert property (@(posedge clk) disable iff (rst) (ready || a1_loop.algo.ip_top_sva.xwr_nerr));
assume_xwr_nerr_check: assert property (@(posedge clk) disable iff (rst) (a3_loop[0].algo.ip_top_sva.write1 &&
                                                                          (a3_loop[0].algo.ip_top_sva.wr_row1 == select_vrow_a2)) |->
                                        (a1_loop.algo.ip_top_sva.xwr_nerr == &a3_loop[0].algo.ip_top_sva.memA_nerr[0]));
assume_xwr_serr_check: assert property (@(posedge clk) disable iff (rst) (a3_loop[0].algo.ip_top_sva.write1 &&
                                                                          (a3_loop[0].algo.ip_top_sva.wr_row1 == select_vrow_a2) &&
                                                                          |a3_loop[0].algo.ip_top_sva.memA_serr[0]) |->
                                        (a1_loop.algo.ip_top_sva.t2_writeA && (a1_loop.algo.ip_top_sva.t2_addrA_wire[0] == select_addr_a2) &&
                                         a1_loop.algo.ip_top_sva.xwr_serr));
`endif

/*
`ifdef FORMAL
genvar berr_int;
generate for (berr_int=0; berr_int<NUMVBNK; berr_int=berr_int+1) begin: berr_loop
  assume_mem_nerr_check: assert property (@(posedge clk) disable iff (rst)
					  (a1_loop.algo.ip_top_sva.mem_nerr[0][berr_int] == t1_loop[berr_int].align_loop.infra.ip_top_sva.mem_nerr));
  assume_mem_serr_check: assert property (@(posedge clk) disable iff (rst)
					  (a1_loop.algo.ip_top_sva.mem_serr[0][berr_int] == t1_loop[berr_int].align_loop.infra.ip_top_sva.mem_serr));
end
endgenerate

assume_xmem_nerr_check: assert property (@(posedge clk) disable iff (rst)
					 (a1_loop.algo.ip_top_sva.xmem_nerr[0] == t2_loop[0].align_loop.infra.ip_top_sva.mem_nerr));
assume_xmem_serr_check: assert property (@(posedge clk) disable iff (rst)
					 (a1_loop.algo.ip_top_sva.xmem_serr[0] == t2_loop[0].align_loop.infra.ip_top_sva.mem_serr));
`endif
*/
endmodule
