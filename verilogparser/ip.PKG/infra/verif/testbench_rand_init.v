/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
module testbench_rand_init;

  string name = "testbench.init.rand_init";

  integer ntb_random_seed;
  integer r;
  initial begin 
    if (!$value$plusargs("ntb_random_seed=%d",ntb_random_seed)) begin
      ntb_random_seed = 3553;
      `DEBUG($psprintf("using default ntb_random_seed %0d", ntb_random_seed))
    end
    `DEBUG($psprintf("seeding $random with %0d", ntb_random_seed))
    r = $random(ntb_random_seed);
  end
endmodule // testbench_rand_init
