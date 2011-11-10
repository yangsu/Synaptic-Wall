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
    fLoc = p.fVertices.get(fCurrIndex);
    fEndIndex = p.fVertices.size() - 1;
    // fCurrIndex = -round(delay / (1000.0/frameRate));
    fColor = p.fColor;
  }
  
  int getIndex() { 
    return fCurrIndex;
  }
  
  float getValue() {
    return fStrength;
  }
  
  int step() {
    fCurrIndex = constrain(fCurrIndex + 1, 0, fEndIndex);
    fLoc.set(fPath.fVertices.get(fCurrIndex));
    if (fCurrIndex >= fEndIndex) {
      fDest.onSignal(fType, fStrength, fCurrIndex);
    }
    return fCurrIndex;
  }
  
  boolean reachedDestination() {
    return fCurrIndex >= fEndIndex;
  }
}