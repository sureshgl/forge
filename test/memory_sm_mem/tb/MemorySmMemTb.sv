//`timescale 1ns/1ps

module MemorySmMemTb;

  //timeunit 1ns;
  //timeprecision 10ps;

//================================================================================
// Clock and Rst
//================================================================================
  
  reg         clk;
  reg         rst;

  real        regClkFreq;
  real        regClkHalfPeriod;
  
//================================================================================
// Clock generation
//================================================================================
  initial begin
    $timeformat ( -9, 3 , "ns", 10 );
  end

  initial begin
    clk = 1'b0;
    forever #regClkHalfPeriod clk = ~clk; 
  end

  initial begin
    if (!$value$plusargs("regClkFreq=%d",regClkFreq)) begin
      regClkFreq = 150; //in Mhz
    end   
    if ( regClkFreq == 0 ) begin
      $display("%0t:ERROR: ClkFreq sholud be a non-zero",$realtime);
      $finish;
    end  
    $display("%0t: Clk frequency=%0dMHz",$realtime,regClkFreq);
    regClkHalfPeriod = 1/(2*regClkFreq) * 1000; //ns
  end 

//================================================================================
// Wave debug
//================================================================================
//VPD dump
initial begin
  if ($test$plusargs("waves")) begin
    $vcdplusfile("MemorySmMem.vpd");
    $vcdpluson();
    $vcdplusmemon();
  end
end

//================================================================================
// DUT
//================================================================================
//`include "memory_sm_mem.vh"

parameter NUMRPRT = 2;
parameter NUMWPRT = 1;
parameter NUMADDR = 1024;
parameter BITDATA = 45;
parameter BITADDR = 1;
parameter FLOPOUT = 0;

logic  [NUMWPRT-1:0] sm_mem_write;
logic  [BITADDR-1:0] sm_mem_wr_adr  [0:NUMWPRT-1];
logic  [BITDATA-1:0] sm_mem_din     [0:NUMWPRT-1];
logic  [NUMRPRT-1:0] sm_mem_read;
logic  [BITADDR-1:0] sm_mem_rd_adr  [0:NUMRPRT-1];
logic  [BITDATA-1:0] sm_mem_rd_dout [0:NUMRPRT-1];

mem_sm_mem dut (
  .clk (clk),
  .rst (rst),
  .sm_mem_write (sm_mem_write), 
  .sm_mem_wr_adr (sm_mem_wr_adr), 
  .sm_mem_din (sm_mem_din),
  .sm_mem_read (sm_mem_read), 
  .sm_mem_rd_adr (sm_mem_rd_adr), 
  .sm_mem_rd_dout (sm_mem_rd_dout)
);

//================================================================================
// Testcase selector 
//================================================================================
string testName;
integer numReqs=0;
integer errCnt=0;

initial begin  
  if(!$value$plusargs("numReqs=%d",numReqs)) begin
    numReqs=10;
  end
  $display ("%0t:numReqs=%d ",$realtime,numReqs);
end 

initial begin  
  if(!$value$plusargs("testName=%s",testName)) begin
    $display ("%0t:No test is selected..selecting memWrRdTest ",$realtime);
    testName = "memWrRdTest";
  end else begin
    reset ();
    runTest();
    eos();
  end
end

task runTest();
  $display("%0t:Running %s ",$realtime,testName);
  if ( testName == "memWrRdTest") begin
    memWrRdTest();
  end else begin 
    $display ("%0t:No test is selected ",$realtime);
    $display ("%0t:Available tests are:",$realtime);
    $display ("%0t:   memWrRdTest ",$realtime);
    $display ("%0t:Ending simulation...",$realtime);
    $finish;
  end  
endtask : runTest

//================================================================================
// Common routines
//================================================================================

task clock (integer numClocks=1);
  repeat (numClocks) @(posedge clk);
endtask : clock

task reset ();
  $display ("%0t: asserting reset", $realtime);
  rst = 1'b1;
  clock(20);
  rst = 1'b0;
  $display ("%0t: de-asserting reset", $realtime);
  clock(5);
endtask : reset

task eos ();
  if  (errCnt) begin
    $display("%0t: Test=%s FAILED errCnt=%d",$realtime,testName,errCnt);
    $finish;
  end else begin
    $display("%0t: Test=%s PASSED",$realtime,testName);
    $finish;
  end
endtask : eos

task memWrite (logic [NUMWPRT-1:0] write, logic [BITADDR-1:0] addr [0:NUMWPRT-1], logic [BITDATA-1:0] din [0:NUMWPRT-1]);
  $display("%0t: memWrite ",$realtime);
  sm_mem_write = write;
  sm_mem_wr_adr = addr;
  sm_mem_din = din;
  clock(1);
  for (integer i=0; i < NUMWPRT; i++ ) begin
    sm_mem_write[i] = 1'b0;
    $display("%0t: memWrite: wport=%0d addr=%0x din=%0x",$realtime,i,addr[i],din[i]);
  end  
endtask : memWrite

task memRead ( ref logic [BITDATA-1:0] dout [0:NUMRPRT-1], logic [NUMRPRT-1:0] read, logic [BITADDR-1:0] addr [0:NUMRPRT-1] );
  $display("%0t: memRead ",$realtime);
  sm_mem_read = read;
  sm_mem_rd_adr = addr;
  clock(1);
  for (integer i=0; i < NUMRPRT; i++ ) begin
    sm_mem_read[i] = 1'b0;
  end  
  clock(FLOPOUT); //rd delay
  for (integer i=0; i < NUMRPRT; i++ ) begin
    dout[i] = sm_mem_rd_dout[i];
    $display("%0t: memRead: rport=%0d read=%0b addr=%0x dout=%0x",$realtime,i,read[i],addr[i],dout[i]);
  end  
endtask : memRead

//================================================================================
// Tests
//================================================================================

task memWrRdTest ();
  reg [BITDATA-1:0] wdata [0:NUMWPRT-1];
  reg [BITADDR-1:0] waddr [0:NUMWPRT-1];
  reg [NUMWPRT-1:0] write;
  reg [BITDATA-1:0] rdata [0:NUMRPRT-1];
  reg [BITADDR-1:0] raddr [0:NUMRPRT-1];
  reg [NUMRPRT-1:0] read;
  integer addr; 
  
  addr = $random();
  repeat (numReqs) begin
    for (integer j=0; j < NUMWPRT; j++) begin
      write[j] = 1'b1; //TBD:randomize 
      waddr[j] = addr + j;
      wdata[j] = $random();
    end
    memWrite(write, waddr, wdata);
    for (integer k=0; k < NUMRPRT; k++) begin
      read[k] = (k < NUMWPRT) ? 1'b1 : 1'b0; 
      raddr[k] = waddr[k];
    end
    memRead(rdata, read, raddr);
    for (integer i=0; i < NUMWPRT; i++ ) begin
      if ( wdata[i] !== rdata[i] ) begin 
        errCnt++;
        $display("%0t: mem read: rdata mismatch: wdata=%0x rdata=%0x",$realtime, wdata[i], rdata[i]);
      end
    end  
    if (errCnt) eos(); 
  end  
endtask : memWrRdTest

endmodule : MemorySmMemTb
