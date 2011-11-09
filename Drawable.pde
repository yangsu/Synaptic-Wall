public abstract class Drawable {
  protected color fColor;
  protected PVector fLoc;
  protected boolean fVisible;
  
  public Drawable() {
    this(0, 0, color(255));
  }
  
  public Drawable(float x, float y) {
    this(x, y, color(255));
  }
  
  public Drawable(float x, float y, color cc) {
    fLoc = new PVector(x, y);
    fVisible = true;
    fColor = cc;
  }
  
  public void translate(PVector change) {
    fLoc.add(change);
  }
  
  public void setVisible(boolean visible) { 
    fVisible = visible;
  }
  
  public abstract void draw();
}