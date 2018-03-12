#!/usr/bin/env tclsh

proc mirrowx list \
{
	set F [llength $list]
	set maxX [lindex [lsort -index 0 -integer $list] end]
	set n [lindex $maxX 0]
	foreach el $list {
		set x [lindex $el 0]
		set y [lindex $el 1]
		set X [expr ($n-$x)*2+$x+1]
		set Y $y
		set newel "$X $Y"
		set list1 [lsort -index 0  [lappend list1 $newel]] 
	}
	return $list1
}

proc mirrowy list \
{
	set F [llength $list]
	set maxY [lindex [lsort -index 1 -integer $list] end]
	set n [lindex $maxY 1]
	foreach el $list {
		set x [lindex $el 0]
		set y [lindex $el 1]
		set X $x
		set Y [expr ($n-$y)*2+$y+1]
		set newel "$X $Y"
		set list1 [lsort [lappend list1 $newel]] 
	}
	#puts "end $list1"
	return $list1
}

proc mirrowxy list \
{
	set maxX [lindex [lsort -index 0 -integer $list] end]
	set maxY [lindex [lsort -index 1 -integer $list] end]
	set nx [lindex $maxX 0]
	set ny [lindex $maxY 1]
	foreach el $list {
		set x [lindex $el 0]
		set y [lindex $el 1]
		set X [expr ($nx-$x)*2+$x+1]
		set Y [expr ($ny-$y)*2+$y+1]
		set newel "$X $Y"
		set list1 [lsort  -integer -index 0 -index 1 [lappend list1 $newel]] 
	}
	return $list1
}

proc mirrow list \
{
	mirrowx $list
	mirrowy $list
	mirrowxy $list
	set list [list $list [mirrowx $list] [mirrowy $list] [mirrowxy $list]]
	return $list
}


proc mirrowxx list \
{
	set maxX [lindex [lsort -index 0 -integer $list] end]
	set n [lindex $maxX 0]
	foreach el $list {
		set x [lindex $el 0]
		set y [lindex $el 1]
		set X [expr ($n-$x)*2+$x+1]
		set Y $y
		set newel "$X $Y"
		set list1 [lsort -index 0  [lappend list1 $newel]] 
	}
	#puts $list1
	return $list1
}

proc mirrowyy list \
{
	set maxY [lindex [lsort -index 1 -integer $list] end]
	set n [lindex $maxY 1]
	foreach el $list {
		set x [lindex $el 0]
		set y [lindex $el 1]
		set X $x
		set Y [expr ($n-$y)*2+$y+1]
		set newel "$X $Y"
		set list1 [lsort [lappend list1 $newel]] 
	}
	#puts $list1
	return $list1
}

proc mirrowx1 list \
{
	mirrowxx $list
	set list [list $list [mirrowxx $list]]
	#puts $list
	return $list
}

proc mirrowy1 list \
{
	mirrowyy $list
	set list [list $list [mirrowyy $list]]
	#puts $list
	return $list
}

proc List1glob list1 \
{
	set List1glob {}
	foreach listcoup $list1 {
		set maxorigy [lindex [lsort -integer -index 1 [lindex $listcoup 0]] end 1]
		set maxorl [lindex $listcoup 0]
		foreach listcoup $list1 {	
			set maxcreaty [lindex [lsort -integer -index 1 [lindex $listcoup 1]] end 1]
			set maxcrl [lindex $listcoup 1]
			set delta [expr [lindex [lsort -integer -index 0 $maxorl] end 0]- \
					[lindex [lsort -integer -index 0 [lindex $listcoup 1]] end 0]/2]
			set group {}
			for {set jj 0} {$jj < [llength [lindex $listcoup 1]]} {incr jj} {
				set changex [lindex [lindex $listcoup 1] $jj 0]	
				set changey [lindex [lindex $listcoup 1] $jj 1]   
				set newxx [expr $changex + $delta]
				set each [list $newxx $changey]
				lappend group $each
			}
			set maxcreatnew [lindex [lsort -integer -index 1 $group] end 1]
		  	if {$maxorigy==$maxcreatnew} {
				set newcoupp {}
				lappend newcoupp $maxorl $group
				lappend List1glob $newcoupp
			}
		}
	}                       
	return $List1glob
}


proc List2glob list2 \
{
	set List2glob {}
	foreach listcoup $list2 {
		set maxorigx [lindex [lsort -integer -index 0 [lindex $listcoup 0]] end 0]
		set maxorl [lindex $listcoup 0]
		foreach listcoup $list2 { 
			set maxcreatx [lindex [lsort -integer -index 0 [lindex $listcoup 1]] end 0]
			set maxcrl [lindex $listcoup 1]
			set delta [expr [lindex [lsort -integer -index 1 $maxorl] end 1]- \
   		 		[lindex [lsort -integer -index 1 [lindex $listcoup 1]] end 1]/2]  
			set group {}
			for {set jj 0} {$jj < [llength [lindex $listcoup 1]]} {incr jj} {
				set changex [lindex [lindex $listcoup 1] $jj 0]
				set changey [lindex [lindex $listcoup 1] $jj 1]
				set newyy [expr $changey + $delta]
				set each [list $changex $newyy]
				lappend group $each
			}
			set maxcreatnew [lindex [lsort -integer -index 0 $group] end 0]
			if {$maxorigx==$maxcreatnew} {
				set newcoupp {}
				lappend newcoupp $maxorl $group
				lappend List2glob $newcoupp
			}
		}
	}
	return $List2glob
}

proc List3glob list3 {
	set List1 {}
	set List2 {}
	foreach i $list3 {
		set g1 {}
		set g2 {}
		set orig [lindex $i 0]
		set x [lindex $i 1]
		set y [lindex $i 2]
		set g1 [list $orig $x]
		set g2 [list $orig $y]
 		lappend List1 $g1
		lappend List2 $g2
	}
	set List1sym $List1					;#only symmetric list (without any changes on half of donate design)	
	set List2sym $List2		
	set List1 [List1glob $List1]     	;# generated donates (half area).    for ex: we generat (all posible (ori && X), and must create their mirrors)
	set List2 [List2glob $List2]
	set List3glob {}
	for {set j 0} {$j < [llength $List1]} {incr j} {        ;#U shape 
		set n1 {}; set m1 {}; set m1mir {}; set n1mir {}		
		set m1 [lindex $List1 $j 0]    					  ;#orig
		set n1 [lindex $List1 $j 1]	;#mirrror X
		set m1mir [mirrowy $m1]		;# mirror Y	
		set n1mir [mirrowy $n1]		;# mirror XY
  		lappend List3glob [list $m1 $n1 $m1mir $n1mir]
	}
	for {set k 0} {$k < [llength $List2]} {incr k} {        ;#C shape 
		set n1 {}; set m1 {}; set m1mir {}; set n1mir {}
		set m1 [lindex $List2 $k 0]      ;#orig
		set n1 [lindex $List2 $k 1]     ;#mirrror Y
		set m1mir [mirrowx $m1]         ;# mirror X     
		set n1mir [mirrowx $n1]         ;# mirror XY
		lappend List3glob [list $m1 $m1mir $n1 $n1mir]
	}
    for {set j 0} {$j < [llength $List1sym]} {incr j} {        ;#U shape 
        set n1 {}; set m1 {}; set m1mir {}; set n1mir {}; set maxX {}
        set m1 [lindex $List1 $j 0]      ;#orig
        set n1 [lindex $List1 $j 1]     ;#mirrror X
		set maxX [lindex [lsort -integer -index 0 $n1] end 0]
		foreach jj $List1sym {	
    	set maxXnew {}
			set maxXnew [lindex [lsort -integer -index 0 [lindex $jj 1]] end 0]
			if {$maxX==$maxXnew} { 
			set m1mir [mirrowy [lindex $jj 0]]         ;# mirror Y     
    		set n1mir [mirrowy [lindex $jj 1]]         ;# mirror XY        	
		    lappend List3glob [list $m1 $n1 $m1mir $n1mir]
			}
		}
    }
        for {set k 0} {$k < [llength $List2sym]} {incr k} {        ;#C shape 
        	set n1 {}; set m1 {}; set m1mir {}; set n1mir {}; set maxY {}
            set m1 [lindex $List2 $k 0]      ;#orig
            set n1 [lindex $List2 $k 1]     ;#mirrror Y
			set maxY [lindex [lsort -integer -index 1 $n1] end 1]
	   		foreach kk $List2sym {
	   			set maxYnew {}
	   			set maxYnew [lindex [lsort -integer -index 1 [lindex $kk 1]] end 1]
	   			if {$maxY==$maxYnew} {
	                set m1mir [mirrowx [lindex $kk 0]]         ;# mirror X     
               		set n1mir [mirrowx [lindex $kk 1]]         ;# mirror XY
	   				lappend List3glob [list $m1 $m1mir $n1 $n1mir]
	   		}
		}
	}
	return $List3glob
}


proc float_gap list \
{
	global N
	if {$N%2==0 && $N%4>0} {	
		set LLT {}
		foreach var $list {
			set var3 {}
			set listva {}    
			set listvaa {}	 
			set listvv {}	 
			set listvvv {}	 
			set first1 [lrange [lsort -integer -index 0 [lindex $var 0]] 0 end-1]
			set GxGy   [lindex [lsort -integer -index 0 [lindex $var 0]]     end]	
			set first2 [lindex $var 1]
			set first3 [lindex $var 2]
			set first4 [lindex $var 3]
			lappend var3 $first1 $first2 $first3 $first4
			lappend LLT $var3
		} 
		set list $LLT
		} elseif {$N%2>0} { 
			set List111 {}
			foreach var $List1 {
				set first [lrange [lsort -integer -index 0 [lindex $var 0]] 0 end-1 ]			;#U shape
				set second [lindex $var 1]
				set var1 {}
				lappend var1 $first $second
				lappend List111 $var1
			}
			set List222 {}
			foreach var $List2 {
				set first [lrange [lsort -integer -index 1 [lindex $var 0]] 0 end-1 ]			;#C shape 
				set second [lindex $var 1]
				set var2 {}
				lappend var2 $first $second
				lappend List222 $var2
			}
			set List333 {}	
			if {$deltaN4p == -1} {
				foreach var $list {
					set first1 [lrange [lsort -integer -index 0 [lindex $var 0]] 0 end-1 ]
					set first2 [lindex $var 1]
					set first3 [lindex $var 2]
					set first4 [lindex $var 3]
					set var3 {}
					lappend var3 $first1 $first2 $first3 $first4
					lappend List333 $var3
                }
				} elseif {$deltaN4p == -3} {
					set List333 {}			
					foreach var $list {
						set listva {}     
						set listvaa {}    
						set listvv {}     
						set listvvv {}    
						set first1 [lrange [lsort -integer -index 0 [lindex $var 0]] 0 end-1 ]
                        set GxGy [lindex [lsort -integer -index 0 [lindex $var 0]] end]         ;# element which we decrice from 4*mirror (first original matrix)
                        set first2beg [lindex $var 1]
                        foreach va $first2beg {
							if {[lindex $GxGy 1]==[lindex $va 1]} {
								lappend listva $va
							}
						}
						set outel [lindex [lsort -integer -index 0 $listva] 0]
						foreach vaa $first2beg {
							if {$vaa!=$outel} {
								lappend listvaa $vaa
							}
						}
						set first2 $listvaa
                        set first3beg [lindex $var 2]
                        foreach vv $first3beg {
							if {[lindex $GxGy 0]==[lindex $vv 0]} {
								lappend listvv $vv
							}
						}
						set outelv [lindex [lsort -integer -index 1 $listvv] 0]
						foreach vv $first3beg {
							if {$vv!=$outelv} {
								lappend listvvv $vv
							}
						}
						set first3 $listvvv
                        set second [lindex $var 3]   
                        set var3 {}
                        lappend var3 $first1 $first2 $first3 $second
                        lappend List333 $var3
					}
				}
				set list $List333
				set List1 $List111
				set List2 $List222
			}
	return $list
}

proc Dondcr2 LList \
{					
	set LLT {}
	foreach var $LList {
		set var3 {}
		set listva {} 
		set listvaa {}
		set listvv {} 
		set listvvv {} 
		set first1 [lrange [lsort -integer -index 0 [lindex $var 0]] 0 end-1 ]
		set GxGy [lindex [lsort -integer -index 0 [lindex $var 0]] end]
		set first2beg [lindex $var 1]
		foreach va $first2beg {
        	if {[lindex $GxGy 1]==[lindex $va 1]} {
				lappend listva $va
			}
		}
		set outel [lindex [lsort -integer -index 0 $listva] 0]
		foreach vaa $first2beg {
			if {$vaa!=$outel} {
				lappend listvaa $vaa
			}
		}
		set first2 $listvaa
		set first3 [lindex $var 2]
		set first4 [lindex $var 3]
		lappend var3 $first1 $first2 $first3 $first4
		lappend LLT $var3
	}
	return $LLT
}


proc Udcr1 List1 \
{
	set List111 {}
	foreach var $List1 {
		set first [lrange [lsort -integer -index 0 [lindex $var 0]] 0 end-1 ]
		set second [lindex $var 1]
		set var1 {}
		lappend var1 $first $second
		lappend List111 $var1
	}
	return $List111
}


proc Cdcr1 List2 \
{
	set List222 {}
	foreach var $List2 {
		set first [lrange [lsort -integer -index 1 [lindex $var 0]] 0 end-1 ] 
		set second [lindex $var 1]
		set var2 {}
		lappend var2 $first $second
		lappend List222 $var2
	}
	return $List222
}


proc Dondcr3or1 {LList delta} \
{
	set List333 {}
	if {$delta == -1} {
		foreach var $LList {
			set first1 [lrange [lsort -integer -index 0 [lindex $var 0]] 0 end-1 ]
			set first2 [lindex $var 1]
			set first3 [lindex $var 2]
			set first4 [lindex $var 3]
			set var3 {}
			lappend var3 $first1 $first2 $first3 $first4
			lappend List333 $var3
		}
		} elseif {$delta == -3} {
			set List333 {}
			foreach var $LList {
				set listva {}     		;#small list which help you decrice the mirror/4 lists
				set listvaa {}          ;#
				set listvv {}           ;#
				set listvvv {}          ;#
				set first1 [lrange [lsort -integer -index 0 [lindex $var 0]] 0 end-1 ]
				set GxGy [lindex [lsort -integer -index 0 [lindex $var 0]] end]         ;# element which we decrice from 4*mirror (first original matrix)
				set first2beg [lindex $var 1]
				foreach va $first2beg {
					if {[lindex $GxGy 1]==[lindex $va 1]} {
						lappend listva $va
					}
				}
				set outel [lindex [lsort -integer -index 0 $listva] 0]
				foreach vaa $first2beg {
					if {$vaa!=$outel} {
						lappend listvaa $vaa
					}
				}
				set first2 $listvaa
				set first3beg [lindex $var 2]
				foreach vv $first3beg {
					if {[lindex $GxGy 0]==[lindex $vv 0]} {
						lappend listvv $vv
					}
				}
				set outelv [lindex [lsort -integer -index 1 $listvv] 0]
				foreach vv $first3beg {
					if {$vv!=$outelv} {
						lappend listvvv $vv
					}
				}
				set first3 $listvvv
				set second [lindex $var 3]   ;# we woldn't change the last ellement of 4*mirroring
				set var3 {}
				lappend var3 $first1 $first2 $first3 $second
				lappend List333 $var3
			}
		}
	return $List333
}
