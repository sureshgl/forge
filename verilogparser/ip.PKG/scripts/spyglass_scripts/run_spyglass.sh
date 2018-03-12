#!/usr/bin/bash
################################################################################
## Copyright (c) 2012-2014 by Cisco Systems, Inc. All rights reserved.
################################################################################

################################################################################################################
################################################################################################################
##  Co-Developed by:                                                                         
##  Jaga
##  email : jaga@cisco.com
##  &
##  Krishna Kumar Gundavarapu
##  email : gukumar@cisco.com
##
##
##  Revision 1.0  2011/18/4 
##  Release Notes: Initial Release
##
##  Revision 2.0  2011/31/10 
##  Release Notes: Updated SGDC parsing section to check the files in the following order
##                 If blockname_sgdc.list is present the files in it will be read
##                 If sgdc.list file is present, but has only goal specific sgdc files in it
##                 (for example blockname_power.sgdc for Power Estimation), then the generic
##                 sgdc file will be read first (names should be blockname_sdc2sgdc.sgdc or blockname.sgdc)
##
##                 If blockname_sgdc.list is not present blockname_sdc2sgdc.sgdc or blockname.sgdc will be read
##                 If either one of the file is not present, blockname_sdc2sgdc.sgdc will be created from 
##                 blockname.sdc file.
##
##                 Added support for vf files with both blockname_rtl.vf and blockname.vf
##  
##  Revision 3.0  2011/11/11 
##  Release Notes: Updated Spyglass GW Methodology variables to align with 4.6.1 release
##  
##  Revision 3.1  2011/05/12 
##  Release Notes: Modified to check for common_project_setup.tcl, .prj and sgdc_file.list
##                 in central dir first followed by local dir.
##                 For lint and lintall goals, if sgdc file or list is not present a dummy 
##                 sgdc file will be created. User has to be careful if that is not the intent.
##
##  Revision 3.2  2012/02/01 
##  Release Notes: Added creation of HTML_REPORTS DIR for dashboard/datasheet reporting
##                 Added script to create a block.prj file in subchip dir. This file is needed
##                 for dashboard/datasheet creation, as will be used for all other goals
##                 This change will result in the results dir structure change from:
##                 RESULTS_DIR/CHIP/TOP to RESULTS_DIR/TOP/TOP
##
##  Revision 4.0  2012/24/02 
##  Release Notes: Following major modifications:
##                 METHODOLOGY & SPYGLASS_METHODOLOGY_VER variable made generic pointing "current"
##                 version, which is linked to the released version in the central dir
##                 Added support for dashboard for at block and fullchip (multiple modules).
##                 "dashboard" goal inputs modified to reflect this
##                 Several file checks (vf, sglib, sgdc, waivers) skipped if the goal is gui or 
##                 dashboard
##                 Added option to read in block level WAIVER file
##
##  Revision 5.0  2012/05/03 
##  Release Notes: Added support to launch spyglass debug runs from any user dir as long as the 
##                 results dir of the user who did the actual run is known.
##                 Please note in this case the prj file also has to be from the RESULTS dir
##                 Added two new goals "adv_lint_verify" and "adv_lint_audit"
##
##  Revision 6.0  2012/16/04 
##  Release Notes: Added support to read multiple_waiver files both at block-level and chip-level common waivers
##		   eg: chip-level: tigershark_lintall_common_waivers.swl, tigershark_cdc_common_waivers.swl
##		   eg: block-level: ts_vil_lintall_waivers.swl, ts_vil_cdc_waivers.swl
##
##  Revision 7.0  2012/15/05 
##  Release Notes: Changed default version to v4.7.0
##		   Added new goal - subchip_cdc_abstract 
##
##  Revision 7.1  2012/17/05 
##  Release Notes: Added checks to pick up common_exceptions sgdc file from the scripts dir
##		   Options to provide vcd file, start/stop time and dut inst added
##
##  Revision 8.0  2012/24/07 
##  Release Notes: Added support for reading in behavioral verilog lib model for checks on gate netlist
##
##  Revision 8.1  2012/08/08 
##  Release Notes: Read cdc_waivers file for subchip_cdc_functional goal
##
##  Revision 9.0  2012/09/06 
##  Release Notes: Added support reading of block waivers/sgdc files from waivers/sgdc dir for SM15
##
##  Revision 10.0  2012/17/12 
##  Release Notes: Added support for scenarios, through command line option
##
##  Revision 11.0  2013/17/07 
##  Release Notes: Added code to look for starlifter level common waiver files and chiplet level common waiver files
##
##
################################################################################################################
################################################################################################################
export SPYDIR=`pwd`

export PROJECT_CENTRAL_DIR=/auto/be_infra/projects

# Set default values
BATCH_GUI="-batch"
CURRENT_OPT_COUNT=0
SGLIBCNT=0
export VENDOR=avago
export SGDCFILE=0
export SDCFILE=0
export SGDCLIST_EXISTS=0
export RTL=0
export GATE=0
export SCENARIO=""
export BEHAV_LIB_FOR_GATE=0
export EXT_RESULTS_FOR_DEBUG=0
export SPYGLASS_DC_PATH=/auto/edatools/synopsys/syn/v2010.12-SP5/bin
export SPYGLASS_DC_DWARE_FILES_PATH=/auto/edatools/synopsys/syn/v2010.12-SP5/packages/dware
export SPYGLASS_DC_DW_FILES_PATH=/auto/edatools/synopsys/syn/v2010.12-SP5/dw
export LM_LICENSE_FILE="6055@ls-na-west:6055@ls-na-east:1730@issg-lmgr1:6055@ls-csi:11208@smblmgr1:1724@deacon:6055@ls-na-temp:6055@192.133.150.111"

VER=v4.7.0 ; # Use -v option to change the tool version

###### Select methodology based on location #######
DATE=`date`;
echo " Date =>  $DATE"
LOCATION=`date +%Z`
echo " LOCATION => $LOCATION "
if ( [ $LOCATION == IST ] ) then 
#INDIA TEAM TO SYNC THE SJC DIR and modify this as needed
	#export METHODOLOGY=/auto/sm15_bgl/asic/users/spyglass/methodology/SiESPINE_GW_current
	#export SPYGLASS_METHODOLOGY_VER=/auto/sm15_bgl/asic/users/spyglass/methodology/GuideWare_current
	export METHODOLOGY=/auto/f4-bgl/asic/methodology2/spyglass/methodology/SiESPINE_GW_current
	export SPYGLASS_METHODOLOGY_VER=/auto/f4-bgl/asic/methodology2/spyglass/methodology/GuideWare_current
else 
	export METHODOLOGY=/auto/be_infra/methodology/spyglass/methodology/SiESPINE_GW_current
	export SPYGLASS_METHODOLOGY_VER=/auto/be_infra/methodology/spyglass/methodology/GuideWare_current
fi 


#Print help message
print_help ()
{
    echo 
    echo "          ##########          #########          #########          ##########" >&2	
    echo 
    echo "  Usage:   `basename $0`" >&2
    echo "          -h 			:: for printing this help message" >&2
    echo "          -v <tool_version> 	:: To change spyglass tool version. Ex. -v v4.4.0 Default is v4.7.0" >&2
    echo "          -c <chip_name> 	:: Ex. -c ts" >&2
    echo "          -t <design_top> 	:: Ex. -c ts (for top) or -c ts_vmc (for ts_vmc subchip)" >&2
    echo "          -s <stage> 	        :: Allowed phases are: prelim_phase, prefinal_phase, final_phase" >&2
    echo "          -g <goal> 		:: Allowed goals are: showgoals, designread, lint, lintall, adv_lint_audit, adv_lint_verify, audit, constr, erc, vendor_erc,  power, \
                                                              dft, subchip_cdc_setup, subchip_cdc_struct, subchip_cdc_structall, subchip_cdc_functional, subchip_cdc_abstract, \
							      core_cdc_setup, core_cdc_validate, core_cdc_struct, gui, dashboard, datasheet, bist_conn, all, clgoal" >&2
    echo "          -r|-n   		:: -r for rtl run and -n for gate level run" >&2
    echo "          -o      		:: -o scenario_name for, default is <blank>" >&2
    echo "          -d   		:: Results directory for the previous/saved spyglass runs; mainly used for Debug Purpose" >&2
    echo "          -w <vcd_file> 	:: VCD (waveform) file path for power analysis
    echo "          -i <DUT_INST> 	:: Block for which PE/PR analysis to be done
    echo "          -a <START_TIME> 	:: Start time in vcd waveform for PE/PR
    echo "          -b <END_TIME> 	:: End time in vcd waveform for PE/PR
    echo "          -- 			:: Addiitonal Spyglass Options. Ex. -- -gui -goals new_goal" >&2
    echo 
    echo "          ##########          #########          #########          ##########" >&2	
}

if [ $# -eq 0 ]; then
    echo "ERROR: No options specified..."
    print_help
    exit 1
fi


# Parse command line options.
while getopts :hv:c:t:d:s:g:w:i:a:b:o:rn OPT; do
    case "$OPT" in
        h)
            print_help 
            exit 0
            ;;
        v)
            VER=$OPTARG
            ;;
        c)
            export CHIP=$OPTARG
            ;;
        t)
            export TOP=$OPTARG
            ;;
        s)
            export STAGE=$OPTARG
            ;;
        g)
            export GOAL=$OPTARG
            ;;
	w)
            export VCD_PATH=$OPTARG
            ;;
        i)
            export DUT_INST=$OPTARG
            ;;
        a)
            export START_TIME=$OPTARG
            ;;
        b)
            export END_TIME=$OPTARG
            ;;
        r)
            RTL=1
            ;;
        n)
            GATE=1
            ;;
	d)
	   EXT_RESULTS_DIR=$OPTARG
	   EXT_RESULTS_FOR_DEBUG=1
	    ;;
        o)
            SCENARIO=$OPTARG
            ;;
        *)
            # getopts issues an error message
            ;;
    esac
done


shift $(($OPTIND - 1))
ADD_SG_OPT=$*



echo "INFO: Executing goal $GOAL for stage $STAGE"
export CURRENT_METHODOLOGY=${METHODOLOGY}/${STAGE}
if ( [ ${EXT_RESULTS_FOR_DEBUG} == 0 ] ); then
	export RESULTS_DIR=${SPYDIR}/RESULTS/${STAGE}
elif ( [ ${EXT_RESULTS_FOR_DEBUG} == 1 ] ); then
	export RESULTS_DIR=${EXT_RESULTS_DIR}/${STAGE}
fi

echo "INFO: Result Directory is ${RESULTS_DIR}"

#if (  [ "$GOAL" == "bist_conn" ]  ); then
#	export METHODOLOGY=/auto/edatools/atrenta/spyglass/v5.0.0/SPYGLASS_HOME/Methodology
#	export SPYGLASS_METHODOLOGY_VER=/auto/edatools/atrenta/spyglass/v5.0.0/SPYGLASS_HOME/Methodology
#        export CURRENT_METHODOLOGY=${METHODOLOGY}
#fi

if ( [ -e "${SPYDIR}/scripts/common_project_setup.tcl" ] ); then 
    export GLOBAL_SETUP=${SPYDIR}/scripts/common_project_setup.tcl
elif ( [ -e "${PROJECT_CENTRAL_DIR}/${CHIP}/spyglass/scripts/common_project_setup.tcl" ] ); then 
    export GLOBAL_SETUP=${PROJECT_CENTRAL_DIR}/${CHIP}/spyglass/scripts/common_project_setup.tcl
else 
    echo "WARNING: common_project_setup.tcl file missing. Please check ...."
fi

if ( [ -e "${SPYDIR}/scripts/f32_MEM_BIST_CONN.tcl" ] ); then 
    export GLOBAL_DFT_BIST_CONN=${SPYDIR}/scripts/f32_MEM_BIST_CONN.tcl
elif ( [ -e "${PROJECT_CENTRAL_DIR}/${CHIP}/spyglass/scripts/f32_MEM_BIST_CONN.tcl" ] ); then 
    export GLOBAL_DFT_BIST_CONN=${PROJECT_CENTRAL_DIR}/${CHIP}/spyglass/scripts/starlifter_MEM_BIST_CONN.tcl
else
    echo "WARNING: f32_MEM_BIST_CONN.tcl file missing. Please check ...."
fi

if(  [ -e "${AVAGO_ROOT}/spyglass_models/sglib.list" ] ); then
	export SGLIBLIST=${AVAGO_ROOT}/spyglass_models/sglib.list
elif (  [ -e "${SPYDIR}/${TOP}/sglib.list" ] ); then
    export SGLIBLIST=${SPYDIR}/${TOP}/sglib.list
elif ( [ -e "${SPYDIR}/tech_libs/sglib.list" ] ); then 
    echo "WARNING: Using sglib.list from a local tech_libs dir"
    export SGLIBLIST=${SPYDIR}/tech_libs/sglib.list
elif ( [ -e "${SPYDIR}/scripts/sglib.list" ] ); then 
    echo "WARNING: Using sglib.list from a local dir"
    export SGLIBLIST=${SPYDIR}/scripts/sglib.list
elif ( [ -e "${PROJECT_CENTRAL_DIR}/${CHIP}/spyglass/scripts/sglib.list" ] ); then 
    export SGLIBLIST=${PROJECT_CENTRAL_DIR}/${CHIP}/spyglass/scripts/sglib.list
else
    echo "ERROR: Unable to find sglib.list. Exiting..." >&2
fi

# Checking the sglib list
while read -r line
do
        if ( [[ ! "$line" =~ "^[ ]*#" ]] && [ ! -e "$line" ] ); then
         echo "ERROR: Library File $line Not found. Exiting......"
        fi

done < ${SGLIBLIST}

if [[ "$ADD_SG_OPT" =~ "-gui" ]]; then
   BATCH_GUI=" "
   echo "INFO: Additional Options $ADD_SG_OPT"
   echo "INFO: Invoking Spyglass in GUI mode"
else
   echo "INFO: Invoking Spyglass in BATCH mode"
fi
  
if [[ "${TOP}" =~ "${CHIP}" ]]; then
  DASHBOARD_CONFIG_FILE=${SPYDIR}/scripts/dashboard_top.cfg ;
else
  DASHBOARD_CONFIG_FILE=${SPYDIR}/scripts/dashboard_module.cfg ;
fi


##################################################
## Check and setup reading of lint waiver files
##################################################

##subchip waivers file ##
if (  [ -e ./$TOP/${TOP}_lintall_waivers.swl ] && ( [ "$GOAL" == "lintall" ] || [ "$GOAL" == "gui" ] ) ); then
      export BLOCK_LINTALL_WAIVER=./$TOP/${TOP}_lintall_waivers.swl
elif (  [ -e ./scripts/${TOP}_lintall_waivers.swl ] && ( [ "$GOAL" == "lintall" ] || [ "$GOAL" == "gui" ] ) ); then
      export BLOCK_LINTALL_WAIVER=./scripts/${TOP}_lintall_waivers.swl
elif (  [ -e ./waivers/${TOP}_lintall_waivers.swl ] && ( [ "$GOAL" == "lintall" ] || [ "$GOAL" == "gui" ] ) ); then
      export BLOCK_LINTALL_WAIVER=./waivers/${TOP}_lintall_waivers.swl
fi

##chiplet waivers file ##
if (  [ -e ./${CHIP}/${CHIP}_lintall_common_waivers.swl ] && ( [ "$GOAL" == "lintall" ]  || [ "$GOAL" == "gui" ] ) ); then
      export CHIP_LINTALL_WAIVER=./${CHIP}/${CHIP}_lintall_common_waivers.swl
elif (  [ -e ${SPYDIR}/scripts/${CHIP}_lintall_common_waivers.swl ] && ( [ "$GOAL" == "lintall" ]  || [ "$GOAL" == "gui" ] ) ); then
      export CHIP_LINTALL_WAIVER=${SPYDIR}/scripts/${CHIP}_lintall_common_waivers.swl
elif (  [ -e ./waivers/${CHIP}_lintall_common_waivers.swl ] && ( [ "$GOAL" == "lintall" ]  || [ "$GOAL" == "gui" ] ) ); then
      export CHIP_LINTALL_WAIVER=./waivers/${CHIP}_lintall_common_waivers.swl
else
    echo "WARNING: Project specific lintall waiver file doesn't exist. Please check...." >&2
fi 

#### For starlifter and blackswift, CHIP is chiplet and there could be waivers common to all chiplets, hence the additional check below ####
if (  [ -e ${PROJECT_ROOT}/starlifter/spyglass/scripts/starlifter_lintall_common_waivers.swl ] && ( [ "$GOAL" == "lintall" ]  || [ "$GOAL" == "gui" ] ) ); then

      export FULLCHIP_LINTALL_WAIVER=${PROJECT_ROOT}/starlifter/spyglass/scripts/starlifter_lintall_common_waivers.swl
elif (  [ -e ${PROJECT_ROOT}/starlifter/spyglass/waivers/starlifter_lintall_common_waivers.swl ] && ( [ "$GOAL" == "lintall" ]  || [ "$GOAL" == "gui" ] ) ); then
      export FULLCHIP_LINTALL_WAIVER=${PROJECT_ROOT}/starlifter/spyglass/waivers/starlifter_lintall_common_waivers.swl
else
    echo "WARNING: Project specific lintall waiver file doesn't exist. Please check...." >&2
fi 
if (  [ -e ${PROJECT_ROOT}/blackswift/spyglass/scripts/blackswift_lintall_common_waivers.swl ] && ( [ "$GOAL" == "lintall" ]  || [ "$GOAL" == "gui" ] ) ); then

      export FULLCHIP_LINTALL_WAIVER=${PROJECT_ROOT}/blackswift/spyglass/scripts/blackswift_lintall_common_waivers.swl
elif (  [ -e ${PROJECT_ROOT}/blackswift/spyglass/waivers/blackswift_lintall_common_waivers.swl ] && ( [ "$GOAL" == "lintall" ]  || [ "$GOAL" == "gui" ] ) ); then
      export FULLCHIP_LINTALL_WAIVER=${PROJECT_ROOT}/blackswift/spyglass/waivers/blackswift_lintall_common_waivers.swl
else
    echo "WARNING: Project specific lintall waiver file doesn't exist. Please check...." >&2
fi 


##################################################
## Check and setup reading of cdc waiver files
##################################################

##subchip waivers file ##
if (  [ -e ./$TOP/${TOP}_cdc_waivers.swl ]  && ([ "$GOAL" == "subchip_cdc_setup" ] || [ "$GOAL" == "subchip_cdc_struct" ] || \
	                                        [ "$GOAL" == "subchip_cdc_functional" ] || \
	                                        [ "$GOAL" == "subchip_cdc_abstract" ] || [ "$GOAL" == "subchip_cdc_structall" ] || [ "$GOAL" == "gui" ] || \
						[ "$GOAL" == "core_cdc_setup" ] || [ "$GOAL" == "core_cdc_validate" ] || [ "$GOAL" == "core_cdc_struct" ] )); then
      export BLOCK_CDC_WAIVER=./$TOP/${TOP}_cdc_waivers.swl
elif (  [ -e ./scripts/${TOP}_cdc_waivers.swl ]  && ([ "$GOAL" == "subchip_cdc_setup" ] || [ "$GOAL" == "subchip_cdc_struct" ] || \
	                                        [ "$GOAL" == "subchip_cdc_functional" ] || \
	                                        [ "$GOAL" == "subchip_cdc_abstract" ] || [ "$GOAL" == "subchip_cdc_structall" ] || [ "$GOAL" == "gui" ] || \
						[ "$GOAL" == "core_cdc_setup" ] || [ "$GOAL" == "core_cdc_validate" ] || [ "$GOAL" == "core_cdc_struct" ] )); then
      export BLOCK_CDC_WAIVER=./scripts/${TOP}_cdc_waivers.swl
elif (  [ -e ./waivers/${TOP}_cdc_waivers.swl ]  && ([ "$GOAL" == "subchip_cdc_setup" ] || [ "$GOAL" == "subchip_cdc_struct" ] || \
	                                        [ "$GOAL" == "subchip_cdc_functional" ] || \
	                                        [ "$GOAL" == "subchip_cdc_abstract" ] || [ "$GOAL" == "subchip_cdc_structall" ] || [ "$GOAL" == "gui" ] || \
						[ "$GOAL" == "core_cdc_setup" ] || [ "$GOAL" == "core_cdc_validate" ] || [ "$GOAL" == "core_cdc_struct" ] )); then
      export BLOCK_CDC_WAIVER=./waivers/${TOP}_cdc_waivers.swl
fi


##chiplet waivers file ##
if (  [ -e ${SPYDIR}/${CHIP}/${CHIP}_cdc_common_waivers.swl ]  && ([ "$GOAL" == "subchip_cdc_setup" ] || [ "$GOAL" == "subchip_cdc_struct" ]  || \
	                                                           [ "$GOAL" == "subchip_cdc_functional" ] || \
                                                                   [ "$GOAL" == "subchip_cdc_abstract" ] || [ "$GOAL" == "subchip_cdc_structall" ] || [ "$GOAL" == "gui" ] || \
						                   [ "$GOAL" == "core_cdc_setup" ] || [ "$GOAL" == "core_cdc_validate" ] || [ "$GOAL" == "core_cdc_struct" ] )); then
      export CHIP_CDC_WAIVER=${SPYDIR}/${CHIP}/${CHIP}_cdc_common_waivers.swl
elif (  [ -e ${SPYDIR}/scripts/${CHIP}_cdc_common_waivers.swl ]  && ([ "$GOAL" == "subchip_cdc_setup" ] || [ "$GOAL" == "subchip_cdc_struct" ]  || \
	                                                           [ "$GOAL" == "subchip_cdc_functional" ] || \
                                                                   [ "$GOAL" == "subchip_cdc_abstract" ] || [ "$GOAL" == "subchip_cdc_structall" ] || [ "$GOAL" == "gui" ] || \
						                   [ "$GOAL" == "core_cdc_setup" ] || [ "$GOAL" == "core_cdc_validate" ] || [ "$GOAL" == "core_cdc_struct" ] )); then
      export CHIP_CDC_WAIVER=${SPYDIR}/scripts/${CHIP}_cdc_common_waivers.swl
elif (  [ -e ./waivers/${CHIP}_cdc_common_waivers.swl ]  && ([ "$GOAL" == "subchip_cdc_setup" ] || [ "$GOAL" == "subchip_cdc_struct" ]  || \
	                                                           [ "$GOAL" == "subchip_cdc_functional" ] || \
                                                                   [ "$GOAL" == "subchip_cdc_abstract" ] || [ "$GOAL" == "subchip_cdc_structall" ] || [ "$GOAL" == "gui" ] || \
						                   [ "$GOAL" == "core_cdc_setup" ] || [ "$GOAL" == "core_cdc_validate" ] || [ "$GOAL" == "core_cdc_struct" ] )); then
      export CHIP_CDC_WAIVER=./waivers/${CHIP}_cdc_common_waivers.swl
else
    echo "WARNING: Project specific cdc waiver file doesn't exist. Please check...." >&2
fi

if (  [ -e ${PROJECT_ROOT}/starlifter/spyglass/scripts/starlifter_cdc_common_waivers.swl ]  && ([ "$GOAL" == "subchip_cdc_setup" ] || [ "$GOAL" == "subchip_cdc_struct" ]  || \
	                                                           [ "$GOAL" == "subchip_cdc_functional" ] || \
                                                                   [ "$GOAL" == "subchip_cdc_abstract" ] || [ "$GOAL" == "subchip_cdc_structall" ] || [ "$GOAL" == "gui" ] || \
						                   [ "$GOAL" == "core_cdc_setup" ] || [ "$GOAL" == "core_cdc_validate" ] || [ "$GOAL" == "core_cdc_struct" ] )); then
      export FULLCHIP_CDC_WAIVER=${PROJECT_ROOT}/starlifter/spyglass/scripts/starlifter_cdc_common_waivers.swl
elif (  [ -e ${PROJECT_ROOT}/starlifter/spyglass/waivers/starlifter_cdc_common_waivers.swl ]  && ([ "$GOAL" == "subchip_cdc_setup" ] || [ "$GOAL" == "subchip_cdc_struct" ]  || \
	                                                           [ "$GOAL" == "subchip_cdc_functional" ] || \
                                                                   [ "$GOAL" == "subchip_cdc_abstract" ] || [ "$GOAL" == "subchip_cdc_structall" ] || [ "$GOAL" == "gui" ] || \
						                   [ "$GOAL" == "core_cdc_setup" ] || [ "$GOAL" == "core_cdc_validate" ] || [ "$GOAL" == "core_cdc_struct" ] )); then
      export FULLCHIP_CDC_WAIVER=${PROJECT_ROOT}/starlifter/spyglass/waivers/starlifter_cdc_common_waivers.swl
fi

##################################################
## Check and setup reading of bist_conn waiver files
##################################################
if (  [ -e ./$TOP/${TOP}_bist_conn_waivers.swl ] && ( [ "$GOAL" == "bist_conn" ] || [ "$GOAL" == "gui" ] ) ); then
      export BLOCK_LINTALL_WAIVER=./$TOP/${TOP}_bist_conn_waivers.swl
elif (  [ -e ./scripts/${TOP}_bist_conn_waivers.swl ] && ( [ "$GOAL" == "bist_conn" ] || [ "$GOAL" == "gui" ] ) ); then
      export BLOCK_LINTALL_WAIVER=./scripts/${TOP}_bist_conn_waivers.swl
elif (  [ -e ./waivers/${TOP}_bist_conn_waivers.swl ] && ( [ "$GOAL" == "bist_conn" ] || [ "$GOAL" == "gui" ] ) ); then
      export BLOCK_LINTALL_WAIVER=./waivers/${TOP}_bist_conn_waivers.swl
fi
if (  [ -e ${SPYDIR}/scripts/${CHIP}_bist_conn_common_waivers.swl ] && ( [ "$GOAL" == "bist_conn" ]  || [ "$GOAL" == "gui" ] ) ); then
      export CHIP_LINTALL_WAIVER=${SPYDIR}/scripts/${CHIP}_bist_conn_common_waivers.swl
elif (  [ -e ./waivers/${CHIP}_bist_conn_common_waivers.swl ] && ( [ "$GOAL" == "bist_conn" ]  || [ "$GOAL" == "gui" ] ) ); then
      export CHIP_LINTALL_WAIVER=./waivers/${CHIP}_bist_conn_common_waivers.swl
else
    echo "WARNING: Project specific bist_conn waiver file doesn't exist. Please check...." >&2
fi 

#### For starlifter and blackswift, CHIP is chiplet and there could be waivers common to all chiplets, hence the additional check below ####
if (  [ -e ${PROJECT_ROOT}/starlifter/spyglass/scripts/starlifter_bist_conn_common_waivers.swl ] && ( [ "$GOAL" == "bist_conn" ]  || [ "$GOAL" == "gui" ] ) ); then

      export CHIP_LINTALL_WAIVER=${PROJECT_ROOT}/starlifter/spyglass/scripts/starlifter_bist_conn_common_waivers.swl
elif (  [ -e ${PROJECT_ROOT}/starlifter/spyglass/waivers/starlifter_bist_conn_common_waivers.swl ] && ( [ "$GOAL" == "bist_conn" ]  || [ "$GOAL" == "gui" ] ) ); then
      export CHIP_LINTALL_WAIVER=${PROJECT_ROOT}/starlifter/spyglass/waivers/starlifter_bist_conn_common_waivers.swl
else
    echo "WARNING: Project specific bist_conn waiver file doesn't exist. Please check...." >&2
fi 
if (  [ -e ${PROJECT_ROOT}/blackswift/spyglass/scripts/blackswift_bist_conn_common_waivers.swl ] && ( [ "$GOAL" == "bist_conn" ]  || [ "$GOAL" == "gui" ] ) ); then

      export CHIP_LINTALL_WAIVER=${PROJECT_ROOT}/blackswift/spyglass/scripts/blackswift_bist_conn_common_waivers.swl
elif (  [ -e ${PROJECT_ROOT}/blackswift/spyglass/waivers/blackswift_bist_conn_common_waivers.swl ] && ( [ "$GOAL" == "bist_conn" ]  || [ "$GOAL" == "gui" ] ) ); then
      export CHIP_LINTALL_WAIVER=${PROJECT_ROOT}/blackswift/spyglass/waivers/blackswift_bist_conn_common_waivers.swl
else
    echo "WARNING: Project specific bist_conn waiver file doesn't exist. Please check...." >&2
fi 



# END:: Setting up the waiver file

#skip from here for dashboard
if ( [ "$GOAL" != "dashboard" ] && [ "$GOAL" != "gui" ] ); then

# Check RTL or GATE option is specified
if ( [ $RTL == $GATE ]  && [ $RTL == 0 ] ); then
    echo "ERROR: Select either RTL or GATE option. Exiting..." >&2
    exit 1
else
  if ( [ $RTL == $GATE ]  && [ $RTL == 1 ] ); then
    echo "ERROR: Cannot select both RTL and GATE. Pl select either of the two. Exiting..." >&2
    exit 1
  fi
fi

# Check if design files exist
if (  [ $RTL == 1 ] && [ -e $TOP/${TOP}.vf ] ); then
   echo "INFO: Setting the source file to $TOP/${TOP}.vf"
   export SOURCE=$TOP/${TOP}.vf
elif (  [ $RTL == 1 ] && [ -e $TOP/${TOP}_rtl.vf ] ); then
   echo "INFO: Setting the source file to $TOP/${TOP}_rtl.vf"
   export SOURCE=$TOP/${TOP}_rtl.vf
elif (  [ $GATE == 1 ] && [ -e $TOP/${TOP}.v ] ); then
   echo "INFO: Setting the source file to $TOP/${TOP}.v"
   export SOURCE=$TOP/${TOP}.v
elif (  [ $GATE == 1 ] && [ -e $TOP/${TOP}.v.gz ] ); then
   echo "INFO: Setting the source file to $TOP/${TOP}.v.gz"
   export SOURCE=$TOP/${TOP}.v.gz
else 
       echo "ERROR: RTL or GATE netlist doesn't exist. Exiting..." >&2
       exit 1
fi   
   
## For gate level netlist based flow, there might be a need to read in verilog library files to prevent 
## spyglass reset propagation blockage through multi-flop sync cells or for other reasons.
if (  [ $GATE == 1 ] && [ -e $TOP/${TOP}_behavioral_lib.vf ] ); then
      BEHAV_LIB_FOR_GATE=1;
      export BEHAV_LIB_LIST_FOR_GATE=$TOP/${TOP}_behavioral_lib.vf;
fi   


# # Setting up the Technology Library file
# if (  [ ! -e $SGLIB1 ] ); then
#     echo "ERROR: Technology Lib files don't exist. Exiting ...." >&2
#     exit 1
# fi 

# Check for goal
if ( [ "$GOAL" == "constr" ]  || [ "$GOAL" == "vendor_erc" ] || [ "$GOAL" == "lint" ]  || [ "$GOAL" == "lintall" ] || \
     [ "$GOAL" == "adv_lint_audit" ] || [ "$GOAL" == "adv_lint_verify" ] || \
     [ "$GOAL" == "erc" ] || [ "$GOAL" == "power" ] || [ "$GOAL" == "subchip_cdc_setup" ] || [ "$GOAL" == "subchip_cdc_struct" ] || \
     [ "$GOAL" == "power_setup" ] || [ "$GOAL" == "power_est" ] || [ "$GOAL" == "power_redn" ] || \
     [ "$GOAL" == "subchip_cdc_structall" ] || [ "$GOAL" == "subchip_cdc_abstract" ] || \
     [ "$GOAL" == "subchip_cdc_functional" ] || [ "$GOAL" == "core_cdc_setup" ] || [ "$GOAL" == "core_cdc_validate" ] || [ "$GOAL" == "core_cdc_struct" ] || \
     [ "$GOAL" == "all" ]  || [ "$GOAL" == "gui" ] || [ "$GOAL" == "audit" ] || [ "$GOAL" == "showgoals" ] || \
     [ "$GOAL" == "dft" ] || [ "$GOAL" == "designread" ] || [ "$GOAL" == "dashboard" ] || [ "$GOAL" == "datasheet" ] || [ "$GOAL" == "bist_conn" ] ); then
     echo "GOAL selected is $GOAL"
else 
    if ( [ "$GOAL" == "clgoal" ] ); then
     echo "INFO: Command line provided goals will be executed"
    else
     echo "ERROR: $GOAL is not a valid goal setting. Exiting..." >&2
     echo "Allowed goals are: showgoals, designread, lint, constr, erc, power, dft, cdcbase, cdcformal, gui, dashboard, datasheet bist_conn, all " >&2
     exit 1
   fi
fi

# Check if constraints (sdc or sgdc) exist 
# designtopname_sgdc.list file should exist in the designtopname dir
# If file doesn't exist a new one will be created with minimum of one entry which will be
# designtopname_sdc2sgdc.sgdc. Additional sgdc files have to be manually added as needed.
   
   # Initializing variable
   SDC2SGDC_IN_LIST=0


   # Setting either SGDC or SDC or SGDC List
   if ( [ -e ${TOP}/${TOP}_sgdc.list ] || [ -e sgdc/${TOP}_sgdc.list ] ); then

      if ( [ -e ${TOP}/${TOP}_sgdc.list ] ); then
         export SGDCLIST=${TOP}/${TOP}_sgdc.list
      elif ( [ -e sgdc/${TOP}_sgdc.list ] ); then
         export SGDCLIST=sgdc/${TOP}_sgdc.list
      fi
      export SGDCLIST_EXISTS=1

      # Check if all files in this list exists, with the exception of file
      # _sdc2sgdc file, which might get created during the run.
      while read -r line
      do
              if ( [[  "$line" =~ "${TOP}_sdc2sgdc.sgdc" ]] ); then
                 ## If sdc2sgdc file is included in the list file, then read it while reading files from the list
		 ## If not read it before reading the files from the list
		 ## This case might happen only if goal specific sgdc (ex. blockname_power.sgdc for PE) is needed
		 $SDC2SGDC_IN_LIST = 1
              fi
              if ( [[ ! "$line" =~ "^[ ]*#" ]] && [ ! -e "$line" ] && [[ ! "$line" =~ "${TOP}_sdc2sgdc.sgdc" ]] && [[ ! "$line" =~ "^$" ]] ); then
               echo "ERROR: sgdc file \" ${line} \" Not found. Exiting......"
	       exit 1
              fi

      done < $SGDCLIST

      if ( [ ! -e ${TOP}/${TOP}_sdc2sgdc.sgdc ] && [ ! -e ${TOP}/${TOP}.sgdc ] ); then
	      ## If sdc2sgdc file and design_name.sgdc file doesn't exist, create the file from sdc file
          if ( [ -e ${TOP}/${TOP}.sdc ] ); then
             echo "INFO: Setting sgdc file"
             echo "current_design $TOP" > $TOP/${TOP}_fromsdc.sgdc
             echo "sdc_data -file ${TOP}/${TOP}.sdc" >> $TOP/${TOP}_fromsdc.sgdc
             export SGDC=$TOP/${TOP}_fromsdc.sgdc
             export SDCFILE=1
          elif ( [ ! "$GOAL" == "lint" ]  && [ ! "$GOAL" == "lintall" ] && [ ! "$GOAL" == "bist_conn" ] ); then 
	     echo "ERROR: Unable to find sdc2sgdc file and SDC FILE.....Exiting" >&2
             exit 1
         fi
      elif ( [ -e ${TOP}/${TOP}_sdc2sgdc.sgdc ] && [[ $SDC2SGDC_IN_LIST == 0 ]] ); then
         ## sdc2sgdc file is present due to earlier conversion, but not listed in the
	 ## sgdc.list file
         export SGDC=$TOP/${TOP}_sdc2sgdc.sgdc
         export SGDCFILE=1
      fi
   else 
      ## If sgdc_file.list doesn't exist
      if ( [ -e $TOP/${TOP}.sgdc ] ); then
        echo "INFO: Setting sgdc file"
        export SGDC=$TOP/${TOP}.sgdc
        export SGDCFILE=1
      else 
      	if ( [ -e ${TOP}/${TOP}_sdc2sgdc.sgdc ] ); then
          # To avoid creating same sgdc file for multiple goals
	  # sgdc file created in the first goal and reused subsequently
          echo "INFO: Setting sgdc file"
          export SGDC=$TOP/${TOP}_sdc2sgdc.sgdc
          export SGDCFILE=1
        else 
	  if ( [ -e $TOP/${TOP}_fromsdc.sgdc ] ); then
           export SGDC=$TOP/${TOP}_fromsdc.sgdc
           export SDCFILE=1
	  else 
            if ( [ -e $TOP/${TOP}.sdc ] ); then
             echo "INFO: Setting sgdc file"
             echo "current_design $TOP" > $TOP/${TOP}_fromsdc.sgdc
             echo "sdc_data -file $TOP/${TOP}.sdc" >> $TOP/${TOP}_fromsdc.sgdc
             export SGDC=$TOP/${TOP}_fromsdc.sgdc
             export SDCFILE=1
            else
	     if ( [ "$GOAL" == "lint" ]  || [ "$GOAL" == "lintall" ] || [ "$GOAL" == "bist_conn" ] ); then 
                echo "WARNING: Using dummy sgdc file. Not a recommended flow. Pl check ..." >&2
		#touch ./dummy.sgdc
                #export SGDC=./dummy.sgdc
                #export SDCFILE=1
             else  
                echo "ERROR: Unable to find SGDCLIST, SGDC FILE or SDC FILE.....Exiting" >&2
                exit 1
             fi
           fi
          fi
	fi
     fi
   fi

   ### Check if common exceptions sgdc file exists in scripts to be read during spyglass checks
   ### File name should be CHIP_common_exceptions.sgdc eg. tigershark_common_exceptions.sgdc
   if ( [ -e scripts/${CHIP}_common_exceptions.sgdc ] ); then
       export CHIP_COMMON_SGDC_EXISTS=1
       export CHIP_COMMON_SGDC_FILE=scripts/${CHIP}_common_exceptions.sgdc
   elif (  [ -e ${PROJECT_ROOT}/starlifter/spyglass/scripts/starlifter_common_exceptions.sgdc ]  ); then
       export CHIP_COMMON_SGDC_EXISTS=1
       export CHIP_COMMON_SGDC_FILE=${PROJECT_ROOT}/starlifter/spyglass/scripts/starlifter_common_exceptions.sgdc
   fi

# Results Dir
  mkdir -p $RESULTS_DIR
  mkdir -p $RESULTS_DIR/${TOP}

# HTML Report Directory
  mkdir -p ${RESULTS_DIR}/HTML_REPORTS  


fi
#end-skip section for dashboard 

if ( [ ${EXT_RESULTS_FOR_DEBUG} == 1 ] ); then
   # Check for Project file - Debug using other users results
   if ( [ -e ${RESULTS_DIR}/${TOP}/${TOP}.prj ] ); then
      proj_file=${RESULTS_DIR}/${TOP}/${TOP}.prj
   else
      echo "ERROR: Unable to find prj file in user RESULTS dir ${RESULTS_DIR}/${TOP}/${TOP}.prj ......Exiting" >&2
      exit 1
   fi
else
   # Check for Project file - Normal run
   #if ( [ -e ${SPYDIR}/scripts/${CHIP}.prj ] ); then
   #   echo "WARNING: Using project file from local dir ...."
   #   cp ${SPYDIR}/scripts/${CHIP}.prj ${RESULTS_DIR}/${TOP}/${TOP}.prj
   if ( [ -e ${SPYDIR}/${CHIP}.prj ] ); then
      echo "WARNING: Using project file from local dir ...."
      cp ${SPYDIR}/${CHIP}.prj ${RESULTS_DIR}/${TOP}/${TOP}.prj
      sed -i "s/\$env.TOP./${TOP}/" ${RESULTS_DIR}/${TOP}/${TOP}.prj 
      proj_file=${RESULTS_DIR}/${TOP}/${TOP}.prj
   elif ( [ -e ${PROJECT_CENTRAL_DIR}/${CHIP}/spyglass/scripts/${CHIP}.prj ] ); then
      echo "INFO: Using project file from central dir ...."
      cp ${PROJECT_CENTRAL_DIR}/${CHIP}/spyglass/scripts/${CHIP}.prj ${RESULTS_DIR}/${TOP}/${TOP}.prj
      sed -i "s/\$env.TOP./${TOP}/" ${RESULTS_DIR}/${TOP}/${TOP}.prj 
      proj_file=${RESULTS_DIR}/${TOP}/${TOP}.prj
   else 
      echo "ERROR: Project file missing. Exiting..." >&2
   fi
fi


#Start of Case statement for different goal execution

    case "$GOAL" in
        "clgoal")
            echo "Executing $GOAL ....." >&2
	    spyglass --v $VER -64bit \
		     $BATCH_GUI \
                     $ADD_SG_OPT \
	             -project $proj_file
           ;;
        "showgoals")
            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit \
		     $BATCH_GUI \
                     $ADD_SG_OPT \
	             -project $proj_file \
		     -showgoals
            ;;
        "designread")
            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit \
		     $BATCH_GUI \
                     $ADD_SG_OPT \
	             -project $proj_file \
		     -designread 
            ;;
        "lint")
		     # -group \
		     # -group_name all_lint \

            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit \
		     $BATCH_GUI \
                     $ADD_SG_OPT \
	             -project $proj_file \
                     -goals lint/structure$SCENARIO \
                     -goals lint/synthesis$SCENARIO \
                     -goals lint/connectivity$SCENARIO \
                     -goals lint/simulation$SCENARIO 
            ;;
        "lintall")
            echo "Executing $GOAL $ADD_SG_OPT ..." >&2
            echo "ADD_SG_OPT is $ADD_SG_OPT $BATCH_GUI $proj_file $SCENARIO ..." >&2
	    spyglass -64bit \
		     $BATCH_GUI \
                     $ADD_SG_OPT \
	             -project $proj_file \
                     -goals lint/lintall$SCENARIO \
            ;;
       "adv_lint_audit")
            echo "Executing $GOAL ..." >&2
            spyglass --v $VER -64bit \
                     $BATCH_GUI \
                     $ADD_SG_OPT \
                     -project $proj_file \
                     -goals adv_lint/adv_lint_audit$SCENARIO
            ;;
        "adv_lint_verify")
            echo "Executing $GOAL ..." >&2
            spyglass --v $VER -64bit \
                     $BATCH_GUI \
                     $ADD_SG_OPT \
                     -project $proj_file \
                     -goals adv_lint/adv_lint_verify$SCENARIO
            ;;
        "audit")
            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit \
		     $BATCH_GUI \
                     $ADD_SG_OPT \
	             -project $proj_file \
                     -goals audit/block_profile$SCENARIO \
            ;;
        "constr")
            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit \
		     $BATCH_GUI \
                     $ADD_SG_OPT \
	             -project $proj_file \
                     -goals constraint/sdc_quick_check$SCENARIO \
                     -goals constraint/sdc_coverage$SCENARIO \
                     -goals constraint/clock_consis$SCENARIO \
                     -goals constraint/io_delay$SCENARIO \
                     -goals constraint/combo_path_check$SCENARIO \
                     -goals constraint/structural_exception$SCENARIO
            ;;
        "subchip_cdc_setup")
            echo "Executing $GOAL ..." >&2
            spyglass --v $VER -64bit \
                     $BATCH_GUI \
                     $ADD_SG_OPT \
                     -project $proj_file \
                     -goals cdc_block/cdc_setup$SCENARIO \
                     -goals cdc_block/cdc_setup_check$SCENARIO \
                     -goals cdc_block/cdc_gen_inputs$SCENARIO \
                      echo " INFO:: Auto and generated clk and resets are reported in sgdc files under \
		                  PRELIM_RESULTS/${TOP}/${TOP}/cdc_block/cdc_setup/$SCENARIO/spyglass_reports/clock-reset dir"
           ;;
        "subchip_cdc_struct")
            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit \
		     $BATCH_GUI \
                     $ADD_SG_OPT \
	             -project $proj_file \
                     -goals cdc_block/cdc_struct$SCENARIO
            ;;
        "subchip_cdc_structall")
            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit \
		     $BATCH_GUI \
                     $ADD_SG_OPT \
	             -project $proj_file \
                     -goals cdc_block/cdc_structall$SCENARIO 
            ;;
        "subchip_cdc_functional")
            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit \
		     $BATCH_GUI \
                     $ADD_SG_OPT \
	             -project $proj_file \
                     -goals cdc_block/cdc_formal_setup$SCENARIO \
                     -goals cdc_block/cdc_formal$SCENARIO 
            ;;
        "subchip_cdc_abstract")
            echo "Executing $GOAL ..." >&2
            spyglass --v $VER -64bit \
                     $BATCH_GUI \
                     $ADD_SG_OPT \
                     -project $proj_file \
                     -goals cdc_block/cdc_abstract$SCENARIO 
            ;;
        "core_cdc_setup" )
            echo "Executing $GOAL ..." >&2
            spyglass --v $VER -64bit \
                     $BATCH_GUI \
                     $ADD_SG_OPT \
                     -project $proj_file \
                     -goals cdc_soc/cdc_setup$SCENARIO \
                     -goals cdc_soc/cdc_setup_check$SCENARIO \
                     -goals cdc_soc/cdc_gen_inputs$SCENARIO
            ;; 
        "core_cdc_validate" )
            echo "Executing $GOAL ..." >&2
            spyglass --v $VER -64bit \
                     $BATCH_GUI \
                     $ADD_SG_OPT \
                     -project $proj_file \
                     -goals cdc_soc/cdc_validate$SCENARIO 
            ;;
        "core_cdc_struct")
            echo "Executing $GOAL ..." >&2
            spyglass --v $VER -64bit \
                     $BATCH_GUI \
                     $ADD_SG_OPT \
                     -project $proj_file \
                     -goals cdc_soc/cdc_validate$SCENARIO \
                     -goals cdc_soc/cdc_verif_struct$SCENARIO
            ;;
        "dft")
            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit \
		     $BATCH_GUI \
                     $ADD_SG_OPT \
	             -project $proj_file \
                     -goals dft_readiness/dft_setup$SCENARIO \
                     -goals dft_readiness/dft_stuck_at_coverage_audit$SCENARIO \
                     -goals dft_readiness/dft_best_practice$SCENARIO \
                     -goals dft_readiness/dft_latches$SCENARIO \
                     -goals dft_readiness/dft_scan_ready$SCENARIO \
                     -goals dft_readiness/dft_test_points$SCENARIO \
                     -goals dft_readiness/dft_block_check$SCENARIO
            ;;
        "bist_conn")
            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit \
		     $BATCH_GUI \
                     $ADD_SG_OPT \
	             -project $proj_file \
                     -goals dft_readiness/dft_block_check$SCENARIO
            ;;
        "power_setup")
            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit                \
                     $BATCH_GUI                     \
                     $ADD_SG_OPT                    \
                     -project $proj_file            \
                     -goals power/power_audit$SCENARIO  
            ;;
        "power_est")
            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit                \
                     $BATCH_GUI                     \
                     $ADD_SG_OPT                    \
                     -project $proj_file            \
                     -goals power/activity_check$SCENARIO  \
                     -goals power/power_est_average$SCENARIO  \
                     -goals power/power_profiling$SCENARIO \
                     -goals power/power_pre_reduction_adv$SCENARIO 
            ;;
        "power_redn")
            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit                \
                     $BATCH_GUI                     \
                     $ADD_SG_OPT                    \
                     -project $proj_file            \
                     -goals power/power_reduction_adv$SCENARIO

            ;;
        "power")
            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit                \
                     $BATCH_GUI                     \
                     $ADD_SG_OPT                    \
                     -project $proj_file            \
                     -goals power/activity_check$SCENARIO  \
                     -goals power/power_est_average$SCENARIO  \
                     -goals power/power_profiling$SCENARIO \
                     -goals power/power_pre_reduction_adv$SCENARIO \
                     -goals power/power_reduction_adv$SCENARIO

            ;;
        "vendor_erc")
            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit \
		     $BATCH_GUI \
                     $ADD_SG_OPT \
                     -project $proj_file \
		     -goals vendor_checks/${VENDOR}_ercblock$SCENARIO
             ;;
        "erc")
            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit \
		     $BATCH_GUI \
                     $ADD_SG_OPT \
                     -project $proj_file \
		     -goals gate_netlist_checks/erc$SCENARIO
             ;;
        "dashboard")
            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit \
		     $BATCH_GUI \
                     $ADD_SG_OPT \
	             -config_file ${DASHBOARD_CONFIG_FILE} \
		     -reportdir ${RESULTS_DIR}/HTML_REPORTS \
                     -gen_aggregate_report dashboard
            ;;
        "datasheet")
            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit \
		     $BATCH_GUI \
                     $ADD_SG_OPT \
		     -config_file ${PROJECT_CENTRAL_DIR}/${CHIP}/spyglass/scripts/datasheet_report.cfg \
                     -gen_aggregate_report datasheet
            ;;
        "gui")
            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit \
                     $ADD_SG_OPT \
		     -project $proj_file
            ;;
        "all")
            echo "Executing $GOAL ..." >&2
	    spyglass --v $VER -64bit \
	             $BATCH_GUI \
                     $ADD_SG_OPT \
	             -project $proj_file \
                     -goals lint/lintall$SCENARIO \
		     -goals adv_lint/adv_lint_audit$SCENARIO \
		     -goals adv_lint/adv_lint_verify$SCENARIO \
                     -goals audit/block_profile$SCENARIO \
		     -goals vendor_checks/${VENDOR}_ercblock$SCENARIO \
                     -goals cdc_block/cdc_setup$SCENARIO \
                     -goals cdc_block/cdc_setup_check$SCENARIO \
                     -goals cdc_block/cdc_gen_inputs$SCENARIO \
                     -goals cdc_block/cdc_struct$SCENARIO \
                     -goals cdc_block/cdc_formal_setup$SCENARIO \
                     -goals cdc_block/cdc_formal$SCENARIO \
                     -goals cdc_block/cdc_abstract$SCENARIO \
                     -goals dft_readiness/dft_setup$SCENARIO \
                     -goals dft_readiness/dft_stuck_at_coverage_audit$SCENARIO \
                     -goals dft_readiness/dft_best_practice$SCENARIO \
                     -goals dft_readiness/dft_latches$SCENARIO \
                     -goals dft_readiness/dft_scan_ready$SCENARIO \
                     -goals dft_readiness/dft_test_points$SCENARIO \
                     -goals dft_readiness/dft_block_check$SCENARIO \
                     -goals power/activity_check$SCENARIO \
                     -goals power/power_audit$SCENARIO \
                     -goals power/power_pre_reduction_adv$SCENARIO \
                     -goals power/power_audit$SCENARIO  \
                     -goals power/power_est_average$SCENARIO \
                     -goals power/power_reduction_adv$SCENARIO
            ;;
        \?)
            # getopts issues an error message
            echo "ERROR: $GOAL is not a valid goal setting. Exiting..." >&2
            exit 1
            ;;
    esac



## Remove the switches we parsed above.
#shift `expr $OPTIND - 1`
#
## We want at least one non-option argument.
## Remove this block if you don't need it.
#if [ $# -eq 0 ]; then
#    echo $USAGE >&2
#    exit 1
#fi
#
## Access additional arguments as usual through
## variables $@, $*, $1, $2, etc. or using this loop:
#for PARAM; do
#    echo $PARAM
#done

# EOF