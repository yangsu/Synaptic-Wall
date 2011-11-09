class Path extends Interactive implements Signalable{
  ArrayList<PVector> fVertices;
  ArrayList<Signal> fSignals;
  ArrayList<Path> fSubPaths;

  PVector fCurrVert;
  int fCurrIndex;
  Signalable fEnd;
  Signalable fStart;
  
  //TODO: Rethink inheritance hiearchy
  int fBeginPosition;
  int fEndPosition;
  
  Path() {
    fSubPaths = new ArrayList<Path>();
    fVertices = new ArrayList<PVector>();
    fSignals = new ArrayList<Signal>();
    fEnd = fStart = null;
    fCurrVert = null;
    fCurrIndex = 0;
  }
  
  Path(Shape shape){
    this();
    fColor = shape.fColor;
    fCurrVert = shape.fLoc;
    fStart = shape;
  }

  int size(){
    return fVertices.size();
  }
  void setEnd(Signalable obj){
    fEnd = obj;
  }
  PVector getStartLoc(){
    if(fVertices.size()!=0)
      return (PVector)fVertices.get(0);
    return null;
  }
  PVector getEndLoc(){
    if(fVertices.size()!=0)
      return (PVector)fVertices.get(fVertices.size()-1);
    return null;
  }

  void addFirst(float x, float y){
    fVertices.add(new PVector(x,y));
  }
  void add(float x, float y){
    //Get the coordinates of the previously added point.
    PVector prev = (PVector)fVertices.get(fVertices.size()-1);
    float px = prev.x;
    float py = prev.y;
    
    //Find the difference between the previous location and the current one, and 
    //normalizes dx and dy using that difference
    float num;
    if(abs(x-px)>abs(y-py))
      num = abs(x-px);
    else
      num = abs(y-py);
    float dx=(x-px)/num;
    float dy=(y-py)/num;
    
    //Add all the fVertices in between the previous and current fVertices using dx 
    //and dy
    for(int i = 1;i<=num;i++){
      fVertices.add(new PVector(px+i*dx,py+i*dy));
    }
  }
  void translate(PVector change) {
    for (PVector vertex : fVertices) {
      vertex.add(change);
    }
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
        stroke(fColor);
        strokeWeight(Constants.SIGNAL_WIDTH + ((fHover) ? 1 : 0));
        drawPath();
      }
      if (fHover) {
        drawJunction(fCurrVert.x, fCurrVert.y);
        drawJunction(fVertices.get(fCurrIndex).x, fVertices.get(fCurrIndex).y);
      }
    popStyle();
    processSignals();
    for (int i = 0; i < fSignals.size(); ++i) {
      fSignals.get(i).draw();
    }
  }
  
  void drawPath(){
    beginShape();
      PVector temp;
      for (int i = 0; i < fVertices.size(); ++i) {
        temp = fVertices.get(i);
        curveVertex(temp.x,temp.y);
      }
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
        SubPath temp;
        for (int j = 0; j < fSubPaths.size(); ++j) {
          temp = ((SubPath)fSubPaths.get(j));
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
  void addSubPath(SubPath subpath) {
    fSubPaths.add(subpath);
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
        fCurrVert = temp;
        fCurrIndex = i;
        return true;
      }
    }
    return false;
  }
  
  boolean onMouseDown(float x, float y) {
    return (fSelected = isInBounds(x, y));
  }
  boolean onMouseMoved(float x, float y) {
    return (fHover = isInBounds(x, y));
  }
  boolean onMouseDragged(float x, float y) {
    return (fHover = isInBounds(x, y));
  }
  boolean onMouseUp(float x, float y) {
    fSelected = false;
    return false;
  }
}