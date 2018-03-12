virtual class MeTransaction;

protected event transactionSent;

task waitUntillSent();
  @(transactionSent);
endtask:waitUntillSent  

task sent();
 ->transactionSent;
endtask

//extern virtual task clear();

//extern virtual function string sprint();

function string sprint(); endfunction
endclass:MeTransaction
