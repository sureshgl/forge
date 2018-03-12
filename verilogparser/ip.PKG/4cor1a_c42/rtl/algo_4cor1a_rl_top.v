module algo_4cor1a_rl_top (clk, rst, ready,
                           cnt, ct_adr, imm, ct_vld, ct_serr, ct_derr,
                           read, write, addr, din, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                           t1_readA, t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_doutA,
                           t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
                           t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCDWDH = 7;
  parameter ECCSWDH = 7;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMCTPT = 4;
  parameter BITCTPT = 2;
  parameter NUMVROW = 1024;   // ALGO2 Parameters
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter NUMWRDS = 4;      // ALIGN Parameters
  parameter BITWRDS = 2;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCDWDH : WIDTH;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;
  parameter SDOUT_WIDTH = BITVBNK+1;
  parameter STAWDTH = 2*SDOUT_WIDTH+ECCSWDH;
  parameter SRAM_DELAY = 2;
  parameter FLOPADD = 1;
  parameter FLOPECC = 1;
  parameter FLOPIN = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;

  parameter BITPADR2 = BITPBNK+BITSROW+BITWRDS;
  parameter BITPADR1 = BITCTPT+BITPADR2+1;

  input [NUMCTPT-1:0]                  cnt;
  input [NUMCTPT*BITADDR-1:0]          ct_adr;
  input [NUMCTPT*WIDTH-1:0]            imm;
  output [NUMCTPT-1:0]                 ct_vld;
  output [NUMCTPT-1:0]                 ct_serr;
  output [NUMCTPT-1:0]                 ct_derr;

  input                                read;
  input                                write;
  input [BITADDR-1:0]                  addr;
  input [WIDTH-1:0]                    din;
  output                               rd_vld;
  output [WIDTH-1:0]                   rd_dout;
  output                               rd_serr;
  output                               rd_derr;
  output [BITPADR1-1:0]                rd_padr;

  output                               ready;
  input                                clk, rst;

  output [NUMCTPT*NUMVBNK-1:0] t1_readA;
  output [NUMCTPT*NUMVBNK-1:0] t1_writeA;
  output [NUMCTPT*NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMCTPT*NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMCTPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input [NUMCTPT*NUMVBNK*PHYWDTH-1:0] t1_doutA;

  output [NUMCTPT-1:0] t2_writeA;
  output [NUMCTPT*BITVROW-1:0] t2_addrA;
  output [NUMCTPT*MEMWDTH-1:0] t2_dinA;

  output [NUMCTPT-1:0] t2_readB;
  output [NUMCTPT*BITVROW-1:0] t2_addrB;
  input [NUMCTPT*MEMWDTH-1:0] t2_doutB;

  output [NUMCTPT-1:0] t3_writeA;
  output [NUMCTPT*BITVROW-1:0] t3_addrA;
  output [NUMCTPT*STAWDTH-1:0] t3_dinA;

  output [NUMCTPT-1:0] t3_readB;
  output [NUMCTPT*BITVROW-1:0] t3_addrB;
  input [NUMCTPT*STAWDTH-1:0] t3_doutB;

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

wire [NUMCTPT-1:0] a2_ready;

wire [NUMCTPT-1:0] t1_writeA_a1;
wire [NUMCTPT*BITADDR-1:0] t1_addrA_a1;
wire [NUMCTPT*WIDTH-1:0] t1_dinA_a1;
wire [NUMCTPT-1:0] t1_readB_a1;
wire [NUMCTPT*BITADDR-1:0] t1_addrB_a1;
reg [NUMCTPT*WIDTH-1:0] t1_doutB_a1;
reg [NUMCTPT-1:0] t1_fwrdB_a1;
reg [NUMCTPT-1:0] t1_serrB_a1;
reg [NUMCTPT-1:0] t1_derrB_a1;
reg [NUMCTPT*BITPADR2-1:0] t1_padrB_a1;

generate if (1) begin: a1_loop

  algo_ncor1a_1r1w #(.BITWDTH (BITWDTH), .WIDTH (WIDTH), .NUMCTPT (NUMCTPT), .BITCTPT (BITCTPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR), .BITPADR (BITPADR1-1),
                     .SRAM_DELAY (SRAM_DELAY+FLOPECC), .FLOPADD (FLOPADD), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    algo (.clk(clk), .rst(rst || !(&a2_ready)), .ready(ready),
          .cnt(cnt), .ct_adr(ct_adr), .imm(imm), .ct_vld(ct_vld), .ct_serr(ct_serr), .ct_derr(ct_derr),
          .read(read), .write(write), .addr(addr), .din(din), .rd_vld(rd_vld), .rd_dout(rd_dout),
          .rd_fwrd(rd_padr[BITPADR1-1]), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr[BITPADR1-2:0]),
          .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
          .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1),
          .t1_fwrdB(t1_fwrdB_a1), .t1_serrB(t1_serrB_a1), .t1_derrB(t1_derrB_a1), .t1_padrB(t1_padrB_a1),
          .select_addr(select_addr), .select_bit(select_bit));

end
endgenerate

wire [WIDTH-1:0] t1_doutB_a1_wire [0:NUMCTPT-1];
wire t1_fwrdB_a1_wire [0:NUMCTPT-1];
wire t1_serrB_a1_wire [0:NUMCTPT-1];
wire t1_derrB_a1_wire [0:NUMCTPT-1];
wire [BITPADR2-1:0] t1_padrB_a1_wire [0:NUMCTPT-1];

integer a1w;
always_comb begin
  t1_doutB_a1 = 0;
  t1_fwrdB_a1 = 0;
  t1_serrB_a1 = 0;
  t1_derrB_a1 = 0;
  t1_padrB_a1 = 0;
  for (a1w=0; a1w<NUMCTPT; a1w=a1w+1) begin
    t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[a1w] << (a1w*WIDTH));
    t1_fwrdB_a1 = t1_fwrdB_a1 | (t1_fwrdB_a1_wire[a1w] << a1w);
    t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_wire[a1w] << a1w);
    t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[a1w] << a1w);
    t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_wire[a1w] << (a1w*BITPADR2));
  end
end

wire [NUMVBNK-1:0] t1_readA_a2 [0:NUMCTPT-1];
wire [NUMVBNK-1:0] t1_writeA_a2 [0:NUMCTPT-1];
wire [NUMVBNK*BITVROW-1:0] t1_addrA_a2 [0:NUMCTPT-1];
wire [NUMVBNK*WIDTH-1:0] t1_dinA_a2 [0:NUMCTPT-1];
reg [NUMVBNK*WIDTH-1:0] t1_doutA_a2 [0:NUMCTPT-1];
reg [NUMVBNK-1:0] t1_fwrdA_a2 [0:NUMCTPT-1];
reg [NUMVBNK-1:0] t1_serrA_a2 [0:NUMCTPT-1];
reg [NUMVBNK-1:0] t1_derrA_a2 [0:NUMCTPT-1];
reg [NUMVBNK*(BITSROW+BITWRDS)-1:0] t1_padrA_a2 [0:NUMCTPT-1];

wire t2_writeA_a2 [0:NUMCTPT-1];
wire [BITVROW-1:0] t2_addrA_a2 [0:NUMCTPT-1];
wire [WIDTH-1:0] t2_dinA_a2 [0:NUMCTPT-1];
wire t2_readB_a2 [0:NUMCTPT-1];
wire [BITVROW-1:0] t2_addrB_a2 [0:NUMCTPT-1];
reg [WIDTH-1:0] t2_doutB_a2 [0:NUMCTPT-1];
reg t2_fwrdB_a2 [0:NUMCTPT-1];
reg t2_serrB_a2 [0:NUMCTPT-1];
reg t2_derrB_a2 [0:NUMCTPT-1];
reg [BITSROW+BITWRDS-1:0] t2_padrB_a2 [0:NUMCTPT-1];

wire t3_writeA_a2 [0:NUMCTPT-1];
wire [BITVROW-1:0] t3_addrA_a2 [0:NUMCTPT-1];
wire [(BITVBNK+1)-1:0] t3_dinA_a2 [0:NUMCTPT-1];
wire t3_readB_a2 [0:NUMCTPT-1];
wire [BITVROW-1:0] t3_addrB_a2 [0:NUMCTPT-1];
reg [(BITVBNK+1)-1:0] t3_doutB_a2 [0:NUMCTPT-1];
reg t3_fwrdB_a2 [0:NUMCTPT-1];
reg t3_serrB_a2 [0:NUMCTPT-1];
reg t3_derrB_a2 [0:NUMCTPT-1];
reg [BITSROW+BITWRDS-1:0] t3_padrB_a2 [0:NUMCTPT-1];

genvar a2v;
generate
  for (a2v=0; a2v<NUMCTPT; a2v=a2v+1) begin: a2_loop
    wire t1_writeA_a1_wire = t1_writeA_a1 >> a2v;
    wire [BITADDR-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> (a2v*BITADDR);
    wire [WIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> (a2v*WIDTH);
    wire t1_readB_a1_wire = t1_readB_a1 >> a2v;
    wire [BITADDR-1:0] t1_addrB_a1_wire = t1_addrB_a1 >> (a2v*BITADDR);

    algo_1r1u_rl #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                   .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR2),
                   .SRAM_DELAY (FLOPECC+SRAM_DELAY), .FLOPIN (0), .FLOPOUT (0))
      algo (.write(t1_writeA_a1_wire), .din(t1_dinA_a1_wire), .read(t1_readB_a1_wire), .rd_adr(t1_addrB_a1_wire),
            .rd_vld(), .rd_dout(t1_doutB_a1_wire[a2v]), .rd_fwrd(t1_fwrdB_a1_wire[a2v]),
            .rd_serr(t1_serrB_a1_wire[a2v]), .rd_derr(t1_derrB_a1_wire[a2v]), .rd_padr(t1_padrB_a1_wire[a2v]),
            .t1_readA(t1_readA_a2[a2v]), .t1_writeA(t1_writeA_a2[a2v]), .t1_addrA(t1_addrA_a2[a2v]), .t1_dinA(t1_dinA_a2[a2v]),
            .t1_doutA(t1_doutA_a2[a2v]), .t1_fwrdA(t1_fwrdA_a2[a2v]), .t1_serrA(t1_serrA_a2[a2v]), .t1_derrA(t1_derrA_a2[a2v]), .t1_padrA(t1_padrA_a2[a2v]),
            .t2_writeA(t2_writeA_a2[a2v]), .t2_addrA(t2_addrA_a2[a2v]), .t2_dinA(t2_dinA_a2[a2v]), .t2_readB(t2_readB_a2[a2v]), .t2_addrB(t2_addrB_a2[a2v]),
            .t2_doutB(t2_doutB_a2[a2v]), .t2_fwrdB(t2_fwrdB_a2[a2v]), .t2_serrB(t2_serrB_a2[a2v]), .t2_derrB(t2_derrB_a2[a2v]), .t2_padrB(t2_padrB_a2[a2v]),
            .t3_writeA(t3_writeA_a2[a2v]), .t3_addrA(t3_addrA_a2[a2v]), .t3_dinA(t3_dinA_a2[a2v]), .t3_readB(t3_readB_a2[a2v]), .t3_addrB(t3_addrB_a2[a2v]),
            .t3_doutB(t3_doutB_a2[a2v]), .t3_fwrdB(t3_fwrdB_a2[a2v]), .t3_serrB(t3_serrB_a2[a2v]), .t3_derrB(t3_derrB_a2[a2v]), .t3_padrB(t3_padrB_a2[a2v]),
            .clk (clk), .rst (rst), .ready (a2_ready[a2v]),
            .select_addr (select_addr), .select_bit (select_bit));
  end
endgenerate

wire [WIDTH-1:0] t1_doutA_a2_wire [0:NUMCTPT-1][0:NUMVBNK-1];
wire t1_fwrdA_a2_wire [0:NUMCTPT-1][0:NUMVBNK-1];
wire t1_serrA_a2_wire [0:NUMCTPT-1][0:NUMVBNK-1];
wire t1_derrA_a2_wire [0:NUMCTPT-1][0:NUMVBNK-1];
wire [BITSROW+BITWRDS-1:0] t1_padrA_a2_wire [0:NUMCTPT-1][0:NUMVBNK-1];
wire t1_readA_wire [0:NUMCTPT-1][0:NUMVBNK-1];
wire t1_writeA_wire [0:NUMCTPT-1][0:NUMVBNK-1];
wire [BITSROW-1:0] t1_addrA_wire [0:NUMCTPT-1][0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_bwA_wire [0:NUMCTPT-1][0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_dinA_wire [0:NUMCTPT-1][0:NUMVBNK-1];

genvar t1c, t1b;
generate
  for (t1c=0; t1c<NUMCTPT; t1c=t1c+1) begin: t1c_loop
    for (t1b=0; t1b<NUMVBNK; t1b=t1b+1) begin: t1b_loop
      wire t1_readA_a2_wire = t1_readA_a2[t1c] >> t1b;
      wire t1_writeA_a2_wire = t1_writeA_a2[t1c] >> t1b;
      wire [BITVROW-1:0] t1_addrA_a2_wire = t1_addrA_a2[t1c] >> (t1b*BITVROW);
      wire [WIDTH-1:0] t1_dinA_a2_wire = t1_dinA_a2[t1c] >> (t1b*WIDTH);

      wire [NUMWRDS*MEMWDTH-1:0] t1_doutA_wire = t1_doutA >> ((t1c*NUMVBNK+t1b)*PHYWDTH);

      if (1) begin: align_loop
        infra_align_ecc_dwsn #(.WIDTH (WIDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCDWDH), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                               .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITSROW+BITWRDS),
                               .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC))
          infra (.read (t1_readA_a2_wire), .write (t1_writeA_a2_wire), .addr (t1_addrA_a2_wire), .din (t1_dinA_a2_wire),
                 .rd_dout (t1_doutA_a2_wire[t1c][t1b]), .rd_fwrd (t1_fwrdA_a2_wire[t1c][t1b]),
                 .rd_serr (t1_serrA_a2_wire[t1c][t1b]), .rd_derr (t1_derrA_a2_wire[t1c][t1b]), .rd_padr (t1_padrA_a2_wire[t1c][t1b]),
                 .mem_read (t1_readA_wire[t1c][t1b]), .mem_write (t1_writeA_wire[t1c][t1b]), .mem_addr (t1_addrA_wire[t1c][t1b]),
                 .mem_dwsn (), .mem_bw (t1_bwA_wire[t1c][t1b]), .mem_din (t1_dinA_wire[t1c][t1b]), .mem_dout (t1_doutA_wire), .mem_serr(),
                 .select_addr (select_vrow),
                 .clk (clk), .rst (rst));
      end
    end
  end
endgenerate

reg [NUMCTPT*NUMVBNK-1:0] t1_readA;
reg [NUMCTPT*NUMVBNK-1:0] t1_writeA;
reg [NUMCTPT*NUMVBNK*BITSROW-1:0] t1_addrA;
reg [NUMCTPT*NUMVBNK*PHYWDTH-1:0] t1_bwA;
reg [NUMCTPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;
integer t1c_int, t1b_int;
always_comb begin
  t1_readA = 0;
  t1_writeA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  for (t1c_int=0; t1c_int<NUMCTPT; t1c_int=t1c_int+1) begin
    t1_doutA_a2[t1c_int] = 0;
    t1_fwrdA_a2[t1c_int] = 0;
    t1_serrA_a2[t1c_int] = 0;
    t1_derrA_a2[t1c_int] = 0;
    t1_padrA_a2[t1c_int] = 0;
    for (t1b_int=0; t1b_int<NUMVBNK; t1b_int=t1b_int+1) begin
      t1_readA = t1_readA | (t1_readA_wire[t1c_int][t1b_int] << (t1c_int*NUMVBNK+t1b_int));
      t1_writeA = t1_writeA | (t1_writeA_wire[t1c_int][t1b_int] << (t1c_int*NUMVBNK+t1b_int));
      t1_addrA = t1_addrA | (t1_addrA_wire[t1c_int][t1b_int] << ((t1c_int*NUMVBNK+t1b_int)*BITSROW));
      t1_bwA = t1_bwA | (t1_bwA_wire[t1c_int][t1b_int] << ((t1c_int*NUMVBNK+t1b_int)*PHYWDTH));
      t1_dinA = t1_dinA | (t1_dinA_wire[t1c_int][t1b_int] << ((t1c_int*NUMVBNK+t1b_int)*PHYWDTH));
      t1_doutA_a2[t1c_int] = t1_doutA_a2[t1c_int] | (t1_doutA_a2_wire[t1c_int][t1b_int] << (t1b_int*WIDTH));
      t1_fwrdA_a2[t1c_int] = t1_fwrdA_a2[t1c_int] | (t1_fwrdA_a2_wire[t1c_int][t1b_int] << t1b_int);
      t1_serrA_a2[t1c_int] = t1_serrA_a2[t1c_int] | (t1_serrA_a2_wire[t1c_int][t1b_int] << t1b_int);
      t1_derrA_a2[t1c_int] = t1_derrA_a2[t1c_int] | (t1_derrA_a2_wire[t1c_int][t1b_int] << t1b_int);
      t1_padrA_a2[t1c_int] = t1_padrA_a2[t1c_int] | (t1_padrA_a2_wire[t1c_int][t1b_int] << (t1b_int*(BITSROW+BITWRDS)));
    end
  end
end

wire [WIDTH-1:0] t2_doutB_a2_wire [0:NUMCTPT-1][0:1-1];
wire t2_fwrdB_a2_wire [0:NUMCTPT-1][0:1-1];
wire t2_serrB_a2_wire [0:NUMCTPT-1][0:1-1];
wire t2_derrB_a2_wire [0:NUMCTPT-1][0:1-1];
wire [BITVROW-1:0] t2_padrB_a2_wire [0:NUMCTPT-1][0:1-1];
wire t2_writeA_wire [0:NUMCTPT-1][0:1-1];
wire [BITVROW-1:0] t2_addrA_wire [0:NUMCTPT-1][0:1-1];
wire [MEMWDTH-1:0] t2_dinA_wire [0:NUMCTPT-1][0:1-1];
wire t2_readB_wire [0:NUMCTPT-1][0:1-1];
wire [BITVROW-1:0] t2_addrB_wire [0:NUMCTPT-1][0:1-1];

genvar t2c, t2b;
generate
  for (t2c=0; t2c<NUMCTPT; t2c=t2c+1) begin: t2c_loop
    for (t2b=0; t2b<1; t2b=t2b+1) begin: t2b_loop
      wire t2_writeA_a2_wire = t2_writeA_a2[t2c] >> t2b;
      wire [BITVROW-1:0] t2_addrA_a2_wire = t2_addrA_a2[t2c] >> (t2b*BITVROW);
      wire [WIDTH-1:0] t2_dinA_a2_wire = t2_dinA_a2[t2c] >> (t2b*WIDTH);

      wire t2_readB_a2_wire = t2_readB_a2[t2c] >> t2b;
      wire [BITVROW-1:0] t2_addrB_a2_wire = t2_addrB_a2[t2c] >> (t2b*BITVROW);

      wire [MEMWDTH-1:0] t2_doutB_wire = t2_doutB >> ((t2c*1+t2b)*MEMWDTH);

      wire mem_write_wire;
      wire [BITVROW-1:0] mem_wr_adr_wire;
      wire [MEMWDTH-1:0] mem_bw_wire;
      wire [MEMWDTH-1:0] mem_din_wire;
      wire mem_read_wire;
      wire [BITVROW-1:0] mem_rd_adr_wire;
      wire [MEMWDTH-1:0] mem_rd_dout_wire;
      wire mem_rd_fwrd_wire;
      wire mem_rd_serr_wire;
      wire mem_rd_derr_wire;
      wire [BITVROW-1:0] mem_rd_padr_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH (WIDTH), .ENAPSDO (1), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCDWDH), .ENAPADR (1),
                               .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                               .NUMSROW (NUMVROW), .BITSROW (BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITVROW),
                               .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPGEN (FLOPECC), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.write(t2_writeA_a2_wire), .wr_adr(t2_addrA_a2_wire), .din(t2_dinA_a2_wire), .read(t2_readB_a2_wire), .rd_adr(t2_addrB_a2_wire),
                 .rd_dout(t2_doutB_a2_wire[t2c][t2b]), .rd_fwrd(t2_fwrdB_a2_wire[t2c][t2b]),
                 .rd_serr(t2_serrB_a2_wire[t2c][t2b]), .rd_derr(t2_derrB_a2_wire[t2c][t2b]), .rd_padr(t2_padrB_a2_wire[t2c][t2b]),
                 .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
                 .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (MEMWDTH), .ENAPSDO (0), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                           .NUMWROW (NUMVROW), .BITWROW (BITVROW), .NUMWBNK (1), .BITWBNK (0),
                           .SRAM_DELAY (SRAM_DELAY), .FLOPMEM (FLOPMEM), .RSTZERO (1))
          infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
                 .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
                 .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr(mem_rd_derr_wire), .rd_padr(mem_rd_padr_wire),
                 .mem_write (t2_writeA_wire[t2c][t2b]), .mem_wr_adr(t2_addrA_wire[t2c][t2b]), .mem_bw (), .mem_din (t2_dinA_wire[t2c][t2b]),
                 .mem_read (t2_readB_wire[t2c][t2b]), .mem_rd_adr(t2_addrB_wire[t2c][t2b]), .mem_rd_dout (t2_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_vrow));
      end
    end
  end
endgenerate

reg [NUMCTPT-1:0] t2_writeA;
reg [NUMCTPT*BITVROW-1:0] t2_addrA;
reg [NUMCTPT*MEMWDTH-1:0] t2_dinA;
reg [NUMCTPT-1:0] t2_readB;
reg [NUMCTPT*BITVROW-1:0] t2_addrB;
integer t2c_int, t2b_int;
always_comb begin
  t2_writeA = 0;
  t2_addrA = 0;
  t2_dinA = 0;
  t2_readB = 0;
  t2_addrB = 0;
  for (t2c_int=0; t2c_int<NUMCTPT; t2c_int=t2c_int+1) begin
    t2_doutB_a2[t2c_int] = 0;
    t2_fwrdB_a2[t2c_int] = 0;
    t2_serrB_a2[t2c_int] = 0;
    t2_derrB_a2[t2c_int] = 0;
    t2_padrB_a2[t2c_int] = 0;
    for (t2b_int=0; t2b_int<1; t2b_int=t2b_int+1) begin
      t2_writeA = t2_writeA | (t2_writeA_wire[t2c_int][t2b_int] << (t2c_int*1+t2b_int));
      t2_addrA = t2_addrA | (t2_addrA_wire[t2c_int][t2b_int] << ((t2c_int*1+t2b_int)*BITVROW));
      t2_dinA = t2_dinA | (t2_dinA_wire[t2c_int][t2b_int] << ((t2c_int*1+t2b_int)*MEMWDTH));
      t2_readB = t2_readB | (t2_readB_wire[t2c_int][t2b_int] << (t2c_int*1+t2b_int));
      t2_addrB = t2_addrB | (t2_addrB_wire[t2c_int][t2b_int] << ((t2c_int*1+t2b_int)*BITVROW));
      t2_doutB_a2[t2c_int] = t2_doutB_a2[t2c_int] | (t2_doutB_a2_wire[t2c_int][t2b_int] << (t2b_int*WIDTH));
      t2_fwrdB_a2[t2c_int] = t2_fwrdB_a2[t2c_int] | (t2_fwrdB_a2_wire[t2c_int][t2b_int] << t2b_int);
      t2_serrB_a2[t2c_int] = t2_serrB_a2[t2c_int] | (t2_serrB_a2_wire[t2c_int][t2b_int] << t2b_int);
      t2_derrB_a2[t2c_int] = t2_derrB_a2[t2c_int] | (t2_derrB_a2_wire[t2c_int][t2b_int] << t2b_int);
      t2_padrB_a2[t2c_int] = t2_padrB_a2[t2c_int] | (t2_padrB_a2_wire[t2c_int][t2b_int] << (t2b_int*BITVROW));
    end
  end
end

wire [SDOUT_WIDTH-1:0] t3_doutB_a2_wire [0:NUMCTPT-1][0:1-1];
wire t3_fwrdB_a2_wire [0:NUMCTPT-1][0:1-1];
wire t3_serrB_a2_wire [0:NUMCTPT-1][0:1-1];
wire t3_derrB_a2_wire [0:NUMCTPT-1][0:1-1];
wire [BITVROW-1:0] t3_padrB_a2_wire [0:NUMCTPT-1][0:1-1];
wire t3_writeA_wire [0:NUMCTPT-1][0:1-1];
wire [BITVROW-1:0] t3_addrA_wire [0:NUMCTPT-1][0:1-1];
wire [STAWDTH-1:0] t3_dinA_wire [0:NUMCTPT-1][0:1-1];
wire t3_readB_wire [0:NUMCTPT-1][0:1-1];
wire [BITVROW-1:0] t3_addrB_wire [0:NUMCTPT-1][0:1-1];

genvar t3c, t3b;
generate
  for (t3c=0; t3c<NUMCTPT; t3c=t3c+1) begin: t3c_loop
    for (t3b=0; t3b<1; t3b=t3b+1) begin: t3b_loop
      wire t3_writeA_a2_wire = t3_writeA_a2[t3c] >> t3b;
      wire [BITVROW-1:0] t3_addrA_a2_wire = t3_addrA_a2[t3c] >> (t3b*BITVROW);
      wire [SDOUT_WIDTH-1:0] t3_dinA_a2_wire = t3_dinA_a2[t3c] >> (t3b*SDOUT_WIDTH);

      wire t3_readB_a2_wire = t3_readB_a2[t3c] >> t3b;
      wire [BITVROW-1:0] t3_addrB_a2_wire = t3_addrB_a2[t3c] >> (t3b*BITVROW);

      wire [STAWDTH-1:0] t3_doutB_wire = t3_doutB >> ((t3c*1+t3b)*STAWDTH);

      wire mem_write_wire;
      wire [BITVROW-1:0] mem_wr_adr_wire;
      wire [STAWDTH-1:0] mem_bw_wire;
      wire [STAWDTH-1:0] mem_din_wire;
      wire mem_read_wire;
      wire [BITVROW-1:0] mem_rd_adr_wire;
      wire [STAWDTH-1:0] mem_rd_dout_wire;
      wire mem_rd_fwrd_wire;
      wire mem_rd_serr_wire;
      wire mem_rd_derr_wire;
      wire [BITVROW-1:0] mem_rd_padr_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH (SDOUT_WIDTH), .ENAPSDO (1), .ENAPAR (0), .ENAECC (0), .ENADEC (1), .ECCWDTH (ECCSWDH), .ENAPADR (1),
                               .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                               .NUMSROW (NUMVROW), .BITSROW (BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITVROW),
                               .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.write(t3_writeA_a2_wire), .wr_adr(t3_addrA_a2_wire), .din(t3_dinA_a2_wire), .read(t3_readB_a2_wire), .rd_adr(t3_addrB_a2_wire),
                 .rd_dout(t3_doutB_a2_wire[t3c][t3b]), .rd_fwrd(t3_fwrdB_a2_wire[t3c][t3b]),
                 .rd_serr(t3_serrB_a2_wire[t3c][t3b]), .rd_derr(t3_derrB_a2_wire[t3c][t3b]), .rd_padr(t3_padrB_a2_wire[t3c][t3b]),
                 .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
                 .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (STAWDTH), .ENAPSDO (0), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                           .NUMWROW (NUMVROW), .BITWROW (BITVROW), .NUMWBNK (1), .BITWBNK (0),
                           .SRAM_DELAY (SRAM_DELAY), .FLOPMEM (FLOPMEM), .RSTZERO (1))
          infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
                 .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
                 .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr(mem_rd_derr_wire), .rd_padr(mem_rd_padr_wire),
                 .mem_write (t3_writeA_wire[t3c][t3b]), .mem_wr_adr(t3_addrA_wire[t3c][t3b]), .mem_bw (), .mem_din (t3_dinA_wire[t3c][t3b]),
                 .mem_read (t3_readB_wire[t3c][t3b]), .mem_rd_adr(t3_addrB_wire[t3c][t3b]), .mem_rd_dout (t3_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_vrow));
      end
    end
  end
endgenerate

reg [NUMCTPT-1:0] t3_writeA;
reg [NUMCTPT*BITVROW-1:0] t3_addrA;
reg [NUMCTPT*STAWDTH-1:0] t3_dinA;
reg [NUMCTPT-1:0] t3_readB;
reg [NUMCTPT*BITVROW-1:0] t3_addrB;
integer t3c_int, t3b_int;
always_comb begin
  t3_writeA = 0;
  t3_addrA = 0;
  t3_dinA = 0;
  t3_readB = 0;
  t3_addrB = 0;
  for (t3c_int=0; t3c_int<NUMCTPT; t3c_int=t3c_int+1) begin
    t3_doutB_a2[t3c_int] = 0;
    t3_fwrdB_a2[t3c_int] = 0;
    t3_serrB_a2[t3c_int] = 0;
    t3_derrB_a2[t3c_int] = 0;
    t3_padrB_a2[t3c_int] = 0;
    for (t3b_int=0; t3b_int<1; t3b_int=t3b_int+1) begin
      t3_writeA = t3_writeA | (t3_writeA_wire[t3c_int][t3b_int] << (t3c_int*1+t3b_int));
      t3_addrA = t3_addrA | (t3_addrA_wire[t3c_int][t3b_int] << ((t3c_int*1+t3b_int)*BITVROW));
      t3_dinA = t3_dinA | (t3_dinA_wire[t3c_int][t3b_int] << ((t3c_int*1+t3b_int)*STAWDTH));
      t3_readB = t3_readB | (t3_readB_wire[t3c_int][t3b_int] << (t3c_int*1+t3b_int));
      t3_addrB = t3_addrB | (t3_addrB_wire[t3c_int][t3b_int] << ((t3c_int*1+t3b_int)*BITVROW));
      t3_doutB_a2[t3c_int] = t3_doutB_a2[t3c_int] | (t3_doutB_a2_wire[t3c_int][t3b_int] << (t3b_int*SDOUT_WIDTH));
      t3_fwrdB_a2[t3c_int] = t3_fwrdB_a2[t3c_int] | (t3_fwrdB_a2_wire[t3c_int][t3b_int] << t3b_int);
      t3_serrB_a2[t3c_int] = t3_serrB_a2[t3c_int] | (t3_serrB_a2_wire[t3c_int][t3b_int] << t3b_int);
      t3_derrB_a2[t3c_int] = t3_derrB_a2[t3c_int] | (t3_derrB_a2_wire[t3c_int][t3b_int] << t3b_int);
      t3_padrB_a2[t3c_int] = t3_padrB_a2[t3c_int] | (t3_padrB_a2_wire[t3c_int][t3b_int] << (t3b_int*BITVROW));
    end
  end
end

endmodule

