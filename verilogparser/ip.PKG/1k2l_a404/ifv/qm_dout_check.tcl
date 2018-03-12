clock -add clk -initial 0
force rst 1
run 8
force rst 0
#while {[value ready] == "1'h0"} {
#  run 2
#}
init -load -current
init -show
define effort 1 hours
define engine_profile on
define engine auto_dist
assertion -delete -all
constraint -delete -all
cutpoint -add $::env(IFV_HIER).core.optr_out
cutpoint -add $::env(IFV_HIER).core.uptr_out
cutpoint -add $::env(IFV_HIER).core.cnt_out
cutpoint -add $::env(IFV_HIER).core.head_out
cutpoint -add $::env(IFV_HIER).core.tail_out
cutpoint -add $::env(IFV_HIER).core.hdeq_out
#cutpoint -add $::env(IFV_HIER).ip_top_sva.tail_tmp
cutpoint -show -all
constraint -add -pin rst 0
constraint -add $::env(IFV_HIER).assume_select*
#constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_po_mt_check
#constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_po_bb_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_pu_fu_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_pu_al_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_pu_same_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_optr_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_uptr_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_cnt_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_head_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_tail_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_hdeq_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_lnkr_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_datr_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.*assert_pu_uniq_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.*assert_pu_range_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.*assert_po_range_check
#constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_tail_not_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_dout_check
assertion -show -all
prove
