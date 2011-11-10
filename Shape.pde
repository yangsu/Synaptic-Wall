abstract class Shape extends Interactive implements Signalable {
  PVector fLoc;
  float fSize;
  ArrayList<Path> fDendrites;
  ArrayList<Control> fControls;

  Shape() {
    fLoc = new PVector(0, 0);
    fSize = 0;
    fColor = color(0);
    fSelected = false;
    fDendrites = new ArrayList<Path>();
    fControls = new ArrayList<Control>();
  }
  
  Shape(float x, float y, float size, color cc) {
    fLoc = new PVector(x, y);
    fSize = size;
    fColor = cc;
    
    fDendrites = new ArrayList<Path>();
    fControls = new ArrayList<Control>();
  }
  
  void addPath(Path p) {
    fDendrites.add(p);
  }
  
  float x() { return fLoc.x; }
  float y() { return fLoc.y; }  
  void setXY(float x, float y) { fLoc.set(x, y, 0); }
}