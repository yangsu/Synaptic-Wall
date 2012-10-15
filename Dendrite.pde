public class Dendrite extends Path {
  public Dendrite(Signalable src, float x, float y, color cc) {
    super(src, x, y, cc);
  }

  public void drawForeground() {
    // Draw start vertex
    drawJunction(getVertex(0));
    super.drawForeground();
  }

  public int getType() {
    return DENDRITE;
  }
}