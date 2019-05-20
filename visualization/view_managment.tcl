# VMD Scripts
# Details:
#   VMD scripts around view management
# Procedures:
#   set_view ?molid? ?center?
#     set the view so that the whole box fits in


proc set_view {{molid top} {center "box"}} {
  # proc to set the view so that the whole box fits in
  # parameter :
  # - molid : Used molecule. Defaults is top.
  # - center : What selection to use for center. "box" uses the pbc box. Default is "box".

  lassign {*}[pbc get -molid $molid] a b c alpha beta gamma
  if {$center == "box"} {
    lassign [vecscale 0.5 "$a $b $c"] ca cb cc
  } else {
    set sel [atomselect $molid $center]
    lassign [measure center $sel] ca cb cc
    $sel delete
  }
  set sf 2.8; # scaling factor
  set s [expr max($sf/$a,$sf/$b,$sf/$c)]
  molinfo $molid set {center_matrix rotate_matrix scale_matrix global_matrix} [list \
    [list "1 0 0 -$ca" "0 1 0 -$cb" "0 0 1 -$cc" {0 0 0 1}] \
    {{1 0 0 0} {0 1 0 0} {0 0 1 0} {0 0 0 1}} \
    [list "$s 0 0 0" "0 $s 0 0" "0 0 $s 0" {0 0 0 1}] \
    {{1 0 0 0} {0 1 0 0} {0 0 1 0} {0 0 0 1}} \
  ]
}

proc set_view_nice {{molid top} {center "box"}} {
  # proc to set the view so that the whole box fits in and rotates the box nicely
  # parameter :
  # - molid : Used molecule. Defaults is top.
  # - center : What selection to use for center. "box" uses the pbc box. Default is "box".
  set_view top "not water";
  rotate y by -10;
  rotate x by 10;
  scale by 0.833333;
  display nearclip set 0.010000
}


