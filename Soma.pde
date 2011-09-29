class Soma extends Shape {
  ArrayList<Path> fDendrites;
  Soma() {
    super(50.0, 50.0, 50, color(255, 0, 0));
    fDendrites = new ArrayList<Path>();
  }
  Soma(float x, float y, float size, color cc) {
    super(x, y, size, cc);
    fDendrites = new ArrayList<Path>();
  }
  
  void draw() {
    pushStyle();
    for(int i = 0; i < fDendrites.size(); ++i)
      fDendrites.get(i).draw();

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
      fDendrites.add(dendrite);
  }

  void sendPulse(int numSignal, int delayms, int type) {
    for (int i = 0; i < numSignal; ++i) {
      for (int j = 0; j < fDendrites.size(); ++j)
        fDendrites.get(j).addPulse(type, i * delayms);
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
      for(Path dendrite : fDendrites)
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