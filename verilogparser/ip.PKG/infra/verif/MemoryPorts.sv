/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

class MemoryReadPortId;
  rand int id;
  rand memory_op op;
  constraint id_c;
  constraint op_c { op inside {MOP_RDC};}
endclass

class MemoryWritePortId;
  rand int id;
  rand memory_op op;
  constraint id_c;
  constraint op_c { op inside {MOP_WR};}
endclass

class MemoryReadWritePortId;
  rand int id;
  rand memory_op op;
  constraint id_c;
  constraint op_c { op inside {MOP_WR, MOP_RDC};}
endclass

class MemoryCountPortId;
  rand int id;
  rand memory_op op;
  constraint id_c;
  constraint op_c { op inside {MOP_C};}
endclass

class MemoryAccessPortId;
  rand int id;
  rand memory_op op;
  constraint id_c;
  constraint op_c { op inside {MOP_WR, MOP_RDC};}
endclass

class MemoryReadUpdatePortId;
  rand int id;
  rand memory_op op;
  constraint id_c;
  constraint op_c { op inside {MOP_RU, MOP_RDC};}
endclass

class MemoryMallocPortId;
  rand int id;
  rand memory_op op;
  constraint id_c;
  constraint op_c { op inside {MOP_M};}
endclass

class MemoryOpcodes #(int NUMPRT = 2);
  string name = "MemOpCodes";
  bit [NUMPRT-1:0] opCodes [int];
  bit [NUMPRT-1:0] maxOpCodes [int];
  port_type ptype [int];
  MemoryReadPortId rid;
  MemoryWritePortId wid;
  MemoryReadWritePortId rwid;
  MemoryCountPortId cid;
  MemoryAccessPortId aid;
  MemoryReadUpdatePortId ruid;
  MemoryMallocPortId mid;

  extern function new();

  function memory_op getRandomOp (port_type pt);
    if (pt == PORT_R) begin
      void'(rid.randomize());
      getRandomOp = rid.op;
    end else if (pt == PORT_W) begin
      void'(wid.randomize());
      getRandomOp = wid.op;
    end else if (pt == PORT_RW) begin
      void'(rwid.randomize());
      getRandomOp = rwid.op;
    end else if(pt == PORT_C) begin
      void'(cid.randomize());
      getRandomOp = cid.op;
    end else if(pt == PORT_A) begin
      void'(aid.randomize());
      getRandomOp = aid.op;
    end else if(pt == PORT_RU) begin
      void'(ruid.randomize());
      getRandomOp = ruid.op;
    end
  endfunction

  function void getPortTypeMap (ref port_type pt [int]);
    int i;
    for(i=0; i< ptype.size(); i++)
      pt[i] = ptype[i];
  endfunction

  function void getRandomMaxConcurrentOpSet (ref memory_op mop[int]);
    int i;
    bit [NUMPRT-1 : 0] opc;
    opc = maxOpCodes[$urandom_range(maxOpCodes.size()-1, 0)];
    for (i = 0; i < NUMPRT; i++) begin
      mop[i] = opc[i] ? getRandomOp(ptype[i]) : MOP_NOP;
    end
  endfunction

  function void getRandomConcurrentOpSet (ref memory_op mop[int]);
    int i;
    bit [NUMPRT-1 : 0] opc;
    opc = opCodes[$urandom_range(opCodes.size()-1, 0)];
    for (i = 0; i < NUMPRT; i++) begin
      mop[i] = opc[i] ? getRandomOp(ptype[i]) : MOP_NOP;
    end
  endfunction

  function void getMaxWriteOpSet (ref bit [NUMPRT-1:0] opset);
    int idx = 0;
    int mc = 0;
    bit [NUMPRT-1 : 0] opc = 0;
    for (int j = 0; j < opCodes.size(); j++) begin
      int lc = 0;
      for (int k = 0; k < NUMPRT; k++) begin
        lc += (opCodes[j][k] && ((ptype[k] == PORT_W) || (ptype[k] == PORT_RW) || (ptype[k] == PORT_A))) ? 1 : 0;
      end
      if (mc < lc) begin
        opc = opCodes[j];
        mc = lc;
        idx = j;
      end
    end
    opset = opc;
    if(opc == 0) begin `FATAL("No write op code found."); end
  endfunction

  function void getMaxReadOpSet (ref bit [NUMPRT-1:0] opset);
    int idx = 0;
    int mc = 0;
    bit [NUMPRT-1 : 0] opc = 0;
    for (int j = 0; j < opCodes.size(); j++) begin
      int lc = 0;
      for (int k = 0; k < NUMPRT; k++) begin
        lc += (opCodes[j][k] && ((ptype[k] == PORT_R) || (ptype[k] == PORT_RW) || (ptype[k] == PORT_A) || (ptype[k] == PORT_RU))) ? 1 : 0;
      end
      if (mc < lc) begin
        opc = opCodes[j];
        mc = lc;
        idx = j;
      end
    end
    opset = opc;
    if(opc == 0) begin  `FATAL("No read op code found."); end
  endfunction

  function void getMaxCountOpSet (ref bit [NUMPRT-1:0] opset);
    int idx = 0;
    int mc = 0;
    bit [NUMPRT-1 : 0] opc = 0;
    for (int j = 0; j < opCodes.size(); j++) begin
      int lc = 0;
      for (int k = 0; k < NUMPRT; k++) begin
        lc += (opCodes[j][k] && (ptype[k] == PORT_C)) ? 1 : 0;
      end
      if (mc < lc) begin
        opc = opCodes[j];
        mc = lc;
        idx = j;
      end
    end
    opset = opc;
    if(opc == 0) begin `FATAL("No count op code found."); end
  endfunction
  
  function void getMaxAccessOpSet (ref bit [NUMPRT-1:0] opset);
    int idx = 0;
    int mc = 0;
    bit [NUMPRT-1 : 0] opc = 0;
    for (int j = 0; j < opCodes.size(); j++) begin
      int lc = 0;
      for (int k = 0; k < NUMPRT; k++) begin
        lc += (opCodes[j][k] && (ptype[k] == PORT_A)) ? 1 : 0;
      end
      if (mc < lc) begin
        opc = opCodes[j];
        mc = lc;
        idx = j;
      end
    end
    opset = opc;
    if(opc == 0) begin `FATAL("No access op code found."); end
  endfunction

  function void getMaxReadUpdateOpSet (ref bit [NUMPRT-1:0] opset);
    int idx = 0;
    int mc = 0;
    bit [NUMPRT-1 : 0] opc = 0;
    for (int j = 0; j < opCodes.size(); j++) begin
      int lc = 0;
      for (int k = 0; k < NUMPRT; k++) begin
        lc += (opCodes[j][k] && (ptype[k] == PORT_RU)) ? 1 : 0;
      end
      if (mc < lc) begin
        opc = opCodes[j];
        mc = lc;
        idx = j;
      end
    end
    opset = opc;
    if(opc == 0) begin  `FATAL("No read update op code found."); end
  endfunction

  function void getConcurrentWriteOpSet (ref memory_op mop[int]);
    int i;
    bit [NUMPRT-1 : 0] opc;
    getMaxWriteOpSet(opc);
    for (i = 0; i < NUMPRT; i++) begin
      mop[i] = opc[i] && ((ptype[i] == PORT_W) || (ptype[i] == PORT_RW) || (ptype[i] == PORT_A)) ? MOP_WR : MOP_NOP;
    end
  endfunction

  function void getConcurrentReadCheckOpSet (ref memory_op mop[int]);
    int i;
    bit [NUMPRT-1 : 0] opc;
    getMaxReadOpSet(opc);
    for (i = 0; i < NUMPRT; i++) begin
      mop[i] = opc[i] && ((ptype[i] == PORT_R) || (ptype[i] == PORT_RW) || (ptype[i] == PORT_RU) || (ptype[i] == PORT_A)) ? MOP_RDC : MOP_NOP;
    end
  endfunction

  function void getConcurrentCountOpSet (ref memory_op mop[int]);
    int i;
    bit [NUMPRT-1 : 0] opc;
    getMaxCountOpSet(opc);
    for (i = 0; i < NUMPRT; i++) begin
      mop[i] = opc[i] && ((ptype[i] == PORT_C)) ? MOP_C : MOP_NOP;
    end
  endfunction

  function void getConcurrentReadUpdateOpSet (ref memory_op mop[int]);
    int i;
    bit [NUMPRT-1 : 0] opc;
    getMaxReadUpdateOpSet(opc);
    for (i = 0; i < NUMPRT; i++) begin
      mop[i] = opc[i] && (ptype[i] == PORT_RU) ? MOP_RU : MOP_NOP;
    end
  endfunction

  function bit hasWritePort ();
    int idx = 0;
    int mc = 0;
    bit [NUMPRT-1 : 0] opc = 0;
    for (int j = 0; j < opCodes.size(); j++) begin
      for (int k = 0; k < NUMPRT; k++) begin
        mc += (opCodes[j][k] && ((ptype[k] == PORT_W) || (ptype[k] == PORT_RW) || (ptype[k] == PORT_A))) ? 1 : 0;
      end
    end
    hasWritePort = (mc > 0);
  endfunction
endclass

class MemoryPorts #(int NUMPRT = 2);
  MemoryReadPortId rid;
  MemoryWritePortId wid;
  MemoryReadWritePortId rwid;
  MemoryCountPortId cid;
  MemoryAccessPortId aid;
  MemoryReadUpdatePortId ruid;
  MemoryOpcodes#(.NUMPRT(NUMPRT)) mco;

  function new ();
    rid     = new();
    wid     = new();
    rwid    = new();
    cid     = new();
    aid     = new();
    ruid    = new();
    mco     = new();
  endfunction

  //TBD :: USE Proper Parameters to determine if write port is there or RW port.
  function int getRandomWritePort ();
    void'(wid.randomize());
    void'(rwid.randomize());
    if(wid.id >= 1024)
      getRandomWritePort = rwid.id;
    else
      getRandomWritePort = wid.id;
  endfunction

  function int getRandomCountPort();
    void'(cid.randomize());
    getRandomCountPort = cid.id;    
  endfunction

  function int getFirstWritePort ();
    int i;
    for(i=0; i < NUMPRT; i++)
      if(mco.ptype[i] == PORT_W || mco.ptype[i] == PORT_RW)
        break;
    getFirstWritePort = i;
  endfunction

  function int getRandomReadPort ();
    void'(rid.randomize());
    getRandomReadPort = rid.id;    
  endfunction

  function int getRandomReadWritePort ();
    void'(rwid.randomize());
    getRandomReadWritePort = rwid.id;    
  endfunction

  function int getRandomReadUpdatePort ();
    void'(ruid.randomize());
    getRandomReadUpdatePort = ruid.id;    
  endfunction

  function void getRandomConcurrentOpSet (ref memory_op mop[int]);
    void'(mco.getRandomConcurrentOpSet(mop));
  endfunction

  function void getRandomMaxConcurrentOpSet (ref memory_op mop[int]);
    void'(mco.getRandomMaxConcurrentOpSet(mop));
  endfunction

  function void getConcurrentWriteOpSet (ref memory_op mop[int]);
    void'(mco.getConcurrentWriteOpSet(mop));
  endfunction

  function void getConcurrentReadCheckOpSet (ref memory_op mop[int]);
    void'(mco.getConcurrentReadCheckOpSet(mop));
  endfunction
  
  function void getConcurrentCountOpSet (ref memory_op mop[int]);
    void'(mco.getConcurrentCountOpSet(mop));
  endfunction
  
  function void getConcurrentReadUpdateOpSet (ref memory_op mop[int]);
    void'(mco.getConcurrentReadUpdateOpSet(mop));
  endfunction

  function bit hasWritePort ();
    hasWritePort = mco.hasWritePort();
  endfunction

  // TBD: add validate functions

endclass
