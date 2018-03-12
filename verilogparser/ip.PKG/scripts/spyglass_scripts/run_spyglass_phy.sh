#!/usr/bin/env bash
################################################################################
## Copyright (c) 2013-2014 by Cisco Systems, Inc. All rights reserved.
################################################################################

################################################################################################################
################################################################################################################
##  Developed : Kranthi Rajoli
##  email : krajoli@cisco.com
##  
##  Revision 1.0: 2013/05/03
##  Revision Notes: Initial checkin
##  
##  Revision 2.0: 2013/05/07
##  Revision Notes: Bug fixed in creating lef.list
##                  Captable creation required only for lib_prep goal, disabled it for other goals
##
##  Revision 3.0: 2013/05/10
##  Revision Notes: Captable modification was done for VIAs
##                  Ability to collect all the libs and lefs if memory list not available
##  Revision 4.0: 2013/09/17
##  Revision Notes: Removed the ability to use the memory list from RTL area
##                  Since we can generate the tech lib for entire starlifter once and use it for all subchips
##                  Also changed the version to 5.1.0

if [ $# -eq 0 ]; then
    echo "ERROR: No options specified..."
    print_help
    exit 1
fi


export RESULTS_DIR=./RESULTS
# Parse command line options.
while getopts :hv:c:t:g:i:a:b:rn OPT; do
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
        g)
            export GOAL=$OPTARG
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
            export RTL=1
	    export GATE=0
            ;;
        n)
            export GATE=1
	    export RTL=0
            ;;
        *)
            # getopts issues an error message
            ;;
    esac
done

#Temporarily hacking the version here
echo "Using the recommended version (v5.1.1.2) of Spyglass for physical runs; ignoring user specified version"
VER="v5.1.1.2"

export SPYGLASS_PHYSICAL_HOME=/auto/edatools/atrenta/spyglass/${VER}/SPYGLASS_PHYSICAL_HOME

export SOURCE=./${TOP}/${TOP}.vf
export PHYSICAL_METHODOLOGY=${SPYGLASS_PHYSICAL_HOME}/common/sgphysical/templates
export CURRENT_METHODOLOGY=${PHYSICAL_METHODOLOGY}
export SPYGLASS_DC_PATH=/auto/edatools/synopsys/syn/v2010.12-SP5/bin
export SPYGLASS_DC_DWARE_FILES_PATH=/auto/edatools/synopsys/syn/v2010.12-SP5/packages/dware
export SPYGLASS_DC_DW_FILES_PATH=/auto/edatools/synopsys/syn/v2010.12-SP5/dw
export LEFLIST=./scripts/lef.list
export LIBLIST=./scripts/lib.list
export SPYDIR=`pwd`
export ATRENTA_LICENSE_FILE="6055@ls-na-west:6055@ls-na-east:1730@issg-lmgr1:4523@issg-lmgr1:6055@ls-csi:11208@smblmgr1:1724@deacon:6055@ls-na-temp:6055@192.133.150.111:5045@ls-na-west:5045@ls-bgl-lnx1"

DATE=`date`;
echo " Date =>  $DATE"
LOCATION=`date +%Z`
echo " LOCATION => $LOCATION "
if ( [ $LOCATION == IST ] ) then 
    MW_MEM_DIR="/auto/f4-bgl/asic/avago/memory_lib_db"
    TECH_DIR="/auto/f4-bgl/asic/avago/sl_design_kit_2013_04_26/dct_design_kit/std_cell_libs_avago"
    TECH_FILE="/auto/f4-bgl/asic/avago/sl_design_kit_2013_04_26/dct_design_kit/design_support/tech/10M_7x2r_R.lef"
    CAPTABLEFILE="/auto/f4-bgl/asic/avago/edi/tech/10M_7x2r_R0918HPM_rc_worst.captable"
else 
    MW_MEM_DIR="/auto/f4_asic2/users/avago/memory_lib_db"
    TECH_DIR="/auto/f4-bgl/asic/avago/sl_design_kit_2013_04_26/dct_design_kit/std_cell_libs_avago"
    TECH_FILE="/auto/f4-bgl/asic/avago/sl_design_kit_2013_04_26/dct_design_kit/design_support/tech/10M_7x2r_R.lef"
    CAPTABLEFILE="/auto/f4-bgl/asic/avago/edi/tech/10M_7x2r_R0918HPM_rc_worst.captable"
fi 

NEW_TECH_FILE=${SPYDIR}/10M_7x2r_R_captable.lef

## Using the macro list from the rtl area
#if ( [ -e ${SPYDIR}/../rtl/${TOP}/${TOP}_mem_slf.list ] ); then
#    echo "INFO: Using memory list from rtl area ..."
#    while read line; do
#	if [[ ${line} =~ ^\s*([a-zA-Z0-9_]+)\_ss.db ]]; then
#	    lef_collection="${lef_collection} ${BASH_REMATCH[1]}.lef"
#	    lib_collection="${lib_collection} ${BASH_REMATCH[1]}_ss.lib"
#	fi
#    done < ${SPYDIR}/../rtl/${TOP}/${TOP}_mem_slf.list
#else
echo "Using all the available memories from the central area ..."
for lf in `find ${MW_MEM_DIR} -name "*.lef" -printf "%f\n"`; do
	lef_collection="${lef_collection} ${lf}"
done
for lf in `find ${MW_MEM_DIR} -name "*_ss.lib" -printf "%f\n"`; do
	lib_collection="${lib_collection} ${lf}"
done
#fi


# Results Dir
  mkdir -p $RESULTS_DIR
  mkdir -p $RESULTS_DIR/${TOP}

if ( [ -e $RESULTS_DIR/${TOP}/lef.list ] );then
    \mv $RESULTS_DIR/${TOP}/lef.list $RESULTS_DIR/${TOP}/lef.list.bak
fi

if ( [ -e $RESULTS_DIR/${TOP}/lib.list ] );then
    \mv $RESULTS_DIR/${TOP}/lib.list $RESULTS_DIR/${TOP}/lib.list.bak
fi

echo " " > $RESULTS_DIR/${TOP}/lef.list
echo " " > $RESULTS_DIR/${TOP}/lib.list

## Create the new captable file only for lib_prep goal;
## cap2lef.v2.pl is a utility provided by Atrenta to merge the 
## cap/resis information from the captable to the tech file
if [[ ${GOAL} == "lib_prep" ]]; then
    CAPTABLEFILE_NEW=${CAPTABLEFILE}_new

    \cp -rf ${CAPTABLEFILE} ${CAPTABLEFILE_NEW}

    echo "INFO: Generating new captable file with metal name hacks"
    sed -i -e 's/M10/metal10/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/M11/metal11/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/M1/metal1/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/M2/metal2/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/M3/metal3/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/M4/metal4/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/M5/metal5/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/M6/metal6/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/M7/metal7/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/M8/metal8/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/M9/metal9/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/VIA1/via1/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/VIA2/via2/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/VIA3/via3/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/VIA4/via4/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/VIA5/via5/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/VIA6/via6/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/VIA7/via7/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/VIA8/via8/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/VIA9/via9/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/VIA RV/VIA via10/g' ${CAPTABLEFILE_NEW}
    sed -i -e 's/VIA polyCont/VIA CO/g' ${CAPTABLEFILE_NEW}
    echo "INFO: Generating new TECH file with captable information"
    ./scripts/cap2lef.v2.pl -l ${TECH_FILE} -c ${CAPTABLEFILE_NEW} -n ${NEW_TECH_FILE}
fi

## The tech file should be the first entry in lef.list followed by other lefs
echo "INFO: Creating lef.list ..."
echo "${NEW_TECH_FILE}" >> $RESULTS_DIR/${TOP}/lef.list
echo "${TECH_DIR}/av28m_hvt/av28m_hvt.lef" >> $RESULTS_DIR/${TOP}/lef.list
echo "${TECH_DIR}/av28m_hvt/av28m_hvt.only_UU_flops.lef" >> $RESULTS_DIR/${TOP}/lef.list
echo "${TECH_DIR}/av28m_lvt/av28m_lvt.lef" >> $RESULTS_DIR/${TOP}/lef.list
echo "${TECH_DIR}/av28m_lvt/av28m_lvt.only_UU_flops.lef" >> $RESULTS_DIR/${TOP}/lef.list
echo "${TECH_DIR}/av28m_svt/av28m_svt.lef" >> $RESULTS_DIR/${TOP}/lef.list
echo "${TECH_DIR}/av28m_svt/av28m_svt.only_UU_flops.lef" >> $RESULTS_DIR/${TOP}/lef.list

for lll in ${lef_collection};do
    echo "${MW_MEM_DIR}/${lll}" >> $RESULTS_DIR/${TOP}/lef.list
done

## No dependency here, libs can be in any order
echo "INFO: Creating lib.list ..."
echo "${TECH_DIR}/av28m_hvt/av28m_hvt_ss.lib" >> $RESULTS_DIR/${TOP}/lib.list
echo "${TECH_DIR}/av28m_lvt/av28m_lvt_ss.lib" >> $RESULTS_DIR/${TOP}/lib.list
echo "${TECH_DIR}/av28m_svt/av28m_svt_ss.lib" >> $RESULTS_DIR/${TOP}/lib.list
for lll in ${lib_collection};do
    echo "${MW_MEM_DIR}/${lll}" >> $RESULTS_DIR/${TOP}/lib.list
done

export LEFLIST=$RESULTS_DIR/${TOP}/lef.list
export LIBLIST=$RESULTS_DIR/${TOP}/lib.list
 
   # Check for Project file - Normal run
   if ( [ -e ${SPYDIR}/scripts/${CHIP}.prj ] ); then
      echo "WARNING: Using project file from local dir ...."
      cp ${SPYDIR}/scripts/${CHIP}_physical.prj ${RESULTS_DIR}/${TOP}/${TOP}_physical.prj
      sed -i "s/\$env.TOP./${TOP}/" ${RESULTS_DIR}/${TOP}/${TOP}_physical.prj 
      proj_file=${RESULTS_DIR}/${TOP}/${TOP}_physical.prj
   else 
      echo "ERROR: Project file missing. Exiting..." >&2
   fi

echo "GOAL is $GOAL"
case "$GOAL" in
	"lib_prep")
	    echo "Executing $GOAL ....." >&2
	    /auto/edatools/atrenta/spyglass/v5.1.1.2/SPYGLASS_HOME/bin/spyglass -64bit \
		     -batch \
	             $ADD_SG_OPT \
	             -project $proj_file \
		     -goals physical_library_preparation
	   ;;
	"phy_signoff")
	    echo "Executing $GOAL ..." >&2
	    /auto/edatools/atrenta/spyglass/v5.1.1.2/SPYGLASS_HOME/bin/spyglass -64bit \
		     -batch \
	             $ADD_SG_OPT \
	             -project $proj_file \
		     -goals physical_analysis_signoff
	    echo "Checking for logical congestion ..."  >& 2
            # Set the name of physical_analysis_signoff logical congestion report
            SIGNOFF_CONG_RPT=$RESULTS_DIR/$TOP/$TOP\_physical/$TOP/physical_analysis_signoff/spyglass_reports/physical/reports/SGP_logical_congestion.rpt
            if ( [ -e $SIGNOFF_CONG_RPT ] ); then
                # Get the number of internally congested modules
                congested_module_count=`awk '/Internal Congestion Module Count/ {print  $NF}' $SIGNOFF_CONG_RPT`
                # Fire physical_analysis_congestion if there is internal congestion with physical_analysis_signoff
                if [ $congested_module_count -gt 0 ]; then
                echo "Block has logical congestion reported by physical_signoff_goal. Number of internally congested module(s): $congested_module_count ..." >& 2
                echo "Executing physical_analysis_congestion ..." >& 2
                /auto/edatools/atrenta/spyglass/v5.1.1.2/SPYGLASS_HOME/bin/spyglass --v $VER -64bit \
                     -batch \
                     $ADD_SG_OPT \
                     -project $proj_file \
                     -goals physical_analysis_congestion
                else
                echo "Block has no logical congestion reported by physical_signoff_goal. Not executing physical_analysis_congestion goal ..." >& 2
                fi
             else
                echo "$SIGNOFF_CONG_RPT does not exist. Not executing physical_congestion_goal ..." >& 2
             fi
	    ;;
	"congestion")
	    echo "Executing $GOAL ..." >&2
	    /auto/edatools/atrenta/spyglass/v5.1.1.2/SPYGLASS_HOME/bin/spyglass -64bit \
		     -batch \
	             $ADD_SG_OPT \
	             -project $proj_file \
		     -goals physical_analysis_congestion
	    ;;
	"gui")
	    echo "Executing $GOAL ..." >&2
	    /auto/edatools/atrenta/spyglass/v5.1.1.2/SPYGLASS_HOME/bin/spyglass -64bit \
	             $ADD_SG_OPT \
		     -project $proj_file
	    ;;
	\?)
	    echo "ERROR: $GOAL is not a valid goal setting. Exiting..." >&2
	    exit 1
	    ;;
esac
