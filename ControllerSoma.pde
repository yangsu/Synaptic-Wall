public class ControllerSoma extends Soma {
  ControllerSoma(float x, float y) {
    super(x, y);
    super.showControls();
  }
  ControllerSoma(float x, float y, float size, color cc, float negt, float post) {
    super(x, y, size, cc, negt, post);
    super.showControls();
  }

  public void drawForeground() {
    super.drawForeground();
    pushStyle();

    strokeWeight(Constants.CP_BORDER_WIDTH);
    rectMode(CORNER);
    stroke(Constants.CP_TEXT_COLOR);
    float r =  fSize + 3 * Constants.SLIDER_BAR_WIDTH + Constants.CP_TEXT_OFFSET;
    float r2 =  fSize + 4 * Constants.SLIDER_BAR_WIDTH;
    float textsize = 9;

    float v = fDecaySlider.getValue();
    float t = fDecaySlider.getTheta();
    String s ="I-Decay";
    float w = textWidth(s);
    float x = fLoc.x + cos(t)*r;
    float y = fLoc.y + sin(t)*(r + textsize);
    noFill();
    rect(x, y, w + 2 * Constants.CP_PADDING, textsize + 2 * Constants.CP_PADDING);
    float x2 = fLoc.x + cos(t)*r2;
    float y2 = fLoc.y + sin(t)*r2;
    line(x, y, x2, y2);
    fill(Constants.CP_TEXT_COLOR);
    x2 = x + Constants.CP_PADDING;
    y2 = y + Constants.CP_PADDING + textsize;
    text(s, x2, y2);

    v = fSpeedSlider.getValue();
    t = fSpeedSlider.getTheta();
    s = "I-Speed";
    w = textWidth(s);
    x = fLoc.x + cos(t)*r;
    y = fLoc.y + sin(t)*(r + textsize);
    noFill();
    rect(x, y, w + 2 * Constants.CP_PADDING, textsize + 2 * Constants.CP_PADDING);
    x2 = fLoc.x + cos(t)*r2;
    y2 = fLoc.y + sin(t)*r2;
    line(x, y, x2, y2);
    fill(Constants.CP_TEXT_COLOR);
    x2 = x + Constants.CP_PADDING;
    y2 = y + Constants.CP_PADDING + textsize;
    text(s, x2, y2);

    v = fLengthSlider.getValue();
    t = fLengthSlider.getTheta();
    s = "I-Duration";
    w = textWidth(s);
    x = fLoc.x + cos(t)*r - w;
    y = fLoc.y + sin(t)*(r + textsize);
    noFill();
    rect(x, y, w + 2 * Constants.CP_PADDING, textsize + 2 * Constants.CP_PADDING);
    x2 = fLoc.x + cos(t)*r2;
    y2 = fLoc.y + sin(t)*r2;
    line(x, y, x2, y2);
    fill(Constants.CP_TEXT_COLOR);
    x2 = x + Constants.CP_PADDING;
    y2 = y + Constants.CP_PADDING + textsize;
    text(s, x2, y2);
    popStyle();
  }

  private void drawControlDisplays() {}
  public void showControls() {}
  public void hideControls() {}
}