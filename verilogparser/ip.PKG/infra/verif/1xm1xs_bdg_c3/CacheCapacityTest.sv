task MeCacheTestcases::CacheCapacityTest ();
    `TB_YAP("CAPACITY TEST STARTED")
      tb.dataCacheCapacityTest();
    `TB_YAP("CAPACITY TEST END")
   tb.clock(100000); 
endtask:CacheCapacityTest


