class ThresholdSlider extends CircularSlider {
  static final int BEGIN = 1;
  static final int END = 2;

  ThresholdSlider(float x, float y, float size,
                  int id, Controllable target) {
    this(x, y, size, 0, TWO_PI, 0, -Constants.SOMA_MAX_THRESHOLD, Constants.SOMA_MAX_THRESHOLD, id, target);
  }

  ThresholdSlider(float x, float y, float size,
                  float val, float min, float max,
                  int id, Controllable target) {
    this(x, y, size, PI + min/Constants.SOMA_MAX_THRESHOLD * PI, PI + max/Constants.SOMA_MAX_THRESHOLD*PI, val, min, max, id, target);
  }

  ThresholdSlider(float x, float y, float size,
                  float begin, float end,
                  float val, float min, float max,
                  int id, Controllable target) {
    super(x, y, size, begin, end, val, min, max, id, target);
  }

  void draw() {
    if (!fVisible) return;
    float temp = fSize + Constants.SLIDER_BAR_WIDTH;

    fill(Constants.SLIDER_BG_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, fBegin, fEnd);
      fill(Constants.HIGHLIGHT_COLOR);
    if (fSlider > PI) {
      arc(fLoc.x, fLoc.y, temp, temp, PI, fSlider);
    }
    else {
      arc(fLoc.x, fLoc.y, temp, temp, fSlider, PI);
    }

    fill((fHover && (fState == BEGIN))
          ? Constants.IN_HIGHLIGHT_COLOR
          : Constants.IN_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, fBegin, fBegin + Constants.THRESHOLD_HANDLE_WIDTH);
    fill((fHover && (fState == END))
      ? Constants.EX_HIGHLIGHT_COLOR
      : Constants.EX_COLOR);
    arc(fLoc.x, fLoc.y, temp, temp, fEnd - Constants.THRESHOLD_HANDLE_WIDTH, fEnd);
    fill(Constants.BG_COLOR);

    // added 0.02 offset to cover up extraneous pixels
    arc(fLoc.x, fLoc.y, fSize, fSize,
        constrain(fBegin - 0.02, -0.02, PI - Constants.THRESHOLD_HANDLE_WIDTH),
        constrain(fEnd + 0.02,
                  PI + Constants.THRESHOLD_HANDLE_WIDTH,
                  TWO_PI+0.02));
  }

  void addChange(float signal) {
    // if the value is greater than max or less than min, meaning that the last signal caused the slider to go over the threshold, change the
    float temp = this.getValue();
    if (temp >= fMax)
      this.setValue(fMax - temp);
    if (temp <= fMin)
      this.setValue(temp - fMin);

    temp = signal + this.getValue();
    if ((temp >= fMax || temp <= fMin) && temp != 0 && fTarget != null) {
        fTarget.onEvent(this.fID, temp);
    }
    this.setValue(signal + this.getValue());
  }

  boolean isInBounds(float x, float y) {
    boolean inBounds = true;
    float dist = PVector.dist(fLoc, new PVector(x, y));
    float angle = Utilities.getAngleNorm(fLoc.x, fLoc.y, x, y);
    if (angle >= fEnd - Constants.THRESHOLD_HANDLE_WIDTH && angle <= fEnd)
      fState = END;
    else if (angle >= fBegin && angle <= fBegin + Constants.THRESHOLD_HANDLE_WIDTH)
      fState = BEGIN;
    else if (angle < fEnd && angle > fBegin)
      fState = SLIDER;
    else
      inBounds = false;
    return inBounds && dist >= fSize && dist <= fSize + Constants.SLIDER_BAR_WIDTH;
  }

  public boolean onMouseDown(float x, float y) {
    return (fSelected = this.isInBounds(x, y));
  }

  public boolean onMouseDragged(float x, float y) {
    if (fSelected) {
      float angle = Utilities.getAngleNorm(fLoc.x, fLoc.y, x, y);
      switch (fState) {
        case BEGIN:
          fBegin = Utilities.constrain(angle, 0.0, PI);
          fMin = - (PI - fBegin)/PI * Constants.SOMA_MAX_THRESHOLD;
          break;
        case END:
          fEnd = Utilities.constrain(angle, PI, TWO_PI);
          fMax = (fEnd - PI)/PI * Constants.SOMA_MAX_THRESHOLD;
          break;
      }
      fSlider = constrain(fSlider, fBegin, fEnd);
    }
    return fSelected;
  }
}