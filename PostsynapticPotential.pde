class PostsynapticPotential extends Signal {
  color fSignalColor;
  PostsynapticPotential(float speed, float length, float strength, Path p) {
    super((strength >= 0) ? Constants.EPSP : Constants.IPSP, speed, length, strength, p);
    fSignalColor = (fStrength >= 0) ? Constants.EPSP_COLOR : Constants.IPSP_COLOR;
  }

  public Signal makeCopy(Path p) {
    return new PostsynapticPotential(fSpeed, fLength, fStrength, p);
  }

  void drawRange() {
    if (fLength <= 1) return;
    pushStyle();
      strokeWeight(Constants.SIGNAL_WIDTH - Constants.SIGNAL_BORDER_WIDTH);
      int offset = (int)(abs(fStrength)/Constants.SIGNAL_RESOLUTION);
      PVector begin, end;
      int t1 = round(constrain(fCurrIndex - offset - fLength, 0, fEndIndex));
      int t2 = round(constrain(fCurrIndex - offset, 0, fEndIndex));
      int t3 = round(constrain(fCurrIndex + offset, 0, fEndIndex));
      int t4 = round(constrain(fCurrIndex + offset + fLength, 0, fEndIndex));

      for (int i = t1, j = t4-1; i < t2 && j >= t3; ++i, --j) {
        stroke(lerpColor(fColor, fSignalColor, float(i-t1)/(t2-t1)));
        begin = fPath.fVertices.get(i);
        end = fPath.fVertices.get(i+1);
        line(begin.x, begin.y, end.x, end.y);
        begin = fPath.fVertices.get(j);
        end = fPath.fVertices.get(j+1);
        line(begin.x, begin.y, end.x, end.y);
      }
    popStyle();
  }
  void draw() {
    pushStyle();
      strokeWeight(Constants.SIGNAL_BORDER_WIDTH);
      stroke(fColor);
      fill(fSignalColor);
      float s = abs(fStrength) + Constants.SIGNAL_WIDTH/2;
      ellipse(fLoc.x, fLoc.y, s, s);
    popStyle();
  }
}