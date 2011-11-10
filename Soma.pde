class Soma extends Shape implements Controllable{
  private float[] fReceivedAPs;

  private boolean fControlActive;

  private ThresholdSlider fThresholdSlider;
  private float fSpeed, fLength, fStrength;
  // Control IDS
  private static final int SPEED = 1;
  private static final int LENGTH = 2;
  private static final int STRENGTH = 3;
  private static final int THRESHOLD = 4;
  
  Soma(float x, float y, float size, color cc, float threshold) {
    this(x, y, size, cc, (threshold > 0) ? threshold : 0, (threshold < 0) ? threshold : 0);
  }
  Soma(float x, float y, float size, color cc, float positivet, float negativet) {
    super(x, y, size, cc);
    fReceivedAPs = new float[0];
    fControlActive = false;
    fSpeed = Constants.SIGNAL_DEFAULT_SPEED;
    fLength = Constants.SIGNAL_DEFAULT_LENGTH;
    fStrength = Constants.SIGNAL_DEFAULT_STRENGTH;
    
    float controlSize = fSize + 3 * Constants.SLIDER_BAR_WIDTH;
    
    fControls.add(new DiscreteCircularSlider(fLoc.x, fLoc.y, controlSize,
                                     0, TWO_PI/3,
                                     fSpeed, 1, Constants.SIGNAL_MAX_SPEED,
                                     SPEED, this));
    fControls.add(new DiscreteCircularSlider(fLoc.x, fLoc.y, controlSize, 
                                     TWO_PI/3, 2 * TWO_PI/3, 
                                     fLength, 1, Constants.SIGNAL_MAX_LENGTH, 
                                     LENGTH, this));
    fControls.add(new CircularSlider(fLoc.x, fLoc.y, controlSize, 
                                     2 * TWO_PI/3, TWO_PI, 
                                     fStrength, -Constants.SIGNAL_MAX_STRENGTH, Constants.SIGNAL_MAX_STRENGTH, 
                                     STRENGTH, this));
    
    fThresholdSlider = new ThresholdSlider(x, y, fSize + Constants.SLIDER_BAR_WIDTH, 
                                            0, negativet, positivet, 
                                            THRESHOLD, this);
    fControls.add(fThresholdSlider);
  }
  
  private void drawSoma() {
    fill(fColor);
    if (fSelected)
      stroke(255);
    ellipse(fLoc.x, fLoc.y, fSize, fSize);
    noStroke();
    fill(blendColor(fColor, color(255, 100), ADD));
    ellipse(fLoc.x, fLoc.y, fSize - Constants.SOMA_RING_WIDTH, fSize - Constants.SOMA_RING_WIDTH);
  }
  
  private void drawControlDisplays() {
    pushStyle();
      color cc = (fStrength > 0) ? Constants.EX_COLOR : Constants.IN_COLOR;
    
      //Speed
      noStroke();
      fill(cc);
      float h = 3;
      float w = h * sqrt(3);
      float y = fLoc.y - 7;
      float temp = -fSpeed/2 * w;
      for (int i = 0; i < fSpeed; ++i) {
        triangle(fLoc.x + w/3 + temp, y - h, 
                 fLoc.x + w/3 + temp, y + h,
                 fLoc.x + w + temp, y);
        temp += w; 
      }
      
      //Length
      noFill();
      stroke(cc);
      float l = fLength/Constants.SIGNAL_MAX_LENGTH * 9;
      float sl = (fSize - 2*l)/2;
      y = fLoc.y + 4;
      beginShape();
      vertex(fLoc.x - l - sl, y);
      vertex(fLoc.x - l, y);
      vertex(fLoc.x - l, y - 5);
      vertex(fLoc.x + l, y - 5);
      vertex(fLoc.x + l, y);
      vertex(fLoc.x + l + sl, y);
      endShape();
      
      //Strength
      noStroke();
      color alpha = (int)(abs(fStrength)/Constants.SIGNAL_MAX_STRENGTH * 255) << 24 | 0xFFFFFF;
      fill(cc & alpha);
      ellipse(fLoc.x, fLoc.y + 12, 3, 3);
    popStyle();
  }
  
  public void draw() {    
    pushStyle();
      for (Control c : fControls)
        c.draw();
      this.drawSoma();
      this.drawControlDisplays();
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
        fSpeed = value;
        break;
      case LENGTH:
        fLength = value;
        break;
      case STRENGTH:
        fStrength = value;
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
    if (fMovable) {
      fLoc.add(change);
      for (Path dendrite : fDendrites)
        dendrite.translate(change);
      for (Control c : fControls)
        c.translate(change);
    }
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
  
  public boolean onMouseDown(float x, float y) {
    fControlActive = false;
    for (Control c : fControls) {
      fControlActive = c.onMouseDown(x, y);
      if (fControlActive) {
        fSelected = true;
        return true;
      }
    }
    return super.onMouseDown(x,y);
  }
  
  public boolean onMouseDragged(float x, float y) {
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
  
  public boolean onMouseMoved(float x, float y) {
    for (Control c : fControls)
      if (c.onMouseMoved(x,y))
        return true;
    return super.onMouseMoved(x,y);
  }
  
  public boolean onMouseUp(float x, float y) {
    fControlActive = false;
    for (Control c : fControls)
      if (c.onMouseUp(x,y))
        return true;
    return super.onMouseUp(x,y);
  }
}