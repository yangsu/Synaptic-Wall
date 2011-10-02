abstract class Signal extends Animatable {
  int fType, currIndex, endIndex;
  PVector beginLoc, endLoc;
  float fValue;
  color cc;
  
  Signal (int end, int tt, int d, color c) {
    endIndex = end;
    fType = tt;
    cc = c;
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
  int getIndex() {
    return currIndex;
  }
  int step() {
    return constrain(currIndex++, 0, endIndex - 3);
  }

  boolean reachedEnd() {
    return currIndex == endIndex - 3;
  }

  void setBeginAndEnd(PVector b, PVector e) {
    beginLoc = b;
    endLoc = e;
  }
}