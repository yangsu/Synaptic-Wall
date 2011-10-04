abstract class Shape extends Animatable implements Interactive, Drawable {
  PVector fLoc;
  float fSize;
  color fColor;
  boolean fSelected;
  
  Shape() {
    fLoc = new PVector(0, 0);
    fSize = 0;
    fColor = color(0);
    fSelected = false;
  }
  
  Shape(float x, float y, float size, color cc) {
    fLoc = new PVector(x, y);
    fSize = size;
    fColor = cc;
  }
  
  abstract boolean isInBounds(float x, float y);
  float x() { return fLoc.x; }
  float y() { return fLoc.y; }  
  void setXY(float x, float y) { fLoc.set(x, y, 0); }
  
  boolean onMouseDown(float x, float y) {
    return false;
  }
  boolean onMouseDragged(float x, float y) {
    return false;
  }
  boolean onMouseMoved(float x, float y) {
    return false;
  }
  boolean onMouseUp(float x, float y) {
    return false;
  }
}