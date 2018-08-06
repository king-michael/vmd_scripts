vmdcon -info "proc repair_bonds {}"
vmdcon -info "proc traj_repair_bonds {}"

proc verbose {lvlin lvlbarrier STR} {
  if {$lvlin >= $lvlbarrier} {
    if {$lvlbarrier == 0} {
      puts "INFO) $STR"
    } else {
      puts "DEBUG-LVL$lvlbarrier) $STR"
    }
  }
}

proc round2 {roundexp precision} {
 return [expr double(round($precision * $roundexp))/$precision]
}

proc repair_bonds {args} {
  global M_PI
  # set args "-dist=2 -verbose=4"
  # defaults
  set dist_crit -1
  set vlvl -1
  set precision [expr int(pow(10,6))]
  # args handler
  if {$args ne ""} {
   foreach arg $args {
    if {[string match "-dist=*" $arg]} { set dist_crit [lindex [split "$arg" "="] end]
    } elseif {[string match "-verbose*" $arg]} { 
      if {[llength [split "$arg" "="]] == 2} {
        set vlvl [lindex [split "$arg" "="] end]
      } else {set vlvl 1}
    } elseif {[string match "-precision*" $arg]} {
      set precision [expr int(pow(10,[lindex [split "$arg" "="] end]))]
    }
   }
   
   
  }
  proc stfu {} {puts -nonewline ""}
  set bondlist [topo getbondlist]; stfu

  lassign [molinfo top get "a b c alpha beta gamma"] a b c alpha beta gamma
  if {$alpha != 90 || $beta != 90 || $gamma !=90} {
    set vec_a "$a 0 0"
    set bx [round2 [expr $b * cos($gamma/180.0*$M_PI)] $precision]
    set by [round2 [expr $b * sin($gamma/180.0*$M_PI)] $precision] ;# expr sqrt(pow($b,2)-pow($bx,2))
    set vec_b "$bx $by 0"
    set cx [round2 [expr $c * cos($beta/180.0*$M_PI)] $precision]
    set cy [round2 [expr ($b * $c * cos($alpha/180.0*$M_PI) - $bx*$cx)/$by] $precision]
    set cz [round2 [expr sqrt(pow($c,2)-pow($cx,2)-pow($cy,2))] $precision]
    set vec_c "$cx $cy $cz"
  } else {lassign "{$a 0 0} {0 $b 0} {0 0 $c}" vec_a vec_b vec_c}
  #
  verbose $vlvl 1 "Box vectors:\n - vec_a : $vec_a\n - vec_b : $vec_b\n - vec_c : $vec_c"

  
  set box_half [vecscale .5 "$a $b $c"]
  lassign $box_half a_half b_half c_half
  set box_crit [lindex [lsort -increasing -real $box_half] 0]
  if {${dist_crit} == -1} { ;# set default value
    set dist_crit $box_crit
  } else { ;# set "box_half" to access smaller bonds
    lassign "$dist_crit $dist_crit $dist_crit" a_half b_half c_half 
  }

  verbose $vlvl 0 "dist_crit: $dist_crit"
  foreach bond $bondlist {
    set dist [measure bond $bond]
    if {$dist>$dist_crit} {
      set sel0 [atomselect top "index [lindex $bond 0]"]
      set sel1 [atomselect top "index [lindex $bond 1]"]
      
      set xyz0 [lindex [$sel0 get "x y z"] 0]
      set xyz1 [lindex [$sel1 get "x y z"] 0]

      set distvec [vecsub $xyz1 $xyz0]
      verbose $vlvl 2 "$bond : $dist"
      verbose $vlvl 3 "$distvec vs $a_half $b_half $c_half "
      lassign $distvec dx dy dz
      if {$dx > $a_half} {
          set xyz1 [vecsub $xyz1 $vec_a]
      } elseif {$dx < -$a_half} {
          set xyz1 [vecadd $xyz1 $vec_a]
      }
      if {$dy > $b_half} {
          set xyz1 [vecsub $xyz1 $vec_b]
      } elseif {$dy < -$b_half} {
          set xyz1 [vecadd $xyz1 $vec_b]
      }
      if {$dz > $c_half} {
          set xyz1 [vecsub $xyz1 $vec_c]
      } elseif {$dz < -$c_half} {
          set xyz1 [vecadd $xyz1 $vec_c]
      }
      $sel1 set "x y z" [list $xyz1]
      $sel0 delete
      $sel1 delete
    }
  }
}

proc traj_repair_bonds {} {
  set numframes [molinfo top get numframes]
  puts "Info) Repair bonds"
  for {set i 0} {$i < $numframes} {incr i} {
    animate goto $i
    puts -nonewline "\rInfo) Process: $i" 
    flush stdout
    repair_bonds
  }
  puts "\rInfo) Finished     "
}
