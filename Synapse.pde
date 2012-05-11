public class Synapse extends ControllableShape implements TimerSubscriber{
  private float fStrength;
  private Signal fLatestSignal;
  private Path fAxon, fDendrite;
  private Cell fInput, fOutput;
  private Timer fTimer;

  public Synapse(Path axon, float x, float y, color cc) {
    this(axon, x, y, cc, Constants.SYNAPSE_STRENGTH);
  }

  public Synapse(Path axon, float x, float y, color cc, float strength) {
    super(x, y, Constants.SYNAPSE_SIZE, cc);
    fStrength = strength;
    fLatestSignal = null;
    fAxon = axon;
    //BUG: Assuming src is always a cell
    if (axon != null)
      fInput = (Cell)(axon.getSrc());
    fDendrite = null;
    fOutput = null;
    fTimer = new Timer(this, Constants.SYNAPSE_TIMING, 0.5);
  }

  public int getType() {
    return Constants.SYNAPSE;
  }

  public Path getAxon() {
    return fAxon;
  }

  public Path getDendrite() {
    return fDendrite;
  }

  public void drawBackground() {
    pushStyle();
    noStroke();
    color c = Constants.SHADOW_COLOR;
    ring(fSize, fLoc.x + Constants.SHADOW_OFFSETX, fLoc.y + Constants.SHADOW_OFFSETY, fStrength*Constants.SYNAPSE_MULT+Constants.SYNAPSE_BASE, c);
    popStyle();
  }

  public void drawForeground() {
    pushStyle();
    noStroke();
    color c = (fHover) ? fHighlightColor : fColor;
    ring(fSize, fLoc.x, fLoc.y, fStrength*Constants.SYNAPSE_MULT+Constants.SYNAPSE_BASE, c);

    if (!fTimer.ended()) {
      pushStyle();
      float s = 1 - 2*abs(fTimer.getProgress() - 0.5);
      fill(lerpColor(fHighlightColor & 0xFFFFFF, fHighlightColor, s));
      // Adde slight offset to cover holes
      ellipse(fLoc.x, fLoc.y, fSize + 0.2, fSize + 0.2);
      popStyle();
    }
    popStyle();
  }

  public void update() {
    fTimer.update();
    if (fInput != null && fOutput != null) {
      float inputDiff = fInput.getCurrentFiringRate() - fInput.getAvgFiringRate();
      float outputDiff = fOutput.getCurrentFiringRate() - fOutput.getAvgFiringRate();
      fStrength += Constants.LEARNING_K * inputDiff * outputDiff;
      fStrength = constrain(fStrength, Constants.SYNAPSE_MIN_STRENGTH, Constants.SYNAPSE_MAX_STRENGTH);
    }
  }

  public boolean isComplete() {
    return fDendrite != null;
  }

  public void addPath(Path p) {
    if (!isComplete()) {
      fDendrite = p;
      // BUG: Assuming dest is always a cell
      fOutput = (Cell)(p.getDest());
    }
  }

  public void onTimerFiring(int id, int time) {
    if (fDendrite != null)
      fDendrite.addSignal(new PostsynapticPotential(
        // fLatestSignal.fSpeed,
        Constants.SIGNAL_DEFAULT_SPEED,
        fLatestSignal.fLength,
        fLatestSignal.fDecay,
        // fLatestSignal.fStrength * fStrength,
        fLatestSignal.fStrength,
        fDendrite
      ));
  }

  public void onSignal(Signal s) {
    fLatestSignal = s;
    fTimer.reset();
  }

  public boolean isInBounds(float x, float y) {
    return PVector.dist(fLoc, new PVector(x, y)) <= (fSize + fStrength);
  }

  public void onEvent(int controlID, float value) {
  }
}