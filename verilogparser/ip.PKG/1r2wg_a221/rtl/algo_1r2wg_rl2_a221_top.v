
module algo_1r2wg_rl2_a221_top (clk, rst, ready,
                                write, wr_adr, din,
                                read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
	                        t1_readA, t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_doutA,
	                        t2_writeA, t2_addrA, t2_readB, t2_addrB, t2_dinA, t2_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMWRPT = 2;
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
  parameter NUMWBNK = 4;      // T2PCK Parameters
  parameter BITWBNK = 2;
  parameter NUMWROW = 256;
  parameter BITWROW = 8;

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;
  parameter PHYWDTH = 140;
  parameter ECCBITS = 4;

  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;
  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input [NUMWRPT-1:0]                  write;
  input [NUMWRPT*BITADDR-1:0]          wr_adr;
  input [NUMWRPT*WIDTH-1:0]            din;

  input                                read;
  input [BITADDR-1:0]                  rd_adr;
  output                               rd_vld;
  output [WIDTH-1:0]                   rd_dout;
  output                               rd_serr;
  output                               rd_derr;
  output [BITPADR-1:0]                 rd_padr;

  output                               ready;
  input                                clk, rst;

  output [NUMVBNK-1:0] t1_readA;
  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input [NUMVBNK*PHYWDTH-1:0] t1_doutA;

  output [2*NUMWRPT*NUMWBNK-1:0] t2_writeA;
  output [2*NUMWRPT*NUMWBNK*BITWROW-1:0] t2_addrA;
  output [2*NUMWRPT*NUMWBNK*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA;

  output [2*NUMWRPT*NUMWBNK-1:0] t2_readB;
  output [2*NUMWRPT*NUMWBNK*BITWROW-1:0] t2_addrB;
  input [2*NUMWRPT*NUMWBNK*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB;

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

wire [2*NUMWRPT-1:0] t2_writeA_a1;
wire [2*NUMWRPT*BITVROW-1:0] t2_addrA_a1;
wire [2*NUMWRPT*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA_a1;
wire [2*NUMWRPT-1:0] t2_readB_a1;
wire [2*NUMWRPT*BITVROW-1:0] t2_addrB_a1;
reg [2*NUMWRPT*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB_a1;
reg [2*NUMWRPT-1:0] t2_fwrdB_a1;
reg [2*NUMWRPT*(BITSROW+BITWRDS)-1:0] t2_padrB_a1;

generate if (1) begin: a1_loop

algo_1rnwg_rl2_a221 #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPSDO (0), .NUMWRPT (NUMWRPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                      .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR-1),
                      .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT), .ECCBITS (ECCBITS))
  algo (.clk(clk), .rst(rst), .ready(ready),
        .write(write), .wr_adr(wr_adr), .din(din),
        .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout),
        .rd_fwrd(rd_padr[BITPADR-1]), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr[BITPADR-2:0]),
        .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
        .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1), .t1_fwrdB(t1_fwrdB_a1), .t1_padrB(t1_padrB_a1),
        .t2_writeA(t2_writeA_a1), .t2_addrA(t2_addrA_a1), .t2_dinA(t2_dinA_a1),
        .t2_readB(t2_readB_a1), .t2_addrB(t2_addrB_a1), .t2_doutB(t2_doutB_a1), .t2_fwrdB(t2_fwrdB_a1), .t2_padrB(t2_padrB_a1),
	.select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

wire [WIDTH-1:0] t1_doutB_a1_wire [0:NUMVBNK-1];
wire t1_fwrdB_a1_wire [0:NUMVBNK-1];
wire t1_serrB_a1_wire [0:NUMVBNK-1];
wire t1_derrB_a1_wire [0:NUMVBNK-1];
wire [BITSROW+BITWRDS-1:0] t1_padrB_a1_wire [0:NUMVBNK-1];
wire t1_readA_wire [0:NUMVBNK-1];
wire t1_writeA_wire [0:NUMVBNK-1];
wire [BITSROW-1:0] t1_addrA_wire [0:NUMVBNK-1];
wire [NUMWRDS*WIDTH-1:0] t1_bwA_wire [0:NUMVBNK-1];
wire [NUMWRDS*WIDTH-1:0] t1_dinA_wire [0:NUMVBNK-1];

genvar t1;
generate for (t1=0; t1<NUMVBNK; t1=t1+1) begin: t1_loop
  wire t1_writeA_a1_wire = t1_writeA_a1 >> t1;
  wire [BITVROW-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> (t1*BITVROW);
  wire [WIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> (t1*WIDTH);

  wire t1_readB_a1_wire = t1_readB_a1 >> t1;
  wire [BITVROW-1:0] t1_addrB_a1_wire = t1_addrB_a1 >> (t1*BITVROW);

  wire [NUMWRDS*WIDTH-1:0] t1_doutA_wire = t1_doutA >> (t1*PHYWDTH);

  if (1) begin: align_loop
    infra_align_ecc_1rw #(.WIDTH (WIDTH), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                          .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITSROW+BITWRDS),
                          .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (0), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
      infra (.write (t1_writeA_a1_wire), .wr_adr (t1_addrA_a1_wire), .din (t1_dinA_a1_wire),
             .read (t1_readB_a1_wire), .rd_adr (t1_addrB_a1_wire), .rd_dout (t1_doutB_a1_wire[t1]), .rd_fwrd (t1_fwrdB_a1_wire[t1]),
             .rd_serr (t1_serrB_a1_wire[t1]), .rd_derr (t1_derrB_a1_wire[t1]), .rd_padr (t1_padrB_a1_wire[t1]),
             .mem_read (t1_readA_wire[t1]), .mem_write (t1_writeA_wire[t1]), .mem_addr (t1_addrA_wire[t1]),
	     .mem_bw (t1_bwA_wire[t1]), .mem_din (t1_dinA_wire[t1]), .mem_dout (t1_doutA_wire),
             .select_addr (select_vrow),
             .clk (clk), .rst (rst));
  end
end
endgenerate

reg [NUMVBNK-1:0] t1_readA;
reg [NUMVBNK-1:0] t1_writeA;
reg [NUMVBNK*BITSROW-1:0] t1_addrA;
reg [NUMVBNK*PHYWDTH-1:0] t1_bwA;
reg [NUMVBNK*PHYWDTH-1:0] t1_dinA;

integer t1_out_int;
always_comb begin
  t1_readA = 0;
  t1_writeA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  t1_doutB_a1 = 0;
  t1_fwrdB_a1 = 0;
  t1_serrB_a1 = 0;
  t1_derrB_a1 = 0;
  t1_padrB_a1 = 0;
  for (t1_out_int=0; t1_out_int<NUMVBNK; t1_out_int=t1_out_int+1) begin
    t1_readA = t1_readA | (t1_readA_wire[t1_out_int] << t1_out_int);
    t1_writeA = t1_writeA | (t1_writeA_wire[t1_out_int] << t1_out_int);
    t1_addrA = t1_addrA | (t1_addrA_wire[t1_out_int] << (t1_out_int*BITSROW));
    t1_bwA = t1_bwA | (t1_bwA_wire[t1_out_int] << (t1_out_int*PHYWDTH));
    t1_dinA = t1_dinA | (t1_dinA_wire[t1_out_int] << (t1_out_int*PHYWDTH));
    t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[t1_out_int] << (t1_out_int*WIDTH));
    t1_fwrdB_a1 = t1_fwrdB_a1 | (t1_fwrdB_a1_wire[t1_out_int] << t1_out_int);
    t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_wire[t1_out_int] << t1_out_int);
    t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[t1_out_int] << t1_out_int);
    t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_wire[t1_out_int] << (t1_out_int*(BITSROW+BITWRDS)));
  end
end

wire [SDOUT_WIDTH+WIDTH-1:0] t2_doutB_a1_wire [0:2*NUMWRPT-1];
wire t2_fwrdB_a1_wire [0:2*NUMWRPT-1];
wire [BITWROW+BITWBNK-1:0] t2_padrB_a1_wire [0:2*NUMWRPT-1];
wire [NUMWBNK-1:0] t2_writeA_wire [0:2*NUMWRPT-1];
wire [NUMWBNK*BITWROW-1:0] t2_addrA_wire [0:2*NUMWRPT-1];
wire [NUMWBNK*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA_wire [0:2*NUMWRPT-1];
wire [NUMWBNK-1:0] t2_readB_wire [0:2*NUMWRPT-1];
wire [NUMWBNK*BITWROW-1:0] t2_addrB_wire [0:2*NUMWRPT-1];

genvar t2;
generate for (t2=0; t2<2*NUMWRPT; t2=t2+1) begin: t2_loop
  wire t2_writeA_a1_wire = t2_writeA_a1 >> t2;
  wire [BITVROW-1:0] t2_addrA_a1_wire = t2_addrA_a1 >> (t2*BITVROW);
  wire [(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA_a1_wire = t2_dinA_a1 >> (t2*(SDOUT_WIDTH+WIDTH));

  wire t2_readB_a1_wire = t2_readB_a1 >> t2;
  wire [BITVROW-1:0] t2_addrB_a1_wire = t2_addrB_a1 >> (t2*BITVROW);

  wire [NUMWBNK*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB_wire = t2_doutB >> (t2*NUMWBNK*(SDOUT_WIDTH+WIDTH));

  wire mem_write_wire;
  wire [BITVROW-1:0] mem_wr_adr_wire;
  wire [SDOUT_WIDTH+WIDTH-1:0] mem_bw_wire;
  wire [SDOUT_WIDTH+WIDTH-1:0] mem_din_wire;
  wire mem_read_wire;
  wire [BITVROW-1:0] mem_rd_adr_wire;
  wire [SDOUT_WIDTH+WIDTH-1:0] mem_rd_dout_wire;
  wire mem_rd_fwrd_wire;
  wire mem_rd_serr_wire;
  wire mem_rd_derr_wire;
  wire [(BITWBNK+BITWROW)-1:0] mem_rd_padr_wire;

  if (1) begin: align_loop
    infra_align_ecc_1r1w #(.WIDTH (SDOUT_WIDTH+WIDTH), .ENAPSDO (1), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                           .NUMSROW (NUMVROW), .BITSROW (BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITWBNK+BITWROW),
                           .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .ENAPADR (1), .RSTZERO (1))
      infra (.write (t2_writeA_a1_wire), .wr_adr (t2_addrA_a1_wire), .din (t2_dinA_a1_wire),
             .read (t2_readB_a1_wire), .rd_adr (t2_addrB_a1_wire), .rd_dout (t2_doutB_a1_wire[t2]),
             .rd_fwrd (t2_fwrdB_a1_wire[t2]), .rd_serr(), .rd_derr(), .rd_padr(t2_padrB_a1_wire[t2]),
             .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
             .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
             .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
             .clk (clk), .rst (rst),
             .select_addr (select_vrow));
  end

  if (1) begin: stack_loop
    infra_stack_1r1w #(.WIDTH (SDOUT_WIDTH+WIDTH), .ENAPSDO (0), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
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

reg [2*NUMWRPT*NUMWBNK-1:0] t2_writeA;
reg [2*NUMWRPT*NUMWBNK*BITWROW-1:0] t2_addrA;
reg [2*NUMWRPT*NUMWBNK*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA;
reg [2*NUMWRPT*NUMWBNK-1:0] t2_readB;
reg [2*NUMWRPT*NUMWBNK*BITWROW-1:0] t2_addrB;

integer t2_out_int;
always_comb begin
  t2_writeA = 0;
  t2_addrA = 0;
  t2_dinA = 0;
  t2_readB = 0;
  t2_addrB = 0;
  t2_doutB_a1 = 0;
  t2_fwrdB_a1 = 0;
  t2_padrB_a1 = 0;
  for (t2_out_int=0; t2_out_int<2*NUMWRPT; t2_out_int=t2_out_int+1) begin
    t2_writeA = t2_writeA | (t2_writeA_wire[t2_out_int] << t2_out_int*NUMWBNK);
    t2_addrA = t2_addrA | (t2_addrA_wire[t2_out_int] << (t2_out_int*NUMWBNK*BITWROW));
    t2_dinA = t2_dinA | (t2_dinA_wire[t2_out_int] << (t2_out_int*NUMWBNK*(SDOUT_WIDTH+WIDTH)));
    t2_readB = t2_readB | (t2_readB_wire[t2_out_int] << t2_out_int*NUMWBNK);
    t2_addrB = t2_addrB | (t2_addrB_wire[t2_out_int] << (t2_out_int*NUMWBNK*BITWROW));
    t2_doutB_a1 = t2_doutB_a1 | (t2_doutB_a1_wire[t2_out_int] << (t2_out_int*(SDOUT_WIDTH+WIDTH)));
    t2_fwrdB_a1 = t2_fwrdB_a1 | (t2_fwrdB_a1_wire[t2_out_int] << t2_out_int);
    t2_padrB_a1 = t2_padrB_a1 | (t2_padrB_a1_wire[t2_out_int] << (t2_out_int*(BITSROW+BITWRDS)));
  end
end

endmodule
