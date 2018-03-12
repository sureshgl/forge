/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
typedef enum {FATAL, ERROR, WARN, INFO, DEBUG, TRACE} log_level;
typedef enum {MOP_NOP, MOP_RD, MOP_WR, MOP_RDC, MOP_C, MOP_RU, MOP_M} memory_op;
typedef enum {PORT_R, PORT_W, PORT_RW, PORT_C, PORT_A, PORT_RU, PORT_M} port_type;

function string sprint_mop (memory_op mop);
  sprint_mop = ((mop == MOP_NOP) ? "NOP" : 
                ((mop == MOP_RD) ? "RD " :
                 ((mop == MOP_WR) ? "WR " :
                  ((mop == MOP_RDC) ? "RDC" :
                   ((mop == MOP_C) ? "C" :
                    ((mop == MOP_RU) ? "RU" : 
                     "UNK"))))));
endfunction

function string sprint_mop2 (memory_op mop);
  sprint_mop2 = ((mop == MOP_NOP) ? "noop" : 
                 ((mop == MOP_RD) ? "read" :
                  ((mop == MOP_WR) ? "write" :
                   ((mop == MOP_RDC) ? "read_check" :
                    ((mop == MOP_C) ? "count" :
                     ((mop == MOP_RU) ? "read_update" :
                      "UNK"))))));
endfunction

static int MAX_ERROR_COUNT = 1;
static log_level llvl    = WARN; // set in testbench_dbg.v
static string memoir_design_name = ""; // set in testbench_dbg.v
static int __err_cnt     = 0;
function void set_fail ();
  __err_cnt++;
endfunction
static int __warn_cnt = 0;
function void set_warn ();
  __warn_cnt++;
endfunction

`define TRACE(y) if (llvl >= TRACE)  begin $display("[T:%s:%0t] %s", name, $time, y); end
`define DEBUG(y) if (llvl >= DEBUG)  begin $display("[D:%s:%0t] %s", name, $time, y); end
`define INFO(y)  if (llvl >= INFO)   begin $display("[I:%s:%0t] %s", name, $time, y); end
`define WARN(y)  if (llvl >= WARN)   begin $display("[W:%s:%0t] %s", name, $time, y);set_warn();end
`define ERROR(y) if (llvl >= ERROR)  begin $display("[E:%s:%0t] %s", name, $time, y);end begin set_fail(); if(__err_cnt >= MAX_ERROR_COUNT) begin $finish; end end
`define FATAL(y) if (llvl >= FATAL)  begin $display("[F:%s:%0t] [exiting] %s", name, $time, y);end begin set_fail();$finish;end
`define TB_YAP(y)    begin $display("[testbench] %s", y);end
`define TB_EXIT(y)   begin $display("[testbench] exit called %s", y); $finish; end
