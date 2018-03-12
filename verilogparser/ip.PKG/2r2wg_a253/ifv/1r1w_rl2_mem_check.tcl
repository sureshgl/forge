clock -add clk -initial 0
force rst 1
#force write_* 0
#force read_* 0
run 16
force rst 0
while {[value ready] == "1'h0"} {
  run 2
}
init -load -current
init -show
define effort 1 hours
define engine_profile on
define engine auto_dist
assertion -show -all
assertion -delete -all
constraint -delete -all
cutpoint -show -all
cutpoint -add $::env(IFV_HIER).core.wrmap_out
constraint -add -pin rst 0
constraint -add des.algo_top.assume_select*
constraint -add $::env(IFV_HIER).ip_top_sva_2.assert_rd_alloc_check
constraint -add $::env(IFV_HIER).ip_top_sva_2.assert_wr_alloc_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_wrmap_alloc_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva_2.*.assert_t1_1port_check
assertion -add $::env(IFV_HIER).ip_top_sva_2.*.assert_t2_wr_same_check
assertion -add $::env(IFV_HIER).ip_top_sva_2.*.assert_t2_rw_pseudo_check
assertion -show -all
prove