interface Interactive {
  
  boolean onMouseDown(float x, float y);
  boolean onMouseDragged(float x, float y);
  boolean onMouseMoved(float x, float y);
  boolean onMouseUp(float x, float y);
  
  boolean onKeyDown(char keyPressed, int specialKey);
  boolean onKeyUp(char keyPressed, int specialKey);
}