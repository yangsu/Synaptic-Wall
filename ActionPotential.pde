class ActionPotential extends Signal {

  ActionPotential(int end, int type, int d) {
    super(end, type, d);
    fValue = type;
  }
  
  void draw() {
    pushStyle();
    if (fType == 0) 
      stroke(255);
    if (fType == 1)
      stroke(0);
    strokeWeight(5);
    line(beginLoc.x, beginLoc.y, endLoc.x, endLoc.y);
    popStyle();
  }
}