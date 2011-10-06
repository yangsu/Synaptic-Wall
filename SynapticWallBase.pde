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
  currentMode = Contants.SOMA;
  
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
      scale(Contants.ZOOM_FACTOR);
      translate(-mouseX, -mouseY);
      fill(Contants.FADE_COLOR);
      rect(0, 0, width, height);
      drawBackground(Contants.BG_COLOR);
      drawContent();
    popMatrix();
  
    int tempX = constrain(mouseX-width/4, 0, width);
    int tempY = constrain(mouseY-height/4, 0, height);
    temp = get(tempX, tempY, temp.width, temp.height);
  
    drawBackground(Contants.BG_COLOR);
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
      case Contants.SOMA:
        text("Soma", 0, 20);
        break;
      case Contants.DENDRITE:
        text("Dendrite", 0, 20);
        break;
      case Contants.INTERACTION:
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
    drawBackground(Contants.BG_COLOR);
    drawContent();
  }
  drawText();
}

void mousePressed() {
  cursor(CROSS);
  Shape selectedShape = shapes.select(mouseX, mouseY);
  Path selectedPath = paths.select(mouseX, mouseY);
  if (currentMode == Contants.SOMA) {
    if (selectedShape != null) {
      shapes.onMouseDown(mouseX, mouseY);
    }
    else {
      currShape = new Soma(mouseX, mouseY, random(20, 30), 
                    color(random(50, 205), random(50, 205), random(50, 205)),
                    random(1, 5));
    }
  }
  else if (currentMode == Contants.DENDRITE) {
    if (selectedShape != null) {
      currPath = new Path(selectedShape);
      currPath.addFirst(selectedShape.x(), selectedShape.y());
    }
    else if (selectedPath != null) {
      currPath = new Path();
      currPath.addFirst(selectedShape.x(), selectedShape.y());
    }
    else
      paths.onMouseDown(mouseX, mouseY);
  }
  else if (currentMode == Contants.INTERACTION && selectedShape != null) {
    ((Soma)selectedShape).fireSignal(5, 200, Contants.IPSP);
  }
  else {
    
  }
  redraw();
}
void mouseDragged() {
  if (currentMode == Contants.SOMA) {
    if (currShape != null) {      
      currShape.setXY(mouseX, mouseY);
    }
    else {
      shapes.onMouseDragged(mouseX, mouseY);
    }
  }
  if (currentMode == Contants.DENDRITE) {
    if (shapes.getSelected() != null && currPath != null)
      currPath.add(mouseX, mouseY);
    else
      paths.onMouseDragged(mouseX, mouseY);
  }
  redraw();
}

void mouseMoved() {
  if(magnify) 
    redraw();
  shapes.onMouseMoved(mouseX, mouseY);
  paths.onMouseMoved(mouseX, mouseY);
}

void mouseReleased() {
  cursor(ARROW);
  
  if (currentMode == Contants.SOMA) {
    if (currShape != null) {
      shapes.add(currShape);
      currShape = null;        
    }
    else {
      shapes.onMouseUp(mouseX, mouseY);
    }
  }
  if (currentMode == Contants.DENDRITE) {
    if (currPath != null) {
      Soma start = (Soma)shapes.getSelected();
      Soma end = (Soma)shapes.select(mouseX, mouseY);
      if (end != null && currPath.size() > 5) {
        currPath.setEnd(end);
        currPath.add(end.x(), end.y());
        currPath.reduce(Contants.SIGNAL_RESOLUTION); 
        start.addDendrite(currPath);
        paths.add(currPath);
      }
      currPath = null;
    }
    else {
      paths.onMouseUp(mouseX, mouseY);
    }
  }
  redraw();
}

void keyPressed() {
  switch (key) {
    case '1': 
      currentMode = Contants.SOMA;
      break;
    case '2': 
      currentMode = Contants.DENDRITE;
      break;
    case '3': 
      currentMode = Contants.INTERACTION;
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