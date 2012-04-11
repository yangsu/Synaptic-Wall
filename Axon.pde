public class Axon extends Path {
  public Axon(Signalable src, float x, float y, color cc) {
    super(src, x, y, cc);
  }

  public void flipColor() {
    super.flipColor();
    ((Drawable)fDest).flipColor();
  }

  public int getType() {
    return Constants.AXON;
  }

  protected void drawPath() {
    pushStyle();
    noFill();
    strokeWeight(Constants.PATH_WIDTH);
    stroke(Constants.SHADOW_COLOR);
    this.drawPathShape(Constants.SHADOW_OFFSETX, Constants.SHADOW_OFFSETY);

    stroke((fHover) ? fHighlightColor : fColor);
    this.drawPathShape(0, 0);
    popStyle();
  }
}