clock -add clk -initial 0
force rst 1
#force refr 0
#force write_* 0
#force read_* 0
run 16
force rst 0
while {[value ready] == "1'h0"} {
  run 2
}
init -load -current
#init -show
define effort 1 hours
define engine_profile on
define engine auto_dist
assertion -delete -all
constraint -delete -all
cutpoint -add $::env(IFV_HIER).core.mapw_out
cutpoint -add $::env(IFV_HIER).core.cdatw_out
cutpoint -show -all
constraint -add -pin rst 0
constraint -add des.algo_top.assume_select*
if {$::env(IFV_REFR) == 1} {
  constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_refr_noacc_check
}
constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_rw_1p_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_mapw_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_cdatw_fwd_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_sold_fwd_check
assertion -add $::env(IFV_HIER).ip_top_sva.assert_wrfifo_check
assertion -show -all
prove

