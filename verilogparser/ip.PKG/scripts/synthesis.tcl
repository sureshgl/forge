#### Template Script for RTL->Gate-Level Flow (generated from RC RC10.1.302 - v10.10-s322_1) 
#### Sample only, please update RTL and library paths before using this script



##############################################################################
## Dump CPU/hostname info               
##############################################################################

if {[file exists /proc/cpuinfo]} {
  sh grep "model name" /proc/cpuinfo
  sh grep "cpu MHz"    /proc/cpuinfo
}

puts "Hostname : [info hostname]"

set DATE [clock format [clock seconds] -format "%b%d-%T"] 

# Section I
##############################################################################
## Preset global variables and attributes
##############################################################################

set_attribute super_thread_rsh_command ssh
set_attribute hdl_language sv

# USER specify hdl-design top level file name below
# this is the 'memory-core name' in the .v file in the rtl dir
set DESIGN <top-cell-name>

set SYN_EFF medium
set MAP_EFF medium
set _OUTPUTS_PATH outputs_${DESIGN}
set _REPORTS_PATH reports_${DESIGN}
set _LOG_PATH logs_${DESIGN}

# create these directories for the above if they dont already exist 
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

# USER sets the appropriate path below
set_attribute lib_search_path {. ./lib}
set_attribute script_search_path {. ./syn}
# note that the encrypted hdl for the core-logic of the Algorithmic memory
# is kept in the src sub-dir of MemoGen installation
set_attribute hdl_search_path {. <install-dir-path>/src/rtl/<algo-name>/rtl <install-dir-path>/src/rtl/common/rtl }

##USER specify machine names to enable super-threading (if applicable).
set_attribute super_thread_servers {<host-name>}

##Default undriven/unconnected setting is 'none'.  
# set_attribute hdl_unconnected_input_port_value 0  
# set_attribute hdl_undriven_output_port_value 0 
# set_attribute hdl_undriven_signal_value        0  

set_attribute wireload_mode default
#set_attribute force_wireload none /designs/*

set_attribute information_level 3 /






# Section II
###############################################################
## Read in Library(s)
###############################################################

# provide various lib paths here e.g. std-cell lib, memory-cell lib etc.
set_attribute library  "<path>/<library1><corner>.lib <path>/<library2><corner>.lib"
## PLE
#set_attribute lef_library "<path>/<library>.lef"
#set_attribute cap_table_file 



####################################################################
## Load Design
#
# Note: The encrypted core-logic file of the generated cut
#       is kept under the 'ip' sub-directory of the installation dir.
####################################################################

# USER read in the top-level of the design; it is in the rtl dir
read_hdl -sv  <working-dir>/rtl/<memory-core name.v>

# 'algo-name' below implies the type of memory-core generated
# e.g. if it is a 1R1W core then algo-name is '1r1w'
elaborate $DESIGN -libpath {. <install-dir-path>/src/rtl/<algo-name>/rtl <install-dir-path>/src/rtl/common/rtl } \
-libext { ".h" ".v" }

puts "Runtime & Memory after 'read_hdl'"
timestat Elaboration


check_design -unresolved
puts "The number of exceptions is [llength [find /designs/$DESIGN -exception *]]"

####################################################################
## Synthesis Timing Constraints Setup
####################################################################

# Note USER has to generate the .sdc file based on his design constraints
# this file has design related constraints like create_clk, set_input/output delays
# set input drive strengths, set output loads, etc
read_sdc ./constraints.sdc

#### To turn off sequential merging on the design 
#### uncomment & use the following attributes.
##set_attribute optimize_merge_flops false /
##set_attribute optimize_merge_latches false /
#### For a particular instance use attribute 'optimize_merge_seqs' to turn off sequential merging. 





# Section III
####################################################################################################
## Step-1) Synthesizing to generic 
#
####################################################################################################


synthesize -to_generic -eff $SYN_EFF
puts "Runtime & Memory after 'synthesize -to_generic'"
timestat GENERIC
report datapath > $_REPORTS_PATH/${DESIGN}_datapath_generic.rpt
generate_reports -outdir $_REPORTS_PATH -tag generic
summary_table -outdir $_REPORTS_PATH

####################################################################################################
## Step-2) Synthesizing to gates 
#
# This is first pass of synthesis; use lower power libs(e.g. hvt libs) to keep the overall design power low
####################################################################################################

synthesize -to_mapped -eff $MAP_EFF -no_incr
puts "Runtime & Memory after 'synthesize -to_map -no_incr'"
timestat MAPPED
report datapath > $_REPORTS_PATH/${DESIGN}_datapath_map.rpt




##Intermediate gate-level netlist for LEC verification..
# (note: this netlist is considered 'intermediate' since we do another fine synthesis pass later)
write_hdl -lec > ${_OUTPUTS_PATH}/${DESIGN}_intermediate.v
# Generate script for lec (logic equi. check) process which happens later in Phy.Des procoess
write_do_lec -revised_design ${_OUTPUTS_PATH}/${DESIGN}_intermediate.v \
-logfile ${_LOG_PATH}/rtl2intermediate.lec.log > ${_OUTPUTS_PATH}/rtl2intermediate.lec.do

## remove hierarchies 
## ungroup -threshold <value>



#######################################################################################################
## Step-3) Incremental Synthesis - 
#                                    provide faster libs here if available to close timing
#######################################################################################################

# provide an additional faster lib path here e.g. lvt lib  (this is lib3 below, in addition to the orig lib1,lib2          
set_attribute library  "<path>/<library1><corner>.lib <path>/<library2><corner>.lib <path>/<library3><corner>.lib"

## Uncomment to remove assigns & insert tiehilo cells during Incremental synthesis
##set_attribute remove_assigns true /
##set_remove_assign_options -buffer_or_inverter <libcell> -design <design|subdesign> 
##set_attribute use_tiehilo_for_const <none|duplicate|unique> /
synthesize -to_mapped -eff $MAP_EFF -incr   
generate_reports -outdir $_REPORTS_PATH -tag incremental
summary_table -outdir $_REPORTS_PATH

puts "Runtime & Memory after incremental synthesis"
timestat INCREMENTAL


## Spatial mode optimization
#
#  Do this for layout-aware synthesis
###################################################

## Uncomment to enable spatial mode optimization
##synthesize -to_mapped -spatial






#Section IV
###################################################
## Generate output files      
#
###################################################
# Write out the final design files
write_design -basename ${_OUTPUTS_PATH}/${DESIGN}_m
write_hdl  > ${_OUTPUTS_PATH}/${DESIGN}_m.v
## write_script > ${_OUTPUTS_PATH}/${DESIGN}_m.script

# write out std.timing constraint file - this orig came from the user
write_sdc > ${_OUTPUTS_PATH}/${DESIGN}_m.sdc

# write the script file for the lec process
write_do_lec -golden_design ${_OUTPUTS_PATH}/${DESIGN}_intermediate.v -revised_design ${_OUTPUTS_PATH}/${DESIGN}_m.v \
-logfile  ${_LOG_PATH}/intermediate2final.lec.log > ${_OUTPUTS_PATH}/intermediate2final.lec.do

##Uncomment if the RTL is to be compared with the final netlist..
##write_do_lec -revised_design ${_OUTPUTS_PATH}/${DESIGN}_m.v \
-logfile ${_LOG_PATH}/rtl2final.lec.log > ${_OUTPUTS_PATH}/rtl2final.lec.do

# report quality of results
report qor

puts "Final Runtime & Memory."
timestat FINAL
puts "============================"
puts "Synthesis Finished ........."
puts "============================"

file copy [get_attr stdout_log /] ${_LOG_PATH}/.

##quit
