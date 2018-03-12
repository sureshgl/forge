task L2CacheTestcases::basicTest ();
    reg stallDis;
    reg outOfOrderDis;
    reg [6:0]wayIndex;
    reg [34-1:0]reqAddr;
    reg [3-1:0]reqType;
    reg [8-1:0]reqSize;
    reg [3-1:0]reqattr;
    reg rowSelectRandomEn;
    reg l2ErrorsEn;
   `TB_YAP("TEST STARTED")
   `TB_YAP("DATA CACHE TEST STARTED")
     wayIndex[6:0] = 4;
     stallDis = 0;
     outOfOrderDis = 0;
     rowSelectRandomEn = 0;
/*
    tb.l2RrspDataErr  = 1;
    tb.l2RrspAddErr  = 1;
     // basic read and write cmd's
     //(input reg [34-1:0] addr,input reg [7:0] size,input reg uch, input reg ack,input reg byIndex);
     tb.sendWrite(33'h20,8'h20, 0, 1);
     tb.clock(1000);
     tb.sendRead(33'h20, 8'h20, 0, 1);
     tb.sendFlush(0, 0, 0, 1,0);
     tb.sendInval(0, 0, 0, 1,0);
*/
  
     //(input reg [34-1:0] addr,input reg [7:0] size,input reg uch, input reg ack,input reg byIndex);

     reqAddr[34-1:0] = {22'h0,7'h2,5'h0};
     reqSize[8-1:0] = 8'h10;
     tb.sendRead(reqAddr[34-1:0], reqSize[8-1:0],1'b1);
     tb.clock(100);

     reqAddr[34-1:0] = {22'h0,7'h2,5'h0};
     reqSize[8-1:0] = 8'h10;
     tb.sendWrite(reqAddr[34-1:0], reqSize[8-1:0],1'b1);
     tb.clock(100);

   `TB_YAP("TEST FINISHED ")
   tb.clock(100000); 
endtask:basicTest
