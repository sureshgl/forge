
module algo_1r1rw_xr_top (clk, rst, ready,
                          write, wr_adr, din,
                          read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
	                  t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
	                  t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_readB, t2_addrB, t2_doutB);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ENAHEC = 0;
  parameter ENAQEC = 0;
  parameter ECCWDTH = 7;
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
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENAHEC ? WIDTH+2*ECCWDTH : ENAQEC ? WIDTH+4*ECCWDTH : WIDTH;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;
  parameter SRAM_DELAY = 2;
  parameter FLOPECC = 0;
  parameter FLOPCMD = 0;
  parameter FLOPIN = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;

  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  input                          write;
  input [BITADDR-1:0]            wr_adr;
  input [WIDTH-1:0]              din;

  input [2-1:0]                  read;
  input [2*BITADDR-1:0]          rd_adr;
  output [2-1:0]                 rd_vld;
  output [2*WIDTH-1:0]           rd_dout;
  output [2-1:0]                 rd_serr;
  output [2-1:0]                 rd_derr;
  output [2*BITPADR-1:0]         rd_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  output [NUMVBNK-1:0] t1_readB;
  output [NUMVBNK*BITSROW-1:0] t1_addrB;
  input [NUMVBNK*PHYWDTH-1:0] t1_doutB;

  output [1-1:0] t2_writeA;
  output [1*BITSROW-1:0] t2_addrA;
  output [1*PHYWDTH-1:0] t2_bwA;
  output [1*PHYWDTH-1:0] t2_dinA;
  output [1-1:0] t2_readB;
  output [1*BITSROW-1:0] t2_addrB;
  input [1*PHYWDTH-1:0] t2_doutB;

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
  addr_inst (.vbadr(), .vradr(select_vrow), .vaddr(select_addr));

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

wire [NUMVBNK-1:0] t1_writeA_a1;
wire [NUMVBNK*BITVROW-1:0] t1_addrA_a1;
wire [NUMVBNK*WIDTH-1:0] t1_dinA_a1;
wire [NUMVBNK-1:0] t1_readB_a1;
wire [NUMVBNK*BITVROW-1:0] t1_addrB_a1;
reg [NUMVBNK*WIDTH-1:0] t1_doutB_a1;
reg [NUMVBNK-1:0] t1_fwrdB_a1;
reg [NUMVBNK-1:0] t1_serrB_a1;
reg [NUMVBNK-1:0] t1_derrB_a1;
reg [NUMVBNK*(BITSROW+BITWRDS)-1:0] t1_padrB_a1;
  
wire t2_writeA_a1;
wire [BITVROW-1:0] t2_addrA_a1;
wire [WIDTH-1:0] t2_dinA_a1;
wire t2_readB_a1;
wire [BITVROW-1:0] t2_addrB_a1;
reg [WIDTH-1:0] t2_doutB_a1;
reg t2_fwrdB_a1;
reg t2_serrB_a1;
reg t2_derrB_a1;
reg [(BITSROW+BITWRDS)-1:0] t2_padrB_a1;

generate if (1) begin: a1_loop

algo_nr1rw_1r1w #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC || ENAHEC || ENAQEC), .NUMVRPT (2), .NUMPRPT (1),
                  .NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK),
                  .BITPADR (BITPADR-1), .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPECC), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    algo (.clk (clk), .rst (rst), .ready (ready),
          .write (write), .wr_adr (wr_adr), .din (din),
	  .read (read), .rd_adr (rd_adr), .rd_vld (rd_vld), .rd_dout (rd_dout),
          .rd_fwrd ({rd_padr[2*BITPADR-1],rd_padr[BITPADR-1]}), .rd_serr (rd_serr), .rd_derr (rd_derr),
          .rd_padr ({rd_padr[2*BITPADR-2:BITPADR],rd_padr[BITPADR-2:0]}),
	  .t1_writeA (t1_writeA_a1), .t1_addrA (t1_addrA_a1), .t1_dinA (t1_dinA_a1),
          .t1_readB (t1_readB_a1), .t1_addrB (t1_addrB_a1), .t1_doutB (t1_doutB_a1),
          .t1_fwrdB (t1_fwrdB_a1), .t1_serrB (t1_serrB_a1), .t1_derrB (t1_derrB_a1), .t1_padrB (t1_padrB_a1),
	  .t2_writeA (t2_writeA_a1), .t2_addrA (t2_addrA_a1), .t2_dinA (t2_dinA_a1),
          .t2_readB (t2_readB_a1), .t2_addrB (t2_addrB_a1), .t2_doutB (t2_doutB_a1),
	  .t2_fwrdB (t2_fwrdB_a1), .t2_serrB (t2_serrB_a1), .t2_derrB (t2_derrB_a1), .t2_padrB (t2_padrB_a1),
	  .select_addr (select_addr),
	  .select_bit (select_bit));

end
endgenerate

wire t1_writeA_wire [0:NUMVBNK-1];
wire [BITSROW-1:0] t1_addrA_wire [0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_bwA_wire [0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_dinA_wire [0:NUMVBNK-1];
wire t1_readB_wire [0:NUMVBNK-1];
wire [BITSROW-1:0] t1_addrB_wire [0:NUMVBNK-1];
wire [WIDTH-1:0] t1_doutB_a1_wire [0:NUMVBNK-1];
wire t1_fwrdB_a1_wire [0:NUMVBNK-1];
wire t1_serrB_a1_wire [0:NUMVBNK-1];
wire t1_derrB_a1_wire [0:NUMVBNK-1];
wire [(BITSROW+BITWRDS)-1:0] t1_padrB_a1_wire [0:NUMVBNK-1];

genvar t1;
generate for (t1=0; t1<NUMVBNK; t1=t1+1) begin: t1_loop
  wire t1_writeA_a1_wire = t1_writeA_a1 >> t1;
  wire [BITVROW-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> (t1*BITVROW);
  wire [WIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> (t1*WIDTH);

  wire t1_readB_a1_wire = t1_readB_a1 >> t1;
  wire [BITVROW-1:0] t1_addrB_a1_wire = t1_addrB_a1 >> (t1*BITVROW);
  wire [NUMWRDS*MEMWDTH-1:0] t1_doutB_wire = t1_doutB >> (t1*PHYWDTH);

  wire mem_write_t1_wire;
  wire [BITSROW-1:0] mem_wr_adr_t1_wire;
  wire [NUMWRDS*MEMWDTH-1:0] mem_bw_t1_wire;
  wire [NUMWRDS*MEMWDTH-1:0] mem_din_t1_wire;
  wire mem_read_t1_wire;
  wire [BITSROW-1:0] mem_rd_adr_t1_wire;
  wire [NUMWRDS*MEMWDTH-1:0] mem_rd_dout_t1_wire;
  wire mem_rd_fwrd_t1_wire;
  wire mem_rd_serr_t1_wire;
  wire mem_rd_derr_t1_wire;
  wire [BITSROW-1:0] mem_rd_padr_t1_wire;

  if (1) begin: align_loop
    infra_align_ecc_1r1w #(.WIDTH (WIDTH), .ENAPSDO (NUMWRDS==1), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                           .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ENAHEC (ENAHEC), .ENAQEC (ENAQEC), .ECCWDTH (ECCWDTH), .ENAPADR (1),
                           .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITSROW),
                           .SRAM_DELAY (SRAM_DELAY+FLOPMEM+FLOPCMD), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (1))
      infra (.write(t1_writeA_a1_wire), .wr_adr(t1_addrA_a1_wire), .din(t1_dinA_a1_wire),
             .read(t1_readB_a1_wire), .rd_adr(t1_addrB_a1_wire), .rd_dout(t1_doutB_a1_wire[t1]),
             .rd_fwrd(t1_fwrdB_a1_wire[t1]), .rd_serr(t1_serrB_a1_wire[t1]), .rd_derr(t1_derrB_a1_wire[t1]), .rd_padr(t1_padrB_a1_wire[t1]),
             .mem_write (mem_write_t1_wire), .mem_wr_adr(mem_wr_adr_t1_wire), .mem_bw (mem_bw_t1_wire), .mem_din (mem_din_t1_wire),
             .mem_read (mem_read_t1_wire), .mem_rd_adr(mem_rd_adr_t1_wire), .mem_rd_dout (mem_rd_dout_t1_wire),
             .mem_rd_fwrd(mem_rd_fwrd_t1_wire), .mem_rd_padr(mem_rd_padr_t1_wire),
             .clk (clk), .rst (rst),
             .select_addr (select_vrow));
      end

  if (1) begin: stack_loop
    infra_stack_1r1w #(.WIDTH (NUMWRDS*MEMWDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (NUMSROW), .BITADDR (BITSROW),
                       .NUMWROW (NUMSROW), .BITWROW (BITSROW), .NUMWBNK (1), .BITWBNK (0),
                       .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1))
      infra (.write (mem_write_t1_wire), .wr_adr (mem_wr_adr_t1_wire), .bw (mem_bw_t1_wire), .din (mem_din_t1_wire),
             .read (mem_read_t1_wire), .rd_adr (mem_rd_adr_t1_wire), .rd_dout (mem_rd_dout_t1_wire),
             .rd_fwrd (mem_rd_fwrd_t1_wire), .rd_serr (mem_rd_serr_t1_wire), .rd_derr(mem_rd_derr_t1_wire), .rd_padr(mem_rd_padr_t1_wire),
             .mem_write (t1_writeA_wire[t1]), .mem_wr_adr(t1_addrA_wire[t1]), .mem_bw (t1_bwA_wire[t1]), .mem_din (t1_dinA_wire[t1]),
             .mem_read (t1_readB_wire[t1]), .mem_rd_adr(t1_addrB_wire[t1]), .mem_rd_dout (t1_doutB_wire),
             .clk (clk), .rst(rst),
             .select_addr (select_srow));
  end
end
endgenerate

reg [NUMVBNK-1:0] t1_writeA;
reg [NUMVBNK*BITSROW-1:0] t1_addrA;
reg [NUMVBNK*PHYWDTH-1:0] t1_bwA;
reg [NUMVBNK*PHYWDTH-1:0] t1_dinA;
reg [NUMVBNK-1:0] t1_readB;
reg [NUMVBNK*BITSROW-1:0] t1_addrB;

integer t1_out_int;
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
  for (t1_out_int=0; t1_out_int<NUMVBNK; t1_out_int=t1_out_int+1) begin
    t1_writeA = t1_writeA | (t1_writeA_wire[t1_out_int] << t1_out_int);
    t1_addrA = t1_addrA | (t1_addrA_wire[t1_out_int] << (t1_out_int*BITSROW));
    t1_bwA = t1_bwA | (t1_bwA_wire[t1_out_int] << (t1_out_int*PHYWDTH));
    t1_dinA = t1_dinA | (t1_dinA_wire[t1_out_int] << (t1_out_int*PHYWDTH));
    t1_readB = t1_readB | (t1_readB_wire[t1_out_int] << t1_out_int);
    t1_addrB = t1_addrB | (t1_addrB_wire[t1_out_int] << (t1_out_int*BITSROW));
    t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[t1_out_int] << (t1_out_int*WIDTH));
    t1_fwrdB_a1 = t1_fwrdB_a1 | (t1_fwrdB_a1_wire[t1_out_int] << t1_out_int);
    t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_wire[t1_out_int] << t1_out_int);
    t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[t1_out_int] << t1_out_int);
    t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_wire[t1_out_int] << (t1_out_int*(BITSROW+BITWRDS)));
  end
end

wire t2_writeA_wire [0:1-1];
wire [BITSROW-1:0] t2_addrA_wire [0:1-1];
wire [NUMWRDS*MEMWDTH-1:0] t2_bwA_wire [0:1-1];
wire [NUMWRDS*MEMWDTH-1:0] t2_dinA_wire [0:1-1];
wire t2_readB_wire [0:1-1];
wire [BITSROW-1:0] t2_addrB_wire [0:1-1];
wire [WIDTH-1:0] t2_doutB_a1_wire [0:1-1];
wire t2_fwrdB_a1_wire [0:1-1];
wire t2_serrB_a1_wire [0:1-1];
wire t2_derrB_a1_wire [0:1-1];
wire [(BITSROW+BITWRDS)-1:0] t2_padrB_a1_wire [0:1-1];

genvar t2;
generate for (t2=0; t2<1; t2=t2+1) begin: t2_loop
  wire t2_writeA_a1_wire = t2_writeA_a1 >> t2;
  wire [BITVROW-1:0] t2_addrA_a1_wire = t2_addrA_a1 >> (t2*BITVROW);
  wire [WIDTH-1:0] t2_dinA_a1_wire = t2_dinA_a1 >> (t2*WIDTH);

  wire t2_readB_a1_wire = t2_readB_a1 >> t2;
  wire [BITVROW-1:0] t2_addrB_a1_wire = t2_addrB_a1 >> (t2*BITVROW);
  wire [NUMWRDS*MEMWDTH-1:0] t2_doutB_wire = t2_doutB >> (t2*PHYWDTH);

  wire mem_write_t2_wire;
  wire [BITSROW-1:0] mem_wr_adr_t2_wire;
  wire [NUMWRDS*MEMWDTH-1:0] mem_bw_t2_wire;
  wire [NUMWRDS*MEMWDTH-1:0] mem_din_t2_wire;
  wire mem_read_t2_wire;
  wire [BITSROW-1:0] mem_rd_adr_t2_wire;
  wire [NUMWRDS*MEMWDTH-1:0] mem_rd_dout_t2_wire;
  wire mem_rd_fwrd_t2_wire;
  wire mem_rd_serr_t2_wire;
  wire mem_rd_derr_t2_wire;
  wire [BITSROW-1:0] mem_rd_padr_t2_wire;

  if (1) begin: align_loop
    infra_align_ecc_1r1w #(.WIDTH (WIDTH), .ENAPSDO (NUMWRDS==1), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                           .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ENAHEC (ENAHEC), .ENAQEC (ENAQEC), .ECCWDTH (ECCWDTH), .ENAPADR (1),
                           .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITSROW),
                           .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (1))
      infra (.write(t2_writeA_a1_wire), .wr_adr(t2_addrA_a1_wire), .din(t2_dinA_a1_wire),
             .read(t2_readB_a1_wire), .rd_adr(t2_addrB_a1_wire), .rd_dout(t2_doutB_a1_wire[t2]),
             .rd_fwrd(t2_fwrdB_a1_wire[t2]), .rd_serr(t2_serrB_a1_wire[t2]), .rd_derr(t2_derrB_a1_wire[t2]), .rd_padr(t2_padrB_a1_wire[t2]),
             .mem_write (mem_write_t2_wire), .mem_wr_adr(mem_wr_adr_t2_wire), .mem_bw (mem_bw_t2_wire), .mem_din (mem_din_t2_wire),
             .mem_read (mem_read_t2_wire), .mem_rd_adr(mem_rd_adr_t2_wire), .mem_rd_dout (mem_rd_dout_t2_wire),
             .mem_rd_fwrd(mem_rd_fwrd_t2_wire), .mem_rd_padr(mem_rd_padr_t2_wire),
             .clk (clk), .rst (rst),
             .select_addr (select_vrow));
      end

  if (1) begin: stack_loop
    infra_stack_1r1w #(.WIDTH (NUMWRDS*MEMWDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (NUMSROW), .BITADDR (BITSROW),
                       .NUMWROW (NUMSROW), .BITWROW (BITSROW), .NUMWBNK (1), .BITWBNK (0),
                       .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1))
      infra (.write (mem_write_t2_wire), .wr_adr (mem_wr_adr_t2_wire), .bw (mem_bw_t2_wire), .din (mem_din_t2_wire),
             .read (mem_read_t2_wire), .rd_adr (mem_rd_adr_t2_wire), .rd_dout (mem_rd_dout_t2_wire),
             .rd_fwrd (mem_rd_fwrd_t2_wire), .rd_serr (mem_rd_serr_t2_wire), .rd_derr(mem_rd_derr_t2_wire), .rd_padr(mem_rd_padr_t2_wire),
             .mem_write (t2_writeA_wire[t2]), .mem_wr_adr(t2_addrA_wire[t2]), .mem_bw (t2_bwA_wire[t2]), .mem_din (t2_dinA_wire[t2]),
             .mem_read (t2_readB_wire[t2]), .mem_rd_adr(t2_addrB_wire[t2]), .mem_rd_dout (t2_doutB_wire),
             .clk (clk), .rst(rst),
             .select_addr (select_srow));
  end
end
endgenerate

reg [1-1:0] t2_writeA;
reg [1*BITSROW-1:0] t2_addrA;
reg [1*PHYWDTH-1:0] t2_bwA;
reg [1*PHYWDTH-1:0] t2_dinA;
reg [1-1:0] t2_readB;
reg [1*BITSROW-1:0] t2_addrB;

integer t2_out_int;
always_comb begin
  t2_writeA = 0;
  t2_addrA = 0;
  t2_bwA = 0;
  t2_dinA = 0;
  t2_readB = 0;
  t2_addrB = 0;
  t2_doutB_a1 = 0;
  t2_fwrdB_a1 = 0;
  t2_serrB_a1 = 0;
  t2_derrB_a1 = 0;
  t2_padrB_a1 = 0;
  for (t2_out_int=0; t2_out_int<1; t2_out_int=t2_out_int+1) begin
    t2_writeA = t2_writeA | (t2_writeA_wire[t2_out_int] << t2_out_int);
    t2_addrA = t2_addrA | (t2_addrA_wire[t2_out_int] << (t2_out_int*BITSROW));
    t2_bwA = t2_bwA | (t2_bwA_wire[t2_out_int] << (t2_out_int*PHYWDTH));
    t2_dinA = t2_dinA | (t2_dinA_wire[t2_out_int] << (t2_out_int*PHYWDTH));
    t2_readB = t2_readB | (t2_readB_wire[t2_out_int] << t2_out_int);
    t2_addrB = t2_addrB | (t2_addrB_wire[t2_out_int] << (t2_out_int*BITSROW));
    t2_doutB_a1 = t2_doutB_a1 | (t2_doutB_a1_wire[t2_out_int] << (t2_out_int*WIDTH));
    t2_fwrdB_a1 = t2_fwrdB_a1 | (t2_fwrdB_a1_wire[t2_out_int] << t2_out_int);
    t2_serrB_a1 = t2_serrB_a1 | (t2_serrB_a1_wire[t2_out_int] << t2_out_int);
    t2_derrB_a1 = t2_derrB_a1 | (t2_derrB_a1_wire[t2_out_int] << t2_out_int);
    t2_padrB_a1 = t2_padrB_a1 | (t2_padrB_a1_wire[t2_out_int] << (t2_out_int*(BITSROW+BITWRDS)));
  end
end

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

endmodule
