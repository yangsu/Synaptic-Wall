class Path extends Animatable {
  ArrayList<PVector> fVertices;
  
  int index;
  color cc;

  Shape start;
  Shape end;
  int numPulses;
  int lineWidth;
  
  public Path(){
    fVertices= new ArrayList<PVector>();  
    cc=color(random(255),200,150);
    start=null;
    end=null;
    index = 0;
    numPulses = 1;
    lineWidth = 5;
  }
  
  //Functions--------------------------------------------------------------------------------------
  int size(){
    return fVertices.size();
  }
  public void setStart(Shape obj){
    start=obj;
  }
  public void setEnd(Shape obj){
    end=obj;
  }
  public PVector getStartLoc(){
    return (PVector)fVertices.get(0);
  }
  public PVector getEndLoc(){
    if(fVertices.size()!=0)
      return (PVector)fVertices.get(fVertices.size()-1);
    return null;
  }
  int getPulsePosition(){
    return index;
  }
  void resetPulse(){
    index=0;
  }
  void addFirst(float x, float y){
    fVertices.add(new PVector(x,y));
  }
  void add(float x, float y){
    //Get the coordinates of the previously added point.
    float px=((PVector)fVertices.get(fVertices.size()-1)).x;
    float py=((PVector)fVertices.get(fVertices.size()-1)).y;
    
    //Find the difference between the previous location and the current one, and normalizes dx and dy using that difference
    float num;
    if(abs(x-px)>abs(y-py))
      num=abs(x-px);
    else
      num=abs(y-py);
    float dx=(x-px)/num;
    float dy=(y-py)/num;
    
    //Add all the fVertices in between the previous and current fVertices using dx and dy
    for(int i=1;i<=num;i++){
      fVertices.add(new PVector(px+i*dx,py+i*dy));
    }
  }
  void translate(PVector change) {
    for (PVector vertex : fVertices) {
      vertex.add(change);
    }
  }
  
  void reduce(int resFactor){
    println("before "+fVertices.size());
    for (int i=fVertices.size()-2;i>=1;i--){
      if(i%resFactor==0)
        continue;
      else
        fVertices.remove(i);
    }
    println("after "+fVertices.size());
  }

  //Display Methods---------------------------------------------------------------------------------
  public void draw() {
    pushStyle();
    if (fVertices.size() > 4) {
      noFill();
      stroke(cc);
      strokeWeight(lineWidth);
      show_Bezier_Continuous_Whole();
    }
    popStyle();
  }
  
  void showPoint(float x, float y){
    point(x,y);
  }
  
  void show_Line(){
    if(index==fVertices.size()-1)
      index=0;
    PVector curr=(PVector)fVertices.get(index);
    PVector next=(PVector)fVertices.get(index+1);

    line(curr.x,curr.y,next.x,next.y);
    index++;
  }

  void show_Curve(){
    if(index==fVertices.size()-3)
      index=0;
    PVector curr=(PVector)fVertices.get(index);
    PVector next=(PVector)fVertices.get(index+1);
    PVector next2=(PVector)fVertices.get(index+2);
    PVector next3=(PVector)fVertices.get(index+3);

    beginShape();
    curveVertex(curr.x,curr.y);
    curveVertex(next.x,next.y);
    curveVertex(next2.x,next2.y);
    curveVertex(next3.x,next3.y);
    endShape();
    index++;
  }

  void show_Curve_Whole(){
    beginShape();
    for(int i=0;i<fVertices.size();i++){
      PVector curr=(PVector)fVertices.get(i);
      curveVertex(curr.x,curr.y);
    }
    endShape();
  }

  void show_Bezier_Continuous(){
    if(index==fVertices.size()-3)
      index=0;
    PVector curr=(PVector)fVertices.get(index);
    PVector next=(PVector)fVertices.get(index+1);
    PVector next2=(PVector)fVertices.get(index+2);
    PVector next3=(PVector)fVertices.get(index+3);

    beginShape();
    vertex(curr.x,curr.y);
    bezierVertex(curr.x,curr.y,next.x,next.y,next2.x,next2.y);
    endShape();
    index++;
  }

  void show_Bezier_Continuous_Whole(){
    beginShape();
    PVector start=(PVector)fVertices.get(0);
    vertex(start.x,start.y);
    for(int i=1;i<fVertices.size()-3;i+=2){
      PVector curr=(PVector)fVertices.get(i);
      PVector next=(PVector)fVertices.get(i+1);
      PVector next2=(PVector)fVertices.get(i+2);
      bezierVertex(curr.x,curr.y,next.x,next.y,next2.x,next2.y);

    }
    endShape();
  }

  void pulse(){
    if(index<=fVertices.size()-3&&(numPulses>0)){
      PVector curr=(PVector)fVertices.get(index);
      PVector next=(PVector)fVertices.get(index+1);
      PVector next2=(PVector)fVertices.get(index+2);
      beginShape();
      vertex(curr.x,curr.y);
      bezierVertex(curr.x,curr.y,next.x,next.y,next2.x,next2.y);
      endShape();
      index++;
    }
    else{
      if(start!=null){
        if(numPulses>0){
          //start.totalPulses--;
          numPulses--;
          index=0;
        }
      }
      //      if(end!=null){
      //        end.setNumPulses(1);
      //      }
    }
  }

}