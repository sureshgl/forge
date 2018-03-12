`ifndef ME_CACHE_MASTER_TRANSACTOR
`define ME_CACHE_MASTER_TRANSACTOR
class MeCacheMasterTransactor #(int NXADDRWIDTH=49, int NXDATAWIDTH=256, int NXIDWIDTH=2, int NXTYPEWIDTH=3, int NXSIZEWIDTH=8, int NXATTRWIDTH=3) extends MeTransactor;

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
        reg stallEn;
        bit isActive;
        reg [63:0]totalTransactions;
        reg [63:0]totalNonPrefetch;
        reg [63:0]totalPrefetch;
        reg [63:0]totalInvalidTr;
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
             for(i=0; i<={NXIDWIDTH{1'b1}}; i = i+1)
                  idArray[i] = 0;
             if ($value$plusargs("stallEn=%d",stallEn)) begin
               `DEBUG($psprintf("stallEn=%d",stallEn))
             end else begin
                stallEn = 0;
                `DEBUG($psprintf("stallEn=%d",stallEn))
             end
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
              totalTransactions = 0;
              totalNonPrefetch = 0;
              totalPrefetch = 0;
              totalInvalidTr = 0;
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
              //wrDrive(); 
              //rdAddrDrive(); 
              reqDrive();
              rrstallDrive();
 
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



       task reqDrive();
          reg [NXIDWIDTH-1:0]ID = 0;
          while(1)
             begin
                reqQueue.get(ReqT);
                ID[NXIDWIDTH-1:0]= 0;
                idSelTask(ID);
                reqId[NXIDWIDTH-1:0] = ID[NXIDWIDTH-1:0];
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
                    end else if(ReqT.reqType == CH_INVAL) begin
                       totalInvalidTr[63:0] = totalInvalidTr[63:0] + 1;
                    end
                       clock(1);
                       while((mAxiIfc.cbMstDrv.creqWrStall == 1 ) ||( mAxiIfc.cbMstDrv.creqRdStall== 1 )|| (mAxiIfc.cbMstDrv.dreqStall== 1 )) begin
                       `DEBUG($psprintf("Mst reqDrive Stall Detected   Add 0x%x id %x",ReqT.addr,ReqT.cId))
                      clock(1); end
                       totalTransactions[63:0] = totalTransactions[63:0] + 1;
                       ReqT.transactionTime = $time;
                       if(ReqT.cattr[0] == CH_REQ_ACK) begin
                          updateInOrderArray(ReqT);
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
                      totalTransactions[63:0] = totalTransactions[63:0] + 1;
                      if(ReqT.cattr[0] == CH_REQ_ACK) begin
                         updateInOrderArray(ReqT);
                         totalNonPrefetch[63:0] = totalNonPrefetch[63:0] + 1;
                         rwRspArray[rdId[NXIDWIDTH-1:0]] = ReqT;
                      end else begin
                         idArray[rdId[NXIDWIDTH-1:0]] = 0;
                         totalPrefetch[63:0] = totalPrefetch[63:0] + 1;
                      end
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
  //             clock(20);

          end
    endtask:reqDrive

      /* task wrDrive();
       endtask:wrDrive


       task rdAddrDrive();
       endtask:rdAddrDrive */

      task rrstallDrive();
          while(1)
             begin
               stall_bit = stallEn ? $urandom_range(0,1) : 0;
               clock(1);
               if(isActive == 1) 
                  mAxiIfc.cbMstDrv.rreqStall <= 0; 
             end
       endtask:rrstallDrive


   /*    task rdDataWrRspMonitor();
          while(1)
             begin
               wait(mAxiIfc.cbMstDrv.rreqValid == 1);
               if(isActive == 1) begin
                  `DEBUG($psprintf("Mst rdDataWrRspMonitor id %d",mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]))
                  if(!(rwRspArray.exists(mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]))) begin
                     `ERROR($psprintf("Mst 1 rdDataWrRspMonitor id %d",mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]))
                     //$finish; 
                     end
                  rwRspT = new();
                  rwRspT = rwRspArray[mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]];
                  rwRspT.data   = mAxiIfc.cbMstDrv.rreqData;
                  rwRspT.rId    = mAxiIfc.cbMstDrv.rreqId;
                  rwRspT.rattr  = mAxiIfc.cbMstDrv.rreqAttr;
                  if(rwRspT.rId != rwRspT.cId)
                    $finish;
                  idArray[rwRspT.rId] = 0;
                  rwRspArray.delete(mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]);
                  if(rwRspT.reqType == CH_READ)
                    readDataReceived();
                  else 
                    writeRspReceived();
               end
               clock(1);
             end
       endtask:rdDataWrRspMonitor*/


       task rdDataWrRspMonitor();
         integer i;
         bit done = 0;
          while(1)
             begin
               while(mAxiIfc.cbMstDrv.rreqValid == 0) clock(1);
                  `DEBUG($psprintf("Mst rdDataWrRspMonitor id %d in Flight",mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]))
                 if(!(rwRspArray.exists(mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]))) begin
                    `ERROR($psprintf("Mst 1 rdDataWrRspMonitor id %d",mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]))
                 end
                 rwRspT = new();
                 rwRspT = rwRspArray[mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]];
                 i = 0;
                 rwRspT.data[i] = mAxiIfc.cbMstDrv.rreqData;
                  `DEBUG($psprintf("King_0 %x  Beet %d ID %d",rwRspT.data[i],i,rwRspT.cId))
                 i = i+1;
                 done = 0;
                 while(done == 1'b0) begin
                    if(mAxiIfc.cbMstDrv.rreqAttr[0] == 1'b1) begin
                       rwRspT.rId    = mAxiIfc.cbMstDrv.rreqId;
                       rwRspT.rattr  = mAxiIfc.cbMstDrv.rreqAttr;
                       done = 1'b1;
                    end else begin
                       clock(1);
                       while(mAxiIfc.cbMstDrv.rreqValid == 0) clock(1);
                          rwRspT.data[i] = mAxiIfc.cbMstDrv.rreqData;
                  `DEBUG($psprintf("King_0 %x  Beet %d ID %d",rwRspT.data[i],i,rwRspT.rId))
                          i = i+1;
                    end
                 end
                 if(rwRspT.rId != rwRspT.cId) begin
                    `ERROR($psprintf("ID switched without sending all beats prev=%0x cur=%0x", rwRspT.rId, rwRspT.cId))
                    $finish;
                  end
                  rwRspT.noBeetsRsv = i;
                  idArray[rwRspT.rId] = 0;
                  checkInOrderArray(rwRspT);
                  rwRspArray.delete(mAxiIfc.cbMstDrv.rreqId[NXIDWIDTH-1:0]);
                  if(rwRspT.reqType == CH_READ)
                    readDataReceived();
                  else 
                    writeRspReceived();
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
                     creqMonT.addr = mAxiIfc.cbMstMon.creqAddr;
                     creqMonT.cattr = mAxiIfc.cbMstMon.creqAttr;
                     creqMonT.size = mAxiIfc.cbMstMon.creqSize;
                     creqMonT.cId = mAxiIfc.cbMstMon.creqId;
                     creqMonT.reqType = mAxiIfc.cbMstMon.creqType;
                     creqMonT.transactionTime = $time;
                     creqBusMonReceived();
               clock(1);
             end
       endtask:creqBusMonitor

       task dreqBusMonitor();
          while(1)
             begin
               wait ((mAxiIfc.cbMstMon.dreqValid == 1) && (mAxiIfc.cbMstMon.dreqStall == 0)); 
                     dreqMonT = new();
                     dreqMonT.data[0] = mAxiIfc.cbMstMon.dreqData;
                     dreqMonT.dattr = mAxiIfc.cbMstMon.dreqAttr;
                     dreqMonT.dId = mAxiIfc.cbMstMon.dreqId;
                     dreqBusMonReceived();
               clock(1);
             end
       endtask:dreqBusMonitor

       task rreqBusMonitor();
        integer i;
         bit done = 0;
          while(1)
             begin
               wait((mAxiIfc.cbMstMon.rreqValid == 1) && (mAxiIfc.cbMstMon.rreqStall == 0));
                 rreqMonT = new();
                 i = 0;
                 rreqMonT.data[i] = mAxiIfc.cbMstMon.rreqData;
                 i = i+1;
                 done = 0;
                 while(done == 1'b0) begin
                    if(mAxiIfc.cbMstMon.rreqAttr[0] == 1'b1) begin
                       rreqMonT.rId    = mAxiIfc.cbMstMon.rreqId;
                       rreqMonT.rattr  = mAxiIfc.cbMstMon.rreqAttr;
                       done = 1'b1;
                    end else begin
                       clock(1);
                       while(mAxiIfc.cbMstMon.rreqValid == 1) clock(1);
                          rreqMonT.data[i] = mAxiIfc.cbMstMon.rreqData;
                          i = i+1;
                    end
                 end
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

     //`DEBUG($psprintf("idArray is FULL emptyArry %d",emptyArry))
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
          `INFO($psprintf("isEmptyidArray is Not Empty %x",k))
           k = {NXIDWIDTH{1'b1}} + 1;
        end
      end
      isEmptyidArray = isEmptyArray;
end 
endfunction:isEmptyidArray


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

task updateInOrderArray (MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH)reqTr);
reg [((NXIDWIDTH+1)*16)-1:0]idClubData;
reg [(NXIDWIDTH+1)-1:0]idData;
reg [NXADDRWIDTH-1:0]cpuReqAddr;
reg [NXIDWIDTH-1:0]cpuReqId;
bit InOrderArray;
integer k,l,m,n;
cpuReqAddr[NXADDRWIDTH-1:0] = reqTr.addr;
cpuReqId[NXIDWIDTH-1:0] = reqTr.cId;
cpuReqAddr[7:0] = 'h0;
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
cpuReqAddr[7:0] = 'h0;
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
                    `TB_YAP($psprintf("checkInOrderArray  FAIL idData 0x%0x  cpuReqId[NXIDWIDTH-1:0] 0x%x ",idData[(NXIDWIDTH+1)-1:0],cpuReqId[NXIDWIDTH-1:0]))
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






