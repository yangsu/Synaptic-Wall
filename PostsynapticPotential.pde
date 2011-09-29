class PostsynapticPotential extends Signal {
  float decayFactor;
  
  PostsynapticPotential (int end, int type, int d, float v, float df) {
    super(end, type, d);
    fValue = v;
    decayFactor = df;
  }

  void draw() {
    pushStyle(); 
    stroke(255);
    strokeWeight(5);
    line(beginLoc.x, beginLoc.y, endLoc.x, endLoc.y);
    popStyle();
  }
  
  int step() {
    fValue *= decayFactor;
    return super.step();
  }
}