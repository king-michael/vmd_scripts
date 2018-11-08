# TCL Script to pick and mark atoms with the same attribute.
# e.g. same clusterID saved in the attribute "user"
# HowTo:
# 1.) load data per frame into "user"
# 2.) type "enable_cluster_pick" to enable the picking
# 3.) pick atoms and enjoy
# 4.) type "disable_cluster_pick" to disable the picking

proc same_user {args} {
  # where the values are saved
  set prop "user"
  # use the picked atom's index and molecule id
  global vmd_pick_atom vmd_pick_mol repUSER

  # get the current value
  set sel_tmp [atomselect $vmd_pick_mol "same residue as (index $vmd_pick_atom)"]
  set user [lsort -unique -decreasing [$sel_tmp get $prop]]
  if {[llength $user] > 2} {vmdcon -err "Something is off we have to many cluster ids in the molecule"}
  set user [lindex $user 0]
  $sel_tmp delete
  vmdcon -info "Select cluster with id: $user"


  # condition of the selection
  set cond "same residue as ($prop $user)"

  # create a rep if not allready exists
  if {![info exists repUSER] || [mol repindex $vmd_pick_mol $repUSER] == -1} {
    vmdcon -info "Created representation"
    set repid [molinfo $vmd_pick_mol get numreps]

    mol selection "$cond"
    mol rep {VDW 0.600000 12.000000}
    mol material {Diffuse}
    mol color {ColorID 0}
    mol addrep $vmd_pick_mol
    mol colupdate $repid $vmd_pick_mol 1
    mol selupdate $repid $vmd_pick_mol 1
    set repUSER [mol repname $vmd_pick_mol $repid]
  }
  set repid [mol repindex $vmd_pick_mol $repUSER]

  # change selection
  mol modselect $repid $vmd_pick_mol $cond
}

# function to enable user_pick
proc enable_user_pick {} {
  global vmd_pick_atom
  trace variable vmd_pick_atom w same_user
  vmdcon -info "trace variable vmd_pick_atom"
}

# function to disable user_pick
proc disable_user_pick {} {
  global vmd_pick_atom
  trace vdelete vmd_pick_atom w same_user;
  global repUSER;
  if {[info exists repUSER]} {unset repUSER}
  vmdcon -info "unset trace variable vmd_pick_atom"
}

puts "enable_user_pick  <- enables user picks"
puts "disable_user_pick <- disable user picks"