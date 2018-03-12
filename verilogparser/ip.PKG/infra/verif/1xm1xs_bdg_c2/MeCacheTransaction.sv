/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

class MeCacheTransaction #(int NXADDRWIDTH=49, int NXDATAWIDTH=256, int NXIDWIDTH=2, int NXTYPEWIDTH=3, int NXSIZEWIDTH=8, int NXATTRWIDTH=3) extends MeTransaction;
  rand bit [NXADDRWIDTH-1:0] addr;
  rand bit [NXDATAWIDTH-1:0] data[8];
  rand bit [NXIDWIDTH-1:0] cId;
  rand bit [NXIDWIDTH-1:0] dId;
  rand bit [NXIDWIDTH-1:0] rId;
  rand bit [NXTYPEWIDTH-1:0] reqType;
  rand bit [NXSIZEWIDTH-1:0] size;
  rand bit [NXATTRWIDTH-1:0] cattr;
  rand bit [NXATTRWIDTH-1:0] dattr;
  rand bit [NXATTRWIDTH-1:0] rattr;

  int clock_tick;
  int req_clock_tick;
  int rsp_clock_tick;
  reg  valid;
  reg rspReceived;
  reg needResponse;
  rand cache_op cacheReqType;
  //rand cache_creq_att cacheCreqAtt;
  rand cache_dreq_att cacheDreqAtt;
  rand cache_rreq_att cacheRreqAtt;
  reg [2:0]beetStart;
  reg [3:0]noBeets;
  reg [3:0]noBeetsRsv;
  real transactionTime;
  function new ();
    //cacheReqType = CH_NOP;
    //cacheCreqAtt = CH_C_NOP;
    //cacheDreqAtt = CH_D_NOP;
    //cacheRreqAtt = CH_R_NOP;
    addr = 0;
    data[0] = 0;
    cId = 0;
    dId = 0;
    rId = 0;
    reqType = CH_NOP;
    size = 0;
    //cattr = cacheCreqAtt;
    dattr = cacheDreqAtt;
    rattr = cacheRreqAtt;
    valid = 0;
    rspReceived = 0;
    needResponse = 0;
    clock_tick = 0;
    req_clock_tick = 0;
    rsp_clock_tick = 0;
  endfunction

  task reset ();
    //cacheReqType = CH_NOP;
    //cacheCreqAtt = CH_C_NOP;
    //cacheDreqAtt = CH_D_NOP;
    //cacheRreqAtt = CH_R_NOP;
    addr = 0;
    data[0] = 0;
    cId = 0;
    dId = 0;
    rId = 0;
    reqType = CH_NOP;
    size = 0;
    //cattr = cacheCreqAtt;
    dattr = cacheDreqAtt;
    rattr = cacheRreqAtt;
    valid = 0;
    rspReceived = 0;
    needResponse = 0;
    clock_tick = 0;
    req_clock_tick = 0;
    rsp_clock_tick = 0;
  endtask

  function bit is_nop ();
    is_nop = (reqType == CH_NOP);
  endfunction

  function bit is_a_read ();
    is_a_read = (reqType == CH_READ);
  endfunction


  function bit is_a_write ();
    is_a_write = (reqType == CH_WRITE);
  endfunction

  function bit is_a_flush ();
    is_a_flush = (cacheReqType == CH_FLUSH);
  endfunction


  function bit is_a_invalid ();
    is_a_invalid = (reqType == CH_INVAL);
  endfunction


  function string creqSprint ();
    $sformat(creqSprint, " Addr=0x%x ReqType=0x%0x Creqattr=0x%0x Size=0x%0x Cid=0x%0x beetStart=%d noBeets=%d noBeetsRsv=%d transactionTime=%t", addr,reqType,cattr,size,cId,beetStart[2:0],noBeets[3:0],noBeetsRsv[3:0],transactionTime);
  endfunction:creqSprint

  function string dreqSprint ();
    $sformat(dreqSprint, " Addr=0x%0x Data[0]=0x%0x DreqAttr=0x%0x  Did=0x%0x", addr,data[0],dattr,dId);
  endfunction:dreqSprint

  function string rreqSprint ();
    $sformat(rreqSprint, " Addr=0x%0x Data[0]=0x%0x RreqAttr=0x%0x  Rid=0x%0x", addr,data[0],rattr,rId);
  endfunction:rreqSprint
 
endclass
