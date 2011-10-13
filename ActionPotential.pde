class ActionPotential extends Signal {
  ActionPotential(int endIndex, int type, float strength, int delay, color cc) {
    super(endIndex, type, strength, delay, cc);
  }
  
  void draw() {
    pushStyle();
      fill(255, 255, 0, 50);
      ellipse(fBeginLoc.x, fBeginLoc.y, 7, 7);
      fill(255, 255, 0, 100);
      ellipse(fBeginLoc.x, fBeginLoc.y, 5, 5);
      fill(255, 255, 0, 250);
      ellipse(fBeginLoc.x, fBeginLoc.y, 3, 3);
    popStyle();
  }
}