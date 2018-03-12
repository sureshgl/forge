//////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2010, Cisco Systems, Inc.
// All Rights Reserved.
//
// This is UNPUBLISHED PROPRIETARY SOURCE CODE of Cisco Systems, Inc;
// the contents of this file may not be disclosed to third parties, copied or
// duplicated in any form, in whole or in part, without the prior written
// permission of Cisco Systems, Inc.
//
// RESTRICTED RIGHTS LEGEND:
// Use, duplication or disclosure by the Government is subject to restrictions
// as set forth in subdivision (c)(1)(ii) of the Rights in Technical Data
// and Computer Software clause at DFARS 252.227-7013, and/or in similar or
// successor clauses in the FAR, DOD or NASA FAR Supplement. Unpublished -
// rights reserved under the Copyright Laws of the United States.
//
//////////////////////////////////////////////////////////////////////////////
//
// File          : CEP_RAMWRAP_1R1W.sv
// Author        : Greg Ries
// Description   : CEP(CPU/ELAM/Protection) RAM wrapper with read and write
//                 ports
//
// $Id: CEP_RAMWRAP_1R1W.sv,v 1.8 2014/05/27 23:43:15 bli4 Exp $
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ns
`include "DGlobal.vh"
`include "Dcm.vh"
`include "Cep.vh"
`include "log2.vh"
`include "CapWrap.vh"
`include "MemRdlCommStructs.vh"

module CEP_RAMWRAP_1R1W
#(
   parameter type RDL_TO_MEM_BUS_TYPE = struct packed { RdlToMemCpu_t cpu;
                                                        RdlToMemPar_t prot;
                                                        RdlToMemFulle_t elam;
                                                        RdlToMemCommon_t common; },
   parameter type MEM_TO_RDL_BUS_TYPE = struct packed { MemToRdlCpu_t cpu;
                                                        MemToRdlPar_t prot;
                                                        MemToRdlFulle_t elam; },
   parameter CPU                      = 1,     
   parameter PARITY                   = 1,
   parameter ECC                      = 0,
   parameter BIP                      = 0,  // Must be 0 for RAM
   parameter ELAM                     = 1,
   parameter ELAM_HAS_DOUT            = 1,
   // parameters above set on instance by macro; parameters below set on instance by user
   parameter WIDTH                    = 32,
   parameter LOGICALWIDTH             = WIDTH,
   parameter LOGICALMASK              = {WIDTH{1'b0}},
   parameter NUMWORDENABLES           = 0,
   parameter DEPTH                    = 256,
   parameter PIPELINE                 = 0,
   parameter CAP_DOUT_PIPE            = 0,
   parameter CAP_DOUT_PIPE_CLOCK_GATE = 0,
   parameter WATERMARK_SUPPORT        = 1'b0,
   parameter PARITYPIPELINE           = 0,
   parameter ELAMPIPELINE             = 0,
   parameter EARLY_CHECK_BIT_GEN      = 0,
   parameter CPU_ACC_WITH_HW_ACC      = 0,
   parameter EMUL                     = 0,
   parameter SUFFIX                   = "",
   parameter DO_NOT_WRITE_X_ON_WRITE_THROUGH = 0
) (
   //Hardware Memory Signals
   input  logic                    CLK_1X,
   input  logic                    CLK_2X,
   input  logic                    RESET_1X,
   input  logic                    SELN_R,
   input  logic                    SELN_W,    
   input  logic [log2(DEPTH)-1:0]  A_R,
   input  logic [log2(DEPTH)-1:0]  A_W,
   input  logic                    WEN,
   input  logic [LOGICALWIDTH-1:0] DIN,
   output logic [LOGICALWIDTH-1:0] DOUT,

   input  logic                    hwAtomic,
   input  logic [((NUMWORDENABLES) ? NUMWORDENABLES-1 : 0) : 0] rdSubwordEnN,
   input  logic [((NUMWORDENABLES) ? NUMWORDENABLES-1 : 0) : 0] wrSubwordEnN,

   output logic [((NUMWORDENABLES) ? NUMWORDENABLES-1 : 0) : 0] corErr,
   output logic [((NUMWORDENABLES) ? NUMWORDENABLES-1 : 0) : 0] uncErr,
   output logic                    supReqPending,

`ifdef EMULATION
   input  logic [`CAP_BUSIN_EMULEXTRAM_RANGE]  eCapBusIn,
   output logic [`CAP_BUSOUT_EMULEXTRAM_RANGE] eCapBusOut,
`endif

   // To/From RDL
   input  RDL_TO_MEM_BUS_TYPE                  rdlToMem,
   output MEM_TO_RDL_BUS_TYPE                  memToRdl
);
   
localparam ELAM_LOCAL      = ELAM & `CAP_ELAM_GLOBAL_ENABLE;
localparam CPU_LOCAL       = CPU  & `CAP_CPU_GLOBAL_ENABLE;
localparam EMUL_LOCAL      = EMUL & `CAP_EMUL_GLOBAL_ENABLE;
localparam ADDRESS_WIDTH   = log2(DEPTH);
// take CAP_DOUT_PIPE stages out of the pipeline passed to the generic
localparam GENERIC_PIPELINE   = PIPELINE - CAP_DOUT_PIPE;

`ifndef SYNTHESIS
  `ifdef CAP_ANNOUNCE
     initial $display("CAP_ANNOUNCE: %m (CAP_RAMWRAP_1R1W) [ DEPTH=%0d WIDTH=%0d LOGICALWIDTH=%0d LOGICALMASK='h%0h NUMWORDENABLES=%0d PIPELINE=%0d CPU=%0d ELAM=%0d ECC=%0d PARITY=%0d PARITYPIPELINE=%0d EMUL=%0d SUFFIX=%0s ]",
        DEPTH,WIDTH,LOGICALWIDTH,LOGICALMASK,NUMWORDENABLES,PIPELINE,CPU,ELAM,ECC,PARITY,PARITYPIPELINE,EMUL,SUFFIX);
  `endif
`endif

`MACRO_log2
`MACRO_CAP_NUMWORDENABLES
`MACRO_getCodeWidth
`MACRO_getProtWidth
`MACRO_RAM_cpuAddrWidth

localparam SUP_ADDRESS_WIDTH   = cpuAddrWidth(DEPTH);
localparam SUB_WIDTH           = (WIDTH/CAP_NUMWORDENABLES);
localparam SUB_CODE_WIDTH      = codeWidth(SUB_WIDTH, PARITY, ECC);
localparam SUB_PROT_WIDTH      = SUB_WIDTH + SUB_CODE_WIDTH;
localparam CODE_PORT_WIDTH     = (SUB_CODE_WIDTH) ? SUB_CODE_WIDTH : 1;
localparam PROT_PHYSICAL_WIDTH = SUB_PROT_WIDTH * CAP_NUMWORDENABLES;
localparam CLOCK_GATED_STAGE   = (CAP_DOUT_PIPE_CLOCK_GATE) ? 1 : 0;
localparam DOUT_MULTI_STAGES   = CAP_DOUT_PIPE - CLOCK_GATED_STAGE;
localparam PROTECTION_STAGE    = (PARITY) ? PIPELINE + PARITYPIPELINE + 2
                                          : PIPELINE + 2;
localparam SAVE_DATA_STAGES    = (PARITY || ECC || ELAM_LOCAL) ? PROTECTION_STAGE
                                                               : PROTECTION_STAGE-1;
localparam HARDWARE_READ_STAGES = PIPELINE + 1;

localparam MAX_ELAM_DATA       = `CAP_BUSOUT_ELAMDATA0_WIDTH * 15;
localparam ELAM_TOTAL_DATA     = PROT_PHYSICAL_WIDTH;
localparam ELAM_DATA_WIDTH     = (ELAM_TOTAL_DATA < MAX_ELAM_DATA) ? ELAM_TOTAL_DATA
                                                                   : MAX_ELAM_DATA;
localparam ELAM_DATA_ZEROS     = MAX_ELAM_DATA - ELAM_DATA_WIDTH;
localparam ELAM_DATA_STAGE     = (PIPELINE || PARITYPIPELINE)
                                    ? PIPELINE + PARITYPIPELINE + 1 : 2;
localparam ELAM_SYNDROME_WIDTH = (SUB_CODE_WIDTH > 0) ? SUB_CODE_WIDTH : 1;

// to support Mem Tasks until I can change them
localparam ECC_WIDTH    = codeWidth(SUB_WIDTH, 0, 1);
localparam AWIDTH       = log2(DEPTH);
localparam CAPWORD32S   = ((WIDTH%32) != 0) ? (WIDTH/32)+1 : WIDTH/32;

wire                           hwRead;
wire                           hwWrite;
wire [CAP_NUMWORDENABLES-1:0]  hwWriteSubwords;
wire [CAP_NUMWORDENABLES-1:0]  hwReadSubwords;
wire [CAP_NUMWORDENABLES-1:0]  cpuBypass0sToHwRead;
wire [CAP_NUMWORDENABLES-1:0]  delayedCpuBypass0sToHwRead;
wire [CAP_NUMWORDENABLES-1:0]  p1CpuBypass0sToHwRead;
wire                           cpuReq;
wire [ADDRESS_WIDTH-1:0]       cpuAddress;
wire                           cpuWrite;
wire [CAP_NUMWORDENABLES-1:0]  cpuSubwords;
wire [LOGICALWIDTH-1:0]        cpuUnprLogiDin;
wire                           cpuGrant;
wire                           cpuDataValid;
wire                           hwReadActive;
wire                           hwWriteActive;
wire [PROT_PHYSICAL_WIDTH-1:0] protPhysDin;
wire [PROT_PHYSICAL_WIDTH-1:0] protPhysDout;
wire [PROT_PHYSICAL_WIDTH-1:0] elamProtPhysDout;
wire                           hwReadAtGate;
wire                           captureCpuRead;
wire [CAP_NUMWORDENABLES-1:0]  captureError;
wire                           lineIsWriteType;
logic                          protOverride;
logic [CODE_PORT_WIDTH-1:0]    checkBitsIn;
logic [CAP_NUMWORDENABLES-1:0] mainUncErr;
logic [CAP_NUMWORDENABLES-1:0] mainCorErr;
logic [CAP_NUMWORDENABLES-1:0] qualUncErr;
logic [CAP_NUMWORDENABLES-1:0] qualCorErr;
logic [CODE_PORT_WIDTH*CAP_NUMWORDENABLES-1:0] syndromeOut;
wire [CAP_NUMWORDENABLES-1:0]  hwGatedParityErr;
wire [LOGICALWIDTH-1:0]        cpuCorrLogiDout;
wire [CAP_NUMWORDENABLES-1:0]  nextGatedCpuBypass0sToHwRead;
wire                           protChkDisable;
wire                           memReadSelN;
wire                           memWriteSelN;
wire [ADDRESS_WIDTH-1:0]       memReadA;
wire [ADDRESS_WIDTH-1:0]       memWriteA;
wire                           memWeN;
wire [CAP_NUMWORDENABLES-1:0]  memWriteSubwords;
wire [CAP_NUMWORDENABLES-1:0]  memReadSubwords;
reg  [PROT_PHYSICAL_WIDTH-1:0] memBeN;
wire [ADDRESS_WIDTH-1:0]       protectionReadAddr;  // address coincident with prot check
wire [ADDRESS_WIDTH-1:0]       protectionReadAddrQ; // address after flopping results of prot
wire [CAP_NUMWORDENABLES-1:0]  readValidNow;
reg  [(SAVE_DATA_STAGES+1)*CAP_NUMWORDENABLES-1:CAP_NUMWORDENABLES] readValidQ;
wire [(SAVE_DATA_STAGES+1)*CAP_NUMWORDENABLES-1:0] readValidVec;
wire [CAP_NUMWORDENABLES-1:0]  readValidAtProtection;
wire [CAP_NUMWORDENABLES-1:0]  readValidAtGate;
wire                           cpuReadNow;
reg  [SAVE_DATA_STAGES:1]      cpuReadQ;
wire [SAVE_DATA_STAGES:0]      cpuReadVec;
reg  [CAP_NUMWORDENABLES-1:0]  gatedCpuBypass0sToHwReadQ;

wire                                          dwnldActiveQ;
wire                                          dwnldSelN;
wire [ADDRESS_WIDTH-1:0]                      dwnldA;

reg                      elamQualEccCorErrQ;
reg                      elamQualEccErrQ;
reg [SUB_CODE_WIDTH-1:0] elamEccSyndromeOutQ;

reg                      elamQualParityErrQ;

reg                                           elamReadSelNQ;
reg                                           elamWriteSelNQ;
reg  [ADDRESS_WIDTH-1:0]                      writeCmdAddrQ;
wire                                          elamErr0In;
wire                                          elamCorrect0In;
wire                                          elamDataValid;
wire [`CAP_ALWAYS_PRESENT_RANGE]              elamAlwaysPresentIn;
wire [MAX_ELAM_DATA-1:0]                      elamDataIn;
wire [ELAM_SYNDROME_WIDTH-1:0]                elamSyndrome0In;
wire [ADDRESS_WIDTH-1:0]                      readCmdAddrQ;
wire [ADDRESS_WIDTH-1:0]                      readAddrQ;
wire [ADDRESS_WIDTH*6-1:0]                    elamAddrIn;

logic                                  readToElam;
logic                                  dataViewEn;
logic [3:0]                            dataViewSel;
logic [`DCM_ELAM_DATA_SLICE_WIDTH-1:0] dataView;

reg [(SAVE_DATA_STAGES+1)*ADDRESS_WIDTH-1:ADDRESS_WIDTH] addrQ;
logic                                  haltQ;
logic [`POWER_CTL_BUS_RANGE]           s0PowerCtlQ;
logic [`POWER_CTL_BUS_RANGE]           s1PowerCtlQ;

// Added by gvaidya for memory parity/ECC testing.
`ifndef SYNTHESIS

// This function needs to use PROT_PHYSICAL_WIDTH as width
// instead of WIDTH since one should be able to corrupt 
// even the parity/ECC bits.
// Also if CAP_NUMWORDENABLES > 1, each subword needs to be corrupted.
   function [PROT_PHYSICAL_WIDTH-1:0] genError;
        
      input [PROT_PHYSICAL_WIDTH-1:0] memWord;
      input integer     numBitFlips;
      
      integer           i, wordNum, randNum;
      reg               tempBit;
      reg [SUB_PROT_WIDTH-1:0] tempGenError;
      
      begin
         if (numBitFlips > SUB_PROT_WIDTH) begin
            $display("DOPPLER_FAULT_INJECTION_TEST_ERROR: numBitFlips > SUB_PROT_WIDTH in call to genError() in %m");
            $finish;
         end
         else if (numBitFlips === 0) begin
            $display("DOPPLER_FAULT_INJECTION_TEST_ERROR: numBitFlips === 0 in call to genError() in %m");
            $finish;
         end
         genError = 0;
         // Perform corruption for each subWord
         for (wordNum = CAP_NUMWORDENABLES; wordNum > 0; wordNum = wordNum - 1) begin
            // Create a vector with 1's in random places
            tempGenError = 'b1;
            tempGenError = (tempGenError << numBitFlips) - 1;
            // tempGenError[numBitFlips-1:0] = ~tempGenError[numBitFlips-1:0]; // Doesn't work
            for (i = 0; i < numBitFlips; i = i + 1) begin
               randNum           = i + ({$random} % (SUB_PROT_WIDTH - i));
               tempBit           = tempGenError[randNum];
               tempGenError[randNum] = tempGenError[i];
               tempGenError[i]       = tempBit;
            end
            genError = genError | tempGenError;
            genError = genError << ((wordNum - 1) * SUB_PROT_WIDTH);
         end
         // Corrupt the memWord with the generated vector
         genError = memWord ^ genError;
      end
   endfunction

   // This will be set by an external backdoor-access-like process.
   reg     createError       = 1'b0;
   reg     createErrorSticky = 1'b0;
   wire    createErrorValid;
   integer numBitFlipsGlobal;
   integer createErrorDelay0 = 1'b0;
   integer createErrorDelay1 = 1'b0;
   integer i;

   wire [PROT_PHYSICAL_WIDTH-1:0] protPhysDoutTemp;
   reg                            createErrorPipe[0:GENERIC_PIPELINE];

   initial begin
      $value$plusargs("CORRUPT_RTL_STICKY=%d", createErrorSticky);
      case (createErrorSticky)
         0: createErrorSticky = 1'b0;
         1: createErrorSticky = 1'b1;
         default: createErrorSticky = 1'b0;
      endcase
   end

   assign createErrorValid = createErrorPipe[0];

   always @(posedge CLK_1X)
     begin
        for (i = 0; i < GENERIC_PIPELINE; i = i + 1)
          begin
             createErrorPipe[i] <= createErrorPipe[i + 1];
          end        
        if (memReadSelN === 1'b0)
          begin
             if (createError === 1'b1)
 		       begin
                  if (createErrorDelay0 === 0) begin
                     if (!createErrorSticky) begin
                        createError <= 1'b0;
                     end
                     createErrorPipe[GENERIC_PIPELINE] <= 1'b1;
                  end
	              else begin
                     createErrorDelay0 = createErrorDelay0 - 1;
                  end
               end
             else
               begin
                  createErrorPipe[GENERIC_PIPELINE] <= 1'b0;                  
               end
          end // if (memReadSelN === 1'b0)
        else
          begin
             createErrorPipe[GENERIC_PIPELINE] <= 1'b0;                  
          end
        if (createErrorValid === 1'b1)
          begin
             $display("DOPPLER_FAULT_INJECTION_TEST - Flipping %0d bits at address 0x%0h",
                      numBitFlipsGlobal, memReadA);
          end
     end // always @ (posedge CLK_1X)
   
   assign protPhysDoutTemp = (createErrorValid === 1'b1) ? genError(protPhysDout, numBitFlipsGlobal) :
                             protPhysDout;

  // This task can be called to arm the memory error injection mechanism
  // Added to inject errors into memories that aren't in the RDL memory map
  // Other memories can be corrupted using the DIM error injection mechanism 
  task memCorrupt;
     input integer numBitFlipsInput;
     input integer createErrorDelayInput;
     begin
         createError <= 1'b1;
         numBitFlipsGlobal <= numBitFlipsInput;
         createErrorDelay0 <= createErrorDelayInput;
     end
   endtask

`endif

// Let the outside world know when the cpu is active
assign supReqPending = cpuReq;

assign {hwReadSubwords, hwWriteSubwords} =
          (NUMWORDENABLES <= 1) ? {1'b1, 1'b1}
                                : {~rdSubwordEnN, ~wrSubwordEnN};

// Hardware is inactive under halt.
// If hardware's priority is overridden, hw CANNOT be active is cpu is
// requesting; otherwise, hardware is active if SELN asserted;
assign hwReadActive  = ~haltQ & (hwAtomic | ~SELN_R);
assign hwWriteActive = ~haltQ & (hwAtomic | ~SELN_W);

generate
   if (CPU_ACC_WITH_HW_ACC)
   begin
      assign cpuGrant = cpuReq & ~dwnldActiveQ &
                        (haltQ | ~hwAtomic & ( SELN_R |  cpuWrite & (A_R != cpuAddress) ) &
                                             ( SELN_W | ~cpuWrite & (A_W != cpuAddress) )
                        );
   end else begin
      assign cpuGrant = cpuReq & ~dwnldActiveQ & (haltQ | ~hwAtomic & SELN_R & SELN_W);
   end
endgenerate

// change the control ports based on hwActive; DIN handled by DinPath
assign memReadSelN  = (dwnldActiveQ) ? dwnldSelN :
                      (hwReadActive) ? SELN_R
                                     : ~(cpuGrant & ~cpuWrite);

assign memWriteSelN = (hwWriteActive) ? SELN_W
                                      : ~(cpuGrant & cpuWrite);

assign memReadA     = (dwnldActiveQ) ? dwnldA :
                      (hwReadActive) ? A_R
                                     : cpuAddress;

assign memWriteA    = (hwWriteActive) ? A_W
                                      : cpuAddress;

assign memWeN       = (hwWriteActive) ? WEN
                                      : ~cpuWrite;

assign memWriteSubwords = (hwWriteActive) ? hwWriteSubwords
                                          : cpuSubwords;

assign memReadSubwords  = (dwnldActiveQ) ? '1 :
                          (hwReadActive) ? hwReadSubwords
                                         : '1;

integer wordI;
always_comb
begin
   for (wordI = 0; wordI < CAP_NUMWORDENABLES; wordI = wordI + 1)
   begin
      memBeN[SUB_PROT_WIDTH*wordI +: SUB_PROT_WIDTH] = {SUB_PROT_WIDTH {~memWriteSubwords[wordI]}};
   end
end

// stage read valid until protection stage
// using vectors let's us select the approprate stage, with
// latency == vector index
always_ff @(posedge CLK_1X)
begin
   readValidQ <= RESET_1X ? {(SAVE_DATA_STAGES * CAP_NUMWORDENABLES) {1'b0}}
                          : readValidVec[SAVE_DATA_STAGES*CAP_NUMWORDENABLES-1:0];

   cpuReadQ   <= cpuReadVec[SAVE_DATA_STAGES-1:0];

   gatedCpuBypass0sToHwReadQ <= nextGatedCpuBypass0sToHwRead;

   haltQ <= rdlToMem.common.halt;

   s0PowerCtlQ <= rdlToMem.common.powerCtl;
   s1PowerCtlQ <= s0PowerCtlQ;
end

assign readValidNow = {CAP_NUMWORDENABLES {~memReadSelN}} & memReadSubwords;
assign cpuReadNow   = cpuReq & ~cpuWrite & cpuGrant;
assign readValidVec = {readValidQ, readValidNow};
assign cpuReadVec   = {cpuReadQ, cpuReadNow};

// get valid read subwords at PROTECTION_STAGE-1 stage
assign readValidAtProtection = readValidVec[PROTECTION_STAGE*CAP_NUMWORDENABLES-1 -:
                                            CAP_NUMWORDENABLES];

assign cpuDataValid = (|readValidAtProtection) & cpuReadVec[PROTECTION_STAGE-1];

// get valid read subwords at HARDWARE_READ_STAGES-1 stage
assign readValidAtGate = readValidVec[HARDWARE_READ_STAGES*CAP_NUMWORDENABLES-1 -:
                                      CAP_NUMWORDENABLES];

assign hwReadAtGate = (|readValidAtGate) & ~cpuReadVec[HARDWARE_READ_STAGES-1];

// pipe the bypass signal to HARDWARE_READ_STAGES-1 stage, then there is
// one more flop before use
CapMultiSync
#(
   .WIDTH  (CAP_NUMWORDENABLES),
   .stages (HARDWARE_READ_STAGES-1)
) MultiSyncBypass (
   .clk     (CLK_1X),
   .reset   (1'b0),  // don't need reset here
   .dataIn  (cpuBypass0sToHwRead),
   .dataOut (delayedCpuBypass0sToHwRead)
);

CepDinPath
#(
   .LOGICALWIDTH        (LOGICALWIDTH),
   .LOGICALMASK         (LOGICALMASK),
   .UNPR_PHYSICAL_WIDTH (WIDTH),
   .PROT_PHYSICAL_WIDTH (PROT_PHYSICAL_WIDTH),
   .CODE_PORT_WIDTH     (CODE_PORT_WIDTH),
   .CAP_NUMWORDENABLES  (CAP_NUMWORDENABLES),
   .EARLY_CHECK_BIT_GEN (EARLY_CHECK_BIT_GEN),
   .NO_HARDWARE_WRITES  (0),
   .PARITY              (PARITY),
   .ECC                 (ECC)
) DinPath (
   .hwUnprLogiDin       (DIN),
   .cpuUnprLogiDin      (cpuUnprLogiDin),
   .hwActive            (hwWriteActive),
   .protPhysDin         (protPhysDin),
   .protOverride        (protOverride),
   .checkBitsIn         (checkBitsIn)
);

CepDoutPath
#(
   .LOGICALWIDTH             (LOGICALWIDTH),
   .LOGICALMASK              (LOGICALMASK),
   .UNPR_PHYSICAL_WIDTH      (WIDTH),
   .PROT_PHYSICAL_WIDTH      (PROT_PHYSICAL_WIDTH),
   .CODE_PORT_WIDTH          (CODE_PORT_WIDTH),
   .CAP_NUMWORDENABLES       (CAP_NUMWORDENABLES),
   .PARITY                   (PARITY),
   .ECC                      (ECC),
   .PIPELINE                 (PIPELINE),
   .PARITYPIPELINE           (PARITYPIPELINE),
   .CAP_DOUT_PIPE            (CAP_DOUT_PIPE),
   .CAP_DOUT_PIPE_CLOCK_GATE (CAP_DOUT_PIPE_CLOCK_GATE)
) DoutPath (
   .sysClk                     (CLK_1X),
`ifndef SYNTHESIS // Added by gvaidya for memory parity/ECC testing.
   .protPhysDout               (protPhysDoutTemp),
`else
   .protPhysDout               (protPhysDout),
`endif
   .hwReadAtGate               (hwReadAtGate),
   .gatedCpuBypass0sToHwRead   (gatedCpuBypass0sToHwReadQ),
   .parityPipeReadValid        (|readValidVec[(PIPELINE+1-CAP_DOUT_PIPE_CLOCK_GATE)
                                              *CAP_NUMWORDENABLES +: CAP_NUMWORDENABLES]),
   .hwCorrLogiDout             (DOUT),
   .hwGatedParityErr           (hwGatedParityErr),
   .cpuCorrLogiDout            (cpuCorrLogiDout),
   .elamProtPhysDout           (elamProtPhysDout),
   .protChkDisable             (protChkDisable),
   .syndromeOut                (syndromeOut),
   .corErr                     (mainCorErr),
   .uncErr                     (mainUncErr)
);

assign qualCorErr = mainCorErr & readValidAtProtection;
assign qualUncErr = mainUncErr & readValidAtProtection;
                       
assign captureCpuRead = cpuReadVec[PROTECTION_STAGE-1] & protOverride;

assign captureError = (captureCpuRead & lineIsWriteType) ? '0 :
                      (captureCpuRead)                   ? '1 
                                                         : (mainCorErr | mainUncErr);

generate
   if (CAP_DOUT_PIPE_CLOCK_GATE)
   begin
      assign nextGatedCpuBypass0sToHwRead =
                ( (|readValidAtGate) & ~cpuReadVec[HARDWARE_READ_STAGES-1] )
                   ? delayedCpuBypass0sToHwRead : gatedCpuBypass0sToHwReadQ;
   end else begin
      assign nextGatedCpuBypass0sToHwRead = delayedCpuBypass0sToHwRead;
   end

   if (CPU_LOCAL) begin
      assign hwRead  = hwReadActive & ~SELN_R;
      assign hwWrite = hwWriteActive & ~SELN_W & ~WEN;

      CepTransactor
      #(
         .LOGICALWIDTH        (LOGICALWIDTH),
         .LOGICALMASK         (LOGICALMASK),
         .UNPR_PHYSICAL_WIDTH (WIDTH),
         .CAP_NUMWORDENABLES  (CAP_NUMWORDENABLES),
         .DEPTH               (DEPTH),
         .WRITE_IN_READ_CLOCK (1'b1),
         .TWO_BYPASS_SUPPORT  (0),
         .WATERMARK_SUPPORT   (WATERMARK_SUPPORT)
      ) Transactor (
         .sysClk              (CLK_1X),
         .sysReset            (RESET_1X),
         .supEnable           (1'b1),
         .rdlToMemCpu         (rdlToMem.cpu),
         .memToRdlCpu         (memToRdl.cpu),
         .hwRead              (hwRead),
         .hwWrite             (hwWrite),
         .hwReadAddress       (A_R),
         .hwWriteAddress      (A_W),
         .hwSubwords          (hwWriteSubwords),
         .hwUnprLogiDin       (DIN),
         .p1HwRead            (1'b0),
         .p1HwWrite           (1'b0),
         .p1HwReadAddress     ({ADDRESS_WIDTH {1'b0}}),
         .p1HwWriteAddress    ({ADDRESS_WIDTH {1'b0}}),
         .p1HwSubwords        ({CAP_NUMWORDENABLES {1'b0}}),
         .p1HwUnprLogiDin     ({LOGICALWIDTH {1'b0}}),
         .p1CpuBypass0sToHwRead(p1CpuBypass0sToHwRead),
         .cpuBypass0sToHwRead (cpuBypass0sToHwRead),
         .cpuReq              (cpuReq),
         .cpuAddress          (cpuAddress),
         .cpuWrite            (cpuWrite),
         .cpuSubwords         (cpuSubwords),
         .cpuUnprLogiDin      (cpuUnprLogiDin),
         .lineIsWriteType     (lineIsWriteType),
         .cpuGrant            (cpuGrant),
         .cpuDataValid        (cpuDataValid),
         .cpuCorrLogiDout     (cpuCorrLogiDout)
      );
   end else begin
      // ground all signals that would have been outputs of the missing
      // transactor
      assign cpuBypass0sToHwRead = '0;
      assign cpuReq = 1'b0;
      assign cpuAddress = '0;
      assign cpuWrite = 1'b0;
      assign cpuSubwords = '0;
      assign cpuUnprLogiDin = '0;
      assign lineIsWriteType = 1'b0;
   end

   // According to V2005, we must name the generate scopes in order
   // to reach them via XMR.  When needed, use direct nesting (V2005 12.4.2)
   // to create consistent scope names/levels without adding spurious levels.
   // The result path to generic wrapper instance should be gen.GenericMem
   // to make it easier for backdoor task generation.

   if (EMUL_LOCAL == 0 ) // single item in this scope; purposely no begin/end

      if (NUMWORDENABLES <= 1) begin : gen
         RAMWRAP_1R1W_FULL 
         #(
            .width    (PROT_PHYSICAL_WIDTH), 
            .depth    (DEPTH),
            .PIPELINE (GENERIC_PIPELINE),
            .SUFFIX   (SUFFIX),
            .DO_NOT_WRITE_X_ON_WRITE_THROUGH (DO_NOT_WRITE_X_ON_WRITE_THROUGH)
         ) GenericMem (
            .CLK_1X    (CLK_1X),
            .CLK_2X    (CLK_2X),
            .POWER_CTL (s1PowerCtlQ),
            .SELN_R    (memReadSelN),
            .SELN_W    (memWriteSelN),       
            .A_R       (memReadA),
            .A_W       (memWriteA),       
            .WEN       (memWeN),
            .DIN       (protPhysDin),
            .DOUT      (protPhysDout)
         );
      end else begin : gen
         RAMWRAP_1R1W_BIT 
         #(
            .width    (PROT_PHYSICAL_WIDTH), 
            .depth    (DEPTH),
            .PIPELINE (GENERIC_PIPELINE),
            .SUFFIX   (SUFFIX),
            .DO_NOT_WRITE_X_ON_WRITE_THROUGH (DO_NOT_WRITE_X_ON_WRITE_THROUGH)
         ) GenericMem (
            .CLK_1X    (CLK_1X),
            .CLK_2X    (CLK_2X),
            .POWER_CTL (s1PowerCtlQ),
            .SELN_R    (memReadSelN),
            .SELN_W    (memWriteSelN),       
            .A_R       (memReadA),
            .A_W       (memWriteA),       
            .WEN       (memWeN),
            .BEN       (memBeN),
            .DIN       (protPhysDin),
            .DOUT      (protPhysDout)
         );
      end

`ifdef EMULATION

   else begin : gen // if (EMUL_LOCAL == 1)
      EMUL_RAMWRAP_1R1W
      #(
         .DEPTH         (DEPTH),
         .WIDTH         (PROT_PHYSICAL_WIDTH), 
         .PIPELINE      (GENERIC_PIPELINE),
         .NUMWORDENABLES(NUMWORDENABLES ),
         .DO_NOT_WRITE_X_ON_WRITE_THROUGH (DO_NOT_WRITE_X_ON_WRITE_THROUGH)
      ) GenericMem (
         .CLK        (CLK_1X),
         .SELN_R     (memReadSelN),
         .SELN_W     (memWriteSelN),
         .A_R        (memReadA),
         .A_W        (memWriteA),
         .WEN        (memWeN),
         .WORDEN     (~memWriteSubwords),
         .DIN        (protPhysDin),
         .DOUT       (protPhysDout),
         .eCapBusIn  (eCapBusIn),
         .eCapBusOut (eCapBusOut)
      );

   end // if (EMUL_LOCAL == 1)

   if (EMUL_LOCAL == 0) assign eCapBusOut = '0;

`endif
      
   if (ELAM_LOCAL || ECC || PARITY)
   begin
      // stage address until matches protection
      if (SAVE_DATA_STAGES > 1)
      begin
         always_ff @(posedge CLK_1X)
         begin
            addrQ <= {addrQ[SAVE_DATA_STAGES*ADDRESS_WIDTH-1:ADDRESS_WIDTH],
                      memReadA};
         end
      end else begin
         always_ff @(posedge CLK_1X)
         begin
            addrQ <= memReadA;
         end
      end

      // address matching protection check
      if (PROTECTION_STAGE > 1)
      begin
         assign protectionReadAddr = addrQ[PROTECTION_STAGE*ADDRESS_WIDTH-1 -: ADDRESS_WIDTH];
      end else begin
         assign protectionReadAddr = memReadA;
      end

      assign protectionReadAddrQ = addrQ[SAVE_DATA_STAGES*ADDRESS_WIDTH +: ADDRESS_WIDTH];

   end else begin
      assign protectionReadAddr  = '0;
      assign protectionReadAddrQ = '0;
   end

   if (PARITY || ECC)
   begin
      assign protOverride = rdlToMem.prot.protOverride;
      assign memToRdl.prot.captureEn = |(readValidAtProtection & captureError);
      assign memToRdl.prot.protErrAddress = { {( $bits(memToRdl.prot.protErrAddress) -
                                                 ADDRESS_WIDTH ) {1'b0}}, protectionReadAddr };

`ifdef DOPPLER_PROTECTION_CHECK_DISABLE
      assign protChkDisable = 1'b1;
`else
      assign protChkDisable = rdlToMem.prot.protChkDisable;
`endif
   end else begin
      assign protOverride = 1'b0;
      assign corErr = '0;
      assign uncErr = '0;
   end

   if (PARITY)
   begin
      assign checkBitsIn  = rdlToMem.prot.parIn;
      assign memToRdl.prot.parErr = |qualUncErr;
      assign memToRdl.prot.parOut = syndromeOut[0];
      assign corErr = '0;
      assign uncErr = (CAP_DOUT_PIPE && CAP_DOUT_PIPE_CLOCK_GATE) ? hwGatedParityErr
                                                                  : qualUncErr;
   end else if (ECC) begin
      assign checkBitsIn  = rdlToMem.prot.eccIn[SUB_CODE_WIDTH-1:0];
      assign memToRdl.prot.uncErr = |qualUncErr;
      assign memToRdl.prot.corErr = |qualCorErr;
      assign memToRdl.prot.syndrome = { {($bits(memToRdl.prot.syndrome)-SUB_CODE_WIDTH){1'b0}},
                                        syndromeOut[SUB_CODE_WIDTH-1:0] };
      assign corErr = qualCorErr;
      assign uncErr = qualUncErr;
   end // if (ECC)

   if (ELAM_LOCAL)
   begin
      always_ff @(posedge CLK_1X)
      begin
         elamReadSelNQ  <= memReadSelN;
         elamWriteSelNQ <= memWriteSelN | memWeN;
         writeCmdAddrQ  <= (~memWriteSelN & ~memWeN | (ADDRESS_WIDTH < 8)) ? memWriteA
                                                                           : writeCmdAddrQ;
      end

      assign readCmdAddrQ  = addrQ[ADDRESS_WIDTH+:ADDRESS_WIDTH];
      assign readAddrQ     = addrQ[ELAM_DATA_STAGE*ADDRESS_WIDTH+:ADDRESS_WIDTH];

      assign elamDataValid = |readValidVec[ELAM_DATA_STAGE*CAP_NUMWORDENABLES+:
                                           CAP_NUMWORDENABLES];

      assign elamAlwaysPresentIn = {elamReadSelNQ, elamWriteSelNQ, elamDataValid};

      if (PARITY)
      begin
         always_ff @(posedge CLK_1X)
         begin
            elamQualParityErrQ <= |qualUncErr;
         end

         assign elamSyndrome0In = elamProtPhysDout[PROT_PHYSICAL_WIDTH-1];
         assign elamErr0In      = elamQualParityErrQ;
         assign elamCorrect0In  = 1'b0;
         assign elamAddrIn = { {(ADDRESS_WIDTH*2) {1'b0}}, writeCmdAddrQ,
                               protectionReadAddrQ, readAddrQ, readCmdAddrQ};

      end else if (ECC) begin
         always_ff @(posedge CLK_1X)
         begin
            elamQualEccCorErrQ  <= |qualCorErr;
            elamQualEccErrQ     <= |(qualCorErr | qualUncErr);
            elamEccSyndromeOutQ <= ((|readValidAtProtection) | (SUB_CODE_WIDTH < 8))
                                      ? syndromeOut[SUB_CODE_WIDTH-1:0]
                                      : elamEccSyndromeOutQ;
         end

         assign elamSyndrome0In = elamEccSyndromeOutQ;
         assign elamErr0In      = elamQualEccErrQ;
         assign elamCorrect0In  = elamQualEccCorErrQ;
         assign elamAddrIn = { {(ADDRESS_WIDTH*2) {1'b0}}, writeCmdAddrQ,
                               protectionReadAddrQ, readAddrQ, readCmdAddrQ};

      end else begin
         assign elamSyndrome0In = 1'b0;
         assign elamErr0In      = 1'b0;
         assign elamCorrect0In  = 1'b0;
         assign elamAddrIn = { {(ADDRESS_WIDTH*2) {1'b0}}, writeCmdAddrQ,
                               {ADDRESS_WIDTH {1'b0}}, readAddrQ, readCmdAddrQ };
      end

      if (ELAM_TOTAL_DATA > ELAM_DATA_WIDTH)
      begin
         assign elamDataIn = elamProtPhysDout[ELAM_DATA_WIDTH-1:0];
      end else begin
         assign elamDataIn = { {ELAM_DATA_ZEROS {1'b0}}, elamProtPhysDout };
      end

      if (ELAM_HAS_DOUT)
      begin
         assign readToElam  = rdlToMem.elam.read;
         assign dataViewEn  = rdlToMem.elam.dataViewEn;
         assign dataViewSel = rdlToMem.elam.dataViewSel;
         assign memToRdl.elam.dataView = dataView;
      end else begin
         assign readToElam = 1'b0;
         assign dataViewEn  = 1'b0;
         assign dataViewSel = '0;
      end

      CepElamMux
      #(
         .ELAMPIPELINE    (ELAMPIPELINE),
         .ELAM_HAS_DOUT   (ELAM_HAS_DOUT),
         .ADDRESS_WIDTH   (ADDRESS_WIDTH),
         .SYNDROME_WIDTH  (ELAM_SYNDROME_WIDTH),
         .EXTRA_CTL_WIDTH (1)
      ) ElamMux (
         .sysClk              (CLK_1X),
         .sysReset            (RESET_1X),

         .elamDataIn          (elamDataIn),
         .elamAddrIn          (elamAddrIn),
         .elamAlwaysPresentIn (elamAlwaysPresentIn),
         .elamExtraCtlIn      (1'b0),
         .elamSyndrome0In     (elamSyndrome0In),
         .elamErr0In          (elamErr0In),
         .elamCorrect0In      (elamCorrect0In),
         .elamSyndrome1In     ({ELAM_SYNDROME_WIDTH {1'b0}}),
         .elamErr1In          (1'b0),
         .elamCorrect1In      (1'b0),

         .elamViewEnable0    (dataViewEn),
         .elamSel0           (dataViewSel),
         .elamCtlViewEnable0 (rdlToMem.elam.ctlViewEn[0]),
         .elamCtlSel0        (rdlToMem.elam.ctlViewSel[0]),
         .elamCtlViewEnable1 (rdlToMem.elam.ctlViewEn[1]),
         .elamCtlSel1        (rdlToMem.elam.ctlViewSel[1]),

         .elamData0       (dataView),
         .elamControl0    (memToRdl.elam.ctlView[0]),
         .elamControl1    (memToRdl.elam.ctlView[1])
      );

      CapNewElamDownload
      #(
         .ADDRESS_WIDTH   (ADDRESS_WIDTH),
         .DEPTH           (DEPTH),
         .PROT_PHYS_WIDTH (PROT_PHYSICAL_WIDTH)
      ) ElamDownload (
         .CLK             (CLK_1X),
         .sysReset        (RESET_1X),

         .readToElam      (readToElam),
         .sysHalt         (haltQ),

         .dwnldActiveQ    (dwnldActiveQ),

         .dwnldSelN       (dwnldSelN),
         .dwnldCsN        (),
         .dwnldWeN        (),
         .dwnldA          (dwnldA),
         .dwnldReN        ()
      );

   end else begin // if (ELAM_LOCAL)
      assign dwnldActiveQ = 1'b0;
      assign dwnldSelN      = 1'b1;
      assign dwnldA         = {ADDRESS_WIDTH {1'b0}};
   end

`ifndef SYNTHESIS
   if (BIP)
   begin
      initial
      begin
         $display("VCS_ERROR: %m BIP must be 0 for RAMs.");
         #0 $finish;
      end
   end

   if (PARITYPIPELINE && !PARITY)
   begin
      initial
      begin
         $display("VCS_ERROR: %m PARITYPIPELINE may only be set along with PARITY.");
         #0 $finish;
      end
   end

   if (CAP_DOUT_PIPE > PIPELINE)
   begin
      initial
      begin
         $display("VCS_ERROR: %m CAP_DOUT_PIPE must not be greater than PIPELINE.");
         #0 $finish;
      end
   end

   if (CAP_DOUT_PIPE_CLOCK_GATE && !CAP_DOUT_PIPE)
   begin
      initial
      begin
         $display("VCS_ERROR: %m CAP_DOUT_PIPE must be set along with CAP_DOUT_PIPE_CLOCK_GATE.");
         #0 $finish;
      end
   end
`endif

endgenerate

`include "CapMemTasksInline.vh"

endmodule // CEP_RAMWRAP_1R1W

