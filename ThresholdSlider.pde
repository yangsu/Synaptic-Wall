class ThresholdSlider extends CircularSlider { 
  static final int BEGIN = 1;
  static final int END = 2;
  
  ThresholdSlider(float x, float y, float size) {
    super(x, y, size);
  }
  
  ThresholdSlider(float x, float y, float size, float begin, float end) {
    super(x, y, size, begin, end);
  }
  
  ThresholdSlider(float x, float y, float size, float val, float min, float max) {
    super(x, y, size, val, min, max);
  }
  
  ThresholdSlider(float x, float y, float size, float begin, float end, float val, float min, float max) {
    super(x, y, size, begin, end, val, min, max);
  }
  
  void draw() {
    if (!fVisible) return;
    float temp = fSize + Constants.SLIDER_BAR_WIDTH;
    
    fill(Constants.SLIDER_BG_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, fBegin, fEnd);
    fill(Constants.SLIDER_BAR_COLOR);
    if (fSlider > PI) {
      fill(Constants.EX_COLOR);
      arc(fLoc.x, fLoc.y, temp, temp, PI, constrain(fSlider, PI, fEnd));
    }
    else {
      fill(Constants.IN_COLOR);
      arc(fLoc.x, fLoc.y, temp, temp, constrain(fSlider, fBegin, PI), PI);
    }
    fill(Constants.IN_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, fBegin, fBegin + Constants.THRESHOLD_HANDLE_WIDTH);
    fill(Constants.EX_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, fEnd - Constants.THRESHOLD_HANDLE_WIDTH, fEnd);
    fill(Constants.BG_COLOR);
    ellipse(fLoc.x, fLoc.y, fSize, fSize);
  }
  
  void addChange(float signal) {
    float temp = constrain(signal, fMin, fMax);
    this.setValue(temp);
  }
  
  boolean isInBounds(float x, float y) {
    boolean inBounds = true;
    float dist = PVector.dist(fLoc, new PVector(x, y));    
    float angle = Utilities.getAngleNorm(fLoc.x, fLoc.y, x, y);
    if (angle >= fEnd - Constants.THRESHOLD_HANDLE_WIDTH && angle <= fEnd)
      fState = END;
    else if (angle >= fBegin && angle <= fBegin + Constants.THRESHOLD_HANDLE_WIDTH)
      fState = BEGIN;
    else
      inBounds = false;
    return inBounds && dist >= fSize && dist <= fSize + Constants.SLIDER_BAR_WIDTH;
  }
  
  boolean onMouseDragged(float x, float y) {
    if (fSelected) {
      float angle = Utilities.getAngleNorm(fLoc.x, fLoc.y, x, y);
      switch (fState) {
        case BEGIN:
          fBegin = Utilities.constrain2(angle, 0.0, PI-Constants.THRESHOLD_HANDLE_WIDTH);
          break;
        case END:
          fEnd = Utilities.constrain3(angle, PI+Constants.THRESHOLD_HANDLE_WIDTH, TWO_PI);
          break;
      }
      fSlider = constrain(fSlider, fBegin, fEnd);
    }
    return fSelected;
  }
}