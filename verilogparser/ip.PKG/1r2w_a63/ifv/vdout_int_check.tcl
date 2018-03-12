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
cutpoint -add $::env(IFV_HIER).core.wrmap*_out
cutpoint -add $::env(IFV_HIER).core.wrdat*_out
cutpoint -add $::env(IFV_HIER).core.*.rdmap_out
cutpoint -add $::env(IFV_HIER).core.*.rcdat_out
cutpoint -add $::env(IFV_HIER).core.*.rpdat_out
#cutpoint -add $::env(IFV_HIER).core.sold_vld
#cutpoint -add $::env(IFV_HIER).core.sold_map
#cutpoint -add $::env(IFV_HIER).core.sold_dat
cutpoint -add $::env(IFV_HIER).ip_top_sva.wr_err
cutpoint -show -all
constraint -add -pin rst 0
constraint -add des.algo_top.assume_select*
constraint -add $::env(IFV_HIER).ip_top_sva.assume_wr_err_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_r*_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_wr*_fwd_check
#constraint -add $::env(IFV_HIER).ip_top_sva.assert_sold_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_rmem_check
#constraint -add $::env(IFV_HIER).ip_top_sva.assert_pdout_check
#constraint -add $::env(IFV_HIER).ip_top_sva.assert_ddout*_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_vdout_int_check
assertion -show -all
prove

