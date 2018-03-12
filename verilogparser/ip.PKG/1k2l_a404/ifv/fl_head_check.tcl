clock -add clk -initial 0
force rst 1
force $::env(IFV_HIER).cp_read 0
force $::env(IFV_HIER).cp_write 0
run 8
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
constraint -add -pin $::env(IFV_HIER).rst 0
constraint -add -pin $::env(IFV_HIER).cp_read 0
constraint -add -pin $::env(IFV_HIER).cp_write 0
constraint -add $::env(IFV_HIER).assume_select*
constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_pu_range_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_po_mt_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_pu_fu_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_pu_al_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_lnkr_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_lnkw_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_pu_ptr_dup_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_head_check
assertion -show -all
prove
