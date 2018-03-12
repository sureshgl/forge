`ifndef ME_CACHE_TEST_BENCH
`define ME_CACHE_TEST_BENCH
class MeCacheTestBench #(int NXADDRWIDTH=31, int NXDATAWIDTH=256, int NXIDWIDTH=4, int NXTYPEWIDTH=3, int NXSIZEWIDTH=8, int NXATTRWIDTH=3,int NOMSTP = 1, int NOSLVP = 1,int NUMWAYS = 4, int NUMROWS = 128, int DBGADDRWIDTH = 7,int DBGBADDRWIDTH = 4,int DBGDATAWIDTH = 144,int NUMDBNK = 9,int NUMDROW = 128) extends MeTransactor;
localparam BYTEADDBITS = 5;
localparam ROWADDRBITS = 7;
localparam TAGADDRBITS = NXADDRWIDTH - ROWADDRBITS  - BYTEADDBITS;


  string name;
  integer i,j;
  MeCacheMasterTransactor#(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) mstTr[NOMSTP];
  MeCacheSlaveTransactor#(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) slvTr[NOSLVP];
  MeCacheDbgTransactor#(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH) dbgTr;
  virtual Misc_Ifc misc_ifc;
  virtual Naxi_Ifc  #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH)  mAxiIfc[NOMSTP];
  virtual Naxi_Ifc  #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH)  sAxiIfc[NOSLVP];
  virtual Dbg_Ifc  #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgIfc;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuWrReqT;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuWrRspT;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuRdReqT;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuRdRspT;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2WrMonT;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2RdAMonT;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2RdDDrT;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) slvCbusMonT;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) slvDbusMonT;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) slvRbusMonT;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) mstCbusMonT;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) mstDbusMonT;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) mstRbusMonT;


        MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuCbusMonT;
        MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuDbusMonT;
        MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuRbusMonT;
        MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2CbusMonT;
        MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2DbusMonT;
        MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2RbusMonT;


        reg [DBGDATAWIDTH-1:0]dbgMem[NUMDBNK][NUMDROW];
	reg [NXDATAWIDTH-1 :0] cacheArray[*];
	reg [NXDATAWIDTH-1 :0] cacheArray_dly1[*];
	reg [NXDATAWIDTH-1 :0] cacheArray_dly2[*];
	reg [NXDATAWIDTH-1 :0] cacheArray_dly[*];
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) inputWrQueue1[*];
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) inputWrQueue2[*];
	reg [NXDATAWIDTH-1 :0] memArray[*];
	reg  dirtyArray[*];
	reg  flushArray[*];
	reg [NXADDRWIDTH-1 :0] InvalArray[*];
	reg [NXDATAWIDTH-1 :0] nonCacheArray[*];
	reg [NXDATAWIDTH-1 :0] evictMemArray[*];
	reg [NXDATAWIDTH-1 :0] wrDataMemArray[*];
       reg l2RrspDataErr;
       reg l2RrspAddErr;


  //MeDuvChecker#(AW,DW,WORDS,LATENCY,NORDP,NOWRP,NORWP,NORUP,NOCNP,NOACP) duvChecker;
  integer                       RESET_CYCLE_COUNT = 20;
  integer                       TIMEOUT_CYCLE_COUNT = 30;
  integer                       DONE_CYCLE_COUNT = 50; // num empty cycles to call done

       mailbox cpuCreqMonQueue;
       mailbox cpuDreqMonQueue;
       mailbox cpuRreqMonQueue;
       mailbox l2CreqMonQueue;
       mailbox l2DreqMonQueue;
       mailbox l2RreqMonQueue;

	mailbox monCpuRdRspQueue;
	mailbox monCpuWrRspQueue;
        mailbox monL2WrRspQueue;

       mailbox cpuReqQueue;
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuRdMonArrayQueue[*];
       mailbox l2WrMonQueue;
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2RdAddMonArrayQueue[*];
       mailbox cpuRdMonQueue;
       mailbox l2RdMonQueue;
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) outOfOrdrArrayQueue[*];
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) outOfOrdrQueue[$];
       

      reg [63:0]cpuRspCacheWrTr;
      reg [63:0]cpuRspNonCacheWrTr;
      reg [63:0]cpuRspCacheRdTr;
      reg [63:0]cpuRspNonCacheRdTr;
      reg [63:0]cpuRspCacheFlushTr;
      reg [63:0]cpuRspCacheInvalidTr;
      reg [63:0]l2RspNonCacheRdTr;
      reg [63:0]l2RspCacheRdTr;
      reg [63:0]l2RspNonCycheWrTr;
      reg [63:0]l2RspNonCacheWrACKTr;
      reg [63:0]l2RspNonCacheWrNOACKTr;
      reg [63:0]l2RspCacheWrTr;
      reg [63:0]l2RspCacheWrACKTr;
      reg [63:0]l2RspCacheWrNOACKTr;

     reg [NXADDRWIDTH-1:0] cacheRandomAddArray[*];
     reg [NXADDRWIDTH-1:0] cacheAddArray[NUMWAYS][NUMROWS];

     bit outOfOrderRspEn;
     bit randomStallEn;
     bit t1_mem_error_check;
     bit t2_mem_error_check;
     bit insertL2Error;
     bit outOfOrderRspDis;


     bit forceAckForallReq;
  function new (string name);
    begin
     super.new(name);
     //duvChecker = new(name);
     this.name = name;
        `DEBUG($psprintf("Function New   "))


      outOfOrderRspEn = 1;
      randomStallEn = 1;
      monCpuRdRspQueue = new();
      monCpuWrRspQueue = new();
      monL2WrRspQueue  = new();

      l2CreqMonQueue  = new();
      l2DreqMonQueue  = new();
      l2RreqMonQueue  = new();
      cpuCreqMonQueue = new();
      cpuDreqMonQueue = new();
      cpuRreqMonQueue = new();


      l2WrMonQueue = new();
      cpuReqQueue = new();
      cpuRdMonQueue = new();
      l2RdMonQueue = new();
     for(i=0; i<NOMSTP; i = i+1) begin
       mstTr[i] = new($psprintf("mstTr[%d]",i));
     end 
     for(i=0; i<NOSLVP; i = i+1) begin
       slvTr[i] = new($psprintf("slvTr[%d]",i));
     end

      dbgTr = new($psprintf("dbgTr"));

     for(i=0; i<NUMDBNK ; i = i+1) begin 
        for(j=0; j<NUMDROW; j = j+1) begin 
            dbgMem[i][j] = 144'h0;
        end
     end


     l2RrspDataErr =0;
     l2RrspAddErr = 0; 
     insertL2Error = 0;
     outOfOrderRspDis = 0;
     t1_mem_error_check = 0;
     t2_mem_error_check = 0;

     forceAckForallReq = 0;
    end
  endfunction:new

  task init (virtual Misc_Ifc misc_ifc,  virtual Naxi_Ifc#(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) mAxiIfc[NOMSTP],virtual Naxi_Ifc#(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) sAxiIfc[NOSLVP],virtual Dbg_Ifc#(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgIfc); 
    begin
     this.misc_ifc = misc_ifc;
        `DEBUG($psprintf("Task Init   "))
     //duvChecker.init(misc_ifc,r_ifc,w_ifc,rw_ifc,ru_ifc,c_ifc,a_ifc);
    for(i=0; i<NOMSTP; i = i+1) begin
       mstTr[i].init(mAxiIfc[i]);
     end 
     for(i=0; i<NOSLVP; i = i+1) begin
       slvTr[i].init(sAxiIfc[i]);
     end 
       dbgTr.init(dbgIfc);
 
   end
 endtask:init

  task clear();
    begin
        `DEBUG($psprintf("Task Clear   "))
      fork
        //duvChecker.clear();
        begin
         for(i=0; i<NOMSTP; i = i+1) begin
            mstTr[i].clear();
         end 
       end
       begin
         for(i=0; i<NOSLVP; i = i+1) begin
            slvTr[i].clear();
         end 
       end
         dbgTr.clear();
      join_none

    end
 endtask:clear

  task reset();
    begin
      misc_ifc.rst <= 1'b1;
      `TB_YAP("reset asserted")
      repeat (RESET_CYCLE_COUNT) @ (posedge misc_ifc.clk);
      misc_ifc.rst <= 1'b0;
      `TB_YAP("reset deasserted")
      waitForReady();
      cpuRspCacheWrTr = 0;
      cpuRspNonCacheWrTr= 0;
      cpuRspCacheFlushTr= 0;
      cpuRspCacheInvalidTr= 0;
      cpuRspCacheRdTr= 0;
      cpuRspNonCacheRdTr= 0;
      l2RspNonCacheRdTr= 0;
      l2RspCacheRdTr= 0;
      l2RspNonCycheWrTr = 0;
      l2RspNonCacheWrACKTr = 0;
      l2RspNonCacheWrNOACKTr = 0;
      l2RspCacheWrTr = 0;
      l2RspCacheWrACKTr = 0;
      l2RspCacheWrNOACKTr = 0;
      outOfOrderRspDis = 0;


      fork
        //duvChecker.reset();
        begin
         for(i=0; i<NOMSTP; i = i+1) begin
            mstTr[i].reset();
         end 
       end
       begin
         for(i=0; i<NOSLVP; i = i+1) begin
            slvTr[i].reset();
         end 
       end
           dbgTr.reset();
      join_none

    end
  endtask:reset

 task run();
   begin
        `DEBUG($psprintf("Task Run"))
     fork
       //duvChecker.run();
       begin
         for(i=0; i<NOMSTP; i = i+1) begin
            mstTr[i].run();
         end 
       end
       begin
         for(i=0; i<NOSLVP; i = i+1) begin
            slvTr[i].run();
         end 
       end
         dbgTr.run();

       drive();
       monitor();
     join_none
   end
 endtask:run

  task drive();
    begin
        `DEBUG($psprintf("Task Drive"))
      fork
        display();
      join_none

    end
   endtask:drive

task display();
while(1) begin
   clock(1);
   if(mstTr[0].totalTransactions[63:0]%10000 == 1) begin
             `TB_YAP($psprintf(" CACHE_TB_INFO  =========================================="))
             `TB_YAP($psprintf(" CACHE_TB_INFO  TOTAL TR                %d ",mstTr[0].totalTransactions[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_INFO  transactionID  		%d ",mstTr[0].transactionId[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_INFO  SIM TIME       		%t ",$time))
             `TB_YAP($psprintf(" CACHE_TB_INFO  =========================================="))
   clock(100);
   end
end
endtask


   task monitor();
     begin
        `DEBUG($psprintf("Task Monitor"))
     fork
         monCpuWrRsp();
         monCpuRdRsp();
         monl2WrReq();
         monl2RdAddReq();
         sendL2RdRsp();

         cpuCreqMon();
         cpuDreqMon();
         cpuRreqMon();
         l2CreqMon();
         l2DreqMon();
         l2RreqMon();
       
          cpuReqTrMon();
          l2ReqTrMon(); 
          //l2ReadTrMoniter();  //FIXME
          cpuReadTrMoniter();

          readCheckTask();
           dbgMemCheck();
           stallCheck();
           cpustallCheck();
           ovrFlowCheck();
           lruMonitor();
      join_none
     end
   endtask :monitor


  task clock (integer numClocks = 1);
       begin
         //`TB_YAP("clock task start")
         repeat(numClocks)@(misc_ifc.tb_req);
         //`TB_YAP("clock task finished")
       end
    endtask:clock


 task waitForReady();
    begin
    while(misc_ifc.tb_rsp.ready == 0)
        clock(1);
    end
 endtask 
 
 task sendCpuWrReq();
   begin
    integer j;
    for(j=0;j<400;j=j+1) begin
       cpuWrReqT = new();
       cpuWrReqT.reqType = CH_WRITE;
       cpuWrReqT.addr = 'h40 + ('h1000 * j);
       cpuWrReqT.size = 'h20;
       cpuWrReqT.cattr = 'h3;
       cpuWrReqT.data = 'hff000040 + ('h1000 * j);
       cpuWrReqT.dattr = 'h1;
       mstTr[0].send(cpuWrReqT);
        //`TB_YAP($psprintf("sendCacheReq Addr 0x%0x, Data 0x%x",  cpuWrReqT.addr,cpuWrReqT.data))
        `DEBUG($psprintf("sendCpuWrReq cReq %s  ", cpuWrReqT.creqSprint))
     end
    end
 endtask:sendCpuWrReq

 task sendCpuRdReq();
   begin
    integer z;
    for(z=0;z<400;z=z+1) begin
       cpuRdReqT = new();
       cpuRdReqT.reqType = CH_READ;
       cpuRdReqT.addr = 'h40 + ('h1000 * z);
       cpuRdReqT.size = 'h20;
       cpuRdReqT.cattr = 'h3;
       mstTr[0].send(cpuRdReqT);
        //`TB_YAP($psprintf("sendCpuRdReq Addr 0x%0x, Data 0x%x",  cpuRdReqT.addr,cpuRdReqT.data))
        `DEBUG($psprintf("sendCpuRdReq cReq %s  ", cpuRdReqT.creqSprint))
     end
    end
 endtask:sendCpuRdReq

 task sendCpuFlushReq();
   begin
    integer z,j;
    end
 endtask:sendCpuFlushReq

task sendDebugReq();
   begin
    integer z;
    end
endtask:sendDebugReq

task fillMemArray;
   reg [6:0]rowAddr = 'h4;
   reg [4:0]byteAddr = 'h0;
   reg [NXADDRWIDTH-1:0]reqAddr;
   reg [18:0] tagAddr = 'h0;
   integer i;
   reg [NXDATAWIDTH-1:0]wrData;
   reg [NXDATAWIDTH-1:0]tagRandomAddr;




  for(i=1; i <=7; i = i+1) begin
   tagRandomAddr[2:0] = i;
   reqAddr[NXADDRWIDTH-1:0] = {tagAddr[18:3],tagRandomAddr[2:0],rowAddr[6:0],5'h0};
   wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,reqAddr[NXADDRWIDTH-1:0]);
   memArray[reqAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
 end





endtask:fillMemArray


task instCacheBasicRDTest(input reg [6:0] rowIndex,input reg stallDis,input reg outOfOrderDis );
   reg [BYTEADDBITS-1:0]byteAddr;
   reg [NXSIZEWIDTH-1:0]byteSize;
   reg [TAGADDRBITS-1:0]tagAddr;
   reg [3:0]tagRandomAddr;
   reg [ROWADDRBITS-1:0]rowAddr;
   reg [NXADDRWIDTH-1:0] cacheAddr;
   reg [NXDATAWIDTH-1:0] wrData;
   integer i;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   begin
      `TB_YAP(" INST CACHE BASIC RD TEST START   ")
   if(outOfOrderDis == 1) begin
      outOfOrderRspEn = 0;
      `TB_YAP($psprintf("OutOfOrder RSp Disable %d ",  outOfOrderRspEn ))
   end else if(outOfOrderDis == 0) begin
      outOfOrderRspEn = 1;
      `TB_YAP($psprintf("OutOfOrder RSp Disable %d ",  outOfOrderRspEn ))
   end
   if(stallDis == 1) begin
      slvTr[0].stallEn = 0;
      `TB_YAP($psprintf("Stall Disable %d ",  slvTr[0].stallEn ))
   end else if(stallDis == 0) begin
      slvTr[0].stallEn = 1;
      `TB_YAP($psprintf("Stall Disable %d ",  slvTr[0].stallEn ))
   end
   for(i=0;i<10;i=i+1)  begin
      tagRandomAddr[3:0] = i;
      tagAddr[TAGADDRBITS-1:0] = 0;
      rowAddr[ROWADDRBITS-1:0] = rowIndex[ROWADDRBITS-1:0];
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:4],tagRandomAddr[3:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
     //if(!(memArray.exists(cacheAddr[NXADDRWIDTH-1:0]))) begin
     //    memArray[cacheAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
     //end
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h3;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_READ;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("instCacheBasicRDTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
    clock(1000);
    isEmpty();

      `TB_YAP(" INST CACHE BASIC RD TEST END   ")
   end
endtask:instCacheBasicRDTest

task instCacheCapacityTest(input reg [6:0] rowIndex,input reg stallDis,input reg outOfOrderDis );
   reg [BYTEADDBITS-1:0]byteAddr;
   reg [NXSIZEWIDTH-1:0]byteSize;
   reg [TAGADDRBITS-1:0]tagAddr;
   reg [ROWADDRBITS-1:0]rowAddr;
   reg [NXADDRWIDTH-1:0] cacheAddr;
   reg [NXDATAWIDTH-1:0] wrData;
   integer i,j;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   begin
      `TB_YAP(" INST CACHE CAPACITY  TEST START   ")
   if(outOfOrderDis == 1) begin
      outOfOrderRspEn = 0;
      `TB_YAP($psprintf("OutOfOrder RSp Disable %d ",  outOfOrderRspEn ))
   end else if(outOfOrderDis == 0) begin
      outOfOrderRspEn = 1;
      `TB_YAP($psprintf("OutOfOrder RSp Disable %d ",  outOfOrderRspEn ))
   end
   if(stallDis == 1) begin
      slvTr[0].stallEn = 0;
      `TB_YAP($psprintf("Stall Disable %d ",  slvTr[0].stallEn ))
   end else if(stallDis == 0) begin
      slvTr[0].stallEn = 1;
      `TB_YAP($psprintf("Stall Disable %d ",  slvTr[0].stallEn ))
   end
   for(i=0;i<TAGADDRBITS;i=i+1)  begin
      tagAddr[TAGADDRBITS-1:0] = 1 << i;
      rowAddr[ROWADDRBITS-1:0] = rowIndex[ROWADDRBITS-1:0];
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
     //if(!(memArray.exists(cacheAddr[NXADDRWIDTH-1:0]))) begin
     //    memArray[cacheAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
     //end
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h3;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_READ;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("instCacheCapacityTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
    clock(1000);
    isEmpty();

   for(i=TAGADDRBITS-1;i>=0;i--)  begin
      tagAddr[TAGADDRBITS-1:0] = 1 << i;
      rowAddr[ROWADDRBITS-1:0] = rowIndex[ROWADDRBITS-1:0];
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
     //if(!(memArray.exists(cacheAddr[NXADDRWIDTH-1:0]))) begin
     //    memArray[cacheAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
     //end
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h3;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_READ;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("instCacheCapacityTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
    clock(1000);
    isEmpty();

   
for(j=0;j<NUMWAYS;j = j+1) begin
    for(i=0;i<NUMROWS;i=i+1)  begin
      tagAddr[TAGADDRBITS-1:0] = j;
      rowAddr[ROWADDRBITS-1:0] = i;
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
     //if(!(memArray.exists(cacheAddr[NXADDRWIDTH-1:0]))) begin
     //    memArray[cacheAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
     //end
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h3;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_READ;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("instCacheCapacityTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
end

for(j=0;j<NUMWAYS;j = j+1) begin
    for(i=0;i<NUMROWS;i=i+1)  begin
      tagAddr[TAGADDRBITS-1:0] = j;
      rowAddr[ROWADDRBITS-1:0] = i;
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
     //if(!(memArray.exists(cacheAddr[NXADDRWIDTH-1:0]))) begin
     //    memArray[cacheAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
     //end
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h3;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_READ;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("instCacheCapacityTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
end
    clock(1000);
    isEmpty();

      `TB_YAP(" INST CACHE CAPACITY  TEST END  ")
   end
endtask:instCacheCapacityTest

task invalidWaybyIndexTest();
   reg [BYTEADDBITS-1:0]byteAddr;
   reg [NXSIZEWIDTH-1:0]byteSize;
   reg [TAGADDRBITS-1:0]tagAddr;
   reg [ROWADDRBITS-1:0]rowAddr;
   reg [NXADDRWIDTH-1:0] cacheAddr;
   reg [NXDATAWIDTH-1:0] wrData;
   integer i,j;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   begin
      `TB_YAP(" INST CACHE CAPACITY  TEST START   ")


for(j=0;j<NUMWAYS;j = j+1) begin
    for(i=0;i<NUMROWS;i=i+1)  begin
      tagAddr[TAGADDRBITS-1:0] = j;
      rowAddr[ROWADDRBITS-1:0] = i;
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h3;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_READ;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("invalidWaybyIndexTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
end
    clock(1000);
    isEmpty();

for(j=0;j<NUMWAYS;j = j+1) begin
    for(i=0;i<NUMROWS;i=i+1)  begin
      tagAddr[TAGADDRBITS-1:0] = 0;
      rowAddr[ROWADDRBITS-1:0] = i;
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h6;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_INVAL;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("invalidWaybyIndexTest READ_REQ %s  ",  cpuReqT.creqSprint))
      clock(10);
   end
end
    isEmpty();
    clock(1000);

for(j=0;j<NUMWAYS;j = j+1) begin
    for(i=0;i<NUMROWS;i=i+1)  begin
      tagAddr[TAGADDRBITS-1:0] = j;
      rowAddr[ROWADDRBITS-1:0] = i;
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h3;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_READ;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("invalidWaybyIndexTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
end
    isEmpty();

    for(i=0;i<NUMROWS;i=i+1)  begin
      tagAddr[TAGADDRBITS-1:0] = 0;
      rowAddr[ROWADDRBITS-1:0] = i;
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h6;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_INVAL;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("invalidWaybyIndexTest READ_REQ %s  ",  cpuReqT.creqSprint))
      clock(10);
   end
    clock(1000);
    isEmpty();

    for(i=0;i<NUMROWS;i=i+1)  begin
      tagAddr[TAGADDRBITS-1:0] = 4;
      rowAddr[ROWADDRBITS-1:0] = i;
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h3;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_READ;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("invalidWaybyIndexTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
    isEmpty();

    for(i=0;i<NUMROWS;i=i+1)  begin
      tagAddr[TAGADDRBITS-1:0] = 0;
      rowAddr[ROWADDRBITS-1:0] = i;
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h3;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_READ;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("invalidWaybyIndexTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
    isEmpty();
    clock(1000);

for(j=0;j<NUMWAYS;j = j+1) begin
    for(i=0;i<NUMROWS;i=i+1)  begin
     if(j == 0) begin
      tagAddr[TAGADDRBITS-1:0] = 4;
     end else if (j == 1) begin
      tagAddr[TAGADDRBITS-1:0] = 0;
     end else begin
      tagAddr[TAGADDRBITS-1:0] = j;
     end

      rowAddr[ROWADDRBITS-1:0] = i;
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h3;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_READ;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("invalidWaybyIndexTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
end
    clock(1000);
    isEmpty();
    for(i=0;i<NUMROWS;i=i+1)  begin
      tagAddr[TAGADDRBITS-1:0] = 2;
      rowAddr[ROWADDRBITS-1:0] = i;
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h2;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_INVAL;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("invalidWaybyIndexTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
    clock(1000);
    isEmpty();

    for(i=0;i<NUMROWS;i=i+1)  begin
      tagAddr[TAGADDRBITS-1:0] = 0;
      rowAddr[ROWADDRBITS-1:0] = i;
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h6;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_INVAL;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("invalidWaybyIndexTest READ_REQ %s  ",  cpuReqT.creqSprint))
    clock(10);
   end
    clock(1000);
    isEmpty();

    for(i=0;i<NUMROWS;i=i+1)  begin
      tagAddr[TAGADDRBITS-1:0] = 4;
      rowAddr[ROWADDRBITS-1:0] = i;
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h2;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_INVAL;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("invalidWaybyIndexTest READ_REQ %s  ",  cpuReqT.creqSprint))
    clock(10);
   end
    clock(1000);
    isEmpty();

for(j=0;j<NUMWAYS;j = j+1) begin
    for(i=0;i<NUMROWS;i=i+1)  begin
     if(j == 3) begin
      tagAddr[TAGADDRBITS-1:0] = 3;
     end else begin
      tagAddr[TAGADDRBITS-1:0] = 7+j;
     end

      rowAddr[ROWADDRBITS-1:0] = i;
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h3;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_READ;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("invalidWaybyIndexTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
end
    clock(1000);
    isEmpty();

      `TB_YAP(" INST CACHE CAPACITY  TEST END  ")
   end
endtask:invalidWaybyIndexTest


task sendRandomIcacheReq(input integer count,input reg stallDis,input reg outOfOrderDis,input reg cacheReads,input reg rowSelectRandomEn,input reg randomL2ErrorEn);
  reg [ROWADDRBITS-1:0]rowAddr;
  reg [ROWADDRBITS-1:0]rowAddrArry[5];
  reg [BYTEADDBITS-1:0]byteAddr;
  reg [NXSIZEWIDTH-1:0]byteSize;
  reg [TAGADDRBITS-1:0] tagAddr;
  reg [2:0]tagRandomAddr;
  reg [NXADDRWIDTH-1:0]reqAddr;
  reg [NXADDRWIDTH-1:0]memAddr;
  reg [NXDATAWIDTH-1:0]wrData;
  reg [1:0]reqType;
  reg [31:0]loopCount = count;
  reg [31:0]loopCount_1 = 1;
  bit byteSizeDone =0;
  bit nonCacheAddr;
  bit invalCacheAddr;
  integer i;
  reg [2:0]cattr;
  bit enableL2Error;
  reg [31:0]MinVal,MaxVal;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
  begin
       if(outOfOrderDis == 1) begin
      	 outOfOrderRspEn = 0;
      	`TB_YAP($psprintf("OutOfOrder RSp Disable %d ",  outOfOrderRspEn ))
       end else if(outOfOrderDis == 0) begin
      	 outOfOrderRspEn = 1;
      	`TB_YAP($psprintf("OutOfOrder RSp Disable %d ",  outOfOrderRspEn ))
       end
   	if(stallDis == 1) begin
      	   slvTr[0].stallEn = 0;
           `TB_YAP($psprintf("Stall Disable %d ",  slvTr[0].stallEn ))
        end else if(stallDis == 0) begin
      	   slvTr[0].stallEn = 1;
           `TB_YAP($psprintf("Stall Disable %d ",  slvTr[0].stallEn ))
        end
        if(randomL2ErrorEn == 1) begin
           insertL2Error = 1;
           `TB_YAP($psprintf("TestbenchReq  insertL2Error %d  ", insertL2Error))
        end else if(randomL2ErrorEn == 0) begin
           insertL2Error = 0;
           `TB_YAP($psprintf("TestbenchReq  insertL2Error %d  ", insertL2Error))
        end
       rowAddrArry[1] = $urandom_range(1,126);
       rowAddrArry[0] = (rowSelectRandomEn == 0) ? rowAddrArry[1] : rowAddrArry[1] - 1;
       rowAddrArry[2] = (rowSelectRandomEn == 0) ? rowAddrArry[1] : rowAddrArry[1] + 1;
       rowAddrArry[3] = (rowSelectRandomEn == 0) ? rowAddrArry[1] : 0;
       rowAddrArry[4] = (rowSelectRandomEn == 0) ? rowAddrArry[1] : 127;
       for(i=0; i<5; i = i+1) begin
             `TB_YAP($psprintf("TestbenchReq rowAddrArry[%d] = %d  ", i,rowAddrArry[i]))
       end
       nonCacheArray.delete;
       while(loopCount[31:0] !=0) begin
          cpuReqT = new();
          tagRandomAddr[2:0] = $urandom_range(1,7);
          byteAddr[BYTEADDBITS-1:0] = $urandom_range('h0,'h1f);
          MinVal[31:0] = 0;
          MaxVal[31:0] = {TAGADDRBITS{1'b1}};
          tagAddr[TAGADDRBITS-1:0] = $urandom_range(MinVal,MaxVal);
          //tagAddr[TAGADDRBITS-1:0] = 19'h0;
          reqType[1:0] = 2'h1;
          byteSizeDone = 0;
          while(byteSizeDone == 0)  begin
             byteSize[NXSIZEWIDTH-1:0] = $urandom_range('h1,'h20);
             if((byteAddr[BYTEADDBITS-1:0] + byteSize[NXSIZEWIDTH-1:0]) <= 'h20) begin
                 byteSizeDone = 1; end
           //`DEBUG($psprintf("TestbenchReq byteAddr  %x  byteSize %x  ",  byteAddr[4:0],byteSize[7:0]))
          end
          rowAddr[6:0] = rowAddrArry[$urandom_range(0,4)];
          wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,reqAddr[NXADDRWIDTH-1:0]);
          invalCacheAddr = 0;
          if(cacheReads == 0) begin
          	reqAddr[NXADDRWIDTH-1:0] = {2'h1,tagAddr[TAGADDRBITS-1-2:3],tagRandomAddr[2:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
                wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,reqAddr[NXADDRWIDTH-1:0]);
                if(insertL2Error == 1) begin
                  enableL2Error = (($urandom%100) < 50);
                  {l2RrspDataErr,l2RrspAddErr} = 2'b00;
                  if(enableL2Error == 1'b1) begin
                     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);
                  end 
                end
                wrData[NXDATAWIDTH-1:NXDATAWIDTH-2] = {l2RrspDataErr,l2RrspAddErr};
                wrData[39:32] = byteSize[NXSIZEWIDTH-1:0];
                `DEBUG($psprintf("TestbenchReq reqAddr  %x  ", reqAddr[NXADDRWIDTH-1:0] ))
                if(!(nonCacheArray.exists(reqAddr[NXADDRWIDTH-1:0]))) begin
                  nonCacheArray[reqAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
                end
          end else begin
                tagAddr[TAGADDRBITS-1:0] = 19'h0;
          	reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:3],tagRandomAddr[2:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
          	//reqAddr[NXADDRWIDTH-1:0] = {tagAddr[18:3],tagRandomAddr[2:0],rowAddr[6:0],5'h0};
          	//byteSize[7:0] ='h20;
                 if((loopCount_1%1000) > 500)  begin
                    invalCacheAddr = $urandom_range(0,1);
                     //`DEBUG($psprintf("TestbenchReq CACHE_INVAL loopCount_1 %d invalCacheAddr %d ", loopCount_1,invalCacheAddr ))
                 end
                 loopCount_1 = loopCount_1 + 1;
                 wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,reqAddr[NXADDRWIDTH-1:0]);
                 memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:3],tagRandomAddr[2:0],rowAddr[ROWADDRBITS-1:0],5'h0};
                //if(!(memArray.exists(memAddr[NXADDRWIDTH-1:0]))) begin
                //    memArray[memAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
                //end
          end
           cpuReqT.addr = (invalCacheAddr == 1) ? memAddr[NXADDRWIDTH-1:0] : reqAddr[NXADDRWIDTH-1:0];
           if(invalCacheAddr == 1'b1) begin
              cpuReqT.cattr = (cacheReads == 1) ? ((forceAckForallReq == 1'b1) ? 3'h3 : 3'h2 ): 3'h0;
           end else begin
              cpuReqT.cattr = (cacheReads == 1) ? 3'h3 : 3'h1;
           end
           cpuReqT.size = (invalCacheAddr == 1) ? 8'h20 : (cacheReads == 1) ? byteSize[NXSIZEWIDTH-1:0] :  nonCacheArray[reqAddr[NXADDRWIDTH-1:0]][39:32];
           cpuReqT.reqType = (invalCacheAddr == 0) ? CH_READ : CH_INVAL;
           mstTr[0].send(cpuReqT);
           loopCount[31:0] = loopCount[31:0] - 1; 
           if(((loopCount[31:0]%1000) == 1) && (cacheReads == 1)) begin
            RARReq();
          end 
           //`DEBUG($psprintf("TestbenchReq Send_REQ %s  loopCount %d ",  cpuReqT.creqSprint,loopCount))
       end

    clock(1000);
    isEmpty();
  end
endtask :sendRandomIcacheReq
/*
*/


task RARReq();
    reg [3:0]tagRandomAddr;
    reg [NXADDRWIDTH-1:0]reqAddr;
    reg [TAGADDRBITS-1:0]tagAddr = 0;
    reg [ROWADDRBITS-1:0]rowAddr = 0;
    integer i;
    MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) wfirReqT;
   reg [7:0] z;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   reg [31:0]MinVal,MaxVal;
   begin
     for(z=0;z<30;z = z+1) begin
         rowAddr[ROWADDRBITS-1:0] =100;
         tagAddr[TAGADDRBITS-1:0] = 'h0;
         if(z[0] == 1) begin
           tagRandomAddr[3:0] = 4;
         end else begin
           tagRandomAddr[3:0] = 5;
         end  
        reqAddr[NXADDRWIDTH-1:0] =  {tagAddr[TAGADDRBITS-1:4],tagRandomAddr[3:0],rowAddr[ROWADDRBITS-1:0],5'h0};
        wfirReqT = new();
        wfirReqT.addr = reqAddr[NXADDRWIDTH-1:0];
        wfirReqT.cattr = 3'h3;
        wfirReqT.size = 'h20;
        wfirReqT.reqType = CH_READ;
        mstTr[0].send(wfirReqT);
        wfirReqT = new();
        wfirReqT.addr = reqAddr[NXADDRWIDTH-1:0];
        wfirReqT.cattr = 3'h3;
        wfirReqT.size = 'h20;
        wfirReqT.reqType = CH_READ;
        mstTr[0].send(wfirReqT);
        wfirReqT = new();
        wfirReqT.addr = reqAddr[NXADDRWIDTH-1:0];
        wfirReqT.cattr = 3'h2;
        wfirReqT.size = 'h20;
        wfirReqT.reqType = CH_INVAL;
        mstTr[0].send(wfirReqT);
        wfirReqT = new();
        wfirReqT.addr = reqAddr[NXADDRWIDTH-1:0];
        wfirReqT.cattr = 3'h3;
        wfirReqT.size = 'h20;
        wfirReqT.reqType = CH_READ;
        mstTr[0].send(wfirReqT);
        wfirReqT = new();
        wfirReqT.addr = reqAddr[NXADDRWIDTH-1:0];
        wfirReqT.cattr = 3'h2;
        wfirReqT.size = 'h20;
        wfirReqT.reqType = CH_INVAL;
        mstTr[0].send(wfirReqT);
      end
    end
endtask:RARReq


task sendReq(input reg [NXADDRWIDTH-1:0]reqAddr,input reg [NXTYPEWIDTH-1:0]reqType,input reg [NXSIZEWIDTH-1:0]reqSize, input reg [NXATTRWIDTH-1:0]reqattr);
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   reg [NXADDRWIDTH-1:0] cacheAddr;
   reg [NXDATAWIDTH-1:0] wrData;

     begin
    if(reqattr[1] == CH_REQ_NOCACHE) begin
      cacheAddr[NXADDRWIDTH-1:0] = reqAddr[NXADDRWIDTH-1:0];
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      wrData[39:32] = {1'b0,reqattr[NXATTRWIDTH-1:0],reqSize[NXSIZEWIDTH-1:0]};
      nonCacheArray[cacheAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
    end else begin
      cacheAddr[NXADDRWIDTH-1:0] = {reqAddr[NXADDRWIDTH-1:5],5'h0};
      if(!(memArray.exists(cacheAddr[NXADDRWIDTH-1:0]))) begin
          memArray[cacheAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
      end
    end
      cpuReqT = new();
      cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = reqattr;
      cpuReqT.size = reqSize;
      cpuReqT.reqType = reqType;

      if(reqType == CH_WRITE) begin
        cpuReqT.dattr = 1;
        cpuReqT.data = wrData;
      end

      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("sendReq READ_REQ %s  ",  cpuReqT.creqSprint))



     end
endtask


task monCpuWrRsp();
     begin
       while(1) begin
        cpuWrRspT = new();
        cpuWrRspT.data = 0;
        mstTr[0].writeRspReceive(cpuWrRspT);
        `DEBUG($psprintf("monCpuWrRsp rReq %s  ", cpuWrRspT.rreqSprint))
         if((cpuWrRspT.reqType == CH_WRITE)&& (cpuWrRspT.cattr[1] == CH_REQ_CACHE)) begin
            cpuRspCacheWrTr[63:0] = cpuRspCacheWrTr[63:0] + 1;
         end else if((cpuWrRspT.reqType == CH_WRITE)&& (cpuWrRspT.cattr[1] == CH_REQ_NOACK)) begin
            cpuRspNonCacheWrTr[63:0] = cpuRspNonCacheWrTr[63:0] + 1;
         end else if((cpuWrRspT.reqType == CH_FLUSH)&& (cpuWrRspT.cattr[1] == CH_REQ_CACHE)) begin
            cpuRspCacheFlushTr[63:0] = cpuRspCacheFlushTr[63:0] + 1;
         end else if((cpuWrRspT.reqType == CH_INVAL)&& (cpuWrRspT.cattr[1] == CH_REQ_CACHE)) begin
            cpuRspCacheInvalidTr[63:0] = cpuRspCacheInvalidTr[63:0] + 1;
         end
         monCpuWrRspQueue.put(cpuWrRspT);
           
       end
     end
endtask:monCpuWrRsp

task monCpuRdRsp();
     begin
       while(1) begin
        cpuRdRspT = new();
        cpuRdRspT.data = 0;
        mstTr[0].readDataReceive(cpuRdRspT);
         if((cpuRdRspT.reqType == CH_READ)&& (cpuRdRspT.cattr[1] == CH_REQ_CACHE)) begin
            cpuRspCacheRdTr[63:0] = cpuRspCacheRdTr[63:0] + 1;
         end else if((cpuRdRspT.reqType == CH_READ)&& (cpuRdRspT.cattr[1] == CH_REQ_NOACK)) begin
            cpuRspNonCacheRdTr[63:0] = cpuRspNonCacheRdTr[63:0] + 1;
         end
        `DEBUG($psprintf("monCpuRdRsp cReq %s  ", cpuRdRspT.creqSprint))
        `DEBUG($psprintf("monCpuRdRsp rReq %s  ", cpuRdRspT.rreqSprint))
         monCpuRdRspQueue.put(cpuRdRspT);
       end
     end
endtask:monCpuRdRsp


task monl2WrReq();
    MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2WrMonT1;
    begin
       while(1) begin
        l2WrMonT = new();
        //l2WrMonT1 = new();
        l2WrMonT.data = 0;
        slvTr[0].wrReceive(l2WrMonT);
        `DEBUG($psprintf("monl2WrReq cReq %s  ", l2WrMonT.creqSprint))
        `DEBUG($psprintf("monl2WrReq dReq %s  ", l2WrMonT.dreqSprint))
         if(l2WrMonT.cattr[1] == CH_REQ_CACHE) begin
             if(l2WrMonT.cattr[0] == CH_REQ_ACK) begin
               l2RspCacheWrACKTr[63:0] = l2RspCacheWrACKTr[63:0] + 1;
             end else begin
               l2RspCacheWrNOACKTr[63:0] = l2RspCacheWrNOACKTr[63:0] + 1;
             end
             l2RspCacheWrTr[63:0] = l2RspCacheWrTr[63:0] + 1;
         
         end else begin
             if(l2WrMonT.cattr[0] == CH_REQ_ACK) begin
               l2RspNonCacheWrACKTr[63:0] = l2RspNonCacheWrACKTr[63:0] + 1;
             end else begin
               l2RspNonCacheWrNOACKTr[63:0] = l2RspNonCacheWrNOACKTr[63:0] + 1;
             end
             l2RspNonCycheWrTr[63:0] = l2RspNonCycheWrTr[63:0] + 1;
         end
         l2WrMonT1 = new l2WrMonT;
         if(l2WrMonT.cattr[0] == 1) begin
           l2WrMonT.rattr = 'h1;
           l2WrMonT.rId = l2WrMonT.cId;
           l2WrMonT.data = 0;
           `DEBUG($psprintf("monl2WrReq rReq %s  ", l2WrMonT.rreqSprint))
           slvTr[0].send(l2WrMonT);
        end
        `DEBUG($psprintf("monl2WrReq cReq %s  ", l2WrMonT1.creqSprint))
        `DEBUG($psprintf("monl2WrReq dReq %s  ", l2WrMonT1.dreqSprint))
        monL2WrRspQueue.put(l2WrMonT1);
       end
     end
endtask:monl2WrReq

task monl2RdAddReq();
    bit pushFBSel;
    begin
       reg  [NXDATAWIDTH-1:0]wrData;
       bit enableL2Error;
       while(1) begin
        l2RdAMonT = new();
        l2RdAMonT.data = 0;
        slvTr[0].rdAddReceive(l2RdAMonT);
        `DEBUG($psprintf("monl2RdAddReq cReq %s  ", l2RdAMonT.creqSprint))
        if(l2RdAMonT.cattr[1] == CH_REQ_NOCACHE) begin
           l2RspNonCacheRdTr[63:0] = l2RspNonCacheRdTr[63:0] + 1;
           if(!(nonCacheArray.exists(l2RdAMonT.addr)))  begin
               `ERROR($psprintf("monl2RdAddReq nonCacheArray not created for cReq %s  ", l2RdAMonT.creqSprint))
           end else begin
              l2RdAMonT.data = nonCacheArray[l2RdAMonT.addr];
              l2RdAMonT.rattr = {l2RdAMonT.data[NXDATAWIDTH-1:NXDATAWIDTH-2],1'b1} ;
           end
        end else if(l2RdAMonT.cattr[1] == CH_REQ_CACHE) begin
          l2RspCacheRdTr[63:0] = l2RspCacheRdTr[63:0] + 1;
          wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,l2RdAMonT.addr);
          enableL2Error = 0;
          if(insertL2Error == 1) begin
              enableL2Error = (($urandom%100) < 25);
              {l2RrspDataErr,l2RrspAddErr} = 2'b00;
              if(enableL2Error == 1'b1) begin
                 {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);
                 `DEBUG($psprintf("monl2RdAddReq L2_ERROR Inserted raatr %x ", {l2RrspDataErr,l2RrspAddErr}))
              end 
            end
            wrData[NXDATAWIDTH-1:NXDATAWIDTH-2] = {l2RrspDataErr,l2RrspAddErr};
            l2RdAMonT.data = wrData[NXDATAWIDTH-1:0]; 
          memArray[l2RdAMonT.addr] = (enableL2Error == 1'b1) ?  {wrData[NXDATAWIDTH-1:128],128'h0} : wrData[NXDATAWIDTH-1:0];
          l2RdAMonT.data = memArray[l2RdAMonT.addr];
          l2RdAMonT.rattr = {l2RdAMonT.data[NXDATAWIDTH-1:NXDATAWIDTH-2],1'b1} ;
        end
        l2RdAMonT.rId = l2RdAMonT.cId ;

        if(l2RdAMonT.cattr[1] == CH_REQ_NOCACHE) begin
           if((l2RdAMonT.addr == l2RdAMonT.data[NXADDRWIDTH-1:0]) && (l2RdAMonT.size == l2RdAMonT.data[39:32])) begin
                  `DEBUG($psprintf("monl2RdAddReq Non CacheRd Req Addr and Size match with expected cReq %s  ", l2RdAMonT.creqSprint))
           end else begin
                  `ERROR($psprintf("monl2RdAddReq Non CacheRd Req Addr and Size Not match with expected cReq %s  ", l2RdAMonT.creqSprint))
           end

        end

        if((l2RspCacheRdTr[63:0] + l2RspNonCacheRdTr[63:0])%10000 < 5000) begin
           outOfOrderRspDis = 0;
        end else begin
           outOfOrderRspDis = 1;
        end

        if (outOfOrderRspEn == 1) begin // code for out of order
          pushFBSel = (outOfOrderRspDis == 1) ? 0 : $urandom_range(0,1);
          if(pushFBSel == 1) begin
            outOfOrdrQueue.push_front(l2RdAMonT);
          end else begin
            outOfOrdrQueue.push_back(l2RdAMonT);
          end 
          `DEBUG($psprintf("monl2RdAddReq outoffOrder rReq data %s  ", l2RdAMonT.rreqSprint))
        end else  begin
          slvTr[0].send(l2RdAMonT);
          `DEBUG($psprintf("monl2RdAddReq rReq data %s  ", l2RdAMonT.rreqSprint))
        end

     end
    end
endtask:monl2RdAddReq



task sendL2RdRsp();
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2RdDataTr;
    reg [31:0]MinVal,MaxVal;
    integer k,l,m,n;
    bit Done;
    bit popFBSel;
    MinVal[31:0] = 0;
    MaxVal[31:0] = 5;
    while(1) begin
       while(outOfOrdrQueue.size() == 0 ) begin
          clock(1);
       end

       k = (outOfOrderRspDis == 1) ? 2 :$urandom_range(MinVal,MaxVal);
       l = 0; 
       while((outOfOrdrQueue.size() < k) && (l < 100)) begin
       `DEBUG($psprintf("sendL2RdRsp k  %d , size %d l %d time %t ",k,outOfOrdrQueue.size(),l,$time))
          clock(1);
          l = l+1;
       end
       n = outOfOrdrQueue.size();
       `DEBUG($psprintf("sendL2RdRsp outOfOrdrQueue Size  %d  ",n))
       for(m=0; m<n; m = m+1) begin
          popFBSel = (outOfOrderRspDis == 1) ? 1 :$urandom_range(0,1);
          if(popFBSel == 1) begin
            l2RdDataTr = outOfOrdrQueue.pop_front();
          end else begin
            l2RdDataTr = outOfOrdrQueue.pop_back();
          end 
          slvTr[0].send(l2RdDataTr);
          `DEBUG($psprintf("sendL2RdRsp rReq data %s  ", l2RdDataTr.rreqSprint))
      end

    end
  endtask:sendL2RdRsp


function [NXDATAWIDTH-1:0] randomData(input integer width,input [30:0]addr); 
integer m; 
    randomData = 0; 
    for (m = width/32; m >= 0; m--) 
      randomData = (randomData << 32) + $urandom + 32'h12345678; 

     //randomData[NXDATAWIDTH-1:0] = 'h0;
     randomData[30:0] = addr;
endfunction

function [NXDATAWIDTH-1:0] randomMemData(input integer width); 
integer m; 
    randomMemData = 0; 
    for (m = width/32; m >= 0; m--) 
      randomMemData = (randomMemData << 32) + $urandom + 32'h12345678;
endfunction

function [NXDATAWIDTH-1:0] randomWrData(input integer width,input [NXADDRWIDTH-1:0]addr); 
integer m; 
reg[NXADDRWIDTH-1:0]memaddr;
reg[NXDATAWIDTH-1:0]randData;
reg [7:0]inArray[32];

    randomWrData = 0; 
    randData = 0; 
    memaddr[NXADDRWIDTH-1:0] = {addr[NXADDRWIDTH-1:5],5'h0};
    for (m = width/32; m >= 0; m--) 
      randData = (randData << 32) + $urandom + $urandom;
 
      if(!(wrDataMemArray.exists(memaddr[NXADDRWIDTH-1:0]))) begin
           wrDataMemArray[memaddr[NXADDRWIDTH-1:0]] = randData;
           randomWrData = randData;
      end else begin
           randData = wrDataMemArray[memaddr[NXADDRWIDTH-1:0]];
           //`DEBUG($psprintf(" SREE_SURESH 1 addr 0x%x  0x%x  ", memaddr[NXADDRWIDTH-1:0],randData))
           for (m = 0; m <32 ; m = m+1) begin
              inArray[m] = randData[NXDATAWIDTH-1:0] >> m*8;
           end 
           for (m = 0; m <32 ; m = m+1) begin
              inArray[m] = inArray[m]+1;
           end 
           randomWrData = 0;
           for (m = 32; m >= 0; m--) 
             randomWrData = randomWrData << 8 | (inArray[m]) ;

           //`DEBUG($psprintf(" SREE_SURESH 2 addr 0x%x  0x%x  ", memaddr[NXADDRWIDTH-1:0],randomWrData))
           wrDataMemArray[memaddr[NXADDRWIDTH-1:0]] = randomWrData;
     end

endfunction

        task automatic cpuCreqMon;
           while(1)
              begin  
                 cpuCbusMonT = new();
                  mstTr[0].creqBusMonReceive(cpuCbusMonT);
                  cpuCreqMonQueue.put(cpuCbusMonT); 
                       `DEBUG($psprintf(" DUVCPUMON cpuCreqMon  creq %s  ", cpuCbusMonT.creqSprint))
              end
        endtask:cpuCreqMon
          
        
        task automatic cpuDreqMon;
           while(1)
              begin  
                 cpuDbusMonT = new();
                  mstTr[0].dreqBusMonReceive(cpuDbusMonT);
                       `DEBUG($psprintf(" DUVCPUMON cpuDreqMon  dreq %s  ", cpuDbusMonT.dreqSprint))
                 cpuDreqMonQueue.put(cpuDbusMonT); 
              end
        endtask:cpuDreqMon
          
        
        task automatic cpuRreqMon();
           while(1)
              begin  
                 cpuRbusMonT = new();
                 mstTr[0].rreqBusMonReceive(cpuRbusMonT);
                       `DEBUG($psprintf(" DUVCPUMON cpuRreqMon  rreq %s  ", cpuRbusMonT.rreqSprint))
                 cpuRreqMonQueue.put(cpuRbusMonT); 
              end
        endtask:cpuRreqMon

        task automatic l2CreqMon;
           while(1)
              begin  
                 l2CbusMonT = new();
                 slvTr[0].creqBusMonReceive(l2CbusMonT);
                 l2CreqMonQueue.put(l2CbusMonT); 
              end
        endtask:l2CreqMon
          
        
        task automatic l2DreqMon;
           while(1)
              begin  
                 l2DbusMonT = new();
                 slvTr[0].dreqBusMonReceive(l2DbusMonT);
                 l2DreqMonQueue.put(l2DbusMonT); 
              end
        endtask:l2DreqMon
          
        
        task automatic l2RreqMon();
           while(1)
              begin  
                 l2RbusMonT = new();
                 slvTr[0].rreqBusMonReceive(l2RbusMonT);
                 l2RreqMonQueue.put(l2RbusMonT); 
              end
        endtask:l2RreqMon

/*
*/

        task automatic cpuReqTrMon;
	   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuCMonT;
	   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuDMonT;
	   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuMonT;
	   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReadAddMonT;
           while(1)
              begin 
                 cpuCreqMonQueue.get(cpuCMonT);
                       `DEBUG($psprintf("cpuReqTrMon cpuCMonT %s  ", cpuCMonT.creqSprint))
                 if(cpuCMonT.reqType == CH_READ) begin
                       `DEBUG($psprintf("cpuReqTrMon cpuCMonT Read %s  ", cpuCMonT.creqSprint))
                    cpuReadAddMonT = new();
                    cpuMonT = cpuCMonT;
                    cpuReadAddMonT = cpuCMonT;
                    if(cpuCMonT.cattr[1] == CH_REQ_CACHE) begin
                       cpuReqQueue.put(cpuMonT);
                    end
                    cpuRdMonArrayQueue[cpuMonT.cId] = cpuReadAddMonT;
                 end else if((cpuCMonT.reqType == CH_WRITE) || (cpuCMonT.reqType == CH_FLUSH) || (cpuCMonT.reqType == CH_INVAL))begin
                       `DEBUG($psprintf("cpuReqTrMon cpuCMonT Write or Flush or Inval %s  ", cpuCMonT.creqSprint))
                    cpuMonT = new cpuCMonT;
                    if(cpuCMonT.reqType == CH_WRITE) begin
                      cpuDreqMonQueue.get(cpuDMonT);
                         `DEBUG($psprintf("cpuReqTrMon cpuCMonT Write Data %s  ", cpuDMonT.dreqSprint))
                      if(cpuMonT.dId != cpuDMonT.cId) begin
                         `ERROR($psprintf("cpuReqTrMon CpuWrcReq %s  ", cpuMonT.creqSprint))
                      end
                    cpuMonT.dattr  = cpuDMonT.dattr;
                    cpuMonT.dId    = cpuDMonT.dId;
                    cpuMonT.data   = cpuDMonT.data;
                    end
                    cpuReqQueue.put(cpuMonT);
                       `DEBUG($psprintf("cpuReqTrMon cpuCMonT Write Cap creq %s  ", cpuMonT.creqSprint))
                       `DEBUG($psprintf("cpuReqTrMon cpuCMonT Write Cap dreq %s  ", cpuMonT.dreqSprint))
                end
              end
        endtask:cpuReqTrMon   


        task automatic l2ReqTrMon;
	   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2CMonT;
	   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2DMonT;
	   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2MonT;
           while(1)
              begin 
                 l2CreqMonQueue.get(l2CMonT);
                 l2MonT = new();
                 if(l2CMonT.reqType == CH_READ) begin
                    l2MonT = l2CMonT;
                    l2RdAddMonArrayQueue[l2CMonT.cId] = l2MonT;
                 end else if(l2CMonT.reqType == CH_WRITE) begin
                    l2MonT = l2CMonT;
                    l2DreqMonQueue.get(l2DMonT);
                    if(l2MonT.dId != l2DMonT.cId) begin
                       `ERROR($psprintf("DuvModel L2ReqTrMon CpuWrcReq %s  ", l2MonT.creqSprint))
                    end
                    l2MonT.dattr  = l2DMonT.dattr;
                    l2MonT.dId    = l2DMonT.dId;
                    l2MonT.data   = l2DMonT.data;
                    l2WrMonQueue.put(l2MonT);
                       `DEBUG($psprintf("DuvModel after l2WrMonQueue CpuWrcReq %s  ", l2MonT.dreqSprint))
                 end else if(l2CMonT.reqType == CH_FLUSH) begin
                    l2MonT = l2CMonT;
                    l2WrMonQueue.put(l2MonT);
                 end else if(l2CMonT.reqType == CH_INVAL) begin
                    l2MonT = l2CMonT;
                    l2WrMonQueue.put(l2MonT);
                 end
              end
        endtask:l2ReqTrMon



    task l2ReadTrMoniter;  // capture L2 Read Responce
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2RdDTr;
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2Tr;
        while(1) begin
            l2RreqMonQueue.get(l2RdDTr);   
            if(!(l2RdAddMonArrayQueue.exists(l2RdDTr.rId)))
                $finish;
            l2Tr = l2RdAddMonArrayQueue[l2RdDTr.rId];
            l2Tr.rattr = l2RdDTr.rattr;
            l2Tr.rId   = l2RdDTr.rId; 
            l2Tr.data  = l2RdDTr.data;
               `DEBUG($psprintf("l2RreqMonQueue cReq %s  ", l2Tr.rreqSprint))
               `DEBUG($psprintf("l2RreqMonQueue dReq %s  ", l2Tr.rreqSprint))
               `DEBUG($psprintf("l2RreqMonQueue rReq %s  ", l2Tr.rreqSprint))
            l2RdMonQueue.put(l2Tr);
        end
    endtask:l2ReadTrMoniter

    task cpuReadTrMoniter;  // capture RTL Read Responce
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuRdDTr;
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuTr;
        while(1) begin
            cpuRreqMonQueue.get(cpuRdDTr);  
            if(cpuRdMonArrayQueue.exists(cpuRdDTr.rId)) begin
               cpuTr = cpuRdMonArrayQueue[cpuRdDTr.rId];
               cpuTr.rattr = cpuRdDTr.rattr;
               cpuTr.rId   = cpuRdDTr.rId; 
               cpuTr.data  = cpuRdDTr.data;
               cpuRdMonQueue.put(cpuTr);
            end
        end
    endtask:cpuReadTrMoniter



function reg [NXDATAWIDTH-1:0]computeCacheData(input [NXDATAWIDTH-1:0] cacheData,MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) penTr);
//input [NXDATAWIDTH-1:0] cacheData;
//MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) penTr;
reg[NXDATAWIDTH-1:0] inData;
reg [NXADDRWIDTH-1:0] addr;
reg [NXSIZEWIDTH-1:0] size;
reg [7:0] inArray[32];
reg [7:0] cacheArray[32];
reg [NXDATAWIDTH-1:0] tempData;
integer m,n; 
    inData[NXDATAWIDTH-1:0] = penTr.data;
    size[NXSIZEWIDTH-1:0] = penTr.size;
    addr[NXADDRWIDTH-1:0] = penTr.addr;
    for (m = 0; m <32 ; m = m+1) begin
        inArray[m] = inData[NXDATAWIDTH-1:0] >> m*8;
        cacheArray[m] = cacheData[NXDATAWIDTH-1:0] >> m*8;
    end 
    for (m = addr[4:0]; m < addr[4:0]+size[NXSIZEWIDTH-1:0]  ; m = m+1) begin
          cacheArray[m] = inArray[m];
    end

    tempData[NXDATAWIDTH-1:0] = {NXDATAWIDTH{1'b0}};
    //for (m = 0; m <32 ; m = m+1) begin  //FIXME
    //    tempData[NXDATAWIDTH-1:0] = tempData[NXDATAWIDTH-1:0] << m*8 | cacheArray[31 - m];
    //end 
    tempData[NXDATAWIDTH-1:0] = {cacheArray[31],cacheArray[30],cacheArray[29],cacheArray[28],cacheArray[27],cacheArray[26],cacheArray[25],cacheArray[24],cacheArray[23],cacheArray[22],cacheArray[21],cacheArray[20],cacheArray[19],cacheArray[18],cacheArray[17],cacheArray[16],cacheArray[15],cacheArray[14],cacheArray[13],cacheArray[12],cacheArray[11],cacheArray[10],cacheArray[9],cacheArray[8],cacheArray[7],cacheArray[6],cacheArray[5],cacheArray[4],cacheArray[3],cacheArray[2],cacheArray[1],cacheArray[0]};
    computeCacheData[NXDATAWIDTH-1:0] = tempData[NXDATAWIDTH-1:0];
endfunction:computeCacheData
/*

*/


task readCheckTask;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuRdDataT;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuRdReqTr;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuWrTr;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) IARTr;
  reg [NXDATAWIDTH-1:0] cpuRdData;
  reg [NXADDRWIDTH-1:0] cpuRdAddr;
  reg [NXDATAWIDTH-1:0] comuteData;
  bit readDataMatchWithFill;
  bit readDataMatchWithHit;
  bit readDataMatchWithEvictMem;
  integer fillSize;
  integer hitSize;
  reg [NXATTRWIDTH-1:0]rattr;
   integer queueSize,i;
   bit RARFound;
   bit IARFound;
   bit l2ErrorFound;
   while(1) begin
       monCpuRdRspQueue.get(cpuRdDataT);
       cpuRdAddr[NXADDRWIDTH-1:0] = cpuRdDataT.addr;
       cpuRdAddr[4:0] = 'h0;
       rattr[NXATTRWIDTH-1:0] = cpuRdDataT.rattr;
       readDataMatchWithFill = 0;
       readDataMatchWithHit = 0;
       readDataMatchWithEvictMem = 0;
       RARFound = 1'h0;
       IARFound = 1'h0;
       l2ErrorFound = 1'b0;
       if(cpuRdDataT.cattr[1] == CH_REQ_NOCACHE)  begin
         if(rattr[NXATTRWIDTH-1:NXATTRWIDTH-2] != 2'b00) begin
            if(rattr[NXATTRWIDTH-1:NXATTRWIDTH-2] == nonCacheArray[cpuRdDataT.addr][NXDATAWIDTH-1:NXDATAWIDTH-2]) begin
              `DEBUG($psprintf(" cpuReadCheck cpu Non Cache raat bits are MATCH with L2 raat %x ", rattr[NXATTRWIDTH-1:0]))
            end else begin
              `ERROR($psprintf(" cpuReadCheck cpu Non Cache raat bits are NOT_MATCH with L2 raat. CPU_RATTR %x L2_RAATR %x ", rattr[NXATTRWIDTH-1:0],nonCacheArray[cpuRdDataT.addr][NXDATAWIDTH-1 : NXDATAWIDTH-2]))
            end
         end
         if(cpuRdDataT.data  !=  nonCacheArray[cpuRdDataT.addr]) begin
          `TB_YAP($psprintf(" NON CACHE RD DATA is invalid"))
          `TB_YAP($psprintf(" CPU Read  TR cReq %s  ", cpuRdDataT.creqSprint))
          `TB_YAP($psprintf(" CPU RD Data 0x%x  ", cpuRdDataT.data))
          `TB_YAP($psprintf(" CACHE  Data 0x%x  ", nonCacheArray[cpuRdAddr[NXADDRWIDTH-1:0]]))
          `ERROR($psprintf(" =======CPU READ MISMACH =============="))
         end else begin
          `DEBUG($psprintf(" NON CACHE RD DATA MATCH"))
          `INFO($psprintf(" CPU_CHECK NON_CACHE_READ_PASS cReq %s  ", cpuRdDataT.creqSprint))
         end
       end else begin
          if ((t1_mem_error_check == 1'b1) || (t2_mem_error_check == 1'b1))begin
            if(rattr[NXATTRWIDTH-1:0] != 3'h1) begin
          	  `DEBUG($psprintf(" cpuReadCheck Data Error  Set %x  for t1 mem error test ", rattr[NXATTRWIDTH-1:0]))
              end else begin
          	  `ERROR($psprintf(" cpuReadCheck Data Error Not Set %x for t1 mem error test  ", rattr[NXATTRWIDTH-1:0]))
              end
          end else if(rattr[NXATTRWIDTH-1:NXATTRWIDTH-2] != 2'b00) begin
            if(rattr[NXATTRWIDTH-1:NXATTRWIDTH-2] == memArray[cpuRdAddr[NXADDRWIDTH-1:0]][NXDATAWIDTH-1:NXDATAWIDTH-2]) begin
               l2ErrorFound = 1'b1;
               memArray.delete(cpuRdAddr[NXADDRWIDTH-1:0]);
              `DEBUG($psprintf(" cpuReadCheck cpu  Cache raat bits are MATCH with L2 raat %x ", rattr[NXATTRWIDTH-1:0]))
            end else begin
              `ERROR($psprintf(" cpuReadCheck cpu  Cache raat bits are NOT_MATCH with L2 raat. CPU_RATTR %x L2_RAATR %x ", rattr[NXATTRWIDTH-1:0],memArray[cpuRdAddr[NXADDRWIDTH-1:0]][NXDATAWIDTH-1 : NXDATAWIDTH-2]))
            end
          end else if(cpuRdDataT.data  ==  memArray[cpuRdAddr[NXADDRWIDTH-1:0]]) begin
            `DEBUG($psprintf(" DEBUG_FILL CPU_TR cReq %s  ", cpuRdDataT.creqSprint))
            `DEBUG($psprintf(" DEBUG_FILL memArray[0x%x]  0x%x  ", cpuRdAddr[NXADDRWIDTH-1:0],memArray[cpuRdAddr[NXADDRWIDTH-1:0]]))
          end else begin
              `TB_YAP($psprintf(" CPU Read  TR cReq %s  ", cpuRdDataT.creqSprint))
              `TB_YAP($psprintf(" CPU RD Data 0x%x  ", cpuRdDataT.data))
              if(!(memArray.exists(cpuRdAddr[NXADDRWIDTH-1:0])))  begin
                `TB_YAP($psprintf(" MEM Nor Found Addr 0x%x", cpuRdAddr[NXADDRWIDTH-1:0] ))
              end
              `ERROR($psprintf(" =======CPU READ MISMACH =============="))
          end

          begin
             queueSize = cpuReqQueue.num();
             for(i=0;i<queueSize; i = i+1) begin
                cpuReqQueue.get(cpuRdReqTr);
                if(((cpuRdDataT.addr >> 5) == (cpuRdReqTr.addr >> 5)) && (cpuRdReqTr.reqType == CH_READ) && (IARFound == 1'b0) && (cpuRdReqTr.transactionTime > cpuRdDataT.transactionTime)) begin
                     RARFound = 1'h1;
                end
                if(((cpuRdDataT.addr >> 5) == (cpuRdReqTr.addr >> 5)) && (cpuRdReqTr.reqType == CH_INVAL) &&(cpuRdReqTr.transactionTime > cpuRdDataT.transactionTime) && (RARFound == 'h0)) begin
                     IARFound = 1'h1;
                     IARTr = new cpuRdReqTr;
                end
                if(((cpuRdDataT.addr >> 5) == (cpuRdReqTr.addr >> 5)) && (cpuRdReqTr.transactionTime <= cpuRdDataT.transactionTime)) begin
                   `DEBUG($psprintf(" cpuReadCheck Removeing Tr From cpuReqQueue creq  %s  ", cpuRdReqTr.creqSprint))
                end else begin
                   cpuReqQueue.put(cpuRdReqTr);
                end
             end

             if((IARFound == 1) && (RARFound == 0) && (l2ErrorFound == 0)) begin
                  if(memArray.exists(cpuRdAddr[NXADDRWIDTH-1:0]))  begin
                     `DEBUG($psprintf(" DEBUG_READ. RM_MEM  %t  ",  IARTr.transactionTime))
                     `DEBUG($psprintf(" DEBUG_READ. RM_MEM After Read, Inval found. Removeing all Mem's. @ %t req %s  ", $time, cpuRdDataT.creqSprint))
                      memArray.delete(cpuRdAddr[NXADDRWIDTH-1:0]);
                      if(memArray.exists(cpuRdAddr[NXADDRWIDTH-1:0]))  begin
                        `ERROR($psprintf(" DEBUG_READ. RM_MEM  MEM not deleted Addr 0x%x", cpuRdAddr[NXADDRWIDTH-1:0] ))
                      end
                  end else begin
                        `ERROR($psprintf(" DEBUG_READ. RM_MEM  MEM not exists Addr 0x%x", cpuRdAddr[NXADDRWIDTH-1:0] ))
                  end
             end
          end
       end
   end
endtask



  
task finish();
    begin
      isEmpty();
      clock(1000);
      
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL TR                                 	%d ",mstTr[0].totalTransactions[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL CACHE WRITE TR  				%d ",mstTr[0].totalCacheWriteTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL CACHE READ TR   				%d ",mstTr[0].totalCacheReadTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL NON CACHE WRITE TR   			%d ",mstTr[0].totalNonCacheWriteTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL NON CACHE READ TR   			%d ",mstTr[0].totalNonCacheReadTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL FLUSH TR   				%d ",mstTr[0].totalFlushTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL INVALID TR   				%d ",mstTr[0].totalInvalidTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL CACHE WRITE ACK TR   			%d ",mstTr[0].totalCacheWriteACKTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL CACHE WRITE NO ACK TR   			%d ",mstTr[0].totalCacheWriteNOACKTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL CACHE WRITE ACK TR   			%d ",mstTr[0].totalNonCacheWriteACKTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL CACHE WRITE NO ACK TR   			%d ",mstTr[0].totalNonCacheWriteNOACKTr[63:0]))

             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL CPU RSP FOR CACHE WRITE    		%d ",cpuRspCacheWrTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL CPU RSP FOR NON CACHE WRITE    		%d ",cpuRspNonCacheWrTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL CPU RSP FOR CACHE READ    		%d ",cpuRspCacheRdTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL CPU RSP FOR NON CACHE READ    		%d ",cpuRspNonCacheRdTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL CPU RSP FOR FLUSH    			%d ",cpuRspCacheFlushTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL CPU RSP FOR INVALID    			%d ",cpuRspCacheInvalidTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL L2  RSP FOR CACHE READ    		%d ",l2RspCacheRdTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL L2  RSP FOR NON CACHE READ    		%d ",l2RspNonCacheRdTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL L2  RSP FOR NON CACHE WRITE    		%d ",l2RspNonCycheWrTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL L2  RSP FOR NON CACHE WRITE ACK    	%d ",l2RspNonCacheWrACKTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL L2  RSP FOR NON CACHE WRITE NO ACK    	%d ",l2RspNonCacheWrNOACKTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL L2  RSP FOR  CACHE WRITE    		%d ",l2RspCacheWrTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL L2  RSP FOR  CACHE WRITE ACK    		%d ",l2RspCacheWrACKTr[63:0]))
             `TB_YAP($psprintf(" CACHE_TB_STATS  TOTAL L2  RSP FOR  CACHE WRITE NO ACK    	%d ",l2RspCacheWrNOACKTr[63:0]))


                      `TB_YAP($psprintf(" ================TEST_PASS==============="))
    end
endtask:finish




task isEmpty();
    bit isEmpty;
    begin
       isEmpty = 0;
       while(isEmpty == 0) begin
          clock(1000);
          isEmpty = mstTr[0].isEmptyidArray() && isEmptyL2WrMonMailBox() && isEmptyCpuRdRspMailBox() ;
       end

       while((testbench.ip_top.e_pf_empty == 0) || (testbench.ip_top.e_uc_stall == 1)) begin
           clock(1);
       end 
             `TB_YAP($psprintf(" isEmpty  e_pf_empty %d  e_uc_stall %d ",testbench.ip_top.e_pf_empty,testbench.ip_top.e_uc_stall))
       if(testbench.ip_top.e_pf_oflw == 1) begin
          `ERROR($psprintf("isEmpty  e_pf_oflw %d  ",testbench.ip_top.e_pf_oflw))
       end
    end
endtask:isEmpty 

function isEmptyL2WrMonMailBox;
reg isEmptyMailBox; 
integer reqQueueCount;
begin
      isEmptyMailBox = 0;
          reqQueueCount =monL2WrRspQueue.num() ;
          if(reqQueueCount !=0 ) begin
               isEmptyMailBox = 0;
          end else begin
               isEmptyMailBox = 1;
          end
          `INFO($psprintf("monL2WrRspQueue  Count %d  isEmptyMailBox %d ",reqQueueCount,isEmptyMailBox))
      isEmptyL2WrMonMailBox = isEmptyMailBox;
end 
endfunction:isEmptyL2WrMonMailBox


function isEmptyCpuRdRspMailBox;
reg isEmptyMailBox; 
integer reqQueueCount;
begin
      isEmptyMailBox = 0;
          reqQueueCount =monCpuRdRspQueue.num() ;
          if(reqQueueCount !=0 ) begin
               isEmptyMailBox = 0;
          end else begin
               isEmptyMailBox = 1;
          end
          `INFO($psprintf("monCpuRdRspQueue  Count %d  isEmptyMailBox %d ",reqQueueCount,isEmptyMailBox))
      isEmptyCpuRdRspMailBox = isEmptyMailBox;
end 
endfunction:isEmptyCpuRdRspMailBox


task instCacheRdAllTest ();
     integer k,m,l;
     reg [BYTEADDBITS-1:0] byteAddr;
     reg [ROWADDRBITS-1:0] rowAddr;
     reg [TAGADDRBITS-1:0] tagAddr;
     reg [NXADDRWIDTH-1:0] cacaheAddr;
     
     reg addrArry[*];
     bit Done;
     bit Done1;
     reg [8:0]totalRows;
     reg [31:0]MinVal,MaxVal;

    `TB_YAP("INST CACHE RD ALL TEST STARTED")
     begin
       for(k=0;k<NUMWAYS;k=k+1) begin
           for(m=0;m<NUMROWS;m=m+1)begin
	       cacheAddArray[k][m] = 'h0;
           end
       end
       MinVal[31:0] = 0;
       MaxVal[31:0] = {TAGADDRBITS{1'b1}};
       for(k=0;k<NUMWAYS;k=k+1) begin
           for(m=0;m<NUMROWS;m=m+1)begin
                 byteAddr[BYTEADDBITS-1:0] = 0;
                 rowAddr[ROWADDRBITS-1:0] = m;
                 tagAddr[TAGADDRBITS-1:0] = $urandom_range(MinVal,MaxVal);
                 Done =0;
                 Done1 =0;
                 while(Done == 0) begin
                     cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
                     if(!(addrArry.exists(cacaheAddr[NXADDRWIDTH-1:0])))begin
                          addrArry[cacaheAddr[NXADDRWIDTH-1:0]] = 1;
			  cacheAddArray[k][m] = cacaheAddr[NXADDRWIDTH-1:0];
                          //memArray[cacaheAddr[NXADDRWIDTH-1:0]] = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
                          while(Done1 == 0) begin
                              totalRows[8:0] = $urandom_range(0,511);
                              if(!(cacheRandomAddArray.exists(totalRows[8:0])))begin
                                    cacheRandomAddArray[totalRows[8:0]] = cacaheAddr[NXADDRWIDTH-1:0];
                                    Done1 = 1;
                              end
                          end
                          Done = 1;
                     end else begin
                          tagAddr[TAGADDRBITS-1:0] = $urandom_range(MinVal,MaxVal);
                          Done = 0;
                     end
                 end
           end
        end
  

       for(k=0;k<NUMWAYS;k=k+1) begin
           for(m=0;m<NUMROWS;m=m+1)begin
                     {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]} = cacheAddArray[k][m];
               `INFO($psprintf("CACHE_ADDR way %d row %d  tagAddr[18:0] 0x%x rowAddr[6:0] 0x%x byteAddr[4:0] 0x%x  ",k,m,tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]))
           end
       end
       readCache();
       readCache();
       readCache();
       readCache();
       readCache();
       readCache();
       readCache();
       clock(1000);
       isEmpty();
    `TB_YAP("INST CACHE RD ALL TEST END")
    end
endtask:instCacheRdAllTest



task readCache();
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
       reg [NXADDRWIDTH-1:0]addr;
       reg [NXSIZEWIDTH-1:0]bAddr;
       reg [NXDATAWIDTH-1:0]data;
       integer a;
    `INFO("instCacheRdAllTest READ STARTED")
       for(a=0; a<NUMWAYS*NUMROWS; a = a+1) begin
           addr[NXADDRWIDTH-1:0] = cacheRandomAddArray[a];
           data[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,addr[NXADDRWIDTH-1:0]);
           cpuReqT = new();
           cpuReqT.addr = addr[NXADDRWIDTH-1:0];
           cpuReqT.cattr = 3'h3;
           cpuReqT.size = 8'h20;
           cpuReqT.reqType = CH_READ; 
           mstTr[0].send(cpuReqT);
       end
    clock(1000);
    isEmpty();
    `INFO("instCacheRdAllTest READ END")
endtask:readCache

task statsTest;
     reg [48:0]rtlRdHit;
     reg [48:0]rtlRdMiss;
     reg [48:0]rtlTotalRd;
     reg [48:0]rtlTotalRdCyc;
     reg [48:0]tbRdHit;
     reg [48:0]tbRdMiss;
     reg [48:0]tbTotalRd;
     reg [48:0]tbTotalRdCyc;


     tbRdHit = 0;
     tbRdMiss = 0;
     tbTotalRd = 0;
     tbTotalRdCyc = 0;

     clock(1000);
     isEmpty();

     tbRdHit =  mstTr[0].totalTransactions - l2RspCacheRdTr;
     tbRdMiss = l2RspCacheRdTr; 


     clock(1000);
     isEmpty();


endtask:statsTest


task sendRead(input reg [NXADDRWIDTH-1:0] addr,input reg [7:0] size,input reg uch, input reg ack);
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
  reg [NXDATAWIDTH-1:0]memData;
  reg [NXDATAWIDTH-1:0]wrData;
  begin
    reg [NXADDRWIDTH-1:0] memAddr = (addr >> (BYTEADDBITS)) << (BYTEADDBITS);
    memData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,addr[NXADDRWIDTH-1:0]);
    memData[39:32] = size[NXSIZEWIDTH-1:0];
    if((!(nonCacheArray.exists(addr[NXADDRWIDTH-1:0]))) && (uch == 1))begin
      nonCacheArray[addr[NXADDRWIDTH-1:0]] = memData[NXDATAWIDTH-1:0];
    end
    cpuReqT = new();
    `INFO($psprintf("read addr=0x%0x size=%0d uch=%0b ack=%0b", addr, size, uch, ack))
    cpuReqT.addr = addr; 
    cpuReqT.cattr = (ack << 0) | (!uch << 1);
    cpuReqT.reqType = CH_READ;
    cpuReqT.size = size;
    mstTr[0].send(cpuReqT);
  end
endtask:sendRead


task sendInval(input reg [NXADDRWIDTH-1:0] addr,input reg [7:0] size,input reg uch, input reg ack, input reg byIndex);
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
  begin
    cpuReqT = new();
    `INFO($psprintf("inval addr=0x%0x size=%0d uch=%0b ack=%0b", addr, size, uch, ack))
    cpuReqT.addr = addr; 
    cpuReqT.cattr = (ack << 0) | (!uch << 1) | (byIndex << 2) ;
    cpuReqT.reqType = CH_INVAL;
    cpuReqT.size = size;
    mstTr[0].send(cpuReqT);
  end
endtask:sendInval

task testForT1MemError(input reg [NXADDRWIDTH-1:0]Addr, input integer errorBitPos);
  reg [104-1:0]t1_mem_data;
  reg [6:0]IndexAddr = Addr[NXADDRWIDTH-1:0] >> 5;
  t2_mem_error_check = 0;
  sendInval(Addr,8'h20, 0,0,1);
  clock(10);
  sendInval(Addr,8'h20, 0,0,1);
  clock(10);
  sendInval(Addr,8'h20, 0,0,1);
  clock(10);
  sendInval(Addr,8'h20, 0,0,1);
  clock(10);
  sendRead(Addr, 8'h20, 0, 1); 
  clock(10);
  sendRead(Addr, 8'h20, 0, 1); 
  clock(10000);
  //t1_mem_data[104-1:0] = testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.bank_v0_h0.MEMCORE[IndexAddr];
    `TB_YAP($psprintf("t1_mem_data 0x%0x  ", t1_mem_data[104-1:0]))
  t1_mem_data[104-1:0] = t1_mem_data[104-1:0] ^ 1 << errorBitPos;
    `TB_YAP($psprintf("t1_mem_data 0x%0x  ", t1_mem_data[104-1:0]))
  //testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.bank_v0_h0.MEMCORE[IndexAddr] = t1_mem_data[104-1:0];
  clock(100);
  t1_mem_error_check = 1;
  sendRead(Addr, 8'h20, 0, 1); 
  clock(1000);
  t1_mem_error_check = 0;
endtask 

task testForT2MemError(input reg [NXADDRWIDTH-1:0]Addr, input integer errorBitPos);
  reg [144-1:0]t2_mem_data;
  reg [6:0]IndexAddr = Addr[NXADDRWIDTH-1:0] >> 5;
  t1_mem_error_check = 0;
  sendInval(Addr,8'h20, 0,0,1);
  clock(10);
  sendInval(Addr,8'h20, 0,0,1);
  clock(10);
  sendInval(Addr,8'h20, 0,0,1);
  clock(10);
  sendInval(Addr,8'h20, 0,0,1);
  clock(10);
  sendRead(Addr, 8'h20, 0, 1); 
  clock(10);
  sendRead(Addr, 8'h20, 0, 1); 
  clock(10000);
  //t2_mem_data[144-1:0] = testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[IndexAddr];
    `TB_YAP($psprintf("t2_mem_data 0x%0x  ", t2_mem_data[144-1:0]))
  t2_mem_data[144-1:0] = t2_mem_data[144-1:0] ^ 1 << errorBitPos;
    `TB_YAP($psprintf("t2_mem_data 0x%0x  ", t2_mem_data[144-1:0]))
  //testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[IndexAddr] = t2_mem_data[144-1:0];
  clock(100);
  t2_mem_error_check = 1;
  sendRead(Addr, 8'h20, 0, 1); 
  clock(1000);
  t2_mem_error_check = 0;
endtask 

task dbgBusTest();
          `TB_YAP($psprintf("dbgBusTest   START "))
      test_dbg_init_all();
      test_dbg_write_all();
      test_dbg_read_all();
      test_dbg_init_all();
          `TB_YAP($psprintf("dbgBusTest   END "))
endtask:dbgBusTest

task test_dbg_init_all();
    integer i,j,k,l;
    MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgWrTr;
    for(i=0; i<NUMDBNK; i = i+1) begin
       for(j=0; j<NUMDROW; j = j+1) begin
           dbgWrTr = new();
           dbgWrTr.addr = j;
           dbgWrTr.baddr = i;
           dbgWrTr.din = 144'h0;
           dbgWrTr.dout  = 'h0;
           dbgWrTr.reqType  = DBG_WRITE;
           dbgMem[i][j] = dbgWrTr.din;
            dbgTr.send(dbgWrTr);
          `INFO($psprintf("DBGMEM_WR_DATA creq %s  ",  dbgWrTr.dbgWriteSprint))
       end  
    end 

    for(i=0; i<NUMDBNK; i = i+1) begin
       for(j=0; j<NUMDROW; j = j+1) begin
           dbgWrTr = new();
               dbgWrTr.addr = j;
               dbgWrTr.baddr = i;
               dbgWrTr.dout = 'h0;
               dbgWrTr.din  = 'h0;
               dbgWrTr.reqType  = DBG_READ;
               dbgTr.send(dbgWrTr);
       end  
     end 

     clock(10000);
          `INFO($psprintf("test_dbg_init_all   END "))
 
endtask:test_dbg_init_all


task test_dbg_write_all();
    integer i,j,k,l;
    MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgWrTr;
    for(i=0; i<NUMDBNK; i = i+1) begin
       for(j=0; j<NUMDROW; j = j+1) begin
           dbgWrTr = new();
           if(i==0) begin
               dbgWrTr.addr = j;
               dbgWrTr.baddr = i;
               dbgWrTr.din = {40'h0,randomMemData(104)} & {104{1'b1}};
               dbgWrTr.dout  = 'h0;
               dbgWrTr.reqType  = DBG_WRITE;
               dbgMem[i][j] = dbgWrTr.din;
           end else begin
               dbgWrTr.addr = j;
               dbgWrTr.baddr = i;
               dbgWrTr.din = randomMemData(144);
               dbgWrTr.dout  = 'h0;
               dbgWrTr.reqType  = DBG_WRITE;
               dbgMem[i][j] = dbgWrTr.din;
            end
            dbgTr.send(dbgWrTr);
          `INFO($psprintf("DBGMEM_WR_DATA creq %s  ",  dbgWrTr.dbgWriteSprint))
       end  
    end  
     clock(10000);
          `INFO($psprintf("test_dbg_write_all   END "))
endtask:test_dbg_write_all

task test_dbg_read_all();
    integer i,j,k,l;
    MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgWrTr;
    for(i=0; i<NUMDBNK; i = i+1) begin
       for(j=0; j<NUMDROW; j = j+1) begin
           dbgWrTr = new();
               dbgWrTr.addr = j;
               dbgWrTr.baddr = i;
               dbgWrTr.dout = 'h0;
               dbgWrTr.din  = 'h0;
               dbgWrTr.reqType  = DBG_READ;
               dbgTr.send(dbgWrTr);
       end  
     end  
     clock(10000);
          `INFO($psprintf("test_dbg_read_all   END "))
endtask:test_dbg_read_all

task stallCheck();
   integer count;
      while(1) begin
        count = 0;
        while(testbench.ip_top.e_uc_stall == 1)  begin
            count = count + 1;
            clock(1);
            if(count > 10000) begin
               `ERROR($psprintf("stallCheck e_uc_stall  is assart more than 10000 clocks stall=%d count =%d",testbench.ip_top.e_uc_stall,count))
            end
        end
            clock(1);
      end
endtask:stallCheck

task cpustallCheck();
   integer count;
      while(1) begin
        count = 0;
        while(testbench.ip_top.s_creq_rdstall_1 == 1)  begin
            count = count + 1;
          //`TB_YAP($psprintf("s_creq_rdstall_1  0x%0x  ", testbench.ip_top.s_creq_rdstall_1 ))
            clock(1);
            if(count > 10000) begin
               `ERROR($psprintf("stallCheck s_creq_rdstall_1  is assart more than 10000 clocks stall=%d count =%d",testbench.ip_top.s_creq_rdstall_1,count))
            end
        end
            clock(1);
      end
endtask:cpustallCheck


task ovrFlowCheck();
      while(1) begin
          if(testbench.ip_top.e_pf_oflw == 1)  begin
            `ERROR($psprintf("e_pf_oflw  0x%0x  ", testbench.ip_top.e_pf_oflw ))
          end
          clock(1);
      end
endtask:ovrFlowCheck

task lruMonitor();

reg [91:0]lruValue;
reg [22:0]way0Lru;
reg [22:0]way1Lru;
reg [22:0]way2Lru;
reg [22:0]way3Lru;
    while(1)begin
       while(testbench.ip_top.core.des.algo.a2_loop.algo.core.t1_writeA == 0) clock(1);
          lruValue[91:0] = testbench.ip_top.core.des.algo.a2_loop.algo.core.t1_dinA;
           way0Lru[22:0] = lruValue[22:0];
           way1Lru[22:0] = lruValue[45:23];
           way2Lru[22:0] = lruValue[68:46];
           way3Lru[22:0] = lruValue[91:69];

           if(way0Lru[22] == 1'b1) begin
             if(way1Lru[22] == 1'b1) begin
               if(way0Lru[20:19] == way1Lru[20:19])begin
                 clock(1);
                 `ERROR($psprintf(" Way0 and Way1 LRU Both Are Same  Way0=0x%0x  Way1=0x%0x ", way0Lru[22:0],way1Lru[22:0]))
             end
             end
             if(way2Lru[22] == 1'b1) begin 
                if (way0Lru[20:19] == way2Lru[20:19])begin
                 clock(1);
                 `ERROR($psprintf(" Way0 and Way2 LRU Both Are Same  Way0=0x%0x  Way2=0x%0x ", way0Lru[22:0],way2Lru[22:0]))
             end
             end
             if(way3Lru[22] == 1'b1) begin 
                if (way0Lru[20:19] == way3Lru[20:19])begin
                 clock(1);
                 `ERROR($psprintf(" Way0 and Way3 LRU Both Are Same  Way0=0x%0x  Way3=0x%0x ", way0Lru[22:0],way3Lru[22:0]))
             end
             end
           end

           if(way1Lru[22] == 1'b1) begin
             if(way0Lru[22] == 1'b1) begin 
		if (way1Lru[20:19] == way0Lru[20:19])begin
                 clock(1);
                 `ERROR($psprintf(" Way1 and Way0 LRU Both Are Same  Way1=0x%0x  Way0=0x%0x ", way1Lru[22:0],way0Lru[22:0]))
             end
             end
             if(way2Lru[22] == 1'b1) begin 
		if (way1Lru[20:19] == way2Lru[20:19])begin
                 clock(1);
                 `ERROR($psprintf(" Way1 and Way2 LRU Both Are Same  Way1=0x%0x  Way2=0x%0x ", way1Lru[22:0],way2Lru[22:0]))
             end
             end
             if(way3Lru[22] == 1'b1) begin 
		if (way1Lru[20:19] == way3Lru[20:19])begin
                 clock(1);
                 `ERROR($psprintf(" Way1 and Way3 LRU Both Are Same  Way1=0x%0x  Way3=0x%0x ", way1Lru[22:0],way3Lru[22:0]))
             end
             end
           end

           if(way2Lru[22] == 1'b1) begin
             if(way0Lru[22] == 1'b1) begin 
		if (way2Lru[20:19] == way0Lru[20:19])begin
                 clock(1);
                 `ERROR($psprintf(" Way2 and Way0 LRU Both Are Same  Way2=0x%0x  Way0=0x%0x ", way2Lru[22:0],way0Lru[22:0]))
             end
             end
             if(way1Lru[22] == 1'b1) begin 
		if (way2Lru[20:19] == way1Lru[20:19])begin
                 clock(1);
                 `ERROR($psprintf(" Way2 and Way1 LRU Both Are Same  Way2=0x%0x  Way1=0x%0x ", way2Lru[22:0],way1Lru[22:0]))
             end
             end
             if(way3Lru[22] == 1'b1) begin 
		if (way2Lru[20:19] == way3Lru[20:19])begin
                 `ERROR($psprintf(" Way2 and Way3 LRU Both Are Same  Way2=0x%0x  Way3=0x%0x ", way2Lru[22:0],way3Lru[22:0]))
             end
             end
           end

           if(way3Lru[22] == 1'b1) begin
             if(way0Lru[22] == 1'b1) begin 
		if (way3Lru[20:19] == way0Lru[20:19])begin
                 clock(1);
                 `ERROR($psprintf(" Way3 and Way0 LRU Both Are Same  Way3=0x%0x  Way0=0x%0x ", way3Lru[22:0],way0Lru[22:0]))
             end
             end
             if(way1Lru[22] == 1'b1) begin 
		if (way3Lru[20:19] == way1Lru[20:19])begin
                 clock(1);
                 `ERROR($psprintf(" Way3 and Way1 LRU Both Are Same  Way3=0x%0x  Way1=0x%0x ", way3Lru[22:0],way1Lru[22:0]))
             end
             end
             if(way2Lru[22] == 1'b1) begin 
		if (way3Lru[20:19] == way2Lru[20:19])begin
                 clock(1);
                 `ERROR($psprintf(" Way3 and Way2 LRU Both Are Same  Way3=0x%0x  Way2=0x%0x ", way3Lru[22:0],way2Lru[22:0]))
             end
             end
           end

           clock(1);

    end
endtask:lruMonitor
task dbgMemCheck();
   integer i,j,k,l;
   MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgRdTr;
   while(1) begin
       dbgRdTr = new();
       dbgTr.readDataReceive(dbgRdTr);
          `TB_YAP($psprintf("DBGMEM_RD_DATA creq %s  ",  dbgRdTr.dbgReadSprint))
       if(dbgRdTr.dout == dbgMem[dbgRdTr.baddr][dbgRdTr.addr]) begin
          `DEBUG($psprintf("DBGMEM PASS creq %s  ",  dbgRdTr.dbgReadSprint))
       end else begin
          `DEBUG($psprintf("DBGMEM FAIL MEM_DATA creq 0x%0x  ",  dbgMem[dbgRdTr.baddr][dbgRdTr.addr]))
          `ERROR($psprintf("DBGMEM FAIL          creq %s  ",  dbgRdTr.dbgReadSprint))
       end

   end
endtask:dbgMemCheck


task resetCache();
   reg [BYTEADDBITS-1:0]byteAddr;
   reg [NXSIZEWIDTH-1:0]byteSize;
   reg [TAGADDRBITS-1:0]tagAddr;
   reg [ROWADDRBITS-1:0]rowAddr;
   reg [NXADDRWIDTH-1:0] cacheAddr;
   reg [NXDATAWIDTH-1:0] wrData;
   integer i,j;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   begin
          `INFO($psprintf("resetCache   START"))
      for(j=0;j<NUMWAYS;j = j+1) begin
         for(i=0;i<NUMROWS;i=i+1)  begin
           tagAddr[TAGADDRBITS-1:0] = j;
           rowAddr[ROWADDRBITS-1:0] = i;
           byteAddr[BYTEADDBITS-1:0] = 5'h0;
           cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
           wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
           cpuReqT = new();
           cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
           cpuReqT.cattr = 3'h3;
           cpuReqT.size = 8'h20;
           cpuReqT.reqType = CH_READ;
           mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("invalidWaybyIndexTest READ_REQ %s  ",  cpuReqT.creqSprint))
        end
      end
         clock(1000);
         isEmpty();
          memArray.delete;
          `INFO($psprintf("resetCache   reset"))
          reReset();
      for(j=0;j<NUMWAYS;j = j+1) begin
         for(i=0;i<NUMROWS;i=i+1)  begin
           tagAddr[TAGADDRBITS-1:0] = j;
           rowAddr[ROWADDRBITS-1:0] = i;
           byteAddr[BYTEADDBITS-1:0] = 5'h0;
           cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
           wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
           cpuReqT = new();
           cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
           cpuReqT.cattr = 3'h3;
           cpuReqT.size = 8'h20;
           cpuReqT.reqType = CH_READ;
           mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("invalidWaybyIndexTest READ_REQ %s  ",  cpuReqT.creqSprint))
        end
      end
         clock(1000);
         isEmpty();
  end
endtask


task reReset();
    misc_ifc.rst <= 1'b1;
    `TB_YAP("reset asserted")
    repeat (RESET_CYCLE_COUNT) @ (posedge misc_ifc.clk);
    misc_ifc.rst <= 1'b0;
    `TB_YAP("reset deasserted")
    waitForReady();
endtask:reReset


task testT1MemError();
   integer a,b;
   integer loopCnt = 40;
   reg [BYTEADDBITS-1:0] byteAddr;
   reg [ROWADDRBITS-1:0] rowAddr;
   reg [TAGADDRBITS-1:0] tagAddr;
   reg [NXADDRWIDTH-1:0] Addr;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgWrTr;
   integer errorBitPos;
   t1_mem_error_check = 1;
      slvTr[0].stallEn = 0;
      insertL2Error = 0;
  begin
          reReset();
          memArray.delete;
     `TB_YAP($psprintf("testT1MemError 1  START "))
    while(loopCnt != 0) begin
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);
     t1_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     errorBitPos = $urandom_range(0,103);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     `TB_YAP($psprintf("testT1MemError 1  Addr 0x%x  ",  Addr[NXADDRWIDTH-1:0]))
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     // insert Error Befor Read 
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t1_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t1_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = 2'b01;


     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     `TB_YAP($psprintf("testT1MemError 2  Addr 0x%x  ",  Addr[NXADDRWIDTH-1:0]))
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.t1_readB);
     clock(3);
     errorBitPos = $urandom_range(0,103);
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t1_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t1_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = 2'b01;



     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     `TB_YAP($psprintf("testT1MemError 3  Addr 0x%x  ",  Addr[NXADDRWIDTH-1:0]))
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.t1_readB);
     @(posedge testbench.ip_top.t1_readB);
     errorBitPos = $urandom_range(0,103);
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     `TB_YAP($psprintf("testT1MemError 4  Addr 0x%x  ",  Addr[NXADDRWIDTH-1:0]))
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     t1_mem_error_check = 0;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     errorBitPos = $urandom_range(0,103);
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);
     t1_mem_error_check = 1;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);

     t1_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t1_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = 2'b01;



     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t1_mem_error_check = 0;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     `TB_YAP($psprintf("testT1MemError 5  Addr 0x%x  ",  Addr[NXADDRWIDTH-1:0]))
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     loopCnt = loopCnt -1 ;

    end


  end
endtask:testT1MemError


task testT1MemErrorNoL2Error();
   integer a,b;
   integer loopCnt = 40;
   reg [BYTEADDBITS-1:0] byteAddr;
   reg [ROWADDRBITS-1:0] rowAddr;
   reg [TAGADDRBITS-1:0] tagAddr;
   reg [NXADDRWIDTH-1:0] Addr;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgWrTr;
   integer errorBitPos;
   t1_mem_error_check = 1;
      slvTr[0].stallEn = 1;
      slvTr[0].alwaysEnStall = 1;
      insertL2Error = 0;
  begin
          reReset();
          memArray.delete;
     `TB_YAP($psprintf("testT1MemErrorNoL2Error 1  START "))
    while(loopCnt != 0) begin
     t1_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     errorBitPos = $urandom_range(0,103);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     `TB_YAP($psprintf("testT1MemErrorNoL2Error 1  Addr 0x%x  ",  Addr[NXADDRWIDTH-1:0]))
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     // insert Error Befor Read 
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t1_mem_error_check = 0;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     `TB_YAP($psprintf("testT1MemErrorNoL2Error CASE 1  "))

     t1_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     `TB_YAP($psprintf("testT1MemErrorNoL2Error 2  Addr 0x%x  ",  Addr[NXADDRWIDTH-1:0]))
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.t1_readB);
     clock(2);
     errorBitPos = $urandom_range(0,103);
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t1_mem_error_check = 0;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     `TB_YAP($psprintf("testT1MemErrorNoL2Error CASE 2  "))

     t1_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     `TB_YAP($psprintf("testT1MemErrorNoL2Error 3  Addr 0x%x  ",  Addr[NXADDRWIDTH-1:0]))
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.t1_readB);
     @(posedge testbench.ip_top.t1_readB);
     errorBitPos = $urandom_range(0,103);
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);



     t1_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     `TB_YAP($psprintf("testT1MemErrorNoL2Error CASE 3  "))

     t1_mem_error_check = 0;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     `TB_YAP($psprintf("testT1MemErrorNoL2Error 3  Addr 0x%x  ",  Addr[NXADDRWIDTH-1:0]))
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     t1_mem_error_check = 1;
     errorBitPos = $urandom_range(0,103);
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);



     t1_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     `TB_YAP($psprintf("testT1MemErrorNoL2Error CASE 4  "))



     
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t1_mem_error_check = 0;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     `TB_YAP($psprintf("testT1MemErrorNoL2Error 5  Addr 0x%x  ",  Addr[NXADDRWIDTH-1:0]))
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     `TB_YAP($psprintf("testT1MemErrorNoL2Error CASE 5  "))
     loopCnt = loopCnt -1 ;

    end


  end
endtask:testT1MemErrorNoL2Error


task testT2MemError();
   integer a,b;
   integer loopCnt = 50;
   reg [BYTEADDBITS-1:0] byteAddr;
   reg [ROWADDRBITS-1:0] rowAddr;
   reg [TAGADDRBITS-1:0] tagAddr;
   reg [NXADDRWIDTH-1:0] Addr;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgWrTr;
   integer errorBitPos;
   t2_mem_error_check = 1;
      slvTr[0].stallEn = 0;
      insertL2Error = 0;
  begin
          reReset();
          memArray.delete;
     `TB_YAP($psprintf("testT1MemError 1  START "))
    while(loopCnt != 0) begin


     //1
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     errorBitPos = $urandom_range(0,143);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     // insert Error Befor Read 
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = 2'b01;

//2
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.t2_readB);
     clock(3);
     errorBitPos = $urandom_range(0,143);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = 2'b01;

//3
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.t2_readB);
     @(posedge testbench.ip_top.t2_readB);
     errorBitPos = $urandom_range(0,143);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = 2'b01;

//4
     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     t2_mem_error_check = 1;
     errorBitPos = $urandom_range(0,143);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = 2'b01; 

//5
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     errorBitPos = $urandom_range(0,143);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     // insert Error Befor Read 
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.t2_readB);
     @(posedge testbench.ip_top.t2_readB);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);



     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     errorBitPos = $urandom_range(0,103);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     // insert Error Befor Read 
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.t2_readB);
     @(posedge testbench.ip_top.t2_readB);
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);



     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = 2'b01;

//6
     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     loopCnt = loopCnt -1 ;

   end


  end
endtask:testT2MemError


task testT2MemErrorNoL2Error();
   integer a,b;
   integer loopCnt = 50;
   reg [BYTEADDBITS-1:0] byteAddr;
   reg [ROWADDRBITS-1:0] rowAddr;
   reg [TAGADDRBITS-1:0] tagAddr;
   reg [NXADDRWIDTH-1:0] Addr;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgWrTr;
   integer errorBitPos;
   t2_mem_error_check = 1;
      slvTr[0].stallEn = 1;
      slvTr[0].alwaysEnStall = 1;
      insertL2Error = 0;
  begin
          reReset();
          memArray.delete;
     `TB_YAP($psprintf("testT2MemErrorNoL2Error 1  START "))
    while(loopCnt != 0) begin


     //1
     t2_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     errorBitPos = $urandom_range(0,143);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     // insert Error Befor Read 
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     `TB_YAP($psprintf("testT2MemErrorNoL2Error CASE 1 "))
//2
     t2_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.t2_readB);
     //clock(3);
     errorBitPos = $urandom_range(0,143);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t2_mem_error_check = 0;
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     `TB_YAP($psprintf("testT2MemErrorNoL2Error CASE 2 "))
//3
     t2_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.t2_readB);
     @(posedge testbench.ip_top.t2_readB);
     errorBitPos = $urandom_range(0,143);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     `TB_YAP($psprintf("testT2MemErrorNoL2Error CASE 3 "))

//4
     t2_mem_error_check = 0;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     t2_mem_error_check = 1;
     errorBitPos = $urandom_range(0,143);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t2_mem_error_check = 0;
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     `TB_YAP($psprintf("testT2MemErrorNoL2Error CASE 4 "))


//6
     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     `TB_YAP($psprintf("testT2MemErrorNoL2Error CASE 5 "))

     loopCnt = loopCnt -1 ;

   end


  end
endtask:testT2MemErrorNoL2Error

task errorOnT1Mem(input reg [ROWADDRBITS-1:0]IndexAdd,input integer errorBitPos);
  reg [104-1:0]t1_mem_data;
  //t1_mem_data[104-1:0] = testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.bank_v0_h0.MEMCORE[IndexAdd];
  `TB_YAP($psprintf("t1_mem_data  0x%0x ",t1_mem_data[104-1:0]))
  t1_mem_data[104-1:0] = t1_mem_data[104-1:0] ^ 1 << errorBitPos;
  `TB_YAP($psprintf("t1_mem_data  0x%0x ",t1_mem_data[104-1:0]))
  //testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.bank_v0_h0.MEMCORE[IndexAdd] = t1_mem_data[104-1:0];
  clock(100);
endtask:errorOnT1Mem

task errorOnT2Mem(input reg [ROWADDRBITS-1:0]IndexAdd,input integer errorBitPos);
  reg [144-1:0]t2_mem_data;
  reg [6:0]memAddr;

  memAddr = IndexAdd[ROWADDRBITS-1:0] ;
  //t2_mem_data[144-1:0] = testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr];
  `TB_YAP($psprintf("t2_mem_data  0x%0x ",t2_mem_data[144-1:0]))
  t2_mem_data[144-1:0] = t2_mem_data[144-1:0] ^ 1 << errorBitPos;
  `TB_YAP($psprintf("t2_mem_data  0x%0x ",t2_mem_data[144-1:0]))
  //testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr] = t2_mem_data[144-1:0];
  clock(100);
endtask:errorOnT2Mem


task clearMem(integer rowAddr);
     MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgWrTr;
     integer a;
     for(a=0; a<=8; a= a+1) begin
       dbgWrTr = new();
       dbgWrTr.addr = rowAddr;
       dbgWrTr.baddr = a;
       dbgWrTr.din = 144'h0;
       dbgWrTr.dout  = 'h0;
       dbgWrTr.reqType  = DBG_WRITE;
       dbgTr.send(dbgWrTr);
       clock(100);
     end
endtask:clearMem


endclass:MeCacheTestBench
`endif

