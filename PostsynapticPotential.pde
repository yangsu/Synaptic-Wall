class PostsynapticPotential extends Signal {
  private float fPrevParam;
  private int fPrevIndex;
  private PVector fPrevLoc;

  PostsynapticPotential(float speed, float length, float decay, float strength, Path p) {
    super((strength >= 0) ? Constants.EPSP : Constants.IPSP, speed, length, decay, strength, p);
    fPrevLoc = Util.clone(fPath.getVertex(fCurrIndex));
    fPrevIndex = fCurrIndex;
    fPrevParam = fParam;
  }

  public Signal makeCopy(Path p) {
    return new PostsynapticPotential(fSpeed, fLength, fDecay, fStrength, p);
  }

  private float calcDistanceTraveled() {
    float dist = 0;
    PVector p = fPath.getVertex(0);
    PVector p1;
    for (int i = 1; i <= fCurrIndex; i++) {
      p1 = fPath.getVertex(i);
      dist += PVector.dist(p, p1);
      p = p1;
    }
    dist += PVector.dist(fLoc, p);
    return dist;
  }

  public void update() {
    super.update();
    // TODO: Should the signal stop decaying after initial firing?
    // float time = Util.secondsElapsed(fBirthTime);
    float time = float(millis() - fBirthTime)/1000;
    float val;
    if (Constants.SIGNAL_LINEAR_DECAY) {
      val = Util.linear(- (1 - fDecay), 1, time, Constants.DECAY_FACTOR);
    }
    else {
      // No need to check for zero because fDecay will never to to 0
      if (fDecay < 1)
        val = Util.expDecay(1, time, lerp(0, Constants.DECAY_FACTOR/2, fDecay));
      else
        val = fStrength;
    }
    fStrength = constrain(val, 0, 1);
    if (fLength > 1)
      determineRange();
  }

  public boolean firingComplete() {
    return super.firingComplete() && fPrevIndex >= fEndIndex;
  }

  private PVector smoothSegment(int index, float t) {
    PVector a = fPath.getVertex(index);
    PVector b = fPath.getVertex(index + 1);
    PVector c = fPath.getVertex(index + 2);
    PVector d = fPath.getVertex(index + 3);
    float x = curvePoint(a.x, b.x, c.x, d.x, t);
    float y = curvePoint(a.y, b.y, c.y, d.y, t);
    return new PVector(x, y);
  }

  private void determineRange() {
    if (calcDistanceTraveled() >= fLength) {
      fPrevParam = advance(fPrevIndex, fPrevParam, fPrevLoc);
      if (fPrevParam >= 1.0) {
        // Move on to the next segment and reset parameter
        fPrevParam = fPrevParam - 1;
        fPrevIndex += 1;
      }
    }
  }

  private void drawSignal() {
    if (gSmoothPaths) {
      beginShape();
      for (int i = fPrevIndex + 1; i < fCurrIndex; i++) {
        PVector p = fPath.getVertex(i);
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
        PVector p = fPath.getVertex(fCurrIndex);
        line(fPrevLoc.x, fPrevLoc.y, p.x, p.y);
        line(p.x, p.y, fLoc.x, fLoc.y);
      }
      else {
        if (gDebug) stroke(0, 0, 255);
        PVector p = fPath.getVertex(fPrevIndex + 1);
        line(fPrevLoc.x, fPrevLoc.y, p.x, p.y);
        beginShape();
        for (int i = fPrevIndex + 1; i <= fCurrIndex; i++) {
          p = fPath.getVertex(i);
          vertex(p.x, p.y);
        }
        endShape();
        p = fPath.getVertex(fCurrIndex);
        line(p.x, p.y, fLoc.x, fLoc.y);
      }
    }
  }

  public void drawForeground() {
    pushStyle();
      float n = abs(fStrength)/Constants.SIGNAL_MAX_STRENGTH;
      color cc = lerpColor(fColor, Constants.EX_HIGHLIGHT_COLOR, n);
      if (fLength > 1) {
        // Draw outer shape
        stroke(fColor);
        strokeWeight(3*Constants.PSP_BORDER_WIDTH);
        drawSignal();

        // Draw inner signal
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