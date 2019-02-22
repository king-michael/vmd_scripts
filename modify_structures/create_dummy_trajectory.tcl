=============================================================#
set TESTMOL [mol new atoms 2]
animate dup $TESTMOL
pbc set "100 100 100 90 90 90"
# add representation
mol color Type
mol representation VDW 1.000000 12.000000
mol selection all
mol material Diffuse
mol addrep $TESTMOL
# set properties
set sel [atomselect $TESTMOL all]
$sel set type X
$sel set name X
$sel set mass 1
set sel1 [atomselect $TESTMOL "index 0"]
set sel2 [atomselect $TESTMOL "index 1"]

# reset coords
$sel1 set {x y z} {"0 0 0"}
$sel2 set {x y z} {"0 0 0"}
#
mol reanalyze $TESTMOL
#=============================================================#
# set TESTMOL 4
set BIN_SIZE 0.01
set BIN_BORDERS "0 15"

set sel1 [atomselect $TESTMOL "index 0"]
set sel2 [atomselect $TESTMOL "index 1"]
animate delete all

set BIN_RANGE [expr [lindex $BIN_BORDERS 1] - [lindex $BIN_BORDERS 0]]

set NUM_BINS [expr int(ceil($BIN_RANGE / $BIN_SIZE)) + 1]
for {set ts 0} {$ts < $NUM_BINS} {incr ts} {
  set dist [expr $ts * $BIN_SIZE]
  animate dup $TESTMOL
  pbc set "100 100 100 90 90 90"
  set coords1 {"0 0 0"}
  set coords2 [list "$dist 0 0"]
  $sel1 set {x y z} $coords1
  $sel2 set {x y z} $coords2
}