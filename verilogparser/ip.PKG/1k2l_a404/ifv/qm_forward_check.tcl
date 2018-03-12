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
cutpoint -show -all
constraint -add -pin rst 0
constraint -add $::env(IFV_HIER).assume_select*
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_odout_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_udout_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_cdout_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_hdout_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_tdout_check
constraint -add $::env(IFV_HIER).ip_top_sva*.*assert_pu_uniq_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_optr_fwd_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_uptr_fwd_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_cnt_fwd_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_head_fwd_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_tail_fwd_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_hdeq_fwd_check
assertion -show -all
prove
