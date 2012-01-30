public abstract class Cell extends Shape implements Controllable {
  private boolean fControlActive;

  public Cell(float x, float y, float size, color cc) {
		super(x, y, size, cc);  
	}

	public boolean isInBounds(float x, float y) {
    return PVector.dist(fLoc, new PVector(x, y)) <= fSize;
  }
  
  public boolean onMouseDown(float x, float y) {
    fControlActive = false;
    for (Control c : fControls) {
      fControlActive = c.onMouseDown(x, y);
      if (fControlActive) {
        fSelected = true;
        return true;
      }
    }
    return super.onMouseDown(x,y);
  }
  
  public boolean onMouseDragged(float x, float y) {
    if (fSelected) {
      if (fControlActive) {
        for (Control c : fControls)
          if (c.onMouseDragged(x,y))
            return true;
        return false;
      }
      else {
        this.translate(new PVector(x - this.fLoc.x, y - this.fLoc.y));
        return true;
      }
    }
    else
      return super.onMouseDragged(x,y);
  }
  
  public boolean onMouseMoved(float x, float y) {
    for (Control c : fControls)
      if (c.onMouseMoved(x,y))
        return true;
    return super.onMouseMoved(x,y);
  }
  
  public boolean onMouseUp(float x, float y) {
    fControlActive = false;
    for (Control c : fControls)
      if (c.onMouseUp(x,y))
        return true;
    return super.onMouseUp(x,y);
  }
}