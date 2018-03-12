`ifndef ME_CACHE_SLAVE_TRANSACTOR
`define ME_CACHE_SLAVE_TRANSACTOR
class MeCacheSlaveTransactor #(int NXADDRWIDTH=31, int NXDATAWIDTH=256, int NXIDWIDTH=4, int NXTYPEWIDTH=3, int NXSIZEWIDTH=8, int NXATTRWIDTH=3) extends MeTransactor;

	virtual Naxi_Ifc  #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH)  sAxiIfc;
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rwRspT;
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rdAddMonT;
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) wrMonT;
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) creqMonT;
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) dreqMonT;
	MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rreqMonT;
        MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rwRspArray[*];
        MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) slvAddrArray[*];
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
        bit stallRandDistEn;
        bit backToBackRspRandDistEn;
        reg [63:0] transactionId;
	function new (string name,bit isActive = 1);
	   begin
             super.new(name);
             this.name = name;
             this.isActive = isActive;
             rwRespQueue = new();
             stallEn = 1;
             stallRandDistEn = 0;
             backToBackRspRandDistEn = 0;
             transactionId[63:0] =1;
           end
	endfunction:new
     
        task init(virtual Naxi_Ifc#(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) sAxiIfc);
           begin
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
              dReqstallDrive();
              //killSim();
              countTrID();
           join_none  
         end
        endtask:drive

       task monitor();
           fork
              rdAddMonitor(); 
              wrMonitor(); 
              creqBusMonitor(); 
              dreqBusMonitor(); 
              rreqBusMonitor(); 
           join_none 
        endtask:monitor


       task killSim();
          begin
           `DEBUG($psprintf("killSim Start   "))
           clock(400);
           `DEBUG($psprintf("killSim End   "))
            $finish;

         end
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
                 backToBackRspRandDistEn = 0;
                end else begin
                 backToBackRspRandDistEn = 1;
                end
                clock(1);
           end
        endtask:countTrID

       task rwRspDrive();
          while(1)
             begin
               rwRespQueue.get(rwRspT);
                `DEBUG($psprintf("rwRspDrive   "))
               sAxiIfc.cbSlvDrv.rreqData <=rwRspT.data; 
               sAxiIfc.cbSlvDrv.rreqAttr <=rwRspT.rattr; 
               sAxiIfc.cbSlvDrv.rreqId   <=rwRspT.rId; 
               sAxiIfc.cbSlvDrv.rreqValid <=1; 
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

       task dReqstallDrive();
          while(1)
             begin
               stall_bit_dreq = stallEn ? $urandom_range('b0,'b1) : 0;
               //sAxiIfc.cbSlvDrv.dreqStall <= stall_bit_dreq; 
               clock(1);
             end
       endtask:dReqstallDrive




        task wrMonitor();
	     MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rdPendTr;
          while(1)
             begin
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

                          wrMonT.data  = sAxiIfc.cbSlvDrv.dreqData;
                          wrMonT.dattr = sAxiIfc.cbSlvDrv.dreqAttr;
                          wrMonT.dId   = sAxiIfc.cbSlvDrv.dreqId;
                          wrMonT.transactionId = transactionId[63:0];
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
	     MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) rdPendTr;
          while(1)
             begin
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
                        rdAddMonT.transactionId = transactionId[63:0];
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

       task creqBusMonitor();
          while(1)
             begin
               wait( (sAxiIfc.cbSlvMon.creqValid == 1) &&
                     (sAxiIfc.cbSlvMon.creqRdStall == 0) && (sAxiIfc.cbSlvMon.creqWrStall == 0) 
                   );
                `DEBUG($psprintf("creqBusMonitor   "))
                     creqMonT = new();
                     creqMonT.addr  = sAxiIfc.cbSlvMon.creqAddr;
                     creqMonT.cattr = sAxiIfc.cbSlvMon.creqAttr;
                     creqMonT.size  = sAxiIfc.cbSlvMon.creqSize;
                     creqMonT.cId   = sAxiIfc.cbSlvMon.creqId;
                     creqMonT.reqType =  sAxiIfc.cbSlvMon.creqType;
                     creqBusMonReceived();
               clock(1);
             end
       endtask:creqBusMonitor

       task dreqBusMonitor();
          while(1)
             begin
               wait ((sAxiIfc.cbSlvMon.dreqValid == 1) && (sAxiIfc.cbSlvMon.dreqStall == 0)); 
                     `DEBUG($psprintf("dreqBusMonitor   "))
                     dreqMonT = new();
                     dreqMonT.data  = sAxiIfc.cbSlvMon.dreqData;
                     dreqMonT.dattr = sAxiIfc.cbSlvMon.dreqAttr;
                     dreqMonT.dId   = sAxiIfc.cbSlvMon.dreqId;
                     dreqBusMonReceived();
               clock(1);
             end
       endtask:dreqBusMonitor

       task rreqBusMonitor();
          while(1)
             begin
               wait ((sAxiIfc.cbSlvMon.rreqValid == 1) && (sAxiIfc.cbSlvMon.rreqStall == 0)); 
                `DEBUG($psprintf("rreqBusMonitor   "))
                     rreqMonT = new();
                     rreqMonT.data  = sAxiIfc.cbSlvMon.rreqData;
                     rreqMonT.rattr = sAxiIfc.cbSlvMon.rreqAttr;
                     rreqMonT.rId   = sAxiIfc.cbSlvMon.rreqId;
                     rreqBusMonReceived();
               clock(1);
             end
       endtask:rreqBusMonitor



       



       task send (MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) t);
          begin
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

     task rdAddReceive (ref MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) t);
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

     task wrReceive (ref MeCacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) t);
        begin
           waitUntilWrreceived();
           t = wrMonT;
        end
     endtask:wrReceive


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
         repeat(numClocks)@(sAxiIfc.cbSlvDrv);
       end
    endtask:clock



endclass:MeCacheSlaveTransactor
`endif






