# utilities
scripts adding usefull features to VMD

## render_transparent.tcl
function to render pictures with transparent background
* ```render_trans ?RENDER_TYPE? ?FILENAME? ?RENDER_OPTIONS?``` <br>
  Creates a file with ```FILENAME```**.png** <br>
  The ```FILENAME``` must contain the extension required for the ```RENDER_TYPE```. <br>
  default: ```render_trans snapshot vmdscene.tga```
  * example: ```render_trans TachyonLOptiXInternal vmdscene.ppm```
  
## write_pdb_with_conectrecord.tcl
function to write a pdb with **CONECT** record (**only for bonded atoms!**)
* ```write_pdb_with_conect FILENAME ?MOLID?``` <br>
  Creates a pdb file with ```FILENAME``` of molecule ```?MOLID?``` with the **CONNECT** record for the bonded atoms <br>
  default: ```write_pdb_with_conect filename top```
  * example: ```write_pdb_with_conect test.pdb ```
  * example: ```write_pdb_with_conect test.pdb top```
  * example: ```write_pdb_with_conect test.pdb 0```
