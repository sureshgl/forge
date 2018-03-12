task MeCacheTestcases::basicTest ();
    reg stallDis;
    reg outOfOrderDis;
    reg [6:0]wayIndex;
    reg cacheReads;
    reg [NXADDRWIDTH-1:0]reqAddr;
    reg [NXTYPEWIDTH-1:0]reqType;
    reg [NXSIZEWIDTH-1:0]reqSize;
    reg [NXATTRWIDTH-1:0]reqattr;
    reg rowSelectRandomEn;
    reg randomL2ErrorEn;
   `TB_YAP("TEST STARTED")
   `TB_YAP("INST CACHE TEST STARTED")
     wayIndex[6:0] = 4;
     stallDis = 0;
     outOfOrderDis = 0;
     cacheReads = 1;
     randomL2ErrorEn = 0;

    
    /* tb.sendRead(33'h60, 8'h20, 0, 1);
     tb.clock(1000);
     tb.sendRead(33'h80, 8'h20, 0, 1);
     tb.clock(1000); */
/*
     // basic read and write cmd's
     //(input reg [NXADDRWIDTH-1:0] addr,input reg [7:0] size,input reg uch, input reg ack,input reg byIndex);
     tb.l2RrspDataErr =1;
     tb.l2RrspAddErr = 1;
     tb.sendRead(33'h20, 8'h20, 0, 1);
     //tb.sendInval(0, 0, 0, 1,0);
     //tb.sendRead(33'h20, 8'h20, 0, 1);
*/
     randomL2ErrorEn = 0;
     cacheReads = 1;

   `TB_YAP("Loop 1")
     stallDis = 0;
     outOfOrderDis = 0;
     rowSelectRandomEn = 0;
     tb.sendRandomIcacheReq(500000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads

   `TB_YAP("Loop 2")
     stallDis = 1;
     outOfOrderDis = 0;
     rowSelectRandomEn = 0;
     tb.sendRandomIcacheReq(500000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads

     
   `TB_YAP("Loop 3")
     stallDis = 0;
     outOfOrderDis = 0;
     rowSelectRandomEn = 1;
     tb.sendRandomIcacheReq(500000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads


   `TB_YAP("Loop 4")
     stallDis = 1;
     outOfOrderDis = 0;
     rowSelectRandomEn = 1;
     tb.sendRandomIcacheReq(500000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads


   `TB_YAP("Loop 4.1")
     stallDis = 1;
     outOfOrderDis = 1;
     rowSelectRandomEn = 0;
     tb.sendRandomIcacheReq(200000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads

   `TB_YAP("Loop 4.2")
     stallDis = 1;
     outOfOrderDis = 1;
     rowSelectRandomEn = 1;
     tb.sendRandomIcacheReq(200000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads

  `TB_YAP("Loop 4.3")
     stallDis = 0;
     outOfOrderDis = 1;
     rowSelectRandomEn = 0;
     tb.sendRandomIcacheReq(200000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads

   `TB_YAP("Loop 4.4")
     stallDis = 0;
     outOfOrderDis = 1;
     rowSelectRandomEn = 1;
     tb.sendRandomIcacheReq(200000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads


     randomL2ErrorEn = 0;
     cacheReads = 0;

   `TB_YAP("Loop 5")
     stallDis = 0;
     outOfOrderDis = 0;
     rowSelectRandomEn = 0;
     tb.sendRandomIcacheReq(500000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads

`TB_YAP("Loop 5")
     stallDis = 0;
     outOfOrderDis = 1;
     rowSelectRandomEn = 0;
     tb.sendRandomIcacheReq(500000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads

   `TB_YAP("Loop 6")
     stallDis = 1;
     outOfOrderDis = 0;
     rowSelectRandomEn = 0;
     tb.sendRandomIcacheReq(500000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads

   `TB_YAP("Loop 6.1")
     stallDis = 1;
     outOfOrderDis = 1;
     rowSelectRandomEn = 0;
     tb.sendRandomIcacheReq(500000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads

   `TB_YAP("Loop 6.2")
     randomL2ErrorEn = 1;
     cacheReads = 1;
     stallDis = 0;
     outOfOrderDis = 0;
     rowSelectRandomEn = 0;
     tb.sendRandomIcacheReq(200000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads
     rowSelectRandomEn = 1;
     tb.sendRandomIcacheReq(200000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads

/*
//------------------------------------------------------------------------------------------------  With Error

     randomL2ErrorEn = 1;
     cacheReads = 1;

   `TB_YAP("Loop 7")
     stallDis = 0;
     outOfOrderDis = 0;
     rowSelectRandomEn = 0;
     tb.sendRandomIcacheReq(500000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads

   `TB_YAP("Loop 7.1")
     stallDis = 0;
     outOfOrderDis = 1;

     rowSelectRandomEn = 0;
     tb.sendRandomIcacheReq(500000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads

   `TB_YAP("Loop 8")
     stallDis = 1;
     outOfOrderDis = 0;
     rowSelectRandomEn = 0;
     tb.sendRandomIcacheReq(500000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads

     
   `TB_YAP("Loop 9")
     stallDis = 0;
     outOfOrderDis = 0;
     rowSelectRandomEn = 1;
     tb.sendRandomIcacheReq(500000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads


   `TB_YAP("Loop 10")
     stallDis = 1;
     outOfOrderDis = 0;
     rowSelectRandomEn = 1;
     tb.sendRandomIcacheReq(500000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads


     randomL2ErrorEn = 1;
     cacheReads = 0;

   `TB_YAP("Loop 11")
     stallDis = 0;
     outOfOrderDis = 0;
     rowSelectRandomEn = 0;
     tb.sendRandomIcacheReq(500000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads


   `TB_YAP("Loop 12")
     stallDis = 1;
     outOfOrderDis = 0;
     rowSelectRandomEn = 0;
     tb.sendRandomIcacheReq(500000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads

    `TB_YAP("Loop 12.1")
     stallDis = 0;
     outOfOrderDis = 1;
     rowSelectRandomEn = 0;
     tb.sendRandomIcacheReq(500000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads

//---------------------------------------------------------------------------------
*/


   `TB_YAP("Loop 12.2")

    
     stallDis = 0;
     outOfOrderDis = 0;
     cacheReads = 1;
     rowSelectRandomEn = 0;
     randomL2ErrorEn = 0;
     tb.sendRandomIcacheReq(500000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn,randomL2ErrorEn); // Random Cache Reads


   `TB_YAP("Loop 13")

     tb.instCacheBasicRDTest(wayIndex,stallDis,outOfOrderDis);
   `TB_YAP("Loop 14")
     tb.instCacheCapacityTest(wayIndex,stallDis,outOfOrderDis);
   `TB_YAP("Loop 15")
     tb.instCacheRdAllTest();


   `TB_YAP("Loop 16")
     tb.invalidWaybyIndexTest();  
     tb.dbgBusTest();
//================== T1_MEM_ERROR_CHECK=======
     tb.testForT1MemError(31'h60, 50);//(input reg [NXADDRWIDTH-1:0]Addr, input integer errorBitPos)
//================== T2_MEM_ERROR_CHECK=======
     tb.testForT2MemError(31'hfe0, 125);//(input reg [NXADDRWIDTH-1:0]Addr, input integer errorBitPos,input reg [2:0] errorBeet)
     tb.test_dbg_init_all();
     tb.resetCache();


// single read
       //reqAddr[NXADDRWIDTH-1:0] = 31'h24;
       //reqType[NXTYPEWIDTH-1:0] = CH_READ;
       //reqSize[NXSIZEWIDTH-1:0] = 8'hE;
       //reqattr[NXATTRWIDTH-1:0] = 3'h1;
       //tb.sendReq(reqAddr,reqType,reqSize,reqattr);






    tb.testT1MemError();
    tb.testT2MemError();
     tb.testT1MemErrorNoL2Error();
     tb.test_dbg_init_all();
    tb.testT2MemErrorNoL2Error();

   `TB_YAP("TEST FINISHED ")
   tb.clock(1000);

//=========================Status Test======================== 
      //tb.sendRandomIcacheReq(1000000,stallDis,outOfOrderDis,cacheReads,rowSelectRandomEn); // Random Cache Reads
      //tb.statsTest();
//=============================================================
endtask:basicTest
