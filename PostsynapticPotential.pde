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
    // float time = Util.secondsElapsed(fBirthTime);
    float time = float(millis() - fBirthTime)/1000;
    float val;
    if (Constants.SIGNAL_LINEAR_DECAY) {
      val = Util.linear(- (1 - fDecay), 1, time, Constants.DECAY_FACTOR);
    }
    else {
      // No need to check for zero because fDecay will never to to 0
      val = Util.expDecay(1, time, lerp(0, Constants.DECAY_FACTOR/2, fDecay));
    }
    fStrength = constrain(val, 0, 1);
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
    // if (fCurrIndex + 1 >= fEndIndex) return;
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
          // When the signal has not travelled far enough from its origin to show the full signal
          currIndex = 0;
          extra = 1;
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

  private void drawSignal() {
    if (gSmoothPaths) {
      beginShape();
      for (int i = fPrevIndex + 1; i < fCurrIndex; i++) {
        PVector p = fPath.fVertices.get(i);
        curveVertex(p.x, p.y);
      }
      endShape();
    }
    else {
      if (fCurrIndex == fPrevIndex) {
        if (gDebug) stroke(255, 0, 0);
        line(fPrevLoc.x, fPrevLoc.y, fLoc.x, fLoc.y);
      }
      else if ((fCurrIndex - fPrevIndex) == 1) {
        if (gDebug) stroke(0, 255, 0);
        PVector p = fPath.fVertices.get(fCurrIndex);
        line(fPrevLoc.x, fPrevLoc.y, p.x, p.y);
        line(p.x, p.y, fLoc.x, fLoc.y);
      }
      else {
        if (gDebug) stroke(0, 0, 255);
        PVector p = fPath.fVertices.get(fPrevIndex + 1);
        line(fPrevLoc.x, fPrevLoc.y, p.x, p.y);
        beginShape();
        for (int i = fPrevIndex + 1; i <= fCurrIndex; i++) {
          p = fPath.fVertices.get(i);
          vertex(p.x, p.y);
        }
        endShape();
        p = fPath.fVertices.get(fCurrIndex);
        line(p.x, p.y, fLoc.x, fLoc.y);
      }
    }
  }

  public void drawForeground() {
    pushStyle();
      float n = abs(fStrength)/Constants.SIGNAL_MAX_STRENGTH;
      color cc = lerpColor(fColor, Constants.EX_HIGHLIGHT_COLOR, n);
      if (fLength > 1) {
        determineRange();

        stroke(fColor);
        strokeWeight(3*Constants.PSP_BORDER_WIDTH);
        drawSignal();

        stroke(lerpColor(fColor, Constants.EX_HIGHLIGHT_COLOR, n));
        strokeWeight(Constants.PSP_BORDER_WIDTH);
        drawSignal();
      }
      else {
        fill(cc);
        stroke(fColor);
        strokeWeight(Constants.PSP_BORDER_WIDTH);
        float s = Constants.PSP_WIDTH;
        ellipse(fLoc.x, fLoc.y, s, s);
      }
    popStyle();
  }
}