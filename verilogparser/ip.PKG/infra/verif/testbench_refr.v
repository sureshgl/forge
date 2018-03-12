/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
module testbench_refr (clk, rst, refr, refr_e);
  string name = "testbench.init.refr";
  parameter REFRESH_M_IN_N_M = 0;
  parameter REFRESH_M_IN_N_N = 0; // 0 => disable
  parameter REFRESH_M_IN_N_N_HF = 0;

  input      clk;
  input      rst;
  output     refr;
  output     refr_e;

  reg [31:0] refr_cnt;
  always @(posedge clk)
    if (rst)
      refr_cnt <= 32'h0;
    else if (|refr_cnt)
      refr_cnt <= refr_cnt - 1'b1;
    else if (~(|refr_cnt))
      refr_cnt <= REFRESH_M_IN_N_N - 1;

  reg        refr_e;
  always @(posedge clk)
    if (rst)
      refr_e <= 1'b0;
    else
      refr_e <= (REFRESH_M_IN_N_N == 0) ? 1'b0 : (refr_cnt < REFRESH_M_IN_N_M);

  reg        refr;
  always @(posedge clk)
    refr <= refr_e;

endmodule // testbench_refr
