public class Dendrite extends Path {
  public Dendrite(Signalable src, float x, float y, color cc) {
    super(src, x, y, cc);
  }

  public void draw() {
    // Draw start vertex
    drawJunction(getVertex(0));
    super.draw();
  }

  public int getType() {
    return Constants.DENDRITE;
  }
}