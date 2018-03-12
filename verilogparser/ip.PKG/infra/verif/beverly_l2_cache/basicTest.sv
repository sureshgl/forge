task L2CacheTestcases::basicTest ();
    reg stallDis;
    reg outOfOrderDis;
    reg [6:0]wayIndex;
    reg [NXADDRWIDTH-1:0]reqAddr;
    reg [NXSIZEWIDTH-1:0]reqSize;
    reg rowSelectRandomEn;
    reg l2ErrorsEn;
    reg [4:0]byteAddr;
    reg [2:0]beetAddr;
    reg [8:0]rowAddr;
    reg [16:0]tagAddr;
    reg [3:0]noBeets;
    bit ack;
    integer i;
   `TB_YAP("TEST STARTED")
   `TB_YAP("DATA CACHE TEST STARTED")
     stallDis = 0;
     outOfOrderDis = 0;
     rowSelectRandomEn = 0;

   /*  byteAddr[4:0] = 0;
     beetAddr[2:0] = 0;
     rowAddr[8:0] = 4;
     tagAddr[16:0] = 1;
     reqAddr[NXADDRWIDTH-1:0] = {tagAddr[16:0],rowAddr[8:0],beetAddr[2:0],byteAddr[4:0]};
     reqSize[NXSIZEWIDTH-1:0] = 8'h40;
     noBeets[3:0] = 2;
     ack = 1;
     tb.sendRead(reqAddr[NXADDRWIDTH-1:0], reqSize[NXSIZEWIDTH-1:0],ack,noBeets);
    */


   /*byteAddr[4:0] = 0;
     beetAddr[2:0] = 0;
     rowAddr[7:0] = 4;
     tagAddr[17:0] = 1;
     reqAddr[NXADDRWIDTH-1:0] = {tagAddr[17:0],rowAddr[7:0],beetAddr[2:0],byteAddr[4:0]};
     reqSize[NXSIZEWIDTH-1:0] = 8'h0;
     noBeets[3:0] = 8;
     ack = 1;
     tb.sendRead(reqAddr[NXADDRWIDTH-1:0], reqSize[NXSIZEWIDTH-1:0],ack,noBeets);
    
     byteAddr[4:0] = 0;
     beetAddr[2:0] = 0;
     rowAddr[7:0] = 4;
     tagAddr[17:0] = 2;
     reqAddr[NXADDRWIDTH-1:0] = {tagAddr[17:0],rowAddr[7:0],beetAddr[2:0],byteAddr[4:0]};
     reqSize[NXSIZEWIDTH-1:0] = 8'h0;
     noBeets[3:0] = 8;
     ack = 1;
     tb.sendRead(reqAddr[NXADDRWIDTH-1:0], reqSize[NXSIZEWIDTH-1:0],ack,noBeets);
     tb.clock(100);*/

     //tb.clock(100);
     //reqAddr[NXADDRWIDTH-1:0] = {18'h1,8'h4,3'h0,5'h0};
     //reqSize[NXSIZEWIDTH-1:0] = 8'h0;
    // tb.sendRead(reqAddr[NXADDRWIDTH-1:0], reqSize[NXSIZEWIDTH-1:0],1'b1);
    // tb.clock(100);
    


     /*for(i=0; i<100;i=i+1) begin
       reqAddr[NXADDRWIDTH-1:0] = {i,8'h4,3'h0,5'h0};
       reqSize[NXSIZEWIDTH-1:0] = 8'h0;
       tb.sendRead(reqAddr[NXADDRWIDTH-1:0], reqSize[NXSIZEWIDTH-1:0],1'b1);
     end */



    /* reqAddr[NXADDRWIDTH-1:0] = {18'h2,8'h4,3'h0,5'h0};
     reqSize[NXSIZEWIDTH-1:0] = 8'h0;
     tb.sendWrite(reqAddr[NXADDRWIDTH-1:0], reqSize[NXSIZEWIDTH-1:0],1'b1,4'h8);
     tb.clock(100);

     reqAddr[NXADDRWIDTH-1:0] = {18'h2,8'h4,3'h0,5'h0};
     reqSize[NXSIZEWIDTH-1:0] = 8'h0;
     tb.sendRead(reqAddr[NXADDRWIDTH-1:0], reqSize[NXSIZEWIDTH-1:0],1'b1);
     tb.clock(100);*/

  /*   for(i=0; i<8; i = i+1) begin
     byteAddr[4:0] = 0;
     beetAddr[2:0] = 0;
     rowAddr[8:0] = 4;
     tagAddr[16:0] = 2;
     reqAddr[NXADDRWIDTH-1:0] = {tagAddr[17:0],rowAddr[7:0],beetAddr[2:0],byteAddr[4:0]};
     reqSize[NXSIZEWIDTH-1:0] = 8'h40;
     noBeets[3:0] = 2;
     ack = 1;
     tb.sendWrite(reqAddr[NXADDRWIDTH-1:0], reqSize[NXSIZEWIDTH-1:0],ack,noBeets);

     end
tb.clock(100);*/
     tb.sendRandomReq();

   `TB_YAP("TEST FINISHED ")
   tb.clock(1000); 
endtask:basicTest
