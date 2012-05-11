public class ObjectCollection {
  private Interactive fSelected;
  private ArrayList<Interactive> fObjs, fSelectedObjs, fControls;
  private ArrayList<Path> fPaths;
  private ArrayList<Path> fDendrites;
  private int fInitiatorIndex, fSomaIndex, fAxonIndex, fSynapseIndex, fDendriteIndex;

  private PVector fSelectStart, fSelectEnd;

  public ObjectCollection() {
    fControls = new ArrayList<Interactive>();
    reset();
  }

  private void drawSelection() {
    if (fSelectStart != null && fSelectEnd != null) {
      pushStyle();
      stroke(Constants.SELECTION_BORDER_COLOR);
      strokeWeight(Constants.SELECTION_BORDER_WIDTH);
      fill(Constants.SELECTION_COLOR);
      PVector size = PVector.sub(fSelectEnd, fSelectStart);
      rect(fSelectStart.x, fSelectStart.y, size.x, size.y);
      popStyle();
    }
  }

  public void draw() {
    int l = fObjs.size();
    // Using draw for now
    // for (Path p : fDendrites)
    //   p.draw();
    // for (int i = fDendriteIndex; i < l; i++)
    //   fObjs.get(i).drawBackground();
    // for (int i = fDendriteIndex; i < l; i++)
    //   fObjs.get(i).drawForeground();
    for (Interactive s : fObjs)
      s.draw();
    if (fSelectStart != null && fSelectEnd != null) {
      drawSelection();
    }
  }
  public void drawAndUpdate() {
    for (Interactive s : fObjs)
      s.update();
    draw();
  }

  public boolean select(float x, float y) {
    deselectAll();
    for (int i = fObjs.size()-1; i>=0; i--) {
      Interactive s = fObjs.get(i);
      if (s.select(x, y) && s.fVisible) {
        fSelected = s;
        return true;
      }
    }
    return false;
  }

  public void showControls() {
    for (Interactive s : fSelectedObjs) {
      if (s.getType() == Constants.INITIATOR ||
          s.getType() == Constants.SOMA)
          ((Controllable)s).showControls();
    }
  }

  public void hideControls() {
    for (Interactive s : fSelectedObjs) {
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
      int index = fObjs.size();
      switch(s.getType()) {
        case Constants.DENDRITE:
          index = (index == -1) ? fDendriteIndex : index;
          fDendriteIndex++;
          fDendrites.add((Path)s);
        case Constants.AXON:
          index = (index == -1) ? fAxonIndex : index;
          fAxonIndex++;
          // Falls through so this is executed for bouth AXON and DENDRITE
          fPaths.add((Path)s);
        case Constants.SYNAPSE:
          index = (index == -1) ? fSynapseIndex : index;
          fSynapseIndex++;
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

  public void addControl(Interactive s) {
    fControls.add(s);
    add(s);
  }

  public void remove(Interactive s) {
    // TODO: check for off by 1 error
    if (s != null) {
      switch(s.getType()) {
        case Constants.DENDRITE:
          fDendriteIndex--;
        case Constants.AXON:
          fAxonIndex--;
        case Constants.SYNAPSE:
          fSynapseIndex--;
        case Constants.SOMA:
          fSomaIndex--;
        case Constants.INITIATOR:
          fInitiatorIndex--;
      }

      switch(s.getType()) {
        case Constants.AXON:
          remove((Interactive)((Path)s).getDest());
        case Constants.DENDRITE:
          Path path = (Path)s;
          ArrayList<Path> paths = path.getConnectedPaths();
          for (Path p : paths)
            remove((Interactive)p);
          break;
        case Constants.SYNAPSE:
          Synapse ss = (Synapse)s;
          remove((Interactive)(ss.getDendrite()));
          break;
        case Constants.SOMA:
        case Constants.INITIATOR:
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

  public void reset() {
    fObjs = new ArrayList<Interactive>();
    fPaths = new ArrayList<Path>();
    fDendrites = new ArrayList<Path>();
    fSelectedObjs = new ArrayList<Interactive>();
    fSelected = null;
    fInitiatorIndex = 0;
    fSomaIndex = 0;
    fAxonIndex = 0;
    fSynapseIndex = 0;
    fDendriteIndex = 0;

    fSelectStart = fSelectEnd = null;

    // Adde controls back
    fObjs.addAll(fControls);
    fSelectedObjs.addAll(fControls);
  }

  private void resetSelection() {
    hideControls();
    fSelectedObjs = new ArrayList<Interactive>();
    fSelectedObjs.addAll(fControls);
  }

  public void beginSelection(float x, float y) {
    resetSelection();
    fSelectStart = new PVector(x, y);
    fSelectEnd = new PVector(x, y);
  }

  public void updateSelection(float x, float y) {
    fSelectEnd.set(x, y, 0);
  }

  public boolean endSelection(float x, float y) {
    fSelectEnd.set(x, y, 0);
    PVector minCoord = new PVector(min(fSelectStart.x, fSelectEnd.x), min(fSelectStart.y, fSelectEnd.y));
    PVector maxCoord = new PVector(max(fSelectStart.x, fSelectEnd.x), max(fSelectStart.y, fSelectEnd.y));
    for (Interactive s : fObjs) {
      switch(s.getType()) {
        case Constants.SOMA:
        case Constants.INITIATOR:
          PVector p = s.getLoc();
          if (p.x >= minCoord.x && p.y >= minCoord.y &&
              p.x <= maxCoord.x && p.y <= maxCoord.y) {
            fSelectedObjs.add(s);
            ((Controllable)s).showControls();
          }
          break;
        case Constants.DENDRITE:
        case Constants.SYNAPSE:
        case Constants.AXON:
          break;
      }
    }
    fSelectStart = fSelectEnd = null;
    // Account for controls since they are always in selected
    boolean selected = (fSelectedObjs.size() - fControls.size()) != 0;
    for (Interactive i : fControls)
      i.setVisible(selected);
    return selected;
  }
  private void syncAttributes(Interactive curr) {
    for (Interactive s : fSelectedObjs) {
      if (curr != s && curr.getType() == s.getType() &&
        (curr.getType() == Constants.SOMA || curr.getType() == Constants.INITIATOR)) {
        ((Cell)s).copyAttributes((Cell)curr);
      }
    }
  }
  public boolean onMouseDown(float x, float y, int key, int keyCode) {
    for (int i = fObjs.size()-1; i>=0; i--) {
      Interactive curr = fObjs.get(i);
      if (curr.onMouseDown(x, y)) {
        if (curr.getType() == Constants.INITIATOR || curr.getType() == Constants.SOMA) {
          if (!fSelectedObjs.contains(curr) && curr.fVisible) {
              fSelectedObjs.add(curr);
              ((Controllable)curr).showControls();
              for (Interactive ii : fControls)
                ii.setVisible(true);
          }
          else if (key == CODED && keyCode == ALT) {
              fSelectedObjs.remove(curr);
              ((Controllable)curr).hideControls();
          }
        }
        return true;
      }
    }
    if (!(key == CODED && keyCode == SHIFT))
      resetSelection();
    for (Interactive i : fControls)
      i.setVisible(false);
    return false;
  }
  public boolean onMouseDragged(float x, float y) {
    for (int i = fObjs.size()-1; i>=0; i--) {
      Interactive curr = fObjs.get(i);
      if (curr.fVisible && curr.onMouseDragged(x, y)) {
        syncAttributes(curr);
        return true;
      }
    }
    return false;
  }
  public boolean onMouseMoved(float x, float y) {
    for (int i = fObjs.size()-1; i>=0; i--) {
      Interactive curr = fObjs.get(i);
      if (curr.fVisible && curr.onMouseMoved(x, y))
        return true;
    }
    return false;
  }
  public boolean onMouseUp(float x, float y) {
    for (int i = fObjs.size()-1; i>=0; i--) {
      Interactive curr = fObjs.get(i);
      if (curr.fVisible && curr.onMouseUp(x, y)) {
        return true;
      }
    }
    return false;
  }
  public boolean onDblClick(float x, float y) {
    for (int i = fObjs.size()-1; i>=0; i--) {
      Interactive curr = fObjs.get(i);
      if (curr.fVisible && curr.onDblClick(x, y))
        return true;
    }
    return false;
  }

  public boolean onSmoothToggle(boolean smooth) {
    for (int i = fObjs.size()-1; i>=0; i--) {
      Interactive curr = fObjs.get(i);
      if (curr.fVisible && curr.onSmoothToggle(smooth))
        return true;
    }
    return false;
  }
}