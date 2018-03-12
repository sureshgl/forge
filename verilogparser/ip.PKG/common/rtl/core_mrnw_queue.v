
module core_mrnw_queue (vpush, vpuaddr, vdin,
                        vpop, vpoaddr, vpo_vld, vpo_dout, vpo_fwrd, vpo_serr, vpo_derr, vpo_padr,
                        t1_writeA, t1_addrA, t1_dinA,
                        t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                        ready, clk, rst);
  
  parameter NUMPUPT = 6;
  parameter NUMPOPT = 1;
  parameter NUMQUEU = 256;
  parameter BITQUEU = 8;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter BITPADR = 15;
  
  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter NUMSBFL = 1;

  input [NUMPUPT-1:0]            vpush;
  input [NUMPUPT*BITQUEU-1:0]    vpuaddr;
  input [NUMPUPT*BITADDR-1:0]    vdin;

  input                          vpop;
  input [NUMPOPT*BITQUEU-1:0]    vpoaddr;
  output [NUMPOPT-1:0]           vpo_vld;
  output [NUMPOPT*BITADDR-1:0]   vpo_dout;
  output [NUMPOPT-1:0]           vpo_fwrd;
  output [NUMPOPT-1:0]           vpo_serr;
  output [NUMPOPT-1:0]           vpo_derr;
  output [NUMPOPT*BITPADR-1:0]   vpo_padr;

  output [NUMPUPT*-1:0]          t1_writeA;
  output [NUMPUPT*BITADDR-1:0]   t1_addrA;
  output [NUMPUPT*BITADDR-1:0]   t1_dinA;
  output [NUMPOPT-1:0]           t1_readB;
  output [NUMPOPT*BITADDR-1:0]   t1_addrB;
  input [NUMPOPT*BITADDR-1:0]    t1_doutB;
  input [NUMPOPT-1:0]            t1_fwrdB;
  input [NUMPOPT-1:0]            t1_serrB;
  input [NUMPOPT-1:0]            t1_derrB;
  input [NUMPOPT*BITPADR-1:0]    t1_padrB;

  output                         ready;
  input                          clk;
  input                          rst;

  reg ready;
  always @(posedge clk)
    ready <= !rst;

  wire               ready_wire;
  wire               vpush_wire [0:NUMPUPT-1];
  wire [BITQUEU-1:0] vpuaddr_wire [0:NUMPUPT-1];
  wire [BITADDR-1:0] vdin_wire [0:NUMPUPT-1];

  wire               vpop_wire [0:NUMPOPT-1];
  wire [BITQUEU-1:0] vpoaddr_wire [0:NUMPOPT-1];

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg [NUMPUPT-1:0] vpush_reg;
    reg [NUMPUPT*BITQUEU-1:0] vpuaddr_reg;
    reg [NUMPUPT*BITADDR-1:0] vdin_reg;
    reg [NUMPOPT-1:0] vpop_reg;
    reg [NUMPOPT*BITADDR-1:0] vpoaddr_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vpush_reg <= vpush & {NUMPUPT{ready}};
      vpuaddr_reg <= vpuaddr;
      vdin_reg <= vdin;
      vpop_reg <= vpop & {NUMPOPT{ready}};
      vpoaddr_reg <= vpoaddr;
    end

    assign ready_wire = ready_reg;
    for (np2_var=0; np2_var<NUMPUPT; np2_var=np2_var+1) begin: pu_loop
      assign vpush_wire[np2_var] = vpush_reg >> np2_var;
      assign vpuaddr_wire[np2_var] = vpuaddr_reg >> (np2_var*BITQUEU);
      assign vdin_wire[np2_var] = vdin_reg >> (np2_var*BITADDR);
    end
    for (np2_var=0; np2_var<NUMPOPT; np2_var=np2_var+1) begin: po_loop
      assign vpop_wire[np2_var] = vpop_reg >> np2_var;
      assign vpoaddr_wire[np2_var] = vpoaddr_reg >> (np2_var*BITADDR);
    end
  end else begin: noflpi_loop
    assign ready_wire = ready; 
    for (np2_var=0; np2_var<NUMPUPT; np2_var=np2_var+1) begin: pu_loop
      assign vpush_wire[np2_var] = (vpush & {NUMPUPT{ready}}) >> np2_var;
      assign vpuaddr_wire[np2_var] = vpuaddr >> (np2_var*BITQUEU);
      assign vdin_wire[np2_var] = vdin >> (np2_var*BITADDR);
    end
    for (np2_var=0; np2_var<NUMPOPT; np2_var=np2_var+1) begin: po_loop
      assign vpop_wire[np2_var] = (vpop & {NUMPOPT{ready}}) >> np2_var;
      assign vpoaddr_wire[np2_var] = vpoaddr >> (np2_var*BITADDR);
    end
  end
  endgenerate

  reg [3:0] vpuptr_wire [0:NUMPUPT-1];
  reg [3:0] vpoptr_wire [0:NUMPOPT-1];

  reg [BITADDR-1:0] queuehead [0:NUMSBFL-1][0:NUMQUEU-1];
  reg               queuefwrd [0:NUMSBFL-1][0:NUMQUEU-1];
  reg               queueserr [0:NUMSBFL-1][0:NUMQUEU-1];
  reg               queuederr [0:NUMSBFL-1][0:NUMQUEU-1];
  reg [BITPADR-1:0] queuepadr [0:NUMSBFL-1][0:NUMQUEU-1];
  reg [BITADDR-1:0] queuetail [0:NUMSBFL-1][0:NUMQUEU-1];
  reg [BITADDR:0]   queuecnt [0:NUMSBFL-1][0:NUMQUEU-1];
  reg [3:0]         queue_pu_ptr [0:NUMQUEU-1];
  reg [3:0]         queue_po_ptr [0:NUMQUEU-1];

  reg                vpop_reg [0:NUMPOPT-1][0:SRAM_DELAY-1];
  reg [BITADDR-1:0]  vpoaddr_reg [0:NUMPOPT-1][0:SRAM_DELAY-1];
  reg [3:0]          vpoptr_reg [0:NUMPOPT-1][0:SRAM_DELAY-1];
  integer vprt_int, vdel_int; 
  always @(posedge clk)
    for (vdel_int=0; vdel_int<SRAM_DELAY; vdel_int=vdel_int+1)
      for (vprt_int=0; vprt_int<NUMPOPT; vprt_int=vprt_int+1)
        if (vdel_int > 0) begin
          vpop_reg[vprt_int][vdel_int] <= vpop_reg[vprt_int][vdel_int-1];
          vpoaddr_reg[vprt_int][vdel_int] <= vpoaddr_reg[vprt_int][vdel_int-1];
          vpoptr_reg[vprt_int][vdel_int] <= vpoptr_reg[vprt_int][vdel_int-1];
        end else begin
          vpop_reg[vprt_int][vdel_int] <= vpop_wire[vprt_int] && (queuecnt[vpoptr_wire[vprt_int]][vpoaddr_wire[vprt_int]]>1);
          vpoaddr_reg[vprt_int][vdel_int] <= vpoaddr_wire[vprt_int];
          vpoptr_reg[vprt_int][vdel_int] <= vpoptr_wire[vprt_int];
        end

  reg               vpop_out [0:NUMPOPT-1];
  reg [BITADDR-1:0] vpoaddr_out [0:NUMPOPT-1];
  reg [3:0]         vpoptr_out [0:NUMPOPT-1];
  integer prto_int;
  always_comb
    for (prto_int=0; prto_int<NUMPOPT; prto_int=prto_int+1) begin
      vpop_out[prto_int] = vpop_reg[prto_int][SRAM_DELAY-1];
      vpoaddr_out[prto_int] = vpoaddr_reg[prto_int][SRAM_DELAY-1];
      vpoptr_out[prto_int] = vpoptr_reg[prto_int][SRAM_DELAY-1];
    end

  integer vptr_int, vptp_int;
  always_comb begin
    for (vptr_int=0; vptr_int<NUMPUPT; vptr_int=vptr_int+1) begin
      vpuptr_wire[vptr_int] = queue_pu_ptr[vpuaddr_wire[vptr_int]];
      for (vptp_int=0; vptp_int<vptr_int; vptp_int=vptp_int+1)
        if (vpush_wire[vptr_int] && vpush_wire[vptp_int] && (vpuaddr_wire[vptr_int]==vpuaddr_wire[vptp_int]))
          vpuptr_wire[vptr_int] = (vpuptr_wire[vptr_int]+1)%NUMSBFL;
    end
    for (vptr_int=0; vptr_int<NUMPOPT; vptr_int=vptr_int+1) begin
      vpoptr_wire[vptr_int] = queue_po_ptr[vpoaddr_wire[vptr_int]];
      for (vptp_int=0; vptp_int<vptr_int; vptp_int=vptp_int+1)
        if (vpop_wire[vptr_int] && vpop_wire[vptp_int] && (vpoaddr_wire[vptr_int]==vpoaddr_wire[vptp_int]))
          vpoptr_wire[vptr_int] = (vpoptr_wire[vptr_int]+1)%NUMSBFL;
    end
  end

  reg pwrite_wire [0:NUMPUPT-1];
  reg [BITADDR-1:0] pwraddr_wire [0:NUMPUPT-1];
  reg [BITADDR-1:0] pdin_wire [0:NUMPUPT-1];
  reg [BITADDR-1:0] pwraddr_temp [0:NUMPUPT-1];
  integer pwr_int, pwp_int;
  always_comb
    for (pwr_int=0; pwr_int<NUMPUPT; pwr_int=pwr_int+1) begin
      pwrite_wire[pwr_int] = vpush_wire[pwr_int];
      pwraddr_temp[pwr_int] = |queuecnt[vpuptr_wire[pwr_int]][vpuaddr_wire[pwr_int]] ? queuetail[vpuptr_wire[pwr_int]][vpuaddr_wire[pwr_int]] : vdin_wire[pwr_int];
      pdin_wire[pwr_int] = vdin_wire[pwr_int];
      for (pwp_int=0; pwp_int<pwr_int; pwp_int=pwp_int+1)
        if (vpush_wire[pwr_int] && vpush_wire[pwp_int] && (vpuaddr_wire[pwr_int]==vpuaddr_wire[pwp_int]) && (vpuptr_wire[pwr_int]==vpuptr_wire[pwp_int]))
          pwraddr_temp[pwr_int] = pdin_wire[pwp_int];
      pwraddr_wire[pwr_int] =  pwraddr_temp[pwr_int];
    end

  reg pread_wire [0:NUMPOPT-1];
  reg [BITADDR-1:0] prdaddr_wire [0:NUMPOPT-1];
  integer prd_int;
  always_comb
    for (prd_int=0; prd_int<NUMPOPT; prd_int=prd_int+1) begin
      pread_wire[prd_int] = vpop_wire[prd_int];
      prdaddr_wire[prd_int] = queuehead[vpoptr_wire[prd_int]][vpoaddr_wire[prd_int]];
    end

  wire pwrite_wire_0 = pwrite_wire[0];
  wire [BITADDR-1:0] pwraddr_wire_0 = pwraddr_wire[0];
  wire [BITADDR-1:0] pdin_wire_0 = pdin_wire[0];
  wire pread_wire_0 = pread_wire[0];
  wire [BITADDR-1:0] prdaddr_wire_0 = prdaddr_wire[0];

  reg [BITADDR-1:0] queuehead_next [0:NUMSBFL-1][0:NUMQUEU-1];
  reg               queuefwrd_next [0:NUMSBFL-1][0:NUMQUEU-1];
  reg               queueserr_next [0:NUMSBFL-1][0:NUMQUEU-1];
  reg               queuederr_next [0:NUMSBFL-1][0:NUMQUEU-1];
  reg [BITPADR-1:0] queuepadr_next [0:NUMSBFL-1][0:NUMQUEU-1];
  reg [BITADDR-1:0] queuetail_next [0:NUMSBFL-1][0:NUMQUEU-1];
  reg [BITADDR:0]   queuecnt_next [0:NUMSBFL-1][0:NUMQUEU-1];
  reg [3:0] queue_pu_ptr_next [0:NUMQUEU-1];
  reg [3:0] queue_po_ptr_next [0:NUMQUEU-1];
  integer qptr_int, qptp_int, qpts_int;
  always_comb begin
    for (qptr_int=0; qptr_int<NUMQUEU; qptr_int=qptr_int+1) begin
      for (qpts_int=0; qpts_int<NUMSBFL; qpts_int=qpts_int+1) begin
        queuehead_next[qpts_int][qptr_int] =  queuehead[qpts_int][qptr_int];
        queuefwrd_next[qpts_int][qptr_int] =  queuefwrd[qpts_int][qptr_int];
        queueserr_next[qpts_int][qptr_int] =  queueserr[qpts_int][qptr_int];
        queuederr_next[qpts_int][qptr_int] =  queuederr[qpts_int][qptr_int];
        queuepadr_next[qpts_int][qptr_int] =  queuepadr[qpts_int][qptr_int];
        queuetail_next[qpts_int][qptr_int] =  queuetail[qpts_int][qptr_int];
        queuecnt_next[qpts_int][qptr_int] = queuecnt[qpts_int][qptr_int];
      end
      queue_pu_ptr_next[qptr_int] = queue_pu_ptr[qptr_int];
      queue_po_ptr_next[qptr_int] = queue_po_ptr[qptr_int];
    end
    for (qptp_int=0; qptp_int<NUMPOPT; qptp_int=qptp_int+1)
      if (vpop_wire[qptp_int]) begin
        queue_po_ptr_next[vpoaddr_wire[qptp_int]] = (queue_po_ptr_next[vpoaddr_wire[qptp_int]]+1)%NUMSBFL; 
        queuecnt_next[vpoptr_wire[qptp_int]][vpoaddr_wire[qptp_int]] = queuecnt_next[vpoptr_wire[qptp_int]][vpoaddr_wire[qptp_int]]-1;
      end
    for (qptp_int=0; qptp_int<NUMPOPT; qptp_int=qptp_int+1)
      if (vpop_out[qptp_int]) begin
        queuehead_next[vpoptr_out[qptp_int]][vpoaddr_out[qptp_int]] = t1_doutB >> (qptp_int*BITADDR);
        queuefwrd_next[vpoptr_out[qptp_int]][vpoaddr_out[qptp_int]] = t1_fwrdB >> qptp_int;
        queueserr_next[vpoptr_out[qptp_int]][vpoaddr_out[qptp_int]] = t1_serrB >> qptp_int;
        queuederr_next[vpoptr_out[qptp_int]][vpoaddr_out[qptp_int]] = t1_derrB >> qptp_int;
        queuepadr_next[vpoptr_out[qptp_int]][vpoaddr_out[qptp_int]] = t1_padrB >> (qptp_int*BITPADR);
      end
    for (qptp_int=NUMPUPT-1; qptp_int>=0; qptp_int=qptp_int-1)
      if (vpush_wire[qptp_int] && ((queuecnt[vpuptr_wire[qptp_int]][vpuaddr_wire[qptp_int]]==0) ||
                                   (queuecnt_next[vpuptr_wire[qptp_int]][vpuaddr_wire[qptp_int]]==1))) begin
        queuehead_next[vpuptr_wire[qptp_int]][vpuaddr_wire[qptp_int]] = vdin_wire[qptp_int];
        queuefwrd_next[vpuptr_wire[qptp_int]][vpuaddr_wire[qptp_int]] = 1'b1;
        queueserr_next[vpuptr_wire[qptp_int]][vpuaddr_wire[qptp_int]] = 1'b0;
        queuederr_next[vpuptr_wire[qptp_int]][vpuaddr_wire[qptp_int]] = 1'b0;
        queuepadr_next[vpuptr_wire[qptp_int]][vpuaddr_wire[qptp_int]] = vdin_wire[qptp_int];
      end
    for (qptp_int=0; qptp_int<NUMPUPT; qptp_int=qptp_int+1)
      if (vpush_wire[qptp_int]) begin
        queuetail_next[vpuptr_wire[qptp_int]][vpuaddr_wire[qptp_int]] = vdin_wire[qptp_int];
        queue_pu_ptr_next[vpuaddr_wire[qptp_int]] = (queue_pu_ptr_next[vpuaddr_wire[qptp_int]]+1)%NUMSBFL; 
        queuecnt_next[vpuptr_wire[qptp_int]][vpuaddr_wire[qptp_int]] = queuecnt_next[vpuptr_wire[qptp_int]][vpuaddr_wire[qptp_int]]+1;
      end
  end

  wire [BITADDR-1:0] queuehead_0 = queuehead[0][0];
  wire [BITADDR:0] queuecnt_0 = queuecnt[0][0];
  wire [BITADDR-1:0] queuetail_0 = queuetail[0][0];
  wire [BITADDR-1:0] queuehead_next_0 = queuehead_next[0][0];
  wire [BITADDR:0] queuecnt_next_0 = queuecnt_next[0][0];
  wire [BITADDR-1:0] queuetail_next_0 = queuetail_next[0][0];
  wire [3:0] queue_pu_ptr_0 = queue_pu_ptr[0];
  wire [3:0] queue_po_ptr_0 = queue_po_ptr[0];

  wire [BITADDR-1:0] queuehead_junk = queuehead[0][0];
  wire [BITADDR:0] queuecnt_junk = queuecnt[0][0];
  wire [BITADDR-1:0] queuetail_junk = queuetail[0][0];
  wire [BITADDR-1:0] queuehead_next_junk = queuehead_next[0][0];
  wire [BITADDR:0] queuecnt_next_junk = queuecnt_next[0][0];
  wire [BITADDR-1:0] queuetail_next_junk = queuetail_next[0][0];
  wire [3:0] queue_pu_ptr_junk = queue_pu_ptr[0];
  wire [3:0] queue_po_ptr_junk = queue_po_ptr[0];

  integer qpdd_int, qpds_int;
  always @(posedge clk)
    for (qpdd_int=0; qpdd_int<NUMQUEU; qpdd_int=qpdd_int+1) begin
      for (qpds_int=0; qpds_int<NUMSBFL; qpds_int=qpds_int+1) begin
        queuehead[qpds_int][qpdd_int] <= queuehead_next[qpds_int][qpdd_int];
        queuefwrd[qpds_int][qpdd_int] <= queuefwrd_next[qpds_int][qpdd_int];
        queueserr[qpds_int][qpdd_int] <= queueserr_next[qpds_int][qpdd_int];
        queuederr[qpds_int][qpdd_int] <= queuederr_next[qpds_int][qpdd_int];
        queuepadr[qpds_int][qpdd_int] <= queuepadr_next[qpds_int][qpdd_int];
        queuetail[qpds_int][qpdd_int] <= queuetail_next[qpds_int][qpdd_int];
        if (rst)
          queuecnt[qpds_int][qpdd_int] <= 0;
        else
          queuecnt[qpds_int][qpdd_int] <= queuecnt_next[qpds_int][qpdd_int];
      end
      if (rst) begin
        queue_pu_ptr[qpdd_int] <= 0;
        queue_po_ptr[qpdd_int] <= 0;
      end else begin
        queue_pu_ptr[qpdd_int] <= queue_pu_ptr_next[qpdd_int];
        queue_po_ptr[qpdd_int] <= queue_po_ptr_next[qpdd_int];
      end
    end

  reg vpo_vld_wire [0:NUMPOPT-1];
  reg [BITADDR-1:0] vpo_dout_wire [0:NUMPOPT-1];
  reg vpo_fwrd_wire [0:NUMPOPT-1];
  reg vpo_serr_wire [0:NUMPOPT-1];
  reg vpo_derr_wire [0:NUMPOPT-1];
  reg [BITPADR-1:0] vpo_padr_wire [0:NUMPOPT-1];
  integer vdop_int;
  always_comb
    for (vdop_int=0; vdop_int<NUMPOPT; vdop_int=vdop_int+1) begin
      vpo_vld_wire[vdop_int] = vpop_wire[vdop_int];
      vpo_dout_wire[vdop_int] = queuehead[vpoptr_wire[vdop_int]][vpoaddr_wire[vdop_int]];
      vpo_fwrd_wire[vdop_int] = queuefwrd[vpoptr_wire[vdop_int]][vpoaddr_wire[vdop_int]];
      vpo_serr_wire[vdop_int] = queueserr[vpoptr_wire[vdop_int]][vpoaddr_wire[vdop_int]];
      vpo_derr_wire[vdop_int] = queuederr[vpoptr_wire[vdop_int]][vpoaddr_wire[vdop_int]];
      vpo_padr_wire[vdop_int] = queuepadr[vpoptr_wire[vdop_int]][vpoaddr_wire[vdop_int]];
    end

  reg [NUMPOPT-1:0] vpo_vld_tmp;
  reg [NUMPOPT*BITADDR-1:0] vpo_dout_tmp;
  reg [NUMPOPT-1:0] vpo_fwrd_tmp;
  reg [NUMPOPT-1:0] vpo_serr_tmp;
  reg [NUMPOPT-1:0] vpo_derr_tmp;
  reg [NUMPOPT*BITPADR-1:0] vpo_padr_tmp;
  integer vdo_int, vdow_int;
  always_comb
    for (vdo_int=0; vdo_int<NUMPOPT; vdo_int=vdo_int+1) begin
      vpo_vld_tmp[vdo_int] = vpo_vld_wire[vdo_int];
      for (vdow_int=0; vdow_int<BITADDR; vdow_int=vdow_int+1)
        vpo_dout_tmp[vdo_int*BITADDR+vdow_int] = vpo_dout_wire[vdo_int][vdow_int];
      vpo_fwrd_tmp[vdo_int] = vpo_fwrd_wire[vdo_int];
      vpo_serr_tmp[vdo_int] = vpo_serr_wire[vdo_int];
      vpo_derr_tmp[vdo_int] = vpo_derr_wire[vdo_int];
      for (vdow_int=0; vdow_int<BITPADR; vdow_int=vdow_int+1)
        vpo_padr_tmp[vdo_int*BITPADR+vdow_int] = vpo_padr_wire[vdo_int][vdow_int];
    end

  reg [NUMPOPT-1:0] vpo_vld;
  reg [NUMPOPT*BITADDR-1:0] vpo_dout;
  reg [NUMPOPT-1:0] vpo_fwrd;
  reg [NUMPOPT-1:0] vpo_serr;
  reg [NUMPOPT-1:0] vpo_derr;
  reg [NUMPOPT*BITPADR-1:0] vpo_padr;
  generate if (FLOPOUT) begin: flp_loop
    always @(posedge clk) begin
      vpo_vld <= vpo_vld_tmp;
      vpo_dout <= vpo_dout_tmp;
      vpo_fwrd <= vpo_fwrd_tmp;
      vpo_serr <= vpo_serr_tmp;
      vpo_derr <= vpo_derr_tmp;
      vpo_padr <= vpo_padr_tmp;
    end
  end else begin: nflp_loop
    always_comb begin
      vpo_vld = vpo_vld_tmp;
      vpo_dout = vpo_dout_tmp;
      vpo_fwrd = vpo_fwrd_tmp;
      vpo_serr = vpo_serr_tmp;
      vpo_derr = vpo_derr_tmp;
      vpo_padr = vpo_padr_tmp;
    end
  end
  endgenerate

  reg [NUMPUPT-1:0] t1_writeA;
  reg [NUMPUPT*BITADDR-1:0] t1_addrA;
  reg [NUMPUPT*BITADDR-1:0] t1_dinA;
  reg [NUMPOPT-1:0] t1_readB;
  reg [NUMPOPT*BITADDR-1:0] t1_addrB;
  integer t1w_int, t1wa_int, t1r_int, t1ra_int;
  always_comb begin 
    for (t1w_int=0; t1w_int<NUMPUPT; t1w_int=t1w_int+1) begin
      t1_writeA[t1w_int] = pwrite_wire[t1w_int];
      for (t1wa_int=0; t1wa_int<BITADDR; t1wa_int=t1wa_int+1)
        t1_addrA[t1w_int*BITADDR+t1wa_int] = pwraddr_wire[t1w_int][t1wa_int];
      for (t1wa_int=0; t1wa_int<BITADDR; t1wa_int=t1wa_int+1)
        t1_dinA[t1w_int*BITADDR+t1wa_int] = pdin_wire[t1w_int][t1wa_int];
    end
    for (t1r_int=0; t1r_int<NUMPOPT; t1r_int=t1r_int+1) begin
      t1_readB[t1r_int] = pread_wire[t1r_int];
      for (t1ra_int=0; t1ra_int<BITADDR; t1ra_int=t1ra_int+1)
        t1_addrB[t1r_int*BITADDR+t1ra_int] = prdaddr_wire[t1r_int][t1ra_int];
    end
  end

endmodule
