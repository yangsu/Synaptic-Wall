public class ControllerSynapse extends Synapse{
  private CircularSlider fRateSlider, fTimeSlider, fNormSlider;
  private DoubleEndedSlider fSignalRangeSlider;
  private float fRate, fTime, fNorm, fRangeMin, fRangeMax;
  private final int RATE = 0;
  private final int TIME = 1;
  private final int NORM = 2;
  private final int RANGE = 3;

  public ControllerSynapse(float x, float y) {
    this(null, x, y, EX_HIGHLIGHT_COLOR);
  }

  public ControllerSynapse(Path axon, float x, float y, color cc) {
    this(axon, x, y, cc, SYNAPSE_STRENGTH);
  }

  public ControllerSynapse(Path axon, float x, float y, color cc, float strength) {
    super(axon, x, y, cc, strength);
    fRate = 0;
    fTime = 0;
    fNorm = 0;
    fRangeMin = fRangeMax = 0.5;
    initControls();
  }

  private void initControls() {
    float controlSize = fSize + 3 * SLIDER_BAR_WIDTH;
    fNormSlider = new CircularSlider(
      fLoc.x, fLoc.y, controlSize,
      0, TWO_PI/3,
      fNorm, 0, 1.0,
      NORM, this
     );
    fControls.add(fNormSlider);
    fTimeSlider = new DiscreteCircularSlider(
      fLoc.x, fLoc.y, controlSize,
      TWO_PI/3, 2 * TWO_PI/3,
      fTime, 0, 1,
      TIME, this
     );
    fControls.add(fTimeSlider);
    fRateSlider = new DiscreteCircularSlider(
      fLoc.x, fLoc.y, controlSize,
      2 * TWO_PI/3, TWO_PI,
      fRate, 0, 1,
      RATE, this
     );
    fControls.add(fRateSlider);

    fSignalRangeSlider = new DoubleEndedSlider(
      fLoc.x, fLoc.y,
      fSize + SLIDER_BAR_WIDTH*1.25, SLIDER_BAR_WIDTH*0.75,
      PI, TWO_PI,
      fRangeMin, fRangeMax, 0, 1,
      RANGE, this
     );
    fControls.add(fSignalRangeSlider);


    showControls();
  }

  private void drawLabels() {
    pushStyle();

    strokeWeight(CP_BORDER_WIDTH);
    rectMode(CORNER);
    stroke(CP_TEXT_COLOR);
    float r =  fSize + 3 * SLIDER_BAR_WIDTH + CP_TEXT_OFFSET;
    float r2 =  fSize + 4 * SLIDER_BAR_WIDTH;
    float textsize = 9;

    float v = fNormSlider.getValue();
    float t = fNormSlider.getSliderPosition();
    String s ="I-Norm";
    float w = textWidth(s);
    float x = fLoc.x + cos(t)*r;
    float y = fLoc.y + sin(t)*(r + textsize);
    noFill();
    rect(x, y, w + 2 * CP_PADDING, textsize + 2 * CP_PADDING);
    float x2 = fLoc.x + cos(t)*r2;
    float y2 = fLoc.y + sin(t)*r2;
    line(x, y, x2, y2);
    fill(CP_TEXT_COLOR);
    x2 = x + CP_PADDING;
    y2 = y + CP_PADDING + textsize;
    text(s, x2, y2);

    v = fRateSlider.getValue();
    t = fRateSlider.getSliderPosition();
    s = "I-Rate";
    w = textWidth(s);
    x = fLoc.x + cos(t)*r;
    y = fLoc.y + sin(t)*(r + textsize);
    noFill();
    rect(x, y, w + 2 * CP_PADDING, textsize + 2 * CP_PADDING);
    x2 = fLoc.x + cos(t)*r2;
    y2 = fLoc.y + sin(t)*r2;
    line(x, y, x2, y2);
    fill(CP_TEXT_COLOR);
    x2 = x + CP_PADDING;
    y2 = y + CP_PADDING + textsize;
    text(s, x2, y2);

    v = fTimeSlider.getValue();
    t = fTimeSlider.getSliderPosition();
    s = "I-Time";
    w = textWidth(s);
    x = fLoc.x + cos(t)*r - w;
    y = fLoc.y + sin(t)*(r + textsize);
    noFill();
    rect(x, y, w + 2 * CP_PADDING, textsize + 2 * CP_PADDING);
    x2 = fLoc.x + cos(t)*r2;
    y2 = fLoc.y + sin(t)*r2;
    line(x, y, x2, y2);
    fill(CP_TEXT_COLOR);
    x2 = x + CP_PADDING;
    y2 = y + CP_PADDING + textsize;
    text(s, x2, y2);
    popStyle();
  }

  private void drawCenterPiece() {
    pushStyle();

    // Center
    fill(EX_COLOR);
    float s = PATH_JUNCTION_WIDTH;
    ellipse(fLoc.x, fLoc.y, s, s);

    // Stem
    strokeWeight(s);
    stroke(EX_COLOR);
    line(fLoc.x, fLoc.y, fLoc.x, fLoc.y - fSize);

    popStyle();
  }

  public void drawBackground() {
    drawCenterPiece();
    super.drawBackground();
  }

  public void drawForeground() {
    super.drawForeground();
    drawControls();
    drawLabels();
  }

  public void onEvent(int controlID, float value) {
    switch (controlID) {
      case RATE:
        fRate = value;
        break;
      case TIME:
        fTime = value;
        break;
      case NORM:
        fNorm = value;
        break;
      case RANGE:
        fRangeMin = fSignalRangeSlider.getValue();
        fRangeMax = fSignalRangeSlider.getValue2();
        println("min " + fRangeMin + " max " + fRangeMax);
        break;
      default:
        break;
    }
  }
}
