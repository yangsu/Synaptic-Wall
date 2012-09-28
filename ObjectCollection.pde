public class ObjectCollection extends Collection {
  private ArrayList<Path> fAxons, fDendrites;
  private ArrayList<Soma> fSomas;
  private ArrayList<Initiator> fInitiators;
  private ArrayList<Synapse> fSynapses;

  public ObjectCollection() {
    fAxons = new ArrayList<Path>();
    fDendrites = new ArrayList<Path>();
    fSomas = new ArrayList<Soma>();
    fSynapses = new ArrayList<Synapse>();
    fInitiators = new ArrayList<Initiator>();
  }

  public void add(Interactive s) {
    if (s != null) {
      switch(s.getType()) {
        case Constants.DENDRITE:
          fDendrites.add((Dendrite)s);
          break;
        case Constants.AXON:
          fAxons.add((Axon)s);
          break;
        case Constants.SYNAPSE:
          fSynapses.add((Synapse)s);
          break;
        case Constants.SOMA:
          fSomas.add((Soma)s);
          break;
        case Constants.INITIATOR:
          fInitiators.add((Initiator)s);
          break;
      }
      fObjs.add(s);
    }
  }

  public void remove(Interactive s) {
    if (s != null) {
      switch(s.getType()) {
        case Constants.AXON:
          fAxons.remove((Axon)s);
        case Constants.DENDRITE:
          fDendrites.remove((Dendrite)s);
          remove((Interactive)((Path)s).getDest());
          Path path = (Path)s;
          ArrayList<Path> paths = path.getConnectedPaths();
          for (Path p : paths)
            remove((Interactive)p);
          break;
        case Constants.SYNAPSE:
          fSynapses.remove((Synapse)s);
          Synapse ss = (Synapse)s;
          remove((Interactive)(ss.getDendrite()));
          break;
        case Constants.SOMA:
          fSomas.remove((Soma)s);
        case Constants.INITIATOR:
          fInitiators.remove((Initiator)s);
          Cell cell = (Cell)s;
          ArrayList<Path> axons = cell.getAxons();
          for (Path p : axons)
            remove((Interactive)p);
          ArrayList<Path> dendrites = cell.getDendrites();
          for (Path p : dendrites)
            remove((Interactive)p);
          break;
      }
      fObjs.remove(s);
    }
  }

  public boolean onMouseDown(float x, float y, int key, int keyCode) {
    for (int i = fObjs.size()-1; i>=0; i--) {
      Interactive curr = fObjs.get(i);
      if (curr.onMouseDown(x, y)) {
        if (curr.getType() == Constants.INITIATOR || curr.getType() == Constants.SOMA) {
          if (!fSelectedObjs.contains(curr) && curr.fVisible) {
            fSelectedObjs.add(curr);
            // @TODO: using selec to set selected state and trigger corresponding changes
            curr.select(x, y);
          }
          else if (key == CODED && keyCode == ALT) {
            fSelectedObjs.remove(curr);
          }
        }
        return true;
      }
    }
    // if (!(key == CODED && keyCode == SHIFT))
    return false;
  }

  public boolean onMouseDragged(float x, float y) {
    for (int i = fObjs.size()-1; i>=0; i--) {
      Interactive curr = fObjs.get(i);
      if (curr.fVisible && curr.onMouseDragged(x, y)) {
        // syncAttributes(curr);
        return true;
      }
    }
    return false;
  }
}