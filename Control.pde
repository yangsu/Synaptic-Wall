public abstract class Control extends Interactive{
  protected int fID;
  protected Controllable fTarget;
  public Control(float x, float y, int id, Controllable target) {
    super(x, y);
    fID = id;
    fTarget = target;
  }
  public int getType() {
    return CONTROL;
  }
}