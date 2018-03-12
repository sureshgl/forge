clock -add clk -initial 0
force rst 1
run 16
force rst 0
while {[value ready] == "1'h0"} {
  run 2
}
init -load -current
#init -show
define effort 48 hours
define engine_profile on
define engine auto_dist
#define engine dagger sword
#define halo seq off
define auto_dist_max 4
assertion -delete -all
constraint -delete -all
cutpoint -show -all
constraint -add -pin rst 0
constraint -add des.algo_top.assume_select*
constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_wr_range_check
constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_rd_range_check
constraint -add $::env(IFV_HIER).ip_top_sva_2.assert_rd_wr_bank_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_fakemem_check
assertion -show -all
prove

