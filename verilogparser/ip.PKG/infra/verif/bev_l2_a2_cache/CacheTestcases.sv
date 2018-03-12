`ifndef CACHE_TEST_CASES
`define CACHE_TEST_CASES
class CacheTestcases#(int BITADDR=34,int BITDATA=512,int BITSEQN=4,int NUMBYLN=64,int XBITATR=3,int NOMSTP = 1,int NOSLVP = 1,int NUMWAYS = 4,int NUMINDX = 128);
   CacheTestBench #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR,NOMSTP,NOSLVP,NUMWAYS,NUMINDX) tb;
   string name;
   string testname;
   function new(CacheTestBench#(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR,NOMSTP,NOSLVP,NUMWAYS,NUMINDX) tb, string name);
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

endclass:CacheTestcases
`endif

   
