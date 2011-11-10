class ActionPotential extends Signal {
  ActionPotential(float speed, float strength, Path p) {
    super(Constants.AP, speed, 1, strength, p);
  }
  
  void draw() {
    pushStyle();
      stroke(Constants.BG_COLOR);
      fill(Constants.HIGHLIGHT_COLOR);
      ellipse(fLoc.x, fLoc.y, abs(fStrength), abs(fStrength));
    popStyle();
  }
}
