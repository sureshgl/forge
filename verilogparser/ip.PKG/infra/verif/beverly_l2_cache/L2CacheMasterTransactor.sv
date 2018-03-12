`ifndef L2_CACHE_MASTER_TRANSACTOR
`define L2_CACHE_MASTER_TRANSACTOR
class L2CacheMasterTransactor #(int NXADDRWIDTH=31, int NXDATAWIDTH=256, int NXIDWIDTH=4, int NXTYPEWIDTH=3, int NXSIZEWIDTH=8, int NXATTRWIDTH=3) extends MeTransactor;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) ReqT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) wrReqT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rdReqT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rwRspT;
   virtual Naxi_Ifc  #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH)  mAxiIfc;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rwRspArray[*];
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) creqMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) dreqMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rreqMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) invalMonT;
   reg [((NXIDWIDTH+1)*16)-1:0]inOrderCheckArray[*];
   reg [NXADDRWIDTH-1:0]rdAddrArray[*];
   string name;
   bit writeOpInProgress;
   bit readOpInProgress;
   bit stall_bit;
   bit isActive;
   integer i;
   reg idArray[{NXIDWIDTH{1'b1}}+1];
   reg [NXIDWIDTH-1:0] Id;
   reg [NXIDWIDTH-1:0] wrId;
   reg [NXIDWIDTH-1:0] rdId;
   reg [NXIDWIDTH-1:0] reqId;
   mailbox reqQueue;
   event writeTransactionRspReceived;
   event readTransactionReceived;
   event creqBusMonitorReceived;
   event dreqBusMonitorReceived;
   event rreqBusMonitorReceived;
   mailbox wrRdAddMon;
   mailbox wrDataMon;
   mailbox reqMonQueue;
   mailbox syncQueue;
   reg [63:0]transactionId; 
   bit syncToken = 1; 
   mailbox wrDataQueue; 
   bit stallEn;
   function new (string name,bit isActive = 1);begin
      super.new(name);
      this.name = name;
      this.isActive = isActive;
      `DEBUG($psprintf("Function New"))
      writeOpInProgress = 0;
      readOpInProgress = 0;
      reqQueue = new();
      wrDataQueue = new();
      wrRdAddMon = new();
      wrDataMon = new();
      reqMonQueue = new();
      syncQueue = new();
      reqId = 0;
      wrId = 0;
      rdId = 0;
      transactionId = 'h0;
      for(i=0; i<={NXIDWIDTH{1'b1}}; i = i+1)
           idArray[i] = 0;
      end
      stallEn = 1;
   endfunction:new
        
   task init(virtual Naxi_Ifc#(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) mAxiIfc); begin
      this.mAxiIfc = mAxiIfc;
     `DEBUG($psprintf("Task Init"))
      end
   endtask:init
   
   task reset (); begin
      if(isActive == 1) begin
         `DEBUG($psprintf("Task Reset"))
          mAxiIfc.cbMstDrv.creqAddr <=0; 
          mAxiIfc.cbMstDrv.creqAttr <=0; 
          mAxiIfc.cbMstDrv.creqSize <=0; 
          mAxiIfc.cbMstDrv.creqId <=0; 
          mAxiIfc.cbMstDrv.creqType <=0; 
          mAxiIfc.cbMstDrv.creqValid <=0;
   
          mAxiIfc.cbMstDrv.dreqData <=0; 
          mAxiIfc.cbMstDrv.dreqAttr <=0; 
          mAxiIfc.cbMstDrv.dreqId <=0; 
          mAxiIfc.cbMstDrv.dreqValid <=0; 
   
          mAxiIfc.cbMstDrv.rreqStall <=0; 
        end
      end
   endtask:reset
   
   task clear ();begin
      if(isActive == 1) begin
        `DEBUG($psprintf("Task Clear"))
         mAxiIfc.cbMstDrv.creqAddr <=0; 
         mAxiIfc.cbMstDrv.creqAttr <=0; 
         mAxiIfc.cbMstDrv.creqSize <=0; 
         mAxiIfc.cbMstDrv.creqId <=0; 
         mAxiIfc.cbMstDrv.creqType <=0; 
         mAxiIfc.cbMstDrv.creqValid <=0;
   
         mAxiIfc.cbMstDrv.dreqData <=0; 
         mAxiIfc.cbMstDrv.dreqAttr <=0; 
         mAxiIfc.cbMstDrv.dreqId <=0; 
         mAxiIfc.cbMstDrv.dreqValid <=0; 
   
         mAxiIfc.cbMstDrv.rreqStall <=0; 
        end
     end
   endtask:clear
   
   task run ();
      `DEBUG($psprintf("Task Run"))
      fork
         drive(); 
         monitor(); 
      join_none 
   endtask:run
   
   task drive();
       `DEBUG($psprintf("Task Drive"))
       fork
          reqDrive();
          reqWrDataDrive();
          rrstallDrive();
          countTrID();
       join_none 
    endtask:drive
   
    task monitor();
        `DEBUG($psprintf("Task Monitor"))
        fork
           rdDataWrRspMonitor();
           monitorReq();
        join_none 
     endtask:monitor

    task wrAddDrive(L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) ReqT); begin
       mAxiIfc.cbMstDrv.creqAddr <=ReqT.addr; 
       mAxiIfc.cbMstDrv.creqAttr <=ReqT.cattr; 
       mAxiIfc.cbMstDrv.creqSize <=ReqT.size; 
       mAxiIfc.cbMstDrv.creqId   <= ReqT.cId; 
       mAxiIfc.cbMstDrv.creqType <=ReqT.reqType; 
       mAxiIfc.cbMstDrv.creqValid <=1;
    end
    endtask

    task wrAddClear(); begin
       mAxiIfc.cbMstDrv.creqAddr <=0; 
       mAxiIfc.cbMstDrv.creqAttr <=0; 
       mAxiIfc.cbMstDrv.creqSize <=0; 
       mAxiIfc.cbMstDrv.creqId <=0; 
       mAxiIfc.cbMstDrv.creqType <=0; 
       mAxiIfc.cbMstDrv.creqValid <=0;
    end
    endtask
   
  /*  task reqDrive();
       reg [NXIDWIDTH-1:0]ID = 0;
       integer i,j,k;
       while(1) begin
          reqQueue.get(ReqT);
          ID[NXIDWIDTH-1:0]= 0;
          idSelTask(ID);
          reqId[NXIDWIDTH-1:0] = ID[NXIDWIDTH-1:0];
          if(ReqT.reqType != CH_READ) begin
              wrId[NXIDWIDTH-1:0] = ID[NXIDWIDTH-1:0];
              ReqT.cId = wrId[NXIDWIDTH-1:0];
              ReqT.dId = wrId[NXIDWIDTH-1:0];
              wrAddDrive(ReqT);
                `TB_YAP($psprintf("reqDrive %s  ",ReqT.creqSprint))
              for(i=0; i<ReqT.noBeets; i = i+1) begin
                `TB_YAP($psprintf("reqDrive %s  ",ReqT.creqSprint))
                mAxiIfc.cbMstDrv.dreqData <=ReqT.data[i]; 
                mAxiIfc.cbMstDrv.dreqId   <=ReqT.dId; 
                mAxiIfc.cbMstDrv.dreqValid <=1; 
                if(i == ReqT.noBeets-1) begin
                   mAxiIfc.cbMstDrv.dreqAttr <=ReqT.dattr; 
                end else begin
                   mAxiIfc.cbMstDrv.dreqAttr <=0; 
                end
                clock(1);
                wrAddClear();
                while((mAxiIfc.cbMstDrv.creqWrStall == 1 ) ||( mAxiIfc.cbMstDrv.creqRdStall== 1 )|| (mAxiIfc.cbMstDrv.dreqStall== 1 ))  clock(1);
              end
              if(ReqT.cattr[0] == CH_REQ_ACK) begin
                 rwRspArray[wrId[NXIDWIDTH-1:0]] = ReqT;
                 wrId[NXIDWIDTH-1:0] = 0;
              end else begin
                 idArray[wrId[NXIDWIDTH-1:0]] = 0;
                 wrId[NXIDWIDTH-1:0] = 0;
              end
          end else begin
             rdId[NXIDWIDTH-1:0] = ID[NXIDWIDTH-1:0];
             ReqT.cId = rdId[NXIDWIDTH-1:0];
             wrAddDrive(ReqT);
             clock(1);
             while((mAxiIfc.cbMstDrv.creqWrStall == 1) || (mAxiIfc.cbMstDrv.creqRdStall == 1))clock(1);
             ReqT.transactionTime = $time;
             rwRspArray[rdId[NXIDWIDTH-1:0]] = ReqT;
             rdId[NXIDWIDTH-1:0] = 0;
          end
          clear();
      end
   endtask:reqDrive */

     task reqDrive();
       reg [NXIDWIDTH-1:0]ID = 0;
       integer i,j,k;
       L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) ReqWrDataT;
       L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) wrRdAddReqT;
       while(1) begin
          reqQueue.get(ReqT);
          if(ReqT.reqType == CH_READ) begin
             blockRARadd(ReqT.addr);
          end
          ID[NXIDWIDTH-1:0]= 0;
          idSelTask(ID);
          reqId[NXIDWIDTH-1:0] = ID[NXIDWIDTH-1:0];
          Id[NXIDWIDTH-1:0] = ID[NXIDWIDTH-1:0];
          ReqT.cId = Id[NXIDWIDTH-1:0];
          if(ReqT.reqType == CH_WRITE) begin
            ReqT.dId = Id[NXIDWIDTH-1:0];
            ReqWrDataT = new ReqT;
            wrDataQueue.put(ReqWrDataT);
          end
          wrAddDrive(ReqT);
          //`TB_YAP($psprintf("reqDrive %s  ",ReqT.creqSprint))
          clock(1);
          while((mAxiIfc.cbMstDrv.creqWrStall == 1 ) ||( mAxiIfc.cbMstDrv.creqRdStall== 1 ))  clock(1);
          wrAddClear();
          ReqT.transactionId = transactionId;
          ReqT.transactionTime = $time;
          rwRspArray[Id[NXIDWIDTH-1:0]] = ReqT;
          if((ReqT.reqType == CH_READ)&& (ReqT.cattr == 'h3)) begin
          rdAddrArray[{(ReqT.addr >> 8),8'h0}] = 1;
          end
          if((ReqT.reqType == CH_READ)&& (ReqT.cattr == 'h2)) begin
          idArray[ReqT.cId] = 0;
          end
          Id[NXIDWIDTH-1:0] = 0;
          wrRdAddReqT = new ReqT;
          wrRdAddMon.put(wrRdAddReqT);
          if(ReqT.reqType == CH_WRITE) begin
            syncQueue.get(syncToken);
          end
      end
   endtask:reqDrive

   task reqWrDataDrive();
       reg [NXIDWIDTH-1:0]ID = 0;
       integer i,j,k;
       L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) WrDataT;
       L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) WrDataMonT;
       while(1) begin
          wrDataQueue.get(WrDataT);
          j = WrDataT.beetStart;
          for(i=0; i<WrDataT.noBeets; i = i+1) begin
            `DEBUG($psprintf("reqWrDataDrive %s  ",WrDataT.creqSprint))
            mAxiIfc.cbMstDrv.dreqData <=WrDataT.data[j]; 
            mAxiIfc.cbMstDrv.dreqId   <=WrDataT.dId; 
            mAxiIfc.cbMstDrv.dreqValid <=1; 
            if(i == WrDataT.noBeets-1) begin
               mAxiIfc.cbMstDrv.dreqAttr <=3'h1; 
            end else begin
               mAxiIfc.cbMstDrv.dreqAttr <=0; 
            end
            j = j+1;
            clock(1);
            while((mAxiIfc.cbMstDrv.dreqStall== 1 ))  clock(1);
            mAxiIfc.cbMstDrv.dreqValid <=0; 
            mAxiIfc.cbMstDrv.dreqData <='h0; 
            mAxiIfc.cbMstDrv.dreqId   <=0; 
            mAxiIfc.cbMstDrv.dreqAttr <=0; 
          end
         WrDataMonT = new WrDataT;
         wrDataMon.put(WrDataMonT);
         syncQueue.put(syncToken);
         if(WrDataT.cattr[0] == 1'b0) begin
           idArray[WrDataT.cId] = 0;
         end
       end
   endtask:reqWrDataDrive

   task monitorReq();
       L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) wrRdAddT;
       L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) WrDataMonT;
       L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) ReqMonT;
       while(1) begin
          wrRdAddMon.get(wrRdAddT);
          `TB_YAP($psprintf("monitorReq[]%s  ",wrRdAddT.creqSprint))
         if(wrRdAddT.reqType == CH_WRITE) begin
            wrDataMon.get(WrDataMonT);
            ReqMonT = new wrRdAddT;
            reqMonQueue.put(ReqMonT);
         end else begin
            ReqMonT = new wrRdAddT;
            reqMonQueue.put(ReqMonT);
         end
       end
   endtask:monitorReq
   

    task rrstallDrive();
       reg [7:0]stallEnCnt;
       reg [7:0]stallDisCnt;
       bit stall_bit_creq;
       while(1)
          begin
            if(stallEn == 1) begin
              stallEnCnt[7:0] = 0;
              stallDisCnt[7:0] = 0;
              stall_bit_creq = $urandom_range('b0,'b1);
              stallEnCnt[7:0] = (stall_bit_creq == 0) ?0 : $urandom_range(1,20);
              stallDisCnt[7:0] = (stall_bit_creq == 0) ?0 : $urandom_range(1,20);
            end else begin
              stallEnCnt[7:0] = 0;
              stallDisCnt[7:0] = 0;
            end
            clock(stallEnCnt[7:0]);
            mAxiIfc.cbMstDrv.rreqStall <= 0; 
            clock(1);
            clock(stallDisCnt[7:0]);
            mAxiIfc.cbMstDrv.rreqStall <= 1; 
          end
       endtask:rrstallDrive

   
   
   task rdDataWrRspMonitor();
      integer i,j;
      bit done = 0;
      while(1)
         begin
           wait((mAxiIfc.cbMstMon.rreqValid == 1) && (mAxiIfc.cbMstMon.rreqStall == 0));
           if(isActive == 1) begin
              if(!(rwRspArray.exists(mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]))) begin
                 `ERROR($psprintf("Mst 1 rdDataWrRspMonitor id %d",mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]))
              end
              rwRspT = new();
              rwRspT = rwRspArray[mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]];
              i = 0;
              done = 0;
              while(done == 1'b0) begin
                 while(mAxiIfc.cbMstMon.rreqValid != 1) clock(1);
                 if(mAxiIfc.cbMstMon.rreqAttr[0] == 1'b1) begin
                    rwRspT.data[i] = mAxiIfc.cbMstMon.rreqData;
                    rwRspT.rId    = mAxiIfc.cbMstMon.rreqId;
                    rwRspT.rattr  = mAxiIfc.cbMstMon.rreqAttr;
                    i = i+1;
                    rwRspT.noBeetsRsv = i;
                    done = 1'b1;
                    if(rwRspT.rId != rwRspT.cId) begin
                       `ERROR($psprintf("Request ID and Responce Loop=%0d ID is Not Match  Rid 0x%0x Cid 0x%0x",i,rwRspT.rId,rwRspT.cId))
                    end
                 end else begin
                    rwRspT.data[i] = mAxiIfc.cbMstMon.rreqData;
                    while(mAxiIfc.cbMstMon.rreqValid != 1) clock(1);
                    rwRspT.rId    = mAxiIfc.cbMstMon.rreqId;
                    if(rwRspT.rId != rwRspT.cId) begin
                       `ERROR($psprintf("Request ID and Responce MM Loop=%0d ID is Not Match  Rid 0x%0x Cid 0x%0x %0d time %0t",i,rwRspT.rId,rwRspT.cId,mAxiIfc.cbMstMon.rreqId,$time))
                    end
                    clock(1);
                    i = i+1;
                 end
                 if(i > 9) begin
                   `TB_YAP($psprintf("Number of Beets Mismach   0x%0x  time %0t",i,$time))
                   `ERROR($psprintf("Number of Beets Mismach   0x%0x ",i))
                 end
                `TB_YAP($psprintf("Time Loop End %0t",$time))
              end
              if(rwRspT.reqType == CH_READ) begin
                readDataReceived();
                rdAddrArray.delete({(rwRspT.addr >> 8),8'h0});
              end else begin
                writeRspReceived();
              end
              idArray[rwRspT.rId] = 0;
              rwRspArray.delete(mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]);
           end
           clock(1);
         end     
   endtask:rdDataWrRspMonitor
   
   	
    
   
   task send (L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) t);begin
         reqQueue.put(t);
      end
   endtask : send
   
   
   task writeRspReceived();
      begin
        -> writeTransactionRspReceived;
      end
   endtask:writeRspReceived

   task waitUntilWriteRspreceived();
      begin
        @(writeTransactionRspReceived);
      end
   endtask:waitUntilWriteRspreceived 

  task writeRspReceive (ref L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) t);
     begin
        waitUntilWriteRspreceived();
        t = rwRspT;
     end
  endtask:writeRspReceive


   task readDataReceived();
      begin
        -> readTransactionReceived;
      end
   endtask: readDataReceived

   task waitUntilReadDatareceived();
      begin
        @(readTransactionReceived);
      end
   endtask:waitUntilReadDatareceived 

  task readDataReceive (ref L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) t);
     begin
        waitUntilReadDatareceived();
        t = rwRspT;
     end
  endtask:readDataReceive
   
   task clock (integer numClocks = 1);
      begin
        repeat(numClocks)@(mAxiIfc.cbMstDrv);
      end
   endtask:clock
   
/*  
   task idSelTask(ref reg[NXIDWIDTH-1 : 0] id);
   reg [NXIDWIDTH-1 : 0] idSel;
   integer l;
   reg idDone; 
   reg emptyArry; 
   reg [31:0]MinVal,MaxVal;
   begin
   
   MinVal[31:0] = 0;
   MaxVal[31:0] = {NXIDWIDTH{1'b1}};
   
   emptyArry = 0;
   while(emptyArry == 0) begin
        for(l=0; l<={NXIDWIDTH{1'b1}}; l = l+1) begin
         if(idArray[l] == 0) begin
           emptyArry = 1;
           l = {NXIDWIDTH{1'b1}} + 1;
         end
        end
        if(emptyArry == 0) begin
   
        `DEBUG($psprintf("idArray is FULL emptyArry %d",emptyArry))
         clock(1);
        end
   end 
   
   
   idDone = 0;
   while(idDone == 0) begin
       idSel[NXIDWIDTH-1 : 0] = $urandom_range(MinVal,MaxVal);
       if(idArray[idSel[NXIDWIDTH-1 : 0]] == 0) begin
          idDone = 1;
          idArray[idSel[NXIDWIDTH-1 : 0]] = 1;
       end else if (idArray[idSel[NXIDWIDTH-1 : 0]] == 1) begin
          idSel[NXIDWIDTH-1 : 0] = 0;
          
       end
   end
     id[NXIDWIDTH-1 : 0]= idSel[NXIDWIDTH-1 : 0];
   end
   endtask:idSelTask
 */

task idSelTask(ref reg[NXIDWIDTH-1 : 0] id);
   reg [NXIDWIDTH-1 : 0] idSel;
   integer l,n;
   reg idDone; 
   reg emptyArry; 
   reg [31:0]MinVal,MaxVal;
   begin
   
   MinVal[31:0] = 0;
   MaxVal[31:0] = {NXIDWIDTH{1'b1}};
        for(l=0; l<={NXIDWIDTH{1'b1}}; l = l+1) begin
         if(idArray[l] == 1) begin
          `DEBUG($psprintf("idArray ID Busy %0x  NXIDWIDTH WIDTH %0d",l,NXIDWIDTH))
         end
        end
   
   emptyArry = 0;
   while(emptyArry == 0) begin
        for(l=0; l<={NXIDWIDTH{1'b1}}; l = l+1) begin
         if(idArray[l] == 0) begin
           emptyArry = 1;
           l = {NXIDWIDTH{1'b1}} + 1;
         end
        end
        if(emptyArry == 0) begin
   
        `DEBUG($psprintf("idArray is FULL emptyArry %d",emptyArry))
         clock(1);
        end
   end 
   
   
  /* idDone = 0;
   while(idDone == 0) begin
       idSel[NXIDWIDTH-1 : 0] = $urandom_range(MinVal,MaxVal);
       if(idArray[idSel[NXIDWIDTH-1 : 0]] == 0) begin
          idDone = 1;
          idArray[idSel[NXIDWIDTH-1 : 0]] = 1;
       end else if (idArray[idSel[NXIDWIDTH-1 : 0]] == 1) begin
          idSel[NXIDWIDTH-1 : 0] = 0;
          
       end

   end*/
   idDone = 0;
   while(idDone == 0) begin
     for(n=0; n<={NXIDWIDTH{1'b1}}; n = n+1) begin
        `DEBUG($psprintf("nxxxxxxxxxxxxxxxx  %d  xxxx %0d",n,idArray[n[NXIDWIDTH-1 : 0]]))
         if(idArray[n[NXIDWIDTH-1 : 0]] == 0) begin
          idArray[n[NXIDWIDTH-1 : 0]] = 1;
          idSel[NXIDWIDTH-1 : 0] = n[NXIDWIDTH-1 : 0];
          idDone =1;
          n = {NXIDWIDTH{1'b1}} + 1;
         end 
       end
       if(idDone == 0) clock(1);
    end

     
     id[NXIDWIDTH-1 : 0]= idSel[NXIDWIDTH-1 : 0];
   end
endtask:idSelTask
   
   
task countTrID();
    while(1) begin
      transactionId[63:0] = transactionId[63:0] + 1;
      clock(1);
    end
 endtask:countTrID

function isEmptyReqQueueMailBox;
reg isEmptyMailBox; 
integer reqQueueCount;
begin
      isEmptyMailBox = 0;
          reqQueueCount =reqQueue.num() ;
          if(reqQueueCount !=0 ) begin
               isEmptyMailBox = 0;
          end else begin
               isEmptyMailBox = 1;
          end
          `INFO($psprintf("reqQueue  Count %d  isEmptyMailBox %d ",reqQueueCount,isEmptyMailBox))
      isEmptyReqQueueMailBox = isEmptyMailBox;
end 
endfunction:isEmptyReqQueueMailBox

task blockRARadd(input [NXADDRWIDTH-1:0] cacheAddr);
   reg [NXADDRWIDTH-1:0] addr;
   begin
     addr[NXADDRWIDTH-1:0] =  {cacheAddr[NXADDRWIDTH-1:0] >> 8,8'h0};
     while(rdAddrArray.exists(addr[NXADDRWIDTH-1:0])) begin
          `DEBUG($psprintf(" RAR Pending 0x%0x  %0t",addr[NXADDRWIDTH-1:0],$time))
        clock(1);
     end
   end
endtask
   
endclass:L2CacheMasterTransactor
`endif
   
   
   
   
   
   
