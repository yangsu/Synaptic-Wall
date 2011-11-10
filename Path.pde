class Path extends Interactive implements Signalable{
  ArrayList<PVector> fVertices;
  ArrayList<Signal> fSignals;
  ArrayList<Path> fConnectedPaths;

  int fCurrIndex;
  Signalable fEnd;
  Signalable fBegin;
  
  int fBeginPosition;
  int fEndPosition;
  
  Path() {
    super();
  }
  
  Path(Signalable begin, float x, float y, color cc){
    fConnectedPaths = new ArrayList<Path>();
    fVertices = new ArrayList<PVector>();
    fSignals = new ArrayList<Signal>();
    fColor = cc;
    fCurrIndex = 0;
    fEnd = null;
    fBegin = begin;
    fVertices.add(new PVector(x,y));
  }

  int size(){
    return fVertices.size();
  }
  
  void setEnd(Signalable obj){
    fEnd = obj;
  }

  void attachToStart() {
    fBegin.addPath(this);
  }
  PVector getCurrVertex() {
    return fVertices.get(fCurrIndex);
  }
  
  void add(float x, float y){
    //Get the coordinates of the previously added point.
    PVector prev = (PVector)fVertices.get(fVertices.size()-1);
    float px = prev.x;
    float py = prev.y;
    
    //Find the difference between the previous location and the current one, and normalizes dx and dy using that difference
    float num;
    if(abs(x-px)>abs(y-py))
      num = abs(x-px);
    else
      num = abs(y-py);
    float dx=(x-px)/num;
    float dy=(y-py)/num;
    
    //Add all the fVertices in between the previous and current fVertices using dx and dy
    for(int i = 1;i<=num;i++){
      fVertices.add(new PVector(px+i*dx,py+i*dy));
    }
  }
  
  void add(PVector p) {
    this.add(p.x, p.y);
  }
  
  void translate(PVector change) {
    if (fMovable)
      for (PVector vertex : fVertices) {
        vertex.add(change);
      }
  }
  
  void reduce() {
    this.reduce(Constants.SIGNAL_RESOLUTION);
  }
  void reduce(int resFactor){
    for (int i = fVertices.size()-2;i>=1;i--){
      if(i%resFactor==0)
        continue;
      else
        fVertices.remove(i);
    }
  }

  void draw() {
    pushStyle();
      if (fVertices.size() > 2) {
        noFill();
        stroke((fHover) ? Utilities.highlight(fColor) : fColor);
        strokeWeight(Constants.SIGNAL_WIDTH);
        drawPath();
      }
      if (fHover) {
        drawJunction(fVertices.get(fCurrIndex).x, fVertices.get(fCurrIndex).y);
      }
      drawJunction(fVertices.get(0));
      drawJunction(fVertices.get(fVertices.size()-1));
    popStyle();
    
    processSignals();
    for (Signal s : fSignals)
      s.draw();
  }
  
  void drawPath(){
    beginShape();
      PVector temp = fVertices.get(0);
      vertex(temp.x, temp.y);
      for (int i = 1; i < fVertices.size() - 1; ++i) {
        temp = fVertices.get(i);
        curveVertex(temp.x,temp.y);
      }
      temp = fVertices.get(fVertices.size() - 1);
      vertex(temp.x, temp.y);
    endShape();
  }
  
  void drawJunction(float x, float y) {
    pushStyle();
      fill(fColor);
      ellipse(x, y, Constants.SIGNAL_WIDTH, Constants.SIGNAL_WIDTH);
    popStyle();
  }
  void drawJunction(PVector p) {
    drawJunction(p.x, p.y);
  }
  
  void processSignals() {
    for (int i = fSignals.size() - 1; i >= 0; --i) {
      Signal curr = fSignals.get(i);
      int pos = curr.step();
      curr.setBeginAndEnd(fVertices.get(pos), fVertices.get(pos + 1));
      if (curr.reachedEnd()) {
        fEnd.receiveSignal(curr.getType(), curr.getValue(), fEndPosition);
        fSignals.remove(curr);
      }
      else {
        Path temp;
        for (int j = 0; j < fConnectedPaths.size(); ++j) {
          temp = fConnectedPaths.get(j);
          if (pos == temp.fBeginPosition)
            temp.addSignal(Constants.AP, 0);
        }
      }
    }
  }
  
  void addSignal(int type, int delay){
    switch (type) {
      case Constants.EPSP:
      case Constants.IPSP:
        // fSignals.add(new PostsynapticPotential(fVertices.size(), type, delay, fColor, 5.0, 0.99));
        // break;
      case Constants.AP:
      default:
        fSignals.add(new ActionPotential(fVertices.size(), type, 5.0, delay, fColor));
        break;
    }
  }
  
  void addPath(Path p) {
    fConnectedPaths.add(p);
  }
  
  void receiveSignal(int type, float value, int position) {
    Signal s = new ActionPotential(fVertices.size(), type, 5.0, 0, fColor);
    s.setStart(position);
    fSignals.add(s);
  }
  
  boolean isInBounds(float x, float y) {
    PVector mouse = new PVector(x,y);
    PVector temp;
    for (int i = 0; i < fVertices.size(); ++i) {
      temp = fVertices.get(i);
      if (PVector.dist(mouse, temp) <= Constants.SIGNAL_WIDTH) {
        fCurrIndex = i;
        return true;
      }
    }
    return false;
  }
  
  public boolean onMouseUp(float x, float y) {
    fSelected = false;
    return false;
  }
}