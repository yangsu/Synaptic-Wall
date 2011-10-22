abstract class Control extends Drawable{
  PVector fLoc;
  
  Control(float x, float y) {
    fLoc = new PVector(x, y);
  }
  void setLoc(float x, float y) {
    fLoc = new PVector(x, y);
  }
  void translate(PVector change) {
    fLoc.add(change);
  }
  abstract boolean isInBounds(float x, float y);
}