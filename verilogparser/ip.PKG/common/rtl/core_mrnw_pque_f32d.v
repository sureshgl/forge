module core_mrnw_pque_f32 (vpop, vpo_ndq, vpo_prt, vpo_cvld, vpo_cnt, vpo_cmt, vpo_pvld, vpo_ptr, vpo_dvld, vpo_dout,
                           vpush, vpu_prt, vpu_ptr, vpu_din, vpu_cvld, vpu_cnt,
                           vcpread, vcpwrite, vcpaddr, vcpdin, vcpread_vld, vcpread_dout,
                           t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
                           t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
                           t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
                           t4_writeA, t4_addrA, t4_dinA, t4_readB, t4_addrB, t4_doutB,
                           t5_writeA, t5_addrA, t5_dinA, t5_readB, t5_addrB, t5_doutB,
                           t6_writeA, t6_addrA, t6_dinA, t6_readB, t6_addrB, t6_doutB,
                           t7_writeA, t7_addrA, t7_dinA, t7_readB, t7_addrB, t7_doutB,
                           ready, clk, rst);
  
  parameter WIDTH = 32;
  parameter NUMPUPT = 1;
  parameter NUMPOPT = 1;
  parameter NUMQPRT = 64;
  parameter BITQPRT = 6;
  parameter NUMPING = 2;
  parameter BITPING = 1;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter BITPADR = 15;
  parameter BITQPTR = BITADDR;
  parameter BITQCNT = BITADDR+1;
  
  parameter QPTR_DELAY = 2;
  parameter LINK_DELAY = 2;
  parameter DATA_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter BITCPAD = BITQPRT;
  parameter CPUWDTH = 2*BITPING+BITQCNT+2*NUMPING*BITQPTR;

  input [NUMPOPT-1:0]            vpop;
  input [NUMPOPT-1:0]            vpo_ndq;
  input [NUMPOPT*BITQPRT-1:0]    vpo_prt;
  output [NUMPOPT-1:0]           vpo_cvld;
  output [NUMPOPT-1:0]           vpo_cmt;
  output [NUMPOPT*BITQCNT-1:0]   vpo_cnt;
  output [NUMPOPT-1:0]           vpo_pvld;
  output [NUMPOPT*BITQPTR-1:0]   vpo_ptr;
  output [NUMPOPT-1:0]           vpo_dvld;
  output [NUMPOPT*WIDTH-1:0]     vpo_dout;

  input [NUMPUPT-1:0]            vpush;
  input [NUMPUPT*BITQPRT-1:0]    vpu_prt;
  input [NUMPUPT*BITQPTR-1:0]    vpu_ptr;
  input [NUMPUPT*WIDTH-1:0]      vpu_din;
  output [NUMPUPT-1:0]           vpu_cvld;
  output [NUMPUPT*BITQCNT-1:0]   vpu_cnt;

  input                          vcpread;
  input                          vcpwrite;
  input [BITCPAD-1:0]            vcpaddr;
  input [CPUWDTH-1:0]            vcpdin;
  output                         vcpread_vld;
  output [CPUWDTH-1:0]           vcpread_dout;

  output [NUMPUPT-1:0]                     t1_writeA;
  output [NUMPUPT*BITADDR-1:0]             t1_addrA;
  output [NUMPUPT*BITQPTR-1:0]             t1_dinA;
  output [NUMPOPT-1:0]                     t1_readB;
  output [NUMPOPT*BITADDR-1:0]             t1_addrB;
  input [NUMPOPT*BITQPTR-1:0]              t1_doutB;

  output [NUMPUPT-1:0]                     t2_writeA;
  output [NUMPUPT*BITADDR-1:0]             t2_addrA;
  output [NUMPUPT*WIDTH-1:0]               t2_dinA;
  output [NUMPOPT-1:0]                     t2_readB;
  output [NUMPOPT*BITADDR-1:0]             t2_addrB;
  input [NUMPOPT*WIDTH-1:0]                t2_doutB;

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

  output                         ready;
  input                          clk;
  input                          rst;

  reg [BITQPRT:0] rstaddr;
  wire rstvld = rstaddr < NUMQPRT;
  always @(posedge clk)
    if (rst)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;

  reg [BITQPRT:0] rstaddr_reg[0:QPTR_DELAY];
  reg [QPTR_DELAY:0] rstvld_reg;
  int rst_int;
  always @(posedge clk)
    if (rst) begin
      rstvld_reg <= 0;
      for (rst_int = 0; rst_int <QPTR_DELAY+1; rst_int=rst_int+1)
        rstaddr_reg[rst_int] <= 0;
    end else begin
      rstvld_reg <= {rstvld_reg[QPTR_DELAY-1:0], rstvld};
      rstaddr_reg[0] <= rstaddr;
      for (rst_int = 1; rst_int <QPTR_DELAY+1; rst_int=rst_int+1)
        rstaddr_reg[rst_int] <= rstaddr_reg[rst_int-1];
    end

  reg ready;
  always @(posedge clk)
    ready <= !rstvld && !(|rstvld_reg);

  wire               ready_wire;
  wire               vpush_wire [0:NUMPUPT-1];
  wire [BITQPRT-1:0] vpuprt_wire [0:NUMPUPT-1];
  wire [BITQPTR-1:0] vpuptr_wire [0:NUMPUPT-1];
  wire [WIDTH-1:0]   vpudin_wire [0:NUMPUPT-1];

  wire               vpop_wire [0:NUMPOPT-1];
  wire               vpondq_wire [0:NUMPOPT-1];
  wire [BITQPRT-1:0] vpoprt_wire [0:NUMPOPT-1];

  wire               vcpread_wire;
  wire               vcpwrite_wire;
  wire [BITCPAD-1:0] vcpaddr_wire;
  wire [CPUWDTH-1:0] vcpdin_wire;

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg [NUMPUPT-1:0] vpush_reg;
    reg [NUMPUPT*BITQPRT-1:0] vpuprt_reg;
    reg [NUMPUPT*BITQPTR-1:0] vpuptr_reg;
    reg [NUMPUPT*WIDTH-1:0] vpudin_reg;
    reg [NUMPOPT-1:0] vpop_reg;
    reg [NUMPOPT-1:0] vpondq_reg;
    reg [NUMPOPT*BITQPRT-1:0] vpoprt_reg;
    reg vcpread_reg;
    reg vcpwrite_reg;
    reg [BITCPAD-1:0] vcpaddr_reg;
    reg [CPUWDTH-1:0] vcpdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vpush_reg <= vpush & {NUMPUPT{ready}};
      vpuprt_reg <= vpu_prt;
      vpuptr_reg <= vpu_ptr;
      vpudin_reg <= vpu_din;
      vpop_reg <= vpop & {NUMPOPT{ready}};
      vpondq_reg <= vpo_ndq;
      vpoprt_reg <= vpo_prt;
      vcpread_reg <= vcpread;
      vcpwrite_reg <= vcpwrite;
      vcpaddr_reg <= vcpaddr;
      vcpdin_reg <= vcpdin;
    end

    assign ready_wire = ready_reg;
    for (np2_var=0; np2_var<NUMPUPT; np2_var=np2_var+1) begin: pu_loop
      assign vpush_wire[np2_var] = vpush_reg >> np2_var;
      assign vpuprt_wire[np2_var] = vpuprt_reg >> (np2_var*BITQPRT);
      assign vpuptr_wire[np2_var] = vpuptr_reg >> (np2_var*BITQPTR);
      assign vpudin_wire[np2_var] = vpudin_reg >> (np2_var*WIDTH);
    end
    for (np2_var=0; np2_var<NUMPOPT; np2_var=np2_var+1) begin: po_loop
      assign vpop_wire[np2_var] = vpop_reg >> np2_var;
      assign vpondq_wire[np2_var] = vpondq_reg >> np2_var;
      assign vpoprt_wire[np2_var] = vpoprt_reg >> (np2_var*BITQPRT);
    end
    assign vcpread_wire = vcpread_reg;
    assign vcpwrite_wire = vcpwrite_reg;
    assign vcpaddr_wire = vcpaddr_reg;
    assign vcpdin_wire = vcpdin_reg;
  end else begin: noflpi_loop
    assign ready_wire = ready; 
    for (np2_var=0; np2_var<NUMPUPT; np2_var=np2_var+1) begin: pu_loop
      assign vpush_wire[np2_var] = (vpush & {NUMPUPT{ready}}) >> np2_var;
      assign vpuprt_wire[np2_var] = vpu_prt >> (np2_var*BITQPRT);
      assign vpuptr_wire[np2_var] = vpu_ptr >> (np2_var*BITQPTR);
      assign vpudin_wire[np2_var] = vpu_din >> (np2_var*WIDTH);
    end
    for (np2_var=0; np2_var<NUMPOPT; np2_var=np2_var+1) begin: po_loop
      assign vpop_wire[np2_var] = (vpop & {NUMPOPT{ready}}) >> np2_var;
      assign vpondq_wire[np2_var] = vpo_ndq >> np2_var;
      assign vpoprt_wire[np2_var] = vpo_prt >> (np2_var*BITQPRT);
    end
    assign vcpread_wire = vcpread;
    assign vcpwrite_wire = vcpwrite;
    assign vcpaddr_wire = vcpaddr;
    assign vcpdin_wire = vcpdin;
  end
  endgenerate

  reg [BITPING-1:0] optr_out [0:NUMPOPT-1];
  reg [BITPING-1:0] uptr_out [0:NUMPUPT-1];
  reg [BITQCNT-1:0] cnt_out  [0:NUMPOPT+NUMPUPT-1];
  reg [NUMPING*BITQPTR-1:0] head_out [0:NUMPOPT+NUMPUPT-1];
  reg [NUMPING*BITQPTR-1:0] tail_out [0:NUMPUPT-1];
  reg [BITQPTR-1:0] hptr_out [0:NUMPOPT+NUMPUPT-1][0:NUMPING-1];
  reg [BITQPTR-1:0] tptr_out [0:NUMPUPT-1][0:NUMPING-1];
  reg [NUMPING*BITQPTR-1:0] hdeq_out [0:NUMPOPT-1];

  reg                vpush_reg [0:NUMPUPT-1][0:QPTR_DELAY+LINK_DELAY-1];
  reg [BITQPRT-1:0]  vpuprt_reg [0:NUMPUPT-1][0:QPTR_DELAY+LINK_DELAY-1];
  reg [BITQPTR-1:0]  vpuptr_reg [0:NUMPUPT-1][0:QPTR_DELAY+LINK_DELAY-1];
  reg [WIDTH-1:0]    vpudin_reg [0:NUMPUPT-1][0:QPTR_DELAY+LINK_DELAY-1];
  reg                vpop_reg [0:NUMPOPT-1][0:QPTR_DELAY+LINK_DELAY-1];
  reg                vpondq_reg [0:NUMPOPT-1][0:QPTR_DELAY+LINK_DELAY-1];
  reg [BITQPRT-1:0]  vpoprt_reg [0:NUMPOPT-1][0:QPTR_DELAY+LINK_DELAY-1];
  reg                vdeq_reg [0:NUMPOPT-1][0:QPTR_DELAY+LINK_DELAY-1];
  reg                vcpread_reg [0:QPTR_DELAY-1];
  reg [BITCPAD-1:0]  vcpaddr_reg [0:QPTR_DELAY-1];
  reg [BITQCNT-1:0]  voct_nxt [0:NUMPOPT-1];
  reg [BITQCNT-1:0]  voct_reg [0:NUMPOPT-1][0:QPTR_DELAY+LINK_DELAY-1];
  reg [BITQCNT-1:0]  vuct_nxt [0:NUMPUPT-1];
  reg [BITQCNT-1:0]  vuct_reg [0:NUMPUPT-1][0:QPTR_DELAY+LINK_DELAY-1];
  reg [BITQCNT-1:0]  vcnt_nxt [0:NUMPOPT+NUMPUPT-1];
  reg [BITQCNT-1:0]  vcnt_reg [0:NUMPOPT+NUMPUPT-1][0:QPTR_DELAY+LINK_DELAY-1];
  reg [BITQCNT-1:0]  vqct_nxt [0:NUMPOPT+NUMPUPT-1];
  reg [BITQCNT-1:0]  vqct_reg [0:NUMPOPT+NUMPUPT-1][0:QPTR_DELAY+LINK_DELAY-1];
  reg [BITQCNT-1:0]  vpct_nxt [0:NUMPOPT+NUMPUPT-1];
  reg [BITQCNT-1:0]  vpct_reg [0:NUMPOPT+NUMPUPT-1][0:QPTR_DELAY+LINK_DELAY-1];
  integer vprt_int, vdel_int; 
  always @(posedge clk)
    for (vdel_int=0; vdel_int<QPTR_DELAY+LINK_DELAY; vdel_int=vdel_int+1)
      if (vdel_int > 0) begin
        for (vprt_int=0; vprt_int<NUMPOPT; vprt_int=vprt_int+1) begin
          vpop_reg[vprt_int][vdel_int] <= vpop_reg[vprt_int][vdel_int-1];
          vpondq_reg[vprt_int][vdel_int] <= vpondq_reg[vprt_int][vdel_int-1];
          vpoprt_reg[vprt_int][vdel_int] <= vpoprt_reg[vprt_int][vdel_int-1];
          if (vdel_int==QPTR_DELAY) begin
            vdeq_reg[vprt_int][vdel_int] <= vpop_reg[vprt_int][vdel_int-1] && !vpondq_reg[vprt_int][vdel_int-1] && (cnt_out[vprt_int]>NUMPING);
          end else begin
            vdeq_reg[vprt_int][vdel_int] <= vdeq_reg[vprt_int][vdel_int-1];
          end
          voct_reg[vprt_int][vdel_int] <= voct_reg[vprt_int][vdel_int-1];
          vcnt_reg[vprt_int][vdel_int] <= vcnt_reg[vprt_int][vdel_int-1];
          vqct_reg[vprt_int][vdel_int] <= vqct_reg[vprt_int][vdel_int-1];
          vpct_reg[vprt_int][vdel_int] <= vpct_reg[vprt_int][vdel_int-1];
        end
        for (vprt_int=0; vprt_int<NUMPUPT; vprt_int=vprt_int+1) begin
          vpush_reg[vprt_int][vdel_int] <= vpush_reg[vprt_int][vdel_int-1];
          vpuprt_reg[vprt_int][vdel_int] <= vpuprt_reg[vprt_int][vdel_int-1];
          vpuptr_reg[vprt_int][vdel_int] <= vpuptr_reg[vprt_int][vdel_int-1];
          vpudin_reg[vprt_int][vdel_int] <= vpudin_reg[vprt_int][vdel_int-1];
          vuct_reg[vprt_int][vdel_int] <= vuct_reg[vprt_int][vdel_int-1];
          vcnt_reg[vprt_int+NUMPOPT][vdel_int] <= vcnt_reg[vprt_int+NUMPOPT][vdel_int-1];
          vqct_reg[vprt_int+NUMPOPT][vdel_int] <= vqct_reg[vprt_int+NUMPOPT][vdel_int-1];
          vpct_reg[vprt_int+NUMPOPT][vdel_int] <= vpct_reg[vprt_int+NUMPOPT][vdel_int-1];
        end
        if (vdel_int<QPTR_DELAY) begin
          vcpread_reg[vdel_int] <= vcpread_reg[vdel_int-1];
          vcpaddr_reg[vdel_int] <= vcpaddr_reg[vdel_int-1];
        end
      end else begin
        for (vprt_int=0; vprt_int<NUMPOPT; vprt_int=vprt_int+1) begin
          vpop_reg[vprt_int][vdel_int] <= vpop_wire[vprt_int];
          vpondq_reg[vprt_int][vdel_int] <= vpondq_wire[vprt_int];
          vpoprt_reg[vprt_int][vdel_int] <= vpoprt_wire[vprt_int];
          voct_reg[vprt_int][vdel_int] <= voct_nxt[vprt_int];
          vcnt_reg[vprt_int][vdel_int] <= vcnt_nxt[vprt_int];
          vqct_reg[vprt_int][vdel_int] <= vqct_nxt[vprt_int];
          vpct_reg[vprt_int][vdel_int] <= vpct_nxt[vprt_int];
        end
        for (vprt_int=0; vprt_int<NUMPUPT; vprt_int=vprt_int+1) begin
          vpush_reg[vprt_int][vdel_int] <= vpush_wire[vprt_int];
          vpuprt_reg[vprt_int][vdel_int] <= vpuprt_wire[vprt_int];
          vpuptr_reg[vprt_int][vdel_int] <= vpuptr_wire[vprt_int];
          vpudin_reg[vprt_int][vdel_int] <= vpudin_wire[vprt_int];
          vuct_reg[vprt_int][vdel_int] <= vuct_nxt[vprt_int];
          vcnt_reg[vprt_int+NUMPOPT][vdel_int] <= vcnt_nxt[vprt_int+NUMPOPT];
          vqct_reg[vprt_int+NUMPOPT][vdel_int] <= vqct_nxt[vprt_int+NUMPOPT];
          vpct_reg[vprt_int+NUMPOPT][vdel_int] <= vpct_nxt[vprt_int+NUMPOPT];
        end
        vcpread_reg[vdel_int] <= vcpread_wire;
        vcpaddr_reg[vdel_int] <= vcpaddr_wire;
      end

  integer vcnt_int, vcpt_int;
  always_comb begin
    for (vcnt_int=0; vcnt_int<NUMPOPT+NUMPUPT; vcnt_int=vcnt_int+1) begin 
      vcnt_nxt[vcnt_int] = 0;
      vqct_nxt[vcnt_int] = 0;
      vpct_nxt[vcnt_int] = 0;
    end
    for (vcnt_int=0; vcnt_int<NUMPOPT; vcnt_int=vcnt_int+1) begin
      voct_nxt[vcnt_int] = 0;
      if (vpop_wire[vcnt_int]) begin
        for (vcpt_int=0; vcpt_int<vcnt_int; vcpt_int=vcpt_int+1)
          if (vpop_wire[vcpt_int] && !vpondq_wire[vcpt_int] && (vpoprt_wire[vcnt_int]==vpoprt_wire[vcpt_int]))
            voct_nxt[vcnt_int] = voct_nxt[vcnt_int] + 1; 
        for (vcpt_int=0; vcpt_int<=vcnt_int; vcpt_int=vcpt_int+1)
          if (vpop_wire[vcpt_int] && !vpondq_wire[vcpt_int] && (vpoprt_wire[vcnt_int]==vpoprt_wire[vcpt_int]))
            vcnt_nxt[vcnt_int] = vcnt_nxt[vcnt_int] - 1; 
        for (vcpt_int=0; vcpt_int<NUMPOPT; vcpt_int=vcpt_int+1)
          if (vpop_wire[vcpt_int] && !vpondq_wire[vcpt_int] && (vpoprt_wire[vcnt_int]==vpoprt_wire[vcpt_int]))
            vqct_nxt[vcnt_int] = vqct_nxt[vcnt_int] - 1; 
        for (vcpt_int=0; vcpt_int<NUMPUPT; vcpt_int=vcpt_int+1)
          if (vpush_wire[vcpt_int] && (vpoprt_wire[vcnt_int]==vpuprt_wire[vcpt_int]))
            vqct_nxt[vcnt_int] = vqct_nxt[vcnt_int] + 1; 
        for (vcpt_int=0; vcpt_int<NUMPOPT; vcpt_int=vcpt_int+1)
          if (vpop_wire[vcpt_int] && !vpondq_wire[vcpt_int] && (vpoprt_wire[vcnt_int]==vpoprt_wire[vcpt_int]))
            vpct_nxt[vcnt_int] = vpct_nxt[vcnt_int] + 1; 
      end
    end
    for (vcnt_int=0; vcnt_int<NUMPUPT; vcnt_int=vcnt_int+1) begin
      vuct_nxt[vcnt_int] = 0;
      if (vpush_wire[vcnt_int]) begin
        for (vcpt_int=0; vcpt_int<vcnt_int; vcpt_int=vcpt_int+1)
          if (vpush_wire[vcpt_int] && (vpuprt_wire[vcnt_int]==vpuprt_wire[vcpt_int]))
            vuct_nxt[vcnt_int] = vuct_nxt[vcnt_int] + 1; 
        for (vcpt_int=0; vcpt_int<NUMPOPT; vcpt_int=vcpt_int+1)
          if (vpop_wire[vcpt_int] && !vpondq_wire[vcpt_int] && (vpuprt_wire[vcnt_int]==vpoprt_wire[vcpt_int]))
            vcnt_nxt[vcnt_int+NUMPOPT] = vcnt_nxt[vcnt_int+NUMPOPT] - 1; 
        for (vcpt_int=0; vcpt_int<=vcnt_int; vcpt_int=vcpt_int+1)
          if (vpush_wire[vcpt_int] && (vpuprt_wire[vcnt_int]==vpuprt_wire[vcpt_int]))
            vcnt_nxt[vcnt_int+NUMPOPT] = vcnt_nxt[vcnt_int+NUMPOPT] + 1; 
        for (vcpt_int=0; vcpt_int<NUMPOPT; vcpt_int=vcpt_int+1)
          if (vpop_wire[vcpt_int] && !vpondq_wire[vcpt_int] && (vpuprt_wire[vcnt_int]==vpoprt_wire[vcpt_int]))
            vqct_nxt[vcnt_int+NUMPOPT] = vqct_nxt[vcnt_int+NUMPOPT] - 1; 
        for (vcpt_int=0; vcpt_int<NUMPUPT; vcpt_int=vcpt_int+1)
          if (vpush_wire[vcpt_int] && (vpuprt_wire[vcnt_int]==vpuprt_wire[vcpt_int]))
            vqct_nxt[vcnt_int+NUMPOPT] = vqct_nxt[vcnt_int+NUMPOPT] + 1; 
        for (vcpt_int=0; vcpt_int<NUMPOPT; vcpt_int=vcpt_int+1)
          if (vpop_wire[vcpt_int] && !vpondq_wire[vcpt_int] && (vpuprt_wire[vcnt_int]==vpoprt_wire[vcpt_int]))
            vpct_nxt[vcnt_int+NUMPOPT] = vpct_nxt[vcnt_int+NUMPOPT] + 1; 
      end
    end
  end

  reg               vpop_out [0:NUMPOPT-1];
  reg               vpondq_out [0:NUMPOPT-1];
  reg [BITQPRT-1:0] vpoprt_out [0:NUMPOPT-1];
  reg               vdeq_out [0:NUMPOPT-1];
  reg [BITQPRT-1:0] vdqprt_out [0:NUMPOPT-1];
  reg               vpush_out [0:NUMPUPT-1];
  reg [BITQPRT-1:0] vpuprt_out [0:NUMPUPT-1];
  reg [BITQPTR-1:0] vpuptr_out [0:NUMPUPT-1];
  reg [WIDTH-1:0]   vpudin_out [0:NUMPUPT-1];
  reg [BITQCNT-1:0] voct_out [0:NUMPOPT-1];
  reg [BITQCNT-1:0] vuct_out [0:NUMPUPT-1];
  reg [BITQCNT-1:0] vcnt_out [0:NUMPOPT+NUMPUPT-1];
  reg [BITQCNT-1:0] vqct_out [0:NUMPOPT+NUMPUPT-1];
  reg [BITQCNT-1:0] vpct_out [0:NUMPOPT+NUMPUPT-1];
  reg               vcpread_out;
  reg [BITCPAD-1:0] vcpaddr_out;
  integer prto_int;
  always_comb begin
    for (prto_int=0; prto_int<NUMPOPT; prto_int=prto_int+1) begin
      vpop_out[prto_int] = vpop_reg[prto_int][QPTR_DELAY-1];
      vpondq_out[prto_int] = vpondq_reg[prto_int][QPTR_DELAY-1];
      vpoprt_out[prto_int] = vpoprt_reg[prto_int][QPTR_DELAY-1];
      vdeq_out[prto_int] = vdeq_reg[prto_int][QPTR_DELAY+LINK_DELAY-1];
      vdqprt_out[prto_int] = vpoprt_reg[prto_int][QPTR_DELAY+LINK_DELAY-1];
      voct_out[prto_int] = voct_reg[prto_int][QPTR_DELAY-1];
      vcnt_out[prto_int] = vcnt_reg[prto_int][QPTR_DELAY-1];
      vqct_out[prto_int] = vqct_reg[prto_int][QPTR_DELAY-1];
      vpct_out[prto_int] = vpct_reg[prto_int][QPTR_DELAY-1];
    end
    for (prto_int=0; prto_int<NUMPUPT; prto_int=prto_int+1) begin
      vpush_out[prto_int] = vpush_reg[prto_int][QPTR_DELAY-1];
      vpuprt_out[prto_int] = vpuprt_reg[prto_int][QPTR_DELAY-1];
      vpuptr_out[prto_int] = vpuptr_reg[prto_int][QPTR_DELAY-1];
      vpudin_out[prto_int] = vpudin_reg[prto_int][QPTR_DELAY-1];
      vuct_out[prto_int] = vuct_reg[prto_int][QPTR_DELAY-1];
      vuct_out[prto_int] = vuct_reg[prto_int][QPTR_DELAY-1];
      vcnt_out[prto_int+NUMPOPT] = vcnt_reg[prto_int+NUMPOPT][QPTR_DELAY-1];
      vqct_out[prto_int+NUMPOPT] = vqct_reg[prto_int+NUMPOPT][QPTR_DELAY-1];
      vpct_out[prto_int+NUMPOPT] = vpct_reg[prto_int+NUMPOPT][QPTR_DELAY-1];
    end
    vcpread_out = vcpread_reg[QPTR_DELAY-1];
    vcpaddr_out = vcpaddr_reg[QPTR_DELAY-1];
  end

  reg [NUMPOPT-1:0]                     t3_readB;
  reg [NUMPOPT*BITQPRT-1:0]             t3_addrB;
  reg [NUMPUPT-1:0]                     t4_readB;
  reg [NUMPUPT*BITQPRT-1:0]             t4_addrB;
  reg [(NUMPOPT+NUMPUPT)-1:0]           t5_readB;
  reg [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t5_addrB;
  reg [(NUMPOPT+NUMPUPT)-1:0]           t6_readB;
  reg [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]   t6_addrB;
  reg [NUMPUPT-1:0]                     t7_readB;
  reg [NUMPUPT*BITQPRT-1:0]             t7_addrB;
  integer rd_int;
  always_comb begin
    t3_readB = rstvld && !rst;
    t3_addrB = (rstvld && !rst) ? rstaddr : 0;
    for (rd_int=0; rd_int<NUMPOPT; rd_int=rd_int+1) begin
      if (vpop_wire[rd_int]) begin
        t3_readB = t3_readB | (1'b1 << rd_int);
        t3_addrB = t3_addrB | (vpoprt_wire[rd_int] << (rd_int*BITQPRT));
      end
    end

    t4_readB = rstvld && !rst;
    t4_addrB = (rstvld && !rst) ? rstaddr : 0;
    for (rd_int=0; rd_int<NUMPUPT; rd_int=rd_int+1) begin
      if (vpush_wire[rd_int]) begin
        t4_readB = t4_readB | (1'b1 << rd_int);
        t4_addrB = t4_addrB | (vpuprt_wire[rd_int] << (rd_int*BITQPRT));
      end
    end

    t5_readB = rstvld && !rst;
    t5_addrB = 0;
    t5_addrB[BITQPRT-1:0] = (rstvld && !rst) ? rstaddr : 0;
    for (rd_int=0; rd_int<NUMPOPT; rd_int=rd_int+1) begin
      if (vpop_wire[rd_int]) begin
        t5_readB = t5_readB | (1'b1 << rd_int);
        t5_addrB = t5_addrB | (vpoprt_wire[rd_int] << (rd_int*BITQPRT));
      end
    end
    for (rd_int=0; rd_int<NUMPUPT; rd_int=rd_int+1) begin
      if (vpush_wire[rd_int]) begin
        t5_readB = t5_readB | (1'b1 << (rd_int+NUMPOPT));
        t5_addrB = t5_addrB | (vpuprt_wire[rd_int] << ((rd_int+NUMPOPT)*BITQPRT));
      end
    end

    t6_readB = rstvld && !rst;
    t6_addrB = 0;
    t6_addrB[BITQPRT-1:0] = (rstvld && !rst) ? rstaddr : 0;
    for (rd_int=0; rd_int<NUMPOPT; rd_int=rd_int+1) begin
      if (vpop_wire[rd_int])
        t6_readB = t6_readB | (1'b1 << rd_int);
      t6_addrB = t6_addrB | (vpoprt_wire[rd_int] << (rd_int*BITQPRT));
    end
    for (rd_int=0; rd_int<NUMPUPT; rd_int=rd_int+1) begin
      if (vpush_wire[rd_int]) begin
        t6_readB = t6_readB | (1'b1 << (rd_int+NUMPOPT));
        t6_addrB = t6_addrB | (vpuprt_wire[rd_int] << ((rd_int+NUMPOPT)*BITQPRT));
      end
    end

    t7_readB = rstvld && !rst;
    t7_addrB = 0;
    t7_addrB[BITQPRT-1:0] = (rstvld && !rst) ? rstaddr : 0;
    for (rd_int=0; rd_int<NUMPUPT; rd_int=rd_int+1) begin
      if (vpush_wire[rd_int]) begin
        t7_readB = t7_readB | (1'b1 << rd_int);
        t7_addrB = t7_addrB | (vpuprt_wire[rd_int] << (rd_int*BITQPRT));
      end
    end

    if (vcpread_wire) begin
      t3_readB[0] = 1'b1;
      t3_addrB[BITQPRT-1:0] = vcpaddr_wire;
      t4_readB[0] = 1'b1;
      t4_addrB[BITQPRT-1:0] = vcpaddr_wire;
      t5_readB[0] = 1'b1;
      t5_addrB[BITQPRT-1:0] = vcpaddr_wire;
      t6_readB[0] = 1'b1;
      t6_addrB[BITQPRT-1:0] = vcpaddr_wire;
      t7_readB[0] = 1'b1;
      t7_addrB[BITQPRT-1:0] = vcpaddr_wire;
    end 
  end

  reg owrite_wire [0:NUMPOPT-1];
  reg [BITQPRT-1:0] owraddr_wire [0:NUMPOPT-1];
  reg [BITPING-1:0] odin_wire [0:NUMPOPT-1];
  reg uwrite_wire [0:NUMPUPT-1];
  reg [BITQPRT-1:0] uwraddr_wire [0:NUMPUPT-1];
  reg [BITPING-1:0] udin_wire [0:NUMPUPT-1];
  reg cwrite_wire [0:NUMPOPT+NUMPUPT-1];
  reg [BITQPRT-1:0] cwraddr_wire [0:NUMPOPT+NUMPUPT-1];
  reg [BITQCNT-1:0] cdin_wire [0:NUMPOPT+NUMPUPT-1];
  reg hwrite_wire [0:NUMPOPT+NUMPUPT-1];
  reg [BITQPRT-1:0] hwraddr_wire [0:NUMPOPT+NUMPUPT-1];
  reg [NUMPING*BITQPTR-1:0] hdin_wire [0:NUMPOPT+NUMPUPT-1];
  reg twrite_wire [0:NUMPUPT-1];
  reg [BITQPRT-1:0] twraddr_wire [0:NUMPUPT-1];
  reg [NUMPING*BITQPTR-1:0] tdin_wire [0:NUMPUPT-1];

  reg [BITPING-1:0] odout_wire [0:NUMPOPT-1];
  reg [BITPING-1:0] udout_wire [0:NUMPUPT-1];
  reg [BITQCNT-1:0] cdout_wire [0:NUMPOPT+NUMPUPT-1];
  reg [NUMPING*BITQPTR-1:0] hdout_wire [0:NUMPOPT+NUMPUPT-1];
  reg [NUMPING*BITQPTR-1:0] tdout_wire [0:NUMPUPT-1];
  integer dout_int;
  always_comb begin
    for (dout_int=0; dout_int<NUMPOPT; dout_int=dout_int+1) 
      odout_wire[dout_int] = t3_doutB >> (dout_int*BITPING);
    for (dout_int=0; dout_int<NUMPUPT; dout_int=dout_int+1) 
      udout_wire[dout_int] = t4_doutB >> (dout_int*BITPING);
    for (dout_int=0; dout_int<NUMPOPT+NUMPUPT; dout_int=dout_int+1) 
      cdout_wire[dout_int] = t5_doutB >> (dout_int*BITQCNT);
    for (dout_int=0; dout_int<NUMPOPT+NUMPUPT; dout_int=dout_int+1) 
      hdout_wire[dout_int] = t6_doutB >> (dout_int*NUMPING*BITQPTR);
    for (dout_int=0; dout_int<NUMPUPT; dout_int=dout_int+1) 
      tdout_wire[dout_int] = t7_doutB >> (dout_int*NUMPING*BITQPTR);
  end

  reg               optr_vld [0:NUMPOPT-1][0:QPTR_DELAY-1];
  reg [BITPING-1:0] optr_reg [0:NUMPOPT-1][0:QPTR_DELAY-1];
  genvar oprt_int, ofwd_int;
  generate
    for (ofwd_int=0; ofwd_int<QPTR_DELAY; ofwd_int=ofwd_int+1) begin: op_loop
      for (oprt_int=0; oprt_int<NUMPOPT; oprt_int=oprt_int+1) begin: po_loop
        reg [BITQPRT-1:0] vaddr_temp;
        reg optr_vld_next;
        reg [BITPING-1:0] optr_reg_next;
        integer fwpt_int;
        always_comb begin
          if (ofwd_int>0) begin
            vaddr_temp = vpoprt_reg[oprt_int][ofwd_int-1];
            optr_vld_next = optr_vld[oprt_int][ofwd_int-1];
            optr_reg_next = optr_reg[oprt_int][ofwd_int-1];
          end else begin
            vaddr_temp = vpoprt_wire[oprt_int];
            optr_vld_next = 1'b0;
            optr_reg_next = 0;
          end
          for (fwpt_int=0; fwpt_int<NUMPOPT; fwpt_int=fwpt_int+1)
            if (owrite_wire[fwpt_int] && (owraddr_wire[fwpt_int] == vaddr_temp)) begin
              optr_vld_next = 1'b1;
              optr_reg_next = odin_wire[fwpt_int];
            end
        end

        always @(posedge clk) begin
          optr_vld[oprt_int][ofwd_int] <= optr_vld_next;
          optr_reg[oprt_int][ofwd_int] <= optr_reg_next;
        end
      end
    end
  endgenerate

  reg               uptr_vld [0:NUMPUPT-1][0:QPTR_DELAY-1];
  reg [BITPING-1:0] uptr_reg [0:NUMPUPT-1][0:QPTR_DELAY-1];
  genvar uptr_int, ufwd_int;
  generate
    for (ufwd_int=0; ufwd_int<QPTR_DELAY; ufwd_int=ufwd_int+1) begin: up_loop
      for (uptr_int=0; uptr_int<NUMPUPT; uptr_int=uptr_int+1) begin: po_loop
        reg [BITQPRT-1:0] vaddr_temp;
        reg uptr_vld_next;
        reg [BITPING-1:0] uptr_reg_next;
        integer fwpt_int;
        always_comb begin
          if (ufwd_int>0) begin
            vaddr_temp = vpuprt_reg[uptr_int][ufwd_int-1];
            uptr_vld_next = uptr_vld[uptr_int][ufwd_int-1];
            uptr_reg_next = uptr_reg[uptr_int][ufwd_int-1];
          end else begin
            vaddr_temp = vpuprt_wire[uptr_int];
            uptr_vld_next = 1'b0;
            uptr_reg_next = 0;
          end
          for (fwpt_int=0; fwpt_int<NUMPUPT; fwpt_int=fwpt_int+1)
            if (uwrite_wire[fwpt_int] && (uwraddr_wire[fwpt_int] == vaddr_temp)) begin
              uptr_vld_next = 1'b1;
              uptr_reg_next = udin_wire[fwpt_int];
            end
        end

        always @(posedge clk) begin
          uptr_vld[uptr_int][ufwd_int] <= uptr_vld_next;
          uptr_reg[uptr_int][ufwd_int] <= uptr_reg_next;
        end
      end
    end
  endgenerate

  reg               cnt_vld [0:NUMPOPT+NUMPUPT-1][0:QPTR_DELAY-1];
  reg [BITQCNT-1:0] cnt_reg [0:NUMPOPT+NUMPUPT-1][0:QPTR_DELAY-1];
  genvar cprt_int, cfwd_int;
  generate
    for (cfwd_int=0; cfwd_int<QPTR_DELAY; cfwd_int=cfwd_int+1) begin: ct_loop
      for (cprt_int=0; cprt_int<NUMPOPT; cprt_int=cprt_int+1) begin: po_loop
        reg [BITQPRT-1:0] vaddr_temp;
        reg cnt_vld_next;
        reg [BITQCNT-1:0] cnt_reg_next;
        integer fwpt_int;
        always_comb begin
          if (cfwd_int>0) begin
	        vaddr_temp = vpoprt_reg[cprt_int][cfwd_int-1];
            cnt_vld_next = cnt_vld[cprt_int][cfwd_int-1];
            cnt_reg_next = cnt_reg[cprt_int][cfwd_int-1];
          end else begin
            vaddr_temp = vpoprt_wire[cprt_int];
            cnt_vld_next = 1'b0;
            cnt_reg_next = 0;
          end
          for (fwpt_int=0; fwpt_int<NUMPOPT+NUMPUPT; fwpt_int=fwpt_int+1)
            if (cwrite_wire[fwpt_int] && (cwraddr_wire[fwpt_int] == vaddr_temp)) begin
              cnt_vld_next = 1'b1;
              cnt_reg_next = cdin_wire[fwpt_int];
            end
        end

        always @(posedge clk) begin
          cnt_vld[cprt_int][cfwd_int] <= cnt_vld_next;
          cnt_reg[cprt_int][cfwd_int] <= cnt_reg_next;
        end
      end

      for (cprt_int=0; cprt_int<NUMPUPT; cprt_int=cprt_int+1) begin: pu_loop
        reg [BITQPRT-1:0] vaddr_temp;
        reg cnt_vld_next;
        reg [BITQCNT-1:0] cnt_reg_next;
        integer fwpt_int;
        always_comb begin
          if (cfwd_int>0) begin
	        vaddr_temp = vpuprt_reg[cprt_int][cfwd_int-1];
            cnt_vld_next = cnt_vld[cprt_int+1][cfwd_int-1];
            cnt_reg_next = cnt_reg[cprt_int+1][cfwd_int-1];
          end else begin
            vaddr_temp = vpuprt_wire[cprt_int];
            cnt_vld_next = 1'b0;
            cnt_reg_next = 0;
          end
          for (fwpt_int=0; fwpt_int<NUMPOPT+NUMPUPT; fwpt_int=fwpt_int+1)
            if (cwrite_wire[fwpt_int] && (cwraddr_wire[fwpt_int] == vaddr_temp)) begin
              cnt_vld_next = 1'b1;
              cnt_reg_next = cdin_wire[fwpt_int];
            end
        end

        always @(posedge clk) begin
          cnt_vld[cprt_int+NUMPOPT][cfwd_int] <= cnt_vld_next;
          cnt_reg[cprt_int+NUMPOPT][cfwd_int] <= cnt_reg_next;
        end
      end
    end
  endgenerate

  reg                       head_vld [0:NUMPOPT+NUMPUPT-1][0:QPTR_DELAY+LINK_DELAY-1];
  reg [NUMPING*BITQPTR-1:0] head_reg [0:NUMPOPT+NUMPUPT-1][0:QPTR_DELAY+LINK_DELAY-1];
  genvar hprt_int, hfwd_int;
  generate
    for (hfwd_int=0; hfwd_int<QPTR_DELAY+LINK_DELAY; hfwd_int=hfwd_int+1) begin: hd_loop
      for (hprt_int=0; hprt_int<NUMPOPT; hprt_int=hprt_int+1) begin: po_loop
        reg [BITQPRT-1:0] vaddr_temp;
        reg head_vld_next;
        reg [NUMPING*BITQPTR-1:0] head_reg_next;
        integer fwpt_int;
        always_comb begin
          if (hfwd_int==QPTR_DELAY) begin
            vaddr_temp = vpoprt_reg[hprt_int][hfwd_int-1];
            if (head_vld[hprt_int][hfwd_int-1]) begin
              head_vld_next = head_vld[hprt_int][hfwd_int-1];
              head_reg_next = head_reg[hprt_int][hfwd_int-1];
            end else begin
              head_vld_next = 1'b1;
              head_reg_next = hdout_wire[hprt_int];
            end
          end else if (hfwd_int>0) begin
            vaddr_temp = vpoprt_reg[hprt_int][hfwd_int-1];
            head_vld_next = head_vld[hprt_int][hfwd_int-1];
            head_reg_next = head_reg[hprt_int][hfwd_int-1];
          end else begin
            vaddr_temp = vpoprt_wire[hprt_int];
            head_vld_next = 1'b0;
            head_reg_next = 0;
          end
          for (fwpt_int=0; fwpt_int<NUMPOPT+NUMPUPT; fwpt_int=fwpt_int+1)
            if (hwrite_wire[fwpt_int] && (hwraddr_wire[fwpt_int] == vaddr_temp)) begin
              head_vld_next = 1'b1;
              head_reg_next = hdin_wire[fwpt_int];
            end
        end

        always @(posedge clk) begin
          head_vld[hprt_int][hfwd_int] <= head_vld_next;
          head_reg[hprt_int][hfwd_int] <= head_reg_next;
        end
      end

      for (hprt_int=0; hprt_int<NUMPUPT; hprt_int=hprt_int+1) begin: pu_loop
        reg [BITQPRT-1:0] vaddr_temp;
        reg head_vld_next;
        reg [NUMPING*BITQPTR-1:0] head_reg_next;
        integer fwpt_int;
        always_comb begin
          if (hfwd_int>0) begin
            vaddr_temp = vpuprt_reg[hprt_int][hfwd_int-1];
            head_vld_next = head_vld[hprt_int+NUMPOPT][hfwd_int-1];
            head_reg_next = head_reg[hprt_int+NUMPOPT][hfwd_int-1];
          end else begin
            vaddr_temp = vpuprt_wire[hprt_int];
            head_vld_next = 1'b0;
            head_reg_next = 0;
          end
          for (fwpt_int=0; fwpt_int<NUMPOPT+NUMPUPT; fwpt_int=fwpt_int+1)
            if (hwrite_wire[fwpt_int] && (hwraddr_wire[fwpt_int] == vaddr_temp)) begin
              head_vld_next = 1'b1;
              head_reg_next = hdin_wire[fwpt_int];
            end
        end

        always @(posedge clk) begin
          head_vld[hprt_int+NUMPOPT][hfwd_int] <= head_vld_next;
          head_reg[hprt_int+NUMPOPT][hfwd_int] <= head_reg_next;
        end
      end
    end
  endgenerate

  reg                       tail_vld [0:NUMPUPT-1][0:QPTR_DELAY-1];
  reg [NUMPING*BITQPTR-1:0] tail_reg [0:NUMPUPT-1][0:QPTR_DELAY-1];
  genvar tprt_int, tfwd_int;
  generate
    for (tfwd_int=0; tfwd_int<QPTR_DELAY; tfwd_int=tfwd_int+1) begin: tl_loop
      for (tprt_int=0; tprt_int<NUMPUPT; tprt_int=tprt_int+1) begin: pu_loop
        reg [BITQPRT-1:0] vaddr_temp;
        reg tail_vld_next;
        reg [NUMPING*BITQPTR-1:0] tail_reg_next;
        integer fwpt_int;
        always_comb begin
          if (tfwd_int>0) begin
	        vaddr_temp = vpuprt_reg[tprt_int][tfwd_int-1];
            tail_vld_next = tail_vld[tprt_int][tfwd_int-1];
            tail_reg_next = tail_reg[tprt_int][tfwd_int-1];
          end else begin
            vaddr_temp = vpuprt_wire[tprt_int];
            tail_vld_next = 1'b0;
            tail_reg_next = 0;
          end
          for (fwpt_int=0; fwpt_int<NUMPUPT; fwpt_int=fwpt_int+1)
            if (twrite_wire[fwpt_int] && (twraddr_wire[fwpt_int] == vaddr_temp)) begin
              tail_vld_next = 1'b1;
              tail_reg_next = tdin_wire[fwpt_int];
            end
        end

        always @(posedge clk) begin
          tail_vld[tprt_int][tfwd_int] <= tail_vld_next;
          tail_reg[tprt_int][tfwd_int] <= tail_reg_next;
        end
      end
    end
  endgenerate

  integer fprt_int, fprp_int;
  always_comb begin
    for (fprt_int=0; fprt_int<NUMPOPT; fprt_int=fprt_int+1) 
      optr_out[fprt_int] = optr_vld[fprt_int][QPTR_DELAY-1] ? optr_reg[fprt_int][QPTR_DELAY-1] : odout_wire[fprt_int];
    for (fprt_int=0; fprt_int<NUMPUPT; fprt_int=fprt_int+1) 
      uptr_out[fprt_int] = uptr_vld[fprt_int][QPTR_DELAY-1] ? uptr_reg[fprt_int][QPTR_DELAY-1] : udout_wire[fprt_int];
    for (fprt_int=0; fprt_int<NUMPOPT; fprt_int=fprt_int+1) begin
      head_out[fprt_int] = head_vld[fprt_int][QPTR_DELAY-1] ? head_reg[fprt_int][QPTR_DELAY-1] : hdout_wire[fprt_int];
      for (fprp_int=0; fprp_int<NUMPING; fprp_int=fprp_int+1)
        hptr_out[fprt_int][fprp_int] = head_out[fprt_int] >> (fprp_int*BITQPTR);
    end
    for (fprt_int=0; fprt_int<NUMPUPT; fprt_int=fprt_int+1) begin
      head_out[fprt_int+NUMPOPT] = head_vld[fprt_int+NUMPOPT][QPTR_DELAY-1] ? head_reg[fprt_int+NUMPOPT][QPTR_DELAY-1] : hdout_wire[fprt_int+NUMPOPT];
      for (fprp_int=0; fprp_int<NUMPING; fprp_int=fprp_int+1)
        hptr_out[fprt_int+NUMPOPT][fprp_int] = head_out[fprt_int+NUMPOPT] >> (fprp_int*BITQPTR);
    end
    for (fprt_int=0; fprt_int<NUMPUPT; fprt_int=fprt_int+1) begin
      tail_out[fprt_int] = tail_vld[fprt_int][QPTR_DELAY-1] ? tail_reg[fprt_int][QPTR_DELAY-1] : tdout_wire[fprt_int];
      for (fprp_int=0; fprp_int<NUMPING; fprp_int=fprp_int+1)
        tptr_out[fprt_int][fprp_int] = tail_out[fprt_int] >> (fprp_int*BITQPTR);
    end
    for (fprt_int=0; fprt_int<NUMPOPT+NUMPUPT; fprt_int=fprt_int+1) 
      cnt_out[fprt_int] = cnt_vld[fprt_int][QPTR_DELAY-1] ? cnt_reg[fprt_int][QPTR_DELAY-1] : cdout_wire[fprt_int];
    for (fprt_int=0; fprt_int<NUMPOPT; fprt_int=fprt_int+1)
      hdeq_out[fprt_int] = head_reg[fprt_int][QPTR_DELAY+LINK_DELAY-1];
  end

  reg [BITPING-1:0] optr_del [0:NUMPOPT-1][0:LINK_DELAY-1];
  integer optr_int, optd_int;
  always @(posedge clk)
    for (optr_int=0; optr_int<NUMPOPT; optr_int=optr_int+1)
      for (optd_int=0; optd_int<LINK_DELAY; optd_int=optd_int+1)
        if (optd_int>0)
          optr_del[optr_int][optd_int] <= optr_del[optr_int][optd_int-1];
        else
          optr_del[optr_int][optd_int] <= optr_out[optr_int];

  reg [BITPING-1:0] odeq_out [0:NUMPOPT-1];
  integer odeq_int;
  always_comb
    for (odeq_int=0; odeq_int<NUMPOPT; odeq_int=odeq_int+1)
      odeq_out[odeq_int] = optr_del[odeq_int][LINK_DELAY-1];

  reg pwrite_wire [0:NUMPUPT-1];
  reg [BITADDR-1:0] pwraddr_wire [0:NUMPUPT-1];
  reg [BITQPTR-1:0] pdin_wire [0:NUMPUPT-1];
  reg [BITADDR-1:0] pwraddr_temp [0:NUMPUPT-1];
  integer pwr_int, pwp_int, pwb_int;
  always_comb
    for (pwr_int=0; pwr_int<NUMPUPT; pwr_int=pwr_int+1) begin
      pwrite_wire[pwr_int] = vpush_out[pwr_int] && (cdin_wire[pwr_int+NUMPOPT]>NUMPING) && (uptr_out[pwr_int]<NUMPING);
      pwraddr_temp[pwr_int] = 0;
      for (pwb_int=0; pwb_int<NUMPING; pwb_int=pwb_int+1)
        if (pwb_int==uptr_out[pwr_int])
          pwraddr_temp[pwr_int] = tail_out[pwr_int] >> (pwb_int*BITQPTR);
//      pwraddr_temp[pwr_int] = tptr_out[pwr_int][uptr_out[pwr_int]];
      pdin_wire[pwr_int] = vpuptr_out[pwr_int];
      for (pwp_int=0; pwp_int<pwr_int; pwp_int=pwp_int+1)
        if (vpush_out[pwr_int] && vpush_out[pwp_int] && (vpuprt_out[pwr_int]==vpuprt_out[pwp_int]))
          pwraddr_temp[pwr_int] = pdin_wire[pwp_int];
      pwraddr_wire[pwr_int] =  pwraddr_temp[pwr_int];
    end

  integer swr_int, swx_int;
  always_comb begin
    for (swr_int=0; swr_int<NUMPOPT; swr_int=swr_int+1) begin
      owrite_wire[swr_int] = vpop_out[swr_int] && !vpondq_out[swr_int] && |cnt_out[swr_int];
      owraddr_wire[swr_int] = vpoprt_out[swr_int];
      odin_wire[swr_int] = (optr_out[swr_int] + voct_out[swr_int] + 1)%NUMPING;
    end
    for (swr_int=0; swr_int<NUMPUPT; swr_int=swr_int+1) begin
      uwrite_wire[swr_int] = vpush_out[swr_int];
      uwraddr_wire[swr_int] = vpuprt_out[swr_int];
      udin_wire[swr_int] = (uptr_out[swr_int] + vuct_out[swr_int] + 1)%NUMPING;
    end
    for (swr_int=0; swr_int<NUMPOPT; swr_int=swr_int+1) begin
      cwrite_wire[swr_int] = vpop_out[swr_int] && !vpondq_out[swr_int] && |cnt_out[swr_int];
      cwraddr_wire[swr_int] = vpoprt_out[swr_int];
      cdin_wire[swr_int] = cnt_out[swr_int] + vcnt_out[swr_int];
    end
    for (swr_int=0; swr_int<NUMPUPT; swr_int=swr_int+1) begin
      cwrite_wire[swr_int+NUMPOPT] = vpush_out[swr_int];
      cwraddr_wire[swr_int+NUMPOPT] = vpuprt_out[swr_int];
      cdin_wire[swr_int+NUMPOPT] = |cnt_out[swr_int+NUMPOPT] ? cnt_out[swr_int+NUMPOPT] + vcnt_out[swr_int+NUMPOPT] : vcnt_out[swr_int+NUMPOPT] + vpct_out[swr_int+NUMPOPT];
    end
    for (swr_int=0; swr_int<NUMPOPT; swr_int=swr_int+1) begin
      hwrite_wire[swr_int] = vdeq_out[swr_int];
      hwraddr_wire[swr_int] = vdqprt_out[swr_int];
      hdin_wire[swr_int] = hdeq_out[swr_int];
      for (swx_int=0; swx_int<swr_int; swx_int=swx_int+1)
        if (hwrite_wire[swr_int] && hwrite_wire[swx_int] && (hwraddr_wire[swr_int]==hwraddr_wire[swx_int]))
          hdin_wire[swr_int] = hdin_wire[swx_int];
      for (swx_int=0; swx_int<NUMPING; swx_int=swx_int+1)
        if (swx_int==odeq_out[swr_int])
          hdin_wire[swr_int] = (hdin_wire[swr_int] & ~({BITQPTR{1'b1}} << (swx_int*BITQPTR))) |
                               (((t1_doutB >> (swr_int*BITQPTR)) & {BITQPTR{1'b1}}) << (swx_int*BITQPTR));
    end
    for (swr_int=0; swr_int<NUMPUPT; swr_int=swr_int+1) begin
      hwrite_wire[swr_int+NUMPOPT] = vpush_out[swr_int] && (cdin_wire[swr_int+NUMPOPT]<=NUMPING);
      hwraddr_wire[swr_int+NUMPOPT] = vpuprt_out[swr_int];
      hdin_wire[swr_int+NUMPOPT] = head_out[swr_int+NUMPOPT];
      for (swx_int=0; swx_int<swr_int+NUMPOPT; swx_int=swx_int+1)
        if (hwrite_wire[swr_int+NUMPOPT] && hwrite_wire[swx_int] && (hwraddr_wire[swr_int+NUMPOPT]==hwraddr_wire[swx_int]))
          hdin_wire[swr_int+NUMPOPT] = hdin_wire[swx_int];
      for (swx_int=0; swx_int<NUMPING; swx_int=swx_int+1)
        if (swx_int==((uptr_out[swr_int]+vuct_out[swr_int])%NUMPING))
          hdin_wire[swr_int+NUMPOPT] = (hdin_wire[swr_int+NUMPOPT] & ~({BITQPTR{1'b1}} << (swx_int*BITQPTR))) |
                                       (vpuptr_out[swr_int] << (swx_int*BITQPTR));
    end
    for (swr_int=0; swr_int<NUMPUPT; swr_int=swr_int+1) begin
      twrite_wire[swr_int] = vpush_out[swr_int];
      twraddr_wire[swr_int] = vpuprt_out[swr_int];
      tdin_wire[swr_int] = tail_out[swr_int];
      for (swx_int=0; swx_int<swr_int; swx_int=swx_int+1)
        if (twrite_wire[swr_int] && twrite_wire[swx_int] && (twraddr_wire[swr_int]==twraddr_wire[swx_int]))
          tdin_wire[swr_int] = tdin_wire[swx_int];
      for (swx_int=0; swx_int<NUMPING; swx_int=swx_int+1)
        if (swx_int==((uptr_out[swr_int]+vuct_out[swr_int])%NUMPING))
          tdin_wire[swr_int] = (tdin_wire[swr_int] & ~({BITQPTR{1'b1}} << (swx_int*BITQPTR))) |
                               (vpuptr_out[swr_int] << (swx_int*BITQPTR));
    end
    if (vcpwrite_wire) begin
      owrite_wire[NUMPOPT-1] = 1'b1;
      owraddr_wire[NUMPOPT-1] = vcpaddr_wire;
      odin_wire[NUMPOPT-1] = vcpdin_wire >> (2*NUMPING*BITQPTR+BITQCNT+BITPING);
      uwrite_wire[NUMPOPT-1] = 1'b1;
      uwraddr_wire[NUMPOPT-1] = vcpaddr_wire;
      udin_wire[NUMPOPT-1] = vcpdin_wire >> (2*NUMPING*BITQPTR+BITQCNT);
      cwrite_wire[NUMPOPT+NUMPUPT-1] = 1'b1;
      cwraddr_wire[NUMPOPT+NUMPUPT-1] = vcpaddr_wire;
      cdin_wire[NUMPOPT+NUMPUPT-1] = vcpdin_wire >> 2*NUMPING*BITQPTR;
      hwrite_wire[NUMPOPT+NUMPUPT-1] = 1'b1;
      hwraddr_wire[NUMPOPT+NUMPUPT-1] = vcpaddr_wire;
      hdin_wire[NUMPOPT+NUMPUPT-1] = vcpdin_wire >> NUMPING*BITQPTR;
      twrite_wire[NUMPUPT-1] = 1'b1;
      twraddr_wire[NUMPUPT-1] = vcpaddr_wire;
      tdin_wire[NUMPUPT-1] = vcpdin_wire;
    end
  end

  wire vcp_vld_wire = vcpread_out;
  wire [CPUWDTH-1:0] vcp_dout_wire = {odout_wire[0],udout_wire[0],cdout_wire[0],hdout_wire[0],tdout_wire[0]};

  reg vpo_cvld_wire [0:NUMPOPT-1];
  reg vpo_cmt_wire [0:NUMPOPT-1];
  reg [BITQCNT-1:0] vpo_cnt_wire [0:NUMPOPT-1];
  reg vpo_pvld_wire [0:NUMPOPT-1];
  reg [BITQPTR-1:0] vpo_ptr_wire [0:NUMPOPT-1];
  reg vpo_dvld_wire [0:NUMPOPT-1];
  reg [WIDTH-1:0] vpo_dout_wire [0:NUMPOPT-1];
  reg vpu_cvld_wire [0:NUMPUPT-1];
  reg [BITQCNT-1:0] vpu_cnt_wire [0:NUMPUPT-1];
  integer vdop_int, vdox_int;
  always_comb begin
    for (vdop_int=0; vdop_int<NUMPOPT; vdop_int=vdop_int+1) begin
      vpo_cvld_wire[vdop_int] = vpop_out[vdop_int];
      vpo_cmt_wire[vdop_int] = !(|cnt_out[vdop_int]);
      vpo_cnt_wire[vdop_int] = |cnt_out[vdop_int] ? cnt_out[vdop_int] + vqct_out[vdop_int] : vqct_out[vdop_int] + vpct_out[vdop_int];
      vpo_pvld_wire[vdop_int] = vpop_out[vdop_int];
//      vpo_ptr_wire[vdop_int] = hptr_out[vdop_int][optr_out[vdop_int]];
      vpo_ptr_wire[vdop_int] = 0;
      for (vdox_int=0; vdox_int<NUMPING; vdox_int=vdox_int+1)
        if (vdox_int==optr_out[vdop_int])
          vpo_ptr_wire[vdop_int] = head_out[vdop_int] >> (vdox_int*BITQPTR);
      vpo_dvld_wire[vdop_int] = vpop_reg[vdop_int][QPTR_DELAY+DATA_DELAY-1];
      vpo_dout_wire[vdop_int] = t2_doutB >> (vdop_int*WIDTH);
    end
    for (vdop_int=0; vdop_int<NUMPUPT; vdop_int=vdop_int+1) begin
      vpu_cvld_wire[vdop_int] = vpush_out[vdop_int];
      vpu_cnt_wire[vdop_int] = |cnt_out[vdop_int+NUMPOPT] ? cnt_out[vdop_int+NUMPOPT] + vqct_out[vdop_int+NUMPOPT] : vqct_out[vdop_int+NUMPOPT] + vpct_out[vdop_int+NUMPOPT];
    end
  end

  reg [NUMPOPT-1:0] vpo_cvld_tmp;
  reg [NUMPOPT-1:0] vpo_cmt_tmp;
  reg [NUMPOPT*BITQCNT-1:0] vpo_cnt_tmp;
  reg [NUMPOPT-1:0] vpo_pvld_tmp;
  reg [NUMPOPT*BITQPTR-1:0] vpo_ptr_tmp;
  reg [NUMPOPT-1:0] vpo_dvld_tmp;
  reg [NUMPOPT*WIDTH-1:0] vpo_dout_tmp;
  reg [NUMPUPT-1:0] vpu_cvld_tmp;
  reg [NUMPUPT*BITQCNT-1:0] vpu_cnt_tmp;
  integer vdo_int, vdow_int;
  always_comb begin
    for (vdo_int=0; vdo_int<NUMPOPT; vdo_int=vdo_int+1) begin
      vpo_pvld_tmp[vdo_int] = vpo_pvld_wire[vdo_int];
      for (vdow_int=0; vdow_int<BITQPTR; vdow_int=vdow_int+1)
        vpo_ptr_tmp[vdo_int*BITQPTR+vdow_int] = vpo_ptr_wire[vdo_int][vdow_int];
      vpo_cvld_tmp[vdo_int] = vpo_cvld_wire[vdo_int];
      vpo_cmt_tmp[vdo_int] = vpo_cmt_wire[vdo_int];
      for (vdow_int=0; vdow_int<BITQCNT; vdow_int=vdow_int+1)
        vpo_cnt_tmp[vdo_int*BITQCNT+vdow_int] = vpo_cnt_wire[vdo_int][vdow_int];
      vpo_dvld_tmp[vdo_int] = vpo_dvld_wire[vdo_int];
      for (vdow_int=0; vdow_int<WIDTH; vdow_int=vdow_int+1)
        vpo_dout_tmp[vdo_int*WIDTH+vdow_int] = vpo_dout_wire[vdo_int][vdow_int];
    end
    for (vdo_int=0; vdo_int<NUMPUPT; vdo_int=vdo_int+1) begin
      vpu_cvld_tmp[vdo_int] = vpu_cvld_wire[vdo_int];
      for (vdow_int=0; vdow_int<BITQCNT; vdow_int=vdow_int+1)
        vpu_cnt_tmp[vdo_int*BITQCNT+vdow_int] = vpu_cnt_wire[vdo_int][vdow_int];
    end
  end

  reg [NUMPOPT-1:0] vpo_cvld;
  reg [NUMPOPT-1:0] vpo_cmt;
  reg [NUMPOPT*BITQCNT-1:0] vpo_cnt;
  reg [NUMPOPT-1:0] vpo_pvld;
  reg [NUMPOPT*BITQPTR-1:0] vpo_ptr;
  reg [NUMPOPT-1:0] vpo_dvld;
  reg [NUMPOPT*WIDTH-1:0] vpo_dout;
  reg [NUMPUPT-1:0] vpu_cvld;
  reg [NUMPUPT*BITQCNT-1:0] vpu_cnt;
  reg vcpread_vld;
  reg [CPUWDTH-1:0] vcpread_dout;
  generate if (FLOPOUT) begin: flp_loop
    always @(posedge clk) begin
      vpo_cvld <= vpo_cvld_tmp;
      vpo_cmt <= vpo_cmt_tmp;
      vpo_cnt <= vpo_cnt_tmp;
      vpo_pvld <= vpo_pvld_tmp;
      vpo_ptr <= vpo_ptr_tmp;
      vpo_dvld <= vpo_dvld_tmp;
      vpo_dout <= vpo_dout_tmp;
      vpu_cvld <= vpu_cvld_tmp;
      vpu_cnt <= vpu_cnt_tmp;
      vcpread_vld <= vcp_vld_wire;
      vcpread_dout <= vcp_dout_wire;
    end
  end else begin: nflp_loop
    always_comb begin
      vpo_cvld = vpo_cvld_tmp;
      vpo_cmt = vpo_cmt_tmp;
      vpo_cnt = vpo_cnt_tmp;
      vpo_pvld = vpo_pvld_tmp;
      vpo_ptr = vpo_ptr_tmp;
      vpo_dvld = vpo_dvld_tmp;
      vpo_dout = vpo_dout_tmp;
      vpu_cvld = vpu_cvld_tmp;
      vpu_cnt = vpu_cnt_tmp;
      vcpread_vld = vcp_vld_wire;
      vcpread_dout = vcp_dout_wire;
    end
  end
  endgenerate

  reg [NUMPUPT-1:0] t1_writeA;
  reg [NUMPUPT*BITADDR-1:0] t1_addrA;
  reg [NUMPUPT*BITQPTR-1:0] t1_dinA;
  reg [NUMPOPT-1:0] t1_readB;
  reg [NUMPOPT*BITADDR-1:0] t1_addrB;
  integer t1w_int, t1wa_int, t1r_int, t1ra_int, t1rb_int;
  always_comb begin 
    for (t1w_int=0; t1w_int<NUMPUPT; t1w_int=t1w_int+1) begin
      t1_writeA[t1w_int] = pwrite_wire[t1w_int];
      for (t1wa_int=0; t1wa_int<BITADDR; t1wa_int=t1wa_int+1)
        t1_addrA[t1w_int*BITADDR+t1wa_int] = pwraddr_wire[t1w_int][t1wa_int];
      for (t1wa_int=0; t1wa_int<BITQPTR; t1wa_int=t1wa_int+1)
        t1_dinA[t1w_int*BITQPTR+t1wa_int] = pdin_wire[t1w_int][t1wa_int];
    end
    t1_addrB = 0;
    for (t1r_int=0; t1r_int<NUMPOPT; t1r_int=t1r_int+1) begin
      t1_readB[t1r_int] = (vpop_out[t1r_int] && (cnt_out[t1r_int]>NUMPING));
      for (t1rb_int=0; t1rb_int<NUMPING; t1rb_int=t1rb_int+1)
        if (t1rb_int==optr_out[t1r_int])
          for (t1ra_int=0; t1ra_int<BITADDR; t1ra_int=t1ra_int+1)
            t1_addrB[t1r_int*BITADDR+t1ra_int] = head_out[t1r_int][t1rb_int*BITQPTR+t1ra_int];
    end
  end

  reg [NUMPUPT-1:0] t2_writeA;
  reg [NUMPUPT*BITADDR-1:0] t2_addrA;
  reg [NUMPUPT*WIDTH-1:0] t2_dinA;
  reg [NUMPOPT-1:0] t2_readB;
  reg [NUMPOPT*BITADDR-1:0] t2_addrB;
  integer t2w_int, t2wa_int, t2r_int, t2ra_int, t2rb_int;
  always_comb begin
    for (t2w_int=0; t2w_int<NUMPUPT; t2w_int=t2w_int+1) begin
      t2_writeA[t2w_int] = vpush_out[t2w_int];
      for (t2wa_int=0; t2wa_int<BITADDR; t2wa_int=t2wa_int+1)
        t2_addrA[t2w_int*BITADDR+t2wa_int] = vpuptr_out[t2w_int][t2wa_int];
      for (t2wa_int=0; t2wa_int<WIDTH; t2wa_int=t2wa_int+1)
        t2_dinA[t2w_int*WIDTH+t2wa_int] = vpudin_out[t2w_int][t2wa_int];
    end
    t2_addrB = 0;
    for (t2r_int=0; t2r_int<NUMPOPT; t2r_int=t2r_int+1) begin
      t2_readB[t2r_int] = vpop_out[t2r_int];
      for (t2rb_int=0; t2rb_int<NUMPING; t2rb_int=t2rb_int+1)
        if (t2rb_int==optr_out[t2r_int])
          for (t2ra_int=0; t2ra_int<BITADDR; t2ra_int=t2ra_int+1)
            t2_addrB[t2r_int*BITADDR+t2ra_int] = head_out[t2r_int][t2rb_int*BITQPTR+t2ra_int];
    end
  end

  reg [NUMPOPT-1:0]         t3_writeA;
  reg [NUMPOPT*BITQPRT-1:0] t3_addrA;
  reg [NUMPOPT*BITPING-1:0] t3_dinA;
  integer t3w_int, t3wa_int;
  always_comb
    for (t3w_int=0; t3w_int<NUMPOPT; t3w_int=t3w_int+1) begin
      t3_writeA[t3w_int] = owrite_wire[t3w_int] || (rstvld_reg[QPTR_DELAY-1] && (t3w_int==0));
      for (t3wa_int=0; t3wa_int<BITQPRT; t3wa_int=t3wa_int+1)
        t3_addrA[t3w_int*BITQPRT+t3wa_int] = (rstvld_reg[QPTR_DELAY-1] && (t3w_int==0)) ? rstaddr_reg[QPTR_DELAY-1][t3wa_int] : owraddr_wire[t3w_int][t3wa_int];
      for (t3wa_int=0; t3wa_int<BITPING; t3wa_int=t3wa_int+1)
        t3_dinA[t3w_int*BITPING+t3wa_int] = (rstvld_reg[QPTR_DELAY-1] && (t3w_int==0)) ? 1'b0 : odin_wire[t3w_int][t3wa_int];
    end

  reg [NUMPUPT-1:0]         t4_writeA;
  reg [NUMPUPT*BITQPRT-1:0] t4_addrA;
  reg [NUMPUPT*BITPING-1:0] t4_dinA;
  integer t4w_int, t4wa_int;
  always_comb
    for (t4w_int=0; t4w_int<NUMPUPT; t4w_int=t4w_int+1) begin
      t4_writeA[t4w_int] = uwrite_wire[t4w_int] || (rstvld_reg[QPTR_DELAY-1] && (t4w_int==0));
      for (t4wa_int=0; t4wa_int<BITQPRT; t4wa_int=t4wa_int+1)
        t4_addrA[t4w_int*BITQPRT+t4wa_int] = (rstvld_reg[QPTR_DELAY-1] && (t4w_int==0)) ? rstaddr_reg[QPTR_DELAY-1][t4wa_int]  : uwraddr_wire[t4w_int][t4wa_int];
      for (t4wa_int=0; t4wa_int<BITPING; t4wa_int=t4wa_int+1)
        t4_dinA[t4w_int*BITPING+t4wa_int] = (rstvld_reg[QPTR_DELAY-1] && (t4w_int==0)) ? 1'b0 : udin_wire[t4w_int][t4wa_int];
    end

  reg [(NUMPOPT+NUMPUPT)-1:0]         t5_writeA;
  reg [(NUMPOPT+NUMPUPT)*BITQPRT-1:0] t5_addrA;
  reg [(NUMPOPT+NUMPUPT)*BITQCNT-1:0] t5_dinA;
  integer t5w_int, t5wa_int;
  always_comb
    for (t5w_int=0; t5w_int<NUMPOPT+NUMPUPT; t5w_int=t5w_int+1) begin
      t5_writeA[t5w_int] = cwrite_wire[t5w_int] || (rstvld_reg[QPTR_DELAY-1] && (t5w_int==0));
      for (t5wa_int=0; t5wa_int<BITQPRT; t5wa_int=t5wa_int+1)
        t5_addrA[t5w_int*BITQPRT+t5wa_int] = (rstvld_reg[QPTR_DELAY-1] && (t5w_int==0)) ? rstaddr_reg[QPTR_DELAY-1][t5wa_int]  : cwraddr_wire[t5w_int][t5wa_int];
      for (t5wa_int=0; t5wa_int<BITQCNT; t5wa_int=t5wa_int+1)
        t5_dinA[t5w_int*BITQCNT+t5wa_int] = (rstvld_reg[QPTR_DELAY-1] && (t5w_int==0)) ? 1'b0 : cdin_wire[t5w_int][t5wa_int];
    end

  reg [(NUMPOPT+NUMPUPT)-1:0]                 t6_writeA;
  reg [(NUMPOPT+NUMPUPT)*BITQPRT-1:0]         t6_addrA;
  reg [(NUMPOPT+NUMPUPT)*NUMPING*BITQPTR-1:0] t6_dinA;
  integer t6w_int, t6wa_int;
  always_comb
    for (t6w_int=0; t6w_int<NUMPOPT+NUMPUPT; t6w_int=t6w_int+1) begin
      t6_writeA[t6w_int] = hwrite_wire[t6w_int] || (rstvld_reg[QPTR_DELAY-1] && (t6w_int==0));
      for (t6wa_int=0; t6wa_int<BITQPRT; t6wa_int=t6wa_int+1)
        t6_addrA[t6w_int*BITQPRT+t6wa_int] = (rstvld_reg[QPTR_DELAY-1] && (t6w_int==0)) ? rstaddr_reg[QPTR_DELAY-1][t6wa_int]  : hwraddr_wire[t6w_int][t6wa_int];
      for (t6wa_int=0; t6wa_int<NUMPING*BITQPTR; t6wa_int=t6wa_int+1)
        t6_dinA[t6w_int*NUMPING*BITQPTR+t6wa_int] = (rstvld_reg[QPTR_DELAY-1] && (t6w_int==0)) ? 1'b0 : hdin_wire[t6w_int][t6wa_int];
    end

  reg [NUMPUPT-1:0]                 t7_writeA;
  reg [NUMPUPT*BITQPRT-1:0]         t7_addrA;
  reg [NUMPUPT*NUMPING*BITQPTR-1:0] t7_dinA;
  integer t7w_int, t7wa_int;
  always_comb
    for (t7w_int=0; t7w_int<NUMPUPT; t7w_int=t7w_int+1) begin
      t7_writeA[t7w_int] = twrite_wire[t7w_int] || (rstvld_reg[QPTR_DELAY-1] && (t7w_int==0));
      for (t7wa_int=0; t7wa_int<BITQPRT; t7wa_int=t7wa_int+1)
        t7_addrA[t7w_int*BITQPRT+t7wa_int] = (rstvld_reg[QPTR_DELAY-1] && (t7w_int==0)) ? rstaddr_reg[QPTR_DELAY-1][t7wa_int]  : twraddr_wire[t7w_int][t7wa_int];
      for (t7wa_int=0; t7wa_int<NUMPING*BITQPTR; t7wa_int=t7wa_int+1)
        t7_dinA[t7w_int*NUMPING*BITQPTR+t7wa_int] = (rstvld_reg[QPTR_DELAY-1] && (t7w_int==0)) ? 1'b0 : tdin_wire[t7w_int][t7wa_int];
    end

endmodule
