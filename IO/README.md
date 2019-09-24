# IO - based functions
  
## write_pdb_with_conectrecord.tcl
function to write a pdb with **CONECT** record (**only for bonded atoms!**)
* ```write_pdb_with_conect FILENAME ?MOLID?``` <br>
  Creates a pdb file with ```FILENAME``` of molecule ```?MOLID?``` with the **CONNECT** record for the bonded atoms <br>
  default: ```write_pdb_with_conect filename top```
  * example: ```write_pdb_with_conect test.pdb ```
  * example: ```write_pdb_with_conect test.pdb top```
  * example: ```write_pdb_with_conect test.pdb 0```

  
## `read_user_files.tcl`
Functions to read files from users into VMD
* `get_column_of_file filename {column 0}` <br>
    Function to read a column from a file

* `read_cluster_per_frame {filename {property user} {value 1} {molid top}}` <br>
  Reads a file with atom ID per line, assigns for all atomID's in this line the `value` to `prorpery`. <br>
  example: `read_cluster_per_frame ./atoms_in_cluster_frame-0_dp-0.32.dat user 1 top`
  
 * `read_file_to_atoms {filename args}` <br>
  Reads a file with atom ID per line, assigns for all atomID's in this line the `value` to `prorpery`. <br>
  example: `read_file_to_atoms ${pairfile} -stride $stride` <br>
  Keywords
    * `property` : property to store `value` in. Default is `user`
    * `value` : value to store in `property`
    * `molid` : molid of the used molecule
    * `stride` : use a stride on the data
       
  