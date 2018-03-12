module algo_1k2l_a404_top (clk, rst, ready,
                               push, pu_prt, pu_metadata, pu_din,
                               pop, po_prt, po_metadata, po_dvld, po_dout,
                               freecnt,
                               cp_read, cp_write, cp_adr, cp_din, cp_vld, cp_dout,
                               t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
                               t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
                               t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
                               t4_writeA, t4_addrA, t4_dinA, t4_readB, t4_addrB, t4_doutB,
                               t5_writeA, t5_addrA, t5_dinA, t5_readB, t5_addrB, t5_doutB,
                               t6_writeA, t6_addrA, t6_dinA, t6_readB, t6_addrB, t6_doutB,
                               t7_writeA, t7_addrA, t7_dinA, t7_readB, t7_addrB, t7_doutB,
                               t8_writeA, t8_addrA, t8_dinA, t8_readB, t8_addrB, t8_doutB,
                               t9_writeA, t9_addrA, t9_dinA, t9_readB, t9_addrB, t9_doutB,
                               t10_writeA, t10_addrA, t10_dinA, t10_readB, t10_addrB, t10_doutB,
                               t11_writeA, t11_addrA, t11_dinA, t11_readB, t11_addrB, t11_doutB,
                               t12_writeA, t12_addrA, t12_dinA, t12_readB, t12_addrB, t12_doutB);

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
  parameter QPTR_DELAY = 1;
  parameter LINK_DELAY = 2;
  parameter DATA_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;
  parameter FLOPOUT = 0;

  parameter T1_T1_WIDTH = 20;
  parameter T1_T1_NUMVBNK = 8;
  parameter T1_T1_BITVBNK = 3;
  parameter T1_T1_DELAY = 2;
  parameter T1_T1_NUMVROW = 1040;
  parameter T1_T1_BITVROW = 11;
  parameter T1_T1_BITWSPF = 0;
  parameter T1_T1_NUMWRDS = 1;
  parameter T1_T1_BITWRDS = 0;
  parameter T1_T1_NUMSROW = 1040;
  parameter T1_T1_BITSROW = 11;
  parameter T1_T1_PHYWDTH = 20;
  parameter T1_T2_WIDTH = 20;
  parameter T1_T2_NUMVBNK = 2;
  parameter T1_T2_BITVBNK = 1;
  parameter T1_T2_DELAY = 2;
  parameter T1_T2_NUMVROW = 1040;
  parameter T1_T2_BITVROW = 11;
  parameter T1_T2_BITWSPF = 0;
  parameter T1_T2_NUMWRDS = 1;
  parameter T1_T2_BITWRDS = 0;
  parameter T1_T2_NUMSROW = 1040;
  parameter T1_T2_BITSROW = 11;
  parameter T1_T2_PHYWDTH = 20;
  parameter T1_T3_WIDTH = 12;
  parameter T1_T3_NUMVBNK = 3;
  parameter T1_T3_BITVBNK = 2;
  parameter T1_T3_DELAY = 2;
  parameter T1_T3_NUMVROW = 1040;
  parameter T1_T3_BITVROW = 11;
  parameter T1_T3_BITWSPF = 0;
  parameter T1_T3_NUMWRDS = 1;
  parameter T1_T3_BITWRDS = 0;
  parameter T1_T3_NUMSROW = 1040;
  parameter T1_T3_BITSROW = 11;
  parameter T1_T3_PHYWDTH = 12;
  parameter T2_T1_WIDTH = 571;
  parameter T2_T1_NUMVBNK = 8;
  parameter T2_T1_BITVBNK = 3;
  parameter T2_T1_DELAY = 2;
  parameter T2_T1_NUMVROW = 1040;
  parameter T2_T1_BITVROW = 11;
  parameter T2_T1_BITWSPF = 0;
  parameter T2_T1_NUMWRDS = 1;
  parameter T2_T1_BITWRDS = 0;
  parameter T2_T1_NUMSROW = 1040;
  parameter T2_T1_BITSROW = 11;
  parameter T2_T1_PHYWDTH = 571;
  parameter T2_T2_WIDTH = 571;
  parameter T2_T2_NUMVBNK = 2;
  parameter T2_T2_BITVBNK = 1;
  parameter T2_T2_DELAY = 2;
  parameter T2_T2_NUMVROW = 1040;
  parameter T2_T2_BITVROW = 11;
  parameter T2_T2_BITWSPF = 0;
  parameter T2_T2_NUMWRDS = 1;
  parameter T2_T2_BITWRDS = 0;
  parameter T2_T2_NUMSROW = 1040;
  parameter T2_T2_BITSROW = 11;
  parameter T2_T2_PHYWDTH = 571;
  parameter T2_T3_WIDTH = 12;
  parameter T2_T3_NUMVBNK = 3;
  parameter T2_T3_BITVBNK = 2;
  parameter T2_T3_DELAY = 2;
  parameter T2_T3_NUMVROW = 1040;
  parameter T2_T3_BITVROW = 11;
  parameter T2_T3_BITWSPF = 0;
  parameter T2_T3_NUMWRDS = 1;
  parameter T2_T3_BITWRDS = 0;
  parameter T2_T3_NUMSROW = 1040;
  parameter T2_T3_BITSROW = 11;
  parameter T2_T3_PHYWDTH = 12;
  parameter T8_WIDTH = 56;
  parameter T8_NUMVBNK = 1;
  parameter T8_BITVBNK = 0;
  parameter T8_DELAY = 2;
  parameter T8_NUMVROW = 2;
  parameter T8_BITVROW = 1;
  parameter T8_BITWSPF = 0;
  parameter T8_NUMWRDS = 1;
  parameter T8_BITWRDS = 0;
  parameter T8_NUMSROW = 2;
  parameter T8_BITSROW = 1;
  parameter T8_PHYWDTH = 56;

  parameter BITMDAT = 5;
  parameter NUMMDAT = 3;
  
  parameter NUMQPTR = NUMADDR;
  parameter BITQPTR = BITADDR;
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter BITCPAD = BITQPRT;
  parameter CPUWDTH = 2*BITPING+BITQCNT+2*NUMPING*(BITQPTR+BITMDAT);

  parameter QPTR_WIDTH = BITQPTR;
  parameter DATA_WIDTH = WIDTH;

  parameter INITCNT = NUMPUPT*(LINK_DELAY+FLOPECC+2);

  input [NUMPUPT-1:0]              push;
  input [NUMPUPT*BITQPRT-1:0]      pu_prt;
  input [NUMPUPT*BITMDAT-1:0]      pu_metadata;
  input [NUMPUPT*WIDTH-1:0]        pu_din;

  input [NUMPOPT-1:0]              pop;
  input [NUMPOPT*BITQPRT-1:0]      po_prt;
  output [NUMPOPT*NUMMDAT*BITMDAT-1:0]     po_metadata;
  output [NUMPOPT-1:0]             po_dvld;
  output [NUMPOPT*WIDTH-1:0]       po_dout;

  input                            cp_read;
  input                            cp_write;
  input [BITCPAD-1:0]              cp_adr;
  input [CPUWDTH-1:0]              cp_din;
  output                           cp_vld;
  output [CPUWDTH-1:0]             cp_dout;

  output [BITQCNT-1:0]             freecnt;
  output                           ready;
  input                            clk, rst;

  output [T1_T1_NUMVBNK-1:0]                 t1_writeA;
  output [T1_T1_NUMVBNK*T1_T1_BITVROW-1:0]   t1_addrA;
  output [T1_T1_NUMVBNK*T1_T1_PHYWDTH-1:0]   t1_dinA;
  output [T1_T1_NUMVBNK-1:0]                 t1_readB;
  output [T1_T1_NUMVBNK*T1_T1_BITVROW-1:0]   t1_addrB;
  input  [T1_T1_NUMVBNK*T1_T1_PHYWDTH-1:0]   t1_doutB;

  output [T1_T2_NUMVBNK-1:0]                 t2_writeA;
  output [T1_T2_NUMVBNK*T1_T2_BITVROW-1:0]   t2_addrA;
  output [T1_T2_NUMVBNK*T1_T2_PHYWDTH-1:0]   t2_dinA;
  output [T1_T2_NUMVBNK-1:0]                 t2_readB;
  output [T1_T2_NUMVBNK*T1_T2_BITVROW-1:0]   t2_addrB;
  input  [T1_T2_NUMVBNK*T1_T2_PHYWDTH-1:0]   t2_doutB;

  output [T1_T3_NUMVBNK-1:0]                 t3_writeA;
  output [T1_T3_NUMVBNK*T1_T3_BITVROW-1:0]   t3_addrA;
  output [T1_T3_NUMVBNK*T1_T3_PHYWDTH-1:0]   t3_dinA;
  output [T1_T3_NUMVBNK-1:0]                 t3_readB;
  output [T1_T3_NUMVBNK*T1_T3_BITVROW-1:0]   t3_addrB;
  input  [T1_T3_NUMVBNK*T1_T3_PHYWDTH-1:0]   t3_doutB;

  output [T2_T1_NUMVBNK-1:0]                 t4_writeA;
  output [T2_T1_NUMVBNK*T2_T1_BITVROW-1:0]   t4_addrA;
  output [T2_T1_NUMVBNK*T2_T1_PHYWDTH-1:0]   t4_dinA;
  output [T2_T1_NUMVBNK-1:0]                 t4_readB;
  output [T2_T1_NUMVBNK*T2_T1_BITVROW-1:0]   t4_addrB;
  input  [T2_T1_NUMVBNK*T2_T1_PHYWDTH-1:0]   t4_doutB;

  output [T2_T2_NUMVBNK-1:0]                 t5_writeA;
  output [T2_T2_NUMVBNK*T2_T2_BITVROW-1:0]   t5_addrA;
  output [T2_T2_NUMVBNK*T2_T2_PHYWDTH-1:0]   t5_dinA;
  output [T2_T2_NUMVBNK-1:0]                 t5_readB;
  output [T2_T2_NUMVBNK*T2_T2_BITVROW-1:0]   t5_addrB;
  input  [T2_T2_NUMVBNK*T2_T2_PHYWDTH-1:0]   t5_doutB;

  output [T2_T3_NUMVBNK-1:0]                 t6_writeA;
  output [T2_T3_NUMVBNK*T2_T3_BITVROW-1:0]   t6_addrA;
  output [T2_T3_NUMVBNK*T2_T3_PHYWDTH-1:0]   t6_dinA;
  output [T2_T3_NUMVBNK-1:0]                 t6_readB;
  output [T2_T3_NUMVBNK*T2_T3_BITVROW-1:0]   t6_addrB;
  input  [T2_T3_NUMVBNK*T2_T3_PHYWDTH-1:0]   t6_doutB;

  output [NUMPOPT-1:0]                     t7_writeA;
  output [NUMPOPT*BITQPRT-1:0]             t7_addrA;
  output [NUMPOPT*BITPING-1:0]             t7_dinA;
  output [NUMPOPT-1:0]                     t7_readB;
  output [NUMPOPT*BITQPRT-1:0]             t7_addrB;
  input [NUMPOPT*BITPING-1:0]              t7_doutB;

  output [NUMPUPT-1:0]                     t8_writeA;
  output [NUMPUPT*BITQPRT-1:0]             t8_addrA;
  output [NUMPUPT*BITPING-1:0]             t8_dinA;
  output [NUMPUPT-1:0]                     t8_readB;
  output [NUMPUPT*BITQPRT-1:0]             t8_addrB;
  input [NUMPUPT*BITPING-1:0]              t8_doutB;

  output [(NUMPOPT+NUMPUPT)-1:0]           t9_writeA;
  output [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t9_addrA;
  output [(NUMPOPT+NUMPUPT)*BITQCNT-1:0]   t9_dinA;
  output [(NUMPOPT+NUMPUPT)-1:0]           t9_readB;
  output [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t9_addrB;
  input [(NUMPOPT+NUMPUPT)*BITQCNT-1:0]    t9_doutB;

  output [(NUMPOPT+NUMPUPT)-1:0]           t10_writeA;
  output [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t10_addrA;
  output [(NUMPOPT+NUMPUPT)*NUMPING*(BITQPTR+BITMDAT)-1:0] t10_dinA;
  output [(NUMPOPT+NUMPUPT)-1:0]           t10_readB;
  output [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t10_addrB;
  input [(NUMPOPT+NUMPUPT)*NUMPING*(BITQPTR+BITMDAT)-1:0] t10_doutB;

  output [NUMPUPT-1:0]                     t11_writeA;
  output [NUMPUPT*BITQPRT-1:0]             t11_addrA;
  output [NUMPUPT*NUMPING*BITQPTR-1:0]     t11_dinA;
  output [NUMPUPT-1:0]                     t11_readB;
  output [NUMPUPT*BITQPRT-1:0]             t11_addrB;
  input [NUMPUPT*NUMPING*BITQPTR-1:0]      t11_doutB;

  output [NUMPUPT-1:0]                     t12_writeA;
  output [NUMPUPT*(BITQPTR-1)-1:0]         t12_addrA;
  output [NUMPUPT*T8_WIDTH-1:0]             t12_dinA;
  output [NUMPUPT-1:0]                     t12_readB;
  output [NUMPUPT*(BITQPTR-1)-1:0]         t12_addrB;
  input [NUMPUPT*T8_WIDTH-1:0]              t12_doutB;

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
`else
wire [BITQPRT-1:0] select_qprt = 0;
wire [BITADDR-1:0] select_addr = 0;
wire [BITVROW-1:0] select_vrow = 0;
wire [BITSROW-1:0] select_srow = 0;
wire [BITDROW-1:0] select_drow = 0;
`endif

wire [NUMPOPT*BITPING-1:0]                   t7_doutB_a1;
wire [NUMPUPT*BITPING-1:0]                   t8_doutB_a1;
wire [(NUMPOPT+NUMPUPT)*BITQCNT-1:0]         t9_doutB_a1;
wire [(NUMPOPT+NUMPUPT)*NUMPING*(BITQPTR+BITMDAT)-1:0] t10_doutB_a1;
wire [NUMPUPT*NUMPING*BITQPTR-1:0]           t11_doutB_a1;


wire [NUMPUPT-1:0]                     t1_writeA_a1;
wire [NUMPUPT*BITADDR-1:0]             t1_addrA_a1;
wire [NUMPUPT*(BITQPTR+BITMDAT)-1:0]   t1_dinA_a1;
wire [NUMPOPT-1:0]                     t1_readB_a1;
wire [NUMPOPT*BITADDR-1:0]             t1_addrB_a1;

reg  [NUMPOPT*(BITQPTR+BITMDAT)-1:0]   t1_doutB_a1;
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

reg [BITQCNT-1:0]          freecnt;
wire [NUMPOPT-1:0]         qm2fl_push;
wire [NUMPOPT*BITQPTR-1:0] qm2fl_ptr;

reg [NUMPUPT-1:0]          fl2qm_push;
wire [NUMPUPT*BITQPRT-1:0] fl2qm_prt;
wire [NUMPUPT*BITMDAT-1:0] fl2qm_metadata;
wire [NUMPUPT*WIDTH-1:0]   fl2qm_din;
reg [NUMPUPT*BITQPTR-1:0]  fl2qm_ptr;

wire [NUMPUPT*BITQCNT-1:0]  push_cnt;
wire [NUMPUPT*BITQPTR-1:0]  push_tail;
localparam FLDELAY = 0;

reg [NUMPUPT*WIDTH-1:0]         pu_din_dly [0:FLDELAY];
reg [NUMPUPT*BITQPRT - 1:0]     pu_prt_dly [0:FLDELAY];
reg [NUMPUPT*BITMDAT - 1:0]     pu_metadata_dly [0:FLDELAY];

genvar fld_int;
generate
  for(fld_int=0; fld_int<=FLDELAY; fld_int=fld_int+1) begin: fld_loop
    if(fld_int > 0) begin
      always@(posedge clk) begin
        pu_din_dly[fld_int] <= pu_din_dly[fld_int-1];
        pu_prt_dly[fld_int] <= pu_prt_dly[fld_int-1];
        pu_metadata_dly[fld_int] <= pu_metadata_dly[fld_int-1];
      end
    end else begin
      always_comb begin
        pu_din_dly[fld_int] = pu_din;
        pu_prt_dly[fld_int] = pu_prt;
        pu_metadata_dly[fld_int] <= pu_metadata;
      end
    end
  end // fld_loop
endgenerate


assign fl2qm_prt = pu_prt_dly[FLDELAY];
assign fl2qm_metadata = pu_metadata_dly[FLDELAY];
assign fl2qm_din = pu_din_dly[FLDELAY];

wire nptr_ready, data_ready, qm_ready;
reg fl_ready;
assign ready = nptr_ready && data_ready && fl_ready && qm_ready;

generate if (1) begin: a1_loop

  algo_mrnw_pque_doppler #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMPUPT (NUMPUPT), .NUMPOPT (NUMPOPT), .BITMDAT(BITMDAT),
                       .NUMQPRT (NUMQPRT), .BITQPRT (BITQPRT), .NUMPING (NUMPING), .BITPING (BITPING),
                       .NUMADDR (NUMADDR), .BITADDR (BITADDR), .BITPADR (BITPADR-1),
                       .QPTR_DELAY(QPTR_DELAY), .LINK_DELAY(LINK_DELAY+FLOPECC), .DATA_DELAY(DATA_DELAY+FLOPECC), .FLOPIN (FLOPIN), .FLOPOUT(FLOPOUT))
   algo_qm(
          .ready(qm_ready), .clk(clk), .rst (rst),
          .push(fl2qm_push), .pu_owr({NUMPUPT{1'b0}}), .pu_prt(fl2qm_prt), .pu_ptr(fl2qm_ptr), .pu_mdat(fl2qm_metadata), .pu_din(fl2qm_din), 
          .pu_cvld(), .pu_cnt(push_cnt), .pu_tail(push_tail), .pu_cserr(), .pu_cderr(),
          .pop(pop), .po_ndq({NUMPOPT{1'b0}}), .po_prt(po_prt), .po_cvld(), .po_cmt(), .po_cnt(), .po_cserr(), .po_cderr(),
          .po_pvld(qm2fl_push), .po_ptr(qm2fl_ptr), .po_mdat(po_metadata), .po_dvld(po_dvld), .po_dout(po_dout), .po_pserr(), .po_pderr(),  .po_dserr(), .po_dderr(),
          .cp_read(cp_read), .cp_write(cp_write), .cp_adr(cp_adr), .cp_din(cp_din), .cp_vld(cp_vld), .cp_dout(cp_dout),
          .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1), .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1), .t1_serrB(1'b0), .t1_derrB(1'b0),
          .t2_writeA(t2_writeA_a1), .t2_addrA(t2_addrA_a1), .t2_dinA(t2_dinA_a1), .t2_readB(t2_readB_a1), .t2_addrB(t2_addrB_a1), .t2_doutB(t2_doutB_a1), .t2_serrB(1'b0), .t2_derrB(1'b0),
          .t3_writeA(t7_writeA), .t3_addrA(t7_addrA), .t3_dinA(t7_dinA), .t3_readB(t7_readB), .t3_addrB(t7_addrB), .t3_doutB(t7_doutB_a1),       .t3_serrB({NUMPOPT{1'b0}}), .t3_derrB({NUMPOPT{1'b0}}),
          .t4_writeA(t8_writeA), .t4_addrA(t8_addrA), .t4_dinA(t8_dinA), .t4_readB(t8_readB), .t4_addrB(t8_addrB), .t4_doutB(t8_doutB_a1),       .t4_serrB({NUMPUPT{1'b0}}), .t4_derrB({NUMPUPT{1'b0}}),
          .t5_writeA(t9_writeA), .t5_addrA(t9_addrA), .t5_dinA(t9_dinA), .t5_readB(t9_readB), .t5_addrB(t9_addrB), .t5_doutB(t9_doutB_a1),       .t5_serrB({(NUMPOPT+NUMPUPT){1'b0}}), .t5_derrB({(NUMPOPT+NUMPUPT){1'b0}}),
          .t6_writeA(t10_writeA), .t6_addrA(t10_addrA), .t6_dinA(t10_dinA), .t6_readB(t10_readB), .t6_addrB(t10_addrB), .t6_doutB(t10_doutB_a1), .t6_serrB({(NUMPOPT+NUMPUPT){1'b0}}), .t6_derrB({(NUMPOPT+NUMPUPT){1'b0}}),
          .t7_writeA(t11_writeA), .t7_addrA(t11_addrA), .t7_dinA(t11_dinA), .t7_readB(t11_readB), .t7_addrB(t11_addrB), .t7_doutB(t11_doutB_a1), .t7_serrB({NUMPUPT{1'b0}}), .t7_derrB({NUMPUPT{1'b0}}),
          .select_qprt (select_qprt), .select_addr (select_addr));

end
endgenerate


wire [T1_T1_NUMVBNK-1:0] t1_writeA_nptr;
wire [T1_T1_NUMVBNK*T1_T1_BITVROW-1:0] t1_addrA_nptr;
wire [T1_T1_NUMVBNK*(BITQPTR+BITMDAT)-1:0] t1_dinA_nptr;

wire [T1_T1_NUMVBNK-1:0] t1_readB_nptr;
wire [T1_T1_NUMVBNK*T1_T1_BITVROW-1:0] t1_addrB_nptr;
reg [T1_T1_NUMVBNK*(BITQPTR+BITMDAT)-1:0] t1_doutB_nptr;
reg [T1_T1_NUMVBNK-1:0] t1_fwrdB_nptr;
reg [T1_T1_NUMVBNK-1:0] t1_serrB_nptr;
reg [T1_T1_NUMVBNK-1:0] t1_derrB_nptr;
reg [T1_T1_NUMVBNK*(T1_T1_BITVROW)-1:0] t1_padrB_nptr;

wire [T1_T2_NUMVBNK-1:0] t2_writeA_nptr;
wire [T1_T2_NUMVBNK*T1_T2_BITVROW-1:0] t2_addrA_nptr;
wire [T1_T2_NUMVBNK*(BITQPTR+BITMDAT)-1:0] t2_dinA_nptr;

wire[T1_T2_NUMVBNK-1:0] t2_readB_nptr;
wire[T1_T2_NUMVBNK*T1_T2_BITVROW-1:0] t2_addrB_nptr;
reg [T1_T2_NUMVBNK*(BITQPTR+BITMDAT)-1:0] t2_doutB_nptr;
reg [T1_T2_NUMVBNK-1:0] t2_fwrdB_nptr;
reg [T1_T2_NUMVBNK-1:0] t2_serrB_nptr;
reg [T1_T2_NUMVBNK-1:0] t2_derrB_nptr;
reg [T1_T2_NUMVBNK*(T1_T2_BITVROW)-1:0] t2_padrB_nptr;

wire [T1_T3_NUMVBNK-1:0] t3_writeA_nptr;
wire [T1_T3_NUMVBNK*T1_T3_BITVROW-1:0] t3_addrA_nptr;
wire [T1_T3_NUMVBNK*(T1_T1_BITVBNK+1)-1:0] t3_dinA_nptr;

wire[T1_T3_NUMVBNK-1:0] t3_readB_nptr;
wire[T1_T3_NUMVBNK*T1_T3_BITVROW-1:0] t3_addrB_nptr;
reg [T1_T3_NUMVBNK*(T1_T1_BITVBNK+1)-1:0] t3_doutB_nptr;
reg [T1_T3_NUMVBNK-1:0] t3_fwrdB_nptr;
reg [T1_T3_NUMVBNK-1:0] t3_serrB_nptr;
reg [T1_T3_NUMVBNK-1:0] t3_derrB_nptr;
reg [T1_T3_NUMVBNK*(T1_T3_BITVROW)-1:0] t3_padrB_nptr;

generate if (1) begin: nptr_loop
algo_nr2w_1r1w #( .WIDTH((BITQPTR+BITMDAT)), .BITWDTH(BITQPTR), .ENAPSDO(0), .ENAPAR(0), .ENAECC(0),
                  .NUMRDPT(NUMPOPT), .NUMADDR(NUMQPTR), .BITADDR(BITADDR), .NUMVROW(T1_T1_NUMVROW), .BITVROW(T1_T1_BITVROW),
                  .NUMVBNK(T1_T1_NUMVBNK), .BITVBNK(T1_T1_BITVBNK), .BITPBNK(BITPBNK), .BITPADR(T1_T1_BITVROW+1),
                  .SRAM_DELAY(LINK_DELAY+FLOPECC), .FLOPIN(FLOPIN), .FLOPOUT(FLOPOUT))
        algo ( .write(t1_writeA_a1), .wr_adr(t1_addrA_a1), .din(t1_dinA_a1),
              .read(t1_readB_a1), .rd_adr(t1_addrB_a1), .rd_vld(), .rd_dout(t1_doutB_a1),
              .rd_fwrd(), .rd_serr(), .rd_derr(), .rd_padr(),
              .t1_writeA(t1_writeA_nptr), .t1_addrA(t1_addrA_nptr), .t1_dinA(t1_dinA_nptr), 
              .t1_readB(t1_readB_nptr), .t1_addrB(t1_addrB_nptr), .t1_doutB(t1_doutB_nptr),
              .t1_fwrdB(t1_fwrdB_nptr), .t1_serrB(t1_serrB_nptr), .t1_derrB(t1_derrB_nptr), .t1_padrB(t1_padrB_nptr),
              .t2_writeA(t2_writeA_nptr), .t2_addrA(t2_addrA_nptr), .t2_dinA(t2_dinA_nptr),
              .t2_readB(t2_readB_nptr), .t2_addrB(t2_addrB_nptr), .t2_doutB(t2_doutB_nptr),
              .t2_fwrdB(t2_fwrdB_nptr), .t2_serrB(t2_serrB_nptr), .t2_derrB(t2_derrB_nptr), .t2_padrB(t2_padrB_nptr),
              .t3_writeA(t3_writeA_nptr), .t3_addrA(t3_addrA_nptr), .t3_dinA(t3_dinA_nptr),
              .t3_readB(t3_readB_nptr), .t3_addrB(t3_addrB_nptr), .t3_doutB(t3_doutB_nptr), .t3_fwrdB(t3_fwrdB_nptr),
              .t3_serrB(t3_serrB_nptr), .t3_derrB(t3_derrB_nptr), .t3_padrB(t3_padrB_nptr),
              .ready(nptr_ready), .clk(clk), .rst(rst),
              .select_addr({BITQPTR{1'b0}}), .select_bit({BITQPTR{1'b0}}));

end
endgenerate

wire t1_writeA_wire [0:NUMPOPT-1][0:T1_T1_NUMVBNK-1];
wire [T1_T1_BITSROW-1:0] t1_addrA_wire [0:NUMPOPT-1][0:T1_T1_NUMVBNK-1];
wire [T1_T1_PHYWDTH-1:0] t1_bwA_wire [0:NUMPOPT-1][0:T1_T1_NUMVBNK-1];
wire [T1_T1_PHYWDTH-1:0] t1_dinA_wire [0:NUMPOPT-1][0:T1_T1_NUMVBNK-1];
wire t1_readB_wire [0:NUMPOPT-1][0:T1_T1_NUMVBNK-1];
wire [T1_T1_BITSROW-1:0] t1_addrB_wire [0:NUMPOPT-1][0:T1_T1_NUMVBNK-1];
wire [(BITQPTR+BITMDAT)-1:0] t1_doutB_nptr_wire [0:NUMPOPT-1][0:T1_T1_NUMVBNK-1];
wire t1_fwrdB_nptr_wire [0:NUMPOPT-1][0:T1_T1_NUMVBNK-1];
wire t1_serrB_nptr_wire [0:NUMPOPT-1][0:T1_T1_NUMVBNK-1];
wire t1_derrB_nptr_wire [0:NUMPOPT-1][0:T1_T1_NUMVBNK-1];
wire [T1_T1_BITVROW-1:0] t1_padrB_nptr_wire [0:NUMPOPT-1][0:T1_T1_NUMVBNK-1];

genvar t1r, t1b;
generate
  for (t1r=0; t1r<NUMPOPT; t1r=t1r+1) begin: t1r_loop
    for (t1b=0; t1b<T1_T1_NUMVBNK; t1b=t1b+1) begin: t1b_loop
      wire t1_writeA_nptr_wire = t1_writeA_nptr >> (t1r*T1_T1_NUMVBNK+t1b);
      wire [T1_T1_BITVROW-1:0] t1_addrA_nptr_wire = t1_addrA_nptr >> ((t1r*T1_T1_NUMVBNK+t1b)*T1_T1_BITVROW);
      wire [(BITQPTR+BITMDAT)-1:0] t1_dinA_nptr_wire = t1_dinA_nptr >> ((t1r*T1_T1_NUMVBNK+t1b)*(BITQPTR+BITMDAT));
      wire t1_readB_nptr_wire = t1_readB_nptr >> (t1r*T1_T1_NUMVBNK+t1b);
      wire [T1_T1_BITVROW-1:0] t1_addrB_nptr_wire = t1_addrB_nptr >> ((t1r*T1_T1_NUMVBNK+t1b)*T1_T1_BITVROW);

      wire [NUMWRDS*T1_T1_PHYWDTH-1:0] t1_doutB_wire = t1_doutB >> ((t1r*T1_T1_NUMVBNK+t1b)*T1_T1_PHYWDTH);

      wire mem_write_t1_wire;
      wire [T1_T1_BITSROW-1:0] mem_wr_adr_t1_wire;
      wire [NUMWRDS*T1_T1_PHYWDTH-1:0] mem_bw_t1_wire;
      wire [NUMWRDS*T1_T1_PHYWDTH-1:0] mem_din_t1_wire;
      wire mem_read_t1_wire;
      wire [T1_T1_BITSROW-1:0] mem_rd_adr_t1_wire;
      wire [NUMWRDS*T1_T1_PHYWDTH-1:0] mem_rd_dout_t1_wire;
      wire mem_rd_fwrd_t1_wire;
      wire mem_rd_serr_t1_wire;
      wire mem_rd_derr_t1_wire;
      wire [(BITWBNK+T1_T1_BITSROW)-1:0] mem_rd_padr_t1_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH ((BITQPTR+BITMDAT)), .ENAPSDO (NUMWRDS==1), .ENAECC (0), .ECCWDTH (T1_T1_PHYWDTH-(BITQPTR+BITMDAT)), .ENAPADR (1),
                               .NUMADDR (T1_T1_NUMVROW), .BITADDR (T1_T1_BITVROW),
                               .NUMSROW (T1_T1_NUMSROW), .BITSROW (T1_T1_BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (T1_T1_BITSROW),
                               .SRAM_DELAY (LINK_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC))
          infra (.write(t1_writeA_nptr_wire), .wr_adr(t1_addrA_nptr_wire), .din(t1_dinA_nptr_wire),
                 .read(t1_readB_nptr_wire), .rd_adr(t1_addrB_nptr_wire),
                 .rd_dout(t1_doutB_nptr_wire[t1r][t1b]), .rd_fwrd(t1_fwrdB_nptr_wire[t1r][t1b]),
                 .rd_serr(t1_serrB_nptr_wire[t1r][t1b]), .rd_derr(t1_derrB_nptr_wire[t1r][t1b]), .rd_padr(t1_padrB_nptr_wire[t1r][t1b]),
                 .mem_write (mem_write_t1_wire), .mem_wr_adr(mem_wr_adr_t1_wire), .mem_bw (mem_bw_t1_wire), .mem_din (mem_din_t1_wire),
                 .mem_read (mem_read_t1_wire), .mem_rd_adr(mem_rd_adr_t1_wire), .mem_rd_dout (mem_rd_dout_t1_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_t1_wire), .mem_rd_padr(mem_rd_padr_t1_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (NUMWRDS*T1_T1_PHYWDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (T1_T1_NUMSROW), .BITADDR (T1_T1_BITSROW),
                           .NUMWROW (T1_T1_NUMSROW), .BITWROW (T1_T1_BITSROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                           .SRAM_DELAY (LINK_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
          infra (.write (mem_write_t1_wire), .wr_adr (mem_wr_adr_t1_wire), .bw (mem_bw_t1_wire), .din (mem_din_t1_wire),
                 .read (mem_read_t1_wire), .rd_adr (mem_rd_adr_t1_wire), .rd_dout (mem_rd_dout_t1_wire),
                 .rd_fwrd (mem_rd_fwrd_t1_wire), .rd_serr (mem_rd_serr_t1_wire), .rd_derr(mem_rd_derr_t1_wire), .rd_padr(mem_rd_padr_t1_wire),
                 .mem_write (t1_writeA_wire[t1r][t1b]), .mem_wr_adr(t1_addrA_wire[t1r][t1b]),
                 .mem_bw (t1_bwA_wire[t1r][t1b]), .mem_din (t1_dinA_wire[t1r][t1b]),
                 .mem_read (t1_readB_wire[t1r][t1b]), .mem_rd_adr(t1_addrB_wire[t1r][t1b]), .mem_rd_dout (t1_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_srow));
      end
    end
  end
endgenerate

reg [NUMPOPT*T1_T1_NUMVBNK-1:0] t1_writeA;
reg [NUMPOPT*T1_T1_NUMVBNK*T1_T1_BITSROW-1:0] t1_addrA;
reg [NUMPOPT*T1_T1_NUMVBNK*T1_T1_PHYWDTH-1:0] t1_bwA;
reg [NUMPOPT*T1_T1_NUMVBNK*T1_T1_PHYWDTH-1:0] t1_dinA;
reg [NUMPOPT*T1_T1_NUMVBNK-1:0] t1_readB;
reg [NUMPOPT*T1_T1_NUMVBNK*T1_T1_BITSROW-1:0] t1_addrB;
integer t1r_int, t1b_int;
always_comb begin
  t1_writeA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  t1_readB = 0;
  t1_addrB = 0;
  t1_doutB_nptr = 0;
  t1_fwrdB_nptr = 0;
  t1_serrB_nptr = 0;
  t1_derrB_nptr = 0;
  t1_padrB_nptr = 0;
  for (t1r_int=0; t1r_int<NUMPOPT; t1r_int=t1r_int+1) begin
    for (t1b_int=0; t1b_int<T1_T1_NUMVBNK; t1b_int=t1b_int+1) begin
      t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int][t1b_int] << (t1r_int*T1_T1_NUMVBNK+t1b_int));
      t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int][t1b_int] << ((t1r_int*T1_T1_NUMVBNK+t1b_int)*T1_T1_BITSROW));
      t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int][t1b_int] << ((t1r_int*T1_T1_NUMVBNK+t1b_int)*T1_T1_PHYWDTH));
      t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int][t1b_int] << ((t1r_int*T1_T1_NUMVBNK+t1b_int)*T1_T1_PHYWDTH));
      t1_readB = t1_readB | (t1_readB_wire[t1r_int][t1b_int] << (t1r_int*T1_T1_NUMVBNK+t1b_int));
      t1_addrB = t1_addrB | (t1_addrB_wire[t1r_int][t1b_int] << ((t1r_int*T1_T1_NUMVBNK+t1b_int)*T1_T1_BITSROW));
      t1_doutB_nptr = t1_doutB_nptr | (t1_doutB_nptr_wire[t1r_int][t1b_int] << ((t1r_int*T1_T1_NUMVBNK+t1b_int)*(BITQPTR+BITMDAT)));
      t1_fwrdB_nptr = t1_fwrdB_nptr | (t1_fwrdB_nptr_wire[t1r_int][t1b_int] << (t1r_int*T1_T1_NUMVBNK+t1b_int));
      t1_serrB_nptr = t1_serrB_nptr | (t1_serrB_nptr_wire[t1r_int][t1b_int] << (t1r_int*T1_T1_NUMVBNK+t1b_int));
      t1_derrB_nptr = t1_derrB_nptr | (t1_derrB_nptr_wire[t1r_int][t1b_int] << (t1r_int*T1_T1_NUMVBNK+t1b_int));
      t1_padrB_nptr = t1_padrB_nptr | (t1_padrB_nptr_wire[t1r_int][t1b_int] << ((t1r_int*T1_T1_NUMVBNK+t1b_int)*(T1_T1_BITSROW)));
    end
  end
end

wire t2_writeA_wire [0:(NUMPOPT+1)-1][0:1-1];
wire [T1_T2_BITSROW-1:0] t2_addrA_wire [0:(NUMPOPT+1)-1][0:1-1];
wire [NUMWRDS*T1_T2_PHYWDTH-1:0] t2_bwA_wire [0:(NUMPOPT+1)-1][0:1-1];
wire [NUMWRDS*T1_T2_PHYWDTH-1:0] t2_dinA_wire [0:(NUMPOPT+1)-1][0:1-1];
wire t2_readB_wire [0:(NUMPOPT+1)-1][0:1-1];
wire [T1_T2_BITSROW-1:0] t2_addrB_wire [0:(NUMPOPT+1)-1][0:1-1];
wire [(BITQPTR+BITMDAT)-1:0] t2_doutB_nptr_wire [0:(NUMPOPT+1)-1][0:1-1];
wire t2_fwrdB_nptr_wire [0:(NUMPOPT+1)-1][0:1-1];
wire t2_serrB_nptr_wire [0:(NUMPOPT+1)-1][0:1-1];
wire t2_derrB_nptr_wire [0:(NUMPOPT+1)-1][0:1-1];
wire [T1_T2_BITSROW+BITWRDS-1:0] t2_padrB_nptr_wire [0:(NUMPOPT+1)-1][0:1-1];

genvar t2r, t2b;
generate
  for (t2r=0; t2r<(NUMPOPT+1); t2r=t2r+1) begin: t2r_loop
    for (t2b=0; t2b<1; t2b=t2b+1) begin: t2b_loop
      wire t2_writeA_nptr_wire = t2_writeA_nptr >> (t2r*1+t2b);
      wire [T1_T2_BITVROW-1:0] t2_addrA_nptr_wire = t2_addrA_nptr >> ((t2r*1+t2b)*T1_T2_BITVROW);
      wire [(BITQPTR+BITMDAT)-1:0] t2_dinA_nptr_wire = t2_dinA_nptr >> ((t2r*1+t2b)*(BITQPTR+BITMDAT));
      wire t2_readB_nptr_wire = t2_readB_nptr >> (t2r*1+t2b);
      wire [T1_T2_BITVROW-1:0] t2_addrB_nptr_wire = t2_addrB_nptr >> ((t2r*1+t2b)*T1_T2_BITVROW);

      wire [NUMWRDS*T1_T2_PHYWDTH-1:0] t2_doutB_wire = t2_doutB >> ((t2r*1+t2b)*T1_T2_PHYWDTH);

      wire mem_write_t2_wire;
      wire [T1_T2_BITSROW-1:0] mem_wr_adr_t2_wire;
      wire [NUMWRDS*T1_T1_PHYWDTH-1:0] mem_bw_t2_wire;
      wire [NUMWRDS*T1_T1_PHYWDTH-1:0] mem_din_t2_wire;
      wire mem_read_t2_wire;
      wire [T1_T2_BITSROW-1:0] mem_rd_adr_t2_wire;
      wire [NUMWRDS*T1_T1_PHYWDTH-1:0] mem_rd_dout_t2_wire;
      wire mem_rd_fwrd_t2_wire;
      wire mem_rd_serr_t2_wire;
      wire mem_rd_derr_t2_wire;
      wire [(BITWBNK+T1_T2_BITSROW)-1:0] mem_rd_padr_t2_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH ((BITQPTR+BITMDAT)), .ENAPSDO (NUMWRDS==1), .ENAECC (0), .ECCWDTH (T1_T2_PHYWDTH-(BITQPTR+BITMDAT)), .ENAPADR (1),
                               .NUMADDR (T1_T2_NUMVROW), .BITADDR (T1_T2_BITVROW),
                               .NUMSROW (NUMSROW), .BITSROW (T1_T2_BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (T1_T2_BITSROW),
                               .SRAM_DELAY (LINK_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.write(t2_writeA_nptr_wire), .wr_adr(t2_addrA_nptr_wire), .din(t2_dinA_nptr_wire),
                 .read(t2_readB_nptr_wire), .rd_adr(t2_addrB_nptr_wire),
                 .rd_dout(t2_doutB_nptr_wire[t2r][t2b]), .rd_fwrd(t2_fwrdB_nptr_wire[t2r][t2b]),
                 .rd_serr(t2_serrB_nptr_wire[t2r][t2b]), .rd_derr(t2_derrB_nptr_wire[t2r][t2b]), .rd_padr(t2_padrB_nptr_wire[t2r][t2b]),
                 .mem_write (mem_write_t2_wire), .mem_wr_adr(mem_wr_adr_t2_wire), .mem_bw (mem_bw_t2_wire), .mem_din (mem_din_t2_wire),
                 .mem_read (mem_read_t2_wire), .mem_rd_adr(mem_rd_adr_t2_wire), .mem_rd_dout (mem_rd_dout_t2_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_t2_wire), .mem_rd_padr(mem_rd_padr_t2_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (NUMWRDS*T1_T2_PHYWDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (NUMSROW), .BITADDR (T1_T2_BITSROW),
                           .NUMWROW (T1_T2_NUMSROW), .BITWROW (T1_T2_BITSROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                           .SRAM_DELAY (LINK_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1))
          infra (.write (mem_write_t2_wire), .wr_adr (mem_wr_adr_t2_wire), .bw (mem_bw_t2_wire), .din (mem_din_t2_wire),
                 .read (mem_read_t2_wire), .rd_adr (mem_rd_adr_t2_wire), .rd_dout (mem_rd_dout_t2_wire),
                 .rd_fwrd (mem_rd_fwrd_t2_wire), .rd_serr (mem_rd_serr_t2_wire), .rd_derr(mem_rd_derr_t2_wire), .rd_padr(mem_rd_padr_t2_wire),
                 .mem_write (t2_writeA_wire[t2r][t2b]), .mem_wr_adr(t2_addrA_wire[t2r][t2b]),
                 .mem_bw (t2_bwA_wire[t2r][t2b]), .mem_din (t2_dinA_wire[t2r][t2b]),
                 .mem_read (t2_readB_wire[t2r][t2b]), .mem_rd_adr(t2_addrB_wire[t2r][t2b]), .mem_rd_dout (t2_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_srow));
      end
    end
  end
endgenerate

reg [(NUMPOPT+1)-1:0] t2_writeA;
reg [(NUMPOPT+1)*T1_T2_BITSROW-1:0] t2_addrA;
reg [(NUMPOPT+1)*T1_T2_PHYWDTH-1:0] t2_bwA;
reg [(NUMPOPT+1)*T1_T2_PHYWDTH-1:0] t2_dinA;
reg [(NUMPOPT+1)-1:0] t2_readB;
reg [(NUMPOPT+1)*T1_T2_BITSROW-1:0] t2_addrB;
integer t2r_int, t2b_int;
always_comb begin
  t2_writeA = 0;
  t2_addrA = 0;
  t2_bwA = 0;
  t2_dinA = 0;
  t2_readB = 0;
  t2_addrB = 0;
  t2_doutB_nptr = 0;
  t2_fwrdB_nptr = 0;
  t2_serrB_nptr = 0;
  t2_derrB_nptr = 0;
  t2_padrB_nptr = 0;
  for (t2r_int=0; t2r_int<NUMPOPT+1; t2r_int=t2r_int+1) begin
    for (t2b_int=0; t2b_int<1; t2b_int=t2b_int+1) begin
      t2_writeA = t2_writeA | (t2_writeA_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_addrA = t2_addrA | (t2_addrA_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*T1_T2_BITSROW));
      t2_bwA = t2_bwA | (t2_bwA_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*T1_T2_PHYWDTH));
      t2_dinA = t2_dinA | (t2_dinA_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*T1_T2_PHYWDTH));
      t2_readB = t2_readB | (t2_readB_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_addrB = t2_addrB | (t2_addrB_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*T1_T2_BITSROW));
      t2_doutB_nptr = t2_doutB_nptr | (t2_doutB_nptr_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*(BITQPTR+BITMDAT)));
      t2_fwrdB_nptr = t2_fwrdB_nptr | (t2_fwrdB_nptr_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_serrB_nptr = t2_serrB_nptr | (t2_serrB_nptr_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_derrB_nptr = t2_derrB_nptr | (t2_derrB_nptr_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_padrB_nptr = t2_padrB_nptr | (t2_padrB_nptr_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*(T1_T2_BITSROW+BITWRDS)));
    end
  end
end

wire t3_writeA_wire [0:(NUMPOPT+2)-1][0:1-1];
wire [T1_T3_BITVROW-1:0] t3_addrA_wire [0:(NUMPOPT+2)-1][0:1-1];
wire [T1_T3_PHYWDTH-1:0] t3_bwA_wire [0:(NUMPOPT+2)-1][0:1-1];
wire [T1_T3_PHYWDTH-1:0] t3_dinA_wire [0:(NUMPOPT+2)-1][0:1-1];
wire t3_readB_wire [0:(NUMPOPT+2)-1][0:1-1];
wire [T1_T3_BITVROW-1:0] t3_addrB_wire [0:(NUMPOPT+2)-1][0:1-1];
wire [(T1_T1_BITVBNK+1)-1:0] t3_doutB_nptr_wire [0:(NUMPOPT+2)-1][0:1-1];
wire t3_fwrdB_nptr_wire [0:(NUMPOPT+2)-1][0:1-1];
wire t3_serrB_nptr_wire [0:(NUMPOPT+2)-1][0:1-1];
wire t3_derrB_nptr_wire [0:(NUMPOPT+2)-1][0:1-1];
wire [T1_T3_BITVROW-1:0] t3_padrB_nptr_wire [0:(NUMPOPT+2)-1][0:1-1];

genvar t3r, t3b;
generate
  for (t3r=0; t3r<NUMPOPT+2; t3r=t3r+1) begin: t3r_loop
    for (t3b=0; t3b<1; t3b=t3b+1) begin: t3b_loop
      wire t3_writeA_nptr_wire = t3_writeA_nptr >> (t3r*1+t3b);
      wire [T1_T3_BITVROW-1:0] t3_addrA_nptr_wire = t3_addrA_nptr >> ((t3r*1+t3b)*T1_T3_BITVROW);
      wire [(T1_T1_BITVBNK+1)-1:0] t3_dinA_nptr_wire = t3_dinA_nptr >> ((t3r*1+t3b)*(T1_T1_BITVBNK+1));
      wire t3_readB_nptr_wire = t3_readB_nptr >> (t3r*1+t3b);
      wire [T1_T3_BITVROW-1:0] t3_addrB_nptr_wire = t3_addrB_nptr >> ((t3r*1+t3b)*T1_T3_BITVROW);

      wire [T1_T3_PHYWDTH-1:0] t3_doutB_wire = t3_doutB >> ((t3r*1+t3b)*T1_T3_PHYWDTH);

      wire mem_write_t3_wire;
      wire [T1_T3_BITVROW-1:0] mem_wr_adr_t3_wire;
      wire [T1_T3_PHYWDTH-1:0] mem_bw_t3_wire;
      wire [T1_T3_PHYWDTH-1:0] mem_din_t3_wire;
      wire mem_read_t3_wire;
      wire [T1_T3_BITVROW-1:0] mem_rd_adr_t3_wire;
      wire [T1_T3_PHYWDTH-1:0] mem_rd_dout_t3_wire;
      wire mem_rd_fwrd_t3_wire;
      wire mem_rd_serr_t3_wire;
      wire mem_rd_derr_t3_wire;
      wire [T1_T3_BITVROW-1:0] mem_rd_padr_t3_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w_a63 #(.WIDTH (T1_T1_BITVBNK+1), .ENAPSDO (1), .ENADEC(1), .ECCWDTH (T1_T3_PHYWDTH-2*(T1_T1_BITVBNK+1)), .ENAPADR (1),
                                   .NUMADDR (T1_T3_NUMVROW), .BITADDR (T1_T3_BITVROW),
                                   .NUMSROW (T1_T3_NUMVROW), .BITSROW (T1_T3_BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (T1_T3_BITVROW),
                                   .SRAM_DELAY (LINK_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.write(t3_writeA_nptr_wire), .wr_adr(t3_addrA_nptr_wire), .din(t3_dinA_nptr_wire),
                 .read(t3_readB_nptr_wire), .rd_adr(t3_addrB_nptr_wire),
                 .rd_dout(t3_doutB_nptr_wire[t3r][t3b]), .rd_fwrd(t3_fwrdB_nptr_wire[t3r][t3b]),
                 .rd_serr(t3_serrB_nptr_wire[t3r][t3b]), .rd_derr(t3_derrB_nptr_wire[t3r][t3b]), .rd_padr(t3_padrB_nptr_wire[t3r][t3b]),
                 .mem_write (mem_write_t3_wire), .mem_wr_adr(mem_wr_adr_t3_wire), .mem_bw (mem_bw_t3_wire), .mem_din (mem_din_t3_wire),
                 .mem_read (mem_read_t3_wire), .mem_rd_adr(mem_rd_adr_t3_wire), .mem_rd_dout (mem_rd_dout_t3_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_t3_wire), .mem_rd_padr(mem_rd_padr_t3_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (T1_T3_PHYWDTH), .ENAPSDO (0), .NUMADDR (T1_T3_NUMVROW), .BITADDR (T1_T3_BITVROW),
                           .NUMWROW (T1_T3_NUMVROW), .BITWROW (T1_T3_BITVROW), .NUMWBNK (1), .BITWBNK (0),
                           .SRAM_DELAY (LINK_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1))
          infra (.write (mem_write_t3_wire), .wr_adr (mem_wr_adr_t3_wire), .bw (mem_bw_t3_wire), .din (mem_din_t3_wire),
                 .read (mem_read_t3_wire), .rd_adr (mem_rd_adr_t3_wire), .rd_dout (mem_rd_dout_t3_wire),
                 .rd_fwrd (mem_rd_fwrd_t3_wire), .rd_serr (mem_rd_serr_t3_wire), .rd_derr(mem_rd_derr_t3_wire), .rd_padr(mem_rd_padr_t3_wire),
                 .mem_write (t3_writeA_wire[t3r][t3b]), .mem_wr_adr(t3_addrA_wire[t3r][t3b]),
                 .mem_bw (t3_bwA_wire[t3r][t3b]), .mem_din (t3_dinA_wire[t3r][t3b]),
                 .mem_read (t3_readB_wire[t3r][t3b]), .mem_rd_adr(t3_addrB_wire[t3r][t3b]), .mem_rd_dout (t3_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_vrow));
      end
    end
  end
endgenerate

reg [(NUMPOPT+2)-1:0] t3_writeA;
reg [(NUMPOPT+2)*T1_T3_BITVROW-1:0] t3_addrA;
reg [(NUMPOPT+2)*T1_T3_PHYWDTH-1:0] t3_bwA;
reg [(NUMPOPT+2)*T1_T3_PHYWDTH-1:0] t3_dinA;
reg [(NUMPOPT+2)-1:0] t3_readB;
reg [(NUMPOPT+2)*T1_T3_BITVROW-1:0] t3_addrB;
integer t3r_int, t3b_int;
always_comb begin
  t3_writeA = 0;
  t3_addrA = 0;
  t3_bwA = 0;
  t3_dinA = 0;
  t3_readB = 0;
  t3_addrB = 0;
  t3_doutB_nptr = 0;
  t3_fwrdB_nptr = 0;
  t3_serrB_nptr = 0;
  t3_derrB_nptr = 0;
  t3_padrB_nptr = 0;
  for (t3r_int=0; t3r_int<NUMPOPT+2; t3r_int=t3r_int+1) begin
    for (t3b_int=0; t3b_int<1; t3b_int=t3b_int+1) begin
      t3_writeA = t3_writeA | (t3_writeA_wire[t3r_int][t3b_int] << (t3r_int*1+t3b_int));
      t3_addrA = t3_addrA | (t3_addrA_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*T1_T3_BITVROW));
      t3_bwA = t3_bwA | (t3_bwA_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*T1_T3_PHYWDTH));
      t3_dinA = t3_dinA | (t3_dinA_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*T1_T3_PHYWDTH));
      t3_readB = t3_readB | (t3_readB_wire[t3r_int][t3b_int] << (t3r_int*1+t3b_int));
      t3_addrB = t3_addrB | (t3_addrB_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*T1_T3_BITVROW));
      t3_doutB_nptr = t3_doutB_nptr | (t3_doutB_nptr_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*(T1_T1_BITVBNK+1)));
      t3_fwrdB_nptr = t3_fwrdB_nptr | (t3_fwrdB_nptr_wire[t3r_int][t3b_int] << (t3r_int*1+t3b_int));
      t3_serrB_nptr = t3_serrB_nptr | (t3_serrB_nptr_wire[t3r_int][t3b_int] << (t3r_int*1+t3b_int));
      t3_derrB_nptr = t3_derrB_nptr | (t3_derrB_nptr_wire[t3r_int][t3b_int] << (t3r_int*1+t3b_int));
      t3_padrB_nptr = t3_padrB_nptr | (t3_padrB_nptr_wire[t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*(T1_T3_BITSROW+BITWRDS)));
    end
  end
end

wire [T2_T1_NUMVBNK-1:0] t4_writeA_dl;
wire [T2_T1_NUMVBNK*T2_T1_BITVROW-1:0] t4_addrA_dl;
wire [T2_T1_NUMVBNK*T2_T1_WIDTH-1:0] t4_dinA_dl;

wire [T2_T1_NUMVBNK-1:0] t4_readB_dl;
wire [T2_T1_NUMVBNK*T2_T1_BITVROW-1:0] t4_addrB_dl;
reg [T2_T1_NUMVBNK*T2_T1_WIDTH-1:0] t4_doutB_dl;
reg [T2_T1_NUMVBNK-1:0] t4_fwrdB_dl;
reg [T2_T1_NUMVBNK-1:0] t4_serrB_dl;
reg [T2_T1_NUMVBNK-1:0] t4_derrB_dl;
reg [T2_T1_NUMVBNK*(T2_T1_BITVROW)-1:0] t4_padrB_dl;

wire [T2_T2_NUMVBNK-1:0] t5_writeA_dl;
wire [T2_T2_NUMVBNK*T2_T2_BITVROW-1:0] t5_addrA_dl;
wire [T2_T2_NUMVBNK*T2_T2_WIDTH-1:0] t5_dinA_dl;

wire[T2_T2_NUMVBNK-1:0] t5_readB_dl;
wire[T2_T2_NUMVBNK*T2_T2_BITVROW-1:0] t5_addrB_dl;
reg [T2_T2_NUMVBNK*T2_T2_WIDTH-1:0] t5_doutB_dl;
reg [T2_T2_NUMVBNK-1:0] t5_fwrdB_dl;
reg [T2_T2_NUMVBNK-1:0] t5_serrB_dl;
reg [T2_T2_NUMVBNK-1:0] t5_derrB_dl;
reg [T2_T2_NUMVBNK*(T2_T2_BITVROW)-1:0] t5_padrB_dl;

wire [T2_T3_NUMVBNK-1:0] t6_writeA_dl;
wire [T2_T3_NUMVBNK*T2_T3_BITVROW-1:0] t6_addrA_dl;
wire [T2_T3_NUMVBNK*(T2_T1_BITVBNK+1)-1:0] t6_dinA_dl;

wire[T2_T3_NUMVBNK-1:0] t6_readB_dl;
wire[T2_T3_NUMVBNK*T2_T3_BITVROW-1:0] t6_addrB_dl;
reg [T2_T3_NUMVBNK*(T2_T1_BITVBNK+1)-1:0] t6_doutB_dl;
reg [T2_T3_NUMVBNK-1:0] t6_fwrdB_dl;
reg [T2_T3_NUMVBNK-1:0] t6_serrB_dl;
reg [T2_T3_NUMVBNK-1:0] t6_derrB_dl;
reg [T2_T3_NUMVBNK*(T2_T3_BITVROW)-1:0] t6_padrB_dl;

generate if (1) begin: data_loop
algo_nr2w_1r1w #( .WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAPSDO(0), .ENAPAR(0), .ENAECC(0),
                  .NUMRDPT(NUMPOPT), .NUMADDR(NUMQPTR), .BITADDR(BITADDR), .NUMVROW(T2_T1_NUMVROW), .BITVROW(T2_T1_BITVROW),
                  .NUMVBNK(T2_T1_NUMVBNK), .BITVBNK(T2_T1_BITVBNK), .BITPBNK(BITPBNK), .BITPADR(T2_T1_BITVROW+1),
                  .SRAM_DELAY(LINK_DELAY+FLOPECC), .FLOPIN(FLOPIN), .FLOPOUT(FLOPOUT))
        algo ( .write(t2_writeA_a1), .wr_adr(t2_addrA_a1), .din(t2_dinA_a1),
              .read(t2_readB_a1), .rd_adr(t2_addrB_a1), .rd_vld(), .rd_dout(t2_doutB_a1),
              .rd_fwrd(), .rd_serr(), .rd_derr(), .rd_padr(),
              .t1_writeA(t4_writeA_dl), .t1_addrA(t4_addrA_dl), .t1_dinA(t4_dinA_dl),
              .t1_readB(t4_readB_dl), .t1_addrB(t4_addrB_dl), .t1_doutB(t4_doutB_dl),
              .t1_fwrdB(t4_fwrdB_dl), .t1_serrB(t4_serrB_dl), .t1_derrB(t4_derrB_dl), .t1_padrB(t4_padrB_dl),
              .t2_writeA(t5_writeA_dl), .t2_addrA(t5_addrA_dl), .t2_dinA(t5_dinA_dl),
              .t2_readB(t5_readB_dl), .t2_addrB(t5_addrB_dl), .t2_doutB(t5_doutB_dl),
              .t2_fwrdB(t5_fwrdB_dl), .t2_serrB(t5_serrB_dl), .t2_derrB(t5_derrB_dl), .t2_padrB(t5_padrB_dl),
              .t3_writeA(t6_writeA_dl), .t3_addrA(t6_addrA_dl), .t3_dinA(t6_dinA_dl),
              .t3_readB(t6_readB_dl), .t3_addrB(t6_addrB_dl), .t3_doutB(t6_doutB_dl), .t3_fwrdB(t6_fwrdB_dl),
              .t3_serrB(t6_serrB_dl), .t3_derrB(t6_derrB_dl), .t3_padrB(t6_padrB_dl),
              .ready(data_ready), .clk(clk), .rst(rst),
              .select_addr({BITQPTR{1'b0}}), .select_bit({BITWDTH{1'b0}}));

end
endgenerate


wire t4_writeA_wire [0:NUMPOPT-1][0:T2_T1_NUMVBNK-1];
wire [T2_T1_BITSROW-1:0] t4_addrA_wire [0:NUMPOPT-1][0:T2_T1_NUMVBNK-1];
wire [T2_T1_WIDTH-1:0] t4_bwA_wire [0:NUMPOPT-1][0:T2_T1_NUMVBNK-1];
wire [T2_T1_WIDTH-1:0] t4_dinA_wire [0:NUMPOPT-1][0:T2_T1_NUMVBNK-1];
wire t4_readB_wire [0:NUMPOPT-1][0:T2_T1_NUMVBNK-1];
wire [T2_T1_BITSROW-1:0] t4_addrB_wire [0:NUMPOPT-1][0:T2_T1_NUMVBNK-1];
wire [T2_T1_WIDTH-1:0] t4_doutB_dl_wire [0:NUMPOPT-1][0:T2_T1_NUMVBNK-1];
wire t4_fwrdB_dl_wire [0:NUMPOPT-1][0:T2_T1_NUMVBNK-1];
wire t4_serrB_dl_wire [0:NUMPOPT-1][0:T2_T1_NUMVBNK-1];
wire t4_derrB_dl_wire [0:NUMPOPT-1][0:T2_T1_NUMVBNK-1];
wire [T2_T1_BITVROW-1:0] t4_padrB_dl_wire [0:NUMPOPT-1][0:T2_T1_NUMVBNK-1];

genvar t4r, t4b;
generate
  for (t4r=0; t4r<NUMPOPT; t4r=t4r+1) begin: t4r_loop
    for (t4b=0; t4b<T2_T1_NUMVBNK; t4b=t4b+1) begin: t4b_loop
      wire t4_writeA_dl_wire = t4_writeA_dl >> (t4r*T2_T1_NUMVBNK+t4b);
      wire [T2_T1_BITVROW-1:0] t4_addrA_dl_wire = t4_addrA_dl >> ((t4r*T2_T1_NUMVBNK+t4b)*T2_T1_BITVROW);
      wire [T2_T1_WIDTH-1:0] t4_dinA_dl_wire = t4_dinA_dl >> ((t4r*T2_T1_NUMVBNK+t4b)*T2_T2_WIDTH);
      wire t4_readB_dl_wire = t4_readB_dl >> (t4r*T2_T1_NUMVBNK+t4b);
      wire [T2_T1_BITVROW-1:0] t4_addrB_dl_wire = t4_addrB_dl >> ((t4r*T2_T1_NUMVBNK+t4b)*T2_T1_BITVROW);

      wire [NUMWRDS*T2_T1_PHYWDTH-1:0] t4_doutB_wire = t4_doutB >> ((t4r*T2_T1_NUMVBNK+t4b)*T2_T1_PHYWDTH);

      wire mem_write_t4_wire;
      wire [T2_T1_BITSROW-1:0] mem_wr_adr_t4_wire;
      wire [NUMWRDS*T2_T1_PHYWDTH-1:0] mem_bw_t4_wire;
      wire [NUMWRDS*T2_T1_PHYWDTH-1:0] mem_din_t4_wire;
      wire mem_read_t4_wire;
      wire [T2_T1_BITSROW-1:0] mem_rd_adr_t4_wire;
      wire [NUMWRDS*T2_T1_PHYWDTH-1:0] mem_rd_dout_t4_wire;
      wire mem_rd_fwrd_t4_wire;
      wire mem_rd_serr_t4_wire;
      wire mem_rd_derr_t4_wire;
      wire [(BITWBNK+T2_T1_BITSROW)-1:0] mem_rd_padr_t4_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH (WIDTH), .ENAPSDO (NUMWRDS==1), .ENAECC (0), .ENAPADR (1),
                               .NUMADDR (T2_T1_NUMVROW), .BITADDR (T2_T1_BITVROW),
                               .NUMSROW (T2_T1_NUMSROW), .BITSROW (T2_T1_BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITWBNK+T2_T1_BITSROW),
                               .SRAM_DELAY (LINK_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC))
          infra (.write(t4_writeA_dl_wire), .wr_adr(t4_addrA_dl_wire), .din(t4_dinA_dl_wire),
                 .read(t4_readB_dl_wire), .rd_adr(t4_addrB_dl_wire),
                 .rd_dout(t4_doutB_dl_wire[t4r][t4b]), .rd_fwrd(t4_fwrdB_dl_wire[t4r][t4b]),
                 .rd_serr(t4_serrB_dl_wire[t4r][t4b]), .rd_derr(t4_derrB_dl_wire[t4r][t4b]), .rd_padr(t4_padrB_dl_wire[t4r][t4b]),
                 .mem_write (mem_write_t4_wire), .mem_wr_adr(mem_wr_adr_t4_wire), .mem_bw (mem_bw_t4_wire), .mem_din (mem_din_t4_wire),
                 .mem_read (mem_read_t4_wire), .mem_rd_adr(mem_rd_adr_t4_wire), .mem_rd_dout (mem_rd_dout_t4_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_t4_wire), .mem_rd_padr(mem_rd_padr_t4_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (NUMWRDS*T2_T1_PHYWDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (T2_T1_NUMSROW), .BITADDR (T2_T1_BITSROW),
                           .NUMWROW (T2_T1_NUMSROW), .BITWROW (T2_T1_BITSROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                           .SRAM_DELAY (LINK_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
          infra (.write (mem_write_t4_wire), .wr_adr (mem_wr_adr_t4_wire), .bw (mem_bw_t4_wire), .din (mem_din_t4_wire),
                 .read (mem_read_t4_wire), .rd_adr (mem_rd_adr_t4_wire), .rd_dout (mem_rd_dout_t4_wire),
                 .rd_fwrd (mem_rd_fwrd_t4_wire), .rd_serr (mem_rd_serr_t4_wire), .rd_derr(mem_rd_derr_t4_wire), .rd_padr(mem_rd_padr_t4_wire),
                 .mem_write (t4_writeA_wire[t4r][t4b]), .mem_wr_adr(t4_addrA_wire[t4r][t4b]),
                 .mem_bw (t4_bwA_wire[t4r][t4b]), .mem_din (t4_dinA_wire[t4r][t4b]),
                 .mem_read (t4_readB_wire[t4r][t4b]), .mem_rd_adr(t4_addrB_wire[t4r][t4b]), .mem_rd_dout (t4_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_srow));
      end
    end
  end
endgenerate

reg [NUMPOPT*T2_T1_NUMVBNK-1:0] t4_writeA;
reg [NUMPOPT*T2_T1_NUMVBNK*T2_T1_BITSROW-1:0] t4_addrA;
reg [NUMPOPT*T2_T1_NUMVBNK*T2_T1_PHYWDTH-1:0] t4_bwA;
reg [NUMPOPT*T2_T1_NUMVBNK*T2_T1_PHYWDTH-1:0] t4_dinA;
reg [NUMPOPT*T2_T1_NUMVBNK-1:0] t4_readB;
reg [NUMPOPT*T2_T1_NUMVBNK*T2_T1_BITSROW-1:0] t4_addrB;
integer t4r_int, t4b_int;
always_comb begin
  t4_writeA = 0;
  t4_addrA = 0;
  t4_bwA = 0;
  t4_dinA = 0;
  t4_readB = 0;
  t4_addrB = 0;
  t4_doutB_dl = 0;
  t4_fwrdB_dl = 0;
  t4_serrB_dl = 0;
  t4_derrB_dl = 0;
  t4_padrB_dl = 0;
  for (t4r_int=0; t4r_int<NUMPOPT; t4r_int=t4r_int+1) begin
    for (t4b_int=0; t4b_int<T2_T1_NUMVBNK; t4b_int=t4b_int+1) begin
      t4_writeA = t4_writeA | (t4_writeA_wire[t4r_int][t4b_int] << (t4r_int*T2_T1_NUMVBNK+t4b_int));
      t4_addrA = t4_addrA | (t4_addrA_wire[t4r_int][t4b_int] << ((t4r_int*T2_T1_NUMVBNK+t4b_int)*T2_T1_BITSROW));
      t4_bwA = t4_bwA | (t4_bwA_wire[t4r_int][t4b_int] << ((t4r_int*T2_T1_NUMVBNK+t4b_int)*T2_T1_PHYWDTH));
      t4_dinA = t4_dinA | (t4_dinA_wire[t4r_int][t4b_int] << ((t4r_int*T2_T1_NUMVBNK+t4b_int)*T2_T1_PHYWDTH));
      t4_readB = t4_readB | (t4_readB_wire[t4r_int][t4b_int] << (t4r_int*T2_T1_NUMVBNK+t4b_int));
      t4_addrB = t4_addrB | (t4_addrB_wire[t4r_int][t4b_int] << ((t4r_int*T2_T1_NUMVBNK+t4b_int)*T2_T1_BITSROW));
      t4_doutB_dl = t4_doutB_dl | (t4_doutB_dl_wire[t4r_int][t4b_int] << ((t4r_int*T2_T1_NUMVBNK+t4b_int)*T2_T1_WIDTH));
      t4_fwrdB_dl = t4_fwrdB_dl | (t4_fwrdB_dl_wire[t4r_int][t4b_int] << (t4r_int*T2_T1_NUMVBNK+t4b_int));
      t4_serrB_dl = t4_serrB_dl | (t4_serrB_dl_wire[t4r_int][t4b_int] << (t4r_int*T2_T1_NUMVBNK+t4b_int));
      t4_derrB_dl = t4_derrB_dl | (t4_derrB_dl_wire[t4r_int][t4b_int] << (t4r_int*T2_T1_NUMVBNK+t4b_int));
      t4_padrB_dl = t4_padrB_dl | (t4_padrB_dl_wire[t4r_int][t4b_int] << ((t4r_int*T2_T1_NUMVBNK+t4b_int)*(T2_T1_BITSROW+BITWRDS)));
    end
  end
end

wire t5_writeA_wire [0:(NUMPOPT+1)-1][0:1-1];
wire [T2_T2_BITSROW-1:0] t5_addrA_wire [0:(NUMPOPT+1)-1][0:1-1];
wire [NUMWRDS*T2_T2_PHYWDTH-1:0] t5_bwA_wire [0:(NUMPOPT+1)-1][0:1-1];
wire [NUMWRDS*T2_T2_PHYWDTH-1:0] t5_dinA_wire [0:(NUMPOPT+1)-1][0:1-1];
wire t5_readB_wire [0:(NUMPOPT+1)-1][0:1-1];
wire [T2_T2_BITSROW-1:0] t5_addrB_wire [0:(NUMPOPT+1)-1][0:1-1];
wire [T2_T1_WIDTH-1:0] t5_doutB_dl_wire [0:(NUMPOPT+1)-1][0:1-1];
wire t5_fwrdB_dl_wire [0:(NUMPOPT+1)-1][0:1-1];
wire t5_serrB_dl_wire [0:(NUMPOPT+1)-1][0:1-1];
wire t5_derrB_dl_wire [0:(NUMPOPT+1)-1][0:1-1];
wire [T2_T2_BITSROW+BITWRDS-1:0] t5_padrB_dl_wire [0:(NUMPOPT+1)-1][0:1-1];

genvar t5r, t5b;
generate
  for (t5r=0; t5r<(NUMPOPT+1); t5r=t5r+1) begin: t5r_loop
    for (t5b=0; t5b<1; t5b=t5b+1) begin: t5b_loop
      wire t5_writeA_dl_wire = t5_writeA_dl >> (t5r*1+t5b);
      wire [T2_T2_BITVROW-1:0] t5_addrA_dl_wire = t5_addrA_dl >> ((t5r*1+t5b)*T2_T2_BITVROW);
      wire [T2_T2_WIDTH-1:0] t5_dinA_dl_wire = t5_dinA_dl >> ((t5r*1+t5b)*T2_T2_WIDTH);
      wire t5_readB_dl_wire = t5_readB_dl >> (t5r*1+t5b);
      wire [T2_T2_BITVROW-1:0] t5_addrB_dl_wire = t5_addrB_dl >> ((t5r*1+t5b)*T2_T2_BITVROW);

      wire [NUMWRDS*T2_T2_PHYWDTH-1:0] t5_doutB_wire = t5_doutB >> ((t5r*1+t5b)*T2_T2_PHYWDTH);

      wire mem_write_t5_wire;
      wire [T2_T2_BITSROW-1:0] mem_wr_adr_t5_wire;
      wire [NUMWRDS*T2_T2_PHYWDTH-1:0] mem_bw_t5_wire;
      wire [NUMWRDS*T2_T2_PHYWDTH-1:0] mem_din_t5_wire;
      wire mem_read_t5_wire;
      wire [T2_T2_BITSROW-1:0] mem_rd_adr_t5_wire;
      wire [NUMWRDS*T2_T2_PHYWDTH-1:0] mem_rd_dout_t5_wire;
      wire mem_rd_fwrd_t5_wire;
      wire mem_rd_serr_t5_wire;
      wire mem_rd_derr_t5_wire;
      wire [(BITWBNK+T2_T2_BITSROW)-1:0] mem_rd_padr_t5_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH (T2_T2_WIDTH), .ENAPSDO (NUMWRDS==1), .ENAECC (0), .ENAPADR (1),
                               .NUMADDR (T2_T2_NUMVROW), .BITADDR (T2_T2_BITVROW),
                               .NUMSROW (NUMSROW), .BITSROW (T2_T2_BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITWBNK+T2_T2_BITSROW),
                               .SRAM_DELAY (LINK_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.write(t5_writeA_dl_wire), .wr_adr(t5_addrA_dl_wire), .din(t5_dinA_dl_wire),
                 .read(t5_readB_dl_wire), .rd_adr(t5_addrB_dl_wire),
                 .rd_dout(t5_doutB_dl_wire[t5r][t5b]), .rd_fwrd(t5_fwrdB_dl_wire[t5r][t5b]),
                 .rd_serr(t5_serrB_dl_wire[t5r][t5b]), .rd_derr(t5_derrB_dl_wire[t5r][t5b]), .rd_padr(t5_padrB_dl_wire[t5r][t5b]),
                 .mem_write (mem_write_t5_wire), .mem_wr_adr(mem_wr_adr_t5_wire), .mem_bw (mem_bw_t5_wire), .mem_din (mem_din_t5_wire),
                 .mem_read (mem_read_t5_wire), .mem_rd_adr(mem_rd_adr_t5_wire), .mem_rd_dout (mem_rd_dout_t5_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_t5_wire), .mem_rd_padr(mem_rd_padr_t5_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (NUMWRDS*T2_T2_PHYWDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (NUMSROW), .BITADDR (T2_T2_BITSROW),
                           .NUMWROW (T2_T2_NUMSROW), .BITWROW (T2_T2_BITSROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                           .SRAM_DELAY (LINK_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1))
          infra (.write (mem_write_t5_wire), .wr_adr (mem_wr_adr_t5_wire), .bw (mem_bw_t5_wire), .din (mem_din_t5_wire),
                 .read (mem_read_t5_wire), .rd_adr (mem_rd_adr_t5_wire), .rd_dout (mem_rd_dout_t5_wire),
                 .rd_fwrd (mem_rd_fwrd_t5_wire), .rd_serr (mem_rd_serr_t5_wire), .rd_derr(mem_rd_derr_t5_wire), .rd_padr(mem_rd_padr_t5_wire),
                 .mem_write (t5_writeA_wire[t5r][t5b]), .mem_wr_adr(t5_addrA_wire[t5r][t5b]),
                 .mem_bw (t5_bwA_wire[t5r][t5b]), .mem_din (t5_dinA_wire[t5r][t5b]),
                 .mem_read (t5_readB_wire[t5r][t5b]), .mem_rd_adr(t5_addrB_wire[t5r][t5b]), .mem_rd_dout (t5_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_srow));
      end
    end
  end
endgenerate

reg [(NUMPOPT+1)-1:0] t5_writeA;
reg [(NUMPOPT+1)*T2_T2_BITSROW-1:0] t5_addrA;
reg [(NUMPOPT+1)*T2_T2_PHYWDTH-1:0] t5_bwA;
reg [(NUMPOPT+1)*T2_T2_PHYWDTH-1:0] t5_dinA;
reg [(NUMPOPT+1)-1:0] t5_readB;
reg [(NUMPOPT+1)*T2_T2_BITSROW-1:0] t5_addrB;
integer t5r_int, t5b_int;
always_comb begin
  t5_writeA = 0;
  t5_addrA = 0;
  t5_bwA = 0;
  t5_dinA = 0;
  t5_readB = 0;
  t5_addrB = 0;
  t5_doutB_dl = 0;
  t5_fwrdB_dl = 0;
  t5_serrB_dl = 0;
  t5_derrB_dl = 0;
  t5_padrB_dl = 0;
  for (t5r_int=0; t5r_int<NUMPOPT+1; t5r_int=t5r_int+1) begin
    for (t5b_int=0; t5b_int<1; t5b_int=t5b_int+1) begin
      t5_writeA = t5_writeA | (t5_writeA_wire[t5r_int][t5b_int] << (t5r_int*1+t5b_int));
      t5_addrA = t5_addrA | (t5_addrA_wire[t5r_int][t5b_int] << ((t5r_int*1+t5b_int)*T2_T2_BITSROW));
      t5_bwA = t5_bwA | (t5_bwA_wire[t5r_int][t5b_int] << ((t5r_int*1+t5b_int)*T2_T2_PHYWDTH));
      t5_dinA = t5_dinA | (t5_dinA_wire[t5r_int][t5b_int] << ((t5r_int*1+t5b_int)*T2_T2_PHYWDTH));
      t5_readB = t5_readB | (t5_readB_wire[t5r_int][t5b_int] << (t5r_int*1+t5b_int));
      t5_addrB = t5_addrB | (t5_addrB_wire[t5r_int][t5b_int] << ((t5r_int*1+t5b_int)*T2_T2_BITSROW));
      t5_doutB_dl = t5_doutB_dl | (t5_doutB_dl_wire[t5r_int][t5b_int] << ((t5r_int*1+t5b_int)*T2_T2_WIDTH));
      t5_fwrdB_dl = t5_fwrdB_dl | (t5_fwrdB_dl_wire[t5r_int][t5b_int] << (t5r_int*1+t5b_int));
      t5_serrB_dl = t5_serrB_dl | (t5_serrB_dl_wire[t5r_int][t5b_int] << (t5r_int*1+t5b_int));
      t5_derrB_dl = t5_derrB_dl | (t5_derrB_dl_wire[t5r_int][t5b_int] << (t5r_int*1+t5b_int));
      t5_padrB_dl = t5_padrB_dl | (t5_padrB_dl_wire[t5r_int][t5b_int] << ((t5r_int*1+t5b_int)*(T2_T2_BITSROW+BITWRDS)));
    end
  end
end

wire t6_writeA_wire [0:(NUMPOPT+2)-1][0:1-1];
wire [T2_T3_BITVROW-1:0] t6_addrA_wire [0:(NUMPOPT+2)-1][0:1-1];
wire [T2_T3_PHYWDTH-1:0] t6_bwA_wire [0:(NUMPOPT+2)-1][0:1-1];
wire [T2_T3_PHYWDTH-1:0] t6_dinA_wire [0:(NUMPOPT+2)-1][0:1-1];
wire t6_readB_wire [0:(NUMPOPT+2)-1][0:1-1];
wire [T2_T3_BITVROW-1:0] t6_addrB_wire [0:(NUMPOPT+2)-1][0:1-1];
wire [(T2_T1_BITVBNK+1)-1:0] t6_doutB_dl_wire [0:(NUMPOPT+2)-1][0:1-1];
wire t6_fwrdB_dl_wire [0:(NUMPOPT+2)-1][0:1-1];
wire t6_serrB_dl_wire [0:(NUMPOPT+2)-1][0:1-1];
wire t6_derrB_dl_wire [0:(NUMPOPT+2)-1][0:1-1];
wire [T2_T3_BITVROW-1:0] t6_padrB_dl_wire [0:(NUMPOPT+2)-1][0:1-1];

genvar t6r, t6b;
generate
  for (t6r=0; t6r<NUMPOPT+2; t6r=t6r+1) begin: t6r_loop
    for (t6b=0; t6b<1; t6b=t6b+1) begin: t6b_loop
      wire t6_writeA_dl_wire = t6_writeA_dl >> (t6r*1+t6b);
      wire [T2_T3_BITVROW-1:0] t6_addrA_dl_wire = t6_addrA_dl >> ((t6r*1+t6b)*T2_T3_BITVROW);
      wire [(T2_T1_BITVBNK+1)-1:0] t6_dinA_dl_wire = t6_dinA_dl >> ((t6r*1+t6b)*(T2_T1_BITVBNK+1));
      wire t6_readB_dl_wire = t6_readB_dl >> (t6r*1+t6b);
      wire [T2_T3_BITVROW-1:0] t6_addrB_dl_wire = t6_addrB_dl >> ((t6r*1+t6b)*T2_T3_BITVROW);

      wire [T2_T3_PHYWDTH-1:0] t6_doutB_wire = t6_doutB >> ((t6r*1+t6b)*T2_T3_PHYWDTH);

      wire mem_write_t6_wire;
      wire [T2_T3_BITVROW-1:0] mem_wr_adr_t6_wire;
      wire [T2_T3_PHYWDTH-1:0] mem_bw_t6_wire;
      wire [T2_T3_PHYWDTH-1:0] mem_din_t6_wire;
      wire mem_read_t6_wire;
      wire [T2_T3_BITVROW-1:0] mem_rd_adr_t6_wire;
      wire [T2_T3_PHYWDTH-1:0] mem_rd_dout_t6_wire;
      wire mem_rd_fwrd_t6_wire;
      wire mem_rd_serr_t6_wire;
      wire mem_rd_derr_t6_wire;
      wire [T2_T3_BITVROW-1:0] mem_rd_padr_t6_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w_a63 #(.WIDTH (T2_T1_BITVBNK+1), .ENAPSDO (1), .ENADEC(1), .ECCWDTH (T2_T3_PHYWDTH-2*(T2_T1_BITVBNK+1)), .ENAPADR (1),
                                   .NUMADDR (T2_T3_NUMVROW), .BITADDR (T2_T3_BITVROW),
                                   .NUMSROW (T2_T3_NUMVROW), .BITSROW (T2_T3_BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (T2_T3_BITVROW),
                                   .SRAM_DELAY (LINK_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.write(t6_writeA_dl_wire), .wr_adr(t6_addrA_dl_wire), .din(t6_dinA_dl_wire),
                 .read(t6_readB_dl_wire), .rd_adr(t6_addrB_dl_wire),
                 .rd_dout(t6_doutB_dl_wire[t6r][t6b]), .rd_fwrd(t6_fwrdB_dl_wire[t6r][t6b]),
                 .rd_serr(t6_serrB_dl_wire[t6r][t6b]), .rd_derr(t6_derrB_dl_wire[t6r][t6b]), .rd_padr(t6_padrB_dl_wire[t6r][t6b]),
                 .mem_write (mem_write_t6_wire), .mem_wr_adr(mem_wr_adr_t6_wire), .mem_bw (mem_bw_t6_wire), .mem_din (mem_din_t6_wire),
                 .mem_read (mem_read_t6_wire), .mem_rd_adr(mem_rd_adr_t6_wire), .mem_rd_dout (mem_rd_dout_t6_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_t6_wire), .mem_rd_padr(mem_rd_padr_t6_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (T2_T3_PHYWDTH), .ENAPSDO (0), .NUMADDR (T2_T3_NUMVROW), .BITADDR (T2_T3_BITVROW),
                           .NUMWROW (T2_T3_NUMVROW), .BITWROW (T2_T3_BITVROW), .NUMWBNK (1), .BITWBNK (0),
                           .SRAM_DELAY (LINK_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1))
          infra (.write (mem_write_t6_wire), .wr_adr (mem_wr_adr_t6_wire), .bw (mem_bw_t6_wire), .din (mem_din_t6_wire),
                 .read (mem_read_t6_wire), .rd_adr (mem_rd_adr_t6_wire), .rd_dout (mem_rd_dout_t6_wire),
                 .rd_fwrd (mem_rd_fwrd_t6_wire), .rd_serr (mem_rd_serr_t6_wire), .rd_derr(mem_rd_derr_t6_wire), .rd_padr(mem_rd_padr_t6_wire),
                 .mem_write (t6_writeA_wire[t6r][t6b]), .mem_wr_adr(t6_addrA_wire[t6r][t6b]),
                 .mem_bw (t6_bwA_wire[t6r][t6b]), .mem_din (t6_dinA_wire[t6r][t6b]),
                 .mem_read (t6_readB_wire[t6r][t6b]), .mem_rd_adr(t6_addrB_wire[t6r][t6b]), .mem_rd_dout (t6_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_vrow));
      end
    end
  end
endgenerate

reg [(NUMPOPT+2)-1:0] t6_writeA;
reg [(NUMPOPT+2)*T2_T3_BITVROW-1:0] t6_addrA;
reg [(NUMPOPT+2)*T2_T3_PHYWDTH-1:0] t6_bwA;
reg [(NUMPOPT+2)*T2_T3_PHYWDTH-1:0] t6_dinA;
reg [(NUMPOPT+2)-1:0] t6_readB;
reg [(NUMPOPT+2)*T2_T3_BITVROW-1:0] t6_addrB;
integer t6r_int, t6b_int;
always_comb begin
  t6_writeA = 0;
  t6_addrA = 0;
  t6_bwA = 0;
  t6_dinA = 0;
  t6_readB = 0;
  t6_addrB = 0;
  t6_doutB_dl = 0;
  t6_fwrdB_dl = 0;
  t6_serrB_dl = 0;
  t6_derrB_dl = 0;
  t6_padrB_dl = 0;
  for (t6r_int=0; t6r_int<NUMPOPT+2; t6r_int=t6r_int+1) begin
    for (t6b_int=0; t6b_int<1; t6b_int=t6b_int+1) begin
      t6_writeA = t6_writeA | (t6_writeA_wire[t6r_int][t6b_int] << (t6r_int*1+t6b_int));
      t6_addrA = t6_addrA | (t6_addrA_wire[t6r_int][t6b_int] << ((t6r_int*1+t6b_int)*T2_T3_BITVROW));
      t6_bwA = t6_bwA | (t6_bwA_wire[t6r_int][t6b_int] << ((t6r_int*1+t6b_int)*T2_T3_PHYWDTH));
      t6_dinA = t6_dinA | (t6_dinA_wire[t6r_int][t6b_int] << ((t6r_int*1+t6b_int)*T2_T3_PHYWDTH));
      t6_readB = t6_readB | (t6_readB_wire[t6r_int][t6b_int] << (t6r_int*1+t6b_int));
      t6_addrB = t6_addrB | (t6_addrB_wire[t6r_int][t6b_int] << ((t6r_int*1+t6b_int)*T2_T3_BITVROW));
      t6_doutB_dl = t6_doutB_dl | (t6_doutB_dl_wire[t6r_int][t6b_int] << ((t6r_int*1+t6b_int)*(T2_T1_BITVBNK+1)));
      t6_fwrdB_dl = t6_fwrdB_dl | (t6_fwrdB_dl_wire[t6r_int][t6b_int] << (t6r_int*1+t6b_int));
      t6_serrB_dl = t6_serrB_dl | (t6_serrB_dl_wire[t6r_int][t6b_int] << (t6r_int*1+t6b_int));
      t6_derrB_dl = t6_derrB_dl | (t6_derrB_dl_wire[t6r_int][t6b_int] << (t6r_int*1+t6b_int));
      t6_padrB_dl = t6_padrB_dl | (t6_padrB_dl_wire[t6r_int][t6b_int] << ((t6r_int*1+t6b_int)*(T2_T3_BITSROW+BITWRDS)));
    end
  end
end


reg  [NUMPUPT*BITQPTR-1:0]     t12_doutB_a2_tmp;
reg  [NUMPUPT*BITQPTR-1:0]     t12_doutB_a2;


generate if (FLOPMEM) begin: t7_flp_loop
  reg [NUMPOPT*BITPING-1:0] t7_doutB_reg;
  reg [NUMPUPT*BITPING-1:0] t8_doutB_reg;
  reg [(NUMPOPT+NUMPUPT)*BITQCNT-1:0] t9_doutB_reg;
  reg [(NUMPOPT+NUMPUPT)*NUMPING*(BITQPTR+BITMDAT)-1:0] t10_doutB_reg;
  reg [NUMPUPT*NUMPING*BITQPTR-1:0] t11_doutB_reg;
  reg [NUMPUPT*T8_WIDTH-1:0] t12_doutB_reg;
  always @(posedge clk) begin
    t7_doutB_reg <= t7_doutB;
    t8_doutB_reg <= t8_doutB;
    t9_doutB_reg <= t9_doutB;
    t10_doutB_reg <= t10_doutB;
    t11_doutB_reg <= t11_doutB;
    t12_doutB_reg <= t12_doutB_a2_tmp;
  end

  assign t7_doutB_a1 = t7_doutB_reg;
  assign t8_doutB_a1 = t8_doutB_reg;
  assign t9_doutB_a1 = t9_doutB_reg;
  assign t10_doutB_a1 = t10_doutB_reg;
  assign t11_doutB_a1 = t11_doutB_reg;
  assign t12_doutB_a2 = t12_doutB_reg;
end else begin: t7_noflp_loop
  assign t7_doutB_a1 = t7_doutB;
  assign t8_doutB_a1 = t8_doutB;
  assign t9_doutB_a1 = t9_doutB;
  assign t10_doutB_a1 = t10_doutB;
  assign t11_doutB_a1 = t11_doutB;
  assign t12_doutB_a2 = t12_doutB_a2_tmp;
end
endgenerate

wire [NUMPUPT-1:0]                     t12_writeA_a2;
wire [NUMPUPT*(BITQPTR-1)-1:0]             t12_addrA_a2;
wire [NUMPUPT*BITQPTR-1:0]             t12_dinA_a2;
wire [NUMPUPT-1:0]                     t12_readB_a2;
wire [NUMPUPT*(BITQPTR-1)-1:0]             t12_addrB_a2;

  generate if(1) begin: a2_loop
    algo_mrnw_fque_doppler #(.NUMPORT(2), .BITPORT(1), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .BITQPTR(BITQPTR),
                     .NUMVROW(NUMADDR/2), .BITVROW(BITADDR-1),
                     .QPTR_DELAY(LINK_DELAY+FLOPECC), .FLOPIN(FLOPIN), .FLOPOUT(FLOPOUT), .BITCPAD(BITADDR), .CPUWDTH(BITADDR+BITQCNT-2))
            algo_fl (
                     .push({1'b0,qm2fl_push}),
                     .pu_ptr({{BITQPTR{1'b0}},qm2fl_ptr}),
                     .pop(push),
                     .po_pvld(fl2qm_push),
                     .po_ptr(fl2qm_ptr),
                     .cp_read(1'b0),
                     .cp_write(1'b0),
                     .cp_adr({BITADDR{1'b0}}),
                     .cp_din({2*(BITADDR-1)+1{1'b0}}),
                     .cp_vld(),
                     .cp_dout(),
                     .t1_writeA(t12_writeA_a2),
                     .t1_addrA(t12_addrA_a2),
                     .t1_dinA(t12_dinA_a2),
                     .t1_readB(t12_readB_a2),
                     .t1_addrB(t12_addrB_a2),
                     .t1_doutB(t12_doutB_a2_tmp),
                     .freecnt(freecnt),
                     .clk(clk),
                     .rst(rst),
                     .ready(fl_ready));

  end
endgenerate

wire t12_writeA_wire [0:NUMPUPT-1];
wire [BITADDR-2:0] t12_addrA_wire [0:NUMPUPT-1];
wire [T8_WIDTH-1:0] t12_bwA_wire [0:NUMPUPT-1];
wire [T8_WIDTH-1:0] t12_dinA_wire [0:NUMPUPT-1];
wire t12_readB_wire [0:NUMPUPT-1];
wire [BITADDR-2:0] t12_addrB_wire [0:NUMPUPT-1];
wire t12_fwrdB_a2_wire [0:NUMPUPT-1];
wire t12_serrB_a2_wire [0:NUMPUPT-1];
wire t12_derrB_a2_wire [0:NUMPUPT-1];
wire [BITADDR-2:0] t12_padrB_a2_wire [0:NUMPUPT-1];
wire [BITQPTR-1:0] t12_doutB_a2_wire [0:NUMPUPT-1] ;

genvar t12r;
generate
  for (t12r=0; t12r<NUMPUPT; t12r=t12r+1) begin: t12r_loop
    wire t12_writeA_a2_wire = t12_writeA_a2 >> (t12r);
    wire [BITADDR-2:0] t12_addrA_a2_wire = t12_addrA_a2 >> (t12r*(BITADDR-1));
    wire [BITQPTR-1:0] t12_dinA_a2_wire = t12_dinA_a2 >> (t12r*(BITQPTR));
    wire t12_readB_a2_wire = t12_readB_a2 >> (t12r);
    wire [BITADDR-2:0] t12_addrB_a2_wire = t12_addrB_a2 >> (t12r*(BITADDR-1));

    wire [T8_WIDTH-1:0] t12_doutB_wire = t12_doutB >> (t12r*T8_WIDTH);

    wire t12_mem_write_wire;
    wire [BITADDR-2:0] t12_mem_wr_adr_wire;
    wire [T8_WIDTH-1:0] t12_mem_bw_wire;
    wire [T8_WIDTH-1:0] t12_mem_din_wire;
    wire t12_mem_read_wire;
    wire [BITADDR-2:0] t12_mem_rd_adr_wire;
    wire [T8_WIDTH-1:0] t12_mem_rd_dout_wire;
    wire t12_mem_rd_fwrd_wire;
    wire t12_mem_rd_serr_wire;
    wire t12_mem_rd_derr_wire;
    wire [BITADDR-2:0] t12_mem_rd_padr_wire;

   if (1) begin: align_loop
      infra_align_ecc_1r1w #(.WIDTH (BITQPTR), .ENAPSDO (NUMWRDS==1), .ENAECC (0), .ECCWDTH (T8_WIDTH-BITQPTR), .ENAPADR (0),
                             .NUMADDR (NUMADDR/2), .BITADDR (BITADDR-1),
                             .NUMSROW (NUMADDR/2), .BITSROW (BITADDR-1), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITADDR-1),
                             .SRAM_DELAY (LINK_DELAY), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC))
        infra (.write(t12_writeA_a2_wire), .wr_adr(t12_addrA_a2_wire), .din(t12_dinA_a2_wire),
               .read(t12_readB_a2_wire), .rd_adr(t12_addrB_a2_wire),
               .rd_dout(t12_doutB_a2_wire[t12r]), .rd_fwrd(t12_fwrdB_a2_wire[t12r]),
               .rd_serr(t12_serrB_a2_wire[t12r]), .rd_derr(t12_derrB_a2_wire[t12r]), .rd_padr(t12_padrB_a2_wire[t12r]),
               .mem_write (t12_mem_write_wire), .mem_wr_adr(t12_mem_wr_adr_wire), .mem_bw (t12_mem_bw_wire), .mem_din (t12_mem_din_wire),
               .mem_read (t12_mem_read_wire), .mem_rd_adr(t12_mem_rd_adr_wire), .mem_rd_dout (t12_mem_rd_dout_wire),
               .mem_rd_fwrd(t12_mem_rd_fwrd_wire), .mem_rd_padr(t12_mem_rd_padr_wire),
               .clk (clk), .rst (rst),
               .select_addr ({BITADDR-1{1'b0}}));
    end

    if (1) begin: stack_loop
      infra_stack_1r1w #(.WIDTH (T8_WIDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (NUMADDR/2), .BITADDR (BITADDR-1),
                         .NUMWROW (NUMADDR/2), .BITWROW (BITADDR-1), .NUMWBNK (1), .BITWBNK (0),
                         .SRAM_DELAY (LINK_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
        infra (.write (t12_mem_write_wire), .wr_adr (t12_mem_wr_adr_wire), .bw (t12_mem_bw_wire), .din (t12_mem_din_wire),
               .read (t12_mem_read_wire), .rd_adr (t12_mem_rd_adr_wire), .rd_dout (t12_mem_rd_dout_wire),
               .rd_fwrd (t12_mem_rd_fwrd_wire), .rd_serr (t12_mem_rd_serr_wire), .rd_derr(t12_mem_rd_derr_wire), .rd_padr(t12_mem_rd_padr_wire),
               .mem_write (t12_writeA_wire[t12r]), .mem_wr_adr(t12_addrA_wire[t12r]),
               .mem_bw (t12_bwA_wire[t12r]), .mem_din (t12_dinA_wire[t12r]),
               .mem_read (t12_readB_wire[t12r]), .mem_rd_adr(t12_addrB_wire[t12r]), .mem_rd_dout (t12_doutB_wire),
               .clk (clk), .rst(rst),
               .select_addr ({BITADDR-1{1'b0}}));
    end
  end
endgenerate

reg [NUMPUPT-1:0] t12_writeA;
reg [NUMPUPT*(BITADDR-1)-1:0] t12_addrA;
reg [NUMPUPT*T8_WIDTH-1:0] t12_bwA;
reg [NUMPUPT*T8_WIDTH-1:0] t12_dinA;
reg [NUMPUPT-1:0] t12_readB;
reg [NUMPUPT*(BITADDR-1)-1:0] t12_addrB;
integer t12r_int;
always_comb begin
  t12_writeA = 0;
  t12_addrA = 0;
  t12_bwA = 0;
  t12_dinA = 0;
  t12_readB = 0;
  t12_addrB = 0;
  t12_doutB_a2_tmp = 0;
  for (t12r_int=0; t12r_int<NUMPUPT; t12r_int=t12r_int+1) begin
    t12_writeA = t12_writeA | (t12_writeA_wire[t12r_int] << (t12r_int));
    t12_addrA = t12_addrA | (t12_addrA_wire[t12r_int] << (t12r_int*(BITADDR-1)));
    t12_bwA = t12_bwA | (t12_bwA_wire[t12r_int] << (t12r_int*BITQPTR));
    t12_dinA = t12_dinA | (t12_dinA_wire[t12r_int] << (t12r_int*T8_WIDTH));
    t12_readB = t12_readB | (t12_readB_wire[t12r_int] << (t12r_int));
    t12_addrB = t12_addrB | (t12_addrB_wire[t12r_int] << (t12r_int*(BITADDR-1)));
    t12_doutB_a2_tmp = t12_doutB_a2_tmp | (t12_doutB_a2_wire[t12r_int] << (t12r_int*BITQPTR));
  end
end

`ifdef FORMAL
localparam FIFOCNT = NUMADDR;
localparam BITFIFO = BITADDR;
localparam QPOP_DELAY = QPTR_DELAY+DATA_DELAY;
wire pop_wire [0:NUMPOPT-1];
wire [BITQPRT-1:0] po_prt_wire [0:NUMPOPT-1];
wire [NUMMDAT*BITMDAT-1:0] po_pre_wire [0:NUMPOPT-1];
wire [BITQPTR-1:0] po_ptr_wire [0:NUMPOPT-1];
wire push_wire [0:NUMPUPT-1];
wire [BITQPRT-1:0] pu_prt_wire [0:NUMPUPT-1];
wire [BITQPTR-1:0] pu_ptr_wire [0:NUMPUPT-1];
wire [BITMDAT-1:0] pu_pre_wire [0:NUMPUPT-1];
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
    assign pu_pre_wire[pr_var] = pu_metadata >> (pr_var*BITMDAT);
    assign free_head_tmp[pr_var] = pu_ptr_reg[pr_var][QPTR_DELAY-1]; 
  end
  for(pr_var=0;pr_var < NUMPOPT; pr_var = pr_var+1) begin
    assign pop_wire[pr_var] = (pop && {NUMPOPT{ready}}) >> pr_var;
    assign po_prt_wire[pr_var] = po_prt >> pr_var;
    assign po_pre_wire[pr_var] = po_metadata >> (pr_var *(NUMMDAT*BITMDAT));
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
assign pop_qhead  = a1_loop.algo_qm.core.vpo_ptr_wire[0];

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
    rfffcnt <= rfffcnt + ((push_wire[0] && (pu_prt_wire[0]==select_qprt)) + (push_wire[1] && (pu_prt_wire[1]==select_qprt))) - (pop_wire[0] && (po_prt_wire[0]==select_qprt));

wire rfff_deq = pop_wire[0] && (po_prt_wire[0]==select_qprt) && ready;

reg [WIDTH-1:0]   datrfff [0:FIFOCNT-1];
reg [BITMDAT-1:0] prerfff [0:FIFOCNT-1];
reg [WIDTH-1:0]   datrfff_nxt [0:FIFOCNT-1];
reg [BITMDAT-1:0] prerfff_nxt [0:FIFOCNT-1];
integer rfff_int,rffp_int;
always_comb begin
  for (rfff_int=0; rfff_int<FIFOCNT; rfff_int=rfff_int+1) begin
    datrfff_nxt[rfff_int] = datrfff[rfff_int];
    prerfff_nxt[rfff_int] = prerfff[rfff_int];
    if (rfff_int<(rfffcnt-rfff_deq)) begin
      datrfff_nxt[rfff_int] = datrfff[rfff_int+rfff_deq];
      prerfff_nxt[rfff_int] = prerfff[rfff_int+rfff_deq];
    end
    for(rffp_int=0; rffp_int<NUMPUPT; rffp_int=rffp_int+1)
      if ((rfff_int==(rfffcnt-rfff_deq)) && push_wire[rffp_int] && (pu_prt_wire[rffp_int]==select_qprt) && ready) begin
        datrfff_nxt[rfff_int] = pu_din_wire[rffp_int];
        prerfff_nxt[rfff_int] = pu_pre_wire[rffp_int];
      end
    end
  end

integer rffd_int;
always @(posedge clk)
  for (rffd_int=0; rffd_int<FIFOCNT; rffd_int=rffd_int+1) begin
    datrfff[rffd_int] <= datrfff_nxt[rffd_int];
    prerfff[rffd_int] <= prerfff_nxt[rffd_int];
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

genvar mdt_var;
generate if (QPTR_DELAY>0) begin: pre_loop
  for(mdt_var=0;mdt_var<NUMMDAT;mdt_var=mdt_var+1) begin :nummdat_loop
    assert_rff_pre_check: assert property (@(posedge clk) disable iff (rst || !ready) (pop && (po_prt==select_qprt) && (mdt_var<rfffcnt)) |-> ##QPTR_DELAY qm2fl_push && (po_pre_wire[0][(mdt_var+1)*BITMDAT-1:mdt_var*BITMDAT]== $past(prerfff[mdt_var],QPTR_DELAY)));
  end
end else begin: npre_loop
  for(mdt_var=0;mdt_var<NUMMDAT;mdt_var=mdt_var+1) begin :nummdat_loop
    assert_rff_pre_check: assert property (@(posedge clk) disable iff (rst || !ready) (pop && (po_prt==select_qprt) && (mdt_var<rfffcnt)) |-> qm2fl_push&& (po_pre_wire[0][(mdt_var+1)*BITMDAT-1:mdt_var*BITMDAT]==prerfff[mdt_var]));
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
