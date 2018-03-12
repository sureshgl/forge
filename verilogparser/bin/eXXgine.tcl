#!/usr/bin/env tclsh


proc func0 {list R} {
	#global R
    set Xp0 1
    set sortlist [lsort -index 1 -integer $list]
    #puts $sortlist
    set n [llength $sortlist]
    #puts $n
    set el [lindex $sortlist [expr $n -1]]
    #puts $el
    set Yp0 [expr [lindex $el 1] +1]
    #puts $Yp0
    set newel0 "$Xp0 $Yp0"
	#puts $newel0
    set list1 [linsert $list [expr $R-1] $newel0 ]
    return $list1
}
#############################
proc func1 {list R} {
	#global R
	
	set sortlist [lsort -index 1 -integer $list] 
    set n [llength $sortlist]   
	set el [lindex $sortlist [expr $n-1]]
	#puts $el
    set Xp1 [expr [lindex $el 0] +1]
		#puts $Xp1
    set Yp1 [lindex $el 1]
		#puts $Yp1
	set newel1 "$Xp1 $Yp1"	
	set list2 [linsert $list [expr $R-1] $newel1]	
		
  ###############################  
	set newlist {}
	set newL {}
	
	set maxY [lindex $el 1]
	#puts "real $maxY"
		if {$maxY >= 2} {
			set maxYL [expr $maxY -1]   ;# max element , for second element in group
			#puts "down $maxYL"
		} else {
			set maxYL 1	
			#puts "down $maxYL"
		}
			
		foreach element $list2 {
			#puts $element
			if {$maxY==[lindex $element 1]} {
			lappend newlist $element  	 ;#in newlist are elements {maxX *}
				}
			if {$maxYL==[lindex $element 1]} {
			lappend newL $element   	;#porcnakan naxaverji elementneri hamar
				}	
				
		
		}
		set newlist [lsort -integer -index 1 $newlist ]
			#puts "newlist $newlist"
		set newL [lsort -integer -index 1 $newL ]
			#puts "newL $newL"
		
	set L [llength $newlist]
	set lL [llength $newL]
	
	if {$lL >= $L} {
	    set list1 $list2
		} else {
			set List {}
			set x 1
			set y 1	
			for { set k 1} {$k <= $R} {incr k} {
				set obj "[expr $k*$x] $y"
				lappend List $obj
			}
			#puts $List
			set list1 $List							
	}
	return $list1
}

proc func3 {list R} {
	#global R
	set newList {}
    foreach l $list {
		set l [lsort -index 0 -integer $l]
		set l [lrange $l 0 [expr $R -2]]
		lappend newList [func0 $l $R];
		lappend newList [func1 $l $R];
	}
	return $newList
}

proc runX list \
{
	set R [llength $list]
	set list [lrange $list 0 end-1]
	set i 0
	set newList [list $list]
	while {$i < $R-1} {
	    set newList [func3 $newList $R]
		#puts $newList
		incr i
	}
	set finallist [lsort -unique $newList]
	#puts "\nXXXX gine output \n$finallist\n############\n"
	return $finallist
}

