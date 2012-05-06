class ActionPotential extends Signal {
  ActionPotential(float speed, float length, float decay, float strength, Path p) {
    super(Constants.AP, speed, length, decay, strength, p);
    fColor = Constants.AP_COLOR;
  }

  public Signal makeCopy(Path p) {
    return new ActionPotential(fSpeed, fLength, fDecay, fStrength, p);
  }

  public void drawBackground() {
    pushStyle();
    fill(Constants.SHADOW_COLOR);
    noStroke();
    float s = Constants.AP_WIDTH + Constants.AP_BORDER_WIDTH/2;
    ellipse(fLoc.x + Constants.SHADOW_OFFSETX, fLoc.y + Constants.SHADOW_OFFSETY, s, s);
    popStyle();
  }

  public void drawForeground() {
    pushStyle();
    strokeWeight(Constants.AP_BORDER_WIDTH);
    fill(Constants.BG_COLOR);
    stroke(fColor);
    float s = Constants.AP_WIDTH;
    ellipse(fLoc.x, fLoc.y, s, s);
    popStyle();
  }
}
