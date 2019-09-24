# utilities
scripts adding usefull features to VMD

## render_transparent.tcl
function to render pictures with transparent background
* ```render_trans ?RENDER_TYPE? ?FILENAME? ?RENDER_OPTIONS?``` <br>
  Creates a file with ```FILENAME```**.png** <br>
  The ```FILENAME``` must contain the extension required for the ```RENDER_TYPE```. <br>
  default: ```render_trans snapshot vmdscene.tga```
  * example: ```render_trans TachyonLOptiXInternal vmdscene.ppm```
  
