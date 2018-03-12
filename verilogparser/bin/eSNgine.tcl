#!/usr/bin/env tclsh

proc round {expr} \
{
	set value [expr {abs(double(round(1000*($expr))))/1000}]
	return $value
}

proc genorigsimple list \
{
	set listy {} ; set listx {} ; set LIST {}
	foreach var $list {
		if {[lindex $var 0]==1} {
			set listy [lappend listy $var]
		}
		if {[lindex $var 1]==1} {
			set listx [lappend listx $var]
		}
	}
	set listX [lsort -integer -index 0 [lreplace $listx 0 0]] 	
	set listY [lsort -integer -index 1 -decreasing $listy] 
	set LIST [concat $listY $listX]
	set maxY [lindex [lsort -integer -index 1 $LIST] end end]
	set New {}	
	foreach x $LIST {
		set new {}
		for {set i 0} {$i < $maxY} {incr i} {
			set el "[expr [lindex $x 0]+$i] [expr [lindex $x 1]+$i]"	
			set find [lsearch -exact $list $el]
			if {$find!=-1} {
				lappend new $el		
			}
		}
		lappend New $new
	}	
	set M {}
	for {set i 1} {$i <= [llength $New]} {set i [expr {$i + 2}]} {
		set ori [concat [lindex $New [expr  $i-1]]]
		set rep [concat [lsort -integer -index 1 -decreasing [lindex $New  $i]]]
		set 111 [lappend M $ori $rep]
	}
	set NN {}
	for {set j 0} {$j < [llength $111]} {incr j} {
		foreach k [lindex $111 $j] {
			lappend k "ll"
			lappend NN $k 
		}
	}
	return $NN
}

proc genXsimple list \
{
	set listy {} ; set listx {} ; set LIST {}			
	set maxx [lindex [lsort -integer -index 0 $list] end 0]	
	foreach var $list {
		if {[lindex $var 0]==$maxx} {
			set listy [lappend listy $var]
		}
		if {[lindex $var 1]==1} {
			set listx [lappend listx $var]
		}
	}
	set listX [lsort -integer -index 0 $listx]  
	set listY [lreplace [lsort -integer -index 1 $listy] 0 0] 
	set LIST [concat $listX $listY]
	set maxY [lindex [lsort -integer -index 1 $LIST] end end]
	set New {}
	foreach x $LIST {
		set new {}
		for {set i 0} {$i < $maxY} {incr i} {
			set el "[expr [lindex $x 0]-$i] [expr [lindex $x 1]+$i]"	
			set find [lsearch -exact $list $el]
			if {$find!=-1} {
				lappend new $el		
			}
		}
		lappend New $new
	}	
	set M {}
	for {set i 1} {$i <= [llength $New]} {set i [expr {$i + 2}]} {
		set ori [concat [lindex $New  [expr $i-1]]]
		set rep [concat [lsort -integer -index 1 -decreasing [lindex $New  $i]]]
		set 111 [lappend M $ori $rep]
	}
	set NN {}
	for {set j 0} {$j < [llength $111]} {incr j} {
		foreach k [lindex $111 $j] {
			lappend k "lr"	
			lappend NN $k
		}
	}
	return $NN
}


proc genYsimple list \
{
	set listy {} ; set listx {} ; set LIST {}
	set maxy [lindex [lsort -integer -index 1 $list] end 1]
	foreach var $list {
		if {[lindex $var 0]==1} {
			set listy [lappend listy $var]
		}
		if {[lindex $var 1]==$maxy} {
			set listx [lappend listx $var]
		}
	}
	set listX [lreplace [lsort -integer -index 0 -decreasing $listx] end end]  	;#bottom banks only
	set listY [lsort -integer -index 1 -decreasing $listy] 		 ;#left banks only
	set LIST [concat $listX $listY]
	set minY [lindex [lsort -integer -index 1 $LIST] 0 1]
	set New {}
	foreach x $LIST {
		set new {}
		for {set i 0} {$i < $minY} {incr i} {
			set el "[expr [lindex $x 0]+$i] [expr [lindex $x 1]-$i]"	
			set find [lsearch -exact $list $el]
			if {$find!=-1} {
				lappend new $el		
			}
		}
		lappend New $new
	}
	set M {}
	for {set i 1} {$i <= [llength $New]} {set i [expr {$i + 2}]} {
		set ori [concat [lindex $New [expr  $i-1]]]
		set rep [concat [lsort -integer -index 1 [lindex $New  $i]]]
		set 111 [lappend M $ori $rep]
	}
	set NN {}
	for {set j 0} {$j < [llength $111]} {incr j} {
		foreach k [lindex $111 $j] {
			lappend k "ul"
			lappend NN $k
		}
	}
	return $NN
}

proc genXYsimple list \
{
	set listy {} ; set listx {} ;set LIST {}
	set maxy [lindex [lsort -integer -index 1 $list] end 1]	;#the greates y from list 
	set maxx [lindex [lsort -integer -index 0 $list] end 0] ;#the greates x from list 
	foreach var $list {
		if {[lindex $var 0]==$maxx} {
			set listy [lappend listy $var]
		}
		if {[lindex $var 1]==$maxy} {
			set listx [lappend listx $var]
		}
	}
	set listX [lsort -integer -index 0 -decreasing $listx]   	;#bottom banks only
	set listY [lreplace [lsort -integer -index 1 $listy] end end] 		 ;#left banks only
	set LIST [concat $listY $listX]
	set minY [lindex [lsort -integer -index 1 $LIST] 0 1]
	set New {}
	foreach x $LIST {
		set new {}
		for {set i 0} {$i < $minY} {incr i} {
			set el "[expr [lindex $x 0]-$i] [expr [lindex $x 1]-$i]"	
			set find [lsearch -exact $list $el]
			if {$find!=-1} {
				lappend new $el		
			}
		}
		lappend New $new
	}	
	set M {}
	for {set i 1} {$i <= [llength $New]} {set i [expr {$i + 2}]} {
		set ori [concat [lindex $New  [expr $i-1]]]
		set rep [concat [lsort -integer -index 1  [lindex $New  $i]]]
		set 111 [lappend M $ori $rep]
	}
	set NN {}
	for {set j 0} {$j < [llength $111]} {incr j} {
		foreach k [lindex $111 $j] {
			lappend k "ur"
			lappend NN $k
		}
	}
	return $NN
}

proc Hirdistsimp listet {
	set All {}
	foreach i $listet {
		set iii {}
		set iii [join $i]
		lappend All $iii
	}
	return $All
}

proc easycalculate {list1 e f} \
{
	set Newlist {}
	foreach el $list1 {
		set newel {}
		if {[lindex $el 2]=="ll"} {
			set newel {}
			set x [expr [lindex $el 0] * $e -$e]
			set y [expr [lindex $el 1] * $f -$f]
			if {$x!=0.0} {
				set x [round $x]
			}
			if {$y!=0.0} {
				set y [round $y]
			}
			set newel "$x $y [lindex $el 2]"
			lappend Newlist $newel
			} elseif {[lindex $el 2]=="lr"} { 
				set newel {}
				set x [expr [lindex $el 0] * $e]
				set y [expr [lindex $el 1] * $f -$f]
				if {$x!=0.0} {
					set x [round $x]
				}
				if {$y!=0.0} {
					set y [round $y]
				}                        
				set newel "$x $y [lindex $el 2]"
				lappend Newlist $newel
				} elseif {[lindex $el 2]=="ul"} {
					set newel {}
					set x [expr [lindex $el 0] * $e -$e]
					set y [expr [lindex $el 1] * $f]
					if {$x!=0.0} {
						set x [round $x]
					}
					if {$y!=0.0} {
						set y [round $y]
					}                        
					set newel "$x $y [lindex $el 2]"
					lappend Newlist $newel
					} elseif {[lindex $el 2]=="ur"} {
						set newel {}
						set x [expr [lindex $el 0] * $e]
						set y [expr [lindex $el 1] * $f]
						if {$x!=0.0} {
							set x [round $x]
						}
						if {$y!=0.0} {
							set y [round $y]
						}                        
						set newel [list $x $y [lindex $el 2]]
						lappend Newlist $newel
					}
				}
				return $Newlist
}


proc easybkadd {banklist list1} \
{
	set New {}
	for {set i 0} {$i < [llength $list1]} {incr i} {
		set et {}
		set et [list [lindex $banklist $i] [lindex $list1 $i]]
		lappend New $et
	}
	return $New
}

proc easybbox {bkcrd e f} \
{
	set New {}
	for {set i 0} {$i < [llength $bkcrd]} {incr i} {
		if {[lindex $bkcrd $i 1 2]=="ll"} {
		set et {}     	
		set etbbx [round [expr [lindex $bkcrd $i 1 0] +$e]]
		set etbby [round [expr [lindex $bkcrd $i 1 1] +$f]]
		set et [list [lindex $bkcrd $i 0] [lindex $bkcrd $i 1] [list $etbbx $etbby]]
	}
	if {[lindex $bkcrd $i 1 2]=="lr"} {
		set et {}
		set etbbx [round [expr [lindex $bkcrd $i 1 0] -$e]]
		set etbby [round [expr [lindex $bkcrd $i 1 1] +$f]]
		set et [list [lindex $bkcrd $i 0] [lindex $bkcrd $i 1] [list $etbbx $etbby]]
	}
	if {[lindex $bkcrd $i 1 2]=="ul"} {
		set et {}
		set etbbx [round [expr [lindex $bkcrd $i 1 0] +$e]]
		set etbby [round [expr [lindex $bkcrd $i 1 1] -$f]]
		set et [list [lindex $bkcrd $i 0] [lindex $bkcrd $i 1] [list $etbbx $etbby]]
	}
	if {[lindex $bkcrd $i 1 2]=="ur"} {
		set et {}
		set etbbx [round [expr [lindex $bkcrd $i 1 0] -$e]]
		set etbby [round [expr [lindex $bkcrd $i 1 1] -$f]]
		set et [list [lindex $bkcrd $i 0] [lindex $bkcrd $i 1] [list $etbbx $etbby]]
	}
	lappend New $et
	}
	return $New
}

proc finaladd {banks List e f} \
{
	set FP {}
	foreach i $List {
		set list1 [easycalculate $i $e $f]          ;# work only with same size banks on one FP     (e,f banks physical sizes)
		set bkcrd [easybkadd $banks $list1]       	;# bankname add into list 		( working on one FP list)
		set bboxbkcrd [easybbox $bkcrd $e $f]       ;# Added bbox on existed bankcrdlist   (working on one FP list )
		lappend FP $bboxbkcrd
	}
	return $FP
}
