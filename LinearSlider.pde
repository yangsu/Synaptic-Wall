public class LinearSlider extends Slider {
  public LinearSlider(float x, float y, float size, float val, float min, float max, int id, Controllable target) {
    this(x, y, size, Constants.SLIDER_BAR_WIDTH, val, min, max, id, target);
  }

  public LinearSlider(float x, float y, float size, float thickness, float val, float min, float max, int id, Controllable target) {
    super(x, y, size, thickness, x, x + size, val, min, max, id, target);
  }

  public void drawBackground() {
    pushStyle();
    fill(Constants.SLIDER_BG_COLOR);
    rect(fLoc.x, fLoc.y, fSize, fThickness);
    popStyle();
  }

  public void drawForeground() {
    pushStyle();
    fill((fHover) ? Constants.HIGHLIGHT_COLOR : Constants.SLIDER_BAR_COLOR);
    rect(fLoc.x, fLoc.y, fSlider - fBegin, fThickness);
    popStyle();
  }

  public boolean isInBounds(float x, float y) {
    return x >= fBegin && x <= fEnd && y >= fLoc.y && y <= fLoc.y + fThickness;
  }

  public void updateSlider(float x, float y) {
    // TODO: add custom constrain function for correct snapping behavior
    fSlider = constrain(x, fBegin, fEnd);
    println(fSlider);
    fValue = map(fSlider, fBegin, fEnd, fMin, fMax);
    if (fTarget != null) fTarget.onEvent(fID, fValue);
  }
}