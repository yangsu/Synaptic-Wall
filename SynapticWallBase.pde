ShapesCollection shapes;

boolean magnify;

int currentMode; // 1 = SOMA, 2 = DENDRITE
Soma currentSoma;
Path currentDendrite;

float scale;
PImage temp;
void setup() {
  size(800, 800);
  temp = createImage(width/2, height/2, ARGB);

  //Settings
  ellipseMode(RADIUS);
  smooth();
  noLoop();
  noStroke();
  cursor(ARROW);
  
  //initialization
  magnify = false;
  currentMode = 1;
  scale = 5.0;
  
  shapes = new ShapesCollection();
  currentSoma = null;
  currentDendrite = null;
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
  if (currentSoma != null)
    currentSoma.draw();
  if (currentDendrite != null)
    currentDendrite.draw();
}
void drawMagnified() {
  pushStyle();
  pushMatrix();
  translate(mouseX, mouseY);
  scale(scale);
  translate(-mouseX, -mouseY);
  fill(100, 180);
  rect(0, 0, width, height);
  drawBackground(color(100, 180));
  drawContent();
  popMatrix();
  
  int tempX = constrain(mouseX-width/4, 0, width);
  int tempY = constrain(mouseY-height/4, 0, height);
  temp = get(tempX, tempY, temp.width, temp.height);
  
  drawBackground(color(100));
  drawContent();  

  image(temp, tempX, tempY);

  noFill();
  stroke(255);
  strokeWeight(5);
  rect(tempX, tempY, temp.width, temp.height);
  popStyle();
}
void draw() {
  if (magnify) {
    drawMagnified();
  }
  else {
    drawBackground(color(100));
    drawContent();    
  }
  
  switch (currentMode) {
    case 1:
      fill(200, 20, 20);
      text("Soma", 0, 20);
      break;
    case 2:
      fill(20, 200, 20);
      text("Dendrite", 0, 20);
      break;
  }
}

void mousePressed() {
  cursor(CROSS);
  boolean selected = shapes.select(mouseX, mouseY);
  if (currentMode == 1) {
    if (selected) {
        shapes.onMouseDown(mouseX, mouseY);
    }
    else {
      currentSoma = new Soma(mouseX, mouseY, random(20, 30), 
                    color(random(50, 205), random(50, 205), random(50, 205)));
    }
  }
  Shape selectedShape = shapes.getSelected();
  if (currentMode == 2 && selectedShape != null) {
    currentDendrite = new Path();
    currentDendrite.addFirst(selectedShape.x(), selectedShape.y());
  }
  redraw();
}
void mouseDragged() {
  if (currentMode == 1) {
    if (currentSoma != null) {      
      currentSoma.setXY(mouseX, mouseY);
    }
    else {
      shapes.onMouseDragged(mouseX, mouseY);
    }
  }
  if (currentMode == 2 && shapes.getSelected() != null) {
    currentDendrite.add(mouseX, mouseY);
  }
  redraw();
}
void mouseMoved() {
  if (mouseButton == RIGHT && shapes.onMouseMoved(mouseX, mouseY)) {
    
  }
  else {
    if(magnify) 
      redraw();
  }
}
void mouseReleased() {
  cursor(ARROW);
  if (currentMode == 1) {
    if (currentSoma != null) {
      shapes.add(currentSoma);
      currentSoma = null;        
    }
    else {
      shapes.onMouseUp(mouseX, mouseY);
    }
  }
  if (currentMode == 2) {
    if (currentDendrite != null) {
      currentDendrite.reduce(20);
      Soma selected = (Soma)shapes.getSelected();
      if (selected != null) {      
        selected.addDendrite(currentDendrite);
      }
      currentDendrite = null;
    }
  }
  redraw();
}

void keyPressed() {
  if (shapes.onKeyDown(key, keyCode)) {
    
  }
  else {
    if (key == '1')
      currentMode = 1;
    if (key == '2')
      currentMode = 2;
    if (key == 'm')
      magnify = !magnify;    
  }

  redraw();
}
void keyReleased() {
  if (shapes.onKeyUp(key, keyCode)) {
    
  }
  redraw();
}