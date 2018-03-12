/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
class MemoryTransactor #(AW=9, DW=32, WORDS=256, CHK_READ_VLD=1, CHK_READ_ERR=1, LATENCY=2);
  string name;
  virtual mem_r_ifc  #(AW, DW, LATENCY)  r_ifc[];
  virtual mem_w_ifc  #(AW, DW)           w_ifc[];
  virtual mem_rw_ifc #(AW, DW, LATENCY) rw_ifc[];
  virtual mem_c_ifc  #(AW, DW)           c_ifc[];
  virtual mem_a_ifc #(AW, DW, LATENCY)   a_ifc[];
  virtual mem_rw_ifc #(AW, DW, LATENCY) ru_ifc[];
  virtual mem_dbg_ifc #(AW, WORDS, DW, LATENCY) dbg_ifc;
  virtual mem_misc_ifc misc_ifc;

  int     op_stats [memory_op];

  int     ReadIdStart = 0;
  int     WriteIdStart = 0;
  int     RWIdStart = 0;
  int     CIdStart = 0;
  int     AIdStart = 0;
  int     RUIdStart = 0;
  int     RefreshIdStart = 0;

  bit [DW-1:0] mem [int];

  mailbox      rreq[int];
  mailbox      rexp[int];
  mailbox      wreq[int];
  mailbox      rwreq[int];
  mailbox      rwexp[int];
  mailbox      creq[int];
  mailbox      areq[int];
  mailbox      aexp[int];
  mailbox      rureq[int];
  mailbox      ruexp[int];

  function new (string name);
    this.name = name;
    `DEBUG($psprintf("memory transactor AW=%0d DW=%0d WORDS=%0d", AW, DW, WORDS))
    if (WORDS > (1 << AW)) begin
      `FATAL("bad parameters supplied to memory model")
    end
    op_stats[MOP_NOP] = 0;
    op_stats[MOP_RD]  = 0;
    op_stats[MOP_WR]  = 0;
    op_stats[MOP_RDC] = 0;
    op_stats[MOP_C] = 0;
    op_stats[MOP_RU] = 0;
  endfunction

  task reset ();
    int i;  
    `DEBUG($psprintf("num_r_ports=%0d num_w_ports=%0d num_rw_ports=%0d num_refr_ports=%0d num_access_ports=%0d num_count_ports=%0d num_ru_ports=%0d", r_ifc.size(), w_ifc.size(), rw_ifc.size(), 0, a_ifc.size(), c_ifc.size(), ru_ifc.size()))
    ReadIdStart = 0;
    WriteIdStart    = ReadIdStart + r_ifc.size();
    RWIdStart       = WriteIdStart + w_ifc.size();
    CIdStart        = RWIdStart + rw_ifc.size();
    AIdStart        = CIdStart + c_ifc.size();
    RUIdStart       = AIdStart + a_ifc.size();
    RefreshIdStart  = RUIdStart + ru_ifc.size();
    `DEBUG($psprintf("start id R=%0d W=%0d RW=%0d C=%0d A=%0d RU=%0d Refr=%0d", ReadIdStart, WriteIdStart, RWIdStart, CIdStart, AIdStart, RUIdStart, RefreshIdStart))

    if (r_ifc.size())
      `DEBUG("resetting read ports")
    for(i=0;i<r_ifc.size();i++)  begin
      r_ifc[i].read    <= 0;
      r_ifc[i].addr    <= 0;
      rreq[ReadIdStart + i] = new();
      rexp[ReadIdStart + i] = new();
    end

    if (w_ifc.size())
      `DEBUG("resetting write ports")
    for(i=0;i<w_ifc.size();i++) begin
      w_ifc[i].write   <= 0;
      w_ifc[i].addr    <= 0;
      wreq[WriteIdStart + i] = new();
    end

    if (rw_ifc.size())
      `DEBUG("resetting read-write ports")
    for(i=0;i<rw_ifc.size();i++) begin
      rw_ifc[i].write   <= 0;
      rw_ifc[i].read    <= 0;
      rw_ifc[i].addr    <= 0;
      rwreq[RWIdStart + i] = new();
      rwexp[RWIdStart + i] = new();
    end
    
    if (c_ifc.size())
      `DEBUG("resetting count ports")
    for(i=0;i<c_ifc.size();i++) begin
      c_ifc[i].cnt       <= 0;
      c_ifc[i].ct_adr    <= 0;
      creq[CIdStart + i] = new();
    end

    if (a_ifc.size())
      `DEBUG("resetting access ports")
    for(i=0;i<a_ifc.size();i++) begin
      a_ifc[i].ac_write   <= 0;
      a_ifc[i].ac_read    <= 0;
      a_ifc[i].ac_addr    <= 0;
      areq[AIdStart + i] = new();
      aexp[AIdStart + i] = new();
    end

    if (ru_ifc.size())
      `DEBUG("resetting read-update ports")
    for(i=0;i<ru_ifc.size();i++) begin
      ru_ifc[i].write   <= 0;
      ru_ifc[i].read    <= 0;
      ru_ifc[i].addr    <= 0;
      rureq[RUIdStart + i] = new();
      ruexp[RUIdStart + i] = new();
    end
  endtask

  task run ();
    `DEBUG("run")
    fork
      sndr_rcvr();
    join_none
  endtask

  task automatic sndr_rcvr ();
    begin
      automatic int i;
      for(i=0;i<r_ifc.size();i++)  begin
        automatic int j = i;
        fork
          r_sndr(ReadIdStart + j);
          r_rcvr(ReadIdStart + j);
        join_none
      end
    end
    begin
      automatic int i;
      for(i=0;i< w_ifc.size();i++)  begin
        automatic int j = i;
        fork
          w_sndr(WriteIdStart + j);
        join_none
      end
    end
    begin
      automatic int i;
      for(i =0; i< rw_ifc.size(); i++) begin
        automatic int j = i;
        fork
          rw_sndr(RWIdStart + j);
          rw_rcvr(RWIdStart + j);
        join_none
      end
    end
    begin
      automatic int i;
      for(i =0; i< c_ifc.size(); i++) begin
        automatic int j = i;
        fork
          c_sndr(CIdStart + j);
        join_none
      end
    end
    begin
      automatic int i;
      for(i =0; i< a_ifc.size(); i++) begin
        automatic int j = i;
        fork
          a_sndr(AIdStart + j);
          a_rcvr(AIdStart + j);
        join_none
      end
    end    
    begin
      automatic int i;
      for(i =0; i< ru_ifc.size(); i++) begin
        automatic int j = i;
        fork
          ru_sndr(RUIdStart + j);
          ru_rcvr(RUIdStart + j);
        join_none
      end
    end
  endtask

  task automatic r_sndr (int id);
    int r_id = id - ReadIdStart;
    `DEBUG($psprintf("starting r%0d sender ", id))
    while (1) begin
      MemoryTransaction #(AW,DW,WORDS) t;
      r_ifc[r_id].read   <= 0;
      rreq[id].get(t);
      update_stats(t);
      while (misc_ifc.refr)
        step(1);
      if (!t.is_read() & !t.is_nop()) begin
        `ERROR($psprintf("r%0d bad op %s", id, t.sprint()))
      end
      r_ifc[r_id].read <= t.is_read();
      r_ifc[r_id].addr <= t.addr;
      if (!mem.exists(t.addr) & t.is_read()) begin
        `ERROR($psprintf("r%0d accessing location not previoualy written %s", id, t.sprint()))
      end
      if (t.is_read_check()) begin
        t.data    = mem[t.addr];
        rexp[id].put(t);
      end
      `TRACE($psprintf("r%0d %s", id, t.sprint()))
      step(1);
    end
  endtask

  task automatic w_sndr (int id);
    int w_id = id - WriteIdStart;
    `DEBUG($psprintf("starting w%0d sender ", id))
    while (1) begin
      MemoryTransaction #(AW,DW,WORDS) t;
      w_ifc[w_id].write   <= 0;
      wreq[id].get(t);
      update_stats(t);
      while (misc_ifc.refr)
        step(1);
      if (!t.is_write() & !t.is_nop()) begin
        `ERROR($psprintf("w%0d bad op %s", id, t.sprint()))
      end
      w_ifc[w_id].write   <= t.is_write();
      w_ifc[w_id].addr    <= t.addr;
      w_ifc[w_id].din     <= t.data;
      if (t.is_model_write()) begin
        #1; // delay write threads for data ordering
        mem[t.addr]         = t.data;
      end
        `TRACE($psprintf("w%0d %s", id, t.sprint()))
      step(1);
    end
  endtask

  task automatic rw_sndr (int id);
    int rw_id = id - RWIdStart;
    `DEBUG($psprintf("starting rw%0d sender ", id))
    while (1) begin
      MemoryTransaction #(AW,DW,WORDS) t;
      rw_ifc[rw_id].read  <= 0;
      rw_ifc[rw_id].write <= 0;
      rwreq[id].get(t);
      update_stats(t);
      while (misc_ifc.refr)
        step(1);
      rw_ifc[rw_id].read  <= t.is_read();
      rw_ifc[rw_id].write <= t.is_write();
      rw_ifc[rw_id].addr  <= t.addr;
      if (t.is_model_write()) begin
        rw_ifc[rw_id].din <= t.data;
      end
      if (!mem.exists(t.addr) & t.is_read()) begin
        `ERROR($psprintf("rw%0d accessing location not previoualy written %s", id, t.sprint()))
      end
      if (t.is_read_check()) begin
        t.data    = mem[t.addr];
        rwexp[id].put(t);
      end
      if (t.is_write()) begin
        #1; // delay write threads for data ordering
        mem[t.addr]     = t.data;
      end
      `TRACE($psprintf("rw%0d %s", id, t.sprint()))
      step(1);
    end
  endtask

  task automatic c_sndr (int id);
    int c_id = id - CIdStart;
    bit [DW:0] tdata;
    bit [DW-1:0] mdata;
    `DEBUG($psprintf("starting c%0d sender ", id))
    while (1) begin
      MemoryTransaction #(AW,DW,WORDS) t;
      c_ifc[c_id].cnt   <= 0;
      creq[id].get(t);
      update_stats(t);
      while (misc_ifc.refr)
        step(1);
      if (!t.is_count() & !t.is_nop()) begin
        `ERROR($psprintf("c%0d bad op %s", id, t.sprint()))
      end
      c_ifc[c_id].cnt       <= t.is_count();
      c_ifc[c_id].ct_adr    <= t.addr;
      c_ifc[c_id].ct_imm    <= t.data;      
      if (t.is_count()) begin
        #1; // delay write threads for data ordering
        tdata        = mem[t.addr] + t.data;
        mem[t.addr]  = {|tdata[DW:DW-1],tdata[DW-2:0]};
      end
      `TRACE($psprintf("c%0d %s", id, t.sprint()))
      step(1);
    end
  endtask

  task automatic a_sndr (int id);
    int a_id = id - AIdStart;
    `DEBUG($psprintf("starting a%0d sender ", id))
    while (1) begin
      MemoryTransaction #(AW,DW,WORDS) t;
      a_ifc[a_id].ac_read  <= 0;
      a_ifc[a_id].ac_write <= 0;
      areq[id].get(t);
      update_stats(t);
      
      while (misc_ifc.refr)
        step(1);

      a_ifc[a_id].ac_read  <= t.is_read();
      a_ifc[a_id].ac_write <= t.is_write();
      a_ifc[a_id].ac_addr  <= t.addr;
      if (t.is_write()) begin
        a_ifc[a_id].ac_din <= t.data;
      end else
        a_ifc[a_id].ac_din <= 0;
      if (!mem.exists(t.addr) & t.is_read()) begin
        `ERROR($psprintf("a%0d accessing location not previoualy written %s", id, t.sprint()))
      end
      if (t.is_read()) begin
        t.data    = mem[t.addr];
        aexp[id].put(t);
      end
      if (t.is_write()) begin
        #1; // delay write threads for data ordering
        mem[t.addr]     = t.data;
      end
      `TRACE($psprintf("a%0d %s", id, t.sprint()))
      step(1);
    end
  endtask

  task automatic ru_sndr (int id);
    int ru_id = id - RUIdStart;
    `DEBUG($psprintf("starting ru%0d sender ", id))
    while (1) begin
      MemoryTransaction #(AW,DW,WORDS) t;
      bit [DW-1:0] udata;
      ru_ifc[ru_id].read  <= 0;
      ru_ifc[ru_id].addr  <= 0;
      rureq[id].get(t);
      udata = t.data;
      update_stats(t);
      while (misc_ifc.refr)
        step(1);
      fork
        begin
          ru_ifc[ru_id].read  <= t.is_read();
          ru_ifc[ru_id].addr  <= t.addr;
          #1;
          t.data = mem[t.addr];
          if (t.is_read_check())
            ruexp[id].put(t);
          `TRACE($psprintf("ru%0d %s udata=0x%0x (r)", id, t.sprint(), udata));
        end
        begin
          step(LATENCY-1);
          if (t.is_ru_update()) begin
            `TRACE($psprintf("ru%0d %s udata=0x%0x (w)", id, t.sprint(), udata))
            mem[t.addr] = udata;
          end
          step(1);
          ru_ifc[ru_id].write <= t.is_ru_update();
          ru_ifc[ru_id].din   <= udata;
        end
      join_none
      step(1);
    end
  endtask
  
  task automatic r_rcvr (int id);
    int r_id = id - ReadIdStart;
    `DEBUG($psprintf("starting r%0d receiver ", id))
    while (1) begin
      MemoryTransaction #(AW,DW,WORDS) e;
      MemoryTransaction #(AW,DW,WORDS) a;
      if (r_ifc[r_id].read_d === 1'b1) begin
        if (rexp[id].num() == 0) begin
          `ERROR($psprintf("r%0d NOT expecting empty read expect queue", id))
        end
        rexp[id].get(e);
        if (e.is_read_check()) begin
          a = new ();
          a.data = r_ifc[r_id].dout;
          if (CHK_READ_VLD & !r_ifc[r_id].read_vld) begin
            `ERROR($psprintf("r%0d EXPECTING read vld", id))
          end
          if (CHK_READ_ERR & (r_ifc[r_id].read_serr | r_ifc[r_id].read_derr)) begin
            `ERROR($psprintf("r%0d NOT expecting read error", id))
          end
          if (e.data !== a.data) begin
            `ERROR($psprintf("r%0d data check failed addr=0x%0x exp=0x%0x act=0x%0x", id, e.addr, e.data, a.data))
          end else begin
            `TRACE($psprintf("r%0d data check passed addr=0x%0x exp=0x%0x act=0x%0x", id, e.addr, e.data, a.data))
          end
        end else begin
          `ERROR($psprintf("r%0d NOT expecting non-RDC op %s", id, e.sprint()))
        end
      end
      step(1);
    end
  endtask

  task automatic rw_rcvr (int id);
    int rw_id = id - RWIdStart;
    while (1) begin
      MemoryTransaction #(AW,DW,WORDS) e;
      MemoryTransaction #(AW,DW,WORDS) a;
      if (rw_ifc[rw_id].read_d === 1'b1) begin
        if (rwexp[id].num() == 0) begin
          `ERROR($psprintf("rw%0d NOT expecting empty read expect queue", id))
        end
        rwexp[id].get(e);
        if (e.is_read_check()) begin
          a = new ();
          a.data = rw_ifc[rw_id].dout;
          if (CHK_READ_VLD & !rw_ifc[rw_id].read_vld) begin
            `ERROR($psprintf("rw%0d EXPECTING read vld", id))
          end
          if (CHK_READ_ERR & (rw_ifc[rw_id].read_serr | rw_ifc[rw_id].read_derr)) begin
            `ERROR($psprintf("rw%0d NOT expecting read error", id))
          end
          if (e.data !== a.data) begin
            `ERROR($psprintf("rw%0d data check failed addr=0x%0x exp=0x%0x act=0x%0x", id, e.addr, e.data, a.data))
          end else begin
            `TRACE($psprintf("rw%0d data check passed addr=0x%0x exp=0x%0x act=0x%0x", id, e.addr, e.data, a.data))
          end
        end else begin
          `ERROR($psprintf("rw%0d NOT expecting non-RDC op %s", id, e.sprint()))
        end
      end
      step(1);
    end
  endtask

  task automatic a_rcvr (int id);
    int a_id = id - AIdStart;
    while (1) begin
      MemoryTransaction #(AW,DW,WORDS) e;
      MemoryTransaction #(AW,DW,WORDS) a;
      if (a_ifc[a_id].read_d === 1'b1) begin
        if (aexp[id].num() == 0) begin
          `ERROR($psprintf("a%0d NOT expecting empty read expect queue", id))
        end
        aexp[id].get(e);
        if (e.is_read()) begin
          a = new ();
          a.data = a_ifc[a_id].ac_dout;
          if (CHK_READ_VLD & !a_ifc[a_id].ac_vld) begin
            `ERROR($psprintf("a%0d EXPECTING access vld", id))
          end
          if (CHK_READ_ERR & (a_ifc[a_id].ac_serr | a_ifc[a_id].ac_derr)) begin
            `ERROR($psprintf("a%0d NOT expecting read error", id))
          end
          if (e.data !== a.data) begin
            `ERROR($psprintf("a%0d data check failed addr=0x%0x exp=0x%0x act=0x%0x", id, e.addr, e.data, a.data))
          end else begin
            `TRACE($psprintf("a%0d data check passed addr=0x%0x exp=0x%0x act=0x%0x", id, e.addr, e.data, a.data))
          end
        end else begin
          `ERROR($psprintf("a%0d NOT expecting non-RDC op %s", id, e.sprint()))
        end
      end
      step(1);
    end
  endtask

  task automatic step (int c);
    repeat (c) @ (posedge misc_ifc.clk);
  endtask

  task automatic ru_rcvr (int id);
    int ru_id = id - RUIdStart;
    while (1) begin
      MemoryTransaction #(AW,DW,WORDS) e;
      MemoryTransaction #(AW,DW,WORDS) a;
      ru_ifc[ru_id].write <= 0;
      if (ru_ifc[ru_id].read_d === 1'b1) begin
        if (ruexp[id].num() == 0) begin
          `ERROR($psprintf("ru%0d NOT expecting empty read expect queue", id))
        end
        ruexp[id].get(e);
        if (e.is_read_check()) begin
          a = new ();
          a.data = ru_ifc[ru_id].dout;
          if (CHK_READ_VLD & !ru_ifc[ru_id].read_vld) begin
            `ERROR($psprintf("ru%0d EXPECTING read vld", id))
          end
          if (CHK_READ_ERR & (ru_ifc[ru_id].read_serr | ru_ifc[ru_id].read_derr)) begin
            `ERROR($psprintf("ru%0d NOT expecting read error", id))
          end
          if (e.data !== a.data) begin
            `ERROR($psprintf("ru%0d data check failed addr=0x%0x exp=0x%0x act=0x%0x", id, e.addr, e.data, a.data))
          end else begin
            `TRACE($psprintf("ru%0d data check passed addr=0x%0x exp=0x%0x act=0x%0x", id, e.addr, e.data, a.data))
          end
        end else begin
          `ERROR($psprintf("ru%0d NOT expecting non-RDC op %s", id, e.sprint()))
        end
      end
      step(1);
    end
  endtask

  task send (int id, MemoryTransaction #(AW,DW,WORDS) t);
    if (wreq.exists(id))
      wreq[id].put(t);
    
    if (rreq.exists(id))
      rreq[id].put(t);
    
    if (rwreq.exists(id))
      rwreq[id].put(t);
    
    if(creq.exists(id))
      creq[id].put(t);    

    if(areq.exists(id))
      areq[id].put(t);

    if (rureq.exists(id))
      rureq[id].put(t);
  endtask

  function int get_r_pending_count ();
    int i;
    int s = 0;
    if (rreq.first(i))
      do begin
        s += rreq[i].num();
      end while (rreq.next(i));
    get_r_pending_count = s;
  endfunction

  function int get_w_pending_count ();
    int i;
    int s = 0;
    if (wreq.first(i))
      do begin
        s += wreq[i].num();
      end while (wreq.next(i));
    get_w_pending_count = s;
  endfunction

  function int get_rw_pending_count ();
    int i;
    int s = 0;
    if (rwreq.first(i))
      do begin
        s += rwreq[i].num();
      end while (rwreq.next(i));
    get_rw_pending_count = s;
  endfunction

  function int get_c_pending_count ();
    int i;
    int s = 0;
    if (areq.first(i))
      do begin
        s += areq[i].num();
      end while (areq.next(i));
    get_c_pending_count = s;
  endfunction
  
  function int get_a_pending_count ();
    int i;
    int s = 0;
    if (areq.first(i))
      do begin
        s += areq[i].num();
      end while (areq.next(i));
    get_a_pending_count = s;
  endfunction

  function int get_ru_pending_count ();
    int i;
    int s = 0;
    if (rureq.first(i))
      do begin
        s += rureq[i].num();
      end while (rureq.next(i));
    get_ru_pending_count = s;
  endfunction

  task wait_too_many();
    while (
           (get_r_pending_count() > 100) ||
           (get_w_pending_count() > 100) || 
           (get_rw_pending_count() > 100) ||
           (get_a_pending_count() > 100) ||
           (get_c_pending_count() > 100) ||
           (get_ru_pending_count() > 100)
           ) begin
      step (1);
    end    
  endtask

  function bit is_empty ();
    int i;
    bit s = 1;
    if (rreq.first(i))
      do begin
        s &= (rreq[i].num() == 0);
      end while (rreq.next(i));
    if (wreq.first(i))
      do begin
        s &= (wreq[i].num() == 0);
      end while (wreq.next(i));
    if (rwreq.first(i))
      do begin
        s &= (rwreq[i].num() == 0);
      end while (rwreq.next(i));
    if(creq.first(i))
        do begin
            s &= (creq[i].num() == 0);
        end while (creq.next(i));
    if(areq.first(i))
        do begin
            s &= (areq[i].num() == 0);
        end while (areq.next(i));
    if(rureq.first(i))
        do begin
            s &= (rureq[i].num() == 0);
        end while (rureq.next(i));

    if (rexp.first(i))
      do begin
        s &= (rexp[i].num() == 0);
      end while (rexp.next(i));
    if (rwexp.first(i))
      do begin
        s &= (rwexp[i].num() == 0);
      end while (rwexp.next(i));
    if (aexp.first(i))
        do begin
            s &= (aexp[i].num() == 0);
        end while (aexp.next(i));
    if (ruexp.first(i))
      do begin
        s &= (ruexp[i].num() == 0);
      end while (ruexp.next(i));

    is_empty = s;
  endfunction

  task automatic wait_is_empty ();
    while (!is_empty())
      step(1);
  endtask

  task update_stats (ref MemoryTransaction #(AW,DW,WORDS) t);
    op_stats[t.mop]++;
  endtask

  task automatic report_stats ();
    memory_op m;
    string s = "memory operations performed:";
    if (op_stats.first(m))
      do begin
        if (m != MOP_NOP) begin
          int c = op_stats[m];
          if (c != 0) 
            s = $psprintf("%s %s=%0d", s, sprint_mop2(m), c);
        end
      end while (op_stats.next(m));
    `TB_YAP(s)

    if (readPortpresent() && ((op_stats[MOP_RD] + op_stats[MOP_RDC] + op_stats[MOP_RU]) == 0)) begin
      `ERROR("No reads sent")
    end
  endtask

  function int readPortpresent();
    begin
      if ((r_ifc.size() != 0 ) || (rw_ifc.size() != 0) || (a_ifc.size() != 0) || (ru_ifc.size() != 0))
        return 1;
    end
  endfunction

endclass
