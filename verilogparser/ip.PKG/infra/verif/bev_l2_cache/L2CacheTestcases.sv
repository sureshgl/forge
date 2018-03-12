`ifndef L2_CACHE_TEST_CASES
`define L2_CACHE_TEST_CASES
class L2CacheTestcases#(int NXADDRWIDTH=31, int NXDATAWIDTH=256, int NXIDWIDTH=4, int NXTYPEWIDTH=3, int NXSIZEWIDTH=8, int NXATTRWIDTH=3,int NOMSTP = 1, int NOSLVP = 1,int NUMWAYS = 4, int NUMROWS = 128);
   L2CacheTestBench #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH,NOMSTP,NOSLVP,NUMWAYS,NUMROWS) tb;
   string name;
   string testname;
   function new(L2CacheTestBench#(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH,NOMSTP,NOSLVP,NUMWAYS,NUMROWS) tb, string name);
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

endclass:L2CacheTestcases
`endif

   
