public class Initiator extends Shape implements Controllable {
  private static final int RHYTHMICITY = 1;
  private static final int BURSTINESS = 2;
  private static final int FREQUENCY = 3;

  private float fRhythmicity, fFreq;
  private int fBurstiness;

  public Initiator(float x, float y, float size, color cc, float rhythmicity, int burstiness, float frequency) {
    super(x, y, size, cc);
    fRhythmicity = rhythmicity;
    fBurstiness = burstiness;
    fFreq = frequency;

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

  public void draw() {    
    pushStyle();
      for (Control c : fControls)
        c.draw();
      this.drawInitiator();
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
  }

  void onSignal(Signal s) {
    println("Something's wrong! Initiator is getting a signal!");
  }

}