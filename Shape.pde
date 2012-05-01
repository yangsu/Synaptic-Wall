public abstract class Shape extends Interactive implements Signalable {
  protected float fSize;

  public Shape() {
    super();
    fSize = 0;
    fSelected = false;
  }

  public Shape(float x, float y, float size, color cc) {
    super(x, y, cc);
    fSize = size;
  }

  public float x() { return fLoc.x; }
  public float y() { return fLoc.y; }
  public void setXY(float x, float y) { fLoc.set(x, y, 0); }
  public void setXY(PVector l) { setXY(l.x, l.y); }
  public void translate(float dx, float dy) {
    translate(new PVector(dx, dy));
  }
  public void translate(PVector change) {
    if (fMovable)
      fLoc.add(change);
  }
}