module algo_nbor1u_1r1w_nocam 
(
  clk, rst, ready,disp_en, freeze,
  cpu_read, cpu_write, cpu_bnk, cpu_addr, cpu_din, cpu_dout, cpu_vld,
  sr_en, sr_key, sr_dout, sr_vld, sr_match, sr_mhe,
  up_en, up_key, up_din, up_del, up_bp, 
  t1_readB, t1_addrB, t1_doutB, 
  t1_writeA, t1_addrA, t1_dinA,
  select_key, select_bit
);
  parameter NUMSEPT = 1;

  parameter KYWIDTH = 4;
  parameter DTWIDTH = 2;
  parameter LG_DTWIDTH = 1;
  parameter NUMVROW = 4;
  parameter BITVROW = 2;
  parameter NUMVBNK = 1;
  parameter BITVBNK = 1;
  parameter MEM_DELAY = 1;
  parameter FLOPCRC=1;
  parameter BITPBNK = BITVBNK+1;

  parameter QSIZE = 4;
  parameter LG_QSIZE = 2;

  parameter PHWIDTH = KYWIDTH+DTWIDTH+1;
  parameter PLINE_DELAY = MEM_DELAY + FLOPCRC;

  input clk, rst,disp_en, freeze;
  output ready;

  input cpu_read;
  input cpu_write;
  input [BITPBNK-1:0] cpu_bnk;
  input [BITVROW-1:0] cpu_addr;
  input [PHWIDTH-1:0] cpu_din;
  output[PHWIDTH-1:0] cpu_dout;
  output              cpu_vld;

  input  [NUMSEPT-1:0] sr_en;
  input  [NUMSEPT*KYWIDTH-1:0] sr_key;
  output [NUMSEPT*DTWIDTH-1:0] sr_dout;
  output [NUMSEPT-1:0] sr_vld;
  output [NUMSEPT-1:0] sr_match;
  output [NUMSEPT-1:0] sr_mhe;

  input  up_en;
  input  [KYWIDTH-1:0] up_key;
  input  [DTWIDTH-1:0] up_din;
  input  up_del;
  output up_bp;

  output [NUMSEPT*NUMVBNK-1:0] t1_readB;
  output [NUMSEPT*NUMVBNK*BITVROW-1:0] t1_addrB;
  input  [NUMSEPT*NUMVBNK*PHWIDTH-1:0] t1_doutB;

  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMVBNK*PHWIDTH-1:0] t1_dinA;

  input [KYWIDTH-1:0] select_key;
  input [LG_DTWIDTH-1:0] select_bit;

  core_nbor1u_1r1w_nocam
  #(.NUMSEPT(NUMSEPT), .KYWIDTH(KYWIDTH), .DTWIDTH(DTWIDTH), .NUMVROW(NUMVROW), .BITVROW(BITVROW), 
  .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .MEM_DELAY(MEM_DELAY), .FLOPCRC(FLOPCRC), .BITPBNK(BITPBNK),
  .QSIZE(QSIZE), .LG_QSIZE(LG_QSIZE))
  core (.clk(clk), .rst(rst), .ready(ready),.disp_en(disp_en), .freeze(freeze),
    .cpu_read(cpu_read), .cpu_write(cpu_write), .cpu_bnk(cpu_bnk), .cpu_addr(cpu_addr), .cpu_din(cpu_din), .cpu_dout(cpu_dout), .cpu_vld(cpu_vld),
    .sr_en(sr_en), .sr_key(sr_key), .sr_dout(sr_dout), .sr_vld(sr_vld), .sr_match(sr_match), .sr_mhe(sr_mhe),
  .up_en(up_en), .up_key(up_key), .up_din(up_din), .up_del(up_del), .up_bp(up_bp), 
  .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB), 
  .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA));

`ifdef FORMAL
   assume_select_key_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_key));
   assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit) && select_bit < DTWIDTH);
   assume_select_interface_2: assume property (@(posedge clk) disable iff (rst) (!ready |-> !(up_en)));
   assume_select_interface_3: assume property (@(posedge clk) disable iff (rst) (!ready |-> !(|sr_en)));
   assume_select_interface : assume property (@(posedge clk) disable iff (!ready) (up_en |-> !(|sr_en)));
   assume_select_interface_4 : assume property (@(posedge clk) disable iff (!ready) (up_bp |-> (!up_en)));
   assume_select_interface_5 : assume property (@(posedge clk) disable iff (!ready) ((cpu_read || cpu_write) |-> (!up_en && !(|sr_en))));
   assume_select_interface_6 : assume property (@(posedge clk) disable iff (!ready) (!cpu_read || !cpu_write));
   ip_top_sva_nbor1u_1r1w_nocam 
  #(.NUMSEPT(NUMSEPT), .KYWIDTH(KYWIDTH), .DTWIDTH(DTWIDTH), .LG_DTWIDTH(LG_DTWIDTH), .NUMVROW(NUMVROW), .BITVROW(BITVROW), 
  .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .MEM_DELAY(MEM_DELAY), .FLOPCRC(FLOPCRC), .BITPBNK(BITPBNK),
  .QSIZE(QSIZE), .LG_QSIZE(LG_QSIZE))
  ip_top_sva (.*);
`endif


endmodule
