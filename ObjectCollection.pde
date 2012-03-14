public class ObjectCollection {
  private Interactive fSelected;
  private ArrayList<Interactive> fObjs;
  private int fInitiatorIndex, fSomaIndex, fAxonIndex, fSynapseIndex, fDendriteIndex;

  public ObjectCollection() {
    fSelected = null;
    fObjs = new ArrayList<Interactive>();
    fInitiatorIndex = 0;
    fSomaIndex = 0;
    fAxonIndex = 0;
    fSynapseIndex = 0;
    fDendriteIndex = 0;
  }

  public void draw() {
    for (Interactive s : fObjs)
      s.draw();
  }

  public boolean select(float x, float y) {
    this.deselectAll();
    for (int i = fObjs.size()-1; i>=0; i--) {
      Interactive s = fObjs.get(i);
      if (s.select(x, y)) {
        fSelected = s;
        return true;
      }
    }
    return false;
  }

  public void showControls() {
    for (Interactive s : fObjs) {
      if (s.getType() == Constants.INITIATOR ||
          s.getType() == Constants.SOMA)
          ((Controllable)s).showControls();
    }
  }

  public void hideControls() {
    for (Interactive s : fObjs) {
      if (s.getType() == Constants.INITIATOR ||
          s.getType() == Constants.SOMA)
          ((Controllable)s).hideControls();
    }
  }

  public void deselectAll() {
    fSelected = null;
    for (Interactive s : fObjs)
      s.deselect();
  }

  public Interactive getSelected() {
    return fSelected;
  }

  public void add(Interactive s) {
    if (s != null) {
      int index = -1;
      switch(s.getType()) {
        case Constants.AXON:
          index = (index == -1) ? fAxonIndex : index;
          fAxonIndex++;
        case Constants.SYNAPSE:
          index = (index == -1) ? fSynapseIndex : index;
          fSynapseIndex++;
        case Constants.DENDRITE:
          index = (index == -1) ? fDendriteIndex : index;
          fDendriteIndex++;
        case Constants.SOMA:
          index = (index == -1) ? fSomaIndex : index;
          fSomaIndex++;
        case Constants.INITIATOR:
          index = (index == -1) ? fInitiatorIndex : index;
          fInitiatorIndex++;
      }
      fObjs.add(index, s);
    }
  }

  public void remove(Interactive s) {
    // TODO: check for off by 1 error
    if (s != null) {
      switch(s.getType()) {
        case Constants.AXON:
          fAxonIndex--;
        case Constants.SYNAPSE:
          fSynapseIndex--;
        case Constants.DENDRITE:
          fDendriteIndex--;
        case Constants.SOMA:
          fSomaIndex--;
        case Constants.INITIATOR:
          fInitiatorIndex--;
      }
      fObjs.remove(s);
    }
  }

  public boolean onMouseDown(float x, float y) {
    for (Interactive s : fObjs)
      if (s.onMouseDown(x, y))
        return true;
    return false;
  }
  public boolean onMouseDragged(float x, float y) {
    for (Interactive s : fObjs)
      if (s.onMouseDragged(x, y))
        return true;
    return false;
  }
  public boolean onMouseMoved(float x, float y) {
    for (Interactive s : fObjs)
      if (s.onMouseMoved(x, y))
        return true;
    return false;
  }
  public boolean onMouseUp(float x, float y) {
    for (Interactive s : fObjs)
      if (s.onMouseUp(x, y))
        return true;
    return false;
  }
  public boolean onDblClick(float x, float y) {
    for (Interactive s : fObjs)
      if (s.onDblClick(x, y))
        return true;
    return false;
  }
}