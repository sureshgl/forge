module ip_top_sva_nbor1u_1r1w_nocam 
(
  clk, rst, ready,
  cpu_read, cpu_write, cpu_bnk, cpu_addr, cpu_din, cpu_dout, cpu_vld,
  sr_en, sr_key, sr_dout, sr_vld, sr_match, sr_mhe,
  up_en, up_key, up_din, up_del, up_bp, 
  t1_readB, t1_addrB, t1_doutB, 
  t1_writeA, t1_addrA, t1_dinA,
  select_key, select_bit
);
  parameter NUMSEPT = 1;

  parameter KYWIDTH = 32;
  parameter DTWIDTH = 32;
  parameter LG_DTWIDTH = 5;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter MEM_DELAY = 2;
  parameter FLOPCRC = 0;
  parameter QSIZE=2;
  parameter LG_QSIZE=1;
  parameter BITPBNK = BITVBNK+1;

  parameter PHWIDTH = KYWIDTH+DTWIDTH+1;
  parameter PLINE_DELAY = MEM_DELAY + FLOPCRC;
  parameter UP_DELAY = PLINE_DELAY;

  input clk, rst;
  input ready;

  input cpu_read;
  input cpu_write;
  input [BITPBNK-1:0] cpu_bnk;
  input [BITVROW-1:0] cpu_addr;
  input [PHWIDTH-1:0] cpu_din;
  input [PHWIDTH-1:0] cpu_dout;
  input               cpu_vld;

  input  [NUMSEPT-1:0] sr_en;
  input  [NUMSEPT*KYWIDTH-1:0] sr_key;
  input [NUMSEPT*DTWIDTH-1:0] sr_dout;
  input [NUMSEPT-1:0] sr_vld;
  input [NUMSEPT-1:0] sr_match;
  input [NUMSEPT-1:0] sr_mhe;

  input  up_en;
  input  [KYWIDTH-1:0] up_key;
  input  [DTWIDTH-1:0] up_din;
  input  up_del;
  input up_bp;

  input [NUMVBNK-1:0] t1_readB;
  input [NUMVBNK*BITVROW-1:0] t1_addrB;
  input [NUMVBNK*PHWIDTH-1:0] t1_doutB;

  input [NUMVBNK-1:0] t1_writeA;
  input [NUMVBNK*BITVROW-1:0] t1_addrA;
  input [NUMVBNK*PHWIDTH-1:0] t1_dinA;

  input [KYWIDTH-1:0] select_key;
  input [LG_DTWIDTH-1:0] select_bit;

  reg                 t1_writeA_wire [0:NUMVBNK-1];
  reg [BITVROW-1:0]   t1_addrA_wire [0:NUMVBNK-1];
  reg [PHWIDTH-1:0]   t1_dinA_wire [0:NUMVBNK-1];
  reg                 t1_readB_wire [0:NUMVBNK-1];
  reg [BITVROW-1:0]   t1_addrB_wire [0:NUMVBNK-1];
  reg [PHWIDTH-1:0]   t1_doutB_wire [0:NUMVBNK-1];
  integer t1_int;
  always_comb
    for (t1_int=0; t1_int<NUMVBNK; t1_int=t1_int+1) begin
      t1_writeA_wire[t1_int] = t1_writeA >> t1_int;
      t1_addrA_wire[t1_int] = t1_addrA >> (t1_int*BITVROW);
      t1_dinA_wire[t1_int] = t1_dinA >> (t1_int*PHWIDTH);
      t1_readB_wire[t1_int] = t1_readB >> t1_int;
      t1_addrB_wire[t1_int] = t1_addrB >> (t1_int*BITVROW);
      t1_doutB_wire[t1_int] = t1_doutB >> (t1_int*PHWIDTH);
    end

  wire [BITVROW-1:0] select_t1row [0:NUMVBNK-1];
  genvar t1_gen;
  generate 
  for(t1_gen=0; t1_gen<NUMVBNK; t1_gen=t1_gen+1) begin: tdout_loop
    assert_select_row_check: assert property (@(posedge clk) disable iff (!ready) ($stable(select_t1row[t1_gen])));
    assert_select_cpu_check: assert property (@(posedge clk) disable iff (!ready) ((cpu_write && cpu_bnk==t1_gen) |-> (cpu_addr != select_t1row[t1_gen]) ));

    reg [PHWIDTH-1:0] t1mem; 
    reg t1mem_inv;
    always @(posedge clk)
      if(!ready) begin
        t1mem_inv <=1;
        t1mem <= 0;
      end
      else if(t1_writeA_wire[t1_gen] && (t1_addrA_wire[t1_gen] == select_t1row[t1_gen])) begin
        t1mem <= t1_dinA_wire[t1_gen]; 
        t1mem_inv <= 0;
      end

    assert_update_row_check: assert property (@(posedge clk) disable iff(!ready) (core.up_f_en && core.up_f_key  == select_key)|-> ##FLOPCRC (core.up_hash[t1_gen] == select_t1row[t1_gen]));
    assert_search_row_check: assert property (@(posedge clk) disable iff(!ready) (sr_en[0] && sr_key == select_key)|-> ##FLOPCRC (core.crc_res[0][t1_gen] == select_t1row[t1_gen]));

    //TODO: We dont check for t1mem_inv here, as all assertions are used after
    //ready signal is high. So we must already assume mem = 0;
    assert_tdout_check: assert property (@(posedge clk) disable iff (!ready) ((t1_readB_wire[t1_gen] &&  (t1_addrB_wire[t1_gen] == select_t1row[t1_gen])) |-> 
                                            ##MEM_DELAY ((t1_doutB_wire[t1_gen]== $past(t1mem,MEM_DELAY))) ));
    //Need to prove this one
    assert_tdout_2_check: assert property(@(posedge clk) disable iff (!ready) ( (t1_readB_wire[t1_gen] && t1_addrB_wire[t1_gen] != select_t1row[t1_gen]) |-> 
                                            ##MEM_DELAY (t1_doutB_wire[t1_gen][KYWIDTH-1:0] != select_key)));
    
  end
  endgenerate


  reg data_vld;
  reg data_mem;
  always @(posedge clk)
    if(!ready) begin
      data_vld <= 0;
      data_mem <= 0;
    end
    else if (up_en  && (up_key == select_key)) begin
      data_vld  <= !up_del;
      data_mem <= up_din[select_bit];
    end
  
  assert_sr_vld_check: assert property (@(posedge clk) disable iff (!ready) ( (sr_en) |-> ##PLINE_DELAY (sr_vld) ));
  assert_sr_mhe_check: assert property (@(posedge clk) disable iff (!ready) ( (sr_en && sr_key == select_key) |-> ##PLINE_DELAY (!sr_mhe) ));
  assert_sr_match_check: assert property (@(posedge clk) disable iff (!ready) ( (data_vld && sr_en && sr_key == select_key) |-> ##PLINE_DELAY (sr_match)) );
  assert_sr_nomatch_check: assert property (@(posedge clk) disable iff (!ready) ( (!data_vld && sr_en && sr_key == select_key) |-> ##PLINE_DELAY (!sr_match)) );
  assert_sr_dout_check: assert property (@(posedge clk) disable iff (!ready) ( (data_vld && sr_en && sr_key == select_key) |-> ##PLINE_DELAY (sr_dout[select_bit] == $past(data_mem, PLINE_DELAY)) ));
  

  //
  //FIFO Assertions
  //
  assert_fifo_cnt_check    : assert property (@(posedge clk) disable iff(rst) (core.fifo_cnt <= QSIZE));
  assert_fifo_cnt_lo_check : assert property (@(posedge clk) disable iff(rst) (up_en |-> ##2(core.fifo_cnt > 0)));
  assert_fifo_pu_po_check  : assert property (@(posedge clk) disable iff(rst) (core.pu_lo_en |-> core.po_en));
  assert_fifo_up_nxt_check : assert property (@(posedge clk) disable iff(rst) (core.up_f_en |-> ((core.up_nxt_id < core.fifo_cnt) && core.fifo_cnt>0) ));
  assert_fifo_cnt_inc_check    : assert property (@(posedge clk) disable iff(rst) (core.fifo_cnt ==0   |-> ##1(core.fifo_cnt  <= 1)));
  assert_fifo_up_nxt_inc_check : assert property (@(posedge clk) disable iff(rst) (core.up_nxt_id == 0 |-> ##1(core.up_nxt_id <= 1)));

  reg [LG_QSIZE:0] srq_cnt;
  integer srm_int;
  always_comb begin
    srq_cnt = 0;
    for(srm_int=0; srm_int<QSIZE; srm_int=srm_int+1)
      srq_cnt = srq_cnt + core.srqg_match[0][srm_int];
  end
  assert_fifo_match_cnt_check    : assert property (@(posedge clk) disable iff(rst) (srq_cnt <= 1));
  assert_fifo_match_check    : assert property (@(posedge clk) disable iff(rst) ( (sr_en && (sr_key == select_key) && data_vld ##FLOPCRC core.sr_q_hit[0]) |-> 
                                                    (!core.sr_q_del[0] && core.sr_q_dat[0][select_bit] == $past(data_mem,1))));

  /*reg up_en_dly[0:UP_DELAY-1];
  reg [KYWIDTH-1:0] up_key_dly[0:UP_DELAY-1];
  reg [DTWIDTH-1:0] up_din_dly[0:UP_DELAY-1];
  reg up_del_dly[0:UP_DELAY-1];
  integer updel_int;
  always @(posedge clk)
  for(updel_int=0; updel_int<UP_DELAY; updel_int = updel_int+1) begin
    if(!ready) begin
      up_en_dly[updel_int] <= 0;
      up_key_dly[updel_int] <=0;
      up_din_dly[updel_int] <= 0;
      up_del_dly[updel_int] <= 0;
    end else begin
      up_en_dly[updel_int] <= (updel_int ==0 ? up_en : up_en_dly[updel_int-1]);
      up_key_dly[updel_int] <= (updel_int ==0 ? up_key : up_key_dly[updel_int-1]);
      up_din_dly[updel_int] <= (updel_int ==0 ? up_din : up_din_dly[updel_int-1]);
      up_del_dly[updel_int] <= (updel_int ==0 ? up_del : up_del_dly[updel_int-1]);
    end
  end

  reg data_vld;
  reg data_mem;
  always @(posedge clk)
    if(!ready) begin
      data_vld <= 0;
      data_mem <= 0;
    end
    else if (up_en_dly[UP_DELAY-1] && (up_key_dly[UP_DELAY-1] == select_key) && !up_fail) begin
      data_vld  <= !up_del_dly[UP_DELAY-1];
      data_mem <= up_din_dly[UP_DELAY-1][select_bit];
    end
  
  assert_sr_vld_check: assert property (@(posedge clk) disable iff (!ready) ( (sr_en && sr_key == select_key) |-> ##PLINE_DELAY (sr_vld && !sr_mhe) ));
  assert_sr_match_check: assert property (@(posedge clk) disable iff (!ready) ( (data_vld && sr_en && sr_key == select_key) |-> ##PLINE_DELAY (sr_match)) );
  assert_sr_nomatch_check: assert property (@(posedge clk) disable iff (!ready) ( (!data_vld && sr_en && sr_key == select_key) |-> ##PLINE_DELAY (!sr_match)) );
  //assert_sr_dout_check: assert property (@(posedge clk) disable iff (!ready) ( (data_vld && sr_en && sr_key == select_key) |-> ##PLINE_DELAY (sr_dout[select_bit] == $past(data_mem, PLINE_DELAY)) ));
  
*/
endmodule
