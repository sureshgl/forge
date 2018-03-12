module algo_1xm1xs_bdg_c4_top_wrap #(
  parameter IP_WIDTH = 256, parameter IP_BITWIDTH = 8, parameter IP_NUMADDR = 512, parameter IP_BITADDR = 9, parameter IP_NUMVBNK = 4, parameter IP_ENAPAR = 0,
  parameter IP_BITVBNK = 2, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, parameter IP_BITPBNK = 1, parameter T1_WIDTH = 104, 
  parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 0, parameter T1_DELAY = 1, parameter T1_NUMVROW = 128, parameter T1_BITVROW = 7,
  parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 0, parameter T1_NUMSROW = 128, parameter T1_BITSROW = 7, parameter T1_PHYWDTH = 104,
  parameter T2_WIDTH = 256, parameter T2_NUMVBNK = 4, parameter T2_BITVBNK = 2, parameter T2_DELAY = 1, parameter T2_NUMVROW = 128, parameter T2_BITVROW = 7,
  parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 128, parameter T2_BITSROW = 7, parameter T2_PHYWDTH = 256)
  (
    clk, rst, ready,
  
    s_creq_valid, s_creq_type, s_creq_attr, s_creq_size, s_creq_id, s_creq_addr, s_creq_rdstall, s_creq_wrstall,
    s_dreq_valid, s_dreq_id, s_dreq_data, s_dreq_attr, s_dreq_stall,
    s_rreq_valid, s_rreq_id, s_rreq_data, s_rreq_attr, s_rreq_stall,

    m_creq_valid, m_creq_type, m_creq_attr, m_creq_size, m_creq_id, m_creq_addr, m_creq_rdstall, m_creq_wrstall,
    m_dreq_valid, m_dreq_id, m_dreq_data, m_dreq_attr, m_dreq_stall,
    m_rreq_valid, m_rreq_id, m_rreq_data, m_rreq_attr, m_rreq_stall,

    t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_readB, t1_addrB, t1_doutB,
    t2_writeA, t2_addrA, t2_dinA, t2_bwA, t2_readB, t2_addrB, t2_doutB,

    e_pf_empty, e_pf_oflw, e_uc_stall, e_cache_rd_hit, e_cache_wr_hit,
    e_tgerr_vld, e_tgerr_bid, e_tgerr_idx,
    e_dterr_vld, e_dterr_bid, e_dterr_idx,
    e_l2err_vld,
  dbg_la_pf_stall,
  dbg_la_t3_block,
  dbg_la_sqfifo_cnt,
  dbg_la_sqfifo_fnd,
  dbg_la_sqfifo_fuc,
  dbg_la_sqfifo_fsq,
  dbg_la_sqfifo_pop,
  dbg_la_sqfifo_deq,
  dbg_la_sqfifo_dsl,
  dbg_la_sqfifo_psl,
  dbg_la_sqfifo_ssl,
  dbg_la_sqfifo_sdq,
  dbg_la_sqfifo_psl_help,
  dbg_la_sqfifo_dsq_help,
  dbg_la_vread_vld,
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
  dbg_la_vsidx_out,
  dbg_la_sqfifo_hit,
  dbg_la_sqfifo_htv,
  dbg_la_sqfifo_hsq,
  dbg_la_cache_hit,
  dbg_la_cache_map,
  dbg_la_cache_add,
  dbg_la_cache_evt,
  dbg_la_cache_emp,
  dbg_la_sqfifo_vld,
  dbg_la_sqfifo_prv,
  dbg_la_sqfifo_rdv,
  dbg_la_sqfifo_wrv,
  dbg_la_sqfifo_flv,
  dbg_la_sqfifo_inv,
  dbg_la_sqfifo_uch,
  dbg_la_sqfifo_idx,
  dbg_la_sqfifo_fil,
  dbg_la_id_bsy,
  dbg_la_sreq_stall,
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
  dbg_la_late_retire,
  dbg_la_mreq_fifo_full,
  dbg_la_mreq_fifo_empty,
  dbg_la_mreq_fifo_push,
  dbg_la_ucach_wack_reg
  ); 

  parameter BITWDTH = IP_BITWIDTH;
  parameter WIDTH = IP_WIDTH;
  parameter BYTWDTH = WIDTH/8;
  parameter BITBYTS = BITWDTH - 3;
  parameter ENAPAR = 1;
  parameter ENAECC = 0;
  parameter ECCWDTH = 5;
  parameter NUMRWPT = 1;
  parameter NUMADDR = (1 << (34-BITBYTS));
  parameter BITADDR = 34-BITBYTS;
  parameter BITUCPF = 0;
  parameter NUMVROW = T1_NUMVROW; 
  parameter BITVROW = T1_BITVROW;
  parameter NUMWRDS = 4;
  parameter BITWRDS = 2;
  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 2;
  parameter FLOPECC = 0;
  parameter FLOPCMD = 0;
  parameter FLOPIN = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;

  parameter BITDTAG = BITADDR-BITVROW;
  parameter BITTAGW = BITDTAG+BITWRDS+2;
  parameter NUMTGBY = (NUMWRDS*BITTAGW >> 3) + ((NUMWRDS*BITTAGW) % 8 ? 1 : 0);
  parameter TAGWDTH = ENAPAR ? (NUMWRDS*BITTAGW)+NUMTGBY : NUMWRDS*BITTAGW;
  parameter NUMDTBY = (NUMWRDS*WIDTH >> 3) + (((NUMWRDS*WIDTH) % 8) ? 1 : 0);
  parameter PHYWDTH = ENAPAR ? (NUMWRDS*WIDTH)+NUMDTBY : NUMWRDS*WIDTH;

  parameter BITTGBY = 4;
  parameter BITDTBY = 7;

  parameter FIFOCNT = 8;
  parameter BITFIFO = 3;

  parameter BITXTYP = 3;
  parameter BITXADR = BITUCPF+BITADDR+BITBYTS;
  parameter BITXATR = 3;
  parameter BITXSIZ = 8;
  parameter BITXSEQ = 5;
  parameter NXWIDTH = 256;
  parameter NXBTCNT = 1; // data beat count
  parameter BITXDBT = 0; // data beat count bits

  parameter BITCSTS = 48; // stats reg size

  parameter NUMXMPT = 1;
  parameter NUMXSPT = 1;
  parameter NXTNOWR = 0;  // disable naxi write
  parameter NXTNOFL = 0;  // disable naxi flush
  parameter NXTNOIV = 0;  // disable naxi invalidate

  parameter BITSEQN = BITXSEQ;

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
  output [NUMRWPT*BITVROW-1:0]         t1_addrA;
  output [NUMRWPT*TAGWDTH-1:0]         t1_dinA;
  output [NUMRWPT*TAGWDTH-1:0]         t1_bwA;
  output [NUMRWPT-1:0]                 t1_readB;
  output [NUMRWPT*BITVROW-1:0]         t1_addrB;
  input  [NUMRWPT*TAGWDTH-1:0]         t1_doutB;

  output [NUMRWPT-1:0]                 t2_writeA;
  output [NUMRWPT*BITVROW-1:0]         t2_addrA;
  output [NUMRWPT*PHYWDTH-1:0]         t2_dinA;
  output [NUMRWPT*PHYWDTH-1:0]         t2_bwA;
  output [NUMRWPT-1:0]                 t2_readB;
  output [NUMRWPT*BITVROW-1:0]         t2_addrB;
  input  [NUMRWPT*PHYWDTH-1:0]         t2_doutB;

  output                               e_pf_empty;
  output                               e_pf_oflw;
  output                               e_uc_stall;
  output                               e_cache_rd_hit;
  output                               e_cache_wr_hit;
  output                               e_tgerr_vld;
  output [BITTGBY-1:0]                 e_tgerr_bid;
  output [BITVROW-1:0]                 e_tgerr_idx;
  output                               e_dterr_vld;
  output [BITDTBY-1:0]                 e_dterr_bid;
  output [BITVROW-1:0]                 e_dterr_idx;
  output                               e_l2err_vld;
 
  output                               ready;
  input                                clk;
  input                                rst;

  output dbg_la_pf_stall;
  output dbg_la_t3_block;
  output [BITFIFO:0] dbg_la_sqfifo_cnt;
  output dbg_la_sqfifo_fnd;
  output dbg_la_sqfifo_fuc;
  output [BITSEQN-1:0]dbg_la_sqfifo_fsq;
  output dbg_la_sqfifo_pop;
  output dbg_la_sqfifo_deq;
  output [BITFIFO-1:0]dbg_la_sqfifo_dsl;
  output [BITFIFO-1:0]dbg_la_sqfifo_psl;
  output [BITFIFO-1:0]dbg_la_sqfifo_ssl;
  output dbg_la_sqfifo_sdq;
  output [BITSEQN-1:0]dbg_la_sqfifo_psl_help;
  output [BITSEQN-1:0]dbg_la_sqfifo_dsq_help;
  output dbg_la_vread_vld;
  output dbg_la_twrite_wire;
  output [BITVROW-1:0] dbg_la_twraddr_wire;
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
  output dbg_la_vsidx_out;
  output dbg_la_sqfifo_hit;
  output dbg_la_sqfifo_htv;
  output [BITSEQN-1:0]dbg_la_sqfifo_hsq;
  output dbg_la_cache_hit;
  output [BITWRDS-1:0]dbg_la_cache_map;
  output dbg_la_cache_add;
  output dbg_la_cache_evt;
  output [BITWRDS-1:0]dbg_la_cache_emp;
  output [FIFOCNT-1:0]dbg_la_sqfifo_vld;
  output [FIFOCNT-1:0]dbg_la_sqfifo_prv;
  output [FIFOCNT-1:0]dbg_la_sqfifo_rdv;
  output [FIFOCNT-1:0]dbg_la_sqfifo_wrv;
  output [FIFOCNT-1:0]dbg_la_sqfifo_flv;
  output [FIFOCNT-1:0]dbg_la_sqfifo_inv;
  output [FIFOCNT-1:0]dbg_la_sqfifo_uch;
  output [FIFOCNT-1:0]dbg_la_sqfifo_idx;
  output [FIFOCNT-1:0]dbg_la_sqfifo_fil;
  output [32-1:0]                 dbg_la_id_bsy;
  output                               dbg_la_sreq_stall;
  output                               dbg_la_sreq_vld;
  output [BITXSEQ-1:0]                 dbg_la_sreq_fid;
  output                               dbg_la_sreq_map_vld;
  output [BITXSEQ-1:0]                 dbg_la_sreq_rid;
  output [BITXSEQ:0]                   dbg_la_spnd_frcnt;
  output [NUMXSEQ-1:0]                 dbg_la_spnd_ack;
  output                               dbg_la_rmap_0;
  output [BITXSEQ-1:0]                 dbg_la_rmap_rid_0;
  output                               dbg_la_rmap_1;
  output [BITXSEQ-1:0]                 dbg_la_rmap_rid_1;
  output dbg_la_late_retire;
  output dbg_la_mreq_fifo_full;
  output dbg_la_mreq_fifo_empty;
  output dbg_la_mreq_fifo_push;
  output dbg_la_ucach_wack_reg;


  assign t1_bwA = ~0;
  assign t2_bwA = ~0;

  algo_pxmqxs_cache_bdg_c1_top #(
    .BITWDTH     (BITWDTH     ), .WIDTH       (WIDTH       ), .BYTWDTH     (BYTWDTH     ), .BITBYTS     (BITBYTS     ), .ENAPAR      (ENAPAR      ),
    .ENAECC      (ENAECC      ), .ECCWDTH     (ECCWDTH     ), .NUMRWPT     (NUMRWPT     ), .NUMADDR     (NUMADDR     ), .BITADDR     (BITADDR     ),
    .NUMVROW     (NUMVROW     ), .BITVROW     (BITVROW     ), .NUMWRDS     (NUMWRDS     ), .BITWRDS     (BITWRDS     ), .SRAM_DELAY  (SRAM_DELAY  ),
    .DRAM_DELAY  (DRAM_DELAY  ), .FLOPECC     (FLOPECC     ), .FLOPCMD     (FLOPCMD     ), .FLOPIN      (FLOPIN      ), .FLOPMEM     (FLOPMEM     ),
    .FLOPOUT     (FLOPOUT     ), .FIFOCNT     (FIFOCNT     ), .BITFIFO     (BITFIFO     ), .BITXTYP     (BITXTYP     ), .BITXSEQ     (BITXSEQ     ),
    .BITXATR     (BITXATR     ), .BITXSIZ     (BITXSIZ     ), .NXWIDTH     (NXWIDTH     ), .NXBTCNT     (NXBTCNT     ), .BITXDBT     (BITXDBT     ),
    .NXTNOWR     (NXTNOWR     ), .NXTNOFL     (NXTNOFL     ), .NXTNOIV     (NXTNOIV     ),
    .NUMTGBY     (NUMTGBY     ), .NUMDTBY     (NUMDTBY     ), .BITTGBY     (BITTGBY     ), .BITDTBY     (BITDTBY     ), .BITUCPF     (BITUCPF     ))
   algo (
    .clk(clk), .rst(rst), .ready(ready),
  
    .s_creq_valid(s_creq_valid), .s_creq_type(s_creq_type), .s_creq_attr(s_creq_attr), .s_creq_size(s_creq_size), .s_creq_id(s_creq_id), .s_creq_addr(s_creq_addr), .s_creq_rdstall(s_creq_rdstall), .s_creq_wrstall(s_creq_wrstall),
    .s_dreq_valid(s_dreq_valid), .s_dreq_id(s_dreq_id), .s_dreq_data(s_dreq_data), .s_dreq_attr(s_dreq_attr), .s_dreq_stall(s_dreq_stall),
    .s_rreq_valid(s_rreq_valid), .s_rreq_id(s_rreq_id), .s_rreq_data(s_rreq_data), .s_rreq_attr(s_rreq_attr), .s_rreq_stall(s_rreq_stall),

    .m_creq_valid(m_creq_valid), .m_creq_type(m_creq_type), .m_creq_attr(m_creq_attr), .m_creq_size(m_creq_size), .m_creq_id(m_creq_id), .m_creq_addr(m_creq_addr), .m_creq_rdstall(m_creq_rdstall), .m_creq_wrstall(m_creq_wrstall),
    .m_dreq_valid(m_dreq_valid), .m_dreq_id(m_dreq_id), .m_dreq_data(m_dreq_data), .m_dreq_attr(m_dreq_attr), .m_dreq_stall(m_dreq_stall),
    .m_rreq_valid(m_rreq_valid), .m_rreq_id(m_rreq_id), .m_rreq_data(m_rreq_data), .m_rreq_attr(m_rreq_attr), .m_rreq_stall(m_rreq_stall),

    .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
    .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),

    .e_pf_empty (e_pf_empty ), .e_pf_oflw  (e_pf_oflw), .e_uc_stall (e_uc_stall), .e_cache_rd_hit(e_cache_rd_hit), .e_cache_wr_hit(e_cache_wr_hit),
    .e_tgerr_vld(e_tgerr_vld), .e_tgerr_bid(e_tgerr_bid), .e_tgerr_idx(e_tgerr_idx),
    .e_dterr_vld(e_dterr_vld), .e_dterr_bid(e_dterr_bid), .e_dterr_idx(e_dterr_idx),
    .e_l2err_vld(e_l2err_vld),
    .dbg_la_pf_stall(dbg_la_pf_stall),
    .dbg_la_t3_block(dbg_la_t3_block),
    .dbg_la_sqfifo_cnt(dbg_la_sqfifo_cnt),
    .dbg_la_sqfifo_fnd(dbg_la_sqfifo_fnd),
    .dbg_la_sqfifo_fuc(dbg_la_sqfifo_fuc),
    .dbg_la_sqfifo_fsq(dbg_la_sqfifo_fsq),
    .dbg_la_sqfifo_pop(dbg_la_sqfifo_pop),
    .dbg_la_sqfifo_deq(dbg_la_sqfifo_deq),
    .dbg_la_sqfifo_dsl(dbg_la_sqfifo_dsl),
    .dbg_la_sqfifo_psl(dbg_la_sqfifo_psl),
    .dbg_la_sqfifo_ssl(dbg_la_sqfifo_ssl),
    .dbg_la_sqfifo_sdq(dbg_la_sqfifo_sdq),
    .dbg_la_sqfifo_psl_help(dbg_la_sqfifo_psl_help),
    .dbg_la_sqfifo_dsq_help(dbg_la_sqfifo_dsq_help),
    .dbg_la_vread_vld(dbg_la_vread_vld),
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
    .dbg_la_vsidx_out(dbg_la_vsidx_out),
    .dbg_la_sqfifo_hit(dbg_la_sqfifo_hit),
    .dbg_la_sqfifo_htv(dbg_la_sqfifo_htv),
    .dbg_la_sqfifo_hsq(dbg_la_sqfifo_hsq),
    .dbg_la_cache_hit(dbg_la_cache_hit),
    .dbg_la_cache_map(dbg_la_cache_map),
    .dbg_la_cache_add(dbg_la_cache_add),
    .dbg_la_cache_evt(dbg_la_cache_evt),
    .dbg_la_cache_emp(dbg_la_cache_emp),
    .dbg_la_sqfifo_vld(dbg_la_sqfifo_vld),
    .dbg_la_sqfifo_prv(dbg_la_sqfifo_prv),
    .dbg_la_sqfifo_rdv(dbg_la_sqfifo_rdv),
    .dbg_la_sqfifo_wrv(dbg_la_sqfifo_wrv),
    .dbg_la_sqfifo_flv(dbg_la_sqfifo_flv),
    .dbg_la_sqfifo_inv(dbg_la_sqfifo_inv),
    .dbg_la_sqfifo_uch(dbg_la_sqfifo_uch),
    .dbg_la_sqfifo_idx(dbg_la_sqfifo_idx),
    .dbg_la_sqfifo_fil(dbg_la_sqfifo_fil),
    .dbg_la_id_bsy(dbg_la_id_bsy),
    .dbg_la_sreq_stall(dbg_la_sreq_stall),
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
    .dbg_la_late_retire(dbg_la_late_retire),
    .dbg_la_mreq_fifo_full(dbg_la_mreq_fifo_full),
    .dbg_la_mreq_fifo_empty(dbg_la_mreq_fifo_empty),
    .dbg_la_mreq_fifo_push(dbg_la_mreq_fifo_push),
    .dbg_la_ucach_wack_reg(dbg_la_ucach_wack_reg)
    /*.dbg_la_pf_stall(),
    .dbg_la_t3_block(),
    .dbg_la_sqfifo_cnt(),
    .dbg_la_sqfifo_fnd(),
    .dbg_la_sqfifo_fuc(),
    .dbg_la_sqfifo_fsq(),
    .dbg_la_sqfifo_pop(),
    .dbg_la_sqfifo_deq(),
    .dbg_la_sqfifo_dsl(),
    .dbg_la_sqfifo_psl(),
    .dbg_la_sqfifo_ssl(),
    .dbg_la_sqfifo_sdq(),
    .dbg_la_sqfifo_psl_help(),
    .dbg_la_sqfifo_dsq_help(),
    .dbg_la_vread_vld(),
    .dbg_la_twrite_wire(),
    .dbg_la_twraddr_wire(),
    .dbg_la_dwrite_wire(),
    .dbg_la_dwraddr_wire(),
    .dbg_la_data_vld(),
    .dbg_la_dtag_vld(),
    .dbg_la_tg_rd_vld(),
    .dbg_la_dt_rd_vld(),
    .dbg_la_dvld_out(),
    .dbg_la_drty_out(),
    .dbg_la_dlru_out(),
    .dbg_la_vread_out(), 
    .dbg_la_vucach_out(),
    .dbg_la_vwrite_out(),
    .dbg_la_vflush_out(),
    .dbg_la_vfill_out(),
    .dbg_la_srdwr_out(),
    .dbg_la_vinvld_out(),
    .dbg_la_vsidx_out(),
    .dbg_la_sqfifo_hit(),
    .dbg_la_sqfifo_htv(),
    .dbg_la_sqfifo_hsq(),
    .dbg_la_cache_hit(),
    .dbg_la_cache_map(),
    .dbg_la_cache_add(),
    .dbg_la_cache_evt(),
    .dbg_la_cache_emp(),
    .dbg_la_sqfifo_vld(),
    .dbg_la_sqfifo_prv(),
    .dbg_la_sqfifo_rdv(),
    .dbg_la_sqfifo_wrv(),
    .dbg_la_sqfifo_flv(),
    .dbg_la_sqfifo_inv(),
    .dbg_la_sqfifo_uch(),
    .dbg_la_sqfifo_idx(),
    .dbg_la_sqfifo_fil(),
    .dbg_la_id_bsy(),
    .dbg_la_sreq_stall(),
    .dbg_la_sreq_vld(),
    .dbg_la_sreq_fid(),
    .dbg_la_sreq_map_vld(),
    .dbg_la_sreq_rid(),
    .dbg_la_spnd_frcnt(),
    .dbg_la_spnd_ack(),
    .dbg_la_rmap_0(),
    .dbg_la_rmap_rid_0(),
    .dbg_la_rmap_1(),
    .dbg_la_rmap_rid_1(),
    .dbg_la_late_retire(),
    .dbg_la_mreq_fifo_full(),
    .dbg_la_mreq_fifo_empty(),
    .dbg_la_mreq_fifo_push(),
    .dbg_la_ucach_wack_reg()*/
);

endmodule // algo_1xm1xs_bdg_c4_top_wrap

