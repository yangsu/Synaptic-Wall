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
  
  int getIndex() { 
    return fCurrIndex;
  }
  
  float getValue() {
    return fStrength;
  }
  
  int step() {
    fCurrIndex = constrain(fCurrIndex + (int)fSpeed, 0, fEndIndex);
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