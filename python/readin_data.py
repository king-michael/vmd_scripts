# imports
import numpy as np
from VMD import evaltcl
from AtomSel import AtomSel

def load_assign_data(cond, npyfile):
    """
    Function to load and assign data.

    Parameters
    ----------
    cond : str
        VMD selection string
    npyfile : str
        path to numpy `.npy` file.
    """
    # get number of frames
    n_frames = int(evaltcl('molinfo top get numframes'))
    # read in data
    data = np.load(npyfile)
    if n_frames != data.shape[0]:
        print("something is off")
    # create atomselection and assign data
    sel = AtomSel(cond)
    for n in range(n_frames):
        sel.frame(n)
        sel.set('user', data[n, :].tolist())


def expand_data_to_residue(condition, column='user', n_frames=None):
  """
  Function to expand the data stored in column from a per atom data to a per residue data.

  Parameter
  ---------
  condition : str
    condition string to select the atomselect containing the data
  column : str, optional
    column where the data is stored. Default is `'user'`.
  n_frames : int or None, optional
    Number of frames to consinder. If `None` all frames are taken.
    Default is `None`

  Example
  -------
  >>> expand_data_to_residue(condition='type OW', column='user', n_frames=100)
  """
  # get number of frames
  if n_frames is None:
    n_frames = int(evaltcl('molinfo top get numframes'))

  sel_data = AtomSel(condition)
  residue = sel_data.get('residue')
  sel_residues = AtomSel('same residue as ({})'.format(condition))
  # get the list of resdiue IDs
  list_residues = sel_residues.get('residue')
  # create a dictionay with the counts per residue
  dict_counts = dict(np.array(np.unique(list_residues, return_counts=True)).T)
  # get the counts (keep order of the residues as in sel !)
  counts_residues = np.vectorize(dict_counts.__getitem__)(residue)

  for n in range(n_frames):
      sel_data.frame(n)
      sel_residues.frame(n)
      data = sel_data.get(column)
      data_residue = np.repeat(data, counts_residues)
      sel_residues.set(column, data_residue.tolist())


if __name__ == "__main__":
    # input
    load_assign_data("type CAL CO", "cluster_id.npy")