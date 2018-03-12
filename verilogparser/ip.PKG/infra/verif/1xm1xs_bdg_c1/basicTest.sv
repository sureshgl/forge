task MeCacheTestcases::basicTest ();
    reg stallDis;
    reg outOfOrderDis;
    reg [6:0]wayIndex;
    reg [NXADDRWIDTH-1:0]reqAddr;
    reg [NXTYPEWIDTH-1:0]reqType;
    reg [NXSIZEWIDTH-1:0]reqSize;
    reg [NXATTRWIDTH-1:0]reqattr;
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
     //(input reg [NXADDRWIDTH-1:0] addr,input reg [7:0] size,input reg uch, input reg ack,input reg byIndex);
     tb.sendWrite(33'h20,8'h20, 0, 1);
     tb.clock(1000);
     tb.sendRead(33'h20, 8'h20, 0, 1);
     tb.sendFlush(0, 0, 0, 1,0);
     tb.sendInval(0, 0, 0, 1,0);
*/
  

     tb.forceAckForallReq = 0;


    `TB_YAP("Loop 1")
     stallDis = 0;
     outOfOrderDis = 0;
     l2ErrorsEn = 0;
     rowSelectRandomEn = 0;
     tb.sendRandomDcacheReq(1000000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test


    `TB_YAP("Loop 2")
     stallDis = 1;
     outOfOrderDis = 0;
     l2ErrorsEn = 0;
     rowSelectRandomEn = 0;
     tb.sendRandomDcacheReq(1000000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test



    `TB_YAP("Loop 3")
     stallDis = 0;
     outOfOrderDis = 0;
     l2ErrorsEn = 0;
     rowSelectRandomEn = 1;
     tb.sendRandomDcacheReq(1000000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test



    `TB_YAP("Loop 4")
     stallDis = 1;
     outOfOrderDis = 0;
     l2ErrorsEn = 0;
     rowSelectRandomEn = 1;
     tb.sendRandomDcacheReq(1000000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test



    `TB_YAP("Loop 5")
     stallDis = 0;
     outOfOrderDis = 1;
     l2ErrorsEn = 0;
     rowSelectRandomEn = 0;
     tb.sendRandomDcacheReq(500000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test


    `TB_YAP("Loop 6")
     stallDis = 1;
     outOfOrderDis = 1;
     l2ErrorsEn = 0;
     rowSelectRandomEn = 0;
     tb.sendRandomDcacheReq(500000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test

    `TB_YAP("Loop 6.1")
     stallDis = 0;
     outOfOrderDis = 1;
     l2ErrorsEn = 0;
     rowSelectRandomEn = 1;
     tb.sendRandomDcacheReq(500000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test

`TB_YAP("Loop 6.2")
     stallDis = 1;
     outOfOrderDis = 1;
     l2ErrorsEn = 0;
     rowSelectRandomEn = 1;
     tb.sendRandomDcacheReq(500000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test


     tb.blockInvalReq = 1;
     stallDis = 0;
     outOfOrderDis = 0;
     l2ErrorsEn = 0;
     rowSelectRandomEn = 0;
     tb.sendRandomDcacheReq(500000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test
     rowSelectRandomEn = 1;
     tb.sendRandomDcacheReq(500000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test
     tb.blockInvalReq = 0;

     tb.forceAckForallReq = 1;

    `TB_YAP("Loop 7")
     stallDis = 0;
     outOfOrderDis = 0;
     l2ErrorsEn = 1;
     rowSelectRandomEn = 0;
     tb.sendRandomDcacheReq(1000000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test

/*
//--------------------------------------  WITH ERROR

     tb.forceAckForallReq = 1;

    `TB_YAP("Loop 7.1")
     stallDis = 0;
     outOfOrderDis = 0;
     l2ErrorsEn = 1;
     rowSelectRandomEn = 0;
     tb.sendRandomDcacheReq(500000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test


    `TB_YAP("Loop 8")
     stallDis = 1;
     outOfOrderDis = 0;
     l2ErrorsEn = 1;
     rowSelectRandomEn = 0;
     tb.sendRandomDcacheReq(500000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test



    `TB_YAP("Loop 9")
     stallDis = 0;
     outOfOrderDis = 0;
     l2ErrorsEn = 1;
     rowSelectRandomEn = 1;
     tb.sendRandomDcacheReq(500000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test



    `TB_YAP("Loop 10")
     stallDis = 1;
     outOfOrderDis = 0;
     l2ErrorsEn = 1;
     rowSelectRandomEn = 1;
     tb.sendRandomDcacheReq(500000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test

    `TB_YAP("Loop 11")
     stallDis = 0;
     outOfOrderDis = 1;
     l2ErrorsEn = 1;
     rowSelectRandomEn = 0;
     tb.sendRandomDcacheReq(500000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test



    `TB_YAP("Loop 12")
     stallDis = 1;
     outOfOrderDis = 1;
     l2ErrorsEn = 1;
     rowSelectRandomEn = 1;
     tb.sendRandomDcacheReq(500000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test

     tb.blockInvalReq = 1;
     stallDis = 0;
     outOfOrderDis = 0;
     l2ErrorsEn = 1;
     rowSelectRandomEn = 0;
     tb.sendRandomDcacheReq(500000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test
     rowSelectRandomEn = 1;
     tb.sendRandomDcacheReq(500000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test
     tb.blockInvalReq = 0;

*/

    `TB_YAP("Loop 12.1")
     stallDis = 0;
     outOfOrderDis = 0;
     l2ErrorsEn = 0;
     rowSelectRandomEn = 0;
     tb.sendRandomDcacheReq(10000,stallDis,outOfOrderDis,rowSelectRandomEn,l2ErrorsEn);// Random Test


     tb.forceAckForallReq = 0;
     tb.insertL2Error = 0;
     stallDis = 0;
     outOfOrderDis = 0;

    `TB_YAP("Loop 13")
     tb.dataCacheCapacityTest(wayIndex,stallDis,outOfOrderDis);  // Test for test all bits in address bus
     tb.dataCacheWrRdAllTest(); // test for test all teh rows and ways in the cache
     tb.invalByIndex();
     tb.flushByIndex();


     tb.dbgBusTest();
    //================== T1_MEM_ERROR_CHECK=======
    tb.testForT1MemError(33'h060, 9);//(input reg [NXADDRWIDTH-1:0]Addr, input integer errorBitPos)
    //================== T2_MEM_ERROR_CHECK=======
    tb.testForT2MemError(33'h020,143);//(input reg [NXADDRWIDTH-1:0]Addr, input integer errorBitPos,input reg [2:0] errorBeet)
    tb.test_dbg_init_all();
    tb.resetCache();


    // randomMemError
    tb.testT1MemError();
    tb.testT2MemError();
tb.testT1MemErrorNoL2Error();
    tb.test_dbg_init_all();
    tb.testT2MemErrorNoL2Error();

   `TB_YAP("TEST FINISHED ")
   tb.clock(100000); 
endtask:basicTest
