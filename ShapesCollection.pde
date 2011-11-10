class ShapesCollection {
  Shape fSelected;
  ArrayList<Shape> fShapes;

  ShapesCollection() {
    fSelected = null;
    fShapes = new ArrayList<Shape>();
  }
  
  void draw() {
    for (int i = 0; i < fShapes.size(); ++i) {
      fShapes.get(i).draw();
    }
  }
  
  Shape select(float x, float y) {
    fSelected = null;
    for (int i = 0; i < fShapes.size(); ++i) {
      Shape obj = fShapes.get(i);
      if (obj.select(x, y)) {
        fSelected = obj;
        //Move shape to the end of the list
        fShapes.remove(fSelected);
        fShapes.add(fSelected);
        break;
      }
    }
    this.deselectAllOthers();
    return fSelected;
  }
  
  void deselectAllOthers() {
    for (Shape s : fShapes)
      if (s != fSelected)
        s.deselect();
  }
  Shape getSelected() {
    return fSelected;
  }
  
  void add(Shape s) {
    if (s != null)
      fShapes.add(s);
  }
  void remove(Shape s) {
    if (s != null)
      fShapes.remove(s);
  }
  
  public boolean onMouseDown(float x, float y) {
    boolean result = false;
    for (int i = 0; i < fShapes.size(); ++i)
      result = result || fShapes.get(i).onMouseDown(x, y);
    return result;
  }
  public boolean onMouseDragged(float x, float y) {
    boolean result = false;
    for (int i = 0; i < fShapes.size(); ++i)
      result = result || fShapes.get(i).onMouseDragged(x, y);
    return result;
  }
  public boolean onMouseMoved(float x, float y) {
    boolean result = false;
    for (int i = 0; i < fShapes.size(); ++i)
      result = result || fShapes.get(i).onMouseMoved(x, y);
    return result;
  }
  public boolean onMouseUp(float x, float y) {
    boolean result = false;
    for (int i = 0; i < fShapes.size(); ++i)
      result = result || fShapes.get(i).onMouseUp(x, y);
    return false;
  }
}