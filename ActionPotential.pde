class ActionPotential extends Signal {
  ActionPotential(float speed, float strength, Path p) {
    super(Constants.AP, speed, 1, strength, p);
    fColor = Constants.AP_COLOR;
  }

  public Signal makeCopy(Path p) {
    return new ActionPotential(fSpeed, fStrength, p);
  }

  void draw() {
    pushStyle();
      strokeWeight(Constants.SIGNAL_BORDER_WIDTH);
      stroke(Constants.BG_COLOR);
      fill(fColor);
      float s = (abs(fStrength)/Constants.SIGNAL_MAX_STRENGTH) * Constants.SIGNAL_WIDTH + Constants.SIGNAL_BASE;
      ellipse(fLoc.x, fLoc.y, s, s);
    popStyle();
  }
}
