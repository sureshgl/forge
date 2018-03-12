#!/usr/bin/env tclsh
puts "current TCL version $tcl_version"
##########################################
########## specifying switches ###########
##########################################
set symmetry 	true
set bsp 		false
set wsp 		false
set unisize		true
set unitype 	true
#set tech		16nm
##########################################
########## specifying paths    ###########
##########################################
#set design_name  "memoir_1r1w_b10_24Kx64"
set curdir "[pwd]"
set path "/auto/memoir-proj01/harut/perfroce/runs/3.3.11225M/verilogparser/bin"
#puts $path
foreach arg $::argv {set name $arg}
source "$curdir/tcl/${name}_pd_setup.tcl";
#set rtl "../rtl/${design_name}.v"
set algolist "1R1RW_B35 1R1W_B10 1RU_B2 1RW_B1 2R2W_B50 2ROR1W_B20 2RW_B40 3ROR1W_b60 4ROR1W_B70 1R1RW_B37 1R2W_B90 1RW1W_B30 2R1W_B80 2ROR1W_B120 2RU_B41 3R1W_B100 4R1W_B110"

if {[lsearch $algolist $algo_name]>=0} {
} else {
    puts "$algo_name not supported yet" 
    exit
}
#########################################
exec /usr/bin/csh -c "$path/memcomp.csh $name" >@stdout 2>@stderr
############ sourcinc engine #############
##########################################
source "$path/eRgine.tcl" ;
source "$path/eSNgine.tcl";
source "$path/eGIgine.tcl";
source "$path/eIIgine.tcl";
source "$path/eZgine.tcl";
source "$path/eXXgine.tcl";
source "$path/eGSgine.tcl";
source "$path/eDFgine.tcl";
source "$path/ePBgine.tcl";
source "$path/eOgine.tcl";
#source "fp.tcl";
##########################################
############ sourcinc engine #############
##########################################
#puts $banks
if {$tech=="16nm" || $tech=="16nm_od"} {
	set xd 2.88
    #set xd 0
	set yd 0
	set ky 1.152
	set kx 1.44
    puts "technology 16nm_od"
	} else {
		set xd 4.4
		set yd 0
		set ky 2.2
		set kx 2.2
	}
set kxy "$kx $ky"
set xyd "$xd $yd"
set banktlist [mmrlist $banks ]
#puts $banktlist
set flatbanks [banklist $banks]
#puts $flatbanks
set N [llength $flatbanks]
puts "$N Physical memory banks detected"
foreach mmr $banktlist {
    set memhome "${mmr}"
    set initsize [findsize $mmr $memhome]
    #puts [lindex $initsize 0]
    set newx [round [expr [lindex $initsize 0 1] + $xd]]
    set newy [round [expr [lindex $initsize 0 2] + $yd]]
    set size "\{[lindex $initsize 0 0] $newx $newy\}"
    #puts $sizelist
    lappend sizelst $size
}

set sizelist [join $sizelst] 
#puts $sizelist
set List [linemtx [XN $N]]
#puts $List
#puts $N
##########################################
############ sourcinc engine #############
##########################################
puts "creating matrix views of floorplans..."
foreach xlist $List {
	set list [runX $xlist]
	lappend LIST $list
}

#puts $LIST
##########################################
############ sourcinc engine #############
##########################################


set List1 {}
set List2 {}
set LList {}

if {$symmetry=="true"} {
	set list [lindex $LIST 0]  
	set listP [lindex $LIST 1] 
	set listF [lindex $LIST 2] 
	if {$N>=24} {
		foreach list $list {
		lappend LList [mirrow $list]
		set weight "100000 0.02 0.2"
		}
			} elseif {$N<24} {
		foreach list $listP {
		    lappend List1 [mirrowx1 $list]
		    lappend List2 [mirrowy1 $list]
			set weight "10000 2 0.02"
		}
	}
	
	
	if {$N%2==0 && $N%4>0} {				
		set LList [Dondcr2 $LList]	
	}
	if {$N%2>0} { 
		set List1 [Udcr1 $List1]
		set List2 [Cdcr1 $List2]
		set LList [Dondcr3or1 $LList $deltaN4p]
	}
	
	puts "matrix views are created"
	} elseif {$symmetry=="false"} {
		set list [lindex $LIST 0]  
		set listP [lindex $LIST 1] 
		set listF [lindex $LIST 2] 
		if {$N>=32} {
			foreach list $list {
			lappend LList [mirrow $list]
			set weight "100000 0.02 0.2"
			}
			set LList [List3glob $LList]
		} elseif {$N<32} {
			set weight "10000 2 0.02"
		foreach list $listP {
		    lappend List1 [mirrowx1 $list]
		    lappend List2 [mirrowy1 $list]
		}
		set List1 [List1glob $List1]
		set List2 [List2glob $List2]
	}
		if {$N%2==0 && $N%4>0} {				
			set LList [Dondcr2 $LList]	
		}
		if {$N%2>0} { 
			set List1 [Udcr1 $List1]
			set List2 [Cdcr1 $List2]
			set LList [Dondcr3or1 $LList $deltaN4p]
		}
	puts "matrix views are created"
	}

#puts $List
    
    
    ##########################################
############## snake engine ##############
##########################################
# puts $List1 
puts "inserting real sizes to the matrixes"
puts "ordering banks in the list"
if {$unisize=="true"} {
	if {$unitype=="true"} {
		set LISTf {}
		foreach var $listF {
			set m [genorigsimple $var]
			lappend LISTf $m
		}
		set listF $LISTf
		set lIST1 {}
		foreach varr $List1 {
			lappend lIST1 [list [genorigsimple [lindex $varr 0]] \
								[genXsimple [lindex $varr 1]]]
		}
		set List1 [Hirdistsimp $lIST1]
		set lIST2 {}
		foreach varrr $List2 {
			lappend lIST2 [list [genYsimple [lindex $varrr 1]] \
								[genorigsimple [lindex $varrr 0]]]
		}
		set List2 [Hirdistsimp $lIST2]
		set llIST {}
		
		foreach varrrr $LList {
			lappend llIST [list [genYsimple [lindex $varrrr 2]] \
								[genorigsimple [lindex $varrrr 0]] \
								[genXsimple [lindex $varrrr 1]] \
								[genXYsimple [lindex $varrrr 3]]]
		}
		set LList [Hirdistsimp $llIST]
		set List [lsort -unique [join [list $listF $List1 $List2 $LList]]]
		set bankcrdlist [finaladd $flatbanks $List [lindex $sizelist 0 1] [lindex $sizelist 0 2]]
	}
}

#puts "\n###########\n[lindex $bankcrdlist 2]\n###########\n"
##########################################
############ sourcinc engine #############
##########################################
puts "calculating minimum required gap area"
set Gapout [minimum_gap_area $N $sizelist]
#puts $Gapout
set List {}
set List $bankcrdlist	;# output of this gine must have same view like a eSQgine output
set bankcrdlist {}

foreach crd  $List {
    set listgap [MainGap $crd]          ;#use for bsp-es (calculate0); (proc calculate) used only for simple snake 
	if {[llength $listgap]==3} {
		foreach lg $listgap {
			lappend bankcrdlist $lg
		}
		} else {
        	lappend bankcrdlist $listgap
	}
}

#puts "\n###########\n[lindex $bankcrdlist 2]\n###########\n"

##########################################
############ sourcinc engine #############
##########################################


#foreach var $bankcrdlist {
#	puts $var
#	set maxlist [find_maxx_maxy $var]
#	set minedge [final_minedge $var]
#	puts "\n####################\n${minedge}\n########"
#}



##########################################
############ sourcinc engine #############
##########################################
#source "$path/eSgine.tcl"


#    set properties "$R $A $FS"
puts "selecting floorplan"

foreach fp $bankcrdlist {
	set ptbankcrd [addproperty $fp]
	set ptbankcrdlist [lsort -uniq -index {1} [lsort -uniq -index {0} [lappend ptbankcrdlst $ptbankcrd]]]
	set property [property $fp]
	lappend propertylist $property
}



set m 0

#puts $propertylist
#puts "\n########\n[lindex $ptbankcrdlist 0]\n########\n"
#puts "\n########\n[lindex $ptbankcrdlist 8]\n########\n"
#puts $bestfp


foreach property $propertylist {
	set RW  [round [expr [lindex $weight 0]*[lindex $property 0]]]
	set AW  [round [expr [lindex $weight 1]*[lindex $property 1]]]
	set FSW [round [expr [lindex $weight 2]*[lindex $property 2]]]
	set sum [round [expr $RW + $AW + $FSW]]
	set sumlist [lsort -real -index {0} [lappend sumlst "\{$sum\} \{$property\}"]]
	set best [lindex $sumlist $m]	
}


set list [lindex [lsearch -inline -index 0 $ptbankcrdlist [lindex $best 1]] 1]
#puts $list
##########################################
############ sourcinc engine #############
##########################################
puts "finding IO port placement area"
#source "$path/eOgine.tcl"
set maxlist [find_maxx_maxy $list]
set minedge [final_minedge $list]
#puts $list
#puts $minedged
#set bankbblist [bank_bbox $list]
#set range [find_range $list]
#puts $range
set blk_bbox [blockage_bbox $list]
#puts $blk_bbox


############# writing placement file ########
puts "writing placement file"
set output [open "$curdir/$design_name.fp.tcl" w]

create_floorplan $list $output $kxy
place_cell $list $output $xyd $kxy
create_pin_blockage $blk_bbox $output
puts $output "set_keepout_margin -outer {0.72 0.72 0.72 0.72} -all_macros"
puts $output "place_fp_pin -block_level"
close $output
puts "placement file is generated in current dir"




