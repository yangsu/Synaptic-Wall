public class Synapse extends Shape {
  private float fStrength;

  public Synapse(float x, float y, color cc) {
    this(x, y, cc, Constants.SYNAPSE_DEFAULT_STRENGTH);
  }

  public Synapse(float x, float y, color cc, float strength) {
    super(x, y, Constants.SYNAPSE_SIZE, cc);
    fStrength = strength;
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

  void addPath(Path p) {
  }

  void onSignal(Signal s) {
  }

  public boolean isInBounds(float x, float y) {
    return PVector.dist(fLoc, new PVector(x, y)) <= fSize;
  }
}