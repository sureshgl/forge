clock -add clk -initial 0
force rst 1
force write_* 0
force read_*  0
run 8
#force rst 0
#run 4
init -load -current
init -show
define effort 1 hours
#define effort 500 seconds
define engine_profile on
define engine auto_dist
assertion -delete -all
constraint -delete -all
cutpoint -show -all
constraint -add -pin rst 0
constraint -add des.assume_select*
constraint -add des.ip_top_sva_2.*.assert_wr_range_check
constraint -add des.ip_top_sva_2.*.assert_rd_range_check
constraint -add des.ip_top_sva.*.assert_pdout*_check
constraint -show -all
assertion -add des.ip_top_sva.*.assert_dout_check
assertion -show -all
prove
