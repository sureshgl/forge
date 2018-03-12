
module algo_1r1w_rl2_a322_top (clk, rst, ready,
                               write, wr_adr, din,
                               read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
	                       t1_readA, t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_doutA,
	                       t2_writeA, t2_addrA, t2_readB, t2_addrB, t2_dinA, t2_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;   // ALGO Parameters
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter NUMWRDS = 4;      // ALIGN Parameters
  parameter BITWRDS = 2;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter NUMWBNK = 1;
  parameter BITWBNK = 0;
  parameter NUMWROW = NUMVROW;
  parameter BITWROW = BITVROW;

  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;
  parameter FLOPOUT = 0;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;
  parameter ECCBITS = 4;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input                                read;
  input [BITADDR-1:0]                  rd_adr;
  output                               rd_vld;
  output                               rd_serr;
  output                               rd_derr;
  output [WIDTH-1:0]                   rd_dout;
  output [BITPADR-1:0]                 rd_padr;

  output                               ready;
  input                                clk, rst;

  output [NUMVBNK-1:0] t1_readA;
  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input [NUMVBNK*PHYWDTH-1:0] t1_doutA;

  output [2-1:0] t2_writeA;
  output [2*BITVROW-1:0] t2_addrA;
  output [2*(SDOUT_WIDTH+MEMWDTH)-1:0] t2_dinA;
  output [2-1:0] t2_readB;
  output [2*BITVROW-1:0] t2_addrB;
  input [2*(SDOUT_WIDTH+MEMWDTH)-1:0] t2_doutB;

`ifdef FORMAL
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

wire [BITVROW-1:0] select_vrow;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  row_adr (.vbadr(), .vradr(select_vrow), .vaddr(select_addr));

`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITVROW-1:0] select_vrow = 0;
`endif

wire [1-1:0] t1_writeA_a1;
wire [1*BITVBNK-1:0] t1_bankA_a1;
wire [1*BITVROW-1:0] t1_addrA_a1;
wire [1*WIDTH-1:0] t1_dinA_a1;
wire [1-1:0] t1_readB_a1;
wire [1*BITVBNK-1:0] t1_bankB_a1;
wire [1*BITVROW-1:0] t1_addrB_a1;
reg [1*WIDTH-1:0] t1_doutB_a1;
reg [1-1:0] t1_fwrdB_a1;
reg [1-1:0] t1_serrB_a1;
reg [1-1:0] t1_derrB_a1;
reg [1*(BITSROW+BITWRDS)-1:0] t1_padrB_a1;

wire [2-1:0] t2_writeA_a1;
wire [2*BITVROW-1:0] t2_addrA_a1;
wire [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA_a1;
wire [2-1:0] t2_readB_a1;
wire [2*BITVROW-1:0] t2_addrB_a1;
reg [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB_a1;
reg [2-1:0] t2_fwrdB_a1;
reg [2-1:0] t2_serrB_a1;
reg [2-1:0] t2_derrB_a1;
reg [2*(BITSROW+BITWRDS)-1:0] t2_padrB_a1;

generate if (1) begin: a1_loop
  
  algo_1r1w_rl2_pseudo #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                         .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR-1),
                         .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .DRAM_DELAY (DRAM_DELAY+FLOPMEM), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT), .ECCBITS (ECCBITS))
    algo (.clk(clk), .rst(rst), .ready(ready), .refr (1'b0),
          .write(write), .wr_adr(wr_adr), .din(din),
          .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout),
          .rd_fwrd(rd_padr[BITPADR-1]), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr[BITPADR-2:0]),
          .t1_writeA(t1_writeA_a1), .t1_bankA(t1_bankA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
          .t1_readB(t1_readB_a1), .t1_bankB(t1_bankB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1),
          .t1_fwrdB(t1_fwrdB_a1), .t1_serrB(t1_serrB_a1), .t1_derrB(t1_derrB_a1), .t1_padrB(t1_padrB_a1),
          .t1_refrC(),
          .t2_writeA(t2_writeA_a1), .t2_addrA(t2_addrA_a1), .t2_dinA(t2_dinA_a1), .t2_readB(t2_readB_a1), .t2_addrB(t2_addrB_a1), .t2_doutB(t2_doutB_a1),
          .t2_fwrdB(t2_fwrdB_a1), .t2_serrB(t2_serrB_a1), .t2_derrB(t2_derrB_a1), .t2_padrB(t2_padrB_a1),
          .select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

wire t1_writeA_wire;
wire [BITVBNK-1:0] t1_bankA_wire;
wire [BITSROW-1:0] t1_addrA_wire;
wire [NUMWRDS*MEMWDTH-1:0] t1_bwA_wire;
wire [NUMWRDS*MEMWDTH-1:0] t1_dinA_wire;
wire t1_readB_wire;
wire [BITVBNK-1:0] t1_bankB_wire;
wire [BITSROW-1:0] t1_addrB_wire;

generate if (1) begin: t1_loop
  reg [BITVBNK-1:0] t1_bankB_reg [0:DRAM_DELAY-1];
  integer dout_int;
  always @(posedge clk)
    for (dout_int=0; dout_int<DRAM_DELAY; dout_int=dout_int+1)
      if (dout_int>0)
        t1_bankB_reg[dout_int] <= t1_bankB_reg[dout_int-1];
      else
        t1_bankB_reg[dout_int] <= t1_bankB_wire;

  wire [NUMWRDS*MEMWDTH-1:0] t1_doutB_wire = t1_doutA >> (t1_bankB_reg[DRAM_DELAY-1]*PHYWDTH);

  if (1) begin: align_loop
    infra_align_ecc_pseudo #(.WIDTH (WIDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                             .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                             .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITSROW),
                             .SRAM_DELAY (DRAM_DELAY), .FLOPGEN (0), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC))
        infra (.write(t1_writeA_a1), .wr_bnk(t1_bankA_a1), .wr_adr(t1_addrA_a1), .din(t1_dinA_a1),
               .read(t1_readB_a1), .rd_bnk(t1_bankB_a1), .rd_adr(t1_addrB_a1), .rd_dout(t1_doutB_a1),
               .rd_fwrd(t1_fwrdB_a1), .rd_serr(t1_serrB_a1), .rd_derr(t1_derrB_a1), .rd_padr (t1_padrB_a1),
               .mem_write(t1_writeA_wire), .mem_wr_bnk(t1_bankA_wire), .mem_wr_adr(t1_addrA_wire),
               .mem_wr_dwsn(), .mem_bw(t1_bwA_wire), .mem_din(t1_dinA_wire),
               .mem_read (t1_readB_wire), .mem_rd_bnk(t1_bankB_wire), .mem_rd_adr(t1_addrB_wire), .mem_rd_dwsn(),
               .mem_rd_dout(t1_doutB_wire), .mem_rd_fwrd(1'b0), .mem_rd_padr(),
               .clk (clk), .rst (rst),
	       .select_vrow (select_vrow));
  end
end
endgenerate

reg [NUMVBNK-1:0] t1_readA;
reg [NUMVBNK-1:0] t1_writeA;
reg [NUMVBNK*BITSROW-1:0] t1_addrA;
reg [NUMVBNK*PHYWDTH-1:0] t1_bwA;
reg [NUMVBNK*PHYWDTH-1:0] t1_dinA;
always_comb begin
  t1_readA = 0;
  t1_writeA = 0;
  t1_addrA = 0;
  if (t1_readB_wire) begin
    t1_readA = t1_readB_wire << t1_bankB_wire;
    t1_addrA = t1_addrB_wire << (t1_bankB_wire*BITSROW);
  end
  if (t1_writeA_wire) begin
    t1_writeA = t1_writeA_wire << t1_bankA_wire;
    t1_addrA = t1_addrA | (t1_addrA_wire << (t1_bankA_wire*BITSROW));
  end
  t1_bwA = {NUMVBNK{t1_bwA_wire}};
  t1_dinA = {NUMVBNK{t1_dinA_wire}};
end

wire [SDOUT_WIDTH+WIDTH-1:0] t2_doutB_a1_wire [0:2-1];
wire t2_fwrdB_a1_wire [0:2-1];
wire t2_serrB_a1_wire [0:2-1];
wire t2_derrB_a1_wire [0:2-1];
wire [BITWROW+BITWBNK-1:0] t2_padrB_a1_wire [0:2-1];
wire [NUMWBNK-1:0] t2_writeA_wire [0:2-1];
wire [NUMWBNK*BITWROW-1:0] t2_addrA_wire [0:2-1];
wire [NUMWBNK*(SDOUT_WIDTH+MEMWDTH)-1:0] t2_dinA_wire [0:2-1];
wire [NUMWBNK-1:0] t2_readB_wire [0:2-1];
wire [NUMWBNK*BITWROW-1:0] t2_addrB_wire [0:2-1];

genvar t2;
generate for (t2=0; t2<2; t2=t2+1) begin: t2_loop
  wire t2_writeA_a1_wire = t2_writeA_a1 >> t2;
  wire [BITVROW-1:0] t2_addrA_a1_wire = t2_addrA_a1 >> (t2*BITVROW);
  wire [(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA_a1_wire = t2_dinA_a1 >> (t2*(SDOUT_WIDTH+WIDTH));
  wire [SDOUT_WIDTH-1:0] t2_sdinA_a1_wire = t2_dinA_a1_wire >> WIDTH;
  wire [WIDTH-1:0] t2_ddinA_a1_wire = t2_dinA_a1_wire;

  wire t2_readB_a1_wire = t2_readB_a1 >> t2;
  wire [BITVROW-1:0] t2_addrB_a1_wire = t2_addrB_a1 >> (t2*BITVROW);

  wire [NUMWBNK*(SDOUT_WIDTH+MEMWDTH)-1:0] t2_doutB_wire = t2_doutB >> (t2*NUMWBNK*(SDOUT_WIDTH+MEMWDTH));

  wire mem_write_wire;
  wire [BITVROW-1:0] mem_wr_adr_wire;
  wire [SDOUT_WIDTH+MEMWDTH-1:0] mem_bw_wire;
  wire [SDOUT_WIDTH+MEMWDTH-1:0] mem_din_wire;
  wire mem_read_wire;
  wire [BITVROW-1:0] mem_rd_adr_wire;
  wire [SDOUT_WIDTH+MEMWDTH-1:0] mem_rd_dout_wire;
  wire mem_rd_fwrd_wire;
  wire mem_rd_serr_wire;
  wire mem_rd_derr_wire;
  wire [(BITWBNK+BITWROW)-1:0] mem_rd_padr_wire;

  if (1) begin: align_s_loop
    infra_align_ecc_1r1w #(.WIDTH (SDOUT_WIDTH), .ENAPSDO (1), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                           .NUMSROW (NUMVROW), .BITSROW (BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITWBNK+BITWROW),
                           .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .ENAPADR (1), .RSTZERO (1))
      infra (.write (t2_writeA_a1_wire), .wr_adr (t2_addrA_a1_wire), .din (t2_sdinA_a1_wire),
             .read (t2_readB_a1_wire), .rd_adr (t2_addrB_a1_wire), .rd_dout (t2_doutB_a1_wire[t2][SDOUT_WIDTH+WIDTH-1:WIDTH]),
             .rd_fwrd (), .rd_serr(), .rd_derr(), .rd_padr(),
             .mem_write (), .mem_wr_adr(), .mem_bw (mem_bw_wire[SDOUT_WIDTH+MEMWDTH-1:MEMWDTH]), .mem_din (mem_din_wire[SDOUT_WIDTH+MEMWDTH-1:MEMWDTH]),
             .mem_read (), .mem_rd_adr(), .mem_rd_dout (mem_rd_dout_wire[SDOUT_WIDTH+MEMWDTH-1:MEMWDTH]),
             .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
             .clk (clk), .rst (rst),
             .select_addr (select_vrow));
  end

  if (1) begin: align_d_loop
    infra_align_ecc_1r1w #(.WIDTH (WIDTH), .ENAPSDO (1), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                           .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                           .NUMSROW (NUMVROW), .BITSROW (BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITWBNK+BITWROW),
                           .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .ENAPADR (1), .RSTZERO (1))
      infra (.write (t2_writeA_a1_wire), .wr_adr (t2_addrA_a1_wire), .din (t2_ddinA_a1_wire),
             .read (t2_readB_a1_wire), .rd_adr (t2_addrB_a1_wire), .rd_dout (t2_doutB_a1_wire[t2][WIDTH-1:0]),
             .rd_fwrd (t2_fwrdB_a1_wire[t2]), .rd_serr(t2_serrB_a1_wire[t2]), .rd_derr(t2_derrB_a1_wire[t2]), .rd_padr(t2_padrB_a1_wire[t2]),
             .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire[MEMWDTH-1:0]), .mem_din (mem_din_wire[MEMWDTH-1:0]),
             .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire[MEMWDTH-1:0]),
             .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
             .clk (clk), .rst (rst),
             .select_addr (select_vrow));
  end

  if (1) begin: stack_loop
    infra_stack_1r1w #(.WIDTH (SDOUT_WIDTH+MEMWDTH), .ENAPSDO (0), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                       .NUMWROW (NUMWROW), .BITWROW (BITWROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                       .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1))
      infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
             .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
             .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr(mem_rd_derr_wire), .rd_padr(mem_rd_padr_wire),
             .mem_write (t2_writeA_wire[t2]), .mem_wr_adr (t2_addrA_wire[t2]), .mem_bw(), .mem_din (t2_dinA_wire[t2]),
             .mem_read (t2_readB_wire[t2]), .mem_rd_adr (t2_addrB_wire[t2]), .mem_rd_dout (t2_doutB_wire),
             .clk (clk), .rst(rst),
             .select_addr (select_vrow));
  end
end
endgenerate

reg [2*NUMWBNK-1:0] t2_writeA;
reg [2*NUMWBNK*BITWROW-1:0] t2_addrA;
reg [2*NUMWBNK*(SDOUT_WIDTH+MEMWDTH)-1:0] t2_dinA;
reg [2*NUMWBNK-1:0] t2_readB;
reg [2*NUMWBNK*BITWROW-1:0] t2_addrB;

integer t2_out_int;
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
  t2_padrB_a1 = 0;
  for (t2_out_int=0; t2_out_int<2; t2_out_int=t2_out_int+1) begin
    t2_writeA = t2_writeA | (t2_writeA_wire[t2_out_int] << t2_out_int*NUMWBNK);
    t2_addrA = t2_addrA | (t2_addrA_wire[t2_out_int] << (t2_out_int*NUMWBNK*BITWROW));
    t2_dinA = t2_dinA | (t2_dinA_wire[t2_out_int] << (t2_out_int*NUMWBNK*(SDOUT_WIDTH+MEMWDTH)));
    t2_readB = t2_readB | (t2_readB_wire[t2_out_int] << t2_out_int*NUMWBNK);
    t2_addrB = t2_addrB | (t2_addrB_wire[t2_out_int] << (t2_out_int*NUMWBNK*BITWROW));
    t2_doutB_a1 = t2_doutB_a1 | (t2_doutB_a1_wire[t2_out_int] << (t2_out_int*(SDOUT_WIDTH+WIDTH)));
    t2_fwrdB_a1 = t2_fwrdB_a1 | (t2_fwrdB_a1_wire[t2_out_int] << t2_out_int);
    t2_serrB_a1 = t2_serrB_a1 | (t2_serrB_a1_wire[t2_out_int] << t2_out_int);
    t2_derrB_a1 = t2_derrB_a1 | (t2_derrB_a1_wire[t2_out_int] << t2_out_int);
    t2_padrB_a1 = t2_padrB_a1 | (t2_padrB_a1_wire[t2_out_int] << (t2_out_int*(BITSROW+BITWRDS)));
  end
end

endmodule
