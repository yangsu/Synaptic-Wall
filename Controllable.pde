public interface Controllable{
  public void drawControls();
  public void showControls();
  public void hideControls();
  public void onEvent(int controlID, float value);
}