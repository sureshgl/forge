module algo_1xm1xs_bdg_c6_sva_wrap #(
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
    t2_writeA, t2_addrA, t2_dinA, t2_bwA, t2_readB, t2_addrB, t2_doutB
  ); 

  parameter BITWDTH = IP_BITWIDTH;
  parameter WIDTH = IP_WIDTH;
  parameter BYTWDTH = WIDTH/8;
  parameter BITBYTS = BITWDTH - 3;
  parameter ENAPAR = 1;
  parameter ENAECC = 0;
  parameter ECCWDTH = 5;
  parameter NUMRWPT = 1;
  parameter BITADDR = 31-BITBYTS;
  parameter NUMVTAG = T1_NUMVROW; 
  parameter BITVTAG = T1_BITVROW;
  parameter NUMVROW = T2_NUMVROW; 
  parameter BITVROW = T2_BITVROW;
  parameter NUMWRDS = 4;
  parameter BITWRDS = 2;
  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 2;
  parameter FLOPECC = 0;
  parameter FLOPCMD = 0;
  parameter FLOPIN = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;

  parameter FIFOCNT = 4;
  parameter BITFIFO = 2;

  parameter NXTNOWR = 1;  // disable naxi write
  parameter NXTNOFL = 1;  // disable naxi flush
  parameter NXTNOIV = 0;  // disable naxi invalidate

  parameter BITXTYP = 3;
  parameter BITXADR = BITADDR+BITBYTS;
  parameter BITXATR = 3;
  parameter BITXSIZ = 8;
  parameter BITXSEQ = 3;
  parameter NXWIDTH = 256;
  parameter NXBTCNT = 1; // data beat count
  parameter BITXDBT = 0; // data beat count bits

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

  input                                m_creq_valid;
  input   [BITXTYP-1:0]                m_creq_type;
  input   [BITXATR-1:0]                m_creq_attr;
  input   [BITXSIZ-1:0]                m_creq_size;
  input   [BITXSEQ-1:0]                m_creq_id;
  input   [BITXADR-1:0]                m_creq_addr;
  input                                m_creq_rdstall;
  input                                m_creq_wrstall;

  input                                m_dreq_valid;
  input   [BITXSEQ-1:0]                m_dreq_id;
  input   [NXWIDTH-1:0]                m_dreq_data;
  input   [BITXATR-1:0]                m_dreq_attr;
  input                                m_dreq_stall;

  input                                m_rreq_valid;
  input   [BITXSEQ-1:0]                m_rreq_id;
  input   [NXWIDTH-1:0]                m_rreq_data;
  input   [BITXATR-1:0]                m_rreq_attr;
  input                                m_rreq_stall;

  input                                s_creq_valid;
  input   [BITXTYP-1:0]                s_creq_type;
  input   [BITXATR-1:0]                s_creq_attr;
  input   [BITXSIZ-1:0]                s_creq_size;
  input   [BITXSEQ-1:0]                s_creq_id;
  input   [BITXADR-1:0]                s_creq_addr;
  input                                s_creq_rdstall;
  input                                s_creq_wrstall;

  input                                s_dreq_valid;
  input   [BITXSEQ-1:0]                s_dreq_id;
  input   [NXWIDTH-1:0]                s_dreq_data;
  input   [BITXATR-1:0]                s_dreq_attr;
  input                                s_dreq_stall;

  input                                s_rreq_valid;
  input   [BITXSEQ-1:0]                s_rreq_id;
  input   [NXWIDTH-1:0]                s_rreq_data;
  input   [BITXATR-1:0]                s_rreq_attr;
  input                                s_rreq_stall;

  input   [NUMRWPT-1:0]                t1_writeA;
  input   [NUMRWPT*BITVTAG-1:0]        t1_addrA;
  input   [NUMRWPT*TAGWDTH-1:0]        t1_dinA;
  input   [NUMRWPT*TAGWDTH-1:0]        t1_bwA;
  input   [NUMRWPT-1:0]                t1_readB;
  input   [NUMRWPT*BITVTAG-1:0]        t1_addrB;
  input   [NUMRWPT*TAGWDTH-1:0]        t1_doutB;

  input   [NUMRWPT-1:0]                t2_writeA;
  input   [NUMRWPT*BITVROW-1:0]        t2_addrA;
  input   [NUMRWPT*PHYWDTH-1:0]        t2_dinA;
  input   [NUMRWPT*PHYWDTH-1:0]        t2_bwA;
  input   [NUMRWPT-1:0]                t2_readB;
  input   [NUMRWPT*BITVROW-1:0]        t2_addrB;
  input   [NUMRWPT*PHYWDTH-1:0]        t2_doutB;

  input                                ready;
  input                                clk;
  input                                rst;

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

  localparam NUMXSEQ = (1 << BITXSEQ);

  // --------------------------------------------------------------------------
  // Slave NAXI interface - command side
  // --------------------------------------------------------------------------

  assume_snaxi_bad_cmd: assert property (@(posedge clk) disable iff (rst) s_creq_valid |-> ((s_creq_type == NXTEWRIT) || (s_creq_type == NXTEREAD) || (s_creq_type == NXTEFLUS) || (s_creq_type == NXTEINVD)))
  else $display("[ERROR:memoir:%m:%0t] bad command type creq_type=0x%0x", $time, s_creq_type);

  assume_snaxi_bad_seq: assert property (@(posedge clk) disable iff (rst) s_creq_valid |-> (s_creq_id < NUMXSEQ))
  else $display("[ERROR:memoir:%m:%0t request ID out of range id=0x%0x", $time, s_creq_id);

  assume_snaxi_write_cmd_creq_dreq: assert property (@(posedge clk) disable iff (rst) (s_creq_valid && (s_creq_type == NXTEWRIT)) |-> (s_dreq_valid && (s_creq_id == s_dreq_id)))
  else $display("[ERROR:memoir:%m:%0t] write cmd => dreq_vld and sequence numbers match cseq=0x%0x dseq=0x%0x", $time, s_creq_id, s_dreq_id);

  assume_snaxi_not_expecting_write_cmd: assert property (@(posedge clk) disable iff (rst) s_creq_valid |-> !((s_creq_type == NXTEWRIT) && (NXTNOWR==1)))
  else $display("[ERROR:memoir:%m:%0t] not expecting write command ", $time);
  
  assume_snaxi_not_expecting_flush_cmd: assert property (@(posedge clk) disable iff (rst) s_creq_valid |-> !((s_creq_type == NXTEFLUS) && (NXTNOFL==1)))
  else $display("[ERROR:memoir:%m:%0t] not expecting flush command", $time);

  assume_snaxi_not_expecting_invalidate_cmd: assert property (@(posedge clk) disable iff (rst) s_creq_valid |-> !((s_creq_type == NXTEINVD) && (NXTNOIV==1)))
  else $display("[ERROR:memoir:%m:%0t] not expecting invalidate command", $time);

  assume_snaxi_read_no_dreq_vld: assert property (@(posedge clk) disable iff (rst) s_creq_valid |-> !((s_creq_type==NXTEREAD)  && s_dreq_valid))
  else $display("[ERROR:memoir:%m:%0t] not expecting data valid for read command", $time);

  assume_snaxi_flush_no_dreq_vld: assert property (@(posedge clk) disable iff (rst) s_creq_valid |-> !((s_creq_type==NXTEFLUS) && s_dreq_valid))
  else $display("[ERROR:memoir:%m:%0t] not expecting data valid for flush command", $time);
  
  assume_snaxi_invalidate_no_deq_vld: assert property (@(posedge clk) disable iff (rst) s_creq_valid |->!((s_creq_type==NXTEINVD) && s_dreq_valid))
  else $display("[ERROR:memoir:%m:%0t] not expecting data valid for invalidate command", $time);

  assume_snaxi_flush_line_size: assert property (@(posedge clk) disable iff (rst) (s_creq_valid && (s_creq_type==NXTEFLUS)) |-> (s_creq_addr[BITXDBT+BITBYTS-1:0] == 0))
  else $display("[ERROR:memoir:%m:%0t] flush cmd addr not lize aligned", $time);

  assume_snaxi_invalidate_line_size: assert property (@(posedge clk) disable iff (rst) (s_creq_valid && (s_creq_type==NXTEINVD)) |-> (s_creq_addr[BITXDBT+BITBYTS-1:0] == 0))
  else $display("[ERROR:memoir:%m:%0t] invalidate cmd addr not lize aligned", $time);
  
  assume_snaxi_flush_cached_only: assert property (@(posedge clk) disable iff (rst) (s_creq_valid && (s_creq_type==NXTEFLUS)) |-> s_creq_attr[NXACBCCH])
  else $display("[ERROR:memoir:%m:%0t] flush to non-cacheble address", $time);

  assume_snaxi_invalidate_cached_only: assert property (@(posedge clk) disable iff (rst) (s_creq_valid && (s_creq_type==NXTEINVD)) |-> s_creq_attr[NXACBCCH])
  else $display("[ERROR:memoir:%m:%0t] invalidate to non-cacheble address", $time);

  wire [BITXSIZ-1:0] sreq_size_m1  = (s_creq_size[BITXSIZ-1:0] - 1); 
  wire [BITXSIZ:0]   sreq_size_act = sreq_size_m1 + 1'b1;
  wire [BITBYTS:0]   sreq_size_ovr = s_creq_addr[BITBYTS-1:0] + s_creq_size[BITBYTS-1:0];
  wire [BITXDBT-1:0] sreq_stbt     = s_creq_addr >> BITBYTS;
  wire [BITXDBT:0]   sreq_bcnt     = (sreq_size_act >> BITBYTS) + (sreq_size_ovr >> BITBYTS) + (|sreq_size_ovr[BITBYTS-1:0]);
  wire [BITXADR:0]   sreq_sadr     = (s_creq_addr << 1) >> 1;
  wire [BITXADR:0]   sreq_eadr     = (sreq_sadr + sreq_size_act) - 1'b1;

  reg [BITADDR-1:0] spnd_addr [0:NUMXSEQ-1];
  reg [BITXDBT:0]   spnd_bcnt [0:NUMXSEQ-1];
  reg               spnd_ack  [0:NUMXSEQ-1];
  reg               spnd_rd   [0:NUMXSEQ-1];
  reg               spnd_uch  [0:NUMXSEQ-1];
  always @(posedge clk)
    if (s_creq_valid) begin
      spnd_addr[s_creq_id] <= s_creq_addr;
      spnd_ack[s_creq_id]  <= s_creq_attr[NXACBACK];
      spnd_uch[s_creq_id]  <= s_creq_attr[NXACBCCH];
      spnd_bcnt[s_creq_id] <= sreq_bcnt;
      spnd_rd[s_creq_id]   <= (s_creq_type == NXTEREAD);
    end

  reg [BITXSEQ-1:0] swr_seq;
  reg [BITXDBT:0]   swr_bcnt;
  always @(posedge clk)
    if (s_creq_valid && (s_creq_type == NXTEWRIT) && !(s_creq_rdstall || s_creq_wrstall || s_dreq_stall) && s_dreq_valid) begin
      swr_seq  <= s_creq_id;
      swr_bcnt <= sreq_bcnt - 1'b1;
    end else if (s_dreq_valid && !s_dreq_stall)
      swr_bcnt <= swr_bcnt - 1'b1;
  wire swr_bip = |swr_bcnt;

  assume_snaxi_flit_overlap: assert property (@(posedge clk) disable iff (rst) s_creq_valid |-> (sreq_sadr[BITXADR:BITXDBT+BITBYTS] == sreq_eadr[BITXADR:BITXDBT+BITBYTS]))
  else $display("[ERROR:memoir:%m:%0t] request crosses flit boundary", $time);

  assume_snaxi_bad_size: assert property (@(posedge clk) disable iff (rst) s_creq_valid |-> (sreq_size_act <= (NXBTCNT * (NXWIDTH >> 3))))
  else $display("[ERROR:memoir:%m:%0t] req size > line size size=%0d", $time, sreq_size_act);
  
  assume_snaxi_too_many_beats: assert property (@(posedge clk) disable iff (rst) s_creq_valid |-> (sreq_bcnt <= NXBTCNT))
  else $display("[ERROR:memoir:%m:%0t] too many beats %0d", $time, sreq_bcnt);

  assume_snaxi_zero_beats: assert property (@(posedge clk) disable iff (rst) s_creq_valid |-> (sreq_bcnt != 0))
  else $display("[ERROR:memoir:%m:%0t] zero beats %0d", $time, sreq_bcnt);

  assume_snaxi_data_no_last: assert property (@(posedge clk) disable iff (rst) (s_dreq_valid && (swr_bcnt == 1)) |-> s_dreq_attr[NXADBLST])
  else $display("[ERROR:memoir:%m:%0t] expecting last beat", $time);

  assume_snaxi_data_id_change: assert property (@(posedge clk) disable iff (rst) (s_dreq_valid && swr_bip) |-> (s_dreq_id == swr_seq))
  else $display("[ERROR:memoir:%m:%0t] sequence number changed for data beats before last seen", $time);
  
  assert_snaxi_stalls_all_or_none: assert property (@(posedge clk) disable iff (rst) ((s_creq_rdstall && s_creq_wrstall && s_dreq_stall) || !(s_creq_rdstall || s_creq_wrstall || s_dreq_stall)))
  else $display("[ERROR:memoir:%m:%0t] stalls must all be asserted or deasserted", $time);

  // --------------------------------------------------------------------------
  // Slave NAXI interface - response side
  // --------------------------------------------------------------------------

  assume_snaxi_response_no_stalls: assert property (@(posedge clk) disable iff (rst) !s_rreq_stall)
  else $display("[ERROR:memoir:%m:%0t] not expecting stall on response bus", $time);
  
  assert_snaxi_response_not_expected: assert property (@(posedge clk) disable iff (rst) s_rreq_valid |-> spnd_ack[s_rreq_id])
  else $display("[ERROR:memoir:%m:%0t] not expecting response", $time);

  reg [BITXSEQ-1:0] srd_seq;
  reg [BITXDBT:0]   srd_bcnt;
  reg [BITXSEQ-1:0] srd_seq_nxt;
  reg [BITXDBT:0]   srd_bcnt_nxt;
  always @(posedge clk)
    if (rst)
      srd_bcnt <= 0;
    else begin
      srd_bcnt <= srd_bcnt_nxt; 
      srd_seq  <= srd_seq_nxt;
    end 
  
  always_comb begin
    srd_bcnt_nxt = 0;
    srd_seq_nxt  = srd_seq;
    if (s_rreq_valid && !s_rreq_stall && spnd_rd[s_rreq_id] && !(|srd_bcnt)) begin
      srd_bcnt_nxt = spnd_bcnt[s_rreq_id] - 1'b1;
      srd_seq_nxt  = s_rreq_id;
    end else if (s_rreq_valid && !s_rreq_stall && spnd_rd[s_rreq_id])
      srd_bcnt_nxt = srd_bcnt - 1'b1;
    else if (|srd_bcnt)
      srd_bcnt_nxt = srd_bcnt;
  end
  wire srd_bip = |srd_bcnt;

  assert_snaxi_response_no_last: assert property (@(posedge clk) disable iff (rst) (s_rreq_valid && !s_rreq_stall && (srd_bcnt_nxt == 0)) |-> s_rreq_attr[NXADBLST])
  else $display("[ERROR:memoir:%m:%0t response data last expected", $time);

  assert_snaxi_response_id_change: assert property (@(posedge clk) disable iff (rst) (s_rreq_valid && srd_bip) |-> (s_rreq_id == srd_seq))
  else $display("[ERROR:memoir:%m:%0t] sequence number changed for resp data beats before last seen", $time);

  // NAXI master side

  // TBD multiple req to same seq number with ack

  // --------------------------------------------------------------------------
  // Master NAXI interface - command side
  // --------------------------------------------------------------------------
  assert_mnaxi_bad_req_type: assert property (@(posedge clk) disable iff (rst) m_creq_valid |-> ((m_creq_type == NXTEREAD) || (m_creq_type == NXTEWRIT)))
  else $display("[ERROR:memoir:%m:%0t] bad command type creq_type=0x%0x", $time, m_creq_type);

  assert_mnaxi_bad_seq: assert property (@(posedge clk) disable iff (rst) m_creq_valid |-> (m_creq_id < NUMXSEQ))
  else $display("[ERROR:memoir:%m:%0t request ID out of range id=0x%0x", $time, m_creq_id);

  assert_mnaxi_write_cmd_creq_dreq: assert property (@(posedge clk) disable iff (rst) (m_creq_valid && (m_creq_type == NXTEWRIT)) |-> (m_dreq_valid && (m_creq_id == m_dreq_id)))
  else $display("[ERROR:memoir:%m:%0t] write cmd => dreq_vld and sequence numbers match cseq=0x%0x dseq=0x%0x", $time, m_creq_id, m_dreq_id);

  assert_mnaxi_not_expecting_write_cmd: assert property (@(posedge clk) disable iff (rst) m_creq_valid  |-> !((m_creq_type == NXTEWRIT) && ((NXTNOWR==1))))
  else $display("[ERROR:memoir:%m:%0t] not expecting write command ", $time);
  
  assert_mnaxi_not_expecting_flush_cmd: assert property (@(posedge clk) disable iff (rst) m_creq_valid |-> !(m_creq_type == NXTEFLUS))
  else $display("[ERROR:memoir:%m:%0t] not expecting flush command", $time);

  assert_mnaxi_not_expecting_invalidate_cmd: assert property (@(posedge clk) disable iff (rst) m_creq_valid |-> !(m_creq_type == NXTEINVD))
  else $display("[ERROR:memoir:%m:%0t] not expecting invalidate command", $time);

  assert_mnaxi_read_no_dreq_vld: assert property (@(posedge clk) disable iff (rst) m_creq_valid |-> !(m_dreq_valid && (m_creq_type==NXTEREAD)))
  else $display("[ERROR:memoir:%m:%0t] not expecting data valid for read command", $time);

  assert_mnaxi_cach_addr_bad_offset: assert property (@(posedge clk) disable iff (rst) m_creq_valid |-> !(m_creq_attr[NXACBCCH] && (|m_creq_addr[BITXDBT+BITBYTS-1:0])))
  else $display("[ERROR:memoir:%m:%0t] cacheable request address with non-zero offset", $time);

  assert_mnaxi_cach_rd_no_ack: assert property (@(posedge clk) disable iff (rst) (m_creq_valid && (m_creq_type==NXTEREAD) && (m_creq_attr[NXACBCCH])) |-> m_creq_attr[NXACBACK])
  else $display("[ERROR:memoir:%m:%0t] cacheable reads must have ack bit set", $time);
  
  assert_mnaxi_cach_wr_ack: assert property (@(posedge clk) disable iff (rst) (m_creq_valid && (m_creq_type==NXTEWRIT) && (m_creq_attr[NXACBCCH])) |-> !m_creq_attr[NXACBACK])
  else $display("[ERROR:memoir:%m:%0t] cacheable writes must not have ack bit set", $time);
  
  wire [BITXSIZ-1:0] mreq_size_m1  = (m_creq_size[BITXSIZ-1:0] - 1); 
  wire [BITXSIZ:0]   mreq_size_act = mreq_size_m1 + 1'b1;
  wire [BITBYTS:0]   mreq_size_ovr = m_creq_addr[BITBYTS-1:0] + m_creq_size[BITBYTS-1:0];
  wire [BITXDBT-1:0] mreq_stbt     = m_creq_addr >> BITBYTS;
  wire [BITXDBT:0]   mreq_bcnt     = (mreq_size_act >> BITBYTS) + (mreq_size_ovr >> BITBYTS) + (|mreq_size_ovr[BITBYTS-1:0]);
  wire [BITXADR:0]   mreq_sadr     = (m_creq_addr << 1) >> 1;
  wire [BITXADR:0]   mreq_eadr     = (mreq_sadr + mreq_size_act) - 1'b1;

  reg [BITADDR-1:0] mpnd_addr [0:NUMXSEQ-1];
  reg [BITXDBT:0]   mpnd_bcnt [0:NUMXSEQ-1];
  reg               mpnd_ack  [0:NUMXSEQ-1];
  reg               mpnd_rd   [0:NUMXSEQ-1];
  reg               mpnd_uch  [0:NUMXSEQ-1];
  always @(posedge clk)
    if (m_creq_valid) begin
      mpnd_addr[m_creq_id] <= m_creq_addr;
      mpnd_ack[m_creq_id]  <= m_creq_attr[NXACBACK];
      mpnd_uch[m_creq_id]  <= m_creq_attr[NXACBCCH];
      mpnd_bcnt[m_creq_id] <= mreq_bcnt;
      mpnd_rd[m_creq_id]   <= (m_creq_type == NXTEREAD);
    end

  reg [BITXSEQ-1:0] mwr_seq;
  reg [BITXDBT:0]   mwr_bcnt;
  always @(posedge clk)
    if (m_creq_valid && (m_creq_type == NXTEWRIT) && !(m_creq_rdstall || m_creq_wrstall || m_dreq_stall) && m_dreq_valid) begin
      mwr_seq  <= m_creq_id;
      mwr_bcnt <= mreq_bcnt - 1'b1;
    end else if (m_dreq_valid)
      mwr_bcnt <= mwr_bcnt - 1'b1;
  wire mwr_bip = |mwr_bcnt;

  assert_mnaxi_flit_overlap: assert property (@(posedge clk) disable iff (rst) m_creq_valid |-> (mreq_sadr[BITXADR:BITXDBT+BITBYTS] == mreq_eadr[BITXADR:BITXDBT+BITBYTS]))
  else $display("[ERROR:memoir:%m:%0t] request crosses flit boundary", $time);

  assert_mnaxi_cach_line_size: assert property (@(posedge clk) disable iff (rst) m_creq_valid |-> !(m_creq_attr[NXACBCCH] && (mreq_size_act != (NXBTCNT * (NXWIDTH>>3)))))
  else $display("[ERROR:memoir:%m:%0t] cacheable request not line sized", $time);

  assert_mnaxi_bad_size: assert property (@(posedge clk) disable iff (rst) m_creq_valid |-> (mreq_size_act <= (NXBTCNT * (NXWIDTH >> 3))))
  else $display("[ERROR:memoir:%m:%0t] req size > line size size=%0d", $time, mreq_size_act);
  
  assert_mnaxi_too_many_beats: assert property (@(posedge clk) disable iff (rst) m_creq_valid |-> (mreq_bcnt <= NXBTCNT))
  else $display("[ERROR:memoir:%m:%0t] too many beats %0d", $time, mreq_bcnt);

  assert_mnaxi_zero_beats: assert property (@(posedge clk) disable iff (rst) m_creq_valid |-> (mreq_bcnt != 0))
  else $display("[ERROR:memoir:%m:%0t] zero beats %0d", $time, mreq_bcnt);

  assert_mnaxi_data_no_last: assert property (@(posedge clk) disable iff (rst) (m_dreq_valid && (mwr_bcnt == 1)) |-> m_dreq_attr[NXADBLST])
  else $display("[ERROR:memoir:%m:%0t] expecting last beat", $time);

  assert_mnaxi_data_id_change: assert property (@(posedge clk) disable iff (rst) (m_dreq_valid && mwr_bip) |-> (m_dreq_id == mwr_seq))
  else $display("[ERROR:memoir:%m:%0t] sequence number changed for data beats before last seen", $time);
  
  assert_mnaxi_stalls_all_or_none: assert property (@(posedge clk) disable iff (rst) ((m_creq_rdstall && m_creq_wrstall && m_dreq_stall) || !(m_creq_rdstall || m_creq_wrstall || m_dreq_stall)))
  else $display("[ERROR:memoir:%m:%0t] stalls must all be asserted or deasserted", $time);

  // --------------------------------------------------------------------------
  // Master NAXI interface - response side
  // --------------------------------------------------------------------------

  assert_mnaxi_response_not_expected: assert property (@(posedge clk) disable iff (rst) m_rreq_valid |-> mpnd_ack[m_rreq_id])
  else $display("[ERROR:memoir:%m:%0t] not expecting response", $time);

  reg [BITXSEQ-1:0] mrd_seq;
  reg [BITXDBT:0]   mrd_bcnt;
  reg [BITXSEQ-1:0] mrd_seq_nxt;
  reg [BITXDBT:0]   mrd_bcnt_nxt;
  always @(posedge clk)
    if (rst)
      mrd_bcnt <= 0;
    else begin
      mrd_bcnt <= mrd_bcnt_nxt; 
      mrd_seq  <= mrd_seq_nxt;
    end 
  
  always_comb begin
    mrd_bcnt_nxt = 0;
    mrd_seq_nxt  = mrd_seq;
    if (m_rreq_valid && !m_rreq_stall && mpnd_rd[m_rreq_id] && !(|mrd_bcnt)) begin
      mrd_bcnt_nxt = mpnd_bcnt[m_rreq_id] - 1'b1;
      mrd_seq_nxt  = m_rreq_id;
    end else if (m_rreq_valid && !m_rreq_stall && mpnd_rd[m_rreq_id])
      mrd_bcnt_nxt = mrd_bcnt - 1'b1;
    else if (|mrd_bcnt)
      mrd_bcnt_nxt = mrd_bcnt;
  end
  wire mrd_bip = |mrd_bcnt;

  assert_mnaxi_response_no_last: assert property (@(posedge clk) disable iff (rst) (m_rreq_valid && !m_rreq_stall && (mrd_bcnt_nxt == 0)) |-> m_rreq_attr[NXADBLST])
  else $display("[ERROR:memoir:%m:%0t response data last expected", $time);

  assert_mnaxi_response_id_change: assert property (@(posedge clk) disable iff (rst) (m_rreq_valid && mrd_bip) |-> (m_rreq_id == mrd_seq))
  else $display("[ERROR:memoir:%m:%0t] sequence number changed for resp data beats before last seen", $time);


endmodule // algo_1xm1xs_bdg_c6_sva_wrap

