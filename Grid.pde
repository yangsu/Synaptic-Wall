public class Grid extends Interactive{
  private PVector[][] fGrid;
  private int fHorizontalCount, fVerticalCount;
  private float fCellWidth, fCellHeight;
  private float fWidth, fHeight;
  private PVector fCurrent;

  public Grid(float size, int count) {
    this(size, size, count, count);
  }
  public Grid(float w, float h, int hc, int vc) {
    this.fWidth = w;
    this.fHeight = h;
    this.fHorizontalCount = hc;
    this.fVerticalCount = vc;
    this.fCellWidth = w/hc;
    this.fCellHeight = h/vc;
    this.fGrid = new PVector[fHorizontalCount+1][fVerticalCount+1];
    for (int i = 0; i <= fHorizontalCount; i++) {
      for (int j = 0; j <= fVerticalCount; j++) {
        fGrid[i][j] = new PVector(i*fCellWidth, j*fCellHeight);
      }
    }
    this.fCurrent = new PVector(0, 0);
  }

  public int getType() {
    return Constants.GRID;
  }

  public void draw() {
    for (int i = 0; i <= fHorizontalCount; i++) {
      for (int j = 0; j <= fVerticalCount; j++) {
        PVector p = fGrid[i][j];
        fill(Constants.GRID_NODE_COLOR);
        rect(p.x, p.y, Constants.GRID_NODE_SIZE, Constants.GRID_NODE_SIZE);
      }
    }
    if (fCurrent != null) {
      fill(Constants.GRID_NODE_HIGHLIGHT);
      rect(fCurrent.x, fCurrent.y,
           Constants.GRID_NODE_SIZE,
           Constants.GRID_NODE_SIZE);
    }
  }

  public PVector getCurrent() {
    return fCurrent;
  }

  protected boolean isInBounds(float x, float y) {
    int xi = round(mouseX/fCellWidth);
    int yi = round(mouseY/fCellHeight);
    if (fGrid.length > 0 && fGrid[0].length > 0 &&
        xi < fGrid.length && yi < fGrid[0].length)
      fCurrent = fGrid[xi][yi];
    return true;
  }
}