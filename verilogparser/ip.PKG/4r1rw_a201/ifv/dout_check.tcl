clock -add clk -initial 0
force rst 1
#force refr 0
#force write_* 0
#force read_* 0
run 16
force rst 0
while {[value ready] == "1'h0"} {
  run 2
}
init -load -current
init -show
define effort 4 hours
define engine_profile on
#define engine saber dagger bow3 sword3 hammer
define engine auto_dist
#define engine dagger sword
#define halo seq off
#define auto_dist_max 4
assertion -delete -all
constraint -delete -all
cutpoint -add $::env(IFV_HIER).ip_top_sva.mem_serr
cutpoint -add $::env(IFV_HIER).ip_top_sva.mem_derr
cutpoint -add $::env(IFV_HIER).ip_top_sva.xmem_serr
cutpoint -add $::env(IFV_HIER).ip_top_sva.xmem_derr
#cutpoint -add $::env(IFV_HIER).t1_doutB
#cutpoint -add $::env(IFV_HIER).t1_fwrdB
#cutpoint -add $::env(IFV_HIER).t1_serrB
#cutpoint -add $::env(IFV_HIER).t1_derrB
#cutpoint -add $::env(IFV_HIER).t2_doutB
#cutpoint -add $::env(IFV_HIER).t2_fwrdB
#cutpoint -add $::env(IFV_HIER).t2_serrB
#cutpoint -add $::env(IFV_HIER).t2_derrB
cutpoint -add $::env(IFV_HIER).core.xor_fwd_data
cutpoint -add $::env(IFV_HIER).core.xor_data
cutpoint -show -all
constraint -add -pin rst 0
constraint -add -pin ena_rdacc 1
constraint -add $::env(IFV_HIER).assume_select*
constraint -add des.algo_top.assume_1r1rw*
constraint -add des.algo_top.assume_ena_rdacc*
constraint -add des.algo_top.vrpt_int_loop.*.assume_1r1rw_check
constraint -add $::env(IFV_HIER).ip_top_sva_2.assert_rd_wr_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assume_mem_*err_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assume_xmem_*err_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_pdout_check
constraint -add $::env(IFV_HIER).ip_top_sva.*.assert_xor_more_check
constraint -add $::env(IFV_HIER).ip_top_sva.assert_fakemem_check
constraint -show -all
assertion -add $::env(IFV_HIER).ip_top_sva.*.assert_vld_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.*.assert_fwrd*_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.*.assert_dout*_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.*.assert_derr*_check
assertion -add $::env(IFV_HIER).ip_top_sva.*.*.assert_padr*_check
assertion -show -all
prove
