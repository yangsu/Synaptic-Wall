class PostsynapticPotential extends Signal {
  PostsynapticPotential(float speed, float length, float decay, float strength, Path p) {
    super((strength >= 0) ? Constants.EPSP : Constants.IPSP, speed, length, decay, strength, p);
  }

  public Signal makeCopy(Path p) {
    return new PostsynapticPotential(fSpeed, fLength, fDecay, fStrength, p);
  }

  public void update() {
    super.update();
    if (Constants.SIGNAL_LINEAR_DECAY)
      fStrength = lerp(Constants.SIGNAL_STRENGTH, fDecay * Constants.SIGNAL_STRENGTH, (float)fCurrIndex/fEndIndex);
    else
      fStrength *= fDecay;
  }

  public void draw() {
    pushStyle();
      strokeWeight(Constants.PSP_BORDER_WIDTH);
      float s = Constants.PSP_WIDTH;
      float n = fStrength/Constants.SIGNAL_STRENGTH;
      fill(lerpColor(fColor, Constants.EX_HIGHLIGHT_COLOR, n));
      stroke(fColor);
      ellipse(fLoc.x, fLoc.y, s, s);
    popStyle();
  }
}