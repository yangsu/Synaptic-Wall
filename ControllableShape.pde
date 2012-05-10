public abstract class ControllableShape extends Shape implements Controllable {
  protected ArrayList<Control> fControls;
  public ControllableShape() {
    fControls = new ArrayList<Control>();
  }

  public ControllableShape(float x, float y, float size, color cc) {
    super(x, y, size, cc);
    fControls = new ArrayList<Control>();
  }

  public void showControls() {
    for (Control c : fControls) {
      c.setVisible(true);
    }
  }

  public void hideControls() {
    for (Control c : fControls) {
      c.setVisible(false);
    }
  }

  public void drawControls() {
    for (Control c : fControls)
      c.draw();
  }

  public boolean onMouseDown(float x, float y) {
    for (Control c : fControls) {
      if (c.fVisible && c.onMouseDown(x, y))
        return (fSelected = true);
    }
    return super.onMouseDown(x, y);
  }

  public boolean onMouseDragged(float x, float y) {
    if (fSelected) {
      for (Control c : fControls) {
        if (c.fVisible && c.onMouseDragged(x, y))
          return true;
      }
    }
    return super.onMouseDragged(x, y);
  }

  public boolean onMouseMoved(float x, float y) {
    for (Control c : fControls) {
      if (c.fVisible && c.onMouseMoved(x, y))
        return true;
    }
    return super.onMouseMoved(x, y);
  }

  public boolean onMouseUp(float x, float y) {
    for (Control c : fControls) {
      if (c.fVisible && c.onMouseUp(x, y))
        return true;
    }
    return super.onMouseUp(x, y);
  }
}