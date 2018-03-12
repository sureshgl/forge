module ip_top_sva_2_refr_2stage
  #(
parameter     NUMRBNK = 8,
parameter     BITRBNK = 3,
parameter     REFFREQ = 16,
parameter     REFFRHF = 0)
(
  input clk,
  input rst,
  input pref,
  input pacc1,
  input [BITRBNK-1:0] pacbadr1,
  input pacc2,
  input [BITRBNK-1:0] pacbadr2,
  input prefr,
  input [BITRBNK-1:0] prfbadr
);

assert_pref_check: assert property (@(posedge clk) disable iff (rst) !pref |-> ##[1:REFFREQ+REFFRHF-1] pref);
assert_pref_half_check: assert property (@(posedge clk) disable iff (rst) pref ##(REFFREQ+REFFRHF) pref |-> ##REFFREQ (!REFFRHF || pref));
assert_pacc_check: assert property (@(posedge clk) disable iff (rst) !(pref && (pacc1 || pacc2)));
//assert_pacc1_range_check: assert property (@(posedge clk) disable iff (rst) pacc1 |-> (pacbadr1 < NUMRBNK));
//assert_pacc2_range_check: assert property (@(posedge clk) disable iff (rst) pacc2 |-> (pacbadr2 < NUMRBNK));
assert_prefr_range_check: assert property (@(posedge clk) disable iff (rst) prefr |-> (prfbadr < NUMRBNK));
assert_pacc_prefr_check: assert property (@(posedge clk) disable iff (rst) prefr |->
					  !(pacc1 && (pacbadr1 == prfbadr)) && !(pacc2 && (pacbadr2 == prfbadr)));

endmodule


module ip_top_sva_refr_2stage
  #(
parameter     NUMRBNK = 8,
parameter     BITRBNK = 3,
parameter     REFLOPW = 0,
parameter     NUMRROW = 16,
parameter     BITRROW = 4,
parameter     REFFREQ = 10,
parameter     REFFRHF = 0)
(
  input clk,
  input rst,
  input prefr,
  input [BITRBNK-1:0] prfbadr,
  input [BITRBNK-1:0] select_rbnk,
  input [BITRROW-1:0] select_rrow
);

reg [BITRROW-1:0] row_cnt;
always @(posedge clk) 
  if (rst)
    row_cnt <= 0;
  else if (prefr && (prfbadr == select_rbnk))
    row_cnt <= (row_cnt == NUMRROW-1) ? 0 : row_cnt + 1;

reg [15:0] bitcell_cnt;
always @(posedge clk) 
  if (rst || (prefr && (prfbadr == select_rbnk) && (row_cnt == select_rrow)))
    if (REFLOPW)
      bitcell_cnt <= (2*REFFREQ >= NUMRBNK) ? 2*(REFFREQ*NUMRROW+REFFREQ)+NUMRBNK-2 : (NUMRBNK*NUMRROW)+2*REFFREQ-2; //DADA Not proven
    else if (REFFRHF)
      bitcell_cnt <= (2*REFFREQ >= NUMRBNK) ? ((NUMRROW%2) ? (2*REFFREQ+1)*NUMRROW+2*REFFREQ+2 :
                                                             (2*REFFREQ+1)*NUMRROW+REFFREQ+1) : NUMRBNK*NUMRROW+2*REFFREQ+1; //DADA Not proven
    else
      bitcell_cnt <= (NUMRBNK == 2) ? 2*(REFFREQ*NUMRROW)+REFFREQ-1 :
                     (2*REFFREQ >= NUMRBNK) ? 2*(REFFREQ*NUMRROW+REFFREQ) : (NUMRBNK*NUMRROW)+2*REFFREQ; 
  else if (|bitcell_cnt)
    bitcell_cnt <= bitcell_cnt - 1;

assert_bitcell_gt0_check: assert property (@(posedge clk) disable iff (rst) (bitcell_cnt != 0));
`ifdef FORMAL
assert_bitcell_gt1_check: assert property (@(posedge clk) disable iff (rst) (bitcell_cnt != 1));
`endif

assert_scnt_check: assert property (@(posedge clk) disable iff (rst)
                                    !(refresh_module.prefr_scnt_1 && !refresh_module.prefr_scnt_0));
assert_sptr_check: assert property (@(posedge clk) disable iff (rst)
                                    !(refresh_module.prefr_scnt_1 && refresh_module.prefr_scnt_0 &&
                                      (refresh_module.prefr_sptr_1 == refresh_module.prefr_sptr_0)));

endmodule


