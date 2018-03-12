//////////////////////////////////////////////////////////////////////////////
// Copyright (c) 20011, Cisco Systems, Inc.
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
// File          : CepElamMux.v
// Author        : Greg Ries
// Description   : CEP Wrapper ELAM Mux for 2 control views and one data view
// $Header: /auto/dsbu-asic-core/dglobal/MASTER/common/rtl/CepElamMux.sv,v 1.1 2013/01/31 03:10:12 abhasin2 Exp $
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ns
`include "DGlobal.vh"
`include "Cep.vh"

module CepElamMux
#(
   parameter    ELAMPIPELINE    = 0,
   parameter    ELAM_HAS_DOUT   = 1,
   parameter    ADDRESS_WIDTH   = 8,
   parameter    SYNDROME_WIDTH  = 1,
   parameter    EXTRA_CTL_WIDTH = 1
) (
   input  wire                                          sysClk,
   input  wire                                          sysReset,

   input  wire [(`CAP_BUSOUT_ELAMDATA0_WIDTH * 15)-1:0] elamDataIn,
   input  wire [(ADDRESS_WIDTH*6)-1:0]                  elamAddrIn,
   input  wire [`CAP_ALWAYS_PRESENT_RANGE]              elamAlwaysPresentIn,
   input  wire [EXTRA_CTL_WIDTH-1:0]                    elamExtraCtlIn,
   input  wire [SYNDROME_WIDTH-1:0]                     elamSyndrome0In,
   input  wire                                          elamErr0In,
   input  wire                                          elamCorrect0In,
   input  wire [SYNDROME_WIDTH-1:0]                     elamSyndrome1In,
   input  wire                                          elamErr1In,
   input  wire                                          elamCorrect1In,

   input  wire                                          elamViewEnable0,
   input  wire [`CAP_BUSIN_ELAMSELECT0_RANGE]           elamSel0,
   input  wire                                          elamCtlViewEnable0,
   input  wire [`CAP_BUSIN_ELAMCTLSELECT0_RANGE]        elamCtlSel0,
   input  wire                                          elamCtlViewEnable1,
   input  wire [`CAP_BUSIN_ELAMCTLSELECT1_RANGE]        elamCtlSel1,

   output wire [`CAP_BUSOUT_ELAMDATA0_RANGE] 	        elamData0,
   output wire [`CAP_BUSOUT_ELAMCTL0_RANGE]             elamControl0,
   output wire [`CAP_BUSOUT_ELAMCTL1_RANGE]             elamControl1
);           

localparam SYNDROME_ZERO_BITS = `CAP_CTL_REMAIN_SIZE - SYNDROME_WIDTH - 2;
localparam ADD_EXTRA_CTL = (ADDRESS_WIDTH < `CAP_CTL_REMAIN_SIZE);
localparam ADD_ZERO_CTL  = ( (ADDRESS_WIDTH + EXTRA_CTL_WIDTH) < `CAP_CTL_REMAIN_SIZE );
localparam EXTRA_CTL_BITS = `CAP_CTL_REMAIN_SIZE - ADDRESS_WIDTH;
localparam ZERO_CTL_BITS  = `CAP_CTL_REMAIN_SIZE - ADDRESS_WIDTH - EXTRA_CTL_WIDTH;
localparam ADDRESS_BITS   = (ADDRESS_WIDTH > `CAP_CTL_REMAIN_SIZE) ? `CAP_CTL_REMAIN_SIZE
                                                                   : ADDRESS_WIDTH;
localparam EXTRA_ZERO_CTL_WIDTH = (ADD_ZERO_CTL)  ? `CAP_CTL_REMAIN_SIZE - ADDRESS_WIDTH :
                                  (ADD_EXTRA_CTL) ? EXTRA_CTL_BITS
                                                  : 1;
localparam ALL_ADDRESS_ZERO_BITS = `CAP_BUSOUT_ELAMDATA0_WIDTH - (ADDRESS_WIDTH*6);

`ifdef COREDCM_CAP_CUSTOM_STUB
   // DV wants to drive elam outputs from tasks
   reg [`CAP_BUSOUT_ELAMCTL0_WIDTH-1:0]  dvElamControl0;
   reg [`CAP_BUSOUT_ELAMCTL0_WIDTH-1:0]  dvElamControl1;
   reg [`CAP_BUSOUT_ELAMDATA0_WIDTH-1:0] dvElamData0;

   function integer getWidthControl;
      begin
         getWidthControl = `CAP_BUSOUT_ELAMCTL0_WIDTH;
      end
   endfunction

   function integer getWidthData;
      begin
         getWidthData = `CAP_BUSOUT_ELAMDATA0_WIDTH;
      end
   endfunction

   function [`CAP_BUSOUT_ELAMCTL0_WIDTH-1:0] ReadWordControl;
      input sliceNum;
      begin
         ReadWordControl = (sliceNum) ? dvElamControl1 : dvElamControl0;
      end
   endfunction

   function [`CAP_BUSOUT_ELAMDATA0_WIDTH-1:0] ReadWordData;
      begin
         ReadWordData = dvElamData0;
      end
   endfunction

   task WriteWordControl;
      input                                  sliceNum;
      input [`CAP_BUSOUT_ELAMCTL0_WIDTH-1:0] dvElamControlIn;
      begin
         if (sliceNum) dvElamControl1 = dvElamControlIn;
         else dvElamControl0 = dvElamControlIn;
      end
   endtask

   task WriteWordData;
      input [`CAP_BUSOUT_ELAMDATA0_WIDTH-1:0] dvElamDataIn;
      begin
         dvElamData0 = dvElamDataIn;
      end
   endtask

   assign elamControl0 = dvElamControl0;
   assign elamControl1 = dvElamControl1;
   assign elamData0    = dvElamData0;

`else  // `ifdef COREDCM_CAP_CUSTOM_STUB

   wire [`CAP_BUSOUT_ELAMCTL0_RANGE]         elamControl0Local;
   wire [`CAP_BUSOUT_ELAMCTL1_RANGE]         elamControl1Local;
   reg  [`CAP_CTL_REMAIN_RANGE]              elamRemain0;
   reg  [`CAP_CTL_REMAIN_RANGE]              elamRemain1;
 
   wire [`CAP_BUSOUT_ELAMCTL0_RANGE]         elamControl0LocalQuiet;
   wire [`CAP_BUSOUT_ELAMCTL1_RANGE]         elamControl1LocalQuiet;

   wire [(`CAP_BUSOUT_ELAMCTL0_WIDTH*8)-1:0] elamRemainVec;
   wire [EXTRA_ZERO_CTL_WIDTH-1:0]           extraZeroCtl;

   reg  [`CAP_BUSOUT_ELAMDATA0_RANGE]        elamData0Local;
   wire [`CAP_BUSOUT_ELAMDATA0_RANGE]        elamData0LocalQuiet;

   reg  [`CAP_BUSIN_ELAMSELECT0_RANGE]       elamSel0Q;
   reg  [`CAP_BUSIN_ELAMCTLSELECT0_RANGE]    elamCtlSel0Q;
   reg  [`CAP_BUSIN_ELAMCTLSELECT1_RANGE]    elamCtlSel1Q;

   always @(posedge sysClk)
   begin
      elamCtlSel0Q        <= (elamCtlViewEnable0) ? elamCtlSel0 : elamCtlSel0Q;
      elamCtlSel1Q        <= (elamCtlViewEnable1) ? elamCtlSel1 : elamCtlSel1Q;
   end

   always @* begin
      case (elamCtlSel0Q)
         3'd0 : elamRemain0 = elamRemainVec[0 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE];
         3'd1 : elamRemain0 = elamRemainVec[1 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE];
         3'd2 : elamRemain0 = elamRemainVec[2 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE];
         3'd3 : elamRemain0 = elamRemainVec[3 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE];
         3'd4 : elamRemain0 = elamRemainVec[4 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE];
         3'd5 : elamRemain0 = elamRemainVec[5 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE];
         3'd6 : elamRemain0 = elamRemainVec[6 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE];
         3'd7 : elamRemain0 = elamRemainVec[7 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE];
         default : elamRemain0 = {`CAP_CTL_REMAIN_SIZE {1'bx}};
      endcase
   end

   always @* begin
      case (elamCtlSel1Q)
         3'd0 : elamRemain1 = elamRemainVec[0 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE];
         3'd1 : elamRemain1 = elamRemainVec[1 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE];
         3'd2 : elamRemain1 = elamRemainVec[2 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE];
         3'd3 : elamRemain1 = elamRemainVec[3 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE];
         3'd4 : elamRemain1 = elamRemainVec[4 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE];
         3'd5 : elamRemain1 = elamRemainVec[5 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE];
         3'd6 : elamRemain1 = elamRemainVec[6 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE];
         3'd7 : elamRemain1 = elamRemainVec[7 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE];
         default : elamRemain1 = {`CAP_CTL_REMAIN_SIZE {1'bx}};
      endcase
   end

   assign elamControl0Local = {elamAlwaysPresentIn, elamRemain0};
   assign elamControl1Local = {elamAlwaysPresentIn, elamRemain1};

   `ifdef DONTUSEFORNOW
      vendor_and2 QuietElamControl0[`CAP_BUSOUT_ELAMCTL0_WIDTH-1:0]
      (
         .ina (elamControl0Local),
         .inb (elamCtlViewEnable0),
         .out (elamControl0LocalQuiet)
      );
     
      vendor_and2 QuietElamControl1[`CAP_BUSOUT_ELAMCTL1_WIDTH-1:0]
      (
         .ina (elamControl1Local),
         .inb (elamCtlViewEnable1),
         .out (elamControl1LocalQuiet)
      );
   `else // !`ifdef DONTUSEFORNOW

      assign elamControl0LocalQuiet = elamControl0Local &
                                      {`CAP_BUSOUT_ELAMCTL0_WIDTH {elamCtlViewEnable0}};
      assign elamControl1LocalQuiet = elamControl1Local &
                                      {`CAP_BUSOUT_ELAMCTL1_WIDTH {elamCtlViewEnable1}};
   `endif // !`ifdef DONTUSEFORNOW

   generate
      if (ADD_ZERO_CTL)
      begin
         assign extraZeroCtl = { elamExtraCtlIn, {ZERO_CTL_BITS {1'b0}} };
      end else if (ADD_EXTRA_CTL) begin
         assign extraZeroCtl = elamExtraCtlIn[EXTRA_CTL_WIDTH-1 -: EXTRA_CTL_BITS];
      end

      assign elamRemainVec[0 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE] =
                { elamErr0In, elamCorrect0In, {SYNDROME_ZERO_BITS {1'b0}}, elamSyndrome0In };
      assign elamRemainVec[7 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE] =
                { elamErr1In, elamCorrect1In, {SYNDROME_ZERO_BITS {1'b0}}, elamSyndrome1In };

      // there are 6 address views; pack them with the addition mem ctl bits
      if (ADD_ZERO_CTL || ADD_EXTRA_CTL)
      begin
         assign elamRemainVec[1 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE] =
                   {extraZeroCtl, elamAddrIn[0 * ADDRESS_WIDTH +: ADDRESS_WIDTH]};
         assign elamRemainVec[2 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE] =
                   {extraZeroCtl, elamAddrIn[1 * ADDRESS_WIDTH +: ADDRESS_WIDTH]};
         assign elamRemainVec[3 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE] =
                   {extraZeroCtl, elamAddrIn[2 * ADDRESS_WIDTH +: ADDRESS_WIDTH]};
         assign elamRemainVec[4 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE] =
                   {extraZeroCtl, elamAddrIn[3 * ADDRESS_WIDTH +: ADDRESS_WIDTH]};
         assign elamRemainVec[5 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE] =
                   {extraZeroCtl, elamAddrIn[4 * ADDRESS_WIDTH +: ADDRESS_WIDTH]};
         assign elamRemainVec[6 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE] =
                   {extraZeroCtl, elamAddrIn[5 * ADDRESS_WIDTH +: ADDRESS_WIDTH]};
      end else begin
         assign elamRemainVec[1 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE] =
                   elamAddrIn[0 * ADDRESS_WIDTH +: ADDRESS_BITS];
         assign elamRemainVec[2 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE] =
                   elamAddrIn[1 * ADDRESS_WIDTH +: ADDRESS_BITS];
         assign elamRemainVec[3 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE] =
                   elamAddrIn[2 * ADDRESS_WIDTH +: ADDRESS_BITS];
         assign elamRemainVec[4 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE] =
                   elamAddrIn[3 * ADDRESS_WIDTH +: ADDRESS_BITS];
         assign elamRemainVec[5 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE] =
                   elamAddrIn[4 * ADDRESS_WIDTH +: ADDRESS_BITS];
         assign elamRemainVec[6 * `CAP_CTL_REMAIN_SIZE +: `CAP_CTL_REMAIN_SIZE] =
                   elamAddrIn[5 * ADDRESS_WIDTH +: ADDRESS_BITS];
      end

      if (ELAM_HAS_DOUT)
      begin
         always @(posedge sysClk)
         begin
            elamSel0Q        <= (elamViewEnable0) ? elamSel0 : elamSel0Q;
         end

         always @* begin
            case (elamSel0Q)
               4'd0  : elamData0Local = elamDataIn[0  * 128 +: 128];
               4'd1  : elamData0Local = elamDataIn[1  * 128 +: 128];
               4'd2  : elamData0Local = elamDataIn[2  * 128 +: 128];
               4'd3  : elamData0Local = elamDataIn[3  * 128 +: 128];
               4'd4  : elamData0Local = elamDataIn[4  * 128 +: 128];
               4'd5  : elamData0Local = elamDataIn[5  * 128 +: 128];
               4'd6  : elamData0Local = elamDataIn[6  * 128 +: 128];
               4'd7  : elamData0Local = elamDataIn[7  * 128 +: 128];
               4'd8  : elamData0Local = elamDataIn[8  * 128 +: 128];
               4'd9  : elamData0Local = elamDataIn[9  * 128 +: 128];
               4'd10 : elamData0Local = elamDataIn[10 * 128 +: 128];
               4'd11 : elamData0Local = elamDataIn[11 * 128 +: 128];
               4'd12 : elamData0Local = elamDataIn[12 * 128 +: 128];
               4'd13 : elamData0Local = elamDataIn[13 * 128 +: 128];
               4'd14 : elamData0Local = elamDataIn[14 * 128 +: 128];
               4'd15 : elamData0Local = { {ALL_ADDRESS_ZERO_BITS {1'b0}}, elamAddrIn };
               default : elamData0Local = {`CAP_BUSOUT_ELAMDATA0_WIDTH {1'bx}};
            endcase
         end

   `ifdef DONTUSEFORNOW
         vendor_and2 QuietElamData0[`CAP_BUSOUT_ELAMDATA0_WIDTH-1:0]
         (
            .ina (elamData0Local),
            .inb (elamViewEnable0),
            .out (elamData0LocalQuiet)
         );
   `else // !`ifdef DONTUSEFORNOW
         assign elamData0LocalQuiet = elamData0Local &
                                      {`CAP_BUSOUT_ELAMDATA0_WIDTH {elamViewEnable0}};
   `endif // !`ifdef DONTUSEFORNOW

         if (ELAMPIPELINE)
         begin
            reg [`CAP_BUSOUT_ELAMDATA0_RANGE] elamData0LocalQuietD1Q;
            reg                               elamViewEnable0D1Q;
 
            always @ (posedge sysClk)
            begin
               // add one extra cycle to enable to turn buss off again
               // after view enable goes away
               elamViewEnable0D1Q     <= elamViewEnable0;
               elamData0LocalQuietD1Q <= (elamViewEnable0D1Q | elamViewEnable0 | sysReset)
                                            ? elamData0LocalQuiet : elamData0LocalQuietD1Q;
            end

            assign elamData0 = elamData0LocalQuietD1Q;
         end else begin
            assign elamData0 = elamData0LocalQuiet;
         end

      end else begin  // if (ELAM_HAS_DOUT)
         assign elamData0 = {`CAP_BUSOUT_ELAMDATA0_WIDTH {1'b0}};
      end  // !if (ELAM_HAS_DOUT)

      if (ELAMPIPELINE) begin
         reg [`CAP_BUSOUT_ELAMCTL0_RANGE] elamControl0LocalQuietD1Q;
         reg [`CAP_BUSOUT_ELAMCTL0_RANGE] elamControl1LocalQuietD1Q;
         reg                              elamCtlViewEnable0D1Q;
         reg                              elamCtlViewEnable1D1Q;
         always @ (posedge sysClk)
         begin
            // add one extra cycle to enable to turn buss off again
            // after view enable goes away
            elamCtlViewEnable0D1Q     <= elamCtlViewEnable0;
            elamCtlViewEnable1D1Q     <= elamCtlViewEnable1;
            elamControl0LocalQuietD1Q <= (elamCtlViewEnable0 | elamCtlViewEnable0D1Q |
                                          sysReset)
                                            ? elamControl0LocalQuiet
                                            : elamControl0LocalQuietD1Q;
            elamControl1LocalQuietD1Q <= (elamCtlViewEnable1 | elamCtlViewEnable1D1Q |
                                          sysReset)
                                            ? elamControl1LocalQuiet
                                            : elamControl1LocalQuietD1Q;
         end
         assign elamControl0 = elamControl0LocalQuietD1Q;
         assign elamControl1 = elamControl1LocalQuietD1Q;
      end else begin
         assign elamControl0 = elamControl0LocalQuiet;
         assign elamControl1 = elamControl1LocalQuiet;
      end
   endgenerate

`endif  // !ifdef COREDCM_CAP_CUSTOM_STUB

endmodule // CepElamMux

