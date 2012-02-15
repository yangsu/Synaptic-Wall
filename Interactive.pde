public abstract class Interactive extends Drawable{
  protected boolean fSelected;
  protected boolean fHover;

  public Interactive() {
    super();
  }

  public Interactive(float x, float y) {
    super(x, y);
  }

  public Interactive(float x, float y, color cc) {
    super(x, y, cc);
  }

  protected abstract boolean isInBounds(float x, float y);

  public boolean onMouseDown(float x, float y) {
    return (fSelected = this.isInBounds(x, y));
  }

  public boolean onMouseMoved(float x, float y) {
    return (fHover = this.isInBounds(x,y));
  }

  public boolean onMouseDragged(float x, float y) {
    return false;
  }

  public boolean onMouseUp(float x, float y) {
    return false;
  }

  public boolean onDblClick(float x, float y) {
    return false;
  }

  public boolean select(float x, float y) {
    return (fSelected = this.isInBounds(x, y));
  }

  public void deselect() {
    fSelected = false;
  }
}