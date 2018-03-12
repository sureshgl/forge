#!/usr/bin/env tclsh

#set list "{mem_t1_bank0_cell_wsp0_dwrap_cell {203.04 728.06 ul} {270.72 546.04}} {mem_t1_bank0_cell_wsp1_dwrap_cell {203.04 546.05 ul} {270.72 364.03}} {mem_t1_bank0_cell_wsp2_dwrap_cell {135.36 728.06 ul} {203.04 546.04}} {mem_t1_bank0_cell_wsp3_dwrap_cell {67.68 728.06 ul} {135.36 546.04}} {mem_t1_bank0_cell_wsp4_dwrap_cell {135.36 546.05 ul} {203.04 364.03}} {mem_t1_bank0_cell_wsp5_dwrap_cell {67.68 546.05 ul} {135.36 364.03}} {mem_t1_bank0_cell_wsp6_dwrap_cell {0.0 728.06 ul} {67.68 546.04}} {mem_t1_bank0_cell_wsp7_dwrap_cell {0.0 546.05 ul} {67.68 364.03}} {mem_t1_bank0_cell_wsp8_dwrap_cell {0.0 182.02 ll} {67.68 364.04}} {mem_t1_bank0_cell_wsp9_dwrap_cell {67.68 182.02 ll} {135.36 364.04}} {mem_t1_bank0_cell_wsp10_dwrap_cell {0.0 0.0 ll} {67.68 182.02}} {mem_t1_bank0_cell_wsp11_dwrap_cell {67.68 0.0 ll} {135.36 182.02}} {mem_t1_bank0_cell_wsp12_dwrap_cell {135.36 182.02 ll} {203.04 364.04}} {mem_t1_bank0_cell_wsp13_dwrap_cell {203.04 182.02 ll} {270.72 364.04}} {mem_t1_bank0_cell_wsp14_dwrap_cell {135.36 0.0 ll} {203.04 182.02}} {mem_t1_bank0_cell_wsp15_dwrap_cell {203.04 0.0 ll} {270.72 182.02}} {mem_t1_bank0_cell_wsp16_dwrap_cell {365.87 0.0 lr} {298.19 182.02}} {mem_t1_bank0_cell_wsp17_dwrap_cell {365.87 182.02 lr} {298.19 364.04}} {mem_t1_bank0_cell_wsp18_dwrap_cell {433.55 0.0 lr} {365.87 182.02}} {mem_t1_bank0_cell_wsp19_dwrap_cell {501.23 0.0 lr} {433.55 182.02}} {mem_t1_bank0_cell_wsp20_dwrap_cell {433.55 182.02 lr} {365.87 364.04}} {mem_t1_bank0_cell_wsp21_dwrap_cell {501.23 182.02 lr} {433.55 364.04}} {mem_t1_bank0_cell_wsp22_dwrap_cell {568.91 0.0 lr} {501.23 182.02}} {mem_t1_bank0_cell_wsp23_dwrap_cell {568.91 182.02 lr} {501.23 364.04}} {mem_t1_bank0_cell_wsp24_dwrap_cell {568.91 546.05 ur} {501.23 364.03}} {mem_t1_bank0_cell_wsp25_dwrap_cell {501.23 546.05 ur} {433.55 364.03}} {mem_t1_bank0_cell_wsp26_dwrap_cell {568.91 728.06 ur} {501.23 546.04}} {mem_t1_bank0_cell_wsp27_dwrap_cell {501.23 728.06 ur} {433.55 546.04}} {mem_t1_bank0_cell_wsp28_dwrap_cell {433.55 546.05 ur} {365.87 364.03}} {mem_t1_bank0_cell_wsp29_dwrap_cell {365.87 546.05 ur} {298.19 364.03}} {mem_t1_bank0_cell_wsp30_dwrap_cell {433.55 728.06 ur} {365.87 546.04}} {mem_t1_bank0_cell_wsp31_dwrap_cell {365.87 728.06 ur} {298.19 546.04}}"
#set path "/Users/harutyan/Desktop/COPPER"
#source "$path/eGSgine.tcl"

proc sort_list {list} \
{
	foreach edge11 $list {
		if {[lindex $edge11 2]=="t" || [lindex $edge11 2]=="b"} {
			set crd1 [lsort -real -index 0 [list [lindex $edge11 0] [lindex $edge11 1]]]
			set  edge1 [linsert $crd1 end [lindex $edge11 2]]
			} elseif {[lindex $edge11 2]=="l" || [lindex $edge11 2]=="r"} {
				set crd1 [lsort -real -index 1 [list [lindex $edge11 0] [lindex $edge11 1]]]
				set  edge1 [linsert $crd1 end [lindex $edge11 2]]
			}
			lappend newlist $edge1
		}
	return $newlist
}

#puts "[sort_list $testlist]"

proc useless_bbox {list} \
{
	set edgechain {}
	set edgechaint {}
	set edgechainb {}
	set edgechainl {}
	set edgechainr {}
	set bboxlist {}
	if {[llength $list]>4} {
		set newlist [sort_list $list]
		foreach edge $newlist {
			if {[lindex $edge 2]=="t"} {
				set tedgelist [lsort -real -index {0 0} [lappend tedgelst $edge]]
				} elseif {[lindex $edge 2]=="b"} {
					set bedgelist [lsort -real -index {0 0} [lappend bedgelst $edge]]
					} elseif {[lindex $edge 2]=="l"} {
						set ledgelist [lsort -real -index {0 1} [lappend ledgelst $edge]]
						} elseif {[lindex $edge 2]=="r"} {
							set redgelist [lsort -real -index {0 1} [lappend redgelst $edge]]
						}
		
		}
		lappend fulllist $tedgelist $bedgelist $ledgelist $redgelist
		#puts "\n####\n$fulllist\n####\n"
			
		foreach edgelist $fulllist {
			set	n [llength $edgelist]
			if {$n>1} {
				for {set i 0} {$i < $n-1} {incr i} {
					if {[lindex $edgelist 0 2]=="t" && \
						[lindex $edgelist $i 1 0]==[lindex $edgelist $i+1 0 0]} {
						set edgechaint [lsort -u [lappend edgchaint [lindex $edgelist $i] [lindex $edgelist $i+1]]]
					}
					if {[lindex $edgelist 0 2]=="b" && \
						[lindex $edgelist $i 1 0]==[lindex $edgelist $i+1 0 0]} {
						set edgechainb [lsort -u [lappend edgchainb [lindex $edgelist $i] [lindex $edgelist $i+1]]]
					}
					if {[lindex $edgelist 0 2]=="l" && \
						[lindex $edgelist $i 1 1]==[lindex $edgelist $i+1 0 1]} {
						set edgechainb [lsort -u [lappend edgchainb [lindex $edgelist $i] [lindex $edgelist $i+1]]]
					}
					if {[lindex $edgelist 0 2]=="r" && \
						[lindex $edgelist $i 1 1]==[lindex $edgelist $i+1 0 1]} {
						set edgechainb [lsort -u [lappend edgchainb [lindex $edgelist $i] [lindex $edgelist $i+1]]]
					}
				}
				} else {
					set edgechain $edgelist
				}
		}
		#puts "\nchain \n$edgechaint\n######\n\n$edgechainb\n######\n"
		set edgelistchain [join [lappend edgelstchain $edgechaint $edgechainb $edgechainl $edgechainr $edgechain]]
		#puts $edgelistchain
	
		foreach var $list {
			set minX [lindex [lsort -uniq -real [lappend maxXlist [lindex $var 0 0] [lindex $var 1 0]]] 0]
			set minY [lindex [lsort -uniq -real [lappend maxYlist [lindex $var 0 1] [lindex $var 1 1]]] 0]
			set maxX [lindex [lsort -uniq -real [lappend maxXlist [lindex $var 0 0] [lindex $var 1 0]]] end]
			set maxY [lindex [lsort -uniq -real [lappend maxYlist [lindex $var 0 1] [lindex $var 1 1]]] end]
			set maxlist [list $maxX $maxY]
		}
	
		foreach edge1 $edgelistchain {
			if {[lindex $edge1 2]=="t" && [lindex $edge1 0 1]!=$minY} {
				set minx [lindex $edge1 0 0]
				set miny $minY
				set maxx [lindex $edge1 1 0]
				set maxy [lindex $edge1 1 1]
				set edgel "\{$minx $miny\} \{$minx $maxy\} l"
				set edger "\{$maxx $miny\} \{$maxx $maxy\} r"
				set edget "\{$minx $maxy\} \{$maxx $maxy\} t"
				set edgeb "\{$minx $miny\} \{$maxx $miny\} b"
				set bbox [list $edgel $edger $edget $edgeb]	
				set bboxlist [lsort -uniq [lappend bboxlst $bbox]]
				} elseif {[lindex $edge1 2]=="b" && [lindex $edge1 0 1]!=$maxY} {
					set minx [lindex $edge1 0 0]
					set miny [lindex $edge1 1 1]
					set maxx [lindex $edge1 1 0]
					set maxy $maxY
					set edgel "\{$minx $miny\} \{$minx $maxy\} l"
					set edger "\{$maxx $miny\} \{$maxx $maxy\} r"
					set edget "\{$minx $maxy\} \{$maxx $maxy\} t"
					set edgeb "\{$minx $miny\} \{$maxx $miny\} b"
					set bbox [list $edgel $edger $edget $edgeb]	
					set bboxlist [lsort -uniq [lappend bboxlst $bbox]]
					}  elseif {[lindex $edge1 2]=="r" && [lindex $edge1 0 0]!=$minX} {
						set minx $minX
						set miny [lindex $edge1 0 1]
						set maxx [lindex $edge1 1 0]
						set maxy [lindex $edge1 1 1]
						set edgel "\{$minx $miny\} \{$minx $maxy\} l"
						set edger "\{$maxx $miny\} \{$maxx $maxy\} r"
						set edget "\{$minx $maxy\} \{$maxx $maxy\} t"
						set edgeb "\{$minx $miny\} \{$maxx $miny\} b"
						set bbox [list $edgel $edger $edget $edgeb]	
						set bboxlist [lsort -uniq [lappend bboxlst $bbox]]
						} elseif {[lindex $edge1 2]=="l" && [lindex $edge1 0 0]!=$maxX} {
							set minx [lindex $edge1 0 0]
							set miny [lindex $edge1 0 1]
							set maxx $maxX
							set maxy [lindex $edge1 1 1]
							set edgel "\{$minx $miny\} \{$minx $maxy\} l"
							set edger "\{$maxx $miny\} \{$maxx $maxy\} r"
							set edget "\{$minx $maxy\} \{$maxx $maxy\} t"
							set edgeb "\{$minx $miny\} \{$maxx $miny\} b"
							set bbox [list $edgel $edger $edget $edgeb]	
							set bboxlist [lsort -uniq [lappend bboxlst $bbox]]
						}
					}
		set finalbboxlist [lsort -uniq $bboxlist]
		} else {
			set finalbboxlist [list $list]
		}
	return $finalbboxlist
}


#set less_b [useless_bbox $testlist]
#puts "$less_bb\n[llength $less_bb]"


proc bank_bbox {list} \
{
	foreach bank $list {
		set minx [lindex [lsort -real -uniq [list [lindex $bank 1 0] [lindex $bank 2 0]]] 0]
		set miny [lindex [lsort -real -uniq [list [lindex $bank 1 1] [lindex $bank 2 1]]] 0]
		set maxx [lindex [lsort -real -uniq [list [lindex $bank 1 0] [lindex $bank 2 0]]] end]
		set maxy [lindex [lsort -real -uniq [list [lindex $bank 1 1] [lindex $bank 2 1]]] end]
		set edgel "\{$minx $miny\} \{$minx $maxy\} l"
		set edger "\{$maxx $miny\} \{$maxx $maxy\} r"
		set edget "\{$minx $maxy\} \{$minx $maxy\} t"
		set edgeb "\{$minx $miny\} \{$maxx $miny\} b"
		set bbox [list $edgel $edger $edget $edgeb]	
		set bboxlist [lsort -uniq [lappend bboxlst $bbox]]
	}
	return $bboxlist
}

#set bankbblist [bank_bbox $list]
#puts "$bankbblist \n\n [llength $bankbblist]"

proc crd_list {list} \
{
	foreach edge $list {
		set xlist [lsort -u [lappend xlst [lindex $edge 0 0] [lindex $edge 1 0]]]
		set ylist [lsort -u [lappend ylst [lindex $edge 0 1] [lindex $edge 1 1]]]
	}
	foreach x $xlist {
		foreach y $ylist {
			set crd "$x $y"
			set crdlist [lsort -u [lappend crdlst $crd]]
		}	
	}
	return $crdlist
}


#set crdlist [crd_list $minedge]
#puts $crdlist

proc bbox_list {list} \
{
	foreach crd1 $list {
		foreach crd2 $list {
			if {[lindex $crd1 0]<[lindex $crd2 0] && [lindex $crd1 1]<[lindex $crd2 1]} {
				set minx [lindex $crd1 0]
				set miny [lindex $crd1 1]
				set maxx [lindex $crd2 0]
				set maxy [lindex $crd2 1]
				set edgel "\{$minx $miny\} \{$minx $maxy\} l"
				set edger "\{$maxx $miny\} \{$maxx $maxy\} r"
				set edget "\{$minx $maxy\} \{$maxx $maxy\} t"
				set edgeb "\{$minx $miny\} \{$maxx $miny\} b"
				set bbox [list $edgel $edger $edget $edgeb]	
				lappend bboxlist $bbox
			}
		}
	}
	return $bboxlist
}


#puts $bboxlist

proc internal_bb {bboxlist1 bboxlist2} \
{
	set rmlist {}
	foreach bbox1 $bboxlist1 {
		foreach bbox2 $bboxlist2 {
			foreach edge1 $bbox1 {
				foreach edge2 $bbox2 {
					if {[lindex $edge1 2]=="l" && [lindex $edge2 2]=="t" || \
						[lindex $edge1 2]=="l" && [lindex $edge2 2]=="b" || \
						[lindex $edge1 2]=="r" && [lindex $edge2 2]=="t" || \
						[lindex $edge1 2]=="r" && [lindex $edge2 2]=="b"} {
							if {[lindex $edge1 0 0]>[lindex $edge2 0 0] && [lindex $edge1 0 0]<[lindex $edge2 1 0] && \
								[lindex $edge2 0 1]>[lindex $edge1 0 1] && [lindex $edge2 0 1]<[lindex $edge1 1 1]} {
									#puts "\n bad list $bbox1\ngood list $bbox2\n"
									lappend rmlist $bbox2
								}
						} elseif {[lindex $edge1 2]=="t" && [lindex $edge2 2]=="l" || \
								  [lindex $edge1 2]=="t" && [lindex $edge2 2]=="r" || \
								  [lindex $edge1 2]=="b" && [lindex $edge2 2]=="l" || \
								  [lindex $edge1 2]=="b" && [lindex $edge2 2]=="r"} {
			  						if {[lindex $edge2 0 0]>[lindex $edge1 0 0] && [lindex $edge2 0 0]<[lindex $edge1 1 0] && \
			  							[lindex $edge1 0 1]>[lindex $edge2 0 1] && [lindex $edge1 0 1]<[lindex $edge2 1 1]} {
			  								#puts "\n$bbox1\n$bbox2\n\n"
											lappend rmlist $bbox2
										}
										} elseif {[lindex $edge1 2]=="t" && [lindex $edge2 2]=="t" || \
												  [lindex $edge1 2]=="b" && [lindex $edge2 2]=="b" } {
													  if {[lindex $edge1 0 1]==[lindex $edge2 0 1] && \
														  [lindex $edge1 0 0]<=[lindex $edge2 0 0] && \
														  [lindex $edge1 1 0]> [lindex $edge2 0 0] && \
														  [lindex $edge1 1 0]<=[lindex $edge2 1 0]} {
													  		  lappend rmlist $bbox2
													  			} elseif {[lindex $edge2 0 1]==[lindex $edge1 0 1] && \
														 	 			  [lindex $edge2 0 0]<=[lindex $edge1 0 0] && \
																		  [lindex $edge2 1 0]> [lindex $edge1 0 0] && \
														 	   			  [lindex $edge2 1 0]<=[lindex $edge1 1 0]} {
																			  lappend rmlist $bbox2
																		  }
												  }  elseif {[lindex $edge1 2]=="l" && [lindex $edge2 2]=="l" || \
													  		 [lindex $edge1 2]=="r" && [lindex $edge2 2]=="r" } {
																 if {[lindex $edge1 0 0]==[lindex $edge2 0 0] && \
																	 [lindex $edge1 0 1]<=[lindex $edge2 0 1] && \
																	 [lindex $edge1 1 1]> [lindex $edge2 0 1] && \
																	 [lindex $edge1 1 1]<=[lindex $edge2 1 1] \
																	 } {
													  					 lappend rmlist $bbox2
													 					} elseif {[lindex $edge2 0 0]==[lindex $edge1 0 0] && \
																				  [lindex $edge2 0 1]<=[lindex $edge1 0 1] && \
																				  [lindex $edge2 1 1]> [lindex $edge1 0 1] && \
														 	 					  [lindex $edge2 1 1]<=[lindex $edge1 1 1]} {
																					 lappend rmlist $bbox2
																					 }
																				 }
				}
			}
			if {[lindex $bbox1 0 0 0]<=[lindex $bbox2 0 0 0] && \
				[lindex $bbox1 1 0 0]>=[lindex $bbox2 1 0 0] && \
				[lindex $bbox1 2 0 1]>=[lindex $bbox2 2 0 1] && \
				[lindex $bbox1 3 1 1]<=[lindex $bbox2 3 1 1] || \
				[lindex $bbox1 0 0]==[lindex $bbox2 0 0] || \
				[lindex $bbox1 0 1]==[lindex $bbox2 0 1] || \
				[lindex $bbox1 1 0]==[lindex $bbox2 1 0] || \
				[lindex $bbox1 1 1]==[lindex $bbox2 1 1] \
				} {
					#puts "\n bad list $bbox1\ngood list $bbox2\n"
					lappend rmlist $bbox2
			}
			if {[lindex $bbox1 0 0 0]>=[lindex $bbox2 0 0 0] && \
				[lindex $bbox1 1 0 0]<=[lindex $bbox2 1 0 0] && \
				[lindex $bbox1 2 0 1]<=[lindex $bbox2 2 0 1] && \
				[lindex $bbox1 3 1 1]>=[lindex $bbox2 3 1 1]} {
					#puts "\n bad list $bbox1\ngood list $bbox2\n"
					lappend rmlist $bbox2
			}
		}
	}
	set newlist [lremove $bboxlist2 $rmlist]
#	puts "final list $newlist\n [llength $newlist]\n"
	return $newlist
}

#set int_bb [internal_bb $bankbblist $bboxlist]
#puts $int_bb

proc minimum_bbox {list} \
{
	#puts $list
	set uselesslist {}
	if {[llength $list]>4} {
		foreach bbox1 $list {
			foreach bbox2 $list {
				if {[lindex $bbox1 0 0 0]>=[lindex $bbox2 0 0 0] && \
					[lindex $bbox1 1 0 0]< [lindex $bbox2 1 0 0] && \
					[lindex $bbox1 2 0 1]<=[lindex $bbox2 2 0 1] && \
					[lindex $bbox1 3 1 1]>=[lindex $bbox2 3 1 1] || \
					[lindex $bbox1 0 0 0]> [lindex $bbox2 0 0 0] && \
					[lindex $bbox1 1 0 0]<=[lindex $bbox2 1 0 0] && \
					[lindex $bbox1 2 0 1]<=[lindex $bbox2 2 0 1] && \
					[lindex $bbox1 3 1 1]>=[lindex $bbox2 3 1 1] || \
					[lindex $bbox1 0 0 0]>=[lindex $bbox2 0 0 0] && \
					[lindex $bbox1 1 0 0]<=[lindex $bbox2 1 0 0] && \
					[lindex $bbox1 2 0 1]< [lindex $bbox2 2 0 1] && \
					[lindex $bbox1 3 1 1]>=[lindex $bbox2 3 1 1] || \
					[lindex $bbox1 0 0 0]>=[lindex $bbox2 0 0 0] && \
					[lindex $bbox1 1 0 0]<=[lindex $bbox2 1 0 0] && \
					[lindex $bbox1 2 0 1]<=[lindex $bbox2 2 0 1] && \
					[lindex $bbox1 3 1 1]> [lindex $bbox2 3 1 1]} {
						lappend uselesslist $bbox1
						#puts $bbox1
				} else {
					#set uselesslist {}
				}
			}
		}
		set finallist [lremove $list $uselesslist]
		} elseif {[llength $list]==4} {
			set finallist [list $list]
			} else {
				#puts "no gap boxes were found in the design"
			}
	#puts "\n########## init list ########\n$list\n########\n$finallist"
	return $finallist
}

#puts $final_list
proc gap_area {list} \
{
	#puts $list
	set less_bb {}
	foreach var $list {
		set minX [lindex [lsort -uniq -real [lappend maxXlist [lindex $var 0 0] [lindex $var 1 0]]] 0]
		set minY [lindex [lsort -uniq -real [lappend maxYlist [lindex $var 0 1] [lindex $var 1 1]]] 0]
		set maxX [lindex [lsort -uniq -real [lappend maxXlist [lindex $var 0 0] [lindex $var 1 0]]] end]
		set maxY [lindex [lsort -uniq -real [lappend maxYlist [lindex $var 0 1] [lindex $var 1 1]]] end]
	}
	set deltaX [round [expr $maxX - $minX]]
	set deltaY [round [expr $maxY - $minY]]
	set fullarea   [round [expr $deltaX * $deltaY]]
	#puts $fullarea
	set less_bb    [useless_bbox $list]
	#puts $less_bb
	set minimum_bb [minimum_bbox $less_bb]
	#puts $minimum_bb
	foreach bbox $minimum_bb {
		set deltax [round [expr [lindex $bbox 2 1 0] - [lindex $bbox 2 0 0]]]
		set deltay [round [expr [lindex $bbox 0 1 1] - [lindex $bbox 0 0 1]]]
		set area [round [expr $deltax*$deltay]]
		lappend arealist $area
	}
	foreach bbarea $arealist {
		set gap_area [round [expr $fullarea - $bbarea]]
	}
	return $gap_area
}

#gap_area $minedge
proc ladd L {expr [join $L +]+0}

proc gravity_center {list} \
{
	#puts $list
	if {[llength $list]>4} {
		set crdlist		[crd_list $list]
		set bboxlist 	[bbox_list $crdlist]
		set useless_bb 	[useless_bbox $list]
		set int_bb 		[internal_bb $useless_bb $bboxlist]
		set final_list 	[minimum_bbox $int_bb]
	#	puts $final_list
		set gaparea 	[gap_area $list]
		foreach bbox $final_list {
			set centerx [round [expr [lindex $bbox 2 0 0] + ([lindex $bbox 3 1 0]-[lindex $bbox 2 0 0])/2]]
			set centery [round [expr [lindex $bbox 0 0 1] + ([lindex $bbox 1 1 1]-[lindex $bbox 0 0 1])/2]]
			set area [round [expr ([lindex $bbox 0 1 1] - [lindex $bbox 0 0 1])*([lindex $bbox 2 1 0]-[lindex $bbox 2 0 0])]]
			set areaR [round [expr $area/$gaparea]]
			set crdweight "\{$centerx $centery\} $areaR"
			lappend crdweightlst $crdweight
		}

		foreach crdW $crdweightlst {
			set Xlist [lappend xlst [round [expr [lindex $crdW 0 0] * [lindex $crdW 1]]]]
			set Ylist [lappend ylst [round [expr [lindex $crdW 0 1] * [lindex $crdW 1]]]]
			set Klist [lappend klst [lindex $crdW 1]]
		}
		set K [round [expr [ladd $Klist]]]
		set X [round [expr [ladd $Xlist]/$K]]
		set Y [round [expr [ladd $Ylist]/$K]]
		set gapGC [list $X $Y]
		} elseif {[llength $list]==4} {
			foreach var $list {
				set x1 [lindex [lsort -real [lappend xlist [lindex $var 0 0]]] 0]
				set y1 [lindex [lsort -real [lappend ylist [lindex $var 0 1]]] 0]
				set x2 [lindex [lsort -real [lappend xlist [lindex $var 0 0]]] end]
				set y2 [lindex [lsort -real [lappend ylist [lindex $var 0 1]]] end]	
		}
		#puts "$x1 $y1 --- $x2 $y2"
		set X [round [expr $x1+($x2 - $x1)/2]]
		set Y [round [expr $y1+($y2 - $y1)/2]]
		set gapGC [list $X $Y]
	}
	#puts "$gapGC"
	return $gapGC
}


proc find_edge {list} \
{
	set minedge [final_minedge $list]
	set GC 		[gravity_center $minedge]
	foreach var $list {
		set minX [lindex [lsort -uniq -real [lappend maxXlist [lindex $var 1 0] [lindex $var 2 0]]] 0]
		set minY [lindex [lsort -uniq -real [lappend maxYlist [lindex $var 1 1] [lindex $var 2 1]]] 0]
		set maxX [lindex [lsort -uniq -real [lappend maxXlist [lindex $var 1 0] [lindex $var 2 0]]] end]
		set maxY [lindex [lsort -uniq -real [lappend maxYlist [lindex $var 1 1] [lindex $var 2 1]]] end]
	}
	set x [lindex $GC 0]
	set y [lindex $GC 1]
	set deltay1 [round [expr $maxY-$y]]
	set deltay2 [round [expr $minY+$y]]
	set deltax1 [round [expr $maxX-$x]]
	set deltax2 [round [expr $minX+$x]]
	set pinedge [lindex [lsort -index {0} -real [lappend deltalst "$deltay1 t" "$deltay2 b" "$deltax1 r" "$deltax2 l"]] 0 1]
	return $pinedge
}


proc find_gap {list} \
{
	#puts $list
	set minedge 	[final_minedge $list]
	if {[llength $minedge]>4} {
		set crdlist 	[crd_list 		$minedge]
		set bboxlist 	[bbox_list 		$crdlist]
		set useless_bb 	[useless_bbox	$minedge]
		set int_bb 		[internal_bb $useless_bb $bboxlist]
		set final_list 	[minimum_bbox	 $int_bb]
		foreach bbox $final_list {
			set index [lsearch $final_list $bbox]
			set area [round [expr ([lindex $bbox 0 1 1] - [lindex $bbox 0 0 1])*([lindex $bbox 2 1 0]-[lindex $bbox 2 0 0])]]
			set areaindex  [lsort -index 0 -real [lappend areaind "$area $index"]]
		}
		set usefullgap [lindex $final_list [lindex $areaindex end 1]]
		} elseif {[llength $minedge]==4} {
			set usefullgap $list
		}
		
	return $usefullgap
}

proc finddelta {list} \
{
	set newminedge {}
	set deltal {}
	set deltar {}
	set deltab {}
	set deltat {}		
	set coreedges [coreedge $list]
	set minedge [lsort -u [final_minedge $list]]
	set newlist [join [lappend newlst $coreedges $minedge]]
	if {[llength $minedge]==4} {
		set newlist [join [lappend newlst $coreedges $minedge]]
		foreach edge1 $newlist {
			foreach edge2 $newlist {
				set paredge {}
				if {[lindex $edge1 2]==[lindex $edge2 2] && $edge1!=$edge2} {
					if {[lindex $edge2 2]=="l"} {
						set deltal "[round [expr [lindex $edge1 0 0] - [lindex $edge2 0 0]]] l"
						} elseif { [lindex $edge2 2]=="r"} {
							set deltar "[round [expr [lindex $edge1 0 0] - [lindex $edge2 0 0]]] r"
							} elseif {[lindex $edge2 2]=="t" } {
								set deltat "[round [expr [lindex $edge1 0 1] - [lindex $edge2 0 1]]] t"
								} elseif {[lindex $edge2 2]=="b"} {
									set deltab "[round [expr [lindex $edge1 0 1] - [lindex $edge2 0 1]]] b"
								}
				}
			}
		}
	}
	set deltalist [lsort [lappend deltalst $deltal $deltar $deltab $deltat]]
	return $deltalist
}




proc find_range {list} \
{
	set newedgeb {}
	set newedget {}
	set newedgel {}
	set newedger {}
	set coreedges [coreedge $list]
	set minedge [lsort -u [final_minedge $list]]
	set newlist [join [lappend newlst $coreedges $minedge]]
	set deltalist [finddelta $list]
	set delta1 [lindex $deltalist 0]
	set delta2 [lindex $deltalist 1]
	set edge1 [lindex $delta1 1]
	set edge2 [lindex $delta2 1]
	if {[lindex $delta1 0]==[lindex $delta2 0]} {
		if {$edge1=="l" || $edge2=="l"} {
			set coreedge [lsearch -index {2} -inline $coreedges l]
			set gapedge  [lsearch -index {2} -inline $minedge   l]
			set x1 [lindex $coreedge 0 0]
			set x2 [lindex $coreedge 1 0]
			set y1 [lindex $gapedge  0 1]
			set y2 [lindex $gapedge  1 1]
			set newedgel "\{\{$x1 $y1\} \{$x2 $y2\} l\}"
		}
		if {$edge1=="r" || $edge2=="r"} {
			set coreedge [lsearch -index {2} -inline $coreedges r]
			set gapedge  [lsearch -index {2} -inline $minedge   r]
			set x1 [lindex $coreedge 0 0]
			set x2 [lindex $coreedge 1 0]
			set y1 [lindex $gapedge  0 1]
			set y2 [lindex $gapedge  1 1]
			set newedger "\{\{$x1 $y1\} \{$x2 $y2\} r\}"
		}
		if {$edge1=="t" || $edge2=="t"} {
			set coreedge [lsearch -index {2} -inline $coreedges t]
			set gapedge  [lsearch -index {2} -inline $minedge   t]
			set y1 [lindex $coreedge 0 1]
			set y2 [lindex $coreedge 1 1]
			set x1 [lindex $gapedge  0 0]
			set x2 [lindex $gapedge  1 0]
			set newedget "\{\{$x1 $y1\} \{$x2 $y2\} t\}"
		}
		if {$edge1=="b" || $edge2=="b"} {
			set coreedge [lsearch -index {2} -inline $coreedges b]
			set gapedge  [lsearch -index {2} -inline $minedge   b]
			set y1 [lindex $coreedge 0 1]
			set y2 [lindex $coreedge 1 1]
			set x1 [lindex $gapedge  0 0]
			set x2 [lindex $gapedge  1 0]
			set newedgeb "\{\{$x1 $y1\} \{$x2 $y2\} b\}"
		}
		set newedgelist [join [lappend newedgelst $newedger $newedgel $newedgeb $newedget]]
		} else {
			if {$edge1=="l" || $edge1=="r"} {
				set coreedge [lsearch -index {2} -inline $coreedges $edge1]
				set gapedge  [lsearch -index {2} -inline $minedge   $edge1]
				set x1 [lindex $coreedge 0 0]
				set x2 [lindex $coreedge 1 0]
				set y1 [lindex $gapedge  0 1]
				set y2 [lindex $gapedge  1 1]
				set newedge "\{\{$x1 $y1\} \{$x2 $y2\} $edge1\}"
			}
			if {$edge1=="t" || $edge1=="b"} {
				set coreedge [lsearch -index {2} -inline $coreedges $edge1]
				set gapedge  [lsearch -index {2} -inline $minedge   $edge1]
				set y1 [lindex $coreedge 0 1]
				set y2 [lindex $coreedge 1 1]
				set x1 [lindex $gapedge  0 0]
				set x2 [lindex $gapedge  1 0]
				set newedge "\{\{$x1 $y1\} \{$x2 $y2\} $edge1\}"
			}
			set newedgelist $newedge
		}
	set newlist [join [lappend newlst $coreedges $minedge $newedgelist]]
	set newminedge [minimum_edge_same $newlist]
	#puts "\n ---- ################# ---- \n$newminedge\n########\n[llength $newminedge]\n#######\n"
	set blockrange [lremove $newminedge $minedge]
	set l [llength $blockrange]
	#puts "\n#################################"
	return $blockrange	
}

proc blockage_bbox {list} \
{
	set range [find_range $list]
	foreach line $range {
		lappend newrange [lrange $line 0 1]
	}
	set block_edge_list $newrange
	set delta 4
	foreach block_edge $block_edge_list {
		set xlst {}
		set ylst {}
		set x1 [expr [lindex [lsort -real [lappend xlst [lindex $block_edge 0 0] [lindex $block_edge 1 0]]]   0] - $delta] 
		set y1 [expr [lindex [lsort -real [lappend ylst [lindex $block_edge 0 1] [lindex $block_edge 1 1]]]   0] - $delta]
		set x2 [expr [lindex [lsort -real [lappend xlst [lindex $block_edge 0 0] [lindex $block_edge 1 0]]] end] + $delta]
		set y2 [expr [lindex [lsort -real [lappend ylst [lindex $block_edge 0 1] [lindex $block_edge 1 1]]] end] + $delta]
		set blkbbox "\{$x1 $y1\} \{$x2 $y2\}"
		set blkbboxlist [lsort -u [lappend blkbboxlst $blkbbox]]
		#puts $blkbbox
	}
	return $blkbboxlist
}

#puts "[blockage_bbox $list]"

#puts "[find_range $list]"
proc find_range {list} \
{
	set newedgeb {}
	set newedget {}
	set newedgel {}
	set newedger {}
	set coreedges [coreedge $list]
	set minedge [lsort -u [final_minedge $list]]
	set newlist [join [lappend newlst $coreedges $minedge]]
	set deltalist [finddelta $list]
	set delta1 [lindex $deltalist 0]
	set delta2 [lindex $deltalist 1]
	set edge1 [lindex $delta1 1]
	set edge2 [lindex $delta2 1]
	if {[lindex $delta1 0]==[lindex $delta2 0]} {
		if {$edge1=="l" || $edge2=="l"} {
			set coreedge [lsearch -index {2} -inline $coreedges l]
			set gapedge  [lsearch -index {2} -inline $minedge   l]
			set x1 [lindex $coreedge 0 0]
			set x2 [lindex $coreedge 1 0]
			set y1 [lindex $gapedge  0 1]
			set y2 [lindex $gapedge  1 1]
			set newedgel "\{\{$x1 $y1\} \{$x2 $y2\} l\}"
		}
		if {$edge1=="r" || $edge2=="r"} {
			set coreedge [lsearch -index {2} -inline $coreedges r]
			set gapedge  [lsearch -index {2} -inline $minedge   r]
			set x1 [lindex $coreedge 0 0]
			set x2 [lindex $coreedge 1 0]
			set y1 [lindex $gapedge  0 1]
			set y2 [lindex $gapedge  1 1]
			set newedger "\{\{$x1 $y1\} \{$x2 $y2\} r\}"
		}
		if {$edge1=="t" || $edge2=="t"} {
			set coreedge [lsearch -index {2} -inline $coreedges t]
			set gapedge  [lsearch -index {2} -inline $minedge   t]
			set y1 [lindex $coreedge 0 1]
			set y2 [lindex $coreedge 1 1]
			set x1 [lindex $gapedge  0 0]
			set x2 [lindex $gapedge  1 0]
			set newedget "\{\{$x1 $y1\} \{$x2 $y2\} t\}"
		}
		if {$edge1=="b" || $edge2=="b"} {
			set coreedge [lsearch -index {2} -inline $coreedges b]
			set gapedge  [lsearch -index {2} -inline $minedge   b]
			set y1 [lindex $coreedge 0 1]
			set y2 [lindex $coreedge 1 1]
			set x1 [lindex $gapedge  0 0]
			set x2 [lindex $gapedge  1 0]
			set newedgeb "\{\{$x1 $y1\} \{$x2 $y2\} b\}"
		}
		set newedgelist [join [lappend newedgelst $newedger $newedgel $newedgeb $newedget]]
		} else {
			if {$edge1=="l" || $edge1=="r"} {
				set coreedge [lsearch -index {2} -inline $coreedges $edge1]
				set gapedge  [lsearch -index {2} -inline $minedge   $edge1]
				set x1 [lindex $coreedge 0 0]
				set x2 [lindex $coreedge 1 0]
				set y1 [lindex $gapedge  0 1]
				set y2 [lindex $gapedge  1 1]
				set newedge "\{\{$x1 $y1\} \{$x2 $y2\} $edge1\}"
			}
			if {$edge1=="t" || $edge1=="b"} {
				set coreedge [lsearch -index {2} -inline $coreedges $edge1]
				set gapedge  [lsearch -index {2} -inline $minedge   $edge1]
				set y1 [lindex $coreedge 0 1]
				set y2 [lindex $coreedge 1 1]
				set x1 [lindex $gapedge  0 0]
				set x2 [lindex $gapedge  1 0]
				set newedge "\{\{$x1 $y1\} \{$x2 $y2\} $edge1\}"
			}
			set newedgelist $newedge
		}
	set newlist [join [lappend newlst $coreedges $minedge $newedgelist]]
	set newminedge [minimum_edge_same $newlist]
	#puts "\n ---- ################# ---- \n$newminedge\n########\n[llength $newminedge]\n#######\n"
	set blockrange [lremove $newminedge $minedge]
	set l [llength $blockrange]
	#puts "\n#################################"
	return $blockrange	
}

