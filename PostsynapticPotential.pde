class PostsynapticPotential extends Signal {
  color fSignalColor;
  float fSize;
  PostsynapticPotential(float speed, float length, float strength, float mult, Path p) {
    super((strength >= 0) ? Constants.EPSP : Constants.IPSP, speed, length, strength, p);
    fStrength *= mult;
    fSize = Constants.SIGNAL_WIDTH*mult;
    fSignalColor = (fStrength >= 0) ? Constants.EX_COLOR : Constants.IN_COLOR;
  }

  void draw() {
    pushStyle();
      int offset = (int)(fSize/Constants.SIGNAL_RESOLUTION);
      PVector begin, end;
      color t1, t2;
      int t3 = round(constrain(fCurrIndex - offset - fLength, 0, fEndIndex));
      int t4 = round(constrain(fCurrIndex - offset, 0, fEndIndex));
      for (int i = t3; i < t4; ++i) {
        begin = fPath.fVertices.get(i);
        end = fPath.fVertices.get(i+1);
        t1 = lerpColor(fColor, fSignalColor, map(i, t3, t4, 0, 1));
        t2 = lerpColor(fColor, fSignalColor, map(i+1, t3, t4, 0, 1));
        gradient(begin, end, t1, t2);
      }
      t3 = round(constrain(fCurrIndex + offset, 0, fEndIndex));
      t4 = round(constrain(fCurrIndex + offset + fLength, 0, fEndIndex));
      for (int i = t3; i < t4; ++i) {
        begin = fPath.fVertices.get(i);
        end = fPath.fVertices.get(i+1);
        t1 = lerpColor(fSignalColor, fColor, map(i, t3, t4, 0, 1));
        t2 = lerpColor(fSignalColor, fColor, map(i+1, t3, t4, 0, 1));
        gradient(begin, end, t1, t2);
      }
      stroke(fColor);
      fill(fSignalColor);
      ellipse(fLoc.x, fLoc.y, fSize, fSize);
    popStyle();
  }
  
  void gradient(PVector a, PVector b, color c, color d) {
    pushStyle();
      int div = floor(PVector.dist(a, b));
      float j, k, xt, yt, xt2, yt2;
      strokeWeight(Constants.DENDRITE_WIDTH);
      for (int i = 0; i < div; i++) {
        j = float(i)/div;
        k = float(i+1)/div;
        stroke(lerpColor(c, d, j));
        xt = lerp(a.x, b.x, j);
        yt = lerp(a.y, b.y, j);
        xt2 = lerp(a.x, b.x, k);
        yt2 = lerp(a.y, b.y, k);
        line(xt, yt, xt2, yt2);
      }
    popStyle();
  }
  void gradient(float x1, float y1, float x2, float y2, color a, color b) {
    this.gradient(new PVector(x1, y1), new PVector(x2, y2), a, b);
  }
}