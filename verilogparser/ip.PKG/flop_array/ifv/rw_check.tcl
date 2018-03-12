clock -add wrclk -initial 0
clock -add rdclk -initial 0
force rst 1
force read* 0
force write* 0
run 8
#force rst 0
#run 2
init -load -current
init -show
define effort 1 hours
#define effort 1 minutes
define engine_profile on
define engine auto_dist
assertion -delete -all
constraint -delete -all
cutpoint -show -all
constraint -add -pin rst 0
#constraint -add -pin write_2 0
constraint -add ff_m_nrmbw_async2.assume*
constraint -show -all
assertion -add ff_m_nrmbw_async2.assert_rd_dout*_check*
##assertion -add ff_m_nrmbw_async2.flop_mem_wrap.width_loop\[\*\].flop_mem_cell_inst.assert_wr_sanity_check*
assertion -show -all
prove
