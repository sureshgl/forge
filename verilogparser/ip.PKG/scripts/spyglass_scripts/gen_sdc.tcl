################################################################################
# Copyright (c) 2010-2015 by Cisco Systems Inc.    All Rights Reserved.
################################################################################

exec hostname
exec date

define_design_lib WORK -path $env(PROJECT_ROOT)/spyglass/$env(block_name)/WORK

source -echo -verbose $env(SYNDIR)/setup/dc_setup.tcl

set ANALYZE_OPTION $env(ANALYZE_OPTION)
set DEFAULT_DEFINES $env(DEFAULT_DEFINES)
set SDC_OUT_FILE $env(PROJECT_ROOT)/spyglass/$env(block_name)/$env(block_name).sdc

if {$env(block_name)=="pciecpuif_wrap"} {
        set hdlin_vrlg_std 2001
        printvar *vrlg*
        set ANALYZE_OPTION verilog
}

source $env(SYNDIR)/$env(block_name)/inputs/all_rtl_files.vf

if {[info exists ts_def]} {
analyze -define "${DEFAULT_DEFINES} ${ts_def}" -f ${ANALYZE_OPTION} ${rtl_files}
} else {
analyze -define ${DEFAULT_DEFINES} -f ${ANALYZE_OPTION} ${rtl_files}
}

elaborate $env(block_name)

if { [file exists [which $DCRM_SDC_INPUT_FILE] ] }  {
   source -echo -verbose ${DCRM_SDC_INPUT_FILE}
   source -echo -verbose $env(SYNDIR)/scripts/default.sdc
} else {
   puts "READING default.sdc"
   source -echo -verbose $env(SYNDIR)/scripts/default.sdc
}

link

write_sdc -nosplit -version 1.8 ${SDC_OUT_FILE}

exec grep -v "CORE_MEM_RST"  ${SDC_OUT_FILE} | grep -v "CORE_BIST_RUN" | grep -v "CORE_BIST_RPR_MODE" | grep -v "BIST_DONE" > ${SDC_OUT_FILE}.temp
exec mv ${SDC_OUT_FILE}.temp ${SDC_OUT_FILE}

exec rm -rf $env(PROJECT_ROOT)/syn/$env(block_name)/reports.0
exec rm -rf $env(PROJECT_ROOT)/syn/$env(block_name)/results.0
exec rm -rf $env(PROJECT_ROOT)/spyglass/$env(block_name)/WORK

exec hostname
exec date
exit

