class PostsynapticPotential extends Signal {
  float fDecayFactor;
  PVector fMid, fOffset;
  
  PostsynapticPotential (int endIndex, int type, float strength, int delay, color cc, float decayFactor) {
    super(endIndex, type, strength, delay, cc);
    fDecayFactor = decayFactor;
    fMid = new PVector(0,0);
    fOffset = new PVector(0,0);
  }

  void draw() {
    pushStyle(); 
      stroke(fColor);
      strokeWeight(Constants.SIGNAL_WIDTH);
      PVector diff = PVector.sub(fEndLoc, fBeginLoc);
      diff.normalize();
      PVector positiveOffset = PVector.mult(diff, Constants.SIGNAL_CONTROL_LENGTH),
              negativeOffset = PVector.mult(diff, -Constants.SIGNAL_CONTROL_LENGTH),
              beginControl = PVector.add(fBeginLoc, positiveOffset),
              endControl = PVector.add(fEndLoc, positiveOffset),
              peak = PVector.add(fMid, PVector.mult(fOffset, (fType) * fStrength * Constants.SIGNAL_MULTIPLIER)),
              peakControl1 = PVector.add(peak, negativeOffset),
              peakControl2 = PVector.add(peak, positiveOffset);
      noFill();
      beginShape();
        vertex(fBeginLoc.x, fBeginLoc.y);
        bezierVertex(beginControl.x, beginControl.y, peakControl1.x, peakControl1.y, peak.x, peak.y);
        bezierVertex(peakControl2.x, peakControl2.y, endControl.x, endControl.y, fEndLoc.x, fEndLoc.y);
      endShape();
    popStyle();
  }
  
  int step() {
    fStrength *= fDecayFactor;
    return super.step();
  }
  
  void setBeginAndEnd(PVector b, PVector e) {
    fMid.set(PVector.mult(PVector.add(b,e),0.5));
    float inv = -(e.x-b.x)/(e.y-b.y);
    float inter = fMid.y - inv*fMid.x;
    fOffset.set(e.y - b.y, -(e.x - b.x), 0);
    fOffset.normalize();
    super.setBeginAndEnd(b,e);
  }
}