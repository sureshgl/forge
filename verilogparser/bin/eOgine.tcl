#!/usr/bin/env tclsh

#set path "/Users/harutyan/Desktop"
#set path "$path/FP"

proc create_floorplan {list file kxy} \
{
    set kx [lindex $kxy 0]
    set ky [lindex $kxy 1]
	set maxXlist {}
    set maxYlist {}
	foreach var $list {
		set maxx {}
		set maxy {}
		set maxx [lindex [lsort -uniq -real [lappend maxXlist	[lindex $var 1 0] [lindex $var 2 0]]] end]
		set maxy [lindex [lsort -uniq -real [lappend maxYlist	[lindex $var 1 1] [lindex $var 2 1]]] end]
	}
    set maxX [round [expr $maxx + 2*$kx]]
    set maxY [round [expr $maxy + 2*$ky]]
	set crtfp "create_floorplan -control_type width_and_height -core_width $maxX -core_height $maxY"
	puts $file $crtfp
    puts "selected floorplan have following physical parameters\ndie size $maxX x $maxY\ndie area [round [expr $maxX*$maxY]] um^2"
   # die area size $maxX x $maxY\ndie area [round [expr $maxX*$maxY]] um^2"
}


proc place_cell {list file xyd kxy} \
{	
    set kx [lindex $kxy 0]
    set ky [lindex $kxy 1]
	set xd [lindex $xyd 0]
	set yd [lindex $xyd 1]
	foreach el $list {
		set ulxlst {}
		set ulylst {}
		set llxlst {}
		set llylst {}
		set lrxlst {}
		set lrylst {}
		set urxlst {}
		set urylst {}	
		if {[lindex $el 1 2]=="ll"} {
			set minx [round [expr $kx + [lindex [lsort -real [lappend llxlst [lindex $el 2 0] [lindex $el 1 0]]] 0] - $xd]]
			set miny [round [expr $ky + [lindex [lsort -real [lappend llylst [lindex $el 2 1] [lindex $el 1 1]]] 0]]]
			set maxx [round [expr $kx + [lindex [lsort -real [lappend llxlst [lindex $el 2 0] [lindex $el 1 0]]] end] - $xd]]
			set maxy [round [expr $ky + [lindex [lsort -real [lappend llylst [lindex $el 2 1] [lindex $el 1 1]]] end]]]
			set bankname [lindex $el 0]
			puts $file "set_attribute $bankname origin \{$maxx $miny\};"
			puts $file "set_attribute $bankname orientation FN;"
			puts $file "set_attribute $bankname is_fixed true;"
			puts $file "create_placement_blockage -coordinate \{\{$minx $miny\} \{$maxx $maxy\}\} \
												  -name soft_blk_${bankname} \
												  -type partial \
												  -blocked_percentage 0 \
												  -buffer_only;"
			} elseif {[lindex $el 1 2]=="lr"} {
			    set minx [round [expr $kx + [lindex [lsort -real [lappend llxlst [lindex $el 2 0] [lindex $el 1 0]]] 0] + $xd]]
			    set miny [round [expr $ky + [lindex [lsort -real [lappend llylst [lindex $el 2 1] [lindex $el 1 1]]] 0]]]
			    set maxx [round [expr $kx + [lindex [lsort -real [lappend llxlst [lindex $el 2 0] [lindex $el 1 0]]] end] + $xd]]
			    set maxy [round [expr $ky + [lindex [lsort -real [lappend llylst [lindex $el 2 1] [lindex $el 1 1]]] end]]]
                set bankname [lindex $el 0]
				puts $file "set_attribute $bankname origin \{$minx $miny\};"
				puts $file "set_attribute $bankname orientation N;"
				puts $file "set_attribute $bankname is_fixed true;"
				puts $file "create_placement_blockage -coordinate \{\{$minx $miny\} \{$maxx $maxy\}\} \
													  -name soft_blk_${bankname} \
													  -type partial \
													  -blocked_percentage 0 \
													  -buffer_only;"
				} elseif {[lindex $el 1 2]=="ur"} {
			        set minx [round [expr $kx + [lindex [lsort -real [lappend llxlst [lindex $el 2 0] [lindex $el 1 0]]] 0] + $xd]]
			        set miny [round [expr $ky + [lindex [lsort -real [lappend llylst [lindex $el 2 1] [lindex $el 1 1]]] 0]]]
			        set maxx [round [expr $kx + [lindex [lsort -real [lappend llxlst [lindex $el 2 0] [lindex $el 1 0]]] end] + $xd]]
			        set maxy [round [expr $ky + [lindex [lsort -real [lappend llylst [lindex $el 2 1] [lindex $el 1 1]]] end]]]
					set bankname [lindex $el 0]
					puts $file "set_attribute $bankname origin \{$minx $maxy\};"
					puts $file "set_attribute $bankname orientation FS;"
					puts $file "set_attribute $bankname is_fixed true;"
					puts $file "create_placement_blockage -coordinate \{\{$minx $miny\} \{$maxx $maxy\}\} \
														  -name soft_blk_${bankname} \
														  -type partial \
														  -blocked_percentage 0 \
														  -buffer_only;"
					} elseif {[lindex $el 1 2]=="ul"} {
			            set minx [round [expr $kx + [lindex [lsort -real [lappend llxlst [lindex $el 2 0] [lindex $el 1 0]]] 0] - $xd]]
			            set miny [round [expr $ky + [lindex [lsort -real [lappend llylst [lindex $el 2 1] [lindex $el 1 1]]] 0]]]
			            set maxx [round [expr $kx + [lindex [lsort -real [lappend llxlst [lindex $el 2 0] [lindex $el 1 0]]] end] - $xd]]
			            set maxy [round [expr $ky + [lindex [lsort -real [lappend llylst [lindex $el 2 1] [lindex $el 1 1]]] end]]]
						set bankname [lindex $el 0]
						puts $file "set_attribute $bankname origin \{$maxx $maxy\};"
						puts $file "set_attribute $bankname orientation S;"
						puts $file "set_attribute $bankname is_fixed true;"
						puts $file "create_placement_blockage -coordinate \{\{$minx $miny\} \{$maxx $maxy\}\} \
															  -name soft_blk_${bankname} \
															  -type partial \
															  -blocked_percentage 0 \
															  -buffer_only;"
					}
					
	}
}

proc create_pin_blockage {list file} \
{
	foreach var $list {
		set i [lsearch $list $var]
		puts $file "create_placement_blockage -coordinate \{$var\} -name pin_blockage_$i -no_pin"
	}
}



