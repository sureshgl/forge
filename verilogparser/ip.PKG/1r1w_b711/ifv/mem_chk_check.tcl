clock -add rd_clk_0 -initial 0
clock -add wr_clk_1 -initial 0
force wr_rst_1 1
force rd_rst_0 1
#force refr 0
#force write_* 0
#force read_* 0
run 16
force rd_rst_0 0
force wr_rst_1 0
run 2
init -load -current
##init -show
define effort 1 hours
define engine_profile on
define engine auto_dist
#define engine sword3
#define halo seq off
#define auto_dist_max 4
assertion -delete -all
constraint -delete -all
cutpoint -show -all
constraint -add -pin rd_rst_0 0
constraint -add -pin wr_rst_1 0
constraint -add $::env(IFV_HIER).assume_select*
constraint -add $::env(IFV_HIER).ip_top_sva.assert_mem_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.assert_mem_chk_check
assertion -show -all
prove
