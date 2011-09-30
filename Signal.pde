abstract class Signal extends Animatable {
  int fType, currIndex, endIndex;
  PVector beginLoc, endLoc;
  float fValue;
  
  Signal (int end, int tt, int d) {
    endIndex = end;
    fType = tt;
    currIndex = -round(d / (1000.0/frameRate));
    beginLoc = endLoc = new PVector(0,0);
  }

  abstract void draw();
  
  int getType() {
    return fType;
  }
  float getValue() {
    return fValue;
  }
  int step() {
    return constrain(++currIndex, 0, endIndex - 2);
  }

  boolean reachedEnd() {
    return currIndex == endIndex - 2;
  }

  void setBeginAndEnd(PVector b, PVector e) {
    beginLoc = b;
    endLoc = e;
  }
}