
clock -add clk -initial 0
force rst 1
force cp_read 0
force cp_write 0
run 8
force rst 0
while {[value ready] == "1'h0"} {
  run 2
}
init -load -current
init -show
define effort 1 hours
define engine_profile on
define engine auto_dist
assertion -delete -all
constraint -delete -all
cutpoint -show -all
constraint -add -pin rst 0
constraint -add -pin cp_read 0
constraint -add -pin cp_write 0
constraint -add assume_select*
constraint -add ip_top_sva.*.assert_pu_fu_check
constraint -add ip_top_sva.*.assert_pu_al_check
constraint -show -all
assertion -add ip_top_sva.*.assert_lnkw_check
assertion -show -all
prove
