clock -add rd_clk_0 -initial 0
clock -add wr_clk_1 -initial 0
force wr_rst_1 1
force rd_rst_0 1
#force refr 0
#force write_* 0
#force read_* 0
run 8
force rd_rst_0 0
force wr_rst_1 0
run 2
init -load -current
##init -show
define effort 1 hours
define engine_profile on
define engine auto_dist
#define engine dagger sword
#define halo seq off
#define auto_dist_max 4
assertion -delete -all
constraint -delete -all
#cutpoint -add $::env(IFV_HIER_2).rd_dout
cutpoint -show -all
constraint -add -pin rd_rst_0 0
constraint -add -pin wr_rst_1 0
constraint -add des.algo_top.assume_select*
constraint -add des.algo_top.*.*.assume_select*
#constraint -add $::env(IFV_HIER).ip_top_sva_2.assert_rd_wr_check
constraint -add $::env(IFV_HIER_2).ip_top_sva.*assert_dout_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_pdout_check
assertion -show -all
prove
