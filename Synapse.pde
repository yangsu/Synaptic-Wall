public class Synapse extends Shape {
  private float fStrength;
  private float fSignalStrength;
  private Path fAxon;
  private Path fDendrite;
  private boolean fDisabled;
  private boolean fFired;
  private int fTimer;
  private int fEndTime;
  private int fMid;

  public Synapse(Path axon, float x, float y, color cc) {
    this(axon, x, y, cc, Constants.SYNAPSE_STRENGTH);
  }

  public Synapse(Path axon, float x, float y, color cc, float strength) {
    super(x, y, Constants.SYNAPSE_SIZE, cc);
    fStrength = strength;
    fSignalStrength = 0;
    fAxon = axon;
    fDendrite = null;
    fDisabled = false;
    fFired = true;
    fTimer = 0;
    fEndTime = 0;
    fMid = 0;
  }

  public int getType() {
    return Constants.SYNAPSE;
  }

  private void drawActivation() {
    pushStyle();
      fill(lerpColor(Constants.BG_COLOR, fHighlightColor,
          1.0 - 2*abs((fTimer - fMid)/(float)Constants.SYNAPSE_TIMING)));
      // Adde slight offset to cover holes
      ellipse(fLoc.x, fLoc.y, fSize + 0.2, fSize + 0.2);
    popStyle();
  }
  private void updateState() {
    if (fTimer < fEndTime) {
      drawActivation();
      fTimer = millis();
      if (fTimer > fMid && fDendrite != null && !fFired) {
        fDendrite.addSignal(new PostsynapticPotential(
                              Constants.SIGNAL_DEFAULT_SPEED,
                              Constants.SIGNAL_DEFAULT_LENGTH,
                              fSignalStrength*fStrength,
                              fDendrite));
        fFired = true;
      }
    }
    else {
      fDisabled = false;
    }
  }

  public void draw() {
    pushStyle();
      noStroke();
      fill((fHover) ? fHighlightColor : fColor);
      float s = fSize+fStrength*Constants.SYNAPSE_MULT+Constants.SYNAPSE_BASE;
      ellipse(fLoc.x, fLoc.y, s, s);
      fill(Constants.BG_COLOR);
      ellipse(fLoc.x, fLoc.y, fSize, fSize);
      updateState();
    popStyle();
  }

  public boolean isComplete() {
    return fDendrite != null;
  }

  public void flipColor() {
    super.flipColor();
    fDendrite.flipColor();
  }

  public void addPath(Path p) {
    if (!isComplete())
      fDendrite = p;
  }

  public void onSignal(Signal s) {
    if (!fDisabled) {
      fDisabled = true;
      fFired = false;
      fTimer = millis();
      fEndTime = fTimer + Constants.SYNAPSE_TIMING;
      fMid = fTimer + Constants.SYNAPSE_TIMING/2;
      fSignalStrength = s.fStrength;
    }
  }

  public boolean isInBounds(float x, float y) {
    return PVector.dist(fLoc, new PVector(x, y)) <= (fSize + fStrength);
  }
}