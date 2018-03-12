################################################################################
## Copyright (c) 2012-2014 by Cisco Systems, Inc. All rights reserved.
# Common Spyglass project file setup
#
# this file contains common project wide Spyglass settings
# the common setup enable easier deployment of common settings
#
# 02/02/12 - Updated no save policy for various goals to prevent license hogging
#
################################################################################
puts "########################################"
puts "sourcing scripts/common_project_setup.tcl"
puts "########################################"
puts ""

# common project wide waivers applied to all blocks
#read_file -type waiver     scripts/tigershark_common_waivers.swl

#set_option ignorewaivers yes

set_option enable_save_restore no

# specify common VHDL/Mixed language options
set_option sort
set_option enable_precompile_vlog

# specify that Spyglass design constraints (sgdc) file should be strictly checked
set_option strict_sgdc_check no

# SDC to SGDC conversion
#set_option overloadrules SGDC_cdc_false_path01+severity=Warning
#set_option overloadrules SGDC_cdc_false_path02+severity=Warning
#set_option overloadrules SDC_02+severity=Warning
#set_option overloadrules SDC_36+severity=Warning
set_option overloadrules checkSGDC_06+severity=Warning
set_option overloadrules SDC_Sanity_Rule+severity=Warning
set_option overloadrules SGDC_cdc_false_path01+severity=Warning
set_option overloadrules SGDC_cdc_false_path02+severity=Warning
set_option overloadrules SGDC_cdc_false_path03+severity=Warning
set_option overloadrules SGDC_cdc_false_path04+severity=Warning
set_option overloadrules SGDC_input01+severity=Warning
set_option overloadrules SGDC_output01+severity=Warning
set_option overloadrules checkSGDC_06+severity=Warning

#if {"$env(SGDCLIST_EXISTS)" == 1  ||  "$env(SGDCFILE)" == 1} {
if {"$env(SDCFILE)" == 1} {
set_option sdc2sgdcfile ${TOP}/${TOP}_sdc2sgdc.sgdc
set_option extractDomainInfo yes
set_option translateIODelay yes
set_option mapVirtualClkByName yes
set_option mapSuffixList virtual
#set_goal_option mapSuffixList virtual
#set_goal_option mapVirtualClkByName yes
set_option sdc2sgdc yes 
}
# location where spyglass will run
set_option projectwdir $env(RESULTS_DIR)

# memory threshold - max number of bits to synthesize
set_option mthresh 9126
# Added for RBM
set_option define_cell_sim_depth 14
# compile time arguments
set_option language_mode mixed

# Designware setup
set_option dw yes
#set_option lib SPY_DW_WORK $env(PROJECT_ROOT)/f32/f32_top/spyglass/SPY_DW_WORK
set_option lib SPY_DW_WORK $env(PROJECT_ROOT)/SPY_DW_WORK

## Parameters
#set_parameter flopInFaninCount 500

# specify Spyglass reports to generate
# the regression reports will link to these reports if they exist
create_report waiver
create_report moresimple_sevclass
#create_report drag
create_report summary

if {"$env(GOAL)" == "subchip_cdc_setup" | "$env(GOAL)" == "subchip_cdc_struct" | "$env(GOAL)" == "subchip_cdc_functional" | "$env(GOAL)" == "core_cdc_setup" | "$env(GOAL)" == "core_cdc_validate" | "$env(GOAL)" == "core_cdc_struct" | "$env(GOAL)" == "subchip_cdc_abstract" | "$env(GOAL)" == "subchip_cdc_structall"} {
	create_report CDC-report
	create_report CKSGDCInfo
        create_report Ac_sync_qualifier
        create_report Ac_sync_group_detail
        create_report Clock-Reset-Detail
}

if {"$env(GOAL)" == "subchip_cdc_setup" | "$env(GOAL)" == "subchip_cdc_struct" | "$env(GOAL)" == "subchip_cdc_functional" | \
                    "$env(GOAL)" == "core_cdc_setup" | "$env(GOAL)" == "core_cdc_validate" | "$env(GOAL)" == "core_cdc_struct" | \
                    "$env(GOAL)" == "lint" | "$env(GOAL)" == "lintall" | "$env(GOAL)" == "audit" | \
                    "$env(GOAL)" == "erc" | "$env(GOAL)" == "vendor_erc" | "$env(GOAL)" == "dashboard" | \
                    "$env(GOAL)" == "datasheet" | "$env(GOAL)" == "designread" | "$env(GOAL)" == "subchip_cdc_abstract" | "$env(GOAL)" == "subchip_cdc_structall"} {
    puts "INFO:: setting nosavepolicy options"
    set_option nosavepolicies {constraints,dft,power}
}

if {"$env(GOAL)" == "power" } {
    set_option nosavepolicies {constraints,dft}
}
if {"$env(GOAL)" == "dft" } {
    set_option nosavepolicies {constraints,power}
}
if {"$env(GOAL)" == "constr" } {
    set_option nosavepolicies {dft,power}
}


###############################################
# Dash board Generation settings (4.6 or above)
###############################################
# generate Dashboard and Datasheet reports with every run (Requires SG4.6 or later)
# set_option aggregate_report { project_summary datasheet dashboard}
# read the common dashboard success criteria file - this is a tcl based file
# set_option aggregate_report_config_file ./scripts/dashboard_report.cfg
# specify the directory where the dashboard and datasheet reports will be generated
# set_option aggregate_reportdir $env(RESULTS_DIR)/HTML_REPORTS
