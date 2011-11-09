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
    return (fHover = this.isInBounds(x, y));
  }
  
  public boolean onMouseDragged(float x, float y) {
    return (fHover = this.isInBounds(x, y));
  }
  
  public boolean onMouseUp(float x, float y) {
    return (fSelected = fHover = false);
  }
}