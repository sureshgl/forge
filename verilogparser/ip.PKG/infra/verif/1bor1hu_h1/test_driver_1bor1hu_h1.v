/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
module test_driver_1bor1hu_h1 (read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
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
                    search, sr_key, sr_dout, sr_vld, sr_match, sr_mhe, sr_serr, sr_derr, sr_padr,
                    update, up_key, up_din, up_del, up_bp, 
                    dbg_en, dbg_read, dbg_write, dbg_bank, dbg_addr, dbg_din, dbg_vld, dbg_dout, dbg_refr, dbg_rbnk,
                    clk, lclk, ready, rst, refr);

parameter DEPTH = 32;
parameter BITADDR = 5;
parameter WIDTH   = 8;
parameter BITPADR = 16;

parameter HASH_KYWIDTH = 0;
parameter HASH_DTWIDTH = 0;

parameter NUMCELL = 8;
parameter BITCELL = 3;
parameter NUMQUEU = DEPTH/80;
parameter BITQUEU = BITADDR-BITCELL;
parameter NUMSCNT = 2;
parameter CNTWDTH = WIDTH >=4 ? WIDTH/NUMSCNT : 4/NUMSCNT;

parameter ENARDSG = 0;
parameter ENAWRSG = 0;
parameter ENAPSDO = 0;
parameter ENARPSD = 0;
parameter ENARDSQ = 0;
parameter ENAWRSQ = 0;
parameter ENAWRST = 0;
parameter WRRDHAZ = 4;
parameter RDWRHAZ = 3;
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
parameter NUMSEPT = 0;
parameter NUMHUPT = 0;

parameter MEM_DELAY = 1;
parameter UPD_DELAY = 1;

parameter TB_HALF_CLK_PER = 1000;
parameter TB_HALF_LCLK_PER = 1500;

parameter REFRESH_M_IN_N_N_HF = 0;
parameter REFRESH_M_IN_N_N = 15;
parameter REFRESH_M_IN_N_M = 1;

parameter TB_VPD_DUMP_FILE = "dump.vpd";

parameter REFRESH = (REFRESH_M_IN_N_N > 0) ? 1 : 0;
parameter KYWIDTH = HASH_KYWIDTH;
parameter DTWIDTH = HASH_DTWIDTH;
parameter NUMHKEY = 1 << KYWIDTH;

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

parameter MAX_MEM_DELAY = 10;

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

output [NUMSEPT-1:0]          search;
output [NUMSEPT*KYWIDTH-1:0]  sr_key;
input [NUMSEPT*DTWIDTH-1:0]   sr_dout;
input [NUMSEPT-1:0]           sr_vld;
input [NUMSEPT-1:0]           sr_match;
input [NUMSEPT-1:0]           sr_mhe;
input [NUMSEPT-1:0]           sr_serr;
input [NUMSEPT-1:0]           sr_derr;
input [NUMSEPT*BITPADR-1:0]   sr_padr;

output [NUMHUPT-1:0]          update;
output [NUMHUPT*KYWIDTH-1:0]  up_key;
output [NUMHUPT*DTWIDTH-1:0]  up_din;
output [NUMHUPT-1:0]          up_del;
input [NUMHUPT-1:0]           up_bp;

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

reg               search_wire [0:NUMSEPT-1]; 
reg [KYWIDTH-1:0] sr_key_wire [0:NUMSEPT-1];
reg [DTWIDTH-1:0] sr_dout_wire [0:NUMSEPT-1];
reg               sr_vld_wire [0:NUMSEPT-1];
reg               sr_match_wire [0:NUMSEPT-1];
reg               sr_mhe_wire [0:NUMSEPT-1];
reg               sr_serr_wire [0:NUMSEPT-1];
reg               sr_derr_wire [0:NUMSEPT-1];
reg [BITPADR-1:0] sr_padr_wire [0:NUMSEPT-1];

reg               update_wire [0:NUMHUPT-1];
reg [KYWIDTH-1:0] up_key_wire [0:NUMHUPT-1];
reg [DTWIDTH-1:0] up_din_wire [0:NUMHUPT-1];
reg               up_del_wire [0:NUMHUPT-1];
reg               up_bp_wire [0:NUMHUPT-1];

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

reg               dq_vld_wire [0:NUMDQPT-1];
reg [BITADDR-1:0] dq_adr_wire [0:NUMDQPT-1];

reg               push_wire [0:NUMPUPT-1];
reg [BITQUEU-1:0] pu_adr_wire [0:NUMPUPT-1];
reg [WIDTH-1:0]   pu_din_wire [0:NUMPUPT-1];

reg               pop_wire [0:NUMPOPT-1];
reg [BITQUEU-1:0] po_adr_wire [0:NUMPOPT-1];
reg               po_vld_wire [0:NUMPOPT-1];
reg [WIDTH-1:0]   po_dout_wire [0:NUMPOPT-1]; 
reg               po_serr_wire [0:NUMPOPT-1];
reg               po_derr_wire [0:NUMPOPT-1];
reg [BITPADR-1:0] po_padr_wire [0:NUMPOPT-1];

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
  for (init_int=0; init_int<NUMSEPT; init_int=init_int+1)
    search_wire[init_int] = 0;
  for (init_int=0; init_int<NUMHUPT; init_int=init_int+1)
    update_wire[init_int] = 0;
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
  for (init_int=0; init_int<NUMDQPT; init_int=init_int+1)
    dq_vld_wire[init_int] = 0;
  for (init_int=0; init_int<NUMPUPT; init_int=init_int+1)
    push_wire[init_int] = 0;
  for (init_int=0; init_int<NUMPOPT; init_int=init_int+1)
    pop_wire[init_int] = 0;
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

reg memflg [0:DEPTH-1];
reg [WIDTH-1:0] memchk [0:DEPTH-1];
reg [BITADDR:0] quecnt [0:NUMQUEU-1];

reg [CNTWDTH:0] cnt_temp [0:NUMCTPT-1][0:NUMSCNT-1];
reg [WIDTH-1:0] cnt_help [0:NUMCTPT-1];

parameter HASHDEPTH = 2*DEPTH;

reg mem_vld [0:HASHDEPTH-1]; 
reg [KYWIDTH-1:0] mem_key [0:HASHDEPTH-1];
reg [DTWIDTH-1:0] mem_data [0:HASHDEPTH-1];

reg [DTWIDTH-1:0] hash_data [*];

integer ct_int, ctp_int, ctc_int;
always_comb begin
  for (ctc_int=0; ctc_int<NUMSCNT; ctc_int=ctc_int+1)
    for (ct_int=0; ct_int<NUMCTPT; ct_int=ct_int+1) begin
      cnt_temp[ct_int][ctc_int] = ((memchk[ct_adr_wire[ct_int]] >> ctc_int*CNTWDTH) & {CNTWDTH{1'b1}}) +
                                  ((imm_wire[ct_int] >> ctc_int*CNTWDTH) & {CNTWDTH{1'b1}});
      cnt_temp[ct_int][ctc_int] = {|cnt_temp[ct_int][ctc_int][CNTWDTH:CNTWDTH-1],cnt_temp[ct_int][ctc_int][CNTWDTH-2:0]};
      for (ctp_int=0; ctp_int<NUMCTPT; ctp_int=ctp_int+1)
        if ((ct_int != ctp_int) && (cnt_wire[ctp_int] && (ct_adr_wire[ctp_int] == ct_adr_wire[ct_int]))) begin
          cnt_temp[ct_int][ctc_int] = cnt_temp[ct_int][ctc_int] + ((imm_wire[ctp_int] >> ctc_int*CNTWDTH) & {CNTWDTH{1'b1}});
          cnt_temp[ct_int][ctc_int] = {|cnt_temp[ct_int][ctc_int][CNTWDTH:CNTWDTH-1],cnt_temp[ct_int][ctc_int][CNTWDTH-2:0]};
        end
    end
  for (ct_int=0; ct_int<NUMCTPT; ct_int=ct_int+1) begin
    cnt_help[ct_int] = 0;
    for (ctc_int=0; ctc_int<NUMSCNT; ctc_int=ctc_int+1)
      cnt_help[ct_int] = cnt_help[ct_int] | (cnt_temp[ct_int][ctc_int] << (ctc_int*CNTWDTH));
  end
end

reg [BITADDR:0] quecnt_pu [0:NUMPUPT-1];
reg [BITADDR:0] quecnt_po [0:NUMPOPT-1];
integer qc_int, qcp_int;
always_comb begin
  for (qc_int=0; qc_int<NUMPUPT; qc_int=qc_int+1) begin
    quecnt_pu[qc_int] = quecnt[pu_adr_wire[qc_int]];
    for (qcp_int=0; qcp_int<NUMPUPT; qcp_int=qcp_int+1)
      if (push_wire[qcp_int] && (pu_adr_wire[qc_int]==pu_adr_wire[qcp_int]))
        quecnt_pu[qc_int] = quecnt_pu[qc_int]+1;
    for (qcp_int=0; qcp_int<NUMPOPT; qcp_int=qcp_int+1)
      if (pop_wire[qcp_int] && (pu_adr_wire[qc_int]==po_adr_wire[qcp_int]))
        quecnt_pu[qc_int] = quecnt_pu[qc_int]-1;
  end
  for (qc_int=0; qc_int<NUMPOPT; qc_int=qc_int+1) begin
    quecnt_po[qc_int] = quecnt[po_adr_wire[qc_int]];
    for (qcp_int=0; qcp_int<NUMPUPT; qcp_int=qcp_int+1)
      if (push_wire[qcp_int] && (po_adr_wire[qc_int]==pu_adr_wire[qcp_int]))
        quecnt_po[qc_int] = quecnt_po[qc_int]+1;
    for (qcp_int=0; qcp_int<NUMPOPT; qcp_int=qcp_int+1)
      if (pop_wire[qcp_int] && (po_adr_wire[qc_int]==po_adr_wire[qcp_int]))
        quecnt_po[qc_int] = quecnt_po[qc_int]-1;
  end
end

reg                ru_write_reg [0:NUMRUPT-1][0:MEM_DELAY+UPD_DELAY-1];
reg [BITADDR-1:0]  ru_adr_reg [0:NUMRUPT-1][0:MEM_DELAY+UPD_DELAY-1];
reg [WIDTH-1:0]    ru_din_reg [0:NUMRUPT-1][0:MEM_DELAY+UPD_DELAY-1];
reg                pop_reg   [0:NUMPOPT-1][0:MEM_DELAY+UPD_DELAY-1];
reg [BITQUEU-1:0]  po_adr_reg [0:NUMPOPT-1][0:MEM_DELAY+UPD_DELAY-1];

integer wr_int;
always @(posedge clk) begin
  if (NUMRUPT && rst)
    for (int a=0; a<DEPTH; a=a+1)
      memchk[a] <= 0;
  if (NUMMAPT && rst)
    for (int a=0; a<DEPTH; a=a+1)
      memflg[a] <= 1'b0;
  if (NUMPUPT && rst) begin
    for (int a=0; a<DEPTH; a=a+1)
      memflg[a] <= 1'b0;
    for (int a=0; a<NUMQUEU; a=a+1)
      quecnt[a] <= 0;
  end
  if (NUMSEPT && rst)
    for(int a =0; a<HASHDEPTH; a=a+1) 
      mem_vld[a] <=0;
    
  for (wr_int=0; wr_int<NUMRWPT; wr_int=wr_int+1)
    if (rw_write_wire[wr_int]) 
      memchk[rw_adr_wire[wr_int]] <= rw_din_wire[wr_int];
  for (wr_int=0; wr_int<NUMWRPT; wr_int=wr_int+1)
    if (write_wire[wr_int]) begin
      if (ENAWRSQ)
        memchk[NUMCELL*wr_adr_wire[wr_int][BITADDR-1:BITCELL]+wr_adr_wire[wr_int][BITCELL-1:0]] <= din_wire[wr_int];
      else
        memchk[wr_adr_wire[wr_int]] <= din_wire[wr_int];
      if (ENAWRST)
        memflg[wr_adr_wire[wr_int]] <= 1'b1;
    end
  for (wr_int=0; wr_int<NUMHUPT; wr_int=wr_int+1)
    if (update_wire[wr_int]) begin
      if(up_del_wire[wr_int]) hash_data.delete(up_key_wire[wr_int]);
      else hash_data[up_key_wire[wr_int]] = up_din_wire[wr_int];
      /*int match_id = HASHDEPTH; int empty_id = HASHDEPTH;
      for(int a=0; a< HASHDEPTH; a=a+1) 
        if(empty_id == HASHDEPTH && !mem_vld[a]) empty_id = a; 
        else if(match_id == HASHDEPTH && mem_vld[a] && mem_key[a] == update_key[wr_int]) match_id = a;
      if(match_id < HASHDEPTH) begin
        mem_vld[a] = !up_del[wr_int];
        mem_data[a] = up_data[wr_int];
      end
      else if(!up_del[wr_int] && empty_id < HASHDEPTH) begin
        mem_vld[a] = !up_del[wr_int];
        mem_key[a] = up_key[wr_int];
        mem_data[a] = up_data[wr_int];   
      end
      else if(!up_del[wr_int]) $display("Could not update. No empty slot found in mem_check storage.");
    */end
  for (wr_int=0; wr_int<NUMCTPT; wr_int=wr_int+1)
    if (cnt_wire[wr_int]) 
      memchk[ct_adr_wire[wr_int]] <= cnt_help[wr_int];
  for (wr_int=0; wr_int<NUMACPT; wr_int=wr_int+1)
    if (ac_write_wire[wr_int]) 
      memchk[ac_adr_wire[wr_int]] <= ac_din_wire[wr_int];
  for (wr_int=0; wr_int<NUMRUPT; wr_int=wr_int+1)
    if (ru_write_reg[wr_int][MEM_DELAY+UPD_DELAY-1])
      memchk[ru_adr_reg[wr_int][MEM_DELAY+UPD_DELAY-1]] <= ru_din_reg[wr_int][MEM_DELAY+UPD_DELAY-1];
  for (wr_int=0; wr_int<NUMMAPT; wr_int=wr_int+1)
    if (ma_write_wire[wr_int]) begin
      memflg[ma_adr_wire[wr_int]] <= 1'b1;
      memchk[ma_adr_wire[wr_int]] <= ma_din_wire[wr_int];
    end
  for (wr_int=0; wr_int<NUMDQPT; wr_int=wr_int+1)
    if (dq_vld_wire[wr_int])
      memflg[dq_adr_wire[wr_int]] <= 1'b0;
  for (wr_int=0; wr_int<NUMPUPT; wr_int=wr_int+1)
    if (push_wire[wr_int]) begin
      memflg[pu_din_wire[wr_int]] <= 1'b1;
      quecnt[pu_adr_wire[wr_int]] <= quecnt_pu[wr_int];
    end
  for (wr_int=0; wr_int<NUMPOPT; wr_int=wr_int+1) begin
    if (pop_wire[wr_int])
      quecnt[po_adr_wire[wr_int]] <= quecnt_po[wr_int];
    if (pop_reg[wr_int][MEM_DELAY-1])
      memflg[po_dout_wire[wr_int]] <= 1'b0;
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
reg               search_reg  [0:NUMSEPT-1][0:MEM_DELAY-1];
reg               sr_match_reg[0:NUMSEPT-1][0:MEM_DELAY-1];
reg [DTWIDTH-1:0] sr_dout_reg [0:NUMSEPT-1][0:MEM_DELAY-1];
reg               ac_read_reg [0:NUMACPT-1][0:MEM_DELAY-1];
reg [WIDTH-1:0]   ac_dout_reg [0:NUMACPT-1][0:MEM_DELAY-1];
reg               ru_read_reg [0:NUMRUPT-1][0:MEM_DELAY+UPD_DELAY-1];
reg [WIDTH-1:0]   ru_dout_reg [0:NUMRUPT-1][0:MEM_DELAY+UPD_DELAY-1];

reg               dbg_read_reg [0:NUMDBNK-1][0:MAX_MEM_DELAY-1];
reg [BITDBNK-1:0] dbg_bank_reg [0:NUMDBNK-1][0:MAX_MEM_DELAY-1];
reg [DBGWDTH-1:0] dbg_dout_reg [0:NUMDBNK-1][0:MAX_MEM_DELAY-1];
integer rdel_int, mdel_int,ddel_int;
always @(posedge clk)
  for (ddel_int=0; ddel_int<MAX_MEM_DELAY; ddel_int=ddel_int+1)
    if (ddel_int>0) begin
      if (ddel_int<C1_DELY) begin
        for (rdel_int=0; rdel_int<NUMDBNK; rdel_int=rdel_int+1) begin
          dbg_dout_reg[rdel_int][ddel_int] <= dbg_dout_reg[rdel_int][ddel_int-1];
          dbg_bank_reg[rdel_int][ddel_int] <= dbg_bank_reg[rdel_int][ddel_int-1];
          dbg_read_reg[rdel_int][ddel_int] <= dbg_read_reg[rdel_int][ddel_int-1];
        end
      end
    end else begin
      for (rdel_int=0; rdel_int<NUMDBNK; rdel_int=rdel_int+1) begin
        dbg_dout_reg[rdel_int][mdel_int] <= (dbg_read && (dbg_bank == rdel_int)) ? dbgchk[dbg_bank][dbg_addr] : {(DBGWDTH>0?DBGWDTH:1){1'bx}};
        dbg_read_reg[rdel_int][mdel_int] <= dbg_read && (dbg_bank == rdel_int);
      end
    end

always @(posedge clk)
  for (mdel_int=0; mdel_int<MEM_DELAY+UPD_DELAY; mdel_int=mdel_int+1)
    if (mdel_int>0) begin
      if (mdel_int<MEM_DELAY) begin
        for (rdel_int=0; rdel_int<NUMRDPT; rdel_int=rdel_int+1) begin
          read_reg[rdel_int][mdel_int] <= read_reg[rdel_int][mdel_int-1];
          rd_adr_reg[rdel_int][mdel_int] <= rd_adr_reg[rdel_int][mdel_int-1];
          rd_dout_reg[rdel_int][mdel_int] <= rd_dout_reg[rdel_int][mdel_int-1];
        end
        for (rdel_int=0; rdel_int<NUMRWPT; rdel_int=rdel_int+1) begin
          rw_read_reg[rdel_int][mdel_int] <= rw_read_reg[rdel_int][mdel_int-1];
          rw_dout_reg[rdel_int][mdel_int] <= rw_dout_reg[rdel_int][mdel_int-1];
        end
        for (rdel_int=0; rdel_int<NUMSEPT; rdel_int=rdel_int+1) begin
          search_reg[rdel_int][mdel_int] <= search_reg[rdel_int][mdel_int-1];
          sr_match_reg[rdel_int][mdel_int] <= sr_match_reg[rdel_int][mdel_int-1];
          sr_dout_reg[rdel_int][mdel_int] <= sr_dout_reg[rdel_int][mdel_int-1];
        end
        for (rdel_int=0; rdel_int<NUMACPT; rdel_int=rdel_int+1) begin
          ac_read_reg[rdel_int][mdel_int] <= ac_read_reg[rdel_int][mdel_int-1];
          ac_dout_reg[rdel_int][mdel_int] <= ac_dout_reg[rdel_int][mdel_int-1];
        end
      end
      for (rdel_int=0; rdel_int<NUMPOPT; rdel_int=rdel_int+1) begin
        pop_reg[rdel_int][mdel_int] <= pop_reg[rdel_int][mdel_int-1];
        po_adr_reg[rdel_int][mdel_int] <= po_adr_reg[rdel_int][mdel_int-1];
      end
      for (rdel_int=0; rdel_int<NUMRUPT; rdel_int=rdel_int+1) begin
        ru_read_reg[rdel_int][mdel_int] <= ru_read_reg[rdel_int][mdel_int-1];
        ru_dout_reg[rdel_int][mdel_int] <= ru_dout_reg[rdel_int][mdel_int-1];
        ru_write_reg[rdel_int][mdel_int] <= ru_write_reg[rdel_int][mdel_int-1];
        ru_adr_reg[rdel_int][mdel_int] <= ru_adr_reg[rdel_int][mdel_int-1];
        ru_din_reg[rdel_int][mdel_int] <= ru_din_reg[rdel_int][mdel_int-1];
      end
      // Mask forwarding read cases since forwarding has to be handled outside.
      for (rdel_int=0;rdel_int<NUMRUPT;rdel_int=rdel_int+1) begin
        if(ru_adr_reg[rdel_int][MEM_DELAY-1] == ru_adr_reg[rdel_int][mdel_int] && ru_read_reg[rdel_int][MEM_DELAY-1]) begin
          ru_read_reg[rdel_int][mdel_int] = 1'b0;
          //$display("Masked a read due to read forwarding. addr = 0x%h", ru_adr_reg[rdel_int][mdel_int]);
        end
      end
      // End masking
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
      for (rdel_int=0; rdel_int<NUMSEPT; rdel_int=rdel_int+1) begin
        search_reg[rdel_int][mdel_int] <= search_wire[rdel_int];
        sr_match_reg[rdel_int][mdel_int] <= search_wire[rdel_int] ? hash_data.exists(sr_key_wire[rdel_int]) : 'hx;
        sr_dout_reg[rdel_int][mdel_int] <= search_wire[rdel_int] && hash_data.exists(sr_key_wire[rdel_int]) ? hash_data[sr_key_wire[rdel_int]] : 'hx;
        /*int match_id = HASHDEPTH;
        if(search_wire[rdel_int])
          for(int a=0; a<HASHDEPTH; a=a+1) if(match_id == HASHDEPTH && mem_vld[a] && mem_key[a] == sr_key_wire[rdel_int]) match_id = a;
        sr_match_reg[rdel_int][mdel_int] <= (match_id < HASHDEPTH);
        sr_dout_reg[rdel_int][mdel_int] <= (match_id < HASHDEPTH ? mem_data[match_id] : {DTWIDTH(1'bx}}); 
      */end     
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
      for (rdel_int=0; rdel_int<NUMPOPT; rdel_int=rdel_int+1) begin
        pop_reg[rdel_int][mdel_int] <= pop_wire[rdel_int];
        po_adr_reg[rdel_int][mdel_int] <= po_adr_wire[rdel_int];
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
reg [NUMRWPT-1:0] match_se;
reg [NUMACPT-1:0] match_ac;
reg [NUMRUPT-1:0] match_ru;
reg [NUMMAPT-1:0] match_ma;
reg [NUMPOPT-1:0] match_po;
reg [NUMDBNK-1:0] match_db;
always_comb begin
  for (chk_int=0; chk_int<NUMRDPT; chk_int=chk_int+1) begin
    match_rd[chk_int] = !read_reg[chk_int][MEM_DELAY-1] || ((rd_vld_wire[chk_int] === read_reg[chk_int][MEM_DELAY-1]) &&
                                    (rd_dout_wire[chk_int] === rd_dout_reg[chk_int][MEM_DELAY-1]));
  end
  for (chk_int=0; chk_int<NUMRWPT; chk_int=chk_int+1)
    match_rw[chk_int] = !rw_read_reg[chk_int][MEM_DELAY-1] || ((rw_vld_wire[chk_int] === rw_read_reg[chk_int][MEM_DELAY-1]) &&
                                    (rw_dout_wire[chk_int] === rw_dout_reg[chk_int][MEM_DELAY-1]));
  for (chk_int=0; chk_int<NUMSEPT; chk_int=chk_int+1)
    match_se[chk_int] = !search_reg[chk_int][MEM_DELAY-1] || ((sr_vld_wire[chk_int] === search_reg[chk_int][MEM_DELAY-1]) &&
                                    (sr_match_wire[chk_int] === sr_match_reg[chk_int][MEM_DELAY-1]) &&
                                    (!sr_match_wire[chk_int] || (sr_dout_wire[chk_int] === sr_dout_reg[chk_int][MEM_DELAY-1])));
  for (chk_int=0; chk_int<NUMACPT; chk_int=chk_int+1)
    match_ac[chk_int] = !ac_read_reg[chk_int][MEM_DELAY-1] || ((ac_vld_wire[chk_int] === ac_read_reg[chk_int][MEM_DELAY-1]) &&
                                                               (ac_dout_wire[chk_int] === ac_dout_reg[chk_int][MEM_DELAY-1])); 
  for (chk_int=0; chk_int<NUMRUPT; chk_int=chk_int+1)
    match_ru[chk_int] = !ru_read_reg[chk_int][MEM_DELAY-1] || ((ru_vld_wire[chk_int] === ru_read_reg[chk_int][MEM_DELAY-1]) &&
                                                               (ru_dout_wire[chk_int] === memchk[ru_adr_reg[chk_int][MEM_DELAY-1]])); 
  for (chk_int=0; chk_int<NUMMAPT; chk_int=chk_int+1)
    match_ma[chk_int] = !ma_write_wire[chk_int] || !memflg[ma_adr_wire[chk_int]];
  for (chk_int=0; chk_int<NUMPOPT; chk_int=chk_int+1)
    match_po[chk_int] = !pop_reg[chk_int][MEM_DELAY-1] || ((po_vld_wire[chk_int] === pop_reg[chk_int][MEM_DELAY-1]) &&
                                                           memflg[po_dout_wire[chk_int]]);
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
  for (stp_int=0; stp_int<NUMSEPT; stp_int=stp_int+1)
    if (!match_se[stp_int]) begin
      `ERROR($psprintf("memory search check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, sr_dout_reg[stp_int][MEM_DELAY-1], sr_dout_wire[stp_int]))
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
  for (stp_int=0; stp_int<NUMMAPT; stp_int=stp_int+1)
    if (!match_ma[stp_int]) begin
      `ERROR($psprintf("memory ma check failed on port=%0d adr=0x%0x already allocated", stp_int, ma_adr_wire[stp_int]))
      stop_sim <= 1'b1;
    end
  for (stp_int=0; stp_int<NUMPOPT; stp_int=stp_int+1) begin
    if (!match_po[stp_int]) begin
      `ERROR($psprintf("memory po check failed on port=%0d act=0x%0x", stp_int, po_dout_wire[stp_int]))
      stop_sim <= 1'b1;
    end
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
  if (stop_sim) #1 $finish;
end

reg matchflag;
always @(posedge clk)
  if (rst)
    matchflag <= 1'b0;
  else
    matchflag <= matchflag || ((NUMRDPT>0) && ~&match_rd) ||
                              ((NUMRWPT>0) && ~&match_rw) ||
                              ((NUMSEPT>0) && ~&match_se) ||
                              ((NUMACPT>0) && ~&match_ac) ||
                              ((NUMRUPT>0) && ~&match_ru) ||
                              ((NUMPOPT>0) && ~&match_po) ||
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

reg [NUMPUPT-1:0]         push;
reg [NUMPUPT*BITQUEU-1:0] pu_adr;
reg [NUMPUPT*BITADDR-1:0] pu_din; 

reg [NUMPOPT-1:0]         pop;
reg [NUMPOPT*BITQUEU-1:0] po_adr;

reg [NUMDQPT-1:0]         dq_vld;
reg [NUMDQPT*BITADDR-1:0] dq_adr;

reg [NUMSEPT-1:0]          search;
reg [NUMSEPT*KYWIDTH-1:0]  sr_key;

reg [NUMHUPT-1:0]          update;
reg [NUMHUPT*KYWIDTH-1:0]  up_key;
reg [NUMHUPT*DTWIDTH-1:0]  up_din;
reg [NUMHUPT-1:0]          up_del;

integer bus_int;
always_comb begin
  read = 0;
  rd_adr = 0;
  for (bus_int=0; bus_int<NUMRDPT; bus_int=bus_int+1) begin
    read = read | (read_wire[bus_int] << bus_int);
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
    ru_write = ru_write | (ru_write_reg[bus_int][MEM_DELAY+UPD_DELAY-1] << bus_int);
    ru_addr = ru_addr | (ru_adr_wire[bus_int] << (bus_int*BITADDR));
    ru_din = ru_din | (ru_din_reg[bus_int][MEM_DELAY+UPD_DELAY-1] << (bus_int*WIDTH));
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
  dq_vld = 0;
  dq_adr = 0;
  for (bus_int=0; bus_int<NUMDQPT; bus_int=bus_int+1) begin
    dq_vld = dq_vld | (dq_vld_wire[bus_int] << bus_int);
    dq_adr = dq_adr | (dq_adr_wire[bus_int] << (bus_int*BITADDR));
  end
  push = 0;
  pu_adr = 0;
  pu_din = 0;
  for (bus_int=0; bus_int<NUMPUPT; bus_int=bus_int+1) begin
    push = push | (push_wire[bus_int] << bus_int);
    pu_adr = pu_adr | (pu_adr_wire[bus_int] << (bus_int*BITQUEU));
    pu_din = pu_din | (pu_din_wire[bus_int] << (bus_int*WIDTH));
  end
  pop = 0;
  po_adr = 0;
  for (bus_int=0; bus_int<NUMPOPT; bus_int=bus_int+1) begin
    pop = pop | (pop_wire[bus_int] << bus_int);
    po_adr = po_adr | (po_adr_wire[bus_int] << (bus_int*BITQUEU));
    po_vld_wire[bus_int] = po_vld >> bus_int;
    po_dout_wire[bus_int] = po_dout >> (bus_int*WIDTH);
    po_serr_wire[bus_int] = po_serr >> bus_int;
    po_derr_wire[bus_int] = po_derr >> bus_int;
    po_padr_wire[bus_int] = po_padr >> (bus_int*BITPADR);
  end
  search=0;
  sr_key =0;
  for (bus_int=0; bus_int<NUMSEPT; bus_int=bus_int+1) begin
    search = search | (search_wire[bus_int] << bus_int);
    sr_key = sr_key | (sr_key_wire[bus_int] << (bus_int*KYWIDTH));
    sr_vld_wire [bus_int] = sr_vld  >> bus_int;
    sr_match_wire [bus_int] = sr_match  >> bus_int;
    sr_dout_wire[bus_int] = sr_dout >> (bus_int*DTWIDTH);
    sr_serr_wire[bus_int] = sr_serr >> bus_int;
    sr_derr_wire[bus_int] = sr_derr >> bus_int;
    sr_padr_wire[bus_int] = sr_padr >> (bus_int*BITPADR);
  end
  update=0;
  up_del = 0;
  up_key =0;
  up_din=0;
  for (bus_int=0; bus_int<NUMHUPT; bus_int=bus_int+1) begin
    update = update | (update_wire[bus_int] << bus_int);
    up_del = up_del | (up_del_wire[bus_int] << bus_int);
    up_key = up_key | (up_key_wire[bus_int] << (bus_int*KYWIDTH));
    up_din = up_din | (up_din_wire[bus_int] << (bus_int*DTWIDTH));
    up_bp_wire[bus_int] = up_bp >> bus_int;
  end
end

wire [WIDTH-1:0] po_dout_wire_0 = po_dout_wire[0];

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
function [NUMPUPT*WIDTH-1:0] randomPUvalue; input integer width; integer i; begin randomPUvalue = 0; for (i = width/32; i >= 0; i--) randomPUvalue = (randomPUvalue << 32) + $urandom; end endfunction
function [NUMSEPT*KYWIDTH-1:0] randomSEkey; input integer width; integer i; begin randomSEkey = 0; for (i = width/32; i >= 0; i--) randomSEkey = (randomSEkey << 32) + $urandom; end endfunction
function [NUMHUPT*KYWIDTH-1:0] randomUPkey; input integer width; integer i; begin randomUPkey = 0; for (i = width/32; i >= 0; i--) randomUPkey = (randomUPkey << 32) + $urandom; end endfunction
function [NUMHUPT*DTWIDTH-1:0] randomUPvalue; input integer width; integer i; begin randomUPvalue = 0; for (i = width/32; i >= 0; i--) randomUPvalue = (randomUPvalue << 32) + $urandom; end endfunction


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
  reg [BITADDR-1:0] tmpadr1, tmpadr2, tmpadr3;
  reg [BITVBNK-1:0] tmpbnk;
  begin
    `TB_YAP("test_write_all running") 
    if (ENAWRSQ)
      for (m=0; m<NUMQUEU; m=m+1)
        for (i=0; i<NUMCELL; i=i+1)
          memacc (0, 0,
                  0, 0, 0, 0,
                  1, {m[BITQUEU-1:0],i[BITCELL-1:0]}, randomWRvalue(NUMWRPT*WIDTH),
                  0, 0, 0,
                  0, 0, 0, 0,
                  0, 0, 0, 0,
                  0, 0,
                  0, 0,
                  0, 0, 0,
                  0, 0,
                  0, 0,
                  0, 0, 0, 0);
    else for (m=0; m<DEPTH; m=m+1)
      if (NUMWRPT>0)
        if (ENAWRSG) begin
          tmpbnk = m >> BITVROW;
          for (i=0; i<NUMWRPT; i=i+1)
            if (wrsgmsk[tmpbnk][i])
              memacc (0, 0,
                      0, 0, 0, 0,
                      1 << i, m << (i*BITADDR), randomWRvalue(NUMWRPT*WIDTH),
                      0, 0, 0,
                      0, 0, 0, 0,
                      0, 0, 0, 0,
                      0, 0,
                      0, 0,
                      0, 0, 0,
                      0, 0,
                      0, 0,
                      0, 0, 0, 0);
        end else
          memacc (0, 0,
                  0, 0, 0, 0,
                  1, m, randomWRvalue(NUMWRPT*WIDTH),
                  0, 0, 0,
                  0, 0, 0, 0,
                  0, 0, 0, 0,
                  0, 0,
                  0, 0,
                  0, 0, 0,
                  0, 0,
                  0, 0,
                  0, 0, 0, 0);
      else if (NUMRWPT>0)
        memacc (0, 0,
                0, 1, m, randomRWvalue(NUMRWPT*WIDTH),
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0,
                0, 0,
                0, 0, 0,
                0, 0,
                0, 0,
                0, 0, 0, 0);
      else if (NUMACPT>0)
        memacc (0, 0,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                0, 1, m, randomACvalue(NUMACPT*WIDTH),
                0, 0, 0, 0,
                0, 0,
                0, 0,
                0, 0, 0,
                0, 0,
                0, 0,
                0, 0, 0, 0);
      else if (NUMRUPT>0)
        memacc (0, 0,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0,
                1, 1, m, randomRUvalue(NUMRUPT*WIDTH),
                0, 0,
                0, 0,
                0, 0, 0,
                0, 0,
                0, 0,
                0, 0, 0, 0);
      else if (NUMMAPT>0) begin
        if (m<8)
          memacc (0, 0,
                  0, 0, 0, 0,
                  0, 0, 0,
                  0, 0, 0,
                  0, 0, 0, 0,
                  0, 0, 0, 0,
                  1, randomMAvalue(NUMMAPT*WIDTH),
                  0, 0,
                  0, 0, 0,
                  0, 0,
                  0, 0,
                  0, 0, 0, 0);
      end else if (NUMPUPT>0) begin
        memacc (0, 0,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0,
                0, 0,
                1, m%NUMQUEU, m,
                0, 0,
                0, 0,
                0, 0, 0, 0);
      end else if (NUMHUPT>0) begin
        memacc (0, 0,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0,
                0, 0,
                0, 0, 0,
                0, 0,
                0, 0,
                1, 0, m, m);
      end
    cyc (10);
    `TB_YAP("test_write_all completed")
  end
endtask

task test_write_seq_till_bp;
  integer m;
  begin
    for (m=0; m<2*DEPTH; m=m+1)
      if (NUMHUPT>0) begin
        memacc (0, 0,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0,
                0, 0,
                0, 0, 0,
                0, 0,
                0, 0,
                !up_bp, 0, m , m);
      end
    cyc (10);
    `TB_YAP("test_write_seq_till_bp completed with pop = ")
    $display("%d\n", hash_data.num());
  end
endtask

task test_write_rand_till_bp;
  integer m;
  begin
    for (m=0; m<3*DEPTH; m=m+1)
      if (NUMHUPT>0) begin
        memacc (0, 0,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0,
                0, 0,
                0, 0, 0,
                0, 0,
                0, 0,
                !up_bp, 0, randomUPkey(NUMHUPT*KYWIDTH) , randomUPvalue(NUMHUPT*DTWIDTH));
      end
    cyc (10);
    `TB_YAP("test_write_rand_till_bp completed with pop = ")
    $display("%d\n", hash_data.num());
  end
endtask

task test_write_till_load;
  input integer load;
  integer m;
  begin
    for (m=0; m<load; m=m+1)
      if (NUMHUPT>0) begin
        if(up_bp) cyc(4);
        memacc (0, 0,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0,
                0, 0,
                0, 0, 0,
                0, 0,
                0, 0,
                !up_bp, 0, randomUPkey(NUMHUPT*KYWIDTH) , randomUPvalue(NUMHUPT*DTWIDTH));
      end
    cyc (10);
    `TB_YAP("test_write_till_load completed with pop = ")
    $display("%d\n", hash_data.num());
  end
endtask


task test_hash_random;
  integer m;
  integer key_id; 
  integer tmp_id;
  reg[KYWIDTH-1:0] key;
  integer maxChoice;
  integer choice;   //0 is idle cycle, 1 is insert, 2 is delete, 3 is update, >3 is search, maxChoice-1 is search_unknown
  begin
    maxChoice = 10;
    for (m=0; m<2*DEPTH; m=m+1) begin
      choice = $urandom%maxChoice;
      if (NUMHUPT>0) begin
        if(choice == 1) begin  //Insert Random entry.
          memacc (0, 0,
                  0, 0, 0, 0,
                  0, 0, 0,
                  0, 0, 0,
                  0, 0, 0, 0,
                  0, 0, 0, 0,
                  0, 0,
                  0, 0,
                  0, 0, 0,
                  0, 0,
                  0, 0,
                  !up_bp, 0, randomUPkey(NUMHUPT*KYWIDTH) , randomUPvalue(NUMHUPT*DTWIDTH));
        end else if(choice < maxChoice-1 && hash_data.num() > 0) begin
          key_id = $urandom%hash_data.num();
          tmp_id = 0;
          hash_data.first(key);
          while (tmp_id < key_id) begin
            hash_data.next(key);
            tmp_id = tmp_id+1;
          end
          memacc (0, 0,
                  0, 0, 0, 0,
                  0, 0, 0,
                  0, 0, 0,
                  0, 0, 0, 0,
                  0, 0, 0, 0,
                  0, 0,
                  0, 0,
                  0, 0, 0,
                  0, 0,
                  (choice > 3), key,
                  !up_bp && (choice > 0 && choice < 4), (choice==2), key , randomUPvalue(NUMHUPT*DTWIDTH));
        end
        else if(choice == maxChoice-1) begin
          memacc (0, 0,
                  0, 0, 0, 0,
                  0, 0, 0,
                  0, 0, 0,
                  0, 0, 0, 0,
                  0, 0, 0, 0,
                  0, 0,
                  0, 0,
                  0, 0, 0,
                  0, 0,
                  1, randomSEkey(NUMSEPT*KYWIDTH),
                  0, 0, 0, 0);
          end
        end
      end
    cyc (10);
    `TB_YAP("test_hash_random completed with pop = ")
    $display("%d\n", hash_data.num());
  end
endtask

task test_delete_till_no_bp;
  reg [KYWIDTH-1:0] key;
  begin
    if(hash_data.first(key))
    do  
    if (NUMSEPT>0) begin
        memacc (0, 0,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0,
                0, 0,
                0, 0, 0,
                0, 0,
                0, 0,
                1, 1, key, 0);
      end
      while(hash_data.next(key) && up_bp);
    cyc (10);
    `TB_YAP("test_delete_till_no_bp completed with pop =")
    $display("%d\n", hash_data.num());
  end
endtask

task test_search_all;
  reg [KYWIDTH-1:0] key;
  begin
    if(hash_data.first(key))
    do  
    if (NUMSEPT>0) begin
        memacc (0, 0,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0,
                0, 0,
                0, 0, 0,
                0, 0,
                1, key,
                0, 0, 0, 0);
      end
      while(hash_data.next(key));
    cyc (10);
    `TB_YAP("test_search_all completed.")
  end
endtask

task test_search_random;
  integer m;
  begin
    for(m=0; m<DEPTH; m=m+1)
      if (NUMSEPT>0) begin
        memacc (0, 0,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0,
                0, 0,
                0, 0, 0,
                0, 0,
                1, randomSEkey(NUMSEPT*KYWIDTH),
                0, 0, 0, 0);
      end
    cyc (10);
    `TB_YAP("test_search_random completed.")
  end
endtask

task test_read_all;
  integer m, i;
  reg [BITVBNK-1:0] tmpbnk;
  begin
    `TB_YAP("test_read_all running") 
    if (NUMPOPT>0) begin
      for (m=0; m<NUMQUEU; m=m+1)
        while (|quecnt[m]) begin
          memacc (0, 0,
                  0, 0, 0, 0,
                  0, 0, 0,
                  0, 0, 0,
                  0, 0, 0, 0,
                  0, 0, 0, 0,
                  0, 0,
                  0, 0,
                  0, 0, 0,
                  1, m,
                  0, 0,
                  0, 0, 0, 0);
         cyc(4);
       end
    end else if (ENARDSQ)
      for (m=0; m<NUMQUEU; m=m+1)
        for (i=0; i<NUMCELL; i=i+1)
          memacc (1, {m[BITQUEU-1:0],i[BITCELL-1:0]},
                  0, 0, 0, 0,
                  0, 0, 0,
                  0, 0, 0,
                  0, 0, 0, 0,
                  0, 0, 0, 0,
                  0, 0,
                  0, 0,
                  0, 0, 0,
                  0, 0,
                  0, 0,
                  0, 0, 0, 0);
    else for (m=0; m<DEPTH; m=m+1)
      if (NUMRDPT>0)
        if (ENARDSG) begin
          tmpbnk = m >> BITVROW;
          for (i=0; i<NUMRDPT; i=i+1)
            if (wrsgmsk[tmpbnk][i])
              memacc (1 << i, m << (i*BITADDR),
                      0, 0, 0, 0,
                      0, 0, 0,
                      0, 0, 0,
                      0, 0, 0, 0,
                      0, 0, 0, 0,
                      0, 0,
                      0, 0,
                      0, 0, 0,
                      0, 0,
                      0, 0,
                      0, 0, 0, 0);
        end else
          memacc (1, m,
                  0, 0, 0, 0,
                  0, 0, 0,
                  0, 0, 0,
                  0, 0, 0, 0,
                  0, 0, 0, 0,
                  0, 0,
                  0, 0,
                  0, 0, 0,
                  0, 0,
                  0, 0,
                  0, 0, 0, 0);
      else if (NUMRWPT>0)
        memacc (0, 0,
                1, 0, m, 0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0,
                0, 0,
                0, 0, 0,
                0, 0,
                0, 0,
                0, 0, 0, 0);
      else if (NUMACPT>0)
        memacc (0, 0,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                1, 0, m, 0,
                0, 0, 0, 0,
                0, 0,
                0, 0,
                0, 0, 0,
                0, 0,
                0, 0,
                0, 0, 0, 0);
      else if (NUMRUPT>0)
        memacc (0, 0,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0,
                1, 0, m, 0,
                0, 0,
                0, 0,
                0, 0, 0,
                0, 0,
                0, 0,
                0, 0, 0, 0);
      else if (NUMSEPT>0)
        memacc (0, 0,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0,
                0, 0,
                0, 0, 0,
                0, 0,
                1, m,
                0, 0, 0, 0);
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
input [NUMDQPT-1:0] dq;
input [NUMDQPT*BITADDR-1:0] dqadr;
input [NUMPUPT-1:0] pu;
input [NUMPUPT*BITQUEU-1:0] puadr;
input [NUMPUPT*WIDTH-1:0] pudin;
input [NUMPOPT-1:0] po;
input [NUMPOPT*BITQUEU-1:0] poadr;
input [NUMSEPT-1:0] sr;
input [NUMSEPT*KYWIDTH-1:0] srkey;
input [NUMHUPT-1:0] up;
input [NUMHUPT-1:0] updel;
input [NUMHUPT*KYWIDTH-1:0] upkey;
input [NUMHUPT*DTWIDTH-1:0] updin;
integer i;
  begin
    if (refr)
      cyc (1);
    for (i=0; i<NUMRDPT; i=i+1) begin
      read_wire[i] = rd >> i;
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
    for (i=0; i<NUMDQPT; i=i+1) begin
      dq_vld_wire[i] = dq >> i;
      dq_adr_wire[i] = dqadr >> i*BITADDR;
    end
    for (i=0; i<NUMPUPT; i=i+1) begin
      push_wire[i] = pu >> i;
      pu_adr_wire[i] = puadr >> i*BITQUEU;
      pu_din_wire[i] = pudin >> i*WIDTH;
    end
    for (i=0; i<NUMPOPT; i=i+1) begin
      pop_wire[i] = po >> i;
      po_adr_wire[i] = poadr >> i*BITQUEU;
    end
    for (i=0; i<NUMSEPT; i=i+1) begin
      search_wire[i] = sr >> i;
      sr_key_wire[i] = srkey >> i*KYWIDTH;
    end
    for (i=0; i<NUMHUPT; i=i+1) begin
      update_wire[i] = up >> i;
      up_del_wire[i] = updel >> i;
      up_key_wire[i] = upkey >> i*KYWIDTH;
      up_din_wire[i] = updin >> i*DTWIDTH;
    end
    cyc (1);
    for (i=0; i<NUMRDPT; i=i+1) begin
      read_wire[i] = 0;
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
    for (i=0; i<NUMDQPT; i=i+1) begin
      dq_vld_wire[i] = 0;
      dq_adr_wire[i] = 'hx;
    end
    for (i=0; i<NUMPUPT; i=i+1) begin
      push_wire[i] = 0;
      pu_adr_wire[i] = 'hx;
    end
    for (i=0; i<NUMPOPT; i=i+1) begin
      pop_wire[i] = 0;
      po_adr_wire[i] = 'hx;
    end
    for (i=0; i<NUMSEPT; i=i+1) begin
      search_wire[i] = 0;
      sr_key_wire[i] = 'hx;
    end
    for (i=0; i<NUMHUPT; i=i+1) begin
      update_wire[i] = 0;
      up_del_wire[i] = 'hx;
      up_key_wire[i] = 'hx;
      up_din_wire[i] = 'hx;
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
reg [KYWIDTH-1:0] tmpkey;
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
reg [NUMDQPT-1:0] deq;
reg [NUMDQPT*BITADDR-1:0] dqadr;
reg [NUMPUPT-1:0] puwr;
reg [NUMPUPT*BITQUEU-1:0] puadr;
reg [NUMPUPT*BITADDR-1:0] pudin;
reg [NUMPOPT-1:0] pord;
reg [NUMPOPT*BITQUEU-1:0] poadr;
reg [NUMSEPT-1:0] sr;
reg [NUMSEPT*KYWIDTH-1:0] srkey;
reg [NUMHUPT-1:0] up;
reg [NUMHUPT-1:0] updel;
reg [NUMHUPT*KYWIDTH-1:0] upkey;
reg [NUMHUPT*DTWIDTH-1:0] updin;
reg no_free_bnks;
  begin
    `TB_YAP("test_random running") 
    for (n=0; n<num; n=n+1) begin
      usedbnk = 0;
      no_free_bnks = 0;
      if ((n% 10000) == 0) 
        `TB_YAP($psprintf("test_random sent %0d of %0d", n, num))

      read = 0;
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
          if (&usedbnk && (ENAPSDO || ENARPSD)) no_free_bnks = 1;
          while ((ENAPSDO || ENARPSD) && tmpacc && usedbnk[tmpbnk] && !(&usedbnk)) begin
            tmpadr = $urandom%DEPTH;
            tmpbnk = tmpadr >> BITVROW;
          end
          usedbnk = usedbnk | (tmpacc << tmpbnk);
        end
        read = read | ((!no_free_bnks && tmpacc) << i); 
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
        if (&usedbnk && (ENAPSDO || ENARPSD)) no_free_bnks = 1;
        while ((ENAPSDO || ENARPSD) && tmpacc && usedbnk[tmpbnk] && !(&usedbnk)) begin
          tmpadr = $urandom%DEPTH;
          tmpbnk = tmpadr >> BITVROW;
        end
        usedbnk = usedbnk | (tmpacc << tmpbnk);
        rwrd = rwrd | ((!no_free_bnks && tmprw && tmpacc) << i); 
        rwwr = rwwr | ((!no_free_bnks && !tmprw && tmpacc) << i); 
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
                tmpacc = tmpacc && !(write_reg[j][k-1] && (wr_adr_reg[j][k-1]==tmpadr));
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
          if (&usedbnk && (ENAPSDO || ENARPSD)) no_free_bnks = 1;
          while ((ENAPSDO || ENARPSD) && tmpacc && usedbnk[tmpbnk] && !(&usedbnk)) begin
            tmpadr = $urandom%DEPTH;
            tmpbnk = tmpadr >> BITVROW;
          end
          if (ENAWRST)
            tmpacc = tmpacc && !memflg[tmpadr];
          usedbnk = usedbnk | (tmpacc << tmpbnk);
        end
        write = write | ((!no_free_bnks && tmpacc) << i); 
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
        if (ENAWRST)
          tmpacc = tmpacc && memflg[tmpadr];
        rurd = rurd | (tmpacc << i); 
        ruwr = ruwr | ((tmpru && tmpacc) << i); 
        ruadr = ruadr | (tmpadr << i*BITADDR);
      end

      mawr = 0;
      for (i=0; i<NUMMAPT; i=i+1) begin
        tmpacc = ($urandom < 32'hC0000000) && !ma_bp_wire[i];
        mawr = mawr | (tmpacc << i); 
      end

      deq = 0;
      dqadr = 0;
      for (i=0; i<NUMDQPT; i=i+1) begin
        tmpadr = $urandom%DEPTH;
        tmpacc = ($urandom < 32'hC0000000);
        tmpacc = tmpacc && memflg[tmpadr];
        for (j=0; j<i; j=j+1) begin
          tmpchk = dqadr >> (j*BITADDR);
          tmpacc = tmpacc && !(deq[j] && (tmpadr==tmpchk));
        end
        deq = deq | (tmpacc << i);
        dqadr = dqadr | (tmpadr << i*BITADDR);
      end

      pord = 0;
      poadr = 0;
      for (i=0; i<NUMPOPT; i=i+1) begin
        tmpacc = ($urandom < 32'hC0000000);
        tmpque = $urandom%NUMQUEU;
        for (j=0; j<4; j=j+1)
          if (pop_reg[i][j] && (po_adr_reg[i][j]==tmpque))
            tmpacc = 0;
        tmpacc = tmpacc && |quecnt[tmpque];
        pord = pord | (tmpacc << i); 
        poadr = poadr | (tmpque << i*BITQUEU);
      end

      puwr = 0;
      puadr = 0;
      pudin = 0;
      for (i=0; i<NUMPUPT; i=i+1) begin
        tmpacc = ($urandom < 32'hC0000000);
        tmpque = $urandom%NUMQUEU;
        tmpadr = $urandom%DEPTH;
        tmpacc = tmpacc && !memflg[tmpadr];
        for (j=0; j<i; j=j+1) begin
          tmpchk = pudin>>(j*BITADDR);
          tmpacc = tmpacc && !(puwr[j] && (tmpchk==tmpadr));
        end
        puwr = puwr | (tmpacc << i); 
        puadr = puadr | (tmpque << i*BITQUEU);
        pudin = pudin | (tmpadr << i*BITADDR);
      end

      sr = 0;
      srkey = 0;
      for (i=0; i<NUMSEPT; i=i+1) begin
        tmpacc = ($urandom < 32'hC0000000);
        tmpkey = $urandom%NUMHKEY;
//        tmpacc = tmpacc && |quecnt[tmpkey];
        sr = sr | (tmpacc << i); 
        srkey = srkey | (tmpkey << i*BITQUEU);
      end

      up = 0;
      updel = 0;
      upkey = 0;
      for (i=0; i<NUMHUPT; i=i+1) begin
        tmpacc = ($urandom < 32'hC0000000);
        tmpkey = $urandom%NUMHKEY;
//        tmpacc = tmpacc && !memflg[tmpadr];
        up = up | (tmpacc << i); 
        upkey = upkey | (tmpkey << i*KYWIDTH);
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
      read = read & (ptmask >> (NUMRWPT+NUMWRPT+NUMCTPT+NUMACPT+NUMRUPT+NUMMAPT+NUMDQPT+NUMPUPT+NUMPOPT+NUMHUPT+NUMSEPT));
      rwrd = rwrd & (ptmask >> (NUMWRPT+NUMCTPT+NUMACPT+NUMRUPT+NUMMAPT+NUMDQPT+NUMPUPT+NUMPOPT+NUMHUPT+NUMSEPT));
      rwwr = rwwr & (ptmask >> (NUMWRPT+NUMCTPT+NUMACPT+NUMRUPT+NUMMAPT+NUMDQPT+NUMPUPT+NUMPOPT+NUMHUPT+NUMSEPT));
      write = write & (ptmask >> (NUMCTPT+NUMACPT+NUMRUPT+NUMMAPT+NUMDQPT+NUMPUPT+NUMPOPT+NUMHUPT+NUMSEPT));
      cnt = cnt & (ptmask >> (NUMACPT+NUMRUPT+NUMMAPT+NUMDQPT+NUMPUPT+NUMPOPT+NUMHUPT+NUMSEPT));
      acrd = acrd & (ptmask >> (NUMRUPT+NUMMAPT+NUMDQPT+NUMPUPT+NUMPOPT+NUMHUPT+NUMSEPT));
      acwr = acwr & (ptmask >> (NUMRUPT+NUMMAPT+NUMDQPT+NUMPUPT+NUMPOPT+NUMHUPT+NUMSEPT));
      rurd = rurd & (ptmask >> (NUMMAPT+NUMDQPT+NUMPUPT+NUMPOPT+NUMHUPT+NUMSEPT));
      ruwr = ruwr & (ptmask >> (NUMMAPT+NUMDQPT+NUMPUPT+NUMPOPT+NUMHUPT+NUMSEPT));
      mawr = mawr & (ptmask >> (NUMDQPT+NUMPUPT+NUMPOPT+NUMHUPT+NUMSEPT));
      deq = deq & (ptmask >> (NUMPUPT+NUMPOPT+NUMHUPT+NUMSEPT));
      puwr = puwr & (ptmask >> (NUMPOPT+NUMHUPT+NUMSEPT));
      pord = pord & (ptmask >> (NUMHUPT+NUMSEPT));
      sr = sr & (ptmask >> (NUMHUPT));
      up = up & ptmask; 

      if (ENAWRST)
        memacc(read, rdadr,
               rwrd, rwwr, rwadr, randomRWvalue(NUMRWPT*WIDTH),
               write, wradr, randomWRvalue(NUMWRPT*WIDTH),
               cnt, ctadr, randomCTvalue(NUMCTPT*WIDTH),
               acrd, acwr, acadr, randomACvalue(NUMACPT*WIDTH),
               rurd, rurd, ruadr, ruwr ? 0 : randomRUvalue(NUMRUPT*WIDTH),
               mawr, randomMAvalue(NUMMAPT*WIDTH),
               deq, dqadr,
               puwr, puadr, pudin,
               pord, poadr,
               sr, srkey,
               up, updel, upkey, randomUPvalue(NUMHUPT*DTWIDTH));
      else
        memacc(read, rdadr,
               rwrd, rwwr, rwadr, randomRWvalue(NUMRWPT*WIDTH),
               write, wradr, randomWRvalue(NUMWRPT*WIDTH),
               cnt, ctadr, randomCTvalue(NUMCTPT*WIDTH),
               acrd, acwr, acadr, randomACvalue(NUMACPT*WIDTH),
               rurd, ruwr, ruadr, randomRUvalue(NUMRUPT*WIDTH),
               mawr, randomMAvalue(NUMMAPT*WIDTH),
               deq, dqadr,
               puwr, puadr, pudin,
               pord, poadr,
               sr, srkey,
               up, updel, upkey, randomUPvalue(NUMHUPT*DTWIDTH));
    end
    `TB_YAP("test_random completed") 
  end
endtask

task get_paddr;
input [BITADDR-1:0] addr;
output [BITPADR-1:0] paddr;
begin
  if (refr) cyc (1);
  if (NUMRDPT > 0) begin
    read_wire[0] = 1;
    rd_adr_wire[0] = addr;
  end else if (NUMRWPT > 0) begin
    rw_read_wire[0] = 1;
    rw_write_wire[0] = 0;
    rw_adr_wire[0] = addr;
  end else if (NUMACPT > 0) begin
    ac_read_wire[0] = 1;
    ac_write_wire[0] = 0;
    ac_adr_wire[0] = addr;
  end else if (NUMRUPT > 0) begin
    ru_read_wire[0] = 1;
    ru_write_wire[0] = 0;
    ru_adr_wire[0] = addr;
  end

  cyc (1);

  if (NUMRDPT > 0) 
    read_wire[0] = 0;
  else if (NUMRWPT > 0)
    rw_read_wire[0] = 0;
  else if (NUMACPT > 0)
    ac_read_wire[0] = 0;
  else if (NUMRUPT > 0)
    ru_read_wire[0] = 0;

  cyc (MEM_DELAY-1);

  #1;
  
  if (NUMRDPT > 0) 
    paddr = rd_padr;
  else if (NUMRWPT > 0)
    paddr = rw_padr;
  else if (NUMACPT > 0)
    paddr = ac_padr;
  else if (NUMRUPT > 0)
    paddr = ru_padr;

  `TB_YAP($psprintf("The physical address for logical address 0x%0h is 0x%0h", addr, paddr))
end
endtask

//MEMOIR_SHIP_OFF
`ifdef FUNC_ERR_TEST
task test_err_inj;
reg [BITADDR-1:0] l_addr;
reg [BITPADR-1:0] p_addr;
reg [BITVROW-1:0] r_addr1, r_addr2;
begin
  l_addr = {$random()} % DEPTH; // pick a logical address
  get_paddr (l_addr, p_addr); // get physical address from the logical address
  testbench_func.ip_top.get_raddr (p_addr, r_addr1); // get row address from the physical address
  testbench_func.ip_top.show_all_laddr (r_addr1); // for information only
  // creating a serr
  `TB_YAP($psprintf("injecting an 1-bit error on field 1 of row 0x%0x", r_addr1))
  testbench_func.ip_top.put_serr (1, r_addr1);

  r_addr2 = r_addr1;
  while (r_addr2 == r_addr1) begin
    l_addr = {$random()} % DEPTH; // pick another logical address
    get_paddr (l_addr, p_addr);
    testbench_func.ip_top.get_raddr (p_addr, r_addr2);
  end
  testbench_func.ip_top.show_all_laddr (r_addr2); // for information only
  // creating a derr
  `TB_YAP($psprintf ("injecting an 2-bit error on field 0 of row 0x%0x", r_addr2))
  testbench_func.ip_top.put_derr (0, r_addr2);
  test_read_all(); // this should get error indications on all addresses with error rows
  test_write_all(); // clear all errors; another test_real_all later should be clean
end
endtask
`endif

`ifdef BEH_ERR_TEST
task test_err_inj;
  reg err_type;
  integer err_mem_mask;
  begin
    err_type = {$random()} % 2; // either 0 or 1
    err_mem_mask = get_err_type(testbench_beh.ip_top.num_mem_types);
    `TB_YAP($psprintf ("injecting %0d-bit error on Type %b memories", (err_type + 1), err_mem_mask))
    testbench_beh.ip_top.err_type = err_type;
    testbench_beh.ip_top.err_mem_mask = err_mem_mask;
  end
endtask
`endif

`ifdef BEH_SERR_TEST
task test_err_inj;
  reg err_type;
  integer err_mem_mask;
  begin
    err_type = 0;
    err_mem_mask = get_err_type(testbench_beh.ip_top.num_mem_types);
    `TB_YAP($psprintf ("injecting %0d-bit error on Type %b memories", (err_type + 1), err_mem_mask))
    testbench_beh.ip_top.err_type = err_type;
    testbench_beh.ip_top.err_mem_mask = err_mem_mask;
  end
endtask
`endif

`ifdef BEH_DERR_TEST
task test_err_inj;
  reg err_type;
  integer err_mem_mask;
  begin
    err_type = 1;
    err_mem_mask = get_err_type(testbench_beh.ip_top.num_mem_types);
    `TB_YAP($psprintf("injecting %0d-bit error on Type %b memories", (err_type + 1), err_mem_mask))
    testbench_beh.ip_top.err_type = err_type;
    testbench_beh.ip_top.err_mem_mask = err_mem_mask;
  end
endtask
`endif

`ifdef BEH_SERR_ALL_TEST
task test_err_inj;
  reg err_type;
  integer err_mem_mask;
  begin
    err_type = 0;
    err_mem_mask = ~0;
    `TB_YAP($psprintf ("injecting %0d-bit error on Type %b memories", (err_type + 1), err_mem_mask))
    testbench_beh.ip_top.err_type = err_type;
    testbench_beh.ip_top.err_mem_mask = err_mem_mask;
  end
endtask
`endif

function integer get_err_type;
  input integer num_mem_types;
  integer type_id;
  begin
`ifdef ERR_T1 type_id=1;
`elsif ERR_T2 type_id=2;
`elsif ERR_T3 type_id=3;
`elsif ERR_T4 type_id=4;
`elsif ERR_T5 type_id=5;
`elsif ERR_T6 type_id=6;
`elsif ERR_T7 type_id=7;
`elsif ERR_T8 type_id=8;
`else type_id = ({$random()} % num_mem_types) + 1;
`endif
    get_err_type = 1 << (type_id -1);
  end
endfunction

`ifdef PADDR_CHECK
integer unique_padr_check_on = 0;
wire [BITADDR-1:0] rd_adr_wire_dly [0:NUMRDPT-1];
wire [BITADDR-1:0] rw_adr_wire_dly [0:NUMRWPT-1];
reg [0:NUMRDPT-1][BITADDR-1:0] rd_adr_wire_d [MEM_DELAY-1:0];
int bus_i;
reg [0:NUMRWPT-1][BITADDR-1:0] rw_adr_wire_d [MEM_DELAY-1:0];
reg valid [DEPTH-1:0];
reg [BITPADR-1:0] ref_paddr_hash [DEPTH-1:0];
reg valid_un [DEPTH-1:0];
reg [BITPADR-1:0] ref_paddr_hash_un [DEPTH-1:0];

always @(posedge clk) begin    
  for (int bus_i=0; bus_i<NUMRDPT; bus_i=bus_i+1)
    rd_adr_wire_d[0][bus_i]<=rd_adr_wire[bus_i];

  for (int dly_i = 1; dly_i < MEM_DELAY; dly_i=dly_i+1)
    for (int bus_i=0; bus_i<NUMRDPT; bus_i=bus_i+1)
      rd_adr_wire_d[dly_i][bus_i] <= rd_adr_wire_d[dly_i-1][bus_i];

  for (int bus_i=0; bus_i<NUMRWPT; bus_i=bus_i+1)
    rw_adr_wire_d[0][bus_i]<=rw_adr_wire[bus_i];

  for (int dly_i = 1; dly_i < MEM_DELAY; dly_i=dly_i+1)
    for (int bus_i=0; bus_i<NUMRWPT; bus_i=bus_i+1)
      rw_adr_wire_d[dly_i][bus_i] <= rw_adr_wire_d[dly_i-1][bus_i];
end

initial
  for(int i=0; i<DEPTH; i++)
    valid[i] = 0;

always @(posedge clk) begin
  for (bus_i=0; bus_i<NUMRDPT; bus_i=bus_i+1) begin
    if (rd_vld_wire[bus_i]) begin
      ;
//      if (valid[rd_adr_wire_d[MEM_DELAY-1][bus_i]]==1) begin
//        padr_last_bits_check_r: assert (ref_paddr_hash[rd_adr_wire_d[MEM_DELAY-1][bus_i]][BITVROW-1:0]==rd_padr_wire[bus_i][BITVROW-1:0])
//      end else begin
//        $error ("ERROR:the same addres %0b is mapped to both %0b and %0b physical addresses,lowest %0d bits of which do not match",rd_adr_wire_d[MEM_DELAY-1][bus_i],rd_padr_wire[bus_i],ref_paddr_hash[rd_adr_wire_d[MEM_DELAY-1][bus_i]],BITVROW);
//      end
    end else begin
      valid[rd_adr_wire_d[MEM_DELAY-1][bus_i]] = 1;    
      ref_paddr_hash[rd_adr_wire_d[MEM_DELAY-1][bus_i]] <= rd_padr_wire[bus_i];
    end
  end

  for (bus_i=0; bus_i<NUMRWPT; bus_i=bus_i+1) begin
    if (rw_vld_wire[bus_i]) begin
      ;
//      if (valid[rw_adr_wire_d[MEM_DELAY-1][bus_i]]==1)
//        padr_last_bits_check_rw: assert (ref_paddr_hash[rw_adr_wire_d[MEM_DELAY-1][bus_i]][BITVROW-1:0]==rw_padr_wire[bus_i][BITVROW-1:0]) 
//      else
//        $error ("ERROR:the same addres %0b is mapped to both %0b and %0b physical addresses,lowest %0d bits of which do not match",rw_adr_wire_d[MEM_DELAY-1][bus_i],rw_padr_wire[bus_i],ref_paddr_hash[rw_adr_wire_d[MEM_DELAY-1][bus_i]],BITVROW);
    end else begin
      valid[rw_adr_wire_d[MEM_DELAY-1][bus_i]] = 1;    
      ref_paddr_hash[rw_adr_wire_d[MEM_DELAY-1][bus_i]] <=rw_padr_wire[bus_i];
    end
  end
end

initial
  for(int i=0; i<DEPTH; i++)
    valid_un[i] = 0;

always @(posedge clk) begin
  for (bus_i=0; bus_i<NUMRDPT; bus_i=bus_i+1) begin
    if (rd_vld_wire[bus_i] && unique_padr_check_on)  begin
      for(int i=0;i<DEPTH;i=i+1) begin
        if(valid_un[i]==1)begin 
          if(ref_paddr_hash_un[i] == rd_padr_wire[bus_i])
            padr_unique_check_r:assert(i==rd_adr_wire_d[MEM_DELAY-1][bus_i]) 
          else begin 
            $error ("ERROR: the physical address %0b is mapped to two addresses %0b and %0b",ref_paddr_hash_un[i],i,rd_adr_wire_d[MEM_DELAY-1][bus_i]);
          end
        end
      end 
      if (valid_un[rd_adr_wire_d[MEM_DELAY-1][bus_i]]!=1) begin 
        valid_un[rd_adr_wire_d[MEM_DELAY-1][bus_i]]=1;
        ref_paddr_hash_un[rd_adr_wire_d[MEM_DELAY-1][bus_i]]=rd_padr_wire[bus_i];
      end
    end
  end

  for (bus_i=0; bus_i<NUMRWPT; bus_i=bus_i+1)   begin
    if (rw_vld_wire[bus_i] && unique_padr_check_on)  begin
      for(int i=0;i<DEPTH;i=i+1) begin
        if(valid_un[i]==1)begin 
          if(ref_paddr_hash_un[i] == rw_padr_wire[bus_i])
            padr_unique_check_rw:assert(i==rw_adr_wire_d[MEM_DELAY-1][bus_i])
          else begin 
            $error ("ERROR: the physical address %0b is mapped to two addresses %0b and %0b",ref_paddr_hash_un[i],i,rw_adr_wire_d[MEM_DELAY-1][bus_i]);
          end
        end
      end
      if (valid_un[rw_adr_wire_d[MEM_DELAY-1][bus_i]]!=1) begin  
        valid_un[rw_adr_wire_d[MEM_DELAY-1][bus_i]]=1;
        ref_paddr_hash_un[rw_adr_wire_d[MEM_DELAY-1][bus_i]]=rw_padr_wire[bus_i];
      end
    end
  end
end
`endif

task test_fast_init;
begin
  reg [WIDTH-1:0] rt_dout;
//SJ  testbench.ip_top.WriteTask(0, 8'hde, ~0);
//SJ  testbench.ip_top.ReadTask(0, rt_dout);
//SJ  $display ("ReadTask -> dout =  %x", rt_dout); 
end
endtask

//MEMOIR_SHIP_ON

initial begin
  reset;
  `TB_YAP("Running tests")
//  test_write_all();
    //test_write_seq_till_bp();
    //test_write_rand_till_bp();
    test_write_till_load(DEPTH);
    //test_delete_till_no_bp();
    test_search_all();
    test_hash_random();
    test_search_all();
    test_search_random();
`ifdef MEMOIR_FASTINIT_TEST test_fast_init(); `endif
`ifdef BEH_ERR_TEST  test_err_inj();`endif
`ifdef BEH_SERR_TEST  test_err_inj();`endif
`ifdef BEH_DERR_TEST  test_err_inj();`endif
`ifdef BEH_SERR_ALL_TEST  test_err_inj();`endif
 // test_random(DEPTH + 20000);
//MEMOIR_SHIP_OFF
`ifdef FUNC_ERR_TEST
  test_err_inj();
`endif
`ifdef PADDR_CHECK
  unique_padr_check_on=1;
  test_read_all();
  unique_padr_check_on=0;  
`endif
//MEMOIR_SHIP_ON
 //test_read_all();
  cyc (10);
`ifdef MEMOIR_DBG_TEST
  `TB_YAP("Running debug tests")
  //dbg_en = 1;
  //test_dbg_write_all();
  //test_dbg_read_all();
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

endmodule
