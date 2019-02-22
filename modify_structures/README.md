# Info
Scripts and programs around modifying and creating structures.

# Files

### `create_dummy_trajectory.tcl` <br>
Script to create a dummy trajectory
of two particles moving apart each other.
Useful to test `switchingfunctions` with `PLUMED`.

### `repair_bonds.tcl`
function to repair bonds (if the bond goes over the periodic boundary)
* ``repair_bonds ?ARGS?`` <br>
  procedure to repair bonds (if the bond goes over the periodic boundary) <br>
  with ?ARG?:
    * ``-dist=`` set critical distance when to wrap repair a bond (default is ``-1``, meaning half the box length)
    * ``-verbose`` turn on verbosity (default is ``-1``)
    * ``-precision`` precision of rounding error
  * ``traj_repair_bonds`` <br>
    procedure to apply ``repair_bonds`` on the whole trajectory
