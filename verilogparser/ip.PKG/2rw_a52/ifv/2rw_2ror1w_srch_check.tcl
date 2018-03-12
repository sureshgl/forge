clock -add clk -initial 0
force rst 1
#force refr 0
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
#define engine hammer saber sword3 sword
assertion -delete -all
constraint -delete -all
cutpoint -add $::env(IFV_HIER).core.wmap*_out
cutpoint -add $::env(IFV_HIER).core.wcdat*_out
cutpoint -add $::env(IFV_HIER).core.sold_vld*
cutpoint -add $::env(IFV_HIER).core.sold_map*
cutpoint -add $::env(IFV_HIER).core.sold_dat*
#cutpoint -add $::env(IFV_HIER).core.sold_ser*
#cutpoint -add $::env(IFV_HIER).core.sold_der*
cutpoint -show -all
constraint -add -pin rst 0
constraint -add des.algo_top.assume_select*
if {$::env(IFV_REFR) == 1} {
  constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_refr_noacc_check
}
constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_rw_1p_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_wmap*_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_wcdat*_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_sold*_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_smem_ecc_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_rmem_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_vmem_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.assert_srch*_check
assertion -show -all
prove

