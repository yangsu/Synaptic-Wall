public class DiscreteCircularSlider extends CircularSlider {

  public DiscreteCircularSlider(float x, float y, float size, int id, Controllable target) {
    super(x, y, size, id, target);
  }

  public DiscreteCircularSlider(float x, float y, float size, float begin, float end, int id, Controllable target) {
    super(x, y, size, begin, end, id, target);
  }

  public DiscreteCircularSlider(float x, float y, float size, float val, float min, float max, int id, Controllable target) {
    super(x, y, size, val, min, max, id, target);
  }

  public DiscreteCircularSlider(float x, float y, float size, float begin, float end, float val, float min, float max, int id, Controllable target) {
    super(x, y, size, begin, end, val, min, max, id, target);
  }

  public void updateSlider(float x, float y) {
    float angle = Util.getAngleNorm(fLoc.x, fLoc.y, x, y);
    float temp = Util.constrain(angle, fBegin, fEnd);
    fValue = round(map(temp, fBegin, fEnd, fMin, fMax));
    fSlider = map(fValue, fMin, fMax, fBegin, fEnd);
    if (fTarget != null) fTarget.onEvent(fID, fValue);
  }
}