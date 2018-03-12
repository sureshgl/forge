# Script file for post-layout Static-Timing Analysis


###############################################################################
#-------------------------------------------------------
#   PART 1 variable setting
#-------------------------------------------------------
source $vars(script_root)/ETC/utils.tcl
source $vars(script_root)/ETC/ETS/utils.tcl

# print running system info in log, can be commented out if not wanted
::FF::system_info

# For EDI FF users, who already have a setup.tcl. They can create 
# ets_config.tcl as a complement setup file 
if {[file exists ets_config.tcl]} {   source ets_config.tcl }

# Source plug in tcls for other initial settings #
::FF_ETS::source_plug ets_pre_init_tcl

if {![info exists vars(rpt_dir)]} { set vars(rpt_dir) "rpt" }
if {![info exists vars(dbs_dir)]} { set vars(dbs_dir) "dbs" }

if {![file exists ./$vars(rpt_dir)]} { exec mkdir $vars(rpt_dir) }
if {![file exists ./$vars(dbs_dir)]} { exec mkdir $vars(dbs_dir) }

if {![info exists vars(si_analysis)]}   { set vars(si_analysis)   "true"  } 
if {![info exists vars(physical_data)]} { set vars(physical_data) "false" }
if {![info exists vars(edi_db_name)]}   { set vars(edi_db_name) "DBS/signoff.enc" }

if {![info exists vars(compress_sta_rpt)]} { set vars(compress_sta_rpt) "false" }
if {$vars(compress_sta_rpt)}               { set gz ".gz" } else { set gz "" }

if  {[info exists vars(mt_cpu)]} { set_multi_cpu_usage -localCpu $vars(mt_cpu) } 

#-------------------------------------------------------
#   PART 2 ILM Setting
#-------------------------------------------------------
if {[info exists vars(read_ilm,cell_list)] && [info exists vars(read_ilm,dir_list)]} {
      set i 0
       foreach cell_name $vars(read_ilm,cell_list) {
            specify_ilm -cell $cell_name -dir [ lindex $vars(read_ilm,dir_list) $i ]
            incr i
      }
}


#-------------------------------------------------------
#   PART 3 Design Import
#-------------------------------------------------------


if {[info exists vars(load_edi_db)] && $vars(load_edi_db)} {

    set EDI_DB true
    if $vars(physical_data) {              
       read_design -physical_data $vars(edi_db_name)
    } else {
       read_design $vars(edi_db_name)
    }
    set vars(design) [ dbget top.name ]

    if { $rda_Input(ui_timelib,min) != ""} {
       set MIN_MAX_FLOW true
    } else {
       set MIN_MAX_FLOW false
    }

} else {
   set EDI_DB false
   if {[info exists vars(libs,timing)]} {
       read_lib  $vars(libs,timing)
       set MIN_MAX_FLOW false 
   }
   if {$vars(si_analysis)} {
      if {[info exists vars(libs,si)]} {
          read_lib  -cdb $vars(libs,si)  
      }
   }

   if {$vars(physical_data)} { read_lib -lef $vars(lef_files) }
   read_verilog $vars(netlist)
   set_top_module  $vars(design)

   if {$vars(physical_data)} { read_def $vars(def_files) }
   if {[info exists vars(signoff_sdc)]}   { read_sdc $vars(signoff_sdc) }
}



#-------------------------------------------------------
#   PART 4 DC source setting (required by SI analysis)
#-------------------------------------------------------

if {$vars(si_analysis)} {
   set_dc_sources -global $vars(dc_source,global)
   if {![info exists vars(dc_source,power_vol)]} {
       set_dc_sources  $vars(dc_source,power_name) 
   } else {
      set i 0
       foreach power_name $vars(dc_source,power_name) {
            set_dc_sources $power_name -power -voltage [ lindex $vars(dc_source,power_vol) $i ]
            incr i
      }
   }
   set_dc_sources  $vars(dc_source,ground_name) -ground
}


#-------------------------------------------------------
#   PART 5 Loading spef files
#-------------------------------------------------------

read_spef $vars(spef_file)

#-------------------------------------------------------
#   PART 6 Read Ilm
#-------------------------------------------------------
if {[info exists vars(read_ilm,cell_list)] && [info exists vars(read_ilm,dir_list)]} {
        if {$vars(si_analysis)} {
                read_ilm
        } else {
                read_ilm -noSI
        }
}


#-------------------------------------------------------
#   PART 7 Other files loaded in. e.g. SDF,IR-Drop
#-------------------------------------------------------

if {[info exists vars(sdf_file,full)]} {
   read_sdf $vars(sdf_file,full)
}

if {[info exists vars(sdf_file,incr)]} {
   read_sdf $vars(sdf_file,incr)
}

if {[info exists vars(ir_drop)]} {
   read_instance_voltage -ir_drop  $vars(ir_drop)
}



# Source plug in tcls for other settings after load in design #
::FF_ETS::source_plug ets_post_init_tcl

#-------------------------------------------------------
#   PART 8 Operating Condition Setting
#-------------------------------------------------------

if {!$MIN_MAX_FLOW} {
   
  if {[info exists vars(op_cond,name)]} {
       if {[info exists vars(op_cond,lib)]} {
          set_op_cond $vars(op_cond,name) -library $vars(op_cond,lib)
        } else {
          set_op_cond $vars(op_cond,name)
        }
   } else {
       puts "WARN: Operating Condition not defined flow will continue"
   }
   
} else {

  if {[info exists vars(op_cond_max,name)]} {
       if {[info exists vars(op_cond_max,lib)]} {
           set_op_cond -max $vars(op_cond_max,name) -maxLibrary $vars(op_cond_max,lib)
       } else {
           set_op_cond -max $vars(op_cond_max,name)
       }
  } else {
       puts "WARN: Max Operating Condition not defined flow will continue"      
  }

 if {[info exists vars(op_cond_min,name)]} {
       if {[info exists vars(op_cond_min,lib)]} {
            set_op_cond -min $vars(op_cond_min,name) -minLibrary $vars(op_cond_min,lib) 
       } else {
            set_op_cond -min $vars(op_cond_min,name)
       }
  } else {
       puts "WARN: Min Operating Condition not defined flow will continue"
  }

}

#-------------------------------------------------------
#   PART 9 Default STA globa Setting
#-------------------------------------------------------

# STA globals 
set_global report_timing_format {instance arc cell load slew delay incr_delay arrival}
set_global timing_case_analysis_for_icg_propagation true
set_global timing_path_groups_for_clocks true
set_global timing_report_unconstrained_paths true
set_global timing_cppr_threshold_ps 10
set_global report_precision 4

# Delay Calculation globals
# These globals apply when ECSM libraries are available
set_delay_cal_mode -considerMillerEffect true
#-------------------------------------------------------
#   PART 10 User Time Margin Setting
#-------------------------------------------------------

  if  {[info exists vars(derate,cell_data_late)]}   { set_timing_derate -late  -data  -cell_delay $vars(derate,cell_data_late)   }
  if  {[info exists vars(derate,cell_data_early)]}  { set_timing_derate -early -data  -cell_delay $vars(derate,cell_data_early)  }
  if  {[info exists vars(derate,cell_clock_late)]}  { set_timing_derate -late  -clock -cell_delay $vars(derate,cell_clock_late)  }
  if  {[info exists vars(derate,cell_clock_early)]} { set_timing_derate -early -clock -cell_delay $vars(derate,cell_clock_early) }

  if  {[info exists vars(derate,net_data_late)]}    { set_timing_derate -late  -data  -net_delay $vars(derate,net_data_late)    } 
  if  {[info exists vars(derate,net_data_early)]}   { set_timing_derate -early -data  -net_delay $vars(derate,net_data_early)   }
  if  {[info exists vars(derate,net_clock_late)]}   { set_timing_derate -late  -clock -net_delay $vars(derate,net_clock_late)   }
  if  {[info exists vars(derate,net_clock_early)]}  { set_timing_derate -early -clock -net_delay $vars(derate,net_clock_early)  }

  report_timing_derate

if {[info exists vars(clock_uncertainty,setup)]} {
  Puts "set_clock_uncertainty  $vars(clock_uncertainty,setup) -setup [all_clocks]"
  set_clock_uncertainty  $vars(clock_uncertainty,setup) -setup [all_clocks]
}

if {[info exists vars(clock_uncertainty,hold)]} {
  Puts "set_clock_uncertainty  $vars(clock_uncertainty,hold) -hold [all_clocks]"
  set_clock_uncertainty  $vars(clock_uncertainty,hold) -hold [all_clocks]
}

#-------------------------------------------------------
#   PART 11 Report Timing (before SI anlaysis)
#-------------------------------------------------------
# Enforce the propagated clocks incase not included in loaded SDC file 
set_propagated_clock [all_clocks]

# Analysis Mode setting
if  {![info exists vars(analysis_mode)]}  { set vars(analysis_mode) "onChipVariation" }
if  {![info exists vars(cppr)]}           { set vars(cppr) "both" }

set_analysis_mode -analysisType $vars(analysis_mode) -cppr $vars(cppr) -sequentialConstProp true -timingSelfLoopsNoSkew  true

# Source plug in tcl for other STA settings before update timing #
::FF_ETS::source_plug ets_pre_sta_tcl

report_timing 

#-------------------------------------------------------
#   PART 12 Write Ilm
#-------------------------------------------------------
if {[info exists vars(write_ilm_dir)]} {
    write_ilm -dir $vars(write_ilm_dir)
}

#-------------------------------------------------------
#   PART 13 Perform SI Analysis 
#-------------------------------------------------------
if {$vars(si_analysis)} {

 if {![info exists vars(si_rpt_prefix)]} { set vars(si_rpt_prefix) ets }
 if {![info exists vars(vir_attacker,mode)]} { set vars(vir_attacker,mode) current }
 if {![info exists vars(vir_attacker,gtol)]} { set vars(vir_attacker,gtol) 0.02 }
 
 set_noise_parm filename_prefix $vars(si_rpt_prefix)
 
 # advanced si settings
 if  {[info exists vars(vir_attacker,mode)]}         { set_virtual_attacker -mode        $vars(vir_attacker,mode) }
 if  {[info exists vars(vir_attacker,factor)]}       { set_virtual_attacker -factor      $vars(vir_attacker,factor) }
 if  {[info exists vars(vir_attacker,gtol)]}         { set_virtual_attacker -gtol        $vars(vir_attacker,gtol) }
 if  {[info exists vars(vir_attacker,switch_prob)]}  { set_virtual_attacker -switch_prob $vars(vir_attacker,switch_prob) }

 if  {[info exists vars(glitch_check,latch_limit)]}  { set_glitch_check -latch_limit  $vars(glitch_check,latch_limit)  }
 if  {[info exists vars(glitch_check,clock_limit)]}  { set_glitch_check -clock_limit  $vars(glitch_check,clock_limit)  }
 if  {[info exists vars(glitch_check,data_limit)]}   { set_glitch_check -data_limit   $vars(glitch_check,data_limit)   }
 if  {[info exists vars(glitch_check,dc_tolerance)]} { set_glitch_check -dc_tolerance $vars(glitch_check,dc_tolerance) }

 set_noise_run_mode -process $vars(process) -mode signoff
 if {[info exists vars(noise,delta_absolute)]} { set_noise_thresh -delta_absolute $vars(noise,delta_absolute) } 
 if {[info exists vars(twf,conv_iter)]}        { set_tw_convergence -first_infinite_windows -iterations $vars(twf,conv_iter) }
 if  {[info exists vars(twf_file)]}            { read_twf $vars(twf_file) }

 # advanced si settings
 if  {[info exists vars(noise,delay_peak)]}  { set_noise_thresh -delay_peak  $vars(noise,delay_peak) }
 if  {[info exists vars(noise,glitch_peak)]} { set_noise_thresh -glitch_peak $vars(noise,glitch_peak) }

 # source plug in tcl for other SI analysis settings #
 ::FF_ETS::source_plug ets_pre_si_tcl

 analyze_noise -delay
}

#-------------------------------------------------------
#   PART 14 Gernerate SI reports
#-------------------------------------------------------
if {$vars(si_analysis)} {

 # system default reports
 report_noise -gzip -sort_by noise -failure -txtfile ./$vars(rpt_dir)/$vars(si_rpt_prefix)_noise_slack_failure.text.gz
 report_noise -gzip -delay max -threshold 0 -txtfile ./$vars(rpt_dir)/$vars(si_rpt_prefix)_max_abs.text.gz
 report_noise -gzip -delay min -threshold 0 -txtfile ./$vars(rpt_dir)/$vars(si_rpt_prefix)_min_abs.text.gz
 report_double_clocking -gzip -file ./$vars(rpt_dir)/$vars(si_rpt_prefix)_clock.text.gz
 write_noise_eco -filename_prefix $vars(rpt_dir)/$vars(si_rpt_prefix) 
 write_sdf -gzip -si ./$vars(rpt_dir)/$vars(si_rpt_prefix)_incr.sdf.gz

 # Source plug in tcl to generate other cusotmer defined noise reports #
 ::FF_ETS::source_plug ets_si_rpt_tcl
 
}

#-------------------------------------------------------
#   PART 15 Generate STA reports
#-------------------------------------------------------
# Analysis Coverage report
report_analysis_coverage              > ./$vars(rpt_dir)/report_analysis_coverage.rpt${gz}
check_timing -type endpoints -verbose > ./$vars(rpt_dir)/uncons_endpoint.rpt${gz}
check_timing -type inputs -verbose    > ./$vars(rpt_dir)/uncons_inputs.rpt${gz}
check_timing -type clocks -verbose    > ./$vars(rpt_dir)/uncons_clocks.rpt${gz}

# Constraint summary report
report_constraint -all_violators -late                               > ./$vars(rpt_dir)/constraint_maxdly.rpt${gz}  
report_constraint -all_violators -early                              > ./$vars(rpt_dir)/constraint_mindly.rpt${gz}
report_constraint -all_violators -drv_violation_type max_transition  > ./$vars(rpt_dir)/constraint_maxtran.rpt${gz} 
report_constraint -all_violators -drv_violation_type max_capacitance > ./$vars(rpt_dir)/constraint_maxcap.rpt${gz} 
report_constraint -all_violators -drv_violation_type max_fanout      > ./$vars(rpt_dir)/constraint_maxfanout.rpt${gz} 

# Detailed paths report
report_timing -max_points 1000 -late -path_type full_clock -net > ./$vars(rpt_dir)/setup.rpt${gz}
report_timing -max_points 1000 -early -path_type full_clock -net  > ./$vars(rpt_dir)/hold.rpt${gz}

# Source plug in tcl to generate other cusotmer defined STA reports
::FF_ETS::source_plug ets_sta_rpt_tcl


#-------------------------------------------------------
#   PART 16 Save Session
#-------------------------------------------------------
if {[info exists vars(read_ilm,cell_list)]} { free_noise_analysis } 

if {![info exists vars(saved_db_name)]} { set vars(saved_db_name) $vars(design).enc }
save_design ./$vars(dbs_dir)/$vars(saved_db_name) -overwrite

#-------------------------------------------------------
#   PART 17 Write sdf for post layout simulation
#-------------------------------------------------------
write_sdf -interconn noport -splitrecrem -splitsetuphold ./$vars(rpt_dir)/$vars(design).3.0.sdf.gz

exit
