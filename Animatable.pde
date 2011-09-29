abstract class Animatable {
  int birthTime;
  int lifeCycle;
  Animatable () {
    birthTime = millis();
  }
  
  abstract void draw();
}