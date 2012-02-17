public class Initiator extends Cell {
  private static final int RHYTHMICITY = 1;
  private static final int BURSTINESS = 2;
  private static final int FREQUENCY = 3;

  private float fRhythmicity, fFreq;
  private int fBurstiness;
  private int fLastFireTime;

  private int fTimer;
  private int fEndTime;
  private int fMid;
  private boolean fFired;

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

    fFiringQueue = new int[0]; // Using append() and subset() is probably inefficient

    // Add controls
    float controlSize = fSize + 3 * Constants.SLIDER_BAR_WIDTH;

    fControls.add(new CircularSlider(fLoc.x, fLoc.y, controlSize,
                                     0, TWO_PI/3,
                                     fRhythmicity, 0, Constants.MAX_RHYTHMICITY,
                                     RHYTHMICITY, this));
    fControls.add(new DiscreteCircularSlider(fLoc.x, fLoc.y, controlSize,
                                     TWO_PI/3, 2 * TWO_PI/3,
                                     fBurstiness, 1, Constants.MAX_BURSTINESS,
                                     BURSTINESS, this));
    fControls.add(new CircularSlider(fLoc.x, fLoc.y, controlSize,
                                     2 * TWO_PI/3, TWO_PI,
                                     fFreq, 0, Constants.MAX_FREQUENCY,
                                     FREQUENCY, this));
    fLastFireTime = millis();

    fTimer = 0;
    fEndTime = 0;
    fMid = 0;
    fFired = true;
  }

  public int getType() {
    return Constants.INITIATOR;
  }

  private void drawInitiator() {
    fill(fColor);
    ellipse(fLoc.x, fLoc.y, fSize, fSize);
    noStroke();
    if (fTimer < fEndTime) {
      fill(lerpColor(fHighlightColor, Constants.HIGHLIGHT_COLOR,
        1.0 - 2*abs((fTimer - fMid)/(float)Constants.CELL_TIMING)));
      fTimer = millis();
      if (fTimer > fMid && !fFired) {
        this.fireSignal();
        fFired = true;
      }
    }
    else {
      fill(fHighlightColor);
    }
    ellipse(fLoc.x, fLoc.y, fSize - Constants.SOMA_RING_WIDTH, fSize - Constants.SOMA_RING_WIDTH);
  }

  private void startTimer() {
    fFired = false;
    fTimer = millis();
    fEndTime = fTimer + Constants.CELL_TIMING;
    fMid = fTimer + Constants.CELL_TIMING/2;
  }

  private void fireSignal() {
    for (Path p : fDendrites)
        p.addSignal(new ActionPotential(Constants.SIGNAL_DEFAULT_SPEED,
                                        Constants.SIGNAL_DEFAULT_STRENGTH,
                                        p));
  }
  private void processFiringPattern() {
    int interval = (int)(1000/fFreq);
    int time = millis();
    if ((time - fLastFireTime) > interval && random(1.0) <= fRhythmicity) {
      fLastFireTime = time;
      //fire
      this.startTimer();
      //add burst
      for (int i = 1; i < fBurstiness; i+=1) // resulting in fBurstiness - 1 bursts
        fFiringQueue = append(fFiringQueue, time + i * Constants.BURST_DELAY);
    }
    if (fFiringQueue.length > 0 && fFiringQueue[0] <= time) {
      //fire
      this.startTimer();
      fFiringQueue = subset(fFiringQueue, 1);
    }
  }

  public void draw() {
    super.draw();
    pushStyle();
      this.drawInitiator();
      this.processFiringPattern();
    popStyle();
  }

  void onEvent(int controlID, float value) {
    switch (controlID) {
      case RHYTHMICITY:
        fRhythmicity = value;
        break;
      case BURSTINESS:
        fBurstiness = (int)value;
        break;
      case FREQUENCY:
        fFreq = value;
        break;
      default:
        break;
    }
  }

  void onSignal(Signal s) {
    println("Something's wrong! Initiator is getting a signal!");
  }
}