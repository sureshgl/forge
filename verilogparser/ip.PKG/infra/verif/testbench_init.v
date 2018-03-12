/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
`timescale 1ps/1ps

module testbench_init #(parameter TB_HALF_CLK_PER = 1000, parameter TB_VPD_DUMP_FILE = "dump.vpd", parameter REFRESH_M_IN_N_M = 0, parameter REFRESH_M_IN_N_N = 0, parameter REFRESH_M_IN_N_N_HF=0)
  (input rst, output clk, output refr, output refr_e);

  string name = "testbench.init";
  
  testbench_clk # (
                   .TB_HALF_CLK_PER (TB_HALF_CLK_PER)
                   )
  c (
     .clk(clk)
     );
  
  testbench_dbg # (
                   .TB_VPD_DUMP_FILE (TB_VPD_DUMP_FILE)
                   )
  d (
     );
  
  testbench_rand_init
    r (
       );

  testbench_refr # (
                   .REFRESH_M_IN_N_M(REFRESH_M_IN_N_M),
                   .REFRESH_M_IN_N_N(REFRESH_M_IN_N_N),
		              .REFRESH_M_IN_N_N_HF(REFRESH_M_IN_N_N_HF)
                    )
    f (
       .clk(clk),
       .rst(rst),
       .refr(refr),
       .refr_e(refr_e)
       );

endmodule
