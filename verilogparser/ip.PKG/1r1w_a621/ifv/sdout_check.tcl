clock -add clk -initial 0
force rst 1
#force refr 0
#force write_* 0
#force read_* 0
run 16
force rst 0
#while {[value ready] == "1'h0"} {
#  run 2
#}
init -load -current
##init -show
define effort 1 hours
define engine_profile on
define engine auto_dist
#define engine dagger sword
#define halo seq off
#define auto_dist_max 4
#assertion -show -all
assertion -delete -all
constraint -delete -all
cutpoint -add $::env(IFV_HIER_2).rd_dout
cutpoint -add $::env(IFV_HIER_2).rd_fwrd
cutpoint -add $::env(IFV_HIER_2).rd_serr
cutpoint -add $::env(IFV_HIER_2).rd_derr
#cutpoint -add $::env(IFV_HIER_2).rd_padr
#cutpoint -add $::env(IFV_HIER_2).ip_top_sva.mem_serr
#cutpoint -add $::env(IFV_HIER_2).ip_top_sva.mem_derr
cutpoint -show -all
constraint -add -pin rst 0
constraint -add des.algo_top.assume_select*
constraint -add $::env(IFV_HIER_2).ip_top_sva.assert_dout_*err_check
constraint -add $::env(IFV_HIER_2).ip_top_sva.assert_fwrd_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.assert_sdout1_check
assertion -add $::env(IFV_HIER).ip_top_sva.assert_sdout2_check
assertion -add $::env(IFV_HIER).ip_top_sva.assert_ddout1_check
assertion -add $::env(IFV_HIER).ip_top_sva.assert_ddout2_check
assertion -show -all
prove
