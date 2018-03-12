clock -add clk -initial 0
force rst 1
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
assertion -show -all
assertion -delete -all
constraint -delete -all
cutpoint -add $::env(IFV_HIER).core.xor_data
cutpoint -show -all
constraint -add -pin rst 0
constraint -add $::env(IFV_HIER).assume_select*
constraint -add $::env(IFV_HIER).ip_top_sva_2.assert_rd_wr_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_pdout_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_xor_more_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.assert_fakemem_check
assertion -show -all
prove

