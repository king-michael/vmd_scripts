# Python implementations for VMD
## requirements
* only tested with `python2.7` and `vmd_1.9.4beta`!

## helper_functions.tcl
### usage:
```
source helper_functions.tcl
```
### Functions
* `set_python_sys ARGV` <br>
function to set the sys.argv for python
    * **usage:** <br>
        ```
        set_python_sys ?ARGV?"
        ```
    * **example:**
        ```
        set_python_sys {-p 1 -t \"Das ist ein test\" -q}"
        ```

* `run_python SCRIPT ?ARGV?` <br>
function to run a python script with command line arguments
    * **usage:** <br>
        ```
        set_python_sys ?ARGV?"
        ```
    * **example:**
        ```
        run_python test_sysargs.py {-p 1 -t \"Das ist ein test\" -q}"

        run_python test_sysargs.py"
        ```

## live_fes.py
### usage:
First load the script, then use ``run()`` to load and connect your files.

**Load the script**:
```
gopython live_fes.py
```

**start the command**:
```
gopython -command "run('analysis/fes.dat', 'analysis/COLVAR')"
```

### important functions

* `run(fes_file='fes.dat', colvar='COLVAR')` <br>
    Plots a `fes.dat` file and
    connects the current ``vmd_frame`` with the ``COLVAR`` file.
    This allows to live trace where the structe currently is.
