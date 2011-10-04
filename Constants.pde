static class Contants {
  // Modes
  static final int SOMA = 0;
  static final int SYNAPSE = 1;
  static final int DENDRITE = 2;
  static final int INTERACTION = 3;

  // Global Settings
  static final color BG_COLOR = 0xFF000000;
  static final color FADE_COLOR = 0xB4646464;
  static final float ZOOM_FACTOR = 4.0;
  
  // Soma Settings
  static final float SOMA_MAX_THRESHOLD = 10.0;
  static final float SOMA_AP_DECAY = 0.95;
  
  // Signals Settings
  static final int EPSP = 1;
  static final int IPSP = -1;
  static final int AP = 0;
  static final float SIGNAL_CONTROL_LENGTH = 3.0;
  static final int SIGNAL_WIDTH = 3;
  static final float SIGNAL_MULTIPLIER = 2.0;
}