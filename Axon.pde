public class Axon extends Path {
  public Axon(Signalable src, float x, float y, color cc) {
    super(src, x, y, cc);
    this.fColor = fHighlightColor;
    this.fHighlightColor = Utilities.highlight(fHighlightColor);
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