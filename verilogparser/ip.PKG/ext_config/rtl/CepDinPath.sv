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
// File          : CepDinPath.sv
// Author        : Greg Ries
// Description   : This module implements a datapath for write data (DIN).
//                 It is designed to be re-used in a variety of CEP wrappers
//                 that all want the same sort of protection options and
//                 arbitration on a DIN path.
//
// hwUnprLogiDin, cpuUnprLogiDin : DIN starts out logical w/ no check bits
// hwUnprPhysDin, cpuUnprPhysDin : map from logical to physical
// hwEarlyPhysDin, cpuEarlyPhysDin : optional Early protection on both
// earlyPhysDin  : mux between hw and cpu based on if hw is active
// protPhysDin   : if no Early protection, protect now
//
// $Id: CepDinPath.sv,v 1.2 2013/07/02 19:53:42 gregries Exp $
//////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ns
`include "DGlobal.vh"
`include "Cep.vh"
`include "log2.vh"
`include "CapWrap.vh"

module CepDinPath
#(
   parameter LOGICALWIDTH        = 32,
   parameter LOGICALMASK         = 32'd0,
   parameter UNPR_PHYSICAL_WIDTH = 32,
   parameter PROT_PHYSICAL_WIDTH = 33,
   parameter CODE_PORT_WIDTH     = 1,
   parameter PARITY              = 1,
   parameter ECC                 = 0,
   parameter CAP_NUMWORDENABLES  = 1,
   parameter EARLY_CHECK_BIT_GEN = 0,
   parameter NO_HARDWARE_WRITES  = 0
) (
   input  logic [LOGICALWIDTH-1:0]        hwUnprLogiDin,
   input  logic [LOGICALWIDTH-1:0]        cpuUnprLogiDin,
   input  logic                           hwActive,

   output logic [PROT_PHYSICAL_WIDTH-1:0] protPhysDin,

   input  logic                           protOverride,
   input  logic [CODE_PORT_WIDTH-1:0]     checkBitsIn
);

`MACRO_log2
`MACRO_getCodeWidth

localparam SUB_WIDTH           = (UNPR_PHYSICAL_WIDTH/CAP_NUMWORDENABLES);
localparam SUB_CODE_WIDTH      = codeWidth(SUB_WIDTH, PARITY, ECC);
localparam SUB_PROT_WIDTH      = SUB_WIDTH + SUB_CODE_WIDTH;
localparam EARLY_PROT_WIDTH    = (EARLY_CHECK_BIT_GEN) ? PROT_PHYSICAL_WIDTH : UNPR_PHYSICAL_WIDTH;

logic [UNPR_PHYSICAL_WIDTH-1:0] hwUnprPhysDin;
logic [UNPR_PHYSICAL_WIDTH-1:0] cpuUnprPhysDin;
logic [EARLY_PROT_WIDTH-1:0]    hwEarlyPhysDin;
logic [EARLY_PROT_WIDTH-1:0]    cpuEarlyPhysDin;
logic [EARLY_PROT_WIDTH-1:0]    earlyPhysDin;

generate
   genvar wordGenVar;
   genvar subGenVar;

   if (LOGICALMASK != 0)
   begin
      MapLogical2Physical
      #(
         .LOGICAL_WIDTH  (LOGICALWIDTH),
         .PHYSICAL_WIDTH (UNPR_PHYSICAL_WIDTH),
         .LOGICAL_MASK   (LOGICALMASK)
      ) MapLogical2PhysicalHw (
         .logicalData (hwUnprLogiDin),
         .physicalData(hwUnprPhysDin)
      );

      MapLogical2Physical
      #(
         .LOGICAL_WIDTH  (LOGICALWIDTH),
         .PHYSICAL_WIDTH (UNPR_PHYSICAL_WIDTH),
         .LOGICAL_MASK   (LOGICALMASK)
      ) MapLogical2PhysicalCpu (
         .logicalData (cpuUnprLogiDin),
         .physicalData(cpuUnprPhysDin)
      );
   end else begin // if (LOGICALMASK != 0)
       assign hwUnprPhysDin  = hwUnprLogiDin;
       assign cpuUnprPhysDin = cpuUnprLogiDin;
   end // else: !if(LOGICALMASK != 0)

   // deal with protection BERFORE the hw/cpu mux
   if (EARLY_CHECK_BIT_GEN && (PARITY || ECC))
   begin
      for (wordGenVar = 0; wordGenVar < CAP_NUMWORDENABLES; wordGenVar = wordGenVar+1)
      begin :earlyCheckGenerate
         if (PARITY)
         begin
            CapParityGen
            #(
               .WIDTH(SUB_WIDTH)
            ) CapParityGenHwWord (
               .rawDataIn        (hwUnprPhysDin[(SUB_WIDTH*wordGenVar)+:SUB_WIDTH]),
               .hwActive         (1'b1),
               .paritySyndromeIn (checkBitsIn),
               .protOverride     (protOverride),
               .parityDataOut    (hwEarlyPhysDin[(SUB_PROT_WIDTH*wordGenVar)+:SUB_PROT_WIDTH])
            );

            CapParityGen
            #(
               .WIDTH(SUB_WIDTH)
            ) CapParityGenCpuWord (
               .rawDataIn        (cpuUnprPhysDin[(SUB_WIDTH*wordGenVar)+:SUB_WIDTH]),
               .hwActive         (1'b0),
               .paritySyndromeIn (checkBitsIn),
               .protOverride     (protOverride),
               .parityDataOut    (cpuEarlyPhysDin[(SUB_PROT_WIDTH*wordGenVar)+:SUB_PROT_WIDTH])
            );
         end else begin // if (PARITY)
            CapEccGen
            #(
               .WIDTH     (SUB_WIDTH),
               .CODEWIDTH (SUB_CODE_WIDTH)
            ) CapECCGenHwWord (
               .rawDataIn    (hwUnprPhysDin[(SUB_WIDTH * wordGenVar)+:SUB_WIDTH]),
               .hwActive     (1'b1),
               .eccSyndromeIn(checkBitsIn),
               .protOverride (protOverride),
               .eccDataOut   (hwEarlyPhysDin[(SUB_PROT_WIDTH*wordGenVar)+:SUB_PROT_WIDTH] )
            );

            CapEccGen
            #(
               .WIDTH     (SUB_WIDTH),
               .CODEWIDTH (SUB_CODE_WIDTH)
            ) CapECCGenCpuWord (
               .rawDataIn    (cpuUnprPhysDin[(SUB_WIDTH * wordGenVar)+:SUB_WIDTH]),
               .hwActive     (1'b0),
               .eccSyndromeIn(checkBitsIn),
               .protOverride (protOverride),
               .eccDataOut   (cpuEarlyPhysDin[(SUB_PROT_WIDTH*wordGenVar)+:SUB_PROT_WIDTH] )
            );
         end // else: !if (PARITY)
      end
   end else begin // if (EARLY_CHECK_BIT_GEN && (PARITY || ECC))
      assign hwEarlyPhysDin  = hwUnprPhysDin;
      assign cpuEarlyPhysDin = cpuUnprPhysDin;
   end // else: !if (EARLY_CHECK_BIT_GEN && (PARITY || ECC))

   // now deal with protection AFTER the hw/cpu mux
   // eliminate bogus NoLogicalNOTOnVector message, which is spyglass bug
   if (!EARLY_CHECK_BIT_GEN && (PARITY || ECC)) // spyglass disable STARC05-2.10.2.3
   begin
      logic [EARLY_PROT_WIDTH-1:0]    genDataIn;
      logic [PROT_PHYSICAL_WIDTH-1:0] genDataOut;

      if (NO_HARDWARE_WRITES)
      begin
         // rather than using muxed DIN, connect the generators straight to
         // CPU DIN--hardware write data is still muxed with cpu for cases
         // like TCAMs, where DIN is used as search key also
         assign genDataIn = cpuEarlyPhysDin;
      end else begin
         // use the muxed DIN that includes hardware write data
         assign genDataIn = earlyPhysDin;
      end

      for (subGenVar = 0; subGenVar < CAP_NUMWORDENABLES; subGenVar = subGenVar+1)
      begin :checkGenerate
         if (PARITY)
         begin
            CapParityGen
            #(
               .WIDTH(SUB_WIDTH)
            ) CapParityGenWord (
               .rawDataIn        (genDataIn[(SUB_WIDTH*subGenVar)+:SUB_WIDTH]),
               .hwActive         (hwActive),
               .paritySyndromeIn (checkBitsIn),
               .protOverride     (protOverride),
               .parityDataOut    (genDataOut[(SUB_PROT_WIDTH*subGenVar)+:SUB_PROT_WIDTH])
            );
         end else if (ECC) begin // if (PARITY)
            CapEccGen
            #(
               .WIDTH     (SUB_WIDTH),
               .CODEWIDTH (SUB_CODE_WIDTH)
            ) CapECCGenHwWord (
               .rawDataIn    (genDataIn[(SUB_WIDTH * subGenVar)+:SUB_WIDTH]),
               .hwActive     (hwActive),
               .eccSyndromeIn(checkBitsIn),
               .protOverride (protOverride),
               .eccDataOut   (genDataOut[(SUB_PROT_WIDTH*subGenVar)+:SUB_PROT_WIDTH] )
            );
         end // else: !if (ECC)

         if (NO_HARDWARE_WRITES)
         begin
            // FOR CAMs which still need HW DIN for MATCHING
            // the regular data bits always come from muxed data
            assign protPhysDin[SUB_PROT_WIDTH*subGenVar+:SUB_WIDTH] =
                      earlyPhysDin[SUB_WIDTH*subGenVar+:SUB_WIDTH];

            // the check data bits always come from the generator
            assign protPhysDin[SUB_PROT_WIDTH*subGenVar+SUB_WIDTH+:SUB_PROT_WIDTH-SUB_WIDTH] =
                      genDataOut[SUB_PROT_WIDTH*subGenVar+SUB_WIDTH+:SUB_PROT_WIDTH-SUB_WIDTH];
         end else begin // if (NO_HARDWARE_WRITES)
            // take check bits and data from gen to get one-bit error injection
            // capability on HW writes
            assign protPhysDin[SUB_PROT_WIDTH*subGenVar+:SUB_PROT_WIDTH] =
                      genDataOut[SUB_PROT_WIDTH*subGenVar+:SUB_PROT_WIDTH];
         end // else: !if (NO_HARDWARE_WRITES)
      end
   end else begin // if (!EARLY_CHECK_BIT_GEN && (PARITY || ECC))
      assign protPhysDin  = earlyPhysDin;
   end // else: !if (!EARLY_CHECK_BIT_GEN && (PARITY || ECC))

endgenerate

// Mux between hw and cpu
assign earlyPhysDin = (hwActive) ? hwEarlyPhysDin : cpuEarlyPhysDin;

endmodule // CepDinPath

