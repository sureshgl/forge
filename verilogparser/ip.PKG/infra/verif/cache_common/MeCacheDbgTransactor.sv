`ifndef ME_CACHE_DBG_TRANSACTOR
`define ME_CACHE_DBG_TRANSACTOR
class MeCacheDbgTransactor #(int DBGADDRWIDTH=7, int DBGBADDRWIDTH=7,int DBGDATAWIDTH=144) extends MeTransactor;

	virtual Dbg_Ifc  #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH)  dbgIfc;
           MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH) dbgTr;
        string name;
        bit writeOpInProgress;
        bit readOpInProgress;
        mailbox writeQueue;
        mailbox readQueue;
        mailbox reqQueue;
        event writeTransactionRspReceived;
        event readTransactionReceived;
        bit isActive;

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
           end
	endfunction:new
     
        task init(virtual Dbg_Ifc#(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH) dbgIfc);
           begin
              this.dbgIfc = dbgIfc;
             `DEBUG($psprintf("Task Init"))
           end
        endtask:init

        task reset ();
           begin
            if(isActive == 1) begin
             `DEBUG($psprintf("Task Reset"))
              dbgIfc.cbDbgDrv.dbg_en <=0; 
              dbgIfc.cbDbgDrv.dbg_read <=0; 
              dbgIfc.cbDbgDrv.dbg_write <=0; 
              dbgIfc.cbDbgDrv.dbg_addr <=0; 
              dbgIfc.cbDbgDrv.dbg_din <=0; 
              dbgIfc.cbDbgDrv.dbg_bank <=0; 
           end
           end
        endtask:reset

        task clear ();
           begin
            if(isActive == 1) begin
             `DEBUG($psprintf("Task Clear"))
              dbgIfc.cbDbgDrv.dbg_en <=0; 
              dbgIfc.cbDbgDrv.dbg_read <=0; 
              dbgIfc.cbDbgDrv.dbg_write <=0; 
              dbgIfc.cbDbgDrv.dbg_addr <=0; 
              dbgIfc.cbDbgDrv.dbg_din <=0; 
              dbgIfc.cbDbgDrv.dbg_bank <=0; 
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
             driveReq();
           join_none 
        endtask:drive

       task monitor();
             `DEBUG($psprintf("Task Monitor"))
           fork
             moniterReadData();
           join_none 
        endtask:monitor

        task driveReq();
           MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH) dbgReqTr;
           while(1) 
              begin
                 reqQueue.get(dbgReqTr);
                 dbgIfc.cbDbgDrv.dbg_en    <=1'b1; 
                 dbgIfc.cbDbgDrv.dbg_read  <=(dbgReqTr.reqType == DBG_READ) ? 1'b1 : 1'b0; 
                 dbgIfc.cbDbgDrv.dbg_write <=(dbgReqTr.reqType == DBG_WRITE) ? 1'b1 : 1'b0; 
                 dbgIfc.cbDbgDrv.dbg_addr  <=dbgReqTr.addr; 
                 dbgIfc.cbDbgDrv.dbg_bank  <=dbgReqTr.baddr; 
                 dbgIfc.cbDbgDrv.dbg_din   <=dbgReqTr.din; 
                 clock(1);
                 readQueue.put(dbgReqTr);
                 dbgIfc.cbDbgDrv.dbg_en <=0; 
                 dbgIfc.cbDbgDrv.dbg_read <=0; 
                 dbgIfc.cbDbgDrv.dbg_write <=0; 
                 dbgIfc.cbDbgDrv.dbg_addr <=0; 
                 dbgIfc.cbDbgDrv.dbg_din <=0; 
                 dbgIfc.cbDbgDrv.dbg_bank <=0; 
              end
        endtask:driveReq

        task moniterReadData();
           MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH) dbgReadTr;
          while(1) begin
           readQueue.get(dbgReadTr);
           while(dbgIfc.cbDbgDrv.dbg_vld == 1'b0) clock(1);
             dbgTr = new dbgReadTr;
             dbgTr.din  = 0; 
             dbgTr.dout = dbgIfc.cbDbgDrv.dbg_dout; 
             `DEBUG($psprintf("moniterReadData creq 1 %s  ",  dbgTr.dbgReadSprint))
             readDataReceived();
             clock(1);
           end
        endtask:moniterReadData

       task send (MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH) t);
          begin
             reqQueue.put(t);
          end
       endtask : send



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

     task readDataReceive (ref MeCacheDbgTransaction #(DBGADDRWIDTH,DBGBADDRWIDTH,DBGDATAWIDTH) t);
        begin
           waitUntilReadDatareceived();
           t = dbgTr;
        end
     endtask:readDataReceive



    task clock (integer numClocks = 1);
       begin
         repeat(numClocks)@(dbgIfc.cbDbgDrv);
       end
    endtask:clock



endclass:MeCacheDbgTransactor
`endif






