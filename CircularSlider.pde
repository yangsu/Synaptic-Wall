public class CircularSlider extends Slider {
  protected int fState;
  protected static final int SLIDER = 0;
  protected static final int BEGIN = 1;
  protected static final int END = 2;

  public CircularSlider(float x, float y, float size, float begin, float end, float val, float min, float max, int id, Controllable target) {
    this(x, y, size, SLIDER_BAR_WIDTH, begin, end, val, min, max, id, target);
  }

  public CircularSlider(float x, float y, float size, float thickness, float begin, float end, float val, float min, float max, int id, Controllable target) {
    super(x, y, size, thickness, begin, end, val, min, max, id, target);
    fState = SLIDER;
    // Circular Sliders are initially hidden
    fVisible = false;
  }

  public void drawBackground() {
    pushStyle();
    fill(SLIDER_BG_COLOR);
    arcWithThickness(CIRCULAR_SLIDER_RADIUS, fLoc.x, fLoc.y, fBegin, fEnd, SLIDER_BAR_WIDTH);
    popStyle();
  }

  public void drawForeground() {
    pushStyle();
    fill((fHover) ? HIGHLIGHT_COLOR : SLIDER_BAR_COLOR);
    arcWithThickness(CIRCULAR_SLIDER_RADIUS, fLoc.x, fLoc.y, fBegin, fSlider, SLIDER_BAR_WIDTH);
    // Added 0.02 for minor offset to cover up extraneous pixels
    fill(SLIDER_HANDLE_COLOR);
    arcWithThickness(CIRCULAR_SLIDER_RADIUS, fLoc.x, fLoc.y, fBegin - 0.02, fBegin + SLIDER_HANDLE_WIDTH, SLIDER_BAR_WIDTH);
    arcWithThickness(CIRCULAR_SLIDER_RADIUS, fLoc.x, fLoc.y, fEnd - SLIDER_HANDLE_WIDTH, fEnd + 0.02, SLIDER_BAR_WIDTH);
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
    return selectState(x, y) && dist >= CIRCULAR_SLIDER_RADIUS && dist <= (CIRCULAR_SLIDER_RADIUS + SLIDER_BAR_WIDTH);
  }

  public void updateSlider(float x, float y) {
    float angle = Util.getAngleNorm(fLoc.x, fLoc.y, x, y);
    fSlider = Util.constrain(angle, fBegin, fEnd);
    fValue = map(fSlider, fBegin, fEnd, fMin, fMax);
    if (fTarget != null) fTarget.onEvent(fID, fValue);
  }
}