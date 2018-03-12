module algo_1k4l_a440_top (clk, rst, ready,
                               push, pu_owr, pu_prt, pu_ptr, pu_cvld, pu_cnt, pu_tail,
                               pop, po_ndq, po_prt, po_cvld, po_cmt, po_cnt, po_pvld, po_ptr,
                               cp_read, cp_write, cp_adr, cp_din, cp_vld, cp_dout,
                               t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
                               t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
                               t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
                               t4_writeA, t4_addrA, t4_dinA, t4_readB, t4_addrB, t4_doutB,
                               t5_writeA, t5_addrA, t5_dinA, t5_readB, t5_addrB, t5_doutB,
                               t6_writeA, t6_addrA, t6_dinA, t6_readB, t6_addrB, t6_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMQPRT = 64;
  parameter BITQPRT = 6;
  parameter NUMPING = 4;
  parameter BITPING = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter BITQCNT = BITADDR+1;
  parameter NUMPUPT = 1;
  parameter NUMPOPT = 1;
  parameter NUMWTPT = 1;
  parameter BITPUPT = 1;
  parameter BITWTPT = 1;
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
  parameter NUMWROW = NUMSROW; // STACK Parameters
  parameter BITWROW = BITSROW;
  parameter NUMDBNK = 8;
  parameter BITDBNK = 3;
  parameter NUMDROW = 1024;
  parameter BITDROW = 10;
  parameter NUMWBNK = 1;
  parameter BITWBNK = 0;
  parameter LINK_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;
  parameter FLOPOUT = 0;

  parameter BITQPTR = BITADDR;
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter BITCPAD = BITQPRT;
  parameter CPUWDTH = 2*BITPING+BITQCNT+2*NUMPING*BITQPTR;

  parameter QPTR_WIDTH = BITQPTR;
  parameter DATA_WIDTH = WIDTH;

  parameter FIFOCNT = NUMQPRT;
  parameter BITFIFO = BITQPRT;
  parameter BITBITQPTR = 4;

  input [NUMPUPT-1:0]              push;
  input [NUMPUPT-1:0]              pu_owr;
  input [NUMPUPT*BITQPRT-1:0]      pu_prt;
  input [NUMPUPT*BITQPTR-1:0]      pu_ptr;
  output [NUMPUPT-1:0]             pu_cvld;
  output [NUMPUPT*BITQCNT-1:0]     pu_cnt;
  output [NUMPUPT*BITQPTR-1:0]     pu_tail;

  input [NUMPOPT-1:0]              pop;
  input [NUMPOPT-1:0]              po_ndq;
  input [NUMPOPT*BITQPRT-1:0]      po_prt;
  output [NUMPOPT-1:0]             po_cvld;
  output [NUMPOPT-1:0]             po_cmt;
  output [NUMPOPT*BITQCNT-1:0]     po_cnt;
  output [NUMPOPT-1:0]             po_pvld;
  output [NUMPOPT*BITQPTR-1:0]     po_ptr;

  input                            cp_read;
  input                            cp_write;
  input [BITCPAD-1:0]              cp_adr;
  input [CPUWDTH-1:0]              cp_din;
  output                           cp_vld;
  output [CPUWDTH-1:0]             cp_dout;

  output                           ready;
  input                            clk, rst;

  output [NUMWTPT-1:0]                     t1_writeA;
  output [NUMWTPT*BITADDR-1:0]             t1_addrA;
  output [NUMWTPT*QPTR_WIDTH-1:0]          t1_dinA;
  output [NUMPOPT-1:0]                     t1_readB;
  output [NUMPOPT*BITADDR-1:0]             t1_addrB;
  input [NUMPOPT*QPTR_WIDTH-1:0]           t1_doutB;

  output [NUMPOPT-1:0]                     t2_writeA;
  output [NUMPOPT*BITQPRT-1:0]             t2_addrA;
  output [NUMPOPT*BITPING-1:0]             t2_dinA;
  output [NUMPOPT-1:0]                     t2_readB;
  output [NUMPOPT*BITQPRT-1:0]             t2_addrB;
  input [NUMPOPT*BITPING-1:0]              t2_doutB;

  output [NUMPUPT-1:0]                     t3_writeA;
  output [NUMPUPT*BITQPRT-1:0]             t3_addrA;
  output [NUMPUPT*BITPING-1:0]             t3_dinA;
  output [NUMPUPT-1:0]                     t3_readB;
  output [NUMPUPT*BITQPRT-1:0]             t3_addrB;
  input [NUMPUPT*BITPING-1:0]              t3_doutB;

  output [(NUMPOPT+NUMPUPT)-1:0]           t4_writeA;
  output [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t4_addrA;
  output [(NUMPOPT+NUMPUPT)*BITQCNT-1:0]   t4_dinA;
  output [(NUMPOPT+NUMPUPT)-1:0]           t4_readB;
  output [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t4_addrB;
  input [(NUMPOPT+NUMPUPT)*BITQCNT-1:0]    t4_doutB;

  output [(NUMPOPT+NUMPUPT)-1:0]           t5_writeA;
  output [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t5_addrA;
  output [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t5_dinA;
  output [(NUMPOPT+NUMPUPT)-1:0]           t5_readB;
  output [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t5_addrB;
  input [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t5_doutB;

  output [NUMPUPT-1:0]                     t6_writeA;
  output [NUMPUPT*BITQPRT-1:0]             t6_addrA;
  output [NUMPUPT*NUMPING*BITQPTR-1:0]     t6_dinA;
  output [NUMPUPT-1:0]                     t6_readB;
  output [NUMPUPT*BITQPRT-1:0]             t6_addrB;
  input [NUMPUPT*NUMPING*BITQPTR-1:0]      t6_doutB;

`ifdef FORMAL 

wire [BITQPRT-1:0] select_qprt;
wire [BITADDR-1:0] select_addr;
assume_select_qprt_range: assume property (@(posedge clk) disable iff (rst) (select_qprt < NUMQPRT));
assume_select_qprt_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_qprt));
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

wire [BITQPRT-2-1:0] select_qprt_vrow;
np2_addr #(
  .NUMADDR (NUMQPRT/4), .BITADDR (BITQPRT-2),
  .NUMVBNK (1), .BITVBNK (0),
  .NUMVROW (NUMQPRT/4), .BITVROW (BITQPRT-2))
  adr_po_pu_ptr (.vbadr(), .vradr(select_qprt_vrow), .vaddr(select_qprt));
  
wire [BITQPRT-2-1:0] select_qprt_srow;
np2_addr #(
  .NUMADDR (NUMQPRT/4), .BITADDR (BITQPRT-2),
  .NUMVBNK (1), .BITVBNK (0),
  .NUMVROW (NUMQPRT/4), .BITVROW (BITQPRT-2))
  vrow_po_pu_ptr (.vbadr(), .vradr(select_qprt_srow), .vaddr(select_qprt_vrow));

`else
wire [BITQPRT-1:0] select_qprt = 0;
wire [BITADDR-1:0] select_addr = 0;
wire [BITVROW-1:0] select_vrow = 0;
wire [BITSROW-1:0] select_srow = 0;
wire [BITDROW-1:0] select_drow = 0;
`endif

wire [NUMPOPT*BITPING-1:0]                   t2_doutB_a1;
wire [NUMPUPT*BITPING-1:0]                   t3_doutB_a1;
wire [(NUMPOPT+NUMPUPT)*BITQCNT-1:0]         t4_doutB_a1;
wire [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t5_doutB_a1;
wire [NUMPUPT*NUMPING*BITQPTR-1:0]           t6_doutB_a1;


wire [NUMPUPT-1:0]                     t1_writeA_a1;
wire [NUMPUPT*BITADDR-1:0]             t1_addrA_a1;
wire [NUMPUPT*BITQPTR-1:0]             t1_dinA_a1;
wire [NUMPOPT-1:0]                     t1_readB_a1;
wire [NUMPOPT*BITADDR-1:0]             t1_addrB_a1;
reg  [NUMPOPT*BITQPTR-1:0]             t1_doutB_a1;
reg  [NUMPOPT-1:0]                     t1_rd_vldB_a1;
reg  [NUMPOPT-1:0]                     t1_fwrdB_a1;
reg  [NUMPOPT-1:0]                     t1_serrB_a1;
reg  [NUMPOPT-1:0]                     t1_derrB_a1;
reg  [NUMPOPT*BITADDR-1:0]             t1_padrB_a1;

wire a1_ready;
wire a2_ready;
assign ready = a1_ready && a2_ready;

generate if (1) begin: a1_loop

  algo_mrnw_pque_f32c #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMPUPT (NUMPUPT), .NUMPOPT (NUMPOPT),
                       .NUMQPRT (NUMQPRT), .BITQPRT (BITQPRT), .NUMPING (NUMPING), .BITPING (BITPING),
                       .NUMADDR (NUMADDR), .BITADDR (BITADDR), .BITPADR (BITPADR-1),
                       .LINK_DELAY(LINK_DELAY+FLOPMEM+FLOPECC), .FLOPIN (FLOPIN), .FLOPOUT(FLOPOUT))
    algo (.ready(a1_ready), .clk(clk), .rst (rst),
          .push(push), .pu_owr(pu_owr), .pu_prt(pu_prt), .pu_ptr(pu_ptr), .pu_cvld(pu_cvld), .pu_cnt(pu_cnt), .pu_tail(pu_tail),
          .pop(pop), .po_ndq(po_ndq), .po_prt(po_prt), .po_cvld(po_cvld), .po_cmt(po_cmt), .po_cnt(po_cnt),
          .po_pvld(po_pvld), .po_ptr(po_ptr),
          .cp_read(cp_read), .cp_write(cp_write), .cp_adr(cp_adr), .cp_din(cp_din), .cp_vld(cp_vld), .cp_dout(cp_dout),
          .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1), .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1),
          .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB_a1),
          .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB_a1),
          .t4_writeA(t4_writeA), .t4_addrA(t4_addrA), .t4_dinA(t4_dinA), .t4_readB(t4_readB), .t4_addrB(t4_addrB), .t4_doutB(t4_doutB_a1),
          .t5_writeA(t5_writeA), .t5_addrA(t5_addrA), .t5_dinA(t5_dinA), .t5_readB(t5_readB), .t5_addrB(t5_addrB), .t5_doutB(t5_doutB_a1),
          .t6_writeA(t6_writeA), .t6_addrA(t6_addrA), .t6_dinA(t6_dinA), .t6_readB(t6_readB), .t6_addrB(t6_addrB), .t6_doutB(t6_doutB_a1),
          .select_qprt (select_qprt), .select_addr (select_addr));

end
endgenerate

wire [BITPADR-1:0] rd_padr_a2;
wire rd_serr_a2;
wire rd_derr_a2;
wire wr_bp_a2;
// TBD assert_wr_bp_check: assert property (@(posedge clk) disable iff (rst) !wr_bp_a2);
wire [NUMWTPT-1:0] t1_writeA_a2;
wire [NUMWTPT*BITADDR-1:0] t1_addrA_a2;
wire [NUMWTPT*BITQPTR-1:0] t1_dinA_a2;
wire [NUMPOPT-1:0] t1_readB_a2;
wire [NUMPOPT*BITADDR-1:0] t1_addrB_a2;
reg  [NUMPOPT*BITQPTR-1:0] t1_doutB_a2;
reg  [NUMPOPT-1:0] t1_fwrdB_a2;
reg  [NUMPOPT-1:0] t1_serrB_a2;
reg  [NUMPOPT-1:0] t1_derrB_a2;
reg  [NUMPOPT*(BITPADR-1)-1:0] t1_padrB_a2; 
wire [BITFIFO:0] bp_thr = NUMQPRT;

generate if (1) begin: a2_loop

  algo_mrnwt_base #(.WIDTH(BITQPTR), .BITWDTH(BITBITQPTR), .NUMRDPT (NUMPOPT), .NUMWRPT (NUMPUPT), .BITWRPT (BITPUPT), .NUMWTPT (1),
                    .NUMADDR(NUMADDR), .BITADDR(BITADDR), .BITPADR(BITPADR-1), .FIFOCNT (NUMQPRT), .BITFIFO(BITFIFO),
                    //.SRAM_DELAY(LINK_DELAY+FLOPMEM+1), .FLOPIN(0), .FLOPOUT(0))
                    .SRAM_DELAY(LINK_DELAY+FLOPMEM+FLOPECC+1), .FLOPIN(0), .FLOPOUT(0))
    algo (.ready(a2_ready), .clk(clk), .rst (rst),
          .write(t1_writeA_a1), .wr_adr(t1_addrA_a1), .din(t1_dinA_a1), .wr_bp(wr_bp_a2), .bp_thr(bp_thr),
          .read(t1_readB_a1), .rd_adr(t1_addrB_a1), .rd_vld(t1_rd_vldB_a1), .rd_dout(t1_doutB_a1),
          .rd_fwrd(t1_fwrdB_a1), .rd_serr(t1_serrB_a1), .rd_derr(t1_derrB_a1), .rd_padr(),
          .t1_writeA(t1_writeA_a2), .t1_addrA(t1_addrA_a2), .t1_dinA(t1_dinA_a2),
          .t1_readB(t1_readB_a2), .t1_addrB(t1_addrB_a2), .t1_doutB(t1_doutB_a2),
          .t1_fwrdB(t1_fwrdB_a2), .t1_serrB(t1_serrB_a2), .t1_derrB(t1_derrB_a2), .t1_padrB(t1_padrB_a2),
          //.select_addr(select_addr), .select_bit(select_bit));
          .select_addr(select_addr), .select_bit(4'h0)); //SU_FIXME

end
endgenerate


wire t1_writeA_wire [0:NUMWTPT-1];
wire [BITADDR-1:0] t1_addrA_wire [0:NUMWTPT-1];
wire [QPTR_WIDTH-1:0] t1_bwA_wire [0:NUMWTPT-1];
wire [QPTR_WIDTH-1:0] t1_dinA_wire [0:NUMWTPT-1];
wire t1_readB_wire [0:NUMPOPT-1];
wire [BITADDR-1:0] t1_addrB_wire [0:NUMPOPT-1];
wire [BITQPTR-1:0] t1_doutB_a2_wire [0:NUMPOPT-1];
wire t1_fwrdB_a2_wire [0:NUMPOPT-1];
wire t1_serrB_a2_wire [0:NUMPOPT-1];
wire t1_derrB_a2_wire [0:NUMPOPT-1];
wire [BITADDR-1:0] t1_padrB_a2_wire [0:NUMPOPT-1];

genvar t1r;
generate
  for (t1r=0; t1r<NUMWTPT; t1r=t1r+1) begin: t1r_loop
    wire t1_writeA_a2_wire = t1_writeA_a2 >> (t1r);
    wire [BITADDR-1:0] t1_addrA_a2_wire = t1_addrA_a2 >> (t1r*BITADDR);
    wire [BITQPTR-1:0] t1_dinA_a2_wire = t1_dinA_a2 >> (t1r*WIDTH);
    wire t1_readB_a2_wire = t1_readB_a2 >> (t1r);
    wire [BITADDR-1:0] t1_addrB_a2_wire = t1_addrB_a2 >> (t1r*BITADDR);

    wire [NUMPOPT*QPTR_WIDTH-1:0] t1_doutB_wire = t1_doutB >> (t1r*QPTR_WIDTH);

    wire t1_mem_write_wire;
    wire [BITADDR-1:0] t1_mem_wr_adr_wire;
    wire [QPTR_WIDTH-1:0] t1_mem_bw_wire;
    wire [QPTR_WIDTH-1:0] t1_mem_din_wire;
    wire t1_mem_read_wire;
    wire [BITADDR-1:0] t1_mem_rd_adr_wire;
    wire [QPTR_WIDTH-1:0] t1_mem_rd_dout_wire;
    wire t1_mem_rd_fwrd_wire;
    wire t1_mem_rd_serr_wire;
    wire t1_mem_rd_derr_wire;
    wire [BITADDR-1:0] t1_mem_rd_padr_wire;
    if (1) begin: align_loop
      infra_align_ecc_1r1w #(.WIDTH (BITQPTR), .ENAPSDO (NUMWRDS==1), .ENAECC (1), .ECCWDTH (QPTR_WIDTH-BITQPTR), .ENAPADR (0),
                             .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                             .NUMSROW (NUMADDR), .BITSROW (BITADDR), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITADDR),
                             .SRAM_DELAY (LINK_DELAY+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC))
        infra (.write(t1_writeA_a2_wire), .wr_adr(t1_addrA_a2_wire), .din(t1_dinA_a2_wire),
               .read(t1_readB_a2_wire), .rd_adr(t1_addrB_a2_wire),
               .rd_dout(t1_doutB_a2_wire[t1r]), .rd_fwrd(t1_fwrdB_a2_wire[t1r]),
               .rd_serr(t1_serrB_a2_wire[t1r]), .rd_derr(t1_derrB_a2_wire[t1r]), .rd_padr(t1_padrB_a2_wire[t1r]),
               .mem_write (t1_mem_write_wire), .mem_wr_adr(t1_mem_wr_adr_wire), .mem_bw (t1_mem_bw_wire), .mem_din (t1_mem_din_wire),
               .mem_read (t1_mem_read_wire), .mem_rd_adr(t1_mem_rd_adr_wire), .mem_rd_dout (t1_mem_rd_dout_wire),
               .mem_rd_fwrd(t1_mem_rd_fwrd_wire), .mem_rd_padr(t1_mem_rd_padr_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_vrow));
    end

    if (1) begin: stack_loop
      infra_stack_1r1w #(.WIDTH (QPTR_WIDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (NUMSROW), .BITADDR (BITSROW),
                         .NUMWROW (NUMADDR), .BITWROW (BITADDR), .NUMWBNK (1), .BITWBNK (0),
                         .SRAM_DELAY (LINK_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
        infra (.write (t1_mem_write_wire), .wr_adr (t1_mem_wr_adr_wire), .bw (t1_mem_bw_wire), .din (t1_mem_din_wire),
               .read (t1_mem_read_wire), .rd_adr (t1_mem_rd_adr_wire), .rd_dout (t1_mem_rd_dout_wire),
               .rd_fwrd (t1_mem_rd_fwrd_wire), .rd_serr (t1_mem_rd_serr_wire), .rd_derr(t1_mem_rd_derr_wire), .rd_padr(t1_mem_rd_padr_wire),
               .mem_write (t1_writeA_wire[t1r]), .mem_wr_adr(t1_addrA_wire[t1r]),
               .mem_bw (t1_bwA_wire[t1r]), .mem_din (t1_dinA_wire[t1r]),
               .mem_read (t1_readB_wire[t1r]), .mem_rd_adr(t1_addrB_wire[t1r]), .mem_rd_dout (t1_doutB_wire),
               .clk (clk), .rst(rst),
               .select_addr (select_srow));
    end
  end
endgenerate

reg [NUMWTPT-1:0] t1_writeA;
reg [NUMWTPT*BITADDR-1:0] t1_addrA;
reg [NUMWTPT*QPTR_WIDTH-1:0] t1_bwA;
reg [NUMWTPT*QPTR_WIDTH-1:0] t1_dinA;
reg [NUMPOPT-1:0] t1_readB;
reg [NUMPOPT*BITADDR-1:0] t1_addrB;
integer t1r_int;
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
  for (t1r_int=0; t1r_int<NUMWTPT; t1r_int=t1r_int+1) begin
    t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int] << (t1r_int));
    t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int] << (t1r_int*BITADDR));
    t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int] << (t1r_int*QPTR_WIDTH));
    t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int] << (t1r_int*QPTR_WIDTH));
  end
  for (t1r_int=0; t1r_int<NUMPOPT; t1r_int=t1r_int+1) begin
    t1_readB = t1_readB | (t1_readB_wire[t1r_int] << (t1r_int));
    t1_addrB = t1_addrB | (t1_addrB_wire[t1r_int] << (t1r_int*BITADDR));
    t1_doutB_a2 = t1_doutB_a2 | (t1_doutB_a2_wire[t1r_int] << (t1r_int*BITQPTR));
    t1_fwrdB_a2 = t1_fwrdB_a2 | (t1_fwrdB_a2_wire[t1r_int] << (t1r_int));
    t1_serrB_a2 = t1_serrB_a2 | (t1_serrB_a2_wire[t1r_int] << (t1r_int));
    t1_derrB_a2 = t1_derrB_a2 | (t1_derrB_a2_wire[t1r_int] << (t1r_int));
    t1_padrB_a2 = t1_padrB_a2 | (t1_padrB_a2_wire[t1r_int] << (t1r_int*BITADDR));
  end
end

assign t2_doutB_a1 = t2_doutB;
assign t3_doutB_a1 = t3_doutB;
assign t4_doutB_a1 = t4_doutB;
assign t5_doutB_a1 = t5_doutB;
assign t6_doutB_a1 = t6_doutB;

endmodule // algo_1k4l_a440_top

