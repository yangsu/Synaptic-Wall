public abstract class Drawable {
  protected color fColor;
  protected color fHighlightColor;
  protected PVector fLoc;
  protected boolean fVisible;
  protected boolean fMovable;

  public Drawable() {
    this(0, 0, color(255));
  }

  public Drawable(float x, float y) {
    this(x, y, color(255));
  }

  public Drawable(float x, float y, color cc) {
    fLoc = new PVector(x, y);
    fVisible = fMovable = true;
    fColor = cc;
    if (cc == Constants.EX_COLOR)
      fHighlightColor = Constants.EX_HIGHLIGHT_COLOR;
    else if (cc == Constants.IN_COLOR)
      fHighlightColor = Constants.IN_HIGHLIGHT_COLOR;
    else
      fHighlightColor = Util.highlight(fColor);
  }

  public void flipColor() {
    if (fColor == Constants.EX_COLOR) {
      fColor = Constants.IN_COLOR;
      fHighlightColor = Constants.IN_HIGHLIGHT_COLOR;
    }
    else if (fColor == Constants.IN_COLOR) {
      fColor = Constants.EX_COLOR;
      fHighlightColor = Constants.EX_HIGHLIGHT_COLOR;
    }
    else if (fColor == Constants.EX_HIGHLIGHT_COLOR) {
      fColor = Constants.IN_HIGHLIGHT_COLOR;
      fHighlightColor = Util.highlight(fColor);
    }
    else if (fColor == Constants.IN_HIGHLIGHT_COLOR) {
      fColor = Constants.EX_HIGHLIGHT_COLOR;
      fHighlightColor = Util.highlight(fColor);
    }
    else {
      println("unknow color");
    }
  }

  public abstract int getType();

  public PVector getLoc() {
    return fLoc;
  }

  public void translate(PVector change) {
    if (fMovable)
      fLoc.add(change);
  }

  public void setVisible(boolean visible) {
    fVisible = visible;
  }

  public void setMovable(boolean movable) {
    fMovable = movable;
  }

  public abstract void draw();
  public void update() {
    //Perform functions that produce animations or other forms of change over time
  };
  public void drawAndUpdate() {
    update();
    draw();
  }

  // Extensions to the drawMethods
  public void ring(float r, float cx, float cy, float t, color c) {
    pushStyle();
    strokeWeight(t);
    float newr = r + t/2 - 0.2;
    noFill();
    stroke(c);
    ellipse(cx, cy, newr, newr);
    popStyle();
  }
  // Arcs
  public void arcWithThickness(float r, float cx, float cy, float startAngle, float endAngle, float t) {
    beginShape();
    float r2 = r + t;
    float x1 = cx + r * cos(startAngle);
    float y1 = cy + r * sin(startAngle);
    float x2 = cx + r2 * cos(endAngle);
    float y2 = cy + r2 * sin(endAngle);
    float x3 = cx + r * cos(endAngle);
    float y3 = cy + r * sin(endAngle);
    vertex(x1, y1);
    fullArc(r, cx, cy, startAngle, endAngle);
    bezierVertex(x2, y2, x3, y3, x2, y2);
    fullArc(r2, cx, cy, endAngle, startAngle);
    endShape(CLOSE);
  }

  public void fullArc(float r, float cx, float cy, float startAngle, float endAngle) {
    int numQuarters;
    float remainder = (endAngle - startAngle)%HALF_PI;
    if (endAngle >= startAngle) {
      numQuarters = floor((endAngle - startAngle)/HALF_PI);
      for (int i = 0; i < numQuarters; i++) {
        quarterArc(r, cx, cy, startAngle + i*HALF_PI, startAngle + (i+1)*HALF_PI, i);
      }
    }
    else {
      numQuarters = ceil((endAngle - startAngle)/HALF_PI);
      for (int i = 0 ; i > numQuarters ; i--) {
        quarterArc(r, cx, cy, startAngle + i*HALF_PI, startAngle + (i-1)*HALF_PI, i);
      }
    }
    quarterArc(r, cx, cy, startAngle + numQuarters*HALF_PI, endAngle, numQuarters);
  }

  public void quarterArc(float r, float cx, float cy, float startAngle, float endAngle, int i) {
    float px0,py0;
    float px1,py1;
    float px2,py2;
    float px3,py3;

    float theta = endAngle - startAngle; // spread of the arc.

    // Compute raw Bezier coordinates.
    float x0 = cos(theta / 2.0);
    float y0 = sin(theta / 2.0);
    float x3 = x0;
    float y3 = 0 - y0;
    float x1 = (4.0 - x0) / 3.0;
    float y1 = ((1.0 - x0) * (3.0 - x0)) / (3.0*y0); // y0 != 0...
    float x2 = x1;
    float y2 = 0 - y1;

    // Compute rotationally-offset Bezier coordinates, using:
    // x' = cos(angle) * x - sin(angle) * y;
    // y' = sin(angle) * x + cos(angle) * y;
    float bezAng = startAngle + theta / 2.0;
    float cBezAng = cos(bezAng);
    float sBezAng = sin(bezAng);
    float rx0 = cBezAng * x0 - sBezAng * y0;
    float ry0 = sBezAng * x0 + cBezAng * y0;
    float rx1 = cBezAng * x1 - sBezAng * y1;
    float ry1 = sBezAng * x1 + cBezAng * y1;
    float rx2 = cBezAng * x2 - sBezAng * y2;
    float ry2 = sBezAng * x2 + cBezAng * y2;
    float rx3 = cBezAng * x3 - sBezAng * y3;
    float ry3 = sBezAng * x3 + cBezAng * y3;

    // Compute scaled and translated Bezier coordinates.
    px0 = cx + r*rx0;
    py0 = cy + r*ry0;
    px1 = cx + r*rx1;
    py1 = cy + r*ry1;
    px2 = cx + r*rx2;
    py2 = cy + r*ry2;
    px3 = cx + r*rx3;
    py3 = cy + r*ry3;

    if (gDebug) {
      // Draw the Bezier control points.
      pushStyle();
      stroke(0, 0 , 0, 64);
      fill  (0, 0 , 0, 64);
      ellipse(px0, py0, 8, 8);
      fill(100, 0 , 0, 64);
      ellipse(px1, py1, 8, 8);
      fill(0, 100 , 0, 64);
      ellipse(px2, py2, 8, 8);
      fill(0, 0 , 100, 64);
      ellipse(px3, py3, 8, 8);
      text(i+0+"", px0, py0);
      text(i+1+"", px1, py1);
      text(i+2+"", px2, py2);
      text(i+3+"", px3, py3);

      // BLUE IS THE "TRUE" CIRULAR ARC:
      noFill();
      stroke(0 , 0, 180, 128);
      arc(cx, cy, r * 2, r * 2, startAngle, endAngle);
      popStyle();
    }

    bezierVertex(px2, py2, px1, py1, px0, py0);
  }
}