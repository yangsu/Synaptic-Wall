public class Synapse extends Shape {
  private float fStrength;
  private Path fAxon;
  private Path fDendrite;
  private boolean fDisabled;
  private boolean fFired;
  private int fTimer;
  private int fEndTime;
  private int fMid;
  private Signal fSigTemplate;
  private color fHighlight;
  public Synapse(Path axon, float x, float y, color cc) {
    this(axon, x, y, cc, Constants.SYNAPSE_DEFAULT_STRENGTH);
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
    fHighlight = Utilities.highlight(fColor);
    fSigTemplate = null;
  }

  public int getType() {
    return Constants.SYNAPSE;
  }

  private void drawActivation() {
    pushStyle();
      fill(lerpColor(Constants.BG_COLOR, Utilities.highlight(fColor), 
          1.0 - 2*abs((fTimer - fMid)/(float)Constants.SYNAPSE_TIMING)));
      ellipse(fLoc.x, fLoc.y, fSize, fSize);
    popStyle();
  }
  private void updateState() {
    if (fTimer < fEndTime) {
      drawActivation();
      fTimer = millis();
      if (fTimer > fMid && fDendrite != null && !fFired) {
        fDendrite.addSignal(fSigTemplate.makeCopy(fDendrite));
        fFired = true;
      }
    }
    else {
      fDisabled = false;
    }
  }

  public void draw() {
    pushStyle();
      stroke((fHover) ? Utilities.highlight(fColor) : fColor);
      strokeWeight(fStrength);
      noFill();
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
      // TODO: do processing on signal
      if (fDendrite != null)
        fSigTemplate = s.makeCopy(fDendrite);
    }
  }

  public boolean isInBounds(float x, float y) {
    return PVector.dist(fLoc, new PVector(x, y)) <= fSize;
  }
}