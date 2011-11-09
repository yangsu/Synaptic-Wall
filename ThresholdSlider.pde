class ThresholdSlider extends CircularSlider { 
  static final int BEGIN = 1;
  static final int END = 2;
  
  ThresholdSlider(float x, float y, float size, int id, Controllable target) {
    super(x, y, size, id, target);
  }
  
  ThresholdSlider(float x, float y, float size, float begin, float end, int id, Controllable target) {
    super(x, y, size, begin, end, id, target);
  }
  
  ThresholdSlider(float x, float y, float size, float val, float min, float max, int id, Controllable target) {
    super(x, y, size, val, min, max, id, target);
  }
  
  ThresholdSlider(float x, float y, float size, float begin, float end, float val, float min, float max, int id, Controllable target) {
    super(x, y, size, begin, end, val, min, max, id, target);
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
    
    // added 0.01 offset to cover up extraneous pixels
    arc(fLoc.x, fLoc.y, fSize, fSize, fBegin-0.01, fEnd+0.01);
  }

  void addChange(float signal) {
    float temp = signal + this.getValue();
    if (temp != 0) {
      if (temp >= fMax) {
        fTarget.onEvent(this.fID, temp);
      }
      if (temp <= fMin) {
        fTarget.onEvent(this.fID, temp);
      }
    }
    
    this.setValue(constrain(temp, fMin, fMax));
  }
  
  boolean isInBounds(float x, float y) {
    boolean inBounds = true;
    float dist = PVector.dist(fLoc, new PVector(x, y));    
    float angle = Utilities.getAngleNorm(fLoc.x, fLoc.y, x, y);
    if (angle >= fEnd - Constants.THRESHOLD_HANDLE_WIDTH && angle <= fEnd)
      fState = END;
    else if (angle >= fBegin && angle <= fBegin + Constants.THRESHOLD_HANDLE_WIDTH)
      fState = BEGIN;
    if (angle < fEnd && angle > fBegin)
      fState = SLIDER;
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