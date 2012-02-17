public abstract class Path extends Interactive implements Signalable{
  protected ArrayList<PVector> fVertices;
  protected ArrayList<Signal> fSignals;
  protected ArrayList<Path> fConnectedPaths;

  protected int fCurrIndex;
  protected Signalable fDest;
  protected Signalable fSrc;
  protected boolean fClosed;

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
    fSrcLoc = new PVector(x,y);
    fVertices.add(new PVector(x,y));
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
    //Get the coordinates of the previously added point.
    PVector prev = (PVector)fVertices.get(fVertices.size()-1);
    float px = prev.x;
    float py = prev.y;

    //Find the difference between the previous location and the current one, and normalizes dx and dy using that difference
    float num;
    if(abs(x-px)>abs(y-py))
      num = abs(x-px);
    else
      num = abs(y-py);
    float dx=(x-px)/num;
    float dy=(y-py)/num;

    //Add all the fVertices in between the previous and current fVertices using dx and dy
    for(int i = 1;i<=num;i++) {
      fVertices.add(new PVector(px+i*dx,py+i*dy));
    }
  }
  public void add(PVector p) {
    if (fClosed) return;
    this.add(p.x, p.y);
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

  public void reduce() {
    this.reduce(Constants.SIGNAL_RESOLUTION);
  }

  public void reduce(int resFactor) {
    for (int i = fVertices.size()-2;i>=1;i--) {
      if(i%resFactor==0)
        continue;
      else
        fVertices.remove(i);
    }
  }

  public void draw() {
    pushStyle();
      drawPath();
      if (fHover) {
        drawJunction(fVertices.get(fCurrIndex).x, fVertices.get(fCurrIndex).y);
      }
    popStyle();

    processSignals();
    for (Signal s : fSignals)
      s.draw();
  }
  private void drawPath() {
    pushStyle();
    noFill();
    stroke((fHover) ? fHighlightColor : fColor);
    beginShape();
      PVector temp = fVertices.get(0);
      vertex(temp.x, temp.y);
      for (int i = 1; i < fVertices.size() - 1; ++i) {
        temp = fVertices.get(i);
        curveVertex(temp.x,temp.y);
      }
    endShape();
    popStyle();
  }
  private void drawJunction(float x, float y) {
    pushStyle();
      fill(fColor);
      ellipse(x, y, Constants.SIGNAL_WIDTH, Constants.SIGNAL_WIDTH);
    popStyle();
  }
  private void drawJunction(PVector p) {
    drawJunction(p.x, p.y);
  }

  private void processSignals() {
    for (int i = fSignals.size() - 1; i >= 0; --i) {
      Signal curr = fSignals.get(i);
      curr.step();
      if (curr.reachedDestination())
        fSignals.remove(curr);
      else {
        for (int j = i; j >= 0; --j) { //Combine adjacent signals
          Signal s = fSignals.get(j);
          if (s != curr && PVector.dist(s.fLoc, curr.fLoc) <= abs(s.fStrength) &&
              s.fType != 0 && curr.fType != 0) {
            PostsynapticPotential p = new PostsynapticPotential((s.fSpeed + curr.fSpeed)/2,
                                                                (s.fLength + curr.fLength)/2,
                                                                (s.fStrength + curr.fStrength)/1.2, this);
            p.setIndex(s.fCurrIndex);
            this.addSignal(p);
            fSignals.remove(curr);
            fSignals.remove(s);
            break;
          }
        }
        for (Path p : fConnectedPaths) {
          if (PVector.dist(p.fSrcLoc, curr.fLoc) <= Constants.SIGNAL_RESOLUTION)
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
    this.addSignal(copy);
  }

  public boolean isInBounds(float x, float y) {
    PVector mouse = new PVector(x,y);
    PVector temp;
    for (int i = 0; i < fVertices.size(); ++i) {
      temp = fVertices.get(i);
      if (PVector.dist(mouse, temp) <= Constants.SIGNAL_WIDTH) {
        fCurrIndex = i;
        return true;
      }
    }
    return false;
  }
}