class PathsCollection {
  Path fSelected;
  ArrayList<Path> fPaths;

  PathsCollection() {
    fSelected = null;
    fPaths = new ArrayList<Path>();
  }
  
  void draw() {
    for (int i = 0; i < fPaths.size(); ++i) {
      fPaths.get(i).draw();
    }
  }
  
  Path select(float x, float y) {
    fSelected = null;
    for (int i = 0; i < fPaths.size(); ++i) {
      Path obj = fPaths.get(i);
      if (obj.onMouseDown(x, y)) {
        fSelected = obj;
        //Move shape to the end of the list
        fPaths.remove(fSelected);
        fPaths.add(fSelected);
      }
    }
    return fSelected;
  }
  Path getSelected() {
    return fSelected;
  }

  void add(Path s) {
    if (s != null)
      fPaths.add(s);
  }
  void remove(Path s) {
    if (s != null)
      fPaths.remove(s);
  }
  
  public boolean onMouseDown(float x, float y) {
    return select(x, y) != null;
  }
  public boolean onMouseDragged(float x, float y) {
    for (int i = 0; i < fPaths.size(); ++i) {
      if (fPaths.get(i).onMouseDragged(x, y)) {
        return true;
      }
    }
    return false;
  }
  public boolean onMouseMoved(float x, float y) {
    for (int i = 0; i < fPaths.size(); ++i) {
      if (fPaths.get(i).onMouseMoved(x, y)) {
        return true;
      }
    }
    return false;
  }
  public boolean onMouseUp(float x, float y) {
    for (int i = 0; i < fPaths.size(); ++i) {
      if (fPaths.get(i).onMouseUp(x, y)) {
        return true;
      }
    }
    return false;
  }
}