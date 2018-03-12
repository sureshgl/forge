clock -add clk -initial 0
force rst 1
force ena_rdacc 1
#force refr 0
#force write_* 0
#force read_* 0
run 8
force rst 0
while {[value ready] == "1'h0"} {
  run 2
}
init -load -current
init -show
define effort 4 hours
define engine_profile on
#define engine auto_dist
#define engine dagger sword
#define halo seq off
#define auto_dist_max 4
assertion -delete -all
constraint -delete -all
cutpoint -add $::env(IFV_HIER_2).rd_dout
cutpoint -add $::env(IFV_HIER_2).rd_fwrd
cutpoint -add $::env(IFV_HIER_2).rd_serr
cutpoint -add $::env(IFV_HIER_2).rd_derr
#cutpoint -add $::env(IFV_HIER_2).rd_padr
cutpoint -show -all
constraint -add -pin rst 0
constraint -add -pin ena_rdacc 1
constraint -add des.algo_top.assume_select*
constraint -add des.algo_top.*.*.assume_select*
constraint -add des.algo_top.assume_1r1rw*
constraint -add des.algo_top.assume_ena_rdacc*
constraint -add des.algo_top.vrpt_int_loop.*.assume_1r1rw_check
constraint -add $::env(IFV_HIER).ip_top_sva_2.assert_rd_wr_check
constraint -add $::env(IFV_HIER_2).ip_top_sva.assert_dout_*err_check
constraint -add $::env(IFV_HIER_2).ip_top_sva.assert_fwrd_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_pdout_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_xdout_check
assertion -show -all
prove
