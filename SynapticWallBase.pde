ShapesCollection shapes;
PathsCollection paths;
boolean magnify;

int currentMode;
Soma currShape;
Path currPath;
PVector tempPathNode;
PVector tempPathNode2;
color tempPathNodeColor;
boolean canCreatePath;

float scale;
PImage temp;
void setup() {
  size(800, 800);
  temp = createImage(width/2, height/2, ARGB);
  //Settings
  ellipseMode(RADIUS);
  strokeCap(ROUND);
  smooth();
  // noLoop();
  noStroke();
  cursor(ARROW);
  Button a = new Button();
  //initialization
  magnify = false;
  currentMode = Constants.SOMA;
  
  shapes = new ShapesCollection();
  paths = new PathsCollection();
  currShape = null;
  currPath = null;
  tempPathNode = new PVector(-999, -999);
  tempPathNode2 = new PVector(-999, -999);
  canCreatePath = true;
}
void clearTempPathNode() {
  tempPathNode.set(-999, -999, 0);
  tempPathNode2.set(-999, -999, 0);
}
void drawTempPathNode() {
  pushStyle();
    fill(tempPathNodeColor);
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
void drawContent(){
  shapes.draw();
  paths.draw();
  if (currShape != null)
    currShape.draw();
  if (currPath != null)
    currPath.draw();
}
void drawMagnified() {
  pushStyle();
    pushMatrix();
      translate(mouseX, mouseY);
      scale(Constants.ZOOM_FACTOR);
      translate(-mouseX, -mouseY);
      fill(Constants.FADE_COLOR);
      rect(0, 0, width, height);
      drawBackground(Constants.BG_COLOR);
      drawContent();
    popMatrix();
  
    int tempX = constrain(mouseX-width/4, 0, width);
    int tempY = constrain(mouseY-height/4, 0, height);
    temp = get(tempX, tempY, temp.width, temp.height);
  
    drawBackground(Constants.BG_COLOR);
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
    switch (currentMode) {
      case Constants.SOMA:
        text("Soma", 0, 20);
        break;
      case Constants.DENDRITE:
        text("Dendrite", 0, 20);
        break;
      case Constants.INTERACTION:
        text("Interaction", 0, 20);
        break;
    }
  popStyle();
}
void draw() {
  if (magnify) {
    drawMagnified();
  }
  else {
    drawBackground(Constants.BG_COLOR);
    drawContent();
  }
  drawTempPathNode();
  drawText();
}

void clear() {
  shapes = new ShapesCollection();
  paths = new PathsCollection();
  currShape = null;
  currPath = null;
}
void mousePressed() {
  cursor(CROSS);
  canCreatePath = true;
  Shape selectedShape = shapes.select(mouseX, mouseY);
  Path selectedPath = paths.select(mouseX, mouseY);
  if (currentMode == Constants.SOMA) {
    if (selectedShape == null) {
      currShape = new Soma(mouseX, mouseY, random(20, 30), 
                    color(random(50, 205), random(50, 205), random(50, 205)),
                    random(-Constants.SOMA_MAX_THRESHOLD, Constants.SOMA_MAX_THRESHOLD));
    }
  }
  else if (currentMode == Constants.DENDRITE) {
    if (selectedShape != null) {
      // tempPathNodeColor = selectedShape.fColor + 0x444444;
      tempPathNodeColor = 0xFFFFFFFF;
      float angle = Utilities.getAngleNorm(selectedShape.x(), selectedShape.y(), mouseX, mouseY);
      tempPathNode.set(cos(angle)*(selectedShape.fSize - Constants.SOMA_RING_WIDTH/2) + selectedShape.x(), 
                       sin(angle)*(selectedShape.fSize - Constants.SOMA_RING_WIDTH/2) + selectedShape.y(), 0);
    }
    else if (selectedPath != null) {
      currPath = new SubPath(selectedPath, selectedPath.fCurrIndex);
      // currPath.addFirst(selectedPath.fCurrVert.x, selectedPath.fCurrVert.y);
    }
    else
      paths.onMouseDown(mouseX, mouseY);
  }
  else if (currentMode == Constants.INTERACTION && selectedShape != null) {
    ((Soma)selectedShape).fireSignal(5, 200, Constants.IPSP);
  }
  else {
    
  }
  redraw();
}
void mouseDragged() {  
  if (currentMode == Constants.SOMA) {
    if (currShape != null)
      currShape.translate(new PVector(mouseX - currShape.x(), mouseY - currShape.y()));
    shapes.onMouseDragged(mouseX, mouseY);
  }
  else if (currentMode == Constants.DENDRITE) {
    Shape selectedShape = shapes.select(mouseX, mouseY);
    
    if (currPath != null) {
      if (selectedShape != null) { // found ending soma
        float angle = Utilities.getAngleNorm(selectedShape.x(), selectedShape.y(), mouseX, mouseY);
        tempPathNode2.set(cos(angle)*(selectedShape.fSize - Constants.SOMA_RING_WIDTH/2) + selectedShape.x(), 
                          sin(angle)*(selectedShape.fSize - Constants.SOMA_RING_WIDTH/2) + selectedShape.y(), 0);
        currPath.add(tempPathNode2.x, tempPathNode2.y);
        currPath.setEnd(selectedShape);
        currPath.reduce(Constants.SIGNAL_RESOLUTION); 
        selectedShape.addDendrite(currPath);
        paths.add(currPath);
        currPath = null;
        canCreatePath = false;
      }
      else { // Creating Path
        currPath.add(mouseX, mouseY);
      }
    }
    else if (canCreatePath) { 
      if (selectedShape != null && selectedShape.isInBounds(mouseX, mouseY)) { // Still at inside starting soma
          float angle = Utilities.getAngleNorm(selectedShape.x(), selectedShape.y(), mouseX, mouseY);
          tempPathNode.set(cos(angle)*(selectedShape.fSize - Constants.SOMA_RING_WIDTH/2) + selectedShape.x(), 
                           sin(angle)*(selectedShape.fSize - Constants.SOMA_RING_WIDTH/2) + selectedShape.y(), 0);
      }
      else { // Left starting soma for the first time and a path is created
        currPath = new Path(shapes.select(tempPathNode.x, tempPathNode.y), tempPathNode.x, tempPathNode.y);
      }
    }
    else {
      paths.onMouseDragged(mouseX, mouseY);
    }
  }
  redraw();
}

void mouseMoved() {
  if(magnify) 
    redraw();
  if (currentMode == Constants.SOMA) {
    shapes.onMouseMoved(mouseX, mouseY);
  }
  if (currentMode == Constants.DENDRITE) {
    paths.onMouseMoved(mouseX, mouseY);
  }
}

void mouseReleased() {
  cursor(ARROW);
  
  if (currentMode == Constants.SOMA) {
    if (currShape != null) {
      shapes.add(currShape);
      currShape.setMovable(false);
      currShape = null;        
    }
    else {
      shapes.onMouseUp(mouseX, mouseY);
    }
  }
  if (currentMode == Constants.DENDRITE) {

  }
  clearTempPathNode();
  redraw();
}

void keyPressed() {
  switch (key) {
    case '1': 
      currentMode = Constants.SOMA;
      break;
    case '2': 
      currentMode = Constants.DENDRITE;
      break;
    case '3': 
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