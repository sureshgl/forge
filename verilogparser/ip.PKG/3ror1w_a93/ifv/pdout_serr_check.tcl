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
#define engine dagger sword
#define halo seq off
#define auto_dist_max 4
assertion -delete -all
constraint -delete -all
cutpoint -add $::env(IFV_HIER).ip_top_sva.wr_serr
cutpoint -add $::env(IFV_HIER_2).ip_top_sva.mem_serr
cutpoint -add $::env(IFV_HIER_2).ip_top_sva.mem_derr
cutpoint -add $::env(IFV_HIER_2).ip_top_sva.xmem_serr
cutpoint -add $::env(IFV_HIER_2).ip_top_sva.xmem_derr
cutpoint -add $::env(IFV_HIER_2).rd_dout
cutpoint -add $::env(IFV_HIER_2).rd_fwrd
cutpoint -add $::env(IFV_HIER_2).rd_serr
cutpoint -add $::env(IFV_HIER_2).rd_derr
cutpoint -add $::env(IFV_HIER_3).rd_dout
cutpoint -add $::env(IFV_HIER_3).rd_fwrd
cutpoint -add $::env(IFV_HIER_3).rd_serr
cutpoint -add $::env(IFV_HIER_3).rd_derr
cutpoint -show -all
constraint -add -pin rst 0
constraint -add des.algo_top.assume_select*
constraint -add des.algo_top.*.*.assume_select*
constraint -add des.algo_top.*.assume_wr_*err_check
constraint -add $::env(IFV_HIER).ip_top_sva_2.assert_rd_wr_check
constraint -add $::env(IFV_HIER_2).ip_top_sva.*.assume_mem_*err_check
constraint -add $::env(IFV_HIER_2).ip_top_sva.*.assume_xmem_*err_check
constraint -add $::env(IFV_HIER_2).ip_top_sva.*.assert_fwrd_*err_check
constraint -add $::env(IFV_HIER_2).ip_top_sva.*.assert_dout_*err*_check
constraint -add $::env(IFV_HIER_2).ip_top_sva.*.assert_derr_*err_check
constraint -add $::env(IFV_HIER_3).ip_top_sva.*.assert_dout_check
constraint -add $::env(IFV_HIER_3).ip_top_sva.*.assert_fwrd_check
constraint -add $::env(IFV_HIER_3).ip_top_sva.*.assert_derr_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_pdout_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_xdout_check
assertion -show -all
prove
