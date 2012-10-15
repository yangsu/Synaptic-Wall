public class SynapticWall extends Constants {

  private boolean gMagnify;
  private int gCurrentMode;
  private String gCurrentModeLabel;
  private PImage gMagnified;

  private Selector gSelector;
  private ObjectCollection gObjs;
  private ControlPanel gCPanel;

  private Interactive gLastSelected;
  private Initiator gCurrInitiator;
  private Soma gCurrShape;
  private Path gCurrPath;
  private PVector gIndicator;
  private PVector gIndicator2;

  public SynapticWall() {
    gCurrentMode = CREATION;
    gCurrentModeLabel = "CREATION";
    gMagnify = false;
    gMagnified = createImage(HALFWIDTH, HALFHEIGHT, ARGB);

    gSelector = new Selector();
    gObjs = new ObjectCollection();
    gCPanel = new ControlPanel(gObjs);

    gCurrShape = null;
    gCurrPath = null;
    gIndicator = new PVector(MIN, MIN);
    gIndicator2 = new PVector(MIN, MIN);
    gLastSelected = null;
    gCurrInitiator = null;
  }

  private void snapIndicators(float x, float y, float size) {
    float angle = Util.getAngleNorm(x, y, mouseX, mouseY);
    float tloc = size-SOMA_RING_WIDTH/2;
    gIndicator.set(cos(angle)*tloc+x, sin(angle)*tloc+y, 0);
  }
  private void clearIndicators() {
    gIndicator.set(MIN, MIN, 0);
    gIndicator2.set(MIN, MIN, 0);
  }

  private void drawBackground(color cc) {
    pushStyle();
      noStroke();
      fill(cc);
      rect(0, 0, width, height);
      gGrid.draw();
    popStyle();
  }

  private void drawAndUpdateContent() {
    drawBackground(BG_COLOR);
    gObjs.drawAndUpdate();
    gCPanel.draw();
    if (gCurrShape != null)
      gCurrShape.drawAndUpdate();
    if (gCurrPath != null)
      gCurrPath.drawAndUpdate();
    if (gCurrInitiator != null && gCurrInitiator.fMovable)
      gCurrInitiator.drawAndUpdate();
  }

  private void drawContent() {
    drawBackground(BG_COLOR);
    gObjs.draw();
    gCPanel.draw();
    if (gCurrShape != null)
      gCurrShape.draw();
    if (gCurrPath != null)
      gCurrPath.draw();
    if (gCurrInitiator != null && gCurrInitiator.fMovable)
      gCurrInitiator.draw();
  }

  private void drawMagnified() {
    pushStyle();
      pushMatrix();
        translate(mouseX, mouseY);
        scale(ZOOM_FACTOR);
        translate(-mouseX, -mouseY);
        fill(FADE_COLOR);
        rect(0, 0, width, height);
        drawContent();
      popMatrix();
      int magnifiedX = constrain(mouseX-QUARTERWIDTH, 0, HALFWIDTH);
      int magnifiedY = constrain(mouseY-QUARTERHEIGHT, 0, HALFHEIGHT);
      gMagnified = get(magnifiedX, magnifiedY, HALFWIDTH, HALFHEIGHT);

      drawContent();

      image(gMagnified, magnifiedX, magnifiedY);

      noFill();
      stroke(255);
      strokeWeight(5);
      rect(magnifiedX, magnifiedY, HALFWIDTH, HALFHEIGHT);

    popStyle();
  }

  public void draw() {
    if (gMagnify)
      drawMagnified();
    else
      drawAndUpdateContent();

    gSelector.draw();

    pushStyle();
      fill(255);
      float s = PATH_JUNCTION_WIDTH;
      ellipse(gIndicator.x, gIndicator.y, s, s);
      ellipse(gIndicator2.x, gIndicator2.y, s, s);

      text(gCurrentModeLabel, 0, 20);
      String fps = nf(frameRate, 2, 2) + " FPS";
      text(fps, width - 60, 20);
    popStyle();
  }

  private void clear() {
    gObjs.reset();
    gCurrShape = null;
    gCurrPath = null;
    gCurrInitiator = null;
    clearIndicators();
  }

  public void onDblClick() {
    if (gCurrentMode == INTERACTION) {
      gObjs.onDblClick(mouseX, mouseY);
    }
  }

  public void onMousePressed() {
    gGrid.onMouseDown(mouseX, mouseY);
    cursor(CROSS);
    Interactive selected = null;
    if (gCurrentMode == CREATION) {
      if (gObjs.select(mouseX, mouseY)) {
        selected = gObjs.getSelected().get(0);
        gLastSelected = selected;
        // If selected is the gCurrInitiator, then create axon
        if (selected.getType() == INITIATOR ||
            selected.getType() == SOMA) {
          Cell c = (Cell)selected;
          snapIndicators(c.x(), c.y(), c.fSize);
        }
        // if selected is a dendrite or an axon
        else if (selected.getType() == AXON) {
          Path p = (Path)selected;
          gIndicator.set(p.getCurrVertex());
          gCurrPath = new Axon(p, gIndicator.x, gIndicator.y, p.fColor);
        }
        else if (selected.getType() == DENDRITE) {
          Path p = (Path)selected;
          gIndicator.set(p.getCurrVertex());
          gCurrPath = new Dendrite(p, gIndicator.x, gIndicator.y, p.fColor);
        }
        // if selected is a synapse, the create an dendrite
        else if (selected.getType() == SYNAPSE) {
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
            SOMA_SIZE,
            EX_COLOR
          );
        else if (mouseButton == LEFT)
          gCurrShape = new Soma(pos.x, pos.y);
      }
    }
    else if (gCurrentMode == DELETION) {
      if (gObjs.select(mouseX, mouseY)) {
        selected = gObjs.getSelected().get(0);
        gObjs.remove(selected);
      }
    }
    else if (gCurrentMode == INTERACTION) {
      if (!gObjs.onMouseDown(mouseX, mouseY, key, keyCode) && !gCPanel.onMouseDown(mouseX, mouseY)) {
        gSelector.beginSelection(mouseX, mouseY);
      }
    }
    else {
      // Do nothing
    }
    redraw();
  }

  public void onMouseDragged() {
    gGrid.onMouseDragged(mouseX, mouseY);

    if (gCurrentMode == CREATION) {
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
          if (selected.getType() == INITIATOR ||
              selected.getType() == SOMA) {
            if (gCurrPath != null) {
              gCurrPath.close();
            }
          }
          else if (selected.getType() == DENDRITE ||
                   selected.getType() == AXON) {
            // Show Indicator
            PVector end = ((Path)selected).getCurrVertex();
            gIndicator2.set(end.x, end.y, 0);
          }
          gLastSelected = selected;
        }
        else { // If not different from the last
          // If still in the gCurrInitiator or the last selected soma
          if (selected.getType() == INITIATOR ||
              selected.getType() == SOMA ||
              selected.getType() == SYNAPSE) {
            Shape s = (Shape)selected;
            snapIndicators(s.x(), s.y(), s.fSize);
          }
        }
      }
      else { // if not selected anything
        if (gLastSelected != null && gCurrPath == null) {
          if (gLastSelected.getType() == INITIATOR ||
              gLastSelected.getType() == SOMA) {
            Cell c = (Cell)gLastSelected;
            gCurrPath = new Axon(c, gIndicator.x, gIndicator.y, c.fHighlightColor);
          }
          else if (gLastSelected.getType() == SYNAPSE) {
            Synapse s = (Synapse)gLastSelected;
            if (!s.isComplete()) {
              color c = (s.fColor == EX_HIGHLIGHT_COLOR) ? EX_COLOR : IN_COLOR;
              gCurrPath = new Dendrite(s, s.x(), s.y(), c);
              gCurrPath.add(gIndicator.x, gIndicator.y);
            }
          }
        }
      }
    }
    else if (gCurrentMode == INTERACTION) {
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

  public void onMouseMoved() {
    gGrid.onMouseMoved(mouseX, mouseY);
    if (gCurrentMode == INTERACTION || gMagnify) {
    }
    gObjs.onMouseMoved(mouseX, mouseY);
    gCPanel.onMouseMoved(mouseX, mouseY);
    redraw();
  }

  public void onMouseReleased() {
    gGrid.onMouseUp(mouseX, mouseY);
    cursor(ARROW);
    if (gCurrentMode == CREATION) {
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
          if (gCurrPath.getType() == AXON) {
            // Calculate offset so the edge of the Synapse is at the end of the path
            PVector last = gCurrPath.getVertex(l-1);
            PVector diff = PVector.sub(last, gCurrPath.getVertex(l-2));
            diff.normalize();
            PVector center = PVector.add(last, PVector.mult(diff, SYNAPSE_OUTER_SIZE));
            Synapse s = new Synapse(gCurrPath, center.x, center.y, gCurrPath.fColor);
            gCurrPath.setDest(s);
            gCurrPath.attachToSource();
            gCurrPath.simplify();
            gObjs.add(gCurrPath);
            gObjs.add(s);
          }
          else if (gCurrPath.getType() == DENDRITE) {
            Interactive selected = null;
            PVector gridPoint = gGrid.getCurrent();
            if (gObjs.select(mouseX, mouseY) ||
                gObjs.select(gridPoint.x, gridPoint.y)) {

              selected = gObjs.getSelected().get(0);
              if (selected.getType() == SOMA) {
                Cell c = (Cell)selected;
                // Add the indicator point to the path
                snapIndicators(c.x(), c.y(), c.fSize);
                gCurrPath.add(gIndicator.x, gIndicator.y);
                gCurrPath.setDest(c);
                c.addPath(gCurrPath);
              }
              else if ((selected.getType() == DENDRITE ||
                        selected.getType() == AXON) &&
                        selected != gCurrPath) {
                //add end to end?
                Path p = (Path)selected;
                PVector end = p.getCurrVertex();
                gIndicator2.set(end.x, end.y, 0);
                gCurrPath.setDest(p);
              }
              if (selected.getType() != INITIATOR &&
                  selected.getType() != SYNAPSE) {
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
    else if (gCurrentMode == INTERACTION) {
      if (gSelector.isSelecting()) {
        gSelector.endSelection(mouseX, mouseY);
        gObjs.selectArea(gSelector.getStart(), gSelector.getEnd());
      }
      gObjs.onMouseUp(mouseX, mouseY);
      gCPanel.onMouseUp(mouseX, mouseY);
    }

    redraw();
  }

  public void onKeyPressed() {
    switch (key) {
      case '1':
        gCurrentMode = CREATION;
        gCurrentModeLabel = "CREATION";
        break;
      case '2':
        gCurrentMode = DELETION;
        gCurrentModeLabel = "DELETION";
        break;
      case '3':
        gCurrentMode = INTERACTION;
        gCurrentModeLabel = "INTERACTION";
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
}