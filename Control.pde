abstract class Control {
  PVector fLoc;
  int fState;
  
  Control(int x, int y) {
    fLoc = new PVector(x, y);
  }
  
  abstract boolean isInBounds(float x, float y);
}