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
    ellipse(tempPathNode.x, tempPathNode.y, Constants.SIGNAL_WIDTH, Constants.SIGNAL_WIDTH);
    ellipse(tempPathNode2.x, tempPathNode2.y, Constants.SIGNAL_WIDTH, Constants.SIGNAL_WIDTH);
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

void mousePressed() {
  cursor(CROSS);
  Interactive selected = null;
  if (objs.select(mouseX, mouseY)) {
    selected = objs.getSelected();
    lastSelected = selected;
    if (currentMode == Constants.CREATION) {
      // If selected is the initiator, then create axon
      if (selected.getType() == Constants.INITIATOR ||
          selected.getType() == Constants.SOMA) {
        Cell c = (Cell)selected;
        updateTempNode(c.x(), c.y(), c.fSize);
      }
      // if selected is a dendrite or an axon
      else if (selected.getType() == Constants.DENDRITE ||
               selected.getType() == Constants.AXON) {
        Path p = (Path)selected;
        tempPathNode.set(p.getCurrVertex());
        // Dendrite/Axon
        currPath = new Path(p, tempPathNode.x, tempPathNode.y, p.fColor);
      }
      // if selected is a synapse, the create an dendrite
      else if (selected.getType() == Constants.SYNAPSE) {

      }
      else {}
    }
    else if (currentMode == Constants.DELETION) {
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
    else if (currentMode == Constants.INTERACTION) {
    }
    else {
      // Do nothing
    }
  }
  else {
    if (currentMode == Constants.CREATION) {
      // If nothing's selected and in CREATION mode, then try creating initiator
      println("creating stuff mousePressed");
      if (initiator == null)
        initiator = new Initiator(mouseX, mouseY, Constants.INITIATOR_SIZE, Constants.EX_COLOR);
      // if initiator is already present, then create a SOMA
      else if (currentMode == Constants.SOMA)
        currShape = new Soma(mouseX, mouseY, Constants.SOMA_SIZE, 
                    (random(1) > 0.5) ? Constants.EX_COLOR : Constants.IN_COLOR, Constants.SOMA_DEFAULT_THRESHOLD);
    }
  }
  redraw();
}

void mouseDragged() {
  if (currentMode == Constants.CREATION) {
    if (initiator != null)
      initiator.translate(new PVector(mouseX - initiator.x(), mouseY - initiator.y()));
    else if (currShape != null)
      currShape.translate(new PVector(mouseX - currShape.x(), mouseY - currShape.y()));
    else if (currPath != null) {
      currPath.add(mouseX, mouseY);
    }
    Interactive selected = null;
    if (objs.select(mouseX, mouseY)) { // If selected object
      selected = objs.getSelected();
      if (selected != lastSelected) {
        if (selected.getType() == Constants.INITIATOR ||
            selected.getType() == Constants.SOMA) {
          // add end to dendrite
        }
        else if (selected.getType() == Constants.DENDRITE ||
                 selected.getType() == Constants.AXON) {
          //add end to end?
        }
        else if (selected.getType() == Constants.SYNAPSE) {
          // add synapse to axon
        }
        // Update lastSelected
        lastSelected = selected;
      }
      else { // If not different from the last 
        // If still in the initiator or the last selected soma
        if (selected.getType() == Constants.INITIATOR ||
            selected.getType() == Constants.SOMA) {
          Cell c = (Cell)selected;
          updateTempNode(c.x(), c.y(), c.fSize);
        }
      }
    }
    else { // if not selected anything
      
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

void mouseMoved() {
  objs.onMouseMoved(mouseX, mouseY);
  redraw();
}

void mouseReleased() {
  cursor(ARROW);
  if (currentMode == Constants.CREATION) {
    if (initiator != null && initiator.fMovable) { // Hack for now
      objs.add(initiator);
      initiator.setMovable(false);
    }
    else if (currShape != null) {
      objs.add(currShape);
      currShape.setMovable(false);
      currShape = null;
    }
    currPath = null;
    canCreatePath = false;
    lastSelected = null;
    clearTempPathNode();
    // ???
    objs.onMouseUp(mouseX, mouseY);
  }
  redraw();
}

void keyPressed() {
  switch (key) {
    case '1': 
      currentMode = Constants.INITIATOR;
      break;
    case '2': 
      currentMode = Constants.SOMA;
      break;
    case '3': 
      currentMode = Constants.DENDRITE;
      break;
    case '4':
      currentMode = Constants.INTERACTION;
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