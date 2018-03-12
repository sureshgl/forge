/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_pxmqxs_cache_bdg_c2_top (

  clk, rst, ready, 
  
  s_creq_valid, s_creq_type, s_creq_attr, s_creq_size, s_creq_id, s_creq_addr, s_creq_rdstall, s_creq_wrstall,
  s_dreq_valid, s_dreq_id, s_dreq_data, s_dreq_attr, s_dreq_stall,
  s_rreq_valid, s_rreq_id, s_rreq_data, s_rreq_attr, s_rreq_stall,

  m_creq_valid, m_creq_type, m_creq_attr, m_creq_size, m_creq_id, m_creq_addr, m_creq_rdstall, m_creq_wrstall,
  m_dreq_valid, m_dreq_id, m_dreq_data, m_dreq_attr, m_dreq_stall,
  m_rreq_valid, m_rreq_id, m_rreq_data, m_rreq_attr, m_rreq_stall,

  t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
  t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,

  e_pf_empty, e_pf_oflw, e_uc_stall, e_cache_rd_hit,
  e_tgerr_vld, e_tgerr_bid, e_tgerr_idx,
  e_dterr_vld, e_dterr_bid, e_dterr_idx,
  e_l2err_vld,
  dbg_la_sqfifo_cnt  ,
  dbg_la_t3_readA  ,
  dbg_la_t3_writeA  ,
  dbg_la_t3_ucachA  ,
  dbg_la_t3_ucofstA  ,
  dbg_la_t3_ucsizeA  ,
  dbg_la_t3_sqinA  ,
  dbg_la_t3_addrA  ,
  dbg_la_sqfifo_vld ,
  dbg_la_sqfifo_prv ,
  dbg_la_sqfifo_rdv ,
  dbg_la_sqfifo_inv ,
  dbg_la_sqfifo_uch ,
  dbg_la_sqfifo_idx ,
  dbg_la_sqfifo_fil ,
  dbg_la_pf_stall,
  dbg_la_t3_stall,
  dbg_la_t3_block,
  dbg_la_l2uc_stall,
  dbg_la_vread,
  dbg_la_vinvld,
  dbg_la_vucach,
  dbg_la_vread_vld ,
  dbg_la_vread_hit ,
  dbg_la_vread_last,
  dbg_la_sqfifo_fbe,
  dbg_la_sqfifo_fbm,
  dbg_la_t3_attrA_wire,
  dbg_la_sqfifo_fnd ,
  dbg_la_sqfifo_fuc ,
  dbg_la_sqfifo_fsq ,
  dbg_la_sqfifo_deq ,
  dbg_la_sqfifo_dsl ,
  dbg_la_sqfifo_pop ,
  dbg_la_sqfifo_psl ,
  dbg_la_sqfifo_sdq ,
  dbg_la_sqfifo_ssl ,
  dbg_la_sqfifo_psl_help , 
  dbg_la_sqfifo_dsq_help,
  dbg_la_twrite_wire,
  dbg_la_twraddr_wire,
  dbg_la_dwrite_wire,
  dbg_la_dwraddr_wire,
  dbg_la_data_vld,
  dbg_la_dtag_vld,
  dbg_la_tg_rd_vld,
  dbg_la_dt_rd_vld,
  dbg_la_dvld_out,
  dbg_la_drty_out,
  dbg_la_dlru_out,
  dbg_la_vread_out, 
  dbg_la_vucach_out,
  dbg_la_vwrite_out,
  dbg_la_vflush_out,
  dbg_la_vfill_out,
  dbg_la_srdwr_out,
  dbg_la_vinvld_out,
  dbg_la_sqfifo_hit,
  dbg_la_sqfifo_htv,
  dbg_la_cache_hit,
  dbg_la_cache_map,
  dbg_la_cache_add,
  dbg_la_cache_evt,
  dbg_la_cache_emp,
  dbg_la_cache_drt,
  dbg_la_id_bsy,
  dbg_la_sreq_stall,
  dbg_la_sreq_bcnt,
  dbg_la_sreq_bbmp,
  dbg_la_sreq_vld,
  dbg_la_sreq_fid,
  dbg_la_sreq_map_vld,
  dbg_la_sreq_rid,
  dbg_la_spnd_frcnt,
  dbg_la_spnd_ack,
  dbg_la_rmap_0,
  dbg_la_rmap_rid_0,
  dbg_la_rmap_1,
  dbg_la_rmap_rid_1,
  dbg_la_mreq_fifo_full,
  dbg_la_mreq_fifo_empty,
  dbg_la_mreq_fifo_push,
  dbg_la_mreq_fifo_pop
 
);

parameter BITWDTH = 4;
parameter WIDTH   = 16;
parameter BYTWDTH = WIDTH/8;
parameter BITBYTS = 1;
parameter ENAPAR  = 0;
parameter ENAECC  = 0;
parameter ECCWDTH = 5;
parameter NUMRWPT = 1;
parameter BITADDR = 8;
parameter NUMADDR = 8;
parameter NUMVROW = 16; 
parameter BITVROW = 4;
parameter NUMVTAG = 16; 
parameter BITVTAG = 4;
parameter NUMWRDS = 4;
parameter BITWRDS = 2;
parameter SRAM_DELAY = 1;
parameter DRAM_DELAY = 2;
parameter FLOPECC = 0;
parameter FLOPCMD = 0;
parameter FLOPIN = 0;
parameter FLOPMEM = 0;
parameter FLOPOUT = 0;

parameter FIFOCNT = 16;
parameter BITFIFO = 4;

parameter NXTNOWR = 0;  // No naxi write
parameter NXTNOFL = 0;  // No naxi flush
parameter NXTNOIV = 0;  // No naxi invalidate

parameter BITXTYP = 3;
parameter BITXADR = BITADDR+BITBYTS;
parameter BITXSEQ = 4;
parameter BITXATR = 3;
parameter BITXSIZ = 8;
parameter NXWIDTH = 256;
parameter NXBTCNT = 1; // data beat count
parameter BITXDBT = 1; // data beat count bits

parameter BITCSTS = 48; // stats reg size

parameter NUMXMPT = 1;
parameter NUMXSPT = 1;

parameter BITSEQN = BITXSEQ;
parameter BITBEAT = BITXDBT;
parameter NUMBEAT = NXBTCNT;

parameter BITDTAG = BITADDR-BITVROW;
parameter BITTAGW = BITDTAG+BITWRDS+2;
parameter NUMTGBY = (NUMWRDS*BITTAGW >> 3) + ((NUMWRDS*BITTAGW) % 8 ? 1 : 0);
parameter TAGWDTH = ENAPAR ? (NUMWRDS*BITTAGW)+NUMTGBY : NUMWRDS*BITTAGW;
parameter NUMDTBY = (NUMWRDS*WIDTH >> 3) + (((NUMWRDS*WIDTH) % 8) ? 1 : 0);
parameter PHYWDTH = ENAPAR ? (NUMWRDS*WIDTH)+NUMDTBY : NUMWRDS*WIDTH;

parameter BITTGBY = 5;
parameter BITDTBY = 7; 
parameter NUMXSEQ = (1 << BITXSEQ);
output                               m_creq_valid;
output  [BITXTYP-1:0]                m_creq_type;
output  [BITXATR-1:0]                m_creq_attr;
output  [BITXSIZ-1:0]                m_creq_size;
output  [BITXSEQ-1:0]                m_creq_id;
output  [BITXADR-1:0]                m_creq_addr;
input                                m_creq_rdstall;
input                                m_creq_wrstall;

output                               m_dreq_valid;
output  [BITXSEQ-1:0]                m_dreq_id;
output  [NXWIDTH-1:0]                m_dreq_data;
output  [BITXATR-1:0]                m_dreq_attr;
input                                m_dreq_stall;

input                                m_rreq_valid;
input   [BITXSEQ-1:0]                m_rreq_id;
input   [NXWIDTH-1:0]                m_rreq_data;
input   [BITXATR-1:0]                m_rreq_attr;
output                               m_rreq_stall;

input                                s_creq_valid;
input   [BITXTYP-1:0]                s_creq_type;
input   [BITXATR-1:0]                s_creq_attr;
input   [BITXSIZ-1:0]                s_creq_size;
input   [BITXSEQ-1:0]                s_creq_id;
input   [BITXADR-1:0]                s_creq_addr;
output                               s_creq_rdstall;
output                               s_creq_wrstall;

input                                s_dreq_valid;
input   [BITXSEQ-1:0]                s_dreq_id;
input   [NXWIDTH-1:0]                s_dreq_data;
input   [BITXATR-1:0]                s_dreq_attr;
output                               s_dreq_stall;

output                               s_rreq_valid;
output  [BITXSEQ-1:0]                s_rreq_id;
output  [NXWIDTH-1:0]                s_rreq_data;
output  [BITXATR-1:0]                s_rreq_attr;
input                                s_rreq_stall;

output [NUMRWPT-1:0]                 t1_writeA;
output [NUMRWPT*BITVTAG-1:0]         t1_addrA;
output [NUMRWPT*TAGWDTH-1:0]         t1_dinA;
output [NUMRWPT-1:0]                 t1_readB;
output [NUMRWPT*BITVTAG-1:0]         t1_addrB;
input  [NUMRWPT*TAGWDTH-1:0]         t1_doutB;

output [NUMRWPT-1:0]                 t2_writeA;
output [NUMRWPT*BITVROW-1:0]         t2_addrA;
output [NUMRWPT*PHYWDTH-1:0]         t2_dinA;
output [NUMRWPT-1:0]                 t2_readB;
output [NUMRWPT*BITVROW-1:0]         t2_addrB;
input  [NUMRWPT*PHYWDTH-1:0]         t2_doutB;

output                               e_pf_empty;
output                               e_pf_oflw;
output                               e_uc_stall;
output                               e_cache_rd_hit;
output                               e_tgerr_vld;
output [BITTGBY-1:0]                 e_tgerr_bid;
output [BITVTAG-1:0]                 e_tgerr_idx;
output                               e_dterr_vld;
output [BITDTBY-1:0]                 e_dterr_bid;
output [BITVROW-1:0]                 e_dterr_idx;
output                               e_l2err_vld;

output                               ready;
input                                clk;
input                                rst;

  output [BITFIFO:0]dbg_la_sqfifo_cnt  ;
  output dbg_la_t3_readA  ;
  output dbg_la_t3_writeA  ;
  output dbg_la_t3_ucachA  ;
  output [NUMRWPT*BITBYTS-1:0]dbg_la_t3_ucofstA  ;
  output [NUMRWPT*BITXSIZ-1:0]dbg_la_t3_ucsizeA  ;
  output [NUMRWPT*BITSEQN-1:0]dbg_la_t3_sqinA  ;
  output [NUMRWPT*BITADDR-1:0]dbg_la_t3_addrA  ;
  output [FIFOCNT-1:0]dbg_la_sqfifo_vld ;
  output [FIFOCNT-1:0]dbg_la_sqfifo_prv ;
  output [FIFOCNT-1:0]dbg_la_sqfifo_rdv ;
  output [FIFOCNT-1:0]dbg_la_sqfifo_inv ;
  output [FIFOCNT-1:0]dbg_la_sqfifo_uch ;
  output [FIFOCNT-1:0]dbg_la_sqfifo_idx ;
  output [FIFOCNT-1:0]dbg_la_sqfifo_fil ;
  output dbg_la_pf_stall;
  output dbg_la_t3_stall;
  output dbg_la_t3_block;
  output dbg_la_l2uc_stall ;
  output dbg_la_vread;
  output dbg_la_vinvld;
  output dbg_la_vucach;
  output dbg_la_vread_vld ;
  output dbg_la_vread_hit ;
  output dbg_la_vread_last;
  output [BITBEAT-1:0] dbg_la_sqfifo_fbe;
  output [NUMBEAT-1:0] dbg_la_sqfifo_fbm;
  output [BITXATR-1:0] dbg_la_t3_attrA_wire;
  output         dbg_la_sqfifo_fnd ;
  output         dbg_la_sqfifo_fuc ;
  output [BITSEQN-1:0] dbg_la_sqfifo_fsq ;
  output         dbg_la_sqfifo_deq ;
  output [BITFIFO-1:0] dbg_la_sqfifo_dsl ;
  output         dbg_la_sqfifo_pop ;
  output [BITFIFO-1:0] dbg_la_sqfifo_psl ;
  output         dbg_la_sqfifo_sdq ;
  output [BITFIFO-1:0] dbg_la_sqfifo_ssl ;
  output [BITSEQN-1:0] dbg_la_sqfifo_psl_help ; 
  output [BITSEQN-1:0] dbg_la_sqfifo_dsq_help;
  output dbg_la_twrite_wire;
  output [BITVTAG-1:0] dbg_la_twraddr_wire;
  output dbg_la_dwrite_wire;
  output [BITVROW-1:0] dbg_la_dwraddr_wire;
  output dbg_la_data_vld;
  output dbg_la_dtag_vld;
  output dbg_la_tg_rd_vld;
  output dbg_la_dt_rd_vld;
  output [NUMWRDS-1:0]dbg_la_dvld_out;
  output [NUMWRDS-1:0]dbg_la_drty_out;
  output [NUMWRDS*BITWRDS-1:0]dbg_la_dlru_out;
  output dbg_la_vread_out; 
  output dbg_la_vucach_out;
  output dbg_la_vwrite_out;
  output dbg_la_vflush_out;
  output dbg_la_vfill_out;
  output dbg_la_srdwr_out;
  output dbg_la_vinvld_out;
  output dbg_la_sqfifo_hit;
  output dbg_la_sqfifo_htv;
  output dbg_la_cache_hit;
  output [BITWRDS-1:0]dbg_la_cache_map;
  output dbg_la_cache_add;
  output dbg_la_cache_evt;
  output [BITWRDS-1:0]dbg_la_cache_emp;
  output [BITWRDS-1:0]dbg_la_cache_drt;
  output [NUMXSEQ-1:0]                 dbg_la_id_bsy;
  output                               dbg_la_sreq_stall;
  output [BITXDBT:0]                   dbg_la_sreq_bcnt;
  output [NXBTCNT-1:0]                 dbg_la_sreq_bbmp;
  output                               dbg_la_sreq_vld;
  output [BITXSEQ-1:0]                 dbg_la_sreq_fid;
  output                               dbg_la_sreq_map_vld;
  output [BITXSEQ-1:0]                 dbg_la_sreq_rid;
  output [BITXSEQ:0]                   dbg_la_spnd_frcnt;
  output [NUMXSEQ-1:0]                 dbg_la_spnd_ack;
  output                               dbg_la_rmap_0;
  output [BITXSEQ-1:0]                 dbg_la_rmap_rid_0;
  output dbg_la_rmap_1;
  output [BITXSEQ-1:0]dbg_la_rmap_rid_1;
  output dbg_la_mreq_fifo_full;
  output dbg_la_mreq_fifo_empty;
  output dbg_la_mreq_fifo_push;
  output dbg_la_mreq_fifo_pop;
 
wire [NUMRWPT*NUMWRDS*BITTAGW-1:0]   t1_dinA_a2;
wire [NUMRWPT*NUMWRDS*BITTAGW-1:0]   t1_doutB_a2;
wire                                 t1_serrB_a2;
wire [BITTGBY-1:0]                   t1_bidB_a2;

wire [NUMRWPT*NUMWRDS*WIDTH-1:0]     t2_dinA_a2;
wire [NUMRWPT*NUMWRDS*WIDTH-1:0]     t2_doutB_a2;
wire                                 t2_serrB_a2;
wire [BITDTBY-1:0]                   t2_bidB_a2;

`ifdef FORMAL
  wire [BITADDR-1:0] select_addr;
  wire [BITWDTH-1:0] select_bit;
  assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < (1<<BITADDR)));
  assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
  assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
  assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

  wire [BITVROW-1:0] select_vrow = select_addr;
`else
  wire [BITADDR-1:0] select_addr = 0;
  wire [BITWDTH-1:0] select_bit = 0;
  wire [BITVROW-1:0] select_vrow = 0;
`endif

wire pf_stall_a2;
wire t3_stall_a2;
wire ready_a1;
wire ready_a2;
assign ready = ready_a2 && ready_a1;

wire t1_stallA_a1 = !ready_a2 || pf_stall_a2;
wire t2_stallA_a1 = !ready_a2 || t3_stall_a2;

wire    [NUMRWPT-1:0]                t1_readA_a1;
wire    [NUMRWPT-1:0]                t1_writeA_a1;
wire    [NUMRWPT-1:0]                t1_flushA_a1;
wire    [NUMRWPT-1:0]                t1_invldA_a1;
wire    [NUMRWPT-1:0]                t1_sidxA_a1;
wire    [NUMRWPT-1:0]                t1_fldrtA_a1;
wire    [NUMRWPT-1:0]                t1_ucachA_a1;
wire    [NUMRWPT*BITBYTS-1:0]        t1_ucofstA_a1;
wire    [NUMRWPT*BITXSIZ-1:0]        t1_ucsizeA_a1;
wire    [NUMRWPT*BITSEQN-1:0]        t1_sqinA_a1;
wire    [NUMRWPT*BITADDR-1:0]        t1_addrA_a1;
wire    [NUMRWPT*BYTWDTH-1:0]        t1_byinA_a1;
wire    [NUMRWPT*WIDTH-1:0]          t1_dinA_a1;
wire    [NUMRWPT*NUMBEAT-1:0]        t1_bbmpA_a1;
wire    [NUMRWPT-1:0]                t1_rd_vldA_a1;
wire    [NUMRWPT-1:0]                t1_rd_hitA_a1;
wire    [NUMRWPT*BITSEQN-1:0]        t1_rd_sqoutA_a1;
wire    [NUMRWPT*WIDTH-1:0]          t1_rd_doutA_a1;
wire    [NUMRWPT-1:0]                t1_rd_serrA_a1;
wire    [NUMRWPT-1:0]                t1_rd_lastA_a1;
wire    [NUMRWPT*BITXATR-1:0]        t1_rd_attrA_a1;

wire    [NUMRWPT-1:0]                t2_readA_a1;
wire    [NUMRWPT-1:0]                t2_writeA_a1  = {NUMRWPT{1'b0}};
wire    [NUMRWPT-1:0]                t2_ucachA_a1;
wire    [NUMRWPT*BITBYTS-1:0]        t2_ucofstA_a1;
wire    [NUMRWPT*BITXSIZ-1:0]        t2_ucsizeA_a1;
wire    [NUMRWPT*BITXATR-1:0]        t2_attrA_a1;
wire    [NUMRWPT*BITSEQN-1:0]        t2_sqinA_a1;
wire    [NUMRWPT*BITADDR-1:0]        t2_addrA_a1;
wire    [NUMRWPT*WIDTH-1:0]          t2_dinA_a1 = {(NUMRWPT*WIDTH){1'b0}};
wire    [NUMRWPT-1:0]                t2_vldA_a1;
wire    [NUMRWPT*BITSEQN-1:0]        t2_sqoutA_a1;
wire    [NUMRWPT*WIDTH-1:0]          t2_doutA_a1;
wire                                 t2_block_a1;
 

generate if (1) begin : a1_loop
  algo_pxmqxs_cache_1rw_mb #(
    .BITWDTH   (BITWDTH    ), .WIDTH     (WIDTH      ), .BYTWDTH   (BYTWDTH    ), .BITBYTS   (BITBYTS    ), .NUMRWPT   (NUMRWPT    ),
    .BITADDR   (BITADDR    ), .NUMVROW   (NUMVROW    ), .BITVROW   (BITVROW    ), .NUMWRDS   (NUMWRDS    ),
    .BITWRDS   (BITWRDS    ), .SRAM_DELAY(SRAM_DELAY ), .DRAM_DELAY(DRAM_DELAY ), .FLOPIN    (FLOPIN     ), .FLOPOUT   (FLOPOUT    ),
    .FIFOCNT   (FIFOCNT    ), .BITFIFO   (BITFIFO    ), 
    .BITXTYP   (BITXTYP    ), .BITXADR   (BITXADR    ), .BITXSEQ   (BITXSEQ    ), .BITXATR   (BITXATR    ), .BITXSIZ   (BITXSIZ    ), 
    .NXWIDTH   (NXWIDTH    ), .NXBTCNT   (NXBTCNT    ), .BITXDBT   (BITXDBT    ), .NUMXMPT   (NUMXMPT    ), .NUMXSPT   (NUMXSPT    ),
    .NXTNOWR     (NXTNOWR     ), .NXTNOFL     (NXTNOFL     ), .NXTNOIV     (NXTNOIV))
   algo (
      .s_creq_valid(s_creq_valid), .s_creq_type(s_creq_type), .s_creq_attr(s_creq_attr), .s_creq_size(s_creq_size), .s_creq_id(s_creq_id), 
      .s_creq_addr(s_creq_addr), .s_creq_rdstall(s_creq_rdstall), .s_creq_wrstall(s_creq_wrstall),
      .s_dreq_valid(s_dreq_valid), .s_dreq_id(s_dreq_id), .s_dreq_data(s_dreq_data), .s_dreq_attr(s_dreq_attr), .s_dreq_stall(s_dreq_stall),
      .s_rreq_valid(s_rreq_valid), .s_rreq_id(s_rreq_id), .s_rreq_data(s_rreq_data), .s_rreq_attr(s_rreq_attr), .s_rreq_stall(s_rreq_stall),

      .m_creq_valid(m_creq_valid), .m_creq_type(m_creq_type), .m_creq_attr(m_creq_attr), .m_creq_size(m_creq_size), .m_creq_id(m_creq_id), 
      .m_creq_addr(m_creq_addr), .m_creq_rdstall(m_creq_rdstall), .m_creq_wrstall(m_creq_wrstall),
      .m_dreq_valid(m_dreq_valid), .m_dreq_id(m_dreq_id), .m_dreq_data(m_dreq_data), .m_dreq_attr(m_dreq_attr), .m_dreq_stall(m_dreq_stall),
      .m_rreq_valid(m_rreq_valid), .m_rreq_id(m_rreq_id), .m_rreq_data(m_rreq_data), .m_rreq_attr(m_rreq_attr), .m_rreq_stall(m_rreq_stall),

      .t1_readA(t1_readA_a1), .t1_writeA(t1_writeA_a1), .t1_flushA(t1_flushA_a1), .t1_invldA(t1_invldA_a1), .t1_sidxA(t1_sidxA_a1), .t1_fldrtA(t1_fldrtA_a1), 
      .t1_ucachA(t1_ucachA_a1), .t1_ucofstA (t1_ucofstA_a1), .t1_ucsizeA (t1_ucsizeA_a1),
      .t1_sqinA(t1_sqinA_a1), .t1_addrA(t1_addrA_a1), .t1_byinA(t1_byinA_a1), .t1_dinA(t1_dinA_a1), .t1_bbmpA(t1_bbmpA_a1),
      .t1_rd_vldA(t1_rd_vldA_a1), .t1_rd_hitA(t1_rd_hitA_a1), .t1_rd_sqoutA(t1_rd_sqoutA_a1), .t1_rd_doutA(t1_rd_doutA_a1), .t1_stallA(t1_stallA_a1), .t1_rd_serrA (t1_rd_serrA_a1), .t1_rd_lastA(t1_rd_lastA_a1), .t1_rd_attrA(t1_rd_attrA_a1),

      .t2_readA(t2_readA_a1), .t2_writeA(t2_writeA_a1), .t2_ucachA(t2_ucachA_a1), .t2_ucofstA (t2_ucofstA_a1), .t2_ucsizeA (t2_ucsizeA_a1), .t2_sqinA(t2_sqinA_a1), .t2_addrA(t2_addrA_a1), .t2_dinA(t2_dinA_a1), 
      .t2_vldA(t2_vldA_a1), .t2_sqoutA(t2_sqoutA_a1), .t2_doutA(t2_doutA_a1), .t2_attrA(t2_attrA_a1), .t2_stallA(t2_stallA_a1), .t2_blockA(t2_block_a1),

      .e_l2err_vld(e_l2err_vld),

      .ready(ready_a1), .clk(clk),.rst(rst),
      .dbg_la_id_bsy(dbg_la_id_bsy),
      .dbg_la_sreq_stall(dbg_la_sreq_stall),
      .dbg_la_sreq_bcnt(dbg_la_sreq_bcnt),
      .dbg_la_sreq_bbmp(dbg_la_sreq_bbmp),
      .dbg_la_sreq_vld(dbg_la_sreq_vld),
      .dbg_la_sreq_fid(dbg_la_sreq_fid),
      .dbg_la_sreq_map_vld(dbg_la_sreq_map_vld),
      .dbg_la_sreq_rid(dbg_la_sreq_rid),
      .dbg_la_spnd_frcnt(dbg_la_spnd_frcnt),
      .dbg_la_spnd_ack(dbg_la_spnd_ack),
      .dbg_la_rmap_0(dbg_la_rmap_0),
      .dbg_la_rmap_rid_0(dbg_la_rmap_rid_0),
      .dbg_la_rmap_1(dbg_la_rmap_1),
      .dbg_la_rmap_rid_1(dbg_la_rmap_rid_1),
      .dbg_la_mreq_fifo_full(dbg_la_mreq_fifo_full),
      .dbg_la_mreq_fifo_empty(dbg_la_mreq_fifo_empty),
      .dbg_la_mreq_fifo_push(dbg_la_mreq_fifo_push),
      .dbg_la_mreq_fifo_pop(dbg_la_mreq_fifo_pop) 
    );
end
endgenerate

generate if (1) begin: a2_loop

  algo_nrw_cache_1r1w_mb2 #(
    .BITWDTH (BITWDTH), .WIDTH (WIDTH), .NUMRWPT (NUMRWPT), .BITADDR (BITADDR),
    .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS),
    .BITBEAT (BITBEAT), .NUMBEAT (NUMBEAT), .BITSEQN (BITSEQN), .NUMSEQN(1<<BITSEQN),
    .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT),
    .FIFOCNT   (FIFOCNT    ), .BITFIFO   (BITFIFO    ), .BITUOFS (BITBYTS), .BITUSIZ (BITXSIZ),
    .BITXATR(BITXATR), 
    .NUMTGBY     (NUMTGBY     ), .NUMDTBY     (NUMDTBY     ), .BITTGBY     (BITTGBY     ), .BITDTBY     (BITDTBY     ))
    algo (.clk(clk), .rst(rst), .ready(ready_a2),
      .read(t1_readA_a1), .invld(t1_invldA_a1), .sidx(t1_sidxA_a1), .ucach(t1_ucachA_a1), .ucofst (t1_ucofstA_a1), .ucsize(t1_ucsizeA_a1),
      .sqin(t1_sqinA_a1), .addr(t1_addrA_a1), .bbmp(t1_bbmpA_a1),
      .pf_stall(pf_stall_a2), 
      .rd_vld(t1_rd_vldA_a1), .rd_hit(t1_rd_hitA_a1), .rd_sqout(t1_rd_sqoutA_a1), .rd_dout(t1_rd_doutA_a1), .rd_serr(t1_rd_serrA_a1), .rd_last(t1_rd_lastA_a1), .rd_attr(t1_rd_attrA_a1),
      .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA_a2), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB_a2), .t1_serrB(t1_serrB_a2), .t1_bidB(t1_bidB_a2),
      .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA_a2), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB_a2), .t2_serrB(t2_serrB_a2), .t2_bidB(t2_bidB_a2),
      .t3_readA(t2_readA_a1), .t3_ucachA(t2_ucachA_a1), .t3_ucofstA(t2_ucofstA_a1), .t3_ucsizeA(t2_ucsizeA_a1), .t3_sqinA(t2_sqinA_a1), .t3_addrA(t2_addrA_a1), 
      .t3_vldA(t2_vldA_a1), .t3_sqoutA(t2_sqoutA_a1), .t3_doutA(t2_doutA_a1), .t3_attrA(t2_attrA_a1), .t3_stall(t3_stall_a2), .t3_block(t2_block_a1), 
      .e_pf_empty (e_pf_empty ), .e_pf_oflw  (e_pf_oflw), .e_uc_stall (e_uc_stall), .e_cache_rd_hit(e_cache_rd_hit),
      .e_tgerr_vld(e_tgerr_vld), .e_tgerr_bid(e_tgerr_bid), .e_tgerr_idx(e_tgerr_idx),
      .e_dterr_vld(e_dterr_vld), .e_dterr_bid(e_dterr_bid), .e_dterr_idx(e_dterr_idx),
      .select_addr(select_addr), .select_bit(select_bit),
      .dbg_la_sqfifo_cnt(dbg_la_sqfifo_cnt),
      .dbg_la_t3_readA(dbg_la_t3_readA),
      .dbg_la_t3_writeA (dbg_la_t3_writeA),
      .dbg_la_t3_ucachA (dbg_la_t3_ucachA),
      .dbg_la_t3_ucofstA(dbg_la_t3_ucofstA),
      .dbg_la_t3_ucsizeA(dbg_la_t3_ucsizeA),
      .dbg_la_t3_sqinA(dbg_la_t3_sqinA),
      .dbg_la_t3_addrA(dbg_la_t3_addrA),
      .dbg_la_sqfifo_vld(dbg_la_sqfifo_vld),
      .dbg_la_sqfifo_prv(dbg_la_sqfifo_prv),
      .dbg_la_sqfifo_rdv(dbg_la_sqfifo_rdv),
      .dbg_la_sqfifo_inv(dbg_la_sqfifo_inv),
      .dbg_la_sqfifo_uch(dbg_la_sqfifo_uch),
      .dbg_la_sqfifo_idx(dbg_la_sqfifo_idx),
      .dbg_la_sqfifo_fil(dbg_la_sqfifo_fil),
      .dbg_la_pf_stall(dbg_la_pf_stall),
      .dbg_la_t3_stall(dbg_la_t3_stall),
      .dbg_la_t3_block(dbg_la_t3_block),
      .dbg_la_l2uc_stall(dbg_la_l2uc_stall),
      .dbg_la_vread(dbg_la_vread),
      .dbg_la_vinvld(dbg_la_vinvld),
      .dbg_la_vucach(dbg_la_vucach),
      .dbg_la_vread_vld(dbg_la_vread_vld),
      .dbg_la_vread_hit(dbg_la_vread_hit),
      .dbg_la_vread_last(dbg_la_vread_last),
      .dbg_la_sqfifo_fbe(dbg_la_sqfifo_fbe),
      .dbg_la_sqfifo_fbm(dbg_la_sqfifo_fbm),
      .dbg_la_t3_attrA_wire(dbg_la_t3_attrA_wire),
      .dbg_la_sqfifo_fnd(dbg_la_sqfifo_fnd),
      .dbg_la_sqfifo_fuc(dbg_la_sqfifo_fuc),
      .dbg_la_sqfifo_fsq(dbg_la_sqfifo_fsq),
      .dbg_la_sqfifo_deq(dbg_la_sqfifo_deq),
      .dbg_la_sqfifo_dsl(dbg_la_sqfifo_dsl),
      .dbg_la_sqfifo_pop(dbg_la_sqfifo_pop),
      .dbg_la_sqfifo_psl(dbg_la_sqfifo_psl),
      .dbg_la_sqfifo_sdq(dbg_la_sqfifo_sdq),
      .dbg_la_sqfifo_ssl(dbg_la_sqfifo_ssl),
      .dbg_la_sqfifo_psl_help(dbg_la_sqfifo_psl_help),
      .dbg_la_sqfifo_dsq_help(dbg_la_sqfifo_dsq_help),
      .dbg_la_twrite_wire(dbg_la_twrite_wire),
      .dbg_la_twraddr_wire(dbg_la_twraddr_wire),
      .dbg_la_dwrite_wire(dbg_la_dwrite_wire),
      .dbg_la_dwraddr_wire(dbg_la_dwraddr_wire),
      .dbg_la_data_vld(dbg_la_data_vld),
      .dbg_la_dtag_vld(dbg_la_dtag_vld),
      .dbg_la_tg_rd_vld(dbg_la_tg_rd_vld),
      .dbg_la_dt_rd_vld(dbg_la_dt_rd_vld),
      .dbg_la_dvld_out(dbg_la_dvld_out),
      .dbg_la_drty_out(dbg_la_drty_out),
      .dbg_la_dlru_out(dbg_la_dlru_out),
      .dbg_la_vread_out(dbg_la_vread_out), 
      .dbg_la_vucach_out(dbg_la_vucach_out),
      .dbg_la_vwrite_out(dbg_la_vwrite_out),
      .dbg_la_vflush_out(dbg_la_vflush_out),
      .dbg_la_vfill_out(dbg_la_vfill_out),
      .dbg_la_srdwr_out(dbg_la_srdwr_out),
      .dbg_la_vinvld_out(dbg_la_vinvld_out),
      .dbg_la_sqfifo_hit(dbg_la_sqfifo_hit),
      .dbg_la_sqfifo_htv(dbg_la_sqfifo_htv),
      .dbg_la_cache_hit(dbg_la_cache_hit),
      .dbg_la_cache_map(dbg_la_cache_map),
      .dbg_la_cache_add(dbg_la_cache_add),
      .dbg_la_cache_evt(dbg_la_cache_evt),
      .dbg_la_cache_emp(dbg_la_cache_emp),
      .dbg_la_cache_drt(dbg_la_cache_drt)

    );


  if (ENAPAR) begin: pgc

    reg [TAGWDTH-1:0] t1_dinA_tmp;
    always_comb begin :t1_pgen
      reg [9-1:0] dwp;
      integer pb;
      t1_dinA_tmp = {TAGWDTH{1'b0}};
      for (integer i=0;i<NUMTGBY;i++) begin
        pb = (TAGWDTH-(i*9)) > 8 ? 8 : TAGWDTH-(i*9)-1;
        dwp = 9'h0;
        dwp[7:0] = t1_dinA_a2 >> i*8;
        dwp[pb]   = ^dwp[7:0];
        t1_dinA_tmp = t1_dinA_tmp | (dwp << i*9);
      end
    end
    assign t1_dinA = t1_dinA_tmp;

    reg [(NUMWRDS*BITTAGW)-1:0] t1_doutB_tmp; 
    reg                         t1_serrB_tmp;
    reg [BITTGBY-1:0]           t1_bidB_tmp;
    always_comb begin: t1_pchk
      reg [9-1:0] dwp;
      t1_doutB_tmp = {(NUMWRDS*BITTAGW){1'b0}};
      t1_serrB_tmp = 0;
      t1_bidB_tmp = 0;
      for (integer i=0;i<NUMTGBY;i++) begin
        dwp = 9'h0;
        dwp = t1_doutB >> i*9;
        if (^dwp)
          t1_bidB_tmp = i;
        t1_serrB_tmp = t1_serrB_tmp | ^dwp;
        t1_doutB_tmp = t1_doutB_tmp | (dwp[7:0] << i*8);
      end
    end
    assign t1_doutB_a2 = t1_doutB_tmp;
    assign t1_serrB_a2 = t1_serrB_tmp; 
    assign t1_bidB_a2  = t1_bidB_tmp;

    reg [PHYWDTH-1:0] t2_dinA_tmp;
    always_comb begin :t2_pgen
      reg [9-1:0] dwp;
      t2_dinA_tmp = {PHYWDTH{1'b0}};
      for (integer i=0;i<NUMDTBY;i++) begin
        dwp = 9'h0;
        dwp[7:0] = t2_dinA_a2 >> i*8;
        dwp[8]   = ^dwp[7:0];
        t2_dinA_tmp = t2_dinA_tmp | (dwp << i*9);
      end
    end
    assign t2_dinA = t2_dinA_tmp;

    reg [(NUMWRDS*WIDTH)-1:0] t2_doutB_tmp; 
    reg                       t2_serrB_tmp;
    reg [BITDTBY-1:0]         t2_bidB_tmp;
    always_comb begin: t2_pchk
      reg [9-1:0] dwp;
      t2_doutB_tmp = {(NUMWRDS*WIDTH){1'b0}};
      t2_serrB_tmp = 0;
      t2_bidB_tmp = 0;
      for (integer i=0;i<NUMDTBY;i++) begin
        dwp = 9'h0;
        dwp = t2_doutB >> i*9;
        if (^dwp)
          t2_bidB_tmp = i;
        t2_serrB_tmp = t2_serrB_tmp | ^dwp;
        t2_doutB_tmp = t2_doutB_tmp | (dwp[7:0] << i*8);
      end
    end
    assign t2_doutB_a2 = t2_doutB_tmp;
    assign t2_serrB_a2 = t2_serrB_tmp;
    assign t2_bidB_a2  = t2_bidB_tmp;

  end else begin
    assign t1_dinA = t1_dinA_a2;
    assign t1_doutB_a2 = t1_doutB;
    assign t1_serrB_a2 = 1'b0;
    assign t2_dinA  = t2_dinA_a2;
    assign t2_doutB_a2 = t2_doutB;
    assign t2_serrB_a2 = 1'b0;
  end
end
endgenerate

endmodule // algo_pxmqxs_cache_bdg_c2_top

