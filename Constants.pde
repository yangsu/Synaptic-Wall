static class Constants {
  static final int DBL_CLICK_THRESHOLD = 300;


  // Modes
  static final int CREATION    = 0;
  static final int DELETION    = 1;
  static final int INTERACTION = 2;

  // Types
  static final int INITIATOR = 0;
  static final int SOMA      = 1;
  static final int AXON      = 2;
  static final int DENDRITE  = 3;
  static final int SYNAPSE   = 4;
  static final int SIGNAL    = 5;
  static final int CONTROL   = 5;

  // Global Settings
  static final color BG_COLOR           = 0xFF4C4C4C;
  static final color FADE_COLOR         = 0xB4646464;
  static final color EX_COLOR           = 0xFFB08B47;
  static final color EX_HIGHLIGHT_COLOR = 0xFFD2C277;
  static final color IN_COLOR           = 0xFF0A6891;
  static final color IN_HIGHLIGHT_COLOR = 0xFF67A4D0;
  static final color HIGHLIGHT_COLOR    = 0xBBFFFFFF;

  static final float ZOOM_FACTOR        = 4.0;
  static final int   SIGNAL_RESOLUTION  = 1;

  static final int  CELL_TIMING = 500;
  // Initiator Settings
  static final int  INITIATOR_SIZE = 40;

  // Soma Settings
  static final int   SOMA_SIZE              = 30;
  static final float SOMA_RING_WIDTH        = 8.0;
  static final float SOMA_DEFAULT_THRESHOLD = 5.0;
  static final float SOMA_MAX_THRESHOLD     = 10.0;

  // Dendrite Settings
  static final float DENDRITE_WIDTH = 8.0;

  // Axon Settings
  static final float AXON_WIDTH     = 8.0;

  // Synapse Settings
  static final color SYNAPSE_ACTIVATION_COLOR = 0xFF000000;
  static final int SYNAPSE_TIMING             = 700; // Miliseconds
  static final float SYNAPSE_SIZE             = 20.0; // radius
  static final float SYNAPSE_DEFAULT_STRENGTH = 5.0;

  // Signals Settings
  static final int    EPSP  = 1;
  static final int    IPSP  = -1;
  static final int    AP    = 0;
  static final int    EPSP_COLOR = 0xFFFEFB98;
  static final int    IPSP_COLOR = 0xFF66A3CF;
  static final int    SIGNAL_DEFAULT_SPEED    = 1;
  static final int    SIGNAL_DEFAULT_LENGTH   = 15;
  static final float  SIGNAL_DEFAULT_STRENGTH = 4;
  static final int    SIGNAL_MAX_SPEED        = 5;
  static final int    SIGNAL_MAX_LENGTH       = 20;
  static final float  SIGNAL_MAX_STRENGTH     = 8.0;

  static final float SIGNAL_CONTROL_LENGTH = 3.0;
  static final float SIGNAL_WIDTH          = 8.0;
  static final float SIGNAL_BORDER_WIDTH   = 2.0;
  static final float SIGNAL_MULTIPLIER     = 2.0;

  static final int AP_STROKE_WEIGHT = 2;
  // Initiator Settings
  static final float DEFAULT_RHYTHMICITY = 1.0;
  static final int   DEFAULT_BURSTINESS  = 1; // per firing
  static final float DEFAULT_FREQUENCY   = 0.5; // Hz
  static final float MAX_RHYTHMICITY     = 1.0;
  static final int   MAX_BURSTINESS      = 5; // per firing
  static final float MAX_FREQUENCY       = 3.0; // Hz
  static final int   BURST_DELAY         = 10;

  // Slider Settings
  static final color SLIDER_BG_COLOR        = 0x64FFFFFF;
  static final color SLIDER_BAR_COLOR       = 0xFFCCCCCC;
  static final color SLIDER_HANDLE_COLOR    = BG_COLOR;
  static final float SLIDER_BAR_WIDTH       = 7.5;
  static final float SLIDER_BAR_LENGTH      = 0.1;
  static final float SLIDER_HANDLE_WIDTH    = 0.03;
  static final float THRESHOLD_HANDLE_WIDTH = 0.15;

}