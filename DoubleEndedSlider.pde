public class DoubleEndedSlider extends CircularSlider {
  private float fValue2, fSlider2;
  public DoubleEndedSlider(float x, float y, float size, float begin, float end, float val, float min, float max, int id, Controllable target) {
    this(x, y, size, Constants.SLIDER_BAR_WIDTH, begin, end, val, val, min, max, id, target);
  }

  public DoubleEndedSlider(float x, float y, float size, float thickness, float begin, float end, float val, float val2, float min, float max, int id, Controllable target) {
    super(x, y, size, thickness, begin, end, val, min, max, id, target);
    setValue2(val2);
  }

  public void setValue2(float val) {
    fValue2 = constrain(val, fMin, fMax);
    fSlider2 = constrain(map(val, fMin, fMax, fBegin, fEnd), fBegin, fEnd);
  }

  public void drawForeground() {
    pushStyle();
    float w = Constants.DBLSIDED_HANDLE_WIDTH;
    float s = Constants.SLIDER_BAR_WIDTH;
    fill(0xFFFFFFFF);
    arcWithThickness(fSize, fLoc.x, fLoc.y, fSlider - w, fSlider + w, s);
    arcWithThickness(fSize, fLoc.x, fLoc.y, fSlider2 - w, fSlider2 + w, s);
    popStyle();
  }
}