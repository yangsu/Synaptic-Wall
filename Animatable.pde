abstract class Animatable extends Utilities {
  int birthTime;
  int lifeCycle;
  Animatable () {
    lifeCycle = 0;
    birthTime = millis();
  }
  
  abstract void draw();
}