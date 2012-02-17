class ThresholdSlider extends CircularSlider {
  static final int BEGIN = 1;
  static final int END = 2;

  private float fOffset;
  public ThresholdSlider(float x, float y, float size,
                  int id, Controllable target) {
    this(x, y, size, 0, -Constants.SOMA_MAX_THRESHOLD, Constants.SOMA_MAX_THRESHOLD, id, target);
  }

  public ThresholdSlider(float x, float y, float size,
                  float val, float min, float max,
                  int id, Controllable target) {
    // this(x, y, size, PI + min/Constants.SOMA_MAX_THRESHOLD * PI, PI + max/Constants.SOMA_MAX_THRESHOLD*PI, val, min, max, id, target);
    super(x, y, size,
          (min/Constants.SOMA_MAX_THRESHOLD) * PI,
          (max/Constants.SOMA_MAX_THRESHOLD) * PI,
          val, min, max, id, target);
    // fBegin = (min/Constants.SOMA_MAX_THRESHOLD) * PI;
    // fEnd = (max/Constants.SOMA_MAX_THRESHOLD) * PI;
    fSlider = HALF_PI;
    fOffset = Constants.THRESHOLD_HANDLE_WIDTH;
  }

  // public ThresholdSlider(float x, float y, float size,
  //                 float begin, float end,
  //                 float val, float min, float max,
  //                 int id, Controllable target) {
  //   super(x, y, size, begin, end, val, min, max, id, target);
  // }
  public float getValue() {
    if (fSlider > 0) {
      return map(fSlider, fOffset, fEnd - fOffset, 0, fMax);
    }
    else if (fSlider < 0) {
      return map(fSlider, fBegin + fOffset, -fOffset, fMin, 0);
    }
    else
      return 0;
  }
  private void drawThresholdArc(float x, float y, float s, float b, float e) {
    // if (!(b <= 0 && b >= -PI)) {
    //   println("begin has an incorrect value :"+ b);
    // }
    // if (!(e >= 0 && e <= PI)) {
    //   println("end has an incorrect value :"+ e);
    // }
    float bb = Utilities.convertToArcCoord(b);
    float ee = Utilities.convertToArcCoord(e);
    if (b * e >= 0 /* same sign */||
        (ee >= (PI + HALF_PI) && ee <= TWO_PI)) {
      arc(x, y, s, s, bb, ee);
    }
    else {
      arc(x, y, s, s, bb, TWO_PI);
      arc(x, y, s, s, 0, ee);
    }
  }
  public void draw() {
    pushStyle();
      if (!fVisible) return;
      float size = fSize + Constants.SLIDER_BAR_WIDTH;

      fill(Constants.SLIDER_BG_COLOR);
      this.drawThresholdArc(fLoc.x, fLoc.y, size, fBegin, fEnd);

      fill(Constants.HIGHLIGHT_COLOR);
      if (fSlider > 0) {
        this.drawThresholdArc(fLoc.x, fLoc.y, size, -fOffset, fSlider);
      }
      else {
        this.drawThresholdArc(fLoc.x, fLoc.y, size, fSlider, fOffset);
      }
      fill((fHover && (fState == BEGIN))
            ? Constants.THRESHOLD_POSITIVE_HIGHLIGHT
            : Constants.THRESHOLD_POSITIVE_COLOR);
      this.drawThresholdArc(fLoc.x, fLoc.y, size, fBegin, fBegin + fOffset);
      fill((fHover && (fState == END))
        ? Constants.THRESHOLD_NEGATIVE_HIGHLIGHT
        : Constants.THRESHOLD_NEGATIVE_COLOR);
      this.drawThresholdArc(fLoc.x, fLoc.y, size, fEnd - fOffset, fEnd);

      fill(Constants.BG_COLOR);
      this.drawThresholdArc(fLoc.x, fLoc.y, fSize, fBegin - 0.02, fEnd + 0.02);
   popStyle();
  }

  public void addChange(float signal) {
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

  public boolean isInBounds(float x, float y) {
    boolean inBounds = true;
    float dist = PVector.dist(fLoc, new PVector(x, y));
    float angle = Utilities.thresholdAngle(fLoc.x, fLoc.y, x, y);
    if (angle >= fEnd - fOffset && angle <= fEnd)
      fState = END;
    else if (angle >= fBegin && angle <= fBegin + fOffset)
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
      float angle = Utilities.thresholdAngle(fLoc.x, fLoc.y, x, y);
      switch (fState) {
        case BEGIN:
          fBegin = constrain(angle, -PI, -2*fOffset);
          // fMin = - (PI - fBegin)/PI * Constants.SOMA_MAX_THRESHOLD;
          break;
        case END:
          fEnd = constrain(angle, 2*fOffset, PI);
          // fMax = (fEnd - PI)/PI * Constants.SOMA_MAX_THRESHOLD;
          break;
      }
      fSlider = constrain(fSlider, fBegin + fOffset, fEnd - fOffset);
    }
    return fSelected;
  }
}