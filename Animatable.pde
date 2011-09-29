abstract class Animatable extends Utilities {
  int birthTime;
  int lifeCycle;
  Animatable () {
    lifeCycle = FADE_COLOR;
    birthTime = millis();
  }
  
  abstract void draw();
}