public class ThresholdSlider extends CircularSlider {
  private float fOffset;
  public ThresholdSlider(float x, float y, float size, int id, Controllable target) {
    this(x, y, size, SLIDER_BAR_WIDTH,
        0, -SOMA_MAX_THRESHOLD, SOMA_MAX_THRESHOLD,
        id, target);
  }

  public ThresholdSlider(float x, float y, float size, float val, float min, float max, int id, Controllable target) {
    this(x, y, size, SLIDER_BAR_WIDTH, val, min, max, id, target);
  }

  public ThresholdSlider(float x, float y, float size, float thickness, float val, float min, float max, int id, Controllable target) {
    super(x, y, size, thickness,
          (min/SOMA_MAX_THRESHOLD) * PI,
          (max/SOMA_MAX_THRESHOLD) * PI,
          val, min, max, id, target);
    fSlider = HALF_PI;
    fOffset = THRESHOLD_HANDLE_WIDTH;

    fVisible = true;
  }

  public void setValue(float val) {
    // if (val <= fMin || val >= fMax)
    //   fTarget.onEvent(fID, val);
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
    fBegin = fMin * PI / SOMA_MAX_THRESHOLD;
  }

  public float getMax() {
    return fMax;
  }

  public void setMax(float value) {
    fMax = value;
    fEnd = fMax * PI / SOMA_MAX_THRESHOLD;
  }

  private void drawThresholdArc(float x, float y, float s, float b, float e) {
    float bb = Util.convertToArcCoord(b);
    float ee = Util.convertToArcCoord(e);
    if ((b * e >= 0 && ee >= bb) /* same sign */||
        (ee >= (PI + HALF_PI) && ee < TWO_PI)) {
      arcWithThickness(s, x, y, bb, ee, SLIDER_BAR_WIDTH);
    }
    else {
      arcWithThickness(s, x, y, bb, TWO_PI, SLIDER_BAR_WIDTH);
      arcWithThickness(s, x, y, 0, ee, SLIDER_BAR_WIDTH);
    }
  }

  public boolean isInBounds(float x, float y) {
    float dist = PVector.dist(fLoc, new PVector(x, y));
    return selectState(x, y) && dist >= THRESHOLD_SLIDER_RADIUS && dist <= (THRESHOLD_SLIDER_RADIUS + SLIDER_BAR_WIDTH);
  }

  public void drawBackground() {
    pushStyle();
    fill(SLIDER_BG_COLOR);
    drawThresholdArc(fLoc.x, fLoc.y, THRESHOLD_SLIDER_RADIUS, fBegin, fEnd);
    popStyle();
  }

  public void drawForeground() {
    pushStyle();
    fill(HIGHLIGHT_COLOR);
    if (fSlider > 0)
      drawThresholdArc(fLoc.x, fLoc.y, THRESHOLD_SLIDER_RADIUS, -fOffset, fSlider);
    else if (fSlider < 0)
      drawThresholdArc(fLoc.x, fLoc.y, THRESHOLD_SLIDER_RADIUS, fSlider, fOffset);
    else
      drawThresholdArc(fLoc.x, fLoc.y, THRESHOLD_SLIDER_RADIUS, -fOffset, fOffset);
    fill((fHover && (fState == BEGIN))
          ? THRESHOLD_NEGATIVE_HIGHLIGHT
          : THRESHOLD_NEGATIVE_COLOR);
    drawThresholdArc(fLoc.x, fLoc.y, THRESHOLD_SLIDER_RADIUS, fBegin, fBegin + fOffset);
    fill((fHover && (fState == END))
          ? THRESHOLD_POSITIVE_HIGHLIGHT
          : THRESHOLD_POSITIVE_COLOR);
    drawThresholdArc(fLoc.x, fLoc.y, THRESHOLD_SLIDER_RADIUS, fEnd - fOffset, fEnd);
   popStyle();
  }

  public boolean selectState(float x, float y) {
    float angle = Util.thresholdAngle(fLoc.x, fLoc.y, x, y);
    if (angle >= fEnd - fOffset && angle <= fEnd)
      fState = END;
    else if (angle >= fBegin && angle <= fBegin + fOffset)
      fState = BEGIN;
    else if (angle < fEnd && angle > fBegin)
      fState = SLIDER;
    else
      return false;
    return true;
  }

  public void updateSlider(float x, float y) {
    float angle = Util.thresholdAngle(fLoc.x, fLoc.y, x, y);
    switch (fState) {
      case BEGIN:
        fBegin = Util.thresholdConstrain(angle, -PI, -2*fOffset);
        fMin = fBegin/PI * SOMA_MAX_THRESHOLD;
        break;
      case END:
        fEnd = Util.thresholdConstrain(angle, 2*fOffset, PI);
        fMax = fEnd/PI * SOMA_MAX_THRESHOLD;
        break;
    }
    fSlider = constrain(fSlider, fBegin + fOffset, fEnd - fOffset);
  }

  public boolean onMouseDown(float x, float y) {
    return (fSelected = isInBounds(x, y));
  }
  // Threshold is always visible
  public void setVisible(boolean visible) {
  }
}