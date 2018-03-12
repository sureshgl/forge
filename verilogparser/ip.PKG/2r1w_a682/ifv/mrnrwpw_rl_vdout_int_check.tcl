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
cutpoint -add $::env(IFV_HIER).core.mapr_out
cutpoint -add $::env(IFV_HIER).core.cdatr_out
cutpoint -add $::env(IFV_HIER).core.pdatr_out
#cutpoint -add $::env(IFV_HIER).core.sold_vld
#cutpoint -add $::env(IFV_HIER).core.sold_map
#cutpoint -add $::env(IFV_HIER).core.sold_dat
cutpoint -show -all
constraint -add -pin rst 0
constraint -add des.algo_top.assume_select*
if {$::env(IFV_REFR) == 1} {
  constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_refr_noacc_check
}
constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_rw*_check
constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_rd*_check
constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_wr*_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_mapr_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_cdatr_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_pdatr_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_mapw_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_cdatw_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_sold_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_rmem_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_pdout_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_cdout*_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_vdout_int_check
assertion -show -all
prove

