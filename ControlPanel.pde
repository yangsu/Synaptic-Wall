final int SCALEID = 0;
final int ZOOMID = 1;
public class ControlPanel extends Collection {
  EventReceiver fEvents;
  Soma fSoma;
  ControllerSynapse fSynapse;
  Slider fScale, fZoom;
  ObjectCollection fObjCollection;

  public ControlPanel (ObjectCollection objs) {
    fObjCollection = objs;
    fEvents = new EventReceiver();

    // Initiate Control Panel
    fSoma = new ControllerSoma(
      0.8 * width,
      0.8 * height
    );
    fSoma.setVisible(false);
    fSoma.setMovable(false);
    fSoma.showControls();
    fObjs.add(fSoma);

    fSynapse = new ControllerSynapse(
      0.8 * width,
      0.6 * height
    );
    fSynapse.setVisible(false);
    fSynapse.setMovable(false);
    fSynapse.showControls();
    fObjs.add(fSynapse);

    fScale = new LinearSlider(
      0.75 * width,
      0.1 * height,
      150f,
      SCALE, 1f, MAX_SCALE,
      SCALEID, fEvents
    );
    fScale.setLabel("Scale");
    fScale.setVisible(false);
    fScale.setMovable(false);
    fObjs.add(fScale);

    fZoom = new LinearSlider(
      0.75 * width,
      0.05 * height,
      150f,
      ZOOM_FACTOR, 1f, MAX_ZOOM,
      ZOOMID, fEvents
    );
    fZoom.setLabel("Zoom");
    fZoom.setVisible(false);
    fZoom.setMovable(false);
    fObjs.add(fZoom);
  }

  public int getType() {
    return -1;
  }

  // private void syncAttributes(Interactive curr) {
  //   for (Interactive s : fSelectedObjs) {
  //     if (curr != s && curr.getType() == s.getType()) {
  //       if (curr.getType() == SOMA || curr.getType() == INITIATOR) {
  //         ((Cell)s).copyAttributes((Cell)curr);
  //       }
  //     }
  //   }
  // }
}

public class EventReceiver implements Controllable {
  public EventReceiver() {}
  public void drawControls() {}
  public void showControls() {}
  public void hideControls() {}
  public void onEvent(int controlID, float value) {
    switch (controlID) {
      case SCALEID:
        Constants.SCALE = value;
        Constants.recalculate();
        break;
      case ZOOMID:
        Constants.ZOOM_FACTOR = value;
        break;
    }
  }
}
