class Soma extends Shape {
  ArrayList<Path> dendrites;
  float[] receivedAPs;
  float decay = 0.95;
  float threshold, currAP, thresholdAngle;
  boolean changingThreshold;
  
  Soma(float x, float y, float size, color cc, float t) {
    super(x, y, size, cc);
    threshold = t;
    receivedAPs = new float[0];
    dendrites = new ArrayList<Path>();
    changingThreshold = false;
    currAP = 0;
    
    thresholdAngle = threshold / MAX_THRESHOLD * TWO_PI;
  }
  void drawThreshold() {
    noStroke();
    currAP = 0;
    for (int i = 0; i < receivedAPs.length; ++i) {
      currAP += receivedAPs[i];
      receivedAPs[i] *= decay;
    }
    
    float currAngle = currAP / MAX_THRESHOLD * TWO_PI;
    fill(255, 100);
    ellipse(fLoc.x, fLoc.y, fSize * 1.5, fSize * 1.5);
    fill(255);
    arc(fLoc.x, fLoc.y, fSize * 1.5, fSize * 1.5, 0, thresholdAngle);
    fill(fColor);
    arc(fLoc.x, fLoc.y, fSize * 1.51, fSize * 1.51, 0, currAngle);
    fill(BG_COLOR);
    ellipse(fLoc.x, fLoc.y, fSize * 1.25, fSize * 1.25);
  }
  void draw() {
    pushStyle();
    //Draw dendrites
    for(int i = 0; i < dendrites.size(); ++i)
      dendrites.get(i).draw();
    
    drawThreshold();
    
    //Draw selection
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
    
    //Draw Controls
    popStyle();  
  }
  
  void addDendrite(Path dendrite) {
    if (dendrite != null)
      dendrites.add(dendrite);
  }

  void fireAP(int numSignal, int delayms, int type) {
    for (int i = 0; i < numSignal; ++i) {
      for (int j = 0; j < dendrites.size(); ++j)
        dendrites.get(j).addActionPotential(type, i * delayms);
    }
  }

  void receiveAP(int type, float value) {
    currAP += value;
    receivedAPs = append(receivedAPs, value);
    if (currAP >= threshold) {
      while (receivedAPs.length > 0)
        receivedAPs = shorten(receivedAPs);
        
      for (int j = 0; j < dendrites.size(); ++j)
        dendrites.get(j).addActionPotential(0, 0);
    }
  }

  boolean isInBounds(float x, float y) {
    float dist = PVector.dist(fLoc, new PVector(x, y));
    if (dist <= fSize) {
      changingThreshold = false;
      return true;
    }
    else if (dist <= fSize * 1.5 && dist >= fSize) {
      changingThreshold = true;
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
      if (changingThreshold) {
        thresholdAngle = Utilities.getAngle(fLoc.x, fLoc.y, x, y);
        //Don't change the actual threshold until mouse released
      }
      else {
        PVector change = new PVector(mouseX - pmouseX, mouseY - pmouseY);
        fLoc.add(change);
        for(Path dendrite : dendrites)
          dendrite.translate(change);    
      }
      return true;
    }
    else
      return false;
  }
  boolean onMouseUp(float x, float y) {
    fSelected = false;
    if (changingThreshold) {
      changingThreshold = false;
      threshold = thresholdAngle / TWO_PI * MAX_THRESHOLD;
    }
    return false;
  }
}