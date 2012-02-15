public interface Controllable{
  void drawControls();
  void showControls();
  void hideControls();
  void onEvent(int controlID, float value);
}