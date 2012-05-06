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

  public void drawBackground() {
    pushStyle();
    noFill();
    strokeWeight(Constants.PATH_WIDTH);
    stroke(Constants.SHADOW_COLOR);
    drawPathShape(Constants.SHADOW_OFFSETX, Constants.SHADOW_OFFSETY);
    popStyle();
    super.drawBackground();
  }
}