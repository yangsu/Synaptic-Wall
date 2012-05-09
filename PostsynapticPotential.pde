class PostsynapticPotential extends Signal {
  private float fEndParam;
  private int fEndIndex;
  private PVector fEndLoc;

  PostsynapticPotential(float speed, float length, float decay, float strength, Path p) {
    super((strength >= 0) ? Constants.EPSP : Constants.IPSP, speed, length, decay, strength, p);
    setIndex(fCurrIndex);
  }

  public Signal makeCopy(Path p) {
    return new PostsynapticPotential(fSpeed, fLength, fDecay, fStrength, p);
  }

  public void setIndex(int i) {
    super.setIndex(i);
    fEndLoc = Util.clone(fPath.getVertex(i));
    fEndIndex = i;
    fEndParam = 0;
  }
  private float calcDistanceTraveled() {
    // TODO: amortized calculation needed
    // BUG: this distance is incorrect for signals that get added through sub paths
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
        val = Util.expDecay(1, time, lerp(0, Constants.DECAY_FACTOR, fDecay));
      else
        val = fStrength;
    }
    fStrength = constrain(val, 0, 1);
    if (fLength > 1 && calcDistanceTraveled() >= fLength) {
      // Advance the end of the signal
      fEndParam = advance(fEndIndex, fEndParam, fEndLoc);
      if (fEndParam >= 1.0) {
        // Move on to the next segment and reset parameter
        fEndParam = fEndParam - 1;
        fEndIndex += 1;
      }
    }
  }

  public boolean firingComplete() {
    return super.firingComplete() && fEndIndex >= fFinalIndex;
  }

  private void drawSignal() {
    if (gSmoothPaths) {
      beginShape();
      for (int i = fEndIndex + 1; i < fCurrIndex; i++) {
        PVector p = fPath.getVertex(i);
        curveVertex(p.x, p.y);
      }
      endShape();
    }
    else {
      if (fCurrIndex == fEndIndex) {
        if (gDebug) stroke(255, 0, 0);
        line(fEndLoc.x, fEndLoc.y, fLoc.x, fLoc.y);
      }
      else if ((fCurrIndex - fEndIndex) == 1) {
        if (gDebug) stroke(0, 255, 0);
        PVector p = fPath.getVertex(fCurrIndex);
        line(fEndLoc.x, fEndLoc.y, p.x, p.y);
        line(p.x, p.y, fLoc.x, fLoc.y);
      }
      else {
        if (gDebug) stroke(0, 0, 255);
        PVector p = fPath.getVertex(fEndIndex + 1);
        line(fEndLoc.x, fEndLoc.y, p.x, p.y);
        beginShape();
        for (int i = fEndIndex + 1; i <= fCurrIndex; i++) {
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
        noFill();
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