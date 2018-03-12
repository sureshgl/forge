/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
class MemoryTransaction #(AW=3, DW=3, WORDS=8);
  rand bit [AW-1:0] addr;
  rand bit [DW-1:0] data;
  rand memory_op mop;
  rand bit no_modelwrite;
  constraint nowrite_c {no_modelwrite inside {0};}

  function new ();
    mop = MOP_NOP;
    addr = 0;
    data = 0;
    no_modelwrite = 0;
  endfunction

  task reset ();
    mop = MOP_NOP;
    addr = 0;
    data = 0;
    no_modelwrite = 0;
  endtask

  function bit is_nop ();
    is_nop = (mop == MOP_NOP);
  endfunction

  function bit is_read ();
    is_read = (mop == MOP_RD) || (mop == MOP_RDC) || (mop == MOP_RU);
  endfunction

  function bit is_write ();
    is_write = (mop == MOP_WR);
  endfunction

  function bit is_count ();
    is_count = (mop == MOP_C);
  endfunction
  
  function bit is_read_check ();
    is_read_check = (mop == MOP_RDC) || (mop == MOP_RU);
  endfunction

  function bit is_ru_update ();
    is_ru_update = (mop == MOP_RU);
  endfunction

  function bit is_model_write ();
    is_model_write = ((is_write()) && (!no_modelwrite));
  endfunction

  function string sprint ();
    if(no_modelwrite) begin
      $sformat(sprint, "%s addr=0x%0x data=0x%0x (NO MW)", sprint_mop(mop), addr, data);
    end else begin
      $sformat(sprint, "%s addr=0x%0x data=0x%0x", sprint_mop(mop), addr, data);
    end
  endfunction

endclass

class MemoryUpdateTransaction #(AW=3, DW=3, WORDS=8) extends MemoryTransaction;
  rand bit [DW-1:0] udata;
endclass
