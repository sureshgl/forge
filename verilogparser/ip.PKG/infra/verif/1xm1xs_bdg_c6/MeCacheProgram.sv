/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
program MeCacheProgram #( int NXADDRWIDTH=31,
                          int NXDATAWIDTH=256,
                          int NXIDWIDTH=4,
                          int NXTYPEWIDTH=3,
                          int NXSIZEWIDTH=8,
                          int NXATTRWIDTH=3,
                          int NOMSTP = 1,
                          int NOSLVP = 1,
                          int NUMWAYS = 4,
                          int NUMROWS = 128,
                          int DBGADDRWIDTH = 7,
                          int DBGBADDRWIDTH = 7,
                          int DBGDATAWIDTH = 144,
                          int NUMDBNK = 9,
                          int NUMDROW = 128
                        )
                        ( Misc_Ifc misc_ifc,
                          Naxi_Ifc mAxiIfc[NOMSTP], 
                          Naxi_Ifc sAxiIfc[NOSLVP],
                          Dbg_Ifc dbgIfc
                        );

  string                        name = "testbench.program";

  MeCacheTestBench#(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH,NOMSTP,NOSLVP,NUMWAYS,NUMROWS,DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH,NUMDBNK,NUMDROW) tb;
  MeCacheTestcases#(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH,NOMSTP,NOSLVP,NUMWAYS,NUMROWS,DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH,NUMDBNK,NUMDROW) tc;
  integer randomseed;

  initial
     begin
        run();
     end


  task run();
   tb = new("tb");
   tc = new (tb,"tc");
   //tb.init(misc_ifc,r_ifc[NORDP],w_ifc[NOWRP],rw_ifc[NORWP],ru_ifc[NORUP],c_ifc[NOCNP],a_ifc[NOACP]);
   tb.init(misc_ifc,mAxiIfc,sAxiIfc,dbgIfc);
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
