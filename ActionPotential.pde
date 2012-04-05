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
      strokeWeight(Constants.SIGNAL_BORDER_WIDTH);
      stroke(Constants.BG_COLOR);
      fill(fColor);
      float s = (abs(fStrength)/Constants.SIGNAL_STRENGTH) * Constants.SIGNAL_WIDTH + Constants.SIGNAL_BORDER_WIDTH/2;
      ellipse(fLoc.x, fLoc.y, s, s);
    popStyle();
  }
}
