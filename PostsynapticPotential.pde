class PostsynapticPotential extends Signal {
  float decayFactor;
  PVector mid, offset;
  
  PostsynapticPotential (int end, int type, int d, color c, float v, float df) {
    super(end, type, d, c);
    fValue = v;
    decayFactor = df;
    mid = new PVector(0,0);
    offset = new PVector(0,0);
    
  }

  void draw() {
    pushStyle(); 
    stroke(cc);
    strokeWeight(5);
    PVector diff = PVector.sub(endLoc, beginLoc);
    diff.normalize();
    PVector beginControl = PVector.add(beginLoc, PVector.mult(diff, SIGNAL_BEZIER_CONTROL_LENGTH)),
            endControl = PVector.add(endLoc, PVector.mult(diff, -SIGNAL_BEZIER_CONTROL_LENGTH)),
            peak = PVector.add(mid, PVector.mult(offset, (fType) * SIGNAL_PEAK_HEIGHT)),
            peakControl1 = PVector.add(peak, PVector.mult(diff, -SIGNAL_BEZIER_CONTROL_LENGTH)),
            peakControl2 = PVector.add(peak, PVector.mult(diff, SIGNAL_BEZIER_CONTROL_LENGTH));
    noFill();
    beginShape();
    vertex(beginLoc.x, beginLoc.y);
    bezierVertex(beginControl.x, beginControl.y, peakControl1.x, peakControl1.y, peak.x, peak.y);
    bezierVertex(peakControl2.x, peakControl2.y, endControl.x, endControl.y, endLoc.x, endLoc.y);
    endShape();
    popStyle();
  }
  
  int step() {
    fValue *= decayFactor;
    return super.step();
  }
  
  void setBeginAndEnd(PVector b, PVector e) {
    mid.set(PVector.mult(PVector.add(b,e),0.5));
    float inv = -(e.x-b.x)/(e.y-b.y);
    float inter = mid.y - inv*mid.x;
    offset.set(e.y - b.y, -(e.x - b.x), 0);
    offset.normalize();
    super.setBeginAndEnd(b,e);
  }
}