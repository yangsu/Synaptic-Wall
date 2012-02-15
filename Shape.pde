abstract class Shape extends Interactive implements Signalable {
  float fSize;

  Shape() {
    super();
    fSize = 0;
    fSelected = false;
  }

  Shape(float x, float y, float size, color cc) {
    super(x, y, cc);
    fSize = size;
  }

  float x() { return fLoc.x; }
  float y() { return fLoc.y; }
  void setXY(float x, float y) { fLoc.set(x, y, 0); }
  void setXY(PVector l) { this.setXY(l.x, l.y); }
  void translate(float dx, float dy) {
    this.translate(new PVector(dx, dy));
  }
  void translate(PVector change) {
    if (fMovable)
      fLoc.add(change);
  }
}