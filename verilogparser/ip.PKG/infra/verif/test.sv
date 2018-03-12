task MemoryModel::test ();

  bit few_rand = 0;

  `TB_YAP("Running tests")
  
  test_write_all();
  test_simple();
  test_random(few_rand);
  test_capacity_check();
  test_op_sequence();
  test_read_all();

  `TB_YAP("All tests completed")

endtask
