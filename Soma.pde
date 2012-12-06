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
      x, y, SOMA_SIZE, EX_COLOR,
      SOMA_INIT_NEG_THRESHOLD,
      SOMA_INIT_POS_THRESHOLD
    );
  }

  Soma(float x, float y, float size, color cc, float negt, float post) {
    super(x, y, size, cc);
    fReceivedSignals = new ArrayList<Signal>();
    fSpeed = SIGNAL_DEFAULT_SPEED;
    fLength = SIGNAL_DEFAULT_LENGTH;
    fDecay = SIGNAL_DEFAULT_DECAY;
    fType = EXCITATORY;

    fSpeedSlider = new CircularSlider(
      fLoc.x, fLoc.y, CIRCULAR_SLIDER_RADIUS,
      0, TWO_PI/3,
      fSpeed, 1, SIGNAL_MAX_SPEED,
      SPEED, this
    );
    fControls.add(fSpeedSlider);

    fLengthSlider = new DiscreteCircularSlider(
      fLoc.x, fLoc.y, CIRCULAR_SLIDER_RADIUS,
      TWO_PI/3, 2 * TWO_PI/3,
      fLength, 1, SIGNAL_MAX_LENGTH,
      LENGTH, this
    );
    fControls.add(fLengthSlider);
    fDecaySlider = new CircularSlider(
      fLoc.x, fLoc.y, CIRCULAR_SLIDER_RADIUS,
      2 * TWO_PI/3, TWO_PI,
      fDecay, SIGNAL_MAX_DECAY, 1.0, //1.0 = no decay
      DECAY, this
    );
    fControls.add(fDecaySlider);

    fThresholdSlider = new ThresholdSlider(
      x, y, THRESHOLD_SLIDER_RADIUS,
      0, negt, post,
      THRESHOLD, this
    );
    fControls.add(fThresholdSlider);

    fLastFired = 0;
  }

  public int getType() {
    return SOMA;
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
      float h = 3/SCALE;
      float w = h * sqrt(3);
      float y = fLoc.y - 7/SCALE;
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
      float l = fLength/SIGNAL_MAX_LENGTH * 9/SCALE;
      float offsetL = (SOMA_SIZE - 2*l)/2;
      y = fLoc.y + 4/SCALE;
      float y2 = y - 5/SCALE;
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
      ellipse(fLoc.x, fLoc.y + 12/SCALE, 3/SCALE, 3/SCALE);
    popStyle();
  }

  private static final float c = 2; // capacitance
  private static final float r = 500; // resistance
  private static final float rc = r * c;
  private static final float ur =  -0.5; // reset potential
  private static final float u0 = 0; // resting potential
  private static final float q = 2.3; // total charge
  private static final float tc = -100000;
  private static final float th = 1; // the neuron threshold
  private static final float taus = 500; // time constant

  private void processSignals() {
    double seps = 0, eps = 0;
    int now = millis();
    int timeSinceLastFiring = now - fLastFired;
    for (int i = fReceivedSignals.size()-1; i >= 0; --i) {
      Signal s = fReceivedSignals.get(i);
      int diff = now - s.fFiringTime;
      float actualLength = s.fLength*SIGNAL_FIRING_MULTIPLIER + SIGNAL_SINGLE_FIRING_TIME;
      if (fLastFired <= s.fFiringTime && s.fFiringTime <= now) {
        eps = Math.exp(-diff/rc) - Math.exp(-diff/taus);
      }
      if (s.fFiringTime < fLastFired && fLastFired <= now) {
        eps = Math.exp(-(fLastFired - s.fFiringTime)/taus)*(Math.exp(-timeSinceLastFiring/rc) - Math.exp(-timeSinceLastFiring/taus));
      }
      if (eps <= 0.005) {
        fReceivedSignals.remove(s);
      }
      seps += s.fStrength * eps;
      // float val = Util.pulse(s.fStrength, diff, actualLength);
    }

    double value = u0 + (ur - u0) * Math.exp(-timeSinceLastFiring / rc) + q/c * 1/(1-taus/rc) * seps;
    if (value >= th) { // generate spike
      value = ur;
      fire();
    }

    fThresholdSlider.setValue((float)value);
  }

  public void update() {
    processSignals();
  }

  public void drawBackground() {
    drawControls();
    pushStyle();
    float s = SOMA_SIZE - SOMA_RING_WIDTH;
    fill(fColor);
    ellipse(fLoc.x, fLoc.y, s, s);

    drawControlDisplays();

    noStroke();
    color c = SHADOW_COLOR;
    ring(s, fLoc.x + SHADOW_OFFSETX, fLoc.y + SHADOW_OFFSETY, SOMA_RING_WIDTH, c);
    popStyle();
  }

  public void drawForeground() {
    pushStyle();

    float s = SOMA_SIZE - SOMA_RING_WIDTH;
    fill(fColor);
    noStroke();
    color c = lerpColor(fHighlightColor, HIGHLIGHT_COLOR, fThresholdSlider.getValue());
    ring(s, fLoc.x, fLoc.y, SOMA_RING_WIDTH, c);

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
    if ((millis() - fLastFired) >= SOMA_FIRING_DELAY) {
      float val = (fType == EXCITATORY) ? SIGNAL_DEFAULT_STRENGTH : -SIGNAL_DEFAULT_STRENGTH;
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
        // fire();
        break;
      default:
        break;
    }
  }
}