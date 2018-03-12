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
#init -show
define effort 1 hours
define engine_profile on
define engine auto_dist
constraint -add -pin rst 0
assertion -delete -all
constraint -delete -all
#cutpoint -add $::env(IFV_HIER).core.*.rdcnt_out
cutpoint -show -all
constraint -add -pin rst 0
constraint -add des.algo_top.assume_select*
constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_ru_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_r*_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_pdout_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_dout_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_serr_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_derr_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_padr_check
assertion -show -all
prove

