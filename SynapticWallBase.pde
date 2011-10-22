ShapesCollection shapes;
PathsCollection paths;
boolean magnify;

int currentMode;
Soma currShape;
Path currPath;

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
}

void drawBackground(color cc) {
  pushStyle();
    noStroke();
    fill(cc);
    rect(0, 0, width, height);
  popStyle();
}
void drawContent(){
  paths.draw();
  shapes.draw();
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
  drawText();
}

void mousePressed() {
  cursor(CROSS);
  Shape selectedShape = shapes.select(mouseX, mouseY);
  Path selectedPath = paths.select(mouseX, mouseY);
  if (currentMode == Constants.SOMA) {
    if (selectedShape != null) {
      shapes.onMouseDown(mouseX, mouseY);
    }
    else {
      currShape = new Soma(mouseX, mouseY, random(20, 30), 
                    color(random(50, 205), random(50, 205), random(50, 205)),
                    random(1, 5));
    }
  }
  else if (currentMode == Constants.DENDRITE) {
    if (selectedShape != null) {
      currPath = new Path(selectedShape);
      currPath.addFirst(selectedShape.x(), selectedShape.y());
    }
    else if (selectedPath != null) {
      currPath = new SubPath(selectedPath, selectedPath.fCurrIndex);
      currPath.addFirst(selectedPath.fCurrVert.x, selectedPath.fCurrVert.y);
      
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
      currShape.setXY(mouseX, mouseY);
  }
  if (currentMode == Constants.DENDRITE) {
    if (currPath != null)
      currPath.add(mouseX, mouseY);
  }
  paths.onMouseDragged(mouseX, mouseY);
  shapes.onMouseDragged(mouseX, mouseY);
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
      currShape = null;        
    }
    else {
      shapes.onMouseUp(mouseX, mouseY);
    }
  }
  if (currentMode == Constants.DENDRITE) {
    //TODO:Need refactoring
    if (currPath != null && currPath.size() > 5) {
      Shape selectedShape = shapes.getSelected();
      Shape endShape = shapes.select(mouseX, mouseY);
      Path selectedPath = paths.getSelected();      
      Path endPath = paths.select(mouseX, mouseY);
      if (selectedShape != null && endShape != null) {
        currPath.setEnd(endShape);
        currPath.add(endShape.x(), endShape.y());
        currPath.reduce(Constants.SIGNAL_RESOLUTION); 
        selectedShape.addDendrite(currPath);
        paths.add(currPath);
      }
      else if (selectedPath != null && endShape != null) {
        currPath.setEnd(endShape);
        currPath.add(endShape.x(), endShape.y());
        selectedPath.addSubPath((SubPath)currPath);
        currPath.reduce(Constants.SIGNAL_RESOLUTION);
        paths.add(currPath);
      }
      else if (selectedPath != null && endPath != null) {
        currPath.setEnd(endPath);
        currPath.add(endPath.fCurrVert.x, endPath.fCurrVert.y);
        selectedPath.addSubPath((SubPath)currPath);
        ((SubPath)currPath).setEndPosition(endPath.fCurrIndex);
        currPath.reduce(Constants.SIGNAL_RESOLUTION);
        paths.add(currPath);
      }
      else {}
      currPath = null;
    }
    else {
    }
  }
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
  }
  redraw();
}