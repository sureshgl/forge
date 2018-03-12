clock -add clk -initial 0
force rst 1
#force write_* 0
#force read_* 0
run 8
force rst 0
#while {[value ready] == "1'h0"} {
#  run 2
#}
init -load -current
#init -show
define effort 1 hours
define engine_profile on
define engine auto_dist
assertion -delete -all
constraint -delete -all
cutpoint -add $::env(IFV_HIER).core.new_vld
cutpoint -add $::env(IFV_HIER).core.new_bank
cutpoint -show -all
constraint -add -pin rst 0
constraint -add des.algo_top.assume_select*
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_sdout_check
#constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_wr_bp_check
#constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_rd_range_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_rd_malloc_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_new_bank_check
#constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_sdout_salloc_bank_check
#constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_free_head_bank_check
#constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_sdout_malloc_bank_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.assert_wr_malloc_missing_check
assertion -show -all
prove