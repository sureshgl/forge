module algo_1xm1xs_bdg_c5_top_wrap #(
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
    dbg_la_sqfifo_vld,
    dbg_la_sqfifo_prv,
    dbg_la_sqfifo_rdv,
    dbg_la_sqfifo_inv,
    dbg_la_sqfifo_uch,
    dbg_la_sqfifo_idx,
    dbg_la_sqfifo_fil,
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

  parameter BITWDTH = IP_BITWIDTH-3;
  parameter WIDTH = IP_WIDTH/8;
  parameter BYTWDTH = WIDTH/8;
  parameter BITBYTS = BITWDTH - 3;
  parameter ENAPAR = 1;
  parameter ENAECC = 0;
  parameter ECCWDTH = 5;
  parameter NUMRWPT = 1;
  parameter BITADDR = 61-BITBYTS;
  parameter NUMADDR = 57'h100000000000;
  parameter NUMVTAG = T1_NUMVROW; 
  parameter BITVTAG = T1_BITVROW;
  parameter NUMVROW = T2_NUMVROW; 
  parameter BITVROW = T2_BITVROW;
  parameter NUMWRDS = 8;
  parameter BITWRDS = 3;
  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 2;
  parameter FLOPECC = 0;
  parameter FLOPCMD = 0;
  parameter FLOPIN = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;

  parameter FIFOCNT = 16;
  parameter BITFIFO = 4;

  parameter NXTNOWR = 1;  // disable naxi write
  parameter NXTNOFL = 1;  // disable naxi flush
  parameter NXTNOIV = 0;  // disable naxi invalidate

  parameter BITXTYP = 3;
  parameter BITXADR = BITADDR+BITBYTS;
  parameter BITXATR = 3;
  parameter BITXSIZ = 8;
  parameter BITXSEQ = 5;
  parameter NXWIDTH = 256;
  parameter NXBTCNT = 8; // data beat count
  parameter BITXDBT = 3; // data beat count bits

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
  
  parameter BITTGBY = 6;
  parameter BITDTBY = 8; 

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
  output [NUMRWPT*TAGWDTH-1:0]         t1_bwA;
  output [NUMRWPT-1:0]                 t1_readB;
  output [NUMRWPT*BITVTAG-1:0]         t1_addrB;
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

  output [4:0]dbg_la_sqfifo_cnt  ;
  output dbg_la_t3_readA  ;
  output dbg_la_t3_writeA  ;
  output dbg_la_t3_ucachA  ;
  output [((1 * 5) - 1):0]dbg_la_t3_ucofstA  ;
  output [((1 * 8) - 1):0]dbg_la_t3_ucsizeA  ;
  output [((1 * 5) - 1):0]dbg_la_t3_sqinA  ;
  output [((1 * 56) - 1):0]dbg_la_t3_addrA  ;
  output [15:0]dbg_la_sqfifo_vld;
  output [15:0]dbg_la_sqfifo_prv;
  output [15:0]dbg_la_sqfifo_rdv;
  output [15:0]dbg_la_sqfifo_inv;
  output [15:0]dbg_la_sqfifo_uch;
  output [15:0]dbg_la_sqfifo_idx;
  output [15:0]dbg_la_sqfifo_fil;
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
  output [3-1:0] dbg_la_sqfifo_fbe;
  output [8-1:0] dbg_la_sqfifo_fbm;
  output [3-1:0] dbg_la_t3_attrA_wire;
  output         dbg_la_sqfifo_fnd ;
  output         dbg_la_sqfifo_fuc ;
  output [5-1:0] dbg_la_sqfifo_fsq ;
  output         dbg_la_sqfifo_deq ;
  output [4-1:0] dbg_la_sqfifo_dsl ;
  output         dbg_la_sqfifo_pop ;
  output [4-1:0] dbg_la_sqfifo_psl ;
  output         dbg_la_sqfifo_sdq ;
  output [4-1:0] dbg_la_sqfifo_ssl ;
  output [5-1:0] dbg_la_sqfifo_psl_help ; 
  output [5-1:0] dbg_la_sqfifo_dsq_help;
  output dbg_la_twrite_wire;
  output [3-1:0] dbg_la_twraddr_wire;
  output dbg_la_dwrite_wire;
  output [6-1:0] dbg_la_dwraddr_wire;
  output dbg_la_data_vld;
  output dbg_la_dtag_vld;
  output dbg_la_tg_rd_vld;
  output dbg_la_dt_rd_vld;
  output [8-1:0]dbg_la_dvld_out;
  output [8-1:0]dbg_la_drty_out;
  output [8*3-1:0]dbg_la_dlru_out;
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
  output [3-1:0]dbg_la_cache_map;
  output dbg_la_cache_add;
  output dbg_la_cache_evt;
  output [3-1:0]dbg_la_cache_emp;
  output [3-1:0]dbg_la_cache_drt;
  output [32-1:0] dbg_la_id_bsy;
  output         dbg_la_sreq_stall;
  output [3:0]   dbg_la_sreq_bcnt;
  output [8-1:0] dbg_la_sreq_bbmp;
  output         dbg_la_sreq_vld;
  output [5-1:0] dbg_la_sreq_fid;
  output         dbg_la_sreq_map_vld;
  output [5-1:0] dbg_la_sreq_rid;
  output [5:0]   dbg_la_spnd_frcnt;
  output [32-1:0]dbg_la_spnd_ack;
  output         dbg_la_rmap_0;
  output [5-1:0] dbg_la_rmap_rid_0;
  output dbg_la_rmap_1;
  output [5-1:0]dbg_la_rmap_rid_1;
  output dbg_la_mreq_fifo_full;
  output dbg_la_mreq_fifo_empty;
  output dbg_la_mreq_fifo_push;
  output dbg_la_mreq_fifo_pop;
  //assign t1_bwA = ~0;
  //assign t2_bwA = ~0;
  assign t1_bwA[NUMRWPT*TAGWDTH-1:0] = {NUMRWPT*TAGWDTH{1'b1}};
  assign t2_bwA[NUMRWPT*PHYWDTH-1:0] = {NUMRWPT*PHYWDTH{1'b1}};

  algo_pxmqxs_cache_bdg_c2_top #(
    .BITWDTH     (BITWDTH     ), .WIDTH       (WIDTH       ), .BYTWDTH     (BYTWDTH     ), .BITBYTS     (BITBYTS     ), .ENAPAR      (ENAPAR      ),
    .ENAECC      (ENAECC      ), .ECCWDTH     (ECCWDTH     ), .NUMRWPT     (NUMRWPT     ), .BITADDR     (BITADDR     ), .NUMADDR     (NUMADDR     ),
    .NUMVROW     (NUMVROW     ), .BITVROW     (BITVROW     ), .NUMWRDS     (NUMWRDS     ), .BITWRDS     (BITWRDS     ), .SRAM_DELAY  (SRAM_DELAY  ),
    .NUMVTAG     (NUMVTAG     ), .BITVTAG     (BITVTAG     ), .BITDTAG     (BITDTAG     ), .BITTAGW     (BITTAGW     ),
    .DRAM_DELAY  (DRAM_DELAY  ), .FLOPECC     (FLOPECC     ), .FLOPCMD     (FLOPCMD     ), .FLOPIN      (FLOPIN      ), .FLOPMEM     (FLOPMEM     ),
    .FLOPOUT     (FLOPOUT     ), .FIFOCNT     (FIFOCNT     ), .BITFIFO     (BITFIFO     ), .BITXTYP     (BITXTYP     ), .BITXSEQ     (BITXSEQ     ),
    .BITXATR     (BITXATR     ), .BITXSIZ     (BITXSIZ     ), .NXWIDTH     (NXWIDTH     ), .NXBTCNT     (NXBTCNT     ), .BITXDBT     (BITXDBT     ),
    .NXTNOWR     (NXTNOWR     ), .NXTNOFL     (NXTNOFL     ), .NXTNOIV     (NXTNOIV),
    .BITBEAT     (BITBEAT     ), .NUMBEAT     (NUMBEAT     ), .BITSEQN     (BITSEQN),
    .NUMTGBY     (NUMTGBY     ), .NUMDTBY     (NUMDTBY     ), .BITTGBY     (BITTGBY     ), .BITDTBY     (BITDTBY     ))
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

    .e_pf_empty (e_pf_empty ), .e_pf_oflw  (e_pf_oflw), .e_uc_stall (e_uc_stall), .e_cache_rd_hit(e_cache_rd_hit),
    .e_tgerr_vld(e_tgerr_vld), .e_tgerr_bid(e_tgerr_bid), .e_tgerr_idx(e_tgerr_idx),
    .e_dterr_vld(e_dterr_vld), .e_dterr_bid(e_dterr_bid), .e_dterr_idx(e_dterr_idx),

    .e_l2err_vld(e_l2err_vld),
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
    .dbg_la_cache_drt(dbg_la_cache_drt),
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
    /*.dbg_la_sqfifo_cnt(),
    .dbg_la_t3_readA(),
    .dbg_la_t3_writeA (),
    .dbg_la_t3_ucachA (),
    .dbg_la_t3_ucofstA(),
    .dbg_la_t3_ucsizeA(),
    .dbg_la_t3_sqinA(),
    .dbg_la_t3_addrA(),
    .dbg_la_sqfifo_vld(),
    .dbg_la_sqfifo_prv(),
    .dbg_la_sqfifo_rdv(),
    .dbg_la_sqfifo_inv(),
    .dbg_la_sqfifo_uch(),
    .dbg_la_sqfifo_idx(),
    .dbg_la_sqfifo_fil(),
    .dbg_la_pf_stall(),
    .dbg_la_t3_stall(),
    .dbg_la_t3_block(),
    .dbg_la_l2uc_stall(),
    .dbg_la_vread(),
    .dbg_la_vinvld(),
    .dbg_la_vucach(),
    .dbg_la_vread_vld(),
    .dbg_la_vread_hit(),
    .dbg_la_vread_last(),
    .dbg_la_sqfifo_fbe(),
    .dbg_la_sqfifo_fbm(),
    .dbg_la_t3_attrA_wire(),
    .dbg_la_sqfifo_fnd(),
    .dbg_la_sqfifo_fuc(),
    .dbg_la_sqfifo_fsq(),
    .dbg_la_sqfifo_deq(),
    .dbg_la_sqfifo_dsl(),
    .dbg_la_sqfifo_pop(),
    .dbg_la_sqfifo_psl(),
    .dbg_la_sqfifo_sdq(),
    .dbg_la_sqfifo_ssl(),
    .dbg_la_sqfifo_psl_help(),
    .dbg_la_sqfifo_dsq_help(),
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
    .dbg_la_sqfifo_hit(),
    .dbg_la_sqfifo_htv(),
    .dbg_la_cache_hit(),
    .dbg_la_cache_map(),
    .dbg_la_cache_add(),
    .dbg_la_cache_evt(),
    .dbg_la_cache_emp(),
    .dbg_la_cache_drt(),
    .dbg_la_id_bsy(),
    .dbg_la_sreq_stall(),
    .dbg_la_sreq_bcnt(),
    .dbg_la_sreq_bbmp(),
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
    .dbg_la_mreq_fifo_full(),
    .dbg_la_mreq_fifo_empty(),
    .dbg_la_mreq_fifo_push(),
    .dbg_la_mreq_fifo_pop()*/
);

endmodule // algo_1xm1xs_bdg_c5_top_wrap

