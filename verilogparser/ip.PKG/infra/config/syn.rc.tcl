puts "Hostname : [info hostname]"

if {![info exists DESIGN]} {
    puts "ERROR: DESIGN not defined"
    quit
}
if {![info exists CLOCK_PERIOD]} {
    puts "ERROR: CLOCK_PERIOD not defined"
    quit
}
if {![info exists HDL_FILES]} {
    puts "ERROR: HDL_FILES not defined"
    quit
}
if {![info exists HDL_SEARCH_PATH]} {
    puts "ERROR: HDL_SEARCH_PATH not defined"
    quit
}
if {![info exists LIB_SEARCH_PATH]} {
    puts "ERROR: LIB_SEARCH_PATH not defined"
    quit
}

set SYN_EFF medium
set MAP_EFF medium
set DATE [clock format [clock seconds] -format "%b%d-%T"] 
set _OUTPUTS_PATH outputs
set _REPORTS_PATH reports
set _LOG_PATH logs
set HDL_EXT {".h" "v"}
#set_attribute script_search_path $SCRIPT_SEARCH_PATH
set_attribute hdl_search_path $HDL_SEARCH_PATH
set_attribute lib_search_path $LIB_SEARCH_PATH
set_attribute hdl_language sv
set_attribute wireload_mode default
set_attribute information_level 3 /
set_attribute library $SYN_LIB_FILES /
# set_attribute hdl_error_on_blackbox true /
# TBD set_attribute lef_library

# ----------------------------------------------------------------------
read_hdl -sv $HDL_FILES
elaborate -libpath $HDL_SEARCH_PATH -libext $HDL_EXT $DESIGN 
puts "Runtime and Memory after 'read_hdl'"
timestat Elaboration
check_design -unresolved

# ----------------------------------------------------------------------
set sdc_version 1.8
#set_units -time ps -resistance kOhm -capacitance fF -voltage V -current mA
dc::set_units -time ps
dc::set_max_fanout 16 [dc::current_design]
dc::set_ideal_network -no_propagate  [dc::get_ports clk]
dc::create_clock [dc::get_ports clk]  -period $CLOCK_PERIOD
set ports_clock_root {clk}
dc::set_input_delay -clock clk .02  [dc::remove_from_collection [dc::all_inputs] $ports_clock_root]
dc::set_output_delay  -clock clk .02 [dc::all_outputs]

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

# ----------------------------------------------------------------------
synthesize -to_generic -eff $SYN_EFF
puts "Runtime & Memory after 'synthesize -to_generic'"
timestat GENERIC
report datapath > $_REPORTS_PATH/${DESIGN}_datapath_generic.rpt
generate_reports -outdir $_REPORTS_PATH -tag generic
summary_table -outdir $_REPORTS_PATH

# ----------------------------------------------------------------------
synthesize -to_mapped -eff $MAP_EFF -no_incr
puts "Runtime & Memory after 'synthesize -to_map -no_incr'"
timestat MAPPED
report datapath > $_REPORTS_PATH/${DESIGN}_datapath_map.rpt

# ----------------------------------------------------------------------
##Intermediate netlist for LEC verification..
write_hdl -lec > ${_OUTPUTS_PATH}/${DESIGN}_intermediate.v
write_do_lec -revised_design ${_OUTPUTS_PATH}/${DESIGN}_intermediate.v -logfile ${_LOG_PATH}/rtl2intermediate.lec.log > ${_OUTPUTS_PATH}/rtl2intermediate.lec.do

#ungroup -flatten des

# ----------------------------------------------------------------------
## Uncomment to remove assigns & insert tiehilo cells during Incremental synthesis
##set_attribute remove_assigns true /
##set_remove_assign_options -buffer_or_inverter <libcell> -design <design|subdesign> 
##set_attribute use_tiehilo_for_const <none|duplicate|unique> /
synthesize -to_mapped -eff $MAP_EFF -incr   
generate_reports -outdir $_REPORTS_PATH -tag incremental
summary_table -outdir $_REPORTS_PATH

puts "Runtime & Memory after incremental synthesis"
timestat INCREMENTAL

## Uncomment to enable spatial mode optimization
##synthesize -to_mapped -spatial

# ----------------------------------------------------------------------
write_design -basename ${_OUTPUTS_PATH}/${DESIGN}
## write_hdl  > ${_OUTPUTS_PATH}/${DESIGN}.v
## write_script > ${_OUTPUTS_PATH}/${DESIGN}.script
write_sdc > ${_OUTPUTS_PATH}/${DESIGN}.sdc

# ----------------------------------------------------------------------
write_do_lec -golden_design ${_OUTPUTS_PATH}/${DESIGN}_intermediate.v -revised_design ${_OUTPUTS_PATH}/${DESIGN}.v -logfile  ${_LOG_PATH}/intermediate2final.lec.log > ${_OUTPUTS_PATH}/intermediate2final.lec.do
##Uncomment if the RTL is to be compared with the final netlist..
##write_do_lec -revised_design ${_OUTPUTS_PATH}/${DESIGN}.v -logfile ${_LOG_PATH}/rtl2final.lec.log > ${_OUTPUTS_PATH}/rtl2final.lec.do
report qor

puts "Final Runtime & Memory."
timestat FINAL
puts "============================"
puts "Synthesis Finished ........."
puts "============================"

file copy [get_attr stdout_log /] ${_LOG_PATH}/.

quit
