/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

class CacheTransaction #(int BITADDR=34, int BITDATA=512, int BITSEQN=16, int NUMBYLN=64,int XBITATR=3 ) extends MeTransaction;
  rand bit [BITADDR-1:0] Addr;
  rand bit [BITDATA-1:0] Data;
  rand bit [BITSEQN-1:0] ReqSeq;
  rand bit [BITSEQN-1:0] RspSeq;
  rand bit [NUMBYLN-1:0] ByteEn;
  rand bit [XBITATR-1:0] Attr;

  reg Write;
  reg Read;
  reg Inval;
  reg  valid;
  reg [63:0] transactionId;
  real transactionTime;

  function new ();
    Addr = 0;
    Data = 0;
    ReqSeq = 0;
    RspSeq = 0;
    ByteEn = 0;
    Attr = 0;
    Write = 0;
    Read = 0;
    Inval = 0;
    valid = 0;
    transactionId = 0;
  endfunction

  task reset ();
    Addr = 0;
    Data = 0;
    ReqSeq = 0;
    RspSeq = 0;
    ByteEn = 0;
    Attr = 0;
    Write = 0;
    Read = 0;
    Inval = 0;
    valid = 0;
    transactionId = 0;

  endtask


  function bit is_a_read ();
    is_a_read = (Read == 1);
  endfunction


  function bit is_a_write ();
    is_a_write = (Write == 1);
  endfunction


  function bit is_a_invalid ();
    is_a_invalid = (Inval == 1);
  endfunction

  function string reqSprint ();
    $sformat(reqSprint, " Addr=0x%0x Write=%0b Read=%0b Inval=%0b ReqSeq=0x%0x RspSeq=0x%0x ByteEn=0x%0x Attr=0x%0x Data = 0x%0x trTime= %0t, transactionId= %0d ", Addr,Write,Read,Inval,ReqSeq,RspSeq,ByteEn,Attr,Data,transactionTime,transactionId[63:0]);
    //$sformat(reqSprint, " Addr=0x%0x Data=0x%0x ", Addr,Data);
  endfunction:reqSprint

  function string reqASprint ();
    $sformat(reqASprint, " Addr=0x%0x Write=%0b Read=%0b Inval=%0b ReqSeq=0x%0x BA=0x%0x trTime= %0t, transactionId= %0d ", Addr,Write,Read,Inval,ReqSeq,ByteEn,transactionTime,transactionId[63:0]);
  endfunction:reqASprint

  function string dreqSprint ();
  endfunction:dreqSprint

 
endclass
