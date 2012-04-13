
static class Constants {
  static final int MAX = 99999;

  static final int WIDTH  = 800;
  static final int HEIGHT = 800;

  static final float SCALE = 1.0;

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
  static final int CONTROL   = 6;
  static final int GRID      = 7;
  static final int GEOPATH   = 8;

  // Global Settings
  static final color BG_COLOR           = 0xFF4C4C4C;
  static final color FADE_COLOR         = 0xB4646464;
  static final color EX_COLOR           = 0xFFB08B47;
  static final color EX_HIGHLIGHT_COLOR = 0xFFFDFB98;
  static final color IN_COLOR           = 0xFF0A6891;
  static final color IN_HIGHLIGHT_COLOR = 0xFF67A4D0;
  static final color HIGHLIGHT_COLOR    = 0xBBFFFFFF;

  static final color SHADOW_COLOR   = 0xBB323232;
  static final float SHADOW_OFFSETX = 3/SCALE;
  static final float SHADOW_OFFSETY = 3/SCALE;

  static final float ZOOM_FACTOR        = 4.0;
  static final int   SIGNAL_RESOLUTION  = 1;

  static final int  CELL_TIMING = 500;
  // Initiator Settings

  // Soma Settings
  static final int   EXCITATORY = 0;
  static final int   INHIBITORY = 1;
  static final int   SOMA_SIZE               = 30 / (int)SCALE;
  static final int   SOMA_FIRING_DELAY       = 300;
  static final float SOMA_RING_WIDTH         = 10.0 / SCALE;
  static final float SOMA_DEFAULT_THRESHOLD  = 5.0;
  static final float SOMA_MAX_THRESHOLD      = 10.0;
  static final float SOMA_INIT_POS_THRESHOLD = 7.5;
  static final float SOMA_INIT_NEG_THRESHOLD = -7.5;

  // Path Settings
  static final float PATH_WIDTH = 8.0 / SCALE;

  // Synapse Settings
  static final color SYNAPSE_ACTIVATION_COLOR = 0xFF000000;
  static final int   SYNAPSE_TIMING           = 700; // Miliseconds
  static final float SYNAPSE_SIZE             = 12.0 / SCALE; // radius
  static final float SYNAPSE_STRENGTH         = 1.0; // Thickness
  static final float SYNAPSE_MULT             = 2.0;
  static final float SYNAPSE_BASE             = 2.0;
  static final float SYNAPSE_OUTER_SIZE       = (SYNAPSE_SIZE + SYNAPSE_STRENGTH*SYNAPSE_MULT + SYNAPSE_BASE) / SCALE;

  // Signals Settings
  static final int   EPSP  = 1;
  static final int   IPSP  = -1;
  static final int   AP    = 0;
  static final int   EPSP_COLOR = 0xFFD2C277;
  static final int   IPSP_COLOR = 0xFF67A4D0;
  static final int   AP_COLOR = 0xFFFDFB98;

  static final boolean SIGNAL_LINEAR_DECAY = true;
  static final int   SIGNAL_DEFAULT_SPEED  = 1;
  static final int   SIGNAL_DEFAULT_LENGTH = 20/SIGNAL_RESOLUTION;
  static final float SIGNAL_DEFAULT_DECAY  = 1.0; // No decay
  static final int   SIGNAL_MAX_SPEED      = 5;
  static final int   SIGNAL_MAX_LENGTH     = 30/SIGNAL_RESOLUTION;
  static final float SIGNAL_MAX_DECAY      = 0.1; // Halves

  static final float AP_WIDTH        = 4.0 / SCALE;
  static final float AP_BORDER_WIDTH = 3.0 / SCALE;

  static final float PSP_WIDTH        = 6.0 / SCALE;
  static final float PSP_BORDER_WIDTH = 6.0 / SCALE;

  static final float SIGNAL_STRENGTH       = 5.0;
  static final float SIGNAL_CONTROL_LENGTH = 3.0;
  static final float SIGNAL_WIDTH          = 8.0 / SCALE;
  static final float SIGNAL_DEFAULT_WIDTH  = SIGNAL_WIDTH/2;
  static final float SIGNAL_BORDER_WIDTH   = 2.0 / SCALE;
  static final float SIGNAL_RANGE_WIDTH    = (PATH_WIDTH - 2*SIGNAL_BORDER_WIDTH) / SCALE;
  static final int   SIGNAL_FIRING_TIME    = 800;

  // Initiator Settings
  static final float DEFAULT_RHYTHMICITY = 1.0;
  static final int   DEFAULT_BURSTINESS  = 1; // per firing
  static final float DEFAULT_FREQUENCY   = 0.5; // Hz
  static final float MAX_RHYTHMICITY     = 1.0;
  static final int   MAX_BURSTINESS      = 5; // per firing
  static final float MAX_FREQUENCY       = 3.0; // Hz
  static final int   BURST_DELAY         = 300;

  // Slider Settings
  static final color SLIDER_BG_COLOR        = 0xFF7F7F7F;
  static final color SLIDER_BAR_COLOR       = 0xFFCCCCCC;
  static final color SLIDER_HANDLE_COLOR    = BG_COLOR;
  static final float SLIDER_BAR_WIDTH       = 7.5 / SCALE;
  static final float SLIDER_BAR_LENGTH      = 0.1 / SCALE;
  static final float SLIDER_HANDLE_WIDTH    = 0.03 / SCALE;
  static final float THRESHOLD_HANDLE_WIDTH = 0.15 / SCALE;
  static final color THRESHOLD_POSITIVE_COLOR     = 0xFFFF6725;
  static final color THRESHOLD_POSITIVE_HIGHLIGHT = 0xFFFF8947;
  static final color THRESHOLD_NEGATIVE_COLOR     = 0xFF00329B;
  static final color THRESHOLD_NEGATIVE_HIGHLIGHT = 0xFF2254BD;

  // Grid Settings
  static final color GRID_NODE_COLOR     = 0xFF666666;
  static final color GRID_NODE_HIGHLIGHT = 0xFFAAAAAA;
  static final float GRID_NODE_SIZE      = 1;
  static final int   GRID_RESOLUTION     = 40;
}