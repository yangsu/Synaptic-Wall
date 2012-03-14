boolean magnify;
float scale;
int currentMode;
PImage temp;

ObjectCollection objs;
Interactive lastSelected;
Initiator initiator;
Soma currShape;
Path currPath;
PVector tempPathNode;
PVector tempPathNode2;
color tempPathNodeColor;
boolean canCreatePath;

void setup() {
  size(800, 800);
  temp = createImage(width/2, height/2, ARGB);
  //Settings
  ellipseMode(RADIUS);
  strokeCap(ROUND);
  smooth();
  // noLoop();
  noStroke();
  Button a = new Button();
  //initialization
  magnify = false;
  currentMode = Constants.CREATION;

  objs = new ObjectCollection();
  currShape = null;
  currPath = null;
  tempPathNode = new PVector(-999, -999);
  tempPathNode2 = new PVector(-999, -999);
  canCreatePath = true;
  lastSelected = null;
  initiator = null;
}
void updateTempNode(float x, float y, float size) {
  float angle = Utilities.getAngleNorm(x, y, mouseX, mouseY);
  float tloc = size-Constants.SOMA_RING_WIDTH/2;
  tempPathNode.set(cos(angle)*tloc+x, sin(angle)*tloc+y, 0);
}
void clearTempPathNode() {
  tempPathNode.set(-999, -999, 0);
  tempPathNode2.set(-999, -999, 0);
}
void drawTempPathNode() {
  pushStyle();
    fill(255);
    ellipse(tempPathNode.x, tempPathNode.y, Constants.SIGNAL_DEFAULT_STRENGTH, Constants.SIGNAL_DEFAULT_STRENGTH);
    ellipse(tempPathNode2.x, tempPathNode2.y, Constants.SIGNAL_DEFAULT_STRENGTH, Constants.SIGNAL_DEFAULT_STRENGTH);
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
  objs.draw();
  if (currShape != null)
    currShape.draw();
  if (currPath != null)
    currPath.draw();
  if (initiator != null && initiator.fMovable)
    initiator.draw();
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

    int tempX = constrain(mouseX-width/4, 0, width);
    int tempY = constrain(mouseY-height/4, 0, height);
    temp = get(tempX, tempY, temp.width, temp.height);

    drawContent();

    image(temp, tempX, tempY);

    noFill();
    stroke(255);
    strokeWeight(5);
    rect(tempX, tempY, temp.width, temp.height);
  popStyle();
}

void drawText() {
  pushStyle();
    fill(255);
    String s = "";
    switch (currentMode) {
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
  if (magnify)
    drawMagnified();
  else
    drawContent();
  drawTempPathNode();
  drawText();
}
void clear() {
  objs = new ObjectCollection();
  currShape = null;
  currPath = null;
  initiator = null;
  clearTempPathNode();
}

boolean released = true;
int lastclick = 0;
void mousePressed() {
  if (millis() - lastclick < Constants.DBL_CLICK_THRESHOLD &&
      currentMode == Constants.INTERACTION) {
    objs.onDblClick(mouseX, mouseY);
  }
  lastclick = millis();
  if (released) {
    released = false;
    onMousePressed();
  }
}
void mouseDragged() {
  onMouseDragged();
}
void mouseMoved() {
  onMouseMoved();
}
void mouseReleased() {
  if (!released){
    onMouseReleased();
    released = true;
  }
}

void onMousePressed() {
  cursor(CROSS);
  Interactive selected = null;
  if (currentMode == Constants.CREATION) {
    if (objs.select(mouseX, mouseY)) {
      selected = objs.getSelected();
      lastSelected = selected;
      // If selected is the initiator, then create axon
      if (selected.getType() == Constants.INITIATOR ||
          selected.getType() == Constants.SOMA) {
        Cell c = (Cell)selected;
        updateTempNode(c.x(), c.y(), c.fSize);
      }
      // if selected is a dendrite or an axon
      else if (selected.getType() == Constants.DENDRITE) {
        Path p = (Path)selected;
        tempPathNode.set(p.getCurrVertex());
        currPath = new Dendrite(p, tempPathNode.x, tempPathNode.y, Constants.DENDRITE_COLOR);
      }
      else if (selected.getType() == Constants.AXON) {
        Path p = (Path)selected;
        tempPathNode.set(p.getCurrVertex());
        currPath = new Axon(p, tempPathNode.x, tempPathNode.y, Constants.AXON_COLOR);
      }
      // if selected is a synapse, the create an dendrite
      else if (selected.getType() == Constants.SYNAPSE) {
        Synapse s = (Synapse)selected;
        updateTempNode(s.x(), s.y(), s.fSize);
      }
      else {}
    }
    else {
      // If nothing's selected and in CREATION mode, then try creating initiator
      if (initiator == null && mouseButton == RIGHT)
        initiator = new Initiator(mouseX,
                                  mouseY,
                                  Constants.SOMA_SIZE,
                                  Constants.EX_COLOR);
      // if initiator is already present, then create a SOMA
      else if (currShape == null && mouseButton == LEFT)
        currShape = new Soma(mouseX,
                             mouseY,
                             Constants.SOMA_SIZE,
                             Constants.EX_COLOR,
                             -7.5,
                             7.5);
    }
  }
  else if (currentMode == Constants.DELETION) {
    if (objs.select(mouseX, mouseY)) {
      selected = objs.getSelected();
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
  else if (currentMode == Constants.INTERACTION) {
    objs.onMouseDown(mouseX, mouseY);
  }
  else {
    // Do nothing
  }
  redraw();
}

void onMouseDragged() {
  if (currentMode == Constants.CREATION) {
    if (initiator != null && initiator.fMovable)
      initiator.translate(new PVector(mouseX - initiator.x(), mouseY - initiator.y()));
    if (currShape != null)
      currShape.translate(new PVector(mouseX - currShape.x(), mouseY - currShape.y()));
    if (currPath != null) {
      currPath.add(mouseX, mouseY);
    }

    Interactive selected = null;
    if (objs.select(mouseX, mouseY)) { // If selected object
      selected = objs.getSelected();
      if (selected != lastSelected) {
        if (selected.getType() == Constants.INITIATOR ||
            selected.getType() == Constants.SOMA) {
          if (currPath != null) currPath.close();
        }
        else if (selected.getType() == Constants.DENDRITE ||
                 selected.getType() == Constants.AXON) {
        }
        else if (selected.getType() == Constants.SYNAPSE) {
        }
        lastSelected = selected;
      }
      else { // If not different from the last
        // If still in the initiator or the last selected soma
        if (selected.getType() == Constants.INITIATOR ||
            selected.getType() == Constants.SOMA ||
            selected.getType() == Constants.SYNAPSE) {
          Shape s = (Shape)selected;
          updateTempNode(s.x(), s.y(), s.fSize);
        }
      }
    }
    else { // if not selected anything
      if (lastSelected != null && currPath == null) {
        if (lastSelected.getType() == Constants.INITIATOR ||
            lastSelected.getType() == Constants.SOMA) {
          Cell c = (Cell)lastSelected;
          currPath = new Axon(c, tempPathNode.x, tempPathNode.y, c.fColor);
        }
        else if (lastSelected.getType() == Constants.SYNAPSE) {
          Synapse s = (Synapse)lastSelected;
          if (!s.isComplete()) {
            currPath = new Dendrite(s, s.x(), s.y(), Constants.DENDRITE_COLOR);
            currPath.add(tempPathNode.x, tempPathNode.y);
          }
        }
      }
    }
  }
  else if (currentMode == Constants.INTERACTION) {
    objs.onMouseDragged(mouseX, mouseY);
  }
  else {
    // Do nothing
  }
  redraw();
}

void onMouseMoved() {
  if (currentMode == Constants.INTERACTION || magnify) {
    objs.onMouseMoved(mouseX, mouseY);
    redraw();
  }
}

void onMouseReleased() {
  cursor(ARROW);
  if (currentMode == Constants.CREATION) {
    if (initiator != null && initiator.fMovable) { // Hack for now
      objs.add(initiator);
      initiator.setMovable(false);
      initiator = null;
    }
    else if (currShape != null) {
      objs.add(currShape);
      currShape.setMovable(false);
      currShape = null;
    }
    else if (currPath != null) {
      int l = currPath.size();
      if (l < 2) println ("ERROR! currPath has a length less than 2");
      else {
        currPath.setMovable(false);
        if (currPath.getType() == Constants.AXON) {
          // Calculate offset so the edge of the Synapse is at the end of the path
          PVector diff = PVector.sub(currPath.getVertex(l-1),
                                     currPath.getVertex(l-2));
          PVector center = PVector.add(currPath.getVertex(l-1),
                            PVector.mult(diff, Constants.SYNAPSE_SIZE- Constants.SIGNAL_DEFAULT_STRENGTH + 1));
          Synapse s = new Synapse(currPath, center.x, center.y, currPath.fColor);
          currPath.setDest(s);
          currPath.reduce();
          currPath.attachToSource();
          objs.add(currPath);
          objs.add(s);
        }
        else if (currPath.getType() == Constants.DENDRITE) {
          Interactive selected = null;
          if (objs.select(mouseX, mouseY)) { // If selected object
            selected = objs.getSelected();
            if (selected.getType() == Constants.SOMA) {
              Cell c = (Cell)selected;
              updateTempNode(c.x(), c.y(), c.fSize);
              currPath.add(tempPathNode.x, tempPathNode.y);
              currPath.setDest(c);
            }
            else if ((selected.getType() == Constants.DENDRITE ||
                      selected.getType() == Constants.AXON) &&
                      selected != currPath) {
              //add end to end?
              Path p = (Path)selected;
              PVector end = p.getCurrVertex();
              tempPathNode2.set(end.x, end.y, 0);
              currPath.setDest(p);
            }
            if (selected.getType() != Constants.INITIATOR &&
                selected.getType() != Constants.SYNAPSE) {
              currPath.reduce();
              currPath.attachToSource();
              objs.add(currPath);
            }
          }
        }
      }
      currPath = null;
    }
    lastSelected = null;
    clearTempPathNode();
  }
  else if (currentMode == Constants.INTERACTION)
    objs.onMouseUp(mouseX, mouseY);

  redraw();
}

void keyPressed() {
  switch (key) {
    case '1':
      currentMode = Constants.CREATION;
      objs.hideControls();
      break;
    case '2':
      currentMode = Constants.DELETION;
      objs.hideControls();
      break;
    case '3':
      currentMode = Constants.INTERACTION;
      objs.showControls();
      break;
    case 'm':
      magnify = !magnify;
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