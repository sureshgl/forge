/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

interface L2_M_Ifc #(int BITADDR=34, int BITDATA=512, int BITSEQN=16, int NUMBYLN=64, int XBITATR=3) (input clk);


  logic                reqRd;
  logic                reqWr;
  logic                reqInv;
  logic [BITSEQN-1:0]  reqSeq;
  logic [BITADDR-1:0]  reqAddr;
  logic [BITDATA-1:0]  reqDin;
  logic [NUMBYLN-1:0]  reqByteEn;
  logic                reqStall;
  
  logic                rspRd;
  logic                rspWr;
  logic                rspInv;
  logic [BITSEQN-1:0]  rspSeq;
  logic [BITDATA-1:0]  rspDout;
  logic [XBITATR-1:0]  rspAttr;
  logic                rspStall;


  clocking cbMstDrv @(posedge clk);
     //default input #30 output #10;
  output  reqRd;
  output  reqWr;
  output  reqInv;
  output  reqSeq;
  output  reqAddr;
  output  reqDin;
  output  reqByteEn;
  input   reqStall;
  
  input   rspRd;
  input   rspWr;
  input   rspInv;
  input   rspSeq;
  input   rspDout;
  input   rspAttr;
  inout   rspStall;

  endclocking

  clocking cbMstMon @(posedge clk);
     //default input #30 output #10;
  input   reqRd;
  input   reqWr;
  input   reqInv;
  input   reqSeq;
  input   reqAddr;
  input   reqDin;
  input   reqByteEn;
  input   reqStall;
  
  input   rspRd;
  input   rspWr;
  input   rspInv;
  input   rspSeq;
  input   rspDout;
  input   rspAttr;
  input   rspStall;

  endclocking

endinterface

interface L2_S_Ifc #(int BITADDR=34, int BITDATA=512, int BITSEQN=16, int NUMBYLN=64, int XBITATR=3) (input clk);


  logic                reqRd;
  logic                reqWr;
  logic [BITSEQN-1:0]  reqSeq;
  logic [BITADDR-1:0]  reqAddr;
  logic [BITDATA-1:0]  reqDin;
  logic                reqStall;
  
  logic                rspVld;
  logic [BITSEQN-1:0]  rspSeq;
  logic [BITDATA-1:0]  rspDout;
  logic [XBITATR-1:0]  rspAttr;
  logic                rspStall;





  clocking cbSlvDrv @(posedge clk);
     //default input #30 output #10;
  input                reqRd;
  input                reqWr;
  input                reqSeq;
  input                reqAddr;
  input                reqDin;
  inout                reqStall;
  
  output                rspVld;
  output                rspSeq;
  output                rspDout;
  output                rspAttr;
  input                 rspStall;


  endclocking

  clocking cbSlvMon @(posedge clk);
     //default input #30 output #10;
  input   reqRd;
  input   reqWr;
  input   reqSeq;
  input   reqAddr;
  input   reqDin;
  input   reqStall;
  
  input  rspVld;
  input  rspSeq;
  input  rspDout;
  input  rspAttr;
  input  rspStall;

  endclocking 
endinterface

