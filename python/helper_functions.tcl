
#=============================================================================#
# set_python_sys ARGV
#=============================================================================#

proc set_python_sys {{ARGV ""}} {
  # function to set the sys.argv for python
  set OUTPUT ""
  for {set i 0} {$i < [llength $ARGV]} {incr i} {
    set v [lindex $ARGV $i]
    if {$i > 0} {set OUTPUT "${OUTPUT} , "}
    set OUTPUT "${OUTPUT} '$v'"
  }
  set cmd "import sys; sys.argv=list((${OUTPUT}))"
  gopython -command "$cmd"
}
vmdcon -info "procedure to to set python sys.argv" 
vmdcon -info "use:"
vmdcon -info "  set_python_sys ?ARGV?"
vmdcon -info " example:"
vmdcon -info "  set_python_sys {-p 1 -t \"Das ist ein test\" -q}"

#=============================================================================#
# run_python SCRIPT ?ARGV?
#=============================================================================#

proc run_python {SCRIPT {ARGV ""}} {
  # function to run a python script with command line arguments
  set OUTPUT "'${SCRIPT}'"
  for {set i 0} {$i < [llength $ARGV]} {incr i} {
    set v [lindex $ARGV $i]
    set OUTPUT "${OUTPUT}, '$v'"
  }
  set cmd "import sys; sys.argv=\[${OUTPUT}\]"
  gopython -command "$cmd"
  gopython $SCRIPT
}
vmdcon -info "procedure to run a python script with sys.argv" 
vmdcon -info "use:"
vmdcon -info "  set_python_sys ?ARGV?"
vmdcon -info "examples:"
vmdcon -info "  run_python test_sysargs.py {-p 1 -t \"Das ist ein test\" -q}"
vmdcon -info "  run_python test_sysargs.py"

