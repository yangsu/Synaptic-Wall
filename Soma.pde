class Soma extends Shape implements Controllable{
  float[] fReceivedAPs;
  
  boolean fControlActive;
  ThresholdSlider fThresholdSlider;
  
  private static final int OVER_THRESHOLD = 1;
  private static final int SPEED = 1;
  private static final int INTERVAL = 2;
  private static final int STRENGTH = 3;
  private static final int THRESHOLD = 4;
  
  Soma(float x, float y, float size, color cc, float threshold) {
    this(x, y, size, cc, (threshold > 0) ? threshold : 0, (threshold < 0) ? threshold : 0);
  }
  Soma(float x, float y, float size, color cc, float positivet, float negativet) {
    super(x, y, size, cc);
    fReceivedAPs = new float[0];
    fControlActive = false;
    
    float interval = TWO_PI / 3;
    float temp = interval;
    float controlSize = fSize + 30;
    fControls.add(new CircularSlider(fLoc.x, fLoc.y, controlSize, 0, temp, 0, 0, 10, SPEED, this));
    fControls.add(new CircularSlider(fLoc.x, fLoc.y, controlSize, temp, temp + interval, 0, 0, 10, INTERVAL, this));
    temp += interval;
    fControls.add(new CircularSlider(fLoc.x, fLoc.y, controlSize, temp, temp + interval, 0, 0, 10, STRENGTH, this));
    
    fThresholdSlider = new ThresholdSlider(x, y, fSize + 10, 
      PI + negativet/Constants.SOMA_MAX_THRESHOLD * PI,
      PI + positivet/Constants.SOMA_MAX_THRESHOLD * PI,
      0, negativet, positivet, THRESHOLD, this);
    fControls.add(fThresholdSlider);
  }

  void draw() {    
    pushStyle();
      for (Control c : fControls) {
        c.draw();
      }
      fThresholdSlider.draw();
    
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
    fThresholdSlider.addChange(value);
    fReceivedAPs = append(fReceivedAPs, value);
  }

  void onEvent(int controlID, float value) {
    switch (controlID) {
      case SPEED:
        break;
      case INTERVAL:
        break;
      case STRENGTH:
        break;
      case THRESHOLD: 
        fReceivedAPs = new float[0];
        for (int j = 0; j < fDendrites.size(); ++j)
          fDendrites.get(j).addSignal(Constants.EPSP, 0);
        break;
      default:
        break;
    }
  }
  
  public void translate(PVector change) {
    fLoc.add(change);
    for (Path dendrite : fDendrites)
      dendrite.translate(change);
    for (Control c : fControls)
      c.translate(change);
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
      if (fControlActive) {
        return true;
      }
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
        this.translate(new PVector(x - this.fLoc.x, y - this.fLoc.y));
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