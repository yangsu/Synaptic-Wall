static class Constants {
  // Modes
  static final int SOMA        = 0;
  static final int SYNAPSE     = 1;
  static final int DENDRITE    = 2;
  static final int INTERACTION = 3;

  // Global Settings
  static final color BG_COLOR           = 0xFF000000;
  static final color FADE_COLOR         = 0xB4646464;
  static final color EX_COLOR           = 0xFFB08B47;
  static final color EX_HIGHLIGHT_COLOR = 0xFFC2A268;
  static final color IN_COLOR           = 0xFF0C6891;
  static final color IN_HIGHLIGHT_COLOR = 0xFF108AC0;
  static final color HIGHLIGHT_COLOR    = 0xFFFFFFFF;

  static final float ZOOM_FACTOR        = 4.0;
  static final int   SIGNAL_RESOLUTION  = 1;
  
  // Soma Settings
  static final float SOMA_RING_WIDTH    = 8.0;
  static final float SOMA_MAX_THRESHOLD = 10.0;
  
  static final float DENDRITE_WIDTH = 3.0;
  static final float AXON_WIDTH     = 3.0;
  
  // Signals Settings
  static final int    EPSP  = 1;
  static final int    IPSP  = -1;
  static final int    AP    = 0;
  static final int    SIGNAL_DEFAULT_SPEED    = 1;
  static final int    SIGNAL_DEFAULT_LENGTH   = 1;
  static final float  SIGNAL_DEFAULT_STRENGTH = 4;
  static final int    SIGNAL_MAX_SPEED        = 5;
  static final int    SIGNAL_MAX_LENGTH       = 5;
  static final float  SIGNAL_MAX_STRENGTH     = 8.0;
  
  static final float SIGNAL_CONTROL_LENGTH = 3.0;
  static final float SIGNAL_WIDTH          = 5.0;
  static final float SIGNAL_MULTIPLIER     = 2.0;

  // Initiator Settings
  static final float MAX_RHYTHMICITY = 1.0;
  static final int   MAX_BURSTINESS  = 5; // per firing
  static final float MAX_FREQUENCY   = 5.0; // Hz
  static final int   BURST_DELAY     = 5;

  // Slider Settings
  static final color SLIDER_BG_COLOR        = 0x64FFFFFF;
  static final color SLIDER_BAR_COLOR       = 0xFFCCCCCC;
  static final color SLIDER_HANDLE_COLOR    = 0xFF000000;
  static final float SLIDER_BAR_WIDTH       = 7.5;
  static final float SLIDER_BAR_LENGTH      = 0.1;
  static final float SLIDER_HANDLE_WIDTH    = 0.03;
  static final float THRESHOLD_HANDLE_WIDTH = 0.15;
  
}