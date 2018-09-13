
proc render_trans {{render_type snapshot} {filename vmdscene.tga} {render_options ""}} {
  # script to render pictures with transparent background
  
  # set render_type snapshot
  # set render_options "" ;# "display %s"
  # set filename vmdscene.tga

  # remove extension
  set path  [file dirname $filename]
  set fname [file rootname [file tail $filename]]
  set ext [file extension $filename]

  puts "render original"
  # render original
  render ${render_type} .tmp${ext} ${render_options}

  puts "save values"
  # init saved attributes
  set attrib_axes "X Y Z Origin Labels"
  set attrib_display "Background BackgroundTop BackgroundBot Foreground FPS"
  set attrib_lables "Atoms Bonds Angles Dihedrals Springs"

  # init sorate
  set old_background "";
  set old_axes ""; 
  set old_labels "";
  set old_molid_reps "";
  set old_light "";

  # save colors
  foreach attrib $attrib_display {lappend old_background [color Display $attrib]}
  foreach attrib $attrib_axes {lappend old_axes [color Axes $attrib]}
  foreach attrib $attrib_lables {lappend old_labels [color Labels $attrib]}
  # save lights
  for {set i 0} {$i <  [light num]} {incr i} {
    lappend old_light [light $i status]
  }
  # save reps per molid
  foreach molid [molinfo list] {
    set old_reps "";
    # get representations
    for {set i 0} {$i <  [molinfo top get numreps]} {incr i} {
      lappend old_reps [molinfo $molid get [list "selection $i" "rep $i" "color $i"]]
    }
  lappend old_molid_reps $old_reps 
  }

  #=====================================#
  # create Mask
  #=====================================#
  puts "create Mask"
  # set colors
  foreach attrib $attrib_display {color Display $attrib white}
  foreach attrib $attrib_axes {color Axes $attrib black}
  foreach attrib $attrib_lables {color Labels $attrib black}
  # turn of lights
  for {set i 0} {$i <  [light num]} {incr i} {light $i off}
  # black rep per molid
  foreach molid [molinfo list] {
    # make everything black
    for {set i 0} {$i <  [molinfo top get numreps]} {incr i} {
      mol modcolor $i $molid {ColorID 16}
    }
  }

  puts "render mask"
  render ${render_type} .tmp-S${ext} ${render_options}

  #=====================================#
  # reset values
  #=====================================#
  puts "reset values"
  # reset colors
  foreach attrib $attrib_display value $old_background {color Display $attrib $value}
  foreach attrib $attrib_axes value $old_axes {color Axes $attrib $value}
  foreach attrib $attrib_lables value $old_labels {color Labels $attrib $value}
  # reset lights
  for {set i 0} {$i <  [light num]} {incr i} {light $i [lindex $old_light $i 0]}
  # reset reps per molid
  foreach molid [molinfo list] old_reps $old_molid_reps {
    for {set i 0} {$i <  [molinfo top get numreps]} {incr i} {
      mol modcolor $i $molid [lindex $old_reps $i 2]
    }
  }

  #=====================================#
  # make it transparent
  #=====================================#
  puts "create transparent"
  #::ExecTool::exec convert .tmp-S${ext} -negate .tmp-M.png
  #::ExecTool::exec  convert .tmp${ext} .tmp-M.png -alpha off -compose copy-opacity -composite $fname.png
  ::ExecTool::exec convert .tmp${ext} \( .tmp-S${ext} -colorspace gray -negate \) -alpha off -compose copy_opacity -composite  $fname.png

  ::ExecTool::exec rm -f .tmp${ext} .tmp-S${ext}

}
puts "Use:"
puts " render_trans snapshot vmdscene.tga"
puts " render_trans TachyonLOptiXInternal vmdscene.ppm"
