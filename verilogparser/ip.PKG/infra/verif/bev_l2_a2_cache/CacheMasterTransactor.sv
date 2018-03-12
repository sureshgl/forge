`ifndef CACHE_MASTER_TRANSACTOR
`define CACHE_MASTER_TRANSACTOR
class CacheMasterTransactor #(int BITADDR=34, int BITDATA=512, int BITSEQN=16, int NUMBYLN=64,int XBITATR=3) extends MeTransactor;

	CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) ReqT;
	CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) wrReqT;
	CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) rdReqT;
	CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) rwRspT;
	virtual L2_M_Ifc  #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR)  mL2Ifc;
	CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) rwRspArray[*];
	CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) reqMonT;
	CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) rspMonT;
	CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) invalMonT;
        reg [((BITSEQN+1)*16)-1:0]inOrderCheckArray[*];
        string name;
        bit writeOpInProgress;
        bit readOpInProgress;
             bit stall_bit;
        integer i;
        reg idArray[{BITSEQN{1'b1}}+1];
        reg [BITSEQN-1:0] reqId;
        mailbox writeQueue;
        mailbox reqQueue;
        mailbox invalQueue;
        event writeTransactionRspReceived;
        event readTransactionReceived;
        event reqBusMonitorReceived;
        event rspBusMonitorReceived;
        bit isActive;
        reg stallEn;
        bit stallRandDistEn;
        bit stall_bit_creq;
        reg [63:0] transactionId;
        reg [63:0] totalTransactions;
	function new (string name,bit isActive = 1);
	   begin
             super.new(name);
             this.name = name;
             this.isActive = isActive;
             `DEBUG($psprintf("Function New"))
             writeOpInProgress = 0;
             readOpInProgress = 0;
             writeQueue = new();
             reqQueue = new();
             invalQueue = new();
             reqId = 0;
             stallEn = 1;
             stallRandDistEn = 0;
             transactionId = 0;
             totalTransactions = 0;
             for(i=0; i<={BITSEQN{1'b1}}; i = i+1)
                  idArray[i] = 0;
           end
	endfunction:new
     
        task init(virtual L2_M_Ifc#(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) mL2Ifc);
           begin
              this.mL2Ifc = mL2Ifc;
             `DEBUG($psprintf("Task Init"))
           end
        endtask:init

        task reset ();
           begin
            if(isActive == 1) begin
             `DEBUG($psprintf("Task Reset"))
              mL2Ifc.cbMstDrv.reqRd <=0; 
              mL2Ifc.cbMstDrv.reqWr <=0; 
              mL2Ifc.cbMstDrv.reqInv <=0; 
              mL2Ifc.cbMstDrv.reqSeq <=0; 
              mL2Ifc.cbMstDrv.reqAddr <=0; 
              mL2Ifc.cbMstDrv.reqDin <=0;
              mL2Ifc.cbMstDrv.reqByteEn <=0; 
              mL2Ifc.cbMstDrv.rspStall <=0; 
              transactionId = 0;
           end
           end
        endtask:reset

        task clear ();
           begin
            if(isActive == 1) begin
             `DEBUG($psprintf("Task Clear"))
              mL2Ifc.cbMstDrv.reqRd <=0; 
              mL2Ifc.cbMstDrv.reqWr <=0; 
              mL2Ifc.cbMstDrv.reqInv <=0; 
              mL2Ifc.cbMstDrv.reqSeq <=0; 
              mL2Ifc.cbMstDrv.reqAddr <=0; 
              mL2Ifc.cbMstDrv.reqDin <=0;
              mL2Ifc.cbMstDrv.reqByteEn <=0; 
              mL2Ifc.cbMstDrv.rspStall <=0; 
              transactionId = 0;
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
              rspStallDrive();
              countTrID();
 
           join_none 
        endtask:drive

       task monitor();
             `DEBUG($psprintf("Task Monitor"))
           fork
              rdDataWrRspMonitor(); 
              reqBusMonitor(); 
              rspBusMonitor(); 
           join_none 
        endtask:monitor

        task countTrID();
           while(1) begin
                transactionId[63:0] = transactionId[63:0] + 1;
                if((transactionId[63:0] % 20000) <= 10000) begin
                 stallRandDistEn = 0;
                end else begin
                 stallRandDistEn = 1;
                end
                clock(1);
           end
        endtask:countTrID



       task reqDrive();
          reg [BITSEQN-1:0]ID = 0;
          while(1)begin
            reqQueue.get(ReqT);
            ID[BITSEQN-1:0]= 0;
            idSelTask(ID);
            reqId[BITSEQN-1:0] = ID[BITSEQN-1:0];
            `INFO($psprintf(" CPU_REQ_TO_CACHE   Req Addr %s  ", ReqT.reqSprint))
            mL2Ifc.cbMstDrv.reqRd <=ReqT.Read; 
            mL2Ifc.cbMstDrv.reqWr <=ReqT.Write; 
            mL2Ifc.cbMstDrv.reqInv <=ReqT.Inval; 
            mL2Ifc.cbMstDrv.reqSeq <=reqId; 
            mL2Ifc.cbMstDrv.reqAddr <=ReqT.Addr; 
            mL2Ifc.cbMstDrv.reqDin <=ReqT.Data;
            mL2Ifc.cbMstDrv.reqByteEn <=ReqT.ByteEn;
            clock(1);
            while(mL2Ifc.cbMstDrv.reqStall == 1 ) clock(1);
            mL2Ifc.cbMstDrv.reqRd <=0; 
            mL2Ifc.cbMstDrv.reqWr <=0; 
            mL2Ifc.cbMstDrv.reqInv <=0; 
            mL2Ifc.cbMstDrv.reqSeq <=0; 
            mL2Ifc.cbMstDrv.reqAddr <=0; 
            mL2Ifc.cbMstDrv.reqDin <=0;
            mL2Ifc.cbMstDrv.reqByteEn <=ReqT.ByteEn;
            ReqT.transactionId = transactionId[63:0];
            ReqT.ReqSeq = reqId;
            ReqT.transactionTime = $time;
            rwRspArray[reqId[BITSEQN-1:0]] = ReqT;
            reqId[BITSEQN-1:0] = 0;
            updateInOrderArray(ReqT);
            totalTransactions = totalTransactions + 1;
          end
    endtask:reqDrive


      task rspStallDrive();
          reg [7:0]stallEnCnt;
          reg [7:0]stallDisCnt;
          while(1)
             begin
               if(stallEn == 1) begin
                 if(stallRandDistEn == 0) begin
                      stallEnCnt[7:0] = 0;
                      stallDisCnt[7:0] = 0;
                 end else begin
                      stall_bit_creq = $urandom_range('b0,'b1);
                      stallEnCnt[7:0] = (stall_bit_creq == 0) ?0 : $urandom_range(1,20);
                      stallDisCnt[7:0] = (stall_bit_creq == 0) ?0 : $urandom_range(1,20);
                 end
               end else begin
                  stallEnCnt[7:0] = 0;
                  stallDisCnt[7:0] = 0;
               end
               clock(stallEnCnt[7:0]);
               mL2Ifc.cbMstDrv.rspStall <= 0; 
               clock(1);
               clock(stallDisCnt[7:0]);
               mL2Ifc.cbMstDrv.rspStall <= 1; 
             end
       endtask:rspStallDrive


       task rdDataWrRspMonitor();
          while(1) begin
               wait(((mL2Ifc.cbMstDrv.rspRd == 1) ||(mL2Ifc.cbMstDrv.rspWr == 1) ||(mL2Ifc.cbMstDrv.rspInv == 1)) && (mL2Ifc.cbMstDrv.rspStall == 0));
               if(isActive == 1) begin
                  `DEBUG($psprintf("Mst rdDataWrRspMonitor id %d size %0d time %t",mL2Ifc.cbMstDrv.rspSeq[BITSEQN-1:0],rwRspArray.size(),$time))
                  if(!(rwRspArray.exists(mL2Ifc.cbMstDrv.rspSeq[BITSEQN-1:0]))) begin
                     `ERROR($psprintf("Mst 1 rdDataWrRspMonitor id %d",mL2Ifc.cbMstDrv.rspSeq[BITSEQN-1:0]))
                  end
                  rwRspT = new();
                  rwRspT = rwRspArray[mL2Ifc.cbMstDrv.rspSeq[BITSEQN-1:0]];
                  if(mL2Ifc.cbMstDrv.rspRd == 1) begin
                     rwRspT.Data   = mL2Ifc.cbMstDrv.rspDout;
                  end
                  rwRspT.RspSeq    = mL2Ifc.cbMstDrv.rspSeq;
                  rwRspT.Attr  = mL2Ifc.cbMstDrv.rspAttr;
                  if(!(
                        (rwRspT.ReqSeq == rwRspT.RspSeq) && 
                        (rwRspT.Write  == mL2Ifc.cbMstDrv.rspWr)  && 
                        (rwRspT.Read   == mL2Ifc.cbMstDrv.rspRd)  && 
                        (rwRspT.Inval  == mL2Ifc.cbMstDrv.rspInv) 
                      )) begin
           
                     `DEBUG($psprintf("Request  and Responce  is Not Match for ID  %s",rwRspT.reqSprint))
                     `ERROR($psprintf("===========FAIL============"))
                  end
                  checkInOrderArray(rwRspT);
                  idArray[rwRspT.ReqSeq] = 0;
                  rwRspArray.delete(mL2Ifc.cbMstDrv.rspSeq[BITSEQN-1:0]);
                  if(rwRspT.Read == 1'b1)
                    readDataReceived();
                  else 
                    writeRspReceived();
               end
               clock(1);
             end
       endtask:rdDataWrRspMonitor

	
 
       task reqBusMonitor();
          while(1)
             begin
               wait( ((mL2Ifc.cbMstMon.reqRd == 1) ||(mL2Ifc.cbMstMon.reqWr == 1) ||(mL2Ifc.cbMstMon.reqInv == 1)) &&
                     (mL2Ifc.cbMstMon.reqStall == 0)  
                   );
                     reqMonT = new();
                     reqMonT.transactionId = transactionId[63:0];
                     reqMonT.transactionTime = $time;
                     reqMonT.Read     = mL2Ifc.cbMstMon.reqRd;
                     reqMonT.Write    = mL2Ifc.cbMstMon.reqWr;
                     reqMonT.Inval    = mL2Ifc.cbMstMon.reqInv;
                     reqMonT.Addr     = mL2Ifc.cbMstMon.reqAddr;
                     reqMonT.Data     = mL2Ifc.cbMstMon.reqDin;
                     reqMonT.ReqSeq   = mL2Ifc.cbMstMon.reqSeq;
                     reqMonT.RspSeq   = 0;
                     reqMonT.ByteEn   = mL2Ifc.cbMstMon.reqByteEn;
                     reqMonT.Attr     = 0;
                     reqMonT.valid    = 1;
                     reqBusMonReceived();
               clock(1);
             end
       endtask:reqBusMonitor

       task rspBusMonitor();
          while(1)
             begin
               wait( ((mL2Ifc.cbMstMon.rspRd == 1) ||(mL2Ifc.cbMstMon.rspWr == 1) ||(mL2Ifc.cbMstMon.rspInv == 1)) &&
                     (mL2Ifc.cbMstMon.rspStall == 0)  
                   );
                     rspMonT = new();
                     rspMonT.transactionId = transactionId[63:0];
                     rspMonT.transactionTime = $time;
                     rspMonT.Read     = mL2Ifc.cbMstMon.rspRd;
                     rspMonT.Write    = mL2Ifc.cbMstMon.rspWr;
                     rspMonT.Inval    = mL2Ifc.cbMstMon.rspInv;
                     rspMonT.Addr     = 0;
                     rspMonT.Data     = mL2Ifc.cbMstMon.rspDout;
                     rspMonT.ReqSeq   = 0;
                     rspMonT.RspSeq   = mL2Ifc.cbMstMon.rspSeq;
                     rspMonT.ByteEn   = 0;
                     rspMonT.Attr     =  mL2Ifc.cbMstMon.rspAttr;
                     rspMonT.valid    = 1;
                     rspBusMonReceived();
               clock(1);
             end
       endtask:rspBusMonitor

       


       



       task send (CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) t);
          begin
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

     task writeRspReceive (ref CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) t);
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

     task readDataReceive (ref CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) t);
        begin
           waitUntilReadDatareceived();
           t = rwRspT;
        end
     endtask:readDataReceive


      task reqBusMonReceived();
         begin
           -> reqBusMonitorReceived;
         end
      endtask: reqBusMonReceived

      task waitUntilReqBusMonitorReceived();
         begin
           @(reqBusMonitorReceived);
         end
      endtask:waitUntilReqBusMonitorReceived 

     task reqBusMonReceive (ref CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) t);
        begin
           waitUntilReqBusMonitorReceived();
           t = reqMonT;
        end
     endtask:reqBusMonReceive


      task rspBusMonReceived();
         begin
           -> rspBusMonitorReceived;
         end
      endtask: rspBusMonReceived

      task waitUntilRspBusMonitorReceived();
         begin
           @(rspBusMonitorReceived);
         end
      endtask:waitUntilRspBusMonitorReceived 

     task rspBusMonReceive (ref CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) t);
        begin
           waitUntilRspBusMonitorReceived();
           t = rspMonT;
        end
     endtask:rspBusMonReceive








    task clock (integer numClocks = 1);
       begin
         repeat(numClocks)@(mL2Ifc.cbMstDrv);
       end
    endtask:clock


task idSelTask(ref reg[BITSEQN-1 : 0] id);
reg [BITSEQN-1 : 0] idSel;
integer l;
reg idDone; 
reg emptyArry; 
reg [31:0]MinVal,MaxVal;
begin

MinVal[31:0] = 0;
MaxVal[31:0] = {BITSEQN{1'b1}};

emptyArry = 0;
while(emptyArry == 0) begin
     for(l=0; l<={BITSEQN{1'b1}}; l = l+1) begin
      if(idArray[l] == 0) begin
        emptyArry = 1;
        l = {BITSEQN{1'b1}} + 1;
      end
     end
     if(emptyArry == 0) begin
     `DEBUG($psprintf("idArray is FULL emptyArry %d",emptyArry))
      clock(1);
     end
end 


idDone = 0;
while(idDone == 0) begin
    idSel[BITSEQN-1 : 0] = $urandom_range(MinVal,MaxVal);
    if(idArray[idSel[BITSEQN-1 : 0]] == 0) begin
       idDone = 1;
       idArray[idSel[BITSEQN-1 : 0]] = 1;
    end else if (idArray[idSel[BITSEQN-1 : 0]] == 1) begin
       idSel[BITSEQN-1 : 0] = 0;
       
    end
end
  id[BITSEQN-1 : 0]= idSel[BITSEQN-1 : 0];
end
endtask:idSelTask

function isEmptyidArray;
integer k;
reg isEmptyArray; 
begin
      isEmptyArray = 1;
      for(k=0; k<={BITSEQN{1'b1}}; k = k+1) begin
        if(idArray[k] == 1) begin
           isEmptyArray = 0;
          `DEBUG($psprintf("isEmptyidArray is Not Empty %x",k))
           k = {BITSEQN{1'b1}} + 1;
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


task updateInOrderArray (CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR)reqTr);
reg [((BITSEQN+1)*16)-1:0]idClubData;
reg [(BITSEQN+1)-1:0]idData;
reg [BITADDR-1:0]cpuReqAddr;
reg [BITSEQN-1:0]cpuReqId;
bit InOrderArray;
integer k,l,m,n;
cpuReqAddr[BITADDR-1:0] = reqTr.Addr;
cpuReqId[BITSEQN-1:0] = reqTr.ReqSeq;
cpuReqAddr[4:0] = 'h0;
idClubData[((BITSEQN+1)*16)-1:0] = 'h0;
idData[(BITSEQN+1)-1:0] = 'h0;
InOrderArray = 0;
        `DEBUG($psprintf("updateInOrderArray Req ADDR 0x%0x  ", cpuReqAddr[BITADDR-1:0]))
        `DEBUG($psprintf("updateInOrderArray Req creq %s  ", reqTr.reqSprint))
        if(inOrderCheckArray.exists(cpuReqAddr[BITADDR-1:0]))  begin
            idClubData[((BITSEQN+1)*16)-1:0] = inOrderCheckArray[cpuReqAddr[BITADDR-1:0]];
              `DEBUG($psprintf("updateInOrderArray Total Pending Req idClubData 0x%0x  ", idClubData[((BITSEQN+1)*16)-1:0]))
            for(k=0; k<16; k = k+1) begin
                idData[(BITSEQN+1)-1:0] = idClubData[((BITSEQN+1)*16)-1:0] >> k*(BITSEQN+1);
                `DEBUG($psprintf("updateInOrderArray k=%d Pending Order idData 0x%0x  ", k,idData[(BITSEQN+1)-1:0]))
                if(idData[BITSEQN] == 1'b0)  begin
                   idData[(BITSEQN+1)-1:0] = {1'b1,cpuReqId[BITSEQN-1:0]};
                   idClubData[((BITSEQN+1)*16)-1:0] = idClubData[((BITSEQN+1)*16)-1:0] | idData[(BITSEQN+1)-1:0] << k*(BITSEQN+1);
                   inOrderCheckArray[cpuReqAddr[BITADDR-1:0]] = idClubData[((BITSEQN+1)*16)-1:0];
                  `DEBUG($psprintf("updateInOrderArray adding New Pending Req. idData 0x%x idClubData 0x%0x  ", idData[(BITSEQN+1)-1:0],idClubData[((BITSEQN+1)*16)-1:0]))
                   k = 16;
                   InOrderArray = 1;
                end
            end
            if(InOrderArray == 1'b0) begin
              `ERROR($psprintf("updateInOrderArray not set for creq %s  ", reqTr.reqSprint))
            end
        end else begin
           idClubData[((BITSEQN+1)*16)-1:0] = {1'b1,cpuReqId[BITSEQN-1:0]};
           inOrderCheckArray[cpuReqAddr[BITADDR-1:0]] = idClubData[((BITSEQN+1)*16)-1:0];
           `DEBUG($psprintf("updateInOrderArray1 idClubData 0x%0x  ", idClubData[((BITSEQN+1)*16)-1:0]))
        end
endtask:updateInOrderArray


task checkInOrderArray (CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR)reqTr);
reg [((BITSEQN+1)*16)-1:0]idClubData;
reg [(BITSEQN+1)-1:0]idData;
reg [BITADDR-1:0]cpuReqAddr;
reg [BITSEQN-1:0]cpuReqId;
bit InOrderArray;
integer k,l,m,n;
cpuReqAddr[BITADDR-1:0] = reqTr.Addr;
cpuReqId[BITSEQN-1:0] = reqTr.ReqSeq;
cpuReqAddr[4:0] = 'h0;
idClubData[((BITSEQN+1)*16)-1:0] = 'h0;
idData[(BITSEQN+1)-1:0] = 'h0;
InOrderArray = 0;
        `DEBUG($psprintf("checkInOrderArray Req ADDR 0x%0x  ", cpuReqAddr[BITADDR-1:0]))
        `DEBUG($psprintf("checkInOrderArray Req creq %s  ", reqTr.reqSprint))
        if(inOrderCheckArray.exists(cpuReqAddr[BITADDR-1:0]))  begin
            idClubData[((BITSEQN+1)*16)-1:0] = inOrderCheckArray[cpuReqAddr[BITADDR-1:0]];
              `DEBUG($psprintf("checkInOrderArray Total Pending Req idClubData 0x%0x  ", idClubData[((BITSEQN+1)*16)-1:0]))
               idData[(BITSEQN+1)-1:0] = idClubData[((BITSEQN+1)*16)-1:0];
              `DEBUG($psprintf("checkInOrderArray Top Of the Pending idData 0x%0x --> 0x%0x ", idData[(BITSEQN+1)-1:0],idData[(BITSEQN)-1:0]))
               if(idData[BITSEQN] == 1'b1)  begin
                   if(idData[BITSEQN-1:0] != cpuReqId[BITSEQN-1:0]) begin
                    `TB_YAP($psprintf("checkInOrderArray  FAIL idData 0x%0x  cpuReqId[BITSEQN-1:0] ",idData[(BITSEQN+1)-1:0],cpuReqId[BITSEQN-1:0]))
                    `ERROR($psprintf("checkInOrderArray FAIL for rsv Req  %s  ", reqTr.reqSprint))
                   end else begin
                     idClubData[((BITSEQN+1)*16)-1:0] = idClubData[((BITSEQN+1)*16)-1:0] >> (BITSEQN+1);
                     if(idClubData[((BITSEQN+1)*16)-1:0] == 'h0) begin
                        inOrderCheckArray.delete(cpuReqAddr[BITADDR-1:0]);
                     end else begin
                         inOrderCheckArray[cpuReqAddr[BITADDR-1:0]] = idClubData[((BITSEQN+1)*16)-1:0];
                     end
                     `DEBUG($psprintf("checkInOrderArray Update Array After remove Mach Rsp idClubData 0x%0x  ", idClubData[((BITSEQN+1)*16)-1:0]))
                   end
               end else begin
                  `ERROR($psprintf("checkInOrderArray Valid Not set Top od ID Req 0x%0x  ",idData[(BITSEQN+1)-1:0] ))
               end
        end else begin
           `ERROR($psprintf("checkInOrderArray inOrderCheckArray is Empty but Req Rsv %s  ", reqTr.reqSprint))
        end
endtask:checkInOrderArray

endclass:CacheMasterTransactor
`endif






