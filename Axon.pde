public class Axon extends Path {
  public Axon(Signalable src, float x, float y, color cc) {
    super(src, x, y, (cc == Constants.EX_COLOR) ? Constants.EX_HIGHLIGHT_COLOR : Constants.IN_HIGHLIGHT_COLOR);
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