#!/usr/bin/env tclsh

###############################################
####### Restrictions for eGIgine #######
###############################################

#set Gapout 1732345.1		;# get from restrictions    (for each fp we must have equal or bigger gap area)
set kcoffdonat 1.5		;# get from Restrictions (coeff for DONATE increasing area dx dy)
#set Gapout 20000.0		;# experiment


proc minimum_gap_area {N sizelist} \
{
	set percent 0.5
	set bankarea [round [expr [lindex $sizelist 0 1]*[lindex $sizelist 0 2]]]
	set area [round [expr ($bankarea/100*$percent)*($N*$N)/2]]
	return $area
}

##############################################

####################################################################
####### Restrictions for choosing fp's by ratio and gap area #######
####################################################################
#
#set ratio_fp_max 2.0
#set ratio_fp_min 1.0
#
#set std_cell_area_max 50000.0   ;#(fp area)-(total macro area)
#set std_cell_area_min 0.0
#
###################################################################


#namespace path {tcl::mathop tcl::mathfunc}
#puts [* [sqrt 49] [+ 1 2 3]]
#
#namespace eval foo {
#    variable bar 0
#    proc grill {} {
#        variable bar
#        puts "called [incr bar] times"
#    }
#    namespace export grill
#}
## Direct call
#::foo::grill
#
## Use the command resolution path to find the name
#namespace eval boo {
#    namespace path ::foo
#    grill
#}
#
## Import into current namespace, then call local alias
#namespace import foo::grill
#grill
#
## Create two ensembles, one with the default name and one with a
## specified name.  Then call through the ensembles.
#namespace eval foo {
#    namespace ensemble create
#    namespace ensemble create -command ::foobar
#}
#foo grill
#foobar grill
#
#puts "grill came from [namespace origin grill]"
#
#
#
#
#array set qwe {
#	qwe asd
#	qaz edc
#}
#
#
#puts $qwe
