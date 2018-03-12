clock -add clk -initial 0
force rst 1
#force refr 0
#force write_* 0
#force read_* 0
run 8
force rst 0
while {[value ready] == "1'h0"} {
  run 2
}
init -load -current
init -show
define effort 4 hours
define engine_profile on
#define engine auto_dist
assertion -delete -all
constraint -delete -all
cutpoint -show -all
constraint -add -pin rst 0
constraint -add -pin ena_rdacc 1
constraint -add des.algo_top.assume_1r1rw*
constraint -add des.algo_top.assume_ena_rdacc*
constraint -add des.algo_top.vrpt_int_loop.*.assume_1r1rw_check
constraint -add $::env(IFV_HIER).ip_top_sva_2.assert_rd_wr_check
constraint -show -all
#assertion -add $::env(IFV_HIER_2).ip_top_sva_2.assert_rd_range_check
assertion -add $::env(IFV_HIER_2).ip_top_sva_2.assert_wr_range_check
assertion -show -all
prove
