task CacheTestcases::basicTest ();
    reg [BITADDR-1:0]reqAddr;
    reg [NUMBYLN-1:0]byteEn;
   `TB_YAP("TEST STARTED")
   `TB_YAP("DATA CACHE TEST STARTED")
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

     tb.clock(100);
    /* reqAddr[BITADDR-1:0] = {27'h1,5'h0};
     tb.sendRead(reqAddr[BITADDR-1:0]);
     tb.clock(100);

    `TB_YAP($psprintf("TEST FINISHED time %0d ", $time))
     reqAddr[BITADDR-1:0] = {27'h2,5'h0};
     byteEn[NUMBYLN-1:0] = 32'hffffffff;
     tb.sendWrite(reqAddr[BITADDR-1:0], byteEn[NUMBYLN-1:0]);
     tb.clock(100);
     reqAddr[BITADDR-1:0] = {27'h2,5'h0};
     tb.sendRead(reqAddr[BITADDR-1:0]);*/

     tb.sendRequest();

   `TB_YAP("TEST FINISHED ")
   tb.clock(100000); 
endtask:basicTest
