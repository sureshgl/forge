clock -add clk -initial 0
clock -add lclk -initial 0
force rst 1
force rst_l 1
#force write_* 0
#force read_* 0
run 16
force rst 0
force rst_l 0
while {[value ready] == "1'h0"} {
  run 2
}
init -load -current
#init -show
define effort 1 hours
define engine_profile on
define engine auto_dist
constraint -add -pin rst 0
constraint -add -pin rst_l 0
assertion -delete -all
constraint -delete -all
cutpoint -add $::env(IFV_HIER).core.wrmap*_out
cutpoint -add $::env(IFV_HIER).core.wrdat*_out
cutpoint -add $::env(IFV_HIER).core.*.rdmap_out
cutpoint -add $::env(IFV_HIER).core.*.rcdat_out
cutpoint -add $::env(IFV_HIER).core.*.rpdat_out
cutpoint -add $::env(IFV_HIER).core.vdout_int
cutpoint -add $::env(IFV_HIER).ip_top_sva.*.dout_bit1_err
cutpoint -add $::env(IFV_HIER).ip_top_sva.*.dout_bit1_pos
cutpoint -add $::env(IFV_HIER).ip_top_sva.*.dout_bit2_err
cutpoint -add $::env(IFV_HIER).ip_top_sva.*.dout_bit2_pos
cutpoint -add $::env(IFV_HIER).ip_top_sva.*.mem_serr
cutpoint -add $::env(IFV_HIER).ip_top_sva.*.mem_derr
#cutpoint -add $::env(IFV_HIER).core.wr_srch_flag
#cutpoint -add $::env(IFV_HIER).core.wr_srch_data
cutpoint -add $::env(IFV_HIER).ip_top_sva.wr_err
cutpoint -show -all
constraint -add -pin rst 0
constraint -add -pin rst_l 0
constraint -add des.algo_top.assume_select*
constraint -add $::env(IFV_HIER).ip_top_sva.assume_wr_err_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_r*_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_wr*_fwd_check
#constraint -add $::env(IFV_HIER).ip_top_sva.assert_pdat_fwd_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_pdout_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_cdout_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_rmem_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assume_mem_*err_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_eccmem_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_vdout_int_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_mem_chk_check
#constraint -add $::env(IFV_HIER).ip_top_sva.assert_vmem_check
#constraint -add $::env(IFV_HIER).ip_top_sva.assert_srch_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_fakemem_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_dout_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_fwrd_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_dout_*err_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_padr_check
assertion -show -all
prove

