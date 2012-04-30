public abstract class Cell extends Shape implements Controllable {
  private boolean fControlActive;
  protected boolean fControlVisible;

  protected ArrayList<Path> fAxons;
  protected ArrayList<Path> fDendrites;
  protected ArrayList<Control> fControls;

  public Cell(float x, float y, float size, color cc) {
    super(x, y, size, cc);

    fAxons = new ArrayList<Path>();
    fDendrites = new ArrayList<Path>();
    fControls = new ArrayList<Control>();
  }

  public void addPath(Path p) {
    if (p.getType() ==Constants.DENDRITE)
      fDendrites.add(p);
    else if (p.getType() == Constants.AXON)
      fAxons.add(p);
  }

  public abstract void copyAttributes(Cell c);

  public void showControls() {
    fControlVisible = true;
  }

  public void hideControls() {
    fControlVisible = false;
  }

  public void drawControls() {
    for (Control c : fControls)
      c.draw();
  }

  protected void drawDendrites() {
    for (Path p : fDendrites)
      p.draw();
  }

  protected void drawAxons() {
    for (Path p : fAxons)
      p.draw();
  }

  public void draw() {
    if (fControlVisible) {
      this.drawControls();
    }
  }

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
      this.flipColor();
      return true;
    }
    return false;
  }

  public boolean onMouseDown(float x, float y) {
    if (fControlVisible) {
      fControlActive = false;
      for (Control c : fControls) {
        fControlActive = c.onMouseDown(x, y);
        if (fControlActive) {
          fSelected = true;
          return true;
        }
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
      if (fControlActive && fControlVisible) {
        for (Control c : fControls)
          if (c.onMouseDragged(x, y))
            return true;
        return false;
      }
      else {
        this.translate(new PVector(x - this.fLoc.x, y - this.fLoc.y));
        return true;
      }
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
    for (Control c : fControls)
      if (c.onMouseMoved(x, y))
        return true;
    // for (Path p : fAxons)
    //   if (p.onMouseMoved(x, y))
    //     return true;
    // for (Path p : fDendrites)
    //   if (p.onMouseMoved(x, y))
    //     return true;
    return super.onMouseMoved(x, y);
  }

  public boolean onMouseUp(float x, float y) {
    if (fControlActive && fControlVisible) {
      for (Control c : fControls)
        if (c.onMouseUp(x, y))
          return true;
    }
    fControlActive = false;
    // for (Path p : fAxons)
    //   if (p.onMouseUp(x, y))
    //     return true;
    // for (Path p : fDendrites)
    //   if (p.onMouseUp(x, y))
    //     return true;
    return super.onMouseUp(x, y);
  }
}