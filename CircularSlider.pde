class CircularSlider extends Control {
  float fSize, fValue;
  float fBegin, fEnd, fCurr;
  boolean fHover, fSelected;
  
  int fState;
  static final int SLIDER = 0;
  static final int BEGIN = 1;
  static final int END = 2;
  CircularSlider(float x, float y, float size) {
    super(x,y);
    fSize = size;
    fCurr = fBegin = HALF_PI;
    fEnd = 3 * HALF_PI;
    fState = SLIDER;
  }
  CircularSlider(float x, float y, float size, float begin, float end) {
    this(x, y, size);
    fCurr = fBegin = begin;
    fEnd = end;
  }
  
  float getValue() {
    return fValue;
  }
  
  void draw() {
    if (!fVisible) return;
    float temp = fSize + Constants.SLIDER_BAR_WIDTH;
    
    fill(Constants.SLIDER_BG_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, fBegin, fEnd);
    fill(Constants.SLIDER_BAR_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, 
        constrain(fCurr - Constants.SLIDER_LENGTH, fBegin, fEnd), 
        constrain(fCurr + Constants.SLIDER_LENGTH, fBegin, fEnd));
    fill(Constants.EX_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, fBegin, fBegin + Constants.SLIDER_HANDLE_WIDTH);
    fill(Constants.IN_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, fEnd - Constants.SLIDER_HANDLE_WIDTH, fEnd);
    fill(Constants.BG_COLOR);
    ellipse(fLoc.x, fLoc.y, fSize, fSize);
  }
  
  boolean isInBounds(float x, float y) {
    boolean inBounds = true;
    float dist = PVector.dist(fLoc, new PVector(x, y));    
    float angle = Utilities.getAngleNorm(fLoc.x, fLoc.y, x, y);
    if (angle >= fEnd - Constants.SLIDER_HANDLE_WIDTH && angle <= fEnd)
      fState = END;
    else if (angle >= fBegin && angle <= fBegin + Constants.SLIDER_HANDLE_WIDTH)
      fState = BEGIN;
    else if (angle < fEnd && angle > fBegin)
      fState = SLIDER;
    else
      inBounds = false;
    return inBounds && dist >= fSize && dist <= fSize + Constants.SLIDER_BAR_WIDTH;
  }
  
  boolean onMouseDown(float x, float y) {
    return fSelected = isInBounds(x, y);
  }
  
  boolean onMouseDragged(float x, float y) {
    if (fSelected) {
      float angle = Utilities.getAngleNorm(fLoc.x, fLoc.y, x, y);
      switch (fState) {
        case SLIDER:
          fCurr = angle;
          break;
        case BEGIN:
          println("BEGIN "+angle);
          fBegin = constrain(angle, 0.0, PI);
          break;
        case END:
          println("END "+angle);
          fEnd = constrain(angle, PI, TWO_PI);
          break;
      }
      fCurr = constrain(fCurr, 
                        fBegin + Constants.SLIDER_HANDLE_WIDTH + Constants.SLIDER_LENGTH, 
                        fEnd - Constants.SLIDER_HANDLE_WIDTH - Constants.SLIDER_LENGTH);
      return fSelected;
    }
    return false;
  }
  
  boolean onMouseMoved(float x, float y) {
    return (fHover = isInBounds(x, y));
  }
  
  boolean onMouseUp(float x, float y) {
    return (fSelected = fHover = false);
  }
}