public class Synapse extends Shape {
  private float fStrength;
  private Path fAxon;
  private Path fDendrite;
  private boolean fDisabled;
  private boolean fFired;
  private int fTimer;
  private int fEndTime;
  private int fMid;

  public Synapse(Path axon, float x, float y, color cc) {
    this(axon, x, y, cc, Constants.SIGNAL_DEFAULT_STRENGTH);
    fColor = fHighlightColor;
    fHighlightColor = Utilities.highlight(fHighlightColor);
  }

  public Synapse(Path axon, float x, float y, color cc, float strength) {
    super(x, y, Constants.SYNAPSE_SIZE, cc);
    fStrength = strength;
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
                              fStrength,
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
      ellipse(fLoc.x, fLoc.y, fSize + fStrength, fSize + fStrength);
      fill(Constants.BG_COLOR);
      ellipse(fLoc.x, fLoc.y, fSize, fSize);
      updateState();
    popStyle();
  }

  public boolean isComplete() {
    return fDendrite != null;
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
    }
  }

  public boolean isInBounds(float x, float y) {
    return PVector.dist(fLoc, new PVector(x, y)) <= fSize;
  }
}