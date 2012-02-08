public class ObjectCollection {
  Interactive fSelected;
  ArrayList<Interactive> fObjs;

  ObjectCollection() {
    fSelected = null;
    fObjs = new ArrayList<Interactive>();
  }
  
  void draw() {
    for (Interactive s : fObjs)
      s.draw();
  }
  
  boolean select(float x, float y) {
    this.deselectAll();
    for (Interactive s : fObjs) {
      if (s.select(x, y)) {
        fSelected = s;
        //Move Object to the end of the list
        // fObjs.remove(fSelected);
        // fObjs.add(fSelected);
        return true;
      }
    }
    return false;
  }
  
  void deselectAll() {
    fSelected = null;
    for (Interactive s : fObjs)
      s.deselect();
  }

  Interactive getSelected() {
    return fSelected;
  }
  
  void add(Interactive s) {
    if (s != null)
      fObjs.add(s);
  }

  void remove(Interactive s) {
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