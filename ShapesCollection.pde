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
  boolean select(float x, float y) {
    boolean result = false;
    for (int i = 0; i < fShapes.size(); ++i) {
      Shape obj = fShapes.get(i);
      if (obj.onMouseDown(x, y)) {
        fSelected = obj;
        fShapes.remove(fSelected);
        fShapes.add(fSelected);
        result = true;
      }
      else {
        obj.deselect();
      }
    }
    if (!result)    
      fSelected = null;
    return result;
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
  	return select(x, y);
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
  boolean onKeyDown(char keyPressed, int specialKey) {
    for (int i = 0; i < fShapes.size(); ++i) {
  	  if (fShapes.get(i).onKeyDown(keyPressed, specialKey))
  	    return true;
  	}
  	return false;
  }
  boolean onKeyUp(char keyPressed, int specialKey) {
    for (int i = 0; i < fShapes.size(); ++i) {
  	  if (fShapes.get(i).onKeyUp(keyPressed, specialKey))
  	    return true;
  	}
  	return false;
  }
}