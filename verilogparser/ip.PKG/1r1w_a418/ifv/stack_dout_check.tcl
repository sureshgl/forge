clock -add clk -initial 0
force rst 1
#force refr 0
force write* 0
force read* 0
run 8
force rst 0
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
cutpoint -show -all
constraint -add -pin rst 0
constraint -add $::env(IFV_HIER).assume_select*
constraint -add $::env(IFV_HIER_STACK).ip_top_sva_2.*.assert_rd_range_check
constraint -add $::env(IFV_HIER_STACK).ip_top_sva_2.*.assert_wr_range_check
constraint -add $::env(IFV_HIER_STACK).ip_top_sva.*.assert_mem_check
constraint -show -all
assertion -add $::env(IFV_HIER_STACK).ip_top_sva.*.assert_dout_check
assertion -add $::env(IFV_HIER_STACK).ip_top_sva.*.assert_fakemem_check
assertion -show -all
prove
