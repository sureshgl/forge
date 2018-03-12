
module algo_16m8d_1r1w_top (clk, rst, ready,
                            malloc, ma_vld, ma_adr, ma_serr, ma_derr, ma_padr, ma_bp, bp_thr, bp_hys,
                            dq_vld, dq_adr,
                            cp_read, cp_write, cp_adr, cp_din, cp_vld, cp_dout,
                            grpmsk, grpbp, grpcnt, grpmt, ena_rand,
                            pwrite, pwrbadr, pwrradr, 
                            t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB);
  parameter ENAEXT = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter NUMMAPT = 16;
  parameter NUMDQPT = 8;
  parameter NUMEGPT = 2;    // Num egress ports
  parameter NUMARPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;  // ALGO1 Parameters
  parameter BITVROW = 10;
  parameter BITPROW = BITVROW;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter FLOPIN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;
  parameter FLOPOUT = 0;
  parameter ECCBITS = 5;
  parameter SRAM_DELAY = 2;

  parameter SDOUT_WIDTH = BITVROW+ECCBITS;
  
  parameter NUMWBNK = 1;
  parameter BITWBNK = 0;
  parameter NUMWROW = NUMVROW;
  parameter BITWROW = BITVROW;

  parameter BITCPAD = 2+3+5;
  parameter CPUWDTH = 54;

  input [NUMMAPT-1:0]            malloc;
  output [NUMMAPT-1:0]           ma_vld;
  output [NUMMAPT*BITADDR-1:0]   ma_adr;
  output [NUMMAPT-1:0]           ma_serr;
  output [NUMMAPT-1:0]           ma_derr;
  output [NUMMAPT*(BITVROW+2)-1:0] ma_padr;
  output [NUMMAPT-1:0]           ma_bp;
  input [BITVROW:0]              bp_thr;
  input [BITVROW:0]              bp_hys;

  input [NUMDQPT-1:0]            dq_vld;
  input [NUMDQPT*BITADDR-1:0]    dq_adr;

  input                          cp_read;
  input                          cp_write;
  input [BITCPAD-1:0]            cp_adr;
  input [CPUWDTH-1:0]            cp_din;
  output                         cp_vld;
  output [CPUWDTH-1:0]           cp_dout;

  input [NUMMAPT*NUMVBNK-1:0]     grpmsk;
  input [NUMMAPT*NUMVBNK-1:0]     grpbp;
  input [NUMMAPT*(BITVBNK+1)-1:0] grpcnt;
  output [NUMVBNK-1:0]            grpmt;
  input                           ena_rand;

  output                         ready;
  input                          clk, rst;

  output [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_writeA;
  output [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_addrA;
  output [(NUMDQPT/NUMEGPT)*NUMVBNK*SDOUT_WIDTH-1:0] t2_dinA;
  output [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_readB;
  output [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_addrB;
  input [(NUMDQPT/NUMEGPT)*NUMVBNK*SDOUT_WIDTH-1:0] t2_doutB;
  
  output [(NUMMAPT)-1:0] pwrite ;
  output [((NUMMAPT)*BITVBNK)-1:0] pwrbadr;
  output [((NUMMAPT)*BITVROW)-1:0] pwrradr; 

`ifdef FORMAL 
wire [BITADDR-1:0] select_addr;
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr == 0));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
//assume_select_mask_stable: assume property (@(posedge clk) disable iff (rst) $stable(grpmsk));

wire [BITVROW-1:0] select_vrow;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  adr_a2 (.vbadr(), .vradr(select_vrow), .vaddr(select_addr));
  
`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITVROW-1:0] select_vrow = 0;
`endif

wire [NUMMAPT-1:0] ma_fwrd_int;
wire [NUMMAPT*(BITVROW+1)-1:0] ma_padr_int;
reg [BITVROW:0] ma_padr_tmp [0:NUMMAPT-1];
reg [NUMMAPT*(BITVROW+2)-1:0] ma_padr;
integer mpdr_int;
always_comb begin
  ma_padr = 0;
  for (mpdr_int=0; mpdr_int<NUMMAPT; mpdr_int=mpdr_int+1) begin
    ma_padr_tmp[mpdr_int] = ma_padr_int >> (mpdr_int*(BITVROW+1));
    ma_padr = ma_padr | ({ma_fwrd_int[mpdr_int],ma_padr_tmp[mpdr_int]} << (mpdr_int*(BITVROW+2)));
  end
end

wire [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_writeA_a1;
wire [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_addrA_a1;
wire [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_dinA_a1;
wire [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_readB_a1;
wire [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_addrB_a1;
reg [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_doutB_a1;
reg [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_fwrdB_a1;
reg [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_serrB_a1;
reg [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_derrB_a1;
reg [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_padrB_a1;

generate if (1) begin: a1_loop
  algo_nmpd_1r1w_fl_shared #(.ENAEXT(ENAEXT), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .NUMADDR(NUMADDR), .BITADDR(BITADDR),
                                 .NUMMAPT (NUMMAPT), .NUMDQPT (NUMDQPT), .NUMEGPT (NUMEGPT), .NUMARPT (NUMARPT),
                                 .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .NUMVROW(NUMVROW), .BITVROW(BITVROW),
                                 .SRAM_DELAY(SRAM_DELAY+FLOPMEM+1), .FLOPIN (FLOPIN), .FLOPOUT(FLOPOUT))
    algo (.ready(ready), .clk(clk), .rst (rst),
          .malloc(malloc), .ma_vld(ma_vld), .ma_adr(ma_adr), .ma_bp(ma_bp), .bp_thr(bp_thr), .bp_hys(bp_hys),
          .ma_fwrd(ma_fwrd_int), .ma_serr(ma_serr), .ma_derr(ma_derr), .ma_padr(ma_padr_int),
          .dq_vld(dq_vld), .dq_adr(dq_adr),
          .cp_read(cp_read), .cp_write(cp_write), .cp_adr(cp_adr), .cp_din(cp_din), .cp_vld(cp_vld), .cp_dout(cp_dout),
          .grpmsk(grpmsk), .grpbp(grpbp), .grpcnt(grpcnt), .grpmt(grpmt), .ena_rand(ena_rand),
          .t2_writeA(t2_writeA_a1), .t2_addrA(t2_addrA_a1), .t2_dinA(t2_dinA_a1),
          .t2_readB(t2_readB_a1), .t2_addrB(t2_addrB_a1), .t2_doutB(t2_doutB_a1),
          .t2_fwrdB(t2_fwrdB_a1), .t2_serrB(t2_serrB_a1), .t2_derrB(t2_derrB_a1), .t2_padrB(t2_padrB_a1),
  	  .select_addr (select_addr), 
      .pwrite(pwrite), .pwrbadr(pwrbadr), .pwrradr(pwrradr));
end
endgenerate

wire [BITVROW-1:0] t2_doutB_a1_wire [0:(NUMDQPT/NUMEGPT)-1][0:NUMVBNK-1];
wire t2_fwrdB_a1_wire [0:(NUMDQPT/NUMEGPT)-1][0:NUMVBNK-1];
wire t2_serrB_a1_wire [0:(NUMDQPT/NUMEGPT)-1][0:NUMVBNK-1];
wire t2_derrB_a1_wire [0:(NUMDQPT/NUMEGPT)-1][0:NUMVBNK-1];
wire [BITWROW+BITWBNK-1:0] t2_padrB_a1_wire [0:(NUMDQPT/NUMEGPT)-1][0:NUMVBNK-1];
wire [NUMWBNK-1:0] t2_writeA_wire [0:(NUMDQPT/NUMEGPT)-1][0:NUMVBNK-1];
wire [NUMWBNK*BITWROW-1:0] t2_addrA_wire [0:(NUMDQPT/NUMEGPT)-1][0:NUMVBNK-1];
wire [NUMWBNK*SDOUT_WIDTH-1:0] t2_dinA_wire [0:(NUMDQPT/NUMEGPT)-1][0:NUMVBNK-1];
wire [NUMWBNK-1:0] t2_readB_wire [0:(NUMDQPT/NUMEGPT)-1][0:NUMVBNK-1];
wire [NUMWBNK*BITWROW-1:0] t2_addrB_wire [0:(NUMDQPT/NUMEGPT)-1][0:NUMVBNK-1];

genvar t2r, t2b;
generate
  for (t2r=0; t2r<(NUMDQPT/NUMEGPT); t2r=t2r+1) begin: t2r_loop
    for (t2b=0; t2b<NUMVBNK; t2b=t2b+1) begin: t2b_loop
      wire t2_writeA_a1_wire = t2_writeA_a1 >> (t2r*NUMVBNK+t2b);
      wire [BITVROW-1:0] t2_addrA_a1_wire = t2_addrA_a1 >> ((t2r*NUMVBNK+t2b)*BITVROW);
      wire [BITVROW-1:0] t2_dinA_a1_wire = t2_dinA_a1 >> ((t2r*NUMVBNK+t2b)*BITVROW);

      wire t2_readB_a1_wire = t2_readB_a1 >> (t2r*NUMVBNK+t2b);
      wire [BITVROW-1:0] t2_addrB_a1_wire = t2_addrB_a1 >> ((t2r*NUMVBNK+t2b)*BITVROW);

      wire [NUMWBNK*SDOUT_WIDTH-1:0] t2_doutB_wire = t2_doutB >> ((t2r*NUMVBNK+t2b)*NUMWBNK*SDOUT_WIDTH);

      wire mem_write_wire;
      wire [BITVROW-1:0] mem_wr_adr_wire;
      wire [SDOUT_WIDTH-1:0] mem_bw_wire;
      wire [SDOUT_WIDTH-1:0] mem_din_wire;
      wire mem_read_wire;
      wire [BITVROW-1:0] mem_rd_adr_wire;
      wire [SDOUT_WIDTH-1:0] mem_rd_dout_wire;
      wire mem_rd_fwrd_wire;
      wire mem_rd_serr_wire;
      wire mem_rd_derr_wire;
      wire [(BITWBNK+BITWROW)-1:0] mem_rd_padr_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH (BITVROW), .ENAPSDO (0), .ENAPAR (0), .ENAECC (1), .ENADEC (0), .ECCWDTH (ECCBITS),
                               .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                               .NUMSROW (NUMVROW), .BITSROW (BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITWBNK+BITWROW),
                               .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPGEN (0), .FLOPMEM (0), .FLOPOUT (1), .ENAPADR (1), .RSTONES (1))
          infra (.write (t2_writeA_a1_wire), .wr_adr (t2_addrA_a1_wire), .din (t2_dinA_a1_wire),
                 .read (t2_readB_a1_wire), .rd_adr (t2_addrB_a1_wire), .rd_dout (t2_doutB_a1_wire[t2r][t2b]),
                 .rd_fwrd (t2_fwrdB_a1_wire[t2r][t2b]), .rd_serr(t2_serrB_a1_wire[t2r][t2b]), .rd_derr(t2_derrB_a1_wire[t2r][t2b]), .rd_padr(t2_padrB_a1_wire[t2r][t2b]),
                 .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
                 .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (SDOUT_WIDTH), .ENAPSDO (0), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                           .NUMWROW (NUMWROW), .BITWROW (BITWROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                           .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
          infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
                 .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
                 .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr(mem_rd_derr_wire), .rd_padr(mem_rd_padr_wire),
                 .mem_write (t2_writeA_wire[t2r][t2b]), .mem_wr_adr (t2_addrA_wire[t2r][t2b]), .mem_bw(), .mem_din (t2_dinA_wire[t2r][t2b]),
                 .mem_read (t2_readB_wire[t2r][t2b]), .mem_rd_adr (t2_addrB_wire[t2r][t2b]), .mem_rd_dout (t2_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_vrow));
      end
    end
  end
endgenerate

reg [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_writeA;
reg [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_addrA;
reg [(NUMDQPT/NUMEGPT)*NUMVBNK*SDOUT_WIDTH-1:0] t2_dinA;
reg [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_readB;
reg [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_addrB;
integer t2r_int, t2b_int;
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
  for (t2r_int=0; t2r_int<(NUMDQPT/NUMEGPT); t2r_int=t2r_int+1) begin: lp1
    for (t2b_int=0; t2b_int<NUMVBNK; t2b_int=t2b_int+1) begin: lp2
      t2_writeA = t2_writeA | (t2_writeA_wire[t2r_int][t2b_int] << (t2r_int*NUMVBNK+t2b_int));
      t2_addrA = t2_addrA | (t2_addrA_wire[t2r_int][t2b_int] << ((t2r_int*NUMVBNK+t2b_int)*BITVROW));
      t2_dinA = t2_dinA | (t2_dinA_wire[t2r_int][t2b_int] << ((t2r_int*NUMVBNK+t2b_int)*SDOUT_WIDTH));
      t2_readB = t2_readB | (t2_readB_wire[t2r_int][t2b_int] << (t2r_int*NUMVBNK+t2b_int));
      t2_addrB = t2_addrB | (t2_addrB_wire[t2r_int][t2b_int] << ((t2r_int*NUMVBNK+t2b_int)*BITVROW));
      t2_doutB_a1 = t2_doutB_a1 | (t2_doutB_a1_wire[t2r_int][t2b_int] << ((t2r_int*NUMVBNK+t2b_int)*BITVROW));
      t2_fwrdB_a1 = t2_fwrdB_a1 | (t2_fwrdB_a1_wire[t2r_int][t2b_int] << (t2r_int*NUMVBNK+t2b_int));
      t2_serrB_a1 = t2_serrB_a1 | (t2_serrB_a1_wire[t2r_int][t2b_int] << (t2r_int*NUMVBNK+t2b_int));
      t2_derrB_a1 = t2_derrB_a1 | (t2_derrB_a1_wire[t2r_int][t2b_int] << (t2r_int*NUMVBNK+t2b_int));
      t2_padrB_a1 = t2_padrB_a1 | (t2_padrB_a1_wire[t2r_int][t2b_int] << ((t2r_int*NUMVBNK+t2b_int)*BITVROW));
    end
  end
end

endmodule
