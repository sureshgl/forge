
module algo_1r2m_1rw_fl_top (clk, rst, ready,
                             refr, write, wr_adr, din, wr_bp,
                             read, rd_deq, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                             t1_readA, t1_writeA, t1_addrA, t1_dwsnA, t1_bwA, t1_dinA, t1_doutA, t1_refrB, t1_bankB,
                             t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAEXT = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter NUMRDPT = 1;
  parameter NUMWRPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;  // ALGO1 Parameters
  parameter BITVROW = 10;
  parameter BITPROW = BITVROW;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter FLOPIN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;
  parameter FLOPOUT = 0;
  parameter NUMWRDS = 4;     // ALIGN Parameters
  parameter BITWRDS = 2;
  parameter NUMSROW = 64;
  parameter BITSROW = 6;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;
  parameter REFRESH = 0;      // REFRESH Parameters 
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
  parameter ECCBITS = 5;
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;

  parameter BITPADR = BITVBNK+BITSROW+BITWRDS+1;
//  parameter SDOUT_WIDTH = BITVROW+ECCBITS;
  parameter SDOUT_WIDTH = BITVROW;
  parameter NUMWBNK = 1;
  parameter BITWBNK = 0;
  parameter NUMWROW = NUMVROW;
  parameter BITWROW = BITVROW;

  input                          refr;

  input [NUMWRPT-1:0]            write;
  output [NUMWRPT*BITADDR-1:0]   wr_adr;
  input [NUMWRPT*WIDTH-1:0]      din;
  output                         wr_bp;

  input [NUMRDPT-1:0]            read;
  input [NUMRDPT-1:0]            rd_deq;
  input [NUMRDPT*BITADDR-1:0]    rd_adr;
  output [NUMRDPT-1:0]           rd_vld;
  output [NUMRDPT*WIDTH-1:0]     rd_dout;
  output [NUMRDPT-1:0]           rd_serr;
  output [NUMRDPT-1:0]           rd_derr;
  output [NUMRDPT*BITPADR-1:0]   rd_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMRDPT*NUMVBNK-1:0] t1_readA;
  output [NUMRDPT*NUMVBNK-1:0] t1_writeA;
  output [NUMRDPT*NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMRDPT*NUMVBNK*BITDWSN-1:0] t1_dwsnA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_doutA;
  output [NUMRDPT*NUMVBNK-1:0] t1_refrB;
  output [NUMRDPT*NUMVBNK*BITRBNK-1:0] t1_bankB;

  output [NUMRDPT*NUMVBNK-1:0] t2_writeA;
  output [NUMRDPT*NUMVBNK*BITVROW-1:0] t2_addrA;
  output [NUMRDPT*NUMVBNK*SDOUT_WIDTH-1:0] t2_dinA;
  output [NUMRDPT*NUMVBNK-1:0] t2_readB;
  output [NUMRDPT*NUMVBNK*BITVROW-1:0] t2_addrB;
  input [NUMRDPT*NUMVBNK*SDOUT_WIDTH-1:0] t2_doutB;

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

wire [BITVROW-1:0] select_vrow;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  adr_a2 (.vbadr(), .vradr(select_vrow), .vaddr(select_addr));
  
`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITVROW-1:0] select_vrow = 0;
wire [BITRBNK-1:0] select_rbnk = 0;
wire [BITRROW-1:0] select_rrow = 0;
`endif

wire [NUMRDPT-1:0] rd_fwrd_int;
wire [NUMRDPT*(BITPADR-1)-1:0] rd_padr_int;
reg [BITPADR-2:0] rd_padr_tmp [0:NUMRDPT-1];
reg [NUMRDPT*BITPADR-1:0] rd_padr;
integer padr_int;
always_comb begin
  rd_padr = 0;
  for (padr_int=0; padr_int<NUMRDPT; padr_int=padr_int+1) begin
    rd_padr_tmp[padr_int] = rd_padr_int << (padr_int*(BITPADR-1));
    rd_padr = rd_padr | ({rd_fwrd_int[padr_int],rd_padr_tmp[padr_int]} << (padr_int*BITPADR));
  end
end

wire [NUMRDPT*NUMVBNK-1:0] t1_readA_a1;
wire [NUMRDPT*NUMVBNK-1:0] t1_writeA_a1;
wire [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrA_a1;
wire [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_dinA_a1;
wire [NUMRDPT*NUMVBNK-1:0] t1_refrB_a1;
reg [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_doutA_a1;
reg [NUMRDPT*NUMVBNK-1:0] t1_fwrdA_a1;
reg [NUMRDPT*NUMVBNK-1:0] t1_serrA_a1;
reg [NUMRDPT*NUMVBNK-1:0] t1_derrA_a1;
reg [NUMRDPT*NUMVBNK*(BITPADR-BITVBNK-1)-1:0] t1_padrA_a1;

wire [NUMRDPT*NUMVBNK-1:0] t2_writeA_a1;
wire [NUMRDPT*NUMVBNK*BITVROW-1:0] t2_addrA_a1;
wire [NUMRDPT*NUMVBNK*BITVROW-1:0] t2_dinA_a1;
wire [NUMRDPT*NUMVBNK-1:0] t2_readB_a1;
wire [NUMRDPT*NUMVBNK*BITVROW-1:0] t2_addrB_a1;
reg [NUMRDPT*NUMVBNK*BITVROW-1:0] t2_doutB_a1;
reg [NUMRDPT*NUMVBNK-1:0] t2_fwrdB_a1;
reg [NUMRDPT*NUMVBNK-1:0] t2_serrB_a1;
reg [NUMRDPT*NUMVBNK-1:0] t2_derrB_a1;
reg [NUMRDPT*NUMVBNK*BITVROW-1:0] t2_padrB_a1;

generate if (1) begin: a1_loop
  algo_mrnwa_1rw_fl #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAEXT(ENAEXT), .ENAPAR(ENAPAR), .ENAECC(ENAECC),
                      .NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMRDPT (NUMRDPT), .NUMWRPT (NUMWRPT),
                      .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .NUMVROW(NUMVROW), .BITVROW(BITVROW), .BITPADR(BITPADR-1),
                      .REFRESH(REFRESH), .REFFREQ(REFFREQ), .SRAM_DELAY(SRAM_DELAY+FLOPMEM), .DRAM_DELAY(DRAM_DELAY+FLOPMEM), .FLOPIN (FLOPIN), .FLOPOUT(FLOPOUT))
    algo (.ready(ready), .clk(clk), .rst (rst),
          .refr (refr), .write(write), .wr_adr(wr_adr), .din(din), .wr_bp(wr_bp),
          .read(read), .rd_deq(rd_deq), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout),
          .rd_fwrd(rd_fwrd_int), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr_int),
          .t1_readA(t1_readA_a1), .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
          .t1_doutA(t1_doutA_a1), .t1_fwrdA(t1_fwrdA_a1), .t1_serrA(t1_serrA_a1), .t1_derrA(t1_derrA_a1), .t1_padrA(t1_padrA_a1),
          .t1_refrB(t1_refrB_a1),
          .t2_writeA(t2_writeA_a1), .t2_addrA(t2_addrA_a1), .t2_dinA(t2_dinA_a1), .t2_readB(t2_readB_a1), .t2_addrB(t2_addrB_a1), .t2_doutB(t2_doutB_a1),
  	  .select_addr (select_addr), .select_bit (select_bit));
end
endgenerate

wire [WIDTH-1:0] t1_doutA_a1_wire [0:NUMRDPT-1][0:NUMVBNK-1]; 
wire t1_fwrdA_a1_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire t1_serrA_a1_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire t1_derrA_a1_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [BITSROW+BITWRDS-1:0] t1_padrA_a1_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire t1_readA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire t1_writeA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [BITSROW-1:0] t1_addrA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [BITDWSN-1:0] t1_dwsnA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_bwA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_dinA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire t1_refrB_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [BITRBNK-1:0] t1_bankB_wire [0:NUMRDPT-1][0:NUMVBNK-1];
genvar t1r, t1b;
generate
  for (t1r=0; t1r<NUMRDPT; t1r=t1r+1) begin: t1r_loop
    for (t1b=0; t1b<NUMVBNK; t1b=t1b+1) begin: t1b_loop
      wire t1_readA_a1_wire = t1_readA_a1 >> (t1r*NUMVBNK+t1b);
      wire t1_writeA_a1_wire = t1_writeA_a1 >> (t1r*NUMVBNK+t1b);
      wire [BITVROW-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> ((t1r*NUMVBNK+t1b)*BITVROW);
      wire [WIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> ((t1r*NUMVBNK+t1b)*WIDTH);
      wire t1_refrB_a1_wire = t1_refrB_a1 >> (t1r*NUMVBNK+t1b);

      wire [NUMWRDS*MEMWDTH-1:0] t1_doutA_wire = t1_doutA >> ((t1r*NUMVBNK+t1b)*PHYWDTH);

      if (1) begin: align_loop
        infra_align_ecc_dwsn #(.WIDTH (WIDTH), .ENAEXT (ENAEXT), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                               .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITSROW+BITWRDS),
                               .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                               .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                               .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                               .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                               .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC))
          infra (.read (t1_readA_a1_wire), .write (t1_writeA_a1_wire), .addr (t1_addrA_a1_wire), .din (t1_dinA_a1_wire), .rd_dout (t1_doutA_a1_wire[t1r][t1b]),
                 .rd_fwrd (t1_fwrdA_a1_wire[t1r][t1b]), .rd_serr (t1_serrA_a1_wire[t1r][t1b]), .rd_derr (t1_derrA_a1_wire[t1r][t1b]), .rd_padr (t1_padrA_a1_wire[t1r][t1b]),
                 .mem_read (t1_readA_wire[t1r][t1b]), .mem_write (t1_writeA_wire[t1r][t1b]), .mem_addr (t1_addrA_wire[t1r][t1b]),
                 .mem_dwsn (t1_dwsnA_wire[t1r][t1b]), .mem_bw (t1_bwA_wire[t1r][t1b]), .mem_din (t1_dinA_wire[t1r][t1b]), .mem_dout (t1_doutA_wire), .mem_serr(),
                 .select_addr (select_vrow),
                 .clk (clk), .rst (rst));
      end

      wire [BITRBNK-1:0] t1_bankA_a1_wire = t1_addrA_wire[t1r][t1b] >> (BITSROW-BITRBNK-BITWSPF);

      if (REFRESH==1) begin: refr_loop
        infra_refr_1stage #(.NUMRBNK (NUMRBNK), .BITRBNK (BITRBNK), .REFLOPW (REFLOPW),
                            .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
          infra (.clk (clk), .rst (rst),
                 .pref (t1_refrB_a1_wire), .pacc (t1_readA_a1_wire || t1_writeA_a1_wire), .pacbadr (t1_bankA_a1_wire),
                 .prefr (t1_refrB_wire[t1r][t1b]), .prfbadr (t1_bankB_wire[t1r][t1b]),
                 .select_rbnk (select_rbnk), .select_rrow (select_rrow));
      end else begin: no_refr_loop
        assign t1_refrB_wire[t1r][t1b] = 1'b0;
        assign t1_bankB_wire[t1r][t1b] = 0;
      end
    end
  end
endgenerate

reg [NUMRDPT*NUMVBNK-1:0] t1_readA;
reg [NUMRDPT*NUMVBNK-1:0] t1_writeA;
reg [NUMRDPT*NUMVBNK*BITSROW-1:0] t1_addrA;
reg [NUMRDPT*NUMVBNK*BITDWSN-1:0] t1_dwsnA;
reg [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_bwA;
reg [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;
reg [NUMRDPT*NUMVBNK-1:0] t1_refrB;
reg [NUMRDPT*NUMVBNK*BITRBNK-1:0] t1_bankB;
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
  t1_doutA_a1 = 0;
  t1_fwrdA_a1 = 0;
  t1_serrA_a1 = 0;
  t1_derrA_a1 = 0;
  t1_padrA_a1 = 0;
  for (t1r_int=0; t1r_int<NUMRDPT; t1r_int=t1r_int+1) begin
    for (t1b_int=0; t1b_int<NUMVBNK; t1b_int=t1b_int+1) begin
      t1_readA = t1_readA | (t1_readA_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*BITSROW));
      t1_dwsnA = t1_dwsnA | (t1_dwsnA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*BITDWSN));
      t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*PHYWDTH));
      t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*PHYWDTH));
      t1_refrB = t1_refrB | (t1_refrB_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_bankB = t1_bankB | (t1_bankB_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*BITRBNK));
      t1_doutA_a1 = t1_doutA_a1 | (t1_doutA_a1_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*WIDTH));
      t1_fwrdA_a1 = t1_fwrdA_a1 | (t1_fwrdA_a1_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_serrA_a1 = t1_serrA_a1 | (t1_serrA_a1_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_derrA_a1 = t1_derrA_a1 | (t1_derrA_a1_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_padrA_a1 = t1_padrA_a1 | (t1_padrA_a1_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*(BITSROW+BITWRDS)));
    end
  end
end

wire [BITVROW-1:0] t2_doutB_a1_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire t2_fwrdB_a1_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire t2_serrB_a1_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire t2_derrB_a1_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [BITWROW+BITWBNK-1:0] t2_padrB_a1_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [NUMWBNK-1:0] t2_writeA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [NUMWBNK*BITWROW-1:0] t2_addrA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [NUMWBNK*SDOUT_WIDTH-1:0] t2_dinA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [NUMWBNK-1:0] t2_readB_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [NUMWBNK*BITWROW-1:0] t2_addrB_wire [0:NUMRDPT-1][0:NUMVBNK-1];

genvar t2r, t2b;
generate
  for (t2r=0; t2r<NUMRDPT; t2r=t2r+1) begin: t2r_loop
    for (t2b=0; t2b<NUMVBNK; t2b=t2b+1) begin: t2b_loop
      wire t2_writeA_a1_wire = t2_writeA_a1 >> (t2r*NUMVBNK+t2b);
      wire [BITVROW-1:0] t2_addrA_a1_wire = t2_addrA_a1 >> ((t2r*NUMVBNK+t2b)*BITVROW);
      wire [BITVROW-1:0] t2_dinA_a1_wire = t2_dinA_a1 >> ((t2r*NUMVBNK+t2b)*BITVROW);

      wire t2_readB_a1_wire = t2_readB_a1 >> (t2r*NUMVBNK+t2b);
      wire [BITVROW-1:0] t2_addrB_a1_wire = t2_addrB_a1 >> ((t2r*NUMVBNK+t2b)*BITVROW);

      wire [NUMWBNK*SDOUT_WIDTH-1:0] t2_doutB_wire = t2_doutB >> ((t2r*NUMVBNK+t2b)*NUMWBNK*SDOUT_WIDTH);

      wire mem_write_wire;
      wire [BITVROW-1:0] mem_wr_adr_wire;
      wire [SDOUT_WIDTH-1:0] mem_bw_wire;
      wire [SDOUT_WIDTH-1:0] mem_din_wire;
      wire mem_read_wire;
      wire [BITVROW-1:0] mem_rd_adr_wire;
      wire [SDOUT_WIDTH-1:0] mem_rd_dout_wire;
      wire mem_rd_fwrd_wire;
      wire mem_rd_serr_wire;
      wire mem_rd_derr_wire;
      wire [(BITWBNK+BITWROW)-1:0] mem_rd_padr_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH (BITVROW), .ENAPSDO (0), .ENAPAR (0), .ENAECC (0), .ECCWDTH (ECCBITS), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                               .NUMSROW (NUMVROW), .BITSROW (BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITWBNK+BITWROW),
                               .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPGEN (0), .FLOPMEM (0), .ENAPADR (1), .RSTONES (1))
          infra (.write (t2_writeA_a1_wire), .wr_adr (t2_addrA_a1_wire), .din (t2_dinA_a1_wire),
                 .read (t2_readB_a1_wire), .rd_adr (t2_addrB_a1_wire), .rd_dout (t2_doutB_a1_wire[t2r][t2b]),
                 .rd_fwrd (t2_fwrdB_a1_wire[t2r][t2b]), .rd_serr(t2_serrB_a1_wire[t2r][t2b]), .rd_derr(t2_derrB_a1_wire[t2r][t2b]), .rd_padr(t2_padrB_a1_wire[t2r][t2b]),
                 .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
                 .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (SDOUT_WIDTH), .ENAPSDO (0), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                           .NUMWROW (NUMWROW), .BITWROW (BITWROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                           .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
          infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
                 .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
                 .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr(mem_rd_derr_wire), .rd_padr(mem_rd_padr_wire),
                 .mem_write (t2_writeA_wire[t2r][t2b]), .mem_wr_adr (t2_addrA_wire[t2r][t2b]), .mem_bw(), .mem_din (t2_dinA_wire[t2r][t2b]),
                 .mem_read (t2_readB_wire[t2r][t2b]), .mem_rd_adr (t2_addrB_wire[t2r][t2b]), .mem_rd_dout (t2_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_vrow));
      end
    end
  end
endgenerate

reg [NUMRDPT*NUMVBNK-1:0] t2_writeA;
reg [NUMRDPT*NUMVBNK*BITVROW-1:0] t2_addrA;
reg [NUMRDPT*NUMVBNK*SDOUT_WIDTH-1:0] t2_dinA;
reg [NUMRDPT*NUMVBNK-1:0] t2_readB;
reg [NUMRDPT*NUMVBNK*BITVROW-1:0] t2_addrB;
integer t2r_int, t2b_int;
always_comb begin
  t2_writeA = 0;
  t2_addrA = 0;
  t2_dinA = 0;
  t2_readB = 0;
  t2_addrB = 0;
  t2_doutB_a1 = 0;
  t2_fwrdB_a1 = 0;
  t2_serrB_a1 = 0;
  t2_derrB_a1 = 0;
  for (t2r_int=0; t2r_int<NUMRDPT; t2r_int=t2r_int+1) begin
    for (t2b_int=0; t2b_int<NUMVBNK; t2b_int=t2b_int+1) begin
      t2_writeA = t2_writeA | (t2_writeA_wire[t2r_int][t2b_int] << (t2r_int*NUMVBNK+t2b_int));
      t2_addrA = t2_addrA | (t2_addrA_wire[t2r_int][t2b_int] << ((t2r_int*NUMVBNK+t2b_int)*BITVROW));
      t2_dinA = t2_dinA | (t2_dinA_wire[t2r_int][t2b_int] << ((t2r_int*NUMVBNK+t2b_int)*SDOUT_WIDTH));
      t2_readB = t2_readB | (t2_readB_wire[t2r_int][t2b_int] << (t2r_int*NUMVBNK+t2b_int));
      t2_addrB = t2_addrB | (t2_addrB_wire[t2r_int][t2b_int] << ((t2r_int*NUMVBNK+t2b_int)*BITVROW));
      t2_doutB_a1 = t2_doutB_a1 | (t2_doutB_a1_wire[t2r_int][t2b_int] << ((t2r_int*NUMVBNK+t2b_int)*BITVROW));
      t2_fwrdB_a1 = t2_fwrdB_a1 | (t2_fwrdB_a1_wire[t2r_int][t2b_int] << (t2r_int*NUMVBNK+t2b_int));
      t2_serrB_a1 = t2_serrB_a1 | (t2_serrB_a1_wire[t2r_int][t2b_int] << (t2r_int*NUMVBNK+t2b_int));
      t2_derrB_a1 = t2_derrB_a1 | (t2_derrB_a1_wire[t2r_int][t2b_int] << (t2r_int*NUMVBNK+t2b_int));
    end
  end
end

endmodule
