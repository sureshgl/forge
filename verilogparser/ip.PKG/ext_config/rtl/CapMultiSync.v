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
// File          : CapMultiSync
// Author        : Rakesh Sanam
// Description   : Pipelining module
// $Heading$
//
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps


module CapMultiSync
   #(parameter WIDTH  = 8,
     parameter stages = 2
     )
   (
    input  wire                 clk,
    input  wire                 reset,
    
    input  wire [WIDTH-1:0] 	dataIn,
    output wire [WIDTH-1:0] 	dataOut
    );

   localparam LOCAL_STAGES = (stages < 1) ? 1 : stages;

   reg  [(WIDTH*LOCAL_STAGES)-1:0]     dataInFF;
   wire [(WIDTH*LOCAL_STAGES)-1:0]     nextDataInFF;

   genvar i;
   generate
      if (stages > 0) begin
         always @(posedge clk) begin
            dataInFF <= (reset) ? {(WIDTH*LOCAL_STAGES) {1'b0}} : nextDataInFF;
         end

         if (stages > 1) begin
            assign nextDataInFF = {dataIn, dataInFF[(WIDTH*LOCAL_STAGES)-1:WIDTH]};
         end else begin
            assign nextDataInFF = dataIn;
         end

	 assign dataOut = dataInFF[WIDTH-1:0];

      end else begin
	 assign dataOut = dataIn;
      end
      
   endgenerate

endmodule // CapMultiSync

    
//
//$Log: CapMultiSync.v,v $
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
//Revision 1.3  2010/10/29 01:38:47  gregries
//* improve coding:
//  * eliminate verilog "memory" coding style
//  * eliminate multiple always blocks touching same identifier (diff bits)
//  * make code more straight-forward
//
//Revision 1.2  2008/05/16 22:00:33  sanam
//Fixed Cpu Controller/FSM handshaking for CPU getting immediate access with zero Read Latency
//
//Revision 1.1  2008/03/25 04:53:56  sanam
//Initial Check in For CAP Wrappers
//
//
