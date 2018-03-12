/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
program testbench_program #(int AW=12, int DW=4, int WORDS=200,
                            int LATENCY=2, int RESET_NEEDED=1, 
                            int WAIT_FOR_READY=1, int CHK_READ_VLD = 1,
                            int CHK_READ_ERR = 1, int TOTAL_PORTS = 2,
			                   int DBGWDTH=0, int BITDROW=0, int NUMDROW=0, 
                            int BITDBNK=0, int NUMDBNK=0)
  (mem_misc_ifc misc_ifc, mem_dbg_ifc dbg_ifc, mem_r_ifc_pkd.tb r_ifc_pkd, 
   mem_w_ifc_pkd.tb w_ifc_pkd, mem_rw_ifc_pkd.tb rw_ifc_pkd, 
   mem_c_ifc_pkd c_ifc_pkd, mem_a_ifc_pkd a_ifc_pkd, mem_rw_ifc_pkd ru_ifc_pkd);

  string                        name = "testbench.program";
  integer                       RESET_CYCLE_COUNT = 10;
  integer                       TIMEOUT_CYCLE_COUNT = 30 * WORDS + 50000*5;
  integer                       DONE_CYCLE_COUNT = 50; // num empty cycles to call done

  MemoryModel #(AW, DW, WORDS, CHK_READ_VLD, CHK_READ_ERR, LATENCY, TOTAL_PORTS) mem;

  initial begin
    init_vars();
    init();
    run();
    reset();
    wait_design_ready();
    fork
      test();
      finish();
    join
  end

  task automatic init_vars ();
    int rv;
    rv = $value$plusargs("RESET_CYCLE_COUNT=%d",RESET_CYCLE_COUNT);
    rv = $value$plusargs("TIMEOUT_CYCLE_COUNT=%d",TIMEOUT_CYCLE_COUNT);
    rv = $value$plusargs("DONE_CYCLE_COUNT=%d",DONE_CYCLE_COUNT);
    `DEBUG($psprintf("RESET_CYCLE_COUNT=%0d TIMEOUT_CYCLE_COUNT=%0d DONE_CYCLE_COUNT=%0d", RESET_CYCLE_COUNT, TIMEOUT_CYCLE_COUNT, DONE_CYCLE_COUNT))
    `DEBUG($psprintf("WAIT_FOR_READY=%0d RESET_NEEDED=%0d TOTAL_PORTS=%0d", WAIT_FOR_READY, RESET_NEEDED, TOTAL_PORTS))

  endtask

  task init ();
    int i;
    mem = new ({name,".memory_model"});
    `DEBUG("init")
    if(r_ifc_pkd.NUMPRT > 0)
      mem.r_ifc = r_ifc_pkd.r_ifc;
    if(w_ifc_pkd.NUMPRT > 0)
      mem.w_ifc = w_ifc_pkd.w_ifc;
    if(rw_ifc_pkd.NUMPRT > 0)
      mem.rw_ifc = rw_ifc_pkd.rw_ifc;
    if(a_ifc_pkd.NUMPRT > 0)
        mem.a_ifc = a_ifc_pkd.a_ifc;
    if(c_ifc_pkd.NUMPRT > 0)
        mem.c_ifc = c_ifc_pkd.c_ifc;
    if(ru_ifc_pkd.NUMPRT > 0)
        mem.ru_ifc = ru_ifc_pkd.rw_ifc;
    mem.misc_ifc = misc_ifc;
    // TBD Fix when adding debug port
    //mem.dbg_ifc = dbg_ifc;
  endtask

  task reset ();
    fork
      reset_sequence();
      mem.reset();
    join
  endtask

  task run ();
    `DEBUG("run")
    fork
      mem.run();
    join_none
  endtask

  task automatic step (int c);
    repeat (c) @ (posedge misc_ifc.clk);
  endtask

  function bit is_empty ();
    is_empty = mem.is_empty();
  endfunction

  task automatic wait_is_empty ();
    while (!is_empty()) begin
      step(1);
    end    
  endtask

  task test ();
    `INFO("running tests")
    mem.test();
    // TBD: rereset - destroy TB and start over
  endtask

  task automatic finish ();
    fork
      wait_done();
      wait_timeout();
    join_any
    disable fork;
    //TBD: dump queues
    `INFO("Turning Assertions OFF.");
    $assertoff;
    misc_ifc.rst <= 1'b1;
    step(100);
    mem.report_stats();
    if ( __err_cnt != 0) begin
        `TB_YAP($psprintf("Simulation FAILED (w=%0d e=%0d)",__warn_cnt, __err_cnt))
    end else begin
        `TB_YAP($psprintf("Simulation PASSED (w=%0d)", __warn_cnt))
    end
    $finish (__err_cnt);
  endtask

  task automatic wait_done ();
    int cnt = 0;
    while (cnt < DONE_CYCLE_COUNT) begin
      step(1);
      cnt = is_empty() ? (cnt + 1) : 0;
    end
  endtask

  task automatic wait_timeout ();
    step(TIMEOUT_CYCLE_COUNT);
    `FATAL("timeout - consider increasing TIMEOUT_CYCLE_COUNT")
  endtask

  task automatic  wait_design_ready ();
    if (WAIT_FOR_READY) begin
      `INFO("waiting for ready")
      while (misc_ifc.ready !== 1'b1)
        step(1);
      `INFO("ready detected")
    end else begin
      `INFO("not waiting for ready")
    end
  endtask

  task automatic reset_sequence ();
    if (RESET_NEEDED) begin
      misc_ifc.rst <= 1'b1;
      `INFO("reset asserted")
      repeat (RESET_CYCLE_COUNT) @ (posedge misc_ifc.clk);
      misc_ifc.rst <= 1'b0;
      `INFO("reset deasserted")
    end
    dbg_ifc.dbg_en <= 1'b0;
    dbg_ifc.dbg_write <= 1'b0;
    dbg_ifc.dbg_read <= 1'b0;
  endtask

endprogram
