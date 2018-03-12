
module algo_2r2w_a653_top (clk, rst, ready,
                           write, wr_adr, din,
                           read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
		 	   t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
			   t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
			   t3_writeA, t3_addrA, t3_bwA, t3_dinA, t3_readB, t3_addrB, t3_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMRDPT = 2;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter NUMWRDS = 4;       // ALIGN Parameters
  parameter BITWRDS = 2;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;
  parameter NUMWROW = NUMSROW; // STACK Parameters
  parameter BITWROW = BITSROW;
  parameter NUMWBNK = 1;
  parameter BITWBNK = 0;
  parameter ECCBITS = 4;
  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;
  parameter FLOPOUT = 0;
  parameter CGFLOPI = 0;
  parameter CGFLOPC = 0;
  parameter CGFLOPM = 0;
  parameter CGFLOPE = 0;
  parameter CGFLOPO = 0;

  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;
  parameter CDOUT_WIDTH = 2*(WIDTH)+ECCWDTH;

  input [2-1:0]                        write;
  input [2*BITADDR-1:0]                wr_adr;
  input [2*WIDTH-1:0]                  din;

  input [NUMRDPT-1:0]                  read;
  input [NUMRDPT*BITADDR-1:0]          rd_adr;
  output [NUMRDPT-1:0]                 rd_vld;
  output [NUMRDPT*WIDTH-1:0]           rd_dout;
  output [NUMRDPT-1:0]                 rd_serr;
  output [NUMRDPT-1:0]                 rd_derr;
  output [NUMRDPT*BITPADR-1:0]         rd_padr;

  output                               ready;
  input                                clk, rst;

  output [NUMRDPT*NUMVBNK-1:0] t1_writeA;
  output [NUMRDPT*NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;

  output [NUMRDPT*NUMVBNK-1:0] t1_readB;
  output [NUMRDPT*NUMVBNK*BITSROW-1:0] t1_addrB;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_doutB;

  output [(NUMRDPT+1)-1:0] t2_writeA;
  output [(NUMRDPT+1)*BITVROW-1:0] t2_addrA;
  output [(NUMRDPT+1)*CDOUT_WIDTH-1:0] t2_bwA;
  output [(NUMRDPT+1)*CDOUT_WIDTH-1:0] t2_dinA;

  output [(NUMRDPT+1)-1:0] t2_readB;
  output [(NUMRDPT+1)*BITVROW-1:0] t2_addrB;
  input [(NUMRDPT+1)*CDOUT_WIDTH-1:0] t2_doutB;

  output [(NUMRDPT+2)-1:0] t3_writeA;
  output [(NUMRDPT+2)*BITVROW-1:0] t3_addrA;
  output [(NUMRDPT+2)*SDOUT_WIDTH-1:0] t3_bwA;
  output [(NUMRDPT+2)*SDOUT_WIDTH-1:0] t3_dinA;
  output [(NUMRDPT+2)-1:0] t3_readB;
  output [(NUMRDPT+2)*BITVROW-1:0] t3_addrB;
  input [(NUMRDPT+2)*SDOUT_WIDTH-1:0] t3_doutB;

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

wire [NUMRDPT-1:0] rd_fwrd_int;
wire [NUMRDPT*(BITPADR-1)-1:0] rd_padr_int;
reg [BITPADR-2:0] rd_padr_tmp [0:NUMRDPT-1];
reg [NUMRDPT*BITPADR-1:0] rd_padr;
integer padr_int;
always_comb begin
  rd_padr = 0;
  for (padr_int=0; padr_int<NUMRDPT; padr_int=padr_int+1) begin
    rd_padr_tmp[padr_int] = rd_padr_int >> (padr_int*(BITPADR-1));
    rd_padr = rd_padr | ({rd_fwrd_int[padr_int],rd_padr_tmp[padr_int]} << (padr_int*BITPADR));
  end
end

wire [NUMRDPT*NUMVBNK-1:0] t1_writeA_a1;
wire [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrA_a1;
wire [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_dinA_a1;
wire [NUMRDPT*NUMVBNK-1:0] t1_readB_a1;
wire [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB_a1;
reg [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_doutB_a1;
reg [NUMRDPT*NUMVBNK-1:0] t1_fwrdB_a1;
reg [NUMRDPT*NUMVBNK-1:0] t1_serrB_a1;
reg [NUMRDPT*NUMVBNK-1:0] t1_derrB_a1;
reg [NUMRDPT*NUMVBNK*(BITSROW+BITWRDS)-1:0] t1_padrB_a1;

wire [(NUMRDPT+1)-1:0] t2_writeA_a1;
wire [(NUMRDPT+1)*BITVROW-1:0] t2_addrA_a1;
wire [(NUMRDPT+1)*WIDTH-1:0] t2_dinA_a1;
wire [(NUMRDPT+1)-1:0] t2_readB_a1;
wire [(NUMRDPT+1)*BITVROW-1:0] t2_addrB_a1;
reg [(NUMRDPT+1)*WIDTH-1:0] t2_doutB_a1;
reg [(NUMRDPT+1)-1:0] t2_fwrdB_a1;
reg [(NUMRDPT+1)-1:0] t2_serrB_a1;
reg [(NUMRDPT+1)-1:0] t2_derrB_a1;
reg [(NUMRDPT+1)*(BITSROW+BITWRDS)-1:0] t2_padrB_a1;

wire [(NUMRDPT+2)-1:0] t3_writeA_a1;
wire [(NUMRDPT+2)*BITVROW-1:0] t3_addrA_a1;
wire [(NUMRDPT+2)*(BITVBNK+1)-1:0] t3_dinA_a1;
wire [(NUMRDPT+2)-1:0] t3_readB_a1;
wire [(NUMRDPT+2)*BITVROW-1:0] t3_addrB_a1;
reg [(NUMRDPT+2)*(BITVBNK+1)-1:0] t3_doutB_a1;
reg [(NUMRDPT+2)-1:0] t3_fwrdB_a1;
reg [(NUMRDPT+2)-1:0] t3_serrB_a1;
reg [(NUMRDPT+2)-1:0] t3_derrB_a1;
reg [(NUMRDPT+2)*(BITSROW+BITWRDS)-1:0] t3_padrB_a1;

generate if (1) begin: a1_loop

  algo_nr2w_1r1w_a653 #(.BITWDTH (BITWDTH), .WIDTH (WIDTH), .ENAPSDO (0), .ENAPAR (ENAPAR), .ENAECC (ENAECC),
                        .NUMRDPT (NUMRDPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                        .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR-1),
                        .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPIN(FLOPIN), .FLOPOUT(FLOPOUT), .CGFLOPI(CGFLOPI), .CGFLOPO(CGFLOPO))
    algo (.clk(clk), .rst(rst), .ready(ready),
          .write(write), .wr_adr(wr_adr), .din(din),
          .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout),
          .rd_fwrd(rd_fwrd_int), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr_int),
          .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
          .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1),
          .t1_fwrdB(t1_fwrdB_a1), .t1_serrB(t1_serrB_a1), .t1_derrB(t1_derrB_a1), .t1_padrB(t1_padrB_a1),
          .t2_writeA(t2_writeA_a1), .t2_addrA(t2_addrA_a1), .t2_dinA(t2_dinA_a1),
          .t2_readB(t2_readB_a1), .t2_addrB(t2_addrB_a1), .t2_doutB(t2_doutB_a1),
          .t2_fwrdB(t2_fwrdB_a1), .t2_serrB(t2_serrB_a1), .t2_derrB(t2_derrB_a1), .t2_padrB(t2_padrB_a1),
          .t3_writeA(t3_writeA_a1), .t3_addrA(t3_addrA_a1), .t3_dinA(t3_dinA_a1),
          .t3_readB(t3_readB_a1), .t3_addrB(t3_addrB_a1), .t3_doutB(t3_doutB_a1),
          .t3_fwrdB(t3_fwrdB_a1), .t3_serrB(t3_serrB_a1), .t3_derrB(t3_derrB_a1), .t3_padrB(t3_padrB_a1),
          .select_addr(select_addr), .select_bit(select_bit));

end
endgenerate

wire t1_writeA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [BITWROW-1:0] t1_addrA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_bwA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_dinA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire t1_readB_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [BITSROW-1:0] t1_addrB_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [WIDTH-1:0] t1_doutB_a1_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire t1_fwrdB_a1_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire t1_serrB_a1_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire t1_derrB_a1_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [BITSROW+BITWRDS-1:0] t1_padrB_a1_wire [0:NUMRDPT-1][0:NUMVBNK-1];

genvar t1r, t1b;
generate
  for (t1r=0; t1r<NUMRDPT; t1r=t1r+1) begin: t1r_loop
    for (t1b=0; t1b<NUMVBNK; t1b=t1b+1) begin: t1b_loop
      wire t1_writeA_a1_wire = t1_writeA_a1 >> (t1r*NUMVBNK+t1b);
      wire [BITVROW-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> ((t1r*NUMVBNK+t1b)*BITVROW);
      wire [WIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> ((t1r*NUMVBNK+t1b)*WIDTH);
      wire t1_readB_a1_wire = t1_readB_a1 >> (t1r*NUMVBNK+t1b);
      wire [BITVROW-1:0] t1_addrB_a1_wire = t1_addrB_a1 >> ((t1r*NUMVBNK+t1b)*BITVROW);

      wire [NUMWRDS*MEMWDTH-1:0] t1_doutB_wire = t1_doutB >> ((t1r*NUMVBNK+t1b)*PHYWDTH);

      wire t1_mem_write_wire;
      wire [BITSROW-1:0] t1_mem_wr_adr_wire;
      wire [NUMWRDS*MEMWDTH-1:0] t1_mem_bw_wire;
      wire [NUMWRDS*MEMWDTH-1:0] t1_mem_din_wire;
      wire t1_mem_read_wire;
      wire [BITSROW-1:0] t1_mem_rd_adr_wire;
      wire [NUMWRDS*MEMWDTH-1:0] t1_mem_rd_dout_wire;
      wire t1_mem_rd_fwrd_wire;
      wire t1_mem_rd_serr_wire;
      wire t1_mem_rd_derr_wire;
      wire [(BITWBNK+BITWROW)-1:0] t1_mem_rd_padr_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH (WIDTH), .ENAPSDO (NUMWRDS==1), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .ENAPADR (1),
                               .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                               .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITWBNK+BITWROW),
                               .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC), .CGFLOPM(0), .CGFLOPO(CGFLOPE))
          infra (.write(t1_writeA_a1_wire), .wr_adr(t1_addrA_a1_wire), .din(t1_dinA_a1_wire),
                 .read(t1_readB_a1_wire), .rd_adr(t1_addrB_a1_wire),
                 .rd_dout(t1_doutB_a1_wire[t1r][t1b]), .rd_fwrd(t1_fwrdB_a1_wire[t1r][t1b]),
                 .rd_serr(t1_serrB_a1_wire[t1r][t1b]), .rd_derr(t1_derrB_a1_wire[t1r][t1b]), .rd_padr(t1_padrB_a1_wire[t1r][t1b]),
                 .mem_write (t1_mem_write_wire), .mem_wr_adr(t1_mem_wr_adr_wire), .mem_bw (t1_mem_bw_wire), .mem_din (t1_mem_din_wire),
                 .mem_read (t1_mem_read_wire), .mem_rd_adr(t1_mem_rd_adr_wire), .mem_rd_dout (t1_mem_rd_dout_wire),
                 .mem_rd_fwrd(t1_mem_rd_fwrd_wire), .mem_rd_padr(t1_mem_rd_padr_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (NUMWRDS*MEMWDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (NUMSROW), .BITADDR (BITSROW),
                           .NUMWROW (NUMWROW), .BITWROW (BITWROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                           .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .CGFLOPC(CGFLOPC), .CGFLOPM(CGFLOPM))
          infra (.write (t1_mem_write_wire), .wr_adr (t1_mem_wr_adr_wire), .bw (t1_mem_bw_wire), .din (t1_mem_din_wire),
                 .read (t1_mem_read_wire), .rd_adr (t1_mem_rd_adr_wire), .rd_dout (t1_mem_rd_dout_wire),
                 .rd_fwrd (t1_mem_rd_fwrd_wire), .rd_serr (t1_mem_rd_serr_wire), .rd_derr(t1_mem_rd_derr_wire), .rd_padr(t1_mem_rd_padr_wire),
                 .mem_write (t1_writeA_wire[t1r][t1b]), .mem_wr_adr(t1_addrA_wire[t1r][t1b]),
                 .mem_bw (t1_bwA_wire[t1r][t1b]), .mem_din (t1_dinA_wire[t1r][t1b]),
                 .mem_read (t1_readB_wire[t1r][t1b]), .mem_rd_adr(t1_addrB_wire[t1r][t1b]), .mem_rd_dout (t1_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_srow));
      end
    end
  end
endgenerate

reg [NUMRDPT*NUMVBNK-1:0] t1_writeA;
reg [NUMRDPT*NUMVBNK*BITSROW-1:0] t1_addrA;
reg [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_bwA;
reg [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;
reg [NUMRDPT*NUMVBNK-1:0] t1_readB;
reg [NUMRDPT*NUMVBNK*BITSROW-1:0] t1_addrB;
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
  for (t1r_int=0; t1r_int<NUMRDPT; t1r_int=t1r_int+1) begin
    for (t1b_int=0; t1b_int<NUMVBNK; t1b_int=t1b_int+1) begin
      t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*BITSROW));
      t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*PHYWDTH));
      t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*PHYWDTH));
      t1_readB = t1_readB | (t1_readB_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_addrB = t1_addrB | (t1_addrB_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*BITSROW));
      t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*WIDTH));
      t1_fwrdB_a1 = t1_fwrdB_a1 | (t1_fwrdB_a1_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*(BITSROW+BITWRDS)));
    end
  end
end

wire t2_writeA_wire [0:(NUMRDPT+1)-1][0:1-1];
wire [BITVROW-1:0] t2_addrA_wire [0:(NUMRDPT+1)-1][0:1-1];
wire [CDOUT_WIDTH-1:0] t2_bwA_wire [0:(NUMRDPT+1)-1][0:1-1];
wire [CDOUT_WIDTH-1:0] t2_dinA_wire [0:(NUMRDPT+1)-1][0:1-1];
wire t2_readB_wire [0:(NUMRDPT+1)-1][0:1-1];
wire [BITVROW-1:0] t2_addrB_wire [0:(NUMRDPT+1)-1][0:1-1];
wire [WIDTH-1:0] t2_doutB_a1_wire [0:(NUMRDPT+1)-1][0:1-1];
wire t2_fwrdB_a1_wire [0:(NUMRDPT+1)-1][0:1-1];
wire t2_serrB_a1_wire [0:(NUMRDPT+1)-1][0:1-1];
wire t2_derrB_a1_wire [0:(NUMRDPT+1)-1][0:1-1];
wire [BITVROW-1:0] t2_padrB_a1_wire [0:(NUMRDPT+1)-1][0:1-1];

genvar t2r, t2b;
generate
  for (t2r=0; t2r<(NUMRDPT+1); t2r=t2r+1) begin: t2r_loop
    for (t2b=0; t2b<1; t2b=t2b+1) begin: t2b_loop
      wire t2_writeA_a1_wire = t2_writeA_a1 >> (t2r*1+t2b);
      wire [BITVROW-1:0] t2_addrA_a1_wire = t2_addrA_a1 >> ((t2r*1+t2b)*BITVROW);
      wire [WIDTH-1:0] t2_dinA_a1_wire = t2_dinA_a1 >> ((t2r*1+t2b)*WIDTH);
      wire t2_readB_a1_wire = t2_readB_a1 >> (t2r*1+t2b);
      wire [BITVROW-1:0] t2_addrB_a1_wire = t2_addrB_a1 >> ((t2r*1+t2b)*BITVROW);

      wire [CDOUT_WIDTH-1:0] t2_doutB_wire = t2_doutB >> ((t2r*1+t2b)*CDOUT_WIDTH);

      wire t2_mem_write_wire;
      wire [BITVROW-1:0] t2_mem_wr_adr_wire;
      wire [CDOUT_WIDTH-1:0] t2_mem_bw_wire;
      wire [CDOUT_WIDTH-1:0] t2_mem_din_wire;
      wire t2_mem_read_wire;
      wire [BITVROW-1:0] t2_mem_rd_adr_wire;
      wire [CDOUT_WIDTH-1:0] t2_mem_rd_dout_wire;
      wire t2_mem_rd_fwrd_wire;
      wire t2_mem_rd_serr_wire;
      wire t2_mem_rd_derr_wire;
      wire [BITVROW-1:0] t2_mem_rd_padr_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH (WIDTH), .ENAPSDO (1), .ENADEC (1), .ECCWDTH (ECCWDTH), .ENAPADR (1),
                               .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                               .NUMSROW (NUMVROW), .BITSROW (BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITVROW),
                               .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (1),
                               .CGFLOPM (0), .CGFLOPO(CGFLOPE))
          infra (.write(t2_writeA_a1_wire), .wr_adr(t2_addrA_a1_wire), .din(t2_dinA_a1_wire),
                 .read(t2_readB_a1_wire), .rd_adr(t2_addrB_a1_wire),
                 .rd_dout(t2_doutB_a1_wire[t2r][t2b]), .rd_fwrd(t2_fwrdB_a1_wire[t2r][t2b]),
                 .rd_serr(t2_serrB_a1_wire[t2r][t2b]), .rd_derr(t2_derrB_a1_wire[t2r][t2b]), .rd_padr(t2_padrB_a1_wire[t2r][t2b]),
                 .mem_write (t2_mem_write_wire), .mem_wr_adr(t2_mem_wr_adr_wire), .mem_bw (t2_mem_bw_wire), .mem_din (t2_mem_din_wire),
                 .mem_read (t2_mem_read_wire), .mem_rd_adr(t2_mem_rd_adr_wire), .mem_rd_dout (t2_mem_rd_dout_wire),
                 .mem_rd_fwrd(t2_mem_rd_fwrd_wire), .mem_rd_padr(t2_mem_rd_padr_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (CDOUT_WIDTH), .ENAPSDO (0), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                           .NUMWROW (NUMVROW), .BITWROW (BITVROW), .NUMWBNK (1), .BITWBNK (0),
                           .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1),
                           .CGFLOPC(CGFLOPC), .CGFLOPM(CGFLOPM))
          infra (.write (t2_mem_write_wire), .wr_adr (t2_mem_wr_adr_wire), .bw (t2_mem_bw_wire), .din (t2_mem_din_wire),
                 .read (t2_mem_read_wire), .rd_adr (t2_mem_rd_adr_wire), .rd_dout (t2_mem_rd_dout_wire),
                 .rd_fwrd (t2_mem_rd_fwrd_wire), .rd_serr (t2_mem_rd_serr_wire), .rd_derr(t2_mem_rd_derr_wire), .rd_padr(t2_mem_rd_padr_wire),
                 .mem_write (t2_writeA_wire[t2r][t2b]), .mem_wr_adr(t2_addrA_wire[t2r][t2b]),
                 .mem_bw (t2_bwA_wire[t2r][t2b]), .mem_din (t2_dinA_wire[t2r][t2b]),
                 .mem_read (t2_readB_wire[t2r][t2b]), .mem_rd_adr(t2_addrB_wire[t2r][t2b]), .mem_rd_dout (t2_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_vrow));
      end
    end
  end
endgenerate

reg [(NUMRDPT+1)-1:0] t2_writeA;
reg [(NUMRDPT+1)*BITVROW-1:0] t2_addrA;
reg [(NUMRDPT+1)*CDOUT_WIDTH-1:0] t2_bwA;
reg [(NUMRDPT+1)*CDOUT_WIDTH-1:0] t2_dinA;
reg [(NUMRDPT+1)-1:0] t2_readB;
reg [(NUMRDPT+1)*BITVROW-1:0] t2_addrB;
integer t2r_int, t2b_int;
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
  for (t2r_int=0; t2r_int<NUMRDPT+1; t2r_int=t2r_int+1) begin
    for (t2b_int=0; t2b_int<1; t2b_int=t2b_int+1) begin
      t2_writeA = t2_writeA | (t2_writeA_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_addrA = t2_addrA | (t2_addrA_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*BITVROW));
      t2_bwA = t2_bwA | (t2_bwA_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*CDOUT_WIDTH));
      t2_dinA = t2_dinA | (t2_dinA_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*CDOUT_WIDTH));
      t2_readB = t2_readB | (t2_readB_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_addrB = t2_addrB | (t2_addrB_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*BITVROW));
      t2_doutB_a1 = t2_doutB_a1 | (t2_doutB_a1_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*WIDTH));
      t2_fwrdB_a1 = t2_fwrdB_a1 | (t2_fwrdB_a1_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_serrB_a1 = t2_serrB_a1 | (t2_serrB_a1_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_derrB_a1 = t2_derrB_a1 | (t2_derrB_a1_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_padrB_a1 = t2_padrB_a1 | (t2_padrB_a1_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*(BITSROW+BITWRDS)));
    end
  end
end

wire t3_writeA_wire [0:(NUMRDPT+2)-1][0:1-1];
wire [BITVROW-1:0] t3_addrA_wire [0:(NUMRDPT+2)-1][0:1-1];
wire [SDOUT_WIDTH-1:0] t3_bwA_wire [0:(NUMRDPT+2)-1][0:1-1];
wire [SDOUT_WIDTH-1:0] t3_dinA_wire [0:(NUMRDPT+2)-1][0:1-1];
wire t3_readB_wire [0:(NUMRDPT+2)-1][0:1-1];
wire [BITVROW-1:0] t3_addrB_wire [0:(NUMRDPT+2)-1][0:1-1];
wire [(BITVBNK+1)-1:0] t3_doutB_a1_wire [0:(NUMRDPT+2)-1][0:1-1];
wire t3_fwrdB_a1_wire [0:(NUMRDPT+2)-1][0:1-1];
wire t3_serrB_a1_wire [0:(NUMRDPT+2)-1][0:1-1];
wire t3_derrB_a1_wire [0:(NUMRDPT+2)-1][0:1-1];
wire [BITVROW-1:0] t3_padrB_a1_wire [0:(NUMRDPT+2)-1][0:1-1];

genvar t3r, t3b;
generate
  for (t3r=0; t3r<NUMRDPT+2; t3r=t3r+1) begin: t3r_loop
    for (t3b=0; t3b<1; t3b=t3b+1) begin: t3b_loop
      wire t3_writeA_a1_wire = t3_writeA_a1 >> (t3r*1+t3b);
      wire [BITVROW-1:0] t3_addrA_a1_wire = t3_addrA_a1 >> ((t3r*1+t3b)*BITVROW);
      wire [(BITVBNK+1)-1:0] t3_dinA_a1_wire = t3_dinA_a1 >> ((t3r*1+t3b)*(BITVBNK+1));
      wire t3_readB_a1_wire = t3_readB_a1 >> (t3r*1+t3b);
      wire [BITVROW-1:0] t3_addrB_a1_wire = t3_addrB_a1 >> ((t3r*1+t3b)*BITVROW);

      wire [SDOUT_WIDTH-1:0] t3_doutB_wire = t3_doutB >> ((t3r*1+t3b)*SDOUT_WIDTH);

      wire t3_mem_write_wire;
      wire [BITVROW-1:0] t3_mem_wr_adr_wire;
      wire [SDOUT_WIDTH-1:0] t3_mem_bw_wire;
      wire [SDOUT_WIDTH-1:0] t3_mem_din_wire;
      wire t3_mem_read_wire;
      wire [BITVROW-1:0] t3_mem_rd_adr_wire;
      wire [SDOUT_WIDTH-1:0] t3_mem_rd_dout_wire;
      wire t3_mem_rd_fwrd_wire;
      wire t3_mem_rd_serr_wire;
      wire t3_mem_rd_derr_wire;
      wire [BITVROW-1:0] t3_mem_rd_padr_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH (BITVBNK+1), .ENAPSDO (1), .ENADEC(1), .ECCWDTH (ECCBITS), .ENAPADR (1),
                               .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                               .NUMSROW (NUMVROW), .BITSROW (BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITVROW),
                               .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (0), .RSTZERO (1),
                               .CGFLOPM (0), .CGFLOPO(0))
          infra (.write(t3_writeA_a1_wire), .wr_adr(t3_addrA_a1_wire), .din(t3_dinA_a1_wire),
                 .read(t3_readB_a1_wire), .rd_adr(t3_addrB_a1_wire),
                 .rd_dout(t3_doutB_a1_wire[t3r][t3b]), .rd_fwrd(t3_fwrdB_a1_wire[t3r][t3b]),
                 .rd_serr(t3_serrB_a1_wire[t3r][t3b]), .rd_derr(t3_derrB_a1_wire[t3r][t3b]), .rd_padr(t3_padrB_a1_wire[t3r][t3b]),
                 .mem_write (t3_mem_write_wire), .mem_wr_adr(t3_mem_wr_adr_wire), .mem_bw (t3_mem_bw_wire), .mem_din (t3_mem_din_wire),
                 .mem_read (t3_mem_read_wire), .mem_rd_adr(t3_mem_rd_adr_wire), .mem_rd_dout (t3_mem_rd_dout_wire),
                 .mem_rd_fwrd(t3_mem_rd_fwrd_wire), .mem_rd_padr(t3_mem_rd_padr_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (SDOUT_WIDTH), .ENAPSDO (0), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                           .NUMWROW (NUMVROW), .BITWROW (BITVROW), .NUMWBNK (1), .BITWBNK (0),
                           .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1),
                           .CGFLOPC(CGFLOPC), .CGFLOPM(CGFLOPM))
          infra (.write (t3_mem_write_wire), .wr_adr (t3_mem_wr_adr_wire), .bw (t3_mem_bw_wire), .din (t3_mem_din_wire),
                 .read (t3_mem_read_wire), .rd_adr (t3_mem_rd_adr_wire), .rd_dout (t3_mem_rd_dout_wire),
                 .rd_fwrd (t3_mem_rd_fwrd_wire), .rd_serr (t3_mem_rd_serr_wire), .rd_derr(t3_mem_rd_derr_wire), .rd_padr(t3_mem_rd_padr_wire),
                 .mem_write (t3_writeA_wire[t3r][t3b]), .mem_wr_adr(t3_addrA_wire[t3r][t3b]),
                 .mem_bw (t3_bwA_wire[t3r][t3b]), .mem_din (t3_dinA_wire[t3r][t3b]),
                 .mem_read (t3_readB_wire[t3r][t3b]), .mem_rd_adr(t3_addrB_wire[t3r][t3b]), .mem_rd_dout (t3_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_vrow));
      end
    end
  end
endgenerate

reg [(NUMRDPT+2)-1:0] t3_writeA;
reg [(NUMRDPT+2)*BITVROW-1:0] t3_addrA;
reg [(NUMRDPT+2)*SDOUT_WIDTH-1:0] t3_bwA;
reg [(NUMRDPT+2)*SDOUT_WIDTH-1:0] t3_dinA;
reg [(NUMRDPT+2)-1:0] t3_readB;
reg [(NUMRDPT+2)*BITVROW-1:0] t3_addrB;
integer t3r_int, t3b_int;
always_comb begin
  t3_writeA = 0;
  t3_addrA = 0;
  t3_bwA = 0;
  t3_dinA = 0;
  t3_readB = 0;
  t3_addrB = 0;
  t3_doutB_a1 = 0;
  t3_fwrdB_a1 = 0;
  t3_serrB_a1 = 0;
  t3_derrB_a1 = 0;
  t3_padrB_a1 = 0;
  for (t3r_int=0; t3r_int<NUMRDPT+2; t3r_int=t3r_int+1) begin
    for (t3b_int=0; t3b_int<1; t3b_int=t3b_int+1) begin
      t3_writeA = t3_writeA | (t3_writeA_wire[t3r_int][t3b_int] << (t3r_int*1+t3b_int));
      t3_addrA = t3_addrA | (t3_addrA_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*BITVROW));
      t3_bwA = t3_bwA | (t3_bwA_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*SDOUT_WIDTH));
      t3_dinA = t3_dinA | (t3_dinA_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*SDOUT_WIDTH));
      t3_readB = t3_readB | (t3_readB_wire[t3r_int][t3b_int] << (t3r_int*1+t3b_int));
      t3_addrB = t3_addrB | (t3_addrB_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*BITVROW));
      t3_doutB_a1 = t3_doutB_a1 | (t3_doutB_a1_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*(BITVBNK+1)));
      t3_fwrdB_a1 = t3_fwrdB_a1 | (t3_fwrdB_a1_wire[t3r_int][t3b_int] << (t3r_int*1+t3b_int));
      t3_serrB_a1 = t3_serrB_a1 | (t3_serrB_a1_wire[t3r_int][t3b_int] << (t3r_int*1+t3b_int));
      t3_derrB_a1 = t3_derrB_a1 | (t3_derrB_a1_wire[t3r_int][t3b_int] << (t3r_int*1+t3b_int));
      t3_padrB_a1 = t3_padrB_a1 | (t3_padrB_a1_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*(BITSROW+BITWRDS)));
    end
  end
end

endmodule
