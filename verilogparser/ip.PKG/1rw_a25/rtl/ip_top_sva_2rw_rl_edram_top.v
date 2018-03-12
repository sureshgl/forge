module ip_top_sva_2_2rw_rl_edram_top
  #(parameter
     NUMADDR = 8192,
     BITADDR = 13,
     NUMVBNK = 8,
     BITVBNK = 3,
     NUMVROW = 1024,
     BITVROW = 10,
     NUMMBNK = 8,
     BITMBNK = 3,
     NUMWRDS = 4,
     BITWRDS = 2,
     NUMSROW = 64,
     BITSROW = 6,
     REFFREQ = 10
   )
(
  input clk,
  input rst,
  input ready,
  input refr,
  input read,
  input write,
  input [BITADDR-1:0] addr,
  input [NUMMBNK-1:0] t1_readA,
  input [NUMMBNK-1:0] t1_writeA,
  input [NUMMBNK*(BITVBNK+BITSROW)-1:0] t1_addrA,
  input [NUMMBNK-1:0] t1_refrB,
  input [NUMMBNK*BITVBNK-1:0] t1_bankB,
  input [1-1:0] t2_readA,
  input [1-1:0] t2_writeA,
  input [1*(BITVBNK+BITSROW)-1:0] t2_addrA,
  input [1-1:0] t3_writeA,
  input [1*BITVROW-1:0] t3_addrA,
  input [1-1:0] t3_readB,
  input [1*BITVROW-1:0] t3_addrB,
  input [1-1:0] t4_writeA,
  input [1*BITVROW-1:0] t4_addrA,
  input [1-1:0] t4_readB,
  input [1*BITVROW-1:0] t4_addrB
);

assert_refr_check: assert property (@(posedge clk) disable iff (!ready) !refr |-> ##[1:REFFREQ-2] refr ##1 refr);
//assert_refr2_check: assert property (@(posedge clk) disable iff (!ready) !refr ##1 !refr ##1 !refr |-> ##1 refr ##1 refr);
//assert_refr_check: assert property (@(posedge clk) disable iff (!ready) !refr ##[1:REFFREQ-2] refr ##1 refr);
assert_refr2_check: assert property (@(posedge clk) disable iff (!ready) !refr ##1 refr |-> ##1 refr);
assert_rw_1p_check: assert property (@(posedge clk) disable iff (rst) !(read && write) && !(refr && read) && !(refr && write)); 
assert_rw_range_check: assert property (@(posedge clk) disable iff (rst) (read || write) |-> (addr < NUMADDR));

genvar t1_int;
generate for (t1_int=0; t1_int<1; t1_int=t1_int+1) begin: t1_loop
  wire t1_readA_wire = t1_readA >> t1_int;
  wire t1_writeA_wire = t1_writeA >> t1_int;
  wire [BITVBNK+BITSROW-1:0] t1_addrA_wire = t1_addrA >> (t1_int*(BITVBNK+BITSROW));
  wire [BITVBNK-1:0] t1_vbnkA_wire = t1_addrA_wire >> BITSROW;
  wire [BITSROW-1:0] t1_srowA_wire = t1_addrA_wire; 
  wire t1_refrB_wire = t1_refrB >> t1_int;
  wire [BITVBNK-1:0] t1_vbnkB_wire = t1_bankB >> (t1_int*BITVBNK);

  assert_t1_rw_1p_check: assert property (@(posedge clk) disable iff (rst) !(t1_readA_wire && t1_writeA_wire));
  assert_t1_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire || t1_writeA_wire) |->
					     (t1_vbnkA_wire < NUMVBNK) && (t1_srowA_wire < NUMSROW));
  assert_t1_rf_range_check: assert property (@(posedge clk) disable iff (rst) t1_refrB_wire |-> (t1_vbnkB_wire < NUMVBNK));
  assert_t1_rw_bank_check: assert property (@(posedge clk) disable iff (!ready) (t1_readA_wire || t1_writeA_wire) |-> ##1
					    !(t1_refrB_wire && (t1_vbnkB_wire == $past(t1_vbnkA_wire))) &&
					    !((t1_readA_wire || t1_writeA_wire) && (t1_vbnkA_wire == $past(t1_vbnkA_wire))));
  assert_t1_rf_bank_check: assert property (@(posedge clk) disable iff (rst) t1_refrB_wire |-> ##1
					    !(t1_refrB_wire && (t1_vbnkB_wire == $past(t1_vbnkB_wire))) &&
					    !((t1_readA_wire || t1_writeA_wire) && (t1_vbnkA_wire == $past(t1_vbnkB_wire))));
  assert_t1_rfrw_check: assert property (@(posedge clk) disable iff (rst) (t1_refrB_wire && (t1_readA_wire || t1_writeA_wire)) |->
					 (t1_vbnkB_wire != t1_vbnkA_wire));
end
endgenerate

genvar t2_int;
generate for (t2_int=0; t2_int<1; t2_int=t2_int+1) begin: t2_loop
  wire t2_readA_wire = t2_readA >> t2_int;
  wire t2_writeA_wire = t2_writeA >> t2_int;
  wire [BITVBNK+BITSROW-1:0] t2_addrA_wire = t2_addrA >> (t2_int*(BITVBNK+BITSROW));
  wire [BITVBNK-1:0] t2_vbnkA_wire = t2_addrA_wire >> BITSROW;
  wire [BITSROW-1:0] t2_srowA_wire = t2_addrA_wire; 

  assert_t2_rw_1p_check: assert property (@(posedge clk) disable iff (rst) !(t2_readA_wire && t2_writeA_wire));
  assert_t2_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire || t2_writeA_wire) |->
					     (t2_vbnkA_wire < NUMVBNK) && (t2_srowA_wire < NUMSROW));
end
endgenerate

genvar t3_int;
generate for (t3_int=0; t3_int<1; t3_int=t3_int+1) begin: t3_loop
  wire t3_writeA_wire = t3_writeA >> t3_int;
  wire [BITVROW-1:0] t3_addrA_wire = t3_addrA >> (t3_int*BITVROW);
  
  wire t3_readB_wire = t3_readB >> t3_int;
  wire [BITVROW-1:0] t3_addrB_wire = t3_addrB >> (t3_int*BITVROW);
  
  assert_t3_wr_range_check: assert property (@(posedge clk) disable iff (rst) t3_writeA_wire |-> (t3_addrA_wire < NUMVROW));
  assert_t3_rd_range_check: assert property (@(posedge clk) disable iff (rst) t3_readB_wire |-> (t3_addrB_wire < NUMVROW));
  assert_t3_rw_psuedo_check: assert property (@(posedge clk) disable iff (rst) (t3_writeA_wire && t3_readB_wire) |-> (t3_addrA_wire != t3_addrB_wire));
end
endgenerate

genvar t4_int;
generate for (t4_int=0; t4_int<1; t4_int=t4_int+1) begin: t4_loop
  wire t4_writeA_wire = t4_writeA >> t4_int;
  wire [BITVROW-1:0] t4_addrA_wire = t4_addrA >> (t4_int*BITVROW);
  
  wire t4_readB_wire = t4_readB >> t4_int;
  wire [BITVROW-1:0] t4_addrB_wire = t4_addrB >> (t4_int*BITVROW);
  
  assert_t4_wr_range_check: assert property (@(posedge clk) disable iff (rst) t4_writeA_wire |-> (t4_addrA_wire < NUMVROW));
  assert_t4_rd_range_check: assert property (@(posedge clk) disable iff (rst) t4_readB_wire |-> (t4_addrB_wire < NUMVROW));
  assert_t4_rw_psuedo_check: assert property (@(posedge clk) disable iff (rst) (t4_writeA_wire && t4_readB_wire) |-> (t4_addrA_wire != t4_addrB_wire));
end
endgenerate

endmodule

module ip_top_sva_2rw_rl_edram_top
  #(parameter
     NUMVBNK = 8,
     BITVBNK = 3,
     NUMMBNK = 8,
     BITMBNK = 3,
     NUMRROW = 3,
     BITRROW = 2,
     REFFREQ = 10
   )
(
  input clk,
  input rst,
  input ready,
  input [NUMMBNK-1:0] t1_refrB,
  input [NUMMBNK*BITVBNK-1:0] t1_bankB,
  input [BITRROW-1:0] select_rrow,
  input [BITVBNK-1:0] select_rbnk
);

genvar t1_int;
generate for (t1_int=0; t1_int<1; t1_int=t1_int+1) begin: t1_loop
  wire t1_refrB_wire = t1_refrB >> t1_int;
  wire [BITVBNK-1:0] t1_vbnkB_wire = t1_bankB >> (t1_int*BITVBNK);

  reg [BITRROW-1:0] row_cnt;
  always @(posedge clk)
    if (rst)
      row_cnt <= 0;
//    else if (prefr && (prfbadr == select_rbnk))
    else if (t1_refrB_wire && (t1_vbnkB_wire == 0))
      row_cnt <= (row_cnt == NUMRROW-1) ? 0 : row_cnt + 1;

  reg [15:0] bitcell_cnt;
  always @(posedge clk)
//    if (rst || (prefr && (prfbadr == select_rbnk) && (row_cnt == select_rrow)))
    if (!ready || (t1_refrB_wire && (t1_vbnkB_wire == 0) && (row_cnt == 0)))
//      bitcell_cnt <= (REFFREQ > NUMVBNK) ? 3*(REFFREQ*NUMRROW+REFFREQ)-REFFREQ+2 : 3*(NUMVBNK*NUMRROW+REFFREQ)-REFFREQ+2; // REFFREQ=5,7 NUMRROW=3
//      bitcell_cnt <= (REFFREQ > NUMVBNK) ? 3*(REFFREQ*NUMRROW+REFFREQ)-REFFREQ+4 : 3*(NUMVBNK*NUMRROW+REFFREQ)-REFFREQ+4; // REFFREQ=9 NUMRROW=3
      bitcell_cnt <= (REFFREQ > NUMVBNK) ? 3*(REFFREQ*NUMRROW+REFFREQ)+1 : 3*(NUMVBNK*NUMRROW+REFFREQ)+1; // REFFREQ=6,8 NUMRROW=3
    else if (|bitcell_cnt)
      bitcell_cnt <= bitcell_cnt - 1;

  assert_refr_norefr_check: assert property (@(posedge clk) disable iff (rst) a1_loop.algo.core.request |-> ##1
                                             ((!a1_loop.algo.core.refresh_module.norefr || a1_loop.algo.core.prefr) ||
                                              $past(!a1_loop.algo.core.refresh_module.norefr || a1_loop.algo.core.prefr)));
//  assert_refr_rf_check: assert property (@(posedge clk) disable iff (rst) (a1_loop.algo.core.vrefr1 && a1_loop.algo.core.vrefr2) |-> ##1
//					 (!a1_loop.algo.core.refresh_module.norefr &&
//					  !a1_loop.algo.core.refresh_module.pacc1 &&
//					  !a1_loop.algo.core.refresh_module.pacc2 &&
//					  !a1_loop.algo.core.refresh_module.pacc3));
  assert_bitcell_gt0_check: assert property (@(posedge clk) disable iff (rst) (bitcell_cnt != 0));
  assert_bitcell_gt1_check: assert property (@(posedge clk) disable iff (rst) (bitcell_cnt != 1));

end
endgenerate

endmodule
