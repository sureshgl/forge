#!/usr/bin/env tclsh


proc lsum L {round [expr [join $L +]+0]}


proc xy {list} \
{
	set xlist {}
	set ylist {}
	foreach var $list {
		set minx [lindex [lsort -uniq -real [lappend xlist [lindex $var 1 0] [lindex $var 2 0]]] 0]
		set miny [lindex [lsort -uniq -real [lappend ylist [lindex $var 1 1] [lindex $var 2 1]]] 0]
		set maxx [lindex [lsort -uniq -real [lappend xlist [lindex $var 1 0] [lindex $var 2 0]]] end]
		set maxy [lindex [lsort -uniq -real [lappend ylist [lindex $var 1 1] [lindex $var 2 1]]] end]
	}
	#puts "$minx $miny ------ $maxx $maxy"
	#set x [round [expr $maxx - $minx]]
	#set y [round [expr $maxy - $miny]]
	set xy "$maxx $maxy"
	return $xy

}

proc ratio {list} \
{
	set x [lindex [xy $list] 0]
	set y [lindex [xy $list] 1]
	if {$x>$y} {
		set R [round [expr $x/$y]]
		} elseif {$y>$x} {
			set R [round [expr $y/$x]]
		}
		return $R
}

proc area {list} \
{
	set x [lindex [xy $list] 0]
	set y [lindex [xy $list] 1]
	set A [round [expr $x * $y]]
	return $A
}


proc macroarea {list} \
{
	foreach bank $list {
		set banklist [list $bank]
		set bankarea [area $banklist]
		lappend bankarealist $bankarea
	}
	set totalbankarea [lsum $bankarealist]
	return $totalbankarea
}

proc freespace {list} \
{
	set MA [macroarea $list]
	set FA [area $list]
	set FS [round [expr $FA - $MA]]
	return $FS
}

proc property {list} \
{
	set R [ratio $list]
	set A [area $list]
	set FS [freespace $list]
	set properties "$R $A $FS"
	return $properties
}

proc addproperty {list} \
{
	set properties [property $list]
	set ptbnkcrdbb [list $properties $list]
	return $ptbnkcrdbb
}

proc rmproperty {list} \
{
	set bnkcrdbb [join [lrange $list 1 end]]
	return $bnkcrdbb
}





