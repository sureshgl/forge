module core_ncor1a_1r1w (vcnt, vctaddr, vimm, vcnt_vld, vcnt_serr, vcnt_derr,
                         vread, vwrite, vaddr, vdin, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                         t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                         ready, clk, rst);

  parameter BITWDTH = 5;
  parameter WIDTH = 32;
  parameter NUMSCNT = 1;
  parameter NUMCTPT = 2;
  parameter BITCTPT = 1;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter BITPBNK = 4;
  parameter BITPADR = BITCTPT+BITADDR;
  parameter CNTWDTH = WIDTH/NUMSCNT;
  parameter SRAM_DELAY = 2;
  parameter FLOPADD = 0;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  input [NUMCTPT-1:0]                vcnt;
  input [NUMCTPT*BITADDR-1:0]        vctaddr;
  input [NUMCTPT*WIDTH-1:0]          vimm;
  output [NUMCTPT-1:0]               vcnt_vld;
  output [NUMCTPT-1:0]               vcnt_serr;
  output [NUMCTPT-1:0]               vcnt_derr;

  input                              vread;
  input                              vwrite;
  input [BITADDR-1:0]                vaddr;
  input [WIDTH-1:0]                  vdin;
  output                             vread_vld;
  output [WIDTH-1:0]                 vdout;
  output                             vread_fwrd;
  output                             vread_serr;
  output                             vread_derr;
  output [BITPADR-1:0]               vread_padr;

  output [NUMCTPT-1:0] t1_writeA;
  output [NUMCTPT*BITADDR-1:0] t1_addrA;
  output [NUMCTPT*WIDTH-1:0] t1_dinA;
  
  output [NUMCTPT-1:0] t1_readB;
  output [NUMCTPT*BITADDR-1:0] t1_addrB;
  input [NUMCTPT*WIDTH-1:0] t1_doutB;
  input [NUMCTPT-1:0] t1_fwrdB;
  input [NUMCTPT-1:0] t1_serrB;
  input [NUMCTPT-1:0] t1_derrB;
  input [NUMCTPT*(BITPADR-BITCTPT)-1:0] t1_padrB;
  
  output                             ready;
  input                              clk;
  input                              rst;

  reg [BITADDR:0] rstaddr;
  wire rstvld = (rstaddr < NUMADDR);
  always @(posedge clk)
    if (rst)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;

  reg ready;
  always @(posedge clk)
    ready <= !rstvld;

  wire ready_wire;

  wire vcnt_wire [0:NUMCTPT-1];
  wire [BITADDR-1:0] vctaddr_wire [0:NUMCTPT-1];
  wire [WIDTH-1:0] vimm_wire [0:NUMCTPT-1];

  wire vread_wire;
  wire vwrite_wire;
  wire [BITADDR-1:0] vaddr_wire;
  wire [WIDTH-1:0] vdin_wire;

  genvar flp_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg [NUMCTPT-1:0] vcnt_reg;
    reg [NUMCTPT*BITADDR-1:0] vctaddr_reg;
    reg [NUMCTPT*WIDTH-1:0] vimm_reg;
    reg vread_reg;
    reg vwrite_reg;
    reg [BITADDR-1:0] vaddr_reg;
    reg [WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vcnt_reg <= vcnt & {NUMCTPT{ready}};
      vctaddr_reg <= vctaddr;
      vimm_reg <= vimm;
      vread_reg <= vread && ready;
      vwrite_reg <= vwrite && ready;
      vaddr_reg <= vaddr;
      vdin_reg <= vdin;
    end

    assign ready_wire = ready_reg;
    for (flp_var=0; flp_var<NUMCTPT; flp_var=flp_var+1) begin: ct_loop
      assign vcnt_wire[flp_var] = vcnt_reg[flp_var] && (vctaddr_wire[flp_var]<NUMADDR);
      assign vctaddr_wire[flp_var] = vctaddr_reg >> (flp_var*BITADDR);
      assign vimm_wire[flp_var] = vimm_reg >> (flp_var*WIDTH);
    end

    assign vread_wire = vread_reg && (vaddr_reg<NUMADDR);
    assign vwrite_wire = vwrite_reg && (vaddr_reg<NUMADDR);
    assign vaddr_wire = vaddr_reg;
    assign vdin_wire = vdin_reg;
  end else begin: noflpi_loop
    assign ready_wire = ready;
    for (flp_var=0; flp_var<NUMCTPT; flp_var=flp_var+1) begin: ct_loop
      assign vcnt_wire[flp_var] = vcnt[flp_var] && (vctaddr_wire[flp_var]<NUMADDR) && ready;
      assign vctaddr_wire[flp_var] = vctaddr >> (flp_var*BITADDR);
      assign vimm_wire[flp_var] = vimm >> (flp_var*WIDTH);
    end

    assign vread_wire = vread && (vaddr<NUMADDR) && ready;
    assign vwrite_wire = vwrite && (vaddr<NUMADDR) && ready;
    assign vaddr_wire = vaddr;
    assign vdin_wire = vdin;
  end
  endgenerate

  reg                vcnt_reg [0:NUMCTPT-1][0:SRAM_DELAY-1];
  reg [BITADDR-1:0]  vctaddr_reg [0:NUMCTPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0]    vimm_reg [0:NUMCTPT-1][0:SRAM_DELAY-1];
  reg                vread_reg [0:SRAM_DELAY-1];
  reg                vwrite_reg [0:SRAM_DELAY-1];
  reg [BITADDR-1:0]  vaddr_reg [0:SRAM_DELAY-1];
  reg [WIDTH-1:0]    vdin_reg [0:SRAM_DELAY-1];

  integer vdel_int, vprt_int;
  always @(posedge clk) 
    for (vdel_int=0; vdel_int<SRAM_DELAY; vdel_int=vdel_int+1)
      if (vdel_int>0) begin
        for (vprt_int=0; vprt_int<NUMCTPT; vprt_int=vprt_int+1) begin
          vcnt_reg[vprt_int][vdel_int] <= vcnt_reg[vprt_int][vdel_int-1];
          vctaddr_reg[vprt_int][vdel_int] <= vctaddr_reg[vprt_int][vdel_int-1];
          vimm_reg[vprt_int][vdel_int] <= vimm_reg[vprt_int][vdel_int-1];
        end
        vread_reg[vdel_int] <= vread_reg[vdel_int-1];
        vwrite_reg[vdel_int] <= vwrite_reg[vdel_int-1];
        vaddr_reg[vdel_int] <= vaddr_reg[vdel_int-1];
        vdin_reg[vdel_int] <= vdin_reg[vdel_int-1];
      end else begin
        for (vprt_int=0; vprt_int<NUMCTPT; vprt_int=vprt_int+1) begin
          vcnt_reg[vprt_int][vdel_int] <= vcnt_wire[vprt_int] && (vctaddr_wire[vprt_int] < NUMADDR) && ready;
          vctaddr_reg[vprt_int][vdel_int] <= vctaddr_wire[vprt_int];
          vimm_reg[vprt_int][vdel_int] <= vimm_wire[vprt_int];
        end
        vread_reg[vdel_int] <= vread_wire;
        vwrite_reg[vdel_int] <= vwrite_wire && (vaddr_wire < NUMADDR) && ready;
        vaddr_reg[vdel_int] <= vaddr_wire;
        vdin_reg[vdel_int] <= vdin_wire;          
      end

  reg               vcnt_out[0:NUMCTPT-1];
  reg [BITADDR-1:0] vctaddr_out[0:NUMCTPT-1];
  reg [WIDTH-1:0]   vimm_out[0:NUMCTPT-1];
  integer vout_int;
  always_comb
    for (vout_int=0; vout_int<NUMCTPT; vout_int=vout_int+1) begin
      vcnt_out[vout_int] = vcnt_reg[vout_int][SRAM_DELAY-1];
      vctaddr_out[vout_int] = vctaddr_reg[vout_int][SRAM_DELAY-1];
      vimm_out[vout_int] = vimm_reg[vout_int][SRAM_DELAY-1];
    end

  wire               vread_out = vread_reg[SRAM_DELAY-1];
  wire               vwrite_out = vwrite_reg[SRAM_DELAY-1];
  wire [BITADDR-1:0] vaddr_out = vaddr_reg[SRAM_DELAY-1];
  wire [WIDTH-1:0]   vdin_out = vdin_reg[SRAM_DELAY-1];       

  // Read request of pivoted data on DRAM memory
  reg               pwrite [0:NUMCTPT-1];
  reg [BITADDR-1:0] pwraddr [0:NUMCTPT-1];
  reg [WIDTH-1:0]   pdin [0:NUMCTPT-1];
  reg [CNTWDTH:0]   pdin_temp [0:NUMCTPT-1][0:NUMSCNT-1];

  reg [NUMCTPT-1:0] t1_readB;
  reg [NUMCTPT*BITADDR-1:0] t1_addrB;
  integer t1rd_int;
  always_comb begin
    t1_readB = 0;
    t1_addrB = 0;
    for (t1rd_int=0; t1rd_int<NUMCTPT; t1rd_int=t1rd_int+1)
      if (rstvld && !rst) begin
        t1_readB = t1_readB | (1'b1 << t1rd_int);
        t1_addrB = t1_addrB | (rstaddr[BITADDR-1:0] << (t1rd_int*BITADDR));
      end else if (vread_wire || vwrite_wire/* && !(pwrite[t1rd_int] && (pwraddr[t1rd_int] == vaddr_wire))*/) begin
        t1_readB = t1_readB | (1'b1 << t1rd_int);
        t1_addrB = t1_addrB | (vaddr_wire << (t1rd_int*BITADDR));
      end else if (vcnt_wire[t1rd_int]/* && !(pwrite[t1rd_int] && (pwraddr[t1rd_int] == vctaddr_wire[t1rd_int]))*/) begin
        t1_readB = t1_readB | (1'b1 << t1rd_int);
        t1_addrB = t1_addrB | (vctaddr_wire[t1rd_int] << (t1rd_int*BITADDR));
      end
  end

  reg [WIDTH-1:0]           pdout_wire [0:NUMCTPT-1];
  reg                       pfwrd_wire [0:NUMCTPT-1];
  reg                       pserr_wire [0:NUMCTPT-1];
  reg                       pderr_wire [0:NUMCTPT-1];
  reg [BITPADR-BITCTPT-1:0] ppadr_wire [0:NUMCTPT-1];
  integer pdo_int;
  always_comb
    for (pdo_int=0; pdo_int<NUMCTPT; pdo_int=pdo_int+1) begin
      pdout_wire[pdo_int] = t1_doutB >> (pdo_int*WIDTH);
      pfwrd_wire[pdo_int] = t1_fwrdB >> pdo_int;
      pserr_wire[pdo_int] = t1_serrB >> pdo_int;
      pderr_wire[pdo_int] = t1_derrB >> pdo_int;
      ppadr_wire[pdo_int] = t1_padrB >> (pdo_int*(BITPADR-BITCTPT));
    end

  reg              cnt_vld [0:NUMCTPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0]  cnt_reg [0:NUMCTPT-1][0:SRAM_DELAY-1];
  integer cprt_int, cdel_int;
  always @(posedge clk) 
    for (cprt_int=0; cprt_int<NUMCTPT; cprt_int=cprt_int+1)
      for (cdel_int=0; cdel_int<SRAM_DELAY; cdel_int=cdel_int+1)
        if (cdel_int>0) begin
          if (pwrite[cprt_int] && vcnt_reg[cprt_int][cdel_int-1] && (pwraddr[cprt_int] == vctaddr_reg[cprt_int][cdel_int-1])) begin
            cnt_vld[cprt_int][cdel_int] <= 1'b1;
            cnt_reg[cprt_int][cdel_int] <= pdin[cprt_int];
          end else begin
            cnt_vld[cprt_int][cdel_int] <= cnt_vld[cprt_int][cdel_int-1];
            cnt_reg[cprt_int][cdel_int] <= cnt_reg[cprt_int][cdel_int-1];            
          end
        end else begin
          if (pwrite[cprt_int] && vcnt_wire[cprt_int] && (pwraddr[cprt_int] == vctaddr_wire[cprt_int])) begin
            cnt_vld[cprt_int][cdel_int] <= 1'b1;
            cnt_reg[cprt_int][cdel_int] <= pdin[cprt_int];
          end else begin
            cnt_vld[cprt_int][cdel_int] <= 1'b0;
            cnt_reg[cprt_int][cdel_int] <= 0;
          end
        end

  reg              rdcnt_vld [0:NUMCTPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0]  rdcnt_reg [0:NUMCTPT-1][0:SRAM_DELAY-1];
  integer rprt_int, rdel_int;
  always @(posedge clk) 
    for (rprt_int=0; rprt_int<NUMCTPT; rprt_int=rprt_int+1)
      for (rdel_int=0; rdel_int<SRAM_DELAY; rdel_int=rdel_int+1)
        if (rdel_int>0) begin
          if (pwrite[rprt_int] && vread_reg[rdel_int-1] && (pwraddr[rprt_int] == vaddr_reg[rdel_int-1])) begin
            rdcnt_vld[rprt_int][rdel_int] <= 1'b1;
            rdcnt_reg[rprt_int][rdel_int] <= pdin[rprt_int];
          end else begin
            rdcnt_vld[rprt_int][rdel_int] <= rdcnt_vld[rprt_int][rdel_int-1];
            rdcnt_reg[rprt_int][rdel_int] <= rdcnt_reg[rprt_int][rdel_int-1];            
          end
        end else begin
          if (pwrite[rprt_int] && vread_wire && (pwraddr[rprt_int] == vaddr_wire)) begin
            rdcnt_vld[rprt_int][rdel_int] <= 1'b1;
            rdcnt_reg[rprt_int][rdel_int] <= pdin[rprt_int];
          end else begin
            rdcnt_vld[rprt_int][rdel_int] <= 1'b0;
            rdcnt_reg[rprt_int][rdel_int] <= 0;
          end
        end

  reg [WIDTH-1:0] cnt_out [0:NUMCTPT-1];
  reg [WIDTH-1:0] rdcnt_out [0:NUMCTPT-1];
  integer cnto_int;
  always_comb
    for (cnto_int=0; cnto_int<NUMCTPT; cnto_int=cnto_int+1) begin
      cnt_out[cnto_int] = cnt_vld[cnto_int][SRAM_DELAY-1] ? cnt_reg[cnto_int][SRAM_DELAY-1] : pdout_wire[cnto_int];
      rdcnt_out[cnto_int] = rdcnt_vld[cnto_int][SRAM_DELAY-1] ? rdcnt_reg[cnto_int][SRAM_DELAY-1] : pdout_wire[cnto_int];
    end

  reg [NUMCTPT-1:0] vcnt_vld_wire;
  reg [NUMCTPT-1:0] vcnt_serr_wire;
  reg [NUMCTPT-1:0] vcnt_derr_wire;
  integer vco_int;
  always_comb
    for (vco_int=0; vco_int<NUMCTPT; vco_int=vco_int+1) begin
      vcnt_vld_wire[vco_int] = vcnt_out[vco_int];
      vcnt_serr_wire[vco_int] = pserr_wire[vco_int];
      vcnt_derr_wire[vco_int] = pderr_wire[vco_int];
    end
/*      
  wire vread_vld_wire = vread_out;
  reg [CNTWDTH-1:0] vdout_wire [0:NUMSCNT-1][0:1];
  reg [CNTWDTH-1:0] rdcnt_wire [0:NUMCTPT-1][0:NUMSCNT-1];
  reg vread_fwrd_wire;
  reg vread_ferr_wire;
  reg vread_serr_wire;
  reg vread_derr_wire;
  reg [BITPADR-1:0] vread_padr_wire;
  reg [CNTWDTH:0] vdout_cnt [0:NUMSCNT-1][0:1];
  integer vdo_int, vdoc_int;
  always_comb begin
    vread_fwrd_wire = 0;
    for (vdoc_int=0; vdoc_int<NUMSCNT; vdoc_int=vdoc_int+1) begin
      vdout_wire[vdoc_int][0] = 0;
      vdout_wire[vdoc_int][1] = 0;
    end
    for (vdo_int=0; vdo_int<NUMCTPT; vdo_int=vdo_int+1) begin
      vread_fwrd_wire = vread_fwrd_wire || (vread_out && (rdcnt_vld[vdo_int][SRAM_DELAY-1] || pfwrd_wire[vdo_int]));
    end
    for (vdo_int=0; vdo_int<NUMCTPT; vdo_int=vdo_int+2)
      for (vdoc_int=0; vdoc_int<NUMSCNT; vdoc_int=vdoc_int+1) begin
         rdcnt_wire[vdo_int][vdoc_int] = rdcnt_out[vdo_int] >> (vdoc_int*CNTWDTH);
         vdout_cnt[vdoc_int][0] = vdout_wire[vdoc_int][0] + rdcnt_wire[vdo_int][vdoc_int];
         vdout_wire[vdoc_int][0] = {|vdout_cnt[vdoc_int][0][CNTWDTH:CNTWDTH-1],vdout_cnt[vdoc_int][0][CNTWDTH-2:0]};
      end
    for (vdo_int=1; vdo_int<NUMCTPT; vdo_int=vdo_int+2)
      for (vdoc_int=0; vdoc_int<NUMSCNT; vdoc_int=vdoc_int+1) begin
         rdcnt_wire[vdo_int][vdoc_int] = rdcnt_out[vdo_int] >> (vdoc_int*CNTWDTH);
         vdout_cnt[vdoc_int][1] = vdout_wire[vdoc_int][1] + rdcnt_wire[vdo_int][vdoc_int];
         vdout_wire[vdoc_int][1] = {|vdout_cnt[vdoc_int][1][CNTWDTH:CNTWDTH-1],vdout_cnt[vdoc_int][1][CNTWDTH-2:0]};
      end
    vread_padr_wire = padr_wire[0];
    vread_ferr_wire = 0;
    vread_serr_wire = 0;
    vread_derr_wire = 0; 
    for (vdo_int=NUMCTPT-1; vdo_int>=0; vdo_int=vdo_int-1)
      if (pserr_wire[vdo_int]) begin
        vread_ferr_wire = vread_ferr_wire || (vread_out && !(rdcnt_vld[vdo_int][SRAM_DELAY-1] || pfwrd_wire[vdo_int])); 
        vread_serr_wire = 1'b1;
        vread_padr_wire = {vdo_int,padr_wire[vdo_int]};
      end
    for (vdo_int=NUMCTPT-1; vdo_int>=0; vdo_int=vdo_int-1)
      if (pderr_wire[vdo_int]) begin
        vread_ferr_wire = vread_ferr_wire || (vread_out && !(rdcnt_vld[vdo_int][SRAM_DELAY-1] || pfwrd_wire[vdo_int])); 
        vread_derr_wire = 1'b1;
        vread_padr_wire = {vdo_int,padr_wire[vdo_int]};
      end
    vread_fwrd_wire = vread_fwrd_wire && !vread_ferr_wire;
  end
*/
  reg vread_vld_next [0:3];
  reg [CNTWDTH-1:0] vdout_next [0:(1<<BITCTPT)-1][0:NUMSCNT-1][0:3];
  reg vread_ferr_next [0:(1<<BITCTPT)-1][0:3];
  reg vread_fwrd_next [0:(1<<BITCTPT)-1][0:3];
  reg vread_serr_next [0:(1<<BITCTPT)-1][0:3];
  reg vread_derr_next [0:(1<<BITCTPT)-1][0:3];
  reg [BITPADR-1:0] vread_padr_next [0:(1<<BITCTPT)-1][0:3];
  reg vread_vld_wire [0:3];
  reg [CNTWDTH:0] vdout_wire [0:(1<<BITCTPT)-1][0:NUMSCNT-1][0:3];
  reg vread_ferr_wire [0:(1<<BITCTPT)-1][0:3];
  reg vread_fwrd_wire [0:(1<<BITCTPT)-1][0:3];
  reg vread_serr_wire [0:(1<<BITCTPT)-1][0:3];
  reg vread_derr_wire [0:(1<<BITCTPT)-1][0:3];
  reg [BITPADR-1:0] vread_padr_wire [0:(1<<BITCTPT)-1][0:3];

  genvar vdo_var, vdoc_var, vdos_var;
  generate for (vdos_var=0; vdos_var<4; vdos_var=vdos_var+1) begin: vdos_loop
    if (vdos_var>0) begin: mid_loop
      if (vdos_var<=FLOPADD) begin: flp_loop
        integer vdo_int, vdoc_int;
        always @(posedge clk) begin
          vread_vld_next[vdos_var] <= vread_vld_wire[vdos_var-1];
          for (vdo_int=0; (1<<vdos_var)*vdo_int<(1<<BITCTPT); vdo_int=vdo_int+1) begin
            for (vdoc_int=0; vdoc_int<NUMSCNT; vdoc_int=vdoc_int+1)
              vdout_next[vdo_int][vdoc_int][vdos_var] <= vdout_wire[vdo_int][vdoc_int][vdos_var-1];
            vread_ferr_next[vdo_int][vdos_var] <= vread_ferr_wire[vdo_int][vdos_var-1];
            vread_fwrd_next[vdo_int][vdos_var] <= vread_fwrd_wire[vdo_int][vdos_var-1];
            vread_serr_next[vdo_int][vdos_var] <= vread_serr_wire[vdo_int][vdos_var-1];
            vread_derr_next[vdo_int][vdos_var] <= vread_derr_wire[vdo_int][vdos_var-1];
            vread_padr_next[vdo_int][vdos_var] <= vread_padr_wire[vdo_int][vdos_var-1];
          end
        end
      end else begin: nflp_loop
        integer vdo_int, vdoc_int;
        always_comb begin
          vread_vld_next[vdos_var] <= vread_vld_wire[vdos_var-1];
          for (vdo_int=0; (1<<vdos_var)*vdo_int<(1<<BITCTPT); vdo_int=vdo_int+1) begin
            for (vdoc_int=0; vdoc_int<NUMSCNT; vdoc_int=vdoc_int+1)
              vdout_next[vdo_int][vdoc_int][vdos_var] = vdout_wire[vdo_int][vdoc_int][vdos_var-1];
            vread_ferr_next[vdo_int][vdos_var] = vread_ferr_wire[vdo_int][vdos_var-1];
            vread_fwrd_next[vdo_int][vdos_var] = vread_fwrd_wire[vdo_int][vdos_var-1];
            vread_serr_next[vdo_int][vdos_var] = vread_serr_wire[vdo_int][vdos_var-1];
            vread_derr_next[vdo_int][vdos_var] = vread_derr_wire[vdo_int][vdos_var-1];
            vread_padr_next[vdo_int][vdos_var] = vread_padr_wire[vdo_int][vdos_var-1];
          end
        end
      end
    end else begin: init_loop
      integer vdo_int, vdoc_int;
      always_comb begin
        vread_vld_next[vdos_var] = vread_out;
        for (vdo_int=0; vdo_int<(1<<BITCTPT); vdo_int=vdo_int+1)
          if (vdo_int<NUMCTPT) begin
            for (vdoc_int=0; vdoc_int<NUMSCNT; vdoc_int=vdoc_int+1)
              vdout_next[vdo_int][vdoc_int][vdos_var] = rdcnt_out[vdo_int] >> (vdoc_int*CNTWDTH);
            vread_ferr_next[vdo_int][vdos_var] = vread_out && !(rdcnt_vld[vdo_int][SRAM_DELAY-1] || pfwrd_wire[vdo_int]);
            vread_fwrd_next[vdo_int][vdos_var] = vread_out && (rdcnt_vld[vdo_int][SRAM_DELAY-1] || pfwrd_wire[vdo_int]);
            vread_serr_next[vdo_int][vdos_var] = pserr_wire[vdo_int];
            vread_derr_next[vdo_int][vdos_var] = pderr_wire[vdo_int]; 
            vread_padr_next[vdo_int][vdos_var] = ppadr_wire[vdo_int];
          end else begin
            for (vdoc_int=0; vdoc_int<NUMSCNT; vdoc_int=vdoc_int+1)
              vdout_next[vdo_int][vdoc_int][vdos_var] = 0;
            vread_ferr_next[vdo_int][vdos_var] = 1'b0;
            vread_fwrd_next[vdo_int][vdos_var] = 1'b0;
            vread_serr_next[vdo_int][vdos_var] = 1'b0;
            vread_derr_next[vdo_int][vdos_var] = 1'b0;
            vread_padr_next[vdo_int][vdos_var] = 0;
          end
      end
    end
  end
  endgenerate
        
  integer vdo_int, vdoc_int, vdos_int, vdob_int;
  always_comb
    for (vdos_int=0; vdos_int<4; vdos_int=vdos_int+1) begin
      vread_vld_wire[vdos_int] = vread_vld_next[vdos_int];
      for (vdo_int=0; ((2<<vdos_int)*vdo_int)<(1<<BITCTPT); vdo_int=vdo_int+1) begin
        for (vdoc_int=0; vdoc_int<NUMSCNT; vdoc_int=vdoc_int+1)
          vdout_wire[vdo_int][vdoc_int][vdos_int] = 0;
        vread_ferr_wire[vdo_int][vdos_int] = 0;
        vread_fwrd_wire[vdo_int][vdos_int] = 0;
        vread_serr_wire[vdo_int][vdos_int] = 0;
        vread_derr_wire[vdo_int][vdos_int] = 0; 
        vread_padr_wire[vdo_int][vdos_int] = vread_padr_next[vdo_int][vdos_int];
        for (vdob_int=0; vdob_int<2; vdob_int=vdob_int+1) begin
          for (vdoc_int=0; vdoc_int<NUMSCNT; vdoc_int=vdoc_int+1)
            vdout_wire[vdo_int][vdoc_int][vdos_int] = vdout_wire[vdo_int][vdoc_int][vdos_int] + vdout_next[2*vdo_int+vdob_int][vdoc_int][vdos_int];
          vread_fwrd_wire[vdo_int][vdos_int] = vread_fwrd_wire[vdo_int][vdos_int] + vread_fwrd_next[2*vdo_int+vdob_int][vdos_int]; 
          if (vread_serr_next[2*vdo_int+vdob_int][vdos_int]) begin
            vread_ferr_wire[vdo_int][vdos_int] = vread_ferr_wire[vdo_int][vdos_int] || vread_ferr_next[2*vdo_int+vdob_int][vdos_int];
            vread_serr_wire[vdo_int][vdos_int] = 1'b1;
            vread_padr_wire[vdo_int][vdos_int] = vread_padr_next[2*vdo_int+vdob_int][vdos_int];
          end
          if (vread_derr_next[2*vdo_int+vdob_int][vdos_int]) begin
            vread_ferr_wire[vdo_int][vdos_int] = vread_ferr_wire[vdo_int][vdos_int] || vread_ferr_next[2*vdo_int+vdob_int][vdos_int];
            vread_derr_wire[vdo_int][vdos_int] = 1'b1;
            vread_padr_wire[vdo_int][vdos_int] = vread_padr_next[2*vdo_int+vdob_int][vdos_int];
          end
        end
        for (vdoc_int=0; vdoc_int<NUMSCNT; vdoc_int=vdoc_int+1)
          vdout_wire[vdo_int][vdoc_int][vdos_int] = {|vdout_wire[vdo_int][vdoc_int][vdos_int][CNTWDTH:CNTWDTH-1],
                                                     vdout_wire[vdo_int][vdoc_int][vdos_int][CNTWDTH-2:0]};
      end
    end

  reg [NUMCTPT-1:0] vcnt_vld_temp;
  reg [NUMCTPT-1:0] vcnt_serr_temp;
  reg [NUMCTPT-1:0] vcnt_derr_temp;
  reg vread_vld_temp;
  reg [WIDTH-1:0] vdout_temp;
  reg vread_fwrd_temp;
  reg vread_serr_temp;
  reg vread_derr_temp;
  reg [BITPADR-1:0] vread_padr_temp;
    
  integer flpa_int;
  always_comb begin
    vcnt_vld_temp = vcnt_vld_wire;
    vcnt_serr_temp = vcnt_serr_wire;
    vcnt_derr_temp = vcnt_derr_wire;
    vread_vld_temp = vread_vld_wire[2];
    vdout_temp = 0;
    for (flpa_int=0; flpa_int<NUMSCNT; flpa_int=flpa_int+1) begin
      vdout_temp = vdout_temp | (vdout_wire[0][flpa_int][2] << (flpa_int*CNTWDTH));
    end
    vread_fwrd_temp = vread_fwrd_wire[0][2] && vread_ferr_wire[0][2];
    vread_serr_temp = vread_serr_wire[0][2];
    vread_derr_temp = vread_derr_wire[0][2];
    vread_padr_temp = vread_padr_wire[0][2];
  end

/*
  reg [NUMCTPT-1:0] vcnt_vld_temp;
  reg [NUMCTPT-1:0] vcnt_serr_temp;
  reg [NUMCTPT-1:0] vcnt_derr_temp;
  reg vread_vld_temp;
  reg [WIDTH-1:0] vdout_temp;
  reg vread_fwrd_temp;
  reg vread_serr_temp;
  reg vread_derr_temp;
  reg [BITPADR-1:0] vread_padr_temp;
  generate if (FLOPADD==2) begin: flpa2_loop
  end else if (FLOPADD==1) begin: flpa_loop
    reg [CNTWDTH-1:0] vdout_cnt_temp [0:NUMSCNT-1][0:1];
    
    integer flpa_int;
    always @(posedge clk) begin
      vcnt_vld_temp <= vcnt_vld_wire;
      vcnt_serr_temp <= vcnt_serr_wire;
      vcnt_derr_temp <= vcnt_derr_wire;
      vread_vld_temp <= vread_vld_wire;
      for (flpa_int=0; flpa_int<NUMSCNT; flpa_int=flpa_int+1) begin
        vdout_cnt_temp[flpa_int][0] <= vdout_wire[flpa_int][0];
        vdout_cnt_temp[flpa_int][1] <= vdout_wire[flpa_int][1];
      end
      vread_fwrd_temp <= vread_fwrd_wire;
      vread_serr_temp <= vread_serr_wire;
      vread_derr_temp <= vread_derr_wire;
      vread_padr_temp <= vread_padr_wire;
    end

    reg [CNTWDTH:0] vdout_add_temp [0:NUMSCNT-1];
    integer fadd_int;
    always_comb begin
      vdout_temp = 0;
      for (fadd_int=0; fadd_int<NUMSCNT; fadd_int=fadd_int+1) begin
        vdout_add_temp[fadd_int] = vdout_cnt_temp[fadd_int][0] + vdout_cnt_temp[fadd_int][1];
        vdout_temp = vdout_temp | ({|vdout_add_temp[fadd_int][CNTWDTH:CNTWDTH-1],vdout_add_temp[fadd_int][CNTWDTH-2:0]} << (fadd_int*CNTWDTH));
      end
    end
  end else begin: nflpa_loop
    reg [CNTWDTH-1:0] vdout_cnt_temp [0:NUMSCNT-1][0:1];
    
    integer flpa_int;
    always_comb begin
      vcnt_vld_temp = vcnt_vld_wire;
      vcnt_serr_temp = vcnt_serr_wire;
      vcnt_derr_temp = vcnt_derr_wire;
      vread_vld_temp = vread_vld_wire;
      for (flpa_int=0; flpa_int<NUMSCNT; flpa_int=flpa_int+1) begin
        vdout_cnt_temp[flpa_int][0] = vdout_wire[flpa_int][0];
        vdout_cnt_temp[flpa_int][1] = vdout_wire[flpa_int][1];
      end
      vread_fwrd_temp = vread_fwrd_wire;
      vread_serr_temp = vread_serr_wire;
      vread_derr_temp = vread_derr_wire;
      vread_padr_temp = vread_padr_wire;
    end

    reg [CNTWDTH:0] vdout_add_temp [0:NUMSCNT-1];
    integer fadd_int;
    always_comb begin
      vdout_temp = 0;
      for (fadd_int=0; fadd_int<NUMSCNT; fadd_int=fadd_int+1) begin
        vdout_add_temp[fadd_int] = vdout_cnt_temp[fadd_int][0] + vdout_cnt_temp[fadd_int][1];
        vdout_temp = vdout_temp | ({|vdout_add_temp[fadd_int][CNTWDTH:CNTWDTH-1],vdout_add_temp[fadd_int][CNTWDTH-2:0]} << (fadd_int*CNTWDTH));
      end
    end
  end
  endgenerate
*/      
  reg [NUMCTPT-1:0] vcnt_vld;
  reg [NUMCTPT-1:0] vcnt_serr;
  reg [NUMCTPT-1:0] vcnt_derr;
  reg               vread_vld;
  reg [WIDTH-1:0]   vdout;
  reg               vread_fwrd;
  reg               vread_serr;
  reg               vread_derr;
  reg [BITPADR-1:0] vread_padr;
  generate if (FLOPOUT) begin: flpo_loop
    always @(posedge clk) begin
      vcnt_vld <= vcnt_vld_temp;
      vcnt_serr <= vcnt_serr_temp;
      vcnt_derr <= vcnt_derr_temp;
      vread_vld <= vread_vld_temp;
      vdout <= vdout_temp; 
      vread_fwrd <= vread_fwrd_temp;
      vread_serr <= vread_serr_temp;
      vread_derr <= vread_derr_temp;
      vread_padr <= vread_padr_temp;
    end
  end else begin: nflpo_loop
    always_comb begin
      vcnt_vld = vcnt_vld_temp;
      vcnt_serr = vcnt_serr_temp;
      vcnt_derr = vcnt_derr_temp;
      vread_vld = vread_vld_temp;
      vdout = vdout_temp;
      vread_fwrd = vread_fwrd_temp;
      vread_serr = vread_serr_temp;
      vread_derr = vread_derr_temp;
      vread_padr = vread_padr_temp;
    end
  end
  endgenerate

  reg               rstvld_reg [0:SRAM_DELAY-1];
  reg [BITADDR-1:0] rstaddr_reg [0:SRAM_DELAY-1];
  integer rst_int;
  always @(posedge clk)
    for (rst_int=0; rst_int<SRAM_DELAY; rst_int=rst_int+1)
      if (rst_int>0) begin
        rstvld_reg[rst_int] <= rstvld_reg[rst_int-1];
        rstaddr_reg[rst_int] <= rstaddr_reg[rst_int-1];
      end else begin
        rstvld_reg[rst_int] <= rstvld && !rst;
        rstaddr_reg[rst_int] <= rstaddr;
      end

  reg [CNTWDTH-1:0] cnt_help [0:NUMCTPT-1][0:NUMSCNT-1];
  reg [CNTWDTH-1:0] vimm_help [0:NUMCTPT-1][0:NUMSCNT-1];
  wire [BITCTPT-1:0] rand_bank = 0;
  integer pwr_int, pwc_int;
  always_comb
    for (pwr_int=0; pwr_int<NUMCTPT; pwr_int=pwr_int+1) begin
      for (pwc_int=0; pwc_int<NUMSCNT; pwc_int=pwc_int+1) begin
        cnt_help[pwr_int][pwc_int] = 0;
        vimm_help[pwr_int][pwc_int] = 0;
      end
      if (rstvld_reg[SRAM_DELAY-1]) begin
        pwrite[pwr_int] = 1'b1;
        pwraddr[pwr_int] = rstaddr_reg[SRAM_DELAY-1];
        for (pwc_int=0; pwc_int<NUMSCNT; pwc_int=pwc_int+1)
          pdin_temp[pwr_int][pwc_int] = 0;
      end else if (vwrite_out) begin
        pwrite[pwr_int] = 1'b1;
        pwraddr[pwr_int] = vaddr_out;
        for (pwc_int=0; pwc_int<NUMSCNT; pwc_int=pwc_int+1)
          if (pwr_int==rand_bank)
            pdin_temp[pwr_int][pwc_int] = (vdin_out >> (pwc_int*CNTWDTH)) & {CNTWDTH{1'b1}};
          else
            pdin_temp[pwr_int][pwc_int] = 0;
      end else if (vcnt_out[pwr_int]) begin
        pwrite[pwr_int] = !pderr_wire[pwr_int];
//        pwrite[pwr_int] = 1'b1;
        pwraddr[pwr_int] = vctaddr_out[pwr_int];
        for (pwc_int=0; pwc_int<NUMSCNT; pwc_int=pwc_int+1) begin
          cnt_help[pwr_int][pwc_int] = cnt_out[pwr_int] >> (pwc_int*CNTWDTH);
          vimm_help[pwr_int][pwc_int] = vimm_out[pwr_int] >> (pwc_int*CNTWDTH);
          pdin_temp[pwr_int][pwc_int] = cnt_help[pwr_int][pwc_int] + vimm_help[pwr_int][pwc_int];
        end
      end else begin
        pwrite[pwr_int] = 1'b0;
        pwraddr[pwr_int] = 0;
        for (pwc_int=0; pwc_int<NUMSCNT; pwc_int=pwc_int+1)
          pdin_temp[pwr_int][pwc_int] = 0;
      end
      pdin[pwr_int] = 0;
      for (pwc_int=0; pwc_int<NUMSCNT; pwc_int=pwc_int+1)
        pdin[pwr_int] = pdin[pwr_int] | ({|pdin_temp[pwr_int][pwc_int][CNTWDTH:CNTWDTH-1],pdin_temp[pwr_int][pwc_int][CNTWDTH-2:0]} << (pwc_int*CNTWDTH));
    end
/*
  wire vcnt_out_0 = vcnt_out[0];
  wire vcnt_out_1 = vcnt_out[1];
  wire vcnt_out_2 = vcnt_out[2];
  wire vcnt_out_3 = vcnt_out[3];
  wire pwrite_0 = pwrite[0];
  wire pwrite_1 = pwrite[1];
  wire pwrite_2 = pwrite[2];
  wire pwrite_3 = pwrite[3];
*/
  reg [NUMCTPT-1:0] t1_writeA;
  reg [NUMCTPT*BITADDR-1:0] t1_addrA;
  reg [NUMCTPT*WIDTH-1:0] t1_dinA;
  integer t1wp_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    for (t1wp_int=0; t1wp_int<NUMCTPT; t1wp_int=t1wp_int+1)
      if (pwrite[t1wp_int]) begin
        t1_writeA = t1_writeA | (1'b1 << t1wp_int);
        t1_addrA = t1_addrA | (pwraddr[t1wp_int] << (t1wp_int*BITADDR));
        t1_dinA = t1_dinA | (pdin[t1wp_int] << (t1wp_int*WIDTH));
      end
  end

endmodule



