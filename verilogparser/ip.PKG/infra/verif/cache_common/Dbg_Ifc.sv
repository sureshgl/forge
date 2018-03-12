/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */


interface Dbg_Ifc #(int DBGADDRWIDTH=7, int DBGBADDRWIDTH=7,int DBGDATAWIDTH=144) (input clk);


  logic                      dbg_en;
  logic                      dbg_read;
  logic                      dbg_write;
  logic                      dbg_vld;
  logic [DBGADDRWIDTH-1:0]   dbg_addr;
  logic [DBGDATAWIDTH-1:0]   dbg_din;
  logic [DBGDATAWIDTH-1:0]   dbg_dout;
  logic [DBGBADDRWIDTH-1:0]  dbg_bank;
  


  clocking cbDbgDrv @(posedge clk);
     //default input #30 output #10;

     output  dbg_en;
     output  dbg_read;
     output  dbg_write;
     output  dbg_addr;
     output  dbg_din;
     output  dbg_bank;
     input   dbg_vld;
     input   dbg_dout;
     
  endclocking

  clocking cbDbgMon @(posedge clk);
     //default input #30 output #10;
   
     input  dbg_en;
     input  dbg_read;
     input  dbg_write;
     input  dbg_addr;
     input  dbg_dout;
     input  dbg_bank;
     input  dbg_vld;
     input  dbg_din;
 
  endclocking 


endinterface

