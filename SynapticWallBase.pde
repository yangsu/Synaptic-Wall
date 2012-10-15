boolean gDebug = false;
int gIDCount = 0;

SynapticWall sw;
Grid gGrid;
boolean gSmoothPaths;


void setup() {
  //Settings
  size(Constants.WIDTH, Constants.HEIGHT);
  ellipseMode(RADIUS);
  strokeCap(ROUND);
  strokeJoin(ROUND);
  smooth();
  // noLoop();
  noStroke();

  sw = new SynapticWall();
  gGrid = new Grid(Constants.WIDTH, Constants.GRID_RESOLUTION);
  gSmoothPaths = false;
}

void draw() {
  sw.draw();
}

boolean released = true;
int lastclick = 0;
void mousePressed() {
  if (millis() - lastclick < Constants.DBL_CLICK_THRESHOLD) {
    sw.onDblClick();
  }
  lastclick = millis();

  if (released) {
    released = false;
    sw.onMousePressed();
  }
}

void mouseReleased() {
  if (!released){
    sw.onMouseReleased();
    released = true;
  }
}

void mouseMoved() {
  sw.onMouseMoved();
}

void mouseDragged() {
  sw.onMouseDragged();
}

void keyPressed() {
  sw.onKeyPressed();
}