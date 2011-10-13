abstract class Animatable extends Drawable{
  int fBirthTime;
  int fLifeCycle;
  boolean fAnimationEnded;
  Animatable () {
    fLifeCycle = 0;
    fBirthTime = millis();
    fAnimationEnded = false;
  }
}