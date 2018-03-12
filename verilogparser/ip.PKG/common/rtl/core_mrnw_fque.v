module core_mrnw_fque (vpop, vpo_pvld, vpo_ptr,
                       vpush, vpu_ptr,
                       vcpread, vcpwrite, vcpaddr, vcpdin, vcpread_vld, vcpread_dout,
                       t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
                       freecnt,
                       rst_ofst, ready, clk, rst);
  
  parameter WIDTH = 32;
  parameter NUMPUPT = 1;
  parameter NUMPOPT = 1;
  parameter NUMADDR = 16;
  parameter BITADDR = 4;
  parameter BITQPTR = 5;
  parameter BITQCNT = BITADDR+1;

  parameter NUMVBNK = 2;
  parameter BITVBNK = 1;
  parameter NUMVROW = 8;
  parameter BITVROW = 3;
  
  parameter QPTR_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter NUMMXPT = (NUMPUPT > NUMPOPT) ? NUMPUPT : NUMPOPT;
  parameter FIFOCNT = (QPTR_DELAY+2);
  parameter INITCNT = (QPTR_DELAY+1);

  parameter BITCPAD = BITADDR+1;
  parameter CPUWDTH = BITADDR+BITQCNT;

  input [NUMPOPT-1:0]            vpop;
  output [NUMPOPT-1:0]           vpo_pvld;
  output [NUMPOPT*BITQPTR-1:0]   vpo_ptr;

  input [NUMPUPT-1:0]            vpush;
  input [NUMPUPT*BITQPTR-1:0]    vpu_ptr;

  input                          vcpread;
  input                          vcpwrite;
  input [BITCPAD-1:0]            vcpaddr;
  input [CPUWDTH-1:0]            vcpdin;
  output                         vcpread_vld;
  output [CPUWDTH-1:0]           vcpread_dout;

  output [NUMVBNK-1:0]           t1_writeA;
  output [NUMVBNK*BITVROW-1:0]   t1_addrA;
  output [NUMVBNK*BITQPTR-1:0]   t1_dinA;
  output [NUMVBNK-1:0]           t1_readB;
  output [NUMVBNK*BITVROW-1:0]   t1_addrB;
  input [NUMVBNK*BITQPTR-1:0]    t1_doutB;

  output [BITQCNT-1:0]           freecnt;
  input [7:0]                    rst_ofst;
  output                         ready;
  input                          clk;
  input                          rst;

  reg [BITADDR:0] rstaddr;
  reg [BITADDR-1:0] rstdin;
  wire [BITADDR:0] rstaddr_inc = rstaddr + 1;
  wire [BITADDR-1:0] rstdin_inc = rstdin + NUMVBNK;
  wire rstvld = rstaddr < NUMVROW;
  always @(posedge clk)
    if (rst) begin
      rstaddr <= 0;
      rstdin <= 0;
    end else if (rstvld) begin
      rstaddr <= rstaddr_inc;
      rstdin <= rstdin_inc;
    end

  reg ready;
  always @(posedge clk)
    ready <= !rstvld;

  wire               ready_wire;
  wire               vpush_wire [0:NUMPUPT-1];
  wire [BITQPTR-1:0] vpuptr_wire [0:NUMPUPT-1];

  wire               vpop_wire [0:NUMPOPT-1];

  wire               vcpread_wire;
  wire               vcpwrite_wire;
  wire [BITCPAD-1:0] vcpaddr_wire;
  wire [CPUWDTH-1:0] vcpdin_wire;

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg [NUMPUPT-1:0] vpush_reg;
    reg [NUMPUPT*BITQPTR-1:0] vpuptr_reg;
    reg [NUMPOPT-1:0] vpop_reg;
    reg vcpread_reg;
    reg vcpwrite_reg;
    reg [BITCPAD-1:0] vcpaddr_reg;
    reg [CPUWDTH-1:0] vcpdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vpush_reg <= vpush & {NUMPUPT{ready}};
      vpuptr_reg <= vpu_ptr;
      vpop_reg <= vpop & {NUMPOPT{ready}};
      vcpread_reg <= vcpread;
      vcpaddr_reg <= vcpaddr;
      vcpwrite_reg <= vcpwrite;
      vcpdin_reg <= vcpdin;
    end

    assign ready_wire = ready_reg;
    for (np2_var=0; np2_var<NUMPUPT; np2_var=np2_var+1) begin: pu_loop
      assign vpush_wire[np2_var] = vpush_reg >> np2_var;
      assign vpuptr_wire[np2_var] = vpuptr_reg >> (np2_var*BITQPTR);
    end
    for (np2_var=0; np2_var<NUMPOPT; np2_var=np2_var+1) begin: po_loop
      assign vpop_wire[np2_var] = vpop_reg >> np2_var;
    end
    assign vcpread_wire = vcpread_reg;
    assign vcpwrite_wire = vcpwrite_reg;
    assign vcpaddr_wire = vcpaddr_reg;
    assign vcpdin_wire = vcpdin_reg;
  end else begin: noflpi_loop
    assign ready_wire = ready; 
    for (np2_var=0; np2_var<NUMPUPT; np2_var=np2_var+1) begin: pu_loop
      assign vpush_wire[np2_var] = (vpush & {NUMPUPT{ready}}) >> np2_var;
      assign vpuptr_wire[np2_var] = vpu_ptr >> (np2_var*BITQPTR);
    end
    for (np2_var=0; np2_var<NUMPOPT; np2_var=np2_var+1) begin: po_loop
      assign vpop_wire[np2_var] = (vpop & {NUMPOPT{ready}}) >> np2_var;
    end
    assign vcpread_wire = vcpread;
    assign vcpwrite_wire = vcpwrite;
    assign vcpaddr_wire = vcpaddr;
    assign vcpdin_wire = vcpdin;
  end
  endgenerate

  reg [3:0] popcnt;
  reg [3:0] pushcnt;
  integer pcnt_int;
  always_comb begin
    popcnt = 0;
    for (pcnt_int=0; pcnt_int<NUMPOPT; pcnt_int=pcnt_int+1)
      if (vpop_wire[pcnt_int])
        popcnt = popcnt + 1;
    pushcnt = 0;
    for (pcnt_int=0; pcnt_int<NUMPUPT; pcnt_int=pcnt_int+1)
      if (vpush_wire[pcnt_int])
        pushcnt = pushcnt + 1;
  end

  reg [BITADDR-1:0] headptr;
  reg [BITQCNT-1:0] freecnt;
  always @(posedge clk)
    if (rstvld) begin
      headptr <= 0;
      freecnt <= NUMADDR;
    end else if (|popcnt || |pushcnt) begin
      headptr <= (headptr + popcnt)%NUMADDR;
      freecnt <= freecnt - popcnt + pushcnt;
    end else if (vcpwrite_wire) begin
      headptr <= vcpdin_wire >> BITQCNT;
      freecnt <= vcpdin_wire;
    end

  reg [(BITVROW+1)-1:0] pbnk_freecnt [0:NUMVBNK-1];
  reg [BITVROW-1:0] pbnk_headptr [0:NUMVBNK-1];
  reg [BITVBNK-1:0] min_bnk;
  always_comb begin 
  min_bnk = 0; 
  for(integer i=0;i<NUMVBNK;i=i+1) 
    min_bnk = (pbnk_freecnt[i] < pbnk_freecnt[min_bnk]) ? i : min_bnk;
  end

  reg vbwrite_wire [NUMVBNK-1:0];
  reg [BITQPTR-1:0] vbdin_wire [NUMVBNK-1:0];
  always_comb begin
    for (integer i=0; i<NUMVBNK; i++) 
      vbwrite_wire[i]   = 1'b0;  
    for (integer i=0; i<NUMVBNK; i++) begin
      if (i==min_bnk) begin
        vbwrite_wire[i] = vpush_wire[0];  
        vbdin_wire[i] = vpuptr_wire[0] ;
      end else begin
        vbwrite_wire[i] = 1'b0;
        vbdin_wire[i] = vpuptr_wire[0]; 
      end
    end
  end

  reg [BITVBNK - 1:0] vpop_rrptr;
  reg [BITVBNK - 1:0] vpop_rrptr_nxt;
  reg [NUMPOPT-1:0] b2p_map [0:NUMVBNK-1];
  reg vpop_bnk [0:NUMVBNK-1];
  integer pbnk,ppbnk;
  integer pua_int, pub_int;
  always_comb begin
    for (pua_int =0; pua_int<NUMPOPT; pua_int++) begin
      vpop_bnk[pua_int] = 1'b0;
      b2p_map[pua_int] = {NUMVBNK{1'b0}};
    end
    ppbnk = vpop_rrptr;
    pbnk = vpop_rrptr;
    vpop_rrptr_nxt = vpop_rrptr;
    for (pub_int=0; pub_int<NUMPOPT; pub_int++) begin
      if (vpop_wire[pub_int]) begin
        ppbnk = ((pbnk_freecnt[min_bnk] == 0) && (pbnk == min_bnk)) ? ((pbnk + 1'b1)%NUMVBNK) : pbnk; 
        vpop_bnk[ppbnk] = 1'b1;
        b2p_map[ppbnk] = pub_int;
        pbnk = (ppbnk + 1'b1)%NUMVBNK;
      end
    end
    vpop_rrptr_nxt = pbnk;
  end

  always @(posedge clk)
    vpop_rrptr <= rst ? {BITVBNK{1'b0}} : vpop_rrptr_nxt;

  reg [3:0] headptrval [0:NUMPOPT-1];
  integer head_int;
  always_comb begin
    for (head_int=0; head_int<NUMPOPT; head_int=head_int+1) begin
      if (head_int>0)
        headptrval[head_int] = headptrval[head_int-1];
      else
        headptrval[head_int] = 0;
      if ((vpop_bnk[head_int]))
        headptrval[head_int] = headptrval[head_int] + 1;
    end
  end

  reg [1:0] pwrite_sel;
  reg pwrite_wire [0:NUMVBNK-1];
  reg [BITVROW-1:0] pwraddr_wire [0:NUMVBNK-1];
  reg [BITQPTR-1:0] pdin_wire [0:NUMVBNK-1];
  integer pwr_int;
  always_comb begin
    pwrite_sel = 0;
    if (rstvld) begin
      for (pwr_int=0; pwr_int<NUMVBNK; pwr_int=pwr_int+1) begin
        pwrite_wire[pwr_int] = (rstaddr < NUMVROW) && (!rst);
        pwraddr_wire[pwr_int] = rstaddr;
        pdin_wire[pwr_int] = 0;
        if (BITQPTR > BITADDR) begin
          pdin_wire[pwr_int] = pdin_wire[pwr_int] | (rst_ofst << BITADDR);
        end
        pdin_wire[pwr_int] = pdin_wire[pwr_int] | (rstdin[BITADDR-1:0] + pwr_int);
        if (pwrite_wire[pwr_int])
          pwrite_sel = pwrite_sel + 1;
      end
    end else begin
      for (pwr_int=0; pwr_int<NUMVBNK; pwr_int=pwr_int+1) begin
        pwrite_wire[pwr_int] = vbwrite_wire[pwr_int];
        pwraddr_wire[pwr_int] = (pbnk_headptr[pwr_int] + pbnk_freecnt[pwr_int]) % NUMADDR;
        pdin_wire[pwr_int] = vbdin_wire[pwr_int];
        if (vbwrite_wire[pwr_int])
          pwrite_sel = pwrite_sel + 1;
      end
    end
  end

  reg [1:0] pread_sel;
  reg pread_wire [0:NUMVBNK-1];
  reg [BITVROW-1:0] prdaddr_wire [0:NUMVBNK-1];
  integer prd_int;
  always_comb begin
    pread_sel = 0;
    for (prd_int=0; prd_int<NUMVBNK; prd_int=prd_int+1) begin
      if(prd_int > 0)
        pread_wire[prd_int] = vpop_bnk[prd_int] && (pbnk_freecnt[prd_int] > INITCNT);
      else
        pread_wire[prd_int] = vpop_bnk[prd_int] && (pbnk_freecnt[prd_int] > INITCNT);
      prdaddr_wire[prd_int] = (pbnk_headptr[prd_int] + INITCNT) % NUMADDR;
    end
  end

  integer pfcnt;
    always @(posedge clk)
      for(pfcnt =0;pfcnt < NUMVBNK;pfcnt++) begin
        if (rstvld) begin
          pbnk_freecnt[pfcnt] <= NUMADDR/NUMVBNK;
          pbnk_headptr[pfcnt] <= 0;
        end else if (vpop_bnk[pfcnt] || pwrite_wire[pfcnt]) begin
          pbnk_freecnt[pfcnt] <= pbnk_freecnt[pfcnt] - vpop_bnk[pfcnt] +  pwrite_wire[pfcnt];
          pbnk_headptr[pfcnt] <= (pbnk_headptr[pfcnt] + vpop_bnk[pfcnt]) % NUMVROW;
        end
      end


  reg [BITQPTR-1:0] fifo_new_dat [0:NUMVBNK-1][0:FIFOCNT-1];

  reg vpo_pvld_wire [0:NUMPOPT-1];
  reg [BITQPTR-1:0] vpo_ptr_wire [0:NUMPOPT-1];
  integer vdop_int, vdox_int;
  always_comb begin
    for (integer i=0; i<NUMPOPT; i=i+1) begin
      vpo_ptr_wire[i] = 0;
    end
    for (vdop_int=0; vdop_int<NUMPOPT; vdop_int=vdop_int+1) begin
      vpo_pvld_wire[vdop_int] = vpop_wire[vdop_int];
      if(vpop_bnk[vdop_int]) begin
        vpo_ptr_wire[b2p_map[vdop_int]] = fifo_new_dat[vdop_int][0];  
      end
    end
  end

  reg [NUMPOPT-1:0] vpo_pvld_tmp;
  reg [NUMPOPT*BITQPTR-1:0] vpo_ptr_tmp;
  integer vdo_int, vdow_int;
  always_comb
    for (vdo_int=0; vdo_int<NUMPOPT; vdo_int=vdo_int+1) begin
      vpo_pvld_tmp[vdo_int] = vpo_pvld_wire[vdo_int];
      for (vdow_int=0; vdow_int<BITQPTR; vdow_int=vdow_int+1)
        vpo_ptr_tmp[vdo_int*BITQPTR+vdow_int] = vpo_ptr_wire[vdo_int][vdow_int];
    end

  reg [NUMVBNK-1:0] t1_writeA;
  reg [NUMVBNK*BITVROW-1:0] t1_addrA;
  reg [NUMVBNK*BITQPTR-1:0] t1_dinA;
  reg [NUMVBNK-1:0] t1_readB;
  reg [NUMVBNK*BITVROW-1:0] t1_addrB;

  reg t1_writeA_wire [0:NUMVBNK-1];
  reg [BITVROW-1:0] t1_addrA_wire [0:NUMVBNK-1];
  reg [BITQPTR-1:0] t1_dinA_wire [0:NUMVBNK-1];
  reg t1_readB_wire [0:NUMVBNK-1];
  reg [BITVROW-1:0] t1_addrB_wire [0:NUMVBNK-1];
  reg [BITQPTR-1:0] t1_doutB_wire [0:NUMVBNK-1];

  integer t1w_int, t1wa_int, t1r_int, t1ra_int, t1rb_int;
  always_comb begin 
    for (t1w_int=0; t1w_int<NUMVBNK; t1w_int=t1w_int+1) begin
      t1_writeA_wire[t1w_int] = pwrite_wire[t1w_int];
      t1_addrA_wire[t1w_int] = pwraddr_wire[t1w_int];
      t1_dinA_wire[t1w_int] = pdin_wire[t1w_int];
    end
    for (t1r_int=0; t1r_int<NUMVBNK; t1r_int=t1r_int+1) begin
      t1_readB_wire[t1r_int] = pread_wire[t1r_int];
      t1_addrB_wire[t1r_int] = prdaddr_wire[t1r_int];
      t1_doutB_wire[t1r_int] = t1_doutB >> (t1r_int * BITQPTR);
    end
  
    for (t1w_int=0; t1w_int<NUMVBNK; t1w_int=t1w_int+1) begin
      if (vcpwrite_wire && (vcpaddr_wire[BITCPAD-1] == t1w_int)) begin
        t1_writeA_wire[NUMVBNK-1] = 1'b1;
        t1_addrA_wire[NUMVBNK-1] = vcpaddr_wire[BITADDR-1:0];
        t1_dinA_wire[NUMVBNK-1] = vcpdin_wire;
      end
    end

    for (t1r_int=0; t1r_int<NUMVBNK; t1r_int=t1r_int+1) begin
      if (vcpread_wire && (vcpaddr_wire[BITCPAD-1] == t1r_int)) begin
        t1_readB_wire[NUMVBNK-1] = 1'b1;
        t1_addrB_wire[NUMVBNK-1] = vcpaddr_wire[BITADDR-1:0];
      end
    end
  end

  integer t1w_int1, t1r_int1;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    t1_readB = 0;
    t1_addrB = 0;
    for(t1w_int1=0 ; t1w_int1 <NUMVBNK; t1w_int1 = t1w_int1+1) begin
      if(t1_writeA_wire[t1w_int1]) begin
        t1_writeA = t1_writeA | (1'b1 << t1w_int1);
	    t1_addrA  = t1_addrA | (t1_addrA_wire[t1w_int1] << BITVROW * t1w_int1);
	    t1_dinA   = t1_dinA | (t1_dinA_wire[t1w_int1] << BITQPTR * t1w_int1);
	  end
    end
    for (t1r_int1=0; t1r_int1<NUMVBNK; t1r_int1=t1r_int1+1) begin
      if(t1_readB_wire[t1r_int1]) begin
        t1_readB = t1_readB | (1'b1 << t1r_int1);
	    t1_addrB = t1_addrB | (t1_addrB_wire[t1r_int1] << t1r_int1 * BITVROW );
      end
    end
  end

  reg               vpop_reg [0:NUMVBNK-1][0:QPTR_DELAY-1];
  reg [BITVROW-1:0] vpop_adr_reg [0:NUMVBNK-1][0:QPTR_DELAY-1];
  reg               vcpread_reg [0:QPTR_DELAY-1];
  reg [BITCPAD-1:0] vcpaddr_reg [0:QPTR_DELAY-1];
  integer vprt_int, vdel_int; 
  always @(posedge clk)
    for (vdel_int=0; vdel_int<QPTR_DELAY; vdel_int=vdel_int+1)
      if (vdel_int > 0) begin
        for (vprt_int=0; vprt_int<NUMVBNK; vprt_int=vprt_int+1) begin
          vpop_reg[vprt_int][vdel_int] <= vpop_reg[vprt_int][vdel_int-1];
          vpop_adr_reg[vprt_int][vdel_int] <= vpop_adr_reg[vprt_int][vdel_int-1];
        end
        vcpread_reg[vdel_int] <= vcpread_reg[vdel_int-1];
        vcpaddr_reg[vdel_int] <= vcpaddr_reg[vdel_int-1];
      end else begin
        for (vprt_int=0; vprt_int<NUMVBNK; vprt_int=vprt_int+1) begin
	      if(vprt_int > 0)
            vpop_reg[vprt_int][vdel_int] <= vpop_bnk[vprt_int] && (pbnk_freecnt[vprt_int] > INITCNT); 
	      else
            vpop_reg[vprt_int][vdel_int] <= vpop_bnk[vprt_int] && (pbnk_freecnt[vprt_int] > INITCNT);
          vpop_adr_reg[vprt_int][vdel_int] <= prdaddr_wire[vprt_int];
        end
        vcpread_reg[vdel_int] <= vcpread_wire;
        vcpaddr_reg[vdel_int] <= vcpaddr_wire;
      end

  reg               vpop_out [0:NUMVBNK-1];
  reg [BITVROW-1:0] vpop_adr_out [0:NUMVBNK-1];
  reg               vcpread_out;
  reg [BITCPAD-1:0] vcpaddr_out;
  integer prto_int;
  always_comb
    for (prto_int=0; prto_int<NUMVBNK; prto_int=prto_int+1) begin
      vpop_out[prto_int] = vpop_reg[prto_int][QPTR_DELAY-1];
      vpop_adr_out[prto_int] = vpop_adr_reg[prto_int][QPTR_DELAY-1];
      vcpread_out = vcpread_reg[QPTR_DELAY-1];
      vcpaddr_out = vcpaddr_reg[QPTR_DELAY-1];
    end

  wire vcp_vld_wire = vcpread_out;
  wire vcp_dout_wire = vcpaddr_out[BITCPAD-1] ? t1_doutB[BITQPTR-1:0] : {headptr,freecnt};

  reg [NUMPOPT-1:0] vpo_pvld;
  reg [NUMPOPT*BITQPTR-1:0] vpo_ptr;
  reg vcpread_vld;
  reg [CPUWDTH-1:0] vcpread_dout;
  generate if (FLOPOUT) begin: flp_loop
    always @(posedge clk) begin
      vpo_pvld <= vpo_pvld_tmp;
      vpo_ptr <= vpo_ptr_tmp;
      vcpread_vld <= vcp_vld_wire;
      vcpread_dout <= vcp_dout_wire;
    end
  end else begin: nflp_loop
    always_comb begin
      vpo_pvld = vpo_pvld_tmp;
      vpo_ptr = vpo_ptr_tmp;
      vcpread_vld = vcp_vld_wire;
      vcpread_dout = vcp_dout_wire;
    end
  end
  endgenerate

  genvar bnk_var;
  generate for (bnk_var=0; bnk_var<NUMVBNK; bnk_var=bnk_var+1) begin : bnk_loop
    integer wffo_int,wffo_int1;
    reg [BITQPTR-1:0] fifo_new_dat_next [0:FIFOCNT-1];
    always_comb begin
      for (wffo_int=0; wffo_int<FIFOCNT; wffo_int=wffo_int+1) begin: wffo_loop
        if (|vpop_bnk[bnk_var] && (wffo_int<(FIFOCNT-vpop_bnk[bnk_var])))
          fifo_new_dat_next[wffo_int] = fifo_new_dat[bnk_var][wffo_int+vpop_bnk[bnk_var]];
        else begin
          fifo_new_dat_next[wffo_int] = fifo_new_dat[bnk_var][wffo_int];
        end
        if (t1_writeA_wire[bnk_var] && (t1_addrA_wire[bnk_var] == ((pbnk_headptr[bnk_var]+wffo_int+vpop_bnk[bnk_var])%NUMVROW)))
          fifo_new_dat_next[wffo_int] = t1_dinA_wire[bnk_var];
        if (vpop_out[bnk_var] && (vpop_adr_out[bnk_var] == ((pbnk_headptr[bnk_var]+wffo_int+vpop_bnk[bnk_var])%NUMVROW)))
          fifo_new_dat_next[wffo_int] = t1_doutB_wire[bnk_var];
        if (rst)
          fifo_new_dat_next[wffo_int] = (NUMVBNK*wffo_int) + bnk_var;
      end
    end

    always @(posedge clk) begin
      for (wffo_int1=0; wffo_int1<FIFOCNT; wffo_int1=wffo_int1+1)
        fifo_new_dat[bnk_var][wffo_int1] <= fifo_new_dat_next[wffo_int1];
    end
  end
  endgenerate

endmodule
