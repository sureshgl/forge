`ifndef CACHE_SLAVE_TRANSACTOR
`define CACHE_SLAVE_TRANSACTOR
class CacheSlaveTransactor #(int BITADDR=34, int BITDATA=512, int BITSEQN=16, int NUMBYLN=64,int XBITATR=3) extends MeTransactor;

	virtual L2_S_Ifc  #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR)  sL2Ifc;
	CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) rwRspT;
	CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) rdAddMonT;
	CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) wrMonT;
	CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) reqMonT;
	CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) rspMonT;
        CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) rwRspArray[*];
        CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) slvAddrArray[*];
        string name;
        mailbox rwRespQueue;
        bit stall_bit_req;
        event rdAddTransactionReceived;
        event writeTransactionReceived;
        event reqBusMonitorReceived;
        event rspBusMonitorReceived;
        reg stallEn;
        bit isActive;
        bit stallRandDistEn;
        bit stall_bit_creq;
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
     
        task init(virtual L2_S_Ifc#(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) sL2Ifc);
           begin
              this.sL2Ifc = sL2Ifc;
           end
        endtask:init

        task reset ();
           begin
            if(isActive == 1) begin
              sL2Ifc.cbSlvDrv.reqStall <=0; 
              sL2Ifc.cbSlvDrv.rspVld <=0; 
              sL2Ifc.cbSlvDrv.rspSeq <=0; 
              sL2Ifc.cbSlvDrv.rspDout <=0; 
              sL2Ifc.cbSlvDrv.rspAttr <=0; 
            end
           end
        endtask:reset

        task clear ();
           begin
            if(isActive == 1) begin
              sL2Ifc.cbSlvDrv.reqStall <=0; 
              sL2Ifc.cbSlvDrv.rspVld <=0; 
              sL2Ifc.cbSlvDrv.rspSeq <=0; 
              sL2Ifc.cbSlvDrv.rspDout <=0; 
              sL2Ifc.cbSlvDrv.rspAttr <=0; 
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
              ReqstallDrive(); 
              countTrID();
           join_none  
         end
        endtask:drive

       task monitor();
           fork
              rdAddMonitor(); 
              wrMonitor(); 
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
                if((transactionId[63:0] % 10000) <= 5000) begin
                 backToBackRspRandDistEn = 0;
                end else begin
                 backToBackRspRandDistEn = 1;
                end
                clock(1);
           end
        endtask:countTrID

       task rwRspDrive();
          reg[7:0]Cnt;
          while(1)
             begin
               rwRespQueue.get(rwRspT);
                `DEBUG($psprintf("rwRspDrive with Rsv ID %0x Write %0d Read %0d ime %t ",rwRspT.RspSeq,rwRspT.Write,rwRspT.Read ,$time))
               sL2Ifc.cbSlvDrv.rspVld  <=1; 
               sL2Ifc.cbSlvDrv.rspSeq  <=rwRspT.RspSeq; 
               sL2Ifc.cbSlvDrv.rspDout <=(rwRspT.Write == 1'b1) ? 'h0: rwRspT.Data; 
               sL2Ifc.cbSlvDrv.rspAttr <=rwRspT.Attr; 
               clock(1);
               while(sL2Ifc.cbSlvDrv.rspStall == 1 )
                  clock(1);
               rwRspArray.delete(rwRspT.RspSeq[BITSEQN-1:0]);
               slvAddrArray.delete(rwRspT.Addr);
               sL2Ifc.cbSlvDrv.rspVld  <=0; 
               sL2Ifc.cbSlvDrv.rspSeq  <=0; 
               sL2Ifc.cbSlvDrv.rspDout <=0; 
               sL2Ifc.cbSlvDrv.rspAttr <=0;
               if(backToBackRspRandDistEn == 1'b0) begin
                  Cnt[7:0] = $urandom_range(1,20);
                  clock(Cnt[7:0]);
               end
             end
       endtask:rwRspDrive

       task ReqstallDrive();
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
               sL2Ifc.cbSlvDrv.reqStall <= 0; 
               clock(1);
               clock(stallDisCnt[7:0]);
               sL2Ifc.cbSlvDrv.reqStall <= 1; 
             end
       endtask:ReqstallDrive

       




        task wrMonitor();
	     CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) rdPendTr;
          while(1)begin
               wait( (sL2Ifc.cbSlvDrv.reqWr == 1'b1) && (sL2Ifc.cbSlvDrv.reqRd == 1'b0) && (sL2Ifc.cbSlvDrv.reqStall == 1'b0) );
                   if(isActive == 1) begin
                          `DEBUG($psprintf("wrMonitor   "))
                          if(rwRspArray.exists(sL2Ifc.cbSlvDrv.reqSeq[BITSEQN-1:0])) begin
                              `DEBUG($psprintf("rwRspArray with Rsv ID exists %x time %t ",sL2Ifc.cbSlvDrv.reqSeq[BITSEQN-1:0],$time))
                               $finish;
                          end
                          wrMonT = new();
                          wrMonT.Addr     = sL2Ifc.cbSlvDrv.reqAddr;
                          wrMonT.Data     = sL2Ifc.cbSlvDrv.reqDin;
                          wrMonT.ReqSeq   = sL2Ifc.cbSlvDrv.reqSeq;
                          wrMonT.RspSeq   = 0;
                          wrMonT.ByteEn   = 0;
                          wrMonT.Attr     = 0;
                          wrMonT.Write    = sL2Ifc.cbSlvDrv.reqWr;
                          wrMonT.Read     = sL2Ifc.cbSlvDrv.reqRd;
                          wrMonT.Inval    = 0;
                          wrMonT.valid    = 1;
                          wrMonT.transactionTime = $time;
                          wrMonT.transactionId = transactionId[63:0];
                          //rwRspArray[sL2Ifc.cbSlvDrv.reqSeq[BITSEQN-1:0]] = wrMonT;
                          if(slvAddrArray.exists(wrMonT.Addr)) begin
                            rdPendTr = slvAddrArray[wrMonT.Addr];
                           `DEBUG($psprintf("rdAddMonitor L2 have 2 same Pending Request's, Addr %s  ",wrMonT.reqSprint))
                           `DEBUG($psprintf("rdAddMonitor L2 Rsv      Creq ID  %x  ",wrMonT.ReqSeq))
                           `ERROR($psprintf("rdAddMonitor L2 Pending  Creq ID  %x  ",rdPendTr.ReqSeq))
                          end
                          wrReceived();
                   end
               clock(1);
             end
       endtask:wrMonitor

        task rdAddMonitor();
             integer i;
	     CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) rdPendTr;
          while(1)
             begin
               wait( (sL2Ifc.cbSlvDrv.reqRd == 1'b1) && (sL2Ifc.cbSlvDrv.reqWr == 1'b0) && (sL2Ifc.cbSlvDrv.reqStall == 1'b0));
                  if(isActive == 1) begin
                        if(rwRspArray.exists(sL2Ifc.cbSlvDrv.reqSeq[BITSEQN-1:0])) begin
                            `DEBUG($psprintf("rdAddMonitor  Non Rspond ID still in L2. creqId %x  ",sL2Ifc.cbSlvDrv.reqSeq[BITSEQN-1:0]))
                             $finish;
                        end
                        `DEBUG($psprintf("rdAddMonitor   "))
                        rdAddMonT = new();
                        rdAddMonT.Addr     = sL2Ifc.cbSlvDrv.reqAddr;
                        rdAddMonT.Data     = 0;
                        rdAddMonT.ReqSeq   = sL2Ifc.cbSlvDrv.reqSeq;
                        rdAddMonT.RspSeq   = 0;
                        rdAddMonT.ByteEn   = 0;
                        rdAddMonT.Attr     = 0;
                        rdAddMonT.Write    = sL2Ifc.cbSlvDrv.reqWr;
                        rdAddMonT.Read     = sL2Ifc.cbSlvDrv.reqRd;
                        rdAddMonT.Inval    = 0;
                        rdAddMonT.valid    = 1;
                        rdAddMonT.transactionId = transactionId[63:0];
                        rdAddMonT.transactionTime = $time;
                        rwRspArray[sL2Ifc.cbSlvDrv.reqSeq[BITSEQN-1:0]] = rdAddMonT;
                        if(slvAddrArray.exists(rdAddMonT.Addr)) begin
                            rdPendTr = slvAddrArray[rdAddMonT.Addr];
                           `DEBUG($psprintf("rdAddMonitor L2 have 2 same Pending Request's, Addr %s  ",rdAddMonT.reqSprint))
                           `DEBUG($psprintf("rdAddMonitor L2 Rsv      Creq ID  %x  ",rdAddMonT.ReqSeq))
                           `ERROR($psprintf("rdAddMonitor L2 Pending  Creq ID  %x  ",rdPendTr.ReqSeq))
                        end
                        slvAddrArray[rdAddMonT.Addr] = rdAddMonT;
                        rdAddReceived();
                  end
               clock(1);
             end
       endtask:rdAddMonitor

       task reqBusMonitor();
          while(1)
             begin
               wait( (sL2Ifc.cbSlvMon.reqRd == 1) && (sL2Ifc.cbSlvMon.reqWr == 1) && (sL2Ifc.cbSlvMon.reqStall == 0));
                     `DEBUG($psprintf("reqBusMonitor   "))
                     reqMonT = new();
                     reqMonT.Addr     = sL2Ifc.cbSlvMon.reqAddr;
                     reqMonT.Data     = sL2Ifc.cbSlvMon.reqDin;
                     reqMonT.ReqSeq   = sL2Ifc.cbSlvMon.reqSeq;
                     reqMonT.RspSeq   = 0;
                     reqMonT.ByteEn   = 0;
                     reqMonT.Attr     = 0;
                     reqMonT.Write    = sL2Ifc.cbSlvMon.reqWr;
                     reqMonT.Read     = sL2Ifc.cbSlvMon.reqRd;
                     reqMonT.Inval    = 0;
                     reqMonT.valid    = 1;
                     reqMonT.transactionTime = $time;
                     reqMonT.transactionId = transactionId[63:0];
                     reqBusMonReceived();
               clock(1);
             end
       endtask:reqBusMonitor

       

       task rspBusMonitor();
          while(1)
             begin
               wait( (sL2Ifc.cbSlvMon.rspVld == 1) && (sL2Ifc.cbSlvMon.rspStall == 0));
                     `DEBUG($psprintf("rspBusMonitor   "))
                     rspMonT = new();
                     rspMonT.Addr     = 0;
                     rspMonT.Data     = sL2Ifc.cbSlvMon.rspDout;
                     rspMonT.ReqSeq   = 0;
                     rspMonT.RspSeq   = sL2Ifc.cbSlvMon.rspSeq;
                     rspMonT.ByteEn   = 0;
                     rspMonT.Attr     = 0;
                     rspMonT.Write    = sL2Ifc.cbSlvMon.reqWr;
                     rspMonT.Read     = sL2Ifc.cbSlvMon.reqRd;
                     rspMonT.Inval    = 0;
                     rspMonT.valid    = 1;
                     rspMonT.transactionTime = $time;
                     rspMonT.transactionId = transactionId[63:0];
                     rspBusMonReceived();
               clock(1);
             end
       endtask:rspBusMonitor

       
       

       



       task send (CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) t);
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

     task rdAddReceive (ref CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) t);
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

     task wrReceive (ref CacheTransaction #(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) t);
        begin
           waitUntilWrreceived();
           t = wrMonT;
        end
     endtask:wrReceive


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
         repeat(numClocks)@(sL2Ifc.cbSlvDrv);
       end
    endtask:clock



endclass:CacheSlaveTransactor
`endif






