
module core_mrnwapd_1r1w_fl (vwrite, vwrite_bp, vwraddr, vdin, bp_thr,
                             vread, vrdaddr, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                             vdeq, vdqaddr,
                             t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                             t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
                             ready, clk, rst);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMRDPT = 2;
  parameter NUMWRPT = 2;
  parameter NUMDQPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPADR = 15;
  
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter NUMSBFL = SRAM_DELAY+2;
  parameter NUMARPT = 4;
  parameter NUMFPAD = 4;

  output                         vwrite_bp;

  input [NUMWRPT-1:0]            vwrite;
  output [NUMWRPT*BITADDR-1:0]   vwraddr;
  input [NUMWRPT*WIDTH-1:0]      vdin;

  input [7:0]                    bp_thr;

  input [NUMRDPT-1:0]            vread;
  input [NUMRDPT*BITADDR-1:0]    vrdaddr;
  output [NUMRDPT-1:0]           vread_vld;
  output [NUMRDPT*WIDTH-1:0]     vdout;
  output [NUMRDPT-1:0]           vread_fwrd;
  output [NUMRDPT-1:0]           vread_serr;
  output [NUMRDPT-1:0]           vread_derr;
  output [NUMRDPT*BITPADR-1:0]   vread_padr;

  input [NUMDQPT-1:0]            vdeq;
  input [NUMDQPT*BITADDR-1:0]    vdqaddr;

  output [NUMRDPT*NUMVBNK-1:0]          t1_writeA;
  output [NUMRDPT*NUMVBNK*BITVROW-1:0]  t1_addrA;
  output [NUMRDPT*NUMVBNK*WIDTH-1:0]    t1_dinA;
  output [NUMRDPT*NUMVBNK-1:0]          t1_readB;
  output [NUMRDPT*NUMVBNK*BITVROW-1:0]  t1_addrB;
  input [NUMRDPT*NUMVBNK*WIDTH-1:0]     t1_doutB;
  input [NUMRDPT*NUMVBNK-1:0]           t1_fwrdB;
  input [NUMRDPT*NUMVBNK-1:0]           t1_serrB;
  input [NUMRDPT*NUMVBNK-1:0]           t1_derrB;
  input [NUMRDPT*NUMVBNK*(BITPADR-BITVBNK)-1:0] t1_padrB;

  output [NUMDQPT*NUMVBNK-1:0]          t2_writeA;
  output [NUMDQPT*NUMVBNK*BITVROW-1:0]  t2_addrA;
  output [NUMDQPT*NUMVBNK*BITVROW-1:0]  t2_dinA;

  output [NUMDQPT*NUMVBNK-1:0]          t2_readB;
  output [NUMDQPT*NUMVBNK*BITVROW-1:0]  t2_addrB;
  input [NUMDQPT*NUMVBNK*BITVROW-1:0]   t2_doutB;


  output                             ready;
  input                              clk;
  input                              rst;

  reg [BITVROW:0] rstaddr;
  wire rstvld = (rstaddr != NUMVROW-2);
  always @(posedge clk)
    if (rst)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;

  reg ready;
  always @(posedge clk)
    ready <= !rstvld;

  wire               ready_wire;
  wire               vwrite_wire [0:NUMWRPT-1];
  wire [WIDTH-1:0]   vdin_wire [0:NUMWRPT-1];
  wire               vread_wire [0:NUMRDPT-1];
  wire [BITADDR-1:0] vrdaddr_wire [0:NUMRDPT-1];
  wire [BITVBNK-1:0] vrdbadr_wire [0:NUMRDPT-1];
  wire [BITVROW-1:0] vrdradr_wire [0:NUMRDPT-1];
  wire               vdeq_wire [0:NUMDQPT-1];
  wire [BITADDR-1:0] vdqaddr_wire [0:NUMDQPT-1];
  wire [BITVBNK-1:0] vdqbadr_wire [0:NUMDQPT-1];
  wire [BITVROW-1:0] vdqradr_wire [0:NUMDQPT-1];

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg [NUMWRPT-1:0] vwrite_reg;
    reg [NUMWRPT*WIDTH-1:0] vdin_reg;
    reg [NUMRDPT-1:0] vread_reg;
    reg [NUMRDPT*BITADDR-1:0] vrdaddr_reg;
    reg [NUMRDPT-1:0] vdeq_reg;
    reg [NUMRDPT*BITADDR-1:0] vdqaddr_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vwrite_reg <= vwrite & {NUMWRPT{ready}};
      vdin_reg <= vdin;
      vread_reg <= vread & {NUMRDPT{ready}};
      vrdaddr_reg <= vrdaddr;
      vdeq_reg <= vdeq & {NUMDQPT{ready}};
      vdqaddr_reg <= vdqaddr;
    end

    assign ready_wire = ready_reg;
    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = vwrite_reg >> np2_var;
      assign vdin_wire[np2_var] = vdin_reg >> (np2_var*WIDTH);
    end
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread_reg >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr_reg >> (np2_var*BITADDR);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
    end
    for (np2_var=0; np2_var<NUMDQPT; np2_var=np2_var+1) begin: dq_loop
      assign vdeq_wire[np2_var] = vdeq_reg >> np2_var;
      assign vdqaddr_wire[np2_var] = vdqaddr_reg >> (np2_var*BITADDR);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        dq_adr_inst (.vbadr(vdqbadr_wire[np2_var]), .vradr(vdqradr_wire[np2_var]), .vaddr(vdqaddr_wire[np2_var]));
    end
  end else begin: noflpi_loop
    assign ready_wire = ready; 
    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = (vwrite & {NUMWRPT{ready}}) >> np2_var;
      assign vdin_wire[np2_var] = vdin >> (np2_var*WIDTH);
    end
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = (vread & {NUMRDPT{ready}}) >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr >> (np2_var*BITADDR);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
    end
    for (np2_var=0; np2_var<NUMDQPT; np2_var=np2_var+1) begin: dq_loop
      assign vdeq_wire[np2_var] = (vdeq & {NUMDQPT{ready}}) >> np2_var;
      assign vdqaddr_wire[np2_var] = vdqaddr >> (np2_var*BITADDR);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        dq_adr_inst (.vbadr(vdqbadr_wire[np2_var]), .vradr(vdqradr_wire[np2_var]), .vaddr(vdqaddr_wire[np2_var]));
    end
  end
  endgenerate

//  reg                vwrite_reg [0:NUMWRPT-1][0:DRAM_DELAY-1];
//  reg [WIDTH-1:0]    vdin_reg [0:NUMWRPT-1][0:DRAM_DELAY-1];
  reg                vread_reg [0:NUMRDPT-1][0:DRAM_DELAY-1];
  reg [BITVBNK-1:0]  vrdbadr_reg [0:NUMRDPT-1][0:DRAM_DELAY-1];
  reg [BITVROW-1:0]  vrdradr_reg [0:NUMRDPT-1][0:DRAM_DELAY-1];
  reg                vdeq_reg [0:NUMDQPT-1][0:DRAM_DELAY-1];
  reg [BITVBNK-1:0]  vdqbadr_reg [0:NUMDQPT-1][0:DRAM_DELAY-1];
  reg [BITVROW-1:0]  vdqradr_reg [0:NUMDQPT-1][0:DRAM_DELAY-1];
  integer vprt_int, vdel_int; 
  always @(posedge clk)
    for (vdel_int=0; vdel_int<DRAM_DELAY; vdel_int=vdel_int+1) begin
//      for (vprt_int=0; vprt_int<NUMWRPT; vprt_int=vprt_int+1)
//        if (vdel_int > 0) begin
//          vwrite_reg[vprt_int][vdel_int] <= vwrite_reg[vprt_int][vdel_int-1];
//          vdin_reg[vprt_int][vdel_int] <= vdin_reg[vprt_int][vdel_int-1];
//        end else begin
//          vwrite_reg[vprt_int][vdel_int] <= vwrite_wire[vprt_int];
//          vdin_reg[vprt_int][vdel_int] <= vdin_wire[vprt_int];
//        end
      for (vprt_int=0; vprt_int<NUMRDPT; vprt_int=vprt_int+1)
        if (vdel_int > 0) begin
          vread_reg[vprt_int][vdel_int] <= vread_reg[vprt_int][vdel_int-1];
          vrdbadr_reg[vprt_int][vdel_int] <= vrdbadr_reg[vprt_int][vdel_int-1];
          vrdradr_reg[vprt_int][vdel_int] <= vrdradr_reg[vprt_int][vdel_int-1];
        end else begin
          vread_reg[vprt_int][vdel_int] <= vread_wire[vprt_int];
          vrdbadr_reg[vprt_int][vdel_int] <= vrdbadr_wire[vprt_int];
          vrdradr_reg[vprt_int][vdel_int] <= vrdradr_wire[vprt_int];
        end
      for (vprt_int=0; vprt_int<NUMDQPT; vprt_int=vprt_int+1)
        if (vdel_int > 0) begin
          vdeq_reg[vprt_int][vdel_int] <= vdeq_reg[vprt_int][vdel_int-1];
          vdqbadr_reg[vprt_int][vdel_int] <= vdqbadr_reg[vprt_int][vdel_int-1];
          vdqradr_reg[vprt_int][vdel_int] <= vdqradr_reg[vprt_int][vdel_int-1];
        end else begin
          vdeq_reg[vprt_int][vdel_int] <= vdeq_wire[vprt_int];
          vdqbadr_reg[vprt_int][vdel_int] <= vdqbadr_wire[vprt_int];
          vdqradr_reg[vprt_int][vdel_int] <= vdqradr_wire[vprt_int];
        end
    end

//  reg               vwrite_out [0:NUMWRPT-1];
//  reg [WIDTH-1:0]   vdin_out [0:NUMWRPT-1];
  reg               vread_out [0:NUMRDPT-1];
  reg [BITVBNK-1:0] vrdbadr_out [0:NUMRDPT-1];
  reg [BITVROW-1:0] vrdradr_out [0:NUMRDPT-1];
  reg               vdeq_out [0:NUMDQPT-1];
  reg [BITVBNK-1:0] vdqbadr_out [0:NUMDQPT-1];
  reg [BITVROW-1:0] vdqradr_out [0:NUMDQPT-1];
  integer prto_int;
  always_comb begin
//    for (prto_int=0; prto_int<NUMWRPT; prto_int=prto_int+1) begin
//      if (prto_int<NUMARPT)
//        vwrite_out[prto_int] = vwrite_reg[prto_int][0];
//      else
//        vwrite_out[prto_int] = vwrite_reg[prto_int][1];
//      vdin_out[prto_int] = vdin_reg[prto_int][2];
//    end
    for (prto_int=0; prto_int<NUMRDPT; prto_int=prto_int+1) begin
      vread_out[prto_int] = vread_reg[prto_int][DRAM_DELAY-1];
      vrdbadr_out[prto_int] = vrdbadr_reg[prto_int][DRAM_DELAY-1];
      vrdradr_out[prto_int] = vrdradr_reg[prto_int][DRAM_DELAY-1];
    end
    for (prto_int=0; prto_int<NUMDQPT; prto_int=prto_int+1) begin
      vdeq_out[prto_int] = vdeq_reg[prto_int][DRAM_DELAY-1];
      vdqbadr_out[prto_int] = vdqbadr_reg[prto_int][DRAM_DELAY-1];
      vdqradr_out[prto_int] = vdqradr_reg[prto_int][DRAM_DELAY-1];
    end
  end

  reg pwrite_wire [0:NUMWRPT-1];
  reg [BITVBNK-1:0] pwrbadr_wire [0:NUMWRPT-1];
  reg [BITVROW-1:0] pwrradr_wire [0:NUMWRPT-1];
  reg [WIDTH-1:0] pdin_wire [0:NUMWRPT-1];

  wire pwrite_wire_0 = pwrite_wire[0];
  wire [BITVBNK-1:0] pwrbadr_wire_0 = pwrbadr_wire[0];
  wire [BITVROW-1:0] pwrradr_wire_0 = pwrradr_wire[0];
  wire [WIDTH-1:0] pdin_wire_0 = pdin_wire[0];

  wire pwrite_wire_1 = pwrite_wire[1];
  wire [BITVBNK-1:0] pwrbadr_wire_1 = pwrbadr_wire[1];
  wire [BITVROW-1:0] pwrradr_wire_1 = pwrradr_wire[1];
  wire [WIDTH-1:0] pdin_wire_1 = pdin_wire[1];
/*
  wire pwrite_wire_2 = pwrite_wire[2];
  wire [BITVBNK-1:0] pwrbadr_wire_2 = pwrbadr_wire[2];
  wire [BITVROW-1:0] pwrradr_wire_2 = pwrradr_wire[2];
  wire [WIDTH-1:0] pdin_wire_2 = pdin_wire[2];
*/
  reg swrite_wire [0:NUMVBNK-1][0:NUMDQPT-1];
  reg [BITVROW-1:0] swrradr_wire [0:NUMVBNK-1][0:NUMDQPT-1];
  reg [BITVROW-1:0] sdin_wire [0:NUMVBNK-1][0:NUMDQPT-1];

  wire swrite_wire_0_0 = swrite_wire[0][0];
  wire [BITVROW-1:0] swrradr_wire_0_0 = swrradr_wire[0][0];
  wire [BITVROW-1:0] sdin_wire_0_0 = sdin_wire[0][0];
  wire swrite_wire_0_1 = swrite_wire[0][1];
  wire [BITVROW-1:0] swrradr_wire_0_1 = swrradr_wire[0][1];
  wire [BITVROW-1:0] sdin_wire_0_1 = sdin_wire[0][1];
/*
  wire swrite_wire_1 = swrite_wire[1];
  wire [BITVROW-1:0] swrradr_wire_1 = swrradr_wire[1];
  wire [BITVROW-1:0] sdin_wire_1 = sdin_wire[1];
  wire swrite_wire_2 = swrite_wire[2];
  wire [BITVROW-1:0] swrradr_wire_2 = swrradr_wire[2];
  wire [BITVROW-1:0] sdin_wire_2 = sdin_wire[2];
*/
  reg sread_wire [0:NUMVBNK-1][0:NUMDQPT-1];
  reg [BITVROW-1:0] srdradr_wire [0:NUMVBNK-1][0:NUMDQPT-1];

  wire sread_wire_0_0 = sread_wire[0][0];
  wire [BITVROW-1:0] srdradr_wire_0_0 = srdradr_wire[0][0];
  wire sread_wire_0_1 = sread_wire[0][1];
  wire [BITVROW-1:0] srdradr_wire_0_1 = srdradr_wire[0][1];
/*
  wire sread_wire_1 = sread_wire[1];
  wire [BITVROW-1:0] srdradr_wire_1 = srdradr_wire[1];
  wire sread_wire_2 = sread_wire[2];
  wire [BITVROW-1:0] srdradr_wire_2 = srdradr_wire[2];
  wire sread_wire_3 = sread_wire[3];
  wire [BITVROW-1:0] srdradr_wire_3 = srdradr_wire[3];
*/

  reg vread_vld_wire [0:NUMRDPT-1];
  reg vread_fwrd_wire [0:NUMRDPT-1];
  reg vread_serr_wire [0:NUMRDPT-1];
  reg vread_derr_wire [0:NUMRDPT-1];
  reg [BITPADR-1:0] vread_padr_wire [0:NUMRDPT-1];
  reg [BITPADR-BITVBNK-1:0] vread_padr_temp [0:NUMRDPT-1];
  reg [WIDTH-1:0] vdout_wire [0:NUMRDPT-1];
  integer vdop_int;
  always_comb
    for (vdop_int=0; vdop_int<NUMRDPT; vdop_int=vdop_int+1) begin
      vread_vld_wire[vdop_int] = vread_out[vdop_int];
      vread_fwrd_wire[vdop_int] = t1_fwrdB >> (NUMVBNK*vdop_int+vrdbadr_out[vdop_int]);
      vread_serr_wire[vdop_int] = t1_serrB >> (NUMVBNK*vdop_int+vrdbadr_out[vdop_int]);
      vread_derr_wire[vdop_int] = t1_derrB >> (NUMVBNK*vdop_int+vrdbadr_out[vdop_int]);
      vread_padr_temp[vdop_int] = t1_padrB >> ((NUMVBNK*vdop_int+vrdbadr_out[vdop_int])*(BITPADR-BITVBNK));
      vread_padr_wire[vdop_int] = {vrdbadr_out[vdop_int],vread_padr_temp[vdop_int]};
      vdout_wire[vdop_int] = t1_doutB >> ((NUMVBNK*vdop_int+vrdbadr_out[vdop_int])*WIDTH);
    end

  reg [NUMRDPT-1:0] vread_vld_tmp;
  reg [NUMRDPT-1:0] vread_fwrd_tmp;
  reg [NUMRDPT-1:0] vread_serr_tmp;
  reg [NUMRDPT-1:0] vread_derr_tmp;
  reg [NUMRDPT*BITPADR-1:0] vread_padr_tmp;
  reg [NUMRDPT*WIDTH-1:0] vdout_tmp;
  integer vdo_int, vdow_int;
  always_comb
    for (vdo_int=0; vdo_int<NUMRDPT; vdo_int=vdo_int+1) begin
      vread_vld_tmp[vdo_int] = vread_vld_wire[vdo_int];
      for (vdow_int=0; vdow_int<WIDTH; vdow_int=vdow_int+1)
        vdout_tmp[vdo_int*WIDTH+vdow_int] = vdout_wire[vdo_int][vdow_int];
      vread_fwrd_tmp[vdo_int] = vread_fwrd_wire[vdo_int];
      vread_serr_tmp[vdo_int] = vread_serr_wire[vdo_int];
      vread_derr_tmp[vdo_int] = vread_derr_wire[vdo_int];
      for (vdow_int=0; vdow_int<BITPADR; vdow_int=vdow_int+1)
        vread_padr_tmp[vdo_int*BITPADR+vdow_int] = vread_padr_wire[vdo_int][vdow_int];
    end

  reg [NUMRDPT-1:0] vread_vld;
  reg [NUMRDPT-1:0] vread_fwrd;
  reg [NUMRDPT-1:0] vread_serr;
  reg [NUMRDPT-1:0] vread_derr;
  reg [NUMRDPT*BITPADR-1:0] vread_padr;
  reg [NUMRDPT*WIDTH-1:0] vdout;
  generate if (FLOPOUT) begin: flp_loop
    always @(posedge clk) begin
      vread_vld <= vread_vld_tmp;
      vdout <= vdout_tmp;
      vread_fwrd <= vread_fwrd_tmp;
      vread_serr <= vread_serr_tmp;
      vread_derr <= vread_derr_tmp;
      vread_padr <= vread_padr_tmp;
    end
  end else begin: nflp_loop
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

  reg [BITVROW-1:0] freehead [0:NUMSBFL-1][0:NUMVBNK-1];
  reg [BITVROW-1:0] freetail [0:NUMSBFL-1][0:NUMVBNK-1];
  reg [BITVROW:0]   freecnt [0:NUMVBNK-1];
  reg [3:0]         free_enq_ptr [0:NUMVBNK-1];
  reg [3:0]         free_deq_ptr [0:NUMVBNK-1];

  reg [NUMVBNK-1:0] free_pivot_bp;
  integer frbp_int;
  always @(posedge clk)
    for (frbp_int=0; frbp_int<NUMVBNK; frbp_int=frbp_int+1)
      free_pivot_bp[frbp_int] <= (freecnt[frbp_int] > NUMSBFL+5+NUMFPAD+bp_thr);

  reg [BITVBNK:0] free_pivot_cnt;
  integer frcb_int;
  always_comb begin
    free_pivot_cnt = 0;
    for (frcb_int=0; frcb_int<NUMVBNK; frcb_int=frcb_int+1)
      if (free_pivot_bp[frcb_int])
        free_pivot_cnt = free_pivot_cnt + 1;
  end

  reg [BITADDR:0] totalcnt;
  integer totb_int, tots_int;
  always_comb begin
    totalcnt = 0;
    for (totb_int=0; totb_int<NUMVBNK; totb_int=totb_int+1)
      totalcnt = totalcnt + freecnt[totb_int];
  end

  assign vwrite_bp = (free_pivot_cnt < (NUMRDPT+NUMWRPT));
//  assign vwrite_bp = (totalcnt <= (NUMVROW+(NUMVBNK-1)*NUMSBFL));

  wire totalcnt_thr_0 = (totalcnt <= (NUMVBNK*NUMSBFL));
  wire totalcnt_thr_1 = (totalcnt <= (NUMVBNK*NUMSBFL+1));
  wire totalcnt_thr_2 = (totalcnt <= (NUMVBNK*NUMSBFL+2));
  wire totalcnt_thr_3 = (totalcnt <= (NUMVBNK*NUMSBFL+3));
  wire totalcnt_thr_4 = (totalcnt <= (NUMVBNK*NUMSBFL+4));
  wire totalcnt_thr_5 = (totalcnt <= (NUMVBNK*NUMSBFL+5));
  wire totalcnt_thr_6 = (totalcnt <= (NUMVBNK*NUMSBFL+6));
  wire totalcnt_thr_7 = (totalcnt <= (NUMVBNK*NUMSBFL+7));
/*
  wire [BITVROW-1:0] freehead_0_0 = freehead[0][0];
  wire [BITVROW-1:0] freetail_0_0 = freetail[0][0];
  wire [BITVROW-1:0] freehead_1_0 = freehead[1][0];
  wire [BITVROW-1:0] freetail_1_0 = freetail[1][0];
  wire [BITVROW-1:0] freehead_2_0 = freehead[2][0];
  wire [BITVROW-1:0] freetail_2_0 = freetail[2][0];
  wire [BITVROW-1:0] freehead_3_0 = freehead[3][0];
  wire [BITVROW-1:0] freetail_3_0 = freetail[3][0];
  wire [BITVROW:0] freecnt_0 = freecnt[0];
  wire [BITVROW:0] freecnt_1 = freecnt[1];
  wire [BITVROW:0] freecnt_2 = freecnt[2];
  wire [BITVROW:0] freecnt_3 = freecnt[3];
  wire [3:0] free_enq_ptr_0 = free_enq_ptr[0];
  wire [3:0] free_deq_ptr_0 = free_deq_ptr[0];
*/
  reg [NUMVBNK-1:0] free_pivot_next;
  integer frei_int;
  always_comb begin
    free_pivot_next = 0;
    for (frei_int=0; frei_int<NUMVBNK; frei_int=frei_int+1)
      if (freecnt[frei_int] > NUMSBFL+4+NUMFPAD)
        free_pivot_next = free_pivot_next | (1'b1 << frei_int);
  end

  reg [NUMVBNK-1:0] free_pivot_init;
  always @(posedge clk)
    free_pivot_init <= free_pivot_next;

  reg [NUMVBNK-1:0] free_pivot_temp [0:NUMWRPT-1];
  reg [NUMVBNK-1:0] free_pivot [0:NUMWRPT-1];
  reg [NUMVBNK-1:0] new_pivot [0:NUMWRPT-1];
  reg               new_vld [0:NUMWRPT-1];
  reg [BITVBNK-1:0] new_bnk [0:NUMWRPT-1];
  integer newp_int, newx_int;
  always_comb
    for (newp_int=0; newp_int<NUMWRPT; newp_int=newp_int+2) begin
      new_vld[newp_int] = 1'b0;
      new_bnk[newp_int] = 0;
      for (newx_int=NUMVBNK-1; newx_int>=0; newx_int=newx_int-1)
        if (free_pivot_temp[newp_int][newx_int]) begin
          new_vld[newp_int] = 1'b1;
          new_bnk[newp_int] = newx_int;
        end
      new_vld[newp_int+1] = 1'b0;
      new_bnk[newp_int+1] = 0;
      for (newx_int=0; newx_int<NUMVBNK; newx_int=newx_int+1)
        if (free_pivot_temp[newp_int+1][newx_int]) begin
          new_vld[newp_int+1] = 1'b1;
          new_bnk[newp_int+1] = newx_int;
        end
    end

  wire               new_vld_temp [0:NUMWRPT-1];
  wire [BITVBNK-1:0] new_bnk_temp [0:NUMWRPT-1];
  genvar newd_var;
  generate for (newd_var=0; newd_var<NUMWRPT; newd_var=newd_var+1) begin: nvld_loop
    if (newd_var<NUMARPT) begin: flp_loop
      reg new_vld_del [0:1];
      reg [BITVBNK-1:0] new_bnk_del [0:1];
      always @(posedge clk) begin
        new_vld_del[1] <= new_vld_del[0];
        new_bnk_del[1] <= new_bnk_del[0];
        new_vld_del[0] <= new_vld[newd_var];
        new_bnk_del[0] <= new_bnk[newd_var];
      end

      assign new_vld_temp[newd_var] = new_vld_del[1] && vwrite_wire[newd_var]; 
      assign new_bnk_temp[newd_var] = new_bnk_del[1];
    end else begin: nflp_loop
      reg new_vld_del;
      reg [BITVBNK-1:0] new_bnk_del;
      always @(posedge clk) begin
        new_vld_del <= new_vld[newd_var];
        new_bnk_del <= new_bnk[newd_var];
      end

      assign new_vld_temp[newd_var] = new_vld_del && vwrite_wire[newd_var]; 
      assign new_bnk_temp[newd_var] = new_bnk_del;
    end
  end
  endgenerate

  wire new_vld_0 = new_vld[0];
  wire [BITVBNK-1:0] new_bnk_0 = new_bnk[0];
  wire new_vld_1 = new_vld[1];
  wire [BITVBNK-1:0] new_bnk_1 = new_bnk[1];

  wire new_vld_temp_0 = new_vld_temp[0];
  wire [BITVBNK-1:0] new_bnk_temp_0 = new_bnk_temp[0];
  wire new_vld_temp_1 = new_vld_temp[1];
  wire [BITVBNK-1:0] new_bnk_temp_1 = new_bnk_temp[1];

  reg [NUMVBNK-1:0] free_pivot_reg [0:1];
  always @(posedge clk) begin
    free_pivot_reg[0] <= free_pivot[NUMARPT-2];
    free_pivot_reg[1] <= free_pivot[NUMARPT-1];
  end

  wire [NUMVBNK-1:0] free_pivot_0 = free_pivot[0];
  wire [NUMVBNK-1:0] free_pivot_1 = free_pivot[1];
  wire [NUMVBNK-1:0] free_pivot_temp_0 = free_pivot_temp[0];
  wire [NUMVBNK-1:0] free_pivot_temp_1 = free_pivot_temp[1];

  integer usep_int;
  always_comb
    for (usep_int=0; usep_int<NUMWRPT; usep_int=usep_int+1) begin
      if (usep_int==0)
        free_pivot_temp[usep_int] = free_pivot_init;
      else if (usep_int==1)
        free_pivot_temp[usep_int] = free_pivot_init;
      else if (usep_int==NUMARPT)
        free_pivot_temp[usep_int] = free_pivot_reg[0];
      else if (usep_int==NUMARPT+1)
        free_pivot_temp[usep_int] = free_pivot_reg[1];
      else
        free_pivot_temp[usep_int] = free_pivot[usep_int-2];
      new_pivot[usep_int] = new_vld[usep_int] ? (1'b1 << new_bnk[usep_int]) : 0;
      free_pivot[usep_int] = free_pivot_temp[usep_int] & ~new_pivot[usep_int];
    end

  reg new_enq [0:NUMVBNK-1];
  reg [BITVROW-1:0] new_radr [0:NUMVBNK-1];
  integer newe_int, newb_int;
  always_comb
    for (newb_int=0; newb_int<NUMVBNK; newb_int=newb_int+1) begin
      new_enq[newb_int] = 1'b0;
      for (newe_int=0; newe_int<NUMWRPT; newe_int=newe_int+1)
        if (new_vld_temp[newe_int] && (new_bnk_temp[newe_int] == newb_int))
          new_enq[newb_int] = 1'b1;
      new_radr[newb_int] = freehead[free_enq_ptr[newb_int]][newb_int];
    end 

  reg [NUMVBNK-1:0] new_deq [0:NUMDQPT-1];
  integer deqb_int;
  always @(posedge clk)
    for (deqb_int=0; deqb_int<NUMDQPT; deqb_int=deqb_int+1) 
      if (vdeq_wire[deqb_int])
        new_deq[deqb_int] <= (1'b1 << vdqbadr_wire[deqb_int]);
      else
        new_deq[deqb_int] <= 0;

  wire new_enq_0 = new_enq[0];
  wire new_enq_1 = new_enq[1];
  wire new_enq_2 = new_enq[2];
  wire new_enq_3 = new_enq[3];
  wire [BITVROW-1:0] new_radr_0 = new_radr[0];
  wire [BITVROW-1:0] new_radr_1 = new_radr[1];
  wire [NUMVBNK-1:0] new_deq_0 = new_deq[0];
  wire [NUMVBNK-1:0] new_deq_1 = new_deq[1];

  reg [3:0] free_deq_ptr_nxt [0:NUMVBNK-1][0:NUMDQPT];
  integer fdqb_int, fdqp_int;
  always_comb
    for (fdqb_int=0; fdqb_int<NUMVBNK; fdqb_int=fdqb_int+1) begin
      free_deq_ptr_nxt[fdqb_int][0] = free_deq_ptr[fdqb_int];
      for (fdqp_int=0; fdqp_int<NUMDQPT; fdqp_int=fdqp_int+1)
        if (vdeq_out[fdqp_int] && (vdqbadr_out[fdqp_int] == fdqb_int))
          free_deq_ptr_nxt[fdqb_int][fdqp_int+1] = (free_deq_ptr_nxt[fdqb_int][fdqp_int] + 1) % NUMSBFL;
        else
          free_deq_ptr_nxt[fdqb_int][fdqp_int+1] = free_deq_ptr_nxt[fdqb_int][fdqp_int];
    end

  wire [3:0] free_deq_ptr_nxt_0_0 = free_deq_ptr_nxt[0][0];
  wire [3:0] free_deq_ptr_nxt_0_1 = free_deq_ptr_nxt[0][1];
  wire [3:0] free_deq_ptr_nxt_0_2 = free_deq_ptr_nxt[0][2];

  integer fptb_int, fptr_int;
  always @(posedge clk)
    for (fptb_int=0; fptb_int<NUMVBNK; fptb_int=fptb_int+1)
      if (rst) begin
        free_enq_ptr[fptb_int] <= 0;
        free_deq_ptr[fptb_int] <= 0;
      end else begin
        if (new_enq[fptb_int])
          free_enq_ptr[fptb_int] <= (free_enq_ptr[fptb_int] + 1) % NUMSBFL;
        free_deq_ptr[fptb_int] <= free_deq_ptr_nxt[fptb_int][NUMDQPT];
      end

  reg       new_enq_reg [0:NUMVBNK-1][0:SRAM_DELAY-1];
  reg [3:0] new_list_reg [0:NUMVBNK-1][0:SRAM_DELAY-1];
  integer fnwb_int, fnwd_int;
  always @(posedge clk)
    for (fnwb_int=0; fnwb_int<NUMVBNK; fnwb_int=fnwb_int+1)
      for (fnwd_int=0; fnwd_int<SRAM_DELAY; fnwd_int=fnwd_int+1)
        if (fnwd_int>0) begin
          new_enq_reg[fnwb_int][fnwd_int] <= new_enq_reg[fnwb_int][fnwd_int-1];
          new_list_reg[fnwb_int][fnwd_int] <= new_list_reg[fnwb_int][fnwd_int-1];
        end else begin
          new_enq_reg[fnwb_int][fnwd_int] <= new_enq[fnwb_int];
          new_list_reg[fnwb_int][fnwd_int] <= free_enq_ptr[fnwb_int];
        end

  reg [BITVROW:0] freecnt_nxt [0:NUMVBNK-1];
  integer fctb_int, fctr_int;
  always_comb
    for (fctb_int=0; fctb_int<NUMVBNK; fctb_int=fctb_int+1) begin
      freecnt_nxt[fctb_int] = freecnt[fctb_int];
      if (new_enq_reg[fctb_int][0])
        freecnt_nxt[fctb_int] = freecnt_nxt[fctb_int] - 1;
      for (fctr_int=0; fctr_int<NUMDQPT; fctr_int=fctr_int+1)
        if (new_deq[fctr_int][fctb_int])
          freecnt_nxt[fctb_int] = freecnt_nxt[fctb_int] + 1;
    end

  integer frer_int, freb_int, fres_int;
  always @(posedge clk)
    if (rst)
      for (freb_int=0; freb_int<NUMVBNK; freb_int=freb_int+1) begin
        for (fres_int=0; fres_int<NUMSBFL; fres_int=fres_int+1) begin
          freehead[fres_int][freb_int] <= fres_int;
          freetail[fres_int][freb_int] <= (NUMSBFL==2) ? NUMVROW-NUMSBFL + fres_int : NUMVROW-NUMVROW%NUMSBFL-NUMSBFL+fres_int;
        end
        freecnt[freb_int] <= NUMVROW - NUMVROW%NUMSBFL;
      end
    else begin
      for (frer_int=0; frer_int<NUMDQPT; frer_int=frer_int+1)
        if (vdeq_out[frer_int])
          freetail[free_deq_ptr_nxt[vdqbadr_out[frer_int]][frer_int]][vdqbadr_out[frer_int]] <= vdqradr_out[frer_int];
      for (freb_int=0; freb_int<NUMVBNK; freb_int=freb_int+1)
        if (new_enq_reg[freb_int][SRAM_DELAY-1])
          freehead[new_list_reg[freb_int][SRAM_DELAY-1]][freb_int] <= t2_doutB >> ((new_list_reg[freb_int][SRAM_DELAY-1][0]*NUMVBNK+freb_int)*BITVROW);
      for (freb_int=0; freb_int<NUMVBNK; freb_int=freb_int+1)
        freecnt[freb_int] <= freecnt_nxt[freb_int];
    end

  integer pwrp_int;
  always_comb
    for (pwrp_int=0; pwrp_int<NUMWRPT; pwrp_int=pwrp_int+1) begin
      pwrite_wire[pwrp_int] = new_vld_temp[pwrp_int];
      pwrbadr_wire[pwrp_int] = new_bnk_temp[pwrp_int];
      pwrradr_wire[pwrp_int] = new_radr[new_bnk_temp[pwrp_int]];
      pdin_wire[pwrp_int] = vdin_wire[pwrp_int];
    end

  reg [NUMWRPT*BITADDR-1:0] vwraddr;
  integer vwra_int;
  always_comb begin
    vwraddr = 0;
    for (vwra_int=0; vwra_int<NUMWRPT; vwra_int=vwra_int+1)
      if (NUMVROW == (1 << BITVROW))
        vwraddr = vwraddr | ({pwrbadr_wire[vwra_int],pwrradr_wire[vwra_int]} << (vwra_int*BITADDR)); 
      else
        vwraddr = vwraddr | ({pwrradr_wire[vwra_int],pwrbadr_wire[vwra_int]} << (vwra_int*BITADDR)); 
  end

  integer swrr_int, swrb_int, swrd_int;
  always_comb
    for (swrb_int=0; swrb_int<NUMVBNK; swrb_int=swrb_int+1) begin
      for (swrd_int=0; swrd_int<NUMDQPT; swrd_int=swrd_int+1) begin
        swrite_wire[swrb_int][swrd_int] = 1'b0;
        swrradr_wire[swrb_int][swrd_int] = 0;
        sdin_wire[swrb_int][swrd_int] = 0;
        for (swrr_int=0; swrr_int<NUMDQPT; swrr_int=swrr_int+1)
          if (vdeq_out[swrr_int] && (vdqbadr_out[swrr_int] == swrb_int)) begin
            swrite_wire[swrb_int][free_deq_ptr_nxt[swrb_int][swrr_int][0]] = 1'b1;
            swrradr_wire[swrb_int][free_deq_ptr_nxt[swrb_int][swrr_int][0]] = freetail[free_deq_ptr_nxt[swrb_int][swrr_int]][swrb_int];
            sdin_wire[swrb_int][free_deq_ptr_nxt[swrb_int][swrr_int][0]] = vdqradr_out[swrr_int];
          end
        if (rstvld && !rst) begin
          swrite_wire[swrb_int][swrd_int] = 1'b1;
          swrradr_wire[swrb_int][swrd_int] = rstaddr;
          sdin_wire[swrb_int][swrd_int] = rstaddr+NUMSBFL;
        end
      end
    end
     
  integer srdb_int, srdd_int;
  always_comb 
    for (srdb_int=0; srdb_int<NUMVBNK; srdb_int=srdb_int+1) begin
      for (srdd_int=0; srdd_int<NUMDQPT; srdd_int=srdd_int+1) begin
        sread_wire[srdb_int][srdd_int] = 1'b0;
        srdradr_wire[srdb_int][srdd_int] = 0;
      end
      if (new_enq[srdb_int])
        sread_wire[srdb_int][free_enq_ptr[srdb_int][0]] = 1'b1;
      srdradr_wire[srdb_int][free_enq_ptr[srdb_int][0]] = new_radr[srdb_int];
    end

/*
  wire [BITVBNK-1:0] new_bank_0 = new_bank[0];
  wire [BITVBNK-1:0] new_bank_1 = new_bank[1];
  wire [3:0] new_bank_0 = new_list[0];
  wire [3:0] new_bank_1 = new_list[1];
*/

  reg [NUMRDPT*NUMVBNK-1:0] t1_writeA;
  reg [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrA;
  reg [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_dinA;
  reg [NUMRDPT*NUMVBNK-1:0] t1_readB;
  reg [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB;
  integer t1w_int, t1wa_int, t1wb_int, t1r_int, t1ra_int, t1rb_int;
  always_comb begin 
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    for (t1wb_int=0; t1wb_int<NUMVBNK; t1wb_int=t1wb_int+1)
      for (t1r_int=0; t1r_int<NUMRDPT; t1r_int=t1r_int+1) begin
        if (new_enq[t1wb_int])
          t1_writeA[t1r_int*NUMVBNK+t1wb_int] = 1'b1;
        for (t1wa_int=0; t1wa_int<BITVROW; t1wa_int=t1wa_int+1)
          t1_addrA[(t1r_int*NUMVBNK+t1wb_int)*BITVROW+t1wa_int] = new_radr[t1wb_int][t1wa_int];
      end
    for (t1w_int=0; t1w_int<NUMWRPT; t1w_int=t1w_int+1)
      for (t1r_int=0; t1r_int<NUMRDPT; t1r_int=t1r_int+1) begin
        for (t1wb_int=0; t1wb_int<NUMVBNK; t1wb_int=t1wb_int+1)
          if (pwrite_wire[t1w_int] && (pwrbadr_wire[t1w_int]==t1wb_int)) begin
            for (t1wa_int=0; t1wa_int<WIDTH; t1wa_int=t1wa_int+1)
              t1_dinA[(t1r_int*NUMVBNK+t1wb_int)*WIDTH+t1wa_int] = pdin_wire[t1w_int][t1wa_int];
          end
      end
    t1_readB = 0;
    t1_addrB = 0;
    for (t1r_int=0; t1r_int<NUMRDPT; t1r_int=t1r_int+1) begin
      if (vread_wire[t1r_int])
        t1_readB = t1_readB | (1'b1 << (t1r_int*NUMVBNK+vrdbadr_wire[t1r_int]));
      for (t1rb_int=0; t1rb_int<NUMVBNK; t1rb_int=t1rb_int+1)
        if (vread_wire[t1r_int] && (vrdbadr_wire[t1r_int]==t1rb_int))
          for (t1ra_int=0; t1ra_int<BITVROW; t1ra_int=t1ra_int+1)
            t1_addrB[(t1r_int*NUMVBNK+t1rb_int)*BITVROW+t1ra_int] = vrdradr_wire[t1r_int][t1ra_int];
    end
  end

  reg [NUMDQPT*NUMVBNK-1:0] t2_writeA;
  reg [NUMDQPT*NUMVBNK*BITVROW-1:0] t2_addrA;
  reg [NUMDQPT*NUMVBNK*BITVROW-1:0] t2_dinA;
  reg [NUMDQPT*NUMVBNK-1:0] t2_readB;
  reg [NUMDQPT*NUMVBNK*BITVROW-1:0] t2_addrB;
  integer t2d_int, t2a_int, t2b_int;
  always_comb begin
    t2_writeA = 0;
    t2_addrA = 0;
    t2_dinA = 0;
    for (t2b_int=0; t2b_int<NUMVBNK; t2b_int=t2b_int+1)
      for (t2d_int=0; t2d_int<NUMDQPT; t2d_int=t2d_int+1) begin
        if (swrite_wire[t2b_int][t2d_int])
          t2_writeA[t2d_int*NUMVBNK+t2b_int] = 1'b1;
        for (t2a_int=0; t2a_int<BITVROW; t2a_int=t2a_int+1) begin
          t2_addrA[(t2d_int*NUMVBNK+t2b_int)*BITVROW+t2a_int] = swrradr_wire[t2b_int][t2d_int][t2a_int];
          t2_dinA[(t2d_int*NUMVBNK+t2b_int)*BITVROW+t2a_int] = sdin_wire[t2b_int][t2d_int][t2a_int];
        end
      end
    t2_readB = 0;
    t2_addrB = 0;
    for (t2b_int=0; t2b_int<NUMVBNK; t2b_int=t2b_int+1)
      for (t2d_int=0; t2d_int<NUMDQPT; t2d_int=t2d_int+1) begin
        if (sread_wire[t2b_int][t2d_int])
          t2_readB[t2d_int*NUMVBNK+t2b_int] = 1'b1;
        for (t2a_int=0; t2a_int<BITVROW; t2a_int=t2a_int+1)
          t2_addrB[(t2d_int*NUMVBNK+t2b_int)*BITVROW+t2a_int] = srdradr_wire[t2b_int][t2d_int][t2a_int];
      end
  end

endmodule
