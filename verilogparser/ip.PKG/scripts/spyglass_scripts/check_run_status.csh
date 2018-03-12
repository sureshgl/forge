#!/bin/csh -f
########################################################################
#  Copyright (c) 2013-2015 by Cisco Systems Inc.  All Rights reserved
########################################################################
touch $PROJECT_ROOT/$chiplet/run_lsf_$subchip.log
#if ( $VERT_FLOW == "false" ) then
#	sleep `grep -m1 -ao '[3-10]' /dev/urandom | sed s/0/10/ | head -n1`
#endif

if (  -e $PROJECT_ROOT/$chiplet/syn/syn_status/syn_done_$SUBCHIP  && $VERT_FLOW == "true" &&   `bjobs -J F32_SPY_RUN | grep " RUN " | wc -l`  <  $num_jobs ) then
	echo "$SUBCHIP Synthesis is completed at `date`..." >>$PROJECT_ROOT/$chiplet/run_lsf_$subchip.log
	echo " Proceeding to CDC run... " >>$PROJECT_ROOT/$chiplet/run_lsf_$SUBCHIP.log  
        echo -n "CDC: Number of spyglass license used " >> $PROJECT_ROOT/$chiplet/run_lsf_$subchip.log
        echo `bjobs -J F32_SPY_RUN | grep " RUN " | wc -l` >> $PROJECT_ROOT/$chiplet/run_lsf_$subchip.log
        echo "CDC: Number_of spyglass license set for use $num_jobs">>$PROJECT_ROOT/$chiplet/run_lsf_$subchip.log 
	exit 0
else if ( $goal == "lintall" && $VERT_FLOW == "true" &&   `bjobs -J F32_SPY_RUN | grep " RUN " | wc -l` <  $num_jobs ) then
	echo "Proceeding to lint run...">>$PROJECT_ROOT/$chiplet/run_lsf_$subchip.log
        echo -n "LINT: Number of spyglass license used " >> $PROJECT_ROOT/$chiplet/run_lsf_$subchip.log
        echo `bjobs -J F32_SPY_RUN | grep " RUN " | wc -l` >> $PROJECT_ROOT/$chiplet/run_lsf_$subchip.log
        echo "LINT: Number_of spyglass license set for use $num_jobs">>$PROJECT_ROOT/$chiplet/run_lsf_$subchip.log 
	exit 0
else if ( $VERT_FLOW == "false" ) then
	echo "No Vertical flow Proceeding to lint run...">>$PROJECT_ROOT/$chiplet/run_lsf_$subchip.log
        echo -n "Number of spyglass license used " >> $PROJECT_ROOT/$chiplet/run_lsf_$subchip.log
        echo `bjobs -J F32_SPY_RUN | grep " RUN " | wc -l` >> $PROJECT_ROOT/$chiplet/run_lsf_$subchip.log
        echo "Number_of spyglass license set for use $num_jobs">>$PROJECT_ROOT/$chiplet/run_lsf_$subchip.log 
        exit 0
else 
	echo -n "$SUBCHIP back in queue on " >>$PROJECT_ROOT/$chiplet/run_lsf_$subchip.log
	echo `date` >>$PROJECT_ROOT/$chiplet/run_lsf_$subchip.log
	exit 1
endif

