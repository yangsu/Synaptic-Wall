abstract class Signal extends Drawable {
  public int fCurrIndex, fEndTime;
  public float fSpeed, fLength, fStrength;
  protected int fType, fEndIndex;
  protected Path fPath;
  protected Signalable fDest;
  protected boolean fFired;

  Signal() {}
  Signal (int type, float speed, float length, float strength, Path p) {
    super(p.fVertices.get(0).x, p.fVertices.get(0).y, (type == Constants.EPSP) ? Constants.EX_COLOR : Constants.IN_COLOR);
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
    fFired = false;
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

  public int step() {
    fCurrIndex = constrain(fCurrIndex + (int)fSpeed, 0, fEndIndex);
    fLoc.set(fPath.fVertices.get(fCurrIndex));
    if (reachedDestination())
      fire();
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