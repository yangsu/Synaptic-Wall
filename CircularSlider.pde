class CircularSlider extends Control {
  float fSize, fMin, fMax, fValue;
  float fBegin, fEnd, fSlider;
  
  int fState;
  static final int SLIDER = 0;
  
  CircularSlider(float x, float y, float size, int id, Controllable target) {
    this(x, y, size, 0, TWO_PI, 0, 0, TWO_PI, id, target);
  }
  
  CircularSlider(float x, float y, float size, float begin, float end, int id, Controllable target) {
    this(x, y, size, begin, end, begin, begin, end, id, target);
  }
  
  CircularSlider(float x, float y, float size, float val, float min, float max, int id, Controllable target) {
    this(x, y, size, 0, TWO_PI, val, min, max, id, target);
  }
  
  CircularSlider(float x, float y, float size, float begin, float end, float val, float min, float max, int id, Controllable target) {
    super(x, y, id, target);
    fSize = size;
    fState = SLIDER;
    fBegin = begin;
    fEnd = end;
    fMin = min;
    fMax = max;
    this.setValue(val);
  }
  
  float getValue() {
    return fValue;
  }
  
  void setValue(float val) {
    fValue = val;
    fSlider = constrain(map(val, fMin, fMax, fBegin, fEnd), fBegin, fEnd);
  }
  
  void setSliderBounds(float begin, float end) {
    fBegin = begin;
    fEnd = end;
    fSlider = constrain(fSlider, fBegin, fEnd);
  }
  
  void setValueRange(float min, float max) {
    fMin = min;
    fMax = max;
  }
  
  void draw() {
    if (!fVisible) return;
    float temp = fSize + Constants.SLIDER_BAR_WIDTH;
    
    fill(Constants.SLIDER_BG_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, fBegin, fEnd);
    
    if (fHover)
      fill(Constants.HIGHLIGHT_COLOR);
    else
      fill(Constants.SLIDER_BAR_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, fBegin, fSlider);
    // Added 0.02 for minor offset to cover up extraneous pixels
    fill(Constants.SLIDER_HANDLE_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, fBegin - 0.02, fBegin + Constants.SLIDER_HANDLE_WIDTH);
    arc(fLoc.x, fLoc.y, temp, temp, fEnd - Constants.SLIDER_HANDLE_WIDTH, fEnd + 0.02);
    fill(Constants.BG_COLOR);
    ellipse(fLoc.x, fLoc.y, fSize, fSize);
  }
  
  boolean isInBounds(float x, float y) {
    boolean inBounds = false;
    float dist = PVector.dist(fLoc, new PVector(x, y));    
    float angle = Utilities.getAngleNorm(fLoc.x, fLoc.y, x, y);
    if (angle < fEnd && angle > fBegin) {
      fState = SLIDER;
      inBounds = true;
    }
    return inBounds && dist >= fSize && dist <= fSize + Constants.SLIDER_BAR_WIDTH;
  }
  
  void updateSlider(float x, float y) {
    float angle = Utilities.getAngleNorm(fLoc.x, fLoc.y, x, y);
    fSlider = Utilities.constrain(angle, fBegin, fEnd);
  }
  
  public boolean onMouseDown(float x, float y) {
    fSelected = this.isInBounds(x, y);
    if (fSelected)
      updateSlider(x, y);
    return fSelected;
  }

  public boolean onMouseDragged(float x, float y) {
    if (fSelected)
      updateSlider(x, y);
    return fSelected;
  }
}