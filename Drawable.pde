public abstract class Drawable {
  protected color fColor;
  protected color fHighlightColor;
  protected PVector fLoc;
  protected boolean fVisible;
  protected boolean fMovable;

  public Drawable() {
    this(0, 0, color(255));
  }

  public Drawable(float x, float y) {
    this(x, y, color(255));
  }

  public Drawable(float x, float y, color cc) {
    fLoc = new PVector(x, y);
    fVisible = fMovable = true;
    fColor = cc;
    if (cc == Constants.EX_COLOR)
      fHighlightColor = Constants.EX_HIGHLIGHT_COLOR;
    else if (cc == Constants.IN_COLOR)
      fHighlightColor = Constants.IN_HIGHLIGHT_COLOR;
    else
      fHighlightColor = Util.highlight(fColor);
  }

  public void flipColor() {
    if (fColor == Constants.EX_COLOR) {
      fColor = Constants.IN_COLOR;
      fHighlightColor = Constants.IN_HIGHLIGHT_COLOR;
    }
    else if (fColor == Constants.IN_COLOR) {
      fColor = Constants.EX_COLOR;
      fHighlightColor = Constants.EX_HIGHLIGHT_COLOR;
    }
    else if (fColor == Constants.EX_HIGHLIGHT_COLOR) {
      fColor = Constants.IN_HIGHLIGHT_COLOR;
      fHighlightColor = Util.highlight(fColor);
    }
    else if (fColor == Constants.IN_HIGHLIGHT_COLOR) {
      fColor = Constants.EX_HIGHLIGHT_COLOR;
      fHighlightColor = Util.highlight(fColor);
    }
    else {
      println("unknow color");
    }
  }

  public abstract int getType();

  public PVector getLoc() {
    return fLoc;
  }

  public void translate(PVector change) {
    if (fMovable)
      fLoc.add(change);
  }

  public void setVisible(boolean visible) {
    fVisible = visible;
  }

  public void setMovable(boolean movable) {
    fMovable = movable;
  }

  public abstract void draw();
  public void update() {
    //Perform functions that produce animations or other forms of change over time
  };
  public void drawAndUpdate() {
    update();
    draw();
  }
}