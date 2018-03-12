
module algo_2ru_1r1w_mt_top (clk, rst, ready,
                             read, write, addr, din, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                             t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
                             t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter NUMRUPT = 2;
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
  parameter MEMWDTH = ENAPAR ? NUMWRDS*WIDTH+1 : ENAECC ? NUMWRDS*WIDTH+ECCWDTH : NUMWRDS*WIDTH;
  parameter PHYWDTH = MEMWDTH;
  parameter NUMWROW = NUMSROW; // STACK Parameters
  parameter BITWROW = BITSROW;
  parameter NUMWBNK = 1;
  parameter BITWBNK = 0;
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;
  parameter FLOPOUT = 0;

  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter BITMAPT = BITPBNK*NUMVBNK;

  input [NUMRUPT-1:0]            read;
  input [NUMRUPT-1:0]            write;
  input [NUMRUPT*BITADDR-1:0]    addr;
  input [NUMRUPT*WIDTH-1:0]      din;
  output [NUMRUPT-1:0]           rd_vld;
  output [NUMRUPT*WIDTH-1:0]     rd_dout;
  output [NUMRUPT-1:0]           rd_serr;
  output [NUMRUPT-1:0]           rd_derr;
  output [NUMRUPT*BITPADR-1:0]   rd_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMRUPT*NUMPBNK-1:0] t1_writeA;
  output [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_addrA;
  output [NUMRUPT*NUMPBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMRUPT*NUMPBNK*PHYWDTH-1:0] t1_dinA;
  output [NUMRUPT*NUMPBNK-1:0] t1_readB;
  output [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_addrB;
  input [NUMRUPT*NUMPBNK*PHYWDTH-1:0] t1_doutB;

  output [(NUMRUPT-1)-1:0] t2_writeA;
  output [(NUMRUPT-1)*BITSROW-1:0] t2_addrA;
  output [(NUMRUPT-1)*BITMAPT-1:0] t2_dinA;
  output [NUMRUPT-1:0] t2_readB;
  output [NUMRUPT*BITSROW-1:0] t2_addrB;
  input [NUMRUPT*BITMAPT-1:0] t2_doutB;

`ifdef FORMAL 
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

wire [BITVROW-1:0] select_vrow;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  adr_a2 (.vbadr(), .vradr(select_vrow), .vaddr(select_addr));
  
wire [BITSROW-1:0] select_srow;
np2_addr #(
  .NUMADDR (NUMVROW), .BITADDR (BITVROW),
  .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
  .NUMVROW (NUMSROW), .BITVROW (BITSROW))
  vrow_inst (.vbadr(), .vradr(select_srow), .vaddr(select_vrow));

`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITVROW-1:0] select_vrow = 0;
wire [BITSROW-1:0] select_srow = 0;
`endif

wire [NUMRUPT-1:0] rd_fwrd_int;
wire [NUMRUPT*(BITPADR-1)-1:0] rd_padr_int;
reg [BITPADR-2:0] rd_padr_tmp [0:NUMRUPT-1];
reg [NUMRUPT*BITPADR-1:0] rd_padr;
integer padr_int;
always_comb begin
  rd_padr = 0;
  for (padr_int=0; padr_int<NUMRUPT; padr_int=padr_int+1) begin
    rd_padr_tmp[padr_int] = rd_padr_int << (padr_int*(BITPADR-1));
    rd_padr = rd_padr | ({rd_fwrd_int[padr_int],rd_padr_tmp[padr_int]} << (padr_int*BITPADR));
  end
end

wire [NUMRUPT*NUMPBNK-1:0] t1_writeA_a1;
wire [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_addrA_a1;
wire [NUMRUPT*NUMPBNK*MEMWDTH-1:0] t1_dinA_a1;
wire [NUMRUPT*NUMPBNK-1:0] t1_readB_a1;
wire [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_addrB_a1;
reg [NUMRUPT*NUMPBNK*MEMWDTH-1:0] t1_doutB_a1;
reg [NUMRUPT*NUMPBNK-1:0] t1_fwrdB_a1;
reg [NUMRUPT*NUMPBNK-1:0] t1_serrB_a1;
reg [NUMRUPT*NUMPBNK-1:0] t1_derrB_a1;
reg [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_padrB_a1;

wire [NUMRUPT*BITMAPT-1:0] t2_doutB_a1;

generate if (1) begin: a1_loop

  algo_nru_1r1w_mt #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                     .NUMRUPT (NUMRUPT), .NUMADDR(NUMADDR), .BITADDR(BITADDR),
                     .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMPBNK(NUMPBNK), .BITPBNK(BITPBNK),
                     .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS), .NUMSROW(NUMSROW), .BITSROW(BITSROW), .BITPADR(BITPADR-1),
                     .SRAM_DELAY(SRAM_DELAY+FLOPMEM), .DRAM_DELAY(DRAM_DELAY), .FLOPIN (FLOPIN), .FLOPPWR (0), .FLOPOUT(FLOPOUT))
    algo (.ready(ready), .clk(clk), .rst (rst),
          .read (read), .write(write), .addr(addr), .din(din), .rd_vld(rd_vld), .rd_dout(rd_dout),
          .rd_fwrd(rd_fwrd_int), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr_int),
          .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
          .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1),
          .t1_fwrdB(t1_fwrdB_a1), .t1_serrB(t1_serrB_a1), .t1_derrB(t1_derrB_a1), .t1_padrB(t1_padrB_a1),
          .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB_a1),
          .select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

wire [MEMWDTH-1:0] t1_doutB_a1_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire t1_fwrdB_a1_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire t1_serrB_a1_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire t1_derrB_a1_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire [BITSROW-1:0] t1_padrB_a1_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire t1_writeA_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire [BITSROW-1:0] t1_addrA_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire [MEMWDTH-1:0] t1_bwA_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire [MEMWDTH-1:0] t1_dinA_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire t1_readB_wire [0:NUMRUPT-1][0:NUMPBNK-1];
wire [BITSROW-1:0] t1_addrB_wire [0:NUMRUPT-1][0:NUMPBNK-1];

genvar t1r, t1b;
generate
  for (t1r=0; t1r<NUMRUPT; t1r=t1r+1) begin: t1r_loop
    for (t1b=0; t1b<NUMPBNK; t1b=t1b+1) begin: t1b_loop
      wire t1_writeA_a1_wire = t1_writeA_a1 >> (t1r*NUMPBNK+t1b);
      wire [BITSROW-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> ((t1r*NUMPBNK+t1b)*BITSROW);
      wire [MEMWDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> ((t1r*NUMPBNK+t1b)*MEMWDTH); 
      wire t1_readB_a1_wire = t1_readB_a1 >> (t1r*NUMPBNK+t1b);
      wire [BITSROW-1:0] t1_addrB_a1_wire = t1_addrB_a1 >> ((t1r*NUMPBNK+t1b)*BITSROW);

      wire [MEMWDTH-1:0] t1_doutB_wire = t1_doutB >> ((t1r*NUMPBNK+t1b)*PHYWDTH);

      wire mem_write_wire;
      wire [BITSROW-1:0] mem_wr_adr_wire;
      wire [MEMWDTH-1:0] mem_bw_wire;
      wire [MEMWDTH-1:0] mem_din_wire;
      wire mem_read_wire;
      wire [BITSROW-1:0] mem_rd_adr_wire;
      wire [MEMWDTH-1:0] mem_rd_dout_wire;
      wire mem_rd_fwrd_wire;
      wire mem_rd_serr_wire;
      wire mem_rd_derr_wire;
      wire [(BITWBNK+BITWROW)-1:0] mem_rd_padr_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH (MEMWDTH), .ENAPSDO (1), .ENAPAR (0), .ENAECC (0), .ECCWDTH (ECCWDTH), .ENAPADR (1),
                               .NUMADDR (NUMSROW), .BITADDR (BITSROW), .NUMSROW (NUMVROW), .BITSROW (BITSROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITWBNK+BITWROW),
                               .SRAM_DELAY (DRAM_DELAY), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.write(t1_writeA_a1_wire), .wr_adr(t1_addrA_a1_wire), .din(t1_dinA_a1_wire),
                 .read(t1_readB_a1_wire), .rd_adr(t1_addrB_a1_wire),
                 .rd_dout(t1_doutB_a1_wire[t1r][t1b]), .rd_fwrd(t1_fwrdB_a1_wire[t1r][t1b]),
                 .rd_serr(t1_serrB_a1_wire[t1r][t1b]), .rd_derr(t1_derrB_a1_wire[t1r][t1b]), .rd_padr(t1_padrB_a1_wire[t1r][t1b]),
                 .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
                 .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_srow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (MEMWDTH), .ENAPSDO (0), .NUMADDR (NUMSROW), .BITADDR (BITSROW),
                           .NUMWROW (NUMWROW), .BITWROW (BITWROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                           .SRAM_DELAY (DRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (0))
          infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
                 .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
                 .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr(mem_rd_derr_wire), .rd_padr(mem_rd_padr_wire),
                 .mem_write (t1_writeA_wire[t1r][t1b]), .mem_wr_adr(t1_addrA_wire[t1r][t1b]),
                 .mem_bw (t1_bwA_wire[t1r][t1b]), .mem_din (t1_dinA_wire[t1r][t1b]),
                 .mem_read (t1_readB_wire[t1r][t1b]), .mem_rd_adr(t1_addrB_wire[t1r][t1b]), .mem_rd_dout (t1_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_srow));
      end
    end
  end
endgenerate

reg [NUMRUPT*NUMPBNK-1:0] t1_writeA;
reg [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_addrA;
reg [NUMRUPT*NUMPBNK*PHYWDTH-1:0] t1_bwA;
reg [NUMRUPT*NUMPBNK*PHYWDTH-1:0] t1_dinA;
reg [NUMRUPT*NUMPBNK-1:0] t1_readB;
reg [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_addrB;
integer t1r_int, t1b_int;
always_comb begin
  t1_writeA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  t1_readB = 0;
  t1_addrB = 0;
  t1_doutB_a1 = 0;
  t1_fwrdB_a1 = 0;
  t1_serrB_a1 = 0;
  t1_derrB_a1 = 0;
  t1_padrB_a1 = 0;
  for (t1r_int=0; t1r_int<NUMRUPT; t1r_int=t1r_int+1) begin
    for (t1b_int=0; t1b_int<NUMPBNK; t1b_int=t1b_int+1) begin
      t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*BITSROW));
      t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*PHYWDTH));
      t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*PHYWDTH));
      t1_readB = t1_readB | (t1_readB_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_addrB = t1_addrB | (t1_addrB_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*BITSROW));
      t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*MEMWDTH));
      t1_fwrdB_a1 = t1_fwrdB_a1 | (t1_fwrdB_a1_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*BITSROW));
    end
  end
end

generate if (FLOPMEM) begin: t2_flp_loop
  reg [NUMRUPT*BITMAPT-1:0] t2_doutB_reg;
  always @(posedge clk) begin
    t2_doutB_reg <= t2_doutB;
  end

  assign t2_doutB_a1 = t2_doutB_reg;
end else begin: t2_noflp_loop
  assign t2_doutB_a1 = t2_doutB;
end
endgenerate

endmodule
