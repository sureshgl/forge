/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
// to enable dumping run ./simv +waves
// to change log level ./simv +log_level=4
module testbench_dbg;
  string name = "testbench.init.dbg";
  parameter TB_VPD_DUMP_FILE = "dump.vpd";
  integer   ll;
  initial begin
    if ($test$plusargs("waves")) begin
`ifdef VCS_SIMULATOR
      `TB_YAP($psprintf("wave dumping on: %s",TB_VPD_DUMP_FILE))
      $vcdplusfile(TB_VPD_DUMP_FILE);
      $vcdpluson();
      $vcdplusmemon();
      //$vcdplustraceon();
      // $vcdplusdeltacycleon;
      // $vcdplusglitchon;
`endif
`ifdef NCV_SIMULATOR
      $shm_open(TB_VPD_DUMP_FILE);
    if ($test$plusargs("dumpmem")) begin
      `TB_YAP("wave dumping on with +dumpmem")
      $shm_probe(`SIM_TOP, "ACM");
   end else begin
      `TB_YAP($psprintf("wave dumping on: %s",TB_VPD_DUMP_FILE))
      $shm_probe(`SIM_TOP, "AC");
   end
    
      //$shm_probe(test_bench, "AC");//   - full hierarchy
      // $shm_probe(test_bench, "AS");//  - Just the top level
`endif
    end
  end
  initial begin
    if ($value$plusargs("log_level=%d",ll)) begin
      llvl = log_level'(ll);
      `DEBUG($psprintf("log_level set to %0d", llvl))
    end
      `TB_YAP($psprintf("log_level set to %0d", llvl))
    if ($value$plusargs("memoir_design_name=%s",memoir_design_name)) begin
      `TB_YAP($psprintf("memoir_design_name=%s",memoir_design_name))
    end
  end
endmodule // testbench_dbg
