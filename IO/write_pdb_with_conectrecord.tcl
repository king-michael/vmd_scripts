
# http://www.bmsc.washington.edu/CrystaLinks/man/pdb/part_69.html
# COLUMNS         DATA TYPE        FIELD           DEFINITION
#  1 -  6         Record name      "CONECT"
#  7 - 11         Integer          serial          Atom serial number
# 12 - 16         Integer          serial          Serial number of bonded atom
# 17 - 21         Integer          serial          Serial number of bonded atom
# 22 - 26         Integer          serial          Serial number of bonded atom
# 27 - 31         Integer          serial          Serial number of bonded atom
# 32 - 36         Integer          serial          Serial number of hydrogen bonded atom
# 37 - 41         Integer          serial          Serial number of hydrogen bonded atom
# 42 - 46         Integer          serial          Serial number of salt bridged atom
# 47 - 51         Integer          serial          Serial number of hydrogen bonded atom
# 52 - 56         Integer          serial          Serial number of hydrogen bonded atom
# 57 - 61         Integer          serial          Serial number of salt bridged atom


proc write_pdb_with_conect {fname {molid top}} {
  # function to write the connect record for bonded atoms.
  
  # create pdb file
  set now [molinfo top get frame]
  animate write pdb $fname beg $now end $now $molid
  
  set sel [atomselect $molid all]

  set f [open $fname {WRONLY CREAT APPEND}] ;# instead of "a"
  
  foreach bond [$sel getbonds] i [$sel list] {
    if {[llength $bond]} {
      set str [format "%6s%5i" "CONECT" [incr i]]
      foreach b $bond {
        set str [format "$str%5i" [incr b]]
      }
      puts $f $str
    }
  }
  
  close $f
}
