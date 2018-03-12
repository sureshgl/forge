/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
module testbench_clk (clk);
  string name = "testbench.init.clk";
  parameter TB_HALF_CLK_PER = 1000;

  output clk;

  reg    clk = 0;
  initial begin
    forever #TB_HALF_CLK_PER clk = ~clk;
  end

  reg [31:0] ccnt = {32{1'b0}};
  always @(posedge clk)
    ccnt <= ccnt + 1'b1;

endmodule // testbench_clk
