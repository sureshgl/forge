module core_nru_1r1w (vread, vwrite, vaddr, vdin, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                      t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                      ready, clk, rst);

  parameter BITWDTH = 5;
  parameter WIDTH = 32;
  parameter NUMRUPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMWRDS = 8;
  parameter BITWRDS = 3;
  parameter NUMPBNK = 4;     // NUMRUPT*NUMRUPT
  parameter BITPBNK = 2;
  parameter BITPADR = BITPBNK+BITVROW+BITWRDS;
  parameter SRAM_DELAY = 2;
  parameter UPD_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  input [NUMRUPT-1:0]                vread;
  input [NUMRUPT-1:0]                vwrite;
  input [NUMRUPT*BITADDR-1:0]        vaddr;
  input [NUMRUPT*WIDTH-1:0]          vdin;
  output [NUMRUPT-1:0]               vread_vld;
  output [NUMRUPT*WIDTH-1:0]         vdout;
  output [NUMRUPT-1:0]               vread_fwrd;
  output [NUMRUPT-1:0]               vread_serr;
  output [NUMRUPT-1:0]               vread_derr;
  output [NUMRUPT*BITPADR-1:0]       vread_padr;

  output [NUMPBNK-1:0]               t1_writeA;
  output [NUMPBNK*BITVROW-1:0]       t1_addrA;
  output [NUMPBNK*NUMWRDS*WIDTH-1:0] t1_dinA;
  
  output [NUMPBNK-1:0]               t1_readB;
  output [NUMPBNK*BITVROW-1:0]       t1_addrB;
  input [NUMPBNK*NUMWRDS*WIDTH-1:0]  t1_doutB;
  input [NUMPBNK-1:0]                t1_fwrdB;
  input [NUMPBNK-1:0]                t1_serrB;
  input [NUMPBNK-1:0]                t1_derrB;
  input [NUMPBNK*(BITPADR-BITPBNK-BITWRDS)-1:0] t1_padrB;

  
  output                                ready;
  input                                 clk;
  input                                 rst;

  reg [BITVROW:0] rstaddr;
  wire rstvld = (rstaddr < NUMVROW);
  always @(posedge clk)
    if (rst)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;

  reg ready;
  reg               rstvld_reg [0:SRAM_DELAY+UPD_DELAY-1];
  reg [BITADDR-1:0] rstaddr_reg [0:SRAM_DELAY+UPD_DELAY-1];
  integer           rst_int;
  always @(posedge clk)
    ready <= !rstvld && !rstvld_reg [SRAM_DELAY+UPD_DELAY-1];

  wire                                  ready_wire;

  wire                                  vread_wire [0:NUMRUPT-1];
  wire                                  vwrite_wire [0:NUMRUPT-1];
  wire [BITADDR-1:0]                    vaddr_wire [0:NUMRUPT-1];
  wire [BITWRDS-1:0]                    vwadr_wire [0:NUMRUPT-1];
  wire [BITVROW-1:0]                    vradr_wire [0:NUMRUPT-1];
  wire [WIDTH-1:0]                      vdin_wire [0:NUMRUPT-1];

  genvar flp_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg [NUMRUPT-1:0] vread_reg;
    reg [NUMRUPT-1:0] vwrite_reg;
    reg [NUMRUPT*BITADDR-1:0] vaddr_reg;
    reg [NUMRUPT*WIDTH-1:0]   vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vread_reg <= vread && {NUMRUPT{ready}};
      vwrite_reg <= vwrite && {NUMRUPT{ready}};
      vaddr_reg <= vaddr;
      vdin_reg <= vdin;
    end

    assign ready_wire = ready_reg;
    for (flp_var=0; flp_var<NUMRUPT; flp_var=flp_var+1) begin: ru_loop
      assign vread_wire[flp_var] = vread_reg[flp_var] && (vaddr_wire[flp_var]<NUMADDR);
      assign vwrite_wire[flp_var] = vwrite_reg[flp_var];
      assign vaddr_wire[flp_var] = vaddr_reg >> (flp_var*BITADDR);
      assign vdin_wire[flp_var] = vdin_reg >> (flp_var*WIDTH);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        adr_inst (.vbadr(vwadr_wire[flp_var]), .vradr(vradr_wire[flp_var]), .vaddr(vaddr_wire[flp_var]));
    end
  end else begin: noflpi_loop
    assign ready_wire = ready;
    for (flp_var=0; flp_var<NUMRUPT; flp_var=flp_var+1) begin: ru_loop
      assign vread_wire[flp_var] = vread[flp_var] && (vaddr_wire[flp_var]<NUMADDR) && ready;
      assign vwrite_wire[flp_var] = vwrite[flp_var] && ready;
      assign vaddr_wire[flp_var] = vaddr >> (flp_var*BITADDR);
      assign vdin_wire[flp_var] = vdin >> (flp_var*WIDTH);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        adr_inst (.vbadr(vwadr_wire[flp_var]), .vradr(vradr_wire[flp_var]), .vaddr(vaddr_wire[flp_var]));
    end
  end
  endgenerate

  reg                vread_reg [0:NUMRUPT-1][0:SRAM_DELAY+UPD_DELAY-1];
//  reg                vwrite_reg [0:NUMRUPT-1][0:SRAM_DELAY-1];
  reg [BITWRDS-1:0]  vwadr_reg [0:NUMRUPT-1][0:SRAM_DELAY+UPD_DELAY-1];
  reg [BITVROW-1:0]  vradr_reg [0:NUMRUPT-1][0:SRAM_DELAY+UPD_DELAY-1];
//  reg [WIDTH-1:0]    vdin_reg [0:NUMRUPT-1][0:SRAM_DELAY-1];
  integer vdel_int, vprt_int;
  always @(posedge clk) 
    for (vdel_int=0; vdel_int<SRAM_DELAY+UPD_DELAY; vdel_int=vdel_int+1)
      if (vdel_int>0) begin
        for (vprt_int=0; vprt_int<NUMRUPT; vprt_int=vprt_int+1) begin
          vread_reg[vprt_int][vdel_int] <= vread_reg[vprt_int][vdel_int-1];
//          vwrite_reg[vprt_int][vdel_int] <= vwrite_reg[vprt_int][vdel_int-1];
          vwadr_reg[vprt_int][vdel_int] <= vwadr_reg[vprt_int][vdel_int-1];
          vradr_reg[vprt_int][vdel_int] <= vradr_reg[vprt_int][vdel_int-1];
//          vdin_reg[vprt_int][vdel_int] <= vdin_reg[vprt_int][vdel_int-1];
        end
      end else begin
        for (vprt_int=0; vprt_int<NUMRUPT; vprt_int=vprt_int+1) begin
          vread_reg[vprt_int][vdel_int] <= vread_wire[vprt_int];
//          vwrite_reg[vprt_int][vdel_int] <= vwrite_wire[vprt_int];
          vwadr_reg[vprt_int][vdel_int] <= vwadr_wire[vprt_int];
          vradr_reg[vprt_int][vdel_int] <= vradr_wire[vprt_int];
//          vdin_reg[vprt_int][vdel_int] <= vdin_wire[vprt_int];
        end
      end

  reg               vread_out [0:NUMRUPT-1];
  reg               vwrite_out [0:NUMRUPT-1];
  reg [BITWRDS-1:0] vrdwadr_out [0:NUMRUPT-1];
  reg [BITVROW-1:0] vrdradr_out [0:NUMRUPT-1];
  reg [BITWRDS-1:0] vwrwadr_out [0:NUMRUPT-1];
  reg [BITVROW-1:0] vwrradr_out [0:NUMRUPT-1];
//  reg [WIDTH-1:0]   vdin_out [0:NUMRUPT-1];
  integer vout_int, vwpt_int;
  always_comb begin
    for (vout_int=0; vout_int<NUMRUPT; vout_int=vout_int+1) begin
      vread_out[vout_int] = vread_reg[vout_int][SRAM_DELAY-1];
      vrdwadr_out[vout_int] = vwadr_reg[vout_int][SRAM_DELAY-1];
      vrdradr_out[vout_int] = vradr_reg[vout_int][SRAM_DELAY-1];
      vwrite_out[vout_int] = vwrite_wire[vout_int] && vread_reg[vout_int][SRAM_DELAY+UPD_DELAY-1];
      vwrwadr_out[vout_int] = vwadr_reg[vout_int][SRAM_DELAY+UPD_DELAY-1];
      vwrradr_out[vout_int] = vradr_reg[vout_int][SRAM_DELAY+UPD_DELAY-1];
//      vdin_out[vout_int] = vdin_reg[vout_int][SRAM_DELAY-1];
    end
    for (vout_int=0; vout_int<NUMRUPT; vout_int=vout_int+1)
      for (vwpt_int=vout_int+1; vwpt_int<NUMRUPT; vwpt_int=vwpt_int+1)
        vwrite_out[vout_int] = vwrite_out[vout_int] && !(vwrite_out[vwpt_int] &&
                                                         (vwrradr_out[vwpt_int] == vwrradr_out[vout_int]) && (vwrwadr_out[vwpt_int]==vwrwadr_out[vout_int]));
  end

  reg [NUMPBNK-1:0] t1_readB;
  reg [NUMPBNK*BITVROW-1:0] t1_addrB;
  integer t1rd_int, t1rb_int, t1ra_int;
  always_comb begin
    t1_readB = 0;
    t1_addrB = 0;
    for (t1rd_int=0; t1rd_int<NUMRUPT; t1rd_int=t1rd_int+1)
      for (t1rb_int=0; t1rb_int<NUMRUPT; t1rb_int=t1rb_int+1) begin
        if (vread_wire[t1rd_int])
          t1_readB = t1_readB | (1'b1 << (t1rb_int*NUMRUPT+t1rd_int));
        for (t1ra_int=0; t1ra_int<BITVROW; t1ra_int=t1ra_int+1)
          t1_addrB[(t1rb_int*NUMRUPT+t1rd_int)*BITVROW+t1ra_int] = vradr_wire[t1rd_int][t1ra_int];
      end
  end

  reg [NUMWRDS*WIDTH-1:0]   pdout_wire [0:NUMRUPT-1][0:NUMRUPT-1];
  reg                       pfwrd_wire [0:NUMRUPT-1][0:NUMRUPT-1];
  reg                       pserr_wire [0:NUMRUPT-1][0:NUMRUPT-1];
  reg                       pderr_wire [0:NUMRUPT-1][0:NUMRUPT-1];
  reg [BITPADR-BITPBNK-1:0] ppadr_wire [0:NUMRUPT-1][0:NUMRUPT-1];
  integer pdop_int, pdob_int;
  always_comb
    for (pdop_int=0; pdop_int<NUMRUPT; pdop_int=pdop_int+1)
      for (pdob_int=0; pdob_int<NUMRUPT; pdob_int=pdob_int+1) begin
        pdout_wire[pdop_int][pdob_int] = t1_doutB >> ((pdob_int*NUMRUPT+pdop_int)*NUMWRDS*WIDTH);
        pfwrd_wire[pdop_int][pdob_int] = t1_fwrdB >> (pdob_int*NUMRUPT+pdop_int);
        pserr_wire[pdop_int][pdob_int] = t1_serrB >> (pdob_int*NUMRUPT+pdop_int);
        pderr_wire[pdop_int][pdob_int] = t1_derrB >> (pdob_int*NUMRUPT+pdop_int);
        ppadr_wire[pdop_int][pdob_int]  = t1_padrB >> ((pdob_int*NUMRUPT+pdop_int)*(BITPADR-BITPBNK));
      end

  reg                     pwrite [0:NUMRUPT-1][0:NUMRUPT-1];
  reg [BITVROW-1:0]       pwraddr [0:NUMRUPT-1][0:NUMRUPT-1];
  reg [NUMWRDS*WIDTH-1:0] pdin [0:NUMRUPT-1][0:NUMRUPT-1];

  reg                     data_vld [0:NUMRUPT-1][0:NUMRUPT-1][0:SRAM_DELAY+UPD_DELAY-1];
  reg [NUMWRDS*WIDTH-1:0] data_reg [0:NUMRUPT-1][0:NUMRUPT-1][0:SRAM_DELAY+UPD_DELAY-1];
  integer rptp_int, rptb_int, rdel_int;
  always @(posedge clk) 
    for (rptp_int=0; rptp_int<NUMRUPT; rptp_int=rptp_int+1)
      for (rptb_int=0; rptb_int<NUMRUPT; rptb_int=rptb_int+1)
        for (rdel_int=0; rdel_int<SRAM_DELAY+UPD_DELAY; rdel_int=rdel_int+1)
          if (rdel_int==SRAM_DELAY) begin
            if (pwrite[rptp_int][rptb_int] && vread_reg[rptp_int][rdel_int-1] && (pwraddr[rptp_int][rptb_int] == vradr_reg[rptp_int][rdel_int-1])) begin
              data_vld[rptp_int][rptb_int][rdel_int] <= 1'b1;
              data_reg[rptp_int][rptb_int][rdel_int] <= pdin[rptp_int][rptb_int];
            end else if (data_vld[rptp_int][rptb_int][rdel_int-1]) begin
              data_vld[rptp_int][rptb_int][rdel_int] <= data_vld[rptp_int][rptb_int][rdel_int-1];
              data_reg[rptp_int][rptb_int][rdel_int] <= data_reg[rptp_int][rptb_int][rdel_int-1];            
            end else begin
              data_vld[rptp_int][rptb_int][rdel_int] <= 1'b1;
              data_reg[rptp_int][rptb_int][rdel_int] <= pdout_wire[rptp_int][rptb_int];
            end
          end else if (rdel_int>0) begin
            if (pwrite[rptp_int][rptb_int] && vread_reg[rptp_int][rdel_int-1] && (pwraddr[rptp_int][rptb_int] == vradr_reg[rptp_int][rdel_int-1])) begin
              data_vld[rptp_int][rptb_int][rdel_int] <= 1'b1;
              data_reg[rptp_int][rptb_int][rdel_int] <= pdin[rptp_int][rptb_int];
            end else begin
              data_vld[rptp_int][rptb_int][rdel_int] <= data_vld[rptp_int][rptb_int][rdel_int-1];
              data_reg[rptp_int][rptb_int][rdel_int] <= data_reg[rptp_int][rptb_int][rdel_int-1];            
            end
          end else begin
            if (pwrite[rptp_int][rptb_int] && vread_wire[rptp_int] && (pwraddr[rptp_int][rptb_int] == vradr_wire[rptp_int])) begin
              data_vld[rptp_int][rptb_int][rdel_int] <= 1'b1;
              data_reg[rptp_int][rptb_int][rdel_int] <= pdin[rptp_int][rptb_int];
            end else begin
              data_vld[rptp_int][rptb_int][rdel_int] <= 1'b0;
              data_reg[rptp_int][rptb_int][rdel_int] <= 0;
            end
          end

  reg [NUMWRDS*WIDTH-1:0] rdat_out [0:NUMRUPT-1][0:NUMRUPT-1];
  reg [NUMWRDS*WIDTH-1:0] wdat_out [0:NUMRUPT-1][0:NUMRUPT-1];
  integer fwdp_int, fwdb_int;
  always_comb
    for (fwdp_int=0; fwdp_int<NUMRUPT; fwdp_int=fwdp_int+1)
      for (fwdb_int=0; fwdb_int<NUMRUPT; fwdb_int=fwdb_int+1) begin
        rdat_out[fwdp_int][fwdb_int] = data_vld[fwdp_int][fwdb_int][SRAM_DELAY-1] ? data_reg[fwdp_int][fwdb_int][SRAM_DELAY-1] : pdout_wire[fwdp_int][fwdb_int];
        wdat_out[fwdp_int][fwdb_int] = data_vld[fwdp_int][fwdb_int][SRAM_DELAY+UPD_DELAY-1] ? data_reg[fwdp_int][fwdb_int][SRAM_DELAY+UPD_DELAY-1] : pdout_wire[fwdp_int][fwdb_int];
      end

  reg               vread_vld_wire [0:NUMRUPT-1];
  reg               vread_fwrd_wire [0:NUMRUPT-1];
  reg               vread_ferr_wire [0:NUMRUPT-1];
  reg               vread_serr_wire [0:NUMRUPT-1];
  reg               vread_derr_wire [0:NUMRUPT-1];
  reg [BITPADR-1:0] vread_padr_wire [0:NUMRUPT-1];
  reg [WIDTH-1:0]   vdout_wire [0:NUMRUPT-1];
  reg [NUMWRDS*WIDTH-1:0] vdout_temp [0:NUMRUPT-1];
  integer           vdor_int, vdob_int;
  always_comb begin
    vread_vld_wire = vread_out;
    for (vdor_int=0; vdor_int<NUMRUPT; vdor_int=vdor_int+1) begin
      vread_fwrd_wire[vdor_int] = 0;
      vdout_temp[vdor_int] = 0;
      for (vdob_int=0; vdob_int<NUMRUPT; vdob_int=vdob_int+1) begin
        vread_fwrd_wire[vdor_int] = vread_fwrd_wire[vdor_int] || (vread_out[vdor_int] && (data_vld[vdor_int][vdob_int][SRAM_DELAY-1] || pfwrd_wire[vdor_int][vdob_int]));
        vdout_temp[vdor_int] = vdout_temp[vdor_int] ^ rdat_out[vdor_int][vdob_int];
      end
      vdout_wire[vdor_int] = 0;
      for (vdob_int=0; vdob_int<NUMWRDS; vdob_int=vdob_int+1)
        if (vdob_int==vrdwadr_out[vdor_int])
          vdout_wire[vdor_int] = vdout_temp[vdor_int] >> (vdob_int*WIDTH);
      vread_padr_wire[vdor_int] = {ppadr_wire[vdor_int][0],vrdwadr_out[vdor_int]};
      vread_ferr_wire[vdor_int] = 0;
      vread_serr_wire[vdor_int] = 0;
      vread_derr_wire[vdor_int] = 0; 
      for (vdob_int=NUMRUPT-1; vdob_int>=0; vdob_int=vdob_int-1)
        if (pserr_wire[vdor_int][vdob_int]) begin
          vread_ferr_wire[vdor_int] = vread_ferr_wire[vdor_int] || (vread_out[vdor_int] && !(data_vld[vdor_int][vdob_int][SRAM_DELAY-1] || pfwrd_wire[vdor_int][vdob_int])); 
          vread_serr_wire[vdor_int] = 1'b1;
          vread_padr_wire[vdor_int] = {vdob_int,ppadr_wire[vdor_int][vdob_int],vrdwadr_out[vdor_int]};
        end
      for (vdob_int=NUMRUPT-1; vdob_int>=0; vdob_int=vdob_int-1)
        if (pderr_wire[vdor_int][vdob_int]) begin
          vread_ferr_wire[vdor_int] = vread_ferr_wire[vdor_int] || (vread_out[vdor_int] && !(data_vld[vdor_int][vdob_int][SRAM_DELAY-1] || pfwrd_wire[vdor_int][vdob_int])); 
          vread_derr_wire[vdor_int] = 1'b1;
          vread_padr_wire[vdor_int] = {vdob_int,ppadr_wire[vdor_int][vdob_int],vrdwadr_out[vdor_int]};
        end
      vread_fwrd_wire[vdor_int] = vread_fwrd_wire[vdor_int] && !vread_ferr_wire[vdor_int];
    end
  end

  reg [NUMRUPT-1:0]         vread_vld_tmp;
  reg [NUMRUPT*WIDTH-1:0]   vdout_tmp;
  reg [NUMRUPT-1:0]         vread_fwrd_tmp;
  reg [NUMRUPT-1:0]         vread_serr_tmp;
  reg [NUMRUPT-1:0]         vread_derr_tmp;
  reg [NUMRUPT*BITPADR-1:0] vread_padr_tmp;
  integer                   vbus_int;
  always_comb begin
    vread_vld_tmp = 0;
    vdout_tmp = 0;
    vread_fwrd_tmp = 0;
    vread_serr_tmp = 0;
    vread_derr_tmp = 0;
    vread_padr_tmp = 0;
    for (vbus_int=0; vbus_int<NUMRUPT; vbus_int=vbus_int+1) begin
      vread_vld_tmp = vread_vld_tmp | (vread_out[vbus_int] << vbus_int);
      vdout_tmp = vdout_tmp | (vdout_wire[vbus_int] << (vbus_int*WIDTH));
      vread_fwrd_tmp = vread_fwrd_tmp | (vread_fwrd_wire[vbus_int] << vbus_int);
      vread_serr_tmp = vread_serr_tmp | (vread_serr_wire[vbus_int] << vbus_int);
      vread_derr_tmp = vread_derr_tmp | (vread_derr_wire[vbus_int] << vbus_int);
      vread_padr_tmp = vread_padr_tmp | (vread_padr_wire[vbus_int] << (vbus_int*BITPADR));
    end
  end
  
  reg [NUMRUPT-1:0]         vread_vld;
  reg [NUMRUPT*WIDTH-1:0]   vdout;
  reg [NUMRUPT-1:0]         vread_fwrd;
  reg [NUMRUPT-1:0]         vread_serr;
  reg [NUMRUPT-1:0]         vread_derr;
  reg [NUMRUPT*BITPADR-1:0] vread_padr;
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

  always @(posedge clk)
    for (rst_int=0; rst_int<SRAM_DELAY+UPD_DELAY; rst_int=rst_int+1)
      if (rst_int>0) begin
        rstvld_reg[rst_int] <= rstvld_reg[rst_int-1];
        rstaddr_reg[rst_int] <= rstaddr_reg[rst_int-1];
      end else begin
        rstvld_reg[rst_int] <= rstvld && !rst;
        rstaddr_reg[rst_int] <= rstaddr;
      end

  reg [WIDTH-1:0] wdin [0:NUMRUPT-1][0:NUMRUPT-1][0:NUMWRDS-1];
  integer wwrr_int, wwrb_int, wwrw_int, wwrx_int;
  always_comb
    for (wwrr_int=0; wwrr_int<NUMRUPT; wwrr_int=wwrr_int+1)
      for (wwrb_int=0; wwrb_int<NUMRUPT; wwrb_int=wwrb_int+1)
        for (wwrw_int=0; wwrw_int<NUMWRDS; wwrw_int=wwrw_int+1)
          if (vwrite_out[wwrr_int] && (wwrw_int==vwrwadr_out[wwrr_int])) begin
            wdin[wwrb_int][wwrr_int][wwrw_int] = vdin_wire[wwrr_int];
            for (wwrx_int=0; wwrx_int<NUMRUPT; wwrx_int=wwrx_int+1)
              if (wwrx_int!=wwrr_int)
                wdin[wwrb_int][wwrr_int][wwrw_int] = wdin[wwrb_int][wwrr_int][wwrw_int] ^ (wdat_out[wwrr_int][wwrx_int] >> (wwrw_int*WIDTH));
          end else begin
            wdin[wwrb_int][wwrr_int][wwrw_int] = wdat_out[wwrr_int][wwrr_int] >> (wwrw_int*WIDTH); 
          end

  integer pwrr_int, pwrb_int, pwrx_int;
  always_comb
    for (pwrr_int=0; pwrr_int<NUMRUPT; pwrr_int=pwrr_int+1)
      for (pwrb_int=0; pwrb_int<NUMRUPT; pwrb_int=pwrb_int+1)
        if (rstvld_reg[SRAM_DELAY+UPD_DELAY-1]) begin
          pwrite[pwrb_int][pwrr_int] = 1'b1;
          pwraddr[pwrb_int][pwrr_int] = rstaddr_reg[SRAM_DELAY+UPD_DELAY-1];
          pdin[pwrb_int][pwrr_int] = 0;
        end else if (vwrite_out[pwrr_int]) begin
          pwrite[pwrb_int][pwrr_int] = 1'b1;
          pwraddr[pwrb_int][pwrr_int] = vwrradr_out[pwrr_int];
          pdin[pwrb_int][pwrr_int] = 0;
          for (pwrx_int=0; pwrx_int<NUMWRDS; pwrx_int=pwrx_int+1)
            pdin[pwrb_int][pwrr_int] = pdin[pwrb_int][pwrr_int] | (wdin[pwrb_int][pwrr_int][pwrx_int] << (pwrx_int*WIDTH));
        end else begin
          pwrite[pwrb_int][pwrr_int] = 1'b0;
          pwraddr[pwrb_int][pwrr_int] = 0;
          pdin[pwrb_int][pwrr_int] = 0;
        end

  reg [NUMPBNK-1:0]               t1_writeA;
  reg [NUMPBNK*BITVROW-1:0]       t1_addrA;
  reg [NUMPBNK*NUMWRDS*WIDTH-1:0] t1_dinA;
  integer t1wp_int, t1wb_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    for (t1wp_int=0; t1wp_int<NUMRUPT; t1wp_int=t1wp_int+1)
      for (t1wb_int=0; t1wb_int<NUMRUPT; t1wb_int=t1wb_int+1)
        if (pwrite[t1wp_int][t1wb_int]) begin
          t1_writeA = t1_writeA | (1'b1 << (t1wb_int*NUMRUPT+t1wp_int));
          t1_addrA = t1_addrA | (pwraddr[t1wp_int][t1wb_int] <<  ((t1wb_int*NUMRUPT+t1wp_int)*BITVROW));
          t1_dinA = t1_dinA | (pdin[t1wp_int][t1wb_int] <<  ((t1wb_int*NUMRUPT+t1wp_int)*NUMWRDS*WIDTH));
        end
  end

endmodule // core_nru_1r1w
