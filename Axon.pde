public class Axon extends Path {
  public Axon(Signalable src, float x, float y, color cc) {
    super(src, x, y, cc);
  }

  public void flipColor() {
    super.flipColor();
    ((Drawable)fDest).flipColor();
  }

  public int getType() {
    return AXON;
  }

  public void drawBackground() {
    pushStyle();
    noFill();
    strokeWeight(PATH_WIDTH);
    stroke(SHADOW_COLOR);
    drawPathShape(SHADOW_OFFSETX, SHADOW_OFFSETY);
    popStyle();
    super.drawBackground();
  }
}