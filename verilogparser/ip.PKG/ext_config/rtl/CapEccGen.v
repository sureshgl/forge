//////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2006, Cisco Systems, Inc.
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
// File          : CapEccGen
// Author        : Rakesh Sanam
// Description   : ECC Generator
// $Heading$
//
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ns

module CapEccGen 
   #(parameter WIDTH     = 8,
     parameter CODEWIDTH = 5
    )
   ( 
    input  wire  [WIDTH-1:0]               rawDataIn,
    input  wire                            hwActive,
    input  wire [CODEWIDTH-1:0] 	   eccSyndromeIn,
    input  wire                            protOverride,
     
    output wire  [WIDTH+CODEWIDTH-1:0]   eccDataOut
   );
   
   localparam TOTAL_BITS = WIDTH+CODEWIDTH;

`ifdef CAP_ECC_GLOBAL_BYPASS

   assign eccDataOut = { {CODEWIDTH{1'b0}},rawDataIn };

`else

   function integer log2;
      input [31:0] value;
      reg [31:0]   v; // not reusing value because of DC warning
      begin
	 v = value-1;
	 for (log2=0; v>0; log2=log2+1)
	    v = v>>1;
      end
   endfunction // log2


   integer               c, i, j;
   wire [TOTAL_BITS-1:0] hammingData;
   reg  [CODEWIDTH-1:0]  eccSyndrome;
   wire [CODEWIDTH-1:0]  eccOut;
   wire [WIDTH-1:0]      dataOut;
   
   //Generate Code and Data Interleaved Bits
   generate
      genvar 		tangleVar;
      assign hammingData[1:0]         = 2'b0;
      assign hammingData[TOTAL_BITS-1] = 1'b0;
      for (tangleVar=2; tangleVar < TOTAL_BITS-1; tangleVar=tangleVar+1) begin : inteleaveECC
	 case (tangleVar)
	    32'h0000_0003 : assign hammingData[tangleVar] = 1'b0;
            32'h0000_0007 : assign hammingData[tangleVar] = 1'b0;
            32'h0000_000f : assign hammingData[tangleVar] = 1'b0;
            32'h0000_001f : assign hammingData[tangleVar] = 1'b0;
            32'h0000_003f : assign hammingData[tangleVar] = 1'b0;
            32'h0000_007f : assign hammingData[tangleVar] = 1'b0;
            32'h0000_00ff : assign hammingData[tangleVar] = 1'b0;
            32'h0000_01ff : assign hammingData[tangleVar] = 1'b0;
            32'h0000_03ff : assign hammingData[tangleVar] = 1'b0;
            32'h0000_07ff : assign hammingData[tangleVar] = 1'b0;
            32'h0000_0fff : assign hammingData[tangleVar] = 1'b0;
            32'h0000_1fff : assign hammingData[tangleVar] = 1'b0;
            32'h0000_3fff : assign hammingData[tangleVar] = 1'b0;
            32'h0000_7fff : assign hammingData[tangleVar] = 1'b0;
            32'h0000_ffff : assign hammingData[tangleVar] = 1'b0;
            32'h0001_ffff : assign hammingData[tangleVar] = 1'b0;
            32'h0003_ffff : assign hammingData[tangleVar] = 1'b0;
            32'h0007_ffff : assign hammingData[tangleVar] = 1'b0;
            32'h000f_ffff : assign hammingData[tangleVar] = 1'b0;
            32'h001f_ffff : assign hammingData[tangleVar] = 1'b0;
            32'h003f_ffff : assign hammingData[tangleVar] = 1'b0;
            32'h007f_ffff : assign hammingData[tangleVar] = 1'b0;
            32'h00ff_ffff : assign hammingData[tangleVar] = 1'b0;
            32'h01ff_ffff : assign hammingData[tangleVar] = 1'b0;
            32'h03ff_ffff : assign hammingData[tangleVar] = 1'b0;
            32'h07ff_ffff : assign hammingData[tangleVar] = 1'b0;
            32'h0fff_ffff : assign hammingData[tangleVar] = 1'b0;
            32'h1fff_ffff : assign hammingData[tangleVar] = 1'b0;
            32'h3fff_ffff : assign hammingData[tangleVar] = 1'b0;
            32'h7fff_ffff : assign hammingData[tangleVar] = 1'b0;
            default       : assign hammingData[tangleVar] = rawDataIn[tangleVar-log2(tangleVar+1)];
	 endcase // case (sweepvar)
      end
   endgenerate

   always @ (*)
   begin
      eccSyndrome=0;
      for (c=0; c<(CODEWIDTH-1); c=c+1) begin
	 if (c==0) begin
	    for (i=0; i<TOTAL_BITS-1; i=i+2) begin
	       eccSyndrome[c] = eccSyndrome[c] ^  hammingData[i];
	    end
	 end else begin
	    for (i=(1'b1<<c)-1; i<TOTAL_BITS-1; i=i+(1'b1<<(c+1))) begin
	       for (j=0; (j<(1'b1<<c)) && ((i+j) < (TOTAL_BITS-1)); j=j+1) begin
		  eccSyndrome[c] = eccSyndrome[c] ^  hammingData[i+j];
	       end
	    end
	 end // else: !if(c==0)
      end // for (c=0; c<(CODEWIDTH-1); c=c+1)
      eccSyndrome[CODEWIDTH-1] = ^{eccSyndrome[CODEWIDTH-2:0], rawDataIn};
   end // always @ (*)

   assign eccOut  = (protOverride & ~hwActive) ? eccSyndromeIn : eccSyndrome;
   assign dataOut = rawDataIn ^ { {(WIDTH-1) {1'b0}}, (protOverride & hwActive)};

   assign eccDataOut = {eccOut, dataOut};
      
`endif
   
endmodule // CapEccGen

	
       
//
//$Log: CapEccGen.v,v $
//Revision 1.2  2013/07/04 00:07:12  gregries
//* fix multiple assign issue in CapEccGen.v (was same assign repeating in
//  loop, only spyglass cares)
//* waive stupidity about combining seq and comb state machine in one always,
//  irrelevant if all statments are nonblocking setting of registers
//* waive logcal not stupidity for BCAM and TCAM wrappers
//
//Revision 1.1  2013/01/31 03:10:12  abhasin2
//Adding files to dglobal used for memory instantiation in cray
//
//Revision 4.1  2012/03/13 22:25:42  rvish
//initial checkin for dopplerd with name changes. 4 tests fail in commit_regress - JtagDeviceIdJtagChipVTest, commitRtsCsmTestArray, PuzzleCoreEmulFlistTest and PlcResolutionBasicPlcTest
//
//Revision 4.0  2012/03/11 07:02:42  glambida
//Incrementing revision to 4.0
//
//Revision 3.1  2011/01/13 21:00:48  abbanerj
//global replace of doppler with dopplerd
//
//Revision 3.0  2011/01/13 19:53:21  abbanerj
//initial checkin for dopplerdcs.  start from version 3.0
//
//Revision 1.8  2010/02/19 03:07:48  gregries
//For Cap:
//- changed to not assert syndrome capture on R-M-W with protoverride set
//- changed behavior of hw write with protoverride set to inject 1-bit error
//- delay start of BIP gen if startBipCheck is clear
//
//For Nfl:
//- take in new CapTransactor required for above Cap changes
//- move 1-port FIFOs over to a custom one based on clock-gated pipeline mode
//- fix some unused, floating signals
//
//Revision 1.7  2009/10/06 22:08:22  gregries
//* fix misuse of parameter keyword
//
//Revision 1.6  2009/03/05 17:38:54  olicht
//IZ#2948: cosim performance :add hooks to eliminate parity,ecc,elam inside cap wrappers
//
//Revision 1.5  2008/06/05 13:58:58  sanam
//Spyglass issue work around
//
//Revision 1.4  2008/04/17 20:27:27  sanam
//Fixed interleaving index issues
//
//Revision 1.3  2008/04/14 21:01:14  sanam
//Corrected Indexing for the last ECC code bit with partial XOR cloud
//
//Revision 1.2  2008/04/02 15:04:42  sanam
//Spyglass Fixes
//
//Revision 1.1  2008/03/25 04:53:53  sanam
//Initial Check in For CAP Wrappers
//
//
