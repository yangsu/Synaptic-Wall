public abstract class Slider extends Control {
  protected float fSize, fThickness, fMin, fMax, fValue, fBegin, fEnd, fSlider;
  protected String fLabel;

  public Slider(float x, float y, float size, float thickness, float begin, float end, float val, float min, float max, int id, Controllable target) {
    super(x, y, id, target);
    fSize = size;
    fThickness = thickness;
    setSliderBounds(begin, end);
    setValueRange(min, max);
    setValue(val);

    fLabel = "";
    fVisible = true;
  }

  public float getValue() {
    return fValue;
  }

  public float getSliderPosition() {
    return fSlider;
  }

  public void setLabel(String label) {
    fLabel = label;
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

  public abstract void updateSlider(float x, float y);

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