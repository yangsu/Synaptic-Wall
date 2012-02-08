public class Axon extends Path {
  public Axon(Signalable src, float x, float y, color cc) {
    super(src, x, y, cc);
  }

  public Axon(Path p, float x, float y, color cc) {
    super(p, x, y, cc);
  }

  public int getType() {
    return Constants.AXON;
  }
}