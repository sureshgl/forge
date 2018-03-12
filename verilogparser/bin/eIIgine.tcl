#!/usr/bin/env tclsh


proc banklist {list} \
{
    foreach types $list {
        foreach type $types {
            foreach bank $type {
                foreach wsp $bank {
                    foreach bsp $wsp {
                        lappend flatbanklist [lindex $bsp 0]
                    }
                }
            }
        }
    }
    return $flatbanklist
}

proc mmrlist {list} \
{
    foreach types $list {
        foreach type $types {
            foreach bank $type {
                foreach wsp $bank {
                    foreach bsp $wsp {
                        lappend typelist [lindex $bsp 1]
                    }
                 }
            }
        }
    }
    return [lsort -uniq $typelist]
}


proc findsize {list path} \
{	
	set n [llength $list]
	for {set i 0} {$i < $n} {incr i} {
		set bank [lindex $list $i]
		set lef1 "${path}/${bank}.lef"
		set file1 [open $lef1 r+]
		set file2 [read $file1]
		regexp {\s+SIZE\s+(\d*\.?\d+)\s+BY\s+(\d*\.?\d+)}  $file2 match x y
		set t "t[expr $i + 1]"
	set size "$t $x $y"
	lappend sizelist $size
    }
	return $sizelist
}


proc XN {N} \
{
	if {$N>12} { 
		for {set i 0} {$i < $N} {set i [expr $i + 4]} {
			set L $i	
		}
		set deltaN4n [expr $N - $L]
		set LdeltaN4n [list $L $deltaN4n]
		set Q $i 
		set deltaN4p [expr $N - $Q]
		set QdeltaN4p [list $Q $deltaN4p]
		} else {
			for {set i 0} {$i < $N} {set i [expr $i + 4]} {}
			set Q $i
			set deltaN4p [expr $N - $Q]
			set QdeltaN4p [list $Q $deltaN4p]
		}
	for {set i 0} {$i < $N} {set i [expr $i + 2]} {
	}
	set V $i
	set deltaN2 [expr $N - $V]
	set VdeltaN2 [list $V $deltaN2]
	set P [expr $V/2]
	set F [expr $Q/4] 
	set Nlist [list $F $P ]
	return $Nlist
}

proc linemtx {lN} \
{
	set x 1
	set y 1
	foreach var $lN {
		for {set k 1} {$k <= $var} {incr k} {
			set obj "[expr $k*$x] $y"
			lappend list $obj
			set list [lsort -unique $list]
		    set list [lsort -integer -index 0 $list]
		}
	lappend List $list
	}
	return $List
}
