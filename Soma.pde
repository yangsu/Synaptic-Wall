class Soma extends Shape {
  ArrayList<Path> fDendrites;
  float[] fReceivedAPs;
  
  float fThreshold, fCurrAP, fThresholdAngle;
  boolean fChangingthreshold;
  
  Soma(float x, float y, float size, color cc, float t) {
    super(x, y, size, cc);
    fThreshold = t;
    fReceivedAPs = new float[0];
    fDendrites = new ArrayList<Path>();
    fChangingthreshold = false;
    fCurrAP = 0;
    
    fThresholdAngle = fThreshold / Contants.SOMA_MAX_THRESHOLD * TWO_PI;
  }
  void drawThreshold() {
    noStroke();
    fCurrAP = 0;
    for (int i = 0; i < fReceivedAPs.length; ++i) {
      fCurrAP += fReceivedAPs[i];
      fReceivedAPs[i] *= Contants.SOMA_AP_DECAY;
    }
    
    float currAngle = constrain(fCurrAP/ Contants.SOMA_MAX_THRESHOLD * TWO_PI, 0, fThresholdAngle);
    fill(255, 100);
    ellipse(fLoc.x, fLoc.y, fSize * 1.5, fSize * 1.5);
    fill(255);
    arc(fLoc.x, fLoc.y, fSize * 1.5, fSize * 1.5, 0, fThresholdAngle);
    fill(fColor);
    arc(fLoc.x, fLoc.y, fSize * 1.51, fSize * 1.51, 0, currAngle);
    fill(Contants.BG_COLOR);
    ellipse(fLoc.x, fLoc.y, fSize * 1.25, fSize * 1.25);
    
    if (fCurrAP >= fThreshold) {
      while (fReceivedAPs.length > 0)
        fReceivedAPs = shorten(fReceivedAPs);

      for (int j = 0; j < fDendrites.size(); ++j)
        fDendrites.get(j).addSignal(Contants.EPSP, 0);
    }
    
    if (fChangingthreshold) {
      fill(255);
      String t = nf(fThreshold, 2, 2);
      text(t, fLoc.x + 2.0 * fSize, fLoc.y);
    }
  }
  void draw() {
    pushStyle();

    drawThreshold();
    
    if (fSelected) {
      stroke(255);
      strokeWeight(1);
    }
    else
      noStroke();
    
    //Draw Soma
    fill(fColor);
    ellipse(fLoc.x, fLoc.y, fSize, fSize);
    fill(blendColor(fColor, color(255, 100), ADD));
    ellipse(fLoc.x, fLoc.y, fSize * 0.75, fSize * 0.75);
    
    popStyle();  
  }
  
  void addDendrite(Path dendrite) {
    if (dendrite != null)
      fDendrites.add(dendrite);
  }

  void fireAP(int numSignal, int delayms, int type) {
    for (int i = 0; i < numSignal; ++i) {
      for (int j = 0; j < fDendrites.size(); ++j)
        // fDendrites.get(j).addSignal(type, i * delayms);
        fDendrites.get(j).addSignal((int)random(3) - 1, i * delayms);
    }
  }

  void receiveAP(int type, float value) {
    fCurrAP += value;
    fReceivedAPs = append(fReceivedAPs, value);
  }

  boolean isInBounds(float x, float y) {
    float dist = PVector.dist(fLoc, new PVector(x, y));
    if (dist <= fSize) {
      fChangingthreshold = false;
      return true;
    }
    else if (dist <= fSize * 1.5 && dist >= fSize) {
      fChangingthreshold = true;
      return true;
    }
    else
      return false;
  }
  boolean onMouseDown(float x, float y) {
    if (isInBounds(x, y))
      fSelected = true;
    else
      fSelected = false;
    return fSelected;
  }
  boolean onMouseDragged(float x, float y) {
    if (fSelected) {
      if (fChangingthreshold) {
        fThresholdAngle = Utilities.getAngle(fLoc.x, fLoc.y, x, y);
        fThreshold = fThresholdAngle / TWO_PI * Contants.SOMA_MAX_THRESHOLD;
      }
      else {
        PVector change = new PVector(mouseX - pmouseX, mouseY - pmouseY);
        fLoc.add(change);
        for(Path dendrite : fDendrites)
          dendrite.translate(change);    
      }
      return true;
    }
    else
      return false;
  }
  boolean onMouseUp(float x, float y) {
    fSelected = false;
    fChangingthreshold = false;
    return false;
  }
}