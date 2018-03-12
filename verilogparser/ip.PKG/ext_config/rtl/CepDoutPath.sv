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
// File          : CepDoutPath.v
// Author        : Greg Ries
// Description   : This module inplements a datapath for read data (DOUT).
//                 It is designed to be re-used in a variety of CEP wrappers
//                 that all want the same sort of protection options and
//                 pipelining on a DOUT path.
//
//                 - prot means ecc/parity bits are intermingled
//                 - corr means ecc/parity bits have been removed after
//                   checking
//
//                 The hardware port can hook up to one of three places:
//                   1) A parity checker after a flop that is clock gated
//                      by hardware read; results will stay constant
//                      between hw reads (cpu does not trample)
//                   2) the pipelined protected data (must skip ecc/parity
//                      bits); this case is for use with PARITYPIPELINE
//                   3) at the same point as cpu:  after the main checker
//                      and any pipeline stages that came before
//
//                   Pipline support:
//                      PIPELINE total stages after the memory input flop.
//                      CAP_DOUT_PIPE stages after generic memory, one of
//                         which may be clock gated
//                         (CAP_DOUT_PIPE_CLOCK_GATE); CAP_DOUT_PIPE is
//                         already included in PIPELINE above
//                      PARITYPIPELINE : an extra stage is added AFTER
//                         PIPELINE, and the cpu takes its data from this
//                         extra stage; hw takes data from before this
//                         stage.
//
// $Id: CepDoutPath.sv,v 1.3 2013/07/16 17:14:03 gregries Exp $
//////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ns
`include "DGlobal.vh"
`include "Cep.vh"
`include "log2.vh"
`include "CapWrap.vh"

module CepDoutPath
#(
   parameter LOGICALWIDTH             = 32,
   parameter LOGICALMASK              = 32'd0,
   parameter UNPR_PHYSICAL_WIDTH      = 32,
   parameter PROT_PHYSICAL_WIDTH      = 33,
   parameter CODE_PORT_WIDTH          = 1,
   parameter CAP_NUMWORDENABLES       = 1,
   parameter PARITY                   = 1,
   parameter ECC                      = 0,
   parameter PIPELINE                 = 0,
   parameter PARITYPIPELINE           = 0,
   parameter CAP_DOUT_PIPE            = 0,
   parameter CAP_DOUT_PIPE_CLOCK_GATE = 0
) (
   input  wire                                           sysClk,

   input  wire [PROT_PHYSICAL_WIDTH-1:0]                 protPhysDout,
   input  wire                                           hwReadAtGate,
   input  wire [CAP_NUMWORDENABLES-1:0]                  gatedCpuBypass0sToHwRead,

   input  wire                                           parityPipeReadValid,

   output wire [LOGICALWIDTH-1:0]                        hwCorrLogiDout,
   output wire [CAP_NUMWORDENABLES-1:0]                  hwGatedParityErr,
   output wire [LOGICALWIDTH-1:0]                        cpuCorrLogiDout,

   output wire [PROT_PHYSICAL_WIDTH-1:0]                 elamProtPhysDout,

   input  wire                                            protChkDisable,
   output wire [(CODE_PORT_WIDTH*CAP_NUMWORDENABLES)-1:0] syndromeOut,
   output wire [CAP_NUMWORDENABLES-1:0]                   uncErr,
   output wire [CAP_NUMWORDENABLES-1:0]                   corErr
);

`MACRO_log2
`MACRO_getCodeWidth

localparam SUB_WIDTH           = (UNPR_PHYSICAL_WIDTH/CAP_NUMWORDENABLES);
localparam SUB_CODE_WIDTH      = codeWidth(SUB_WIDTH, PARITY, ECC);
localparam SUB_PROT_WIDTH      = SUB_WIDTH + SUB_CODE_WIDTH;
localparam CLOCK_GATED_STAGE   = (CAP_DOUT_PIPE_CLOCK_GATE) ? 1 : 0;
localparam DOUT_MULTI_STAGES   = CAP_DOUT_PIPE - CLOCK_GATED_STAGE;

wire [PROT_PHYSICAL_WIDTH-1:0] capPipeProtPhysDout;
reg  [PROT_PHYSICAL_WIDTH-1:0] hwGatedProtPhysDoutQ;
wire [PROT_PHYSICAL_WIDTH-1:0] hwGatedProtPhysDout;
reg  [PROT_PHYSICAL_WIDTH-1:0] parityPipeProtPhysDoutQ;
wire [PROT_PHYSICAL_WIDTH-1:0] parityPipeProtPhysDout;
wire [UNPR_PHYSICAL_WIDTH-1:0] hwGatedCorrPhysDout;
wire [UNPR_PHYSICAL_WIDTH-1:0] ungatedCorrPhysDout;
wire [UNPR_PHYSICAL_WIDTH-1:0] hwCorrPhysDout;
wire [UNPR_PHYSICAL_WIDTH-1:0] hwBypCorrPhysDout;
wire [CAP_NUMWORDENABLES-1:0]  hwParityErr;
reg  [UNPR_PHYSICAL_WIDTH-1:0] hwClearData;

generate
   genvar wordGenVar;
   genvar subwordGenVar;
   genvar xlateGenVar;

   // start by putting pipe stages on wrapper DOUT, if tla asked for it
   if (DOUT_MULTI_STAGES > 0)
   begin
      CapMultiSync
      #(
         .WIDTH     (PROT_PHYSICAL_WIDTH),
         .stages    (DOUT_MULTI_STAGES)
      ) CapMultiSyncDout (
         .clk       (sysClk),
         .reset     (1'b0), // don't need reset here
         .dataIn    (protPhysDout),
         .dataOut   (capPipeProtPhysDout)
      );
   end else begin
      assign capPipeProtPhysDout = protPhysDout;
   end

   // if the dout pipe should be clock gated, one stage was left out of
   // DOUT_MULTI_STAGES earlier.  Add one stage in after the MULTI with
   // the clock gate.
   if (CLOCK_GATED_STAGE)
   begin
      always @(posedge sysClk)
      begin
         hwGatedProtPhysDoutQ <= (hwReadAtGate) ? capPipeProtPhysDout : hwGatedProtPhysDout;
      end
      assign hwGatedProtPhysDout = hwGatedProtPhysDoutQ;

      // need another checker set on the hwGated dout since it bypasses the
      // main one
      for (subwordGenVar = 0; subwordGenVar < CAP_NUMWORDENABLES;
           subwordGenVar = subwordGenVar + 1)
      begin :hwCheckGenerate
         CapParityCkr
         #(
            .WIDTH (SUB_WIDTH)
         ) CapHwParityCkrWord (
            .parityDataIn   (hwGatedProtPhysDout[SUB_PROT_WIDTH*subwordGenVar +:
                                                    SUB_PROT_WIDTH]),
            .protChkDisable (protChkDisable),
            .rawDataOut     (hwGatedCorrPhysDout[SUB_WIDTH*subwordGenVar +: SUB_WIDTH]),
            .parityOut      (),  // only need the err--the rest comes from main checker
            .parErr         (hwParityErr[subwordGenVar])
         );
      end

      assign hwGatedParityErr = hwParityErr;

   end else begin
      assign hwGatedProtPhysDout = {PROT_PHYSICAL_WIDTH {1'b0}};
      assign hwGatedParityErr = {CAP_NUMWORDENABLES {1'b0}};
   end

   // When there is a CLOCK_GATED_STAGE on the HW read path, or when
   // PARITYPIPELINE is set, put a pipe stage before the correction module.
   // For CLOCK_GATED_STAGE, the stage being added here is in parallel
   // with, and to match with, the CLOCK_GATED_STAGE on the hw path above.
   // For PARITYPIPELINE, this is a new stage to isolate parity check
   // timing from the memory read path.
   if (CLOCK_GATED_STAGE || PARITY && PARITYPIPELINE)
   begin
      always @(posedge sysClk)
      begin
         parityPipeProtPhysDoutQ <= (parityPipeReadValid) ? capPipeProtPhysDout
                                                          : parityPipeProtPhysDoutQ;
      end
      assign parityPipeProtPhysDout = parityPipeProtPhysDoutQ;

   end else begin
      assign parityPipeProtPhysDout = capPipeProtPhysDout;
   end

   // instantiate protection modules
   if (PARITY || ECC)
   begin
      for (wordGenVar = 0; wordGenVar < CAP_NUMWORDENABLES; wordGenVar = wordGenVar + 1)
      begin :corrGenerate
         if (PARITY)
         begin
            CapParityCkr
            #(
               .WIDTH (SUB_WIDTH)
            ) CapParityCkrWord (
               .parityDataIn   (parityPipeProtPhysDout[SUB_PROT_WIDTH*wordGenVar +:
                                                       SUB_PROT_WIDTH]),
               .protChkDisable (protChkDisable),
               .rawDataOut     (ungatedCorrPhysDout[SUB_WIDTH*wordGenVar +: SUB_WIDTH]),
               .parityOut      (syndromeOut[wordGenVar]),
               .parErr         (uncErr[wordGenVar])
            );

            // tie off unneeded signals to safe values
            assign corErr[wordGenVar] = 1'b0;
 
         end else begin
            CapEccCkr
            #(
               .WIDTH     (SUB_WIDTH),
               .CODEWIDTH (SUB_CODE_WIDTH)
            ) CapEccCkrWord (
               .eccDataIn      (parityPipeProtPhysDout[SUB_PROT_WIDTH*wordGenVar +:
                                                       SUB_PROT_WIDTH]),
               .protChkDisable (protChkDisable),
               .rawDataOut     (ungatedCorrPhysDout[SUB_WIDTH*wordGenVar +: SUB_WIDTH]),
               .eccSyndromeOut (syndromeOut[(SUB_CODE_WIDTH*wordGenVar) +: SUB_CODE_WIDTH]),
               .eccCorErr      (corErr[wordGenVar]),
               .eccUncErr      (uncErr[wordGenVar])
            );
         end
      end
   end else begin // if (PARITY || ECC)
      // no check/corect of any kind; pass thru data and tie off error
      // signals to safe values
      assign ungatedCorrPhysDout = parityPipeProtPhysDout;
      assign syndromeOut = '0;
      assign corErr = '0;
      assign uncErr = '0;
   end // else: !if (PARITY || ECC)

   // next to last step:  choose where to hook up hw output (cpu output
   // always goes on ungatedCorrPhysDout)
   if (CLOCK_GATED_STAGE)
   begin
      assign hwCorrPhysDout = hwGatedCorrPhysDout;
   end else if (PARITY && PARITYPIPELINE) begin
      for (xlateGenVar = 0; xlateGenVar < CAP_NUMWORDENABLES; xlateGenVar = xlateGenVar+1)
      begin :hwDoutGenerate
         assign hwCorrPhysDout[SUB_WIDTH * xlateGenVar +: SUB_WIDTH] =
                   capPipeProtPhysDout[SUB_PROT_WIDTH * xlateGenVar +: SUB_WIDTH];
      end
   end else begin
      assign hwCorrPhysDout = ungatedCorrPhysDout;
   end

   // last step, expand hw data to logical
   // CPU port always takes output from main checker
   if (LOGICALMASK != 0)
   begin
      MapPhysical2Logical
      #(
         .LOGICAL_WIDTH  (LOGICALWIDTH),
         .LOGICAL_MASK   (LOGICALMASK),
         .PHYSICAL_WIDTH (UNPR_PHYSICAL_WIDTH)
      ) MapPhysical2LogicalHw (
         .logicalData  (hwCorrLogiDout),
         .physicalData (hwBypCorrPhysDout)
      );

      MapPhysical2Logical
      #(
         .LOGICAL_WIDTH  (LOGICALWIDTH),
         .LOGICAL_MASK   (LOGICALMASK),
         .PHYSICAL_WIDTH (UNPR_PHYSICAL_WIDTH)
      ) MapPhysical2LogicalCpu (
         .logicalData  (cpuCorrLogiDout),
         .physicalData (ungatedCorrPhysDout)
      );
   end else begin
      assign hwCorrLogiDout  = hwBypCorrPhysDout;
      assign cpuCorrLogiDout = ungatedCorrPhysDout;
   end

   // eliminate bogus NoLogicalNOTOnVector message, which is spyglass bug
   if (!PIPELINE && !(PARITY && PARITYPIPELINE)) // spyglass disable STARC05-2.10.2.3
   begin
      // there aren't any flops on the cpu read path, so make some for ELAM
      reg [PROT_PHYSICAL_WIDTH-1:0] elamProtPhysDoutQ;
      always @(posedge sysClk)
      begin
         elamProtPhysDoutQ <= (parityPipeReadValid) ? parityPipeProtPhysDout
                                                    : elamProtPhysDoutQ;
      end
      assign elamProtPhysDout = elamProtPhysDoutQ;

   end else begin
      // hook up ELAM after all flops on cpu path, right before main checker
      assign elamProtPhysDout = parityPipeProtPhysDout;
   end
endgenerate

// bypass 0's to hardware DOUT in case of read in the middle of cpu READCLEAR
integer j;
always @*
begin
   for (j = 0; j < CAP_NUMWORDENABLES; j = j + 1)
   begin
      hwClearData[(j+1)*SUB_WIDTH-1 -: SUB_WIDTH] = {SUB_WIDTH {gatedCpuBypass0sToHwRead[j]}};
   end
end

assign hwBypCorrPhysDout = hwCorrPhysDout & ~hwClearData;

endmodule // CepDoutPath

