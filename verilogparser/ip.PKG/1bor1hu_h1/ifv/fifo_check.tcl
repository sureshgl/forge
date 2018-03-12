clock -add clk -initial 0
force rst 1
run 8
force rst 0
while {[value ready] == "1'h0"} {
  run 2
}
init -load -current
init -show
define effort 10 minutes
define engine_profile on
#define engine auto_dist
assertion -delete -all
constraint -delete -all
cutpoint -add core.sr_hash
cutpoint -add core.up_hash
cutpoint -add ip_top_sva.select_t1row
cutpoint -show -all
constraint -add -pin rst 0
constraint -add assume_select*
constraint -add ip_top_sva.*.assert_*_row_check
constraint -add ip_top_sva.*.assert_tdout*_check
constraint -add ip_top_sva.*.assert_qmem*_check
constraint -show -all
assertion -add ip_top_sva.assert_fifo_*_check
assertion -show -all
prove
