clock -add clk -initial 0
force rst 1
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
#define engine hammer sword
#define halo seq off
#define auto_dist_max 4
assertion -delete -all
constraint -delete -all
cutpoint -add $::env(IFV_HIER).write
cutpoint -add $::env(IFV_HIER).wr_adr
cutpoint -add $::env(IFV_HIER).din
cutpoint -add $::env(IFV_HIER).read
cutpoint -add $::env(IFV_HIER).rd_adr
cutpoint -add $::env(IFV_HIER).core.xwrite_req
cutpoint -add $::env(IFV_HIER).core.xwrradr_req
cutpoint -add $::env(IFV_HIER).core.xdin_req
cutpoint -show -all
constraint -add -pin rst 0
constraint -add des.algo_top.assume_select*
constraint -add des.algo_top.*.*.assume_select*
if {$::env(IFV_REFR) == 1} {
  constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_refr_check
  constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_refr_noacc_check
}
constraint -add $::env(IFV_HIER).ip_top_sva_2.assert_rd_wr_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_xdout_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_xwrite_req_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_xmem_req_check
assertion -show -all
prove
