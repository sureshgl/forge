clock -add clk -initial 0
force rst 1
force cp_write 0
force grpmsk 12'h000
force grpbp 12'h000
#force write_* 0
#force read_* 0
run 32
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
cutpoint -add $::env(IFV_HIER).core.new_bnk_temp
cutpoint -add $::env(IFV_HIER).core.new_radr
cutpoint -show -all
constraint -add -pin rst 0
constraint -add -pin cp_write 0
constraint -add algo_top.assume_select*
constraint -add $::env(IFV_HIER).ip_top_sva.assert_pdout_check
constraint -add $::env(IFV_HIER).ip_top_sva_2.assume_grpmsk_stable
constraint -add $::env(IFV_HIER).ip_top_sva_2.assume_grpbp_stable
constraint -add $::env(IFV_HIER).ip_top_sva_2.assume_grpbp_less_check
constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_ma_bp_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_rd_pseudo_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_ma_pseudo_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_ma_grpmsk_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_wr_grpmsk_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_rd_ma_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_ma_dout_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_wr_dout_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_fwrd_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_derr_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_padr_check
assertion -show -all
prove
