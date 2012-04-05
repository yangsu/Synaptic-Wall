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
    float num = max(abs(x-px), abs(y-py));
    float dx=(x-px)/num;
    float dy=(y-py)/num;

    //Add all the fVertices in between the previous and current fVertices using dx and dy
    for(int i = 1;i<=num;i++)
      fVertices.add(new PVector(px+i*dx,py+i*dy));
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

  public void update() {
    processSignals();
  }

  public void draw() {
    drawPath();
    if (fHover)
      drawJunction(getVertex(fCurrIndex));
    // Signals are drawn via drawSignals() method. Not called here by default
  }
  private void drawPath() {
    pushStyle();
    noFill();
    strokeWeight(Constants.PATH_WIDTH);
    stroke((fHover) ? fHighlightColor : fColor);
    beginShape();
      PVector temp = fVertices.get(0);
      vertex(temp.x, temp.y);
      for (int i = 1; i < fVertices.size() - 1; ++i) {
        temp = fVertices.get(i);
        vertex(temp.x,temp.y);
      }
    endShape();
    popStyle();
  }
  public void drawSignals() {
    for (Signal s : fSignals)
      s.draw();
    for (Signal s : fSignals)
      s.drawSignalBody();
  }

  protected void drawJunction(float x, float y) {
    pushStyle();
      fill((fHover) ? fHighlightColor : fColor);
      float s = Constants.SIGNAL_DEFAULT_WIDTH;
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
      if (curr.reachedDestination())
        fSignals.remove(curr);
      else {
        //Combine adjacent signals
        for (int j = i; j >= 0; --j) {
          Signal s = fSignals.get(j);
          // TODO
          // if (s != curr &&
          //     PVector.dist(s.fLoc, curr.fLoc) <= (abs(s.fStrength) + abs(curr.fStrength)) &&
          //     s.fType != 0 && curr.fType != 0) {
          //   PostsynapticPotential p = new PostsynapticPotential((s.fSpeed + curr.fSpeed)/2,
          //                                                       (s.fLength + curr.fLength)/2,
          //                                                       s.fStrength + curr.fStrength, this);
          //   p.setIndex(s.fCurrIndex);
          //   this.addSignal(p);
          //   fSignals.remove(curr);
          //   fSignals.remove(s);
          //   break;
          // }
        }
        //Copy Signals to connected paths
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
    float mindist = 9999, dist;
    for (int i = 0; i < fVertices.size(); ++i) {
      temp = fVertices.get(i);
      dist = PVector.dist(mouse, temp);
      if (dist <= Constants.SIGNAL_WIDTH/2 &&
          dist <= mindist) {
        fCurrIndex = i;
        mindist = dist;
      }
    }
    return mindist != 9999;
  }

  public void flipColor() {
    super.flipColor();
    for (Path p : fConnectedPaths)
      p.flipColor();
  }
}