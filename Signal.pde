abstract class Signal extends Drawable {
  int fType, fCurrIndex, fEndIndex;
  PVector fBeginLoc, fEndLoc;
  float fStrength;
  
  Signal (int endIndex, int type, float strength, int delay, color cc) {
    fEndIndex = endIndex;
    fType = type;
    fStrength = strength;
    fCurrIndex = -round(delay / (1000.0/frameRate));
    fColor = cc;
    fBeginLoc = fEndLoc = new PVector(0,0);
  }
  void setStart(int index) { fCurrIndex = index; }
  int getType() { return fType; }
  float getValue() { return fStrength; }
  int getIndex() { return fCurrIndex; }
  int step() { return constrain(fCurrIndex++, 0, fEndIndex - 1); }
  boolean reachedEnd() { return fCurrIndex == fEndIndex - 1; }
  void setBeginAndEnd(PVector begin, PVector end) {
    fBeginLoc = begin;
    fEndLoc = end;
  }
  boolean onMouseDown(float x, float y) {
    return false;
  }
  
  boolean onMouseDragged(float x, float y) {
    return false;
  }
  
  boolean onMouseMoved(float x, float y) {
    return false;
  }
  
  boolean onMouseUp(float x, float y) {
    return false;
  }
}