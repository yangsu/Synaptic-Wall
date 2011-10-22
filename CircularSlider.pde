class CircularSlider extends Control {
  float fSize, fWidth;
  float fBegin, fEnd, fCurr;
  boolean fHover, fSelected;
  CircularSlider(int x, int y, float size, float width) {
    super(x,y);
    fSize = size;
    fWidth = width;
    fCurr = fBegin = 0;
    fEnd = TWO_PI;
  }
  CircularSlider(int x, int y, float size, float width, float begin, float end) {
    this(x, y, size, width);
    fCurr = fBegin = begin;
    fEnd = end;
  }
  
  void draw() {
    if (!fVisible) return;
    fCurr = constrain(fCurr, fBegin, fEnd);
    float temp = fSize + fWidth;
    
    fill(Contants.SLIDER_BG_COLOR);
    ellipse(fLoc.x, fLoc.y, temp, temp);
    fill(Contants.SLIDER_BAR_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, fBegin, fCurr);
    fill(Contants.BG_COLOR);
    ellipse(fLoc.x, fLoc.y, fSize, fSize);
  }
  
  boolean isInBounds(float x, float y) {
    return false;
  }
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