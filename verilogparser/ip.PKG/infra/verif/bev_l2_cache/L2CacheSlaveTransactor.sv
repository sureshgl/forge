`ifndef L2_CACHE_SLAVE_TRANSACTOR
`define L2_CACHE_SLAVE_TRANSACTOR
class L2CacheSlaveTransactor #(int NXADDRWIDTH=31, int NXDATAWIDTH=256, int NXIDWIDTH=4, int NXTYPEWIDTH=3, int NXSIZEWIDTH=8, int NXATTRWIDTH=3) extends MeTransactor;
   virtual Naxi_Ifc  #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH)  sAxiIfc;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rwRspT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rdAddMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) wrMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) creqMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) dreqMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rreqMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rwRspArray[*];
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) slvAddrArray[*];
   string name;
   mailbox rwRespQueue;
   bit stall_bit_creq;
   bit stall_bit_dreq;
   event rdAddTransactionReceived;
   event writeTransactionReceived;
   event creqBusMonitorReceived;
   event dreqBusMonitorReceived;
   event rreqBusMonitorReceived;
   reg stallEn;
   bit isActive;
   function new (string name,bit isActive = 1);
      begin
        super.new(name);
        this.name = name;
        this.isActive = isActive;
        rwRespQueue = new();
        stallEn = 1;
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
       join_none  
     end
    endtask:drive

   task monitor();
       fork
          rdAddMonitor(); 
          wrMonitor(); 
       join_none 
    endtask:monitor


         
   task rwRspDrive();
      while(1) begin
         rwRespQueue.get(rwRspT);
          `DEBUG($psprintf("rwRspDrive   "))
         sAxiIfc.cbSlvDrv.rreqData <=rwRspT.data[0]; 
         sAxiIfc.cbSlvDrv.rreqAttr <=0; 
         sAxiIfc.cbSlvDrv.rreqValid <=1; 
         sAxiIfc.cbSlvDrv.rreqId   <=rwRspT.rId; 
         clock(1);
         while(sAxiIfc.cbSlvDrv.rreqStall == 1 )
            clock(1);
         sAxiIfc.cbSlvDrv.rreqData <=rwRspT.data[1]; 
         sAxiIfc.cbSlvDrv.rreqAttr <=rwRspT.rattr; 
         clock(1);
         while(sAxiIfc.cbSlvDrv.rreqStall == 1 )
            clock(1);
         rwRspArray.delete(rwRspT.rId[NXIDWIDTH-1:0]);
         slvAddrArray.delete(rwRspT.addr);
         sAxiIfc.cbSlvDrv.rreqData <=0; 
         sAxiIfc.cbSlvDrv.rreqAttr <=0; 
         sAxiIfc.cbSlvDrv.rreqId   <=0; 
         sAxiIfc.cbSlvDrv.rreqValid <=0; 
      end
   endtask:rwRspDrive

   task cReqstallDrive();
      while(1)begin
           sAxiIfc.cbSlvDrv.creqRdStall <= 0; 
           sAxiIfc.cbSlvDrv.creqWrStall <= 0; 
           sAxiIfc.cbSlvDrv.dreqStall <= 0; 
           clock(1);
      end
   endtask:cReqstallDrive





   task wrMonitor();
      L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rdPendTr;
      while(1)begin
         wait( (sAxiIfc.cbSlvDrv.creqValid == 1'b1) && (sAxiIfc.cbSlvDrv.dreqValid == 1'b1) &&
                (sAxiIfc.cbSlvDrv.creqRdStall == 1'b0) && (sAxiIfc.cbSlvDrv.creqWrStall == 1'b0) &&  (sAxiIfc.cbSlvDrv.dreqStall == 1'b0)
             );
         if(isActive == 1) begin
             `DEBUG($psprintf("wrMonitor   "))
            if(sAxiIfc.cbSlvDrv.creqType != CH_READ) begin
                if(rwRspArray.exists(sAxiIfc.cbSlvDrv.creqId[NXIDWIDTH-1:0])) begin
                    `DEBUG($psprintf("rwRspArray with Rsv ID exists %x time %t ",sAxiIfc.cbSlvDrv.creqId[NXIDWIDTH-1:0],$time))
                     $finish;
                end
                wrMonT = new();
                wrMonT.addr  = sAxiIfc.cbSlvDrv.creqAddr;
                wrMonT.cattr = sAxiIfc.cbSlvDrv.creqAttr;
                wrMonT.size  = sAxiIfc.cbSlvDrv.creqSize;
                wrMonT.cId   = sAxiIfc.cbSlvDrv.creqId;
                wrMonT.reqType  = sAxiIfc.cbSlvDrv.creqType;

                wrMonT.data[0]  = sAxiIfc.cbSlvDrv.dreqData;
                wrMonT.dattr = sAxiIfc.cbSlvDrv.dreqAttr;
                wrMonT.dId   = sAxiIfc.cbSlvDrv.dreqId;
                if(wrMonT.cattr[0] == 1) begin
                  rwRspArray[sAxiIfc.cbSlvDrv.creqId[NXIDWIDTH-1:0]] = wrMonT;
                end
                if(slvAddrArray.exists(wrMonT.addr)) begin
                  rdPendTr = slvAddrArray[wrMonT.addr];
                 `DEBUG($psprintf("rdAddMonitor L2 have 2 same Pending Request's, Addr %s  ",rdAddMonT.creqSprint))
                 `DEBUG($psprintf("rdAddMonitor L2 Rsv      Creq ID  %x  ",rdAddMonT.cId))
                 `ERROR($psprintf("rdAddMonitor L2 Pending  Creq ID  %x  ",rdPendTr.cId))
              end
              wrReceived();
            end
         end
          clock(1);
        end
  endtask:wrMonitor

   task rdAddMonitor();
     integer i;
     L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rdPendTr;
     while(1)begin
        wait( (sAxiIfc.cbSlvDrv.creqValid == 1'b1) && (sAxiIfc.cbSlvDrv.creqRdStall == 1'b0) && (sAxiIfc.cbSlvDrv.creqWrStall == 1'b0));
           if(isActive == 1) begin
              if(sAxiIfc.cbSlvDrv.creqType == CH_READ) begin
                 if(rwRspArray.exists(sAxiIfc.cbSlvDrv.creqId[NXIDWIDTH-1:0])) begin
                     `DEBUG($psprintf("rdAddMonitor  Non Rspond ID still in L2. creqId %x  ",sAxiIfc.cbSlvDrv.creqId[NXIDWIDTH-1:0]))
                      $finish;
                 end
                 `DEBUG($psprintf("rdAddMonitor   "))
                 rdAddMonT = new();
                 rdAddMonT.addr   = sAxiIfc.cbSlvDrv.creqAddr;
                 rdAddMonT.cattr  = sAxiIfc.cbSlvDrv.creqAttr;
                 rdAddMonT.size   = sAxiIfc.cbSlvDrv.creqSize;
                 rdAddMonT.cId    = sAxiIfc.cbSlvDrv.creqId;
                 rdAddMonT.reqType   = sAxiIfc.cbSlvDrv.creqType;
                 rwRspArray[sAxiIfc.cbSlvDrv.creqId[NXIDWIDTH-1:0]] = rdAddMonT;
                 if(slvAddrArray.exists(rdAddMonT.addr)) begin
                     rdPendTr = slvAddrArray[rdAddMonT.addr];
                    `DEBUG($psprintf("rdAddMonitor L2 have 2 same Pending Request's, Addr %s  ",rdAddMonT.creqSprint))
                    `DEBUG($psprintf("rdAddMonitor L2 Rsv      Creq ID  %x  ",rdAddMonT.cId))
                    `ERROR($psprintf("rdAddMonitor L2 Pending  Creq ID  %x  ",rdPendTr.cId))
                 end
                 if(rdAddMonT.cattr[1] == 1'b1) begin
                    slvAddrArray[rdAddMonT.addr] = rdAddMonT;
                 end
                 rdAddReceived();
                end
           end
          clock(1);
        end
  endtask:rdAddMonitor





       



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






