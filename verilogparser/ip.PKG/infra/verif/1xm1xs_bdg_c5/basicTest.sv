task MeCacheTestcases::basicTest ();

/*
  // SREE's test
  //(input reg [NXADDRWIDTH-1:0] addr,input reg [7:0] size,input reg uch, input reg ack, input reg byIndex)
  tb.l2RrspDataErr =1;
  tb.l2RrspAddErr = 1;
  tb.sendRead(32'h200, 0, 0, 1);
  tb.clock(1000);
  tb.l2RrspDataErr =0;
  tb.l2RrspAddErr = 0;
  tb.sendRead(32'h200, 0, 0, 1);
  tb.clock(1000);
  tb.sendRead(32'h200, 0, 0, 1);
  //tb.sendInval(32'h200,0, 0,1,0);
  //(input reg [NXADDRWIDTH-1:0] addr,input reg [7:0] size,input reg [3:0]noBeets,input [2:0]beetStart);
  tb.sendNonCacheRead(61'h200,8'h80,4'h4,3'h0);
  tb.clock(1000);

*/


  reg stallDisable;
  reg gapBetweenBeetsDisable;
  reg outoffOrderRspDisable;
  reg rowSelectRandomEn;
  reg randomL2ErrorEn;

  randomL2ErrorEn = 0;
  outoffOrderRspDisable = 0;


  `TB_YAP("Loop 1 ")
  stallDisable = 1;
  gapBetweenBeetsDisable = 1;
  outoffOrderRspDisable = 1;
  rowSelectRandomEn = 0;
  tb.sendRandomDesCacheReq(500000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,rowSelectRandomEn,randomL2ErrorEn);  // Random test


  `TB_YAP("Loop 2 ")
  stallDisable = 1;
  gapBetweenBeetsDisable = 1;
  outoffOrderRspDisable = 0;
  rowSelectRandomEn = 0;
  tb.sendRandomDesCacheReq(500000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,rowSelectRandomEn,randomL2ErrorEn);  // Random test


  `TB_YAP("Loop 3 ")
  stallDisable = 0;
  gapBetweenBeetsDisable = 0;
  outoffOrderRspDisable = 1;
  rowSelectRandomEn = 0;
  tb.sendRandomDesCacheReq(500000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,rowSelectRandomEn,randomL2ErrorEn);  // Random test


  `TB_YAP("Loop 4 ")
  stallDisable = 1;
  gapBetweenBeetsDisable = 1;
  outoffOrderRspDisable = 1;
  rowSelectRandomEn = 0;
  tb.sendRandomDesCacheReq(500000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,rowSelectRandomEn,randomL2ErrorEn);  // Random test



 `TB_YAP("Loop 5 ")
  stallDisable = 0;
  gapBetweenBeetsDisable = 0;
  outoffOrderRspDisable = 0;
  rowSelectRandomEn = 1;
  tb.sendRandomDesCacheReq(500000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,rowSelectRandomEn,randomL2ErrorEn);  // Random test


  `TB_YAP("Loop 6 ")
  stallDisable = 1;
  gapBetweenBeetsDisable = 1;
  outoffOrderRspDisable = 0;
  rowSelectRandomEn = 1;
  tb.sendRandomDesCacheReq(500000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,rowSelectRandomEn,randomL2ErrorEn);  // Random test


  `TB_YAP("Loop 7 ")
  stallDisable = 0;
  gapBetweenBeetsDisable = 0;
  outoffOrderRspDisable = 1;
  rowSelectRandomEn = 1;
  tb.sendRandomDesCacheReq(500000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,rowSelectRandomEn,randomL2ErrorEn);  // Random test


  `TB_YAP("Loop 8 ")
  stallDisable = 1;
  gapBetweenBeetsDisable = 1;
  outoffOrderRspDisable = 1;
  rowSelectRandomEn = 1;
  tb.sendRandomDesCacheReq(500000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,rowSelectRandomEn,randomL2ErrorEn);  // Random test


 
  `TB_YAP("Loop 9 ")
  stallDisable = 0;
  gapBetweenBeetsDisable = 0;
  outoffOrderRspDisable = 0;
  rowSelectRandomEn = 0;
  tb.sendRandomDescacheNonCacheRdReq(100000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,randomL2ErrorEn);

  `TB_YAP("Loop 10 ")
  randomL2ErrorEn = 1;
  outoffOrderRspDisable = 0;
  stallDisable = 0;
  gapBetweenBeetsDisable = 0;
  rowSelectRandomEn = 0;
  tb.sendRandomDesCacheReq(200000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,rowSelectRandomEn,randomL2ErrorEn);  // Random test
  rowSelectRandomEn = 1;
  tb.sendRandomDesCacheReq(200000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,rowSelectRandomEn,randomL2ErrorEn);  // Random test

/*

//-----------------------------------------------------WITH ERROR TEST


  randomL2ErrorEn = 1;

 `TB_YAP("Loop 1 ")
  stallDisable = 0;
  gapBetweenBeetsDisable = 0;
  outoffOrderRspDisable = 0;
  rowSelectRandomEn = 0;
  tb.sendRandomDesCacheReq(500000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,rowSelectRandomEn,randomL2ErrorEn);  // Random test


  `TB_YAP("Loop 2 ")
  stallDisable = 1;
  gapBetweenBeetsDisable = 1;
  outoffOrderRspDisable = 0;
  rowSelectRandomEn = 0;
  tb.sendRandomDesCacheReq(500000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,rowSelectRandomEn,randomL2ErrorEn);  // Random test


  `TB_YAP("Loop 3 ")
  stallDisable = 0;
  gapBetweenBeetsDisable = 0;
  outoffOrderRspDisable = 1;
  rowSelectRandomEn = 0;
  tb.sendRandomDesCacheReq(300000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,rowSelectRandomEn,randomL2ErrorEn);  // Random test


  `TB_YAP("Loop 4 ")
  stallDisable = 1;
  gapBetweenBeetsDisable = 1;
  outoffOrderRspDisable = 1;
  rowSelectRandomEn = 0;
  tb.sendRandomDesCacheReq(300000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,rowSelectRandomEn,randomL2ErrorEn);  // Random test



 `TB_YAP("Loop 5 ")
  stallDisable = 0;
  gapBetweenBeetsDisable = 0;
  outoffOrderRspDisable = 0;
  rowSelectRandomEn = 1;
  tb.sendRandomDesCacheReq(500000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,rowSelectRandomEn,randomL2ErrorEn);  // Random test


  `TB_YAP("Loop 6 ")
  stallDisable = 1;
  gapBetweenBeetsDisable = 1;
  outoffOrderRspDisable = 0;
  rowSelectRandomEn = 1;
  tb.sendRandomDesCacheReq(500000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,rowSelectRandomEn,randomL2ErrorEn);  // Random test


  `TB_YAP("Loop 7 ")
  stallDisable = 0;
  gapBetweenBeetsDisable = 0;
  outoffOrderRspDisable = 1;
  rowSelectRandomEn = 1;
  tb.sendRandomDesCacheReq(300000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,rowSelectRandomEn,randomL2ErrorEn);  // Random test


  `TB_YAP("Loop 8 ")
  stallDisable = 1;
  gapBetweenBeetsDisable = 1;
  outoffOrderRspDisable = 1;
  rowSelectRandomEn = 1;
  tb.sendRandomDesCacheReq(300000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,rowSelectRandomEn,randomL2ErrorEn);  // Random test


 
   
  `TB_YAP("Loop 9 ")
  stallDisable = 0;
  gapBetweenBeetsDisable = 0;
  rowSelectRandomEn = 0;
  outoffOrderRspDisable = 0;
  tb.sendRandomDescacheNonCacheRdReq(100000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,randomL2ErrorEn);

//-----------------------------------------------------------------------------------------------
*/
  `TB_YAP("Loop 15 ")
  stallDisable = 0;
  gapBetweenBeetsDisable = 0;
  outoffOrderRspDisable = 0;
  randomL2ErrorEn =0;
  rowSelectRandomEn = 0;
  tb.sendRandomDesCacheReq(10000,stallDisable,gapBetweenBeetsDisable,outoffOrderRspDisable,rowSelectRandomEn,randomL2ErrorEn);  // Random test

  `TB_YAP("Loop 16 ")
  tb.DesCacheCapacityTest();  // Test all bits in address bus 
  tb.prefetchCacheReq(100000);  // PreFetch test
  tb.testforInvalidByIndex();
  tb.clock(1000);

  tb.dbgBusTest();
  //================== T1_MEM_ERROR_CHECK=======
  tb.testForT1MemError(61'h300, 233);//(input reg [NXADDRWIDTH-1:0]Addr, input integer errorBitPos)
  //================== T2_MEM_ERROR_CHECK=======
  tb.testForT2MemError(61'h400, 124,4);//(input reg [NXADDRWIDTH-1:0]Addr, input integer errorBitPos,input reg [2:0] errorBeet)
  tb.test_dbg_init_all();
  tb.resetCache();

//  RandomMemErrorTest
tb.testT1MemError();
tb.testT2MemError();
tb.clock(1000);
tb.testT1MemErrorNoL2Error();
tb.test_dbg_init_all();
tb.testT2MemErrorNoL2Error();
tb.clock(1000);


`TB_YAP("Write task finished")
endtask:basicTest
