public abstract class Cell extends ControllableShape {
  protected ArrayList<Path> fAxons;
  protected ArrayList<Path> fDendrites;

  protected int fTotalTime, fLastFired, fNumFired;
  protected float fAvgFiringRate, fCurrentFiringRate;

  public Cell(float x, float y, float size, color cc) {
    super(x, y, size, cc);

    fAxons = new ArrayList<Path>();
    fDendrites = new ArrayList<Path>();
    fLastFired = 0;
    fNumFired = 0;
    fAvgFiringRate = 0;
    fCurrentFiringRate = 0;
  }

  protected void fire() {
    if (fireSignals()) {
      int current = millis();
      fNumFired++;
      if (fNumFired > 1) {
        float interval = (current - fLastFired)/1000.0;
        fCurrentFiringRate = 1.0/interval;
        fTotalTime += interval;
        fAvgFiringRate = 1/(float(fTotalTime)/fNumFired);
        // println(fCurrentFiringRate + " " + fAvgFiringRate);
      }
      fLastFired = current;
    }
  }

  public float getAvgFiringRate() {
    return fAvgFiringRate;
  }

  public float getCurrentFiringRate() {
    return fCurrentFiringRate;
  }

  protected abstract boolean fireSignals();

  public void addPath(Path p) {
    if (p.getType() ==Constants.DENDRITE)
      fDendrites.add(p);
    else if (p.getType() == Constants.AXON)
      fAxons.add(p);
  }

  public ArrayList<Path> getAxons() {
    return fAxons;
  }

  public ArrayList<Path> getDendrites() {
    return fDendrites;
  }

  public abstract void copyAttributes(Cell c);

  public boolean isInBounds(float x, float y) {
    return PVector.dist(fLoc, new PVector(x, y)) <= fSize;
  }

  public void flipColor() {
    super.flipColor();
    for (Path p : fAxons)
      p.flipColor();
    for (Path p : fDendrites)
      p.flipColor();
  }

  public boolean onDblClick(float x, float y) {
    if (isInBounds(x, y)) {
      flipColor();
      return true;
    }
    return false;
  }

  public boolean onMouseDown(float x, float y) {
    for (Control c : fControls) {
      if (c.fVisible && c.onMouseDown(x, y)) {
          return (fSelected = true);
      }
    }
    // for (Path p : fAxons)
    //   if (p.onMouseDown(x, y))
    //     return true;
    // for (Path p : fDendrites)
    //   if (p.onMouseDown(x, y))
    //     return true;
    return super.onMouseDown(x, y);
  }

  public void translate(PVector change) {
    if (fMovable) {
      for (Path dendrite : fAxons)
        dendrite.translate(change);
      for (Control c : fControls)
        c.translate(change);
      super.translate(change);
    }
  }
  public boolean onMouseDragged(float x, float y) {
    if (fSelected) {
      for (Control c : fControls) {
        if (c.fVisible && c.onMouseDragged(x, y))
          return true;
      }

      translate(new PVector(x - fLoc.x, y - fLoc.y));
      return true;
    }
    // for (Path p : fAxons)
    //   if (p.onMouseDragged(x, y))
    //     return true;
    // for (Path p : fDendrites)
    //   if (p.onMouseDragged(x, y))
    //     return true;
    return super.onMouseDragged(x, y);
  }

  public boolean onMouseMoved(float x, float y) {
    for (Control c : fControls) {
      if (c.fVisible && c.onMouseMoved(x, y))
        return true;
    }
    // for (Path p : fAxons)
    //   if (p.onMouseMoved(x, y))
    //     return true;
    // for (Path p : fDendrites)
    //   if (p.onMouseMoved(x, y))
    //     return true;
    return super.onMouseMoved(x, y);
  }

  public boolean onMouseUp(float x, float y) {
    for (Control c : fControls) {
      if (c.fVisible && c.onMouseUp(x, y))
        return true;
    }
    // for (Path p : fAxons)
    //   if (p.onMouseUp(x, y))
    //     return true;
    // for (Path p : fDendrites)
    //   if (p.onMouseUp(x, y))
    //     return true;
    return super.onMouseUp(x, y);
  }
}