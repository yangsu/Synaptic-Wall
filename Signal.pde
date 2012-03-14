abstract class Signal extends Drawable {
  public int fCurrIndex, fEndTime;
  public float fSpeed, fLength, fStrength;
  protected int fType, fEndIndex;
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
    fEndTime = 0;
  }

  public int getType() {
    return Constants.SIGNAL;
  }

  public void setIndex(int i) {
    fCurrIndex = constrain(i, 0, fEndIndex);
  }

  public int step() {
    fCurrIndex = constrain(fCurrIndex + (int)fSpeed, 0, fEndIndex);
    fLoc.set(fPath.fVertices.get(fCurrIndex));
    if (fCurrIndex >= fEndIndex) {
      fEndTime = millis();
      fDest.onSignal(this);
    }
    return fCurrIndex;
  }

  public boolean reachedDestination() {
    return fCurrIndex >= fEndIndex;
  }

  public abstract Signal makeCopy(Path p);

  public void drawSignalBody() {
    //Empty by default. Can be used to draw signal bodies to the background
  }
}