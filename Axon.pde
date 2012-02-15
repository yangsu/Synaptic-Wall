public class Axon extends Path {
  public Axon(Signalable src, float x, float y, color cc) {
    super(src, x, y, cc);
    fColor = fHighlightColor;
    fHighlightColor = Utilities.highlight(fHighlightColor);
  }

  public Axon(Path p, float x, float y, color cc) {
    super(p, x, y, cc);
  }

  public void draw() {
    pushStyle();
    strokeWeight(Constants.AXON_WIDTH);
    super.draw();
    popStyle();
  }

  public int getType() {
    return Constants.AXON;
  }
}