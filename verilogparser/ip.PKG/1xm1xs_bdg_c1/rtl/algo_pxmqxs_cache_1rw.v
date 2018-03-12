module algo_pxmqxs_cache_1rw (

  s_creq_valid, s_creq_type, s_creq_attr, s_creq_size, s_creq_id, s_creq_addr, s_creq_rdstall, s_creq_wrstall,
  s_dreq_valid, s_dreq_id, s_dreq_data, s_dreq_attr, s_dreq_stall,
  s_rreq_valid, s_rreq_id, s_rreq_data, s_rreq_attr, s_rreq_stall,

  m_creq_valid, m_creq_type, m_creq_attr, m_creq_size, m_creq_id, m_creq_addr, m_creq_rdstall, m_creq_wrstall,
  m_dreq_valid, m_dreq_id, m_dreq_data, m_dreq_attr, m_dreq_stall,
  m_rreq_valid, m_rreq_id, m_rreq_data, m_rreq_attr, m_rreq_stall,

  t1_readA, t1_writeA, t1_flushA, t1_invldA, t1_sidxA, t1_ucachA, t1_sqinA, t1_addrA, t1_byinA, t1_dinA, 
  t1_rd_vldA, t1_rd_hitA, t1_rd_serrA, t1_rd_sqoutA, t1_rd_doutA, t1_stallA, t1_ucofstA, t1_ucsizeA, t1_ucpfxA, t1_rd_attrA,
  
  t2_readA, t2_writeA, t2_ucachA, t2_sqinA, t2_addrA, t2_dinA, t2_vldA, t2_sqoutA, t2_doutA, t2_attrA, t2_stallA, t2_blockA, t2_ucofstA, t2_ucsizeA, t2_ucpfxA,

  mfifo_empty,

  e_l2err_vld,

  ready, clk, rst,
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

parameter BITWDTH = 5;
parameter WIDTH = 32;
parameter BYTWDTH = WIDTH/8;
parameter BITBYTS = 1;
parameter NUMRWPT = 1;
parameter NUMADDR = 65536;
parameter BITADDR = 16;
parameter BITUCPF = 2;
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

parameter NXTNOWR = 0;  // No naxi write
parameter NXTNOFL = 0;  // No naxi flush
parameter NXTNOIV = 0;  // No naxi invalidate

parameter BITXTYP = 3;
parameter BITXADR = BITUCPF+BITADDR+BITBYTS;
parameter BITXSEQ = 4;
parameter BITXATR = 3;
parameter BITXSIZ = 8;
parameter NXWIDTH = 256;
parameter NXBTCNT = 1; // data beat count
parameter BITXDBT = 0; // data beat count bits

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
output  [NUMRWPT-1:0]                t1_ucachA;
output  [NUMRWPT*BITBYTS-1:0]        t1_ucofstA;
output  [NUMRWPT*BITXSIZ-1:0]        t1_ucsizeA;
output  [NUMRWPT*BITUCPF-1:0]        t1_ucpfxA;
output  [NUMRWPT*BITXSEQ-1:0]        t1_sqinA;
output  [NUMRWPT*BITADDR-1:0]        t1_addrA;
output  [NUMRWPT*BYTWDTH-1:0]        t1_byinA;
output  [NUMRWPT*WIDTH-1:0]          t1_dinA;
input   [NUMRWPT-1:0]                t1_rd_vldA;
input   [NUMRWPT-1:0]                t1_rd_hitA;
input   [NUMRWPT-1:0]                t1_rd_serrA;
input   [NUMRWPT*BITXSEQ-1:0]        t1_rd_sqoutA;
input   [NUMRWPT*WIDTH-1:0]          t1_rd_doutA;
input                                t1_stallA;
input   [NUMRWPT*BITXATR-1:0]        t1_rd_attrA;

input   [NUMRWPT-1:0]                t2_readA;
input   [NUMRWPT-1:0]                t2_writeA;
input   [NUMRWPT-1:0]                t2_ucachA;
input   [NUMRWPT*BITBYTS-1:0]        t2_ucofstA;
input   [NUMRWPT*BITXSIZ-1:0]        t2_ucsizeA;
input   [NUMRWPT*BITUCPF-1:0]        t2_ucpfxA;
input   [NUMRWPT*BITXSEQ-1:0]        t2_sqinA;
input   [NUMRWPT*BITADDR-1:0]        t2_addrA;
input   [NUMRWPT*WIDTH-1:0]          t2_dinA;
output  [NUMRWPT-1:0]                t2_vldA;
output  [NUMRWPT*BITXSEQ-1:0]        t2_sqoutA;
output  [NUMRWPT*WIDTH-1:0]          t2_doutA;
output  [NUMRWPT*BITXATR-1:0]        t2_attrA;
input                                t2_stallA;
output                               t2_blockA;

output                               mfifo_empty;
output                               e_l2err_vld;

output                               ready;
input                                clk;
input                                rst;

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

wire [BITADDR-1:0]                  select_addr = {BITADDR{1'b0}};
wire [BITWDTH-1:0]                  select_bit = {BITWDTH{1'b0}};

  core_pxmqxs_cache_1rw #(
    .BITWDTH   (BITWDTH    ), .WIDTH     (WIDTH      ), .BYTWDTH   (BYTWDTH    ), .BITBYTS   (BITBYTS    ), .NUMRWPT   (NUMRWPT    ),
    .NUMADDR   (NUMADDR    ), .BITADDR   (BITADDR    ), .NUMVROW   (NUMVROW    ), .BITVROW   (BITVROW    ), .NUMWRDS   (NUMWRDS    ),
    .BITWRDS   (BITWRDS    ), .SRAM_DELAY(SRAM_DELAY ), .DRAM_DELAY(DRAM_DELAY ), .FLOPIN    (FLOPIN     ), .FLOPOUT   (FLOPOUT    ),
    .FIFOCNT   (FIFOCNT    ), .BITFIFO   (BITFIFO    ), 
    .BITXTYP   (BITXTYP    ), .BITXADR   (BITXADR    ), .BITXSEQ   (BITXSEQ    ), .BITXATR   (BITXATR    ), .BITXSIZ   (BITXSIZ    ), 
    .NXWIDTH   (NXWIDTH    ), .NXBTCNT   (NXBTCNT    ), .BITXDBT   (BITXDBT    ), .NUMXMPT   (NUMXMPT    ), .NUMXSPT   (NUMXSPT    ),
    .NXTNOWR     (NXTNOWR     ), .NXTNOFL     (NXTNOFL     ), .NXTNOIV     (NXTNOIV))
   core (
    .s_creq_valid(s_creq_valid), .s_creq_type(s_creq_type), .s_creq_attr(s_creq_attr), .s_creq_size(s_creq_size), .s_creq_id(s_creq_id), 
    .s_creq_addr(s_creq_addr), .s_creq_rdstall(s_creq_rdstall), .s_creq_wrstall(s_creq_wrstall),
    .s_dreq_valid(s_dreq_valid), .s_dreq_id(s_dreq_id), .s_dreq_data(s_dreq_data), .s_dreq_attr(s_dreq_attr), .s_dreq_stall(s_dreq_stall),
    .s_rreq_valid(s_rreq_valid), .s_rreq_id(s_rreq_id), .s_rreq_data(s_rreq_data), .s_rreq_attr(s_rreq_attr), .s_rreq_stall(s_rreq_stall),

    .m_creq_valid(m_creq_valid), .m_creq_type(m_creq_type), .m_creq_attr(m_creq_attr), .m_creq_size(m_creq_size), .m_creq_id(m_creq_id), 
    .m_creq_addr(m_creq_addr), .m_creq_rdstall(m_creq_rdstall), .m_creq_wrstall(m_creq_wrstall),
    .m_dreq_valid(m_dreq_valid), .m_dreq_id(m_dreq_id), .m_dreq_data(m_dreq_data), .m_dreq_attr(m_dreq_attr), .m_dreq_stall(m_dreq_stall),
    .m_rreq_valid(m_rreq_valid), .m_rreq_id(m_rreq_id), .m_rreq_data(m_rreq_data), .m_rreq_attr(m_rreq_attr), .m_rreq_stall(m_rreq_stall),

    .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_flushA(t1_flushA), .t1_invldA(t1_invldA), .t1_sidxA(t1_sidxA), .t1_ucachA(t1_ucachA), .t1_ucofstA(t1_ucofstA), .t1_ucsizeA(t1_ucsizeA), .t1_ucpfxA(t1_ucpfxA),
    .t1_sqinA(t1_sqinA), .t1_addrA(t1_addrA), .t1_byinA(t1_byinA), .t1_dinA(t1_dinA), 
    .t1_rd_vldA(t1_rd_vldA), .t1_rd_hitA(t1_rd_hitA), .t1_rd_serrA (t1_rd_serrA), .t1_rd_sqoutA(t1_rd_sqoutA), .t1_rd_doutA(t1_rd_doutA), .t1_stallA(t1_stallA), .t1_rd_attrA (t1_rd_attrA),

    .t2_readA(t2_readA), .t2_writeA(t2_writeA), .t2_ucachA(t2_ucachA), .t2_sqinA(t2_sqinA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_ucofstA(t2_ucofstA), .t2_ucsizeA(t2_ucsizeA), .t2_ucpfxA (t2_ucpfxA),
    .t2_vldA(t2_vldA), .t2_sqoutA(t2_sqoutA), .t2_doutA(t2_doutA), .t2_attrA(t2_attrA), .t2_stallA(t2_stallA), .t2_blockA(t2_blockA),

    .mfifo_empty (mfifo_empty),

    .e_l2err_vld(e_l2err_vld),

    .ready(ready), .clk(clk), .rst(rst),

    .select_addr(select_addr),.select_bit(select_bit),
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
 
);

`ifdef SIM_SVA

assume_snaxi_bad_type_chk: assert property (@(posedge clk) disable iff (rst || !ready) (s_creq_type < 3'b100))
  else $display("[ERROR:memoir:%m:%0t] bad NAXI command type creq_type=0x%0x", $time, s_creq_type);

assume_snaxi_seq_chk: assert property (@(posedge clk) disable iff (rst || !ready) (s_dreq_valid && (s_creq_type == 3'b000)) |-> (s_creq_valid && (s_creq_id == s_dreq_id)))
  else $display("[ERROR:memoir:%m:%0t] slave ifc cmd and data valid at the same time with different sequence number cseq=0x%0x dseq=0x%0x", $time, s_creq_id, s_dreq_id);
// TBD: assume flush => no dreq_valid
// TBD: assume invalidate => no dreq_valid
// TBD: assume single flit regardless of alignment/address/size
// TBD: for flush and invalidate, size is cache line size
// TBD: drop flush and invalidate if CACHED is not set

// TBD: depending on cache access size, constrain creq_size

// TBD: rreq_attr bit definition
//
// TBD: do flush and invaldate update LRU?
//
// TBD: what are the attr field values for flush and invalidated - can it be
// non-cacheable? does it need response?
//
// TBD: no conflicting accesses to address space i.e., cached and non-cached
// to same addr
//
// TBD: error bits from L2 handling and routing them
//
// TBD: data error to be set on data parity error? how about on tag ECC error?
//
// TBD: for one one-byte read, should rest of the bytes be cleared?
//
// TBD: describe software interface as it differs from master interface
// flush_cache and reset_cache have to be handled in cache_core by Da
//
// CPU never stalls response bus -- assert on this
//
// TBD: assert invalid Ops on NXTNOWR = 0;  // No naxi write NXTNOFL = 0;  // No naxi flush NXTNOIV = 0;  // No naxi invalidate

assert_mnaxi_vld_seq_chk: assert property (@(posedge clk) disable iff (rst || !ready) (m_dreq_valid && (m_creq_type == 3'b000)) |-> (m_creq_valid && (m_creq_id == m_dreq_id)))
  else $display("[ERROR:memoir:%m:%0t] master ifc cmd and data valid at the same time with different sequence number cseq=0x%0x dseq=0x%0x", $time, m_creq_id, m_dreq_id);

`endif

endmodule

