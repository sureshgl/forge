`ifndef ME_CACHE_MASTER_TRANSACTOR
`define ME_CACHE_MASTER_TRANSACTOR
class MeCacheMasterTransactor #(int NXADDRWIDTH=31, int NXDATAWIDTH=256, int NXIDWIDTH=4, int NXTYPEWIDTH=3, int NXSIZEWIDTH=8, int NXATTRWIDTH=3) extends MeTransactor;

	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) ReqT;
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) wrReqT;
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rdReqT;
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rwRspT;
	virtual Naxi_Ifc  #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH)  mAxiIfc;
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rwRspArray[*];
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) creqMonT;
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) dreqMonT;
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rreqMonT;
        reg [((NXIDWIDTH+1)*16)-1:0]inOrderCheckArray[*];
        string name;
        bit writeOpInProgress;
        bit readOpInProgress;
             bit stall_bit;
        integer i;
        reg idArray[{NXIDWIDTH{1'b1}}+1];
        reg [NXIDWIDTH-1:0] wrId;
        reg [NXIDWIDTH-1:0] rdId;
        reg [NXIDWIDTH-1:0] reqId;
        mailbox writeQueue;
        mailbox readQueue;
        mailbox reqQueue;
        event writeTransactionRspReceived;
        event readTransactionReceived;
        event creqBusMonitorReceived;
        event dreqBusMonitorReceived;
        event rreqBusMonitorReceived;
        bit isActive;
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
        reg [63:0]totalNonCacheWriteNOACKTr;

        reg [63:0] transactionId;
	function new (string name,bit isActive = 1);
	   begin
             super.new(name);
             this.name = name;
             this.isActive = isActive;
             `DEBUG($psprintf("Function New"))
             writeOpInProgress = 0;
             readOpInProgress = 0;
             writeQueue = new();
             readQueue = new();
             reqQueue = new();
             reqId = 0;
             wrId = 0;
             rdId = 0;
             transactionId = 0;
             for(i=0; i<={NXIDWIDTH{1'b1}}; i = i+1)
                  idArray[i] = 0;
           end
	endfunction:new
     
        task init(virtual Naxi_Ifc#(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) mAxiIfc);
           begin
              this.mAxiIfc = mAxiIfc;
             `DEBUG($psprintf("Task Init"))
           end
        endtask:init

        task reset ();
           begin
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
              transactionId = 0;
           end
           end
        endtask:reset

        task clear ();
           begin
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
              transactionId = 0;
              totalTransactions= 0;
              totalCacheWriteTr= 0;
              totalCacheReadTr= 0;
              totalNonCacheWriteTr= 0;
              totalNonCacheReadTr= 0;
              totalFlushTr= 0;
              totalInvalidTr= 0;
              totalCacheWriteACKTr= 0;
              totalCacheWriteNOACKTr= 0;
              totalNonCacheWriteACKTr= 0;
              totalNonCacheWriteNOACKTr= 0;
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
              countTrID();
 
           join_none 
        endtask:drive

       task monitor();
             `DEBUG($psprintf("Task Monitor"))
           fork
              rdDataWrRspMonitor(); 
              creqBusMonitor(); 
              dreqBusMonitor(); 
              rreqBusMonitor(); 
           join_none 
        endtask:monitor

        task countTrID();
           while(1) begin
                transactionId[63:0] = transactionId[63:0] + 1;
                clock(1);
           end
        endtask:countTrID



       task reqDrive();
          reg [NXIDWIDTH-1:0]ID = 0;
          while(1)
             begin
                reqQueue.get(ReqT);
                totalTransactions[63:0] = totalTransactions[63:0] + 1;
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
                       	mAxiIfc.cbMstDrv.dreqData <=ReqT.data; 
                       	mAxiIfc.cbMstDrv.dreqAttr <=ReqT.dattr; 
                       	mAxiIfc.cbMstDrv.dreqId   <=ReqT.dId; 
                       	mAxiIfc.cbMstDrv.dreqValid <=1;
                       end
                       clock(1);
                       while((mAxiIfc.cbMstDrv.creqWrStall == 1 ) ||( mAxiIfc.cbMstDrv.creqRdStall== 1 )|| (mAxiIfc.cbMstDrv.dreqStall== 1 )) begin
                          `DEBUG($psprintf("Mst reqDrive Stall Detected   Add 0x%x id %x",ReqT.addr,ReqT.cId))
                           clock(1);
                       end
                       if(ReqT.reqType == CH_WRITE)  begin
                            if(ReqT.cattr[1] == CH_REQ_CACHE) begin
                               totalCacheWriteTr[63:0]= totalCacheWriteTr[63:0] + 1;
                               if(ReqT.cattr[0] == CH_REQ_ACK) begin
                                  totalCacheWriteACKTr[63:0]= totalCacheWriteACKTr[63:0] + 1;
                               end else begin
                                  totalCacheWriteNOACKTr[63:0]= totalCacheWriteNOACKTr[63:0] + 1;
                               end
                            end else begin
                               totalNonCacheWriteTr[63:0]= totalNonCacheWriteTr[63:0] + 1;
                               if(ReqT.cattr[0] == CH_REQ_ACK) begin
                                  totalNonCacheWriteACKTr[63:0]= totalNonCacheWriteACKTr[63:0] + 1;
                               end else begin
                                  totalNonCacheWriteNOACKTr[63:0]= totalNonCacheWriteNOACKTr[63:0] + 1;
                               end
                            end
                       end else if(ReqT.reqType == CH_FLUSH)  begin
                            totalFlushTr[63:0] = totalFlushTr[63:0] + 1;
                       end else if(ReqT.reqType == CH_INVAL)  begin
                            totalInvalidTr[63:0] = totalInvalidTr[63:0] + 1;
                       end
  
                       ReqT.transactionId = transactionId[63:0];
                       ReqT.transactionTime = $time;                    
                       if(ReqT.cattr[0] == CH_REQ_ACK) begin
                          rwRspArray[wrId[NXIDWIDTH-1:0]] = ReqT;
                          wrId[NXIDWIDTH-1:0] = 0;
                          updateInOrderArray(ReqT);
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
                         ReqT.transactionId = transactionId[63:0];                    
                         ReqT.transactionTime = $time;                    
                      if(ReqT.cattr[1] == CH_REQ_CACHE)  begin
                            totalCacheReadTr[63:0] = totalCacheReadTr[63:0] + 1;
                            updateInOrderArray(ReqT);
                       end else begin
                            totalNonCacheReadTr[63:0] = totalNonCacheReadTr[63:0] + 1;
                       end
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
          while(1)
             begin
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
                  rwRspT.data   = mAxiIfc.cbMstDrv.rreqData;
                  rwRspT.rId    = mAxiIfc.cbMstDrv.rreqId;
                  rwRspT.rattr  = mAxiIfc.cbMstDrv.rreqAttr;
                  if(rwRspT.rId != rwRspT.cId) begin
                     `DEBUG($psprintf("Request ID and Responce ID is Not Match  %s",rwRspT.creqSprint))
                     `DEBUG($psprintf("Request ID and Responce ID is Not Match  %s",rwRspT.rreqSprint))
                     `ERROR($psprintf("===========FAIL============"))
                  end
                  idArray[rwRspT.rId] = 0;
                  rwRspArray.delete(mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]);
                  checkInOrderArray(rwRspT);
                  if(rwRspT.reqType == CH_READ)
                    readDataReceived();
                  else 
                    writeRspReceived();
               end
               clock(1);
             end
       endtask:rdDataWrRspMonitor

	
 
       task creqBusMonitor();
          while(1)
             begin
               wait( (mAxiIfc.cbMstMon.creqValid == 1) &&
                     (mAxiIfc.cbMstMon.creqRdStall == 0) && (mAxiIfc.cbMstMon.creqWrStall == 0) 
                   );
                     creqMonT = new();
                     creqMonT.transactionId = transactionId[63:0];
                     creqMonT.transactionTime = $time;                    
                     creqMonT.addr = mAxiIfc.cbMstMon.creqAddr;
                     creqMonT.cattr = mAxiIfc.cbMstMon.creqAttr;
                     creqMonT.size = mAxiIfc.cbMstMon.creqSize;
                     creqMonT.cId = mAxiIfc.cbMstMon.creqId;
                     creqMonT.reqType = mAxiIfc.cbMstMon.creqType;
                     creqBusMonReceived();
               clock(1);
             end
       endtask:creqBusMonitor

       task dreqBusMonitor();
          while(1)
             begin
               wait ((mAxiIfc.cbMstMon.dreqValid == 1) && (mAxiIfc.cbMstMon.dreqStall == 0)); 
                     dreqMonT = new();
                     dreqMonT.data = mAxiIfc.cbMstMon.dreqData;
                     dreqMonT.dattr = mAxiIfc.cbMstMon.dreqAttr;
                     dreqMonT.dId = mAxiIfc.cbMstMon.dreqId;
                     dreqBusMonReceived();
               clock(1);
             end
       endtask:dreqBusMonitor

       task rreqBusMonitor();
          while(1)
             begin
               wait ((mAxiIfc.cbMstMon.rreqValid == 1) && (mAxiIfc.cbMstMon.rreqStall == 0)); 
                     rreqMonT = new();
                     rreqMonT.data = mAxiIfc.cbMstMon.rreqData;
                     rreqMonT.rattr = mAxiIfc.cbMstMon.rreqAttr;
                     rreqMonT.rId = mAxiIfc.cbMstMon.rreqId;
                     rreqBusMonReceived();
               clock(1);
             end
       endtask:rreqBusMonitor



       



       task send (MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) t);
          begin

             reqQueue.put(t);
            /* if(t.reqType == CH_READ)
               readQueue.put(t);
             else
               writeQueue.put(t);*/
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

     task writeRspReceive (ref MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) t);
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

     task readDataReceive (ref MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) t);
        begin
           waitUntilReadDatareceived();
           t = rwRspT;
        end
     endtask:readDataReceive


      task creqBusMonReceived();
         begin
           -> creqBusMonitorReceived;
         end
      endtask: creqBusMonReceived

      task waitUntilCreqBusMonitorReceived();
         begin
           @(creqBusMonitorReceived);
         end
      endtask:waitUntilCreqBusMonitorReceived 

     task creqBusMonReceive (ref MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) t);
        begin
           waitUntilCreqBusMonitorReceived();
           t = creqMonT;
        end
     endtask:creqBusMonReceive


      task dreqBusMonReceived();
         begin
           -> dreqBusMonitorReceived;
         end
      endtask: dreqBusMonReceived

      task waitUntilDreqBusMonitorReceived();
         begin
           @(dreqBusMonitorReceived);
         end
      endtask:waitUntilDreqBusMonitorReceived 

     task dreqBusMonReceive (ref MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) t);
        begin
           waitUntilDreqBusMonitorReceived();
           t = dreqMonT;
        end
     endtask:dreqBusMonReceive



      task rreqBusMonReceived();
         begin
           -> rreqBusMonitorReceived;
         end
      endtask: rreqBusMonReceived

      task waitUntilRreqBusMonitorReceived();
         begin
           @(rreqBusMonitorReceived);
         end
      endtask:waitUntilRreqBusMonitorReceived 

     task rreqBusMonReceive (ref MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) t);
        begin
           waitUntilRreqBusMonitorReceived();
           t = rreqMonT;
        end
     endtask:rreqBusMonReceive





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

function isEmptyidArray;
integer k;
reg isEmptyArray; 
begin
      isEmptyArray = 1;
      for(k=0; k<={NXIDWIDTH{1'b1}}; k = k+1) begin
        if(idArray[k] == 1) begin
           isEmptyArray = 0;
          `DEBUG($psprintf("isEmptyidArray is Not Empty %x",k))
           k = {NXIDWIDTH{1'b1}} + 1;
        end
      end
      isEmptyidArray = isEmptyArray;
end 
endfunction:isEmptyidArray

function isEmptyReqMailBox;
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
          `INFO($psprintf("isEmptyReqMailBox  Count %d  isEmptyMailBox %d ",reqQueueCount,isEmptyMailBox))
      isEmptyReqMailBox = isEmptyMailBox;
end 
endfunction:isEmptyReqMailBox


task updateInOrderArray (MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH)reqTr);
reg [((NXIDWIDTH+1)*16)-1:0]idClubData;
reg [(NXIDWIDTH+1)-1:0]idData;
reg [NXADDRWIDTH-1:0]cpuReqAddr;
reg [NXIDWIDTH-1:0]cpuReqId;
bit InOrderArray;
integer k,l,m,n;
cpuReqAddr[NXADDRWIDTH-1:0] = reqTr.addr;
cpuReqId[NXIDWIDTH-1:0] = reqTr.cId;
cpuReqAddr[4:0] = 'h0;
idClubData[((NXIDWIDTH+1)*16)-1:0] = 'h0;
idData[(NXIDWIDTH+1)-1:0] = 'h0;
InOrderArray = 0;
     if(reqTr.cattr[1] == CH_REQ_CACHE) begin
        `DEBUG($psprintf("updateInOrderArray Req ADDR 0x%0x  ", cpuReqAddr[NXADDRWIDTH-1:0]))
        `DEBUG($psprintf("updateInOrderArray Req creq %s  ", reqTr.creqSprint))
        if(inOrderCheckArray.exists(cpuReqAddr[NXADDRWIDTH-1:0]))  begin
            idClubData[((NXIDWIDTH+1)*16)-1:0] = inOrderCheckArray[cpuReqAddr[NXADDRWIDTH-1:0]];
            `DEBUG($psprintf("updateInOrderArray Total Pending Req idClubData 0x%0x  ", idClubData[((NXIDWIDTH+1)*16)-1:0]))
            for(k=0; k<16; k = k+1) begin
                idData[(NXIDWIDTH+1)-1:0] = idClubData[((NXIDWIDTH+1)*16)-1:0] >> k*(NXIDWIDTH+1);
                `DEBUG($psprintf("updateInOrderArray k=%d Pending Order idData 0x%0x --> 0x%0x ", k,idData[(NXIDWIDTH+1)-1:0],idData[NXIDWIDTH+-1:0]))
                if(idData[NXIDWIDTH] == 1'b0)  begin
                   idData[(NXIDWIDTH+1)-1:0] = {1'b1,cpuReqId[NXIDWIDTH-1:0]};
                   idClubData[((NXIDWIDTH+1)*16)-1:0] = idClubData[((NXIDWIDTH+1)*16)-1:0] | idData[(NXIDWIDTH+1)-1:0] << k*(NXIDWIDTH+1);
                   inOrderCheckArray[cpuReqAddr[NXADDRWIDTH-1:0]] = idClubData[((NXIDWIDTH+1)*16)-1:0];
                  `DEBUG($psprintf("updateInOrderArray adding New Pending Req. idData 0x%x --> 0x%x  idClubData 0x%0x  ", idData[(NXIDWIDTH+1)-1:0],idData[NXIDWIDTH+-1:0],idClubData[((NXIDWIDTH+1)*16)-1:0]))
                   k = 16;
                   InOrderArray = 1;
                end
            end
            if(InOrderArray == 1'b0) begin
              `ERROR($psprintf("updateInOrderArray not set for creq %s  ", reqTr.creqSprint))
            end
        end else begin
           idClubData[((NXIDWIDTH+1)*16)-1:0] = {1'b1,cpuReqId[NXIDWIDTH-1:0]};
           inOrderCheckArray[cpuReqAddr[NXADDRWIDTH-1:0]] = idClubData[((NXIDWIDTH+1)*16)-1:0];
           `DEBUG($psprintf("updateInOrderArray1 idClubData 0x%0x  ", idClubData[((NXIDWIDTH+1)*16)-1:0]))
        end
     end
endtask:updateInOrderArray


task checkInOrderArray (MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH)reqTr);
reg [((NXIDWIDTH+1)*16)-1:0]idClubData;
reg [(NXIDWIDTH+1)-1:0]idData;
reg [NXADDRWIDTH-1:0]cpuReqAddr;
reg [NXIDWIDTH-1:0]cpuReqId;
bit InOrderArray;
integer k,l,m,n;
cpuReqAddr[NXADDRWIDTH-1:0] = reqTr.addr;
cpuReqId[NXIDWIDTH-1:0] = reqTr.cId;
cpuReqAddr[4:0] = 'h0;
idClubData[((NXIDWIDTH+1)*16)-1:0] = 'h0;
idData[(NXIDWIDTH+1)-1:0] = 'h0;
InOrderArray = 0;
     if(reqTr.cattr[1] == CH_REQ_CACHE) begin
        `DEBUG($psprintf("checkInOrderArray Req ADDR 0x%0x  ", cpuReqAddr[NXADDRWIDTH-1:0]))
        `DEBUG($psprintf("checkInOrderArray Req creq %s  ", reqTr.creqSprint))
        if(inOrderCheckArray.exists(cpuReqAddr[NXADDRWIDTH-1:0]))  begin
            idClubData[((NXIDWIDTH+1)*16)-1:0] = inOrderCheckArray[cpuReqAddr[NXADDRWIDTH-1:0]];
              `DEBUG($psprintf("checkInOrderArray Total Pending Req idClubData 0x%0x  ", idClubData[((NXIDWIDTH+1)*16)-1:0]))
               idData[(NXIDWIDTH+1)-1:0] = idClubData[((NXIDWIDTH+1)*16)-1:0];
              `DEBUG($psprintf("checkInOrderArray Top Of the Pending idData 0x%0x --> 0x%0x ", idData[(NXIDWIDTH+1)-1:0],idData[(NXIDWIDTH)-1:0]))
               if(idData[NXIDWIDTH] == 1'b1)  begin
                   if(idData[NXIDWIDTH-1:0] != cpuReqId[NXIDWIDTH-1:0]) begin
                    `TB_YAP($psprintf("checkInOrderArray  FAIL idData 0x%0x  cpuReqId[NXIDWIDTH-1:0] ",idData[(NXIDWIDTH+1)-1:0],cpuReqId[NXIDWIDTH-1:0]))
                    `ERROR($psprintf("checkInOrderArray FAIL for rsv Req  %s  ", reqTr.creqSprint))
                   end else begin
                     idClubData[((NXIDWIDTH+1)*16)-1:0] = idClubData[((NXIDWIDTH+1)*16)-1:0] >> (NXIDWIDTH+1);
                     if(idClubData[((NXIDWIDTH+1)*16)-1:0] == 'h0) begin
                        inOrderCheckArray.delete(cpuReqAddr[NXADDRWIDTH-1:0]);
                     end else begin
                         inOrderCheckArray[cpuReqAddr[NXADDRWIDTH-1:0]] = idClubData[((NXIDWIDTH+1)*16)-1:0];
                     end
                     `DEBUG($psprintf("checkInOrderArray Update Array After remove Mach Rsp idClubData 0x%0x  ", idClubData[((NXIDWIDTH+1)*16)-1:0]))
                   end
               end else begin
                  `ERROR($psprintf("checkInOrderArray Valid Not set Top od ID Req 0x%0x  ",idData[(NXIDWIDTH+1)-1:0] ))
               end
        end else begin
           `ERROR($psprintf("checkInOrderArray inOrderCheckArray is Empty but Req Rsv %s  ", reqTr.creqSprint))
        end
     end
endtask:checkInOrderArray

endclass:MeCacheMasterTransactor
`endif






