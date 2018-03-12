`ifndef ME_TRANSACTOR
`define ME_TRANSACTOR
virtual class MeTransactor;

protected string name;
protected event transactionreceived;
protected mailbox sendQ;
protected bit driveInProgress;
protected bit writeInProgress;
protected bit readInProgress;

function new (string name);
  begin
   this.name = name;
   sendQ = new();
   driveInProgress = 0;
   writeInProgress = 0;
   readInProgress = 0;
  end
endfunction

/*extern virtual task reset();
extern virtual task clear();
//extern virtual task init();
extern virtual task run();
extern virtual task drive();
extern virtual task monitor();*/

task reset() ; endtask
task clear(); endtask
//task init(); endtask
task run(); endtask
task drive(); endtask
task monitor(); endtask


task received();
 -> transactionreceived;
endtask

task waitUntilReceived ();
  @transactionreceived;
endtask

 task clock (integer numClocks = 1); endtask

endclass:MeTransactor
`endif
