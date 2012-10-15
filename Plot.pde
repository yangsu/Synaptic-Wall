public class Plot extends Interactive {
  private PVector[] fData, fTransformedData;
  private PVector fTL, fBR, fDimension, fMin, fMax, fRange;
  private boolean fShowGrid, fBackground;

  public Plot(PVector topleft, PVector bottomright, PVector[] data) {
    fData = data;

    fTL = topleft;
    fBR = bottomright;
    fDimension = PVector.sub(fBR, fTL);

    fMin = new PVector(MAX, MAX);
    fMax = new PVector(MIN, MIN);
    for (PVector p: data) {
      if (p.x < fMin.x) fMin.x = p.x;
      if (p.y < fMin.y) fMin.y = p.y;
      if (p.x > fMax.x) fMax.x = p.x;
      if (p.y > fMax.y) fMax.y = p.y;
    }
    fRange = PVector.sub(fMax, fMin);

    this.computeTransformations();

    fShowGrid = true;
    fBackground = true;
  }

  private void computeTransformations() {
    fTransformedData = new PVector[fData.length];
    for (int i = 0; i < fData.length; i++) {
      fTransformedData[i] = new PVector(
        fData[i].x/fRange.x*fDimension.x + fTL.x,
        fBR.y - fData[i].y/fRange.y*fDimension.y
      );
    }
  }

  public int getType() {
    return PLOT;
  }

  public void draw() {
    pushStyle();
      // if (fShowGrid) {
      //   for (float i = fTL.x; i <= fBR.x; i += ) {
      //     for (float j = fTL.y; j <= fBR.y; j += ) {
      //       PVector p = fGrid[i][j];
      //       fill(GRID_NODE_COLOR);
      //       rect(p.x, p.y, GRID_NODE_SIZE, GRID_NODE_SIZE);
      //     }
      //   }
      // }
      if (fBackground) {
        fill(BG_COLOR);
        rect(fTL.x, fTL.y, fDimension.x, fDimension.y);
      }
      noFill();
      stroke(255);
      strokeWeight(1);
      beginShape();
      for (PVector p: fTransformedData) {
        vertex(p.x, p.y);
      }
      endShape();
    popStyle();
  }


  protected boolean isInBounds(float x, float y) {
    return fTL.x <= x && x <= fBR.x &&
           fTL.y <= y && y <= fBR.y;
  }
}