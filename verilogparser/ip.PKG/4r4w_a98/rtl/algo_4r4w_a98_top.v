
module algo_4r4w_a98_top (clk, rst, ready,
                          write, wr_adr, din,
                          read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
			  t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
			  t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
			  t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter NUMWRDS = 4;      // ALIGN Parameters
  parameter BITWRDS = 2;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter PHYWDTH = NUMWRDS*WIDTH;
  parameter ECCBITS = 4;
  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;

  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input [4-1:0]                        write;
  input [4*BITADDR-1:0]                wr_adr;
  input [4*WIDTH-1:0]                  din;

  input [4-1:0]                        read;
  input [4*BITADDR-1:0]                rd_adr;
  output [4-1:0]                       rd_vld;
  output [4*WIDTH-1:0]                 rd_dout;
  output [4-1:0]                       rd_serr;
  output [4-1:0]                       rd_derr;
  output [4*BITPADR-1:0]               rd_padr;

  output                               ready;
  input                                clk, rst;

  output [4*NUMVBNK-1:0] t1_writeA;
  output [4*NUMVBNK*BITSROW-1:0] t1_addrA;
  output [4*NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [4*NUMVBNK*PHYWDTH-1:0] t1_dinA;

  output [4*NUMVBNK-1:0] t1_readB;
  output [4*NUMVBNK*BITSROW-1:0] t1_addrB;
  input [4*NUMVBNK*PHYWDTH-1:0] t1_doutB;

  output [2-1:0] t2_writeA;
  output [2*BITVROW-1:0] t2_addrA;
  output [2*WIDTH-1:0] t2_dinA;

  output [8-1:0] t2_readB;
  output [8*BITVROW-1:0] t2_addrB;
  input [8*WIDTH-1:0] t2_doutB;

  output [2-1:0] t3_writeA;
  output [2*BITVROW-1:0] t3_addrA;
  output [2*SDOUT_WIDTH-1:0] t3_dinA;

  output [8-1:0] t3_readB;
  output [8*BITVROW-1:0] t3_addrB;
  input [8*SDOUT_WIDTH-1:0] t3_doutB;

`ifdef FORMAL
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr == 0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit == 0));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
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

wire [2*NUMVBNK-1:0] t1_writeA_a1;
wire [2*NUMVBNK*BITVROW-1:0] t1_addrA_a1;
wire [2*NUMVBNK*WIDTH-1:0] t1_dinA_a1;
wire [4*NUMVBNK-1:0] t1_readB_a1;
wire [4*NUMVBNK*BITVROW-1:0] t1_addrB_a1;
reg [4*NUMVBNK*WIDTH-1:0] t1_doutB_a1;
reg [4*NUMVBNK-1:0] t1_serrB_a1;
reg [4*NUMVBNK-1:0] t1_derrB_a1;
reg [4*NUMVBNK*(BITSROW+BITWRDS)-1:0] t1_padrB_a1;

wire [8-1:0] t2_readB_a1;
wire [8*BITVROW-1:0] t2_addrB_a1;
wire [8*WIDTH-1:0] t2_doutB_a1;

wire [8-1:0] t3_readB_a1;
wire [8*BITVROW-1:0] t3_addrB_a1;
wire [8*SDOUT_WIDTH-1:0] t3_doutB_a1;

generate if (1) begin: a1_loop

algo_2nr4w_2r2w_2 #(.BITWDTH (BITWDTH), .WIDTH (WIDTH), .NUMDUPL (2), .NUMRDPT (2), .NUMWRPT (2), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
	          .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR-1),
	          .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPIN(FLOPIN), .FLOPOUT(FLOPOUT))
  algo (.clk(clk), .rst(rst), .ready(ready),
        .write(write), .wr_adr(wr_adr), .din(din),
        .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), 
        .rd_fwrd({rd_padr[4*BITPADR-1],rd_padr[3*BITPADR-1],rd_padr[2*BITPADR-1],rd_padr[BITPADR-1]}), .rd_serr(rd_serr), .rd_derr(rd_derr),
        .rd_padr({rd_padr[4*BITPADR-2:3*BITPADR],rd_padr[3*BITPADR-2:2*BITPADR],rd_padr[2*BITPADR-2:BITPADR],rd_padr[BITPADR-2:0]}),
	.t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
        .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1), .t1_padrB(t1_padrB_a1),
        .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB_a1), .t2_addrB(t2_addrB_a1), .t2_doutB(t2_doutB_a1),
        .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), .t3_readB(t3_readB_a1), .t3_addrB(t3_addrB_a1), .t3_doutB(t3_doutB_a1),
	.select_addr(select_addr), .select_bit(select_bit));

end
endgenerate

wire [2-1:0] t1_writeA_wire [0:2-1][0:NUMVBNK-1];
wire [2*BITSROW-1:0] t1_addrA_wire [0:2-1][0:NUMVBNK-1];
wire [2*NUMWRDS*WIDTH-1:0] t1_bwA_wire [0:2-1][0:NUMVBNK-1];
wire [2*NUMWRDS*WIDTH-1:0] t1_dinA_wire [0:2-1][0:NUMVBNK-1];
wire [2-1:0] t1_readB_wire [0:2-1][0:NUMVBNK-1];
wire [2*BITSROW-1:0] t1_addrB_wire [0:2-1][0:NUMVBNK-1];
wire [2*WIDTH-1:0] t1_doutB_a1_wire [0:2-1][0:NUMVBNK-1];
wire [2-1:0] t1_serrB_a1_wire [0:2-1][0:NUMVBNK-1];
wire [2-1:0] t1_derrB_a1_wire [0:2-1][0:NUMVBNK-1];
wire [2*(BITSROW+BITWRDS)-1:0] t1_padrB_a1_wire [0:2-1][0:NUMVBNK-1];

genvar t1r, t1b;
generate
  for (t1r=0; t1r<2; t1r=t1r+1) begin: t1r_loop
    for (t1b=0; t1b<NUMVBNK; t1b=t1b+1) begin: t1b_loop
      wire [2-1:0] t1_writeA_a1_wire = t1_writeA_a1 >> (2*t1b);
      wire [2*BITVROW-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> (2*t1b*BITVROW);
      wire [2*WIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> (2*t1b*WIDTH);
      wire [2-1:0] t1_readB_a1_wire = t1_readB_a1 >> 2*(2*t1b+t1r);
      wire [2*BITVROW-1:0] t1_addrB_a1_wire = t1_addrB_a1 >> 2*((2*t1b+t1r)*BITVROW);

      wire [2*NUMWRDS*WIDTH-1:0] t1_doutB_wire = t1_doutB >> 2*((t1r*NUMVBNK+t1b)*PHYWDTH);

      if (1) begin: align_loop
        infra_align_mrnw #(.WIDTH (WIDTH), .PARITY (0), .NUMADDR (NUMVROW), .BITADDR (BITVROW), .NUMRDPT (2), .NUMWRPT (2),
                           .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITSROW+BITWRDS),
                           .SRAM_DELAY (SRAM_DELAY), .FLOPMEM (FLOPMEM))
          infra (.write(t1_writeA_a1_wire), .wr_adr(t1_addrA_a1_wire), .din(t1_dinA_a1_wire),
                 .read(t1_readB_a1_wire), .rd_adr(t1_addrB_a1_wire),
                 .rd_dout(t1_doutB_a1_wire[t1r][t1b]), .rd_serr(t1_serrB_a1_wire[t1r][t1b]), .rd_padr(t1_padrB_a1_wire[t1r][t1b]),
                 .mem_write (t1_writeA_wire[t1r][t1b]), .mem_wr_adr(t1_addrA_wire[t1r][t1b]), .mem_bw (t1_bwA_wire[t1r][t1b]), .mem_din (t1_dinA_wire[t1r][t1b]),
                 .mem_read (t1_readB_wire[t1r][t1b]), .mem_rd_adr(t1_addrB_wire[t1r][t1b]), .mem_rd_dout (t1_doutB_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_vrow));
        assign t1_derrB_a1_wire[t1r][t1b] = 1'b0;
      end
    end
  end
endgenerate

reg [4*NUMVBNK-1:0] t1_writeA;
reg [4*NUMVBNK*BITSROW-1:0] t1_addrA;
reg [4*NUMVBNK*PHYWDTH-1:0] t1_bwA;
reg [4*NUMVBNK*PHYWDTH-1:0] t1_dinA;
reg [4*NUMVBNK-1:0] t1_readB;
reg [4*NUMVBNK*BITSROW-1:0] t1_addrB;
integer t1r_int, t1b_int;
always_comb begin
  t1_writeA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  t1_readB = 0;
  t1_addrB = 0;
  t1_doutB_a1 = 0;
  t1_serrB_a1 = 0;
  t1_derrB_a1 = 0;
  t1_padrB_a1 = 0;
  for (t1r_int=0; t1r_int<2; t1r_int=t1r_int+1) begin
    for (t1b_int=0; t1b_int<NUMVBNK; t1b_int=t1b_int+1) begin
      t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*2));
      t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*2*BITSROW));
      t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*2*PHYWDTH));
      t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*2*PHYWDTH));
    end
  end
  for (t1r_int=0; t1r_int<2; t1r_int=t1r_int+1) begin
    for (t1b_int=0; t1b_int<NUMVBNK; t1b_int=t1b_int+1) begin
      t1_readB = t1_readB | (t1_readB_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int)*2);
      t1_addrB = t1_addrB | (t1_addrB_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int)*2*BITSROW);
      t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[t1r_int][t1b_int] << ((2*t1b_int+t1r_int)*2*WIDTH));
      t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_wire[t1r_int][t1b_int] << ((2*t1b_int+t1r_int)*2));
      t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[t1r_int][t1b_int] << ((2*t1b_int+t1r_int)*2));
      t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_wire[t1r_int][t1b_int] << ((2*t1b_int+t1r_int)*2*(BITSROW+BITWRDS)));
    end
  end
end

assign t2_readB = t2_readB_a1;
assign t2_addrB = t2_addrB_a1;

assign t3_readB = t3_readB_a1;
assign t3_addrB = t3_addrB_a1;

generate if (FLOPMEM) begin: t2_t3_flp_loop
  reg [8*WIDTH-1:0] t2_doutB_reg;
  reg [8*SDOUT_WIDTH-1:0] t3_doutB_reg;
  always @(posedge clk) begin
    t2_doutB_reg <= t2_doutB;
    t3_doutB_reg <= t3_doutB;
  end
  
  assign t2_doutB_a1 = t2_doutB_reg;
  assign t3_doutB_a1 = t3_doutB_reg;
end else begin: t2_t3_noflp_loop
  assign t2_doutB_a1 = t2_doutB;
  assign t3_doutB_a1 = t3_doutB;
end
endgenerate

endmodule
