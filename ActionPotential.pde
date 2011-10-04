class ActionPotential extends Signal {
  PVector fOffset;
  
  ActionPotential(int endIndex, int type, float strength, int delay, color cc) {
    super(endIndex, type, strength, delay, cc);
    fOffset = new PVector(0,0);
  }
  
  void draw() {
    pushStyle();
      // stroke(fColor);
      // strokeWeight(Contants.SIGNAL_WIDTH);
      // PVector beginControl = PVector.add(fBeginLoc, PVector.mult(fOffset, fStrength)),
      //         endControl = PVector.add(fEndLoc, PVector.mult(fOffset, fStrength));
      // noFill();
      // beginShape();
      //   vertex(fBeginLoc.x, fBeginLoc.y);
      //   vertex(beginControl.x, beginControl.y);
      //   vertex(endControl.x, endControl.y);
      //   vertex(fEndLoc.x, fEndLoc.y);
      // endShape();
      fill(255, 255, 0, 50);
      ellipse(fBeginLoc.x, fBeginLoc.y, 7, 7);
      fill(255, 255, 0, 100);
      ellipse(fBeginLoc.x, fBeginLoc.y, 5, 5);
      fill(255, 255, 0, 250);
      ellipse(fBeginLoc.x, fBeginLoc.y, 3, 3);
    popStyle();
  }
  
  void setBeginAndEnd(PVector b, PVector e) {
    fOffset.set(e.y - b.y, -(e.x - b.x), 0);
    fOffset.normalize();
    super.setBeginAndEnd(b,e);
  }
}