clock -add clk -initial 0
clock -add lclk -initial 0
force rst 1
force rst_l 1
force write_* 0
force read_* 0
run 16
force rst 0
force rst_l 0
while {[value ready] == "2'h0"} {
  run 2
}
init -load -current
init -show
define effort 1 hours
define engine_profile on
#define engine auto_dist
assertion -delete -all
constraint -delete -all
cutpoint -show -all
constraint -add -pin rst 0
constraint -add -pin rst_l 0
constraint -add des.algo_top.assume_select*
constraint -add $::env(IFV_HIER).ip_top_sva_2.rd_loop*.assume_rd_range_check
constraint -add $::env(IFV_HIER).ip_top_sva_2.wr_loop*.assume_wr_range_check
constraint -add $::env(IFV_HIER).ip_top_sva_2.rrate_loop.bb_l*.assume_read_rate
constraint -add $::env(IFV_HIER).ip_top_sva_2.wrate_loop.pa_l*.ba_l*.assume_write_rate
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.lp_ctrl.bank*.rport*.assert_t1_rd_vld_del_check
assertion -add $::env(IFV_HIER).ip_top_sva.lp_ctrl.bank*.wport*.assert_t1_wr_vld_del_check
assertion -show -all
prove

