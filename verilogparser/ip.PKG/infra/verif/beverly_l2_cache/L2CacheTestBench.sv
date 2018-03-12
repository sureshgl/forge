`ifndef L2_CACHE_TEST_BENCH
`define L2_CACHE_TEST_BENCH
class L2CacheTestBench #(int NXADDRWIDTH=31, int NXDATAWIDTH=256, int NXTYPEWIDTH=3, int NXSIZEWIDTH=8, int NXATTRWIDTH=3,int NOMSTP = 1, int NOSLVP = 1,int NUMWAYS = 4, int NUMROWS = 128,int XBITSEQ = 5, int YBITSEQ=4 ) extends MeTransactor;


   localparam BYTEADDBITS = 5;
   localparam BEETADDBITS = 3;
   localparam ROWADDRBITS = 9;

   localparam BYTEBITS = 5;
   localparam BEATBITS = 4;
   localparam INDEXBITS = 8;
   localparam TAGADDRBITS = NXADDRWIDTH - ROWADDRBITS - BEETADDBITS - BYTEADDBITS;
   localparam TAGBITS = NXADDRWIDTH - INDEXBITS - BEATBITS - BYTEBITS;

   string name;
   integer i,j;
   L2CacheMasterTransactor#(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) mstTr[NOMSTP];
   L2CacheSlaveTransactor#(NXADDRWIDTH,NXDATAWIDTH,YBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) slvTr[NOSLVP];
   virtual Misc_Ifc misc_ifc;
   virtual Naxi_Ifc  #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH)  mAxiIfc[NOMSTP];
   virtual Naxi_Ifc  #(NXADDRWIDTH,NXDATAWIDTH,YBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH)  sAxiIfc[NOSLVP];

   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuWrRspT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,YBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2RdAMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,YBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2WrMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuRdRspT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,YBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) outOfOrdrQueue[$];
   integer                       RESET_CYCLE_COUNT = 20;
   integer                       TIMEOUT_CYCLE_COUNT = 30;
   integer                       DONE_CYCLE_COUNT = 50; // num empty cycles to call done
   reg [255:0]dataSend;
   mailbox cpuReqQueue;
   mailbox monCpuRdRspQueue;
   mailbox evictCheckQueue; 
   mailbox monL2WrRspQueue; 
   reg [NXDATAWIDTH-1 :0] memArray[*];
   reg [NXDATAWIDTH-1 :0] memArrayOld[*];
   reg [NXDATAWIDTH-1 :0] evictMemArray[*];
   reg [NXDATAWIDTH-1 :0] evictMemArrayOld[*];
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) ReadMatchArray[*];
   bit outOfOrderRspEn;
   bit outOfOrderDis;
   reg [63:0]l2ReadTrReceived;
   function new (string name); begin
     super.new(name);
     this.name = name;
     cpuReqQueue = new();
     monCpuRdRspQueue = new();
     monL2WrRspQueue = new();
     `DEBUG($psprintf("Function New   "))

     for(i=0; i<NOMSTP; i = i+1) begin
       mstTr[i] = new($psprintf("mstTr[%d]",i));
     end 
     for(i=0; i<NOSLVP; i = i+1) begin
       slvTr[i] = new($psprintf("slvTr[%d]",i));
     end
     dataSend = 1;
     outOfOrderRspEn = 0;
     outOfOrderDis = 1;
     l2ReadTrReceived = 0;
   end
  endfunction:new

   task init (virtual Misc_Ifc misc_ifc,  virtual Naxi_Ifc#(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) mAxiIfc[NOMSTP],virtual Naxi_Ifc#(NXADDRWIDTH,NXDATAWIDTH,YBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) sAxiIfc[NOSLVP]);begin 
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
       join_none
     end
  endtask:drive


   task monitor(); begin
      `DEBUG($psprintf("Task Monitor"))
      fork
         monCpuWrRsp();
         monCpuRdRsp();
         monl2WrReq();
         monl2RdAddReq();
         sendL2RdRsp();
         monCpuReq();
         readCheckTask();
         writeCheckTask();
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

   task monCpuReq(); begin
       L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqTr;
       L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReq;
       reg [2:0]beetStart;
      reg [NXADDRWIDTH-1:0] addr;
       integer i,j;
       while(1) begin
         mstTr[0].reqMonQueue.get(cpuReqTr);
           j = cpuReqTr.beetStart;
           beetStart[2:0] = cpuReqTr.addr >> 5;
           //if((cpuReqTr.noBeets%2 != 0 ) && (beetStart[0] == 1) && (cpuReqTr.reqType != CH_READ)) begin
           if( (beetStart[0] == 1) && (cpuReqTr.reqType != CH_READ)) begin
              cpuReq = new();
              cpuReq.addr = {(cpuReqTr.addr >> 8),beetStart[2:1],6'h0};
              cpuReq.data[0]   = 'h0;
              cpuReq.byteEn[0] = 'h0;
              cpuReq.reqType     = cpuReqTr.reqType;
              cpuReq.cattr     = cpuReqTr.cattr;
              cpuReq.dattr     = cpuReqTr.dattr;
              cpuReq.cId     = cpuReqTr.cId;
              cpuReq.dId     = cpuReqTr.dId;
              cpuReq.rId     = cpuReqTr.rId;
              cpuReq.transactionTime= cpuReqTr.transactionTime;
              cpuReq.transactionId= cpuReqTr.transactionId;
              cpuReqQueue.put(cpuReq);
              `TB_YAP($psprintf("monCpuReq START %s  ",cpuReq.creqSprint))
           end
           for(i=0; i <cpuReqTr.noBeets; i = i+1) begin
              cpuReq = new();
              addr[NXADDRWIDTH-1:0] = {((cpuReqTr.addr >> 5) + i[3:0]),5'h0};
              cpuReq.addr = addr;
              cpuReq.data[0]   = cpuReqTr.data[j];
              cpuReq.byteEn[0] = cpuReqTr.byteEn[j];
              cpuReq.reqType     = cpuReqTr.reqType;
              cpuReq.cattr     = cpuReqTr.cattr;
              cpuReq.dattr     = cpuReqTr.dattr;
              cpuReq.cId     = cpuReqTr.cId;
              cpuReq.dId     = cpuReqTr.dId;
              cpuReq.rId     = cpuReqTr.rId;
              cpuReq.BeetNumber = i;
              cpuReq.transactionTime= cpuReqTr.transactionTime;
              cpuReq.transactionId= cpuReqTr.transactionId;
              if(!(( cpuReq.cattr == 'h2) && (cpuReqTr.reqType == CH_READ)))begin
                 cpuReqQueue.put(cpuReq);
              end
              j = j + 1;
              `TB_YAP($psprintf("monCpuReq[%0d] %s  ",i,cpuReq.creqSprint))
           end
           if((cpuReqTr.noBeets%2 == 1 ) && (beetStart[0] == 0) && (cpuReqTr.reqType != CH_READ)) begin
              cpuReq = new();
              cpuReq.addr = {addr[NXADDRWIDTH-1:6],1'b1,5'h0};
              cpuReq.data[0]   = 'h0;
              cpuReq.byteEn[0] = 'h0;
              cpuReq.reqType     = cpuReqTr.reqType;
              cpuReq.cattr     = cpuReqTr.cattr;
              cpuReq.dattr     = cpuReqTr.dattr;
              cpuReq.cId     = cpuReqTr.cId;
              cpuReq.dId     = cpuReqTr.dId;
              cpuReq.rId     = cpuReqTr.rId;
              cpuReq.transactionTime= cpuReqTr.transactionTime;
              cpuReq.transactionId= cpuReqTr.transactionId;
              cpuReqQueue.put(cpuReq);
              `TB_YAP($psprintf("monCpuReq END1 %s  ",cpuReq.creqSprint))
           end
           if((cpuReqTr.noBeets%2 == 0 ) && (beetStart[0] == 1) && (cpuReqTr.reqType != CH_READ)) begin
              cpuReq = new();
              cpuReq.addr = {addr[NXADDRWIDTH-1:6],1'b1,5'h0};
              cpuReq.data[0]   = 'h0;
              cpuReq.byteEn[0] = 'h0;
              cpuReq.reqType     = cpuReqTr.reqType;
              cpuReq.cattr     = cpuReqTr.cattr;
              cpuReq.dattr     = cpuReqTr.dattr;
              cpuReq.cId     = cpuReqTr.cId;
              cpuReq.dId     = cpuReqTr.dId;
              cpuReq.rId     = cpuReqTr.rId;
              cpuReq.transactionTime= cpuReqTr.transactionTime;
              cpuReq.transactionId= cpuReqTr.transactionId;
              cpuReqQueue.put(cpuReq);
              `TB_YAP($psprintf("monCpuReq END2 %s  ",cpuReq.creqSprint))
           end
       end
    end
   endtask:monCpuReq

   task monCpuWrRsp();begin
       integer queueSize,j;
       L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuWrErrRspTr;
       while(1) begin
          cpuWrRspT = new();
          cpuWrRspT.data[0] = 0;
          mstTr[0].writeRspReceive(cpuWrRspT);
         `DEBUG($psprintf("monCpuWrRsp cReq %s  ", cpuWrRspT.rreqSprint))
       end
     end
   endtask:monCpuWrRsp

   task monCpuRdRsp();begin
     L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rdRspT;
     integer i,j;
     reg [NXADDRWIDTH-1:0]rdAddr;
     reg [3:0]numBeets;
     reg [3:0]startBeet;
      while(1) begin
         cpuRdRspT = new();
         cpuRdRspT.data[0] = 0;
         mstTr[0].readDataReceive(cpuRdRspT);
         `TB_YAP($psprintf("monCpuRdRsp cReq %s  ", cpuRdRspT.creqSprint))
          numBeets = cpuRdRspT.noBeets;
          rdAddr   = {(cpuRdRspT.addr >> 5),5'h0};
          startBeet = cpuRdRspT.addr[7:5];
          for(i=0; i<numBeets; i = i+1) begin
             rdRspT = new();
             rdRspT.addr = rdAddr[NXADDRWIDTH-1:0] + {i[3:0],5'h0};
             rdRspT.data[0] = cpuRdRspT.data[i];
             rdRspT.byteEn[0]= cpuRdRspT.byteEn[startBeet];
             rdRspT.transactionTime= cpuRdRspT.transactionTime;
             rdRspT.transactionId= cpuRdRspT.transactionId;
             rdRspT.cId= cpuRdRspT.cId;
             startBeet[3:0] = startBeet[3:0] + 1'b1;
             monCpuRdRspQueue.put(rdRspT);
         `TB_YAP($psprintf("monCpuRdRsp[%0d] cReq %s  ", i,rdRspT.creqSprint))
          end
      end
    end
   endtask:monCpuRdRsp


   task monl2WrReq();begin
      L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,YBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2WrMonT1;
      L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,YBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) wrRspT;
      reg [NXDATAWIDTH-1:0]wrData;
      reg [NXADDRWIDTH-1:0]evictAddr;
      reg [3:0]numBeets;
      reg [3:0]startBeet;
      integer i,j;
      while(1) begin
         l2WrMonT = new();
         slvTr[0].wrReceive(l2WrMonT);
         `TB_YAP($psprintf("monl2WrReq cReq %s  ", l2WrMonT.creqSprint))
         evictAddr[NXADDRWIDTH-1:0] = l2WrMonT.addr;
         j[2:0] = evictAddr[7:5];
          for(i=0; i<2; i = i+1) begin
             wrRspT = new();
             wrRspT.addr = {evictAddr[NXADDRWIDTH-1:8], j[2:0],5'h0};
             wrRspT.data[0] = l2WrMonT.data[i];
             wrRspT.byteEn[0]= {32{1'b1}};
             wrRspT.transactionTime= l2WrMonT.transactionTime;
             wrRspT.transactionId= l2WrMonT.transactionId;
             monL2WrRspQueue.put(wrRspT);
             j[2:0] = j[2:0] +1;
         `DEBUG($psprintf("monL2WrRspQueue[%0d] cReq %s  ", i,wrRspT.creqSprint))
         `DEBUG($psprintf("monL2WrRspQueue[%0d] cReq %s  ", i,wrRspT.rreqSprint))
          end
      end
     end
   endtask:monl2WrReq


   task monl2RdAddReq();begin
      L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,YBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2RsvRdReq;
      reg [NXDATAWIDTH-1:0]wrData;
      reg [NXADDRWIDTH-1:0]memAddr;
      bit pushFBSel;
      while(1) begin
         l2RdAMonT = new();
         l2RdAMonT.data[0] = 0;
         slvTr[0].rdAddReceive(l2RdAMonT);
         `TB_YAP($psprintf("monl2RdAddReq cReq %s  ", l2RdAMonT.creqSprint))
          l2ReadTrReceived[63:0] = l2ReadTrReceived[63:0] + 1;
          if((l2ReadTrReceived[63:0] % 10000) <5000) begin
              outOfOrderDis = 0;
          end else begin
              outOfOrderDis = 1;
          end
          //wrData[NXDATAWIDTH-1:0] = randomDataWithAddr(NXDATAWIDTH,l2RdAMonT.addr);
          //l2RdAMonT.data[0] = wrData[NXDATAWIDTH-1:0];
          //wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH);
          //l2RdAMonT.data[1] = wrData[NXDATAWIDTH-1:0];
          l2RdAMonT.data[0] = dataSend;
          memAddr[NXADDRWIDTH-1:0] = l2RdAMonT.addr;
          memArrayOld[memAddr[NXADDRWIDTH-1:0]] = memArray[memAddr[NXADDRWIDTH-1:0]];
                     `DEBUG($psprintf(" monl2RdAddReq 1   MEM_DELETE 0x%0x -->   %0t  ", memAddr[NXADDRWIDTH-1:0],$time))
          memArray.delete(memAddr[NXADDRWIDTH-1:0]);
          //evictMemArray.delete(memAddr[NXADDRWIDTH-1:0]);  // Suresh Chnage
          memArray[memAddr[NXADDRWIDTH-1:0]] = dataSend;
          dataSend = dataSend + 1;
          l2RdAMonT.data[1] = dataSend;
          memAddr[NXADDRWIDTH-1:0] = {((l2RdAMonT.addr >> 5) + 1'b1),5'h0};
          memArrayOld[memAddr[NXADDRWIDTH-1:0]] = memArray[memAddr[NXADDRWIDTH-1:0]];
                     `DEBUG($psprintf(" monl2RdAddReq 2   MEM_DELETE 0x%0x -->   %0t  ", memAddr[NXADDRWIDTH-1:0],$time))
          memArray.delete(memAddr[NXADDRWIDTH-1:0]);
          //evictMemArray.delete(memAddr[NXADDRWIDTH-1:0]);  // Suresh Chnage
          memArray[memAddr[NXADDRWIDTH-1:0]] = dataSend;
          dataSend = dataSend + 1;
          l2RdAMonT.rattr = {2'h0,1'b1};
          l2RdAMonT.rId = l2RdAMonT.cId;
          l2RdAMonT.noBeets = 2;
          //slvTr[0].send(l2RdAMonT);
          if (outOfOrderRspEn == 1) begin // code for out of order
             pushFBSel = (outOfOrderDis == 1) ? 0 : $urandom_range(0,1);
             if(pushFBSel == 1) begin
                outOfOrdrQueue.push_front(l2RdAMonT);
             end else begin
                outOfOrdrQueue.push_back(l2RdAMonT);
             end 
             `DEBUG($psprintf("monl2RdAddReq outoffOrder rReq data %s  ", l2RdAMonT.creqSprint))
          end else  begin
             slvTr[0].send(l2RdAMonT);
             `DEBUG($psprintf("monl2RdAddReq rReq data %s  ", l2RdAMonT.creqSprint))
          end

      end
     end
   endtask:monl2RdAddReq




 /*   task sendL2RdRsp();
       L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,YBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2RdDataTr;
       while(1) begin
         clock(1);
       end
   endtask:sendL2RdRsp*/


task sendL2RdRsp();
	L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,YBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2RdDataTr;
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



   function [NXDATAWIDTH-1:0] randomDataWithAddr(input integer width,input [NXADDRWIDTH-1:0]addr); 
      integer m; 
      randomDataWithAddr = 0; 
      for (m = width/32; m >= 0; m--) 
         randomDataWithAddr = (randomDataWithAddr << 32) + $urandom + 32'h12345678;
      randomDataWithAddr[NXADDRWIDTH-1:0] = addr;
   endfunction

   function [NXDATAWIDTH-1:0] randomData(input integer width); 
      integer m; 
      randomData = 0; 
      for (m = width/32; m >= 0; m--) 
         randomData = (randomData << 32) + $urandom + $urandom_range(0,32'hffffffff);;
   endfunction

   task finish();
      begin
        clock(1000);
      end
   endtask:finish

task sendWrite(input reg [NXADDRWIDTH-1:0] addr,input reg [7:0] size, input reg ack, input reg [3:0]noBeets = 0);
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
  reg  [NXDATAWIDTH-1:0]wrData;
  automatic integer k;
  begin
    cpuReqT = new();
    `TB_YAP($psprintf("write addr=0x%0x size=%0d ack=%0b noBeets = %0d", addr, size,ack,noBeets))
    cpuReqT.addr = addr; 
    cpuReqT.cattr = (ack << 0) | (1 << 1);
    cpuReqT.reqType = CH_WRITE;
    cpuReqT.size = size;
    cpuReqT.noBeets = noBeets;
    cpuReqT.beetStart = 0;
    for(k=0; k < noBeets; k = k+1) begin
       wrData[NXDATAWIDTH-1:0] =  randomData(NXDATAWIDTH);
    `TB_YAP($psprintf("write Data = 0x%0x", wrData[NXDATAWIDTH-1:0]))
       cpuReqT.data[k] = wrData[NXDATAWIDTH-1:0];
    end
    cpuReqT.dattr = 1;
    mstTr[0].send(cpuReqT);
  end
endtask:sendWrite


task sendInval(input reg [NXADDRWIDTH-1:0] addr,input reg [7:0] size, input reg ack);
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
  begin
    cpuReqT = new();
    `INFO($psprintf("inval addr=0x%0x size=%0d  ack=%0b ", addr, size, ack))
    cpuReqT.addr = addr; 
    cpuReqT.cattr = (ack << 0) | (1 << 1) ;
    cpuReqT.reqType = CH_INVAL;
    cpuReqT.size = size;
    mstTr[0].send(cpuReqT);
  end
endtask:sendInval

task sendRead(input reg [NXADDRWIDTH-1:0] addr,input reg [7:0] size, input reg ack,input reg[3:0] noBeets = 0);
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
  integer i;
  reg [3:0]startBeet;
  begin
    cpuReqT = new();
    `TB_YAP($psprintf("read addr=0x%0x size=%0d  ack=%0b noBeets[3:0] = %0d", addr, size, ack,noBeets))
    cpuReqT.addr = addr; 
    cpuReqT.cattr = (ack << 0) | (1 << 1);
    cpuReqT.reqType = CH_READ;
    cpuReqT.size = size;
    cpuReqT.noBeets = noBeets;
    startBeet[3:0] =  addr[7:5];
    for(i=0; i <noBeets; i = i+1) begin
       cpuReqT.byteEn[startBeet] = 32'hffffffff; 
       startBeet[3:0] = startBeet[3:0] + 1'b1;
    end
    mstTr[0].send(cpuReqT);
  end
endtask:sendRead

/*
task sendRandomReq();
   reg [BYTEADDBITS-1:0]byteAddr;
   reg [ROWADDRBITS-1:0]rowAddr;
   reg [ROWADDRBITS-1:0]rowAddrArry[5];
   reg [TAGADDRBITS-1:0]tagAddr;
   reg [3:0]tagRandomAddr;
   reg [NXADDRWIDTH-1:0]reqAddr;
   reg [NXADDRWIDTH-1:0]memAddr;
   reg [NXDATAWIDTH*8-1:0]memData;
   reg [31:0] count = 100000;
   reg [31:0]loopCount = count;
   bit byteSizeDone =0;
   reg [BEETADDBITS-1:0]beetStart;
   reg [BYTEADDBITS-1:0]startByteInbeet;
   reg [NXSIZEWIDTH-1:0]startByte;
   reg [NXSIZEWIDTH-1:0]stopByte;
   reg [NXSIZEWIDTH-1:0]maxByteSize;
   reg [8:0]byteSize;
   reg [8:0]ActByteSize;
   reg [3:0]noBeets;
   reg [5:0]x32b;
   reg [5:0]w32b;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   reg [31:0]MinVal,MaxVal;
   reg invalCacheAddr;
   reg [31:0]loopCount_1 = 1;
   reg [NXDATAWIDTH-1:0]wrData;
   integer i,j;
   reg [16*32-1:0]byteEnBus;
   bit rowSelectRandomEn = 0;
   begin
       rowAddrArry[1] = $urandom_range(1,6);  // increase row size
       rowAddrArry[1] = 4;
       rowAddrArry[0] = (rowSelectRandomEn == 0) ? rowAddrArry[1] :rowAddrArry[1] - 1;
       rowAddrArry[2] = (rowSelectRandomEn == 0) ? rowAddrArry[1] :rowAddrArry[1] + 1;
       rowAddrArry[3] = (rowSelectRandomEn == 0) ? rowAddrArry[1] :0;
       rowAddrArry[4] = (rowSelectRandomEn == 0) ? rowAddrArry[1] :7;
       for(i=0; i<5; i = i+1) begin
             `TB_YAP($psprintf("TestbenchReq rowAddrArry[%d] = %d  ", i,rowAddrArry[i]))
       end
      
      
      while(loopCount[31:0] !=0) begin
          invalCacheAddr = 0;
          if((loopCount_1%5000) > 2500)  begin
             invalCacheAddr = $urandom_range(0,1);
             //`DEBUG($psprintf("TestbenchReq CACHE_INVAL loopCount_1 %d invalCacheAddr %d ", loopCount_1,invalCacheAddr ))
          end
          loopCount_1 = loopCount_1 + 1;
          invalCacheAddr = 0;
             cpuReqT = new();
             rowAddr[ROWADDRBITS-1:0] = rowAddrArry[$urandom_range(0,4)];
             tagAddr[TAGADDRBITS-1:0] = 'h0;
             tagRandomAddr[3:0] = $urandom_range(1,15);   // way select

 
              beetStart[BEETADDBITS-1:0] = $urandom_range(0,7);   // start beet for Cpu req ( out of 8(n-1) beets which beet u we want)
              //beetStart[BEETADDBITS-1:0] = 'h0;   // start beet for Cpu req ( out of 8(n-1) beets which beet u we want)
              startByteInbeet[BYTEADDBITS-1:0] = $urandom_range(0,31);
              //startByteInbeet[BYTEADDBITS-1:0] = 'h0;
              if(startByteInbeet[BYTEADDBITS-1:0] < 3) startByteInbeet[BYTEADDBITS-1:0] = 3;
              startByte[NXSIZEWIDTH-1:0] = beetStart[2:0] * 32 + startByteInbeet[4:0];
              MinVal[31:0] = 255;
              //MinVal[31:0] = 127;
              MaxVal[31:0] = startByte;
              stopByte[NXSIZEWIDTH-1:0] = $urandom_range(MinVal,MaxVal);
              //j =  $urandom_range(1,7);
              if(stopByte[NXSIZEWIDTH-1:0] == 32) stopByte[NXSIZEWIDTH-1:0] = 34;
              else if(stopByte[NXSIZEWIDTH-1:0] == 64) stopByte[NXSIZEWIDTH-1:0] = 66;
              else if(stopByte[NXSIZEWIDTH-1:0] == 96) stopByte[NXSIZEWIDTH-1:0] = 98;
              else if(stopByte[NXSIZEWIDTH-1:0] == 128) stopByte[NXSIZEWIDTH-1:0] = 130;
              else if(stopByte[NXSIZEWIDTH-1:0] == 160) stopByte[NXSIZEWIDTH-1:0] = 163;
              else if(stopByte[NXSIZEWIDTH-1:0] == 192) stopByte[NXSIZEWIDTH-1:0] = 194;
              else if(stopByte[NXSIZEWIDTH-1:0] == 224) stopByte[NXSIZEWIDTH-1:0] = 225;
              //stopByte[NXSIZEWIDTH-1:0] = 127;
              maxByteSize[NXSIZEWIDTH-1:0] = (stopByte[NXSIZEWIDTH-1:0]-startByte[NXSIZEWIDTH-1:0]);  // total number of bytes ( 0 to 255)
              byteSize[8:0] =  maxByteSize[NXSIZEWIDTH-1:0] + 1;

              x32b[5:0] = startByteInbeet[BYTEADDBITS-1:0] + byteSize[BYTEADDBITS-1:0];
              w32b = |(startByteInbeet[BYTEADDBITS-1:0] + byteSize[BYTEADDBITS-1:0]);
              noBeets[3:0] = byteSize[8:5] + x32b[5] + w32b;


                reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:4],tagRandomAddr[3:0],rowAddr[ROWADDRBITS-1:0],beetStart[BEETADDBITS-1:0],startByteInbeet[BYTEADDBITS-1:0]};
               memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:4],tagRandomAddr[3:0],rowAddr[ROWADDRBITS-1:0],8'h0};
              cpuReqT.addr = (invalCacheAddr == 1) ? memAddr[NXADDRWIDTH-1:0] : reqAddr[NXADDRWIDTH-1:0];
              cpuReqT.cattr = 'h2;
              cpuReqT.cattr = 'h3;
              cpuReqT.cattr = $urandom_range('h2,'h3);
              cpuReqT.reqType = (invalCacheAddr == 1) ? CH_INVAL :$urandom_range(CH_WRITE,CH_READ);
              //cpuReqT.reqType = (invalCacheAddr == 1) ? CH_INVAL :CH_READ;
              cpuReqT.size = (invalCacheAddr == 1) ? 8'h0 : byteSize[NXSIZEWIDTH-1:0];
              cpuReqT.noBeets = (invalCacheAddr == 1) ? 1 : noBeets[3:0];
              cpuReqT.beetStart = (invalCacheAddr == 1) ? 0 : beetStart[2:0];
              for(i=0; i<16; i = i+1) begin
                 cpuReqT.data[i] = {NXDATAWIDTH{1'b0}};
                 cpuReqT.byteEn[i] = 'h0;
              end
              for(i=beetStart; i<beetStart+noBeets; i = i+1) begin
                 wrData[NXDATAWIDTH-1:0] =  {i[3:0],220'h0,cpuReqT.addr[31:0]};
                 wrData[NXDATAWIDTH-1:0] =  randomData(NXDATAWIDTH);
                 cpuReqT.data[i] = wrData[NXDATAWIDTH-1:0];
              end
              byteEnBus = 'h0;
              for(i=startByte[NXSIZEWIDTH-1:0]; i <= stopByte[NXSIZEWIDTH-1:0]; i = i+1) begin
                 byteEnBus[i] = 1'b1;
              end
              for(i=0; i<16; i = i+1) begin
                 cpuReqT.byteEn[i] = byteEnBus[16*32-1:0] >> i*32;
              end
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  -------------  loopCount %d ",  loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  beetStart %d  loopCount %d ",  beetStart[2:0],loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  startByteInbeet %d  loopCount %d ",  startByteInbeet[4:0],loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  stopByte %d  loopCount %d ",  stopByte[7:0],loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  startByte %d  loopCount %d ",  startByte[7:0],loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  maxByteSize %d  loopCount %d ",  maxByteSize[7:0],loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  byteSize %d  loopCount %d ",  byteSize[7:0],loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  noBeets %d  loopCount %d ",  noBeets[3:0],loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  startByteInbeet %x  loopCount %d ",  startByteInbeet[4:0],loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  byteSize %x  loopCount %d ",  byteSize[4:0],loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  x32b %x  loopCount %d ",  x32b[5:0],loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  w32b %x  loopCount %d ",  w32b[5:0],loopCount))
              for(i=0; i<9; i = i+1) begin
                `TB_YAP($psprintf("TestbenchReq cpuReqT.byteEn[%0d] --> 0x%0x  loopCount %d ",  i,cpuReqT.byteEn[i],loopCount))
              end
              `TB_YAP($psprintf("TestbenchReq DES_CACHE ADDR  %x  loopCount %d ",  cpuReqT.addr,loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  -------------  loopCount %d ",  loopCount))

          mstTr[0].send(cpuReqT);
          loopCount[31:0] = loopCount[31:0] - 1;
          if(loopCount[31:0]%1000 == 0) begin
              isEmptyReqQueue();
          end 
       end

     clock(1000);
     isEmptyReqQueue();
end
endtask:sendRandomReq
*/

task sendRandomReq();
   reg [NXADDRWIDTH-1:0]startAddr;
   reg [NXADDRWIDTH-1:0]endAddr;
   reg [NXSIZEWIDTH:0]actSize;
   reg [NXSIZEWIDTH-1:0]naxiSize;
   reg [BEATBITS-1:0]beatStart;
   reg [BYTEBITS-1:0]startByteInBeat;
   reg [3:0]numBeat;
   reg [BYTEADDBITS-1:0]byteAddr;
   reg [ROWADDRBITS-1:0]rowAddr;
   reg [ROWADDRBITS-1:0]rowAddrArry[5];
   reg [TAGADDRBITS-1:0]tagAddr;
   reg [3:0]tagRandomAddr;
   reg [NXADDRWIDTH-1:0]reqAddr;
   reg [NXADDRWIDTH-1:0]memAddr;
   reg [NXDATAWIDTH*8-1:0]memData;
   reg [31:0] count = 20000;
   reg [31:0]loopCount = count;
   bit byteSizeDone =0;
   reg [BEETADDBITS-1:0]beetStart;
   reg [BYTEADDBITS-1:0]startByteInbeet;
   reg [NXSIZEWIDTH-1:0]startByte;
   reg [NXSIZEWIDTH:0]stopByte;
   reg [NXSIZEWIDTH-1:0]maxByteSize;
   reg [8:0]byteSize;
   reg [8:0]ActByteSize;
   reg [3:0]noBeets;
   reg [5:0]x32b;
   reg [5:0]w32b;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
   reg [31:0]MinVal,MaxVal;
   reg invalCacheAddr;
   reg [31:0]loopCount_1 = 1;
   reg [NXDATAWIDTH-1:0]wrData;
   integer i,j;
   reg [16*32-1:0]byteEnBus;
   bit rowSelectRandomEn = 0;
   reg [2:0] invalBeats;
   begin
       rowAddrArry[1] = $urandom_range(1,6);  // increase row size
       rowAddrArry[1] = 4;
       rowAddrArry[0] = (rowSelectRandomEn == 0) ? rowAddrArry[1] :rowAddrArry[1] - 1;
       rowAddrArry[2] = (rowSelectRandomEn == 0) ? rowAddrArry[1] :rowAddrArry[1] + 1;
       rowAddrArry[3] = (rowSelectRandomEn == 0) ? rowAddrArry[1] :0;
       rowAddrArry[4] = (rowSelectRandomEn == 0) ? rowAddrArry[1] :7;
       for(i=0; i<5; i = i+1) begin
             `TB_YAP($psprintf("TestbenchReq rowAddrArry[%d] = %d  ", i,rowAddrArry[i]))
       end
      
      
      while(loopCount[31:0] !=0) begin
          invalCacheAddr = 0;
          if((loopCount_1%5000) > 2500)  begin
             invalCacheAddr = $urandom_range(0,1);
             //`DEBUG($psprintf("TestbenchReq CACHE_INVAL loopCount_1 %d invalCacheAddr %d ", loopCount_1,invalCacheAddr ))
          end
          loopCount_1 = loopCount_1 + 1;
          //invalCacheAddr = 0;
             cpuReqT = new();
             rowAddr[ROWADDRBITS-1:0] = rowAddrArry[$urandom_range(0,4)];
             tagAddr[TAGADDRBITS-1:0] = 'h0;
             tagRandomAddr[3:0] = $urandom_range(1,15);   // way select
             //tagRandomAddr[3:0] = 0;   // way select
              beatStart[BEATBITS-1:0] = $urandom_range(0,7);
              //beatStart[BEATBITS-1:0] = 0;
              startByteInBeat[BYTEBITS-1:0] = $urandom_range(0,31);
              if(startByteInBeat[BYTEADDBITS-1:0] > 29) startByteInBeat[BYTEADDBITS-1:0] = 28;
              startAddr[NXADDRWIDTH-1:0] = {{TAGBITS{1'b0}},{INDEXBITS{1'b0}}, beatStart[BEATBITS-1:0],startByteInBeat[BYTEBITS-1:0]};
              actSize[NXSIZEWIDTH:0] = $urandom_range(1,256);
              endAddr[NXADDRWIDTH-1:0] = startAddr[NXADDRWIDTH-1:0] + (actSize[NXSIZEWIDTH:0] - 1);
              naxiSize[NXSIZEWIDTH-1:0] = actSize[NXSIZEWIDTH-1:0];
              numBeat[3:0] = (endAddr[8:5] - startAddr[8:5] + 16 + 1)%16;
              startByte[NXSIZEWIDTH-1:0] = beatStart[2:0] * 32 + startByteInBeat[4:0];
              stopByte[NXSIZEWIDTH:0] = actSize[NXSIZEWIDTH:0];

              if(loopCount_1[31:0]%100  < 5) begin
               `DEBUG($psprintf("TestbenchReq MYINSTBEAT  loopCount_1 %d ", loopCount_1 ))
                 beatStart[BEATBITS-1:0] = 7;
                 startByteInBeat[BYTEBITS-1:0] = $urandom_range(0,31);
                 if(startByteInBeat[BYTEADDBITS-1:0] > 29) startByteInBeat[BYTEADDBITS-1:0] = 28;
                 startAddr[NXADDRWIDTH-1:0] = {{TAGBITS{1'b0}},{INDEXBITS{1'b0}}, beatStart[BEATBITS-1:0],startByteInBeat[BYTEBITS-1:0]};
                 actSize[NXSIZEWIDTH:0] = $urandom_range(33,37);
                 endAddr[NXADDRWIDTH-1:0] = startAddr[NXADDRWIDTH-1:0] + (actSize[NXSIZEWIDTH:0] - 1);
                 naxiSize[NXSIZEWIDTH-1:0] = actSize[NXSIZEWIDTH-1:0];
                 numBeat[3:0] = (endAddr[8:5] - startAddr[8:5] + 16 + 1)%16;
                 startByte[NXSIZEWIDTH-1:0] = beatStart[2:0] * 32 + startByteInBeat[4:0];
                 stopByte[NXSIZEWIDTH:0] = actSize[NXSIZEWIDTH:0];
              end

               if(loopCount_1[31:0]%250  < 5) begin
               `DEBUG($psprintf("TestbenchReq MYINSTBEAT 1 loopCount_1 %d ", loopCount_1 ))
                 beatStart[BEATBITS-1:0] = 0;
                 startByteInBeat[BYTEBITS-1:0] = $urandom_range(0,31);
                 if(startByteInBeat[BYTEADDBITS-1:0] > 29) startByteInBeat[BYTEADDBITS-1:0] = 28;
                 startAddr[NXADDRWIDTH-1:0] = {{TAGBITS{1'b0}},{INDEXBITS{1'b0}}, beatStart[BEATBITS-1:0],startByteInBeat[BYTEBITS-1:0]};
                 actSize[NXSIZEWIDTH:0] = 256;
                 endAddr[NXADDRWIDTH-1:0] = startAddr[NXADDRWIDTH-1:0] + (actSize[NXSIZEWIDTH:0] - 1);
                 naxiSize[NXSIZEWIDTH-1:0] = actSize[NXSIZEWIDTH-1:0];
                 numBeat[3:0] = (endAddr[8:5] - startAddr[8:5] + 16 + 1)%16;
                 startByte[NXSIZEWIDTH-1:0] = beatStart[2:0] * 32 + startByteInBeat[4:0];
                 stopByte[NXSIZEWIDTH:0] = actSize[NXSIZEWIDTH:0];
              end

              if(invalCacheAddr == 1'b1)  begin
               `DEBUG($psprintf("TestbenchReq InvalCmd loopCount_1 %d ", loopCount_1 ))
                 beatStart[BEATBITS-1:0] = 0;
                 beatStart[BEATBITS-1:1] = $urandom_range(0,3);
                 startByteInBeat[BYTEBITS-1:0] = 0;
                 invalBeats[2:0] = $urandom_range(1,4);
                 startAddr[NXADDRWIDTH-1:0] = {{TAGBITS{1'b0}},{INDEXBITS{1'b0}}, beatStart[BEATBITS-1:0],startByteInBeat[BYTEBITS-1:0]};
                 actSize[NXSIZEWIDTH:0] = invalBeats[2:0] * 64; // cache line size
                 endAddr[NXADDRWIDTH-1:0] = startAddr[NXADDRWIDTH-1:0] + (actSize[NXSIZEWIDTH:0] - 1);
                 naxiSize[NXSIZEWIDTH-1:0] = actSize[NXSIZEWIDTH-1:0];
                 numBeat[3:0] = (endAddr[8:5] - startAddr[8:5] + 16 + 1)%16;
                 startByte[NXSIZEWIDTH-1:0] = beatStart[2:0] * 32 + startByteInBeat[4:0];
                 stopByte[NXSIZEWIDTH:0] = actSize[NXSIZEWIDTH:0];
              end

              reqAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:4],tagRandomAddr[3:0],8'h4, beatStart[BEATBITS-1:0],startByteInBeat[BYTEBITS-1:0]};
              memAddr[NXADDRWIDTH-1:0] = {tagAddr[TAGADDRBITS-1:4],tagRandomAddr[3:0],8'h4, beatStart[BEATBITS-1:0],5'h0};
              cpuReqT.addr = (invalCacheAddr == 1) ? memAddr[NXADDRWIDTH-1:0] : reqAddr[NXADDRWIDTH-1:0];
              cpuReqT.cattr = $urandom_range('h2,'h3);
              cpuReqT.cattr = 'h3;
              cpuReqT.reqType = (invalCacheAddr == 1) ? CH_INVAL :$urandom_range(CH_WRITE,CH_READ);
              cpuReqT.size =  naxiSize[NXSIZEWIDTH-1:0];
              cpuReqT.noBeets =  numBeat[3:0];
              cpuReqT.beetStart =  beatStart[2:0];


              for(i=0; i<16; i = i+1) begin
                 cpuReqT.data[i] = {NXDATAWIDTH{1'b0}};
                 cpuReqT.byteEn[i] = 'h0;
              end
              for(i=beatStart; i<beatStart+numBeat; i = i+1) begin
                 wrData[NXDATAWIDTH-1:0] =  {i[3:0],220'h0,cpuReqT.addr[31:0]};
                 wrData[NXDATAWIDTH-1:0] =  randomData(NXDATAWIDTH);
                 cpuReqT.data[i] = wrData[NXDATAWIDTH-1:0];
              end
              byteEnBus = 'h0;
              for(i=startByte[NXSIZEWIDTH-1:0]; i < startByte[NXSIZEWIDTH-1:0]+stopByte[NXSIZEWIDTH:0]; i = i+1) begin
                 byteEnBus[i] = 1'b1;
              end
              for(i=0; i<16; i = i+1) begin
                 cpuReqT.byteEn[i] = byteEnBus[16*32-1:0] >> i*32;
              end


              `TB_YAP($psprintf("TestbenchReq DES_CACHE  -------------  loopCount %d ",  loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  ReqType %d  loopCount %d ",  cpuReqT.reqType,loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  beatStart %d  loopCount %d ",  beatStart[BEATBITS-1:0],loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  startByteInBeat %d  loopCount %d ",  startByteInBeat[BYTEBITS-1:0],loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  stopByte %d  loopCount %d ",  stopByte[NXSIZEWIDTH:0],loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  startByte %d  loopCount %d ",  startByte[NXSIZEWIDTH-1:0],loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  actsize %d  loopCount %d ",  actSize[NXSIZEWIDTH:0],loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  naxiSize %d  loopCount %d ",  naxiSize[NXSIZEWIDTH-1:0],loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  numBeat %d  loopCount %d ",  numBeat[3:0],loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  startAddr %x  loopCount %d ",  startAddr[NXADDRWIDTH-1:0],loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  endAddr %x  loopCount %d ",  endAddr[NXADDRWIDTH-1:0],loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  reqAddr %x  loopCount %d ",  reqAddr[NXADDRWIDTH-1:0],loopCount))
              if((cpuReqT.byteEn[8] == 1'b1) && (cpuReqT.byteEn[9] == 1'b0) && (cpuReqT.byteEn[6] == 1'b0)) begin
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  MYINSTBEAT reqAddr %x  loopCount %d ",  reqAddr[NXADDRWIDTH-1:0],loopCount))

              end
              for(i=0; i<16; i = i+1) begin
                `TB_YAP($psprintf("TestbenchReq cpuReqT.byteEn[%0d] --> 0x%0x  loopCount %d ",  i,cpuReqT.byteEn[i],loopCount))
              end
              `TB_YAP($psprintf("TestbenchReq DES_CACHE ADDR  %x  loopCount %d ",  cpuReqT.addr,loopCount))
              `TB_YAP($psprintf("TestbenchReq DES_CACHE  -------------  loopCount %d ",  loopCount))

 
             /* startByteInbeet[BYTEADDBITS-1:0] = $urandom_range(0,31);
              beatStart[3:0] = $urandom_range(0,7);
              startAddr[34:0] = {17'h0,5'h0, beatStart[3:0],startByteInbeet[4:0]};
              actsize[8:0] = $urandom_range(1,256);
              endaddress[34:0] = startAddr[34:0] + (actsize[8:0] - 1);
              naxisize[7:0] = actsize[7:0];
              noBeats[3:0] = (endaddress[8:5] - startAddr[8:5] + 16 + 1)%16;
            */
          mstTr[0].send(cpuReqT);
          loopCount[31:0] = loopCount[31:0] - 1;
          if(loopCount[31:0]%1000 == 0) begin
              isEmptyReqQueue();
          end 
       end

     clock(1000);
     isEmptyReqQueue();
end
endtask:sendRandomReq

task readCheckTask;
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuRdDataT;
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuWrTr;
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuRdTr;
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) RAWTr;
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) RAITr;
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) invalTr;
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) flushTr;
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) IARTr;
  reg [NXDATAWIDTH-1:0] cpuRdData;
  reg [NXADDRWIDTH-1:0] cpuRdAddr;
  reg [NXDATAWIDTH-1:0] comuteData;
  bit readDataMatchWithMemArry;
  bit readDataMatchWithOnlyMemArry;
  bit readDataMatchWithFill;
  bit readDataMatchWithHit;
  bit readDataMatchWithMemOldArry;
  bit readDataMatchWithEvictMem;
  bit readDataMatchWithInvalMem;
  integer fillSize;
  integer hitSize,queueSize;
  bit rawTrFound;
  bit raiTrFound;
  bit invalFound;
  bit invalLocked;
  bit readLocked;
  bit l2ErrorDetected;
  bit memErrorDetected;
  bit WBRFound;
  bit RBRFound;
  bit WARFound;
  bit RARFound;
  bit IARFound;
  real evicttransactionTime;
  reg  evictWrFound; 
  integer j;
   while(1) begin
       monCpuRdRspQueue.get(cpuRdDataT);
       `TB_YAP($psprintf("monCpuRdRspQueue %s  ", cpuRdDataT.creqSprint))
       cpuRdAddr[NXADDRWIDTH-1:0] = cpuRdDataT.addr;
       readDataMatchWithMemArry = 0;
       readDataMatchWithOnlyMemArry = 0;
       readDataMatchWithFill = 0;
       readDataMatchWithHit = 0;
       readDataMatchWithMemOldArry = 0;
       readDataMatchWithEvictMem = 0;
       readDataMatchWithInvalMem = 0;
       WBRFound = 0;
       RBRFound = 0;
       WARFound = 0;
       RARFound = 0;
       IARFound = 0;
       evictWrFound = 0;
       evicttransactionTime = 0;
       queueSize = cpuReqQueue.num();
       for(i=0; i<queueSize; i = i+1) begin
          cpuReqQueue.get(cpuWrTr);
          if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5))) begin
            `DEBUG($psprintf(" DEBUG_READ Same Add Tr  in Queue %s  ", cpuWrTr.creqSprint))
            `DEBUG($psprintf(" DEBUG_READ Same Add Tr  in Queue %s  ", cpuWrTr.dreqSprint))
          end
          cpuReqQueue.put(cpuWrTr);
       end  
       queueSize = cpuReqQueue.num();
       for(i=0; i<queueSize; i = i+1) begin
          cpuReqQueue.get(cpuWrTr);
          if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (cpuWrTr.transactionTime < cpuRdDataT.transactionTime) && (cpuWrTr.evictTr == 1'b1)) begin
            evicttransactionTime = cpuWrTr.transactionTime;
            `DEBUG($psprintf(" DEBUG_READ ForRead check Lock Write Evixt %s  ", cpuWrTr.creqSprint))
            evictWrFound = 1;
          end
          cpuReqQueue.put(cpuWrTr);
         
       end
       if(evictWrFound == 1'b1) begin
          queueSize = cpuReqQueue.num();
          for(i=0; i<queueSize; i = i+1) begin
             cpuReqQueue.get(cpuWrTr);
             if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (cpuWrTr.transactionTime <=  evicttransactionTime ) && (cpuWrTr.writeCheckDone == 1'b1)) begin
                 `DEBUG($psprintf(" DEBUG_READ ForRead check Removeing Unwanted Read %s  ", cpuWrTr.creqSprint))
             end else begin
               cpuReqQueue.put(cpuWrTr);
             end
          end
       end

        
       `DEBUG($psprintf(" DEBUG_READ Cache Read Creq %s",cpuRdDataT.creqSprint))
       l2ErrorDetected = 0;
       memErrorDetected = 0;
      
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
        if(memArray.exists(cpuRdAddr[NXADDRWIDTH-1:0])) begin
        `DEBUG($psprintf( "MEME Data 0x%0x  ", memArray[cpuRdAddr[NXADDRWIDTH-1:0]]))
        end
        if(memArray.exists(cpuRdAddr[NXADDRWIDTH-1:0])) begin
  	     invalFound = 0;
  	     invalLocked = 0;
  	     readLocked = 0;
             queueSize = cpuReqQueue.num();
             `DEBUG($psprintf(" DEBUG_READ cpuReqQueue SIZE  %d  ", cpuReqQueue.num()))
             for(i=0; i<queueSize; i = i+1) begin
                cpuReqQueue.get(cpuWrTr);
                if((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5))  begin
                    `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP PEND_TR_CPU_QUEUE cReq %s  ", cpuWrTr.creqSprint))
                end
                if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_READ) && (readLocked == 0) && (cpuWrTr.transactionTime != cpuRdDataT.transactionTime)) begin
                    `DEBUG($psprintf(" DEBUG_READ cpuWrTr.transactionTime %0t  ", cpuWrTr.transactionTime))
                    `DEBUG($psprintf(" DEBUG_READ cpuRdDataT.transactionTime %0t  ", cpuRdDataT.transactionTime))
                    `ERROR($psprintf(" DEBUG_READ BEFORE_CMP one more Read is Pending Befor curent Read Rsv Read cReq %s  ", cpuWrTr.creqSprint))
                end
                if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_READ) && (cpuWrTr.transactionTime == cpuRdDataT.transactionTime)) begin
                    readLocked = 1;
                    `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP READLOCKED cReq %s  ", cpuWrTr.creqSprint))
                end

                
                if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_INVAL) && 
                   (cpuWrTr.transactionTime < cpuRdDataT.transactionTime) && (readLocked == 0) ) begin
                    invalTr = new cpuWrTr;
                    invalLocked = 1;
                    `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP INVALLOCKED cReq %s  ", invalTr.creqSprint))
                end
                cpuReqQueue.put(cpuWrTr);
             end
             
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
                    `DEBUG($psprintf(" DEBUG_READ COMPUTEDATA 0x%x ",comuteData[NXDATAWIDTH-1:0] ))
                end  // end for comuteReadHit
                if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (cpuWrTr.transactionId > cpuRdDataT.transactionId))  begin
                    `DEBUG($psprintf(" DEBUG_READ MEMARRYCMP 2 CPU_TR Pend Wr Tr After Rd Tr cReq %s  ", cpuWrTr.creqSprint))
                end
                cpuReqQueue.put(cpuWrTr);
             end
             `DEBUG($psprintf(" DEBUG_READ cpuRdDataT.data[0] 0x%0x ", cpuRdDataT.data[0]))
             if(cpuRdDataT.data[0]  === comuteData[NXDATAWIDTH-1:0]) begin
                readDataMatchWithMemArry = 1'b1;
                `DEBUG($psprintf(" DEBUG_READ MEMARRYCMP Read Data Match With MemArray+WrTr 0x%x ",comuteData[NXDATAWIDTH-1:0] ))
             end
        end

        if(memArrayOld.exists(cpuRdAddr[NXADDRWIDTH-1:0])) begin
        `DEBUG($psprintf("Mem Old Data 0x%0x  ", memArrayOld[cpuRdAddr[NXADDRWIDTH-1:0]]))
        end
        if((memArrayOld.exists(cpuRdAddr[NXADDRWIDTH-1:0])) && (readDataMatchWithMemArry == 1'b0)) begin
  	     invalFound = 0;
  	     invalLocked = 0;
  	     readLocked = 0;
             queueSize = cpuReqQueue.num();
             `DEBUG($psprintf(" DEBUG_READ cpuReqQueue SIZE  %d  ", cpuReqQueue.num()))
             for(i=0; i<queueSize; i = i+1) begin
                cpuReqQueue.get(cpuWrTr);
                if((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5))  begin
                    `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP PEND_TR_CPU_QUEUE cReq %s  ", cpuWrTr.creqSprint))
                end
                if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_READ) && (readLocked == 0) && (cpuWrTr.transactionTime != cpuRdDataT.transactionTime)) begin
                    `DEBUG($psprintf(" DEBUG_READ cpuWrTr.transactionTime %0t  ", cpuWrTr.transactionTime))
                    `DEBUG($psprintf(" DEBUG_READ cpuRdDataT.transactionTime %0t  ", cpuRdDataT.transactionTime))
                    `ERROR($psprintf(" DEBUG_READ BEFORE_CMP one more Read is Pending Befor curent Read Rsv Read cReq %s  ", cpuWrTr.creqSprint))
                end
                if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_READ) && (cpuWrTr.transactionTime == cpuRdDataT.transactionTime)) begin
                    readLocked = 1;
                    `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP READLOCKED cReq %s  ", cpuWrTr.creqSprint))
                end

                
                if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_INVAL) && 
                   (cpuWrTr.transactionTime < cpuRdDataT.transactionTime) && (readLocked == 0) ) begin
                    invalTr = new cpuWrTr;
                    invalLocked = 1;
                    `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP INVALLOCKED cReq %s  ", invalTr.creqSprint))
                end
                cpuReqQueue.put(cpuWrTr);
             end
             
             `DEBUG($psprintf(" DEBUG_READ cpuReqQueue SIZE  %d  ", cpuReqQueue.num()))

             queueSize = cpuReqQueue.num();
             `DEBUG($psprintf(" DEBUG_READ cpuReqQueue SIZE  %d  ", cpuReqQueue.num()))
             comuteData[NXDATAWIDTH-1:0] = memArrayOld[cpuRdAddr[NXADDRWIDTH-1:0]];
             `DEBUG($psprintf(" DEBUG_READ MEMARRYCMP MEM_OLD_DATA 0x%x Addr 0x%x ",comuteData[NXDATAWIDTH-1:0] ,cpuRdAddr[NXADDRWIDTH-1:0]))
             for(i=0; i<queueSize; i = i+1) begin
                cpuReqQueue.get(cpuWrTr);
                if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_INVAL) && (cpuWrTr.transactionId < cpuRdDataT.transactionId))  begin
                     comuteData[NXDATAWIDTH-1:0] = memArrayOld[cpuRdAddr[NXADDRWIDTH-1:0]];
                    `DEBUG($psprintf(" DEBUG_READ MEMARRYCMP INVAL Found. Reseting the Comp Data with ZERO's  cReq %s  ", cpuWrTr.creqSprint))
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
             if(cpuRdDataT.data[0]=== comuteData[NXDATAWIDTH-1:0]) begin
                readDataMatchWithMemOldArry = 1'b1;
                `DEBUG($psprintf(" DEBUG_READ MEMARRYCMP Read Data Match With MemArrayOld+WrTr 0x%x ",comuteData[NXDATAWIDTH-1:0] ))
             end
        end

        if(evictMemArray.exists(cpuRdAddr[NXADDRWIDTH-1:0])&& (readDataMatchWithMemArry == 1'b0)&& (readDataMatchWithMemOldArry == 1'b0)) begin

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
                if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_INVAL) && 
                   (cpuWrTr.transactionTime < cpuRdDataT.transactionTime) && (readLocked == 0)) begin
                    invalTr = new cpuWrTr;
                    invalLocked = 1;
                    `DEBUG($psprintf(" DEBUG_READ BEFORE_CMP_EVICT INVALLOCKED cReq %s  ", invalTr.creqSprint))
                end
                cpuReqQueue.put(cpuWrTr);
             end
             
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
                if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (cpuWrTr.transactionId > cpuRdDataT.transactionId))  begin
                    `DEBUG($psprintf(" DEBUG_READ EVICTARRYCMP 2 CPU_TR Pend Wr Tr After Rd Tr cReq %s  ", cpuWrTr.creqSprint))
                end
                cpuReqQueue.put(cpuWrTr);
             end

             if(cpuRdDataT.data[0]  === comuteData[NXDATAWIDTH-1:0]) begin
                readDataMatchWithEvictMem = 1'b1;
             end

            /* if(readDataMatchWithEvictMem == 1'b0) begin
                queueSize = cpuReqQueue.num();
                comuteData[NXDATAWIDTH-1:0] = evictMemArrayOld[cpuRdAddr[NXADDRWIDTH-1:0]];
                `DEBUG($psprintf(" DEBUG_READ EVICTARRYCMP MEM_DATA 0x%x Addr 0x%x ",comuteData[NXDATAWIDTH-1:0] ,cpuRdAddr[NXADDRWIDTH-1:0]))
                for(i=0; i<queueSize; i = i+1) begin
                   cpuReqQueue.get(cpuWrTr);
                   if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_INVAL) && (cpuWrTr.transactionId < cpuRdDataT.transactionId))  begin
                        comuteData[NXDATAWIDTH-1:0] = evictMemArrayOld[cpuRdAddr[NXADDRWIDTH-1:0]];
                       `DEBUG($psprintf(" DEBUG_READ EVICTARRYCMP INVAL Found. Reseting the Comp Data with Evic Data EVIC_DATA 0x%x  cReq %s  ",comuteData[NXDATAWIDTH-1:0], cpuWrTr.creqSprint))
                   end  // end for comuteReadHit
                   if(((cpuWrTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (cpuWrTr.transactionId > cpuRdDataT.transactionId))  begin
                       `DEBUG($psprintf(" DEBUG_READ EVICTARRYCMP 2 CPU_TR Pend Wr Tr After Rd Tr cReq %s  ", cpuWrTr.creqSprint))
                   end
                   cpuReqQueue.put(cpuWrTr);
                end

                if(cpuRdDataT.data[0]  === comuteData[NXDATAWIDTH-1:0]) begin
                   readDataMatchWithEvictMem = 1'b1;
                  `DEBUG($psprintf(" DEBUG_READ EVICTARRYCMP DATA  MATCH WITH EVICTOLDMEM 0x%x Addr 0x%x ",comuteData[NXDATAWIDTH-1:0] ,cpuRdAddr[NXADDRWIDTH-1:0]))
                end

             end*/
         end

      

                        
         queueSize = cpuReqQueue.num();
         for(j=0;j<queueSize; j = j+1) begin
           cpuReqQueue.get(cpuRdTr);
           if(((cpuRdTr.addr >> 5) == (cpuRdDataT.addr >> 5)) && (cpuRdTr.reqType == CH_READ) && (cpuRdTr.transactionTime == cpuRdDataT.transactionTime))  begin
               `DEBUG($psprintf(" DEBUG_READ Removeing RdTr from CpuQueue %s  ", cpuRdTr.creqSprint))
                if(readDataMatchWithEvictMem == 1'b1) begin
                    ReadMatchArray[{(cpuRdTr.addr >> 5),5'h0}] = cpuRdTr;
                end 
           end else begin
              cpuReqQueue.put(cpuRdTr);
           end
         end


              

               if((IARFound == 1'b1) && (WBRFound == 1'b0) && (RBRFound == 1'b0) && (WARFound == 1'b0) && (RARFound == 1'b0)) begin
              // if((IARFound == 1'b1)  && (RBRFound == 1'b0) && (RARFound == 1'b0)) begin
                   if(memArray.exists(cpuRdAddr[NXADDRWIDTH-1:0]) || memArrayOld.exists(cpuRdAddr[NXADDRWIDTH-1:0]) ||evictMemArray.exists(cpuRdAddr[NXADDRWIDTH-1:0]) )  begin
                      if(readDataMatchWithMemOldArry == 1)  begin
                         if(memArrayOld.exists(cpuRdAddr[NXADDRWIDTH-1:0]))  begin
                           `DEBUG($psprintf(" DEBUG_READ MEM_OLD_DELETE 0x%0x -->   %0t  ", cpuRdAddr[NXADDRWIDTH-1:0],$time))
                            memArrayOld.delete(cpuRdAddr[NXADDRWIDTH-1:0]);
                         end
                      end else begin
                         if(memArray.exists(cpuRdAddr[NXADDRWIDTH-1:0]))  begin
                           `DEBUG($psprintf(" DEBUG_READ MEM_DELETE 0x%0x -->   %0t  ", cpuRdAddr[NXADDRWIDTH-1:0],$time))
                            memArray.delete(cpuRdAddr[NXADDRWIDTH-1:0]);
                         end
                      end
                      if(evictMemArray.exists(cpuRdAddr[NXADDRWIDTH-1:0]) )  begin
                        `DEBUG($psprintf(" DEBUG_READ EVICT_DELETE 0x%0x -->   %0t  ", cpuRdAddr[NXADDRWIDTH-1:0],$time))
                         evictMemArray.delete(cpuRdAddr[NXADDRWIDTH-1:0]);
                      end
                      `DEBUG($psprintf(" DEBUG_READ. RM_MEM IARFound  time %t   ", IARTr.transactionTime))
                      `DEBUG($psprintf(" DEBUG_READ. RM_MEM After Read Inval found. Removeing all Mem's. time %t Read req %s  ", $time,cpuRdTr.creqSprint))
                   end
               end

               if(readDataMatchWithMemArry == 1'b1)
                   `DEBUG($psprintf(" CPU_CHECK CACHE_READ_PASS  Data Match With L2 Mem + Wr %s  ", cpuRdDataT.creqSprint))
               if(readDataMatchWithEvictMem == 1'b1)
                   `DEBUG($psprintf(" CPU_CHECK CACHE_READ_PASS  Data Match With Evict Mem %s  ", cpuRdDataT.creqSprint))
               if(readDataMatchWithMemOldArry == 1'b1)
                   `DEBUG($psprintf(" CPU_CHECK CACHE_READ_PASS  Data Match With L2 Old Mem  + Wr %s  ", cpuRdDataT.creqSprint))
               if(readDataMatchWithMemArry || readDataMatchWithEvictMem || readDataMatchWithMemOldArry )  begin
                     `DEBUG($psprintf(" CPU_CHECK CACHE_READ_PASS ceq %s",cpuRdDataT.creqSprint))
               end else begin
                     `TB_YAP($psprintf(" DEBUG_FILL_FAIL 2"))
                     `TB_YAP($psprintf(" CACHE Read data is not Valid. Read Data is not Mach with Cache  Data"))
                     `TB_YAP($psprintf(" CPU Read  TR cReq %s  ", cpuRdDataT.creqSprint))
                     `TB_YAP($psprintf(" CPU RD Data 0x%x  ", cpuRdDataT.data[0]))
                     `ERROR($psprintf(" =======CPU READ MISMACH =============="))
               end
       
/*
*/
   end  // end while
endtask
function reg [NXDATAWIDTH-1:0]computeCacheData(input [NXDATAWIDTH-1:0] cacheData,L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) penTr);
reg[NXDATAWIDTH-1:0] inData;
reg [NXADDRWIDTH-1:0] addr;
reg [NXSIZEWIDTH-1:0] size;
reg [7:0] inArray[32];
reg [7:0] cacheArray[32];
reg [NXDATAWIDTH-1:0] tempData;
reg [31:0]byteEn;
integer m,n; 
    inData[NXDATAWIDTH-1:0] = penTr.data[0];
    size[NXSIZEWIDTH-1:0] = penTr.size;
    addr[NXADDRWIDTH-1:0] = penTr.addr;
    byteEn[31:0] = penTr.byteEn[0];
    for (m = 0; m <NXDATAWIDTH/8 ; m = m+1) begin
        inArray[m] = inData[NXDATAWIDTH-1:0] >> m*8;
        cacheArray[m] = cacheData[NXDATAWIDTH-1:0] >> m*8;
    end 
    for (m = 0; m < 32  ; m = m+1) begin
          cacheArray[m] = (byteEn[m] == 1'b1 ) ? inArray[m] : cacheArray[m];
    end
    tempData[NXDATAWIDTH-1:0] = {NXDATAWIDTH{1'b0}};
    for (m = 0; m < 32  ; m = m+1) begin
       tempData[NXDATAWIDTH-1:0] = tempData[NXDATAWIDTH-1:0]  | cacheArray[m] << m*8;
    end

    computeCacheData[NXDATAWIDTH-1:0] = tempData[NXDATAWIDTH-1:0];
endfunction:computeCacheData

task writeCheckTask;
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuWrTr;
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,YBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2WrTr;
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuEvictWrTr;
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuWrRdTr;
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) evictTr;
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,XBITSEQ,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) IAWTr;

  integer hitSize,i,queueSize;
  bit EvictDataMatch;
  bit EvictDataMatchWithFlush;
  bit EvictDataMatchWithInval;
  bit RemoveFlushInvalFromQueue;
  bit EvictDataMatchWithFlushRemoveWrTr;
  mailbox evictCheckQueue;
  reg[NXDATAWIDTH-1:0]comuteData;
  reg[NXDATAWIDTH-1:0]oldEvictData;
  bit lockSet;
  bit WBWFound;
  bit RBWFound;
  bit WAWFound;
  bit RAWFound;
  bit IAWFound;
  bit invalFoundAfterWr;
  reg ReadFoundForDelete;
  reg WriteFoundForDelete;
  real EvicttransactionTime;
  reg writeFound;
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
     ReadFoundForDelete = 1'b0;
     WriteFoundForDelete = 1'b0;
     EvicttransactionTime = 0;
     oldEvictData = 0;
     writeFound = 0;
     `DEBUG($psprintf(" DEBUG_EVICT L2_TR   cReq %s  ", l2WrTr.creqSprint))
      evictCheckQueue = new();
      queueSize = cpuReqQueue.num();
      for(i=0; i<queueSize; i = i+1) begin
         cpuReqQueue.get(cpuWrTr);
         if(((cpuWrTr.addr >> 5) == (l2WrTr.addr >> 5))  )  begin
           evictTr = new cpuWrTr;
          `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP All Req  %s  ", evictTr.creqSprint))
           evictCheckQueue.put(evictTr);
           if(evictTr.reqType == CH_WRITE) begin
              writeFound = 1;
           end
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
       /*if(writeFound == 1'b0) begin
          `DEBUG($psprintf(" writeFound  %d  ", writeFound))
           comuteData[NXDATAWIDTH-1:0] = memArray[l2WrTr.addr];
           if(comuteData[NXDATAWIDTH-1:0] === l2WrTr.data[0]) begin
               EvictDataMatch = 1'b1;
               oldEvictData = evictMemArray[l2WrTr.addr];
               evictMemArray[l2WrTr.addr] = l2WrTr.data[0];
               memArray.delete(l2WrTr.addr);
               cpuEvictWrTr = new ();
              `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP DATA MATCH  WITH DUMMY REQ%s  ", cpuEvictWrTr.creqSprint))
              `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP Addr 0x%x DATA 0x%x  ",l2WrTr.addr, evictMemArray[l2WrTr.addr]))
           end 
       end*/

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
            if(((cpuWrTr.addr >> 5) == (l2WrTr.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (EvictDataMatch == 1))  begin
                `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP 2 Pend Wr Tr After Evict Wr Tr  %s  ", cpuWrTr.creqSprint))
                `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP 2 Pend Wr Tr After Evict Wr Tr  %s  ", cpuWrTr.dreqSprint))
            end
            if(((cpuWrTr.addr >> 5) == (l2WrTr.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (EvictDataMatch == 0) && (cpuWrTr.writeCheckDone == 1'b0))  begin
                 `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP 1 Pend Wr Tr Before Evict Wr Tr  %s  ", cpuWrTr.creqSprint))
                 `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP 1 Pend Wr Tr Before Evict Wr Tr  %s  ", cpuWrTr.dreqSprint))
                  comuteData[NXDATAWIDTH-1:0] = computeCacheData(comuteData[NXDATAWIDTH-1:0],cpuWrTr);
                  invalFoundAfterWr = 0;
                  if(comuteData[NXDATAWIDTH-1:0] === l2WrTr.data[0]) begin
                      EvictDataMatch = 1'b1;
                      oldEvictData = evictMemArray[l2WrTr.addr];
                      evictMemArray[l2WrTr.addr] = l2WrTr.data[0];
                      //evictMemArrayOld.delete(l2WrTr.addr);
                     //`DEBUG($psprintf(" DEBUG_READ MEM_DELETE 0x%0x -->   %0t  ", l2WrTr.addr,$time))
                     // memArray.delete(l2WrTr.addr);
                      cpuEvictWrTr = new cpuWrTr;
                     `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP DATA MATCH %s  ", cpuEvictWrTr.creqSprint))
                     `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP Addr 0x%x DATA 0x%x  ",l2WrTr.addr, evictMemArray[l2WrTr.addr]))
                  end 
            end  else begin
                evictCheckQueue.put(cpuWrTr);
            end // end for comuteReadHit
         end  // end for
        /*if((EvictDataMatch == 1))begin
         queueSize = cpuReqQueue.num();
             for(i=0; i<queueSize; i = i+1) begin
                cpuReqQueue.get(cpuWrTr);
                if(((cpuWrTr.addr >> 5) == (cpuEvictWrTr.addr >> 5)) && (cpuWrTr.reqType != CH_READ) && (cpuWrTr.transactionTime <= cpuEvictWrTr.transactionTime))  begin
                   `DEBUG($psprintf(" DEBUG_EVICT MEMARRYCMP Remove Tr from cpuReqQueue Queue %s  ", cpuWrTr.creqSprint))
                end else begin
                   cpuReqQueue.put(cpuWrTr);
                end
             end
         end*/

       end


       if((EvictDataMatch == 1) ) begin
         queueSize = cpuReqQueue.num();
         for(i=0; i<queueSize; i = i+1) begin
            cpuReqQueue.get(cpuWrTr);
            if(((cpuWrTr.addr >> 5) == (cpuEvictWrTr.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (cpuWrTr.transactionTime < cpuEvictWrTr.transactionTime))  begin
                WBWFound = 1;
               `DEBUG($psprintf(" DEBUG_EVICT  WBWFound cReq %s  ", cpuWrTr.creqSprint))
            end
            if(((cpuWrTr.addr >> 5) == (cpuEvictWrTr.addr >> 5)) && (cpuWrTr.reqType == CH_READ) && (cpuWrTr.transactionTime < cpuEvictWrTr.transactionTime))  begin
                RBWFound = 1;
               `DEBUG($psprintf(" DEBUG_EVICT  RBWFound cReq %s  ", cpuWrTr.creqSprint))
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


          if((EvictDataMatch == 1))begin
             queueSize = cpuReqQueue.num();
             for(i=0; i<queueSize; i = i+1) begin
                cpuReqQueue.get(cpuWrTr);
                if(((cpuWrTr.addr >> 5) == (cpuEvictWrTr.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (cpuWrTr.transactionTime === cpuEvictWrTr.transactionTime))  begin
                    cpuWrTr.evictTr = 1'b1;
                   `DEBUG($psprintf(" DEBUG_EVICT cpuReqQueue Write Tr Match With Evict  %s  ", cpuWrTr.creqSprint))
                end 
                if(((cpuWrTr.addr >> 5) == (cpuEvictWrTr.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (cpuWrTr.transactionTime <= cpuEvictWrTr.transactionTime))  begin
                    cpuWrTr.writeCheckDone = 1'b1;
                   `DEBUG($psprintf(" DEBUG_EVICT cpuReqQueue Write Tr  Datacheck done while Evict  %s  ", cpuWrTr.creqSprint))
                end 
             cpuReqQueue.put(cpuWrTr);
             end
         end


         if((EvictDataMatch == 1) && (RBWFound == 1'b0))begin
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


         if((EvictDataMatch == 1) && (RBWFound == 1'b1))begin
             evictMemArrayOld[l2WrTr.addr] = oldEvictData;
         end
         ReadFoundForDelete = 1'b0;
         WriteFoundForDelete = 1'b0;
         EvicttransactionTime = 0;
         if(EvictDataMatch == 1)  begin
            queueSize = cpuReqQueue.num();
            for(i=0; i<queueSize; i = i+1) begin
                cpuReqQueue.get(cpuWrTr);
                if(((cpuWrTr.addr >> 5) == (cpuEvictWrTr.addr >> 5)) && (cpuWrTr.reqType == CH_READ) && (cpuWrTr.transactionTime < cpuEvictWrTr.transactionTime))  begin
                    ReadFoundForDelete = 1'b1;
                    `DEBUG($psprintf(" DEBUG_EVICT ReadFoundForDelete  %s  ", cpuWrTr.creqSprint))
                end
                if(((cpuWrTr.addr >> 5) == (cpuEvictWrTr.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (cpuWrTr.evictTr == 1'b1) && (ReadFoundForDelete == 1'b0) )  begin
                    `DEBUG($psprintf(" DEBUG_EVICT DebugReadFoundForDelete  %s  ", cpuWrTr.creqSprint))

                end
                if(((cpuWrTr.addr >> 5) == (cpuEvictWrTr.addr >> 5)) && (cpuWrTr.reqType == CH_WRITE) && (cpuWrTr.evictTr == 1'b1) && (ReadFoundForDelete == 1'b0) && (cpuWrTr.transactionTime <= cpuEvictWrTr.transactionTime))  begin
                    WriteFoundForDelete = 1'b1;
                    EvicttransactionTime = cpuWrTr.transactionTime;
                    `DEBUG($psprintf(" DEBUG_EVICT WriteFoundForDelete  %s  ", cpuWrTr.creqSprint))
                end
                cpuReqQueue.put(cpuWrTr);
            end
        end
        if((EvictDataMatch == 1) && (WriteFoundForDelete == 1'b1)) begin
            queueSize = cpuReqQueue.num();
            for(i=0; i<queueSize; i = i+1) begin
                cpuReqQueue.get(cpuWrTr);
                if(((cpuWrTr.addr >> 5) == (cpuEvictWrTr.addr >> 5)) && (cpuWrTr.reqType != CH_READ) && (cpuWrTr.transactionTime <= EvicttransactionTime))  begin
                   `DEBUG($psprintf(" DEBUG_EVICT  Remove OLD Wr Tr from cpuReqQueue Queue %s  ", cpuWrTr.creqSprint))
                end else begin
                    cpuReqQueue.put(cpuWrTr);
                end
            end
        end




       `DEBUG($psprintf(" DEBUG_EVICT  WBWFound %d RBWFound %d WAWFound %d RAWFound %d IAWFound %d  ",WBWFound,RBWFound,WAWFound,RAWFound,IAWFound ))
        //if((IAWFound == 1'b1) && (WBWFound == 1'b0) && (RBWFound == 1'b0) && (WAWFound == 1'b0) && (RAWFound == 1'b0)) begin
        if((IAWFound == 1'b1) ) begin
               `DEBUG($psprintf(" DEBUG_EVICT. Start Delete1 time %t   ", $time))
            if(memArray.exists(l2WrTr.addr) || evictMemArray.exists(l2WrTr.addr) )  begin
               evictMemArray.delete(l2WrTr.addr);
               evictMemArrayOld.delete(l2WrTr.addr);
                     `DEBUG($psprintf(" DDEBUG_EVICT 1  MEM_DELETE 0x%0x -->   %0t  ", l2WrTr.addr,$time))
               memArray.delete(l2WrTr.addr);
               memArrayOld.delete(l2WrTr.addr);
               `DEBUG($psprintf(" DEBUG_EVICT. RM_MEM IAWFound  time %t   ", IAWTr.transactionTime))
               `DEBUG($psprintf(" DEBUG_EVICT. RM_MEM After Write Inval found. Removeing all Mem's. time %t Read req %s  ", $time,l2WrTr.creqSprint))
               if(memArray.exists(l2WrTr.addr) || evictMemArray.exists(l2WrTr.addr) )  begin
                 `ERROR($psprintf(" DEBUG_EVICT. RM_MEM  MEM not delete. Addr 0x%x", l2WrTr.addr))
               end
            end
       end

        if((IAWFound == 1'b0) && ( (WAWFound == 1'b0) && (RAWFound == 1'b0) && (RBWFound == 1'b0))) begin
               `DEBUG($psprintf(" DEBUG_EVICT. Start Delete2 time %t   ", $time))
            if(memArray.exists(l2WrTr.addr) || evictMemArray.exists(l2WrTr.addr) )  begin
               evictMemArray.delete(l2WrTr.addr);
               evictMemArrayOld.delete(l2WrTr.addr);
                     `DEBUG($psprintf(" DDEBUG_EVICT 2  MEM_DELETE 0x%0x -->   %0t  ", l2WrTr.addr,$time))
               memArray.delete(l2WrTr.addr);
               memArrayOld.delete(l2WrTr.addr);
               `DEBUG($psprintf(" DEBUG_EVICT. RM_MEM After Write Read or Write found. Removeing all Mem's. time %t Read req %s  ", $time,l2WrTr.creqSprint))
               if(memArray.exists(l2WrTr.addr) || evictMemArray.exists(l2WrTr.addr) )  begin
                 `ERROR($psprintf(" DEBUG_EVICT. RM_MEM  MEM not delete. Addr 0x%x", l2WrTr.addr))
               end
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

          if((EvictDataMatch == 1) )  begin
             `DEBUG($psprintf(" CACHE EVICT DATA MATCH Addr 0x%x",l2WrTr.addr ))
          end else begin
                      `TB_YAP($psprintf(" CACHE EVICT DATA NOT MATCH "))
                      `TB_YAP($psprintf(" L2 EVICT   TR cReq %s  ", l2WrTr.creqSprint))
                      `TB_YAP($psprintf(" L2 EVICT    Data 0x%x  ", l2WrTr.data[0]))
                      `ERROR($psprintf(" =======CPU WRITE MISMACH =============="))
          end

  end  // end while
endtask

task isEmptyReqQueue();
    bit isEmpty;
    begin
       isEmpty = 0;
       while(isEmpty == 0) begin
          clock(1000);
          isEmpty = mstTr[0].isEmptyReqQueueMailBox();
       end
    end
endtask:isEmptyReqQueue


endclass:L2CacheTestBench
`endif

