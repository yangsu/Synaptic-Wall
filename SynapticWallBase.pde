boolean gMagnify;
int gCurrentMode;
PImage gMagnified;

ObjectCollection gObjs;

Interactive gLastSelected;
Initiator gCurrInitiator;
Soma gCurrShape;
Path gCurrPath;
PVector gTempPathNode;
PVector gTempPathNode2;

boolean gCanCreatePath;

Grid gGrid;

void setup() {
  size(Constants.WIDTH, Constants.HEIGHT);
  gMagnified = createImage(width/2, height/2, ARGB);
  //Settings
  ellipseMode(RADIUS);
  strokeCap(ROUND);
  smooth();
  // noLoop();
  noStroke();
  //initialization
  gMagnify = false;
  gCurrentMode = Constants.CREATION;

  gObjs = new ObjectCollection();
  gCurrShape = null;
  gCurrPath = null;
  gTempPathNode = new PVector(-999, -999);
  gTempPathNode2 = new PVector(-999, -999);
  gCanCreatePath = true;
  gLastSelected = null;
  gCurrInitiator = null;

  gGrid = new Grid(Constants.WIDTH, Constants.GRID_RESOLUTION);
}
void updateTempNode(float x, float y, float size) {
  float angle = Utilities.getAngleNorm(x, y, mouseX, mouseY);
  float tloc = size-Constants.SOMA_RING_WIDTH/2;
  gTempPathNode.set(cos(angle)*tloc+x, sin(angle)*tloc+y, 0);
}
void clearTempPathNode() {
  gTempPathNode.set(-999, -999, 0);
  gTempPathNode2.set(-999, -999, 0);
}
void drawTempPathNode() {
  pushStyle();
    fill(255);
    ellipse(gTempPathNode.x, gTempPathNode.y, Constants.SIGNAL_DEFAULT_STRENGTH, Constants.SIGNAL_DEFAULT_STRENGTH);
    ellipse(gTempPathNode2.x, gTempPathNode2.y, Constants.SIGNAL_DEFAULT_STRENGTH, Constants.SIGNAL_DEFAULT_STRENGTH);
  popStyle();
}
void drawBackground(color cc) {
  pushStyle();
    noStroke();
    fill(cc);
    rect(0, 0, width, height);
  popStyle();
}
void drawContent() {
  drawBackground(Constants.BG_COLOR);
  gGrid.draw();
  gObjs.draw();
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

    int gMagnifiedX = constrain(mouseX-width/4, 0, width);
    int gMagnifiedY = constrain(mouseY-height/4, 0, height);
    gMagnified = get(gMagnifiedX, gMagnifiedY, gMagnified.width, gMagnified.height);

    drawContent();

    image(gMagnified, gMagnifiedX, gMagnifiedY);

    noFill();
    stroke(255);
    strokeWeight(5);
    rect(gMagnifiedX, gMagnifiedY, gMagnified.width, gMagnified.height);
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
  popStyle();
}

void draw() {
  if (gMagnify)
    drawMagnified();
  else
    drawContent();
  drawTempPathNode();
  drawText();
}
void clear() {
  gObjs = new ObjectCollection();
  gCurrShape = null;
  gCurrPath = null;
  gCurrInitiator = null;
  clearTempPathNode();
}

boolean released = true;
int lastclick = 0;
void mousePressed() {
  if (millis() - lastclick < Constants.DBL_CLICK_THRESHOLD &&
      gCurrentMode == Constants.INTERACTION) {
    gObjs.onDblClick(mouseX, mouseY);
  }
  lastclick = millis();
  if (released) {
    released = false;
    onMousePressed();
  }
  gGrid.onMouseDown(mouseX, mouseY);
}
void mouseDragged() {
  onMouseDragged();
  gGrid.onMouseDragged(mouseX, mouseY);
}
void mouseMoved() {
  onMouseMoved();
  gGrid.onMouseMoved(mouseX, mouseY);
}
void mouseReleased() {
  if (!released){
    onMouseReleased();
    released = true;
  }
  gGrid.onMouseUp(mouseX, mouseY);
}

void onMousePressed() {
  cursor(CROSS);
  Interactive selected = null;
  if (gCurrentMode == Constants.CREATION) {
    if (gObjs.select(mouseX, mouseY)) {
      selected = gObjs.getSelected();
      gLastSelected = selected;
      // If selected is the gCurrInitiator, then create axon
      if (selected.getType() == Constants.INITIATOR ||
          selected.getType() == Constants.SOMA) {
        Cell c = (Cell)selected;
        updateTempNode(c.x(), c.y(), c.fSize);
      }
      // if selected is a dendrite or an axon
      else if (selected.getType() == Constants.DENDRITE) {
        Path p = (Path)selected;
        gTempPathNode.set(p.getCurrVertex());
        gCurrPath = new Dendrite(p, gTempPathNode.x, gTempPathNode.y, Constants.DENDRITE_COLOR);
      }
      else if (selected.getType() == Constants.AXON) {
        Path p = (Path)selected;
        gTempPathNode.set(p.getCurrVertex());
        gCurrPath = new Axon(p, gTempPathNode.x, gTempPathNode.y, Constants.AXON_COLOR);
      }
      // if selected is a synapse, the create an dendrite
      else if (selected.getType() == Constants.SYNAPSE) {
        Synapse s = (Synapse)selected;
        updateTempNode(s.x(), s.y(), s.fSize);
      }
      else {}
    }
    else {
      PVector pos = gGrid.getCurrent();
      // If nothing's selected and in CREATION mode, then try creating gCurrInitiator
      if (gCurrInitiator == null && mouseButton == RIGHT)
        gCurrInitiator = new Initiator(pos.x,
                                      pos.y,
                                      Constants.SOMA_SIZE,
                                      Constants.EX_COLOR);
      // if gCurrInitiator is already present, then create a SOMA
      else if (gCurrShape == null && mouseButton == LEFT)
        gCurrShape = new Soma(pos.x,
                             pos.y,
                             Constants.SOMA_SIZE,
                             Constants.EX_COLOR,
                             -7.5,
                             7.5);
    }
  }
  else if (gCurrentMode == Constants.DELETION) {
    if (gObjs.select(mouseX, mouseY)) {
      selected = gObjs.getSelected();
      switch (selected.getType()) {
        case Constants.INITIATOR :
          break;
        case Constants.SOMA :
          break;
        case Constants.AXON :
          break;
        case Constants.DENDRITE :
          break;
        case Constants.SYNAPSE :
          break;
      }
    }
  }
  else if (gCurrentMode == Constants.INTERACTION) {
    gObjs.onMouseDown(mouseX, mouseY);
  }
  else {
    // Do nothing
  }
  redraw();
}

void onMouseDragged() {
  if (gCurrentMode == Constants.CREATION) {
    PVector pos = gGrid.getCurrent();
    if (gCurrInitiator != null && gCurrInitiator.fMovable)
      gCurrInitiator.translate(new PVector(pos.x - gCurrInitiator.x(), pos.y - gCurrInitiator.y()));
    if (gCurrShape != null)
      gCurrShape.translate(new PVector(pos.x - gCurrShape.x(), pos.y - gCurrShape.y()));
    if (gCurrPath != null) {
      gCurrPath.add(pos.x, pos.y);
    }

    Interactive selected = null;
    if (gObjs.select(mouseX, mouseY)) { // If selected object
      selected = gObjs.getSelected();
      if (selected != gLastSelected) {
        if (selected.getType() == Constants.INITIATOR ||
            selected.getType() == Constants.SOMA) {
          if (gCurrPath != null) gCurrPath.close();
        }
        else if (selected.getType() == Constants.DENDRITE ||
                 selected.getType() == Constants.AXON) {
        }
        else if (selected.getType() == Constants.SYNAPSE) {
        }
        gLastSelected = selected;
      }
      else { // If not different from the last
        // If still in the gCurrInitiator or the last selected soma
        if (selected.getType() == Constants.INITIATOR ||
            selected.getType() == Constants.SOMA ||
            selected.getType() == Constants.SYNAPSE) {
          Shape s = (Shape)selected;
          updateTempNode(s.x(), s.y(), s.fSize);
        }
      }
    }
    else { // if not selected anything
      if (gLastSelected != null && gCurrPath == null) {
        if (gLastSelected.getType() == Constants.INITIATOR ||
            gLastSelected.getType() == Constants.SOMA) {
          Cell c = (Cell)gLastSelected;
          gCurrPath = new Axon(c, gTempPathNode.x, gTempPathNode.y, Constants.AXON_COLOR);
        }
        else if (gLastSelected.getType() == Constants.SYNAPSE) {
          Synapse s = (Synapse)gLastSelected;
          if (!s.isComplete()) {
            gCurrPath = new Dendrite(s, s.x(), s.y(), Constants.DENDRITE_COLOR);
            gCurrPath.add(gTempPathNode.x, gTempPathNode.y);
          }
        }
      }
    }
  }
  else if (gCurrentMode == Constants.INTERACTION) {
    gObjs.onMouseDragged(mouseX, mouseY);
  }
  else {
    // Do nothing
  }
  redraw();
}

void onMouseMoved() {
  if (gCurrentMode == Constants.INTERACTION || gMagnify) {
    gObjs.onMouseMoved(mouseX, mouseY);
    redraw();
  }
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
      if (l < 2) println ("ERROR! gCurrPath has a length less than 2");
      else {
        gCurrPath.setMovable(false);
        if (gCurrPath.getType() == Constants.AXON) {
          // Calculate offset so the edge of the Synapse is at the end of the path
          PVector diff = PVector.sub(gCurrPath.getVertex(l-1),
                                     gCurrPath.getVertex(l-2));
          PVector center = PVector.add(gCurrPath.getVertex(l-1),
                            PVector.mult(diff, Constants.SYNAPSE_SIZE- Constants.SIGNAL_DEFAULT_STRENGTH + 1));
          Synapse s = new Synapse(gCurrPath, center.x, center.y, gCurrPath.fColor);
          gCurrPath.setDest(s);
          gCurrPath.reduce();
          gCurrPath.attachToSource();
          gObjs.add(gCurrPath);
          gObjs.add(s);
        }
        else if (gCurrPath.getType() == Constants.DENDRITE) {
          Interactive selected = null;
          if (gObjs.select(mouseX, mouseY)) { // If selected object
            selected = gObjs.getSelected();
            if (selected.getType() == Constants.SOMA) {
              Cell c = (Cell)selected;
              updateTempNode(c.x(), c.y(), c.fSize);
              gCurrPath.add(gTempPathNode.x, gTempPathNode.y);
              gCurrPath.setDest(c);
            }
            else if ((selected.getType() == Constants.DENDRITE ||
                      selected.getType() == Constants.AXON) &&
                      selected != gCurrPath) {
              //add end to end?
              Path p = (Path)selected;
              PVector end = p.getCurrVertex();
              gTempPathNode2.set(end.x, end.y, 0);
              gCurrPath.setDest(p);
            }
            if (selected.getType() != Constants.INITIATOR &&
                selected.getType() != Constants.SYNAPSE) {
              gCurrPath.reduce();
              gCurrPath.attachToSource();
              gObjs.add(gCurrPath);
            }
          }
        }
      }
      gCurrPath = null;
    }
    gLastSelected = null;
    clearTempPathNode();
  }
  else if (gCurrentMode == Constants.INTERACTION)
    gObjs.onMouseUp(mouseX, mouseY);

  redraw();
}

void keyPressed() {
  switch (key) {
    case '1':
      gCurrentMode = Constants.CREATION;
      gObjs.hideControls();
      break;
    case '2':
      gCurrentMode = Constants.DELETION;
      gObjs.hideControls();
      break;
    case '3':
      gCurrentMode = Constants.INTERACTION;
      gObjs.showControls();
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
  }
  redraw();
}