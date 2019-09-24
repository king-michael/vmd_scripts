# read in user data

# Read frames from file
proc get_column_of_file {filename {column 0}} {
  set list_column ""
  set fp [open ${filename} "r"]
  gets ${fp} firstline
  # get rid of the comment sign
  if {[string match [string index $firstline 0]  "#"]} {
    set firstline [lrange ${firstline} 1 end]
  }
  puts "get column '[lindex ${firstline} ${column}]'"
  while { [gets ${fp} line] >= 0 } {
    lappend list_column [lindex ${line} ${column}]
  }
  close ${fp}

  return ${list_column}
}


proc read_cluster_per_frame {filename {property user} {value 1} {molid top}} {
  # read_cluster_per_frame ./atoms_in_cluster_frame-0_dp-0.32.dat user 1 top
  set fp [open ${filename} "r"]
  set sel [atomselect top all]

  set ts 0
  while { [gets ${fp} line] >= 0 } {
    animate goto $ts
    set data [$sel get $property]
    foreach id $line {lset data $id $value}
    $sel set $property ${data}
    incr ts
  }
  close ${fp}
  $sel delete
}

proc read_file_to_atoms {filename args} {
  # read_file_to_atoms ${pairfile} -stride $stride

  # START HANDLING KEYWORDS
  array set settings {
    property user
    value       1
    molid     top
    stride      1
  }
  set index 0
  for {set i 0} {$i < [llength $args]} {incr i} {
    set arg [lindex $args $i]
    if {[string match "-*" $arg]} {
      set key [string trimleft $arg -]
      incr i
      if {[array names settings $key] != ""} {
        set settings($key) [lindex $args $i]
      } else {
        set out "read_file_to_atoms filename"
        foreach n [array names settings] {set out "$out -${n} $settings($n)"}
        puts $out; return
      }
    }
  }
  # END HANDLING KEYWORDS

  # START HANDLING FILE
  set fp [open ${filename} "r"]
  set sel [atomselect top all]
  set ts -1
  while { [gets ${fp} line] >= 0 } {
    incr ts
    if {[expr $ts % $settings(stride)] eq 0} {
      animate goto [expr int($ts/$settings(stride))]
      set data [$sel get $settings(property)]
      foreach id $line {lset data $id $settings(value)}
      $sel set $settings(property) ${data}
    }
  }
  close ${fp}
  $sel delete
  # END HANDLING FILE
}