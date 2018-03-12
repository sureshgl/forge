/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
program CacheProgram   #( int BITADDR=34,
                          int BITDATA=512,
                          int BITSEQN=4,
                          int NUMBYLN=64,
                          int XBITATR=3,
                          int NOMSTP = 1,
                          int NOSLVP = 1,
                          int NUMWAYS = 4,
                          int NUMINDX = 128

                        )
                        ( Misc_Ifc misc_ifc,
                          L2_M_Ifc mL2Ifc[NOMSTP], 
                          L2_S_Ifc sL2Ifc[NOSLVP]
                        );

  string                        name = "testbench.program";

  CacheTestBench#(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR,NOMSTP,NOSLVP,NUMWAYS,NUMINDX) tb;
  CacheTestcases#(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR,NOMSTP,NOSLVP,NUMWAYS,NUMINDX) tc;
  integer randomseed;

  initial
     begin
        run();
     end


  task run();
   tb = new("tb");
   tc = new (tb,"tc");
   tb.init(misc_ifc,mL2Ifc,sL2Ifc);
   tb.clear();
   tb.reset();
   tb.clear();
   tb.clock(300);
   tb.run();
   tb.clock(300);
   tc.runtestcase();
   tb.finish();
   tb.clock(100);
  endtask:run
endprogram
