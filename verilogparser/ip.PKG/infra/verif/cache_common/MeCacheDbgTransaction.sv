/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

class MeCacheDbgTransaction #(int DBGADDRWIDTH=7, int DBGBADDRWIDTH=7,int DBGDATAWIDTH=144) extends MeTransaction;
  rand bit [DBGADDRWIDTH-1:0] addr;
  rand bit [DBGBADDRWIDTH-1:0] baddr;
  rand bit reqType;
  rand bit dbgEn;
  rand bit [DBGDATAWIDTH-1:0] dout;
  rand bit [DBGDATAWIDTH-1:0] din;

  rand dbg_op cacheReqType;
  function new ();
    addr = 0;
    baddr = 0;
    dout = 0;
    din = 0;
    dbgEn = 0;
    reqType = DBG_WRITE;
  endfunction

  task reset ();
    addr = 0;
    baddr = 0;
    dout = 0;
    din = 0;
    dbgEn = 0;
    reqType = DBG_WRITE;
  endtask


  function bit is_a_read ();
    is_a_read = (reqType == CH_READ);
  endfunction


  function bit is_a_write ();
    is_a_write = (reqType == CH_WRITE);
  endfunction


  function string dbgWriteSprint ();
    $sformat(dbgWriteSprint, " Addr=0x%0x BAddr=0x%0x ReqType=0x%0x DIn=0x%0x DOut=0x%0x ", addr,baddr,reqType,din,dout);
  endfunction:dbgWriteSprint

  function string dbgReadSprint ();
    $sformat(dbgReadSprint, " Addr=0x%0x BAddr=0x%0x ReqType=0x%0x  DIn=0x%0x DOut=0x%0x ", addr,baddr,reqType,din,dout);
  endfunction:dbgReadSprint

endclass
