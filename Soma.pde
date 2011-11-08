class Soma extends Shape {
  float[] fReceivedAPs;
  
  float fCurrAP;
  boolean fControlActive;
  CircularSlider fThreshold;
  
  Soma(float x, float y, float size, color cc, float threshold) {
    super(x, y, size, cc);
    fReceivedAPs = new float[0];
    fControlActive = false;
    fCurrAP = 0;
    
    float interval = TWO_PI / 3;
    float temp = interval;
    float controlSize = fSize + 30;
    fControls.add(new CircularSlider(fLoc.x, fLoc.y, controlSize, 0, temp, 0, 0, 10));
    fControls.add(new CircularSlider(fLoc.x, fLoc.y, controlSize, temp, temp + interval, 0, 0, 10));
    temp += interval;
    fControls.add(new CircularSlider(fLoc.x, fLoc.y, controlSize, temp, temp + interval, 0, 0, 10));
    
    fThreshold = new ThresholdSlider(x, y, fSize + 10, 0, 0, threshold);
    fThreshold.setVisible(true);
  }

  void draw() {    
    pushStyle();
      for (Control c : fControls) {
        c.setVisible(fSelected);
        c.draw();
      }
      fThreshold.draw();
    
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

  void fireSignal(int numSignal, int delayms, int type) {
    for (int i = 0; i < numSignal; ++i) {
      for (int j = 0; j < fDendrites.size(); ++j)
        fDendrites.get(j).addSignal((int)random(3) - 1, i * delayms);
    }
  }

  void receiveSignal(int type, float value, int position) {
    fCurrAP += value;
    fReceivedAPs = append(fReceivedAPs, value);
  }

  boolean isInBounds(float x, float y) {
    float dist = PVector.dist(fLoc, new PVector(x, y));
    if (dist <= fSize) {
      fControlActive = false;
      return true;
    }
    else if (dist <= fSize + Constants.SLIDER_BAR_WIDTH && dist >= fSize) {
      fControlActive = fSelected;
      return true;
    }
    else {
      return false;
    }
  }
  
  boolean onMouseDown(float x, float y) {
    fControlActive = false;
    for (Control c : fControls) {
      fControlActive = c.onMouseDown(x, y);
      if (fControlActive == true) 
        return true;
    }
    return super.onMouseDown(x,y);
  }
  boolean onMouseDragged(float x, float y) {
    if (fSelected) {
      if (fControlActive) {
        for (Control c : fControls)
          if (c.onMouseDragged(x,y))
            return true;
        return false;
      }
      else {
        PVector change = new PVector(mouseX - pmouseX, mouseY - pmouseY);
        fLoc.add(change);
        for (Path dendrite : fDendrites)
          dendrite.translate(change);
        for (Control c : fControls)
          c.translate(change);
        fThreshold.translate(change);
        return true;
      }
    }
    else
      return super.onMouseDragged(x,y);
  }
  boolean onMouseMoved(float x, float y) {
    for (Control c : fControls)
      if (c.onMouseMoved(x,y))
        return true;
    return super.onMouseMoved(x,y);
  }
  boolean onMouseUp(float x, float y) {
    fControlActive = false;
    for (Control c : fControls)
      if (c.onMouseUp(x,y))
        return true;
    return super.onMouseUp(x,y);
  }
}