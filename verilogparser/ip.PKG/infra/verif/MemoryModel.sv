/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
class MemoryModel #(AW=8, DW=32, WORDS=256, CHK_READ_VLD=1, CHK_READ_ERR=1, LATENCY=2, TOTAL_PORTS=2) extends MemoryTransactor #(AW, DW, WORDS, CHK_READ_VLD, CHK_READ_ERR, LATENCY);

  function new (string name);
    super.new(name);
  endfunction

  extern task test ();

  task reset ();
    super.reset();
  endtask

  task run ();
    fork
      super.run();
    join_none
  endtask

  task test_simple (); 
    int i;
    port_type pt[int];
    MemoryPorts #(.NUMPRT(TOTAL_PORTS)) m = new();
    MemoryTransaction #(AW,DW, WORDS) t;
    MemoryTransaction #(AW,DW, WORDS) t2;
    wait_is_empty();
    `TB_YAP("test_simple running ")
    m.mco.getPortTypeMap(pt);
    for (i = 0; i < TOTAL_PORTS; i++) begin
      t = new();
      void'(t.randomize());
      if(t.addr >= WORDS)
        t.addr = 0;
      t.mop = m.mco.getRandomOp(pt[i]);
      send(i, t);
      step(1);
      wait_is_empty();
    end
    wait_is_empty();
    `TB_YAP("test_simple completed") 
  endtask

  task test_write_all ();
    MemoryPorts #(.NUMPRT(TOTAL_PORTS)) m = new();
    MemoryTransaction #(AW, DW, WORDS) t;
    CyclicRandomGenerator #(0, WORDS) crg;
    memory_op mop[int];
    int num_iter = 1;
    int num_req = num_iter*WORDS;
    int cnt = 0;

    wait_is_empty();
    step(10);
    `TB_YAP("test_write_all running") 
    crg = new();
    if (m.hasWritePort()) begin
      m.getConcurrentWriteOpSet(mop);      
      while (cnt < num_req) begin
        wait_too_many();
        for (int j = 0; j < TOTAL_PORTS; j++) begin
          if (mop[j] != MOP_NOP) begin
            t = new();
            cnt++;
            void'(t.randomize());
            t.addr   = crg.next();
            t.mop    = mop[j];
            send(j, t);
            if ((cnt % 2000) == 0)
              `TB_YAP($psprintf("test_write_all sent %0d of %0d", cnt, num_req))
          end
        end
      end
    end else begin
      `DEBUG("no write port detected - clearing testbench mem directly")
      for (int w = 0; w < WORDS; w = w + 1) begin
        mem[w] = 0;
      end
    end
    wait_is_empty();
    `TB_YAP("test_write_all completed") 
  endtask

  task test_capacity_check ();
    MemoryPorts #(.NUMPRT(TOTAL_PORTS)) m = new();
    MemoryTransaction #(AW, DW, WORDS) t;
    MemoryTransaction #(AW, DW, WORDS) t2;
    CyclicRandomGenerator #(0, WORDS) crg;
    memory_op mop[int];
    int num_iter = 1;
    int num_req = num_iter*WORDS + 20000;
    int cnt = 0;

    wait_is_empty();
    step(10);
    `TB_YAP("test_capacity_check running") 
    crg = new();
    while (cnt < num_req) begin
      wait_too_many();
      m.getRandomMaxConcurrentOpSet(mop);
      for (int j = 0; j < TOTAL_PORTS; j++) begin
        t = new();
        void'(t.randomize());
        if (mop[j] != MOP_NOP) begin
          cnt++;
          t.addr   = crg.next();
          if ((cnt % 2000) == 0)
            `TB_YAP($psprintf("test_capacity_check sent %0d of %0d", cnt, num_req))
        end
        t.mop    = mop[j];
        send(j, t);
      end
    end 
    wait_is_empty();
    `TB_YAP("test_capacity_check completed") 
  endtask

  task test_random (bit few);
    MemoryPorts #(.NUMPRT(TOTAL_PORTS)) m = new();
    MemoryTransaction #(AW, DW, WORDS) t[TOTAL_PORTS];
    MemoryTransaction #(AW, DW, WORDS) t2;
    CyclicRandomGenerator #(0, WORDS) crg;
    memory_op mop[int];
    int num_iter = 1;
    int num_req = num_iter*WORDS;
    int cnt = 0;

    if (few) begin
      num_req = (WORDS > 200) ? 200 : WORDS;
      `DEBUG($psprintf("sending %0d random ops", num_req))
    end
    wait_is_empty();
    step(10);
    `TB_YAP("test_random running") 
    crg = new();
    while (cnt < num_req) begin
      wait_too_many();
      m.getRandomConcurrentOpSet(mop);
      for (int j = 0; j < TOTAL_PORTS; j++) begin
        t[j] = new();
        void'(t[j].randomize());
        if (mop[j] != MOP_NOP) begin
          cnt++;
          t[j].addr   = crg.next();
          if ((cnt % 2000) == 0)
             `TB_YAP($psprintf("test_random sent %0d of %0d", cnt, num_req))
        end
        t[j].mop = mop[j];
      end
      for (int i = TOTAL_PORTS-1; i >= 0; i--) begin
        for (int j = i-1; j >= 0; j--) begin
          if( (t[j].addr == t[i].addr) && (t[j].mop == t[i].mop) && (t[j].is_write())) begin
            t[j].no_modelwrite = 1'b1;
          end
        end
      end
      for(int i = 0; i < TOTAL_PORTS; i++) begin
        send(i,t[i]);
      end
    end 
    wait_is_empty();
    `TB_YAP("test_random completed") 
  endtask

  task test_op_sequence();
    MemoryPorts #(.NUMPRT(TOTAL_PORTS)) m = new();
    MemoryTransaction #(AW, DW, WORDS) t;
    CyclicRandomGenerator #(0, WORDS) crg;
    memory_op mop[int];
    int l = 0;
    int num_cop = 10;
    int num_req = 10;
    int tot_req = num_cop * num_req * TOTAL_PORTS;
    wait_is_empty();
    step(10);
    `TB_YAP("test_op_sequence running") 
    crg = new();
    for (int k = 0; k < num_cop; k++) begin
      m.getRandomConcurrentOpSet(mop);
      for (int j = 0; j < num_req; j++) begin
        for (int i = 0; i < TOTAL_PORTS; i++) begin
          l++;
          t = new();
          void'(t.randomize());
          t.addr   = crg.next();
          t.mop    = mop[i];
          send(i, t);
          if ((l % 100) == 0)
            `TB_YAP($psprintf("test_op_sequence sent %0d of %0d", l, tot_req))
        end
      end
    end
    `TB_YAP("test_op_sequence completed") 
    wait_is_empty();
  endtask

  task test_read_all ();
    MemoryPorts #(.NUMPRT(TOTAL_PORTS)) m = new();
    MemoryTransaction #(AW, DW, WORDS) t;
    CyclicRandomGenerator #(0, WORDS) crg;
    memory_op mop[int];
    int num_iter = 1;
    int num_req = num_iter*WORDS;
    int cnt = 0;

    wait_is_empty();
    step(10);
    `TB_YAP("test_read_all running") 
    crg = new();
    m.getConcurrentReadCheckOpSet(mop);
    while (cnt < num_req) begin
      wait_too_many();
      for (int j = 0; j < TOTAL_PORTS; j++) begin
        if (mop[j] != MOP_NOP) begin
          t = new();
          cnt++;
          void'(t.randomize());
          t.addr   = crg.next();
          t.mop    = mop[j];
          send(j, t);
          if ((cnt % 2000) == 0)
            `TB_YAP($psprintf("test_read_all sent %0d of %0d", cnt, num_req))
        end
      end
    end    
    `TB_YAP("test_read_all completed")
    wait_is_empty();
  endtask

endclass
