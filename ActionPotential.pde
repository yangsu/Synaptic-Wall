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
      float s = Constants.AP_WIDTH;

      fill(Constants.SHADOW_COLOR);
      stroke(Constants.SHADOW_COLOR);
      ellipse(fLoc.x + Constants.SHADOW_OFFSETX, fLoc.y + Constants.SHADOW_OFFSETY, s, s);

      fill(Constants.BG_COLOR);
      stroke(fColor);
      ellipse(fLoc.x, fLoc.y, s, s);
    popStyle();
  }
}
