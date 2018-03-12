
module algo_4ror1w_top (refr, clk, rst, ready,
                        write, wr_adr, din,
                        read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
	                t1_readA, t1_writeA, t1_addrA, t1_dwsnA, t1_bwA, t1_dinA, t1_doutA, t1_serrA, t1_refrB, t1_bankB,
	                t2_readA, t2_writeA, t2_addrA, t2_dwsnA, t2_bwA, t2_dinA, t2_doutA, t2_serrA, t2_refrB, t2_bankB,
	                t3_readA, t3_writeA, t3_addrA, t3_dwsnA, t3_bwA, t3_dinA, t3_doutA, t3_serrA, t3_refrB, t3_bankB,
	                t4_readA, t4_writeA, t4_addrA, t4_dwsnA, t4_bwA, t4_dinA, t4_doutA, t4_serrA, t4_refrB, t4_bankB);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAEXT = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter MEMWDTH = ENAEXT ? WIDTH : ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW1 = 1024;
  parameter BITVROW1 = 10;
  parameter NUMVBNK1 = 8;
  parameter BITVBNK1 = 3;
  parameter BITPBNK1 = 4;
  parameter FLOPIN1 = 0;
  parameter FLOPOUT1 = 0;
  parameter NUMVROW2 = 256;
  parameter BITVROW2 = 8;
  parameter NUMVBNK2 = 4;
  parameter BITVBNK2 = 2;
  parameter BITPBNK2 = 3;
  parameter FLOPIN2 = 0;
  parameter FLOPOUT2 = 0;
  parameter NUMWRDS2 = 4;      // ALIGN Parameters
  parameter BITWRDS2 = 2;
  parameter NUMSROW2 = 64;
  parameter BITSROW2 = 6;
  parameter PHYWDTH2 = NUMWRDS2*MEMWDTH;
  parameter REFRESH = 1;      // REFRESH Parameters 
  parameter NUMRBNK = 8;
  parameter BITRBNK = 3;
  parameter BITWSPF = 0;
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
  parameter FLOPCMD = 0;
  parameter FLOPECC = 0;
  parameter FLOPMEM = 0;

  parameter BITPADR2 = BITPBNK2+BITSROW2+BITWRDS2;
  parameter BITPADR1 = BITPBNK1+BITPADR2+1;

  input                                refr;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input [4-1:0]                        read;
  input [4*BITADDR-1:0]                rd_adr;
  output [4-1:0]                       rd_vld;
  output [4*WIDTH-1:0]                 rd_dout;
  output [4-1:0]                       rd_serr;
  output [4-1:0]                       rd_derr;
  output [4*BITPADR1-1:0]              rd_padr;

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
  output [NUMVBNK1*NUMVBNK2*BITRBNK-1:0] t1_bankB;

  output [NUMVBNK1-1:0] t2_readA;
  output [NUMVBNK1-1:0] t2_writeA;
  output [NUMVBNK1*BITSROW2-1:0] t2_addrA;
  output [NUMVBNK1*BITDWSN-1:0] t2_dwsnA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_bwA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_dinA;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_doutA;
  input [NUMVBNK1-1:0] t2_serrA;
  output [NUMVBNK1-1:0] t2_refrB;
  output [NUMVBNK1*BITRBNK-1:0] t2_bankB;

  output [NUMVBNK2-1:0] t3_readA;
  output [NUMVBNK2-1:0] t3_writeA;
  output [NUMVBNK2*BITSROW2-1:0] t3_addrA;
  output [NUMVBNK2*BITDWSN-1:0] t3_dwsnA;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_bwA;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_dinA;
  input [NUMVBNK2*PHYWDTH2-1:0] t3_doutA;
  input [NUMVBNK2-1:0] t3_serrA;
  output [NUMVBNK2-1:0] t3_refrB;
  output [NUMVBNK2*BITRBNK-1:0] t3_bankB;

  output [1-1:0] t4_readA;
  output [1-1:0] t4_writeA;
  output [1*BITSROW2-1:0] t4_addrA;
  output [1*BITDWSN-1:0] t4_dwsnA;
  output [1*PHYWDTH2-1:0] t4_bwA;
  output [1*PHYWDTH2-1:0] t4_dinA;
  input [1*PHYWDTH2-1:0] t4_doutA;
  input [1-1:0] t4_serrA;
  output [1-1:0] t4_refrB;
  output [1*BITRBNK-1:0] t4_bankB;

`ifdef FORMAL
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
wire [BITRBNK-1:0] select_rbnk;
wire [BITRROW-1:0] select_rrow;
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr == 0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit == 0));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));
assume_select_rbnk_range: assume property (@(posedge clk) disable iff (rst) (select_rbnk < NUMRBNK));
assume_select_rbnk_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_rbnk));
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
wire [BITRBNK-1:0] select_rbnk = 0;
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
wire [2*WIDTH-1:0] t3_doutA_a1;
wire [2-1:0] t3_fwrdA_a1;
wire [2-1:0] t3_serrA_a1;
wire [2-1:0] t3_derrA_a1;
wire [2*BITPADR2-1:0] t3_padrA_a1;

wire [NUMVBNK1-1:0] t1_a2_ready;
wire t3_a3_ready;

generate if (1) begin: a1_loop

  algo_nror1w #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMVRPT (4), .NUMPRPT (2),
                .NUMVROW (NUMVROW1), .BITVROW (BITVROW1), .NUMVBNK (NUMVBNK1), .BITVBNK (BITVBNK1), .BITPBNK (BITPBNK1), .BITPADR (BITPADR1-1),
                .REFRESH (REFRESH), .REFFREQ (REFFREQ), .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPECC+FLOPMEM+FLOPIN2+FLOPOUT2), .FLOPIN (FLOPIN1), .FLOPOUT (FLOPOUT1))
    algo (.refr (refr), .clk (clk), .rst (rst || !(&t1_a2_ready) || !t3_a3_ready), .ready (ready),
          .write (write), .wr_adr (wr_adr), .din (din),
	  .read (read), .rd_adr (rd_adr), .rd_vld (rd_vld), .rd_dout (rd_dout),
	  .rd_fwrd ({rd_padr[4*BITPADR1-1],rd_padr[3*BITPADR1-1],rd_padr[2*BITPADR1-1],rd_padr[BITPADR1-1]}), .rd_serr (rd_serr), .rd_derr (rd_derr),
          .rd_padr ({rd_padr[4*BITPADR1-2:3*BITPADR1],rd_padr[3*BITPADR1-2:2*BITPADR1],rd_padr[2*BITPADR1-2:BITPADR1],rd_padr[BITPADR1-2:0]}),
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
                .REFRESH (REFRESH), .REFFREQ (REFFREQ), .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPECC+FLOPMEM), .FLOPIN (FLOPIN2), .FLOPOUT (FLOPOUT2))
    algo (.refr (t1_refrB_a1_wire[a2_int]), .clk (clk), .rst (rst), .ready (t1_a2_ready[a2_int]),
          .write (t1_writeA_a1_wire[a2_int]), .wr_adr (t1_wadrA_a1_wire[a2_int]), .din (t1_dinA_a1_wire[a2_int]),
	  .read (t1_readA_a1_wire[a2_int]), .rd_adr (t1_radrA_a1_wire[a2_int]), .rd_vld (), .rd_dout (t1_doutA_a1_wire[a2_int]),
	  .rd_fwrd (t1_fwrdA_a1_wire[a2_int]), .rd_serr (t1_serrA_a1_wire[a2_int]), .rd_derr (t1_derrA_a1_wire[a2_int]), .rd_padr (t1_padrA_a1_wire[a2_int]),
          .t1_readA (t1_readA_a2[a2_int]), .t1_writeA (t1_writeA_a2[a2_int]), .t1_addrA (t1_addrA_a2[a2_int]), .t1_dinA (t1_dinA_a2[a2_int]), .t1_doutA (t1_doutA_a2[a2_int]),
	  .t1_fwrdA (t1_fwrdA_a2[a2_int]), .t1_serrA (t1_serrA_a2[a2_int]), .t1_derrA (t1_derrA_a2[a2_int]), .t1_padrA (t1_padrA_a2[a2_int]), .t1_refrB (t1_refrB_a2[a2_int]),
          .t2_readA (t2_readA_a2[a2_int]), .t2_writeA (t2_writeA_a2[a2_int]), .t2_addrA (t2_addrA_a2[a2_int]), .t2_dinA (t2_dinA_a2[a2_int]), .t2_doutA (t2_doutA_a2[a2_int]),
	  .t2_fwrdA (t2_fwrdA_a2[a2_int]), .t2_serrA (t2_serrA_a2[a2_int]), .t2_derrA (t2_derrA_a2[a2_int]), .t2_padrA (t2_padrA_a2[a2_int]), .t2_refrB (t2_refrB_a2[a2_int]),
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
wire [BITRBNK-1:0] t1_bankB_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];

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
                               .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.read (t1_readA_a2_wire), .write (t1_writeA_a2_wire), .addr (t1_addrA_a2_wire), .din (t1_dinA_a2_wire),
                 .rd_dout (t1_doutA_a2_wire[t1r][t1b]), .rd_fwrd (t1_fwrdA_a2_wire[t1r][t1b]),
                 .rd_serr (t1_serrA_a2_wire[t1r][t1b]), .rd_derr (t1_derrA_a2_wire[t1r][t1b]), .rd_padr (t1_padrA_a2_wire[t1r][t1b]),
                 .mem_read (t1_readA_wire[t1r][t1b]), .mem_write (t1_writeA_wire[t1r][t1b]), .mem_addr (t1_addrA_wire[t1r][t1b]),
                 .mem_dwsn (t1_dwsnA_wire[t1r][t1b]), .mem_bw (t1_bwA_wire[t1r][t1b]), .mem_din (t1_dinA_wire[t1r][t1b]),
                 .mem_dout (t1_doutA_wire), .mem_serr (t1_serrA_wire),
                 .select_addr (select_vrow_a2),
                 .clk (clk), .rst (rst));
      end

      wire [BITRBNK-1:0] t1_bankA_a2_wire = t1_addrA_wire[t1r][t1b] >> (BITSROW2-BITRBNK-BITWSPF);

      if (REFRESH==1) begin: refr_loop
        infra_refr_1stage #(.NUMRBNK (NUMRBNK), .BITRBNK (BITRBNK), .REFLOPW (REFLOPW),
                            .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
          infra (.clk (clk), .rst (rst),
                 .pref (t1_refrB_a2_wire), .pacc (t1_readA_a2_wire || t1_writeA_a2_wire), .pacbadr (t1_bankA_a2_wire),
                 .prefr (t1_refrB_wire[t1r][t1b]), .prfbadr (t1_bankB_wire[t1r][t1b]),
                 .select_rbnk (select_rbnk), .select_rrow (select_rrow));
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
reg [NUMVBNK1*NUMVBNK2*BITRBNK-1:0] t1_bankB;
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
      t1_bankB = t1_bankB | (t1_bankB_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK2+t1b_int)*BITRBNK));
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
wire [BITRBNK-1:0] t2_bankB_wire [0:NUMVBNK1-1][0:1-1];

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
                               .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.read (t2_readA_a2_wire), .write (t2_writeA_a2_wire), .addr (t2_addrA_a2_wire), .din (t2_dinA_a2_wire),
                 .rd_dout (t2_doutA_a2_wire[t2r][t2b]), .rd_fwrd (t2_fwrdA_a2_wire[t2r][t2b]),
                 .rd_serr (t2_serrA_a2_wire[t2r][t2b]), .rd_derr (t2_derrA_a2_wire[t2r][t2b]), .rd_padr (t2_padrA_a2_wire[t2r][t2b]),
                 .mem_read (t2_readA_wire[t2r][t2b]), .mem_write (t2_writeA_wire[t2r][t2b]), .mem_addr (t2_addrA_wire[t2r][t2b]),
                 .mem_dwsn (t2_dwsnA_wire[t2r][t2b]), .mem_bw (t2_bwA_wire[t2r][t2b]), .mem_din (t2_dinA_wire[t2r][t2b]),
                 .mem_dout (t2_doutA_wire), .mem_serr (t2_serrA_wire),
                 .select_addr (select_vrow_a2),
                 .clk (clk), .rst (rst));
      end
      wire [BITRBNK-1:0] t2_bankA_a2_wire = t2_addrA_wire[t2r][t2b] >> (BITSROW2-BITRBNK-BITWSPF);

      if (REFRESH==1) begin: refr_loop
        infra_refr_1stage #(.NUMRBNK (NUMRBNK), .BITRBNK (BITRBNK), .REFLOPW (REFLOPW),
                            .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
          infra (.clk (clk), .rst (rst),
                 .pref (t2_refrB_a2_wire), .pacc (t2_readA_a2_wire || t2_writeA_a2_wire), .pacbadr (t2_bankA_a2_wire),
                 .prefr (t2_refrB_wire[t2r][t2b]), .prfbadr (t2_bankB_wire[t2r][t2b]),
                 .select_rbnk (select_rbnk), .select_rrow (select_rrow));
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
reg [NUMVBNK1*BITRBNK-1:0] t2_bankB;

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
      t2_bankB = t2_bankB | (t2_bankB_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*BITRBNK));
      t2_doutA_a2[t2r_int] = t2_doutA_a2[t2r_int] | (t2_doutA_a2_wire[t2r_int][t2b_int] << (t2b_int*WIDTH));
      t2_fwrdA_a2[t2r_int] = t2_fwrdA_a2[t2r_int] | (t2_fwrdA_a2_wire[t2r_int][t2b_int] << t2b_int);
      t2_serrA_a2[t2r_int] = t2_serrA_a2[t2r_int] | (t2_serrA_a2_wire[t2r_int][t2b_int] << t2b_int);
      t2_derrA_a2[t2r_int] = t2_derrA_a2[t2r_int] | (t2_derrA_a2_wire[t2r_int][t2b_int] << t2b_int);
      t2_padrA_a2[t2r_int] = t2_padrA_a2[t2r_int] | (t2_padrA_a2_wire[t2r_int][t2b_int] << (t2b_int*(BITSROW2+BITWRDS2)));
    end
  end
end

wire [NUMVBNK2-1:0] t3_readA_a3;
wire [NUMVBNK2-1:0] t3_writeA_a3;
wire [NUMVBNK2*BITVROW2-1:0] t3_addrA_a3;
wire [NUMVBNK2*WIDTH-1:0] t3_dinA_a3;
wire [NUMVBNK2-1:0] t3_refrB_a3;
reg [NUMVBNK2*WIDTH-1:0] t3_doutA_a3;
reg [NUMVBNK2-1:0] t3_fwrdA_a3;
reg [NUMVBNK2-1:0] t3_serrA_a3;
reg [NUMVBNK2-1:0] t3_derrA_a3;
reg [NUMVBNK2*(BITSROW2+BITWRDS2)-1:0] t3_padrA_a3;

wire [1-1:0] t4_readA_a3;
wire [1-1:0] t4_writeA_a3;
wire [1*BITVROW2-1:0] t4_addrA_a3;
wire [1*WIDTH-1:0] t4_dinA_a3;
wire [1-1:0] t4_refrB_a3;
reg [1*WIDTH-1:0] t4_doutA_a3;
reg [1-1:0] t4_fwrdA_a3;
reg [1-1:0] t4_serrA_a3;
reg [1-1:0] t4_derrA_a3;
reg [1*(BITSROW2+BITWRDS2)-1:0] t4_padrA_a3;

genvar a3_int;
generate for (a3_int=0; a3_int<1; a3_int=a3_int+1) begin: a3_loop
 
  algo_nror1w #(.WIDTH (WIDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .BITWDTH (BITWDTH), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1), .NUMVRPT (2), .NUMPRPT (1),
                .NUMVROW (NUMVROW2), .BITVROW (BITVROW2), .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2), .BITPBNK (BITPBNK2), .BITPADR (BITPADR2),
                .REFRESH (REFRESH), .REFFREQ (REFFREQ), .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPECC+FLOPMEM), .FLOPIN (FLOPIN2), .FLOPOUT (FLOPOUT2))
    algo (.refr (t3_refrB_a1[0]), .clk (clk), .rst (rst), .ready (t3_a3_ready),
          .write (t3_writeA_a1[0]), .wr_adr (t3_addrA_a1[BITVROW1-1:0]), .din (t3_dinA_a1[WIDTH-1:0]),
          .read (t3_readA_a1), .rd_adr (t3_addrA_a1), .rd_vld (), .rd_dout (t3_doutA_a1),
	  .rd_fwrd (t3_fwrdA_a1), .rd_serr (t3_serrA_a1), .rd_derr (t3_derrA_a1), .rd_padr (t3_padrA_a1),
          .t1_readA (t3_readA_a3), .t1_writeA (t3_writeA_a3), .t1_addrA (t3_addrA_a3), .t1_dinA (t3_dinA_a3), .t1_doutA (t3_doutA_a3),
	  .t1_fwrdA (t3_fwrdA_a3), .t1_serrA (t3_serrA_a3), .t1_derrA (t3_derrA_a3), .t1_padrA (t3_padrA_a3), .t1_refrB (t3_refrB_a3),
          .t2_readA (t4_readA_a3), .t2_writeA (t4_writeA_a3), .t2_addrA (t4_addrA_a3), .t2_dinA (t4_dinA_a3), .t2_doutA (t4_doutA_a3),
	  .t2_fwrdA (t4_fwrdA_a3), .t2_serrA (t4_serrA_a3), .t2_derrA (t4_derrA_a3), .t2_padrA (t4_padrA_a3), .t2_refrB (t4_refrB_a3),
	  .select_addr (select_addr_a2), .select_bit (select_bit));

end
endgenerate

wire [WIDTH-1:0] t3_doutA_a3_wire [0:NUMVBNK2-1]; 
wire t3_fwrdA_a3_wire [0:NUMVBNK2-1];
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
wire [BITRBNK-1:0] t3_bankB_wire [0:NUMVBNK2-1];

genvar t3;
generate for (t3=0; t3<NUMVBNK2; t3=t3+1) begin: t3_loop
  wire t3_readA_a3_wire = t3_readA_a3 >> t3;
  wire t3_writeA_a3_wire = t3_writeA_a3 >> t3;
  wire [BITVROW2-1:0] t3_addrA_a3_wire = t3_addrA_a3 >> (t3*BITVROW2);
  wire [WIDTH-1:0] t3_dinA_a3_wire = t3_dinA_a3 >> (t3*WIDTH);
  wire t3_refrB_a3_wire = t3_refrB_a3 >> t3;

  wire [NUMWRDS2*MEMWDTH-1:0] t3_doutA_wire = t3_doutA >> (t3*PHYWDTH2);
  wire [NUMWRDS2-1:0] t3_serrA_wire = t3_serrA >> t3;

  if (1) begin: align_loop
    infra_align_ecc_dwsn #(.WIDTH (WIDTH), .ENAEXT (ENAEXT), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                           .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                           .NUMSROW (NUMSROW2), .BITSROW (BITSROW2), .NUMWRDS (NUMWRDS2), .BITWRDS (BITWRDS2), .BITPADR (BITSROW2+BITWRDS2),
                           .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                           .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                           .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                           .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                           .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC), .RSTZERO (1))
      infra (.read (t3_readA_a3_wire), .write (t3_writeA_a3_wire), .addr (t3_addrA_a3_wire), .din (t3_dinA_a3_wire),
             .rd_dout (t3_doutA_a3_wire[t3]), .rd_fwrd (t3_fwrdA_a3_wire[t3]),
             .rd_serr (t3_serrA_a3_wire[t3]), .rd_derr (t3_derrA_a3_wire[t3]), .rd_padr (t3_padrA_a3_wire[t3]),
             .mem_read (t3_readA_wire[t3]), .mem_write (t3_writeA_wire[t3]), .mem_addr (t3_addrA_wire[t3]),
             .mem_dwsn (t3_dwsnA_wire[t3]), .mem_bw (t3_bwA_wire[t3]), .mem_din (t3_dinA_wire[t3]),
             .mem_dout (t3_doutA_wire), .mem_serr (t3_serrA_wire),
             .select_addr (select_vrow_a2),
             .clk (clk), .rst (rst));
  end

  wire [BITRBNK-1:0] t3_bankA_wire = t3_addrA_wire[t3] >> (BITSROW2-BITRBNK-BITWSPF);

  if (REFRESH==1) begin: refr_loop
    infra_refr_1stage #(.NUMRBNK (NUMRBNK), .BITRBNK (BITRBNK), .REFLOPW (REFLOPW),
                        .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
        infra (.clk (clk), .rst (rst),
               .pref (t3_refrB_a3_wire), .pacc (t3_readA_wire[t3] || t3_writeA_wire[t3]), .pacbadr (t3_bankA_wire),
               .prefr (t3_refrB_wire[t3]), .prfbadr (t3_bankB_wire[t3]),
               .select_rbnk (select_rbnk), .select_rrow (select_rrow));
  end else begin: no_refr_loop
    assign t3_refrB_wire[t3] = 1'b0;
    assign t3_bankB_wire[t3] = 0;
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
reg [NUMVBNK2*BITRBNK-1:0] t3_bankB;

integer t3_out_int;
always_comb begin
  t3_readA = 0;
  t3_writeA = 0;
  t3_addrA = 0;
  t3_dwsnA = 0;
  t3_bwA = 0;
  t3_dinA = 0;
  t3_refrB = 0;
  t3_bankB = 0;
  t3_doutA_a3 = 0;
  t3_fwrdA_a3 = 0;
  t3_serrA_a3 = 0;
  t3_derrA_a3 = 0;
  t3_padrA_a3 = 0;
  for (t3_out_int=0; t3_out_int<NUMVBNK2; t3_out_int=t3_out_int+1) begin
    t3_readA = t3_readA | (t3_readA_wire[t3_out_int] << t3_out_int);
    t3_writeA = t3_writeA | (t3_writeA_wire[t3_out_int] << t3_out_int);
    t3_addrA = t3_addrA | (t3_addrA_wire[t3_out_int] << (t3_out_int*BITSROW2));
    t3_dwsnA = t3_dwsnA | (t3_dwsnA_wire[t3_out_int] << (t3_out_int*BITDWSN));
    t3_bwA = t3_bwA | (t3_bwA_wire[t3_out_int] << (t3_out_int*PHYWDTH2));
    t3_dinA = t3_dinA | (t3_dinA_wire[t3_out_int] << (t3_out_int*PHYWDTH2));
    t3_doutA_a3 = t3_doutA_a3 | (t3_doutA_a3_wire[t3_out_int] << (t3_out_int*WIDTH));
    t3_fwrdA_a3 = t3_fwrdA_a3 | (t3_fwrdA_a3_wire[t3_out_int] << t3_out_int);
    t3_serrA_a3 = t3_serrA_a3 | (t3_serrA_a3_wire[t3_out_int] << t3_out_int);
    t3_derrA_a3 = t3_derrA_a3 | (t3_derrA_a3_wire[t3_out_int] << t3_out_int);
    t3_padrA_a3 = t3_padrA_a3 | (t3_padrA_a3_wire[t3_out_int] << (t3_out_int*(BITSROW2+BITWRDS2)));
    t3_refrB = t3_refrB | (t3_refrB_wire[t3_out_int] << t3_out_int);
    t3_bankB = t3_bankB | (t3_bankB_wire[t3_out_int] << (t3_out_int*BITRBNK));
  end
end

wire [WIDTH-1:0] t4_doutA_a3_wire [0:1-1];
wire t4_fwrdA_a3_wire [0:1-1];
wire t4_serrA_a3_wire [0:1-1];
wire t4_derrA_a3_wire [0:1-1];
wire [(BITSROW2+BITWRDS2)-1:0] t4_padrA_a3_wire [0:1-1];
wire t4_readA_wire [0:1-1];
wire t4_writeA_wire [0:1-1];
wire [BITSROW2-1:0] t4_addrA_wire [0:1-1];
wire [BITDWSN-1:0] t4_dwsnA_wire [0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t4_bwA_wire [0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t4_dinA_wire [0:1-1];
wire t4_refrB_wire [0:1-1];
wire [BITRBNK-1:0] t4_bankB_wire [0:1-1];

genvar t4;
generate for (t4=0; t4<1; t4=t4+1) begin: t4_loop
  wire t4_readA_a3_wire = t4_readA_a3 >> t4;
  wire t4_writeA_a3_wire = t4_writeA_a3 >> t4;
  wire [BITVROW2-1:0] t4_addrA_a3_wire = t4_addrA_a3 >> (t4*BITVROW2);
  wire [WIDTH-1:0] t4_dinA_a3_wire = t4_dinA_a3 >> (t4*WIDTH);
  wire t4_refrB_a3_wire = t4_refrB_a3 >> t4;

  wire [NUMWRDS2*MEMWDTH-1:0] t4_doutA_wire = t4_doutA >> (t4*PHYWDTH2);
  wire [NUMWRDS2-1:0] t4_serrA_wire = t4_serrA >> t4;

  if (1) begin: align_loop
    infra_align_ecc_dwsn #(.WIDTH (WIDTH), .ENAEXT (ENAEXT), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                           .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                           .NUMSROW (NUMSROW2), .BITSROW (BITSROW2), .NUMWRDS (NUMWRDS2), .BITWRDS (BITWRDS2), .BITPADR (BITSROW2+BITWRDS2),
                           .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                           .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                           .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                           .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                           .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC), .RSTZERO (1))
      infra (.read (t4_readA_a3_wire), .write (t4_writeA_a3_wire), .addr (t4_addrA_a3_wire), .din (t4_dinA_a3_wire),
             .rd_dout (t4_doutA_a3_wire[t4]), .rd_fwrd (t4_fwrdA_a3_wire[t4]),
             .rd_serr (t4_serrA_a3_wire[t4]), .rd_derr (t4_derrA_a3_wire[t4]), .rd_padr (t4_padrA_a3_wire[t4]),
             .mem_read (t4_readA_wire[t4]), .mem_write (t4_writeA_wire[t4]), .mem_addr (t4_addrA_wire[t4]),
             .mem_dwsn (t4_dwsnA_wire[t4]), .mem_bw (t4_bwA_wire[t4]), .mem_din (t4_dinA_wire[t4]),
             .mem_dout (t4_doutA_wire), .mem_serr (t4_serrA_wire),
             .select_addr (select_vrow_a2),
             .clk (clk), .rst (rst));
  end

  wire [BITRBNK-1:0] t4_bankA_wire = t4_addrA_wire[t4] >> (BITSROW2-BITRBNK-BITWSPF);

  if (REFRESH==1) begin: refr_loop
    infra_refr_1stage #(.NUMRBNK (NUMRBNK), .BITRBNK (BITRBNK), .REFLOPW (REFLOPW),
                        .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
      infra (.clk (clk), .rst (rst),
             .pref (t4_refrB_a3_wire), .pacc (t4_readA_wire[t4] || t4_writeA_wire[t4]), .pacbadr (t4_bankA_wire),
             .prefr (t4_refrB_wire[t4]), .prfbadr (t4_bankB_wire[t4]),
             .select_rbnk (select_rbnk), .select_rrow (select_rrow));
  end else begin: no_refr_loop
    assign t4_refrB_wire[t4] = 1'b0;
    assign t4_bankB_wire[t4] = 0;
  end

end
endgenerate
reg [1-1:0] t4_readA;
reg [1-1:0] t4_writeA;
reg [1*BITSROW2-1:0] t4_addrA;
reg [1*BITDWSN-1:0] t4_dwsnA;
reg [1*PHYWDTH2-1:0] t4_bwA;
reg [1*PHYWDTH2-1:0] t4_dinA;
reg [1-1:0] t4_refrB;
reg [1*BITRBNK-1:0] t4_bankB;

integer t4_out_int;
always_comb begin
  t4_readA = 0;
  t4_writeA = 0;
  t4_addrA = 0;
  t4_dwsnA = 0;
  t4_bwA = 0;
  t4_dinA = 0;
  t4_doutA_a3 = 0;
  t4_fwrdA_a3 = 0;
  t4_serrA_a3 = 0;
  t4_derrA_a3 = 0;
  t4_padrA_a3 = 0;
  t4_refrB = 0;
  t4_bankB = 0;
  for (t4_out_int=0; t4_out_int<1; t4_out_int=t4_out_int+1) begin
    t4_readA = t4_readA | (t4_readA_wire[t4_out_int] << t4_out_int);
    t4_writeA = t4_writeA | (t4_writeA_wire[t4_out_int] << t4_out_int);
    t4_addrA = t4_addrA | (t4_addrA_wire[t4_out_int] << (t4_out_int*BITSROW2));
    t4_dwsnA = t4_dwsnA | (t4_dwsnA_wire[t4_out_int] << (t4_out_int*BITDWSN));
    t4_bwA = t4_bwA | (t4_bwA_wire[t4_out_int] << (t4_out_int*PHYWDTH2));
    t4_dinA = t4_dinA | (t4_dinA_wire[t4_out_int] << (t4_out_int*PHYWDTH2));
    t4_doutA_a3 = t4_doutA_a3 | (t4_doutA_a3_wire[t4_out_int] << (t4_out_int*WIDTH));
    t4_fwrdA_a3 = t4_fwrdA_a3 | (t4_fwrdA_a3_wire[t4_out_int] << t4_out_int);
    t4_serrA_a3 = t4_serrA_a3 | (t4_serrA_a3_wire[t4_out_int] << t4_out_int);
    t4_derrA_a3 = t4_derrA_a3 | (t4_derrA_a3_wire[t4_out_int] << t4_out_int);
    t4_padrA_a3 = t4_padrA_a3 | (t4_padrA_a3_wire[t4_out_int] << (t4_out_int*(BITSROW2+BITWRDS2)));
    t4_refrB = t4_refrB | (t4_refrB_wire[t4_out_int] << t4_out_int);
    t4_bankB = t4_bankB | (t4_bankB_wire[t4_out_int] << (t4_out_int*BITRBNK));
  end
end

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

assume_xwr_rerr_check: assert property (@(posedge clk) disable iff (rst) (ready || a1_loop.algo.ip_top_sva.xwr_nerr));
assume_xwr_nerr_check: assert property (@(posedge clk) disable iff (rst) (a3_loop[0].algo.ip_top_sva.write &&
                                                                          (a3_loop[0].algo.ip_top_sva.wr_row == select_vrow_a2)) |->
                                        (a1_loop.algo.ip_top_sva.xwr_nerr == &a3_loop[0].algo.ip_top_sva.mem_nerr[0]));
assume_xwr_serr_check: assert property (@(posedge clk) disable iff (rst) (a3_loop[0].algo.ip_top_sva.write &&
                                                                          (a3_loop[0].algo.ip_top_sva.wr_row == select_vrow_a2) &&
                                                                          (ENAPAR ? (|a3_loop[0].algo.ip_top_sva.mem_serr[0] ||
                                                                                     |a3_loop[0].algo.ip_top_sva.mem_derr[0]) :
                                                                                    |a3_loop[0].algo.ip_top_sva.mem_derr[0])) |->
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
