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

        MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) invalMonT;


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
	reg [NXDATAWIDTH-1 :0] InvalArray[*];
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
       mailbox l2IAWQueue;
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
     reg [NXADDRWIDTH-1:0] statsCacheAddArray[NUMWAYS][NUMROWS];

     bit outOfOrderRspEn;
     bit randomStallEn;
     bit invalFlushByIndexTest;
     bit singleByteReq;

    bit outOfOrderDis;
    bit insertL2Error;

   bit t1_mem_error_check;
       bit t2_mem_error_check;

   bit forceAckForallReq;
   bit blockInvalReq;

  function new (string name);
    begin
     super.new(name);
     //duvChecker = new(name);
     this.name = name;
        `DEBUG($psprintf("Function New   "))


      outOfOrderRspEn = 1;
      outOfOrderDis = 0;
      randomStallEn = 1;
      insertL2Error = 0;
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
      l2IAWQueue = new();
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
        invalFlushByIndexTest = 0;
        singleByteReq = 0;
        forceAckForallReq = 0;
        blockInvalReq = 0;
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
      outOfOrderDis = 0;
      insertL2Error = 0;


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
   if(mstTr[0].totalTransactions[63:0]%10000 == 500) begin
             //`TB_YAP($psprintf(" CACHE_TB_INFO  ================================================="))
             `TB_YAP($psprintf(" CACHE_TB_INFO  TOTAL TR                                %d ",mstTr[0].totalTransactions[63:0]))
             //`TB_YAP($psprintf(" CACHE_TB_INFO  transactionID     			%d ",mstTr[0].transactionId[63:0]))
             //`TB_YAP($psprintf(" CACHE_TB_INFO  SIM TIME     				%t ",$time))
             //`TB_YAP($psprintf(" CACHE_TB_INFO  ================================================="))
   clock(100);
   end
   if(mstTr[0].totalTransactions[63:0]%10000 < 5000) begin
      outOfOrderDis = 0;
   end else begin
      outOfOrderDis = 1;
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
         //cpuRreqMon();  //FIXME to speed up sim
         //l2CreqMon();
         //l2DreqMon();
         //l2RreqMon();
       
          cpuReqTrMon();
          //l2ReqTrMon(); 
          //l2ReadTrMoniter();  //FIXME
          //cpuReadTrMoniter(); // Comment to speed up sim

          writeCheckTask();
          readCheckTask();
          //updateInvalMem();
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


task sendReq(input reg [NXADDRWIDTH-1:0]reqAddr,input reg [NXTYPEWIDTH-1:0]reqType,input reg [NXSIZEWIDTH-1:0]reqSize, input reg [NXATTRWIDTH-1:0]reqattr);
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   reg [NXADDRWIDTH-1:0] cacheAddr;
   reg [NXDATAWIDTH-1:0] wrData;

     begin
    if(reqattr[1] == CH_REQ_NOCACHE) begin
      cacheAddr[NXADDRWIDTH-1:0] = reqAddr[NXADDRWIDTH-1:0];
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      wrData[75:64] = {1'b0,reqattr[NXATTRWIDTH-1:0],reqSize[NXSIZEWIDTH-1:0]};
      nonCacheArray[cacheAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
    end else begin
      cacheAddr[NXADDRWIDTH-1:0] = {reqAddr[NXADDRWIDTH-1:5],5'h0};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
     //if(!(memArray.exists(cacheAddr[NXADDRWIDTH-1:0]))) begin
     //    memArray[cacheAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
     //end
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





task dataCacheBasicRDWRFlushInvalTest(input reg [6:0] rowIndex,input reg stallDis,input reg outoffOrderRspDisable );
   reg [4:0]byteAddr;
   reg [7:0]byteSize;
   reg [14:0]tagAddr;
   reg [3:0]tagRandomAddr;
   reg [6:0]rowAddr;
   reg [NXADDRWIDTH-1:0] cacheAddr;
   reg [NXDATAWIDTH-1:0] wrData;
   integer i;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   begin
   if(outoffOrderRspDisable == 1) begin
      outOfOrderRspEn = 0;
      `TB_YAP($psprintf("OutOfOrder RSp Disable %d ",  outOfOrderRspEn ))
   end else if(outoffOrderRspDisable == 0) begin
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
      tagAddr[14:0] = 0;
      rowAddr[6:0] = rowIndex[6:0];
      byteAddr[4:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[14:0],tagRandomAddr[3:0],rowAddr[6:0],byteAddr[4:0]};
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
      `DEBUG($psprintf("dataCacheBasicRDWRFlushInvalTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
    clock(1000);
    isEmpty();

   for(i=0;i<10;i=i+1)  begin
      tagRandomAddr[3:0] = i;
      tagAddr[14:0] = 0;
      rowAddr[6:0] = rowIndex[6:0];
      byteAddr[4:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[14:0],tagRandomAddr[3:0],rowAddr[6:0],byteAddr[4:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
     //if(!(memArray.exists(cacheAddr[NXADDRWIDTH-1:0]))) begin
     //    memArray[cacheAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
     //end
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h3;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_WRITE;
      wrData[NXDATAWIDTH-1:0] = randomWrData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      cpuReqT.data = wrData[NXDATAWIDTH-1:0];
      cpuReqT.dattr = 3'h1;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("dataCacheBasicRDWRFlushInvalTest WRITE_REQ %s  ",  cpuReqT.creqSprint))
   end

    clock(1000);
    isEmpty();


  for(i=0;i<10;i=i+1)  begin
      tagRandomAddr[3:0] = i;
      tagAddr[14:0] = 0;
      rowAddr[6:0] = rowIndex[6:0];
      byteAddr[4:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[14:0],tagRandomAddr[3:0],rowAddr[6:0],byteAddr[4:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
     //if(!(memArray.exists(cacheAddr[NXADDRWIDTH-1:0]))) begin
     //    memArray[cacheAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
     //end
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h3;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_FLUSH;
      cpuReqT.data = 0;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("dataCacheBasicRDWRFlushInvalTest FLUSH_REQ %s  ",  cpuReqT.creqSprint))
   end

    clock(1000);
    isEmpty();

  for(i=0;i<10;i=i+1)  begin
      tagRandomAddr[3:0] = i;
      tagAddr[14:0] = 0;
      rowAddr[6:0] = rowIndex[6:0];
      byteAddr[4:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[14:0],tagRandomAddr[3:0],rowAddr[6:0],byteAddr[4:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
     //if(!(memArray.exists(cacheAddr[NXADDRWIDTH-1:0]))) begin
     //    memArray[cacheAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
     //end
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h3;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_INVAL;
      cpuReqT.data = 0;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("dataCacheBasicRDWRFlushInvalTest FLUSH_REQ %s  ",  cpuReqT.creqSprint))
   end

    clock(1000);
    isEmpty();


   end
endtask:dataCacheBasicRDWRFlushInvalTest



task dataCacheCapacityTest(input reg [6:0] rowIndex,input reg stallDis,input reg outoffOrderRspDisable );
   reg [BYTEADDBITS-1:0]byteAddr;
   reg [NXSIZEWIDTH-1:0]byteSize;
   reg [TAGADDRBITS-1:0]tagAddr;
   reg [ROWADDRBITS-1:0]rowAddr;
   reg [NXADDRWIDTH-1:0] cacheAddr;
   reg [NXDATAWIDTH-1:0] wrData;
   integer i,j;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   begin
      	`TB_YAP("dataCacheCapacityTest START" )
       nonCacheArray.delete;
       //memArray.delete;
   if(outoffOrderRspDisable == 1) begin
      outOfOrderRspEn = 0;
      `TB_YAP($psprintf("OutOfOrder RSp Disable %d ",  outOfOrderRspEn ))
   end else if(outoffOrderRspDisable == 0) begin
      outOfOrderRspEn = 1;
      `TB_YAP($psprintf("OutOfOrder RSp Disable %d ",  outOfOrderRspEn ))
   end
   if(stallDis == 1) begin
      slvTr[0].stallEn = 0;
      `TB_YAP($psprintf("Stall Disable %d ",  slvTr[0].stallEn ))
   end else if(stallDis == 0) begin
      slvTr[0].stallEn =1;
      `TB_YAP($psprintf("Stall Disable %d ",  slvTr[0].stallEn ))
   end

      `TB_YAP($psprintf("ADDR_BITS TAGADDRBITS %d, ROWADDRBITS %d, BYTEADDBITS %d ", TAGADDRBITS,ROWADDRBITS,BYTEADDBITS ))
    clock(1000);
    reReset();
    cpuReqQueue = new();
    memArray.delete;

   for(i=0;i<TAGADDRBITS;i=i+1)  begin
      tagAddr[TAGADDRBITS-1:0] = 1 << i;
      rowAddr[ROWADDRBITS-1:0] = rowIndex[ROWADDRBITS-1:0];
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {2'h1,tagAddr[TAGADDRBITS-1-2:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      wrData[75:64] = {4'h1,8'h20};
      if(!(nonCacheArray.exists(cacheAddr[NXADDRWIDTH-1:0]))) begin
          nonCacheArray[cacheAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
      end
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h1;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_READ;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("dataCacheCapacityTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
    clock(1000);
    isEmpty();

   for(i=TAGADDRBITS-1;i>=0;i--)  begin
      tagAddr[TAGADDRBITS-1:0] = 1 << i;
      rowAddr[ROWADDRBITS-1:0] = rowIndex[ROWADDRBITS-1:0];
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {2'h1,tagAddr[TAGADDRBITS-1-2:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      wrData[75:64] = {4'h1,8'h20};
      if(!(nonCacheArray.exists(cacheAddr[NXADDRWIDTH-1:0]))) begin
          nonCacheArray[cacheAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
      end
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h1;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_READ;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("dataCacheCapacityTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
    clock(1000);
    isEmpty();

  for(i=0;i<TAGADDRBITS;i=i+1)  begin
      tagAddr[TAGADDRBITS-1:0] = 1 << i;
      rowAddr[ROWADDRBITS-1:0] = rowIndex[ROWADDRBITS-1:0];
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {2'h2,tagAddr[TAGADDRBITS-1-2:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      wrData[75:64] = {4'h1,8'h20};
      if(!(nonCacheArray.exists(cacheAddr[NXADDRWIDTH-1:0]))) begin
          nonCacheArray[cacheAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
      end
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h1;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_WRITE;
      cpuReqT.data = nonCacheArray[cacheAddr[NXADDRWIDTH-1:0]];
      cpuReqT.dattr = 'h1;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("dataCacheCapacityTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
    clock(1000);
    isEmpty();



   for(i=TAGADDRBITS-1;i>=0;i--)  begin
      tagAddr[TAGADDRBITS-1:0] = 1 << i;
      rowAddr[ROWADDRBITS-1:0] = rowIndex[ROWADDRBITS-1:0];
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {2'h2,tagAddr[TAGADDRBITS-1-2:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      wrData[75:64] = {4'h1,8'h20};
      if(!(nonCacheArray.exists(cacheAddr[NXADDRWIDTH-1:0]))) begin
          nonCacheArray[cacheAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
      end
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h1;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_WRITE;
      cpuReqT.data = nonCacheArray[cacheAddr[NXADDRWIDTH-1:0]];
      cpuReqT.dattr = 'h1;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("dataCacheCapacityTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
    clock(1000);
    isEmpty();



   for(i=0;i<TAGADDRBITS-2;i=i+1)  begin
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
      `DEBUG($psprintf("dataCacheCapacityTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
    clock(1000);
    isEmpty();

   for(i=TAGADDRBITS-1-2;i>=0;i--)  begin
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
      `DEBUG($psprintf("dataCacheCapacityTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
    clock(1000);
    isEmpty();

   for(i=0;i<TAGADDRBITS-2;i=i+1)  begin
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
      cpuReqT.reqType = CH_WRITE;
      wrData[NXDATAWIDTH-1:0] = randomWrData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      cpuReqT.data = wrData[NXDATAWIDTH-1:0];
      cpuReqT.dattr = 3'h1;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("dataCacheCapacityTest WRITE_REQ %s  ",  cpuReqT.creqSprint))
   end

    clock(1000);
    isEmpty();

   for(i=TAGADDRBITS-1-2;i>=0;i--)  begin
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
      cpuReqT.reqType = CH_WRITE;
      wrData[NXDATAWIDTH-1:0] = randomWrData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      cpuReqT.data = wrData[NXDATAWIDTH-1:0];
      cpuReqT.dattr = 3'h1;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("dataCacheCapacityTest WRITE_REQ %s  ",  cpuReqT.creqSprint))
   end

    clock(1000);
    isEmpty();



  for(i=0;i<TAGADDRBITS-2;i=i+1)  begin
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
      cpuReqT.reqType = CH_FLUSH;
      cpuReqT.data = 0;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("dataCacheCapacityTest FLUSH_REQ %s  ",  cpuReqT.creqSprint))
   end

    clock(1000);
    isEmpty();

  for(i=0;i<TAGADDRBITS-2;i=i+1)  begin
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
      cpuReqT.reqType = CH_INVAL;
      cpuReqT.data = 0;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("dataCacheCapacityTest FLUSH_REQ %s  ",  cpuReqT.creqSprint))
   end

    clock(1000);
    isEmpty();
    cpuReqQueue = new();
    reReset();
    memArray.delete;

for(j=0; j<NUMWAYS; j = j+1) begin
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
      cpuReqT.reqType = CH_WRITE;
      wrData[NXDATAWIDTH-1:0] = randomWrData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      cpuReqT.data = wrData[NXDATAWIDTH-1:0];
      cpuReqT.dattr = 3'h1;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("dataCacheCapacityTest WRITE_REQ %s  ",  cpuReqT.creqSprint))
   end
end

for(j=0; j<NUMWAYS; j = j+1) begin
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
      `DEBUG($psprintf("dataCacheCapacityTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
   end
    clock(1000);
    isEmpty();

   for(j=0; j<NUMWAYS; j = j+1) begin
    for(i=0;i<NUMROWS;i=i+1)  begin
      tagAddr[TAGADDRBITS-1:0] = j;
      rowAddr[ROWADDRBITS-1:0] = i;
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h3;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_INVAL;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("dataCacheCapacityTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
   end
    clock(1000);
    isEmpty();

    memArray.delete;
    cpuReqQueue = new();

   for(j=0; j<NUMWAYS; j = j+1) begin
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
      `DEBUG($psprintf("dataCacheCapacityTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
   end
    clock(1000);
    isEmpty();

    for(j=0; j<NUMWAYS; j = j+1) begin
    for(i=0;i<NUMROWS;i=i+1)  begin
      tagAddr[TAGADDRBITS-1:0] = j;
      rowAddr[ROWADDRBITS-1:0] = i;
      byteAddr[BYTEADDBITS-1:0] = 5'h0;
      cacheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
      cpuReqT = new();
      cpuReqT.addr = cacheAddr[NXADDRWIDTH-1:0];
      cpuReqT.cattr = 3'h3;
      cpuReqT.size = 8'h20;
      cpuReqT.reqType = CH_INVAL;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("dataCacheCapacityTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
   end
    clock(1000);
    isEmpty();

    memArray.delete;
    cpuReqQueue = new();

for(j=0; j<NUMWAYS; j = j+1) begin
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
      cpuReqT.reqType = CH_WRITE;
      wrData[NXDATAWIDTH-1:0] = randomWrData(NXDATAWIDTH,cacheAddr[NXADDRWIDTH-1:0]);
      cpuReqT.data = wrData[NXDATAWIDTH-1:0];
      cpuReqT.dattr = 3'h1;
      mstTr[0].send(cpuReqT);
      `DEBUG($psprintf("dataCacheCapacityTest WRITE_REQ %s  ",  cpuReqT.creqSprint))
   end
end

for(j=0; j<NUMWAYS; j = j+1) begin
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
      `DEBUG($psprintf("dataCacheCapacityTest READ_REQ %s  ",  cpuReqT.creqSprint))
   end
   end
    clock(1000);
    isEmpty();


      	`TB_YAP("dataCacheCapacityTest END" )
   end
endtask:dataCacheCapacityTest

task sendRandomDcacheReq(input integer count,input reg stallDis,input reg outoffOrderRspDisable,input reg rowSelectRandomEn,input reg randomL2ErrorEn);
  reg [ROWADDRBITS-1:0]rowAddr;
  reg [ROWADDRBITS-1:0]rowAddrArry[5];
  reg [BYTEADDBITS-1:0]byteAddr;
  reg [NXSIZEWIDTH-1:0]byteSize;
  reg [TAGADDRBITS-1:0] tagAddr;
  reg [3:0]tagRandomAddr;
  reg [NXADDRWIDTH-1:0]reqAddr;
  reg [NXADDRWIDTH-1:0]memAddr;
  reg [NXDATAWIDTH-1:0]wrData;
  reg [1:0]reqType;
  reg [31:0]loopCount = count;
  reg [31:0]loopCount_1 = 1;
  bit byteSizeDone =0;
  bit nonCacheAddr;
  bit ackEn = 0;
  integer i,j;
  reg [2:0]cattr;
  bit enableL2Error;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
  begin
       nonCacheArray.delete;
       //memArray.delete;  FIXME
       if(outoffOrderRspDisable == 1) begin
      	 outOfOrderRspEn = 0;
      	`TB_YAP($psprintf("OutOfOrder RSp Disable %d ",  outOfOrderRspEn ))
       end else if(outoffOrderRspDisable == 0) begin
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
       rowAddrArry[0] = (rowSelectRandomEn == 0) ? rowAddrArry[1] :rowAddrArry[1] - 1;
       rowAddrArry[2] = (rowSelectRandomEn == 0) ? rowAddrArry[1] :rowAddrArry[1] + 1;
       rowAddrArry[3] = (rowSelectRandomEn == 0) ? rowAddrArry[1] :0;
       rowAddrArry[4] = (rowSelectRandomEn == 0) ? rowAddrArry[1] :127;
       for(i=0; i<5; i = i+1) begin
             `TB_YAP($psprintf("TestbenchReq rowAddrArry[%d] = %d  ", i,rowAddrArry[i]))
       end
       while(loopCount[31:0] !=0) begin
          cpuReqT = new();
          tagRandomAddr[3:0] = $urandom_range(1,7);
          byteAddr[BYTEADDBITS-1:0] = $urandom_range(0,'h1f);
          tagAddr[TAGADDRBITS-1:0] = 'h0;
          nonCacheAddr = 0;
          if((loopCount_1%1000) <= 250)  begin
             nonCacheAddr = $urandom_range(0,1);
             nonCacheAddr = 0;
             //`DEBUG($psprintf("TestbenchReq CACHE_NONCACHE loopCount_1 %d nonCacheAddr %d ", loopCount_1,nonCacheAddr ))
          end
          nonCacheAddr = 0;
          byteSizeDone = 0;
          loopCount_1[31:0] = loopCount_1[31:0] + 1;
          while(byteSizeDone == 0)  begin
             byteSize[NXSIZEWIDTH-1:0] = $urandom_range(1,'h20);
             if((byteAddr[BYTEADDBITS-1:0] + byteSize[NXSIZEWIDTH-1:0]) <= 'h20) begin
                 byteSizeDone = 1; end
          end
          rowAddr[6:0] = rowAddrArry[$urandom_range(0,4)];
          wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,reqAddr[NXADDRWIDTH-1:0]);
          if(nonCacheAddr == 1) begin
              tagAddr[TAGADDRBITS-1:0] = $urandom_range(0,32768);
              reqType[1:0] = $urandom_range(CH_WRITE,CH_READ);
              ackEn = (forceAckForallReq == 1'b1) ?  CH_REQ_ACK: $urandom_range(CH_REQ_NOACK,CH_REQ_ACK);
              if(reqType[1:0] == 0) begin
          	reqAddr[NXADDRWIDTH-1:0] = {2'h1,tagAddr[TAGADDRBITS-1-2:4],tagRandomAddr[3:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
                wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,reqAddr[NXADDRWIDTH-1:0]);
                wrData[75:64] = {3'b0,ackEn,byteSize[NXSIZEWIDTH-1:0]};
              end else if(reqType[1:0] == 1)begin
          	reqAddr[NXADDRWIDTH-1:0] = {2'h2,tagAddr[TAGADDRBITS-1-2:4],tagRandomAddr[3:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
                wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,reqAddr[NXADDRWIDTH-1:0]);
                wrData[75:64] = {4'h1,byteSize[NXSIZEWIDTH-1:0]};
              end
              enableL2Error = 0;
              if(insertL2Error == 1) begin
                  enableL2Error = (($urandom%100) < 50);
                  {l2RrspDataErr,l2RrspAddErr} = 2'b00;
                  if(enableL2Error == 1'b1) begin
                     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);
                     `DEBUG($psprintf("NonCacheBle Read  L2_ERROR Inserted raatr %x  reqType %d  addr 0x%x ", {l2RrspDataErr,l2RrspAddErr},reqType[1:0],reqAddr[NXADDRWIDTH-1:0]))
                  end 
              end
              wrData[NXDATAWIDTH-1:NXDATAWIDTH-2] = {l2RrspDataErr,l2RrspAddErr};
              if(!(nonCacheArray.exists(reqAddr[NXADDRWIDTH-1:0]))) begin
                  nonCacheArray[reqAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
              end
          end else begin
                reqType[1:0] = (blockInvalReq == 1) ? $urandom_range(CH_WRITE,CH_FLUSH) : $urandom_range(CH_WRITE,CH_INVAL);//FIXME
          	reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:4],tagRandomAddr[3:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
          	//reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:3],tagRandomAddr[2:0],rowAddr[ROWADDRBITS-1:0],5'h0};
                //byteSize[NXSIZEWIDTH-1:0] = 'h20;  //FIXME
                 if(byteSize[NXSIZEWIDTH-1:0] <=2) begin
                     byteSize[NXSIZEWIDTH-1:0] = 3;
                     if(byteAddr[BYTEADDBITS-1:0] > 5'h1d) begin
                        byteAddr[BYTEADDBITS-1:0] = 5'h1d;
          	         reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:4],tagRandomAddr[3:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
                         //`DEBUG($psprintf("TestbenchReq Update Single Beet Addr  0x%x size %0d ", reqAddr[NXADDRWIDTH-1:0],byteSize[NXSIZEWIDTH-1:0] ))
                       end

                 end
         end

          if(reqType[1:0] == CH_WRITE) begin  // Write req
           ackEn = (forceAckForallReq == 1'b1) ?  CH_REQ_ACK : $urandom_range(CH_REQ_NOACK,CH_REQ_ACK);
           cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
           cpuReqT.cattr = (nonCacheAddr == 1) ?  nonCacheArray[reqAddr[NXADDRWIDTH-1:0]][74:72]: {2'h1,ackEn};
           cpuReqT.size = (nonCacheAddr == 1) ?  nonCacheArray[reqAddr[NXADDRWIDTH-1:0]][71:64] : byteSize[NXSIZEWIDTH-1:0];
           cpuReqT.reqType = CH_WRITE;
           wrData[NXDATAWIDTH-1:0] = (cpuReqT.size == 1)  ? randomWrXorData(NXDATAWIDTH,reqAddr[NXADDRWIDTH-1:0]) : randomWrData(NXDATAWIDTH,reqAddr[NXADDRWIDTH-1:0]);
           cpuReqT.data = (nonCacheAddr == 1) ?  nonCacheArray[reqAddr[NXADDRWIDTH-1:0]] : wrData[NXDATAWIDTH-1:0];
           cpuReqT.dattr = 3'h1;
          end else if (reqType[1:0] == CH_READ)  begin
           cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
           cpuReqT.cattr = (nonCacheAddr == 1) ? nonCacheArray[reqAddr[NXADDRWIDTH-1:0]][74:72]: 3'h3;
           cpuReqT.size = (nonCacheAddr == 1) ?  nonCacheArray[reqAddr[NXADDRWIDTH-1:0]][71:64] : byteSize[NXSIZEWIDTH-1:0];
           cpuReqT.reqType = CH_READ;
          end else if (reqType[1:0] == CH_FLUSH)  begin
           ackEn = (forceAckForallReq == 1'b1) ?  CH_REQ_ACK: CH_REQ_NOACK;
           cpuReqT.addr = {reqAddr[NXADDRWIDTH-1:5],5'h0};
           cpuReqT.cattr = {2'h1,ackEn};
           cpuReqT.size = 8'h20;
           cpuReqT.reqType = CH_FLUSH;
          end else if (reqType[1:0] == CH_INVAL)  begin
           ackEn = (forceAckForallReq == 1'b1) ?  CH_REQ_ACK: CH_REQ_NOACK;
           cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
           cpuReqT.addr = {reqAddr[NXADDRWIDTH-1:5],5'h0};
           cpuReqT.cattr = {2'h1,ackEn};
           cpuReqT.size = 8'h20;
           cpuReqT.reqType = CH_INVAL;
          end
          mstTr[0].send(cpuReqT);
           //`DEBUG($psprintf("TestbenchReq REQ  %s  ", cpuReqT.creqSprint))
          loopCount[31:0] = loopCount[31:0] - 1; 
          if((loopCount[31:0]%100) == 1) begin
            //WFIRTask(rowAddr[ROWADDRBITS-1:0]);
          end
          if((loopCount[31:0]%1000) == 1) begin
            //RARReq();
            //WARReq();
            //WAWReq();
            //RAWReq();
          end
       end

    clock(1000);
    isEmpty();
           `DEBUG($psprintf("TESTBENCH  Number of Data TR in Cache Befor Flush %d ",  cacheArray.num()))
           `DEBUG($psprintf("TESTBENCH  Number of dirty TR in Cache Befor Flush %d ",  dirtyArray.num()))
      /* begin
          for(i=1; i<=15; i = i+1)  begin
            for(j=0; j<=4; j = j+1)  begin
             rowAddr[ROWADDRBITS-1:0] = rowAddrArry[j];
             cpuReqT = new();
             reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:4],i[3:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
             reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:4],i[3:0],rowAddr[ROWADDRBITS-1:0],5'h0};
             cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
             cpuReqT.cattr = 3'h3;
             cpuReqT.size = 'h20;
             cpuReqT.reqType = CH_FLUSH;
             mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s FLUSH CMD ",  cpuReqT.creqSprint))
           end
         end
       end
    clock(1000);
           `DEBUG($psprintf("TESTBENCH  Number of Data TR in Cache After Flush %d ",  cacheArray.num()))
           `DEBUG($psprintf("TESTBENCH  Number of dirty TR in Cache After Flush %d ",  dirtyArray.num()))

       begin
          for(i=1; i<=15; i = i+1)  begin
             for(j=0; j<=4; j = j+1)  begin
             rowAddr[ROWADDRBITS-1:0] = rowAddrArry[j];
             cpuReqT = new();
             reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:4],i[3:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
             reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:4],i[3:0],rowAddr[ROWADDRBITS-1:0],5'h0};
             cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
             cpuReqT.cattr = 3'h3;
             cpuReqT.size = 'h20;
             cpuReqT.reqType = CH_INVAL;
             mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s INVAL CMD ",  cpuReqT.creqSprint))
           end
         end
       end*/
    clock(1000);
           `DEBUG($psprintf("TESTBENCH  Number of Data TR in Cache After Inval %d ",  cacheArray.num()))
           `DEBUG($psprintf("TESTBENCH  Number of dirty TR in Cache After Inval %d ",  dirtyArray.num()))
    isEmpty();
    clock(1000);
    flushCpuReqQueue();
    isEmpty();
    for(i=1; i<=15; i = i+1)  begin
             for(j=0; j<=4; j = j+1)  begin
             rowAddr[ROWADDRBITS-1:0] = rowAddrArry[j];
             cpuReqT = new();
             reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:4],i[3:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
             reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:4],i[3:0],rowAddr[ROWADDRBITS-1:0],5'h0};
             cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
             cpuReqT.cattr = 3'h3;
             cpuReqT.size = 'h20;
             cpuReqT.reqType = CH_INVAL;
             mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s INVAL CMD ",  cpuReqT.creqSprint))
           end
         end
    isEmpty();
    clock(1000);

  end
endtask :sendRandomDcacheReq


task  WFIRTask(input reg [ROWADDRBITS-1:0] rowAddr);
    reg [3:0]tagRandomAddr;
    reg [NXADDRWIDTH-1:0]reqAddr;
    reg [TAGADDRBITS-1:0]tagAddr = 0;
    integer i;
    MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) wfirReqT;
    tagRandomAddr[3:0] = $urandom_range(8,15);
    reqAddr[NXADDRWIDTH-1:0] =  {tagAddr[TAGADDRBITS-1:4],tagRandomAddr[3:0],rowAddr[ROWADDRBITS-1:0],5'h0};
    //`DEBUG($psprintf("TestbenchReq WFIRTask rowAddr 0xd  tagRandomAddr[3:0] %d  ", rowAddr[ROWADDRBITS-1:0],tagRandomAddr[3:0]))
    for(i=0; i<5; i = i+1) begin
        wfirReqT = new();
        wfirReqT.addr = reqAddr[NXADDRWIDTH-1:0];
        wfirReqT.cattr = 3'h3;
        wfirReqT.size = 'h20;
        if(i == 0) begin
          wfirReqT.reqType = CH_READ;
        end else if(i == 1) begin
          wfirReqT.reqType = CH_WRITE;
          wfirReqT.data = randomWrData(NXDATAWIDTH,reqAddr[NXADDRWIDTH-1:0]);
          wfirReqT.dattr = 3'h1;
        end else if(i == 2) begin
          wfirReqT.reqType = CH_FLUSH;
          wfirReqT.cattr = 3'h2;
        end else if(i == 3) begin
          wfirReqT.reqType = CH_INVAL;
          wfirReqT.cattr = 3'h2;
        end else if(i == 4) begin
          wfirReqT.reqType = CH_READ;
        end
        mstTr[0].send(wfirReqT);
           //`DEBUG($psprintf("TestbenchReq WFIRTask REQ  %s  ", wfirReqT.creqSprint))
    end
endtask:WFIRTask


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
     for(z=0;z<10;z = z+1) begin
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
        wfirReqT.reqType = CH_FLUSH;
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


task WAWReq();
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
     for(z=0;z<10;z = z+1) begin
         rowAddr[ROWADDRBITS-1:0] =101;
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
        wfirReqT.reqType = CH_WRITE;
        wfirReqT.data = randomWrData(NXDATAWIDTH,reqAddr[NXADDRWIDTH-1:0]);
        wfirReqT.dattr = 3'h1;
        mstTr[0].send(wfirReqT);
        wfirReqT = new();
        wfirReqT.addr = reqAddr[NXADDRWIDTH-1:0];
        wfirReqT.cattr = 3'h3;
        wfirReqT.size = 'h20;
        wfirReqT.reqType = CH_WRITE;
        wfirReqT.data = randomWrData(NXDATAWIDTH,reqAddr[NXADDRWIDTH-1:0]);
        wfirReqT.dattr = 3'h1;
        mstTr[0].send(wfirReqT);
        wfirReqT = new();
        wfirReqT.addr = reqAddr[NXADDRWIDTH-1:0];
        wfirReqT.cattr = 3'h2;
        wfirReqT.size = 'h20;
        wfirReqT.reqType = CH_FLUSH;
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
        wfirReqT.reqType = CH_WRITE;
        wfirReqT.data = randomWrData(NXDATAWIDTH,reqAddr[NXADDRWIDTH-1:0]);
        wfirReqT.dattr = 3'h1;
        mstTr[0].send(wfirReqT);
        wfirReqT = new();
        wfirReqT.addr = reqAddr[NXADDRWIDTH-1:0];
        wfirReqT.cattr = 3'h2;
        wfirReqT.size = 'h20;
        wfirReqT.reqType = CH_INVAL;
        mstTr[0].send(wfirReqT);
      end
    end
endtask:WAWReq

task RAWReq();
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
     for(z=0;z<10;z = z+1) begin
         rowAddr[ROWADDRBITS-1:0] =102;
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
        wfirReqT.reqType = CH_WRITE;
        wfirReqT.data = randomWrData(NXDATAWIDTH,reqAddr[NXADDRWIDTH-1:0]);
        wfirReqT.dattr = 3'h1;
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
        wfirReqT.reqType = CH_FLUSH;
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
        wfirReqT.reqType = CH_WRITE;
        wfirReqT.data = randomWrData(NXDATAWIDTH,reqAddr[NXADDRWIDTH-1:0]);
        wfirReqT.dattr = 3'h1;
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
endtask:RAWReq

task WARReq();
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
     for(z=0;z<10;z = z+1) begin
         rowAddr[ROWADDRBITS-1:0] =103;
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
        wfirReqT.reqType = CH_WRITE;
        wfirReqT.data = randomWrData(NXDATAWIDTH,reqAddr[NXADDRWIDTH-1:0]);
        wfirReqT.dattr = 3'h1;
        mstTr[0].send(wfirReqT);
        wfirReqT = new();
        wfirReqT.addr = reqAddr[NXADDRWIDTH-1:0];
        wfirReqT.cattr = 3'h2;
        wfirReqT.size = 'h20;
        wfirReqT.reqType = CH_FLUSH;
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
        wfirReqT.cattr = 3'h3;
        wfirReqT.size = 'h20;
        wfirReqT.reqType = CH_WRITE;
        wfirReqT.data = randomWrData(NXDATAWIDTH,reqAddr[NXADDRWIDTH-1:0]);
        wfirReqT.dattr = 3'h1;
        mstTr[0].send(wfirReqT);
        wfirReqT = new();
        wfirReqT.addr = reqAddr[NXADDRWIDTH-1:0];
        wfirReqT.cattr = 3'h2;
        wfirReqT.size = 'h20;
        wfirReqT.reqType = CH_INVAL;
        mstTr[0].send(wfirReqT);
      end
    end
endtask:WARReq

task sendRandomIcacheReq(input integer count);
  reg [6:0]rowAddr;
  reg [4:0]byteAddr;
  reg [7:0]byteSize;
  reg [18:0] tagAddr;
  reg [2:0]tagRandomAddr;
  reg [NXADDRWIDTH-1:0]reqAddr;
  reg [NXADDRWIDTH-1:0]memAddr;
  reg [NXDATAWIDTH-1:0]wrData;
  reg [1:0]reqType;
  reg [31:0]loopCount = count;
  reg [31:0]loopCount_1 = 1;
  bit byteSizeDone =0;
  bit nonCacheAddr;
  integer i;
  reg [2:0]cattr;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
  begin
       rowAddr[6:0] = $urandom_range(1,4);
       rowAddr[6:0] = 4;
       while(loopCount[31:0] !=0) begin
          cpuReqT = new();
          tagRandomAddr[2:0] = $urandom_range(1,7);
          byteAddr[4:0] = $urandom_range(0,'h1f);
          tagAddr[18:0] = 19'h0;
          byteSizeDone = 0;
          while(byteSizeDone == 0)  begin
             byteSize[7:0] = $urandom_range('h1,'h20);
             if((byteAddr[4:0] + byteSize[7:0]) <= 'h20);
                 byteSizeDone = 1;
           //`DEBUG($psprintf("TestbenchReq byteAddr  %x  byteSize %x  ",  byteAddr[4:0],byteSize[7:0]))
          end

          	reqAddr[NXADDRWIDTH-1:0] = {tagAddr[18:3],tagRandomAddr[2:0],rowAddr[6:0],byteAddr[4:0]};
          	reqAddr[NXADDRWIDTH-1:0] = {tagAddr[18:3],tagRandomAddr[2:0],rowAddr[6:0],5'h0};
          	byteSize[7:0] ='h20;
               // `DEBUG($psprintf("TestbenchReq byteAddr  %x  reqAddr %x  ",  byteAddr[4:0],reqAddr[NXADDRWIDTH-1:0]))
               // `DEBUG($psprintf("TestbenchReq tagAddr  %x  reqAddr %x  ",  tagAddr[18:3],reqAddr[NXADDRWIDTH-1:0]))
               // `DEBUG($psprintf("TestbenchReq tagRandomAddr  %x  reqAddr %x  ",  tagRandomAddr[2:0],reqAddr[NXADDRWIDTH-1:0]))
               // `DEBUG($psprintf("TestbenchReq rowAddr  %x  reqAddr %x  ",  rowAddr[6:0],reqAddr[NXADDRWIDTH-1:0]))
                 wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,reqAddr[NXADDRWIDTH-1:0]);
                 memAddr[NXADDRWIDTH-1:0] = {tagAddr[18:3],tagRandomAddr[2:0],rowAddr[6:0],5'h0};
                //if(!(memArray.exists(memAddr[NXADDRWIDTH-1:0]))) begin
                //    memArray[memAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
                //end

          loopCount_1[31:0] = loopCount_1[31:0] + 1;
          
           cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
           cpuReqT.cattr = 3'h3;
           cpuReqT.size = byteSize[7:0];
           cpuReqT.reqType = CH_READ;
           //`DEBUG($psprintf("TestbenchReq READ_REQ %s  ",  cpuReqT.creqSprint))
           mstTr[0].send(cpuReqT);
          loopCount[31:0] = loopCount[31:0] - 1;  
          // `DEBUG($psprintf("TestbenchReq Send_REQ %s  loopCount %d ",  cpuReqT.creqSprint,loopCount))
       end

    clock(1000);
    isEmpty();

  end
endtask :sendRandomIcacheReq




task monCpuWrRsp();
     begin
       integer queueSize,j;
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuWrErrRspTr;
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
         //monCpuWrRspQueue.put(cpuWrRspT);

           if(cpuWrRspT.cattr[1] == CH_REQ_NOCACHE)  begin
               if(cpuWrRspT.rattr[NXATTRWIDTH-1:1] != nonCacheArray[cpuWrRspT.addr][NXDATAWIDTH-1:NXDATAWIDTH-2]) begin
                  `ERROR($psprintf("monCpuWrRsp raat is not Match exp %x , rReq %x  ",nonCacheArray[cpuWrRspT.addr][NXDATAWIDTH-1:NXDATAWIDTH-2],cpuWrRspT.rattr))
               end
               queueSize = cpuReqQueue.num();
               for(j=0;j<queueSize; j = j+1) begin
                   cpuReqQueue.get(cpuWrErrRspTr);
                   if((cpuWrRspT.addr  == cpuWrErrRspTr.addr ) && (cpuWrErrRspTr.reqType == CH_WRITE) 
                       && (cpuWrRspT.transactionTime == cpuWrErrRspTr.transactionTime) && (cpuWrRspT.cId  == cpuWrErrRspTr.cId ))  begin
                       `DEBUG($psprintf(" monCpuWrRsp Removeing Wr Error Rsp from CpuQueue %s  ", cpuWrErrRspTr.creqSprint))
                   end else begin
                      cpuReqQueue.put(cpuWrErrRspTr);
                   end
               end

           end


           if((cpuWrRspT.cattr[1] == CH_REQ_CACHE) && (cpuWrRspT.rattr[2:1] != 2'b00))  begin
              `DEBUG($psprintf(" monCpuWrRsp Recived Cache Wr Rsp with Error Rsp %s  ", cpuWrRspT.creqSprint))
              queueSize = cpuReqQueue.num();
              for(j=0;j<queueSize; j = j+1) begin
                 cpuReqQueue.get(cpuWrErrRspTr);
                 if(((cpuWrRspT.addr >> 5) == (cpuWrErrRspTr.addr >> 5)) && (cpuWrErrRspTr.reqType == CH_WRITE) && (cpuWrRspT.transactionTime == cpuWrErrRspTr.transactionTime))  begin
                     `DEBUG($psprintf(" monCpuWrRsp Removeing Wr Error Rsp from CpuQueue %s  ", cpuWrErrRspTr.creqSprint))
                     `DEBUG($psprintf(" monCpuWrRsp Removeing Wr Error Rsp from CpuQueue %s  ", cpuWrRspT.creqSprint))
                     `DEBUG($psprintf(" monCpuWrRsp Removeing Wr Error Rsp from CpuQueue %s  ", cpuWrRspT.rreqSprint))
                 end else begin
                    cpuReqQueue.put(cpuWrErrRspTr);
                 end
              end
           end
           
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
    reg [NXDATAWIDTH-1:0]nonCacheData;
    bit pushFBSel;
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
               l2WrMonT.rattr = 'h1;
             end else begin
               l2RspCacheWrNOACKTr[63:0] = l2RspCacheWrNOACKTr[63:0] + 1;
             end
             l2RspCacheWrTr[63:0] = l2RspCacheWrTr[63:0] + 1;
         
         end else begin
             nonCacheData[NXDATAWIDTH-1:0] = nonCacheArray[l2WrMonT.addr];
             if(l2WrMonT.cattr[0] == CH_REQ_ACK) begin
               l2RspNonCacheWrACKTr[63:0] = l2RspNonCacheWrACKTr[63:0] + 1;
               l2WrMonT.rattr = {nonCacheData[NXDATAWIDTH-1:NXDATAWIDTH-2],1'b1};
             end else begin
               l2RspNonCacheWrNOACKTr[63:0] = l2RspNonCacheWrNOACKTr[63:0] + 1;
             end
             l2RspNonCycheWrTr[63:0] = l2RspNonCycheWrTr[63:0] + 1;
         end
         l2WrMonT1 = new l2WrMonT;
         if(l2WrMonT.cattr[0] == 1) begin
           //l2WrMonT.rattr = 'h1;
           l2WrMonT.rId = l2WrMonT.cId;
           l2WrMonT.data = 0;
           `DEBUG($psprintf("monl2WrReq rReq %s  ", l2WrMonT.rreqSprint))
           if(outOfOrderRspEn == 1) begin // code for out of order
             pushFBSel = (outOfOrderDis == 1) ? 0 :$urandom_range(0,1);
             if(pushFBSel == 1) begin
               outOfOrdrQueue.push_front(l2WrMonT);
             end else begin
               outOfOrdrQueue.push_back(l2WrMonT);
             end 
           end else begin
             slvTr[0].send(l2WrMonT);
           end
        end
        `DEBUG($psprintf("monl2WrReq cReq %s  ", l2WrMonT1.creqSprint))
        `DEBUG($psprintf("monl2WrReq dReq %s  ", l2WrMonT1.dreqSprint))
        monL2WrRspQueue.put(l2WrMonT1);
       end
     end
endtask:monl2WrReq

task monl2RdAddReq();
    reg [NXDATAWIDTH-1:0]wrData;
    MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2RsvRdReq;
    bit pushFBSel;
    bit enableL2Error;
    begin
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
           end
        end else if(l2RdAMonT.cattr[1] == CH_REQ_CACHE) begin
           l2RsvRdReq = new l2RdAMonT;
           if(invalFlushByIndexTest == 0) begin
               //removeIAWTask(l2RsvRdReq);
           end
           l2RspCacheRdTr[63:0] = l2RspCacheRdTr[63:0] + 1;
           wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,l2RdAMonT.addr);
           evictMemArray.delete(l2RdAMonT.addr);
           InvalArray.delete(l2RdAMonT.addr);
           memArray.delete(l2RdAMonT.addr);
           enableL2Error = 0;
           {l2RrspDataErr,l2RrspAddErr} = 2'b00;
            if(insertL2Error == 1) begin
              enableL2Error = (($urandom%100) < 25);
              {l2RrspDataErr,l2RrspAddErr} = 2'b00;
              if(enableL2Error == 1'b1) begin
                 {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);
                 //removeWrTrTask(l2RsvRdReq);
              end 
            end
           wrData[NXDATAWIDTH-1:NXDATAWIDTH-2] = {l2RrspDataErr,l2RrspAddErr};
           //l2RdAMonT.data = wrData[NXDATAWIDTH-1:0];
           //wrData[127:0] = ({l2RrspDataErr,l2RrspAddErr} != 2'b00) ? 128'h0 : wrData[127:0];
           memArray[l2RdAMonT.addr] = wrData[NXDATAWIDTH-1:0];
           l2RdAMonT.data = memArray[l2RdAMonT.addr];
           l2RdAMonT.rattr = {l2RdAMonT.data[NXDATAWIDTH-1:NXDATAWIDTH-2],1'b1};
           `DEBUG($psprintf("monl2RdAddReq rsep Req %s  ", l2RdAMonT.rreqSprint))
        end

        if(l2RdAMonT.cattr[1] == CH_REQ_NOCACHE) begin
           if((l2RdAMonT.addr == l2RdAMonT.data[NXADDRWIDTH-1:0]) && (l2RdAMonT.size == l2RdAMonT.data[71:64])&& (l2RdAMonT.cattr == l2RdAMonT.data[74:72])) begin
               `DEBUG($psprintf("monl2RdAddReq NonCacheRd Addr and Size Match with expected cReq %s  ", l2RdAMonT.creqSprint))
           end else begin
               `TB_YAP($psprintf("monl2RdAddReq NonCacheRd Addr and Size Not Match with expected cReq %s  ", l2RdAMonT.creqSprint))
               `ERROR($psprintf("monl2RdAddReq NonCacheRd Data 0x%x  ", l2RdAMonT.data))
          end
           l2RdAMonT.rattr = {l2RdAMonT.data[NXDATAWIDTH-1:NXDATAWIDTH-2],1'b1};
               `DEBUG($psprintf("monl2RdAddReq NonCacheRd Data 0x%x and rattr 0x%x   ", l2RdAMonT.data,l2RdAMonT.rattr))
        end

        l2RdAMonT.rId = l2RdAMonT.cId ;



        if (outOfOrderRspEn == 1) begin // code for out of order
           pushFBSel = (outOfOrderDis == 1) ? 0 :$urandom_range(0,1);
             if(pushFBSel == 1) begin
               outOfOrdrQueue.push_front(l2RdAMonT);
             end else begin
               outOfOrdrQueue.push_back(l2RdAMonT);
             end 
        end else  begin
          slvTr[0].send(l2RdAMonT);
          `DEBUG($psprintf("monl2RdAddReq rReq data %s  ", l2RdAMonT.rreqSprint))
        end

     end
    end
endtask:monl2RdAddReq

task removeIAWTask(MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2RsvRdReq);
   bit readFound;
   bit writeFound;
   bit invalFound;
   bit flushFound;
   bit FAWFound;
   bit InvalTrLocked;
   reg [NXADDRWIDTH-1:0]regAddr;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) invalTr;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) readTr;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) flushTr;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) writeTr;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cacheTr;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) IWTr;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) FinalInvalTr;
   integer queueSize,i,j;
   integer cpuQueSize,iawQueSize;
   bit Done;
   reg [63:0] RTrId = {64{1'b0}};
   reg [63:0] WTrId = {64{1'b0}};
   reg [63:0] ITrId = {64{1'b0}};
   reg [63:0] FTrId = {64{1'b0}};

   reg [63:0] RTrId1= {64{1'b0}};
   reg [63:0] WTrId1= {64{1'b0}};
   reg [63:0] ITrId1= {64{1'b0}};
   reg [63:0] FTrId1= {64{1'b0}};

   reg [63:0] FinalITrId= {64{1'b0}};
   queueSize = l2IAWQueue.num();
   for(i=0; i<queueSize; i = i+1) begin
       l2IAWQueue.get(cacheTr);
   end
   readFound = 0;
   writeFound = 0;
   invalFound = 0;
   flushFound = 0;
   Done = 0;
   FAWFound = 0;
   InvalTrLocked = 0;
   regAddr[NXADDRWIDTH-1:5]= {(l2RsvRdReq.addr >> 5),5'h0};
   queueSize = cpuReqQueue.num();
   for(i=0; i<queueSize; i = i+1) begin
       cpuReqQueue.get(cacheTr);
       if((cacheTr.addr >> 5) == (l2RsvRdReq.addr >> 5)) begin
         `DEBUG($psprintf("removeIAWTask Matching Addr Req In CpuQue creq %s  ", cacheTr.creqSprint))
          if(cacheTr.reqType == CH_WRITE)  begin
              writeFound = 1;
              if(readFound == 0) begin
                writeTr = new cacheTr;
                l2IAWQueue.put(writeTr);
                WTrId[63:0] = writeTr.transactionId;
              end
          end
          if(cacheTr.reqType == CH_READ)  begin
              if(readFound == 0) begin
                readTr = new cacheTr;
                l2IAWQueue.put(readTr);
                RTrId[63:0] = readTr.transactionId;
              end
              readFound = 1;
          end
          if(cacheTr.reqType == CH_INVAL)  begin
              invalFound = 1;
              if(readFound == 0) begin
                invalTr = new cacheTr;
                l2IAWQueue.put(invalTr);
                ITrId[63:0] = invalTr.transactionId;
              end
          end
          if(cacheTr.reqType == CH_FLUSH)  begin
              flushFound = 1;
              if(readFound == 0) begin
                flushTr = new cacheTr;
                l2IAWQueue.put(flushTr);
                FTrId[63:0] = flushTr.transactionId;
              end
          end
       end  // end if address check 
       cpuReqQueue.put(cacheTr);
   end  // end for

         `DEBUG($psprintf("removeIAWTask WTrId[63:0] %0d  Addr 0x%x" ,WTrId[63:0],l2RsvRdReq.addr ))
         `DEBUG($psprintf("removeIAWTask FTrId[63:0] %0d  Addr 0x%x" ,FTrId[63:0],l2RsvRdReq.addr ))
         `DEBUG($psprintf("removeIAWTask ITrId[63:0] %0d  Addr 0x%x" ,ITrId[63:0],l2RsvRdReq.addr ))
         `DEBUG($psprintf("removeIAWTask RTrId[63:0] %0d  Addr 0x%x" ,RTrId[63:0],l2RsvRdReq.addr ))


   iawQueSize = l2IAWQueue.num();
   for(i=0; i<iawQueSize; i = i+1) begin
       l2IAWQueue.get(IWTr);
       `DEBUG($psprintf("removeIAWTask IAW Req in l2IAWQueue Queue D creq %s  ", IWTr.creqSprint))
       l2IAWQueue.put(IWTr);
   end 

   readFound = 0;
   writeFound = 0;
   invalFound = 0;
   flushFound = 0;
   Done = 0;
   FAWFound = 0;
   InvalTrLocked = 0;
   iawQueSize = l2IAWQueue.num();
   for(i=0; i<iawQueSize; i = i+1) begin
       l2IAWQueue.get(IWTr);
       `DEBUG($psprintf("removeIAWTask IAW Req in l2IAWQueue Queue creq %s  ", IWTr.creqSprint))



       if(IWTr.reqType == CH_WRITE) begin
          WTrId1[63:0] = IWTr.transactionId;
          writeFound = 1;
          `DEBUG($psprintf("removeIAWTask Wr Req in l2IAWQueue Queue WTrId1[63:0] %d creq %s  ", WTrId1[63:0],IWTr.creqSprint))
       end
       if(IWTr.reqType == CH_READ) begin
          RTrId1[63:0] = IWTr.transactionId;
          readFound = 1;
          `DEBUG($psprintf("removeIAWTask Rd Req in l2IAWQueue Queue RTrId[63:0] %d creq %s  ", RTrId1[63:0],IWTr.creqSprint))
       end
       if(IWTr.reqType == CH_FLUSH) begin
          FTrId1[63:0] = IWTr.transactionId;
          `DEBUG($psprintf("removeIAWTask Fl Req in l2IAWQueue Queue FTrId[63:0] %d creq %s  ", FTrId1[63:0],IWTr.creqSprint))
           flushFound = 1;
       end
       if(IWTr.reqType == CH_INVAL) begin
          ITrId1[63:0] = IWTr.transactionId;
          FinalInvalTr = new IWTr;
          `DEBUG($psprintf("removeIAWTask In Req in l2IAWQueue Queue ITrId[63:0] %d creq %s  ", ITrId1[63:0],IWTr.creqSprint))
           invalFound = 1;
           WTrId1[63:0] = 0;
           FTrId1[63:0] = 0;
       end

       if((invalFound == 0) && (flushFound == 1) && (writeFound == 1) && (FTrId1[63:0] > WTrId1[63:0]) && (InvalTrLocked == 0)) begin
             FAWFound = 1;
             InvalTrLocked = 1;
             FinalITrId[63:0]= 64'h0;
             `DEBUG($psprintf("removeIAWTask  Invalid not found before FAW. so set value is Zero. FinalITrId[63:0] %d creq %s  ", FinalITrId[63:0],IWTr.creqSprint))
       end

       if((invalFound == 1) && (flushFound == 1) && (writeFound == 1) && (FTrId1[63:0] > WTrId1[63:0]) && (InvalTrLocked == 0)) begin
             FAWFound = 1;
             InvalTrLocked = 1;
             FinalITrId[63:0]= ITrId1[63:0];
             `DEBUG($psprintf("removeIAWTask New Invalid Locked  FinalITrId[63:0] %d creq %s  ", FinalITrId[63:0],FinalInvalTr.creqSprint))
       end
       l2IAWQueue.put(IWTr);
   end
     
       if(InvalTrLocked == 0) begin
             FinalITrId[63:0]= ITrId1[63:0];
             `DEBUG($psprintf("removeIAWTask New Invalid Locked  Set. useing default Inval (before Read) FinalITrId[63:0] %d ", FinalITrId[63:0]))
       end
 
   cpuQueSize = cpuReqQueue.num();
   for(i=0; i<cpuQueSize; i = i+1) begin
       cpuReqQueue.get(cacheTr);
         `DEBUG($psprintf("removeIAWTask IAW Req in cpuReqQueue Queue creq %s  ", cacheTr.creqSprint))
       if(((cacheTr.addr >> 5) == (l2RsvRdReq.addr >> 5)) && (cacheTr.transactionId <= FinalITrId[63:0]))begin
         `DEBUG($psprintf("removeIAWTask removing IAW Req in cpuReqQueue Queue creq %s  ", cacheTr.creqSprint))
       end else begin
           cpuReqQueue.put(cacheTr);
       end
   end



endtask:removeIAWTask

task removeWrTrTask(MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2RsvRdReq);
   integer cpuQueSize;
   integer i;
   bit writeFound,readFound;
   reg [NXADDRWIDTH-1:0] addr;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cacheTr;
   addr[NXADDRWIDTH-1:0]= {(l2RsvRdReq.addr >> 5),5'h0};
   writeFound = 0;
   readFound = 0;
   cpuQueSize = cpuReqQueue.num();
   for(i=0; i<cpuQueSize; i = i+1) begin
       cpuReqQueue.get(cacheTr);
       if(((cacheTr.addr >> 5) == (l2RsvRdReq.addr >> 5)) && (writeFound == 0) && (readFound == 0))  begin
          `DEBUG($psprintf("removeWrTrTask Matching Addr Req In CpuQue creq %s  ", cacheTr.creqSprint))
          if(cacheTr.reqType == CH_WRITE)  begin
              writeFound = 1;
              `DEBUG($psprintf("removeWrTrTask WR_TR from  CpuQue while L2 ERROR RSP creq %s  ", cacheTr.creqSprint))
          end
          if(cacheTr.reqType == CH_READ)  begin
              cpuReqQueue.put(cacheTr);
              readFound = 1;
          end
       end else begin
              cpuReqQueue.put(cacheTr);
       end 
   end
endtask:removeWrTrTask



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

       k = (outOfOrderDis == 1) ? 2 :$urandom_range(MinVal,MaxVal);
       l = 0; 
       while((outOfOrdrQueue.size() < k) && (l < 100)) begin
       `DEBUG($psprintf("sendL2RdRsp k  %d , size %d l %d time %t ",k,outOfOrdrQueue.size(),l,$time))
          clock(1);
          l = l+1;
       end
       n = outOfOrdrQueue.size();
       `DEBUG($psprintf("sendL2RdRsp outOfOrdrQueue Size  %d  ",n))
       for(m=0; m<n; m = m+1) begin
          popFBSel = (outOfOrderDis == 1) ? 1 :$urandom_range(0,1);
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


function [NXDATAWIDTH-1:0] randomData(input integer width,input [NXADDRWIDTH-1:0]addr); 
integer m; 
    randomData = 0; 
    for (m = width/32; m >= 0; m--) 
      randomData = (randomData << 32) + $urandom + 32'h12345678;

      //randomData[127:0] = randomData[127:0] ^ 128'h1234567890abcdef1234567890abcdef;
      //randomData[256:128] = randomData[256:128] ^ 128'h1234567890abcdef1234567890abcdef;

     //randomData[NXDATAWIDTH-1:0] = 'h0;
     randomData[NXADDRWIDTH-1:0] = addr;
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

      //randomWrData[127:0] = randomWrData[127:0] ^ 128'h1234567890abcdef1234567890abcdef;
      //randomWrData[256:128] = randomWrData[256:128] ^ 128'h1234567890abcdef1234567890abcdef;
           //`DEBUG($psprintf(" SREE_SURESH 2 addr 0x%x  0x%x  ", memaddr[NXADDRWIDTH-1:0],randomWrData))
           wrDataMemArray[memaddr[NXADDRWIDTH-1:0]] = randomWrData;
     end

endfunction

function [NXDATAWIDTH-1:0] randomWrXorData(input integer width,input [NXADDRWIDTH-1:0]addr); 
integer m; 
reg[NXADDRWIDTH-1:0]memaddr;
reg[NXDATAWIDTH-1:0]randData;
reg [7:0]inArray[32];

    if(singleByteReq == 0) begin
      randomWrXorData[127:0] =  128'h1234567890abcdef1234567890abcdef;
      randomWrXorData[256:128] =128'h1234567890abcdef1234567890abcdef;
      singleByteReq = 1;
    end else begin
      randomWrXorData[127:0] =  128'hfedcba0987654321fedcba0987654321;
      randomWrXorData[256:128] =128'hfedcba0987654321fedcba0987654321;
      singleByteReq = 0;
    end
    /*randomWrXorData = 0; 
    randData = 0; 
    memaddr[NXADDRWIDTH-1:0] = {addr[NXADDRWIDTH-1:5],5'h0};
    for (m = width/32; m >= 0; m--) 
      randData = (randData << 32) + $urandom + $urandom;
   
    if(!(memArray.exists(memaddr[NXADDRWIDTH-1:0]))) begin
       randomWrXorData[NXDATAWIDTH-1:0] = randData[NXDATAWIDTH-1:0];
           `DEBUG($psprintf(" randomWrXorData 1 addr 0x%x  0x%x  ", memaddr[NXADDRWIDTH-1:0],randomWrXorData))
    end else begin 
       randData[NXDATAWIDTH-1:0] = memArray[memaddr[NXADDRWIDTH-1:0]];
       randomWrXorData[NXDATAWIDTH-1:0] = randData[NXDATAWIDTH-1:0] ^ {NXDATAWIDTH{1'b1}};
           `DEBUG($psprintf(" randomWrXorData 2 addr 0x%x  0x%x  ", memaddr[NXADDRWIDTH-1:0],randomWrXorData))
    end
 
      */
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
                    cpuMonT = new cpuCMonT;
                    cpuReadAddMonT = cpuCMonT;
                    if(cpuMonT.cattr[1] == 1'b1) begin
                       cpuReqQueue.put(cpuMonT);  // FIXME no need to capture Read Rsp to this Queue
                    end
                    if(cpuMonT.cattr[1] == CH_REQ_NOCACHE) begin
                       cpuReqQueue.put(cpuMonT);  // FIXME no need to capture Read Rsp to this Queue
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
                    if(cpuMonT.cattr[1] == CH_REQ_CACHE) begin
                       cpuReqQueue.put(cpuMonT);
                       `DEBUG($psprintf("cpuReqTrMon cpuCMonT Write Cap creq %s  ", cpuMonT.creqSprint))
                       `DEBUG($psprintf("cpuReqTrMon cpuCMonT Write Cap dreq %s  ", cpuMonT.dreqSprint))
                    end
                    if((cpuMonT.cattr[1] == CH_REQ_NOCACHE) && (cpuMonT.cattr[0] == CH_REQ_ACK))begin
                       cpuReqQueue.put(cpuMonT);
                       `DEBUG($psprintf("cpuReqTrMon cpuCMonT NC Write Cap creq %s  ", cpuMonT.creqSprint))
                       `DEBUG($psprintf("cpuReqTrMon cpuCMonT NC Write Cap dreq %s  ", cpuMonT.dreqSprint))
                    end
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

task updateInvalMem;
   reg [NXADDRWIDTH-1:0] addr;
   reg [NXDATAWIDTH-1:0] data;
   begin
     while(1) begin
       mstTr[0].invalQueue.get(invalMonT);
       addr[NXADDRWIDTH-1:0] = invalMonT.addr;
       addr[NXADDRWIDTH-1:0] = {addr[NXADDRWIDTH-1:5],5'h0};
       if(evictMemArray.exists(addr[NXADDRWIDTH-1:0])) begin
         InvalArray[addr] = evictMemArray[addr];
         evictMemArray.delete(addr); 
         `DEBUG($psprintf(" Update Invalid Mem with Evict Mem. Addr 0x%x data 0x%x", addr,data)) 
       end else begin
         `DEBUG($psprintf(" Not Update Invalid Mem with Evict Mem. Addr 0x%x ", addr))
       end 
       if(memArray.exists(addr[NXADDRWIDTH-1:0])) begin
         InvalArray[addr] = memArray[addr];
         memArray.delete(addr); 
         `DEBUG($psprintf(" Update Invalid Mem with L2 Mem. Addr 0x%x data 0x%x", addr,data)) 
       end else begin
         `DEBUG($psprintf(" Not Update Invalid Mem with L2 Mem. Addr 0x%x ", addr))
       end 

     end
   end
endtask:updateInvalMem


task readCheckTask;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuRdDataT;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuWrTr;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuRdTr;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) RAWTr;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) RAITr;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) invalTr;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) flushTr;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) IARTr;
  reg [NXDATAWIDTH-1:0] cpuRdData;
  reg [NXADDRWIDTH-1:0] cpuRdAddr;
  reg [NXDATAWIDTH-1:0] comuteData;
  bit readDataMatchWithMemArry;
  bit readDataMatchWithFill;
  bit readDataMatchWithHit;
  bit readDataMatchWithEvictMem;
  bit readDataMatchWithInvalMem;
  integer fillSize;
  integer hitSize,queueSize;
  bit rawTrFound;
  bit raiTrFound;
  bit invalFound;
  bit invalLocked;
  bit flushLocked;
  bit readLocked;
  bit l2ErrorDetected;
  bit memErrorDetected;
  bit WBRFound;
  bit RBRFound;
  bit WARFound;
  bit RARFound;
  bit IARFound;
  integer j;
   while(1) begin
       monCpuRdRspQueue.get(cpuRdDataT);
       cpuRdAddr[NXADDRWIDTH-1:0] = cpuRdDataT.addr;
       cpuRdAddr[4:0] = 'h0;
       readDataMatchWithMemArry = 0;
       readDataMatchWithFill = 0;
       readDataMatchWithHit = 0;
       readDataMatchWithEvictMem = 0;
       readDataMatchWithInvalMem = 0;
       WBRFound = 0;
       RBRFound = 0;
       WARFound = 0;
       RARFound = 0;
       IARFound = 0;
       if(cpuRdDataT.cattr[1] == CH_REQ_NOCACHE)  begin
         if(cpuRdDataT.rattr[2:1] != 2'b00) begin
              if(cpuRdDataT.rattr[NXATTRWIDTH-1:NXATTRWIDTH-2] == nonCacheArray[cpuRdDataT.addr][NXDATAWIDTH-1 : NXDATAWIDTH-2]) begin
          	  `DEBUG($psprintf(" cpuReadCheck cpu cache raat bits are MATCH with L2 raat %x ", cpuRdDataT.rattr[NXATTRWIDTH-1:0]))
              end else begin
                  `TB_YAP($psprintf(" CPU RD Data 0x%x  ", cpuRdDataT.data))
                  `TB_YAP($psprintf(" CACHE  Data 0x%x  ", nonCacheArray[cpuRdDataT.addr]))
          	  `ERROR($psprintf(" cpuReadCheck cpu cache raat bits are NOT_MATCH with L2 raat. CPU_RATTR %x L2_RAATR %x ", cpuRdDataT.rattr[NXATTRWIDTH-1:0],nonCacheArray[cpuRdDataT.addr][NXDATAWIDTH-1 : NXDATAWIDTH-2]))
              end
         end else if(cpuRdDataT.data  !=  nonCacheArray[cpuRdDataT.addr]) begin
             `TB_YAP($psprintf(" NON CACHE RD DATA is invalid"))
             `TB_YAP($psprintf(" CPU Read  TR cReq %s  ", cpuRdDataT.creqSprint))
             `TB_YAP($psprintf(" CPU RD Data 0x%x  ", cpuRdDataT.data))
             `TB_YAP($psprintf(" CACHE  Data 0x%x  ", nonCacheArray[cpuRdDataT.addr]))
             `ERROR($psprintf(" =======CPU READ MISMACH =============="))
         end else begin
             `DEBUG($psprintf(" NON CACHE RD DATA MATCH"))
             `INFO($psprintf(" CPU_CHECK NON_CACHE_READ_PASS cReq %s  ", cpuRdDataT.creqSprint))
         end

              queueSize = cpuReqQueue.num();
               for(j=0;j<queueSize; j = j+1) begin
                 cpuReqQueue.get(cpuRdTr);
                 if((cpuRdTr.addr  == cpuRdDataT.addr ) && (cpuRdTr.reqType == CH_READ) && (cpuRdTr.transactionTime == cpuRdDataT.transactionTime))  begin
                     `DEBUG($psprintf(" DEBUG_READ Removeing RdTr from CpuQueue %s  ", cpuRdTr.creqSprint))
                 end else begin
                    cpuReqQueue.put(cpuRdTr);
                 end
               end

       end else begin
              `DEBUG($psprintf(" DEBUG_READ Cache Read Creq %s",cpuRdDataT.creqSprint))
              l2ErrorDetected = 0;
              memErrorDetected = 0;
              if((t1_mem_error_check == 1'b1) || (t2_mem_error_check == 1'b1)) begin
                  if(cpuRdDataT.rattr[NXATTRWIDTH-1:0] != 3'h1) begin
          	     `DEBUG($psprintf(" cpuReadCheck Data Error  Set %x  for t1 mem error test ", cpuRdDataT.rattr[NXATTRWIDTH-1:0]))
                      memErrorDetected = 1;
                  end else begin
          	     `ERROR($psprintf(" cpuReadCheck Data Error Not Set %x for t1 mem error test  ", cpuRdDataT.rattr[NXATTRWIDTH-1:0]))
                  end
              end else if(cpuRdDataT.rattr[2:1] != 2'b00) begin
                  if(cpuRdDataT.rattr[NXATTRWIDTH-1:NXATTRWIDTH-2] == memArray[cpuRdAddr[NXADDRWIDTH-1:0]][NXDATAWIDTH-1 : NXDATAWIDTH-2]) begin
          	    `DEBUG($psprintf(" cpuReadCheck cpu cache raat bits are MATCH with L2 raat %x ", cpuRdDataT.rattr[NXATTRWIDTH-1:0]))
                     memArray.delete(cpuRdAddr[NXADDRWIDTH-1:0]);
                     l2ErrorDetected = 1;
                  end else begin
          	  `ERROR($psprintf(" cpuReadCheck cpu cache raat bits are NOT_MATCH with L2 raat. CPU_RATTR %x L2_RAATR %x ", cpuRdDataT.rattr[NXATTRWIDTH-1:0],nonCacheArray[cpuRdAddr[NXADDRWIDTH-1:0]][NXDATAWIDTH-1 : NXDATAWIDTH-2]))
                  end
              end
              queueSize = cpuReqQueue.num();
              for(i=0; i<queueSize; i = i+1) begin
                 cpuReqQueue.get(cpuWrTr);
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (cpuWrTr.transactionTime < cpuRdDataT.transactionTime)) begin
                          WBRFound = 1;
                          `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP WBRFound cReq %s  ", cpuWrTr.creqSprint))
                      end
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_READ) && (cpuWrTr.transactionTime < cpuRdDataT.transactionTime)) begin
                          RBRFound = 1;
                          `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP RBRFound cReq %s  ", cpuWrTr.creqSprint))
                      end
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (IARFound == 0) && (cpuWrTr.transactionTime > cpuRdDataT.transactionTime)) begin
                          WARFound = 1;
                          `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP WARFound cReq %s  ", cpuWrTr.creqSprint))
                      end
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_READ) && (IARFound == 0) && (cpuWrTr.transactionTime > cpuRdDataT.transactionTime)) begin
                          RARFound = 1;
                          `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP RARFound cReq %s  ", cpuWrTr.creqSprint))
                      end
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_INVAL) && (WARFound == 0) && (RARFound == 0)&& (cpuWrTr.transactionTime > cpuRdDataT.transactionTime)) begin
                          IARFound = 1;
                          IARTr = new cpuWrTr;
                          `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP IARFound cReq %s  ", cpuWrTr.creqSprint))
                      end
                 cpuReqQueue.put(cpuWrTr);
              end
              `DEBUG($psprintf(" DEBUG_READ  WBRFound %d RBRFound %d WARFound %d RARFound %d IARFound %d  ",WBRFound,RBRFound,WARFound,RARFound,IARFound ))
              if((memArray.exists(cpuRdAddr[NXADDRWIDTH-1:0])) && ((l2ErrorDetected == 0) || (memErrorDetected == 0))) begin
  	  	   invalFound = 0;
  		   invalLocked = 0;
  		   flushLocked = 0;
  		   readLocked = 0;
                   queueSize = cpuReqQueue.num();
                          `DEBUG($psprintf(" DEBUG_READ cpuReqQueue SIZE  %d  ", cpuReqQueue.num()))
                   for(i=0; i<queueSize; i = i+1) begin
                      cpuReqQueue.get(cpuWrTr);
                      if((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5))  begin
                          `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP PEND_TR_CPU_QUEUE cReq %s  ", cpuWrTr.creqSprint))
                      end
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_READ) && (readLocked == 0) && (cpuWrTr.transactionTime != cpuRdDataT.transactionTime)) begin
                          `ERROR($psprintf(" DEBUG_READ BEFORE_CMP one more Read is Pending Befor curent Read Rsv Read cReq %s  ", cpuWrTr.creqSprint))
                      end
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_READ) && (cpuWrTr.transactionTime == cpuRdDataT.transactionTime)) begin
                          readLocked = 1;
                          `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP READLOCKED cReq %s  ", cpuWrTr.creqSprint))
                      end

                      
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_INVAL) && 
                         (cpuWrTr.transactionTime < cpuRdDataT.transactionTime) && (readLocked == 0)&& (flushLocked == 0)) begin
                          invalTr = new cpuWrTr;
                          invalLocked = 1;
                          `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP INVALLOCKED cReq %s  ", invalTr.creqSprint))
                      end

                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_FLUSH) && 
                         (cpuWrTr.transactionTime < cpuRdDataT.transactionTime) && (readLocked == 0)&& (invalLocked == 0)) begin
                          flushTr = new cpuWrTr;
                          flushLocked = 1;
                          `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP FLUSHLOCKED cReq %s  ", flushTr.creqSprint))
                      end
                      cpuReqQueue.put(cpuWrTr);
                   end
                   /*if((invalLocked == 1) && (readLocked == 1)&& (flushLocked == 0)) begin
                      queueSize = cpuReqQueue.num();
                      for(i=0; i<queueSize; i = i+1) begin
                          cpuReqQueue.get(cpuWrTr);
                           if(((cpuWrTr.addr >> 5) == (invalTr.addr >> 5)) && (cpuWrTr.reqType != CH_READ) && (cpuWrTr.transactionTime <= invalTr.transactionTime)) begin
                                 `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP REMOVE_REQ cReq %s  ", cpuWrTr.creqSprint))
                           end else begin
                                cpuReqQueue.put(cpuWrTr);
                           end
                      end
                   end*/

                          `DEBUG($psprintf(" DEBUG_READ cpuReqQueue SIZE  %d  ", cpuReqQueue.num()))

                   queueSize = cpuReqQueue.num();
                          `DEBUG($psprintf(" DEBUG_READ cpuReqQueue SIZE  %d  ", cpuReqQueue.num()))
                   comuteData[NXDATAWIDTH-1:0] = memArray[cpuRdAddr[NXADDRWIDTH-1:0]];
                   `DEBUG($psprintf(" DEBUG_READ MEMARRYCMP MEM_DATA 0x%x Addr 0x%x ",comuteData[NXDATAWIDTH-1:0] ,cpuRdAddr[NXADDRWIDTH-1:0]))
                   for(i=0; i<queueSize; i = i+1) begin
                      cpuReqQueue.get(cpuWrTr);
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_INVAL) && (cpuWrTr.transactionId < cpuRdDataT.transactionId))  begin
                           comuteData[NXDATAWIDTH-1:0] = memArray[cpuRdAddr[NXADDRWIDTH-1:0]];
                          `DEBUG($psprintf(" DEBUG_READ MEMARRYCMP INVAL Found. Reseting the Comp Data with Mem Data MEM_DATA 0x%x  cReq %s  ",comuteData[NXDATAWIDTH-1:0], cpuWrTr.creqSprint))
                      end  // end for comuteReadHit
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (cpuWrTr.transactionId < cpuRdDataT.transactionId))  begin
                           comuteData[NXDATAWIDTH-1:0] = computeCacheData(comuteData[NXDATAWIDTH-1:0],cpuWrTr);
                          `DEBUG($psprintf(" DEBUG_READ MEMARRYCMP 1 CPU_TR Pend Wr Tr Before Rd Tr cReq %s  ", cpuWrTr.creqSprint))
                      end  // end for comuteReadHit
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (cpuWrTr.transactionId > cpuRdDataT.transactionId))  begin
                          `DEBUG($psprintf(" DEBUG_READ MEMARRYCMP 2 CPU_TR Pend Wr Tr After Rd Tr cReq %s  ", cpuWrTr.creqSprint))
                      end
                      cpuReqQueue.put(cpuWrTr);
                   end
                   if(cpuRdDataT.data  == comuteData[NXDATAWIDTH-1:0]) begin
                      readDataMatchWithMemArry = 1'b1;
                      `DEBUG($psprintf(" DEBUG_READ MEMARRYCMP Read Data Match With MemArray+WrTr 0x%x ",comuteData[NXDATAWIDTH-1:0] ))
                   end
              end

              if(evictMemArray.exists(cpuRdAddr[NXADDRWIDTH-1:0])) begin

  	  	   invalFound = 0;
  		   invalLocked = 0;
  		   readLocked = 0;
                   queueSize = cpuReqQueue.num();
                   `DEBUG($psprintf(" DEBUG_READ cpuReqQueue SIZE  %d  ", cpuReqQueue.num()))
                   for(i=0; i<queueSize; i = i+1) begin
                      cpuReqQueue.get(cpuWrTr);
                      if((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5))  begin
                          `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP_EVICT PEND_TR_CPU_QUEUE cReq %s  ", cpuWrTr.creqSprint))
                      end
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_READ) && (readLocked == 0) &&
                         (cpuWrTr.transactionTime != cpuRdDataT.transactionTime)) begin
                          `ERROR($psprintf(" DEBUG_READ BEFORE_CMP_EVICT one more Read is Pending Befor curent Read Rsv Read cReq %s  ", cpuWrTr.creqSprint))
                      end
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_READ) && (cpuWrTr.transactionTime == cpuRdDataT.transactionTime)) begin
                          readLocked = 1;
                          `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP_EVICT READLOCKED cReq %s  ", cpuWrTr.creqSprint))
                      end
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_FLUSH) && 
                         (cpuWrTr.transactionTime < cpuRdDataT.transactionTime) && (readLocked == 0)&& (invalLocked == 0)) begin
                          flushTr = new cpuWrTr;
                          flushLocked = 1;
                          `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP_EVICT FLUSHLOCKED cReq %s  ", flushTr.creqSprint))
                      end
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_INVAL) && 
                         (cpuWrTr.transactionTime < cpuRdDataT.transactionTime) && (readLocked == 0)&& (flushLocked == 0)) begin
                          invalTr = new cpuWrTr;
                          invalLocked = 1;
                          `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP_EVICT INVALLOCKED cReq %s  ", invalTr.creqSprint))
                      end
                      cpuReqQueue.put(cpuWrTr);
                   end
                   /*if((invalLocked == 1) && (readLocked == 1)&& (flushLocked == 0)) begin
                      queueSize = cpuReqQueue.num();
                      for(i=0; i<queueSize; i = i+1) begin
                          cpuReqQueue.get(cpuWrTr);
                           if(((cpuWrTr.addr >> 5) == (invalTr.addr >> 5)) && (cpuWrTr.reqType != CH_READ) && (cpuWrTr.transactionTime <= invalTr.transactionTime)) begin
                                 `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP_EVICT REMOVE_REQ cReq %s  ", cpuWrTr.creqSprint))
                           end else begin
                                cpuReqQueue.put(cpuWrTr);
                           end
                      end
                   end*/
                   `DEBUG($psprintf(" DEBUG_READ cpuReqQueue SIZE  %d  ", cpuReqQueue.num()))

                   queueSize = cpuReqQueue.num();
                   comuteData[NXDATAWIDTH-1:0] = evictMemArray[cpuRdAddr[NXADDRWIDTH-1:0]];
                   `DEBUG($psprintf(" DEBUG_READ EVICTARRYCMP MEM_DATA 0x%x Addr 0x%x ",comuteData[NXDATAWIDTH-1:0] ,cpuRdAddr[NXADDRWIDTH-1:0]))
                   for(i=0; i<queueSize; i = i+1) begin
                      cpuReqQueue.get(cpuWrTr);
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_INVAL) && (cpuWrTr.transactionId < cpuRdDataT.transactionId))  begin
                           comuteData[NXDATAWIDTH-1:0] = evictMemArray[cpuRdAddr[NXADDRWIDTH-1:0]];
                          `DEBUG($psprintf(" DEBUG_READ EVICTARRYCMP INVAL Found. Reseting the Comp Data with Evic Data EVIC_DATA 0x%x  cReq %s  ",comuteData[NXDATAWIDTH-1:0], cpuWrTr.creqSprint))
                      end  // end for comuteReadHit
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (cpuWrTr.transactionId < cpuRdDataT.transactionId))  begin
                           comuteData[NXDATAWIDTH-1:0] = computeCacheData(comuteData[NXDATAWIDTH-1:0],cpuWrTr);
                          `DEBUG($psprintf(" DEBUG_READ EVICTARRYCMP 1 CPU_TR Pend Wr Tr Before Rd Tr cReq %s  ", cpuWrTr.creqSprint))
                      end  // end for comuteReadHit
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (cpuWrTr.transactionId > cpuRdDataT.transactionId))  begin
                          `DEBUG($psprintf(" DEBUG_READ EVICTARRYCMP 2 CPU_TR Pend Wr Tr After Rd Tr cReq %s  ", cpuWrTr.creqSprint))
                      end
                      cpuReqQueue.put(cpuWrTr);
                   end
                   if(cpuRdDataT.data  == comuteData[NXDATAWIDTH-1:0]) begin
                      readDataMatchWithEvictMem = 1'b1;
                   end
              end


              if(InvalArray.exists(cpuRdAddr[NXADDRWIDTH-1:0])) begin
                   queueSize = cpuReqQueue.num();
                   comuteData[NXDATAWIDTH-1:0] = InvalArray[cpuRdAddr[NXADDRWIDTH-1:0]];
                   `DEBUG($psprintf(" DEBUG_READ INVALARRYCMP MEM_DATA 0x%x Addr 0x%x ",comuteData[NXDATAWIDTH-1:0] ,cpuRdAddr[NXADDRWIDTH-1:0]))
                   for(i=0; i<queueSize; i = i+1) begin
                      cpuReqQueue.get(cpuWrTr);
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (cpuWrTr.transactionId < cpuRdDataT.transactionId))  begin
                           comuteData[NXDATAWIDTH-1:0] = computeCacheData(comuteData[NXDATAWIDTH-1:0],cpuWrTr);
                          `DEBUG($psprintf(" DEBUG_READ INVALARRYCMP 1 CPU_TR Pend Wr Tr Before Rd Tr cReq %s  ", cpuWrTr.creqSprint))
                      end  // end for comuteReadHit
                      if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (cpuWrTr.transactionId > cpuRdDataT.transactionId))  begin
                          `DEBUG($psprintf(" DEBUG_READ INVALARRYCMP 2 CPU_TR Pend Wr Tr After Rd Tr cReq %s  ", cpuWrTr.creqSprint))
                      end
                      cpuReqQueue.put(cpuWrTr);
                   end
                   if(cpuRdDataT.data  == comuteData[NXDATAWIDTH-1:0]) begin
                      readDataMatchWithInvalMem = 1'b1;
                   end
              end

                
               queueSize = cpuReqQueue.num();
               for(j=0;j<queueSize; j = j+1) begin
                 cpuReqQueue.get(cpuRdTr);
                 if(((cpuRdTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuRdTr.reqType == CH_READ) && (cpuRdTr.transactionTime == cpuRdDataT.transactionTime))  begin
                     `DEBUG($psprintf(" DEBUG_READ Removeing RdTr from CpuQueue %s  ", cpuRdTr.creqSprint))
                 end else begin
                    cpuReqQueue.put(cpuRdTr);
                 end
               end


              /* if((IARFound == 1'b1) && (WBRFound == 1'b0) && (RBRFound == 1'b0) && (WARFound == 1'b0) && (RARFound == 1'b0)) begin
                   evictMemArray.delete(cpuRdAddr[NXADDRWIDTH-1:0]);
                   memArray.delete(cpuRdAddr[NXADDRWIDTH-1:0]);
                   InvalArray.delete(cpuRdAddr[NXADDRWIDTH-1:0]);
                   `TB_YAP($psprintf(" DEBUG_READ. RM_MEM After Read Inval found. Removeing all Mem's. Read req %s  ", cpuRdTr.creqSprint))
               end*/

               if((IARFound == 1'b1) && (WBRFound == 1'b0) && (RBRFound == 1'b0) && (WARFound == 1'b0) && (RARFound == 1'b0) && (l2ErrorDetected == 0) && (memErrorDetected == 0)) begin
                   if(memArray.exists(cpuRdAddr[NXADDRWIDTH-1:0]) || evictMemArray.exists(cpuRdAddr[NXADDRWIDTH-1:0]) || InvalArray.exists(cpuRdAddr[NXADDRWIDTH-1:0]))  begin
                      evictMemArray.delete(cpuRdAddr[NXADDRWIDTH-1:0]);
                      memArray.delete(cpuRdAddr[NXADDRWIDTH-1:0]);
                      InvalArray.delete(cpuRdAddr[NXADDRWIDTH-1:0]);
                      `DEBUG($psprintf(" DEBUG_READ. RM_MEM IARFound  time %t   ", IARTr.transactionTime))
                      `DEBUG($psprintf(" DEBUG_READ. RM_MEM After Read Inval found. Removeing all Mem's. time %t Read req %s  ", $time,cpuRdTr.creqSprint))
                      if(memArray.exists(cpuRdAddr[NXADDRWIDTH-1:0]) || evictMemArray.exists(cpuRdAddr[NXADDRWIDTH-1:0]) || InvalArray.exists(cpuRdAddr[NXADDRWIDTH-1:0]))  begin
                        `ERROR($psprintf(" DEBUG_READ. RM_MEM  MEM not delete. Addr 0x%x",cpuRdAddr[NXADDRWIDTH-1:0] ))
                      end
                   end else begin
                        `ERROR($psprintf(" DEBUG_READ. RM_MEM  MEM not FOUND. Addr 0x%x",cpuRdAddr[NXADDRWIDTH-1:0] ))
                   end
               end

               if(readDataMatchWithMemArry == 1'b1)
                   `INFO($psprintf(" CPU_CHECK CACHE_READ_PASS  Data Match With L2 Mem %s  ", cpuRdDataT.creqSprint))
               if(readDataMatchWithEvictMem == 1'b1)
                   `INFO($psprintf(" CPU_CHECK CACHE_READ_PASS  Data Match With Evict Mem %s  ", cpuRdDataT.creqSprint))
               if(readDataMatchWithInvalMem == 1'b1)
                   `INFO($psprintf(" CPU_CHECK CACHE_READ_PASS  Data Match With  Inval mem %s  ", cpuRdDataT.creqSprint))
               if(l2ErrorDetected == 1'b1)
                   `INFO($psprintf(" CPU_CHECK CACHE_READ_PASS  L2 Error Detaected %s  ", cpuRdDataT.creqSprint))
               if(memErrorDetected == 1'b1)
                   `INFO($psprintf(" CPU_CHECK CACHE_READ_PASS  L2 Error Detaected %s  ", cpuRdDataT.creqSprint))
               if(readDataMatchWithMemArry || readDataMatchWithEvictMem || readDataMatchWithInvalMem || l2ErrorDetected || memErrorDetected)  begin
                     `INFO($psprintf(" CPU_CHECK CACHE_READ_PASS ceq %s",cpuRdDataT.creqSprint))
               end else begin
                     `TB_YAP($psprintf(" DEBUG_FILL_FAIL 2"))
                     `TB_YAP($psprintf(" CACHE Read data is not Valid. Read Data is not Mach with Cache  Data"))
                     `TB_YAP($psprintf(" CPU Read  TR cReq %s  ", cpuRdDataT.creqSprint))
                     `TB_YAP($psprintf(" CPU RD Data 0x%x  ", cpuRdDataT.data))
                     `ERROR($psprintf(" =======CPU READ MISMACH =============="))
               end
       
/*
*/
       end
   end  // end while
endtask

task writeCheckTask;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuWrTr;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2WrTr;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuEvictWrTr;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuWrRdTr;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) evictTr;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) IAWTr;
  integer hitSize,i,queueSize;
  bit EvictDataMatch;
  bit EvictDataMatchWithFlush;
  bit EvictDataMatchWithInval;
  bit RemoveFlushInvalFromQueue;
  bit EvictDataMatchWithFlushRemoveWrTr;
  mailbox evictCheckQueue;
  reg[NXDATAWIDTH-1:0]comuteData;
  bit lockSet;
  bit WBWFound;
  bit RBWFound;
  bit WAWFound;
  bit RAWFound;
  bit IAWFound;
  bit invalFoundAfterWr;
  while(1) begin
     monL2WrRspQueue.get(l2WrTr);
     EvictDataMatch = 0;
     EvictDataMatchWithFlush  =0;
     EvictDataMatchWithInval  =0;
     RemoveFlushInvalFromQueue  =0;
     EvictDataMatchWithFlushRemoveWrTr  =0;
     WBWFound  =0;
     RBWFound  =0;
     WAWFound  =0;
     RAWFound  =0;
     IAWFound  =0;
     invalFoundAfterWr = 0;
     if(l2WrTr.cattr[1] == CH_REQ_NOCACHE) begin
          if(l2WrTr.rattr[2:1] != 2'b00) begin
              if(l2WrTr.rattr[NXATTRWIDTH-1:NXATTRWIDTH-2] == nonCacheArray[l2WrTr.addr][NXDATAWIDTH-1 : NXDATAWIDTH-2]) begin
          	  `DEBUG($psprintf(" cpuReadCheck cpu cache raat bits are MATCH with L2 raat %x ", l2WrTr.rattr[NXATTRWIDTH-1:0]))
              end else begin
          	  `ERROR($psprintf(" cpuReadCheck cpu cache raat bits are NOT_MATCH with L2 raat. CPU_RATTR %x L2_RAATR %x ", l2WrTr.rattr[NXATTRWIDTH-1:0],nonCacheArray[l2WrTr.addr][NXDATAWIDTH-1 : NXDATAWIDTH-2]))
              end
          end else if(l2WrTr.data  !=  nonCacheArray[l2WrTr.addr]) begin
             `TB_YAP($psprintf(" NON CACHE WR DATA is invalid"))
             `TB_YAP($psprintf(" L2 Write  TR cReq %s  ", l2WrTr.creqSprint))
             `TB_YAP($psprintf(" L2 Write  TR dReq %s  ", l2WrTr.dreqSprint))
             `TB_YAP($psprintf(" L2 WR Data     0x%x  ", l2WrTr.data))
             `TB_YAP($psprintf(" NonCACHE  Data 0x%x  ", nonCacheArray[l2WrTr.addr]))
             `ERROR($psprintf(" =======CPU WRITE MISMACH =============="))
         end else begin
             `DEBUG($psprintf(" NON CACHE WR DATA MATCH"))
             `INFO($psprintf(" L2_CHECK NON_CACHE_WRITE_PASS cReq %s  ", l2WrTr.creqSprint))
         end
        if(l2WrTr.cattr[1] == CH_REQ_NOCACHE) begin
           if((l2WrTr.addr == l2WrTr.data[NXADDRWIDTH-1:0]) && (l2WrTr.size == l2WrTr.data[71:64]&& (l2WrTr.cattr == l2WrTr.data[74:72]))) begin
               `DEBUG($psprintf("writeCheckTask NonCacheWr Addr and Size Match with expected cReq %s  ", l2RdAMonT.creqSprint))
           end else begin
               `ERROR($psprintf("writeCheckTask NonCacheWr Addr and Size Not Match with expected cReq %s  ", l2RdAMonT.creqSprint))
          end
        end
     end else begin
           `DEBUG($psprintf(" DEBUG_EVICT L2_TR   cReq %s  ", l2WrTr.creqSprint))
                evictCheckQueue = new();
                queueSize = cpuReqQueue.num();
                for(i=0; i<queueSize; i = i+1) begin
                     cpuReqQueue.get(cpuWrTr);
                        if(((cpuWrTr.addr >> 5) == (l2WrTr.addr >> 5))  )  begin
                          evictTr = new cpuWrTr;
                         `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP All Req  %s  ", evictTr.creqSprint))
                          evictCheckQueue.put(evictTr);
                        end
                     cpuReqQueue.put(cpuWrTr);
               end
           `DEBUG($psprintf(" DEBUG_EVICT evictCheckQueue CNT  %d  ", evictCheckQueue.num))
                lockSet = 0;
                queueSize = evictCheckQueue.num();
                for(i=0; i<queueSize; i = i+1) begin
                     evictCheckQueue.get(evictTr);
                     if((evictTr.reqType == CH_WRITE) || (evictTr.reqType == CH_READ) )  begin
                        lockSet = 1;
                     end
                     if(lockSet == 1) begin
                          evictCheckQueue.put(evictTr);
                     end else begin
                        `DEBUG($psprintf(" DEBUG_EVICT Removeing Inital INVAL/FLUSH from evictCheckQueue creq  %s  ", evictTr.creqSprint))
                     end
                end
           `DEBUG($psprintf(" DEBUG_EVICT evictCheckQueue CNT  %d  ", evictCheckQueue.num))


          if(memArray.exists(l2WrTr.addr))  begin
                queueSize = evictCheckQueue.num();
                comuteData[NXDATAWIDTH-1:0] = memArray[l2WrTr.addr];
                `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP memArray Data 0x%32h  %h", comuteData[NXDATAWIDTH-1:0],l2WrTr.addr))
                for(i=0; i<queueSize; i = i+1) begin
                     evictCheckQueue.get(cpuWrTr);
                     if(((cpuWrTr.addr >> 5) == (l2WrTr.addr >> 5)) && (cpuWrTr.reqType == CH_INVAL) && (EvictDataMatch == 0))  begin
                           invalFoundAfterWr = 1;
                          comuteData[NXDATAWIDTH-1:0] = memArray[l2WrTr.addr];
                          `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP INVAL FOUND Load Mem Array Data 0x%32h  0x%h", comuteData[NXDATAWIDTH-1:0],l2WrTr.addr))
                         `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP INVAL REQ is   %s  ", cpuWrTr.creqSprint))
                     end
                     if(((cpuWrTr.addr >> 5) == (l2WrTr.addr >> 5)) && (cpuWrTr.reqType == CH_FLUSH) && (EvictDataMatch == 0) && (invalFoundAfterWr == 0))  begin
                          `ERROR($psprintf(" DEBUG_EVICT FLUSH FOUND .MEMARRYCMP But still Data is Not Match with Mem+Wr Data %s", cpuWrTr.creqSprint))
                     end
                     if(((cpuWrTr.addr >> 5) == (l2WrTr.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (EvictDataMatch == 1))  begin
                         `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP 2 Pend Wr Tr After Evict Wr Tr  %s  ", cpuWrTr.creqSprint))
                     end
                     if(((cpuWrTr.addr >> 5) == (l2WrTr.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (EvictDataMatch == 0))  begin
                          `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP 1 Pend Wr Tr Before Evict Wr Tr  %s  ", cpuWrTr.creqSprint))
                           comuteData[NXDATAWIDTH-1:0] = computeCacheData(comuteData[NXDATAWIDTH-1:0],cpuWrTr);
                           invalFoundAfterWr = 0;
                           if(comuteData[NXDATAWIDTH-1:0] == l2WrTr.data) begin
                               EvictDataMatch = 1'b1;
                               evictMemArray[l2WrTr.addr] = l2WrTr.data;
                               memArray.delete(l2WrTr.addr);
                               cpuEvictWrTr = new cpuWrTr;
                              `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP DATA MATCH %s  ", cpuEvictWrTr.creqSprint))
                              `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP Addr 0x%x DATA 0x%x  ",l2WrTr.addr, evictMemArray[l2WrTr.addr]))
                           end 
                    end  else begin
                       evictCheckQueue.put(cpuWrTr);
                    end // end for comuteReadHit
                end  // end for

                if(EvictDataMatch == 1) begin
                queueSize = cpuReqQueue.num();
                    for(i=0; i<queueSize; i = i+1) begin
                       cpuReqQueue.get(cpuWrTr);
                       if(((cpuWrTr.addr >> 5) == (cpuEvictWrTr.addr >> 5)) && (cpuWrTr.reqType != CH_READ) && (cpuWrTr.transactionTime <= cpuEvictWrTr.transactionTime))  begin
                          `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP Remove Tr from cpuReqQueue Queue %s  ", cpuWrTr.creqSprint))
                       end else begin
                          cpuReqQueue.put(cpuWrTr);
                       end
                    end
                end

            end

          if((evictMemArray.exists(l2WrTr.addr)) && (EvictDataMatch == 1'b0) && (EvictDataMatchWithInval == 1'b0) )  begin
                queueSize = evictCheckQueue.num();
                comuteData[NXDATAWIDTH-1:0] = evictMemArray[l2WrTr.addr];
                `DEBUG($psprintf(" DEBUG_EVICT EVICARRYCMP memArray Data 0x%32h  %s", comuteData[NXDATAWIDTH-1:0],l2WrTr.addr))
                for(i=0; i<queueSize; i = i+1) begin
                     evictCheckQueue.get(cpuWrTr);
                     if(((cpuWrTr.addr >> 5) == (l2WrTr.addr >> 5)) && (cpuWrTr.reqType == CH_FLUSH) && (EvictDataMatchWithFlush == 0))  begin
                          comuteData[NXDATAWIDTH-1:0] = memArray[l2WrTr.addr];
                          `ERROR($psprintf(" DEBUG_EVICT FLUSH FOUND .EVICARRYCMP But still Data is Not Match with Mem+Wr Data %s", cpuWrTr.creqSprint))
                     end
                     if(((cpuWrTr.addr >> 5) == (l2WrTr.addr >> 5)) && (cpuWrTr.reqType == CH_INVAL) && (EvictDataMatchWithFlush == 0))  begin
                          `DEBUG($psprintf(" DEBUG_EVICT EVICARRYCMP INVAL FOUND Load Mem Array Data 0x%32h  0x%h", comuteData[NXDATAWIDTH-1:0],l2WrTr.addr))
                         `DEBUG($psprintf(" DEBUG_EVICT EVICARRYCMP INVAL REQ is   %s  ", cpuWrTr.creqSprint))
                     end
                     if(((cpuWrTr.addr >> 5) == (l2WrTr.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (EvictDataMatchWithFlush == 1))  begin
                         `DEBUG($psprintf(" DEBUG_EVICT EVICARRYCMP 2 Pend Wr Tr After Evict Wr Tr  %s  ", cpuWrTr.creqSprint))
                     end
                     if(((cpuWrTr.addr >> 5) == (l2WrTr.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (EvictDataMatchWithFlush == 0))  begin
                          `DEBUG($psprintf(" DEBUG_EVICT EVICARRYCMP 1 Pend Wr Tr Before Evict Wr Tr  %s  ", cpuWrTr.creqSprint))
                           comuteData[NXDATAWIDTH-1:0] = computeCacheData(comuteData[NXDATAWIDTH-1:0],cpuWrTr);
                           if(comuteData[NXDATAWIDTH-1:0] == l2WrTr.data) begin
                               EvictDataMatchWithFlush = 1'b1;
                               evictMemArray[l2WrTr.addr] = l2WrTr.data;
                               memArray.delete(l2WrTr.addr);
                               cpuEvictWrTr = new cpuWrTr;
                              `DEBUG($psprintf(" DEBUG_EVICT EVICARRYCMP DATA MATCH %s  ", cpuEvictWrTr.creqSprint))
                              `DEBUG($psprintf(" DEBUG_EVICT EVICARRYCMP Addr 0x%x DATA 0x%x  ",l2WrTr.addr, evictMemArray[l2WrTr.addr]))
                           end 
                    end  else begin
                       evictCheckQueue.put(cpuWrTr);
                    end // end for comuteReadHit
                end  // end for

                if(EvictDataMatchWithFlush == 1) begin
                queueSize = cpuReqQueue.num();
                    for(i=0; i<queueSize; i = i+1) begin
                       cpuReqQueue.get(cpuWrTr);
                       if(((cpuWrTr.addr >> 5) == (cpuEvictWrTr.addr >> 5)) && (cpuWrTr.reqType != CH_READ) && (cpuWrTr.transactionTime <= cpuEvictWrTr.transactionTime))  begin
                          `DEBUG($psprintf(" DEBUG_EVICT EVICARRYCMP Remove Tr from cpuReqQueue Queue %s  ", cpuWrTr.creqSprint))
                       end else begin
                          cpuReqQueue.put(cpuWrTr);
                       end
                    end
                end

            end

              if((EvictDataMatch == 1) || (EvictDataMatchWithFlush == 1)) begin
                queueSize = cpuReqQueue.num();
                for(i=0; i<queueSize; i = i+1) begin
                   cpuReqQueue.get(cpuWrTr);
                       if(((cpuWrTr.addr >> 5) == (cpuEvictWrTr.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (cpuWrTr.transactionTime < cpuEvictWrTr.transactionTime))  begin
                           WBWFound = 1;
                          `DEBUG($psprintf(" DEBUG_EVICT  WBWFound cReq %s  ", cpuWrTr.creqSprint))
                       end
                       if(((cpuWrTr.addr >> 5) == (cpuEvictWrTr.addr >> 5)) && (cpuWrTr.reqType == CH_READ) && (cpuWrTr.transactionTime < cpuEvictWrTr.transactionTime))  begin
                           RBWFound = 1;
                          `DEBUG($psprintf(" DEBUG_EVICT  WBWFound cReq %s  ", cpuWrTr.creqSprint))
                       end
                       if(((cpuWrTr.addr >> 5) == (cpuEvictWrTr.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (IAWFound == 0) && (cpuWrTr.transactionTime > cpuEvictWrTr.transactionTime))  begin
                           WAWFound = 1;
                          `DEBUG($psprintf(" DEBUG_EVICT  WAWFound cReq %s  ", cpuWrTr.creqSprint))
                       end
                       if(((cpuWrTr.addr >> 5) == (cpuEvictWrTr.addr >> 5)) && (cpuWrTr.reqType == CH_READ) && (IAWFound == 0) && (cpuWrTr.transactionTime > cpuEvictWrTr.transactionTime))  begin
                           RAWFound = 1;
                          `DEBUG($psprintf(" DEBUG_EVICT  RAWFound cReq %s  ", cpuWrTr.creqSprint))
                       end
                       if(((cpuWrTr.addr >> 5) == (cpuEvictWrTr.addr >> 5)) && (cpuWrTr.reqType == CH_INVAL) && (WAWFound == 0) && (RAWFound == 0) && (cpuWrTr.transactionTime > cpuEvictWrTr.transactionTime))  begin
                           IAWFound = 1;
                           IAWTr = new cpuWrTr; 
                          `DEBUG($psprintf(" DEBUG_EVICT  IAWFound cReq %s  ", cpuWrTr.creqSprint))
                       end
                   cpuReqQueue.put(cpuWrTr);
                end
              end

              `DEBUG($psprintf(" DEBUG_READ  WBWFound %d RBWFound %d WAWFound %d RAWFound %d IAWFound %d  ",WBWFound,RBWFound,WAWFound,RAWFound,IAWFound ))
               if((IAWFound == 1'b1) && (WBWFound == 1'b0) && (RBWFound == 1'b0) && (WAWFound == 1'b0) && (RAWFound == 1'b0)) begin
                   if(memArray.exists(l2WrTr.addr) || evictMemArray.exists(l2WrTr.addr) || InvalArray.exists(l2WrTr.addr))  begin
                      evictMemArray.delete(l2WrTr.addr);
                      memArray.delete(l2WrTr.addr);
                      InvalArray.delete(l2WrTr.addr);
                      `DEBUG($psprintf(" DEBUG_READ. RM_MEM IAWFound  time %t   ", IAWTr.transactionTime))
                      `DEBUG($psprintf(" DEBUG_READ. RM_MEM After Write Inval found. Removeing all Mem's. time %t Read req %s  ", $time,l2WrTr.creqSprint))
                      if(memArray.exists(l2WrTr.addr) || evictMemArray.exists(l2WrTr.addr) || InvalArray.exists(l2WrTr.addr))  begin
                        `ERROR($psprintf(" DEBUG_READ. RM_MEM  MEM not delete. Addr 0x%x", l2WrTr.addr))
                      end
                   end else begin
                       `ERROR($psprintf(" DEBUG_READ. RM_MEM  MEM not exists Addr 0x%x", l2WrTr.addr))
                   end
               end
/*
*/
           if((InvalArray.exists(l2WrTr.addr))&& (EvictDataMatch == 1'b0) && (EvictDataMatchWithFlush == 1'b0) )  begin
                queueSize = cpuReqQueue.num();
                comuteData[NXDATAWIDTH-1:0] = InvalArray[l2WrTr.addr];
                `DEBUG($psprintf(" DEBUG_EVICT INVALARRYCMP InvalMem Data 0x%32h  %s", comuteData[NXDATAWIDTH-1:0],l2WrTr.addr))
                for(i=0; i<queueSize; i = i+1) begin
                     cpuReqQueue.get(cpuWrTr);
                     if(((cpuWrTr.addr >> 5) == (l2WrTr.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (EvictDataMatchWithInval == 1))  begin
                         `DEBUG($psprintf(" DEBUG_EVICT INVALARRYCMP 2 Pend Wr Tr After Evict Wr Tr  %s  ", cpuWrTr.creqSprint))
                     end
                     if(((cpuWrTr.addr >> 5) == (l2WrTr.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (EvictDataMatchWithInval == 0))  begin
                          `DEBUG($psprintf(" DEBUG_EVICT INVALARRYCMP 1 Pend Wr Tr Before Evict Wr Tr  %s  ", cpuWrTr.creqSprint))
                           comuteData[NXDATAWIDTH-1:0] = computeCacheData(comuteData[NXDATAWIDTH-1:0],cpuWrTr);
                           if(comuteData[NXDATAWIDTH-1:0] == l2WrTr.data) begin
                               EvictDataMatchWithInval = 1'b1;
                               InvalArray.delete(l2WrTr.addr);
                              `DEBUG($psprintf(" DEBUG_EVICT INVALARRYCMP DATA MATCH %s  ", cpuWrTr.creqSprint))
                           end 
                    end  else begin
                       cpuReqQueue.put(cpuWrTr);
                    end // end for comuteReadHit
                end  // end for
           end  


           // removening INVAL and FLUSH in Que after Write
           begin
           queueSize = cpuReqQueue.num();
           cpuWrRdTr = new();
                `DEBUG($psprintf(" DEBUG_EVICT Removeing Flush/Inval From Queue Started"))
                for(i=0; i<queueSize; i = i+1) begin
                     cpuReqQueue.get(cpuWrTr);
                     if(((cpuWrTr.addr >> 5) == (l2WrTr.addr >> 5)) && ((cpuWrTr.reqType == CH_FLUSH) || (cpuWrTr.reqType == CH_INVAL)) && (RemoveFlushInvalFromQueue == 0))  begin
                         `DEBUG($psprintf(" DEBUG_EVICT Removeing Flush/Inval From Queue %s  ", cpuWrTr.creqSprint))
                     //end else if(((cpuWrTr.addr >> 5) == (l2WrTr.addr >> 5)) && ((cpuWrTr.reqType == CH_WRITE) || (cpuWrTr.reqType == CH_READ)) && (RemoveFlushInvalFromQueue == 0))  begin
                     end else if(((cpuWrTr.addr >> 5) == (l2WrTr.addr >> 5)) && ((cpuWrTr.reqType == CH_WRITE) || (cpuWrTr.reqType == CH_READ)) && (RemoveFlushInvalFromQueue == 0))  begin
                         `DEBUG($psprintf(" DEBUG_EVICT Not Removeing Flush/Inval From Queue %s  ", cpuWrTr.creqSprint))
                         cpuReqQueue.put(cpuWrTr);
                         RemoveFlushInvalFromQueue = 1;
                     end else begin
                         cpuReqQueue.put(cpuWrTr);
                     end

                end // end for
          end // end begin

          if(EvictDataMatch == 1)
             `DEBUG($psprintf(" CACHE_EVICT DATA_MATCH_PASS Data Match With EvictMem Creq %s",l2WrTr.creqSprint ))
          if(EvictDataMatchWithFlush == 1)
             `DEBUG($psprintf(" CACHE_EVICT DATA_MATCH_PASS Data Match With FlushMem Creq %s",l2WrTr.creqSprint ))
          if(EvictDataMatchWithInval == 1)
             `DEBUG($psprintf(" CACHE_EVICT DATA_MATCH_PASS Data Match With InvalMem Creq %s",l2WrTr.creqSprint ))

          if((EvictDataMatch == 1) || (EvictDataMatchWithFlush == 1) || (EvictDataMatchWithInval == 1))  begin
             `DEBUG($psprintf(" CACHE EVICT DATA MATCH Addr 0x%x",l2WrTr.addr ))
          end else begin
                      `TB_YAP($psprintf(" CACHE EVICT DATA NOT MATCH "))
                      `TB_YAP($psprintf(" L2 EVICT   TR cReq %s  ", l2WrTr.creqSprint))
                      `TB_YAP($psprintf(" L2 EVICT    Data 0x%x  ", l2WrTr.data))
                      `ERROR($psprintf(" =======CPU WRITE MISMACH =============="))
          end

      end  // check cache or non cache write
  end  // end while
endtask

  
task finish();
    begin
      isEmpty();
      clock(1000);
      /*reg [63:0]cpuRspCacheWrTr;
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

        reg [63:0]totalTransactions;
        reg [63:0]totalCacheWriteTr;
        reg [63:0]totalCacheReadTr;
        reg [63:0]totalNonCacheWriteTr;
        reg [63:0]totalNonCacheReadTr;
        reg [63:0]totalFlushTr;
        reg [63:0]totalInvalidTr;
        reg [63:0]totalCacheWriteACKTr;
        reg [63:0]totalCacheWriteNOACKTr;
        reg [63:0]totalNonCacheWriteACKTr;
        reg [63:0]totalNonCacheWriteNOACKTr;*/



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


task dataCacheWrRdAllTest ();
     integer k,m,l;
     reg [BYTEADDBITS-1:0] byteAddr;
     reg [ROWADDRBITS-1:0] rowAddr;
     reg [TAGADDRBITS-1:0] tagAddr;
     reg [NXADDRWIDTH-1:0] cacaheAddr;
     reg [31:0]MinVal,MaxVal;
 
     reg addrArry[*];
     bit Done;
     bit Done1;
     reg [8:0]totalRows;
          `INFO($psprintf("dataCacheWrRdAllTest  Count %d   Count %d ",NUMWAYS,NUMROWS))
       nonCacheArray.delete;
       //memArray.delete;
    clock(1000);
    reReset();
    cpuReqQueue = new();
    memArray.delete;

    `TB_YAP(" dataCacheWrRdAllTest TEST STARTED")
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
                 tagAddr[TAGADDRBITS-1-2:0] = $urandom_range(MinVal,MaxVal);
                 Done =0;
                 Done1 =0;
                 while(Done == 0) begin
                     cacaheAddr[NXADDRWIDTH-1:0] = {2'h0,tagAddr[TAGADDRBITS-1-2:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
                     if(!(addrArry.exists(cacaheAddr[NXADDRWIDTH-1:0])))begin
                          addrArry[cacaheAddr[NXADDRWIDTH-1:0]] = 1;
			  cacheAddArray[k][m] = cacaheAddr[NXADDRWIDTH-1:0];
                          //memArray[cacaheAddr[NXADDRWIDTH-1:0]] = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
                          while(Done1 == 0) begin
                              totalRows[8:0] = $urandom_range(0,'h1ff);
                              if(!(cacheRandomAddArray.exists(totalRows[8:0])))begin
                                    cacheRandomAddArray[totalRows[8:0]] = cacaheAddr[NXADDRWIDTH-1:0];
                                    Done1 = 1;
                              end
                          end
                          Done = 1;
                     end else begin
                          tagAddr[TAGADDRBITS-1-2:0] = $urandom_range(MinVal,MaxVal);
                          Done = 0;
                     end
                 end
           end
        end
  

       for(k=0;k<NUMWAYS;k=k+1) begin
           for(m=0;m<NUMROWS;m=m+1)begin
                     {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]} = cacheAddArray[k][m];
               `DEBUG($psprintf("CACHE_ADDR way %d row %d  tagAddr[18:0] 0x%x rowAddr[6:0] 0x%x byteAddr[4:0] 0x%x  ",k,m,tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]))
           end
       end
       readCache();
       writeCache();
       readCache();
       writeCache();
       readCache();
       flushCache();
       readCache();
       writeCache();
       flushCache();
       writeCache();
       readCache();
       invalidCache();
       readCache();
       invalidCache();
       writeCache();
       readCache();
       evictCache();
       evictCacheRead();
    end
     clock(1000);
     isEmpty();
    `TB_YAP("dataCacheWrRdAllTest TEST END")
endtask:dataCacheWrRdAllTest



task readCache();
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
       reg [NXADDRWIDTH-1:0]addr;
       reg [4:0]bAddr;
       reg [NXDATAWIDTH-1:0]data;
       integer a;
    `INFO("dataCacheWrRdAllTest READ STARTED")
          `INFO($psprintf("readCache  Count %d   Count %d ",NUMWAYS,NUMROWS))
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
    `INFO("dataCacheWrRdAllTest READ END")
endtask:readCache


    task writeCache();
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
       reg [NXADDRWIDTH-1:0]addr;
       reg [BYTEADDBITS-1:0]bAddr;
       reg [NXDATAWIDTH-1:0]data;
       reg [NXSIZEWIDTH-1:0]bSize;
       bit bSizeDone =0;
       integer a;
    `INFO("dataCacheWrRdAllTest WRITE STARTED")
          `INFO($psprintf("writeCache  Count %d   Count %d ",NUMWAYS,NUMROWS))
       for(a=0; a<NUMWAYS*NUMROWS; a = a+1) begin
          bAddr[BYTEADDBITS-1:0] = $urandom_range(0,'h1f);
          bSizeDone = 0;
          while(bSizeDone == 0)  begin
             bSize[NXSIZEWIDTH-1:0] = $urandom_range(1,'h20);
             if((bAddr[BYTEADDBITS-1:0] + bSize[NXSIZEWIDTH-1:0]) <= 'h20) begin
                 bSizeDone = 1; end
          end
          if(bSize[NXSIZEWIDTH-1:0] <= 'h3) begin
               bAddr[BYTEADDBITS-1:0] = 'h0;
               bSize[NXSIZEWIDTH-1:0] = 'h20;
          end
          addr[NXADDRWIDTH-1:0] = cacheRandomAddArray[a];
          addr[NXADDRWIDTH-1:0] = {addr[NXADDRWIDTH-1:5],bAddr[BYTEADDBITS-1:0]};
          //addr[NXADDRWIDTH-1:0] = {addr[NXADDRWIDTH-1:5],5'h0};
          data[NXDATAWIDTH-1:0] = randomWrData(NXDATAWIDTH,addr[NXADDRWIDTH-1:0]);
           cpuReqT = new();
          //bSize[7:0] = 8'h20;
          cpuReqT.addr = addr[NXADDRWIDTH-1:0];
          cpuReqT.data = data[NXDATAWIDTH-1:0];
          cpuReqT.cattr = 3'h3;
          cpuReqT.size = bSize[NXSIZEWIDTH-1:0];
          cpuReqT.reqType = CH_WRITE; 
          cpuReqT.dattr = 3'h1;
          mstTr[0].send(cpuReqT);
       end
    clock(1000);
    isEmpty();
    `INFO("dataCacheWrRdAllTest WRITE END")
    endtask:writeCache

    task evictCache();
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
       reg [NXADDRWIDTH-1:0]addr;
       reg [BYTEADDBITS-1:0]bAddr;
       reg [NXDATAWIDTH-1:0]data;
       reg [NXSIZEWIDTH-1:0]bSize;
       bit bSizeDone =0;
       integer a,b;
       reg [1:0]way;
    `INFO("dataCacheWrRdAllTest EVICT STARTED")
          `INFO($psprintf("evictCache  Count %d   Count %d ",NUMWAYS,NUMROWS))
       for(a=0; a<NUMWAYS; a = a+1) begin
         for(b=0; b<NUMROWS; b = b+1) begin
          way[1:0] = a;
          addr[NXADDRWIDTH-1:0] = cacheAddArray[a][b];
          addr[NXADDRWIDTH-1:0] = {17'h0,way[1:0],addr[11:5],5'h0};
          //memArray[addr[NXADDRWIDTH-1:0]] = randomData(NXDATAWIDTH,addr[NXADDRWIDTH-1:0]);
          data[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,addr[NXADDRWIDTH-1:0]);
           cpuReqT = new();
          cpuReqT.addr = addr[NXADDRWIDTH-1:0];
          cpuReqT.data = data[NXDATAWIDTH-1:0];
          cpuReqT.cattr = 3'h3;
          cpuReqT.size = 8'h20;
          cpuReqT.reqType = CH_WRITE; 
          cpuReqT.dattr = 3'h1;
          mstTr[0].send(cpuReqT);
       end
     end
    clock(1000);
    isEmpty();
    `INFO("dataCacheWrRdAllTest EVICT END")
    endtask:evictCache

    task evictCacheRead();
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
       reg [NXADDRWIDTH-1:0]addr;
       reg [BYTEADDBITS-1:0]bAddr;
       reg [NXDATAWIDTH-1:0]data;
       reg [NXSIZEWIDTH-1:0]bSize;
       bit bSizeDone =0;
       integer a,b;
       reg [1:0]way;
    `INFO("dataCacheWrRdAllTest EVICT READ STARTED")
          `INFO($psprintf("evictCacheRead  Count %d   Count %d ",NUMWAYS,NUMROWS))
       for(a=0; a<NUMWAYS; a = a+1) begin
         for(b=0; b<NUMROWS; b = b+1) begin
          way[1:0] = a;
          addr[NXADDRWIDTH-1:0] = cacheAddArray[a][b];
          addr[NXADDRWIDTH-1:0] = {17'h0,way[1:0],addr[11:5],5'h0};
          cpuReqT = new();
          cpuReqT.addr = addr[NXADDRWIDTH-1:0];
          cpuReqT.cattr = 3'h3;
          cpuReqT.size = 8'h20;
          cpuReqT.reqType = CH_READ; 
          mstTr[0].send(cpuReqT);
       end
     end
    clock(1000);
    isEmpty();
    `INFO("dataCacheWrRdAllTest EVICT READ END")
    endtask:evictCacheRead

    task flushCache();
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
       reg [NXADDRWIDTH-1:0]addr;
       reg [BYTEADDBITS-1:0]bAddr;
       reg [NXDATAWIDTH-1:0]data;
       integer a;
    `INFO("dataCacheWrRdAllTest FLUSH STARTED")
       for(a=0; a<NUMWAYS*NUMROWS; a = a+1) begin
           addr[NXADDRWIDTH-1:0] = cacheRandomAddArray[a];
           data[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,addr[NXADDRWIDTH-1:0]);
           cpuReqT = new();
           cpuReqT.addr = addr[NXADDRWIDTH-1:0];
           cpuReqT.cattr = 3'h3;
           cpuReqT.size = 8'h20;
           cpuReqT.reqType = CH_FLUSH; 
           mstTr[0].send(cpuReqT);
       end
    clock(1000);
    isEmpty();
    `INFO("dataCacheWrRdAllTest FLUSH END")
    endtask:flushCache

    task invalidCache();
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
       reg [NXADDRWIDTH-1:0]addr;
       reg [BYTEADDBITS-1:0]bAddr;
       reg [NXDATAWIDTH-1:0]data;
       integer a;
    `INFO("dataCacheWrRdAllTest INVAL STARTED")
          `INFO($psprintf("invalidCache  Count %d   Count %d ",NUMWAYS,NUMROWS))
       for(a=0; a<NUMWAYS*NUMROWS; a = a+1) begin
           addr[NXADDRWIDTH-1:0] = cacheRandomAddArray[a];
           data[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,addr[NXADDRWIDTH-1:0]);
           cpuReqT = new();
           cpuReqT.addr = addr[NXADDRWIDTH-1:0];
           cpuReqT.cattr = 3'h3;
           cpuReqT.size = 8'h20;
           cpuReqT.reqType = CH_INVAL; 
           mstTr[0].send(cpuReqT);
       end
    clock(1000);
    isEmpty();
    cpuReqQueue = new();
    `INFO("dataCacheWrRdAllTest INVAL END")
    endtask:invalidCache

/*
task statsTest;
     integer k,m,l;
     reg [BYTEADDBITS-1:0] byteAddr;
     reg [ROWADDRBITS-1:0] rowAddr;
     reg [TAGADDRBITS-1:0] tagAddr;
     reg [NXADDRWIDTH-1:0] cacaheAddr;
     reg [31:0]MinVal,MaxVal;
     reg [48:0]rtlRdHit;
     reg [48:0]rtlRdMiss;
     reg [48:0]rtlWrHit;
     reg [48:0]rtlWrMiss;
     reg [48:0]rtlTotalRd;
     reg [48:0]rtlTotalRdCyc;
     reg [48:0]tbRdHit;
     reg [48:0]tbRdMiss;
     reg [48:0]tbWrHit;
     reg [48:0]tbWrMiss;
     reg [48:0]tbTotalRd;
     reg [48:0]tbTotalRdCyc;

     reg addrArry[*];
     bit Done;
     bit Done1;
     reg [8:0]totalRows;
          `INFO($psprintf("dataCacheWrRdAllTest  Count %d   Count %d ",NUMWAYS,NUMROWS))

    `TB_YAP(" dataCacheWrRdAllTest TEST STARTED")
     begin
       for(k=0;k<NUMWAYS;k=k+1) begin
           for(m=0;m<NUMROWS;m=m+1)begin
	       statsCacheAddArray[k][m] = 'h0;
           end
       end

     tbRdHit = 0;
     tbRdMiss = 0;
     tbWrHit = 0;
     tbWrMiss = 0;
     tbTotalRd = 0;
     tbTotalRdCyc = 0;

//=================  fill the cache with know data and address

for(k=0;k<NUMWAYS;k=k+1) begin
           for(m=0;m<NUMROWS;m=m+1)begin
                 byteAddr[BYTEADDBITS-1:0] = 0;
                 rowAddr[ROWADDRBITS-1:0] = m;
                 tagAddr[TAGADDRBITS-1-2:0] = k;
                 cacaheAddr[NXADDRWIDTH-1:0] = {2'h0,tagAddr[TAGADDRBITS-1-2:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
                 if(!(memArray.exists(cacaheAddr[NXADDRWIDTH-1:0])))begin
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = 1;
		      statsCacheAddArray[k][m] = cacaheAddr[NXADDRWIDTH-1:0];
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
                 end
           end
        end
statsReadCache();   // this will fill the all the cache rows with Tag address = 0,1,2,3
     clock(1000);
     isEmpty();
for(k=0;k<NUMWAYS;k=k+1) begin
           for(m=0;m<NUMROWS;m=m+1)begin
                 byteAddr[BYTEADDBITS-1:0] = 0;
                 rowAddr[ROWADDRBITS-1:0] = m;
                 tagAddr[TAGADDRBITS-1-2:0] = k+4;
                 cacaheAddr[NXADDRWIDTH-1:0] = {2'h0,tagAddr[TAGADDRBITS-1-2:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
                 if(!(memArray.exists(cacaheAddr[NXADDRWIDTH-1:0])))begin
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = 1;
		      statsCacheAddArray[k][m] = cacaheAddr[NXADDRWIDTH-1:0];
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
                 end
           end
        end
statsReadCache();   // this will fill the all the cache rows with Tag address = 4,5,6,7
     clock(1000);
     isEmpty();

for(k=0;k<NUMWAYS;k=k+1) begin
           for(m=0;m<NUMROWS;m=m+1)begin
                 byteAddr[BYTEADDBITS-1:0] = 0;
                 rowAddr[ROWADDRBITS-1:0] = m;
                 tagAddr[TAGADDRBITS-1-2:0] = k+8;
                 cacaheAddr[NXADDRWIDTH-1:0] = {2'h0,tagAddr[TAGADDRBITS-1-2:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
                 if(!(memArray.exists(cacaheAddr[NXADDRWIDTH-1:0])))begin
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = 1;
		      statsCacheAddArray[k][m] = cacaheAddr[NXADDRWIDTH-1:0];
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
                 end
           end
        end
statsReadCache();   // this will fill the all the cache rows with Tag address = 8,9,10,11
     clock(1000);
     isEmpty();
for(k=0;k<NUMWAYS;k=k+1) begin
           for(m=0;m<NUMROWS;m=m+1)begin
                 byteAddr[BYTEADDBITS-1:0] = 0;
                 rowAddr[ROWADDRBITS-1:0] = m;
                 tagAddr[TAGADDRBITS-1-2:0] = k+12;
                 cacaheAddr[NXADDRWIDTH-1:0] = {2'h0,tagAddr[TAGADDRBITS-1-2:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
                 if(!(memArray.exists(cacaheAddr[NXADDRWIDTH-1:0])))begin
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = 1;
		      statsCacheAddArray[k][m] = cacaheAddr[NXADDRWIDTH-1:0];
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
                 end
           end
        end
statsReadCache();   // this will fill the all the cache rows with Tag address = 12,13,14,15
     clock(1000);
     isEmpty();

for(k=0;k<NUMWAYS;k=k+1) begin
           for(m=0;m<NUMROWS;m=m+1)begin
                 byteAddr[BYTEADDBITS-1:0] = 0;
                 rowAddr[ROWADDRBITS-1:0] = m;
                 tagAddr[TAGADDRBITS-1-2:0] = k;
                 cacaheAddr[NXADDRWIDTH-1:0] = {2'h0,tagAddr[TAGADDRBITS-1-2:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
                 if(!(memArray.exists(cacaheAddr[NXADDRWIDTH-1:0])))begin
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = 1;
		      statsCacheAddArray[k][m] = cacaheAddr[NXADDRWIDTH-1:0];
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
                 end
           end
        end
statsInvalCache();   // this will invalid  Tag address = 0,1,2,3
     clock(1000);
     isEmpty();
for(k=0;k<NUMWAYS;k=k+1) begin
           for(m=0;m<NUMROWS;m=m+1)begin
                 byteAddr[BYTEADDBITS-1:0] = 0;
                 rowAddr[ROWADDRBITS-1:0] = m;
                 tagAddr[TAGADDRBITS-1-2:0] = k+4;
                 cacaheAddr[NXADDRWIDTH-1:0] = {2'h0,tagAddr[TAGADDRBITS-1-2:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
                 if(!(memArray.exists(cacaheAddr[NXADDRWIDTH-1:0])))begin
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = 1;
		      statsCacheAddArray[k][m] = cacaheAddr[NXADDRWIDTH-1:0];
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
                 end
           end
        end
statsInvalCache();   // this will invalid Tag address = 4,5,6,7
     clock(1000);
     isEmpty();

for(k=0;k<NUMWAYS;k=k+1) begin
           for(m=0;m<NUMROWS;m=m+1)begin
                 byteAddr[BYTEADDBITS-1:0] = 0;
                 rowAddr[ROWADDRBITS-1:0] = m;
                 tagAddr[TAGADDRBITS-1-2:0] = k+8;
                 cacaheAddr[NXADDRWIDTH-1:0] = {2'h0,tagAddr[TAGADDRBITS-1-2:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
                 if(!(memArray.exists(cacaheAddr[NXADDRWIDTH-1:0])))begin
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = 1;
		      statsCacheAddArray[k][m] = cacaheAddr[NXADDRWIDTH-1:0];
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
                 end
           end
        end
statsInvalCache();   // this will invalid Tag address = 8,9,10,11
     clock(1000);
     isEmpty();
for(k=0;k<NUMWAYS;k=k+1) begin
           for(m=0;m<NUMROWS;m=m+1)begin
                 byteAddr[BYTEADDBITS-1:0] = 0;
                 rowAddr[ROWADDRBITS-1:0] = m;
                 tagAddr[TAGADDRBITS-1-2:0] = k+12;
                 cacaheAddr[NXADDRWIDTH-1:0] = {2'h0,tagAddr[TAGADDRBITS-1-2:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
                 if(!(memArray.exists(cacaheAddr[NXADDRWIDTH-1:0])))begin
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = 1;
		      statsCacheAddArray[k][m] = cacaheAddr[NXADDRWIDTH-1:0];
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
                 end
           end
        end
statsInvalCache();   // this will invalid Tag address = 12,13,14,15
     clock(1000);
     isEmpty();
    cpuReqQueue = new();
    memArray.delete;
// now cache should not have any data or valid tags.
//=================================================================
// check the default stats registers
        force testbench.ip_top.cnt_cac_reset_stats =1;
        clock(10);
        release testbench.ip_top.cnt_cac_reset_stats;// <=0;
        clock(10);
	rtlRdHit[48-1:0]            = testbench.ip_top.cnt_cac_rd_hit[48-1:0];
	rtlRdMiss[48-1:0]           = testbench.ip_top.cnt_cac_rd_miss[48-1:0];
	rtlWrHit[48-1:0]            = testbench.ip_top.cnt_cac_wr_hit[48-1:0];
	rtlWrMiss[48-1:0]           = testbench.ip_top.cnt_cac_wr_miss[48-1:0];
	rtlTotalRd[48-1:0]          = testbench.ip_top.cnt_cac_total_reads[48-1:0];
	rtlTotalRdCyc[48-1:0]       = testbench.ip_top.cnt_cac_total_read_cycles[48-1:0];
        if(rtlRdHit[48-1:0] !=0) begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_rd_hit is not Zero after Reset  %d ",rtlRdHit[48-1:0]))end
        if(rtlRdMiss[48-1:0] !=0)begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_rd_miss is not Zero after Reset  %d ",rtlRdMiss[48-1:0]))end
        if(rtlWrHit[48-1:0] !=0)begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_wr_hit is not Zero after Reset  %d ",rtlWrHit[48-1:0]))end
        if(rtlWrMiss[48-1:0] !=0)begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_wr_miss is not Zero after Reset  %d ",rtlWrMiss[48-1:0]))end
        if(rtlTotalRd[48-1:0] !=0)begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_total_reads is not Zero after Reset  %d ",rtlTotalRd[48-1:0]))end
        if(rtlTotalRdCyc[48-1:0] !=0)begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_total_read_cycles is not Zero after Reset  %d ",rtlTotalRdCyc[48-1:0])) end



//=====================================================================

       for(k=0;k<NUMWAYS;k=k+1) begin
           for(m=0;m<NUMROWS;m=m+1)begin
                 byteAddr[BYTEADDBITS-1:0] = 0;
                 rowAddr[ROWADDRBITS-1:0] = m;
                 tagAddr[TAGADDRBITS-1-2:0] = k;
                 cacaheAddr[NXADDRWIDTH-1:0] = {2'h0,tagAddr[TAGADDRBITS-1-2:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
                 if(!(memArray.exists(cacaheAddr[NXADDRWIDTH-1:0])))begin
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = 1;
		      statsCacheAddArray[k][m] = cacaheAddr[NXADDRWIDTH-1:0];
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
                 end
           end
        end
  

       for(k=0;k<NUMWAYS;k=k+1) begin
           for(m=0;m<NUMROWS;m=m+1)begin
                     {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]} = statsCacheAddArray[k][m];
               `DEBUG($psprintf("STATS_CACHE_ADDR way %d row %d  tagAddr[18:0] 0x%x rowAddr[6:0] 0x%x byteAddr[4:0] 0x%x  ",k,m,tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]))
           end
       end
       statsReadCache();
       tbRdMiss = 512;
       statsReadCache();
       tbRdHit = 512;

       for(k=0;k<NUMWAYS;k=k+1) begin
           for(m=0;m<NUMROWS;m=m+1)begin
                 byteAddr[BYTEADDBITS-1:0] = 0;
                 rowAddr[ROWADDRBITS-1:0] = m;
                 tagAddr[TAGADDRBITS-1-2:0] = 4+k;
                 cacaheAddr[NXADDRWIDTH-1:0] = {2'h0,tagAddr[TAGADDRBITS-1-2:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
                 if(!(memArray.exists(cacaheAddr[NXADDRWIDTH-1:0])))begin
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = 1;
		      statsCacheAddArray[k][m] = cacaheAddr[NXADDRWIDTH-1:0];
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
                 end
           end
        end
  

       for(k=0;k<NUMWAYS;k=k+1) begin
           for(m=0;m<NUMROWS;m=m+1)begin
                     {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]} = statsCacheAddArray[k][m];
               `DEBUG($psprintf("STATS_CACHE_ADDR way %d row %d  tagAddr[18:0] 0x%x rowAddr[6:0] 0x%x byteAddr[4:0] 0x%x  ",k,m,tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]))
           end
       end

       statsWriteCache();
       tbWrMiss = 512;
       statsWriteCache();
       tbWrHit = 512;
       //statsFlushCache();
       //statsInvalCache();


     clock(1000);
     isEmpty();
	rtlRdHit[48-1:0]            = testbench.ip_top.cnt_cac_rd_hit[48-1:0];
	rtlRdMiss[48-1:0]           = testbench.ip_top.cnt_cac_rd_miss[48-1:0];
	rtlWrHit[48-1:0]            = testbench.ip_top.cnt_cac_wr_hit[48-1:0];
	rtlWrMiss[48-1:0]           = testbench.ip_top.cnt_cac_wr_miss[48-1:0];
	rtlTotalRd[48-1:0]          = testbench.ip_top.cnt_cac_total_reads[48-1:0];
	rtlTotalRdCyc[48-1:0]       = testbench.ip_top.cnt_cac_total_read_cycles[48-1:0];
          `TB_YAP($psprintf("STATS TB_RD_MISS %d    RTL_RD_MISS  %d ",tbRdMiss[48-1:0],rtlRdMiss[48-1:0]))
          `TB_YAP($psprintf("STATS TB_RD_HIT  %d    RTL_RD_HIT  %d ",tbRdHit[48-1:0],rtlRdHit[48-1:0]))
          `TB_YAP($psprintf("STATS TB_WR_MISS %d    RTL_WR_MISS  %d ",tbWrMiss[48-1:0],rtlWrMiss[48-1:0]))
          `TB_YAP($psprintf("STATS TB_WR_HIT  %d    RTL_WR_HIT  %d ",tbWrHit[48-1:0],rtlWrHit[48-1:0]))
       
          if(rtlRdHit[48-1:0] != tbRdHit[48-1:0]) begin
            `ERROR($psprintf("STATS CHECK  rtlRdHit  and tbRdHit  not Match  %d  %d ",rtlRdHit[48-1:0],tbRdHit[48-1:0]))
          end else begin
            `TB_YAP($psprintf("STATS CHECK  rtlRdHit  and tbRdHit   Match  %d  %d ",rtlRdHit[48-1:0],tbRdHit[48-1:0]))
          end
          if(rtlRdMiss[48-1:0] != tbRdMiss[48-1:0]) begin
            `ERROR($psprintf("STATS CHECK  rtlRdMiss  and tbRdMiss  not Match  %d  %d ",rtlRdMiss[48-1:0],tbRdMiss[48-1:0]))
          end else begin
            `TB_YAP($psprintf("STATS CHECK  rtlRdMiss  and tbRdMiss   Match  %d  %d ",rtlRdMiss[48-1:0],tbRdMiss[48-1:0]))
          end
          if(rtlWrHit[48-1:0] != tbWrHit[48-1:0]) begin
            `ERROR($psprintf("STATS CHECK  rtlWrHit  and tbWrHit  not Match  %d  %d ",rtlWrHit[48-1:0],tbWrHit[48-1:0]))
          end else begin
            `TB_YAP($psprintf("STATS CHECK  rtlWrHit  and tbWrHit   Match  %d  %d ",rtlWrHit[48-1:0],tbWrHit[48-1:0]))
          end
          if(rtlWrMiss[48-1:0] != tbWrMiss[48-1:0]) begin
            `ERROR($psprintf("STATS CHECK  rtlWrMiss  and tbWrMiss  not Match  %d  %d ",rtlWrMiss[48-1:0],tbWrMiss[48-1:0]))
          end else begin
            `TB_YAP($psprintf("STATS CHECK  rtlWrMiss  and tbWrMiss   Match  %d  %d ",rtlWrMiss[48-1:0],tbWrMiss[48-1:0]))
          end
          if(rtlTotalRd[48-1:0] != (tbRdMiss[48-1:0] + tbRdHit[48-1:0] )) begin
            `ERROR($psprintf("STATS CHECK  rtlTotalRd  and tbRdMiss +  tbRdHit not Match  %d  %d  ",rtlTotalRd[48-1:0],(tbRdMiss[48-1:0]+tbRdHit[48-1:0])))
          end else begin
            `TB_YAP($psprintf("STATS CHECK  rtlTotalRd  and tbRdMiss +  tbRdHit  Match  %d  %d ",rtlTotalRd[48-1:0],(tbRdMiss[48-1:0]+tbRdHit[48-1:0])))
          end

        force testbench.ip_top.cnt_cac_reset_stats =1;
        clock(10);
        release testbench.ip_top.cnt_cac_reset_stats ;
        clock(10);
	rtlRdHit[48-1:0]            = testbench.ip_top.cnt_cac_rd_hit[48-1:0];
	rtlRdMiss[48-1:0]           = testbench.ip_top.cnt_cac_rd_miss[48-1:0];
	rtlWrHit[48-1:0]            = testbench.ip_top.cnt_cac_wr_hit[48-1:0];
	rtlWrMiss[48-1:0]           = testbench.ip_top.cnt_cac_wr_miss[48-1:0];
	rtlTotalRd[48-1:0]          = testbench.ip_top.cnt_cac_total_reads[48-1:0];
	rtlTotalRdCyc[48-1:0]       = testbench.ip_top.cnt_cac_total_read_cycles[48-1:0];
        if(rtlRdHit[48-1:0] !=0) begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_rd_hit is not Zero after Reset  %d ",rtlRdHit[48-1:0])) end
        if(rtlRdMiss[48-1:0] !=0) begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_rd_miss is not Zero after Reset  %d ",rtlRdMiss[48-1:0])) end
        if(rtlWrHit[48-1:0] !=0) begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_wr_hit is not Zero after Reset  %d ",rtlWrHit[48-1:0])) end
        if(rtlWrMiss[48-1:0] !=0) begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_wr_miss is not Zero after Reset  %d ",rtlWrMiss[48-1:0])) end
        if(rtlTotalRd[48-1:0] !=0) begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_total_reads is not Zero after Reset  %d ",rtlTotalRd[48-1:0])) end
        if(rtlTotalRdCyc[48-1:0] !=0) begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_total_read_cycles is not Zero after Reset  %d ",rtlTotalRdCyc[48-1:0])) end


        testbench.ip_top.core.des.algo.a1_loop.algo.core.cac_rd_hit <=48'hfffffffffff0;
        clock(10);
        testbench.ip_top.core.des.algo.a1_loop.algo.core.cac_rd_miss <=48'hfffffffffff0;
        clock(10);
        testbench.ip_top.core.des.algo.a1_loop.algo.core.cac_wr_hit <=48'hfffffffffff0;
        clock(10);
        testbench.ip_top.core.des.algo.a1_loop.algo.core.cac_wr_miss <=48'hfffffffffff0;
        clock(10);
        testbench.ip_top.core.des.algo.a1_loop.algo.core.cac_total_reads <=48'hfffffffffff0;
        clock(10);
        testbench.ip_top.core.des.algo.a1_loop.algo.core.cac_total_read_cycles <=48'hfffffffffff0;
        clock(10);
       statsReadCache();
       statsWriteCache();
       for(k=0;k<NUMWAYS;k=k+1) begin
           for(m=0;m<NUMROWS;m=m+1)begin
                 byteAddr[BYTEADDBITS-1:0] = 0;
                 rowAddr[ROWADDRBITS-1:0] = m;
                 tagAddr[TAGADDRBITS-1-2:0] = 12+k;
                 cacaheAddr[NXADDRWIDTH-1:0] = {2'h0,tagAddr[TAGADDRBITS-1-2:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
                 if(!(memArray.exists(cacaheAddr[NXADDRWIDTH-1:0])))begin
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = 1;
		      statsCacheAddArray[k][m] = cacaheAddr[NXADDRWIDTH-1:0];
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
                 end
           end
        end
       statsReadCache();
       statsWriteCache();
  for(k=0;k<NUMWAYS;k=k+1) begin
           for(m=0;m<NUMROWS;m=m+1)begin
                 byteAddr[BYTEADDBITS-1:0] = 0;
                 rowAddr[ROWADDRBITS-1:0] = m;
                 tagAddr[TAGADDRBITS-1-2:0] = 16+k;
                 cacaheAddr[NXADDRWIDTH-1:0] = {2'h0,tagAddr[TAGADDRBITS-1-2:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
                 if(!(memArray.exists(cacaheAddr[NXADDRWIDTH-1:0])))begin
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = 1;
		      statsCacheAddArray[k][m] = cacaheAddr[NXADDRWIDTH-1:0];
                      memArray[cacaheAddr[NXADDRWIDTH-1:0]] = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
                 end
           end
        end
       statsWriteCache();
        clock(1000);
        isEmpty();
       rtlRdHit[48-1:0]            = testbench.ip_top.cnt_cac_rd_hit[48-1:0];
	rtlRdMiss[48-1:0]           = testbench.ip_top.cnt_cac_rd_miss[48-1:0];
	rtlWrHit[48-1:0]            = testbench.ip_top.cnt_cac_wr_hit[48-1:0];
	rtlWrMiss[48-1:0]           = testbench.ip_top.cnt_cac_wr_miss[48-1:0];
	rtlTotalRd[48-1:0]          = testbench.ip_top.cnt_cac_total_reads[48-1:0];
	rtlTotalRdCyc[48-1:0]       = testbench.ip_top.cnt_cac_total_read_cycles[48-1:0];
        if(rtlRdHit[48-1:0] !={48{1'b1}}) begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_rd_hit is not Staturated  %d ",rtlRdHit[48-1:0])) end
        if(rtlRdMiss[48-1:0] !={48{1'b1}}) begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_rd_miss is not Staturated   %d ",rtlRdMiss[48-1:0])) end
        if(rtlWrHit[48-1:0] !={48{1'b1}}) begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_wr_hit is not Staturated   %d ",rtlWrHit[48-1:0])) end
        if(rtlWrMiss[48-1:0] !={48{1'b1}}) begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_wr_miss is not Staturated   %d ",rtlWrMiss[48-1:0])) end
        if(rtlTotalRd[48-1:0] !={48{1'b1}}) begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_total_reads is not Staturated   %d ",rtlTotalRd[48-1:0])) end
        if(rtlTotalRdCyc[48-1:0] !={48{1'b1}}) begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_total_read_cycles is not Staturated  %d ",rtlTotalRdCyc[48-1:0])) end

force testbench.ip_top.cnt_cac_reset_stats =1;
        clock(10);
        release testbench.ip_top.cnt_cac_reset_stats ;
        clock(10);
	rtlRdHit[48-1:0]            = testbench.ip_top.cnt_cac_rd_hit[48-1:0];
	rtlRdMiss[48-1:0]           = testbench.ip_top.cnt_cac_rd_miss[48-1:0];
	rtlWrHit[48-1:0]            = testbench.ip_top.cnt_cac_wr_hit[48-1:0];
	rtlWrMiss[48-1:0]           = testbench.ip_top.cnt_cac_wr_miss[48-1:0];
	rtlTotalRd[48-1:0]          = testbench.ip_top.cnt_cac_total_reads[48-1:0];
	rtlTotalRdCyc[48-1:0]       = testbench.ip_top.cnt_cac_total_read_cycles[48-1:0];
        if(rtlRdHit[48-1:0] !=0) begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_rd_hit is not Zero after Reset  %d ",rtlRdHit[48-1:0])) end
        if(rtlRdMiss[48-1:0] !=0) begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_rd_miss is not Zero after Reset  %d ",rtlRdMiss[48-1:0])) end
        if(rtlWrHit[48-1:0] !=0) begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_wr_hit is not Zero after Reset  %d ",rtlWrHit[48-1:0])) end
        if(rtlWrMiss[48-1:0] !=0) begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_wr_miss is not Zero after Reset  %d ",rtlWrMiss[48-1:0])) end
        if(rtlTotalRd[48-1:0] !=0) begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_total_reads is not Zero after Reset  %d ",rtlTotalRd[48-1:0])) end
        if(rtlTotalRdCyc[48-1:0] !=0) begin
           `ERROR($psprintf("STATS CHECK  cnt_cac_total_read_cycles is not Zero after Reset  %d ",rtlTotalRdCyc[48-1:0])) end




     clock(1000);
     isEmpty();
    end
    `TB_YAP("dataCacheWrRdAllTest TEST END")


endtask:statsTest

task statsReadCache();
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
       reg [NXADDRWIDTH-1:0]addr;
       reg [4:0]bAddr;
       reg [NXDATAWIDTH-1:0]data;
       integer a,b;
    `INFO("dataCacheWrRdAllTest READ STARTED")
          `INFO($psprintf("statsReadCache  Count %d   Count %d ",NUMWAYS,NUMROWS))
       for(a=0; a<NUMWAYS; a = a+1) begin
          for(b=0; b<NUMROWS; b = b+1) begin
           addr[NXADDRWIDTH-1:0] = statsCacheAddArray[a][b];
           data[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,addr[NXADDRWIDTH-1:0]);
           cpuReqT = new();
           cpuReqT.addr = addr[NXADDRWIDTH-1:0];
           cpuReqT.cattr = 3'h3;
           cpuReqT.size = 8'h20;
           cpuReqT.reqType = CH_READ; 
           mstTr[0].send(cpuReqT);
          end
       end
endtask:statsReadCache

task statsWriteCache();
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
       reg [NXADDRWIDTH-1:0]addr;
       reg [4:0]bAddr;
       reg [NXDATAWIDTH-1:0]data;
       integer a,b;
    `INFO("dataCacheWrRdAllTest READ STARTED")
          `INFO($psprintf("statsWriteCache  Count %d   Count %d ",NUMWAYS,NUMROWS))
       for(a=0; a<NUMWAYS; a = a+1) begin
          for(b=0; b<NUMROWS; b = b+1) begin
           addr[NXADDRWIDTH-1:0] = statsCacheAddArray[a][b];
           data[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,addr[NXADDRWIDTH-1:0]);
           cpuReqT = new();
           cpuReqT.addr = addr[NXADDRWIDTH-1:0];
           cpuReqT.cattr = 3'h3;
           cpuReqT.size = 8'h20;
           cpuReqT.reqType = CH_WRITE; 
           cpuReqT.data = data[NXDATAWIDTH-1:0]; 
           cpuReqT.dattr = 1; 
           mstTr[0].send(cpuReqT);
          end
       end
endtask:statsWriteCache


task statsFlushCache();
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
       reg [NXADDRWIDTH-1:0]addr;
       reg [4:0]bAddr;
       reg [NXDATAWIDTH-1:0]data;
       integer a,b;
    `INFO("dataCacheWrRdAllTest READ STARTED")
          `INFO($psprintf("statsFlushCache  Count %d   Count %d ",NUMWAYS,NUMROWS))
       for(a=0; a<NUMWAYS; a = a+1) begin
          for(b=0; b<NUMROWS; b = b+1) begin
           addr[NXADDRWIDTH-1:0] = statsCacheAddArray[a][b];
           data[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,addr[NXADDRWIDTH-1:0]);
           cpuReqT = new();
           cpuReqT.addr = addr[NXADDRWIDTH-1:0];
           cpuReqT.cattr = 3'h3;
           cpuReqT.size = 8'h20;
           cpuReqT.reqType = CH_FLUSH; 
           mstTr[0].send(cpuReqT);
          end
       end
endtask:statsFlushCache

task statsInvalCache();
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
       reg [NXADDRWIDTH-1:0]addr;
       reg [4:0]bAddr;
       reg [NXDATAWIDTH-1:0]data;
       integer a,b;
    `INFO("dataCacheWrRdAllTest READ STARTED")
          `INFO($psprintf("statsInvalCache  Count %d   Count %d ",NUMWAYS,NUMROWS))
       for(a=0; a<NUMWAYS; a = a+1) begin
          for(b=0; b<NUMROWS; b = b+1) begin
           addr[NXADDRWIDTH-1:0] = statsCacheAddArray[a][b];
           data[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,addr[NXADDRWIDTH-1:0]);
           cpuReqT = new();
           cpuReqT.addr = addr[NXADDRWIDTH-1:0];
           cpuReqT.cattr = 3'h3;
           cpuReqT.size = 8'h20;
           cpuReqT.reqType = CH_INVAL; 
           mstTr[0].send(cpuReqT);
          end
       end
clock(1000);
    isEmpty();
    cpuReqQueue = new();

endtask:statsInvalCache

*/

task sendRead(input reg [NXADDRWIDTH-1:0] addr,input reg [7:0] size,input reg uch, input reg ack);
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
  reg [NXDATAWIDTH-1:0]memData;
  reg [NXDATAWIDTH-1:0]wrData;
  begin
    reg [NXADDRWIDTH-1:0] memAddr = (addr >> (BYTEADDBITS)) << (BYTEADDBITS);
    memData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,addr[NXADDRWIDTH-1:0]);
    memData[75:64] = {4'h1,size[NXSIZEWIDTH-1:0]};
    if((!(nonCacheArray.exists(addr[NXADDRWIDTH-1:0]))) && (uch == 1))begin
      nonCacheArray[addr[NXADDRWIDTH-1:0]] = memData[NXDATAWIDTH-1:0];
    end
    if((!(memArray.exists(memAddr[NXADDRWIDTH-1:0]))) && (uch == 0))begin
     memArray[memAddr[NXADDRWIDTH-1:0]] = memData[NXDATAWIDTH-1:0];
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

task sendWrite(input reg [NXADDRWIDTH-1:0] addr,input reg [7:0] size,input reg uch, input reg ack);
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
  reg [NXDATAWIDTH-1:0]memData;
  reg [NXDATAWIDTH-1:0]wrData;
  begin
    reg [NXADDRWIDTH-1:0] memAddr = (addr >> (BYTEADDBITS)) << (BYTEADDBITS);
    memData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,addr[NXADDRWIDTH-1:0]);
    memData[75:64] = {4'h1,size[NXSIZEWIDTH-1:0]};
    if((!(nonCacheArray.exists(addr[NXADDRWIDTH-1:0]))) && (uch == 1))begin
      nonCacheArray[addr[NXADDRWIDTH-1:0]] = memData[NXDATAWIDTH-1:0];
    end
    if((!(memArray.exists(memAddr[NXADDRWIDTH-1:0]))) && (uch == 0))begin
     memArray[memAddr[NXADDRWIDTH-1:0]] = memData[NXDATAWIDTH-1:0];
    end
    cpuReqT = new();
    `INFO($psprintf("write addr=0x%0x size=%0d uch=%0b ack=%0b", addr, size, uch, ack))
    cpuReqT.addr = addr; 
    cpuReqT.cattr = (ack << 0) | (!uch << 1);
    cpuReqT.reqType = CH_WRITE;
    cpuReqT.size = size;
    wrData[NXDATAWIDTH-1:0] = (uch == 1) ? nonCacheArray[addr[NXADDRWIDTH-1:0]] : randomData(NXDATAWIDTH,addr[NXADDRWIDTH-1:0]);
    cpuReqT.data = wrData[NXDATAWIDTH-1:0];
    cpuReqT.dattr = 1;
    mstTr[0].send(cpuReqT);
  end
endtask:sendWrite

task sendFlush(input reg [NXADDRWIDTH-1:0] addr,input reg [7:0] size, input reg ack, input reg byIndex);
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
  begin
    cpuReqT = new();
    `INFO($psprintf("flush addr=0x%0x size=%0d  ack=%0b byIndex=%0b", addr, size, ack,byIndex))
    cpuReqT.addr = addr; 
    cpuReqT.cattr = (ack << 0) | (1 << 1) | (byIndex << 2);
    cpuReqT.reqType = CH_FLUSH;
    cpuReqT.size = size;
    mstTr[0].send(cpuReqT);
  end
endtask:sendFlush

task sendInval(input reg [NXADDRWIDTH-1:0] addr,input reg [7:0] size, input reg ack, input reg byIndex);
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
  begin
    cpuReqT = new();
    `INFO($psprintf("inval addr=0x%0x size=%0d  ack=%0b byIndex=%0b", addr, size, ack,byIndex))
    cpuReqT.addr = addr; 
    cpuReqT.cattr = (ack << 0) | (1 << 1) | (byIndex << 2) ;
    cpuReqT.reqType = CH_INVAL;
    cpuReqT.size = size;
    mstTr[0].send(cpuReqT);
  end
endtask:sendInval

task invalByIndex();
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rmReqT;
   reg [NXADDRWIDTH-1:0]addr;
   reg [NXDATAWIDTH-1:0]data;
   integer a,b;
   integer queueSize;
   reg [BYTEADDBITS-1:0] byteAddr;
   reg [ROWADDRBITS-1:0] rowAddr;
   reg [TAGADDRBITS-1:0] tagAddr;
   reg [TAGADDRBITS-1:0] tagAddr1;
   reg [NXADDRWIDTH-1:0] cacaheAddr;
   bit ack;
   begin
     invalFlushByIndexTest = 1;
    `INFO("invalByIndex Fill the Cache With Write")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = a;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              ack = $urandom_range(0,1);
              cpuReqT.cattr = 2'b1 << 1 | ack << 0;
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_WRITE; 
              cpuReqT.data = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
              cpuReqT.dattr = 1;
              mstTr[0].send(cpuReqT);
          end
        end
        clock(100);
        isEmpty();
    `INFO("invalByIndex Fill the Cache With Write End")


    
    `INFO("invalByIndex Read Cache")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = a;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              cpuReqT.cattr = {2'b1,1'b1};
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_READ; 
              mstTr[0].send(cpuReqT);
          end
        end
        clock(100);
        isEmpty();
    `INFO("invalByIndex Read Cache End")

    `INFO("invalByIndex Inval by Index")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = 0;
              tagAddr1[TAGADDRBITS-1:0] = a;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              cpuReqT.cattr = {2'b11,1'b0};
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_INVAL; 
              mstTr[0].send(cpuReqT);
              clock(10);
              isEmpty();
              addr[NXADDRWIDTH-1:0] = {tagAddr1[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              memArray.delete(addr[NXADDRWIDTH-1:0]);
          end
        end
        clock(100);
        isEmpty();
    `INFO("invalByIndex Inval by Index End")


    `INFO("Remove Tr from Cpu Queue")
     queueSize = cpuReqQueue.num();
     for(a=0; a<queueSize; a = a+1) begin
        cpuReqQueue.get(rmReqT);
     end


    `INFO("invalByIndex Fill the Cache With Write")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = a;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              ack = $urandom_range(0,1);
              cpuReqT.cattr = 2'b1 << 1 | ack << 0;
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_WRITE; 
              cpuReqT.data = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
              cpuReqT.dattr = 1;
              mstTr[0].send(cpuReqT);
          end
        end
        clock(100);
        isEmpty();
    `INFO("invalByIndex Fill the Cache With Write End")


    `INFO("invalByIndex Read Cache")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = a;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              cpuReqT.cattr = {2'b1,1'b1};
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_READ; 
              mstTr[0].send(cpuReqT);
          end
        end
        clock(100);
        isEmpty();
    `INFO("invalByIndex Read Cache End")

    `INFO("Invalidate Way1  useing normal INVAL CMD")
        for(a=0; a<1; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              if(a == 0) begin
                 tagAddr[TAGADDRBITS-1:0] = 1;
              end else if(a == 1) begin
                 tagAddr[TAGADDRBITS-1:0] = 2;
              end
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              cpuReqT.cattr = {2'b01,1'b0};
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_INVAL; 
              mstTr[0].send(cpuReqT);
              memArray.delete(cacaheAddr[NXADDRWIDTH-1:0]);
          end
        end
        clock(100);
        isEmpty();
    `INFO("Invalidate Way1  useing normal INVAL CMD End")

    `INFO("Invalidate Way0 Way3 useing INVAL_By_index CMD")
        for(a=0; a<2; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = 0;
              if(a == 0) begin
                  tagAddr1[TAGADDRBITS-1:0] = 1;
              end else if (a == 1) begin 
                  tagAddr1[TAGADDRBITS-1:0] = 2;
              end
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              cpuReqT.cattr = {2'b11,1'b0};
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_INVAL; 
              mstTr[0].send(cpuReqT);
              clock(10);
              isEmpty();
              addr[NXADDRWIDTH-1:0] = {tagAddr1[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              memArray.delete(addr[NXADDRWIDTH-1:0]);
          end
        end
        clock(100);
        isEmpty();
    `INFO("invalByIndex Way1 Way3 useing  INVAL_By_index End")

    `INFO("Remove Tr from Cpu Queue")
     queueSize = cpuReqQueue.num();
     for(a=0; a<queueSize; a = a+1) begin
        cpuReqQueue.get(rmReqT);
        if(rmReqT.addr <33'h3000) begin
           `DEBUG($psprintf("invalByIndex Removeing Way0,Way1,Way2 addr Addr=%0x", rmReqT.addr))
        end else begin
          cpuReqQueue.put(rmReqT);
        end
     end



    `INFO("invalByIndex Read Cache")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = a;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              cpuReqT.cattr = {2'b1,1'b1};
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_READ; 
              mstTr[0].send(cpuReqT);
          end
        end
        clock(100);
        isEmpty();
    `INFO("invalByIndex Read Cache End")
       queueSize = cpuReqQueue.num();
    `INFO($psprintf("invalByIndex QUEUE_CNT =%0d",queueSize ))
`INFO("Invalidate Way0 Way1 useing INVAL_By_index CMD")
        for(a=0; a<2; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = 0;
              tagAddr1[TAGADDRBITS-1:0] = a;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              cpuReqT.cattr = {2'b11,1'b0};
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_INVAL; 
              mstTr[0].send(cpuReqT);
              clock(10);
              isEmpty();
              addr[NXADDRWIDTH-1:0] = {tagAddr1[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              memArray.delete(addr[NXADDRWIDTH-1:0]);
          end
        end
        clock(100);
        isEmpty();
    `INFO("invalByIndex Way0 Way1 useing  INVAL_By_index End")

    `INFO("Remove Tr from Cpu Queue")
        for(a=0; a<2; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              cpuReqQueue.get(rmReqT);
              if(rmReqT.addr <33'h2000) begin
                 `DEBUG($psprintf("invalByIndex Removeing Way0,Way1,Way2 addr Addr=%0x", rmReqT.addr))
              end else begin
                cpuReqQueue.put(rmReqT);
              end
           end
        end

 `INFO("invalByIndex Read Cache")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = a;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              cpuReqT.cattr = {2'b1,1'b1};
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_READ; 
              mstTr[0].send(cpuReqT);
          end
        end
        clock(100);
        isEmpty();
    `INFO("invalByIndex Read Cache End")




     invalFlushByIndexTest = 0;
  end
endtask:invalByIndex

task flushByIndex();
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rmReqT;
   reg [NXADDRWIDTH-1:0]addr;
   reg [NXDATAWIDTH-1:0]data;
   integer a,b;
   integer queueSize;
   reg [BYTEADDBITS-1:0] byteAddr;
   reg [ROWADDRBITS-1:0] rowAddr;
   reg [TAGADDRBITS-1:0] tagAddr;
   reg [TAGADDRBITS-1:0] tagAddr1;
   reg [NXADDRWIDTH-1:0] cacaheAddr;
   bit ack;
   begin
     invalFlushByIndexTest = 1;
     outOfOrderRspEn = 0;
    `INFO("flushByIndex Fill the Cache With Write")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = a;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              ack = $urandom_range(0,1);
              ack = 0;
              cpuReqT.cattr = 2'b1 << 1 | ack << 0;
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_WRITE; 
              cpuReqT.data = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
              cpuReqT.dattr = 1;
              mstTr[0].send(cpuReqT);
          end
        end
        clock(100);
        isEmpty();
    `INFO("flushByIndex Fill the Cache With Write End")


    `INFO("flushByIndex flush Start")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = 0;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              cpuReqT.cattr = {2'b11,1'b0};
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_FLUSH; 
              mstTr[0].send(cpuReqT);
              clock(10);
              isEmpty();
          end
        end
        clock(100);
        isEmpty();
    `INFO("flushByIndex flush End")


    `INFO("flushByIndex Read Cache")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = a;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              cpuReqT.cattr = {2'b1,1'b1};
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_READ; 
              mstTr[0].send(cpuReqT);
          end
        end
        clock(100);
        isEmpty();
    `INFO("flushByIndex Read  End")


    `INFO("flushByIndex Fill the Cache With diff Write")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = a+4;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              ack = $urandom_range(0,1);
              ack = 0;
              cpuReqT.cattr = 2'b1 << 1 | ack << 0;
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_WRITE; 
              cpuReqT.data = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
              cpuReqT.dattr = 1;
              mstTr[0].send(cpuReqT);
          end
        end
        clock(100);
        isEmpty();
    `INFO("flushByIndex Fill the Cache With diff Write End")


   `INFO("flushByIndex normal Flush Way0 and Way2")
        for(a=0; a<2; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              if(a == 0)
                 tagAddr[TAGADDRBITS-1:0] = 4;
              else 
                 tagAddr[TAGADDRBITS-1:0] = 6;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              ack = 0;
              cpuReqT.cattr = 2'b1 << 1 | ack << 0;
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_FLUSH; 
              cpuReqT.data = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
              cpuReqT.dattr = 1;
              mstTr[0].send(cpuReqT);
          end
        end
        clock(100);
        isEmpty();
   `INFO("flushByIndex normal Flush Way0 and Way2 End")
`INFO("flushByIndex Flush Way1 and Way3")
        for(a=0; a<2; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = 0;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              ack = 0;
              cpuReqT.cattr = 2'b11 << 1 | ack << 0;
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_FLUSH; 
              cpuReqT.data = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
              cpuReqT.dattr = 1;
              mstTr[0].send(cpuReqT);
              clock(10);
              isEmpty();
          end
        end
        clock(100);
        isEmpty();
   `INFO("flushByIndex  Flush Way1 and Way3 End")

 `INFO("flushByIndex Read Cache")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = 4+a;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              cpuReqT.cattr = {2'b1,1'b1};
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_READ; 
              mstTr[0].send(cpuReqT);
          end
        end
        clock(100);
        isEmpty();
    `INFO("flushByIndex Read  End")

  `INFO("flushByIndex Fill the Cache With diff Write")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = a+8;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              ack = $urandom_range(0,1);
              ack = 0;
              cpuReqT.cattr = 2'b1 << 1 | ack << 0;
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_WRITE; 
              cpuReqT.data = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
              cpuReqT.dattr = 1;
              mstTr[0].send(cpuReqT);
          end
        end
        clock(100);
        isEmpty();
    `INFO("flushByIndex Fill the Cache With diff Write End")

`INFO("flushByIndex Flush Way0 and Way1")
        for(a=0; a<2; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = 0;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              ack = 0;
              cpuReqT.cattr = 2'b11 << 1 | ack << 0;
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_FLUSH; 
              cpuReqT.data = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
              cpuReqT.dattr = 1;
              mstTr[0].send(cpuReqT);
              clock(10);
              isEmpty();
          end
        end
        clock(100);
        isEmpty();
   `INFO("flushByIndex  Flush Way1 and Way3 End")
`INFO("flushByIndex Fill the Cache With diff Write")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = a+12;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              ack = $urandom_range(0,1);
              ack = 0;
              cpuReqT.cattr = 2'b1 << 1 | ack << 0;
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_WRITE; 
              cpuReqT.data = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
              cpuReqT.dattr = 1;
              mstTr[0].send(cpuReqT);
          end
        end
        clock(100);
        isEmpty();
    `INFO("flushByIndex Fill the Cache With diff Write End")


`INFO("flushByIndex Fill the Cache With diff Write")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = a+12;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              ack = 1;
              cpuReqT.cattr = 2'b1 << 1 | ack << 0;
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_READ; 
              cpuReqT.data = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
              cpuReqT.dattr = 1;
              mstTr[0].send(cpuReqT);
          end
        end
        clock(100);
        isEmpty();
    `INFO("flushByIndex Fill the Cache With diff Write End")
    `INFO("flushByIndex flush Start")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = 0;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              cpuReqT.cattr = {2'b11,1'b0};
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_FLUSH; 
              mstTr[0].send(cpuReqT);
              clock(10);
              isEmpty();
          end
        end
        clock(100);
        isEmpty();
    `INFO("flushByIndex flush End")

   end
endtask:flushByIndex


task dbgBusTest();
          `TB_YAP($psprintf("dbgBusTest START"))
      test_dbg_init_all();
      test_dbg_write_all();
      test_dbg_read_all();
      test_dbg_init_all();
          `TB_YAP($psprintf("dbgBusTest END"))
endtask:dbgBusTest

task test_dbg_init_all();
    integer i,j,k,l;
    MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgWrTr;
          `INFO($psprintf("test_dbg_init_all START"))
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
          `INFO($psprintf("test_dbg_init_all END"))
endtask:test_dbg_init_all

task test_dbg_write_all();
    integer i,j,k,l;
    MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgWrTr;
          `INFO($psprintf("test_dbg_write_all START"))
    for(i=0; i<NUMDBNK; i = i+1) begin
       for(j=0; j<NUMDROW; j = j+1) begin
           dbgWrTr = new();
           if(i==0) begin
               dbgWrTr.addr = j;
               dbgWrTr.baddr = i;
               dbgWrTr.din = {52'h0,randomMemData(92)};
               dbgWrTr.dout  = 'h0;
               dbgWrTr.reqType  = DBG_WRITE;
           end else begin
               dbgWrTr.addr = j;
               dbgWrTr.baddr = i;
               dbgWrTr.din = randomMemData(144);
               dbgWrTr.dout  = 'h0;
               dbgWrTr.reqType  = DBG_WRITE;
            end
            dbgMem[i][j] = dbgWrTr.din;
            dbgTr.send(dbgWrTr);
          `INFO($psprintf("DBGMEM_WR_DATA creq %s  ",  dbgWrTr.dbgWriteSprint))
       end  
    end  
      clock(10000);
          `INFO($psprintf("test_dbg_write_all END"))
endtask:test_dbg_write_all

task test_dbg_read_all();
    integer i,j,k,l;
    MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgWrTr;
          `INFO($psprintf("test_dbg_read_all START"))
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
          `INFO($psprintf("test_dbg_read_all END"))
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
          `INFO($psprintf("DBGMEM_RD_DATA creq %s  ",  dbgRdTr.dbgReadSprint))
       if(dbgRdTr.dout == dbgMem[dbgRdTr.baddr][dbgRdTr.addr]) begin
          `DEBUG($psprintf("DBGMEM PASS creq %s  ",  dbgRdTr.dbgReadSprint))
       end else begin
          `TB_YAP($psprintf("DBGMEM FAIL MEM_DATA creq 0x%0x  ",  dbgMem[dbgRdTr.baddr][dbgRdTr.addr]))
          `ERROR($psprintf("DBGMEM FAIL          creq %s  ",  dbgRdTr.dbgReadSprint))
       end

   end
endtask:dbgMemCheck

task testForT1MemError(input reg [NXADDRWIDTH-1:0]Addr, input integer errorBitPos);
  reg [104-1:0]t1_mem_data;
  reg [6:0]IndexAddr = Addr[NXADDRWIDTH-1:0] >> 5;
          `TB_YAP($psprintf("testForT1MemError START"))
  t2_mem_error_check = 0;
  sendInval(Addr,8'h20, 0,1);
  clock(10);
  sendInval(Addr,8'h20, 0,1);
  clock(10);
  sendInval(Addr,8'h20, 0,1);
  clock(10);
  sendInval(Addr,8'h20, 0,1);
  clock(10);
  sendRead(Addr, 8'h20, 0, 1); 
  clock(10);
  sendRead(Addr, 8'h20, 0, 1); 
  clock(1000);
  //t1_mem_data[104-1:0] = testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.bank_v0_h0.MEMCORE[IndexAddr];
  t1_mem_data[104-1:0] = t1_mem_data[104-1:0] ^ 1 << errorBitPos;
  //testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.bank_v0_h0.MEMCORE[IndexAddr] = t1_mem_data[104-1:0];
  clock(100);
  t1_mem_error_check = 1;
  sendRead(Addr, 8'h20, 0, 1); 
  clock(10);
          `TB_YAP($psprintf("testForT1MemError END"))
      clock(10000);
  t1_mem_error_check = 0;
endtask 

task testForT2MemError(input reg [NXADDRWIDTH-1:0]Addr, input integer errorBitPos);
  reg [144-1:0]t2_mem_data;
  reg [6:0]IndexAddr = Addr[NXADDRWIDTH-1:0] >> 5;
          `TB_YAP($psprintf("testForT2MemError START"))
  t1_mem_error_check = 0;
  sendInval(Addr,8'h20, 0,1);
  clock(10);
  sendInval(Addr,8'h20, 0,1);
  clock(10);
  sendInval(Addr,8'h20, 0,1);
  clock(10);
  sendInval(Addr,8'h20, 0,1);
  clock(10);
  sendRead(Addr, 8'h20, 0, 1); 
  clock(10);
  sendRead(Addr, 8'h20, 0, 1); 
  clock(1000);
  //t2_mem_data[144-1:0] = testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[IndexAddr];
  t2_mem_data[144-1:0] = t2_mem_data[144-1:0] ^ 1 << errorBitPos;
  //testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[IndexAddr] = t2_mem_data[144-1:0];
  clock(100);
  t2_mem_error_check = 1;
  sendRead(Addr, 8'h20, 0, 1); 
  clock(10);
          `TB_YAP($psprintf("testForT2MemError END"))
clock(10000);
  t2_mem_error_check = 0;
endtask 
task flushCpuReqQueue();
integer i,j;
reg [ROWADDRBITS-1:0]rowAddr;
mailbox flushCpuReqQueue;
MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReq1T;
flushCpuReqQueue = new();
     insertL2Error = 0;
     j = cpuReqQueue.num();
    `TB_YAP($psprintf(" CPU_REQ_QUEUE_COUNT AT END   SIZE  %d  ", cpuReqQueue.num()))
     for(i=0; i<j; i = i+1) begin
         cpuReqQueue.get(cpuReqT);
         if(cpuReqT.reqType == CH_READ) begin
           `ERROR($psprintf("flushCpuReqQueue cpuReqQueue Have Read Tr %s  ",  cpuReqT.creqSprint))
         end else if(cpuReqT.reqType == CH_WRITE) begin
             cpuReq1T = new cpuReqT;
             flushCpuReqQueue.put(cpuReq1T);
             cpuReqQueue.put(cpuReqT);
         end else begin
             cpuReqQueue.put(cpuReqT);
         end
     end

    `TB_YAP($psprintf(" CPU_REQ_QUEUE_COUNT AT END   SIZE  %d  ", cpuReqQueue.num()))
     j = flushCpuReqQueue.num();
    `TB_YAP($psprintf(" flushCpuReqQueue SIZE  %d  ", flushCpuReqQueue.num()))
     for(i=0; i<j; i = i+1) begin
         flushCpuReqQueue.get(cpuReqT);
         if(cpuReqT.reqType == CH_WRITE) begin
             cpuReq1T = new(); 
             cpuReq1T.addr = (cpuReqT.addr >> 5) << 5;
             cpuReq1T.reqType = CH_WRITE;
             cpuReq1T.size = 8'h20;
             cpuReq1T.cattr = 3'h3;
             cpuReq1T.data = randomWrData(NXDATAWIDTH,cpuReq1T.addr);
             cpuReq1T.dattr = 3'h1;
             mstTr[0].send(cpuReq1T);
           `TB_YAP($psprintf("flushCpuReqQueue sending Write  Tr %s  ",  cpuReq1T.creqSprint))
             clock(100);
             cpuReq1T = new() ;
             cpuReq1T.addr = (cpuReqT.addr >> 5) << 5;
             cpuReq1T.reqType = CH_FLUSH;
             cpuReq1T.size = 8'h20;
             cpuReq1T.cattr = 3'h3;
             mstTr[0].send(cpuReq1T);
         end
     end
    `TB_YAP($psprintf(" CPU_REQ_QUEUE_COUNT AT END   SIZE  %d  ", cpuReqQueue.num()))
     clock(2000);

     j = cpuReqQueue.num();
     for(i=0; i<j; i = i+1) begin
         cpuReqQueue.get(cpuReqT);
         if((cpuReqT.reqType == CH_FLUSH) || (cpuReqT.reqType == CH_INVAL))begin
           `DEBUG($psprintf("flushCpuReqQueue removeing Flush/Inval from cpuReqQueue Tr %s  ",  cpuReqT.creqSprint))
         end else begin
             cpuReqQueue.put(cpuReqT);
         end
     end
     


    `TB_YAP($psprintf(" CPU_REQ_QUEUE_COUNT AT END   SIZE  %d  ", cpuReqQueue.num()))
     clock(1000);

    


     j = cpuReqQueue.num();
     for(i=0; i<j; i = i+1) begin
         cpuReqQueue.get(cpuReqT);
         if((cpuReqT.reqType == CH_READ) || (cpuReqT.reqType == CH_WRITE))begin
           `ERROR($psprintf("TestbenchReq cpuReqQueue Have Read/Write Tr %s  ",  cpuReqT.creqSprint))
         end
     end

     if(l2RspNonCycheWrTr[63:0] != mstTr[0].totalNonCacheWriteTr[63:0]) begin
           `ERROR($psprintf("TestbenchReq NC Writes Cnt Not Matching 0x%x 0x%x   ", l2RspNonCycheWrTr[63:0],mstTr[0].totalNonCacheWriteTr[63:0]))
     end

     if(l2RspNonCacheRdTr[63:0] != mstTr[0].totalNonCacheReadTr[63:0]) begin
           `ERROR($psprintf("TestbenchReq NC Writes Cnt Not Matching 0x%x 0x%x   ", l2RspNonCacheRdTr[63:0],mstTr[0].totalNonCacheReadTr[63:0]))
     end


endtask


task resetCache();
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rmReqT;
   reg [NXADDRWIDTH-1:0]addr;
   reg [NXDATAWIDTH-1:0]data;
   integer a,b;
   integer queueSize;
   reg [BYTEADDBITS-1:0] byteAddr;
   reg [ROWADDRBITS-1:0] rowAddr;
   reg [TAGADDRBITS-1:0] tagAddr;
   reg [TAGADDRBITS-1:0] tagAddr1;
   reg [NXADDRWIDTH-1:0] cacaheAddr;
   bit ack;
   begin
    `INFO("resetCache Fill the Cache With Write")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = a;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              ack = $urandom_range(0,1);
              cpuReqT.cattr = 2'b1 << 1 | ack << 0;
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_WRITE; 
              cpuReqT.data = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
              cpuReqT.dattr = 1;
              mstTr[0].send(cpuReqT);
          end
        end
        clock(100);
        isEmpty();
    `INFO("resetCache Fill the Cache With Write End")


    
    `INFO("resetCache Read Cache")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = a;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              cpuReqT.cattr = {2'b1,1'b1};
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_READ; 
              mstTr[0].send(cpuReqT);
          end
        end
        clock(100);
        isEmpty();
    `INFO("resetCache Read Cache End")

     reReset();
     cpuReqQueue = new();
    `INFO("resetCache Fill the Cache With Write")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = a;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              ack = $urandom_range(0,1);
              cpuReqT.cattr = 2'b1 << 1 | ack << 0;
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_WRITE; 
              cpuReqT.data = randomData(NXDATAWIDTH,cacaheAddr[NXADDRWIDTH-1:0]);
              cpuReqT.dattr = 1;
              mstTr[0].send(cpuReqT);
          end
        end
        clock(100);
        isEmpty();
    `INFO("resetCache Fill the Cache With Write End")


    
    `INFO("resetCache Read Cache")
        for(a=0; a<NUMWAYS; a = a+1) begin
           for(b=0; b<NUMROWS; b = b+1) begin
              byteAddr[BYTEADDBITS-1:0] = 0;
              rowAddr[ROWADDRBITS-1:0] = b;
              tagAddr[TAGADDRBITS-1:0] = a;
              cacaheAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
              cpuReqT = new();
              cpuReqT.addr = cacaheAddr[NXADDRWIDTH-1:0];
              cpuReqT.cattr = {2'b1,1'b1};
              cpuReqT.size = 8'h20;
              cpuReqT.reqType = CH_READ; 
              mstTr[0].send(cpuReqT);
          end
        end
        clock(100);
        isEmpty();
    `INFO("resetCache Read Cache End")
    end


    `TB_YAP("resetCache Read Cache End")
endtask:resetCache

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
   integer loopCnt = 50;
   reg [BYTEADDBITS-1:0] byteAddr;
   reg [ROWADDRBITS-1:0] rowAddr;
   reg [TAGADDRBITS-1:0] tagAddr;
   reg [NXADDRWIDTH-1:0] Addr;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgWrTr;
   integer errorBitPos;
   t1_mem_error_check = 1;
  begin
    `TB_YAP("testT1MemError START")
      reReset();
     cpuReqQueue = new();
     insertL2Error = 0;
    while(loopCnt != 0) begin
     // 1
     t1_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     errorBitPos = $urandom_range(0,103);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
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
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);


    `TB_YAP("testT1MemError CASE 1")

     // 2
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
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
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

    `TB_YAP("testT1MemError CASE 2")

     // 3
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
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
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t1_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

    `TB_YAP("testT1MemError CASE 3")

     // 4
     t1_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     errorBitPos = $urandom_range(0,103);
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     t1_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = 2'b01;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     t1_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t1_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

    `TB_YAP("testT1MemError CASE 4")
      //5 
     t1_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.t1_readB);
     @(posedge testbench.ip_top.t1_readB);
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
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);


    `TB_YAP("testT1MemError CASE 5")

     // 6
     t1_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


    `TB_YAP("testT1MemError CASE 6")
     

     loopCnt = loopCnt -1 ;

           `TB_YAP($psprintf("testT1MemError  loopCnt %d   ", loopCnt ))
    end

      isEmpty();
    `TB_YAP("testT1MemError END")

  end
endtask:testT1MemError


task testT1MemErrorNoL2Error();
   integer a,b;
   integer loopCnt = 50;
   reg [BYTEADDBITS-1:0] byteAddr;
   reg [ROWADDRBITS-1:0] rowAddr;
   reg [TAGADDRBITS-1:0] tagAddr;
   reg [NXADDRWIDTH-1:0] Addr;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgWrTr;
   integer errorBitPos;
   t1_mem_error_check = 1;
  begin
    `TB_YAP("testT1MemErrorNoL2Error START")
      reReset();
     cpuReqQueue = new();
     insertL2Error = 0;
    while(loopCnt != 0) begin
     // 1
     t1_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     errorBitPos = $urandom_range(0,103);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
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


    `TB_YAP("testT1MemErrorNoL2Error CASE 1")

     // 2
     t1_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.t1_readB);
     clock(3);
     errorBitPos = $urandom_range(0,103);
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t1_mem_error_check = 0;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

    `TB_YAP("testT1MemErrorNoL2Error CASE 2")

     // 3
     t1_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.t1_readB);
     @(posedge testbench.ip_top.t1_readB);
     errorBitPos = $urandom_range(0,103);
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t1_mem_error_check = 0;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

    `TB_YAP("testT1MemErrorNoL2Error CASE 3")

     // 4
     t1_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     errorBitPos = $urandom_range(0,103);
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     t1_mem_error_check = 1;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     t1_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

    `TB_YAP("testT1MemErrorNoL2Error CASE 4")

     // 6
     t1_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


    `TB_YAP("testT1MemErrorNoL2Error CASE 5")
     

     loopCnt = loopCnt -1 ;

           `TB_YAP($psprintf("testT1MemErrorNoL2Error  loopCnt %d   ", loopCnt ))
    end

      isEmpty();
    `TB_YAP("testT1MemErrorNoL2Error END")

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
  begin
    `TB_YAP("testT2MemError START")
      reReset();
     cpuReqQueue = new();
     insertL2Error = 0;
    while(loopCnt != 0) begin
     // 1
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
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

    `TB_YAP("testT2MemError CASE 1")

     // 2
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
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

    `TB_YAP("testT2MemError CASE 2")
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
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

    `TB_YAP("testT2MemError CASE 3")
    //4
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.t2_readB);
     errorBitPos = $urandom_range(0,143);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);


    `TB_YAP("testT2MemError CASE 4")
    //5
     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     t2_mem_error_check = 1;
     errorBitPos = $urandom_range(0,143);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);



     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

    `TB_YAP("testT2MemError CASE 5")


     //6
     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


    `TB_YAP("testT2MemError CASE 6")
     loopCnt = loopCnt -1 ;

           `TB_YAP($psprintf("testT2MemError  loopCnt %d   ", loopCnt ))
   end

      isEmpty();
    `TB_YAP("testT2MemError END")

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
  begin
    `TB_YAP("testT2MemErrorNoL2Error START")
      reReset();
     cpuReqQueue = new();
     insertL2Error = 0;
    while(loopCnt != 0) begin
     // 1
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
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

    `TB_YAP("testT2MemErrorNoL2Error CASE 1")

     // 2
     t2_mem_error_check = 1;
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
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

    `TB_YAP("testT2MemErrorNoL2Error CASE 2")
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
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

    `TB_YAP("testT2MemErrorNoL2Error CASE 3")
        //5
     t2_mem_error_check = 0;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     t2_mem_error_check = 1;
     errorBitPos = $urandom_range(0,143);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);



     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

    `TB_YAP("testT2MemErrorNoL2Error CASE 4")


     //6
     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,127);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],5'h0};
     sendRead(Addr, 8'h20, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


    `TB_YAP("testT2MemErrorNoL2Error CASE 5")
     loopCnt = loopCnt -1 ;

           `TB_YAP($psprintf("testT2MemErrorNoL2Error  loopCnt %d   ", loopCnt ))
   end

      isEmpty();
    `TB_YAP("testT2MemErrorNoL2Error END")

  end
endtask:testT2MemErrorNoL2Error

task errorOnT1Mem(input reg [ROWADDRBITS-1:0]IndexAdd,input integer errorBitPos);
  reg [104-1:0]t1_mem_data;
  //t1_mem_data[104-1:0] = testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.bank_v0_h0.MEMCORE[IndexAdd];
  //`TB_YAP($psprintf("t1_mem_data  0x%0x ",t1_mem_data[104-1:0]))
  t1_mem_data[104-1:0] = t1_mem_data[104-1:0] ^ 1 << errorBitPos;
  //`TB_YAP($psprintf("t1_mem_data  0x%0x ",t1_mem_data[104-1:0]))
  //testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.bank_v0_h0.MEMCORE[IndexAdd] = t1_mem_data[104-1:0];
  clock(100);
endtask:errorOnT1Mem

task errorOnT2Mem(input reg [ROWADDRBITS-1:0]IndexAdd,input integer errorBitPos);
  reg [144-1:0]t2_mem_data;
  reg [6:0]memAddr;

  memAddr = IndexAdd[ROWADDRBITS-1:0] ;
  //t2_mem_data[144-1:0] = testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr];
  //`TB_YAP($psprintf("t2_mem_data  0x%0x ",t2_mem_data[144-1:0]))
  t2_mem_data[144-1:0] = t2_mem_data[144-1:0] ^ 1 << errorBitPos;
  //`TB_YAP($psprintf("t2_mem_data  0x%0x ",t2_mem_data[144-1:0]))
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

