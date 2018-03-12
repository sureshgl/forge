clock -add clk -initial 0
force rst 1
#force refr 0
#force write_* 0
#force read_* 0
run 16
force rst 0
#while {[value ready] == "1'h0"} {
#  run 2
#}
init -load -current
#init -show
define effort 1 hours
define engine_profile on
define engine auto_dist
#define engine dagger sword
#define halo seq off
#define auto_dist_max 4
assertion -delete -all
constraint -delete -all
cutpoint -add $::env(IFV_HIER).mux.t1_writeA
cutpoint -add $::env(IFV_HIER).mux.t1_addrA
cutpoint -add $::env(IFV_HIER).mux.t1_dinA
cutpoint -add $::env(IFV_HIER).ip_top_sva.wrp*_serr
cutpoint -add $::env(IFV_HIER).ip_top_sva.wrp*_derr
cutpoint -add $::env(IFV_HIER_2).rd_dout
cutpoint -add $::env(IFV_HIER_2).rd_fwrd
cutpoint -add $::env(IFV_HIER_2).rd_serr
cutpoint -add $::env(IFV_HIER_2).rd_derr
cutpoint -add $::env(IFV_HIER_2).ip_top_sva.mem_serr
cutpoint -add $::env(IFV_HIER_2).ip_top_sva.mem_derr
cutpoint -add $::env(IFV_HIER_2).ip_top_sva.xmem_serr
cutpoint -add $::env(IFV_HIER_2).ip_top_sva.xmem_derr
cutpoint -add $::env(IFV_HIER_3).rd_dout
cutpoint -add $::env(IFV_HIER_3).rd_fwrd
cutpoint -add $::env(IFV_HIER_3).rd_serr
cutpoint -add $::env(IFV_HIER_3).rd_derr
cutpoint -add $::env(IFV_HIER_3).ip_top_sva.mem_serr
cutpoint -add $::env(IFV_HIER_3).ip_top_sva.mem_derr
cutpoint -show -all
constraint -add -pin rst 0
constraint -add des.algo_top.assume_select*
if {$::env(IFV_REFR) == 1} {
#  constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_refr_check
  constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_refr_noacc_check
}
constraint -add des.algo_top.*.assume_wr_*err_check
constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_t1_wrA_range_check
constraint -add $::env(IFV_HIER).ip_top_sva_2.*.assert_rw_1p_check
constraint -add $::env(IFV_HIER_2).ip_top_sva.*.assert_fwrd*_check
constraint -add $::env(IFV_HIER_2).ip_top_sva.*.assert_dout*_check
constraint -add $::env(IFV_HIER_2).ip_top_sva.*.assert_derr*_check
constraint -add $::env(IFV_HIER_3).ip_top_sva.assert_dout*_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.assert_pdout1_check
assertion -add $::env(IFV_HIER).ip_top_sva.assert_pdout2_check
assertion -add $::env(IFV_HIER).ip_top_sva.assert_sdout1_check
assertion -add $::env(IFV_HIER).ip_top_sva.assert_sdout2_check
assertion -add $::env(IFV_HIER).ip_top_sva.assert_cdout1_check
assertion -add $::env(IFV_HIER).ip_top_sva.assert_cdout2_check
assertion -show -all
prove
