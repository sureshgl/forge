module algo_mrnwt_base_top (clk, rst, ready,
                            write, wr_adr, din,
                            read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                            bp_thr, wr_bp,
	                        t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMRDPT = 4;
  parameter NUMWRPT = 4;
  parameter NUMWTPT = 1;
  parameter BITWRPT = 2;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMCOLS = 1;
  parameter BITCOLS = 0;
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

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;
  parameter FLOPOUT = 0;

  parameter FIFOCNT = 64;
  parameter BITFIFO = 6;

  parameter BITPADR = BITVBNK+BITSROW+BITWRDS+1;
  
  input [NUMWRPT-1:0]                   write;
  input [NUMWRPT*BITADDR-1:0]           wr_adr;
  input [NUMWRPT*WIDTH-1:0]             din;

  input [NUMRDPT-1:0]                  read;
  input [NUMRDPT*BITADDR-1:0]          rd_adr;
  output [NUMRDPT-1:0]                 rd_vld;
  output [NUMRDPT*WIDTH-1:0]           rd_dout;
  output [NUMRDPT-1:0]                 rd_serr;
  output [NUMRDPT-1:0]                 rd_derr;
  output [NUMRDPT*BITPADR-1:0]         rd_padr;

  output                              wr_bp;

  input [BITFIFO:0]                     bp_thr;

  output                               ready;
  input                                clk, rst;

  output [NUMRDPT*NUMVBNK-1:0] t1_writeA;
  output [NUMRDPT*NUMVBNK*(BITSROW+BITCOLS)-1:0] t1_addrA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;

  output [NUMRDPT*NUMVBNK-1:0] t1_readB;
  output [NUMRDPT*NUMVBNK*(BITSROW+BITCOLS)-1:0] t1_addrB;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_doutB;

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

wire [NUMWTPT-1:0] t1_writeA_a1;
wire [NUMWTPT*BITADDR-1:0] t1_addrA_a1;
wire [NUMWTPT*WIDTH-1:0] t1_dinA_a1;
wire [NUMRDPT-1:0] t1_readB_a1;
wire [NUMRDPT*BITADDR-1:0] t1_addrB_a1;
wire [NUMRDPT-1:0] t1_rd_vldB_a1;
wire [NUMRDPT*WIDTH-1:0] t1_doutB_a1;
wire [NUMRDPT-1:0] t1_fwrdB_a1;
wire [NUMRDPT-1:0] t1_serrB_a1;
wire [NUMRDPT-1:0] t1_derrB_a1;
wire [NUMRDPT*(BITPADR-1)-1:0] t1_padrB_a1;

wire a2_ready;

generate if (1) begin: a1_loop

  algo_mrnwt_base #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .NUMRDPT (NUMRDPT), .NUMWRPT (NUMWRPT), .BITWRPT (BITWRPT), .NUMWTPT (NUMWTPT),
                    .NUMADDR(NUMADDR), .BITADDR(BITADDR), .BITPADR(BITPADR-1),
                    .FIFOCNT(FIFOCNT), .BITFIFO(BITFIFO),
                    .SRAM_DELAY(SRAM_DELAY+FLOPMEM+1), .FLOPIN(FLOPIN), .FLOPOUT(FLOPOUT))
    algo (.ready(ready), .clk(clk), .rst (rst || !a2_ready),
          .write(write), .wr_adr(wr_adr), .din(din), .wr_bp(wr_bp), .bp_thr(bp_thr),
          .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout),
          .rd_fwrd(rd_padr[BITPADR-1]), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr[BITPADR-2:0]),
          .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
          .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1),
          .t1_fwrdB(t1_fwrdB_a1), .t1_serrB(t1_serrB_a1), .t1_derrB(t1_derrB_a1), .t1_padrB(t1_padrB_a1),
          .select_addr(select_addr), .select_bit(select_bit));

end
endgenerate


wire [NUMRDPT*NUMVBNK-1:0] t1_writeA_a2;
wire [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrA_a2;
wire [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_dinA_a2;
wire [NUMRDPT*NUMVBNK-1:0] t1_readB_a2;
wire [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB_a2;
reg [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_doutB_a2;
reg [NUMRDPT*NUMVBNK-1:0] t1_fwrdB_a2; 
reg [NUMRDPT*NUMVBNK-1:0] t1_serrB_a2; 
reg [NUMRDPT*NUMVBNK-1:0] t1_derrB_a2; 
reg [NUMRDPT*NUMVBNK*(BITSROW+BITWRDS)-1:0] t1_padrB_a2;

generate if (1) begin: a2_loop

algo_nr1w_dup #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMRDPT (NUMRDPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPADR (BITPADR-1), .NUMCOLS (NUMCOLS), .BITCOLS (BITCOLS),
		.SRAM_DELAY (SRAM_DELAY+FLOPMEM+FLOPCMD), .FLOPIN (FLOPIN), .FLOPOUT (1))
    algo (.clk(clk), .rst(rst), .ready(a2_ready),
          .write(t1_writeA_a1), .wr_adr(t1_addrA_a1), .din(t1_dinA_a1),
          .read(t1_readB_a1), .rd_adr(t1_addrB_a1), .rd_vld(t1_rd_vldB_a1), .rd_dout(t1_doutB_a1),
          .rd_fwrd(t1_fwrdB_a1), .rd_serr(t1_serrB_a1), .rd_derr(t1_derrB_a1), .rd_padr(t1_padrB_a1),
          .t1_writeA(t1_writeA_a2), .t1_addrA(t1_addrA_a2), .t1_dinA(t1_dinA_a2),
          .t1_readB(t1_readB_a2), .t1_addrB(t1_addrB_a2), .t1_doutB(t1_doutB_a2),
          .t1_fwrdB(t1_fwrdB_a2), .t1_serrB(t1_serrB_a2), .t1_derrB(t1_derrB_a2), .t1_padrB(t1_padrB_a2), 
	  .select_addr(select_addr), .select_bit(select_bit));

end
endgenerate

wire t1_writeA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [BITWROW-1:0] t1_addrA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_bwA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_dinA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire t1_readB_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [BITSROW-1:0] t1_addrB_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [WIDTH-1:0] t1_doutB_a2_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire t1_fwrdB_a2_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire t1_serrB_a2_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire t1_derrB_a2_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [BITSROW+BITWRDS-1:0] t1_padrB_a2_wire [0:NUMRDPT-1][0:NUMVBNK-1];

genvar t1r, t1b;
generate
  for (t1r=0; t1r<NUMRDPT; t1r=t1r+1) begin: t1r_loop
    for (t1b=0; t1b<NUMVBNK; t1b=t1b+1) begin: t1b_loop
      wire t1_writeA_a2_wire = t1_writeA_a2 >> (t1r*NUMVBNK+t1b);
      wire [BITVROW-1:0] t1_addrA_a2_wire = t1_addrA_a2 >> ((t1r*NUMVBNK+t1b)*BITVROW);
      wire [WIDTH-1:0] t1_dinA_a2_wire = t1_dinA_a2 >> ((t1r*NUMVBNK+t1b)*WIDTH);
      wire t1_readB_a2_wire = t1_readB_a2 >> (t1r*NUMVBNK+t1b);
      wire [BITVROW-1:0] t1_addrB_a2_wire = t1_addrB_a2 >> ((t1r*NUMVBNK+t1b)*BITVROW);

      wire [NUMWRDS*MEMWDTH-1:0] t1_doutB_wire = t1_doutB >> ((t1r*NUMVBNK+t1b)*PHYWDTH);

      wire mem_write_wire;
      wire [BITSROW-1:0] mem_wr_adr_wire;
      wire [NUMWRDS*MEMWDTH-1:0] mem_bw_wire;
      wire [NUMWRDS*MEMWDTH-1:0] mem_din_wire;
      wire mem_read_wire;
      wire [BITSROW-1:0] mem_rd_adr_wire;
      wire [NUMWRDS*MEMWDTH-1:0] mem_rd_dout_wire;
      wire mem_rd_fwrd_wire;
      wire mem_rd_serr_wire;
      wire mem_rd_derr_wire;
      wire [(BITWBNK+BITWROW)-1:0] mem_rd_padr_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH (WIDTH), .ENAPSDO (NUMWRDS==1), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .ENAPADR (1),
                               .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                               .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITWBNK+BITWROW),
                               .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC))
          infra (.write(t1_writeA_a2_wire), .wr_adr(t1_addrA_a2_wire), .din(t1_dinA_a2_wire),
                 .read(t1_readB_a2_wire), .rd_adr(t1_addrB_a2_wire),
                 .rd_dout(t1_doutB_a2_wire[t1r][t1b]), .rd_fwrd(t1_fwrdB_a2_wire[t1r][t1b]),
                 .rd_serr(t1_serrB_a2_wire[t1r][t1b]), .rd_derr(t1_derrB_a2_wire[t1r][t1b]), .rd_padr(t1_padrB_a2_wire[t1r][t1b]),
                 .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
                 .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (NUMWRDS*MEMWDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (NUMSROW), .BITADDR (BITSROW),
                           .NUMWROW (NUMWROW), .BITWROW (BITWROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                           .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
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
  t1_doutB_a2 = 0;
  t1_fwrdB_a2 = 0;
  t1_serrB_a2 = 0;
  t1_derrB_a2 = 0;
  t1_padrB_a2 = 0;
  for (t1r_int=0; t1r_int<NUMRDPT; t1r_int=t1r_int+1) begin
    for (t1b_int=0; t1b_int<NUMVBNK; t1b_int=t1b_int+1) begin
      t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*BITSROW));
      t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*PHYWDTH));
      t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*PHYWDTH));
      t1_readB = t1_readB | (t1_readB_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_addrB = t1_addrB | (t1_addrB_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*BITSROW));
      t1_doutB_a2 = t1_doutB_a2 | (t1_doutB_a2_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*WIDTH));
      t1_fwrdB_a2 = t1_fwrdB_a2 | (t1_fwrdB_a2_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_serrB_a2 = t1_serrB_a2 | (t1_serrB_a2_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_derrB_a2 = t1_derrB_a2 | (t1_derrB_a2_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_derrB_a2 = t1_derrB_a2 | (t1_derrB_a2_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_padrB_a2 = t1_padrB_a2 | (t1_padrB_a2_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*(BITSROW+BITWRDS)));
    end
  end
end

endmodule // algo_mrnwt_base_top


