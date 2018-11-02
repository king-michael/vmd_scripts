# date: 20.09.2017
# author: Michael King (michael.king@uni-konstanzz.de)
#ToDo:
#    - [untested] proc was not tested for multiple representations (comment out the line if you want to use it)
#    - [bug] slow performance for a lot of mols
#       + create multiple sels => to one molecule
#       + repliace bond list * numframes times => set mollist of new molecule
#       + maybe renum resids!
#    - add update representation proc

namespace eval ssplots {
  namespace export info ;#
  #=====================================#
  # proc info / help
  #=====================================#
  proc info {} {
    puts "usage:
  [namespace current]::info
      - prints this message

  [namespace current]::createmols ?molid?
      - create mols from trajectory

  [namespace current]::createmols_fast ?molid?
      - create mols from trajectory (all in one mol, may not work with selections using residue)

  [namespace current]::deletemols
      - delete mols (clean up after picture)

  [namespace current]::showmols
      - show mols

  [namespace current]::hidemols
      - hide mols

  [namespace current]::updatemols
      - update representations based on the original mol

  #BUGS:
    - \[untested\] proc was not tested for multiple representations (comment out the line if you want to use it)
    - \[bug\] slow performance for a lot of mols
    "
  }
  [namespace current]::info ;# print info
  namespace export help ;#
  interp alias {} [namespace current]::help {} [namespace current]::info ;# alias the command

  #=====================================#
  # proc createmols
  #=====================================#
  namespace export createmols ;# ka
  proc createmols {{molid top}} { ;# create molids
    variable USEDFAST 0
    set molid [molinfo $molid get id]
    variable org_molid $molid
    set numframes [molinfo $molid get numframes]; # number of frames
    set oldmols [molinfo list]  ;# list of old molids

    # get representations
    set numreps [molinfo $molid get numreps]
    if {$numreps > 1} {vmdcon -err "proc not written/tested for more then one representation"; return}; # comment out if sure
    set repinfo "" ;# representation info
    for {set i 0} {$i < $numreps} {incr i} {
      lappend repinfo [molinfo $molid get [list "rep $i" "selection $i" "color $i" "material $i"]]
    }
    # create new mols
    variable newmols "" ;# empty list for new molids
    set sel [atomselect $molid all]
    for {set ts 0} {$ts < $numframes} {incr ts} {
      mol top $molid
      animate goto $ts
#       set sel [atomselect top all]
#       lappend newmols $sel
      $sel update
      puts "$ts"
      set tmp [::TopoTools::selections2mol "$sel"] ;# creates a new mol
      lappend newmols $tmp ;# stores the molid in a list
      # add representations
      mol delrep 0 $tmp
      for {set i 0} {$i < $numreps} {incr i} {
        lassign [lindex $repinfo $i] inp_rep inp_sel inp_col inp_mat
        mol representation $inp_rep
        mol selection $inp_sel
        mol color $inp_col
        mol material $inp_mat
        mol addrep $tmp
      }
      mol ssrecalc $tmp ;# recalc SS structure
      mol rename $tmp "ts: $ts"
    }
    mol off $molid ;# turns off current molecule
    return
  }

  #=====================================#
  # proc createmols_fast
  #=====================================#
  namespace export createmols_fast ;# ka
  proc createmols_fast {{molid top}} { ;# create molids
    variable USEDFAST 1
    set molid [molinfo $molid get id]
    variable org_molid $molid
    set numframes [molinfo $molid get numframes]; # number of frames
    set oldmols [molinfo list]  ;# list of old molids
    mol top $molid
    # CHECK
    puts "Do a sanity check if box exist"
    set WARN 0
    for {set i 0} {$i < [molinfo $molid get numframes]} {incr i} {
      animate goto $i
      lassign [molinfo $molid get "a b c alpha beta gamma"] a b c alpha beta gamma
      if {$a == 0.0} {molinfo $molid set a 100 ; set WARN 1}
      if {$b == 0.0} {molinfo $molid set b 100 ; set WARN 1}
      if {$c == 0.0} {molinfo $molid set c 100 ; set WARN 1}
      unset a b c alpha beta gamma
    }
    if {$WARN == 1} {puts "WARNING) somewhere was the box dimension 0.0 changed it to 100"} else {puts " passed"}

    # get representations
    set numreps [molinfo $molid get numreps]
    if {$numreps > 1} {vmdcon -err "proc not written/tested for more then one representation"; return}; # comment out if sure
    set repinfo "" ;# representation info
    for {set i 0} {$i < $numreps} {incr i} {
      lappend repinfo [molinfo $molid get [list "rep $i" "selection $i" "color $i" "material $i"]]
    }

    set sel [atomselect $molid all]
    set oldresid [$sel get resid]; puts -nonewline "" ;# old resids
    set list_ones ""; foreach resid $oldresid {lappend list_ones 1}
    set newcoords "" ;# list of newcoords
#     set newresids "" ;# list for newresids #FIXME
    set newstructure "" ;# list for structures
    for {set ts 0} {$ts < $numframes} {incr ts} {
      animate goto $ts
      puts -nonewline "\r $ts of $numframes"; flush stdout
      vmd_calculate_structure $molid
      $sel update
      lappend newcoords {*}[$sel get "x y z"]
#       lappend newresids {*}[vecadd [$sel get resid] [vecscale $ts $list_ones]]
      lappend newstructure {*}[$sel get structure]
    }

    puts "\nfinished calculating SS"



    animate goto 0; # go back to first frame
    set newmol [::TopoTools::replicatemol $molid $numframes 1 1]; # replicate


    variable newmols [list $newmol] ;#  list for new molids
    molinfo $newmol set "a b c alpha beta gamma" [molinfo $molid get "a b c alpha beta gamma"] ;# adjsut box
    set selnew [atomselect $newmol all] ;# selection
    $selnew set structure $newstructure
#     $selnew set resid $newresids ;# #FIXME
    $selnew set "x y z" $newcoords
    # add representations
    mol delrep 0 $newmol


    for {set i 0} {$i < $numreps} {incr i} {
      lassign [lindex $repinfo $i] inp_rep inp_sel inp_col inp_mat
      mol representation $inp_rep
      mol selection $inp_sel
      mol color $inp_col
      mol material $inp_mat
      mol addrep $newmol
    }

    #mol rename $tmp "ts: $ts"
    mol off $molid ;# turns off current molecule
    display resetview
    return
  }

  #=====================================#
  # proc deletemols
  #=====================================#
  namespace export deletemols ;# ka
  proc deletemols {} { ;# delete molids
    variable newmols
    foreach molid $newmols {
      mol delete $molid
    }
    set newmols ""
  }

  #=====================================#
  # proc deletemols
  #=====================================#
  namespace export showmols ;# ka
  proc showmols {} { ;# delete molids
    variable newmols
    foreach molid $newmols {
      mol on $molid
    }
  }

  #=====================================#
  # proc deletemols
  #=====================================#
  namespace export hidemols ;# ka
  proc hidemols {} { ;# delete molids
    variable newmols
    foreach molid $newmols {
      mol off $molid
    }
  }

  #=====================================#
  # proc updatemols
  #=====================================#
  namespace export updatemols ;# ka
  proc updatemols {} { ;# delete molids
    variable newmols
    variable org_molid
    variable USEDFAST
    # get representations
    set numreps [molinfo $org_molid get numreps]
    set repinfo "" ;# representation info
    for {set i 0} {$i < $numreps} {incr i} {
      lappend repinfo [molinfo $org_molid get [list "rep $i" "selection $i" "color $i" "material $i"]]
    } ;# for {set i 0} {$i < $numreps} {incr i}
    foreach molid $newmols {
      set tmp_numreps [molinfo $molid get numreps]
      for {set i 0} {$i < $tmp_numreps} {incr i} {mol delrep 0 $molid}
      for {set i 0} {$i < $numreps} {incr i} {
        lassign [lindex $repinfo $i] inp_rep inp_sel inp_col inp_mat
        mol representation $inp_rep
        mol selection $inp_sel
        mol color $inp_col
        mol material $inp_mat
        mol addrep $molid
      } ;# for {set i 0} {$i < $numreps} {incr i}
      if {$USEDFAST != 1} {mol ssrecalc $molid}
    } ;# foreach molid $newmols
  } ;# proc hidemols {}

} ;# namespace eval