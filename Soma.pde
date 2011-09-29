class Soma extends Shape {
  ArrayList<Path> dendrites;
  ArrayList<Float> receivedPulses;
  float decay = 0.95;
  float threshold;
  Soma(float x, float y, float size, color cc, float t) {
    super(x, y, size, cc);
    threshold = t;
    receivedPulses = new ArrayList<Float>();
    dendrites = new ArrayList<Path>();
  }
  
  void draw() {
    pushStyle();
    for(int i = 0; i < dendrites.size(); ++i)
      dendrites.get(i).draw();

    if (fSelected) {
      stroke(255);
      strokeWeight(1);
    }
    else
      noStroke();
    fill(fColor);
    ellipse(fLoc.x, fLoc.y, fSize, fSize);
    fill(blendColor(fColor, color(255, 100), ADD));
    ellipse(fLoc.x, fLoc.y, fSize * 0.75, fSize * 0.75);
    popStyle();  
  }
  
  void addDendrite(Path dendrite) {
    if (dendrite != null)
      dendrites.add(dendrite);
  }

  void sendPulse(int numSignal, int delayms, int type) {
    for (int i = 0; i < numSignal; ++i) {
      for (int j = 0; j < dendrites.size(); ++j)
        dendrites.get(j).addPulse(type, i * delayms);
    }
  }

  void receivePulse(int type, float value) {
      float total = 0;
      for (Float f : receivedPulses) {
        f *= decay;
        total += f;
      }
      total += value;
      receivedPulses.add(value);
      if (total >= threshold) {
        receivedPulses.clear();
        for (int j = 0; j < dendrites.size(); ++j)
          dendrites.get(j).addPulse(0, 0);
      }
  }

  boolean isInBounds(float x, float y) {
    if(PVector.dist(fLoc, new PVector(x, y)) <= fSize)
      return true;
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
      PVector change = new PVector(mouseX - pmouseX, mouseY - pmouseY);
      fLoc.add(change);
      for(Path dendrite : dendrites)
        dendrite.translate(change);
      return true;
    }
    else
      return false;
  }
  boolean onMouseUp(float x, float y) {
    fSelected = false;
    return false;
  }
}