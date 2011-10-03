class ActionPotential extends Signal {
  PVector offset;
  
  ActionPotential(int end, int type, int delay, color c, float value) {
    super(end, type, delay, c);
    fStrength = value;
    offset = new PVector(0,0);
  }
  
  void draw() {
    pushStyle();
      stroke(cc);
      strokeWeight(5);
      PVector beginControl = PVector.add(beginLoc, PVector.mult(offset, fStrength)),
              endControl = PVector.add(endLoc, PVector.mult(offset, fStrength));
      noFill();
      beginShape();
        vertex(beginLoc.x, beginLoc.y);
        vertex(beginControl.x, beginControl.y);
        vertex(endControl.x, endControl.y);
        vertex(endLoc.x, endLoc.y);
      endShape();
    popStyle();
  }
  
  void setBeginAndEnd(PVector b, PVector e) {
    offset.set(e.y - b.y, -(e.x - b.x), 0);
    offset.normalize();
    super.setBeginAndEnd(b,e);
  }
}