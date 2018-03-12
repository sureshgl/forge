`ifndef L2_CACHE_SLAVE_TRANSACTOR
`define L2_CACHE_SLAVE_TRANSACTOR
class L2CacheSlaveTransactor #(int NXADDRWIDTH=31, int NXDATAWIDTH=256, int NXIDWIDTH=4, int NXTYPEWIDTH=3, int NXSIZEWIDTH=8, int NXATTRWIDTH=3) extends MeTransactor;
   virtual Naxi_Ifc  #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH)  sAxiIfc;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rwRspT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) addMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rdAddMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) wrAddMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) wrDataMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) wrMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) creqMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) dreqMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rreqMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rwRspArray[*];
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) slvAddrArray[*];
   string name;
   mailbox rwRespQueue;
   mailbox wrAddrQueue;
   bit stall_bit_creq;
   bit stall_bit_dreq;
   event rdAddTransactionReceived;
   event writeTransactionReceived;
   event creqBusMonitorReceived;
   event dreqBusMonitorReceived;
   event rreqBusMonitorReceived;
   reg stallEn;
   reg gapBetweenBeetsEn;
   reg alwaysEnStall;
   reg alwaysEnGapBetweenBeets;
   bit isActive;
   reg [63:0] transactionId;
   bit gapBetweenBeetsRandDistEn;
   bit stallRandDistEn;
   function new (string name,bit isActive = 1);
      begin
        super.new(name);
        this.name = name;
        this.isActive = isActive;
        rwRespQueue = new();
        wrAddrQueue = new();
        stallEn = 1;
        gapBetweenBeetsEn = 1;
        transactionId = 0;
        gapBetweenBeetsRandDistEn = 0;
        stallRandDistEn = 0;
        alwaysEnStall = 1;
        alwaysEnGapBetweenBeets = 1;
      end
   endfunction:new
        
   task init(virtual Naxi_Ifc#(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) sAxiIfc);begin
          this.sAxiIfc = sAxiIfc;
       end
    endtask:init

   task reset ();
      begin
       if(isActive == 1) begin
         sAxiIfc.cbSlvDrv.creqRdStall <=0; 
         sAxiIfc.cbSlvDrv.creqWrStall <=0;
         sAxiIfc.cbSlvDrv.dreqStall <=0;

         sAxiIfc.cbSlvDrv.rreqData <=0; 
         sAxiIfc.cbSlvDrv.rreqAttr <=0; 
         sAxiIfc.cbSlvDrv.rreqId <=0; 
         sAxiIfc.cbSlvDrv.rreqValid <=0; 
       end
      end
   endtask:reset

   task clear ();
      begin
       if(isActive == 1) begin
         sAxiIfc.cbSlvDrv.creqRdStall <=0; 
         sAxiIfc.cbSlvDrv.creqWrStall <=0;
         sAxiIfc.cbSlvDrv.dreqStall <=0;

         sAxiIfc.cbSlvDrv.rreqData <=0; 
         sAxiIfc.cbSlvDrv.rreqAttr <=0; 
         sAxiIfc.cbSlvDrv.rreqId <=0; 
         sAxiIfc.cbSlvDrv.rreqValid <=0;
       end 
      end
   endtask:clear

   task run ();
      fork
         drive(); 
         monitor(); 
      join_none 
   endtask:run

   task drive();
     if(isActive == 1) begin
       fork
          rwRspDrive(); 
          cReqstallDrive(); 
          countTrID();
       join_none  
     end
    endtask:drive

   task monitor();
       fork
          wrDataMonitor(); 
          addMonitor(); 
       join_none 
    endtask:monitor

   task rBusClear();
      sAxiIfc.cbSlvDrv.rreqData <=0; 
      sAxiIfc.cbSlvDrv.rreqAttr <=0; 
      sAxiIfc.cbSlvDrv.rreqId   <=0; 
      sAxiIfc.cbSlvDrv.rreqValid <=0; 
   endtask

   task countTrID();
        while(1) begin
          transactionId[63:0] = transactionId[63:0] + 1;
          if((transactionId[63:0] % 20000) <= 10000) begin
           stallRandDistEn = 0;
          end else begin
           stallRandDistEn = 1;
          end
          if((transactionId[63:0] % 10000) <= 5000) begin
           gapBetweenBeetsRandDistEn = 0;
          end else begin
           gapBetweenBeetsRandDistEn = 1;
          end
          clock(1);
        end
   endtask:countTrID
         
   task rwRspDrive();
      integer i,k;
      while(1) begin
         rwRespQueue.get(rwRspT);
         `TB_YAP($psprintf("rwRspDrive   "))
          for(i=0; i<rwRspT.noBeets; i = i+1) begin
                sAxiIfc.cbSlvDrv.rreqData <=rwRspT.data[i]; 
                sAxiIfc.cbSlvDrv.rreqId   <=rwRspT.rId; 
                sAxiIfc.cbSlvDrv.rreqValid <=1; 
                if(i == rwRspT.noBeets-1) begin
                   sAxiIfc.cbSlvDrv.rreqAttr <=rwRspT.rattr; 
                end else begin
                   sAxiIfc.cbSlvDrv.rreqAttr <=0; 
                end
                clock(1);
                while(sAxiIfc.cbSlvDrv.rreqStall == 1 )clock(1);
                if ((gapBetweenBeetsEn == 1) && (i != (rwRspT.noBeets-1)) && ((gapBetweenBeetsRandDistEn == 1) || (alwaysEnGapBetweenBeets == 1))) begin 
               `DEBUG($psprintf("rwRspDrive i=%0d  NB=%0d  Creq %s  ",i,rwRspT.noBeets,rwRspT.creqSprint))
                      sAxiIfc.cbSlvDrv.rreqValid <=0;
                      k =$urandom_range(0,7);
                      clock(k);
               end // end code for bubbles
           end
           rBusClear();
           rwRspArray.delete(rwRspT.rId[NXIDWIDTH-1:0]);
           slvAddrArray.delete(rwRspT.addr);
      end
   endtask:rwRspDrive


   task cReqstallDrive();
          reg [7:0]stallEnCnt;
          reg [7:0]stallDisCnt;
          bit stall_bit_creq;
          while(1)
             begin
               if((stallEn == 1) && ((stallRandDistEn == 1'b1) || (alwaysEnStall == 1'b1) ))begin
                  stallEnCnt[7:0] = 0;
                  stallDisCnt[7:0] = 0;
                  stall_bit_creq = $urandom_range('b0,'b1);
                  stallEnCnt[7:0]  = (alwaysEnStall == 1'b1) ? $urandom_range(1,20)  : (stall_bit_creq == 0) ? 0 : $urandom_range(1,20);
                  stallDisCnt[7:0] = (alwaysEnStall == 1'b1) ? $urandom_range(1,20)  : (stall_bit_creq == 0) ? 0 : $urandom_range(1,20);
               end else begin
                  stallEnCnt[7:0] = 0;
                  stallDisCnt[7:0] = 0;
               end
               clock(stallEnCnt[7:0]);
               sAxiIfc.cbSlvDrv.creqRdStall <= 0; 
               sAxiIfc.cbSlvDrv.creqWrStall <= 0; 
               sAxiIfc.cbSlvDrv.dreqStall <= 0; 
               clock(1);
               clock(stallDisCnt[7:0]);
               sAxiIfc.cbSlvDrv.creqRdStall <= 1; 
               sAxiIfc.cbSlvDrv.creqWrStall <= 1; 
               sAxiIfc.cbSlvDrv.dreqStall <= 1; 
             end
    endtask:cReqstallDrive


   task wrDataMonitor();
      L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) wrAT;
      integer i;
      while(1)begin
         //while(sAxiIfc.cbSlvDrv.dreqValid == 1'b0)clock(1);
         while(  (sAxiIfc.cbSlvDrv.dreqValid == 1'b0) || (sAxiIfc.cbSlvDrv.dreqStall == 1'b1)) clock(1);
         if(isActive == 1) begin
             `DEBUG($psprintf("wrDataMonitor   "))
             `DEBUG($psprintf(" SURESH wrDataMonitor Recived START "))
              if(sAxiIfc.cbSlvDrv.creqType != CH_READ) begin
                wrMonT = new();
                for(i=0; i<8; i = i+1) begin
                    wrMonT.data[i]  = sAxiIfc.cbSlvDrv.dreqData;
                    wrMonT.dattr = sAxiIfc.cbSlvDrv.dreqAttr;
                    wrMonT.dId   = sAxiIfc.cbSlvDrv.dreqId;
                    if(wrMonT.dattr[0] == 1'b1) begin
                      i = 8;
                    end else begin
                      clock(1);
                    end
                    `DEBUG($psprintf(" SURESH wrDataMonitor Recived Before A"))
                    while(  (sAxiIfc.cbSlvDrv.dreqValid == 1'b0) || (sAxiIfc.cbSlvDrv.dreqStall == 1'b1)) clock(1);
                   `DEBUG($psprintf(" SURESH wrDataMonitor Recived Before B"))
                end
                   `DEBUG($psprintf(" SURESH wrDataMonitor Recived Before 1"))
                wrAddrQueue.get(wrAT);
             `DEBUG($psprintf(" SURESH wrDataMonitor Recived %0x ",wrAT.addr))
                if(wrAT.cId != wrMonT.dId) begin
                  `TB_YAP($psprintf("wrDataMonitor CID 0x%0x and DID 0x%0x not same   for Addr 0x%0x  ",wrAT.cId,wrMonT.dId,wrAT.addr))
                   $finish;
                end
                wrMonT.addr   = wrAT.addr;
                wrMonT.cattr  = wrAT.cattr;
                wrMonT.size   = wrAT.size;
                wrMonT.cId    = wrAT.cId;
                wrMonT.reqType   = wrAT.reqType;
                wrReceived();
            end
         end
          clock(1);
        end
  endtask:wrDataMonitor

   task addMonitor();
     integer i;
     L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rdPendTr;
     while(1)begin
        wait( (sAxiIfc.cbSlvDrv.creqValid == 1'b1) && (sAxiIfc.cbSlvDrv.creqRdStall == 1'b0) && (sAxiIfc.cbSlvDrv.creqWrStall == 1'b0));
        if(isActive == 1) begin
           if(rwRspArray.exists(sAxiIfc.cbSlvDrv.creqId[NXIDWIDTH-1:0])) begin
               `DEBUG($psprintf("rdAddMonitor  Non Rspond ID still in L2. creqId %x  ",sAxiIfc.cbSlvDrv.creqId[NXIDWIDTH-1:0]))
                $finish;
           end
           `DEBUG($psprintf("rdAddMonitor   "))
           addMonT = new();
           addMonT.addr   = sAxiIfc.cbSlvDrv.creqAddr;
           addMonT.cattr  = sAxiIfc.cbSlvDrv.creqAttr;
           addMonT.size   = sAxiIfc.cbSlvDrv.creqSize;
           addMonT.cId    = sAxiIfc.cbSlvDrv.creqId;
           addMonT.reqType   = sAxiIfc.cbSlvDrv.creqType;
           if(addMonT.cattr[0] == 1'b1) begin
             rwRspArray[sAxiIfc.cbSlvDrv.creqId[NXIDWIDTH-1:0]] = addMonT;
           end
           if(slvAddrArray.exists(addMonT.addr)) begin
               rdPendTr = slvAddrArray[addMonT.addr];
              `DEBUG($psprintf("rdAddMonitor L2 have 2 same Pending Request's, Addr %s  ",addMonT.creqSprint))
              `DEBUG($psprintf("rdAddMonitor L2 Rsv      Creq ID  %x  ",addMonT.cId))
              `ERROR($psprintf("rdAddMonitor L2 Pending  Creq ID  %x  ",rdPendTr.cId))
           end
           if(addMonT.cattr[0] == 1'b1) begin
              slvAddrArray[addMonT.addr] = addMonT;
           end
           if(addMonT.reqType == CH_READ) begin
              rdAddMonT = new addMonT;
              rdAddReceived();
           end else begin
              wrAddMonT = new  addMonT;
              `DEBUG($psprintf("SURESH WR RSV Addr %s  ",wrAddMonT.creqSprint))
              wrAddrQueue.put(wrAddMonT);
           end
        end
        clock(1);
      end
  endtask:addMonitor





       



   task send (L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) t);begin
           rwRespQueue.put(t);
      end
   endtask : send


      task rdAddReceived();
         begin
           -> rdAddTransactionReceived;
         end
      endtask:rdAddReceived

      task waitUntilRdAddReceived();
         begin
           @(rdAddTransactionReceived);
         end
      endtask:waitUntilRdAddReceived 

     task rdAddReceive (ref L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) t);
        begin
           waitUntilRdAddReceived();
           t = rdAddMonT;
        end
     endtask:rdAddReceive


      task wrReceived();
         begin
           -> writeTransactionReceived;
         end
      endtask: wrReceived

      task waitUntilWrreceived();
         begin
           @(writeTransactionReceived);
         end
      endtask:waitUntilWrreceived 

     task wrReceive (ref L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) t);
        begin
           waitUntilWrreceived();
           t = wrMonT;
        end
     endtask:wrReceive


   task clock (integer numClocks = 1);begin
      repeat(numClocks)@(sAxiIfc.cbSlvDrv);
      end
   endtask:clock

endclass:L2CacheSlaveTransactor
`endif






