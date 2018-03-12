
module algo_1r1d3w_1rw_rl2_top (clk, rst, ready,
                                write, wr_adr, din,
                                read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
	                        t1_readA, t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_doutA,
	                        t2_readA, t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_doutA);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
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

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;
  parameter PHYWDTH = 140;
  parameter ECCBITS = 4;

  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;
  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

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

  output [2-1:0] t2_readA;
  output [2-1:0] t2_writeA;
  output [2*BITVROW-1:0] t2_addrA;
  output [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_bwA;
  output [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA;
  input [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutA;

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

wire [NUMVBNK-1:0] t1_readA_a1;
wire [NUMVBNK-1:0] t1_writeA_a1;
wire [NUMVBNK*BITVROW-1:0] t1_addrA_a1;
wire [NUMVBNK*WIDTH-1:0] t1_dinA_a1;
reg [NUMVBNK*WIDTH-1:0] t1_doutA_a1;
reg [NUMVBNK-1:0] t1_fwrdA_a1;
reg [NUMVBNK-1:0] t1_serrA_a1;
reg [NUMVBNK-1:0] t1_derrA_a1;
reg [NUMVBNK*(BITSROW+BITWRDS)-1:0] t1_padrA_a1;

wire [2-1:0] t2_readA_a1;
wire [2-1:0] t2_writeA_a1;
wire [2*BITVROW-1:0] t2_addrA_a1;
wire [2*WIDTH-1:0] t2_dinA_a1;
reg [2*WIDTH-1:0] t2_doutA_a1;
reg [2-1:0] t2_fwrdA_a1;
reg [2-1:0] t2_serrA_a1;
reg [2-1:0] t2_derrA_a1;
reg [2*(BITSROW+BITWRDS)-1:0] t2_padrA_a1;

wire [2-1:0] t3_readA_a1;
wire [2-1:0] t3_writeA_a1;
wire [2*BITVROW-1:0] t3_addrA_a1;
wire [2*(BITVBNK+1)-1:0] t3_dinA_a1;
reg [2*(BITVBNK+1)-1:0] t3_doutA_a1;
reg [2-1:0] t3_fwrdA_a1;
reg [2-1:0] t3_serrA_a1;
reg [2-1:0] t3_derrA_a1;
reg [2*(BITSROW+BITWRDS)-1:0] t3_padrA_a1;

generate if (1) begin: a1_loop
  algo_1r1d3w_1rw_rl2 #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                        .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR-1),
                        .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    algo (.clk(clk), .rst(rst), .ready(ready),
          .write(write), .wr_adr(wr_adr), .din(din),
          .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout),
          .rd_fwrd(rd_padr[BITPADR-1]), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr[BITPADR-2:0]),
          .t1_readA(t1_readA_a1), .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
          .t1_doutA(t1_doutA_a1), .t1_fwrdA(t1_fwrdA_a1), .t1_serrA(t1_serrA_a1), .t1_derrA(t1_derrA_a1), .t1_padrA(t1_padrA_a1),
          .t2_readA(t2_readA_a1), .t2_writeA(t2_writeA_a1), .t2_addrA(t2_addrA_a1), .t2_dinA(t2_dinA_a1),
          .t2_doutA(t2_doutA_a1), .t2_fwrdA(t2_fwrdA_a1), .t2_serrA(t2_serrA_a1), .t2_derrA(t2_derrA_a1), .t2_padrA(t2_padrA_a1),
          .t3_readA(t3_readA_a1), .t3_writeA(t3_writeA_a1), .t3_addrA(t3_addrA_a1), .t3_dinA(t3_dinA_a1),
          .t3_doutA(t3_doutA_a1), .t3_fwrdA(t3_fwrdA_a1), .t3_serrA(t3_serrA_a1), .t3_derrA(t3_derrA_a1), .t3_padrA(t3_padrA_a1),
  	.select_addr (select_addr), .select_bit (select_bit));
end
endgenerate

wire [WIDTH-1:0] t1_doutA_a1_wire [0:NUMVBNK-1];
wire t1_fwrdA_a1_wire [0:NUMVBNK-1];
wire t1_serrA_a1_wire [0:NUMVBNK-1];
wire t1_derrA_a1_wire [0:NUMVBNK-1];
wire [BITSROW+BITWRDS-1:0] t1_padrA_a1_wire [0:NUMVBNK-1];
wire t1_readA_wire [0:NUMVBNK-1];
wire t1_writeA_wire [0:NUMVBNK-1];
wire [BITSROW-1:0] t1_addrA_wire [0:NUMVBNK-1];
wire [NUMWRDS*WIDTH-1:0] t1_bwA_wire [0:NUMVBNK-1];
wire [NUMWRDS*WIDTH-1:0] t1_dinA_wire [0:NUMVBNK-1];

genvar t1;
generate for (t1=0; t1<NUMVBNK; t1=t1+1) begin: t1_loop
  wire t1_readA_a1_wire = t1_readA_a1 >> t1;
  wire t1_writeA_a1_wire = t1_writeA_a1 >> t1;
  wire [BITVROW-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> (t1*BITVROW);
  wire [WIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> (t1*WIDTH);

  wire [NUMWRDS*WIDTH-1:0] t1_doutA_wire = t1_doutA >> (t1*PHYWDTH);

  if (1) begin: align_loop
    infra_align_ecc_1rw #(.WIDTH (WIDTH), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                          .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITSROW+BITWRDS),
                          .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (0), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
      infra (.write (t1_writeA_a1_wire), .wr_adr (t1_addrA_a1_wire), .din (t1_dinA_a1_wire),
             .read (t1_readA_a1_wire), .rd_adr (t1_addrA_a1_wire), .rd_dout (t1_doutA_a1_wire[t1]), .rd_fwrd (t1_fwrdA_a1_wire[t1]),
             .rd_serr (t1_serrA_a1_wire[t1]), .rd_derr (t1_derrA_a1_wire[t1]), .rd_padr (t1_padrA_a1_wire[t1]),
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
  t1_doutA_a1 = 0;
  t1_fwrdA_a1 = 0;
  t1_serrA_a1 = 0;
  t1_derrA_a1 = 0;
  t1_padrA_a1 = 0;
  for (t1_out_int=0; t1_out_int<NUMVBNK; t1_out_int=t1_out_int+1) begin
    t1_readA = t1_readA | (t1_readA_wire[t1_out_int] << t1_out_int);
    t1_writeA = t1_writeA | (t1_writeA_wire[t1_out_int] << t1_out_int);
    t1_addrA = t1_addrA | (t1_addrA_wire[t1_out_int] << (t1_out_int*BITSROW));
    t1_bwA = t1_bwA | (t1_bwA_wire[t1_out_int] << (t1_out_int*PHYWDTH));
    t1_dinA = t1_dinA | (t1_dinA_wire[t1_out_int] << (t1_out_int*PHYWDTH));
    t1_doutA_a1 = t1_doutA_a1 | (t1_doutA_a1_wire[t1_out_int] << (t1_out_int*WIDTH));
    t1_fwrdA_a1 = t1_fwrdA_a1 | (t1_fwrdA_a1_wire[t1_out_int] << t1_out_int);
    t1_serrA_a1 = t1_serrA_a1 | (t1_serrA_a1_wire[t1_out_int] << t1_out_int);
    t1_derrA_a1 = t1_derrA_a1 | (t1_derrA_a1_wire[t1_out_int] << t1_out_int);
    t1_padrA_a1 = t1_padrA_a1 | (t1_padrA_a1_wire[t1_out_int] << (t1_out_int*(BITSROW+BITWRDS)));
  end
end

wire [WIDTH-1:0] t2_doutA_a1_wire [0:2-1];
wire t2_fwrdA_a1_wire [0:2-1];
wire t2_serrA_a1_wire [0:2-1];
wire t2_derrA_a1_wire [0:2-1];
wire [BITVROW-1:0] t2_padrA_a1_wire [0:2-1];
wire [(BITVBNK+1)-1:0] t3_doutA_a1_wire [0:2-1];
wire t3_fwrdA_a1_wire [0:2-1];
wire t3_serrA_a1_wire [0:2-1];
wire t3_derrA_a1_wire [0:2-1];
wire [BITVROW-1:0] t3_padrA_a1_wire [0:2-1];
wire t2_readA_wire [0:2-1];
wire t2_writeA_wire [0:2-1];
wire [BITVROW-1:0] t2_addrA_wire [0:2-1];
wire [SDOUT_WIDTH+WIDTH-1:0] t2_bwA_wire [0:2-1];
wire [SDOUT_WIDTH+WIDTH-1:0] t2_dinA_wire [0:2-1];

wire [SDOUT_WIDTH+WIDTH-1:0] t2_dinA_wire_0 = t2_dinA_wire[0];
wire [SDOUT_WIDTH+WIDTH-1:0] t2_dinA_wire_1 = t2_dinA_wire[1];

genvar t2;
generate for (t2=0; t2<2; t2=t2+1) begin: t2_loop
  wire t2_readA_a1_wire = t2_readA_a1 >> t2;
  wire t2_writeA_a1_wire = t2_writeA_a1 >> t2;
  wire [BITVROW-1:0] t2_addrA_a1_wire = t2_addrA_a1 >> (t2*BITVROW);
  wire [WIDTH-1:0] t2_dinA_a1_wire = t2_dinA_a1 >> (t2*WIDTH);
  wire [BITVBNK:0] t3_dinA_a1_wire = t3_dinA_a1 >> (t2*(BITVBNK+1));

  wire [WIDTH-1:0] t2_doutA_wire = t2_doutA >> (t2*(SDOUT_WIDTH+WIDTH));
  wire [SDOUT_WIDTH-1:0] t3_doutA_wire = t2_doutA >> (t2*(SDOUT_WIDTH+WIDTH)+WIDTH);

  if (1) begin: align_loop
    infra_align_ecc_1rw #(.WIDTH (WIDTH), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                          .NUMSROW (NUMVROW), .BITSROW (BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITVROW),
                          .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (0), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1))
      infrad (.write (t2_writeA_a1_wire), .wr_adr (t2_addrA_a1_wire), .din (t2_dinA_a1_wire),
              .read (t2_readA_a1_wire), .rd_adr (t2_addrA_a1_wire), .rd_dout (t2_doutA_a1_wire[t2]), .rd_fwrd (t2_fwrdA_a1_wire[t2]),
              .rd_serr (t2_serrA_a1_wire[t2]), .rd_derr (t2_derrA_a1_wire[t2]), .rd_padr (t2_padrA_a1_wire[t2]),
              .mem_read (t2_readA_wire[t2]), .mem_write (t2_writeA_wire[t2]), .mem_addr (t2_addrA_wire[t2]),
	      .mem_bw (t2_bwA_wire[t2][WIDTH-1:0]), .mem_din (t2_dinA_wire[t2][WIDTH-1:0]), .mem_dout (t2_doutA_wire),
              .select_addr (select_vrow),
              .clk (clk), .rst (rst));

    infra_align_ecc_1rw #(.WIDTH (BITVBNK+1), .ENADEC (1), .ECCWDTH (ECCBITS), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                          .NUMSROW (NUMVROW), .BITSROW (BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITVROW),
                          .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (0), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1))
      infras (.write (t2_writeA_a1_wire), .wr_adr (t2_addrA_a1_wire), .din (t3_dinA_a1_wire),
              .read (t2_readA_a1_wire), .rd_adr (t2_addrA_a1_wire), .rd_dout (t3_doutA_a1_wire[t2]), .rd_fwrd (t3_fwrdA_a1_wire[t2]),
              .rd_serr (t3_serrA_a1_wire[t2]), .rd_derr (t3_derrA_a1_wire[t2]), .rd_padr (t3_padrA_a1_wire[t2]),
              .mem_read (), .mem_write (), .mem_addr (),
	      .mem_bw (t2_bwA_wire[t2][SDOUT_WIDTH+WIDTH-1:WIDTH]), .mem_din (t2_dinA_wire[t2][SDOUT_WIDTH+WIDTH-1:WIDTH]), .mem_dout (t3_doutA_wire),
              .select_addr (select_vrow),
              .clk (clk), .rst (rst));
  end
end
endgenerate

reg [2-1:0] t2_readA;
reg [2-1:0] t2_writeA;
reg [2*BITVROW-1:0] t2_addrA;
reg [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_bwA;
reg [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA;

integer t2_out_int;
always_comb begin
  t2_readA = 0;
  t2_writeA = 0;
  t2_addrA = 0;
  t2_bwA = 0;
  t2_dinA = 0;
  t2_doutA_a1 = 0;
  t2_fwrdA_a1 = 0;
  t2_serrA_a1 = 0;
  t2_derrA_a1 = 0;
  t2_padrA_a1 = 0;
  t3_doutA_a1 = 0;
  t3_fwrdA_a1 = 0;
  t3_serrA_a1 = 0;
  t3_derrA_a1 = 0;
  t3_padrA_a1 = 0;
  for (t2_out_int=0; t2_out_int<2; t2_out_int=t2_out_int+1) begin
    t2_readA = t2_readA | (t2_readA_wire[t2_out_int] << t2_out_int);
    t2_writeA = t2_writeA | (t2_writeA_wire[t2_out_int] << t2_out_int);
    t2_addrA = t2_addrA | (t2_addrA_wire[t2_out_int] << (t2_out_int*BITVROW));
    t2_bwA = t2_bwA | (t2_bwA_wire[t2_out_int] << (t2_out_int*(SDOUT_WIDTH+WIDTH)));
    t2_dinA = t2_dinA | (t2_dinA_wire[t2_out_int] << (t2_out_int*(SDOUT_WIDTH+WIDTH)));
    t2_doutA_a1 = t2_doutA_a1 | (t2_doutA_a1_wire[t2_out_int] << (t2_out_int*WIDTH));
    t2_fwrdA_a1 = t2_fwrdA_a1 | (t2_fwrdA_a1_wire[t2_out_int] << t2_out_int);
    t2_serrA_a1 = t2_serrA_a1 | (t2_serrA_a1_wire[t2_out_int] << t2_out_int);
    t2_derrA_a1 = t2_derrA_a1 | (t2_derrA_a1_wire[t2_out_int] << t2_out_int);
    t2_padrA_a1 = t2_padrA_a1 | (t2_padrA_a1_wire[t2_out_int] << (t2_out_int*(BITSROW+BITWRDS)));
    t3_doutA_a1 = t3_doutA_a1 | (t3_doutA_a1_wire[t2_out_int] << (t2_out_int*(BITVBNK+1)));
    t3_fwrdA_a1 = t3_fwrdA_a1 | (t3_fwrdA_a1_wire[t2_out_int] << t2_out_int);
    t3_serrA_a1 = t3_serrA_a1 | (t3_serrA_a1_wire[t2_out_int] << t2_out_int);
    t3_derrA_a1 = t3_derrA_a1 | (t3_derrA_a1_wire[t2_out_int] << t2_out_int);
    t3_padrA_a1 = t3_padrA_a1 | (t3_padrA_a1_wire[t2_out_int] << (t2_out_int*(BITSROW+BITWRDS)));
  end
end

endmodule
