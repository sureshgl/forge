module core_nrw_1r1w (vread, vwrite, vaddr, vdin, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                      t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                      ready, clk, rst);

  parameter BITWDTH = 5;
  parameter WIDTH = 32;
  parameter NUMRWPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMPBNK = 4;     // NUMRWPT*NUMRWPT
  parameter BITPBNK = 2;
  parameter BITPADR = BITPBNK+BITADDR;
  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  input [NUMRWPT-1:0]                vread;
  input [NUMRWPT-1:0]                vwrite;
  input [NUMRWPT*BITADDR-1:0]        vaddr;
  input [NUMRWPT*WIDTH-1:0]          vdin;
  output [NUMRWPT-1:0]               vread_vld;
  output [NUMRWPT*WIDTH-1:0]         vdout;
  output [NUMRWPT-1:0]               vread_fwrd;
  output [NUMRWPT-1:0]               vread_serr;
  output [NUMRWPT-1:0]               vread_derr;
  output [NUMRWPT*BITPADR-1:0]       vread_padr;

  output [NUMPBNK-1:0]               t1_writeA;
  output [NUMPBNK*BITADDR-1:0]       t1_addrA;
  output [NUMPBNK*WIDTH-1:0]         t1_dinA;
  
  output [NUMPBNK-1:0]               t1_readB;
  output [NUMPBNK*BITADDR-1:0]       t1_addrB;
  input [NUMPBNK*WIDTH-1:0]          t1_doutB;
  input [NUMPBNK-1:0]                t1_fwrdB;
  input [NUMPBNK-1:0]                t1_serrB;
  input [NUMPBNK-1:0]                t1_derrB;
  input [NUMPBNK*(BITPADR-BITPBNK)-1:0] t1_padrB;
  
  output                                ready;
  input                                 clk;
  input                                 rst;

  reg [BITADDR:0]                       rstaddr;
  wire                                  rstvld = (rstaddr < NUMADDR);
  always @(posedge clk)
    if (rst)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;

  reg                                   ready;
  always @(posedge clk)
    ready <= !rstvld;

  wire                                  ready_wire;

  wire                                  vread_wire [0:NUMRWPT-1];
  wire                                  vwrite_wire [0:NUMRWPT-1];
  wire [BITADDR-1:0]                    vaddr_wire [0:NUMRWPT-1];
  wire [WIDTH-1:0]                      vdin_wire [0:NUMRWPT-1];

  genvar                                flp_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg [NUMRWPT-1:0] vread_reg;
    reg [NUMRWPT-1:0] vwrite_reg;
    reg [NUMRWPT*BITADDR-1:0] vaddr_reg;
    reg [NUMRWPT*WIDTH-1:0]   vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vread_reg <= vread && {NUMRWPT{ready}};
      vwrite_reg <= vwrite && {NUMRWPT{ready}};
      vaddr_reg <= vaddr;
      vdin_reg <= vdin;
    end

    assign ready_wire = ready_reg;
    for (flp_var=0; flp_var<NUMRWPT; flp_var=flp_var+1) begin: ct_loop
      assign vread_wire[flp_var] = vread_reg[flp_var] && (vaddr_wire[flp_var]<NUMADDR);
      assign vwrite_wire[flp_var] = vwrite_reg[flp_var] && (vaddr_wire[flp_var]<NUMADDR);
      assign vaddr_wire[flp_var] = vaddr_reg >> (flp_var*BITADDR);
      assign vdin_wire[flp_var] = vdin_reg >> (flp_var*WIDTH);
    end
  end else begin: noflpi_loop
    assign ready_wire = ready;
    for (flp_var=0; flp_var<NUMRWPT; flp_var=flp_var+1) begin: ct_loop
      assign vread_wire[flp_var] = vread[flp_var] && (vaddr_wire[flp_var]<NUMADDR) && ready;
      assign vwrite_wire[flp_var] = vwrite[flp_var] && (vaddr_wire[flp_var]<NUMADDR) && ready;
      assign vaddr_wire[flp_var] = vaddr >> (flp_var*BITADDR);
      assign vdin_wire[flp_var] = vdin >> (flp_var*WIDTH);
    end
  end
  endgenerate

  reg                vread_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg                vwrite_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [BITADDR-1:0]  vaddr_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0]    vdin_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  integer            vdel_int, vprt_int;
  always @(posedge clk) 
    for (vdel_int=0; vdel_int<SRAM_DELAY; vdel_int=vdel_int+1)
      if (vdel_int>0) begin
        for (vprt_int=0; vprt_int<NUMRWPT; vprt_int=vprt_int+1) begin
          vread_reg[vprt_int][vdel_int] <= vread_reg[vprt_int][vdel_int-1];
          vwrite_reg[vprt_int][vdel_int] <= vwrite_reg[vprt_int][vdel_int-1];
          vaddr_reg[vprt_int][vdel_int] <= vaddr_reg[vprt_int][vdel_int-1];
          vdin_reg[vprt_int][vdel_int] <= vdin_reg[vprt_int][vdel_int-1];
        end
      end else begin
        for (vprt_int=0; vprt_int<NUMRWPT; vprt_int=vprt_int+1) begin
          vread_reg[vprt_int][vdel_int] <= vread_wire[vprt_int];
          vwrite_reg[vprt_int][vdel_int] <= vwrite_wire[vprt_int];
          vaddr_reg[vprt_int][vdel_int] <= vaddr_wire[vprt_int];
          vdin_reg[vprt_int][vdel_int] <= vdin_wire[vprt_int];
        end
      end

  reg               vread_out [0:NUMRWPT-1];
  reg               vwrite_out [0:NUMRWPT-1];
  reg [BITADDR-1:0] vaddr_out [0:NUMRWPT-1];
  reg [WIDTH-1:0]   vdin_out [0:NUMRWPT-1];
  integer vout_int, vwpt_int;
  always_comb
    for (vout_int=0; vout_int<NUMRWPT; vout_int=vout_int+1) begin
      vread_out[vout_int] = vread_reg[vout_int][SRAM_DELAY-1];
      vwrite_out[vout_int] = vwrite_reg[vout_int][SRAM_DELAY-1];
      for (vwpt_int=vout_int+1; vwpt_int<NUMRWPT; vwpt_int=vwpt_int+1)
        vwrite_out[vout_int] = vwrite_out[vout_int] && !(vwrite_reg[vwpt_int][SRAM_DELAY-1] &&
                                                         (vaddr_reg[vwpt_int][SRAM_DELAY-1] == vaddr_reg[vout_int][SRAM_DELAY-1]));
      vaddr_out[vout_int] = vaddr_reg[vout_int][SRAM_DELAY-1];
      vdin_out[vout_int] = vdin_reg[vout_int][SRAM_DELAY-1];
    end

  reg [NUMPBNK-1:0] t1_readB;
  reg [NUMPBNK*BITADDR-1:0] t1_addrB;
  integer t1rd_int, t1rb_int, t1ra_int;
  always_comb begin
    t1_readB = 0;
    t1_addrB = 0;
    for (t1rd_int=0; t1rd_int<NUMRWPT; t1rd_int=t1rd_int+1)
      for (t1rb_int=0; t1rb_int<NUMRWPT; t1rb_int=t1rb_int+1) begin
        if (vread_wire[t1rd_int] || vwrite_wire[t1rd_int])
          t1_readB = t1_readB | (1'b1 << (t1rb_int*NUMRWPT+t1rd_int));
        for (t1ra_int=0; t1ra_int<BITADDR; t1ra_int=t1ra_int+1)
          t1_addrB[(t1rb_int*NUMRWPT+t1rd_int)*BITADDR+t1ra_int] = vaddr_wire[t1rd_int][t1ra_int];
      end
  end

  reg [WIDTH-1:0]           pdout_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  reg                       pfwrd_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  reg                       pserr_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  reg                       pderr_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  reg [BITPADR-BITPBNK-1:0] ppadr_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  integer                   pdop_int, pdob_int;
  always_comb
    for (pdop_int=0; pdop_int<NUMRWPT; pdop_int=pdop_int+1)
      for (pdob_int=0; pdob_int<NUMRWPT; pdob_int=pdob_int+1) begin
        pdout_wire[pdop_int][pdob_int] = t1_doutB >> ((pdob_int*NUMRWPT+pdop_int)*WIDTH);
        pfwrd_wire[pdop_int][pdob_int] = t1_fwrdB >> ((pdob_int*NUMRWPT+pdop_int)*WIDTH);
        pserr_wire[pdop_int][pdob_int] = t1_serrB >> ((pdob_int*NUMRWPT+pdop_int)*WIDTH);
        pderr_wire[pdop_int][pdob_int] = t1_derrB >> ((pdob_int*NUMRWPT+pdop_int)*WIDTH);
        ppadr_wire[pdop_int][pdob_int]  = t1_padrB >> ((pdob_int*NUMRWPT+pdop_int)*(BITPADR-BITPBNK));
      end

  reg               pwrite [0:NUMRWPT-1][0:NUMRWPT-1];
  reg [BITADDR-1:0] pwraddr [0:NUMRWPT-1][0:NUMRWPT-1];
  reg [WIDTH-1:0]   pdin [0:NUMRWPT-1][0:NUMRWPT-1];

  reg               data_vld [0:NUMRWPT-1][0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0]   data_reg [0:NUMRWPT-1][0:NUMRWPT-1][0:SRAM_DELAY-1];
  integer           rptp_int, rptb_int, rdel_int;
  always @(posedge clk) 
    for (rptp_int=0; rptp_int<NUMRWPT; rptp_int=rptp_int+1)
      for (rptb_int=0; rptb_int<NUMRWPT; rptb_int=rptb_int+1)
        for (rdel_int=0; rdel_int<SRAM_DELAY; rdel_int=rdel_int+1)
          if (rdel_int>0) begin
            if (pwrite[rptp_int][rptb_int] && (vread_reg[rptp_int][rdel_int-1] || vwrite_reg[rptp_int][rdel_int-1]) &&
                (pwraddr[rptp_int][rptb_int] == vaddr_reg[rptp_int][rdel_int-1])) begin
              data_vld[rptp_int][rptb_int][rdel_int] <= 1'b1;
              data_reg[rptp_int][rptb_int][rdel_int] <= pdin[rptp_int][rptb_int];
            end else begin
              data_vld[rptp_int][rptb_int][rdel_int] <= data_vld[rptp_int][rptb_int][rdel_int-1];
              data_reg[rptp_int][rptb_int][rdel_int] <= data_reg[rptp_int][rptb_int][rdel_int-1];            
            end
          end else begin
            if (pwrite[rptp_int][rptb_int] && (vread_wire[rptp_int] || vwrite_wire[rptp_int]) &&
                (pwraddr[rptp_int][rptb_int] == vaddr_wire[rptp_int])) begin
              data_vld[rptp_int][rptb_int][rdel_int] <= 1'b1;
              data_reg[rptp_int][rptb_int][rdel_int] <= pdin[rptp_int][rptb_int];
            end else begin
              data_vld[rptp_int][rptb_int][rdel_int] <= 1'b0;
              data_reg[rptp_int][rptb_int][rdel_int] <= 0;
            end
          end

  reg [WIDTH-1:0] data_out [0:NUMRWPT-1][0:NUMRWPT-1];
  integer         fwdp_int, fwdb_int;
  always_comb
    for (fwdp_int=0; fwdp_int<NUMRWPT; fwdp_int=fwdp_int+1)
      for (fwdb_int=0; fwdb_int<NUMRWPT; fwdb_int=fwdb_int+1)
        data_out[fwdp_int][fwdb_int] = data_vld[fwdp_int][fwdb_int][SRAM_DELAY-1] ? data_reg[fwdp_int][fwdb_int][SRAM_DELAY-1] : pdout_wire[fwdp_int][fwdb_int];

  wire [WIDTH-1:0] pdout_wire_0_0 = pdout_wire[0][0];
  wire [WIDTH-1:0] pdout_wire_0_1 = pdout_wire[0][1];
  wire [WIDTH-1:0] data_out_0_0 = data_out[0][0];
  wire [WIDTH-1:0] data_out_0_1 = data_out[0][1];

  reg             vread_vld_wire [0:NUMRWPT-1];
  reg             vread_fwrd_wire [0:NUMRWPT-1];
  reg             vread_ferr_wire [0:NUMRWPT-1];
  reg             vread_serr_wire [0:NUMRWPT-1];
  reg             vread_derr_wire [0:NUMRWPT-1];
  reg [BITPADR-1:0] vread_padr_wire [0:NUMRWPT-1];
  reg [WIDTH-1:0]   vdout_wire [0:NUMRWPT-1];
  integer           vdor_int, vdob_int;
  always_comb begin
    vread_vld_wire = vread_out;
    for (vdor_int=0; vdor_int<NUMRWPT; vdor_int=vdor_int+1) begin
      vread_fwrd_wire[vdor_int] = 0;
      vdout_wire[vdor_int] = 0;
      for (vdob_int=0; vdob_int<NUMRWPT; vdob_int=vdob_int+1) begin
        vread_fwrd_wire[vdor_int] = vread_fwrd_wire[vdor_int] || (vread_out[vdor_int] && (data_vld[vdor_int][vdob_int][SRAM_DELAY-1] || pfwrd_wire[vdor_int][vdob_int]));
        vdout_wire[vdor_int] = vdout_wire[vdor_int] ^ data_out[vdor_int][vdob_int];
      end
      vread_padr_wire[vdor_int] = ppadr_wire[vdor_int][0];
      vread_ferr_wire[vdor_int] = 0;
      vread_serr_wire[vdor_int] = 0;
      vread_derr_wire[vdor_int] = 0; 
      for (vdob_int=NUMRWPT-1; vdob_int>=0; vdob_int=vdob_int-1)
        if (pserr_wire[vdor_int][vdob_int]) begin
          vread_ferr_wire[vdor_int] = vread_ferr_wire[vdor_int] || (vread_out[vdor_int] && !(data_vld[vdor_int][vdob_int][SRAM_DELAY-1] || pfwrd_wire[vdor_int][vdob_int])); 
          vread_serr_wire[vdor_int] = 1'b1;
          vread_padr_wire[vdor_int] = {vdob_int,ppadr_wire[vdor_int][vdob_int]};
        end
      for (vdob_int=NUMRWPT-1; vdob_int>=0; vdob_int=vdob_int-1)
        if (pderr_wire[vdor_int][vdob_int]) begin
          vread_ferr_wire[vdor_int] = vread_ferr_wire[vdor_int] || (vread_out[vdor_int] && !(data_vld[vdor_int][vdob_int][SRAM_DELAY-1] || pfwrd_wire[vdor_int][vdob_int])); 
          vread_derr_wire[vdor_int] = 1'b1;
          vread_padr_wire[vdor_int] = {vdob_int,ppadr_wire[vdor_int][vdob_int]};
        end
      vread_fwrd_wire[vdor_int] = vread_fwrd_wire[vdor_int] && !vread_ferr_wire[vdor_int];
    end
  end

  wire [WIDTH-1:0] vdout_wire_0 = vdout_wire[0];

  reg [NUMRWPT-1:0]         vread_vld_tmp;
  reg [NUMRWPT*WIDTH-1:0]   vdout_tmp;
  reg [NUMRWPT-1:0]         vread_fwrd_tmp;
  reg [NUMRWPT-1:0]         vread_serr_tmp;
  reg [NUMRWPT-1:0]         vread_derr_tmp;
  reg [NUMRWPT*BITPADR-1:0] vread_padr_tmp;
  integer                   vbus_int;
  always_comb begin
    vread_vld_tmp = 0;
    vdout_tmp = 0;
    vread_fwrd_tmp = 0;
    vread_serr_tmp = 0;
    vread_derr_tmp = 0;
    vread_padr_tmp = 0;
    for (vbus_int=0; vbus_int<NUMRWPT; vbus_int=vbus_int+1) begin
      vread_vld_tmp = vread_vld_tmp | (vread_out[vbus_int] << vbus_int);
      vdout_tmp = vdout_tmp | (vdout_wire[vbus_int] << (vbus_int*WIDTH));
      vread_fwrd_tmp = vread_fwrd_tmp | (vread_fwrd_wire[vbus_int] << vbus_int);
      vread_serr_tmp = vread_serr_tmp | (vread_serr_wire[vbus_int] << vbus_int);
      vread_derr_tmp = vread_derr_tmp | (vread_derr_wire[vbus_int] << vbus_int);
      vread_padr_tmp = vread_padr_tmp | (vread_padr_wire[vbus_int] << (vbus_int*BITPADR));
    end
  end
  
  reg [NUMRWPT-1:0]         vread_vld;
  reg [NUMRWPT*WIDTH-1:0]   vdout;
  reg [NUMRWPT-1:0]         vread_fwrd;
  reg [NUMRWPT-1:0]         vread_serr;
  reg [NUMRWPT-1:0]         vread_derr;
  reg [NUMRWPT*BITPADR-1:0] vread_padr;
  generate if (FLOPOUT) begin: flpo_loop
    always @(posedge clk) begin
      vread_vld <= vread_vld_tmp;
      vdout <= vdout_tmp; 
      vread_fwrd <= vread_fwrd_tmp;
      vread_serr <= vread_serr_tmp;
      vread_derr <= vread_derr_tmp;
      vread_padr <= vread_padr_tmp;
    end
  end else begin: nflpo_loop
    always_comb begin
      vread_vld = vread_vld_tmp;
      vdout = vdout_tmp;
      vread_fwrd = vread_fwrd_tmp;
      vread_serr = vread_serr_tmp;
      vread_derr = vread_derr_tmp;
      vread_padr = vread_padr_tmp;
    end
  end
  endgenerate

  reg               rstvld_reg [0:SRAM_DELAY-1];
  reg [BITADDR-1:0] rstaddr_reg [0:SRAM_DELAY-1];
  integer           rst_int;
  always @(posedge clk)
    for (rst_int=0; rst_int<SRAM_DELAY; rst_int=rst_int+1)
      if (rst_int>0) begin
        rstvld_reg[rst_int] <= rstvld_reg[rst_int-1];
        rstaddr_reg[rst_int] <= rstaddr_reg[rst_int-1];
      end else begin
        rstvld_reg[rst_int] <= rstvld && !rst;
        rstaddr_reg[rst_int] <= rstaddr;
      end

  integer pwrr_int, pwrb_int;
  always_comb
    for (pwrr_int=0; pwrr_int<NUMRWPT; pwrr_int=pwrr_int+1)
      for (pwrb_int=0; pwrb_int<NUMRWPT; pwrb_int=pwrb_int+1)
        if (rstvld_reg[SRAM_DELAY-1]) begin
          pwrite[pwrb_int][pwrr_int] = 1'b1;
          pwraddr[pwrb_int][pwrr_int] = rstaddr_reg[SRAM_DELAY-1];
          pdin[pwrb_int][pwrr_int] = 0;
        end else if (vwrite_out[pwrr_int]) begin
          pwrite[pwrb_int][pwrr_int] = 1'b1;
          pwraddr[pwrb_int][pwrr_int] = vaddr_out[pwrr_int];
          pdin[pwrb_int][pwrr_int] = vdin_out[pwrr_int] ^ vdout_wire[pwrr_int] ^ data_out[pwrr_int][pwrr_int];
        end else begin
          pwrite[pwrb_int][pwrr_int] = 1'b0;
          pwraddr[pwrb_int][pwrr_int] = 0;
          pdin[pwrb_int][pwrr_int] = 0;
        end

  wire pwrite_0_0 = pwrite[0][0];
  wire [BITADDR-1:0] pwraddr_0_0 = pwraddr[0][0];
  wire [WIDTH-1:0] pdin_0_0 = pdin[0][0];
  wire pwrite_1_0 = pwrite[1][0];
  wire [BITADDR-1:0] pwraddr_1_0 = pwraddr[1][0];
  wire [WIDTH-1:0] pdin_1_0 = pdin[1][0];
  wire pwrite_0_1  = pwrite[0][1];
  wire [BITADDR-1:0] pwraddr_0_1  = pwraddr[0][1];
  wire [WIDTH-1:0] pdin_0_1  = pdin[0][1];
  wire pwrite_1_1  = pwrite[1][1];
  wire [BITADDR-1:0] pwraddr_1_1  = pwraddr[1][1];
  wire [WIDTH-1:0] pdin_1_1  = pdin[1][1];

  reg [NUMPBNK-1:0]         t1_writeA;
  reg [NUMPBNK*BITADDR-1:0] t1_addrA;
  reg [NUMPBNK*WIDTH-1:0]   t1_dinA;
  integer                   t1wp_int, t1wb_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    for (t1wp_int=0; t1wp_int<NUMRWPT; t1wp_int=t1wp_int+1)
      for (t1wb_int=0; t1wb_int<NUMRWPT; t1wb_int=t1wb_int+1)
        if (pwrite[t1wp_int][t1wb_int]) begin
          t1_writeA = t1_writeA | (1'b1 << (t1wb_int*NUMRWPT+t1wp_int));
          t1_addrA  = t1_addrA | (pwraddr[t1wp_int][t1wb_int] <<  ((t1wb_int*NUMRWPT+t1wp_int) * BITADDR));
          t1_dinA   = t1_dinA | (pdin[t1wp_int][t1wb_int] <<  ((t1wb_int*NUMRWPT+t1wp_int) * WIDTH));
        end
  end

endmodule // core_nrw_1r1w
