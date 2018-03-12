clock -add clk -initial 0
force rst 1
#force read 0
#force write 0
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
assertion -delete -all
constraint -delete -all
cutpoint -add $::env(IFV_HIER_A5).core.wrmap*_out
cutpoint -add $::env(IFV_HIER_A5).core.wrdat*_out
#cutpoint -add $::env(IFV_HIER_A5).core.*.rdmap_out
#cutpoint -add $::env(IFV_HIER_A5).core.*.r*dat_out
#cutpoint -add $::env(IFV_HIER_A5).ip_top_sva.wr_err
cutpoint -show -all
constraint -add -pin rst 0
constraint -add des.algo_top.assume_select*
constraint -add $::env(IFV_HIER).assume_select*
constraint -add $::env(IFV_HIER_A5).ip_top_sva_2.*.assert_ru_check
constraint -add $::env(IFV_HIER_A5).ip_top_sva_2.*.assert_ru_range_check
#constraint -add $::env(IFV_HIER_A5).ip_top_sva.assume_wr_err_check
#constraint -add $::env(IFV_HIER_A5).ip_top_sva.*.assert_r*_fwd_check
constraint -add $::env(IFV_HIER_A5).ip_top_sva.assert_wr*_fwd_check
constraint -add $::env(IFV_HIER_A5).ip_top_sva.assert_rmem_check
constraint -show -all
assertion -add $::env(IFV_HIER_A5).ip_top_sva.assert_fakemem_check
assertion -show -all
prove

