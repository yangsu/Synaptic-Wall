abstract class Shape extends Drawable implements Signalable {
  PVector fLoc;
  color fColor;
  boolean fSelected;
  boolean fHover;
  float fSize;
  ArrayList<Path> fDendrites;
  ArrayList<Control> fControls;

  Shape() {
    fLoc = new PVector(0, 0);
    fSize = 0;
    fColor = color(0);
    fSelected = false;
    fDendrites = new ArrayList<Path>();
    fControls = new ArrayList<Control>();
  }
  
  Shape(float x, float y, float size, color cc) {
    fLoc = new PVector(x, y);
    fSize = size;
    fColor = cc;
  }
  
  void addDendrite(Path dendrite) {
    if (dendrite != null)
      fDendrites.add(dendrite);
  }
  
  float x() { return fLoc.x; }
  float y() { return fLoc.y; }  
  void setXY(float x, float y) { fLoc.set(x, y, 0); }
  
  abstract boolean isInBounds(float x, float y);
  boolean onMouseDown(float x, float y) {
    return (fSelected = isInBounds(x, y));
  }
  boolean onMouseMoved(float x, float y) {
    return (fHover = isInBounds(x, y));
  }
  boolean onMouseDragged(float x, float y) {
    return (fHover = isInBounds(x, y));
  }
  boolean onMouseUp(float x, float y) {
    return false;
  }
}