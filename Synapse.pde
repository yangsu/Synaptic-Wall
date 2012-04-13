public class Synapse extends Shape {
  private float fStrength;
  private Signal fLatestSignal;
  private Path fAxon;
  private Path fDendrite;
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
    fLatestSignal = null;
    fAxon = axon;
    fDendrite = null;
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
                              fLatestSignal.fSpeed,
                              fLatestSignal.fLength,
                              fLatestSignal.fDecay,
                              fLatestSignal.fStrength * fStrength,
                              fDendrite));
        fFired = true;
      }
    }
  }

  public void draw() {
    pushStyle();
      noStroke();
      color c = Constants.SHADOW_COLOR;
      ring(fSize, fLoc.x + Constants.SHADOW_OFFSETX, fLoc.y + Constants.SHADOW_OFFSETY, fStrength*Constants.SYNAPSE_MULT+Constants.SYNAPSE_BASE, c);
      c = (fHover) ? fHighlightColor : fColor;
      ring(fSize, fLoc.x, fLoc.y, fStrength*Constants.SYNAPSE_MULT+Constants.SYNAPSE_BASE, c);
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
    fFired = false;
    fTimer = millis();
    fEndTime = fTimer + Constants.SYNAPSE_TIMING;
    fMid = fTimer + Constants.SYNAPSE_TIMING/2;
    fLatestSignal = s;
  }

  public boolean isInBounds(float x, float y) {
    return PVector.dist(fLoc, new PVector(x, y)) <= (fSize + fStrength);
  }
}