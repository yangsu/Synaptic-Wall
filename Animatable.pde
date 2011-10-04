abstract class Animatable {
  int birthTime;
  int lifeCycle;
  Animatable () {
    lifeCycle = 0;
    birthTime = millis();
  }
}