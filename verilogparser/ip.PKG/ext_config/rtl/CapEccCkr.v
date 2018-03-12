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
// File          : CapEccCkr
// Author        : Rakesh Sanam
// Description   : ECC Checker and Corrector
// $Header: /auto/dsbu-asic-core/dglobal/MASTER/common/rtl/CapEccCkr.v,v 1.1 2013/01/31 03:10:12 abhasin2 Exp $
//
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ns

module CapEccCkr
   #(parameter WIDTH     = 17,
     parameter CODEWIDTH = 6 
     )
   ( 
    input  wire  [WIDTH+CODEWIDTH-1:0]  eccDataIn,
    input  wire                         protChkDisable, 
    output wire  [WIDTH-1:0]            rawDataOut,
    output wire  [CODEWIDTH-1:0]        eccSyndromeOut,
    output wire                         eccCorErr,
    output wire                         eccUncErr
     );
   
`ifdef CAP_ECC_GLOBAL_BYPASS

    assign rawDataOut = eccDataIn[WIDTH-1:0];
    assign eccSyndromeOut = {CODEWIDTH{1'b0}};
    assign eccCorErr = 1'b0;
    assign eccUncErr = 1'b0;

`else

   function integer dataIdx;
      input [31:0] value;
      reg [31:0] v;
      reg [31:0] log2;
      begin
         // dataIdx = value - log2(value+1)
         // get log2(value+1)
         v = value;
         for (log2=0; v>0; log2=log2+1) v = v>>1;
         dataIdx = value - log2;
      end
   endfunction
  
   localparam totalBits = WIDTH+CODEWIDTH;

   integer                c, i, j;
   wire [totalBits-1:0]   hammingData;
   reg  [CODEWIDTH-1:0]   ckrEccSyndrome;
   reg  [totalBits-1:0]   hammingCorData;
   wire [CODEWIDTH-1:0]   eccSyndromeIn;
   wire                   overAllParity;
   wire [WIDTH-1:0]       rawDataOutTemp;
   assign                 eccSyndromeIn = eccDataIn[WIDTH+CODEWIDTH-1:WIDTH];
   
   //Generate Code and Data Interleaved Bits to Create Hamming Word
   generate
      genvar            tangleVar;
      assign hammingData[1:0]         = eccSyndromeIn[1:0];
      assign hammingData[totalBits-1] = eccSyndromeIn[CODEWIDTH-1];
      for (tangleVar=2; tangleVar < (totalBits-1); tangleVar=tangleVar+1) begin : inteleaveECC
         case (tangleVar)
            32'h0000_0003 : assign hammingData[tangleVar] = eccSyndromeIn[2];
            32'h0000_0007 : assign hammingData[tangleVar] = eccSyndromeIn[3];
            32'h0000_000f : assign hammingData[tangleVar] = eccSyndromeIn[4];
            32'h0000_001f : assign hammingData[tangleVar] = eccSyndromeIn[5];
            32'h0000_003f : assign hammingData[tangleVar] = eccSyndromeIn[6];
            32'h0000_007f : assign hammingData[tangleVar] = eccSyndromeIn[7];
            32'h0000_00ff : assign hammingData[tangleVar] = eccSyndromeIn[8];
            32'h0000_01ff : assign hammingData[tangleVar] = eccSyndromeIn[9];
            32'h0000_03ff : assign hammingData[tangleVar] = eccSyndromeIn[10];
            32'h0000_07ff : assign hammingData[tangleVar] = eccSyndromeIn[11];
            32'h0000_0fff : assign hammingData[tangleVar] = eccSyndromeIn[12];
            32'h0000_1fff : assign hammingData[tangleVar] = eccSyndromeIn[13];
            32'h0000_3fff : assign hammingData[tangleVar] = eccSyndromeIn[14];
            32'h0000_7fff : assign hammingData[tangleVar] = eccSyndromeIn[15];
            32'h0000_ffff : assign hammingData[tangleVar] = eccSyndromeIn[16];
            32'h0001_ffff : assign hammingData[tangleVar] = eccSyndromeIn[17];
            32'h0003_ffff : assign hammingData[tangleVar] = eccSyndromeIn[18];
            32'h0007_ffff : assign hammingData[tangleVar] = eccSyndromeIn[19];
            32'h000f_ffff : assign hammingData[tangleVar] = eccSyndromeIn[20];
            32'h001f_ffff : assign hammingData[tangleVar] = eccSyndromeIn[21];
            32'h003f_ffff : assign hammingData[tangleVar] = eccSyndromeIn[22];
            32'h007f_ffff : assign hammingData[tangleVar] = eccSyndromeIn[23];
            32'h00ff_ffff : assign hammingData[tangleVar] = eccSyndromeIn[24];
            32'h01ff_ffff : assign hammingData[tangleVar] = eccSyndromeIn[25];
            32'h03ff_ffff : assign hammingData[tangleVar] = eccSyndromeIn[26];
            32'h07ff_ffff : assign hammingData[tangleVar] = eccSyndromeIn[27];
            32'h0fff_ffff : assign hammingData[tangleVar] = eccSyndromeIn[28];
            32'h1fff_ffff : assign hammingData[tangleVar] = eccSyndromeIn[29];
            32'h3fff_ffff : assign hammingData[tangleVar] = eccSyndromeIn[30];
            32'h7fff_ffff : assign hammingData[tangleVar] = eccSyndromeIn[31];
            default       : assign hammingData[tangleVar] = eccDataIn[dataIdx(tangleVar)];
         endcase // case (sweepvar)
      end
   endgenerate
       
   assign overAllParity = ^(hammingData[totalBits-2:0]);
   
   always @ (*)
   begin
      ckrEccSyndrome[CODEWIDTH-1] = overAllParity ^ hammingData[totalBits-1];
      ckrEccSyndrome[CODEWIDTH-2:0] = {(CODEWIDTH-1) {1'b0}};
      for (c=0; c < (CODEWIDTH-1); c=c+1) begin
         if (c==0) begin
            for (i=0; i<totalBits-1; i=i+2) begin
               ckrEccSyndrome[c]    = ckrEccSyndrome[c] ^  hammingData[i];
            end
         end else begin
            for (i=(1'b1<<c)-1; i<totalBits-1; i=i+(1'b1<<(c+1))) begin
               for (j=0; (j<(1'b1<<c)) && ((i+j) < (totalBits-1)); j=j+1) begin
                  ckrEccSyndrome[c] = ckrEccSyndrome[c] ^  hammingData[i+j];
               end
            end
         end // else: !if(c==0)
      end 
   end // always @ (*)

   assign eccCorErr     = ckrEccSyndrome[CODEWIDTH-1] & ~protChkDisable;
   assign eccUncErr     = ~ckrEccSyndrome[CODEWIDTH-1] & (|ckrEccSyndrome[CODEWIDTH-2:0]) &
                          ~protChkDisable;
   

  always @ (*) begin
     hammingCorData = hammingData;
     if (eccCorErr)
        hammingCorData[ckrEccSyndrome[CODEWIDTH-2:0]-1] =
           !hammingData[ckrEccSyndrome[CODEWIDTH-2:0]-1];
  end
  
   //Pick Data bits off of the Hamming word
   generate
      assign rawDataOutTemp[0] = hammingCorData[2];

      if (totalBits >= 6) begin
         if (totalBits <= 8)
            assign rawDataOutTemp[totalBits-5:1] = hammingCorData[totalBits-2:4];
         else
            assign rawDataOutTemp[3:1] = hammingCorData[6:4];
      end

      if (totalBits >= 10) begin
         if (totalBits <= 16)
            assign rawDataOutTemp[totalBits-6:4] = hammingCorData[totalBits-2:8];
         else
            assign rawDataOutTemp[10:4] = hammingCorData[14:8];
      end

      if (totalBits >= 18) begin
         if (totalBits <= 32)
            assign rawDataOutTemp[totalBits-7:11] = hammingCorData[totalBits-2:16];
         else
            assign rawDataOutTemp[25:11] = hammingCorData[30:16];
      end

      if (totalBits >= 34) begin
         if (totalBits <= 64)
            assign rawDataOutTemp[totalBits-8:26] = hammingCorData[totalBits-2:32];
         else
            assign rawDataOutTemp[56:26] = hammingCorData[62:32];
      end

      if (totalBits >= 66) begin
         if (totalBits <= 128)
            assign rawDataOutTemp[totalBits-9:57] = hammingCorData[totalBits-2:64];
         else
            assign rawDataOutTemp[119:57] = hammingCorData[126:64];
      end

      if (totalBits >= 130) begin
         if (totalBits <= 256)
            assign rawDataOutTemp[totalBits-10:120] = hammingCorData[totalBits-2:128];
         else
            assign rawDataOutTemp[246:120] = hammingCorData[254:128];
      end

      if (totalBits >= 258) begin
         if (totalBits <= 512)
            assign rawDataOutTemp[totalBits-11:247] = hammingCorData[totalBits-2:256];
         else
            assign rawDataOutTemp[501:247] = hammingCorData[510:256];
      end

      if (totalBits >= 514) begin
         if (totalBits <= 1024)
            assign rawDataOutTemp[totalBits-12:502] = hammingCorData[totalBits-2:512];
         else
            assign rawDataOutTemp[1012:502] = hammingCorData[1022:512];
      end

      if (totalBits >= 1026) begin
         if (totalBits <= 2048)
            assign rawDataOutTemp[totalBits-13:1013] = hammingCorData[totalBits-2:1024];
         else
            assign rawDataOutTemp[2035:1013] = hammingCorData[2046:1024];
      end

      // stop here because max memory is 2048 bits wide, and this already goes past
      if (totalBits >= 2050) begin
         if (totalBits <= 4096)
            assign rawDataOutTemp[totalBits-14:2036] = hammingCorData[totalBits-2:2048];
         else
            assign rawDataOutTemp[4082:2036] = hammingCorData[4094:2048];
      end
   endgenerate

   assign rawDataOut     = rawDataOutTemp;
   assign eccSyndromeOut = ckrEccSyndrome;
   
`endif

endmodule // CapEccGen


//
//$Log: CapEccCkr.v,v $
//Revision 1.1  2013/01/31 03:10:12  abhasin2
//Adding files to dglobal used for memory instantiation in cray
//
//Revision 4.4  2012/10/11 07:49:01  mrunal
//   copied over files from DopplerCSR branch to DopplerD, resolved compile error due to st_cmos32lp define usage, merged dopplerd and dopplercsr's memories.wrap.xml, except Cosim Test commit_regress passed fully
//
//Revision 4.3  2012/04/17 01:36:04  gregries
//* brough over changes from dopplerd to work around dclint bug that gave
//  an error message for non-constant function where function was constant
//
//Revision 4.2  2012/04/12 19:09:30  gregries
//* brought over changes from DopplerD to remove LINT-[FIAAS] messages
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
//Revision 1.11  2009/09/29 02:28:50  gregries
//* removed ckrEccSyndrome[CODEWIDTH-1] from correction indexing since that
//  shouldn't be used to select the value.  It was OK to include it in past
//  versions since it used to be always 0.  Once it was changed to have the
//  proper syndrome value, however, it was no longer harmless to include it
//  in the indexing operation.
//
//Revision 1.10  2009/06/12 02:12:16  gregries
//* eccSyndromeOut changed; now (storedEcc ^ recalculatedEcc)
//  before: it was the stored ecc bits
//
//Revision 1.9  2009/04/23 20:36:31  gregries
//* extend protChkDisable use to include eccUncErr
//
//Revision 1.8  2009/03/05 17:38:54  olicht
//IZ#2948: cosim performance :add hooks to eliminate parity,ecc,elam inside cap wrappers
//
//Revision 1.7  2008/06/06 16:30:24  sanam
//Made the missing connection for Overall Parity Bit
//
//Revision 1.6  2008/06/05 13:58:57  sanam
//Spygalss issue Work around
//
//Revision 1.5  2008/05/09 20:11:47  sanam
//Changed Syntax for indexing
//
//Revision 1.4  2008/05/08 03:59:37  sanam
//Added Protection Check Disable
//
//Revision 1.3  2008/04/17 20:27:27  sanam
//Fixed interleaving index issues
//
//Revision 1.2  2008/04/14 21:01:14  sanam
//Corrected Indexing for the last ECC code bit with partial XOR cloud
//
//Revision 1.1  2008/03/25 04:53:52  sanam
//Initial Check in For CAP Wrappers
//
//
