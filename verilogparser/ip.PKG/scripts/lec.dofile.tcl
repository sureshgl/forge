//  This is the an RTL to gates main do file It includes the setup 
//  steps, reading the verilog, elaborating and comparing, and 
//  finally the report generation. 
// 
set log file log/partition_rtl2gates_fv.log -replace 
add renaming rule r1   \/U\$1 ""  -revised 
add renaming rule g1   \/U\$1 ""  -golden 
add renaming rule r2   \[%d\] _@1 -revised 
add renaming rule g2   \[%d\] _@1 -golden 
add renaming rule g3   \/\    _   -golden 
add renaming rule r3   \/\    _   -revised 
// Set mapping methods. 
// -unreach = map those key points that do not affect (reach) an output. 
set mapping method -unreach  
// -name first = map matching names then work on the remaining key points. 
set mapping method -name first 
// By default the compare effort is low...
set compare effort medium 
//----------------------------------------------------------------------------- 
// Renaming Rules 
//  These rules help the tool translate the RTL signal and register names 
//  into the gate-level name. Synthesis changes the names of registers and 
//  and nets and this helps the tool match key points based on names. 
read library         -both -sensitive -verilog -define functional \ 
        verilog_primitives.v 
//----------------------------------------------------------------------------- 
// Reading the Golden Design 
// 
 subfub_3.v \ 
 subfub_4.v \ 
 subfub_5.v 
//----------------------------------------------------------------------------- 
// Elaborate the Golden Design 
// 
//  We need to do this before we read the revised design. By not elaborating 
//  when we read in the design we can do multiple reads. 
// 
elaborate design -golden 
//----------------------------------------------------------------------------- 
// Reading the Revised Design 
// 
read design -verilog -revised -sensitive -noelaborate \ 
 partition_gates.v  
//----------------------------------------------------------------------------- 
// Elaborate the Revised Design 
// 
elaborate design -revised 
// Constraints on the Two Designs 
// 
//on intial FV runs, do not use this line.  Only set to 0 after identifying all undriven signals in golden 
set undriven signal 0  
// -phase = map key points with an inverted phase. 
set mapping method -phase 
// Set flattening methods. 
// do not convert a DFF to a D-Latch if the clock port is zero. 
set flatten model -NODFF_TO_DLAT_FEEDBACK 
// Compare the Two Designs 
// Flat compare  (slower with fewer differences) 
set system mode lec -nomap 
//read mapped points partition.map 
map key points 
add compare points -all 
compare 
//----------------------------------------------------------------------------- 
// Report Generation 
// 
report compare data -noneq      > reports/partition_rtl2gates_noneq_points.rpt 
report unmapped points -revised > reports/partition_rtl2gates_revised_unmapped_points.rpt 
report unmapped points -golden  > reports/partition_rtl2gates_golden_unmapped_points.rpt 
report unmapped points -summary > reports/partition_rtl2gates_mapping_summary.rpt
