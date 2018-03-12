clock -add clk -initial 0
force rst 1
#force write_* 0
#force read_* 0
run 8
force rst 0
while {[value ready] == "1'h0"} {
  run 2
}
init -load -current
#init -show
define effort 1 hours
define engine_profile on
define engine auto_dist
assertion -delete -all
constraint -delete -all
#cutpoint -add $::env(IFV_HIER).core.wrmap_out
#cutpoint -add $::env(IFV_HIER).core.wrdat_out
#cutpoint -add $::env(IFV_HIER).core.rdmap_out
#cutpoint -add $::env(IFV_HIER).core.rddat_out
#cutpoint -add $::env(IFV_HIER).core.sold_vld
#cutpoint -add $::env(IFV_HIER).core.sold_map
#cutpoint -add $::env(IFV_HIER).core.sold_dat
cutpoint -show -all
constraint -add -pin rst 0
constraint -add algo_top.assume_select*
#constraint -add $::env(IFV_HIER).ip_top_sva.assert_rd*_fwd_check
#constraint -add $::env(IFV_HIER).ip_top_sva.assert_wr*_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_vmem_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.assert_fakemem_check
assertion -show -all
prove
