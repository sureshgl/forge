module algo_pxmqxs_cache_1rw_mb (

  s_creq_valid, s_creq_type, s_creq_attr, s_creq_size, s_creq_id, s_creq_addr, s_creq_rdstall, s_creq_wrstall,
  s_dreq_valid, s_dreq_id, s_dreq_data, s_dreq_attr, s_dreq_stall,
  s_rreq_valid, s_rreq_id, s_rreq_data, s_rreq_attr, s_rreq_stall,

  m_creq_valid, m_creq_type, m_creq_attr, m_creq_size, m_creq_id, m_creq_addr, m_creq_rdstall, m_creq_wrstall,
  m_dreq_valid, m_dreq_id, m_dreq_data, m_dreq_attr, m_dreq_stall,
  m_rreq_valid, m_rreq_id, m_rreq_data, m_rreq_attr, m_rreq_stall,

  t1_readA, t1_writeA, t1_flushA, t1_invldA, t1_sidxA, t1_fldrtA, t1_ucachA, t1_sqinA, t1_addrA, t1_byinA, t1_dinA, t1_bbmpA,
  t1_rd_vldA, t1_rd_hitA, t1_rd_sqoutA, t1_rd_doutA, t1_stallA, t1_ucofstA, t1_ucsizeA, t1_rd_serrA, t1_rd_lastA, t1_rd_attrA,
  
  t2_readA, t2_writeA, t2_ucachA, t2_sqinA, t2_addrA, t2_dinA, t2_vldA, t2_sqoutA, t2_doutA, t2_attrA, t2_stallA, t2_blockA, t2_ucofstA, t2_ucsizeA,

  e_l2err_vld,

  ready, clk, rst,
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

parameter BITWDTH = 5;
parameter WIDTH = 32;
parameter BYTWDTH = WIDTH/8;
parameter BITBYTS = 1;
parameter NUMRWPT = 1;
parameter BITADDR = 16;
parameter NUMVROW = 256; 
parameter BITVROW = 8;
parameter NUMWRDS = 1;
parameter BITWRDS = 0;
parameter SRAM_DELAY = 2;
parameter DRAM_DELAY = 4;
parameter FLOPIN = 0;
parameter FLOPOUT = 0;
parameter FIFOCNT = 16;
parameter BITFIFO = 4;
parameter NUMDTBY = 1;
parameter NUMTGBY = 1;

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

output  [NUMRWPT-1:0]                t1_readA;
output  [NUMRWPT-1:0]                t1_writeA;
output  [NUMRWPT-1:0]                t1_flushA;
output  [NUMRWPT-1:0]                t1_invldA;
output  [NUMRWPT-1:0]                t1_sidxA;
output  [NUMRWPT-1:0]                t1_fldrtA;
output  [NUMRWPT-1:0]                t1_ucachA;
output  [NUMRWPT*BITBYTS-1:0]        t1_ucofstA;
output  [NUMRWPT*BITXSIZ-1:0]        t1_ucsizeA;
output  [NUMRWPT*BITXSEQ-1:0]        t1_sqinA;
output  [NUMRWPT*BITADDR-1:0]        t1_addrA;
output  [NUMRWPT*BYTWDTH-1:0]        t1_byinA;
output  [NUMRWPT*WIDTH-1:0]          t1_dinA;
output  [NUMRWPT*NXBTCNT-1:0]        t1_bbmpA;
input   [NUMRWPT-1:0]                t1_rd_vldA;
input   [NUMRWPT-1:0]                t1_rd_hitA;
input   [NUMRWPT*BITXSEQ-1:0]        t1_rd_sqoutA;
input   [NUMRWPT*WIDTH-1:0]          t1_rd_doutA;
input   [NUMRWPT-1:0]                t1_rd_serrA;
input   [NUMRWPT-1:0]                t1_rd_lastA;
input   [NUMRWPT*BITXATR-1:0]        t1_rd_attrA;
input                                t1_stallA;

input   [NUMRWPT-1:0]                t2_readA;
input   [NUMRWPT-1:0]                t2_writeA;
input   [NUMRWPT-1:0]                t2_ucachA;
input   [NUMRWPT*BITBYTS-1:0]        t2_ucofstA;
input   [NUMRWPT*BITXSIZ-1:0]        t2_ucsizeA;
input   [NUMRWPT*BITXSEQ-1:0]        t2_sqinA;
input   [NUMRWPT*BITADDR-1:0]        t2_addrA;
input   [NUMRWPT*WIDTH-1:0]          t2_dinA;
output  [NUMRWPT-1:0]                t2_vldA;
output  [NUMRWPT*BITXSEQ-1:0]        t2_sqoutA;
output  [NUMRWPT*WIDTH-1:0]          t2_doutA;
output  [NUMRWPT*BITXATR-1:0]        t2_attrA;
input                                t2_stallA;
output                               t2_blockA;
  
output                               e_l2err_vld;
output                               ready;
input                                clk;
input                                rst;

output [NUMXSEQ-1:0]                      dbg_la_id_bsy;
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

wire [BITADDR-1:0]                  select_addr = {BITADDR{1'b0}};
wire [BITWDTH-1:0]                  select_bit  = {BITWDTH{1'b0}};

  core_pxmqxs_cache_1rw_mb #(
    .BITWDTH   (BITWDTH    ), .WIDTH     (WIDTH      ), .BYTWDTH   (BYTWDTH    ), .BITBYTS   (BITBYTS    ), .NUMRWPT   (NUMRWPT    ),
    .BITADDR   (BITADDR    ), .NUMVROW   (NUMVROW    ), .BITVROW   (BITVROW    ), .NUMWRDS   (NUMWRDS    ),
    .BITWRDS   (BITWRDS    ), .SRAM_DELAY(SRAM_DELAY ), .DRAM_DELAY(DRAM_DELAY ), .FLOPIN    (FLOPIN     ), .FLOPOUT   (FLOPOUT    ),
    .FIFOCNT   (FIFOCNT    ), .BITFIFO   (BITFIFO    ), 
    .BITXTYP   (BITXTYP    ), .BITXADR   (BITXADR    ), .BITXSEQ   (BITXSEQ    ), .BITXATR   (BITXATR    ), .BITXSIZ   (BITXSIZ    ), 
    .NXWIDTH   (NXWIDTH    ), .NXBTCNT   (NXBTCNT    ), .BITXDBT   (BITXDBT    ), .NUMXMPT   (NUMXMPT    ), .NUMXSPT   (NUMXSPT    ),
    .NXTNOWR   (NXTNOWR    ), .NXTNOFL   (NXTNOFL    ), .NXTNOIV   (NXTNOIV    ) )
   core (
    .s_creq_valid(s_creq_valid), .s_creq_type(s_creq_type), .s_creq_attr(s_creq_attr), .s_creq_size(s_creq_size), .s_creq_id(s_creq_id), 
    .s_creq_addr(s_creq_addr), .s_creq_rdstall(s_creq_rdstall), .s_creq_wrstall(s_creq_wrstall),
    .s_dreq_valid(s_dreq_valid), .s_dreq_id(s_dreq_id), .s_dreq_data(s_dreq_data), .s_dreq_attr(s_dreq_attr), .s_dreq_stall(s_dreq_stall),
    .s_rreq_valid(s_rreq_valid), .s_rreq_id(s_rreq_id), .s_rreq_data(s_rreq_data), .s_rreq_attr(s_rreq_attr), .s_rreq_stall(s_rreq_stall),

    .m_creq_valid(m_creq_valid), .m_creq_type(m_creq_type), .m_creq_attr(m_creq_attr), .m_creq_size(m_creq_size), .m_creq_id(m_creq_id), 
    .m_creq_addr(m_creq_addr), .m_creq_rdstall(m_creq_rdstall), .m_creq_wrstall(m_creq_wrstall),
    .m_dreq_valid(m_dreq_valid), .m_dreq_id(m_dreq_id), .m_dreq_data(m_dreq_data), .m_dreq_attr(m_dreq_attr), .m_dreq_stall(m_dreq_stall),
    .m_rreq_valid(m_rreq_valid), .m_rreq_id(m_rreq_id), .m_rreq_data(m_rreq_data), .m_rreq_attr(m_rreq_attr), .m_rreq_stall(m_rreq_stall),
    
    .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_flushA(t1_flushA), .t1_invldA(t1_invldA), .t1_sidxA(t1_sidxA), .t1_fldrtA(t1_fldrtA), .t1_ucachA(t1_ucachA),  .t1_ucofstA(t1_ucofstA), .t1_ucsizeA(t1_ucsizeA),
    .t1_sqinA(t1_sqinA), .t1_addrA(t1_addrA), .t1_byinA(t1_byinA), .t1_dinA(t1_dinA), .t1_bbmpA(t1_bbmpA),
    .t1_rd_vldA(t1_rd_vldA), .t1_rd_hitA(t1_rd_hitA), .t1_rd_sqoutA(t1_rd_sqoutA), .t1_rd_doutA(t1_rd_doutA), .t1_stallA(t1_stallA), .t1_rd_serrA (t1_rd_serrA), .t1_rd_lastA(t1_rd_lastA), .t1_rd_attrA(t1_rd_attrA),

    .t2_readA(t2_readA), .t2_writeA(t2_writeA), .t2_ucachA(t2_ucachA), .t2_sqinA(t2_sqinA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_ucofstA(t2_ucofstA), .t2_ucsizeA(t2_ucsizeA),
    .t2_vldA(t2_vldA), .t2_sqoutA(t2_sqoutA), .t2_doutA(t2_doutA), .t2_attrA(t2_attrA), .t2_stallA(t2_stallA), .t2_blockA (t2_blockA),

    .e_l2err_vld (e_l2err_vld),

    .ready(ready), .clk(clk), .rst(rst),

    .select_addr(select_addr),.select_bit(select_bit),
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

endmodule // algo_pxmqxs_cache_1rw_mb

