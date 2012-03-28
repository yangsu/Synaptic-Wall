public class GeometricPath extends Path {
  private int fPathType;
  private Grid fGrid;

  public GeometricPath(Signalable src, float x, float y, color cc, int t, Grid g) {
    super(src, x, y, cc);
    fPathType = t;
    fGrid = g;
  }

  // public void draw() {
  //   super.draw();
  // }

  @Override
  public void add(float x, float y) {
    if (fVertices.size() > 0) {
      PVector last = fVertices.get(fVertices.size() - 1);
      if (last.x == x && last.y == y)
        return;
    }
    fVertices.add(new PVector(x, y));
  }

  public int getPathType() {
    return fPathType;
  }

  private void removeJags() {
    if (fVertices.size() <= 2)
      return;
    boolean changed = true;
    // Continue until no change
    while (changed) {
      changed = false;
      PVector p1 = fVertices.get(0);
      int i = 1;
      while (i < fVertices.size() - 1) {
        PVector p2 = fVertices.get(i);
        PVector p3 = fVertices.get(i + 1);
        PVector d1 = PVector.sub(p2, p1);
        PVector d2 = PVector.sub(p3, p2);
        PVector sum = PVector.add(d1, d2);
        // if the 2 segments are
        if (// vertical and then horizontal
          (d1.x == 0 && d1.mag() == fGrid.getCellHeight() &&
           d2.y == 0 && d2.mag() == fGrid.getCellWidth()) ||
          // horizontal and then vertical
          (d1.y == 0 && d1.mag() == fGrid.getCellWidth() &&
           d2.x == 0 && d2.mag() == fGrid.getCellHeight()) ||
          // overlap
          sum.mag() == 0 || sum.x == 0 || sum.y == 0) {
          fVertices.remove(p2);
          changed = true;
        }
        else if (// 2 consecutive diagonals not in the same direction
          PVector.sub(d1, d2).mag() != 0 &&
          d1.mag() == fGrid.getCellDiagonal() &&
          d2.mag() == fGrid.getCellDiagonal()) {
          PVector mid = PVector.mult(PVector.add(p1, p3), 0.5);
          fVertices.get(i).set(mid);
        }
        else {
          p1 = p2;
          i += 1;
        }
      }
    }
  }

  private void straightLine(PVector start, PVector end) {
    PVector diff = PVector.sub(end, start);
    float incx = diff.x/abs(diff.x) * fGrid.getCellWidth();
    float incy = diff.y/abs(diff.y) * fGrid.getCellHeight();
    int count = round(diff.mag() / fGrid.getCellDiagonal());
    for (int i = 0; i < count; i++)
      fVertices.add(new PVector(start.x + i*incx, start.y + i*incy));
  }
  private void recontructOptimal() {
    if (fVertices.size() <= 2)
      return;
    PVector first = fVertices.get(0);
    PVector last = fVertices.get(fVertices.size()-1);
    PVector diff = PVector.sub(last, first);
    float ax = abs(diff.x);
    float ay = abs(diff.y);
    fVertices.clear();
    fVertices.add(first);
    PVector curr = first;
    int maxcount = ceil(diff.mag()/fGrid.getCellDiagonal() * 2);
    while (PVector.sub(last, curr).mag() != 0 &&
           fVertices.size() < maxcount) {
      // if it's a straight diagonal
      if (ax == ay || ax == 0 || ay == 0) {
        straightLine(curr, last);
        break;
      }
      else {
        PVector inc = (ax > ay) ? new PVector(diff.x/ax * fGrid.getCellWidth(), 0)
                                : new PVector(0, diff.y/ay * fGrid.getCellHeight());
        curr = PVector.add(curr, inc);
        fVertices.add(curr);
      }
      diff = PVector.sub(last, curr);
      ax = abs(diff.x);
      ay = abs(diff.y);
      println(diff);
    }
  }

  @Override
  public void reduce() {
    recontructOptimal();
    this.removeJags();
  }

  public Path convertToPath() {
    Path p = null;
    if (fPathType == Constants.AXON)
      p = new Axon(fSrc, fLoc.x, fLoc.y, fColor);
    else if (fPathType == Constants.DENDRITE)
      p = new Dendrite(fSrc, fLoc.x, fLoc.y, fColor);
    else
      return null;
    for (PVector v : fVertices)
      p.add(v);
    return p;
  }

  public int getType() {
    return Constants.GEOPATH;
  }
}