public class Collection {
  protected ArrayList<Interactive> fObjs, fSelectedObjs;
  protected Interactive fSelected;

  public Collection() {
    reset();
  }

  public void reset() {
    fObjs = new ArrayList<Interactive>();
    resetSelection();
  }

  public void resetSelection() {
    fSelectedObjs = new ArrayList<Interactive>();
  }

  public void draw() {
    for (Interactive s : fObjs)
      s.draw();
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

  public void deselectAll() {
    fSelected = null;
    for (Interactive s : fObjs)
      s.deselect();
  }

  public Interactive getSelected() {
    return fSelected;
  }

  public void add(Interactive s) {
    fObjs.add(s);
  }

  public void remove(Interactive s) {
    fObjs.remove(s);
  }

  public boolean selectArea(PVector minCoord, PVector maxCoord) {
    PVector p;

    for (Interactive s : fObjs) {
      p = s.getLoc();
      if (p.x >= minCoord.x && p.y >= minCoord.y &&
          p.x <= maxCoord.x && p.y <= maxCoord.y) {
        fSelectedObjs.add(s);
      }
    }

    return fSelectedObjs.size() != 0;
  }

  public boolean onMouseDown(float x, float y) {
    for (int i = fObjs.size()-1; i>=0; i--) {
      Interactive curr = fObjs.get(i);
      if (curr.fVisible && curr.onMouseDown(x, y)) {
        return true;
      }
    }
    return false;
  }

  public boolean onMouseDragged(float x, float y) {
    for (int i = fObjs.size()-1; i>=0; i--) {
      Interactive curr = fObjs.get(i);
      if (curr.fVisible && curr.onMouseDragged(x, y)) {
        return true;
      }
    }
    return false;
  }

  public boolean onMouseMoved(float x, float y) {
    for (int i = fObjs.size()-1; i>=0; i--) {
      Interactive curr = fObjs.get(i);
      if (curr.fVisible && curr.onMouseMoved(x, y)) {
        return true;
      }
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
      if (curr.fVisible && curr.onDblClick(x, y)) {
        return true;
      }
    }
    return false;
  }

  public boolean onSmoothToggle(boolean smooth) {
    for (int i = fObjs.size()-1; i>=0; i--) {
      Interactive curr = fObjs.get(i);
      if (curr.fVisible && curr.onSmoothToggle(smooth)) {
        return true;
      }
    }
    return false;
  }
}