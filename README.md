# vmd_scripts
various vmd scripts

# Overview

## modify_structures
scripts to modify structures
### repair_bonds.tcl
function to repair bonds (if the bond goes over the periodic boundary)
* ``repair_bonds ?ARGS?`` <br>
  procedure to repair bonds (if the bond goes over the periodic boundary) <br>
  with ?ARG?:
    * ``-dist=`` set critical distance when to wrap repair a bond (default is ``-1``, meaning half the box length)
    * ``-verbose`` turn on verbosity (default is ``-1``)
    * ``-precision`` precision of rounding error
  * ``traj_repair_bonds`` <br>
    procedure to apply ``repair_bonds`` on the whole trajectory
  
## python
scripts to control python from VMD or vice versa
### helper_functions.tcl
* ``set_python_sys ?ARGV?`` <br>
  procedure to set ``?ARGV?`` as ``sys.argv`` for python
* ``run_python SCRIPT ?ARGV?`` <br>
  procedure to run a python ``SCRIPT`` with ``?ARGV?`` as ``sys.argv``