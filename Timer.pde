public class Timer {
  private int fID;
  private int fStartTime, fEndTime, fLastFiredTime, fThrottleInterval, fLength;
  private float fFiringPos;
  private boolean fFired;
  private ArrayList<TimerSubscriber> fSubs;

  public Timer(TimerSubscriber sub, int lengthMS) {
    this(sub, lengthMS, 1, 0);// Default to fire at the end of the timer interval
  }

  public Timer(TimerSubscriber sub, int lengthMS, float firingPos) {
    this(sub, lengthMS, firingPos, 0);
  }
  public Timer(TimerSubscriber sub, int lengthMS, float firingPos, int throttleInterval) {
    fID = gIDCount++;
    fLength = lengthMS;
    fFiringPos = firingPos;
    fThrottleInterval = throttleInterval;
    fLastFiredTime = 0;
    fSubs = new ArrayList<TimerSubscriber>();
    addSub(sub);
    fFired = false;
  }

  public void update() {
    int currentTime = millis();
    if (currentTime >= fEndTime && !fFired && !throttled()) {
      fFired = true;
      fLastFiredTime = currentTime;
      for (TimerSubscriber sub : fSubs)
        sub.onTimerFiring(fID, currentTime);
    }
  }

  public void reset() {
    if (gDebug) println(fID + " reset");
    // println((fLastFiredTime - fStartTime) +"  "+ (fEndTime - fStartTime));
    fStartTime = millis();
    fEndTime = fStartTime + round(fLength * fFiringPos);
    fFired = false;
  }

  public float getProgress() {
    return float(millis() - fStartTime)/fLength;
  }

  public int getLastFiredTime() {
    return fLastFiredTime;
  }

  public void setLength(int l) {
    fLength = l;
  }

  public boolean throttled() {
    int time = millis();
    return (time >= fStartTime) && (time <= fEndTime + fThrottleInterval);
  }

  public boolean ended() {
    return getProgress() >= 1;
  }

  public boolean fired() {
    return fFired;
  }

  public void addSub(TimerSubscriber sub) {
    fSubs.add(sub);
  }

  public void removeSub(TimerSubscriber sub) {
    fSubs.remove(sub);
  }
}

public interface TimerSubscriber {
  public void onTimerFiring(int id, int currentTime);
}