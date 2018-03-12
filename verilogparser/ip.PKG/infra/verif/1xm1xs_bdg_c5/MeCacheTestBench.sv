`ifndef ME_CACHE_TEST_BENCH
`define ME_CACHE_TEST_BENCH
class MeCacheTestBench #(int NXADDRWIDTH=31, int NXDATAWIDTH=256, int NXIDWIDTH=4, int NXTYPEWIDTH=3, int NXSIZEWIDTH=8, int NXATTRWIDTH=3,int NOMSTP = 1, int NOSLVP = 1,int NUMWAYS = 4, int NUMROWS = 128, int DBGADDRWIDTH = 7,int DBGBADDRWIDTH = 4,int DBGDATAWIDTH = 144,int NUMDBNK = 9,int NUMDROW = 128) extends MeTransactor;

localparam BYTEADDBITS = 5;
localparam BEETADDBITS = 3;
localparam ROWADDRBITS = 4;
localparam TAGADDRBITS = NXADDRWIDTH - ROWADDRBITS - BEETADDBITS - BYTEADDBITS;

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
	reg [NXDATAWIDTH*8-1 :0] memArray[*];
	reg  dirtyArray[*];
	reg  flushArray[*];
	reg [NXADDRWIDTH-1 :0] InvalArray[*];
	reg [NXDATAWIDTH*8-1 :0] nonCacheArray[*];

       reg [63:0]totalReadTrReceived;
       reg [63:0]totalNonPrefetchTrReceived;
       reg [63:0]l2ReadTrReceived;
       bit outOfOrderDis;

       bit outOfOrderRspEn;
       bit randomStallEn;
       bit t1_mem_error_check;
       bit t2_mem_error_check;
       reg l2RrspDataErr;
       reg l2RrspAddErr;
       reg insertL2Error;
       bit forceAckForallReq;
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


       mailbox cpuReqQueue;
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuRdMonArrayQueue[*];
       mailbox l2WrMonQueue;
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2RdAddMonArrayQueue[*];
       mailbox cpuRdMonQueue;
       mailbox l2RdMonQueue;
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) outOfOrdrArrayQueue[*];
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) outOfOrdrQueue[$];
       

  function new (string name);
    begin
     super.new(name);
     //duvChecker = new(name);
     this.name = name;
        `DEBUG($psprintf("Function New   "))

      outOfOrderRspEn = 1;
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
     l2RrspDataErr =0;
     l2RrspAddErr  = 0;
     insertL2Error = 0;
     t1_mem_error_check = 0;
     t2_mem_error_check = 0;
     outOfOrderDis = 0;
     for(i=0; i<NUMDBNK ; i = i+1) begin 
        for(j=0; j<NUMDROW; j = j+1) begin 
            dbgMem[i][j] = 144'h0;
        end
     end
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
      totalReadTrReceived = 0;
      l2ReadTrReceived = 0;
      outOfOrderDis = 0;
      totalNonPrefetchTrReceived = 0;

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
             //`TB_YAP($psprintf(" CACHE_TB_INFO  SIM TIME     				%t ",$time))
             //`TB_YAP($psprintf(" CACHE_TB_INFO  ================================================="))
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
         cpuReadCheck();
         dbgMemCheck();
         cpuCreqMon();
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
    end
 endtask:sendCpuWrReq

 task sendCpuRdReq();
   begin
    integer z;
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
   //memArray[reqAddr[NXADDRWIDTH-1:0]] = wrData[NXDATAWIDTH-1:0];
 end





endtask:fillMemArray

task sendNonCacheRead(input reg [NXADDRWIDTH-1:0] addr,input reg [NXSIZEWIDTH-1:0] size,input reg [3:0]noBeets,input [2:0]beetStart);
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
  reg [NXDATAWIDTH*8-1:0]memData;
begin
     memData[NXDATAWIDTH*8-1:0] = randomDataDesCache(NXDATAWIDTH*8,addr[NXADDRWIDTH-1:0]);
     memData[71:64] = size[NXSIZEWIDTH-1:0];
     memData[83:80] = noBeets[3:0];
     memData[86:84] = beetStart[2:0];
    if(!(nonCacheArray.exists(addr[NXADDRWIDTH-1:0]))) begin
       nonCacheArray[addr[NXADDRWIDTH-1:0]] = memData[NXDATAWIDTH*8-1:0];
    end

    cpuReqT = new();
    cpuReqT.addr = addr; 
    cpuReqT.cattr = 3'h1;
    cpuReqT.reqType = CH_READ;
    cpuReqT.size = size;
    cpuReqT.noBeets =  noBeets;
    cpuReqT.beetStart = beetStart;
    mstTr[0].send(cpuReqT);
end
endtask


task sendRead(input reg [NXADDRWIDTH-1:0] addr,input reg [7:0] size,input reg uch, input reg ack);
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
  begin
    reg [NXADDRWIDTH-1:0] memAddr = (addr >> (BYTEADDBITS+BEETADDBITS)) << (BYTEADDBITS+BEETADDBITS);
    cpuReqT = new();
    `INFO($psprintf("read addr=0x%0x size=%0d uch=%0b ack=%0b", addr, size, uch, ack))
    cpuReqT.addr = addr; 
    cpuReqT.cattr = (ack << 0) | (!uch << 1);
    cpuReqT.reqType = CH_READ;
    cpuReqT.size = size;
    cpuReqT.noBeets =  8;
    cpuReqT.beetStart = 0;
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
    cpuReqT.noBeets =  8;
    cpuReqT.beetStart = 0;
    mstTr[0].send(cpuReqT);
  end
endtask:sendInval

task sendInvalid ();
  reg [2:0]beetStart;
  reg [4:0]startByteInbeet;
  reg [7:0]startByte;
  reg [7:0]stopByte;
  reg [7:0]maxByteSize;
  reg [8:0]byteSize;
  reg [3:0]noBeets;
  reg[4:0]byteAddr;
  reg [ROWADDRBITS-1:0]rowAddr;
  reg [TAGADDRBITS-1:0]tagAddr;
  reg [2:0]tagRandomAddr;
  reg [NXADDRWIDTH-1:0]reqAddr;
  reg [NXADDRWIDTH-1:0]memAddr;
  reg [NXDATAWIDTH*8-1:0]memData;
  reg [5:0]x32b;
  reg w32b;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
  reg [31:0]MinVal,MaxVal;
  begin
    cpuReqT = new();
    rowAddr[ROWADDRBITS-1:0] = 4;   // row in way select
    tagAddr[TAGADDRBITS-1:0] = 'h0;
    tagRandomAddr[2:0] = 'h1;   // way select

    beetStart[2:0] = 3;   // start beet for Cpu req ( out of 8(n-1) beets which beet u we want)
    startByteInbeet[4:0] = 21;
    startByte[7:0] = beetStart[2:0] * 32 + startByteInbeet[4:0];
    MinVal[31:0] = 255;
    MaxVal[31:0] = startByte;
    stopByte[7:0] = $urandom_range(MinVal,MaxVal);
    //stopByte[7:0] = 254;
    maxByteSize[7:0] = (stopByte[7:0]-startByte[7:0]);  // total number of bytes ( 0 to 255)
    byteSize[8:0] =  maxByteSize[7:0] + 1;
    
    x32b[5:0] = 0;
    x32b[5:0] = startByteInbeet[4:0] + byteSize[4:0];
    w32b = |(startByteInbeet[4:0] + byteSize[4:0]);
    noBeets[3:0] = byteSize[8:5] + x32b[5] + w32b;

    `DEBUG($psprintf("TestbenchReq DES_CACHE  beetStart %d   ",  beetStart[2:0]))
    `DEBUG($psprintf("TestbenchReq DES_CACHE  startByteInbeet %d   ",  startByteInbeet[4:0]))
    `DEBUG($psprintf("TestbenchReq DES_CACHE  stopByte %d   ",  stopByte[7:0]))
    `DEBUG($psprintf("TestbenchReq DES_CACHE  startByte %d   ",  startByte[7:0]))
    `DEBUG($psprintf("TestbenchReq DES_CACHE  maxByteSize %d   ",  maxByteSize[7:0]))
    `DEBUG($psprintf("TestbenchReq DES_CACHE  byteSize %d   ",  byteSize[7:0]))
    `DEBUG($psprintf("TestbenchReq DES_CACHE  noBeets %d   ",  noBeets[3:0]))

    reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:3],tagRandomAddr[2:0],rowAddr[ROWADDRBITS-1:0],beetStart[2:0],startByteInbeet[4:0]};
    memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:3],tagRandomAddr[2:0],rowAddr[ROWADDRBITS-1:0],8'h0};
    cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
    cpuReqT.cattr = 'h3;
    cpuReqT.reqType = CH_READ;
    cpuReqT.size = byteSize[7:0];
    cpuReqT.noBeets = noBeets[3:0];
    cpuReqT.beetStart = beetStart[2:0];
   //if(!(memArray.exists(memAddr[NXADDRWIDTH-1:0]))) begin
   //  memData[NXDATAWIDTH*8-1:0] = randomDataDesCache(NXDATAWIDTH*8,reqAddr[NXADDRWIDTH-1:0]);
   //  memArray[memAddr[NXADDRWIDTH-1:0]] = memData[NXDATAWIDTH*8-1:0];
   //  `DEBUG($psprintf("FILL_MEM 0x%x   ",   memArray[memAddr[NXADDRWIDTH-1:0]]))
   //  `DEBUG($psprintf("FILL_MEM ADD 0x%x   ",   memAddr[NXADDRWIDTH-1:0]))
   //end
    mstTr[0].send(cpuReqT);
    `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
  end
endtask:sendInvalid 

task sendRandomDescacheNonCacheRdReq(input integer count,input reg stallDisable,input reg gapBetweenBeetsDisable,input reg outoffOrderRspDisable,input reg randomL2ErrorEn);
  reg [ROWADDRBITS-1:0]rowAddr;
  reg [ROWADDRBITS-1:0]rowAddrArry[5];
  reg [BYTEADDBITS-1:0]byteAddr;
  reg [TAGADDRBITS-1:0] tagAddr;
  reg [2:0]tagRandomAddr;
  reg [NXADDRWIDTH-1:0]reqAddr;
  reg [NXADDRWIDTH-1:0]memAddr;
  reg [NXDATAWIDTH-1:0]wrData;
  reg [1:0]reqType;
  reg [31:0]loopCount = count;
  reg [31:0]loopCount_1 = 1;
  bit byteSizeDone =0;
  reg [BEETADDBITS-1:0]beetStart;
  reg [BYTEADDBITS-1:0]startByteInbeet;
  reg [NXSIZEWIDTH-1:0]startByte;
  reg [NXSIZEWIDTH-1:0]stopByte;
  reg [NXSIZEWIDTH-1:0]maxByteSize;
  reg [8:0]byteSize;
  reg [3:0]noBeets;
  reg [5:0]x32b;
  reg [5:0]w32b;
  bit nonCacheAddr;
  integer i;
  reg [2:0]cattr;
   reg [31:0]MinVal,MaxVal;
   reg [NXDATAWIDTH*8-1:0]memData;
   bit enableL2Error;
  MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
  begin
       if(outoffOrderRspDisable == 1) begin
      	 outOfOrderRspEn = 0;
      	`TB_YAP($psprintf("OutOfOrder RSp Disable %d ",  outOfOrderRspEn ))
       end else if(outoffOrderRspDisable == 0) begin
      	 outOfOrderRspEn = 1;
      	`TB_YAP($psprintf("OutOfOrder RSp Disable %d ",  outOfOrderRspEn ))
       end
   	if(stallDisable == 1) begin
      	   slvTr[0].stallEn = 0;
           `TB_YAP($psprintf("Stall Disable %d ",  slvTr[0].stallEn ))
        end else if(stallDisable == 0) begin
      	   slvTr[0].stallEn = 1;
           `TB_YAP($psprintf("Stall Disable %d ",  slvTr[0].stallEn ))
        end

        if(gapBetweenBeetsDisable == 1) begin
           slvTr[0].gapBetweenBeetsEn = 0;
           `TB_YAP($psprintf("TestbenchReq  slvTr[0].gapBetweenBeetsEn %d  ", slvTr[0].gapBetweenBeetsEn))
        end else if(gapBetweenBeetsDisable == 0) begin
           slvTr[0].gapBetweenBeetsEn = 1;
           `TB_YAP($psprintf("TestbenchReq  slvTr[0].gapBetweenBeetsEn %d  ", slvTr[0].gapBetweenBeetsEn))
      end
      if(randomL2ErrorEn == 1) begin
           insertL2Error = 1;
           `TB_YAP($psprintf("TestbenchReq  insertL2Error %d  ", insertL2Error))
      end else if(randomL2ErrorEn == 0) begin
           insertL2Error = 0;
           `TB_YAP($psprintf("TestbenchReq  insertL2Error %d  ", insertL2Error))
      end


       nonCacheArray.delete;
       while(loopCount[31:0] !=0) begin
           `DEBUG($psprintf("TestbenchReq  loopCount %d  ", loopCount))
             cpuReqT = new();
             rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,3);
             tagAddr[TAGADDRBITS-1:0] = 'h0;
             tagRandomAddr[2:0] = $urandom_range(1,7);   // way select

              beetStart[BEETADDBITS-1:0] = $urandom_range(0,7);   // start beet for Cpu req ( out of 8(n-1) beets which beet u we want)
              startByteInbeet[BYTEADDBITS-1:0] = $urandom_range(0,31);

              startByte[NXSIZEWIDTH-1:0] = beetStart[2:0] * 32 + startByteInbeet[4:0];
              MinVal[31:0] = 255;
              MaxVal[31:0] = startByte;
              stopByte[NXSIZEWIDTH-1:0] = $urandom_range(MinVal,MaxVal);
              maxByteSize[NXSIZEWIDTH-1:0] = (stopByte[NXSIZEWIDTH-1:0]-startByte[NXSIZEWIDTH-1:0]);  // total number of bytes ( 0 to 255)
              byteSize[8:0] =  maxByteSize[NXSIZEWIDTH-1:0] + 1;

              x32b[5:0] = startByteInbeet[BYTEADDBITS-1:0] + byteSize[BYTEADDBITS-1:0];
              w32b = |(startByteInbeet[BYTEADDBITS-1:0] + byteSize[BYTEADDBITS-1:0]);
              noBeets[3:0] = byteSize[8:5] + x32b[5] + w32b;
           `DEBUG($psprintf("TestbenchReq  noBeets  %d byteSize[8:5] %d x32b[5] %d w32b %d", noBeets[3:0],byteSize[8:5],x32b[5],w32b))

               reqAddr[NXADDRWIDTH-1:0] = {2'h1,tagAddr[TAGADDRBITS-1-2:3],tagRandomAddr[2:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
               memAddr[NXADDRWIDTH-1:0] = {2'h1,tagAddr[TAGADDRBITS-1-2:3],tagRandomAddr[2:0],rowAddr[ROWADDRBITS-1:0],8'h0};
               memData[NXDATAWIDTH*8-1:0] = randomDataDesCache(NXDATAWIDTH*8,reqAddr[NXADDRWIDTH-1:0]);
               if(insertL2Error == 1) begin
                  enableL2Error = (($urandom%100) < 50 );
                  {l2RrspDataErr,l2RrspAddErr} = 2'b00;
                  if(enableL2Error == 1'b1) begin
                     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);
                     `DEBUG($psprintf("NonCacheBle Read  L2_ERROR Inserted raatr %x  ", {l2RrspDataErr,l2RrspAddErr}))
                  end 
              end
               memData[NXDATAWIDTH-1:NXDATAWIDTH-2] = {l2RrspDataErr,l2RrspAddErr};
               memData[71:64] = byteSize[NXSIZEWIDTH-1:0];
               memData[83:80] = noBeets[3:0];
               memData[86:84] = beetStart[2:0];
           `DEBUG($psprintf("TestbenchReq  noBeets  %d beetStart %d ", noBeets[3:0],beetStart[2:0]))
              `DEBUG($psprintf("TestbenchReq DES_CACHE  beetStart %d  loopCount %d ",  beetStart[2:0],loopCount))
              `DEBUG($psprintf("TestbenchReq DES_CACHE  startByteInbeet %d  loopCount %d ",  startByteInbeet[4:0],loopCount))
              `DEBUG($psprintf("TestbenchReq DES_CACHE  stopByte %d  loopCount %d ",  stopByte[7:0],loopCount))
              `DEBUG($psprintf("TestbenchReq DES_CACHE  startByte %d  loopCount %d ",  startByte[7:0],loopCount))
              `DEBUG($psprintf("TestbenchReq DES_CACHE  maxByteSize %d  loopCount %d ",  maxByteSize[7:0],loopCount))
              `DEBUG($psprintf("TestbenchReq DES_CACHE  byteSize %d  loopCount %d ",  byteSize[7:0],loopCount))
              `DEBUG($psprintf("TestbenchReq DES_CACHE  noBeets %d  loopCount %d ",  noBeets[3:0],loopCount))
              if(!(nonCacheArray.exists(reqAddr[NXADDRWIDTH-1:0]))) begin
                 nonCacheArray[reqAddr[NXADDRWIDTH-1:0]] = memData[NXDATAWIDTH*8-1:0];
              end

              cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
              cpuReqT.cattr =  3'h1;
              cpuReqT.size = nonCacheArray[reqAddr[NXADDRWIDTH-1:0]][71:64];
              cpuReqT.reqType = CH_READ;
              cpuReqT.noBeets = nonCacheArray[reqAddr[NXADDRWIDTH-1:0]][83:80];
              cpuReqT.beetStart = nonCacheArray[reqAddr[NXADDRWIDTH-1:0]][86:84];
              mstTr[0].send(cpuReqT);
              loopCount = loopCount - 1 ;
          
       end

    clock(1000);
    isEmpty();
  end
endtask :sendRandomDescacheNonCacheRdReq


task sendRandomDesCacheReq(input integer count,input reg stallDisable,input reg gapBetweenBeetsDisable,input reg outoffOrderRspDisable,input reg rowSelectRandomEn,input reg randomL2ErrorEn);
   reg [BYTEADDBITS-1:0]byteAddr;
   reg [ROWADDRBITS-1:0]rowAddr;
   reg [ROWADDRBITS-1:0]rowAddrArry[5];
   reg [TAGADDRBITS-1:0]tagAddr;
   reg [2:0]tagRandomAddr;
   reg [NXADDRWIDTH-1:0]reqAddr;
   reg [NXADDRWIDTH-1:0]memAddr;
   reg [NXDATAWIDTH*8-1:0]memData;
   reg [31:0]loopCount = count;
   bit byteSizeDone =0;
   reg [BEETADDBITS-1:0]beetStart;
   reg [BYTEADDBITS-1:0]startByteInbeet;
   reg [NXSIZEWIDTH-1:0]startByte;
   reg [NXSIZEWIDTH-1:0]stopByte;
   reg [NXSIZEWIDTH-1:0]maxByteSize;
   reg [8:0]byteSize;
   reg [3:0]noBeets;
   reg [5:0]x32b;
   reg [5:0]w32b;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   reg [31:0]MinVal,MaxVal;
   reg nonCacheAddr;
   reg invalCacheAddr;
   reg [31:0]loopCount_1 = 1;
   reg [NXDATAWIDTH-1:0]wrData;
    bit enableL2Error;
   begin
       rowAddrArry[1] = $urandom_range(1,6);
       rowAddrArry[0] = (rowSelectRandomEn == 0) ? rowAddrArry[1] :rowAddrArry[1] - 1;
       rowAddrArry[2] = (rowSelectRandomEn == 0) ? rowAddrArry[1] :rowAddrArry[1] + 1;
       rowAddrArry[3] = (rowSelectRandomEn == 0) ? rowAddrArry[1] :0;
       rowAddrArry[4] = (rowSelectRandomEn == 0) ? rowAddrArry[1] :7;
       for(i=0; i<5; i = i+1) begin
             `TB_YAP($psprintf("TestbenchReq rowAddrArry[%d] = %d  ", i,rowAddrArry[i]))
       end
      if(stallDisable == 1) begin
           slvTr[0].stallEn = 0;
           `TB_YAP($psprintf("TestbenchReq  slvTr[0].stallEn %d  ", slvTr[0].stallEn))
      end else if(stallDisable == 0) begin
           slvTr[0].stallEn = 1;
           `TB_YAP($psprintf("TestbenchReq  slvTr[0].stallEn %d  ", slvTr[0].stallEn))
      end
      if(gapBetweenBeetsDisable == 1) begin
           slvTr[0].gapBetweenBeetsEn = 0;
           `TB_YAP($psprintf("TestbenchReq  slvTr[0].gapBetweenBeetsEn %d  ", slvTr[0].gapBetweenBeetsEn))
      end else if(gapBetweenBeetsDisable == 0) begin
           slvTr[0].gapBetweenBeetsEn = 1;
           `TB_YAP($psprintf("TestbenchReq  slvTr[0].gapBetweenBeetsEn %d  ", slvTr[0].gapBetweenBeetsEn))
      end
      if(outoffOrderRspDisable == 1) begin
           outOfOrderRspEn = 0;
           `TB_YAP($psprintf("TestbenchReq  outOfOrderRspEn %d  ", outOfOrderRspEn))
      end else if(outoffOrderRspDisable == 0) begin
           outOfOrderRspEn = 1;
           `TB_YAP($psprintf("TestbenchReq  outOfOrderRspEn %d  ", outOfOrderRspEn))
      end
      if(randomL2ErrorEn == 1) begin
           insertL2Error = 1;
           `TB_YAP($psprintf("TestbenchReq  insertL2Error %d  ", insertL2Error))
      end else if(randomL2ErrorEn == 0) begin
           insertL2Error = 0;
           `TB_YAP($psprintf("TestbenchReq  insertL2Error %d  ", insertL2Error))
      end
      nonCacheArray.delete;
       //memArray.delete;
      while(loopCount[31:0] !=0) begin


          nonCacheAddr = 0;
          invalCacheAddr = 0;

          if((loopCount_1%10000) <= 5000)  begin
             nonCacheAddr = $urandom_range(0,1);
             //`DEBUG($psprintf("TestbenchReq CACHE_NONCACHE loopCount_1 %d nonCacheAddr %d ", loopCount_1,nonCacheAddr ))
          end

          if((loopCount_1%5000) > 2500)  begin
             invalCacheAddr = $urandom_range(0,1);
             //`DEBUG($psprintf("TestbenchReq CACHE_INVAL loopCount_1 %d invalCacheAddr %d ", loopCount_1,invalCacheAddr ))
          end
          loopCount_1 = loopCount_1 + 1;
          nonCacheAddr = 0;
          if(nonCacheAddr == 1) begin
             cpuReqT = new();
             rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,3);
              MinVal[31:0] = 0;
              MaxVal[31:0] = {TAGADDRBITS{1'b1}};
             tagAddr[TAGADDRBITS-1:0] = $urandom_range(MinVal,MaxVal);
             //tagAddr[TAGADDRBITS-1:0] = 'h0;
             tagRandomAddr[2:0] = $urandom_range(1,7);   // way select

              beetStart[BEETADDBITS-1:0] = $urandom_range(0,7);   // start beet for Cpu req ( out of 8(n-1) beets which beet u we want)
              startByteInbeet[BYTEADDBITS-1:0] = $urandom_range(0,31);

              startByte[NXSIZEWIDTH-1:0] = beetStart[2:0] * 32 + startByteInbeet[4:0];
              MinVal[31:0] = 255;
              MaxVal[31:0] = startByte;
              stopByte[NXSIZEWIDTH-1:0] = $urandom_range(MinVal,MaxVal);
              maxByteSize[NXSIZEWIDTH-1:0] = (stopByte[NXSIZEWIDTH-1:0]-startByte[NXSIZEWIDTH-1:0]);  // total number of bytes ( 0 to 255)
              byteSize[8:0] =  maxByteSize[NXSIZEWIDTH-1:0] + 1;

              x32b[5:0] = startByteInbeet[BYTEADDBITS-1:0] + byteSize[BYTEADDBITS-1:0];
              w32b = |(startByteInbeet[BYTEADDBITS-1:0] + byteSize[BYTEADDBITS-1:0]);
              noBeets[3:0] = byteSize[8:5] + x32b[5] + w32b;

               reqAddr[NXADDRWIDTH-1:0] = {2'h1,tagAddr[TAGADDRBITS-1-2:3],tagRandomAddr[2:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
               memAddr[NXADDRWIDTH-1:0] = {2'h1,tagAddr[TAGADDRBITS-1-2:3],tagRandomAddr[2:0],rowAddr[ROWADDRBITS-1:0],8'h0};
               memData[NXDATAWIDTH*8-1:0] = randomDataDesCache(NXDATAWIDTH*8,reqAddr[NXADDRWIDTH-1:0]);
               if(insertL2Error == 1) begin
                  enableL2Error = (($urandom%100) < 50 );
                  {l2RrspDataErr,l2RrspAddErr} = 2'b00;
                  if(enableL2Error == 1'b1) begin
                     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);
                     //`DEBUG($psprintf("NonCacheBle Read  L2_ERROR Inserted raatr %x  ", {l2RrspDataErr,l2RrspAddErr}))
                  end 
              end

               memData[NXDATAWIDTH-1:NXDATAWIDTH-2] = {l2RrspDataErr,l2RrspAddErr};
               memData[71:64] = byteSize[NXSIZEWIDTH-1:0];
               memData[83:80] = noBeets[3:0];
               memData[86:84] = beetStart[2:0];
              if(!(nonCacheArray.exists(reqAddr[NXADDRWIDTH-1:0]))) begin
                 nonCacheArray[reqAddr[NXADDRWIDTH-1:0]] = memData[NXDATAWIDTH*8-1:0];
              end

              cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
              cpuReqT.cattr =  3'h1;
              cpuReqT.size = nonCacheArray[reqAddr[NXADDRWIDTH-1:0]][71:64];
              cpuReqT.reqType = CH_READ;
              cpuReqT.noBeets = nonCacheArray[reqAddr[NXADDRWIDTH-1:0]][83:80];
              cpuReqT.beetStart = nonCacheArray[reqAddr[NXADDRWIDTH-1:0]][86:84];

          end else if(nonCacheAddr == 0) begin
             cpuReqT = new();
             rowAddr[ROWADDRBITS-1:0] = rowAddrArry[$urandom_range(0,4)];
             tagAddr[TAGADDRBITS-1:0] = 'h0;
             tagRandomAddr[3:0] = $urandom_range(1,15);   // way select

 
              beetStart[BEETADDBITS-1:0] = $urandom_range(0,7);   // start beet for Cpu req ( out of 8(n-1) beets which beet u we want)
              startByteInbeet[BYTEADDBITS-1:0] = $urandom_range(0,31);
              beetStart[BEETADDBITS-1:0] = 0;   // start beet for Cpu req ( out of 8(n-1) beets which beet u we want)
              startByteInbeet[BYTEADDBITS-1:0] = 0;

              startByte[NXSIZEWIDTH-1:0] = beetStart[2:0] * 32 + startByteInbeet[4:0];
              MinVal[31:0] = 255;
              MaxVal[31:0] = startByte;
              stopByte[NXSIZEWIDTH-1:0] = $urandom_range(MinVal,MaxVal);
              maxByteSize[NXSIZEWIDTH-1:0] = (stopByte[NXSIZEWIDTH-1:0]-startByte[NXSIZEWIDTH-1:0]);  // total number of bytes ( 0 to 255)
              byteSize[8:0] =  maxByteSize[NXSIZEWIDTH-1:0] + 1;

              x32b[5:0] = startByteInbeet[BYTEADDBITS-1:0] + byteSize[BYTEADDBITS-1:0];
              w32b = |(startByteInbeet[BYTEADDBITS-1:0] + byteSize[BYTEADDBITS-1:0]);
              noBeets[3:0] = byteSize[8:5] + x32b[5] + w32b;

              //`DEBUG($psprintf("TestbenchReq DES_CACHE  beetStart %d  loopCount %d ",  beetStart[2:0],loopCount))
              //`DEBUG($psprintf("TestbenchReq DES_CACHE  startByteInbeet %d  loopCount %d ",  startByteInbeet[4:0],loopCount))
              //`DEBUG($psprintf("TestbenchReq DES_CACHE  stopByte %d  loopCount %d ",  stopByte[7:0],loopCount))
              //`DEBUG($psprintf("TestbenchReq DES_CACHE  startByte %d  loopCount %d ",  startByte[7:0],loopCount))
              //`DEBUG($psprintf("TestbenchReq DES_CACHE  maxByteSize %d  loopCount %d ",  maxByteSize[7:0],loopCount))
              //`DEBUG($psprintf("TestbenchReq DES_CACHE  byteSize %d  loopCount %d ",  byteSize[7:0],loopCount))
              //`DEBUG($psprintf("TestbenchReq DES_CACHE  noBeets %d  loopCount %d ",  noBeets[3:0],loopCount))

                reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:4],tagRandomAddr[3:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
                memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:4],tagRandomAddr[3:0],rowAddr[ROWADDRBITS-1:0],8'h0};
               // `DEBUG($psprintf("TestbenchReq reqAddr 0x%x  memAddr 0x%x loopCount %d",  reqAddr[NXADDRWIDTH-1:0], memAddr[NXADDRWIDTH-1:0],loopCount))
              cpuReqT.addr = (invalCacheAddr == 1) ? memAddr[NXADDRWIDTH-1:0] : reqAddr[NXADDRWIDTH-1:0];
              cpuReqT.cattr = (invalCacheAddr == 1) ? ((forceAckForallReq == 1'b1) ? 'h3 :'h2 ):'h3;
              cpuReqT.reqType = (invalCacheAddr == 1) ? CH_INVAL :CH_READ;
              cpuReqT.size = (invalCacheAddr == 1) ? 8'h0 : byteSize[NXSIZEWIDTH-1:0];
              cpuReqT.noBeets = (invalCacheAddr == 1) ? 1 : noBeets[3:0];
              cpuReqT.beetStart = (invalCacheAddr == 1) ? 0 : beetStart[2:0];
             //if(!(memArray.exists(memAddr[NXADDRWIDTH-1:0]))) begin
             //   memData[NXDATAWIDTH*8-1:0] = randomDataDesCache(NXDATAWIDTH*8,reqAddr[NXADDRWIDTH-1:0]);
             //   memArray[memAddr[NXADDRWIDTH-1:0]] = memData[NXDATAWIDTH*8-1:0];
             //   if(memArray.exists(memAddr[NXADDRWIDTH-1:0])) begin
             //  //`DEBUG($psprintf("TestbenchReq DES_CACHE  inside Fill Mem with Data 0x%x  loopCount %d ",  memAddr[NXADDRWIDTH-1:0],loopCount))
             //    end
             //end
          end
          mstTr[0].send(cpuReqT);
          loopCount[31:0] = loopCount[31:0] - 1; 
          if((loopCount[31:0]%500) == 1)  begin
           `DEBUG($psprintf("TestbenchReq in RAR loopCount %d ", loopCount))
              RARReq();
              IARReq();
              l2ErroReq();
          end
           //`DEBUG($psprintf("TestbenchReq Send_REQ %s  loopCount %d ",  cpuReqT.creqSprint,loopCount))
           //clock(20); // SREE ADDED
       end
     clock(1000);
     isEmpty();

     

end
endtask:sendRandomDesCacheReq

task RARReq();
   reg[BYTEADDBITS-1:0]byteAddr;
   reg [ROWADDRBITS-1:0]rowAddr;
   reg [TAGADDRBITS-1:0]tagAddr;
   reg [3:0]tagRandomAddr;
   reg [NXADDRWIDTH-1:0]reqAddr;
   reg [BEETADDBITS-1:0]beetStart;
   reg [BYTEADDBITS-1:0]startByteInbeet;
   reg [NXSIZEWIDTH-1:0]startByte;
   reg [NXSIZEWIDTH-1:0]stopByte;
   reg [NXSIZEWIDTH-1:0]maxByteSize;
   reg [8:0]byteSize;
   reg [3:0]noBeets;
   reg [5:0]x32b;
   reg [5:0]w32b;
   reg [4:0] z;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   reg [31:0]MinVal,MaxVal;
   begin
     for(z=0;z<30;z = z+1) begin
         rowAddr[ROWADDRBITS-1:0] =14;
         tagAddr[TAGADDRBITS-1:0] = 'h0;
         if(z[0] == 1) begin
           tagRandomAddr[3:0] = 4;
         end else begin
           tagRandomAddr[3:0] = 5;
         end  
         beetStart[BEETADDBITS-1:0] = $urandom_range(0,7);   
         startByteInbeet[BYTEADDBITS-1:0] = $urandom_range(0,31);

         startByte[NXSIZEWIDTH-1:0] = beetStart[2:0] * 32 + startByteInbeet[4:0];
         MinVal[31:0] = 255;
         MaxVal[31:0] = startByte;
         stopByte[NXSIZEWIDTH-1:0] = $urandom_range(MinVal,MaxVal);
         maxByteSize[NXSIZEWIDTH-1:0] = (stopByte[NXSIZEWIDTH-1:0]-startByte[NXSIZEWIDTH-1:0]);  // total number of bytes ( 0 to 255)
         byteSize[8:0] =  maxByteSize[NXSIZEWIDTH-1:0] + 1;

         x32b[5:0] = startByteInbeet[BYTEADDBITS-1:0] + byteSize[BYTEADDBITS-1:0];
         w32b = |(startByteInbeet[BYTEADDBITS-1:0] + byteSize[BYTEADDBITS-1:0]);
         noBeets[3:0] = byteSize[8:5] + x32b[5] + w32b;

         
         reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:4],tagRandomAddr[3:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
         cpuReqT = new();
         cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
         cpuReqT.cattr = 'h3;
         cpuReqT.reqType = CH_READ;
         cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
         cpuReqT.noBeets = noBeets[3:0];
         cpuReqT.beetStart = beetStart[2:0];
         mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq RARReq Send_REQ %s  ",  cpuReqT.creqSprint))
      end
end
endtask:RARReq

task l2ErroReq();
   reg[BYTEADDBITS-1:0]byteAddr;
   reg [ROWADDRBITS-1:0]rowAddr;
   reg [TAGADDRBITS-1:0]tagAddr;
   reg [4:0]tagRandomAddr;
   reg [NXADDRWIDTH-1:0]reqAddr;
   reg [BEETADDBITS-1:0]beetStart;
   reg [BYTEADDBITS-1:0]startByteInbeet;
   reg [NXSIZEWIDTH-1:0]startByte;
   reg [NXSIZEWIDTH-1:0]stopByte;
   reg [NXSIZEWIDTH-1:0]maxByteSize;
   reg [8:0]byteSize;
   reg [3:0]noBeets;
   reg [5:0]x32b;
   reg [5:0]w32b;
   reg [4:0] z;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   reg [31:0]MinVal,MaxVal;
   tagRandomAddr[4:0] = 0;
   begin
     for(z=0;z<30;z = z+1) begin
         rowAddr[ROWADDRBITS-1:0] =12;
         tagAddr[TAGADDRBITS-1:0] = 53'h12340000;
         beetStart[BEETADDBITS-1:0] = $urandom_range(0,7);   
         startByteInbeet[BYTEADDBITS-1:0] = $urandom_range(0,31);

         startByte[NXSIZEWIDTH-1:0] = beetStart[2:0] * 32 + startByteInbeet[4:0];
         MinVal[31:0] = 255;
         MaxVal[31:0] = startByte;
         stopByte[NXSIZEWIDTH-1:0] = $urandom_range(MinVal,MaxVal);
         maxByteSize[NXSIZEWIDTH-1:0] = (stopByte[NXSIZEWIDTH-1:0]-startByte[NXSIZEWIDTH-1:0]);  // total number of bytes ( 0 to 255)
         byteSize[8:0] =  maxByteSize[NXSIZEWIDTH-1:0] + 1;

         x32b[5:0] = startByteInbeet[BYTEADDBITS-1:0] + byteSize[BYTEADDBITS-1:0];
         w32b = |(startByteInbeet[BYTEADDBITS-1:0] + byteSize[BYTEADDBITS-1:0]);
         noBeets[3:0] = byteSize[8:5] + x32b[5] + w32b;

         
         reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:5],tagRandomAddr[4:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
         cpuReqT = new();
         cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
         cpuReqT.cattr = 'h3;
         cpuReqT.reqType = CH_READ;
         cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
         cpuReqT.noBeets = noBeets[3:0];
         cpuReqT.beetStart = beetStart[2:0];
         mstTr[0].send(cpuReqT);
         if(z[0] == 1) begin
           tagRandomAddr[4:0] = tagRandomAddr[4:0] + 1;
         end  
           `DEBUG($psprintf("TestbenchReq l2ErroReq Send_REQ %s  ",  cpuReqT.creqSprint))
      end
end
endtask:l2ErroReq


task IARReq();
   reg[BYTEADDBITS-1:0]byteAddr;
   reg [ROWADDRBITS-1:0]rowAddr;
   reg [TAGADDRBITS-1:0]tagAddr;
   reg [3:0]tagRandomAddr;
   reg [NXADDRWIDTH-1:0]reqAddr;
   reg [BEETADDBITS-1:0]beetStart;
   reg [BYTEADDBITS-1:0]startByteInbeet;
   reg [NXSIZEWIDTH-1:0]startByte;
   reg [NXSIZEWIDTH-1:0]stopByte;
   reg [NXSIZEWIDTH-1:0]maxByteSize;
   reg [8:0]byteSize;
   reg [3:0]noBeets;
   reg [5:0]x32b;
   reg [5:0]w32b;
   reg [4:0] z;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   reg [31:0]MinVal,MaxVal;
   begin
     for(z=0;z<30;z = z+1) begin
         rowAddr[ROWADDRBITS-1:0] =13;
         tagAddr[TAGADDRBITS-1:0] = 'h0;
         tagRandomAddr[3:0] = 4;
         beetStart[BEETADDBITS-1:0] = $urandom_range(0,7);   
         startByteInbeet[BYTEADDBITS-1:0] = $urandom_range(0,31);

         startByte[NXSIZEWIDTH-1:0] = beetStart[2:0] * 32 + startByteInbeet[4:0];
         MinVal[31:0] = 255;
         MaxVal[31:0] = startByte;
         stopByte[NXSIZEWIDTH-1:0] = $urandom_range(MinVal,MaxVal);
         maxByteSize[NXSIZEWIDTH-1:0] = (stopByte[NXSIZEWIDTH-1:0]-startByte[NXSIZEWIDTH-1:0]);  // total number of bytes ( 0 to 255)
         byteSize[8:0] =  maxByteSize[NXSIZEWIDTH-1:0] + 1;

         x32b[5:0] = startByteInbeet[BYTEADDBITS-1:0] + byteSize[BYTEADDBITS-1:0];
         w32b = |(startByteInbeet[BYTEADDBITS-1:0] + byteSize[BYTEADDBITS-1:0]);
         noBeets[3:0] = byteSize[8:5] + x32b[5] + w32b;

         
         cpuReqT = new();
         if(z[0] == 1) begin
           cpuReqT.reqType = CH_READ;
           cpuReqT.cattr = 'h3;
           cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
           reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:4],tagRandomAddr[3:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
         cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
         end else begin
           cpuReqT.reqType = CH_INVAL;
           cpuReqT.cattr = 'h2;
           cpuReqT.size = 'h0;
           reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:4],tagRandomAddr[3:0],rowAddr[ROWADDRBITS-1:0],8'h0};
           cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
         end  
         cpuReqT.noBeets = noBeets[3:0];
         cpuReqT.beetStart = beetStart[2:0];
         mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq IARReq Send_REQ %s  ",  cpuReqT.creqSprint))
      end
end
endtask:IARReq

task prefetchCacheReq(input integer count);
   reg[BYTEADDBITS-1:0]byteAddr;
   reg [ROWADDRBITS-1:0]rowAddr;
   reg [TAGADDRBITS-1:0]tagAddr;
   reg [2:0]tagRandomAddr;
   reg [NXADDRWIDTH-1:0]reqAddr;
   reg [NXADDRWIDTH-1:0]memAddr;
   reg [NXDATAWIDTH*8-1:0]memData;
   reg [31:0]loopCount = count;
   bit byteSizeDone =0;
   reg [BEETADDBITS-1:0]beetStart;
   reg [BYTEADDBITS-1:0]startByteInbeet;
   reg [NXSIZEWIDTH-1:0]startByte;
   reg [NXSIZEWIDTH-1:0]stopByte;
   reg [NXSIZEWIDTH-1:0]maxByteSize;
   reg [8:0]byteSize;
   reg [3:0]noBeets;
   reg [5:0]x32b;
   reg [5:0]w32b;
   integer i,j;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   reg [31:0]MinVal,MaxVal;
   begin
          nonCacheArray.delete;
        `TB_YAP("Prefetch Test start ")
           rowAddr[ROWADDRBITS-1:0] = $urandom_range(1,4);
           rowAddr[ROWADDRBITS-1:0] = 4;
           rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
      while(loopCount[31:0] !=0) begin
           //rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
           tagAddr[TAGADDRBITS-1:0] = 'h0;
           tagRandomAddr[2:0] = $urandom_range(1,7);   // way select

           beetStart[BEETADDBITS-1:0] = $urandom_range(0,7);   // start beet for Cpu req ( out of 8(n-1) beets which beet u we want)
           startByteInbeet[BYTEADDBITS-1:0] = $urandom_range(0,31);


           reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:3],tagRandomAddr[2:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
           memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:3],tagRandomAddr[2:0],rowAddr[ROWADDRBITS-1:0],8'h0};

         byteSize[NXSIZEWIDTH-1:0] = 1;
         noBeets[3:0] = 1;
         cpuReqT = new();
         cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
         cpuReqT.cattr = 'h2;
         cpuReqT.reqType = CH_READ;
         cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
         cpuReqT.noBeets = noBeets[3:0];
         cpuReqT.beetStart = beetStart[2:0];
        //if(!(memArray.exists(memAddr[NXADDRWIDTH-1:0]))) begin
        //   memData[NXDATAWIDTH*8-1:0] = randomDataDesCache(NXDATAWIDTH*8,reqAddr[NXADDRWIDTH-1:0]);
        //   memArray[memAddr[NXADDRWIDTH-1:0]] = memData[NXDATAWIDTH*8-1:0];
        //   if(memArray.exists(memAddr[NXADDRWIDTH-1:0])) begin
        //  //`DEBUG($psprintf("TestbenchReq DES_CACHE  inside Fill Mem with Data 0x%x  loopCount %d ",  memAddr[NXADDRWIDTH-1:0],loopCount))
        //    end
        //end
          mstTr[0].send(cpuReqT);

      for(i=0; i<8; i = i+1) begin
         beetStart[BEETADDBITS-1:0] = $urandom_range(0,7);   // start beet for Cpu req ( out of 8(n-1) beets which beet u we want)
         startByteInbeet[BYTEADDBITS-1:0] = $urandom_range(0,31);

         startByte[NXSIZEWIDTH-1:0] = beetStart[2:0] * 32 + startByteInbeet[4:0];
         MinVal[31:0] = 255;
         MaxVal[31:0] = startByte;
         stopByte[NXSIZEWIDTH-1:0] = $urandom_range(MinVal,MaxVal);
         maxByteSize[NXSIZEWIDTH-1:0] = (stopByte[NXSIZEWIDTH-1:0]-startByte[NXSIZEWIDTH-1:0]);  // total number of bytes ( 0 to 255)
         byteSize[8:0] =  maxByteSize[NXSIZEWIDTH-1:0] + 1;

         x32b[5:0] = startByteInbeet[BYTEADDBITS-1:0] + byteSize[BYTEADDBITS-1:0];
         w32b = |(startByteInbeet[BYTEADDBITS-1:0] + byteSize[BYTEADDBITS-1:0]);
         noBeets[3:0] = byteSize[8:5] + x32b[5] + w32b;

         // `DEBUG($psprintf("TestbenchReq DES_CACHE  beetStart %d  loopCount %d ",  beetStart[2:0],loopCount))
         // `DEBUG($psprintf("TestbenchReq DES_CACHE  startByteInbeet %d  loopCount %d ",  startByteInbeet[4:0],loopCount))
         // `DEBUG($psprintf("TestbenchReq DES_CACHE  stopByte %d  loopCount %d ",  stopByte[7:0],loopCount))
         // `DEBUG($psprintf("TestbenchReq DES_CACHE  startByte %d  loopCount %d ",  startByte[7:0],loopCount))
         // `DEBUG($psprintf("TestbenchReq DES_CACHE  maxByteSize %d  loopCount %d ",  maxByteSize[7:0],loopCount))
         // `DEBUG($psprintf("TestbenchReq DES_CACHE  byteSize %d  loopCount %d ",  byteSize[7:0],loopCount))
         // `DEBUG($psprintf("TestbenchReq DES_CACHE  noBeets %d  loopCount %d ",  noBeets[3:0],loopCount))

           reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:3],tagRandomAddr[2:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
           memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:3],tagRandomAddr[2:0],rowAddr[ROWADDRBITS-1:0],8'h0};
          // `DEBUG($psprintf("TestbenchReq reqAddr 0x%x  memAddr 0x%x loopCount %d",  reqAddr[NXADDRWIDTH-1:0], memAddr[NXADDRWIDTH-1:0],loopCount))
         cpuReqT = new();
         cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
         cpuReqT.cattr = 'h3;
         cpuReqT.reqType = CH_READ;
         cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
         cpuReqT.noBeets = noBeets[3:0];
         cpuReqT.beetStart = beetStart[2:0];
        //if(!(memArray.exists(memAddr[NXADDRWIDTH-1:0]))) begin
        //   memData[NXDATAWIDTH*8-1:0] = randomDataDesCache(NXDATAWIDTH*8,reqAddr[NXADDRWIDTH-1:0]);
        //   memArray[memAddr[NXADDRWIDTH-1:0]] = memData[NXDATAWIDTH*8-1:0];
        //   if(memArray.exists(memAddr[NXADDRWIDTH-1:0])) begin
        //  //`DEBUG($psprintf("TestbenchReq DES_CACHE  inside Fill Mem with Data 0x%x  loopCount %d ",  memAddr[NXADDRWIDTH-1:0],loopCount))
        //    end
        //end
          mstTr[0].send(cpuReqT);
    end
          loopCount[31:0] = loopCount[31:0] - 1;  
           //`DEBUG($psprintf("TestbenchReq Send_REQ %s  loopCount %d ",  cpuReqT.creqSprint,loopCount))
           //clock(20); // SREE ADDED
       end

     clock(1000);
     isEmpty();
`TB_YAP("prefetch Test End")
end
endtask:prefetchCacheReq




task DesCacheCapacityTest();
   reg[BYTEADDBITS-1:0]byteAddr;
   reg [ROWADDRBITS-1:0]rowAddr;
   reg [TAGADDRBITS-1:0]tagAddr;
   reg [2:0]tagRandomAddr;
   reg [NXADDRWIDTH-1:0]reqAddr;
   reg [NXADDRWIDTH-1:0]memAddr;
   reg [NXDATAWIDTH*8-1:0]memData;
   bit byteSizeDone =0;
   reg [BEETADDBITS-1:0]beetStart;
   reg [BYTEADDBITS-1:0]startByteInbeet;
   reg [NXSIZEWIDTH-1:0]startByte;
   reg [NXSIZEWIDTH-1:0]stopByte;
   reg [NXSIZEWIDTH-1:0]maxByteSize;
   reg [8:0]byteSize;
   reg [3:0]noBeets;
   reg [5:0]x32b;
   reg [5:0]w32b;
   integer i,j;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   begin

            `TB_YAP("DesCacheCapacityTest  START ")

           `TB_YAP($psprintf("Suresh_perm_dbg BYTEADDBITS %d BEETADDBITS %d ROWADDRBITS %d TAGADDRBITS %d  ",BYTEADDBITS,BEETADDBITS,ROWADDRBITS,TAGADDRBITS))
      nonCacheArray.delete;
      for(i=0; i<TAGADDRBITS; i = i+1) begin
           `DEBUG($psprintf("Suresh_perm_dbg i =  %d TAGADDRBITS %d  ",i,TAGADDRBITS))
	  rowAddr[ROWADDRBITS-1:0] = 4;
	  beetStart[BEETADDBITS-1:0] = 0;
	  startByteInbeet[BYTEADDBITS-1:0] = 0;
	  tagAddr[TAGADDRBITS-1:0] = 1 << i;
	  byteSize[8:0] = 9'h0;
	  noBeets[3:0] = 4'h8;

	  reqAddr[NXADDRWIDTH-1:0]  = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
	  memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],8'h0};
          cpuReqT = new();
	  cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
	  cpuReqT.cattr = 'h3;
	  cpuReqT.reqType = CH_READ;
	  cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
	  cpuReqT.noBeets = noBeets[3:0];
	  cpuReqT.beetStart = beetStart[2:0];

	 //if(!(memArray.exists(memAddr[NXADDRWIDTH-1:0]))) begin
	 //   memData[NXDATAWIDTH*8-1:0] = randomDataDesCache(NXDATAWIDTH*8,reqAddr[NXADDRWIDTH-1:0]);
	 //   memArray[memAddr[NXADDRWIDTH-1:0]] = memData[NXDATAWIDTH*8-1:0];
	 //end

	  mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
	  
      end

      for(i=TAGADDRBITS; i>=0; i--) begin
	  rowAddr[ROWADDRBITS-1:0] = 4;
	  beetStart[BEETADDBITS-1:0] = 0;
	  startByteInbeet[BYTEADDBITS-1:0] = 0;
	  tagAddr[TAGADDRBITS-1:0] = 1 << i;
	  byteSize[8:0] = 9'h0;
	  noBeets[3:0] = 4'h8;

	  reqAddr[NXADDRWIDTH-1:0]  = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
	  memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],8'h0};

          cpuReqT = new();
	  cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
	  cpuReqT.cattr = 'h3;
	  cpuReqT.reqType = CH_READ;
	  cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
	  cpuReqT.noBeets = noBeets[3:0];
	  cpuReqT.beetStart = beetStart[2:0];

	 //if(!(memArray.exists(memAddr[NXADDRWIDTH-1:0]))) begin
	 //   memData[NXDATAWIDTH*8-1:0] = randomDataDesCache(NXDATAWIDTH*8,reqAddr[NXADDRWIDTH-1:0]);
	 //   memArray[memAddr[NXADDRWIDTH-1:0]] = memData[NXDATAWIDTH*8-1:0];
	 //end

	  mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
      end

    for(j=0;j<NUMWAYS; j = j+1) begin
      for(i=0; i<NUMROWS; i = i+1) begin
	  rowAddr[ROWADDRBITS-1:0] = i;
	  beetStart[BEETADDBITS-1:0] = 0;
	  startByteInbeet[BYTEADDBITS-1:0] = 0;
	  tagAddr[TAGADDRBITS-1:0] = j;
	  byteSize[8:0] = 9'h0;
	  noBeets[3:0] = 4'h8;

	  reqAddr[NXADDRWIDTH-1:0]  = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
	  memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],8'h0};

          cpuReqT = new();
	  cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
	  cpuReqT.cattr = 'h3;
	  cpuReqT.reqType = CH_READ;
	  cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
	  cpuReqT.noBeets = noBeets[3:0];
	  cpuReqT.beetStart = beetStart[2:0];

	 //if(!(memArray.exists(memAddr[NXADDRWIDTH-1:0]))) begin
	 //   memData[NXDATAWIDTH*8-1:0] = randomDataDesCache(NXDATAWIDTH*8,reqAddr[NXADDRWIDTH-1:0]);
	 //   memArray[memAddr[NXADDRWIDTH-1:0]] = memData[NXDATAWIDTH*8-1:0];
	 //end

	  mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
	  
      end
    end
    for(j=0;j<NUMWAYS; j = j+1) begin
      for(i=0; i<NUMROWS; i = i+1) begin
	  rowAddr[ROWADDRBITS-1:0] = i;
	  beetStart[BEETADDBITS-1:0] = 0;
	  startByteInbeet[BYTEADDBITS-1:0] = 0;
	  tagAddr[TAGADDRBITS-1:0] = j;
	  byteSize[8:0] = 9'h0;
	  noBeets[3:0] = 4'h8;

	  reqAddr[NXADDRWIDTH-1:0]  = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
	  memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],8'h0};

          cpuReqT = new();
	  cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
	  cpuReqT.cattr = 'h3;
	  cpuReqT.reqType = CH_READ;
	  cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
	  cpuReqT.noBeets = noBeets[3:0];
	  cpuReqT.beetStart = beetStart[2:0];

	 //if(!(memArray.exists(memAddr[NXADDRWIDTH-1:0]))) begin
	 //   memData[NXDATAWIDTH*8-1:0] = randomDataDesCache(NXDATAWIDTH*8,reqAddr[NXADDRWIDTH-1:0]);
	 //   memArray[memAddr[NXADDRWIDTH-1:0]] = memData[NXDATAWIDTH*8-1:0];
	 //end

	  mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
	  
      end
    end

        clock(1000);
        isEmpty();

   for(j=0;j<NUMWAYS; j = j+1) begin
      for(i=0; i<NUMROWS; i = i+1) begin
	  rowAddr[ROWADDRBITS-1:0] = i;
	  beetStart[BEETADDBITS-1:0] = 0;
	  startByteInbeet[BYTEADDBITS-1:0] = 0;
	  tagAddr[TAGADDRBITS-1:0] = j;
	  byteSize[8:0] = 9'h0;
	  noBeets[3:0] = 4'h8;

	  reqAddr[NXADDRWIDTH-1:0]  = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
	  memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],8'h0};

          cpuReqT = new();
	  cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
	  cpuReqT.cattr = 'h2;
	  cpuReqT.reqType = CH_INVAL;
	  cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
	  cpuReqT.noBeets = noBeets[3:0];
	  cpuReqT.beetStart = beetStart[2:0];
          //memArray.(memAddr[NXADDRWIDTH-1:0])

	  mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
	  
      end
    end
        clock(1000);
        isEmpty();
          memArray.delete;

     for(j=0;j<NUMWAYS; j = j+1) begin
      for(i=0; i<NUMROWS; i = i+1) begin
	  rowAddr[ROWADDRBITS-1:0] = i;
	  beetStart[BEETADDBITS-1:0] = 0;
	  startByteInbeet[BYTEADDBITS-1:0] = 0;
	  tagAddr[TAGADDRBITS-1:0] = j;
	  byteSize[8:0] = 9'h0;
	  noBeets[3:0] = 4'h8;

	  reqAddr[NXADDRWIDTH-1:0]  = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
	  memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],8'h0};

          cpuReqT = new();
	  cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
	  cpuReqT.cattr = 'h3;
	  cpuReqT.reqType = CH_READ;
	  cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
	  cpuReqT.noBeets = noBeets[3:0];
	  cpuReqT.beetStart = beetStart[2:0];

	 //if(!(memArray.exists(memAddr[NXADDRWIDTH-1:0]))) begin
	 //   memData[NXDATAWIDTH*8-1:0] = randomDataDesCache(NXDATAWIDTH*8,reqAddr[NXADDRWIDTH-1:0]);
	 //   memArray[memAddr[NXADDRWIDTH-1:0]] = memData[NXDATAWIDTH*8-1:0];
	 //end

	  mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
	  
      end
    end
        clock(1000);
        isEmpty();


       `TB_YAP("DesCacheCapacityTest END")
end
endtask:DesCacheCapacityTest

task testforInvalidByIndex();
   reg[BYTEADDBITS-1:0]byteAddr;
   reg [ROWADDRBITS-1:0]rowAddr;
   reg [TAGADDRBITS-1:0]tagAddr;
   reg [2:0]tagRandomAddr;
   reg [NXADDRWIDTH-1:0]reqAddr;
   reg [NXADDRWIDTH-1:0]memAddr;
   reg [NXDATAWIDTH*8-1:0]memData;
   bit byteSizeDone =0;
   reg [BEETADDBITS-1:0]beetStart;
   reg [BYTEADDBITS-1:0]startByteInbeet;
   reg [NXSIZEWIDTH-1:0]startByte;
   reg [NXSIZEWIDTH-1:0]stopByte;
   reg [NXSIZEWIDTH-1:0]maxByteSize;
   reg [8:0]byteSize;
   reg [3:0]noBeets;
   reg [5:0]x32b;
   reg [5:0]w32b;
   integer i,j;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   begin

            `TB_YAP("testforInvalidByIndex  START ")

           `TB_YAP($psprintf("Suresh_perm_dbg BYTEADDBITS %d BEETADDBITS %d ROWADDRBITS %d TAGADDRBITS %d  ",BYTEADDBITS,BEETADDBITS,ROWADDRBITS,TAGADDRBITS))
      nonCacheArray.delete;
    for(j=0;j<NUMWAYS; j = j+1) begin
      for(i=0; i<NUMROWS; i = i+1) begin
	  rowAddr[ROWADDRBITS-1:0] = i;
	  beetStart[BEETADDBITS-1:0] = 0;
	  startByteInbeet[BYTEADDBITS-1:0] = 0;
	  tagAddr[TAGADDRBITS-1:0] = j;
	  byteSize[8:0] = 9'h0;
	  noBeets[3:0] = 4'h8;

	  reqAddr[NXADDRWIDTH-1:0]  = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
	  memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],8'h0};

          cpuReqT = new();
	  cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
	  cpuReqT.cattr = 'h3;
	  cpuReqT.reqType = CH_READ;
	  cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
	  cpuReqT.noBeets = noBeets[3:0];
	  cpuReqT.beetStart = beetStart[2:0];

	  mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
	  
      end
    end
        clock(1000);
        isEmpty();
    for(j=0;j<NUMWAYS; j = j+1) begin
      for(i=0; i<NUMROWS; i = i+1) begin
	  rowAddr[ROWADDRBITS-1:0] = i;
	  beetStart[BEETADDBITS-1:0] = 0;
	  startByteInbeet[BYTEADDBITS-1:0] = 0;
	  tagAddr[TAGADDRBITS-1:0] = 0;
	  byteSize[8:0] = 9'h0;
	  noBeets[3:0] = 4'h8;

	  reqAddr[NXADDRWIDTH-1:0]  = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
	  memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],8'h0};

          cpuReqT = new();
	  cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
	  cpuReqT.cattr = 'h6;
	  cpuReqT.reqType = CH_INVAL;
	  cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
	  cpuReqT.noBeets = noBeets[3:0];
	  cpuReqT.beetStart = beetStart[2:0];


	  mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
        clock(10);
        isEmpty();
	  
      end
      end
        clock(1000);
        isEmpty();

    for(j=0;j<NUMWAYS; j = j+1) begin
      for(i=0; i<NUMROWS; i = i+1) begin
	  rowAddr[ROWADDRBITS-1:0] = i;
	  beetStart[BEETADDBITS-1:0] = 0;
	  startByteInbeet[BYTEADDBITS-1:0] = 0;
	  tagAddr[TAGADDRBITS-1:0] = j;
	  byteSize[8:0] = 9'h0;
	  noBeets[3:0] = 4'h8;

	  reqAddr[NXADDRWIDTH-1:0]  = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
	  memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],8'h0};

          cpuReqT = new();
	  cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
	  cpuReqT.cattr = 'h3;
	  cpuReqT.reqType = CH_READ;
	  cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
	  cpuReqT.noBeets = noBeets[3:0];
	  cpuReqT.beetStart = beetStart[2:0];


	  mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
	  
      end
      end
        clock(1000);
        isEmpty();



      for(i=0; i<NUMROWS; i = i+1) begin
	  rowAddr[ROWADDRBITS-1:0] = i;
	  beetStart[BEETADDBITS-1:0] = 0;
	  startByteInbeet[BYTEADDBITS-1:0] = 0;
	  tagAddr[TAGADDRBITS-1:0] = 0;
	  byteSize[8:0] = 9'h0;
	  noBeets[3:0] = 4'h8;

	  reqAddr[NXADDRWIDTH-1:0]  = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
	  memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],8'h0};

          cpuReqT = new();
	  cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
	  cpuReqT.cattr = 'h6;
	  cpuReqT.reqType = CH_INVAL;
	  cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
	  cpuReqT.noBeets = noBeets[3:0];
	  cpuReqT.beetStart = beetStart[2:0];


	  mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
        clock(10);
        isEmpty();
	  
      end
        clock(10);
        isEmpty();

      for(i=0; i<NUMROWS; i = i+1) begin
	  rowAddr[ROWADDRBITS-1:0] = i;
	  beetStart[BEETADDBITS-1:0] = 0;
	  startByteInbeet[BYTEADDBITS-1:0] = 0;
	  tagAddr[TAGADDRBITS-1:0] = 4;
	  byteSize[8:0] = 9'h0;
	  noBeets[3:0] = 4'h8;

	  reqAddr[NXADDRWIDTH-1:0]  = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
	  memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],8'h0};

          cpuReqT = new();
	  cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
	  cpuReqT.cattr = 'h3;
	  cpuReqT.reqType = CH_READ;
	  cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
	  cpuReqT.noBeets = noBeets[3:0];
	  cpuReqT.beetStart = beetStart[2:0];


	  mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
	  
      end
        clock(10);
        isEmpty();

      for(i=0; i<NUMROWS; i = i+1) begin
	  rowAddr[ROWADDRBITS-1:0] = i;
	  beetStart[BEETADDBITS-1:0] = 0;
	  startByteInbeet[BYTEADDBITS-1:0] = 0;
	  tagAddr[TAGADDRBITS-1:0] = 0;
	  byteSize[8:0] = 9'h0;
	  noBeets[3:0] = 4'h8;

	  reqAddr[NXADDRWIDTH-1:0]  = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
	  memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],8'h0};

          cpuReqT = new();
	  cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
	  cpuReqT.cattr = 'h3;
	  cpuReqT.reqType = CH_READ;
	  cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
	  cpuReqT.noBeets = noBeets[3:0];
	  cpuReqT.beetStart = beetStart[2:0];


	  mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
	  
      end
        clock(10);
        isEmpty();


    for(j=0;j<NUMWAYS; j = j+1) begin
      for(i=0; i<NUMROWS; i = i+1) begin
	  rowAddr[ROWADDRBITS-1:0] = i;
	  beetStart[BEETADDBITS-1:0] = 0;
	  startByteInbeet[BYTEADDBITS-1:0] = 0;
          if(j==0) begin
	     tagAddr[TAGADDRBITS-1:0] = 4;
          end else if(j==1) begin
	     tagAddr[TAGADDRBITS-1:0] = 0;
          end else begin
	     tagAddr[TAGADDRBITS-1:0] = j;

          end
	  byteSize[8:0] = 9'h0;
	  noBeets[3:0] = 4'h8;

	  reqAddr[NXADDRWIDTH-1:0]  = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
	  memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],8'h0};

          cpuReqT = new();
	  cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
	  cpuReqT.cattr = 'h3;
	  cpuReqT.reqType = CH_READ;
	  cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
	  cpuReqT.noBeets = noBeets[3:0];
	  cpuReqT.beetStart = beetStart[2:0];


	  mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
	  
      end
      end

        clock(1000);
        isEmpty();

      for(i=0; i<NUMROWS; i = i+1) begin
	  rowAddr[ROWADDRBITS-1:0] = i;
	  beetStart[BEETADDBITS-1:0] = 0;
	  startByteInbeet[BYTEADDBITS-1:0] = 0;
	  tagAddr[TAGADDRBITS-1:0] = 0;
	  byteSize[8:0] = 9'h0;
	  noBeets[3:0] = 4'h8;

	  reqAddr[NXADDRWIDTH-1:0]  = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
	  memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],8'h0};

          cpuReqT = new();
	  cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
	  cpuReqT.cattr = 'h2;
	  cpuReqT.reqType = CH_INVAL;
	  cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
	  cpuReqT.noBeets = noBeets[3:0];
	  cpuReqT.beetStart = beetStart[2:0];


	  mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
	  
      end
        clock(10);
        isEmpty();

      for(i=0; i<NUMROWS; i = i+1) begin
	  rowAddr[ROWADDRBITS-1:0] = i;
	  beetStart[BEETADDBITS-1:0] = 0;
	  startByteInbeet[BYTEADDBITS-1:0] = 0;
	  tagAddr[TAGADDRBITS-1:0] = 3;
	  byteSize[8:0] = 9'h0;
	  noBeets[3:0] = 4'h8;

	  reqAddr[NXADDRWIDTH-1:0]  = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
	  memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],8'h0};

          cpuReqT = new();
	  cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
	  cpuReqT.cattr = 'h2;
	  cpuReqT.reqType = CH_INVAL;
	  cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
	  cpuReqT.noBeets = noBeets[3:0];
	  cpuReqT.beetStart = beetStart[2:0];


	  mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
	  
      end
        clock(10);
        isEmpty();


      for(i=0; i<NUMROWS; i = i+1) begin
	  rowAddr[ROWADDRBITS-1:0] = i;
	  beetStart[BEETADDBITS-1:0] = 0;
	  startByteInbeet[BYTEADDBITS-1:0] = 0;
	  tagAddr[TAGADDRBITS-1:0] = 0;
	  byteSize[8:0] = 9'h0;
	  noBeets[3:0] = 4'h8;

	  reqAddr[NXADDRWIDTH-1:0]  = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
	  memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],8'h0};

          cpuReqT = new();
	  cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
	  cpuReqT.cattr = 'h6;
	  cpuReqT.reqType = CH_INVAL;
	  cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
	  cpuReqT.noBeets = noBeets[3:0];
	  cpuReqT.beetStart = beetStart[2:0];


	  mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
        clock(10);
        isEmpty();
	  
      end
        clock(10);
        isEmpty();

      

for(j=0;j<NUMWAYS; j = j+1) begin
      for(i=0; i<NUMROWS; i = i+1) begin
	  rowAddr[ROWADDRBITS-1:0] = i;
	  beetStart[BEETADDBITS-1:0] = 0;
	  startByteInbeet[BYTEADDBITS-1:0] = 0;
          if(j== 1)begin
	    tagAddr[TAGADDRBITS-1:0] = 4;
          end else begin
	    tagAddr[TAGADDRBITS-1:0] = j;
          end

	  byteSize[8:0] = 9'h0;
	  noBeets[3:0] = 4'h8;

	  reqAddr[NXADDRWIDTH-1:0]  = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
	  memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],8'h0};

          cpuReqT = new();
	  cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
	  cpuReqT.cattr = 'h3;
	  cpuReqT.reqType = CH_READ;
	  cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
	  cpuReqT.noBeets = noBeets[3:0];
	  cpuReqT.beetStart = beetStart[2:0];


	  mstTr[0].send(cpuReqT);
           `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
	  
      end
      end

    
        clock(1000);
        isEmpty();


       `TB_YAP("testforInvalidByIndex END")
end
endtask:testforInvalidByIndex

task sendRandomReq(input integer count);
endtask :sendRandomReq

task monCpuWrRsp();
     begin
       while(1) begin
        cpuWrRspT = new();
        cpuWrRspT.data[0] = 0;
        mstTr[0].writeRspReceive(cpuWrRspT);
        //`TB_YAP($psprintf("monCpuWrRsp Addr 0x%0x, Data 0x%x",  cpuWrRspT.addr,cpuWrRspT.data))
        `DEBUG($psprintf("monCpuWrRsp rReq %s  ", cpuWrRspT.rreqSprint))
       end
     end
endtask:monCpuWrRsp


task monCpuRdRsp();
       MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuRdMRspT;
       integer i,j;
     begin
       while(1) begin
        cpuRdRspT = new();
        cpuRdRspT.data[0] = 0;
        mstTr[0].readDataReceive(cpuRdRspT);
        //`TB_YAP($psprintf("monCpuRdRsp Addr 0x%0x, Data 0x%x",  cpuRdRspT.addr,cpuRdRspT.data))
        `DEBUG($psprintf("monCpuRdRsp cReq %s  ", cpuRdRspT.creqSprint))
        `DEBUG($psprintf("monCpuRdRsp rReq %s  ", cpuRdRspT.rreqSprint))
         totalReadTrReceived[63:0] = totalReadTrReceived[63:0] + 1;
         if(cpuRdRspT.cattr[0] == CH_REQ_ACK)  begin
            totalNonPrefetchTrReceived[63:0] = totalNonPrefetchTrReceived[63:0] + 1;
         end
         cpuRdMRspT = new cpuRdRspT;
         for(j=0; j<8; j = j+1)
            cpuRdMRspT.data[j] = 'h0;
         j = cpuRdMRspT.beetStart;
         for(i=0; i<cpuRdMRspT.noBeets; i = i+1) begin
             cpuRdMRspT.data[j] = cpuRdRspT.data[i];
             `DEBUG($psprintf("monCpuWrRsp SURESH cpuRdMRspT.data[%d]cReq 0x%x  ", j,cpuRdMRspT.data[j]))
              j = j+1;
         end
         `DEBUG($psprintf("monCpuWrRsp SURESH cReq %s  ", cpuRdRspT.creqSprint))
         cpuRdMonQueue.put(cpuRdMRspT);
       end
     end
endtask:monCpuRdRsp



task monl2WrReq();
    begin
       while(1) begin
        l2WrMonT = new();
        l2WrMonT.data[0] = 0;
        slvTr[0].wrReceive(l2WrMonT);
        //`TB_YAP($psprintf("monl2WrReq Addr 0x%0x, Data 0x%x",  l2WrMonT.addr,l2WrMonT.data))
        `DEBUG($psprintf("monl2WrReq cReq %s  ", l2WrMonT.creqSprint))
        `DEBUG($psprintf("monl2WrReq dReq %s  ", l2WrMonT.dreqSprint))
         if(l2WrMonT.cattr[0] == 1) begin
           l2WrMonT.rattr = 'h1;
           l2WrMonT.rId = l2WrMonT.cId;
           l2WrMonT.data[0] = 0;
           `DEBUG($psprintf("monl2WrReq rReq %s  ", l2WrMonT.rreqSprint))
           slvTr[0].send(l2WrMonT);
        end
       end
     end
endtask:monl2WrReq

task monl2RdAddReq();
    integer i;
    reg [NXDATAWIDTH*8-1:0]memData;
    reg [NXADDRWIDTH-1:0]rdAddr;
    reg [NXADDRWIDTH-1:0]memAddr;
    reg [NXATTRWIDTH-1:0]rdCattr;
    bit enableL2Error;
    bit pushFBSel;
    begin
       while(1) begin
        l2RdAMonT = new();
        l2RdAMonT.data[0] = 0;
        slvTr[0].rdAddReceive(l2RdAMonT);
        `DEBUG($psprintf("monl2RdAddReq cReq %s  ", l2RdAMonT.creqSprint))
        l2ReadTrReceived[63:0] = l2ReadTrReceived[63:0] + 1;
       if((l2ReadTrReceived[63:0] % 10000) <5000) begin
           outOfOrderDis = 0;
       end else begin
           outOfOrderDis = 1;
       end
        l2RdAMonT.data[0] = l2RdAMonT.addr;
        rdAddr[NXADDRWIDTH-1:0] = l2RdAMonT.addr;
        memAddr[NXADDRWIDTH-1:0] = {rdAddr[48:8],8'h0};
        rdCattr[NXATTRWIDTH-1:0] = l2RdAMonT.cattr;
        if(l2RdAMonT.cattr == 3'h3) begin
            memAddr[NXADDRWIDTH-1:0] = l2RdAMonT.addr;
            memArray.delete(memAddr[NXADDRWIDTH-1:0]);
            memData[NXDATAWIDTH*8-1:0] = randomDataDesCache(NXDATAWIDTH*8,memAddr[NXADDRWIDTH-1:0]);
            l2RdAMonT.noBeets = 8;
            enableL2Error = 0;
            if(insertL2Error == 1) begin
              enableL2Error = (($urandom%100) < 25 );
              {l2RrspDataErr,l2RrspAddErr} = 2'b00;
              if(enableL2Error == 1'b1)begin
                 {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);
                 l2RdAMonT.noBeets = $urandom_range(1,8);
                 `DEBUG($psprintf("monl2RdAddReq L2_ERROR Inserted raatr %x Beets %d  ", {l2RrspDataErr,l2RrspAddErr},l2RdAMonT.noBeets))
              end 
            end
              memData[NXDATAWIDTH-1:NXDATAWIDTH-2] = {l2RrspDataErr,l2RrspAddErr};
            `DEBUG($psprintf("L2_MEMADDR[NXADDRWIDTH-1:0] 0x%x  ", memAddr[NXADDRWIDTH-1:0] )) 
              memArray[memAddr[NXADDRWIDTH-1:0]] = memData[NXDATAWIDTH*8-1:0];
            if(!(memArray.exists(l2RdAMonT.addr))) begin
              `ERROR($psprintf("monl2RdAddReq cReq %s  ", l2RdAMonT.creqSprint)) end
            l2RdAMonT.rattr = {memData[NXDATAWIDTH-1:NXDATAWIDTH-2],1'b1} ;
            l2RdAMonT.beetStart = 0;
            for(i=0; i<8; i = i+1)
               l2RdAMonT.data[i] = memData[NXDATAWIDTH*8-1:0] >> i * NXDATAWIDTH;
            memArray[memAddr[NXADDRWIDTH-1:0]] = (enableL2Error == 1'b1) ? {{NXDATAWIDTH*7{1'b0}},memData[NXDATAWIDTH-1:0]}:memData[NXDATAWIDTH*8-1:0];
        end else begin
             if(!(nonCacheArray.exists(l2RdAMonT.addr))) begin
               `ERROR($psprintf("monl2RdAddReq cReq %s  ", l2RdAMonT.creqSprint)) end
             memData[NXDATAWIDTH*8-1:0]=  nonCacheArray[l2RdAMonT.addr];
             for(i=0; i<8; i = i+1)begin
               l2RdAMonT.data[i] = memData[NXDATAWIDTH*8-1:0] >> i * NXDATAWIDTH;end
                  `DEBUG($psprintf("monl2RdAddReq Non CacheRd Req Recives %s  ", l2RdAMonT.creqSprint))

             l2RdAMonT.rattr = {memData[NXDATAWIDTH-1:NXDATAWIDTH-2],1'b1} ;
             l2RdAMonT.beetStart = l2RdAMonT.data[0][86:84];
             l2RdAMonT.noBeets = (l2RdAMonT.rattr[2:1] != 0) ? $urandom_range(1,l2RdAMonT.data[0][83:80]) : l2RdAMonT.data[0][83:80];
        end
        l2RdAMonT.rId = l2RdAMonT.cId ;

        if(l2RdAMonT.cattr[1] == CH_REQ_NOCACHE) begin
           if((l2RdAMonT.addr == l2RdAMonT.data[0][NXADDRWIDTH-1:0]) && (l2RdAMonT.size == l2RdAMonT.data[0][71:64])) begin
                  `DEBUG($psprintf("monl2RdAddReq Non CacheRd Req Addr and Size match with expected cReq %s  ", l2RdAMonT.creqSprint))
           end else begin
                  `ERROR($psprintf("monl2RdAddReq Non CacheRd Req Addr and Size Not match with expected cReq %s  ", l2RdAMonT.creqSprint))
           end

        end

        if (outOfOrderRspEn == 1) begin // code for out of order
          pushFBSel = (outOfOrderDis == 1) ? 0 : $urandom_range(0,1);
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
    MaxVal[31:0] = 8;
    while(1) begin
       while(outOfOrdrQueue.size() == 0 ) begin
          clock(1);
       end

       k = (outOfOrderDis == 1) ? 2 : $urandom_range(MinVal,MaxVal);
       l = 0; 
       while((outOfOrdrQueue.size() < k) && (l < 100)) begin
       `DEBUG($psprintf("sendL2RdRsp k  %d , size %d l %d time %t ",k,outOfOrdrQueue.size(),l,$time))
          clock(1);
          l = l+1;
       end
       n = outOfOrdrQueue.size();
       `DEBUG($psprintf("sendL2RdRsp outOfOrdrQueue Size  %d  ",n))
       for(m=0; m<n; m = m+1) begin
          popFBSel = (outOfOrderDis == 1) ? 1 : $urandom_range(0,1);
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


 

  task finish();
    int m,n;
    begin
      isEmpty();
       clock(1000);
        `TB_YAP($psprintf("CACHE_TB STATS TOTAL CPU READ SEND     		%d",mstTr[0].totalTransactions[63:0]))
        `TB_YAP($psprintf("CACHE_TB STATS TOTAL CPU NON PREFETCH READ SEND  	%d",mstTr[0].totalNonPrefetch[63:0]))
        `TB_YAP($psprintf("CACHE_TB STATS TOTAL CPU PREFETCH READ SEND  	%d",mstTr[0].totalPrefetch[63:0]))
        `TB_YAP($psprintf("CACHE_TB STATS TOTAL CPU INVAL SEND                  %d",mstTr[0].totalInvalidTr[63:0]))
        `TB_YAP($psprintf("CACHE_TB STATS TOTAL CPU READ RECEIVED 		%d",totalReadTrReceived[63:0]))
        `TB_YAP($psprintf("CACHE_TB STATS TOTAL CPU NON PREFETCH READ RECEIVED 	%d",totalNonPrefetchTrReceived[63:0]))
        `TB_YAP($psprintf("=============TEST_PASS============"))

      // TBD SURESH WHY IS FINISH NOT BEING CALLED HERE
      // ??????????????????????????????????????????????????????????????????????:!
      //

    end
  endtask:finish





function [NXDATAWIDTH*8-1:0] randomDataDesCache(input integer width,input [NXADDRWIDTH-1:0]addr); 
integer m; 
    randomDataDesCache = 0; 
    for (m = width/32; m >= 0; m--) 
      randomDataDesCache = (randomDataDesCache << 32) + $urandom; 

     //randomData[NXDATAWIDTH-1:0] = 'h0;
     randomDataDesCache[NXADDRWIDTH-1:0] = addr[NXADDRWIDTH-1:0];
endfunction

function [NXDATAWIDTH-1:0] randomData(input integer width,input [NXADDRWIDTH-1:0]addr); 
integer m; 
    randomData = 0; 
    for (m = width/32; m >= 0; m--) 
      randomData = (randomData << 32) + $urandom; 

     //randomData[NXDATAWIDTH-1:0] = 'h0;
     randomData[NXADDRWIDTH-1:0] = addr;
endfunction

function [NXDATAWIDTH-1:0] randomMemData(input integer width); 
integer m; 
    randomMemData = 0; 
    for (m = width/32; m >= 0; m--) 
      randomMemData = (randomMemData << 32) + $urandom + 32'h12345678;
endfunction



   task cpuReadCheck;
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuRdRspTr;
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuRdReqTr;
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) IARTr;
        reg [NXADDRWIDTH-1:0]memAddr;
        reg [NXDATAWIDTH-1:0]memData;
        reg [2:0]beetStart;
        reg [3:0]noBeets;
        reg [NXATTRWIDTH-1:0]rattr;
        integer a,b,i;
        integer queueSize;
        bit RARFound;
        bit IARFound;
       bit l2ErrorFound;

   while(1) begin
      cpuRdMonQueue.get(cpuRdRspTr);
      if(cpuRdRspTr.cattr[1] == CH_REQ_CACHE)  begin
          memAddr[NXADDRWIDTH-1:0] = cpuRdRspTr.addr;
          beetStart[2:0] = cpuRdRspTr.beetStart;
          noBeets[3:0] = cpuRdRspTr.noBeets;
          memAddr[7:0] = 'h0;
          RARFound = 1'h0;
          IARFound = 1'h0;
          l2ErrorFound = 1'b0;
          rattr[NXATTRWIDTH-1:0] = cpuRdRspTr.rattr;
          `DEBUG($psprintf("cpuReadCheck cpuRdRspTr %s  ", cpuRdRspTr.creqSprint))
           b =  beetStart[2:0];
          `DEBUG($psprintf("cpuReadCheck t1_mem_error_check %d t2_mem_error_check %d  ", t1_mem_error_check,t2_mem_error_check))
           if(t1_mem_error_check == 1'b1) begin
              if(rattr[NXATTRWIDTH-1:0] != 3'h1) begin
          	  `DEBUG($psprintf(" cpuReadCheck Data Error  Set %x  for t1 mem error test ", rattr[NXATTRWIDTH-1:0]))
              end else begin
          	  `ERROR($psprintf(" cpuReadCheck Data Error Not Set %x for t1 mem error test  ", rattr[NXATTRWIDTH-1:0]))
              end
           end else if(t2_mem_error_check == 1'b1) begin
              if(rattr[NXATTRWIDTH-1:0] != 3'h1) begin
          	  `DEBUG($psprintf(" cpuReadCheck Data Error  Set %x for t2 mem error test ", rattr[NXATTRWIDTH-1:0]))
              end else begin
          	  `ERROR($psprintf(" cpuReadCheck Data Error Not Set %x for t2 mem error test  ", rattr[NXATTRWIDTH-1:0]))
              end
              /*for(a=0; a<cpuRdRspTr.noBeetsRsv-1; a = a+1) begin
          	    memData[NXDATAWIDTH-1:0] = memArray[memAddr[NXADDRWIDTH-1:0]] >> b * NXDATAWIDTH; 
          	    if(cpuRdRspTr.data[b] != memData[NXDATAWIDTH-1:0]) begin
          	        `TB_YAP($psprintf(" cpuReadCheck CPU_READ_DATA 0x%x  ", cpuRdRspTr.data[b]))
          	        `TB_YAP($psprintf(" cpuReadCheck MEM_READ_DATA 0x%x  ", memData[NXDATAWIDTH-1:0]))
          	        `TB_YAP($psprintf(" cpuReadCheck MEM_ARRAY 0x%x  ", memArray[memAddr[NXADDRWIDTH-1:0]]))
          	        `TB_YAP($psprintf(" cpuReadCheck MEM_ARRAY ADD  0x%x  ", memAddr[NXADDRWIDTH-1:0]))
          	        `TB_YAP($psprintf(" cpuReadCheck beetStart %d, noBeets %d  loop %d ", beetStart[2:0],noBeets[3:0],a))
          	        `TB_YAP($psprintf(" cpuReadCheck DATA MISMATCH"))
          	        `ERROR($psprintf(" =========================="))
          	    end else begin
          	        `DEBUG($psprintf(" cpuReadCheck CPU_READ_DATA 0x%x  ", cpuRdRspTr.data[b]))
          	        `DEBUG($psprintf(" cpuReadCheck MEM_READ_DATA 0x%x  ", memData[NXDATAWIDTH-1:0]))
          	        //`DEBUG($psprintf(" cpuReadCheck MEM_ARRAY 0x%x  ", memArray[memAddr[NXADDRWIDTH-1:0]]))
          	        //`DEBUG($psprintf(" cpuReadCheck MEM_ARRAY ADD  0x%x  ", memAddr[NXADDRWIDTH-1:0]))
          	        `DEBUG($psprintf(" cpuReadCheck beetStart %d, noBeets %d  loop %d ", beetStart[2:0],noBeets[3:0],a))
          	        `DEBUG($psprintf(" cpuReadCheck DATA MATCH"))
          	        `DEBUG($psprintf(" =========================="))
          	    end
          	    b = b+1;
              end*/
          	`INFO($psprintf(" CPU_CHECK CACHE_READ_PASS Req %s  When T2 Mem Error Inserted ", cpuRdRspTr.creqSprint))
           end else if(rattr[NXATTRWIDTH-1:0] != 3'h1) begin
              if(rattr[NXATTRWIDTH-1:NXATTRWIDTH-2] == memArray[memAddr[NXADDRWIDTH-1:0]][NXDATAWIDTH-1 : NXDATAWIDTH-2]) begin
                   memArray.delete(memAddr[NXADDRWIDTH-1:0]);
                   l2ErrorFound = 1'b1;
          	  `DEBUG($psprintf(" cpuReadCheck cpu cache raat bits are MATCH with L2 raat %x ", rattr[NXATTRWIDTH-1:0]))
              end else begin
          	  `ERROR($psprintf(" cpuReadCheck cpu cache raat bits are NOT_MATCH with L2 raat. CPU_RATTR %x L2_RAATR %x ", rattr[NXATTRWIDTH-1:0],memArray[memAddr[NXADDRWIDTH-1:0]][NXDATAWIDTH-1 : NXDATAWIDTH-2]))
              end
           end else begin
          	for(a=0; a<noBeets; a = a+1) begin
          	    memData[NXDATAWIDTH-1:0] = memArray[memAddr[NXADDRWIDTH-1:0]] >> b * NXDATAWIDTH; 
          	    if(cpuRdRspTr.data[b] != memData[NXDATAWIDTH-1:0]) begin
          	        `TB_YAP($psprintf(" cpuReadCheck CPU_READ_DATA 0x%x  ", cpuRdRspTr.data[b]))
          	        `TB_YAP($psprintf(" cpuReadCheck MEM_READ_DATA 0x%x  ", memData[NXDATAWIDTH-1:0]))
          	        `TB_YAP($psprintf(" cpuReadCheck MEM_ARRAY 0x%x  ", memArray[memAddr[NXADDRWIDTH-1:0]]))
          	        `TB_YAP($psprintf(" cpuReadCheck MEM_ARRAY ADD  0x%x  ", memAddr[NXADDRWIDTH-1:0]))
          	        `TB_YAP($psprintf(" cpuReadCheck beetStart %d, noBeets %d  loop %d ", beetStart[2:0],noBeets[3:0],a))
          	        `TB_YAP($psprintf(" cpuReadCheck DATA MISMATCH"))
          	        `ERROR($psprintf(" =========================="))
          	    end else begin
          	        `DEBUG($psprintf(" cpuReadCheck CPU_READ_DATA 0x%x  ", cpuRdRspTr.data[b]))
          	        `DEBUG($psprintf(" cpuReadCheck MEM_READ_DATA 0x%x  ", memData[NXDATAWIDTH-1:0]))
          	        //`DEBUG($psprintf(" cpuReadCheck MEM_ARRAY 0x%x  ", memArray[memAddr[NXADDRWIDTH-1:0]]))
          	        //`DEBUG($psprintf(" cpuReadCheck MEM_ARRAY ADD  0x%x  ", memAddr[NXADDRWIDTH-1:0]))
          	        `DEBUG($psprintf(" cpuReadCheck beetStart %d, noBeets %d  loop %d ", beetStart[2:0],noBeets[3:0],a))
          	        `DEBUG($psprintf(" cpuReadCheck DATA MATCH"))
          	        `DEBUG($psprintf(" =========================="))
          	    end
          	    b = b+1;
          	end
          	`INFO($psprintf(" CPU_CHECK CACHE_READ_PASS Req %s  ", cpuRdRspTr.creqSprint))
                 begin
                    queueSize = cpuReqQueue.num();
                    for(i=0;i<queueSize; i = i+1) begin
                       cpuReqQueue.get(cpuRdReqTr);
                       if(((cpuRdRspTr.addr >> 8) == (cpuRdReqTr.addr >> 8)) && (cpuRdReqTr.reqType == CH_READ) && (IARFound == 1'b0) && (cpuRdReqTr.transactionTime > cpuRdRspTr.transactionTime)) begin
                            RARFound = 1'h1;
                       end
                       if(((cpuRdRspTr.addr >> 8) == (cpuRdReqTr.addr >> 8)) && (cpuRdReqTr.reqType == CH_INVAL)&& (cpuRdReqTr.transactionTime > cpuRdRspTr.transactionTime) && (RARFound == 1'h0)) begin
                            IARFound = 1'h1;
                            IARTr = new cpuRdReqTr;
                       end
                       if(((cpuRdRspTr.addr >> 8) == (cpuRdReqTr.addr >> 8)) && (cpuRdReqTr.transactionTime <= cpuRdRspTr.transactionTime)) begin
          	          `DEBUG($psprintf(" cpuReadCheck Removeing Tr From cpuReqQueue creq  %s  ", cpuRdReqTr.creqSprint))
                       end else begin
                          cpuReqQueue.put(cpuRdReqTr);
                       end
                    end
                    `DEBUG($psprintf(" DEBUG_READ. IARFound %d  RARFound %d   ",  IARFound,RARFound))
                    if((IARFound == 1) && (RARFound == 0) && (l2ErrorFound == 0)) begin
                         if(memArray.exists(memAddr[NXADDRWIDTH-1:0]))  begin
                            `DEBUG($psprintf(" DEBUG_READ. RM_MEM  %t  ",  IARTr.transactionTime))
                            `DEBUG($psprintf(" DEBUG_READ. RM_MEM After Read, Inval found. Removeing all Mem's. @ %t req %s  ", $time, cpuRdRspTr.creqSprint))
                             memArray.delete(memAddr[NXADDRWIDTH-1:0]);
                             if(memArray.exists(memAddr[NXADDRWIDTH-1:0]))  begin
                               `ERROR($psprintf(" DEBUG_READ. RM_MEM  MEM not deleted Addr 0x%x", memAddr[NXADDRWIDTH-1:0] ))
                             end
                         end else begin
                               `ERROR($psprintf(" DEBUG_READ. RM_MEM  MEM not exists Addr 0x%x", memAddr[NXADDRWIDTH-1:0] ))
                         end
                    end
                 end
             
           end
      end else begin
          memAddr[NXADDRWIDTH-1:0] = cpuRdRspTr.addr;
          beetStart[2:0] = cpuRdRspTr.beetStart;
          noBeets[3:0] = cpuRdRspTr.noBeets;
          rattr[NXATTRWIDTH-1:0] = cpuRdRspTr.rattr;
          `DEBUG($psprintf("cpuReadCheck cpuRdRspTr %s  ", cpuRdRspTr.creqSprint))
           b =  beetStart[2:0];
           if(rattr[NXATTRWIDTH-1:0] != 3'h1)begin
              if(rattr[NXATTRWIDTH-1:NXATTRWIDTH-2] == nonCacheArray[memAddr[NXADDRWIDTH-1:0]][NXDATAWIDTH-1 : NXDATAWIDTH-2]) begin
          	  `DEBUG($psprintf(" cpuReadCheck cpu Non Cache raat bits are MATCH with L2 raat %x ", rattr[NXATTRWIDTH-1:0]))
              end else begin
          	  `ERROR($psprintf(" cpuReadCheck cpu Non Cache raat bits are NOT_MATCH with L2 raat. CPU_RATTR %x L2_RAATR %x ", rattr[NXATTRWIDTH-1:0],nonCacheArray[memAddr[NXADDRWIDTH-1:0]][NXDATAWIDTH-1 : NXDATAWIDTH-2]))
              end
              for(a=0; a< cpuRdRspTr.noBeetsRsv; a = a+1) begin
                  memData[NXDATAWIDTH-1:0] = nonCacheArray[memAddr[NXADDRWIDTH-1:0]] >> b * NXDATAWIDTH; 
                  if(cpuRdRspTr.data[b] != memData[NXDATAWIDTH-1:0]) begin
                      `TB_YAP($psprintf(" cpuReadCheck CPU_READ_DATA 0x%x  ", cpuRdRspTr.data[b]))
                      `TB_YAP($psprintf(" cpuReadCheck MEM_READ_DATA 0x%x  ", memData[NXDATAWIDTH-1:0]))
                      `TB_YAP($psprintf(" cpuReadCheck MEM_ARRAY 0x%x  ", nonCacheArray[memAddr[NXADDRWIDTH-1:0]]))
                      `TB_YAP($psprintf(" cpuReadCheck MEM_ARRAY ADD  0x%x  ", memAddr[NXADDRWIDTH-1:0]))
                      `TB_YAP($psprintf(" cpuReadCheck beetStart %d, noBeets %d  loop %d ", beetStart[2:0],noBeets[3:0],a))
                      `TB_YAP($psprintf(" cpuReadCheck NON CACHE ERROR RSP DATA MISMATCH"))
                      `ERROR($psprintf(" =========================="))
                  end else begin
                      `DEBUG($psprintf(" cpuReadCheck CPU_READ_DATA 0x%x  ", cpuRdRspTr.data[b]))
                      `DEBUG($psprintf(" cpuReadCheck MEM_READ_DATA 0x%x  ", memData[NXDATAWIDTH-1:0]))
                      `DEBUG($psprintf(" cpuReadCheck beetStart %d, noBeets %d  loop %d ", beetStart[2:0],noBeets[3:0],a))
                      `DEBUG($psprintf(" cpuReadCheck NON CACHE ERROR RSP DATA MATCH"))
                      `DEBUG($psprintf(" =========================="))
                  end
                  b = b+1;
              end
           `INFO($psprintf(" CPU_CHECK NON_CACHE_READ_PASS Req %s  ", cpuRdRspTr.creqSprint))
           end else begin
              for(a=0; a<noBeets; a = a+1) begin
                  memData[NXDATAWIDTH-1:0] = nonCacheArray[memAddr[NXADDRWIDTH-1:0]] >> b * NXDATAWIDTH; 
                  if(cpuRdRspTr.data[b] != memData[NXDATAWIDTH-1:0]) begin
                      `TB_YAP($psprintf(" cpuReadCheck CPU_READ_DATA 0x%x  ", cpuRdRspTr.data[b]))
                      `TB_YAP($psprintf(" cpuReadCheck MEM_READ_DATA 0x%x  ", memData[NXDATAWIDTH-1:0]))
                      `TB_YAP($psprintf(" cpuReadCheck MEM_ARRAY 0x%x  ", nonCacheArray[memAddr[NXADDRWIDTH-1:0]]))
                      `TB_YAP($psprintf(" cpuReadCheck MEM_ARRAY ADD  0x%x  ", memAddr[NXADDRWIDTH-1:0]))
                      `TB_YAP($psprintf(" cpuReadCheck beetStart %d, noBeets %d  loop %d ", beetStart[2:0],noBeets[3:0],a))
                      `TB_YAP($psprintf(" cpuReadCheck NON CACHE DATA MISMATCH"))
                      `ERROR($psprintf(" =========================="))
                  end else begin
                      `DEBUG($psprintf(" cpuReadCheck CPU_READ_DATA 0x%x  ", cpuRdRspTr.data[b]))
                      `DEBUG($psprintf(" cpuReadCheck MEM_READ_DATA 0x%x  ", memData[NXDATAWIDTH-1:0]))
                      `DEBUG($psprintf(" cpuReadCheck beetStart %d, noBeets %d  loop %d ", beetStart[2:0],noBeets[3:0],a))
                      `DEBUG($psprintf(" cpuReadCheck NON CACHE DATA MATCH"))
                      `DEBUG($psprintf(" =========================="))
                  end
                  b = b+1;
               end
              `INFO($psprintf(" CPU_CHECK NON_CACHE_READ_PASS Req %s  ", cpuRdRspTr.creqSprint))
           end

        end

     end
   endtask

task isEmpty();
    bit isEmptyMstIdArry;
    begin
       isEmptyMstIdArry = 0;
       while(isEmptyMstIdArry == 0) begin
          clock(1000);
          isEmptyMstIdArry = mstTr[0].isEmptyidArray() && isEmptyCpuRdMonQueueMailBox()  &&  mstTr[0].isEmptyReqQueueMailBox();
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

function isEmptyCpuRdMonQueueMailBox;
reg isEmptyMailBox; 
integer reqQueueCount;
begin
      isEmptyMailBox = 0;
          reqQueueCount =cpuRdMonQueue.num() ;
          if(reqQueueCount !=0 ) begin
               isEmptyMailBox = 0;
          end else begin
               isEmptyMailBox = 1;
          end
          `INFO($psprintf("cpuRdMonQueue  Count %d  isEmptyMailBox %d ",reqQueueCount,isEmptyMailBox))
      isEmptyCpuRdMonQueueMailBox = isEmptyMailBox;
end 
endfunction:isEmptyCpuRdMonQueueMailBox

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

     tbRdHit =  mstTr[0].totalTransactions - l2ReadTrReceived;
     tbRdMiss = l2ReadTrReceived; 


     clock(1000);
     isEmpty();


endtask:statsTest

task testForT1MemError(input reg [NXADDRWIDTH-1:0]Addr, input integer errorBitPos);
  reg [239-1:0]t1_mem_data;
  reg [3:0]IndexAddr = Addr[NXADDRWIDTH-1:0] >> 8;
  t2_mem_error_check = 0;
  sendInval(Addr,0, 0,0,1);
  clock(10);
  sendInval(Addr,0, 0,0,1);
  clock(10);
  sendInval(Addr,0, 0,0,1);
  clock(10);
  sendInval(Addr,0, 0,0,1);
  clock(10);
  sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
  clock(10);
  sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
  clock(10000);
  t1_mem_data[239-1:0] = testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.mem[IndexAddr];
          `TB_YAP($psprintf("t1_mem_data  0x%0x ",t1_mem_data[239-1:0]))
  t1_mem_data[239-1:0] = t1_mem_data[239-1:0] ^ 1 << errorBitPos;
          `TB_YAP($psprintf("t1_mem_data  0x%0x ",t1_mem_data[239-1:0]))
  testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.mem[IndexAddr] = t1_mem_data[239-1:0];
  clock(100);
  t1_mem_error_check = 1;
  sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
  clock(1000);
  //sendInval(32'h300,0, 0,0,1);
  //clock(100);
  //t1_mem_error_check = 0;
  //sendRead(32'h300, 0, 0, 1); // this will support full 8 beat only
  //clock(100);
  t1_mem_error_check = 0;
endtask 

task testForT2MemError(input reg [NXADDRWIDTH-1:0]Addr, input integer errorBitPos,input reg [2:0] errorBeet);
  reg [144-1:0]t2_mem_data;
  reg [3:0]IndexAddr = Addr[NXADDRWIDTH-1:0] >> 8;
  //reg [6:0]memAddr = IndexAddr[3:0] * 8 + errorBeet[2:0] - 1'b1;
  reg [6:0]memAddr = IndexAddr[3:0] * 8 + errorBeet[2:0];
  t1_mem_error_check = 0;
  sendInval(Addr,0, 0,0,1);
  clock(10);
  sendInval(Addr,0, 0,0,1);
  clock(10);
  sendInval(Addr,0, 0,0,1);
  clock(10);
  sendInval(Addr,0, 0,0,1);
  clock(10);
  sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
  clock(10);
  sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
  clock(10000);
  //t2_mem_data[144-1:0] = testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr];
          `TB_YAP($psprintf("t2_mem_data  0x%0x ",t2_mem_data[144-1:0]))
  t2_mem_data[144-1:0] = t2_mem_data[144-1:0] ^ 1 << errorBitPos;
          `TB_YAP($psprintf("t2_mem_data  0x%0x ",t2_mem_data[144-1:0]))
  //testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr] = t2_mem_data[144-1:0];
  clock(100);
  t2_mem_error_check = 1;
  sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
  clock(1000);
  t2_mem_error_check = 0;
  //sendInval(32'h300,0, 0,0,1);
  //clock(100);
  //t2_mem_error_check = 0;
  //sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
  //clock(100);
endtask 
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
          `INFO($psprintf("test_dbg_init_all START "))
    for(i=0; i<NUMDBNK; i = i+1) begin
       for(j=0; j<NUMDROW; j = j+1) begin
           dbgWrTr = new();
           if(i==0) begin
               dbgWrTr.addr = j;
               dbgWrTr.baddr = i;
               dbgWrTr.din = 239'h0;
               dbgWrTr.dout  = 'h0;
               dbgWrTr.reqType  = DBG_WRITE;
               dbgMem[i][j] = dbgWrTr.din;
               if(j == 15) begin
                  j = NUMDROW;
               end
           end else begin
               dbgWrTr.addr = j;
               dbgWrTr.baddr = i;
               dbgWrTr.din = 239'h0;
               dbgWrTr.dout  = 'h0;
               dbgWrTr.reqType  = DBG_WRITE;
               dbgMem[i][j] = dbgWrTr.din & {144{1'b1}};
            end
            dbgTr.send(dbgWrTr);
          `DEBUG($psprintf("DBGMEM_WR_DATA creq %s  ",  dbgWrTr.dbgWriteSprint))
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
               if(i == 0) begin
                 if(j == 15) begin
                    j = NUMDROW;
                 end
               end
       end  
     end  

     clock(10000);
          `INFO($psprintf("test_dbg_init_all END "))

endtask:test_dbg_init_all



task test_dbg_write_all();
    integer i,j,k,l;
    MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgWrTr;
          `INFO($psprintf("test_dbg_write_all START "))
    for(i=0; i<NUMDBNK; i = i+1) begin
       for(j=0; j<NUMDROW; j = j+1) begin
           dbgWrTr = new();
           if(i==0) begin
               dbgWrTr.addr = j;
               dbgWrTr.baddr = i;
               dbgWrTr.din = randomMemData(239);
               dbgWrTr.dout  = 'h0;
               dbgWrTr.reqType  = DBG_WRITE;
               dbgMem[i][j] = dbgWrTr.din;
               if(j == 15) begin
                  j = NUMDROW;
               end
           end else begin
               dbgWrTr.addr = j;
               dbgWrTr.baddr = i;
               dbgWrTr.din = randomMemData(144)& {144{1'b1}};
               dbgWrTr.dout  = 'h0;
               dbgWrTr.reqType  = DBG_WRITE;
               dbgMem[i][j] = dbgWrTr.din & {144{1'b1}};
            end
            dbgTr.send(dbgWrTr);
          `DEBUG($psprintf("DBGMEM_WR_DATA creq %s  ",  dbgWrTr.dbgWriteSprint))
       end  
    end  
    clock(10000);
          `INFO($psprintf("test_dbg_write_all END "))
endtask:test_dbg_write_all

task test_dbg_read_all();
    integer i,j,k,l;
    MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgWrTr;
          `INFO($psprintf("test_dbg_read_all START "))
    for(i=0; i<NUMDBNK; i = i+1) begin
       for(j=0; j<NUMDROW; j = j+1) begin
               dbgWrTr = new();
               dbgWrTr.addr = j;
               dbgWrTr.baddr = i;
               dbgWrTr.dout = 'h0;
               dbgWrTr.din  = 'h0;
               dbgWrTr.reqType  = DBG_READ;
               dbgTr.send(dbgWrTr);
               if(i == 0) begin
                 if(j == 15) begin
                    j = NUMDROW;
                 end
               end
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
//FIXME NEED TO FIX
reg [439:0]lruValue;
reg [52:0]way0Lru;
reg [52:0]way1Lru;
reg [52:0]way2Lru;
reg [52:0]way3Lru;
reg [54:0]wayLru[8];
integer k,l;
    while(1)begin
       while(testbench.ip_top.core.des.algo.a2_loop.algo.core.t1_writeA == 0) clock(1);
          lruValue[439:0] = testbench.ip_top.core.des.algo.a2_loop.algo.core.t1_dinA;
          for(k=0; k<8; k = k+1) begin
             wayLru[k] = lruValue[439:0] >> k * 55;
          end
          for(k=0; k <8; k = k+1) begin
             for(l=0; l <k; l = l+1) begin
                if((wayLru[k][54] == 1'b1) && (wayLru[l][54] == 1'b1) ) begin
                  if(wayLru[k][52:50] == wayLru[l][52:50]) begin
                     clock(1);
                     `ERROR($psprintf(" Way[%0d] and Way[%0d] LRU Both Are Same  Way[%0d]=0x%0x  Way[%0d]=0x%0x ", k,l,k,wayLru[k][52:50],l,wayLru[l][52:50]))
                  end
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
          `DEBUG($psprintf("DBGMEM_RD_DATA creq %s  ",  dbgRdTr.dbgReadSprint))
       if(dbgRdTr.dout == dbgMem[dbgRdTr.baddr][dbgRdTr.addr]) begin
          `DEBUG($psprintf("DBGMEM PASS creq %s  ",  dbgRdTr.dbgReadSprint))
       end else begin
          `TB_YAP($psprintf("DBGMEM FAIL MEM_DATA creq 0x%0x  ",  dbgMem[dbgRdTr.baddr][dbgRdTr.addr]))
          `ERROR($psprintf("DBGMEM FAIL          creq %s  ",  dbgRdTr.dbgReadSprint))
       end

   end
endtask:dbgMemCheck


task automatic cpuCreqMon;
           while(1)
              begin  
                 cpuCbusMonT = new();
                  mstTr[0].creqBusMonReceive(cpuCbusMonT);
                  if(cpuCbusMonT.cattr[1] == CH_REQ_CACHE) begin
                     cpuReqQueue.put(cpuCbusMonT); 
                    `DEBUG($psprintf(" DUVCPUMON cpuCreqMon  creq %s  ", cpuCbusMonT.creqSprint))
                  end
              end
endtask:cpuCreqMon

task resetCache();
   reg[BYTEADDBITS-1:0]byteAddr;
   reg [ROWADDRBITS-1:0]rowAddr;
   reg [TAGADDRBITS-1:0]tagAddr;
   reg [2:0]tagRandomAddr;
   reg [NXADDRWIDTH-1:0]reqAddr;
   reg [NXADDRWIDTH-1:0]memAddr;
   reg [NXDATAWIDTH*8-1:0]memData;
   bit byteSizeDone =0;
   reg [BEETADDBITS-1:0]beetStart;
   reg [BYTEADDBITS-1:0]startByteInbeet;
   reg [NXSIZEWIDTH-1:0]startByte;
   reg [NXSIZEWIDTH-1:0]stopByte;
   reg [NXSIZEWIDTH-1:0]maxByteSize;
   reg [8:0]byteSize;
   reg [3:0]noBeets;
   reg [5:0]x32b;
   reg [5:0]w32b;
   integer i,j;
   MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   begin
   for(j=0;j<NUMWAYS; j = j+1) begin
      for(i=0; i<NUMROWS; i = i+1) begin
	  rowAddr[ROWADDRBITS-1:0] = i;
	  beetStart[BEETADDBITS-1:0] = 0;
	  startByteInbeet[BYTEADDBITS-1:0] = 0;
	  tagAddr[TAGADDRBITS-1:0] = j;
	  byteSize[8:0] = 9'h0;
	  noBeets[3:0] = 4'h8;
	  reqAddr[NXADDRWIDTH-1:0]  = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
          cpuReqT = new();
	  cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
	  cpuReqT.cattr = 'h3;
	  cpuReqT.reqType = CH_READ;
	  cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
	  cpuReqT.noBeets = noBeets[3:0];
	  cpuReqT.beetStart = beetStart[2:0];

	  mstTr[0].send(cpuReqT);
          `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
	  
      end
    end
        clock(10000);
        isEmpty();

        

       memArray.delete;
       cpuReqQueue = new();

    for(j=0;j<NUMWAYS; j = j+1) begin
      for(i=0; i<NUMROWS; i = i+1) begin
	  rowAddr[ROWADDRBITS-1:0] = i;
	  beetStart[BEETADDBITS-1:0] = 0;
	  startByteInbeet[BYTEADDBITS-1:0] = 0;
	  tagAddr[TAGADDRBITS-1:0] = j;
	  byteSize[8:0] = 9'h0;
	  noBeets[3:0] = 4'h8;
	  reqAddr[NXADDRWIDTH-1:0]  = {tagAddr[TAGADDRBITS-1:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
          cpuReqT = new();
	  cpuReqT.addr = reqAddr[NXADDRWIDTH-1:0];
	  cpuReqT.cattr = 'h3;
	  cpuReqT.reqType = CH_READ;
	  cpuReqT.size = byteSize[NXSIZEWIDTH-1:0];
	  cpuReqT.noBeets = noBeets[3:0];
	  cpuReqT.beetStart = beetStart[2:0];

	  mstTr[0].send(cpuReqT);
          `DEBUG($psprintf("TestbenchReq Send_REQ %s  ",  cpuReqT.creqSprint))
	  
      end
    end
        clock(10000);
        isEmpty();





   end


endtask:resetCache

task reReset();
    misc_ifc.rst <= 1'b1;
    `TB_YAP("reset asserted")
    repeat (RESET_CYCLE_COUNT) @ (posedge misc_ifc.clk);
    misc_ifc.rst <= 1'b0;
    `TB_YAP("reset deasserted")
    waitForReady();
endtask:reReset



task clearMem(input reg [ROWADDRBITS-1:0]IndexAdd);
    MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgWrTr;
    integer a,b;
    dbgWrTr = new();
    dbgWrTr.addr = IndexAdd[ROWADDRBITS-1:0];
    dbgWrTr.baddr = 0;
    dbgWrTr.din = 239'h0;
    dbgWrTr.dout  = 'h0;
    dbgWrTr.reqType  = DBG_WRITE;
    dbgTr.send(dbgWrTr);
    clock(100);
   for(b=0;b<8;b = b+1) begin
    for(a=0;a<8;a = a+1) begin
       dbgWrTr = new();
       dbgWrTr.addr = IndexAdd[ROWADDRBITS-1:0]*8 + a;
       dbgWrTr.baddr = 1+b;
       dbgWrTr.din = 239'h0;
       dbgWrTr.dout  = 'h0;
       dbgWrTr.reqType  = DBG_WRITE;
       dbgTr.send(dbgWrTr);
       clock(100);
    end
   end
endtask:clearMem



task errorOnT1Mem(input reg [ROWADDRBITS-1:0]IndexAdd,input integer errorBitPos);
  reg [239-1:0]t1_mem_data;
  t1_mem_data[239-1:0] = testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.mem[IndexAdd];
  `TB_YAP($psprintf("t1_mem_data  0x%0x ",t1_mem_data[239-1:0]))
  t1_mem_data[239-1:0] = t1_mem_data[239-1:0] ^ 1 << errorBitPos;
  `TB_YAP($psprintf("t1_mem_data  0x%0x ",t1_mem_data[239-1:0]))
  testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.mem[IndexAdd] = t1_mem_data[239-1:0];
  clock(100);
endtask:errorOnT1Mem
task errorOnT1Mem1(input reg [ROWADDRBITS-1:0]IndexAdd,input integer errorBitPos);
  reg [239-1:0]t1_mem_data;
  t1_mem_data[239-1:0] = testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.mem[IndexAdd];
  `TB_YAP($psprintf("t1_mem_data  0x%0x ",t1_mem_data[239-1:0]))
  t1_mem_data[239-1:0] = {239{1'b1}};
  `TB_YAP($psprintf("t1_mem_data  0x%0x ",t1_mem_data[239-1:0]))
  testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.mem[IndexAdd] = t1_mem_data[239-1:0];
  clock(100);
endtask:errorOnT1Mem1

task errorOnT2Mem(input reg [ROWADDRBITS-1:0]IndexAdd,input integer errorBitPos,input integer beetNo);
  reg [144-1:0]t2_mem_data;
  reg [6:0]memAddr;

  `TB_YAP($psprintf("errorOnT2Mem  beetNo %d   ",beetNo))
  memAddr = IndexAdd[ROWADDRBITS-1:0] * 8 + beetNo;
  //memAddr = IndexAdd[ROWADDRBITS-1:0] * 8 + 7; //FIXME SREE u Need to change 6 to 7 for insert error in 7th beat
  //t2_mem_data[144-1:0] = testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr];
  `TB_YAP($psprintf("t2_mem_data  0x%0x ",t2_mem_data[144-1:0]))
  t2_mem_data[144-1:0] = t2_mem_data[144-1:0] ^ 1 << errorBitPos;
  `TB_YAP($psprintf("t2_mem_data  0x%0x ",t2_mem_data[144-1:0]))
  //testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr] = t2_mem_data[144-1:0];
  clock(100);
endtask:errorOnT2Mem

task errorOnT2Mem1(input reg [ROWADDRBITS-1:0]IndexAdd,input integer errorBitPos,input integer beetNo);
  reg [144-1:0]t2_mem_data;
  reg [6:0]memAddr;

  memAddr = IndexAdd[ROWADDRBITS-1:0] * 8 + 0;
  //t2_mem_data[144-1:0] = testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr];
  `TB_YAP($psprintf("t2_mem_data  0x%0x ",t2_mem_data[144-1:0]))
  t2_mem_data[144-1:0] = t2_mem_data[144-1:0] ^ 1 << errorBitPos;
  `TB_YAP($psprintf("t2_mem_data  0x%0x ",t2_mem_data[144-1:0]))
  //testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr] = t2_mem_data[144-1:0];
  clock(100);
endtask:errorOnT2Mem1

task errorOnT2Mem2(input reg [ROWADDRBITS-1:0]IndexAdd,input integer errorBitPos,input integer beetNo);
  reg [144-1:0]t2_mem_data;
  reg [6:0]memAddr;

  `TB_YAP($psprintf("errorOnT2Mem2  insert Error on all beats  "))
 /* memAddr = IndexAdd[ROWADDRBITS-1:0] * 8 + 0;
  t2_mem_data[144-1:0] = testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr];
  t2_mem_data[144-1:0] = t2_mem_data[144-1:0] ^ 1 << errorBitPos;
  testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr] = t2_mem_data[144-1:0];
  memAddr = IndexAdd[ROWADDRBITS-1:0] * 8 + 1;
  t2_mem_data[144-1:0] = testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr];
  t2_mem_data[144-1:0] = t2_mem_data[144-1:0] ^ 1 << errorBitPos;
  testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr] = t2_mem_data[144-1:0];
  memAddr = IndexAdd[ROWADDRBITS-1:0] * 8 + 2;
  t2_mem_data[144-1:0] = testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr];
  t2_mem_data[144-1:0] = t2_mem_data[144-1:0] ^ 1 << errorBitPos;
  testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr] = t2_mem_data[144-1:0];
  memAddr = IndexAdd[ROWADDRBITS-1:0] * 8 + 3;
  t2_mem_data[144-1:0] = testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr];
  t2_mem_data[144-1:0] = t2_mem_data[144-1:0] ^ 1 << errorBitPos;
  testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr] = t2_mem_data[144-1:0];
  memAddr = IndexAdd[ROWADDRBITS-1:0] * 8 + 4;
  t2_mem_data[144-1:0] = testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr];
  t2_mem_data[144-1:0] = t2_mem_data[144-1:0] ^ 1 << errorBitPos;
  testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr] = t2_mem_data[144-1:0];
  memAddr = IndexAdd[ROWADDRBITS-1:0] * 8 + 5;
  t2_mem_data[144-1:0] = testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr];
  t2_mem_data[144-1:0] = t2_mem_data[144-1:0] ^ 1 << errorBitPos;
  testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr] = t2_mem_data[144-1:0];
  memAddr = IndexAdd[ROWADDRBITS-1:0] * 8 + 6;
  t2_mem_data[144-1:0] = testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr];
  t2_mem_data[144-1:0] = t2_mem_data[144-1:0] ^ 1 << errorBitPos;
  testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr] = t2_mem_data[144-1:0];
  memAddr = IndexAdd[ROWADDRBITS-1:0] * 8 + 7;
  t2_mem_data[144-1:0] = testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr];
  t2_mem_data[144-1:0] = t2_mem_data[144-1:0] ^ 1 << errorBitPos;
  testbench.ip_top.mem_t2_bank0_cell_bsp7_dwrap_cell.bank_v0_h0.MEMCORE[memAddr] = t2_mem_data[144-1:0];
  */clock(100);
endtask:errorOnT2Mem2

task testT1MemError();
   integer loopCnt = 40;
   reg [BYTEADDBITS-1:0]byteAddr;
   reg [ROWADDRBITS-1:0]rowAddr;
   reg [TAGADDRBITS-1:0]tagAddr;
   reg [NXADDRWIDTH-1:0]Addr;
   integer errorBitPos;
   integer randClk;
     slvTr[0].gapBetweenBeetsEn = 0;
     insertL2Error = 0;
       reReset();
       memArray.delete;
       cpuReqQueue = new();
  `TB_YAP($psprintf("t1_mem_data START "))
   while(loopCnt != 0) begin
     t1_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);
     //1
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     errorBitPos = $urandom_range(0,238);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     // insert Error Befor Read 
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t1_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t1_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

  `TB_YAP($psprintf("t1_mem_data  CASE 1 "))

     //2
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.read);
     clock(3);
     errorBitPos = $urandom_range(0,238);
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     t1_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t1_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

  `TB_YAP($psprintf("t1_mem_data  CASE 2 "))
     //3
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.read);
     @(posedge testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.read);
     randClk = $urandom_range(0,7);
     clock(randClk);
    `TB_YAP($psprintf("t1_mem_data  randClk %d  time %t ",randClk,$time))
     errorBitPos = $urandom_range(0,238);
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t1_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t1_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

  `TB_YAP($psprintf("t1_mem_data  CASE 3 "))
     //4
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     @(posedge testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.write);
     randClk = $urandom_range(0,7);
     clock(randClk);
    `TB_YAP($psprintf("t1_mem_data  randClk %d  time %t ",randClk,$time))
     errorBitPos = $urandom_range(0,238);
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t1_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t1_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

  `TB_YAP($psprintf("t1_mem_data  CASE 4 "))


     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t1_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00; 
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     errorBitPos = $urandom_range(0,238);
     @(negedge testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.read);
     clock(1);
     @(posedge testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.read);
     randClk = $urandom_range(8,12);
     clock(randClk);
    `TB_YAP($psprintf("t1_mem_data  randClk %d  time %t ",randClk,$time))
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     t1_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t1_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

  `TB_YAP($psprintf("t1_mem_data  CASE 4.1 "))

     //5
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t1_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00; 
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     errorBitPos = $urandom_range(0,238);
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     t1_mem_error_check = 1;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t1_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t1_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

  `TB_YAP($psprintf("t1_mem_data  CASE 5 "))
     //6
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     t1_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00; 
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);

  `TB_YAP($psprintf("t1_mem_data  CASE 6 "))
     loopCnt = loopCnt -1 ;

  `TB_YAP($psprintf("t1_mem_data  loopCnt    %d    ",loopCnt))
  end

endtask:testT1MemError

task testT1MemErrorNoL2Error();
   integer loopCnt = 40;
   reg [BYTEADDBITS-1:0]byteAddr;
   reg [ROWADDRBITS-1:0]rowAddr;
   reg [TAGADDRBITS-1:0]tagAddr;
   reg [NXADDRWIDTH-1:0]Addr;
   integer errorBitPos;
   integer randClk;
     slvTr[0].gapBetweenBeetsEn = 1;
     slvTr[0].alwaysEnGapBetweenBeets = 1;
     slvTr[0].alwaysEnStall = 1;
     insertL2Error = 0;
       reReset();
       memArray.delete;
       cpuReqQueue = new();
  `TB_YAP($psprintf("testT1MemErrorNoL2Error START "))
   while(loopCnt != 0) begin
     t1_mem_error_check = 1;
     //1
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     errorBitPos = $urandom_range(0,238);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     // insert Error Befor Read 
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t1_mem_error_check = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

  `TB_YAP($psprintf("testT1MemErrorNoL2Error  CASE 1 "))

     //2
     t1_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.read);
     clock(3);
     errorBitPos = $urandom_range(0,238);
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     t1_mem_error_check = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

  `TB_YAP($psprintf("testT1MemErrorNoL2Error  CASE 2 "))
     //3
     t1_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.read);
     @(posedge testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.write);
     randClk = $urandom_range(2,7);
     clock(randClk);
    `TB_YAP($psprintf("testT1MemErrorNoL2Error  randClk %d  time %t ",randClk,$time))
     errorBitPos = $urandom_range(0,238);
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t1_mem_error_check = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

  `TB_YAP($psprintf("testT1MemErrorNoL2Error  CASE 3 "))

     t1_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     @(posedge testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.write);
     clock(1);
     @(posedge testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.read);
     randClk = $urandom_range(0,7);
     clock(randClk);
    `TB_YAP($psprintf("testT1MemErrorNoL2Error  randClk %d  time %t ",randClk,$time))
     errorBitPos = $urandom_range(0,238);
     errorOnT1Mem1(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t1_mem_error_check = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

  `TB_YAP($psprintf("testT1MemErrorNoL2Error  CASE 3.1 "))



     //4
     t1_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     @(posedge testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.write);
     randClk = $urandom_range(2,7);
     clock(randClk);
    `TB_YAP($psprintf("testT1MemErrorNoL2Error  randClk %d  time %t ",randClk,$time))
     errorBitPos = $urandom_range(0,238);
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t1_mem_error_check = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

  `TB_YAP($psprintf("testT1MemErrorNoL2Error  CASE 4 "))


     t1_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     errorBitPos = $urandom_range(0,238);
     @(negedge testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.read);
     @(posedge testbench.ip_top.mem_t1_bank0_cell_dwrap_cell.read);
     randClk = $urandom_range(8,12);
     clock(randClk);
    `TB_YAP($psprintf("testT1MemErrorNoL2Error  randClk %d  time %t ",randClk,$time))
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     t1_mem_error_check = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

  `TB_YAP($psprintf("testT1MemErrorNoL2Error  CASE 4.1 "))


  

     //5
     t1_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t1_mem_error_check = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     errorBitPos = $urandom_range(0,238);
     errorOnT1Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos);
     t1_mem_error_check = 1;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t1_mem_error_check = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

  `TB_YAP($psprintf("testT1MemErrorNoL2Error  CASE 5 "))
     //6
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     t1_mem_error_check = 0;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);

  `TB_YAP($psprintf("testT1MemErrorNoL2Error  CASE 6 "))
     loopCnt = loopCnt -1 ;

  `TB_YAP($psprintf("testT1MemErrorNoL2Error  loopCnt    %d    ",loopCnt))
  end

endtask:testT1MemErrorNoL2Error

task testT2MemError();
   integer loopCnt = 50;
   reg [BYTEADDBITS-1:0]byteAddr;
   reg [ROWADDRBITS-1:0]rowAddr;
   reg [TAGADDRBITS-1:0]tagAddr;
   reg [NXADDRWIDTH-1:0]Addr;
   integer errorBitPos;
   integer beetNo;
   integer randClk;
       reReset();
       memArray.delete;
       cpuReqQueue = new();
     insertL2Error = 0;
  `TB_YAP($psprintf("t2_mem_data START "))
   while(loopCnt != 0) begin
     // 1
     slvTr[0].gapBetweenBeetsEn = 0;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);
     t2_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     errorBitPos = $urandom_range(0,143);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     // insert Error Befor Read 
     beetNo = $urandom_range(0,7);
     errorOnT2Mem1(rowAddr[ROWADDRBITS-1:0],errorBitPos,beetNo);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);
     

  `TB_YAP($psprintf("t2_mem_data  CASE 1 "))

     // 2
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.t2_readB);
     randClk = $urandom_range(0,4);
     clock(randClk);
    `TB_YAP($psprintf("t2_mem_data  randClk %d  time %t ",randClk,$time))
     errorBitPos = $urandom_range(0,143);
     beetNo = $urandom_range(0,7);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos,beetNo);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

  `TB_YAP($psprintf("t2_mem_data  CASE 2 "))
     // 3
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     @(posedge testbench.ip_top.t2_writeA);
     randClk = $urandom_range(0,4);
     clock(randClk);
    `TB_YAP($psprintf("t2_mem_data  randClk %d  time %t ",randClk,$time))
     errorBitPos = $urandom_range(0,143);
     beetNo = $urandom_range(0,7);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos,beetNo);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

  `TB_YAP($psprintf("t2_mem_data  CASE 3 "))


    rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     @(posedge testbench.ip_top.t2_writeA);
     errorBitPos = $urandom_range(0,143);
     beetNo = $urandom_range(0,7);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos,beetNo);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

  `TB_YAP($psprintf("t2_mem_data  CASE 3.1 "))


     // 4
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = 2'h0;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     @(posedge testbench.ip_top.t2_writeA);
     randClk = $urandom_range(8,13);
     clock(randClk);
    `TB_YAP($psprintf("t2_mem_data  randClk %d  time %t ",randClk,$time))
     errorBitPos = $urandom_range(0,143);
     errorOnT2Mem2(rowAddr[ROWADDRBITS-1:0],errorBitPos,beetNo);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

  `TB_YAP($psprintf("t2_mem_data  CASE 4 "))


          // 5
     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00; 
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     t2_mem_error_check = 1;
     errorBitPos = $urandom_range(0,143);
     beetNo = $urandom_range(0,7);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos,beetNo);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);  

     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

  `TB_YAP($psprintf("t2_mem_data  CASE 5 "))
    //6 
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00; 
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.t2_readB);
     @(posedge testbench.ip_top.t2_readB);
     errorBitPos = $urandom_range(0,143);
     beetNo = $urandom_range(0,7);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos,beetNo);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     t2_mem_error_check = 1;
     {l2RrspDataErr,l2RrspAddErr} = $urandom_range(1,3);

  `TB_YAP($psprintf("t2_mem_data  CASE 6 "))
     // 7
     t2_mem_error_check = 0;
     {l2RrspDataErr,l2RrspAddErr} = 2'b00; 
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

  `TB_YAP($psprintf("t2_mem_data  CASE 7 "))
     loopCnt = loopCnt -1 ;

  `TB_YAP($psprintf("t2_mem_data  loopCnt    %d    ",loopCnt))
  end

endtask:testT2MemError

task testT2MemErrorNoL2Error();
   integer loopCnt = 50;
   reg [BYTEADDBITS-1:0]byteAddr;
   reg [ROWADDRBITS-1:0]rowAddr;
   reg [TAGADDRBITS-1:0]tagAddr;
   reg [NXADDRWIDTH-1:0]Addr;
   integer errorBitPos;
   integer beetNo;
   integer randClk;
       reReset();
       memArray.delete;
       cpuReqQueue = new();
     insertL2Error = 0;
  `TB_YAP($psprintf("testT2MemErrorNoL2Error START "))
   while(loopCnt != 0) begin
     // 1
     slvTr[0].gapBetweenBeetsEn = 1;
     slvTr[0].alwaysEnGapBetweenBeets = 1;
     slvTr[0].alwaysEnStall = 1;
     t2_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     errorBitPos = $urandom_range(0,143);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     // insert Error Befor Read 
     beetNo = $urandom_range(0,7);
     errorOnT2Mem1(rowAddr[ROWADDRBITS-1:0],errorBitPos,beetNo);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t2_mem_error_check = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     

  `TB_YAP($psprintf("t2_mem_data  CASE 1 "))

     // 2
     t2_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.t2_readB);
     randClk = $urandom_range(1,2);
     clock(randClk);
    `TB_YAP($psprintf("testT2MemErrorNoL2Error  randClk %d  time %t ",randClk,$time))
     errorBitPos = $urandom_range(0,143);
     beetNo = $urandom_range(0,7);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos,beetNo);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     t2_mem_error_check = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

  `TB_YAP($psprintf("testT2MemErrorNoL2Error  CASE 2 "))
     // 3
     t2_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     randClk = $urandom_range(2,4);
     clock(randClk);
     repeat(randClk)@(posedge testbench.ip_top.t2_readB);
    `TB_YAP($psprintf("testT2MemErrorNoL2Error  randClk %d  time %t ",randClk,$time))
     errorBitPos = $urandom_range(0,143);
     beetNo = $urandom_range(0,7);
     beetNo = randClk+1;;
     errorOnT2Mem2(rowAddr[ROWADDRBITS-1:0],errorBitPos,beetNo);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t2_mem_error_check = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

  `TB_YAP($psprintf("testT2MemErrorNoL2Error  CASE 3 "))


     t2_mem_error_check = 1;
    rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     repeat(3)@(posedge testbench.ip_top.t2_readB);
     errorBitPos = $urandom_range(0,143);
     beetNo = $urandom_range(4,7);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos,beetNo);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t2_mem_error_check = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

  `TB_YAP($psprintf("testT2MemErrorNoL2Error  CASE 3.1 "))


     // 4
     t2_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     repeat(2)@(posedge testbench.ip_top.t2_writeA);
     randClk = $urandom_range(2,8);
     clock(randClk);
    `TB_YAP($psprintf("testT2MemErrorNoL2Error  randClk %d  time %t ",randClk,$time))
     errorBitPos = $urandom_range(0,143);
     beetNo = $urandom_range(0,1);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos,beetNo);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);


     t2_mem_error_check = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

  `TB_YAP($psprintf("testT2MemErrorNoL2Error  CASE 4 "))


          // 5
     t2_mem_error_check = 0;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     t2_mem_error_check = 1;
     errorBitPos = $urandom_range(0,143);
     beetNo = $urandom_range(0,7);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos,beetNo);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);  

     t2_mem_error_check = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

  `TB_YAP($psprintf("testT2MemErrorNoL2Error  CASE 5 "))
    //6 
     t2_mem_error_check = 1;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     clearMem(rowAddr[ROWADDRBITS-1:0]);
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     @(negedge testbench.ip_top.t2_readB);
     @(posedge testbench.ip_top.t2_readB);
     errorBitPos = $urandom_range(0,143);
     beetNo = $urandom_range(0,7);
     errorOnT2Mem(rowAddr[ROWADDRBITS-1:0],errorBitPos,beetNo);
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

     t2_mem_error_check = 0;
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

  `TB_YAP($psprintf("testT2MemErrorNoL2Error  CASE 6 "))
     // 7
     t2_mem_error_check = 0;
     rowAddr[ROWADDRBITS-1:0] = $urandom_range(0,15);
     Addr[NXADDRWIDTH-1:0] = {{TAGADDRBITS{1'b0}},rowAddr[ROWADDRBITS-1:0],8'h0};
     sendRead(Addr, 0, 0, 1); // this will support full 8 beat only
     clock(300);
     clearMem(rowAddr[ROWADDRBITS-1:0]);

  `TB_YAP($psprintf("testT2MemErrorNoL2Error  CASE 7 "))
     loopCnt = loopCnt -1 ;

  `TB_YAP($psprintf("testT2MemErrorNoL2Error  loopCnt    %d    ",loopCnt))
  end

endtask:testT2MemErrorNoL2Error

endclass:MeCacheTestBench
`endif

