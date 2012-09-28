boolean gDebug = false;
int gIDCount = 0;

boolean gMagnify;
boolean gSelected;
Selector gSelector;
boolean gSmoothPaths;
int gCurrentMode;
PImage gMagnified;

ObjectCollection gObjs;

Interactive gLastSelected;
Initiator gCurrInitiator;
Soma gCurrShape;
Path gCurrPath;
PVector gIndicator;
PVector gIndicator2;

ControlPanel gCPanel;

Grid gGrid;

void setup() {
  size(Constants.WIDTH, Constants.HEIGHT);
  gMagnified = createImage(Constants.HALFWIDTH, Constants.HALFHEIGHT, ARGB);

  gSelector = new Selector();

  //Settings
  ellipseMode(RADIUS);
  strokeCap(ROUND);
  strokeJoin(ROUND);
  smooth();
  // noLoop();
  noStroke();
  //initialization
  gMagnify = false;
  gSelected = false;
  gSmoothPaths = false;
  gCurrentMode = Constants.CREATION;

  gObjs = new ObjectCollection();
  gCPanel = new ControlPanel(gObjs);

  gCurrShape = null;
  gCurrPath = null;
  gIndicator = new PVector(Constants.MIN, Constants.MIN);
  gIndicator2 = new PVector(Constants.MIN, Constants.MIN);
  gLastSelected = null;
  gCurrInitiator = null;

  gGrid = new Grid(Constants.WIDTH, Constants.GRID_RESOLUTION);
}

void snapIndicators(float x, float y, float size) {
  float angle = Util.getAngleNorm(x, y, mouseX, mouseY);
  float tloc = size-Constants.SOMA_RING_WIDTH/2;
  gIndicator.set(cos(angle)*tloc+x, sin(angle)*tloc+y, 0);
}
void clearIndicators() {
  gIndicator.set(Constants.MIN, Constants.MIN, 0);
  gIndicator2.set(Constants.MIN, Constants.MIN, 0);
}
void drawIndicators() {
  pushStyle();
    fill(255);
    float s = Constants.PATH_JUNCTION_WIDTH;
    ellipse(gIndicator.x, gIndicator.y, s, s);
    ellipse(gIndicator2.x, gIndicator2.y, s, s);
  popStyle();
}

void drawBackground(color cc) {
  pushStyle();
    noStroke();
    fill(cc);
    rect(0, 0, width, height);
  popStyle();
}

void drawAndUpdateContent() {
  drawBackground(Constants.BG_COLOR);
  gGrid.draw();
  gObjs.drawAndUpdate();
  gCPanel.draw();
  if (gCurrShape != null)
    gCurrShape.drawAndUpdate();
  if (gCurrPath != null)
    gCurrPath.drawAndUpdate();
  if (gCurrInitiator != null && gCurrInitiator.fMovable)
    gCurrInitiator.drawAndUpdate();
}

void drawContent() {
  drawBackground(Constants.BG_COLOR);
  gGrid.draw();
  gObjs.draw();
  gCPanel.draw();
  if (gCurrShape != null)
    gCurrShape.draw();
  if (gCurrPath != null)
    gCurrPath.draw();
  if (gCurrInitiator != null && gCurrInitiator.fMovable)
    gCurrInitiator.draw();
}

void drawMagnified() {
  pushStyle();
    pushMatrix();
      translate(mouseX, mouseY);
      scale(Constants.ZOOM_FACTOR);
      translate(-mouseX, -mouseY);
      fill(Constants.FADE_COLOR);
      rect(0, 0, width, height);
      drawContent();
    popMatrix();
    int magnifiedX = constrain(mouseX-Constants.QUARTERWIDTH, 0, Constants.HALFWIDTH);
    int magnifiedY = constrain(mouseY-Constants.QUARTERHEIGHT, 0, Constants.HALFHEIGHT);
    gMagnified = get(magnifiedX, magnifiedY, Constants.HALFWIDTH, Constants.HALFHEIGHT);

    drawContent();

    image(gMagnified, magnifiedX, magnifiedY);

    noFill();
    stroke(255);
    strokeWeight(5);
    rect(magnifiedX, magnifiedY, Constants.HALFWIDTH, Constants.HALFHEIGHT);

    drawIndicators();
    drawText();

  popStyle();
}

void drawText() {
  pushStyle();
    fill(255);
    String s = "";
    switch (gCurrentMode) {
      case Constants.CREATION:
        s = "CREATION";
        break;
      case Constants.DELETION:
        s = "DELETION";
        break;
      case Constants.INTERACTION:
        s = "INTERACTION";
        break;
    }
    text(s, 0, 20);
    // Frame Rate
    s = nf(frameRate, 2, 2) + " FPS";
    text(s, width - 60, 20);
  popStyle();
}

void draw() {
  if (gMagnify)
    drawMagnified();
  else {
    drawAndUpdateContent();
  }
  gSelector.draw();
}

void clear() {
  gObjs.reset();
  gCurrShape = null;
  gCurrPath = null;
  gCurrInitiator = null;
  clearIndicators();
}

boolean released = true;
int lastclick = 0;
void mousePressed() {
  gGrid.onMouseDown(mouseX, mouseY);
  if (millis() - lastclick < Constants.DBL_CLICK_THRESHOLD &&
      gCurrentMode == Constants.INTERACTION) {
    gObjs.onDblClick(mouseX, mouseY);
  }
  lastclick = millis();
  if (released) {
    released = false;
    onMousePressed();
  }
}
void mouseDragged() {
  gGrid.onMouseDragged(mouseX, mouseY);
  onMouseDragged();
}
void mouseMoved() {
  gGrid.onMouseMoved(mouseX, mouseY);
  onMouseMoved();
}
void mouseReleased() {
  gGrid.onMouseUp(mouseX, mouseY);
  if (!released){
    onMouseReleased();
    released = true;
  }
}

void onMousePressed() {
  cursor(CROSS);
  Interactive selected = null;
  if (gCurrentMode == Constants.CREATION) {
    if (gObjs.select(mouseX, mouseY)) {
      selected = gObjs.getSelected().get(0);
      gLastSelected = selected;
      // If selected is the gCurrInitiator, then create axon
      if (selected.getType() == Constants.INITIATOR ||
          selected.getType() == Constants.SOMA) {
        Cell c = (Cell)selected;
        snapIndicators(c.x(), c.y(), c.fSize);
      }
      // if selected is a dendrite or an axon
      else if (selected.getType() == Constants.AXON) {
        Path p = (Path)selected;
        gIndicator.set(p.getCurrVertex());
        gCurrPath = new Axon(p, gIndicator.x, gIndicator.y, p.fColor);
      }
      else if (selected.getType() == Constants.DENDRITE) {
        Path p = (Path)selected;
        gIndicator.set(p.getCurrVertex());
        gCurrPath = new Dendrite(p, gIndicator.x, gIndicator.y, p.fColor);
      }
      // if selected is a synapse, the create an dendrite
      else if (selected.getType() == Constants.SYNAPSE) {
        Synapse s = (Synapse)selected;
        snapIndicators(s.x(), s.y(), s.fSize);
      }
      else {}
    }
    else {
      PVector pos = gGrid.getCurrent();
      if (mouseButton == RIGHT)
        gCurrInitiator = new Initiator(
          pos.x,
          pos.y,
          Constants.SOMA_SIZE,
          Constants.EX_COLOR
        );
      else if (mouseButton == LEFT)
        gCurrShape = new Soma(pos.x, pos.y);
    }
  }
  else if (gCurrentMode == Constants.DELETION) {
    if (gObjs.select(mouseX, mouseY)) {
      selected = gObjs.getSelected().get(0);
      gObjs.remove(selected);
    }
  }
  else if (gCurrentMode == Constants.INTERACTION) {
    if (!gObjs.onMouseDown(mouseX, mouseY, key, keyCode) && !gCPanel.onMouseDown(mouseX, mouseY)) {
      gSelector.beginSelection(mouseX, mouseY);
    }
  }
  else {
    // Do nothing
  }
  redraw();
}

void onMouseDragged() {
  if (gCurrentMode == Constants.CREATION) {
    PVector gridPoint = gGrid.getCurrent();
    if (gCurrInitiator != null && gCurrInitiator.fMovable) {
      gCurrInitiator.translate(new PVector(
        gridPoint.x - gCurrInitiator.x(),
        gridPoint.y - gCurrInitiator.y()
      ));
      return;
    }
    if (gCurrShape != null && gCurrShape.fMovable) {
      gCurrShape.translate(new PVector(
        gridPoint.x - gCurrShape.x(),
        gridPoint.y - gCurrShape.y()
      ));
      return;
    }
    if (gCurrPath != null) {
      gCurrPath.add(gridPoint.x, gridPoint.y);
    }

    Interactive selected = null;
    if (gObjs.select(mouseX, mouseY) ||
        gObjs.select(gridPoint.x, gridPoint.y)) {

      selected = gObjs.getSelected().get(0);
      if (selected != gLastSelected) {
        if (selected.getType() == Constants.INITIATOR ||
            selected.getType() == Constants.SOMA) {
          if (gCurrPath != null) {
            gCurrPath.close();
          }
        }
        else if (selected.getType() == Constants.DENDRITE ||
                 selected.getType() == Constants.AXON) {
          // Show Indicator
          PVector end = ((Path)selected).getCurrVertex();
          gIndicator2.set(end.x, end.y, 0);
        }
        gLastSelected = selected;
      }
      else { // If not different from the last
        // If still in the gCurrInitiator or the last selected soma
        if (selected.getType() == Constants.INITIATOR ||
            selected.getType() == Constants.SOMA ||
            selected.getType() == Constants.SYNAPSE) {
          Shape s = (Shape)selected;
          snapIndicators(s.x(), s.y(), s.fSize);
        }
      }
    }
    else { // if not selected anything
      if (gLastSelected != null && gCurrPath == null) {
        if (gLastSelected.getType() == Constants.INITIATOR ||
            gLastSelected.getType() == Constants.SOMA) {
          Cell c = (Cell)gLastSelected;
          gCurrPath = new Axon(c, gIndicator.x, gIndicator.y, c.fHighlightColor);
        }
        else if (gLastSelected.getType() == Constants.SYNAPSE) {
          Synapse s = (Synapse)gLastSelected;
          if (!s.isComplete()) {
            color c = (s.fColor == Constants.EX_HIGHLIGHT_COLOR) ? Constants.EX_COLOR : Constants.IN_COLOR;
            gCurrPath = new Dendrite(s, s.x(), s.y(), c);
            gCurrPath.add(gIndicator.x, gIndicator.y);
          }
        }
      }
    }
  }
  else if (gCurrentMode == Constants.INTERACTION) {
    if (gSelector.isSelecting()) {
      gSelector.updateSelection(mouseX, mouseY);
    }
    else {
      gObjs.onMouseDragged(mouseX, mouseY);
      gCPanel.onMouseDragged(mouseX, mouseY);
    }
  }
  else {
    // Do nothing
  }
  redraw();
}

void onMouseMoved() {
  if (gCurrentMode == Constants.INTERACTION || gMagnify) {
  }
  gObjs.onMouseMoved(mouseX, mouseY);
  gCPanel.onMouseMoved(mouseX, mouseY);
  redraw();
}

void onMouseReleased() {
  cursor(ARROW);
  if (gCurrentMode == Constants.CREATION) {
    if (gCurrInitiator != null && gCurrInitiator.fMovable) { // Hack for now
      gObjs.add(gCurrInitiator);
      gCurrInitiator.setMovable(false);
      gCurrInitiator = null;
    }
    else if (gCurrShape != null) {
      gObjs.add(gCurrShape);
      gCurrShape.setMovable(false);
      gCurrShape = null;
    }
    else if (gCurrPath != null) {
      int l = gCurrPath.size();
      if (l < 4) println ("ERROR! gCurrPath has a length less than 4");
      else {
        gCurrPath.setMovable(false);
        if (gCurrPath.getType() == Constants.AXON) {
          // Calculate offset so the edge of the Synapse is at the end of the path
          PVector last = gCurrPath.getVertex(l-1);
          PVector diff = PVector.sub(last, gCurrPath.getVertex(l-2));
          diff.normalize();
          PVector center = PVector.add(last, PVector.mult(diff, Constants.SYNAPSE_OUTER_SIZE));
          Synapse s = new Synapse(gCurrPath, center.x, center.y, gCurrPath.fColor);
          gCurrPath.setDest(s);
          gCurrPath.attachToSource();
          gCurrPath.simplify();
          gObjs.add(gCurrPath);
          gObjs.add(s);
        }
        else if (gCurrPath.getType() == Constants.DENDRITE) {
          Interactive selected = null;
          PVector gridPoint = gGrid.getCurrent();
          if (gObjs.select(mouseX, mouseY) ||
              gObjs.select(gridPoint.x, gridPoint.y)) {

            selected = gObjs.getSelected().get(0);
            if (selected.getType() == Constants.SOMA) {
              Cell c = (Cell)selected;
              // Add the indicator point to the path
              snapIndicators(c.x(), c.y(), c.fSize);
              gCurrPath.add(gIndicator.x, gIndicator.y);
              gCurrPath.setDest(c);
              c.addPath(gCurrPath);
            }
            else if ((selected.getType() == Constants.DENDRITE ||
                      selected.getType() == Constants.AXON) &&
                      selected != gCurrPath) {
              //add end to end?
              Path p = (Path)selected;
              PVector end = p.getCurrVertex();
              gIndicator2.set(end.x, end.y, 0);
              gCurrPath.setDest(p);
            }
            if (selected.getType() != Constants.INITIATOR &&
                selected.getType() != Constants.SYNAPSE) {
              // gCurrPath.reduce();
              gCurrPath.attachToSource();
              gCurrPath.simplify();
              gObjs.add(gCurrPath);
            }
          }
        }
      }
      gCurrPath = null;
    }
    gLastSelected = null;
    clearIndicators();
  }
  else if (gCurrentMode == Constants.INTERACTION) {
    if (gSelector.isSelecting()) {
      gSelector.endSelection(mouseX, mouseY);
      gObjs.selectArea(gSelector.getStart(), gSelector.getEnd());
    }
    gObjs.onMouseUp(mouseX, mouseY);
    gCPanel.onMouseUp(mouseX, mouseY);
  }

  redraw();
}

void keyPressed() {
  switch (key) {
    case '1':
      gCurrentMode = Constants.CREATION;
      break;
    case '2':
      gCurrentMode = Constants.DELETION;
      break;
    case '3':
      gCurrentMode = Constants.INTERACTION;
      break;
    case 'm':
      gMagnify = !gMagnify;
      break;
    case 'p':
      noLoop();
      break;
    case 'o':
      loop();
      break;
    case 'c':
      clear();
      break;
    case 's':
      gSmoothPaths = !gSmoothPaths;
      gObjs.onSmoothToggle(gSmoothPaths);
      break;
  }
  redraw();
}