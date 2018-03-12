module core_mrnwt_base (vwrite, vwraddr, vdin, vwr_bp,
                        vread, vrdaddr, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr, 
                        t1_writeA, t1_addrA, t1_dinA,
                        t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                        bp_thr,
	                ready, clk, rst);
 
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMRDPT = 2;
  parameter NUMWRPT = 3;
  parameter BITWRPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMWTPT = 3;
  parameter BITPADR = 13;

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter FIFOCNT = NUMWRPT;
  parameter BITFIFO = 7;
  parameter NUMSRCH = 2;

  input [NUMWRPT-1:0]                   vwrite;
  input [NUMWRPT*BITADDR-1:0]           vwraddr;
  input [NUMWRPT*WIDTH-1:0]             vdin;
  output                                vwr_bp;
  
  input [NUMRDPT-1:0]                   vread;
  input [NUMRDPT*BITADDR-1:0]           vrdaddr;
  output [NUMRDPT-1:0]                  vread_vld;
  output [NUMRDPT*WIDTH-1:0]            vdout;
  output [NUMRDPT-1:0]                  vread_fwrd;
  output [NUMRDPT-1:0]                  vread_serr;
  output [NUMRDPT-1:0]                  vread_derr;
  output [NUMRDPT*BITPADR-1:0]          vread_padr;

  output [NUMWTPT-1:0]                  t1_writeA;
  output [NUMWTPT*BITADDR-1:0]          t1_addrA;
  output [NUMWTPT*WIDTH-1:0]            t1_dinA;

  output [NUMRDPT-1:0]                  t1_readB;
  output [NUMRDPT*BITADDR-1:0]          t1_addrB;
  input [NUMRDPT*WIDTH-1:0]             t1_doutB;
  input [NUMRDPT-1:0]                   t1_fwrdB;
  input [NUMRDPT-1:0]                   t1_serrB;
  input [NUMRDPT-1:0]                   t1_derrB;
  input [NUMRDPT*BITPADR-1:0]           t1_padrB;

  input [BITFIFO:0]                     bp_thr;

  output                                ready;
  input                                 clk;
  input                                 rst;

  reg ready;
  always @(posedge clk)
    ready <= !rst;

  wire vread_wire [0:NUMRDPT-1];
  wire [BITADDR-1:0] vrdaddr_wire [0:NUMRDPT-1];
  wire vwrite_wire [0:NUMWRPT-1];
  wire [BITADDR-1:0] vwraddr_wire [0:NUMWRPT-1];
  wire [WIDTH-1:0] vdin_wire [0:NUMWRPT-1];
  wire [BITFIFO:0] bp_thr_wire;

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg [NUMRDPT-1:0] vread_reg;
    reg [NUMRDPT*BITADDR-1:0] vrdaddr_reg;
    reg [NUMWRPT-1:0] vwrite_reg;
    reg [NUMWRPT*BITADDR-1:0] vwraddr_reg;
    reg [NUMWRPT*WIDTH-1:0] vdin_reg;
    reg [BITFIFO:0] bp_thr_reg;
    always @(posedge clk) begin
      vread_reg <= vread & {NUMRDPT{ready}};
      vrdaddr_reg <= vrdaddr;
      vwrite_reg <= vwrite & {NUMWRPT{ready}};
      vwraddr_reg <= vwraddr;
      vdin_reg <= vdin;
      bp_thr_reg <= bp_thr;
    end

    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread_reg >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr_reg >> (np2_var*BITADDR);
    end

    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = vwrite_reg >> np2_var;
      assign vwraddr_wire[np2_var] = vwraddr_reg >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin_reg >> (np2_var*WIDTH);
    end
    assign bp_thr_wire = bp_thr_reg;
  end else begin: noflpi_loop
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr >> (np2_var*BITADDR);
    end 

    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = vwrite >> np2_var;
      assign vwraddr_wire[np2_var] = vwraddr >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin >> (np2_var*WIDTH);
    end 
    assign bp_thr_wire = bp_thr;
  end
  endgenerate

  reg [BITFIFO:0]    wrfifo_cnt;
  reg                wrfifo_new_vld [0:FIFOCNT-1];
  reg [BITADDR-1:0]  wrfifo_new_adr [0:FIFOCNT-1];
  reg [WIDTH-1:0]    wrfifo_new_dat [0:FIFOCNT-1];

  wire wrfifo_new_vld_0 = wrfifo_new_vld[0];
  wire [BITADDR-1:0] wrfifo_new_adr_0 = wrfifo_new_adr[0];
  wire [WIDTH-1:0] wrfifo_new_dat_0 = wrfifo_new_dat[0];
  wire wrfifo_new_vld_1 = wrfifo_new_vld[1];
  wire [BITADDR-1:0] wrfifo_new_adr_1 = wrfifo_new_adr[1];
  wire [WIDTH-1:0] wrfifo_new_dat_1 = wrfifo_new_dat[1];

  reg [BITWRPT-1:0] vwr_bnk_sel;
  reg vwrite_nxt [0:NUMWRPT-1];
  reg [BITADDR-1:0] vwraddr_nxt [0:NUMWRPT-1];
  reg [WIDTH-1:0] vdin_nxt [0:NUMWRPT-1];
  integer vwrn_int;
  always_comb begin
    for (vwrn_int=0; vwrn_int<NUMWRPT; vwrn_int=vwrn_int+1) begin
      vwrite_nxt[vwrn_int] = 1'b0;
      vwraddr_nxt[vwrn_int] = 0;
      vdin_nxt[vwrn_int] = 0;
    end
    vwr_bnk_sel = 0;
    for (vwrn_int=0; vwrn_int<NUMWRPT; vwrn_int=vwrn_int+1)
      if (vwrite_wire[vwrn_int]) begin
        vwrite_nxt[vwr_bnk_sel] = 1'b1;
        vwraddr_nxt[vwr_bnk_sel] = vwraddr_wire[vwrn_int];
        vdin_nxt[vwr_bnk_sel] = vdin_wire[vwrn_int];
        vwr_bnk_sel = vwr_bnk_sel + 1;
      end
  end

  reg [3:0] wrfifo_dcnt;
  reg [3:0] wrfifo_ecnt;
  integer wffc_int;
  always_comb begin
    wrfifo_dcnt = NUMWTPT;
    wrfifo_dcnt = (wrfifo_cnt > wrfifo_dcnt) ? wrfifo_dcnt : wrfifo_cnt;
    wrfifo_ecnt = 0;
    for (wffc_int=0; wffc_int<NUMWRPT; wffc_int=wffc_int+1)
      wrfifo_ecnt = wrfifo_ecnt + vwrite_wire[wffc_int];
  end

  always @(posedge clk)
    if (rst)
      wrfifo_cnt <= 0;
    else
      wrfifo_cnt <= wrfifo_cnt + wrfifo_ecnt - wrfifo_dcnt;

  genvar wffo_var;
  generate
    for (wffo_var=0; wffo_var<FIFOCNT; wffo_var=wffo_var+1) begin: wffo_loop
      reg [3:0] vwr_sel;
      reg [3:0] fifo_cnt_temp;

      integer fcnt_int;
      always_comb begin
        vwr_sel = NUMWRPT;
        for (fcnt_int=0; fcnt_int<NUMWRPT; fcnt_int=fcnt_int+1)
          if (vwrite_nxt[fcnt_int] && (wffo_var == (wrfifo_cnt - wrfifo_dcnt + fcnt_int)))
            vwr_sel = fcnt_int;
      end

      reg               wrfifo_new_vld_next;
      reg [BITADDR-1:0] wrfifo_new_adr_next;
      reg [WIDTH-1:0]   wrfifo_new_dat_next;
      always_comb
        if ((vwr_sel != NUMWRPT) && vwrite_nxt[vwr_sel]) begin
          wrfifo_new_vld_next = vwrite_nxt[vwr_sel];
          wrfifo_new_adr_next = vwraddr_nxt[vwr_sel];
          wrfifo_new_dat_next = vdin_nxt[vwr_sel];
        end else if (|wrfifo_dcnt && (wffo_var<FIFOCNT-wrfifo_dcnt)) begin
          wrfifo_new_vld_next = wrfifo_new_vld[wffo_var+wrfifo_dcnt];
          wrfifo_new_adr_next = wrfifo_new_adr[wffo_var+wrfifo_dcnt];
          wrfifo_new_dat_next = wrfifo_new_dat[wffo_var+wrfifo_dcnt];
        end else begin
          wrfifo_new_vld_next = 1'b0;
          wrfifo_new_adr_next = wrfifo_new_adr[wffo_var];
          wrfifo_new_dat_next = wrfifo_new_dat[wffo_var];
        end

      always @(posedge clk) begin
        wrfifo_new_vld[wffo_var] <= wrfifo_new_vld_next;
        wrfifo_new_adr[wffo_var] <= wrfifo_new_adr_next;
        wrfifo_new_dat[wffo_var] <= wrfifo_new_dat_next;
      end
    end
  endgenerate

  reg wr_srch_flag [0:NUMRDPT-1][0:NUMSRCH-1];
  reg [WIDTH-1:0] wr_srch_data [0:NUMRDPT-1][0:NUMSRCH-1];
  integer wsrc_int, wsrr_int, wsrs_int;
  always_comb
    for (wsrr_int=0; wsrr_int<NUMRDPT; wsrr_int=wsrr_int+1) begin
      for (wsrs_int=0; wsrs_int<NUMSRCH; wsrs_int=wsrs_int+1) begin
        wr_srch_flag[wsrr_int][wsrs_int] = 1'b0;
        wr_srch_data[wsrr_int][wsrs_int] = 0;
      end
      for (wsrs_int=0; wsrs_int<NUMSRCH; wsrs_int=wsrs_int+1)
        for (wsrc_int=wsrs_int*FIFOCNT/NUMSRCH; wsrc_int<(wsrs_int+1)*FIFOCNT/NUMSRCH; wsrc_int=wsrc_int+1)
          if (wrfifo_new_vld[wsrc_int] && (wrfifo_new_adr[wsrc_int]==vrdaddr_wire[wsrr_int])) begin
            wr_srch_flag[wsrr_int][wsrs_int] = 1'b1;
            wr_srch_data[wsrr_int][wsrs_int] = wrfifo_new_dat[wsrc_int];
          end
    end

  reg              vread_reg [0:NUMRDPT-1][0:SRAM_DELAY-1];
  reg              vread_fwrd_reg [0:NUMRDPT-1][0:NUMSRCH-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0]  vread_data_reg [0:NUMRDPT-1][0:NUMSRCH-1][0:SRAM_DELAY-1];
  integer vreg_int, vrpt_int, vrps_int;
  always @(posedge clk)
    for (vrpt_int=0; vrpt_int<NUMRDPT; vrpt_int=vrpt_int+1)
      for (vrps_int=0; vrps_int<NUMSRCH; vrps_int=vrps_int+1)
        for (vreg_int=0; vreg_int<SRAM_DELAY; vreg_int=vreg_int+1) 
          if (vreg_int>0) begin
            vread_reg[vrpt_int][vreg_int] <= vread_reg[vrpt_int][vreg_int-1];
            vread_fwrd_reg[vrpt_int][vrps_int][vreg_int] <= vread_fwrd_reg[vrpt_int][vrps_int][vreg_int-1];
            vread_data_reg[vrpt_int][vrps_int][vreg_int] <= vread_data_reg[vrpt_int][vrps_int][vreg_int-1];
          end else begin
            vread_reg[vrpt_int][vreg_int] <= vread_wire[vrpt_int];
            vread_fwrd_reg[vrpt_int][vrps_int][vreg_int] <= wr_srch_flag[vrpt_int][vrps_int];
            vread_data_reg[vrpt_int][vrps_int][vreg_int] <= wr_srch_data[vrpt_int][vrps_int];
          end

  reg vread_out [0:NUMRDPT-1];
  reg vread_fwrd_out [0:NUMRDPT-1];
  reg [WIDTH-1:0] vread_data_out [0:NUMRDPT-1];
  integer vdel_int, vdes_int;
  always_comb 
    for (vdel_int=0; vdel_int<NUMRDPT; vdel_int=vdel_int+1) begin
      vread_out[vdel_int] = vread_reg[vdel_int][SRAM_DELAY-1];
      vread_fwrd_out[vdel_int] = 1'b0;
      vread_data_out[vdel_int] = 0;
      for (vdes_int=0; vdes_int<NUMSRCH; vdes_int=vdes_int+1)
        if (vread_fwrd_reg[vdel_int][vdes_int][SRAM_DELAY-1]) begin
          vread_fwrd_out[vdel_int] = 1'b1;
          vread_data_out[vdel_int] = vread_data_reg[vdel_int][vdes_int][SRAM_DELAY-1];
        end
    end

  reg [NUMWTPT-1:0] t1_writeA;
  reg [NUMWTPT*BITADDR-1:0] t1_addrA;
  reg [NUMWTPT*WIDTH-1:0] t1_dinA;
  reg [NUMRDPT-1:0] t1_readB;
  reg [NUMRDPT*BITADDR-1:0] t1_addrB;
  integer prtb_int, prtw_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    for (prtb_int=0; prtb_int<NUMWTPT; prtb_int=prtb_int+1)
      if (prtb_int<wrfifo_cnt) begin
        t1_writeA[prtb_int] = 1'b1;
        for (prtw_int=0; prtw_int<BITADDR; prtw_int=prtw_int+1)
          t1_addrA[prtb_int*BITADDR+prtw_int] = wrfifo_new_adr[prtb_int][prtw_int];
        for (prtw_int=0; prtw_int<WIDTH; prtw_int=prtw_int+1)
          t1_dinA[prtb_int*WIDTH+prtw_int] = wrfifo_new_dat[prtb_int][prtw_int];
      end
    t1_readB = 0;
    t1_addrB = 0;
    for (prtb_int=0; prtb_int<NUMRDPT; prtb_int=prtb_int+1)
      if (vread_wire[prtb_int]) begin
        t1_readB[prtb_int] = 1'b1;
        for (prtw_int=0; prtw_int<BITADDR; prtw_int=prtw_int+1)
          t1_addrB[prtb_int*BITADDR+prtw_int] = vrdaddr_wire[prtb_int][prtw_int];
      end
  end

  reg               vread_vld_wire [0:NUMRDPT-1];
  reg [WIDTH-1:0]   vdout_wire [0:NUMRDPT-1];
  reg               vread_fwrd_wire [0:NUMRDPT-1];
  reg               vread_serr_wire [0:NUMRDPT-1];
  reg               vread_derr_wire [0:NUMRDPT-1];
  reg [BITPADR-1:0] vread_padr_wire [0:NUMRDPT-1];
  integer vrd_int;
  always_comb 
    for (vrd_int=0; vrd_int<NUMRDPT; vrd_int=vrd_int+1) begin
      vread_vld_wire[vrd_int] = vread_out[vrd_int];
      vdout_wire[vrd_int] = vread_fwrd_out[vrd_int] ? vread_data_out[vrd_int] : t1_doutB >> (vrd_int*WIDTH);
      vread_fwrd_wire[vrd_int] = t1_fwrdB >> vrd_int;
      vread_serr_wire[vrd_int] = t1_serrB >> vrd_int;
      vread_derr_wire[vrd_int] = t1_derrB >> vrd_int;
      vread_padr_wire[vrd_int] = t1_padrB >> (vrd_int*BITPADR);
    end

  reg [NUMRDPT-1:0]         vread_vld_tmp;
  reg [NUMRDPT*WIDTH-1:0]   vdout_tmp;
  reg [NUMRDPT-1:0]         vread_fwrd_tmp;
  reg [NUMRDPT-1:0]         vread_serr_tmp;
  reg [NUMRDPT-1:0]         vread_derr_tmp;
  reg [NUMRDPT*BITPADR-1:0] vread_padr_tmp;
  integer vwire_int;
  always_comb begin
    vread_vld_tmp = 0;
    vdout_tmp = 0;
    vread_fwrd_tmp = 0;
    vread_serr_tmp = 0;
    vread_derr_tmp = 0;
    vread_padr_tmp = 0;
    for (vwire_int=0; vwire_int<NUMRDPT; vwire_int=vwire_int+1) begin
      vread_vld_tmp = vread_vld_tmp | (vread_out[vwire_int] << vwire_int);
      vdout_tmp = vdout_tmp | (vdout_wire[vwire_int] << (vwire_int*WIDTH));
      vread_fwrd_tmp = vread_fwrd_tmp | (vread_fwrd_wire[vwire_int] << vwire_int);
      vread_serr_tmp = vread_serr_tmp | (vread_serr_wire[vwire_int] << vwire_int);
      vread_derr_tmp = vread_derr_tmp | (vread_derr_wire[vwire_int] << vwire_int);
      vread_padr_tmp = vread_padr_tmp | (vread_padr_wire[vwire_int] << (vwire_int*BITPADR));
    end
  end

  reg [NUMRDPT-1:0]         vread_vld;
  reg [NUMRDPT*WIDTH-1:0]   vdout;
  reg [NUMRDPT-1:0]         vread_fwrd;
  reg [NUMRDPT-1:0]         vread_serr;
  reg [NUMRDPT-1:0]         vread_derr;
  reg [NUMRDPT*BITPADR-1:0] vread_padr;
  reg vwr_bp;

  generate if (FLOPOUT) begin: flp_loop
    always @(posedge clk) begin
      vread_vld <= vread_vld_tmp;
      vdout <= vdout_tmp;
      vread_fwrd <= vread_fwrd_tmp;
      vread_serr <= vread_serr_tmp;
      vread_derr <= vread_derr_tmp;
      vread_padr <= vread_padr_tmp;
      vwr_bp <= (wrfifo_cnt > bp_thr_wire);
    end
  end else begin: nflp_loop
    always_comb begin
      vread_vld = vread_vld_tmp;
      vdout = vdout_tmp;
      vread_fwrd = vread_fwrd_tmp;
      vread_serr = vread_serr_tmp;
      vread_derr = vread_derr_tmp;
      vread_padr = vread_padr_tmp;
      vwr_bp = (wrfifo_cnt > bp_thr_wire);
    end
  end
  endgenerate

endmodule



