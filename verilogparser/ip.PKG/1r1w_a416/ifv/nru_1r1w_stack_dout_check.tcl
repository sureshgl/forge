clock -add clk -initial 0
force rst 1
#force refr 0
#force write_* 0
#force read_* 0
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
#define engine dagger sword
#define halo seq off
#define auto_dist_max 4
assertion -delete -all
constraint -delete -all
cutpoint -show -all
constraint -add -pin rst 0
constraint -add $::env(IFV_HIER).assume_select*
#constraint -add $::env(IFV_HIER).ip_top_sva_2.assert_rd_range_check
constraint -add $::env(IFV_HIER).ip_top_sva_2.assert_wr_range_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_mem_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.assert_dout_check
assertion -add $::env(IFV_HIER).ip_top_sva.assert_derr_check
assertion -add $::env(IFV_HIER).ip_top_sva.assert_fwrd_check
assertion -add $::env(IFV_HIER).ip_top_sva.assert_padr_check
assertion -show -all
prove
