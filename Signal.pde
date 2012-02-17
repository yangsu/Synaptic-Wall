abstract class Signal extends Drawable {
  protected int fType, fCurrIndex, fEndIndex;
  protected float fSpeed, fLength, fStrength;
  protected Path fPath;
  protected Signalable fDest;

  Signal() {}
  Signal (int type, float speed, float length, float strength, Path p) {
    super(p.fVertices.get(0).x, p.fVertices.get(0).y, p.fColor);
    fType = type;
    fSpeed = speed;
    fLength = length;
    fStrength = strength;
    fPath = p;
    //fDest is private ?
    fDest = p.fDest;
    fCurrIndex = 0;
    fEndIndex = p.fVertices.size() - 1;
    // fCurrIndex = -round(delay / (1000.0/frameRate));
  }
  public int getType() {
    return Constants.SIGNAL;
  }
  void setIndex(int i) {
    fCurrIndex = constrain(i, 0, fEndIndex);
  }
  int getIndex() {
    return fCurrIndex;
  }

  float getValue() {
    return fStrength;
  }

  int step() {
    fCurrIndex = constrain(fCurrIndex + (int)fSpeed, 0, fEndIndex);
    fLoc.set(fPath.fVertices.get(fCurrIndex));
    if (fCurrIndex >= fEndIndex)
      fDest.onSignal(this);
    return fCurrIndex;
  }

  boolean reachedDestination() {
    return fCurrIndex >= fEndIndex;
  }

  public abstract Signal makeCopy(Path p);
}