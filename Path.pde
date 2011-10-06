class Path extends Animatable implements Interactive, Drawable, Signalable{
  ArrayList<PVector> fVertices;
  ArrayList<Signal> fSignals;
  ArrayList<Path> fSubPaths;

  boolean fHover;
  boolean fCreatingSubPath;
  color fColor;
  Path fCurrSubPath;
  PVector fCurrVert;
  Shape fEnd;
  Shape fStart;
  
  Path() {
    fSubPaths = new ArrayList<Path>();
    fVertices = new ArrayList<PVector>();
    fHover = fCreatingSubPath = false;
    fSignals = new ArrayList<Signal>();
    fEnd = fStart = null;
    fCurrVert = null;
    fCurrSubPath = null;
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
  void setEnd(Shape obj){
    fEnd = obj;
  }
  PVector getStartLoc(){
    if(fVertices.size()!=0)
      return (PVector)fVertices.get(0);
    return null;
  }
  PVector getfEndLoc(){
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
        strokeWeight(Contants.SIGNAL_WIDTH + ((fHover) ? 1 : 0));
        drawPath();
      }
      if (fHover) {
        fill(255);
        ellipse(fCurrVert.x, fCurrVert.y, Contants.SIGNAL_WIDTH, Contants.SIGNAL_WIDTH);
      }
      drawSubPaths();
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
      // for (int j = fSignals.size() - 1; j >= 0; --j) {
      //   if (i == (fSignals.get(j).getIndex() + 1)){
      //     endShape();
      //     beginShape();
      //     curveVertex(temp.x,temp.y);
      //     //Only one signal should match the current index 
      //     break;
      //   }
      // }
    }
    endShape();
  }
  void drawSubPaths() {
    if (fCreatingSubPath)
      fCurrSubPath.draw();
    for (int i = 0; i < fSubPaths.size(); ++i) {
      fSubPaths.get(i).draw();
    }
  }
  void processSignals() {
    for (int i = fSignals.size() - 1; i >= 0; --i) {
      Signal curr = fSignals.get(i);
      int pos = curr.step();
      curr.setBeginAndEnd(fVertices.get(pos), fVertices.get(pos + 2));
      if (curr.reachedEnd()) {
        ((Soma)fEnd).receiveSignal(curr.getType(), curr.getValue());
        fSignals.remove(curr);
      }
    }
  }
  void addSignal(int type, int delay){
    switch (type) {
      case Contants.EPSP:
      case Contants.IPSP:
        // fSignals.add(new PostsynapticPotential(fVertices.size(), type, delay, fColor, 5.0, 0.99));
        // break;
      case Contants.AP:
      default:
        fSignals.add(new ActionPotential(fVertices.size(), type, 5.0, delay, fColor));
        break;
    }
  }
  
  void fireSignal(int numSignal, int delayms, int type) {
    
  }
  void receiveSignal(int type, float value) {
    
  }
  
  boolean isOnPath(float x, float y) {
    PVector mouse = new PVector(x,y);
    PVector temp;
    fHover = false;
    for (int i = 0; i < fVertices.size(); ++i) {
      temp = fVertices.get(i);
      if (PVector.dist(mouse, temp) <= Contants.SIGNAL_WIDTH) {
        fCurrVert = temp;
        fHover = true;
      }
    }
    return fHover;
  }
  
  boolean onMouseDown(float x, float y) {
    if (fHover) {
      // fCurrSubPath = new Path(fStart);
      // fCurrSubPath.addFirst(fCurrVert.x, fCurrVert.y);
      // fCreatingSubPath = true;
      return true;
    }
    else
      return false;
  }
  boolean onMouseDragged(float x, float y) {
    if (fCreatingSubPath) {
      fCurrSubPath.add(x,y);
    }
    return false;
  }
  boolean onMouseMoved(float x, float y) {
    return !fCreatingSubPath && isOnPath(x,y);
  }
  boolean onMouseUp(float x, float y) {
    if (fCreatingSubPath) {
      fCurrSubPath.setEnd(fEnd);
      fCurrSubPath.reduce(Contants.SIGNAL_RESOLUTION); 
      fSubPaths.add(fCurrSubPath);
      fCurrSubPath = null;
      fCreatingSubPath = false;
    }
    return false;
  }
}