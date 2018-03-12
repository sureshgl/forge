`ifndef L2_CACHE_TEST_BENCH
`define L2_CACHE_TEST_BENCH
class L2CacheTestBench #(int NXADDRWIDTH=31, int NXDATAWIDTH=256, int NXIDWIDTH=4, int NXTYPEWIDTH=3, int NXSIZEWIDTH=8, int NXATTRWIDTH=3,int NOMSTP = 1, int NOSLVP = 1,int NUMWAYS = 4, int NUMROWS = 128 ) extends MeTransactor;

   localparam BYTEADDBITS = 5;
   localparam ROWADDRBITS = 7;
   localparam TAGADDRBITS = NXADDRWIDTH - ROWADDRBITS  - BYTEADDBITS;


   string name;
   integer i,j;
   L2CacheMasterTransactor#(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) mstTr[NOMSTP];
   L2CacheSlaveTransactor#(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) slvTr[NOSLVP];
   virtual Misc_Ifc misc_ifc;
   virtual Naxi_Ifc  #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH)  mAxiIfc[NOMSTP];
   virtual Naxi_Ifc  #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH)  sAxiIfc[NOSLVP];

   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuWrRspT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2RdAMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2WrMonT;
   L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuRdRspT;
   integer                       RESET_CYCLE_COUNT = 20;
   integer                       TIMEOUT_CYCLE_COUNT = 30;
   integer                       DONE_CYCLE_COUNT = 50; // num empty cycles to call done

   function new (string name); begin
     super.new(name);
     this.name = name;
     `DEBUG($psprintf("Function New   "))

     for(i=0; i<NOMSTP; i = i+1) begin
       mstTr[i] = new($psprintf("mstTr[%d]",i));
     end 
     for(i=0; i<NOSLVP; i = i+1) begin
       slvTr[i] = new($psprintf("slvTr[%d]",i));
     end
   end
  endfunction:new

   task init (virtual Misc_Ifc misc_ifc,  virtual Naxi_Ifc#(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) mAxiIfc[NOMSTP],virtual Naxi_Ifc#(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) sAxiIfc[NOSLVP]);begin 
      this.misc_ifc = misc_ifc;
      `DEBUG($psprintf("Task Init   "))
      for(i=0; i<NOMSTP; i = i+1) begin
         mstTr[i].init(mAxiIfc[i]);
      end 
      for(i=0; i<NOSLVP; i = i+1) begin
         slvTr[i].init(sAxiIfc[i]);
      end 
    end
   endtask:init

   task clear();begin
       `DEBUG($psprintf("Task Clear   "))
       fork
         begin
          for(i=0; i<NOMSTP; i = i+1) begin
             mstTr[i].clear();
          end 
        end
        begin
          for(i=0; i<NOSLVP; i = i+1) begin
             slvTr[i].clear();
          end 
        end
       join_none
     end
   endtask:clear

   task reset(); begin
      misc_ifc.rst <= 1'b1;
      `TB_YAP("reset asserted")
      repeat (RESET_CYCLE_COUNT) @ (posedge misc_ifc.clk);
      misc_ifc.rst <= 1'b0;
      `TB_YAP("reset deasserted")
      waitForReady();
      fork
         begin
           for(i=0; i<NOMSTP; i = i+1) begin
            mstTr[i].reset();
           end 
         end
         begin
           for(i=0; i<NOSLVP; i = i+1) begin
              slvTr[i].reset();
           end 
         end
      join_none
     end
  endtask:reset

  task run();begin
      `DEBUG($psprintf("Task Run"))
      fork
        begin
          for(i=0; i<NOMSTP; i = i+1) begin
             mstTr[i].run();
          end 
        end
        begin
          for(i=0; i<NOSLVP; i = i+1) begin
             slvTr[i].run();
          end 
        end
        drive();
        monitor();
      join_none
    end
  endtask:run

   task drive();begin
       `DEBUG($psprintf("Task Drive"))
       fork
       join_none
     end
  endtask:drive


   task monitor(); begin
      `DEBUG($psprintf("Task Monitor"))
      fork
         monCpuWrRsp();
         monCpuRdRsp();
         monl2WrReq();
         monl2RdAddReq();
         sendL2RdRsp();
      join_none
     end
   endtask :monitor

   task clock (integer numClocks = 1);begin
          //`TB_YAP("clock task start")
          repeat(numClocks)@(misc_ifc.tb_req);
          //`TB_YAP("clock task finished")
        end
   endtask:clock

   task waitForReady();
      begin
      while(misc_ifc.tb_rsp.ready == 0)
          clock(1);
      end
   endtask 
 
   

   task monCpuWrRsp();begin
       integer queueSize,j;
       L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuWrErrRspTr;
       while(1) begin
          cpuWrRspT = new();
          cpuWrRspT.data[0] = 0;
          mstTr[0].writeRspReceive(cpuWrRspT);
         `DEBUG($psprintf("monCpuWrRsp cReq %s  ", cpuWrRspT.rreqSprint))
       end
     end
   endtask:monCpuWrRsp

   task monCpuRdRsp();begin
      while(1) begin
         cpuRdRspT = new();
         cpuRdRspT.data[0] = 0;
         mstTr[0].readDataReceive(cpuRdRspT);
         `DEBUG($psprintf("monCpuRdRsp cReq %s  ", cpuRdRspT.rreqSprint))
      end
    end
   endtask:monCpuRdRsp


   task monl2WrReq();begin
      L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2WrMonT1;
      while(1) begin
         l2WrMonT = new();
         l2WrMonT.data[0] = 0;
         slvTr[0].wrReceive(l2WrMonT);
         `DEBUG($psprintf("monl2WrReq cReq %s  ", l2WrMonT.creqSprint))
      end
     end
   endtask:monl2WrReq

   task monl2RdAddReq();begin
      L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2RsvRdReq;
      reg [NXDATAWIDTH-1:0]wrData;
      while(1) begin
         l2RdAMonT = new();
         l2RdAMonT.data[0] = 0;
         slvTr[0].rdAddReceive(l2RdAMonT);
         `TB_YAP($psprintf("monl2RdAddReq cReq %s  ", l2RdAMonT.creqSprint))
          if(l2RdAMonT.cattr[1] == CH_REQ_CACHE) begin
             wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,l2RdAMonT.addr);
             l2RdAMonT.data[0] = wrData[NXDATAWIDTH-1:0];
             wrData[NXDATAWIDTH-1:0] = randomData(NXDATAWIDTH,l2RdAMonT.addr);
             l2RdAMonT.data[1] = wrData[NXDATAWIDTH-1:0];
             l2RdAMonT.rattr = {2'h0,1'b1};
             l2RdAMonT.rId = l2RdAMonT.cId;
             slvTr[0].send(l2RdAMonT);
          end
      end
     end
   endtask:monl2RdAddReq




    task sendL2RdRsp();
       L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) l2RdDataTr;
       while(1) begin
         clock(1);
       end
   endtask:sendL2RdRsp


   function [NXDATAWIDTH-1:0] randomData(input integer width,input [NXADDRWIDTH-1:0]addr); 
      integer m; 
      randomData = 0; 
      for (m = width/32; m >= 0; m--) 
         randomData = (randomData << 32) + $urandom + 32'h12345678;
      randomData[NXADDRWIDTH-1:0] = addr;
   endfunction


   task finish();
      begin
        clock(1000);
      end
   endtask:finish

task sendWrite(input reg [NXADDRWIDTH-1:0] addr,input reg [7:0] size, input reg ack);
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
  reg  [NXDATAWIDTH-1:0]wrData;
  begin
    cpuReqT = new();
    `INFO($psprintf("write addr=0x%0x size=%0d ack=%0b", addr, size,ack))
    cpuReqT.addr = addr; 
    cpuReqT.cattr = (ack << 0) | (1 << 1);
    cpuReqT.reqType = CH_WRITE;
    cpuReqT.size = size;
    wrData[NXDATAWIDTH-1:0] =  randomData(NXDATAWIDTH,addr[NXADDRWIDTH-1:0]);
    cpuReqT.data[0] = wrData[NXDATAWIDTH-1:0];
    cpuReqT.dattr = 1;
    mstTr[0].send(cpuReqT);
  end
endtask:sendWrite


task sendInval(input reg [NXADDRWIDTH-1:0] addr,input reg [7:0] size, input reg ack);
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
  begin
    cpuReqT = new();
    `INFO($psprintf("inval addr=0x%0x size=%0d  ack=%0b ", addr, size, ack))
    cpuReqT.addr = addr; 
    cpuReqT.cattr = (ack << 0) | (1 << 1) ;
    cpuReqT.reqType = CH_INVAL;
    cpuReqT.size = size;
    mstTr[0].send(cpuReqT);
  end
endtask:sendInval

task sendRead(input reg [NXADDRWIDTH-1:0] addr,input reg [7:0] size, input reg ack);
  L2CacheTransaction #(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) cpuReqT;
  begin
    cpuReqT = new();
    `TB_YAP($psprintf("read addr=0x%0x size=%0d  ack=%0b", addr, size, ack))
    cpuReqT.addr = addr; 
    cpuReqT.cattr = (ack << 0) | (1 << 1);
    cpuReqT.reqType = CH_READ;
    cpuReqT.size = size;
    mstTr[0].send(cpuReqT);
  end
endtask:sendRead
endclass:L2CacheTestBench
`endif

