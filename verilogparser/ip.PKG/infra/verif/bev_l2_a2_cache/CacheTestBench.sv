`ifndef CACHE_TEST_BENCH
`define CACHE_TEST_BENCH
class CacheTestBench #(int BITADDR=34,int BITDATA=512,int BITSEQN=4,int NUMBYLN=64,int XBITATR=3,int NOMSTP = 1,int NOSLVP = 1,int NUMWAYS = 4,int NUMINDX = 128) extends MeTransactor;

   localparam BYTEADDBITS = 5;
   localparam ROWADDRBITS = 7;
   localparam TAGADDRBITS = BITADDR - ROWADDRBITS  - BYTEADDBITS;

   localparam BYTE = 8;

   string name;
   integer i,j;
   CacheMasterTransactor#(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) mstTr[NOMSTP];
   CacheSlaveTransactor#(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) slvTr[NOSLVP];
   virtual Misc_Ifc misc_ifc;
   virtual L2_M_Ifc  #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR)  mL2Ifc[NOMSTP];
   virtual L2_S_Ifc  #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR)  sL2Ifc[NOSLVP];

   CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) cpuWrRspT;
   CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) MemRdAMonT;
   CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) MemWrMonT;
   CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) MemWrRspT;
   CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) cpuRdRspT;
   CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) outOfOrdrQueue[$];
   integer                       RESET_CYCLE_COUNT = 20;
   integer                       TIMEOUT_CYCLE_COUNT = 30;
   integer                       DONE_CYCLE_COUNT = 50; // num empty cycles to call done
   reg [BITDATA-1 :0] memArray[*];
   reg [BITDATA-1 :0] evictMemArray[*];
   reg [BITDATA-1 :0] InvalArray[*];
   mailbox cpuReqQueue;
   mailbox monCpuRdRspQueue;
   mailbox monL2WrRspQueue;
   bit outOfOrderRspEn;

   function new (string name); begin
     super.new(name);
     this.name = name;
     `DEBUG($psprintf("Function New   "))
     cpuReqQueue = new();
     monCpuRdRspQueue = new();
     monL2WrRspQueue = new();
     for(i=0; i<NOMSTP; i = i+1) begin
       mstTr[i] = new($psprintf("mstTr[%d]",i));
     end 
     for(i=0; i<NOSLVP; i = i+1) begin
       slvTr[i] = new($psprintf("slvTr[%d]",i));
     end
     outOfOrderRspEn = 1;
   end
  endfunction:new

   task init (virtual Misc_Ifc misc_ifc,  virtual L2_M_Ifc#(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) mAxiIfc[NOMSTP],virtual L2_S_Ifc#(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) sAxiIfc[NOSLVP]);begin 
      this.misc_ifc = misc_ifc;
      `DEBUG($psprintf("Task Init   "))
      for(i=0; i<NOMSTP; i = i+1) begin
         mstTr[i].init(mAxiIfc[i]);
      end 
      for(i=0; i<NOSLVP; i = i+1) begin
         slvTr[i].init(sAxiIfc[i]);
      end 
    end
   endtask:init

   task clear();begin
       `DEBUG($psprintf("Task Clear   "))
       fork
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
       join_none
     end
   endtask:clear

   task reset(); begin
      misc_ifc.rst <= 1'b1;
      `TB_YAP("reset asserted")
      repeat (RESET_CYCLE_COUNT) @ (posedge misc_ifc.clk);
      misc_ifc.rst <= 1'b0;
      `TB_YAP("reset deasserted")
      waitForReady();
      fork
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
      join_none
     end
  endtask:reset

  task run();begin
      `DEBUG($psprintf("Task Run"))
      fork
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
        drive();
        monitor();
      join_none
    end
  endtask:run

   task drive();begin
       `DEBUG($psprintf("Task Drive"))
       fork
         display();
       join_none
     end
  endtask:drive


   task monitor(); begin
      `DEBUG($psprintf("Task Monitor"))
      fork
         monCpuWrRsp();
         monCpuRdRsp();
         monMemWrReq();
         monMemRdAddReq();
         sendMemRdRsp();
         monCpuReq();
         readCheckTask();
         writeCheckTask();
         sendL2RdRsp();
      join_none
     end
   endtask :monitor

   task clock (integer numClocks = 1);begin
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
 
   task monCpuReq();begin
      CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) cpuReqT;
       while(1) begin
          cpuReqT = new();
          mstTr[0].reqBusMonReceive(cpuReqT);
         `DEBUG($psprintf("monCpuReq cReq %s  ", cpuReqT.reqSprint))
          cpuReqQueue.put(cpuReqT);
       end
     end
   endtask:monCpuReq
   

   task monCpuWrRsp();begin
       integer queueSize,j;
       while(1) begin
          cpuWrRspT = new();
          cpuWrRspT.Data[0] = 0;
          mstTr[0].writeRspReceive(cpuWrRspT);
         `DEBUG($psprintf("monCpuWrRsp cReq %s  ", cpuWrRspT.reqSprint))
       end
     end
   endtask:monCpuWrRsp

   task monCpuRdRsp();begin
      while(1) begin
         cpuRdRspT = new();
         cpuRdRspT.Data[0] = 0;
         mstTr[0].readDataReceive(cpuRdRspT);
         `DEBUG($psprintf("monCpuRdRsp cReq %s  ", cpuRdRspT.reqSprint))
         monCpuRdRspQueue.put(cpuRdRspT);
      end
    end
   endtask:monCpuRdRsp


   task monMemWrReq();begin
      bit pushFBSel;
      while(1) begin
         MemWrMonT = new();
         MemWrMonT.Data = 0;
         slvTr[0].wrReceive(MemWrMonT);
         //`TB_YAP($psprintf("monMemWrReq cReq %s  ", MemWrMonT.reqSprint))
         MemWrRspT = new MemWrMonT ;
         MemWrRspT.Attr = {2'h0,1'b1};
         MemWrRspT.RspSeq = MemWrMonT.ReqSeq;
         //slvTr[0].send(MemWrRspT);
         monL2WrRspQueue.put(MemWrMonT);
       /* if (outOfOrderRspEn == 1) begin // code for out of order
           pushFBSel = $urandom_range(0,1);
             if(pushFBSel == 1) begin
               outOfOrdrQueue.push_front(MemWrRspT);
             end else begin
               outOfOrdrQueue.push_back(MemWrRspT);
             end 
        end else  begin
          slvTr[0].send(MemWrRspT);
          `DEBUG($psprintf("monMemWrReq rReq data %s  ", MemWrRspT.reqSprint))
        end
       */
      end
     end
   endtask:monMemWrReq

   task monMemRdAddReq();begin
      reg [BITDATA-1:0]wrData;
      bit pushFBSel;
      while(1) begin
         MemRdAMonT = new();
         MemRdAMonT.Data = 0;
         slvTr[0].rdAddReceive(MemRdAMonT);
         `DEBUG($psprintf("monMemRdAddReq cReq %s  ", MemRdAMonT.reqSprint))
             wrData[BITDATA-1:0] = randomDataWithAddr(BITDATA,MemRdAMonT.Addr);
            //`TB_YAP($psprintf("monMemRdAddReq 0x%0x  ", wrData[BITDATA-1:0]))
             MemRdAMonT.Data = wrData[BITDATA-1:0];
             memArray[MemRdAMonT.Addr] =  wrData[BITDATA-1:0];
             MemRdAMonT.Attr = {2'h0,1'b1};
             MemRdAMonT.RspSeq = MemRdAMonT.ReqSeq;
             //slvTr[0].send(MemRdAMonT);
             if(outOfOrderRspEn == 1) begin // code for out of order
                pushFBSel = $urandom_range(0,1);
                if(pushFBSel == 1) begin
                  outOfOrdrQueue.push_front(MemRdAMonT);
                end else begin
                  outOfOrdrQueue.push_back(MemRdAMonT);
                end 
             end else  begin
               slvTr[0].send(MemRdAMonT);
               `DEBUG($psprintf("monMemRdAddReq rReq data %s  ", MemRdAMonT.reqSprint))
             end
      end
     end
   endtask:monMemRdAddReq


  task sendL2RdRsp();
    CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) l2RdDataTr;
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

       k = (outOfOrderRspEn == 0) ? 2 :$urandom_range(MinVal,MaxVal);
       l = 0; 
       `DEBUG($psprintf(" Before sendL2RdRsp k  %d , size %d l %d time %t ",k,outOfOrdrQueue.size(),l,$time))
       while((outOfOrdrQueue.size() < k) && (l < 100)) begin
       `DEBUG($psprintf("sendL2RdRsp k  %d , size %d l %d time %t ",k,outOfOrdrQueue.size(),l,$time))
          clock(1);
          l = l+1;
       end
       n = outOfOrdrQueue.size();
       `DEBUG($psprintf("sendL2RdRsp outOfOrdrQueue Size  %d  ",n))
       for(m=0; m<n; m = m+1) begin
          popFBSel = (outOfOrderRspEn == 0) ? 1 :$urandom_range(0,1);
          if(popFBSel == 1) begin
            l2RdDataTr = outOfOrdrQueue.pop_front();
          end else begin
            l2RdDataTr = outOfOrdrQueue.pop_back();
          end 
          slvTr[0].send(l2RdDataTr);
          `DEBUG($psprintf("sendL2RdRsp rReq data %s  ", l2RdDataTr.reqSprint))
      end

    end
  endtask:sendL2RdRsp


    task sendMemRdRsp();
       CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) MemRdDataTr;
       while(1) begin
         clock(1);
       end
   endtask:sendMemRdRsp


   function [BITDATA-1:0] randomDataWithAddr(input integer width,input [BITDATA-1:0]addr); 
      integer m; 
      randomDataWithAddr = 0; 
      for (m = width/32; m >= 0; m--) 
         randomDataWithAddr = (randomDataWithAddr << 32) + $urandom + 32'h12345678;
      randomDataWithAddr[BITADDR-1:0] = addr;
   endfunction

   function [BITDATA-1:0] randomData(input integer width); 
      integer m; 
      randomData = 0; 
      for (m = width/32; m >= 0; m--) 
         randomData = (randomData << 32) + $urandom + 32'h12345678;
   endfunction

   task finish();
      begin
        isEmpty();
        clock(1000);
      end
   endtask:finish


task sendWrite(input reg [BITDATA-1:0] addr,input reg [NUMBYLN-1:0] byteEn);
  CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) cpuReqT;
  reg  [BITDATA-1:0]wrData;
  begin
    cpuReqT = new();
    `TB_YAP($psprintf("write addr=0x%0x byteEn=%0d ", addr, byteEn))
    cpuReqT.Addr = addr; 
    cpuReqT.Write = 1'b1;
    cpuReqT.Read  = 1'b0;
    cpuReqT.Inval = 1'b0;
    cpuReqT.valid = 1'b1;
    cpuReqT.ByteEn = byteEn;
    wrData[BITDATA-1:0] =  randomDataWithAddr(BITDATA,addr[BITADDR-1:0]);
    cpuReqT.Data = wrData[BITDATA-1:0];
    mstTr[0].send(cpuReqT);
  end
endtask:sendWrite

task sendInval(input reg [BITDATA-1:0] addr);
  CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) cpuReqT;
  reg  [BITADDR-1:0]wrData;
  begin
    cpuReqT = new();
    `TB_YAP($psprintf("write addr=0x%0x  ", addr))
    cpuReqT.Addr = addr; 
    cpuReqT.Write = 1'b0;
    cpuReqT.Read  = 1'b0;
    cpuReqT.Inval = 1'b1;
    cpuReqT.valid = 1'b1;
    cpuReqT.ByteEn = 'h0;
    wrData[BITDATA-1:0] =  {BITDATA{1'b0}};
    cpuReqT.Data = wrData[BITDATA-1:0];
    mstTr[0].send(cpuReqT);
  end
endtask:sendInval

task sendRead(input reg [BITDATA-1:0] addr);
  CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) cpuReqT;
  reg  [BITADDR-1:0]wrData;
  begin
    cpuReqT = new();
    `TB_YAP($psprintf("write addr=0x%0x  ", addr))
    cpuReqT.Addr = addr; 
    cpuReqT.Write = 1'b0;
    cpuReqT.Read  = 1'b1;
    cpuReqT.Inval = 1'b0;
    cpuReqT.valid = 1'b1;
    cpuReqT.ByteEn = '0;
    wrData[BITDATA-1:0] =  {BITDATA{1'b0}};
    cpuReqT.Data = wrData[BITDATA-1:0];
    mstTr[0].send(cpuReqT);
  end
endtask:sendRead




task readCheckTask;
  CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) cpuRdDataT;
  CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) cpuWrTr;
  CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) cpuRdTr;
  CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) RAWTr;
  CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) RAITr;
  CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) invalTr;
  CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) flushTr;
  CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) IARTr;
  CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) WriteByteAll;
  reg [BITDATA-1:0] cpuRdData;
  reg [BITADDR-1:0] cpuRdAddr;
  reg [BITDATA-1:0] comuteData;
  bit readDataMatchWithMemArry;
  bit readDataMatchWithFill;
  bit readDataMatchWithHit;
  bit readDataMatchWithEvictMem;
  bit readDataMatchWithInvalMem;
  bit writeTrWithAllByteEnFound;
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
       cpuRdAddr[BITADDR-1:0] = cpuRdDataT.Addr;
       cpuRdAddr[4:0] = 'h0;
       readDataMatchWithMemArry = 0;
       readDataMatchWithFill = 0;
       readDataMatchWithHit = 0;
       readDataMatchWithEvictMem = 0;
       readDataMatchWithInvalMem = 0;
       writeTrWithAllByteEnFound = 0;
       WBRFound = 0;
       RBRFound = 0;
       WARFound = 0;
       RARFound = 0;
       IARFound = 0;
       `DEBUG($psprintf(" DEBUG_READ Cache Read Rsp ---------->  %s",cpuRdDataT.reqSprint))
       queueSize = cpuReqQueue.num();
       for(i=0; i<queueSize; i = i+1) begin
          cpuReqQueue.get(cpuWrTr);
          if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5))  ) begin
              `DEBUG($psprintf(" DEBUG_READ  SAME ADDR cReq %s  ", cpuWrTr.reqASprint))
          end
          if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Write == 1'b1) && (cpuWrTr.transactionTime < cpuRdDataT.transactionTime)) begin
              WBRFound = 1;
              `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP WBRFound cReq %s  ", cpuWrTr.reqASprint))
          end
          if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Read == 1'b1) && (cpuWrTr.transactionTime < cpuRdDataT.transactionTime)) begin
              RBRFound = 1;
              `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP RBRFound cReq %s  ", cpuWrTr.reqASprint))
          end
          if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Write == 1'b1) && (IARFound == 0) && (cpuWrTr.transactionTime > cpuRdDataT.transactionTime)) begin
              WARFound = 1;
              `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP WARFound cReq %s  ", cpuWrTr.reqASprint))
          end
          if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Read == 1'b1) && (IARFound == 0) && (cpuWrTr.transactionTime > cpuRdDataT.transactionTime)) begin
              RARFound = 1;
              `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP RARFound cReq %s  ", cpuWrTr.reqASprint))
          end
          if(((cpuWrTr.Addr >> 5)==(cpuRdDataT.Addr >> 5))&&(cpuWrTr.Inval==1'b1)&& (WARFound==0)&&(RARFound==0)&&(cpuWrTr.transactionTime>cpuRdDataT.transactionTime))begin
              IARFound = 1;
              IARTr = new cpuWrTr;
              `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP IARFound cReq %s  ", cpuWrTr.reqASprint))
          end
          cpuReqQueue.put(cpuWrTr);
       end
       `DEBUG($psprintf(" DEBUG_READ  WBRFound %d RBRFound %d WARFound %d RARFound %d IARFound %d  ",WBRFound,RBRFound,WARFound,RARFound,IARFound ))



      if(memArray.exists(cpuRdAddr[BITADDR-1:0]))begin
  	 invalFound = 0;
	 invalLocked = 0;
	 flushLocked = 0;
	 readLocked = 0;
         queueSize = cpuReqQueue.num();
         `DEBUG($psprintf(" DEBUG_READ Mem exists cpuReqQueue SIZE  %d  ", cpuReqQueue.num()))
         for(i=0; i<queueSize; i = i+1) begin
            cpuReqQueue.get(cpuWrTr);
            if((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5))  begin
                `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP PEND_TR_CPU_QUEUE cReq %s  ", cpuWrTr.reqASprint))
            end
            if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Read == 1'b1) && (readLocked == 0) && (cpuWrTr.transactionTime != cpuRdDataT.transactionTime)) begin
                `ERROR($psprintf(" DEBUG_READ BEFORE_CMP one more Read is Pending Befor curent Read Rsv Read cReq %s  ", cpuWrTr.reqASprint))
            end
            if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Read == 1'b1) && (cpuWrTr.transactionTime == cpuRdDataT.transactionTime)) begin
                readLocked = 1;
                `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP READLOCKED cReq %s  ", cpuWrTr.reqASprint))
            end
            if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Inval == 1'b1) && 
               (cpuWrTr.transactionTime < cpuRdDataT.transactionTime) && (readLocked == 0)&& (flushLocked == 0)) begin
                invalTr = new cpuWrTr;
                invalLocked = 1;
                `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP INVALLOCKED cReq %s  ", invalTr.reqASprint))
            end
            cpuReqQueue.put(cpuWrTr);
         end
         `DEBUG($psprintf(" DEBUG_READ cpuReqQueue SIZE  %d  ", cpuReqQueue.num()))
         queueSize = cpuReqQueue.num();
         comuteData[BITDATA-1:0] = memArray[cpuRdAddr[BITADDR-1:0]];
         `DEBUG($psprintf(" DEBUG_READ MEMARRYCMP MEM_DATA 0x%x Addr 0x%x ",comuteData[BITDATA-1:0] ,cpuRdAddr[BITADDR-1:0]))
         for(i=0; i<queueSize; i = i+1) begin
            cpuReqQueue.get(cpuWrTr);
            if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Inval == 1'b1) && (cpuWrTr.transactionId < cpuRdDataT.transactionId))  begin
                 comuteData[BITDATA-1:0] = memArray[cpuRdAddr[BITADDR-1:0]];
                `DEBUG($psprintf(" DEBUG_READ MEMARRYCMP INVAL Found. Reseting the Comp Data with Mem Data MEM_DATA 0x%x  cReq %s  ",comuteData[BITDATA-1:0], cpuWrTr.reqSprint))
            end  // end for comuteReadHit
            if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Write == 1'b1) && (cpuWrTr.transactionId < cpuRdDataT.transactionId))  begin
                 comuteData[BITDATA-1:0] = computeCacheData(comuteData[BITDATA-1:0],cpuWrTr);
                `DEBUG($psprintf(" DEBUG_READ MEMARRYCMP 1 CPU_TR Pend Wr Tr Before Rd Tr cReq %s  ", cpuWrTr.reqSprint))
            end  // end for comuteReadHit
            if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Write == 1'b1) && (cpuWrTr.transactionId > cpuRdDataT.transactionId))  begin
                `DEBUG($psprintf(" DEBUG_READ MEMARRYCMP 2 CPU_TR Pend Wr Tr After Rd Tr cReq %s  ", cpuWrTr.reqASprint))
            end
            cpuReqQueue.put(cpuWrTr);
         end
         if(cpuRdDataT.Data  == comuteData[BITDATA-1:0]) begin
            readDataMatchWithMemArry = 1'b1;
            `DEBUG($psprintf(" DEBUG_READ MEMARRYCMP Read Data Match With MemArray+WrTr 0x%x ",comuteData[BITDATA-1:0] ))
         end
      end

      if((!(memArray.exists(cpuRdAddr[BITADDR-1:0])))  && (readDataMatchWithMemArry == 1'b0)) begin
  	 invalFound = 0;
	 invalLocked = 0;
	 flushLocked = 0;
	 readLocked = 0;
         writeTrWithAllByteEnFound = 0;
         queueSize = cpuReqQueue.num();
         `DEBUG($psprintf(" DEBUG_READ cpuReqQueue No Mem Exists SIZE  %d  ", cpuReqQueue.num()))
         for(i=0; i<queueSize; i = i+1) begin
            cpuReqQueue.get(cpuWrTr);
            if((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5))  begin
                `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP PEND_TR_CPU_QUEUE cReq %s  ", cpuWrTr.reqASprint))
            end
            if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Write == 1'b1) && (cpuWrTr.ByteEn == {NUMBYLN{1'b1}})&& (writeTrWithAllByteEnFound == 1'b0) && (cpuWrTr.transactionTime < cpuRdDataT.transactionTime)) begin
                `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP Write Tr with All Byte En Found %s  ", cpuWrTr.reqSprint))
                  WriteByteAll = new cpuWrTr;
                 writeTrWithAllByteEnFound = 1;
            end
            if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Read == 1'b1) && (writeTrWithAllByteEnFound == 1'b0)) begin
                `ERROR($psprintf(" DEBUG_READ BEFORE_CMP  No Mem Array Found Before ReadReq %s  ", cpuWrTr.reqASprint))
            end
            if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Read == 1'b1) && (writeTrWithAllByteEnFound == 1'b1)) begin
                `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP  No Mem Read Lock %s  ", cpuWrTr.reqASprint))
	         readLocked = 1;
            end
            if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Write == 1'b1) && (writeTrWithAllByteEnFound == 1'b0)) begin
                `ERROR($psprintf(" DEBUG_READ BEFORE_CMP  No Mem Array Found Before Write Req %s  ", cpuWrTr.reqASprint))
            end
            if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Inval == 1'b1) && (readLocked == 1'b0)) begin
                 writeTrWithAllByteEnFound = 0;
                `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP  No Mem Reset writeTrWithAllByteEnFound %s  ", cpuWrTr.reqSprint))
           end
            cpuReqQueue.put(cpuWrTr);
         end
	 readLocked = 0;
         queueSize = cpuReqQueue.num();
         `DEBUG($psprintf(" DEBUG_READ cpuReqQueue No Mem Exists  SIZE  %d  ", cpuReqQueue.num()))
         for(i=0; i<queueSize; i = i+1) begin
            cpuReqQueue.get(cpuWrTr);
            if((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5))  begin
                `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP PEND_TR_CPU_QUEUE cReq %s  ", cpuWrTr.reqASprint))
            end
            if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Read == 1'b1) && (readLocked == 0) && (cpuWrTr.transactionTime != cpuRdDataT.transactionTime)) begin
                `ERROR($psprintf(" DEBUG_READ BEFORE_CMP one more Read is Pending Befor curent Read Rsv Read cReq %s  ", cpuWrTr.reqASprint))
            end
            if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Read == 1'b1) && (cpuWrTr.transactionTime == cpuRdDataT.transactionTime)) begin
                readLocked = 1;
                `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP READLOCKED cReq %s  ", cpuWrTr.reqASprint))
            end
            if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Inval == 1'b1) && 
               (cpuWrTr.transactionTime < cpuRdDataT.transactionTime) && (readLocked == 0)&& (flushLocked == 0)) begin
                invalTr = new cpuWrTr;
                invalLocked = 1;
                `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP INVALLOCKED cReq %s  ", invalTr.reqASprint))
            end
            cpuReqQueue.put(cpuWrTr);
         end
         `DEBUG($psprintf(" DEBUG_READ cpuReqQueue No Mem  SIZE  %d  ", cpuReqQueue.num()))
         queueSize = cpuReqQueue.num();
         comuteData[BITDATA-1:0] = WriteByteAll.Data;
         `DEBUG($psprintf(" DEBUG_READ MEMARRYCMP MEM_DATA 0x%x Addr 0x%x ",comuteData[BITDATA-1:0] ,cpuRdAddr[BITADDR-1:0]))
         for(i=0; i<queueSize; i = i+1) begin
            cpuReqQueue.get(cpuWrTr);
            if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Write == 1'b1) && (cpuWrTr.transactionId < cpuRdDataT.transactionId))  begin
                 comuteData[BITDATA-1:0] = computeCacheData(comuteData[BITDATA-1:0],cpuWrTr);
                `DEBUG($psprintf(" DEBUG_READ MEMARRYCMP 1 CPU_TR Pend Wr Tr Before Rd Tr cReq %s  ", cpuWrTr.reqSprint))
            end  // end for comuteReadHit
            if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Write == 1'b1) && (cpuWrTr.transactionId > cpuRdDataT.transactionId))  begin
                `DEBUG($psprintf(" DEBUG_READ MEMARRYCMP 2 CPU_TR Pend Wr Tr After Rd Tr cReq %s  ", cpuWrTr.reqSprint))
            end
            cpuReqQueue.put(cpuWrTr);
         end
         if(cpuRdDataT.Data  == comuteData[BITDATA-1:0]) begin
            readDataMatchWithMemArry = 1'b1;
            `DEBUG($psprintf(" DEBUG_READ MEMARRYCMP Read Data Match With MemArray+WrTr 0x%x ",comuteData[BITDATA-1:0] ))
         end
      end

      /*  if(evictMemArray.exists(cpuRdAddr[BITADDR-1:0])) begin
    	 invalFound = 0;
  	 invalLocked = 0;
  	 readLocked = 0;
           queueSize = cpuReqQueue.num();
           `DEBUG($psprintf(" DEBUG_READ cpuReqQueue SIZE  %d  ", cpuReqQueue.num()))
           for(i=0; i<queueSize; i = i+1) begin
              cpuReqQueue.get(cpuWrTr);
              if((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5))  begin
                  `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP_EVICT PEND_TR_CPU_QUEUE cReq %s  ", cpuWrTr.reqSprint))
              end
              if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Read == 1'b1) && (readLocked == 0) &&
                 (cpuWrTr.transactionTime != cpuRdDataT.transactionTime)) begin
                  `ERROR($psprintf(" DEBUG_READ BEFORE_CMP_EVICT one more Read is Pending Befor curent Read Rsv Read cReq %s  ", cpuWrTr.reqSprint))
              end
              if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Read == 1'b1) && (cpuWrTr.transactionTime == cpuRdDataT.transactionTime)) begin
                  readLocked = 1;
                  `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP_EVICT READLOCKED cReq %s  ", cpuWrTr.reqSprint))
              end
              if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Inval == 1'b1) && 
                 (cpuWrTr.transactionTime < cpuRdDataT.transactionTime) && (readLocked == 0)&& (flushLocked == 0)) begin
                  invalTr = new cpuWrTr;
                  invalLocked = 1;
                  `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP_EVICT INVALLOCKED cReq %s  ", invalTr.reqSprint))
              end
              cpuReqQueue.put(cpuWrTr);
           end
           `DEBUG($psprintf(" DEBUG_READ cpuReqQueue SIZE  %d  ", cpuReqQueue.num()))

           queueSize = cpuReqQueue.num();
           comuteData[BITDATA-1:0] = evictMemArray[cpuRdAddr[BITADDR-1:0]];
           `DEBUG($psprintf(" DEBUG_READ EVICTARRYCMP MEM_DATA 0x%x Addr 0x%x ",comuteData[BITDATA-1:0] ,cpuRdAddr[BITADDR-1:0]))
           for(i=0; i<queueSize; i = i+1) begin
              cpuReqQueue.get(cpuWrTr);
              if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Inval == 1'b1) && (cpuWrTr.transactionId < cpuRdDataT.transactionId))  begin
                   comuteData[BITDATA-1:0] = evictMemArray[cpuRdAddr[BITADDR-1:0]];
                  `DEBUG($psprintf(" DEBUG_READ EVICTARRYCMP INVAL Found. Reseting the Comp Data with Evic Data EVIC_DATA 0x%x  cReq %s  ",comuteData[BITDATA-1:0], cpuWrTr.reqSprint))
              end  // end for comuteReadHit
              if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Write == 1'b1) && (cpuWrTr.transactionId < cpuRdDataT.transactionId))  begin
                   comuteData[BITDATA-1:0] = computeCacheData(comuteData[BITDATA-1:0],cpuWrTr);
                  `DEBUG($psprintf(" DEBUG_READ EVICTARRYCMP 1 CPU_TR Pend Wr Tr Before Rd Tr cReq %s  ", cpuWrTr.reqSprint))
              end  // end for comuteReadHit
              if(((cpuWrTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuWrTr.Write == 1'b1) && (cpuWrTr.transactionId > cpuRdDataT.transactionId))  begin
                  `DEBUG($psprintf(" DEBUG_READ EVICTARRYCMP 2 CPU_TR Pend Wr Tr After Rd Tr cReq %s  ", cpuWrTr.reqSprint))
              end
              cpuReqQueue.put(cpuWrTr);
           end
           if(cpuRdDataT.Data  == comuteData[BITDATA-1:0]) begin
              readDataMatchWithEvictMem = 1'b1;
           end
        end*/

       queueSize = cpuReqQueue.num();
       for(j=0;j<queueSize; j = j+1) begin
         cpuReqQueue.get(cpuRdTr);
         if(((cpuRdTr.Addr >> 5) == (cpuRdDataT.Addr >> 5)) && (cpuRdTr.Read == 1'b1) && (cpuRdTr.transactionTime == cpuRdDataT.transactionTime))  begin
             `DEBUG($psprintf(" DEBUG_READ Removeing RdTr from CpuQueue %s  %0t  %0t  ", cpuRdTr.reqSprint,cpuRdTr.transactionTime,cpuRdDataT.transactionTime))
         end else begin
            cpuReqQueue.put(cpuRdTr);
         end
       end


        if((IARFound == 1'b1) && (WBRFound == 1'b0) && (RBRFound == 1'b0) && (WARFound == 1'b0) && (RARFound == 1'b0) ) begin
            if(memArray.exists(cpuRdAddr[BITADDR-1:0]) || evictMemArray.exists(cpuRdAddr[BITADDR-1:0]) || InvalArray.exists(cpuRdAddr[BITADDR-1:0]))  begin
               evictMemArray.delete(cpuRdAddr[BITADDR-1:0]);
               memArray.delete(cpuRdAddr[BITADDR-1:0]);
               InvalArray.delete(cpuRdAddr[BITADDR-1:0]);
               `DEBUG($psprintf(" DEBUG_READ. RM_MEM IARFound  time %t   ", IARTr.transactionTime))
               `DEBUG($psprintf(" DEBUG_READ. RM_MEM After Read Inval found. Removeing all Mem's. time %t Read req %s  ", $time,cpuRdTr.reqSprint))
               if(memArray.exists(cpuRdAddr[BITADDR-1:0]) || evictMemArray.exists(cpuRdAddr[BITADDR-1:0]) || InvalArray.exists(cpuRdAddr[BITADDR-1:0]))  begin
                 `ERROR($psprintf(" DEBUG_READ. RM_MEM  MEM not delete. Addr 0x%x",cpuRdAddr[BITADDR-1:0] ))
               end
            end else begin
                 `ERROR($psprintf(" DEBUG_READ. RM_MEM  MEM not FOUND. Addr 0x%x",cpuRdAddr[BITADDR-1:0] ))
            end
        end

        if(readDataMatchWithMemArry == 1'b1)
            `INFO($psprintf(" CPU_CHECK CACHE_READ_PASS  Data Match With L2 Mem %s  ", cpuRdDataT.reqSprint))
        if(readDataMatchWithEvictMem == 1'b1)
            `INFO($psprintf(" CPU_CHECK CACHE_READ_PASS  Data Match With Evict Mem %s  ", cpuRdDataT.reqSprint))
        if(readDataMatchWithInvalMem == 1'b1)
            `INFO($psprintf(" CPU_CHECK CACHE_READ_PASS  Data Match With  Inval mem %s  ", cpuRdDataT.reqSprint))
        if(l2ErrorDetected == 1'b1)
            `INFO($psprintf(" CPU_CHECK CACHE_READ_PASS  L2 Error Detaected %s  ", cpuRdDataT.reqSprint))
        if(memErrorDetected == 1'b1)
            `INFO($psprintf(" CPU_CHECK CACHE_READ_PASS  L2 Error Detaected %s  ", cpuRdDataT.reqSprint))
        if(readDataMatchWithMemArry || readDataMatchWithEvictMem || readDataMatchWithInvalMem || l2ErrorDetected || memErrorDetected)  begin
              `INFO($psprintf(" CPU_CHECK CACHE_READ_PASS ceq %s",cpuRdDataT.reqSprint))
        end else begin
              `TB_YAP($psprintf(" DEBUG_FILL_FAIL 2"))
              `TB_YAP($psprintf(" CACHE Read data is not Valid. Read Data is not Mach with Cache  Data"))
              `TB_YAP($psprintf(" CPU Read  TR cReq %s  ", cpuRdDataT.reqSprint))
              `TB_YAP($psprintf(" CPU RD Data 0x%x  ", cpuRdDataT.Data))
              `ERROR($psprintf(" =======CPU READ MISMACH =============="))
        end
   end  // end while
endtask

task writeCheckTask;
  CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) cpuWrTr;
  CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) l2WrTr;
  CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) cpuEvictWrTr;
  CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) cpuWrRdTr;
  CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) evictTr;
  CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) IAWTr;
  integer hitSize,i,queueSize;
  bit EvictDataMatch;
  bit EvictDataMatchWithInval;
  bit RemoveFlushInvalFromQueue;
  bit EvictDataMatchWithFlushRemoveWrTr;
  mailbox evictCheckQueue;
  reg[BITDATA-1:0]comuteData;
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
     EvictDataMatchWithInval  =0;
     RemoveFlushInvalFromQueue  =0;
     EvictDataMatchWithFlushRemoveWrTr  =0;
     WBWFound  =0;
     RBWFound  =0;
     WAWFound  =0;
     RAWFound  =0;
     IAWFound  =0;
     invalFoundAfterWr = 0;
     `DEBUG($psprintf(" DEBUG_EVICT L2_TR ----------->  cReq %s  ", l2WrTr.reqSprint))
      evictCheckQueue = new();
      queueSize = cpuReqQueue.num();
      for(i=0; i<queueSize; i = i+1) begin
           cpuReqQueue.get(cpuWrTr);
              if(((cpuWrTr.Addr >> 5) == (l2WrTr.Addr >> 5))  )  begin
                evictTr = new cpuWrTr;
               `DEBUG($psprintf(" DEBUG_EVICT SAME ADDRESS All Req  %s  ", evictTr.reqASprint))
                evictCheckQueue.put(evictTr);
              end
           cpuReqQueue.put(cpuWrTr);
      end
      `DEBUG($psprintf(" DEBUG_EVICT evictCheckQueue CNT  %d  ", evictCheckQueue.num))
      lockSet = 0;
      queueSize = evictCheckQueue.num();
      for(i=0; i<queueSize; i = i+1) begin
           evictCheckQueue.get(evictTr);
           if((evictTr.Write == 1'b1) || (evictTr.Read == 1'b1) )  begin
              lockSet = 1;
           end
           if(lockSet == 1) begin
                evictCheckQueue.put(evictTr);
           end else begin
              `DEBUG($psprintf(" DEBUG_EVICT Removeing Inital INVAL/FLUSH from evictCheckQueue creq  %s  ", evictTr.reqASprint))
           end
      end
      `DEBUG($psprintf(" DEBUG_EVICT evictCheckQueue CNT  %d  ", evictCheckQueue.num))


     if(memArray.exists(l2WrTr.Addr))  begin
        queueSize = evictCheckQueue.num();
        comuteData[BITDATA-1:0] = memArray[l2WrTr.Addr];
        `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP Mem Exists memArray Data 0x%32h  %h", comuteData[BITDATA-1:0],l2WrTr.Addr))
         for(i=0; i<queueSize; i = i+1) begin
            evictCheckQueue.get(cpuWrTr);
            if(((cpuWrTr.Addr >> 5) == (l2WrTr.Addr >> 5)) && (cpuWrTr.Inval == 1'b1) && (EvictDataMatch == 0))  begin
                  invalFoundAfterWr = 1;
                 comuteData[BITDATA-1:0] = memArray[l2WrTr.Addr];
                 `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP INVAL FOUND Load Mem Array Data 0x%32h  0x%h", comuteData[BITDATA-1:0],l2WrTr.Addr))
                `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP INVAL REQ is   %s  ", cpuWrTr.reqASprint))
            end
            if(((cpuWrTr.Addr >> 5) == (l2WrTr.Addr >> 5)) && (cpuWrTr.Write == 1'b1) && (EvictDataMatch == 1))  begin
                `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP 2 Pend Wr Tr After Evict Wr Tr  %s  ", cpuWrTr.reqASprint))
            end
            if(((cpuWrTr.Addr >> 5) == (l2WrTr.Addr >> 5)) && (cpuWrTr.Write == 1'b1) && (EvictDataMatch == 0))  begin
              `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP 1 Pend Wr Tr Before Evict Wr Tr  %s  ", cpuWrTr.reqASprint))
               comuteData[BITDATA-1:0] = computeCacheData(comuteData[BITDATA-1:0],cpuWrTr);
               invalFoundAfterWr = 0;
               if(comuteData[BITDATA-1:0] == l2WrTr.Data) begin
                  EvictDataMatch = 1'b1;
                  evictMemArray[l2WrTr.Addr] = l2WrTr.Data;
                  memArray.delete(l2WrTr.Addr);
                  cpuEvictWrTr = new cpuWrTr;
                 `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP DATA MATCH %s  ", cpuEvictWrTr.reqSprint))
                 `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP Addr 0x%x DATA 0x%x  ",l2WrTr.Addr, l2WrTr.Data))
                 `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP Addr 0x%x DATA 0x%x  ",l2WrTr.Addr, comuteData[BITDATA-1:0]))
               end 
            end  else begin
               evictCheckQueue.put(cpuWrTr);
            end // end for comuteReadHit
         end  // end for

         if(EvictDataMatch == 1) begin
         queueSize = cpuReqQueue.num();
             for(i=0; i<queueSize; i = i+1) begin
                cpuReqQueue.get(cpuWrTr);
                if(((cpuWrTr.Addr >> 5) == (cpuEvictWrTr.Addr >> 5)) && (cpuWrTr.Read != 1'b1) && (cpuWrTr.transactionTime <= cpuEvictWrTr.transactionTime))  begin
                   `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP Remove Tr from cpuReqQueue Queue %s  ", cpuWrTr.reqASprint))
                end else begin
                   cpuReqQueue.put(cpuWrTr);
                end
             end
         end
     end


     if((!(memArray.exists(l2WrTr.Addr))) && (EvictDataMatch == 1'b0)) begin
        queueSize = evictCheckQueue.num();
        comuteData[BITDATA-1:0] = {BITDATA{1'b0}};
        `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP Not Exists memArray Data 0x%32h  %h", comuteData[BITDATA-1:0],l2WrTr.Addr))
         for(i=0; i<queueSize; i = i+1) begin
            evictCheckQueue.get(cpuWrTr);
            if(((cpuWrTr.Addr >> 5) == (l2WrTr.Addr >> 5)) && (cpuWrTr.Inval == 1'b1) && (EvictDataMatch == 0))  begin
                  invalFoundAfterWr = 1;
                 comuteData[BITDATA-1:0] = {BITDATA{1'b0}};
                 `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP NME  INVAL FOUND Load Mem Array Data 0x%32h  0x%h", comuteData[BITDATA-1:0],l2WrTr.Addr))
                `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP NME INVAL REQ is   %s  ", cpuWrTr.reqSprint))
            end
            if(((cpuWrTr.Addr >> 5) == (l2WrTr.Addr >> 5)) && (cpuWrTr.Write == 1'b1) && (EvictDataMatch == 1))  begin
                `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP NME 2 Pend Wr Tr After Evict Wr Tr  %s  ", cpuWrTr.reqSprint))
            end
            if(((cpuWrTr.Addr >> 5) == (l2WrTr.Addr >> 5)) && (cpuWrTr.Write == 1'b1) && (EvictDataMatch == 0))  begin
              `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP NME 1 Pend Wr Tr Before Evict Wr Tr  %s  ", cpuWrTr.reqSprint))
               comuteData[BITDATA-1:0] = computeCacheData(comuteData[BITDATA-1:0],cpuWrTr);
               invalFoundAfterWr = 0;
               if(comuteData[BITDATA-1:0] == l2WrTr.Data) begin
                  EvictDataMatch = 1'b1;
                  evictMemArray[l2WrTr.Addr] = l2WrTr.Data;
                  memArray.delete(l2WrTr.Addr);
                  cpuEvictWrTr = new cpuWrTr;
                 `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP NME DATA MATCH %s  ", cpuEvictWrTr.reqSprint))
                 `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP NME Addr 0x%x DATA 0x%x  ",l2WrTr.Addr, evictMemArray[l2WrTr.Addr]))
               end 
            end  else begin
               evictCheckQueue.put(cpuWrTr);
            end // end for comuteReadHit
         end  // end for

         if(EvictDataMatch == 1) begin
         queueSize = cpuReqQueue.num();
             for(i=0; i<queueSize; i = i+1) begin
                cpuReqQueue.get(cpuWrTr);
                if(((cpuWrTr.Addr >> 5) == (cpuEvictWrTr.Addr >> 5)) && (cpuWrTr.Read != 1'b1) && (cpuWrTr.transactionTime <= cpuEvictWrTr.transactionTime))  begin
                   `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP NME Remove Tr from cpuReqQueue Queue %s  ", cpuWrTr.reqASprint))
                end else begin
                   cpuReqQueue.put(cpuWrTr);
                end
             end
         end
     end



     if(EvictDataMatch == 1)  begin
       queueSize = cpuReqQueue.num();
       for(i=0; i<queueSize; i = i+1) begin
          cpuReqQueue.get(cpuWrTr);
              if(((cpuWrTr.Addr >> 5) == (cpuEvictWrTr.Addr >> 5)) && (cpuWrTr.Write == 1'b1) && (cpuWrTr.transactionTime < cpuEvictWrTr.transactionTime))  begin
                  WBWFound = 1;
                 `DEBUG($psprintf(" DEBUG_EVICT  TRCHECK WBWFound cReq %s  ", cpuWrTr.reqASprint))
              end
              if(((cpuWrTr.Addr >> 5) == (cpuEvictWrTr.Addr >> 5)) && (cpuWrTr.Read == 1'b1) && (cpuWrTr.transactionTime < cpuEvictWrTr.transactionTime))  begin
                  RBWFound = 1;
                 `DEBUG($psprintf(" DEBUG_EVICT  TRCHECK WBWFound cReq %s  ", cpuWrTr.reqASprint))
              end
              if(((cpuWrTr.Addr >> 5) == (cpuEvictWrTr.Addr >> 5)) && (cpuWrTr.Write == 1'b1) && (IAWFound == 0) && (cpuWrTr.transactionTime > cpuEvictWrTr.transactionTime))  begin
                  WAWFound = 1;
                 `DEBUG($psprintf(" DEBUG_EVICT  TRCHECK WAWFound cReq %s  ", cpuWrTr.reqASprint))
              end
              if(((cpuWrTr.Addr >> 5) == (cpuEvictWrTr.Addr >> 5)) && (cpuWrTr.Read == 1'b1) && (IAWFound == 0) && (cpuWrTr.transactionTime > cpuEvictWrTr.transactionTime))  begin
                  RAWFound = 1;
                 `DEBUG($psprintf(" DEBUG_EVICT  TRCHECK RAWFound cReq %s  ", cpuWrTr.reqASprint))
              end
              if(((cpuWrTr.Addr >> 5) == (cpuEvictWrTr.Addr >> 5)) && (cpuWrTr.Inval == 1'b1) && (WAWFound == 0) && (RAWFound == 0) && (cpuWrTr.transactionTime > cpuEvictWrTr.transactionTime))  begin
                  IAWFound = 1;
                  IAWTr = new cpuWrTr; 
                 `DEBUG($psprintf(" DEBUG_EVICT  TRCHECK IAWFound cReq %s  ", cpuWrTr.reqASprint))
              end
          cpuReqQueue.put(cpuWrTr);
       end
     end

     `DEBUG($psprintf(" DEBUG_READ  WBWFound %d RBWFound %d WAWFound %d RAWFound %d IAWFound %d  ",WBWFound,RBWFound,WAWFound,RAWFound,IAWFound ))
      if((IAWFound == 1'b1) && (WBWFound == 1'b0) && (RBWFound == 1'b0) && (WAWFound == 1'b0) && (RAWFound == 1'b0)) begin
        if(memArray.exists(l2WrTr.Addr) || evictMemArray.exists(l2WrTr.Addr) || InvalArray.exists(l2WrTr.Addr))  begin
           evictMemArray.delete(l2WrTr.Addr);
           memArray.delete(l2WrTr.Addr);
           InvalArray.delete(l2WrTr.Addr);
           `DEBUG($psprintf(" DEBUG_READ. RM_MEM IAWFound  time %t   ", IAWTr.transactionTime))
           `DEBUG($psprintf(" DEBUG_READ. RM_MEM After Write Inval found. Removeing all Mem's. time %t Read req %s  ", $time,l2WrTr.reqSprint))
           if(memArray.exists(l2WrTr.Addr) || evictMemArray.exists(l2WrTr.Addr) || InvalArray.exists(l2WrTr.Addr))  begin
             `ERROR($psprintf(" DEBUG_READ. RM_MEM  MEM not delete. Addr 0x%x", l2WrTr.Addr))
           end
        end else begin
            `ERROR($psprintf(" DEBUG_READ. RM_MEM  MEM not exists Addr 0x%x", l2WrTr.Addr))
        end
      end
/*
*/

      // removening INVAL and FLUSH in Que after Write
      begin
      queueSize = cpuReqQueue.num();
      cpuWrRdTr = new();
      `DEBUG($psprintf(" DEBUG_EVICT Removeing Flush/Inval From Queue Started"))
      for(i=0; i<queueSize; i = i+1) begin
           cpuReqQueue.get(cpuWrTr);
           if(((cpuWrTr.Addr >> 5) == (l2WrTr.Addr >> 5)) && ((cpuWrTr.Inval == 1'b1)) && (RemoveFlushInvalFromQueue == 0))  begin
               `DEBUG($psprintf(" DEBUG_EVICT Removeing Flush/Inval From Queue %s  ", cpuWrTr.reqSprint))
           end else if(((cpuWrTr.Addr >> 5) == (l2WrTr.Addr >> 5)) && ((cpuWrTr.Write == 1'b1) || (cpuWrTr.Read == 1'b1)) && (RemoveFlushInvalFromQueue == 0))  begin
               `DEBUG($psprintf(" DEBUG_EVICT Not Removeing Flush/Inval From Queue %s  ", cpuWrTr.reqSprint))
               cpuReqQueue.put(cpuWrTr);
               RemoveFlushInvalFromQueue = 1;
           end else begin
               cpuReqQueue.put(cpuWrTr);
           end
      end // end for
       end // end begin

          if(EvictDataMatch == 1)
             `DEBUG($psprintf(" CACHE_EVICT DATA_MATCH_PASS Data Match With EvictMem Creq %s",l2WrTr.reqSprint ))
          if((EvictDataMatch == 1))  begin
             `DEBUG($psprintf(" CACHE EVICT DATA MATCH Addr 0x%x",l2WrTr.Addr ))
          end else begin
                      `TB_YAP($psprintf(" CACHE EVICT DATA NOT MATCH "))
                      `TB_YAP($psprintf(" L2 EVICT   TR cReq %s  ", l2WrTr.reqSprint))
                      `TB_YAP($psprintf(" L2 EVICT    Data 0x%x  ", l2WrTr.Data))
                      `ERROR($psprintf(" =======CPU WRITE MISMACH =============="))
          end

  end  // end while
endtask

function reg [BITDATA-1:0]computeCacheData(input [BITDATA-1:0] cacheData,CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) penTr);
reg[BITDATA-1:0] inData;
reg [7:0] inArray[NUMBYLN];
reg [7:0] cacheArray[NUMBYLN];
reg [7:0] tempArray[NUMBYLN];
reg [BITDATA-1:0] tempData;
integer m,n; 
    inData[BITDATA-1:0] = penTr.Data;
    for (m = 0; m <NUMBYLN ; m = m+1) begin
        inArray[m] = inData[BITDATA-1:0] >> m*8;
        cacheArray[m] = cacheData[BITDATA-1:0] >> m*8;
    end 

    tempData[BITDATA-1:0] = {BITDATA{1'b0}};
    for(n=0;n<NUMBYLN ;n = n+1) begin
       tempArray[n] = (penTr.ByteEn[n] == 1'b1) ? inArray[n] : cacheArray[n];
    end

    for(n=31;n>=0 ;n = n-1) begin
       tempData[BITDATA-1:0] = (tempData[BITDATA-1:0] | tempArray[n] << n*8);
    end

    //tempData[BITDATA-1:0] = penTr.Data;
    computeCacheData[BITDATA-1:0] = tempData[BITDATA-1:0];
endfunction:computeCacheData

task sendRequest();
  reg [ROWADDRBITS-1:0]rowAddr;
  reg [ROWADDRBITS-1:0]rowAddrArry[5];
  reg [BYTEADDBITS-1:0]byteAddr;
  reg [TAGADDRBITS-1:0] tagAddr;
  reg [3:0]tagRandomAddr;
  reg [BITADDR-1:0]reqAddr;
  reg [BITADDR-1:0]memAddr;
  reg [BITDATA-1:0]wrData;
  reg [1:0]reqType;
  reg [31:0]loopCount = 50000;
  reg [31:0]loopCount1;
  bit byteSizeDone =0;
  bit nonCacheAddr;
  bit ackEn = 0;
  integer i,j;
  reg [2:0]cattr;
  bit enableL2Error;
  bit byteEnSel;
  CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) cpuReqT;
  begin
       rowAddrArry[1] = 4;
       rowAddrArry[0] = 4; 
       rowAddrArry[2] = 4;
       rowAddrArry[3] = 4;
       rowAddrArry[4] = 4;
       for(i=0; i<5; i = i+1) begin
             `TB_YAP($psprintf("TestbenchReq rowAddrArry[%d] = %d  ", i,rowAddrArry[i]))
       end
       while(loopCount[31:0] !=0) begin
          cpuReqT = new();
          loopCount1[31:0] = loopCount1[31:0] + 1;
          tagRandomAddr[3:0] = $urandom_range(1,13);
          byteAddr[BYTEADDBITS-1:0] = 'h0;
          tagAddr[TAGADDRBITS-1:0] = 'h0;
          byteSizeDone = 0;
          rowAddr[6:0] = rowAddrArry[$urandom_range(0,4)];
          reqAddr[BITADDR-1:0] = {tagAddr[TAGADDRBITS-1:4],tagRandomAddr[3:0],rowAddr[ROWADDRBITS-1:0],byteAddr[BYTEADDBITS-1:0]};
          if((loopCount1[31:0]%1000) < 500)  begin
             reqType[1:0] =  $urandom_range(1,3); 
          end else begin
             reqType[1:0] =  $urandom_range(1,2); 
          end
          if(reqType[1:0] == 1) begin  // Write req
           cpuReqT.Addr = reqAddr[BITADDR-1:0];
   	   cpuReqT.Write = 1'b1;
           cpuReqT.Read  = 1'b0;
           cpuReqT.Inval = 1'b0;
           cpuReqT.valid = 1'b1;
           //cpuReqT.ByteEn =  {NUMBYLN{1'b1}};
           byteEnSel = $urandom_range(0,1);
           cpuReqT.ByteEn =  (byteEnSel == 1'b1) ? $urandom_range(1,{NUMBYLN{1'b1}}) : {NUMBYLN{1'b1}};
           wrData[BITDATA-1:0] = randomDataWithAddr(BITDATA,reqAddr[BITADDR-1:0]);
           cpuReqT.Data =  wrData[BITDATA-1:0];
          end else if (reqType[1:0] == 2)  begin
           cpuReqT.Addr = reqAddr[BITADDR-1:0];
   	   cpuReqT.Write = 1'b0;
           cpuReqT.Read  = 1'b1;
           cpuReqT.Inval = 1'b0;
           cpuReqT.valid = 1'b1;
           cpuReqT.ByteEn =  {NUMBYLN{1'b1}};
           wrData[BITDATA-1:0] = randomDataWithAddr(BITDATA,reqAddr[BITADDR-1:0]);
           cpuReqT.Data =  'h0;
          end else if (reqType[1:0] == 3)  begin
           cpuReqT.Addr = {reqAddr[BITADDR-1:5],5'h0};
   	   cpuReqT.Write = 1'b0;
           cpuReqT.Read  = 1'b0;
           cpuReqT.Inval = 1'b1;
           cpuReqT.valid = 1'b1;
           cpuReqT.ByteEn =  {NUMBYLN{1'b1}};
           wrData[BITDATA-1:0] = randomDataWithAddr(BITDATA,reqAddr[BITADDR-1:0]);
           cpuReqT.Data =  'h0;
          end
          mstTr[0].send(cpuReqT);
          loopCount[31:0] = loopCount[31:0] - 1; 
       end
  end
endtask :sendRequest


task isEmpty();
    bit isEmptyMstIdArry;
    begin
       isEmptyMstIdArry = 0;
       while(isEmptyMstIdArry == 0) begin
          clock(1000);
          isEmptyMstIdArry = mstTr[0].isEmptyidArray() && isEmptyCpuRdMonQueueMailBox()  &&  mstTr[0].isEmptyReqMailBox();
       end
          `INFO($psprintf("isEmpty  isEmptyMstIdArry %d ",isEmptyMstIdArry))
    end
endtask:isEmpty



function isEmptyCpuRdMonQueueMailBox;
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
          `INFO($psprintf("cpuRdMonQueue  Count %d  isEmptyMailBox %d ",reqQueueCount,isEmptyMailBox))
      isEmptyCpuRdMonQueueMailBox = isEmptyMailBox;
end 
endfunction:isEmptyCpuRdMonQueueMailBox


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

endclass:CacheTestBench
`endif
