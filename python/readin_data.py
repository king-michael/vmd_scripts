# imports
import numpy as np
from VMD import evaltcl
from AtomSel import AtomSel

def load_assign_data(cond, npyfile):
    """
    Function to load and assign data
    Parameters
    ----------
    cond : str
        VMD selection string
    npyfile : str
        path to numpy `.npy` file.

    Returns
    -------

    """
    # get number of frames
    n_frames = int(evaltcl('molinfo top get numframes'))
    # read in data
    data = np.load(npyfile)
    if n_frames != data.shape[0]:
        print "something is off"
    # create atomselection and assign data
    sel = AtomSel(cond)
    for n in range(n_frames):
        sel.frame(n)
        sel.set('user', data[n, :].tolist())

if __name__ == "__main__":
    # input
    load_assign_data("type CAL CO", "cluster_id.npy")