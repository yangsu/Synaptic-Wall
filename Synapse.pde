public class Synapse extends Shape {
  private float fStrength;
  private Path fAxon;
  private Path fDendrite;

  public Synapse(Path axon, float x, float y, color cc) {
    this(axon, x, y, cc, Constants.SYNAPSE_DEFAULT_STRENGTH);
  }

  public Synapse(Path axon, float x, float y, color cc, float strength) {
    super(x, y, Constants.SYNAPSE_SIZE, cc);
    fStrength = strength;
    fAxon = axon;
    fDendrite = null;
  }

  public int getType() {
    return Constants.SYNAPSE;
  }

  public void draw() {
    pushStyle();
      fill((fHover) ? Utilities.highlight(fColor) : fColor);
      ellipse(fLoc.x, fLoc.y, fSize, fSize);
      fill(Constants.BG_COLOR);
      ellipse(fLoc.x, fLoc.y, fSize-fStrength, fSize-fStrength);
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
  }

  public boolean isInBounds(float x, float y) {
    return PVector.dist(fLoc, new PVector(x, y)) <= fSize;
  }
}