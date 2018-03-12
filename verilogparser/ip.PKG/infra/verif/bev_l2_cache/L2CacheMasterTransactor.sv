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
   string name;
   bit writeOpInProgress;
   bit readOpInProgress;
   bit stall_bit;
   bit isActive;
   integer i;
   reg idArray[{NXIDWIDTH{1'b1}}+1];
   reg [NXIDWIDTH-1:0] wrId;
   reg [NXIDWIDTH-1:0] rdId;
   reg [NXIDWIDTH-1:0] reqId;
   mailbox reqQueue;
   event writeTransactionRspReceived;
   event readTransactionReceived;
   event creqBusMonitorReceived;
   event dreqBusMonitorReceived;
   event rreqBusMonitorReceived;
   
   function new (string name,bit isActive = 1);begin
      super.new(name);
      this.name = name;
      this.isActive = isActive;
      `DEBUG($psprintf("Function New"))
      writeOpInProgress = 0;
      readOpInProgress = 0;
      reqQueue = new();
      reqId = 0;
      wrId = 0;
      rdId = 0;
      for(i=0; i<={NXIDWIDTH{1'b1}}; i = i+1)
           idArray[i] = 0;
      end
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
          rrstallDrive();
       join_none 
    endtask:drive
   
    task monitor();
        `DEBUG($psprintf("Task Monitor"))
        fork
           rdDataWrRspMonitor(); 
        join_none 
     endtask:monitor
   
    task reqDrive();
       reg [NXIDWIDTH-1:0]ID = 0;
       while(1) begin
          reqQueue.get(ReqT);
          ID[NXIDWIDTH-1:0]= 0;
          idSelTask(ID);
          reqId[NXIDWIDTH-1:0] = ID[NXIDWIDTH-1:0];
          `INFO($psprintf(" CPU_REQ_TO_CACHE   Req Addr %s  ", ReqT.creqSprint))
          if(ReqT.reqType != CH_READ) begin
             `DEBUG($psprintf("Mst wrDrive  Add 0x%x id %x",ReqT.addr,ReqT.cId))
              wrId[NXIDWIDTH-1:0] = ID[NXIDWIDTH-1:0];
              ReqT.cId = wrId[NXIDWIDTH-1:0];
              ReqT.dId = wrId[NXIDWIDTH-1:0];
              mAxiIfc.cbMstDrv.creqAddr <=ReqT.addr; 
              mAxiIfc.cbMstDrv.creqAttr <=ReqT.cattr; 
              mAxiIfc.cbMstDrv.creqSize <=ReqT.size; 
              mAxiIfc.cbMstDrv.creqId   <= ReqT.cId; 
              mAxiIfc.cbMstDrv.creqType <=ReqT.reqType; 
              mAxiIfc.cbMstDrv.creqValid <=1;
              if(ReqT.reqType == CH_WRITE) begin 
                 mAxiIfc.cbMstDrv.dreqData <=ReqT.data[0]; 
                 mAxiIfc.cbMstDrv.dreqAttr <=ReqT.dattr; 
                 mAxiIfc.cbMstDrv.dreqId   <=ReqT.dId; 
                 mAxiIfc.cbMstDrv.dreqValid <=1;
              end
              clock(1);
              while((mAxiIfc.cbMstDrv.creqWrStall == 1 ) ||( mAxiIfc.cbMstDrv.creqRdStall== 1 )|| (mAxiIfc.cbMstDrv.dreqStall== 1 )) begin
                 `DEBUG($psprintf("Mst reqDrive Stall Detected   Add 0x%x id %x",ReqT.addr,ReqT.cId))
                  clock(1);
              end
              if(ReqT.cattr[0] == CH_REQ_ACK) begin
                 rwRspArray[wrId[NXIDWIDTH-1:0]] = ReqT;
                 wrId[NXIDWIDTH-1:0] = 0;
              end else begin
                 idArray[wrId[NXIDWIDTH-1:0]] = 0;
                 wrId[NXIDWIDTH-1:0] = 0;
              end
          end else begin
             `DEBUG($psprintf("Mst rdAddrDrive id %d",ReqT.cId))
             rdId[NXIDWIDTH-1:0] = ID[NXIDWIDTH-1:0];
             ReqT.cId = rdId[NXIDWIDTH-1:0];
             mAxiIfc.cbMstDrv.creqAddr <=ReqT.addr; 
             mAxiIfc.cbMstDrv.creqAttr <=ReqT.cattr; 
             mAxiIfc.cbMstDrv.creqSize <=ReqT.size; 
             mAxiIfc.cbMstDrv.creqId   <=ReqT.cId; 
             mAxiIfc.cbMstDrv.creqType <=ReqT.reqType; 
             mAxiIfc.cbMstDrv.creqValid <=1;
             clock(1);
             while((mAxiIfc.cbMstDrv.creqWrStall == 1) || (mAxiIfc.cbMstDrv.creqRdStall == 1))clock(1);
             ReqT.transactionTime = $time;
             rwRspArray[rdId[NXIDWIDTH-1:0]] = ReqT;
             rdId[NXIDWIDTH-1:0] = 0;
          end
          mAxiIfc.cbMstDrv.creqAddr <=0; 
          mAxiIfc.cbMstDrv.creqAttr <=0; 
          mAxiIfc.cbMstDrv.creqSize <=0; 
          mAxiIfc.cbMstDrv.creqId   <=0; 
          mAxiIfc.cbMstDrv.creqType <=0; 
          mAxiIfc.cbMstDrv.creqValid <=0;
    
          mAxiIfc.cbMstDrv.dreqData <=0; 
          mAxiIfc.cbMstDrv.dreqAttr <=0; 
          mAxiIfc.cbMstDrv.dreqId <=0; 
          mAxiIfc.cbMstDrv.dreqValid <=0;
      end
   endtask:reqDrive
   
   
   task rrstallDrive();
       while(1)begin
          clock(1);
          if(isActive == 1) 
             mAxiIfc.cbMstDrv.rreqStall <= 0; 
       end
    endtask:rrstallDrive
   
   
   task rdDataWrRspMonitor();
      while(1)
         begin
           wait(mAxiIfc.cbMstDrv.rreqValid == 1);
           if(isActive == 1) begin
              `DEBUG($psprintf("Mst rdDataWrRspMonitor id %d",mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]))
              if(!(rwRspArray.exists(mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]))) begin
                 `ERROR($psprintf("Mst 1 rdDataWrRspMonitor id %d",mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]))
              end
              rwRspT = new();
              rwRspT = rwRspArray[mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]];
              rwRspT.data[0]   = mAxiIfc.cbMstDrv.rreqData;
              rwRspT.rId    = mAxiIfc.cbMstDrv.rreqId;
              rwRspT.rattr  = mAxiIfc.cbMstDrv.rreqAttr;
              if(rwRspT.rId != rwRspT.cId) begin
                 `DEBUG($psprintf("Request ID and Responce ID is Not Match  %s",rwRspT.creqSprint))
                 `DEBUG($psprintf("Request ID and Responce ID is Not Match  %s",rwRspT.rreqSprint))
                 `ERROR($psprintf("===========FAIL============"))
              end
              idArray[rwRspT.rId] = 0;
              rwRspArray.delete(mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]);
              if(rwRspT.reqType == CH_READ)
                readDataReceived();
              else 
                writeRspReceived();
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
   
   
   
   
   
   
endclass:L2CacheMasterTransactor
`endif
   
   
   
   
   
   
