class PostsynapticPotential extends Signal {
  float fDecay;
  
  PostsynapticPotential(float speed, float length, float strength, float decay, Path p) {
    super((strength >= 0) ? Constants.EPSP : Constants.IPSP, speed, length, strength, p);
    fDecay = decay;
  }

  void draw() {
    pushStyle(); 
      stroke(fColor);
      strokeWeight(Constants.SIGNAL_WIDTH);
    popStyle();
  }
  
  int step() {
    fStrength *= fDecay;
    return super.step();
  }
}