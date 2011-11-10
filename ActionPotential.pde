class ActionPotential extends Signal {
  ActionPotential(float speed, float length, float strength, Path p) {
    super(Constants.AP, speed, length, strength, p);
  }
  
  void draw() {
    pushStyle();
      fill(Constants.EX_COLOR);
      ellipse(fLoc.x, fLoc.y, Constants.SIGNAL_WIDTH, Constants.SIGNAL_WIDTH);
    popStyle();
  }
}