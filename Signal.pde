abstract class Signal extends Drawable {
  public int fCurrIndex, fEndTime;
  public float fSpeed, fLength, fDecay, fStrength;
  protected int fType, fEndIndex;
  protected Path fPath;
  protected Signalable fDest;
  protected boolean fFired;

  private float fParamT;

  Signal() {}
  Signal (int type, float speed, float length, float decay, float strength, Path p) {
    super(p.fVertices.get(0).x, p.fVertices.get(0).y, (type == Constants.EPSP) ? Constants.EX_COLOR : Constants.IN_COLOR);
    fType = type;
    fSpeed = speed;
    fLength = length;
    fDecay = decay;
    fStrength = strength;
    fPath = p;
    //fDest is private ?
    fDest = p.fDest;
    fCurrIndex = 0;
    fEndIndex = p.fVertices.size();
    fEndTime = 0;
    fFired = false;

    fParamT = 0;
  }

  public int getType() {
    return Constants.SIGNAL;
  }

  public void setIndex(int i) {
    fCurrIndex = constrain(i, 0, fEndIndex);
    PVector temp = fPath.fVertices.get(fCurrIndex);
    fLoc = new PVector(temp.x, temp.y, temp.z);
  }

  protected void fire() {
    if (!fFired) {
      fDest.onSignal(this);
      fEndTime = millis();
      fFired = true;
    }
  }

  public void update() {
    if (fFired) return;

    PVector a = fPath.fVertices.get(fCurrIndex);
    PVector b = fPath.fVertices.get(fCurrIndex + 1);
    if (gSmoothPaths) {
      PVector c = fPath.fVertices.get(fCurrIndex + 2);
      PVector d = fPath.fVertices.get(fCurrIndex + 3);
      float x = curvePoint(a.x, b.x, c.x, d.x, fParamT);
      float y = curvePoint(a.y, b.y, c.y, d.y, fParamT);
      fLoc.set(x, y, 0);

      fParamT += fSpeed / PVector.dist(b, c);
    }
    else {
      fLoc.set(lerp(a.x, b.x, fParamT), lerp(a.y, b.y, fParamT), 0);
      fParamT += fSpeed / PVector.dist(a, b);
    }

    // note: use linear distance as an approximation
    if (fParamT >= 1.0) {
      // Move on to the next segment and reset time
      fParamT = 0;
      fCurrIndex += 1;
      if (reachedDestination())
        fire();
    }

  }

  public boolean reachedDestination() {
    return fCurrIndex == fEndIndex - ((gSmoothPaths) ? 3 : 1);
  }

  public boolean fired() {
    return fFired;
  }

  public abstract Signal makeCopy(Path p);
}