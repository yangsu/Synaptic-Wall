public class Grid extends Interactive {
  private PVector[][] fGrid;
  private int fHorizontalCount, fVerticalCount;
  private float fCellWidth, fCellHeight, fCellDiagonal;
  private float fWidth, fHeight;
  private PVector fCurrent;

  public Grid(float size, int count) {
    this(size, size, count, count);
  }
  public Grid(float w, float h, int hc, int vc) {
    fWidth = w;
    fHeight = h;
    fHorizontalCount = hc;
    fVerticalCount = vc;
    fCellWidth = w/hc;
    fCellHeight = h/vc;
    fCellDiagonal = sqrt(sq(fCellWidth) + sq(fCellHeight));
    fGrid = new PVector[fHorizontalCount+1][fVerticalCount+1];
    for (int i = 0; i <= fHorizontalCount; i++) {
      for (int j = 0; j <= fVerticalCount; j++) {
        fGrid[i][j] = new PVector(i*fCellWidth, j*fCellHeight);
      }
    }
    fCurrent = new PVector(0, 0);
  }

  public int getType() {
    return GRID;
  }

  public float getCellWidth() {
    return fCellWidth;
  }

  public float getCellHeight() {
    return fCellHeight;
  }

  public float getCellDiagonal() {
    return fCellDiagonal;
  }

  public void draw() {
    for (int i = 0; i <= fHorizontalCount; i++) {
      for (int j = 0; j <= fVerticalCount; j++) {
        PVector p = fGrid[i][j];
        fill(GRID_NODE_COLOR);
        rect(p.x, p.y, GRID_NODE_SIZE, GRID_NODE_SIZE);
      }
    }
    if (fCurrent != null) {
      fill(GRID_NODE_HIGHLIGHT);
      rect(fCurrent.x, fCurrent.y,
           GRID_NODE_SIZE,
           GRID_NODE_SIZE);
    }
  }

  public PVector getCurrent() {
    return fCurrent;
  }

  protected boolean isInBounds(float x, float y) {
    int xi = round(mouseX/fCellWidth);
    int yi = round(mouseY/fCellHeight);
    if (fGrid.length > 0 && fGrid[0].length > 0 &&
        xi < fGrid.length && yi < fGrid[0].length &&
        xi >= 0 && yi >= 0)
      fCurrent = fGrid[xi][yi];
    return true;
  }
}