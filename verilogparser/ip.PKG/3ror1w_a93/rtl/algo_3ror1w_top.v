
module algo_3ror1w_top (refr, clk, rst, ready,
                        write, wr_adr, din,
                        read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
	                t1_readA, t1_writeA, t1_addrA, t1_dwsnA, t1_bwA, t1_dinA, t1_doutA, t1_serrA, t1_refrB, t1_bankB,
	                t2_readA, t2_writeA, t2_addrA, t2_dwsnA, t2_bwA, t2_dinA, t2_doutA, t2_serrA, t2_refrB, t2_bankB,
	                t3_readA, t3_writeA, t3_addrA, t3_dwsnA, t3_bwA, t3_dinA, t3_doutA, t3_serrA, t3_refrB, t3_bankB);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAEXT = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter MEMWDTH = ENAEXT ? WIDTH : ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW1 = 1024;   // ALGO1 Parameters
  parameter BITVROW1 = 10;
  parameter NUMVBNK1 = 8;
  parameter BITVBNK1 = 3;
  parameter BITPBNK1 = 4;
  parameter FLOPIN1 = 0;
  parameter FLOPOUT1 = 0;
  parameter NUMWRDS1 = 4; 
  parameter BITWRDS1 = 2;
  parameter NUMSROW1 = 64;
  parameter BITSROW1 = 6;
  parameter PHYWDTH1 = NUMWRDS1*MEMWDTH;
  parameter NUMRBNK1 = 8;
  parameter BITRBNK1 = 3;
  parameter BITWSPF1 = 0;
  parameter NUMVROW2 = 256;    // ALGO2 Parameters
  parameter BITVROW2 = 8;
  parameter NUMVBNK2 = 4;
  parameter BITVBNK2 = 2;
  parameter BITPBNK2 = 3;
  parameter FLOPIN2 = 0;
  parameter FLOPOUT2 = 0;
  parameter NUMWRDS2 = 4; 
  parameter BITWRDS2 = 2;
  parameter NUMSROW2 = 64;
  parameter BITSROW2 = 6;
  parameter PHYWDTH2 = NUMWRDS2*MEMWDTH;
  parameter NUMRBNK2 = 8;
  parameter BITRBNK2 = 3;
  parameter BITWSPF2 = 0;
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
  parameter SRAM_DELAY = 2;
  parameter FLOPECC = 0;
  parameter FLOPMEM = 0;
  parameter FLOPCMD = 0;

  parameter BITPADR3 = BITVBNK2+BITSROW2+BITWRDS2;
  parameter BITPADR2 = BITPBNK2+BITSROW2+BITWRDS2;
  parameter BITPADR1 = BITPBNK1+BITPADR2+1;

  input                                refr;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input [3-1:0]                        read;
  input [3*BITADDR-1:0]                rd_adr;
  output [3-1:0]                       rd_vld;
  output [3*WIDTH-1:0]                 rd_dout;
  output [3-1:0]                       rd_serr;
  output [3-1:0]                       rd_derr;
  output [3*BITPADR1-1:0]              rd_padr;

  output                               ready;
  input                                clk, rst;

  output [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
  output [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrA;
  output [NUMVBNK1*NUMVBNK2*BITDWSN-1:0] t1_dwsnA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_doutA;
  input [NUMVBNK1*NUMVBNK2-1:0] t1_serrA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_refrB;
  output [NUMVBNK1*NUMVBNK2*BITRBNK2-1:0] t1_bankB;

  output [NUMVBNK1-1:0] t2_readA;
  output [NUMVBNK1-1:0] t2_writeA;
  output [NUMVBNK1*BITSROW2-1:0] t2_addrA;
  output [NUMVBNK1*BITDWSN-1:0] t2_dwsnA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_bwA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_dinA;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_doutA;
  input [NUMVBNK1-1:0] t2_serrA;
  output [NUMVBNK1-1:0] t2_refrB;
  output [NUMVBNK1*BITRBNK2-1:0] t2_bankB;

  output [NUMVBNK2-1:0] t3_readA;
  output [NUMVBNK2-1:0] t3_writeA;
  output [NUMVBNK2*BITSROW2-1:0] t3_addrA;
  output [NUMVBNK2*BITDWSN-1:0] t3_dwsnA;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_bwA;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_dinA;
  input [NUMVBNK2*PHYWDTH2-1:0] t3_doutA;
  input [NUMVBNK2-1:0] t3_serrA;
  output [NUMVBNK2-1:0] t3_refrB;
  output [NUMVBNK2*BITRBNK2-1:0] t3_bankB;

`ifdef FORMAL
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
wire [BITRBNK1-1:0] select_rbnk1;
wire [BITRBNK2-1:0] select_rbnk2;
wire [BITRROW-1:0] select_rrow;
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr == 0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit == 0));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));
assume_select_rbnk1_range: assume property (@(posedge clk) disable iff (rst) (select_rbnk1 < NUMRBNK1));
assume_select_rbnk1_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_rbnk1));
assume_select_rbnk2_range: assume property (@(posedge clk) disable iff (rst) (select_rbnk2 < NUMRBNK2));
assume_select_rbnk2_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_rbnk2));
assume_select_rrow_range: assume property (@(posedge clk) disable iff (rst) (select_rrow < NUMRROW));
assume_select_rrow_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_rrow));

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
wire [BITRBNK1-1:0] select_rbnk1 = 0;
wire [BITRBNK2-1:0] select_rbnk2 = 0;
wire [BITRROW-1:0] select_rrow = 0;
`endif

wire [2*NUMVBNK1-1:0] t1_readA_a1;
wire [2*NUMVBNK1-1:0] t1_writeA_a1;
wire [2*NUMVBNK1*BITVROW1-1:0] t1_addrA_a1;
wire [2*NUMVBNK1*WIDTH-1:0] t1_dinA_a1;
wire [2*NUMVBNK1-1:0] t1_refrB_a1;
reg [2*NUMVBNK1*WIDTH-1:0] t1_doutA_a1;
reg [2*NUMVBNK1-1:0] t1_fwrdA_a1;
reg [2*NUMVBNK1-1:0] t1_serrA_a1;
reg [2*NUMVBNK1-1:0] t1_derrA_a1;
reg [2*NUMVBNK1*BITPADR2-1:0] t1_padrA_a1;

wire [2-1:0] t3_readA_a1;
wire [2-1:0] t3_writeA_a1;
wire [2*BITVROW1-1:0] t3_addrA_a1;
wire [2*WIDTH-1:0] t3_dinA_a1;
wire [2-1:0] t3_refrB_a1;
reg [2*WIDTH-1:0] t3_doutA_a1;
reg [2-1:0] t3_fwrdA_a1;
reg [2-1:0] t3_serrA_a1;
reg [2-1:0] t3_derrA_a1;
reg [2*BITPADR2-1:0] t3_padrA_a1;

wire [NUMVBNK1-1:0] a2_ready;
wire a3_ready;

generate if (1) begin: a1_loop

  algo_nror1w #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMVRPT (3), .NUMPRPT (2),
                .NUMVROW (NUMVROW1), .BITVROW (BITVROW1), .NUMVBNK (NUMVBNK1), .BITVBNK (BITVBNK1), .BITPBNK (BITPBNK1), .BITPADR (BITPADR1-1),
                .REFRESH (REFRESH), .REFFREQ (REFFREQ), .SRAM_DELAY (SRAM_DELAY+FLOPECC+FLOPCMD+FLOPMEM+FLOPIN2+FLOPOUT2), .FLOPIN (FLOPIN1), .FLOPOUT (FLOPOUT1))
    algo (.refr (refr), .clk (clk), .rst (rst || !(&a2_ready) || !a3_ready), .ready (ready),
          .write (write), .wr_adr (wr_adr), .din (din),
	  .read (read), .rd_adr (rd_adr), .rd_vld (rd_vld), .rd_dout (rd_dout),
	  .rd_fwrd ({rd_padr[3*BITPADR1-1],rd_padr[2*BITPADR1-1],rd_padr[BITPADR1-1]}), .rd_serr (rd_serr), .rd_derr (rd_derr),
          .rd_padr ({rd_padr[3*BITPADR1-2:2*BITPADR1],rd_padr[2*BITPADR1-2:BITPADR1],rd_padr[BITPADR1-2:0]}),
          .t1_readA (t1_readA_a1), .t1_writeA (t1_writeA_a1), .t1_addrA (t1_addrA_a1), .t1_dinA (t1_dinA_a1), .t1_doutA (t1_doutA_a1),
	  .t1_fwrdA (t1_fwrdA_a1), .t1_serrA (t1_serrA_a1), .t1_derrA (t1_derrA_a1), .t1_padrA (t1_padrA_a1), .t1_refrB (t1_refrB_a1),
          .t2_readA (t3_readA_a1), .t2_writeA (t3_writeA_a1), .t2_addrA (t3_addrA_a1), .t2_dinA (t3_dinA_a1), .t2_doutA (t3_doutA_a1),
	  .t2_fwrdA (t3_fwrdA_a1), .t2_serrA (t3_serrA_a1), .t2_derrA (t3_derrA_a1), .t2_padrA (t3_padrA_a1), .t2_refrB (t3_refrB_a1),
	  .select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

reg [2-1:0] t1_readA_a1_wire [0:NUMVBNK1-1];
reg t1_writeA_a1_wire [0:NUMVBNK1-1];
reg [2*BITVROW1-1:0] t1_radrA_a1_wire [0:NUMVBNK1-1];
reg [BITVROW1-1:0] t1_wadrA_a1_wire [0:NUMVBNK1-1];
reg [WIDTH-1:0] t1_dinA_a1_wire [0:NUMVBNK1-1];
reg t1_refrB_a1_wire [0:NUMVBNK1-1];
wire [2*WIDTH-1:0] t1_doutA_a1_wire [0:NUMVBNK1-1];
wire [2-1:0] t1_fwrdA_a1_wire [0:NUMVBNK1-1];
wire [2-1:0] t1_serrA_a1_wire [0:NUMVBNK1-1];
wire [2-1:0] t1_derrA_a1_wire [0:NUMVBNK1-1];
wire [2*BITPADR2-1:0] t1_padrA_a1_wire [0:NUMVBNK1-1];
wire [WIDTH-1:0] t3_doutA_a1_wire [0:1-1];
wire t3_fwrdA_a1_wire [0:1-1];
wire t3_serrA_a1_wire [0:1-1];
wire t3_derrA_a1_wire [0:1-1];
wire [BITPADR3-1:0] t3_padrA_a1_wire [0:1-1];
integer a1_wire_int;
always_comb begin
  t1_doutA_a1 = 0;
  t1_fwrdA_a1 = 0;
  t1_serrA_a1 = 0;
  t1_derrA_a1 = 0;
  t1_padrA_a1 = 0;
  for (a1_wire_int=0; a1_wire_int<NUMVBNK1; a1_wire_int=a1_wire_int+1) begin
    t1_readA_a1_wire[a1_wire_int] = t1_readA_a1 >> (a1_wire_int*2);
    t1_writeA_a1_wire[a1_wire_int] = t1_writeA_a1 >> (a1_wire_int*2);
    t1_radrA_a1_wire[a1_wire_int] = t1_addrA_a1 >> (a1_wire_int*2*BITVROW1);
    t1_wadrA_a1_wire[a1_wire_int] = t1_addrA_a1 >> (a1_wire_int*BITVROW1);
    t1_dinA_a1_wire[a1_wire_int] = t1_dinA_a1 >> (a1_wire_int*2*WIDTH);
    t1_refrB_a1_wire[a1_wire_int] = t1_refrB_a1 >> (a1_wire_int*2);
    t1_doutA_a1 = t1_doutA_a1 | (t1_doutA_a1_wire[a1_wire_int] << (a1_wire_int*2*WIDTH));
    t1_fwrdA_a1 = t1_fwrdA_a1 | (t1_fwrdA_a1_wire[a1_wire_int] << a1_wire_int*2);
    t1_serrA_a1 = t1_serrA_a1 | (t1_serrA_a1_wire[a1_wire_int] << a1_wire_int*2);
    t1_derrA_a1 = t1_derrA_a1 | (t1_derrA_a1_wire[a1_wire_int] << a1_wire_int*2);
    t1_padrA_a1 = t1_padrA_a1 | (t1_padrA_a1_wire[a1_wire_int] << (a1_wire_int*2*BITPADR2));
  end
  t3_doutA_a1 = t3_doutA_a1_wire[0];
  t3_fwrdA_a1 = t3_fwrdA_a1_wire[0];
  t3_serrA_a1 = t3_serrA_a1_wire[0];
  t3_derrA_a1 = t3_derrA_a1_wire[0];
  t3_padrA_a1 = t3_padrA_a1_wire[0];
end

wire [NUMVBNK2-1:0] t1_readA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2-1:0] t1_writeA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2*BITVROW2-1:0] t1_addrA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2*WIDTH-1:0] t1_dinA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2-1:0] t1_refrB_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2*WIDTH-1:0] t1_doutA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2-1:0] t1_fwrdA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2-1:0] t1_serrA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2-1:0] t1_derrA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2*(BITSROW2+BITWRDS2)-1:0] t1_padrA_a2 [0:NUMVBNK1-1];

wire [1-1:0] t2_readA_a2 [0:NUMVBNK1-1];
wire [1-1:0] t2_writeA_a2 [0:NUMVBNK1-1];
wire [1*BITVROW2-1:0] t2_addrA_a2 [0:NUMVBNK1-1];
wire [1*WIDTH-1:0] t2_dinA_a2 [0:NUMVBNK1-1];
wire [1-1:0] t2_refrB_a2 [0:NUMVBNK1-1];
reg [1*WIDTH-1:0] t2_doutA_a2 [0:NUMVBNK1-1];
reg [1-1:0] t2_fwrdA_a2 [0:NUMVBNK1-1];
reg [1-1:0] t2_serrA_a2 [0:NUMVBNK1-1];
reg [1-1:0] t2_derrA_a2 [0:NUMVBNK1-1];
reg [1*(BITSROW2+BITWRDS2)-1:0] t2_padrA_a2 [0:NUMVBNK1-1];

genvar a2_int;
generate for (a2_int=0; a2_int<NUMVBNK1; a2_int=a2_int+1) begin: a2_loop

  algo_nror1w #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1), .NUMVRPT (2), .NUMPRPT (1),
                .NUMVROW (NUMVROW2), .BITVROW (BITVROW2), .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2), .BITPBNK (BITPBNK2), .BITPADR (BITPADR2),
                .REFRESH (REFRESH), .REFFREQ (REFFREQ), .SRAM_DELAY (SRAM_DELAY+FLOPECC+FLOPCMD+FLOPMEM), .FLOPIN (FLOPIN2), .FLOPOUT (FLOPOUT2))
    algo (.refr (t1_refrB_a1_wire[a2_int]), .clk (clk), .rst (rst), .ready (a2_ready[a2_int]),
          .write (t1_writeA_a1_wire[a2_int]), .wr_adr (t1_wadrA_a1_wire[a2_int]), .din (t1_dinA_a1_wire[a2_int]),
	  .read (t1_readA_a1_wire[a2_int]), .rd_adr (t1_radrA_a1_wire[a2_int]), .rd_vld (), .rd_dout (t1_doutA_a1_wire[a2_int]),
	  .rd_fwrd (t1_fwrdA_a1_wire[a2_int]), .rd_serr (t1_serrA_a1_wire[a2_int]), .rd_derr (t1_derrA_a1_wire[a2_int]), .rd_padr (t1_padrA_a1_wire[a2_int]),
          .t1_readA (t1_readA_a2[a2_int]), .t1_writeA (t1_writeA_a2[a2_int]), .t1_addrA (t1_addrA_a2[a2_int]), .t1_dinA (t1_dinA_a2[a2_int]), .t1_doutA (t1_doutA_a2[a2_int]),
	  .t1_fwrdA (t1_fwrdA_a2[a2_int]), .t1_serrA (t1_serrA_a2[a2_int]), .t1_derrA (t1_derrA_a2[a2_int]), .t1_padrA (t1_padrA_a2[a2_int]),
          .t1_refrB (t1_refrB_a2[a2_int]),
          .t2_readA (t2_readA_a2[a2_int]), .t2_writeA (t2_writeA_a2[a2_int]), .t2_addrA (t2_addrA_a2[a2_int]), .t2_dinA (t2_dinA_a2[a2_int]), .t2_doutA (t2_doutA_a2[a2_int]),
	  .t2_fwrdA (t2_fwrdA_a2[a2_int]), .t2_serrA (t2_serrA_a2[a2_int]), .t2_derrA (t2_derrA_a2[a2_int]), .t2_padrA (t2_padrA_a2[a2_int]),
          .t2_refrB (t2_refrB_a2[a2_int]),
	  .select_addr (select_addr_a2), .select_bit (select_bit));

end
endgenerate

wire [WIDTH-1:0] t1_doutA_a2_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_fwrdA_a2_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_serrA_a2_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_derrA_a2_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [BITSROW2+BITWRDS2-1:0] t1_padrA_a2_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_readA_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_writeA_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [BITSROW2-1:0] t1_addrA_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [BITDWSN-1:0] t1_dwsnA_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t1_bwA_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t1_dinA_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_refrB_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [BITRBNK2-1:0] t1_bankB_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];

genvar t1r, t1b;
generate
  for (t1r=0; t1r<NUMVBNK1; t1r=t1r+1) begin: t1r_loop
    for (t1b=0; t1b<NUMVBNK2; t1b=t1b+1) begin: t1b_loop

      wire t1_readA_a2_wire = t1_readA_a2[t1r] >> t1b;
      wire t1_writeA_a2_wire = t1_writeA_a2[t1r] >> t1b;
      wire [BITVROW2-1:0] t1_addrA_a2_wire = t1_addrA_a2[t1r] >> (t1b*BITVROW2);
      wire [WIDTH-1:0] t1_dinA_a2_wire = t1_dinA_a2[t1r] >> (t1b*WIDTH);
      wire t1_refrB_a2_wire = t1_refrB_a2[t1r] >> t1b;

      wire [NUMWRDS2*MEMWDTH-1:0] t1_doutA_wire = t1_doutA >> ((t1r*NUMVBNK2+t1b)*PHYWDTH2);
      wire [NUMWRDS2-1:0] t1_serrA_wire = t1_serrA >> (t1r*NUMVBNK2+t1b);

      if (1) begin: align_loop
        infra_align_ecc_dwsn #(.WIDTH (WIDTH), .ENAEXT (ENAEXT), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                               .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                               .NUMSROW (NUMSROW2), .BITSROW (BITSROW2), .NUMWRDS (NUMWRDS2), .BITWRDS (BITWRDS2), .BITPADR (BITSROW2+BITWRDS2),
                               .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                               .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                               .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                               .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                               .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPCMD(FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.read (t1_readA_a2_wire), .write (t1_writeA_a2_wire), .addr (t1_addrA_a2_wire), .din (t1_dinA_a2_wire),
                 .rd_dout (t1_doutA_a2_wire[t1r][t1b]), .rd_fwrd (t1_fwrdA_a2_wire[t1r][t1b]),
                 .rd_serr (t1_serrA_a2_wire[t1r][t1b]), .rd_derr (t1_derrA_a2_wire[t1r][t1b]), .rd_padr (t1_padrA_a2_wire[t1r][t1b]),
                 .mem_read (t1_readA_wire[t1r][t1b]), .mem_write (t1_writeA_wire[t1r][t1b]), .mem_addr (t1_addrA_wire[t1r][t1b]),
                 .mem_dwsn (t1_dwsnA_wire[t1r][t1b]), .mem_bw (t1_bwA_wire[t1r][t1b]), .mem_din (t1_dinA_wire[t1r][t1b]),
                 .mem_dout (t1_doutA_wire), .mem_serr (t1_serrA_wire),
                 .select_addr (select_vrow_a2),
                 .clk (clk), .rst (rst));
      end

      wire [BITRBNK2-1:0] t1_bankA_a2_wire = t1_addrA_wire[t1r][t1b] >> (BITSROW2-BITRBNK2-BITWSPF2);

      if (REFRESH==1) begin: refr_loop
        infra_refr_1stage #(.NUMRBNK (NUMRBNK2), .BITRBNK (BITRBNK2), .REFLOPW (REFLOPW),
                            .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
          infra (.clk (clk), .rst (rst),
                 .pref (t1_refrB_a2_wire), .pacc (t1_readA_a2_wire || t1_writeA_a2_wire), .pacbadr (t1_bankA_a2_wire),
                 .prefr (t1_refrB_wire[t1r][t1b]), .prfbadr (t1_bankB_wire[t1r][t1b]),
                 .select_rbnk (select_rbnk2), .select_rrow (select_rrow));
      end else begin: no_refr_loop
        assign t1_refrB_wire[t1r][t1b] = 1'b0;
        assign t1_bankB_wire[t1r][t1b] = 0;
      end
    end
  end
endgenerate

reg [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
reg [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
reg [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrA;
reg [NUMVBNK1*NUMVBNK2*BITDWSN-1:0] t1_dwsnA;
reg [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA;
reg [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA;
reg [NUMVBNK1*NUMVBNK2-1:0] t1_refrB;
reg [NUMVBNK1*NUMVBNK2*BITRBNK2-1:0] t1_bankB;
integer t1r_int, t1b_int;
always_comb begin
  t1_readA = 0;
  t1_writeA = 0;
  t1_addrA = 0;
  t1_dwsnA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  t1_refrB = 0;
  t1_bankB = 0;
  for (t1r_int=0; t1r_int<NUMVBNK1; t1r_int=t1r_int+1) begin
    t1_doutA_a2[t1r_int] = 0;
    t1_fwrdA_a2[t1r_int] = 0;
    t1_serrA_a2[t1r_int] = 0;
    t1_derrA_a2[t1r_int] = 0;
    t1_padrA_a2[t1r_int] = 0;
    for (t1b_int=0; t1b_int<NUMVBNK2; t1b_int=t1b_int+1) begin
      t1_readA = t1_readA | (t1_readA_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK2+t1b_int));
      t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK2+t1b_int));
      t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK2+t1b_int)*BITSROW2));
      t1_dwsnA = t1_dwsnA | (t1_dwsnA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK2+t1b_int)*BITDWSN));
      t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK2+t1b_int)*PHYWDTH2));
      t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK2+t1b_int)*PHYWDTH2));
      t1_refrB = t1_refrB | (t1_refrB_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK2+t1b_int));
      t1_bankB = t1_bankB | (t1_bankB_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK2+t1b_int)*BITRBNK2));
      t1_doutA_a2[t1r_int] = t1_doutA_a2[t1r_int] | (t1_doutA_a2_wire[t1r_int][t1b_int] << (t1b_int*WIDTH));
      t1_fwrdA_a2[t1r_int] = t1_fwrdA_a2[t1r_int] | (t1_fwrdA_a2_wire[t1r_int][t1b_int] << t1b_int);
      t1_serrA_a2[t1r_int] = t1_serrA_a2[t1r_int] | (t1_serrA_a2_wire[t1r_int][t1b_int] << t1b_int);
      t1_derrA_a2[t1r_int] = t1_derrA_a2[t1r_int] | (t1_derrA_a2_wire[t1r_int][t1b_int] << t1b_int);
      t1_padrA_a2[t1r_int] = t1_padrA_a2[t1r_int] | (t1_padrA_a2_wire[t1r_int][t1b_int] << (t1b_int*(BITSROW2+BITWRDS2)));
    end
  end
end

wire [WIDTH-1:0] t2_doutA_a2_wire [0:NUMVBNK1-1][0:1-1];
wire t2_fwrdA_a2_wire [0:NUMVBNK1-1][0:1-1];
wire t2_serrA_a2_wire [0:NUMVBNK1-1][0:1-1];
wire t2_derrA_a2_wire [0:NUMVBNK1-1][0:1-1];
wire [BITSROW2+BITWRDS2-1:0] t2_padrA_a2_wire [0:NUMVBNK1-1][0:1-1];
wire t2_readA_wire [0:NUMVBNK1-1][0:1-1];
wire t2_writeA_wire [0:NUMVBNK1-1][0:1-1];
wire [BITSROW2-1:0] t2_addrA_wire [0:NUMVBNK1-1][0:1-1];
wire [BITDWSN-1:0] t2_dwsnA_wire [0:NUMVBNK1-1][0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t2_bwA_wire [0:NUMVBNK1-1][0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t2_dinA_wire [0:NUMVBNK1-1][0:1-1];
wire t2_refrB_wire [0:NUMVBNK1-1][0:1-1];
wire [BITRBNK2-1:0] t2_bankB_wire [0:NUMVBNK1-1][0:1-1];

genvar t2r, t2b;
generate
  for (t2r=0; t2r<NUMVBNK1; t2r=t2r+1) begin: t2r_loop
    for (t2b=0; t2b<1; t2b=t2b+1) begin: t2b_loop

      wire t2_readA_a2_wire = t2_readA_a2[t2r] >> t2b;
      wire t2_writeA_a2_wire = t2_writeA_a2[t2r] >> t2b;
      wire [BITVROW2-1:0] t2_addrA_a2_wire = t2_addrA_a2[t2r] >> (t2b*BITVROW2);
      wire [WIDTH-1:0] t2_dinA_a2_wire = t2_dinA_a2[t2r] >> (t2b*WIDTH);
      wire t2_refrB_a2_wire = t2_refrB_a2[t2r] >> t2b;

      wire [NUMWRDS2*MEMWDTH-1:0] t2_doutA_wire = t2_doutA >> ((t2r*1+t2b)*PHYWDTH2);
      wire [NUMWRDS2-1:0] t2_serrA_wire = t2_serrA >> (t2r*1+t2b);

      if (1) begin: align_loop
        infra_align_ecc_dwsn #(.WIDTH (WIDTH), .ENAEXT (ENAEXT), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                               .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                               .NUMSROW (NUMSROW2), .BITSROW (BITSROW2), .NUMWRDS (NUMWRDS2), .BITWRDS (BITWRDS2), .BITPADR (BITSROW2+BITWRDS2),
                               .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                               .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                               .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                               .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                               .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPCMD(FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.read (t2_readA_a2_wire), .write (t2_writeA_a2_wire), .addr (t2_addrA_a2_wire), .din (t2_dinA_a2_wire),
                 .rd_dout (t2_doutA_a2_wire[t2r][t2b]), .rd_fwrd (t2_fwrdA_a2_wire[t2r][t2b]),
                 .rd_serr (t2_serrA_a2_wire[t2r][t2b]), .rd_derr (t2_derrA_a2_wire[t2r][t2b]), .rd_padr (t2_padrA_a2_wire[t2r][t2b]),
                 .mem_read (t2_readA_wire[t2r][t2b]), .mem_write (t2_writeA_wire[t2r][t2b]), .mem_addr (t2_addrA_wire[t2r][t2b]),
                 .mem_dwsn (t2_dwsnA_wire[t2r][t2b]), .mem_bw (t2_bwA_wire[t2r][t2b]), .mem_din (t2_dinA_wire[t2r][t2b]),
                 .mem_dout (t2_doutA_wire), .mem_serr (t2_serrA_wire),
                 .select_addr (select_vrow_a2),
                 .clk (clk), .rst (rst));
      end
      wire [BITRBNK2-1:0] t2_bankA_a2_wire = t2_addrA_wire[t2r][t2b] >> (BITSROW2-BITRBNK2-BITWSPF2);

      if (REFRESH==1) begin: refr_loop
        infra_refr_1stage #(.NUMRBNK (NUMRBNK2), .BITRBNK (BITRBNK2), .REFLOPW (REFLOPW),
                            .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
          infra (.clk (clk), .rst (rst),
                 .pref (t2_refrB_a2_wire), .pacc (t2_readA_a2_wire || t2_writeA_a2_wire), .pacbadr (t2_bankA_a2_wire),
                 .prefr (t2_refrB_wire[t2r][t2b]), .prfbadr (t2_bankB_wire[t2r][t2b]),
                 .select_rbnk (select_rbnk2), .select_rrow (select_rrow));
      end else begin: no_refr_loop
        assign t2_refrB_wire[t2r][t2b] = 1'b0;
        assign t2_bankB_wire[t2r][t2b] = 0;
      end
    end
  end
endgenerate

reg [NUMVBNK1-1:0] t2_readA;
reg [NUMVBNK1-1:0] t2_writeA;
reg [NUMVBNK1*BITSROW2-1:0] t2_addrA;
reg [NUMVBNK1*BITDWSN-1:0] t2_dwsnA;
reg [NUMVBNK1*PHYWDTH2-1:0] t2_bwA;
reg [NUMVBNK1*PHYWDTH2-1:0] t2_dinA;
reg [NUMVBNK1-1:0] t2_refrB;
reg [NUMVBNK1*BITRBNK2-1:0] t2_bankB;

integer t2r_int, t2b_int;
always_comb begin
  t2_readA = 0;
  t2_writeA = 0;
  t2_addrA = 0;
  t2_dwsnA = 0;
  t2_bwA = 0;
  t2_dinA = 0;
  t2_refrB = 0;
  t2_bankB = 0;
  for (t2r_int=0; t2r_int<NUMVBNK1; t2r_int=t2r_int+1) begin
    t2_doutA_a2[t2r_int] = 0;
    t2_fwrdA_a2[t2r_int] = 0;
    t2_serrA_a2[t2r_int] = 0;
    t2_derrA_a2[t2r_int] = 0;
    t2_padrA_a2[t2r_int] = 0;
    for (t2b_int=0; t2b_int<1; t2b_int=t2b_int+1) begin
      t2_readA = t2_readA | (t2_readA_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_writeA = t2_writeA | (t2_writeA_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_addrA = t2_addrA | (t2_addrA_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*BITSROW2));
      t2_dwsnA = t2_dwsnA | (t2_dwsnA_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*BITDWSN));
      t2_bwA = t2_bwA | (t2_bwA_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*PHYWDTH2));
      t2_dinA = t2_dinA | (t2_dinA_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*PHYWDTH2));
      t2_refrB = t2_refrB | (t2_refrB_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_bankB = t2_bankB | (t2_bankB_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*BITRBNK2));
      t2_doutA_a2[t2r_int] = t2_doutA_a2[t2r_int] | (t2_doutA_a2_wire[t2r_int][t2b_int] << (t2b_int*WIDTH));
      t2_fwrdA_a2[t2r_int] = t2_fwrdA_a2[t2r_int] | (t2_fwrdA_a2_wire[t2r_int][t2b_int] << t2b_int);
      t2_serrA_a2[t2r_int] = t2_serrA_a2[t2r_int] | (t2_serrA_a2_wire[t2r_int][t2b_int] << t2b_int);
      t2_derrA_a2[t2r_int] = t2_derrA_a2[t2r_int] | (t2_derrA_a2_wire[t2r_int][t2b_int] << t2b_int);
      t2_padrA_a2[t2r_int] = t2_padrA_a2[t2r_int] | (t2_padrA_a2_wire[t2r_int][t2b_int] << (t2b_int*(BITSROW2+BITWRDS2)));
    end
  end
end

wire [NUMVBNK2-1:0] t3_readA_a3 [0:1-1];
wire [NUMVBNK2-1:0] t3_writeA_a3 [0:1-1];
wire [NUMVBNK2*BITVROW2-1:0] t3_addrA_a3 [0:1-1];
wire [NUMVBNK2*WIDTH-1:0] t3_dinA_a3 [0:1-1];
wire [NUMVBNK2-1:0] t3_refrB_a3 [0:1-1];
reg [NUMVBNK2*WIDTH-1:0] t3_doutA_a3 [0:1-1];
reg [NUMVBNK2-1:0] t3_fwrdA_a3 [0:1-1];
reg [NUMVBNK2-1:0] t3_serrA_a3 [0:1-1];
reg [NUMVBNK2-1:0] t3_derrA_a3 [0:1-1];
reg [NUMVBNK2*(BITSROW2+BITWRDS2)-1:0] t3_padrA_a3 [0:1-1];

genvar a3_int;
generate for (a3_int=0; a3_int<1; a3_int=a3_int+1) begin: a3_loop

  algo_nror1w_dup #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1), .NUMRDPT (1),
                    .NUMVROW (NUMVROW2), .BITVROW (BITVROW2), .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2), .BITPADR (BITPADR3),
                    .REFRESH (REFRESH), .SRAM_DELAY (SRAM_DELAY+FLOPECC+FLOPCMD+FLOPMEM), .FLOPIN (FLOPIN2), .FLOPOUT (FLOPOUT2))
    algo (.refr (t3_refrB_a1[0]), .clk (clk), .rst (rst), .ready (a3_ready),
          .write (t3_writeA_a1[0]), .wr_adr (t3_addrA_a1[BITVROW1-1:0]), .din (t3_dinA_a1[WIDTH-1:0]),
          .read (t3_readA_a1[0]), .rd_adr (t3_addrA_a1[BITVROW1-1:0]), .rd_vld (), .rd_dout (t3_doutA_a1_wire[a3_int]),
          .rd_fwrd (t3_fwrdA_a1_wire[a3_int]), .rd_serr (t3_serrA_a1_wire[a3_int]), .rd_derr (t3_derrA_a1_wire[a3_int]), .rd_padr (t3_padrA_a1_wire[a3_int]),
          .t1_readA (t3_readA_a3[a3_int]), .t1_writeA (t3_writeA_a3[a3_int]), .t1_addrA (t3_addrA_a3[a3_int]), .t1_dinA (t3_dinA_a3[a3_int]), .t1_doutA (t3_doutA_a3[a3_int]),
          .t1_fwrdA (t3_fwrdA_a3[a3_int]), .t1_serrA (t3_serrA_a3[a3_int]), .t1_derrA (t3_derrA_a3[a3_int]), .t1_padrA (t3_padrA_a3[a3_int]), .t1_refrB (t3_refrB_a3[a3_int]),
          .select_addr (select_addr_a2), .select_bit (select_bit));

end
endgenerate

wire [WIDTH-1:0] t3_doutA_a3_wire [0:1-1][0:NUMVBNK2-1];
wire t3_fwrdA_a3_wire [0:1-1][0:NUMVBNK2-1];
wire t3_serrA_a3_wire [0:1-1][0:NUMVBNK2-1];
wire t3_derrA_a3_wire [0:1-1][0:NUMVBNK2-1];
wire [BITSROW2+BITWRDS2-1:0] t3_padrA_a3_wire [0:1-1][0:NUMVBNK2-1];
wire t3_readA_wire [0:1-1][0:NUMVBNK2-1];
wire t3_writeA_wire [0:1-1][0:NUMVBNK2-1];
wire [BITSROW2-1:0] t3_addrA_wire [0:1-1][0:NUMVBNK2-1];
wire [BITDWSN-1:0] t3_dwsnA_wire [0:1-1][0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t3_bwA_wire [0:1-1][0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t3_dinA_wire [0:1-1][0:NUMVBNK2-1];
wire t3_refrB_wire [0:1-1][0:NUMVBNK2-1];
wire [BITRBNK2-1:0] t3_bankB_wire [0:1-1][0:NUMVBNK2-1];
  
genvar t3r, t3b;
generate 
  for (t3r=0; t3r<1; t3r=t3r+1) begin: t3r_loop
    for (t3b=0; t3b<NUMVBNK2; t3b=t3b+1) begin: t3b_loop
  
      wire t3_readA_a3_wire = t3_readA_a3[t3r] >> t3b; 
      wire t3_writeA_a3_wire = t3_writeA_a3[t3r] >> t3b;
      wire [BITVROW2-1:0] t3_addrA_a3_wire = t3_addrA_a3[t3r] >> (t3b*BITVROW2);
      wire [WIDTH-1:0] t3_dinA_a3_wire = t3_dinA_a3[t3r] >> (t3b*WIDTH);
      wire t3_refrB_a3_wire = t3_refrB_a3[t3r] >> t3b;
    
      wire [NUMWRDS2*MEMWDTH-1:0] t3_doutA_wire = t3_doutA >> ((t3r*1+t3b)*PHYWDTH2);
      wire [NUMWRDS2-1:0] t3_serrA_wire = t3_serrA >> (t3r*1+t3b);

      if (1) begin: align_loop
        infra_align_ecc_dwsn #(.WIDTH (WIDTH), .ENAEXT (ENAEXT), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                               .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                               .NUMSROW (NUMSROW2), .BITSROW (BITSROW2), .NUMWRDS (NUMWRDS2), .BITWRDS (BITWRDS2), .BITPADR (BITSROW2+BITWRDS2),
                               .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                               .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                               .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                               .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                               .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPCMD(FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.read (t3_readA_a3_wire), .write (t3_writeA_a3_wire), .addr (t3_addrA_a3_wire), .din (t3_dinA_a3_wire),
                 .rd_dout (t3_doutA_a3_wire[t3r][t3b]), .rd_fwrd (t3_fwrdA_a3_wire[t3r][t3b]),
                 .rd_serr (t3_serrA_a3_wire[t3r][t3b]), .rd_derr (t3_derrA_a3_wire[t3r][t3b]), .rd_padr (t3_padrA_a3_wire[t3r][t3b]),
                 .mem_read (t3_readA_wire[t3r][t3b]), .mem_write (t3_writeA_wire[t3r][t3b]), .mem_addr (t3_addrA_wire[t3r][t3b]),
                 .mem_dwsn (t3_dwsnA_wire[t3r][t3b]), .mem_bw (t3_bwA_wire[t3r][t3b]), .mem_din (t3_dinA_wire[t3r][t3b]),
                 .mem_dout (t3_doutA_wire), .mem_serr (t3_serrA_wire),
                 .select_addr (select_vrow_a2),
                 .clk (clk), .rst (rst));
      end
      wire [BITRBNK2-1:0] t3_bankA_a3_wire = t3_addrA_wire[t3r][t3b] >> (BITSROW2-BITRBNK2-BITWSPF2);

      if (REFRESH==1) begin: refr_loop
        infra_refr_1stage #(.NUMRBNK (NUMRBNK2), .BITRBNK (BITRBNK2), .REFLOPW (REFLOPW),
                            .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
          infra (.clk (clk), .rst (rst),
                 .pref (t3_refrB_a3_wire), .pacc (t3_readA_a3_wire || t3_writeA_a3_wire), .pacbadr (t3_bankA_a3_wire),
                 .prefr (t3_refrB_wire[t3r][t3b]), .prfbadr (t3_bankB_wire[t3r][t3b]),
                 .select_rbnk (select_rbnk2), .select_rrow (select_rrow));
      end else begin: no_refr_loop
        assign t3_refrB_wire[t3r][t3b] = 1'b0;
        assign t3_bankB_wire[t3r][t3b] = 0;
      end
    end
  end
endgenerate

reg [NUMVBNK2-1:0] t3_readA;
reg [NUMVBNK2-1:0] t3_writeA;
reg [NUMVBNK2*BITSROW2-1:0] t3_addrA;
reg [NUMVBNK2*BITDWSN-1:0] t3_dwsnA;
reg [NUMVBNK2*PHYWDTH2-1:0] t3_bwA;
reg [NUMVBNK2*PHYWDTH2-1:0] t3_dinA;
reg [NUMVBNK2-1:0] t3_refrB;
reg [NUMVBNK2*BITRBNK2-1:0] t3_bankB;

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
  for (t3r_int=0; t3r_int<1; t3r_int=t3r_int+1) begin
    t3_doutA_a3[t3r_int] = 0;
    t3_fwrdA_a3[t3r_int] = 0;
    t3_serrA_a3[t3r_int] = 0;
    t3_derrA_a3[t3r_int] = 0;
    t3_padrA_a3[t3r_int] = 0;
    for (t3b_int=0; t3b_int<NUMVBNK2; t3b_int=t3b_int+1) begin
      t3_readA = t3_readA | (t3_readA_wire[t3r_int][t3b_int] << (t3r_int*1+t3b_int));
      t3_writeA = t3_writeA | (t3_writeA_wire[t3r_int][t3b_int] << (t3r_int*1+t3b_int));
      t3_addrA = t3_addrA | (t3_addrA_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*BITSROW2));
      t3_dwsnA = t3_dwsnA | (t3_dwsnA_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*BITDWSN));
      t3_bwA = t3_bwA | (t3_bwA_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*PHYWDTH2));
      t3_dinA = t3_dinA | (t3_dinA_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*PHYWDTH2));
      t3_refrB = t3_refrB | (t3_refrB_wire[t3r_int][t3b_int] << (t3r_int*1+t3b_int));
      t3_bankB = t3_bankB | (t3_bankB_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*BITRBNK2));
      t3_doutA_a3[t3r_int] = t3_doutA_a3[t3r_int] | (t3_doutA_a3_wire[t3r_int][t3b_int] << (t3b_int*WIDTH));
      t3_fwrdA_a3[t3r_int] = t3_fwrdA_a3[t3r_int] | (t3_fwrdA_a3_wire[t3r_int][t3b_int] << t3b_int);
      t3_serrA_a3[t3r_int] = t3_serrA_a3[t3r_int] | (t3_serrA_a3_wire[t3r_int][t3b_int] << t3b_int);
      t3_derrA_a3[t3r_int] = t3_derrA_a3[t3r_int] | (t3_derrA_a3_wire[t3r_int][t3b_int] << t3b_int);
      t3_padrA_a3[t3r_int] = t3_padrA_a3[t3r_int] | (t3_padrA_a3_wire[t3r_int][t3b_int] << (t3b_int*(BITSROW2+BITWRDS2)));
    end
  end
end

/*
wire [WIDTH-1:0] t3_doutA_a3_wire [0:NUMVBNK2-1];
wire t3_serrA_a3_wire [0:NUMVBNK2-1];
wire t3_derrA_a3_wire [0:NUMVBNK2-1];
wire [(BITSROW2+BITWRDS2)-1:0] t3_padrA_a3_wire [0:NUMVBNK2-1];
wire t3_readA_wire [0:NUMVBNK2-1];
wire t3_writeA_wire [0:NUMVBNK2-1];
wire [BITSROW2-1:0] t3_addrA_wire [0:NUMVBNK2-1];
wire [BITDWSN-1:0] t3_dwsnA_wire [0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t3_bwA_wire [0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t3_dinA_wire [0:NUMVBNK2-1];
wire t3_refrB_wire [0:NUMVBNK2-1];
wire [BITRBNK2-1:0] t3_bankB_wire [0:NUMVBNK2-1];

genvar t3;
generate for (t3=0; t3<1; t3=t3+1) begin: t3_loop
  wire t3_readA_a1_wire = t3_readA_a1 >> t3;
  wire t3_writeA_a1_wire = t3_writeA_a1 >> t3;
  wire [BITVROW1-1:0] t3_addrA_a1_wire = t3_addrA_a1 >> (t3*BITVROW1);
  wire [WIDTH-1:0] t3_dinA_a1_wire = t3_dinA_a1 >> (t3*WIDTH);
  wire t3_refrB_a1_wire = t3_refrB_a1 >> t3;

  wire [NUMWRDS2*MEMWDTH-1:0] t3_doutA_wire = t3_doutA >> (t3*PHYWDTH1);


  if (1) begin: align_loop
    infra_align_dwsn #(.WIDTH (WIDTH), .PARITY (PARITY), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
                       .NUMSROW (NUMSROW1), .BITSROW (BITSROW1), .NUMWRDS (NUMWRDS1), .BITWRDS (BITWRDS1), .BITPADR (BITSROW1+BITWRDS1),
                       .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                       .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                       .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                       .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                       .SRAM_DELAY (SRAM_DELAY), .FLOPCMD(FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1))
      infra (.read (t3_readA_a1_wire), .write (t3_writeA_a1_wire), .addr (t3_addrA_a1_wire), .din (t3_dinA_a1_wire), .dout (t3_doutA_a1_wire[t3]),
             .serr (t3_serrA_a1_wire[t3]), .padr (t3_padrA_a1_wire[t3]),
             .mem_read (t3_readA_wire[t3]), .mem_write (t3_writeA_wire[t3]), .mem_addr (t3_addrA_wire[t3]),
             .mem_dwsn (t3_dwsnA_wire[t3]), .mem_bw (t3_bwA_wire[t3]), .mem_din (t3_dinA_wire[t3]), .mem_dout (t3_doutA_wire),
             .select_addr (select_addr_a2),
             .clk (clk), .rst (rst));
    assign t3_derrA_a1_wire[t3] = 1'b0;
  end

  wire [BITRBNK1-1:0] t3_bankA_wire = t3_addrA_wire[t3] >> (BITSROW1-BITRBNK1-BITWSPF1);

  if (REFRESH==1) begin: refr_loop
    infra_refr_1stage #(.NUMRBNK (NUMRBNK1), .BITRBNK (BITRBNK1), .REFLOPW (REFLOPW),
                        .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
      infra (.clk (clk), .rst (rst),
             .pref (t3_refrB_a1_wire), .pacc (t3_readA_wire[t3] || t3_writeA_wire[t3]), .pacbadr (t3_bankA_wire),
             .prefr (t3_refrB_wire[t3]), .prfbadr (t3_bankB_wire[t3]),
             .select_rbnk (select_rbnk1), .select_rrow (select_rrow));
  end else begin: no_refr_loop
    assign t3_refrB_wire[t3] = 1'b0;
    assign t3_bankB_wire[t3] = 0;
  end

end
endgenerate

reg [1-1:0] t3_readA;
reg [1-1:0] t3_writeA;
reg [1*BITSROW1-1:0] t3_addrA;
reg [1*BITDWSN-1:0] t3_dwsnA;
reg [1*PHYWDTH1-1:0] t3_bwA;
reg [1*PHYWDTH1-1:0] t3_dinA;
reg [1-1:0] t3_refrB;
reg [1*BITRBNK1-1:0] t3_bankB;

integer t3_out_int;
always_comb begin
  t3_readA = 0;
  t3_writeA = 0;
  t3_addrA = 0;
  t3_dwsnA = 0;
  t3_bwA = 0;
  t3_dinA = 0;
  t3_doutA_a1 = 0;
  t3_serrA_a1 = 0;
  t3_derrA_a1 = 0;
  t3_padrA_a1 = 0;
  t3_refrB = 0;
  t3_bankB = 0;
  for (t3_out_int=0; t3_out_int<1; t3_out_int=t3_out_int+1) begin
    t3_readA = t3_readA | (t3_readA_wire[t3_out_int] << t3_out_int);
    t3_writeA = t3_writeA | (t3_writeA_wire[t3_out_int] << t3_out_int);
    t3_addrA = t3_addrA | (t3_addrA_wire[t3_out_int] << (t3_out_int*BITSROW1));
    t3_dwsnA = t3_dwsnA | (t3_dwsnA_wire[t3_out_int] << (t3_out_int*BITDWSN));
    t3_bwA = t3_bwA | (t3_bwA_wire[t3_out_int] << (t3_out_int*PHYWDTH1));
    t3_dinA = t3_dinA | (t3_dinA_wire[t3_out_int] << (t3_out_int*PHYWDTH1));
    t3_doutA_a1 = t3_doutA_a1 | (t3_doutA_a1_wire[t3_out_int] << (t3_out_int*WIDTH));
    t3_serrA_a1 = t3_serrA_a1 | (t3_serrA_a1_wire[t3_out_int] << t3_out_int);
    t3_derrA_a1 = t3_derrA_a1 | (t3_derrA_a1_wire[t3_out_int] << t3_out_int);
    t3_padrA_a1 = t3_padrA_a1 | (t3_padrA_a1_wire[t3_out_int] << (t3_out_int*(BITSROW1+BITWRDS1)));
    t3_refrB = t3_refrB | (t3_refrB_wire[t3_out_int] << t3_out_int);
    t3_bankB = t3_bankB | (t3_bankB_wire[t3_out_int] << (t3_out_int*BITRBNK1));
  end
end
*/

`ifdef FORMAL
genvar werr_int;
generate for (werr_int=0; werr_int<NUMVBNK1; werr_int=werr_int+1) begin: werr_loop
  assume_wr_rerr_check: assert property (@(posedge clk) disable iff (rst) (ready || a1_loop.algo.ip_top_sva.wr_nerr[werr_int]));
  assume_wr_nerr_check: assert property (@(posedge clk) disable iff (rst) (a2_loop[werr_int].algo.ip_top_sva.write &&
                                                                           (a2_loop[werr_int].algo.ip_top_sva.wr_row == select_vrow_a2)) |->
                                         (a1_loop.algo.ip_top_sva.wr_nerr[werr_int] == &a2_loop[werr_int].algo.ip_top_sva.mem_nerr[0]));
  assume_wr_serr_check: assert property (@(posedge clk) disable iff (rst) (a2_loop[werr_int].algo.ip_top_sva.write &&
                                                                           (a2_loop[werr_int].algo.ip_top_sva.wr_row == select_vrow_a2) &&
                                                                           (ENAPAR ? (|a2_loop[werr_int].algo.ip_top_sva.mem_serr[0] ||
                                                                                       |a2_loop[werr_int].algo.ip_top_sva.mem_derr[0]) :
                                                                                     |a2_loop[werr_int].algo.ip_top_sva.mem_derr[0])) |->
                                         (a1_loop.algo.ip_top_sva.t1_writeA_wire[werr_int] && (a1_loop.algo.ip_top_sva.t1_addrA_wire[0][werr_int] == select_addr_a2) &&
                                          a1_loop.algo.ip_top_sva.wr_serr[werr_int]));
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

