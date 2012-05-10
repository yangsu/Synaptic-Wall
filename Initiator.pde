public class Initiator extends Cell implements TimerSubscriber{
  private static final int RHYTHMICITY = 1;
  private static final int BURSTINESS = 2;
  private static final int FREQUENCY = 3;

  private float fRhythmicity, fFreq;
  private int fBurstiness, fType;

  private CircularSlider fRhythmicitySlider, fFreqSlider, fBurstinessSlider;
  private Timer fTimer;

  private int[] fFiringQueue;

  public Initiator(float x, float y, float size, color cc) {
    this(x, y, size, cc, Constants.DEFAULT_RHYTHMICITY,
         Constants.DEFAULT_BURSTINESS, Constants.DEFAULT_FREQUENCY);
  }

  public Initiator(float x, float y, float size, color cc, float rhythmicity, int burstiness, float frequency) {
    super(x, y, size, cc);
    fRhythmicity = rhythmicity;
    fBurstiness = burstiness;
    fFreq = frequency;
    fType = Constants.EXCITATORY;

    fFiringQueue = new int[0]; // Using append() and subset() is probably inefficient

    // Add controls
    float controlSize = fSize + 3 * Constants.SLIDER_BAR_WIDTH;

    fRhythmicitySlider = new CircularSlider(
      fLoc.x, fLoc.y, controlSize,
       0, TWO_PI/3,
       fRhythmicity, 0, Constants.MAX_RHYTHMICITY,
       RHYTHMICITY, this
     );
    fControls.add(fRhythmicitySlider);
    fBurstinessSlider = new DiscreteCircularSlider(
      fLoc.x, fLoc.y, controlSize,
      TWO_PI/3, 2 * TWO_PI/3,
      fBurstiness, 1, Constants.MAX_BURSTINESS,
      BURSTINESS, this
     );
    fControls.add(fBurstinessSlider);
    fFreqSlider = new CircularSlider(
      fLoc.x, fLoc.y, controlSize,
      2 * TWO_PI/3, TWO_PI,
      fFreq, Constants.DEFAULT_FREQUENCY, Constants.MAX_FREQUENCY,
      FREQUENCY, this
     );
    fControls.add(fFreqSlider);

    fTimer = new Timer(this, round(1000/fFreq), 0.5);
    fTimer.reset();
  }

  public int getType() {
    return Constants.INITIATOR;
  }

  protected boolean fireSignals() {
    for (Path p : fAxons)
        p.addSignal(new ActionPotential(
          Constants.SIGNAL_DEFAULT_SPEED,
          Constants.SIGNAL_DEFAULT_LENGTH,
          Constants.SIGNAL_DEFAULT_DECAY,
          Constants.SIGNAL_DEFAULT_STRENGTH,
          p));
    return true;
  }

  public void onTimerFiring(int id, int time) {
    if (!fTimer.throttled() && random(1.0) <= fRhythmicity) {
      for (int i = 0; i < fBurstiness; i+=1) {
         // resulting in fBurstiness - 1 bursts
        fFiringQueue = append(fFiringQueue, time + i * Constants.BURST_DELAY);
      }
    }
  }

  public void update() {
    fTimer.update();
    int time = millis();
    if (fTimer.ended()) fTimer.reset();
    if (fFiringQueue.length > 0 && fFiringQueue[0] <= time) {
      fire();
      fFiringQueue = subset(fFiringQueue, 1);
    }
  }

  public void drawBackground() {
    pushStyle();
    drawControls();
    float s = fSize - Constants.SOMA_RING_WIDTH;
    fill(fColor);
    noStroke();
    ellipse(fLoc.x, fLoc.y, s, s);
    color c = Constants.SHADOW_COLOR;
    ring(s, fLoc.x + Constants.SHADOW_OFFSETX, fLoc.y + Constants.SHADOW_OFFSETY, Constants.SOMA_RING_WIDTH, c);
    popStyle();
  }

  public void drawForeground() {
    pushStyle();
    float s = fSize - Constants.SOMA_RING_WIDTH;
    color c;
    noStroke();
    if (!fTimer.ended()) {
      c = lerpColor(fHighlightColor, Constants.HIGHLIGHT_COLOR,
        1.0 - 2*abs(fTimer.getProgress() - 0.5));
    }
    else {
      c = fHighlightColor;
    }
    ring(s, fLoc.x, fLoc.y, Constants.SOMA_RING_WIDTH, c);
    popStyle();
  }

  public void flipColor() {
    super.flipColor();
    fType ^= 1; // Flip between EXCITATORY and INHIBITORY
  }

  public void copyAttributes(Cell c) {
    Initiator s = (Initiator)c;
    fRhythmicity = s.fRhythmicity;
    fRhythmicitySlider.setValue(fRhythmicity);
    fBurstiness = s.fBurstiness;
    fBurstinessSlider.setValue(fBurstiness);
    fFreq = s.fFreq;
    fFreqSlider.setValue(fFreq);
  }

  public void onEvent(int controlID, float value) {
    switch (controlID) {
      case RHYTHMICITY:
        fRhythmicity = value;
        break;
      case BURSTINESS:
        fBurstiness = (int)value;
        break;
      case FREQUENCY:
        fFreq = value;
        fTimer.setLength(round(1000/fFreq));
        break;
      default:
        break;
    }
  }

  public void onSignal(Signal s) {
    println("Something's wrong! Initiator is getting a signal!");
  }
}