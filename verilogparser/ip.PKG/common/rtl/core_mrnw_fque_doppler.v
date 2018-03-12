module core_mrnw_fque_doppler (vpop, vpo_pvld, vpo_ptr,
                       vpush, vpu_ptr,
                       vcpread, vcpwrite, vcpaddr, vcpdin, vcpread_vld, vcpread_dout,
                       t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
                       freecnt,
                       ready, clk, rst);
  
  parameter WIDTH = 32;
  parameter NUMPORT = 1;
  parameter NUMADDR = 16;
  parameter BITADDR = 4;
  parameter BITQPTR = 5;
  parameter BITQCNT = BITADDR+1;

  parameter BITPORT = 1;
  parameter NUMVROW = 8;
  parameter BITVROW = 3;
  
  parameter QPTR_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter FIFOCNT = QPTR_DELAY+2;
  parameter INITCNT = QPTR_DELAY+1;

  parameter BITCPAD = BITADDR+1;
  parameter CPUWDTH = BITADDR+BITQCNT;

  input  [NUMPORT-1:0]           vpop;
  output [NUMPORT-1:0]           vpo_pvld;
  output [NUMPORT*BITQPTR-1:0]   vpo_ptr;

  input  [NUMPORT-1:0]           vpush;
  input  [NUMPORT*BITQPTR-1:0]   vpu_ptr;

  input                          vcpread;
  input                          vcpwrite;
  input  [BITCPAD-1:0]           vcpaddr;
  input  [CPUWDTH-1:0]           vcpdin;
  output                         vcpread_vld;
  output [CPUWDTH-1:0]           vcpread_dout;

  output [NUMPORT-1:0]           t1_writeA;
  output [NUMPORT*BITVROW-1:0]   t1_addrA;
  output [NUMPORT*BITQPTR-1:0]   t1_dinA;
  output [NUMPORT-1:0]           t1_readB;
  output [NUMPORT*BITVROW-1:0]   t1_addrB;
  input  [NUMPORT*BITQPTR-1:0]   t1_doutB;

  output [BITQCNT-1:0]           freecnt;
  output                         ready;
  input                          clk;
  input                          rst;

  reg  [BITADDR:0]   rstaddr;
  reg  [BITADDR-1:0] rstdin;
  wire [BITADDR:0]   rstaddr_inc = rstaddr + 1;
  wire [BITADDR-1:0] rstdin_inc  = rstdin + NUMPORT;
  wire               rstvld      = rstaddr < NUMVROW;
  always @(posedge clk)
    if (rst) begin
      rstaddr <= 0;
      rstdin  <= 0;
    end else if (rstvld) begin
      rstaddr <= rstaddr_inc;
      rstdin  <= rstdin_inc;
    end

  reg ready;
  always @(posedge clk)
    ready <= !rstvld;

  wire               ready_wire;
  wire               vpush_wire  [0:NUMPORT-1];
  wire [BITQPTR-1:0] vpuptr_wire [0:NUMPORT-1];

  wire               vpop_wire   [0:NUMPORT-1];

  wire               vcpread_wire;
  wire               vcpwrite_wire;
  wire [BITCPAD-1:0] vcpaddr_wire;
  wire [CPUWDTH-1:0] vcpdin_wire;

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg                       ready_reg;
    reg [NUMPORT-1:0]         vpush_reg;
    reg [NUMPORT*BITQPTR-1:0] vpuptr_reg;
    reg [NUMPORT-1:0]         vpop_reg;
    reg                       vcpread_reg;
    reg                       vcpwrite_reg;
    reg [BITCPAD-1:0]         vcpaddr_reg;
    reg [CPUWDTH-1:0]         vcpdin_reg;
    always @(posedge clk) begin
      ready_reg    <= ready;
      vpush_reg    <= vpush & {NUMPORT{ready}};
      vpuptr_reg   <= vpu_ptr;
      vpop_reg     <= vpop & {NUMPORT{ready}};
      vcpread_reg  <= vcpread;
      vcpaddr_reg  <= vcpaddr;
      vcpwrite_reg <= vcpwrite;
      vcpdin_reg   <= vcpdin;
    end

    assign ready_wire = ready_reg;
    for (np2_var=0; np2_var<NUMPORT; np2_var=np2_var+1) begin: pu_loop
      assign vpush_wire[np2_var]  = vpush_reg >> np2_var;
      assign vpuptr_wire[np2_var] = vpuptr_reg >> (np2_var*BITQPTR);
    end
    for (np2_var=0; np2_var<NUMPORT; np2_var=np2_var+1) begin: po_loop
      assign vpop_wire[np2_var] = vpop_reg >> np2_var;
    end
    assign vcpread_wire  = vcpread_reg;
    assign vcpwrite_wire = vcpwrite_reg;
    assign vcpaddr_wire  = vcpaddr_reg;
    assign vcpdin_wire   = vcpdin_reg;
  end else begin: noflpi_loop
    assign ready_wire = ready; 
    for (np2_var=0; np2_var<NUMPORT; np2_var=np2_var+1) begin: pu_loop
      assign vpush_wire[np2_var]  = (vpush & {NUMPORT{ready}}) >> np2_var;
      assign vpuptr_wire[np2_var] = vpu_ptr >> (np2_var*BITQPTR);
    end
    for (np2_var=0; np2_var<NUMPORT; np2_var=np2_var+1) begin: po_loop
      assign vpop_wire[np2_var] = (vpop & {NUMPORT{ready}}) >> np2_var;
    end
    assign vcpread_wire  = vcpread;
    assign vcpwrite_wire = vcpwrite;
    assign vcpaddr_wire  = vcpaddr;
    assign vcpdin_wire   = vcpdin;
  end
  endgenerate

  reg [3:0] popcnt;
  reg [3:0] pushcnt;
  always_comb begin
    popcnt = 0;
    for (integer pcnt_int=0; pcnt_int<NUMPORT; pcnt_int=pcnt_int+1)
      if (vpop_wire[pcnt_int])
        popcnt = popcnt + 1;
    pushcnt = 0;
    for (integer pcnt_int=0; pcnt_int<NUMPORT; pcnt_int=pcnt_int+1)
      if (vpush_wire[pcnt_int])
        pushcnt = pushcnt + 1;
  end

  reg [BITQCNT-1:0] freecnt;
  always @(posedge clk)
    if (rstvld) begin
      freecnt <= NUMADDR;
    end else if (|popcnt || |pushcnt) begin
      freecnt <= freecnt - popcnt + pushcnt;
    end else if (vcpwrite_wire) begin
      freecnt <= vcpdin_wire;
    end

  reg [(BITVROW+1)-1:0] pbnk_freecnt [0:NUMPORT-1];
  reg [BITVROW-1:0]     pbnk_headptr [0:NUMPORT-1];
  reg [BITPORT-1:0]     min_bnk;
  reg [BITPORT-1:0]     max_bnk;
  always_comb begin 
    min_bnk = 0; 
    max_bnk = 0; 
    for(integer i=0;i<NUMPORT;i=i+1)  begin
      min_bnk = (pbnk_freecnt[i] < pbnk_freecnt[min_bnk]) ? i : min_bnk;
      max_bnk = (pbnk_freecnt[i] > pbnk_freecnt[max_bnk]) ? i : max_bnk;
    end
  end

  reg               vbwrite_wire [NUMPORT-1:0];
  reg [BITQPTR-1:0] vbdin_wire [NUMPORT-1:0];
  integer           min_bnk_nxt;
  always_comb begin
    for (integer i=0; i<NUMPORT; i++) begin
      vbwrite_wire[i] = 1'b0;  
      vbdin_wire[i]   = 0;
    end
    min_bnk_nxt = min_bnk;
    for (integer i=0; i<NUMPORT; i++) begin
      vbwrite_wire[min_bnk_nxt] = vpush_wire[i];  
      vbdin_wire[min_bnk_nxt]   = vpuptr_wire[i] ;
      min_bnk_nxt               = (min_bnk_nxt+vpush_wire[i]) % NUMPORT;
    end
  end

  reg [NUMPORT-1:0] b2p_map [0:NUMPORT-1];
  reg               vpop_bnk [0:NUMPORT-1];
  integer           max_bnk_nxt;
  always_comb begin
    for (integer pua_int =0; pua_int<NUMPORT; pua_int++) begin
      vpop_bnk[pua_int] = 1'b0;
      b2p_map[pua_int] = {NUMPORT{1'b0}};
    end
    max_bnk_nxt = max_bnk;
    for (integer pub_int=0; pub_int<NUMPORT; pub_int++) begin
      if (vpop_wire[pub_int] && (freecnt > 0)) begin
        vpop_bnk[max_bnk_nxt] = 1'b1;
        b2p_map[max_bnk_nxt] = pub_int;
        max_bnk_nxt = (max_bnk_nxt + 1'b1)%NUMPORT;
      end
    end
  end

  reg [3:0] headptrval [0:NUMPORT-1];
  always_comb begin
    for (integer head_int=0; head_int<NUMPORT; head_int=head_int+1) begin
      if (head_int>0)
        headptrval[head_int] = headptrval[head_int-1];
      else
        headptrval[head_int] = 0;
      if ((vpop_bnk[head_int]))
        headptrval[head_int] = headptrval[head_int] + 1;
    end
  end

  reg [1:0] pwrite_sel;
  reg pwrite_wire [0:NUMPORT-1];
  reg [BITVROW-1:0] pwraddr_wire [0:NUMPORT-1];
  reg [BITQPTR-1:0] pdin_wire [0:NUMPORT-1];
  always_comb begin
    pwrite_sel = 0;
    if (rstvld) begin
      for (integer pwr_int=0; pwr_int<NUMPORT; pwr_int=pwr_int+1) begin
        pwrite_wire[pwr_int] = (rstaddr < NUMVROW) && (!rst);
        pwraddr_wire[pwr_int] = rstaddr;
        pdin_wire[pwr_int] = 0;
        pdin_wire[pwr_int] = pdin_wire[pwr_int] | (rstdin[BITADDR-1:0] + pwr_int);
        if (pwrite_wire[pwr_int])
          pwrite_sel = pwrite_sel + 1;
      end
    end else begin
      for (integer pwr_int=0; pwr_int<NUMPORT; pwr_int=pwr_int+1) begin
        pwrite_wire[pwr_int] = vbwrite_wire[pwr_int];
        pwraddr_wire[pwr_int] = (pbnk_headptr[pwr_int] + pbnk_freecnt[pwr_int]) % NUMVROW;
        pdin_wire[pwr_int] = vbdin_wire[pwr_int];
        if (vbwrite_wire[pwr_int])
          pwrite_sel = pwrite_sel + 1;
      end
    end
  end

  reg [1:0] pread_sel;
  reg pread_wire [0:NUMPORT-1];
  reg [BITVROW-1:0] prdaddr_wire [0:NUMPORT-1];
  always_comb begin
    pread_sel = 0;
    for (integer prd_int=0; prd_int<NUMPORT; prd_int=prd_int+1) begin
      if(prd_int > 0)
        pread_wire[prd_int] = vpop_bnk[prd_int] && (pbnk_freecnt[prd_int] > INITCNT);
      else
        pread_wire[prd_int] = vpop_bnk[prd_int] && (pbnk_freecnt[prd_int] > INITCNT);
      prdaddr_wire[prd_int] = (pbnk_headptr[prd_int] + INITCNT) % NUMVROW;
    end
  end

    always @(posedge clk)
      for(integer pfcnt =0;pfcnt < NUMPORT;pfcnt++) begin
        if (rstvld) begin
          pbnk_freecnt[pfcnt] <= NUMVROW;
          pbnk_headptr[pfcnt] <= 0;
        end else if (vpop_bnk[pfcnt] || pwrite_wire[pfcnt]) begin
          pbnk_freecnt[pfcnt] <= pbnk_freecnt[pfcnt] - vpop_bnk[pfcnt] +  pwrite_wire[pfcnt];
          pbnk_headptr[pfcnt] <= (pbnk_headptr[pfcnt] + vpop_bnk[pfcnt]) % NUMVROW;
        end
      end


  reg [BITQPTR-1:0] fifo_new_dat [0:NUMPORT-1][0:FIFOCNT-1];

  reg vpo_pvld_wire [0:NUMPORT-1];
  reg [BITQPTR-1:0] vpo_ptr_wire [0:NUMPORT-1];
  always_comb begin
    for (integer i=0; i<NUMPORT; i=i+1) begin
      vpo_ptr_wire[i] = 0;
    end
    for (integer vdop_int=0; vdop_int<NUMPORT; vdop_int=vdop_int+1) begin
      vpo_pvld_wire[vdop_int] = vpop_wire[vdop_int];
      if(vpop_bnk[vdop_int]) begin
        vpo_ptr_wire[b2p_map[vdop_int]] = fifo_new_dat[vdop_int][0];  
      end
    end
  end

  reg [NUMPORT-1:0] vpo_pvld_tmp;
  reg [NUMPORT*BITQPTR-1:0] vpo_ptr_tmp;
  always_comb
    for (integer vdo_int=0; vdo_int<NUMPORT; vdo_int=vdo_int+1) begin
      vpo_pvld_tmp[vdo_int] = vpo_pvld_wire[vdo_int];
      for (integer vdow_int=0; vdow_int<BITQPTR; vdow_int=vdow_int+1)
        vpo_ptr_tmp[vdo_int*BITQPTR+vdow_int] = vpo_ptr_wire[vdo_int][vdow_int];
    end

  reg [NUMPORT-1:0]         t1_writeA;
  reg [NUMPORT*BITVROW-1:0] t1_addrA;
  reg [NUMPORT*BITQPTR-1:0] t1_dinA;
  reg [NUMPORT-1:0]         t1_readB;
  reg [NUMPORT*BITVROW-1:0] t1_addrB;

  reg               t1_writeA_wire [0:NUMPORT-1];
  reg [BITVROW-1:0] t1_addrA_wire  [0:NUMPORT-1];
  reg [BITQPTR-1:0] t1_dinA_wire   [0:NUMPORT-1];
  reg               t1_readB_wire  [0:NUMPORT-1];
  reg [BITVROW-1:0] t1_addrB_wire  [0:NUMPORT-1];
  reg [BITQPTR-1:0] t1_doutB_wire  [0:NUMPORT-1];

  always_comb begin 
    for (integer t1w_int=0; t1w_int<NUMPORT; t1w_int=t1w_int+1) begin
      t1_writeA_wire[t1w_int] = pwrite_wire[t1w_int];
      t1_addrA_wire[t1w_int] = pwraddr_wire[t1w_int];
      t1_dinA_wire[t1w_int] = pdin_wire[t1w_int];
    end
    for (integer t1r_int=0; t1r_int<NUMPORT; t1r_int=t1r_int+1) begin
      t1_readB_wire[t1r_int] = pread_wire[t1r_int];
      t1_addrB_wire[t1r_int] = prdaddr_wire[t1r_int];
      t1_doutB_wire[t1r_int] = t1_doutB >> (t1r_int * BITQPTR);
    end
  
    for (integer t1w_int=0; t1w_int<NUMPORT; t1w_int=t1w_int+1) begin
      if (vcpwrite_wire && (vcpaddr_wire[BITCPAD-1] == t1w_int)) begin
        t1_writeA_wire[NUMPORT-1] = 1'b1;
        t1_addrA_wire[NUMPORT-1] = vcpaddr_wire[BITADDR-1:0];
        t1_dinA_wire[NUMPORT-1] = vcpdin_wire;
      end
    end

    for (integer t1r_int=0; t1r_int<NUMPORT; t1r_int=t1r_int+1) begin
      if (vcpread_wire && (vcpaddr_wire[BITCPAD-1] == t1r_int)) begin
        t1_readB_wire[NUMPORT-1] = 1'b1;
        t1_addrB_wire[NUMPORT-1] = vcpaddr_wire[BITADDR-1:0];
      end
    end
  end

  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    t1_readB = 0;
    t1_addrB = 0;
    for(integer t1w_int1=0 ; t1w_int1 <NUMPORT; t1w_int1 = t1w_int1+1) begin
      if(t1_writeA_wire[t1w_int1]) begin
        t1_writeA = t1_writeA | (1'b1 << t1w_int1);
	    t1_addrA  = t1_addrA | (t1_addrA_wire[t1w_int1] << BITVROW * t1w_int1);
	    t1_dinA   = t1_dinA | (t1_dinA_wire[t1w_int1] << BITQPTR * t1w_int1);
	  end
    end
    for (integer t1r_int1=0; t1r_int1<NUMPORT; t1r_int1=t1r_int1+1) begin
      if(t1_readB_wire[t1r_int1]) begin
        t1_readB = t1_readB | (1'b1 << t1r_int1);
	    t1_addrB = t1_addrB | (t1_addrB_wire[t1r_int1] << t1r_int1 * BITVROW );
      end
    end
  end

  reg               vpop_reg [0:NUMPORT-1][0:QPTR_DELAY-1];
  reg [BITVROW-1:0] vpop_adr_reg [0:NUMPORT-1][0:QPTR_DELAY-1];
  reg               vcpread_reg [0:QPTR_DELAY-1];
  reg [BITCPAD-1:0] vcpaddr_reg [0:QPTR_DELAY-1];
  always @(posedge clk)
    for (integer vdel_int=0; vdel_int<QPTR_DELAY; vdel_int=vdel_int+1)
      if (vdel_int > 0) begin
        for (integer vprt_int=0; vprt_int<NUMPORT; vprt_int=vprt_int+1) begin
          vpop_reg[vprt_int][vdel_int] <= vpop_reg[vprt_int][vdel_int-1];
          vpop_adr_reg[vprt_int][vdel_int] <= vpop_adr_reg[vprt_int][vdel_int-1];
        end
        vcpread_reg[vdel_int] <= vcpread_reg[vdel_int-1];
        vcpaddr_reg[vdel_int] <= vcpaddr_reg[vdel_int-1];
      end else begin
        for (integer vprt_int=0; vprt_int<NUMPORT; vprt_int=vprt_int+1) begin
	      if(vprt_int > 0)
            vpop_reg[vprt_int][vdel_int] <= vpop_bnk[vprt_int] && (pbnk_freecnt[vprt_int] > INITCNT); 
	      else
            vpop_reg[vprt_int][vdel_int] <= vpop_bnk[vprt_int] && (pbnk_freecnt[vprt_int] > INITCNT);
          vpop_adr_reg[vprt_int][vdel_int] <= prdaddr_wire[vprt_int];
        end
        vcpread_reg[vdel_int] <= vcpread_wire;
        vcpaddr_reg[vdel_int] <= vcpaddr_wire;
      end

  reg               vpop_out [0:NUMPORT-1];
  reg [BITVROW-1:0] vpop_adr_out [0:NUMPORT-1];
  reg               vcpread_out;
  reg [BITCPAD-1:0] vcpaddr_out;
  always_comb
    for (integer prto_int=0; prto_int<NUMPORT; prto_int=prto_int+1) begin
      vpop_out[prto_int] = vpop_reg[prto_int][QPTR_DELAY-1];
      vpop_adr_out[prto_int] = vpop_adr_reg[prto_int][QPTR_DELAY-1];
      vcpread_out = vcpread_reg[QPTR_DELAY-1];
      vcpaddr_out = vcpaddr_reg[QPTR_DELAY-1];
    end

  wire vcp_vld_wire = vcpread_out;
  wire vcp_dout_wire = vcpaddr_out[BITCPAD-1] ? t1_doutB[BITQPTR-1:0] : {freecnt};

  reg [NUMPORT-1:0] vpo_pvld;
  reg [NUMPORT*BITQPTR-1:0] vpo_ptr;
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
  generate for (bnk_var=0; bnk_var<NUMPORT; bnk_var=bnk_var+1) begin : bnk_loop
    reg [BITQPTR-1:0] fifo_new_dat_next [0:FIFOCNT-1];
    always_comb begin
      for (integer wffo_int=0; wffo_int<FIFOCNT; wffo_int=wffo_int+1) begin: wffo_loop
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
          fifo_new_dat_next[wffo_int] = (NUMPORT*wffo_int) + bnk_var;
      end
    end

    always @(posedge clk) begin
      for (integer wffo_int1=0; wffo_int1<FIFOCNT; wffo_int1=wffo_int1+1)
        fifo_new_dat[bnk_var][wffo_int1] <= fifo_new_dat_next[wffo_int1];
    end
  end
  endgenerate

endmodule
