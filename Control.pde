abstract class Control extends Interactive{
  
  Control(float x, float y) {
    super(x, y);
  }
  abstract boolean isInBounds(float x, float y);
}