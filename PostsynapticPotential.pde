class PostsynapticPotential extends Signal {
  private float fPrevParam;
  private int fPrevIndex;
  private PVector fPrevLoc;

  PostsynapticPotential(float speed, float length, float decay, float strength, Path p) {
    super((strength >= 0) ? Constants.EPSP : Constants.IPSP, speed, length, decay, strength, p);
    fPrevLoc = new PVector (-999, -999);
  }

  public Signal makeCopy(Path p) {
    return new PostsynapticPotential(fSpeed, fLength, fDecay, fStrength, p);
  }

  public void update() {
    super.update();
    if (Constants.SIGNAL_LINEAR_DECAY)
      fStrength = lerp(Constants.SIGNAL_STRENGTH, fDecay * Constants.SIGNAL_STRENGTH, (float)fCurrIndex/fEndIndex);
    else
      fStrength *= fDecay;
  }

  private PVector smoothSegment(int index, float t) {
    PVector a = fPath.fVertices.get(index);
    PVector b = fPath.fVertices.get(index + 1);
    PVector c = fPath.fVertices.get(index + 2);
    PVector d = fPath.fVertices.get(index + 3);
    float x = curvePoint(a.x, b.x, c.x, d.x, t);
    float y = curvePoint(a.y, b.y, c.y, d.y, t);
    return new PVector(x, y);
  }

  private void determineRange() {
    if (fCurrIndex + 1 >= fEndIndex) return;
    PVector a = fPath.fVertices.get(fCurrIndex);
    PVector b = fPath.fVertices.get(fCurrIndex + 1);
    // PVector c = fPath.fVertices.get(constrain(fCurrIndex + 2, 0, fEndIndex -1));
    PVector c, d;
    // float length = (gSmoothPaths) ? PVector.dist(b, c) : PVector.dist(a, b);
    float length = PVector.dist(a, b);
    float currTraversed = fParamT * length;
    if (fLength > currTraversed) {
      float lNeeded = fLength - currTraversed;
      int currIndex = fCurrIndex;
      float extra = 0;
      while (true) {
        currIndex--;
        if (currIndex < 0) {
          currIndex = 0;
          break;
        }
        a = fPath.fVertices.get(currIndex);
        b = fPath.fVertices.get(currIndex + 1);
        c = fPath.fVertices.get(currIndex + 2);
        length = (gSmoothPaths) ? PVector.dist(b, c) : PVector.dist(a, b);
        if (length > lNeeded) {
          extra = lNeeded/length;
          break;
        }
        else {
          lNeeded -= length;
        }
      }
      fPrevIndex = currIndex;
      fPrevParam = 1 - extra;
    }
    else {
      fPrevIndex = fCurrIndex;
      fPrevParam = fParamT - fLength/length;
    }

    a = fPath.fVertices.get(fPrevIndex);
    b = fPath.fVertices.get(fPrevIndex + 1);
    if (gSmoothPaths) {
      c = fPath.fVertices.get(fPrevIndex + 2);
      d = fPath.fVertices.get(fPrevIndex + 3);
      float x = curvePoint(a.x, b.x, c.x, d.x, fPrevParam);
      float y = curvePoint(a.y, b.y, c.y, d.y, fPrevParam);
      fPrevLoc.set(x, y, 0);
    }
    else {
      fPrevLoc.set(lerp(a.x, b.x, fPrevParam), lerp(a.y, b.y, fPrevParam), 0);
    }
  }

  public void drawForeground() {
    pushStyle();
      float s = Constants.PSP_WIDTH;
      float n = fStrength/Constants.SIGNAL_MAX_STRENGTH;
      fill(lerpColor(fColor, Constants.EX_HIGHLIGHT_COLOR, n));
      stroke(fColor);
      strokeWeight(Constants.PSP_BORDER_WIDTH);
      ellipse(fLoc.x, fLoc.y, s, s);
      if (fLength > 1) {
        determineRange();

        beginShape();
        println(fPrevIndex + 1 + "   " + fCurrIndex);
        if (gSmoothPaths) {
          for (int i = fPrevIndex + 1; i < fCurrIndex; i++) {
            PVector p = fPath.fVertices.get(i);
            curveVertex(p.x, p.y);
          }
        }
        else {
          for (int i = fPrevIndex + 1; i < fCurrIndex; i++) {
            PVector p = fPath.fVertices.get(i);
            vertex(p.x, p.y);
          }
        }
        endShape();

        ellipse(fPrevLoc.x, fPrevLoc.y, s, s);
      }
    popStyle();
  }
}