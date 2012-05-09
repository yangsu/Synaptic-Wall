public abstract class Path extends Interactive implements Signalable{
  protected ArrayList<PVector> fVertices;
  protected ArrayList<Signal> fSignals;
  protected ArrayList<Path> fConnectedPaths;

  protected int fCurrIndex;
  protected Signalable fDest;
  protected Signalable fSrc;
  protected boolean fClosed, fSmooth;

  // Find a way to not special case this
  protected PVector fSrcLoc;
  protected int fDestPos;

  public Path(Signalable src, float x, float y, color cc) {
    super(x, y, cc);
    fConnectedPaths = new ArrayList<Path>();
    fVertices = new ArrayList<PVector>();
    fSignals = new ArrayList<Signal>();
    fCurrIndex = 0;
    fDest = null;
    fSrc = src;
    fClosed = false;
    fSmooth = false;
    fSrcLoc = new PVector(x,y);

    fVertices.add(new PVector(x, y));
  }

  public Path(Path p, float x, float y, color cc) {
    this((Signalable)p, x, y, cc);
    PVector temp = p.fVertices.get(p.fCurrIndex);
    fSrcLoc = new PVector(temp.x, temp.y);
  }

  public int size() {
    return fVertices.size();
  }

  public void close() {
    fClosed = true;
  }

  public void setDest(Signalable obj) {
    fDest = obj;
  }

  public void setDest(Path p) {
    fDest = p;
    fDestPos = p.fCurrIndex;
  }

  public void attachToSource() {
    fSrc.addPath(this);
  }

  public PVector getCurrVertex() {
    return fVertices.get(fCurrIndex);
  }
  public PVector getVertex(int i) {
    if (i < fVertices.size())
      return fVertices.get(i);
    else
      return null;
  }

  public void add(float x, float y) {
    if (fClosed) return;

    if (fVertices.size() > 0) {
      PVector last = fVertices.get(fVertices.size() - 1);
      if (last.x == x && last.y == y) return;
    }

    fVertices.add(new PVector(x, y));
  }

  public void add(PVector p) {
    if (fClosed) return;
    add(p.x, p.y);
  }

  public void addPath(Path p) {
    fConnectedPaths.add(p);
  }

  public void translate(PVector change) {
    if (fMovable)
      for (PVector vertex : fVertices) {
        vertex.add(change);
      }
  }

  public void update() {
    processSignals();
  }

  public void drawBackground() {
    for (Signal s : fSignals)
      s.drawBackground();
  }

  public void drawForeground() {
    drawPath();
    // for (PVector p : fVertices)
    //   drawJunction(p.x, p.y);
    if (fHover)
      drawJunction(getVertex(fCurrIndex));
    for (Signal s : fSignals)
      s.drawForeground();
  }

  protected void drawPathShape(float offsetx, float offsety) {
    beginShape();
      if (fSmooth) {
        for (PVector p : fVertices) {
          curveVertex(p.x + offsetx, p.y + offsety);
        }
      }
      else {
        for (PVector p : fVertices) {
          vertex(p.x + offsetx, p.y + offsety);
        }
      }
    endShape();
  }

  protected void drawPath() {
    pushStyle();
    noFill();
    strokeWeight(Constants.PATH_WIDTH);
    stroke((fHover) ? fHighlightColor : fColor);
    drawPathShape(0, 0);
    popStyle();
  }

  protected void drawJunction(float x, float y) {
    pushStyle();
      fill((fHover) ? fHighlightColor : fColor);
      float s = Constants.PATH_JUNCTION_WIDTH;
      ellipse(x, y, s, s);
    popStyle();
  }

  protected void drawJunction(PVector p) {
    drawJunction(p.x, p.y);
  }

  private void processSignals() {
    for (int i = fSignals.size() - 1; i >= 0; --i) {
      Signal curr = fSignals.get(i);
      curr.update();
      if (curr.firingComplete())
        fSignals.remove(curr);
      else {
        //Combine adjacent signals
        for (int j = i; j >= 0; --j) {
          Signal s = fSignals.get(j);
          if (s != curr &&
              PVector.dist(s.fLoc, curr.fLoc) <= (abs(s.fStrength) + abs(curr.fStrength)) &&
              s.fType != 0 && curr.fType != 0) {
            PostsynapticPotential p = new PostsynapticPotential(
              (s.fSpeed + curr.fSpeed)/2,
              (s.fLength + curr.fLength)/2,
              (s.fDecay + curr.fDecay)/2,
              s.fStrength + curr.fStrength,
              this);
            p.setIndex(s.fCurrIndex);
            addSignal(p);
            fSignals.remove(curr);
            fSignals.remove(s);
            break;
          }
        }
        //Copy Signals to connected paths
        for (Path p : fConnectedPaths) {
          if (PVector.dist(p.fSrcLoc, curr.fLoc) <= Constants.SIGNAL_WIDTH)
            p.addSignal(curr.makeCopy(p));
        }
      }
    }
  }

  public void addSignal(Signal s) {
    fSignals.add(s);
  }

  public void onSignal(Signal s) {
    Signal copy = s.makeCopy(this);
    copy.setIndex(s.fPath.fDestPos);
    addSignal(copy);
  }

  public boolean isInBounds(float x, float y) {
    PVector mouse = new PVector(x,y);
    PVector temp;
    float mindist = Constants.MAX, dist;
    for (int i = 0; i < fVertices.size(); ++i) {
      temp = fVertices.get(i);
      dist = PVector.dist(mouse, temp);
      if (dist <= Constants.PATH_WIDTH/2 &&
          dist <= mindist) {
        fCurrIndex = i;
        mindist = dist;
      }
    }
    return mindist != Constants.MAX;
  }

  public void flipColor() {
    super.flipColor();
    for (Path p : fConnectedPaths)
      p.flipColor();
  }

  private void simplify() {
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
          (d1.x == 0 && d1.mag() == gGrid.getCellHeight() &&
           d2.y == 0 && d2.mag() == gGrid.getCellWidth()) ||
          // horizontal and then vertical
          (d1.y == 0 && d1.mag() == gGrid.getCellWidth() &&
           d2.x == 0 && d2.mag() == gGrid.getCellHeight()) ||
          // overlap
          sum.mag() == 0 || sum.x == 0 || sum.y == 0 || d2.mag() == 0) {
          fVertices.remove(p2);
          changed = true;
        }
        else if (// 2 consecutive diagonals not in the same direction
          PVector.sub(d1, d2).mag() != 0 &&
          d1.mag() == gGrid.getCellDiagonal() &&
          d2.mag() == gGrid.getCellDiagonal()) {
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
    float incx = diff.x/abs(diff.x) * gGrid.getCellWidth();
    float incy = diff.y/abs(diff.y) * gGrid.getCellHeight();
    int count = round(diff.mag() / gGrid.getCellDiagonal());
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
    int maxcount = ceil(diff.mag()/gGrid.getCellDiagonal() * 2);
    while (PVector.sub(last, curr).mag() != 0 &&
           fVertices.size() < maxcount) {
      // if it's a straight diagonal
      if (ax == ay || ax == 0 || ay == 0) {
        straightLine(curr, last);
        break;
      }
      else {
        PVector inc = (ax > ay) ? new PVector(diff.x/ax * gGrid.getCellWidth(), 0)
                                : new PVector(0, diff.y/ay * gGrid.getCellHeight());
        curr = PVector.add(curr, inc);
        fVertices.add(curr);
      }
      diff = PVector.sub(last, curr);
      ax = abs(diff.x);
      ay = abs(diff.y);
    }
  }

  public boolean onSmoothToggle(boolean smooth) {
    if (fSmooth == smooth) return false;
    fSmooth = smooth;
    int last = fVertices.size() - 1;
    if (fSmooth) {
      // The first and last points in a series of curveVertex() lines will be
      // used to guide the beginning and end of a the curve.
      // So the first and last vertices need to be replicated
      fVertices.add(0, fVertices.get(0));
      fVertices.add(fVertices.get(last));
    }
    else {
      fVertices.remove(last);
      fVertices.remove(0);
    }
    return false;
  }
}