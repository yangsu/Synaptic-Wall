class ShapesCollection extends Animatable implements Interactive{
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
      if (obj.onMouseDown(x, y)) {
        fSelected = obj;
        //Move shape to the end of the list
        fShapes.remove(fSelected);
        fShapes.add(fSelected);
      }
    }
    return fSelected;
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
  
  boolean onMouseDown(float x, float y) {
  	return select(x, y) != null;
  }
  boolean onMouseDragged(float x, float y) {
    for (int i = 0; i < fShapes.size(); ++i) {
  	  if (fShapes.get(i).onMouseDragged(x, y)) {
        return true;
  	  }
  	}
  	return false;
  }
  boolean onMouseMoved(float x, float y) {
    for (int i = 0; i < fShapes.size(); ++i) {
  	  if (fShapes.get(i).onMouseMoved(x, y)) {
        return true;
  	  }
  	}
  	return false;
  }
  boolean onMouseUp(float x, float y) {
    for (int i = 0; i < fShapes.size(); ++i) {
  	  if (fShapes.get(i).onMouseUp(x, y)) {
        return true;
  	  }
  	}
  	return false;
  }
}