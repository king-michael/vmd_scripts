
# Files
## ss_fix.tcl
Function to fix the `ss_cache` problem in `VMD`
 when overlaying multiple molecules
```
the secondary structure is NOT updated when
displaying multiple time steps at once
```

this file provides a work around

### usage

#### in short for the lazy
1.) Create the representation you want

2.) Load the script:<br>
`source LOCATION_OF_THE_SCRIPT/tcl_procs_ss_fix.tcl`

3.) Run the procedure:<br>
`::ssplots::createmols_fast`

#### in longer
##### load the script
`source LOCATION_OF_THE_SCRIPT/ss_fix.tcl`

##### general usage
```
  ::ssplots::info
      - prints this message

  ::ssplots::createmols ?molid?
      - create mols from trajectory

  ::ssplots::createmols_fast ?molid?
      - create mols from trajectory (all in one mol, may not work with selections using residue)

  ::ssplots::deletemols
      - delete mols (clean up after picture)

  ::ssplots::showmols
      - show mols

  ::ssplots::hidemols
      - hide mols

  ::ssplots::updatemols
      - update representations based on the original mol
 ```

### known BUGS:
 - **untested** proc was not tested for multiple representations (comment out the line if you want to use it)
 - **bug** slow performance for a lot of mols
