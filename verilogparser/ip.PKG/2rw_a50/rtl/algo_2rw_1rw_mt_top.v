
module algo_2rw_1rw_mt_top (clk, rst, ready,
                            refr, read, write, addr, din, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                            t1_readA, t1_writeA, t1_addrA, t1_dwsnA, t1_bwA, t1_dinA, t1_doutA, t1_refrB, t1_bankB,
                            t2_readA, t2_writeA, t2_addrA, t2_dwsnA, t2_bwA, t2_dinA, t2_doutA, t2_refrB, t2_bankB,
                            t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter PARITY = 0;
  parameter MEMWDTH = WIDTH+PARITY;
  parameter NUMRDPT = 0;
  parameter NUMRWPT = 2;
  parameter NUMWRPT = 0;
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
  parameter ECCBITS = 8; 
  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 2;
  parameter FLOPMEM = 0;

  parameter BITPADR2 = BITPBNK2+BITSROW2+BITWRDS2+1;
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

  output [NUMPBNK1*NUMVBNK2-1:0] t1_readA;
  output [NUMPBNK1*NUMVBNK2-1:0] t1_writeA;
  output [NUMPBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrA;
  output [NUMPBNK1*NUMVBNK2*BITDWSN-1:0] t1_dwsnA;
  output [NUMPBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA;
  output [NUMPBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA;
  input [NUMPBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_doutA;
  output [NUMPBNK1*NUMVBNK2-1:0] t1_refrB;
  output [NUMPBNK1*NUMVBNK2*BITRBNK-1:0] t1_bankB;

  output [NUMPBNK1-1:0] t2_readA;
  output [NUMPBNK1-1:0] t2_writeA;
  output [NUMPBNK1*BITSROW2-1:0] t2_addrA;
  output [NUMPBNK1*BITDWSN-1:0] t2_dwsnA;
  output [NUMPBNK1*PHYWDTH2-1:0] t2_bwA;
  output [NUMPBNK1*PHYWDTH2-1:0] t2_dinA;
  input [NUMPBNK1*PHYWDTH2-1:0] t2_doutA;
  output [NUMPBNK1-1:0] t2_refrB;
  output [NUMPBNK1*BITRBNK-1:0] t2_bankB;

  output [(NUMRWPT+NUMWRPT-!NUMRDPT)-1:0] t3_writeA;
  output [(NUMRWPT+NUMWRPT-!NUMRDPT)*BITVROW1-1:0] t3_addrA;
  output [(NUMRWPT+NUMWRPT-!NUMRDPT)*SDOUT_WIDTH-1:0] t3_dinA;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrB;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t3_doutB;

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

wire [2*NUMPBNK1-1:0] t1_readA_a1;
wire [2*NUMPBNK1-1:0] t1_writeA_a1;
wire [2*NUMPBNK1*BITVROW1-1:0] t1_addrA_a1;
wire [2*NUMPBNK1*WIDTH-1:0] t1_dinA_a1;
wire [2*NUMPBNK1-1:0] t1_refrB_a1;
reg [2*NUMPBNK1*WIDTH-1:0] t1_doutA_a1;
reg [2*NUMPBNK1-1:0] t1_serrA_a1;
reg [2*NUMPBNK1-1:0] t1_derrA_a1;
reg [2*NUMPBNK1*BITPADR2-1:0] t1_padrA_a1;

//wire [(NUMRWPT+NUMWRPT)-1:0] t3_writeA_a1;
//wire [(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrA_a1;
//wire [(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t3_dinA_a1;
wire [(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t3_doutB_a1;

//assign t3_writeA = t3_writeA_a1;
//assign t3_addrA = t3_addrA_a1;
//assign t3_dinA = t3_dinA_a1;

wire [NUMPBNK1-1:0] t1_a2_ready;

generate if (1) begin: a1_loop

algo_mrnrwpw_1rw_mt_a50 #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMRDPT (NUMRDPT), .NUMRWPT (NUMRWPT), .NUMWRPT (NUMWRPT),
                          .NUMVBNK(NUMVBNK1), .BITVBNK(BITVBNK1), .NUMVROW(NUMVROW1), .BITVROW(BITVROW1), .NUMPBNK(NUMPBNK1), .BITPBNK(BITPBNK1), .BITPADR(BITPADR1),
                          .REFRESH(REFRESH), .SRAM_DELAY(SRAM_DELAY+FLOPMEM), .DRAM_DELAY(DRAM_DELAY+FLOPMEM+FLOPIN2+FLOPOUT2),
                          .FLOPIN(FLOPIN1), .FLOPOUT(FLOPOUT1), .ECCBITS(ECCBITS))
  algo (.ready(ready), .clk(clk), .rst (rst || !(&t1_a2_ready)),
        .refr (refr), .read(read),. write(write), .addr(addr), .din(din), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
        .t1_readA(t1_readA_a1), .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
        .t1_doutA(t1_doutA_a1), .t1_serrA(t1_serrA_a1), .t1_derrA(t1_derrA_a1), .t1_padrA(t1_padrA_a1),
        .t1_refrB(t1_refrB_a1),
        .t2_writeA(t3_writeA), .t2_addrA(t3_addrA), .t2_dinA(t3_dinA), .t2_readB(t3_readB), .t2_addrB(t3_addrB), .t2_doutB(t3_doutB_a1),
	.select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

reg [2-1:0] t1_readA_a1_wire [0:NUMPBNK1-1];
reg t1_writeA_a1_wire [0:NUMPBNK1-1];
reg [2*BITVROW1-1:0] t1_radrA_a1_wire [0:NUMPBNK1-1];
reg [BITVROW1-1:0] t1_wadrA_a1_wire [0:NUMPBNK1-1];
reg [WIDTH-1:0] t1_dinA_a1_wire [0:NUMPBNK1-1];
reg t1_refrB_a1_wire [0:NUMPBNK1-1];
wire [2*WIDTH-1:0] t1_doutA_a1_wire [0:NUMPBNK1-1];
wire [2-1:0] t1_serrA_a1_wire [0:NUMPBNK1-1];
wire [2-1:0] t1_derrA_a1_wire [0:NUMPBNK1-1];
wire [2*BITPADR2-1:0] t1_padrA_a1_wire [0:NUMPBNK1-1];
integer a1_wire_int;
always_comb begin
  t1_doutA_a1 = 0;
  t1_serrA_a1 = 0;
  t1_derrA_a1 = 0;
  t1_padrA_a1 = 0;
  for (a1_wire_int=0; a1_wire_int<NUMPBNK1; a1_wire_int=a1_wire_int+1) begin
    t1_readA_a1_wire[a1_wire_int] = t1_readA_a1 >> (a1_wire_int*2);
    t1_writeA_a1_wire[a1_wire_int] = t1_writeA_a1 >> (a1_wire_int*2);
    t1_radrA_a1_wire[a1_wire_int] = t1_addrA_a1 >> (a1_wire_int*2*BITVROW1);
    t1_wadrA_a1_wire[a1_wire_int] = t1_addrA_a1 >> (a1_wire_int*2*BITVROW1);
    t1_dinA_a1_wire[a1_wire_int] = t1_dinA_a1 >> (a1_wire_int*2*WIDTH);
    t1_refrB_a1_wire[a1_wire_int] = t1_refrB_a1 >> (a1_wire_int*2);
    t1_doutA_a1 = t1_doutA_a1 | (t1_doutA_a1_wire[a1_wire_int] << (a1_wire_int*2*WIDTH));
    t1_serrA_a1 = t1_serrA_a1 | (t1_serrA_a1_wire[a1_wire_int] << a1_wire_int*2);
    t1_derrA_a1 = t1_derrA_a1 | (t1_derrA_a1_wire[a1_wire_int] << a1_wire_int*2);
    t1_padrA_a1 = t1_padrA_a1 | (t1_padrA_a1_wire[a1_wire_int] << (a1_wire_int*2*BITPADR2));
  end
end

wire [NUMVBNK2-1:0] t1_readA_a2 [0:NUMPBNK1-1];
wire [NUMVBNK2-1:0] t1_writeA_a2 [0:NUMPBNK1-1];
wire [NUMVBNK2*BITVROW2-1:0] t1_addrA_a2 [0:NUMPBNK1-1];
wire [NUMVBNK2*WIDTH-1:0] t1_dinA_a2 [0:NUMPBNK1-1];
wire [NUMVBNK2-1:0] t1_refrB_a2 [0:NUMPBNK1-1];
reg [NUMVBNK2*WIDTH-1:0] t1_doutA_a2 [0:NUMPBNK1-1];
reg [NUMVBNK2-1:0] t1_serrA_a2 [0:NUMPBNK1-1];
reg [NUMVBNK2-1:0] t1_derrA_a2 [0:NUMPBNK1-1];
reg [NUMVBNK2*(BITSROW2+BITWRDS2)-1:0] t1_padrA_a2 [0:NUMPBNK1-1];

wire [1-1:0] t2_readA_a2 [0:NUMPBNK1-1];
wire [1-1:0] t2_writeA_a2 [0:NUMPBNK1-1];
wire [1*BITVROW2-1:0] t2_addrA_a2 [0:NUMPBNK1-1];
wire [1*WIDTH-1:0] t2_dinA_a2 [0:NUMPBNK1-1];
wire [1-1:0] t2_refrB_a2 [0:NUMPBNK1-1];
reg [1*WIDTH-1:0] t2_doutA_a2 [0:NUMPBNK1-1];
reg [1-1:0] t2_serrA_a2 [0:NUMPBNK1-1];
reg [1-1:0] t2_derrA_a2 [0:NUMPBNK1-1];
reg [1*(BITSROW2+BITWRDS2)-1:0] t2_padrA_a2 [0:NUMPBNK1-1];

genvar a2_int;
generate for (a2_int=0; a2_int<NUMPBNK1; a2_int=a2_int+1) begin: a2_loop

algo_nror1w_a20 #(.WIDTH (WIDTH), .BITWDTH(BITWDTH), .NUMADDR(NUMVROW1), .BITADDR(BITVROW1), .NUMVRPT(2), .NUMPRPT(1),
                  .NUMVROW(NUMVROW2), .BITVROW(BITVROW2), .NUMVBNK(NUMVBNK2), .BITVBNK(BITVBNK2), .BITPBNK(BITPBNK2), .BITPADR(BITPADR2),
                  .REFRESH(REFRESH), .REFFREQ(REFFREQ), .SRAM_DELAY(DRAM_DELAY+FLOPMEM), .FLOPIN (FLOPIN2), .FLOPOUT (FLOPOUT2))
    algo (.refr (t1_refrB_a1_wire[a2_int]), .clk (clk), .rst (rst), .ready (t1_a2_ready[a2_int]),
          .write (t1_writeA_a1_wire[a2_int]), .wr_adr (t1_wadrA_a1_wire[a2_int]), .din (t1_dinA_a1_wire[a2_int]),
          .read (t1_readA_a1_wire[a2_int]), .rd_adr (t1_radrA_a1_wire[a2_int]), .rd_vld (), .rd_dout (t1_doutA_a1_wire[a2_int]),
          .rd_serr (t1_serrA_a1_wire[a2_int]), .rd_derr (t1_derrA_a1_wire[a2_int]), .rd_padr (t1_padrA_a1_wire[a2_int]),
          .t1_readA (t1_readA_a2[a2_int]), .t1_writeA (t1_writeA_a2[a2_int]), .t1_addrA (t1_addrA_a2[a2_int]), .t1_dinA (t1_dinA_a2[a2_int]), .t1_doutA (t1_doutA_a2[a2_int]),
          .t1_serrA (t1_serrA_a2[a2_int]), .t1_derrA (t1_derrA_a2[a2_int]), .t1_padrA (t1_padrA_a2[a2_int]), .t1_refrB (t1_refrB_a2[a2_int]),
          .t2_readA (t2_readA_a2[a2_int]), .t2_writeA (t2_writeA_a2[a2_int]), .t2_addrA (t2_addrA_a2[a2_int]), .t2_dinA (t2_dinA_a2[a2_int]), .t2_doutA (t2_doutA_a2[a2_int]),
          .t2_serrA (t2_serrA_a2[a2_int]), .t2_derrA (t2_derrA_a2[a2_int]), .t2_padrA (t2_padrA_a2[a2_int]), .t2_refrB (t2_refrB_a2[a2_int]),
          .select_addr (select_addr_a2), .select_bit (select_bit));

end
endgenerate

wire [WIDTH-1:0] t1_doutA_a2_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire t1_serrA_a2_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire t1_derrA_a2_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire [BITSROW2+BITWRDS2-1:0] t1_padrA_a2_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire t1_readA_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire t1_writeA_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire [BITSROW2-1:0] t1_addrA_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire [BITDWSN-1:0] t1_dwsnA_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t1_bwA_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t1_dinA_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire t1_refrB_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
wire [BITRBNK-1:0] t1_bankB_wire [0:NUMPBNK1-1][0:NUMVBNK2-1];
genvar t1r, t1b;
generate
  for (t1r=0; t1r<NUMPBNK1; t1r=t1r+1) begin: t1r_loop
    for (t1b=0; t1b<NUMVBNK2; t1b=t1b+1) begin: t1b_loop
      wire t1_readA_a2_wire = t1_readA_a2[t1r] >> t1b;
      wire t1_writeA_a2_wire = t1_writeA_a2[t1r] >> t1b;
      wire [BITVROW2-1:0] t1_addrA_a2_wire = t1_addrA_a2[t1r] >> (t1b*BITVROW2);
      wire [WIDTH-1:0] t1_dinA_a2_wire = t1_dinA_a2[t1r] >> (t1b*WIDTH);
      wire t1_refrB_a2_wire = t1_refrB_a2[t1r] >> t1b;

      wire [NUMWRDS2*MEMWDTH-1:0] t1_doutA_wire = t1_doutA >> ((t1r*NUMVBNK2+t1b)*PHYWDTH2);

      if (1) begin: align_loop
        infra_align_dwsn #(.WIDTH (WIDTH), .PARITY (PARITY), .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                           .NUMSROW (NUMSROW2), .BITSROW (BITSROW2), .NUMWRDS (NUMWRDS2), .BITWRDS (BITWRDS2), .BITPADR (BITSROW2+BITWRDS2),
                           .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                           .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                           .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                           .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                           .SRAM_DELAY (DRAM_DELAY), .FLOPMEM (FLOPMEM), .RSTZERO (1))
          infra (.read (t1_readA_a2_wire), .write (t1_writeA_a2_wire), .addr (t1_addrA_a2_wire), .din (t1_dinA_a2_wire),
                 .dout (t1_doutA_a2_wire[t1r][t1b]), .serr (t1_serrA_a2_wire[t1r][t1b]), .padr (t1_padrA_a2_wire[t1r][t1b]),
                 .mem_read (t1_readA_wire[t1r][t1b]), .mem_write (t1_writeA_wire[t1r][t1b]), .mem_addr (t1_addrA_wire[t1r][t1b]),
                 .mem_dwsn (t1_dwsnA_wire[t1r][t1b]), .mem_bw (t1_bwA_wire[t1r][t1b]), .mem_din (t1_dinA_wire[t1r][t1b]), .mem_dout (t1_doutA_wire),
                 .select_addr (select_vrow_a2),
                 .clk (clk), .rst (rst));
        assign t1_derrA_a2_wire[t1r][t1b] = 1'b0;
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

reg [NUMPBNK1*NUMVBNK2-1:0] t1_readA;
reg [NUMPBNK1*NUMVBNK2-1:0] t1_writeA;
reg [NUMPBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrA;
reg [NUMPBNK1*NUMVBNK2*BITDWSN-1:0] t1_dwsnA;
reg [NUMPBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA;
reg [NUMPBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA;
reg [NUMPBNK1*NUMVBNK2-1:0] t1_refrB;
reg [NUMPBNK1*NUMVBNK2*BITRBNK-1:0] t1_bankB;
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
  for (t1r_int=0; t1r_int<NUMPBNK1; t1r_int=t1r_int+1) begin
    t1_doutA_a2[t1r_int] = 0;
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
      t1_serrA_a2[t1r_int] = t1_serrA_a2[t1r_int] | (t1_serrA_a2_wire[t1r_int][t1b_int] << t1b_int);
      t1_derrA_a2[t1r_int] = t1_derrA_a2[t1r_int] | (t1_derrA_a2_wire[t1r_int][t1b_int] << t1b_int);
      t1_padrA_a2[t1r_int] = t1_padrA_a2[t1r_int] | (t1_padrA_a2_wire[t1r_int][t1b_int] << (t1b_int*(BITSROW2+BITWRDS2)));
    end
  end
end

wire [WIDTH-1:0] t2_doutA_a2_wire [0:NUMPBNK1-1][0:1-1];
wire t2_serrA_a2_wire [0:NUMPBNK1-1][0:1-1];
wire t2_derrA_a2_wire [0:NUMPBNK1-1][0:1-1];
wire [BITSROW2+BITWRDS2-1:0] t2_padrA_a2_wire [0:NUMPBNK1-1][0:1-1];
wire t2_readA_wire [0:NUMPBNK1-1][0:1-1];
wire t2_writeA_wire [0:NUMPBNK1-1][0:1-1];
wire [BITSROW2-1:0] t2_addrA_wire [0:NUMPBNK1-1][0:1-1];
wire [BITDWSN-1:0] t2_dwsnA_wire [0:NUMPBNK1-1][0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t2_bwA_wire [0:NUMPBNK1-1][0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t2_dinA_wire [0:NUMPBNK1-1][0:1-1];
wire t2_refrB_wire [0:NUMPBNK1-1][0:1-1];
wire [BITRBNK-1:0] t2_bankB_wire [0:NUMPBNK1-1][0:1-1];

genvar t2r, t2b;
generate
  for (t2r=0; t2r<NUMPBNK1; t2r=t2r+1) begin: t2r_loop
    for (t2b=0; t2b<1; t2b=t2b+1) begin: t2b_loop
      wire t2_readA_a2_wire = t2_readA_a2[t2r] >> t2b;
      wire t2_writeA_a2_wire = t2_writeA_a2[t2r] >> t2b;
      wire [BITVROW2-1:0] t2_addrA_a2_wire = t2_addrA_a2[t2r] >> (t2b*BITVROW2);
      wire [WIDTH-1:0] t2_dinA_a2_wire = t2_dinA_a2[t2r] >> (t2b*WIDTH);
      wire t2_refrB_a2_wire = t2_refrB_a2[t2r] >> t2b;

      wire [NUMWRDS2*MEMWDTH-1:0] t2_doutA_wire = t2_doutA >> ((t2r*1+t2b)*PHYWDTH2);

      if (1) begin: align_loop
        infra_align_dwsn #(.WIDTH (WIDTH), .PARITY (PARITY), .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                           .NUMSROW (NUMSROW2), .BITSROW (BITSROW2), .NUMWRDS (NUMWRDS2), .BITWRDS (BITWRDS2), .BITPADR (BITSROW2+BITWRDS2),
                           .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                           .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                           .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                           .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                           .SRAM_DELAY (DRAM_DELAY), .FLOPMEM (FLOPMEM), .RSTZERO (1))
          infra (.read (t2_readA_a2_wire), .write (t2_writeA_a2_wire), .addr (t2_addrA_a2_wire), .din (t2_dinA_a2_wire),
                 .dout (t2_doutA_a2_wire[t2r][t2b]), .serr (t2_serrA_a2_wire[t2r][t2b]), .padr (t2_padrA_a2_wire[t2r][t2b]),
                 .mem_read (t2_readA_wire[t2r][t2b]), .mem_write (t2_writeA_wire[t2r][t2b]), .mem_addr (t2_addrA_wire[t2r][t2b]),
                 .mem_dwsn (t2_dwsnA_wire[t2r][t2b]), .mem_bw (t2_bwA_wire[t2r][t2b]), .mem_din (t2_dinA_wire[t2r][t2b]), .mem_dout (t2_doutA_wire),
                 .select_addr (select_vrow_a2),
                 .clk (clk), .rst (rst));
        assign t2_derrA_a2_wire[t2r][t2b] = 1'b0;
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

reg [NUMPBNK1-1:0] t2_readA;
reg [NUMPBNK1-1:0] t2_writeA;
reg [NUMPBNK1*BITSROW2-1:0] t2_addrA;
reg [NUMPBNK1*BITDWSN-1:0] t2_dwsnA;
reg [NUMPBNK1*PHYWDTH2-1:0] t2_bwA;
reg [NUMPBNK1*PHYWDTH2-1:0] t2_dinA;
reg [NUMPBNK1-1:0] t2_refrB;
reg [NUMPBNK1*BITRBNK-1:0] t2_bankB;

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
  for (t2r_int=0; t2r_int<NUMPBNK1; t2r_int=t2r_int+1) begin
    t2_doutA_a2[t2r_int] = 0;
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
      t2_serrA_a2[t2r_int] = t2_serrA_a2[t2r_int] | (t2_serrA_a2_wire[t2r_int][t2b_int] << t2b_int);
      t2_derrA_a2[t2r_int] = t2_derrA_a2[t2r_int] | (t2_derrA_a2_wire[t2r_int][t2b_int] << t2b_int);
      t2_padrA_a2[t2r_int] = t2_padrA_a2[t2r_int] | (t2_padrA_a2_wire[t2r_int][t2b_int] << (t2b_int*(BITSROW2+BITWRDS2)));
    end
  end
end

generate if (FLOPMEM) begin: t3_flp_loop
  reg [(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t3_doutB_reg;
  always @(posedge clk) begin
    t3_doutB_reg <= t3_doutB;
  end

  assign t3_doutB_a1 = t3_doutB_reg;
end else begin: t3_noflp_loop
  assign t3_doutB_a1 = t3_doutB;
end
endgenerate

endmodule
