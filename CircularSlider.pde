public class CircularSlider extends Control {
  protected float fSize, fMin, fMax, fValue;
  protected float fBegin, fEnd, fSlider;

  protected int fState;
  protected static final int SLIDER = 0;

  public CircularSlider(float x, float y, float size, int id, Controllable target) {
    this(x, y, size, 0, TWO_PI, 0, 0, TWO_PI, id, target);
  }

  public CircularSlider(float x, float y, float size, float begin, float end, int id, Controllable target) {
    this(x, y, size, begin, end, begin, begin, end, id, target);
  }

  public CircularSlider(float x, float y, float size, float val, float min, float max, int id, Controllable target) {
    this(x, y, size, 0, TWO_PI, val, min, max, id, target);
  }

  public CircularSlider(float x, float y, float size, float begin, float end, float val, float min, float max, int id, Controllable target) {
    super(x, y, id, target);
    fSize = size;
    fState = SLIDER;
    setValueRange(min, max);
    setSliderBounds(begin, end);
    setValue(val);
    // Circular Sliders are initially hidden
    fVisible = false;
  }

  public float getValue() {
    return fValue;
  }

  public float getTheta() {
    return fSlider;
  }

  public void setValue(float val) {
    fValue = constrain(val, fMin, fMax);
    fSlider = constrain(map(val, fMin, fMax, fBegin, fEnd), fBegin, fEnd);
  }

  public void setSliderBounds(float begin, float end) {
    fBegin = begin;
    fEnd = end;
    fSlider = constrain(fSlider, fBegin, fEnd);
  }

  public void setValueRange(float min, float max) {
    fMin = min;
    fMax = max;
  }

  public void drawBackground() {
    pushStyle();
    fill(Constants.SLIDER_BG_COLOR);
    arcWithThickness(fSize, fLoc.x, fLoc.y, fBegin, fEnd, Constants.SLIDER_BAR_WIDTH);
    popStyle();
  }

  public void drawForeground() {
    pushStyle();
    float s = Constants.SLIDER_BAR_WIDTH;
    if (fHover)
      fill(Constants.HIGHLIGHT_COLOR);
    else
      fill(Constants.SLIDER_BAR_COLOR);
    arcWithThickness(fSize, fLoc.x, fLoc.y, fBegin, fSlider, s);
    // Added 0.02 for minor offset to cover up extraneous pixels
    fill(Constants.SLIDER_HANDLE_COLOR);
    arcWithThickness(fSize, fLoc.x, fLoc.y, fBegin - 0.02, fBegin + Constants.SLIDER_HANDLE_WIDTH, s);
    arcWithThickness(fSize, fLoc.x, fLoc.y, fEnd - Constants.SLIDER_HANDLE_WIDTH, fEnd + 0.02, s);
    popStyle();
  }

  public boolean selectState(float x, float y) {
    float angle = Util.getAngleNorm(fLoc.x, fLoc.y, x, y);
    if (angle < fEnd && angle > fBegin) {
      fState = SLIDER;
      return true;
    }
    return false;
  }

  public boolean isInBounds(float x, float y) {
    float dist = PVector.dist(fLoc, new PVector(x, y));
    return selectState(x, y) && dist >= fSize && dist <= fSize + Constants.SLIDER_BAR_WIDTH;
  }

  public void updateSlider(float x, float y) {
    float angle = Util.getAngleNorm(fLoc.x, fLoc.y, x, y);
    fSlider = Util.constrain(angle, fBegin, fEnd);
    fValue = map(fSlider, fBegin, fEnd, fMin, fMax);
    if (fTarget != null) fTarget.onEvent(fID, fValue);
  }

  public boolean onMouseDown(float x, float y) {
    fSelected = isInBounds(x, y);
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