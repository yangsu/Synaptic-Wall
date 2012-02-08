public class Dendrite extends Path {
  public Dendrite(Signalable src, float x, float y, color cc) {
    super(src, x, y, cc);
  }

  public void draw() {
    pushStyle();
    strokeWeight(Constants.DENDRITE_WIDTH);
    super.draw();
    popStyle();
  }

  public int getType() {
    return Constants.DENDRITE;
  }
}