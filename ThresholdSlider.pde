class ThresholdSlider extends CircularSlider {
  static final int BEGIN = 1;
  static final int END = 2;

  private float fOffset;
  public ThresholdSlider(float x, float y, float size,
                  int id, Controllable target) {
    this(x, y, size,
        0, -Constants.SOMA_MAX_THRESHOLD, Constants.SOMA_MAX_THRESHOLD,
        id, target);
  }

  public ThresholdSlider(float x, float y, float size,
                  float val, float min, float max,
                  int id, Controllable target) {
    super(x, y, size,
          (min/Constants.SOMA_MAX_THRESHOLD) * PI,
          (max/Constants.SOMA_MAX_THRESHOLD) * PI,
          val, min, max, id, target);
    fSlider = HALF_PI;
    fOffset = Constants.THRESHOLD_HANDLE_WIDTH;

    fVisible = true;
  }

  public void setValue(float val) {
    if (val <= fMin || val >= fMax)
      fTarget.onEvent(fID, val);
    fValue = constrain(val, fMin, fMax);
    if (fValue > 0)
      fSlider = map(fValue, 0, fMax, fOffset, fEnd - fOffset);
    else if (fValue < 0)
      fSlider = map(fValue, fMin, 0, fBegin + fOffset, -fOffset);
    else
      fSlider = 0;
  }

  public float getValue() {
    if (fSlider > 0)
      // return map(fSlider, fOffset, fEnd - fOffset, 0, fMax);
      return norm(fSlider, fOffset, fEnd - fOffset);
    else if (fSlider < 0)
      // return map(fSlider, fBegin + fOffset, -fOffset, fMin, 0);
      return norm(fSlider, fBegin + fOffset, -fOffset);
    else
      return 0;
  }

  public float getMin() {
    return fMin;
  }

  public void setMin(float value) {
    fMin = value;
    fBegin = fMin * PI / Constants.SOMA_MAX_THRESHOLD;
  }

  public float getMax() {
    return fMax;
  }

  public void setMax(float value) {
    fMax = value;
    fEnd = fMax * PI / Constants.SOMA_MAX_THRESHOLD;
  }

  private void drawThresholdArc(float x, float y, float s, float b, float e) {
    float bb = Util.convertToArcCoord(b);
    float ee = Util.convertToArcCoord(e);
    if ((b * e >= 0 && ee >= bb) /* same sign */||
        (ee >= (PI + HALF_PI) && ee < TWO_PI)) {
      arcWithThickness(s, x, y, bb, ee, Constants.SLIDER_BAR_WIDTH);
    }
    else {
      arcWithThickness(s, x, y, bb, TWO_PI, Constants.SLIDER_BAR_WIDTH);
      arcWithThickness(s, x, y, 0, ee, Constants.SLIDER_BAR_WIDTH);
    }
  }

  public void draw() {
    pushStyle();
      if (!fVisible) return;

      fill(Constants.SLIDER_BG_COLOR);
      drawThresholdArc(fLoc.x, fLoc.y, fSize, fBegin, fEnd);

      fill(Constants.HIGHLIGHT_COLOR);
      if (fSlider > 0)
        drawThresholdArc(fLoc.x, fLoc.y, fSize, -fOffset, fSlider);
      else if (fSlider < 0)
        drawThresholdArc(fLoc.x, fLoc.y, fSize, fSlider, fOffset);
      else
        drawThresholdArc(fLoc.x, fLoc.y, fSize, -fOffset, fOffset);
      fill((fHover && (fState == BEGIN))
            ? Constants.THRESHOLD_NEGATIVE_HIGHLIGHT
            : Constants.THRESHOLD_NEGATIVE_COLOR);
      drawThresholdArc(fLoc.x, fLoc.y, fSize, fBegin, fBegin + fOffset);
      fill((fHover && (fState == END))
            ? Constants.THRESHOLD_POSITIVE_HIGHLIGHT
            : Constants.THRESHOLD_POSITIVE_COLOR);
      drawThresholdArc(fLoc.x, fLoc.y, fSize, fEnd - fOffset, fEnd);
   popStyle();
  }

  public boolean isInBounds(float x, float y) {
    boolean inBounds = true;
    float dist = PVector.dist(fLoc, new PVector(x, y));
    float angle = Util.thresholdAngle(fLoc.x, fLoc.y, x, y);
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
    return (fSelected = isInBounds(x, y));
  }

  public boolean onMouseDragged(float x, float y) {
    if (fSelected) {
      float angle = Util.thresholdAngle(fLoc.x, fLoc.y, x, y);
      switch (fState) {
        case BEGIN:
          fBegin = Util.thresholdConstrain(angle, -PI, -2*fOffset);
          fMin = fBegin/PI * Constants.SOMA_MAX_THRESHOLD;
          break;
        case END:
          fEnd = Util.thresholdConstrain(angle, 2*fOffset, PI);
          fMax = fEnd/PI * Constants.SOMA_MAX_THRESHOLD;
          break;
      }
      fSlider = constrain(fSlider, fBegin + fOffset, fEnd - fOffset);
    }
    return fSelected;
  }

  // Threshold is always visible
  public void setVisible(boolean visible) {
    fVisible = true;
  }
}