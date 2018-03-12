clock -add clk -initial 0
force rst 1
force cp_write 0
force dq_vld 0
force bp_thr 12'h000
force bp_hys 12'h000
#force grpmsk 12'h000
#force grpbp 12'h000
#force ena_rand 1'b0
#force write_* 0
#force read_* 0
run 32
force rst 0
run 32
force cp_write 1
force cp_adr 10'h000
force cp_din 'h7FC008
run 2
force cp_write 1
force cp_adr 10'h001
force cp_din 'h7FC008
run 2
force cp_write 1
force cp_adr 10'h002
force cp_din 'h7FC008
run 2
force cp_write 1
force cp_adr 10'h003
force cp_din 'h7FC008
run 2
force cp_write 1
force cp_adr 10'h004
force cp_din 'h7FC008
run 2
force cp_write 1
force cp_adr 10'h005
force cp_din 'h7FC008
run 2
force cp_write 1
force cp_adr 10'h006
force cp_din 'h7FC008
run 2
force cp_write 1
force cp_adr 10'h007
force cp_din 'h7FC008
run 2
force cp_write 1
force cp_adr 10'h008
force cp_din 'h7FC008
run 2
force cp_write 1
force cp_adr 10'h009
force cp_din 'h7FC008
run 2
force cp_write 1
force cp_adr 10'h00a
force cp_din 'h7FC008
run 2
force cp_write 1
force cp_adr 10'h00b
force cp_din 'h7FC008
run 2
force cp_write 0
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
cutpoint -add $::env(IFV_HIER).core.new_vld_wire
cutpoint -add $::env(IFV_HIER).core.new_bnk_wire
cutpoint -show -all
constraint -add -pin rst 0
constraint -add -pin cp_write 0
constraint -add -pin bp_thr 12'h000
constraint -add -pin bp_hys 12'h000
#constraint -add -pin ena_rand 1'b0
#constraint -add -pin grpmsk 12'h03F
#constraint -add -pin grpbp 12'h03F
constraint -add algo_top.assume_select*
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_dq_fif_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_dq_alp_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_dq_same_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_ma_pseudo_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_lnkr_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_freecnt_sel_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_ma_fwrd_check
#assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_ma_radr_check
#assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_lnkw_check
assertion -show -all
prove
