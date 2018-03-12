//`timescale 1ns/1ps

module RegDgStatTb;

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
    $vcdplusfile("RegDgStat.vpd");
    $vcdpluson();
    $vcdplusmemon();
  end
end

//================================================================================
// DUT
//================================================================================
//`include "reg_dg_stat.vh"

localparam BITDATA = 22;
localparam FLOPODT = 0;
localparam FLOPOFL = 0;
localparam BITOFST_FL1 = 0;
localparam BITOFST_NMS = 2;
localparam BITOFST_XEN = 4;
localparam BITOFST_CNT = 16;
  
localparam BITDATA_FL1 = 1;
localparam BITDATA_NMS = 1;
localparam BITDATA_XEN = 1;
localparam BITDATA_CNT = 4;
  
logic                cwrite;
logic                cwack;
logic [BITDATA-1:0] cdin;
logic [BITDATA-1:0] cdout;

logic [BITDATA_FL1-1:0] dg_stat_fl1_rdat; 
logic [BITDATA_FL1-1:0] dg_stat_fl1_din;
logic                   dg_stat_fl1_wr;
 
logic [BITDATA_NMS-1:0] dg_stat_nms_rdat; 
logic [BITDATA_NMS-1:0] dg_stat_nms_din;
logic                   dg_stat_nms_wr;
 
logic [BITDATA_XEN-1:0] dg_stat_xen_rdat; 
logic [BITDATA_XEN-1:0] dg_stat_xen_din;
logic                   dg_stat_xen_wr;
 
logic [BITDATA_CNT-1:0] dg_stat_cnt_rdat; 
logic [BITDATA_CNT-1:0] dg_stat_cnt_din;
logic                   dg_stat_cnt_wr;

reg_dg_stat dut (
                 .clk              (clk),             
                 .rst              (rst),
                 .cwrite           (cwrite), 
                 .cdin             (cdin), 
                 .cwack            (cwack), 
                 .cdout            (cdout),
                 .dg_stat_fl1_rdat (dg_stat_fl1_rdat), 
                 .dg_stat_fl1_wr   (dg_stat_fl1_wr), 
                 .dg_stat_fl1_din  (dg_stat_fl1_din),
                 .dg_stat_nms_rdat (dg_stat_nms_rdat), 
                 .dg_stat_nms_wr   (dg_stat_nms_wr), 
                 .dg_stat_nms_din  (dg_stat_nms_din),
                 .dg_stat_xen_rdat (dg_stat_xen_rdat),
                 .dg_stat_xen_wr   (dg_stat_xen_wr),
                 .dg_stat_xen_din  (dg_stat_xen_din),
                 .dg_stat_cnt_rdat (dg_stat_cnt_rdat),
                 .dg_stat_cnt_wr   (dg_stat_cnt_wr),
                 .dg_stat_cnt_din  (dg_stat_cnt_din)
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
    $display ("%0t:No test is selected..selecting regWrRdTest ",$realtime);
    testName = "regWrRdTest";
  end else begin
    reset ();
    runTest();
    eos();
  end
end

task runTest();
  $display("%0t:Running %s ",$realtime,testName);
  if ( testName == "cpuRegWrRdTest") begin
    cpuRegWrRdTest();
  end else if ( testName == "funcRegWrRdTest") begin
    funcRegWrRdTest();
  end else if ( testName == "regPorTest") begin
    regPorTest();
  end else begin 
    $display ("%0t:No test is selected ",$realtime);
    $display ("%0t:Available tests are:",$realtime);
    $display ("%0t:   regPorTest ",$realtime);
    $display ("%0t:   cpuRegWrRdTest ",$realtime);
    $display ("%0t:   funcRegWrRdTest ",$realtime);
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
  cwrite = 1'b0;
  dg_stat_fl1_wr = 1'b0;
  dg_stat_nms_wr = 1'b0;
  dg_stat_xen_wr = 1'b0;
  dg_stat_cnt_wr = 1'b0;
  clock(20);
  rst = 1'b0;
  $display ("%0t: de-asserting reset", $realtime);
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

task regWrite (bit cpuFuncWr, bit [3:0] funcWrS, reg [BITDATA-1:0] din);
  $display("%0t: regWrite: cpuFuncWr=%0d wdata=%0x funcWrS=%0x",$realtime,cpuFuncWr,din,funcWrS);
  if ( cpuFuncWr ) begin
    cwrite = 1'b1;
    cdin = din;
    clock(1);
    wait (cwack == 1'b1);
    cwrite = 1'b0;
  end else if (funcWrS != 0) begin
    cwrite = 1'b0;
    dg_stat_fl1_wr = funcWrS[0];
    dg_stat_fl1_din = din >>  BITOFST_FL1;
    dg_stat_nms_wr = funcWrS[1];
    dg_stat_nms_din = din >> BITOFST_NMS;
    dg_stat_xen_wr = funcWrS[2];
    dg_stat_xen_din = din >> BITOFST_XEN;
    dg_stat_cnt_wr = funcWrS[3];
    dg_stat_cnt_din = din >> BITOFST_CNT;
    clock(1);
    dg_stat_fl1_wr = 1'b0;
    dg_stat_nms_wr = 1'b0;
    dg_stat_xen_wr = 1'b0;
    dg_stat_cnt_wr = 1'b0;
  end
endtask : regWrite

function reg [BITDATA-1:0] regRead (bit cpuFuncRd=1);
  if (cpuFuncRd) begin
    regRead = cdout[BITDATA-1:0];
  end else begin
    regRead = 0;
    regRead[BITDATA_FL1-1+BITOFST_FL1:0+BITOFST_FL1] = dg_stat_fl1_rdat;
    regRead[BITDATA_NMS-1+BITOFST_NMS:0+BITOFST_NMS] = dg_stat_nms_rdat;
    regRead[BITDATA_XEN-1+BITOFST_XEN:0+BITOFST_XEN] = dg_stat_xen_rdat;
    regRead[BITDATA_CNT-1+BITOFST_CNT:0+BITOFST_CNT] = dg_stat_cnt_rdat;
  end
  $display("%0t: regRead=%0x",$realtime,regRead);
endfunction : regRead

//================================================================================
// Tests
//================================================================================

task regPorTest ();
  reg [BITDATA-1:0] actData;
  reg [BITDATA-1:0] expData;

  actData = regRead(1'b1);
  expData = 0;
  if ( actData != expData ) begin 
    errCnt++;
    $display("%0t:POR val mismatch: expData=%0x actData=%0x",$realtime, expData, actData);
    eos();
  end
endtask : regPorTest 

task regWrRdTest (bit cpuFunc=1);
  reg [BITDATA-1:0] wdata=0;
  reg [BITDATA-1:0] expData=0;
  reg [BITDATA-1:0] rdata;
  reg [3:0]         funcWrS;
  
  repeat (numReqs) begin
    funcWrS = $urandom_range(1,15); 
    wdata[BITDATA_FL1-1+BITOFST_FL1:0+BITOFST_FL1] = $random();
    wdata[BITDATA_NMS-1+BITOFST_NMS:0+BITOFST_NMS] = $random();
    wdata[BITDATA_XEN-1+BITOFST_XEN:0+BITOFST_XEN] = $random();
    wdata[BITDATA_CNT-1+BITOFST_CNT:0+BITOFST_CNT] = $random();
    regWrite(cpuFunc,funcWrS,wdata);
    clock(2-FLOPODT); 
    rdata = regRead(cpuFunc);
    if (cpuFunc) begin
      expData = wdata;
    end else begin
      expData[BITDATA_FL1-1+BITOFST_FL1:0+BITOFST_FL1] = funcWrS[0] ? wdata[BITDATA_FL1-1+BITOFST_FL1:0+BITOFST_FL1] : expData[BITDATA_FL1-1+BITOFST_FL1:0+BITOFST_FL1];
      expData[BITDATA_NMS-1+BITOFST_NMS:0+BITOFST_NMS] = funcWrS[1] ? wdata[BITDATA_NMS-1+BITOFST_NMS:0+BITOFST_NMS] : expData[BITDATA_NMS-1+BITOFST_NMS:0+BITOFST_NMS];
      expData[BITDATA_XEN-1+BITOFST_XEN:0+BITOFST_XEN] = funcWrS[2] ? wdata[BITDATA_XEN-1+BITOFST_XEN:0+BITOFST_XEN] : expData[BITDATA_XEN-1+BITOFST_XEN:0+BITOFST_XEN];
      expData[BITDATA_CNT-1+BITOFST_CNT:0+BITOFST_CNT] = funcWrS[3] ? wdata[BITDATA_CNT-1+BITOFST_CNT:0+BITOFST_CNT] : expData[BITDATA_CNT-1+BITOFST_CNT:0+BITOFST_CNT];
    end
    if ( expData !== rdata ) begin 
      errCnt++;
      $display("%0t:cpuFunc=%0b reg read: rdata mismatch: expData=%0x rdata=%0x",$realtime, cpuFunc, expData, rdata);
      eos(); 
    end
  end  
endtask : regWrRdTest

task cpuRegWrRdTest ();
  regWrRdTest (1'b1);
endtask : cpuRegWrRdTest 

task funcRegWrRdTest ();
  regWrRdTest (1'b0);
endtask : funcRegWrRdTest 

endmodule : RegDgStatTb
