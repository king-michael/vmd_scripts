# utilities
scripts adding usefull features to VMD

## `render_transparent.tcl`
function to render pictures with transparent background
* ```render_trans ?RENDER_TYPE? ?FILENAME? ?RENDER_OPTIONS?``` <br>
  Creates a file with ```FILENAME```**.png** <br>
  The ```FILENAME``` must contain the extension required for the ```RENDER_TYPE```. <br>
  default: ```render_trans snapshot vmdscene.tga```
  * example: ```render_trans TachyonLOptiXInternal vmdscene.ppm```
  
## `sorting.tcl`
* `compare` <br>
    Normal compare function <br>
    example: `lsort -command compare {{15 15 2} {2.6 2.6 1} {2.6 2.6 3}} # => {{2.6 2.6 1} {2.6 2.6 3} {15 15 2}}`

* `compare_round` <br>
    Compare function that rounds the values <br>
    example: `lsort -command compare_round {{15 15 2} {2.6 2.7 1} {2.6 2.6 3}} # => {{2.6 2.7 1} {2.6 2.6 3} {15 15 2}}`
