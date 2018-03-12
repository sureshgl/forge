
module algo_mrnw_queue_top (clk, rst, ready,
                            push, pu_adr, pu_din,
                            pop, po_adr, po_vld, po_dout, po_serr, po_derr, po_padr,
                            t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
                            t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB);

  parameter NUMQUEU = 8;
  parameter BITQUEU = 3;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 6;
  parameter MEMWDTH = ENAPAR ? BITADDR+1 : ENAECC ? BITADDR+ECCWDTH : BITADDR;
  parameter NUMPUPT = 6;
  parameter NUMPOPT = 1;
  parameter NUMSBFL = 1;
  parameter NUMVROW = 1024;  // ALGO2 Parameters
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMPBNK = 11;
  parameter BITPBNK = 4;
  parameter NUMWRDS = 4;     // ALIGN Parameters
  parameter BITWRDS = 2;
  parameter NUMSROW = 64;
  parameter BITSROW = 6;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;
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

  parameter BITMAPT = (BITPBNK+1)*NUMVBNK;

  input [NUMPUPT-1:0]            push;
  input [NUMPUPT*BITQUEU-1:0]    pu_adr;
  input [NUMPUPT*BITADDR-1:0]    pu_din;

  input [NUMPOPT-1:0]            pop;
  input [NUMPOPT*BITQUEU-1:0]    po_adr;
  output [NUMPOPT-1:0]           po_vld;
  output [NUMPOPT*BITADDR-1:0]   po_dout;
  output [NUMPOPT-1:0]           po_serr;
  output [NUMPOPT-1:0]           po_derr;
  output [NUMPOPT*BITPADR-1:0]   po_padr;

  output                         ready;
  input                          clk, rst;

  output [2*NUMPOPT*NUMPBNK-1:0] t1_writeA;
  output [2*NUMPOPT*NUMPBNK*BITSROW-1:0] t1_addrA;
  output [2*NUMPOPT*NUMPBNK*PHYWDTH-1:0] t1_bwA;
  output [2*NUMPOPT*NUMPBNK*PHYWDTH-1:0] t1_dinA;
  output [2*NUMPOPT*NUMPBNK-1:0] t1_readB;
  output [2*NUMPOPT*NUMPBNK*BITSROW-1:0] t1_addrB;
  input [2*NUMPOPT*NUMPBNK*PHYWDTH-1:0] t1_doutB;

  output [NUMPUPT-1:0] t2_writeA;
  output [NUMPUPT*BITVROW-1:0] t2_addrA;
  output [NUMPUPT*BITMAPT-1:0] t2_dinA;
  output [(NUMPUPT+NUMPOPT)-1:0] t2_readB;
  output [(NUMPUPT+NUMPOPT)*BITVROW-1:0] t2_addrB;
  input [(NUMPUPT+NUMPOPT)*BITMAPT-1:0] t2_doutB;

`ifdef FORMAL 
wire [BITQUEU-1:0] select_queue;
wire [BITADDR-1:0] select_addr;
assume_select_queue_range: assume property (@(posedge clk) disable iff (rst) (select_queue < NUMQUEU));
assume_select_queue_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_queue));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));

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
wire [BITQUEU-1:0] select_queue = 0;
wire [BITADDR-1:0] select_addr = 0;
wire [BITVROW-1:0] select_vrow = 0;
wire [BITSROW-1:0] select_srow = 0;
`endif

wire [NUMPOPT-1:0] po_fwrd_int;
wire [NUMPOPT*(BITPADR-1)-1:0] po_padr_int;
reg [BITPADR-2:0] po_padr_tmp [0:NUMPOPT-1];
reg [NUMPOPT*BITPADR-1:0] po_padr;
integer padr_int;
always_comb begin
  po_padr = 0;
  for (padr_int=0; padr_int<NUMPOPT; padr_int=padr_int+1) begin
    po_padr_tmp[padr_int] = po_padr_int << (padr_int*(BITPADR-1));
    po_padr = po_padr | ({po_fwrd_int[padr_int],po_padr_tmp[padr_int]} << (padr_int*BITPADR));
  end
end

wire [NUMPUPT-1:0] t1_writeA_a1;
wire [NUMPUPT*BITADDR-1:0] t1_addrA_a1;
wire [NUMPUPT*BITADDR-1:0] t1_dinA_a1;
wire [NUMPOPT-1:0] t1_readB_a1;
wire [NUMPOPT*BITADDR-1:0] t1_addrB_a1;
wire [NUMPOPT*BITADDR-1:0] t1_doutB_a1;
wire [NUMPOPT-1:0] t1_fwrdB_a1;
wire [NUMPOPT-1:0] t1_serrB_a1;
wire [NUMPOPT-1:0] t1_derrB_a1;
wire [NUMPOPT*(BITPBNK+BITSROW+BITWRDS)-1:0] t1_padrB_a1;

wire a2_ready;

generate if (1) begin: a1_loop

  algo_mrnw_queue #(.NUMPUPT (NUMPUPT), .NUMPOPT (NUMPOPT), .NUMQUEU (NUMQUEU), .BITQUEU (BITQUEU),
                    .NUMADDR(NUMADDR), .BITADDR(BITADDR), .BITPADR(BITPADR-1),
                    .SRAM_DELAY(SRAM_DELAY+DRAM_DELAY+FLOPMEM), .FLOPIN (FLOPIN), .FLOPOUT(FLOPOUT), .NUMSBFL(NUMSBFL))
    algo (.ready(ready), .clk(clk), .rst (rst || !a2_ready),
          .push(push), .pu_adr(pu_adr), .pu_din(pu_din),
          .pop(pop), .po_adr(po_adr), .po_vld(po_vld), .po_dout(po_dout),
          .po_fwrd(po_fwrd_int), .po_serr(po_serr), .po_derr(po_derr), .po_padr(po_padr_int),
          .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
          .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1),
          .t1_fwrdB(t1_fwrdB_a1), .t1_serrB(t1_serrB_a1), .t1_derrB(t1_derrB_a1), .t1_padrB(t1_padrB_a1),
          .select_queue (select_queue), .select_addr (select_addr));

end
endgenerate

wire [2*NUMPOPT*NUMPBNK-1:0] t1_writeA_a2;
wire [2*NUMPOPT*NUMPBNK*BITVROW-1:0] t1_addrA_a2;
wire [2*NUMPOPT*NUMPBNK*MEMWDTH-1:0] t1_dinA_a2;
wire [2*NUMPOPT*NUMPBNK-1:0] t1_readB_a2;
wire [2*NUMPOPT*NUMPBNK*BITVROW-1:0] t1_addrB_a2;
reg [2*NUMPOPT*NUMPBNK*MEMWDTH-1:0] t1_doutB_a2;
reg [2*NUMPOPT*NUMPBNK-1:0] t1_fwrdB_a2;
reg [2*NUMPOPT*NUMPBNK-1:0] t1_serrB_a2;
reg [2*NUMPOPT*NUMPBNK-1:0] t1_derrB_a2;
reg [2*NUMPOPT*NUMPBNK*(BITSROW+BITWRDS)-1:0] t1_padrB_a2;

wire [(NUMPUPT+NUMPOPT)*BITMAPT-1:0] t2_doutB_a2;

generate if (1) begin: a2_loop

  algo_mrnw_1r1w_mt2 #(.WIDTH(BITADDR), .BITWDTH(4), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                       .NUMRDPT (NUMPOPT), .NUMWRPT (NUMPUPT), .NUMADDR(NUMADDR), .BITADDR(BITADDR),
                       .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMPBNK(NUMPBNK), .BITPBNK(BITPBNK), .BITPADR(BITPADR-1),
                       .SRAM_DELAY(SRAM_DELAY+FLOPMEM), .DRAM_DELAY(DRAM_DELAY), .FLOPIN (0), .FLOPWRM (1), .FLOPPWR (0), .FLOPOUT(0))
    algo (.ready(a2_ready), .clk(clk), .rst (rst),
          .write(t1_writeA_a1), .wr_adr(t1_addrA_a1), .din(t1_dinA_a1),
          .read(t1_readB_a1), .rd_adr(t1_addrB_a1), .rd_vld(), .rd_dout(t1_doutB_a1),
          .rd_fwrd(t1_fwrdB_a1), .rd_serr(t1_serrB_a1), .rd_derr(t1_derrB_a1), .rd_padr(t1_padrB_a1),
          .t1_writeA(t1_writeA_a2), .t1_addrA(t1_addrA_a2), .t1_dinA(t1_dinA_a2),
          .t1_readB(t1_readB_a2), .t1_addrB(t1_addrB_a2), .t1_doutB(t1_doutB_a2),
          .t1_fwrdB(t1_fwrdB_a2), .t1_serrB(t1_serrB_a2), .t1_derrB(t1_derrB_a2), .t1_padrB(t1_padrB_a2),
          .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB_a2),
          .select_addr (select_addr), .select_bit (4'h0));

end
endgenerate

wire [MEMWDTH-1:0] t1_doutB_a2_wire [0:2*NUMPOPT-1][0:NUMPBNK-1];
wire t1_fwrdB_a2_wire [0:2*NUMPOPT-1][0:NUMPBNK-1];
wire t1_serrB_a2_wire [0:2*NUMPOPT-1][0:NUMPBNK-1];
wire t1_derrB_a2_wire [0:2*NUMPOPT-1][0:NUMPBNK-1];
wire [BITSROW+BITWRDS-1:0] t1_padrB_a2_wire [0:2*NUMPOPT-1][0:NUMPBNK-1];
wire t1_writeA_wire [0:2*NUMPOPT-1][0:NUMPBNK-1];
wire [BITSROW-1:0] t1_addrA_wire [0:2*NUMPOPT-1][0:NUMPBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_bwA_wire [0:2*NUMPOPT-1][0:NUMPBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_dinA_wire [0:2*NUMPOPT-1][0:NUMPBNK-1];
wire t1_readB_wire [0:2*NUMPOPT-1][0:NUMPBNK-1];
wire [BITSROW-1:0] t1_addrB_wire [0:2*NUMPOPT-1][0:NUMPBNK-1];

genvar t1r, t1b;
generate
  for (t1r=0; t1r<2*NUMPOPT; t1r=t1r+1) begin: t1r_loop
    for (t1b=0; t1b<NUMPBNK; t1b=t1b+1) begin: t1b_loop
      wire t1_writeA_a2_wire = t1_writeA_a2 >> (t1r*NUMPBNK+t1b);
      wire [BITVROW-1:0] t1_addrA_a2_wire = t1_addrA_a2 >> ((t1r*NUMPBNK+t1b)*BITVROW);
      wire [MEMWDTH-1:0] t1_dinA_a2_wire = t1_dinA_a2 >> ((t1r*NUMPBNK+t1b)*MEMWDTH); 
      wire t1_readB_a2_wire = t1_readB_a2 >> (t1r*NUMPBNK+t1b);
      wire [BITVROW-1:0] t1_addrB_a2_wire = t1_addrB_a2 >> ((t1r*NUMPBNK+t1b)*BITVROW);

      wire [NUMWRDS*MEMWDTH-1:0] t1_doutB_wire = t1_doutB >> ((t1r*NUMPBNK+t1b)*PHYWDTH);

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
        infra_align_ecc_1r1w #(.WIDTH (MEMWDTH), .ENAPSDO (1), .ENAPAR (0), .ENAECC (0), .ECCWDTH (ECCWDTH), .ENAPADR (1),
                               .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                               .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITWBNK+BITWROW),
                               .SRAM_DELAY (DRAM_DELAY), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC))
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
        infra_stack_1r1w #(.WIDTH (NUMWRDS*MEMWDTH), .ENAPSDO (0), .NUMADDR (NUMSROW), .BITADDR (BITSROW),
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

reg [2*NUMPOPT*NUMPBNK-1:0] t1_writeA;
reg [2*NUMPOPT*NUMPBNK*BITSROW-1:0] t1_addrA;
reg [2*NUMPOPT*NUMPBNK*PHYWDTH-1:0] t1_bwA;
reg [2*NUMPOPT*NUMPBNK*PHYWDTH-1:0] t1_dinA;
reg [2*NUMPOPT*NUMPBNK-1:0] t1_readB;
reg [2*NUMPOPT*NUMPBNK*BITSROW-1:0] t1_addrB;
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
  for (t1r_int=0; t1r_int<2*NUMPOPT; t1r_int=t1r_int+1) begin
    for (t1b_int=0; t1b_int<NUMPBNK; t1b_int=t1b_int+1) begin
      t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*BITSROW));
      t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*PHYWDTH));
      t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*PHYWDTH));
      t1_readB = t1_readB | (t1_readB_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_addrB = t1_addrB | (t1_addrB_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*BITSROW));
      t1_doutB_a2 = t1_doutB_a2 | (t1_doutB_a2_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*MEMWDTH));
      t1_fwrdB_a2 = t1_fwrdB_a2 | (t1_fwrdB_a2_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_serrB_a2 = t1_serrB_a2 | (t1_serrB_a2_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_derrB_a2 = t1_derrB_a2 | (t1_derrB_a2_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_padrB_a2 = t1_padrB_a2 | (t1_padrB_a2_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*(BITSROW+BITWRDS)));
    end
  end
end

generate if (FLOPMEM) begin: t2_flp_loop
  reg [(NUMPOPT+NUMPUPT)*BITMAPT-1:0] t2_doutB_reg;
  always @(posedge clk) begin
    t2_doutB_reg <= t2_doutB;
  end

  assign t2_doutB_a2 = t2_doutB_reg;
end else begin: t2_noflp_loop
  assign t2_doutB_a2 = t2_doutB;
end
endgenerate

endmodule
