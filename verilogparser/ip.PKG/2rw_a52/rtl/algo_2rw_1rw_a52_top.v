
module algo_2rw_1rw_a52_top (refr, clk, rst, ready,
                             read, write, addr, din, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                             t1_readA, t1_writeA, t1_addrA, t1_dwsnA, t1_bwA, t1_dinA, t1_doutA, t1_refrB, t1_bankB,
                             t2_readA, t2_writeA, t2_addrA, t2_dwsnA, t2_bwA, t2_dinA, t2_doutA, t2_refrB, t2_bankB,
                             t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
                             t4_writeA, t4_addrA, t4_dinA, t4_readB, t4_addrB, t4_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAEXT = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW1 = 1024;
  parameter BITVROW1 = 10;
  parameter NUMVBNK1 = 8;
  parameter BITVBNK1 = 3;
  parameter BITPBNK1 = 4;
  parameter NUMWRDS1 = 1;      // ALIGN Parameters
  parameter BITWRDS1 = 0;
  parameter NUMSROW1 = 1024;
  parameter BITSROW1 = 10;
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
  parameter BITPROW2 = BITSROW2;
  parameter FLOPIN2 = 0;
  parameter FLOPOUT2 = 0;
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
  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 2;
  parameter ECCBITS = 4;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;

  parameter BITPADR2 = BITPBNK2+BITSROW2+BITWRDS2;
  parameter BITPADR1 = BITPBNK1+BITPADR2+1;

  parameter SDOUT_WIDTH = 2*(BITVBNK1+1)+ECCBITS;

  input                          refr;

  input [2-1:0]                  read;
  input [2-1:0]                  write;
  input [2*BITADDR-1:0]          addr;
  input [2*WIDTH-1:0]            din;
  output [2-1:0]                 rd_vld;
  output [2*WIDTH-1:0]           rd_dout;
  output [2-1:0]                 rd_serr;
  output [2-1:0]                 rd_derr;
  output [2*BITPADR1-1:0]        rd_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
  output [NUMVBNK1*NUMVBNK2*BITVROW2-1:0] t1_addrA;
  output [NUMVBNK1*NUMVBNK2*BITDWSN-1:0] t1_dwsnA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_doutA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_refrB;
  output [NUMVBNK1*NUMVBNK2*BITRBNK-1:0] t1_bankB;

  output [NUMVBNK1-1:0] t2_readA;
  output [NUMVBNK1-1:0] t2_writeA;
  output [NUMVBNK1*BITVROW2-1:0] t2_addrA;
  output [NUMVBNK1*BITDWSN-1:0] t2_dwsnA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_bwA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_dinA;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_doutA;
  output [NUMVBNK1-1:0] t2_refrB;
  output [NUMVBNK1*BITRBNK-1:0] t2_bankB;

  output [2-1:0] t3_writeA;
  output [2*BITVROW1-1:0] t3_addrA;
  output [2*SDOUT_WIDTH-1:0] t3_dinA;
  output [2-1:0] t3_readB;
  output [2*BITVROW1-1:0] t3_addrB;
  input [2*SDOUT_WIDTH-1:0] t3_doutB;

  output [2-1:0] t4_writeA;
  output [2*BITVROW1-1:0] t4_addrA;
  output [2*MEMWDTH-1:0] t4_dinA;
  output [2-1:0] t4_readB;
  output [2*BITVROW1-1:0] t4_addrB;
  input [2*MEMWDTH-1:0] t4_doutB;

`ifdef FORMAL 
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
wire [BITRBNK-1:0] select_rbnk;
wire [BITRROW-1:0] select_rrow;
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr==0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit==0));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));
assume_select_rbnk_range: assume property (@(posedge clk) disable iff (rst) (select_rbnk < NUMRBNK));
assume_select_rbnk_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_rbnk));
assume_select_rrow_range: assume property (@(posedge clk) disable iff (rst) (select_rrow < NUMRROW));
assume_select_rrow_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_rrow));
  
wire [BITVROW1-1:0] select_vrow_a1;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK1), .BITVBNK (BITVBNK1),
  .NUMVROW (NUMVROW1), .BITVROW (BITVROW1))
  adr_a2 (.vbadr(), .vradr(select_vrow_a1), .vaddr(select_addr));

wire [BITVROW2-1:0] select_vrow_a2;
np2_addr #(
  .NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
  .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2),
  .NUMVROW (NUMVROW2), .BITVROW (BITVROW2))
  row_a2 (.vbadr(), .vradr(select_vrow_a2), .vaddr(select_vrow_a1));

`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITVROW1-1:0] select_vrow_a1 = 0;
wire [BITVROW2-1:0] select_vrow_a2 = 0;
wire [BITRBNK-1:0] select_rbnk = 0;
wire [BITRROW-1:0] select_rrow = 0;
`endif

wire [NUMVBNK1-1:0] t1_writeA_a1;
wire [NUMVBNK1*BITVROW1-1:0] t1_addrA_a1;
wire [NUMVBNK1*WIDTH-1:0] t1_dinA_a1;

wire [NUMVBNK1-1:0] t1_readB_a1;
wire [NUMVBNK1*BITVROW1-1:0] t1_addrB_a1;
reg [NUMVBNK1*WIDTH-1:0] t1_doutB_a1;
reg [NUMVBNK1-1:0] t1_fwrdB_a1;
reg [NUMVBNK1-1:0] t1_serrB_a1;
reg [NUMVBNK1-1:0] t1_derrB_a1;
reg [NUMVBNK1*BITPADR2-1:0] t1_padrB_a1;

wire [NUMVBNK1-1:0] t1_readC_a1;
wire [NUMVBNK1*BITVROW1-1:0] t1_addrC_a1;
reg [NUMVBNK1*WIDTH-1:0] t1_doutC_a1;
reg [NUMVBNK1-1:0] t1_fwrdC_a1;
reg [NUMVBNK1-1:0] t1_serrC_a1;
reg [NUMVBNK1-1:0] t1_derrC_a1;
reg [NUMVBNK1*BITPADR2-1:0] t1_padrC_a1;

wire [NUMVBNK1-1:0] t1_refrD_a1;

wire [2-1:0] t3_writeA_a1;
wire [2*BITVROW1-1:0] t3_addrA_a1;
wire [2*SDOUT_WIDTH-1:0] t3_dinA_a1;
wire [2-1:0] t3_readB_a1;
wire [2*BITVROW1-1:0] t3_addrB_a1;
reg [2*SDOUT_WIDTH-1:0] t3_doutB_a1;
reg [2-1:0] t3_fwrdB_a1;
reg [2-1:0] t3_serrB_a1;
reg [2-1:0] t3_derrB_a1;
reg [2*BITPADR2-1:0] t3_padrB_a1;

wire [2-1:0] t4_writeA_a1;
wire [2*BITVROW1-1:0] t4_addrA_a1;
wire [2*WIDTH-1:0] t4_dinA_a1;
wire [2-1:0] t4_readB_a1;
wire [2*BITVROW1-1:0] t4_addrB_a1;
reg [2*WIDTH-1:0] t4_doutB_a1;
reg [2-1:0] t4_fwrdB_a1;
reg [2-1:0] t4_serrB_a1;
reg [2-1:0] t4_derrB_a1;
reg [2*BITPADR2-1:0] t4_padrB_a1;

wire [NUMVBNK1-1:0] t1_a2_ready;

generate if (1) begin: a1_loop

algo_2rw_2ror1w_a52 #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .NUMADDR(NUMADDR), .BITADDR(BITADDR),
                      .NUMVBNK(NUMVBNK1), .BITVBNK(BITVBNK1), .NUMVROW(NUMVROW1), .BITVROW(BITVROW1), .BITPBNK(BITPBNK1), .BITPADR(BITPADR1-1),
                      .REFRESH(REFRESH), .SRAM_DELAY(SRAM_DELAY+FLOPCMD+FLOPMEM), .DRAM_DELAY(DRAM_DELAY+FLOPMEM+FLOPCMD+FLOPIN2+FLOPOUT2),
                      .FLOPIN(FLOPIN1), .FLOPOUT(FLOPOUT1), .ECCBITS(ECCBITS))
  algo (.refr(refr), .ready(ready), .clk(clk), .rst (rst || !(|t1_a2_ready)),
        .read(read),. write(write), .addr(addr), .din(din), .rd_vld(rd_vld), .rd_dout(rd_dout),
        .rd_fwrd({rd_padr[2*BITPADR1-1],rd_padr[BITPADR1-1]}), .rd_serr(rd_serr), .rd_derr(rd_derr),
        .rd_padr({rd_padr[2*BITPADR1-2:BITPADR1],rd_padr[BITPADR1-2:0]}),
        .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
        .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1),
        .t1_fwrdB(t1_fwrdB_a1), .t1_serrB(t1_serrB_a1), .t1_derrB(t1_derrB_a1), .t1_padrB(t1_padrB_a1),
        .t1_readC(t1_readC_a1), .t1_addrC(t1_addrC_a1), .t1_doutC(t1_doutC_a1), 
        .t1_fwrdC(t1_fwrdC_a1), .t1_serrC(t1_serrC_a1), .t1_derrC(t1_derrC_a1), .t1_padrC(t1_padrC_a1),
        .t1_refrD(t1_refrD_a1),
        .t2_writeA(t3_writeA_a1), .t2_addrA(t3_addrA_a1), .t2_dinA(t3_dinA_a1),
        .t2_readB(t3_readB_a1), .t2_addrB(t3_addrB_a1), .t2_doutB(t3_doutB_a1),
        .t3_writeA(t4_writeA_a1), .t3_addrA(t4_addrA_a1), .t3_dinA(t4_dinA_a1),
        .t3_readB(t4_readB_a1), .t3_addrB(t4_addrB_a1), .t3_doutB(t4_doutB_a1),
        .t3_fwrdB(t4_fwrdB_a1), .t3_serrB(t4_serrB_a1), .t3_derrB(t4_derrB_a1), .t3_padrB(t4_padrB_a1),
	.select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

wire [NUMVBNK2-1:0] t1_readA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2-1:0] t1_writeA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2*BITVROW2-1:0] t1_addrA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2*WIDTH-1:0] t1_dinA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2*WIDTH-1:0] t1_doutA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2-1:0] t1_fwrdA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2-1:0] t1_serrA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2-1:0] t1_derrA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2*(BITSROW2+BITWRDS2)-1:0] t1_padrA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2-1:0] t1_refrB_a2 [0:NUMVBNK1-1];

wire t2_readA_a2 [0:NUMVBNK1-1];
wire t2_writeA_a2 [0:NUMVBNK1-1];
wire [BITVROW2-1:0] t2_addrA_a2 [0:NUMVBNK1-1];
wire [WIDTH-1:0] t2_dinA_a2 [0:NUMVBNK1-1];
reg [WIDTH-1:0] t2_doutA_a2 [0:NUMVBNK1-1];
reg t2_fwrdA_a2 [0:NUMVBNK1-1];
reg t2_serrA_a2 [0:NUMVBNK1-1];
reg t2_derrA_a2 [0:NUMVBNK1-1];
reg [(BITSROW2+BITWRDS2)-1:0] t2_padrA_a2 [0:NUMVBNK1-1];
wire t2_refrB_a2 [0:NUMVBNK1-1];

wire [WIDTH-1:0] t1_doutB_a1_wire [0:NUMVBNK1-1];
wire t1_fwrdB_a1_wire [0:NUMVBNK1-1];
wire t1_serrB_a1_wire [0:NUMVBNK1-1];
wire t1_derrB_a1_wire [0:NUMVBNK1-1];
wire [BITPADR2-1:0] t1_padrB_a1_wire [0:NUMVBNK1-1];
wire [WIDTH-1:0] t1_doutC_a1_wire [0:NUMVBNK1-1];
wire t1_fwrdC_a1_wire [0:NUMVBNK1-1];
wire t1_serrC_a1_wire [0:NUMVBNK1-1];
wire t1_derrC_a1_wire [0:NUMVBNK1-1];
wire [BITPADR2-1:0] t1_padrC_a1_wire [0:NUMVBNK1-1];


genvar a2;
generate for (a2=0; a2<NUMVBNK1; a2=a2+1) begin: a2_loop
  wire vwrite = t1_writeA_a1 >> a2;
  wire [BITVROW1-1:0] vwraddr = t1_addrA_a1 >> a2*BITVROW1;
  wire [WIDTH-1:0] vdin = t1_dinA_a1 >> a2*WIDTH;
  wire vread1 = t1_readB_a1 >> a2;
  wire [BITVROW1-1:0] vrdaddr1 = t1_addrB_a1 >> a2*BITVROW1;
  wire vread2 = t1_readC_a1 >> a2;
  wire [BITVROW1-1:0] vrdaddr2 = t1_addrC_a1 >> a2*BITVROW1;
  wire vrefr = t1_refrD_a1 >> a2;

  algo_nror1w #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .NUMVRPT(2), .NUMPRPT(1), .NUMADDR(NUMVROW1), .BITADDR(BITVROW1),
                .NUMVROW(NUMVROW2), .BITVROW(BITVROW2), .NUMVBNK(NUMVBNK2), .BITVBNK(BITVBNK2), .BITPBNK(BITPBNK2), .BITPADR(BITPADR2),
                .REFRESH(REFRESH), .REFFREQ(REFFREQ), .SRAM_DELAY(DRAM_DELAY+FLOPCMD+FLOPECC+FLOPMEM), .FLOPIN (FLOPIN2), .FLOPOUT (FLOPOUT2))
    algo (.refr (vrefr), .ready (t1_a2_ready[a2]), .clk (clk), .rst (rst),
          .write (vwrite), .wr_adr (vwraddr), .din (vdin),
          .read ({vread2,vread1}), .rd_adr ({vrdaddr2,vrdaddr1}),
	  .rd_vld (), .rd_dout ({t1_doutC_a1_wire[a2],t1_doutB_a1_wire[a2]}),
          .rd_fwrd ({t1_fwrdC_a1_wire[a2],t1_fwrdB_a1_wire[a2]}), .rd_serr ({t1_serrC_a1_wire[a2],t1_serrB_a1_wire[a2]}),
          .rd_derr ({t1_derrC_a1_wire[a2],t1_derrB_a1_wire[a2]}), .rd_padr ({t1_padrC_a1_wire[a2],t1_padrB_a1_wire[a2]}),
          .t1_readA (t1_readA_a2[a2]), .t1_writeA (t1_writeA_a2[a2]), .t1_addrA (t1_addrA_a2[a2]), .t1_dinA (t1_dinA_a2[a2]), .t1_doutA (t1_doutA_a2[a2]),
          .t1_fwrdA (t1_fwrdA_a2[a2]), .t1_serrA (t1_serrA_a2[a2]), .t1_derrA (t1_derrA_a2[a2]), .t1_padrA (t1_padrA_a2[a2]), .t1_refrB (t1_refrB_a2[a2]),
          .t2_readA (t2_readA_a2[a2]), .t2_writeA (t2_writeA_a2[a2]), .t2_addrA (t2_addrA_a2[a2]), .t2_dinA (t2_dinA_a2[a2]), .t2_doutA (t2_doutA_a2[a2]),
          .t2_fwrdA (t2_fwrdA_a2[a2]), .t2_serrA (t2_serrA_a2[a2]), .t2_derrA (t2_derrA_a2[a2]), .t2_padrA (t2_padrA_a2[a2]), .t2_refrB (t2_refrB_a2[a2]),
	  .select_addr (select_vrow_a1), .select_bit (select_bit));
end
endgenerate

integer t1_dout_int;
always_comb begin
  t1_doutB_a1 = 0;
  t1_fwrdB_a1 = 0;
  t1_serrB_a1 = 0;
  t1_derrB_a1 = 0;
  t1_padrB_a1 = 0;
  t1_doutC_a1 = 0;
  t1_fwrdC_a1 = 0;
  t1_serrC_a1 = 0;
  t1_derrC_a1 = 0;
  t1_padrC_a1 = 0;
  for (t1_dout_int=0; t1_dout_int<NUMVBNK1; t1_dout_int=t1_dout_int+1) begin
    t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[t1_dout_int] << (t1_dout_int*WIDTH));
    t1_fwrdB_a1 = t1_fwrdB_a1 | (t1_fwrdB_a1_wire[t1_dout_int] << t1_dout_int);
    t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_wire[t1_dout_int] << t1_dout_int);
    t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[t1_dout_int] << t1_dout_int);
    t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_wire[t1_dout_int] << (t1_dout_int*BITPADR2));
    t1_doutC_a1 = t1_doutC_a1 | (t1_doutC_a1_wire[t1_dout_int] << (t1_dout_int*WIDTH));
    t1_fwrdC_a1 = t1_fwrdC_a1 | (t1_fwrdC_a1_wire[t1_dout_int] << t1_dout_int);
    t1_serrC_a1 = t1_serrC_a1 | (t1_serrC_a1_wire[t1_dout_int] << t1_dout_int);
    t1_derrC_a1 = t1_derrC_a1 | (t1_derrC_a1_wire[t1_dout_int] << t1_dout_int);
    t1_padrC_a1 = t1_padrC_a1 | (t1_padrC_a1_wire[t1_dout_int] << (t1_dout_int*BITPADR2));
  end
end

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

      if (1) begin: align_loop
        infra_align_ecc_dwsn #(.WIDTH (WIDTH), .ENAEXT (ENAEXT), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                               .NUMSROW (NUMSROW2), .BITSROW (BITSROW2), .NUMWRDS (NUMWRDS2), .BITWRDS (BITWRDS2), .BITPADR (BITSROW2+BITWRDS2),
                               .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                               .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                               .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                               .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                               .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPCMD(FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.read (t1_readA_a2_wire), .write (t1_writeA_a2_wire), .addr (t1_addrA_a2_wire), .din (t1_dinA_a2_wire), .rd_dout (t1_doutA_a2_wire[t1r][t1b]),
                 .rd_fwrd (t1_fwrdA_a2_wire[t1r][t1b]), .rd_serr (t1_serrA_a2_wire[t1r][t1b]), .rd_derr (t1_derrA_a2_wire[t1r][t1b]), .rd_padr (t1_padrA_a2_wire[t1r][t1b]),
                 .mem_read (t1_readA_wire[t1r][t1b]), .mem_write (t1_writeA_wire[t1r][t1b]), .mem_addr (t1_addrA_wire[t1r][t1b]),
                 .mem_dwsn (t1_dwsnA_wire[t1r][t1b]), .mem_bw (t1_bwA_wire[t1r][t1b]), .mem_din (t1_dinA_wire[t1r][t1b]), .mem_dout (t1_doutA_wire), .mem_serr(),
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

      if (1) begin: align_loop
        infra_align_ecc_dwsn #(.WIDTH (WIDTH), .ENAEXT (ENAEXT), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                               .NUMSROW (NUMSROW2), .BITSROW (BITSROW2), .NUMWRDS (NUMWRDS2), .BITWRDS (BITWRDS2), .BITPADR (BITSROW2+BITWRDS2),
                               .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                               .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                               .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                               .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                               .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPCMD(FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.read (t2_readA_a2_wire), .write (t2_writeA_a2_wire), .addr (t2_addrA_a2_wire), .din (t2_dinA_a2_wire), .rd_dout (t2_doutA_a2_wire[t2r][t2b]),
                 .rd_fwrd (t2_fwrdA_a2_wire[t2r][t2b]), .rd_serr (t2_serrA_a2_wire[t2r][t2b]), .rd_derr (t2_derrA_a2_wire[t2r][t2b]), .rd_padr (t2_padrA_a2_wire[t2r][t2b]),
                 .mem_read (t2_readA_wire[t2r][t2b]), .mem_write (t2_writeA_wire[t2r][t2b]), .mem_addr (t2_addrA_wire[t2r][t2b]),
                 .mem_dwsn (t2_dwsnA_wire[t2r][t2b]), .mem_bw (t2_bwA_wire[t2r][t2b]), .mem_din (t2_dinA_wire[t2r][t2b]), .mem_dout (t2_doutA_wire), .mem_serr(),
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

wire [SDOUT_WIDTH-1:0] t3_doutB_a1_wire [0:2-1];
wire t3_fwrdB_a1_wire [0:2-1];
wire t3_serrB_a1_wire [0:2-1];
wire t3_derrB_a1_wire [0:2-1];
wire [BITVROW1-1:0] t3_padrB_a1_wire [0:2-1];
wire t3_writeA_wire [0:2-1];
wire [BITVROW1-1:0] t3_addrA_wire [0:2-1];
wire [SDOUT_WIDTH-1:0] t3_bwA_wire [0:2-1];
wire [SDOUT_WIDTH-1:0] t3_dinA_wire [0:2-1];
wire t3_readB_wire [0:2-1];
wire [BITVROW1-1:0] t3_addrB_wire [0:2-1];

genvar t3r;
generate
  for (t3r=0; t3r<2; t3r=t3r+1) begin: t3c_loop
    wire t3_writeA_a1_wire = t3_writeA_a1 >> t3r;
    wire [BITVROW1-1:0] t3_addrA_a1_wire = t3_addrA_a1 >> (t3r*BITVROW1);
    wire [SDOUT_WIDTH-1:0] t3_dinA_a1_wire = t3_dinA_a1 >> (t3r*SDOUT_WIDTH);
    wire t3_readB_a1_wire = t3_readB_a1 >> t3r;
    wire [BITVROW1-1:0] t3_addrB_a1_wire = t3_addrB_a1 >> (t3r*BITVROW1);

    wire [SDOUT_WIDTH-1:0] t3_doutB_wire = t3_doutB >> (t3r*SDOUT_WIDTH);

    wire mem_write_wire;
    wire [BITVROW1-1:0] mem_wr_adr_wire;
    wire [SDOUT_WIDTH-1:0] mem_bw_wire;
    wire [SDOUT_WIDTH-1:0] mem_din_wire;
    wire mem_read_wire;
    wire [BITVROW1-1:0] mem_rd_adr_wire;
    wire [SDOUT_WIDTH-1:0] mem_rd_dout_wire;
    wire mem_rd_fwrd_wire;
    wire mem_rd_serr_wire;
    wire mem_rd_derr_wire;
    wire [BITVROW1-1:0] mem_rd_padr_wire;

    if (1) begin: align_loop
      infra_align_ecc_1r1w #(.WIDTH (SDOUT_WIDTH), .ENAPSDO (0), .ENAPAR (0), .ENAECC (0), .ECCWDTH (ECCBITS),
                             .NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
                             .NUMSROW (NUMVROW1), .BITSROW (BITVROW1), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITVROW1),
                             .SRAM_DELAY (SRAM_DELAY+FLOPMEM+FLOPCMD), .FLOPGEN (0), .FLOPMEM (0), .RSTZERO (1), .ENAPADR (1))
        infra (.write(t3_writeA_a1_wire), .wr_adr(t3_addrA_a1_wire), .din(t3_dinA_a1_wire),
               .read(t3_readB_a1_wire), .rd_adr(t3_addrB_a1_wire), .rd_dout(t3_doutB_a1_wire[t3r]),
               .rd_fwrd(t3_fwrdB_a1_wire[t3r]), .rd_serr(t3_serrB_a1_wire[t3r]), .rd_derr(t3_derrB_a1_wire[t3r]), .rd_padr(t3_padrB_a1_wire[t3r]),
               .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
               .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
               .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_vrow_a1));
    end
    if (1) begin: stack_loop
      infra_stack_1r1w #(.WIDTH (SDOUT_WIDTH), .ENAPSDO (0), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
                         .NUMWBNK (1), .BITWBNK (0), .NUMWROW (NUMVROW1), .BITWROW (BITVROW1),
                         .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (0), .RSTZERO (1))
                         //.SRAM_DELAY (SRAM_DELAY), .FLOPCMD (0), .FLOPMEM (FLOPMEM), .FLOPOUT (0), .RSTZERO (1))
        infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
               .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
               .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr (mem_rd_derr_wire), .rd_padr (mem_rd_padr_wire),
               .mem_write (t3_writeA_wire[t3r]), .mem_wr_adr(t3_addrA_wire[t3r]), .mem_bw (t3_bwA_wire[t3r]), .mem_din (t3_dinA_wire[t3r]),
               .mem_read (t3_readB_wire[t3r]), .mem_rd_adr(t3_addrB_wire[t3r]), .mem_rd_dout (t3_doutB_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_vrow_a1));
    end
  end
endgenerate

reg [2-1:0] t3_writeA;
reg [2*BITVROW1-1:0] t3_addrA;
reg [2*SDOUT_WIDTH-1:0] t3_bwA;
reg [2*SDOUT_WIDTH-1:0] t3_dinA;
reg [2-1:0] t3_readB;
reg [2*BITVROW1-1:0] t3_addrB;

integer t3r_int;
always_comb begin
  t3_writeA = 0;
  t3_addrA = 0;
  t3_bwA = 0;
  t3_dinA = 0;
  t3_readB = 0;
  t3_addrB = 0;
  t3_doutB_a1 = 0;
  t3_fwrdB_a1 = 0;
  t3_serrB_a1 = 0;
  t3_derrB_a1 = 0;
  t3_padrB_a1 = 0;
  for (t3r_int=0; t3r_int<2; t3r_int=t3r_int+1) begin
    t3_writeA = t3_writeA | (t3_writeA_wire[t3r_int] << t3r_int);
    t3_addrA = t3_addrA | (t3_addrA_wire[t3r_int] << (t3r_int*BITVROW1));
    t3_bwA = t3_bwA | (t3_bwA_wire[t3r_int] << (t3r_int*SDOUT_WIDTH));
    t3_dinA = t3_dinA | (t3_dinA_wire[t3r_int] << (t3r_int*SDOUT_WIDTH));
    t3_readB = t3_readB | (t3_readB_wire[t3r_int] << t3r_int);
    t3_addrB = t3_addrB | (t3_addrB_wire[t3r_int] << (t3r_int*BITVROW1));
    t3_doutB_a1 = t3_doutB_a1 | (t3_doutB_a1_wire[t3r_int] << (t3r_int*SDOUT_WIDTH));
    t3_fwrdB_a1 = t3_fwrdB_a1 | (t3_fwrdB_a1_wire[t3r_int] << t3r_int);
    t3_serrB_a1 = t3_serrB_a1 | (t3_serrB_a1_wire[t3r_int] << t3r_int);
    t3_padrB_a1 = t3_padrB_a1 | (t3_padrB_a1_wire[t3r_int] << (t3r_int*BITPADR2));
  end
end

wire [WIDTH-1:0] t4_doutB_a1_wire [0:2-1];
wire t4_fwrdB_a1_wire [0:2-1];
wire t4_serrB_a1_wire [0:2-1];
wire t4_derrB_a1_wire [0:2-1];
wire [BITVROW1-1:0] t4_padrB_a1_wire [0:2-1];
wire t4_writeA_wire [0:2-1];
wire [BITVROW1-1:0] t4_addrA_wire [0:2-1];
wire [MEMWDTH-1:0] t4_bwA_wire [0:2-1];
wire [MEMWDTH-1:0] t4_dinA_wire [0:2-1];
wire t4_readB_wire [0:2-1];
wire [BITVROW1-1:0] t4_addrB_wire [0:2-1];

genvar t4r;
generate
  for (t4r=0; t4r<2; t4r=t4r+1) begin: t4c_loop
    wire t4_writeA_a1_wire = t4_writeA_a1 >> t4r;
    wire [BITVROW1-1:0] t4_addrA_a1_wire = t4_addrA_a1 >> (t4r*BITVROW1);
    wire [WIDTH-1:0] t4_dinA_a1_wire = t4_dinA_a1 >> (t4r*WIDTH);
    wire t4_readB_a1_wire = t4_readB_a1 >> t4r;
    wire [BITVROW1-1:0] t4_addrB_a1_wire = t4_addrB_a1 >> (t4r*BITVROW1);

    wire [MEMWDTH-1:0] t4_doutB_wire = t4_doutB >> (t4r*MEMWDTH);

    wire mem_write_wire;
    wire [BITVROW1-1:0] mem_wr_adr_wire;
    wire [MEMWDTH-1:0] mem_bw_wire;
    wire [MEMWDTH-1:0] mem_din_wire;
    wire mem_read_wire;
    wire [BITVROW1-1:0] mem_rd_adr_wire;
    wire [MEMWDTH-1:0] mem_rd_dout_wire;
    wire mem_rd_fwrd_wire;
    wire mem_rd_serr_wire;
    wire mem_rd_derr_wire;
    wire [BITVROW1-1:0] mem_rd_padr_wire;

    if (1) begin: align_loop
      infra_align_ecc_1r1w #(.WIDTH (WIDTH), .ENAPSDO (1), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                             .NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
                             .NUMSROW (NUMVROW1), .BITSROW (BITVROW1), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITVROW1),
                             .SRAM_DELAY (SRAM_DELAY+FLOPMEM+FLOPCMD), .FLOPGEN (1), .FLOPMEM (0), .RSTZERO (1), .ENAPADR (1))
        infra (.write(t4_writeA_a1_wire), .wr_adr(t4_addrA_a1_wire), .din(t4_dinA_a1_wire),
               .read(t4_readB_a1_wire), .rd_adr(t4_addrB_a1_wire), .rd_dout(t4_doutB_a1_wire[t4r]),
               .rd_fwrd(t4_fwrdB_a1_wire[t4r]), .rd_serr(t4_serrB_a1_wire[t4r]), .rd_derr(t4_derrB_a1_wire[t4r]), .rd_padr(t4_padrB_a1_wire[t4r]),
               .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
               .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
               .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_vrow_a1));
    end
    if (1) begin: stack_loop
      infra_stack_1r1w #(.WIDTH (MEMWDTH), .ENAPSDO (0), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
                         .NUMWBNK (1), .BITWBNK (0), .NUMWROW (NUMVROW1), .BITWROW (BITVROW1),
                         .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (0), .RSTZERO (1))
                         //.SRAM_DELAY (SRAM_DELAY), .FLOPCMD (0), .FLOPMEM (FLOPMEM), .FLOPOUT (0), .RSTZERO (1))
        infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
               .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
               .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr (mem_rd_derr_wire), .rd_padr (mem_rd_padr_wire),
               .mem_write (t4_writeA_wire[t4r]), .mem_wr_adr(t4_addrA_wire[t4r]), .mem_bw (t4_bwA_wire[t4r]), .mem_din (t4_dinA_wire[t4r]),
               .mem_read (t4_readB_wire[t4r]), .mem_rd_adr(t4_addrB_wire[t4r]), .mem_rd_dout (t4_doutB_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_vrow_a1));
    end
  end
endgenerate

reg [2-1:0] t4_writeA;
reg [2*BITVROW1-1:0] t4_addrA;
reg [2*MEMWDTH-1:0] t4_bwA;
reg [2*MEMWDTH-1:0] t4_dinA;
reg [2-1:0] t4_readB;
reg [2*BITVROW1-1:0] t4_addrB;

integer t4r_int;
always_comb begin
  t4_writeA = 0;
  t4_addrA = 0;
  t4_bwA = 0;
  t4_dinA = 0;
  t4_readB = 0;
  t4_addrB = 0;
  t4_doutB_a1 = 0;
  t4_fwrdB_a1 = 0;
  t4_serrB_a1 = 0;
  t4_derrB_a1 = 0;
  t4_padrB_a1 = 0;
  for (t4r_int=0; t4r_int<2; t4r_int=t4r_int+1) begin
    t4_writeA = t4_writeA | (t4_writeA_wire[t4r_int] << t4r_int);
    t4_addrA = t4_addrA | (t4_addrA_wire[t4r_int] << (t4r_int*BITVROW1));
    t4_bwA = t4_bwA | (t4_bwA_wire[t4r_int] << (t4r_int*MEMWDTH));
    t4_dinA = t4_dinA | (t4_dinA_wire[t4r_int] << (t4r_int*MEMWDTH));
    t4_readB = t4_readB | (t4_readB_wire[t4r_int] << t4r_int);
    t4_addrB = t4_addrB | (t4_addrB_wire[t4r_int] << (t4r_int*BITVROW1));
    t4_doutB_a1 = t4_doutB_a1 | (t4_doutB_a1_wire[t4r_int] << (t4r_int*WIDTH));
    t4_fwrdB_a1 = t4_fwrdB_a1 | (t4_fwrdB_a1_wire[t4r_int] << t4r_int);
    t4_serrB_a1 = t4_serrB_a1 | (t4_serrB_a1_wire[t4r_int] << t4r_int);
    t4_padrB_a1 = t4_padrB_a1 | (t4_padrB_a1_wire[t4r_int] << (t4r_int*BITPADR2));
  end
end

`ifdef FORMAL
genvar werr_int;
generate for (werr_int=0; werr_int<NUMVBNK1; werr_int=werr_int+1) begin: werr_loop
  assume_wr_rerr_check: assert property (@(posedge clk) disable iff (rst) (ready || a1_loop.algo.ip_top_sva.wrp1_nerr[werr_int]));
  assume_wr_nerr_check: assert property (@(posedge clk) disable iff (rst) a1_loop.algo.ip_top_sva.wrp1_nerr[werr_int] |->
                                         !(a2_loop[werr_int].algo.ip_top_sva.write && (a2_loop[werr_int].algo.ip_top_sva.wr_row == select_vrow_a2) &&
                                           |(~a2_loop[werr_int].algo.ip_top_sva.mem_serr[0])));
  assume_wr_serr_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |->
                                         (a2_loop[werr_int].algo.ip_top_sva.write && (a2_loop[werr_int].algo.ip_top_sva.wr_row == select_vrow_a2 &&
                                          (ENAPAR ? (|a2_loop[werr_int].algo.ip_top_sva.mem_serr[0] || |a2_loop[werr_int].algo.ip_top_sva.mem_derr[0]) :
                                           ENAECC ? (|a2_loop[werr_int].algo.ip_top_sva.mem_derr[0]) : 1'b0))) ==
                                         (ENAPAR ? a1_loop.algo.ip_top_sva.wrp1_serr[werr_int] : ENAECC ? a1_loop.algo.ip_top_sva.wrp1_derr[werr_int] : 1'b0));
end
endgenerate
`endif

endmodule
