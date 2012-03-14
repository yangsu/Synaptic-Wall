class PostsynapticPotential extends Signal {
  PostsynapticPotential(float speed, float length, float strength, Path p) {
    super((strength >= 0) ? Constants.EPSP : Constants.IPSP, speed, length, strength, p);
  }

  public Signal makeCopy(Path p) {
    return new PostsynapticPotential(fSpeed, fLength, fStrength, p);
  }

  public void drawSignalBody() {
    if (fLength <= 1) return;
    pushStyle();
      strokeWeight(Constants.SIGNAL_RANGE_WIDTH);
      int offset = ceil((abs(fStrength)/Constants.SIGNAL_MAX_STRENGTH) *
                       Constants.SIGNAL_WIDTH/Constants.SIGNAL_RESOLUTION +
                       Constants.SIGNAL_BASE - Constants.SIGNAL_BORDER_WIDTH);
      int t1 = round(constrain(fCurrIndex - offset - fLength, 0, fEndIndex));
      int t2 = ceil(constrain(fCurrIndex - offset, 0, fEndIndex));
      int t3 = floor(constrain(fCurrIndex + offset, 0, fEndIndex));
      int t4 = round(constrain(fCurrIndex + offset + fLength, 0, fEndIndex));
      int i = t1, j = t4-1;
      PVector begin, end;
      for (int it = 0; it < fLength; ++it) {
        stroke(lerpColor(0xFFFFFF & fColor, fHighlightColor, it/fLength));
        if (i < t2) {
          begin = fPath.fVertices.get(i);
          end = fPath.fVertices.get(i+1);
          line(begin.x, begin.y, end.x, end.y);
        }
        if (j >= t3) {
          begin = fPath.fVertices.get(j);
          end = fPath.fVertices.get(j+1);
          line(begin.x, begin.y, end.x, end.y);
        }
        ++i;
        --j;
      }

      // Temporary Fix with fFired flag
      if (t4 >= fEndIndex && !fFired && ((Drawable)fDest).getType() == Constants.SOMA)
        fire();
    popStyle();
  }

  private void debug(int t1, int t2, int t3, int t4) {
    pushStyle();
    PVector p;
    p = fPath.fVertices.get(t1);
    fill(255, 0, 0);
    ellipse(p.x, p.y, 2, 2);
    p = fPath.fVertices.get(t2);
    fill(0, 255, 0);
    ellipse(p.x, p.y, 2, 2);
    p = fPath.fVertices.get(t3);
    fill(0, 0, 255);
    ellipse(p.x, p.y, 2, 2);
    p = fPath.fVertices.get(t4);
    fill(255, 255, 255);
    ellipse(p.x, p.y, 2, 2);
    popStyle();
  }

  public void draw() {
    pushStyle();
      strokeWeight(Constants.SIGNAL_BORDER_WIDTH);
      stroke(fColor);
      fill(fHighlightColor);
      float s = (abs(fStrength)/Constants.SIGNAL_MAX_STRENGTH) * Constants.SIGNAL_WIDTH + Constants.SIGNAL_BASE;
      ellipse(fLoc.x, fLoc.y, s, s);
    popStyle();
  }
}