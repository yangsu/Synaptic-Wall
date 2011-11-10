abstract class Signal extends Drawable {
  protected int fType, fCurrIndex, fEndIndex;
  protected float fSpeed, fLength, fStrength;
  protected Path fPath;
  protected Signalable fDest;

  Signal() {}
  Signal (int type, float speed, float length, float strength, Path p) {
    fType = type;
    fSpeed = speed;
    fLength = length;
    fStrength = strength;
    fPath = p;
    //fDest is private ?
    fDest = p.fDest;
    fCurrIndex = 0;
    PVector temp =  p.fVertices.get(fCurrIndex);
    fLoc = new PVector(temp.x, temp.y);
    fEndIndex = p.fVertices.size() - 1;
    // fCurrIndex = -round(delay / (1000.0/frameRate));
    fColor = p.fColor;
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
  
  void drawRange() {};
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