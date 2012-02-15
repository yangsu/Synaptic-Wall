public class Dendrite extends Path {
  public Dendrite(Signalable src, float x, float y, color cc) {
    super(src, x, y, cc);
  }

  public void draw() {
    pushStyle();
      strokeWeight(Constants.DENDRITE_WIDTH);
      float s = Constants.SIGNAL_WIDTH;
      PVector v = fVertices.get(0);
      fill(fColor);
      ellipse(v.x, v.y, s, s);
      super.draw();
    popStyle();
  }

  public int getType() {
    return Constants.DENDRITE;
  }
}