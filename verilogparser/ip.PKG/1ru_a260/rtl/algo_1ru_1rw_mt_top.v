
module algo_1ru_1rw_mt_top (clk, rst, ready,
                            refr, read, write, addr, din, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                            t1_readA, t1_writeA, t1_addrA, t1_dwsnA, t1_bwA, t1_dinA, t1_doutA, t1_refrB, t1_bankB,
                            t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_readB, t2_addrB, t2_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAEXT = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter NUMRUPT = 1;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;  // ALGO1 Parameters
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMPBNK = 11;
  parameter BITPBNK = 4;
  parameter NUMWRDS = 4;     // ALIGN Parameters
  parameter BITWRDS = 2;
  parameter NUMSROW = 64;
  parameter BITSROW = 6;
  parameter BITPROW = BITSROW;
  parameter MEMWDTH = ENAEXT ? NUMWRDS*WIDTH : ENAPAR ? NUMWRDS*WIDTH+1 : ENAECC ? NUMWRDS*WIDTH+ECCWDTH : NUMWRDS*WIDTH;
  parameter PHYWDTH = MEMWDTH;
  parameter FLOPIN = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;
  parameter FLOPOUT = 0;

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
  parameter DISCORR = 0;
  parameter ECCBITS = 8;
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;

  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter BITMAPT = BITPBNK*NUMVBNK;
  parameter SDOUT_WIDTH = 2*BITMAPT+ECCBITS;

  input                                            refr;

  input [NUMRUPT-1:0]                              read;
  input [NUMRUPT-1:0]                              write;
  input [NUMRUPT*BITADDR-1:0]                      addr;
  input [NUMRUPT*WIDTH-1:0]                        din;
  output [NUMRUPT-1:0]                             rd_vld;
  output [NUMRUPT*WIDTH-1:0]                       rd_dout;
  output [NUMRUPT-1:0]                             rd_serr;
  output [NUMRUPT-1:0]                             rd_derr;
  output [NUMRUPT*BITPADR-1:0]                     rd_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMRUPT*NUMPBNK-1:0] t1_readA;
  output [NUMRUPT*NUMPBNK-1:0] t1_writeA;
  output [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_addrA;
  output [NUMRUPT*NUMPBNK*BITDWSN-1:0] t1_dwsnA;
  output [NUMRUPT*NUMPBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMPBNK*PHYWDTH-1:0] t1_dinA;
  input [NUMRUPT*NUMPBNK*PHYWDTH-1:0] t1_doutA;
  output [NUMRUPT*NUMPBNK-1:0] t1_refrB;
  output [NUMRUPT*NUMPBNK*BITRBNK-1:0] t1_bankB;

  output [NUMRUPT-1:0] t2_writeA;
  output [NUMRUPT*BITSROW-1:0] t2_addrA;
  output [NUMRUPT*SDOUT_WIDTH-1:0] t2_bwA;
  output [NUMRUPT*SDOUT_WIDTH-1:0] t2_dinA;
  output [NUMRUPT-1:0] t2_readB;
  output [NUMRUPT*BITSROW-1:0] t2_addrB;
  input [NUMRUPT*SDOUT_WIDTH-1:0] t2_doutB;

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
  adr_inst (.vbadr(), .vradr(select_vrow), .vaddr(select_addr));

wire [BITVROW-1:0] select_srow;
np2_addr #(
  .NUMADDR (NUMVROW), .BITADDR (BITVROW),
  .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
  .NUMVROW (NUMSROW), .BITVROW (BITSROW))
  wadr_inst (.vbadr(), .vradr(select_srow), .vaddr(select_vrow));
  
`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITVROW-1:0] select_vrow = 0;
wire [BITSROW-1:0] select_srow = 0;
wire [BITRBNK-1:0] select_rbnk = 0;
wire [BITRROW-1:0] select_rrow = 0;
`endif

wire [NUMRUPT*NUMPBNK-1:0] t1_readA_a1;
wire [NUMRUPT*NUMPBNK-1:0] t1_writeA_a1;
wire [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_addrA_a1;
wire [NUMRUPT*NUMPBNK*NUMWRDS*WIDTH-1:0] t1_dinA_a1;
wire [NUMRUPT*NUMPBNK-1:0] t1_refrB_a1;
reg [NUMRUPT*NUMPBNK*NUMWRDS*WIDTH-1:0] t1_doutA_a1;
reg [NUMRUPT*NUMPBNK-1:0] t1_fwrdA_a1;
reg [NUMRUPT*NUMPBNK-1:0] t1_serrA_a1;
reg [NUMRUPT*NUMPBNK-1:0] t1_derrA_a1;
reg [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_padrA_a1;

wire [NUMRUPT-1:0] t2_writeA_a1;
wire [NUMRUPT*BITSROW-1:0] t2_addrA_a1;
wire [NUMRUPT*BITMAPT-1:0] t2_dinA_a1;
wire [NUMRUPT-1:0] t2_readB_a1;
wire [NUMRUPT*BITSROW-1:0] t2_addrB_a1;
wire [NUMRUPT*BITMAPT-1:0] t2_doutB_a1;
wire [NUMRUPT-1:0] t2_fwrdB_a1;
wire [NUMRUPT-1:0] t2_serrB_a1;
wire [NUMRUPT-1:0] t2_derrB_a1;
wire [NUMRUPT*BITSROW-1:0] t2_padrB_a1;

generate if (1) begin: a1_loop

  algo_nru_1rw_mt #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAEXT(ENAEXT), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ECCWDTH(ECCWDTH), .NUMRUPT(NUMRUPT),
                    .NUMADDR(NUMADDR), .BITADDR(BITADDR),
                    .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMPBNK(NUMPBNK), .BITPBNK(BITPBNK), .BITPADR(BITPADR-1),
                    .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS), .NUMSROW(NUMSROW), .BITSROW(BITSROW),
                    .REFRESH(REFRESH), .REFFREQ(REFFREQ),
                    .SRAM_DELAY(SRAM_DELAY+FLOPMEM), .DRAM_DELAY(DRAM_DELAY+FLOPMEM), .FLOPIN (FLOPIN), .FLOPPWR(0), .FLOPOUT(FLOPOUT))
    algo (.ready(ready), .clk(clk), .rst (rst),
          .refr (refr), .read(read),. write(write), .addr(addr), .din(din), .rd_vld(rd_vld), .rd_dout(rd_dout),
          .rd_fwrd(rd_padr[BITPADR-1]), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr[BITPADR-2:0]),
          .t1_readA(t1_readA_a1), .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1), .t1_doutA(t1_doutA_a1),
          .t1_fwrdA(t1_fwrdA_a1), .t1_serrA(t1_serrA_a1), .t1_derrA(t1_derrA_a1), .t1_padrA(t1_padrA_a1),
          .t1_refrB(t1_refrB_a1),
          .t2_writeA(t2_writeA_a1), .t2_addrA(t2_addrA_a1), .t2_dinA(t2_dinA_a1), .t2_readB(t2_readB_a1), .t2_addrB(t2_addrB_a1), .t2_doutB(t2_doutB_a1),
          .select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

wire [NUMWRDS*WIDTH-1:0] t1_doutA_a1_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire t1_fwrdA_a1_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire t1_serrA_a1_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire t1_derrA_a1_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire [BITSROW-1:0] t1_padrA_a1_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire t1_readA_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire t1_writeA_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire [BITSROW-1:0] t1_addrA_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire [BITDWSN-1:0] t1_dwsnA_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire [NUMWRDS*WIDTH-1:0] t1_bwA_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire [NUMWRDS*WIDTH-1:0] t1_dinA_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire t1_refrB_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire [BITRBNK-1:0] t1_bankB_wire [0:NUMRUPT-1][0:NUMPBNK-1];

genvar t1r, t1b;
generate
  for (t1r=0; t1r<NUMRUPT; t1r=t1r+1) begin: t1r_loop
    for (t1b=0; t1b<NUMPBNK; t1b=t1b+1) begin: t1b_loop

      wire t1_readA_a1_wire = t1_readA_a1 >> (t1r*NUMPBNK+t1b);
      wire t1_writeA_a1_wire = t1_writeA_a1 >> (t1r*NUMPBNK+t1b);
      wire [BITSROW-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> ((t1r*NUMPBNK+t1b)*BITSROW);
      wire [NUMWRDS*WIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> ((t1r*NUMPBNK+t1b)*NUMWRDS*WIDTH);
      wire t1_refrB_a1_wire = t1_refrB_a1 >> (t1r*NUMPBNK+t1b);

      wire [NUMWRDS*WIDTH-1:0] t1_doutA_wire = t1_doutA >> ((t1r*NUMPBNK+t1b)*PHYWDTH);

      if (1) begin: align_loop
        infra_align_ecc_dwsn #(.WIDTH (NUMWRDS*WIDTH), .ENAEXT (ENAEXT), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                               .NUMADDR (NUMSROW), .BITADDR (BITSROW),
                               .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITSROW),
                               .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                               .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                               .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                               .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                               .SRAM_DELAY (DRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC))
          infra (.read(t1_readA_a1_wire), .write(t1_writeA_a1_wire), .addr(t1_addrA_a1_wire), .din(t1_dinA_a1_wire), .rd_dout(t1_doutA_a1_wire[t1r][t1b]),
                 .rd_fwrd(t1_fwrdA_a1_wire[t1r][t1b]), .rd_serr(t1_serrA_a1_wire[t1r][t1b]), .rd_derr(t1_derrA_a1_wire[t1r][t1b]), .rd_padr(t1_padrA_a1_wire[t1r][t1b]),
                 .mem_read (t1_readA_wire[t1r][t1b]), .mem_write (t1_writeA_wire[t1r][t1b]), .mem_addr (t1_addrA_wire[t1r][t1b]),
                 .mem_dwsn (t1_dwsnA_wire[t1r][t1b]), .mem_bw (t1_bwA_wire[t1r][t1b]), .mem_din (t1_dinA_wire[t1r][t1b]), .mem_dout (t1_doutA_wire), .mem_serr(),
                 .select_addr (select_srow),
                 .clk (clk), .rst (rst));
      end

      wire [BITRBNK-1:0] t1_bankA_wire = t1_addrA_wire[t1r][t1b] >> (BITPROW-BITRBNK-BITWSPF);

      if (REFRESH==1) begin: refr_loop
        infra_refr_1stage #(.NUMRBNK (NUMRBNK), .BITRBNK (BITRBNK), .REFLOPW (REFLOPW),
                            .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
          infra (.clk (clk), .rst (rst),
                 .pref (t1_refrB_a1_wire), .pacc (t1_readA_wire[t1r][t1b] || t1_writeA_wire[t1r][t1b]), .pacbadr (t1_bankA_wire),
                 .prefr (t1_refrB_wire[t1r][t1b]), .prfbadr (t1_bankB_wire[t1r][t1b]),
                 .select_rbnk (select_rbnk), .select_rrow (select_rrow));
      end else begin: no_refr_loop
        assign t1_refrB_wire[t1r][t1b] = 1'b0;
        assign t1_bankB_wire[t1r][t1b] = 0;
      end
    end
  end
endgenerate

reg [NUMRUPT*NUMPBNK-1:0] t1_readA;
reg [NUMRUPT*NUMPBNK-1:0] t1_writeA;
reg [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_addrA;
reg [NUMRUPT*NUMPBNK*BITDWSN-1:0] t1_dwsnA;
reg [NUMRUPT*NUMPBNK*PHYWDTH-1:0] t1_bwA;
reg [NUMRUPT*NUMPBNK*PHYWDTH-1:0] t1_dinA;
reg [NUMRUPT*NUMPBNK-1:0] t1_refrB;
reg [NUMRUPT*NUMPBNK*BITRBNK-1:0] t1_bankB;
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
  for (t1r_int=0; t1r_int<NUMRUPT; t1r_int=t1r_int+1) begin
    for (t1b_int=0; t1b_int<NUMPBNK; t1b_int=t1b_int+1) begin
      t1_readA = t1_readA | (t1_readA_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*BITSROW));
      t1_dwsnA = t1_dwsnA | (t1_dwsnA_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*BITDWSN));
      t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*PHYWDTH));
      t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*PHYWDTH));
      t1_doutA_a1 = t1_doutA_a1 | (t1_doutA_a1_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*NUMWRDS*WIDTH));
      t1_fwrdA_a1 = t1_fwrdA_a1 | (t1_fwrdA_a1_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_serrA_a1 = t1_serrA_a1 | (t1_serrA_a1_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_derrA_a1 = t1_serrA_a1 | (t1_derrA_a1_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_padrA_a1 = t1_padrA_a1 | (t1_padrA_a1_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*BITSROW));
      t1_refrB = t1_refrB | (t1_refrB_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_bankB = t1_bankB | (t1_bankB_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*BITRBNK));
    end
  end
end

generate if (1) begin: t2_loop
  wire [NUMRUPT-1:0] mem_write_wire;
  wire [NUMRUPT*BITSROW-1:0] mem_wr_adr_wire;
  wire [NUMRUPT*SDOUT_WIDTH-1:0] mem_bw_wire;
  wire [NUMRUPT*SDOUT_WIDTH-1:0] mem_din_wire;
  wire [NUMRUPT-1:0] mem_read_wire;
  wire [NUMRUPT*BITSROW-1:0] mem_rd_adr_wire;
  wire [NUMRUPT*SDOUT_WIDTH-1:0] mem_rd_dout_wire;
  wire [NUMRUPT-1:0] mem_rd_fwrd_wire;
  wire [NUMRUPT-1:0] mem_rd_serr_wire;
  wire [NUMRUPT-1:0] mem_rd_derr_wire;
  wire [NUMRUPT*BITSROW-1:0] mem_rd_padr_wire;

  if (1) begin: align_loop
    infra_align_ecc_mrnw #(.WIDTH (BITMAPT), .ENAPSDO (1), .ENADEC (1), .ECCWDTH (ECCBITS),
                           .NUMRDPT (NUMRUPT), .NUMWRPT (NUMRUPT), .NUMADDR (NUMSROW), .BITADDR (BITSROW),
                           .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITSROW),
                           .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .ENAPADR (1))
      infra (.write(t2_writeA_a1), .wr_adr(t2_addrA_a1), .din(t2_dinA_a1), .read(t2_readB_a1), .rd_adr(t2_addrB_a1),
             .rd_vld(), .rd_dout(t2_doutB_a1), .rd_fwrd(t2_fwrdB_a1), .rd_serr(t2_serrB_a1), .rd_derr(t2_derrB_a1), .rd_padr(t2_padrB_a1),
             .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
             .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
             .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
             .clk (clk), .rst (rst),
             .select_addr (select_srow));
  end

  if (1) begin: stack_loop
    infra_stack_mrnw #(.WIDTH (SDOUT_WIDTH), .ENAPSDO (0), .NUMRDPT (NUMRUPT), .NUMWRPT (NUMRUPT),
                       .NUMADDR (NUMSROW), .BITADDR (BITSROW),
                       .NUMWBNK (1), .BITWBNK (0), .NUMWROW (NUMSROW), .BITWROW (BITSROW), .BITPADR (BITSROW),
                       .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (0), .FLOPMEM (FLOPMEM), .FLOPOUT (0))
      infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
             .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
             .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr (mem_rd_derr_wire), .rd_padr (mem_rd_padr_wire),
             .mem_write (t2_writeA), .mem_wr_adr(t2_addrA), .mem_bw (t2_bwA), .mem_din (t2_dinA),
             .mem_read (t2_readB), .mem_rd_adr(t2_addrB), .mem_rd_dout (t2_doutB),
             .clk (clk), .rst (rst),
             .select_addr (select_srow));
  end
end
endgenerate

`ifdef FORMAL

generate if (REFRESH) begin: refr_loop
  assert_refr_check: assert property (@(posedge clk) disable iff (!ready) !refr |-> ##[1:REFFREQ-1] refr);
  assert_refr_half_check: assert property (@(posedge clk) disable iff (!ready) refr ##(REFFREQ+REFFRHF) refr |-> ##REFFREQ (!REFFRHF || refr));
  assert_refr_noacc_check: assume property (@(posedge clk) disable iff (!ready) !(refr && (write || |read)));
end
endgenerate

`endif

endmodule
