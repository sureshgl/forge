
module algo_3r1w_1rw_mt_top (clk, rst, ready,
                             refr, read, write, addr, din, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                             t1_readA, t1_writeA, t1_addrA, t1_dwsnA, t1_bwA, t1_dinA, t1_doutA, t1_refrB, t1_bankB,
                             t2_readA, t2_writeA, t2_addrA, t2_dwsnA, t2_bwA, t2_dinA, t2_doutA, t2_refrB, t2_bankB,
                             t3_readA, t3_writeA, t3_addrA, t3_dwsnA, t3_bwA, t3_dinA, t3_doutA, t3_refrB, t3_bankB,
                             t4_writeA, t4_addrA, t4_dinA, t4_readB, t4_addrB, t4_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter PARITY = 1;
  parameter MEMWDTH = WIDTH+PARITY;
  parameter NUMRDPT = 3;
  parameter NUMRWPT = 0;
  parameter NUMWRPT = 1;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW1 = 1024;  // ALGO1 Parameters
  parameter BITVROW1 = 10;
  parameter NUMVBNK1 = 8;
  parameter BITVBNK1 = 3;
  parameter NUMPBNK1 = 10;
  parameter BITPBNK1 = 4;
  parameter FLOPIN1 = 0;
  parameter FLOPOUT1 = 0;
  parameter NUMVROW2 = 256;   // ALGO2 Parameters
  parameter BITVROW2 = 8;
  parameter NUMVBNK2 = 4;
  parameter BITVBNK2 = 2;
  parameter BITPBNK2 = 3;
  parameter FLOPIN2 = 0;
  parameter FLOPOUT2 = 0;
  parameter NUMWRDS2 = 4;     // ALIGN Parameters
  parameter BITWRDS2 = 2;
  parameter NUMSROW2 = 64;
  parameter BITSROW2 = 6;
  parameter PHYWDTH2 = NUMWRDS2*MEMWDTH;
  parameter NUMRBNK2 = 8;
  parameter BITRBNK2 = 3;
  parameter BITWSPF2 = 0;
  parameter NUMVROW3 = 256;   // ALGO2 Parameters
  parameter BITVROW3 = 8;
  parameter NUMVBNK3 = 4;
  parameter BITVBNK3 = 2;
  parameter BITPBNK3 = 3;
  parameter FLOPIN3 = 0;
  parameter FLOPOUT3 = 0;
  parameter NUMWRDS3 = 4;     // ALIGN Parameters
  parameter BITWRDS3 = 2;
  parameter NUMSROW3 = 64;
  parameter BITSROW3 = 6;
  parameter PHYWDTH3 = NUMWRDS3*MEMWDTH;
  parameter NUMRBNK3 = 8;
  parameter BITRBNK3 = 3;
  parameter BITWSPF3 = 0;
  parameter REFRESH = 1;      // REFRESH Parameters 
  parameter REFLOPW = 0;
  parameter NUMRROW = 16;
  parameter BITRROW = 4;
  parameter REFFREQ = 16;
  parameter REFFRHF = 0;
  parameter NUMDWS0 = 72;     // DWSN Parameters
  parameter NUMDWS1 = 72;
  parameter NUMDWS2 = 72;
  parameter NUMDWS3 = 72;
  parameter NUMDWS4 = 72;
  parameter NUMDWS5 = 72;
  parameter NUMDWS6 = 72;
  parameter NUMDWS7 = 72;
  parameter NUMDWS8 = 72;
  parameter NUMDWS9 = 72;
  parameter NUMDWS10 = 72;
  parameter NUMDWS11 = 72;
  parameter NUMDWS12 = 72;
  parameter NUMDWS13 = 72;
  parameter NUMDWS14 = 72;
  parameter NUMDWS15 = 72;
  parameter BITDWSN = 8;
  parameter ECCBITS = 8;
  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 2;
  parameter FLOPMEM = 0;

  parameter BITPADR4 = BITVBNK3+BITSROW3+BITWRDS3;
  parameter BITPADR3 = BITPBNK3+BITSROW3+BITWRDS3+1;
  parameter BITPADR2 = BITPBNK2+BITPADR3+1;
  parameter BITPADR1 = BITPBNK1+BITPADR2+1;

  parameter BITMAPT = BITPBNK1*NUMPBNK1;
  parameter SDOUT_WIDTH = 2*BITMAPT+ECCBITS;

  input                                            refr;

  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]            read;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]            write;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*BITADDR-1:0]    addr;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0]      din;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]           rd_vld;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0]     rd_dout;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]           rd_serr;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]           rd_derr;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR1-1:0]  rd_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMPBNK1*NUMVBNK2*NUMVBNK3-1:0] t1_readA;
  output [NUMPBNK1*NUMVBNK2*NUMVBNK3-1:0] t1_writeA;
  output [NUMPBNK1*NUMVBNK2*NUMVBNK3*BITSROW3-1:0] t1_addrA;
  output [NUMPBNK1*NUMVBNK2*NUMVBNK3*BITDWSN-1:0] t1_dwsnA;
  output [NUMPBNK1*NUMVBNK2*NUMVBNK3*PHYWDTH3-1:0] t1_bwA;
  output [NUMPBNK1*NUMVBNK2*NUMVBNK3*PHYWDTH3-1:0] t1_dinA;
  input [NUMPBNK1*NUMVBNK2*NUMVBNK3*PHYWDTH3-1:0] t1_doutA;
  output [NUMPBNK1*NUMVBNK2*NUMVBNK3-1:0] t1_refrB;
  output [NUMPBNK1*NUMVBNK2*NUMVBNK3*BITRBNK3-1:0] t1_bankB;

  output [NUMPBNK1*NUMVBNK2-1:0] t2_readA;
  output [NUMPBNK1*NUMVBNK2-1:0] t2_writeA;
  output [NUMPBNK1*NUMVBNK2*BITSROW3-1:0] t2_addrA;
  output [NUMPBNK1*NUMVBNK2*BITDWSN-1:0] t2_dwsnA;
  output [NUMPBNK1*NUMVBNK2*PHYWDTH3-1:0] t2_bwA;
  output [NUMPBNK1*NUMVBNK2*PHYWDTH3-1:0] t2_dinA;
  input [NUMPBNK1*NUMVBNK2*PHYWDTH3-1:0] t2_doutA;
  output [NUMPBNK1*NUMVBNK2-1:0] t2_refrB;
  output [NUMPBNK1*NUMVBNK2*BITRBNK3-1:0] t2_bankB;

  output [NUMPBNK1*NUMVBNK3-1:0] t3_readA;
  output [NUMPBNK1*NUMVBNK3-1:0] t3_writeA;
  output [NUMPBNK1*NUMVBNK3*BITSROW3-1:0] t3_addrA;
  output [NUMPBNK1*NUMVBNK3*BITDWSN-1:0] t3_dwsnA;
  output [NUMPBNK1*NUMVBNK3*PHYWDTH3-1:0] t3_bwA;
  output [NUMPBNK1*NUMVBNK3*PHYWDTH3-1:0] t3_dinA;
  input [NUMPBNK1*NUMVBNK3*PHYWDTH3-1:0] t3_doutA;
  output [NUMPBNK1*NUMVBNK3-1:0] t3_refrB;
  output [NUMPBNK1*NUMVBNK3*BITRBNK3-1:0] t3_bankB;

  output [(NUMRWPT+NUMWRPT)-1:0] t4_writeA;
  output [(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t4_addrA;
  output [(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t4_dinA;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t4_readB;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t4_addrB;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t4_doutB;

`ifdef FORMAL 
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
wire [BITRBNK2-1:0] select_rbnk_a2;
wire [BITRBNK3-1:0] select_rbnk_a3;
wire [BITRROW-1:0] select_rrow;
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr == 0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit == 0));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));
assume_select_rbnk_a2_range: assume property (@(posedge clk) disable iff (rst) (select_rbnk_a2 < NUMRBNK2));
assume_select_rbnk_a2_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_rbnk_a2));
assume_select_rbnk_a3_range: assume property (@(posedge clk) disable iff (rst) (select_rbnk_a3 < NUMRBNK3));
assume_select_rbnk_a3_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_rbnk_a3));
assume_select_rrow_range: assume property (@(posedge clk) disable iff (rst) (select_rrow < NUMRROW));
assume_select_rrow_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_rrow));

wire [BITVROW1-1:0] select_addr_a2;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK1), .BITVBNK (BITVBNK1),
  .NUMVROW (NUMVROW1), .BITVROW (BITVROW1))
  adr_a2 (.vbadr(), .vradr(select_addr_a2), .vaddr(select_addr));
  
wire [BITVROW2-1:0] select_addr_a3;
np2_addr #(
  .NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
  .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2),
  .NUMVROW (NUMVROW2), .BITVROW (BITVROW2))
  adr_a3 (.vbadr(), .vradr(select_addr_a3), .vaddr(select_addr_a2));

wire [BITVROW3-1:0] select_vrow_a3;
np2_addr #(
  .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
  .NUMVBNK (NUMVBNK3), .BITVBNK (BITVBNK3),
  .NUMVROW (NUMVROW3), .BITVROW (BITVROW3))
  row_a3 (.vbadr(), .vradr(select_vrow_a3), .vaddr(select_addr_a3));
`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITVROW1-1:0] select_addr_a2 = 0;
wire [BITVROW2-1:0] select_addr_a3 = 0;
wire [BITVROW3-1:0] select_vrow_a3 = 0;
wire [BITRBNK2-1:0] select_rbnk_a2 = 0;
wire [BITRBNK3-1:0] select_rbnk_a3 = 0;
wire [BITRROW-1:0] select_rrow = 0;
`endif

wire [3*NUMPBNK1-1:0] t1_readA_a1;
wire [3*NUMPBNK1-1:0] t1_writeA_a1;
wire [3*NUMPBNK1*BITVROW1-1:0] t1_addrA_a1;
wire [3*NUMPBNK1*WIDTH-1:0] t1_dinA_a1;
wire [3*NUMPBNK1-1:0] t1_refrB_a1;
reg [3*NUMPBNK1*WIDTH-1:0] t1_doutA_a1;
reg [3*NUMPBNK1-1:0] t1_serrA_a1;
reg [3*NUMPBNK1-1:0] t1_derrA_a1;
reg [3*NUMPBNK1*BITPADR2-1:0] t1_padrA_a1;

wire [(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t4_doutB_a1;

wire [NUMPBNK1-1:0] a2_ready;

generate if (1) begin: a1_loop

algo_mrnrwpw_1rw_mt #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMRDPT (NUMRDPT), .NUMRWPT (NUMRWPT), .NUMWRPT (NUMWRPT),
                      .NUMVBNK(NUMVBNK1), .BITVBNK(BITVBNK1), .NUMVROW(NUMVROW1), .BITVROW(BITVROW1), .NUMPBNK(NUMPBNK1), .BITPBNK(BITPBNK1), .BITPADR(BITPADR1),
                      .REFRESH(REFRESH), .SRAM_DELAY(SRAM_DELAY+FLOPMEM), .DRAM_DELAY(DRAM_DELAY+FLOPMEM+FLOPIN2+FLOPOUT2+FLOPIN3+FLOPOUT3),
                      .FLOPIN(FLOPIN1), .FLOPOUT(FLOPOUT1), .ECCBITS(ECCBITS))
  algo (.ready(ready), .clk(clk), .rst (rst || !(&a2_ready)),
        .refr (refr), .read(read),. write(write), .addr(addr), .din(din), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
        .t1_readA(t1_readA_a1), .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
        .t1_doutA(t1_doutA_a1), .t1_serrA(t1_serrA_a1), .t1_derrA(t1_derrA_a1), .t1_padrA(t1_padrA_a1),
        .t1_refrB(t1_refrB_a1),
        .t2_writeA(t4_writeA), .t2_addrA(t4_addrA), .t2_dinA(t4_dinA), .t2_readB(t4_readB), .t2_addrB(t4_addrB), .t2_doutB(t4_doutB_a1),
	.select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

reg [3-1:0] t1_readA_a1_wire [0:NUMPBNK1-1];
reg t1_writeA_a1_wire [0:NUMPBNK1-1];
reg [3*BITVROW1-1:0] t1_radrA_a1_wire [0:NUMPBNK1-1];
reg [BITVROW1-1:0] t1_wadrA_a1_wire [0:NUMPBNK1-1];
reg [WIDTH-1:0] t1_dinA_a1_wire [0:NUMPBNK1-1];
reg t1_refrB_a1_wire [0:NUMPBNK1-1];
wire [3*WIDTH-1:0] t1_doutA_a1_wire [0:NUMPBNK1-1];
wire [3-1:0] t1_serrA_a1_wire [0:NUMPBNK1-1];
wire [3-1:0] t1_derrA_a1_wire [0:NUMPBNK1-1];
wire [3*BITPADR2-1:0] t1_padrA_a1_wire [0:NUMPBNK1-1];
integer a1_wire_int;
always_comb begin
  t1_doutA_a1 = 0;
  t1_serrA_a1 = 0;
  t1_derrA_a1 = 0;
  t1_padrA_a1 = 0;
  for (a1_wire_int=0; a1_wire_int<NUMPBNK1; a1_wire_int=a1_wire_int+1) begin
    t1_readA_a1_wire[a1_wire_int] = t1_readA_a1 >> (a1_wire_int*3);
    t1_writeA_a1_wire[a1_wire_int] = t1_writeA_a1 >> (a1_wire_int*3);
    t1_radrA_a1_wire[a1_wire_int] = t1_addrA_a1 >> (a1_wire_int*3*BITVROW1);
    t1_wadrA_a1_wire[a1_wire_int] = t1_addrA_a1 >> (a1_wire_int*3*BITVROW1);
    t1_dinA_a1_wire[a1_wire_int] = t1_dinA_a1 >> (a1_wire_int*3*WIDTH);
    t1_refrB_a1_wire[a1_wire_int] = t1_refrB_a1 >> (a1_wire_int*3);
    t1_doutA_a1 = t1_doutA_a1 | (t1_doutA_a1_wire[a1_wire_int] << (a1_wire_int*3*WIDTH));
    t1_serrA_a1 = t1_serrA_a1 | (t1_serrA_a1_wire[a1_wire_int] << a1_wire_int*3);
    t1_derrA_a1 = t1_derrA_a1 | (t1_derrA_a1_wire[a1_wire_int] << a1_wire_int*3);
    t1_padrA_a1 = t1_padrA_a1 | (t1_padrA_a1_wire[a1_wire_int] << (a1_wire_int*3*BITPADR2));
  end
end

wire [2*NUMVBNK2-1:0] t1_readA_a2 [0:NUMPBNK1-1];
wire [2*NUMVBNK2-1:0] t1_writeA_a2 [0:NUMPBNK1-1];
wire [2*NUMVBNK2*BITVROW2-1:0] t1_addrA_a2 [0:NUMPBNK1-1];
wire [2*NUMVBNK2*WIDTH-1:0] t1_dinA_a2 [0:NUMPBNK1-1];
reg [2*NUMVBNK2*WIDTH-1:0] t1_doutA_a2 [0:NUMPBNK1-1];
reg [2*NUMVBNK2-1:0] t1_serrA_a2 [0:NUMPBNK1-1];
reg [2*NUMVBNK2-1:0] t1_derrA_a2 [0:NUMPBNK1-1];
reg [2*NUMVBNK2*BITPADR3-1:0] t1_padrA_a2 [0:NUMPBNK1-1];
reg [2*NUMVBNK2-1:0] t1_refrB_a2 [0:NUMPBNK1-1];

wire [2-1:0] t3_readA_a2 [0:NUMPBNK1-1];
wire [2-1:0] t3_writeA_a2 [0:NUMPBNK1-1];
wire [2*BITVROW2-1:0] t3_addrA_a2 [0:NUMPBNK1-1];
wire [2*WIDTH-1:0] t3_dinA_a2 [0:NUMPBNK1-1];
reg [2*WIDTH-1:0] t3_doutA_a2 [0:NUMPBNK1-1];
reg [2-1:0] t3_serrA_a2 [0:NUMPBNK1-1];
reg [2-1:0] t3_derrA_a2 [0:NUMPBNK1-1];
reg [2*BITPADR3-1:0] t3_padrA_a2 [0:NUMPBNK1-1];
reg [2-1:0] t3_refrB_a2 [0:NUMPBNK1-1];

wire [NUMVBNK2-1:0] a3_ready [0:NUMPBNK1-1];
wire [NUMVBNK3-1:0] a4_ready [0:NUMPBNK1-1];

genvar a2;
generate for (a2=0; a2<NUMPBNK1; a2=a2+1) begin: a2_loop

  algo_nror1w_a20 #(.WIDTH (WIDTH), .BITWDTH(BITWDTH), .NUMADDR(NUMVROW1), .BITADDR(BITVROW1), .NUMVRPT(3), .NUMPRPT(2),
                    .NUMVROW(NUMVROW2), .BITVROW(BITVROW2), .NUMVBNK(NUMVBNK2), .BITVBNK(BITVBNK2), .BITPBNK(BITPBNK2), .BITPADR(BITPADR2),
                    .REFRESH(REFRESH), .REFFREQ(REFFREQ), .SRAM_DELAY(DRAM_DELAY+FLOPMEM+FLOPIN3+FLOPOUT3), .FLOPIN (FLOPIN2), .FLOPOUT (FLOPOUT2))
    algo (.refr (t1_refrB_a1_wire[a2]), .clk (clk), .rst (rst || !(&a3_ready[a2])), .ready (a2_ready[a2]),
          .write (t1_writeA_a1_wire[a2]), .wr_adr (t1_wadrA_a1_wire[a2]), .din (t1_dinA_a1_wire[a2]),
          .read (t1_readA_a1_wire[a2]), .rd_adr (t1_radrA_a1_wire[a2]), .rd_vld (), .rd_dout (t1_doutA_a1_wire[a2]),
          .rd_serr (t1_serrA_a1_wire[a2]), .rd_derr (t1_derrA_a1_wire[a2]), .rd_padr (t1_padrA_a1_wire[a2]),
          .t1_readA (t1_readA_a2[a2]), .t1_writeA (t1_writeA_a2[a2]), .t1_addrA (t1_addrA_a2[a2]), .t1_dinA (t1_dinA_a2[a2]), .t1_doutA (t1_doutA_a2[a2]),
          .t1_serrA (t1_serrA_a2[a2]), .t1_derrA (t1_derrA_a2[a2]), .t1_padrA (t1_padrA_a2[a2]), .t1_refrB (t1_refrB_a2[a2]),
          .t2_readA (t3_readA_a2[a2]), .t2_writeA (t3_writeA_a2[a2]), .t2_addrA (t3_addrA_a2[a2]), .t2_dinA (t3_dinA_a2[a2]), .t2_doutA (t3_doutA_a2[a2]),
          .t2_serrA (t3_serrA_a2[a2]), .t2_derrA (t3_derrA_a2[a2]), .t2_padrA (t3_padrA_a2[a2]), .t2_refrB (t3_refrB_a2[a2]),
          .select_addr (select_addr_a2), .select_bit (select_bit));

end
endgenerate

reg [2-1:0] t1_readA_a2_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
reg t1_writeA_a2_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
reg [2*BITVROW2-1:0] t1_radrA_a2_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
reg [BITVROW2-1:0] t1_wadrA_a2_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
reg [WIDTH-1:0] t1_dinA_a2_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
reg t1_refrB_a2_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire [2*WIDTH-1:0] t1_doutA_a2_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire [2-1:0] t1_serrA_a2_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire [2-1:0] t1_derrA_a2_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire [2*BITPADR3-1:0] t1_padrA_a2_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire [WIDTH-1:0] t3_doutA_a2_wire [0:NUMPBNK1-1][0:1-1];
wire t3_serrA_a2_wire [0:NUMPBNK1-1][0:1-1];
wire t3_derrA_a2_wire [0:NUMPBNK1-1][0:1-1];
wire [BITPADR4-1:0] t3_padrA_a2_wire [0:NUMPBNK1-1][0:1-1];
integer a2r_int, a2b_int;
always_comb begin
  for (a2r_int=0; a2r_int<NUMPBNK1; a2r_int=a2r_int+1) begin
    t1_doutA_a2[a2r_int] = 0;
    t1_serrA_a2[a2r_int] = 0;
    t1_derrA_a2[a2r_int] = 0;
    t1_padrA_a2[a2r_int] = 0;
    for (a2b_int=0; a2b_int<NUMVBNK2; a2b_int=a2b_int+1) begin
      t1_readA_a2_wire[a2r_int][a2b_int] = t1_readA_a2[a2r_int] >> (a2b_int*2);
      t1_writeA_a2_wire[a2r_int][a2b_int] = t1_writeA_a2[a2r_int] >> (a2b_int*2);
      t1_radrA_a2_wire[a2r_int][a2b_int] = t1_addrA_a2[a2r_int] >> (a2b_int*2*BITVROW2);
      t1_wadrA_a2_wire[a2r_int][a2b_int] = t1_addrA_a2[a2r_int] >> (a2b_int*2*BITVROW2);
      t1_dinA_a2_wire[a2r_int][a2b_int] = t1_dinA_a2[a2r_int] >> (a2b_int*2*WIDTH);
      t1_refrB_a2_wire[a2r_int][a2b_int] = t1_refrB_a2[a2r_int] >> (a2b_int*2);
      t1_doutA_a2[a2r_int] = t1_doutA_a2[a2r_int] | (t1_doutA_a2_wire[a2r_int][a2b_int] << (a2b_int*2*WIDTH));
      t1_serrA_a2[a2r_int] = t1_serrA_a2[a2r_int] | (t1_serrA_a2_wire[a2r_int][a2b_int] << (a2b_int*2));
      t1_derrA_a2[a2r_int] = t1_derrA_a2[a2r_int] | (t1_derrA_a2_wire[a2r_int][a2b_int] << (a2b_int*2));
      t1_padrA_a2[a2r_int] = t1_padrA_a2[a2r_int] | (t1_padrA_a2_wire[a2r_int][a2b_int] << (a2b_int*2*BITPADR3));
    end
    t3_doutA_a2[a2r_int] = t3_doutA_a2_wire[a2r_int][0];
    t3_serrA_a2[a2r_int] = t3_serrA_a2_wire[a2r_int][0];
    t3_derrA_a2[a2r_int] = t3_derrA_a2_wire[a2r_int][0];
    t3_padrA_a2[a2r_int] = t3_padrA_a2_wire[a2r_int][0];
  end
end

wire [NUMVBNK3-1:0] t1_readA_a3 [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire [NUMVBNK3-1:0] t1_writeA_a3 [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire [NUMVBNK3*BITVROW3-1:0] t1_addrA_a3 [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire [NUMVBNK3*WIDTH-1:0] t1_dinA_a3 [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire [NUMVBNK3-1:0] t1_refrB_a3 [0:NUMPBNK1-1][0:NUMVBNK2-1];
reg [NUMVBNK3*WIDTH-1:0] t1_doutA_a3 [0:NUMPBNK1-1][0:NUMVBNK2-1];
reg [NUMVBNK3-1:0] t1_serrA_a3 [0:NUMPBNK1-1][0:NUMVBNK2-1];
reg [NUMVBNK3-1:0] t1_derrA_a3 [0:NUMPBNK1-1][0:NUMVBNK2-1];
reg [NUMVBNK3*(BITSROW3+BITWRDS3)-1:0] t1_padrA_a3 [0:NUMPBNK1-1][0:NUMVBNK2-1];

wire [1-1:0] t2_readA_a3 [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire [1-1:0] t2_writeA_a3 [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire [1*BITVROW3-1:0] t2_addrA_a3 [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire [1*WIDTH-1:0] t2_dinA_a3 [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire [1-1:0] t2_refrB_a3 [0:NUMPBNK1-1][0:NUMVBNK2-1];
reg [1*WIDTH-1:0] t2_doutA_a3 [0:NUMPBNK1-1][0:NUMVBNK2-1];
reg [1-1:0] t2_serrA_a3 [0:NUMPBNK1-1][0:NUMVBNK2-1];
reg [1-1:0] t2_derrA_a3 [0:NUMPBNK1-1][0:NUMVBNK2-1];
reg [1*(BITSROW3+BITWRDS3)-1:0] t2_padrA_a3 [0:NUMPBNK1-1][0:NUMVBNK2-1];

genvar a3r, a3b;
generate
  for (a3r=0; a3r<NUMPBNK1; a3r=a3r+1) begin: a3r_loop
    for (a3b=0; a3b<NUMVBNK2; a3b=a3b+1) begin: a3b_loop

      algo_nror1w_a20 #(.WIDTH (WIDTH), .BITWDTH(BITWDTH), .NUMADDR(NUMVROW2), .BITADDR(BITVROW2), .NUMVRPT(2), .NUMPRPT(1),
                        .NUMVROW(NUMVROW3), .BITVROW(BITVROW3), .NUMVBNK(NUMVBNK3), .BITVBNK(BITVBNK3), .BITPBNK(BITPBNK3), .BITPADR(BITPADR3),
                        .REFRESH(REFRESH), .REFFREQ(REFFREQ), .SRAM_DELAY(DRAM_DELAY+FLOPMEM), .FLOPIN (FLOPIN3), .FLOPOUT (FLOPOUT3))
        algo (.refr (t1_refrB_a2_wire[a3r][a3b]), .clk (clk), .rst (rst), .ready (a3_ready[a3r][a3b]),
              .write (t1_writeA_a2_wire[a3r][a3b]), .wr_adr (t1_wadrA_a2_wire[a3r][a3b]), .din (t1_dinA_a2_wire[a3r][a3b]),
              .read (t1_readA_a2_wire[a3r][a3b]), .rd_adr (t1_radrA_a2_wire[a3r][a3b]), .rd_vld (), .rd_dout (t1_doutA_a2_wire[a3r][a3b]),
              .rd_serr (t1_serrA_a2_wire[a3r][a3b]), .rd_derr (t1_derrA_a2_wire[a3r][a3b]), .rd_padr (t1_padrA_a2_wire[a3r][a3b]),
              .t1_readA (t1_readA_a3[a3r][a3b]), .t1_writeA (t1_writeA_a3[a3r][a3b]), .t1_addrA (t1_addrA_a3[a3r][a3b]), .t1_dinA (t1_dinA_a3[a3r][a3b]),
              .t1_doutA (t1_doutA_a3[a3r][a3b]), .t1_serrA (t1_serrA_a3[a3r][a3b]), .t1_derrA (t1_derrA_a3[a3r][a3b]), .t1_padrA (t1_padrA_a3[a3r][a3b]),
              .t1_refrB (t1_refrB_a3[a3r][a3b]),
              .t2_readA (t2_readA_a3[a3r][a3b]), .t2_writeA (t2_writeA_a3[a3r][a3b]), .t2_addrA (t2_addrA_a3[a3r][a3b]), .t2_dinA (t2_dinA_a3[a3r][a3b]),
              .t2_doutA (t2_doutA_a3[a3r][a3b]), .t2_serrA (t2_serrA_a3[a3r][a3b]), .t2_derrA (t2_derrA_a3[a3r][a3b]), .t2_padrA (t2_padrA_a3[a3r][a3b]),
              .t2_refrB (t2_refrB_a3[a3r][a3b]),
              .select_addr (select_addr_a3), .select_bit (select_bit));

    end
  end
endgenerate

wire [WIDTH-1:0] t1_doutA_a3_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:NUMVBNK3-1];
wire t1_serrA_a3_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:NUMVBNK3-1];
wire t1_derrA_a3_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:NUMVBNK3-1];
wire [BITSROW3+BITWRDS3-1:0] t1_padrA_a3_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:NUMVBNK3-1];
wire t1_readA_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:NUMVBNK3-1];
wire t1_writeA_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:NUMVBNK3-1];
wire [BITSROW3-1:0] t1_addrA_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:NUMVBNK3-1];
wire [BITDWSN-1:0] t1_dwsnA_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:NUMVBNK3-1];
wire [NUMWRDS3*MEMWDTH-1:0] t1_bwA_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:NUMVBNK3-1];
wire [NUMWRDS3*MEMWDTH-1:0] t1_dinA_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:NUMVBNK3-1];
wire t1_refrB_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:NUMVBNK3-1];
wire [BITRBNK3-1:0] t1_bankB_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:NUMVBNK3-1];

genvar t1r, t1b, t1c;
generate
  for (t1r=0; t1r<NUMPBNK1; t1r=t1r+1) begin: t1r_loop
    for (t1b=0; t1b<NUMVBNK2; t1b=t1b+1) begin: t1b_loop
      for (t1c=0; t1c<NUMVBNK3; t1c=t1c+1) begin: t1c_loop
        wire t1_readA_a3_wire = t1_readA_a3[t1r][t1b] >> t1c;
        wire t1_writeA_a3_wire = t1_writeA_a3[t1r][t1b] >> t1c;
        wire [BITVROW3-1:0] t1_addrA_a3_wire = t1_addrA_a3[t1r][t1b] >> (t1c*BITVROW3);
        wire [WIDTH-1:0] t1_dinA_a3_wire = t1_dinA_a3[t1r][t1b] >> (t1c*WIDTH);
        wire t1_refrB_a3_wire = t1_refrB_a3[t1r][t1b] >> t1c;

        wire [NUMWRDS3*MEMWDTH-1:0] t1_doutA_wire = t1_doutA >> ((((t1r*NUMVBNK2+t1b)*NUMVBNK3)+t1c)*PHYWDTH3);

        if (1) begin: align_loop
          infra_align_dwsn #(.WIDTH (WIDTH), .PARITY (PARITY), .NUMADDR (NUMVROW3), .BITADDR (BITVROW3),
                             .NUMSROW (NUMSROW3), .BITSROW (BITSROW3), .NUMWRDS (NUMWRDS3), .BITWRDS (BITWRDS3), .BITPADR (BITSROW3+BITWRDS3),
                             .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                             .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                             .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                             .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                             .SRAM_DELAY (DRAM_DELAY), .FLOPMEM (FLOPMEM), .RSTZERO(1))
            infra (.read (t1_readA_a3_wire), .write (t1_writeA_a3_wire), .addr (t1_addrA_a3_wire), .din (t1_dinA_a3_wire),
                   .dout (t1_doutA_a3_wire[t1r][t1b][t1c]), .serr (t1_serrA_a3_wire[t1r][t1b][t1c]), .padr (t1_padrA_a3_wire[t1r][t1b][t1c]),
                   .mem_read (t1_readA_wire[t1r][t1b][t1c]), .mem_write (t1_writeA_wire[t1r][t1b][t1c]), .mem_addr (t1_addrA_wire[t1r][t1b][t1c]),
                   .mem_dwsn (t1_dwsnA_wire[t1r][t1b][t1c]), .mem_bw (t1_bwA_wire[t1r][t1b][t1c]), .mem_din (t1_dinA_wire[t1r][t1b][t1c]), .mem_dout (t1_doutA_wire),
                   .select_addr (select_vrow_a3),
                   .clk (clk), .rst (rst));
          assign t1_derrA_a3_wire[t1r][t1b][t1c] = 1'b0;
        end

        wire [BITRBNK3-1:0] t1_bankA_a3_wire = t1_addrA_wire[t1r][t1b][t1c] >> (BITSROW3-BITRBNK3-BITWSPF3);

        if (REFRESH==1) begin: refr_loop
          infra_refr_1stage #(.NUMRBNK (NUMRBNK3), .BITRBNK (BITRBNK3), .REFLOPW (REFLOPW),
                              .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
            infra (.clk (clk), .rst (rst),
                   .pref (t1_refrB_a3_wire), .pacc (t1_readA_a3_wire || t1_writeA_a3_wire), .pacbadr (t1_bankA_a3_wire),
                   .prefr (t1_refrB_wire[t1r][t1b][t1c]), .prfbadr (t1_bankB_wire[t1r][t1b][t1c]),
                   .select_rbnk (select_rbnk_a3), .select_rrow (select_rrow));
        end else begin: no_refr_loop
          assign t1_refrB_wire[t1r][t1b][t1c] = 1'b0;
          assign t1_bankB_wire[t1r][t1b][t1c] = 0;
        end
      end
    end
  end
endgenerate

reg [NUMPBNK1*NUMVBNK2*NUMVBNK3-1:0] t1_readA;
reg [NUMPBNK1*NUMVBNK2*NUMVBNK3-1:0] t1_writeA;
reg [NUMPBNK1*NUMVBNK2*NUMVBNK3*BITSROW3-1:0] t1_addrA;
reg [NUMPBNK1*NUMVBNK2*NUMVBNK3*BITDWSN-1:0] t1_dwsnA;
reg [NUMPBNK1*NUMVBNK2*NUMVBNK3*PHYWDTH3-1:0] t1_bwA;
reg [NUMPBNK1*NUMVBNK2*NUMVBNK3*PHYWDTH3-1:0] t1_dinA;
reg [NUMPBNK1*NUMVBNK2*NUMVBNK3-1:0] t1_refrB;
reg [NUMPBNK1*NUMVBNK2*NUMVBNK3*BITRBNK3-1:0] t1_bankB;
integer t1r_int, t1b_int, t1c_int;
always_comb begin
  t1_readA = 0;
  t1_writeA = 0;
  t1_addrA = 0;
  t1_dwsnA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  t1_refrB = 0;
  t1_bankB = 0;
  for (t1r_int=0; t1r_int<NUMPBNK1; t1r_int=t1r_int+1) begin
    for (t1b_int=0; t1b_int<NUMVBNK2; t1b_int=t1b_int+1) begin
      t1_doutA_a3[t1r_int][t1b_int] = 0;
      t1_serrA_a3[t1r_int][t1b_int] = 0;
      t1_derrA_a3[t1r_int][t1b_int] = 0;
      t1_padrA_a3[t1r_int][t1b_int] = 0;
      for (t1c_int=0; t1c_int<NUMVBNK3; t1c_int=t1c_int+1) begin
        t1_readA = t1_readA | (t1_readA_wire[t1r_int][t1b_int][t1c_int] << ((t1r_int*NUMVBNK2+t1b_int)*NUMVBNK3+t1c_int));
        t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int][t1b_int][t1c_int] << ((t1r_int*NUMVBNK2+t1b_int)*NUMVBNK3+t1c_int));
        t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int][t1b_int][t1c_int] << (((t1r_int*NUMVBNK2+t1b_int)*NUMVBNK3+t1c_int)*BITSROW3));
        t1_dwsnA = t1_dwsnA | (t1_dwsnA_wire[t1r_int][t1b_int][t1c_int] << (((t1r_int*NUMVBNK2+t1b_int)*NUMVBNK3+t1c_int)*BITDWSN));
        t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int][t1b_int][t1c_int] << (((t1r_int*NUMVBNK2+t1b_int)*NUMVBNK3+t1c_int)*PHYWDTH3));
        t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int][t1b_int][t1c_int] << (((t1r_int*NUMVBNK2+t1b_int)*NUMVBNK3+t1c_int)*PHYWDTH3));
        t1_refrB = t1_refrB | (t1_refrB_wire[t1r_int][t1b_int][t1c_int] << ((t1r_int*NUMVBNK2+t1b_int)*NUMVBNK3+t1c_int));
        t1_bankB = t1_bankB | (t1_bankB_wire[t1r_int][t1b_int][t1c_int] << (((t1r_int*NUMVBNK2+t1b_int)*NUMVBNK3+t1c_int)*BITRBNK3));
        t1_doutA_a3[t1r_int][t1b_int] = t1_doutA_a3[t1r_int][t1b_int] | (t1_doutA_a3_wire[t1r_int][t1b_int][t1c_int] << (t1c_int*WIDTH));
        t1_serrA_a3[t1r_int][t1b_int] = t1_serrA_a3[t1r_int][t1b_int] | (t1_serrA_a3_wire[t1r_int][t1b_int][t1c_int] << t1c_int);
        t1_derrA_a3[t1r_int][t1b_int] = t1_derrA_a3[t1r_int][t1b_int] | (t1_derrA_a3_wire[t1r_int][t1b_int][t1c_int] << t1c_int);
        t1_padrA_a3[t1r_int][t1b_int] = t1_padrA_a3[t1r_int][t1b_int] | (t1_padrA_a3_wire[t1r_int][t1b_int][t1c_int] << (t1c_int*(BITSROW3+BITWRDS3)));
      end
    end
  end
end

wire [WIDTH-1:0] t2_doutA_a3_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:1-1];
wire t2_serrA_a3_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:1-1];
wire t2_derrA_a3_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:1-1];
wire [BITSROW3+BITWRDS3-1:0] t2_padrA_a3_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:1-1];
wire t2_readA_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:1-1];
wire t2_writeA_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:1-1];
wire [BITSROW3-1:0] t2_addrA_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:1-1];
wire [BITDWSN-1:0] t2_dwsnA_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:1-1];
wire [NUMWRDS3*MEMWDTH-1:0] t2_bwA_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:1-1];
wire [NUMWRDS3*MEMWDTH-1:0] t2_dinA_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:1-1];
wire t2_refrB_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:1-1];
wire [BITRBNK3-1:0] t2_bankB_wire [0:NUMPBNK1-1][0:NUMVBNK2-1][0:1-1];

genvar t2r, t2b, t2c;
generate
  for (t2r=0; t2r<NUMPBNK1; t2r=t2r+1) begin: t2r_loop
    for (t2b=0; t2b<NUMVBNK2; t2b=t2b+1) begin: t2b_loop
      for (t2c=0; t2c<1; t2c=t2c+1) begin: t2c_loop
        wire t2_readA_a3_wire = t2_readA_a3[t2r][t2b] >> t2c;
        wire t2_writeA_a3_wire = t2_writeA_a3[t2r][t2b] >> t2c;
        wire [BITVROW3-1:0] t2_addrA_a3_wire = t2_addrA_a3[t2r][t2b] >> (t2c*BITVROW3);
        wire [WIDTH-1:0] t2_dinA_a3_wire = t2_dinA_a3[t2r][t2b] >> (t2c*WIDTH);
        wire t2_refrB_a3_wire = t2_refrB_a3[t2r][t2b] >> t2c;

        wire [NUMWRDS3*MEMWDTH-1:0] t2_doutA_wire = t2_doutA >> (((t2r*NUMVBNK2+t2b)+t2c)*PHYWDTH3);

        if (1) begin: align_loop
          infra_align_dwsn #(.WIDTH (WIDTH), .PARITY (PARITY), .NUMADDR (NUMVROW3), .BITADDR (BITVROW3),
                             .NUMSROW (NUMSROW3), .BITSROW (BITSROW3), .NUMWRDS (NUMWRDS3), .BITWRDS (BITWRDS3), .BITPADR (BITSROW3+BITWRDS3),
                             .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                             .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                             .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11), 
                             .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                             .SRAM_DELAY (DRAM_DELAY), .FLOPMEM (FLOPMEM), .RSTZERO(1))
            infra (.read (t2_readA_a3_wire), .write (t2_writeA_a3_wire), .addr (t2_addrA_a3_wire), .din (t2_dinA_a3_wire),
                   .dout (t2_doutA_a3_wire[t2r][t2b][t2c]), .serr (t2_serrA_a3_wire[t2r][t2b][t2c]), .padr (t2_padrA_a3_wire[t2r][t2b][t2c]),
                   .mem_read (t2_readA_wire[t2r][t2b][t2c]), .mem_write (t2_writeA_wire[t2r][t2b][t2c]), .mem_addr (t2_addrA_wire[t2r][t2b][t2c]),
                   .mem_dwsn (t2_dwsnA_wire[t2r][t2b][t2c]), .mem_bw (t2_bwA_wire[t2r][t2b][t2c]), .mem_din (t2_dinA_wire[t2r][t2b][t2c]), .mem_dout (t2_doutA_wire),
                   .select_addr (select_vrow_a3),
                   .clk (clk), .rst (rst));
          assign t2_derrA_a3_wire[t2r][t2b][t2c] = 1'b0;
        end

        wire [BITRBNK3-1:0] t2_bankA_a3_wire = t2_addrA_wire[t2r][t2b][t2c] >> (BITSROW3-BITRBNK3-BITWSPF3);

        if (REFRESH==1) begin: refr_loop
          infra_refr_1stage #(.NUMRBNK (NUMRBNK3), .BITRBNK (BITRBNK3), .REFLOPW (REFLOPW),
                              .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
            infra (.clk (clk), .rst (rst),
                   .pref (t2_refrB_a3_wire), .pacc (t2_readA_a3_wire || t2_writeA_a3_wire), .pacbadr (t2_bankA_a3_wire),
                   .prefr (t2_refrB_wire[t2r][t2b][t2c]), .prfbadr (t2_bankB_wire[t2r][t2b][t2c]),
                   .select_rbnk (select_rbnk_a3), .select_rrow (select_rrow));
        end else begin: no_refr_loop
          assign t2_refrB_wire[t2r][t2b][t2c] = 1'b0;
          assign t2_bankB_wire[t2r][t2b][t2c] = 0;
        end
      end
    end
  end
endgenerate

reg [NUMPBNK1*NUMVBNK2-1:0] t2_readA;
reg [NUMPBNK1*NUMVBNK2-1:0] t2_writeA;
reg [NUMPBNK1*NUMVBNK2*BITSROW3-1:0] t2_addrA;
reg [NUMPBNK1*NUMVBNK2*BITDWSN-1:0] t2_dwsnA;
reg [NUMPBNK1*NUMVBNK2*PHYWDTH3-1:0] t2_bwA;
reg [NUMPBNK1*NUMVBNK2*PHYWDTH3-1:0] t2_dinA;
reg [NUMPBNK1*NUMVBNK2-1:0] t2_refrB;
reg [NUMPBNK1*NUMVBNK2*BITRBNK3-1:0] t2_bankB;
integer t2r_int, t2b_int, t2c_int;
always_comb begin
  t2_readA = 0;
  t2_writeA = 0;
  t2_addrA = 0;
  t2_dwsnA = 0;
  t2_bwA = 0;
  t2_dinA = 0;
  t2_refrB = 0;
  t2_bankB = 0;
  for (t2r_int=0; t2r_int<NUMPBNK1; t2r_int=t2r_int+1) begin
    for (t2b_int=0; t2b_int<NUMVBNK2; t2b_int=t2b_int+1) begin
      t2_doutA_a3[t2r_int][t2b_int] = 0;
      t2_serrA_a3[t2r_int][t2b_int] = 0;
      t2_derrA_a3[t2r_int][t2b_int] = 0;
      t2_padrA_a3[t2r_int][t2b_int] = 0;
      for (t2c_int=0; t2c_int<1; t2c_int=t2c_int+1) begin
        t2_readA = t2_readA | (t2_readA_wire[t2r_int][t2b_int][t2c_int] << ((t2r_int*NUMVBNK2+t2b_int)+t2c_int));
        t2_writeA = t2_writeA | (t2_writeA_wire[t2r_int][t2b_int][t2c_int] << ((t2r_int*NUMVBNK2+t2b_int)+t2c_int));
        t2_addrA = t2_addrA | (t2_addrA_wire[t2r_int][t2b_int][t2c_int] << (((t2r_int*NUMVBNK2+t2b_int)+t2c_int)*BITSROW3));
        t2_dwsnA = t2_dwsnA | (t2_dwsnA_wire[t2r_int][t2b_int][t2c_int] << (((t2r_int*NUMVBNK2+t2b_int)+t2c_int)*BITDWSN));
        t2_bwA = t2_bwA | (t2_bwA_wire[t2r_int][t2b_int][t2c_int] << (((t2r_int*NUMVBNK2+t2b_int)+t2c_int)*PHYWDTH3));
        t2_dinA = t2_dinA | (t2_dinA_wire[t2r_int][t2b_int][t2c_int] << (((t2r_int*NUMVBNK2+t2b_int)+t2c_int)*PHYWDTH3));
        t2_refrB = t2_refrB | (t2_refrB_wire[t2r_int][t2b_int][t2c_int] << ((t2r_int*NUMVBNK2+t2b_int)+t2c_int));
        t2_bankB = t2_bankB | (t2_bankB_wire[t2r_int][t2b_int][t2c_int] << (((t2r_int*NUMVBNK2+t2b_int)+t2c_int)*BITRBNK3));
        t2_doutA_a3[t2r_int][t2b_int] = t2_doutA_a3[t2r_int][t2b_int] | (t2_doutA_a3_wire[t2r_int][t2b_int][t2c_int] << (t2c_int*WIDTH));
        t2_serrA_a3[t2r_int][t2b_int] = t2_serrA_a3[t2r_int][t2b_int] | (t2_serrA_a3_wire[t2r_int][t2b_int][t2c_int] << t2c_int);
        t2_derrA_a3[t2r_int][t2b_int] = t2_derrA_a3[t2r_int][t2b_int] | (t2_derrA_a3_wire[t2r_int][t2b_int][t2c_int] << t2c_int);
        t2_padrA_a3[t2r_int][t2b_int] = t2_padrA_a3[t2r_int][t2b_int] | (t2_padrA_a3_wire[t2r_int][t2b_int][t2c_int] << (t2c_int*(BITSROW3+BITWRDS3)));
      end
    end
  end
end

wire [NUMVBNK3-1:0] t3_readA_a4 [0:NUMPBNK1-1][0:1-1];
wire [NUMVBNK3-1:0] t3_writeA_a4 [0:NUMPBNK1-1][0:1-1];
wire [NUMVBNK3*BITVROW3-1:0] t3_addrA_a4 [0:NUMPBNK1-1][0:1-1];
wire [NUMVBNK3*WIDTH-1:0] t3_dinA_a4 [0:NUMPBNK1-1][0:1-1];
reg [NUMVBNK3*WIDTH-1:0] t3_doutA_a4 [0:NUMPBNK1-1][0:1-1];
reg [NUMVBNK3-1:0] t3_fwrdA_a4 [0:NUMPBNK1-1][0:1-1];
reg [NUMVBNK3-1:0] t3_serrA_a4 [0:NUMPBNK1-1][0:1-1];
reg [NUMVBNK3-1:0] t3_derrA_a4 [0:NUMPBNK1-1][0:1-1];
reg [NUMVBNK3*(BITSROW3+BITWRDS3)-1:0] t3_padrA_a4 [0:NUMPBNK1-1][0:1-1];
wire [NUMVBNK3-1:0] t3_refrB_a4 [0:NUMPBNK1-1][0:1-1];

genvar a4r, a4b;
generate
  for (a4r=0; a4r<NUMPBNK1; a4r=a4r+1) begin: a4r_loop
    for (a4b=0; a4b<1; a4b=a4b+1) begin: a4b_loop

      algo_nror1w_dup #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMVROW2), .BITADDR (BITVROW2), .NUMRDPT (1),
                        .NUMVROW (NUMVROW3), .BITVROW (BITVROW3), .NUMVBNK (NUMVBNK3), .BITVBNK (BITVBNK3), .BITPADR (BITPADR4),
                        .REFRESH (REFRESH), .SRAM_DELAY (DRAM_DELAY+FLOPMEM), .FLOPIN (FLOPIN3), .FLOPOUT (FLOPOUT3))
        algo (.refr (t3_refrB_a2[a4r][0]), .clk (clk), .rst (rst), .ready (a4_ready[a4r][a4b]),
              .write (t3_writeA_a2[a4r][0]), .wr_adr (t3_addrA_a2[a4r][BITVROW2-1:0]), .din (t3_dinA_a2[a4r][WIDTH-1:0]),
              .read (t3_readA_a2[a4r][0]), .rd_adr (t3_addrA_a2[a4r][BITVROW2-1:0]), .rd_vld (), .rd_dout (t3_doutA_a2_wire[a4r][a4b]),
              .rd_fwrd (), .rd_serr (t3_serrA_a2_wire[a4r][a4b]), .rd_derr (t3_derrA_a2_wire[a4r][a4b]), .rd_padr (t3_padrA_a2_wire[a4r][a4b]),
              .t1_readA (t3_readA_a4[a4r][a4b]), .t1_writeA (t3_writeA_a4[a4r][a4b]), .t1_addrA (t3_addrA_a4[a4r][a4b]),
              .t1_dinA (t3_dinA_a4[a4r][a4b]), .t1_doutA (t3_doutA_a4[a4r][a4b]),
              .t1_fwrdA (t3_fwrdA_a4[a4r][a4b]), .t1_serrA (t3_serrA_a4[a4r][a4b]), .t1_derrA (t3_derrA_a4[a4r][a4b]), .t1_padrA (t3_padrA_a4[a4r][a4b]),
              .t1_refrB (t3_refrB_a4[a4r][a4b]),
              .select_addr (select_addr_a3), .select_bit (select_bit));
    end
  end
endgenerate

wire [WIDTH-1:0] t3_doutA_a4_wire [0:NUMPBNK1-1][0:1-1][0:NUMVBNK3-1];
wire t3_fwrdA_a4_wire [0:NUMPBNK1-1][0:1-1][0:NUMVBNK3-1];
wire t3_serrA_a4_wire [0:NUMPBNK1-1][0:1-1][0:NUMVBNK3-1];
wire t3_derrA_a4_wire [0:NUMPBNK1-1][0:1-1][0:NUMVBNK3-1];
wire [BITSROW3+BITWRDS3-1:0] t3_padrA_a4_wire [0:NUMPBNK1-1][0:1-1][0:NUMVBNK3-1];
wire t3_readA_wire [0:NUMPBNK1-1][0:1-1][0:NUMVBNK3-1];
wire t3_writeA_wire [0:NUMPBNK1-1][0:1-1][0:NUMVBNK3-1];
wire [BITSROW3-1:0] t3_addrA_wire [0:NUMPBNK1-1][0:1-1][0:NUMVBNK3-1];
wire [BITDWSN-1:0] t3_dwsnA_wire [0:NUMPBNK1-1][0:1-1][0:NUMVBNK3-1];
wire [NUMWRDS3*MEMWDTH-1:0] t3_bwA_wire [0:NUMPBNK1-1][0:1-1][0:NUMVBNK3-1];
wire [NUMWRDS3*MEMWDTH-1:0] t3_dinA_wire [0:NUMPBNK1-1][0:1-1][0:NUMVBNK3-1];
wire t3_refrB_wire [0:NUMPBNK1-1][0:1-1][0:NUMVBNK3-1];
wire [BITRBNK3-1:0] t3_bankB_wire [0:NUMPBNK1-1][0:1-1][0:NUMVBNK3-1];

genvar t3r, t3b, t3c;
generate
  for (t3r=0; t3r<NUMPBNK1; t3r=t3r+1) begin: t3r_loop
    for (t3b=0; t3b<1; t3b=t3b+1) begin: t3b_loop
      for (t3c=0; t3c<NUMVBNK3; t3c=t3c+1) begin: t3c_loop
        wire t3_readA_a4_wire = t3_readA_a4[t3r][t3b] >> t3c;
        wire t3_writeA_a4_wire = t3_writeA_a4[t3r][t3b] >> t3c;
        wire [BITVROW3-1:0] t3_addrA_a4_wire = t3_addrA_a4[t3r][t3b] >> (t3c*BITVROW3);
        wire [WIDTH-1:0] t3_dinA_a4_wire = t3_dinA_a4[t3r][t3b] >> (t3c*WIDTH);
        wire t3_refrB_a4_wire = t3_refrB_a4[t3r][t3b] >> t3c;

        wire [NUMWRDS3*MEMWDTH-1:0] t3_doutA_wire = t3_doutA >> (((t3r*NUMVBNK3+t3b)+t3c)*PHYWDTH3);

        if (1) begin: align_loop
          infra_align_dwsn #(.WIDTH (WIDTH), .PARITY (PARITY), .NUMADDR (NUMVROW3), .BITADDR (BITVROW3),
                             .NUMSROW (NUMSROW3), .BITSROW (BITSROW3), .NUMWRDS (NUMWRDS3), .BITWRDS (BITWRDS3), .BITPADR (BITSROW3+BITWRDS3),
                             .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                             .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                             .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                             .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                             .SRAM_DELAY (DRAM_DELAY), .FLOPMEM (FLOPMEM), .RSTZERO (1))
            infra (.read (t3_readA_a4_wire), .write (t3_writeA_a4_wire), .addr (t3_addrA_a4_wire), .din (t3_dinA_a4_wire),
                   .dout (t3_doutA_a4_wire[t3r][t3b][t3c]), .serr (t3_serrA_a4_wire[t3r][t3b][t3c]), .padr (t3_padrA_a4_wire[t3r][t3b][t3c]),
                   .mem_read (t3_readA_wire[t3r][t3b][t3c]), .mem_write (t3_writeA_wire[t3r][t3b][t3c]), .mem_addr (t3_addrA_wire[t3r][t3b][t3c]),
                   .mem_dwsn (t3_dwsnA_wire[t3r][t3b][t3c]), .mem_bw (t3_bwA_wire[t3r][t3b][t3c]), .mem_din (t3_dinA_wire[t3r][t3b][t3c]), .mem_dout (t3_doutA_wire),
                   .select_addr (select_vrow_a3),
                   .clk (clk), .rst (rst));
          assign t3_fwrdA_a4_wire[t3r][t3b][t3c] = 1'b0;
          assign t3_derrA_a4_wire[t3r][t3b][t3c] = 1'b0;
        end

        wire [BITRBNK3-1:0] t3_bankA_a4_wire = t3_addrA_wire[t3r][t3b][t3c] >> (BITSROW3-BITRBNK3-BITWSPF3);

        if (REFRESH==1) begin: refr_loop
          infra_refr_1stage #(.NUMRBNK (NUMRBNK3), .BITRBNK (BITRBNK3), .REFLOPW (REFLOPW),
                              .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
            infra (.clk (clk), .rst (rst),
                   .pref (t3_refrB_a4_wire), .pacc (t3_readA_a4_wire || t3_writeA_a4_wire), .pacbadr (t3_bankA_a4_wire),
                   .prefr (t3_refrB_wire[t3r][t3b][t3c]), .prfbadr (t3_bankB_wire[t3r][t3b][t3c]),
                   .select_rbnk (select_rbnk_a3), .select_rrow (select_rrow));
        end else begin: no_refr_loop
          assign t3_refrB_wire[t3r][t3b][t3c] = 1'b0;
          assign t3_bankB_wire[t3r][t3b][t3c] = 0;
        end
      end
    end
  end
endgenerate

reg [NUMPBNK1*NUMVBNK3-1:0] t3_readA;
reg [NUMPBNK1*NUMVBNK3-1:0] t3_writeA;
reg [NUMPBNK1*NUMVBNK3*BITSROW3-1:0] t3_addrA;
reg [NUMPBNK1*NUMVBNK3*BITDWSN-1:0] t3_dwsnA;
reg [NUMPBNK1*NUMVBNK3*PHYWDTH3-1:0] t3_bwA;
reg [NUMPBNK1*NUMVBNK3*PHYWDTH3-1:0] t3_dinA;
reg [NUMPBNK1*NUMVBNK3-1:0] t3_refrB;
reg [NUMPBNK1*NUMVBNK3*BITRBNK3-1:0] t3_bankB;
integer t3r_int, t3b_int, t3c_int;
always_comb begin
  t3_readA = 0;
  t3_writeA = 0;
  t3_addrA = 0;
  t3_dwsnA = 0;
  t3_bwA = 0;
  t3_dinA = 0;
  t3_refrB = 0;
  t3_bankB = 0;
  for (t3r_int=0; t3r_int<NUMPBNK1; t3r_int=t3r_int+1) begin
    for (t3b_int=0; t3b_int<1; t3b_int=t3b_int+1) begin
      t3_doutA_a4[t3r_int][t3b_int] = 0;
      t3_fwrdA_a4[t3r_int][t3b_int] = 0;
      t3_serrA_a4[t3r_int][t3b_int] = 0;
      t3_derrA_a4[t3r_int][t3b_int] = 0;
      t3_padrA_a4[t3r_int][t3b_int] = 0;
      for (t3c_int=0; t3c_int<NUMVBNK3; t3c_int=t3c_int+1) begin
        t3_readA = t3_readA | (t3_readA_wire[t3r_int][t3b_int][t3c_int] << ((t3r_int*NUMVBNK3+t3b_int)+t3c_int));
        t3_writeA = t3_writeA | (t3_writeA_wire[t3r_int][t3b_int][t3c_int] << ((t3r_int*NUMVBNK3+t3b_int)+t3c_int));
        t3_addrA = t3_addrA | (t3_addrA_wire[t3r_int][t3b_int][t3c_int] << (((t3r_int*NUMVBNK3+t3b_int)+t3c_int)*BITSROW3));
        t3_dwsnA = t3_dwsnA | (t3_dwsnA_wire[t3r_int][t3b_int][t3c_int] << (((t3r_int*NUMVBNK3+t3b_int)+t3c_int)*BITDWSN));
        t3_bwA = t3_bwA | (t3_bwA_wire[t3r_int][t3b_int][t3c_int] << (((t3r_int*NUMVBNK3+t3b_int)+t3c_int)*PHYWDTH3));
        t3_dinA = t3_dinA | (t3_dinA_wire[t3r_int][t3b_int][t3c_int] << (((t3r_int*NUMVBNK3+t3b_int)+t3c_int)*PHYWDTH3));
        t3_refrB = t3_refrB | (t3_refrB_wire[t3r_int][t3b_int][t3c_int] << ((t3r_int*NUMVBNK3+t3b_int)+t3c_int));
        t3_bankB = t3_bankB | (t3_bankB_wire[t3r_int][t3b_int][t3c_int] << (((t3r_int*NUMVBNK3+t3b_int)+t3c_int)*BITRBNK3));
        t3_doutA_a4[t3r_int][t3b_int] = t3_doutA_a4[t3r_int][t3b_int] | (t3_doutA_a4_wire[t3r_int][t3b_int][t3c_int] << (t3c_int*WIDTH));
        t3_fwrdA_a4[t3r_int][t3b_int] = t3_fwrdA_a4[t3r_int][t3b_int] | (t3_fwrdA_a4_wire[t3r_int][t3b_int][t3c_int] << t3c_int);
        t3_serrA_a4[t3r_int][t3b_int] = t3_serrA_a4[t3r_int][t3b_int] | (t3_serrA_a4_wire[t3r_int][t3b_int][t3c_int] << t3c_int);
        t3_derrA_a4[t3r_int][t3b_int] = t3_derrA_a4[t3r_int][t3b_int] | (t3_derrA_a4_wire[t3r_int][t3b_int][t3c_int] << t3c_int);
        t3_padrA_a4[t3r_int][t3b_int] = t3_padrA_a4[t3r_int][t3b_int] | (t3_padrA_a4_wire[t3r_int][t3b_int][t3c_int] << (t3c_int*(BITSROW3+BITWRDS3)));
      end
    end
  end
end

/*
wire [WIDTH-1:0] t3_doutA_a2_wire [0:NUMPBNK1-1][0:1-1];
wire t3_serrA_a2_wire [0:NUMPBNK1-1][0:1-1];
wire t3_derrA_a2_wire [0:NUMPBNK1-1][0:1-1];
wire [BITSROW2+BITWRDS2-1:0] t3_padrA_a2_wire [0:NUMPBNK1-1][0:1-1];
wire t3_readA_wire [0:NUMPBNK1-1][0:1-1];
wire t3_writeA_wire [0:NUMPBNK1-1][0:1-1];
wire [BITSROW2-1:0] t3_addrA_wire [0:NUMPBNK1-1][0:1-1];
wire [BITDWSN-1:0] t3_dwsnA_wire [0:NUMPBNK1-1][0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t3_bwA_wire [0:NUMPBNK1-1][0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t3_dinA_wire [0:NUMPBNK1-1][0:1-1];
wire t3_refrB_wire [0:NUMPBNK1-1][0:1-1];
wire [BITRBNK2-1:0] t3_bankB_wire [0:NUMPBNK1-1][0:1-1];

genvar t3r, t3b;
generate
  for (t3r=0; t3r<NUMPBNK1; t3r=t3r+1) begin: t3r_loop
    for (t3b=0; t3b<1; t3b=t3b+1) begin: t3b_loop
      wire t3_readA_a2_wire = t3_readA_a2[t3r] >> t3b;
      wire t3_writeA_a2_wire = t3_writeA_a2[t3r] >> t3b;
      wire [BITVROW2-1:0] t3_addrA_a2_wire = t3_addrA_a2[t3r] >> (t3b*BITVROW2);
      wire [WIDTH-1:0] t3_dinA_a2_wire = t3_dinA_a2[t3r] >> (t3b*WIDTH);
      wire t3_refrB_a2_wire = t3_refrB_a2[t3r] >> t3b;

      wire [NUMWRDS2*MEMWDTH-1:0] t3_doutA_wire = t3_doutA >> ((t3r*1+t3b)*PHYWDTH2);

      if (1) begin: align_loop
        infra_align_dwsn #(.WIDTH (WIDTH), .PARITY (PARITY), .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                           .NUMSROW (NUMSROW2), .BITSROW (BITSROW2), .NUMWRDS (NUMWRDS2), .BITWRDS (BITWRDS2), .BITPADR (BITSROW2+BITWRDS2),
                           .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                           .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                           .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                           .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                           .SRAM_DELAY (DRAM_DELAY), .FLOPMEM (FLOPMEM), .RSTZERO(1))
          infra (.read (t3_readA_a2_wire), .write (t3_writeA_a2_wire), .addr (t3_addrA_a2_wire), .din (t3_dinA_a2_wire),
                 .dout (t3_doutA_a2_wire[t3r][t3b]), .serr (t3_serrA_a2_wire[t3r][t3b]), .padr (t3_padrA_a2_wire[t3r][t3b]),
                 .mem_read (t3_readA_wire[t3r][t3b]), .mem_write (t3_writeA_wire[t3r][t3b]), .mem_addr (t3_addrA_wire[t3r][t3b]),
                 .mem_dwsn (t3_dwsnA_wire[t3r][t3b]), .mem_bw (t3_bwA_wire[t3r][t3b]), .mem_din (t3_dinA_wire[t3r][t3b]), .mem_dout (t3_doutA_wire),
                 .select_addr (select_addr_a3),
                 .clk (clk), .rst (rst));
        assign t3_derrA_a2_wire[t3r][t3b] = 1'b0;
      end

      wire [BITRBNK2-1:0] t3_bankA_a2_wire = t3_addrA_wire[t3r][t3b] >> (BITSROW2-BITRBNK2-BITWSPF2);

      if (REFRESH==1) begin: refr_loop
        infra_refr_1stage #(.NUMRBNK (NUMRBNK2), .BITRBNK (BITRBNK2), .REFLOPW (REFLOPW),
                            .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
          infra (.clk (clk), .rst (rst),
                 .pref (t3_refrB_a2_wire), .pacc (t3_readA_a2_wire || t3_writeA_a2_wire), .pacbadr (t3_bankA_a2_wire),
                 .prefr (t3_refrB_wire[t3r][t3b]), .prfbadr (t3_bankB_wire[t3r][t3b]),
                 .select_rbnk (select_rbnk_a2), .select_rrow (select_rrow));
      end else begin: no_refr_loop
        assign t3_refrB_wire[t3r][t3b] = 1'b0;
        assign t3_bankB_wire[t3r][t3b] = 0;
      end
    end
  end
endgenerate

reg [NUMPBNK1-1:0] t3_readA;
reg [NUMPBNK1-1:0] t3_writeA;
reg [NUMPBNK1*BITSROW2-1:0] t3_addrA;
reg [NUMPBNK1*BITDWSN-1:0] t3_dwsnA;
reg [NUMPBNK1*PHYWDTH2-1:0] t3_bwA;
reg [NUMPBNK1*PHYWDTH2-1:0] t3_dinA;
reg [NUMPBNK1-1:0] t3_refrB;
reg [NUMPBNK1*BITRBNK2-1:0] t3_bankB;
integer t3r_int, t3b_int;
always_comb begin
  t3_readA = 0;
  t3_writeA = 0;
  t3_addrA = 0;
  t3_dwsnA = 0;
  t3_bwA = 0;
  t3_dinA = 0;
  t3_refrB = 0;
  t3_bankB = 0;
  for (t3r_int=0; t3r_int<NUMPBNK1; t3r_int=t3r_int+1) begin
    t3_doutA_a2[t3r_int] = 0;
    t3_serrA_a2[t3r_int] = 0;
    t3_derrA_a2[t3r_int] = 0;
    t3_padrA_a2[t3r_int] = 0;
    for (t3b_int=0; t3b_int<1; t3b_int=t3b_int+1) begin
      t3_readA = t3_readA | (t3_readA_wire[t3r_int][t3b_int] << (t3r_int*1+t3b_int));
      t3_writeA = t3_writeA | (t3_writeA_wire[t3r_int][t3b_int] << (t3r_int*1+t3b_int));
      t3_addrA = t3_addrA | (t3_addrA_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*BITSROW2));
      t3_dwsnA = t3_dwsnA | (t3_dwsnA_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*BITDWSN));
      t3_bwA = t3_bwA | (t3_bwA_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*PHYWDTH2));
      t3_dinA = t3_dinA | (t3_dinA_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*PHYWDTH2));
      t3_refrB = t3_refrB | (t3_refrB_wire[t3r_int][t3b_int] << (t3r_int*1+t3b_int));
      t3_bankB = t3_bankB | (t3_bankB_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*BITRBNK2));
      t3_doutA_a2[t3r_int] = t3_doutA_a2[t3r_int] | (t3_doutA_a2_wire[t3r_int][t3b_int] << (t3b_int*WIDTH));
      t3_serrA_a2[t3r_int] = t3_serrA_a2[t3r_int] | (t3_serrA_a2_wire[t3r_int][t3b_int] << t3b_int);
      t3_derrA_a2[t3r_int] = t3_derrA_a2[t3r_int] | (t3_derrA_a2_wire[t3r_int][t3b_int] << t3b_int);
      t3_padrA_a2[t3r_int] = t3_padrA_a2[t3r_int] | (t3_padrA_a2_wire[t3r_int][t3b_int] << (t3b_int*(BITSROW2+BITWRDS2)));
    end
  end
end
*/
generate if (FLOPMEM) begin: t4_flp_loop
  reg [(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t4_doutB_reg;
  always @(posedge clk) begin
    t4_doutB_reg <= t4_doutB;
  end

  assign t4_doutB_a1 = t4_doutB_reg;
end else begin: t4_noflp_loop
  assign t4_doutB_a1 = t4_doutB;
end
endgenerate

`ifdef FORMAL
genvar rerr_int, werr_int;
generate
  for (rerr_int=0; rerr_int<NUMPBNK1; rerr_int=rerr_int+1) begin: rerr_loop
    for (werr_int=0; werr_int<NUMVBNK2; werr_int=werr_int+1) begin: werr_loop
      assume_wr_rerr_check: assert property (@(posedge clk) disable iff (rst) (ready || a2_loop[rerr_int].algo.ip_top_sva.wr_nerr[werr_int]));
      assume_wr_nerr_check: assert property (@(posedge clk) disable iff (rst) (a3r_loop[rerr_int].a3b_loop[werr_int].algo.ip_top_sva.write &&
                                                                               (a3r_loop[rerr_int].a3b_loop[werr_int].algo.ip_top_sva.wr_row == select_vrow_a3)) |->
                                             (a2_loop[rerr_int].algo.ip_top_sva.wr_nerr[werr_int] == &a3r_loop[rerr_int].a3b_loop[werr_int].algo.ip_top_sva.mem_nerr[0]));
      assume_wr_serr_check: assert property (@(posedge clk) disable iff (rst) (a3r_loop[rerr_int].a3b_loop[werr_int].algo.ip_top_sva.write &&
                                                                               (a3r_loop[rerr_int].a3b_loop[werr_int].algo.ip_top_sva.wr_row == select_vrow_a3) &&
                                                                               |a3r_loop[rerr_int].a3b_loop[werr_int].algo.ip_top_sva.mem_serr[0]) |->
                                             (a2_loop[rerr_int].algo.ip_top_sva.t1_writeA_wire[werr_int] &&
                                              (a2_loop[rerr_int].algo.ip_top_sva.t1_addrA_wire[0][werr_int] == select_addr_a3) &&
                                              a2_loop[rerr_int].algo.ip_top_sva.wr_serr[werr_int]));
    end
  end
endgenerate
/*
assume_xmem_nerr_check: assert property (@(posedge clk) disable iff (rst)
                                         (a1_loop.algo.ip_top_sva.xmem_nerr[0] == t2_loop[0].align_loop.infra.ip_top_sva.mem_nerr));
assume_xmem_serr_check: assert property (@(posedge clk) disable iff (rst)
                                         (a1_loop.algo.ip_top_sva.xmem_serr[0] == t2_loop[0].align_loop.infra.ip_top_sva.mem_serr));
*/
`endif

endmodule
