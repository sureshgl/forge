#!/usr/bin/env tclsh

#namespace path {tcl::mathop tcl::mathfunc}

#puts [* [sqrt 49] [+ 1 2 3]]
proc extrY {list dy} \
{
	set newlist {}
	foreach i $list {
		set inew {}
		lappend newlist [list [lindex $i 0] [list [lindex $i 1 0] [round [expr [lindex $i 1 1]+$dy]] \
						[lindex $i 1 2]] [list [lindex $i 2 0]    [round [expr [lindex $i 2 1]+$dy]]]]
	}  
	return $newlist
}  

proc extrX {list dx} \
{
	set newlist {}
	foreach i $list {
		set inew {}
		lappend newlist [list [lindex $i 0] [list [round [expr [lindex $i 1 0]+$dx]] [lindex $i 1 1] \
						[lindex $i 1 2]]	[list [round [expr [lindex $i 2 0]+$dx]] [lindex $i 2 1]]]
	}  
	return $newlist
}  

proc Gapgen {list flist shape} { 
	global kcoffdonat
	global Gapout
	global sizelist
	global xd
	global yd
	set newfp {}
	set Maxx {}
	set Maxy {}
	set maxXlist {}				
	set maxYlist {}  
	foreach var $list {
		set Maxx [lindex [lsort -uniq -real [lappend maxXlist   [lindex $var 1 0] [lindex $var 2 0]]] end]
		set Maxy [lindex [lsort -uniq -real [lappend maxYlist   [lindex $var 1 1] [lindex $var 2 1]]] end]
	}
	set bankarea {}
	foreach i $list {
		if {[regexp {.*t1.*} [lindex $i 0]]==1} {
            set barea [round [expr [lindex $sizelist 0 2]*[lindex $sizelist 0 1]]]
	        } else {
			#	set barea [round [expr [lindex $sizelist 1 2]*[lindex $sizelist 1 1]]]
			}	
			set bankarea [round [expr $bankarea+$barea]]
		}
	set FParea [round [expr $Maxx*$Maxy]]
	set gaparea [round [expr $FParea-$bankarea]]
	if {$Gapout<=$gaparea} {
		set newfp $list
		} else {
			set Addarea [expr $Gapout-$gaparea]
			if {$shape=="L_shape"} {
				#puts "L"
				set newfp {}
				set newfp $list 
				#puts "NNNNNNN $newfp"
			}
			if {$shape=="U_shape"} {
				#puts "U"
				set newfp {}
				set dx [round [expr $Addarea/$Maxy]]
				#puts $dxn
				if {$xd>0} {
				set dxn [expr $dx/$xd]
					for {set i 0} {$i < $dxn} {incr i} {
						set multydx [round [expr $xd * $i]]
					}
					} else {
						set multydx $dx
					}
				puts "x delta $multydx" 
				
				set LL [lindex $flist 0]
				set newLX [extrX [lindex $flist 1] $multydx]
				#puts "$LL $newLX"
				set newfp [join [list $LL $newLX]]
			}	
			if {$shape=="C_shape"} {
				#puts "C"
				set newfp {}
				set dy [round [expr $Addarea/$Maxx]]	
				set LL [lindex $flist 1]
				#puts $dyn
				if {$yd>0} {
				set dyn [expr $dy/$yd]
					for {set i 0} {$i < $dyn} {incr i} {
						set multydy [round [expr $yd * $i]]
					}
					} else {
						set multydy $dy
					}
				puts "y delta $multydy"
				set newLY [extrY [lindex $flist 0] $multydy]
				#puts "$LL $newLY"
				set newfp [join [list $newLY $LL]]
			}
			if {$shape=="D_shape"} {
				#puts "D"
				set newfp {}
				################# Increase only dx (like a U shape) ########################
				set dx [round [expr $Addarea/$Maxy]]	
				set LL [lindex $flist 1]
				set LY [lindex $flist 0]
				#puts $dxn
				if {$xd>0} {
				set dxn [expr $dx/$xd]
					for {set i 0} {$i < $dxn} {incr i} {
						set multydx [round [expr $xd * $i]]
					}
					} else {
						set multydx $dx
					}
				set newLX [extrX [lindex $flist 2] $multydx]
				set newLXY [extrX [lindex $flist 3] $multydx]
				set newfp1 [join [list $LY $LL $newLX $newLXY]]		
				################## Increase only dy (like a C shape) #######################
				set dy [round [expr $Addarea/$Maxx]]	
				set LL [lindex $flist 1]
				set LX [lindex $flist 2]
				#puts $dyn
				if {$yd>0} {
				set dyn [expr $dy/$yd]
					for {set i 0} {$i < $dyn} {incr i} {
						set multydy [round [expr $yd * $i]]
					}
					} else {
						set multydy $dy
					}
				set newLY [extrY [lindex $flist 0] $multydy]
				set newLXY [extrY [lindex $flist 3] $multydy]
				set newfp2 [join [list $newLY $LL $LX $newLXY]]
				################## Increase dx & dy using coff kcoff #######################
				set x {}	
				set x [round [expr [expr [expr {sqrt ([expr 4*$Addarea*$kcoffdonat+($Maxy*$kcoffdonat+$Maxx)*($Maxy*$kcoffdonat+$Maxx)])}]-($Maxy*$kcoffdonat+$Maxx)]/2*$kcoffdonat]]     ;# hight
				set dx $x
				set dy [round [expr $x*$kcoffdonat]]
				set LL [lindex $flist 1]
				set newLX [extrX [lindex $flist 2] $dx]
				set newLXY0 [extrX [lindex $flist 3] $dx]    ;# middle used
				set newLY [extrY [lindex $flist 0] $dy]
				set newLXY [extrY $newLXY0 $dy]
				set newfp3 [join [list $newLY $LL $newLX $newLXY]]	
				######################################################################
				lappend newfp $newfp1 $newfp2 $newfp3
			}
	}
	return $newfp
}

proc MainGap bankcrdlist \
{
	set LL {}
	set LX {}
	set LY {}
	set LXY {}
	set M {}
	foreach i $bankcrdlist {
		if {[lindex $i 1 2]=="ll"} {
			lappend LL $i 
		}
		if {[lindex $i 1 2]=="lr"} {
			lappend LX $i 
		}
		if {[lindex $i 1 2]=="ul"} {
			lappend LY $i 
		}
		if {[lindex $i 1 2]=="ur"} {
			lappend LXY $i 
		}
	}
	lappend M $LL $LX $LY $LXY

	if {$LXY=={} && $LX=={} && $LY=={} && $LL!={}} {	  
		set ML [lindex $M 0]
		set newfp [Gapgen $bankcrdlist $ML "L_shape"]     
	}	
	if {$LXY=={} && $LY=={} && $LX!={} && $LL!={}} {	  
		set MX [list [lindex $M 0] [lindex $M 1]]
		set newfp [Gapgen $bankcrdlist $MX "U_shape"]     
	}
	if {$LXY=={} && $LX=={} && $LY!={} && $LL!={}} {	  
		set MY [list [lindex $M 2] [lindex $M 0]]
		set newfp [Gapgen $bankcrdlist $MY "C_shape"]     
		} elseif {$LXY!={} && $LX!={} && $LY!={} && $LL!={}} {														
			set MXY [list [lindex $M 2] [lindex $M 0] [lindex $M 1] [lindex $M 3]]
			set newfp [Gapgen $bankcrdlist $MXY "D_shape"]       
		}
	return $newfp

}     




