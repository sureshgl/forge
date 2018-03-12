`ifdef FORMAL
`define FORMAL_OR_SIM_SVA
`endif
`ifdef SIM_SVA
`define FORMAL_OR_SIM_SVA
`endif


`ifdef FORMAL_OR_SIM_SVA

module ip_top_sva_2_refr_1stage
  #(
parameter     NUMRBNK = 8,
parameter     BITRBNK = 3,
parameter     REFFREQ = 16,
parameter     REFFRHF = 0)
(
  input clk,
  input rst,
  input pref,
  input pacc,
  input [BITRBNK-1:0] pacbadr,
  input prefr,
  input [BITRBNK-1:0] prfbadr
);
`ifdef FORMAL
//synopsys translate_off


assert_pref_check: assert property (@(posedge clk) disable iff (rst) !pref |-> ##[1:REFFREQ+REFFRHF-1] pref);
assert_pref_half_check: assert property (@(posedge clk) disable iff (rst) pref ##1 !pref [*(REFFREQ+REFFRHF-1)] ##1 pref |-> ##[1:REFFREQ] (!REFFRHF || pref));
assert_pacc_check: assert property (@(posedge clk) disable iff (rst) !(pref && pacc));
//assert_pacc_range_check: assume property (@(posedge clk) disable iff (rst) pacc |-> (pacbadr < NUMRBNK));
assert_prefr_range_check: assume property (@(posedge clk) disable iff (rst) prefr |-> (prfbadr < NUMRBNK));
assert_pacc_prefr_check: assume property (@(posedge clk) disable iff (rst) (pacc && prefr) |-> (pacbadr != prfbadr));
//synopsys translate_on
`endif
endmodule


module ip_top_sva_refr_1stage
  #(
parameter     NUMRBNK = 8,
parameter     BITRBNK = 3,
parameter     REFLOPW = 0,
parameter     NUMRROW = 16,
parameter     BITRROW = 4,
parameter     REFFREQ = 10,
parameter     REFFRHF = 0
   )
(
  input clk,
  input rst,
  input prefr,
  input [BITRBNK-1:0] prfbadr,
  input [BITRBNK-1:0] select_rbnk,
  input [BITRROW-1:0] select_rrow
);
`ifdef FORMAL
//synopsys translate_off

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
      bitcell_cnt <= (REFFREQ >= NUMRBNK) ? REFFREQ*NUMRROW+REFFREQ+NUMRBNK-2 : NUMRBNK*NUMRROW+REFFREQ+REFFREQ-2;
    else if (REFFRHF)
      bitcell_cnt <= (REFFREQ >= NUMRBNK) ? ((NUMRROW%2) ? (2*REFFREQ+1)*(NUMRROW>>1)+REFFREQ+1+NUMRBNK+1 :
                                                           (2*REFFREQ+1)*(NUMRROW>>1)+NUMRBNK+1) : NUMRBNK*NUMRROW+REFFREQ+1;
    else
//      bitcell_cnt <= (REFFREQ >= NUMRBNK) ? REFFREQ*NUMRROW+REFFREQ : NUMRBNK*NUMRROW+REFFREQ; // STICKY MAXREFR=1
      bitcell_cnt <= (REFFREQ > NUMRBNK) ? REFFREQ*NUMRROW+NUMRBNK+1 : NUMRBNK*NUMRROW+REFFREQ;
  else if (|bitcell_cnt)
    bitcell_cnt <= bitcell_cnt - 1;

assert_bitcell_gt0_check: assert property (@(posedge clk) disable iff (rst) (bitcell_cnt != 0));
`ifdef FORMAL
assert_bitcell_gt1_check: assert property (@(posedge clk) disable iff (rst) (bitcell_cnt != 1));
`endif

//synopsys translate_on
`endif
endmodule

`endif

