clock -add clk -initial 0
force rst 1
force push 0
force pop 0
run 16
force rst 0
while {[value ready] == "1'h0"} {
  run 2
}
run 8
init -load -current
init -show
define effort 1 hours
#define effort 500 seconds
define engine_profile on
define engine auto_dist
assertion -delete -all
constraint -delete -all
cutpoint -show -all
constraint -add -pin rst 0
#constraint -add -pin uprt 0
#constraint -add -pin oprt 0
constraint -add algo_top.assume_select*
constraint -add algo_top.*.assume_select*
constraint -add algo_top.assert_rff_pop_check
constraint -add algo_top.assert_rfffcnt_check
constraint -add algo_top.assert_tot_pop_check
constraint -add algo_top.assert_totlcnt_check
constraint -add algo_top.assert_freecnt_check
constraint -add algo_top.*.*assert_oth_push_check
constraint -add algo_top.*.assert_oth_pop_check
constraint -add algo_top.*.*assert_pu_uniq_check
constraint -add algo_top.a1_loop.algo_qm.ip_top_sva.*.assert_optr_fwd_check
constraint -add algo_top.a1_loop.algo_qm.ip_top_sva.*.assert_uptr_fwd_check
constraint -add algo_top.a1_loop.algo_qm.ip_top_sva.*.assert_cnt_fwd_check
constraint -add algo_top.a1_loop.algo_qm.ip_top_sva.*.assert_head_fwd_check
constraint -add algo_top.a1_loop.algo_qm.ip_top_sva.*.assert_tail_fwd_check
constraint -add algo_top.a1_loop.algo_qm.ip_top_sva.*.assert_hdeq_fwd_check
constraint -add algo_top.a1_loop.algo_qm.ip_top_sva.*.assert_lnkr_check
constraint -add algo_top.a1_loop.algo_qm.ip_top_sva.*.assert_lnkw_check
constraint -add algo_top.a1_loop.algo_qm.ip_top_sva.*.assert_datr_check
constraint -add algo_top.a1_loop.algo_qm.ip_top_sva.*.assert_datw_check
constraint -add algo_top.a1_loop.algo_qm.ip_top_sva.*.assert_pu_fu_check
constraint -add algo_top.a1_loop.algo_qm.ip_top_sva.*.assert_pu_al_check
constraint -add algo_top.a1_loop.algo_qm.ip_top_sva.assert_pu_same_check
constraint -add algo_top.a2_loop.algo_fl.ip_top_sva.*.assert_lnkr_check
constraint -add algo_top.a2_loop.algo_fl.ip_top_sva.*.assert_lnkw_check
constraint -add algo_top.a2_loop.algo_fl.ip_top_sva.*.assert_po_mt_check
constraint -add algo_top.a2_loop.algo_fl.ip_top_sva.*.assert_pu_fu_check
constraint -add algo_top.a2_loop.algo_fl.ip_top_sva.*.assert_pu_al_check
constraint -add algo_top.a2_loop.algo_fl.ip_top_sva.*.*.assert_pu_ptr_dup_check
constraint -show -all
assertion -add algo_top.*.assert_rff_dat_check
assertion -add algo_top.*.assert_rff_pre_check
assertion -show -all
prove
