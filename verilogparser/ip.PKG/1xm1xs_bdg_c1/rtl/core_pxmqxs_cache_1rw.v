module core_pxmqxs_cache_1rw (

  s_creq_valid, s_creq_type, s_creq_attr, s_creq_size, s_creq_id, s_creq_addr, s_creq_rdstall, s_creq_wrstall,
  s_dreq_valid, s_dreq_id, s_dreq_data, s_dreq_attr, s_dreq_stall,
  s_rreq_valid, s_rreq_id, s_rreq_data, s_rreq_attr, s_rreq_stall,

  m_creq_valid, m_creq_type, m_creq_attr, m_creq_size, m_creq_id, m_creq_addr, m_creq_rdstall, m_creq_wrstall,
  m_dreq_valid, m_dreq_id, m_dreq_data, m_dreq_attr, m_dreq_stall,
  m_rreq_valid, m_rreq_id, m_rreq_data, m_rreq_attr, m_rreq_stall,

  t1_readA, t1_writeA, t1_flushA, t1_invldA, t1_sidxA, t1_ucachA, t1_sqinA, t1_addrA, t1_byinA, t1_dinA, t1_ucofstA, t1_ucsizeA, t1_ucpfxA,
  t1_rd_vldA, t1_rd_hitA, t1_rd_serrA, t1_rd_sqoutA, t1_rd_doutA, t1_stallA, t1_rd_attrA,
  
  t2_readA, t2_writeA, t2_ucachA, t2_sqinA, t2_addrA, t2_dinA, t2_vldA, t2_sqoutA, t2_doutA, t2_attrA, t2_stallA, t2_blockA, t2_ucofstA, t2_ucsizeA, t2_ucpfxA,

  mfifo_empty,
  
  e_l2err_vld,

  ready, clk, rst,

  select_addr, select_bit,

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
parameter NUMXSEQ = (1 << BITXSEQ);
parameter NXBTCNT = 1; // data beat count
parameter BITXDBT = 0; // data beat count bits

parameter NUMXMPT = 1;
parameter NUMXSPT = 1;

parameter BITCSTS = 48; // stats reg size

parameter SPFFCNT = FIFOCNT;
parameter MQFFCNT = FIFOCNT;
parameter BITSPFF = BITFIFO;
parameter BITMQFF = BITFIFO;

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
output   [NUMRWPT*BITXATR-1:0]       t2_attrA; // address and data error from L2
input                                t2_stallA;
output                               t2_blockA;

output                               mfifo_empty;
output                               e_l2err_vld;

output                               ready;
input                                clk;
input                                rst;

input [BITADDR-1:0]                  select_addr;
input [BITWDTH-1:0]                  select_bit;

output [NUMXSEQ-1:0]                 dbg_la_id_bsy;
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


localparam NXTEWRIT = 3'b000;  // NAXI TYPE ENCODING WRITE
localparam NXTEREAD = 3'b001;
localparam NXTEFLUS = 3'b010;
localparam NXTEINVD = 3'b011;
localparam NXTERSVD = 3'b100;

localparam NXADBLST = 0; // NAXI data     attribute bit position last 
localparam NXARBLST = 0; // NAXI response attribute bit position last
localparam NXARBAER = 1; // NAXI response attribute bit position address error
localparam NXARBDER = 2; // NAXI response attribute bit position data error
localparam NXACBACK = 0; // NAXI command  attribute bit position acknowledge
localparam NXACBCCH = 1; // NAXI command  attribute bit position cacheable
localparam NXACBIDX = 2; // NAXI command  attribute bit position index operation

reg ready;
always @(posedge clk)
  ready <= !rst;

wire                         cpu_stall;
reg [NUMXSEQ-1:0]            spnd_ack;
reg [NUMXSEQ-1:0]            spnd_ccrd;
reg [NUMXSEQ-1:0]            spnd_ccwr;
wire                         sreq_map_vld;
wire                         spnd_full;
wire                         sreq_vld;
wire                         sreq_read;
wire                         sreq_write;
wire                         sreq_flush;
wire                         sreq_invld;
wire                         sreq_sidx;
wire                         sreq_ucach;
wire [BITBYTS-1:0]           sreq_ucofs;
wire [BITXSIZ-1:0]           sreq_ucsiz;
wire [BITUCPF-1:0]           sreq_ucpfx;
wire [BITXSEQ-1:0]           sreq_seq;
wire [BITXADR-BITBYTS-1:0]   sreq_addr;
wire [BYTWDTH-1:0]           sreq_byin;
wire [WIDTH-1:0]             sreq_din;
wire [BITXSEQ-1:0]           sreq_fid;
wire [BITXSEQ-1:0]           sreq_rid;
reg                          srsp_vld;
reg  [BITXATR-1:0]           srsp_attr;
reg  [BITXSEQ-1:0]           srsp_id;
reg  [WIDTH-1:0]             srsp_data;
reg                          srsp_ferr;
wire [BITXSEQ-1:0]           srsp_fid;
wire                         sreq_stall;
wire [BITXSEQ:0]             spnd_frcnt;

assign sreq_read  = !cpu_stall && s_creq_valid && (s_creq_type == NXTEREAD);
assign sreq_write = !cpu_stall && s_creq_valid && (s_creq_type == NXTEWRIT) && s_dreq_valid && s_dreq_attr[NXADBLST] && (NXTNOWR==0); 
assign sreq_flush = !cpu_stall && s_creq_valid && (s_creq_type == NXTEFLUS) && (NXTNOFL==0);
assign sreq_invld = !cpu_stall && s_creq_valid && (s_creq_type == NXTEINVD) && (NXTNOIV==0);
assign sreq_sidx  = (sreq_invld || sreq_flush) &&  s_creq_attr[NXACBIDX];
assign sreq_ucach = sreq_vld && !s_creq_attr[NXACBCCH];
assign sreq_ucofs = s_creq_addr[BITBYTS-1:0];
assign sreq_ucsiz = s_creq_size;
assign sreq_ucpfx = s_creq_addr[BITXADR-1:BITXADR-BITUCPF];
assign sreq_vld   = (sreq_read || sreq_write || sreq_flush || sreq_invld);
assign sreq_fid   = s_creq_id;
assign sreq_seq   = sreq_rid;
assign sreq_addr  = s_creq_addr >> BITBYTS;
assign sreq_byin  = (~({BYTWDTH{1'b1}} << s_creq_size)) << s_creq_addr[BITBYTS-1:0];
assign sreq_din   = (NXTNOWR==0) ? s_dreq_data : {WIDTH{1'b0}};

assign sreq_stall = (spnd_frcnt <= (NUMXSEQ-FIFOCNT));

wire               rmap_0;
wire [BITXSEQ-1:0] rmap_rid_0;
wire               rmap_1;
wire [BITXSEQ-1:0] rmap_rid_1;

id_mapper #(
  .NUMID(NUMXSEQ), .BITID(BITXSEQ))
 idmap (
  .clk        (clk), .rst        (rst),
  .fmap       (sreq_vld), .fmap_fid   (sreq_fid), .fmap_vld   (sreq_map_vld), .fmap_rid   (sreq_rid),
  .rlkp       (t1_rd_vldA), .rlkp_rid   (t1_rd_sqoutA), .rlkp_fid   (srsp_fid), .rlkp_vld   (),
  .rmap_0     (rmap_0), .rmap_rid_0 (rmap_rid_0), .rmap_vld_0 (), .rmap_fid_0 (),
  .rmap_1     (rmap_1), .rmap_rid_1 (rmap_rid_1), .rmap_vld_1 (), .rmap_fid_1 (),
  .free_cnt   (spnd_frcnt),
  .id_bsy     (dbg_la_id_bsy)
);

assign spnd_full = ~sreq_map_vld;

always @(posedge clk)
  if (rst)
    spnd_ack <= {NUMXSEQ{1'b0}};
  else if (sreq_vld)
    spnd_ack[sreq_rid] <= s_creq_attr[NXACBACK];

reg [NUMXSEQ-1:0] spnd_ccrd_nxt;
always_comb begin 
  spnd_ccrd_nxt = spnd_ccrd;
  for (integer i=0;i<NUMXSEQ;i++) begin
    if (sreq_vld && (sreq_rid==i))
      spnd_ccrd_nxt[sreq_rid] = sreq_read && !sreq_ucach;
    if (t1_rd_vldA && (t1_rd_sqoutA==i))
      spnd_ccrd_nxt[t1_rd_sqoutA] = 1'b0;
  end
end
always @(posedge clk)
  if (rst)
    spnd_ccrd <= {NUMXSEQ{1'b0}};
  else
    spnd_ccrd <= spnd_ccrd_nxt;

reg [NUMXSEQ-1:0] spnd_ccwr_nxt;
always_comb begin 
  spnd_ccwr_nxt = spnd_ccwr;
  for (integer i=0;i<NUMXSEQ;i++) begin
    if (sreq_vld && (sreq_rid==i))
      spnd_ccwr_nxt[sreq_rid] = sreq_write && !sreq_ucach;
    if (t1_rd_vldA && (t1_rd_sqoutA==i))
      spnd_ccwr_nxt[t1_rd_sqoutA] = 1'b0;
  end
end
always @(posedge clk)
  if (rst)
    spnd_ccwr <= {NUMXSEQ{1'b0}};
  else
    spnd_ccwr <= spnd_ccwr_nxt;

wire srsp_serr = (|t1_rd_attrA) ? 1'b0 : (t1_rd_vldA && t1_rd_serrA);

always @(posedge clk) begin
  srsp_vld  <= t1_rd_vldA && spnd_ack[t1_rd_sqoutA];
  srsp_attr <= {BITXATR{1'b0}} | (srsp_serr << NXARBDER) | (1'b1 << NXARBLST) | t1_rd_attrA;
  srsp_id   <= srsp_fid;
  srsp_data <= t1_rd_doutA;
  srsp_ferr <= t1_rd_vldA && (|t1_rd_attrA) && !spnd_ack[t1_rd_sqoutA];
end

reg               resp_vld;
reg [BITXSEQ-1:0] resp_rid;
always @(posedge clk) begin
  resp_vld <= t1_rd_vldA;
  resp_rid <= t1_rd_sqoutA;
end

wire   t2_writeA_wire;
assign t2_writeA_wire = t2_writeA[0] && (NXTNOWR==0);

wire   late_retire = (t2_writeA_wire && (resp_rid == t2_sqinA)); // do not retire if evict in progress
assign rmap_0     = resp_vld && !late_retire;
assign rmap_rid_0 = resp_rid;

wire               lret_vld_wire = resp_vld && late_retire; 
reg                lret_vld_reg;

// master requestor
wire               mreq_fifo_full;
wire               mreq_fifo_empty;
wire               mreq_fifo_push;
wire               mreq_fifo_pop;
wire               mreq_fwrd_sel;
wire               mreq_read_wire;
wire               mreq_write_wire;
wire [BITXATR-1:0] mreq_datr_wire;
wire [BITXSIZ-1:0] mreq_size_wire;
wire [BITXTYP-1:0] mreq_type_wire;
wire [BITXATR-1:0] mreq_catr_wire;
wire [BITXSEQ-1:0] mreq_id_wire;
wire [BITXADR-1:0] mreq_addr_wire;
wire [WIDTH-1:0]   mreq_din_wire;
reg                mreq_read_reg;
reg                mreq_write_reg;
reg  [BITXSIZ-1:0] mreq_size_reg;
reg  [BITXTYP-1:0] mreq_type_reg;
reg  [BITXATR-1:0] mreq_catr_reg;
reg  [BITXSEQ-1:0] mreq_id_reg;
reg  [BITXADR-1:0] mreq_addr_reg;
reg  [WIDTH-1:0]   mreq_din_reg;

reg  ucach_wack_reg;
wire ucach_wack_vld;
wire [BITXATR-1:0]ucach_wack_attr = {BITXATR{1'b0}} | (1 << NXARBLST);
wire ucach_wack_wire = t2_writeA_wire && t2_ucachA && !spnd_ack[t2_sqinA];

assign mreq_read_wire  = t2_readA;
assign mreq_write_wire = t2_writeA_wire;
assign mreq_datr_wire  = {BITXATR{1'b0}} | (1 << NXADBLST);
assign mreq_size_wire  = t2_ucachA ? t2_ucsizeA : BYTWDTH;
assign mreq_type_wire  = (t2_readA ? NXTEREAD : (t2_writeA_wire ? NXTEWRIT : NXTERSVD));
assign mreq_catr_wire  = {BITXATR{1'b0}} | (!t2_ucachA << NXACBCCH) | (((t2_writeA_wire && t2_ucachA && spnd_ack[t2_sqinA]) || t2_readA) << NXACBACK);
assign mreq_id_wire    = t2_sqinA;
assign mreq_addr_wire  = t2_ucachA ? {t2_ucpfxA,t2_addrA,t2_ucofstA} : ({BITXADR{1'b0}} | (t2_addrA << BITBYTS));
assign mreq_din_wire   = t2_writeA_wire ? t2_dinA : {WIDTH{1'b0}};

assign mreq_fifo_push  = mreq_read_wire || mreq_write_wire;
assign mreq_fifo_pop   = !mreq_fifo_empty && ((!m_creq_rdstall && mreq_read_reg ) || ((!m_creq_wrstall && !m_dreq_stall) && mreq_write_reg));

fifo_basic #(
  .DEPTH(MQFFCNT),
  .LG_DEPTH(BITMQFF),
  .WIDTH(1+1+BITXSIZ+BITXTYP+BITXATR+BITXSEQ+BITXADR+WIDTH+1+1))
 mreq_fifo (
  .rst(rst),
  .clk(clk),
  .ready(),
  .full(mreq_fifo_full),
  .empty(mreq_fifo_empty),
  .pu_en(mreq_fifo_push),
  .pu_data({ucach_wack_wire,lret_vld_wire,mreq_size_wire,mreq_type_wire,mreq_catr_wire,mreq_id_wire,mreq_addr_wire,mreq_din_wire,mreq_write_wire,mreq_read_wire}),
  .po_en (mreq_fifo_pop),
  .po_data({ucach_wack_reg, lret_vld_reg, mreq_size_reg, mreq_type_reg, mreq_catr_reg, mreq_id_reg, mreq_addr_reg, mreq_din_reg, mreq_write_reg, mreq_read_reg })
);

assign rmap_1     = lret_vld_reg && mreq_fifo_pop;
assign rmap_rid_1 = mreq_id_reg; 
assign ucach_wack_vld = ucach_wack_reg && mreq_fifo_pop;

assign m_creq_valid   = mreq_fifo_pop; 
assign m_creq_type    = mreq_type_reg;
assign m_creq_attr    = mreq_catr_reg;
assign m_creq_size    = mreq_size_reg;
assign m_creq_id      = mreq_id_reg;
assign m_creq_addr    = mreq_addr_reg; 
assign m_dreq_valid   = mreq_write_reg && mreq_fifo_pop;
assign m_dreq_id      = mreq_id_reg;
assign m_dreq_data    = mreq_din_reg;
assign m_dreq_attr    = mreq_datr_wire; 
assign t2_vldA        = (ucach_wack_vld || m_rreq_valid) && !t2_stallA;
assign t2_sqoutA      = ucach_wack_vld ? mreq_id_reg : m_rreq_id;
assign t2_attrA       = (ucach_wack_vld ? ucach_wack_attr : m_rreq_attr) & ({BITXATR{1'b0}} | (1<<NXARBAER) | (1<<NXARBDER));
assign t2_doutA       = m_rreq_data;
assign m_rreq_stall   = ucach_wack_vld || t2_stallA;
assign t2_blockA      = m_creq_rdstall || m_creq_wrstall;

assign t1_readA       = sreq_read;
assign t1_writeA      = sreq_write;
assign t1_flushA      = sreq_flush;
assign t1_invldA      = sreq_invld;
assign t1_sidxA       = sreq_sidx;
assign t1_ucachA      = sreq_ucach;
assign t1_ucofstA     = sreq_ucofs;
assign t1_ucsizeA     = sreq_ucsiz;
assign t1_ucpfxA      = sreq_ucpfx;
assign t1_sqinA       = sreq_seq;
assign t1_addrA       = sreq_addr;
assign t1_byinA       = sreq_byin;
assign t1_dinA        = sreq_din;

assign cpu_stall      = spnd_full || sreq_stall || t1_stallA;
assign s_creq_rdstall = cpu_stall; 
assign s_creq_wrstall = cpu_stall; 
assign s_dreq_stall   = cpu_stall;

assign s_rreq_valid   = srsp_vld;
assign s_rreq_id      = srsp_id;
assign s_rreq_data    = srsp_data;
assign s_rreq_attr    = srsp_attr;
assign e_l2err_vld    = srsp_ferr;

assign mfifo_empty    = mreq_fifo_empty;

// -----------------------------------------------------------------------------
// software interface
// -----------------------------------------------------------------------------

`ifdef CACHE_DBG

  assert_l2_req_fifo_overflow: assert property (@(posedge clk) disable iff (rst) mreq_fifo_push |-> !mreq_fifo_full)
  else $display("[ERROR:memoir:%m:%0t] L2 request FIFO overflow", $time);

`endif

assign dbg_la_sreq_stall = sreq_stall; 
assign dbg_la_sreq_vld = sreq_vld;
assign dbg_la_sreq_fid = sreq_fid;
assign dbg_la_sreq_map_vld = sreq_map_vld;
assign dbg_la_sreq_rid = sreq_rid;
assign dbg_la_spnd_frcnt = spnd_frcnt;
assign dbg_la_spnd_ack = spnd_ack;
assign dbg_la_rmap_0 = rmap_0;
assign dbg_la_rmap_rid_0 = rmap_rid_0;
assign dbg_la_rmap_1 = rmap_1;
assign dbg_la_rmap_rid_1 = rmap_rid_1;
assign dbg_la_late_retire  =  late_retire;
assign dbg_la_mreq_fifo_full  =  mreq_fifo_full;
assign dbg_la_mreq_fifo_empty =  mreq_fifo_empty;
assign dbg_la_mreq_fifo_push  =  mreq_fifo_push;
assign dbg_la_ucach_wack_reg  =  ucach_wack_reg;

endmodule // core_pxmqxs_cache_1rw

