/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
module test_driver_4r5ws_a32 (read, rd_deq, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                    rw_read, rw_write, rw_addr, rw_din, rw_vld, rw_dout, rw_serr, rw_derr, rw_padr,
                    write, wr_adr, din,
                    cnt, ct_adr, ct_imm, ct_vld, ct_serr, ct_derr,
                    ac_read, ac_write, ac_addr, ac_din, ac_vld, ac_dout, ac_serr, ac_derr, ac_padr,
                    ru_read, ru_write, ru_addr, ru_din, ru_vld, ru_dout, ru_serr, ru_derr, ru_padr,
                    ma_write, ma_adr, ma_din, ma_bp,
                    dq_vld, dq_adr, 
                    push, pu_adr, pu_din, pu_ptr, pu_vld, pu_cnt,
                    pop, po_adr, po_vld, po_dout, po_serr, po_derr, po_padr,
                    po_ptr, po_nxt, po_cnt, po_snxt, po_sdout,
                    dbg_en, dbg_read, dbg_write, dbg_bank, dbg_addr, dbg_din, dbg_vld, dbg_dout, dbg_refr, dbg_rbnk,
                    clk, lclk, ready, rst, refr);

parameter DEPTH = 32;
parameter BITADDR = 5;
parameter WIDTH   = 8;
parameter BITPADR = 16;

parameter NUMCELL = 80;
parameter BITCELL = 7;
parameter NUMQUEU = DEPTH/80;
parameter BITQUEU = BITADDR-BITCELL;

parameter ENARDSG = 0;
parameter ENAWRSG = 0;
parameter ENAPSDO = 0;
parameter ENARDSQ = 0;
parameter ENAWRSQ = 0;
parameter ENAWRST = 0;
parameter WRRDHAZ = 20;
parameter RDWRHAZ = 20;
parameter WIN_DELAY = 26;
parameter NUMVBNK = 4;
parameter BITVBNK = 2;
parameter NUMVROW = 8;
parameter BITVROW = 3;

parameter NUMRDPT = 0;
parameter NUMRWPT = 0;
parameter NUMWRPT = 0;
parameter NUMCTPT = 0;
parameter NUMACPT = 0;
parameter NUMRUPT = 0;
parameter NUMMAPT = 0;
parameter NUMDQPT = 0;
parameter NUMPUPT = 0;
parameter NUMPOPT = 0;

parameter MEM_DELAY = 1;

parameter TB_HALF_CLK_PER = 1000;
parameter TB_HALF_LCLK_PER = 1500;

parameter REFRESH_M_IN_N_N_HF = 0;
parameter REFRESH_M_IN_N_N = 15;
parameter REFRESH_M_IN_N_M = 1;

parameter TB_VPD_DUMP_FILE = "dump.vpd";

parameter REFRESH = (REFRESH_M_IN_N_N > 0) ? 1 : 0;

parameter NUMMASK = 0;
parameter PTMASK1 = 0;
parameter PTMASK2 = 0;
parameter PTMASK3 = 0;
parameter PTMASK4 = 0;
parameter PTMASK5 = 0;
parameter PTMASK6 = 0;
parameter PTMASK7 = 0;
parameter PTMASK8 = 0;

parameter NUMDBNK = 0;
parameter BITDBNK = 0;
parameter NUMDROW = 0;
parameter BITDROW = 0;
parameter DBGWDTH = 0;
parameter BITDRBNK = 0;

parameter C1_BANK = 0;	parameter C1_ROWS = 0;	parameter C1_WDTH = 0;  parameter C1_DELY = 1;  parameter C1_RBNK = 0;  parameter C1_RROW = 0;
parameter C2_BANK = 0;	parameter C2_ROWS = 0;	parameter C2_WDTH = 0;  parameter C2_DELY = 1;  parameter C2_RBNK = 0;  parameter C2_RROW = 0;
parameter C3_BANK = 0;	parameter C3_ROWS = 0;	parameter C3_WDTH = 0;  parameter C3_DELY = 1;  parameter C3_RBNK = 0;  parameter C3_RROW = 0;
parameter C4_BANK = 0;	parameter C4_ROWS = 0;	parameter C4_WDTH = 0;  parameter C4_DELY = 1;  parameter C4_RBNK = 0;  parameter C4_RROW = 0;
parameter C5_BANK = 0;	parameter C5_ROWS = 0;	parameter C5_WDTH = 0;  parameter C5_DELY = 1;  parameter C5_RBNK = 0;  parameter C5_RROW = 0;
parameter C6_BANK = 0;	parameter C6_ROWS = 0;	parameter C6_WDTH = 0;  parameter C6_DELY = 1;  parameter C6_RBNK = 0;  parameter C6_RROW = 0;
parameter C7_BANK = 0;	parameter C7_ROWS = 0;	parameter C7_WDTH = 0;  parameter C7_DELY = 1;  parameter C7_RBNK = 0;  parameter C7_RROW = 0;
parameter C8_BANK = 0;	parameter C8_ROWS = 0;	parameter C8_WDTH = 0;  parameter C8_DELY = 1;  parameter C8_RBNK = 0;  parameter C8_RROW = 0;

output                       refr;

output [NUMRDPT-1:0]         read;
output [NUMRDPT-1:0]         rd_deq;
output [NUMRDPT*BITADDR-1:0] rd_adr;
input [NUMRDPT-1:0]          rd_vld;
input [NUMRDPT*WIDTH-1:0]    rd_dout; 
input [NUMRDPT-1:0]          rd_serr;
input [NUMRDPT-1:0]          rd_derr;
input [NUMRDPT*BITPADR-1:0]  rd_padr;

output [NUMRWPT-1:0]         rw_read;
output [NUMRWPT-1:0]         rw_write;
output [NUMRWPT*BITADDR-1:0] rw_addr;
output [NUMRWPT*WIDTH-1:0]   rw_din; 
input [NUMRWPT-1:0]          rw_vld;
input [NUMRWPT*WIDTH-1:0]    rw_dout; 
input [NUMRWPT-1:0]          rw_serr;
input [NUMRWPT-1:0]          rw_derr;
input [NUMRWPT*BITPADR-1:0]  rw_padr;

output [NUMWRPT-1:0]         write;
output [NUMWRPT*BITADDR-1:0] wr_adr;
output [NUMWRPT*WIDTH-1:0]   din; 

output [NUMCTPT-1:0]         cnt;
output [NUMCTPT*BITADDR-1:0] ct_adr;
output [NUMCTPT*WIDTH-1:0]   ct_imm; 
input [NUMCTPT-1:0]          ct_vld;
input [NUMCTPT-1:0]          ct_serr;
input [NUMCTPT-1:0]          ct_derr;

output [NUMACPT-1:0]         ac_read;
output [NUMACPT-1:0]         ac_write;
output [NUMACPT*BITADDR-1:0] ac_addr;
output [NUMACPT*WIDTH-1:0]   ac_din; 
input [NUMACPT-1:0]          ac_vld;
input [NUMACPT*WIDTH-1:0]    ac_dout; 
input [NUMACPT-1:0]          ac_serr;
input [NUMACPT-1:0]          ac_derr;
input [NUMACPT*BITPADR-1:0]  ac_padr;

output [NUMRUPT-1:0]         ru_read;
output [NUMRUPT-1:0]         ru_write;
output [NUMRUPT*BITADDR-1:0] ru_addr;
output [NUMRUPT*WIDTH-1:0]   ru_din; 
input [NUMRUPT-1:0]          ru_vld;
input [NUMRUPT*WIDTH-1:0]    ru_dout; 
input [NUMRUPT-1:0]          ru_serr;
input [NUMRUPT-1:0]          ru_derr;
input [NUMRUPT*BITPADR-1:0]  ru_padr;

output [NUMMAPT-1:0]         ma_write;
input [NUMMAPT*BITADDR-1:0]  ma_adr;
output [NUMMAPT*WIDTH-1:0]   ma_din; 
input [NUMMAPT-1:0]          ma_bp;

output [NUMDQPT-1:0]         dq_vld;
output [NUMDQPT*BITADDR-1:0] dq_adr;

output [NUMPUPT-1:0]         push;
output [NUMPUPT*BITQUEU-1:0] pu_adr;
output [NUMPUPT*BITADDR-1:0] pu_ptr; 
output [NUMPUPT*WIDTH-1:0]   pu_din; 
input [NUMPUPT-1:0]          pu_vld;
input [NUMPUPT*(BITADDR+1)-1:0]    pu_cnt; 

output [NUMPOPT-1:0]         pop;
output [NUMPOPT*BITQUEU-1:0] po_adr;
input [NUMPOPT-1:0]          po_vld;
input [NUMPOPT*BITADDR-1:0]  po_ptr; 
input [NUMPOPT*BITADDR-1:0]  po_nxt; 
input [NUMPOPT*WIDTH-1:0]    po_dout; 
input [NUMPOPT-1:0]          po_serr;
input [NUMPOPT-1:0]          po_derr;
input [NUMPOPT*BITPADR-1:0]  po_padr;
input [NUMPOPT*(BITADDR+1)-1:0]    po_cnt; 
input [NUMPOPT*BITADDR-1:0]  po_snxt; 
input [NUMPOPT*WIDTH-1:0]    po_sdout; 

output                       dbg_en;
output                       dbg_read;
output                       dbg_write;
output [BITDBNK-1:0]         dbg_bank;
output [BITDROW-1:0]         dbg_addr;
output [DBGWDTH-1:0]         dbg_din; 
input                        dbg_vld;
input [DBGWDTH-1:0]          dbg_dout; 
output                       dbg_refr;
output [BITDRBNK-1:0]        dbg_rbnk;

output                       clk;
output                       lclk;
output                       rst;
input                        ready;

reg               read_wire [0:NUMRDPT-1];
reg               rd_deq_wire [0:NUMRDPT-1];
reg [BITADDR-1:0] rd_adr_wire [0:NUMRDPT-1];
reg               rd_vld_wire [0:NUMRDPT-1];
reg [WIDTH-1:0]   rd_dout_wire [0:NUMRDPT-1]; 
reg               rd_serr_wire [0:NUMRDPT-1];
reg               rd_derr_wire [0:NUMRDPT-1];
reg [BITPADR-1:0] rd_padr_wire [0:NUMRDPT-1];

reg               rw_read_wire [0:NUMRWPT-1];
reg               rw_write_wire [0:NUMRWPT-1];
reg [BITADDR-1:0] rw_adr_wire [0:NUMRWPT-1];
reg [WIDTH-1:0]   rw_din_wire [0:NUMRWPT-1];
reg               rw_vld_wire [0:NUMRWPT-1];
reg [WIDTH-1:0]   rw_dout_wire [0:NUMRWPT-1]; 
reg               rw_serr_wire [0:NUMRWPT-1];
reg               rw_derr_wire [0:NUMRWPT-1];
reg [BITPADR-1:0] rw_padr_wire [0:NUMRWPT-1];

reg               write_wire [0:NUMWRPT-1];
reg [BITADDR-1:0] wr_adr_wire [0:NUMWRPT-1];
reg [WIDTH-1:0]   din_wire [0:NUMWRPT-1];

reg               cnt_wire [0:NUMCTPT-1];
reg [BITADDR-1:0] ct_adr_wire [0:NUMCTPT-1];
reg [WIDTH-1:0]   imm_wire [0:NUMCTPT-1];

reg               ac_read_wire [0:NUMACPT-1];
reg               ac_write_wire [0:NUMACPT-1];
reg [BITADDR-1:0] ac_adr_wire [0:NUMACPT-1];
reg [WIDTH-1:0]   ac_din_wire [0:NUMACPT-1];
reg               ac_vld_wire [0:NUMACPT-1];
reg [WIDTH-1:0]   ac_dout_wire [0:NUMACPT-1]; 
reg               ac_serr_wire [0:NUMACPT-1];
reg               ac_derr_wire [0:NUMACPT-1];
reg [BITPADR-1:0] ac_padr_wire [0:NUMACPT-1];

reg               ru_read_wire [0:NUMRUPT-1];
reg               ru_write_wire [0:NUMRUPT-1];
reg [BITADDR-1:0] ru_adr_wire [0:NUMRUPT-1];
reg [WIDTH-1:0]   ru_din_wire [0:NUMRUPT-1];
reg               ru_vld_wire [0:NUMRUPT-1];
reg [WIDTH-1:0]   ru_dout_wire [0:NUMRUPT-1]; 
reg               ru_serr_wire [0:NUMRUPT-1];
reg               ru_derr_wire [0:NUMRUPT-1];
reg [BITPADR-1:0] ru_padr_wire [0:NUMRUPT-1];

reg               ma_write_wire [0:NUMMAPT-1];
reg [BITADDR-1:0] ma_adr_wire [0:NUMMAPT-1];
reg [WIDTH-1:0]   ma_din_wire [0:NUMMAPT-1];
reg               ma_bp_wire [0:NUMMAPT-1];

reg                       dbg_en;
reg                       dbg_read;
reg                       dbg_write;
reg [BITDBNK-1:0]         dbg_bank;
reg [BITDROW-1:0]         dbg_addr;
reg [DBGWDTH-1:0]         dbg_din; 
reg                       dbg_refr;
reg [BITDRBNK-1:0]        dbg_rbnk;

reg [NUMWRPT-1:0] wrsgmsk [0:NUMVBNK-1];

reg rst;

string name = "testbench.drvr";

integer init_int;
reg clk;
initial begin
  clk = 0;
  for (init_int=0; init_int<NUMVBNK; init_int=init_int+1)
    wrsgmsk[init_int] = 1<<($urandom%NUMWRPT);
  for (init_int=0; init_int<NUMRDPT; init_int=init_int+1)
    read_wire[init_int] = 0;
  for (init_int=0; init_int<NUMRWPT; init_int=init_int+1) begin
    rw_read_wire[init_int] = 0;
    rw_write_wire[init_int] = 0;
  end
  for (init_int=0; init_int<NUMWRPT; init_int=init_int+1)
    write_wire[init_int] = 0;
  for (init_int=0; init_int<NUMCTPT; init_int=init_int+1)
    cnt_wire[init_int] = 0;
  for (init_int=0; init_int<NUMACPT; init_int=init_int+1) begin
    ac_read_wire[init_int] = 0;
    ac_write_wire[init_int] = 0;
  end
  for (init_int=0; init_int<NUMRUPT; init_int=init_int+1) begin
    ru_read_wire[init_int] = 0;
    ru_write_wire[init_int] = 0;
  end
  for (init_int=0; init_int<NUMMAPT; init_int=init_int+1)
    ma_write_wire[init_int] = 0;
  dbg_en = 0;
  dbg_read = 0;
  dbg_write = 0;
  dbg_refr = 0;
  forever #TB_HALF_CLK_PER clk = !clk;
end

reg lclk;
initial begin
  lclk = 0;
  forever #TB_HALF_LCLK_PER lclk = !lclk;
end

reg [WIDTH-1:0] memchk [0:DEPTH-1];
reg [WIDTH:0] cnt_temp [0:NUMCTPT-1];
integer ct_int, ctp_int;
always_comb
  for (ct_int=0; ct_int<NUMCTPT; ct_int=ct_int+1) begin
    cnt_temp[ct_int] = memchk[ct_adr_wire[ct_int]] + imm_wire[ct_int];
    cnt_temp[ct_int] = {|cnt_temp[ct_int][WIDTH:WIDTH-1],cnt_temp[ct_int][WIDTH-2:0]};
    for (ctp_int=0; ctp_int<NUMCTPT; ctp_int=ctp_int+1)
      if ((ct_int != ctp_int) && (cnt_wire[ctp_int] && (ct_adr_wire[ctp_int] == ct_adr_wire[ct_int]))) begin
        cnt_temp[ct_int] = cnt_temp[ct_int] + imm_wire[ctp_int];
        cnt_temp[ct_int] = {|cnt_temp[ct_int][WIDTH:WIDTH-1],cnt_temp[ct_int][WIDTH-2:0]};
      end
  end

reg                ru_write_reg [0:NUMRUPT-1][0:MEM_DELAY-1];
reg [BITADDR-1:0]  ru_adr_reg [0:NUMRUPT-1][0:MEM_DELAY-1];
reg [WIDTH-1:0]    ru_din_reg [0:NUMRUPT-1][0:MEM_DELAY-1];

reg memflg [0:DEPTH-1];
integer wr_int;
always @(posedge clk) begin
  if (NUMRUPT && rst)
    for (int a=0; a<DEPTH; a=a+1)
      memchk[a] <= 0;
  if (NUMMAPT && rst)
    for (int a=0; a<DEPTH; a=a+1)
      memflg[a] <= 1'b0;
  for (wr_int=0; wr_int<NUMRDPT; wr_int=wr_int+1)
    if (read_wire[wr_int] && rd_deq_wire[wr_int])
      memflg[rd_adr_wire[wr_int]] <= 1'b0;
  for (wr_int=0; wr_int<NUMRWPT; wr_int=wr_int+1)
    if (rw_write_wire[wr_int]) 
      memchk[rw_adr_wire[wr_int]] <= rw_din_wire[wr_int];
  for (wr_int=0; wr_int<NUMWRPT; wr_int=wr_int+1)
    if (write_wire[wr_int]) 
      if (ENAWRSQ)
        memchk[NUMCELL*wr_adr_wire[wr_int][BITADDR-1:BITCELL]+wr_adr_wire[wr_int][BITCELL-1:0]] <= din_wire[wr_int];
      else
        memchk[wr_adr_wire[wr_int]] <= din_wire[wr_int];
  for (wr_int=0; wr_int<NUMCTPT; wr_int=wr_int+1)
    if (cnt_wire[wr_int]) 
      memchk[ct_adr_wire[wr_int]] <= cnt_temp[wr_int];
  for (wr_int=0; wr_int<NUMACPT; wr_int=wr_int+1)
    if (ac_write_wire[wr_int]) 
      memchk[ac_adr_wire[wr_int]] <= ac_din_wire[wr_int];
  for (wr_int=0; wr_int<NUMRUPT; wr_int=wr_int+1)
    if (ru_write_reg[wr_int][MEM_DELAY-1]) 
      memchk[ru_adr_reg[wr_int][MEM_DELAY-1]] <= ru_din_reg[wr_int][MEM_DELAY-1];
  for (wr_int=0; wr_int<NUMMAPT; wr_int=wr_int+1)
    if (ma_write_wire[wr_int]) begin
      memflg[ma_adr_wire[wr_int]] <= 1'b1;
      memchk[ma_adr_wire[wr_int]] <= ma_din_wire[wr_int];
    end
end

reg [DBGWDTH-1:0] dbgchk [0:NUMDBNK-1][0:NUMDROW-1];
always @(posedge clk)
  if (dbg_write)
    dbgchk[dbg_bank][dbg_addr] <= dbg_din;

reg               read_reg   [0:NUMRDPT-1][0:MEM_DELAY-1];
reg [BITADDR-1:0] rd_adr_reg [0:NUMRDPT-1][0:MEM_DELAY-1];
reg [WIDTH-1:0]   rd_dout_reg [0:NUMRDPT-1][0:MEM_DELAY-1];
reg               rw_read_reg [0:NUMRWPT-1][0:MEM_DELAY-1];
reg [WIDTH-1:0]   rw_dout_reg [0:NUMRWPT-1][0:MEM_DELAY-1];
reg               ac_read_reg [0:NUMACPT-1][0:MEM_DELAY-1];
reg [WIDTH-1:0]   ac_dout_reg [0:NUMACPT-1][0:MEM_DELAY-1];
reg               ru_read_reg [0:NUMRUPT-1][0:MEM_DELAY-1];
reg [WIDTH-1:0]   ru_dout_reg [0:NUMRUPT-1][0:MEM_DELAY-1];
reg               dbg_read_reg [0:NUMDBNK-1][0:MEM_DELAY-1];
reg [BITDBNK-1:0] dbg_bank_reg [0:NUMDBNK-1][0:MEM_DELAY-1];
reg [DBGWDTH-1:0] dbg_dout_reg [0:NUMDBNK-1][0:MEM_DELAY-1];
integer rdel_int, mdel_int;
always @(posedge clk)
  for (mdel_int=0; mdel_int<MEM_DELAY; mdel_int=mdel_int+1)
    if (mdel_int>0) begin
      for (rdel_int=0; rdel_int<NUMRDPT; rdel_int=rdel_int+1) begin
        read_reg[rdel_int][mdel_int] <= read_reg[rdel_int][mdel_int-1];
        rd_adr_reg[rdel_int][mdel_int] <= rd_adr_reg[rdel_int][mdel_int-1];
        rd_dout_reg[rdel_int][mdel_int] <= rd_dout_reg[rdel_int][mdel_int-1];
      end
      for (rdel_int=0; rdel_int<NUMRWPT; rdel_int=rdel_int+1) begin
        rw_read_reg[rdel_int][mdel_int] <= rw_read_reg[rdel_int][mdel_int-1];
        rw_dout_reg[rdel_int][mdel_int] <= rw_dout_reg[rdel_int][mdel_int-1];
      end
      for (rdel_int=0; rdel_int<NUMACPT; rdel_int=rdel_int+1) begin
        ac_read_reg[rdel_int][mdel_int] <= ac_read_reg[rdel_int][mdel_int-1];
        ac_dout_reg[rdel_int][mdel_int] <= ac_dout_reg[rdel_int][mdel_int-1];
      end
      for (rdel_int=0; rdel_int<NUMRUPT; rdel_int=rdel_int+1) begin
        ru_read_reg[rdel_int][mdel_int] <= ru_read_reg[rdel_int][mdel_int-1];
        ru_dout_reg[rdel_int][mdel_int] <= ru_dout_reg[rdel_int][mdel_int-1];
        ru_write_reg[rdel_int][mdel_int] <= ru_write_reg[rdel_int][mdel_int-1];
        ru_adr_reg[rdel_int][mdel_int] <= ru_adr_reg[rdel_int][mdel_int-1];
        ru_din_reg[rdel_int][mdel_int] <= ru_din_reg[rdel_int][mdel_int-1];
      end
      for (rdel_int=0; rdel_int<NUMDBNK; rdel_int=rdel_int+1) begin
        dbg_dout_reg[rdel_int][mdel_int] <= dbg_dout_reg[rdel_int][mdel_int-1];
        dbg_bank_reg[rdel_int][mdel_int] <= dbg_bank_reg[rdel_int][mdel_int-1];
        dbg_read_reg[rdel_int][mdel_int] <= dbg_read_reg[rdel_int][mdel_int-1];
      end
    end else begin
      for (rdel_int=0; rdel_int<NUMRDPT; rdel_int=rdel_int+1) begin
        read_reg[rdel_int][mdel_int] <= read_wire[rdel_int];
        rd_adr_reg[rdel_int][mdel_int] <= rd_adr_wire[rdel_int];
        if (ENARDSQ)
          rd_dout_reg[rdel_int][mdel_int] <= read_wire[rdel_int] ? memchk[NUMCELL*rd_adr_wire[rdel_int][BITADDR-1:BITCELL]+rd_adr_wire[rdel_int][BITCELL-1:0]] : {WIDTH{1'bx}};
        else
          rd_dout_reg[rdel_int][mdel_int] <= read_wire[rdel_int] ? memchk[rd_adr_wire[rdel_int]] : {WIDTH{1'bx}};
      end
      for (rdel_int=0; rdel_int<NUMRWPT; rdel_int=rdel_int+1) begin
        rw_read_reg[rdel_int][mdel_int] <= rw_read_wire[rdel_int];
        rw_dout_reg[rdel_int][mdel_int] <= rw_read_wire[rdel_int] ? memchk[rw_adr_wire[rdel_int]] : {WIDTH{1'bx}};
      end
      for (rdel_int=0; rdel_int<NUMACPT; rdel_int=rdel_int+1) begin
        ac_read_reg[rdel_int][mdel_int] <= ac_read_wire[rdel_int];
        ac_dout_reg[rdel_int][mdel_int] <= ac_read_wire[rdel_int] ? memchk[ac_adr_wire[rdel_int]] : {WIDTH{1'bx}};
      end
      for (rdel_int=0; rdel_int<NUMRUPT; rdel_int=rdel_int+1) begin
        ru_read_reg[rdel_int][mdel_int] <= ru_read_wire[rdel_int];
        ru_dout_reg[rdel_int][mdel_int] <= ru_read_wire[rdel_int] ? memchk[ru_adr_wire[rdel_int]] : {WIDTH{1'bx}};
        ru_write_reg[rdel_int][mdel_int] <= ru_read_wire[rdel_int] && ru_write_wire[rdel_int];
        ru_adr_reg[rdel_int][mdel_int] <= ru_adr_wire[rdel_int];
        ru_din_reg[rdel_int][mdel_int] <= ru_din_wire[rdel_int];
      end
      for (rdel_int=0; rdel_int<NUMDBNK; rdel_int=rdel_int+1) begin
        dbg_dout_reg[rdel_int][mdel_int] <= (dbg_read && (dbg_bank == rdel_int)) ? dbgchk[dbg_bank][dbg_addr] : {(DBGWDTH>0?DBGWDTH:1){1'bx}};
        dbg_read_reg[rdel_int][mdel_int] <= dbg_read && (dbg_bank == rdel_int);
      end
    end

reg               write_reg [0:NUMWRPT-1][0:WIN_DELAY-1];
reg [BITADDR-1:0] wr_adr_reg [0:NUMWRPT-1][0:WIN_DELAY-1];
integer wdel_int, wprt_int;
always @(posedge clk)
  for (wdel_int=0; wdel_int<WIN_DELAY; wdel_int=wdel_int+1)
    if (wdel_int>0) begin
      for (wprt_int=0; wprt_int<NUMWRPT; wprt_int=wprt_int+1) begin
        write_reg[wprt_int][wdel_int] <= write_reg[wprt_int][wdel_int-1];
        wr_adr_reg[wprt_int][wdel_int] <= wr_adr_reg[wprt_int][wdel_int-1];
      end
    end else begin
      for (wprt_int=0; wprt_int<NUMWRPT; wprt_int=wprt_int+1) begin
        write_reg[wprt_int][wdel_int] <= write_wire[wprt_int];
        wr_adr_reg[wprt_int][wdel_int] <= wr_adr_wire[wprt_int];
      end
    end

integer chk_int;
reg [NUMRDPT-1:0] match_rd;
reg [NUMRWPT-1:0] match_rw;
reg [NUMACPT-1:0] match_ac;
reg [NUMRUPT-1:0] match_ru;
reg [NUMDBNK-1:0] match_db;
always_comb begin
  for (chk_int=0; chk_int<NUMRDPT; chk_int=chk_int+1) begin
    match_rd[chk_int] = !read_reg[chk_int][MEM_DELAY-1] || ((rd_vld_wire[chk_int] === read_reg[chk_int][MEM_DELAY-1]) &&
							    (rd_dout_wire[chk_int] === rd_dout_reg[chk_int][MEM_DELAY-1]));
  end
  for (chk_int=0; chk_int<NUMRWPT; chk_int=chk_int+1)
    match_rw[chk_int] = !rw_read_reg[chk_int][MEM_DELAY-1] || ((rw_vld_wire[chk_int] === rw_read_reg[chk_int][MEM_DELAY-1]) &&
                                                               (rw_dout_wire[chk_int] === rw_dout_reg[chk_int][MEM_DELAY-1])); 
  for (chk_int=0; chk_int<NUMACPT; chk_int=chk_int+1)
    match_ac[chk_int] = !ac_read_reg[chk_int][MEM_DELAY-1] || ((ac_vld_wire[chk_int] === ac_read_reg[chk_int][MEM_DELAY-1]) &&
                                                               (ac_dout_wire[chk_int] === ac_dout_reg[chk_int][MEM_DELAY-1])); 
  for (chk_int=0; chk_int<NUMRUPT; chk_int=chk_int+1)
    match_ru[chk_int] = !ru_read_reg[chk_int][MEM_DELAY-1] || ((ru_vld_wire[chk_int] === ru_read_reg[chk_int][MEM_DELAY-1]) &&
                                                               (ru_dout_wire[chk_int] === memchk[ru_adr_reg[chk_int][MEM_DELAY-1]])); 
  for (chk_int=0; chk_int<NUMDBNK; chk_int=chk_int+1) begin
    if (chk_int<C1_BANK)
      match_db[chk_int] = !dbg_read_reg[chk_int][C1_DELY-1] || ((dbg_vld === dbg_read_reg[chk_int][C1_DELY-1]) &&
                                                                (dbg_dout === dbg_dout_reg[chk_int][C1_DELY-1]));
    else if (chk_int<C1_BANK+C2_BANK)
      match_db[chk_int] = !dbg_read_reg[chk_int][C2_DELY-1] || ((dbg_vld === dbg_read_reg[chk_int][C2_DELY-1]) &&
                                                                (dbg_dout === dbg_dout_reg[chk_int][C2_DELY-1]));
    else if (chk_int<C1_BANK+C2_BANK+C3_BANK)
      match_db[chk_int] = !dbg_read_reg[chk_int][C3_DELY-1] || ((dbg_vld === dbg_read_reg[chk_int][C3_DELY-1]) &&
                                                                (dbg_dout === dbg_dout_reg[chk_int][C3_DELY-1]));
    else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK)
      match_db[chk_int] = !dbg_read_reg[chk_int][C4_DELY-1] || ((dbg_vld === dbg_read_reg[chk_int][C4_DELY-1]) &&
                                                                (dbg_dout === dbg_dout_reg[chk_int][C4_DELY-1]));
    else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK+C5_BANK)
      match_db[chk_int] = !dbg_read_reg[chk_int][C5_DELY-1] || ((dbg_vld === dbg_read_reg[chk_int][C5_DELY-1]) &&
                                                                (dbg_dout === dbg_dout_reg[chk_int][C5_DELY-1]));
    else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK+C5_BANK+C6_BANK)
      match_db[chk_int] = !dbg_read_reg[chk_int][C6_DELY-1] || ((dbg_vld === dbg_read_reg[chk_int][C6_DELY-1]) &&
                                                                (dbg_dout === dbg_dout_reg[chk_int][C6_DELY-1]));
    else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK+C5_BANK+C6_BANK+C7_BANK)
      match_db[chk_int] = !dbg_read_reg[chk_int][C7_DELY-1] || ((dbg_vld === dbg_read_reg[chk_int][C7_DELY-1]) &&
                                                                (dbg_dout === dbg_dout_reg[chk_int][C7_DELY-1]));
    else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK+C5_BANK+C6_BANK+C7_BANK+C8_BANK)
      match_db[chk_int] = !dbg_read_reg[chk_int][C8_DELY-1] || ((dbg_vld === dbg_read_reg[chk_int][C8_DELY-1]) &&
                                                                (dbg_dout === dbg_dout_reg[chk_int][C8_DELY-1]));
  end
end

integer stp_int;
reg stop_sim = 0;
always @(posedge clk) begin
  for (stp_int=0; stp_int<NUMRDPT; stp_int=stp_int+1) begin
    if (!match_rd[stp_int]) begin
      `ERROR($psprintf("memory rd check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, rd_dout_reg[stp_int][MEM_DELAY-1], rd_dout_wire[stp_int]))
      stop_sim <= 1'b1;
    end
  end
  for (stp_int=0; stp_int<NUMRWPT; stp_int=stp_int+1)
    if (!match_rw[stp_int]) begin
      `ERROR($psprintf("memory rw check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, rw_dout_reg[stp_int][MEM_DELAY-1], rw_dout_wire[stp_int]))
      stop_sim <= 1'b1;
    end
  for (stp_int=0; stp_int<NUMACPT; stp_int=stp_int+1)
    if (!match_ac[stp_int]) begin
      `ERROR($psprintf("memory ac check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, ac_dout_reg[stp_int][MEM_DELAY-1], ac_dout_wire[stp_int]))
      stop_sim <= 1'b1;
    end
  for (stp_int=0; stp_int<NUMRUPT; stp_int=stp_int+1)
    if (!match_ru[stp_int]) begin
      `ERROR($psprintf("memory ru check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, memchk[ru_adr_reg[stp_int][MEM_DELAY-1]], ru_dout_wire[stp_int]))
      stop_sim <= 1'b1;
    end
  for (stp_int=0; stp_int<NUMDBNK; stp_int=stp_int+1)
    if (!match_db[stp_int]) begin
      stop_sim <= 1'b1;
      if (chk_int<C1_BANK) begin
        `ERROR($psprintf("memory db check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, dbg_dout_reg[stp_int][C1_DELY-1], dbg_dout))
      end else if (chk_int<C1_BANK+C2_BANK) begin
        `ERROR($psprintf("memory db check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, dbg_dout_reg[stp_int][C2_DELY-1], dbg_dout))
      end else if (chk_int<C1_BANK+C2_BANK+C3_BANK) begin
        `ERROR($psprintf("memory db check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, dbg_dout_reg[stp_int][C3_DELY-1], dbg_dout))
      end else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK) begin
        `ERROR($psprintf("memory db check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, dbg_dout_reg[stp_int][C4_DELY-1], dbg_dout))
      end else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK+C5_BANK) begin
        `ERROR($psprintf("memory db check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, dbg_dout_reg[stp_int][C5_DELY-1], dbg_dout))
      end else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK+C5_BANK+C6_BANK) begin
        `ERROR($psprintf("memory db check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, dbg_dout_reg[stp_int][C6_DELY-1], dbg_dout))
      end else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK+C5_BANK+C6_BANK+C7_BANK) begin 
        `ERROR($psprintf("memory db check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, dbg_dout_reg[stp_int][C7_DELY-1], dbg_dout))
      end else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK+C5_BANK+C6_BANK+C7_BANK+C8_BANK) begin 
        `ERROR($psprintf("memory db check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, dbg_dout_reg[stp_int][C8_DELY-1], dbg_dout))
      end
    end
  if (stop_sim) $finish;
end

reg matchflag;
always @(posedge clk)
  if (rst)
    matchflag <= 1'b0;
  else
    matchflag <= matchflag || ((NUMRDPT>0) && ~&match_rd) ||
                              ((NUMRWPT>0) && ~&match_rw) ||
                              ((NUMACPT>0) && ~&match_ac) ||
                              ((NUMRUPT>0) && ~&match_ru) ||
                              ((NUMDBNK>0) && ~&match_db);

reg [31:0] refr_cnt;
reg refr_half;
always @(posedge clk)
  if (rst) begin
    refr_cnt <= 0;
    refr_half <= 0;
  end else if (|refr_cnt)
    refr_cnt <= refr_cnt - 1;
  else if (~(|refr_cnt)) begin
    refr_cnt <= REFRESH_M_IN_N_N + (REFRESH_M_IN_N_N_HF && refr_half) - 1;
    refr_half <= !refr_half;
  end

assign refr = (REFRESH && ready && (refr_cnt < REFRESH_M_IN_N_M));

reg [NUMRDPT-1:0]         read;
reg [NUMRDPT-1:0]         rd_deq;
reg [NUMRDPT*BITADDR-1:0] rd_adr;

reg [NUMRWPT-1:0]         rw_read;
reg [NUMRWPT-1:0]         rw_write;
reg [NUMRWPT*BITADDR-1:0] rw_addr;
reg [NUMRWPT*WIDTH-1:0]   rw_din; 

reg [NUMWRPT-1:0]         write;
reg [NUMWRPT*BITADDR-1:0] wr_adr;
reg [NUMWRPT*WIDTH-1:0]   din; 

reg [NUMCTPT-1:0]         cnt;
reg [NUMCTPT*BITADDR-1:0] ct_adr;
reg [NUMCTPT*WIDTH-1:0]   ct_imm; 

reg [NUMACPT-1:0]         ac_read;
reg [NUMACPT-1:0]         ac_write;
reg [NUMACPT*BITADDR-1:0] ac_addr;
reg [NUMACPT*WIDTH-1:0]   ac_din; 

reg [NUMRUPT-1:0]         ru_read;
reg [NUMRUPT-1:0]         ru_write;
reg [NUMRUPT*BITADDR-1:0] ru_addr;
reg [NUMRUPT*WIDTH-1:0]   ru_din; 

reg [NUMMAPT-1:0]         ma_write;
reg [NUMMAPT*WIDTH-1:0]   ma_din; 

integer bus_int;
always_comb begin
  read = 0;
  rd_deq = 0;
  rd_adr = 0;
  for (bus_int=0; bus_int<NUMRDPT; bus_int=bus_int+1) begin
    read = read | (read_wire[bus_int] << bus_int);
    rd_deq = rd_deq | (rd_deq_wire[bus_int] << bus_int);
    rd_adr = rd_adr | (rd_adr_wire[bus_int] << (bus_int*BITADDR));
    rd_vld_wire[bus_int] = rd_vld >> bus_int;
    rd_dout_wire[bus_int] = rd_dout >> (bus_int*WIDTH);
    rd_serr_wire[bus_int] = rd_serr >> bus_int;
    rd_derr_wire[bus_int] = rd_derr >> bus_int;
    rd_padr_wire[bus_int] = rd_padr >> (bus_int*BITPADR);
  end
  rw_read = 0;
  rw_write = 0;
  rw_addr = 0;
  rw_din = 0;
  for (bus_int=0; bus_int<NUMRWPT; bus_int=bus_int+1) begin
    rw_read = rw_read | (rw_read_wire[bus_int] << bus_int);
    rw_write = rw_write | (rw_write_wire[bus_int] << bus_int);
    rw_addr = rw_addr | (rw_adr_wire[bus_int] << (bus_int*BITADDR));
    rw_din = rw_din | (rw_din_wire[bus_int] << (bus_int*WIDTH));
    rw_vld_wire[bus_int] = rw_vld >> bus_int;
    rw_dout_wire[bus_int] = rw_dout >> (bus_int*WIDTH);
    rw_serr_wire[bus_int] = rw_serr >> bus_int;
    rw_derr_wire[bus_int] = rw_derr >> bus_int;
    rw_padr_wire[bus_int] = rw_padr >> (bus_int*BITPADR);
  end
  write = 0;
  wr_adr = 0;
  din = 0;
  for (bus_int=0; bus_int<NUMWRPT; bus_int=bus_int+1) begin
    write = write | (write_wire[bus_int] << bus_int);
    wr_adr = wr_adr | (wr_adr_wire[bus_int] << (bus_int*BITADDR));
    din = din | (din_wire[bus_int] << (bus_int*WIDTH));
  end
  cnt = 0;
  ct_adr = 0;
  ct_imm = 0;
  for (bus_int=0; bus_int<NUMCTPT; bus_int=bus_int+1) begin
    cnt = cnt | (cnt_wire[bus_int] << bus_int);
    ct_adr = ct_adr | (ct_adr_wire[bus_int] << (bus_int*BITADDR));
    ct_imm = ct_imm | (imm_wire[bus_int] << (bus_int*WIDTH));
  end
  ac_read = 0;
  ac_write = 0;
  ac_addr = 0;
  ac_din = 0;
  for (bus_int=0; bus_int<NUMACPT; bus_int=bus_int+1) begin
    ac_read = ac_read | (ac_read_wire[bus_int] << bus_int);
    ac_write = ac_write | (ac_write_wire[bus_int] << bus_int);
    ac_addr = ac_addr | (ac_adr_wire[bus_int] << (bus_int*BITADDR));
    ac_din = ac_din | (ac_din_wire[bus_int] << (bus_int*WIDTH));
    ac_vld_wire[bus_int] = ac_vld >> bus_int;
    ac_dout_wire[bus_int] = ac_dout >> (bus_int*WIDTH);
    ac_serr_wire[bus_int] = ac_serr >> bus_int;
    ac_derr_wire[bus_int] = ac_derr >> bus_int;
    ac_padr_wire[bus_int] = ac_padr >> (bus_int*BITPADR);
  end
  ru_read = 0;
  ru_write = 0;
  ru_addr = 0;
  ru_din = 0;
  for (bus_int=0; bus_int<NUMRUPT; bus_int=bus_int+1) begin
    ru_read = ru_read | (ru_read_wire[bus_int] << bus_int);
    ru_write = ru_write | (ru_write_reg[bus_int][MEM_DELAY-1] << bus_int);
    ru_addr = ru_addr | (ru_adr_wire[bus_int] << (bus_int*BITADDR));
    ru_din = ru_din | (ru_din_reg[bus_int][MEM_DELAY-1] << (bus_int*WIDTH));
    ru_vld_wire[bus_int] = ru_vld >> bus_int;
    ru_dout_wire[bus_int] = ru_dout >> (bus_int*WIDTH);
    ru_serr_wire[bus_int] = ru_serr >> bus_int;
    ru_derr_wire[bus_int] = ru_derr >> bus_int;
    ru_padr_wire[bus_int] = ru_padr >> (bus_int*BITPADR);
  end
  ma_write = 0;
  ma_din = 0;
  for (bus_int=0; bus_int<NUMMAPT; bus_int=bus_int+1) begin
    ma_write = ma_write | (ma_write_wire[bus_int] << bus_int);
    ma_din = ma_din | (ma_din_wire[bus_int] << (bus_int*WIDTH));
    ma_bp_wire[bus_int] = ma_bp >> bus_int;
    ma_adr_wire[bus_int] = ma_adr >> (bus_int*BITADDR);
  end
end

task reset;
begin
  `TB_YAP("asserting reset")
  rst = 1;
  cyc (20);
  rst = 0;
  while (!ready)
    cyc (1);
end
endtask

function [NUMACPT*WIDTH-1:0] randomACvalue; input integer width; integer i; begin randomACvalue = 0; for (i = width/32; i >= 0; i--) randomACvalue = (randomACvalue << 32) + $urandom; end endfunction
function [NUMCTPT*WIDTH-1:0] randomCTvalue; input integer width; integer i; begin randomCTvalue = 0; for (i = width/32; i >= 0; i--) randomCTvalue = (randomCTvalue << 32) + $urandom; end endfunction
function [NUMWRPT*WIDTH-1:0] randomWRvalue; input integer width; integer i; begin randomWRvalue = 0; for (i = width/32; i >= 0; i--) randomWRvalue = (randomWRvalue << 32) + $urandom; end endfunction
function [NUMRWPT*WIDTH-1:0] randomRWvalue; input integer width; integer i; begin randomRWvalue = 0; for (i = width/32; i >= 0; i--) randomRWvalue = (randomRWvalue << 32) + $urandom; end endfunction
function [NUMRUPT*WIDTH-1:0] randomRUvalue; input integer width; integer i; begin randomRUvalue = 0; for (i = width/32; i >= 0; i--) randomRUvalue = (randomRUvalue << 32) + $urandom; end endfunction
function [NUMMAPT*WIDTH-1:0] randomMAvalue; input integer width; integer i; begin randomMAvalue = 0; for (i = width/32; i >= 0; i--) randomMAvalue = (randomMAvalue << 32) + $urandom; end endfunction


function [C1_WDTH-1:0] randomT1value; input integer width; integer i; begin  randomT1value = 0;  for (i = width/32; i >= 0; i--)      randomT1value = (randomT1value << 32) + $urandom; end endfunction
function [C2_WDTH-1:0] randomT2value; input integer width; integer i; begin  randomT2value = 0;  for (i = width/32; i >= 0; i--)      randomT2value = (randomT2value << 32) + $urandom; end endfunction
function [C3_WDTH-1:0] randomT3value; input integer width; integer i; begin  randomT3value = 0;  for (i = width/32; i >= 0; i--)      randomT3value = (randomT3value << 32) + $urandom; end endfunction
function [C4_WDTH-1:0] randomT4value; input integer width; integer i; begin  randomT4value = 0;  for (i = width/32; i >= 0; i--)      randomT4value = (randomT4value << 32) + $urandom; end endfunction
function [C5_WDTH-1:0] randomT5value; input integer width; integer i; begin  randomT5value = 0;  for (i = width/32; i >= 0; i--)      randomT5value = (randomT5value << 32) + $urandom; end endfunction
function [C6_WDTH-1:0] randomT6value; input integer width; integer i; begin  randomT6value = 0;  for (i = width/32; i >= 0; i--)      randomT6value = (randomT6value << 32) + $urandom; end endfunction
function [C7_WDTH-1:0] randomT7value; input integer width; integer i; begin  randomT7value = 0;  for (i = width/32; i >= 0; i--)      randomT7value = (randomT7value << 32) + $urandom; end endfunction
function [C8_WDTH-1:0] randomT8value; input integer width; integer i; begin  randomT8value = 0;  for (i = width/32; i >= 0; i--)      randomT8value = (randomT8value << 32) + $urandom; end endfunction

task test_write_all;
  integer m, i;
  reg [BITVBNK-1:0] tmpbnk;
  begin
    `TB_YAP("test_write_all running") 
    if (ENAWRSQ)
      for (m=0; m<NUMQUEU; m=m+1)
        for (i=0; i<NUMCELL; i=i+1)
          memacc (0, 0, 0,
                  0, 0, 0, 0,
                  1, {m[BITQUEU-1:0],i[BITCELL-1:0]}, randomWRvalue(NUMWRPT*WIDTH),
                  0, 0, 0,
                  0, 0, 0, 0,
                  0, 0, 0, 0,
                  0, 0);
    else for (m=0; m<DEPTH; m=m+1)
      if (NUMWRPT>0)
        if (ENAWRSG) begin
          tmpbnk = m >> BITVROW;
          for (i=0; i<NUMWRPT; i=i+1)
            if (wrsgmsk[tmpbnk][i])
              memacc (0, 0, 0,
                      0, 0, 0, 0,
                      1 << i, m << (i*BITADDR), randomWRvalue(NUMWRPT*WIDTH),
                      0, 0, 0,
                      0, 0, 0, 0,
                      0, 0, 0, 0,
                      0, 0);
        end else
          memacc (0, 0, 0,
                  0, 0, 0, 0,
                  1, m, randomWRvalue(NUMWRPT*WIDTH),
                  0, 0, 0,
                  0, 0, 0, 0,
                  0, 0, 0, 0,
                  0, 0);
      else if (NUMRWPT>0)
        memacc (0, 0, 0,
                0, 1, m, randomRWvalue(NUMRWPT*WIDTH),
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0);
      else if (NUMACPT>0)
        memacc (0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                0, 1, m, randomACvalue(NUMACPT*WIDTH),
                0, 0, 0, 0,
                0, 0);
      else if (NUMRUPT>0)
        memacc (0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0,
                1, 1, m, randomRUvalue(NUMRUPT*WIDTH),
                0, 0);
      else if (NUMMAPT>0)
        if (m<8)
          memacc (0, 0, 0,
                  0, 0, 0, 0,
                  0, 0, 0,
                  0, 0, 0,
                  0, 0, 0, 0,
                  0, 0, 0, 0,
                  1, randomMAvalue(NUMMAPT*WIDTH));
    cyc (10);
    `TB_YAP("test_write_all completed")
  end
endtask

task test_read_all;
  integer m, i;
  reg [BITVBNK-1:0] tmpbnk;
  begin
    `TB_YAP("test_read_all running") 
    if (ENARDSQ)
      for (m=0; m<NUMQUEU; m=m+1)
        for (i=0; i<NUMCELL; i=i+1)
          memacc (1, 0, {m[BITQUEU-1:0],i[BITCELL-1:0]},
                  0, 0, 0, 0,
                  0, 0, 0,
                  0, 0, 0,
                  0, 0, 0, 0,
                  0, 0, 0, 0,
                  0, 0);
    else for (m=0; m<DEPTH; m=m+1)
      if (NUMRDPT>0)
        if (ENARDSG) begin
          tmpbnk = m >> BITVROW;
          for (i=0; i<NUMRDPT; i=i+1)
            if (wrsgmsk[tmpbnk][i])
              memacc (1 << i, 0, m << (i*BITADDR),
                      0, 0, 0, 0,
                      0, 0, 0,
                      0, 0, 0,
                      0, 0, 0, 0,
                      0, 0, 0, 0,
                      0, 0);
        end else
          memacc (1, 0, m,
                  0, 0, 0, 0,
                  0, 0, 0,
                  0, 0, 0,
                  0, 0, 0, 0,
                  0, 0, 0, 0,
                  0, 0);
      else if (NUMRWPT>0)
        memacc (0, 0, 0,
                1, 0, m, 0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0);
      else if (NUMACPT>0)
        memacc (0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                1, 0, m, 0,
                0, 0, 0, 0,
                0, 0);
      else if (NUMRUPT>0)
        memacc (0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0,
                1, 0, m, 0,
                0, 0);
    cyc (10);
    `TB_YAP("test_read_all completed")
  end
endtask

task test_dbg_write_all;
  integer m,n,start,rstart;
  begin
    `TB_YAP("test_dbg_write_all running")
	start = 0;
        for (m=0; m<C1_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C1_ROWS; n=n+1) begin
            if (C1_RBNK==0)
              dbgacc (0, 1, n, randomT1value(C1_WDTH), 0, 0);
            else if ((C1_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, randomT1value(C1_WDTH), 1, rstart);
              dbgacc (0, 1, n, randomT1value(C1_WDTH), 0, 0);
            end else
              dbgacc (0, 1, n, randomT1value(C1_WDTH), 1, rstart);
            rstart = (rstart + 1) % C1_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C2_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C2_ROWS; n=n+1) begin
            if (C2_RBNK==0)
              dbgacc (0, 1, n, randomT2value(C2_WDTH), 0, 0);
            else if ((C2_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, randomT2value(C2_WDTH), 1, rstart);
              dbgacc (0, 1, n, randomT2value(C2_WDTH), 0, 0);
            end else
              dbgacc (0, 1, n, randomT2value(C2_WDTH), 1, rstart);
            rstart = (rstart + 1) % C2_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C3_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C3_ROWS; n=n+1) begin
            if (C3_RBNK==0)
              dbgacc (0, 1, n, randomT3value(C3_WDTH), 0, 0);
            else if ((C3_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, randomT3value(C3_WDTH), 1, rstart);
              dbgacc (0, 1, n, randomT3value(C3_WDTH), 0, 0);
            end else
              dbgacc (0, 1, n, randomT3value(C3_WDTH), 1, rstart);
            rstart = (rstart + 1) % C3_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C4_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C4_ROWS; n=n+1) begin
            if (C4_RBNK==0)
              dbgacc (0, 1, n, randomT4value(C4_WDTH), 0, 0);
            else if ((C4_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, randomT4value(C4_WDTH), 1, rstart);
              dbgacc (0, 1, n, randomT4value(C4_WDTH), 0, 0);
            end else
              dbgacc (0, 1, n, randomT4value(C4_WDTH), 1, rstart);
            rstart = (rstart + 1) % C4_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C5_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C5_ROWS; n=n+1) begin
            if (C5_RBNK==0)
              dbgacc (0, 1, n, randomT5value(C5_WDTH), 0, 0);
            else if ((C5_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, randomT5value(C5_WDTH), 1, rstart);
              dbgacc (0, 1, n, randomT5value(C5_WDTH), 0, 0);
            end else
              dbgacc (0, 1, n, randomT5value(C5_WDTH), 1, rstart);
            rstart = (rstart + 1) % C5_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C6_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C6_ROWS; n=n+1) begin
            if (C6_RBNK==0)
              dbgacc (0, 1, n, randomT6value(C6_WDTH), 0, 0);
            else if ((C6_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, randomT6value(C6_WDTH), 1, rstart);
              dbgacc (0, 1, n, randomT6value(C6_WDTH), 0, 0);
            end else
              dbgacc (0, 1, n, randomT6value(C6_WDTH), 1, rstart);
            rstart = (rstart + 1) % C6_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C7_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C7_ROWS; n=n+1) begin
            if (C7_RBNK==0)
              dbgacc (0, 1, n, randomT7value(C7_WDTH), 0, 0);
            else if ((C7_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, randomT7value(C7_WDTH), 1, rstart);
              dbgacc (0, 1, n, randomT7value(C7_WDTH), 0, 0);
            end else
              dbgacc (0, 1, n, randomT7value(C7_WDTH), 1, rstart);
            rstart = (rstart + 1) % C7_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C8_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C8_ROWS; n=n+1) begin
            if (C8_RBNK==0)
              dbgacc (0, 1, n, randomT8value(C8_WDTH), 0, 0);
            else if ((C8_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, randomT8value(C8_WDTH), 1, rstart);
              dbgacc (0, 1, n, randomT8value(C8_WDTH), 0, 0);
            end else
              dbgacc (0, 1, n, randomT8value(C8_WDTH), 1, rstart);
            rstart = (rstart + 1) % C8_RBNK;
          end
          start = start + 1;
        end
	cyc (10);
    `TB_YAP("test_dbg_write_all completed")
  end
endtask

task test_dbg_read_all;
  integer m,n,start,rstart;
  begin
    `TB_YAP("test_dbg_read_all running") 
	start = 0;
        for (m=0; m<C1_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C1_ROWS; n=n+1) begin
            if (C1_RBNK==0)
              dbgacc (1, 0, n, 0, 0, 0);
            else if ((C1_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, 0, 1, rstart);
              dbgacc (1, 0, n, 0, 0, 0);
            end else
              dbgacc (1, 0, n, 0, 1, rstart);
            rstart = (rstart + 1) % C1_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C2_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C2_ROWS; n=n+1) begin
            if (C2_RBNK==0)
              dbgacc (1, 0, n, 0, 0, 0);
            else if ((C2_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, 0, 1, rstart);
              dbgacc (1, 0, n, 0, 0, 0);
            end else
              dbgacc (1, 0, n, 0, 1, rstart);
            rstart = (rstart + 1) % C2_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C3_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C3_ROWS; n=n+1) begin
            if (C3_RBNK==0)
              dbgacc (1, 0, n, 0, 0, 0);
            else if ((C3_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, 0, 1, rstart);
              dbgacc (1, 0, n, 0, 0, 0);
            end else
              dbgacc (1, 0, n, 0, 1, rstart);
            rstart = (rstart + 1) % C3_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C4_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C4_ROWS; n=n+1) begin
            if (C4_RBNK==0)
              dbgacc (1, 0, n, 0, 0, 0);
            else if ((C4_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, 0, 1, rstart);
              dbgacc (1, 0, n, 0, 0, 0);
            end else
              dbgacc (1, 0, n, 0, 1, rstart);
            rstart = (rstart + 1) % C4_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C5_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C5_ROWS; n=n+1) begin
            if (C5_RBNK==0)
              dbgacc (1, 0, n, 0, 0, 0);
            else if ((C5_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, 0, 1, rstart);
              dbgacc (1, 0, n, 0, 0, 0);
            end else
              dbgacc (1, 0, n, 0, 1, rstart);
            rstart = (rstart + 1) % C5_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C6_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C6_ROWS; n=n+1) begin
            if (C6_RBNK==0)
              dbgacc (1, 0, n, 0, 0, 0);
            else if ((C6_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, 0, 1, rstart);
              dbgacc (1, 0, n, 0, 0, 0);
            end else
              dbgacc (1, 0, n, 0, 1, rstart);
            rstart = (rstart + 1) % C6_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C7_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C7_ROWS; n=n+1) begin
            if (C7_RBNK==0)
              dbgacc (1, 0, n, 0, 0, 0);
            else if ((C7_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, 0, 1, rstart);
              dbgacc (1, 0, n, 0, 0, 0);
            end else
              dbgacc (1, 0, n, 0, 1, rstart);
            rstart = (rstart + 1) % C7_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C8_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C8_ROWS; n=n+1) begin
            if (C8_RBNK==0)
              dbgacc (1, 0, n, 0, 0, 0);
            else if ((C8_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, 0, 1, rstart);
              dbgacc (1, 0, n, 0, 0, 0);
            end else
              dbgacc (1, 0, n, 0, 1, rstart);
            rstart = (rstart + 1) % C8_RBNK;
          end
          start = start + 1;
        end
	cyc (10);
    `TB_YAP("test_dbg_read_all completed")
  end
endtask

task cyc;
input [31:0] cycles;
integer i;
begin
  if (cycles > 0) begin
    for (i=0; i<cycles; i=i+1)
      @(posedge clk);
    #(TB_HALF_CLK_PER/2);
  end
end
endtask

task memacc;
input [NUMRDPT-1:0] rd;
input [NUMRDPT-1:0] rddq;
input [NUMRDPT*BITADDR-1:0] rdadr;
input [NUMRWPT-1:0] rwrd;
input [NUMRWPT-1:0] rwwr;
input [NUMRWPT*BITADDR-1:0] rwadr;
input [NUMRWPT*WIDTH-1:0] rwdin;
input [NUMWRPT-1:0] wr;
input [NUMWRPT*BITADDR-1:0] wradr;
input [NUMWRPT*WIDTH-1:0] din;
input [NUMCTPT-1:0] cnt;
input [NUMCTPT*BITADDR-1:0] ctadr;
input [NUMCTPT*WIDTH-1:0] imm;
input [NUMACPT-1:0] acrd;
input [NUMACPT-1:0] acwr;
input [NUMACPT*BITADDR-1:0] acadr;
input [NUMACPT*WIDTH-1:0] acdin;
input [NUMRUPT-1:0] rurd;
input [NUMRUPT-1:0] ruwr;
input [NUMRUPT*BITADDR-1:0] ruadr;
input [NUMRUPT*WIDTH-1:0] rudin;
input [NUMMAPT-1:0] mawr;
input [NUMMAPT*WIDTH-1:0] madin;
integer i;
  begin
    if (refr)
      cyc (1);
    for (i=0; i<NUMRDPT; i=i+1) begin
      read_wire[i] = rd >> i;
      rd_deq_wire[i] = rddq >> i*BITADDR;
      rd_adr_wire[i] = rdadr >> i*BITADDR;
    end
    for (i=0; i<NUMRWPT; i=i+1) begin
      rw_read_wire[i] = rwrd >> i;
      rw_write_wire[i] = rwwr >> i;
      rw_adr_wire[i] = rwadr >> i*BITADDR;
      rw_din_wire[i] = rwdin >> i*WIDTH;
    end
    for (i=0; i<NUMWRPT; i=i+1) begin
      write_wire[i] = wr >> i;
      wr_adr_wire[i] = wradr >> i*BITADDR;
      din_wire[i] = din >> i*WIDTH;
    end
    for (i=0; i<NUMCTPT; i=i+1) begin
      cnt_wire[i] = cnt >> i;
      ct_adr_wire[i] = ctadr >> i*BITADDR;
      imm_wire[i] = imm >> i*WIDTH;
    end
    for (i=0; i<NUMACPT; i=i+1) begin
      ac_read_wire[i] = acrd >> i;
      ac_write_wire[i] = acwr >> i;
      ac_adr_wire[i] = acadr >> i*BITADDR;
      ac_din_wire[i] = acdin >> i*WIDTH;
    end
    for (i=0; i<NUMRUPT; i=i+1) begin
      ru_read_wire[i] = rurd >> i;
      ru_write_wire[i] = ruwr >> i;
      ru_adr_wire[i] = ruadr >> i*BITADDR;
      ru_din_wire[i] = rudin >> i*WIDTH;
    end
    for (i=0; i<NUMMAPT; i=i+1) begin
      ma_write_wire[i] = mawr >> i;
      ma_din_wire[i] = madin >> i*WIDTH;
    end
    cyc (1);
    for (i=0; i<NUMRDPT; i=i+1) begin
      read_wire[i] = 0;
      rd_deq_wire[i] = 0;
      rd_adr_wire[i] = 'hx;
    end
    for (i=0; i<NUMRWPT; i=i+1) begin
      rw_read_wire[i] = 0;
      rw_write_wire[i] = 0;
      rw_adr_wire[i] = 'hx;
      rw_din_wire[i] = 'hx;
    end
    for (i=0; i<NUMWRPT; i=i+1) begin
      write_wire[i] = 0;
      wr_adr_wire[i] = 'hx;
      din_wire[i] = 'hx;
    end
    for (i=0; i<NUMCTPT; i=i+1) begin
      cnt_wire[i] = 0;
      ct_adr_wire[i] = 'hx;
      imm_wire[i] = 'hx;
    end
    for (i=0; i<NUMACPT; i=i+1) begin
      ac_read_wire[i] = 0;
      ac_write_wire[i] = 0;
      ac_adr_wire[i] = 'hx;
      ac_din_wire[i] = 'hx;
    end
    for (i=0; i<NUMRUPT; i=i+1) begin
      ru_read_wire[i] = 0;
      ru_write_wire[i] = 0;
      ru_adr_wire[i] = 'hx;
      ru_din_wire[i] = 'hx;
    end
    for (i=0; i<NUMMAPT; i=i+1) begin
      ma_write_wire[i] = 0;
      ma_din_wire[i] = 'hx;
    end
  end
endtask

task dbgacc;
input dbgrd;
input dbgwr;
input [BITDROW-1:0] dbgrow;
input [DBGWDTH-1:0] dbgdin;
input dbgrf;
input [BITDRBNK-1:0] dbgrfb;
integer i;
  begin
    dbg_read = dbgrd;
    dbg_write = dbgwr;
    dbg_addr = dbgrow;
    dbg_din = dbgdin;
    dbg_refr = dbgrf;
    dbg_rbnk = dbgrfb;
    cyc (1);
    dbg_read = 0;
    dbg_write = 0;
    dbg_addr = 'hx;
    dbg_din = 'hx;
    dbg_refr = 0;
    dbg_rbnk = 'hx;
  end
endtask

task test_random;
input [31:0] num;
integer n,i,j,k;
reg               tmpacc;
reg [BITADDR-1:0] tmpadr;
reg [BITADDR-1:0] tmpchk;
reg [BITVBNK-1:0] tmpbnk;
reg [BITQUEU-1:0] tmpque;
reg [BITCELL-1:0] tmpcel;
reg [31:0]        tmpcnt;
reg               tmprw;
reg               tmpacr;
reg               tmpacw;
reg               tmpru;
reg [31:0]        mask;
reg [31:0]        ptmask;
reg               wrsgtmp;
reg [NUMVBNK-1:0] usedbnk;
reg [NUMRDPT-1:0] read;
reg [NUMRDPT-1:0] rddq;
reg [NUMRDPT*BITADDR-1:0] rdadr;
reg [NUMRWPT-1:0] rwrd;
reg [NUMRWPT-1:0] rwwr;
reg [NUMRWPT*BITADDR-1:0] rwadr;
reg [NUMWRPT-1:0] write;
reg [NUMWRPT*BITADDR-1:0] wradr;
reg [NUMCTPT-1:0] cnt;
reg [NUMCTPT*BITADDR-1:0] ctadr;
reg [NUMACPT-1:0] acrd;
reg [NUMACPT-1:0] acwr;
reg [NUMACPT*BITADDR-1:0] acadr;
reg [NUMRUPT-1:0] rurd;
reg [NUMRUPT-1:0] ruwr;
reg [NUMRUPT*BITADDR-1:0] ruadr;
reg [NUMMAPT-1:0] mawr;
  begin
    `TB_YAP("test_random running") 
    for (n=0; n<num; n=n+1) begin
      usedbnk = 0;
      if ((n% 10000) == 0) 
        `TB_YAP($psprintf("test_random sent %0d of %0d", n, num))

      read = 0;
      rddq = 0;
      rdadr = 0;
      for (i=0; i<NUMRDPT; i=i+1) begin
        if (ENARDSG) begin
          tmpacc = ($urandom < 32'hC0000000);
          wrsgtmp = 0;
          for (j=0; j<NUMVBNK; j=j+1)
            wrsgtmp = wrsgtmp || wrsgmsk[j][i];
          tmpacc = tmpacc && wrsgtmp;
          tmpadr = $urandom%DEPTH;
          tmpbnk = tmpadr >> BITVROW;
          while (tmpacc && !wrsgmsk[tmpbnk][i]) begin
            tmpadr = $urandom%DEPTH;
            tmpbnk = tmpadr >> BITVROW;
          end
        end if (ENARDSQ) begin
          tmpque = $urandom%NUMQUEU;
          tmpcel = $urandom%NUMCELL;
          tmpadr = {tmpque,tmpcel};
          tmpacc = ($urandom < 32'hC0000000);
          tmpcnt = 0;
          if (|tmpcel[BITCELL-1:2]) begin
            for (j=0; j<5; j=j+1)
              if (read_reg[i][j] && (rd_adr_reg[i][j][1:0]==tmpcel[1:0]))
                tmpcnt = tmpcnt+1;
          end else begin
            for (j=0; j<3; j=j+1)
              if (read_reg[i][j] && (rd_adr_reg[i][j][1:0]==tmpcel[1:0]))
                tmpcnt = tmpcnt+1;
          end
          tmpacc = tmpacc && (tmpcnt<1);
          for (j=0; j<NUMWRPT; j=j+1)
            for (k=0; k<WRRDHAZ; k=k+1)
              tmpacc = tmpacc && !(write_reg[j][k] && (wr_adr_reg[j][k]==tmpadr));
        end else begin
          tmpadr = $urandom%DEPTH;
          tmpacc = ($urandom < 32'hC0000000);
          tmpbnk = tmpadr >> BITVROW;
          while (ENAPSDO && tmpacc && usedbnk[tmpbnk] && !(&usedbnk)) begin
            tmpadr = $urandom%DEPTH;
            tmpbnk = tmpadr >> BITVROW;
          end
          usedbnk = usedbnk | (tmpacc << tmpbnk);
        end
        read = read | (tmpacc << i); 
        rddq = rddq | (memflg[tmpadr] << i);
        rdadr = rdadr | (tmpadr << i*BITADDR);
      end

      rwrd = 0;
      rwwr = 0;
      rwadr = 0;
      for (i=0; i<NUMRWPT; i=i+1) begin
        tmpadr = $urandom%DEPTH;
        tmpacc = ($urandom < 32'hC0000000);
        tmprw = ($urandom < 32'h80000000);
        tmpbnk = tmpadr >> BITVROW;
        while (ENAPSDO && tmpacc && usedbnk[tmpbnk] && !(&usedbnk)) begin
          tmpadr = $urandom%DEPTH;
          tmpbnk = tmpadr >> BITVROW;
        end
        usedbnk = usedbnk | (tmpacc << tmpbnk);
        rwrd = rwrd | ((tmprw && tmpacc) << i); 
        rwwr = rwwr | ((!tmprw && tmpacc) << i); 
        rwadr = rwadr | (tmpadr << i*BITADDR);
      end

      write = 0;
      wradr = 0;
      for (i=0; i<NUMWRPT; i=i+1) begin
        if (ENAWRSG) begin
          tmpacc = ($urandom < 32'hC0000000);
          wrsgtmp = 0;
          for (j=0; j<NUMVBNK; j=j+1)
            wrsgtmp = wrsgtmp || wrsgmsk[j][i];
          tmpacc = tmpacc && wrsgtmp;
          tmpadr = $urandom%DEPTH;
          tmpbnk = tmpadr >> BITVROW;
          while (tmpacc && !wrsgmsk[tmpbnk][i]) begin
            tmpadr = $urandom%DEPTH;
            tmpbnk = tmpadr >> BITVROW;
          end
        end if (ENAWRSQ) begin
          tmpque = $urandom%NUMQUEU;
          tmpcel = $urandom%NUMCELL;
          tmpadr = {tmpque,tmpcel};
          tmpacc = ($urandom < 32'hC0000000);
          tmpcnt = 0;
          if (|tmpcel[BITCELL-1:2]) begin
            for (j=0; j<WIN_DELAY; j=j+1)
              if (write_reg[i][j] && (wr_adr_reg[i][j][1:0]==tmpcel[1:0]))
                tmpcnt = tmpcnt+1;
          end else
            for (j=0; j<12; j=j+1)
              if (write_reg[i][j] && (wr_adr_reg[i][j][1:0]==tmpcel[1:0]))
                tmpcnt = tmpcnt+1;
          tmpacc = tmpacc && (tmpcnt<4);
          for (j=0; j<NUMRDPT; j=j+1)
            for (k=0; k<RDWRHAZ; k=k+1)
              if (k>0)
                tmpacc = tmpacc && !(read_reg[j][k-1] && (rd_adr_reg[j][k-1]==tmpadr));
              else begin
                tmpchk = rdadr>>(j*BITADDR);
                tmpacc = tmpacc && !(read[j] && (tmpchk==tmpadr));
              end
          if (i==4)
            for (j=0; j<WIN_DELAY; j=j+1)
              tmpacc = tmpacc && !(write_reg[i][j]);
        end else begin
          tmpacc = ($urandom < 32'hC0000000);
          tmpadr = $urandom%DEPTH;
          tmpbnk = tmpadr >> BITVROW;
          while (ENAPSDO && tmpacc && usedbnk[tmpbnk] && !(&usedbnk)) begin
            tmpadr = $urandom%DEPTH;
            tmpbnk = tmpadr >> BITVROW;
          end
          usedbnk = usedbnk | (tmpacc << tmpbnk);
        end
        write = write | (tmpacc << i); 
        wradr = wradr | (tmpadr << i*BITADDR);
      end

      cnt = 0;
      ctadr = 0;
      for (i=0; i<NUMCTPT; i=i+1) begin
        tmpadr = $urandom%DEPTH;
        tmpacc = ($urandom < 32'hC0000000);
        cnt = cnt | (tmpacc << i); 
        ctadr = ctadr | (tmpadr << i*BITADDR);
      end

      acrd = 0;
      acwr = 0;
      acadr = 0;
      for (i=0; i<NUMACPT; i=i+1) begin
        tmpadr = $urandom%DEPTH;
        tmpacc = ($urandom < 32'hC0000000);
        tmpacr = ($urandom < 32'h80000000);
        tmpacw = ($urandom < 32'h80000000);
        acrd = acrd | ((tmpacr && tmpacc) << i); 
        acwr = acwr | ((tmpacw && tmpacc) << i); 
        acadr = acadr | (tmpadr << i*BITADDR);
      end

      rurd = 0;
      ruwr = 0;
      ruadr = 0;
      for (i=0; i<NUMRUPT; i=i+1) begin
        tmpadr = $urandom%DEPTH;
        tmpacc = ($urandom < 32'hC0000000);
        tmpru = ($urandom < 32'h80000000);
        rurd = rurd | (tmpacc << i); 
        ruwr = ruwr | ((tmpru && tmpacc) << i); 
        ruadr = ruadr | (tmpadr << i*BITADDR);
      end

      mawr = 0;
      for (i=0; i<NUMMAPT; i=i+1) begin
        tmpacc = ($urandom < 32'hC0000000) && !ma_bp_wire[i];
        mawr = mawr | (tmpacc << i); 
      end

      if (NUMMASK>0) begin
        mask = $urandom%NUMMASK;
        case (mask)
          0: ptmask = PTMASK1;
          1: ptmask = PTMASK2;
          2: ptmask = PTMASK3;
          3: ptmask = PTMASK4;
          4: ptmask = PTMASK5;
          5: ptmask = PTMASK6;
          6: ptmask = PTMASK7;
          7: ptmask = PTMASK8;
        endcase
      end else ptmask = ~0;
      /*
       NUMMASK = 3
       rd0 rd1 rw2 wr3
       PTMASK1  1   1   0   0      // RD Port 0 and RD Port 1 active
       PTMAKS2  0   0   1   0      // RW Port 2 active
       PTMASK3  1   0   1   1      // RD Port 0 RW Port 2 WR Port 3 active
       */
      read = read & (ptmask >> (NUMRWPT+NUMWRPT+NUMCTPT+NUMACPT+NUMRUPT+NUMMAPT));
      rwrd = rwrd & (ptmask >> (NUMWRPT+NUMCTPT+NUMACPT+NUMRUPT+NUMMAPT));
      rwwr = rwwr & (ptmask >> (NUMWRPT+NUMCTPT+NUMACPT+NUMRUPT+NUMMAPT));
      write = write & (ptmask >> (NUMCTPT+NUMACPT+NUMRUPT+NUMMAPT));
      cnt = cnt & (ptmask >> (NUMACPT+NUMRUPT+NUMMAPT));
      acrd = acrd & (ptmask >> (NUMRUPT+NUMMAPT));
      acwr = acwr & (ptmask >> (NUMRUPT+NUMMAPT));
      rurd = rurd & (ptmask >> (NUMMAPT));
      ruwr = ruwr & (ptmask >> (NUMMAPT));
      mawr = mawr & ptmask;

      memacc(read, rddq, rdadr,
             rwrd, rwwr, rwadr, randomRWvalue(NUMRWPT*WIDTH),
             write, wradr, randomWRvalue(NUMWRPT*WIDTH),
             cnt, ctadr, randomCTvalue(NUMCTPT*WIDTH),
             acrd, acwr, acadr, randomACvalue(NUMACPT*WIDTH),
             rurd, ruwr, ruadr, randomRUvalue(NUMRUPT*WIDTH),
             mawr, randomMAvalue(NUMMAPT*WIDTH));
    end
    `TB_YAP("test_random completed") 
  end
endtask

initial begin
  reset;
  `TB_YAP("Running tests")
  test_write_all();
  test_random(DEPTH + 20000);
  test_read_all();
  cyc (40);
`ifdef MEMOIR_DBG_TEST
  `TB_YAP("Running debug tests")
  dbg_en = 1;
  test_dbg_write_all();
  test_dbg_read_all();
`endif
  `TB_YAP("All tests completed")
  $assertoff;
  rst = 1;
  cyc (50);
  $finish;
end

final begin
  if ((__err_cnt != 0) || matchflag) begin
    `TB_YAP($psprintf("Simulation FAILED (w=%0d e=%0d) (%s)", __warn_cnt, __err_cnt, memoir_design_name))
  end else begin
    `TB_YAP($psprintf("Simulation PASSED (w=%0d) (%s)\n", __warn_cnt, memoir_design_name))
  end
end

endmodule // test_driver_4r5ws_a32

