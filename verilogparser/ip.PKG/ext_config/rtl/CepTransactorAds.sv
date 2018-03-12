//////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2008, Cisco Systems, Inc.
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
// File          : CepTransactorAds.sv
// Author        : Andrew Robbins, adapated from CapTransactor.v by Greg Ries
//                 (I added a variable number of write and read ports)
//
// Description   : This module acts as a middle agent between a cap
//                 bus and and a memory (or other module that has
//                 a memory-like interface).  This module supports all the
//                 transactions on the Cap bus, including reads and writes of
//                 size 1 to 64 32b words.  It collects data bursts from
//                 the Cap bus so as to do full-width memory operations
//                 whenever possible.  It also maintains a cache line that
//                 can hold one memory entry, and the cache line is used to
//                 do read-modify-write operations to subwords (or for
//                 read-clear).
//
//                 This agent supports the following concepts:
//                 1) writeTrans<signal> : one write
//                 transaction from the sup of size (1..64) 32b words.
//                 There may be multiple requests from sup during one
//                 transaction and multiple responses to sup.  The
//                 important thing is that it is still the SAME transaction
//                 as long as the totalSize given by sup for the first
//                 request hasn't been completed or timed out.
//                 2) line<signal> : during a trans, the activities, requests,
//                 and responses made for one line (one entry) in the
//                 memory.  In general, there may be one or two requests
//                 and roughly totalSize/64b responses before a transLine
//                 is done.  TransLine helps keep track of what the agent
//                 is doing to this particular line right now, as opposed
//                 to what is happening in the long-term trans.
//
//                 This agent does the following sorts of activities to
//                 a line:
//                 1) READ       : Read             : a sup read of all or part of one line
//                 2) FULLWRITE  : FullWrite        : a sup write of one entire line
//                 3) MERGEWRITE : Read-Merge-Write : a sup write of a partial line
//                 4) READCLEAR  : Read-Clear-Write : a sup read+write of one entire line
//                 A single sup transaction can string together multiple of
//                 the above, such as MERGEWRITE, FULLWRITE to start
//                 writing in the middle of a line but write all the way to
//                 the end of the next line.
//
//                 There is bypassing between this agent and hardware
//                 reads or writes as follows:
//                 1) If hardware reads in the middle of a sup
//                 read-clear-write, then all 0's are bypassed to the
//                 hardware read.
//                 2) If hardware writes in the middle of a sup
//                 read-clear-write, then sup write is squashed for the
//                 subwords written by hardware.
//                 3) If hardware writes in the middle of a sup
//                 read-merge-write, then hardware write data for the
//                 subwords written by hardware is merged into the cache
//                 line for bits NOT being written by sup.
//
//                 For the WRITE_IN_READ_CLOCK parameter, set it if the cpu
//                 needs to bypass hw write data to a cpu read in the same
//                 clock.  Clear it if the case cannot come up OR if the
//                 memory already makes the write data available (such as
//                 may be the case from a synchronous write to an
//                 asynchronous read).
//
//                 There is no READ_IN_READ_CLOCK because if hardware CAN
//                 read at the same time cpu reads, hardware should assert
//                 the atomic flag if it also plans to write back.
//////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ns
`include "Cep.vh"
`include "log2.vh"
`include "CapWrap.vh"
`include "MemRdlCommStructs.vh"

module CepTransactorAds
#(
   parameter LOGICALWIDTH        = 32,
   parameter LOGICALMASK         = 32'd0,
   parameter UNPR_PHYSICAL_WIDTH = 32,
   parameter CAP_NUMWORDENABLES  = 1,
   parameter DEPTH               = 256,
   parameter WRITE_IN_READ_CLOCK = 1'b0,
   parameter WATERMARK_SUPPORT   = 1'b0,
   parameter NUM_HW_READS        = 1,
   parameter NUM_HW_WRITES       = 1
) (
   input  wire                                       sysClk,
   input  wire                                       sysReset,

   // Just take in the needed fields from CAP BUS so that other modules can
   // drive other fields.
   input  wire                                       supEnable,
   input  wire                                       supTimeout,
   input  wire                                       supRead,
   input  wire                                       supWrite,
   input  wire [`CEP_ADDR_RANGE]                     supAddress,
   input  wire [`CEP_TRANS_SIZE_RANGE]               supTotalSize,
   input  wire [63:0]                                supWriteData,

   output wire                                       supAccessComplete,
   output wire                                       supReadDataValid,
   output wire [63:0]                                supReadData,
   output wire [`CEP_TRANS_SIZE_RANGE]               supAccessSize,

   // ADS wrapper can have N reads by M writes, so all the read and write
   // signals from CapTransactor are put into a vector of parameterizable size.
   input  wire [NUM_HW_READS-1:0]                           hwRead,
   input  wire [NUM_HW_READS-1:0][log2(DEPTH)-1:0]          hwReadAddress,
   output reg  [NUM_HW_READS-1:0][CAP_NUMWORDENABLES-1:0]   cpuBypass0sToHwRead,

   input  wire [NUM_HW_WRITES-1:0]                          hwWrite,
   input  wire [NUM_HW_WRITES-1:0][log2(DEPTH)-1:0]         hwWriteAddress,
   input  logic [NUM_HW_WRITES-1:0][CAP_NUMWORDENABLES-1:0] hwSubwords,
   input  wire [NUM_HW_WRITES-1:0][LOGICALWIDTH-1:0]        hwUnprLogiDin,



   // generic memory interface
   // cpuReq stays high until cpuGrant is asserted to indicate request was
   // accepted.  if cpuWrite is high, it's a write, else it's a read.
   // cpuSubwords is only needed if (CAP_NUMWORDENABLES > 1)--then it
   // indicates which subwords are being read/written.  Din and Dout are
   // both in logical format.  Assert cpuDataValid for one cycle when read
   // data is being returned, and put the read data on the cpuCorrLogiDout
   // bus.
   output wire                                       cpuReq,
   output wire [log2(DEPTH)-1:0]                     cpuAddress,
   output wire                                       cpuWrite,
   output logic [CAP_NUMWORDENABLES-1:0]             cpuSubwords,
   output wire [LOGICALWIDTH-1:0]                    cpuUnprLogiDin,

   // This signal is used to prevent reporting syndrome capture when
   // protoverride is set, but the cpu is writing (in R-M-W), not reading
   output wire                                       lineIsWriteType,

   input  wire                                       cpuGrant,
   input  wire                                       cpuDataValid,
   input  wire [LOGICALWIDTH-1:0]                    cpuCorrLogiDout
);

`MACRO_log2
`MACRO_getCodeWidth

localparam ELEMENT_WIDTH        = 32;
localparam SUB_WIDTH            = (UNPR_PHYSICAL_WIDTH/CAP_NUMWORDENABLES);
localparam ADDRESS_WIDTH        = log2(DEPTH);
localparam WORD32_NUM           = ((LOGICALWIDTH%32) != 0) ? (LOGICALWIDTH / 32) +1
                                                           : LOGICALWIDTH / 32;
localparam WORD32_ADDR_WIDTH    = log2(WORD32_NUM);
localparam EXT_ADDRESS_WIDTH    = (WORD32_NUM > 1) ? ADDRESS_WIDTH + WORD32_ADDR_WIDTH
                                                   : ADDRESS_WIDTH;
localparam ELEMENTS_PER_SUBWORD = WORD32_NUM / CAP_NUMWORDENABLES;

//
// Wires
//

logic   [NUM_HW_READS-1:0]                  hwReadAddressMatch;
logic   [NUM_HW_WRITES-1:0]                 hwWriteAddressMatch;
logic   [NUM_HW_WRITES-1:0]                 hwBypassIntoCache;
logic   [NUM_HW_WRITES-1:0][WORD32_NUM-1:0] hwSel;

wire [WORD32_NUM*32-1:0]                 optMask; // help synth eat flops
wire                                     supTotalSize1;
wire                                     supTotalSize2;
wire                                     supTotalSize1Or2;
wire                                     lastWriteResponse;
wire                                     fullLine;
wire                                     supTotalSizeGe2;
wire                                     write64;
wire [WORD32_NUM*32-1:0]                 cacheLineShifted;
wire [`CEP_TRANS_SIZE_RANGE]             readResponseAccessSize;
wire                                     vulnerableReadIssue;
wire                                     supAddressIsLastLine;

wire [NUM_HW_WRITES-1:0][WORD32_NUM*32-1:0]  extHwUnprLogiDin;
wire [WORD32_NUM*32-1:0]                 extCpuCorrLogiDout;

wire [WORD32_NUM-1:0]                    cpuSel;
wire [WORD32_NUM-1:0]                    supWord32SelVecWire;
reg  [WORD32_NUM-1:0]                    supWord32SelVec;
wire [WORD32_NUM-1:0]                    supHiSel;
wire [WORD32_NUM-1:0]                    supLoSel;
logic [NUM_HW_WRITES-1:0][WORD32_NUM-1:0] hwWriteElements;
reg  [WORD32_NUM-1:0]                    cpuReadElementsTemp;
logic [WORD32_NUM-1:0]                   cpuReadElements;
wire                                     clearCacheLineDirty;

wire [ELEMENT_WIDTH-1:0]                 supReadDataHi;
wire [ELEMENT_WIDTH-1:0]                 supReadDataLo;

wire                                     nextWriteTransValid;
wire                                     writeTransNew;

wire                                     nextLineValid;
wire [`CAP_ACTION_RANGE]                 nextLineAction;
wire                                     nextLineReadInProgress;
wire                                     nextLineReadComplete;
wire                                     nextLineDinNeeded;
logic [CAP_NUMWORDENABLES-1:0]           nextLineCpuOwnsSubwords;
wire                                     lineIsRead;
wire                                     lineIsReadClear;
wire                                     lineIsFullWrite;
wire                                     lineIsMergeWrite;
wire                                     lineNew;
wire                                     lineComplete;
wire                                     lineReadIssued;
wire                                     lastLineReadResponse;
wire                                     lastLineWriteResponse;
wire                                     readClearWriteReady;
wire                                     last1WordWritten;
wire                                     last2WordsWritten;

wire                                     memRead;
wire                                     memWrite;

wire                                     supReqIsQuery;
wire                                     supReq;
wire                                     supWriteXfer;
wire                                     nextMakeQueryResponse;

logic [`CEP_TRANS_SIZE_RANGE]            totalSize;

//
// Flops
//

reg                                      writeTransValidQ;  // to track burst write

reg                                      lineValidQ;        // indicates working on line
reg  [`CAP_ACTION_RANGE]                 lineActionQ;       // what to do to this line
// top bit indicates have gone past end--also keeps width valid for 1 32b word
reg                                      lineReadInProgressQ;
reg                                      lineReadCompleteQ;
reg                                      lineDinNeededQ;    // waiting for more DIN
logic  [CAP_NUMWORDENABLES-1:0]          lineCpuOwnsSubwordsQ;

logic [WORD32_NUM*32-1:0]                nextCacheLine;
wire [UNPR_PHYSICAL_WIDTH-1:0]           nextPhysCacheLine;
logic [WORD32_NUM-1:0]                   nextCacheLineDirty;
wire [WORD32_NUM*32-1:0]                 cacheLineQ;
reg  [UNPR_PHYSICAL_WIDTH-1:0]           physCacheLineQ;
reg  [WORD32_NUM-1:0]                    cacheLineDirtyQ;
wire                                     changeCacheLine;

reg                                      makeQueryResponseQ;
reg                                      writeCompletedQ;

always @(posedge sysClk)
begin
   writeTransValidQ     <= nextWriteTransValid;

   lineValidQ           <= nextLineValid;
   lineActionQ          <= nextLineAction;
   lineReadInProgressQ  <= nextLineReadInProgress;
   lineReadCompleteQ    <= nextLineReadComplete;
   lineDinNeededQ       <= nextLineDinNeeded;
   lineCpuOwnsSubwordsQ <= nextLineCpuOwnsSubwords;

   makeQueryResponseQ   <= nextMakeQueryResponse;
   writeCompletedQ      <= memWrite & cpuGrant;

   physCacheLineQ       <= (changeCacheLine) ? nextPhysCacheLine : physCacheLineQ;
   cacheLineDirtyQ      <= (supWriteXfer | lineNew) ? nextCacheLineDirty : cacheLineDirtyQ;
end

//
// Logic
//

// ignore external total size and replace with 1 if WATERMARK
assign totalSize = (WATERMARK_SUPPORT) ? 6'd1 : supTotalSize;

// totalSize of all 0 means 64, so can't do <= 2 sorts of things
assign supTotalSize1 = (totalSize == 6'd1);
assign supTotalSize2 = (totalSize == 6'd2);
assign supTotalSize1Or2 = supTotalSize1 | supTotalSize2;

// supRead=1 supWrite=1 totalSize= 0 is timeout, not new request
assign supReq = supEnable & ~supTimeout & (supRead | supWrite);
// Below is the CAP version line. Emailed Greg about the change because timeout is currently driven to 0. Seems that we need to drive timeout.
// I am using the CEP line for consistency with the regular transactor. We should get the update to TlaBlockNRdlWrap.sv once it is put in dglobal.
//assign supReq        = supEnable &
//                       ( (supRead ^ supWrite) | supRead & supWrite & (|totalSize) );


// make a vector of the cache line shifted left by 32 to help in selecting
// the low 32b data
assign cacheLineShifted = cacheLineQ << 32;

// we have to track the the concept of a burst transaction for writes so
// that the very first transaction can be recognized as a query while
// subsequent transactions are seen as bursts
assign supWriteXfer  = supEnable & supWrite & ~supRead;
assign writeTransNew = ~writeTransValidQ & supWriteXfer;
assign nextWriteTransValid = ~sysReset & ( writeTransNew |
                                           writeTransValidQ & ~supTimeout &
                                           ~(supAccessComplete & lastWriteResponse) );

// Query means this agent must respond to the current request, even if
// there is more write data to receive--sup doesn't know the size of the
// line until the first response is received.
assign supReqIsQuery = writeTransNew;

// line valid if we get a new sup req--get a new sup req every time we
// cross over a line boundary
assign lineNew       = ~lineValidQ & supReq;

assign clearCacheLineDirty = lineNew;

assign lineComplete  = supTimeout | 

                       ( (lineActionQ == `CAP_ACTION_READ) |
                         (lineActionQ == `CAP_ACTION_READCLEAR) ) &
                       supReadDataValid & lastLineReadResponse |

                       ( (lineActionQ == `CAP_ACTION_FULLWRITE) |
                         (lineActionQ == `CAP_ACTION_MERGEWRITE) ) &
                       supAccessComplete & lastLineWriteResponse;

assign nextLineValid = ~sysReset & (lineNew | lineValidQ & ~lineComplete);

// WATERMARK_SUPPORT does a modified READCLEAR instead of a READ when the
// watermark is read.  It's not a true READCLEAR because the write data is
// the current depth instead of all 0.  Watermarks are at odd element addresses.
assign nextLineAction = (lineNew)
                           ? ( (WATERMARK_SUPPORT & supRead & supAddress[0])
                                                     ? `CAP_ACTION_READCLEAR :
                               (supRead & ~supWrite) ? `CAP_ACTION_READ :
                               (supRead & supWrite)  ? `CAP_ACTION_READCLEAR :
                               (supWrite & fullLine) ? `CAP_ACTION_FULLWRITE
                                                     : `CAP_ACTION_MERGEWRITE )
                           : lineActionQ;

assign lineIsRead       = (lineActionQ == `CAP_ACTION_READ);
assign lineIsReadClear  = (lineActionQ == `CAP_ACTION_READCLEAR);
assign lineIsFullWrite  = (lineActionQ == `CAP_ACTION_FULLWRITE);
assign lineIsMergeWrite = (lineActionQ == `CAP_ACTION_MERGEWRITE);
assign lineIsWriteType  = lineActionQ[`CAP_ACTION_WRITE_BIT];
// track a read is in progress from the time it is granted until data is
// returned (they can be the same cycle if AR w/ no pipe stages)
assign nextLineReadInProgress =
          (lineNew) ? 1'b0
                    : ~lineReadInProgressQ & memRead & cpuGrant & ~cpuDataValid |
                      lineReadInProgressQ & ~cpuDataValid;

// when a new line action starts, the read has not been completed,
// otherwise, it is complete whenever we receive cpu data--no need to
// cleanup on timeout because sup will start over with a new request
// nexttime, which will clear this
assign nextLineReadComplete = (lineNew)      ? 1'b0 :
                              (cpuDataValid) ? 1'b1
                                             : lineReadCompleteQ;

// The cpu generally starts out planning to read/write all subwords, except
// for watermark READCLEAR, which only wants to write the watermark.  There
// are two cases that might cause it to drop reading/writing specific
// subwords:
// 1) MERGEWRITE : hw bypasses data to cpu after cpu has issued read but
// before cpu has obtained read data--must remember which subwords were
// bypassed so as to not OVERWRITE them with the stale read data
// 2) READCLEAR  : after the read has been issued but before the location
// has been cleared, hw writes the same location.  (HW should already have
// obtained the all 0's cleared data from a read bypass.)  The new value HW
// is writing should be the final memory value, so do NOT write the cpu
// data to those subwords written by HW.
//    Both cases mean start out with a vector of 1's and then clear any
//    subwords that are written by hardware after/cooincident-with the read
//    (Also, clear when the READCLEAR write is made, because then the data
//     is in the memory, so we can stop tracking it and don't want to write
//     again.)

always @*
begin
    nextLineCpuOwnsSubwords = lineCpuOwnsSubwordsQ;
    for(integer i = 0; i < NUM_HW_WRITES; i++)
    begin
        if( hwWrite[i] & hwWriteAddressMatch[i] & (lineReadIssued | vulnerableReadIssue) )
            nextLineCpuOwnsSubwords = lineCpuOwnsSubwordsQ & ~hwSubwords;
    end
    if(lineIsReadClear & memWrite & cpuGrant)
        nextLineCpuOwnsSubwords = 1'b0;
    if(lineNew)
        nextLineCpuOwnsSubwords = 1'b1;
    if(lineNew & WATERMARK_SUPPORT & supRead & supAddress[0])
        nextLineCpuOwnsSubwords = 1'b1;
end

// For reads, have to track not  just if completed, but also if issued (due
// to pipe latency)
assign lineReadIssued = lineReadInProgressQ | lineReadCompleteQ;

// Do a memory read if there is an active READ, READCLEAR, or MERGEWRITE trans and
// we haven't read the line yet.  MERGEWRITE must receive all DIN before
// reading
assign memRead = lineValidQ & ~lineReadIssued & (lineIsRead | lineIsReadClear |
                                                 lineIsMergeWrite & ~lineDinNeededQ);

// Do a memory write if:
//    READCLEAR and line has issued read (or completed read, if watermark)
//    FULLWRITE and DIN has been collected
//    MERGEWRITE and and line has been read (DIN already collected)
assign readClearWriteReady = (WATERMARK_SUPPORT) ? lineReadCompleteQ : lineReadIssued;
assign memWrite = lineValidQ &
                  ( lineIsReadClear & readClearWriteReady & (|lineCpuOwnsSubwordsQ) |
                    lineIsFullWrite & ~lineDinNeededQ & ~writeCompletedQ |
                    lineIsMergeWrite & lineReadCompleteQ & ~writeCompletedQ );

// if HW can write in the same cycle as cpu reads AND we must bypass the
// data, then detect the vulnerable read issue
assign vulnerableReadIssue = WRITE_IN_READ_CLOCK && memRead && cpuGrant;

assign cpuReq      = memRead | memWrite;
assign cpuAddress  = supAddress[EXT_ADDRESS_WIDTH-1:WORD32_ADDR_WIDTH];
assign cpuWrite    = memWrite;
assign cpuSubwords = (lineIsReadClear & memWrite) ? lineCpuOwnsSubwordsQ
                                                  : {CAP_NUMWORDENABLES {1'b1}};

assign cpuUnprLogiDin =
          ( (lineActionQ == `CAP_ACTION_READCLEAR) & WATERMARK_SUPPORT )
             // watermark--copy upper half of line to lower half
             ? {2 {cacheLineQ[LOGICALWIDTH-1:LOGICALWIDTH/2]}} :
          (lineActionQ == `CAP_ACTION_READCLEAR)
             // normal READCLEAR just clears
             ? {LOGICALWIDTH {1'b0}}
             : cacheLineQ[LOGICALWIDTH-1:0];

// send responses to Sup
// once line has been read, stream out read data; BUT, for readclear, don't
// send last response until the write has been completed or disabled
assign supAddressIsLastLine =
          (supAddress[EXT_ADDRESS_WIDTH-1:WORD32_ADDR_WIDTH] == (DEPTH - 1));

assign supReadDataValid =
          lineValidQ & lineReadCompleteQ &
          (  lineIsRead |
             lineIsReadClear & ( ~lastLineReadResponse | ~(|lineCpuOwnsSubwordsQ) )  );
 
assign supReadData = supReadDataValid ? {supReadDataHi, supReadDataLo} : '0;

// to break a combinational path from sup inputs to outputs, if we need to
// respond to a query, remember to next cycle and do it then
assign nextMakeQueryResponse = ~sysReset & supReqIsQuery & ~lastLineWriteResponse;

assign supAccessComplete = makeQueryResponseQ |
                           ~lineIsWriteType & supReadDataValid & lastLineReadResponse |
                           lineIsWriteType & lineValidQ & writeCompletedQ;

// reads always send back 2 32b words unless the remaining size is 1 or the
// 32b word address is the last one;  writes send back the number of
// 32b words unless the response is for completion of the last line in the memory,
// which sends 0
// (Query can always send line size because it can never be end of memory)
assign supAccessSize =   (supReadDataValid) ? readResponseAccessSize :
                       (makeQueryResponseQ) ? WORD32_NUM[`CEP_TRANS_SIZE_RANGE] :
      (writeCompletedQ & last1WordWritten)  ? `CAP_END_OF_MEMORY_1WORD :
      (writeCompletedQ & last2WordsWritten) ? `CAP_END_OF_MEMORY_2WORDS
                                            : WORD32_NUM[`CEP_TRANS_SIZE_RANGE];

assign supTotalSizeGe2 = |totalSize[`CEP_TRANS_SIZE_MSB:1];
assign write64 = ~(supTotalSizeGe2 | totalSize[0]) | supTotalSizeGe2;

// When CPU reads, it may have write data cached (MERGEWRITE), so don't
// update dirty elements; also if hardware wrote into part of the line but
// that write isn't in the read data, don't update that part of the line
// either.
assign cpuSel = {WORD32_NUM {cpuDataValid}} & ~cacheLineDirtyQ & cpuReadElements;

// figure out which two (or one) 32b words sup is writing to
assign supHiSel = {WORD32_NUM {supWriteXfer}} & supWord32SelVecWire;
assign supLoSel = {WORD32_NUM {write64}} & (supHiSel >> 1);

//
// all signals that need special code for width changes
//

always @*
begin
    for(integer i = 0; i < NUM_HW_READS; i++)
    begin
        hwReadAddressMatch[i]  = (hwReadAddress[i] == supAddress[EXT_ADDRESS_WIDTH-1:WORD32_ADDR_WIDTH]);

        // don't worry about hw read in same clock for below bypass because then
        // hardware should assert the atomic flag, which will prevent the cpu
        // read--only have to worry about hw reads AFTER cpu read issued
        cpuBypass0sToHwRead[i] = (lineValidQ & lineIsReadClear & hwRead[i] & hwReadAddressMatch[i] & lineReadIssued) ? lineCpuOwnsSubwordsQ : {CAP_NUMWORDENABLES {1'b0}};
    end
end

always @*
begin
    for(integer i = 0; i < NUM_HW_WRITES; i++)
    begin
        // maintain cache line
        hwWriteAddressMatch[i] = (hwWriteAddress[i] == supAddress[EXT_ADDRESS_WIDTH-1:WORD32_ADDR_WIDTH]);
        hwBypassIntoCache[i]   = lineValidQ & lineIsMergeWrite & hwWrite[i] & hwWriteAddressMatch[i] & (lineReadIssued | vulnerableReadIssue);

        // this will still bypass the cycle after we write (when we are just making
        // the response to sup), but that's OK since we are done with the data then;
        // to fix, and in ~writeCompletedQ
        hwSel[i]               = {WORD32_NUM {hwBypassIntoCache[i]}} & hwWriteElements[i] & ~cacheLineDirtyQ;
    end
end

always @*
begin
    for(integer elementI = 0; elementI < WORD32_NUM; elementI++)
    begin
        nextCacheLine[elementI*ELEMENT_WIDTH +: ELEMENT_WIDTH] = cacheLineQ[elementI*ELEMENT_WIDTH +: ELEMENT_WIDTH];
        if(cpuSel[elementI]) nextCacheLine[elementI*ELEMENT_WIDTH +: ELEMENT_WIDTH] = extCpuCorrLogiDout[elementI*ELEMENT_WIDTH +: ELEMENT_WIDTH];
        for(integer i = 0; i < NUM_HW_WRITES; i++)
        begin
            if(hwSel[i][elementI]) nextCacheLine[elementI*ELEMENT_WIDTH +: ELEMENT_WIDTH] = extHwUnprLogiDin[i][elementI*ELEMENT_WIDTH +: ELEMENT_WIDTH];
        end
        if(supLoSel[elementI]) nextCacheLine[elementI*ELEMENT_WIDTH +: ELEMENT_WIDTH] = supWriteData[31:0];
        if(supHiSel[elementI]) nextCacheLine[elementI*ELEMENT_WIDTH +: ELEMENT_WIDTH] = supWriteData[63:32];


        nextCacheLineDirty[elementI] =
                (|optMask[elementI*ELEMENT_WIDTH +: ELEMENT_WIDTH]) &
                ( (supHiSel[elementI] | supLoSel[elementI]) ? 1'b1 :
                  (clearCacheLineDirty)                     ? 1'b0
                                                            : cacheLineDirtyQ[elementI] );
    end
end


generate

   assign changeCacheLine = supWriteXfer | (|hwBypassIntoCache) | cpuDataValid;

   if (LOGICALMASK != 0)
   begin
      MapPhysical2Logical
      #(
         .LOGICAL_WIDTH  (LOGICALWIDTH),
         .LOGICAL_MASK   (LOGICALMASK),
         .PHYSICAL_WIDTH (UNPR_PHYSICAL_WIDTH)
      ) MapPhysical2LogicalC (
         .physicalData (physCacheLineQ),
         .logicalData  (cacheLineQ)
      );

      MapLogical2Physical
      #(
         .LOGICAL_WIDTH  (LOGICALWIDTH),
         .LOGICAL_MASK   (LOGICALMASK),
         .PHYSICAL_WIDTH (UNPR_PHYSICAL_WIDTH)
      ) MapLogical2PhysicalCN (
         .logicalData  (nextCacheLine),
         .physicalData (nextPhysCacheLine)
      );
   end else begin
      assign cacheLineQ = physCacheLineQ;
      assign nextPhysCacheLine = nextCacheLine;
   end

   if (WORD32_NUM == 1)
   begin
      // indicates a response now would finish a write trans (all of totalSize used)
      // special case for 32b because only done when totalSize==1 or
      // writing to last line address
      assign lastWriteResponse = supTotalSize1 | supAddressIsLastLine;

      // Hi read data is always whole cache and low always 0
      assign supReadDataHi = cacheLineQ;
      assign supReadDataLo = '0;

      // reads always return only one 32b word
      assign readResponseAccessSize = 6'd1;

      // There's always only one read response/line, so it must be the last one
      assign lastLineReadResponse = 1'b1;

      assign last1WordWritten = supAddressIsLastLine;
      assign last2WordsWritten = 1'b0;

   end else if (WORD32_NUM == 2) begin
      // special case because compare address is 0 bits wide; so also done if 2-word
      // write with low address bit of 0
      assign lastWriteResponse = supTotalSize1 |
                                 supTotalSize2 & (supAddress[0] == 1'b0) |
                                 supAddressIsLastLine;

      // choose the Hi and Lo read data
      // invert the address because address 0 is MSB
      assign supReadDataHi =       cacheLineQ[{~supAddress[0], 5'd31} -: 32];
      assign supReadDataLo = cacheLineShifted[{~supAddress[0], 5'd31} -: 32];

      // decide if read response is for one or two 32b words
      // reads always send back 2 words unless the remaining size is 1 or the
      // word address is the last one
      assign readResponseAccessSize = (supTotalSize1 | supAddress[0]) ? 6'd1 : 6'd2;

      // There's always only one read response/line, so it must be the last one
      assign lastLineReadResponse = 1'b1;

      // 0 means 64, so only write < size 2 is size 1
      assign last1WordWritten  = supAddressIsLastLine & supAddress[0];
      assign last2WordsWritten = supAddressIsLastLine & ~supAddress[0] & (totalSize != 6'd1);

   end else begin
      reg  [WORD32_ADDR_WIDTH-1:0]             nextLineWord32Addr;
      wire [`CEP_TRANS_SIZE_RANGE]             nextLineTotalSize;
      wire                                     lineTotalSize1;
      wire                                     lineTotalSize2;
      wire                                     lineTotalSize1Or2;
      reg  [WORD32_ADDR_WIDTH-1:0]             lineWord32AddrQ;   // 32b word idx within line
      reg  [`CEP_TRANS_SIZE_RANGE]             lineTotalSizeQ;

      always @(posedge sysClk)
      begin
         lineWord32AddrQ      <= nextLineWord32Addr;
         lineTotalSizeQ       <= nextLineTotalSize;
      end

      // for large lines, track our position in the line for reads
      // (can always add 2 because we won't use this address after it wraps)
      always @*
      begin
        nextLineWord32Addr = (lineNew) ? {supAddress[WORD32_ADDR_WIDTH-1:0]} :
                         (supReadDataValid) ? lineWord32AddrQ + 2'd2 : lineWord32AddrQ;
      end

      assign nextLineTotalSize = (lineNew)          ? totalSize :
                                 (supReadDataValid) ? lineTotalSizeQ - supAccessSize
                                                    : lineTotalSizeQ;

      assign lineTotalSize1 = (lineTotalSizeQ == 6'd1);
      assign lineTotalSize2 = (lineTotalSizeQ == 6'd2);
      assign lineTotalSize1Or2 = lineTotalSize1 | lineTotalSize2;

      // general case--compute compare address
      assign lastWriteResponse = supTotalSize1 |
                                 supTotalSize2 & ( supAddress[WORD32_ADDR_WIDTH-1:0] !=
                                                   {WORD32_ADDR_WIDTH {1'b1}} ) |
                                 (supAddress[WORD32_ADDR_WIDTH-1:1] ==
                                  {(WORD32_ADDR_WIDTH-1) {1'b1}}) & supAddressIsLastLine ;

      // choose the Hi and Lo read data
      // invert the address because address 0 is MSB
      assign supReadDataHi =       cacheLineQ[{~lineWord32AddrQ[WORD32_ADDR_WIDTH-1:0], 5'd31}
                                              -: 32];
      assign supReadDataLo = cacheLineShifted[{~lineWord32AddrQ[WORD32_ADDR_WIDTH-1:0], 5'd31}
                                              -: 32];

      // decide if read response is for one or two 32b words
      // reads always send back 2 words unless the remaining size is 1 or the
      // word address is the last one
      assign readResponseAccessSize =
                ( lineTotalSize1 | (lineWord32AddrQ[WORD32_ADDR_WIDTH-1:0] ==
                                    {WORD32_ADDR_WIDTH {1'b1}}) )
                   ? 6'd1 : 6'd2;

      assign lastLineReadResponse = lineTotalSize1Or2 | &lineWord32AddrQ[WORD32_ADDR_WIDTH-1:1];

      // 0 means 64, so only write < size 2 is size 1
      assign last1WordWritten =
               supAddressIsLastLine &
               (supAddress[WORD32_ADDR_WIDTH-1:0] == {WORD32_ADDR_WIDTH {1'b1}});
      assign last2WordsWritten =
               supAddressIsLastLine &
               (supAddress[WORD32_ADDR_WIDTH-1:0] == { {(WORD32_ADDR_WIDTH-1) {1'b1}}, 1'b0 }) &
               (totalSize != 6'd1);
   end

   if (WORD32_NUM == 1)
   begin
      // writes are always for the full line if there's one 32b word
      assign fullLine = 1'b1;

      // one-bit select is always 1
      assign supWord32SelVecWire = 1'b1;

      // Writes always hit the one and only 32b word
      assign hwWriteElements = '1;

      // omit reading the only element if mergewrite and hw wrote to it
      assign cpuReadElements = lineCpuOwnsSubwordsQ | ~lineIsMergeWrite;

   end else begin
      // full line if addressing first 32b word and totalSize >= line size
      assign fullLine = (supAddress[WORD32_ADDR_WIDTH-1:0] == {WORD32_ADDR_WIDTH {1'b0}}) &
                        ( {~(|totalSize), totalSize} >= WORD32_NUM );

      // make a 1-hot vec that says which 32b word sup is targetting
      reg [WORD32_NUM-1:0] tempSupWord32SelVec;
      always @*
      begin

         tempSupWord32SelVec = {WORD32_NUM {1'b0}};
         // invert the word32 address so 0 starts on the MSB
         tempSupWord32SelVec[~supAddress[WORD32_ADDR_WIDTH-1:0] ] = 1'b1;
         supWord32SelVec = tempSupWord32SelVec;
      end
      assign supWord32SelVecWire = supWord32SelVec;

      // decide which elements are written by hardware, considering subword enables
      always @*
      begin
         for(int writePort = 0; writePort < NUM_HW_WRITES; writePort++)
         begin
             for (int i = 0; i < CAP_NUMWORDENABLES; i++)
             begin
                hwWriteElements[writePort][i*ELEMENTS_PER_SUBWORD +: ELEMENTS_PER_SUBWORD] = {ELEMENTS_PER_SUBWORD {hwSubwords[writePort][i]}};
             end
         end
      end

      // omit reading element if mergewrite and hw wrote to it
      always @*
      begin
         for (int i = 0; i < CAP_NUMWORDENABLES; i++)
         begin
            cpuReadElements[i*ELEMENTS_PER_SUBWORD +: ELEMENTS_PER_SUBWORD] = {ELEMENTS_PER_SUBWORD {(lineIsMergeWrite) ? lineCpuOwnsSubwordsQ[i] : 1'b1}};
         end
      end
   end

   if (WORD32_NUM <= 2)
   begin
      // sup can send 64b data, and there is <= 64b word, so one write
      // finishes it off
      assign nextLineDinNeeded = 1'b0;

      // same for write
      assign lastLineWriteResponse = 1'b1;

   end else begin

      // need more write data unless there is a supWrite with (totalSize > 2)
      // and we are more than 2 from the end of the line; either finish the write
      // data or finish the line, otherwise.
      assign nextLineDinNeeded =
                (supReq)
                   ? ~supRead & supWrite & ~supTotalSize1Or2 &
                     ( supAddress[WORD32_ADDR_WIDTH-1:0] <
                       { {(WORD32_ADDR_WIDTH-1) {1'b1}}, 1'b0 } )
                   : lineDinNeededQ;

      assign lastLineWriteResponse = ( supAddress[WORD32_ADDR_WIDTH-1:1] ==
                                       {(WORD32_ADDR_WIDTH-1) {1'b1}} ) | supTotalSize1Or2;
   end

   // generate a mask that can be used to read/write the logical-sized cache
   // line so that reserved flops/gates are deleted; extra code in case
   // LOGICALMASK is wrong (too small)--won't cause extra gates
   // extend logical-sized things up to next 32b boundary
   assign optMask[LOGICALWIDTH-1:0] = ~LOGICALMASK;
   assign extCpuCorrLogiDout[LOGICALWIDTH-1:0] = cpuCorrLogiDout;
   if ((WORD32_NUM * 32) > LOGICALWIDTH)
   begin
      assign optMask[WORD32_NUM*32-1:LOGICALWIDTH] = {(WORD32_NUM * 32 - LOGICALWIDTH) {1'b0}};
      assign extCpuCorrLogiDout[WORD32_NUM*32-1:LOGICALWIDTH] =
                {(WORD32_NUM * 32 - LOGICALWIDTH) {1'b0}}; 
   end

   genvar gi;
   for(gi = 0; gi < NUM_HW_WRITES; gi = gi + 1)
   begin
      assign extHwUnprLogiDin[gi][LOGICALWIDTH-1:0] = hwUnprLogiDin;
      if ((WORD32_NUM * 32) > LOGICALWIDTH)
          assign extHwUnprLogiDin[gi][WORD32_NUM*32-1:LOGICALWIDTH] = {(WORD32_NUM * 32 - LOGICALWIDTH) {1'b0}}; 
   end

endgenerate

endmodule // CapTransactor

