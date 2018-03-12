///////////////////////////////////////////////////////////////////
// Copyright (c) 2005, Cisco Systems, Inc.                         
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
////////////////////////////////////////////////////////////////////
//      Created By:     adapted from CapElamDownload by Greg Ries
//
//      CVS Header:     $Header: /auto/dsbu-asic-core/dglobal/MASTER/common/rtl/CapNewElamDownload.v,v 1.1 2013/01/31 03:10:12 abhasin2 Exp $
///////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module CapNewElamDownload
#(
   parameter ADDRESS_WIDTH   = 4,
   parameter DEPTH           = 16, 
   parameter PROT_PHYS_WIDTH = 128
) (
   input  wire                       CLK,
   input  wire                       sysReset,

   input  wire                       readToElam,
   input  wire                       sysHalt,

   output reg                        dwnldActiveQ,

   output wire                       dwnldSelN,
   output wire                       dwnldCsN,
   output wire                       dwnldWeN,
   output wire [ADDRESS_WIDTH-1:0]   dwnldA,
   output wire                       dwnldReN
);

reg  [ADDRESS_WIDTH-1:0] addrCounterQ;
wire                     downloadStart;

always @(posedge CLK)
begin
   dwnldActiveQ <= (sysReset)                                    ? 1'b0 :
                   ( dwnldActiveQ & (addrCounterQ >= DEPTH-1) )  ? 1'b0 :
                   (downloadStart)                               ? 1'b1
                                                                 : dwnldActiveQ;

   addrCounterQ <= (sysReset)      ? {ADDRESS_WIDTH {1'b0}} :
                   (dwnldActiveQ)  ? addrCounterQ + { {(ADDRESS_WIDTH-1) {1'b0}}, 1'b1 } :
                   (downloadStart) ? {ADDRESS_WIDTH {1'b0}}
                                   : addrCounterQ;
end

assign downloadStart = readToElam & sysHalt;

assign dwnldSelN   =  ~dwnldActiveQ;
assign dwnldCsN    =  ~dwnldActiveQ;
assign dwnldWeN    =  1'b1;
assign dwnldA      =  addrCounterQ;      
assign dwnldReN    =  1'b0;

endmodule // CapNewElamDownload

//
// $Log: CapNewElamDownload.v,v $
// Revision 1.1  2013/01/31 03:10:12  abhasin2
// Adding files to dglobal used for memory instantiation in cray
//
// Revision 4.1  2012/03/13 22:25:42  rvish
// initial checkin for dopplerd with name changes. 4 tests fail in commit_regress - JtagDeviceIdJtagChipVTest, commitRtsCsmTestArray, PuzzleCoreEmulFlistTest and PlcResolutionBasicPlcTest
//
// Revision 4.0  2012/03/11 07:02:42  glambida
// Incrementing revision to 4.0
//
// Revision 3.1  2011/01/13 21:00:48  abbanerj
// global replace of doppler with dopplerd
//
// Revision 3.0  2011/01/13 19:53:21  abbanerj
// initial checkin for dopplerdcs.  start from version 3.0
//
// Revision 1.2  2009/04/15 20:53:20  gregries
// * rewrite of Cap wrappers (90%)
// * improved bursting scheme along with burst bug fixes
// * optimization of sup/hw arbitration and some flop savings
// * support of hwAtomic and hwPriorityOverride
// * support of bypassing to make accesses atomic
// * support of READ-CLEAR for statistics offload
// * registering of all signals before use by ELAM--DIN no longer going to
//   ELAM to avoid adding too many flops
// * fix of BIP bugs
// * addition of NO_HARDWARE_WRITES parameter to TCAMS and BCAMS to optimize
//   DIN timing in the case that sup is the only agent that writes
// * addition of CAP_DOUT_PIPE and CAP_DOUT_PIPE_CLOCK_GATE parameters to
//   add a pipe stage to DOUT in the Cap Wrapper (as opposed to inside the
//   generic memory) and then to optionally clock-gate that register to
//   change only when hardware reads (as opposed to sup reads).
//
//
