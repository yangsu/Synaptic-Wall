abstract class Drawable {
  color fColor;
  
  boolean fVisible;
  boolean fSelected;
  boolean fHover;
  
  Drawable() {
    fVisible = true;
    fSelected = fHover = false;
  }
  
  abstract void draw();
  
  void setVisible(boolean visible) { fVisible = visible; }
 
  boolean isInBounds(float x, float y) { return false; }
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
    return (fSelected = fHover = false);
  }
}