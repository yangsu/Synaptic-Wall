class Soma extends Cell {
  private ArrayList<Signal> fReceivedSignals;

  protected ThresholdSlider fThresholdSlider;
  protected CircularSlider fSpeedSlider, fLengthSlider, fDecaySlider;
  protected float fSpeed, fLength, fDecay;
  // Control IDS
  private static final int SPEED = 1;
  private static final int LENGTH = 2;
  private static final int DECAY = 3;
  private static final int THRESHOLD = 4;

  private int fType;
  Soma(float x, float y) {
    this(
      x, y, Constants.SOMA_SIZE, Constants.EX_COLOR,
      Constants.SOMA_INIT_NEG_THRESHOLD,
      Constants.SOMA_INIT_POS_THRESHOLD
    );
  }

  Soma(float x, float y, float size, color cc, float negt, float post) {
    super(x, y, size, cc);
    fReceivedSignals = new ArrayList<Signal>();
    fSpeed = Constants.SIGNAL_DEFAULT_SPEED;
    fLength = Constants.SIGNAL_DEFAULT_LENGTH;
    fDecay = Constants.SIGNAL_DEFAULT_DECAY;
    fType = Constants.EXCITATORY;

    float controlSize = fSize + 3 * Constants.SLIDER_BAR_WIDTH;

    fSpeedSlider = new CircularSlider(
      fLoc.x, fLoc.y, controlSize,
      0, TWO_PI/3,
      fSpeed, 1, Constants.SIGNAL_MAX_SPEED,
      SPEED, this
    );
    fControls.add(fSpeedSlider);

    fLengthSlider = new DiscreteCircularSlider(
      fLoc.x, fLoc.y, controlSize,
      TWO_PI/3, 2 * TWO_PI/3,
      fLength, 1, Constants.SIGNAL_MAX_LENGTH,
      LENGTH, this
    );
    fControls.add(fLengthSlider);
    fDecaySlider = new CircularSlider(
      fLoc.x, fLoc.y, controlSize,
      2 * TWO_PI/3, TWO_PI,
      fDecay, Constants.SIGNAL_MAX_DECAY, 1.0, //1.0 = no decay
      DECAY, this
    );
    fControls.add(fDecaySlider);

    fThresholdSlider = new ThresholdSlider(
      x, y, fSize + Constants.SLIDER_BAR_WIDTH,
      0, negt, post,
      THRESHOLD, this
    );
    fControls.add(fThresholdSlider);

    fLastFired = 0;
  }

  public int getType() {
    return Constants.SOMA;
  }

  public float getThresholdValue() {
    return fThresholdSlider.getValue();
  }

  public float getMinThreshold() {
    return fThresholdSlider.getMin();
  }

  public void setMinThreshold(float value) {
    fThresholdSlider.setMin(value);
  }

  public float getMaxThreshold() {
    return fThresholdSlider.getMax();
  }

  public void setMaxThreshold(float value) {
    fThresholdSlider.setMax(value);
  }

  private void drawControlDisplays() {
    pushStyle();
      color cc = fHighlightColor;

      //Speed
      noStroke();
      fill(cc);
      float h = 3/Constants.SCALE;
      float w = h * sqrt(3);
      float y = fLoc.y - 7/Constants.SCALE;
      float offset = -fSpeed/2 * w;
      for (int i = 0; i < fSpeed; ++i) {
        triangle(fLoc.x + w/3 + offset, y - h,
                 fLoc.x + w/3 + offset, y + h,
                 fLoc.x + w + offset, y);
        offset += w;
      }

      //Length
      noFill();
      stroke(cc);
      float l = fLength/Constants.SIGNAL_MAX_LENGTH * 9/Constants.SCALE;
      float offsetL = (fSize - 2*l)/2;
      y = fLoc.y + 4/Constants.SCALE;
      float y2 = y - 5/Constants.SCALE;
      beginShape();
      vertex(fLoc.x - l - offsetL, y);
      vertex(fLoc.x - l, y);
      vertex(fLoc.x - l, y2);
      vertex(fLoc.x + l, y2);
      vertex(fLoc.x + l, y);
      vertex(fLoc.x + l + offsetL, y);
      endShape();

      //DECAY
      noStroke();
      color newcolor = lerpColor(cc & 0xFFFFFF, cc, fDecay);
      fill(newcolor);
      ellipse(fLoc.x, fLoc.y + 12/Constants.SCALE, 3/Constants.SCALE, 3/Constants.SCALE);
    popStyle();
  }

  private void processSignals() {
    float sum = 0;
    int now = millis();
    for (int i = fReceivedSignals.size()-1; i >= 0; --i) {
      Signal s = fReceivedSignals.get(i);
      int diff = now - s.fFiringTime;
      float actualLength = s.fLength*Constants.SIGNAL_FIRING_MULTIPLIER + Constants.SIGNAL_SINGLE_FIRING_TIME;
      if (diff > actualLength)
        fReceivedSignals.remove(s);
      else {
        float val = Util.pulse(s.fStrength, diff, actualLength);
        sum += val;
      }
    }
    fThresholdSlider.setValue(sum);
  }

  public void update() {
    processSignals();
  }

  public void drawBackground() {
    drawControls();
    pushStyle();
    float s = fSize - Constants.SOMA_RING_WIDTH;
    fill(fColor);
    ellipse(fLoc.x, fLoc.y, s, s);

    drawControlDisplays();

    noStroke();
    color c = Constants.SHADOW_COLOR;
    ring(s, fLoc.x + Constants.SHADOW_OFFSETX, fLoc.y + Constants.SHADOW_OFFSETY, Constants.SOMA_RING_WIDTH, c);
    popStyle();
  }

  public void drawForeground() {
    pushStyle();

    float s = fSize - Constants.SOMA_RING_WIDTH;
    fill(fColor);
    noStroke();
    color c = lerpColor(fHighlightColor, Constants.HIGHLIGHT_COLOR, fThresholdSlider.getValue());
    ring(s, fLoc.x, fLoc.y, Constants.SOMA_RING_WIDTH, c);

    popStyle();
  }

  public void flipColor() {
    super.flipColor();
    fType ^= 1; // Flip between EXCITATORY and INHIBITORY
  }

  public void onSignal(Signal s) {
    fReceivedSignals.add(s);
  }

  public void copyAttributes(Cell c) {
    Soma s = (Soma)c;
    fSpeed = s.fSpeed;
    fSpeedSlider.setValue(fSpeed);
    fLength = s.fLength;
    fLengthSlider.setValue(fLength);
    fDecay = s.fDecay;
    fDecaySlider.setValue(fDecay);
    setMinThreshold(s.getMinThreshold());
    setMaxThreshold(s.getMaxThreshold());
  }

  protected boolean fireSignals() {
    if ((millis() - fLastFired) >= Constants.SOMA_FIRING_DELAY) {
      float val = (fType == Constants.EXCITATORY) ? Constants.SIGNAL_DEFAULT_STRENGTH : -Constants.SIGNAL_DEFAULT_STRENGTH;
      for (Path p : fAxons)
        p.addSignal(new ActionPotential(fSpeed, fLength, fDecay, val, p));
      return true;
    }
    return false;
  }
  public void onEvent(int controlID, float value) {
    switch (controlID) {
      case SPEED:
        fSpeed = value;
        break;
      case LENGTH:
        fLength = value;
        break;
      case DECAY:
        fDecay = value;
        break;
      case THRESHOLD:
        fire();
        break;
      default:
        break;
    }
  }
}