abstract class Drawable {
  color fColor;
  
  boolean fVisible;
  boolean fSelected;
  boolean fHover;
  
  Drawable() {
    fVisible = true;
  }
  
  abstract void draw();
  
  void setVisible(boolean visible) { fVisible = visible; }
  
  abstract boolean onMouseDown(float x, float y);
  abstract boolean onMouseDragged(float x, float y);
  abstract boolean onMouseMoved(float x, float y);
  abstract boolean onMouseUp(float x, float y);
}