clock -add clk -initial 0
force rst 1
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
cutpoint -add $::env(IFV_HIER).core.cnt_out
cutpoint -show -all
constraint -add -pin rst 0
constraint -add des.algo_top.assume_select*
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_cnt_fwd_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_cmt_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_cnt_check
assertion -show -all
prove
