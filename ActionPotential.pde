class ActionPotential extends Signal {
  ActionPotential(float speed, float length, float decay, float strength, Path p) {
    super(AP, speed, length, decay, strength, p);
    fColor = AP_COLOR;
  }

  public Signal makeCopy(Path p) {
    return new ActionPotential(fSpeed, fLength, fDecay, fStrength, p);
  }

  public void drawBackground() {
    pushStyle();
    fill(SHADOW_COLOR);
    noStroke();
    float s = AP_WIDTH + AP_BORDER_WIDTH/2;
    ellipse(fLoc.x + SHADOW_OFFSETX, fLoc.y + SHADOW_OFFSETY, s, s);
    popStyle();
  }

  public void drawForeground() {
    pushStyle();
    strokeWeight(AP_BORDER_WIDTH);
    fill(BG_COLOR);
    stroke(fColor);
    float s = AP_WIDTH;
    ellipse(fLoc.x, fLoc.y, s, s);
    popStyle();
  }
}
