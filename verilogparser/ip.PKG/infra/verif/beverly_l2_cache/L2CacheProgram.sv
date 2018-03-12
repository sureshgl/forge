/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
program L2CacheProgram #( int NXADDRWIDTH=34,
                          int NXDATAWIDTH=256,
                          int NXTYPEWIDTH=3,
                          int NXSIZEWIDTH=8,
                          int NXATTRWIDTH=3,
                          int NOMSTP = 1,
                          int NOSLVP = 1,
                          int NUMWAYS = 4,
                          int NUMROWS = 128,
                          int XBITSEQ = 5,
                          int YBITSEQ = 4

                        )
                        ( Misc_Ifc misc_ifc,
                          Naxi_Ifc mAxiIfc[NOMSTP], 
                          Naxi_Ifc sAxiIfc[NOSLVP]
                        );

  string                        name = "testbench.program";

  L2CacheTestBench#(NXADDRWIDTH,NXDATAWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH,NOMSTP,NOSLVP,NUMWAYS,NUMROWS,XBITSEQ,YBITSEQ) tb;
  L2CacheTestcases#(NXADDRWIDTH,NXDATAWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH,NOMSTP,NOSLVP,NUMWAYS,NUMROWS,XBITSEQ,YBITSEQ) tc;
  integer randomseed;

  initial
     begin
        run();
     end


  task run();
   tb = new("tb");
   tc = new (tb,"tc");
   tb.init(misc_ifc,mAxiIfc,sAxiIfc);
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
