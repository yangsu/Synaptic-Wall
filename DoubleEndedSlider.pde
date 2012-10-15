public class DoubleEndedSlider extends CircularSlider {
  private float fValue2, fSlider2, fOffset;
  public DoubleEndedSlider(float x, float y, float size, float begin, float end, float val, float min, float max, int id, Controllable target) {
    this(x, y, size, SLIDER_BAR_WIDTH, begin, end, val, val, min, max, id, target);
  }

  public DoubleEndedSlider(float x, float y, float size, float thickness, float begin, float end, float val, float val2, float min, float max, int id, Controllable target) {
    super(x, y, size, thickness, begin, end, val, min, max, id, target);
    fOffset = DBLSIDED_HANDLE_WIDTH;
    setValue2(val2);
  }

  public float getValue2() {
    return fValue2;
  }

  public void setValue2(float val) {
    fValue2 = constrain(val, fMin, fMax);
    fSlider2 = constrain(map(val, fMin, fMax, fBegin, fEnd), fBegin, fEnd);
  }

  public void drawForeground() {
    pushStyle();
    fill((fHover) ? HIGHLIGHT_COLOR : SLIDER_BAR_COLOR);
    arcWithThickness(fSize, fLoc.x, fLoc.y, fSlider, fSlider2, fThickness);

    fill((fHover && (fState == BEGIN))
      ? 0xFFFFFFFF
      : HIGHLIGHT_COLOR);

    arcWithThickness(fSize, fLoc.x, fLoc.y, fSlider - fOffset, fSlider, fThickness);

    fill((fHover && (fState == END))
      ? 0xFFFFFFFF
      : HIGHLIGHT_COLOR);
    arcWithThickness(fSize, fLoc.x, fLoc.y, fSlider2, fSlider2 + fOffset, fThickness);
    popStyle();
  }

  public boolean selectState(float x, float y) {
    float angle = Util.getAngleNorm(fLoc.x, fLoc.y, x, y);
    if (angle >= fSlider2 && angle <= fSlider2 + fOffset)
      fState = END;
    else if (angle >= fSlider - fOffset && angle <= fSlider)
      fState = BEGIN;
    else if (angle < fEnd && angle > fBegin)
      fState = SLIDER;
    else
      return false;
    return true;
  }

  public void updateSlider(float x, float y) {
    float angle = Util.getAngleNorm(fLoc.x, fLoc.y, x, y);
    switch (fState) {
      case BEGIN:
        // TODO: bug in Util.constrain
        fSlider = constrain(angle, fBegin, fSlider2);
        fValue = map(fSlider, fBegin, fEnd, fMin, fMax);
        fTarget.onEvent(fID, fValue);
        break;
      case END:
        fSlider2 = Util.constrain(angle, fSlider, fEnd);
        fValue2 = map(fSlider2, fBegin, fEnd, fMin, fMax);
        fTarget.onEvent(fID, fValue2);
        break;
    }
  }
}