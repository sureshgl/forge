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
define effort 2 hours
define engine_profile on
define engine auto_dist
constraint -add -pin rst 0
assertion -show -all
assertion -delete -all
constraint -delete -all
cutpoint -add $::env(IFV_HIER).core.wrmap_out
cutpoint -add $::env(IFV_HIER).core.wrdat_out
cutpoint -add $::env(IFV_HIER).core.rdmap_out
cutpoint -add $::env(IFV_HIER).core.rddat_out
#cutpoint -add $::env(IFV_HIER).core.pdat_out
cutpoint -add $::env(IFV_HIER).core.vdout_int
#cutpoint -add $::env(IFV_HIER).core.wr_srch_flag
#cutpoint -add $::env(IFV_HIER).core.wr_srch_data
cutpoint -show -all
constraint -add -pin rst 0
constraint -add des.algo_top.assume_select*
constraint -add $::env(IFV_HIER).ip_top_sva.assert_rd*_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_wr*_fwd_check
#constraint -add $::env(IFV_HIER).ip_top_sva.assert_pdat_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_mapmem_ecc_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_pdout_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_ddout2_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_rmem_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_vdout_int_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_fakemem_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.assert_dout_check
assertion -add $::env(IFV_HIER).ip_top_sva.assert_fwrd_check
assertion -add $::env(IFV_HIER).ip_top_sva.assert_padr_check
assertion -show -all
prove

