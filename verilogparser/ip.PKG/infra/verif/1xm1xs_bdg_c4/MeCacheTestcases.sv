`ifndef ME_CACHE_TEST_CASES
`define ME_CACHE_TEST_CASES
class MeCacheTestcases#(int NXADDRWIDTH=31, int NXDATAWIDTH=256, int NXIDWIDTH=4, int NXTYPEWIDTH=3, int NXSIZEWIDTH=8, int NXATTRWIDTH=3,int NOMSTP = 1, int NOSLVP = 1,int NUMWAYS = 4, int NUMROWS = 128, int DBGADDRWIDTH = 7,int DBGBADDRWIDTH = 4,int DBGDATAWIDTH = 144,int NUMDBNK = 9,int NUMDROW = 128);
   MeCacheTestBench #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH,NOMSTP,NOSLVP,NUMWAYS,NUMROWS,DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH,NUMDBNK,NUMDROW) tb;
   string name;
   string testname;
   function new(MeCacheTestBench#(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH,NOMSTP,NOSLVP,NUMWAYS,NUMROWS,DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH,NUMDBNK,NUMDROW) tb, string name);
    begin
     this.name = name;
     this.tb = tb;
     if(!$value$plusargs("testname=%s",testname)) begin
        //$finish;
       testname="basicTest";
     end
    end
   endfunction:new
extern task basicTest();
   task runtestcase();
      begin
       if(testname == "basicTest") begin
          $display("TEST NAME = %s",testname);
           basicTest();
       end
      end
   endtask:runtestcase

endclass:MeCacheTestcases
`endif

   
