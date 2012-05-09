abstract class Signal extends Drawable {
  public int fCurrIndex, fEndTime;
  public float fSpeed, fLength, fDecay, fStrength;
  protected int fType, fEndIndex;
  protected Path fPath;
  protected Signalable fDest;
  protected boolean fFired;

  protected float fParam;

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
    fEndIndex = p.fVertices.size() - ((gSmoothPaths) ? 4 : 1);
    fEndTime = 0;
    fFired = false;

    fParam = 0;
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

  protected float advance(int index, float param, PVector p) {
    PVector a = fPath.fVertices.get(index);
    PVector b = fPath.fVertices.get(index + 1);
    if (gSmoothPaths) {
      PVector c = fPath.fVertices.get(index + 2);
      PVector d = fPath.fVertices.get(index + 3);
      float x = curvePoint(a.x, b.x, c.x, d.x, param);
      float y = curvePoint(a.y, b.y, c.y, d.y, param);
      p.set(x, y, 0);

      // note: use linear distance as an approximation
      return param + fSpeed / PVector.dist(b, c);
    }
    else {
      p.set(lerp(a.x, b.x, param), lerp(a.y, b.y, param), 0);
      // note: use linear distance as an approximation
      return param + fSpeed / PVector.dist(a, b);
    }
  }

  public void update() {
    if (fFired) return;
    fParam = advance(fCurrIndex, fParam, fLoc);
    if (fParam >= 1.0) {
      // Move on to the next segment and reset parameter
      fParam = fParam - 1;
      fCurrIndex += 1;
      if (fCurrIndex >= fEndIndex) {
        fire();
      }
    }
  }

  public boolean firingComplete() {
    return fFired;
  }

  public abstract Signal makeCopy(Path p);
}