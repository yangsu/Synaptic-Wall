class ActionPotential extends Signal {
  ActionPotential(float speed, float length, float decay, float strength, Path p) {
    super(Constants.AP, speed, length, decay, strength, p);
    fColor = Constants.AP_COLOR;
  }

  public Signal makeCopy(Path p) {
    return new ActionPotential(fSpeed, fLength, fDecay, fStrength, p);
  }

  public void draw() {
    pushStyle();
      strokeWeight(Constants.AP_BORDER_WIDTH);
      fill(Constants.BG_COLOR);
      stroke(fColor);
      float s = Constants.AP_WIDTH;
      ellipse(fLoc.x, fLoc.y, s, s);
    popStyle();
  }
}
