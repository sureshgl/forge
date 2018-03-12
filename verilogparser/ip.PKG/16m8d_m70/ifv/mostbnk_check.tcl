clock -add clk -initial 0
force rst 1
force cp_write 0
force grpbp 12'h000
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
cutpoint -add $::env(IFV_HIER).core.grpbp_vld
cutpoint -add $::env(IFV_HIER).core.freecnt
cutpoint -show -all
constraint -add -pin rst 0
constraint -add -pin cp_write 0
constraint -add algo_top.assume_select*
#constraint -add $::env(IFV_HIER).ip_top_sva_2.assume_grpbp_less_check
#constraint -add $::env(IFV_HIER).ip_top_sva_2.assume_grpbp_cont_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.assert_permmst_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_mostbnk_check
assertion -show -all
prove
