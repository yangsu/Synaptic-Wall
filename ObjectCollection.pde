public class ObjectCollection {
  Interactive fSelected;
  ArrayList<Interactive> fObjs;

  public ObjectCollection() {
    fSelected = null;
    fObjs = new ArrayList<Interactive>();
  }

  public void draw() {
    for (Interactive s : fObjs)
      s.draw();
  }

  public boolean select(float x, float y) {
    this.deselectAll();
    for (Interactive s : fObjs) {
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
    if (s != null)
      fObjs.add(s);
  }

  public void remove(Interactive s) {
    if (s != null)
      fObjs.remove(s);
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
}