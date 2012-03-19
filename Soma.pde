class Soma extends Cell {
  private ArrayList<Signal> fReceivedPSPs;

  private ThresholdSlider fThresholdSlider;
  private float fSpeed, fLength, fStrength;
  // Control IDS
  private static final int SPEED = 1;
  private static final int LENGTH = 2;
  private static final int STRENGTH = 3;
  private static final int THRESHOLD = 4;

  private int fLastFired;
  Soma(float x, float y, float size, color cc, float threshold) {
    this(x, y, size, cc, (threshold > 0) ? threshold : 0, (threshold < 0) ? threshold : 0);
  }

  Soma(float x, float y, float size, color cc, float negativet, float positivet) {
    super(x, y, size, cc);
    fReceivedPSPs = new ArrayList<Signal>();
    fSpeed = Constants.SIGNAL_DEFAULT_SPEED;
    fLength = Constants.SIGNAL_DEFAULT_LENGTH;
    fStrength = Constants.SIGNAL_DEFAULT_STRENGTH;

    float controlSize = fSize + 3 * Constants.SLIDER_BAR_WIDTH;

    fControls.add(new DiscreteCircularSlider(fLoc.x, fLoc.y, controlSize,
                                     0, TWO_PI/3,
                                     fSpeed, 1, Constants.SIGNAL_MAX_SPEED,
                                     SPEED, this));
    fControls.add(new DiscreteCircularSlider(fLoc.x, fLoc.y, controlSize,
                                     TWO_PI/3, 2 * TWO_PI/3,
                                     fLength, 1, Constants.SIGNAL_MAX_LENGTH,
                                     LENGTH, this));
    fControls.add(new CircularSlider(fLoc.x, fLoc.y, controlSize,
                                     2 * TWO_PI/3, TWO_PI,
                                     fStrength, -Constants.SIGNAL_MAX_STRENGTH, Constants.SIGNAL_MAX_STRENGTH,
                                     STRENGTH, this));

    fThresholdSlider = new ThresholdSlider(x, y, fSize + Constants.SLIDER_BAR_WIDTH,
                                            0, negativet, positivet,
                                            THRESHOLD, this);
    fControls.add(fThresholdSlider);

    fLastFired = 0;
  }

  public int getType() {
    return Constants.SOMA;
  }

  private void drawSoma() {
    fill(fColor);
    ellipse(fLoc.x, fLoc.y, fSize, fSize);
    noStroke();
    fill(lerpColor(fHighlightColor, Constants.HIGHLIGHT_COLOR, fThresholdSlider.getValue()));
    ellipse(fLoc.x, fLoc.y, fSize - Constants.SOMA_RING_WIDTH, fSize - Constants.SOMA_RING_WIDTH);
  }

  private void drawControlDisplays() {
    pushStyle();
      color cc = (fStrength > 0) ? Constants.EX_COLOR : Constants.IN_COLOR;

      //Speed
      noStroke();
      fill(cc);
      float h = 3;
      float w = h * sqrt(3);
      float y = fLoc.y - 7;
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
      float l = fLength/Constants.SIGNAL_MAX_LENGTH * 9;
      float sl = (fSize - 2*l)/2;
      y = fLoc.y + 4;
      beginShape();
      vertex(fLoc.x - l - sl, y);
      vertex(fLoc.x - l, y);
      vertex(fLoc.x - l, y - 5);
      vertex(fLoc.x + l, y - 5);
      vertex(fLoc.x + l, y);
      vertex(fLoc.x + l + sl, y);
      endShape();

      //Strength
      noStroke();
      color alpha = (int)(abs(fStrength)/Constants.SIGNAL_MAX_STRENGTH * 255) << 24 | 0xFFFFFF;
      fill(cc & alpha);
      ellipse(fLoc.x, fLoc.y + 12, 3, 3);
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
        sum += Utilities.pulse(s.fStrength, diff, Constants.SIGNAL_FIRING_TIME);
    }
    fThresholdSlider.setValue(sum);
  }

  public void draw() {
    this.processSignals();
    super.draw();
    pushStyle();
      if (!fControlVisible)
        fThresholdSlider.draw();
      this.drawSoma();
      this.drawControlDisplays();
    popStyle();
  }

  public void flipColor() {
    super.flipColor();
    fStrength = -fStrength;
  }

  public void onSignal(Signal s) {
    fReceivedPSPs.add(s);
  }

  public void onEvent(int controlID, float value) {
    switch (controlID) {
      case SPEED:
        fSpeed = value;
        break;
      case LENGTH:
        fLength = value;
        break;
      case STRENGTH:
        fStrength = value;
        break;
      case THRESHOLD:
        if ((millis() - fLastFired) >= Constants.SOMA_FIRING_DELAY) {
          fLastFired = millis();
          for (Path p : fDendrites)
            p.addSignal(new ActionPotential(fSpeed, fStrength, p));
        }
        break;
      default:
        break;
    }
  }
}