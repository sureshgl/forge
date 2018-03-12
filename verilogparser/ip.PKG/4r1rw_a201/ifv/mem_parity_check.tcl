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
define engine sword3
#define engine auto_dist
#define halo seq off
#define auto_dist_max 4
assertion -delete -all
constraint -delete -all
cutpoint -show -all
constraint -add -pin rst 0
constraint -add -pin ena_rdacc 1
constraint -add $::env(IFV_HIER).assume_select*
constraint -add des.algo_top.assume_1r1rw*
constraint -add des.algo_top.assume_ena_rdacc*
constraint -add des.algo_top.vrpt_int_loop.*.assume_1r1rw_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_mem_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.assert_mem_parity_check
assertion -show -all
prove