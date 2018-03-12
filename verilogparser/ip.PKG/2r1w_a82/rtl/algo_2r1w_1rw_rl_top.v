
module algo_2r1w_1rw_rl_top (clk, rst, ready,
                             refr, read, write, addr, din, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                             t1_readA, t1_writeA, t1_addrA, t1_dwsnA, t1_bwA, t1_dinA, t1_doutA, t1_refrB, t1_bankB,
                             t2_readA, t2_writeA, t2_addrA, t2_dwsnA, t2_bwA, t2_dinA, t2_doutA, t2_refrB, t2_bankB,
                             t3_writeA, t3_addrA, t3_bwA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
                             t4_writeA, t4_addrA, t4_bwA, t4_dinA, t4_readB, t4_addrB, t4_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAEXT = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter NUMRDPT = 2;
  parameter NUMRWPT = 0;
  parameter NUMWRPT = 1;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW1 = 1024;  // ALGO1 Parameters
  parameter BITVROW1 = 10;
  parameter NUMVBNK1 = 8;
  parameter BITVBNK1 = 3;
  parameter BITPBNK1 = 4;
  parameter FLOPIN1 = 0;
  parameter FLOPOUT1 = 0;
  parameter NUMWRDS1 = 1;     // ALIGN Parameters
  parameter BITWRDS1 = 0;
  parameter NUMSROW1 = 1024;
  parameter BITSROW1 = 10;
  parameter PHYWDTH1 = NUMWRDS1*MEMWDTH;
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
  parameter ECCBITS = 4;
  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 2;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;

  parameter BITPADR2 = BITPBNK2+BITSROW2+BITWRDS2;
  parameter BITPADR1 = BITPBNK1+BITPADR2+1;

  parameter SDOUT_WIDTH = 2*(BITVBNK1+1)+ECCBITS;
  parameter NUMCASH = NUMRDPT+NUMRWPT+NUMWRPT-1;

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

  output [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
  output [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrA;
  output [NUMVBNK1*NUMVBNK2*BITDWSN-1:0] t1_dwsnA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_doutA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_refrB;
  output [NUMVBNK1*NUMVBNK2*BITRBNK-1:0] t1_bankB;

  output [NUMVBNK1-1:0] t2_readA;
  output [NUMVBNK1-1:0] t2_writeA;
  output [NUMVBNK1*BITSROW2-1:0] t2_addrA;
  output [NUMVBNK1*BITDWSN-1:0] t2_dwsnA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_bwA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_dinA;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_doutA;
  output [NUMVBNK1-1:0] t2_refrB;
  output [NUMVBNK1*BITRBNK-1:0] t2_bankB;

  output [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t3_writeA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*BITSROW1-1:0] t3_addrA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] t3_bwA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] t3_dinA;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1-1:0] t3_addrB;
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] t3_doutB;

  output [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t4_writeA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*BITSROW1-1:0] t4_addrA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*PHYWDTH1-1:0] t4_bwA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*PHYWDTH1-1:0] t4_dinA;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t4_readB;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1-1:0] t4_addrB;
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*PHYWDTH1-1:0] t4_doutB;

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

wire [NUMRDPT+NUMRWPT+NUMWRPT-1:0] rd_fwrd_int;
wire [(NUMRDPT+NUMRWPT+NUMWRPT)*(BITPADR1-1)-1:0] rd_padr_int;
reg [BITPADR1-2:0] rd_padr_tmp [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR1-1:0] rd_padr;
integer padr_int;
always_comb begin
  rd_padr = 0;
  for (padr_int=0; padr_int<NUMRDPT+NUMRWPT+NUMWRPT; padr_int=padr_int+1) begin
    rd_padr_tmp[padr_int] = rd_padr_int << (padr_int*(BITPADR1-1));
    rd_padr = rd_padr | ({rd_fwrd_int[padr_int],rd_padr_tmp[padr_int]} << (padr_int*BITPADR1));
  end
end

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

wire [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t3_writeA_a1;
wire [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrA_a1;
wire [NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t3_dinA_a1;
wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB_a1;
wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t3_doutB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_fwrdB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_serrB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_derrB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR2-1:0] t3_padrB_a1;

wire [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t4_writeA_a1;
wire [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t4_addrA_a1;
wire [NUMCASH*(NUMRWPT+NUMWRPT)*WIDTH-1:0] t4_dinA_a1;
wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t4_readB_a1;
wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t4_addrB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] t4_doutB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t4_fwrdB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t4_serrB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t4_derrB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR2-1:0] t4_padrB_a1;

wire [NUMVBNK1-1:0] t1_a2_ready;

generate if (1) begin: a1_loop

algo_mrnrwpw_1rw_rl #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAPSDO (0), .NUMRDPT (NUMRDPT), .NUMRWPT (NUMRWPT), .NUMWRPT (NUMWRPT),
                      .NUMADDR(NUMADDR), .BITADDR(BITADDR),
                      .NUMVBNK(NUMVBNK1), .BITVBNK(BITVBNK1), .NUMVROW(NUMVROW1), .BITVROW(BITVROW1), .BITPBNK(BITPBNK1), .BITPADR(BITPADR1-1),
                      .REFRESH(REFRESH), .SRAM_DELAY(SRAM_DELAY+FLOPMEM), .DRAM_DELAY(DRAM_DELAY+FLOPMEM+FLOPIN2+FLOPOUT2),
                      .FLOPIN(FLOPIN1), .FLOPOUT(FLOPOUT1), .ECCBITS(ECCBITS))
  algo (.ready(ready), .clk(clk), .rst (rst || !(&t1_a2_ready)),
        .refr (refr), .read(read),. write(write), .addr(addr), .din(din), .rd_vld(rd_vld), .rd_dout(rd_dout),
        .rd_fwrd(rd_fwrd_int), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr_int),
        .t1_readA(t1_readA_a1), .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1), .t1_doutA(t1_doutA_a1),
        .t1_fwrdA(t1_fwrdA_a1), .t1_serrA(t1_serrA_a1), .t1_derrA(t1_derrA_a1), .t1_padrA(t1_padrA_a1),
        .t1_refrB(t1_refrB_a1),
        .t2_writeA(t3_writeA_a1), .t2_addrA(t3_addrA_a1), .t2_dinA(t3_dinA_a1), .t2_readB(t3_readB_a1), .t2_addrB(t3_addrB_a1),
        .t2_doutB(t3_doutB_a1), .t2_fwrdB(t3_fwrdB_a1), .t2_serrB(t3_serrB_a1), .t2_derrB(t3_derrB_a1), .t2_padrB(t3_padrB_a1),
        .t3_writeA(t4_writeA_a1), .t3_addrA(t4_addrA_a1), .t3_dinA(t4_dinA_a1), .t3_readB(t4_readB_a1), .t3_addrB(t4_addrB_a1),
        .t3_doutB(t4_doutB_a1), .t3_fwrdB(t4_fwrdB_a1), .t3_serrB(t4_serrB_a1), .t3_derrB(t4_derrB_a1), .t3_padrB(t4_padrB_a1),
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
    t1_wadrA_a1_wire[a1_wire_int] = t1_addrA_a1 >> (a1_wire_int*2*BITVROW1);
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
reg [NUMVBNK2*WIDTH-1:0] t1_doutA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2-1:0] t1_fwrdA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2-1:0] t1_serrA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2-1:0] t1_derrA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2*(BITSROW2+BITWRDS2)-1:0] t1_padrA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2-1:0] t1_refrB_a2 [0:NUMVBNK1-1];

wire [1-1:0] t2_readA_a2 [0:NUMVBNK1-1];
wire [1-1:0] t2_writeA_a2 [0:NUMVBNK1-1];
wire [1*BITVROW2-1:0] t2_addrA_a2 [0:NUMVBNK1-1];
wire [1*WIDTH-1:0] t2_dinA_a2 [0:NUMVBNK1-1];
reg [1*WIDTH-1:0] t2_doutA_a2 [0:NUMVBNK1-1];
reg [1-1:0] t2_fwrdA_a2 [0:NUMVBNK1-1];
reg [1-1:0] t2_serrA_a2 [0:NUMVBNK1-1];
reg [1-1:0] t2_derrA_a2 [0:NUMVBNK1-1];
reg [1*(BITSROW2+BITWRDS2)-1:0] t2_padrA_a2 [0:NUMVBNK1-1];
wire [1-1:0] t2_refrB_a2 [0:NUMVBNK1-1];

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

      if (1) begin: align_loop
        infra_align_ecc_dwsn #(.WIDTH (WIDTH), .ENAEXT (ENAEXT), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                               .NUMSROW (NUMSROW2), .BITSROW (BITSROW2), .NUMWRDS (NUMWRDS2), .BITWRDS (BITWRDS2), .BITPADR (BITSROW2+BITWRDS2),
                               .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                               .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                               .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                               .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                               .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC), .RSTZERO (1))
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
                               .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC), .RSTZERO (1))
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

wire [(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t3_doutB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_fwrdB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_serrB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_derrB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR2-1:0] t3_padrB_a1_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)-1:0] t3_writeA_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)*BITSROW1-1:0] t3_addrA_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] t3_bwA_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] t3_dinA_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1-1:0] t3_addrB_wire [0:NUMCASH-1];

genvar t3c;
generate
  for (t3c=0; t3c<NUMCASH; t3c=t3c+1) begin: t3c_loop
    wire [(NUMRWPT+NUMWRPT)-1:0] t3_writeA_a1_wire = t3_writeA_a1 >> (t3c*(NUMRWPT+NUMWRPT));
    wire [(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrA_a1_wire = t3_addrA_a1 >> (t3c*(NUMRWPT+NUMWRPT)*BITVROW1);
    wire [(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t3_dinA_a1_wire = t3_dinA_a1 >> (t3c*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH);
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB_a1_wire = t3_readB_a1 >> (t3c*(NUMRDPT+NUMRWPT+NUMWRPT));
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrB_a1_wire = t3_addrB_a1 >> (t3c*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1);

    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] t3_doutB_wire = t3_doutB >> (t3c*(NUMRDPT+NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH);

    wire [(NUMRWPT+NUMWRPT)-1:0] mem_write_t3c_wire;
    wire [(NUMRWPT+NUMWRPT)*BITSROW1-1:0] mem_wr_adr_t3c_wire;
    wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] mem_bw_t3c_wire;
    wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] mem_din_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_read_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1-1:0] mem_rd_adr_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] mem_rd_dout_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_rd_fwrd_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_rd_serr_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_rd_derr_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR2-1:0] mem_rd_padr_t3c_wire;

    if (1) begin: align_loop
      infra_align_ecc_mrnw #(.WIDTH (SDOUT_WIDTH), .ENAPSDO (NUMWRDS1==1), .ENAPAR (0), .ENAECC (0), .ECCWDTH (ECCWDTH),
                             .NUMRDPT (NUMRDPT+NUMRWPT+NUMWRPT), .NUMWRPT (NUMRWPT+NUMWRPT), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
                             .NUMSROW (NUMSROW1), .BITSROW (BITSROW1), .NUMWRDS (NUMWRDS1), .BITWRDS (BITWRDS1), .BITPADR (BITPADR2),
                             .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .ENAPADR (1), .RSTZERO (1))
        infra (.write(t3_writeA_a1_wire), .wr_adr(t3_addrA_a1_wire), .din(t3_dinA_a1_wire),
               .read(t3_readB_a1_wire), .rd_adr(t3_addrB_a1_wire),
               .rd_vld(), .rd_dout(t3_doutB_a1_wire[t3c]), .rd_fwrd(t3_fwrdB_a1_wire[t3c]),
               .rd_serr(t3_serrB_a1_wire[t3c]), .rd_derr(t3_derrB_a1_wire[t3c]), .rd_padr(t3_padrB_a1_wire[t3c]),
               .mem_write (mem_write_t3c_wire), .mem_wr_adr(mem_wr_adr_t3c_wire), .mem_bw (mem_bw_t3c_wire), .mem_din (mem_din_t3c_wire),
               .mem_read (mem_read_t3c_wire), .mem_rd_adr(mem_rd_adr_t3c_wire), .mem_rd_dout (mem_rd_dout_t3c_wire),
               .mem_rd_fwrd(mem_rd_fwrd_t3c_wire), .mem_rd_padr(mem_rd_padr_t3c_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_addr_a2));
    end
    if (1) begin: stack_loop
      infra_stack_mrnw #(.WIDTH (NUMWRDS1*SDOUT_WIDTH), .ENAPSDO (NUMWRDS1>1), .NUMRDPT (NUMRDPT+NUMRWPT+NUMWRPT), .NUMWRPT (NUMRWPT+NUMWRPT),
                         .NUMADDR (NUMSROW1), .BITADDR (BITSROW1),
                         .NUMWBNK (1), .BITWBNK (0), .NUMWROW (NUMSROW1), .BITWROW (BITSROW1), .BITPADR (BITPADR2),
                         .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (0), .FLOPMEM (FLOPMEM), .FLOPOUT (0), .RSTZERO (1))
        infra (.write (mem_write_t3c_wire), .wr_adr (mem_wr_adr_t3c_wire), .bw (mem_bw_t3c_wire), .din (mem_din_t3c_wire),
               .read (mem_read_t3c_wire), .rd_adr (mem_rd_adr_t3c_wire), .rd_dout (mem_rd_dout_t3c_wire),
               .rd_fwrd (mem_rd_fwrd_t3c_wire), .rd_serr (mem_rd_serr_t3c_wire), .rd_derr (mem_rd_derr_t3c_wire), .rd_padr (mem_rd_padr_t3c_wire),
               .mem_write (t3_writeA_wire[t3c]), .mem_wr_adr(t3_addrA_wire[t3c]), .mem_bw (t3_bwA_wire[t3c]), .mem_din (t3_dinA_wire[t3c]),
               .mem_read (t3_readB_wire[t3c]), .mem_rd_adr(t3_addrB_wire[t3c]), .mem_rd_dout (t3_doutB_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_addr_a2));
    end
  end
endgenerate

reg [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t3_writeA;
reg [NUMCASH*(NUMRWPT+NUMWRPT)*BITSROW1-1:0] t3_addrA;
reg [NUMCASH*(NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] t3_bwA;
reg [NUMCASH*(NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] t3_dinA;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1-1:0] t3_addrB;

integer t3c_int;
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
  for (t3c_int=0; t3c_int<NUMCASH; t3c_int=t3c_int+1) begin
    t3_writeA = t3_writeA | (t3_writeA_wire[t3c_int] << (t3c_int*(NUMRWPT+NUMWRPT)));
    t3_addrA = t3_addrA | (t3_addrA_wire[t3c_int] << (t3c_int*(NUMRWPT+NUMWRPT)*BITSROW1));
    t3_bwA = t3_bwA | (t3_bwA_wire[t3c_int] << (t3c_int*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH));
    t3_dinA = t3_dinA | (t3_dinA_wire[t3c_int] << (t3c_int*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH));
    t3_readB = t3_readB | (t3_readB_wire[t3c_int] << (t3c_int*(NUMRDPT+NUMRWPT+NUMWRPT)));
    t3_addrB = t3_addrB | (t3_addrB_wire[t3c_int] << (t3c_int*(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1));
    t3_doutB_a1 = t3_doutB_a1 | (t3_doutB_a1_wire[t3c_int] << (t3c_int*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH));
    t3_fwrdB_a1 = t3_fwrdB_a1 | (t3_fwrdB_a1_wire[t3c_int] << (t3c_int*(NUMRDPT+NUMRWPT+NUMWRPT)));
    t3_serrB_a1 = t3_serrB_a1 | (t3_serrB_a1_wire[t3c_int] << (t3c_int*(NUMRDPT+NUMRWPT+NUMWRPT)));
    t3_padrB_a1 = t3_padrB_a1 | (t3_padrB_a1_wire[t3c_int] << (t3c_int*(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR2));
  end
end

wire [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] t4_doutB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t4_fwrdB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t4_serrB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t4_derrB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR2-1:0] t4_padrB_a1_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)-1:0] t4_writeA_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)*BITSROW1-1:0] t4_addrA_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*MEMWDTH-1:0] t4_bwA_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*MEMWDTH-1:0] t4_dinA_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t4_readB_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1-1:0] t4_addrB_wire [0:NUMCASH-1];

genvar t4c;
generate
  for (t4c=0; t4c<NUMCASH; t4c=t4c+1) begin: t4c_loop
    wire [(NUMRWPT+NUMWRPT)-1:0] t4_writeA_a1_wire = t4_writeA_a1 >> (t4c*(NUMRWPT+NUMWRPT));
    wire [(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t4_addrA_a1_wire = t4_addrA_a1 >> (t4c*(NUMRWPT+NUMWRPT)*BITVROW1);
    wire [(NUMRWPT+NUMWRPT)*WIDTH-1:0] t4_dinA_a1_wire = t4_dinA_a1 >> (t4c*(NUMRWPT+NUMWRPT)*WIDTH);
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t4_readB_a1_wire = t4_readB_a1 >> (t4c*(NUMRDPT+NUMRWPT+NUMWRPT));
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t4_addrB_a1_wire = t4_addrB_a1 >> (t4c*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1);

    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*NUMWRDS1*MEMWDTH-1:0] t4_doutB_wire = t4_doutB >> (t4c*(NUMRDPT+NUMRWPT+NUMWRPT)*PHYWDTH1);

    wire [(NUMRWPT+NUMWRPT)-1:0] mem_write_t4c_wire;
    wire [(NUMRWPT+NUMWRPT)*BITSROW1-1:0] mem_wr_adr_t4c_wire;
    wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*MEMWDTH-1:0] mem_bw_t4c_wire;
    wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*MEMWDTH-1:0] mem_din_t4c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_read_t4c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1-1:0] mem_rd_adr_t4c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*NUMWRDS1*MEMWDTH-1:0] mem_rd_dout_t4c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_rd_fwrd_t4c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_rd_serr_t4c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_rd_derr_t4c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR2-1:0] mem_rd_padr_t4c_wire;

    if (1) begin: align_loop
      infra_align_ecc_mrnw #(.WIDTH (WIDTH), .ENAPSDO (NUMWRDS1==1), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                             .NUMRDPT (NUMRDPT+NUMRWPT+NUMWRPT), .NUMWRPT (NUMRWPT+NUMWRPT), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
                             .NUMSROW (NUMSROW1), .BITSROW (BITSROW1), .NUMWRDS (NUMWRDS1), .BITWRDS (BITWRDS1), .BITPADR (BITPADR2),
                             .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .RSTZERO (1), .ENAPADR (1))
        infra (.write(t4_writeA_a1_wire), .wr_adr(t4_addrA_a1_wire), .din(t4_dinA_a1_wire),
               .read(t4_readB_a1_wire), .rd_adr(t4_addrB_a1_wire),
               .rd_vld(), .rd_dout(t4_doutB_a1_wire[t4c]), .rd_fwrd(t4_fwrdB_a1_wire[t4c]),
               .rd_serr(t4_serrB_a1_wire[t4c]), .rd_derr(t4_derrB_a1_wire[t4c]), .rd_padr(t4_padrB_a1_wire[t4c]),
               .mem_write (mem_write_t4c_wire), .mem_wr_adr(mem_wr_adr_t4c_wire), .mem_bw (mem_bw_t4c_wire), .mem_din (mem_din_t4c_wire),
               .mem_read (mem_read_t4c_wire), .mem_rd_adr(mem_rd_adr_t4c_wire), .mem_rd_dout (mem_rd_dout_t4c_wire),
               .mem_rd_fwrd(mem_rd_fwrd_t4c_wire), .mem_rd_padr(mem_rd_padr_t4c_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_addr_a2));
    end
    if (1) begin: stack_loop
      infra_stack_mrnw #(.WIDTH (NUMWRDS1*MEMWDTH), .ENAPSDO (NUMWRDS1>1), .NUMRDPT (NUMRDPT+NUMRWPT+NUMWRPT), .NUMWRPT (NUMRWPT+NUMWRPT),
                         .NUMADDR (NUMSROW1), .BITADDR (BITSROW1),
                         .NUMWBNK (1), .BITWBNK (0), .NUMWROW (NUMSROW1), .BITWROW (BITSROW1), .BITPADR (BITPADR2),
                         .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (0), .FLOPMEM (FLOPMEM), .FLOPOUT (0), .RSTZERO (1))
        infra (.write (mem_write_t4c_wire), .wr_adr (mem_wr_adr_t4c_wire), .bw (mem_bw_t4c_wire), .din (mem_din_t4c_wire),
               .read (mem_read_t4c_wire), .rd_adr (mem_rd_adr_t4c_wire), .rd_dout (mem_rd_dout_t4c_wire),
               .rd_fwrd (mem_rd_fwrd_t4c_wire), .rd_serr (mem_rd_serr_t4c_wire), .rd_derr (mem_rd_derr_t4c_wire), .rd_padr (mem_rd_padr_t4c_wire),
               .mem_write (t4_writeA_wire[t4c]), .mem_wr_adr(t4_addrA_wire[t4c]), .mem_bw (t4_bwA_wire[t4c]), .mem_din (t4_dinA_wire[t4c]),
               .mem_read (t4_readB_wire[t4c]), .mem_rd_adr(t4_addrB_wire[t4c]), .mem_rd_dout (t4_doutB_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_addr_a2));
    end
  end
endgenerate

reg [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t4_writeA;
reg [NUMCASH*(NUMRWPT+NUMWRPT)*BITSROW1-1:0] t4_addrA;
reg [NUMCASH*(NUMRWPT+NUMWRPT)*NUMWRDS1*MEMWDTH-1:0] t4_bwA;
reg [NUMCASH*(NUMRWPT+NUMWRPT)*NUMWRDS1*MEMWDTH-1:0] t4_dinA;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t4_readB;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1-1:0] t4_addrB;

integer t4c_int;
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
  for (t4c_int=0; t4c_int<NUMCASH; t4c_int=t4c_int+1) begin
    t4_writeA = t4_writeA | (t4_writeA_wire[t4c_int] << (t4c_int*(NUMRWPT+NUMWRPT)));
    t4_addrA = t4_addrA | (t4_addrA_wire[t4c_int] << (t4c_int*(NUMRWPT+NUMWRPT)*BITSROW1));
    t4_bwA = t4_bwA | (t4_bwA_wire[t4c_int] << (t4c_int*(NUMRWPT+NUMWRPT)*PHYWDTH1));
    t4_dinA = t4_dinA | (t4_dinA_wire[t4c_int] << (t4c_int*(NUMRWPT+NUMWRPT)*PHYWDTH1));
    t4_readB = t4_readB | (t4_readB_wire[t4c_int] << (t4c_int*(NUMRDPT+NUMRWPT+NUMWRPT)));
    t4_addrB = t4_addrB | (t4_addrB_wire[t4c_int] << (t4c_int*(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1));
    t4_doutB_a1 = t4_doutB_a1 | (t4_doutB_a1_wire[t4c_int] << (t4c_int*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH));
    t4_fwrdB_a1 = t4_fwrdB_a1 | (t4_fwrdB_a1_wire[t4c_int] << (t4c_int*(NUMRDPT+NUMRWPT+NUMWRPT)));
    t4_serrB_a1 = t4_serrB_a1 | (t4_serrB_a1_wire[t4c_int] << (t4c_int*(NUMRDPT+NUMRWPT+NUMWRPT)));
    t4_padrB_a1 = t4_padrB_a1 | (t4_padrB_a1_wire[t4c_int] << (t4c_int*(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR2));
  end
end

endmodule
