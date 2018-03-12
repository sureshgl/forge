#### Template Script for RTL->Gate-Level Flow (generated from RC RC10.1.302 - v10.10-s322_1) 
#### Sample only, please update RTL and library paths before using this script

if {[file exists /proc/cpuinfo]} {
  sh grep "model name" /proc/cpuinfo
  sh grep "cpu MHz"    /proc/cpuinfo
}

puts "Hostname : [info hostname]"

##############################################################################
## Preset global variables and attributes
##############################################################################



set_attribute super_thread_rsh_command ssh
set_attribute hdl_language sv
set DESIGN ip_real
set SYN_EFF medium
set MAP_EFF medium
set DATE [clock format [clock seconds] -format "%b%d-%T"] 
set _OUTPUTS_PATH outputs_${DESIGN}
set _REPORTS_PATH reports_${DESIGN}
set _LOG_PATH logs_${DESIGN}
##set ET_WORKDIR <ET work directory>
set_attribute lib_search_path {. ./lib}
set_attribute script_search_path {. ./syn}
set_attribute hdl_search_path {. ../../../../ip/1r1w_rl2/rtl ../../../../ip/1r1w_rl2/gen/rtl}
##Uncomment and specify machine names to enable super-threading.
#set_attribute super_thread_servers {co-c-001 mach2 mach4 mach} /
set_attribute super_thread_servers {co-c-001}

##Default undriven/unconnected setting is 'none'.  
# set_attribute hdl_unconnected_input_port_value 0  
# set_attribute hdl_undriven_output_port_value 0 
# set_attribute hdl_undriven_signal_value        0  

set_attribute wireload_mode default
#set_attribute force_wireload none /designs/*

set_attribute information_level 3 /

###############################################################
## Library setup
###############################################################


set_attribute library  "<path>/<library><corner>.lib <path>/<library><corner>.lib"
## PLE
#set_attribute lef_library "<path>/<library>.lef"
#set_attribute cap_table_file 
####################################################################
## Load Design
####################################################################


read_hdl -sv \
../../../../ip/1r1w_rl2/gen/rtl/ip_real.v \
../../../../ip/1r1w_rl2/gen/rtl/mem_real.v \
../../../../ip/1r1w_rl2/gen/rtl/T1_WRAP_0.v \
../../../../ip/1r1w_rl2/gen/rtl/T2_WRAP_0.v \
../../../../ip/1r1w_rl2/rtl/design_1r1w_rl2.v \
../../../../ip/1r1w_rl2/rtl/core.v \
../../../../ip/1r1w_rl2/rtl/ecc_calc.v \
../../../../ip/1r1w_rl2/rtl/ecc_check.v \
../../../../ip/1r1w_rl2/rtl/mux.v \
../../../../ip/1r1w_rl2/rtl/np2_addr.v

elaborate $DESIGN -libpath {.  ../../../../ip/1r1w_rl2/rtl ../../../../ip/1r1w_rl2/gen/rtl } -libext { ".h" ".v" }
puts "Runtime & Memory after 'read_hdl'"
timestat Elaboration


check_design -unresolved

####################################################################
## Constraints Setup
####################################################################

read_sdc ./constraints.sdc
puts "The number of exceptions is [llength [find /designs/$DESIGN -exception *]]"


if {![file exists ${_OUTPUTS_PATH}]} {
  file mkdir ${_OUTPUTS_PATH}
  puts "Creating directory ${_OUTPUTS_PATH}"
}

if {![file exists ${_REPORTS_PATH}]} {
  file mkdir ${_REPORTS_PATH}
  puts "Creating directory ${_REPORTS_PATH}"
}

if {![file exists ${_LOG_PATH}]} {
  file mkdir ${_LOG_PATH}
  puts "Creating directory ${_LOG_PATH}"
}

#### To turn off sequential merging on the design 
#### uncomment & use the following attributes.
##set_attribute optimize_merge_flops false /
##set_attribute optimize_merge_latches false /
#### For a particular instance use attribute 'optimize_merge_seqs' to turn off sequential merging. 

####################################################################################################
## Synthesizing to generic 
####################################################################################################


synthesize -to_generic -eff $SYN_EFF
puts "Runtime & Memory after 'synthesize -to_generic'"
timestat GENERIC
report datapath > $_REPORTS_PATH/${DESIGN}_datapath_generic.rpt
generate_reports -outdir $_REPORTS_PATH -tag generic
summary_table -outdir $_REPORTS_PATH






####################################################################################################
## Synthesizing to gates
####################################################################################################

synthesize -to_mapped -eff $MAP_EFF -no_incr
puts "Runtime & Memory after 'synthesize -to_map -no_incr'"
timestat MAPPED
report datapath > $_REPORTS_PATH/${DESIGN}_datapath_map.rpt




##Intermediate netlist for LEC verification..
write_hdl -lec > ${_OUTPUTS_PATH}/${DESIGN}_intermediate.v
write_do_lec -revised_design ${_OUTPUTS_PATH}/${DESIGN}_intermediate.v -logfile ${_LOG_PATH}/rtl2intermediate.lec.log > ${_OUTPUTS_PATH}/rtl2intermediate.lec.do

## ungroup -threshold <value>



#######################################################################################################
## Incremental Synthesis
#######################################################################################################

## Uncomment to remove assigns & insert tiehilo cells during Incremental synthesis
##set_attribute remove_assigns true /
##set_remove_assign_options -buffer_or_inverter <libcell> -design <design|subdesign> 
##set_attribute use_tiehilo_for_const <none|duplicate|unique> /
synthesize -to_mapped -eff $MAP_EFF -incr   
generate_reports -outdir $_REPORTS_PATH -tag incremental
summary_table -outdir $_REPORTS_PATH

puts "Runtime & Memory after incremental synthesis"
timestat INCREMENTAL




###################################################
## Spatial mode optimization
###################################################

## Uncomment to enable spatial mode optimization
##synthesize -to_mapped -spatial



write_design -basename ${_OUTPUTS_PATH}/${DESIGN}_m
## write_hdl  > ${_OUTPUTS_PATH}/${DESIGN}_m.v
## write_script > ${_OUTPUTS_PATH}/${DESIGN}_m.script
write_sdc > ${_OUTPUTS_PATH}/${DESIGN}_m.sdc


#################################
### write_do_lec
#################################


write_do_lec -golden_design ${_OUTPUTS_PATH}/${DESIGN}_intermediate.v -revised_design ${_OUTPUTS_PATH}/${DESIGN}_m.v -logfile  ${_LOG_PATH}/intermediate2final.lec.log > ${_OUTPUTS_PATH}/intermediate2final.lec.do
##Uncomment if the RTL is to be compared with the final netlist..
##write_do_lec -revised_design ${_OUTPUTS_PATH}/${DESIGN}_m.v -logfile ${_LOG_PATH}/rtl2final.lec.log > ${_OUTPUTS_PATH}/rtl2final.lec.do
report qor

puts "Final Runtime & Memory."
timestat FINAL
puts "============================"
puts "Synthesis Finished ........."
puts "============================"

file copy [get_attr stdout_log /] ${_LOG_PATH}/.

##quit
