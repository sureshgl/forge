####  Script for RTL-> Gate-Level Synthesis 

if {[file exists /proc/cpuinfo]} {
  sh grep "model name" /proc/cpuinfo
  sh grep "cpu MHz"    /proc/cpuinfo
}

puts "Hostname : [info hostname]"

proc P_timestamp {str} {
  set c [clock format [clock seconds]];
  set h [sh hostname];
  set u [sh whoami];
  echo "$str: #TIMESTAMP: " $c " " $h " " $u;
} ; # P_timestamp

##############################################################################
## Preset global variables and attributes
##############################################################################

set DESIGN_NAME [getenv TOP_MODULE]
set FREQ [getenv FREQ]
set DATE [clock format [clock seconds] -format "%b%d-%T"] 
set _OUTPUTS_PATH outputs
set _REPORTS_PATH reports
set _LOG_PATH logs

set hdlin_while_loop_iterations 32768
#set_app_var compile_delete_unloaded_sequential_cells true
#set_app_var compile_seqmap_propagate_constants true
set_app_var alib_library_analysis_path .
set hdlin_check_no_latch true

set compile_seqmap_propagate_constants          false
set compile_seqmap_propagate_high_effort        false
# don't delete unloaded flops
set compile_delete_unloaded_sequential_cells    false
# preserve all sequentials
set hdlin_preserve_sequential                   true


###############################################################
## Library setup
###############################################################

set_app_var target_library [getenv ATTR_LIB]
set_app_var synthetic_library dw_foundation.sldb
set_app_var link_library "* $synthetic_library $target_library "

####################################################################
## Load Design
####################################################################

set RTL_SOURCE_FILES	[getenv READ_HDL_ARGS]

set REPORTS_DIR "reports"
set RESULTS_DIR "outputs"

file mkdir ${REPORTS_DIR}
file mkdir ${RESULTS_DIR}

set_svf ${RESULTS_DIR}/${DESIGN_NAME}.mapped.svf

P_timestamp "Start of synthesis: "
define_design_lib WORK -path ./WORK
analyze -format sverilog ${RTL_SOURCE_FILES} 
P_timestamp "End of  analyze: "
elaborate ${DESIGN_NAME}
P_timestamp "End of  elaborate: "
check_design > ${REPORTS_DIR}/${DESIGN_NAME}.check_design.rpt
P_timestamp "End of check_design: "

set status [link]

if { [is_true $status ] } {
  echo "Linking succeeded."
}

####################################################################
## Constraints Setup
####################################################################

set_fix_multiple_port_nets -all -buffer_constants

set timing_margin 0
#0.300
set clkp [expr "(1000.0 / ${FREQ})-${timing_margin}"]
set clkpb2 [expr "$clkp/2"]
set clk2 ${clkpb2}

#create_clock -name clk  -period ${clkp} -wavefor {0 0.5} clk
create_clock -name clk  -period 0.3 clk
#create_clock -name clk  -period ${clkp}  clk
set_ideal_network -no_propagate clk
set_ideal_network -no_propagate rst
set_max_fanout 30 [current_design]

#set ports_clock_rst_root {clk, rst}
#set_input_delay -clock clk .1  [remove_from_collection [all_inputs] $ports_clock_rst_root]
set_input_delay -clock clk 0  [all_inputs]
set_output_delay  -clock clk  0 [all_outputs]
#set_input_delay .1  [remove_from_collection [all_inputs] $ports_clock_rst_root]
#set_output_delay  .1 [all_outputs]
#set_false_path -to [get_ports t1_bist*]
set_case_analysis 0 rst

set auto_wire_load_selection true
set_wire_load_mode top
set hdlin_check_no_latch true

set compile_ultra_ungroup_dw false
#set compile_disable_hierarchical_inverter_opt true
#set_verification_priority -all -high

#compile_ultra -no_seq_output_inversion -no_autoungroup -no_boundary_optimization -exact_map
compile_ultra
P_timestamp "End of compile_ultra: "

report_timing

######set bus_naming_style {%s_%dA}

######suppress_message "NMA-8"
suppress_message "NMA-9"
suppress_message "NMA-16"
suppress_message "NMA-14"
suppress_message "UCN-4"

set change_names_dont_change_bus_members true
define_name_rules scip -allowed          {a-z A-Z 0-9 _}   -type cell
define_name_rules scip -allowed          {a-z A-Z 0-9 _}   -type net
define_name_rules scip -allowed          {a-z A-Z 0-9 _ []} -type port

define_name_rules scip -first_restricted {0-9 _}
#define_name_rules scip -last_restricted  {_}
change_names -hierarchy -rules scip
define_name_rules scip_last -equal_ports_nets -check_bus_indexing

change_names -verbose -hierarchy -rules scip_last

write -f verilog -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}.hier.vg
write -f verilog -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}.flat.vg
write_sdc -version 1.8 -nosplit ${RESULTS_DIR}/${DESIGN_NAME}.flat.sdc

#################################
### Report Timing
#################################

check_design -multiple_design > ${REPORTS_DIR}/${DESIGN_NAME}.check_design-multi_final.rpt
report_qor > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.qor.rpt
report_timing -transition_time -nets -attributes -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.timing.rpt
report_timing -nworst 1 -max_paths 10000 -transition_time -nets -attributes -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.timing_all.rpt
report_const -all_vio -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.timing.all_vio.rpt
report_const -all_vio -verbose -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.timing.all_vio_verbose.rpt

report_area -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.area.rpt
report_area -nosplit -hier > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.area.hier.rpt

write -f verilog -hierarchy -output  ${RESULTS_DIR}/${DESIGN_NAME}.flat.vg
write -f ddc     -hierarchy -output  ${RESULTS_DIR}/${DESIGN_NAME}.ddc
write_sdc -version 1.8      -nosplit ${RESULTS_DIR}/${DESIGN_NAME}.flat.sdc

#################################
### Done!!!
#################################

puts "============================"
puts "Synthesis Finished ........."
puts "============================"

P_timestamp "Synthesis done: "
quit
