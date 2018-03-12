clock -add clk -initial 0
force rst 1
force cp_write 0
force ena_rand 0
#force write_* 0
#force read_* 0
run 32
force rst 0
run 32
force cp_write 1
force cp_adr 10'h000
force cp_din 'd32
run 2
force cp_write 1
force cp_adr 10'h001
force cp_din 'd32
run 2
force cp_write 1
force cp_adr 10'h002
force cp_din 'd32
run 2
force cp_write 1
force cp_adr 10'h003
force cp_din 'd32
run 2
force cp_write 1
force cp_adr 10'h004
force cp_din 'd32
run 2
force cp_write 1
force cp_adr 10'h005
force cp_din 'd32
run 2
force cp_write 1
force cp_adr 10'h006
force cp_din 'd32
run 2
force cp_write 1
force cp_adr 10'h007
force cp_din 'd32
run 2
force cp_write 1
force cp_adr 10'h008
force cp_din 'd32
run 2
force cp_write 1
force cp_adr 10'h009
force cp_din 'd32
run 2
force cp_write 1
force cp_adr 10'h00a
force cp_din 'd32
run 2
force cp_write 1
force cp_adr 10'h00b
force cp_din 'd32
run 2
force cp_write 0
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
cutpoint -add $::env(IFV_HIER).core.mostbnk_tmp
cutpoint -show -all
constraint -add -pin rst 0
constraint -add -pin cp_write 0
constraint -add algo_top.assume_select*
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_dq_fak_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_permide_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_perminv_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_permmat_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_freecnt_check
assertion -show -all
prove
