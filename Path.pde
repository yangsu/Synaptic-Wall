class Path extends Animatable {
  ArrayList<PVector> vertices;
  ArrayList<ActionPotential> aps;  
  int index;
  color cc;

  Shape start;
  Shape end;

  int lineWidth;
  
  public Path(Shape s){
    vertices = new ArrayList<PVector>();
    aps = new ArrayList<ActionPotential>();
    cc=color(random(255),200,150);
    start=s;
    end=null;
    index = 0;
    lineWidth = 5;
  }
  
  //Functions--------------------------------------------------------------------------------------
  int size(){
    return vertices.size();
  }
  public void setStart(Shape obj){
    start=obj;
  }
  public void setEnd(Shape obj){
    end=obj;
  }
  public PVector getStartLoc(){
    return (PVector)vertices.get(0);
  }
  public PVector getEndLoc(){
    if(vertices.size()!=0)
      return (PVector)vertices.get(vertices.size()-1);
    return null;
  }

  void addFirst(float x, float y){
    vertices.add(new PVector(x,y));
  }
  void add(float x, float y){
    //Get the coordinates of the previously added point.
    PVector prev = (PVector)vertices.get(vertices.size()-1);
    float px=prev.x;
    float py=prev.y;
    
    //Find the difference between the previous location and the current one, and normalizes dx and dy using that difference
    float num;
    if(abs(x-px)>abs(y-py))
      num=abs(x-px);
    else
      num=abs(y-py);
    float dx=(x-px)/num;
    float dy=(y-py)/num;
    
    //Add all the vertices in between the previous and current vertices using dx and dy
    for(int i=1;i<=num;i++){
      vertices.add(new PVector(px+i*dx,py+i*dy));
    }
  }
  void translate(PVector change) {
    for (PVector vertex : vertices) {
      vertex.add(change);
    }
  }
  
  void reduce(int resFactor){
    println("before "+vertices.size());
    for (int i=vertices.size()-2;i>=1;i--){
      if(i%resFactor==0)
        continue;
      else
        vertices.remove(i);
    }
    println("after "+vertices.size());
  }

  //Display Methods---------------------------------------------------------------------------------
  public void draw() {
    pushStyle();
    if (vertices.size() > 4) {
      noFill();
      stroke(cc);
      strokeWeight(lineWidth);
      show_Bezier_Continuous_Whole();
    }
    popStyle();
    processActionPotentials();
    for (int i = 0; i < aps.size(); ++i) {
      aps.get(i).draw();
    }
  }

  void show_Bezier_Continuous_Whole(){
    beginShape();
    PVector start=(PVector)vertices.get(0);
    vertex(start.x,start.y);
    for(int i=1;i<vertices.size()-2;i+=2){
      PVector curr=(PVector)vertices.get(i);
      PVector next=(PVector)vertices.get(i+1);
      PVector next2=(PVector)vertices.get(i+2);
      bezierVertex(curr.x,curr.y,next.x,next.y,next2.x,next2.y);
    }
    endShape();
  }

  void processActionPotentials() {
    for (int i = aps.size() - 1; i >= 0; --i) {
      ActionPotential curr = aps.get(i);
      int pos = curr.step();
      curr.setBeginAndEnd(vertices.get(pos), vertices.get(pos + 1));
      if (curr.reachedEnd()) {
        ((Soma)end).receiveAP(curr.getType(), curr.getValue());        
        aps.remove(curr);
      }
    }
  }
  void addActionPotential(int type, int delay){
    aps.add(new ActionPotential(vertices.size(), type, delay));
  }
}