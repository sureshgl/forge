#!/bin/tcsh
setenv TOP_MODULE "priority_encode_log"
setenv FREQ 2000
setenv ATTR_LIB "/auto/memoir-tools/libraries/avago/16nm/DK_PN75_2013_11_05.to_Memoir/std_cell_libs_digital/timing_power_analysis/av16_svt16_slow_slowod_0.db"
setenv VT_SETTINGS ""
setenv READ_HDL_ARGS  "priority_encode_flopped.v ../rtl/priority_encode_dsbu.v ../rtl/priority_encode_simple.v ../rtl/priority_encode_log.v"
bsub -I -q bigmem "dc_shell-t -64bit	 -wait 100 -f rgr_dc_syn_script.tcl"
