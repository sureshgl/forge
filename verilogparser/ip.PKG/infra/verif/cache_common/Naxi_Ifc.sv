/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

interface Naxi_Ifc #(int NXADDRWIDTH=31, int NXDATAWIDTH=256, int NXIDWIDTH=4, int NXTYPEWIDTH=3, int NXSIZEWIDTH=8, int NXATTRWIDTH=3) (input clk);


  logic [NXADDRWIDTH-1:0]  creqAddr;
  logic [NXATTRWIDTH-1:0]  creqAttr;
  logic [NXSIZEWIDTH-1:0]  creqSize;
  logic [NXIDWIDTH-1:0]    creqId;
  logic [NXTYPEWIDTH-1:0]  creqType;
  logic                    creqValid;
  logic                    creqRdStall;
  logic                    creqWrStall;
  
  logic [NXDATAWIDTH-1:0]  dreqData;
  logic [NXATTRWIDTH-1:0]  dreqAttr;
  logic [NXIDWIDTH-1:0]    dreqId;
  logic                    dreqValid;
  logic                    dreqStall;

  logic [NXDATAWIDTH-1:0]  rreqData;
  logic [NXATTRWIDTH-1:0]  rreqAttr;
  logic [NXIDWIDTH-1:0]    rreqId;
  logic                    rreqValid;
  logic                    rreqStall;


  clocking cbMstDrv @(posedge clk);
     //default input #30 output #10;

     output  creqAddr;
     output  creqAttr;
     output  creqSize;
     output  creqId;
     output  creqType;
     output  creqValid;
     input   creqRdStall;
     input   creqWrStall;
     
     output  dreqData;
     output  dreqAttr;
     output  dreqId;
     output  dreqValid;
     input   dreqStall;

     input  rreqData;
     input  rreqAttr;
     input  rreqId;
     input  rreqValid;
     output  rreqStall;

  endclocking

  clocking cbMstMon @(posedge clk);
     //default input #30 output #10;
     
     input  creqAddr;
     input  creqAttr;
     input  creqSize;
     input  creqId;
     input  creqType;
     input  creqValid;
     input  creqRdStall;
     input  creqWrStall;
     
     input  dreqData;
     input  dreqAttr;
     input  dreqId;
     input  dreqValid;
     input  dreqStall;

     input  rreqData;
     input  rreqAttr;
     input  rreqId;
     input  rreqValid;
     input  rreqStall;

  endclocking 


  clocking cbSlvDrv @(posedge clk);
     //default input #30 output #10;

     input  creqAddr;
     input  creqAttr;
     input  creqSize;
     input  creqId;
     input  creqType;
     input  creqValid;
     inout creqRdStall;
     inout creqWrStall;
     
     input  dreqData;
     input  dreqAttr;
     input  dreqId;
     input  dreqValid;
     inout dreqStall;

     output  rreqData;
     output  rreqAttr;
     output  rreqId;
     output  rreqValid;
     input   rreqStall;

  endclocking

  clocking cbSlvMon @(posedge clk);
     //default input #30 output #10;
     
     input  creqAddr;
     input  creqAttr;
     input  creqSize;
     input  creqId;
     input  creqType;
     input  creqValid;
     input  creqRdStall;
     input  creqWrStall;
     
     input  dreqData;
     input  dreqAttr;
     input  dreqId;
     input  dreqValid;
     input  dreqStall;

     input  rreqData;
     input  rreqAttr;
     input  rreqId;
     input  rreqValid;
     input  rreqStall;

  endclocking 

endinterface

