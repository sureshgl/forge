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
// File          : CapParityGen
// Author        : Rakesh Sanam
// Description   : Parity Generator
// $Heading$
//
//
//////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ns

module CapParityGen 
   #(parameter WIDTH =8)
   ( 
    input  wire [WIDTH-1:0]                rawDataIn,
    input  wire                            hwActive,
    input  wire [0:0]                      paritySyndromeIn,
    input  wire                            protOverride,
     
    output wire [WIDTH:0]                  parityDataOut
   );

`ifdef CAP_PARITY_GLOBAL_BYPASS

   assign parityDataOut = {1'b0, rawDataIn};

`else

   wire             parityOut;
   wire [WIDTH-1:0] dataOut;

   assign parityOut = (protOverride & ~hwActive) ? paritySyndromeIn : ^rawDataIn;
   assign dataOut = rawDataIn ^ { {(WIDTH-1) {1'b0}}, (protOverride & hwActive)};

   assign parityDataOut = {parityOut, dataOut};
      
`endif
   
endmodule // CapParityGen


        
       
//
//$Log: CapParityGen.v,v $
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
//Revision 1.3  2010/02/19 03:07:48  gregries
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
//Revision 1.2  2009/03/05 17:38:54  olicht
//IZ#2948: cosim performance :add hooks to eliminate parity,ecc,elam inside cap wrappers
//
//Revision 1.1  2008/03/25 04:53:58  sanam
//Initial Check in For CAP Wrappers
//
//
