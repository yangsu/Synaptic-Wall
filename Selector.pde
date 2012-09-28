/*
 * Selector Class
 * Used for keeping the state of selection, rendering, and updating the selection areas
 */

public class Selector {
  private PVector fStart, fEnd;
  private boolean fSelecting;

  public Selector() {
    fStart = new PVector();
    fEnd = new PVector();
    fSelecting = false;
  }

  public boolean isSelecting() {
    return fSelecting;
  }

  public PVector getStart() {
    return fStart;
  }

  public PVector getEnd() {
    return fEnd;
  }

  public void beginSelection(float x, float y) {
    fStart.set(x, y, 0);
    fEnd.set(x, y, 0);
    fSelecting = true;
  }

  public void updateSelection(float x, float y) {
    fEnd.set(x, y, 0);
  }

  public void endSelection(float x, float y) {
    fSelecting = false;
  }

  public void draw() {
    if (isSelecting()) {
      pushStyle();
        stroke(Constants.SELECTION_BORDER_COLOR);
        strokeWeight(Constants.SELECTION_BORDER_WIDTH);
        fill(Constants.SELECTION_COLOR);
        PVector size = PVector.sub(fEnd, fStart);
        rect(fStart.x, fStart.y, size.x, size.y);
      popStyle();
    }
  }
}