public class Initiator extends Cell {
  private static final int RHYTHMICITY = 1;
  private static final int BURSTINESS = 2;
  private static final int FREQUENCY = 3;

  private float fRhythmicity, fFreq;
  private int fBurstiness;
  private int fBirthTime;

  private int[] fFiringQueue;
  private boolean fPropChanged;
  private int fStep, fStop;

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
    fPropChanged = false;
    fStep = 30;
    fStop = 30; //Visuals lasts 1 second

    fBirthTime = frameCount;
  }

  private void drawInitiator() {
    fill(fColor);
    if (fSelected)
      stroke(255);
    ellipse(fLoc.x, fLoc.y, fSize, fSize);
    noStroke();
    fill(blendColor(fColor, color(255, 100), ADD));
    ellipse(fLoc.x, fLoc.y, fSize - Constants.SOMA_RING_WIDTH, fSize - Constants.SOMA_RING_WIDTH);
  }

  private void fireSignal() {
    for (Path p : fDendrites)
        p.addSignal(new PostsynapticPotential(Constants.SIGNAL_DEFAULT_SPEED, 
                                              Constants.SIGNAL_DEFAULT_LENGTH, 
                                              Constants.SIGNAL_DEFAULT_STRENGTH, 
                                              p));
  }
  private void processFiringPattern() {
    int interval = (int)(30/fFreq);
    if ((frameCount - fBirthTime)%interval == 0 && random(1.0) <= fRhythmicity) {
      //fire
      this.fireSignal();
      //add burst
      for (int i = 1; i < fBurstiness; i+=1) // resulting in fBurstiness - 1 bursts
        fFiringQueue = append(fFiringQueue, frameCount + i * Constants.BURST_DELAY);
    }
    if (fFiringQueue.length > 0 && fFiringQueue[0] <= frameCount) {
      //fire
      this.fireSignal();
      fFiringQueue = subset(fFiringQueue, 1);
    }
  }

  private void visualizeChange() {
    if (fStep < fStop) {
      // Visuals
      fStep += 1;
    }
  }

  public void draw() {    
    pushStyle();
      for (Control c : fControls)
        c.draw();
      this.drawInitiator();
      this.processFiringPattern();
      this.visualizeChange();
    popStyle();
  }

  boolean isInBounds(float x, float y) {
    return PVector.dist(fLoc, new PVector(x, y)) <= fSize;
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
    fPropChanged = true;
    fStep = 0;
  }

  void onSignal(Signal s) {
    println("Something's wrong! Initiator is getting a signal!");
  }
}