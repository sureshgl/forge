clock -add clk -initial 0
force rst 1
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
assertion -show -all
assertion -delete -all
constraint -delete -all
cutpoint -add $::env(IFV_HIER).core.*.sdout*bit*err*
cutpoint -add $::env(IFV_HIER).core.*.sdout*bit*pos*
cutpoint -add $::env(IFV_HIER).ip_top_sva.*.state_serr
cutpoint -add $::env(IFV_HIER).ip_top_sva.*.state_derr
cutpoint -add $::env(IFV_HIER).core.swrite_wire
cutpoint -add $::env(IFV_HIER).core.swrradr_wire
cutpoint -add $::env(IFV_HIER).core.*.sdin_pre_ecc
cutpoint -show -all
constraint -add -pin rst 0
constraint -add des.algo_top.assume_select*
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_sdout_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assume_state_*err_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_sdout_ecc_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_sdout_*err_check
assertion -show -all
prove
