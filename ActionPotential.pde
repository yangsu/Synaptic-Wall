class ActionPotential extends Signal {
  ActionPotential(float speed, float strength, Path p) {
    super(Constants.AP, speed, 1, strength, p);
  }

  public Signal makeCopy(Path p) {
    return new ActionPotential(fSpeed, fStrength, p);
  }

  void draw() {
    pushStyle();
      strokeWeight(Constants.AP_STROKE_WEIGHT);
      stroke(Constants.BG_COLOR);
      fill(Constants.AP_COLOR);
      float s = (0.5 + abs(fStrength)/Constants.SIGNAL_MAX_STRENGTH) * Constants.SIGNAL_WIDTH;
      ellipse(fLoc.x, fLoc.y, s, s);
    popStyle();
  }
}
