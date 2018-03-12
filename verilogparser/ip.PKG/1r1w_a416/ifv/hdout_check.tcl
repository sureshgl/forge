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
constraint -add des.algo_top.assume_select*
constraint -add $::env(IFV_HIER).assume_select*
constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_pu_range_check
constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_po_range_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_hp*_ru_check
constraint -add $::env(IFV_HIER_A6).ip_top_sva_2.*ru_check
constraint -add $::env(IFV_HIER_A6).ip_top_sva.*.assert_r*_fwd_check
constraint -add $::env(IFV_HIER_A6).ip_top_sva.assert_wr*_fwd_check
constraint -add $::env(IFV_HIER_A6).ip_top_sva.assert_rmem_check
constraint -add $::env(IFV_HIER_A6).ip_top_sva.*.assert_dout_check
constraint -add $::env(IFV_HIER_A6).ip_top_sva.assert_fakemem_check
constraint -add $::env(IFV_HIER_ALIGN).ip_top_sva.assert_mem_check
constraint -add $::env(IFV_HIER_STACK).ip_top_sva.assert_mem_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_hdout_check
assertion -show -all
prove
