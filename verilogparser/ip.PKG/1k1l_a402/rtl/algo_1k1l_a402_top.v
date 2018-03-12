module algo_1k1l_a402_top (clk, rst, ready,
                               push, pu_prt, pu_din,
                               pop, po_prt,  po_dvld, po_dout, po_cserr, po_cderr, po_dserr, po_dderr,
                               freecnt,
                               cp_read, cp_write, cp_adr, cp_din, cp_vld, cp_dout,
                               t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_serrB, t1_derrB, t1_padrB,
                               t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_serrB, t2_derrB, t2_padrB,
                               t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
                               t4_writeA, t4_addrA, t4_dinA, t4_readB, t4_addrB, t4_doutB,
                               t5_writeA, t5_addrA, t5_dinA, t5_readB, t5_addrB, t5_doutB,
                               t6_writeA, t6_addrA, t6_dinA, t6_readB, t6_addrB, t6_doutB,
                               t7_writeA, t7_addrA, t7_dinA, t7_readB, t7_addrB, t7_doutB,
                               t8_writeA, t8_addrA, t8_dinA, t8_readB, t8_addrB, t8_doutB, t8_serrB, t8_derrB, t8_padrB);

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
  parameter NUMVROW = 8192;  // ALGO2 Parameters
  parameter BITVROW = 13;
  parameter NUMVBNK = 1;
  parameter BITVBNK = 0;
  parameter NUMPBNK = 11;
  parameter BITPBNK = 4;
  parameter NUMWRDS = 1;     // ALIGN Parameters
  parameter BITWRDS = 0;
  parameter NUMSROW = 8192;
  parameter BITSROW = 13;
  parameter NUMWROW = NUMSROW; // STACK Parameters
  parameter BITWROW = BITSROW;
  parameter NUMDBNK = 8;
  parameter BITDBNK = 3;
  parameter NUMDROW = 1024;
  parameter BITDROW = 10;
  parameter NUMWBNK = 1;
  parameter BITWBNK = 0;
  parameter QPTR_DELAY = 1;
  parameter LINK_DELAY = 2;
  parameter DATA_DELAY = 2;
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

  input [NUMPUPT-1:0]              push;
  input [NUMPUPT*BITQPRT-1:0]      pu_prt;
  input [NUMPUPT*WIDTH-1:0]        pu_din;

  input [NUMPOPT-1:0]              pop;
  input [NUMPOPT*BITQPRT-1:0]      po_prt;
  output [NUMPOPT-1:0]             po_dvld;
  output [NUMPOPT*WIDTH-1:0]       po_dout;
  output [NUMPOPT-1:0]             po_cserr;
  output [NUMPOPT-1:0]             po_cderr;
  output [NUMPOPT-1:0]             po_dserr;
  output [NUMPOPT-1:0]             po_dderr;

  input                            cp_read;
  input                            cp_write;
  input [BITCPAD-1:0]              cp_adr;
  input [CPUWDTH-1:0]              cp_din;
  output                           cp_vld;
  output [CPUWDTH-1:0]             cp_dout;

  output [BITQCNT-1:0]             freecnt;
  output                           ready;
  input                            clk, rst;

  output [NUMPUPT-1:0]                     t1_writeA;
  output [NUMPUPT*BITADDR-1:0]             t1_addrA;
  output [NUMPUPT*QPTR_WIDTH-1:0]          t1_dinA;
  output [NUMPOPT-1:0]                     t1_readB;
  output [NUMPOPT*BITADDR-1:0]             t1_addrB;
  input [NUMPOPT*QPTR_WIDTH-1:0]           t1_doutB;
  output  [NUMPOPT-1:0]                    t1_serrB;
  output  [NUMPOPT-1:0]                    t1_derrB;
  output  [NUMPOPT*BITADDR-1:0]            t1_padrB;

  output [NUMPUPT-1:0]                     t2_writeA;
  output [NUMPUPT*BITADDR-1:0]             t2_addrA;
  output [NUMPUPT*DATA_WIDTH-1:0]          t2_dinA;
  output [NUMPOPT-1:0]                     t2_readB;
  output [NUMPOPT*BITADDR-1:0]             t2_addrB;
  input [NUMPOPT*DATA_WIDTH-1:0]           t2_doutB;
  output  [NUMPOPT-1:0]                    t2_serrB;
  output  [NUMPOPT-1:0]                    t2_derrB;
  output  [NUMPOPT*BITADDR-1:0]            t2_padrB;

  output [NUMPOPT-1:0]                     t3_writeA;
  output [NUMPOPT*BITQPRT-1:0]             t3_addrA;
  output [NUMPOPT*BITPING-1:0]             t3_dinA;
  output [NUMPOPT-1:0]                     t3_readB;
  output [NUMPOPT*BITQPRT-1:0]             t3_addrB;
  input [NUMPOPT*BITPING-1:0]              t3_doutB;

  output [NUMPUPT-1:0]                     t4_writeA;
  output [NUMPUPT*BITQPRT-1:0]             t4_addrA;
  output [NUMPUPT*BITPING-1:0]             t4_dinA;
  output [NUMPUPT-1:0]                     t4_readB;
  output [NUMPUPT*BITQPRT-1:0]             t4_addrB;
  input [NUMPUPT*BITPING-1:0]              t4_doutB;

  output [(NUMPOPT+NUMPUPT)-1:0]           t5_writeA;
  output [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t5_addrA;
  output [(NUMPOPT+NUMPUPT)*BITQCNT-1:0]   t5_dinA;
  output [(NUMPOPT+NUMPUPT)-1:0]           t5_readB;
  output [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t5_addrB;
  input [(NUMPOPT+NUMPUPT)*BITQCNT-1:0]    t5_doutB;

  output [(NUMPOPT+NUMPUPT)-1:0]           t6_writeA;
  output [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t6_addrA;
  output [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t6_dinA;
  output [(NUMPOPT+NUMPUPT)-1:0]           t6_readB;
  output [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t6_addrB;
  input [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t6_doutB;

  output [NUMPUPT-1:0]                     t7_writeA;
  output [NUMPUPT*BITQPRT-1:0]             t7_addrA;
  output [NUMPUPT*NUMPING*BITQPTR-1:0]     t7_dinA;
  output [NUMPUPT-1:0]                     t7_readB;
  output [NUMPUPT*BITQPRT-1:0]             t7_addrB;
  input [NUMPUPT*NUMPING*BITQPTR-1:0]      t7_doutB;

  output [NUMPUPT-1:0]                     t8_writeA;
  output [NUMPUPT*BITADDR-1:0]             t8_addrA;
  output [NUMPUPT*QPTR_WIDTH-1:0]          t8_dinA;
  output [NUMPOPT-1:0]                     t8_readB;
  output [NUMPOPT*BITADDR-1:0]             t8_addrB;
  input [NUMPOPT*QPTR_WIDTH-1:0]           t8_doutB;
  output  [NUMPOPT-1:0]                    t8_serrB;
  output  [NUMPOPT-1:0]                    t8_derrB;
  output  [NUMPOPT*BITADDR-1:0]            t8_padrB;

  wire [NUMPOPT-1:0] qm2fl_push;
  wire [NUMPOPT*BITQPTR-1:0] qm2fl_ptr;

  wire [NUMPUPT-1:0] fl2qm_push;
  wire [NUMPUPT*BITQPRT-1:0] fl2qm_prt;
  wire [NUMPUPT*WIDTH-1:0] fl2qm_din;
  wire [NUMPUPT*BITQPTR-1:0] fl2qm_ptr;

  localparam FLDELAY = 0;

  reg [NUMPUPT*WIDTH-1:0] pu_din_dly [0:FLDELAY];
  reg [BITQPRT - 1:0]     pu_prt_dly [0:FLDELAY];

  genvar fld_int;
  generate
    for(fld_int=0; fld_int<=FLDELAY; fld_int=fld_int+1) begin: fld_loop
      if(fld_int > 0) begin
        always@(posedge clk) begin
          pu_din_dly[fld_int] <= pu_din_dly[fld_int-1];
          pu_prt_dly[fld_int] <= pu_prt_dly[fld_int-1];
        end
      end else begin
        always_comb begin
          pu_din_dly[fld_int] = pu_din;
          pu_prt_dly[fld_int] = pu_prt;
        end
      end
    end // fld_loop
  endgenerate


  assign fl2qm_prt = pu_prt_dly[FLDELAY];
  assign fl2qm_din = pu_din_dly[FLDELAY];
  wire fl_ready, qm_ready;
  assign ready = fl_ready && qm_ready;

`ifdef FORMAL 

wire [BITQPRT-1:0] select_qprt;
wire [BITADDR-1:0] select_addr;
assume_select_qprt_range: assume property (@(posedge clk) disable iff (rst) (select_qprt < NUMQPRT));
assume_select_qprt_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_qprt));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
/*
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
*/
`else
wire [BITQPRT-1:0] select_qprt = 0;
wire [BITADDR-1:0] select_addr = 0;
/*
wire [BITVROW-1:0] select_vrow = 0;
wire [BITSROW-1:0] select_srow = 0;
wire [BITDROW-1:0] select_drow = 0;
*/
`endif

wire [NUMPOPT*BITPING-1:0]                   t3_doutB_a1;
wire [NUMPUPT*BITPING-1:0]                   t4_doutB_a1;
wire [(NUMPOPT+NUMPUPT)*BITQCNT-1:0]         t5_doutB_a1;
wire [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t6_doutB_a1;
wire [NUMPUPT*NUMPING*BITQPTR-1:0]           t7_doutB_a1;


wire [NUMPUPT-1:0]                     t1_writeA_a1;
wire [NUMPUPT*BITADDR-1:0]             t1_addrA_a1;
wire [NUMPUPT*BITQPTR-1:0]             t1_dinA_a1;
wire [NUMPOPT-1:0]                     t1_readB_a1;
wire [NUMPOPT*BITADDR-1:0]             t1_addrB_a1;
reg  [NUMPOPT*BITQPTR-1:0]             t1_doutB_a1;
reg  [NUMPOPT-1:0]                     t1_fwrdB_a1;
reg  [NUMPOPT-1:0]                     t1_serrB_a1;
reg  [NUMPOPT-1:0]                     t1_derrB_a1;
reg  [NUMPOPT*BITADDR-1:0]             t1_padrB_a1;

wire [NUMPUPT-1:0]                     t2_writeA_a1;
wire [NUMPUPT*BITADDR-1:0]             t2_addrA_a1;
wire [NUMPUPT*WIDTH-1:0]               t2_dinA_a1;
wire [NUMPOPT-1:0]                     t2_readB_a1;
wire [NUMPOPT*BITADDR-1:0]             t2_addrB_a1;

reg  [NUMPOPT*WIDTH-1:0]               t2_doutB_a1;
reg  [NUMPOPT-1:0]                     t2_fwrdB_a1;
reg  [NUMPOPT-1:0]                     t2_serrB_a1;
reg  [NUMPOPT-1:0]                     t2_derrB_a1;
reg  [NUMPOPT*BITADDR-1:0]             t2_padrB_a1;

wire [NUMPUPT-1:0]                     t8_writeA_a2;
wire [NUMPUPT*BITADDR-1:0]             t8_addrA_a2;
wire [NUMPUPT*BITQPTR-1:0]             t8_dinA_a2;
wire [NUMPOPT-1:0]                     t8_readB_a2;
wire [NUMPOPT*BITADDR-1:0]             t8_addrB_a2;

reg  [NUMPOPT*BITQPTR-1:0]             t8_doutB_a2;
reg  [NUMPOPT-1:0]                     t8_fwrdB_a2;
reg  [NUMPOPT-1:0]                     t8_serrB_a2;
reg  [NUMPOPT-1:0]                     t8_derrB_a2;
reg  [NUMPOPT*BITADDR-1:0]             t8_padrB_a2;
reg  [BITQCNT-1:0]                     freecnt;

wire [NUMPUPT*BITQCNT-1:0]  push_cnt;
wire [NUMPUPT*BITQPTR-1:0]  push_tail;

generate if (1) begin: a1_loop

  algo_mrnw_pque_f32 #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMPUPT (NUMPUPT), .NUMPOPT (NUMPOPT),
                       .NUMQPRT (NUMQPRT), .BITQPRT (BITQPRT), .NUMPING (NUMPING), .BITPING (BITPING),
                       .NUMADDR (NUMADDR), .BITADDR (BITADDR), .BITQPTR(BITQPTR), .BITPADR (BITPADR-1),
                       .QPTR_DELAY(QPTR_DELAY), .LINK_DELAY(LINK_DELAY+FLOPECC), .DATA_DELAY(DATA_DELAY+FLOPECC), .FLOPIN (FLOPIN), .FLOPOUT(FLOPOUT))
    algo (.ready(qm_ready), .clk(clk), .rst (rst),
          .push(fl2qm_push), .pu_owr({NUMPUPT{1'b0}}), .pu_prt(fl2qm_prt), .pu_ptr(fl2qm_ptr), .pu_din(fl2qm_din), .pu_cvld(), .pu_cnt(push_cnt), .pu_tail(push_tail), .pu_cserr(),  .pu_cderr(), 
          .pop(pop), .po_ndq({NUMPOPT{1'b0}}), .po_prt(po_prt), .po_cvld(), .po_cmt(), .po_cnt(), .po_cserr(po_cserr), .po_cderr(po_cderr),
          .po_pvld(qm2fl_push), .po_ptr(qm2fl_ptr), .po_dvld(po_dvld), .po_dout(po_dout), .po_pserr(), .po_pderr(),  .po_dserr(po_dserr), .po_dderr(po_dderr),
          .cp_read(cp_read), .cp_write(cp_write), .cp_adr(cp_adr), .cp_din(cp_din), .cp_vld(cp_vld), .cp_dout(cp_dout),
          .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1), .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1), .t1_serrB(t1_serrB_a1), .t1_derrB(t1_serrB_a1),
          .t2_writeA(t2_writeA_a1), .t2_addrA(t2_addrA_a1), .t2_dinA(t2_dinA_a1), .t2_readB(t2_readB_a1), .t2_addrB(t2_addrB_a1), .t2_doutB(t2_doutB_a1), .t2_serrB(t2_serrB_a1), .t2_derrB(t2_serrB_a1),
          .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB_a1), .t3_serrB({NUMPOPT{1'b0}}), .t3_derrB({NUMPOPT{1'b0}}),
          .t4_writeA(t4_writeA), .t4_addrA(t4_addrA), .t4_dinA(t4_dinA), .t4_readB(t4_readB), .t4_addrB(t4_addrB), .t4_doutB(t4_doutB_a1), .t4_serrB({NUMPUPT{1'b0}}), .t4_derrB({NUMPUPT{1'b0}}),
          .t5_writeA(t5_writeA), .t5_addrA(t5_addrA), .t5_dinA(t5_dinA), .t5_readB(t5_readB), .t5_addrB(t5_addrB), .t5_doutB(t5_doutB_a1), .t5_serrB({(NUMPOPT+NUMPUPT){1'b0}}), .t5_derrB({(NUMPOPT+NUMPUPT){1'b0}}),
          .t6_writeA(t6_writeA), .t6_addrA(t6_addrA), .t6_dinA(t6_dinA), .t6_readB(t6_readB), .t6_addrB(t6_addrB), .t6_doutB(t6_doutB_a1), .t6_serrB({(NUMPOPT+NUMPUPT){1'b0}}), .t6_derrB({(NUMPOPT+NUMPUPT){1'b0}}),
          .t7_writeA(t7_writeA), .t7_addrA(t7_addrA), .t7_dinA(t7_dinA), .t7_readB(t7_readB), .t7_addrB(t7_addrB), .t7_doutB(t7_doutB_a1), .t7_serrB({NUMPOPT{1'b0}}), .t7_derrB({NUMPOPT{1'b0}}),
          .select_qprt (select_qprt), .select_addr (select_addr));

end
endgenerate

wire t1_writeA_wire [0:NUMPUPT-1];
wire [BITADDR-1:0] t1_addrA_wire [0:NUMPUPT-1];
wire [QPTR_WIDTH-1:0] t1_bwA_wire [0:NUMPUPT-1];
wire [QPTR_WIDTH-1:0] t1_dinA_wire [0:NUMPUPT-1];
wire t1_readB_wire [0:NUMPOPT-1];
wire [BITADDR-1:0] t1_addrB_wire [0:NUMPOPT-1];
wire [BITQPTR-1:0] t1_doutB_a1_wire [0:NUMPOPT-1];
wire t1_fwrdB_a1_wire [0:NUMPOPT-1];
wire t1_serrB_a1_wire [0:NUMPOPT-1];
wire t1_derrB_a1_wire [0:NUMPOPT-1];
wire [BITADDR-1:0] t1_padrB_a1_wire [0:NUMPOPT-1];

genvar t1r;
generate
  for (t1r=0; t1r<NUMPUPT; t1r=t1r+1) begin: t1r_loop
    wire t1_writeA_a1_wire = t1_writeA_a1 >> (t1r);
    wire [BITADDR-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> (t1r*BITADDR);
    wire [BITQPTR-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> (t1r*WIDTH);
    wire t1_readB_a1_wire = t1_readB_a1 >> (t1r);
    wire [BITADDR-1:0] t1_addrB_a1_wire = t1_addrB_a1 >> (t1r*BITADDR);

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
      infra_align_ecc_1r1w #(.WIDTH (BITQPTR), .ENAPSDO (NUMWRDS==1), .ENAECC (0), .ENAPADR (0),
                             .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                             .NUMSROW (NUMADDR), .BITSROW (BITADDR), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITADDR),
                             .SRAM_DELAY (LINK_DELAY), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC))
        infra (.write(t1_writeA_a1_wire), .wr_adr(t1_addrA_a1_wire), .din(t1_dinA_a1_wire),
               .read(t1_readB_a1_wire), .rd_adr(t1_addrB_a1_wire),
               .rd_dout(t1_doutB_a1_wire[t1r]), .rd_fwrd(t1_fwrdB_a1_wire[t1r]),
               .rd_serr(t1_serrB_a1_wire[t1r]), .rd_derr(t1_derrB_a1_wire[t1r]), .rd_padr(t1_padrB_a1_wire[t1r]),
               .mem_write (t1_mem_write_wire), .mem_wr_adr(t1_mem_wr_adr_wire), .mem_bw (t1_mem_bw_wire), .mem_din (t1_mem_din_wire),
               .mem_read (t1_mem_read_wire), .mem_rd_adr(t1_mem_rd_adr_wire), .mem_rd_dout (t1_mem_rd_dout_wire),
               .mem_rd_fwrd(t1_mem_rd_fwrd_wire), .mem_rd_padr(t1_mem_rd_padr_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_addr));
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
               .select_addr (select_addr));
    end
  end
endgenerate

reg [NUMPUPT-1:0] t1_writeA;
reg [NUMPUPT*BITADDR-1:0] t1_addrA;
reg [NUMPUPT*QPTR_WIDTH-1:0] t1_bwA;
reg [NUMPUPT*QPTR_WIDTH-1:0] t1_dinA;
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
  t1_doutB_a1 = 0;
  t1_fwrdB_a1 = 0;
  t1_serrB_a1 = 0;
  t1_derrB_a1 = 0;
  t1_padrB_a1 = 0;
  for (t1r_int=0; t1r_int<NUMPUPT; t1r_int=t1r_int+1) begin
    t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int] << (t1r_int));
    t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int] << (t1r_int*BITADDR));
    t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int] << (t1r_int*QPTR_WIDTH));
    t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int] << (t1r_int*QPTR_WIDTH));
    t1_readB = t1_readB | (t1_readB_wire[t1r_int] << (t1r_int));
    t1_addrB = t1_addrB | (t1_addrB_wire[t1r_int] << (t1r_int*BITADDR));
    t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[t1r_int] << (t1r_int*BITQPTR));
    t1_fwrdB_a1 = t1_fwrdB_a1 | (t1_fwrdB_a1_wire[t1r_int] << (t1r_int));
    t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_wire[t1r_int] << (t1r_int));
    t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[t1r_int] << (t1r_int));
    t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_wire[t1r_int] << (t1r_int*BITADDR));
  end
end


wire t2_writeA_wire [0:NUMPUPT-1];
wire [BITADDR-1:0] t2_addrA_wire [0:NUMPUPT-1];
wire [DATA_WIDTH-1:0] t2_bwA_wire [0:NUMPUPT-1];
wire [DATA_WIDTH-1:0] t2_dinA_wire [0:NUMPUPT-1];
wire t2_readB_wire [0:NUMPOPT-1];
wire [BITADDR-1:0] t2_addrB_wire [0:NUMPOPT-1];
wire [WIDTH-1:0] t2_doutB_a1_wire [0:NUMPOPT-1];
wire t2_fwrdB_a1_wire [0:NUMPOPT-1];
wire t2_serrB_a1_wire [0:NUMPOPT-1];
wire t2_derrB_a1_wire [0:NUMPOPT-1];
wire [BITADDR-1:0] t2_padrB_a1_wire [0:NUMPOPT-1];

genvar t2r;
generate
  for (t2r=0; t2r<NUMPUPT; t2r=t2r+1) begin: t2r_loop
    wire t2_writeA_a1_wire = t2_writeA_a1 >> (t2r);
    wire [BITADDR-1:0] t2_addrA_a1_wire = t2_addrA_a1 >> (t2r*BITADDR);
    wire [WIDTH-1:0] t2_dinA_a1_wire = t2_dinA_a1 >> (t2r*WIDTH);
    wire t2_readB_a1_wire = t2_readB_a1 >> (t2r);
    wire [BITADDR-1:0] t2_addrB_a1_wire = t2_addrB_a1 >> (t2r*BITADDR);

    wire [NUMPOPT*DATA_WIDTH-1:0] t2_doutB_wire = t2_doutB >> (t2r*DATA_WIDTH);

    wire t2_mem_write_wire;
    wire [BITADDR-1:0] t2_mem_wr_adr_wire;
    wire [DATA_WIDTH-1:0] t2_mem_bw_wire;
    wire [DATA_WIDTH-1:0] t2_mem_din_wire;
    wire t2_mem_read_wire;
    wire [BITADDR-1:0] t2_mem_rd_adr_wire;
    wire [DATA_WIDTH-1:0] t2_mem_rd_dout_wire;
    wire t2_mem_rd_fwrd_wire;
    wire t2_mem_rd_serr_wire;
    wire t2_mem_rd_derr_wire;
    wire [BITADDR-1:0] t2_mem_rd_padr_wire;

   if (1) begin: align_loop
      infra_align_ecc_1r1w #(.WIDTH (WIDTH), .ENAPSDO (NUMWRDS==1), .ENAECC (0), .ENAPADR (0),
                             .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                             .NUMSROW (NUMADDR), .BITSROW (BITADDR), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITADDR),
                             .SRAM_DELAY (DATA_DELAY), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (1))
        infra (.write(t2_writeA_a1_wire), .wr_adr(t2_addrA_a1_wire), .din(t2_dinA_a1_wire),
               .read(t2_readB_a1_wire), .rd_adr(t2_addrB_a1_wire),
               .rd_dout(t2_doutB_a1_wire[t2r]), .rd_fwrd(t2_fwrdB_a1_wire[t2r]),
               .rd_serr(t2_serrB_a1_wire[t2r]), .rd_derr(t2_derrB_a1_wire[t2r]), .rd_padr(t2_padrB_a1_wire[t2r]),
               .mem_write (t2_mem_write_wire), .mem_wr_adr(t2_mem_wr_adr_wire), .mem_bw (t2_mem_bw_wire), .mem_din (t2_mem_din_wire),
               .mem_read (t2_mem_read_wire), .mem_rd_adr(t2_mem_rd_adr_wire), .mem_rd_dout (t2_mem_rd_dout_wire),
               .mem_rd_fwrd(t2_mem_rd_fwrd_wire), .mem_rd_padr(t2_mem_rd_padr_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_addr));
    end

    if (1) begin: stack_loop
      infra_stack_1r1w #(.WIDTH (DATA_WIDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                         .NUMWROW (NUMADDR), .BITWROW (BITADDR), .NUMWBNK (1), .BITWBNK (0),
                         .SRAM_DELAY (DATA_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
        infra (.write (t2_mem_write_wire), .wr_adr (t2_mem_wr_adr_wire), .bw (t2_mem_bw_wire), .din (t2_mem_din_wire),
               .read (t2_mem_read_wire), .rd_adr (t2_mem_rd_adr_wire), .rd_dout (t2_mem_rd_dout_wire),
               .rd_fwrd (t2_mem_rd_fwrd_wire), .rd_serr (t2_mem_rd_serr_wire), .rd_derr(t2_mem_rd_derr_wire), .rd_padr(t2_mem_rd_padr_wire),
               .mem_write (t2_writeA_wire[t2r]), .mem_wr_adr(t2_addrA_wire[t2r]),
               .mem_bw (t2_bwA_wire[t2r]), .mem_din (t2_dinA_wire[t2r]),
               .mem_read (t2_readB_wire[t2r]), .mem_rd_adr(t2_addrB_wire[t2r]), .mem_rd_dout (t2_doutB_wire),
               .clk (clk), .rst(rst),
               .select_addr (select_addr));
    end
  end
endgenerate

reg [NUMPUPT-1:0] t2_writeA;
reg [NUMPUPT*BITADDR-1:0] t2_addrA;
reg [NUMPUPT*DATA_WIDTH-1:0] t2_bwA;
reg [NUMPUPT*DATA_WIDTH-1:0] t2_dinA;
reg [NUMPOPT-1:0] t2_readB;
reg [NUMPOPT*BITADDR-1:0] t2_addrB;
integer t2r_int;
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
  for (t2r_int=0; t2r_int<NUMPUPT; t2r_int=t2r_int+1) begin
    t2_writeA = t2_writeA | (t2_writeA_wire[t2r_int] << (t2r_int));
    t2_addrA = t2_addrA | (t2_addrA_wire[t2r_int] << (t2r_int*BITADDR));
    t2_bwA = t2_bwA | (t2_bwA_wire[t2r_int] << (t2r_int*DATA_WIDTH));
    t2_dinA = t2_dinA | (t2_dinA_wire[t2r_int] << (t2r_int*DATA_WIDTH));
    t2_readB = t2_readB | (t2_readB_wire[t2r_int] << (t2r_int));
    t2_addrB = t2_addrB | (t2_addrB_wire[t2r_int] << (t2r_int*BITADDR));
    t2_doutB_a1 = t2_doutB_a1 | (t2_doutB_a1_wire[t2r_int] << (t2r_int*WIDTH));
    t2_fwrdB_a1 = t2_fwrdB_a1 | (t2_fwrdB_a1_wire[t2r_int] << (t2r_int));
    t2_serrB_a1 = t2_serrB_a1 | (t2_serrB_a1_wire[t2r_int] << (t2r_int));
    t2_derrB_a1 = t2_derrB_a1 | (t2_derrB_a1_wire[t2r_int] << (t2r_int));
    t2_padrB_a1 = t2_padrB_a1 | (t2_padrB_a1_wire[t2r_int] << (t2r_int*BITADDR));
  end
end



generate if (FLOPMEM) begin: t3_flp_loop
  reg [NUMPOPT*BITPING-1:0] t3_doutB_reg;
  reg [NUMPUPT*BITPING-1:0] t4_doutB_reg;
  reg [(NUMPOPT+NUMPUPT)*BITQCNT-1:0] t5_doutB_reg;
  reg [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t6_doutB_reg;
  reg [NUMPUPT*NUMPING*BITQPTR-1:0] t7_doutB_reg;
  always @(posedge clk) begin
    t3_doutB_reg <= t3_doutB;
    t4_doutB_reg <= t4_doutB;
    t5_doutB_reg <= t5_doutB;
    t6_doutB_reg <= t6_doutB;
    t7_doutB_reg <= t7_doutB;
  end

  assign t3_doutB_a1 = t3_doutB_reg;
  assign t4_doutB_a1 = t4_doutB_reg;
  assign t5_doutB_a1 = t5_doutB_reg;
  assign t6_doutB_a1 = t6_doutB_reg;
  assign t7_doutB_a1 = t7_doutB_reg;
end else begin: t3_noflp_loop
  assign t3_doutB_a1 = t3_doutB;
  assign t4_doutB_a1 = t4_doutB;
  assign t5_doutB_a1 = t5_doutB;
  assign t6_doutB_a1 = t6_doutB;
  assign t7_doutB_a1 = t7_doutB;
end
endgenerate

generate
  if (1) begin: a2_loop
    algo_mrnw_fque_doppler #(.NUMPORT(1), .BITPORT(1), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .BITQPTR(BITQPTR),
                     .NUMVROW(NUMADDR), .BITVROW(BITADDR),
                     .QPTR_DELAY(LINK_DELAY+FLOPECC), .FLOPIN(FLOPIN), .FLOPOUT(FLOPOUT), .BITCPAD(BITADDR), .CPUWDTH(BITADDR+BITQCNT))
            algo_fl (
                     .push(qm2fl_push),
                     .pu_ptr(qm2fl_ptr),
                     .pop(push),
                     .po_pvld(fl2qm_push),
                     .po_ptr(fl2qm_ptr),
                     .cp_read(1'b0),
                     .cp_write(1'b0),
                     .cp_adr({BITADDR{1'b0}}),
                     .cp_din({(BITQPTR+BITQCNT){1'b0}}),
                     .cp_vld(),
                     .cp_dout(),
                     .t1_writeA(t8_writeA_a2),
                     .t1_addrA(t8_addrA_a2),
                     .t1_dinA(t8_dinA_a2),
                     .t1_readB(t8_readB_a2),
                     .t1_addrB(t8_addrB_a2),
                     .t1_doutB(t8_doutB_a2),
                     .freecnt(freecnt),
                     .clk(clk),
                     .rst(rst),
                     .ready(fl_ready));

  end
endgenerate

wire t8_writeA_wire [0:NUMPUPT-1];
wire [BITADDR-1:0] t8_addrA_wire [0:NUMPUPT-1];
wire [QPTR_WIDTH-1:0] t8_bwA_wire [0:NUMPUPT-1];
wire [QPTR_WIDTH-1:0] t8_dinA_wire [0:NUMPUPT-1];
wire t8_readB_wire [0:NUMPUPT-1];
wire [BITADDR-1:0] t8_addrB_wire [0:NUMPUPT-1];
wire [BITQPTR-1:0] t8_doutB_a2_wire [0:NUMPUPT-1];
wire t8_fwrdB_a2_wire [0:NUMPUPT-1];
wire t8_serrB_a2_wire [0:NUMPUPT-1];
wire t8_derrB_a2_wire [0:NUMPUPT-1];
wire [BITADDR-1:0] t8_padrB_a2_wire [0:NUMPUPT-1];

genvar t8r;
generate
  for (t8r=0; t8r<NUMPUPT; t8r=t8r+1) begin: t8r_loop
    wire t8_writeA_a2_wire = t8_writeA_a2 >> (t8r);
    wire [BITADDR-1:0] t8_addrA_a2_wire = t8_addrA_a2 >> (t8r*(BITQPTR));
    wire [BITQPTR-1:0] t8_dinA_a2_wire = t8_dinA_a2 >> (t8r*BITQPTR);
    wire t8_readB_a2_wire = t8_readB_a2 >> (t8r);
    wire [BITADDR-1:0] t8_addrB_a2_wire = t8_addrB_a2 >> (t8r*(BITQPTR));

    wire [QPTR_WIDTH-1:0] t8_doutB_wire = t8_doutB >> (t8r*QPTR_WIDTH);

    wire t8_mem_write_wire;
    wire [BITADDR-1:0] t8_mem_wr_adr_wire;
    wire [QPTR_WIDTH-1:0] t8_mem_bw_wire;
    wire [QPTR_WIDTH-1:0] t8_mem_din_wire;
    wire t8_mem_read_wire;
    wire [BITADDR-1:0] t8_mem_rd_adr_wire;
    wire [QPTR_WIDTH-1:0] t8_mem_rd_dout_wire;
    wire t8_mem_rd_fwrd_wire;
    wire t8_mem_rd_serr_wire;
    wire t8_mem_rd_derr_wire;
    wire [BITADDR-1:0] t8_mem_rd_padr_wire;

   if (1) begin: align_loop
      infra_align_ecc_1r1w #(.WIDTH (BITQPTR), .ENAPSDO (NUMWRDS==1), .ENAECC (0), .ENAPADR (0),
                             .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                             .NUMSROW (NUMADDR), .BITSROW (BITADDR), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITADDR),
                             .SRAM_DELAY (LINK_DELAY), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (1))
        infra (.write(t8_writeA_a2_wire), .wr_adr(t8_addrA_a2_wire), .din(t8_dinA_a2_wire),
               .read(t8_readB_a2_wire), .rd_adr(t8_addrB_a2_wire),
               .rd_dout(t8_doutB_a2_wire[t8r]), .rd_fwrd(t8_fwrdB_a2_wire[t8r]),
               .rd_serr(t8_serrB_a2_wire[t8r]), .rd_derr(t8_derrB_a2_wire[t8r]), .rd_padr(t8_padrB_a2_wire[t8r]),
               .mem_write (t8_mem_write_wire), .mem_wr_adr(t8_mem_wr_adr_wire), .mem_bw (t8_mem_bw_wire), .mem_din (t8_mem_din_wire),
               .mem_read (t8_mem_read_wire), .mem_rd_adr(t8_mem_rd_adr_wire), .mem_rd_dout (t8_mem_rd_dout_wire),
               .mem_rd_fwrd(t8_mem_rd_fwrd_wire), .mem_rd_padr(t8_mem_rd_padr_wire),
               .clk (clk), .rst (rst),
               .select_addr ({(BITADDR){1'b0}}));
    end

    if (1) begin: stack_loop
      infra_stack_1r1w #(.WIDTH (QPTR_WIDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                         .NUMWROW (NUMADDR), .BITWROW (BITADDR), .NUMWBNK (1), .BITWBNK (0),
                         .SRAM_DELAY (LINK_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
        infra (.write (t8_mem_write_wire), .wr_adr (t8_mem_wr_adr_wire), .bw (t8_mem_bw_wire), .din (t8_mem_din_wire),
               .read (t8_mem_read_wire), .rd_adr (t8_mem_rd_adr_wire), .rd_dout (t8_mem_rd_dout_wire),
               .rd_fwrd (t8_mem_rd_fwrd_wire), .rd_serr (t8_mem_rd_serr_wire), .rd_derr(t8_mem_rd_derr_wire), .rd_padr(t8_mem_rd_padr_wire),
               .mem_write (t8_writeA_wire[t8r]), .mem_wr_adr(t8_addrA_wire[t8r]),
               .mem_bw (t8_bwA_wire[t8r]), .mem_din (t8_dinA_wire[t8r]),
               .mem_read (t8_readB_wire[t8r]), .mem_rd_adr(t8_addrB_wire[t8r]), .mem_rd_dout (t8_doutB_wire),
               .clk (clk), .rst(rst),
               .select_addr ({(BITADDR){1'b0}}));
    end
  end
endgenerate

reg [NUMPUPT-1:0] t8_writeA;
reg [NUMPUPT*(BITADDR)-1:0] t8_addrA;
reg [NUMPUPT*QPTR_WIDTH-1:0] t8_bwA;
reg [NUMPUPT*QPTR_WIDTH-1:0] t8_dinA;
reg [NUMPUPT-1:0] t8_readB;
reg [NUMPUPT*(BITADDR)-1:0] t8_addrB;
integer t8r_int;
always_comb begin
  t8_writeA = 0;
  t8_addrA = 0;
  t8_bwA = 0;
  t8_dinA = 0;
  t8_readB = 0;
  t8_addrB = 0;
  t8_doutB_a2 = 0;
  t8_serrB_a2 = 0;
  t8_derrB_a2 = 0;
  t8_padrB_a2 = 0;
  for (t8r_int=0; t8r_int<NUMPUPT; t8r_int=t8r_int+1) begin
    t8_writeA = t8_writeA | (t8_writeA_wire[t8r_int] << (t8r_int));
    t8_addrA = t8_addrA | (t8_addrA_wire[t8r_int] << (t8r_int*(BITADDR)));
    t8_bwA = t8_bwA | (t8_bwA_wire[t8r_int] << (t8r_int*BITQPTR));
    t8_dinA = t8_dinA | (t8_dinA_wire[t8r_int] << (t8r_int*QPTR_WIDTH));
    t8_readB = t8_readB | (t8_readB_wire[t8r_int] << (t8r_int));
    t8_addrB = t8_addrB | (t8_addrB_wire[t8r_int] << (t8r_int*(BITADDR)));
    t8_doutB_a2 = t8_doutB_a2 | (t8_doutB_a2_wire[t8r_int] << (t8r_int*BITQPTR));
    t8_serrB_a2 = t8_serrB_a2 | (t8_serrB_a2_wire[t8r_int] << (t8r_int));
    t8_derrB_a2 = t8_derrB_a2 | (t8_derrB_a2_wire[t8r_int] << (t8r_int));
    t8_padrB_a2 = t8_padrB_a2 | (t8_padrB_a2_wire[t8r_int] << (t8r_int*BITADDR));
  end
end

assign t1_serrB = t1_serrB_a1;
assign t1_derrB = t1_derrB_a1;
assign t1_padrB = t1_padrB_a1;

assign t2_serrB = t2_serrB_a1;
assign t2_derrB = t2_derrB_a1;
assign t2_padrB = t2_padrB_a1;

assign t8_serrB = t8_serrB_a2;
assign t8_derrB = t8_derrB_a2;
assign t8_padrB = t8_padrB_a2;


`ifdef FORMAL
localparam FIFOCNT = NUMADDR;
localparam BITFIFO = BITADDR;
localparam QPOP_DELAY = QPTR_DELAY+DATA_DELAY;
wire pop_wire [0:NUMPOPT-1];
wire [BITQPRT-1:0] po_prt_wire [0:NUMPOPT-1];
wire [BITQPTR-1:0] po_ptr_wire [0:NUMPOPT-1];
wire push_wire [0:NUMPUPT-1];
wire [BITQPRT-1:0] pu_prt_wire [0:NUMPUPT-1];
wire [BITQPTR-1:0] pu_ptr_wire [0:NUMPUPT-1];
wire [WIDTH-1:0] pu_din_wire [0:NUMPUPT-1];
wire [BITQCNT-1:0] pu_cnt_wire [0:NUMPUPT-1];
wire [BITQPTR-1:0] pu_tail_wire [0:NUMPUPT-1];
reg [3:0] popcnt;
reg [3:0] pushcnt;
wire [BITQPTR-1:0] pop_qhead;
reg [BITQPTR-1:0] push_qtail;
reg [BITQCNT-1:0] push_qcnt;
wire [BITQPTR-1:0] free_head_tmp [0:NUMPUPT-1];

reg pop_reg [0:NUMPOPT-1][0:QPTR_DELAY-1];
reg [BITQPRT-1:0] po_prt_reg [0:NUMPOPT-1][0:QPTR_DELAY-1];
reg push_reg [0:NUMPUPT-1][0:QPTR_DELAY-1];
reg [BITQPRT-1:0] pu_prt_reg [0:NUMPUPT-1][0:QPTR_DELAY-1];
reg [BITQPTR-1:0] pu_ptr_reg [0:NUMPUPT-1][0:QPTR_DELAY-1];

genvar pr_var;
generate
  for(pr_var=0;pr_var < NUMPUPT; pr_var = pr_var+1) begin
    assign push_wire[pr_var] = push >> pr_var;
    assign pu_prt_wire[pr_var] = pu_prt >> (pr_var*BITQPRT);
    assign pu_ptr_wire[pr_var] = fl2qm_ptr >> (pr_var*BITQPTR);
    assign pu_din_wire[pr_var] = pu_din >> (pr_var*WIDTH);
    assign pu_cnt_wire[pr_var] = push_cnt >> (pr_var*BITQCNT);
    assign pu_tail_wire[pr_var] = push_tail >> (pr_var*BITQPTR);
    assign free_head_tmp[pr_var] = pu_ptr_reg[pr_var][QPTR_DELAY-1]; 
  end
  for(pr_var=0;pr_var < NUMPOPT; pr_var = pr_var+1) begin
    assign pop_wire[pr_var] = (pop && {NUMPOPT{ready}}) >> pr_var;
    assign po_prt_wire[pr_var] = po_prt >> pr_var;
  end
endgenerate

integer pot_int,pod_int;
always @ (posedge clk) begin
  for(pod_int=0; pod_int<QPTR_DELAY; pod_int = pod_int+1) begin
    for(pot_int=0; pot_int<NUMPUPT; pot_int = pot_int+1) begin
      if(pod_int>0) begin
        push_reg[pot_int][pod_int] <= push_reg[pot_int][pod_int-1];
        pu_prt_reg[pot_int][pod_int] <= pu_prt_reg[pot_int][pod_int-1];
        pu_ptr_reg[pot_int][pod_int] <= pu_ptr_reg[pot_int][pod_int-1];
      end else begin
        push_reg[pot_int][pod_int] <= push_wire[pot_int];
        pu_prt_reg[pot_int][pod_int] <= pu_prt_wire[pot_int];
        pu_ptr_reg[pot_int][pod_int] <= pu_ptr_wire[pot_int];
      end
    end
    for(pot_int=0; pot_int<NUMPOPT; pot_int = pot_int+1) begin
      if(pod_int>0) begin
        pop_reg[pot_int][pod_int] <= pop_reg[pot_int][pod_int-1];
        po_prt_reg[pot_int][pod_int] <= po_prt_reg[pot_int][pod_int-1];
      end else begin
        pop_reg[pot_int][pod_int] <= pop_wire[pot_int];
        po_prt_reg[pot_int][pod_int] <= po_prt_wire[pot_int];
      end
    end
  end
end

integer put_int;
always_comb begin
  for(put_int=0; put_int<NUMPUPT; put_int=put_int+1)  begin
    push_qtail = 0;
    push_qcnt = 0;
  end
  for(put_int=0; put_int<NUMPUPT; put_int=put_int+1) 
    if(push_reg[put_int][QPTR_DELAY-1] && (pu_prt_reg[put_int][QPTR_DELAY-1] == select_qprt)) begin
      push_qtail = pu_tail_wire[put_int];
      push_qcnt = pu_cnt_wire[put_int];
    end
end
assign pop_qhead  = a1_loop.algo.core.vpo_ptr_wire[0];

always_comb begin
  popcnt = 0;
  for (integer pcnt_int=0; pcnt_int<NUMPOPT; pcnt_int=pcnt_int+1)
    if (pop_wire[pcnt_int] && ready)
      popcnt = popcnt + 1;
  pushcnt = 0;
  for (integer pcnt_int=0; pcnt_int<NUMPUPT; pcnt_int=pcnt_int+1)
    if (push_wire[pcnt_int])
      pushcnt = pushcnt + 1;
end

reg [BITFIFO:0] totlcnt;
always @(posedge clk)
  if (rst || !ready)
    totlcnt <= 0;
  else
    totlcnt <= totlcnt + pushcnt - popcnt;

reg [BITFIFO:0] rfffcnt;
always @(posedge clk)
  if (rst || !ready)
    rfffcnt <= 0;
  else
    rfffcnt <= rfffcnt + (push_wire[0] && (pu_prt_wire[0]==select_qprt)) - (pop_wire[0] && (po_prt_wire[0]==select_qprt));

wire rfff_deq = pop_wire[0] && (po_prt_wire[0]==select_qprt) && ready;

reg [WIDTH-1:0]   datrfff [0:FIFOCNT-1];
reg [WIDTH-1:0]   datrfff_nxt [0:FIFOCNT-1];
integer rfff_int,rffp_int;
always_comb begin
  for (rfff_int=0; rfff_int<FIFOCNT; rfff_int=rfff_int+1) begin
    datrfff_nxt[rfff_int] = datrfff[rfff_int];
    if (rfff_int<(rfffcnt-rfff_deq)) begin
      datrfff_nxt[rfff_int] = datrfff[rfff_int+rfff_deq];
    end
    for(rffp_int=0; rffp_int<NUMPUPT; rffp_int=rffp_int+1)
      if ((rfff_int==(rfffcnt-rfff_deq)) && push_wire[rffp_int] && (pu_prt_wire[rffp_int]==select_qprt) && ready) begin
        datrfff_nxt[rfff_int] = pu_din_wire[rffp_int];
      end
    end
  end

integer rffd_int;
always @(posedge clk)
  for (rffd_int=0; rffd_int<FIFOCNT; rffd_int=rffd_int+1) begin
    datrfff[rffd_int] <= datrfff_nxt[rffd_int];
  end

reg [FIFOCNT-1:0] rfffbmp;
reg [FIFOCNT-1:0] freebmp;
integer puf_int;
always @(posedge clk)
  if (rst || !ready) begin
    rfffbmp <= 0;
    freebmp <= {FIFOCNT{1'b1}};
  end else begin
    for(puf_int=0; puf_int < NUMPUPT; puf_int = puf_int+1) begin
      if (!(push_reg[puf_int][QPTR_DELAY-1] && (pu_prt_reg[puf_int][QPTR_DELAY-1]==select_qprt) && pop_reg[0][QPTR_DELAY-1] && (po_prt_reg[0][QPTR_DELAY-1]==select_qprt))) begin
        if (push_reg[puf_int][QPTR_DELAY-1] && (pu_prt_reg[puf_int][QPTR_DELAY-1]==select_qprt))
          rfffbmp[free_head_tmp[puf_int]] <= 1'b1;
        if (pop_reg[0][QPTR_DELAY-1] && (po_prt_reg[0][QPTR_DELAY-1]==select_qprt) && ready)
          rfffbmp[pop_qhead] <= 1'b0;
      end
      if (push_reg[puf_int][QPTR_DELAY-1] && !pop_reg[0][QPTR_DELAY-1])
        freebmp[free_head_tmp[puf_int]] <= 1'b0;
      if (pop_reg[0][QPTR_DELAY-1]&& !push_reg[puf_int][QPTR_DELAY-1] && ready)
        freebmp[pop_qhead] <= 1'b1;
    end
 end

genvar por_var;
generate for (por_var=0; por_var<NUMPOPT;por_var=por_var+1) begin: por_loop
  assume_select_oprt_range2: assume property (@(posedge clk) disable iff (rst  || !ready) ((po_prt_wire[por_var]<NUMQPRT)));
end
endgenerate

genvar pur_var,pcntb_var;
generate for(pur_var=0; pur_var<NUMPUPT; pur_var=pur_var+1) begin : pur_loop
  assume_select_uprt_range2: assume property (@(posedge clk) disable iff (rst  || !ready) ((pu_prt_wire[pur_var] < NUMQPRT)));
    for (pcntb_var=0;pcntb_var<pur_var;pcntb_var=pcntb_var+1) begin: puni_loop
      assert_pu_uniq_check: assert property (@(posedge clk) disable iff (rst || !ready) (push_wire[pur_var] && push_wire[pcntb_var]) |-> (pu_prt_wire[pur_var] != pu_prt_wire[pcntb_var]));
    end
end
endgenerate

assert_rff_pop_check: assert property (@(posedge clk) disable iff (rst  || !ready) (pop && (po_prt==select_qprt)) |-> |rfffcnt);
assert_rfffcnt_check: assert property (@(posedge clk) disable iff (rst || !ready) (rfffcnt<=FIFOCNT));
assert_tot_pop_check: assert property (@(posedge clk) disable iff (rst || !ready) (pop && (po_prt!=select_qprt)) |-> ((totlcnt-rfffcnt)>0));
assert_totlcnt_check: assert property (@(posedge clk) disable iff (rst || !ready) (totlcnt<=FIFOCNT));
assert_freecnt_check: assert property (@(posedge clk) disable iff (rst || !ready) (freecnt<=FIFOCNT));

genvar po_var;
generate for(po_var=0;po_var<NUMPOPT; po_var=po_var+1) begin: po_loop
  if (QPTR_DELAY>0) begin: oth_loop
    assert_oth_pop_check: assert property (@(posedge clk) disable iff (rst || !ready) (pop_wire[po_var] && (po_prt_wire[po_var]!=select_qprt)) |-> ##QPTR_DELAY
                                            ((pop_qhead<FIFOCNT) && !rfffbmp[pop_qhead] && !freebmp[pop_qhead]));
  end else begin: noth_loop
    assert_oth_pop_check: assert property (@(posedge clk) disable iff (rst || !ready) (pop_wire[0] && (po_prt_wire[po_var]!=select_qprt)) |->
                                          ((pop_qhead<FIFOCNT) && !rfffbmp[pop_qhead] && !freebmp[pop_qhead]));
  end
end
endgenerate

genvar pu_var;
generate for(pu_var=0; pu_var<NUMPUPT; pu_var=pu_var+1) begin: pu_loop
  if (QPTR_DELAY>0) begin: oth_loop
    assert_oth_push_check: assert property (@(posedge clk) disable iff (rst || !ready) (push_wire[pu_var] && (pu_prt_wire[pu_var]!=select_qprt)) |-> ##QPTR_DELAY
                                          ((push_qcnt<NUMPING) || (!rfffbmp[push_qtail] && !freebmp[push_qtail])));
  end else begin: noth_loop
    assert_oth_push_check: assert property (@(posedge clk) disable iff (rst || !ready) (push_wire[pu_var] && (pu_prt_wire[pu_var]!=select_qprt)) |->
                                          ((push_qcnt<NUMPING) || (!rfffbmp[push_qtail] && !freebmp[push_qtail])));
  end
end
endgenerate

generate if (QPOP_DELAY>0) begin: dat_loop
  assert_rff_dat_check: assert property (@(posedge clk) disable iff (rst || !ready) (pop && (po_prt==select_qprt)) |-> ##QPOP_DELAY po_dvld && (po_dout==$past(datrfff[0],QPOP_DELAY)));
end else begin: ndel_loop
  assert_rff_dat_check: assert property (@(posedge clk) disable iff (rst || !ready) (pop && (po_prt==select_qprt)) |-> po_dvld && (po_dout==datrfff[0]));
end
endgenerate
`endif

endmodule
