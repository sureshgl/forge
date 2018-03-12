clock -add clk -initial 0
force rst 1
#force algo_sel 0
#force refr 0
#force write_* 0
#force read_* 0
run 8
force rst 0
while {[value $::env(IFV_HIER_RDY).ready] == "1'h0"} {
  run 2
}
init -load -current
#init -show
define effort 1 hours
define engine_profile on
define engine auto_dist
#define engine saber dagger bow3 sword3 hammer
#define engine dagger sword
#define halo seq off
#define auto_dist_max 4
assertion -delete -all
constraint -delete -all
cutpoint -add $::env(IFV_HIER_1).ip_top_sva.mem_serr
cutpoint -add $::env(IFV_HIER_1).ip_top_sva.mem_derr
cutpoint -add $::env(IFV_HIER_1).ip_top_sva.xmem_serr
cutpoint -add $::env(IFV_HIER_1).ip_top_sva.xmem_derr
cutpoint -add $::env(IFV_HIER_1).t1_doutA
cutpoint -add $::env(IFV_HIER_1).t1_fwrdA
cutpoint -add $::env(IFV_HIER_1).t1_serrA
cutpoint -add $::env(IFV_HIER_1).t1_derrA
cutpoint -add $::env(IFV_HIER_1).t2_doutA
cutpoint -add $::env(IFV_HIER_1).t2_fwrdA
cutpoint -add $::env(IFV_HIER_1).t2_serrA
cutpoint -add $::env(IFV_HIER_1).t2_derrA
cutpoint -add $::env(IFV_HIER_1).core.xor_fwd_data
cutpoint -add $::env(IFV_HIER_1).core.xor_data
cutpoint -show -all
constraint -add -pin rst 0
constraint -add $::env(IFV_HIER_1).assume_select*
constraint -add $::env(IFV_HIER_1).ip_top_sva_2.assert_rd_wr_check
constraint -add $::env(IFV_HIER_1).ip_top_sva.*.assume_mem_*err_check
constraint -add $::env(IFV_HIER_1).ip_top_sva.*.assume_xmem_*err_check
constraint -add $::env(IFV_HIER_1).ip_top_sva.*.assert_pdout_check
constraint -add $::env(IFV_HIER_1).ip_top_sva.*.assert_xor_more_check
constraint -add $::env(IFV_HIER_1).ip_top_sva.assert_fakemem_check
constraint -add $::env(IFV_HIER_2).assume_select*
constraint -add $::env(IFV_HIER_2).ip_top_sva_2.assert_rd_wr_check
constraint -add $::env(IFV_HIER_2).ip_top_sva.*.assume_mem_*err_check
constraint -add $::env(IFV_HIER_2).ip_top_sva.*.assume_xmem_*err_check
constraint -add $::env(IFV_HIER_2).ip_top_sva.*.assert_pdout_check
constraint -add $::env(IFV_HIER_2).ip_top_sva.*.assert_xor_more_check
constraint -add $::env(IFV_HIER_2).ip_top_sva.assert_fakemem_check
constraint -add $::env(IFV_HIER).assume*
constraint -show -all
assertion -add $::env(IFV_HIER).assert_*
assertion -show -all
prove
