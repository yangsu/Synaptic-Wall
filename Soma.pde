class Soma extends Cell {
  private ArrayList<Signal> fReceivedPSPs;

  private ThresholdSlider fThresholdSlider;
  private CircularSlider fSpeedSlider, fLengthSlider, fDecaySlider;
  private float fSpeed, fLength, fDecay;
  // Control IDS
  private static final int SPEED = 1;
  private static final int LENGTH = 2;
  private static final int DECAY = 3;
  private static final int THRESHOLD = 4;

  private int fLastFired, fType;
  Soma(float x, float y, float size, color cc, float threshold) {
    this(x, y, size, cc, (threshold > 0) ? threshold : 0, (threshold < 0) ? threshold : 0);
  }

  Soma(float x, float y, float size, color cc, float negativet, float positivet) {
    super(x, y, size, cc);
    fReceivedPSPs = new ArrayList<Signal>();
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

    fThresholdSlider = new ThresholdSlider(x, y, fSize + Constants.SLIDER_BAR_WIDTH,
                                            0, negativet, positivet,
                                            THRESHOLD, this);
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
      float temp = -fSpeed/2 * w;
      for (int i = 0; i < fSpeed; ++i) {
        triangle(fLoc.x + w/3 + temp, y - h,
                 fLoc.x + w/3 + temp, y + h,
                 fLoc.x + w + temp, y);
        temp += w;
      }

      //Length
      noFill();
      stroke(cc);
      float l = fLength/Constants.SIGNAL_MAX_LENGTH * 9/Constants.SCALE;
      float sl = (fSize - 2*l)/2;
      y = fLoc.y + 4/Constants.SCALE;
      float y2 = y - 5/Constants.SCALE;
      beginShape();
      vertex(fLoc.x - l - sl, y);
      vertex(fLoc.x - l, y);
      vertex(fLoc.x - l, y2);
      vertex(fLoc.x + l, y2);
      vertex(fLoc.x + l, y);
      vertex(fLoc.x + l + sl, y);
      endShape();

      //DECAY
      noStroke();
      color tempc = lerpColor(cc & 0xFFFFFF, cc, fDecay);
      fill(tempc);
      ellipse(fLoc.x, fLoc.y + 12/Constants.SCALE, 3/Constants.SCALE, 3/Constants.SCALE);
    popStyle();
  }

  private void processSignals() {
    float sum = 0;
    int now = millis();
    for (int i = fReceivedPSPs.size()-1; i >= 0; --i) {
      Signal s = fReceivedPSPs.get(i);
      int diff = now - s.fEndTime;
      if (diff > Constants.SIGNAL_FIRING_TIME)
        fReceivedPSPs.remove(s);
      else
        sum += Util.pulse(s.fStrength, diff, Constants.SIGNAL_FIRING_TIME);
    }
    fThresholdSlider.setValue(sum);
  }

  public void update() {
    this.processSignals();
  }

  public void draw() {
    super.draw();
    pushStyle();
      if (!fControlVisible)
        fThresholdSlider.draw();

      // this.drawDendrites();

      float s = fSize - Constants.SOMA_RING_WIDTH;
      fill(fColor);
      ellipse(fLoc.x, fLoc.y, s, s);

      this.drawControlDisplays();

      noStroke();
      color c = Constants.SHADOW_COLOR;
      ring(s, fLoc.x + Constants.SHADOW_OFFSETX, fLoc.y + Constants.SHADOW_OFFSETY, Constants.SOMA_RING_WIDTH, c);

      // this.drawAxons();

      c = lerpColor(fHighlightColor, Constants.HIGHLIGHT_COLOR, fThresholdSlider.getValue());
      ring(s, fLoc.x, fLoc.y, Constants.SOMA_RING_WIDTH, c);

    popStyle();
  }

  public void flipColor() {
    super.flipColor();
    fType ^= 1; // Flip between EXCITATORY and INHIBITORY
  }

  public void onSignal(Signal s) {
    fReceivedPSPs.add(s);
  }

  public void copyAttributes(Cell c) {
    Soma s = (Soma)c;
    fSpeed = s.fSpeed;
    fSpeedSlider.setValue(fSpeed);
    fLength = s.fLength;
    fLengthSlider.setValue(fLength);
    fDecay = s.fDecay;
    fDecaySlider.setValue(fDecay);
    this.setMinThreshold(s.getMinThreshold());
    this.setMaxThreshold(s.getMaxThreshold());
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
        if ((millis() - fLastFired) >= Constants.SOMA_FIRING_DELAY) {
          fLastFired = millis();
          float val = (fType == Constants.EXCITATORY) ? Constants.SIGNAL_STRENGTH : -Constants.SIGNAL_STRENGTH;
          for (Path p : fAxons)
            p.addSignal(new ActionPotential(fSpeed, fLength, fDecay, val, p));
        }
        break;
      default:
        break;
    }
  }
}